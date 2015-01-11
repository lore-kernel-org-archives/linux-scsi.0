From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v6 3/4] phy: qcom-ufs: add support for 14nm phy
Date: Sun, 11 Jan 2015 14:38:08 +0200
Message-ID: <1420979889-22126-4-git-send-email-ygardi@codeaurora.org>
References: <1420979889-22126-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1420979889-22126-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, noag@codeaurora.org, draviv@codeaurora.org, Kishon Vijay Abraham I <kishon@ti.com>, Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>, "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This change adds a support for a 14nm qcom-ufs phy that is
required in platforms that use ufs-qcom controller.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/phy/Makefile                |   1 +
 drivers/phy/phy-qcom-ufs-qmp-14nm.c | 201 ++++++++++++++++++++++++++++++++++++
 drivers/phy/phy-qcom-ufs-qmp-14nm.h | 177 +++++++++++++++++++++++++++++++
 3 files changed, 379 insertions(+)
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-14nm.c
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-14nm.h

diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 781b2fa..cfbb720 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -36,3 +36,4 @@ obj-$(CONFIG_PHY_STIH407_USB)		+= phy-stih407-usb.o
 obj-$(CONFIG_PHY_STIH41X_USB)		+= phy-stih41x-usb.o
 obj-$(CONFIG_PHY_QCOM_UFS) 	+= phy-qcom-ufs.o
 obj-$(CONFIG_PHY_QCOM_UFS) 	+= phy-qcom-ufs-qmp-20nm.o
+obj-$(CONFIG_PHY_QCOM_UFS) 	+= phy-qcom-ufs-qmp-14nm.o
diff --git a/drivers/phy/phy-qcom-ufs-qmp-14nm.c b/drivers/phy/phy-qcom-ufs-qmp-14nm.c
new file mode 100644
index 0000000..f5fc50a
--- /dev/null
+++ b/drivers/phy/phy-qcom-ufs-qmp-14nm.c
@@ -0,0 +1,201 @@
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
+#include "phy-qcom-ufs-qmp-14nm.h"
+
+#define UFS_PHY_NAME "ufs_phy_qmp_14nm"
+#define UFS_PHY_VDDA_PHY_UV	(925000)
+
+static
+int ufs_qcom_phy_qmp_14nm_phy_calibrate(struct ufs_qcom_phy *ufs_qcom_phy,
+					bool is_rate_B)
+{
+	int tbl_size_A = ARRAY_SIZE(phy_cal_table_rate_A);
+	int tbl_size_B = ARRAY_SIZE(phy_cal_table_rate_B);
+	int err;
+
+	err = ufs_qcom_phy_calibrate(ufs_qcom_phy, phy_cal_table_rate_A,
+		tbl_size_A, phy_cal_table_rate_B, tbl_size_B, is_rate_B);
+
+	if (err)
+		dev_err(ufs_qcom_phy->dev,
+			"%s: ufs_qcom_phy_calibrate() failed %d\n",
+			__func__, err);
+	return err;
+}
+
+static
+void ufs_qcom_phy_qmp_14nm_advertise_quirks(struct ufs_qcom_phy *phy_common)
+{
+	phy_common->quirks =
+		UFS_QCOM_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE;
+}
+
+static int ufs_qcom_phy_qmp_14nm_init(struct phy *generic_phy)
+{
+	struct ufs_qcom_phy_qmp_14nm *phy = phy_get_drvdata(generic_phy);
+	struct ufs_qcom_phy *phy_common = &phy->common_cfg;
+	int err;
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
+	phy_common->vdda_phy.max_uV = UFS_PHY_VDDA_PHY_UV;
+	phy_common->vdda_phy.min_uV = UFS_PHY_VDDA_PHY_UV;
+
+	ufs_qcom_phy_qmp_14nm_advertise_quirks(phy_common);
+
+out:
+	return err;
+}
+
+static
+void ufs_qcom_phy_qmp_14nm_power_control(struct ufs_qcom_phy *phy, bool val)
+{
+	writel_relaxed(val ? 0x1 : 0x0, phy->mmio + UFS_PHY_POWER_DOWN_CONTROL);
+	/*
+	 * Before any transactions involving PHY, ensure PHY knows
+	 * that it's analog rail is powered ON (or OFF).
+	 */
+	mb();
+}
+
+static inline
+void ufs_qcom_phy_qmp_14nm_set_tx_lane_enable(struct ufs_qcom_phy *phy, u32 val)
+{
+	/*
+	 * 14nm PHY does not have TX_LANE_ENABLE register.
+	 * Implement this function so as not to propagate error to caller.
+	 */
+}
+
+static inline void ufs_qcom_phy_qmp_14nm_start_serdes(struct ufs_qcom_phy *phy)
+{
+	u32 tmp;
+
+	tmp = readl_relaxed(phy->mmio + UFS_PHY_PHY_START);
+	tmp &= ~MASK_SERDES_START;
+	tmp |= (1 << OFFSET_SERDES_START);
+	writel_relaxed(tmp, phy->mmio + UFS_PHY_PHY_START);
+	/* Ensure register value is committed */
+	mb();
+}
+
+static int ufs_qcom_phy_qmp_14nm_is_pcs_ready(struct ufs_qcom_phy *phy_common)
+{
+	int err = 0;
+	u32 val;
+
+	err = readl_poll_timeout(phy_common->mmio + UFS_PHY_PCS_READY_STATUS,
+		val, (val & MASK_PCS_READY), 10, 1000000);
+	if (err)
+		dev_err(phy_common->dev, "%s: poll for pcs failed err = %d\n",
+			__func__, err);
+	return err;
+}
+
+static struct phy_ops ufs_qcom_phy_qmp_14nm_phy_ops = {
+	.init		= ufs_qcom_phy_qmp_14nm_init,
+	.exit		= ufs_qcom_phy_exit,
+	.power_on	= ufs_qcom_phy_power_on,
+	.power_off	= ufs_qcom_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+static struct ufs_qcom_phy_specific_ops phy_14nm_ops = {
+	.calibrate_phy		= ufs_qcom_phy_qmp_14nm_phy_calibrate,
+	.start_serdes		= ufs_qcom_phy_qmp_14nm_start_serdes,
+	.is_physical_coding_sublayer_ready = ufs_qcom_phy_qmp_14nm_is_pcs_ready,
+	.set_tx_lane_enable	= ufs_qcom_phy_qmp_14nm_set_tx_lane_enable,
+	.power_control		= ufs_qcom_phy_qmp_14nm_power_control,
+};
+
+static int ufs_qcom_phy_qmp_14nm_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct phy *generic_phy;
+	struct ufs_qcom_phy_qmp_14nm *phy;
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
+				&ufs_qcom_phy_qmp_14nm_phy_ops, &phy_14nm_ops);
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
+		sizeof(phy->common_cfg.name));
+
+out:
+	return err;
+}
+
+static int ufs_qcom_phy_qmp_14nm_remove(struct platform_device *pdev)
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
+static const struct of_device_id ufs_qcom_phy_qmp_14nm_of_match[] = {
+	{.compatible = "qcom,ufs-phy-qmp-14nm"},
+	{},
+};
+MODULE_DEVICE_TABLE(of, ufs_qcom_phy_qmp_14nm_of_match);
+
+static struct platform_driver ufs_qcom_phy_qmp_14nm_driver = {
+	.probe = ufs_qcom_phy_qmp_14nm_probe,
+	.remove = ufs_qcom_phy_qmp_14nm_remove,
+	.driver = {
+		.of_match_table = ufs_qcom_phy_qmp_14nm_of_match,
+		.name = "ufs_qcom_phy_qmp_14nm",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_platform_driver(ufs_qcom_phy_qmp_14nm_driver);
+
+MODULE_DESCRIPTION("Universal Flash Storage (UFS) QCOM PHY QMP 14nm");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/phy/phy-qcom-ufs-qmp-14nm.h b/drivers/phy/phy-qcom-ufs-qmp-14nm.h
new file mode 100644
index 0000000..3aefdba
--- /dev/null
+++ b/drivers/phy/phy-qcom-ufs-qmp-14nm.h
@@ -0,0 +1,177 @@
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
+#ifndef UFS_QCOM_PHY_QMP_14NM_H_
+#define UFS_QCOM_PHY_QMP_14NM_H_
+
+#include "phy-qcom-ufs-i.h"
+
+/* QCOM UFS PHY control registers */
+#define COM_OFF(x)	(0x000 + x)
+#define PHY_OFF(x)	(0xC00 + x)
+#define TX_OFF(n, x)	(0x400 + (0x400 * n) + x)
+#define RX_OFF(n, x)	(0x600 + (0x400 * n) + x)
+
+/* UFS PHY QSERDES COM registers */
+#define QSERDES_COM_BG_TIMER			COM_OFF(0x0C)
+#define QSERDES_COM_BIAS_EN_CLKBUFLR_EN		COM_OFF(0x34)
+#define QSERDES_COM_SYS_CLK_CTRL		COM_OFF(0x3C)
+#define QSERDES_COM_LOCK_CMP1_MODE0		COM_OFF(0x4C)
+#define QSERDES_COM_LOCK_CMP2_MODE0		COM_OFF(0x50)
+#define QSERDES_COM_LOCK_CMP3_MODE0		COM_OFF(0x54)
+#define QSERDES_COM_LOCK_CMP1_MODE1		COM_OFF(0x58)
+#define QSERDES_COM_LOCK_CMP2_MODE1		COM_OFF(0x5C)
+#define QSERDES_COM_LOCK_CMP3_MODE1		COM_OFF(0x60)
+#define QSERDES_COM_CP_CTRL_MODE0		COM_OFF(0x78)
+#define QSERDES_COM_CP_CTRL_MODE1		COM_OFF(0x7C)
+#define QSERDES_COM_PLL_RCTRL_MODE0		COM_OFF(0x84)
+#define QSERDES_COM_PLL_RCTRL_MODE1		COM_OFF(0x88)
+#define QSERDES_COM_PLL_CCTRL_MODE0		COM_OFF(0x90)
+#define QSERDES_COM_PLL_CCTRL_MODE1		COM_OFF(0x94)
+#define QSERDES_COM_SYSCLK_EN_SEL		COM_OFF(0xAC)
+#define QSERDES_COM_RESETSM_CNTRL		COM_OFF(0xB4)
+#define QSERDES_COM_LOCK_CMP_EN			COM_OFF(0xC8)
+#define QSERDES_COM_LOCK_CMP_CFG		COM_OFF(0xCC)
+#define QSERDES_COM_DEC_START_MODE0		COM_OFF(0xD0)
+#define QSERDES_COM_DEC_START_MODE1		COM_OFF(0xD4)
+#define QSERDES_COM_DIV_FRAC_START1_MODE0	COM_OFF(0xDC)
+#define QSERDES_COM_DIV_FRAC_START2_MODE0	COM_OFF(0xE0)
+#define QSERDES_COM_DIV_FRAC_START3_MODE0	COM_OFF(0xE4)
+#define QSERDES_COM_DIV_FRAC_START1_MODE1	COM_OFF(0xE8)
+#define QSERDES_COM_DIV_FRAC_START2_MODE1	COM_OFF(0xEC)
+#define QSERDES_COM_DIV_FRAC_START3_MODE1	COM_OFF(0xF0)
+#define QSERDES_COM_INTEGLOOP_GAIN0_MODE0	COM_OFF(0x108)
+#define QSERDES_COM_INTEGLOOP_GAIN1_MODE0	COM_OFF(0x10C)
+#define QSERDES_COM_INTEGLOOP_GAIN0_MODE1	COM_OFF(0x110)
+#define QSERDES_COM_INTEGLOOP_GAIN1_MODE1	COM_OFF(0x114)
+#define QSERDES_COM_VCO_TUNE_CTRL		COM_OFF(0x124)
+#define QSERDES_COM_VCO_TUNE_MAP		COM_OFF(0x128)
+#define QSERDES_COM_VCO_TUNE1_MODE0		COM_OFF(0x12C)
+#define QSERDES_COM_VCO_TUNE2_MODE0		COM_OFF(0x130)
+#define QSERDES_COM_VCO_TUNE1_MODE1		COM_OFF(0x134)
+#define QSERDES_COM_VCO_TUNE2_MODE1		COM_OFF(0x138)
+#define QSERDES_COM_VCO_TUNE_TIMER1		COM_OFF(0x144)
+#define QSERDES_COM_VCO_TUNE_TIMER2		COM_OFF(0x148)
+#define QSERDES_COM_CLK_SELECT			COM_OFF(0x174)
+#define QSERDES_COM_HSCLK_SEL			COM_OFF(0x178)
+#define QSERDES_COM_CORECLK_DIV			COM_OFF(0x184)
+#define QSERDES_COM_CORE_CLK_EN			COM_OFF(0x18C)
+#define QSERDES_COM_CMN_CONFIG			COM_OFF(0x194)
+#define QSERDES_COM_SVS_MODE_CLK_SEL		COM_OFF(0x19C)
+#define QSERDES_COM_CORECLK_DIV_MODE1		COM_OFF(0x1BC)
+
+/* UFS PHY registers */
+#define UFS_PHY_PHY_START			PHY_OFF(0x00)
+#define UFS_PHY_POWER_DOWN_CONTROL		PHY_OFF(0x04)
+#define UFS_PHY_PCS_READY_STATUS		PHY_OFF(0x168)
+
+/* UFS PHY TX registers */
+#define QSERDES_TX_HIGHZ_TRANSCEIVER_BIAS_DRVR_EN	TX_OFF(0, 0x68)
+#define QSERDES_TX_LANE_MODE				TX_OFF(0, 0x94)
+
+/* UFS PHY RX registers */
+#define QSERDES_RX_UCDR_FASTLOCK_FO_GAIN	RX_OFF(0, 0x40)
+#define QSERDES_RX_RX_TERM_BW			RX_OFF(0, 0x90)
+#define QSERDES_RX_RX_EQ_GAIN1_LSB		RX_OFF(0, 0xC4)
+#define QSERDES_RX_RX_EQ_GAIN1_MSB		RX_OFF(0, 0xC8)
+#define QSERDES_RX_RX_EQ_GAIN2_LSB		RX_OFF(0, 0xCC)
+#define QSERDES_RX_RX_EQ_GAIN2_MSB		RX_OFF(0, 0xD0)
+#define QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2	RX_OFF(0, 0xD8)
+#define QSERDES_RX_SIGDET_CNTRL			RX_OFF(0, 0x114)
+#define QSERDES_RX_SIGDET_LVL			RX_OFF(0, 0x118)
+#define QSERDES_RX_SIGDET_DEGLITCH_CNTRL	RX_OFF(0, 0x11C)
+#define QSERDES_RX_RX_INTERFACE_MODE		RX_OFF(0, 0x12C)
+
+/*
+ * This structure represents the 14nm specific phy.
+ * common_cfg MUST remain the first field in this structure
+ * in case extra fields are added. This way, when calling
+ * get_ufs_qcom_phy() of generic phy, we can extract the
+ * common phy structure (struct ufs_qcom_phy) out of it
+ * regardless of the relevant specific phy.
+ */
+struct ufs_qcom_phy_qmp_14nm {
+	struct ufs_qcom_phy common_cfg;
+};
+
+static struct ufs_qcom_phy_calibration phy_cal_table_rate_A[] = {
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_POWER_DOWN_CONTROL, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_CMN_CONFIG, 0x0e),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_SYSCLK_EN_SEL, 0xd7),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_CLK_SELECT, 0x30),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_SYS_CLK_CTRL, 0x06),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_BIAS_EN_CLKBUFLR_EN, 0x08),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_BG_TIMER, 0x0a),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_HSCLK_SEL, 0x05),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_CORECLK_DIV, 0x0a),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_CORECLK_DIV_MODE1, 0x0a),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_LOCK_CMP_EN, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_VCO_TUNE_CTRL, 0x10),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL, 0x20),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_CORE_CLK_EN, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_LOCK_CMP_CFG, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_VCO_TUNE_TIMER1, 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_VCO_TUNE_TIMER2, 0x3f),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_VCO_TUNE_MAP, 0x14),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_SVS_MODE_CLK_SEL, 0x05),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START_MODE0, 0x82),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1_MODE0, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2_MODE0, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3_MODE0, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_CP_CTRL_MODE0, 0x0b),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_RCTRL_MODE0, 0x16),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CCTRL_MODE0, 0x28),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_INTEGLOOP_GAIN0_MODE0, 0x80),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_INTEGLOOP_GAIN1_MODE0, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_VCO_TUNE1_MODE0, 0x28),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_VCO_TUNE2_MODE0, 0x02),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_LOCK_CMP1_MODE0, 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_LOCK_CMP2_MODE0, 0x0c),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_LOCK_CMP3_MODE0, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START_MODE1, 0x98),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1_MODE1, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2_MODE1, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3_MODE1, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_CP_CTRL_MODE1, 0x0b),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_RCTRL_MODE1, 0x16),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CCTRL_MODE1, 0x28),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_INTEGLOOP_GAIN0_MODE1, 0x80),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_INTEGLOOP_GAIN1_MODE1, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_VCO_TUNE1_MODE1, 0xd6),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_VCO_TUNE2_MODE1, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_LOCK_CMP1_MODE1, 0x32),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_LOCK_CMP2_MODE1, 0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_LOCK_CMP3_MODE1, 0x00),
+
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_HIGHZ_TRANSCEIVER_BIAS_DRVR_EN, 0x45),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE, 0x02),
+
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_LVL, 0x24),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL, 0x02),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_INTERFACE_MODE, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_DEGLITCH_CNTRL, 0x18),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FASTLOCK_FO_GAIN, 0x0B),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_TERM_BW, 0x5B),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB, 0xFF),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB, 0x3F),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB, 0xFF),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB, 0x0F),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2, 0x0E),
+};
+
+static struct ufs_qcom_phy_calibration phy_cal_table_rate_B[] = {
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_VCO_TUNE_MAP, 0x54),
+};
+
+#endif
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
