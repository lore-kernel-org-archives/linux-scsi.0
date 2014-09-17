From: "Yaniv Gardi" <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: RE: [PATCH v4] scsi: ufs: add support of generic PHY framework in Qualcomm MSM chips
Date: Wed, 17 Sep 2014 19:26:05 +0300
Message-ID: <000001cfd294$18e4e300$4aaea900$@codeaurora.org>
References: <1410970929-25544-1-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410970929-25544-1-git-send-email-ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Content-Language: en-us
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, noag-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, 'Rob Herring' <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Pawel Moll' <pawel.moll-5wv7dgnIgG8@public.gmane.org>, 'Mark Rutland' <mark.rutland-5wv7dgnIgG8@public.gmane.org>, 'Ian Campbell' <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, 'Kumar Gala' <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, 'Kishon Vijay Abraham I' <kishon-l0cyMroinI0@public.gmane.org>, 'Vinayak Holikatti' <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "'James E.J. Bottomley'" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, 'Grant Likely' <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, 'Raviv Shvili' <rshvili-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, 'Sujit Reddy Thumma' <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, 'Sahitya Tummala' <stummala-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "'open list:OPEN FIRMWARE AND...'" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This change depends on draviv [PATCH v3] series of 16 changes that was
already uploaded.
Soon draviv will uploaded again as [PATCH v4] that contain 17 patches, and
this change will be dependent on this serie,

Thanks,
Yaniv

-----Original Message-----
From: Yaniv Gardi [mailto:ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org] 
Sent: Wednesday, September 17, 2014 7:22 PM
To: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org; hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org;
ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org; noag-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org; draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org; Rob
Herring; Pawel Moll; Mark Rutland; Ian Campbell; Kumar Gala; Kishon Vijay
Abraham I; Vinayak Holikatti; James E.J. Bottomley; Grant Likely; Raviv
Shvili; Sujit Reddy Thumma; Christoph Hellwig; Sahitya Tummala; open
list:OPEN FIRMWARE AND...
Subject: [PATCH v4] scsi: ufs: add support of generic PHY framework in
Qualcomm MSM chips

In this change we add support to the generic PHY framework.
Two UFS phys are implemented:
qmp-20nm and qmp-28nm.

Also, the files in this change implement the UFS HW (controller & PHY)
specific behavior in Qualcomm chips.
Relocation of a few header files is needed in order to expose routines
and data structures between PHY driver and UFS driver

Signed-off-by: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 .../devicetree/bindings/phy/qcom-ufs-phy.txt       |  37 +
 drivers/phy/Makefile                               |   3 +
 drivers/phy/phy-qcom-ufs-qmp-20nm.c                | 259 ++++++
 drivers/phy/phy-qcom-ufs-qmp-20nm.h                | 216 +++++
 drivers/phy/phy-qcom-ufs-qmp-28nm.c                | 342 ++++++++
 drivers/phy/phy-qcom-ufs-qmp-28nm.h                | 738 ++++++++++++++++++
 drivers/phy/phy-qcom-ufs.c                         | 661 ++++++++++++++++
 drivers/scsi/ufs/Kconfig                           |  12 +
 drivers/scsi/ufs/Makefile                          |   1 +
 drivers/scsi/ufs/ufs-qcom.c                        | 866
+++++++++++++++++++++
 drivers/scsi/ufs/ufs.h                             | 491 ------------
 drivers/scsi/ufs/ufshcd-pci.c                      |   2 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   2 +-
 drivers/scsi/ufs/ufshcd.c                          |  14 +-
 drivers/scsi/ufs/ufshcd.h                          | 595 --------------
 drivers/scsi/ufs/unipro.h                          | 207 -----
 include/linux/phy/phy-qcom-ufs.h                   | 202 +++++
 include/linux/scsi/ufs/ufs-qcom.h                  | 156 ++++
 include/linux/scsi/ufs/ufs.h                       | 491 ++++++++++++
 include/linux/scsi/ufs/ufshcd.h                    | 635 +++++++++++++++
 include/linux/scsi/ufs/unipro.h                    | 207 +++++
 21 files changed, 4840 insertions(+), 1297 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/qcom-ufs-phy.txt
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.c
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.h
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-28nm.c
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-28nm.h
 create mode 100644 drivers/phy/phy-qcom-ufs.c
 create mode 100644 drivers/scsi/ufs/ufs-qcom.c
 delete mode 100644 drivers/scsi/ufs/ufs.h
 delete mode 100644 drivers/scsi/ufs/ufshcd.h
 delete mode 100644 drivers/scsi/ufs/unipro.h
 create mode 100644 include/linux/phy/phy-qcom-ufs.h
 create mode 100644 include/linux/scsi/ufs/ufs-qcom.h
 create mode 100644 include/linux/scsi/ufs/ufs.h
 create mode 100644 include/linux/scsi/ufs/ufshcd.h
 create mode 100644 include/linux/scsi/ufs/unipro.h

diff --git a/Documentation/devicetree/bindings/phy/qcom-ufs-phy.txt
b/Documentation/devicetree/bindings/phy/qcom-ufs-phy.txt
new file mode 100644
index 0000000..8a6798f
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/qcom-ufs-phy.txt
@@ -0,0 +1,37 @@
+* QCOM Universal Flash Storage (UFS) PHY
+
+UFSPHY nodes are defined to describe on-chip UFS PHY hardware macro.
+Each UFS PHY node should have its own node.
+
+To bind UFS PHY with UFS host controller, the controller node should
+contain a phandle reference to UFS PHY node.
+
+Required properties:
+- compatible        : compatible list, contains "qcom,ufs-phy-qmp-28nm"
+                      or "qcom,ufs-phy-qmp-20nm" according to the relevant
+                      phy in use
+- reg               : <registers mapping>
+- #phy-cells        : This property shall be set to 0
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
+		compatible = "qcom,ufs-phy-qmp-28nm";
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
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 95c69ed..eac4854 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -28,3 +28,6 @@ obj-$(CONFIG_PHY_QCOM_IPQ806X_SATA)	+=
phy-qcom-ipq806x-sata.o
 obj-$(CONFIG_PHY_ST_SPEAR1310_MIPHY)	+= phy-spear1310-miphy.o
 obj-$(CONFIG_PHY_ST_SPEAR1340_MIPHY)	+= phy-spear1340-miphy.o
 obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
+obj-$(CONFIG_SCSI_UFS_QCOM) 		+= phy-qcom-ufs.o
+obj-$(CONFIG_SCSI_UFS_QCOM) 		+= phy-qcom-ufs-qmp-28nm.o
+obj-$(CONFIG_SCSI_UFS_QCOM) 		+= phy-qcom-ufs-qmp-20nm.o
diff --git a/drivers/phy/phy-qcom-ufs-qmp-20nm.c
b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
new file mode 100644
index 0000000..b6dcf2d
--- /dev/null
+++ b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
@@ -0,0 +1,259 @@
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
+#include <linux/platform_device.h>
+
+#include <linux/phy/phy-qcom-ufs.h>
+#include "phy-qcom-ufs-qmp-20nm.h"
+
+#define UFS_PHY_NAME "ufs_phy_qmp_20nm"
+
+static
+int ufs_qcom_phy_qmp_20nm_phy_calibrate(struct ufs_qcom_phy *ufs_qcom_phy)
+{
+	struct ufs_qcom_phy_calibration *tbl_A, *tbl_B;
+	int tbl_size_A, tbl_size_B;
+	int rate = UFS_QCOM_LIMIT_HS_RATE;
+	int err;
+
+	tbl_size_A = ARRAY_SIZE(phy_cal_table_rate_A);
+	tbl_A = phy_cal_table_rate_A;
+
+	tbl_size_B = ARRAY_SIZE(phy_cal_table_rate_B);
+	tbl_B = phy_cal_table_rate_B;
+
+	err = ufs_qcom_phy_calibrate(ufs_qcom_phy, tbl_A, tbl_size_A,
+						tbl_B, tbl_size_B, rate);
+
+	if (err)
+		dev_err(ufs_qcom_phy->dev, "%s: ufs_qcom_phy_calibrate()
failed %d\n",
+			__func__, err);
+
+	return err;
+}
+
+static
+void ufs_qcom_phy_qmp_20nm_advertise_quirks(struct ufs_qcom_phy
*phy_common)
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
+		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_clks()
failed %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	err = ufs_qcom_phy_init_vregulators(generic_phy, phy_common);
+	if (err) {
+		dev_err(phy_common->dev, "%s:
ufs_qcom_phy_init_vregulators() failed %d\n",
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
+void ufs_qcom_phy_qmp_20nm_power_control(struct ufs_qcom_phy *phy, bool
val)
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
+			 * Make sure workaround is deactivated before
proceeding
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
+void ufs_qcom_phy_qmp_20nm_set_tx_lane_enable(struct ufs_qcom_phy *phy, u32
val)
+{
+	writel_relaxed(val & UFS_PHY_TX_LANE_ENABLE_MASK,
+			phy->mmio + UFS_PHY_TX_LANE_ENABLE);
+	/*
+	 * ensure that TX_LANE_ENABLE_MASK is written to PHY before it
+	 * continues
+	 */
+	mb();
+}
+
+static inline void ufs_qcom_phy_qmp_20nm_start_serdes(struct ufs_qcom_phy
*phy)
+{
+	u32 tmp;
+
+	tmp = readl_relaxed(phy->mmio + UFS_PHY_PHY_START);
+	tmp &= ~MASK_SERDES_START;
+	tmp |= (1 << OFFSET_SERDES_START);
+	writel_relaxed(tmp, phy->mmio + UFS_PHY_PHY_START);
+	/*
+	 * ensure that UFS_PHY_PHY_START is written to PHY before before it
+	 * continues
+	 */
+	mb();
+}
+
+static int ufs_qcom_phy_qmp_20nm_is_pcs_ready(struct ufs_qcom_phy
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
+struct phy_ops ufs_qcom_phy_qmp_20nm_phy_ops = {
+	.init		= ufs_qcom_phy_qmp_20nm_init,
+	.exit		= ufs_qcom_phy_exit,
+	.power_on	= ufs_qcom_phy_power_on,
+	.power_off	= ufs_qcom_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+struct ufs_qcom_phy_specific_ops phy_20nm_ops = {
+	.calibrate_phy		= ufs_qcom_phy_qmp_20nm_phy_calibrate,
+	.start_serdes		= ufs_qcom_phy_qmp_20nm_start_serdes,
+	.is_physical_coding_sublayer_ready =
ufs_qcom_phy_qmp_20nm_is_pcs_ready,
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
+		err = -ENOMEM;
+		goto out;
+	}
+
+	generic_phy = ufs_qcom_phy_generic_probe(pdev, &phy->common_cfg,
+				&ufs_qcom_phy_qmp_20nm_phy_ops,
&phy_20nm_ops);
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
diff --git a/drivers/phy/phy-qcom-ufs-qmp-20nm.h
b/drivers/phy/phy-qcom-ufs-qmp-20nm.h
new file mode 100644
index 0000000..189e0ed
--- /dev/null
+++ b/drivers/phy/phy-qcom-ufs-qmp-20nm.h
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
+#ifndef UFS_QCOM_PHY_QMP_20NM_H_
+#define UFS_QCOM_PHY_QMP_20NM_H_
+
+#include <linux/phy/phy-qcom-ufs.h>
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
+ * get_ufs_qcom_phy() of generic phy, we can extract the
+ * common phy structure (struct ufs_qcom_phy) out of it
+ * regardless of the relevant specific phy.
+ */
+struct ufs_qcom_phy_qmp_20nm {
+	struct ufs_qcom_phy common_cfg;
+};
+
+static struct ufs_qcom_phy_calibration phy_cal_table_rate_A[] = {
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_POWER_DOWN_CONTROL, 0x01),
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
+};
+
+static struct ufs_qcom_phy_calibration phy_cal_table_rate_B[] = {
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_POWER_DOWN_CONTROL, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CRCTRL, 0xcc),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_SYSCLK_EN_SEL_TXBAND, 0x08),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CLKEPDIV, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_RXTXEPCLK_EN, 0x10),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x98),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START2, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1, 0x80),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2, 0x80),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3, 0x40),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0x65),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x1e),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP3, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP_EN, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL, 0x90),
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
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(0), 0x68),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(1), 0x68),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(1), 0xdc),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL2(0), 0xdc),
+};
+
+#endif
diff --git a/drivers/phy/phy-qcom-ufs-qmp-28nm.c
b/drivers/phy/phy-qcom-ufs-qmp-28nm.c
new file mode 100644
index 0000000..21594e1
--- /dev/null
+++ b/drivers/phy/phy-qcom-ufs-qmp-28nm.c
@@ -0,0 +1,342 @@
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
+#include <linux/platform_device.h>
+#include <linux/phy/phy.h>
+
+#include <linux/phy/phy-qcom-ufs.h>
+#include "phy-qcom-ufs-qmp-28nm.h"
+
+#define UFS_PHY_NAME "ufs_qcom_phy_qmp_28nm"
+
+static
+void ufs_qcom_phy_qmp_28nm_power_control(struct ufs_qcom_phy *phy, bool
val)
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
UFS_QCOM_PHY_DIS_SIGDET_BEFORE_PWR_COLLAPSE) {
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
+				UFS_QCOM_PHY_DIS_SIGDET_BEFORE_PWR_COLLAPSE)
{
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
+static
+void ufs_qcom_phy_qmp_28nm_advertise_quirks(struct ufs_qcom_phy
*phy_common)
+{
+	phy_common->quirks = UFS_QCOM_PHY_QUIRK_CFG_RESTORE
+				|
UFS_QCOM_PHY_DIS_SIGDET_BEFORE_PWR_COLLAPSE;
+}
+
+static int ufs_qcom_phy_qmp_28nm_init(struct phy *generic_phy)
+{
+	struct ufs_qcom_phy_qmp_28nm *phy = phy_get_drvdata(generic_phy);
+	struct ufs_qcom_phy *phy_common = &phy->common_cfg;
+	int err = 0;
+
+	err = ufs_qcom_phy_init_clks(generic_phy, phy_common);
+	if (err) {
+		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_clks()
failed %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	err = ufs_qcom_phy_init_vregulators(generic_phy, phy_common);
+	if (err) {
+		dev_err(phy_common->dev, "%s:
ufs_qcom_phy_init_vregulators() failed %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	ufs_qcom_phy_qmp_28nm_advertise_quirks(phy_common);
+
+out:
+	return err;
+}
+
+static int ufs_qcom_phy_qmp_28nm_calibrate(struct ufs_qcom_phy
*ufs_qcom_phy)
+{
+	struct ufs_qcom_phy_calibration *tbl_A, *tbl_B;
+	int tbl_size_A, tbl_size_B;
+	int rate = UFS_QCOM_LIMIT_HS_RATE;
+	u8 major = ufs_qcom_phy->host_ctrl_rev_major;
+	u16 minor = ufs_qcom_phy->host_ctrl_rev_minor;
+	u16 step = ufs_qcom_phy->host_ctrl_rev_step;
+	int err;
+
+	if ((major == 0x1) && (minor == 0x001) && (step == 0x0000)) {
+		tbl_size_A = ARRAY_SIZE(phy_cal_table_ctrl_1_1_0_rate_A);
+		tbl_A = phy_cal_table_ctrl_1_1_0_rate_A;
+	} else if ((major == 0x1) && (minor == 0x001) && (step == 0x0001)) {
+		tbl_size_A = ARRAY_SIZE(phy_cal_table_ctrl_1_1_1_rate_A);
+		tbl_A = phy_cal_table_ctrl_1_1_1_rate_A;
+	} else {
+		tbl_size_A = 0;
+		tbl_A = NULL;
+	}
+
+	tbl_B = phy_cal_table_rate_B;
+	tbl_size_B = ARRAY_SIZE(phy_cal_table_rate_B);
+
+	err = ufs_qcom_phy_calibrate(ufs_qcom_phy, tbl_A, tbl_size_A,
+			      tbl_B, tbl_size_B, rate);
+	if (err)
+		dev_err(ufs_qcom_phy->dev, "%s: ufs_qcom_phy_calibrate()
failed %d\n",
+			__func__, err);
+
+	return err;
+}
+
+static
+u32 ufs_qcom_phy_qmp_28nm_read_attr(struct ufs_qcom_phy *phy_common, u32
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
+static void
+ufs_qcom_phy_qmp_28nm_write_attr(struct ufs_qcom_phy *phy_common,
+				 u32 attr, u32 val)
+{
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
+static
+void ufs_qcom_phy_qmp_28nm_save_configuration(struct ufs_qcom_phy
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
+			ufs_qcom_phy_qmp_28nm_read_attr(phy_common,
+					cached_phy_attr[i].att);
+}
+
+static void
+ufs_qcom_phy_qmp_28nm_restore_configuration(struct ufs_qcom_phy
*phy_common)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cached_phy_attr); i++)
+		ufs_qcom_phy_qmp_28nm_write_attr(phy_common,
+			cached_phy_attr[i].att, cached_phy_attr[i].value);
+}
+
+static
+void ufs_qcom_phy_qmp_28nm_set_tx_lane_enable(struct ufs_qcom_phy *phy, u32
val)
+{
+	writel_relaxed(val & UFS_PHY_TX_LANE_ENABLE_MASK,
+			phy->mmio + UFS_PHY_TX_LANE_ENABLE);
+	/*
+	 * ensure that TX_LANE_ENABLE_MASK is written to PHY before it
+	 * continues
+	 */
+	mb();
+}
+
+static inline void ufs_qcom_phy_qmp_28nm_start_serdes(struct ufs_qcom_phy
*phy)
+{
+	u32 tmp;
+
+	tmp = readl_relaxed(phy->mmio + UFS_PHY_PHY_START);
+	tmp &= ~MASK_SERDES_START;
+	tmp |= (1 << OFFSET_SERDES_START);
+	writel_relaxed(tmp, phy->mmio + UFS_PHY_PHY_START);
+	/*
+	 * ensure that UFS_PHY_PHY_START is written to PHY before before it
+	 * continues
+	 */
+	mb();
+}
+
+static int ufs_qcom_phy_qmp_28nm_is_pcs_ready(struct ufs_qcom_phy
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
+struct phy_ops ufs_qcom_phy_qmp_28nm_phy_ops = {
+	.init		= ufs_qcom_phy_qmp_28nm_init,
+	.exit		= ufs_qcom_phy_exit,
+	.power_on	= ufs_qcom_phy_power_on,
+	.power_off	= ufs_qcom_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+struct ufs_qcom_phy_specific_ops phy_28nm_ops = {
+	.calibrate_phy		= ufs_qcom_phy_qmp_28nm_calibrate,
+	.start_serdes		= ufs_qcom_phy_qmp_28nm_start_serdes,
+	.save_configuration	= ufs_qcom_phy_qmp_28nm_save_configuration,
+	.restore_configuration	=
ufs_qcom_phy_qmp_28nm_restore_configuration,
+	.is_physical_coding_sublayer_ready =
ufs_qcom_phy_qmp_28nm_is_pcs_ready,
+	.set_tx_lane_enable	= ufs_qcom_phy_qmp_28nm_set_tx_lane_enable,
+	.power_control		= ufs_qcom_phy_qmp_28nm_power_control,
+};
+
+static int ufs_qcom_phy_qmp_28nm_probe(struct platform_device *pdev)
+{
+	struct ufs_qcom_phy_qmp_28nm *phy;
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
+			(struct ufs_qcom_phy_calibration *)cached_phy_regs;
+	phy->common_cfg.cached_regs_table_size =
+				ARRAY_SIZE(cached_phy_regs);
+
+	generic_phy = ufs_qcom_phy_generic_probe(pdev, &phy->common_cfg,
+				&ufs_qcom_phy_qmp_28nm_phy_ops,
&phy_28nm_ops);
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
+static int ufs_qcom_phy_qmp_28nm_remove(struct platform_device *pdev)
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
+static const struct of_device_id ufs_qcom_phy_qmp_28nm_of_match[] = {
+	{.compatible = "qcom,ufs-phy-qmp-28nm"},
+	{},
+};
+MODULE_DEVICE_TABLE(of, ufs_qcom_phy_qmp_28nm_of_match);
+
+static struct platform_driver ufs_qcom_phy_qmp_28nm_driver = {
+	.probe = ufs_qcom_phy_qmp_28nm_probe,
+	.remove = ufs_qcom_phy_qmp_28nm_remove,
+	.driver = {
+		.of_match_table = ufs_qcom_phy_qmp_28nm_of_match,
+		.name = "ufs_qcom_phy_qmp_28nm",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_platform_driver(ufs_qcom_phy_qmp_28nm_driver);
+
+MODULE_DESCRIPTION("Universal Flash Storage (UFS) QCOM PHY QMP 28nm");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/phy/phy-qcom-ufs-qmp-28nm.h
b/drivers/phy/phy-qcom-ufs-qmp-28nm.h
new file mode 100644
index 0000000..b406d99
--- /dev/null
+++ b/drivers/phy/phy-qcom-ufs-qmp-28nm.h
@@ -0,0 +1,738 @@
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
+#ifndef UFS_QCOM_PHY_QMP_28NM_H_
+#define UFS_QCOM_PHY_QMP_28NM_H_
+
+#include <linux/phy/phy-qcom-ufs.h>
+
+/* QCOM UFS PHY control registers */
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
+ * get_ufs_qcom_phy() of generic phy, we can extract the
+ * common phy structure (struct ufs_qcom_phy) out of it
+ * regardless of the relevant specific phy.
+ */
+struct ufs_qcom_phy_qmp_28nm {
+	struct ufs_qcom_phy common_cfg;
+};
+
+static struct ufs_qcom_phy_calibration phy_cal_table_ctrl_1_1_0_rate_A[] =
{
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_POWER_DOWN_CONTROL, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CRCTRL, 0xFF),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CNTRL, 0x24),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_SYSCLK_EN_SEL, 0x08),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_SYS_CLK_CTRL, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CLKEPDIV, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x82),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START2, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1, 0x80),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2, 0x80),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3, 0x10),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x67),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP3, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP_EN, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL, 0x10),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_RXTXEPCLK_EN, 0x13),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_PWM_CNTRL1(0), 0x43),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_PWM_CNTRL1(1), 0x43),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL(0), 0x22),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(0), 0x12),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(0), 0x2a),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL(1), 0x22),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(1), 0x12),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(1), 0x2a),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL(0), 0xC0),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL(1), 0xC0),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL2(0), 0x07),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL2(1), 0x07),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_PWM_G1_CLK_DIVIDER, 0x50),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_PWM_G2_CLK_DIVIDER, 0x28),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_PWM_G3_CLK_DIVIDER, 0x10),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_PWM_G4_CLK_DIVIDER, 0x08),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_CORECLK_PWM_G1_CLK_DIVIDER, 0xa8),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_CORECLK_PWM_G2_CLK_DIVIDER, 0x54),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_CORECLK_PWM_G3_CLK_DIVIDER, 0x2a),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_CORECLK_PWM_G4_CLK_DIVIDER, 0x15),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_OMC_STATUS_RDVAL, 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_LINE_RESET_TIME, 0x1f),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_LINE_RESET_GRANULARITY, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TSYNC_RSYNC_CNTL, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_PLL_CNTL, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_LARGE_AMP_DRV_LVL, 0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_SMALL_AMP_DRV_LVL, 0x1a),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_LARGE_AMP_POST_EMP_LVL, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_SMALL_AMP_POST_EMP_LVL, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_CFG_CHANGE_CNT_VAL, 0x09),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_SYNC_WAIT_TIME, 0x30),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY, 0x08),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_MIN_STALL_NOCONFIG_TIME_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_MIN_STALL_NOCONFIG_TIME_CAPABILITY, 0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_MIN_SAVE_CONFIG_TIME_CAPABILITY, 0x04),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_MIN_SAVE_CONFIG_TIME_CAPABILITY, 0xc8),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_PWM_BURST_CLOSURE_LENGTH_CAPABILITY, 0x10),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_MIN_ACTIVATETIME_CAPABILITY,
0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1(0), 0x07),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2(0), 0x07),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1(1), 0x07),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2(1), 0x07),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL3(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL3(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETI, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETI, 0x3f),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETP, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETP, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RES_TRIM_OFFSET, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_BGTC, 0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_AMP_OS, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_TX_DRV_LVL(0), 0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_TX_DRV_LVL(1), 0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_BIST_MODE_LANENO(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_BIST_MODE_LANENO(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_TX_EMP_POST1_LVL(0), 0x04),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_TX_EMP_POST1_LVL(1), 0x04),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_HIGHZ_TRANSCEIVEREN_BIAS_EN(0),
0x05),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_HIGHZ_TRANSCEIVEREN_BIAS_EN(1),
0x05),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TIMER_100US_SYSCLK_STEPS_MSB, 0x07),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TIMER_100US_SYSCLK_STEPS_LSB, 0x80),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TIMER_20US_CORECLK_STEPS_MSB, 0x27),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TIMER_20US_CORECLK_STEPS_LSB, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_CONTROLSYM_ONE_HOT_DISABLE, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RETIME_BUFFER_EN, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_HSGEAR_CAPABILITY, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_PWMGEAR_CAPABILITY, 0x04),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_AMPLITUDE_CAPABILITY, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_EXTERNALSYNC_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_HS_UNTERMINATED_LINE_DRIVE_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_LS_TERMINATED_LINE_DRIVE_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_REF_CLOCK_SHARED_CAPABILITY,
0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_HIBERN8TIME_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_HSGEAR_CAPABILITY, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_PWMGEAR_CAPABILITY, 0x04),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_UNTERMINATED_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_LS_TERMINATED_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_REF_CLOCK_SHARED_CAPABILITY,
0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G1_SYNC_LENGTH_CAPABILITY,
0x48),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_HS_G1_PREPARE_LENGTH_CAPABILITY, 0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_LS_PREPARE_LENGTH_CAPABILITY,
0x09),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_HIBERN8TIME_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G2_SYNC_LENGTH_CAPABILITY,
0x48),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G3_SYNC_LENGTH_CAPABILITY,
0x48),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_HS_G2_PREPARE_LENGTH_CAPABILITY, 0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_HS_G3_PREPARE_LENGTH_CAPABILITY, 0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_CLKBUF_ENABLE(0), 0x09),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_RESET_TSYNC_EN(0), 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_RES_CODE(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_SERDES_BYP_EN_OUT(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_REC_DETECT_LVL(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_PARRATE_REC_DETECT_IDLE_EN(0),
0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_TRAN_DRVR_EMP_EN(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_AUX_CONTROL(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_AUX_DATA_TCODE(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RCLK_AUXDATA_SEL(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_EQ_CONTROL(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_IQ_RXDET_EN(0), 0x73),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_TERM_HIGHZ_CM_AC_COUPLE(0),
0x05),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_FREEZE_UP_DN(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UFS_CNTRL(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_EIGHTH(0), 0x22),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FO_GAIN(0), 0x0a),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_SO_GAIN(0), 0x06),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		QSERDES_RX_UCDR_SO_SATURATION_AND_ENABLE(0), 0x35),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FO_TO_SO_DELAY(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_CLKBUF_ENABLE(1), 0x09),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_RESET_TSYNC_EN(1), 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_RES_CODE(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_SERDES_BYP_EN_OUT(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_REC_DETECT_LVL(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_PARRATE_REC_DETECT_IDLE_EN(1),
0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_TRAN_DRVR_EMP_EN(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_AUX_CONTROL(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_AUX_DATA_TCODE(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RCLK_AUXDATA_SEL(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_EQ_CONTROL(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_IQ_RXDET_EN(1), 0x73),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_TERM_HIGHZ_CM_AC_COUPLE(1),
0x05),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_FREEZE_UP_DN(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UFS_CNTRL(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_EIGHTH(1), 0x22),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FO_GAIN(1), 0x0a),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_SO_GAIN(1), 0x06),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		QSERDES_RX_UCDR_SO_SATURATION_AND_ENABLE(1), 0x35),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FO_TO_SO_DELAY(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_CMN_MODE, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_IE_TRIM, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_IP_TRIM, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_CORE_CLK_IN_SYNC_SEL, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_BIAS_EN_CLKBUFLR_EN, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_TEST_UPDN_RESTRIMSTEP, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_FAUX_EN, 0x00),
+};
+
+static struct ufs_qcom_phy_calibration phy_cal_table_ctrl_1_1_1_rate_A[] =
{
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_POWER_DOWN_CONTROL, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CRCTRL, 0x43),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CNTRL, 0x24),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_SYSCLK_EN_SEL, 0x08),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_SYS_CLK_CTRL, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CLKEPDIV, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x82),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START2, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1, 0x80),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2, 0x80),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3, 0x10),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x19),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP3, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP_EN, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RESETSM_CNTRL, 0x10),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_RXTXEPCLK_EN, 0x10),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_PWM_CNTRL1(0), 0x43),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_PWM_CNTRL1(1), 0x43),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL(0), 0x40),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(0), 0x0c),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(0), 0x12),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL(1), 0x40),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_HALF(1), 0x0c),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_QUARTER(1), 0x12),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL(0), 0xC0),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL(1), 0xC0),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL2(0), 0x07),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_SIGDET_CNTRL2(1), 0x07),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_PWM_G1_CLK_DIVIDER, 0x30),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_PWM_G2_CLK_DIVIDER, 0x18),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_PWM_G3_CLK_DIVIDER, 0x0c),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_PWM_G4_CLK_DIVIDER, 0x06),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_CORECLK_PWM_G1_CLK_DIVIDER, 0xa8),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_CORECLK_PWM_G2_CLK_DIVIDER, 0x54),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_CORECLK_PWM_G3_CLK_DIVIDER, 0x2a),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_CORECLK_PWM_G4_CLK_DIVIDER, 0x15),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_OMC_STATUS_RDVAL, 0xff),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_LINE_RESET_TIME, 0x1f),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_LINE_RESET_GRANULARITY, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TSYNC_RSYNC_CNTL, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_PLL_CNTL, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_LARGE_AMP_DRV_LVL, 0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_SMALL_AMP_DRV_LVL, 0x1a),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_LARGE_AMP_POST_EMP_LVL, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_SMALL_AMP_POST_EMP_LVL, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_CFG_CHANGE_CNT_VAL, 0x09),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_SYNC_WAIT_TIME, 0x30),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_MIN_SLEEP_NOCONFIG_TIME_CAPABILITY, 0x08),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_MIN_STALL_NOCONFIG_TIME_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_MIN_STALL_NOCONFIG_TIME_CAPABILITY, 0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_MIN_SAVE_CONFIG_TIME_CAPABILITY, 0x04),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_MIN_SAVE_CONFIG_TIME_CAPABILITY, 0xc8),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_RX_PWM_BURST_CLOSURE_LENGTH_CAPABILITY, 0x10),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_MIN_ACTIVATETIME_CAPABILITY,
0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1(0), 0x1f),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2(0), 0x17),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN1(1), 0x1f),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_EQ_GAIN2(1), 0x17),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL3(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL3(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETI, 0x07),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETI, 0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_IP_SETP, 0x07),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CP_SETP, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_RES_TRIM_OFFSET, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_BGTC, 0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_AMP_OS, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_TX_DRV_LVL(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_TX_DRV_LVL(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_BIST_MODE_LANENO(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_BIST_MODE_LANENO(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_TX_EMP_POST1_LVL(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_TX_EMP_POST1_LVL(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_HIGHZ_TRANSCEIVEREN_BIAS_EN(0),
0x05),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_HIGHZ_TRANSCEIVEREN_BIAS_EN(1),
0x05),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TIMER_100US_SYSCLK_STEPS_MSB, 0x07),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TIMER_100US_SYSCLK_STEPS_LSB, 0x80),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TIMER_20US_CORECLK_STEPS_MSB, 0x27),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TIMER_20US_CORECLK_STEPS_LSB, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_CONTROLSYM_ONE_HOT_DISABLE, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RETIME_BUFFER_EN, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_HSGEAR_CAPABILITY, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_PWMGEAR_CAPABILITY, 0x04),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_AMPLITUDE_CAPABILITY, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_EXTERNALSYNC_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_HS_UNTERMINATED_LINE_DRIVE_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		UFS_PHY_TX_LS_TERMINATED_LINE_DRIVE_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_REF_CLOCK_SHARED_CAPABILITY,
0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_TX_HIBERN8TIME_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_HSGEAR_CAPABILITY, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_PWMGEAR_CAPABILITY, 0x04),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_UNTERMINATED_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_LS_TERMINATED_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_REF_CLOCK_SHARED_CAPABILITY,
0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G1_SYNC_LENGTH_CAPABILITY,
0x48),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G1_PREPARE_LENGTH_CAPABILITY,
+
0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_LS_PREPARE_LENGTH_CAPABILITY,
0x0a),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_HIBERN8TIME_CAPABILITY, 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G2_SYNC_LENGTH_CAPABILITY,
0x48),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G3_SYNC_LENGTH_CAPABILITY,
0x48),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G2_PREPARE_LENGTH_CAPABILITY,
+
0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(UFS_PHY_RX_HS_G3_PREPARE_LENGTH_CAPABILITY,
+
0x0f),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_CLKBUF_ENABLE(0), 0x09),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_RESET_TSYNC_EN(0), 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_RES_CODE(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_SERDES_BYP_EN_OUT(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_REC_DETECT_LVL(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_PARRATE_REC_DETECT_IDLE_EN(0),
0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_TRAN_DRVR_EMP_EN(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_AUX_CONTROL(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_AUX_DATA_TCODE(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RCLK_AUXDATA_SEL(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_EQ_CONTROL(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_IQ_RXDET_EN(0), 0x51),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_TERM_HIGHZ_CM_AC_COUPLE(0),
0x05),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_FREEZE_UP_DN(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UFS_CNTRL(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_EIGHTH(0), 0x22),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FO_GAIN(0), 0x0a),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_SO_GAIN(0), 0x06),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		QSERDES_RX_UCDR_SO_SATURATION_AND_ENABLE(0), 0x35),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FO_TO_SO_DELAY(0), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_CLKBUF_ENABLE(1), 0x09),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_RESET_TSYNC_EN(1), 0x01),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_RES_CODE(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_SERDES_BYP_EN_OUT(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_REC_DETECT_LVL(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_PARRATE_REC_DETECT_IDLE_EN(1),
0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_TRAN_DRVR_EMP_EN(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_AUX_CONTROL(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_AUX_DATA_TCODE(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RCLK_AUXDATA_SEL(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_EQ_CONTROL(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_IQ_RXDET_EN(1), 0x51),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_RX_TERM_HIGHZ_CM_AC_COUPLE(1),
0x05),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_FREEZE_UP_DN(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UFS_CNTRL(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_CDR_CONTROL_EIGHTH(1), 0x22),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FO_GAIN(1), 0x0a),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_SO_GAIN(1), 0x06),
+	UFS_QCOM_PHY_CAL_ENTRY(
+		QSERDES_RX_UCDR_SO_SATURATION_AND_ENABLE(1), 0x35),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_RX_UCDR_FO_TO_SO_DELAY(1), 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_CMN_MODE, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_IE_TRIM, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_IP_TRIM, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_CORE_CLK_IN_SYNC_SEL, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_BIAS_EN_CLKBUFLR_EN, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_TEST_UPDN_RESTRIMSTEP, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_FAUX_EN, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(0), 0x08),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_TX_LANE_MODE(1), 0x08),
+};
+
+static struct ufs_qcom_phy_calibration phy_cal_table_rate_B[] = {
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLL_CLKEPDIV, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START1, 0x98),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DEC_START2, 0x03),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START1, 0x80),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START2, 0x80),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_DIV_FRAC_START3, 0x10),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP1, 0x65),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP2, 0x1E),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP3, 0x00),
+	UFS_QCOM_PHY_CAL_ENTRY(QSERDES_COM_PLLLOCK_CMP_EN, 0x03),
+};
+
+static struct ufs_qcom_phy_calibration cached_phy_regs[] = {
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
+static struct ufs_qcom_phy_stored_attributes cached_phy_attr[] = {
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
diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
new file mode 100644
index 0000000..48af90f
--- /dev/null
+++ b/drivers/phy/phy-qcom-ufs.c
@@ -0,0 +1,661 @@
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
+#include <linux/platform_device.h>
+
+#include <linux/phy/phy-qcom-ufs.h>
+
+int ufs_qcom_phy_calibrate(struct ufs_qcom_phy *ufs_qcom_phy,
+			   struct ufs_qcom_phy_calibration *tbl_A,
+			   int tbl_size_A,
+			   struct ufs_qcom_phy_calibration *tbl_B,
+			   int tbl_size_B, int rate)
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
+	if (rate == PA_HS_MODE_B) {
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
+				struct ufs_qcom_phy_specific_ops
*phy_spec_ops)
+{
+	int err;
+	struct device *dev = &pdev->dev;
+	struct phy *generic_phy = NULL;
+	struct phy_provider *phy_provider;
+
+	err = ufs_qcom_phy_base_init(pdev, common_cfg);
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
+	generic_phy = devm_phy_create(dev, NULL, ufs_qcom_phy_gen_ops,
NULL);
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
+ * struct ufs_qcom_phy. In order to function properly it's crucial
+ * to keep the embedded struct "struct ufs_qcom_phy common_cfg"
+ * as the first inside generic_phy.
+ */
+struct ufs_qcom_phy *get_ufs_qcom_phy(struct phy *generic_phy)
+{
+	return (struct ufs_qcom_phy *)phy_get_drvdata(generic_phy);
+}
+
+int ufs_qcom_phy_base_init(struct platform_device *pdev,
+			   struct ufs_qcom_phy *phy_common)
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
+int ufs_qcom_phy_clk_get(struct phy *phy,
+			 const char *name, struct clk **clk_out)
+{
+	struct clk *clk;
+	int err = 0;
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(phy);
+	struct device *dev = ufs_qcom_phy->dev;
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
+	err = ufs_qcom_phy_clk_get(generic_phy, "ref_clk_parent",
+				   &phy_common->ref_clk_parent);
+	if (err)
+		goto out;
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
+out:
+	return err;
+}
+
+int ufs_qcom_phy_init_vreg(struct phy *phy,
+			   struct ufs_qcom_phy_vreg *vreg, const char *name)
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
+int ufs_qcom_phy_disable_vreg(struct phy *phy,
+			      struct ufs_qcom_phy_vreg *vreg)
+{
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(phy);
+	struct device *dev = ufs_qcom_phy->dev;
+	int ret = 0;
+
+	if (!vreg || !vreg->enabled)
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
+		clk_disable_unprepare(phy->ref_clk_parent);
+		clk_disable_unprepare(phy->ref_clk_src);
+		phy->is_ref_clk_enabled = false;
+	}
+}
+
+void ufs_qcom_phy_restore_swi_regs(struct phy *generic_phy)
+{
+	int i;
+	struct ufs_qcom_phy *phy = get_ufs_qcom_phy(generic_phy);
+
+	for (i = 0; i < phy->cached_regs_table_size; i++) {
+		struct ufs_qcom_phy_calibration *table =
+			(struct ufs_qcom_phy_calibration *)phy->cached_regs;
+		writel_relaxed(table[i].cfg_value, phy->mmio +
+				table[i].reg_offset);
+	}
+
+	/* flush buffered writes */
+	mb();
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
+int ufs_qcom_phy_is_cfg_restore_quirk_enabled(struct phy *phy)
+{
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(phy);
+
+	return ufs_qcom_phy->quirks & UFS_QCOM_PHY_QUIRK_CFG_RESTORE;
+}
+
+int ufs_qcom_phy_start_serdes(struct phy *generic_phy)
+{
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
+	int ret = 0;
+
+	if (!ufs_qcom_phy->phy_spec_ops->start_serdes) {
+		dev_err(ufs_qcom_phy->dev, "%s: start_serdes() callback is
not supported\n",
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
+		dev_err(ufs_qcom_phy->dev, "%s: set_tx_lane_enable()
callback is not supported\n",
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
+int ufs_qcom_phy_calibrate_phy(struct phy *generic_phy)
+{
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
+	int ret = 0;
+
+	if (!ufs_qcom_phy->phy_spec_ops->calibrate_phy) {
+		dev_err(ufs_qcom_phy->dev, "%s: calibrate_phy() callback is
not supported\n",
+			__func__);
+		ret = -ENOTSUPP;
+	} else {
+		ret = ufs_qcom_phy->phy_spec_ops->
+				calibrate_phy(ufs_qcom_phy);
+		if (ret)
+			dev_err(ufs_qcom_phy->dev, "%s: calibrate_phy()
failed %d\n",
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
+	if (!ufs_qcom_phy->phy_spec_ops->is_physical_coding_sublayer_ready)
{
+		dev_err(ufs_qcom_phy->dev, "%s:
is_physical_coding_sublayer_ready() callback is not supported\n",
+			__func__);
+		return -ENOTSUPP;
+	}
+
+	return ufs_qcom_phy->phy_spec_ops->
+			is_physical_coding_sublayer_ready(ufs_qcom_phy);
+}
+
+int ufs_qcom_phy_save_configuration(struct phy *generic_phy)
+{
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
+	int ret = 0;
+
+	if (!ufs_qcom_phy->phy_spec_ops->save_configuration) {
+		dev_err(ufs_qcom_phy->dev, "%s: save_configuration()
callback is not supported\n",
+			__func__);
+		ret = -ENOTSUPP;
+	} else {
+
ufs_qcom_phy->phy_spec_ops->save_configuration(ufs_qcom_phy);
+	}
+
+	return ret;
+}
+
+int ufs_qcom_phy_restore_configuration(struct phy *generic_phy)
+{
+	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
+	int ret = 0;
+
+	if (!ufs_qcom_phy->phy_spec_ops->restore_configuration) {
+		dev_err(ufs_qcom_phy->dev, "%s: restore_configuration()
callback is not supported\n",
+			__func__);
+		ret = -ENOTSUPP;
+	} else {
+
ufs_qcom_phy->phy_spec_ops->restore_configuration(ufs_qcom_phy);
+	}
+
+	return ret;
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
+	phy_common->is_powered_on = true;
+	goto out;
+
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
+	ufs_qcom_phy_disable_ref_clk(generic_phy);
+
+	ufs_qcom_phy_disable_vreg(generic_phy, &phy_common->vdda_pll);
+	ufs_qcom_phy_disable_vreg(generic_phy, &phy_common->vdda_phy);
+	phy_common->is_powered_on = false;
+
+	return 0;
+}
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 6e07b2a..b7e426e 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -70,3 +70,15 @@ config SCSI_UFSHCD_PLATFORM
 	If you have a controller with this interface, say Y or M here.
 
 	  If unsure, say N.
+
+config SCSI_UFS_QCOM
+	bool "QCOM specific hooks to UFS controller platform driver"
+	depends on SCSI_UFSHCD_PLATFORM && ARCH_MSM
+	help
+	  This selects the QCOM specific additions to UFSHCD platform
driver.
+	  UFS host on QCOM needs some vendor specific configuration before
+	  accessing the hardware which includes PHY configuration and vendor
+	  specific registers.
+
+	  Select this if you have UFS controller on QCOM chipset.
+	  If unsure, say N.
\ No newline at end of file
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 1e5bd48..8303bcc 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -1,4 +1,5 @@
 # UFSHCD makefile
+obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
new file mode 100644
index 0000000..47e55e8
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -0,0 +1,866 @@
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
+#include <linux/platform_device.h>
+
+#include <linux/scsi/ufs/ufshcd.h>
+#include <linux/scsi/ufs/ufs-qcom.h>
+#include <linux/phy/phy-qcom-ufs.h>
+#include "ufshci.h"
+
+static int ufs_qcom_get_connected_tx_lanes(struct ufs_hba *hba, u32
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
+static int ufs_qcom_host_clk_get(struct device *dev,
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
+static int ufs_qcom_host_clk_enable(struct device *dev,
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
+static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
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
+static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
+{
+	int err = 0;
+	struct device *dev = host->hba->dev;
+
+	if (host->is_lane_clks_enabled)
+		return 0;
+
+	err = ufs_qcom_host_clk_enable(dev,
+			"rx_lane0_sync_clk", host->rx_l0_sync_clk);
+	if (err)
+		goto out;
+
+	err = ufs_qcom_host_clk_enable(dev,
+			"rx_lane1_sync_clk", host->rx_l1_sync_clk);
+	if (err)
+		goto disable_rx_l0;
+
+	err = ufs_qcom_host_clk_enable(dev,
+			"tx_lane0_sync_clk", host->tx_l0_sync_clk);
+	if (err)
+		goto disable_rx_l1;
+
+	err = ufs_qcom_host_clk_enable(dev,
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
+static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
+{
+	int err = 0;
+	struct device *dev = host->hba->dev;
+
+	err = ufs_qcom_host_clk_get(dev,
+			"rx_lane0_sync_clk", &host->rx_l0_sync_clk);
+	if (err)
+		goto out;
+
+	err = ufs_qcom_host_clk_get(dev,
+			"rx_lane1_sync_clk", &host->rx_l1_sync_clk);
+	if (err)
+		goto out;
+
+	err = ufs_qcom_host_clk_get(dev,
+			"tx_lane0_sync_clk", &host->tx_l0_sync_clk);
+	if (err)
+		goto out;
+
+	err = ufs_qcom_host_clk_get(dev,
+			"tx_lane1_sync_clk", &host->tx_l1_sync_clk);
+out:
+	return err;
+}
+
+static int ufs_qcom_link_startup_post_change(struct ufs_hba *hba)
+{
+	struct ufs_qcom_host *host = hba->priv;
+	struct phy *phy = host->generic_phy;
+	u32 tx_lanes;
+	int err = 0;
+
+	err = ufs_qcom_get_connected_tx_lanes(hba, &tx_lanes);
+	if (err)
+		goto out;
+
+	err = ufs_qcom_phy_set_tx_lane_enable(phy, tx_lanes);
+	if (err)
+		dev_err(hba->dev, "%s: ufs_qcom_phy_set_tx_lane_enable
failed\n",
+			__func__);
+
+out:
+	return err;
+}
+
+static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
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
+static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
+{
+	struct ufs_qcom_host *host = hba->priv;
+	struct phy *phy = host->generic_phy;
+	int ret = 0;
+	u8 major;
+	u16 minor, step;
+
+	/* Assert PHY reset and apply PHY calibration values */
+	ufs_qcom_assert_reset(hba);
+	/* provide 1ms delay to let the reset pulse propagate */
+	usleep_range(1000, 1100);
+
+	ufs_qcom_get_controller_revision(hba, &major, &minor, &step);
+	ufs_qcom_phy_save_controller_version(phy, major, minor, step);
+	ret = ufs_qcom_phy_calibrate_phy(phy);
+	if (ret) {
+		dev_err(hba->dev, "%s: ufs_qcom_phy_calibrate_phy() failed,
ret = %d\n",
+			__func__, ret);
+		goto out;
+	}
+
+	/* De-assert PHY reset and start serdes */
+	ufs_qcom_deassert_reset(hba);
+
+	/*
+	 * after reset deassertion, phy will need all ref clocks,
+	 * voltage, current to settle down before starting serdes.
+	 */
+	usleep_range(1000, 1100);
+	ret = ufs_qcom_phy_start_serdes(phy);
+	if (ret) {
+		dev_err(hba->dev, "%s: ufs_qcom_phy_start_serdes() failed,
ret = %d\n",
+			__func__, ret);
+		goto out;
+	}
+
+	ret = ufs_qcom_phy_is_pcs_ready(phy);
+	if (ret)
+		dev_err(hba->dev, "%s: is_physical_coding_sublayer_ready()
failed, ret = %d\n",
+			__func__, ret);
+
+out:
+	return ret;
+}
+
+static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba, bool status)
+{
+	struct ufs_qcom_host *host = hba->priv;
+	int err = 0;
+
+	switch (status) {
+	case PRE_CHANGE:
+		ufs_qcom_power_up_sequence(hba);
+		/*
+		 * The PHY PLL output is the source of tx/rx lane symbol
+		 * clocks, hence, enable the lane clocks only after PHY
+		 * is initialized.
+		 */
+		err = ufs_qcom_enable_lane_clks(host);
+		break;
+	case POST_CHANGE:
+		/* check if UFS PHY moved from DISABLED to HIBERN8 */
+		err = ufs_qcom_check_hibern8(hba);
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
+ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear, u32 hs, u32 rate)
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
+static int ufs_qcom_link_startup_notify(struct ufs_hba *hba, bool status)
+{
+	unsigned long core_clk_rate = 0;
+	u32 core_clk_cycles_per_100ms;
+
+	switch (status) {
+	case PRE_CHANGE:
+		core_clk_rate = ufs_qcom_cfg_timers(hba, UFS_PWM_G1,
+						    SLOWAUTO_MODE, 0);
+		if (!core_clk_rate) {
+			dev_err(hba->dev, "%s: ufs_qcom_cfg_timers()
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
+		ufs_qcom_link_startup_post_change(hba);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+{
+	struct ufs_qcom_host *host = hba->priv;
+	struct phy *phy = host->generic_phy;
+	int ret = 0;
+
+	if (ufs_qcom_is_link_off(hba)) {
+		/*
+		 * Disable the tx/rx lane symbol clocks before PHY is
+		 * powered down as the PLL source should be disabled
+		 * after downstream clocks are disabled.
+		 */
+		ufs_qcom_disable_lane_clks(host);
+		phy_power_off(phy);
+
+		goto out;
+	}
+
+	/*
+	 * If UniPro link is not active, PHY ref_clk, main PHY analog power
+	 * rail and low noise analog power rail for PLL can be switched off.
+	 */
+	if (!ufs_qcom_is_link_active(hba)) {
+		if (ufs_qcom_phy_is_cfg_restore_quirk_enabled(phy) &&
+		    ufs_qcom_is_link_hibern8(hba)) {
+			ret = ufs_qcom_phy_save_configuration(phy);
+			if (ret)
+				dev_err(hba->dev, "%s: failed
ufs_qcom_phy_save_configuration %d\n",
+					__func__, ret);
+		}
+		phy_power_off(phy);
+	}
+
+out:
+	return ret;
+}
+
+static bool ufs_qcom_is_phy_config_restore_required(struct ufs_hba *hba)
+{
+	struct ufs_qcom_host *host = hba->priv;
+	struct phy *phy = host->generic_phy;
+
+	return ufs_qcom_phy_is_cfg_restore_quirk_enabled(phy)
+		&& ufshcd_is_link_hibern8(hba)
+		&& hba->is_sys_suspended;
+}
+
+static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+{
+	struct ufs_qcom_host *host = hba->priv;
+	struct phy *phy = host->generic_phy;
+	int err;
+
+	if (ufs_qcom_is_phy_config_restore_required(hba)) {
+		ufs_qcom_assert_reset(hba);
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
+	if (ufs_qcom_is_phy_config_restore_required(hba)) {
+		ufs_qcom_phy_restore_swi_regs(phy);
+
+		/* De-assert PHY reset and start serdes */
+		ufs_qcom_deassert_reset(hba);
+
+		/*
+		 * after reset deassertion, phy will need all ref clocks,
+		 * voltage, current to settle down before starting serdes.
+		 */
+		usleep_range(1000, 1100);
+
+		err = ufs_qcom_phy_start_serdes(phy);
+		if (err) {
+			dev_err(hba->dev, "%s: ufs_qcom_phy_start_serdes()
failed, err = %d\n",
+				__func__, err);
+			goto out;
+		}
+
+		err = ufs_qcom_phy_restore_configuration(phy);
+		if (err) {
+			dev_err(hba->dev, "%s:
ufs_qcom_phy_restore_configuration() failed, err = %d\n",
+				__func__, err);
+			goto out;
+		}
+
+		err = ufs_qcom_phy_is_pcs_ready(phy);
+		if (err) {
+			dev_err(hba->dev, "%s:
is_physical_coding_sublayer_ready() failed, err = %d\n",
+				__func__, err);
+			goto out;
+		}
+	}
+
+	hba->is_sys_suspended = false;
+out:
+	return err;
+}
+
+struct ufs_qcom_dev_params {
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
+static int ufs_qcom_get_pwr_dev_param(struct ufs_qcom_dev_params
*qcom_param,
+				      struct ufs_pa_layer_attr *dev_max,
+				      struct ufs_pa_layer_attr *agreed_pwr)
+{
+	int min_qcom_gear;
+	int min_dev_gear;
+	bool is_dev_sup_hs = false;
+	bool is_qcom_max_hs = false;
+
+	if (dev_max->pwr_rx == FAST_MODE)
+		is_dev_sup_hs = true;
+
+	if (qcom_param->desired_working_mode == FAST) {
+		is_qcom_max_hs = true;
+		min_qcom_gear = min_t(u32, qcom_param->hs_rx_gear,
+				      qcom_param->hs_tx_gear);
+	} else {
+		min_qcom_gear = min_t(u32, qcom_param->pwm_rx_gear,
+				      qcom_param->pwm_tx_gear);
+	}
+
+	/*
+	 * device doesn't support HS but qcom_param->desired_working_mode is
+	 * HS, thus device and qcom_param don't agree
+	 */
+	if (!is_dev_sup_hs && is_qcom_max_hs) {
+		pr_err("%s: failed to agree on power mode (device doesn't
support HS but requested power is HS)\n",
+			__func__);
+		return -ENOTSUPP;
+	} else if (is_dev_sup_hs && is_qcom_max_hs) {
+		/*
+		 * since device supports HS, it supports FAST_MODE.
+		 * since qcom_param->desired_working_mode is also HS
+		 * then final decision (FAST/FASTAUTO) is done according
+		 * to qcom_params as it is the restricting factor
+		 */
+		agreed_pwr->pwr_rx = agreed_pwr->pwr_tx =
+						qcom_param->rx_pwr_hs;
+	} else {
+		/*
+		 * here qcom_param->desired_working_mode is PWM.
+		 * it doesn't matter whether device supports HS or PWM,
+		 * in both cases qcom_param->desired_working_mode will
+		 * determine the mode
+		 */
+		 agreed_pwr->pwr_rx = agreed_pwr->pwr_tx =
+						qcom_param->rx_pwr_pwm;
+	}
+
+	/*
+	 * we would like tx to work in the minimum number of lanes
+	 * between device capability and vendor preferences.
+	 * the same decision will be made for rx
+	 */
+	agreed_pwr->lane_tx = min_t(u32, dev_max->lane_tx,
+						qcom_param->tx_lanes);
+	agreed_pwr->lane_rx = min_t(u32, dev_max->lane_rx,
+						qcom_param->rx_lanes);
+
+	/* device maximum gear is the minimum between device rx and tx gears
*/
+	min_dev_gear = min_t(u32, dev_max->gear_rx, dev_max->gear_tx);
+
+	/*
+	 * if both device capabilities and vendor pre-defined preferences
are
+	 * both HS or both PWM then set the minimum gear to be the chosen
+	 * working gear.
+	 * if one is PWM and one is HS then the one that is PWM get to
decide
+	 * what is the gear, as it is the one that also decided previously
what
+	 * pwr the device will be configured to.
+	 */
+	if ((is_dev_sup_hs && is_qcom_max_hs) ||
+	    (!is_dev_sup_hs && !is_qcom_max_hs))
+		agreed_pwr->gear_rx = agreed_pwr->gear_tx =
+			min_t(u32, min_dev_gear, min_qcom_gear);
+	else if (!is_dev_sup_hs)
+		agreed_pwr->gear_rx = agreed_pwr->gear_tx = min_dev_gear;
+	else
+		agreed_pwr->gear_rx = agreed_pwr->gear_tx = min_qcom_gear;
+
+	agreed_pwr->hs_rate = qcom_param->hs_rate;
+	return 0;
+}
+
+static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
+				bool status,
+				struct ufs_pa_layer_attr *dev_max_params,
+				struct ufs_pa_layer_attr *dev_req_params)
+{
+	u32 val;
+	struct ufs_qcom_host *host = hba->priv;
+	struct phy *phy = host->generic_phy;
+	struct ufs_qcom_dev_params ufs_qcom_cap;
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
+		ufs_qcom_cap.tx_lanes = UFS_QCOM_LIMIT_NUM_LANES_TX;
+		ufs_qcom_cap.rx_lanes = UFS_QCOM_LIMIT_NUM_LANES_RX;
+		ufs_qcom_cap.hs_rx_gear = UFS_QCOM_LIMIT_HSGEAR_RX;
+		ufs_qcom_cap.hs_tx_gear = UFS_QCOM_LIMIT_HSGEAR_TX;
+		ufs_qcom_cap.pwm_rx_gear = UFS_QCOM_LIMIT_PWMGEAR_RX;
+		ufs_qcom_cap.pwm_tx_gear = UFS_QCOM_LIMIT_PWMGEAR_TX;
+		ufs_qcom_cap.rx_pwr_pwm = UFS_QCOM_LIMIT_RX_PWR_PWM;
+		ufs_qcom_cap.tx_pwr_pwm = UFS_QCOM_LIMIT_TX_PWR_PWM;
+		ufs_qcom_cap.rx_pwr_hs = UFS_QCOM_LIMIT_RX_PWR_HS;
+		ufs_qcom_cap.tx_pwr_hs = UFS_QCOM_LIMIT_TX_PWR_HS;
+		ufs_qcom_cap.hs_rate = UFS_QCOM_LIMIT_HS_RATE;
+		ufs_qcom_cap.desired_working_mode =
+					UFS_QCOM_LIMIT_DESIRED_MODE;
+
+		ret = ufs_qcom_get_pwr_dev_param(&ufs_qcom_cap,
+						 dev_max_params,
+						 dev_req_params);
+		if (ret) {
+			pr_err("%s: failed to determine capabilities\n",
+					__func__);
+			goto out;
+		}
+
+		break;
+	case POST_CHANGE:
+		if (!ufs_qcom_cfg_timers(hba, dev_req_params->gear_rx,
+					dev_req_params->pwr_rx,
+					dev_req_params->hs_rate)) {
+			dev_err(hba->dev, "%s: ufs_qcom_cfg_timers()
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
+		res = ufs_qcom_phy_set_tx_lane_enable(phy, val);
+		if (res) {
+			dev_err(hba->dev, "%s:
ufs_qcom_phy_set_tx_lane_enable() failed res = %d\n",
+				__func__, res);
+			ret = res;
+		}
+
+		/* cache the power mode parameters to use internally */
+		memcpy(&host->dev_req_params,
+				dev_req_params, sizeof(*dev_req_params));
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
+ * ufs_qcom_advertise_quirks - advertise the known QCOM UFS controller
quirks
+ * @hba: host controller instance
+ *
+ * QCOM UFS host controller might have some non standard behaviours
(quirks)
+ * than what is specified by UFSHCI specification. Advertise all such
+ * quirks to standard UFS host controller driver so standard takes them
into
+ * account.
+ */
+static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
+{
+	u8 major;
+	u16 minor, step;
+
+	ufs_qcom_get_controller_revision(hba, &major, &minor, &step);
+
+	if ((major == 0x1) && (minor == 0x001) && (step == 0x0001))
+		hba->quirks |= (UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS
+			      | UFSHCD_QUIRK_BROKEN_INTR_AGGR
+			      | UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP
+			      | UFSHCD_QUIRK_BROKEN_LCC);
+	else if ((major == 0x1) && (minor == 0x002) && (step == 0x0000))
+		hba->quirks |= (UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS
+			      | UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP
+			      | UFSHCD_QUIRK_BROKEN_LCC);
+}
+
+static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on)
+{
+	struct ufs_qcom_host *host = hba->priv;
+	int err = 0;
+	int vote = 0;
+
+	/*
+	 * In case ufs_qcom_init() is not yet done, simply ignore.
+	 * This ufs_qcom_setup_clocks() shall be called from
+	 * ufs_qcom_init() after init is done.
+	 */
+	if (!host)
+		return 0;
+
+	if (on) {
+		err = ufs_qcom_phy_enable_iface_clk(host->generic_phy);
+		if (err)
+			goto out;
+
+		vote = host->bus_vote.saved_vote;
+	} else {
+		/* M-PHY RMMI interface clocks can be turned off */
+		ufs_qcom_phy_disable_iface_clk(host->generic_phy);
+		vote = host->bus_vote.min_bw_vote;
+	}
+
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
+ * ufs_qcom_init - bind phy with controller
+ * @hba: host controller instance
+ *
+ * Binds PHY with controller and powers up PHY enabling clocks
+ * and regulators.
+ *
+ * Returns -EPROBE_DEFER if binding fails, returns negative error
+ * on phy power up failure and returns zero on success.
+ */
+static int ufs_qcom_init(struct ufs_hba *hba)
+{
+	int err;
+	struct device *dev = hba->dev;
+	struct ufs_qcom_host *host;
+
+	if (strlen(android_boot_dev) && strcmp(android_boot_dev,
dev_name(dev)))
+		return -ENODEV;
+
+	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
+	if (!host) {
+		err = -ENOMEM;
+		dev_err(dev, "%s: no memory for qcom ufs host\n", __func__);
+		goto out;
+	}
+
+	host->hba = hba;
+	host->generic_phy = devm_phy_get(dev, "ufsphy");
+
+	if (IS_ERR(host->generic_phy)) {
+		err = PTR_ERR(host->generic_phy);
+		dev_err(dev, "PHY get failed %d\n", err);
+		goto out;
+	}
+
+	hba->priv = (void *)host;
+
+	phy_init(host->generic_phy);
+	err = phy_power_on(host->generic_phy);
+	if (err)
+		goto out_phy_exit;
+
+	err = ufs_qcom_init_lane_clks(host);
+	if (err)
+		goto out_disable_phy;
+
+	ufs_qcom_advertise_quirks(hba);
+
+	hba->caps |= UFSHCD_CAP_CLK_GATING | UFSHCD_CAP_CLK_SCALING;
+	hba->caps |= UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
+	hba->caps |= UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
+	ufs_qcom_setup_clocks(hba, true);
+	goto out;
+
+out_disable_phy:
+	phy_power_off(host->generic_phy);
+out_phy_exit:
+	phy_exit(host->generic_phy);
+	devm_kfree(dev, host);
+	hba->priv = NULL;
+out:
+	return err;
+}
+
+static void ufs_qcom_exit(struct ufs_hba *hba)
+{
+	struct ufs_qcom_host *host = hba->priv;
+
+	ufs_qcom_disable_lane_clks(host);
+	phy_power_off(host->generic_phy);
+}
+
+
+void ufs_qcom_clk_scale_notify(struct ufs_hba *hba)
+{
+	struct ufs_qcom_host *host = hba->priv;
+	struct ufs_pa_layer_attr *dev_req_params = &host->dev_req_params;
+
+	if (!dev_req_params)
+		return;
+
+	ufs_qcom_cfg_timers(hba, dev_req_params->gear_rx,
+				dev_req_params->pwr_rx,
+				dev_req_params->hs_rate);
+}
+
+/**
+ * struct ufs_hba_qcom_vops - UFS QCOM specific variant operations
+ *
+ * The variant operations configure the necessary controller and PHY
+ * handshake during initializaiton.
+ */
+const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
+	.name                   = "qcom",
+	.init                   = ufs_qcom_init,
+	.exit                   = ufs_qcom_exit,
+	.clk_scale_notify	= ufs_qcom_clk_scale_notify,
+	.setup_clocks           = ufs_qcom_setup_clocks,
+	.hce_enable_notify      = ufs_qcom_hce_enable_notify,
+	.link_startup_notify    = ufs_qcom_link_startup_notify,
+	.pwr_change_notify	= ufs_qcom_pwr_change_notify,
+	.suspend		= ufs_qcom_suspend,
+	.resume			= ufs_qcom_resume,
+};
+EXPORT_SYMBOL(ufs_hba_qcom_vops);
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
deleted file mode 100644
index 42c459a..0000000
--- a/drivers/scsi/ufs/ufs.h
+++ /dev/null
@@ -1,491 +0,0 @@
-/*
- * Universal Flash Storage Host controller driver
- *
- * This code is based on drivers/scsi/ufs/ufs.h
- * Copyright (C) 2011-2013 Samsung India Software Operations
- *
- * Authors:
- *	Santosh Yaraganavi <santosh.sy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
- *	Vinayak Holikatti <h.vinayak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- * See the COPYING file in the top-level directory or visit
- * <http://www.gnu.org/licenses/gpl-2.0.html>
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * This program is provided "AS IS" and "WITH ALL FAULTS" and
- * without warranty of any kind. You are solely responsible for
- * determining the appropriateness of using and distributing
- * the program and assume all risks associated with your exercise
- * of rights with respect to the program, including but not limited
- * to infringement of third party rights, the risks and costs of
- * program errors, damage to or loss of data, programs or equipment,
- * and unavailability or interruption of operations. Under no
- * circumstances will the contributor of this Program be liable for
- * any damages of any kind arising from your use or distribution of
- * this program.
- */
-
-#ifndef _UFS_H
-#define _UFS_H
-
-#include <linux/mutex.h>
-#include <linux/types.h>
-
-#define MAX_CDB_SIZE	16
-#define GENERAL_UPIU_REQUEST_SIZE 32
-#define QUERY_DESC_MAX_SIZE       255
-#define QUERY_DESC_MIN_SIZE       2
-#define QUERY_OSF_SIZE            (GENERAL_UPIU_REQUEST_SIZE - \
-					(sizeof(struct utp_upiu_header)))
-
-#define UPIU_HEADER_DWORD(byte3, byte2, byte1, byte0)\
-			cpu_to_be32((byte3 << 24) | (byte2 << 16) |\
-			 (byte1 << 8) | (byte0))
-/*
- * UFS device may have standard LUs and LUN id could be from 0x00 to
- * 0x7F. Standard LUs use "Peripheral Device Addressing Format".
- * UFS device may also have the Well Known LUs (also referred as W-LU)
- * which again could be from 0x00 to 0x7F. For W-LUs, device only use
- * the "Extended Addressing Format" which means the W-LUNs would be
- * from 0xc100 (SCSI_W_LUN_BASE) onwards.
- * This means max. LUN number reported from UFS device could be 0xC17F.
- */
-#define UFS_UPIU_MAX_UNIT_NUM_ID	0x7F
-#define UFS_MAX_LUNS		(SCSI_W_LUN_BASE + UFS_UPIU_MAX_UNIT_NUM_ID)
-#define UFS_UPIU_WLUN_ID	(1 << 7)
-#define UFS_UPIU_MAX_GENERAL_LUN	8
-
-/* Well known logical unit id in LUN field of UPIU */
-enum {
-	UFS_UPIU_REPORT_LUNS_WLUN	= 0x81,
-	UFS_UPIU_UFS_DEVICE_WLUN	= 0xD0,
-	UFS_UPIU_BOOT_WLUN		= 0xB0,
-	UFS_UPIU_RPMB_WLUN		= 0xC4,
-};
-
-/*
- * UFS Protocol Information Unit related definitions
- */
-
-/* Task management functions */
-enum {
-	UFS_ABORT_TASK		= 0x01,
-	UFS_ABORT_TASK_SET	= 0x02,
-	UFS_CLEAR_TASK_SET	= 0x04,
-	UFS_LOGICAL_RESET	= 0x08,
-	UFS_QUERY_TASK		= 0x80,
-	UFS_QUERY_TASK_SET	= 0x81,
-};
-
-/* UTP UPIU Transaction Codes Initiator to Target */
-enum {
-	UPIU_TRANSACTION_NOP_OUT	= 0x00,
-	UPIU_TRANSACTION_COMMAND	= 0x01,
-	UPIU_TRANSACTION_DATA_OUT	= 0x02,
-	UPIU_TRANSACTION_TASK_REQ	= 0x04,
-	UPIU_TRANSACTION_QUERY_REQ	= 0x16,
-};
-
-/* UTP UPIU Transaction Codes Target to Initiator */
-enum {
-	UPIU_TRANSACTION_NOP_IN		= 0x20,
-	UPIU_TRANSACTION_RESPONSE	= 0x21,
-	UPIU_TRANSACTION_DATA_IN	= 0x22,
-	UPIU_TRANSACTION_TASK_RSP	= 0x24,
-	UPIU_TRANSACTION_READY_XFER	= 0x31,
-	UPIU_TRANSACTION_QUERY_RSP	= 0x36,
-	UPIU_TRANSACTION_REJECT_UPIU	= 0x3F,
-};
-
-/* UPIU Read/Write flags */
-enum {
-	UPIU_CMD_FLAGS_NONE	= 0x00,
-	UPIU_CMD_FLAGS_WRITE	= 0x20,
-	UPIU_CMD_FLAGS_READ	= 0x40,
-};
-
-/* UPIU Task Attributes */
-enum {
-	UPIU_TASK_ATTR_SIMPLE	= 0x00,
-	UPIU_TASK_ATTR_ORDERED	= 0x01,
-	UPIU_TASK_ATTR_HEADQ	= 0x02,
-	UPIU_TASK_ATTR_ACA	= 0x03,
-};
-
-/* UPIU Query request function */
-enum {
-	UPIU_QUERY_FUNC_STANDARD_READ_REQUEST           = 0x01,
-	UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST          = 0x81,
-};
-
-/* Flag idn for Query Requests*/
-enum flag_idn {
-	QUERY_FLAG_IDN_FDEVICEINIT      = 0x01,
-	QUERY_FLAG_IDN_PWR_ON_WPE	= 0x03,
-	QUERY_FLAG_IDN_BKOPS_EN         = 0x04,
-};
-
-/* Attribute idn for Query requests */
-enum attr_idn {
-	QUERY_ATTR_IDN_ACTIVE_ICC_LVL	= 0x03,
-	QUERY_ATTR_IDN_BKOPS_STATUS	= 0x05,
-	QUERY_ATTR_IDN_EE_CONTROL	= 0x0D,
-	QUERY_ATTR_IDN_EE_STATUS	= 0x0E,
-};
-
-/* Descriptor idn for Query requests */
-enum desc_idn {
-	QUERY_DESC_IDN_DEVICE		= 0x0,
-	QUERY_DESC_IDN_CONFIGURAION	= 0x1,
-	QUERY_DESC_IDN_UNIT		= 0x2,
-	QUERY_DESC_IDN_RFU_0		= 0x3,
-	QUERY_DESC_IDN_INTERCONNECT	= 0x4,
-	QUERY_DESC_IDN_STRING		= 0x5,
-	QUERY_DESC_IDN_RFU_1		= 0x6,
-	QUERY_DESC_IDN_GEOMETRY		= 0x7,
-	QUERY_DESC_IDN_POWER		= 0x8,
-	QUERY_DESC_IDN_MAX,
-};
-
-enum desc_header_offset {
-	QUERY_DESC_LENGTH_OFFSET	= 0x00,
-	QUERY_DESC_DESC_TYPE_OFFSET	= 0x01,
-};
-
-enum ufs_desc_max_size {
-	QUERY_DESC_DEVICE_MAX_SIZE		= 0x1F,
-	QUERY_DESC_CONFIGURAION_MAX_SIZE	= 0x90,
-	QUERY_DESC_UNIT_MAX_SIZE		= 0x23,
-	QUERY_DESC_INTERCONNECT_MAX_SIZE	= 0x06,
-	/*
-	 * Max. 126 UNICODE characters (2 bytes per character) plus 2 bytes
-	 * of descriptor header.
-	 */
-	QUERY_DESC_STRING_MAX_SIZE		= 0xFE,
-	QUERY_DESC_GEOMETRY_MAZ_SIZE		= 0x44,
-	QUERY_DESC_POWER_MAX_SIZE		= 0x62,
-	QUERY_DESC_RFU_MAX_SIZE			= 0x00,
-};
-
-/* Unit descriptor parameters offsets in bytes*/
-enum unit_desc_param {
-	UNIT_DESC_PARAM_LEN			= 0x0,
-	UNIT_DESC_PARAM_TYPE			= 0x1,
-	UNIT_DESC_PARAM_UNIT_INDEX		= 0x2,
-	UNIT_DESC_PARAM_LU_ENABLE		= 0x3,
-	UNIT_DESC_PARAM_BOOT_LUN_ID		= 0x4,
-	UNIT_DESC_PARAM_LU_WR_PROTECT		= 0x5,
-	UNIT_DESC_PARAM_LU_Q_DEPTH		= 0x6,
-	UNIT_DESC_PARAM_MEM_TYPE		= 0x8,
-	UNIT_DESC_PARAM_DATA_RELIABILITY	= 0x9,
-	UNIT_DESC_PARAM_LOGICAL_BLK_SIZE	= 0xA,
-	UNIT_DESC_PARAM_LOGICAL_BLK_COUNT	= 0xB,
-	UNIT_DESC_PARAM_ERASE_BLK_SIZE		= 0x13,
-	UNIT_DESC_PARAM_PROVISIONING_TYPE	= 0x17,
-	UNIT_DESC_PARAM_PHY_MEM_RSRC_CNT	= 0x18,
-	UNIT_DESC_PARAM_CTX_CAPABILITIES	= 0x20,
-	UNIT_DESC_PARAM_LARGE_UNIT_SIZE_M1	= 0x22,
-};
-
-/*
- * Logical Unit Write Protect
- * 00h: LU not write protected
- * 01h: LU write protected when fPowerOnWPEn =1
- * 02h: LU permanently write protected when fPermanentWPEn =1
- */
-enum ufs_lu_wp_type {
-	UFS_LU_NO_WP		= 0x00,
-	UFS_LU_POWER_ON_WP	= 0x01,
-	UFS_LU_PERM_WP		= 0x02,
-};
-
-/* bActiveICCLevel parameter current units */
-enum {
-	UFSHCD_NANO_AMP		= 0,
-	UFSHCD_MICRO_AMP	= 1,
-	UFSHCD_MILI_AMP		= 2,
-	UFSHCD_AMP		= 3,
-};
-
-#define POWER_DESC_MAX_SIZE			0x62
-#define POWER_DESC_MAX_ACTV_ICC_LVLS		16
-
-/* Attribute  bActiveICCLevel parameter bit masks definitions */
-#define ATTR_ICC_LVL_UNIT_OFFSET	14
-#define ATTR_ICC_LVL_UNIT_MASK		(0x3 << ATTR_ICC_LVL_UNIT_OFFSET)
-#define ATTR_ICC_LVL_VALUE_MASK		0x3FF
-
-/* Power descriptor parameters offsets in bytes */
-enum power_desc_param_offset {
-	PWR_DESC_LEN			= 0x0,
-	PWR_DESC_TYPE			= 0x1,
-	PWR_DESC_ACTIVE_LVLS_VCC_0	= 0x2,
-	PWR_DESC_ACTIVE_LVLS_VCCQ_0	= 0x22,
-	PWR_DESC_ACTIVE_LVLS_VCCQ2_0	= 0x42,
-};
-
-/* Exception event mask values */
-enum {
-	MASK_EE_STATUS		= 0xFFFF,
-	MASK_EE_URGENT_BKOPS	= (1 << 2),
-};
-
-/* Background operation status */
-enum bkops_status {
-	BKOPS_STATUS_NO_OP               = 0x0,
-	BKOPS_STATUS_NON_CRITICAL        = 0x1,
-	BKOPS_STATUS_PERF_IMPACT         = 0x2,
-	BKOPS_STATUS_CRITICAL            = 0x3,
-	BKOPS_STATUS_MAX		 = BKOPS_STATUS_CRITICAL,
-};
-
-/* UTP QUERY Transaction Specific Fields OpCode */
-enum query_opcode {
-	UPIU_QUERY_OPCODE_NOP		= 0x0,
-	UPIU_QUERY_OPCODE_READ_DESC	= 0x1,
-	UPIU_QUERY_OPCODE_WRITE_DESC	= 0x2,
-	UPIU_QUERY_OPCODE_READ_ATTR	= 0x3,
-	UPIU_QUERY_OPCODE_WRITE_ATTR	= 0x4,
-	UPIU_QUERY_OPCODE_READ_FLAG	= 0x5,
-	UPIU_QUERY_OPCODE_SET_FLAG	= 0x6,
-	UPIU_QUERY_OPCODE_CLEAR_FLAG	= 0x7,
-	UPIU_QUERY_OPCODE_TOGGLE_FLAG	= 0x8,
-};
-
-/* Query response result code */
-enum {
-	QUERY_RESULT_SUCCESS                    = 0x00,
-	QUERY_RESULT_NOT_READABLE               = 0xF6,
-	QUERY_RESULT_NOT_WRITEABLE              = 0xF7,
-	QUERY_RESULT_ALREADY_WRITTEN            = 0xF8,
-	QUERY_RESULT_INVALID_LENGTH             = 0xF9,
-	QUERY_RESULT_INVALID_VALUE              = 0xFA,
-	QUERY_RESULT_INVALID_SELECTOR           = 0xFB,
-	QUERY_RESULT_INVALID_INDEX              = 0xFC,
-	QUERY_RESULT_INVALID_IDN                = 0xFD,
-	QUERY_RESULT_INVALID_OPCODE             = 0xFE,
-	QUERY_RESULT_GENERAL_FAILURE            = 0xFF,
-};
-
-/* UTP Transfer Request Command Type (CT) */
-enum {
-	UPIU_COMMAND_SET_TYPE_SCSI	= 0x0,
-	UPIU_COMMAND_SET_TYPE_UFS	= 0x1,
-	UPIU_COMMAND_SET_TYPE_QUERY	= 0x2,
-};
-
-/* UTP Transfer Request Command Offset */
-#define UPIU_COMMAND_TYPE_OFFSET	28
-
-/* Offset of the response code in the UPIU header */
-#define UPIU_RSP_CODE_OFFSET		8
-
-enum {
-	MASK_SCSI_STATUS		= 0xFF,
-	MASK_TASK_RESPONSE              = 0xFF00,
-	MASK_RSP_UPIU_RESULT            = 0xFFFF,
-	MASK_QUERY_DATA_SEG_LEN         = 0xFFFF,
-	MASK_RSP_UPIU_DATA_SEG_LEN	= 0xFFFF,
-	MASK_RSP_EXCEPTION_EVENT        = 0x10000,
-};
-
-/* Task management service response */
-enum {
-	UPIU_TASK_MANAGEMENT_FUNC_COMPL		= 0x00,
-	UPIU_TASK_MANAGEMENT_FUNC_NOT_SUPPORTED = 0x04,
-	UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED	= 0x08,
-	UPIU_TASK_MANAGEMENT_FUNC_FAILED	= 0x05,
-	UPIU_INCORRECT_LOGICAL_UNIT_NO		= 0x09,
-};
-
-/* UFS device power modes */
-enum ufs_dev_pwr_mode {
-	UFS_ACTIVE_PWR_MODE	= 1,
-	UFS_SLEEP_PWR_MODE	= 2,
-	UFS_POWERDOWN_PWR_MODE	= 3,
-};
-
-/**
- * struct utp_upiu_header - UPIU header structure
- * @dword_0: UPIU header DW-0
- * @dword_1: UPIU header DW-1
- * @dword_2: UPIU header DW-2
- */
-struct utp_upiu_header {
-	__be32 dword_0;
-	__be32 dword_1;
-	__be32 dword_2;
-};
-
-/**
- * struct utp_upiu_cmd - Command UPIU structure
- * @data_transfer_len: Data Transfer Length DW-3
- * @cdb: Command Descriptor Block CDB DW-4 to DW-7
- */
-struct utp_upiu_cmd {
-	__be32 exp_data_transfer_len;
-	u8 cdb[MAX_CDB_SIZE];
-};
-
-/**
- * struct utp_upiu_query - upiu request buffer structure for
- * query request.
- * @opcode: command to perform B-0
- * @idn: a value that indicates the particular type of data B-1
- * @index: Index to further identify data B-2
- * @selector: Index to further identify data B-3
- * @reserved_osf: spec reserved field B-4,5
- * @length: number of descriptor bytes to read/write B-6,7
- * @value: Attribute value to be written DW-5
- * @reserved: spec reserved DW-6,7
- */
-struct utp_upiu_query {
-	u8 opcode;
-	u8 idn;
-	u8 index;
-	u8 selector;
-	__be16 reserved_osf;
-	__be16 length;
-	__be32 value;
-	__be32 reserved[2];
-};
-
-/**
- * struct utp_upiu_req - general upiu request structure
- * @header:UPIU header structure DW-0 to DW-2
- * @sc: fields structure for scsi command DW-3 to DW-7
- * @qr: fields structure for query request DW-3 to DW-7
- */
-struct utp_upiu_req {
-	struct utp_upiu_header header;
-	union {
-		struct utp_upiu_cmd sc;
-		struct utp_upiu_query qr;
-	};
-};
-
-/**
- * struct utp_cmd_rsp - Response UPIU structure
- * @residual_transfer_count: Residual transfer count DW-3
- * @reserved: Reserved double words DW-4 to DW-7
- * @sense_data_len: Sense data length DW-8 U16
- * @sense_data: Sense data field DW-8 to DW-12
- */
-struct utp_cmd_rsp {
-	__be32 residual_transfer_count;
-	__be32 reserved[4];
-	__be16 sense_data_len;
-	u8 sense_data[18];
-};
-
-/**
- * struct utp_upiu_rsp - general upiu response structure
- * @header: UPIU header structure DW-0 to DW-2
- * @sr: fields structure for scsi command DW-3 to DW-12
- * @qr: fields structure for query request DW-3 to DW-7
- */
-struct utp_upiu_rsp {
-	struct utp_upiu_header header;
-	union {
-		struct utp_cmd_rsp sr;
-		struct utp_upiu_query qr;
-	};
-};
-
-/**
- * struct utp_upiu_task_req - Task request UPIU structure
- * @header - UPIU header structure DW0 to DW-2
- * @input_param1: Input parameter 1 DW-3
- * @input_param2: Input parameter 2 DW-4
- * @input_param3: Input parameter 3 DW-5
- * @reserved: Reserved double words DW-6 to DW-7
- */
-struct utp_upiu_task_req {
-	struct utp_upiu_header header;
-	__be32 input_param1;
-	__be32 input_param2;
-	__be32 input_param3;
-	__be32 reserved[2];
-};
-
-/**
- * struct utp_upiu_task_rsp - Task Management Response UPIU structure
- * @header: UPIU header structure DW0-DW-2
- * @output_param1: Ouput parameter 1 DW3
- * @output_param2: Output parameter 2 DW4
- * @reserved: Reserved double words DW-5 to DW-7
- */
-struct utp_upiu_task_rsp {
-	struct utp_upiu_header header;
-	__be32 output_param1;
-	__be32 output_param2;
-	__be32 reserved[3];
-};
-
-/**
- * struct ufs_query_req - parameters for building a query request
- * @query_func: UPIU header query function
- * @upiu_req: the query request data
- */
-struct ufs_query_req {
-	u8 query_func;
-	struct utp_upiu_query upiu_req;
-};
-
-/**
- * struct ufs_query_resp - UPIU QUERY
- * @response: device response code
- * @upiu_res: query response data
- */
-struct ufs_query_res {
-	u8 response;
-	struct utp_upiu_query upiu_res;
-};
-
-#define UFS_VREG_VCC_MIN_UV	   2700000 /* uV */
-#define UFS_VREG_VCC_MAX_UV	   3600000 /* uV */
-#define UFS_VREG_VCC_1P8_MIN_UV    1700000 /* uV */
-#define UFS_VREG_VCC_1P8_MAX_UV    1950000 /* uV */
-#define UFS_VREG_VCCQ_MIN_UV	   1100000 /* uV */
-#define UFS_VREG_VCCQ_MAX_UV	   1300000 /* uV */
-#define UFS_VREG_VCCQ2_MIN_UV	   1650000 /* uV */
-#define UFS_VREG_VCCQ2_MAX_UV	   1950000 /* uV */
-
-/*
- * VCCQ & VCCQ2 current requirement when UFS device is in sleep state
- * and link is in Hibern8 state.
- */
-#define UFS_VREG_LPM_LOAD_UA	1000 /* uA */
-
-struct ufs_vreg {
-	struct regulator *reg;
-	const char *name;
-	bool enabled;
-	int min_uV;
-	int max_uV;
-	int min_uA;
-	int max_uA;
-};
-
-struct ufs_vreg_info {
-	struct ufs_vreg *vcc;
-	struct ufs_vreg *vccq;
-	struct ufs_vreg *vccq2;
-	struct ufs_vreg *vdd_hba;
-};
-
-struct ufs_dev_info {
-	bool f_power_on_wp_en;
-	/* Keeps information if any of the LU is power on write protected */
-	bool is_lu_power_on_wp;
-};
-
-#endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 955ed55..2a18b8e 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -33,7 +33,7 @@
  * this program.
  */
 
-#include "ufshcd.h"
+#include <linux/scsi/ufs/ufshcd.h>
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c
b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 8adf067..d2b0ae6 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -37,7 +37,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 
-#include "ufshcd.h"
+#include <linux/scsi/ufs/ufshcd.h>
 
 static const struct of_device_id ufs_of_match[];
 static struct ufs_hba_variant_ops *get_variant_ops(struct device *dev)
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a0a6d1a..e03a114 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -40,8 +40,9 @@
 #include <linux/async.h>
 #include <linux/devfreq.h>
 
-#include "ufshcd.h"
-#include "unipro.h"
+#include <linux/scsi/ufs/ufshcd.h>
+#include <linux/scsi/ufs/unipro.h>
+#include "ufshci.h"
 
 #define UFSHCD_ENABLE_INTRS	(UTP_TRANSFER_REQ_COMPL |\
 				 UTP_TASK_REQ_COMPL |\
@@ -2490,6 +2491,15 @@ out:
 }
 
 /**
+ * ufshcd_hba_stop - Send controller to reset state
+ * @hba: per adapter instance
+ */
+static inline void ufshcd_hba_stop(struct ufs_hba *hba)
+{
+	ufshcd_writel(hba, CONTROLLER_DISABLE,  REG_CONTROLLER_ENABLE);
+}
+
+/**
  * ufshcd_hba_enable - initialize the controller
  * @hba: per adapter instance
  *
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
deleted file mode 100644
index d502d70..0000000
--- a/drivers/scsi/ufs/ufshcd.h
+++ /dev/null
@@ -1,595 +0,0 @@
-/*
- * Universal Flash Storage Host controller driver
- *
- * This code is based on drivers/scsi/ufs/ufshcd.h
- * Copyright (C) 2011-2013 Samsung India Software Operations
- *
- * Authors:
- *	Santosh Yaraganavi <santosh.sy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
- *	Vinayak Holikatti <h.vinayak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- * See the COPYING file in the top-level directory or visit
- * <http://www.gnu.org/licenses/gpl-2.0.html>
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * This program is provided "AS IS" and "WITH ALL FAULTS" and
- * without warranty of any kind. You are solely responsible for
- * determining the appropriateness of using and distributing
- * the program and assume all risks associated with your exercise
- * of rights with respect to the program, including but not limited
- * to infringement of third party rights, the risks and costs of
- * program errors, damage to or loss of data, programs or equipment,
- * and unavailability or interruption of operations. Under no
- * circumstances will the contributor of this Program be liable for
- * any damages of any kind arising from your use or distribution of
- * this program.
- */
-
-#ifndef _UFSHCD_H
-#define _UFSHCD_H
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/io.h>
-#include <linux/delay.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/workqueue.h>
-#include <linux/errno.h>
-#include <linux/types.h>
-#include <linux/wait.h>
-#include <linux/bitops.h>
-#include <linux/pm_runtime.h>
-#include <linux/clk.h>
-#include <linux/completion.h>
-#include <linux/regulator/consumer.h>
-
-#include <asm/irq.h>
-#include <asm/byteorder.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_tcq.h>
-#include <scsi/scsi_dbg.h>
-#include <scsi/scsi_eh.h>
-
-#include "ufs.h"
-#include "ufshci.h"
-
-#define UFSHCD "ufshcd"
-#define UFSHCD_DRIVER_VERSION "0.2"
-
-struct ufs_hba;
-
-enum dev_cmd_type {
-	DEV_CMD_TYPE_NOP		= 0x0,
-	DEV_CMD_TYPE_QUERY		= 0x1,
-};
-
-/**
- * struct uic_command - UIC command structure
- * @command: UIC command
- * @argument1: UIC command argument 1
- * @argument2: UIC command argument 2
- * @argument3: UIC command argument 3
- * @cmd_active: Indicate if UIC command is outstanding
- * @result: UIC command result
- * @done: UIC command completion
- */
-struct uic_command {
-	u32 command;
-	u32 argument1;
-	u32 argument2;
-	u32 argument3;
-	int cmd_active;
-	int result;
-	struct completion done;
-};
-
-/* Used to differentiate the power management options */
-enum ufs_pm_op {
-	UFS_RUNTIME_PM,
-	UFS_SYSTEM_PM,
-	UFS_SHUTDOWN_PM,
-};
-
-#define ufshcd_is_runtime_pm(op) ((op) == UFS_RUNTIME_PM)
-#define ufshcd_is_system_pm(op) ((op) == UFS_SYSTEM_PM)
-#define ufshcd_is_shutdown_pm(op) ((op) == UFS_SHUTDOWN_PM)
-
-/* Host <-> Device UniPro Link state */
-enum uic_link_state {
-	UIC_LINK_OFF_STATE	= 0, /* Link powered down or disabled */
-	UIC_LINK_ACTIVE_STATE	= 1, /* Link is in Fast/Slow/Sleep state */
-	UIC_LINK_HIBERN8_STATE	= 2, /* Link is in Hibernate state */
-};
-
-#define ufshcd_is_link_off(hba) ((hba)->uic_link_state ==
UIC_LINK_OFF_STATE)
-#define ufshcd_is_link_active(hba) ((hba)->uic_link_state == \
-				    UIC_LINK_ACTIVE_STATE)
-#define ufshcd_is_link_hibern8(hba) ((hba)->uic_link_state == \
-				    UIC_LINK_HIBERN8_STATE)
-#define ufshcd_set_link_off(hba) ((hba)->uic_link_state =
UIC_LINK_OFF_STATE)
-#define ufshcd_set_link_active(hba) ((hba)->uic_link_state = \
-				    UIC_LINK_ACTIVE_STATE)
-#define ufshcd_set_link_hibern8(hba) ((hba)->uic_link_state = \
-				    UIC_LINK_HIBERN8_STATE)
-
-/*
- * UFS Power management levels.
- * Each level is in increasing order of power savings.
- */
-enum ufs_pm_level {
-	UFS_PM_LVL_0, /* UFS_ACTIVE_PWR_MODE, UIC_LINK_ACTIVE_STATE */
-	UFS_PM_LVL_1, /* UFS_ACTIVE_PWR_MODE, UIC_LINK_HIBERN8_STATE */
-	UFS_PM_LVL_2, /* UFS_SLEEP_PWR_MODE, UIC_LINK_ACTIVE_STATE */
-	UFS_PM_LVL_3, /* UFS_SLEEP_PWR_MODE, UIC_LINK_HIBERN8_STATE */
-	UFS_PM_LVL_4, /* UFS_POWERDOWN_PWR_MODE, UIC_LINK_HIBERN8_STATE */
-	UFS_PM_LVL_5, /* UFS_POWERDOWN_PWR_MODE, UIC_LINK_OFF_STATE */
-	UFS_PM_LVL_MAX
-};
-
-struct ufs_pm_lvl_states {
-	enum ufs_dev_pwr_mode dev_state;
-	enum uic_link_state link_state;
-};
-
-/**
- * struct ufshcd_lrb - local reference block
- * @utr_descriptor_ptr: UTRD address of the command
- * @ucd_req_ptr: UCD address of the command
- * @ucd_rsp_ptr: Response UPIU address for this command
- * @ucd_prdt_ptr: PRDT address of the command
- * @cmd: pointer to SCSI command
- * @sense_buffer: pointer to sense buffer address of the SCSI command
- * @sense_bufflen: Length of the sense buffer
- * @scsi_status: SCSI status of the command
- * @command_type: SCSI, UFS, Query.
- * @task_tag: Task tag of the command
- * @lun: LUN of the command
- * @intr_cmd: Interrupt command (doesn't participate in interrupt
aggregation)
- */
-struct ufshcd_lrb {
-	struct utp_transfer_req_desc *utr_descriptor_ptr;
-	struct utp_upiu_req *ucd_req_ptr;
-	struct utp_upiu_rsp *ucd_rsp_ptr;
-	struct ufshcd_sg_entry *ucd_prdt_ptr;
-
-	struct scsi_cmnd *cmd;
-	u8 *sense_buffer;
-	unsigned int sense_bufflen;
-	int scsi_status;
-
-	int command_type;
-	int task_tag;
-	u8 lun; /* UPIU LUN id field is only 8-bit wide */
-	bool intr_cmd;
-};
-
-/**
- * struct ufs_query - holds relevent data structures for query request
- * @request: request upiu and function
- * @descriptor: buffer for sending/receiving descriptor
- * @response: response upiu and response
- */
-struct ufs_query {
-	struct ufs_query_req request;
-	u8 *descriptor;
-	struct ufs_query_res response;
-};
-
-/**
- * struct ufs_dev_cmd - all assosiated fields with device management
commands
- * @type: device management command type - Query, NOP OUT
- * @lock: lock to allow one command at a time
- * @complete: internal commands completion
- * @tag_wq: wait queue until free command slot is available
- */
-struct ufs_dev_cmd {
-	enum dev_cmd_type type;
-	struct mutex lock;
-	struct completion *complete;
-	wait_queue_head_t tag_wq;
-	struct ufs_query query;
-};
-
-/**
- * struct ufs_clk_info - UFS clock related info
- * @list: list headed by hba->clk_list_head
- * @clk: clock node
- * @name: clock name
- * @max_freq: maximum frequency supported by the clock
- * @min_freq: min frequency that can be used for clock scaling
- * @curr_freq: indicates the current frequency that it is set to
- * @enabled: variable to check against multiple enable/disable
- */
-struct ufs_clk_info {
-	struct list_head list;
-	struct clk *clk;
-	const char *name;
-	u32 max_freq;
-	u32 min_freq;
-	u32 curr_freq;
-	bool enabled;
-};
-
-#define PRE_CHANGE      0
-#define POST_CHANGE     1
-
-struct ufs_pa_layer_attr {
-	u32 gear_rx;
-	u32 gear_tx;
-	u32 lane_rx;
-	u32 lane_tx;
-	u32 pwr_rx;
-	u32 pwr_tx;
-	u32 hs_rate;
-};
-
-struct ufs_pwr_mode_info {
-	bool is_valid;
-	struct ufs_pa_layer_attr info;
-};
-
-/**
- * struct ufs_hba_variant_ops - variant specific callbacks
- * @name: variant name
- * @init: called when the driver is initialized
- * @exit: called to cleanup everything done in init
- * @clk_scale_notify: notifies that clks are scaled up/down
- * @setup_clocks: called before touching any of the controller registers
- * @setup_regulators: called before accessing the host controller
- * @hce_enable_notify: called before and after HCE enable bit is set to
allow
- *                     variant specific Uni-Pro initialization.
- * @link_startup_notify: called before and after Link startup is carried
out
- *                       to allow variant specific Uni-Pro initialization.
- * @pwr_change_notify: called before and after a power mode change
- *			is carried out to allow vendor spesific capabilities
- *			to be set.
- * @suspend: called during host controller PM callback
- * @resume: called during host controller PM callback
- */
-struct ufs_hba_variant_ops {
-	const char *name;
-	int	(*init)(struct ufs_hba *);
-	void    (*exit)(struct ufs_hba *);
-	void    (*clk_scale_notify)(struct ufs_hba *);
-	int     (*setup_clocks)(struct ufs_hba *, bool);
-	int     (*setup_regulators)(struct ufs_hba *, bool);
-	int     (*hce_enable_notify)(struct ufs_hba *, bool);
-	int     (*link_startup_notify)(struct ufs_hba *, bool);
-	int	(*pwr_change_notify)(struct ufs_hba *,
-					bool, struct ufs_pa_layer_attr *,
-					struct ufs_pa_layer_attr *);
-	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
-	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
-};
-
-/* clock gating state  */
-enum clk_gating_state {
-	CLKS_OFF,
-	CLKS_ON,
-	REQ_CLKS_OFF,
-	REQ_CLKS_ON,
-};
-
-/**
- * struct ufs_clk_gating - UFS clock gating related info
- * @gate_work: worker to turn off clocks after some delay as specified in
- * delay_ms
- * @ungate_work: worker to turn on clocks that will be used in case of
- * interrupt context
- * @state: the current clocks state
- * @delay_ms: gating delay in ms
- * @is_suspended: clk gating is suspended when set to 1 which can be used
- * during suspend/resume
- * @delay_attr: sysfs attribute to control delay_attr
- * @active_reqs: number of requests that are pending and should be waited
for
- * completion before gating clocks.
- */
-struct ufs_clk_gating {
-	struct delayed_work gate_work;
-	struct work_struct ungate_work;
-	enum clk_gating_state state;
-	unsigned long delay_ms;
-	bool is_suspended;
-	struct device_attribute delay_attr;
-	int active_reqs;
-};
-
-struct ufs_clk_scaling {
-	ktime_t  busy_start_t;
-	bool is_busy_started;
-	unsigned long  tot_busy_t;
-	unsigned long window_start_t;
-};
-
-/**
- * struct ufs_init_prefetch - contains data that is pre-fetched once during
- * initialization
- * @icc_level: icc level which was read during initialization
- */
-struct ufs_init_prefetch {
-	u32 icc_level;
-};
-
-/**
- * struct ufs_hba - per adapter private structure
- * @mmio_base: UFSHCI base register address
- * @ucdl_base_addr: UFS Command Descriptor base address
- * @utrdl_base_addr: UTP Transfer Request Descriptor base address
- * @utmrdl_base_addr: UTP Task Management Descriptor base address
- * @ucdl_dma_addr: UFS Command Descriptor DMA address
- * @utrdl_dma_addr: UTRDL DMA address
- * @utmrdl_dma_addr: UTMRDL DMA address
- * @host: Scsi_Host instance of the driver
- * @dev: device handle
- * @lrb: local reference block
- * @lrb_in_use: lrb in use
- * @outstanding_tasks: Bits representing outstanding task requests
- * @outstanding_reqs: Bits representing outstanding transfer requests
- * @capabilities: UFS Controller Capabilities
- * @nutrs: Transfer Request Queue depth supported by controller
- * @nutmrs: Task Management Queue depth supported by controller
- * @ufs_version: UFS Version to which controller complies
- * @vops: pointer to variant specific operations
- * @priv: pointer to variant specific private data
- * @irq: Irq number of the controller
- * @active_uic_cmd: handle of active UIC command
- * @uic_cmd_mutex: mutex for uic command
- * @tm_wq: wait queue for task management
- * @tm_tag_wq: wait queue for free task management slots
- * @tm_slots_in_use: bit map of task management request slots in use
- * @pwr_done: completion for power mode change
- * @tm_condition: condition variable for task management
- * @ufshcd_state: UFSHCD states
- * @eh_flags: Error handling flags
- * @intr_mask: Interrupt Mask Bits
- * @ee_ctrl_mask: Exception event control mask
- * @is_powered: flag to check if HBA is powered
- * @is_init_prefetch: flag to check if data was pre-fetched in
initialization
- * @init_prefetch_data: data pre-fetched during initialization
- * @eh_work: Worker to handle UFS errors that require s/w attention
- * @eeh_work: Worker to handle exception events
- * @errors: HBA errors
- * @uic_error: UFS interconnect layer error status
- * @saved_err: sticky error mask
- * @saved_uic_err: sticky UIC error mask
- * @dev_cmd: ufs device management command information
- * @auto_bkops_enabled: to track whether bkops is enabled in device
- * @vreg_info: UFS device voltage regulator information
- * @clk_list_head: UFS host controller clocks list node head
- * @pwr_info: holds current power mode
- * @max_pwr_info: keeps the device max valid pwm
- */
-struct ufs_hba {
-	void __iomem *mmio_base;
-
-	/* Virtual memory reference */
-	struct utp_transfer_cmd_desc *ucdl_base_addr;
-	struct utp_transfer_req_desc *utrdl_base_addr;
-	struct utp_task_req_desc *utmrdl_base_addr;
-
-	/* DMA memory reference */
-	dma_addr_t ucdl_dma_addr;
-	dma_addr_t utrdl_dma_addr;
-	dma_addr_t utmrdl_dma_addr;
-
-	struct Scsi_Host *host;
-	struct device *dev;
-	/*
-	 * This field is to keep a reference to "scsi_device" corresponding
to
-	 * "UFS device" W-LU.
-	 */
-	struct scsi_device *sdev_ufs_device;
-	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
-	enum uic_link_state uic_link_state;
-	/* Desired UFS power management level during runtime PM */
-	enum ufs_pm_level rpm_lvl;
-	/* Desired UFS power management level during system PM */
-	enum ufs_pm_level spm_lvl;
-	int pm_op_in_progress;
-
-	struct ufshcd_lrb *lrb;
-	unsigned long lrb_in_use;
-
-	unsigned long outstanding_tasks;
-	unsigned long outstanding_reqs;
-
-	u32 capabilities;
-	int nutrs;
-	int nutmrs;
-	u32 ufs_version;
-	struct ufs_hba_variant_ops *vops;
-	void *priv;
-	unsigned int irq;
-	bool is_irq_enabled;
-
-
-	wait_queue_head_t tm_wq;
-	wait_queue_head_t tm_tag_wq;
-	unsigned long tm_condition;
-	unsigned long tm_slots_in_use;
-
-	struct uic_command *active_uic_cmd;
-	struct mutex uic_cmd_mutex;
-	struct completion *uic_async_done;
-
-	u32 ufshcd_state;
-	u32 eh_flags;
-	u32 intr_mask;
-	u16 ee_ctrl_mask;
-	bool is_powered;
-	bool is_init_prefetch;
-	struct ufs_init_prefetch init_prefetch_data;
-
-	/* Work Queues */
-	struct work_struct eh_work;
-	struct work_struct eeh_work;
-
-	/* HBA Errors */
-	u32 errors;
-	u32 uic_error;
-	u32 saved_err;
-	u32 saved_uic_err;
-
-	/* Device management request data */
-	struct ufs_dev_cmd dev_cmd;
-
-	/* Keeps information of the UFS device connected to this host */
-	struct ufs_dev_info dev_info;
-	bool auto_bkops_enabled;
-	struct ufs_vreg_info vreg_info;
-	struct list_head clk_list_head;
-
-	bool wlun_dev_clr_ua;
-
-	struct ufs_pa_layer_attr pwr_info;
-	struct ufs_pwr_mode_info max_pwr_info;
-
-	struct ufs_clk_gating clk_gating;
-	/* Control to enable/disable host capabilities */
-	u32 caps;
-	/* Allow dynamic clk gating */
-#define UFSHCD_CAP_CLK_GATING	(1 << 0)
-	/* Allow hiberb8 with clk gating */
-#define UFSHCD_CAP_HIBERN8_WITH_CLK_GATING (1 << 1)
-	/* Allow dynamic clk scaling */
-#define UFSHCD_CAP_CLK_SCALING	(1 << 2)
-	/* Allow auto bkops to enabled during runtime suspend */
-#define UFSHCD_CAP_AUTO_BKOPS_SUSPEND (1 << 3)
-
-	struct devfreq *devfreq;
-	struct ufs_clk_scaling clk_scaling;
-	bool is_sys_suspended;
-};
-
-/* Returns true if clocks can be gated. Otherwise false */
-static inline bool ufshcd_is_clkgating_allowed(struct ufs_hba *hba)
-{
-	return hba->caps & UFSHCD_CAP_CLK_GATING;
-}
-static inline bool ufshcd_can_hibern8_during_gating(struct ufs_hba *hba)
-{
-	return hba->caps & UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
-}
-static inline int ufshcd_is_clkscaling_enabled(struct ufs_hba *hba)
-{
-	return hba->caps & UFSHCD_CAP_CLK_SCALING;
-}
-static inline bool ufshcd_can_autobkops_during_suspend(struct ufs_hba *hba)
-{
-	return hba->caps & UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
-}
-
-#define ufshcd_writel(hba, val, reg)	\
-	writel((val), (hba)->mmio_base + (reg))
-#define ufshcd_readl(hba, reg)	\
-	readl((hba)->mmio_base + (reg))
-
-/**
- * ufshcd_rmwl - read modify write into a register
- * @hba - per adapter instance
- * @mask - mask to apply on read value
- * @val - actual value to write
- * @reg - register address
- */
-static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32
reg)
-{
-	u32 tmp;
-
-	tmp = ufshcd_readl(hba, reg);
-	tmp &= ~mask;
-	tmp |= (val & mask);
-	ufshcd_writel(hba, tmp, reg);
-}
-
-int ufshcd_alloc_host(struct device *, struct ufs_hba **);
-int ufshcd_init(struct ufs_hba * , void __iomem * , unsigned int);
-void ufshcd_remove(struct ufs_hba *);
-
-/**
- * ufshcd_hba_stop - Send controller to reset state
- * @hba: per adapter instance
- */
-static inline void ufshcd_hba_stop(struct ufs_hba *hba)
-{
-	ufshcd_writel(hba, CONTROLLER_DISABLE,  REG_CONTROLLER_ENABLE);
-}
-
-static inline void check_upiu_size(void)
-{
-	BUILD_BUG_ON(ALIGNED_UPIU_SIZE <
-		GENERAL_UPIU_REQUEST_SIZE + QUERY_DESC_MAX_SIZE);
-}
-
-extern int ufshcd_runtime_suspend(struct ufs_hba *hba);
-extern int ufshcd_runtime_resume(struct ufs_hba *hba);
-extern int ufshcd_runtime_idle(struct ufs_hba *hba);
-extern int ufshcd_system_suspend(struct ufs_hba *hba);
-extern int ufshcd_system_resume(struct ufs_hba *hba);
-extern int ufshcd_shutdown(struct ufs_hba *hba);
-extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
-			       u8 attr_set, u32 mib_val, u8 peer);
-extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
-			       u32 *mib_val, u8 peer);
-
-/* UIC command interfaces for DME primitives */
-#define DME_LOCAL	0
-#define DME_PEER	1
-#define ATTR_SET_NOR	0	/* NORMAL */
-#define ATTR_SET_ST	1	/* STATIC */
-
-static inline int ufshcd_dme_set(struct ufs_hba *hba, u32 attr_sel,
-				 u32 mib_val)
-{
-	return ufshcd_dme_set_attr(hba, attr_sel, ATTR_SET_NOR,
-				   mib_val, DME_LOCAL);
-}
-
-static inline int ufshcd_dme_st_set(struct ufs_hba *hba, u32 attr_sel,
-				    u32 mib_val)
-{
-	return ufshcd_dme_set_attr(hba, attr_sel, ATTR_SET_ST,
-				   mib_val, DME_LOCAL);
-}
-
-static inline int ufshcd_dme_peer_set(struct ufs_hba *hba, u32 attr_sel,
-				      u32 mib_val)
-{
-	return ufshcd_dme_set_attr(hba, attr_sel, ATTR_SET_NOR,
-				   mib_val, DME_PEER);
-}
-
-static inline int ufshcd_dme_peer_st_set(struct ufs_hba *hba, u32 attr_sel,
-					 u32 mib_val)
-{
-	return ufshcd_dme_set_attr(hba, attr_sel, ATTR_SET_ST,
-				   mib_val, DME_PEER);
-}
-
-static inline int ufshcd_dme_get(struct ufs_hba *hba,
-				 u32 attr_sel, u32 *mib_val)
-{
-	return ufshcd_dme_get_attr(hba, attr_sel, mib_val, DME_LOCAL);
-}
-
-static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
-				      u32 attr_sel, u32 *mib_val)
-{
-	return ufshcd_dme_get_attr(hba, attr_sel, mib_val, DME_PEER);
-}
-
-int ufshcd_hold(struct ufs_hba *hba, bool async);
-void ufshcd_release(struct ufs_hba *hba);
-#endif /* End of Header */
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
deleted file mode 100644
index 3fc3e21..0000000
--- a/drivers/scsi/ufs/unipro.h
+++ /dev/null
@@ -1,207 +0,0 @@
-/*
- * drivers/scsi/ufs/unipro.h
- *
- * Copyright (C) 2013 Samsung Electronics Co., Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef _UNIPRO_H_
-#define _UNIPRO_H_
-
-/*
- * M-TX Configuration Attributes
- */
-#define TX_MODE					0x0021
-#define TX_HSRATE_SERIES			0x0022
-#define TX_HSGEAR				0x0023
-#define TX_PWMGEAR				0x0024
-#define TX_AMPLITUDE				0x0025
-#define TX_HS_SLEWRATE				0x0026
-#define TX_SYNC_SOURCE				0x0027
-#define TX_HS_SYNC_LENGTH			0x0028
-#define TX_HS_PREPARE_LENGTH			0x0029
-#define TX_LS_PREPARE_LENGTH			0x002A
-#define TX_HIBERN8_CONTROL			0x002B
-#define TX_LCC_ENABLE				0x002C
-#define TX_PWM_BURST_CLOSURE_EXTENSION		0x002D
-#define TX_BYPASS_8B10B_ENABLE			0x002E
-#define TX_DRIVER_POLARITY			0x002F
-#define TX_HS_UNTERMINATED_LINE_DRIVE_ENABLE	0x0030
-#define TX_LS_TERMINATED_LINE_DRIVE_ENABLE	0x0031
-#define TX_LCC_SEQUENCER			0x0032
-#define TX_MIN_ACTIVATETIME			0x0033
-#define TX_PWM_G6_G7_SYNC_LENGTH		0x0034
-
-/*
- * M-RX Configuration Attributes
- */
-#define RX_MODE					0x00A1
-#define RX_HSRATE_SERIES			0x00A2
-#define RX_HSGEAR				0x00A3
-#define RX_PWMGEAR				0x00A4
-#define RX_LS_TERMINATED_ENABLE			0x00A5
-#define RX_HS_UNTERMINATED_ENABLE		0x00A6
-#define RX_ENTER_HIBERN8			0x00A7
-#define RX_BYPASS_8B10B_ENABLE			0x00A8
-#define RX_TERMINATION_FORCE_ENABLE		0x0089
-
-#define is_mphy_tx_attr(attr)			(attr < RX_MODE)
-/*
- * PHY Adpater attributes
- */
-#define PA_ACTIVETXDATALANES	0x1560
-#define PA_ACTIVERXDATALANES	0x1580
-#define PA_TXTRAILINGCLOCKS	0x1564
-#define PA_PHY_TYPE		0x1500
-#define PA_AVAILTXDATALANES	0x1520
-#define PA_AVAILRXDATALANES	0x1540
-#define PA_MINRXTRAILINGCLOCKS	0x1543
-#define PA_TXPWRSTATUS		0x1567
-#define PA_RXPWRSTATUS		0x1582
-#define PA_TXFORCECLOCK		0x1562
-#define PA_TXPWRMODE		0x1563
-#define PA_LEGACYDPHYESCDL	0x1570
-#define PA_MAXTXSPEEDFAST	0x1521
-#define PA_MAXTXSPEEDSLOW	0x1522
-#define PA_MAXRXSPEEDFAST	0x1541
-#define PA_MAXRXSPEEDSLOW	0x1542
-#define PA_TXLINKSTARTUPHS	0x1544
-#define PA_TXSPEEDFAST		0x1565
-#define PA_TXSPEEDSLOW		0x1566
-#define PA_REMOTEVERINFO	0x15A0
-#define PA_TXGEAR		0x1568
-#define PA_TXTERMINATION	0x1569
-#define PA_HSSERIES		0x156A
-#define PA_PWRMODE		0x1571
-#define PA_RXGEAR		0x1583
-#define PA_RXTERMINATION	0x1584
-#define PA_MAXRXPWMGEAR		0x1586
-#define PA_MAXRXHSGEAR		0x1587
-#define PA_RXHSUNTERMCAP	0x15A5
-#define PA_RXLSTERMCAP		0x15A6
-#define PA_PACPREQTIMEOUT	0x1590
-#define PA_PACPREQEOBTIMEOUT	0x1591
-#define PA_HIBERN8TIME		0x15A7
-#define PA_LOCALVERINFO		0x15A9
-#define PA_TACTIVATE		0x15A8
-#define PA_PACPFRAMECOUNT	0x15C0
-#define PA_PACPERRORCOUNT	0x15C1
-#define PA_PHYTESTCONTROL	0x15C2
-#define PA_PWRMODEUSERDATA0	0x15B0
-#define PA_PWRMODEUSERDATA1	0x15B1
-#define PA_PWRMODEUSERDATA2	0x15B2
-#define PA_PWRMODEUSERDATA3	0x15B3
-#define PA_PWRMODEUSERDATA4	0x15B4
-#define PA_PWRMODEUSERDATA5	0x15B5
-#define PA_PWRMODEUSERDATA6	0x15B6
-#define PA_PWRMODEUSERDATA7	0x15B7
-#define PA_PWRMODEUSERDATA8	0x15B8
-#define PA_PWRMODEUSERDATA9	0x15B9
-#define PA_PWRMODEUSERDATA10	0x15BA
-#define PA_PWRMODEUSERDATA11	0x15BB
-#define PA_CONNECTEDTXDATALANES	0x1561
-#define PA_CONNECTEDRXDATALANES	0x1581
-#define PA_LOGICALLANEMAP	0x15A1
-#define PA_SLEEPNOCONFIGTIME	0x15A2
-#define PA_STALLNOCONFIGTIME	0x15A3
-#define PA_SAVECONFIGTIME	0x15A4
-
-/* PA power modes */
-enum {
-	FAST_MODE	= 1,
-	SLOW_MODE	= 2,
-	FASTAUTO_MODE	= 4,
-	SLOWAUTO_MODE	= 5,
-	UNCHANGED	= 7,
-};
-
-/* PA TX/RX Frequency Series */
-enum {
-	PA_HS_MODE_A	= 1,
-	PA_HS_MODE_B	= 2,
-};
-
-enum ufs_pwm_gear_tag {
-	UFS_PWM_DONT_CHANGE,	/* Don't change Gear */
-	UFS_PWM_G1,		/* PWM Gear 1 (default for reset) */
-	UFS_PWM_G2,		/* PWM Gear 2 */
-	UFS_PWM_G3,		/* PWM Gear 3 */
-	UFS_PWM_G4,		/* PWM Gear 4 */
-	UFS_PWM_G5,		/* PWM Gear 5 */
-	UFS_PWM_G6,		/* PWM Gear 6 */
-	UFS_PWM_G7,		/* PWM Gear 7 */
-};
-
-enum ufs_hs_gear_tag {
-	UFS_HS_DONT_CHANGE,	/* Don't change Gear */
-	UFS_HS_G1,		/* HS Gear 1 (default for reset) */
-	UFS_HS_G2,		/* HS Gear 2 */
-	UFS_HS_G3,		/* HS Gear 3 */
-};
-
-/*
- * Data Link Layer Attributes
- */
-#define DL_TC0TXFCTHRESHOLD	0x2040
-#define DL_FC0PROTTIMEOUTVAL	0x2041
-#define DL_TC0REPLAYTIMEOUTVAL	0x2042
-#define DL_AFC0REQTIMEOUTVAL	0x2043
-#define DL_AFC0CREDITTHRESHOLD	0x2044
-#define DL_TC0OUTACKTHRESHOLD	0x2045
-#define DL_TC1TXFCTHRESHOLD	0x2060
-#define DL_FC1PROTTIMEOUTVAL	0x2061
-#define DL_TC1REPLAYTIMEOUTVAL	0x2062
-#define DL_AFC1REQTIMEOUTVAL	0x2063
-#define DL_AFC1CREDITTHRESHOLD	0x2064
-#define DL_TC1OUTACKTHRESHOLD	0x2065
-#define DL_TXPREEMPTIONCAP	0x2000
-#define DL_TC0TXMAXSDUSIZE	0x2001
-#define DL_TC0RXINITCREDITVAL	0x2002
-#define DL_TC0TXBUFFERSIZE	0x2005
-#define DL_PEERTC0PRESENT	0x2046
-#define DL_PEERTC0RXINITCREVAL	0x2047
-#define DL_TC1TXMAXSDUSIZE	0x2003
-#define DL_TC1RXINITCREDITVAL	0x2004
-#define DL_TC1TXBUFFERSIZE	0x2006
-#define DL_PEERTC1PRESENT	0x2066
-#define DL_PEERTC1RXINITCREVAL	0x2067
-
-/*
- * Network Layer Attributes
- */
-#define N_DEVICEID		0x3000
-#define N_DEVICEID_VALID	0x3001
-#define N_TC0TXMAXSDUSIZE	0x3020
-#define N_TC1TXMAXSDUSIZE	0x3021
-
-/*
- * Transport Layer Attributes
- */
-#define T_NUMCPORTS		0x4000
-#define T_NUMTESTFEATURES	0x4001
-#define T_CONNECTIONSTATE	0x4020
-#define T_PEERDEVICEID		0x4021
-#define T_PEERCPORTID		0x4022
-#define T_TRAFFICCLASS		0x4023
-#define T_PROTOCOLID		0x4024
-#define T_CPORTFLAGS		0x4025
-#define T_TXTOKENVALUE		0x4026
-#define T_RXTOKENVALUE		0x4027
-#define T_LOCALBUFFERSPACE	0x4028
-#define T_PEERBUFFERSPACE	0x4029
-#define T_CREDITSTOSEND		0x402A
-#define T_CPORTMODE		0x402B
-#define T_TC0TXMAXSDUSIZE	0x4060
-#define T_TC1TXMAXSDUSIZE	0x4061
-
-/* Boolean attribute values */
-enum {
-	FALSE = 0,
-	TRUE,
-};
-
-#endif /* _UNIPRO_H_ */
diff --git a/include/linux/phy/phy-qcom-ufs.h
b/include/linux/phy/phy-qcom-ufs.h
new file mode 100644
index 0000000..f8eeb4c
--- /dev/null
+++ b/include/linux/phy/phy-qcom-ufs.h
@@ -0,0 +1,202 @@
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
+#ifndef UFS_QCOM_PHY_H_
+#define UFS_QCOM_PHY_H_
+
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/time.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/phy/phy.h>
+
+#include <linux/scsi/ufs/ufshcd.h>
+#include <linux/scsi/ufs/unipro.h>
+#include <linux/scsi/ufs/ufs-qcom.h>
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
+struct ufs_qcom_phy {
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
+	struct ufs_qcom_phy_vreg vdda_pll;
+	struct ufs_qcom_phy_vreg vdda_phy;
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
+	#define UFS_QCOM_PHY_QUIRK_CFG_RESTORE		(1 << 0)
+
+	/*
+	* If UFS PHY power down is deasserted and power is restored to
analog
+	* circuits, the rx_sigdet can glitch. If the glitch is wide enough,
+	* it can trigger the digital logic to think it saw a DIF-N and cause
+	* it to exit Hibern8. Disabling the rx_sigdet during power-up masks
+	* the glitch.
+	*/
+	#define UFS_QCOM_PHY_DIS_SIGDET_BEFORE_PWR_COLLAPSE	(1 << 1)
+
+	/*
+	* If UFS link is put into Hibern8 and if UFS PHY analog hardware is
+	* power collapsed (by clearing UFS_PHY_POWER_DOWN_CONTROL), Hibern8
+	* exit might fail even after powering on UFS PHY analog hardware.
+	* Enabling this quirk will help to solve above issue by doing
+	* custom PHY settings just before PHY analog power collapse.
+	*/
+	#define UFS_QCOM_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE	(1
<< 2)
+
+	char name[UFS_QCOM_PHY_NAME_LEN];
+	struct ufs_qcom_phy_calibration *cached_regs;
+	int cached_regs_table_size;
+	bool is_powered_on;
+	struct ufs_qcom_phy_specific_ops *phy_spec_ops;
+};
+
+/**
+ * struct ufs_qcom_phy_specific_ops - set of pointers to functions which
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
+struct ufs_qcom_phy_specific_ops {
+	int (*calibrate_phy)(struct ufs_qcom_phy *phy);
+	void (*start_serdes)(struct ufs_qcom_phy *phy);
+	void (*save_configuration)(struct ufs_qcom_phy *phy);
+	void (*restore_configuration)(struct ufs_qcom_phy *phy);
+	int (*is_physical_coding_sublayer_ready)(struct ufs_qcom_phy *phy);
+	void (*set_tx_lane_enable)(struct ufs_qcom_phy *phy, u32 val);
+	void (*power_control)(struct ufs_qcom_phy *phy, bool val);
+};
+
+int ufs_qcom_phy_init_vreg(struct phy *phy,
+			struct ufs_qcom_phy_vreg *vreg, const char *name);
+int ufs_qcom_phy_cfg_vreg(struct phy *phy,
+			struct ufs_qcom_phy_vreg *vreg, bool on);
+int ufs_qcom_phy_enable_vreg(struct phy *phy,
+			struct ufs_qcom_phy_vreg *vreg);
+int ufs_qcom_phy_disable_vreg(struct phy *phy,
+			struct ufs_qcom_phy_vreg *vreg);
+int ufs_qcom_phy_enable_ref_clk(struct phy *phy);
+void ufs_qcom_phy_disable_ref_clk(struct phy *phy);
+int ufs_qcom_phy_enable_iface_clk(struct phy *phy);
+void ufs_qcom_phy_disable_iface_clk(struct phy *phy);
+void ufs_qcom_phy_restore_swi_regs(struct phy *phy);
+int ufs_qcom_phy_link_startup_post_change(struct phy *phy,
+			struct ufs_hba *hba);
+int ufs_qcom_phy_base_init(struct platform_device *pdev,
+			struct ufs_qcom_phy *ufs_qcom_phy_ops);
+int ufs_qcom_phy_is_cfg_restore_quirk_enabled(struct phy *phy);
+struct ufs_qcom_phy *get_ufs_qcom_phy(struct phy *generic_phy);
+int ufs_qcom_phy_start_serdes(struct phy *generic_phy);
+int ufs_qcom_phy_set_tx_lane_enable(struct phy *generic_phy, u32 tx_lanes);
+int ufs_qcom_phy_calibrate_phy(struct phy *generic_phy);
+int ufs_qcom_phy_is_pcs_ready(struct phy *generic_phy);
+int ufs_qcom_phy_save_configuration(struct phy *generic_phy);
+int ufs_qcom_phy_restore_configuration(struct phy *generic_phy);
+void ufs_qcom_phy_save_controller_version(struct phy *generic_phy,
+			u8 major, u16 minor, u16 step);
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
+			struct ufs_qcom_phy_calibration *tbl_A, int
tbl_size_A,
+			struct ufs_qcom_phy_calibration *tbl_B, int
tbl_size_B,
+			int rate);
+#endif
diff --git a/include/linux/scsi/ufs/ufs-qcom.h
b/include/linux/scsi/ufs/ufs-qcom.h
new file mode 100644
index 0000000..d32a3af
--- /dev/null
+++ b/include/linux/scsi/ufs/ufs-qcom.h
@@ -0,0 +1,156 @@
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
+#ifndef UFS_QCOM_H_
+#define UFS_QCOM_H_
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
+#define UFS_QCOM_LIMIT_NUM_LANES_RX	2
+#define UFS_QCOM_LIMIT_NUM_LANES_TX	2
+#define UFS_QCOM_LIMIT_HSGEAR_RX	UFS_HS_G2
+#define UFS_QCOM_LIMIT_HSGEAR_TX	UFS_HS_G2
+#define UFS_QCOM_LIMIT_PWMGEAR_RX	UFS_PWM_G4
+#define UFS_QCOM_LIMIT_PWMGEAR_TX	UFS_PWM_G4
+#define UFS_QCOM_LIMIT_RX_PWR_PWM	SLOW_MODE
+#define UFS_QCOM_LIMIT_TX_PWR_PWM	SLOW_MODE
+#define UFS_QCOM_LIMIT_RX_PWR_HS	FAST_MODE
+#define UFS_QCOM_LIMIT_TX_PWR_HS	FAST_MODE
+#define UFS_QCOM_LIMIT_HS_RATE		PA_HS_MODE_B
+#define UFS_QCOM_LIMIT_DESIRED_MODE	FAST
+
+/* QCOM UFS host controller vendor specific registers */
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
+enum ufs_qcom_phy_init_type {
+	UFS_PHY_INIT_FULL,
+	UFS_PHY_INIT_CFG_RESTORE,
+};
+
+struct ufs_qcom_phy_vreg {
+	const char *name;
+	struct regulator *reg;
+	int max_uA;
+	int min_uV;
+	int max_uV;
+	bool enabled;
+};
+
+static inline void
+ufs_qcom_get_controller_revision(struct ufs_hba *hba,
+				 u8 *major, u16 *minor, u16 *step)
+{
+	u32 ver = ufshcd_readl(hba, REG_UFS_HW_VERSION);
+
+	*major = (ver & UFS_HW_VER_MAJOR_MASK) >> UFS_HW_VER_MAJOR_SHFT;
+	*minor = (ver & UFS_HW_VER_MINOR_MASK) >> UFS_HW_VER_MINOR_SHFT;
+	*step = (ver & UFS_HW_VER_STEP_MASK) >> UFS_HW_VER_STEP_SHFT;
+};
+
+static inline void ufs_qcom_assert_reset(struct ufs_hba *hba)
+{
+	ufshcd_rmwl(hba, MASK_UFS_PHY_SOFT_RESET,
+			1 << OFFSET_UFS_PHY_SOFT_RESET, REG_UFS_CFG1);
+	/*
+	 * ensure that controller writes MASK_UFS_PHY_SOFT_RESET
+	 * before it continues
+	 */
+	mb();
+}
+
+static inline void ufs_qcom_deassert_reset(struct ufs_hba *hba)
+{
+	ufshcd_rmwl(hba, MASK_UFS_PHY_SOFT_RESET,
+			0 << OFFSET_UFS_PHY_SOFT_RESET, REG_UFS_CFG1);
+	/*
+	 * ensure that controller writes MASK_UFS_PHY_SOFT_RESET
+	 * before it continues
+	 */
+	mb();
+}
+
+struct ufs_qcom_bus_vote {
+	uint32_t client_handle;
+	uint32_t curr_vote;
+	int min_bw_vote;
+	int max_bw_vote;
+	int saved_vote;
+	bool is_max_bw_needed;
+	struct device_attribute max_bus_bw;
+};
+
+struct ufs_qcom_host {
+	struct phy *generic_phy;
+	struct ufs_hba *hba;
+	struct ufs_qcom_bus_vote bus_vote;
+	struct ufs_pa_layer_attr dev_req_params;
+	struct clk *rx_l0_sync_clk;
+	struct clk *tx_l0_sync_clk;
+	struct clk *rx_l1_sync_clk;
+	struct clk *tx_l1_sync_clk;
+	bool is_lane_clks_enabled;
+	bool sec_cfg_updated;
+};
+
+#define ufs_qcom_is_link_off(hba) ufshcd_is_link_off(hba)
+#define ufs_qcom_is_link_active(hba) ufshcd_is_link_active(hba)
+#define ufs_qcom_is_link_hibern8(hba) ufshcd_is_link_hibern8(hba)
+
+#define MAX_PROP_NAME              32
+#define VDDA_PHY_MIN_UV            1000000
+#define VDDA_PHY_MAX_UV            1000000
+#define VDDA_PLL_MIN_UV            1800000
+#define VDDA_PLL_MAX_UV            1800000
+
+#endif /* UFS_QCOM_H_ */
diff --git a/include/linux/scsi/ufs/ufs.h b/include/linux/scsi/ufs/ufs.h
new file mode 100644
index 0000000..42c459a
--- /dev/null
+++ b/include/linux/scsi/ufs/ufs.h
@@ -0,0 +1,491 @@
+/*
+ * Universal Flash Storage Host controller driver
+ *
+ * This code is based on drivers/scsi/ufs/ufs.h
+ * Copyright (C) 2011-2013 Samsung India Software Operations
+ *
+ * Authors:
+ *	Santosh Yaraganavi <santosh.sy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
+ *	Vinayak Holikatti <h.vinayak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * See the COPYING file in the top-level directory or visit
+ * <http://www.gnu.org/licenses/gpl-2.0.html>
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * This program is provided "AS IS" and "WITH ALL FAULTS" and
+ * without warranty of any kind. You are solely responsible for
+ * determining the appropriateness of using and distributing
+ * the program and assume all risks associated with your exercise
+ * of rights with respect to the program, including but not limited
+ * to infringement of third party rights, the risks and costs of
+ * program errors, damage to or loss of data, programs or equipment,
+ * and unavailability or interruption of operations. Under no
+ * circumstances will the contributor of this Program be liable for
+ * any damages of any kind arising from your use or distribution of
+ * this program.
+ */
+
+#ifndef _UFS_H
+#define _UFS_H
+
+#include <linux/mutex.h>
+#include <linux/types.h>
+
+#define MAX_CDB_SIZE	16
+#define GENERAL_UPIU_REQUEST_SIZE 32
+#define QUERY_DESC_MAX_SIZE       255
+#define QUERY_DESC_MIN_SIZE       2
+#define QUERY_OSF_SIZE            (GENERAL_UPIU_REQUEST_SIZE - \
+					(sizeof(struct utp_upiu_header)))
+
+#define UPIU_HEADER_DWORD(byte3, byte2, byte1, byte0)\
+			cpu_to_be32((byte3 << 24) | (byte2 << 16) |\
+			 (byte1 << 8) | (byte0))
+/*
+ * UFS device may have standard LUs and LUN id could be from 0x00 to
+ * 0x7F. Standard LUs use "Peripheral Device Addressing Format".
+ * UFS device may also have the Well Known LUs (also referred as W-LU)
+ * which again could be from 0x00 to 0x7F. For W-LUs, device only use
+ * the "Extended Addressing Format" which means the W-LUNs would be
+ * from 0xc100 (SCSI_W_LUN_BASE) onwards.
+ * This means max. LUN number reported from UFS device could be 0xC17F.
+ */
+#define UFS_UPIU_MAX_UNIT_NUM_ID	0x7F
+#define UFS_MAX_LUNS		(SCSI_W_LUN_BASE + UFS_UPIU_MAX_UNIT_NUM_ID)
+#define UFS_UPIU_WLUN_ID	(1 << 7)
+#define UFS_UPIU_MAX_GENERAL_LUN	8
+
+/* Well known logical unit id in LUN field of UPIU */
+enum {
+	UFS_UPIU_REPORT_LUNS_WLUN	= 0x81,
+	UFS_UPIU_UFS_DEVICE_WLUN	= 0xD0,
+	UFS_UPIU_BOOT_WLUN		= 0xB0,
+	UFS_UPIU_RPMB_WLUN		= 0xC4,
+};
+
+/*
+ * UFS Protocol Information Unit related definitions
+ */
+
+/* Task management functions */
+enum {
+	UFS_ABORT_TASK		= 0x01,
+	UFS_ABORT_TASK_SET	= 0x02,
+	UFS_CLEAR_TASK_SET	= 0x04,
+	UFS_LOGICAL_RESET	= 0x08,
+	UFS_QUERY_TASK		= 0x80,
+	UFS_QUERY_TASK_SET	= 0x81,
+};
+
+/* UTP UPIU Transaction Codes Initiator to Target */
+enum {
+	UPIU_TRANSACTION_NOP_OUT	= 0x00,
+	UPIU_TRANSACTION_COMMAND	= 0x01,
+	UPIU_TRANSACTION_DATA_OUT	= 0x02,
+	UPIU_TRANSACTION_TASK_REQ	= 0x04,
+	UPIU_TRANSACTION_QUERY_REQ	= 0x16,
+};
+
+/* UTP UPIU Transaction Codes Target to Initiator */
+enum {
+	UPIU_TRANSACTION_NOP_IN		= 0x20,
+	UPIU_TRANSACTION_RESPONSE	= 0x21,
+	UPIU_TRANSACTION_DATA_IN	= 0x22,
+	UPIU_TRANSACTION_TASK_RSP	= 0x24,
+	UPIU_TRANSACTION_READY_XFER	= 0x31,
+	UPIU_TRANSACTION_QUERY_RSP	= 0x36,
+	UPIU_TRANSACTION_REJECT_UPIU	= 0x3F,
+};
+
+/* UPIU Read/Write flags */
+enum {
+	UPIU_CMD_FLAGS_NONE	= 0x00,
+	UPIU_CMD_FLAGS_WRITE	= 0x20,
+	UPIU_CMD_FLAGS_READ	= 0x40,
+};
+
+/* UPIU Task Attributes */
+enum {
+	UPIU_TASK_ATTR_SIMPLE	= 0x00,
+	UPIU_TASK_ATTR_ORDERED	= 0x01,
+	UPIU_TASK_ATTR_HEADQ	= 0x02,
+	UPIU_TASK_ATTR_ACA	= 0x03,
+};
+
+/* UPIU Query request function */
+enum {
+	UPIU_QUERY_FUNC_STANDARD_READ_REQUEST           = 0x01,
+	UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST          = 0x81,
+};
+
+/* Flag idn for Query Requests*/
+enum flag_idn {
+	QUERY_FLAG_IDN_FDEVICEINIT      = 0x01,
+	QUERY_FLAG_IDN_PWR_ON_WPE	= 0x03,
+	QUERY_FLAG_IDN_BKOPS_EN         = 0x04,
+};
+
+/* Attribute idn for Query requests */
+enum attr_idn {
+	QUERY_ATTR_IDN_ACTIVE_ICC_LVL	= 0x03,
+	QUERY_ATTR_IDN_BKOPS_STATUS	= 0x05,
+	QUERY_ATTR_IDN_EE_CONTROL	= 0x0D,
+	QUERY_ATTR_IDN_EE_STATUS	= 0x0E,
+};
+
+/* Descriptor idn for Query requests */
+enum desc_idn {
+	QUERY_DESC_IDN_DEVICE		= 0x0,
+	QUERY_DESC_IDN_CONFIGURAION	= 0x1,
+	QUERY_DESC_IDN_UNIT		= 0x2,
+	QUERY_DESC_IDN_RFU_0		= 0x3,
+	QUERY_DESC_IDN_INTERCONNECT	= 0x4,
+	QUERY_DESC_IDN_STRING		= 0x5,
+	QUERY_DESC_IDN_RFU_1		= 0x6,
+	QUERY_DESC_IDN_GEOMETRY		= 0x7,
+	QUERY_DESC_IDN_POWER		= 0x8,
+	QUERY_DESC_IDN_MAX,
+};
+
+enum desc_header_offset {
+	QUERY_DESC_LENGTH_OFFSET	= 0x00,
+	QUERY_DESC_DESC_TYPE_OFFSET	= 0x01,
+};
+
+enum ufs_desc_max_size {
+	QUERY_DESC_DEVICE_MAX_SIZE		= 0x1F,
+	QUERY_DESC_CONFIGURAION_MAX_SIZE	= 0x90,
+	QUERY_DESC_UNIT_MAX_SIZE		= 0x23,
+	QUERY_DESC_INTERCONNECT_MAX_SIZE	= 0x06,
+	/*
+	 * Max. 126 UNICODE characters (2 bytes per character) plus 2 bytes
+	 * of descriptor header.
+	 */
+	QUERY_DESC_STRING_MAX_SIZE		= 0xFE,
+	QUERY_DESC_GEOMETRY_MAZ_SIZE		= 0x44,
+	QUERY_DESC_POWER_MAX_SIZE		= 0x62,
+	QUERY_DESC_RFU_MAX_SIZE			= 0x00,
+};
+
+/* Unit descriptor parameters offsets in bytes*/
+enum unit_desc_param {
+	UNIT_DESC_PARAM_LEN			= 0x0,
+	UNIT_DESC_PARAM_TYPE			= 0x1,
+	UNIT_DESC_PARAM_UNIT_INDEX		= 0x2,
+	UNIT_DESC_PARAM_LU_ENABLE		= 0x3,
+	UNIT_DESC_PARAM_BOOT_LUN_ID		= 0x4,
+	UNIT_DESC_PARAM_LU_WR_PROTECT		= 0x5,
+	UNIT_DESC_PARAM_LU_Q_DEPTH		= 0x6,
+	UNIT_DESC_PARAM_MEM_TYPE		= 0x8,
+	UNIT_DESC_PARAM_DATA_RELIABILITY	= 0x9,
+	UNIT_DESC_PARAM_LOGICAL_BLK_SIZE	= 0xA,
+	UNIT_DESC_PARAM_LOGICAL_BLK_COUNT	= 0xB,
+	UNIT_DESC_PARAM_ERASE_BLK_SIZE		= 0x13,
+	UNIT_DESC_PARAM_PROVISIONING_TYPE	= 0x17,
+	UNIT_DESC_PARAM_PHY_MEM_RSRC_CNT	= 0x18,
+	UNIT_DESC_PARAM_CTX_CAPABILITIES	= 0x20,
+	UNIT_DESC_PARAM_LARGE_UNIT_SIZE_M1	= 0x22,
+};
+
+/*
+ * Logical Unit Write Protect
+ * 00h: LU not write protected
+ * 01h: LU write protected when fPowerOnWPEn =1
+ * 02h: LU permanently write protected when fPermanentWPEn =1
+ */
+enum ufs_lu_wp_type {
+	UFS_LU_NO_WP		= 0x00,
+	UFS_LU_POWER_ON_WP	= 0x01,
+	UFS_LU_PERM_WP		= 0x02,
+};
+
+/* bActiveICCLevel parameter current units */
+enum {
+	UFSHCD_NANO_AMP		= 0,
+	UFSHCD_MICRO_AMP	= 1,
+	UFSHCD_MILI_AMP		= 2,
+	UFSHCD_AMP		= 3,
+};
+
+#define POWER_DESC_MAX_SIZE			0x62
+#define POWER_DESC_MAX_ACTV_ICC_LVLS		16
+
+/* Attribute  bActiveICCLevel parameter bit masks definitions */
+#define ATTR_ICC_LVL_UNIT_OFFSET	14
+#define ATTR_ICC_LVL_UNIT_MASK		(0x3 << ATTR_ICC_LVL_UNIT_OFFSET)
+#define ATTR_ICC_LVL_VALUE_MASK		0x3FF
+
+/* Power descriptor parameters offsets in bytes */
+enum power_desc_param_offset {
+	PWR_DESC_LEN			= 0x0,
+	PWR_DESC_TYPE			= 0x1,
+	PWR_DESC_ACTIVE_LVLS_VCC_0	= 0x2,
+	PWR_DESC_ACTIVE_LVLS_VCCQ_0	= 0x22,
+	PWR_DESC_ACTIVE_LVLS_VCCQ2_0	= 0x42,
+};
+
+/* Exception event mask values */
+enum {
+	MASK_EE_STATUS		= 0xFFFF,
+	MASK_EE_URGENT_BKOPS	= (1 << 2),
+};
+
+/* Background operation status */
+enum bkops_status {
+	BKOPS_STATUS_NO_OP               = 0x0,
+	BKOPS_STATUS_NON_CRITICAL        = 0x1,
+	BKOPS_STATUS_PERF_IMPACT         = 0x2,
+	BKOPS_STATUS_CRITICAL            = 0x3,
+	BKOPS_STATUS_MAX		 = BKOPS_STATUS_CRITICAL,
+};
+
+/* UTP QUERY Transaction Specific Fields OpCode */
+enum query_opcode {
+	UPIU_QUERY_OPCODE_NOP		= 0x0,
+	UPIU_QUERY_OPCODE_READ_DESC	= 0x1,
+	UPIU_QUERY_OPCODE_WRITE_DESC	= 0x2,
+	UPIU_QUERY_OPCODE_READ_ATTR	= 0x3,
+	UPIU_QUERY_OPCODE_WRITE_ATTR	= 0x4,
+	UPIU_QUERY_OPCODE_READ_FLAG	= 0x5,
+	UPIU_QUERY_OPCODE_SET_FLAG	= 0x6,
+	UPIU_QUERY_OPCODE_CLEAR_FLAG	= 0x7,
+	UPIU_QUERY_OPCODE_TOGGLE_FLAG	= 0x8,
+};
+
+/* Query response result code */
+enum {
+	QUERY_RESULT_SUCCESS                    = 0x00,
+	QUERY_RESULT_NOT_READABLE               = 0xF6,
+	QUERY_RESULT_NOT_WRITEABLE              = 0xF7,
+	QUERY_RESULT_ALREADY_WRITTEN            = 0xF8,
+	QUERY_RESULT_INVALID_LENGTH             = 0xF9,
+	QUERY_RESULT_INVALID_VALUE              = 0xFA,
+	QUERY_RESULT_INVALID_SELECTOR           = 0xFB,
+	QUERY_RESULT_INVALID_INDEX              = 0xFC,
+	QUERY_RESULT_INVALID_IDN                = 0xFD,
+	QUERY_RESULT_INVALID_OPCODE             = 0xFE,
+	QUERY_RESULT_GENERAL_FAILURE            = 0xFF,
+};
+
+/* UTP Transfer Request Command Type (CT) */
+enum {
+	UPIU_COMMAND_SET_TYPE_SCSI	= 0x0,
+	UPIU_COMMAND_SET_TYPE_UFS	= 0x1,
+	UPIU_COMMAND_SET_TYPE_QUERY	= 0x2,
+};
+
+/* UTP Transfer Request Command Offset */
+#define UPIU_COMMAND_TYPE_OFFSET	28
+
+/* Offset of the response code in the UPIU header */
+#define UPIU_RSP_CODE_OFFSET		8
+
+enum {
+	MASK_SCSI_STATUS		= 0xFF,
+	MASK_TASK_RESPONSE              = 0xFF00,
+	MASK_RSP_UPIU_RESULT            = 0xFFFF,
+	MASK_QUERY_DATA_SEG_LEN         = 0xFFFF,
+	MASK_RSP_UPIU_DATA_SEG_LEN	= 0xFFFF,
+	MASK_RSP_EXCEPTION_EVENT        = 0x10000,
+};
+
+/* Task management service response */
+enum {
+	UPIU_TASK_MANAGEMENT_FUNC_COMPL		= 0x00,
+	UPIU_TASK_MANAGEMENT_FUNC_NOT_SUPPORTED = 0x04,
+	UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED	= 0x08,
+	UPIU_TASK_MANAGEMENT_FUNC_FAILED	= 0x05,
+	UPIU_INCORRECT_LOGICAL_UNIT_NO		= 0x09,
+};
+
+/* UFS device power modes */
+enum ufs_dev_pwr_mode {
+	UFS_ACTIVE_PWR_MODE	= 1,
+	UFS_SLEEP_PWR_MODE	= 2,
+	UFS_POWERDOWN_PWR_MODE	= 3,
+};
+
+/**
+ * struct utp_upiu_header - UPIU header structure
+ * @dword_0: UPIU header DW-0
+ * @dword_1: UPIU header DW-1
+ * @dword_2: UPIU header DW-2
+ */
+struct utp_upiu_header {
+	__be32 dword_0;
+	__be32 dword_1;
+	__be32 dword_2;
+};
+
+/**
+ * struct utp_upiu_cmd - Command UPIU structure
+ * @data_transfer_len: Data Transfer Length DW-3
+ * @cdb: Command Descriptor Block CDB DW-4 to DW-7
+ */
+struct utp_upiu_cmd {
+	__be32 exp_data_transfer_len;
+	u8 cdb[MAX_CDB_SIZE];
+};
+
+/**
+ * struct utp_upiu_query - upiu request buffer structure for
+ * query request.
+ * @opcode: command to perform B-0
+ * @idn: a value that indicates the particular type of data B-1
+ * @index: Index to further identify data B-2
+ * @selector: Index to further identify data B-3
+ * @reserved_osf: spec reserved field B-4,5
+ * @length: number of descriptor bytes to read/write B-6,7
+ * @value: Attribute value to be written DW-5
+ * @reserved: spec reserved DW-6,7
+ */
+struct utp_upiu_query {
+	u8 opcode;
+	u8 idn;
+	u8 index;
+	u8 selector;
+	__be16 reserved_osf;
+	__be16 length;
+	__be32 value;
+	__be32 reserved[2];
+};
+
+/**
+ * struct utp_upiu_req - general upiu request structure
+ * @header:UPIU header structure DW-0 to DW-2
+ * @sc: fields structure for scsi command DW-3 to DW-7
+ * @qr: fields structure for query request DW-3 to DW-7
+ */
+struct utp_upiu_req {
+	struct utp_upiu_header header;
+	union {
+		struct utp_upiu_cmd sc;
+		struct utp_upiu_query qr;
+	};
+};
+
+/**
+ * struct utp_cmd_rsp - Response UPIU structure
+ * @residual_transfer_count: Residual transfer count DW-3
+ * @reserved: Reserved double words DW-4 to DW-7
+ * @sense_data_len: Sense data length DW-8 U16
+ * @sense_data: Sense data field DW-8 to DW-12
+ */
+struct utp_cmd_rsp {
+	__be32 residual_transfer_count;
+	__be32 reserved[4];
+	__be16 sense_data_len;
+	u8 sense_data[18];
+};
+
+/**
+ * struct utp_upiu_rsp - general upiu response structure
+ * @header: UPIU header structure DW-0 to DW-2
+ * @sr: fields structure for scsi command DW-3 to DW-12
+ * @qr: fields structure for query request DW-3 to DW-7
+ */
+struct utp_upiu_rsp {
+	struct utp_upiu_header header;
+	union {
+		struct utp_cmd_rsp sr;
+		struct utp_upiu_query qr;
+	};
+};
+
+/**
+ * struct utp_upiu_task_req - Task request UPIU structure
+ * @header - UPIU header structure DW0 to DW-2
+ * @input_param1: Input parameter 1 DW-3
+ * @input_param2: Input parameter 2 DW-4
+ * @input_param3: Input parameter 3 DW-5
+ * @reserved: Reserved double words DW-6 to DW-7
+ */
+struct utp_upiu_task_req {
+	struct utp_upiu_header header;
+	__be32 input_param1;
+	__be32 input_param2;
+	__be32 input_param3;
+	__be32 reserved[2];
+};
+
+/**
+ * struct utp_upiu_task_rsp - Task Management Response UPIU structure
+ * @header: UPIU header structure DW0-DW-2
+ * @output_param1: Ouput parameter 1 DW3
+ * @output_param2: Output parameter 2 DW4
+ * @reserved: Reserved double words DW-5 to DW-7
+ */
+struct utp_upiu_task_rsp {
+	struct utp_upiu_header header;
+	__be32 output_param1;
+	__be32 output_param2;
+	__be32 reserved[3];
+};
+
+/**
+ * struct ufs_query_req - parameters for building a query request
+ * @query_func: UPIU header query function
+ * @upiu_req: the query request data
+ */
+struct ufs_query_req {
+	u8 query_func;
+	struct utp_upiu_query upiu_req;
+};
+
+/**
+ * struct ufs_query_resp - UPIU QUERY
+ * @response: device response code
+ * @upiu_res: query response data
+ */
+struct ufs_query_res {
+	u8 response;
+	struct utp_upiu_query upiu_res;
+};
+
+#define UFS_VREG_VCC_MIN_UV	   2700000 /* uV */
+#define UFS_VREG_VCC_MAX_UV	   3600000 /* uV */
+#define UFS_VREG_VCC_1P8_MIN_UV    1700000 /* uV */
+#define UFS_VREG_VCC_1P8_MAX_UV    1950000 /* uV */
+#define UFS_VREG_VCCQ_MIN_UV	   1100000 /* uV */
+#define UFS_VREG_VCCQ_MAX_UV	   1300000 /* uV */
+#define UFS_VREG_VCCQ2_MIN_UV	   1650000 /* uV */
+#define UFS_VREG_VCCQ2_MAX_UV	   1950000 /* uV */
+
+/*
+ * VCCQ & VCCQ2 current requirement when UFS device is in sleep state
+ * and link is in Hibern8 state.
+ */
+#define UFS_VREG_LPM_LOAD_UA	1000 /* uA */
+
+struct ufs_vreg {
+	struct regulator *reg;
+	const char *name;
+	bool enabled;
+	int min_uV;
+	int max_uV;
+	int min_uA;
+	int max_uA;
+};
+
+struct ufs_vreg_info {
+	struct ufs_vreg *vcc;
+	struct ufs_vreg *vccq;
+	struct ufs_vreg *vccq2;
+	struct ufs_vreg *vdd_hba;
+};
+
+struct ufs_dev_info {
+	bool f_power_on_wp_en;
+	/* Keeps information if any of the LU is power on write protected */
+	bool is_lu_power_on_wp;
+};
+
+#endif /* End of Header */
diff --git a/include/linux/scsi/ufs/ufshcd.h
b/include/linux/scsi/ufs/ufshcd.h
new file mode 100644
index 0000000..51304f7
--- /dev/null
+++ b/include/linux/scsi/ufs/ufshcd.h
@@ -0,0 +1,635 @@
+/*
+ * Universal Flash Storage Host controller driver
+ *
+ * This code is based on drivers/scsi/ufs/ufshcd.h
+ * Copyright (C) 2011-2013 Samsung India Software Operations
+ *
+ * Authors:
+ *	Santosh Yaraganavi <santosh.sy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
+ *	Vinayak Holikatti <h.vinayak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * See the COPYING file in the top-level directory or visit
+ * <http://www.gnu.org/licenses/gpl-2.0.html>
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * This program is provided "AS IS" and "WITH ALL FAULTS" and
+ * without warranty of any kind. You are solely responsible for
+ * determining the appropriateness of using and distributing
+ * the program and assume all risks associated with your exercise
+ * of rights with respect to the program, including but not limited
+ * to infringement of third party rights, the risks and costs of
+ * program errors, damage to or loss of data, programs or equipment,
+ * and unavailability or interruption of operations. Under no
+ * circumstances will the contributor of this Program be liable for
+ * any damages of any kind arising from your use or distribution of
+ * this program.
+ */
+
+#ifndef _UFSHCD_H
+#define _UFSHCD_H
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/bitops.h>
+#include <linux/pm_runtime.h>
+#include <linux/clk.h>
+#include <linux/completion.h>
+#include <linux/regulator/consumer.h>
+
+#include <asm/irq.h>
+#include <asm/byteorder.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_eh.h>
+
+#include "ufs.h"
+
+#define UFSHCD "ufshcd"
+#define UFSHCD_DRIVER_VERSION "0.2"
+
+struct ufs_hba;
+
+/**
+ * readl_poll_timeout - Periodically poll an address until a condition is
met or a timeout occurs
+ * @addr: Address to poll
+ * @val: Variable to read the value into
+ * @cond: Break condition (usually involving @val)
+ * @sleep_us: Maximum time to sleep between reads in us (0 tight-loops)
+ * @timeout_us: Timeout in us, 0 means never timeout
+ *
+ * Returns 0 on success and -ETIMEDOUT upon a timeout. In either
+ * case, the last read value at @addr is stored in @val. Must not
+ * be called from atomic context if sleep_us or timeout_us are used.
+ */
+#define readl_poll_timeout(addr, val, cond, sleep_us, timeout_us) \
+({ \
+	ktime_t timeout = ktime_add_us(ktime_get(), timeout_us); \
+	might_sleep_if(timeout_us); \
+	for (;;) { \
+		(val) = readl(addr); \
+		if (cond) \
+			break; \
+		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) {
\
+			(val) = readl(addr); \
+			break; \
+		} \
+		if (sleep_us) \
+			usleep_range(DIV_ROUND_UP(sleep_us, 4), sleep_us); \
+	} \
+	(cond) ? 0 : -ETIMEDOUT; \
+})
+
+enum dev_cmd_type {
+	DEV_CMD_TYPE_NOP		= 0x0,
+	DEV_CMD_TYPE_QUERY		= 0x1,
+};
+
+/**
+ * struct uic_command - UIC command structure
+ * @command: UIC command
+ * @argument1: UIC command argument 1
+ * @argument2: UIC command argument 2
+ * @argument3: UIC command argument 3
+ * @cmd_active: Indicate if UIC command is outstanding
+ * @result: UIC command result
+ * @done: UIC command completion
+ */
+struct uic_command {
+	u32 command;
+	u32 argument1;
+	u32 argument2;
+	u32 argument3;
+	int cmd_active;
+	int result;
+	struct completion done;
+};
+
+/* Used to differentiate the power management options */
+enum ufs_pm_op {
+	UFS_RUNTIME_PM,
+	UFS_SYSTEM_PM,
+	UFS_SHUTDOWN_PM,
+};
+
+#define ufshcd_is_runtime_pm(op) ((op) == UFS_RUNTIME_PM)
+#define ufshcd_is_system_pm(op) ((op) == UFS_SYSTEM_PM)
+#define ufshcd_is_shutdown_pm(op) ((op) == UFS_SHUTDOWN_PM)
+
+/* Host <-> Device UniPro Link state */
+enum uic_link_state {
+	UIC_LINK_OFF_STATE	= 0, /* Link powered down or disabled */
+	UIC_LINK_ACTIVE_STATE	= 1, /* Link is in Fast/Slow/Sleep state */
+	UIC_LINK_HIBERN8_STATE	= 2, /* Link is in Hibernate state */
+};
+
+#define ufshcd_is_link_off(hba) ((hba)->uic_link_state ==
UIC_LINK_OFF_STATE)
+#define ufshcd_is_link_active(hba) ((hba)->uic_link_state == \
+				    UIC_LINK_ACTIVE_STATE)
+#define ufshcd_is_link_hibern8(hba) ((hba)->uic_link_state == \
+				    UIC_LINK_HIBERN8_STATE)
+#define ufshcd_set_link_off(hba) ((hba)->uic_link_state =
UIC_LINK_OFF_STATE)
+#define ufshcd_set_link_active(hba) ((hba)->uic_link_state = \
+				    UIC_LINK_ACTIVE_STATE)
+#define ufshcd_set_link_hibern8(hba) ((hba)->uic_link_state = \
+				    UIC_LINK_HIBERN8_STATE)
+
+/*
+ * UFS Power management levels.
+ * Each level is in increasing order of power savings.
+ */
+enum ufs_pm_level {
+	UFS_PM_LVL_0, /* UFS_ACTIVE_PWR_MODE, UIC_LINK_ACTIVE_STATE */
+	UFS_PM_LVL_1, /* UFS_ACTIVE_PWR_MODE, UIC_LINK_HIBERN8_STATE */
+	UFS_PM_LVL_2, /* UFS_SLEEP_PWR_MODE, UIC_LINK_ACTIVE_STATE */
+	UFS_PM_LVL_3, /* UFS_SLEEP_PWR_MODE, UIC_LINK_HIBERN8_STATE */
+	UFS_PM_LVL_4, /* UFS_POWERDOWN_PWR_MODE, UIC_LINK_HIBERN8_STATE */
+	UFS_PM_LVL_5, /* UFS_POWERDOWN_PWR_MODE, UIC_LINK_OFF_STATE */
+	UFS_PM_LVL_MAX
+};
+
+struct ufs_pm_lvl_states {
+	enum ufs_dev_pwr_mode dev_state;
+	enum uic_link_state link_state;
+};
+
+/**
+ * struct ufshcd_lrb - local reference block
+ * @utr_descriptor_ptr: UTRD address of the command
+ * @ucd_req_ptr: UCD address of the command
+ * @ucd_rsp_ptr: Response UPIU address for this command
+ * @ucd_prdt_ptr: PRDT address of the command
+ * @cmd: pointer to SCSI command
+ * @sense_buffer: pointer to sense buffer address of the SCSI command
+ * @sense_bufflen: Length of the sense buffer
+ * @scsi_status: SCSI status of the command
+ * @command_type: SCSI, UFS, Query.
+ * @task_tag: Task tag of the command
+ * @lun: LUN of the command
+ * @intr_cmd: Interrupt command (doesn't participate in interrupt
aggregation)
+ */
+struct ufshcd_lrb {
+	struct utp_transfer_req_desc *utr_descriptor_ptr;
+	struct utp_upiu_req *ucd_req_ptr;
+	struct utp_upiu_rsp *ucd_rsp_ptr;
+	struct ufshcd_sg_entry *ucd_prdt_ptr;
+
+	struct scsi_cmnd *cmd;
+	u8 *sense_buffer;
+	unsigned int sense_bufflen;
+	int scsi_status;
+
+	int command_type;
+	int task_tag;
+	u8 lun; /* UPIU LUN id field is only 8-bit wide */
+	bool intr_cmd;
+};
+
+/**
+ * struct ufs_query - holds relevent data structures for query request
+ * @request: request upiu and function
+ * @descriptor: buffer for sending/receiving descriptor
+ * @response: response upiu and response
+ */
+struct ufs_query {
+	struct ufs_query_req request;
+	u8 *descriptor;
+	struct ufs_query_res response;
+};
+
+/**
+ * struct ufs_dev_cmd - all assosiated fields with device management
commands
+ * @type: device management command type - Query, NOP OUT
+ * @lock: lock to allow one command at a time
+ * @complete: internal commands completion
+ * @tag_wq: wait queue until free command slot is available
+ */
+struct ufs_dev_cmd {
+	enum dev_cmd_type type;
+	struct mutex lock;
+	struct completion *complete;
+	wait_queue_head_t tag_wq;
+	struct ufs_query query;
+};
+
+/**
+ * struct ufs_clk_info - UFS clock related info
+ * @list: list headed by hba->clk_list_head
+ * @clk: clock node
+ * @name: clock name
+ * @max_freq: maximum frequency supported by the clock
+ * @min_freq: min frequency that can be used for clock scaling
+ * @curr_freq: indicates the current frequency that it is set to
+ * @enabled: variable to check against multiple enable/disable
+ */
+struct ufs_clk_info {
+	struct list_head list;
+	struct clk *clk;
+	const char *name;
+	u32 max_freq;
+	u32 min_freq;
+	u32 curr_freq;
+	bool enabled;
+};
+
+#define PRE_CHANGE      0
+#define POST_CHANGE     1
+
+struct ufs_pa_layer_attr {
+	u32 gear_rx;
+	u32 gear_tx;
+	u32 lane_rx;
+	u32 lane_tx;
+	u32 pwr_rx;
+	u32 pwr_tx;
+	u32 hs_rate;
+};
+
+struct ufs_pwr_mode_info {
+	bool is_valid;
+	struct ufs_pa_layer_attr info;
+};
+
+/**
+ * struct ufs_hba_variant_ops - variant specific callbacks
+ * @name: variant name
+ * @init: called when the driver is initialized
+ * @exit: called to cleanup everything done in init
+ * @clk_scale_notify: notifies that clks are scaled up/down
+ * @setup_clocks: called before touching any of the controller registers
+ * @setup_regulators: called before accessing the host controller
+ * @hce_enable_notify: called before and after HCE enable bit is set to
allow
+ *                     variant specific Uni-Pro initialization.
+ * @link_startup_notify: called before and after Link startup is carried
out
+ *                       to allow variant specific Uni-Pro initialization.
+ * @pwr_change_notify: called before and after a power mode change
+ *			is carried out to allow vendor spesific capabilities
+ *			to be set.
+ * @suspend: called during host controller PM callback
+ * @resume: called during host controller PM callback
+ */
+struct ufs_hba_variant_ops {
+	const char *name;
+	int	(*init)(struct ufs_hba *);
+	void    (*exit)(struct ufs_hba *);
+	void    (*clk_scale_notify)(struct ufs_hba *);
+	int     (*setup_clocks)(struct ufs_hba *, bool);
+	int     (*setup_regulators)(struct ufs_hba *, bool);
+	int     (*hce_enable_notify)(struct ufs_hba *, bool);
+	int     (*link_startup_notify)(struct ufs_hba *, bool);
+	int	(*pwr_change_notify)(struct ufs_hba *,
+					bool, struct ufs_pa_layer_attr *,
+					struct ufs_pa_layer_attr *);
+	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
+	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
+};
+
+/* clock gating state  */
+enum clk_gating_state {
+	CLKS_OFF,
+	CLKS_ON,
+	REQ_CLKS_OFF,
+	REQ_CLKS_ON,
+};
+
+/**
+ * struct ufs_clk_gating - UFS clock gating related info
+ * @gate_work: worker to turn off clocks after some delay as specified in
+ * delay_ms
+ * @ungate_work: worker to turn on clocks that will be used in case of
+ * interrupt context
+ * @state: the current clocks state
+ * @delay_ms: gating delay in ms
+ * @is_suspended: clk gating is suspended when set to 1 which can be used
+ * during suspend/resume
+ * @delay_attr: sysfs attribute to control delay_attr
+ * @active_reqs: number of requests that are pending and should be waited
for
+ * completion before gating clocks.
+ */
+struct ufs_clk_gating {
+	struct delayed_work gate_work;
+	struct work_struct ungate_work;
+	enum clk_gating_state state;
+	unsigned long delay_ms;
+	bool is_suspended;
+	struct device_attribute delay_attr;
+	int active_reqs;
+};
+
+struct ufs_clk_scaling {
+	ktime_t  busy_start_t;
+	bool is_busy_started;
+	unsigned long  tot_busy_t;
+	unsigned long window_start_t;
+};
+
+/**
+ * struct ufs_init_prefetch - contains data that is pre-fetched once during
+ * initialization
+ * @icc_level: icc level which was read during initialization
+ */
+struct ufs_init_prefetch {
+	u32 icc_level;
+};
+
+/**
+ * struct ufs_hba - per adapter private structure
+ * @mmio_base: UFSHCI base register address
+ * @ucdl_base_addr: UFS Command Descriptor base address
+ * @utrdl_base_addr: UTP Transfer Request Descriptor base address
+ * @utmrdl_base_addr: UTP Task Management Descriptor base address
+ * @ucdl_dma_addr: UFS Command Descriptor DMA address
+ * @utrdl_dma_addr: UTRDL DMA address
+ * @utmrdl_dma_addr: UTMRDL DMA address
+ * @host: Scsi_Host instance of the driver
+ * @dev: device handle
+ * @lrb: local reference block
+ * @lrb_in_use: lrb in use
+ * @outstanding_tasks: Bits representing outstanding task requests
+ * @outstanding_reqs: Bits representing outstanding transfer requests
+ * @capabilities: UFS Controller Capabilities
+ * @nutrs: Transfer Request Queue depth supported by controller
+ * @nutmrs: Task Management Queue depth supported by controller
+ * @ufs_version: UFS Version to which controller complies
+ * @vops: pointer to variant specific operations
+ * @priv: pointer to variant specific private data
+ * @irq: Irq number of the controller
+ * @active_uic_cmd: handle of active UIC command
+ * @uic_cmd_mutex: mutex for uic command
+ * @tm_wq: wait queue for task management
+ * @tm_tag_wq: wait queue for free task management slots
+ * @tm_slots_in_use: bit map of task management request slots in use
+ * @pwr_done: completion for power mode change
+ * @tm_condition: condition variable for task management
+ * @ufshcd_state: UFSHCD states
+ * @eh_flags: Error handling flags
+ * @intr_mask: Interrupt Mask Bits
+ * @ee_ctrl_mask: Exception event control mask
+ * @is_powered: flag to check if HBA is powered
+ * @is_init_prefetch: flag to check if data was pre-fetched in
initialization
+ * @init_prefetch_data: data pre-fetched during initialization
+ * @eh_work: Worker to handle UFS errors that require s/w attention
+ * @eeh_work: Worker to handle exception events
+ * @errors: HBA errors
+ * @uic_error: UFS interconnect layer error status
+ * @saved_err: sticky error mask
+ * @saved_uic_err: sticky UIC error mask
+ * @dev_cmd: ufs device management command information
+ * @auto_bkops_enabled: to track whether bkops is enabled in device
+ * @vreg_info: UFS device voltage regulator information
+ * @clk_list_head: UFS host controller clocks list node head
+ * @pwr_info: holds current power mode
+ * @max_pwr_info: keeps the device max valid pwm
+ */
+struct ufs_hba {
+	void __iomem *mmio_base;
+
+	/* Virtual memory reference */
+	struct utp_transfer_cmd_desc *ucdl_base_addr;
+	struct utp_transfer_req_desc *utrdl_base_addr;
+	struct utp_task_req_desc *utmrdl_base_addr;
+
+	/* DMA memory reference */
+	dma_addr_t ucdl_dma_addr;
+	dma_addr_t utrdl_dma_addr;
+	dma_addr_t utmrdl_dma_addr;
+
+	struct Scsi_Host *host;
+	struct device *dev;
+	/*
+	 * This field is to keep a reference to "scsi_device" corresponding
to
+	 * "UFS device" W-LU.
+	 */
+	struct scsi_device *sdev_ufs_device;
+	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
+	enum uic_link_state uic_link_state;
+	/* Desired UFS power management level during runtime PM */
+	enum ufs_pm_level rpm_lvl;
+	/* Desired UFS power management level during system PM */
+	enum ufs_pm_level spm_lvl;
+	int pm_op_in_progress;
+
+	struct ufshcd_lrb *lrb;
+	unsigned long lrb_in_use;
+
+	unsigned long outstanding_tasks;
+	unsigned long outstanding_reqs;
+
+	u32 capabilities;
+	int nutrs;
+	int nutmrs;
+	u32 ufs_version;
+	struct ufs_hba_variant_ops *vops;
+	void *priv;
+	unsigned int irq;
+	bool is_irq_enabled;
+
+	/* Interrupt aggregation support is broken */
+	#define UFSHCD_QUIRK_BROKEN_INTR_AGGR			UFS_BIT(0)
+
+	/*
+	 * delay before each dme command is required as the unipro
+	 * layer has shown instabilities
+	 */
+	#define UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS		UFS_BIT(1)
+
+	/*
+	 * If UFS host controller is having issue in processing LCC (Line
+	 * Control Command) coming from device then enable this quirk.
+	 * When this quirk is enabled, host controller driver should disable
+	 * the LCC transmission on UFS device (by clearing TX_LCC_ENABLE
+	 * attribute of device to 0).
+	 */
+	#define UFSHCD_QUIRK_BROKEN_LCC				UFS_BIT(2)
+
+	/*
+	 * The attribute PA_RXHSUNTERMCAP specifies whether or not the
+	 * inbound Link supports unterminated line in HS mode. Setting this
+	 * attribute to 1 fixes moving to HS gear.
+	 */
+	#define UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP		UFS_BIT(3)
+
+	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
+
+	wait_queue_head_t tm_wq;
+	wait_queue_head_t tm_tag_wq;
+	unsigned long tm_condition;
+	unsigned long tm_slots_in_use;
+
+	struct uic_command *active_uic_cmd;
+	struct mutex uic_cmd_mutex;
+	struct completion *uic_async_done;
+
+	u32 ufshcd_state;
+	u32 eh_flags;
+	u32 intr_mask;
+	u16 ee_ctrl_mask;
+	bool is_powered;
+	bool is_init_prefetch;
+	struct ufs_init_prefetch init_prefetch_data;
+
+	/* Work Queues */
+	struct work_struct eh_work;
+	struct work_struct eeh_work;
+
+	/* HBA Errors */
+	u32 errors;
+	u32 uic_error;
+	u32 saved_err;
+	u32 saved_uic_err;
+
+	/* Device management request data */
+	struct ufs_dev_cmd dev_cmd;
+
+	/* Keeps information of the UFS device connected to this host */
+	struct ufs_dev_info dev_info;
+	bool auto_bkops_enabled;
+	struct ufs_vreg_info vreg_info;
+	struct list_head clk_list_head;
+
+	bool wlun_dev_clr_ua;
+
+	struct ufs_pa_layer_attr pwr_info;
+	struct ufs_pwr_mode_info max_pwr_info;
+
+	struct ufs_clk_gating clk_gating;
+	/* Control to enable/disable host capabilities */
+	u32 caps;
+	/* Allow dynamic clk gating */
+#define UFSHCD_CAP_CLK_GATING	(1 << 0)
+	/* Allow hiberb8 with clk gating */
+#define UFSHCD_CAP_HIBERN8_WITH_CLK_GATING (1 << 1)
+	/* Allow dynamic clk scaling */
+#define UFSHCD_CAP_CLK_SCALING	(1 << 2)
+	/* Allow auto bkops to enabled during runtime suspend */
+#define UFSHCD_CAP_AUTO_BKOPS_SUSPEND (1 << 3)
+
+	struct devfreq *devfreq;
+	struct ufs_clk_scaling clk_scaling;
+	bool is_sys_suspended;
+};
+
+/* Returns true if clocks can be gated. Otherwise false */
+static inline bool ufshcd_is_clkgating_allowed(struct ufs_hba *hba)
+{
+	return hba->caps & UFSHCD_CAP_CLK_GATING;
+}
+static inline bool ufshcd_can_hibern8_during_gating(struct ufs_hba *hba)
+{
+	return hba->caps & UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
+}
+static inline int ufshcd_is_clkscaling_enabled(struct ufs_hba *hba)
+{
+	return hba->caps & UFSHCD_CAP_CLK_SCALING;
+}
+static inline bool ufshcd_can_autobkops_during_suspend(struct ufs_hba *hba)
+{
+	return hba->caps & UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
+}
+
+#define ufshcd_writel(hba, val, reg)	\
+	writel((val), (hba)->mmio_base + (reg))
+#define ufshcd_readl(hba, reg)	\
+	readl((hba)->mmio_base + (reg))
+
+/**
+ * ufshcd_rmwl - read modify write into a register
+ * @hba - per adapter instance
+ * @mask - mask to apply on read value
+ * @val - actual value to write
+ * @reg - register address
+ */
+static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32
reg)
+{
+	u32 tmp;
+
+	tmp = ufshcd_readl(hba, reg);
+	tmp &= ~mask;
+	tmp |= (val & mask);
+	ufshcd_writel(hba, tmp, reg);
+}
+
+int ufshcd_alloc_host(struct device *, struct ufs_hba **);
+int ufshcd_init(struct ufs_hba * , void __iomem * , unsigned int);
+void ufshcd_remove(struct ufs_hba *);
+
+extern int ufshcd_runtime_suspend(struct ufs_hba *hba);
+extern int ufshcd_runtime_resume(struct ufs_hba *hba);
+extern int ufshcd_runtime_idle(struct ufs_hba *hba);
+extern int ufshcd_system_suspend(struct ufs_hba *hba);
+extern int ufshcd_system_resume(struct ufs_hba *hba);
+extern int ufshcd_shutdown(struct ufs_hba *hba);
+extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
+			       u8 attr_set, u32 mib_val, u8 peer);
+extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
+			       u32 *mib_val, u8 peer);
+
+/* UIC command interfaces for DME primitives */
+#define DME_LOCAL	0
+#define DME_PEER	1
+#define ATTR_SET_NOR	0	/* NORMAL */
+#define ATTR_SET_ST	1	/* STATIC */
+
+static inline int ufshcd_dme_set(struct ufs_hba *hba, u32 attr_sel,
+				 u32 mib_val)
+{
+	return ufshcd_dme_set_attr(hba, attr_sel, ATTR_SET_NOR,
+				   mib_val, DME_LOCAL);
+}
+
+static inline int ufshcd_dme_st_set(struct ufs_hba *hba, u32 attr_sel,
+				    u32 mib_val)
+{
+	return ufshcd_dme_set_attr(hba, attr_sel, ATTR_SET_ST,
+				   mib_val, DME_LOCAL);
+}
+
+static inline int ufshcd_dme_peer_set(struct ufs_hba *hba, u32 attr_sel,
+				      u32 mib_val)
+{
+	return ufshcd_dme_set_attr(hba, attr_sel, ATTR_SET_NOR,
+				   mib_val, DME_PEER);
+}
+
+static inline int ufshcd_dme_peer_st_set(struct ufs_hba *hba, u32 attr_sel,
+					 u32 mib_val)
+{
+	return ufshcd_dme_set_attr(hba, attr_sel, ATTR_SET_ST,
+				   mib_val, DME_PEER);
+}
+
+static inline int ufshcd_dme_get(struct ufs_hba *hba,
+				 u32 attr_sel, u32 *mib_val)
+{
+	return ufshcd_dme_get_attr(hba, attr_sel, mib_val, DME_LOCAL);
+}
+
+static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
+				      u32 attr_sel, u32 *mib_val)
+{
+	return ufshcd_dme_get_attr(hba, attr_sel, mib_val, DME_PEER);
+}
+
+int ufshcd_hold(struct ufs_hba *hba, bool async);
+void ufshcd_release(struct ufs_hba *hba);
+#endif /* End of Header */
diff --git a/include/linux/scsi/ufs/unipro.h
b/include/linux/scsi/ufs/unipro.h
new file mode 100644
index 0000000..3fc3e21
--- /dev/null
+++ b/include/linux/scsi/ufs/unipro.h
@@ -0,0 +1,207 @@
+/*
+ * drivers/scsi/ufs/unipro.h
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _UNIPRO_H_
+#define _UNIPRO_H_
+
+/*
+ * M-TX Configuration Attributes
+ */
+#define TX_MODE					0x0021
+#define TX_HSRATE_SERIES			0x0022
+#define TX_HSGEAR				0x0023
+#define TX_PWMGEAR				0x0024
+#define TX_AMPLITUDE				0x0025
+#define TX_HS_SLEWRATE				0x0026
+#define TX_SYNC_SOURCE				0x0027
+#define TX_HS_SYNC_LENGTH			0x0028
+#define TX_HS_PREPARE_LENGTH			0x0029
+#define TX_LS_PREPARE_LENGTH			0x002A
+#define TX_HIBERN8_CONTROL			0x002B
+#define TX_LCC_ENABLE				0x002C
+#define TX_PWM_BURST_CLOSURE_EXTENSION		0x002D
+#define TX_BYPASS_8B10B_ENABLE			0x002E
+#define TX_DRIVER_POLARITY			0x002F
+#define TX_HS_UNTERMINATED_LINE_DRIVE_ENABLE	0x0030
+#define TX_LS_TERMINATED_LINE_DRIVE_ENABLE	0x0031
+#define TX_LCC_SEQUENCER			0x0032
+#define TX_MIN_ACTIVATETIME			0x0033
+#define TX_PWM_G6_G7_SYNC_LENGTH		0x0034
+
+/*
+ * M-RX Configuration Attributes
+ */
+#define RX_MODE					0x00A1
+#define RX_HSRATE_SERIES			0x00A2
+#define RX_HSGEAR				0x00A3
+#define RX_PWMGEAR				0x00A4
+#define RX_LS_TERMINATED_ENABLE			0x00A5
+#define RX_HS_UNTERMINATED_ENABLE		0x00A6
+#define RX_ENTER_HIBERN8			0x00A7
+#define RX_BYPASS_8B10B_ENABLE			0x00A8
+#define RX_TERMINATION_FORCE_ENABLE		0x0089
+
+#define is_mphy_tx_attr(attr)			(attr < RX_MODE)
+/*
+ * PHY Adpater attributes
+ */
+#define PA_ACTIVETXDATALANES	0x1560
+#define PA_ACTIVERXDATALANES	0x1580
+#define PA_TXTRAILINGCLOCKS	0x1564
+#define PA_PHY_TYPE		0x1500
+#define PA_AVAILTXDATALANES	0x1520
+#define PA_AVAILRXDATALANES	0x1540
+#define PA_MINRXTRAILINGCLOCKS	0x1543
+#define PA_TXPWRSTATUS		0x1567
+#define PA_RXPWRSTATUS		0x1582
+#define PA_TXFORCECLOCK		0x1562
+#define PA_TXPWRMODE		0x1563
+#define PA_LEGACYDPHYESCDL	0x1570
+#define PA_MAXTXSPEEDFAST	0x1521
+#define PA_MAXTXSPEEDSLOW	0x1522
+#define PA_MAXRXSPEEDFAST	0x1541
+#define PA_MAXRXSPEEDSLOW	0x1542
+#define PA_TXLINKSTARTUPHS	0x1544
+#define PA_TXSPEEDFAST		0x1565
+#define PA_TXSPEEDSLOW		0x1566
+#define PA_REMOTEVERINFO	0x15A0
+#define PA_TXGEAR		0x1568
+#define PA_TXTERMINATION	0x1569
+#define PA_HSSERIES		0x156A
+#define PA_PWRMODE		0x1571
+#define PA_RXGEAR		0x1583
+#define PA_RXTERMINATION	0x1584
+#define PA_MAXRXPWMGEAR		0x1586
+#define PA_MAXRXHSGEAR		0x1587
+#define PA_RXHSUNTERMCAP	0x15A5
+#define PA_RXLSTERMCAP		0x15A6
+#define PA_PACPREQTIMEOUT	0x1590
+#define PA_PACPREQEOBTIMEOUT	0x1591
+#define PA_HIBERN8TIME		0x15A7
+#define PA_LOCALVERINFO		0x15A9
+#define PA_TACTIVATE		0x15A8
+#define PA_PACPFRAMECOUNT	0x15C0
+#define PA_PACPERRORCOUNT	0x15C1
+#define PA_PHYTESTCONTROL	0x15C2
+#define PA_PWRMODEUSERDATA0	0x15B0
+#define PA_PWRMODEUSERDATA1	0x15B1
+#define PA_PWRMODEUSERDATA2	0x15B2
+#define PA_PWRMODEUSERDATA3	0x15B3
+#define PA_PWRMODEUSERDATA4	0x15B4
+#define PA_PWRMODEUSERDATA5	0x15B5
+#define PA_PWRMODEUSERDATA6	0x15B6
+#define PA_PWRMODEUSERDATA7	0x15B7
+#define PA_PWRMODEUSERDATA8	0x15B8
+#define PA_PWRMODEUSERDATA9	0x15B9
+#define PA_PWRMODEUSERDATA10	0x15BA
+#define PA_PWRMODEUSERDATA11	0x15BB
+#define PA_CONNECTEDTXDATALANES	0x1561
+#define PA_CONNECTEDRXDATALANES	0x1581
+#define PA_LOGICALLANEMAP	0x15A1
+#define PA_SLEEPNOCONFIGTIME	0x15A2
+#define PA_STALLNOCONFIGTIME	0x15A3
+#define PA_SAVECONFIGTIME	0x15A4
+
+/* PA power modes */
+enum {
+	FAST_MODE	= 1,
+	SLOW_MODE	= 2,
+	FASTAUTO_MODE	= 4,
+	SLOWAUTO_MODE	= 5,
+	UNCHANGED	= 7,
+};
+
+/* PA TX/RX Frequency Series */
+enum {
+	PA_HS_MODE_A	= 1,
+	PA_HS_MODE_B	= 2,
+};
+
+enum ufs_pwm_gear_tag {
+	UFS_PWM_DONT_CHANGE,	/* Don't change Gear */
+	UFS_PWM_G1,		/* PWM Gear 1 (default for reset) */
+	UFS_PWM_G2,		/* PWM Gear 2 */
+	UFS_PWM_G3,		/* PWM Gear 3 */
+	UFS_PWM_G4,		/* PWM Gear 4 */
+	UFS_PWM_G5,		/* PWM Gear 5 */
+	UFS_PWM_G6,		/* PWM Gear 6 */
+	UFS_PWM_G7,		/* PWM Gear 7 */
+};
+
+enum ufs_hs_gear_tag {
+	UFS_HS_DONT_CHANGE,	/* Don't change Gear */
+	UFS_HS_G1,		/* HS Gear 1 (default for reset) */
+	UFS_HS_G2,		/* HS Gear 2 */
+	UFS_HS_G3,		/* HS Gear 3 */
+};
+
+/*
+ * Data Link Layer Attributes
+ */
+#define DL_TC0TXFCTHRESHOLD	0x2040
+#define DL_FC0PROTTIMEOUTVAL	0x2041
+#define DL_TC0REPLAYTIMEOUTVAL	0x2042
+#define DL_AFC0REQTIMEOUTVAL	0x2043
+#define DL_AFC0CREDITTHRESHOLD	0x2044
+#define DL_TC0OUTACKTHRESHOLD	0x2045
+#define DL_TC1TXFCTHRESHOLD	0x2060
+#define DL_FC1PROTTIMEOUTVAL	0x2061
+#define DL_TC1REPLAYTIMEOUTVAL	0x2062
+#define DL_AFC1REQTIMEOUTVAL	0x2063
+#define DL_AFC1CREDITTHRESHOLD	0x2064
+#define DL_TC1OUTACKTHRESHOLD	0x2065
+#define DL_TXPREEMPTIONCAP	0x2000
+#define DL_TC0TXMAXSDUSIZE	0x2001
+#define DL_TC0RXINITCREDITVAL	0x2002
+#define DL_TC0TXBUFFERSIZE	0x2005
+#define DL_PEERTC0PRESENT	0x2046
+#define DL_PEERTC0RXINITCREVAL	0x2047
+#define DL_TC1TXMAXSDUSIZE	0x2003
+#define DL_TC1RXINITCREDITVAL	0x2004
+#define DL_TC1TXBUFFERSIZE	0x2006
+#define DL_PEERTC1PRESENT	0x2066
+#define DL_PEERTC1RXINITCREVAL	0x2067
+
+/*
+ * Network Layer Attributes
+ */
+#define N_DEVICEID		0x3000
+#define N_DEVICEID_VALID	0x3001
+#define N_TC0TXMAXSDUSIZE	0x3020
+#define N_TC1TXMAXSDUSIZE	0x3021
+
+/*
+ * Transport Layer Attributes
+ */
+#define T_NUMCPORTS		0x4000
+#define T_NUMTESTFEATURES	0x4001
+#define T_CONNECTIONSTATE	0x4020
+#define T_PEERDEVICEID		0x4021
+#define T_PEERCPORTID		0x4022
+#define T_TRAFFICCLASS		0x4023
+#define T_PROTOCOLID		0x4024
+#define T_CPORTFLAGS		0x4025
+#define T_TXTOKENVALUE		0x4026
+#define T_RXTOKENVALUE		0x4027
+#define T_LOCALBUFFERSPACE	0x4028
+#define T_PEERBUFFERSPACE	0x4029
+#define T_CREDITSTOSEND		0x402A
+#define T_CPORTMODE		0x402B
+#define T_TC0TXMAXSDUSIZE	0x4060
+#define T_TC1TXMAXSDUSIZE	0x4061
+
+/* Boolean attribute values */
+enum {
+	FALSE = 0,
+	TRUE,
+};
+
+#endif /* _UNIPRO_H_ */
-- 
1.8.5.2
--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
