From: vinholikatti@gmail.com
Subject: [PATCH V6 2/4] [SCSI] drivers/scsi/ufs: Separate PCI code into glue driver
Date: Tue,  5 Feb 2013 22:17:35 +0530
Message-ID: <511137dc.0657420a.5b57.ffffa7fa@mx.google.com>
References: <1360082857-3317-1-git-send-email-y>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1360082857-3317-1-git-send-email-y>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, santoshsy@gmail.com, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, saugata.das@linaro.org, venkat@linaro.org, subhashj@codeaurora.org, sthumma@codeaurora.org, vinholikatti@gmail.com
List-Id: linux-scsi@vger.kernel.org

From: Vinayak Holikatti <vinholikatti@gmail.com>

This patch separates PCI code from ufshcd.c and makes it as a
core driver module and adds a new file ufshcd-pci.c as PCI glue
driver.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
---
 drivers/scsi/ufs/Kconfig      |   26 +++-
 drivers/scsi/ufs/Makefile     |    1 +
 drivers/scsi/ufs/ufshcd-pci.c |  211 ++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c     |  328 +----------------------------------------
 drivers/scsi/ufs/ufshcd.h     |  202 +++++++++++++++++++++++++
 5 files changed, 440 insertions(+), 328 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
 create mode 100644 drivers/scsi/ufs/ufshcd.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 8ee40df..0371047 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -33,7 +33,27 @@
 # this program.
 
 config SCSI_UFSHCD
-	tristate "Universal Flash Storage host controller driver"
-	depends on PCI && SCSI
+	tristate "Universal Flash Storage Controller Driver Core"
+	depends on SCSI
 	---help---
-	This is a generic driver which supports PCIe UFS Host controllers.
+	This selects the support for UFS devices in Linux, say Y and make
+	  sure that you know the name of your UFS host adapter (the card
+	  inside your computer that "speaks" the UFS protocol, also
+	  called UFS Host Controller), because you will be asked for it.
+	  The module will be called ufshcd.
+
+	  To compile this driver as a module, choose M here and read
+	  <file:Documentation/scsi/ufs.txt>.
+	  However, do not compile this as a module if your root file system
+	  (the one containing the directory /) is located on a UFS device.
+
+config SCSI_UFSHCD_PCI
+	tristate "PCI bus based UFS Controller support"
+	depends on SCSI_UFSHCD && PCI
+	---help---
+	This selects the PCI UFS Host Controller Interface. Select this if
+	you have UFS Host Controller with PCI Interface.
+
+	  If you have a controller with this interface, say Y or M here.
+
+	  If unsure, say N.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index adf7895..9eda0df 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -1,2 +1,3 @@
 # UFSHCD makefile
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
+obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
new file mode 100644
index 0000000..ae30691
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -0,0 +1,211 @@
+/*
+ * Universal Flash Storage Host controller PCI glue driver
+ *
+ * This code is based on drivers/scsi/ufs/ufshcd-pci.c
+ * Copyright (C) 2011-2013 Samsung India Software Operations
+ *
+ * Authors:
+ *	Santosh Yaraganavi <santosh.sy@samsung.com>
+ *	Vinayak Holikatti <h.vinayak@samsung.com>
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
+#include "ufshcd.h"
+#include <linux/pci.h>
+
+#ifdef CONFIG_PM
+/**
+ * ufshcd_pci_suspend - suspend power management function
+ * @pdev: pointer to PCI device handle
+ * @state: power state
+ *
+ * Returns -ENOSYS
+ */
+static int ufshcd_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	/*
+	 * TODO:
+	 * 1. Call ufshcd_suspend
+	 * 2. Do bus specific power management
+	 */
+
+	return -ENOSYS;
+}
+
+/**
+ * ufshcd_pci_resume - resume power management function
+ * @pdev: pointer to PCI device handle
+ *
+ * Returns -ENOSYS
+ */
+static int ufshcd_pci_resume(struct pci_dev *pdev)
+{
+	/*
+	 * TODO:
+	 * 1. Call ufshcd_resume.
+	 * 2. Do bus specific wake up
+	 */
+
+	return -ENOSYS;
+}
+#endif /* CONFIG_PM */
+
+/**
+ * ufshcd_pci_shutdown - main function to put the controller in reset state
+ * @pdev: pointer to PCI device handle
+ */
+static void ufshcd_pci_shutdown(struct pci_dev *pdev)
+{
+	ufshcd_hba_stop((struct ufs_hba *)pci_get_drvdata(pdev));
+}
+
+/**
+ * ufshcd_pci_remove - de-allocate PCI/SCSI host and host memory space
+ *		data structure memory
+ * @pdev - pointer to PCI handle
+ */
+static void ufshcd_pci_remove(struct pci_dev *pdev)
+{
+	struct ufs_hba *hba = pci_get_drvdata(pdev);
+
+	disable_irq(pdev->irq);
+	free_irq(pdev->irq, hba);
+	ufshcd_remove(hba);
+	pci_release_regions(pdev);
+	pci_set_drvdata(pdev, NULL);
+	pci_clear_master(pdev);
+	pci_disable_device(pdev);
+}
+
+/**
+ * ufshcd_set_dma_mask - Set dma mask based on the controller
+ *			 addressing capability
+ * @pdev: PCI device structure
+ *
+ * Returns 0 for success, non-zero for failure
+ */
+static int ufshcd_set_dma_mask(struct pci_dev *pdev)
+{
+	int err;
+
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
+		&& !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
+		return 0;
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (!err)
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+	return err;
+}
+
+/**
+ * ufshcd_pci_probe - probe routine of the driver
+ * @pdev: pointer to PCI device handle
+ * @id: PCI device id
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int __devinit
+ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct ufs_hba *hba;
+	void __iomem *mmio_base;
+	int err;
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "pci_enable_device failed\n");
+		goto out_error;
+	}
+
+	pci_set_master(pdev);
+
+
+	err = pci_request_regions(pdev, UFSHCD);
+	if (err < 0) {
+		dev_err(&pdev->dev, "request regions failed\n");
+		goto out_disable;
+	}
+
+	mmio_base = pci_ioremap_bar(pdev, 0);
+	if (!mmio_base) {
+		dev_err(&pdev->dev, "memory map failed\n");
+		err = -ENOMEM;
+		goto out_release_regions;
+	}
+
+	err = ufshcd_set_dma_mask(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "set dma mask failed\n");
+		goto out_iounmap;
+	}
+
+	err = ufshcd_init(&pdev->dev, &hba, mmio_base, pdev->irq);
+	if (err) {
+		dev_err(&pdev->dev, "Initialization failed\n");
+		goto out_iounmap;
+	}
+
+	pci_set_drvdata(pdev, hba);
+
+	return 0;
+
+out_iounmap:
+	iounmap(mmio_base);
+out_release_regions:
+	pci_release_regions(pdev);
+out_disable:
+	pci_clear_master(pdev);
+	pci_disable_device(pdev);
+out_error:
+	return err;
+}
+
+static DEFINE_PCI_DEVICE_TABLE(ufshcd_pci_tbl) = {
+	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ }	/* terminate list */
+};
+
+MODULE_DEVICE_TABLE(pci, ufshcd_pci_tbl);
+
+static struct pci_driver ufshcd_pci_driver = {
+	.name = UFSHCD,
+	.id_table = ufshcd_pci_tbl,
+	.probe = ufshcd_pci_probe,
+	.remove = __devexit_p(ufshcd_pci_remove),
+	.shutdown = ufshcd_pci_shutdown,
+#ifdef CONFIG_PM
+	.suspend = ufshcd_pci_suspend,
+	.resume = ufshcd_pci_resume,
+#endif
+};
+
+module_pci_driver(ufshcd_pci_driver);
+
+MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
+MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
+MODULE_DESCRIPTION("UFS host controller PCI glue driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(UFSHCD_DRIVER_VERSION);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9fa0b60..60fd40c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1,5 +1,5 @@
 /*
- * Universal Flash Storage Host controller driver
+ * Universal Flash Storage Host controller driver Core
  *
  * This code is based on drivers/scsi/ufs/ufshcd.c
  * Copyright (C) 2011-2013 Samsung India Software Operations
@@ -33,35 +33,7 @@
  * this program.
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/pci.h>
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
-#define UFSHCD_DRIVER_VERSION "0.1"
+#include "ufshcd.h"
 
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
@@ -92,124 +64,6 @@ enum {
 };
 
 /**
- * struct uic_command - UIC command structure
- * @command: UIC command
- * @argument1: UIC command argument 1
- * @argument2: UIC command argument 2
- * @argument3: UIC command argument 3
- * @cmd_active: Indicate if UIC command is outstanding
- * @result: UIC command result
- */
-struct uic_command {
-	u32 command;
-	u32 argument1;
-	u32 argument2;
-	u32 argument3;
-	int cmd_active;
-	int result;
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
- * @outstanding_tasks: Bits representing outstanding task requests
- * @outstanding_reqs: Bits representing outstanding transfer requests
- * @capabilities: UFS Controller Capabilities
- * @nutrs: Transfer Request Queue depth supported by controller
- * @nutmrs: Task Management Queue depth supported by controller
- * @ufs_version: UFS Version to which controller complies
- * @irq: Irq number of the controller
- * @active_uic_cmd: handle of active UIC command
- * @ufshcd_tm_wait_queue: wait queue for task management
- * @tm_condition: condition variable for task management
- * @ufshcd_state: UFSHCD states
- * @int_enable_mask: Interrupt Mask Bits
- * @uic_workq: Work queue for UIC completion handling
- * @feh_workq: Work queue for fatal controller error handling
- * @errors: HBA errors
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
-
-	struct ufshcd_lrb *lrb;
-
-	unsigned long outstanding_tasks;
-	unsigned long outstanding_reqs;
-
-	u32 capabilities;
-	int nutrs;
-	int nutmrs;
-	u32 ufs_version;
-	unsigned int irq;
-
-	struct uic_command active_uic_cmd;
-	wait_queue_head_t ufshcd_tm_wait_queue;
-	unsigned long tm_condition;
-
-	u32 ufshcd_state;
-	u32 int_enable_mask;
-
-	/* Work Queues */
-	struct work_struct uic_workq;
-	struct work_struct feh_workq;
-
-	/* HBA Errors */
-	u32 errors;
-};
-
-/**
- * struct ufshcd_lrb - local reference block
- * @utr_descriptor_ptr: UTRD address of the command
- * @ucd_cmd_ptr: UCD address of the command
- * @ucd_rsp_ptr: Response UPIU address for this command
- * @ucd_prdt_ptr: PRDT address of the command
- * @cmd: pointer to SCSI command
- * @sense_buffer: pointer to sense buffer address of the SCSI command
- * @sense_bufflen: Length of the sense buffer
- * @scsi_status: SCSI status of the command
- * @command_type: SCSI, UFS, Query.
- * @task_tag: Task tag of the command
- * @lun: LUN of the command
- */
-struct ufshcd_lrb {
-	struct utp_transfer_req_desc *utr_descriptor_ptr;
-	struct utp_upiu_cmd *ucd_cmd_ptr;
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
-	unsigned int lun;
-};
-
-/**
  * ufshcd_get_ufs_version - Get the UFS version supported by the HBA
  * @hba - Pointer to adapter instance
  *
@@ -422,15 +276,6 @@ static void ufshcd_enable_run_stop_reg(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_hba_stop - Send controller to reset state
- * @hba: per adapter instance
- */
-static inline void ufshcd_hba_stop(struct ufs_hba *hba)
-{
-	writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
-}
-
-/**
  * ufshcd_hba_start - Start controller initialization sequence
  * @hba: per adapter instance
  */
@@ -1681,15 +1526,6 @@ static struct scsi_host_template ufshcd_driver_template = {
 };
 
 /**
- * ufshcd_pci_shutdown - main function to put the controller in reset state
- * @pdev: pointer to PCI device handle
- */
-static void ufshcd_pci_shutdown(struct pci_dev *pdev)
-{
-	ufshcd_hba_stop((struct ufs_hba *)pci_get_drvdata(pdev));
-}
-
-/**
  * ufshcd_suspend - suspend power management function
  * @hba: per adapter instance
  * @state: power state
@@ -1732,43 +1568,6 @@ int ufshcd_resume(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_resume);
 
-#ifdef CONFIG_PM
-/**
- * ufshcd_pci_suspend - suspend power management function
- * @pdev: pointer to PCI device handle
- * @state: power state
- *
- * Returns -ENOSYS
- */
-static int ufshcd_pci_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	/*
-	 * TODO:
-	 * 1. Call ufshcd_suspend
-	 * 2. Do bus specific power management
-	 */
-
-	return -ENOSYS;
-}
-
-/**
- * ufshcd_pci_resume - resume power management function
- * @pdev: pointer to PCI device handle
- *
- * Returns -ENOSYS
- */
-static int ufshcd_pci_resume(struct pci_dev *pdev)
-{
-	/*
-	 * TODO:
-	 * 1. Call ufshcd_resume
-	 * 2. Do bus specific wake up
-	 */
-
-	return -ENOSYS;
-}
-#endif /* CONFIG_PM */
-
 /**
  * ufshcd_hba_free - free allocated memory for
  *			host memory space data structures
@@ -1799,44 +1598,6 @@ void ufshcd_remove(struct ufs_hba *hba)
 EXPORT_SYMBOL_GPL(ufshcd_remove);
 
 /**
- * ufshcd_pci_remove - de-allocate PCI/SCSI host and host memory space
- *		data structure memory
- * @pdev - pointer to PCI handle
- */
-static void ufshcd_pci_remove(struct pci_dev *pdev)
-{
-	struct ufs_hba *hba = pci_get_drvdata(pdev);
-
-	disable_irq(pdev->irq);
-	free_irq(pdev->irq, hba);
-	ufshcd_remove(hba);
-	pci_release_regions(pdev);
-	pci_set_drvdata(pdev, NULL);
-	pci_clear_master(pdev);
-	pci_disable_device(pdev);
-}
-
-/**
- * ufshcd_set_dma_mask - Set dma mask based on the controller
- *			 addressing capability
- * @pdev: PCI device structure
- *
- * Returns 0 for success, non-zero for failure
- */
-static int ufshcd_set_dma_mask(struct pci_dev *pdev)
-{
-	int err;
-
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
-		&& !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
-		return 0;
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-	if (!err)
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-	return err;
-}
-
-/**
  * ufshcd_init - Driver initialization routine
  * @dev: pointer to device handle
  * @hba_handle: driver private handle
@@ -1952,91 +1713,8 @@ out_error:
 }
 EXPORT_SYMBOL_GPL(ufshcd_init);
 
-/**
- * ufshcd_pci_probe - probe routine of the driver
- * @pdev: pointer to PCI device handle
- * @id: PCI device id
- *
- * Returns 0 on success, non-zero value on failure
- */
-static int __devinit
-ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-{
-	struct ufs_hba *hba;
-	void __iomem *mmio_base;
-	int err;
-
-	err = pci_enable_device(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "pci_enable_device failed\n");
-		goto out_error;
-	}
-
-	pci_set_master(pdev);
-
-	err = pci_request_regions(pdev, UFSHCD);
-	if (err < 0) {
-		dev_err(&pdev->dev, "request regions failed\n");
-		goto out_disable;
-	}
-
-	mmio_base = pci_ioremap_bar(pdev, 0);
-	if (!mmio_base) {
-		dev_err(&pdev->dev, "memory map failed\n");
-		err = -ENOMEM;
-		goto out_release_regions;
-	}
-
-	err = ufshcd_set_dma_mask(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "set dma mask failed\n");
-		goto out_iounmap;
-	}
-
-	err = ufshcd_init(&pdev->dev, &hba, mmio_base, pdev->irq);
-	if (err) {
-		dev_err(&pdev->dev, "Initialization failed\n");
-		goto out_iounmap;
-	}
-
-	pci_set_drvdata(pdev, hba);
-
-	return 0;
-
-out_iounmap:
-	iounmap(mmio_base);
-out_release_regions:
-	pci_release_regions(pdev);
-out_disable:
-	pci_clear_master(pdev);
-	pci_disable_device(pdev);
-out_error:
-	return err;
-}
-
-static DEFINE_PCI_DEVICE_TABLE(ufshcd_pci_tbl) = {
-	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ }	/* terminate list */
-};
-
-MODULE_DEVICE_TABLE(pci, ufshcd_pci_tbl);
-
-static struct pci_driver ufshcd_pci_driver = {
-	.name = UFSHCD,
-	.id_table = ufshcd_pci_tbl,
-	.probe = ufshcd_pci_probe,
-	.remove = __devexit_p(ufshcd_pci_remove),
-	.shutdown = ufshcd_pci_shutdown,
-#ifdef CONFIG_PM
-	.suspend = ufshcd_pci_suspend,
-	.resume = ufshcd_pci_resume,
-#endif
-};
-
-module_pci_driver(ufshcd_pci_driver);
-
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
-MODULE_DESCRIPTION("Generic UFS host controller driver");
+MODULE_DESCRIPTION("Generic UFS host controller driver Core");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(UFSHCD_DRIVER_VERSION);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
new file mode 100644
index 0000000..6b99a42
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -0,0 +1,202 @@
+/*
+ * Universal Flash Storage Host controller driver
+ *
+ * This code is based on drivers/scsi/ufs/ufshcd.h
+ * Copyright (C) 2011-2013 Samsung India Software Operations
+ *
+ * Authors:
+ *	Santosh Yaraganavi <santosh.sy@samsung.com>
+ *	Vinayak Holikatti <h.vinayak@samsung.com>
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
+#include "ufshci.h"
+
+#define UFSHCD "ufshcd"
+#define UFSHCD_DRIVER_VERSION "0.2"
+
+/**
+ * struct uic_command - UIC command structure
+ * @command: UIC command
+ * @argument1: UIC command argument 1
+ * @argument2: UIC command argument 2
+ * @argument3: UIC command argument 3
+ * @cmd_active: Indicate if UIC command is outstanding
+ * @result: UIC command result
+ */
+struct uic_command {
+	u32 command;
+	u32 argument1;
+	u32 argument2;
+	u32 argument3;
+	int cmd_active;
+	int result;
+};
+
+/**
+ * struct ufshcd_lrb - local reference block
+ * @utr_descriptor_ptr: UTRD address of the command
+ * @ucd_cmd_ptr: UCD address of the command
+ * @ucd_rsp_ptr: Response UPIU address for this command
+ * @ucd_prdt_ptr: PRDT address of the command
+ * @cmd: pointer to SCSI command
+ * @sense_buffer: pointer to sense buffer address of the SCSI command
+ * @sense_bufflen: Length of the sense buffer
+ * @scsi_status: SCSI status of the command
+ * @command_type: SCSI, UFS, Query.
+ * @task_tag: Task tag of the command
+ * @lun: LUN of the command
+ */
+struct ufshcd_lrb {
+	struct utp_transfer_req_desc *utr_descriptor_ptr;
+	struct utp_upiu_cmd *ucd_cmd_ptr;
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
+	unsigned int lun;
+};
+
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
+ * @outstanding_tasks: Bits representing outstanding task requests
+ * @outstanding_reqs: Bits representing outstanding transfer requests
+ * @capabilities: UFS Controller Capabilities
+ * @nutrs: Transfer Request Queue depth supported by controller
+ * @nutmrs: Task Management Queue depth supported by controller
+ * @ufs_version: UFS Version to which controller complies
+ * @irq: Irq number of the controller
+ * @active_uic_cmd: handle of active UIC command
+ * @ufshcd_tm_wait_queue: wait queue for task management
+ * @tm_condition: condition variable for task management
+ * @ufshcd_state: UFSHCD states
+ * @int_enable_mask: Interrupt Mask Bits
+ * @uic_workq: Work queue for UIC completion handling
+ * @feh_workq: Work queue for fatal controller error handling
+ * @errors: HBA errors
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
+
+	struct ufshcd_lrb *lrb;
+
+	unsigned long outstanding_tasks;
+	unsigned long outstanding_reqs;
+
+	u32 capabilities;
+	int nutrs;
+	int nutmrs;
+	u32 ufs_version;
+	unsigned int irq;
+
+	struct uic_command active_uic_cmd;
+	wait_queue_head_t ufshcd_tm_wait_queue;
+	unsigned long tm_condition;
+
+	u32 ufshcd_state;
+	u32 int_enable_mask;
+
+	/* Work Queues */
+	struct work_struct uic_workq;
+	struct work_struct feh_workq;
+
+	/* HBA Errors */
+	u32 errors;
+};
+
+int ufshcd_init(struct device *, struct ufs_hba ** , void __iomem * ,
+			unsigned int);
+void ufshcd_remove(struct ufs_hba *);
+
+/**
+ * ufshcd_hba_stop - Send controller to reset state
+ * @hba: per adapter instance
+ */
+static inline void ufshcd_hba_stop(struct ufs_hba *hba)
+{
+	writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
+}
+
+#endif /* End of Header */
-- 
1.7.5.4
