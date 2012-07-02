From: Vinayak Holikatti <vinholikatti@gmail.com>
Subject: [PATCH 1/4] [SCSI] ufs: Separate PCI glue driver for ufshcd
Date: Mon,  2 Jul 2012 20:02:49 +0530
Message-ID: <1341239572-7408-2-git-send-email-vinholikatti@gmail.com>
References: <1341239572-7408-1-git-send-email-vinholikatti@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341239572-7408-1-git-send-email-vinholikatti@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, yejin.moon@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, stephen.doel@linaro.org, sreekumar.c@samsung.com, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patch separates PCI and core UFS host controller driver.
In the current implementation PCI specific code is with ufshcd.c.
To provide way for adding multiple bus glue driver, this patch
separates PCI layer from ufshcd core. Now ufshcd compiles as separate
module and ufshcd-pci as separate module.

Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
---
 drivers/scsi/ufs/Kconfig         |   26 ++-
 drivers/scsi/ufs/Makefile        |    1 +
 drivers/scsi/ufs/ufshcd-pci.c    |  227 ++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c        |  420 ++++++--------------------------------
 drivers/scsi/ufs/ufshcd.h        |  206 +++++++++++++++++++
 drivers/scsi/ufs/ufshcd_common.h |   53 +++++
 6 files changed, 577 insertions(+), 356 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
 create mode 100644 drivers/scsi/ufs/ufshcd.h
 create mode 100644 drivers/scsi/ufs/ufshcd_common.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 8f27f9d..265a8c8 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -43,7 +43,27 @@
 # USA.
 
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
+	This selects the PCI UFS Host Controller Interface.
+	  Most controllers found today are PCI devices.
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
index 0000000..0c0cc92
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -0,0 +1,227 @@
+/*
+ * Universal Flash Storage Host controller driver
+ *
+ * This code is based on drivers/scsi/ufs/ufshcd-pci.c
+ * Copyright (C) 2011-2012 Samsung India Software Operations
+ *
+ * Santosh Yaraganavi <santosh.sy@samsung.com>
+ * Vinayak Holikatti <h.vinayak@samsung.com>
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
+#include "ufshcd.h"
+#include "ufshcd_common.h"
+#include <linux/pci.h>
+
+#ifdef CONFIG_PM
+/**
+ * ufshcd_suspend - suspend power management function
+ * @pdev: pointer to PCI device handle
+ * @state: power state
+ *
+ * Returns -ENOSYS
+ */
+static int ufshcd_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	/*
+	 * TODO:
+	 * 1. Block SCSI requests from SCSI midlayer
+	 * 2. Change the internal driver state to non operational
+	 * 3. Set UTRLRSR and UTMRLRSR bits to zero
+	 * 4. Wait until outstanding commands are completed
+	 * 5. Set HCE to zero to send the UFS host controller to reset state
+	 */
+
+	return -ENOSYS;
+}
+
+/**
+ * ufshcd_resume - resume power management function
+ * @pdev: pointer to PCI device handle
+ *
+ * Returns -ENOSYS
+ */
+static int ufshcd_pci_resume(struct pci_dev *pdev)
+{
+	/*
+	 * TODO:
+	 * 1. Set HCE to 1, to start the UFS host controller
+	 * initialization process
+	 * 2. Set UTRLRSR and UTMRLRSR bits to 1
+	 * 3. Change the internal driver state to operational
+	 * 4. Unblock SCSI requests from SCSI midlayer
+	 */
+
+	return -ENOSYS;
+}
+#endif /* CONFIG_PM */
+
+/**
+ * ufshcd_shutdown - main function to put the controller in reset state
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
+	ufshcd_remove(hba);
+	free_irq(pdev->irq, hba);
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
+		dev_err(&pdev->dev, "%s:%d %sInitialization failed\n",
+				__FILE__, __LINE__, __func__);
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
+MODULE_DESCRIPTION("PCI based UFS host controller driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(UFSHCD_DRIVER_VERSION);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6a4fd00..dfc3e85 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -43,35 +43,7 @@
  * USA.
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
@@ -102,121 +74,6 @@ enum {
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
@@ -335,21 +192,21 @@ static inline void ufshcd_free_hba_memory(struct ufs_hba *hba)
 
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
@@ -429,15 +286,6 @@ static void ufshcd_enable_run_stop_reg(struct ufs_hba *hba)
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
@@ -724,7 +572,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 
 	/* Allocate memory for UTP command descriptors */
 	ucdl_size = (sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
-	hba->ucdl_base_addr = dma_alloc_coherent(&hba->pdev->dev,
+	hba->ucdl_base_addr = dma_alloc_coherent(hba->dev,
 						 ucdl_size,
 						 &hba->ucdl_dma_addr,
 						 GFP_KERNEL);
@@ -737,7 +585,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 */
 	if (!hba->ucdl_base_addr ||
 	    WARN_ON(hba->ucdl_dma_addr & (PAGE_SIZE - 1))) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Command Descriptor Memory allocation failed\n");
 		goto out;
 	}
@@ -747,13 +595,13 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
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
@@ -763,13 +611,13 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
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
@@ -777,7 +625,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	/* Allocate memory for local reference block */
 	hba->lrb = kcalloc(hba->nutrs, sizeof(struct ufshcd_lrb), GFP_KERNEL);
 	if (!hba->lrb) {
-		dev_err(&hba->pdev->dev, "LRB Memory allocation failed\n");
+		dev_err(hba->dev, "LRB Memory allocation failed\n");
 		goto out;
 	}
 	return 0;
@@ -867,7 +715,7 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 	/* check if controller is ready to accept UIC commands */
 	if (((readl(hba->mmio_base + REG_CONTROLLER_STATUS)) &
 	    UIC_COMMAND_READY) == 0x0) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Controller not ready"
 			" to accept UIC commands\n");
 		return -EIO;
@@ -912,7 +760,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	/* check if device present */
 	reg = readl((hba->mmio_base + REG_CONTROLLER_STATUS));
 	if (ufshcd_is_device_present(reg)) {
-		dev_err(&hba->pdev->dev, "cc: Device not present\n");
+		dev_err(hba->dev, "cc: Device not present\n");
 		err = -ENXIO;
 		goto out;
 	}
@@ -924,7 +772,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	if (!(ufshcd_get_lists_status(reg))) {
 		ufshcd_enable_run_stop_reg(hba);
 	} else {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Host controller not ready to process requests");
 		err = -EIO;
 		goto out;
@@ -1005,7 +853,7 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 		if (retry) {
 			retry--;
 		} else {
-			dev_err(&hba->pdev->dev,
+			dev_err(hba->dev,
 				"Controller enable failed\n");
 			return -EIO;
 		}
@@ -1084,7 +932,7 @@ static int ufshcd_do_reset(struct ufs_hba *hba)
 
 	/* start the initialization process */
 	if (ufshcd_initialize_hba(hba)) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Reset: Controller initialization failed\n");
 		return FAILED;
 	}
@@ -1165,7 +1013,7 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
 			task_result = FAILED;
 	} else {
 		task_result = FAILED;
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"trc: Invalid ocs = %x\n", ocs_value);
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -1279,7 +1127,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		/* check if the returned transfer response is valid */
 		result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
 		if (result) {
-			dev_err(&hba->pdev->dev,
+			dev_err(hba->dev,
 				"Invalid response = %x\n", result);
 			break;
 		}
@@ -1308,7 +1156,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case OCS_FATAL_ERROR:
 	default:
 		result |= DID_ERROR << 16;
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 		"OCS error from controller = %x\n", ocs);
 		break;
 	} /* end of switch */
@@ -1372,7 +1220,7 @@ static void ufshcd_uic_cc_handler (struct work_struct *work)
 	    !(ufshcd_get_uic_cmd_result(hba))) {
 
 		if (ufshcd_make_hba_operational(hba))
-			dev_err(&hba->pdev->dev,
+			dev_err(hba->dev,
 				"cc: hba not operational state\n");
 		return;
 	}
@@ -1507,7 +1355,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	free_slot = ufshcd_get_tm_free_slot(hba);
 	if (free_slot >= hba->nutmrs) {
 		spin_unlock_irqrestore(host->host_lock, flags);
-		dev_err(&hba->pdev->dev, "Task management queue full\n");
+		dev_err(hba->dev, "Task management queue full\n");
 		err = FAILED;
 		goto out;
 	}
@@ -1550,7 +1398,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 					 &hba->tm_condition) != 0),
 					 60 * HZ);
 	if (!err) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Task management command timed-out\n");
 		err = FAILED;
 		goto out;
@@ -1685,57 +1533,6 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.can_queue		= UFSHCD_CAN_QUEUE,
 };
 
-/**
- * ufshcd_shutdown - main function to put the controller in reset state
- * @pdev: pointer to PCI device handle
- */
-static void ufshcd_shutdown(struct pci_dev *pdev)
-{
-	ufshcd_hba_stop((struct ufs_hba *)pci_get_drvdata(pdev));
-}
-
-#ifdef CONFIG_PM
-/**
- * ufshcd_suspend - suspend power management function
- * @pdev: pointer to PCI device handle
- * @state: power state
- *
- * Returns -ENOSYS
- */
-static int ufshcd_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	/*
-	 * TODO:
-	 * 1. Block SCSI requests from SCSI midlayer
-	 * 2. Change the internal driver state to non operational
-	 * 3. Set UTRLRSR and UTMRLRSR bits to zero
-	 * 4. Wait until outstanding commands are completed
-	 * 5. Set HCE to zero to send the UFS host controller to reset state
-	 */
-
-	return -ENOSYS;
-}
-
-/**
- * ufshcd_resume - resume power management function
- * @pdev: pointer to PCI device handle
- *
- * Returns -ENOSYS
- */
-static int ufshcd_resume(struct pci_dev *pdev)
-{
-	/*
-	 * TODO:
-	 * 1. Set HCE to 1, to start the UFS host controller
-	 * initialization process
-	 * 2. Set UTRLRSR and UTMRLRSR bits to 1
-	 * 3. Change the internal driver state to operational
-	 * 4. Unblock SCSI requests from SCSI midlayer
-	 */
-
-	return -ENOSYS;
-}
-#endif /* CONFIG_PM */
 
 /**
  * ufshcd_hba_free - free allocated memory for
@@ -1746,108 +1543,59 @@ static void ufshcd_hba_free(struct ufs_hba *hba)
 {
 	iounmap(hba->mmio_base);
 	ufshcd_free_hba_memory(hba);
-	pci_release_regions(hba->pdev);
 }
 
 /**
- * ufshcd_remove - de-allocate PCI/SCSI host and host memory space
+ * ufshcd_remove - de-allocate SCSI host and host memory space
  *		data structure memory
- * @pdev - pointer to PCI handle
+ * @hba - per adapter instance
  */
-static void ufshcd_remove(struct pci_dev *pdev)
+void ufshcd_remove(struct ufs_hba *hba)
 {
-	struct ufs_hba *hba = pci_get_drvdata(pdev);
-
 	/* disable interrupts */
 	ufshcd_int_config(hba, UFSHCD_INT_DISABLE);
-	free_irq(pdev->irq, hba);
 
 	ufshcd_hba_stop(hba);
 	ufshcd_hba_free(hba);
 
 	scsi_remove_host(hba->host);
 	scsi_host_put(hba->host);
-	pci_set_drvdata(pdev, NULL);
-	pci_clear_master(pdev);
-	pci_disable_device(pdev);
 }
+EXPORT_SYMBOL(ufshcd_remove);
 
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
- *
+ * ufshcd_init - Driver initialization routine
+ * @dev: pointer to device handle
+ * @hba_handle: driver private handle
+ * @mmio_base: base register address
+ * @irq_line: Interrupt line of device
  * Returns 0 on success, non-zero value on failure
  */
-static int __devinit
-ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
+		 void __iomem *mmio_base, unsigned int irq_line)
 {
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
 	int err;
 
-	err = pci_enable_device(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "pci_enable_device failed\n");
+	if (!dev && !mmio_base) {
+		dev_err(dev,
+		"Invalid memory reference for dev or mmio_base NULL\n");
+		err = -ENODEV;
 		goto out_error;
 	}
 
-	pci_set_master(pdev);
-
 	host = scsi_host_alloc(&ufshcd_driver_template,
 				sizeof(struct ufs_hba));
 	if (!host) {
-		dev_err(&pdev->dev, "scsi_host_alloc failed\n");
+		dev_err(dev, "scsi_host_alloc failed\n");
 		err = -ENOMEM;
-		goto out_disable;
+		goto out_error;
 	}
 	hba = shost_priv(host);
-
-	err = pci_request_regions(pdev, UFSHCD);
-	if (err < 0) {
-		dev_err(&pdev->dev, "request regions failed\n");
-		goto out_host_put;
-	}
-
-	hba->mmio_base = pci_ioremap_bar(pdev, 0);
-	if (!hba->mmio_base) {
-		dev_err(&pdev->dev, "memory map failed\n");
-		err = -ENOMEM;
-		goto out_release_regions;
-	}
-
 	hba->host = host;
-	hba->pdev = pdev;
+	hba->dev = dev;
+	hba->mmio_base = mmio_base;
 
 	/* Read capabilities registers */
 	ufshcd_hba_capabilities(hba);
@@ -1855,17 +1603,11 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1887,93 +1629,65 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
 
 	/* IRQ registration */
-	err = request_irq(pdev->irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
+	err = request_irq(irq_line, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
 	if (err) {
-		dev_err(&pdev->dev, "request irq failed\n");
+		dev_err(hba->dev, "request irq failed\n");
 		goto out_lrb_free;
 	}
 
 	/* Enable SCSI tag mapping */
 	err = scsi_init_shared_tag_map(host, host->can_queue);
 	if (err) {
-		dev_err(&pdev->dev, "init shared queue failed\n");
+		dev_err(hba->dev, "init shared queue failed\n");
 		goto out_free_irq;
 	}
 
-	pci_set_drvdata(pdev, hba);
-
-	err = scsi_add_host(host, &pdev->dev);
+	err = scsi_add_host(host, hba->dev);
 	if (err) {
-		dev_err(&pdev->dev, "scsi_add_host failed\n");
+		dev_err(hba->dev, "scsi_add_host failed\n");
 		goto out_free_irq;
 	}
 
 	/* Initialization routine */
 	err = ufshcd_initialize_hba(hba);
 	if (err) {
-		dev_err(&pdev->dev, "Initialization failed\n");
-		goto out_free_irq;
+		dev_err(hba->dev, "Initialization failed\n");
+		goto out_remove_scsi_host;
 	}
+	*hba_handle = hba;
 
 	return 0;
 
+out_remove_scsi_host:
+	scsi_remove_host(hba->host);
 out_free_irq:
-	free_irq(pdev->irq, hba);
+	free_irq(irq_line, hba);
 out_lrb_free:
 	ufshcd_free_hba_memory(hba);
-out_iounmap:
-	iounmap(hba->mmio_base);
-out_release_regions:
-	pci_release_regions(pdev);
-out_host_put:
-	scsi_host_put(host);
 out_disable:
-	pci_clear_master(pdev);
-	pci_disable_device(pdev);
+	scsi_host_put(host);
 out_error:
 	return err;
 }
+EXPORT_SYMBOL(ufshcd_init);
 
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
-	.probe = ufshcd_probe,
-	.remove = __devexit_p(ufshcd_remove),
-	.shutdown = ufshcd_shutdown,
-#ifdef CONFIG_PM
-	.suspend = ufshcd_suspend,
-	.resume = ufshcd_resume,
-#endif
-};
-
-/**
- * ufshcd_init - Driver registration routine
- */
-static int __init ufshcd_init(void)
+static int __init ufshcd_module_init(void)
 {
-	return pci_register_driver(&ufshcd_pci_driver);
+	pr_info("UFS Host Driver Core loaded\n");
+	return 0;
 }
-module_init(ufshcd_init);
 
-/**
- * ufshcd_exit - Driver exit clean-up routine
- */
-static void __exit ufshcd_exit(void)
+static void __exit ufshcd_module_exit(void)
 {
-	pci_unregister_driver(&ufshcd_pci_driver);
+	pr_info("UFS Host Driver Core unloaded\n");
 }
-module_exit(ufshcd_exit);
+
+module_init(ufshcd_module_init);
+module_exit(ufshcd_module_exit);
 
 
-MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>, "
-	      "Vinayak Holikatti <h.vinayak@samsung.com>");
-MODULE_DESCRIPTION("Generic UFS host controller driver");
+MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
+MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
+MODULE_DESCRIPTION("Generic Core UFS host controller driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(UFSHCD_DRIVER_VERSION);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
new file mode 100644
index 0000000..40cb1f7
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -0,0 +1,206 @@
+/*
+ * Universal Flash Storage Host controller driver
+ *
+ * This code is based on drivers/scsi/ufs/ufshcd.h
+ * Copyright (C) 2011-2012 Samsung India Software Operations
+ *
+ * Santosh Yaraganavi <santosh.sy@samsung.com>
+ * Vinayak Holikatti <h.vinayak@samsung.com>
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
+	unsigned int irq;
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
+};
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
diff --git a/drivers/scsi/ufs/ufshcd_common.h b/drivers/scsi/ufs/ufshcd_common.h
new file mode 100644
index 0000000..e027727
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd_common.h
@@ -0,0 +1,53 @@
+/*
+ * Universal Flash Storage Host controller driver
+ *
+ * This code is based on drivers/scsi/ufs/ufshcd_common.h
+ * Copyright (C) 2011-2012 Samsung India Software Operations
+ *
+ * Santosh Yaraganavi <santosh.sy@samsung.com>
+ * Vinayak Holikatti <h.vinayak@samsung.com>
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
+#ifndef _UFSHCD_COMMON_H
+#define _UFSHCD_COMMON_H
+
+extern int ufshcd_init(struct device *, struct ufs_hba ** , void __iomem * ,
+			int);
+extern int ufshcd_remove(struct ufs_hba *);
+
+#endif /* END of Header */
-- 
1.7.5.4
