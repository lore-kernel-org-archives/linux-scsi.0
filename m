From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH 1/1] scsi/ufs: qcom: Don't enable PHY_QCOM_UFS by default
Date: Mon, 9 Apr 2018 09:51:27 -0700
Message-ID: <20180409165127.GK453@tuxbook-pro>
References: <20180409132404.20876-1-vivek.gautam@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180409132404.20876-1-vivek.gautam@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: martin.petersen@oracle.com, kishon@ti.com, jejb@linux.vnet.ibm.com, subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon 09 Apr 06:24 PDT 2018, Vivek Gautam wrote:

> While we try to transition from a separate ufs phy driver to a
> more integrated qmp phy driver, don't let SCSI_UFS_QCOM to
> enable PHY_QCOM_UFS config by default.
> The users should enable this in their defconfigs.
> Also add inline definitions for couple of functions -
> a) ufs_qcom_phy_set_tx_lane_enable()
> b) void ufs_qcom_phy_save_controller_version()
> to enable clean build for SCSI_UFS_QCOM.
> 
> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
> ---
>  drivers/scsi/ufs/Kconfig         |  1 -
>  include/linux/phy/phy-qcom-ufs.h | 15 ++++++++++++++-
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index e27b4d4e6ae2..7e8898b6eb67 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -91,7 +91,6 @@ config SCSI_UFS_DWC_TC_PLATFORM
>  config SCSI_UFS_QCOM
>  	tristate "QCOM specific hooks to UFS controller platform driver"
>  	depends on SCSI_UFSHCD_PLATFORM && ARCH_QCOM
> -	select PHY_QCOM_UFS

As you're depending on function in the UFS phy, which can be compiled as
a module you might end up in a configuration where UFS_QCOM is builtin
and the PHY_QCOM_UFS is module, which will fail to link.

So you need to make this:

	depends on PHY_QCOM_UFS || PHY_QCOM_UFS=n

In which case we say that if PHY_QCOM_UFS is a module UFS_QCOM must be a
module and if PHY_QCOM_UFS is not compiled in UFS_QCOM can be either
builtin or a module.

>  	help
>  	  This selects the QCOM specific additions to UFSHCD platform driver.
>  	  UFS host on QCOM needs some vendor specific configuration before
> diff --git a/include/linux/phy/phy-qcom-ufs.h b/include/linux/phy/phy-qcom-ufs.h
> index 0a2c18a9771d..1388c2a2965e 100644
> --- a/include/linux/phy/phy-qcom-ufs.h
> +++ b/include/linux/phy/phy-qcom-ufs.h
> @@ -31,8 +31,21 @@ void ufs_qcom_phy_enable_dev_ref_clk(struct phy *phy);
>   */
>  void ufs_qcom_phy_disable_dev_ref_clk(struct phy *phy);
>  
> +#if IS_ENABLED(CONFIG_PHY_QCOM_UFS)
>  int ufs_qcom_phy_set_tx_lane_enable(struct phy *phy, u32 tx_lanes);
>  void ufs_qcom_phy_save_controller_version(struct phy *phy,
> -			u8 major, u16 minor, u16 step);
> +					  u8 major, u16 minor, u16 step);
> +#else
> +static inline int ufs_qcom_phy_set_tx_lane_enable(struct phy *phy, u32 tx_lanes)
> +{
> +	return -ENOSYS;
> +}
> +
> +static inline void ufs_qcom_phy_save_controller_version(struct phy *phy,
> +							u8 major, u16 minor,
> +							u16 step)
> +{
> +}
> +#endif /* PHY_QCOM_UFS */

What's the timeline for getting rid of the references to these
functions? I presume that code depending on these being here will
compile but won't actually work?

Regards,
Bjorn
