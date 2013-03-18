From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH -next] target: fix possible memory leak in
 core_tpg_register()
Date: Mon, 18 Mar 2013 13:25:30 -0700
Message-ID: <1363638330.3156.1.camel@haakon2.linux-iscsi.org>
References: <CAPgLHd-_WeOFu7-FedBnneXwdTkWNBc8iUpypJdtCpCG29h0TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAPgLHd-_WeOFu7-FedBnneXwdTkWNBc8iUpypJdtCpCG29h0TA@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-03-15 at 17:19 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> 'se_tpg->tpg_lun_list' is malloced in core_tpg_register() and should be freed
> before leaving from the error handling cases, otherwise it will cause memory
> leak. 
> 'se_tpg' is malloced out of this function, and will be freed if we return error, so
> remove free for 'se_tpg'.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---

Applied to target-pending/master, and including in the next
v3.9-rc-fixes pull request.

Thanks Wei!

--nab

>  drivers/target/target_core_tpg.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index 9169d6a..aac9d27 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -711,7 +711,8 @@ int core_tpg_register(
>  
>  	if (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL) {
>  		if (core_tpg_setup_virtual_lun0(se_tpg) < 0) {
> -			kfree(se_tpg);
> +			array_free(se_tpg->tpg_lun_list,
> +				   TRANSPORT_MAX_LUNS_PER_TPG);
>  			return -ENOMEM;
>  		}
>  	}
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
