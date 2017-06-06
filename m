From: Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V2 2/2] scsi: ufshcd-intel-pci: Add PCI driver for Intel Host controllers
Date: Tue,  6 Jun 2017 09:48:51 +0300
Message-ID: <1496731731-19820-2-git-send-email-adrian.hunter@intel.com>
References: <e9c987425ac32ff48bf87faa104a0a12@codeaurora.org>
 <1496731731-19820-1-git-send-email-adrian.hunter@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:6472 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750978AbdFFGyx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Jun 2017 02:54:53 -0400
In-Reply-To: <1496731731-19820-1-git-send-email-adrian.hunter@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Szymon Mielczarek <szymonx.mielczarek@intel.com>, Michal Potomski <michalx.potomski@intel.com>, Grzegorz Janca <grzegorz.janca@intel.com>

From: Szymon Mielczarek <szymonx.mielczarek@intel.com>

This patch adds a glue pci driver for Intel UFS Host controllers.

Signed-off-by: Szymon Mielczarek <szymonx.mielczarek@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V2:

	Change variant name from intel to intel-pci


 drivers/scsi/ufs/Kconfig            |  11 +++
 drivers/scsi/ufs/Makefile           |   1 +
 drivers/scsi/ufs/ufshcd-intel-pci.c | 183 ++++++++++++++++++++++++++++++++++++
 3 files changed, 195 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufshcd-intel-pci.c

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index e27b4d4e6ae2..702420bc0fac 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -69,6 +69,17 @@ config SCSI_UFS_DWC_TC_PCI
 
 	  If unsure, say N.
 
+config SCSI_UFSHCD_INTEL_PCI
+	tristate "Intel PCI bus based UFS Controller support"
+	depends on SCSI_UFSHCD && PCI
+	---help---
+	This selects the Intel PCI UFS Host Controller Interface. Select this if
+	you have Intel UFS Host Controller with PCI Interface.
+
+	  If you have a controller with this interface, say Y or M here.
+
+	  If unsure, say N.
+
 config SCSI_UFSHCD_PLATFORM
 	tristate "Platform bus based UFS Controller support"
 	depends on SCSI_UFSHCD
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 6e77cb0bfee9..be817e1a6666 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -4,4 +4,5 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-d
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
+obj-$(CONFIG_SCSI_UFSHCD_INTEL_PCI) += ufshcd-intel-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
diff --git a/drivers/scsi/ufs/ufshcd-intel-pci.c b/drivers/scsi/ufs/ufshcd-intel-pci.c
new file mode 100644
index 000000000000..0b8dcce5ee3b
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-intel-pci.c
@@ -0,0 +1,183 @@
+/*
+ * Universal Flash Storage Intel Host controller PCI driver
+ *
+ * Copyright (c) 2017, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include "ufshcd.h"
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+
+static int ufs_intel_disable_lcc(struct ufs_hba *hba)
+{
+	u32 attr = UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE);
+	u32 lcc_enable = 0;
+
+	ufshcd_dme_get(hba, attr, &lcc_enable);
+	if (lcc_enable)
+		ufshcd_dme_set(hba, attr, 0);
+
+	return 0;
+}
+
+static int ufs_intel_link_startup_notify(struct ufs_hba *hba,
+					 enum ufs_notify_change_status status)
+{
+	int err = 0;
+
+	switch (status) {
+	case PRE_CHANGE:
+		err = ufs_intel_disable_lcc(hba);
+		break;
+	case POST_CHANGE:
+		break;
+	default:
+		break;
+	}
+
+	return err;
+}
+
+static struct ufs_hba_variant_ops ufs_intel_hba_vops = {
+	.name                   = "intel-pci",
+	.link_startup_notify	= ufs_intel_link_startup_notify,
+};
+
+#ifdef CONFIG_PM_SLEEP
+static int ufs_intel_suspend(struct device *dev)
+{
+	return ufshcd_system_suspend(dev_get_drvdata(dev));
+}
+
+static int ufs_intel_resume(struct device *dev)
+{
+	return ufshcd_system_resume(dev_get_drvdata(dev));
+}
+#endif /* !CONFIG_PM_SLEEP */
+
+#ifdef CONFIG_PM
+static int ufs_intel_runtime_suspend(struct device *dev)
+{
+	return ufshcd_runtime_suspend(dev_get_drvdata(dev));
+}
+
+static int ufs_intel_runtime_resume(struct device *dev)
+{
+	return ufshcd_runtime_resume(dev_get_drvdata(dev));
+}
+
+static int ufs_intel_runtime_idle(struct device *dev)
+{
+	return ufshcd_runtime_idle(dev_get_drvdata(dev));
+}
+#endif /* !CONFIG_PM */
+
+static void ufs_intel_shutdown(struct pci_dev *pdev)
+{
+	ufshcd_shutdown((struct ufs_hba *)pci_get_drvdata(pdev));
+}
+
+static void ufs_intel_remove(struct pci_dev *pdev)
+{
+	struct ufs_hba *hba = pci_get_drvdata(pdev);
+
+	pm_runtime_forbid(&pdev->dev);
+	pm_runtime_get_noresume(&pdev->dev);
+	ufshcd_remove(hba);
+	ufshcd_dealloc_host(hba);
+}
+
+static int ufs_intel_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct ufs_hba *hba;
+	void __iomem *mmio_base;
+	int err;
+
+	dev_info(&pdev->dev, "UFS controller found [%04x:%04x]\n",
+		 (int)pdev->vendor, (int)pdev->device);
+
+	err = pcim_enable_device(pdev);
+	if (err)
+		return err;
+
+	pci_set_master(pdev);
+
+	err = pcim_iomap_regions(pdev, 1 << 0, UFSHCD);
+	if (err < 0)
+		return err;
+
+	mmio_base = pcim_iomap_table(pdev)[0];
+
+	err = ufshcd_alloc_host(&pdev->dev, &hba);
+	if (err)
+		return err;
+
+	hba->vops = &ufs_intel_hba_vops;
+
+	err = ufshcd_init(hba, mmio_base, pdev->irq);
+	if (err) {
+		dev_err(&pdev->dev, "Initialization failed\n");
+		goto out_dealloc;
+	}
+
+	pci_set_drvdata(pdev, hba);
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_allow(&pdev->dev);
+
+	return 0;
+
+out_dealloc:
+	ufshcd_dealloc_host(hba);
+	return err;
+}
+
+static const struct dev_pm_ops ufs_intel_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(ufs_intel_suspend,
+				ufs_intel_resume)
+	SET_RUNTIME_PM_OPS(ufs_intel_runtime_suspend,
+			   ufs_intel_runtime_resume,
+			   ufs_intel_runtime_idle)
+};
+
+#define PCI_CLASS_STORAGE_UFSHCI 0x010901
+
+#define UFSHCD_INTEL_PCI_UFSHCI_DEVICE() { \
+	.vendor      = PCI_VENDOR_ID_INTEL, \
+	.device      = PCI_ANY_ID, \
+	.subvendor   = PCI_ANY_ID, \
+	.subdevice   = PCI_ANY_ID, \
+	.class       = PCI_CLASS_STORAGE_UFSHCI, \
+	.class_mask  = ~0, \
+}
+
+static const struct pci_device_id ufs_intel_tbl[] = {
+	UFSHCD_INTEL_PCI_UFSHCI_DEVICE(),
+	{ }	/* terminate list */
+};
+MODULE_DEVICE_TABLE(pci, ufs_intel_tbl);
+
+static struct pci_driver ufs_intel_driver = {
+	.name       = "ufshcd-intel-pci",
+	.id_table   = ufs_intel_tbl,
+	.probe      = ufs_intel_probe,
+	.remove     = ufs_intel_remove,
+	.shutdown   = ufs_intel_shutdown,
+	.driver     = {
+		.pm = &ufs_intel_pm_ops
+	},
+};
+
+module_pci_driver(ufs_intel_driver);
+
+MODULE_AUTHOR("Szymon Mielczarek <szymonx.mielczarek@intel.com>");
+MODULE_DESCRIPTION("Intel UFS host controller PCI glue driver");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1
