From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: use list_move_tail instead of
 list_del/list_add_tail
Date: Wed, 05 Sep 2012 17:30:24 -0700
Message-ID: <1346891424.4162.316.camel@haakon2.linux-iscsi.org>
References: <CAPgLHd9tGyUzBdbNzorncaa57RFD-YO06tz3UCffuXXxgLDdyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAPgLHd9tGyUzBdbNzorncaa57RFD-YO06tz3UCffuXXxgLDdyg@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: bootc@bootc.net, yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-09-05 at 14:42 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using list_move_tail() instead of list_del() + list_add_tail().
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/target/sbp/sbp_target.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
> index 39ddba5..e57971f 100644
> --- a/drivers/target/sbp/sbp_target.c
> +++ b/drivers/target/sbp/sbp_target.c
> @@ -660,8 +660,7 @@ static void session_reconnect_expired(struct sbp_session *sess)
>  	spin_lock_bh(&sess->lock);
>  	list_for_each_entry_safe(login, temp, &sess->login_list, link) {
>  		login->sess = NULL;
> -		list_del(&login->link);
> -		list_add_tail(&login->link, &login_list);
> +		list_move_tail(&login->link, &login_list);
>  	}
>  	spin_unlock_bh(&sess->lock);
>  
> 
> 
> --

Applied to target-pending/for-next.

Thanks Wei!

--nab
