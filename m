From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target/pscsi: fix return value check
Date: Fri, 25 Oct 2013 11:36:26 -0700
Message-ID: <1382726186.19256.715.camel@haakon3.risingtidesystems.com>
References: <CAPgLHd9hx7fOqn5QJoxqbmnV5ueKasX_QNbSyzKBrYGKq3Hj-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34368 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab3JYS1V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2013 14:27:21 -0400
In-Reply-To: <CAPgLHd9hx7fOqn5QJoxqbmnV5ueKasX_QNbSyzKBrYGKq3Hj-w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Hi Wei,

On Fri, 2013-10-25 at 21:53 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function scsi_host_lookup() returns NULL
> pointer not ERR_PTR(). The IS_ERR() test in the return value check
> should be replaced with NULL test.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---

Applied to target-pending/master with a CC' to stable, and including in
the next -rc7 PULL request.

Thank you!

--nab

>  drivers/target/target_core_pscsi.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 551c96c..0f199f6 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -134,10 +134,10 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
>  	 * pSCSI Host ID and enable for phba mode
>  	 */
>  	sh = scsi_host_lookup(phv->phv_host_id);
> -	if (IS_ERR(sh)) {
> +	if (!sh) {
>  		pr_err("pSCSI: Unable to locate SCSI Host for"
>  			" phv_host_id: %d\n", phv->phv_host_id);
> -		return PTR_ERR(sh);
> +		return -EINVAL;
>  	}
>  
>  	phv->phv_lld_host = sh;
> @@ -515,10 +515,10 @@ static int pscsi_configure_device(struct se_device *dev)
>  			sh = phv->phv_lld_host;
>  		} else {
>  			sh = scsi_host_lookup(pdv->pdv_host_id);
> -			if (IS_ERR(sh)) {
> +			if (!sh) {
>  				pr_err("pSCSI: Unable to locate"
>  					" pdv_host_id: %d\n", pdv->pdv_host_id);
> -				return PTR_ERR(sh);
> +				return -EINVAL;
>  			}
>  		}
>  	} else {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


