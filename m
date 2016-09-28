From: subhashj@codeaurora.org
Subject: Re: [PATCH -next] scsi: ufs: fix error return code in ufshcd_init()
Date: Wed, 28 Sep 2016 15:49:38 -0700
Message-ID: <ce37f469faab393f53a9896e3b603843@codeaurora.org>
References: <1475074182-13038-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59573 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932539AbcI1Wtl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2016 18:49:41 -0400
In-Reply-To: <1475074182-13038-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

On 2016-09-28 07:49, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 37f3c51..6aebb7e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6500,6 +6500,7 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
>  		if (IS_ERR(hba->devfreq)) {
>  			dev_err(hba->dev, "Unable to register with devfreq %ld\n",
>  					PTR_ERR(hba->devfreq));
> +			err = PTR_ERR(hba->devfreq);
>  			goto out_remove_scsi_host;
>  		}
>  		/* Suspend devfreq until the UFS device is detected */
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
