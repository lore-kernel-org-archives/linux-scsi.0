From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v4 2/2] add support for DWC UFS Host Controller
Date: Mon,  8 Feb 2016 19:07:51 +0000
Message-ID: <a84bdc440a45995ace888213468c55a36513a9cb.1454957580.git.jpinto@synopsys.com>
References: <cover.1454957580.git.jpinto@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1454957580.git.jpinto@synopsys.com>
In-Reply-To: <cover.1454957580.git.jpinto@synopsys.com>
References: <cover.1454957580.git.jpinto@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, mark.rutland@arm.com
Cc: gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

This patch has the goal to add support for DesignWare UFS Controller
specific operations and to add specific platform and pci drivers.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
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
 drivers/scsi/ufs/Kconfig                          |  50 ++
 drivers/scsi/ufs/Makefile                         |   3 +
 drivers/scsi/ufs/ufs-dwc-pci.c                    | 180 +++++
 drivers/scsi/ufs/ufs-dwc.c                        | 102 +++
 drivers/scsi/ufs/ufshcd-dwc.c                     | 768 ++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-dwc.h                     |  26 +
 drivers/scsi/ufs/ufshcd.c                         |  61 +-
 drivers/scsi/ufs/ufshcd.h                         |  22 +
 drivers/scsi/ufs/ufshci-dwc.h                     |  42 ++
 drivers/scsi/ufs/ufshci.h                         |   1 +
 drivers/scsi/ufs/unipro.h                         |  39 ++
 13 files changed, 1299 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-dwc.txt
 create mode 100644 drivers/scsi/ufs/ufs-dwc-pci.c
 create mode 100644 drivers/scsi/ufs/ufs-dwc.c
 create mode 100644 drivers/scsi/ufs/ufshcd-dwc.c
 create mode 100644 drivers/scsi/ufs/ufshcd-dwc.h
 create mode 100644 drivers/scsi/ufs/ufshci-dwc.h

diff --git a/Documentation/devicetree/bindings/ufs/ufs-dwc.txt b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
new file mode 100644
index 0000000..f38a3f5
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
+	dwc_ufshcd@0xD0000000 {
+		compatible = "snps,ufshcd-2.0";
+		reg = < 0xD0000000 0x10000 >;
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
index 5f45307..8c130de 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -83,3 +83,53 @@ config SCSI_UFS_QCOM
 
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
+config SCSI_UFS_DWC_MPHY_TC
+	bool "Support for the Synopsys MPHY Test Chip"
+	depends on SCSI_UFS_DWC_HOOKS && (SCSI_UFSHCD_PCI || SCSI_UFS_DWC_PLAT)
+	---help---
+	  This selects the support for the Synopsys MPHY Test Chip.
+
+	  Select this if you have a Synopsys MPHY Test Chip.
+	  If unsure, say N.
+
+config SCSI_UFS_DWC_20BIT_RMMI
+	bool "20-bit RMMI MPHY"
+	depends on SCSI_UFS_DWC_MPHY_TC
+	---help---
+	  This specifies that the Synopsys MPHY supports 40-bit RMMI operations.
+
+	  Select this if you are using a 40-bit RMMI Synopsys MPHY.
+	  If unsure, say N.
+
+config SCSI_UFS_DWC_40BIT_RMMI
+	bool "40-bit RMMI MPHY"
+	depends on SCSI_UFS_DWC_MPHY_TC
+	---help---
+	  This specifies that the Synopsys MPHY supports 40-bit RMMI operations.
+
+	  Select this if you are using a 40-bit RMMI Synopsys MPHY.
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
index 0000000..7ce492d
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-dwc-pci.c
@@ -0,0 +1,180 @@
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
+#ifdef CONFIG_PM
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
+#else /* !CONFIG_PM */
+#define ufs_dw_pci_suspend	NULL
+#define ufs_dw_pci_resume	NULL
+#define ufs_dw_pci_runtime_suspend	NULL
+#define ufs_dw_pci_runtime_resume	NULL
+#define ufs_dw_pci_runtime_idle	NULL
+#endif /* CONFIG_PM */
+
+/**
+ * struct ufs_hba_dwc_vops - UFS DWC specific variant operations
+ */
+static struct ufs_hba_variant_ops ufs_dwc_pci_hba_vops = {
+	.name                   = "ufs-dw-pci",
+	.custom_probe_hba	= ufshcd_dwc_configuration,
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
+MODULE_LICENSE("GPLv2");
diff --git a/drivers/scsi/ufs/ufs-dwc.c b/drivers/scsi/ufs/ufs-dwc.c
new file mode 100644
index 0000000..1b3c609
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
+	.custom_probe_hba	= ufshcd_dwc_configuration,
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
index 0000000..b12b1a8
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-dwc.c
@@ -0,0 +1,768 @@
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
+void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
+{
+	ufshcd_writel(hba, divider_val, DWC_UFS_REG_HCLKDIV);
+}
+EXPORT_SYMBOL(ufshcd_dwc_program_clk_div);
+
+/**
+ * ufshcd_dwc_link_is_up()
+ * Check if link is up
+ * @hba: private structure poitner
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
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
+EXPORT_SYMBOL(ufshcd_dwc_link_is_up);
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
+int ufshcd_dwc_connection_setup(struct ufs_hba *hba)
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
+/**
+ * ufshcd_dwc_setup_20bit_rmmi_lane0()
+ * This function configures Synopsys MPHY 20-bit RMMI Lane 0
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success or non-zero value on failure
+ */
+int ufshcd_dwc_setup_20bit_rmmi_lane0(struct ufs_hba *hba)
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
+ * This function configures Synopsys MPHY 20-bit RMMI Lane 1
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success or non-zero value on failure
+ */
+int ufshcd_dwc_setup_20bit_rmmi_lane1(struct ufs_hba *hba)
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
+ * This function configures Synopsys MPHY specific atributes (20-bit RMMI)
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success or non-zero value on failure
+ */
+int ufshcd_dwc_setup_20bit_rmmi(struct ufs_hba *hba)
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
+
+/**
+ * ufshcd_dwc_setup_40bit_rmmi()
+ * This function configures Synopsys MPHY specific atributes (40-bit RMMI)
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success or non-zero value on failure
+ */
+int ufshcd_dwc_setup_40bit_rmmi(struct ufs_hba *hba)
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
+/**
+ * ufshcd_dwc_setup_mphy()
+ * This function configures Local (host) Synopsys MPHY specific attributes
+ *
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success non-zero value on failure
+ */
+int ufshcd_dwc_setup_mphy(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+#ifdef CONFIG_SCSI_UFS_DWC_40BIT_RMMI
+	dev_info(hba->dev, "Configuring MPHY 40-bit RMMI");
+	ret = ufshcd_dwc_setup_40bit_rmmi(hba);
+	if (ret) {
+		dev_err(hba->dev, "40-bit RMMI configuration failed");
+		goto out;
+	}
+#else
+#ifdef CONFIG_SCSI_UFS_DWC_20BIT_RMMI
+	dev_info(hba->dev, "Configuring MPHY 20-bit RMMI");
+	ret = ufshcd_dwc_setup_20bit_rmmi(hba);
+	if (ret) {
+		dev_err(hba->dev, "20-bit RMMI configuration failed");
+		goto out;
+	}
+#endif
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
+ * ufshcd_dwc_configuration()
+ * UFS Host DWC specific configuration
+ * @hba: private structure poitner
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+int ufshcd_dwc_configuration(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	/* Program Clock Divider Value */
+	ufshcd_dwc_program_clk_div(hba, UFSHCD_CLK_DIV_125);
+
+#ifdef CONFIG_SCSI_UFS_DWC_MPHY_TC
+	ret = ufshcd_dwc_setup_mphy(hba);
+	if (ret) {
+		dev_err(hba->dev, "MPHY configuration failed (%d)", ret);
+		goto out;
+	}
+#endif
+	ret = ufshcd_dme_link_startup(hba);
+	if (ret) {
+		dev_err(hba->dev, "Link Startup command failed (%d)", ret);
+		goto out;
+	}
+
+	ret = ufshcd_dwc_link_is_up(hba);
+	if (ret) {
+		dev_err(hba->dev, "Link is not up");
+		goto out;
+	}
+
+	ret = ufshcd_dwc_connection_setup(hba);
+	if (ret) {
+		dev_err(hba->dev, "Connection setup failed (%d)", ret);
+		goto out;
+	}
+
+	ret = ufshcd_make_hba_operational(hba);
+	if (ret) {
+		dev_err(hba->dev, "HBA kick start failed (%d)", ret);
+		goto out;
+	}
+
+	ret = ufshcd_verify_dev_init(hba);
+	if (ret) {
+		dev_err(hba->dev, "Device init failed (%d)", ret);
+		goto out;
+	}
+
+	ret = ufshcd_complete_dev_init(hba);
+	if (ret) {
+		dev_err(hba->dev, "Device final init failed (%d)", ret);
+		goto out;
+	}
+
+	ufshcd_set_ufs_dev_active(hba);
+	hba->wlun_dev_clr_ua = false;
+
+	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
+		scsi_unblock_requests(hba->host);
+
+	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+
+	scsi_scan_host(hba->host);
+
+out:
+	return ret;
+}
+EXPORT_SYMBOL(ufshcd_dwc_configuration);
diff --git a/drivers/scsi/ufs/ufshcd-dwc.h b/drivers/scsi/ufs/ufshcd-dwc.h
new file mode 100644
index 0000000..dce03ad
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-dwc.h
@@ -0,0 +1,26 @@
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
+void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32);
+int ufshcd_dwc_link_is_up(struct ufs_hba *hba);
+int ufshcd_dwc_connection_setup(struct ufs_hba *hba);
+int ufshcd_dwc_setup_20bit_rmmi_lane0(struct ufs_hba *hba);
+int ufshcd_dwc_setup_20bit_rmmi_lane1(struct ufs_hba *hba);
+int ufshcd_dwc_setup_20bit_rmmi(struct ufs_hba *hba);
+int ufshcd_dwc_setup_40bit_rmmi(struct ufs_hba *hba);
+int ufshcd_dwc_setup_mphy(struct ufs_hba *hba);
+int ufshcd_dwc_configuration(struct ufs_hba *hba);
+
+#endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 85cd256..c16181f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -104,13 +104,6 @@ enum {
 	UFSHCD_CAN_QUEUE	= 32,
 };
 
-/* UFSHCD states */
-enum {
-	UFSHCD_STATE_RESET,
-	UFSHCD_STATE_ERROR,
-	UFSHCD_STATE_OPERATIONAL,
-};
-
 /* UFSHCD error handling flags */
 enum {
 	UFSHCD_EH_IN_PROGRESS = (1 << 0),
@@ -138,8 +131,6 @@ enum {
 #define ufshcd_clear_eh_in_progress(h) \
 	(h->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)
 
-#define ufshcd_set_ufs_dev_active(h) \
-	((h)->curr_dev_pwr_mode = UFS_ACTIVE_PWR_MODE)
 #define ufshcd_set_ufs_dev_sleep(h) \
 	((h)->curr_dev_pwr_mode = UFS_SLEEP_PWR_MODE)
 #define ufshcd_set_ufs_dev_poweroff(h) \
@@ -1223,6 +1214,7 @@ static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 			ret = -EINVAL;
 		}
 		break;
+	case UTP_CMD_TYPE_UFS_STORAGE:
 	case UTP_CMD_TYPE_DEV_MANAGE:
 		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_NONE);
 		if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY)
@@ -1287,6 +1279,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp;
 	struct ufs_hba *hba;
 	unsigned long flags;
+	u32 upiu_flags;
 	int tag;
 	int err = 0;
 
@@ -1343,10 +1336,23 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
-	lrbp->command_type = UTP_CMD_TYPE_SCSI;
+
+	if (hba->ufs_version == UFSHCI_VERSION_20)
+		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
+	else
+		lrbp->command_type = UTP_CMD_TYPE_SCSI;
 
 	/* form UPIU before issuing the command */
-	ufshcd_compose_upiu(hba, lrbp);
+	if (hba->ufs_version == UFSHCI_VERSION_20) {
+		if (likely(lrbp->cmd)) {
+			ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
+					lrbp->cmd->sc_data_direction);
+			ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
+		} else
+			err = -EINVAL;
+	} else
+		ufshcd_compose_upiu(hba, lrbp);
+
 	err = ufshcd_map_sg(lrbp);
 	if (err) {
 		lrbp->cmd = NULL;
@@ -1371,7 +1377,12 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = 0; /* device management cmd is not specific to any LUN */
-	lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
+
+	if (hba->ufs_version == UFSHCI_VERSION_20)
+		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
+	else
+		lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
+
 	lrbp->intr_cmd = true; /* No interrupt aggregation */
 	hba->dev_cmd.type = cmd_type;
 
@@ -2063,7 +2074,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
  *
  * Returns 0 on success, non-zero value on failure
  */
-static int ufshcd_dme_link_startup(struct ufs_hba *hba)
+int ufshcd_dme_link_startup(struct ufs_hba *hba)
 {
 	struct uic_command uic_cmd = {0};
 	int ret;
@@ -2076,6 +2087,7 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 			"dme-link-startup: error code %d\n", ret);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufshcd_dme_link_startup);
 
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
 {
@@ -2511,7 +2523,7 @@ static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
  *
  * Set fDeviceInit flag and poll until device toggles it.
  */
-static int ufshcd_complete_dev_init(struct ufs_hba *hba)
+int ufshcd_complete_dev_init(struct ufs_hba *hba)
 {
 	int i, retries, err = 0;
 	bool flag_res = 1;
@@ -2555,6 +2567,7 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 out:
 	return err;
 }
+EXPORT_SYMBOL_GPL(ufshcd_complete_dev_init);
 
 /**
  * ufshcd_make_hba_operational - Make UFS controller operational
@@ -2568,7 +2581,7 @@ out:
  *
  * Returns 0 on success, non-zero value on failure
  */
-static int ufshcd_make_hba_operational(struct ufs_hba *hba)
+int ufshcd_make_hba_operational(struct ufs_hba *hba)
 {
 	int err = 0;
 	u32 reg;
@@ -2609,6 +2622,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 out:
 	return err;
 }
+EXPORT_SYMBOL_GPL(ufshcd_make_hba_operational);
 
 /**
  * ufshcd_hba_enable - initialize the controller
@@ -2784,7 +2798,7 @@ out:
  * not respond with NOP IN UPIU within timeout of %NOP_OUT_TIMEOUT
  * and we retry sending NOP OUT for %NOP_OUT_RETRIES iterations.
  */
-static int ufshcd_verify_dev_init(struct ufs_hba *hba)
+int ufshcd_verify_dev_init(struct ufs_hba *hba)
 {
 	int err = 0;
 	int retries;
@@ -2807,6 +2821,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 		dev_err(hba->dev, "%s: NOP OUT failed %d\n", __func__, err);
 	return err;
 }
+EXPORT_SYMBOL_GPL(ufshcd_verify_dev_init);
 
 /**
  * ufshcd_set_queue_depth - set lun queue depth
@@ -3187,7 +3202,8 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
 			__ufshcd_release(hba);
-		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE) {
+		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
+			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
 			if (hba->dev_cmd.complete)
 				complete(hba->dev_cmd.complete);
 		}
@@ -5645,7 +5661,16 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_poweroff(hba);
 
-	async_schedule(ufshcd_async_scan, hba);
+	/* Hook for specific hardware config initialization */
+	if (hba->vops->custom_probe_hba) {
+		err = ufshcd_vops_custom_probe_hba(hba);
+		if (err) {
+			dev_err(hba->dev, "Host controller config failed\n");
+			goto out_remove_scsi_host;
+		}
+	}
+	else
+		async_schedule(ufshcd_async_scan, hba);
 
 	return 0;
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2570d94..3f12616 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -76,6 +76,13 @@ enum dev_cmd_type {
 	DEV_CMD_TYPE_QUERY		= 0x1,
 };
 
+/* UFSHCD states */
+enum {
+	UFSHCD_STATE_RESET,
+	UFSHCD_STATE_ERROR,
+	UFSHCD_STATE_OPERATIONAL,
+};
+
 /**
  * struct uic_command - UIC command structure
  * @command: UIC command
@@ -124,6 +131,8 @@ enum uic_link_state {
 				    UIC_LINK_ACTIVE_STATE)
 #define ufshcd_set_link_hibern8(hba) ((hba)->uic_link_state = \
 				    UIC_LINK_HIBERN8_STATE)
+#define ufshcd_set_ufs_dev_active(h) \
+	((h)->curr_dev_pwr_mode = UFS_ACTIVE_PWR_MODE)
 
 /*
  * UFS Power management levels.
@@ -283,6 +292,7 @@ struct ufs_hba_variant_ops {
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
+	int	(*custom_probe_hba)(struct ufs_hba *hba);
 };
 
 /* clock gating state  */
@@ -634,6 +644,10 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u8 attr_set, u32 mib_val, u8 peer);
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
+int ufshcd_dme_link_startup(struct ufs_hba *hba);
+int ufshcd_make_hba_operational(struct ufs_hba *hba);
+int ufshcd_verify_dev_init(struct ufs_hba *hba);
+int ufshcd_complete_dev_init(struct ufs_hba *hba);
 
 /* UIC command interfaces for DME primitives */
 #define DME_LOCAL	0
@@ -788,4 +802,12 @@ static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
 		hba->vops->dbg_register_dump(hba);
 }
 
+static inline int ufshcd_vops_custom_probe_hba(struct ufs_hba *hba)
+{
+	if (hba->vops && hba->vops->custom_probe_hba)
+		return hba->vops->custom_probe_hba(hba);
+
+	return 0;
+}
+
 #endif /* End of Header */
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
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 0ae0967..8dba0e7 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -273,6 +273,7 @@ enum {
 	UTP_CMD_TYPE_SCSI		= 0x0,
 	UTP_CMD_TYPE_UFS		= 0x1,
 	UTP_CMD_TYPE_DEV_MANAGE		= 0x2,
+	UTP_CMD_TYPE_UFS_STORAGE	= 0x11,
 };
 
 enum {
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
