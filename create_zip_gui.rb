require 'tk'
require 'zip'
require 'fileutils'

Tk.root.title('パスワードZip作成')

TkLabel.new(nil,
  text: '圧縮するフォルダを指定してください',
  fg: 'black',
  bg: 'white'
).pack

target_dir_path = TkVariable.new('')
TkEntry.new(
  nil,
  textvariable: target_dir_path
).pack

b1 = TkButton.new(
  text: 'フォルダ選択'
).pack(fill: 'x')

TkLabel.new(nil,
  text: 'Zipファイルを保護するパスワードを設定してください',
  fg: 'black',
  bg: 'white'
).pack

input_password = TkVariable.new('')
TkEntry.new(
  nil,
  textvariable: input_password
).pack

b1.command{
  target_dir_path.value = Tk.chooseDirectory({title: 'フォルダ選択'})
}

b2 = TkButton.new(
  text: '実行',
  command: proc{
    target_dir_path = target_dir_path.to_s
    target_dir = target_dir_path.split("/").last
    zip_file_name = target_dir + ".zip"

    files = Dir.glob(target_dir_path + "/*")

    password = Zip::TraditionalEncrypter.new(input_password.to_s)

    # 作成するzipファイルのパスを引数に指定
    Zip::OutputStream.open(zip_file_name, password) do |out|

      files.each do |file|

        # zipファイル内に書き込むファイルのパスを指定
        file_name = File.basename(file)
        out.put_next_entry(target_dir + "/" + file_name)

        # # zipファイルへ文字列を書き込む
        out.write(File.read(file))
      end

      FileUtils.mv(zip_file_name,File::dirname(target_dir_path))
    end
    Tk.messageBox(message: zip_file_name + 'を作成しました')
  }
).pack(fill: 'x')

Tk.mainloop
