From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v12 9/9] add TC G210 pci driver
Date: Thu, 31 Mar 2016 19:57:22 +0100
Message-ID: <f133c86419f18d60dfea7391b4c7b51ccda4b832.1459448160.git.jpinto@synopsys.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1459448160.git.jpinto@synopsys.com>
In-Reply-To: <cover.1459448160.git.jpinto@synopsys.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tomas.winkler@intel.com
Cc: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, arnd@arndb.de, mark.rutland@arm.com, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds a glue pci driver for the Synopsys G210 Test Chip.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
Changes v10->v12 (Tomas Winkler):
- custom_phy_initialization replaced by phy_initialization
Changes v10->v11 (Arnd Bergmann):
- tc_type is now initialized to TC_G210_INV
- probe function checks if the test chip version is specified
Changes v0->v10:
- This patch only appeared in v10

 drivers/scsi/ufs/Kconfig           |   9 ++
 drivers/scsi/ufs/Makefile          |   1 +
 drivers/scsi/ufs/tc-dwc-g210-pci.c | 181 +++++++++++++++++++++++++++++++++++++
 3 files changed, 191 insertions(+)
 create mode 100644 drivers/scsi/ufs/tc-dwc-g210-pci.c

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 5cfa87b..5a3fde7 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -99,3 +99,12 @@ config SCSI_UFS_DWC_TC_PLATFORM
 	  Synopsys Test Chip is a PHY for prototyping purposes.
 
 	  If unsure, say N."
+
+config SCSI_UFS_DWC_TC_PCI
+	tristate "DesignWare pci support using a G210 Test Chip"
+	depends on SCSI_UFSHCD_PCI
+	select SCSI_UFS_DWC_TC
+	---help---
+	  Synopsys Test Chip is a PHY for prototyping purposes.
+
+	  If unsure, say N."
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index a977fe0..5303d85 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -2,6 +2,7 @@
 obj-$(CONFIG_SCSI_UFS_DWC) += ufshcd-dwc.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC) += tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o
+obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
diff --git a/drivers/scsi/ufs/tc-dwc-g210-pci.c b/drivers/scsi/ufs/tc-dwc-g210-pci.c
new file mode 100644
index 0000000..0667c76
--- /dev/null
+++ b/drivers/scsi/ufs/tc-dwc-g210-pci.c
@@ -0,0 +1,181 @@
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
+#include "ufshcd.h"
+#include "ufshcd-dwc.h"
+#include "tc-dwc-g210.h"
+
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+
+/* Test Chip type expected values */
+#define TC_G210_20BIT 20
+#define TC_G210_40BIT 40
+#define TC_G210_INV 0
+
+static int tc_type = TC_G210_INV;
+module_param(tc_type, int, 0);
+MODULE_PARM_DESC(tc_type, "Test Chip Type (20 = 20-bit, 40 = 40-bit)");
+
+static int tc_dwc_g210_pci_suspend(struct device *dev)
+{
+	return ufshcd_system_suspend(dev_get_drvdata(dev));
+}
+
+static int tc_dwc_g210_pci_resume(struct device *dev)
+{
+	return ufshcd_system_resume(dev_get_drvdata(dev));
+}
+
+static int tc_dwc_g210_pci_runtime_suspend(struct device *dev)
+{
+	return ufshcd_runtime_suspend(dev_get_drvdata(dev));
+}
+
+static int tc_dwc_g210_pci_runtime_resume(struct device *dev)
+{
+	return ufshcd_runtime_resume(dev_get_drvdata(dev));
+}
+
+static int tc_dwc_g210_pci_runtime_idle(struct device *dev)
+{
+	return ufshcd_runtime_idle(dev_get_drvdata(dev));
+}
+
+/**
+ * struct ufs_hba_dwc_vops - UFS DWC specific variant operations
+ */
+static struct ufs_hba_variant_ops tc_dwc_g210_pci_hba_vops = {
+	.name                   = "tc-dwc-g210-pci",
+	.link_startup_notify	= ufshcd_dwc_link_startup_notify,
+};
+
+/**
+ * tc_dwc_g210_pci_shutdown - main function to put the controller in reset state
+ * @pdev: pointer to PCI device handle
+ */
+static void tc_dwc_g210_pci_shutdown(struct pci_dev *pdev)
+{
+	ufshcd_shutdown((struct ufs_hba *)pci_get_drvdata(pdev));
+}
+
+/**
+ * tc_dwc_g210_pci_remove - de-allocate PCI/SCSI host and host memory space
+ *		data structure memory
+ * @pdev - pointer to PCI handle
+ */
+static void tc_dwc_g210_pci_remove(struct pci_dev *pdev)
+{
+	struct ufs_hba *hba = pci_get_drvdata(pdev);
+
+	pm_runtime_forbid(&pdev->dev);
+	pm_runtime_get_noresume(&pdev->dev);
+	ufshcd_remove(hba);
+}
+
+/**
+ * tc_dwc_g210_pci_probe - probe routine of the driver
+ * @pdev: pointer to PCI device handle
+ * @id: PCI device id
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int
+tc_dwc_g210_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct ufs_hba *hba;
+	void __iomem *mmio_base;
+	int err;
+
+	/* Check Test Chip type and set the specific setup routine */
+	if (tc_type == TC_G210_20BIT) {
+		tc_dwc_g210_pci_hba_vops.phy_initialization =
+						tc_dwc_g210_config_20_bit;
+	} else if (tc_type == TC_G210_40BIT) {
+		tc_dwc_g210_pci_hba_vops.phy_initialization =
+						tc_dwc_g210_config_40_bit;
+	} else {
+		dev_err(&pdev->dev, "test chip version not specified\n");
+		return -EPERM;
+	}
+
+	err = pcim_enable_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "pcim_enable_device failed\n");
+		return err;
+	}
+
+	pci_set_master(pdev);
+
+	err = pcim_iomap_regions(pdev, 1 << 0, UFSHCD);
+	if (err < 0) {
+		dev_err(&pdev->dev, "request and iomap failed\n");
+		return err;
+	}
+
+	mmio_base = pcim_iomap_table(pdev)[0];
+
+	err = ufshcd_alloc_host(&pdev->dev, &hba);
+	if (err) {
+		dev_err(&pdev->dev, "Allocation failed\n");
+		return err;
+	}
+
+	INIT_LIST_HEAD(&hba->clk_list_head);
+
+	hba->vops = &tc_dwc_g210_pci_hba_vops;
+
+	err = ufshcd_init(hba, mmio_base, pdev->irq);
+	if (err) {
+		dev_err(&pdev->dev, "Initialization failed\n");
+		return err;
+	}
+
+	pci_set_drvdata(pdev, hba);
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_allow(&pdev->dev);
+
+	return 0;
+}
+
+static const struct dev_pm_ops tc_dwc_g210_pci_pm_ops = {
+	.suspend	= tc_dwc_g210_pci_suspend,
+	.resume		= tc_dwc_g210_pci_resume,
+	.runtime_suspend = tc_dwc_g210_pci_runtime_suspend,
+	.runtime_resume  = tc_dwc_g210_pci_runtime_resume,
+	.runtime_idle    = tc_dwc_g210_pci_runtime_idle,
+};
+
+static const struct pci_device_id tc_dwc_g210_pci_tbl[] = {
+	{ PCI_VENDOR_ID_SYNOPSYS, 0xB101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VENDOR_ID_SYNOPSYS, 0xB102, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ }	/* terminate list */
+};
+
+MODULE_DEVICE_TABLE(pci, tc_dwc_g210_pci_tbl);
+
+static struct pci_driver tc_dwc_g210_pci_driver = {
+	.name = UFSHCD,
+	.id_table = tc_dwc_g210_pci_tbl,
+	.probe = tc_dwc_g210_pci_probe,
+	.remove = tc_dwc_g210_pci_remove,
+	.shutdown = tc_dwc_g210_pci_shutdown,
+	.driver = {
+		.pm = &tc_dwc_g210_pci_pm_ops
+	},
+};
+
+module_pci_driver(tc_dwc_g210_pci_driver);
+
+MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
+MODULE_DESCRIPTION("Synopsys Test Chip G210 PCI glue driver");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
1.8.1.5
