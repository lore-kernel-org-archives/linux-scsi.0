From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH 2/3] scsi/ufs: qcom: Remove ufs_qcom_phy_*() calls from
 host
Date: Mon, 24 Sep 2018 10:24:32 -0700
Message-ID: <20180924172432.GL1367@tuxbook-pro>
References: <20180904101719.18049-1-vivek.gautam@codeaurora.org>
 <20180904101719.18049-3-vivek.gautam@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180904101719.18049-3-vivek.gautam@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: kishon@ti.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, subhashj@codeaurora.org, evgreen@chromium.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue 04 Sep 03:17 PDT 2018, Vivek Gautam wrote:

> The host makes direct calls into phy using ufs_qcom_phy_*()
> APIs. These APIs are only defined for 20nm qcom-ufs-qmp phy
> which is not being used by any architecture as yet. Future
> architectures too are not going to use 20nm ufs phy.
> So remove these ufs_qcom_phy_*() calls from host to let further
> change declare the 20nm phy as broken.
> Also remove couple of stale enum defines for ufs phy.
> 
> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  drivers/phy/qualcomm/phy-qcom-ufs-i.h |  2 +-
>  drivers/scsi/ufs/ufs-qcom.c           | 28 +---------------------------
>  drivers/scsi/ufs/ufs-qcom.h           |  5 -----
>  include/linux/phy/phy-qcom-ufs.h      | 24 ------------------------
>  4 files changed, 2 insertions(+), 57 deletions(-)
>  delete mode 100644 include/linux/phy/phy-qcom-ufs.h
> 
> diff --git a/drivers/phy/qualcomm/phy-qcom-ufs-i.h b/drivers/phy/qualcomm/phy-qcom-ufs-i.h
> index 822c83b8efcd..681644e43248 100644
> --- a/drivers/phy/qualcomm/phy-qcom-ufs-i.h
> +++ b/drivers/phy/qualcomm/phy-qcom-ufs-i.h
> @@ -17,9 +17,9 @@
>  
>  #include <linux/module.h>
>  #include <linux/clk.h>
> +#include <linux/phy/phy.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/slab.h>
> -#include <linux/phy/phy-qcom-ufs.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/delay.h>
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 75ee5906b966..3dc4501c6945 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -16,7 +16,6 @@
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <linux/phy/phy.h>
> -#include <linux/phy/phy-qcom-ufs.h>
>  
>  #include "ufshcd.h"
>  #include "ufshcd-pltfrm.h"
> @@ -189,22 +188,9 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
>  
>  static int ufs_qcom_link_startup_post_change(struct ufs_hba *hba)
>  {
> -	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> -	struct phy *phy = host->generic_phy;
>  	u32 tx_lanes;
> -	int err = 0;
> -
> -	err = ufs_qcom_get_connected_tx_lanes(hba, &tx_lanes);
> -	if (err)
> -		goto out;
>  
> -	err = ufs_qcom_phy_set_tx_lane_enable(phy, tx_lanes);
> -	if (err)
> -		dev_err(hba->dev, "%s: ufs_qcom_phy_set_tx_lane_enable failed\n",
> -			__func__);
> -
> -out:
> -	return err;
> +	return ufs_qcom_get_connected_tx_lanes(hba, &tx_lanes);
>  }
>  
>  static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
> @@ -932,10 +918,8 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
>  {
>  	u32 val;
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> -	struct phy *phy = host->generic_phy;
>  	struct ufs_qcom_dev_params ufs_qcom_cap;
>  	int ret = 0;
> -	int res = 0;
>  
>  	if (!dev_req_params) {
>  		pr_err("%s: incoming dev_req_params is NULL\n", __func__);
> @@ -1002,12 +986,6 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
>  		}
>  
>  		val = ~(MAX_U32 << dev_req_params->lane_tx);
> -		res = ufs_qcom_phy_set_tx_lane_enable(phy, val);
> -		if (res) {
> -			dev_err(hba->dev, "%s: ufs_qcom_phy_set_tx_lane_enable() failed res = %d\n",
> -				__func__, res);
> -			ret = res;
> -		}
>  
>  		/* cache the power mode parameters to use internally */
>  		memcpy(&host->dev_req_params,
> @@ -1264,10 +1242,6 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  		}
>  	}
>  
> -	/* update phy revision information before calling phy_init() */
> -	ufs_qcom_phy_save_controller_version(host->generic_phy,
> -		host->hw_ver.major, host->hw_ver.minor, host->hw_ver.step);
> -
>  	err = ufs_qcom_init_lane_clks(host);
>  	if (err)
>  		goto out_variant_clear;
> diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
> index 295f4bef6a0e..c114826316eb 100644
> --- a/drivers/scsi/ufs/ufs-qcom.h
> +++ b/drivers/scsi/ufs/ufs-qcom.h
> @@ -129,11 +129,6 @@ enum {
>  	MASK_CLK_NS_REG                     = 0xFFFC00,
>  };
>  
> -enum ufs_qcom_phy_init_type {
> -	UFS_PHY_INIT_FULL,
> -	UFS_PHY_INIT_CFG_RESTORE,
> -};
> -
>  /* QCOM UFS debug print bit mask */
>  #define UFS_QCOM_DBG_PRINT_REGS_EN	BIT(0)
>  #define UFS_QCOM_DBG_PRINT_ICE_REGS_EN	BIT(1)
> diff --git a/include/linux/phy/phy-qcom-ufs.h b/include/linux/phy/phy-qcom-ufs.h
> deleted file mode 100644
> index 9dd85071bcce..000000000000
> --- a/include/linux/phy/phy-qcom-ufs.h
> +++ /dev/null
> @@ -1,24 +0,0 @@
> -/*
> - * Copyright (c) 2013-2015, Linux Foundation. All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 and
> - * only version 2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - */
> -
> -#ifndef PHY_QCOM_UFS_H_
> -#define PHY_QCOM_UFS_H_
> -
> -#include "phy.h"
> -
> -int ufs_qcom_phy_set_tx_lane_enable(struct phy *phy, u32 tx_lanes);
> -void ufs_qcom_phy_save_controller_version(struct phy *phy,
> -			u8 major, u16 minor, u16 step);
> -
> -#endif /* PHY_QCOM_UFS_H_ */
> -- 
> QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> 
