From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs-qcom: Fix module autoload
Date: Tue, 03 Jan 2017 17:06:31 -0800
Message-ID: <2e6c48e44bf0af257f11c2ca4007c705@codeaurora.org>
References: <1483365898-30166-1-git-send-email-javier@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46442 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753267AbdADBOb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2017 20:14:31 -0500
In-Reply-To: <1483365898-30166-1-git-send-email-javier@osg.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi-owner@vger.kernel.org

On 2017-01-02 06:04, Javier Martinez Canillas wrote:
> If the driver is built as a module, autoload won't work because the 
> module
> alias information is not filled. So user-space can't match the 
> registered
> device with the corresponding module.
> 
> Export the module alias information using the MODULE_DEVICE_TABLE() 
> macro.
> 
> Before this patch:
> 
> $ modinfo drivers/scsi/ufs/ufs-qcom.ko | grep alias
> $
> 
> After this patch:
> 
> $ modinfo drivers/scsi/ufs/ufs-qcom.ko | grep alias
> alias:          of:N*T*Cqcom,ufshcC*
> alias:          of:N*T*Cqcom,ufshc
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
> 
>  drivers/scsi/ufs/ufs-qcom.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index abe617372661..5ff8a6bf6fd3 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1692,6 +1692,7 @@ static const struct of_device_id 
> ufs_qcom_of_match[] = {
>  	{ .compatible = "qcom,ufshc"},
>  	{},
>  };
> +MODULE_DEVICE_TABLE(of, ufs_qcom_of_match);
> 
>  static const struct dev_pm_ops ufs_qcom_pm_ops = {
>  	.suspend	= ufshcd_pltfrm_suspend,

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
