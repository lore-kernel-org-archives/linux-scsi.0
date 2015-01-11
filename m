From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v6 1/4] phy: qcom-ufs: add support for 20nm phy
Date: Sun, 11 Jan 2015 14:38:06 +0200
Message-ID: <1420979889-22126-2-git-send-email-ygardi@codeaurora.org>
References: <1420979889-22126-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:44624 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbbAKMid (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Jan 2015 07:38:33 -0500
In-Reply-To: <1420979889-22126-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, noag@codeaurora.org, draviv@codeaurora.org, Kishon Vijay Abraham I <kishon@ti.com>, Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>, "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>

This change adds a support for a 20nm qcom-ufs phy that is required in
platforms that use ufs-qcom controller.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/phy/Kconfig                 |   7 +
 drivers/phy/Makefile                |   2 +
 drivers/phy/phy-qcom-ufs-i.h        | 159 ++++++++
 drivers/phy/phy-qcom-ufs-qmp-20nm.c | 257 +++++++++++++
 drivers/phy/phy-qcom-ufs-qmp-20nm.h | 235 ++++++++++++
 drivers/phy/phy-qcom-ufs.c          | 745 ++++++++++++++++++++++++++++++++++++
 include/linux/phy/phy-qcom-ufs.h    |  59 +++
 7 files changed, 1464 insertions(+)
 create mode 100644 drivers/phy/phy-qcom-ufs-i.h
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.c
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.h
 create mode 100644 drivers/phy/phy-qcom-ufs.c
 create mode 100644 include/linux/phy/phy-qcom-ufs.h

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index ccad880..26a7623 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -277,4 +277,11 @@ config PHY_STIH41X_USB
 	  Enable this to support the USB transceiver that is part of
 	  STMicroelectronics STiH41x SoC series.
 
+config PHY_QCOM_UFS
+	tristate "Qualcomm UFS PHY driver"
+	depends on OF && ARCH_MSM
+	select GENERIC_PHY
+	help
+	  Support for UFS PHY on QCOM chipsets.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index aa74f96..781b2fa 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -34,3 +34,5 @@ obj-$(CONFIG_PHY_ST_SPEAR1340_MIPHY)	+= phy-spear1340-miphy.o
 obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
 obj-$(CONFIG_PHY_STIH407_USB)		+= phy-stih407-usb.o
 obj-$(CONFIG_PHY_STIH41X_USB)		+= phy-stih41x-usb.o
+obj-$(CONFIG_PHY_QCOM_UFS) 	+= phy-qcom-ufs.o
+obj-$(CONFIG_PHY_QCOM_UFS) 	+= phy-qcom-ufs-qmp-20nm.o
diff --git a/drivers/phy/phy-qcom-ufs-i.h b/drivers/phy/phy-qcom-ufs-i.h
new file mode 100644
index 0000000..a175069
--- /dev/null
+++ b/drivers/phy/phy-qcom-ufs-i.h
@@ -0,0 +1,159 @@
+/*
+ * Copyright (c) 2013-2015, Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef UFS_QCOM_PHY_I_H_
+#define UFS_QCOM_PHY_I_H_
+
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+
+#include <linux/phy/phy-qcom-ufs.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#define readl_poll_timeout(addr, val, cond, sleep_us, timeout_us) \
+({ \
+	ktime_t timeout = ktime_add_us(ktime_get(), timeout_us); \
+	might_sleep_if(timeout_us); \
+	for (;;) { \
+		(val) = readl(addr); \
+		if (cond) \
+			break; \
+		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
+			(val) = readl(addr); \
+			break; \
+		} \
+		if (sleep_us) \
+			usleep_range(DIV_ROUND_UP(sleep_us, 4), sleep_us); \
+	} \
+	(cond) ? 0 : -ETIMEDOUT; \
+})
+
+#define UFS_QCOM_PHY_CAL_ENTRY(reg, val)	\
+	{				\
+		.reg_offset = reg,	\
+		.cfg_value = val,	\
+	}
+
+#define UFS_QCOM_PHY_NAME_LEN	30
+
+enum {
+	MASK_SERDES_START       = 0x1,
+	MASK_PCS_READY          = 0x1,
+};
+
+enum {
+	OFFSET_SERDES_START     = 0x0,
+};
+
+struct ufs_qcom_phy_stored_attributes {
+	u32 att;
+	u32 value;
+};
+
+struct ufs_qcom_phy_calibration {
+	u32 reg_offset;
+	u32 cfg_value;
+};
+
+struct ufs_qcom_phy_vreg {
+	const char *name;
+	struct regulator *reg;
+	int max_uA;
+	int min_uV;
+	int max_uV;
+	bool enabled;
+	bool is_always_on;
+};
+
+struct ufs_qcom_phy {
+	struct list_head list;
+	struct device *dev;
+	void __iomem *mmio;
+	void __iomem *dev_ref_clk_ctrl_mmio;
+	struct clk *tx_iface_clk;
+	struct clk *rx_iface_clk;
+	bool is_iface_clk_enabled;
+	struct clk *ref_clk_src;
+	struct clk *ref_clk_parent;
+	struct clk *ref_clk;
+	bool is_ref_clk_enabled;
+	bool is_dev_ref_clk_enabled;
+	struct ufs_qcom_phy_vreg vdda_pll;
+	struct ufs_qcom_phy_vreg vdda_phy;
+	struct ufs_qcom_phy_vreg vddp_ref_clk;
+	unsigned int quirks;
+
+	/*
+	* If UFS link is put into Hibern8 and if UFS PHY analog hardware is
+	* power collapsed (by clearing UFS_PHY_POWER_DOWN_CONTROL), Hibern8
+	* exit might fail even after powering on UFS PHY analog hardware.
+	* Enabling this quirk will help to solve above issue by doing
+	* custom PHY settings just before PHY analog power collapse.
+	*/
+	#define UFS_QCOM_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE	BIT(0)
+
+	u8 host_ctrl_rev_major;
+	u16 host_ctrl_rev_minor;
+	u16 host_ctrl_rev_step;
+
+	char name[UFS_QCOM_PHY_NAME_LEN];
+	struct ufs_qcom_phy_calibration *cached_regs;
+	int cached_regs_table_size;
+	bool is_powered_on;
+	struct ufs_qcom_phy_specific_ops *phy_spec_ops;
+};
+
+/**
+ * struct ufs_qcom_phy_specific_ops - set of pointers to functions which have a
+ * specific implementation per phy. Each UFS phy, should implement
+ * those functions according to its spec and requirements
+ * @calibrate_phy: pointer to a function that calibrate the phy
+ * @start_serdes: pointer to a function that starts the serdes
+ * @is_physical_coding_sublayer_ready: pointer to a function that
+ * checks pcs readiness. returns 0 for success and non-zero for error.
+ * @set_tx_lane_enable: pointer to a function that enable tx lanes
+ * @power_control: pointer to a function that controls analog rail of phy
+ * and writes to QSERDES_RX_SIGDET_CNTRL attribute
+ */
+struct ufs_qcom_phy_specific_ops {
+	int (*calibrate_phy)(struct ufs_qcom_phy *phy, bool is_rate_B);
+	void (*start_serdes)(struct ufs_qcom_phy *phy);
+	int (*is_physical_coding_sublayer_ready)(struct ufs_qcom_phy *phy);
+	void (*set_tx_lane_enable)(struct ufs_qcom_phy *phy, u32 val);
+	void (*power_control)(struct ufs_qcom_phy *phy, bool val);
+};
+
+struct ufs_qcom_phy *get_ufs_qcom_phy(struct phy *generic_phy);
+int ufs_qcom_phy_power_on(struct phy *generic_phy);
+int ufs_qcom_phy_power_off(struct phy *generic_phy);
+int ufs_qcom_phy_exit(struct phy *generic_phy);
+int ufs_qcom_phy_init_clks(struct phy *generic_phy,
+			struct ufs_qcom_phy *phy_common);
+int ufs_qcom_phy_init_vregulators(struct phy *generic_phy,
+			struct ufs_qcom_phy *phy_common);
+int ufs_qcom_phy_remove(struct phy *generic_phy,
+		       struct ufs_qcom_phy *ufs_qcom_phy);
+struct phy *ufs_qcom_phy_generic_probe(struct platform_device *pdev,
+			struct ufs_qcom_phy *common_cfg,
+			struct phy_ops *ufs_qcom_phy_gen_ops,
+			struct ufs_qcom_phy_specific_ops *phy_spec_ops);
+int ufs_qcom_phy_calibrate(struct ufs_qcom_phy *ufs_qcom_phy,
+			struct ufs_qcom_phy_calibration *tbl_A, int tbl_size_A,
+			struct ufs_qcom_phy_calibration *tbl_B, int tbl_size_B,
+			bool is_rate_B);
+#endif
diff --git a/drivers/phy/phy-qcom-ufs-qmp-20nm.c b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
new file mode 100644
index 0000000..8332f96
--- /dev/null
+++ b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
@@ -0,0 +1,257 @@
+/*
+ * Copyright (c) 2013-2015, Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include "phy-qcom-ufs-qmp-20nm.h"
+
+#define UFS_PHY_NAME "ufs_phy_qmp_20nm"
+
+static
+int ufs_qcom_phy_qmp_20nm_phy_calibrate(struct ufs_qcom_phy *ufs_qcom_phy,
+					bool is_rate_B)
+{
+	struct ufs_qcom_phy_calibration *tbl_A, *tbl_B;
+	int tbl_size_A, tbl_size_B;
+	u8 major = ufs_qcom_phy->host_ctrl_rev_major;
+	u16 minor = ufs_qcom_phy->host_ctrl_rev_minor;
+	u16 step = ufs_qcom_phy->host_ctrl_rev_step;
+	int err;
+
+	if ((major == 0x1) && (minor == 0x002) && (step == 0x0000)) {
+		tbl_size_A = ARRAY_SIZE(phy_cal_table_rate_A_1_2_0);
+		tbl_A = phy_cal_table_rate_A_1_2_0;
+	} else if ((major == 0x1) && (minor == 0x003) && (step == 0x0000)) {
+		tbl_size_A = ARRAY_SIZE(phy_cal_table_rate_A_1_3_0);
+		tbl_A = phy_cal_table_rate_A_1_3_0;
+	} else {
+		dev_err(ufs_qcom_phy->dev, "%s: Unknown UFS-PHY version, no calibration values\n",
+			__func__);
+		err = -ENODEV;
+		goto out;
+	}
+
+	tbl_size_B = ARRAY_SIZE(phy_cal_table_rate_B);
+	tbl_B = phy_cal_table_rate_B;
+
+	err = ufs_qcom_phy_calibrate(ufs_qcom_phy, tbl_A, tbl_size_A,
+						tbl_B, tbl_size_B, is_rate_B);
+
+	if (err)
+		dev_err(ufs_qcom_phy->dev, "%s: ufs_qcom_phy_calibrate() failed %d\n",
+			__func__, err);
+
+out:
+	return err;
+}
+
+static
+void ufs_qcom_phy_qmp_20nm_advertise_quirks(struct ufs_qcom_phy *phy_common)
+{
+	phy_common->quirks =
+		UFS_QCOM_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE;
+}
+
+static int ufs_qcom_phy_qmp_20nm_init(struct phy *generic_phy)
+{
+	struct ufs_qcom_phy_qmp_20nm *phy = phy_get_drvdata(generic_phy);
+	struct ufs_qcom_phy *phy_common = &phy->common_cfg;
+	int err = 0;
+
+	err = ufs_qcom_phy_init_clks(generic_phy, phy_common);
+	if (err) {
+		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_clks() failed %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	err = ufs_qcom_phy_init_vregulators(generic_phy, phy_common);
+	if (err) {
+		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_vregulators() failed %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	ufs_qcom_phy_qmp_20nm_advertise_quirks(phy_common);
+
+out:
+	return err;
+}
+
+static
+void ufs_qcom_phy_qmp_20nm_power_control(struct ufs_qcom_phy *phy, bool val)
+{
+	bool hibern8_exit_after_pwr_collapse = phy->quirks &
+		UFS_QCOM_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE;
+
+	if (val) {
+		writel_relaxed(0x1, phy->mmio + UFS_PHY_POWER_DOWN_CONTROL);
+		/*
+		 * Before any transactions involving PHY, ensure PHY knows
+		 * that it's analog rail is powered ON.
+		 */
+		mb();
+
+		if (hibern8_exit_after_pwr_collapse) {
+			/*
+			 * Give atleast 1us delay after restoring PHY analog
+			 * power.
+			 */
+			usleep_range(1, 2);
+			writel_relaxed(0x0A, phy->mmio +
+				       QSERDES_COM_SYSCLK_EN_SEL_TXBAND);
+			writel_relaxed(0x08, phy->mmio +
+				       QSERDES_COM_SYSCLK_EN_SEL_TXBAND);
+			/*
+			 * Make sure workaround is deactivated before proceeding
+			 * with normal PHY operations.
+			 */
+			mb();
+		}
+	} else {
+		if (hibern8_exit_after_pwr_collapse) {
+			writel_relaxed(0x0A, phy->mmio +
+				       QSERDES_COM_SYSCLK_EN_SEL_TXBAND);
+			writel_relaxed(0x02, phy->mmio +
+				       QSERDES_COM_SYSCLK_EN_SEL_TXBAND);
+			/*
+			 * Make sure that above workaround is activated before
+			 * PHY analog power collapse.
+			 */
+			mb();
+		}
+
+		writel_relaxed(0x0, phy->mmio + UFS_PHY_POWER_DOWN_CONTROL);
+		/*
+		 * ensure that PHY knows its PHY analog rail is going
+		 * to be powered down
+		 */
+		mb();
+	}
+}
+
+static
+void ufs_qcom_phy_qmp_20nm_set_tx_lane_enable(struct ufs_qcom_phy *phy, u32 val)
+{
+	writel_relaxed(val & UFS_PHY_TX_LANE_ENABLE_MASK,
+			phy->mmio + UFS_PHY_TX_LANE_ENABLE);
+	mb();
+}
+
+static inline void ufs_qcom_phy_qmp_20nm_start_serdes(struct ufs_qcom_phy *phy)
+{
+	u32 tmp;
+
+	tmp = readl_relaxed(phy->mmio + UFS_PHY_PHY_START);
+	tmp &= ~MASK_SERDES_START;
+	tmp |= (1 << OFFSET_SERDES_START);
+	writel_relaxed(tmp, phy->mmio + UFS_PHY_PHY_START);
+	mb();
+}
+
+static int ufs_qcom_phy_qmp_20nm_is_pcs_ready(struct ufs_qcom_phy *phy_common)
+{
+	int err = 0;
+	u32 val;
+
+	err = readl_poll_timeout(phy_common->mmio + UFS_PHY_PCS_READY_STATUS,
+			val, (val & MASK_PCS_READY), 10, 1000000);
+	if (err)
+		dev_err(phy_common->dev, "%s: poll for pcs failed err = %d\n",
+			__func__, err);
+	return err;
+}
+
+static struct phy_ops ufs_qcom_phy_qmp_20nm_phy_ops = {
+	.init		= ufs_qcom_phy_qmp_20nm_init,
+	.exit		= ufs_qcom_phy_exit,
+	.power_on	= ufs_qcom_phy_power_on,
+	.power_off	= ufs_qcom_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+static struct ufs_qcom_phy_specific_ops phy_20nm_ops = {
+	.calibrate_phy		= ufs_qcom_phy_qmp_20nm_phy_calibrate,
+	.start_serdes		= ufs_qcom_phy_qmp_20nm_start_serdes,
+	.is_physical_coding_sublayer_ready = ufs_qcom_phy_qmp_20nm_is_pcs_ready,
+	.set_tx_lane_enable	= ufs_qcom_phy_qmp_20nm_set_tx_lane_enable,
+	.power_control		= ufs_qcom_phy_qmp_20nm_power_control,
+};
+
+static int ufs_qcom_phy_qmp_20nm_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct phy *generic_phy;
+	struct ufs_qcom_phy_qmp_20nm *phy;
+	int err = 0;
+
+	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
+	if (!phy) {
+		dev_err(dev, "%s: failed to allocate phy\n", __func__);
+		err = -ENOMEM;
+		goto out;
+	}
+
+	generic_phy = ufs_qcom_phy_generic_probe(pdev, &phy->common_cfg,
+				&ufs_qcom_phy_qmp_20nm_phy_ops, &phy_20nm_ops);
+
+	if (!generic_phy) {
+		dev_err(dev, "%s: ufs_qcom_phy_generic_probe() failed\n",
+			__func__);
+		err = -EIO;
+		goto out;
+	}
+
+	phy_set_drvdata(generic_phy, phy);
+
+	strlcpy(phy->common_cfg.name, UFS_PHY_NAME,
+			sizeof(phy->common_cfg.name));
+
+out:
+	return err;
+}
+
+static int ufs_qcom_phy_qmp_20nm_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct phy *generic_phy = to_phy(dev);
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
+	int err = 0;
+
+	err = ufs_qcom_phy_remove(generic_phy, ufs_qcom_phy);
+	if (err)
+		dev_err(dev, "%s: ufs_qcom_phy_remove failed = %d\n",
+			__func__, err);
+
+	return err;
+}
+
+static const struct of_device_id ufs_qcom_phy_qmp_20nm_of_match[] = {
+	{.compatible = "qcom,ufs-phy-qmp-20nm"},
+	{},
+};
+MODULE_DEVICE_TABLE(of, ufs_qcom_phy_qmp_20nm_of_match);
+
+static struct platform_driver ufs_qcom_phy_qmp_20nm_driver = {
+	.probe = ufs_qcom_phy_qmp_20nm_probe,
+	.remove = ufs_qcom_phy_qmp_20nm_remove,
+	.driver = {
+		.of_match_table = ufs_qcom_phy_qmp_20nm_of_match,
+		.name = "ufs_qcom_phy_qmp_20nm",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_platform_driver(ufs_qcom_phy_qmp_20nm_driver);
+
+MODULE_DESCRIPTION("Universal Flash Storage (UFS) QCOM PHY QMP 20nm");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/phy/phy-qcom-ufs-qmp-20nm.h b/drivers/phy/phy-qcom-ufs-qmp-20nm.h
new file mode 100644
index 0000000..4f3076b
--- /dev/null
+++ b/drivers/phy/phy-qcom-ufs-qmp-20nm.h
@@ -0,0 +1,235 @@
+/*
+ * Copyright (c) 2013-2015, Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef UFS_QCOM_PHY_QMP_20NM_H_
+#define UFS_QCOM_PHY_QMP_20NM_H_
+
+#include "phy-qcom-ufs-i.h"
+
+/* QCOM UFS PHY control registers */
+
+#define COM_OFF(x)     (0x000 + x)
+#define PHY_OFF(x)     (0xC00 + x)
+#define TX_OFF(n, x)   (0x400 + (0x400 * n) + x)
+#define RX_OFF(n, x)   (0x600 + (0x400 * n) + x)
+
+/* UFS PHY PLL block registers */
+#define QSERDES_COM_SYS_CLK_CTRL		COM_OFF(0x0)
+#define QSERDES_COM_PLL_VCOTAIL_EN		COM_OFF(0x04)
+#define QSERDES_COM_PLL_CNTRL			COM_OFF(0x14)
+#define QSERDES_COM_PLL_IP_SETI			COM_OFF(0x24)
+#define QSERDES_COM_CORE_CLK_IN_SYNC_SEL	COM_OFF(0x28)
+#define QSERDES_COM_BIAS_EN_CLKBUFLR_EN		COM_OFF(0x30)
+#define QSERDES_COM_PLL_CP_SETI			COM_OFF(0x34)
+#define QSERDES_COM_PLL_IP_SETP			COM_OFF(0x38)
+#define QSERDES_COM_PLL_CP_SETP			COM_OFF(0x3C)
+#define QSERDES_COM_SYSCLK_EN_SEL_TXBAND	COM_OFF(0x48)
+#define QSERDES_COM_RESETSM_CNTRL		COM_OFF(0x4C)
+#define QSERDES_COM_RESETSM_CNTRL2		COM_OFF(0x50)
+#define QSERDES_COM_PLLLOCK_CMP1		COM_OFF(0x90)
+#define QSERDES_COM_PLLLOCK_CMP2		COM_OFF(0x94)
+#define QSERDES_COM_PLLLOCK_CMP3		COM_OFF(0x98)
+#define QSERDES_COM_PLLLOCK_CMP_EN		COM_OFF(0x9C)
+#define QSERDES_COM_BGTC			COM_OFF(0xA0)
+#define QSERDES_COM_DEC_START1			COM_OFF(0xAC)
+#define QSERDES_COM_PLL_AMP_OS			COM_OFF(0xB0)
+#define QSERDES_COM_RES_CODE_UP_OFFSET		COM_OFF(0xD8)
+#define QSERDES_COM_RES_CODE_DN_OFFSET		COM_OFF(0xDC)
+#define QSERDES_COM_DIV_FRAC_START1		COM_OFF(0x100)
+#define QSERDES_COM_DIV_FRAC_START2		COM_OFF(0x104)
+#define QSERDES_COM_DIV_FRAC_START3		COM_OFF(0x108)
+#define QSERDES_COM_DEC_START2			COM_OFF(0x10C)
+#define QSERDES_COM_PLL_RXTXEPCLK_EN		COM_OFF(0x110)
+#define QSERDES_COM_PLL_CRCTRL			COM_OFF(0x114)
+#define QSERDES_COM_PLL_CLKEPDIV		COM_OFF(0x118)
+
+/* TX LANE n (0, 1) registers */
+#define QSERDES_TX_EMP_POST1_LVL(n)		TX_OFF(n, 0x08)
+#define QSERDES_TX_DRV_LVL(n)			TX_OFF(n, 0x0C)
+#define QSERDES_TX_LANE_MODE(n)			TX_OFF(n, 0x54)
+
+/* RX LANE n (0, 1) registers */
+#define QSERDES_RX_CDR_CONTROL1(n)		RX_OFF(n, 0x0)
+#define QSERDES_RX_CDR_CONTROL_HALF(n)		RX_OFF(n, 0x8)
+#define QSERDES_RX_RX_EQ_GAIN1_LSB(n)		RX_OFF(n, 0xA8)
+#define QSERDES_RX_RX_EQ_GAIN1_MSB(n)		RX_OFF(n, 0xAC)
+#define QSERDES_RX_RX_EQ_GAIN2_LSB(n)		RX_OFF(n, 0xB0)
+#define QSERDES_RX_RX_EQ_GAIN2_MSB(n)		RX_OFF(n, 0xB4)
+#define QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(n)	RX_OFF(n, 0xBC)
+#define QSERDES_RX_CDR_CONTROL_QUARTER(n)	RX_OFF(n, 0xC)
+#define QSERDES_RX_SIGDET_CNTRL(n)		RX_OFF(n, 0x100)
+
+/* UFS PHY registers */
+#define UFS_PHY_PHY_START			PHY_OFF(0x00)
+#define UFS_PHY_POWER_DOWN_CONTROL		PHY_OFF(0x4)
+#define UFS_PHY_TX_LANE_ENABLE			PHY_OFF(0x44)
+#define UFS_PHY_PWM_G1_CLK_DIVIDER		PHY_OFF(0x08)
+#define UFS_PHY_PWM_G2_CLK_DIVIDER		PHY_OFF(0x0C)
+#define UFS_PHY_PWM_G3_CLK_DIVIDER		PHY_OFF(0x10)
+#define UFS_PHY_PWM_G4_CLK_DIVIDER		PHY_OFF(0x14)
+#define UFS_PHY_CORECLK_PWM_G1_CLK_DIVIDER	PHY_OFF(0x34)
+#define UFS_PHY_CORECLK_PWM_G2_CLK_DIVIDER	PHY_OFF(0x38)
+#define UFS_PHY_CORECLK_PWM_G3_CLK_DIVIDER	PHY_OFF(0x3C)
+#define UFS_PHY_CORECLK_PWM_G4_CLK_DIVIDER	PHY_OFF(0x40)
+#define UFS_PHY_OMC_STATUS_RDVAL		PHY_OFF(0x68)
+#define UFS_PHY_LINE_RESET_TIME			PHY_OFF(0x28)
+#define UFS_PHY_LINE_RESET_GRANULARITY		PHY_OFF(0x2C)
+#define UFS_PHY_TSYNC_RSYNC_CNTL		PHY_OFF(0x48)
+#define UFS_PHY_PLL_CNTL			PHY_OFF(0x50)
+#define UFS_PHY_TX_LARGE_AMP_DRV_LVL		PHY_OFF(0x54)
+#define UFS_PHY_TX_SMALL_AMP_DRV_LVL		PHY_OFF(0x5C)
+#define UFS_PHY_TX_LARGE_AMP_POST_EMP_LVL	PHY_OFF(0x58)
+#define UFS_PHY_TX_SMALL_AMP_POST_EMP_LVL	PHY_OFF(0x60)
+#define UFS_PHY_CFG_CHANGE_CNT_VAL		PHY_OFF(0x64)
+#define UFS_PHY_RX_SYNC_WAIT_TIME		PHY_OFF(0x6C)
+#define UFS_PHY_TX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY	PHY_OFF(0xB4)
+#define UFS_PHY_RX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY	PHY_OFF(0xE0)
+#define UFS_PHY_TX_MIN_STALL_NOCONFIG_TIME_CAPABILITY	PHY_OFF(0xB8)
+#define UFS_PHY_RX_MIN_STALL_NOCONFIG_TIME_CAPABILITY	PHY_OFF(0xE4)
+#define UFS_PHY_TX_MIN_SAVE_CONFIG_TIME_CAPABILITY	PHY_OFF(0xBC)
+#define UFS_PHY_RX_MIN_SAVE_CONFIG_TIME_CAPABILITY	PHY_OFF(0xE8)
+#define UFS_PHY_RX_PWM_BURST_CLOSURE_LENGTH_CAPABILITY	PHY_OFF(0xFC)
+#define UFS_PHY_RX_MIN_ACTIVATETIME_CAPABILITY		PHY_OFF(0x100)
+#define UFS_PHY_RX_SIGDET_CTRL3				PHY_OFF(0x14c)
+#define UFS_PHY_RMMI_ATTR_CTRL			PHY_OFF(0x160)
+#define UFS_PHY_RMMI_RX_CFGUPDT_L1	(1 << 7)
+#define UFS_PHY_RMMI_TX_CFGUPDT_L1	(1 << 6)
+#define UFS_PHY_RMMI_CFGWR_L1		(1 << 5)
+#define UFS_PHY_RMMI_CFGRD_L1		(1 << 4)
+#define UFS_PHY_RMMI_RX_CFGUPDT_L0	(1 << 3)
+#define UFS_PHY_RMMI_TX_CFGUPDT_L0	(1 << 2)
+#define UFS_PHY_RMMI_CFGWR_L0		(1 << 1)
+#define UFS_PHY_RMMI_CFGRD_L0		(1 << 0)
+#define UFS_PHY_RMMI_ATTRID			PHY_OFF(0x164)
+#define UFS_PHY_RMMI_ATTRWRVAL			PHY_OFF(0x168)
+#define UFS_PHY_RMMI_ATTRRDVAL_L0_STATUS	PHY_OFF(0x16C)
+#define UFS_PHY_RMMI_ATTRRDVAL_L1_STATUS	PHY_OFF(0x170)
+#define UFS_PHY_PCS_READY_STATUS		PHY_OFF(0x174)
+
+#define UFS_PHY_TX_LANE_ENABLE_MASK		0x3
+
+/*
+ * This structure represents the 20nm specific phy.
+ * common_cfg MUST remain the first field in this structure
+ * in case extra fields are added. This way, when calling
+ * get_ufs_qcom_phy() of generic phy, we can extract the
+ * common phy structure (struct ufs_qcom_phy) out of it
+ * regardless of the relevant specific phy.
+ */
+struct ufs_qcom_phy_qmp_20nm {
+	struct ufs_qcom_phy common_cfg;
+};
+
+static struct ufs_qcom_phy_calibration phy_cal_table_rate_A_1_2_0[] = {
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_POWER_DOWN_CONTROL, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_SIGDET_CTRL3, 0x0D),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_VCOTAIL_EN, 0xe1),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CRCTRL, 0xcc),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_SYSCLK_EN_SEL_TXBAND, 0x08),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CLKEPDIV, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_RXTXEPCLK_EN, 0x10),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x82),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START2, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1, 0x80),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2, 0x80),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3, 0x40),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x19),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP3, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP_EN, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL, 0x90),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL2, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL1(0), 0xf2),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(0), 0x0c),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(0), 0x12),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL1(1), 0xf2),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(1), 0x0c),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(1), 0x12),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB(0), 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB(0), 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB(0), 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB(1), 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB(1), 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB(1), 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETI, 0x3f),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETP, 0x1b),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETP, 0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETI, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_EMP_POST1_LVL(0), 0x2F),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_DRV_LVL(0), 0x20),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_EMP_POST1_LVL(1), 0x2F),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_DRV_LVL(1), 0x20),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(0), 0x68),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(1), 0x68),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(1), 0xdc),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(0), 0xdc),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_BIAS_EN_CLKBUFLR_EN, 0x3),
+};
+
+static struct ufs_qcom_phy_calibration phy_cal_table_rate_A_1_3_0[] = {
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_POWER_DOWN_CONTROL, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_SIGDET_CTRL3, 0x0D),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_VCOTAIL_EN, 0xe1),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CRCTRL, 0xcc),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_SYSCLK_EN_SEL_TXBAND, 0x08),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CLKEPDIV, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_RXTXEPCLK_EN, 0x10),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x82),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START2, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1, 0x80),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2, 0x80),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3, 0x40),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x19),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP3, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP_EN, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL, 0x90),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL2, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL1(0), 0xf2),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(0), 0x0c),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(0), 0x12),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL1(1), 0xf2),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(1), 0x0c),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(1), 0x12),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB(0), 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB(0), 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB(0), 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB(1), 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB(1), 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB(1), 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETI, 0x2b),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETP, 0x38),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETP, 0x3c),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RES_CODE_UP_OFFSET, 0x02),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RES_CODE_DN_OFFSET, 0x02),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETI, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CNTRL, 0x40),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(0), 0x68),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(1), 0x68),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(1), 0xdc),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(0), 0xdc),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_BIAS_EN_CLKBUFLR_EN, 0x3),
+};
+
+static struct ufs_qcom_phy_calibration phy_cal_table_rate_B[] = {
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x98),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0x65),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x1e),
+};
+
+#endif
diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
new file mode 100644
index 0000000..44ee983
--- /dev/null
+++ b/drivers/phy/phy-qcom-ufs.c
@@ -0,0 +1,745 @@
+/*
+ * Copyright (c) 2013-2015, Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include "phy-qcom-ufs-i.h"
+
+#define MAX_PROP_NAME              32
+#define VDDA_PHY_MIN_UV            1000000
+#define VDDA_PHY_MAX_UV            1000000
+#define VDDA_PLL_MIN_UV            1800000
+#define VDDA_PLL_MAX_UV            1800000
+#define VDDP_REF_CLK_MIN_UV        1200000
+#define VDDP_REF_CLK_MAX_UV        1200000
+
+static int __ufs_qcom_phy_init_vreg(struct phy *, struct ufs_qcom_phy_vreg *,
+				    const char *, bool);
+static int ufs_qcom_phy_init_vreg(struct phy *, struct ufs_qcom_phy_vreg *,
+				  const char *);
+static int ufs_qcom_phy_base_init(struct platform_device *pdev,
+				  struct ufs_qcom_phy *phy_common);
+
+int ufs_qcom_phy_calibrate(struct ufs_qcom_phy *ufs_qcom_phy,
+			   struct ufs_qcom_phy_calibration *tbl_A,
+			   int tbl_size_A,
+			   struct ufs_qcom_phy_calibration *tbl_B,
+			   int tbl_size_B, bool is_rate_B)
+{
+	int i;
+	int ret = 0;
+
+	if (!tbl_A) {
+		dev_err(ufs_qcom_phy->dev, "%s: tbl_A is NULL", __func__);
+		ret = EINVAL;
+		goto out;
+	}
+
+	for (i = 0; i < tbl_size_A; i++)
+		writel_relaxed(tbl_A[i].cfg_value,
+			       ufs_qcom_phy->mmio + tbl_A[i].reg_offset);
+
+	/*
+	 * In case we would like to work in rate B, we need
+	 * to override a registers that were configured in rate A table
+	 * with registers of rate B table.
+	 * table.
+	 */
+	if (is_rate_B) {
+		if (!tbl_B) {
+			dev_err(ufs_qcom_phy->dev, "%s: tbl_B is NULL",
+				__func__);
+			ret = EINVAL;
+			goto out;
+		}
+
+		for (i = 0; i < tbl_size_B; i++)
+			writel_relaxed(tbl_B[i].cfg_value,
+				ufs_qcom_phy->mmio + tbl_B[i].reg_offset);
+	}
+
+	/* flush buffered writes */
+	mb();
+
+out:
+	return ret;
+}
+
+struct phy *ufs_qcom_phy_generic_probe(struct platform_device *pdev,
+				struct ufs_qcom_phy *common_cfg,
+				struct phy_ops *ufs_qcom_phy_gen_ops,
+				struct ufs_qcom_phy_specific_ops *phy_spec_ops)
+{
+	int err;
+	struct device *dev = &pdev->dev;
+	struct phy *generic_phy = NULL;
+	struct phy_provider *phy_provider;
+
+	err = ufs_qcom_phy_base_init(pdev, common_cfg);
+	if (err) {
+		dev_err(dev, "%s: phy base init failed %d\n", __func__, err);
+		goto out;
+	}
+
+	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
+	if (IS_ERR(phy_provider)) {
+		err = PTR_ERR(phy_provider);
+		dev_err(dev, "%s: failed to register phy %d\n", __func__, err);
+		goto out;
+	}
+
+	generic_phy = devm_phy_create(dev, NULL, ufs_qcom_phy_gen_ops);
+	if (IS_ERR(generic_phy)) {
+		err =  PTR_ERR(generic_phy);
+		dev_err(dev, "%s: failed to create phy %d\n", __func__, err);
+		goto out;
+	}
+
+	common_cfg->phy_spec_ops = phy_spec_ops;
+	common_cfg->dev = dev;
+
+out:
+	return generic_phy;
+}
+
+/*
+ * This assumes the embedded phy structure inside generic_phy is of type
+ * struct ufs_qcom_phy. In order to function properly it's crucial
+ * to keep the embedded struct "struct ufs_qcom_phy common_cfg"
+ * as the first inside generic_phy.
+ */
+struct ufs_qcom_phy *get_ufs_qcom_phy(struct phy *generic_phy)
+{
+	return (struct ufs_qcom_phy *)phy_get_drvdata(generic_phy);
+}
+
+static
+int ufs_qcom_phy_base_init(struct platform_device *pdev,
+			   struct ufs_qcom_phy *phy_common)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	int err = 0;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "phy_mem");
+	if (!res) {
+		dev_err(dev, "%s: phy_mem resource not found\n", __func__);
+		err = -ENOMEM;
+		goto out;
+	}
+
+	phy_common->mmio = devm_ioremap_resource(dev, res);
+	if (IS_ERR((void const *)phy_common->mmio)) {
+		err = PTR_ERR((void const *)phy_common->mmio);
+		phy_common->mmio = NULL;
+		dev_err(dev, "%s: ioremap for phy_mem resource failed %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	/* "dev_ref_clk_ctrl_mem" is optional resource */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+					   "dev_ref_clk_ctrl_mem");
+	if (!res) {
+		dev_dbg(dev, "%s: dev_ref_clk_ctrl_mem resource not found\n",
+			__func__);
+		goto out;
+	}
+
+	phy_common->dev_ref_clk_ctrl_mmio = devm_ioremap_resource(dev, res);
+	if (IS_ERR((void const *)phy_common->dev_ref_clk_ctrl_mmio)) {
+		err = PTR_ERR((void const *)phy_common->dev_ref_clk_ctrl_mmio);
+		phy_common->dev_ref_clk_ctrl_mmio = NULL;
+		dev_err(dev, "%s: ioremap for dev_ref_clk_ctrl_mem resource failed %d\n",
+			__func__, err);
+	}
+
+out:
+	return err;
+}
+
+static int __ufs_qcom_phy_clk_get(struct phy *phy,
+			 const char *name, struct clk **clk_out, bool err_print)
+{
+	struct clk *clk;
+	int err = 0;
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(phy);
+	struct device *dev = ufs_qcom_phy->dev;
+
+	clk = devm_clk_get(dev, name);
+	if (IS_ERR(clk)) {
+		err = PTR_ERR(clk);
+		if (err_print)
+			dev_err(dev, "failed to get %s err %d", name, err);
+	} else {
+		*clk_out = clk;
+	}
+
+	return err;
+}
+
+static
+int ufs_qcom_phy_clk_get(struct phy *phy,
+			 const char *name, struct clk **clk_out)
+{
+	return __ufs_qcom_phy_clk_get(phy, name, clk_out, true);
+}
+
+int
+ufs_qcom_phy_init_clks(struct phy *generic_phy,
+		       struct ufs_qcom_phy *phy_common)
+{
+	int err;
+
+	err = ufs_qcom_phy_clk_get(generic_phy, "tx_iface_clk",
+				   &phy_common->tx_iface_clk);
+	if (err)
+		goto out;
+
+	err = ufs_qcom_phy_clk_get(generic_phy, "rx_iface_clk",
+				   &phy_common->rx_iface_clk);
+	if (err)
+		goto out;
+
+	err = ufs_qcom_phy_clk_get(generic_phy, "ref_clk_src",
+				   &phy_common->ref_clk_src);
+	if (err)
+		goto out;
+
+	/*
+	 * "ref_clk_parent" is optional hence don't abort init if it's not
+	 * found.
+	 */
+	__ufs_qcom_phy_clk_get(generic_phy, "ref_clk_parent",
+				   &phy_common->ref_clk_parent, false);
+
+	err = ufs_qcom_phy_clk_get(generic_phy, "ref_clk",
+				   &phy_common->ref_clk);
+
+out:
+	return err;
+}
+
+int
+ufs_qcom_phy_init_vregulators(struct phy *generic_phy,
+			      struct ufs_qcom_phy *phy_common)
+{
+	int err;
+
+	err = ufs_qcom_phy_init_vreg(generic_phy, &phy_common->vdda_pll,
+		"vdda-pll");
+	if (err)
+		goto out;
+
+	err = ufs_qcom_phy_init_vreg(generic_phy, &phy_common->vdda_phy,
+		"vdda-phy");
+
+	if (err)
+		goto out;
+
+	/* vddp-ref-clk-* properties are optional */
+	__ufs_qcom_phy_init_vreg(generic_phy, &phy_common->vddp_ref_clk,
+				 "vddp-ref-clk", true);
+out:
+	return err;
+}
+
+static int __ufs_qcom_phy_init_vreg(struct phy *phy,
+		struct ufs_qcom_phy_vreg *vreg, const char *name, bool optional)
+{
+	int err = 0;
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(phy);
+	struct device *dev = ufs_qcom_phy->dev;
+
+	char prop_name[MAX_PROP_NAME];
+
+	vreg->name = kstrdup(name, GFP_KERNEL);
+	if (!vreg->name) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	vreg->reg = devm_regulator_get(dev, name);
+	if (IS_ERR(vreg->reg)) {
+		err = PTR_ERR(vreg->reg);
+		vreg->reg = NULL;
+		if (!optional)
+			dev_err(dev, "failed to get %s, %d\n", name, err);
+		goto out;
+	}
+
+	if (dev->of_node) {
+		snprintf(prop_name, MAX_PROP_NAME, "%s-max-microamp", name);
+		err = of_property_read_u32(dev->of_node,
+					prop_name, &vreg->max_uA);
+		if (err && err != -EINVAL) {
+			dev_err(dev, "%s: failed to read %s\n",
+					__func__, prop_name);
+			goto out;
+		} else if (err == -EINVAL || !vreg->max_uA) {
+			if (regulator_count_voltages(vreg->reg) > 0) {
+				dev_err(dev, "%s: %s is mandatory\n",
+						__func__, prop_name);
+				goto out;
+			}
+			err = 0;
+		}
+		snprintf(prop_name, MAX_PROP_NAME, "%s-always-on", name);
+		if (of_get_property(dev->of_node, prop_name, NULL))
+			vreg->is_always_on = true;
+		else
+			vreg->is_always_on = false;
+	}
+
+	if (!strcmp(name, "vdda-pll")) {
+		vreg->max_uV = VDDA_PLL_MAX_UV;
+		vreg->min_uV = VDDA_PLL_MIN_UV;
+	} else if (!strcmp(name, "vdda-phy")) {
+		vreg->max_uV = VDDA_PHY_MAX_UV;
+		vreg->min_uV = VDDA_PHY_MIN_UV;
+	} else if (!strcmp(name, "vddp-ref-clk")) {
+		vreg->max_uV = VDDP_REF_CLK_MAX_UV;
+		vreg->min_uV = VDDP_REF_CLK_MIN_UV;
+	}
+
+out:
+	if (err)
+		kfree(vreg->name);
+	return err;
+}
+
+static int ufs_qcom_phy_init_vreg(struct phy *phy,
+			struct ufs_qcom_phy_vreg *vreg, const char *name)
+{
+	return __ufs_qcom_phy_init_vreg(phy, vreg, name, false);
+}
+
+static
+int ufs_qcom_phy_cfg_vreg(struct phy *phy,
+			  struct ufs_qcom_phy_vreg *vreg, bool on)
+{
+	int ret = 0;
+	struct regulator *reg = vreg->reg;
+	const char *name = vreg->name;
+	int min_uV;
+	int uA_load;
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(phy);
+	struct device *dev = ufs_qcom_phy->dev;
+
+	BUG_ON(!vreg);
+
+	if (regulator_count_voltages(reg) > 0) {
+		min_uV = on ? vreg->min_uV : 0;
+		ret = regulator_set_voltage(reg, min_uV, vreg->max_uV);
+		if (ret) {
+			dev_err(dev, "%s: %s set voltage failed, err=%d\n",
+					__func__, name, ret);
+			goto out;
+		}
+		uA_load = on ? vreg->max_uA : 0;
+		ret = regulator_set_optimum_mode(reg, uA_load);
+		if (ret >= 0) {
+			/*
+			 * regulator_set_optimum_mode() returns new regulator
+			 * mode upon success.
+			 */
+			ret = 0;
+		} else {
+			dev_err(dev, "%s: %s set optimum mode(uA_load=%d) failed, err=%d\n",
+					__func__, name, uA_load, ret);
+			goto out;
+		}
+	}
+out:
+	return ret;
+}
+
+static
+int ufs_qcom_phy_enable_vreg(struct phy *phy,
+			     struct ufs_qcom_phy_vreg *vreg)
+{
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(phy);
+	struct device *dev = ufs_qcom_phy->dev;
+	int ret = 0;
+
+	if (!vreg || vreg->enabled)
+		goto out;
+
+	ret = ufs_qcom_phy_cfg_vreg(phy, vreg, true);
+	if (ret) {
+		dev_err(dev, "%s: ufs_qcom_phy_cfg_vreg() failed, err=%d\n",
+			__func__, ret);
+		goto out;
+	}
+
+	ret = regulator_enable(vreg->reg);
+	if (ret) {
+		dev_err(dev, "%s: enable failed, err=%d\n",
+				__func__, ret);
+		goto out;
+	}
+
+	vreg->enabled = true;
+out:
+	return ret;
+}
+
+int ufs_qcom_phy_enable_ref_clk(struct phy *generic_phy)
+{
+	int ret = 0;
+	struct ufs_qcom_phy *phy = get_ufs_qcom_phy(generic_phy);
+
+	if (phy->is_ref_clk_enabled)
+		goto out;
+
+	/*
+	 * reference clock is propagated in a daisy-chained manner from
+	 * source to phy, so ungate them at each stage.
+	 */
+	ret = clk_prepare_enable(phy->ref_clk_src);
+	if (ret) {
+		dev_err(phy->dev, "%s: ref_clk_src enable failed %d\n",
+				__func__, ret);
+		goto out;
+	}
+
+	/*
+	 * "ref_clk_parent" is optional clock hence make sure that clk reference
+	 * is available before trying to enable the clock.
+	 */
+	if (phy->ref_clk_parent) {
+		ret = clk_prepare_enable(phy->ref_clk_parent);
+		if (ret) {
+			dev_err(phy->dev, "%s: ref_clk_parent enable failed %d\n",
+					__func__, ret);
+			goto out_disable_src;
+		}
+	}
+
+	ret = clk_prepare_enable(phy->ref_clk);
+	if (ret) {
+		dev_err(phy->dev, "%s: ref_clk enable failed %d\n",
+				__func__, ret);
+		goto out_disable_parent;
+	}
+
+	phy->is_ref_clk_enabled = true;
+	goto out;
+
+out_disable_parent:
+	if (phy->ref_clk_parent)
+		clk_disable_unprepare(phy->ref_clk_parent);
+out_disable_src:
+	clk_disable_unprepare(phy->ref_clk_src);
+out:
+	return ret;
+}
+
+static
+int ufs_qcom_phy_disable_vreg(struct phy *phy,
+			      struct ufs_qcom_phy_vreg *vreg)
+{
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(phy);
+	struct device *dev = ufs_qcom_phy->dev;
+	int ret = 0;
+
+	if (!vreg || !vreg->enabled || vreg->is_always_on)
+		goto out;
+
+	ret = regulator_disable(vreg->reg);
+
+	if (!ret) {
+		/* ignore errors on applying disable config */
+		ufs_qcom_phy_cfg_vreg(phy, vreg, false);
+		vreg->enabled = false;
+	} else {
+		dev_err(dev, "%s: %s disable failed, err=%d\n",
+				__func__, vreg->name, ret);
+	}
+out:
+	return ret;
+}
+
+void ufs_qcom_phy_disable_ref_clk(struct phy *generic_phy)
+{
+	struct ufs_qcom_phy *phy = get_ufs_qcom_phy(generic_phy);
+
+	if (phy->is_ref_clk_enabled) {
+		clk_disable_unprepare(phy->ref_clk);
+		/*
+		 * "ref_clk_parent" is optional clock hence make sure that clk
+		 * reference is available before trying to disable the clock.
+		 */
+		if (phy->ref_clk_parent)
+			clk_disable_unprepare(phy->ref_clk_parent);
+		clk_disable_unprepare(phy->ref_clk_src);
+		phy->is_ref_clk_enabled = false;
+	}
+}
+
+#define UFS_REF_CLK_EN	(1 << 5)
+
+static void ufs_qcom_phy_dev_ref_clk_ctrl(struct phy *generic_phy, bool enable)
+{
+	struct ufs_qcom_phy *phy = get_ufs_qcom_phy(generic_phy);
+
+	if (phy->dev_ref_clk_ctrl_mmio &&
+	    (enable ^ phy->is_dev_ref_clk_enabled)) {
+		u32 temp = readl_relaxed(phy->dev_ref_clk_ctrl_mmio);
+
+		if (enable)
+			temp |= UFS_REF_CLK_EN;
+		else
+			temp &= ~UFS_REF_CLK_EN;
+
+		/*
+		 * If we are here to disable this clock immediately after
+		 * entering into hibern8, we need to make sure that device
+		 * ref_clk is active atleast 1us after the hibern8 enter.
+		 */
+		if (!enable)
+			udelay(1);
+
+		writel_relaxed(temp, phy->dev_ref_clk_ctrl_mmio);
+		/* ensure that ref_clk is enabled/disabled before we return */
+		wmb();
+		/*
+		 * If we call hibern8 exit after this, we need to make sure that
+		 * device ref_clk is stable for atleast 1us before the hibern8
+		 * exit command.
+		 */
+		if (enable)
+			udelay(1);
+
+		phy->is_dev_ref_clk_enabled = enable;
+	}
+}
+
+void ufs_qcom_phy_enable_dev_ref_clk(struct phy *generic_phy)
+{
+	ufs_qcom_phy_dev_ref_clk_ctrl(generic_phy, true);
+}
+
+void ufs_qcom_phy_disable_dev_ref_clk(struct phy *generic_phy)
+{
+	ufs_qcom_phy_dev_ref_clk_ctrl(generic_phy, false);
+}
+
+/* Turn ON M-PHY RMMI interface clocks */
+int ufs_qcom_phy_enable_iface_clk(struct phy *generic_phy)
+{
+	struct ufs_qcom_phy *phy = get_ufs_qcom_phy(generic_phy);
+	int ret = 0;
+
+	if (phy->is_iface_clk_enabled)
+		goto out;
+
+	ret = clk_prepare_enable(phy->tx_iface_clk);
+	if (ret) {
+		dev_err(phy->dev, "%s: tx_iface_clk enable failed %d\n",
+				__func__, ret);
+		goto out;
+	}
+	ret = clk_prepare_enable(phy->rx_iface_clk);
+	if (ret) {
+		clk_disable_unprepare(phy->tx_iface_clk);
+		dev_err(phy->dev, "%s: rx_iface_clk enable failed %d. disabling also tx_iface_clk\n",
+				__func__, ret);
+		goto out;
+	}
+	phy->is_iface_clk_enabled = true;
+
+out:
+	return ret;
+}
+
+/* Turn OFF M-PHY RMMI interface clocks */
+void ufs_qcom_phy_disable_iface_clk(struct phy *generic_phy)
+{
+	struct ufs_qcom_phy *phy = get_ufs_qcom_phy(generic_phy);
+
+	if (phy->is_iface_clk_enabled) {
+		clk_disable_unprepare(phy->tx_iface_clk);
+		clk_disable_unprepare(phy->rx_iface_clk);
+		phy->is_iface_clk_enabled = false;
+	}
+}
+
+int ufs_qcom_phy_start_serdes(struct phy *generic_phy)
+{
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
+	int ret = 0;
+
+	if (!ufs_qcom_phy->phy_spec_ops->start_serdes) {
+		dev_err(ufs_qcom_phy->dev, "%s: start_serdes() callback is not supported\n",
+			__func__);
+		ret = -ENOTSUPP;
+	} else {
+		ufs_qcom_phy->phy_spec_ops->start_serdes(ufs_qcom_phy);
+	}
+
+	return ret;
+}
+
+int ufs_qcom_phy_set_tx_lane_enable(struct phy *generic_phy, u32 tx_lanes)
+{
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
+	int ret = 0;
+
+	if (!ufs_qcom_phy->phy_spec_ops->set_tx_lane_enable) {
+		dev_err(ufs_qcom_phy->dev, "%s: set_tx_lane_enable() callback is not supported\n",
+			__func__);
+		ret = -ENOTSUPP;
+	} else {
+		ufs_qcom_phy->phy_spec_ops->set_tx_lane_enable(ufs_qcom_phy,
+							       tx_lanes);
+	}
+
+	return ret;
+}
+
+void ufs_qcom_phy_save_controller_version(struct phy *generic_phy,
+					  u8 major, u16 minor, u16 step)
+{
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
+
+	ufs_qcom_phy->host_ctrl_rev_major = major;
+	ufs_qcom_phy->host_ctrl_rev_minor = minor;
+	ufs_qcom_phy->host_ctrl_rev_step = step;
+}
+
+int ufs_qcom_phy_calibrate_phy(struct phy *generic_phy, bool is_rate_B)
+{
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
+	int ret = 0;
+
+	if (!ufs_qcom_phy->phy_spec_ops->calibrate_phy) {
+		dev_err(ufs_qcom_phy->dev, "%s: calibrate_phy() callback is not supported\n",
+			__func__);
+		ret = -ENOTSUPP;
+	} else {
+		ret = ufs_qcom_phy->phy_spec_ops->
+				calibrate_phy(ufs_qcom_phy, is_rate_B);
+		if (ret)
+			dev_err(ufs_qcom_phy->dev, "%s: calibrate_phy() failed %d\n",
+				__func__, ret);
+	}
+
+	return ret;
+}
+
+int ufs_qcom_phy_remove(struct phy *generic_phy,
+			struct ufs_qcom_phy *ufs_qcom_phy)
+{
+	phy_power_off(generic_phy);
+
+	kfree(ufs_qcom_phy->vdda_pll.name);
+	kfree(ufs_qcom_phy->vdda_phy.name);
+
+	return 0;
+}
+
+int ufs_qcom_phy_exit(struct phy *generic_phy)
+{
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
+
+	if (ufs_qcom_phy->is_powered_on)
+		phy_power_off(generic_phy);
+
+	return 0;
+}
+
+int ufs_qcom_phy_is_pcs_ready(struct phy *generic_phy)
+{
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
+
+	if (!ufs_qcom_phy->phy_spec_ops->is_physical_coding_sublayer_ready) {
+		dev_err(ufs_qcom_phy->dev, "%s: is_physical_coding_sublayer_ready() callback is not supported\n",
+			__func__);
+		return -ENOTSUPP;
+	}
+
+	return ufs_qcom_phy->phy_spec_ops->
+			is_physical_coding_sublayer_ready(ufs_qcom_phy);
+}
+
+int ufs_qcom_phy_power_on(struct phy *generic_phy)
+{
+	struct ufs_qcom_phy *phy_common = get_ufs_qcom_phy(generic_phy);
+	struct device *dev = phy_common->dev;
+	int err;
+
+	err = ufs_qcom_phy_enable_vreg(generic_phy, &phy_common->vdda_phy);
+	if (err) {
+		dev_err(dev, "%s enable vdda_phy failed, err=%d\n",
+			__func__, err);
+		goto out;
+	}
+
+	phy_common->phy_spec_ops->power_control(phy_common, true);
+
+	/* vdda_pll also enables ref clock LDOs so enable it first */
+	err = ufs_qcom_phy_enable_vreg(generic_phy, &phy_common->vdda_pll);
+	if (err) {
+		dev_err(dev, "%s enable vdda_pll failed, err=%d\n",
+			__func__, err);
+		goto out_disable_phy;
+	}
+
+	err = ufs_qcom_phy_enable_ref_clk(generic_phy);
+	if (err) {
+		dev_err(dev, "%s enable phy ref clock failed, err=%d\n",
+			__func__, err);
+		goto out_disable_pll;
+	}
+
+	/* enable device PHY ref_clk pad rail */
+	if (phy_common->vddp_ref_clk.reg) {
+		err = ufs_qcom_phy_enable_vreg(generic_phy,
+					       &phy_common->vddp_ref_clk);
+		if (err) {
+			dev_err(dev, "%s enable vddp_ref_clk failed, err=%d\n",
+				__func__, err);
+			goto out_disable_ref_clk;
+		}
+	}
+
+	phy_common->is_powered_on = true;
+	goto out;
+
+out_disable_ref_clk:
+	ufs_qcom_phy_disable_ref_clk(generic_phy);
+out_disable_pll:
+	ufs_qcom_phy_disable_vreg(generic_phy, &phy_common->vdda_pll);
+out_disable_phy:
+	ufs_qcom_phy_disable_vreg(generic_phy, &phy_common->vdda_phy);
+out:
+	return err;
+}
+
+int ufs_qcom_phy_power_off(struct phy *generic_phy)
+{
+	struct ufs_qcom_phy *phy_common = get_ufs_qcom_phy(generic_phy);
+
+	phy_common->phy_spec_ops->power_control(phy_common, false);
+
+	if (phy_common->vddp_ref_clk.reg)
+		ufs_qcom_phy_disable_vreg(generic_phy,
+					  &phy_common->vddp_ref_clk);
+	ufs_qcom_phy_disable_ref_clk(generic_phy);
+
+	ufs_qcom_phy_disable_vreg(generic_phy, &phy_common->vdda_pll);
+	ufs_qcom_phy_disable_vreg(generic_phy, &phy_common->vdda_phy);
+	phy_common->is_powered_on = false;
+
+	return 0;
+}
diff --git a/include/linux/phy/phy-qcom-ufs.h b/include/linux/phy/phy-qcom-ufs.h
new file mode 100644
index 0000000..9d18e9f
--- /dev/null
+++ b/include/linux/phy/phy-qcom-ufs.h
@@ -0,0 +1,59 @@
+/*
+ * Copyright (c) 2013-2015, Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef PHY_QCOM_UFS_H_
+#define PHY_QCOM_UFS_H_
+
+#include "phy.h"
+
+/**
+ * ufs_qcom_phy_enable_ref_clk() - Enable the phy
+ * ref clock.
+ * @phy: reference to a generic phy
+ *
+ * returns 0 for success, and non-zero for error.
+ */
+int ufs_qcom_phy_enable_ref_clk(struct phy *phy);
+
+/**
+ * ufs_qcom_phy_disable_ref_clk() - Disable the phy
+ * ref clock.
+ * @phy: reference to a generic phy.
+ */
+void ufs_qcom_phy_disable_ref_clk(struct phy *phy);
+
+/**
+ * ufs_qcom_phy_enable_dev_ref_clk() - Enable the device
+ * ref clock.
+ * @phy: reference to a generic phy.
+ */
+void ufs_qcom_phy_enable_dev_ref_clk(struct phy *phy);
+
+/**
+ * ufs_qcom_phy_disable_dev_ref_clk() - Disable the device
+ * ref clock.
+ * @phy: reference to a generic phy.
+ */
+void ufs_qcom_phy_disable_dev_ref_clk(struct phy *phy);
+
+int ufs_qcom_phy_enable_iface_clk(struct phy *phy);
+void ufs_qcom_phy_disable_iface_clk(struct phy *phy);
+int ufs_qcom_phy_start_serdes(struct phy *phy);
+int ufs_qcom_phy_set_tx_lane_enable(struct phy *phy, u32 tx_lanes);
+int ufs_qcom_phy_calibrate_phy(struct phy *phy, bool is_rate_B);
+int ufs_qcom_phy_is_pcs_ready(struct phy *phy);
+void ufs_qcom_phy_save_controller_version(struct phy *phy,
+			u8 major, u16 minor, u16 step);
+
+#endif /* PHY_QCOM_UFS_H_ */
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
