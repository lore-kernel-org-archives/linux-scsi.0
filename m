From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2] ufs: introduce hibern8_notify callback
Date: Thu, 10 Nov 2016 10:15:45 -0800
Message-ID: <705df336d5c416fc899f6431a6450ee2@codeaurora.org>
References: <002401d23b4c$70a1f060$51e5d120$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55074 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752508AbcKJSQJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2016 13:16:09 -0500
In-Reply-To: <002401d23b4c$70a1f060$51e5d120$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, cpgs@samsung.com, HeonGwang Chu <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

On 2016-11-10 04:17, Kiwoong Kim wrote:
> Some UFS host controller may need to configure some things
> around hibern8 enter/exit
> 
> v2: change the callback name and data type of 2nd argument
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 12 ++++++++++--
>  drivers/scsi/ufs/ufshcd.h | 12 ++++++++++++
>  2 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 301b592..e75fbb3 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2697,6 +2697,8 @@ static int __ufshcd_uic_hibern8_enter(struct 
> ufs_hba *hba)
>  	int ret;
>  	struct uic_command uic_cmd = {0};
> 
> +	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER, PRE_CHANGE);
> +
>  	uic_cmd.command = UIC_CMD_DME_HIBER_ENTER;
>  	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
> 
> @@ -2710,7 +2712,9 @@ static int __ufshcd_uic_hibern8_enter(struct 
> ufs_hba *hba)
>  		 */
>  		if (ufshcd_link_recovery(hba))
>  			ret = -ENOLINK;
> -	}
> +	} else
> +		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER,
> +								POST_CHANGE);
> 
>  	return ret;
>  }
> @@ -2733,13 +2737,17 @@ static int ufshcd_uic_hibern8_exit(struct 
> ufs_hba *hba)
>  	struct uic_command uic_cmd = {0};
>  	int ret;
> 
> +	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT, PRE_CHANGE);
> +
>  	uic_cmd.command = UIC_CMD_DME_HIBER_EXIT;
>  	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
>  	if (ret) {
>  		dev_err(hba->dev, "%s: hibern8 exit failed. ret = %d\n",
>  			__func__, ret);
>  		ret = ufshcd_link_recovery(hba);
> -	}
> +	} else
> +		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT,
> +								POST_CHANGE);
> 
>  	return ret;
>  }
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 05d8384..8e76501 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -265,6 +265,8 @@ struct ufs_pwr_mode_info {
>   *                  to set some things
>   * @setup_task_mgmt: called before any task management request is 
> issued
>   *                  to set some things
> + * @hibern8_notify: called around hibern8 enter/exit
> + *		    to configure some things
>   * @suspend: called during host controller PM callback
>   * @resume: called during host controller PM callback
>   * @dbg_register_dump: used to dump controller debug information
> @@ -290,6 +292,8 @@ struct ufs_hba_variant_ops {
>  					struct ufs_pa_layer_attr *);
>  	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
>  	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
> +	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
> +				       enum ufs_notify_change_status);
>  	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
>  	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>  	void	(*dbg_register_dump)(struct ufs_hba *hba);
> @@ -821,6 +825,14 @@ static inline void
> ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
>  		return hba->vops->setup_task_mgmt(hba, tag, tm_function);
>  }
> 
> +static inline void ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
> +					enum uic_cmd_dme cmd,
> +					enum ufs_notify_change_status status)
> +{
> +	if (hba->vops && hba->vops->hibern8_notify)
> +		return hba->vops->hibern8_notify(hba, cmd, status);
> +}
> +
>  static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum 
> ufs_pm_op op)
>  {
>  	if (hba->vops && hba->vops->suspend)


LGTM.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>


-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
