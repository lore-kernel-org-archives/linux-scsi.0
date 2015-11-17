From: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v5 02/11] phy: exynos-ufs: add UFS PHY driver for EXYNOS
 SoC
Date: Tue, 17 Nov 2015 11:46:31 +0530
Message-ID: <564AC63F.1000508@ti.com>
References: <1447046787-480-1-git-send-email-alim.akhtar@samsung.com>
 <1447046787-480-3-git-send-email-alim.akhtar@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447046787-480-3-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, gautam.vivek@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On Monday 09 November 2015 10:56 AM, Alim Akhtar wrote:
> From: Seungwon Jeon <essuuj@gmail.com>
> 
> This patch introduces Exynos UFS PHY driver. This driver
> supports to deal with phy calibration and power control
> according to UFS host driver's behavior.
> 
> Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/phy/Kconfig                |    7 ++
>  drivers/phy/Makefile               |    1 +
>  drivers/phy/phy-exynos-ufs.c       |  241 ++++++++++++++++++++++++++++++++++++
>  drivers/phy/phy-exynos-ufs.h       |   85 +++++++++++++
>  drivers/phy/phy-exynos7-ufs.h      |   89 +++++++++++++
>  include/linux/phy/phy-exynos-ufs.h |   85 +++++++++++++
>  6 files changed, 508 insertions(+)
>  create mode 100644 drivers/phy/phy-exynos-ufs.c
>  create mode 100644 drivers/phy/phy-exynos-ufs.h
>  create mode 100644 drivers/phy/phy-exynos7-ufs.h
>  create mode 100644 include/linux/phy/phy-exynos-ufs.h
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 7eb5859dd035..7d38a92e0297 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -389,4 +389,11 @@ config PHY_CYGNUS_PCIE
>  	  Enable this to support the Broadcom Cygnus PCIe PHY.
>  	  If unsure, say N.
>  
> +config PHY_EXYNOS_UFS
> +	tristate "EXYNOS SoC series UFS PHY driver"
> +	depends on OF && ARCH_EXYNOS || COMPILE_TEST
> +	select GENERIC_PHY
> +	help
> +	  Support for UFS PHY on Samsung EXYNOS chipsets.
> +
>  endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 075db1a81aa5..9bec4d1a89e1 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_ARMADA375_USBCLUSTER_PHY)	+= phy-armada375-usb2.o
>  obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
>  obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
> +obj-$(CONFIG_PHY_EXYNOS_UFS)	+= phy-exynos-ufs.o
>  obj-$(CONFIG_PHY_LPC18XX_USB_OTG)	+= phy-lpc18xx-usb-otg.o
>  obj-$(CONFIG_PHY_PXA_28NM_USB2)		+= phy-pxa-28nm-usb2.o
>  obj-$(CONFIG_PHY_PXA_28NM_HSIC)		+= phy-pxa-28nm-hsic.o
> diff --git a/drivers/phy/phy-exynos-ufs.c b/drivers/phy/phy-exynos-ufs.c
> new file mode 100644
> index 000000000000..cb1aeaa3d4eb
> --- /dev/null
> +++ b/drivers/phy/phy-exynos-ufs.c
> @@ -0,0 +1,241 @@
> +/*
> + * UFS PHY driver for Samsung EXYNOS SoC
> + *
> + * Copyright (C) 2015 Samsung Electronics Co., Ltd.
> + * Author: Seungwon Jeon <essuuj@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/iopoll.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/phy/phy.h>
> +#include <linux/phy/phy-exynos-ufs.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +
> +#include "phy-exynos-ufs.h"
> +
> +#define for_each_phy_lane(phy, i) \
> +	for (i = 0; i < (phy)->lane_cnt; i++)
> +#define for_each_phy_cfg(cfg) \
> +	for (; (cfg)->id; (cfg)++)
> +
> +#define PHY_DEF_LANE_CNT	1
> +
> +static void exynos_ufs_phy_config(struct exynos_ufs_phy *phy,
> +			const struct exynos_ufs_phy_cfg *cfg, u8 lane)
> +{
> +	enum {LANE_0, LANE_1}; /* lane index */
> +
> +	switch (lane) {
> +	case LANE_0:
> +		writel(cfg->val, (phy)->reg_pma + cfg->off_0);
> +		break;
> +	case LANE_1:
> +		if (cfg->id == PHY_TRSV_BLK)
> +			writel(cfg->val, (phy)->reg_pma + cfg->off_1);
> +		break;
> +	}
> +}
> +
> +static bool match_cfg_to_pwr_mode(u8 desc, u8 required_pwr)
> +{
> +	if (IS_PWR_MODE_ANY(desc))
> +		return true;
> +
> +	if (IS_PWR_MODE_HS(required_pwr) && IS_PWR_MODE_HS_ANY(desc))
> +		return true;
> +
> +	if (COMP_PWR_MODE(required_pwr, desc))
> +		return true;
> +
> +	if (COMP_PWR_MODE_MD(required_pwr, desc) &&
> +	    COMP_PWR_MODE_GEAR(required_pwr, desc) &&
> +	    COMP_PWR_MODE_SER(required_pwr, desc))
> +		return true;
> +
> +	return false;
> +}
> +
> +int exynos_ufs_phy_calibrate(struct phy *phy,
> +				    enum phy_cfg_tag tag, u8 pwr)

This is similar to the first version of your patch without EXPORT_SYMBOL.

I think you have to create a new generic PHY_OPS for calibrate PHY while making
sure that it is as generic as possible (which means calibrate_phy shouldn't
have tag and pwr arguments or a strong justification as to why those arguments
are required in a generic API).
> +{
> +	struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
> +	struct exynos_ufs_phy_cfg **cfgs = ufs_phy->cfg;
> +	const struct exynos_ufs_phy_cfg *cfg;
> +	int i;
> +
> +	if (unlikely(tag < CFG_PRE_INIT || tag >= CFG_TAG_MAX)) {
> +		dev_err(ufs_phy->dev, "invalid phy config index %d\n", tag);
> +		return -EINVAL;
> +	}
> +
> +	cfg = cfgs[tag];
> +	if (!cfg)
> +		goto out;
> +
> +	for_each_phy_cfg(cfg) {
> +		for_each_phy_lane(ufs_phy, i) {
> +			if (match_cfg_to_pwr_mode(cfg->desc, pwr))
> +				exynos_ufs_phy_config(ufs_phy, cfg, i);
> +		}
> +	}
> +
> +out:
> +	return 0;
> +}
> +
> +void exynos_ufs_phy_set_lane_cnt(struct phy *phy, u8 lane_cnt)

why can't phy_set_bus_width be reused here?
> +{
> +	struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
> +
> +	ufs_phy->lane_cnt = lane_cnt;
> +}
> +
> +int exynos_ufs_phy_wait_for_lock_acq(struct phy *phy)
> +{

As I mentioned before the only interface to the PHY driver should be using PHY
ops. So ideally the PHY driver should have only static functions.
> +	struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
> +	const unsigned int timeout_us = 100000;
> +	const unsigned int sleep_us = 10;
> +	u32 val;
> +	int err;
> +
> +	err = readl_poll_timeout(
> +			ufs_phy->reg_pma + PHY_APB_ADDR(PHY_PLL_LOCK_STATUS),
> +			val, (val & PHY_PLL_LOCK_BIT), sleep_us, timeout_us);
> +	if (err) {
> +		dev_err(ufs_phy->dev,
> +			"failed to get phy pll lock acquisition %d\n", err);
> +		goto out;
> +	}
> +
> +	err = readl_poll_timeout(
> +			ufs_phy->reg_pma + PHY_APB_ADDR(PHY_CDR_LOCK_STATUS),
> +			val, (val & PHY_CDR_LOCK_BIT), sleep_us, timeout_us);
> +	if (err) {
> +		dev_err(ufs_phy->dev,
> +			"failed to get phy cdr lock acquisition %d\n", err);
> +		goto out;
> +	}
> +
> +out:
> +	return err;
> +}
> +
> +static int exynos_ufs_phy_power_on(struct phy *phy)
> +{
> +	struct exynos_ufs_phy *_phy = get_exynos_ufs_phy(phy);
> +
> +	exynos_ufs_phy_ctrl_isol(_phy, false);
> +	return 0;
> +}
> +
> +static int exynos_ufs_phy_power_off(struct phy *phy)
> +{
> +	struct exynos_ufs_phy *_phy = get_exynos_ufs_phy(phy);
> +
> +	exynos_ufs_phy_ctrl_isol(_phy, true);
> +	return 0;
> +}
> +
> +static struct phy_ops exynos_ufs_phy_ops = {
> +	.power_on	= exynos_ufs_phy_power_on,
> +	.power_off	= exynos_ufs_phy_power_off,
.owner is required for phy_ops.
> +}
> +;
> +static const struct of_device_id exynos_ufs_phy_match[];
> +
> +static int exynos_ufs_phy_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct resource *res;
> +	const struct of_device_id *match;
> +	struct exynos_ufs_phy *phy;
> +	struct phy *gen_phy;
> +	struct phy_provider *phy_provider;
> +	const struct exynos_ufs_phy_drvdata *drvdata;
> +	int err = 0;
> +
> +	match = of_match_node(exynos_ufs_phy_match, dev->of_node);
> +	if (!match) {
> +		err = -EINVAL;
> +		dev_err(dev, "failed to get match_node\n");
> +		goto out;
> +	}
> +
> +	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
> +	if (!phy) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "phy-pma");
> +	phy->reg_pma = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(phy->reg_pma)) {
> +		err = PTR_ERR(phy->reg_pma);
> +		goto out;
> +	}
> +
> +	phy->reg_pmu = syscon_regmap_lookup_by_phandle(
> +				dev->of_node, "samsung,pmu-syscon");
> +	if (IS_ERR(phy->reg_pmu)) {
> +		err = PTR_ERR(phy->reg_pmu);
> +		dev_err(dev, "failed syscon remap for pmu\n");
> +		goto out;
> +	}
> +
> +	gen_phy = devm_phy_create(dev, NULL, &exynos_ufs_phy_ops);
> +	if (IS_ERR(gen_phy)) {
> +		err = PTR_ERR(gen_phy);
> +		dev_err(dev, "failed to create PHY for ufs-phy\n");
> +		goto out;
> +	}
> +
> +	drvdata = match->data;
> +	phy->dev = dev;
> +	phy->drvdata = drvdata;
> +	phy->cfg = (struct exynos_ufs_phy_cfg **)drvdata->cfg;
> +	phy->isol = &drvdata->isol;
> +	phy->lane_cnt = PHY_DEF_LANE_CNT;
> +
> +	phy_set_drvdata(gen_phy, phy);
> +
> +	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
> +	if (IS_ERR(phy_provider)) {
> +		err = PTR_ERR(phy_provider);
> +		dev_err(dev, "failed to register phy-provider\n");
> +		goto out;
> +	}
> +out:
> +	return err;
> +}
> +
> +static const struct of_device_id exynos_ufs_phy_match[] = {
> +	{
> +		.compatible = "samsung,exynos7-ufs-phy",
> +		.data = &exynos7_ufs_phy,
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos_ufs_phy_match);
> +
> +static struct platform_driver exynos_ufs_phy_driver = {
> +	.probe  = exynos_ufs_phy_probe,
> +	.driver = {
> +		.name = "exynos-ufs-phy",
> +		.of_match_table = exynos_ufs_phy_match,
> +	},
> +};
> +module_platform_driver(exynos_ufs_phy_driver);
> +MODULE_DESCRIPTION("EXYNOS SoC UFS PHY Driver");
> +MODULE_AUTHOR("Seungwon Jeon <essuuj@gmail.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/phy/phy-exynos-ufs.h b/drivers/phy/phy-exynos-ufs.h
> new file mode 100644
> index 000000000000..820d879f393c
> --- /dev/null
> +++ b/drivers/phy/phy-exynos-ufs.h
> @@ -0,0 +1,85 @@
> +/*
> + * UFS PHY driver for Samsung EXYNOS SoC
> + *
> + * Copyright (C) 2015 Samsung Electronics Co., Ltd.
> + * Author: Seungwon Jeon <essuuj@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#ifndef _PHY_EXYNOS_UFS_
> +#define _PHY_EXYNOS_UFS_
> +
> +#define PHY_COMN_BLK	1
> +#define PHY_TRSV_BLK	2
> +#define END_UFS_PHY_CFG { 0 }
> +#define PHY_TRSV_CH_OFFSET	0x30
> +#define PHY_APB_ADDR(off)	((off) << 2)
> +
> +#define PHY_COMN_REG_CFG(o, v, d) {	\
> +	.off_0 = PHY_APB_ADDR((o)),	\
> +	.off_1 = 0,		\
> +	.val = (v),		\
> +	.desc = (d),		\
> +	.id = PHY_COMN_BLK,	\
> +}
> +
> +#define PHY_TRSV_REG_CFG(o, v, d) {	\
> +	.off_0 = PHY_APB_ADDR((o)),	\
> +	.off_1 = PHY_APB_ADDR((o) + PHY_TRSV_CH_OFFSET),	\
> +	.val = (v),		\
> +	.desc = (d),		\
> +	.id = PHY_TRSV_BLK,	\
> +}
> +
> +/* UFS PHY registers */
> +#define PHY_PLL_LOCK_STATUS	0x1e
> +#define PHY_CDR_LOCK_STATUS	0x5e
> +
> +#define PHY_PLL_LOCK_BIT	BIT(5)
> +#define PHY_CDR_LOCK_BIT	BIT(4)
> +
> +struct exynos_ufs_phy_cfg {
> +	u32 off_0;
> +	u32 off_1;
> +	u32 val;
> +	u8 desc;
> +	u8 id;
> +};
> +
> +struct exynos_ufs_phy_drvdata {
> +	const struct exynos_ufs_phy_cfg **cfg;
> +	struct pmu_isol {
> +		u32 offset;
> +		u32 mask;
> +		u32 en;
> +	} isol;
> +};
> +
> +struct exynos_ufs_phy {
> +	struct device *dev;
> +	void __iomem *reg_pma;
> +	struct regmap *reg_pmu;
> +	const struct exynos_ufs_phy_drvdata *drvdata;
> +	struct exynos_ufs_phy_cfg **cfg;
> +	const struct pmu_isol *isol;
> +	u8 lane_cnt;
> +};
> +
> +static inline struct exynos_ufs_phy *get_exynos_ufs_phy(struct phy *phy)
> +{
> +	return (struct exynos_ufs_phy *)phy_get_drvdata(phy);
> +}

This wrapper function for phy_get_drvdata is unnecessary.
> +
> +static inline void exynos_ufs_phy_ctrl_isol(
> +		struct exynos_ufs_phy *phy, u32 isol)
> +{
> +	regmap_update_bits(phy->reg_pmu, phy->isol->offset,
> +			phy->isol->mask, isol ? 0 : phy->isol->en);
> +}
> +
> +#include "phy-exynos7-ufs.h"
> +
> +#endif /* _PHY_EXYNOS_UFS_ */
> diff --git a/drivers/phy/phy-exynos7-ufs.h b/drivers/phy/phy-exynos7-ufs.h
> new file mode 100644
> index 000000000000..6cd29d7fb200
> --- /dev/null
> +++ b/drivers/phy/phy-exynos7-ufs.h
> @@ -0,0 +1,89 @@
> +/*
> + * UFS PHY driver for Samsung EXYNOS SoC
> + *
> + * Copyright (C) 2015 Samsung Electronics Co., Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#ifndef _PHY_EXYNOS7_UFS_H_
> +#define _PHY_EXYNOS7_UFS_H_
> +
> +#include "phy-exynos-ufs.h"
> +
> +#define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL	0x720
> +#define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_MASK	0x1
> +#define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_EN	BIT(0)
> +
> +/* Calibration for phy initialization */
> +static const struct exynos_ufs_phy_cfg exynos7_pre_init_cfg[] = {
> +	PHY_COMN_REG_CFG(0x00f, 0xfa, PWR_MODE_ANY),
> +	PHY_COMN_REG_CFG(0x010, 0x82, PWR_MODE_ANY),
> +	PHY_COMN_REG_CFG(0x011, 0x1e, PWR_MODE_ANY),
> +	PHY_COMN_REG_CFG(0x017, 0x84, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x035, 0x58, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x036, 0x32, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x037, 0x40, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x03b, 0x83, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x042, 0x88, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x043, 0xa6, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x048, 0x74, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x04c, 0x5b, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x04d, 0x83, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x05c, 0x14, PWR_MODE_ANY),

Are these the usual PHY calbiration settings swing, deemphasis, bias etc.. If
so, we should think about adding standard dt properties and adding the values
for these setting in dt.

Thanks
Kishon
