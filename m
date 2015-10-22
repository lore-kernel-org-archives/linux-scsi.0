From: subhashj@codeaurora.org
Subject: Re: [PATCH v7 5/8] scsi: ufs: creates wrapper functions for vops
Date: Thu, 22 Oct 2015 06:54:30 -0000
Message-ID: <55208bac02d0a2a2d6f92895ef01dd36.squirrel@codeaurora.org>
References: <1441205138-12664-1-git-send-email-ygardi@codeaurora.org>
    <1441205138-12664-6-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441205138-12664-6-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>


> In order to simplify the code a set of wrapper functions is created
> to test and call each of the variant operations.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufs-qcom.c |   1 -
>  drivers/scsi/ufs/ufshcd.c   | 104
> +++++++++++++++++---------------------------
>  drivers/scsi/ufs/ufshcd.h   |  98
> +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 137 insertions(+), 66 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 64c54b7..329ac84 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1049,6 +1049,5 @@ static const struct ufs_hba_variant_ops
> ufs_hba_qcom_vops = {
>  	.suspend		= ufs_qcom_suspend,
>  	.resume			= ufs_qcom_resume,
>  };
> -EXPORT_SYMBOL(ufs_hba_qcom_vops);
>
>  MODULE_LICENSE("GPL v2");
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b0ade73..9e79c33 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -271,10 +271,8 @@ static inline u32 ufshcd_get_intr_mask(struct ufs_hba
> *hba)
>   */
>  static inline u32 ufshcd_get_ufs_version(struct ufs_hba *hba)
>  {
> -	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION) {
> -		if (hba->vops && hba->vops->get_ufs_hci_version)
> -			return hba->vops->get_ufs_hci_version(hba);
> -	}
> +	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION)
> +		return ufshcd_vops_get_ufs_hci_version(hba);
>
>  	return ufshcd_readl(hba, REG_UFS_VERSION);
>  }
> @@ -2473,9 +2471,8 @@ static int ufshcd_change_power_mode(struct ufs_hba
> *hba,
>  		dev_err(hba->dev,
>  			"%s: power mode change failed %d\n", __func__, ret);
>  	} else {
> -		if (hba->vops && hba->vops->pwr_change_notify)
> -			hba->vops->pwr_change_notify(hba,
> -				POST_CHANGE, NULL, pwr_mode);
> +		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, NULL,
> +								pwr_mode);
>
>  		memcpy(&hba->pwr_info, pwr_mode,
>  			sizeof(struct ufs_pa_layer_attr));
> @@ -2495,10 +2492,10 @@ static int ufshcd_config_pwr_mode(struct ufs_hba
> *hba,
>  	struct ufs_pa_layer_attr final_params = { 0 };
>  	int ret;
>
> -	if (hba->vops && hba->vops->pwr_change_notify)
> -		hba->vops->pwr_change_notify(hba,
> -		     PRE_CHANGE, desired_pwr_mode, &final_params);
> -	else
> +	ret = ufshcd_vops_pwr_change_notify(hba, PRE_CHANGE,
> +					desired_pwr_mode, &final_params);
> +
> +	if (ret)
>  		memcpy(&final_params, desired_pwr_mode, sizeof(final_params));
>
>  	ret = ufshcd_change_power_mode(hba, &final_params);
> @@ -2647,8 +2644,7 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
>  	/* UniPro link is disabled at this point */
>  	ufshcd_set_link_off(hba);
>
> -	if (hba->vops && hba->vops->hce_enable_notify)
> -		hba->vops->hce_enable_notify(hba, PRE_CHANGE);
> +	ufshcd_vops_hce_enable_notify(hba, PRE_CHANGE);
>
>  	/* start controller initialization sequence */
>  	ufshcd_hba_start(hba);
> @@ -2681,8 +2677,7 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
>  	/* enable UIC related interrupts */
>  	ufshcd_enable_intr(hba, UFSHCD_UIC_MASK);
>
> -	if (hba->vops && hba->vops->hce_enable_notify)
> -		hba->vops->hce_enable_notify(hba, POST_CHANGE);
> +	ufshcd_vops_hce_enable_notify(hba, POST_CHANGE);
>
>  	return 0;
>  }
> @@ -2735,8 +2730,7 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
>  	int retries = DME_LINKSTARTUP_RETRIES;
>
>  	do {
> -		if (hba->vops && hba->vops->link_startup_notify)
> -			hba->vops->link_startup_notify(hba, PRE_CHANGE);
> +		ufshcd_vops_link_startup_notify(hba, PRE_CHANGE);
>
>  		ret = ufshcd_dme_link_startup(hba);
>
> @@ -2767,11 +2761,9 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
>  	}
>
>  	/* Include any host controller configuration via UIC commands */
> -	if (hba->vops && hba->vops->link_startup_notify) {
> -		ret = hba->vops->link_startup_notify(hba, POST_CHANGE);
> -		if (ret)
> -			goto out;
> -	}
> +	ret = ufshcd_vops_link_startup_notify(hba, POST_CHANGE);
> +	if (ret)
> +		goto out;
>
>  	ret = ufshcd_make_hba_operational(hba);
>  out:
> @@ -4578,8 +4570,7 @@ static int __ufshcd_setup_clocks(struct ufs_hba
> *hba, bool on,
>  		}
>  	}
>
> -	if (hba->vops && hba->vops->setup_clocks)
> -		ret = hba->vops->setup_clocks(hba, on);
> +	ret = ufshcd_vops_setup_clocks(hba, on);
>  out:
>  	if (ret) {
>  		list_for_each_entry(clki, head, list) {
> @@ -4645,27 +4636,22 @@ static int ufshcd_variant_hba_init(struct ufs_hba
> *hba)
>  	if (!hba->vops)
>  		goto out;
>
> -	if (hba->vops->init) {
> -		err = hba->vops->init(hba);
> -		if (err)
> -			goto out;
> -	}
> +	err = ufshcd_vops_init(hba);
> +	if (err)
> +		goto out;
>
> -	if (hba->vops->setup_regulators) {
> -		err = hba->vops->setup_regulators(hba, true);
> -		if (err)
> -			goto out_exit;
> -	}
> +	err = ufshcd_vops_setup_regulators(hba, true);
> +	if (err)
> +		goto out_exit;
>
>  	goto out;
>
>  out_exit:
> -	if (hba->vops->exit)
> -		hba->vops->exit(hba);
> +	ufshcd_vops_exit(hba);
>  out:
>  	if (err)
>  		dev_err(hba->dev, "%s: variant %s init failed err %d\n",
> -			__func__, hba->vops ? hba->vops->name : "", err);
> +			__func__, ufshcd_get_var_name(hba), err);
>  	return err;
>  }
>
> @@ -4674,14 +4660,11 @@ static void ufshcd_variant_hba_exit(struct ufs_hba
> *hba)
>  	if (!hba->vops)
>  		return;
>
> -	if (hba->vops->setup_clocks)
> -		hba->vops->setup_clocks(hba, false);
> +	ufshcd_vops_setup_clocks(hba, false);
>
> -	if (hba->vops->setup_regulators)
> -		hba->vops->setup_regulators(hba, false);
> +	ufshcd_vops_setup_regulators(hba, false);
>
> -	if (hba->vops->exit)
> -		hba->vops->exit(hba);
> +	ufshcd_vops_exit(hba);
>  }
>
>  static int ufshcd_hba_init(struct ufs_hba *hba)
> @@ -5058,17 +5041,13 @@ disable_clks:
>  	 * vendor specific host controller register space call them before the
>  	 * host clocks are ON.
>  	 */
> -	if (hba->vops && hba->vops->suspend) {
> -		ret = hba->vops->suspend(hba, pm_op);
> -		if (ret)
> -			goto set_link_active;
> -	}
> +	ret = ufshcd_vops_suspend(hba, pm_op);
> +	if (ret)
> +		goto set_link_active;
>
> -	if (hba->vops && hba->vops->setup_clocks) {
> -		ret = hba->vops->setup_clocks(hba, false);
> -		if (ret)
> -			goto vops_resume;
> -	}
> +	ret = ufshcd_vops_setup_clocks(hba, false);
> +	if (ret)
> +		goto vops_resume;
>
>  	if (!ufshcd_is_link_active(hba))
>  		ufshcd_setup_clocks(hba, false);
> @@ -5079,7 +5058,7 @@ disable_clks:
>  	hba->clk_gating.state = CLKS_OFF;
>  	/*
>  	 * Disable the host irq as host controller as there won't be any
> -	 * host controller trasanction expected till resume.
> +	 * host controller transaction expected till resume.
>  	 */
>  	ufshcd_disable_irq(hba);
>  	/* Put the host controller in low power mode if possible */
> @@ -5087,8 +5066,7 @@ disable_clks:
>  	goto out;
>
>  vops_resume:
> -	if (hba->vops && hba->vops->resume)
> -		hba->vops->resume(hba, pm_op);
> +	ufshcd_vops_resume(hba, pm_op);
>  set_link_active:
>  	ufshcd_vreg_set_hpm(hba);
>  	if (ufshcd_is_link_hibern8(hba) && !ufshcd_uic_hibern8_exit(hba))
> @@ -5144,11 +5122,9 @@ static int ufshcd_resume(struct ufs_hba *hba, enum
> ufs_pm_op pm_op)
>  	 * vendor specific host controller register space call them when the
>  	 * host clocks are ON.
>  	 */
> -	if (hba->vops && hba->vops->resume) {
> -		ret = hba->vops->resume(hba, pm_op);
> -		if (ret)
> -			goto disable_vreg;
> -	}
> +	ret = ufshcd_vops_resume(hba, pm_op);
> +	if (ret)
> +		goto disable_vreg;
>
>  	if (ufshcd_is_link_hibern8(hba)) {
>  		ret = ufshcd_uic_hibern8_exit(hba);
> @@ -5189,8 +5165,7 @@ static int ufshcd_resume(struct ufs_hba *hba, enum
> ufs_pm_op pm_op)
>  set_old_link_state:
>  	ufshcd_link_state_transition(hba, old_link_state, 0);
>  vendor_suspend:
> -	if (hba->vops && hba->vops->suspend)
> -		hba->vops->suspend(hba, pm_op);
> +	ufshcd_vops_suspend(hba, pm_op);
>  disable_vreg:
>  	ufshcd_vreg_set_lpm(hba);
>  disable_irq_and_vops_clks:
> @@ -5463,8 +5438,7 @@ static int ufshcd_scale_clks(struct ufs_hba *hba,
> bool scale_up)
>  		dev_dbg(hba->dev, "%s: clk: %s, rate: %lu\n", __func__,
>  				clki->name, clk_get_rate(clki->clk));
>  	}
> -	if (hba->vops->clk_scale_notify)
> -		hba->vops->clk_scale_notify(hba);
> +	ufshcd_vops_clk_scale_notify(hba);
>  out:
>  	return ret;
>  }
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 54e7afb..ce75626 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -674,4 +674,102 @@ static inline int ufshcd_dme_peer_get(struct ufs_hba
> *hba,
>
>  int ufshcd_hold(struct ufs_hba *hba, bool async);
>  void ufshcd_release(struct ufs_hba *hba);
> +
> +/* Wrapper functions for safely calling variant operations */
> +static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
> +{
> +	if (hba->vops)
> +		return hba->vops->name;
> +	return "";
> +}
> +
> +static inline int ufshcd_vops_init(struct ufs_hba *hba)
> +{
> +	if (hba->vops && hba->vops->init)
> +		return hba->vops->init(hba);
> +
> +	return 0;
> +}
> +
> +static inline void ufshcd_vops_exit(struct ufs_hba *hba)
> +{
> +	if (hba->vops && hba->vops->exit)
> +		return hba->vops->exit(hba);
> +}
> +
> +static inline u32 ufshcd_vops_get_ufs_hci_version(struct ufs_hba *hba)
> +{
> +	if (hba->vops && hba->vops->get_ufs_hci_version)
> +		return hba->vops->get_ufs_hci_version(hba);
> +
> +	return ufshcd_readl(hba, REG_UFS_VERSION);
> +}
> +
> +static inline void ufshcd_vops_clk_scale_notify(struct ufs_hba *hba)
> +{
> +	if (hba->vops && hba->vops->clk_scale_notify)
> +		return hba->vops->clk_scale_notify(hba);
> +}
> +
> +static inline int ufshcd_vops_setup_clocks(struct ufs_hba *hba, bool on)
> +{
> +	if (hba->vops && hba->vops->setup_clocks)
> +		return hba->vops->setup_clocks(hba, on);
> +
> +	return 0;
> +}
> +
> +static inline int ufshcd_vops_setup_regulators(struct ufs_hba *hba, bool
> status)
> +{
> +	if (hba->vops && hba->vops->setup_regulators)
> +		return hba->vops->setup_regulators(hba, status);
> +
> +	return 0;
> +}
> +
> +static inline int ufshcd_vops_hce_enable_notify(struct ufs_hba *hba,
> +						bool status)
> +{
> +	if (hba->vops && hba->vops->hce_enable_notify)
> +		return hba->vops->hce_enable_notify(hba, status);
> +
> +	return 0;
> +}
> +static inline int ufshcd_vops_link_startup_notify(struct ufs_hba *hba,
> +						bool status)
> +{
> +	if (hba->vops && hba->vops->link_startup_notify)
> +		return hba->vops->link_startup_notify(hba, status);
> +
> +	return 0;
> +}
> +
> +static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
> +				  bool status,
> +				  struct ufs_pa_layer_attr *dev_max_params,
> +				  struct ufs_pa_layer_attr *dev_req_params)
> +{
> +	if (hba->vops && hba->vops->pwr_change_notify)
> +		return hba->vops->pwr_change_notify(hba, status,
> +					dev_max_params, dev_req_params);
> +
> +	return -ENOTSUPP;
> +}
> +
> +static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum ufs_pm_op
> op)
> +{
> +	if (hba->vops && hba->vops->suspend)
> +		return hba->vops->suspend(hba, op);
> +
> +	return 0;
> +}
> +
> +static inline int ufshcd_vops_resume(struct ufs_hba *hba, enum ufs_pm_op
> op)
> +{
> +	if (hba->vops && hba->vops->resume)
> +		return hba->vops->resume(hba, op);
> +
> +	return 0;
> +}
> +
>  #endif /* End of Header */
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
>
