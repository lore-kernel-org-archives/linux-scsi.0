From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsit: use GFP_ATOMIC under spin lock
Date: Tue, 27 Nov 2012 18:53:51 -0800
Message-ID: <1354071231.18736.100.camel@haakon2.linux-iscsi.org>
References: <CAPgLHd9ZPyLugr5mS0NHpm8kiv6a6e9maTY4cuVbO=+CtCf1NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAPgLHd9ZPyLugr5mS0NHpm8kiv6a6e9maTY4cuVbO=+CtCf1NQ@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Wei,

On Fri, 2012-11-23 at 12:07 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> The function iscsit_build_conn_drop_async_message() is called
> from iscsit_close_connection() with spin lock 'sess->conn_lock'
> held, so we should use GFP_ATOMIC instead of GFP_KERNEL.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---

Nice catch here.  Applied to target-pending/for-next, and including a CC
to stable.

Thank you!

--nab

>  drivers/target/iscsi/iscsi_target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 035c2c7..3983ad3 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -2360,7 +2360,7 @@ static void iscsit_build_conn_drop_async_message(struct iscsi_conn *conn)
>  	if (!conn_p)
>  		return;
>  
> -	cmd = iscsit_allocate_cmd(conn_p, GFP_KERNEL);
> +	cmd = iscsit_allocate_cmd(conn_p, GFP_ATOMIC);
>  	if (!cmd) {
>  		iscsit_dec_conn_usage_count(conn_p);
>  		return;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
