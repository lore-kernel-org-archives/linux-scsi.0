From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v12 8/9] add TC G210 platform driver
Date: Thu, 31 Mar 2016 19:57:21 +0100
Message-ID: <aa4c31ba977bc5c07f5706f12c4d9fbb1bb0ec36.1459448160.git.jpinto@synopsys.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1459448160.git.jpinto@synopsys.com>
In-Reply-To: <cover.1459448160.git.jpinto@synopsys.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tomas.winkler@intel.com
Cc: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, arnd@arndb.de, mark.rutland@arm.com, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds a glue platform driver for the Synopsys G210 Test Chip.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
Changes v11->v12 (Tomas Winkler):
- custom_phy_initialization replaced by phy_initialization
Changes v10->v11 (Arnd Bergmann):
- vops structs are now passed in .data
Changes v0->v10:
- This patch only appeared in v10

 .../devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt |  26 +++++
 drivers/scsi/ufs/Kconfig                           |   9 ++
 drivers/scsi/ufs/Makefile                          |   1 +
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c              | 113 +++++++++++++++++++++
 4 files changed, 149 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt
 create mode 100644 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c

diff --git a/Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt b/Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt
new file mode 100644
index 0000000..6ec9647
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt
@@ -0,0 +1,26 @@
+* Universal Flash Storage (UFS) DesignWare Host Controller
+
+DWC_UFS nodes are defined to describe on-chip UFS host controllers and MPHY.
+Each UFS controller instance should have its own node.
+
+Required properties:
+- compatible	: compatible list must contain the PHY type & version:
+			"snps, g210-tc-6.00-20bit"
+			"snps, g210-tc-6.00-40bit"
+		  complemented with the Controller IP version:
+			"snps, dwc-ufshcd-1.40a"
+		  complemented with the JEDEC version:
+			"jedec,ufs-1.1"
+			"jedec,ufs-2.0"
+
+- reg		: <registers mapping>
+- interrupts	: <interrupt mapping for UFS host controller IRQ>
+
+Example for a setup using a 1.40a DWC Controller with a 6.00 G210 40-bit TC:
+	dwc_ufs@d0000000 {
+		compatible = "snps, g210-tc-6.00-40bit",
+			     "snps, dwc-ufshcd-1.40a",
+			     "jedec,ufs-2.0";
+		reg = < 0xd0000000 0x10000 >;
+		interrupts = < 24 >;
+	};
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 9d218f9..5cfa87b 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -90,3 +90,12 @@ config SCSI_UFS_DWC
 config SCSI_UFS_DWC_TC
 	bool
 	select SCSI_UFS_DWC
+
+config SCSI_UFS_DWC_TC_PLATFORM
+	tristate "DesignWare platform support using a G210 Test Chip"
+	depends on SCSI_UFSHCD_PLATFORM
+	select SCSI_UFS_DWC_TC
+	---help---
+	  Synopsys Test Chip is a PHY for prototyping purposes.
+
+	  If unsure, say N."
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 9468d7b..a977fe0 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -1,6 +1,7 @@
 # UFSHCD makefile
 obj-$(CONFIG_SCSI_UFS_DWC) += ufshcd-dwc.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC) += tc-dwc-g210.o
+obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
diff --git a/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c b/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
new file mode 100644
index 0000000..1193a30
--- /dev/null
+++ b/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
@@ -0,0 +1,113 @@
+/*
+ * Synopsys G210 Test Chip driver
+ *
+ * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
+ *
+ * Authors: Joao Pinto <jpinto@synopsys.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/delay.h>
+
+#include "ufshcd-pltfrm.h"
+#include "ufshcd-dwc.h"
+#include "tc-dwc-g210.h"
+
+/**
+ * UFS DWC specific variant operations
+ */
+static struct ufs_hba_variant_ops tc_dwc_g210_20bit_pltfm_hba_vops = {
+	.name                   = "tc-dwc-g210-pltfm",
+	.link_startup_notify	= ufshcd_dwc_link_startup_notify,
+	.phy_initialization = tc_dwc_g210_config_20_bit,
+};
+
+static struct ufs_hba_variant_ops tc_dwc_g210_40bit_pltfm_hba_vops = {
+	.name                   = "tc-dwc-g210-pltfm",
+	.link_startup_notify	= ufshcd_dwc_link_startup_notify,
+	.phy_initialization = tc_dwc_g210_config_40_bit,
+};
+
+static const struct of_device_id tc_dwc_g210_pltfm_match[] = {
+	{
+		.compatible = "snps, g210-tc-6.00-20bit",
+		.data = &tc_dwc_g210_20bit_pltfm_hba_vops,
+	},
+	{
+		.compatible = "snps, g210-tc-6.00-40bit",
+		.data = &tc_dwc_g210_40bit_pltfm_hba_vops,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, tc_dwc_g210_pltfm_match);
+
+/**
+ * tc_dwc_g210_pltfm_probe()
+ * @pdev: pointer to platform device structure
+ *
+ */
+static int tc_dwc_g210_pltfm_probe(struct platform_device *pdev)
+{
+	int err;
+	const struct of_device_id *of_id;
+	struct ufs_hba_variant_ops *vops;
+	struct device *dev = &pdev->dev;
+
+        of_id = of_match_node(tc_dwc_g210_pltfm_match, dev->of_node);
+        vops = (struct ufs_hba_variant_ops *)of_id->data;
+
+	/* Perform generic probe */
+	err = ufshcd_pltfrm_init(pdev, vops);
+	if (err)
+		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
+
+	return err;
+}
+
+/**
+ * tc_dwc_g210_pltfm_remove()
+ * @pdev: pointer to platform device structure
+ *
+ */
+static int tc_dwc_g210_pltfm_remove(struct platform_device *pdev)
+{
+	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+
+	pm_runtime_get_sync(&(pdev)->dev);
+	ufshcd_remove(hba);
+
+	return 0;
+}
+
+static const struct dev_pm_ops tc_dwc_g210_pltfm_pm_ops = {
+	.suspend	= ufshcd_pltfrm_suspend,
+	.resume		= ufshcd_pltfrm_resume,
+	.runtime_suspend = ufshcd_pltfrm_runtime_suspend,
+	.runtime_resume  = ufshcd_pltfrm_runtime_resume,
+	.runtime_idle    = ufshcd_pltfrm_runtime_idle,
+};
+
+static struct platform_driver tc_dwc_g210_pltfm_driver = {
+	.probe		= tc_dwc_g210_pltfm_probe,
+	.remove		= tc_dwc_g210_pltfm_remove,
+	.shutdown = ufshcd_pltfrm_shutdown,
+	.driver		= {
+		.name	= "tc-dwc-g210-pltfm",
+		.pm	= &tc_dwc_g210_pltfm_pm_ops,
+		.of_match_table	= of_match_ptr(tc_dwc_g210_pltfm_match),
+	},
+};
+
+module_platform_driver(tc_dwc_g210_pltfm_driver);
+
+MODULE_ALIAS("platform:tc-dwc-g210-pltfm");
+MODULE_DESCRIPTION("Synopsys Test Chip G210 platform glue driver");
+MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
1.8.1.5
