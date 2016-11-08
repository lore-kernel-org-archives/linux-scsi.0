From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v1] ufs: introduce setup_hibern8 callback
Date: Tue, 08 Nov 2016 11:08:20 -0800
Message-ID: <2b929a73cd7e0f63821383deec9bcac6@codeaurora.org>
References: <001f01d23994$719997c0$54ccc740$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47750 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753830AbcKHTIW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 14:08:22 -0500
In-Reply-To: <001f01d23994$719997c0$54ccc740$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, vinholikatti@gmail.com, =?UTF-8?Q?=EC=B6=94=ED=97=8C=EA=B4=91?= <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

On 2016-11-07 23:48, Kiwoong Kim wrote:
> Some UFS host controller may need to configure some things
> around hibern8 enter/exit
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 10 ++++++++--
>  drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index fdb0502..d4a5a9c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2697,6 +2697,8 @@ static int __ufshcd_uic_hibern8_enter(struct 
> ufs_hba *hba)
>  	int ret;
>  	struct uic_command uic_cmd = {0};
> 
> +	ufshcd_vops_setup_hibern8(hba, true, PRE_CHANGE);
> +
>  	uic_cmd.command = UIC_CMD_DME_HIBER_ENTER;
>  	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
> 
> @@ -2710,7 +2712,8 @@ static int __ufshcd_uic_hibern8_enter(struct 
> ufs_hba *hba)
>  		 */
>  		if (ufshcd_link_recovery(hba))
>  			ret = -ENOLINK;
> -	}
> +	} else
> +		ufshcd_vops_setup_hibern8(hba, true, POST_CHANGE);
> 
>  	return ret;
>  }
> @@ -2733,13 +2736,16 @@ static int ufshcd_uic_hibern8_exit(struct 
> ufs_hba *hba)
>  	struct uic_command uic_cmd = {0};
>  	int ret;
> 
> +	ufshcd_vops_setup_hibern8(hba, false, PRE_CHANGE);
> +
>  	uic_cmd.command = UIC_CMD_DME_HIBER_EXIT;
>  	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
>  	if (ret) {
>  		dev_err(hba->dev, "%s: hibern8 exit failed. ret = %d\n",
>  			__func__, ret);
>  		ret = ufshcd_link_recovery(hba);
> -	}
> +	} else
> +		ufshcd_vops_setup_hibern8(hba, false, POST_CHANGE);
> 
>  	return ret;
>  }
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index b084d89..13504b4 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -265,6 +265,8 @@ struct ufs_pwr_mode_info {
>   *                  to set some things
>   * @setup_task_mgmt: called before any task management request is 
> issued
>   *                  to set some things
> + * @setup_hibern8: called around hibern8 enter/exit
> + *		    to configure some things
>   * @suspend: called during host controller PM callback
>   * @resume: called during host controller PM callback
>   * @dbg_register_dump: used to dump controller debug information
> @@ -290,6 +292,7 @@ struct ufs_hba_variant_ops {
>  					struct ufs_pa_layer_attr *);
>  	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
>  	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
> +	void    (*setup_hibern8)(struct ufs_hba *, bool, bool);

Can we change the name to "hibern8_notify" ? You may check other 
ufs_hba_variant_ops for reference.

>  	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
>  	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>  	void	(*dbg_register_dump)(struct ufs_hba *hba);
> @@ -821,6 +824,13 @@ static inline void
> ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
>  		return hba->vops->setup_task_mgmt(hba, tag, tm_function);
>  }
> 
> +static inline void ufshcd_vops_setup_hibern8(struct ufs_hba *hba,
> +					bool enter, bool notify)

Using bool to specify whether it is hibern8 enter or hibern8 exit 
doesn't seem to be readable. May be you can pass the 
UIC_CMD_DME_HIBER_ENTER or UIC_CMD_DME_HIBER_EXIT (in other words use 
"enum uic_cmd_dme" type).

also "notify" type should be changed from "bool" to "enum 
ufs_notify_change_status".

> +{
> +	if (hba->vops && hba->vops->setup_hibern8)
> +		return hba->vops->setup_hibern8(hba, enter, notify);
> +}
> +
>  static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum 
> ufs_pm_op op)
>  {
>  	if (hba->vops && hba->vops->suspend)

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
