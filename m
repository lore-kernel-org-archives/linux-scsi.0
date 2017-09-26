From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: continue to boot even with Boot LUN is
 disabled
Date: Tue, 26 Sep 2017 14:33:00 -0700
Message-ID: <0a25b85dc02e33bc2f33661ddb2a9629@codeaurora.org>
References: <1506076307-8462-1-git-send-email-kehuanlin@pinecone.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39420 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967113AbdIZVdB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2017 17:33:01 -0400
In-Reply-To: <1506076307-8462-1-git-send-email-kehuanlin@pinecone.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Huanlin Ke <chgokhl@gmail.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kehuanlin@pinecone.net, linux-scsi-owner@vger.kernel.org

On 2017-09-22 03:31, Huanlin Ke wrote:
> Several configurable fields of the Device Descriptor and the Unit
> Descriptors determine the Boot LUN status. The bBootEnable field and
> the bBootLunEn attribute is set to zero by default, so the Boot LUN is
> disabled by default.
> 
> At which point the scsi device add for Boot LUN will fail, but we can
> continue to use the ufs device in fact. This failure shouldn't abort 
> the
> device boot.
> 
> Signed-off-by: Huanlin Ke <kehuanlin@pinecone.net>
> ---
>  drivers/scsi/ufs/ufshcd.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 794a460..bff84be 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5998,25 +5998,22 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba 
> *hba)
>  	}
>  	scsi_device_put(hba->sdev_ufs_device);
> 
> -	sdev_boot = __scsi_add_device(hba->host, 0, 0,
> -		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_BOOT_WLUN), NULL);
> -	if (IS_ERR(sdev_boot)) {
> -		ret = PTR_ERR(sdev_boot);
> -		goto remove_sdev_ufs_device;
> -	}
> -	scsi_device_put(sdev_boot);
> -
>  	sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
>  		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);
>  	if (IS_ERR(sdev_rpmb)) {
>  		ret = PTR_ERR(sdev_rpmb);
> -		goto remove_sdev_boot;
> +		goto remove_sdev_ufs_device;
>  	}
>  	scsi_device_put(sdev_rpmb);
> +
> +	sdev_boot = __scsi_add_device(hba->host, 0, 0,
> +		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_BOOT_WLUN), NULL);
> +	if (IS_ERR(sdev_boot))
> +		dev_err(hba->dev, "%s: BOOT WLUN not found\n", __func__);
> +	else
> +		scsi_device_put(sdev_boot);
>  	goto out;
> 
> -remove_sdev_boot:
> -	scsi_remove_device(sdev_boot);
>  remove_sdev_ufs_device:
>  	scsi_remove_device(hba->sdev_ufs_device);
>  out:

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
