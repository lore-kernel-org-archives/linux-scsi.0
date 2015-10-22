From: subhashj@codeaurora.org
Subject: Re: [PATCH v7 1/8] phy: qcom-ufs: fix build error when the component
 is built as a module
Date: Thu, 22 Oct 2015 06:45:14 -0000
Message-ID: <1354394d9ec67bb7c06ac8537f9a80e8.squirrel@codeaurora.org>
References: <1441205138-12664-1-git-send-email-ygardi@codeaurora.org>
    <1441205138-12664-2-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1441205138-12664-2-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
Cc: robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Kishon Vijay Abraham I <kishon@ti.com>
List-Id: linux-scsi@vger.kernel.org

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

> Export the following functions in order to avoid build errors
> when the component PHY_QCOM_UFS is compiled as a module:
>
> ERROR: "ufs_qcom_phy_disable_ref_clk"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_enable_ref_clk"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_is_pcs_ready"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_disable_iface_clk"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_start_serdes"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_calibrate_phy"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_enable_dev_ref_clk"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_set_tx_lane_enable"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_disable_dev_ref_clk"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_save_controller_version"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_enable_iface_clk"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> make[1]: *** [__modpost] Error 1
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/phy/phy-qcom-ufs.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
> index f9c618f..6140a8b 100644
> --- a/drivers/phy/phy-qcom-ufs.c
> +++ b/drivers/phy/phy-qcom-ufs.c
> @@ -432,6 +432,7 @@ out_disable_src:
>  out:
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(ufs_qcom_phy_enable_ref_clk);
>
>  static
>  int ufs_qcom_phy_disable_vreg(struct phy *phy,
> @@ -474,6 +475,7 @@ void ufs_qcom_phy_disable_ref_clk(struct phy
> *generic_phy)
>  		phy->is_ref_clk_enabled = false;
>  	}
>  }
> +EXPORT_SYMBOL_GPL(ufs_qcom_phy_disable_ref_clk);
>
>  #define UFS_REF_CLK_EN	(1 << 5)
>
> @@ -517,11 +519,13 @@ void ufs_qcom_phy_enable_dev_ref_clk(struct phy
> *generic_phy)
>  {
>  	ufs_qcom_phy_dev_ref_clk_ctrl(generic_phy, true);
>  }
> +EXPORT_SYMBOL_GPL(ufs_qcom_phy_enable_dev_ref_clk);
>
>  void ufs_qcom_phy_disable_dev_ref_clk(struct phy *generic_phy)
>  {
>  	ufs_qcom_phy_dev_ref_clk_ctrl(generic_phy, false);
>  }
> +EXPORT_SYMBOL_GPL(ufs_qcom_phy_disable_dev_ref_clk);
>
>  /* Turn ON M-PHY RMMI interface clocks */
>  int ufs_qcom_phy_enable_iface_clk(struct phy *generic_phy)
> @@ -550,6 +554,7 @@ int ufs_qcom_phy_enable_iface_clk(struct phy
> *generic_phy)
>  out:
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(ufs_qcom_phy_enable_iface_clk);
>
>  /* Turn OFF M-PHY RMMI interface clocks */
>  void ufs_qcom_phy_disable_iface_clk(struct phy *generic_phy)
> @@ -562,6 +567,7 @@ void ufs_qcom_phy_disable_iface_clk(struct phy
> *generic_phy)
>  		phy->is_iface_clk_enabled = false;
>  	}
>  }
> +EXPORT_SYMBOL_GPL(ufs_qcom_phy_disable_iface_clk);
>
>  int ufs_qcom_phy_start_serdes(struct phy *generic_phy)
>  {
> @@ -578,6 +584,7 @@ int ufs_qcom_phy_start_serdes(struct phy *generic_phy)
>
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(ufs_qcom_phy_start_serdes);
>
>  int ufs_qcom_phy_set_tx_lane_enable(struct phy *generic_phy, u32
> tx_lanes)
>  {
> @@ -595,6 +602,7 @@ int ufs_qcom_phy_set_tx_lane_enable(struct phy
> *generic_phy, u32 tx_lanes)
>
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(ufs_qcom_phy_set_tx_lane_enable);
>
>  void ufs_qcom_phy_save_controller_version(struct phy *generic_phy,
>  					  u8 major, u16 minor, u16 step)
> @@ -605,6 +613,7 @@ void ufs_qcom_phy_save_controller_version(struct phy
> *generic_phy,
>  	ufs_qcom_phy->host_ctrl_rev_minor = minor;
>  	ufs_qcom_phy->host_ctrl_rev_step = step;
>  }
> +EXPORT_SYMBOL_GPL(ufs_qcom_phy_save_controller_version);
>
>  int ufs_qcom_phy_calibrate_phy(struct phy *generic_phy, bool is_rate_B)
>  {
> @@ -625,6 +634,7 @@ int ufs_qcom_phy_calibrate_phy(struct phy
> *generic_phy, bool is_rate_B)
>
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(ufs_qcom_phy_calibrate_phy);
>
>  int ufs_qcom_phy_remove(struct phy *generic_phy,
>  			struct ufs_qcom_phy *ufs_qcom_phy)
> @@ -662,6 +672,7 @@ int ufs_qcom_phy_is_pcs_ready(struct phy *generic_phy)
>  	return ufs_qcom_phy->phy_spec_ops->
>  			is_physical_coding_sublayer_ready(ufs_qcom_phy);
>  }
> +EXPORT_SYMBOL_GPL(ufs_qcom_phy_is_pcs_ready);
>
>  int ufs_qcom_phy_power_on(struct phy *generic_phy)
>  {
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
>
