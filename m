From: Girish K S <girish.shivananjappa@linaro.org>
Subject: [RFC V4 1/2] SCSI: UFS: Create separate UFS core and pci modules
Date: Tue, 22 May 2012 17:03:29 +0530
Message-ID: <1337686410-19206-2-git-send-email-girish.shivananjappa@linaro.org>
References: <1337686410-19206-1-git-send-email-girish.shivananjappa@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60745 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758166Ab2EVLeV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2012 07:34:21 -0400
Received: by pbbrp8 with SMTP id rp8so8262155pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 22 May 2012 04:34:20 -0700 (PDT)
In-Reply-To: <1337686410-19206-1-git-send-email-girish.shivananjappa@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, hch@infradead.org, patches@linaro.org, svenkatr@ti.com, Girish K S <girish.shivananjappa@linaro.org>

The existing driver was pci specific. This patch removes the
pci specific code from the core driver. Irrespective of the
pci or non-pci probe, the same core driver can be re-used.

It also creates 2 separate modules of core and pci driver

Signed-off-by: Girish K S <girish.shivananjappa@linaro.org>
---
 drivers/scsi/ufs/Kconfig      |   19 ++-
 drivers/scsi/ufs/Makefile     |    1 +
 drivers/scsi/ufs/ufs.h        |  103 ++++++++++++
 drivers/scsi/ufs/ufshcd-pci.c |  206 +++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c     |  367 ++++++++++------------------------------
 5 files changed, 418 insertions(+), 278 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pci.c

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 8f27f9d..2a70972 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -44,6 +44,19 @@
 
 config SCSI_UFSHCD
 	tristate "Universal Flash Storage host controller driver"
-	depends on PCI && SCSI
-	---help---
-	This is a generic driver which supports PCIe UFS Host controllers.
+	depends on SCSI
+	help
+	This is a generic driver which supports UFS Host controllers.
+	This option is selected automatically if the SCSI option is
+	selected. This is a core ufs driver.
+
+config SCSI_UFSHCD_PCI
+	tristate "Universal Flash Storage host support on PCI bus"
+	depends on SCSI_UFSHCD && PCI
+	help
+	This selects the PCI bus for the Universal Flash Storage IP.
+	Select this option if the IP is present on PCI platform.
+
+	If you have a controller with this interface, say Y or M here.
+
+	If unsure, say N.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index adf7895..9eda0df 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -1,2 +1,3 @@
 # UFSHCD makefile
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
+obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index b207529..9205742 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -46,6 +46,8 @@
 #ifndef _UFS_H
 #define _UFS_H
 
+#define ufs_hostname(x)	(dev_name((x)->dev))
+
 #define MAX_CDB_SIZE	16
 
 #define UPIU_HEADER_DWORD(byte3, byte2, byte1, byte0)\
@@ -204,4 +206,105 @@ struct utp_upiu_task_rsp {
 	u32 reserved[3];
 };
 
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
+struct ufs_pdata {
+	/* TODO */
+	u32 quirks; /* Quirk flags */
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
+ * @outstanding_tasks: Bits representing outstanding task requests
+ * @outstanding_reqs: Bits representing outstanding transfer requests
+ * @capabilities: UFS Controller Capabilities
+ * @nutrs: Transfer Request Queue depth supported by controller
+ * @nutmrs: Task Management Queue depth supported by controller
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
+
+	unsigned int		irq;
+};
+
+extern int ufshcd_initialize_hba(struct ufs_hba *hba);
+extern int ufshcd_drv_init(struct ufs_hba **hostdat, struct device *dev,
+			int irq_no, void __iomem *mmio_base);
+extern void ufshcd_drv_exit(struct ufs_hba *hba);
+#ifdef CONFIG_PM
+extern int ufshcd_suspend(struct ufs_hba *hba);
+extern int ufshcd_resume(struct ufs_hba *hba);
+#endif /* CONFIG_PM */
+
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
new file mode 100644
index 0000000..920ba86
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -0,0 +1,206 @@
+/*
+ * Universal Flash Storage Host controller driver
+ *
+ * This code is based on drivers/scsi/ufs/ufshcd.c
+ * Copyright (C) 2011-2012 Samsung India Software Operations
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * NO WARRANTY
+ * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
+ * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
+ * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
+ * solely responsible for determining the appropriateness of using and
+ * distributing the Program and assumes all risks associated with its
+ * exercise of rights under this Agreement, including but not limited to
+ * the risks and costs of program errors, damage to or loss of data,
+ * programs or equipment, and unavailability or interruption of operations.
+
+ * DISCLAIMER OF LIABILITY
+ * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+ * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
+ * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
+ * USA.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/pci.h>
+#include <scsi/scsi_host.h>
+
+#include "ufs.h"
+#include "ufshci.h"
+
+/**
+ * ufshcd_pci_set_dma_mask - Set dma mask based on the controller
+ *			 addressing capability
+ * @ihba: pointer to host platform data
+ *
+ * Returns 0 for success, non-zero for failure
+ */
+static int ufshcd_pci_set_dma_mask(struct pci_dev *pdev)
+{
+	int err;
+	u64 dma_mask;
+
+	/*
+	 * If controller supports 64 bit addressing mode, then set the DMA
+	 * mask to 64-bit, else set the DMA mask to 32-bit
+	 */
+	dma_mask = DMA_BIT_MASK(64);
+	err = pci_set_dma_mask(pdev, dma_mask);
+	if (err) {
+		dma_mask = DMA_BIT_MASK(32);
+		err = pci_set_dma_mask(pdev, dma_mask);
+	}
+
+	if (err)
+		return err;
+
+	err = pci_set_consistent_dma_mask(pdev, dma_mask);
+
+	return err;
+}
+
+static int __devinit ufshcd_pci_probe(struct pci_dev *pdev,
+				  const struct pci_device_id *entries)
+{
+	struct ufs_hba *uninitialized_var(hba);
+	int err;
+	void __iomem *mmio_base;
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "pci_enable_device failed\n");
+		goto err_return;
+	}
+
+	pci_set_master(pdev);
+
+	err = pci_request_regions(pdev, "ufshcd-pci");
+	if (err < 0) {
+		dev_err(&pdev->dev, "request regions failed\n");
+		goto err_disable;
+	}
+
+	mmio_base = pci_ioremap_bar(pdev, 0);
+	if (!mmio_base) {
+		dev_err(&pdev->dev, "memory map failed\n");
+		err = -ENOMEM;
+		goto err_release;
+	}
+
+	err = ufshcd_pci_set_dma_mask(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "set dma mask failed\n");
+		goto err_iounmap;
+	}
+
+	err = ufshcd_drv_init(&hba, &pdev->dev, pdev->irq, mmio_base);
+	if (err)
+		goto err_iounmap;
+
+	pci_set_drvdata(pdev, hba);
+
+	/* Initialization routine */
+	err = ufshcd_initialize_hba(hba);
+	if (err) {
+		dev_err(&pdev->dev, "Initialization failed\n");
+		goto err_remove;
+	}
+
+	return err;
+
+err_remove:
+	ufshcd_drv_exit(hba);
+err_iounmap:
+	iounmap(hba->mmio_base);
+err_release:
+	pci_release_regions(pdev);
+err_disable:
+	pci_clear_master(pdev);
+	pci_disable_device(pdev);
+err_return:
+	return err;
+}
+
+static void __devexit ufshcd_pci_remove(struct pci_dev *pdev)
+{
+	struct ufs_hba *hba = pci_get_drvdata(pdev);
+
+	ufshcd_drv_exit(hba);
+	iounmap(hba->mmio_base);
+	pci_set_drvdata(pdev, NULL);
+	pci_clear_master(pdev);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+#ifdef CONFIG_PM
+static int ufshcd_pci_suspend(struct device *dev)
+{
+	int ret;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct ufs_hba *hba = pci_get_drvdata(pdev);
+
+	ret = ufshcd_suspend(hba);
+	return ret;
+}
+
+static int ufshcd_pci_resume(struct device *dev)
+{
+	int ret;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct ufs_hba *hba = pci_get_drvdata(pdev);
+
+	ret = ufshcd_resume(hba);
+	return ret;
+}
+#else
+#define ufshcd_pci_suspend	NULL
+#define ufshcd_pci_resume	NULL
+#endif /* CONFIG_PM */
+
+static SIMPLE_DEV_PM_OPS(ufshcd_pci_pmops,
+			 ufshcd_pci_suspend,
+			 ufshcd_pci_resume);
+
+static DEFINE_PCI_DEVICE_TABLE(ufshcd_pci_id) = {
+	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(pci, ufshcd_pci_id);
+
+static struct pci_driver ufshcd_pci_driver = {
+	.name		= "ufshcd-pci",
+	.id_table	= ufshcd_pci_id,
+	.probe		= ufshcd_pci_probe,
+	.remove		= __devexit_p(ufshcd_pci_remove),
+	.driver		=	{
+		.pm =   &ufshcd_pci_pmops
+	},
+};
+
+module_pci_driver(ufshcd_pci_driver);
+
+MODULE_DESCRIPTION("UFS Host Controller PCI Interface driver");
+MODULE_AUTHOR("Girish K S <ks.giri@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e47a0da..20441b9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -46,7 +46,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/delay.h>
@@ -102,91 +101,6 @@ enum {
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
- * @pdev: PCI device handle
- * @lrb: local reference block
- * @outstanding_tasks: Bits representing outstanding task requests
- * @outstanding_reqs: Bits representing outstanding transfer requests
- * @capabilities: UFS Controller Capabilities
- * @nutrs: Transfer Request Queue depth supported by controller
- * @nutmrs: Task Management Queue depth supported by controller
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
-	struct pci_dev *pdev;
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
  * struct ufshcd_lrb - local reference block
  * @utr_descriptor_ptr: UTRD address of the command
  * @ucd_cmd_ptr: UCD address of the command
@@ -335,21 +249,21 @@ static inline void ufshcd_free_hba_memory(struct ufs_hba *hba)
 
 	if (hba->utmrdl_base_addr) {
 		utmrdl_size = sizeof(struct utp_task_req_desc) * hba->nutmrs;
-		dma_free_coherent(&hba->pdev->dev, utmrdl_size,
+		dma_free_coherent(hba->dev, utmrdl_size,
 				  hba->utmrdl_base_addr, hba->utmrdl_dma_addr);
 	}
 
 	if (hba->utrdl_base_addr) {
 		utrdl_size =
 		(sizeof(struct utp_transfer_req_desc) * hba->nutrs);
-		dma_free_coherent(&hba->pdev->dev, utrdl_size,
+		dma_free_coherent(hba->dev, utrdl_size,
 				  hba->utrdl_base_addr, hba->utrdl_dma_addr);
 	}
 
 	if (hba->ucdl_base_addr) {
 		ucdl_size =
 		(sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
-		dma_free_coherent(&hba->pdev->dev, ucdl_size,
+		dma_free_coherent(hba->dev, ucdl_size,
 				  hba->ucdl_base_addr, hba->ucdl_dma_addr);
 	}
 }
@@ -724,7 +638,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 
 	/* Allocate memory for UTP command descriptors */
 	ucdl_size = (sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
-	hba->ucdl_base_addr = dma_alloc_coherent(&hba->pdev->dev,
+	hba->ucdl_base_addr = dma_alloc_coherent(hba->dev,
 						 ucdl_size,
 						 &hba->ucdl_dma_addr,
 						 GFP_KERNEL);
@@ -737,7 +651,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 */
 	if (!hba->ucdl_base_addr ||
 	    WARN_ON(hba->ucdl_dma_addr & (PAGE_SIZE - 1))) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Command Descriptor Memory allocation failed\n");
 		goto out;
 	}
@@ -747,13 +661,13 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 * UFSHCI requires 1024 byte alignment of UTRD
 	 */
 	utrdl_size = (sizeof(struct utp_transfer_req_desc) * hba->nutrs);
-	hba->utrdl_base_addr = dma_alloc_coherent(&hba->pdev->dev,
+	hba->utrdl_base_addr = dma_alloc_coherent(hba->dev,
 						  utrdl_size,
 						  &hba->utrdl_dma_addr,
 						  GFP_KERNEL);
 	if (!hba->utrdl_base_addr ||
 	    WARN_ON(hba->utrdl_dma_addr & (PAGE_SIZE - 1))) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Transfer Descriptor Memory allocation failed\n");
 		goto out;
 	}
@@ -763,13 +677,13 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 * UFSHCI requires 1024 byte alignment of UTMRD
 	 */
 	utmrdl_size = sizeof(struct utp_task_req_desc) * hba->nutmrs;
-	hba->utmrdl_base_addr = dma_alloc_coherent(&hba->pdev->dev,
+	hba->utmrdl_base_addr = dma_alloc_coherent(hba->dev,
 						   utmrdl_size,
 						   &hba->utmrdl_dma_addr,
 						   GFP_KERNEL);
 	if (!hba->utmrdl_base_addr ||
 	    WARN_ON(hba->utmrdl_dma_addr & (PAGE_SIZE - 1))) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 		"Task Management Descriptor Memory allocation failed\n");
 		goto out;
 	}
@@ -777,7 +691,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	/* Allocate memory for local reference block */
 	hba->lrb = kcalloc(hba->nutrs, sizeof(struct ufshcd_lrb), GFP_KERNEL);
 	if (!hba->lrb) {
-		dev_err(&hba->pdev->dev, "LRB Memory allocation failed\n");
+		dev_err(hba->dev, "LRB Memory allocation failed\n");
 		goto out;
 	}
 	return 0;
@@ -867,7 +781,7 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 	/* check if controller is ready to accept UIC commands */
 	if (((readl(hba->mmio_base + REG_CONTROLLER_STATUS)) &
 	    UIC_COMMAND_READY) == 0x0) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Controller not ready"
 			" to accept UIC commands\n");
 		return -EIO;
@@ -912,7 +826,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	/* check if device present */
 	reg = readl((hba->mmio_base + REG_CONTROLLER_STATUS));
 	if (!ufshcd_is_device_present(reg)) {
-		dev_err(&hba->pdev->dev, "cc: Device not present\n");
+		dev_err(hba->dev, "cc: Device not present\n");
 		err = -ENXIO;
 		goto out;
 	}
@@ -924,7 +838,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	if (!(ufshcd_get_lists_status(reg))) {
 		ufshcd_enable_run_stop_reg(hba);
 	} else {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Host controller not ready to process requests");
 		err = -EIO;
 		goto out;
@@ -1005,7 +919,7 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 		if (retry) {
 			retry--;
 		} else {
-			dev_err(&hba->pdev->dev,
+			dev_err(hba->dev,
 				"Controller enable failed\n");
 			return -EIO;
 		}
@@ -1015,37 +929,6 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_initialize_hba - start the initialization process
- * @hba: per adapter instance
- *
- * 1. Enable the controller via ufshcd_hba_enable.
- * 2. Program the Transfer Request List Address with the starting address of
- * UTRDL.
- * 3. Program the Task Management Request List Address with starting address
- * of UTMRDL.
- *
- * Returns 0 on success, non-zero value on failure.
- */
-static int ufshcd_initialize_hba(struct ufs_hba *hba)
-{
-	if (ufshcd_hba_enable(hba))
-		return -EIO;
-
-	/* Configure UTRL and UTMRL base address registers */
-	writel(lower_32_bits(hba->utrdl_dma_addr),
-	       (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_L));
-	writel(upper_32_bits(hba->utrdl_dma_addr),
-	       (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_H));
-	writel(lower_32_bits(hba->utmrdl_dma_addr),
-	       (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_L));
-	writel(upper_32_bits(hba->utmrdl_dma_addr),
-	       (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_H));
-
-	/* Initialize unipro link startup procedure */
-	return ufshcd_dme_link_startup(hba);
-}
-
-/**
  * ufshcd_do_reset - reset the host controller
  * @hba: per adapter instance
  *
@@ -1084,7 +967,7 @@ static int ufshcd_do_reset(struct ufs_hba *hba)
 
 	/* start the initialization process */
 	if (ufshcd_initialize_hba(hba)) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Reset: Controller initialization failed\n");
 		return FAILED;
 	}
@@ -1167,7 +1050,7 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
 			task_result = SUCCESS;
 	} else {
 		task_result = FAILED;
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"trc: Invalid ocs = %x\n", ocs_value);
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -1281,7 +1164,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		/* check if the returned transfer response is valid */
 		result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
 		if (result) {
-			dev_err(&hba->pdev->dev,
+			dev_err(hba->dev,
 				"Invalid response = %x\n", result);
 			break;
 		}
@@ -1310,7 +1193,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case OCS_FATAL_ERROR:
 	default:
 		result |= DID_ERROR << 16;
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 		"OCS error from controller = %x\n", ocs);
 		break;
 	} /* end of switch */
@@ -1374,7 +1257,7 @@ static void ufshcd_uic_cc_handler (struct work_struct *work)
 	    !(ufshcd_get_uic_cmd_result(hba))) {
 
 		if (ufshcd_make_hba_operational(hba))
-			dev_err(&hba->pdev->dev,
+			dev_err(hba->dev,
 				"cc: hba not operational state\n");
 		return;
 	}
@@ -1509,7 +1392,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	free_slot = ufshcd_get_tm_free_slot(hba);
 	if (free_slot >= hba->nutmrs) {
 		spin_unlock_irqrestore(host->host_lock, flags);
-		dev_err(&hba->pdev->dev, "Task management queue full\n");
+		dev_err(hba->dev, "Task management queue full\n");
 		err = FAILED;
 		goto out;
 	}
@@ -1552,7 +1435,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 					 &hba->tm_condition) != 0),
 					 60 * HZ);
 	if (!err) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Task management command timed-out\n");
 		err = FAILED;
 		goto out;
@@ -1688,23 +1571,46 @@ static struct scsi_host_template ufshcd_driver_template = {
 };
 
 /**
- * ufshcd_shutdown - main function to put the controller in reset state
- * @pdev: pointer to PCI device handle
+ * ufshcd_initialize_hba - start the initialization process
+ * @hba: per adapter instance
+ *
+ * 1. Enable the controller via ufshcd_hba_enable.
+ * 2. Program the Transfer Request List Address with the starting address of
+ * UTRDL.
+ * 3. Program the Task Management Request List Address with starting address
+ * of UTMRDL.
+ *
+ * Returns 0 on success, non-zero value on failure.
  */
-static void ufshcd_shutdown(struct pci_dev *pdev)
+int ufshcd_initialize_hba(struct ufs_hba *hba)
 {
-	ufshcd_hba_stop((struct ufs_hba *)pci_get_drvdata(pdev));
+	if (ufshcd_hba_enable(hba))
+		return -EIO;
+
+	/* Configure UTRL and UTMRL base address registers */
+	writel(hba->utrdl_dma_addr,
+	       (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_L));
+	writel(lower_32_bits(hba->utrdl_dma_addr),
+	       (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_H));
+	writel(hba->utmrdl_dma_addr,
+	       (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_L));
+	writel(upper_32_bits(hba->utmrdl_dma_addr),
+	       (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_H));
+
+	/* Initialize unipro link startup procedure */
+	return ufshcd_dme_link_startup(hba);
 }
+EXPORT_SYMBOL(ufshcd_initialize_hba);
 
 #ifdef CONFIG_PM
 /**
  * ufshcd_suspend - suspend power management function
- * @pdev: pointer to PCI device handle
+ * @hba: pointer to host controller platform data
  * @state: power state
  *
  * Returns -ENOSYS
  */
-static int ufshcd_suspend(struct pci_dev *pdev, pm_message_t state)
+int ufshcd_suspend(struct ufs_hba *hba)
 {
 	/*
 	 * TODO:
@@ -1717,14 +1623,15 @@ static int ufshcd_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	return -ENOSYS;
 }
+EXPORT_SYMBOL(ufshcd_suspend);
 
 /**
  * ufshcd_resume - resume power management function
- * @pdev: pointer to PCI device handle
+ * @hba: pointer to host controller platform data
  *
  * Returns -ENOSYS
  */
-static int ufshcd_resume(struct pci_dev *pdev)
+int ufshcd_resume(struct ufs_hba *hba)
 {
 	/*
 	 * TODO:
@@ -1737,119 +1644,55 @@ static int ufshcd_resume(struct pci_dev *pdev)
 
 	return -ENOSYS;
 }
-#endif /* CONFIG_PM */
+EXPORT_SYMBOL(ufshcd_resume);
 
-/**
- * ufshcd_hba_free - free allocated memory for
- *			host memory space data structures
- * @hba: per adapter instance
- */
-static void ufshcd_hba_free(struct ufs_hba *hba)
-{
-	iounmap(hba->mmio_base);
-	ufshcd_free_hba_memory(hba);
-	pci_release_regions(hba->pdev);
-}
+#endif /* CONFIG_PM */
 
 /**
- * ufshcd_remove - de-allocate PCI/SCSI host and host memory space
+ * ufshcd_drv_exit - de-allocate SCSI host and host memory space
  *		data structure memory
- * @pdev - pointer to PCI handle
+ * @dev - pointer to host platform data
  */
-static void ufshcd_remove(struct pci_dev *pdev)
+void ufshcd_drv_exit(struct ufs_hba *hba)
 {
-	struct ufs_hba *hba = pci_get_drvdata(pdev);
-
 	/* disable interrupts */
 	ufshcd_int_config(hba, UFSHCD_INT_DISABLE);
-	free_irq(pdev->irq, hba);
+	free_irq(hba->irq, hba);
 
 	ufshcd_hba_stop(hba);
-	ufshcd_hba_free(hba);
+	ufshcd_free_hba_memory(hba);
 
 	scsi_remove_host(hba->host);
 	scsi_host_put(hba->host);
-	pci_set_drvdata(pdev, NULL);
-	pci_clear_master(pdev);
-	pci_disable_device(pdev);
 }
+EXPORT_SYMBOL(ufshcd_drv_exit);
 
 /**
- * ufshcd_set_dma_mask - Set dma mask based on the controller
- *			 addressing capability
- * @pdev: PCI device structure
- *
- * Returns 0 for success, non-zero for failure
- */
-static int ufshcd_set_dma_mask(struct ufs_hba *hba)
-{
-	int err;
-	u64 dma_mask;
-
-	/*
-	 * If controller supports 64 bit addressing mode, then set the DMA
-	 * mask to 64-bit, else set the DMA mask to 32-bit
-	 */
-	if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT)
-		dma_mask = DMA_BIT_MASK(64);
-	else
-		dma_mask = DMA_BIT_MASK(32);
-
-	err = pci_set_dma_mask(hba->pdev, dma_mask);
-	if (err)
-		return err;
-
-	err = pci_set_consistent_dma_mask(hba->pdev, dma_mask);
-
-	return err;
-}
-
-/**
- * ufshcd_probe - probe routine of the driver
- * @pdev: pointer to PCI device handle
- * @id: PCI device id
+ * ufshcd_drv_init - generic init routine of the driver
+ * @hba: pointer to platform data
  *
  * Returns 0 on success, non-zero value on failure
  */
-static int __devinit
-ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+int ufshcd_drv_init(struct ufs_hba **hostdata, struct device *dev,
+		 int irq_no, void __iomem *mmio_base)
 {
 	struct Scsi_Host *host;
-	struct ufs_hba *hba;
 	int err;
-
-	err = pci_enable_device(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "pci_enable_device failed\n");
-		goto out_error;
-	}
-
-	pci_set_master(pdev);
+	struct ufs_hba *hba;
 
 	host = scsi_host_alloc(&ufshcd_driver_template,
 				sizeof(struct ufs_hba));
 	if (!host) {
-		dev_err(&pdev->dev, "scsi_host_alloc failed\n");
+		dev_err(dev, "scsi_host_alloc failed\n");
 		err = -ENOMEM;
 		goto out_disable;
 	}
 	hba = shost_priv(host);
-
-	err = pci_request_regions(pdev, UFSHCD);
-	if (err < 0) {
-		dev_err(&pdev->dev, "request regions failed\n");
-		goto out_disable;
-	}
-
-	hba->mmio_base = pci_ioremap_bar(pdev, 0);
-	if (!hba->mmio_base) {
-		dev_err(&pdev->dev, "memory map failed\n");
-		err = -ENOMEM;
-		goto out_release_regions;
-	}
-
+	hba->dev = dev;
 	hba->host = host;
-	hba->pdev = pdev;
+	hba->irq = irq_no;
+	hba->mmio_base = mmio_base;
+	*hostdata = hba;
 
 	/* Read capabilities registers */
 	ufshcd_hba_capabilities(hba);
@@ -1857,17 +1700,11 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Get UFS version supported by the controller */
 	hba->ufs_version = ufshcd_get_ufs_version(hba);
 
-	err = ufshcd_set_dma_mask(hba);
-	if (err) {
-		dev_err(&pdev->dev, "set dma mask failed\n");
-		goto out_iounmap;
-	}
-
 	/* Allocate memory for host memory space */
 	err = ufshcd_memory_alloc(hba);
 	if (err) {
-		dev_err(&pdev->dev, "Memory allocation failed\n");
-		goto out_iounmap;
+		dev_err(hba->dev, "Memory allocation failed\n");
+		goto out_disable;
 	}
 
 	/* Configure LRB */
@@ -1889,72 +1726,52 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
 
 	/* IRQ registration */
-	err = request_irq(pdev->irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
+	err = request_irq(hba->irq, ufshcd_intr, IRQF_SHARED,
+			  ufs_hostname(hba), hba);
 	if (err) {
-		dev_err(&pdev->dev, "request irq failed\n");
+		dev_err(hba->dev, "request irq failed\n");
 		goto out_lrb_free;
 	}
 
 	/* Enable SCSI tag mapping */
 	err = scsi_init_shared_tag_map(host, host->can_queue);
 	if (err) {
-		dev_err(&pdev->dev, "init shared queue failed\n");
-		goto out_free_irq;
-	}
-
-	pci_set_drvdata(pdev, hba);
-
-	err = scsi_add_host(host, &pdev->dev);
-	if (err) {
-		dev_err(&pdev->dev, "scsi_add_host failed\n");
+		dev_err(hba->dev, "init shared queue failed\n");
 		goto out_free_irq;
 	}
 
-	/* Initialization routine */
-	err = ufshcd_initialize_hba(hba);
+	err = scsi_add_host(host, hba->dev);
 	if (err) {
-		dev_err(&pdev->dev, "Initialization failed\n");
+		dev_err(hba->dev, "scsi_add_host failed\n");
 		goto out_free_irq;
 	}
 
 	return 0;
 
 out_free_irq:
-	free_irq(pdev->irq, hba);
+	free_irq(hba->irq, hba);
 out_lrb_free:
 	ufshcd_free_hba_memory(hba);
-out_iounmap:
-	iounmap(hba->mmio_base);
-out_release_regions:
-	pci_release_regions(pdev);
 out_disable:
 	scsi_host_put(host);
-	pci_clear_master(pdev);
-	pci_disable_device(pdev);
-out_error:
 	return err;
 }
+EXPORT_SYMBOL(ufshcd_drv_init);
 
-static DEFINE_PCI_DEVICE_TABLE(ufshcd_pci_tbl) = {
-	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ }	/* terminate list */
-};
+static int __init ufshcd_probe(void)
+{
+	pr_info(UFSHCD ": Generic UFS host controller driver\n");
 
-MODULE_DEVICE_TABLE(pci, ufshcd_pci_tbl);
+	return 0;
+}
 
-static struct pci_driver ufshcd_pci_driver = {
-	.name = UFSHCD,
-	.id_table = ufshcd_pci_tbl,
-	.probe = ufshcd_probe,
-	.remove = __devexit_p(ufshcd_remove),
-	.shutdown = ufshcd_shutdown,
-#ifdef CONFIG_PM
-	.suspend = ufshcd_suspend,
-	.resume = ufshcd_resume,
-#endif
-};
+static void __exit ufshcd_remove(void)
+{
+	pr_info(UFSHCD ": Generic UFS host controller driver removed\n");
+}
 
-module_pci_driver(ufshcd_pci_driver);
+module_init(ufshcd_probe);
+module_exit(ufshcd_remove);
 
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>, "
 	      "Vinayak Holikatti <h.vinayak@samsung.com>");
-- 
1.7.4.1

