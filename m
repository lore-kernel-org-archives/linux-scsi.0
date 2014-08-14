From: "Yaniv Gardi" <ygardi@codeaurora.org>
Subject: RE: [PATCH v3] scsi: ufs-msm: add UFS controller support for Qualcomm MSM chips
Date: Thu, 14 Aug 2014 17:27:57 +0300
Message-ID: <001201cfb7cb$f5aeee40$e10ccac0$@codeaurora.org>
References: <1408026157-26972-1-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:37381 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaHNO2N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2014 10:28:13 -0400
In-Reply-To: <1408026157-26972-1-git-send-email-ygardi@codeaurora.org>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, noag@codeaurora.org, draviv@codeaurora.org, 'Rob Herring' <robh+dt@kernel.org>, 'Pawel Moll' <pawel.moll@arm.com>, 'Mark Rutland' <mark.rutland@arm.com>, 'Ian Campbell' <ijc+devicetree@hellion.org.uk>, 'Kumar Gala' <galak@codeaurora.org>, 'Vinayak Holikatti' <vinholikatti@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>, 'Grant Likely' <grant.likely@linaro.org>, 'Sujit Reddy Thumma' <sthumma@codeaurora.org>, 'Sahitya Tummala' <stummala@codeaurora.org>, "'open list:OPEN FIRMWARE AND...'" <devicetree@vger.kernel.org>

All,

This patch is dependent and come on top of draviv 16 patch-set
In this patch we introduce 8 new ufs-msm files that we are working with,
using msm chips.
Please review and comment

Thanks,
Yaniv

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Yaniv Gardi
Sent: Thursday, August 14, 2014 5:22 PM
To: James.Bottomley@HansenPartnership.com; hch@infradead.org
Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org;
linux-arm-msm@vger.kernel.org; santoshsy@gmail.com;
linux-scsi-owner@vger.kernel.org; subhashj@codeaurora.org;
ygardi@codeaurora.org; noag@codeaurora.org; draviv@codeaurora.org; Rob
Herring; Pawel Moll; Mark Rutland; Ian Campbell; Kumar Gala; Vinayak
Holikatti; James E.J. Bottomley; Grant Likely; Sujit Reddy Thumma; Sahitya
Tummala; open list:OPEN FIRMWARE AND...
Subject: [PATCH v3] scsi: ufs-msm: add UFS controller support for Qualcomm
MSM chips

The files in this change implement the UFS HW (controller & PHY) specific
behavior in Qualcomm MSM chips.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
---
 Documentation/devicetree/bindings/ufs/ufs-msm.txt  |   37 +
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |    4 +
 drivers/scsi/ufs/Kconfig                           |   12 +
 drivers/scsi/ufs/Makefile                          |    4 +
 drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.c            |  254 +++++
 drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.h            |  216 ++++
 drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.c            |  368 +++++++
 drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.h            |  735 +++++++++++++
 drivers/scsi/ufs/ufs-msm-phy.c                     |  646 ++++++++++++
 drivers/scsi/ufs/ufs-msm-phy.h                     |  193 ++++
 drivers/scsi/ufs/ufs-msm.c                         | 1105
++++++++++++++++++++
 drivers/scsi/ufs/ufs-msm.h                         |  158 +++
 12 files changed, 3732 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-msm.txt
 create mode 100644 drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.c
 create mode 100644 drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.h
 create mode 100644 drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.c
 create mode 100644 drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.h
 create mode 100644 drivers/scsi/ufs/ufs-msm-phy.c
 create mode 100644 drivers/scsi/ufs/ufs-msm-phy.h
 create mode 100644 drivers/scsi/ufs/ufs-msm.c
 create mode 100644 drivers/scsi/ufs/ufs-msm.h

diff --git a/Documentation/devicetree/bindings/ufs/ufs-msm.txt
b/Documentation/devicetree/bindings/ufs/ufs-msm.txt
new file mode 100644
index 0000000..b5caace
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/ufs-msm.txt
@@ -0,0 +1,37 @@
+* MSM Universal Flash Storage (UFS) PHY
+
+UFSPHY nodes are defined to describe on-chip UFS PHY hardware macro.
+Each UFS PHY node should have its own node.
+
+To bind UFS PHY with UFS host controller, the controller node should
+contain a phandle reference to UFS PHY node.
+
+Required properties:
+- compatible        : compatible list, contains "qcom,ufs-msm-phy-qmp-28nm"
+                      or "qcom,ufs-msm-phy-qmp-20nm" according to the
relevant
+                      phy in use
+- reg               : <registers mapping>
+- #phy-cells         : This property shall be set to 0
+- vdda-phy-supply   : phandle to main PHY supply for analog domain
+- vdda-pll-supply   : phandle to PHY PLL and Power-Gen block power supply
+
+Optional properties:
+- vdda-phy-max-microamp : specifies max. load that can be drawn from phy
supply
+- vdda-pll-max-microamp : specifies max. load that can be drawn from pll
supply
+
+Example:
+
+	ufsphy1: ufsphy@0xfc597000 {
+		compatible = "qcom,ufs-msm-phy-qmp-28nm";
+		reg = <0xfc597000 0x800>;
+		#phy-cells = <0>;
+		vdda-phy-supply = <&pma8084_l4>;
+		vdda-pll-supply = <&pma8084_l12>;
+		vdda-phy-max-microamp = <50000>;
+		vdda-pll-max-microamp = <1000>;
+	};
+
+	ufshc@0xfc598000 {
+		...
+		phys = <&ufsphy1>;
+	};
diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index e73a619..378585c 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -9,6 +9,9 @@ Required properties:
 - reg               : <registers mapping>
 
 Optional properties:
+- phys			: phandle to UFS PHY node
+- phy-names		: the string "ufs_msm_phy" when is found in a node,
along
+			  with "phys" attribute, provides phandle to UFS PHY
node
 - vcc-supply            : phandle to VCC supply regulator node
 - vccq-supply           : phandle to VCCQ supply regulator node
 - vccq2-supply          : phandle to VCCQ2 supply regulator node
@@ -39,6 +42,7 @@ Example:
 		reg = <0xfc598000 0x800>;
 		interrupts = <0 28 0>;
 
+		ufs-phy = <&ufsphy>;
 		vcc-supply = <&xxx_reg1>;
 		vcc-supply-1p8;
 		vccq-supply = <&xxx_reg2>;
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 6e07b2a..a8259e0 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -70,3 +70,15 @@ config SCSI_UFSHCD_PLATFORM
 	If you have a controller with this interface, say Y or M here.
 
 	  If unsure, say N.
+
+config SCSI_UFS_MSM
+	bool "MSM specific hooks to UFS controller platform driver"
+	depends on SCSI_UFSHCD_PLATFORM && ARCH_MSM
+	help
+	  This selects the MSM specific additions to UFSHCD platform driver.
+	  UFS host on MSM needs some vendor specific configuration before
+	  accessing the hardware which includes PHY configuration and vendor
+	  specific registers.
+
+	  Select this if you have UFS controller on MSM chipset.
+	  If unsure, say N.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 1e5bd48..35b6e4d 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -1,4 +1,8 @@
 # UFSHCD makefile
+obj-$(CONFIG_SCSI_UFS_MSM) += ufs-msm.o
+obj-$(CONFIG_SCSI_UFS_MSM) += ufs-msm-phy.o
+obj-$(CONFIG_SCSI_UFS_MSM) += ufs-msm-phy-qmp-28nm.o
+obj-$(CONFIG_SCSI_UFS_MSM) += ufs-msm-phy-qmp-20nm.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
diff --git a/drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.c
b/drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.c
new file mode 100644
index 0000000..2b48bac
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.c
@@ -0,0 +1,254 @@
+/*
+ * Copyright (c) 2013-2014, Linux Foundation. All rights reserved.
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
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/time.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/iopoll.h>
+#include <linux/platform_device.h>
+#include <linux/msm-bus.h>
+
+#include "ufshcd.h"
+#include "unipro.h"
+#include "ufs-msm.h"
+#include "ufs-msm-phy.h"
+#include "ufs-msm-phy-qmp-20nm.h"
+
+#define UFS_PHY_NAME "ufs_msm_phy_qmp_20nm"
+
+static int ufs_msm_phy_qmp_20nm_phy_calibrate(struct ufs_msm_phy
*ufs_msm_phy)
+{
+	struct ufs_msm_phy_calibration *tbl_A, *tbl_B;
+	int tbl_size_A, tbl_size_B;
+	int rate = UFS_MSM_LIMIT_HS_RATE;
+	int err;
+
+	tbl_size_A = ARRAY_SIZE(phy_cal_table_rate_A);
+	tbl_A = phy_cal_table_rate_A;
+
+	tbl_size_B = ARRAY_SIZE(phy_cal_table_rate_B);
+	tbl_B = phy_cal_table_rate_B;
+
+	err = ufs_msm_phy_calibrate(ufs_msm_phy, tbl_A, tbl_size_A,
+						tbl_B, tbl_size_B, rate);
+
+	if (err)
+		dev_err(ufs_msm_phy->dev, "%s: ufs_msm_phy_calibrate()
failed %d\n",
+			__func__, err);
+
+	return err;
+}
+
+static int ufs_msm_phy_qmp_20nm_init(struct phy *generic_phy)
+{
+	struct ufs_msm_phy_qmp_20nm *phy = phy_get_drvdata(generic_phy);
+	struct ufs_msm_phy *phy_common = &phy->common_cfg;
+	int err = 0;
+
+	err = ufs_msm_phy_init_clks(generic_phy, phy_common);
+	if (err) {
+		dev_err(phy_common->dev, "%s: ufs_msm_phy_init_clks() failed
%d\n",
+			__func__, err);
+		goto out;
+	}
+
+	err = ufs_msm_phy_init_vregulators(generic_phy, phy_common);
+	if (err)
+		dev_err(phy_common->dev, "%s: ufs_msm_phy_init_vregulators()
failed %d\n",
+			__func__, err);
+
+out:
+	return err;
+}
+
+static
+void ufs_msm_phy_qmp_20nm_power_control(struct ufs_msm_phy *phy, bool val)
+{
+	if (val) {
+		writel_relaxed(0x1, phy->mmio + UFS_PHY_POWER_DOWN_CONTROL);
+		/*
+		 * Before any transactions involving PHY, ensure PHY knows
+		 * that it's analog rail is powered ON.
+		 */
+		mb();
+
+		if (phy->quirks &
+
MSM_UFS_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE) {
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
+			 * Make sure workaround is deactivated before
proceeding
+			 * with normal PHY operations.
+			 */
+			mb();
+		}
+	} else {
+		if (phy->quirks &
+
MSM_UFS_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE) {
+			writel_relaxed(0x0A, phy->mmio +
+				       QSERDES_COM_SYSCLK_EN_SEL_TXBAND);
+			writel_relaxed(0x02, phy->mmio +
+				       QSERDES_COM_SYSCLK_EN_SEL_TXBAND);
+			/*
+			 * Make sure that above workaround is activated
before
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
+void ufs_msm_phy_qmp_20nm_set_tx_lane_enable(struct ufs_msm_phy *phy, u32
val)
+{
+	writel_relaxed(val & UFS_PHY_TX_LANE_ENABLE_MASK,
+			phy->mmio + UFS_PHY_TX_LANE_ENABLE);
+	mb();
+}
+
+static inline void ufs_msm_phy_qmp_20nm_start_serdes(struct ufs_msm_phy
*phy)
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
+static int ufs_msm_phy_qmp_20nm_is_pcs_ready(struct ufs_msm_phy
*phy_common)
+{
+	int err = 0;
+	u32 val;
+
+	err = readl_poll_timeout(phy_common->mmio +
UFS_PHY_PCS_READY_STATUS,
+			val, (val & MASK_PCS_READY), 10, 1000000);
+	if (err)
+		dev_err(phy_common->dev, "%s: poll for pcs failed err =
%d\n",
+			__func__, err);
+	return err;
+}
+
+static void ufs_msm_phy_qmp_20nm_advertise_quirks(struct phy *generic_phy)
+{
+	struct ufs_msm_phy_qmp_20nm *phy =  phy_get_drvdata(generic_phy);
+	struct ufs_msm_phy *phy_common = &(phy->common_cfg);
+
+	phy_common->quirks =
+		MSM_UFS_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE;
+}
+
+struct phy_ops ufs_msm_phy_qmp_20nm_phy_ops = {
+	.init		= ufs_msm_phy_qmp_20nm_init,
+	.exit		= ufs_msm_phy_exit,
+	.power_on	= ufs_msm_phy_power_on,
+	.power_off	= ufs_msm_phy_power_off,
+	.advertise_quirks = ufs_msm_phy_qmp_20nm_advertise_quirks,
+	.owner		= THIS_MODULE,
+};
+
+struct ufs_msm_phy_specific_ops phy_20nm_ops = {
+	.calibrate_phy		= ufs_msm_phy_qmp_20nm_phy_calibrate,
+	.start_serdes		= ufs_msm_phy_qmp_20nm_start_serdes,
+	.is_physical_coding_sublayer_ready =
ufs_msm_phy_qmp_20nm_is_pcs_ready,
+	.set_tx_lane_enable	= ufs_msm_phy_qmp_20nm_set_tx_lane_enable,
+	.power_control		= ufs_msm_phy_qmp_20nm_power_control,
+};
+
+static int ufs_msm_phy_qmp_20nm_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct phy *generic_phy;
+	struct ufs_msm_phy_qmp_20nm *phy;
+	int err = 0;
+
+	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
+	if (!phy) {
+		dev_err(dev, "%s: failed to allocate phy\n", __func__);
+		err = -ENOMEM;
+		goto out;
+	}
+
+	generic_phy = ufs_msm_phy_generic_probe(pdev, &phy->common_cfg,
+				&ufs_msm_phy_qmp_20nm_phy_ops,
&phy_20nm_ops);
+
+	if (!generic_phy) {
+		dev_err(dev, "%s: ufs_msm_phy_generic_probe() failed\n",
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
+static int ufs_msm_phy_qmp_20nm_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct phy *generic_phy = to_phy(dev);
+	struct ufs_msm_phy *ufs_msm_phy = get_ufs_msm_phy(generic_phy);
+	int err = 0;
+
+	err = ufs_msm_phy_remove(generic_phy, ufs_msm_phy);
+	if (err)
+		dev_err(dev, "%s: ufs_msm_phy_remove failed = %d\n",
+			__func__, err);
+
+	return err;
+}
+
+static const struct of_device_id ufs_msm_phy_qmp_20nm_of_match[] = {
+	{.compatible = "qcom,ufs-msm-phy-qmp-20nm"},
+	{},
+};
+MODULE_DEVICE_TABLE(of, ufs_msm_phy_qmp_20nm_of_match);
+
+static struct platform_driver ufs_msm_phy_qmp_20nm_driver = {
+	.probe = ufs_msm_phy_qmp_20nm_probe,
+	.remove = ufs_msm_phy_qmp_20nm_remove,
+	.driver = {
+		.of_match_table = ufs_msm_phy_qmp_20nm_of_match,
+		.name = "ufs_msm_phy_qmp_20nm",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_platform_driver(ufs_msm_phy_qmp_20nm_driver);
+
+MODULE_DESCRIPTION("Universal Flash Storage (UFS) MSM PHY QMP 20nm");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.h
b/drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.h
new file mode 100644
index 0000000..13bf2f7
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.h
@@ -0,0 +1,216 @@
+/*
+ * Copyright (c) 2013-2014, Linux Foundation. All rights reserved.
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
+#ifndef UFS_MSM_PHY_QMP_20NM_H_
+#define UFS_MSM_PHY_QMP_20NM_H_
+
+#include "ufs-msm-phy.h"
+
+/* MSM UFS PHY control registers */
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
+ * get_ufs_msm_phy() of generic phy, we can extract the
+ * common phy structure (struct ufs_msm_phy) out of it
+ * regardless of the relevant specific phy.
+ */
+struct ufs_msm_phy_qmp_20nm {
+	struct ufs_msm_phy common_cfg;
+};
+
+static struct ufs_msm_phy_calibration phy_cal_table_rate_A[] = {
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_POWER_DOWN_CONTROL, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_VCOTAIL_EN, 0xe1),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CRCTRL, 0xcc),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_SYSCLK_EN_SEL_TXBAND, 0x08),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CLKEPDIV, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_RXTXEPCLK_EN, 0x10),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x82),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START2, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1, 0x80),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2, 0x80),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3, 0x40),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x19),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP3, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP_EN, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL, 0x90),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL2, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL1(0), 0xf2),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(0), 0x0c),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(0), 0x12),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL1(1), 0xf2),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(1), 0x0c),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(1), 0x12),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB(0), 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB(0), 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB(0), 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB(1), 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB(1), 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB(1), 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETI, 0x3f),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETP, 0x1b),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETP, 0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETI, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_EMP_POST1_LVL(0), 0x2F),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_DRV_LVL(0), 0x20),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_EMP_POST1_LVL(1), 0x2F),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_DRV_LVL(1), 0x20),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(0), 0x68),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(1), 0x68),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(1), 0xdc),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(0), 0xdc),
+};
+
+static struct ufs_msm_phy_calibration phy_cal_table_rate_B[] = {
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_POWER_DOWN_CONTROL, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CRCTRL, 0xcc),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_SYSCLK_EN_SEL_TXBAND, 0x08),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CLKEPDIV, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_RXTXEPCLK_EN, 0x10),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x98),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START2, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1, 0x80),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2, 0x80),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3, 0x40),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0x65),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x1e),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP3, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP_EN, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL, 0x90),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL1(0), 0xf2),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(0), 0x0c),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(0), 0x12),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL1(1), 0xf2),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(1), 0x0c),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(1), 0x12),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB(0), 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB(0), 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB(0), 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_LSB(1), 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1_MSB(1), 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_LSB(1), 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2_MSB(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETI, 0x3f),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETP, 0x1b),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETP, 0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETI, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(0), 0x68),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(1), 0x68),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(1), 0xdc),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(0), 0xdc),
+};
+
+#endif
diff --git a/drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.c
b/drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.c
new file mode 100644
index 0000000..6c82a59
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.c
@@ -0,0 +1,368 @@
+/*
+ * Copyright (c) 2013-2014, Linux Foundation. All rights reserved.
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
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/time.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/iopoll.h>
+#include <linux/platform_device.h>
+#include <linux/msm-bus.h>
+#include <linux/phy/phy.h>
+
+#include "ufshcd.h"
+#include "unipro.h"
+#include "ufs-msm.h"
+#include "ufs-msm-phy.h"
+#include "ufs-msm-phy-qmp-28nm.h"
+
+#define UFS_PHY_NAME "ufs_msm_phy_qmp_28nm"
+
+static
+void ufs_msm_phy_qmp_28nm_power_control(struct ufs_msm_phy *phy, bool val)
+{
+	if (val) {
+		writel_relaxed(0x1, phy->mmio + UFS_PHY_POWER_DOWN_CONTROL);
+		/*
+		 * Before any transactions involving PHY, ensure PHY knows
+		 * that it's analog rail is powered ON. This also ensures
+		 * that PHY is out of power collapse before enabling the
+		 * SIGDET.
+		 */
+		mb();
+		if (phy->quirks &
MSM_UFS_PHY_DIS_SIGDET_BEFORE_PWR_COLLAPSE) {
+			writel_relaxed(0xC0,
+				phy->mmio + QSERDES_RX_SIGDET_CNTRL(0));
+			writel_relaxed(0xC0,
+				phy->mmio + QSERDES_RX_SIGDET_CNTRL(1));
+			/*
+			 * make sure that SIGDET is enabled before
proceeding
+			 * further.
+			 */
+			 mb();
+		}
+	} else {
+		 if (phy->quirks &
MSM_UFS_PHY_DIS_SIGDET_BEFORE_PWR_COLLAPSE) {
+			writel_relaxed(0x0,
+				phy->mmio + QSERDES_RX_SIGDET_CNTRL(0));
+			writel_relaxed(0x0,
+				phy->mmio + QSERDES_RX_SIGDET_CNTRL(1));
+			/*
+			 * Ensure that SIGDET is disabled before PHY power
+			 * collapse
+			 */
+			mb();
+		}
+		writel_relaxed(0x0, phy->mmio + UFS_PHY_POWER_DOWN_CONTROL);
+		/*
+		 * ensure that PHY knows its PHY analog rail is going
+		 * to be powered down
+		 */
+		mb();
+	}
+}
+
+static int ufs_msm_phy_qmp_28nm_init(struct phy *generic_phy)
+{
+	struct ufs_msm_phy_qmp_28nm *phy = phy_get_drvdata(generic_phy);
+	struct ufs_msm_phy *phy_common = &phy->common_cfg;
+	int err = 0;
+
+	err = ufs_msm_phy_init_clks(generic_phy, phy_common);
+	if (err) {
+		dev_err(phy_common->dev, "%s: ufs_msm_phy_init_clks() failed
%d\n",
+			__func__, err);
+		goto out;
+	}
+
+	err = ufs_msm_phy_init_vregulators(generic_phy, phy_common);
+	if (err)
+		dev_err(phy_common->dev, "%s: ufs_msm_phy_init_vregulators()
failed %d\n",
+			__func__, err);
+
+out:
+	return err;
+}
+
+static int ufs_msm_phy_qmp_28nm_calibrate(struct ufs_msm_phy *ufs_msm_phy)
+{
+	struct ufs_msm_phy_calibration *tbl_A, *tbl_B;
+	int tbl_size_A, tbl_size_B;
+	int rate = UFS_MSM_LIMIT_HS_RATE;
+	u8 major = ufs_msm_phy->host_ctrl_rev_major;
+	u16 minor = ufs_msm_phy->host_ctrl_rev_minor;
+	u16 step = ufs_msm_phy->host_ctrl_rev_step;
+	int err;
+
+	if ((major == 0x1) && (minor == 0x001) && (step == 0x0000)) {
+		tbl_size_A = ARRAY_SIZE(phy_cal_table_ctrl_1_1_0_rate_A);
+		tbl_A = phy_cal_table_ctrl_1_1_0_rate_A;
+	} else if ((major == 0x1) && (minor == 0x001) && (step == 0x0001)) {
+		tbl_size_A = ARRAY_SIZE(phy_cal_table_ctrl_1_1_1_rate_A);
+		tbl_A = phy_cal_table_ctrl_1_1_1_rate_A;
+	}
+
+	tbl_B = phy_cal_table_rate_B;
+	tbl_size_B = ARRAY_SIZE(phy_cal_table_rate_B);
+
+	err = ufs_msm_phy_calibrate(ufs_msm_phy, tbl_A, tbl_size_A,
+			      tbl_B, tbl_size_B, rate);
+	if (err)
+		dev_err(ufs_msm_phy->dev, "%s: ufs_msm_phy_calibrate()
failed %d\n",
+			__func__, err);
+
+	return err;
+}
+
+static
+u32 ufs_msm_phy_qmp_28nm_read_attr(struct ufs_msm_phy *phy_common, u32
attr)
+
+{
+	u32 l0, l1;
+
+	writel_relaxed(attr, phy_common->mmio + UFS_PHY_RMMI_ATTRID);
+	/* Read attribute value for both lanes */
+	writel_relaxed((UFS_PHY_RMMI_CFGRD_L0 | UFS_PHY_RMMI_CFGRD_L1),
+		       phy_common->mmio + UFS_PHY_RMMI_ATTR_CTRL);
+
+	l0 = readl_relaxed(phy_common->mmio +
UFS_PHY_RMMI_ATTRRDVAL_L0_STATUS);
+	l1 = readl_relaxed(phy_common->mmio +
UFS_PHY_RMMI_ATTRRDVAL_L1_STATUS);
+	/* Both lanes should have the same value for same attribute type */
+	if (unlikely(l0 != l1))
+		dev_warn(phy_common->dev, "%s: attr 0x%x values are not same
for Lane-0 and Lane-1, l0=0x%x, l1=0x%x",
+				__func__, attr, l0, l1);
+
+	/* must clear now */
+	writel_relaxed(0x00, phy_common->mmio + UFS_PHY_RMMI_ATTR_CTRL);
+
+	return l0;
+}
+
+static
+void ufs_msm_phy_qmp_28nm_save_configuration(struct ufs_msm_phy
*phy_common)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cached_phy_regs); i++)
+		cached_phy_regs[i].cfg_value =
+			readl_relaxed(phy_common->mmio +
+				      cached_phy_regs[i].reg_offset);
+
+	for (i = 0; i < ARRAY_SIZE(cached_phy_attr); i++)
+		cached_phy_attr[i].value =
+			ufs_msm_phy_qmp_28nm_read_attr(phy_common,
+					cached_phy_attr[i].att);
+}
+
+static
+void ufs_msm_phy_qmp_28nm_set_tx_lane_enable(struct ufs_msm_phy *phy, u32
val)
+{
+	writel_relaxed(val & UFS_PHY_TX_LANE_ENABLE_MASK,
+			phy->mmio + UFS_PHY_TX_LANE_ENABLE);
+	mb();
+}
+
+static inline void ufs_msm_phy_qmp_28nm_start_serdes(struct ufs_msm_phy
*phy)
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
+static void
+ufs_msm_phy_qmp_28nm_write_attr(struct phy *generic_phy, u32 attr, u32 val)
+{
+	struct ufs_msm_phy_qmp_28nm *phy =  phy_get_drvdata(generic_phy);
+	struct ufs_msm_phy *phy_common = &(phy->common_cfg);
+
+	writel_relaxed(attr, phy_common->mmio + UFS_PHY_RMMI_ATTRID);
+	writel_relaxed(val, phy_common->mmio + UFS_PHY_RMMI_ATTRWRVAL);
+	/* update attribute for both lanes */
+	writel_relaxed((UFS_PHY_RMMI_CFGWR_L0 | UFS_PHY_RMMI_CFGWR_L1),
+		       phy_common->mmio + UFS_PHY_RMMI_ATTR_CTRL);
+	if (is_mphy_tx_attr(attr))
+		writel_relaxed((UFS_PHY_RMMI_TX_CFGUPDT_L0 |
+				UFS_PHY_RMMI_TX_CFGUPDT_L1),
+			       phy_common->mmio + UFS_PHY_RMMI_ATTR_CTRL);
+	else
+		writel_relaxed((UFS_PHY_RMMI_RX_CFGUPDT_L0 |
+				UFS_PHY_RMMI_RX_CFGUPDT_L1),
+			       phy_common->mmio + UFS_PHY_RMMI_ATTR_CTRL);
+
+	writel_relaxed(0x00, phy_common->mmio + UFS_PHY_RMMI_ATTR_CTRL);
+}
+
+static void ufs_msm_phy_qmp_28nm_restore_attrs(struct phy *generic_phy)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cached_phy_attr); i++)
+		ufs_msm_phy_qmp_28nm_write_attr(generic_phy,
+			cached_phy_attr[i].att, cached_phy_attr[i].value);
+}
+
+static int ufs_msm_phy_qmp_28nm_is_pcs_ready(struct ufs_msm_phy
*phy_common)
+{
+	int err = 0;
+	u32 val;
+
+	err = readl_poll_timeout(phy_common->mmio +
UFS_PHY_PCS_READY_STATUS,
+			val, (val & MASK_PCS_READY), 10, 1000000);
+	if (err)
+		dev_err(phy_common->dev, "%s: phy init failed, %d\n",
+			__func__, err);
+
+	return err;
+}
+
+static void ufs_msm_phy_qmp_28nm_advertise_quirks(struct phy *generic_phy)
+{
+	struct ufs_msm_phy_qmp_28nm *phy =  phy_get_drvdata(generic_phy);
+	struct ufs_msm_phy *phy_common = &(phy->common_cfg);
+
+	phy_common->quirks = MSM_UFS_PHY_QUIRK_CFG_RESTORE
+				|
MSM_UFS_PHY_DIS_SIGDET_BEFORE_PWR_COLLAPSE;
+}
+
+static int ufs_msm_phy_qmp_28nm_suspend(struct phy *generic_phy)
+{
+	struct ufs_msm_phy_qmp_28nm *phy =  phy_get_drvdata(generic_phy);
+	struct ufs_msm_phy *phy_common = &(phy->common_cfg);
+
+	ufs_msm_phy_disable_ref_clk(generic_phy);
+	ufs_msm_phy_qmp_28nm_power_control(phy_common, false);
+
+	ufs_msm_phy_disable_vreg(generic_phy, &phy_common->vdda_phy);
+	ufs_msm_phy_disable_vreg(generic_phy, &phy_common->vdda_pll);
+
+	return 0;
+}
+
+static int ufs_msm_phy_qmp_28nm_resume(struct phy *generic_phy)
+{
+	struct ufs_msm_phy_qmp_28nm *phy = phy_get_drvdata(generic_phy);
+	struct ufs_msm_phy *phy_common = &phy->common_cfg;
+	int err = 0;
+
+	ufs_msm_phy_qmp_28nm_start_serdes(phy_common);
+
+	ufs_msm_phy_qmp_28nm_restore_attrs(generic_phy);
+
+	err = ufs_msm_phy_qmp_28nm_is_pcs_ready(phy_common);
+	if (err)
+		dev_err(phy_common->dev, "%s: failed to init phy = %d\n",
+			__func__, err);
+
+	return err;
+}
+
+struct phy_ops ufs_msm_phy_qmp_28nm_phy_ops = {
+	.init		= ufs_msm_phy_qmp_28nm_init,
+	.exit		= ufs_msm_phy_exit,
+	.power_on	= ufs_msm_phy_power_on,
+	.power_off	= ufs_msm_phy_power_off,
+	.advertise_quirks = ufs_msm_phy_qmp_28nm_advertise_quirks,
+	.suspend	= ufs_msm_phy_qmp_28nm_suspend,
+	.resume		= ufs_msm_phy_qmp_28nm_resume,
+	.owner		= THIS_MODULE,
+};
+
+struct ufs_msm_phy_specific_ops phy_28nm_ops = {
+	.calibrate_phy		= ufs_msm_phy_qmp_28nm_calibrate,
+	.start_serdes		= ufs_msm_phy_qmp_28nm_start_serdes,
+	.save_configuration	= ufs_msm_phy_qmp_28nm_save_configuration,
+	.is_physical_coding_sublayer_ready =
ufs_msm_phy_qmp_28nm_is_pcs_ready,
+	.set_tx_lane_enable	= ufs_msm_phy_qmp_28nm_set_tx_lane_enable,
+	.power_control		= ufs_msm_phy_qmp_28nm_power_control,
+};
+
+static int ufs_msm_phy_qmp_28nm_probe(struct platform_device *pdev)
+{
+	struct ufs_msm_phy_qmp_28nm *phy;
+	struct device *dev = &pdev->dev;
+	int err = 0;
+	struct phy *generic_phy;
+
+	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
+	if (!phy) {
+		err = -ENOMEM;
+		dev_err(dev, "%s: failed to allocate phy\n", __func__);
+		goto out;
+	}
+
+	phy->common_cfg.cached_regs =
+			(struct ufs_msm_phy_calibration *)cached_phy_regs;
+	phy->common_cfg.cached_regs_table_size =
+				ARRAY_SIZE(cached_phy_regs);
+
+	generic_phy = ufs_msm_phy_generic_probe(pdev, &phy->common_cfg,
+				&ufs_msm_phy_qmp_28nm_phy_ops,
&phy_28nm_ops);
+
+	if (!generic_phy) {
+		dev_err(dev, "%s: ufs_msm_phy_generic_probe() failed\n",
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
+static int ufs_msm_phy_qmp_28nm_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct phy *generic_phy = to_phy(dev);
+	struct ufs_msm_phy *ufs_msm_phy = get_ufs_msm_phy(generic_phy);
+	int err = 0;
+
+	err = ufs_msm_phy_remove(generic_phy, ufs_msm_phy);
+	if (err)
+		dev_err(dev, "%s: ufs_msm_phy_remove failed = %d\n",
+			__func__, err);
+
+	return err;
+}
+
+static const struct of_device_id ufs_msm_phy_qmp_28nm_of_match[] = {
+	{.compatible = "qcom,ufs-msm-phy-qmp-28nm"},
+	{},
+};
+MODULE_DEVICE_TABLE(of, ufs_msm_phy_qmp_28nm_of_match);
+
+static struct platform_driver ufs_msm_phy_qmp_28nm_driver = {
+	.probe = ufs_msm_phy_qmp_28nm_probe,
+	.remove = ufs_msm_phy_qmp_28nm_remove,
+	.driver = {
+		.of_match_table = ufs_msm_phy_qmp_28nm_of_match,
+		.name = "ufs_msm_phy_qmp_28nm",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_platform_driver(ufs_msm_phy_qmp_28nm_driver);
+
+MODULE_DESCRIPTION("Universal Flash Storage (UFS) MSM PHY QMP 28nm");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.h
b/drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.h
new file mode 100644
index 0000000..edb2892
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.h
@@ -0,0 +1,735 @@
+/*
+ * Copyright (c) 2013-2014, Linux Foundation. All rights reserved.
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
+#ifndef UFS_MSM_PHY_QMP_28NM_H_
+#define UFS_MSM_PHY_QMP_28NM_H_
+
+#include "ufs-msm-phy.h"
+
+/* MSM UFS PHY control registers */
+
+#define COM_OFF(x)     (0x000 + x)
+#define PHY_OFF(x)     (0x700 + x)
+#define TX_OFF(n, x)   (0x100 + (0x400 * n) + x)
+#define RX_OFF(n, x)   (0x200 + (0x400 * n) + x)
+
+/* UFS PHY PLL block registers */
+#define QSERDES_COM_SYS_CLK_CTRL                            COM_OFF(0x00)
+#define QSERDES_COM_PLL_VCOTAIL_EN                          COM_OFF(0x04)
+#define QSERDES_COM_CMN_MODE                                COM_OFF(0x08)
+#define QSERDES_COM_IE_TRIM                                 COM_OFF(0x0C)
+#define QSERDES_COM_IP_TRIM                                 COM_OFF(0x10)
+#define QSERDES_COM_PLL_CNTRL                               COM_OFF(0x14)
+#define QSERDES_COM_PLL_IP_SETI                             COM_OFF(0x18)
+#define QSERDES_COM_CORE_CLK_IN_SYNC_SEL                    COM_OFF(0x1C)
+#define QSERDES_COM_BIAS_EN_CLKBUFLR_EN                     COM_OFF(0x20)
+#define QSERDES_COM_PLL_CP_SETI                             COM_OFF(0x24)
+#define QSERDES_COM_PLL_IP_SETP                             COM_OFF(0x28)
+#define QSERDES_COM_PLL_CP_SETP                             COM_OFF(0x2C)
+#define QSERDES_COM_ATB_SEL1                                COM_OFF(0x30)
+#define QSERDES_COM_ATB_SEL2                                COM_OFF(0x34)
+#define QSERDES_COM_SYSCLK_EN_SEL                           COM_OFF(0x38)
+#define QSERDES_COM_RES_CODE_TXBAND                         COM_OFF(0x3C)
+#define QSERDES_COM_RESETSM_CNTRL                           COM_OFF(0x40)
+#define QSERDES_COM_PLLLOCK_CMP1                            COM_OFF(0x44)
+#define QSERDES_COM_PLLLOCK_CMP2                            COM_OFF(0x48)
+#define QSERDES_COM_PLLLOCK_CMP3                            COM_OFF(0x4C)
+#define QSERDES_COM_PLLLOCK_CMP_EN                          COM_OFF(0x50)
+#define QSERDES_COM_RES_TRIM_OFFSET                         COM_OFF(0x54)
+#define QSERDES_COM_BGTC                                    COM_OFF(0x58)
+#define QSERDES_COM_PLL_TEST_UPDN_RESTRIMSTEP               COM_OFF(0x5C)
+#define QSERDES_COM_PLL_VCO_TUNE                            COM_OFF(0x60)
+#define QSERDES_COM_DEC_START1                              COM_OFF(0x64)
+#define QSERDES_COM_PLL_AMP_OS                              COM_OFF(0x68)
+#define QSERDES_COM_SSC_EN_CENTER                           COM_OFF(0x6C)
+#define QSERDES_COM_SSC_ADJ_PER1                            COM_OFF(0x70)
+#define QSERDES_COM_SSC_ADJ_PER2                            COM_OFF(0x74)
+#define QSERDES_COM_SSC_PER1                                COM_OFF(0x78)
+#define QSERDES_COM_SSC_PER2                                COM_OFF(0x7C)
+#define QSERDES_COM_SSC_STEP_SIZE1                          COM_OFF(0x80)
+#define QSERDES_COM_SSC_STEP_SIZE2                          COM_OFF(0x84)
+#define QSERDES_COM_RES_TRIM_SEARCH                         COM_OFF(0x88)
+#define QSERDES_COM_RES_TRIM_FREEZE                         COM_OFF(0x8C)
+#define QSERDES_COM_RES_TRIM_EN_VCOCALDONE                  COM_OFF(0x90)
+#define QSERDES_COM_FAUX_EN                                 COM_OFF(0x94)
+#define QSERDES_COM_DIV_FRAC_START1                         COM_OFF(0x98)
+#define QSERDES_COM_DIV_FRAC_START2                         COM_OFF(0x9C)
+#define QSERDES_COM_DIV_FRAC_START3                         COM_OFF(0xA0)
+#define QSERDES_COM_DEC_START2                              COM_OFF(0xA4)
+#define QSERDES_COM_PLL_RXTXEPCLK_EN                        COM_OFF(0xA8)
+#define QSERDES_COM_PLL_CRCTRL                              COM_OFF(0xAC)
+#define QSERDES_COM_PLL_CLKEPDIV                            COM_OFF(0xB0)
+#define QSERDES_COM_PLL_FREQUPDATE                          COM_OFF(0xB4)
+#define QSERDES_COM_PLL_VCO_HIGH                            COM_OFF(0xB8)
+#define QSERDES_COM_RESET_SM                                COM_OFF(0xBC)
+
+/* UFS PHY registers */
+#define UFS_PHY_PHY_START                                   PHY_OFF(0x00)
+#define UFS_PHY_POWER_DOWN_CONTROL                          PHY_OFF(0x04)
+#define UFS_PHY_PWM_G1_CLK_DIVIDER                          PHY_OFF(0x08)
+#define UFS_PHY_PWM_G2_CLK_DIVIDER                          PHY_OFF(0x0C)
+#define UFS_PHY_PWM_G3_CLK_DIVIDER                          PHY_OFF(0x10)
+#define UFS_PHY_PWM_G4_CLK_DIVIDER                          PHY_OFF(0x14)
+#define UFS_PHY_TIMER_100US_SYSCLK_STEPS_MSB                PHY_OFF(0x18)
+#define UFS_PHY_TIMER_100US_SYSCLK_STEPS_LSB                PHY_OFF(0x1C)
+#define UFS_PHY_TIMER_20US_CORECLK_STEPS_MSB                PHY_OFF(0x20)
+#define UFS_PHY_TIMER_20US_CORECLK_STEPS_LSB                PHY_OFF(0x24)
+#define UFS_PHY_LINE_RESET_TIME                             PHY_OFF(0x28)
+#define UFS_PHY_LINE_RESET_GRANULARITY                      PHY_OFF(0x2C)
+#define UFS_PHY_CONTROLSYM_ONE_HOT_DISABLE                  PHY_OFF(0x30)
+#define UFS_PHY_CORECLK_PWM_G1_CLK_DIVIDER                  PHY_OFF(0x34)
+#define UFS_PHY_CORECLK_PWM_G2_CLK_DIVIDER                  PHY_OFF(0x38)
+#define UFS_PHY_CORECLK_PWM_G3_CLK_DIVIDER                  PHY_OFF(0x3C)
+#define UFS_PHY_CORECLK_PWM_G4_CLK_DIVIDER                  PHY_OFF(0x40)
+#define UFS_PHY_TX_LANE_ENABLE                              PHY_OFF(0x44)
+#define UFS_PHY_TSYNC_RSYNC_CNTL                            PHY_OFF(0x48)
+#define UFS_PHY_RETIME_BUFFER_EN                            PHY_OFF(0x4C)
+#define UFS_PHY_PLL_CNTL                                    PHY_OFF(0x50)
+#define UFS_PHY_TX_LARGE_AMP_DRV_LVL                        PHY_OFF(0x54)
+#define UFS_PHY_TX_LARGE_AMP_POST_EMP_LVL                   PHY_OFF(0x58)
+#define UFS_PHY_TX_SMALL_AMP_DRV_LVL                        PHY_OFF(0x5C)
+#define UFS_PHY_TX_SMALL_AMP_POST_EMP_LVL                   PHY_OFF(0x60)
+#define UFS_PHY_CFG_CHANGE_CNT_VAL                          PHY_OFF(0x64)
+#define UFS_PHY_OMC_STATUS_RDVAL                            PHY_OFF(0x68)
+#define UFS_PHY_RX_SYNC_WAIT_TIME                           PHY_OFF(0x6C)
+#define UFS_PHY_L0_BIST_CTRL                                PHY_OFF(0x70)
+#define UFS_PHY_L1_BIST_CTRL                                PHY_OFF(0x74)
+#define UFS_PHY_BIST_PRBS_POLY0                             PHY_OFF(0x78)
+#define UFS_PHY_BIST_PRBS_POLY1                             PHY_OFF(0x7C)
+#define UFS_PHY_BIST_PRBS_SEED0                             PHY_OFF(0x80)
+#define UFS_PHY_BIST_PRBS_SEED1                             PHY_OFF(0x84)
+#define UFS_PHY_BIST_FIXED_PAT_CTRL                         PHY_OFF(0x88)
+#define UFS_PHY_BIST_FIXED_PAT0_DATA                        PHY_OFF(0x8C)
+#define UFS_PHY_BIST_FIXED_PAT1_DATA                        PHY_OFF(0x90)
+#define UFS_PHY_BIST_FIXED_PAT2_DATA                        PHY_OFF(0x94)
+#define UFS_PHY_BIST_FIXED_PAT3_DATA                        PHY_OFF(0x98)
+#define UFS_PHY_TX_HSGEAR_CAPABILITY                        PHY_OFF(0x9C)
+#define UFS_PHY_TX_PWMGEAR_CAPABILITY                       PHY_OFF(0xA0)
+#define UFS_PHY_TX_AMPLITUDE_CAPABILITY                     PHY_OFF(0xA4)
+#define UFS_PHY_TX_EXTERNALSYNC_CAPABILITY                  PHY_OFF(0xA8)
+#define UFS_PHY_TX_HS_UNTERMINATED_LINE_DRIVE_CAPABILITY    PHY_OFF(0xAC)
+#define UFS_PHY_TX_LS_TERMINATED_LINE_DRIVE_CAPABILITY      PHY_OFF(0xB0)
+#define UFS_PHY_TX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY       PHY_OFF(0xB4)
+#define UFS_PHY_TX_MIN_STALL_NOCONFIG_TIME_CAPABILITY       PHY_OFF(0xB8)
+#define UFS_PHY_TX_MIN_SAVE_CONFIG_TIME_CAPABILITY          PHY_OFF(0xBC)
+#define UFS_PHY_TX_REF_CLOCK_SHARED_CAPABILITY              PHY_OFF(0xC0)
+#define UFS_PHY_TX_PHY_MAJORMINOR_RELEASE_CAPABILITY        PHY_OFF(0xC4)
+#define UFS_PHY_TX_PHY_EDITORIAL_RELEASE_CAPABILITY         PHY_OFF(0xC8)
+#define UFS_PHY_TX_HIBERN8TIME_CAPABILITY                   PHY_OFF(0xCC)
+#define UFS_PHY_RX_HSGEAR_CAPABILITY                        PHY_OFF(0xD0)
+#define UFS_PHY_RX_PWMGEAR_CAPABILITY                       PHY_OFF(0xD4)
+#define UFS_PHY_RX_HS_UNTERMINATED_CAPABILITY               PHY_OFF(0xD8)
+#define UFS_PHY_RX_LS_TERMINATED_CAPABILITY                 PHY_OFF(0xDC)
+#define UFS_PHY_RX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY       PHY_OFF(0xE0)
+#define UFS_PHY_RX_MIN_STALL_NOCONFIG_TIME_CAPABILITY       PHY_OFF(0xE4)
+#define UFS_PHY_RX_MIN_SAVE_CONFIG_TIME_CAPABILITY          PHY_OFF(0xE8)
+#define UFS_PHY_RX_REF_CLOCK_SHARED_CAPABILITY              PHY_OFF(0xEC)
+#define UFS_PHY_RX_HS_G1_SYNC_LENGTH_CAPABILITY             PHY_OFF(0xF0)
+#define UFS_PHY_RX_HS_G1_PREPARE_LENGTH_CAPABILITY          PHY_OFF(0xF4)
+#define UFS_PHY_RX_LS_PREPARE_LENGTH_CAPABILITY             PHY_OFF(0xF8)
+#define UFS_PHY_RX_PWM_BURST_CLOSURE_LENGTH_CAPABILITY      PHY_OFF(0xFC)
+#define UFS_PHY_RX_MIN_ACTIVATETIME_CAPABILITY              PHY_OFF(0x100)
+#define UFS_PHY_RX_PHY_MAJORMINOR_RELEASE_CAPABILITY        PHY_OFF(0x104)
+#define UFS_PHY_RX_PHY_EDITORIAL_RELEASE_CAPABILITY         PHY_OFF(0x108)
+#define UFS_PHY_RX_HIBERN8TIME_CAPABILITY                   PHY_OFF(0x10C)
+#define UFS_PHY_RX_HS_G2_SYNC_LENGTH_CAPABILITY             PHY_OFF(0x110)
+#define UFS_PHY_RX_HS_G3_SYNC_LENGTH_CAPABILITY             PHY_OFF(0x114)
+#define UFS_PHY_RX_HS_G2_PREPARE_LENGTH_CAPABILITY          PHY_OFF(0x118)
+#define UFS_PHY_RX_HS_G3_PREPARE_LENGTH_CAPABILITY          PHY_OFF(0x11C)
+#define UFS_PHY_DEBUG_BUS_SEL                               PHY_OFF(0x120)
+#define UFS_PHY_DEBUG_BUS_0_STATUS_CHK                      PHY_OFF(0x124)
+#define UFS_PHY_DEBUG_BUS_1_STATUS_CHK                      PHY_OFF(0x128)
+#define UFS_PHY_DEBUG_BUS_2_STATUS_CHK                      PHY_OFF(0x12C)
+#define UFS_PHY_DEBUG_BUS_3_STATUS_CHK                      PHY_OFF(0x130)
+#define UFS_PHY_PCS_READY_STATUS                            PHY_OFF(0x134)
+#define UFS_PHY_L0_BIST_CHK_ERR_CNT_L_STATUS                PHY_OFF(0x138)
+#define UFS_PHY_L0_BIST_CHK_ERR_CNT_H_STATUS                PHY_OFF(0x13C)
+#define UFS_PHY_L1_BIST_CHK_ERR_CNT_L_STATUS                PHY_OFF(0x140)
+#define UFS_PHY_L1_BIST_CHK_ERR_CNT_H_STATUS                PHY_OFF(0x144)
+#define UFS_PHY_L0_BIST_CHK_STATUS                          PHY_OFF(0x148)
+#define UFS_PHY_L1_BIST_CHK_STATUS                          PHY_OFF(0x14C)
+#define UFS_PHY_DEBUG_BUS_0_STATUS                          PHY_OFF(0x150)
+#define UFS_PHY_DEBUG_BUS_1_STATUS                          PHY_OFF(0x154)
+#define UFS_PHY_DEBUG_BUS_2_STATUS                          PHY_OFF(0x158)
+#define UFS_PHY_DEBUG_BUS_3_STATUS                          PHY_OFF(0x15C)
+#define UFS_PHY_RMMI_ATTR_CTRL                              PHY_OFF(0x16C)
+#define UFS_PHY_RMMI_RX_CFGUPDT_L1	(1 << 7)
+#define UFS_PHY_RMMI_TX_CFGUPDT_L1	(1 << 6)
+#define UFS_PHY_RMMI_CFGWR_L1		(1 << 5)
+#define UFS_PHY_RMMI_CFGRD_L1		(1 << 4)
+#define UFS_PHY_RMMI_RX_CFGUPDT_L0	(1 << 3)
+#define UFS_PHY_RMMI_TX_CFGUPDT_L0	(1 << 2)
+#define UFS_PHY_RMMI_CFGWR_L0		(1 << 1)
+#define UFS_PHY_RMMI_CFGRD_L0		(1 << 0)
+#define UFS_PHY_RMMI_ATTRID				    PHY_OFF(0x170)
+#define UFS_PHY_RMMI_ATTRWRVAL				    PHY_OFF(0x174)
+#define UFS_PHY_RMMI_ATTRRDVAL_L0_STATUS		    PHY_OFF(0x178)
+#define UFS_PHY_RMMI_ATTRRDVAL_L1_STATUS		    PHY_OFF(0x17C)
+
+/* TX LANE n (0, 1) registers */
+#define QSERDES_TX_BIST_MODE_LANENO(n)                      TX_OFF(n, 0x00)
+#define QSERDES_TX_CLKBUF_ENABLE(n)                         TX_OFF(n, 0x04)
+#define QSERDES_TX_TX_EMP_POST1_LVL(n)                      TX_OFF(n, 0x08)
+#define QSERDES_TX_TX_DRV_LVL(n)                            TX_OFF(n, 0x0C)
+#define QSERDES_TX_RESET_TSYNC_EN(n)                        TX_OFF(n, 0x10)
+#define QSERDES_TX_LPB_EN(n)                                TX_OFF(n, 0x14)
+#define QSERDES_TX_RES_CODE(n)                              TX_OFF(n, 0x18)
+#define QSERDES_TX_PERL_LENGTH1(n)                          TX_OFF(n, 0x1C)
+#define QSERDES_TX_PERL_LENGTH2(n)                          TX_OFF(n, 0x20)
+#define QSERDES_TX_SERDES_BYP_EN_OUT(n)                     TX_OFF(n, 0x24)
+#define QSERDES_TX_HIGHZ_TRANSCEIVEREN_BIAS_EN(n)           TX_OFF(n, 0x28)
+#define QSERDES_TX_PARRATE_REC_DETECT_IDLE_EN(n)            TX_OFF(n, 0x2C)
+#define QSERDES_TX_BIST_PATTERN1(n)                         TX_OFF(n, 0x30)
+#define QSERDES_TX_BIST_PATTERN2(n)                         TX_OFF(n, 0x34)
+#define QSERDES_TX_BIST_PATTERN3(n)                         TX_OFF(n, 0x38)
+#define QSERDES_TX_BIST_PATTERN4(n)                         TX_OFF(n, 0x3C)
+#define QSERDES_TX_BIST_PATTERN5(n)                         TX_OFF(n, 0x40)
+#define QSERDES_TX_BIST_PATTERN6(n)                         TX_OFF(n, 0x44)
+#define QSERDES_TX_BIST_PATTERN7(n)                         TX_OFF(n, 0x48)
+#define QSERDES_TX_BIST_PATTERN8(n)                         TX_OFF(n, 0x4C)
+#define QSERDES_TX_LANE_MODE(n)                             TX_OFF(n, 0x50)
+#define QSERDES_TX_ATB_SEL(n)                               TX_OFF(n, 0x54)
+#define QSERDES_TX_REC_DETECT_LVL(n)                        TX_OFF(n, 0x58)
+#define QSERDES_TX_PRBS_SEED1(n)                            TX_OFF(n, 0x5C)
+#define QSERDES_TX_PRBS_SEED2(n)                            TX_OFF(n, 0x60)
+#define QSERDES_TX_PRBS_SEED3(n)                            TX_OFF(n, 0x64)
+#define QSERDES_TX_PRBS_SEED4(n)                            TX_OFF(n, 0x68)
+#define QSERDES_TX_RESET_GEN(n)                             TX_OFF(n, 0x6C)
+#define QSERDES_TX_TRAN_DRVR_EMP_EN(n)                      TX_OFF(n, 0x70)
+#define QSERDES_TX_TX_INTERFACE_MODE(n)                     TX_OFF(n, 0x74)
+#define QSERDES_TX_BIST_STATUS(n)                           TX_OFF(n, 0x78)
+#define QSERDES_TX_BIST_ERROR_COUNT1(n)                     TX_OFF(n, 0x7C)
+#define QSERDES_TX_BIST_ERROR_COUNT2(n)                     TX_OFF(n, 0x80)
+
+/* RX LANE n (0, 1) registers */
+#define QSERDES_RX_CDR_CONTROL(n)                           RX_OFF(n, 0x00)
+#define QSERDES_RX_AUX_CONTROL(n)                           RX_OFF(n, 0x04)
+#define QSERDES_RX_AUX_DATA_TCODE(n)                        RX_OFF(n, 0x08)
+#define QSERDES_RX_RCLK_AUXDATA_SEL(n)                      RX_OFF(n, 0x0C)
+#define QSERDES_RX_EQ_CONTROL(n)                            RX_OFF(n, 0x10)
+#define QSERDES_RX_RX_EQ_GAIN2(n)                           RX_OFF(n, 0x14)
+#define QSERDES_RX_AC_JTAG_INIT(n)                          RX_OFF(n, 0x18)
+#define QSERDES_RX_AC_JTAG_LVL_EN(n)                        RX_OFF(n, 0x1C)
+#define QSERDES_RX_AC_JTAG_MODE(n)                          RX_OFF(n, 0x20)
+#define QSERDES_RX_AC_JTAG_RESET(n)                         RX_OFF(n, 0x24)
+#define QSERDES_RX_RX_IQ_RXDET_EN(n)                        RX_OFF(n, 0x28)
+#define QSERDES_RX_RX_TERM_HIGHZ_CM_AC_COUPLE(n)            RX_OFF(n, 0x2C)
+#define QSERDES_RX_RX_EQ_GAIN1(n)                           RX_OFF(n, 0x30)
+#define QSERDES_RX_SIGDET_CNTRL(n)                          RX_OFF(n, 0x34)
+#define QSERDES_RX_RX_BAND(n)                               RX_OFF(n, 0x38)
+#define QSERDES_RX_CDR_FREEZE_UP_DN(n)                      RX_OFF(n, 0x3C)
+#define QSERDES_RX_RX_INTERFACE_MODE(n)                     RX_OFF(n, 0x40)
+#define QSERDES_RX_JITTER_GEN_MODE(n)                       RX_OFF(n, 0x44)
+#define QSERDES_RX_BUJ_AMP(n)                               RX_OFF(n, 0x48)
+#define QSERDES_RX_SJ_AMP1(n)                               RX_OFF(n, 0x4C)
+#define QSERDES_RX_SJ_AMP2(n)                               RX_OFF(n, 0x50)
+#define QSERDES_RX_SJ_PER1(n)                               RX_OFF(n, 0x54)
+#define QSERDES_RX_SJ_PER2(n)                               RX_OFF(n, 0x58)
+#define QSERDES_RX_BUJ_STEP_FREQ1(n)                        RX_OFF(n, 0x5C)
+#define QSERDES_RX_BUJ_STEP_FREQ2(n)                        RX_OFF(n, 0x60)
+#define QSERDES_RX_PPM_OFFSET1(n)                           RX_OFF(n, 0x64)
+#define QSERDES_RX_PPM_OFFSET2(n)                           RX_OFF(n, 0x68)
+#define QSERDES_RX_SIGN_PPM_PERIOD1(n)                      RX_OFF(n, 0x6C)
+#define QSERDES_RX_SIGN_PPM_PERIOD2(n)                      RX_OFF(n, 0x70)
+#define QSERDES_RX_SSC_CTRL(n)                              RX_OFF(n, 0x74)
+#define QSERDES_RX_SSC_COUNT1(n)                            RX_OFF(n, 0x78)
+#define QSERDES_RX_SSC_COUNT2(n)                            RX_OFF(n, 0x7C)
+#define QSERDES_RX_PWM_CNTRL1(n)                            RX_OFF(n, 0x80)
+#define QSERDES_RX_PWM_CNTRL2(n)                            RX_OFF(n, 0x84)
+#define QSERDES_RX_PWM_NDIV(n)                              RX_OFF(n, 0x88)
+#define QSERDES_RX_SIGDET_CNTRL2(n)                         RX_OFF(n, 0x8C)
+#define QSERDES_RX_UFS_CNTRL(n)                             RX_OFF(n, 0x90)
+#define QSERDES_RX_CDR_CONTROL3(n)                          RX_OFF(n, 0x94)
+#define QSERDES_RX_CDR_CONTROL_HALF(n)                      RX_OFF(n, 0x98)
+#define QSERDES_RX_CDR_CONTROL_QUARTER(n)                   RX_OFF(n, 0x9C)
+#define QSERDES_RX_CDR_CONTROL_EIGHTH(n)                    RX_OFF(n, 0xA0)
+#define QSERDES_RX_UCDR_FO_GAIN(n)                          RX_OFF(n, 0xA4)
+#define QSERDES_RX_UCDR_SO_GAIN(n)                          RX_OFF(n, 0xA8)
+#define QSERDES_RX_UCDR_SO_SATURATION_AND_ENABLE(n)         RX_OFF(n, 0xAC)
+#define QSERDES_RX_UCDR_FO_TO_SO_DELAY(n)                   RX_OFF(n, 0xB0)
+#define QSERDES_RX_PI_CTRL1(n)                              RX_OFF(n, 0xB4)
+#define QSERDES_RX_PI_CTRL2(n)                              RX_OFF(n, 0xB8)
+#define QSERDES_RX_PI_QUAD(n)                               RX_OFF(n, 0xBC)
+#define QSERDES_RX_IDATA1(n)                                RX_OFF(n, 0xC0)
+#define QSERDES_RX_IDATA2(n)                                RX_OFF(n, 0xC4)
+#define QSERDES_RX_AUX_DATA1(n)                             RX_OFF(n, 0xC8)
+#define QSERDES_RX_AUX_DATA2(n)                             RX_OFF(n, 0xCC)
+#define QSERDES_RX_AC_JTAG_OUTP(n)                          RX_OFF(n, 0xD0)
+#define QSERDES_RX_AC_JTAG_OUTN(n)                          RX_OFF(n, 0xD4)
+#define QSERDES_RX_RX_SIGDET_PWMDECSTATUS(n)                RX_OFF(n, 0xD8)
+
+#define UFS_PHY_TX_LANE_ENABLE_MASK		0x3
+
+/*
+ * This structure represents the 28nm specific phy.
+ * common_cfg MUST remain the first field in this structure
+ * in case extra fields are added. This way, when calling
+ * get_ufs_msm_phy() of generic phy, we can extract the
+ * common phy structure (struct ufs_msm_phy) out of it
+ * regardless of the relevant specific phy.
+ */
+struct ufs_msm_phy_qmp_28nm {
+	struct ufs_msm_phy common_cfg;
+};
+
+static struct ufs_msm_phy_calibration phy_cal_table_ctrl_1_1_0_rate_A[] = {
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_POWER_DOWN_CONTROL, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CRCTRL, 0xFF),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CNTRL, 0x24),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_SYSCLK_EN_SEL, 0x08),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_SYS_CLK_CTRL, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CLKEPDIV, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x82),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START2, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1, 0x80),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2, 0x80),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3, 0x10),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x67),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP3, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP_EN, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL, 0x10),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_RXTXEPCLK_EN, 0x13),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_PWM_CNTRL1(0), 0x43),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_PWM_CNTRL1(1), 0x43),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL(0), 0x22),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(0), 0x12),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(0), 0x2a),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL(1), 0x22),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(1), 0x12),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(1), 0x2a),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL(0), 0xC0),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL(1), 0xC0),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL2(0), 0x07),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL2(1), 0x07),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_PWM_G1_CLK_DIVIDER, 0x50),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_PWM_G2_CLK_DIVIDER, 0x28),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_PWM_G3_CLK_DIVIDER, 0x10),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_PWM_G4_CLK_DIVIDER, 0x08),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_CORECLK_PWM_G1_CLK_DIVIDER, 0xa8),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_CORECLK_PWM_G2_CLK_DIVIDER, 0x54),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_CORECLK_PWM_G3_CLK_DIVIDER, 0x2a),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_CORECLK_PWM_G4_CLK_DIVIDER, 0x15),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_OMC_STATUS_RDVAL, 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_LINE_RESET_TIME, 0x1f),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_LINE_RESET_GRANULARITY, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TSYNC_RSYNC_CNTL, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_PLL_CNTL, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_LARGE_AMP_DRV_LVL, 0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_SMALL_AMP_DRV_LVL, 0x1a),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_LARGE_AMP_POST_EMP_LVL, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_SMALL_AMP_POST_EMP_LVL, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_CFG_CHANGE_CNT_VAL, 0x09),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_SYNC_WAIT_TIME, 0x30),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY, 0x08),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_MIN_STALL_NOCONFIG_TIME_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_MIN_STALL_NOCONFIG_TIME_CAPABILITY, 0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_MIN_SAVE_CONFIG_TIME_CAPABILITY, 0x04),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_MIN_SAVE_CONFIG_TIME_CAPABILITY, 0xc8),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_PWM_BURST_CLOSURE_LENGTH_CAPABILITY, 0x10),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_MIN_ACTIVATETIME_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1(0), 0x07),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2(0), 0x07),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1(1), 0x07),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2(1), 0x07),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL3(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL3(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETI, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETI, 0x3f),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETP, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETP, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_RES_TRIM_OFFSET, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_BGTC, 0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_AMP_OS, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_TX_DRV_LVL(0), 0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_TX_DRV_LVL(1), 0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_BIST_MODE_LANENO(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_BIST_MODE_LANENO(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_TX_EMP_POST1_LVL(0), 0x04),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_TX_EMP_POST1_LVL(1), 0x04),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_HIGHZ_TRANSCEIVEREN_BIAS_EN(0),
0x05),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_HIGHZ_TRANSCEIVEREN_BIAS_EN(1),
0x05),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TIMER_100US_SYSCLK_STEPS_MSB, 0x07),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TIMER_100US_SYSCLK_STEPS_LSB, 0x80),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TIMER_20US_CORECLK_STEPS_MSB, 0x27),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TIMER_20US_CORECLK_STEPS_LSB, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_CONTROLSYM_ONE_HOT_DISABLE, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RETIME_BUFFER_EN, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_HSGEAR_CAPABILITY, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_PWMGEAR_CAPABILITY, 0x04),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_AMPLITUDE_CAPABILITY, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_EXTERNALSYNC_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_HS_UNTERMINATED_LINE_DRIVE_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_LS_TERMINATED_LINE_DRIVE_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_REF_CLOCK_SHARED_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_HIBERN8TIME_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_HSGEAR_CAPABILITY, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_PWMGEAR_CAPABILITY, 0x04),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_UNTERMINATED_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_LS_TERMINATED_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_REF_CLOCK_SHARED_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G1_SYNC_LENGTH_CAPABILITY,
0x48),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_HS_G1_PREPARE_LENGTH_CAPABILITY, 0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_LS_PREPARE_LENGTH_CAPABILITY,
0x09),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_HIBERN8TIME_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G2_SYNC_LENGTH_CAPABILITY,
0x48),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G3_SYNC_LENGTH_CAPABILITY,
0x48),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_HS_G2_PREPARE_LENGTH_CAPABILITY, 0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_HS_G3_PREPARE_LENGTH_CAPABILITY, 0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_CLKBUF_ENABLE(0), 0x09),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_RESET_TSYNC_EN(0), 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_RES_CODE(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_SERDES_BYP_EN_OUT(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_REC_DETECT_LVL(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_PARRATE_REC_DETECT_IDLE_EN(0),
0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_TRAN_DRVR_EMP_EN(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_AUX_CONTROL(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_AUX_DATA_TCODE(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RCLK_AUXDATA_SEL(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_EQ_CONTROL(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_IQ_RXDET_EN(0), 0x73),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_TERM_HIGHZ_CM_AC_COUPLE(0),
0x05),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_FREEZE_UP_DN(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_UFS_CNTRL(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_EIGHTH(0), 0x22),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FO_GAIN(0), 0x0a),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_SO_GAIN(0), 0x06),
+	UFS_MSM_PHY_CAL_ENTRY(
+		QSERDES_RX_UCDR_SO_SATURATION_AND_ENABLE(0), 0x35),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FO_TO_SO_DELAY(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_CLKBUF_ENABLE(1), 0x09),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_RESET_TSYNC_EN(1), 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_RES_CODE(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_SERDES_BYP_EN_OUT(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_REC_DETECT_LVL(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_PARRATE_REC_DETECT_IDLE_EN(1),
0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_TRAN_DRVR_EMP_EN(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_AUX_CONTROL(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_AUX_DATA_TCODE(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RCLK_AUXDATA_SEL(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_EQ_CONTROL(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_IQ_RXDET_EN(1), 0x73),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_TERM_HIGHZ_CM_AC_COUPLE(1),
0x05),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_FREEZE_UP_DN(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_UFS_CNTRL(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_EIGHTH(1), 0x22),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FO_GAIN(1), 0x0a),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_SO_GAIN(1), 0x06),
+	UFS_MSM_PHY_CAL_ENTRY(
+		QSERDES_RX_UCDR_SO_SATURATION_AND_ENABLE(1), 0x35),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FO_TO_SO_DELAY(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_CMN_MODE, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_IE_TRIM, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_IP_TRIM, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_CORE_CLK_IN_SYNC_SEL, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_BIAS_EN_CLKBUFLR_EN, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_TEST_UPDN_RESTRIMSTEP, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_FAUX_EN, 0x00),
+};
+
+static struct ufs_msm_phy_calibration phy_cal_table_ctrl_1_1_1_rate_A[] = {
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_POWER_DOWN_CONTROL, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CRCTRL, 0x43),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CNTRL, 0x24),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_SYSCLK_EN_SEL, 0x08),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_SYS_CLK_CTRL, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CLKEPDIV, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x82),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START2, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1, 0x80),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2, 0x80),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3, 0x10),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x19),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP3, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP_EN, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL, 0x10),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_RXTXEPCLK_EN, 0x10),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_PWM_CNTRL1(0), 0x43),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_PWM_CNTRL1(1), 0x43),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL(0), 0x40),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(0), 0x0c),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(0), 0x12),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL(1), 0x40),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(1), 0x0c),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(1), 0x12),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL(0), 0xC0),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL(1), 0xC0),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL2(0), 0x07),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL2(1), 0x07),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_PWM_G1_CLK_DIVIDER, 0x30),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_PWM_G2_CLK_DIVIDER, 0x18),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_PWM_G3_CLK_DIVIDER, 0x0c),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_PWM_G4_CLK_DIVIDER, 0x06),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_CORECLK_PWM_G1_CLK_DIVIDER, 0xa8),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_CORECLK_PWM_G2_CLK_DIVIDER, 0x54),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_CORECLK_PWM_G3_CLK_DIVIDER, 0x2a),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_CORECLK_PWM_G4_CLK_DIVIDER, 0x15),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_OMC_STATUS_RDVAL, 0xff),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_LINE_RESET_TIME, 0x1f),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_LINE_RESET_GRANULARITY, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TSYNC_RSYNC_CNTL, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_PLL_CNTL, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_LARGE_AMP_DRV_LVL, 0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_SMALL_AMP_DRV_LVL, 0x1a),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_LARGE_AMP_POST_EMP_LVL, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_SMALL_AMP_POST_EMP_LVL, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_CFG_CHANGE_CNT_VAL, 0x09),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_SYNC_WAIT_TIME, 0x30),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY, 0x08),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_MIN_STALL_NOCONFIG_TIME_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_MIN_STALL_NOCONFIG_TIME_CAPABILITY, 0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_MIN_SAVE_CONFIG_TIME_CAPABILITY, 0x04),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_MIN_SAVE_CONFIG_TIME_CAPABILITY, 0xc8),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_PWM_BURST_CLOSURE_LENGTH_CAPABILITY, 0x10),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_MIN_ACTIVATETIME_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1(0), 0x1f),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2(0), 0x17),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1(1), 0x1f),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2(1), 0x17),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL3(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL3(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETI, 0x07),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETI, 0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETP, 0x07),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETP, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_RES_TRIM_OFFSET, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_BGTC, 0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_AMP_OS, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_TX_DRV_LVL(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_TX_DRV_LVL(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_BIST_MODE_LANENO(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_BIST_MODE_LANENO(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_TX_EMP_POST1_LVL(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_TX_EMP_POST1_LVL(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_HIGHZ_TRANSCEIVEREN_BIAS_EN(0),
0x05),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_HIGHZ_TRANSCEIVEREN_BIAS_EN(1),
0x05),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TIMER_100US_SYSCLK_STEPS_MSB, 0x07),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TIMER_100US_SYSCLK_STEPS_LSB, 0x80),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TIMER_20US_CORECLK_STEPS_MSB, 0x27),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TIMER_20US_CORECLK_STEPS_LSB, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_CONTROLSYM_ONE_HOT_DISABLE, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RETIME_BUFFER_EN, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_HSGEAR_CAPABILITY, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_PWMGEAR_CAPABILITY, 0x04),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_AMPLITUDE_CAPABILITY, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_EXTERNALSYNC_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_HS_UNTERMINATED_LINE_DRIVE_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_LS_TERMINATED_LINE_DRIVE_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_REF_CLOCK_SHARED_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_TX_HIBERN8TIME_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_HSGEAR_CAPABILITY, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_PWMGEAR_CAPABILITY, 0x04),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_UNTERMINATED_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_LS_TERMINATED_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_REF_CLOCK_SHARED_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G1_SYNC_LENGTH_CAPABILITY,
0x48),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G1_PREPARE_LENGTH_CAPABILITY,
0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_LS_PREPARE_LENGTH_CAPABILITY,
0x0a),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_HIBERN8TIME_CAPABILITY, 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G2_SYNC_LENGTH_CAPABILITY,
0x48),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G3_SYNC_LENGTH_CAPABILITY,
0x48),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G2_PREPARE_LENGTH_CAPABILITY,
0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G3_PREPARE_LENGTH_CAPABILITY,
0x0f),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_CLKBUF_ENABLE(0), 0x09),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_RESET_TSYNC_EN(0), 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_RES_CODE(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_SERDES_BYP_EN_OUT(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_REC_DETECT_LVL(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_PARRATE_REC_DETECT_IDLE_EN(0),
0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_TRAN_DRVR_EMP_EN(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_AUX_CONTROL(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_AUX_DATA_TCODE(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RCLK_AUXDATA_SEL(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_EQ_CONTROL(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_IQ_RXDET_EN(0), 0x51),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_TERM_HIGHZ_CM_AC_COUPLE(0),
0x05),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_FREEZE_UP_DN(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_UFS_CNTRL(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_EIGHTH(0), 0x22),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FO_GAIN(0), 0x0a),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_SO_GAIN(0), 0x06),
+	UFS_MSM_PHY_CAL_ENTRY(
+		QSERDES_RX_UCDR_SO_SATURATION_AND_ENABLE(0), 0x35),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FO_TO_SO_DELAY(0), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_CLKBUF_ENABLE(1), 0x09),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_RESET_TSYNC_EN(1), 0x01),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_RES_CODE(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_SERDES_BYP_EN_OUT(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_REC_DETECT_LVL(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_PARRATE_REC_DETECT_IDLE_EN(1),
0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_TRAN_DRVR_EMP_EN(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_AUX_CONTROL(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_AUX_DATA_TCODE(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RCLK_AUXDATA_SEL(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_EQ_CONTROL(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_IQ_RXDET_EN(1), 0x51),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_RX_TERM_HIGHZ_CM_AC_COUPLE(1),
0x05),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_FREEZE_UP_DN(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_UFS_CNTRL(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_EIGHTH(1), 0x22),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FO_GAIN(1), 0x0a),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_SO_GAIN(1), 0x06),
+	UFS_MSM_PHY_CAL_ENTRY(
+		QSERDES_RX_UCDR_SO_SATURATION_AND_ENABLE(1), 0x35),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FO_TO_SO_DELAY(1), 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_CMN_MODE, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_IE_TRIM, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_IP_TRIM, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_CORE_CLK_IN_SYNC_SEL, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_BIAS_EN_CLKBUFLR_EN, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_TEST_UPDN_RESTRIMSTEP, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_FAUX_EN, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(0), 0x08),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(1), 0x08),
+};
+
+static struct ufs_msm_phy_calibration phy_cal_table_rate_B[] = {
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CLKEPDIV, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x98),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START2, 0x03),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1, 0x80),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2, 0x80),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3, 0x10),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0x65),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x1E),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP3, 0x00),
+	UFS_MSM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP_EN, 0x03),
+};
+
+static struct ufs_msm_phy_calibration cached_phy_regs[] = {
+	{QSERDES_COM_PLL_CRCTRL},
+	{QSERDES_COM_PLL_CNTRL},
+	{QSERDES_COM_SYSCLK_EN_SEL},
+	{QSERDES_COM_SYS_CLK_CTRL},
+	{QSERDES_COM_PLL_CLKEPDIV},
+	{QSERDES_COM_DEC_START1},
+	{QSERDES_COM_DEC_START2},
+	{QSERDES_COM_DIV_FRAC_START1},
+	{QSERDES_COM_DIV_FRAC_START2},
+	{QSERDES_COM_DIV_FRAC_START3},
+	{QSERDES_COM_PLLLOCK_CMP1},
+	{QSERDES_COM_PLLLOCK_CMP2},
+	{QSERDES_COM_PLLLOCK_CMP3},
+	{QSERDES_COM_PLLLOCK_CMP_EN},
+	{QSERDES_COM_RESETSM_CNTRL},
+	{QSERDES_COM_PLL_RXTXEPCLK_EN},
+	{QSERDES_RX_PWM_CNTRL1(0)},
+	{QSERDES_RX_PWM_CNTRL1(1)},
+	{QSERDES_RX_CDR_CONTROL(0)},
+	{QSERDES_RX_CDR_CONTROL_HALF(0)},
+	{QSERDES_RX_CDR_CONTROL_QUARTER(0)},
+	{QSERDES_RX_CDR_CONTROL(1)},
+	{QSERDES_RX_CDR_CONTROL_HALF(1)},
+	{QSERDES_RX_CDR_CONTROL_QUARTER(1)},
+	{QSERDES_RX_SIGDET_CNTRL(0)},
+	{QSERDES_RX_SIGDET_CNTRL(1)},
+	{QSERDES_RX_SIGDET_CNTRL2(0)},
+	{QSERDES_RX_SIGDET_CNTRL2(1)},
+	{QSERDES_RX_RX_EQ_GAIN1(0)},
+	{QSERDES_RX_RX_EQ_GAIN2(0)},
+	{QSERDES_RX_RX_EQ_GAIN1(1)},
+	{QSERDES_RX_RX_EQ_GAIN2(1)},
+	{QSERDES_COM_PLL_IP_SETI},
+	{QSERDES_COM_PLL_CP_SETI},
+	{QSERDES_COM_PLL_IP_SETP},
+	{QSERDES_COM_PLL_CP_SETP},
+	{UFS_PHY_PWM_G1_CLK_DIVIDER},
+	{UFS_PHY_PWM_G2_CLK_DIVIDER},
+	{UFS_PHY_PWM_G3_CLK_DIVIDER},
+	{UFS_PHY_PWM_G4_CLK_DIVIDER},
+	{UFS_PHY_CORECLK_PWM_G1_CLK_DIVIDER},
+	{UFS_PHY_CORECLK_PWM_G2_CLK_DIVIDER},
+	{UFS_PHY_CORECLK_PWM_G3_CLK_DIVIDER},
+	{UFS_PHY_CORECLK_PWM_G4_CLK_DIVIDER},
+	{UFS_PHY_OMC_STATUS_RDVAL},
+	{UFS_PHY_LINE_RESET_TIME},
+	{UFS_PHY_LINE_RESET_GRANULARITY},
+	{UFS_PHY_TSYNC_RSYNC_CNTL},
+	{UFS_PHY_PLL_CNTL},
+	{UFS_PHY_TX_LARGE_AMP_DRV_LVL},
+	{UFS_PHY_TX_SMALL_AMP_DRV_LVL},
+	{UFS_PHY_TX_LARGE_AMP_POST_EMP_LVL},
+	{UFS_PHY_TX_SMALL_AMP_POST_EMP_LVL},
+	{UFS_PHY_CFG_CHANGE_CNT_VAL},
+	{UFS_PHY_RX_SYNC_WAIT_TIME},
+	{UFS_PHY_TX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY},
+	{UFS_PHY_RX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY},
+	{UFS_PHY_TX_MIN_STALL_NOCONFIG_TIME_CAPABILITY},
+	{UFS_PHY_RX_MIN_STALL_NOCONFIG_TIME_CAPABILITY},
+	{UFS_PHY_TX_MIN_SAVE_CONFIG_TIME_CAPABILITY},
+	{UFS_PHY_RX_MIN_SAVE_CONFIG_TIME_CAPABILITY},
+	{UFS_PHY_RX_PWM_BURST_CLOSURE_LENGTH_CAPABILITY},
+	{UFS_PHY_RX_MIN_ACTIVATETIME_CAPABILITY},
+	{QSERDES_RX_CDR_CONTROL3(0)},
+	{QSERDES_RX_CDR_CONTROL3(1)},
+	{QSERDES_COM_RES_TRIM_OFFSET},
+	{QSERDES_COM_BGTC},
+	{QSERDES_COM_PLL_AMP_OS},
+};
+
+static struct ufs_msm_phy_stored_attributes cached_phy_attr[] = {
+	{TX_MODE},
+	{TX_HSRATE_SERIES},
+	{TX_HSGEAR},
+	{TX_PWMGEAR},
+	{TX_AMPLITUDE},
+	{TX_HS_SLEWRATE},
+	{TX_SYNC_SOURCE},
+	{TX_HS_PREPARE_LENGTH},
+	{TX_LS_PREPARE_LENGTH},
+	{TX_LCC_ENABLE},
+	{TX_PWM_BURST_CLOSURE_EXTENSION},
+	{TX_BYPASS_8B10B_ENABLE},
+	{TX_DRIVER_POLARITY},
+	{TX_HS_UNTERMINATED_LINE_DRIVE_ENABLE},
+	{TX_LS_TERMINATED_LINE_DRIVE_ENABLE},
+	{TX_LCC_SEQUENCER},
+	{TX_MIN_ACTIVATETIME},
+	{TX_PWM_G6_G7_SYNC_LENGTH},
+	{RX_MODE},
+	{RX_HSRATE_SERIES},
+	{RX_HSGEAR},
+	{RX_PWMGEAR},
+	{RX_LS_TERMINATED_ENABLE},
+	{RX_HS_UNTERMINATED_ENABLE},
+	{RX_ENTER_HIBERN8},
+	{RX_BYPASS_8B10B_ENABLE},
+	{RX_TERMINATION_FORCE_ENABLE},
+};
+
+#endif
diff --git a/drivers/scsi/ufs/ufs-msm-phy.c b/drivers/scsi/ufs/ufs-msm-phy.c
new file mode 100644
index 0000000..82486b2
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-msm-phy.c
@@ -0,0 +1,646 @@
+/*
+ * Copyright (c) 2013-2014, Linux Foundation. All rights reserved.
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
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/time.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/iopoll.h>
+#include <linux/platform_device.h>
+#include <linux/msm-bus.h>
+
+#include "ufshcd.h"
+#include "unipro.h"
+#include "ufs-msm.h"
+#include "ufs-msm-phy.h"
+
+int ufs_msm_phy_calibrate(struct ufs_msm_phy *ufs_msm_phy,
+			struct ufs_msm_phy_calibration *tbl_A, int
tbl_size_A,
+			struct ufs_msm_phy_calibration *tbl_B, int
tbl_size_B,
+			int rate)
+{
+	int i;
+	int ret = 0;
+
+	if (!tbl_A) {
+		dev_err(ufs_msm_phy->dev, "%s: tbl_A is NULL", __func__);
+		ret = EINVAL;
+		goto out;
+	}
+
+	for (i = 0; i < tbl_size_A; i++)
+		writel_relaxed(tbl_A[i].cfg_value,
+				ufs_msm_phy->mmio + tbl_A[i].reg_offset);
+
+	/*
+	 * In case we would like to work in rate B, we need
+	 * to override a registers that were configured in rate A table
+	 * with registers of rate B table.
+	 * table.
+	 */
+	if (rate == PA_HS_MODE_B) {
+		if (!tbl_B) {
+			dev_err(ufs_msm_phy->dev, "%s: tbl_B is NULL",
+				__func__);
+			ret = EINVAL;
+			goto out;
+		}
+
+		for (i = 0; i < tbl_size_B; i++)
+			writel_relaxed(tbl_B[i].cfg_value,
+				ufs_msm_phy->mmio + tbl_B[i].reg_offset);
+	}
+
+	/* flush buffered writes */
+	mb();
+
+out:
+	return ret;
+}
+
+struct phy *ufs_msm_phy_generic_probe(struct platform_device *pdev,
+			  struct ufs_msm_phy *common_cfg,
+			  struct phy_ops *ufs_msm_phy_gen_ops,
+			  struct ufs_msm_phy_specific_ops *phy_spec_ops)
+{
+	int err;
+	struct device *dev = &pdev->dev;
+	struct phy *generic_phy = NULL;
+	struct phy_provider *phy_provider;
+
+	err = ufs_msm_phy_base_init(pdev, common_cfg);
+	if (err) {
+		dev_err(dev, "%s: phy base init failed %d\n", __func__,
err);
+		goto out;
+	}
+
+	phy_provider = devm_of_phy_provider_register(dev,
of_phy_simple_xlate);
+	if (IS_ERR(phy_provider)) {
+		err = PTR_ERR(phy_provider);
+		dev_err(dev, "%s: failed to register phy %d\n", __func__,
err);
+		goto out;
+	}
+
+	generic_phy = devm_phy_create(dev, ufs_msm_phy_gen_ops, NULL);
+	if (IS_ERR(generic_phy)) {
+		err =  PTR_ERR(generic_phy);
+		dev_err(dev, "%s: failed to create phy %d\n", __func__,
err);
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
+ * struct ufs_msm_phy. In order to function properly it's crucial
+ * to keep the embedded struct "struct ufs_msm_phy common_cfg"
+ * as the first inside generic_phy.
+ */
+struct ufs_msm_phy *get_ufs_msm_phy(struct phy *generic_phy)
+{
+	return (struct ufs_msm_phy *)phy_get_drvdata(generic_phy);
+}
+
+int ufs_msm_phy_base_init(struct platform_device *pdev,
+		struct ufs_msm_phy *phy_common)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	int err = 0;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "%s: platform_get_resource() failed. returned
NULL\n",
+			__func__);
+		err = -ENOMEM;
+		goto out;
+	}
+
+	phy_common->mmio = devm_ioremap_resource(dev, res);
+	if (IS_ERR(phy_common->mmio)) {
+		err = PTR_ERR(phy_common->mmio);
+		dev_err(dev, "ioremap resource failed %d\n", err);
+	}
+
+out:
+	return err;
+}
+
+int ufs_msm_phy_clk_get(struct phy *phy,
+		const char *name, struct clk **clk_out)
+{
+	struct clk *clk;
+	int err = 0;
+	struct ufs_msm_phy *ufs_msm_phy = get_ufs_msm_phy(phy);
+	struct device *dev = ufs_msm_phy->dev;
+
+	clk = devm_clk_get(dev, name);
+	if (IS_ERR(clk)) {
+		err = PTR_ERR(clk);
+		dev_err(dev, "failed to get %s err %d", name, err);
+	} else {
+		*clk_out = clk;
+	}
+
+	return err;
+}
+
+int
+ufs_msm_phy_init_clks(struct phy *generic_phy, struct ufs_msm_phy
*phy_common)
+{
+	int err;
+
+	err = ufs_msm_phy_clk_get(generic_phy, "tx_iface_clk",
+		&phy_common->tx_iface_clk);
+	if (err)
+		goto out;
+
+	err = ufs_msm_phy_clk_get(generic_phy, "rx_iface_clk",
+		&phy_common->rx_iface_clk);
+	if (err)
+		goto out;
+
+	err = ufs_msm_phy_clk_get(generic_phy, "ref_clk_src",
+		&phy_common->ref_clk_src);
+	if (err)
+		goto out;
+
+	err = ufs_msm_phy_clk_get(generic_phy, "ref_clk_parent",
+		&phy_common->ref_clk_parent);
+	if (err)
+		goto out;
+
+	err = ufs_msm_phy_clk_get(generic_phy, "ref_clk",
+		&phy_common->ref_clk);
+
+out:
+	return err;
+}
+
+int
+ufs_msm_phy_init_vregulators(struct phy *generic_phy,
+			     struct ufs_msm_phy *phy_common)
+{
+	int err;
+
+	err = ufs_msm_phy_init_vreg(generic_phy, &phy_common->vdda_pll,
+		"vdda-pll");
+	if (err)
+		goto out;
+
+	err = ufs_msm_phy_init_vreg(generic_phy, &phy_common->vdda_phy,
+		"vdda-phy");
+out:
+	return err;
+}
+
+int ufs_msm_phy_init_vreg(struct phy *phy,
+		struct ufs_msm_phy_vreg *vreg, const char *name)
+{
+	int err = 0;
+	struct ufs_msm_phy *ufs_msm_phy = get_ufs_msm_phy(phy);
+	struct device *dev = ufs_msm_phy->dev;
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
+		dev_err(dev, "failed to get %s, %d\n", name, err);
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
+	}
+
+	if (!strcmp(name, "vdda-pll")) {
+		vreg->max_uV = VDDA_PLL_MAX_UV;
+		vreg->min_uV = VDDA_PLL_MIN_UV;
+	} else if (!strcmp(name, "vdda-phy")) {
+		vreg->max_uV = VDDA_PHY_MAX_UV;
+		vreg->min_uV = VDDA_PHY_MIN_UV;
+	}
+
+out:
+	if (err)
+		kfree(vreg->name);
+	return err;
+}
+
+int ufs_msm_phy_cfg_vreg(struct phy *phy,
+			struct ufs_msm_phy_vreg *vreg, bool on)
+{
+	int ret = 0;
+	struct regulator *reg = vreg->reg;
+	const char *name = vreg->name;
+	int min_uV;
+	int uA_load;
+	struct ufs_msm_phy *ufs_msm_phy = get_ufs_msm_phy(phy);
+	struct device *dev = ufs_msm_phy->dev;
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
+			 * regulator_set_optimum_mode() returns new
regulator
+			 * mode upon success.
+			 */
+			ret = 0;
+		} else {
+			dev_err(dev, "%s: %s set optimum mode(uA_load=%d)
failed, err=%d\n",
+					__func__, name, uA_load, ret);
+			goto out;
+		}
+	}
+out:
+	return ret;
+}
+
+int ufs_msm_phy_enable_vreg(struct phy *phy,
+			struct ufs_msm_phy_vreg *vreg)
+{
+	struct ufs_msm_phy *ufs_msm_phy = get_ufs_msm_phy(phy);
+	struct device *dev = ufs_msm_phy->dev;
+	int ret = 0;
+
+	if (!vreg || vreg->enabled)
+		goto out;
+
+	ret = ufs_msm_phy_cfg_vreg(phy, vreg, true);
+	if (ret) {
+		dev_err(dev, "%s: ufs_msm_phy_cfg_vreg() failed, err=%d\n",
+				__func__, ret);
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
+int ufs_msm_phy_enable_ref_clk(struct phy *generic_phy)
+{
+	int ret = 0;
+	struct ufs_msm_phy *phy = get_ufs_msm_phy(generic_phy);
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
+	ret = clk_prepare_enable(phy->ref_clk_parent);
+	if (ret) {
+		dev_err(phy->dev, "%s: ref_clk_parent enable failed %d\n",
+				__func__, ret);
+		goto out_disable_src;
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
+	clk_disable_unprepare(phy->ref_clk_parent);
+out_disable_src:
+	clk_disable_unprepare(phy->ref_clk_src);
+out:
+	return ret;
+}
+
+int ufs_msm_phy_disable_vreg(struct phy *phy,
+			     struct ufs_msm_phy_vreg *vreg)
+{
+	struct ufs_msm_phy *ufs_msm_phy = get_ufs_msm_phy(phy);
+	struct device *dev = ufs_msm_phy->dev;
+	int ret = 0;
+
+	if (!vreg || !vreg->enabled)
+		goto out;
+
+	ret = regulator_disable(vreg->reg);
+
+	if (!ret) {
+		/* ignore errors on applying disable config */
+		ufs_msm_phy_cfg_vreg(phy, vreg, false);
+		vreg->enabled = false;
+	} else {
+		dev_err(dev, "%s: %s disable failed, err=%d\n",
+				__func__, vreg->name, ret);
+	}
+out:
+	return ret;
+}
+
+void ufs_msm_phy_disable_ref_clk(struct phy *generic_phy)
+{
+	struct ufs_msm_phy *phy = get_ufs_msm_phy(generic_phy);
+
+	if (phy->is_ref_clk_enabled) {
+		clk_disable_unprepare(phy->ref_clk);
+		clk_disable_unprepare(phy->ref_clk_parent);
+		clk_disable_unprepare(phy->ref_clk_src);
+		phy->is_ref_clk_enabled = false;
+	}
+}
+
+void ufs_msm_phy_restore_swi_regs(struct phy *generic_phy)
+{
+	int i;
+	struct ufs_msm_phy *phy = get_ufs_msm_phy(generic_phy);
+
+	for (i = 0; i < phy->cached_regs_table_size; i++) {
+		struct ufs_msm_phy_calibration *table =
+			(struct ufs_msm_phy_calibration *)phy->cached_regs;
+		writel_relaxed(table[i].cfg_value, phy->mmio +
+				table[i].reg_offset);
+	}
+
+	/* flush buffered writes */
+	mb();
+}
+
+/* Turn ON M-PHY RMMI interface clocks */
+int ufs_msm_phy_enable_iface_clk(struct phy *generic_phy)
+{
+	struct ufs_msm_phy *phy = get_ufs_msm_phy(generic_phy);
+	int ret = 0;
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
+		dev_err(phy->dev, "%s: rx_iface_clk enable failed %d.
disabling also tx_iface_clk\n",
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
+void ufs_msm_phy_disable_iface_clk(struct phy *generic_phy)
+{
+	struct ufs_msm_phy *phy = get_ufs_msm_phy(generic_phy);
+
+	if (phy->is_iface_clk_enabled) {
+		clk_disable_unprepare(phy->tx_iface_clk);
+		clk_disable_unprepare(phy->rx_iface_clk);
+		phy->is_iface_clk_enabled = false;
+	}
+}
+
+int ufs_msm_phy_is_cfg_restore_quirk_enabled(struct phy *phy)
+{
+	struct ufs_msm_phy *ufs_msm_phy = get_ufs_msm_phy(phy);
+
+	return ufs_msm_phy->quirks & MSM_UFS_PHY_QUIRK_CFG_RESTORE;
+}
+
+int ufs_msm_phy_start_serdes(struct phy *generic_phy)
+{
+	struct ufs_msm_phy *ufs_msm_phy = get_ufs_msm_phy(generic_phy);
+	int ret = 0;
+
+	if (!ufs_msm_phy->phy_spec_ops->start_serdes) {
+		dev_err(ufs_msm_phy->dev, "%s: start_serdes() callback is
not supported\n",
+			__func__);
+		ret = -ENOTSUPP;
+	} else {
+		ufs_msm_phy->phy_spec_ops->start_serdes(ufs_msm_phy);
+	}
+
+	return ret;
+}
+
+int ufs_msm_phy_set_tx_lane_enable(struct phy *generic_phy, u32 tx_lanes)
+{
+	struct ufs_msm_phy *ufs_msm_phy = get_ufs_msm_phy(generic_phy);
+	int ret = 0;
+
+	if (!ufs_msm_phy->phy_spec_ops->set_tx_lane_enable) {
+		dev_err(ufs_msm_phy->dev, "%s: set_tx_lane_enable() callback
is not supported\n",
+			__func__);
+		ret = -ENOTSUPP;
+	} else {
+		ufs_msm_phy->phy_spec_ops->set_tx_lane_enable(ufs_msm_phy,
+								tx_lanes);
+	}
+
+	return ret;
+}
+
+void ufs_msm_phy_save_controller_version(struct phy *generic_phy,
+						u8 major, u16 minor, u16
step)
+{
+	struct ufs_msm_phy *ufs_msm_phy = get_ufs_msm_phy(generic_phy);
+
+	ufs_msm_phy->host_ctrl_rev_major = major;
+	ufs_msm_phy->host_ctrl_rev_minor = minor;
+	ufs_msm_phy->host_ctrl_rev_step = step;
+}
+
+int ufs_msm_phy_calibrate_phy(struct phy *generic_phy)
+{
+	struct ufs_msm_phy *ufs_msm_phy = get_ufs_msm_phy(generic_phy);
+	int ret = 0;
+
+	if (!ufs_msm_phy->phy_spec_ops->calibrate_phy) {
+		dev_err(ufs_msm_phy->dev, "%s: calibrate_phy() callback is
not supported\n",
+			__func__);
+		ret = -ENOTSUPP;
+	} else {
+		ret = ufs_msm_phy->phy_spec_ops->
+				calibrate_phy(ufs_msm_phy);
+		if (ret)
+			dev_err(ufs_msm_phy->dev, "%s: calibrate_phy()
failed %d\n",
+				__func__, ret);
+	}
+
+	return ret;
+}
+
+int ufs_msm_phy_remove(struct phy *generic_phy,
+		       struct ufs_msm_phy *ufs_msm_phy)
+{
+	phy_power_off(generic_phy);
+
+	kfree(ufs_msm_phy->vdda_pll.name);
+	kfree(ufs_msm_phy->vdda_phy.name);
+
+	return 0;
+}
+
+int ufs_msm_phy_exit(struct phy *generic_phy)
+{
+	struct ufs_msm_phy *ufs_msm_phy = get_ufs_msm_phy(generic_phy);
+
+	if (ufs_msm_phy->is_powered_on)
+		phy_power_off(generic_phy);
+
+	return 0;
+}
+
+int ufs_msm_phy_is_pcs_ready(struct phy *generic_phy)
+{
+	struct ufs_msm_phy *ufs_msm_phy = get_ufs_msm_phy(generic_phy);
+
+	if (!ufs_msm_phy->phy_spec_ops->is_physical_coding_sublayer_ready) {
+		dev_err(ufs_msm_phy->dev, "%s:
is_physical_coding_sublayer_ready() callback is not supported\n",
+			__func__);
+		return -ENOTSUPP;
+	}
+
+	return ufs_msm_phy->phy_spec_ops->
+			is_physical_coding_sublayer_ready(ufs_msm_phy);
+}
+
+int ufs_msm_phy_save_configuration(struct phy *generic_phy)
+{
+	struct ufs_msm_phy *ufs_msm_phy = get_ufs_msm_phy(generic_phy);
+	int ret = 0;
+
+	if (!ufs_msm_phy->phy_spec_ops->save_configuration) {
+		dev_err(ufs_msm_phy->dev, "%s: save_configuration() callback
is not supported\n",
+			__func__);
+		ret = -ENOTSUPP;
+	} else {
+		ufs_msm_phy->phy_spec_ops->save_configuration(ufs_msm_phy);
+	}
+
+	return ret;
+}
+
+int ufs_msm_phy_power_on(struct phy *generic_phy)
+{
+	struct ufs_msm_phy *phy_common = get_ufs_msm_phy(generic_phy);
+	struct device *dev = phy_common->dev;
+	int err;
+
+	err = ufs_msm_phy_enable_vreg(generic_phy, &phy_common->vdda_phy);
+	if (err) {
+		dev_err(dev, "%s enable vdda_phy failed, err=%d\n",
+			__func__, err);
+		goto out;
+	}
+
+	phy_common->phy_spec_ops->power_control(phy_common, true);
+
+	/* vdda_pll also enables ref clock LDOs so enable it first */
+	err = ufs_msm_phy_enable_vreg(generic_phy, &phy_common->vdda_pll);
+	if (err) {
+		dev_err(dev, "%s enable vdda_pll failed, err=%d\n",
+			__func__, err);
+		goto out_disable_phy;
+	}
+
+	err = ufs_msm_phy_enable_ref_clk(generic_phy);
+	if (err) {
+		dev_err(dev, "%s enable phy ref clock failed, err=%d\n",
+			__func__, err);
+		goto out_disable_pll;
+	}
+
+	phy_common->is_powered_on = true;
+	goto out;
+
+out_disable_pll:
+	ufs_msm_phy_disable_vreg(generic_phy, &phy_common->vdda_pll);
+out_disable_phy:
+	ufs_msm_phy_disable_vreg(generic_phy, &phy_common->vdda_phy);
+out:
+	return err;
+}
+
+int ufs_msm_phy_power_off(struct phy *generic_phy)
+{
+	struct ufs_msm_phy *phy_common = get_ufs_msm_phy(generic_phy);
+
+	phy_common->phy_spec_ops->power_control(phy_common, false);
+
+	ufs_msm_phy_disable_ref_clk(generic_phy);
+
+	ufs_msm_phy_disable_vreg(generic_phy, &phy_common->vdda_pll);
+	ufs_msm_phy_disable_vreg(generic_phy, &phy_common->vdda_phy);
+	phy_common->is_powered_on = false;
+
+	return 0;
+}
diff --git a/drivers/scsi/ufs/ufs-msm-phy.h b/drivers/scsi/ufs/ufs-msm-phy.h
new file mode 100644
index 0000000..e6f2b92
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-msm-phy.h
@@ -0,0 +1,193 @@
+/*
+ * Copyright (c) 2013-2014, Linux Foundation. All rights reserved.
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
+#ifndef UFS_MSM_PHY_H_
+#define UFS_MSM_PHY_H_
+
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/time.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/iopoll.h>
+#include <linux/platform_device.h>
+#include <linux/phy/phy.h>
+#include <linux/msm-bus.h>
+
+#include "ufshcd.h"
+#include "unipro.h"
+#include "ufs-msm.h"
+
+#define UFS_MSM_PHY_CAL_ENTRY(reg, val)	\
+	{				\
+		.reg_offset = reg,	\
+		.cfg_value = val,	\
+	}
+
+#define UFS_MSM_PHY_NAME_LEN	30
+
+struct ufs_msm_phy_stored_attributes {
+	u32 att;
+	u32 value;
+};
+
+struct ufs_msm_phy_calibration {
+	u32 reg_offset;
+	u32 cfg_value;
+};
+
+struct ufs_msm_phy {
+	struct list_head list;
+	struct device *dev;
+	void __iomem *mmio;
+	struct clk *tx_iface_clk;
+	struct clk *rx_iface_clk;
+	bool is_iface_clk_enabled;
+	struct clk *ref_clk_src;
+	struct clk *ref_clk_parent;
+	struct clk *ref_clk;
+	bool is_ref_clk_enabled;
+	struct ufs_msm_phy_vreg vdda_pll;
+	struct ufs_msm_phy_vreg vdda_phy;
+	unsigned int quirks;
+	u8 host_ctrl_rev_major;
+	u16 host_ctrl_rev_minor;
+	u16 host_ctrl_rev_step;
+
+	/*
+	 * As part of UFS power management, UFS link would be put in
hibernate
+	 * and UFS device would be put in SLEEP mode as part of
runtime/system
+	 * suspend callback. But when system goes into suspend with VDD
+	 * minimization, UFS PHY states are being reset which means UFS link
+	 * hibernate exit command on system resume would fail.
+	 * If this quirk is enabled then above issue is workaround by saving
+	 * the UFS PHY state information before system goes into suspend and
+	 * restoring the saved state information during system resume but
+	 * before executing the hibern8 exit command.
+	 * Note that this quirk will help restoring the PHY state if even
when
+	 * link in not kept in hibern8 during suspend.
+	 *
+	 * Here is the list of steps to save/restore the configuration:
+	 * Before entering into system suspend:
+	 *	1. Read Critical PCS SWI Registers  + less critical PHY CSR
+	 *	2. Read RMMI Attributes
+	 * Enter into system suspend
+	 * After exiting from system suspend:
+	 *	1. Set UFS_PHY_SOFT_RESET bit in UFS_CFG1 register of the
UFS
+	 *	   Controller
+	 *	2. Write 0x01 to the UFS_PHY_POWER_DOWN_CONTROL register in
the
+	 *	   UFS PHY
+	 *	3. Write back the values of the PHY SWI registers
+	 *	4. Clear UFS_PHY_SOFT_RESET bit in UFS_CFG1 register of the
UFS
+	 *	   Controller
+	 *	5. Write 0x01 to the UFS_PHY_PHY_START in the UFS PHY. This
will
+	 *	   start the PLL calibration and bring-up of the PHY.
+	 *	6. Write back the values to the PHY RMMI Attributes
+	 *	7. Wait for UFS_PHY_PCS_READY_STATUS[0] to be '1'
+	 */
+	#define MSM_UFS_PHY_QUIRK_CFG_RESTORE		(1 << 0)
+
+	/*
+	* If UFS PHY power down is deasserted and power is restored to
analog
+	* circuits, the rx_sigdet can glitch. If the glitch is wide enough,
+	* it can trigger the digital logic to think it saw a DIF-N and cause
+	* it to exit Hibern8. Disabling the rx_sigdet during power-up masks
+	* the glitch.
+	*/
+	#define MSM_UFS_PHY_DIS_SIGDET_BEFORE_PWR_COLLAPSE	(1 << 1)
+
+	/*
+	* If UFS link is put into Hibern8 and if UFS PHY analog hardware is
+	* power collapsed (by clearing UFS_PHY_POWER_DOWN_CONTROL), Hibern8
+	* exit might fail even after powering on UFS PHY analog hardware.
+	* Enabling this quirk will help to solve above issue by doing
+	* custom PHY settings just before PHY analog power collapse.
+	*/
+	#define MSM_UFS_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE	(1
<< 2)
+
+	char name[UFS_MSM_PHY_NAME_LEN];
+	struct ufs_msm_phy_calibration *cached_regs;
+	int cached_regs_table_size;
+	bool is_powered_on;
+	struct ufs_msm_phy_specific_ops *phy_spec_ops;
+};
+
+/**
+ * struct ufs_msm_phy_specific_ops - set of pointers to functions which
have a
+ * specific implementation per phy. Each UFS phy, should implement
+ * those functions according to its spec and requirements
+ * @calibrate_phy: pointer to a function that calibrate the phy
+ * @start_serdes: pointer to a function that starts the serdes
+ * @save_configuration: pointer to a function that saves phy
+ * configuration
+ * @is_physical_coding_sublayer_ready: pointer to a function that
+ * checks pcs readiness
+ * @set_tx_lane_enable: pointer to a function that enable tx lanes
+ * @power_control: pointer to a function that controls analog rail of phy
+ * and writes to QSERDES_RX_SIGDET_CNTRL attribute
+ */
+struct ufs_msm_phy_specific_ops {
+	int (*calibrate_phy) (struct ufs_msm_phy *phy);
+	void (*start_serdes) (struct ufs_msm_phy *phy);
+	void (*save_configuration)(struct ufs_msm_phy *phy);
+	int (*is_physical_coding_sublayer_ready) (struct ufs_msm_phy *phy);
+	void (*set_tx_lane_enable) (struct ufs_msm_phy *phy, u32 val);
+	void (*power_control) (struct ufs_msm_phy *phy, bool val);
+};
+
+int ufs_msm_phy_init_vreg(struct phy *phy,
+		struct ufs_msm_phy_vreg *vreg, const char *name);
+int ufs_msm_phy_cfg_vreg(struct phy *phy,
+			struct ufs_msm_phy_vreg *vreg, bool on);
+int ufs_msm_phy_enable_vreg(struct phy *phy,
+			struct ufs_msm_phy_vreg *vreg);
+int ufs_msm_phy_disable_vreg(struct phy *phy,
+			struct ufs_msm_phy_vreg *vreg);
+int ufs_msm_phy_enable_ref_clk(struct phy *phy);
+void ufs_msm_phy_disable_ref_clk(struct phy *phy);
+int ufs_msm_phy_enable_iface_clk(struct phy *phy);
+void ufs_msm_phy_disable_iface_clk(struct phy *phy);
+void ufs_msm_phy_restore_swi_regs(struct phy *phy);
+int ufs_msm_phy_link_startup_post_change(struct phy *phy,
+			struct ufs_hba *hba);
+int ufs_msm_phy_base_init(struct platform_device *pdev,
+			struct ufs_msm_phy *ufs_msm_phy_ops);
+int ufs_msm_phy_is_cfg_restore_quirk_enabled(struct phy *phy);
+struct ufs_msm_phy *get_ufs_msm_phy(struct phy *generic_phy);
+int ufs_msm_phy_start_serdes(struct phy *generic_phy);
+int ufs_msm_phy_set_tx_lane_enable(struct phy *generic_phy, u32 tx_lanes);
+int ufs_msm_phy_calibrate_phy(struct phy *generic_phy);
+int ufs_msm_phy_is_pcs_ready(struct phy *generic_phy);
+int ufs_msm_phy_save_configuration(struct phy *generic_phy);
+void ufs_msm_phy_save_controller_version(struct phy *generic_phy,
+			u8 major, u16 minor, u16 step);
+int ufs_msm_phy_power_on(struct phy *generic_phy);
+int ufs_msm_phy_power_off(struct phy *generic_phy);
+int ufs_msm_phy_exit(struct phy *generic_phy);
+int ufs_msm_phy_init_clks(struct phy *generic_phy,
+			struct ufs_msm_phy *phy_common);
+int ufs_msm_phy_init_vregulators(struct phy *generic_phy,
+			struct ufs_msm_phy *phy_common);
+int ufs_msm_phy_remove(struct phy *generic_phy,
+		       struct ufs_msm_phy *ufs_msm_phy);
+struct phy *ufs_msm_phy_generic_probe(struct platform_device *pdev,
+			struct ufs_msm_phy *common_cfg,
+			struct phy_ops *ufs_msm_phy_gen_ops,
+			struct ufs_msm_phy_specific_ops *phy_spec_ops);
+int ufs_msm_phy_calibrate(struct ufs_msm_phy *ufs_msm_phy,
+			struct ufs_msm_phy_calibration *tbl_A, int
tbl_size_A,
+			struct ufs_msm_phy_calibration *tbl_B, int
tbl_size_B,
+			int rate);
+#endif
diff --git a/drivers/scsi/ufs/ufs-msm.c b/drivers/scsi/ufs/ufs-msm.c
new file mode 100644
index 0000000..a9cbc1b
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-msm.c
@@ -0,0 +1,1105 @@
+/*
+ * Copyright (c) 2013-2014, Linux Foundation. All rights reserved.
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
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/time.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/iopoll.h>
+#include <linux/platform_device.h>
+
+#include <linux/msm-bus.h>
+
+#include "ufshcd.h"
+#include "unipro.h"
+#include "ufs-msm.h"
+#include "ufs-msm-phy.h"
+
+static int ufs_msm_get_speed_mode(struct ufs_pa_layer_attr *p, char
*result);
+static int ufs_msm_get_bus_vote(struct ufs_msm_host *host,
+		const char *speed_mode);
+static int ufs_msm_set_bus_vote(struct ufs_msm_host *host, int vote);
+
+static int ufs_msm_get_connected_tx_lanes(struct ufs_hba *hba, u32
*tx_lanes)
+{
+	int err = 0;
+
+	err = ufshcd_dme_get(hba,
+			UIC_ARG_MIB(PA_CONNECTEDTXDATALANES), tx_lanes);
+	if (err)
+		dev_err(hba->dev, "%s: couldn't read PA_CONNECTEDTXDATALANES
%d\n",
+				__func__, err);
+
+	return err;
+}
+
+static int ufs_msm_host_clk_get(struct device *dev,
+		const char *name, struct clk **clk_out)
+{
+	struct clk *clk;
+	int err = 0;
+
+	clk = devm_clk_get(dev, name);
+	if (IS_ERR(clk)) {
+		err = PTR_ERR(clk);
+		dev_err(dev, "%s: failed to get %s err %d",
+				__func__, name, err);
+	} else {
+		*clk_out = clk;
+	}
+
+	return err;
+}
+
+static int ufs_msm_host_clk_enable(struct device *dev,
+		const char *name, struct clk *clk)
+{
+	int err = 0;
+
+	err = clk_prepare_enable(clk);
+	if (err)
+		dev_err(dev, "%s: %s enable failed %d\n", __func__, name,
err);
+
+	return err;
+}
+
+static void ufs_msm_disable_lane_clks(struct ufs_msm_host *host)
+{
+	if (!host->is_lane_clks_enabled)
+		return;
+
+	clk_disable_unprepare(host->tx_l1_sync_clk);
+	clk_disable_unprepare(host->tx_l0_sync_clk);
+	clk_disable_unprepare(host->rx_l1_sync_clk);
+	clk_disable_unprepare(host->rx_l0_sync_clk);
+
+	host->is_lane_clks_enabled = false;
+}
+
+static int ufs_msm_enable_lane_clks(struct ufs_msm_host *host)
+{
+	int err = 0;
+	struct device *dev = host->hba->dev;
+
+	if (host->is_lane_clks_enabled)
+		return 0;
+
+	err = ufs_msm_host_clk_enable(dev,
+			"rx_lane0_sync_clk", host->rx_l0_sync_clk);
+	if (err)
+		goto out;
+
+	err = ufs_msm_host_clk_enable(dev,
+			"rx_lane1_sync_clk", host->rx_l1_sync_clk);
+	if (err)
+		goto disable_rx_l0;
+
+	err = ufs_msm_host_clk_enable(dev,
+			"tx_lane0_sync_clk", host->tx_l0_sync_clk);
+	if (err)
+		goto disable_rx_l1;
+
+	err = ufs_msm_host_clk_enable(dev,
+			"tx_lane1_sync_clk", host->tx_l1_sync_clk);
+	if (err)
+		goto disable_tx_l0;
+
+	host->is_lane_clks_enabled = true;
+	goto out;
+
+disable_tx_l0:
+	clk_disable_unprepare(host->tx_l0_sync_clk);
+disable_rx_l1:
+	clk_disable_unprepare(host->rx_l1_sync_clk);
+disable_rx_l0:
+	clk_disable_unprepare(host->rx_l0_sync_clk);
+out:
+	return err;
+}
+
+static int ufs_msm_init_lane_clks(struct ufs_msm_host *host)
+{
+	int err = 0;
+	struct device *dev = host->hba->dev;
+
+	err = ufs_msm_host_clk_get(dev,
+			"rx_lane0_sync_clk", &host->rx_l0_sync_clk);
+	if (err)
+		goto out;
+
+	err = ufs_msm_host_clk_get(dev,
+			"rx_lane1_sync_clk", &host->rx_l1_sync_clk);
+	if (err)
+		goto out;
+
+	err = ufs_msm_host_clk_get(dev,
+			"tx_lane0_sync_clk", &host->tx_l0_sync_clk);
+	if (err)
+		goto out;
+
+	err = ufs_msm_host_clk_get(dev,
+			"tx_lane1_sync_clk", &host->tx_l1_sync_clk);
+out:
+	return err;
+}
+
+static int ufs_msm_link_startup_post_change(struct ufs_hba *hba)
+{
+	struct ufs_msm_host *host = hba->priv;
+	struct phy *phy = host->generic_phy;
+	u32 tx_lanes;
+	int err = 0;
+
+	err = ufs_msm_get_connected_tx_lanes(hba, &tx_lanes);
+	if (err)
+		goto out;
+
+	err = ufs_msm_phy_set_tx_lane_enable(phy, tx_lanes);
+	if (err)
+		dev_err(hba->dev, "%s: ufs_msm_phy_set_tx_lane_enable
failed\n",
+			__func__);
+
+out:
+	return err;
+}
+
+static int ufs_msm_check_hibern8(struct ufs_hba *hba)
+{
+	int err;
+	u32 tx_fsm_val = 0;
+	unsigned long timeout = jiffies +
msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
+
+	do {
+		err = ufshcd_dme_get(hba,
+			UIC_ARG_MIB(MPHY_TX_FSM_STATE), &tx_fsm_val);
+		if (err || tx_fsm_val == TX_FSM_HIBERN8)
+			break;
+
+		/* sleep for max. 200us */
+		usleep_range(100, 200);
+	} while (time_before(jiffies, timeout));
+
+	/*
+	 * we might have scheduled out for long during polling so
+	 * check the state again.
+	 */
+	if (time_after(jiffies, timeout))
+		err = ufshcd_dme_get(hba,
+				UIC_ARG_MIB(MPHY_TX_FSM_STATE),
&tx_fsm_val);
+
+	if (err) {
+		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err
%d\n",
+				__func__, err);
+	} else if (tx_fsm_val != TX_FSM_HIBERN8) {
+		err = tx_fsm_val;
+		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
+				__func__, err);
+	}
+
+	return err;
+}
+
+static int ufs_msm_power_up_sequence(struct ufs_hba *hba)
+{
+	struct ufs_msm_host *host = hba->priv;
+	struct phy *phy = host->generic_phy;
+	int ret = 0;
+	u8 major;
+	u16 minor, step;
+
+	/* Assert PHY reset and apply PHY calibration values */
+	ufs_msm_assert_reset(hba);
+	/* provide 1ms delay to let the reset pulse propagate */
+	usleep_range(1000, 1100);
+
+	ufs_msm_get_controller_revision(hba, &major, &minor, &step);
+	ufs_msm_phy_save_controller_version(phy, major, minor, step);
+	ret = ufs_msm_phy_calibrate_phy(phy);
+	if (ret) {
+		dev_err(hba->dev, "%s: ufs_msm_phy_calibrate_phy() failed,
ret = %d\n",
+			__func__, ret);
+		goto out;
+	}
+
+	/* De-assert PHY reset and start serdes */
+	ufs_msm_deassert_reset(hba);
+
+	/*
+	 * after reset deassertion, phy will need all ref clocks,
+	 * voltage, current to settle down before starting serdes.
+	 */
+	usleep_range(1000, 1100);
+	if (ufs_msm_phy_start_serdes(phy)) {
+		dev_err(hba->dev, "%s: ufs_msm_phy_start_serdes() failed,
ret = %d\n",
+			__func__, ret);
+		goto out;
+	}
+
+	ret = ufs_msm_phy_is_pcs_ready(phy);
+	if (ret)
+		dev_err(hba->dev, "%s: is_physical_coding_sublayer_ready()
failed, ret = %d\n",
+			__func__, ret);
+
+out:
+	return ret;
+}
+
+static int ufs_msm_hce_enable_notify(struct ufs_hba *hba, bool status)
+{
+	struct ufs_msm_host *host = hba->priv;
+	int err = 0;
+
+	switch (status) {
+	case PRE_CHANGE:
+		ufs_msm_power_up_sequence(hba);
+		/*
+		 * The PHY PLL output is the source of tx/rx lane symbol
+		 * clocks, hence, enable the lane clocks only after PHY
+		 * is initialized.
+		 */
+		err = ufs_msm_enable_lane_clks(host);
+		break;
+	case POST_CHANGE:
+		/* check if UFS PHY moved from DISABLED to HIBERN8 */
+		err = ufs_msm_check_hibern8(hba);
+		break;
+	default:
+		dev_err(hba->dev, "%s: invalid status %d\n", __func__,
status);
+		err = -EINVAL;
+		break;
+	}
+	return err;
+}
+
+/**
+ * Returns non-zero for success (which rate of core_clk) and 0
+ * in case of a failure
+ */
+static unsigned long
+ufs_msm_cfg_timers(struct ufs_hba *hba, u32 gear, u32 hs, u32 rate)
+{
+	struct ufs_clk_info *clki;
+	u32 core_clk_period_in_ns;
+	u32 tx_clk_cycles_per_us = 0;
+	unsigned long core_clk_rate = 0;
+	u32 core_clk_cycles_per_us = 0;
+
+	static u32 pwm_fr_table[][2] = {
+		{UFS_PWM_G1, 0x1},
+		{UFS_PWM_G2, 0x1},
+		{UFS_PWM_G3, 0x1},
+		{UFS_PWM_G4, 0x1},
+	};
+
+	static u32 hs_fr_table_rA[][2] = {
+		{UFS_HS_G1, 0x1F},
+		{UFS_HS_G2, 0x3e},
+	};
+
+	static u32 hs_fr_table_rB[][2] = {
+		{UFS_HS_G1, 0x24},
+		{UFS_HS_G2, 0x49},
+	};
+
+	if (gear == 0) {
+		dev_err(hba->dev, "%s: invalid gear = %d\n", __func__,
gear);
+		goto out_error;
+	}
+
+	list_for_each_entry(clki, &hba->clk_list_head, list) {
+		if (!strcmp(clki->name, "core_clk"))
+			core_clk_rate = clk_get_rate(clki->clk);
+	}
+
+	/* If frequency is smaller than 1MHz, set to 1MHz */
+	if (core_clk_rate < DEFAULT_CLK_RATE_HZ)
+		core_clk_rate = DEFAULT_CLK_RATE_HZ;
+
+	core_clk_cycles_per_us = core_clk_rate / USEC_PER_SEC;
+	ufshcd_writel(hba, core_clk_cycles_per_us, REG_UFS_SYS1CLK_1US);
+
+	core_clk_period_in_ns = NSEC_PER_SEC / core_clk_rate;
+	core_clk_period_in_ns <<= OFFSET_CLK_NS_REG;
+	core_clk_period_in_ns &= MASK_CLK_NS_REG;
+
+	switch (hs) {
+	case FASTAUTO_MODE:
+	case FAST_MODE:
+		if (rate == PA_HS_MODE_A) {
+			if (gear > ARRAY_SIZE(hs_fr_table_rA)) {
+				dev_err(hba->dev,
+					"%s: index %d exceeds table size
%zu\n",
+					__func__, gear,
+					ARRAY_SIZE(hs_fr_table_rA));
+				goto out_error;
+			}
+			tx_clk_cycles_per_us = hs_fr_table_rA[gear-1][1];
+		} else if (rate == PA_HS_MODE_B) {
+			if (gear > ARRAY_SIZE(hs_fr_table_rB)) {
+				dev_err(hba->dev,
+					"%s: index %d exceeds table size
%zu\n",
+					__func__, gear,
+					ARRAY_SIZE(hs_fr_table_rB));
+				goto out_error;
+			}
+			tx_clk_cycles_per_us = hs_fr_table_rB[gear-1][1];
+		} else {
+			dev_err(hba->dev, "%s: invalid rate = %d\n",
+				__func__, rate);
+			goto out_error;
+		}
+		break;
+	case SLOWAUTO_MODE:
+	case SLOW_MODE:
+		if (gear > ARRAY_SIZE(pwm_fr_table)) {
+			dev_err(hba->dev,
+					"%s: index %d exceeds table size
%zu\n",
+					__func__, gear,
+					ARRAY_SIZE(pwm_fr_table));
+			goto out_error;
+		}
+		tx_clk_cycles_per_us = pwm_fr_table[gear-1][1];
+		break;
+	case UNCHANGED:
+	default:
+		dev_err(hba->dev, "%s: invalid mode = %d\n", __func__, hs);
+		goto out_error;
+	}
+
+	/* this register 2 fields shall be written at once */
+	ufshcd_writel(hba, core_clk_period_in_ns | tx_clk_cycles_per_us,
+
REG_UFS_TX_SYMBOL_CLK_NS_US);
+	goto out;
+
+out_error:
+	core_clk_rate = 0;
+out:
+	return core_clk_rate;
+}
+
+static int ufs_msm_link_startup_notify(struct ufs_hba *hba, bool status)
+{
+	unsigned long core_clk_rate = 0;
+	u32 core_clk_cycles_per_100ms;
+
+	switch (status) {
+	case PRE_CHANGE:
+		core_clk_rate = ufs_msm_cfg_timers(hba, UFS_PWM_G1,
+						   SLOWAUTO_MODE, 0);
+		if (!core_clk_rate) {
+			dev_err(hba->dev, "%s: ufs_msm_cfg_timers()
failed\n",
+				__func__);
+			return -EINVAL;
+		}
+		core_clk_cycles_per_100ms =
+			(core_clk_rate / MSEC_PER_SEC) * 100;
+		ufshcd_writel(hba, core_clk_cycles_per_100ms,
+					REG_UFS_PA_LINK_STARTUP_TIMER);
+		break;
+	case POST_CHANGE:
+		ufs_msm_link_startup_post_change(hba);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int ufs_msm_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+{
+	struct ufs_msm_host *host = hba->priv;
+	struct phy *phy = host->generic_phy;
+	int ret = 0;
+
+	if (ufs_msm_is_link_off(hba)) {
+		/*
+		 * Disable the tx/rx lane symbol clocks before PHY is
+		 * powered down as the PLL source should be disabled
+		 * after downstream clocks are disabled.
+		 */
+		ufs_msm_disable_lane_clks(host);
+		phy_power_off(phy);
+
+		goto out;
+	}
+
+	/*
+	 * If UniPro link is not active, PHY ref_clk, main PHY analog power
+	 * rail and low noise analog power rail for PLL can be switched off.
+	 */
+	if (!ufs_msm_is_link_active(hba)) {
+		if (ufs_msm_phy_is_cfg_restore_quirk_enabled(phy) &&
+		    ufs_msm_is_link_hibern8(hba)) {
+			ret = ufs_msm_phy_save_configuration(phy);
+			if (ret)
+				dev_err(hba->dev, "%s: failed
ufs_msm_phy_save_configuration %d\n",
+					__func__, ret);
+		}
+		phy_power_off(phy);
+	}
+
+out:
+	return ret;
+}
+
+static bool ufs_msm_is_phy_config_restore_required(struct ufs_hba *hba)
+{
+	struct ufs_msm_host *host = hba->priv;
+	struct phy *phy = host->generic_phy;
+
+	return ufs_msm_phy_is_cfg_restore_quirk_enabled(phy)
+		&& ufshcd_is_link_hibern8(hba)
+		&& hba->is_sys_suspended;
+}
+
+static int ufs_msm_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+{
+	struct ufs_msm_host *host = hba->priv;
+	struct phy *phy = host->generic_phy;
+	int err;
+
+	if (ufs_msm_is_phy_config_restore_required(hba)) {
+		ufs_msm_assert_reset(hba);
+		/* provide 1ms delay to let the reset pulse propagate */
+		usleep_range(1000, 1100);
+	}
+
+	err = phy_power_on(phy);
+	if (err) {
+		dev_err(hba->dev, "%s: failed enabling regs, err = %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	if (ufs_msm_is_phy_config_restore_required(hba)) {
+		ufs_msm_phy_restore_swi_regs(phy);
+
+		/* De-assert PHY reset and start serdes */
+		ufs_msm_deassert_reset(hba);
+
+		/*
+		 * after reset deassertion, phy will need all ref clocks,
+		 * voltage, current to settle down before starting serdes.
+		 */
+		usleep_range(1000, 1100);
+
+		err = phy_resume(host->generic_phy);
+	}
+
+	hba->is_sys_suspended = false;
+out:
+	return err;
+}
+
+struct ufs_msm_dev_params {
+	u32 pwm_rx_gear;	/* pwm rx gear to work in */
+	u32 pwm_tx_gear;	/* pwm tx gear to work in */
+	u32 hs_rx_gear;		/* hs rx gear to work in */
+	u32 hs_tx_gear;		/* hs tx gear to work in */
+	u32 rx_lanes;		/* number of rx lanes */
+	u32 tx_lanes;		/* number of tx lanes */
+	u32 rx_pwr_pwm;		/* rx pwm working pwr */
+	u32 tx_pwr_pwm;		/* tx pwm working pwr */
+	u32 rx_pwr_hs;		/* rx hs working pwr */
+	u32 tx_pwr_hs;		/* tx hs working pwr */
+	u32 hs_rate;		/* rate A/B to work in HS */
+	u32 desired_working_mode;
+};
+
+/**
+ * as every power mode, according to the UFS spec, have a defined
+ * number that are not corresponed to their order or power
+ * consumption (i.e 5, 2, 4, 1 respectively from low to high),
+ * we need to map them into array, so we can scan it easily
+ * in order to find the minimum required power mode.
+ * also, we can use this routine to go the other way around,
+ * and from array index, the fetch the correspond power mode.
+ */
+static int map_unmap_pwr_mode(u32 mode, bool is_pwr_to_arr)
+{
+	enum {SL_MD = 0, SLA_MD = 1, FS_MD = 2, FSA_MD = 3, UNDEF = 4};
+	int ret = -EINVAL;
+
+	if (is_pwr_to_arr) {
+		switch (mode) {
+		case SLOW_MODE:
+			ret = SL_MD;
+			break;
+		case SLOWAUTO_MODE:
+			ret = SLA_MD;
+			break;
+		case FAST_MODE:
+			ret = FS_MD;
+			break;
+		case FASTAUTO_MODE:
+			ret = FSA_MD;
+			break;
+		default:
+			ret = UNDEF;
+			break;
+		}
+	} else {
+		switch (mode) {
+		case SL_MD:
+			ret = SLOW_MODE;
+			break;
+		case SLA_MD:
+			ret = SLOWAUTO_MODE;
+			break;
+		case FS_MD:
+			ret = FAST_MODE;
+			break;
+		case FSA_MD:
+			ret = FASTAUTO_MODE;
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+#define NUM_OF_SUPPORTED_MODES	5
+static int get_pwr_dev_param(struct ufs_msm_dev_params *msm_param,
+				struct ufs_pa_layer_attr *dev_max,
+				struct ufs_pa_layer_attr *dev_req)
+{
+	int arr[NUM_OF_SUPPORTED_MODES] = {0};
+	int i;
+	int min_power;
+	int min_msm_gear;
+	int min_dev_gear;
+	bool is_max_dev_hs;
+	bool is_max_msm_hs;
+
+	/**
+	 * mapping the max. supported power mode of the device
+	 * and the max. pre-defined support power mode of the vendor
+	 * in order to scan them easily
+	 */
+	arr[map_unmap_pwr_mode(dev_max->pwr_rx, true)]++;
+	arr[map_unmap_pwr_mode(dev_max->pwr_tx, true)]++;
+
+	if (msm_param->desired_working_mode == SLOW) {
+		arr[map_unmap_pwr_mode(msm_param->rx_pwr_pwm, true)]++;
+		arr[map_unmap_pwr_mode(msm_param->tx_pwr_pwm, true)]++;
+	} else {
+		arr[map_unmap_pwr_mode(msm_param->rx_pwr_hs, true)]++;
+		arr[map_unmap_pwr_mode(msm_param->tx_pwr_hs, true)]++;
+	}
+
+	for (i = 0; i < NUM_OF_SUPPORTED_MODES; ++i) {
+		if (arr[i] != 0)
+			break;
+	}
+
+	/* no supported power mode found */
+	if (i == NUM_OF_SUPPORTED_MODES) {
+		return -EINVAL;
+	} else {
+		min_power = map_unmap_pwr_mode(i, false);
+		if (min_power >= 0)
+			dev_req->pwr_rx = dev_req->pwr_tx = min_power;
+		else
+			return -EINVAL;
+	}
+
+	/**
+	 * we would like tx to work in the minimum number of lanes
+	 * between device capability and vendor preferences.
+	 * the same decision will be made for rx.
+	 */
+	dev_req->lane_tx = min_t(u32, dev_max->lane_tx,
msm_param->tx_lanes);
+	dev_req->lane_rx = min_t(u32, dev_max->lane_rx,
msm_param->rx_lanes);
+
+	if (dev_max->pwr_rx == SLOW_MODE ||
+	    dev_max->pwr_rx == SLOWAUTO_MODE)
+		is_max_dev_hs = false;
+	else
+		is_max_dev_hs = true;
+
+	/* setting the device maximum gear */
+	min_dev_gear = min_t(u32, dev_max->gear_rx, dev_max->gear_tx);
+
+	/**
+	 * setting the desired gear to be the minimum according to the
desired
+	 * power mode
+	 */
+	if (msm_param->desired_working_mode == SLOW) {
+		is_max_msm_hs = false;
+		min_msm_gear = min_t(u32, msm_param->pwm_rx_gear,
+						msm_param->pwm_tx_gear);
+	} else {
+		is_max_msm_hs = true;
+		min_msm_gear = min_t(u32, msm_param->hs_rx_gear,
+						msm_param->hs_tx_gear);
+	}
+
+	/**
+	 * if both device capabilities and vendor pre-defined preferences
are
+	 * both HS or both PWM then set the minimum gear to be the
+	 * chosen working gear.
+	 * if one is PWM and one is HS then the one that is PWM get to
decide
+	 * what the gear, as he is the one that also decided previously what
+	 * pwr the device will be configured to.
+	 */
+	if ((is_max_dev_hs && is_max_msm_hs) ||
+	    (!is_max_dev_hs && !is_max_msm_hs)) {
+		dev_req->gear_rx = dev_req->gear_tx =
+			min_t(u32, min_dev_gear, min_msm_gear);
+	} else if (!is_max_dev_hs) {
+		dev_req->gear_rx = dev_req->gear_tx = min_dev_gear;
+	} else {
+		dev_req->gear_rx = dev_req->gear_tx = min_msm_gear;
+	}
+
+	dev_req->hs_rate = msm_param->hs_rate;
+
+	return 0;
+}
+
+static int ufs_msm_update_bus_bw_vote(struct ufs_msm_host *host)
+{
+	int vote;
+	int err = 0;
+	char mode[BUS_VECTOR_NAME_LEN];
+
+	err = ufs_msm_get_speed_mode(&host->dev_req_params, mode);
+	if (err)
+		goto out;
+
+	vote = ufs_msm_get_bus_vote(host, mode);
+	if (vote >= 0)
+		err = ufs_msm_set_bus_vote(host, vote);
+	else
+		err = vote;
+
+out:
+	if (err)
+		dev_err(host->hba->dev, "%s: failed %d\n", __func__, err);
+	else
+		host->bus_vote.saved_vote = vote;
+	return err;
+}
+
+static int ufs_msm_pwr_change_notify(struct ufs_hba *hba,
+				     bool status,
+				     struct ufs_pa_layer_attr
*dev_max_params,
+				     struct ufs_pa_layer_attr
*dev_req_params)
+{
+	u32 val;
+	struct ufs_msm_host *host = hba->priv;
+	struct phy *phy = host->generic_phy;
+	struct ufs_msm_dev_params ufs_msm_cap;
+	int ret = 0;
+	int res = 0;
+
+	if (!dev_req_params) {
+		pr_err("%s: incoming dev_req_params is NULL\n", __func__);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	switch (status) {
+	case PRE_CHANGE:
+		ufs_msm_cap.tx_lanes = UFS_MSM_LIMIT_NUM_LANES_TX;
+		ufs_msm_cap.rx_lanes = UFS_MSM_LIMIT_NUM_LANES_RX;
+		ufs_msm_cap.hs_rx_gear = UFS_MSM_LIMIT_HSGEAR_RX;
+		ufs_msm_cap.hs_tx_gear = UFS_MSM_LIMIT_HSGEAR_TX;
+		ufs_msm_cap.pwm_rx_gear = UFS_MSM_LIMIT_PWMGEAR_RX;
+		ufs_msm_cap.pwm_tx_gear = UFS_MSM_LIMIT_PWMGEAR_TX;
+		ufs_msm_cap.rx_pwr_pwm = UFS_MSM_LIMIT_RX_PWR_PWM;
+		ufs_msm_cap.tx_pwr_pwm = UFS_MSM_LIMIT_TX_PWR_PWM;
+		ufs_msm_cap.rx_pwr_hs = UFS_MSM_LIMIT_RX_PWR_HS;
+		ufs_msm_cap.tx_pwr_hs = UFS_MSM_LIMIT_TX_PWR_HS;
+		ufs_msm_cap.hs_rate = UFS_MSM_LIMIT_HS_RATE;
+		ufs_msm_cap.desired_working_mode =
+					UFS_MSM_LIMIT_DESIRED_MODE;
+
+		ret = get_pwr_dev_param(&ufs_msm_cap, dev_max_params,
+							dev_req_params);
+		if (ret) {
+			pr_err("%s: failed to determine capabilities\n",
+					__func__);
+			goto out;
+		}
+
+		break;
+	case POST_CHANGE:
+		if (!ufs_msm_cfg_timers(hba, dev_req_params->gear_rx,
+					dev_req_params->pwr_rx,
+					dev_req_params->hs_rate)) {
+			dev_err(hba->dev, "%s: ufs_msm_cfg_timers()
failed\n",
+				__func__);
+			/*
+			 * we return error code at the end of the routine,
+			 * but continue to configure UFS_PHY_TX_LANE_ENABLE
+			 * and bus voting as usual
+			 */
+			ret = -EINVAL;
+		}
+
+		val = ~(MAX_U32 << dev_req_params->lane_tx);
+		res = ufs_msm_phy_set_tx_lane_enable(phy, val);
+		if (res) {
+			dev_err(hba->dev, "%s:
ufs_msm_phy_set_tx_lane_enable() failed res = %d\n",
+				__func__, res);
+			ret = res;
+		}
+
+		/* cache the power mode parameters to use internally */
+		memcpy(&host->dev_req_params,
+				dev_req_params, sizeof(*dev_req_params));
+		ufs_msm_update_bus_bw_vote(host);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+out:
+	return ret;
+}
+
+/**
+ * ufs_msm_advertise_quirks - advertise the known MSM UFS controller quirks
+ * @hba: host controller instance
+ *
+ * MSM UFS host controller might have some non standard behaviours (quirks)
+ * than what is specified by UFSHCI specification. Advertise all such
+ * quirks to standard UFS host controller driver so standard takes them
into
+ * account.
+ */
+static void ufs_msm_advertise_quirks(struct ufs_hba *hba)
+{
+	struct ufs_msm_host *host = hba->priv;
+
+	phy_advertise_quirks(host->generic_phy);
+}
+
+static int ufs_msm_get_bus_vote(struct ufs_msm_host *host,
+		const char *speed_mode)
+{
+	struct device *dev = host->hba->dev;
+	struct device_node *np = dev->of_node;
+	int err;
+	const char *key = "qcom,bus-vector-names";
+
+	if (!speed_mode) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (host->bus_vote.is_max_bw_needed && !!strcmp(speed_mode, "MIN"))
+		err = of_property_match_string(np, key, "MAX");
+	else
+		err = of_property_match_string(np, key, speed_mode);
+
+out:
+	if (err < 0)
+		dev_err(dev, "%s: Invalid %s mode %d\n",
+				__func__, speed_mode, err);
+	return err;
+}
+
+static int ufs_msm_set_bus_vote(struct ufs_msm_host *host, int vote)
+{
+	int err = 0;
+
+	if (vote != host->bus_vote.curr_vote) {
+		err = msm_bus_scale_client_update_request(
+				host->bus_vote.client_handle, vote);
+		if (err) {
+			dev_err(host->hba->dev,
+				"%s: msm_bus_scale_client_update_request()
failed: bus_client_handle=0x%x, vote=%d, err=%d\n",
+				__func__, host->bus_vote.client_handle,
+				vote, err);
+			goto out;
+		}
+
+		host->bus_vote.curr_vote = vote;
+	}
+out:
+	return err;
+}
+
+static int ufs_msm_get_speed_mode(struct ufs_pa_layer_attr *p, char
*result)
+{
+	int err = 0;
+	int gear = max_t(u32, p->gear_rx, p->gear_tx);
+	int lanes = max_t(u32, p->lane_rx, p->lane_tx);
+	int pwr = max_t(u32, map_unmap_pwr_mode(p->pwr_rx, true),
+			map_unmap_pwr_mode(p->pwr_tx, true));
+
+	/* default to PWM Gear 1, Lane 1 if power mode is not initialized */
+	if (!gear)
+		gear = 1;
+
+	if (!lanes)
+		lanes = 1;
+
+	if (!p->pwr_rx && !p->pwr_tx)
+		pwr = 0;
+
+	pwr = map_unmap_pwr_mode(pwr, false);
+	if (pwr < 0) {
+		err = pwr;
+		goto out;
+	}
+
+	if (pwr == FAST_MODE || pwr == FASTAUTO_MODE)
+		snprintf(result, BUS_VECTOR_NAME_LEN, "%s_R%s_G%d_L%d",
"HS",
+				p->hs_rate == PA_HS_MODE_B ? "B" : "A",
+				gear, lanes);
+	else
+		snprintf(result, BUS_VECTOR_NAME_LEN, "%s_G%d_L%d",
+				"PWM", gear, lanes);
+out:
+	return err;
+}
+
+
+
+static int ufs_msm_setup_clocks(struct ufs_hba *hba, bool on)
+{
+	struct ufs_msm_host *host = hba->priv;
+	int err;
+	int vote = 0;
+
+	/*
+	 * In case ufs_msm_init() is not yet done, simply ignore.
+	 * This ufs_msm_setup_clocks() shall be called from
+	 * ufs_msm_init() after init is done.
+	 */
+	if (!host)
+		return 0;
+
+	if (on) {
+		err = ufs_msm_phy_enable_iface_clk(host->generic_phy);
+		if (err)
+			goto out;
+
+		vote = host->bus_vote.saved_vote;
+		if (vote == host->bus_vote.min_bw_vote)
+			ufs_msm_update_bus_bw_vote(host);
+	} else {
+		/* M-PHY RMMI interface clocks can be turned off */
+		ufs_msm_phy_disable_iface_clk(host->generic_phy);
+		vote = host->bus_vote.min_bw_vote;
+	}
+
+	err = ufs_msm_set_bus_vote(host, vote);
+	if (err)
+		dev_err(hba->dev, "%s: set bus vote failed %d\n",
+				__func__, err);
+
+out:
+	return err;
+}
+
+static ssize_t
+show_ufs_to_mem_max_bus_bw(struct device *dev, struct device_attribute
*attr,
+			char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_msm_host *host = hba->priv;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			host->bus_vote.is_max_bw_needed);
+}
+
+static ssize_t
+store_ufs_to_mem_max_bus_bw(struct device *dev, struct device_attribute
*attr,
+		const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_msm_host *host = hba->priv;
+	uint32_t value;
+
+	if (!kstrtou32(buf, 0, &value)) {
+		host->bus_vote.is_max_bw_needed = !!value;
+		ufs_msm_update_bus_bw_vote(host);
+	}
+
+	return count;
+}
+
+static int ufs_msm_bus_register(struct ufs_msm_host *host)
+{
+	int err;
+	struct msm_bus_scale_pdata *bus_pdata;
+	struct device *dev = host->hba->dev;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct device_node *np = dev->of_node;
+
+	bus_pdata = msm_bus_cl_get_pdata(pdev);
+	if (!bus_pdata) {
+		dev_err(dev, "%s: failed to get bus vectors\n", __func__);
+		err = -ENODATA;
+		goto out;
+	}
+
+	err = of_property_count_strings(np, "qcom,bus-vector-names");
+	if (err < 0 || err != bus_pdata->num_usecases) {
+		dev_err(dev, "%s: qcom,bus-vector-names not specified
correctly %d\n",
+				__func__, err);
+		goto out;
+	}
+
+	host->bus_vote.client_handle =
msm_bus_scale_register_client(bus_pdata);
+	if (!host->bus_vote.client_handle) {
+		dev_err(dev, "%s: msm_bus_scale_register_client failed\n",
+				__func__);
+		err = -EFAULT;
+		goto out;
+	}
+
+	/* cache the vote index for minimum and maximum bandwidth */
+	host->bus_vote.min_bw_vote = ufs_msm_get_bus_vote(host, "MIN");
+	host->bus_vote.max_bw_vote = ufs_msm_get_bus_vote(host, "MAX");
+
+	host->bus_vote.max_bus_bw.show = show_ufs_to_mem_max_bus_bw;
+	host->bus_vote.max_bus_bw.store = store_ufs_to_mem_max_bus_bw;
+	sysfs_attr_init(&host->bus_vote.max_bus_bw.attr);
+	host->bus_vote.max_bus_bw.attr.name = "max_bus_bw";
+	host->bus_vote.max_bus_bw.attr.mode = S_IRUGO | S_IWUSR;
+	err = device_create_file(dev, &host->bus_vote.max_bus_bw);
+out:
+	return err;
+}
+
+#define	ANDROID_BOOT_DEV_MAX	30
+static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
+static int get_android_boot_dev(char *str)
+{
+	strlcpy(android_boot_dev, str, ANDROID_BOOT_DEV_MAX);
+	return 1;
+}
+__setup("androidboot.bootdevice=", get_android_boot_dev);
+
+/**
+ * ufs_msm_init - bind phy with controller
+ * @hba: host controller instance
+ *
+ * Binds PHY with controller and powers up PHY enabling clocks
+ * and regulators.
+ *
+ * Returns -EPROBE_DEFER if binding fails, returns negative error
+ * on phy power up failure and returns zero on success.
+ */
+static int ufs_msm_init(struct ufs_hba *hba)
+{
+	int err;
+	struct device *dev = hba->dev;
+	struct ufs_msm_host *host;
+
+	if (strlen(android_boot_dev) && strcmp(android_boot_dev,
dev_name(dev)))
+		return -ENODEV;
+
+	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
+	if (!host) {
+		err = -ENOMEM;
+		dev_err(dev, "%s: no memory for msm ufs host\n", __func__);
+		goto out;
+	}
+
+	host->hba = hba;
+	host->generic_phy = devm_phy_get(dev, "ufs_msm_phy");
+
+	if (IS_ERR(host->generic_phy)) {
+		err = PTR_ERR(host->generic_phy);
+		dev_err(dev, "PHY get failed %d\n", err);
+		goto out;
+	}
+
+	hba->priv = (void *)host;
+
+	err = ufs_msm_bus_register(host);
+	if (err)
+		goto out_host_free;
+
+	phy_init(host->generic_phy);
+	err = phy_power_on(host->generic_phy);
+	if (err)
+		goto out_unregister_bus;
+
+	err = ufs_msm_init_lane_clks(host);
+	if (err)
+		goto out_disable_phy;
+
+	ufs_msm_advertise_quirks(hba);
+
+	hba->caps |= UFSHCD_CAP_CLK_GATING | UFSHCD_CAP_CLK_SCALING;
+	hba->caps |= UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
+	ufs_msm_setup_clocks(hba, true);
+	goto out;
+
+out_disable_phy:
+	phy_power_off(host->generic_phy);
+out_unregister_bus:
+	phy_exit(host->generic_phy);
+	msm_bus_scale_unregister_client(host->bus_vote.client_handle);
+out_host_free:
+	devm_kfree(dev, host);
+	hba->priv = NULL;
+out:
+	return err;
+}
+
+static void ufs_msm_exit(struct ufs_hba *hba)
+{
+	struct ufs_msm_host *host = hba->priv;
+
+	msm_bus_scale_unregister_client(host->bus_vote.client_handle);
+	ufs_msm_disable_lane_clks(host);
+	phy_power_off(host->generic_phy);
+}
+
+
+void ufs_msm_clk_scale_notify(struct ufs_hba *hba)
+{
+	struct ufs_msm_host *host = hba->priv;
+	struct ufs_pa_layer_attr *dev_req_params = &host->dev_req_params;
+
+	if (!dev_req_params)
+		return;
+
+	ufs_msm_cfg_timers(hba, dev_req_params->gear_rx,
+				dev_req_params->pwr_rx,
+				dev_req_params->hs_rate);
+	ufs_msm_update_bus_bw_vote(host);
+}
+/**
+ * struct ufs_hba_msm_vops - UFS MSM specific variant operations
+ *
+ * The variant operations configure the necessary controller and PHY
+ * handshake during initializaiton.
+ */
+const struct ufs_hba_variant_ops ufs_hba_msm_vops = {
+	.name                   = "msm",
+	.init                   = ufs_msm_init,
+	.exit                   = ufs_msm_exit,
+	.clk_scale_notify	= ufs_msm_clk_scale_notify,
+	.setup_clocks           = ufs_msm_setup_clocks,
+	.hce_enable_notify      = ufs_msm_hce_enable_notify,
+	.link_startup_notify    = ufs_msm_link_startup_notify,
+	.pwr_change_notify	= ufs_msm_pwr_change_notify,
+	.suspend		= ufs_msm_suspend,
+	.resume			= ufs_msm_resume,
+};
+EXPORT_SYMBOL(ufs_hba_msm_vops);
diff --git a/drivers/scsi/ufs/ufs-msm.h b/drivers/scsi/ufs/ufs-msm.h
new file mode 100644
index 0000000..6e93f1e
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-msm.h
@@ -0,0 +1,158 @@
+/* Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
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
+#ifndef UFS_MSM_H_
+#define UFS_MSM_H_
+
+#include <linux/phy/phy.h>
+
+#define MAX_U32                 (~(u32)0)
+#define MPHY_TX_FSM_STATE       0x41
+#define TX_FSM_HIBERN8          0x1
+#define HBRN8_POLL_TOUT_MS      100
+#define DEFAULT_CLK_RATE_HZ     1000000
+#define BUS_VECTOR_NAME_LEN     32
+
+#define UFS_HW_VER_MAJOR_SHFT	(28)
+#define UFS_HW_VER_MAJOR_MASK	(0x000F << UFS_HW_VER_MAJOR_SHFT)
+#define UFS_HW_VER_MINOR_SHFT	(16)
+#define UFS_HW_VER_MINOR_MASK	(0x0FFF << UFS_HW_VER_MINOR_SHFT)
+#define UFS_HW_VER_STEP_SHFT	(0)
+#define UFS_HW_VER_STEP_MASK	(0xFFFF << UFS_HW_VER_STEP_SHFT)
+
+/* vendor specific pre-defined parameters */
+#define SLOW 1
+#define FAST 2
+
+#define UFS_MSM_LIMIT_NUM_LANES_RX	2
+#define UFS_MSM_LIMIT_NUM_LANES_TX	2
+#define UFS_MSM_LIMIT_HSGEAR_RX	UFS_HS_G2
+#define UFS_MSM_LIMIT_HSGEAR_TX	UFS_HS_G2
+#define UFS_MSM_LIMIT_PWMGEAR_RX	UFS_PWM_G4
+#define UFS_MSM_LIMIT_PWMGEAR_TX	UFS_PWM_G4
+#define UFS_MSM_LIMIT_RX_PWR_PWM	SLOW_MODE
+#define UFS_MSM_LIMIT_TX_PWR_PWM	SLOW_MODE
+#define UFS_MSM_LIMIT_RX_PWR_HS	FAST_MODE
+#define UFS_MSM_LIMIT_TX_PWR_HS	FAST_MODE
+#define UFS_MSM_LIMIT_HS_RATE		PA_HS_MODE_A
+#define UFS_MSM_LIMIT_DESIRED_MODE	FAST
+
+/* MSM UFS host controller vendor specific registers */
+enum {
+	REG_UFS_SYS1CLK_1US                 = 0xC0,
+	REG_UFS_TX_SYMBOL_CLK_NS_US         = 0xC4,
+	REG_UFS_LOCAL_PORT_ID_REG           = 0xC8,
+	REG_UFS_PA_ERR_CODE                 = 0xCC,
+	REG_UFS_RETRY_TIMER_REG             = 0xD0,
+	REG_UFS_PA_LINK_STARTUP_TIMER       = 0xD8,
+	REG_UFS_CFG1                        = 0xDC,
+	REG_UFS_CFG2                        = 0xE0,
+	REG_UFS_HW_VERSION                  = 0xE4,
+};
+
+/* bit offset */
+enum {
+	OFFSET_UFS_PHY_SOFT_RESET           = 1,
+	OFFSET_CLK_NS_REG                   = 10,
+};
+
+/* bit masks */
+enum {
+	MASK_UFS_PHY_SOFT_RESET             = 0x2,
+	MASK_TX_SYMBOL_CLK_1US_REG          = 0x3FF,
+	MASK_CLK_NS_REG                     = 0xFFFC00,
+};
+
+static LIST_HEAD(phy_list);
+
+enum ufs_msm_phy_init_type {
+	UFS_PHY_INIT_FULL,
+	UFS_PHY_INIT_CFG_RESTORE,
+};
+
+struct ufs_msm_phy_vreg {
+	const char *name;
+	struct regulator *reg;
+	int max_uA;
+	int min_uV;
+	int max_uV;
+	bool enabled;
+};
+
+static inline void
+ufs_msm_get_controller_revision(struct ufs_hba *hba,
+				 u8 *major, u16 *minor, u16 *step)
+{
+	u32 ver = ufshcd_readl(hba, REG_UFS_HW_VERSION);
+
+	*major = (ver & UFS_HW_VER_MAJOR_MASK) >> UFS_HW_VER_MAJOR_SHFT;
+	*minor = (ver & UFS_HW_VER_MINOR_MASK) >> UFS_HW_VER_MINOR_SHFT;
+	*step = (ver & UFS_HW_VER_STEP_MASK) >> UFS_HW_VER_STEP_SHFT;
+};
+
+static inline void ufs_msm_assert_reset(struct ufs_hba *hba)
+{
+	ufshcd_rmwl(hba, MASK_UFS_PHY_SOFT_RESET,
+			1 << OFFSET_UFS_PHY_SOFT_RESET, REG_UFS_CFG1);
+	mb();
+}
+
+static inline void ufs_msm_deassert_reset(struct ufs_hba *hba)
+{
+	ufshcd_rmwl(hba, MASK_UFS_PHY_SOFT_RESET,
+			0 << OFFSET_UFS_PHY_SOFT_RESET, REG_UFS_CFG1);
+	mb();
+}
+
+struct ufs_msm_bus_vote {
+	uint32_t client_handle;
+	uint32_t curr_vote;
+	int min_bw_vote;
+	int max_bw_vote;
+	int saved_vote;
+	bool is_max_bw_needed;
+	struct device_attribute max_bus_bw;
+};
+
+struct ufs_msm_host {
+	struct phy *generic_phy;
+	struct ufs_hba *hba;
+	struct ufs_msm_bus_vote bus_vote;
+	struct ufs_pa_layer_attr dev_req_params;
+	struct clk *rx_l0_sync_clk;
+	struct clk *tx_l0_sync_clk;
+	struct clk *rx_l1_sync_clk;
+	struct clk *tx_l1_sync_clk;
+	bool is_lane_clks_enabled;
+};
+
+#define ufs_msm_is_link_off(hba) ufshcd_is_link_off(hba)
+#define ufs_msm_is_link_active(hba) ufshcd_is_link_active(hba)
+#define ufs_msm_is_link_hibern8(hba) ufshcd_is_link_hibern8(hba)
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
+#define MAX_PROP_NAME              32
+#define VDDA_PHY_MIN_UV            1000000
+#define VDDA_PHY_MAX_UV            1000000
+#define VDDA_PLL_MIN_UV            1800000
+#define VDDA_PLL_MAX_UV            1800000
+
+#endif /* UFS_MSM_H_ */
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

