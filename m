From: dovl@codeaurora.org
Subject: Re: [PATCH v7 2/5] phy: qcom-ufs: add support for 20nm phy
Date: Thu, 15 Jan 2015 15:18:17 -0000
Message-ID: <b82598227a967b6bbd32c8a95b37b0cf.squirrel@www.codeaurora.org>
References: <1421332359-31785-1-git-send-email-ygardi@codeaurora.org>
    <1421332359-31785-3-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1421332359-31785-3-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, noag@codeaurora.org, draviv@codeaurora.org, Kishon Vijay Abraham I <kishon@ti.com>, Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>, "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Reviewed-by: Dov Levenglick <dovl@codeaurora.org>

> This change adds a support for a 20nm qcom-ufs phy that is required in
> platforms that use ufs-qcom controller.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/phy/Makefile                |   1 +
>  drivers/phy/phy-qcom-ufs-i.h        |  43 +++++-
>  drivers/phy/phy-qcom-ufs-qmp-20nm.c | 257
> ++++++++++++++++++++++++++++++++++++
>  drivers/phy/phy-qcom-ufs-qmp-20nm.h | 235
> +++++++++++++++++++++++++++++++++
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
> @@ -35,3 +35,4 @@ obj-$(CONFIG_PHY_XGENE)			+=
> phy-xgene.o
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
> +		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0)
> { \
> +			(val) = readl(addr); \
> +			break; \
> +		} \
> +		if (sleep_us) \
> +			usleep_range(DIV_ROUND_UP(sleep_us, 4), sleep_us);
> \
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
> diff --git a/drivers/phy/phy-qcom-ufs-qmp-20nm.c
> b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
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
> +int ufs_qcom_phy_qmp_20nm_phy_calibrate(struct ufs_qcom_phy
> *ufs_qcom_phy,
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
> +	} else if ((major == 0x1) && (minor == 0x003) && (step == 0x0000))
> {
> +		tbl_size_A = ARRAY_SIZE(phy_cal_table_rate_A_1_3_0);
> +		tbl_A = phy_cal_table_rate_A_1_3_0;
> +	} else {
> +		dev_err(ufs_qcom_phy->dev, "%s: Unknown UFS-PHY version,
> no calibration values\n",
> +			__func__);
> +		err = -ENODEV;
> +		goto out;
> +	}
> +
> +	tbl_size_B = ARRAY_SIZE(phy_cal_table_rate_B);
> +	tbl_B = phy_cal_table_rate_B;
> +
> +	err = ufs_qcom_phy_calibrate(ufs_qcom_phy, tbl_A, tbl_size_A,
> +						tbl_B, tbl_size_B,
> is_rate_B);
> +
> +	if (err)
> +		dev_err(ufs_qcom_phy->dev, "%s: ufs_qcom_phy_calibrate()
> failed %d\n",
> +			__func__, err);
> +
> +out:
> +	return err;
> +}
> +
> +static
> +void ufs_qcom_phy_qmp_20nm_advertise_quirks(struct ufs_qcom_phy
> *phy_common)
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
> +		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_clks()
> failed %d\n",
> +			__func__, err);
> +		goto out;
> +	}
> +
> +	err = ufs_qcom_phy_init_vregulators(generic_phy, phy_common);
> +	if (err) {
> +		dev_err(phy_common->dev, "%s:
> ufs_qcom_phy_init_vregulators() failed %d\n",
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
> +void ufs_qcom_phy_qmp_20nm_power_control(struct ufs_qcom_phy *phy, bool
> val)
> +{
> +	bool hibern8_exit_after_pwr_collapse = phy->quirks &
> +		UFS_QCOM_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE;
> +
> +	if (val) {
> +		writel_relaxed(0x1, phy->mmio +
> UFS_PHY_POWER_DOWN_CONTROL);
> +		/*
> +		 * Before any transactions involving PHY, ensure PHY knows
> +		 * that it's analog rail is powered ON.
> +		 */
> +		mb();
> +
> +		if (hibern8_exit_after_pwr_collapse) {
> +			/*
> +			 * Give atleast 1us delay after restoring PHY
> analog
> +			 * power.
> +			 */
> +			usleep_range(1, 2);
> +			writel_relaxed(0x0A, phy->mmio +
> +				       QSERDES_COM_SYSCLK_EN_SEL_TXBAND);
> +			writel_relaxed(0x08, phy->mmio +
> +				       QSERDES_COM_SYSCLK_EN_SEL_TXBAND);
> +			/*
> +			 * Make sure workaround is deactivated before
> proceeding
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
> +			 * Make sure that above workaround is activated
> before
> +			 * PHY analog power collapse.
> +			 */
> +			mb();
> +		}
> +
> +		writel_relaxed(0x0, phy->mmio +
> UFS_PHY_POWER_DOWN_CONTROL);
> +		/*
> +		 * ensure that PHY knows its PHY analog rail is going
> +		 * to be powered down
> +		 */
> +		mb();
> +	}
> +}
> +
> +static
> +void ufs_qcom_phy_qmp_20nm_set_tx_lane_enable(struct ufs_qcom_phy *phy,
> u32 val)
> +{
> +	writel_relaxed(val & UFS_PHY_TX_LANE_ENABLE_MASK,
> +			phy->mmio + UFS_PHY_TX_LANE_ENABLE);
> +	mb();
> +}
> +
> +static inline void ufs_qcom_phy_qmp_20nm_start_serdes(struct ufs_qcom_phy
> *phy)
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
> +static int ufs_qcom_phy_qmp_20nm_is_pcs_ready(struct ufs_qcom_phy
> *phy_common)
> +{
> +	int err = 0;
> +	u32 val;
> +
> +	err = readl_poll_timeout(phy_common->mmio +
> UFS_PHY_PCS_READY_STATUS,
> +			val, (val & MASK_PCS_READY), 10, 1000000);
> +	if (err)
> +		dev_err(phy_common->dev, "%s: poll for pcs failed err =
> %d\n",
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
> +	.is_physical_coding_sublayer_ready =
> ufs_qcom_phy_qmp_20nm_is_pcs_ready,
> +	.set_tx_lane_enable	=
> ufs_qcom_phy_qmp_20nm_set_tx_lane_enable,
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
> +				&ufs_qcom_phy_qmp_20nm_phy_ops,
> &phy_20nm_ops);
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
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, ufs_qcom_phy_qmp_20nm_of_match);
> +
> +static struct platform_driver ufs_qcom_phy_qmp_20nm_driver = {
> +	.probe = ufs_qcom_phy_qmp_20nm_probe,
> +	.remove = ufs_qcom_phy_qmp_20nm_remove,
> +	.driver = {
> +		.of_match_table = ufs_qcom_phy_qmp_20nm_of_match,
> +		.name = "ufs_qcom_phy_qmp_20nm",
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +module_platform_driver(ufs_qcom_phy_qmp_20nm_driver);
> +
> +MODULE_DESCRIPTION("Universal Flash Storage (UFS) QCOM PHY QMP 20nm");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/phy/phy-qcom-ufs-qmp-20nm.h
> b/drivers/phy/phy-qcom-ufs-qmp-20nm.h
> new file mode 100644
> index 0000000..4f3076b
> --- /dev/null
> +++ b/drivers/phy/phy-qcom-ufs-qmp-20nm.h
> @@ -0,0 +1,235 @@
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
> +#ifndef UFS_QCOM_PHY_QMP_20NM_H_
> +#define UFS_QCOM_PHY_QMP_20NM_H_
> +
> +#include "phy-qcom-ufs-i.h"
> +
> +/* QCOM UFS PHY control registers */
> +
> +#define COM_OFF(x)     (0x000 + x)
> +#define PHY_OFF(x)     (0xC00 + x)
> +#define TX_OFF(n, x)   (0x400 + (0x400 * n) + x)
> +#define RX_OFF(n, x)   (0x600 + (0x400 * n) + x)
> +
> +/* UFS PHY PLL block registers */
> +#define QSERDES_COM_SYS_CLK_CTRL		COM_OFF(0x0)
> +#define QSERDES_COM_PLL_VCOTAIL_EN		COM_OFF(0x04)
> +#define QSERDES_COM_PLL_CNTRL			COM_OFF(0x14)
> +#define QSERDES_COM_PLL_IP_SETI			COM_OFF(0x24)
> +#define QSERDES_COM_CORE_CLK_IN_SYNC_SEL	COM_OFF(0x28)
> +#define QSERDES_COM_BIAS_EN_CLKBUFLR_EN		COM_OFF(0x30)
> +#define QSERDES_COM_PLL_CP_SETI			COM_OFF(0x34)
> +#define QSERDES_COM_PLL_IP_SETP			COM_OFF(0x38)
> +#define QSERDES_COM_PLL_CP_SETP			COM_OFF(0x3C)
> +#define QSERDES_COM_SYSCLK_EN_SEL_TXBAND	COM_OFF(0x48)
> +#define QSERDES_COM_RESETSM_CNTRL		COM_OFF(0x4C)
> +#define QSERDES_COM_RESETSM_CNTRL2		COM_OFF(0x50)
> +#define QSERDES_COM_PLLLOCK_CMP1		COM_OFF(0x90)
> +#define QSERDES_COM_PLLLOCK_CMP2		COM_OFF(0x94)
> +#define QSERDES_COM_PLLLOCK_CMP3		COM_OFF(0x98)
> +#define QSERDES_COM_PLLLOCK_CMP_EN		COM_OFF(0x9C)
> +#define QSERDES_COM_BGTC			COM_OFF(0xA0)
> +#define QSERDES_COM_DEC_START1			COM_OFF(0xAC)
> +#define QSERDES_COM_PLL_AMP_OS			COM_OFF(0xB0)
> +#define QSERDES_COM_RES_CODE_UP_OFFSET		COM_OFF(0xD8)
> +#define QSERDES_COM_RES_CODE_DN_OFFSET		COM_OFF(0xDC)
> +#define QSERDES_COM_DIV_FRAC_START1		COM_OFF(0x100)
> +#define QSERDES_COM_DIV_FRAC_START2		COM_OFF(0x104)
> +#define QSERDES_COM_DIV_FRAC_START3		COM_OFF(0x108)
> +#define QSERDES_COM_DEC_START2			COM_OFF(0x10C)
> +#define QSERDES_COM_PLL_RXTXEPCLK_EN		COM_OFF(0x110)
> +#define QSERDES_COM_PLL_CRCTRL			COM_OFF(0x114)
> +#define QSERDES_COM_PLL_CLKEPDIV		COM_OFF(0x118)
> +
> +/* TX LANE n (0, 1) registers */
> +#define QSERDES_TX_EMP_POST1_LVL(n)		TX_OFF(n, 0x08)
> +#define QSERDES_TX_DRV_LVL(n)			TX_OFF(n, 0x0C)
> +#define QSERDES_TX_LANE_MODE(n)			TX_OFF(n, 0x54)
> +
> +/* RX LANE n (0, 1) registers */
> +#define QSERDES_RX_CDR_CONTROL1(n)		RX_OFF(n, 0x0)
> +#define QSERDES_RX_CDR_CONTROL_HALF(n)		RX_OFF(n, 0x8)
> +#define QSERDES_RX_RX_EQ_GAIN1_LSB(n)		RX_OFF(n, 0xA8)
> +#define QSERDES_RX_RX_EQ_GAIN1_MSB(n)		RX_OFF(n, 0xAC)
> +#define QSERDES_RX_RX_EQ_GAIN2_LSB(n)		RX_OFF(n, 0xB0)
> +#define QSERDES_RX_RX_EQ_GAIN2_MSB(n)		RX_OFF(n, 0xB4)
> +#define QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(n)	RX_OFF(n, 0xBC)
> +#define QSERDES_RX_CDR_CONTROL_QUARTER(n)	RX_OFF(n, 0xC)
> +#define QSERDES_RX_SIGDET_CNTRL(n)		RX_OFF(n, 0x100)
> +
> +/* UFS PHY registers */
> +#define UFS_PHY_PHY_START			PHY_OFF(0x00)
> +#define UFS_PHY_POWER_DOWN_CONTROL		PHY_OFF(0x4)
> +#define UFS_PHY_TX_LANE_ENABLE			PHY_OFF(0x44)
> +#define UFS_PHY_PWM_G1_CLK_DIVIDER		PHY_OFF(0x08)
> +#define UFS_PHY_PWM_G2_CLK_DIVIDER		PHY_OFF(0x0C)
> +#define UFS_PHY_PWM_G3_CLK_DIVIDER		PHY_OFF(0x10)
> +#define UFS_PHY_PWM_G4_CLK_DIVIDER		PHY_OFF(0x14)
> +#define UFS_PHY_CORECLK_PWM_G1_CLK_DIVIDER	PHY_OFF(0x34)
> +#define UFS_PHY_CORECLK_PWM_G2_CLK_DIVIDER	PHY_OFF(0x38)
> +#define UFS_PHY_CORECLK_PWM_G3_CLK_DIVIDER	PHY_OFF(0x3C)
> +#define UFS_PHY_CORECLK_PWM_G4_CLK_DIVIDER	PHY_OFF(0x40)
> +#define UFS_PHY_OMC_STATUS_RDVAL		PHY_OFF(0x68)
> +#define UFS_PHY_LINE_RESET_TIME			PHY_OFF(0x28)
> +#define UFS_PHY_LINE_RESET_GRANULARITY		PHY_OFF(0x2C)
> +#define UFS_PHY_TSYNC_RSYNC_CNTL		PHY_OFF(0x48)
> +#define UFS_PHY_PLL_CNTL			PHY_OFF(0x50)
> +#define UFS_PHY_TX_LARGE_AMP_DRV_LVL		PHY_OFF(0x54)
> +#define UFS_PHY_TX_SMALL_AMP_DRV_LVL		PHY_OFF(0x5C)
> +#define UFS_PHY_TX_LARGE_AMP_POST_EMP_LVL	PHY_OFF(0x58)
> +#define UFS_PHY_TX_SMALL_AMP_POST_EMP_LVL	PHY_OFF(0x60)
> +#define UFS_PHY_CFG_CHANGE_CNT_VAL		PHY_OFF(0x64)
> +#define UFS_PHY_RX_SYNC_WAIT_TIME		PHY_OFF(0x6C)
> +#define UFS_PHY_TX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY	PHY_OFF(0xB4)
> +#define UFS_PHY_RX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY	PHY_OFF(0xE0)
> +#define UFS_PHY_TX_MIN_STALL_NOCONFIG_TIME_CAPABILITY	PHY_OFF(0xB8)
> +#define UFS_PHY_RX_MIN_STALL_NOCONFIG_TIME_CAPABILITY	PHY_OFF(0xE4)
> +#define UFS_PHY_TX_MIN_SAVE_CONFIG_TIME_CAPABILITY	PHY_OFF(0xBC)
> +#define UFS_PHY_RX_MIN_SAVE_CONFIG_TIME_CAPABILITY	PHY_OFF(0xE8)
> +#define UFS_PHY_RX_PWM_BURST_CLOSURE_LENGTH_CAPABILITY	PHY_OFF(0xFC)
> +#define UFS_PHY_RX_MIN_ACTIVATETIME_CAPABILITY		PHY_OFF(0x100)
> +#define UFS_PHY_RX_SIGDET_CTRL3
> PHY_OFF(0x14c)
> +#define UFS_PHY_RMMI_ATTR_CTRL			PHY_OFF(0x160)
> +#define UFS_PHY_RMMI_RX_CFGUPDT_L1	(1 << 7)
> +#define UFS_PHY_RMMI_TX_CFGUPDT_L1	(1 << 6)
> +#define UFS_PHY_RMMI_CFGWR_L1		(1 << 5)
> +#define UFS_PHY_RMMI_CFGRD_L1		(1 << 4)
> +#define UFS_PHY_RMMI_RX_CFGUPDT_L0	(1 << 3)
> +#define UFS_PHY_RMMI_TX_CFGUPDT_L0	(1 << 2)
> +#define UFS_PHY_RMMI_CFGWR_L0		(1 << 1)
> +#define UFS_PHY_RMMI_CFGRD_L0		(1 << 0)
> +#define UFS_PHY_RMMI_ATTRID			PHY_OFF(0x164)
> +#define UFS_PHY_RMMI_ATTRWRVAL			PHY_OFF(0x168)
> +#define UFS_PHY_RMMI_ATTRRDVAL_L0_STATUS	PHY_OFF(0x16C)
> +#define UFS_PHY_RMMI_ATTRRDVAL_L1_STATUS	PHY_OFF(0x170)
> +#define UFS_PHY_PCS_READY_STATUS		PHY_OFF(0x174)
> +
> +#define UFS_PHY_TX_LANE_ENABLE_MASK		0x3
> +
> +/*
> + * This structure represents the 20nm specific phy.
> + * common_cfg MUST remain the first field in this structure
> + * in case extra fields are added. This way, when calling
> + * get_ufs_qcom_phy() of generic phy, we can extract the
> + * common phy structure (struct ufs_qcom_phy) out of it
> + * regardless of the relevant specific phy.
> + */
> +struct ufs_qcom_phy_qmp_20nm {
> +	struct ufs_qcom_phy common_cfg;
> +};
> +
> +static struct ufs_qcom_phy_calibration phy_cal_table_rate_A_1_2_0[] = {
> +	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_POWER_DOWN_CONTROL, 0x01),
> +	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_SIGDET_CTRL3, 0x0D),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_VCOTAIL_EN, 0xe1),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CRCTRL, 0xcc),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_SYSCLK_EN_SEL_TXBAND, 0x08),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CLKEPDIV, 0x03),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_RXTXEPCLK_EN, 0x10),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x82),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START2, 0x03),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1, 0x80),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2, 0x80),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3, 0x40),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0xff),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x19),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP3, 0x00),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP_EN, 0x03),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL, 0x90),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL2, 0x03),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL1(0), 0xf2),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(0), 0x0c),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(0), 0x12),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL1(1), 0xf2),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(1), 0x0c),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(1), 0x12),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB(0), 0xff),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB(0), 0xff),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB(0), 0xff),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB(0), 0x00),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB(1), 0xff),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB(1), 0xff),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB(1), 0xff),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB(1), 0x00),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETI, 0x3f),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETP, 0x1b),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETP, 0x0f),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETI, 0x01),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_EMP_POST1_LVL(0), 0x2F),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_DRV_LVL(0), 0x20),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_EMP_POST1_LVL(1), 0x2F),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_DRV_LVL(1), 0x20),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(0), 0x68),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(1), 0x68),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(1), 0xdc),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(0), 0xdc),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_BIAS_EN_CLKBUFLR_EN, 0x3),
> +};
> +
> +static struct ufs_qcom_phy_calibration phy_cal_table_rate_A_1_3_0[] = {
> +	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_POWER_DOWN_CONTROL, 0x01),
> +	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_SIGDET_CTRL3, 0x0D),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_VCOTAIL_EN, 0xe1),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CRCTRL, 0xcc),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_SYSCLK_EN_SEL_TXBAND, 0x08),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CLKEPDIV, 0x03),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_RXTXEPCLK_EN, 0x10),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x82),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START2, 0x03),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1, 0x80),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2, 0x80),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3, 0x40),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0xff),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x19),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP3, 0x00),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP_EN, 0x03),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL, 0x90),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL2, 0x03),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL1(0), 0xf2),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(0), 0x0c),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(0), 0x12),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL1(1), 0xf2),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(1), 0x0c),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(1), 0x12),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB(0), 0xff),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB(0), 0xff),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB(0), 0xff),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB(0), 0x00),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB(1), 0xff),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB(1), 0xff),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB(1), 0xff),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB(1), 0x00),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETI, 0x2b),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETP, 0x38),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETP, 0x3c),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RES_CODE_UP_OFFSET, 0x02),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RES_CODE_DN_OFFSET, 0x02),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETI, 0x01),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CNTRL, 0x40),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(0), 0x68),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(1), 0x68),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(1), 0xdc),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(0), 0xdc),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_BIAS_EN_CLKBUFLR_EN, 0x3),
> +};
> +
> +static struct ufs_qcom_phy_calibration phy_cal_table_rate_B[] = {
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x98),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0x65),
> +	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x1e),
> +};
> +
> +#endif
> diff --git a/include/linux/phy/phy-qcom-ufs.h
> b/include/linux/phy/phy-qcom-ufs.h
> new file mode 100644
> index 0000000..9d18e9f
> --- /dev/null
> +++ b/include/linux/phy/phy-qcom-ufs.h
> @@ -0,0 +1,59 @@
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
> +#ifndef PHY_QCOM_UFS_H_
> +#define PHY_QCOM_UFS_H_
> +
> +#include "phy.h"
> +
> +/**
> + * ufs_qcom_phy_enable_ref_clk() - Enable the phy
> + * ref clock.
> + * @phy: reference to a generic phy
> + *
> + * returns 0 for success, and non-zero for error.
> + */
> +int ufs_qcom_phy_enable_ref_clk(struct phy *phy);
> +
> +/**
> + * ufs_qcom_phy_disable_ref_clk() - Disable the phy
> + * ref clock.
> + * @phy: reference to a generic phy.
> + */
> +void ufs_qcom_phy_disable_ref_clk(struct phy *phy);
> +
> +/**
> + * ufs_qcom_phy_enable_dev_ref_clk() - Enable the device
> + * ref clock.
> + * @phy: reference to a generic phy.
> + */
> +void ufs_qcom_phy_enable_dev_ref_clk(struct phy *phy);
> +
> +/**
> + * ufs_qcom_phy_disable_dev_ref_clk() - Disable the device
> + * ref clock.
> + * @phy: reference to a generic phy.
> + */
> +void ufs_qcom_phy_disable_dev_ref_clk(struct phy *phy);
> +
> +int ufs_qcom_phy_enable_iface_clk(struct phy *phy);
> +void ufs_qcom_phy_disable_iface_clk(struct phy *phy);
> +int ufs_qcom_phy_start_serdes(struct phy *phy);
> +int ufs_qcom_phy_set_tx_lane_enable(struct phy *phy, u32 tx_lanes);
> +int ufs_qcom_phy_calibrate_phy(struct phy *phy, bool is_rate_B);
> +int ufs_qcom_phy_is_pcs_ready(struct phy *phy);
> +void ufs_qcom_phy_save_controller_version(struct phy *phy,
> +			u8 major, u16 minor, u16 step);
> +
> +#endif /* PHY_QCOM_UFS_H_ */
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
