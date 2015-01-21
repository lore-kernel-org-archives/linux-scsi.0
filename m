From: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v7 2/5] phy: qcom-ufs: add support for 20nm phy
Date: Wed, 21 Jan 2015 15:02:32 +0530
Message-ID: <54BF7230.1050708@ti.com>
References: <1421332359-31785-1-git-send-email-ygardi@codeaurora.org> <1421332359-31785-3-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1421332359-31785-3-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, noag@codeaurora.org, draviv@codeaurora.org, Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>, "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

hi,

On Thursday 15 January 2015 08:02 PM, Yaniv Gardi wrote:
> This change adds a support for a 20nm qcom-ufs phy that is required in
> platforms that use ufs-qcom controller.
> 
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> 
> ---
>  drivers/phy/Makefile                |   1 +
>  drivers/phy/phy-qcom-ufs-i.h        |  43 +++++-
>  drivers/phy/phy-qcom-ufs-qmp-20nm.c | 257 ++++++++++++++++++++++++++++++++++++
>  drivers/phy/phy-qcom-ufs-qmp-20nm.h | 235 +++++++++++++++++++++++++++++++++
>  include/linux/phy/phy-qcom-ufs.h    |  59 +++++++++
>  5 files changed, 594 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.c
>  create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.h
>  create mode 100644 include/linux/phy/phy-qcom-ufs.h
> 
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 335965d..781b2fa 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -35,3 +35,4 @@ obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
>  obj-$(CONFIG_PHY_STIH407_USB)		+= phy-stih407-usb.o
>  obj-$(CONFIG_PHY_STIH41X_USB)		+= phy-stih41x-usb.o
>  obj-$(CONFIG_PHY_QCOM_UFS) 	+= phy-qcom-ufs.o
> +obj-$(CONFIG_PHY_QCOM_UFS) 	+= phy-qcom-ufs-qmp-20nm.o
> diff --git a/drivers/phy/phy-qcom-ufs-i.h b/drivers/phy/phy-qcom-ufs-i.h
> index dac200f..591a391 100644
> --- a/drivers/phy/phy-qcom-ufs-i.h
> +++ b/drivers/phy/phy-qcom-ufs-i.h
> @@ -15,15 +15,56 @@
>  #ifndef UFS_QCOM_PHY_I_H_
>  #define UFS_QCOM_PHY_I_H_
>  
> +#include <linux/module.h>
>  #include <linux/clk.h>
> +#include <linux/regulator/consumer.h>
>  #include <linux/slab.h>
> -#include <linux/phy/phy.h>
> +#include <linux/phy/phy-qcom-ufs.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/delay.h>
>  
> +#define readl_poll_timeout(addr, val, cond, sleep_us, timeout_us) \
> +({ \
> +	ktime_t timeout = ktime_add_us(ktime_get(), timeout_us); \
> +	might_sleep_if(timeout_us); \
> +	for (;;) { \
> +		(val) = readl(addr); \
> +		if (cond) \
> +			break; \
> +		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
> +			(val) = readl(addr); \
> +			break; \
> +		} \
> +		if (sleep_us) \
> +			usleep_range(DIV_ROUND_UP(sleep_us, 4), sleep_us); \
> +	} \
> +	(cond) ? 0 : -ETIMEDOUT; \
> +})
> +
> +#define UFS_QCOM_PHY_CAL_ENTRY(reg, val)	\
> +	{				\
> +		.reg_offset = reg,	\
> +		.cfg_value = val,	\
> +	}
> +
>  #define UFS_QCOM_PHY_NAME_LEN	30
>  
> +enum {
> +	MASK_SERDES_START       = 0x1,
> +	MASK_PCS_READY          = 0x1,
> +};
> +
> +enum {
> +	OFFSET_SERDES_START     = 0x0,
> +};
> +
> +struct ufs_qcom_phy_stored_attributes {
> +	u32 att;
> +	u32 value;
> +};
> +
> +
>  struct ufs_qcom_phy_calibration {
>  	u32 reg_offset;
>  	u32 cfg_value;
> diff --git a/drivers/phy/phy-qcom-ufs-qmp-20nm.c b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
> new file mode 100644
> index 0000000..8332f96
> --- /dev/null
> +++ b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
> @@ -0,0 +1,257 @@
> +/*
> + * Copyright (c) 2013-2015, Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include "phy-qcom-ufs-qmp-20nm.h"
> +
> +#define UFS_PHY_NAME "ufs_phy_qmp_20nm"
> +
> +static
> +int ufs_qcom_phy_qmp_20nm_phy_calibrate(struct ufs_qcom_phy *ufs_qcom_phy,
> +					bool is_rate_B)
> +{
> +	struct ufs_qcom_phy_calibration *tbl_A, *tbl_B;
> +	int tbl_size_A, tbl_size_B;
> +	u8 major = ufs_qcom_phy->host_ctrl_rev_major;
> +	u16 minor = ufs_qcom_phy->host_ctrl_rev_minor;
> +	u16 step = ufs_qcom_phy->host_ctrl_rev_step;
> +	int err;
> +
> +	if ((major == 0x1) && (minor == 0x002) && (step == 0x0000)) {
> +		tbl_size_A = ARRAY_SIZE(phy_cal_table_rate_A_1_2_0);
> +		tbl_A = phy_cal_table_rate_A_1_2_0;
> +	} else if ((major == 0x1) && (minor == 0x003) && (step == 0x0000)) {
> +		tbl_size_A = ARRAY_SIZE(phy_cal_table_rate_A_1_3_0);
> +		tbl_A = phy_cal_table_rate_A_1_3_0;
> +	} else {
> +		dev_err(ufs_qcom_phy->dev, "%s: Unknown UFS-PHY version, no calibration values\n",
> +			__func__);
> +		err = -ENODEV;
> +		goto out;
> +	}
> +
> +	tbl_size_B = ARRAY_SIZE(phy_cal_table_rate_B);
> +	tbl_B = phy_cal_table_rate_B;
> +
> +	err = ufs_qcom_phy_calibrate(ufs_qcom_phy, tbl_A, tbl_size_A,
> +						tbl_B, tbl_size_B, is_rate_B);
> +
> +	if (err)
> +		dev_err(ufs_qcom_phy->dev, "%s: ufs_qcom_phy_calibrate() failed %d\n",
> +			__func__, err);
> +
> +out:
> +	return err;
> +}
> +
> +static
> +void ufs_qcom_phy_qmp_20nm_advertise_quirks(struct ufs_qcom_phy *phy_common)
> +{
> +	phy_common->quirks =
> +		UFS_QCOM_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE;
> +}
> +
> +static int ufs_qcom_phy_qmp_20nm_init(struct phy *generic_phy)
> +{
> +	struct ufs_qcom_phy_qmp_20nm *phy = phy_get_drvdata(generic_phy);
> +	struct ufs_qcom_phy *phy_common = &phy->common_cfg;
> +	int err = 0;
> +
> +	err = ufs_qcom_phy_init_clks(generic_phy, phy_common);
> +	if (err) {
> +		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_clks() failed %d\n",
> +			__func__, err);
> +		goto out;
> +	}
> +
> +	err = ufs_qcom_phy_init_vregulators(generic_phy, phy_common);
> +	if (err) {
> +		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_vregulators() failed %d\n",
> +			__func__, err);
> +		goto out;
> +	}
> +
> +	ufs_qcom_phy_qmp_20nm_advertise_quirks(phy_common);
> +
> +out:
> +	return err;
> +}
> +
> +static
> +void ufs_qcom_phy_qmp_20nm_power_control(struct ufs_qcom_phy *phy, bool val)
> +{
> +	bool hibern8_exit_after_pwr_collapse = phy->quirks &
> +		UFS_QCOM_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE;
> +
> +	if (val) {
> +		writel_relaxed(0x1, phy->mmio + UFS_PHY_POWER_DOWN_CONTROL);
> +		/*
> +		 * Before any transactions involving PHY, ensure PHY knows
> +		 * that it's analog rail is powered ON.
> +		 */
> +		mb();
> +
> +		if (hibern8_exit_after_pwr_collapse) {
> +			/*
> +			 * Give atleast 1us delay after restoring PHY analog
> +			 * power.
> +			 */
> +			usleep_range(1, 2);
> +			writel_relaxed(0x0A, phy->mmio +
> +				       QSERDES_COM_SYSCLK_EN_SEL_TXBAND);
> +			writel_relaxed(0x08, phy->mmio +
> +				       QSERDES_COM_SYSCLK_EN_SEL_TXBAND);
> +			/*
> +			 * Make sure workaround is deactivated before proceeding
> +			 * with normal PHY operations.
> +			 */
> +			mb();
> +		}
> +	} else {
> +		if (hibern8_exit_after_pwr_collapse) {
> +			writel_relaxed(0x0A, phy->mmio +
> +				       QSERDES_COM_SYSCLK_EN_SEL_TXBAND);
> +			writel_relaxed(0x02, phy->mmio +
> +				       QSERDES_COM_SYSCLK_EN_SEL_TXBAND);
> +			/*
> +			 * Make sure that above workaround is activated before
> +			 * PHY analog power collapse.
> +			 */
> +			mb();
> +		}
> +
> +		writel_relaxed(0x0, phy->mmio + UFS_PHY_POWER_DOWN_CONTROL);
> +		/*
> +		 * ensure that PHY knows its PHY analog rail is going
> +		 * to be powered down
> +		 */
> +		mb();
> +	}
> +}
> +
> +static
> +void ufs_qcom_phy_qmp_20nm_set_tx_lane_enable(struct ufs_qcom_phy *phy, u32 val)
> +{
> +	writel_relaxed(val & UFS_PHY_TX_LANE_ENABLE_MASK,
> +			phy->mmio + UFS_PHY_TX_LANE_ENABLE);
> +	mb();
> +}
> +
> +static inline void ufs_qcom_phy_qmp_20nm_start_serdes(struct ufs_qcom_phy *phy)
> +{
> +	u32 tmp;
> +
> +	tmp = readl_relaxed(phy->mmio + UFS_PHY_PHY_START);
> +	tmp &= ~MASK_SERDES_START;
> +	tmp |= (1 << OFFSET_SERDES_START);
> +	writel_relaxed(tmp, phy->mmio + UFS_PHY_PHY_START);
> +	mb();
> +}
> +
> +static int ufs_qcom_phy_qmp_20nm_is_pcs_ready(struct ufs_qcom_phy *phy_common)
> +{
> +	int err = 0;
> +	u32 val;
> +
> +	err = readl_poll_timeout(phy_common->mmio + UFS_PHY_PCS_READY_STATUS,
> +			val, (val & MASK_PCS_READY), 10, 1000000);
> +	if (err)
> +		dev_err(phy_common->dev, "%s: poll for pcs failed err = %d\n",
> +			__func__, err);
> +	return err;
> +}
> +
> +static struct phy_ops ufs_qcom_phy_qmp_20nm_phy_ops = {
> +	.init		= ufs_qcom_phy_qmp_20nm_init,
> +	.exit		= ufs_qcom_phy_exit,
> +	.power_on	= ufs_qcom_phy_power_on,
> +	.power_off	= ufs_qcom_phy_power_off,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static struct ufs_qcom_phy_specific_ops phy_20nm_ops = {
> +	.calibrate_phy		= ufs_qcom_phy_qmp_20nm_phy_calibrate,
> +	.start_serdes		= ufs_qcom_phy_qmp_20nm_start_serdes,
> +	.is_physical_coding_sublayer_ready = ufs_qcom_phy_qmp_20nm_is_pcs_ready,
> +	.set_tx_lane_enable	= ufs_qcom_phy_qmp_20nm_set_tx_lane_enable,
> +	.power_control		= ufs_qcom_phy_qmp_20nm_power_control,
> +};
> +
> +static int ufs_qcom_phy_qmp_20nm_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct phy *generic_phy;
> +	struct ufs_qcom_phy_qmp_20nm *phy;
> +	int err = 0;
> +
> +	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
> +	if (!phy) {
> +		dev_err(dev, "%s: failed to allocate phy\n", __func__);
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	generic_phy = ufs_qcom_phy_generic_probe(pdev, &phy->common_cfg,
> +				&ufs_qcom_phy_qmp_20nm_phy_ops, &phy_20nm_ops);
> +
> +	if (!generic_phy) {
> +		dev_err(dev, "%s: ufs_qcom_phy_generic_probe() failed\n",
> +			__func__);
> +		err = -EIO;
> +		goto out;
> +	}
> +
> +	phy_set_drvdata(generic_phy, phy);
> +
> +	strlcpy(phy->common_cfg.name, UFS_PHY_NAME,
> +			sizeof(phy->common_cfg.name));
> +
> +out:
> +	return err;
> +}
> +
> +static int ufs_qcom_phy_qmp_20nm_remove(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct phy *generic_phy = to_phy(dev);
> +	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
> +	int err = 0;
> +
> +	err = ufs_qcom_phy_remove(generic_phy, ufs_qcom_phy);
> +	if (err)
> +		dev_err(dev, "%s: ufs_qcom_phy_remove failed = %d\n",
> +			__func__, err);
> +
> +	return err;
> +}
> +
> +static const struct of_device_id ufs_qcom_phy_qmp_20nm_of_match[] = {
> +	{.compatible = "qcom,ufs-phy-qmp-20nm"},

Is there a device tree binding documentation for this compatible string?

Please also run checkpatch for your patches.

Thanks
Kishon
