From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v5 02/11] phy: exynos-ufs: add UFS PHY driver for EXYNOS SoC
Date: Mon, 09 Nov 2015 10:56:18 +0530
Message-ID: <1447046787-480-3-git-send-email-alim.akhtar@samsung.com>
References: <1447046787-480-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1447046787-480-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, gautam.vivek@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org, kishon@ti.com
List-Id: linux-scsi@vger.kernel.org

From: Seungwon Jeon <essuuj@gmail.com>

This patch introduces Exynos UFS PHY driver. This driver
supports to deal with phy calibration and power control
according to UFS host driver's behavior.

Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig                |    7 ++
 drivers/phy/Makefile               |    1 +
 drivers/phy/phy-exynos-ufs.c       |  241 ++++++++++++++++++++++++++++++++++++
 drivers/phy/phy-exynos-ufs.h       |   85 +++++++++++++
 drivers/phy/phy-exynos7-ufs.h      |   89 +++++++++++++
 include/linux/phy/phy-exynos-ufs.h |   85 +++++++++++++
 6 files changed, 508 insertions(+)
 create mode 100644 drivers/phy/phy-exynos-ufs.c
 create mode 100644 drivers/phy/phy-exynos-ufs.h
 create mode 100644 drivers/phy/phy-exynos7-ufs.h
 create mode 100644 include/linux/phy/phy-exynos-ufs.h

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 7eb5859dd035..7d38a92e0297 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -389,4 +389,11 @@ config PHY_CYGNUS_PCIE
 	  Enable this to support the Broadcom Cygnus PCIe PHY.
 	  If unsure, say N.
 
+config PHY_EXYNOS_UFS
+	tristate "EXYNOS SoC series UFS PHY driver"
+	depends on OF && ARCH_EXYNOS || COMPILE_TEST
+	select GENERIC_PHY
+	help
+	  Support for UFS PHY on Samsung EXYNOS chipsets.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 075db1a81aa5..9bec4d1a89e1 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_ARMADA375_USBCLUSTER_PHY)	+= phy-armada375-usb2.o
 obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
 obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
 obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
+obj-$(CONFIG_PHY_EXYNOS_UFS)	+= phy-exynos-ufs.o
 obj-$(CONFIG_PHY_LPC18XX_USB_OTG)	+= phy-lpc18xx-usb-otg.o
 obj-$(CONFIG_PHY_PXA_28NM_USB2)		+= phy-pxa-28nm-usb2.o
 obj-$(CONFIG_PHY_PXA_28NM_HSIC)		+= phy-pxa-28nm-hsic.o
diff --git a/drivers/phy/phy-exynos-ufs.c b/drivers/phy/phy-exynos-ufs.c
new file mode 100644
index 000000000000..cb1aeaa3d4eb
--- /dev/null
+++ b/drivers/phy/phy-exynos-ufs.c
@@ -0,0 +1,241 @@
+/*
+ * UFS PHY driver for Samsung EXYNOS SoC
+ *
+ * Copyright (C) 2015 Samsung Electronics Co., Ltd.
+ * Author: Seungwon Jeon <essuuj@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/phy/phy.h>
+#include <linux/phy/phy-exynos-ufs.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+
+#include "phy-exynos-ufs.h"
+
+#define for_each_phy_lane(phy, i) \
+	for (i = 0; i < (phy)->lane_cnt; i++)
+#define for_each_phy_cfg(cfg) \
+	for (; (cfg)->id; (cfg)++)
+
+#define PHY_DEF_LANE_CNT	1
+
+static void exynos_ufs_phy_config(struct exynos_ufs_phy *phy,
+			const struct exynos_ufs_phy_cfg *cfg, u8 lane)
+{
+	enum {LANE_0, LANE_1}; /* lane index */
+
+	switch (lane) {
+	case LANE_0:
+		writel(cfg->val, (phy)->reg_pma + cfg->off_0);
+		break;
+	case LANE_1:
+		if (cfg->id == PHY_TRSV_BLK)
+			writel(cfg->val, (phy)->reg_pma + cfg->off_1);
+		break;
+	}
+}
+
+static bool match_cfg_to_pwr_mode(u8 desc, u8 required_pwr)
+{
+	if (IS_PWR_MODE_ANY(desc))
+		return true;
+
+	if (IS_PWR_MODE_HS(required_pwr) && IS_PWR_MODE_HS_ANY(desc))
+		return true;
+
+	if (COMP_PWR_MODE(required_pwr, desc))
+		return true;
+
+	if (COMP_PWR_MODE_MD(required_pwr, desc) &&
+	    COMP_PWR_MODE_GEAR(required_pwr, desc) &&
+	    COMP_PWR_MODE_SER(required_pwr, desc))
+		return true;
+
+	return false;
+}
+
+int exynos_ufs_phy_calibrate(struct phy *phy,
+				    enum phy_cfg_tag tag, u8 pwr)
+{
+	struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
+	struct exynos_ufs_phy_cfg **cfgs = ufs_phy->cfg;
+	const struct exynos_ufs_phy_cfg *cfg;
+	int i;
+
+	if (unlikely(tag < CFG_PRE_INIT || tag >= CFG_TAG_MAX)) {
+		dev_err(ufs_phy->dev, "invalid phy config index %d\n", tag);
+		return -EINVAL;
+	}
+
+	cfg = cfgs[tag];
+	if (!cfg)
+		goto out;
+
+	for_each_phy_cfg(cfg) {
+		for_each_phy_lane(ufs_phy, i) {
+			if (match_cfg_to_pwr_mode(cfg->desc, pwr))
+				exynos_ufs_phy_config(ufs_phy, cfg, i);
+		}
+	}
+
+out:
+	return 0;
+}
+
+void exynos_ufs_phy_set_lane_cnt(struct phy *phy, u8 lane_cnt)
+{
+	struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
+
+	ufs_phy->lane_cnt = lane_cnt;
+}
+
+int exynos_ufs_phy_wait_for_lock_acq(struct phy *phy)
+{
+	struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
+	const unsigned int timeout_us = 100000;
+	const unsigned int sleep_us = 10;
+	u32 val;
+	int err;
+
+	err = readl_poll_timeout(
+			ufs_phy->reg_pma + PHY_APB_ADDR(PHY_PLL_LOCK_STATUS),
+			val, (val & PHY_PLL_LOCK_BIT), sleep_us, timeout_us);
+	if (err) {
+		dev_err(ufs_phy->dev,
+			"failed to get phy pll lock acquisition %d\n", err);
+		goto out;
+	}
+
+	err = readl_poll_timeout(
+			ufs_phy->reg_pma + PHY_APB_ADDR(PHY_CDR_LOCK_STATUS),
+			val, (val & PHY_CDR_LOCK_BIT), sleep_us, timeout_us);
+	if (err) {
+		dev_err(ufs_phy->dev,
+			"failed to get phy cdr lock acquisition %d\n", err);
+		goto out;
+	}
+
+out:
+	return err;
+}
+
+static int exynos_ufs_phy_power_on(struct phy *phy)
+{
+	struct exynos_ufs_phy *_phy = get_exynos_ufs_phy(phy);
+
+	exynos_ufs_phy_ctrl_isol(_phy, false);
+	return 0;
+}
+
+static int exynos_ufs_phy_power_off(struct phy *phy)
+{
+	struct exynos_ufs_phy *_phy = get_exynos_ufs_phy(phy);
+
+	exynos_ufs_phy_ctrl_isol(_phy, true);
+	return 0;
+}
+
+static struct phy_ops exynos_ufs_phy_ops = {
+	.power_on	= exynos_ufs_phy_power_on,
+	.power_off	= exynos_ufs_phy_power_off,
+}
+;
+static const struct of_device_id exynos_ufs_phy_match[];
+
+static int exynos_ufs_phy_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	const struct of_device_id *match;
+	struct exynos_ufs_phy *phy;
+	struct phy *gen_phy;
+	struct phy_provider *phy_provider;
+	const struct exynos_ufs_phy_drvdata *drvdata;
+	int err = 0;
+
+	match = of_match_node(exynos_ufs_phy_match, dev->of_node);
+	if (!match) {
+		err = -EINVAL;
+		dev_err(dev, "failed to get match_node\n");
+		goto out;
+	}
+
+	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
+	if (!phy) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "phy-pma");
+	phy->reg_pma = devm_ioremap_resource(dev, res);
+	if (IS_ERR(phy->reg_pma)) {
+		err = PTR_ERR(phy->reg_pma);
+		goto out;
+	}
+
+	phy->reg_pmu = syscon_regmap_lookup_by_phandle(
+				dev->of_node, "samsung,pmu-syscon");
+	if (IS_ERR(phy->reg_pmu)) {
+		err = PTR_ERR(phy->reg_pmu);
+		dev_err(dev, "failed syscon remap for pmu\n");
+		goto out;
+	}
+
+	gen_phy = devm_phy_create(dev, NULL, &exynos_ufs_phy_ops);
+	if (IS_ERR(gen_phy)) {
+		err = PTR_ERR(gen_phy);
+		dev_err(dev, "failed to create PHY for ufs-phy\n");
+		goto out;
+	}
+
+	drvdata = match->data;
+	phy->dev = dev;
+	phy->drvdata = drvdata;
+	phy->cfg = (struct exynos_ufs_phy_cfg **)drvdata->cfg;
+	phy->isol = &drvdata->isol;
+	phy->lane_cnt = PHY_DEF_LANE_CNT;
+
+	phy_set_drvdata(gen_phy, phy);
+
+	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
+	if (IS_ERR(phy_provider)) {
+		err = PTR_ERR(phy_provider);
+		dev_err(dev, "failed to register phy-provider\n");
+		goto out;
+	}
+out:
+	return err;
+}
+
+static const struct of_device_id exynos_ufs_phy_match[] = {
+	{
+		.compatible = "samsung,exynos7-ufs-phy",
+		.data = &exynos7_ufs_phy,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_ufs_phy_match);
+
+static struct platform_driver exynos_ufs_phy_driver = {
+	.probe  = exynos_ufs_phy_probe,
+	.driver = {
+		.name = "exynos-ufs-phy",
+		.of_match_table = exynos_ufs_phy_match,
+	},
+};
+module_platform_driver(exynos_ufs_phy_driver);
+MODULE_DESCRIPTION("EXYNOS SoC UFS PHY Driver");
+MODULE_AUTHOR("Seungwon Jeon <essuuj@gmail.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/phy/phy-exynos-ufs.h b/drivers/phy/phy-exynos-ufs.h
new file mode 100644
index 000000000000..820d879f393c
--- /dev/null
+++ b/drivers/phy/phy-exynos-ufs.h
@@ -0,0 +1,85 @@
+/*
+ * UFS PHY driver for Samsung EXYNOS SoC
+ *
+ * Copyright (C) 2015 Samsung Electronics Co., Ltd.
+ * Author: Seungwon Jeon <essuuj@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef _PHY_EXYNOS_UFS_
+#define _PHY_EXYNOS_UFS_
+
+#define PHY_COMN_BLK	1
+#define PHY_TRSV_BLK	2
+#define END_UFS_PHY_CFG { 0 }
+#define PHY_TRSV_CH_OFFSET	0x30
+#define PHY_APB_ADDR(off)	((off) << 2)
+
+#define PHY_COMN_REG_CFG(o, v, d) {	\
+	.off_0 = PHY_APB_ADDR((o)),	\
+	.off_1 = 0,		\
+	.val = (v),		\
+	.desc = (d),		\
+	.id = PHY_COMN_BLK,	\
+}
+
+#define PHY_TRSV_REG_CFG(o, v, d) {	\
+	.off_0 = PHY_APB_ADDR((o)),	\
+	.off_1 = PHY_APB_ADDR((o) + PHY_TRSV_CH_OFFSET),	\
+	.val = (v),		\
+	.desc = (d),		\
+	.id = PHY_TRSV_BLK,	\
+}
+
+/* UFS PHY registers */
+#define PHY_PLL_LOCK_STATUS	0x1e
+#define PHY_CDR_LOCK_STATUS	0x5e
+
+#define PHY_PLL_LOCK_BIT	BIT(5)
+#define PHY_CDR_LOCK_BIT	BIT(4)
+
+struct exynos_ufs_phy_cfg {
+	u32 off_0;
+	u32 off_1;
+	u32 val;
+	u8 desc;
+	u8 id;
+};
+
+struct exynos_ufs_phy_drvdata {
+	const struct exynos_ufs_phy_cfg **cfg;
+	struct pmu_isol {
+		u32 offset;
+		u32 mask;
+		u32 en;
+	} isol;
+};
+
+struct exynos_ufs_phy {
+	struct device *dev;
+	void __iomem *reg_pma;
+	struct regmap *reg_pmu;
+	const struct exynos_ufs_phy_drvdata *drvdata;
+	struct exynos_ufs_phy_cfg **cfg;
+	const struct pmu_isol *isol;
+	u8 lane_cnt;
+};
+
+static inline struct exynos_ufs_phy *get_exynos_ufs_phy(struct phy *phy)
+{
+	return (struct exynos_ufs_phy *)phy_get_drvdata(phy);
+}
+
+static inline void exynos_ufs_phy_ctrl_isol(
+		struct exynos_ufs_phy *phy, u32 isol)
+{
+	regmap_update_bits(phy->reg_pmu, phy->isol->offset,
+			phy->isol->mask, isol ? 0 : phy->isol->en);
+}
+
+#include "phy-exynos7-ufs.h"
+
+#endif /* _PHY_EXYNOS_UFS_ */
diff --git a/drivers/phy/phy-exynos7-ufs.h b/drivers/phy/phy-exynos7-ufs.h
new file mode 100644
index 000000000000..6cd29d7fb200
--- /dev/null
+++ b/drivers/phy/phy-exynos7-ufs.h
@@ -0,0 +1,89 @@
+/*
+ * UFS PHY driver for Samsung EXYNOS SoC
+ *
+ * Copyright (C) 2015 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef _PHY_EXYNOS7_UFS_H_
+#define _PHY_EXYNOS7_UFS_H_
+
+#include "phy-exynos-ufs.h"
+
+#define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL	0x720
+#define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_MASK	0x1
+#define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_EN	BIT(0)
+
+/* Calibration for phy initialization */
+static const struct exynos_ufs_phy_cfg exynos7_pre_init_cfg[] = {
+	PHY_COMN_REG_CFG(0x00f, 0xfa, PWR_MODE_ANY),
+	PHY_COMN_REG_CFG(0x010, 0x82, PWR_MODE_ANY),
+	PHY_COMN_REG_CFG(0x011, 0x1e, PWR_MODE_ANY),
+	PHY_COMN_REG_CFG(0x017, 0x84, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x035, 0x58, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x036, 0x32, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x037, 0x40, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x03b, 0x83, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x042, 0x88, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x043, 0xa6, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x048, 0x74, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x04c, 0x5b, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x04d, 0x83, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x05c, 0x14, PWR_MODE_ANY),
+	END_UFS_PHY_CFG
+};
+
+static const struct exynos_ufs_phy_cfg exynos7_post_init_cfg[] = {
+	END_UFS_PHY_CFG
+};
+
+/* Calibration for HS mode series A/B */
+static const struct exynos_ufs_phy_cfg exynos7_pre_pwr_hs_cfg[] = {
+	PHY_COMN_REG_CFG(0x00f, 0xfa, PWR_MODE_HS_ANY),
+	PHY_COMN_REG_CFG(0x010, 0x82, PWR_MODE_HS_ANY),
+	PHY_COMN_REG_CFG(0x011, 0x1e, PWR_MODE_HS_ANY),
+	/* Setting order: 1st(0x16, 2nd(0x15) */
+	PHY_COMN_REG_CFG(0x016, 0xff, PWR_MODE_HS_ANY),
+	PHY_COMN_REG_CFG(0x015, 0x80, PWR_MODE_HS_ANY),
+	PHY_COMN_REG_CFG(0x017, 0x94, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG(0x036, 0x32, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG(0x037, 0x43, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG(0x038, 0x3f, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG(0x042, 0x88, PWR_MODE_HS_G2_SER_A),
+	PHY_TRSV_REG_CFG(0x042, 0xbb, PWR_MODE_HS_G2_SER_B),
+	PHY_TRSV_REG_CFG(0x043, 0xa6, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG(0x048, 0x74, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG(0x034, 0x35, PWR_MODE_HS_G2_SER_A),
+	PHY_TRSV_REG_CFG(0x034, 0x36, PWR_MODE_HS_G2_SER_B),
+	PHY_TRSV_REG_CFG(0x035, 0x5b, PWR_MODE_HS_G2_SER_A),
+	PHY_TRSV_REG_CFG(0x035, 0x5c, PWR_MODE_HS_G2_SER_B),
+	END_UFS_PHY_CFG
+};
+
+/* Calibration for HS mode series A/B atfer PMC */
+static const struct exynos_ufs_phy_cfg exynos7_post_pwr_hs_cfg[] = {
+	PHY_COMN_REG_CFG(0x015, 0x00, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG(0x04d, 0x83, PWR_MODE_HS_ANY),
+	END_UFS_PHY_CFG
+};
+
+static const struct exynos_ufs_phy_cfg *exynos7_ufs_phy_cfgs[CFG_TAG_MAX] = {
+	[CFG_PRE_INIT]		= exynos7_pre_init_cfg,
+	[CFG_POST_INIT]		= exynos7_post_init_cfg,
+	[CFG_PRE_PWR_HS]	= exynos7_pre_pwr_hs_cfg,
+	[CFG_POST_PWR_HS]	= exynos7_post_pwr_hs_cfg,
+};
+
+static struct exynos_ufs_phy_drvdata exynos7_ufs_phy = {
+	.cfg = exynos7_ufs_phy_cfgs,
+	.isol = {
+		.offset = EXYNOS7_EMBEDDED_COMBO_PHY_CTRL,
+		.mask = EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_MASK,
+		.en = EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_EN,
+	},
+};
+
+#endif /* _PHY_EXYNOS7_UFS_H_ */
diff --git a/include/linux/phy/phy-exynos-ufs.h b/include/linux/phy/phy-exynos-ufs.h
new file mode 100644
index 000000000000..304df68fb9be
--- /dev/null
+++ b/include/linux/phy/phy-exynos-ufs.h
@@ -0,0 +1,85 @@
+/*
+ * phy-exynos-ufs.h - Header file for the UFS PHY of Exynos SoC
+ *
+ * Copyright (C) 2015 Samsung Electronics Co., Ltd.
+ * Author: Seungwon Jeon <essuuj@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _PHY_EXYNOS_UFS_H_
+#define _PHY_EXYNOS_UFS_H_
+
+#include "phy.h"
+
+/* PHY calibration point */
+enum phy_cfg_tag {
+	CFG_PRE_INIT	= 0,
+	CFG_POST_INIT	= 1,
+	CFG_PRE_PWR_HS	= 2,
+	CFG_POST_PWR_HS	= 3,
+	CFG_TAG_MAX,
+};
+
+/* description for PHY calibration */
+enum {
+	/* applicable to any */
+	PWR_DESC_ANY	= 0,
+	/* mode */
+	PWR_DESC_PWM	= 1,
+	PWR_DESC_HS	= 2,
+	/* series */
+	PWR_DESC_SER_A	= 1,
+	PWR_DESC_SER_B	= 2,
+	/* gear */
+	PWR_DESC_G1	= 1,
+	PWR_DESC_G2	= 2,
+	PWR_DESC_G3	= 3,
+	PWR_DESC_G4	= 4,
+	PWR_DESC_G5	= 5,
+	PWR_DESC_G6	= 6,
+	PWR_DESC_G7	= 7,
+	/* field mask */
+	MD_MASK		= 0x3,
+	SR_MASK		= 0x3,
+	GR_MASK		= 0x7,
+};
+
+#define PWR_MODE(g, s, m)	((((g) & GR_MASK) << 4) |\
+				 (((s) & SR_MASK) << 2) | ((m) & MD_MASK))
+#define PWR_MODE_HS(g, s)	((((g) & GR_MASK) << 4) |\
+				 (((s) & SR_MASK) << 2) | PWR_DESC_HS)
+#define PWR_MODE_HS_G1_ANY	PWR_MODE_HS(PWR_DESC_G1, PWR_DESC_ANY)
+#define PWR_MODE_HS_G1_SER_A	PWR_MODE_HS(PWR_DESC_G1, PWR_DESC_SER_A)
+#define PWR_MODE_HS_G1_SER_B	PWR_MODE_HS(PWR_DESC_G1, PWR_DESC_SER_B)
+#define PWR_MODE_HS_G2_ANY	PWR_MODE_HS(PWR_DESC_G2, PWR_DESC_ANY)
+#define PWR_MODE_HS_G2_SER_A	PWR_MODE_HS(PWR_DESC_G2, PWR_DESC_SER_A)
+#define PWR_MODE_HS_G2_SER_B	PWR_MODE_HS(PWR_DESC_G2, PWR_DESC_SER_B)
+#define PWR_MODE_HS_G3_ANY	PWR_MODE_HS(PWR_DESC_G3, PWR_DESC_ANY)
+#define PWR_MODE_HS_G3_SER_A	PWR_MODE_HS(PWR_DESC_G3, PWR_DESC_SER_A)
+#define PWR_MODE_HS_G3_SER_B	PWR_MODE_HS(PWR_DESC_G3, PWR_DESC_SER_B)
+#define PWR_MODE_HS_ANY		PWR_MODE(PWR_DESC_ANY,\
+					 PWR_DESC_ANY, PWR_DESC_HS)
+#define PWR_MODE_PWM_ANY	PWR_MODE(PWR_DESC_ANY,\
+					 PWR_DESC_ANY, PWR_DESC_PWM)
+#define PWR_MODE_ANY		PWR_MODE(PWR_DESC_ANY,\
+					 PWR_DESC_ANY, PWR_DESC_ANY)
+#define IS_PWR_MODE_HS(d)	(((d) & MD_MASK) == PWR_DESC_HS)
+#define IS_PWR_MODE_PWM(d)	(((d) & MD_MASK) == PWR_DESC_PWM)
+#define IS_PWR_MODE_ANY(d)	((d) == PWR_MODE_ANY)
+#define IS_PWR_MODE_HS_ANY(d)	((d) == PWR_MODE_HS_ANY)
+#define COMP_PWR_MODE(a, b)		((a) == (b))
+#define COMP_PWR_MODE_GEAR(a, b)	((((a) >> 4) & GR_MASK) == \
+					 (((b) >> 4) & GR_MASK))
+#define COMP_PWR_MODE_SER(a, b)		((((a) >> 2) & SR_MASK) == \
+					 (((b) >> 2) & SR_MASK))
+#define COMP_PWR_MODE_MD(a, b)		(((a) & MD_MASK) == ((b) & MD_MASK))
+
+int exynos_ufs_phy_calibrate(struct phy *phy, enum phy_cfg_tag tag, u8 pwr);
+void exynos_ufs_phy_set_lane_cnt(struct phy *phy, u8 lane_cnt);
+int exynos_ufs_phy_wait_for_lock_acq(struct phy *phy);
+
+#endif /* _PHY_EXYNOS_UFS_H_ */
-- 
1.7.10.4
