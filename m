From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v7 3/3] add support for DWC UFS Host Controller
Date: Thu, 11 Feb 2016 12:13:06 +0000
Message-ID: <ee97e9b0ece0d819debe403c752d233c6267e02e.1455192008.git.jpinto@synopsys.com>
References: <cover.1455192008.git.jpinto@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1455192008.git.jpinto@synopsys.com>
In-Reply-To: <cover.1455192008.git.jpinto@synopsys.com>
References: <cover.1455192008.git.jpinto@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, arnd@arndb.de, mark.rutland@arm.com
Cc: gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

This patch has the goal to add support for DesignWare UFS Controller
specific operations and to add specific platform and pci drivers.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
Changes v6->v7 (Arnd Bergmann):
- Changed DT node name (to ufs only) and the memory address (to 0xd000000)
- Removed CONFIG_PM from the PCI glue driver (pm.h already does this)
- No other changes are necessary in ufshcd.c because of the link up notify
 function usage (it is simpler now)
- Removed the PHY mentioning since the Test Chip is not a real PHY for real
 world usage, since it is a test chip for prototyping with a very specific
 usage
- Added again the Test Chip 20-bit option
Changes v5->v6:
- Patch bad format fixed
Changes v4->v5 (Akinobu Mita):
- All functions used only locally in ufshcd-dwc are now declared as static
- ufshcd_dwc_configuration() was removed in ufshcd-dwc and a notify
 function (ufshcd_dwc_link_startup_notify) was created to deal with the
 DWC specific init routines
- 20-bit RMMI option was removed from Kconfig. Now if MPHY TC is selected
 and 40-bit is not then it assumes a 20-bit config
Changes v3->v4 (Arnd Bergmann and Mark Rutland):
- SCSI_UFS_DWC_HOOKS is now silent and selected by the SCSI_UFS_DWC_PLAT
 or SCSI_UFS_DWC_PCI
- Compatibility string has the ufs core version for info purposes since
 the driver is capable of getting the controller version from its 
 registers
- Created ufs-dwc-pci glue driver with specific DWC data
- MPHY configuration remains in the ufshcd-dwc since it is unipro
 attribute writting only not following the a linux phy framework logic
Changes v2->v3 (Julian Calaby):
- Implement a common DWC code to be used by the platform and pci glue
 drivers
- Synopsys ID & Class added to the existing pci driver and specific DWC
 was also added to the pci driver
Changes v1->v2 (Akinobu Mita):
- Implement a platform driver that uses the existing UFS core driver
- Add DWC specific code to the existing UFS core driver

 Documentation/devicetree/bindings/ufs/ufs-dwc.txt |  17 +
 MAINTAINERS                                       |   6 +
 drivers/scsi/ufs/Kconfig                          |  51 ++
 drivers/scsi/ufs/Makefile                         |   3 +
 drivers/scsi/ufs/ufs-dwc-pci.c                    | 172 +++++
 drivers/scsi/ufs/ufs-dwc.c                        | 102 +++
 drivers/scsi/ufs/ufshcd-dwc.c                     | 739 ++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-dwc.h                     |  18 +
 drivers/scsi/ufs/ufshci-dwc.h                     |  42 ++
 drivers/scsi/ufs/unipro.h                         |  39 ++
 10 files changed, 1189 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-dwc.txt
 create mode 100644 drivers/scsi/ufs/ufs-dwc-pci.c
 create mode 100644 drivers/scsi/ufs/ufs-dwc.c
 create mode 100644 drivers/scsi/ufs/ufshcd-dwc.c
 create mode 100644 drivers/scsi/ufs/ufshcd-dwc.h
 create mode 100644 drivers/scsi/ufs/ufshci-dwc.h

diff --git a/Documentation/devicetree/bindings/ufs/ufs-dwc.txt b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
new file mode 100644
index 0000000..3cbfd77
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
@@ -0,0 +1,17 @@
+* Universal Flash Storage (UFS) DesignWare Host Controller
+
+DWC_UFSHC nodes are defined to describe on-chip UFS host controllers.
+Each UFS controller instance should have its own node.
+
+Required properties:
+- compatible        : compatible string ("snps,ufshcd-1.0", "snps,ufshcd-1.1"
+  or "snps,ufshcd-2.0")
+- reg               : <registers mapping>
+- interrupts        : <interrupt mapping for UFS host controller IRQ>
+
+Example:
+	ufs@0xd0000000 {
+		compatible = "snps,ufshcd-2.0";
+		reg = < 0xd0000000 0x10000 >;
+		interrupts = < 24 >;
+	};
diff --git a/MAINTAINERS b/MAINTAINERS
index d2f94e2..3db3c4c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11006,6 +11006,12 @@ S:	Supported
 F:	Documentation/scsi/ufs.txt
 F:	drivers/scsi/ufs/
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER DWC HOOKS
+M:	Joao Pinto <Joao.Pinto@synopsys.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/ufs/*dwc*
+
 UNSORTED BLOCK IMAGES (UBI)
 M:	Artem Bityutskiy <dedekind1@gmail.com>
 M:	Richard Weinberger <richard@nod.at>
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 5f45307..35e9ddf 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -83,3 +83,54 @@ config SCSI_UFS_QCOM
 
 	  Select this if you have UFS controller on QCOM chipset.
 	  If unsure, say N.
+
+config SCSI_UFS_DWC_HOOKS
+	bool
+
+config SCSI_UFS_DWC_PLAT
+	tristate "DesignWare UFS controller platform glue driver"
+	depends on SCSI_UFSHCD_PLATFORM
+	select SCSI_UFS_DWC_HOOKS
+	help
+	  This selects the DesignWare UFS host controller platform glue driver.
+
+	  Select this if you have a DesignWare UFS controller on Platform bus.
+	  If unsure, say N.
+
+config SCSI_UFS_DWC_PCI
+	tristate "DesignWare UFS controller pci glue driver"
+	depends on SCSI_UFSHCD_PCI
+	select SCSI_UFS_DWC_HOOKS
+	help
+	  This selects the DesignWare UFS host controller pci glue driver.
+
+	  Select this if you have a DesignWare UFS controller on pci bus.
+	  If unsure, say N.
+
+config SCSI_UFS_DWC_TC
+	bool "Support for the Synopsys Test Chip"
+	depends on SCSI_UFS_DWC_HOOKS && (SCSI_UFSHCD_PCI || SCSI_UFS_DWC_PLAT)
+	---help---
+	  Synopsys Test Chip is a Phy for prototyping purposes.
+	  This selects the support for the Synopsys Test Chip.
+
+	  Select this if you have a Synopsys Test Chip.
+	  If unsure, say N.
+
+config SCSI_UFS_DWC_20BIT_RMMI
+	bool "20-bit RMMI support"
+	depends on SCSI_UFS_DWC_TC
+	---help---
+	  This specifies that the Synopsys Test Chip supports 20-bit RMMI.
+
+	  Select this if you are using a 20-bit RMMI Synopsys Test Chip.
+	  If unsure, say N.
+
+config SCSI_UFS_DWC_40BIT_RMMI
+	bool "40-bit RMMI support"
+	depends on SCSI_UFS_DWC_TC
+	---help---
+	  Synopsys Test Chip is a Phy for prototyping purposes.
+
+	  Select this if you are using a 40-bit RMMI Synopsys Test Chip.
+	  If unsure, say N.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 8303bcc..bab8c05 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -1,4 +1,7 @@
 # UFSHCD makefile
+obj-$(CONFIG_SCSI_UFS_DWC_HOOKS) += ufshcd-dwc.o
+obj-$(CONFIG_SCSI_UFS_DWC_PLAT) += ufs-dwc.o
+obj-$(CONFIG_SCSI_UFS_DWC_PCI) += ufs-dwc-pci.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
diff --git a/drivers/scsi/ufs/ufs-dwc-pci.c b/drivers/scsi/ufs/ufs-dwc-pci.c
new file mode 100644
index 0000000..845eb7e
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-dwc-pci.c
@@ -0,0 +1,172 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
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
+
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+
+/**
+ * ufs_dw_pci_suspend - suspend power management function
+ * @pdev: pointer to PCI device handle
+ * @state: power state
+ *
+ * Returns 0 if successful
+ * Returns non-zero otherwise
+ */
+static int ufs_dw_pci_suspend(struct device *dev)
+{
+	return ufshcd_system_suspend(dev_get_drvdata(dev));
+}
+
+/**
+ * ufs_dw_pci_resume - resume power management function
+ * @pdev: pointer to PCI device handle
+ *
+ * Returns 0 if successful
+ * Returns non-zero otherwise
+ */
+static int ufs_dw_pci_resume(struct device *dev)
+{
+	return ufshcd_system_resume(dev_get_drvdata(dev));
+}
+
+static int ufs_dw_pci_runtime_suspend(struct device *dev)
+{
+	return ufshcd_runtime_suspend(dev_get_drvdata(dev));
+}
+static int ufs_dw_pci_runtime_resume(struct device *dev)
+{
+	return ufshcd_runtime_resume(dev_get_drvdata(dev));
+}
+static int ufs_dw_pci_runtime_idle(struct device *dev)
+{
+	return ufshcd_runtime_idle(dev_get_drvdata(dev));
+}
+
+/**
+ * struct ufs_hba_dwc_vops - UFS DWC specific variant operations
+ */
+static struct ufs_hba_variant_ops ufs_dwc_pci_hba_vops = {
+	.name                   = "ufshcd-dwc-pci",
+	.link_startup_notify	= ufshcd_dwc_link_startup_notify,
+};
+
+/**
+ * ufs_dw_pci_shutdown - main function to put the controller in reset state
+ * @pdev: pointer to PCI device handle
+ */
+static void ufs_dw_pci_shutdown(struct pci_dev *pdev)
+{
+	ufshcd_shutdown((struct ufs_hba *)pci_get_drvdata(pdev));
+}
+
+/**
+ * ufs_dw_pci_remove - de-allocate PCI/SCSI host and host memory space
+ *		data structure memory
+ * @pdev - pointer to PCI handle
+ */
+static void ufs_dw_pci_remove(struct pci_dev *pdev)
+{
+	struct ufs_hba *hba = pci_get_drvdata(pdev);
+
+	pm_runtime_forbid(&pdev->dev);
+	pm_runtime_get_noresume(&pdev->dev);
+	ufshcd_remove(hba);
+}
+
+/**
+ * ufs_dw_pci_probe - probe routine of the driver
+ * @pdev: pointer to PCI device handle
+ * @id: PCI device id
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int
+ufs_dw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct ufs_hba *hba;
+	void __iomem *mmio_base;
+	int err;
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
+	hba->vops = &ufs_dwc_pci_hba_vops;
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
+static const struct dev_pm_ops ufs_dw_pci_pm_ops = {
+	.suspend	= ufs_dw_pci_suspend,
+	.resume		= ufs_dw_pci_resume,
+	.runtime_suspend = ufs_dw_pci_runtime_suspend,
+	.runtime_resume  = ufs_dw_pci_runtime_resume,
+	.runtime_idle    = ufs_dw_pci_runtime_idle,
+};
+
+static const struct pci_device_id ufs_dw_pci_tbl[] = {
+	{ PCI_VENDOR_ID_SYNOPSYS, 0xB101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VENDOR_ID_SYNOPSYS, 0xB102, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ }	/* terminate list */
+};
+
+MODULE_DEVICE_TABLE(pci, ufs_dw_pci_tbl);
+
+static struct pci_driver ufs_dw_pci_driver = {
+	.name = UFSHCD,
+	.id_table = ufs_dw_pci_tbl,
+	.probe = ufs_dw_pci_probe,
+	.remove = ufs_dw_pci_remove,
+	.shutdown = ufs_dw_pci_shutdown,
+	.driver = {
+		.pm = &ufs_dw_pci_pm_ops
+	},
+};
+
+module_pci_driver(ufs_dw_pci_driver);
+
+MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
+MODULE_DESCRIPTION("DesignWare UFS host controller PCI glue driver");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/scsi/ufs/ufs-dwc.c b/drivers/scsi/ufs/ufs-dwc.c
new file mode 100644
index 0000000..7b2fc91
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-dwc.c
@@ -0,0 +1,102 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
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
+
+/**
+ * struct ufs_hba_dwc_vops - UFS DWC specific variant operations
+ *
+ */
+static struct ufs_hba_variant_ops ufs_dwc_hba_vops = {
+	.name                   = "ufshcd-dwc",
+	.link_startup_notify	= ufshcd_dwc_link_startup_notify,
+};
+
+/**
+ * ufs_dwc_probe()
+ * @pdev: pointer to platform device structure
+ *
+ */
+static int ufs_dwc_probe(struct platform_device *pdev)
+{
+	int err;
+	struct device *dev = &pdev->dev;
+
+	/* Perform generic probe */
+	err = ufshcd_pltfrm_init(pdev, &ufs_dwc_hba_vops);
+	if (err)
+		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
+
+	return err;
+}
+
+/**
+ * ufs_dwc_remove()
+ * @pdev: pointer to platform device structure
+ *
+ */
+static int ufs_dwc_remove(struct platform_device *pdev)
+{
+	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+
+	pm_runtime_get_sync(&(pdev)->dev);
+	ufshcd_remove(hba);
+
+	return 0;
+}
+
+static const struct of_device_id ufs_dwc_match[] = {
+	{
+		.compatible = "snps,ufshcd-2.0"
+	},
+	{
+		.compatible = "snps,ufshcd-1.1"
+	},
+	{
+		.compatible = "snps,ufshcd-1.0"
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ufs_dwc_match);
+
+static const struct dev_pm_ops ufs_dwc_pm_ops = {
+	.suspend	= ufshcd_pltfrm_suspend,
+	.resume		= ufshcd_pltfrm_resume,
+	.runtime_suspend = ufshcd_pltfrm_runtime_suspend,
+	.runtime_resume  = ufshcd_pltfrm_runtime_resume,
+	.runtime_idle    = ufshcd_pltfrm_runtime_idle,
+};
+
+static struct platform_driver ufs_dwc_driver = {
+	.probe		= ufs_dwc_probe,
+	.remove		= ufs_dwc_remove,
+	.shutdown = ufshcd_pltfrm_shutdown,
+	.driver		= {
+		.name	= "ufshcd-dwc",
+		.pm	= &ufs_dwc_pm_ops,
+		.of_match_table	= of_match_ptr(ufs_dwc_match),
+	},
+};
+
+module_platform_driver(ufs_dwc_driver);
+
+MODULE_ALIAS("platform:ufshcd-dwc");
+MODULE_DESCRIPTION("DesignWare UFS Host platform glue driver");
+MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/scsi/ufs/ufshcd-dwc.c b/drivers/scsi/ufs/ufshcd-dwc.c
new file mode 100644
index 0000000..1972b5c
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-dwc.c
@@ -0,0 +1,739 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
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
+#include "unipro.h"
+
+#include "ufshcd-dwc.h"
+#include "ufshci-dwc.h"
+
+/**
+ * ufshcd_dwc_program_clk_div()
+ * This function programs the clk divider value. This value is needed to
+ * provide 1 microsecond tick to unipro layer.
+ * @hba: Private Structure pointer
+ * @divider_val: clock divider value to be programmed
+ *
+ */
+static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
+{
+	ufshcd_writel(hba, divider_val, DWC_UFS_REG_HCLKDIV);
+}
+
+/**
+ * ufshcd_dwc_link_is_up()
+ * Check if link is up
+ * @hba: private structure poitner
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
+{
+	int dme_result = 0;
+
+	ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
+
+	if (dme_result == UFSHCD_LINK_IS_UP) {
+		ufshcd_set_link_active(hba);
+		return 0;
+	}
+
+	return 1;
+}
+
+/**
+ * ufshcd_dwc_connection_setup()
+ * This function configures both the local side (host) and the peer side
+ * (device) unipro attributes to establish the connection to application/
+ * cport.
+ * This function is not required if the hardware is properly configured to
+ * have this connection setup on reset. But invoking this function does no
+ * harm and should be fine even working with any ufs device.
+ *
+ * @hba: pointer to drivers private data
+ *
+ * Returns 0 on success non-zero value on failure
+ */
+static int ufshcd_dwc_connection_setup(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	/* Local side Configuration */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 0);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID), 0);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), 0);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERDEVICEID), 1);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERCPORTID), 0);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS), 0);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTFLAGS), 0x6);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTMODE), 1);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 1);
+	if (ret)
+		goto out;
+
+
+	/* Peer side Configuration */
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 0);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(N_DEVICEID), 1);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), 1);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_PEERDEVICEID), 1);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_PEERCPORTID), 0);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS), 0);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CPORTFLAGS), 0x6);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CPORTMODE), 1);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 1);
+	if (ret)
+		goto out;
+
+out:
+	return ret;
+}
+
+#ifdef CONFIG_SCSI_UFS_DWC_40BIT_RMMI
+/**
+ * ufshcd_dwc_setup_40bit_rmmi()
+ * This function configures Synopsys TC specific atributes (40-bit RMMI)
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success or non-zero value on failure
+ */
+static int ufshcd_dwc_setup_40bit_rmmi(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	/* Common block Tx Global Hibernate Exit */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(TX_GLOBALHIBERNATE), 0x00);
+	if (ret)
+		goto out;
+
+	/* Common block Reference Clock Mode 26MHz */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(REFCLKMODE), 0x01);
+	if (ret)
+		goto out;
+
+	/* Common block DCO Target Frequency MAX PWM G1:7Mpbs */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CDIRECTCTRL6), 0x80);
+	if (ret)
+		goto out;
+
+	/* Common block TX and RX Div Factor is 4 7Mbps/40 = 175KHz */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBDIVFACTOR), 0x08);
+	if (ret)
+		goto out;
+
+	/* Common Block DC0 Ctrl 5*/
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBDCOCTRL5), 0x64);
+	if (ret)
+		goto out;
+
+	/* Common Block Program Tunning*/
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBPRGTUNING), 0x09);
+	if (ret)
+		goto out;
+
+	/* Common Block Real Time Observe Select - for debugging */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(RTOBSERVESELECT), 0x00);
+	if (ret)
+		goto out;
+
+	/* Lane 0 configuration*/
+
+	/* TX Reference Clock 26MHz */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_REFCLKFREQ,
+							SELIND_LN0_TX), 0x01);
+	if (ret)
+		goto out;
+
+	/* TX Configuration Clock Frequency Val; Divider setting */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_CFGCLKFREQVAL,
+							SELIND_LN0_TX), 0x19);
+	if (ret)
+		goto out;
+
+	/* TX 40-bit RMMI Interface */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGEXTRATTR,
+							SELIND_LN0_TX), 0x14);
+	if (ret)
+		goto out;
+
+	/* TX dither configuration */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(DITHERCTRL2,
+							SELIND_LN0_TX), 0xd6);
+	if (ret)
+		goto out;
+
+	/* RX Reference Clock 26MHz */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_REFCLKFREQ,
+							SELIND_LN0_RX), 0x01);
+	if (ret)
+		goto out;
+
+	/* RX Configuration Clock Frequency Val; Divider setting */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_CFGCLKFREQVAL,
+							SELIND_LN0_RX), 0x19);
+	if (ret)
+		goto out;
+
+	/* RX 40-bit RMMI Interface */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGWIDEINLN,
+							SELIND_LN0_RX), 4);
+	if (ret)
+		goto out;
+
+	/* RX Squelch Detector output is routed to RX hibern8 exit signal */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXCDR8,
+							SELIND_LN0_RX), 0x80);
+	if (ret)
+		goto out;
+
+	/* RX Squelch Detector output is routed to RX hibern8 exit signal */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXCDR8,
+							SELIND_LN0_RX), 0x80);
+	if (ret)
+		goto out;
+
+	/* Common block Direct Control 10 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(DIRECTCTRL10), 0x04);
+	if (ret)
+		goto out;
+
+	/* Common block Direct Control 19 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(DIRECTCTRL19), 0x02);
+	if (ret)
+		goto out;
+
+	/* RX Squelch Detector output is routed to RX hibern8 exit signal */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXCDR8,
+							SELIND_LN0_RX), 0x80);
+	if (ret)
+		goto out;
+
+	/* ENARXDIRECTCFG4 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG4,
+							SELIND_LN0_RX), 0x03);
+	if (ret)
+		goto out;
+
+	/* CFGRXOVR8 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR8,
+							SELIND_LN0_RX), 0x16);
+	if (ret)
+		goto out;
+
+	/* RXDIRECTCTRL2 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXDIRECTCTRL2,
+							SELIND_LN0_RX), 0x42);
+	if (ret)
+		goto out;
+
+	/* ENARXDIRECTCFG3 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG3,
+							SELIND_LN0_RX), 0xa4);
+	if (ret)
+		goto out;
+
+	/* RXCALCTRL */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXCALCTRL,
+							SELIND_LN0_RX), 0x01);
+	if (ret)
+		goto out;
+
+	/* ENARXDIRECTCFG2 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG2,
+							SELIND_LN0_RX), 0x01);
+	if (ret)
+		goto out;
+
+	/* CFGOVR4 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR4,
+							SELIND_LN0_RX), 0x28);
+	if (ret)
+		goto out;
+
+	/* RXSQCTRL */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXSQCTRL,
+							SELIND_LN0_RX), 0x1E);
+	if (ret)
+		goto out;
+
+	/* CFGOVR6 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR6,
+							SELIND_LN0_RX), 0x2f);
+	if (ret)
+		goto out;
+
+	/* CBPRGPLL2 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBPRGPLL2), 0x00);
+	if (ret)
+		goto out;
+
+out:
+	return ret;
+}
+
+#endif
+
+#ifdef CONFIG_SCSI_UFS_DWC_20BIT_RMMI
+/**
+ * ufshcd_dwc_setup_20bit_rmmi_lane0()
+ * This function configures Synopsys TC 20-bit RMMI Lane 0
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success or non-zero value on failure
+ */
+static int ufshcd_dwc_setup_20bit_rmmi_lane0(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	/* TX Reference Clock 26MHz */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_REFCLKFREQ,
+							SELIND_LN0_TX), 0x01);
+	if (ret)
+		goto out;
+
+	/* TX Configuration Clock Frequency Val; Divider setting */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_CFGCLKFREQVAL,
+							SELIND_LN0_TX), 0x19);
+	if (ret)
+		goto out;
+
+	/* RX Configuration Clock Frequency Val; Divider setting */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_CFGCLKFREQVAL,
+							SELIND_LN0_RX), 0x19);
+	if (ret)
+		goto out;
+
+	/* TX 20-bit RMMI Interface */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGEXTRATTR,
+							SELIND_LN0_TX), 0x12);
+	if (ret)
+		goto out;
+
+	/* TX dither configuration */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(DITHERCTRL2,
+							SELIND_LN0_TX), 0xd6);
+	if (ret)
+		goto out;
+
+	/* RX Reference Clock 26MHz */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_REFCLKFREQ,
+							SELIND_LN0_RX), 0x01);
+	if (ret)
+		goto out;
+
+	/* RX 20-bit RMMI Interface */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGWIDEINLN,
+							SELIND_LN0_RX), 2);
+	if (ret)
+		goto out;
+
+	/* RX Squelch Detector output is routed to RX hibern8 exit signal */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXCDR8,
+							SELIND_LN0_RX), 0x80);
+	if (ret)
+		goto out;
+
+	/* Common block Direct Control 10 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(DIRECTCTRL10), 0x04);
+	if (ret)
+		goto out;
+
+	/* Common block Direct Control 19 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(DIRECTCTRL19), 0x02);
+	if (ret)
+		goto out;
+
+	/* ENARXDIRECTCFG4 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG4,
+							SELIND_LN0_RX), 0x03);
+	if (ret)
+		goto out;
+
+	/* CFGRXOVR8 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR8,
+							SELIND_LN0_RX), 0x16);
+	if (ret)
+		goto out;
+
+	/* RXDIRECTCTRL2 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXDIRECTCTRL2,
+							SELIND_LN0_RX), 0x42);
+
+	if (ret)
+		goto out;
+
+	/* ENARXDIRECTCFG3 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG3,
+							SELIND_LN0_RX), 0xa4);
+
+	if (ret)
+		goto out;
+
+	/* RXCALCTRL */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXCALCTRL,
+							SELIND_LN0_RX), 0x01);
+	if (ret)
+		goto out;
+
+	/* ENARXDIRECTCFG2 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG2,
+							SELIND_LN0_RX), 0x01);
+	if (ret)
+		goto out;
+
+	/* CFGOVR4 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR4,
+							SELIND_LN0_RX), 0x28);
+	if (ret)
+		goto out;
+
+	/* RXSQCTRL */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXSQCTRL,
+							SELIND_LN0_RX), 0x1E);
+	if (ret)
+		goto out;
+
+	/* CFGOVR6 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR6,
+							SELIND_LN0_RX), 0x2f);
+	if (ret)
+		goto out;
+
+	/* CBPRGPLL2 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBPRGPLL2), 0x00);
+
+out:
+	return ret;
+}
+
+/**
+ * ufshcd_dwc_setup_20bit_rmmi_lane1()
+ * This function configures Synopsys TC 20-bit RMMI Lane 1
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success or non-zero value on failure
+ */
+static int ufshcd_dwc_setup_20bit_rmmi_lane1(struct ufs_hba *hba)
+{
+	int connected_rx_lanes = 0;
+	int connected_tx_lanes = 0;
+	int ret = 0;
+
+	/* Get the available lane count */
+	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES),
+			&connected_rx_lanes);
+	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
+			&connected_tx_lanes);
+
+	if (connected_tx_lanes == 2) {
+
+		/* TX Reference Clock 26MHz */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_REFCLKFREQ,
+							SELIND_LN1_TX), 0x0d);
+		if (ret)
+			goto out;
+
+		/* TX Configuration Clock Frequency Val; Divider setting */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_CFGCLKFREQVAL,
+							SELIND_LN1_TX), 0x19);
+		if (ret)
+			goto out;
+
+		/* TX 20-bit RMMI Interface */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGEXTRATTR,
+							SELIND_LN1_TX), 0x12);
+		if (ret)
+			goto out;
+
+		/* TX dither configuration */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(DITHERCTRL2,
+							SELIND_LN0_TX), 0xd6);
+		if (ret)
+			goto out;
+	}
+
+	if (connected_rx_lanes == 2) {
+
+		/* RX Reference Clock 26MHz */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_REFCLKFREQ,
+							SELIND_LN1_RX), 0x01);
+		if (ret)
+			goto out;
+
+		/* RX Configuration Clock Frequency Val; Divider setting */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_CFGCLKFREQVAL,
+							SELIND_LN1_RX), 0x19);
+		if (ret)
+			goto out;
+
+		/* RX 20-bit RMMI Interface */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGWIDEINLN,
+							SELIND_LN1_RX), 2);
+		if (ret)
+			goto out;
+
+		/* RX Squelch Detector output is routed to RX hibern8 exit
+		 * signal
+		 */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXCDR8,
+							SELIND_LN1_RX), 0x80);
+		if (ret)
+			goto out;
+
+		/* ENARXDIRECTCFG4 */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG4,
+							SELIND_LN1_RX), 0x03);
+		if (ret)
+			goto out;
+
+		/* CFGRXOVR8 */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR8,
+							SELIND_LN1_RX), 0x16);
+		if (ret)
+			goto out;
+
+		/* RXDIRECTCTRL2 */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXDIRECTCTRL2,
+							SELIND_LN1_RX), 0x42);
+		if (ret)
+			goto out;
+
+		/* ENARXDIRECTCFG3 */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG3,
+							SELIND_LN1_RX), 0xa4);
+		if (ret)
+			goto out;
+
+		/* RXCALCTRL */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXCALCTRL,
+							SELIND_LN1_RX), 0x01);
+		if (ret)
+			goto out;
+
+		/* ENARXDIRECTCFG2 */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG2,
+							SELIND_LN1_RX), 0x01);
+		if (ret)
+			goto out;
+
+		/* CFGOVR4 */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR4,
+							SELIND_LN1_RX), 0x28);
+		if (ret)
+			goto out;
+
+		/* RXSQCTRL */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXSQCTRL,
+							SELIND_LN1_RX), 0x1E);
+		if (ret)
+			goto out;
+
+		/* CFGOVR6 */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR6,
+							SELIND_LN1_RX), 0x2f);
+		if (ret)
+			goto out;
+	}
+
+out:
+	return ret;
+}
+
+/**
+ * ufshcd_dwc_setup_20bit_rmmi()
+ * This function configures Synopsys TC specific atributes (20-bit RMMI)
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success or non-zero value on failure
+ */
+static int ufshcd_dwc_setup_20bit_rmmi(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	/* Common block Tx Global Hibernate Exit */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(TX_GLOBALHIBERNATE), 0x00);
+	if (ret)
+		goto out;
+
+	/* Common block Reference Clock Mode 26MHz */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(REFCLKMODE), 0x01);
+	if (ret)
+		goto out;
+
+	/* Common block DCO Target Frequency MAX PWM G1:9Mpbs */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CDIRECTCTRL6), 0xc0);
+	if (ret)
+		goto out;
+
+	/* Common block TX and RX Div Factor is 4 7Mbps/20 = 350KHz */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBDIVFACTOR), 0x44);
+	if (ret)
+		goto out;
+
+	/* Common Block DC0 Ctrl 5*/
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBDCOCTRL5), 0x64);
+	if (ret)
+		goto out;
+
+	/* Common Block Program Tunning*/
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBPRGTUNING), 0x09);
+	if (ret)
+		goto out;
+
+	/* Common Block Real Time Observe Select - for debugging */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(RTOBSERVESELECT), 0x00);
+	if (ret)
+		goto out;
+
+	/* Lane 0 configuration*/
+	ret = ufshcd_dwc_setup_20bit_rmmi_lane0(hba);
+	if (ret)
+		goto out;
+
+	/* Lane 1 configuration*/
+	ret = ufshcd_dwc_setup_20bit_rmmi_lane1(hba);
+	if (ret)
+		goto out;
+
+out:
+	return ret;
+}
+#endif
+
+/**
+ * ufshcd_dwc_setup_tc()
+ * This function configures Local (host) Synopsys TC specific attributes
+ *
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success non-zero value on failure
+ */
+static int ufshcd_dwc_setup_tc(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+#ifdef CONFIG_SCSI_UFS_DWC_40BIT_RMMI
+	dev_info(hba->dev, "Configuring Test Chip 40-bit RMMI");
+	ret = ufshcd_dwc_setup_40bit_rmmi(hba);
+	if (ret) {
+		dev_err(hba->dev, "Configuration failed");
+		goto out;
+	}
+#endif
+
+#ifdef CONFIG_SCSI_UFS_DWC_20BIT_RMMI
+	dev_info(hba->dev, "Configuring Test Chip 20-bit RMMI");
+	ret = ufshcd_dwc_setup_20bit_rmmi(hba);
+	if (ret) {
+		dev_err(hba->dev, "Configuration failed");
+		goto out;
+	}
+#endif
+	/* To write Shadow register bank to effective configuration block */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(VS_MPHYCFGUPDT), 0x01);
+	if (ret)
+		goto out;
+
+	/* To configure Debug OMC */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(VS_DEBUGOMC), 0x01);
+
+out:
+	return ret;
+}
+
+/**
+ * ufshcd_dwc_link_startup_notify()
+ * UFS Host DWC specific link startup sequence
+ * @hba: private structure poitner
+ * @status: Callback notify status
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
+					enum ufs_notify_change_status status)
+{
+	int err = 0;
+
+	if (status == PRE_CHANGE) {
+		ufshcd_dwc_program_clk_div(hba, UFSHCD_CLK_DIV_125);
+#ifdef CONFIG_SCSI_UFS_DWC_TC
+		err = ufshcd_dwc_setup_tc(hba);
+		if (err) {
+			dev_err(hba->dev, "Configuration failed (%d)",
+									err);
+			goto out;
+		}
+#endif
+	} else { /* POST_CHANGE */
+		err = ufshcd_dwc_link_is_up(hba);
+		if (err) {
+			dev_err(hba->dev, "Link is not up");
+			goto out;
+		}
+
+		err = ufshcd_dwc_connection_setup(hba);
+		if (err)
+			dev_err(hba->dev, "Connection setup failed (%d)", err);
+	}
+
+out:
+	return err;
+}
+EXPORT_SYMBOL(ufshcd_dwc_link_startup_notify);
diff --git a/drivers/scsi/ufs/ufshcd-dwc.h b/drivers/scsi/ufs/ufshcd-dwc.h
new file mode 100644
index 0000000..ca65ee1
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-dwc.h
@@ -0,0 +1,18 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
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
+#ifndef _UFSHCD_DWC_H
+#define _UFSHCD_DWC_H
+
+int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
+					enum ufs_notify_change_status status);
+#endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshci-dwc.h b/drivers/scsi/ufs/ufshci-dwc.h
new file mode 100644
index 0000000..08ae0ef
--- /dev/null
+++ b/drivers/scsi/ufs/ufshci-dwc.h
@@ -0,0 +1,42 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
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
+#ifndef _UFSHCI_DWC_H
+#define _UFSHCI_DWC_H
+
+/* DWC HC UFSHCI specific Registers */
+enum dwc_specific_registers {
+	DWC_UFS_REG_HCLKDIV	= 0xFC,
+};
+
+/* Link Status*/
+enum link_status {
+	UFSHCD_LINK_IS_DOWN	= 1,
+	UFSHCD_LINK_IS_UP	= 2,
+};
+
+/* Clock Divider Values: Hex equivalent of frequency in MHz */
+enum clk_div_values {
+	UFSHCD_CLK_DIV_62_5	= 0x3e,
+	UFSHCD_CLK_DIV_125	= 0x7d,
+	UFSHCD_CLK_DIV_200	= 0xc8,
+};
+
+/* Selector Index */
+enum selector_index {
+	SELIND_LN0_TX		= 0x00,
+	SELIND_LN1_TX		= 0x01,
+	SELIND_LN0_RX		= 0x04,
+	SELIND_LN1_RX		= 0x05,
+};
+
+#endif /* End of Header */
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 816a8a4..da16254 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -35,6 +35,10 @@
 #define TX_LCC_SEQUENCER			0x0032
 #define TX_MIN_ACTIVATETIME			0x0033
 #define TX_PWM_G6_G7_SYNC_LENGTH		0x0034
+#define TX_REFCLKFREQ				0x00EB
+#define TX_CFGCLKFREQVAL			0x00EC
+#define	CFGEXTRATTR				0x00F0
+#define DITHERCTRL2				0x00F1
 
 /*
  * M-RX Configuration Attributes
@@ -48,8 +52,38 @@
 #define RX_ENTER_HIBERN8			0x00A7
 #define RX_BYPASS_8B10B_ENABLE			0x00A8
 #define RX_TERMINATION_FORCE_ENABLE		0x0089
+#define RX_REFCLKFREQ				0x00EB
+#define	RX_CFGCLKFREQVAL			0x00EC
+#define CFGWIDEINLN				0x00F0
+#define CFGRXCDR8				0x00BA
+#define ENARXDIRECTCFG4				0x00F2
+#define CFGRXOVR8				0x00BD
+#define RXDIRECTCTRL2				0x00C7
+#define ENARXDIRECTCFG3				0x00F3
+#define RXCALCTRL				0x00B4
+#define ENARXDIRECTCFG2				0x00F4
+#define CFGRXOVR4				0x00E9
+#define RXSQCTRL				0x00B5
+#define CFGRXOVR6				0x00BF
 
 #define is_mphy_tx_attr(attr)			(attr < RX_MODE)
+
+/*
+ * Common Block Attributes
+ */
+#define TX_GLOBALHIBERNATE			UNIPRO_CB_OFFSET(0x002B)
+#define REFCLKMODE				UNIPRO_CB_OFFSET(0x00BF)
+#define DIRECTCTRL19				UNIPRO_CB_OFFSET(0x00CD)
+#define DIRECTCTRL10				UNIPRO_CB_OFFSET(0x00E6)
+#define CDIRECTCTRL6				UNIPRO_CB_OFFSET(0x00EA)
+#define RTOBSERVESELECT				UNIPRO_CB_OFFSET(0x00F0)
+#define CBDIVFACTOR				UNIPRO_CB_OFFSET(0x00F1)
+#define CBDCOCTRL5				UNIPRO_CB_OFFSET(0x00F3)
+#define CBPRGPLL2				UNIPRO_CB_OFFSET(0x00F8)
+#define CBPRGTUNING				UNIPRO_CB_OFFSET(0x00FB)
+
+#define UNIPRO_CB_OFFSET(x)			(0x8000 | x)
+
 /*
  * PHY Adpater attributes
  */
@@ -110,6 +144,11 @@
 #define PA_STALLNOCONFIGTIME	0x15A3
 #define PA_SAVECONFIGTIME	0x15A4
 
+/*Other attributes*/
+#define VS_MPHYCFGUPDT		0xD085
+#define VS_DEBUGOMC		0xD09E
+#define VS_POWERSTATE		0xD083
+
 /* PA power modes */
 enum {
 	FAST_MODE	= 1,
-- 
1.8.1.5
