From: Girish K S <girish.shivananjappa@linaro.org>
Subject: [RFC RESEND 1/4] SCSI: UFS: remove all pci code from core driver
Date: Tue, 15 May 2012 15:06:24 +0530
Message-ID: <1337074587-29021-2-git-send-email-girish.shivananjappa@linaro.org>
References: <1337074587-29021-1-git-send-email-girish.shivananjappa@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33385 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2EOJhC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2012 05:37:02 -0400
Received: by dady13 with SMTP id y13so7089614dad.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 May 2012 02:37:01 -0700 (PDT)
In-Reply-To: <1337074587-29021-1-git-send-email-girish.shivananjappa@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, patches@linaro.org, Girish K S <girish.shivananjappa@linaro.org>

The existing driver was pci specific. This patch removes the
pci specific code from the core driver. Irrespective of the
pci or non-pci probe, the same core driver can be re-used.

Signed-off-by: Girish K S <girish.shivananjappa@linaro.org>
---
 drivers/scsi/ufs/ufs.h    |  103 ++++++++++++
 drivers/scsi/ufs/ufshcd.c |  377 ++++++++++-----------------------------------
 2 files changed, 184 insertions(+), 296 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index b207529..029a3f3 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -46,6 +46,8 @@
 #ifndef _UFS_H
 #define _UFS_H
 
+#define ufs_hostname(x)	(dev_name(&(x)->dev))
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
+	struct device dev;
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
+extern int ufshcd_probe(struct ufs_hba **hostdat, struct device *dev,
+			int irq_no, void __iomem *mmio_base);
+extern void ufshcd_remove(struct ufs_hba *hba);
+#ifdef CONFIG_PM
+extern int ufshcd_suspend(struct ufs_hba *hba);
+extern int ufshcd_resume(struct ufs_hba *hba);
+#endif /* CONFIG_PM */
+
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4e010b7..122cc61 100644
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
+		dma_free_coherent(&hba->dev, utmrdl_size,
 				  hba->utmrdl_base_addr, hba->utmrdl_dma_addr);
 	}
 
 	if (hba->utrdl_base_addr) {
 		utrdl_size =
 		(sizeof(struct utp_transfer_req_desc) * hba->nutrs);
-		dma_free_coherent(&hba->pdev->dev, utrdl_size,
+		dma_free_coherent(&hba->dev, utrdl_size,
 				  hba->utrdl_base_addr, hba->utrdl_dma_addr);
 	}
 
 	if (hba->ucdl_base_addr) {
 		ucdl_size =
 		(sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
-		dma_free_coherent(&hba->pdev->dev, ucdl_size,
+		dma_free_coherent(&hba->dev, ucdl_size,
 				  hba->ucdl_base_addr, hba->ucdl_dma_addr);
 	}
 }
@@ -724,7 +638,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 
 	/* Allocate memory for UTP command descriptors */
 	ucdl_size = (sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
-	hba->ucdl_base_addr = dma_alloc_coherent(&hba->pdev->dev,
+	hba->ucdl_base_addr = dma_alloc_coherent(&hba->dev,
 						 ucdl_size,
 						 &hba->ucdl_dma_addr,
 						 GFP_KERNEL);
@@ -737,7 +651,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 */
 	if (!hba->ucdl_base_addr ||
 	    WARN_ON(hba->ucdl_dma_addr & (PAGE_SIZE - 1))) {
-		dev_err(&hba->pdev->dev,
+		dev_err(&hba->dev,
 			"Command Descriptor Memory allocation failed\n");
 		goto out;
 	}
@@ -747,13 +661,13 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 * UFSHCI requires 1024 byte alignment of UTRD
 	 */
 	utrdl_size = (sizeof(struct utp_transfer_req_desc) * hba->nutrs);
-	hba->utrdl_base_addr = dma_alloc_coherent(&hba->pdev->dev,
+	hba->utrdl_base_addr = dma_alloc_coherent(&hba->dev,
 						  utrdl_size,
 						  &hba->utrdl_dma_addr,
 						  GFP_KERNEL);
 	if (!hba->utrdl_base_addr ||
 	    WARN_ON(hba->utrdl_dma_addr & (PAGE_SIZE - 1))) {
-		dev_err(&hba->pdev->dev,
+		dev_err(&hba->dev,
 			"Transfer Descriptor Memory allocation failed\n");
 		goto out;
 	}
@@ -763,13 +677,13 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 * UFSHCI requires 1024 byte alignment of UTMRD
 	 */
 	utmrdl_size = sizeof(struct utp_task_req_desc) * hba->nutmrs;
-	hba->utmrdl_base_addr = dma_alloc_coherent(&hba->pdev->dev,
+	hba->utmrdl_base_addr = dma_alloc_coherent(&hba->dev,
 						   utmrdl_size,
 						   &hba->utmrdl_dma_addr,
 						   GFP_KERNEL);
 	if (!hba->utmrdl_base_addr ||
 	    WARN_ON(hba->utmrdl_dma_addr & (PAGE_SIZE - 1))) {
-		dev_err(&hba->pdev->dev,
+		dev_err(&hba->dev,
 		"Task Management Descriptor Memory allocation failed\n");
 		goto out;
 	}
@@ -777,7 +691,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	/* Allocate memory for local reference block */
 	hba->lrb = kcalloc(hba->nutrs, sizeof(struct ufshcd_lrb), GFP_KERNEL);
 	if (!hba->lrb) {
-		dev_err(&hba->pdev->dev, "LRB Memory allocation failed\n");
+		dev_err(&hba->dev, "LRB Memory allocation failed\n");
 		goto out;
 	}
 	return 0;
@@ -867,7 +781,7 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 	/* check if controller is ready to accept UIC commands */
 	if (((readl(hba->mmio_base + REG_CONTROLLER_STATUS)) &
 	    UIC_COMMAND_READY) == 0x0) {
-		dev_err(&hba->pdev->dev,
+		dev_err(&hba->dev,
 			"Controller not ready"
 			" to accept UIC commands\n");
 		return -EIO;
@@ -912,7 +826,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	/* check if device present */
 	reg = readl((hba->mmio_base + REG_CONTROLLER_STATUS));
 	if (ufshcd_is_device_present(reg)) {
-		dev_err(&hba->pdev->dev, "cc: Device not present\n");
+		dev_err(&hba->dev, "cc: Device not present\n");
 		err = -ENXIO;
 		goto out;
 	}
@@ -924,7 +838,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	if (!(ufshcd_get_lists_status(reg))) {
 		ufshcd_enable_run_stop_reg(hba);
 	} else {
-		dev_err(&hba->pdev->dev,
+		dev_err(&hba->dev,
 			"Host controller not ready to process requests");
 		err = -EIO;
 		goto out;
@@ -1005,7 +919,7 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 		if (retry) {
 			retry--;
 		} else {
-			dev_err(&hba->pdev->dev,
+			dev_err(&hba->dev,
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
+		dev_err(&hba->dev,
 			"Reset: Controller initialization failed\n");
 		return FAILED;
 	}
@@ -1165,7 +1048,7 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
 			task_result = FAILED;
 	} else {
 		task_result = FAILED;
-		dev_err(&hba->pdev->dev,
+		dev_err(&hba->dev,
 			"trc: Invalid ocs = %x\n", ocs_value);
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -1279,7 +1162,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		/* check if the returned transfer response is valid */
 		result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
 		if (result) {
-			dev_err(&hba->pdev->dev,
+			dev_err(&hba->dev,
 				"Invalid response = %x\n", result);
 			break;
 		}
@@ -1308,7 +1191,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case OCS_FATAL_ERROR:
 	default:
 		result |= DID_ERROR << 16;
-		dev_err(&hba->pdev->dev,
+		dev_err(&hba->dev,
 		"OCS error from controller = %x\n", ocs);
 		break;
 	} /* end of switch */
@@ -1372,7 +1255,7 @@ static void ufshcd_uic_cc_handler (struct work_struct *work)
 	    !(ufshcd_get_uic_cmd_result(hba))) {
 
 		if (ufshcd_make_hba_operational(hba))
-			dev_err(&hba->pdev->dev,
+			dev_err(&hba->dev,
 				"cc: hba not operational state\n");
 		return;
 	}
@@ -1507,7 +1390,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	free_slot = ufshcd_get_tm_free_slot(hba);
 	if (free_slot >= hba->nutmrs) {
 		spin_unlock_irqrestore(host->host_lock, flags);
-		dev_err(&hba->pdev->dev, "Task management queue full\n");
+		dev_err(&hba->dev, "Task management queue full\n");
 		err = FAILED;
 		goto out;
 	}
@@ -1550,7 +1433,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 					 &hba->tm_condition) != 0),
 					 60 * HZ);
 	if (!err) {
-		dev_err(&hba->pdev->dev,
+		dev_err(&hba->dev,
 			"Task management command timed-out\n");
 		err = FAILED;
 		goto out;
@@ -1686,23 +1569,46 @@ static struct scsi_host_template ufshcd_driver_template = {
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
@@ -1715,14 +1621,15 @@ static int ufshcd_suspend(struct pci_dev *pdev, pm_message_t state)
 
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
@@ -1735,119 +1642,55 @@ static int ufshcd_resume(struct pci_dev *pdev)
 
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
+ * ufshcd_remove - de-allocate SCSI host and host memory space
  *		data structure memory
- * @pdev - pointer to PCI handle
+ * @dev - pointer to host platform data
  */
-static void ufshcd_remove(struct pci_dev *pdev)
+void ufshcd_remove(struct ufs_hba *hba)
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
-}
-
-/**
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
 }
+EXPORT_SYMBOL(ufshcd_remove);
 
 /**
- * ufshcd_probe - probe routine of the driver
- * @pdev: pointer to PCI device handle
- * @id: PCI device id
+ * ufshcd_probe - generic probe routine of the driver
+ * @hba: pointer to platform data
  *
  * Returns 0 on success, non-zero value on failure
  */
-static int __devinit
-ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+int ufshcd_probe(struct ufs_hba **hostdata, struct device *dev,
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
+		dev_err(&hba->dev, "scsi_host_alloc failed\n");
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
+	hba->dev = *dev;
 	hba->host = host;
-	hba->pdev = pdev;
+	hba->irq = irq_no;
+	hba->mmio_base = mmio_base;
+	*hostdata = hba;
 
 	/* Read capabilities registers */
 	ufshcd_hba_capabilities(hba);
@@ -1855,17 +1698,11 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
+		dev_err(&hba->dev, "Memory allocation failed\n");
+		goto out_disable;
 	}
 
 	/* Configure LRB */
@@ -1887,89 +1724,37 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
 
 	/* IRQ registration */
-	err = request_irq(pdev->irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
+	err = request_irq(hba->irq, ufshcd_intr, IRQF_SHARED,
+			  ufs_hostname(hba), hba);
 	if (err) {
-		dev_err(&pdev->dev, "request irq failed\n");
+		dev_err(&hba->dev, "request irq failed\n");
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
+		dev_err(&hba->dev, "init shared queue failed\n");
 		goto out_free_irq;
 	}
 
-	/* Initialization routine */
-	err = ufshcd_initialize_hba(hba);
+	err = scsi_add_host(host, &hba->dev);
 	if (err) {
-		dev_err(&pdev->dev, "Initialization failed\n");
+		dev_err(&hba->dev, "scsi_add_host failed\n");
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
-{
-	return pci_register_driver(&ufshcd_pci_driver);
-}
-module_init(ufshcd_init);
-
-/**
- * ufshcd_exit - Driver exit clean-up routine
- */
-static void __exit ufshcd_exit(void)
-{
-	pci_unregister_driver(&ufshcd_pci_driver);
-}
-module_exit(ufshcd_exit);
-
+EXPORT_SYMBOL(ufshcd_probe);
 
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>, "
 	      "Vinayak Holikatti <h.vinayak@samsung.com>");
-- 
1.7.4.1

