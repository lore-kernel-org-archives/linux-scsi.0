From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcm_fc: using kfree_rcu() to simplify the code
Date: Mon, 18 Mar 2013 13:24:21 -0700
Message-ID: <1363638261.3156.0.camel@haakon2.linux-iscsi.org>
References: <CAPgLHd9BaUSZf4PmF9UMn8c5CEJXEq9taNtYme5RV6COBztqAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAPgLHd9BaUSZf4PmF9UMn8c5CEJXEq9taNtYme5RV6COBztqAA@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mark.d.rustad@intel.com, bprakash@broadcom.com, sasha.levin@oracle.com, akpm@linux-foundation.org, yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Wei,

On Mon, 2013-03-11 at 21:48 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> The callback function of call_rcu() just calls a kfree(), so we
> can use kfree_rcu() instead of call_rcu() + callback function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---

Apologies for the delay.

Applied to target-pending/for-next.

Thanks!

--nab

>  drivers/target/tcm_fc/tfc_sess.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
> index 113f335..4859505 100644
> --- a/drivers/target/tcm_fc/tfc_sess.c
> +++ b/drivers/target/tcm_fc/tfc_sess.c
> @@ -428,19 +428,12 @@ static int ft_prli(struct fc_rport_priv *rdata, u32 spp_len,
>  	return ret;
>  }
>  
> -static void ft_sess_rcu_free(struct rcu_head *rcu)
> -{
> -	struct ft_sess *sess = container_of(rcu, struct ft_sess, rcu);
> -
> -	kfree(sess);
> -}
> -
>  static void ft_sess_free(struct kref *kref)
>  {
>  	struct ft_sess *sess = container_of(kref, struct ft_sess, kref);
>  
>  	transport_deregister_session(sess->se_sess);
> -	call_rcu(&sess->rcu, ft_sess_rcu_free);
> +	kfree_rcu(sess, rcu);
>  }
>  
>  void ft_sess_put(struct ft_sess *sess)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
