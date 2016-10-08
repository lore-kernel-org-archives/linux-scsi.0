From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [RESEND PATCH v3] scsi: ufshcd: fix possible unclocked register
 access
Date: Sat, 08 Oct 2016 12:33:02 +0900
Message-ID: <000301d22114$ac8d9c70$05a8d550$@samsung.com>
References: <CGME20161007044848epcas2p1aa83439d196cf352c36f1da4dbd18b1d@epcas2p1.samsung.com>
 <1475815702-8624-1-git-send-email-subhashj@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:52419 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754449AbcJHDdE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2016 23:33:04 -0400
In-reply-to: <1475815702-8624-1-git-send-email-subhashj@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: "'open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER'" <linux-scsi@vger.kernel.org>, 'open list' <linux-kernel@vger.kernel.org>

Reviewed-by: Kiwoong Kim <kwmad.kim@samsung.com>

> Vendor specific setup_clocks callback may require the clocks managed
> by ufshcd driver to be ON. So if the vendor specific setup_clocks callback
> is called while the required clocks are turned off, it could result into
> unclocked register access.
> 
> To prevent possible unclock register access, this change adds one more
> argument to setup_clocks callback to let it know whether it is called
> pre/post the clock changes by core driver.
> 
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> ---
> Changes from v2:
> * Added one more argument to setup_clocks callback, this should address
>   Kiwoong Kim's comments on v2.
> 
> Changes from v1:
> * Don't call ufshcd_vops_setup_clocks() again for clock off
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 10 ++++++----
>  drivers/scsi/ufs/ufshcd.c   | 17 ++++++++---------
>  drivers/scsi/ufs/ufshcd.h   |  8 +++++---
>  3 files changed, 19 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 3aedf73..3c4f602 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1094,10 +1094,12 @@ static void ufs_qcom_set_caps(struct ufs_hba *hba)
>   * ufs_qcom_setup_clocks - enables/disable clocks
>   * @hba: host controller instance
>   * @on: If true, enable clocks else disable them.
> + * @status: PRE_CHANGE or POST_CHANGE notify
>   *
>   * Returns 0 on success, non-zero on failure.
>   */
> -static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on)
> +static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
> +				 enum ufs_notify_change_status status)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>  	int err;
> @@ -1111,7 +1113,7 @@ static int ufs_qcom_setup_clocks(struct ufs_hba
*hba,
> bool on)
>  	if (!host)
>  		return 0;
> 
> -	if (on) {
> +	if (on && (status == POST_CHANGE)) {
>  		err = ufs_qcom_phy_enable_iface_clk(host->generic_phy);
>  		if (err)
>  			goto out;
> @@ -1130,7 +1132,7 @@ static int ufs_qcom_setup_clocks(struct ufs_hba
*hba,
> bool on)
>  		if (vote == host->bus_vote.min_bw_vote)
>  			ufs_qcom_update_bus_bw_vote(host);
> 
> -	} else {
> +	} else if (!on && (status == PRE_CHANGE)) {
> 
>  		/* M-PHY RMMI interface clocks can be turned off */
>  		ufs_qcom_phy_disable_iface_clk(host->generic_phy);
> @@ -1254,7 +1256,7 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  	ufs_qcom_set_caps(hba);
>  	ufs_qcom_advertise_quirks(hba);
> 
> -	ufs_qcom_setup_clocks(hba, true);
> +	ufs_qcom_setup_clocks(hba, true, POST_CHANGE);
> 
>  	if (hba->dev->id < MAX_UFS_QCOM_HOSTS)
>  		ufs_qcom_hosts[hba->dev->id] = host;
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 05c7456..571a2f6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5389,6 +5389,10 @@ static int __ufshcd_setup_clocks(struct ufs_hba
> *hba, bool on,
>  	if (!head || list_empty(head))
>  		goto out;
> 
> +	ret = ufshcd_vops_setup_clocks(hba, on, PRE_CHANGE);
> +	if (ret)
> +		return ret;
> +
>  	list_for_each_entry(clki, head, list) {
>  		if (!IS_ERR_OR_NULL(clki->clk)) {
>  			if (skip_ref_clk && !strcmp(clki->name, "ref_clk"))
> @@ -5410,7 +5414,10 @@ static int __ufshcd_setup_clocks(struct ufs_hba
> *hba, bool on,
>  		}
>  	}
> 
> -	ret = ufshcd_vops_setup_clocks(hba, on);
> +	ret = ufshcd_vops_setup_clocks(hba, on, POST_CHANGE);
> +	if (ret)
> +		return ret;
> +
>  out:
>  	if (ret) {
>  		list_for_each_entry(clki, head, list) {
> @@ -5500,8 +5507,6 @@ static void ufshcd_variant_hba_exit(struct ufs_hba
> *hba)
>  	if (!hba->vops)
>  		return;
> 
> -	ufshcd_vops_setup_clocks(hba, false);
> -
>  	ufshcd_vops_setup_regulators(hba, false);
> 
>  	ufshcd_vops_exit(hba);
> @@ -5905,10 +5910,6 @@ disable_clks:
>  	if (ret)
>  		goto set_link_active;
> 
> -	ret = ufshcd_vops_setup_clocks(hba, false);
> -	if (ret)
> -		goto vops_resume;
> -
>  	if (!ufshcd_is_link_active(hba))
>  		ufshcd_setup_clocks(hba, false);
>  	else
> @@ -5925,8 +5926,6 @@ disable_clks:
>  	ufshcd_hba_vreg_set_lpm(hba);
>  	goto out;
> 
> -vops_resume:
> -	ufshcd_vops_resume(hba, pm_op);
>  set_link_active:
>  	ufshcd_vreg_set_hpm(hba);
>  	if (ufshcd_is_link_hibern8(hba) && !ufshcd_uic_hibern8_exit(hba))
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 430bef1..afff7f4 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -273,7 +273,8 @@ struct ufs_hba_variant_ops {
>  	u32	(*get_ufs_hci_version)(struct ufs_hba *);
>  	int	(*clk_scale_notify)(struct ufs_hba *, bool,
>  				    enum ufs_notify_change_status);
> -	int	(*setup_clocks)(struct ufs_hba *, bool);
> +	int	(*setup_clocks)(struct ufs_hba *, bool,
> +				enum ufs_notify_change_status);
>  	int     (*setup_regulators)(struct ufs_hba *, bool);
>  	int	(*hce_enable_notify)(struct ufs_hba *,
>  				     enum ufs_notify_change_status);
> @@ -755,10 +756,11 @@ static inline int
> ufshcd_vops_clk_scale_notify(struct ufs_hba *hba,
>  	return 0;
>  }
> 
> -static inline int ufshcd_vops_setup_clocks(struct ufs_hba *hba, bool on)
> +static inline int ufshcd_vops_setup_clocks(struct ufs_hba *hba, bool on,
> +					enum ufs_notify_change_status
status)
>  {
>  	if (hba->vops && hba->vops->setup_clocks)
> -		return hba->vops->setup_clocks(hba, on);
> +		return hba->vops->setup_clocks(hba, on, status);
>  	return 0;
>  }
> 
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


