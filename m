From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: Clean up some rpm/spm level SysFS nodes upon
 remove
Date: Thu, 18 May 2017 10:54:11 -0700
Message-ID: <1489dbd4ee8018edf88cec05998d5137@codeaurora.org>
References: <1494570987-10128-1-git-send-email-michalx.potomski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48008 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933279AbdERRyN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2017 13:54:13 -0400
In-Reply-To: <1494570987-10128-1-git-send-email-michalx.potomski@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Potomski <michalx.potomski@intel.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com

On 2017-05-11 23:36, Michal Potomski wrote:
> From: Michał Potomski <michalx.potomski@intel.com>
> 
> When reloading module these two attributes aren't
> cleaned up properly and they persist causing warnings
> when trying to load module again. Additionally they are
> not recreated properly due to that.
> 
> Signed-off-by: Michał Potomski <michalx.potomski@intel.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index abc7e87..ffe8d86 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7698,6 +7698,12 @@ static inline void
> ufshcd_add_sysfs_nodes(struct ufs_hba *hba)
>  	ufshcd_add_spm_lvl_sysfs_nodes(hba);
>  }
> 
> +static inline void ufshcd_remove_sysfs_nodes(struct ufs_hba *hba)
> +{
> +	device_remove_file(hba->dev, &hba->rpm_lvl_attr);
> +	device_remove_file(hba->dev, &hba->spm_lvl_attr);
> +}
> +
>  /**
>   * ufshcd_shutdown - shutdown routine
>   * @hba: per adapter instance
> @@ -7735,6 +7741,7 @@ int ufshcd_shutdown(struct ufs_hba *hba)
>   */
>  void ufshcd_remove(struct ufs_hba *hba)
>  {
> +	ufshcd_remove_sysfs_nodes(hba);
>  	scsi_remove_host(hba->host);
>  	/* disable interrupts */
>  	ufshcd_disable_intr(hba, hba->intr_mask);


Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>


-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
