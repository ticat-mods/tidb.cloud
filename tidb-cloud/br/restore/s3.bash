set -euo pipefail
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/./../../../helper/helper.bash"
env=`cat "${1}/env"`

host=`must_env_val "${env}" 'mysql.host'`
port=`must_env_val "${env}" 'mysql.port'`
user=`must_env_val "${env}" 'mysql.user'`
pp=`must_env_val "${env}" 'mysql.pwd'`

bucket_name=`must_env_val "${env}" 's3.bucket.name'`
bucket_path=`must_env_val "${env}" 's3.bucket.path'`
access_key=`must_env_val "${env}" 's3.auth.access-key'`
secret_key=`must_env_val "${env}" 's3.auth.secret-key'`
token=`must_env_val "${env}" 's3.auth.session-token'`

concurrency=`must_env_val "${env}" 'tidb.br.concurrency'`

s3_path="s3://${bucket_name}/${bucket_path}/?access-key=${access_key}&secret-access-key=${secret_key}&session-token=${token}"
query="RESTORE DATABASE * FROM '${s3_path}' SEND_CREDENTIALS_TO_TIKV=FALSE CONCURRENCY=${concurrency}"

MYSQL_PWD="${pp}" mysql -h "${host}" -P "${port}" -u "${user}" -e "${query}"
