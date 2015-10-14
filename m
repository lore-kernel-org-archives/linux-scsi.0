From: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 02/11] phy: exynos-ufs: add UFS PHY driver for EXYNOS SoC
Date: Wed, 14 Oct 2015 18:25:42 +0530
Message-ID: <1444827351-24128-3-git-send-email-alim.akhtar@samsung.com>
References: <1444827351-24128-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1444827351-24128-1-git-send-email-alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: JBottomley-wo1vFcy6AUs@public.gmane.org, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, amit.daniel-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Seungwon Jeon <essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This patch introduces Exynos UFS PHY driver. This driver
supports to deal with phy calibration and power control
according to UFS host driver's behavior.

Signed-off-by: Seungwon Jeon <essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>
---
 drivers/phy/Kconfig                |    7 +
 drivers/phy/Makefile               |    1 +
 drivers/phy/phy-exynos-ufs.c       |  257 ++++++++++++++++++++++++++++++++++++
 drivers/phy/phy-exynos-ufs.h       |   88 ++++++++++++
 drivers/phy/phy-exynos7-ufs.h      |   89 +++++++++++++
 include/linux/phy/phy-exynos-ufs.h |  101 ++++++++++++++
 6 files changed, 543 insertions(+)
 create mode 100644 drivers/phy/phy-exynos-ufs.c
 create mode 100644 drivers/phy/phy-exynos-ufs.h
 create mode 100644 drivers/phy/phy-exynos7-ufs.h
 create mode 100644 include/linux/phy/phy-exynos-ufs.h

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 47da573d0bab..499eec4a967c 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -371,4 +371,11 @@ config PHY_BRCMSTB_SATA
 	  Enable this to support the SATA3 PHY on 28nm Broadcom STB SoCs.
 	  Likely useful only with CONFIG_SATA_BRCMSTB enabled.
 
+config PHY_EXYNOS_UFS
+	tristate "EXYNOS SoC series UFS PHY driver"
+	depends on OF && ARCH_EXYNOS || COMPILE_TEST
+	select GENERIC_PHY
+	help
+	  Support for UFS PHY on Samsung EXYNOS chipsets.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index a5b18c18fc12..2a312ca20795 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -46,3 +46,4 @@ obj-$(CONFIG_PHY_QCOM_UFS) 	+= phy-qcom-ufs-qmp-14nm.o
 obj-$(CONFIG_PHY_TUSB1210)		+= phy-tusb1210.o
 obj-$(CONFIG_PHY_BRCMSTB_SATA)		+= phy-brcmstb-sata.o
 obj-$(CONFIG_PHY_PISTACHIO_USB)		+= phy-pistachio-usb.o
+obj-$(CONFIG_PHY_EXYNOS_UFS)	+= phy-exynos-ufs.o
diff --git a/drivers/phy/phy-exynos-ufs.c b/drivers/phy/phy-exynos-ufs.c
new file mode 100644
index 000000000000..77330b85e3f8
--- /dev/null
+++ b/drivers/phy/phy-exynos-ufs.c
@@ -0,0 +1,257 @@
+/*
+ * UFS PHY driver for Samsung EXYNOS SoC
+ *
+ * Copyright (C) 2015 Samsung Electronics Co., Ltd.
+ * Author: Seungwon Jeon <essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
+static int exynos_ufs_phy_calibrate(struct phy *phy,
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
+static void exynos_ufs_phy_set_lane_cnt(struct phy *phy, u8 lane_cnt)
+{
+	struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
+
+	ufs_phy->lane_cnt = lane_cnt;
+}
+
+static int exynos_ufs_phy_wait_for_lock_acq(struct phy *phy)
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
+};
+
+static struct exynos_ufs_phy_specific_ops phy_specific_ops = {
+	.calibrate_phy = exynos_ufs_phy_calibrate,
+	.set_lane_cnt = exynos_ufs_phy_set_lane_cnt,
+	.wait_for_lock_acq = exynos_ufs_phy_wait_for_lock_acq,
+};
+
+static const struct of_device_id exynos_ufs_phy_match[];
+
+static int exynos_ufs_phy_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	const struct of_device_id *match;
+	struct exynos_ufs_phy *phy;
+	struct exynos_ufs_phy_info *phy_info;
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
+	phy_info = devm_kzalloc(dev, sizeof(*phy_info), GFP_KERNEL);
+	if (!phy_info) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	phy_info->exynos_ufs_privdata = phy;
+	phy_info->phy_specific_ops = &phy_specific_ops;
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
+	phy_set_drvdata(gen_phy, phy_info);
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
+MODULE_AUTHOR("Seungwon Jeon <essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/phy/phy-exynos-ufs.h b/drivers/phy/phy-exynos-ufs.h
new file mode 100644
index 000000000000..a376cf124b22
--- /dev/null
+++ b/drivers/phy/phy-exynos-ufs.h
@@ -0,0 +1,88 @@
+/*
+ * UFS PHY driver for Samsung EXYNOS SoC
+ *
+ * Copyright (C) 2015 Samsung Electronics Co., Ltd.
+ * Author: Seungwon Jeon <essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
+	struct exynos_ufs_phy_info *tmp;
+
+	tmp = phy_get_drvdata(phy);
+	return (struct exynos_ufs_phy *)tmp->exynos_ufs_privdata;
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
index 000000000000..e15bbea50e6e
--- /dev/null
+++ b/include/linux/phy/phy-exynos-ufs.h
@@ -0,0 +1,101 @@
+/*
+ * phy-exynos-ufs.h - Header file for the UFS PHY of Exynos SoC
+ *
+ * Copyright (C) 2015 Samsung Electronics Co., Ltd.
+ * Author: Seungwon Jeon <essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
+/**
+ * struct exynos_ufs_phy_specific_ops - pointers to functions for SoC specific
+ * implementation per phy. Each ufs phy should implement those functions
+ * as per its requirements
+ * @calibrate_phy: pointer to a function to calibrate phy. Returns 0 for
+ * success and non-zero for error.
+ * @set_lane_cnt: pointer to a function to set ufs lane count
+ * @wait_for_lock_acq: pointer to a function which waits for phy PLL lock
+ * acquisition. Returns 0 for success and non-zero for error.
+ */
+struct exynos_ufs_phy_specific_ops {
+	int (*calibrate_phy)(struct phy *phy, enum phy_cfg_tag tag, u8 pwr);
+	void (*set_lane_cnt)(struct phy *phy, u8 lane_cnt);
+	int (*wait_for_lock_acq)(struct phy *phy);
+};
+
+struct exynos_ufs_phy_info {
+	void *exynos_ufs_privdata;
+	struct exynos_ufs_phy_specific_ops *phy_specific_ops;
+};
+#endif /* _PHY_EXYNOS_UFS_H_ */
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
