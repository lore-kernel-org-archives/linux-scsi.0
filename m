From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v16 8/9] add TC G210 platform driver
Date: Wed, 11 May 2016 12:21:32 +0100
Message-ID: <9bbb5f2917016b53371cef6952c9d6772ad06895.1462963164.git.jpinto@synopsys.com>
References: <cover.1462963164.git.jpinto@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:52701 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbcEKLVy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2016 07:21:54 -0400
In-Reply-To: <cover.1462963164.git.jpinto@synopsys.com>
In-Reply-To: <cover.1462963164.git.jpinto@synopsys.com>
References: <cover.1462963164.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>

This patch adds a glue platform driver for the Synopsys G210 Test Chip.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
Changes v15->v16 (Martin K. Petersen):
- The glue driver Makefile entry calls the dwc and tc objects directly.
Changes v13->v15:
- Nothing changed (just to keep up with patch set version).
Changes v12->v13 (Rob Herring):
- Removed spaces from the compatibility string (pltfm driver and DT bindings)
- Removed underscores from the node descriptor
Changes v11->v12 (Tomas Winkler):
- custom_phy_initialization replaced by phy_initialization
Changes v10->v11 (Arnd Bergmann):
- vops structs are now passed in .data
Changes v0->v10:
- This patch only appeared in v10

 .../devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt |  26 +++++
 drivers/scsi/ufs/Kconfig                           |   8 ++
 drivers/scsi/ufs/Makefile                          |   1 +
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c              | 113 +++++++++++++++++++++
 4 files changed, 148 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt
 create mode 100644 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c

diff --git a/Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt b/Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt
new file mode 100644
index 0000000..71c0777
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
+			"snps,g210-tc-6.00-20bit"
+			"snps,g210-tc-6.00-40bit"
+		  complemented with the Controller IP version:
+			"snps,dwc-ufshcd-1.40a"
+		  complemented with the JEDEC version:
+			"jedec,ufs-1.1"
+			"jedec,ufs-2.0"
+
+- reg		: <registers mapping>
+- interrupts	: <interrupt mapping for UFS host controller IRQ>
+
+Example for a setup using a 1.40a DWC Controller with a 6.00 G210 40-bit TC:
+	dwc-ufs@d0000000 {
+		compatible = "snps,g210-tc-6.00-40bit",
+			     "snps,dwc-ufshcd-1.40a",
+			     "jedec,ufs-2.0";
+		reg = < 0xd0000000 0x10000 >;
+		interrupts = < 24 >;
+	};
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 097894a..81fdfb3 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -72,6 +72,14 @@ config SCSI_UFSHCD_PLATFORM
 
 	  If unsure, say N.
 
+config SCSI_UFS_DWC_TC_PLATFORM
+	tristate "DesignWare platform support using a G210 Test Chip"
+	depends on SCSI_UFSHCD_PLATFORM
+	---help---
+	  Synopsys Test Chip is a PHY for prototyping purposes.
+
+	  If unsure, say N.
+
 config SCSI_UFS_QCOM
 	tristate "QCOM specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && ARCH_QCOM
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 8303bcc..d5774c6 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -1,4 +1,5 @@
 # UFSHCD makefile
+obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
diff --git a/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c b/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
new file mode 100644
index 0000000..69b7036
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
+		.compatible = "snps,g210-tc-6.00-20bit",
+		.data = &tc_dwc_g210_20bit_pltfm_hba_vops,
+	},
+	{
+		.compatible = "snps,g210-tc-6.00-40bit",
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
+	of_id = of_match_node(tc_dwc_g210_pltfm_match, dev->of_node);
+	vops = (struct ufs_hba_variant_ops *)of_id->data;
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

