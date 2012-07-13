From: Vinayak Holikatti <vinholikatti@gmail.com>
Subject: [PATCH V2 1/4] [SCSI] drivers/scsi/ufs: Remove PCI specific code
Date: Fri, 13 Jul 2012 19:37:42 +0530
Message-ID: <1342188465-20239-2-git-send-email-vinholikatti@gmail.com>
References: <1342188465-20239-1-git-send-email-vinholikatti@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:50189 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162569Ab2GMOI1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jul 2012 10:08:27 -0400
In-Reply-To: <1342188465-20239-1-git-send-email-vinholikatti@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, sreekumar.c@samsung.com, Vinayak Holikatti <vinholikatti@gmail.com>

This patch removes the PCI specific code to make it into
core ufs driver. This separation allows room for other
bus specific glue drivers to be added in future

Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
---
 drivers/scsi/ufs/Kconfig  |   15 ++-
 drivers/scsi/ufs/ufshcd.c |  270 ++++++++++++---------------------------------
 2 files changed, 80 insertions(+), 205 deletions(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 8f27f9d..8c0cd22 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -43,7 +43,16 @@
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
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6a4fd00..ef442c9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -129,7 +129,7 @@ struct uic_command {
  * @utrdl_dma_addr: UTRDL DMA address
  * @utmrdl_dma_addr: UTMRDL DMA address
  * @host: Scsi_Host instance of the driver
- * @pdev: PCI device handle
+ * @dev: device handle
  * @lrb: local reference block
  * @outstanding_tasks: Bits representing outstanding task requests
  * @outstanding_reqs: Bits representing outstanding transfer requests
@@ -159,7 +159,7 @@ struct ufs_hba {
 	dma_addr_t utmrdl_dma_addr;
 
 	struct Scsi_Host *host;
-	struct pci_dev *pdev;
+	struct device *dev;
 
 	struct ufshcd_lrb *lrb;
 
@@ -335,21 +335,21 @@ static inline void ufshcd_free_hba_memory(struct ufs_hba *hba)
 
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
@@ -724,7 +724,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 
 	/* Allocate memory for UTP command descriptors */
 	ucdl_size = (sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
-	hba->ucdl_base_addr = dma_alloc_coherent(&hba->pdev->dev,
+	hba->ucdl_base_addr = dma_alloc_coherent(hba->dev,
 						 ucdl_size,
 						 &hba->ucdl_dma_addr,
 						 GFP_KERNEL);
@@ -737,7 +737,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 */
 	if (!hba->ucdl_base_addr ||
 	    WARN_ON(hba->ucdl_dma_addr & (PAGE_SIZE - 1))) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Command Descriptor Memory allocation failed\n");
 		goto out;
 	}
@@ -747,13 +747,13 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
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
@@ -763,13 +763,13 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
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
@@ -777,7 +777,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	/* Allocate memory for local reference block */
 	hba->lrb = kcalloc(hba->nutrs, sizeof(struct ufshcd_lrb), GFP_KERNEL);
 	if (!hba->lrb) {
-		dev_err(&hba->pdev->dev, "LRB Memory allocation failed\n");
+		dev_err(hba->dev, "LRB Memory allocation failed\n");
 		goto out;
 	}
 	return 0;
@@ -867,7 +867,7 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 	/* check if controller is ready to accept UIC commands */
 	if (((readl(hba->mmio_base + REG_CONTROLLER_STATUS)) &
 	    UIC_COMMAND_READY) == 0x0) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Controller not ready"
 			" to accept UIC commands\n");
 		return -EIO;
@@ -912,7 +912,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	/* check if device present */
 	reg = readl((hba->mmio_base + REG_CONTROLLER_STATUS));
 	if (ufshcd_is_device_present(reg)) {
-		dev_err(&hba->pdev->dev, "cc: Device not present\n");
+		dev_err(hba->dev, "cc: Device not present\n");
 		err = -ENXIO;
 		goto out;
 	}
@@ -924,7 +924,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	if (!(ufshcd_get_lists_status(reg))) {
 		ufshcd_enable_run_stop_reg(hba);
 	} else {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Host controller not ready to process requests");
 		err = -EIO;
 		goto out;
@@ -1005,7 +1005,7 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 		if (retry) {
 			retry--;
 		} else {
-			dev_err(&hba->pdev->dev,
+			dev_err(hba->dev,
 				"Controller enable failed\n");
 			return -EIO;
 		}
@@ -1084,7 +1084,7 @@ static int ufshcd_do_reset(struct ufs_hba *hba)
 
 	/* start the initialization process */
 	if (ufshcd_initialize_hba(hba)) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Reset: Controller initialization failed\n");
 		return FAILED;
 	}
@@ -1165,7 +1165,7 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
 			task_result = FAILED;
 	} else {
 		task_result = FAILED;
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"trc: Invalid ocs = %x\n", ocs_value);
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -1279,7 +1279,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		/* check if the returned transfer response is valid */
 		result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
 		if (result) {
-			dev_err(&hba->pdev->dev,
+			dev_err(hba->dev,
 				"Invalid response = %x\n", result);
 			break;
 		}
@@ -1308,7 +1308,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case OCS_FATAL_ERROR:
 	default:
 		result |= DID_ERROR << 16;
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 		"OCS error from controller = %x\n", ocs);
 		break;
 	} /* end of switch */
@@ -1372,7 +1372,7 @@ static void ufshcd_uic_cc_handler (struct work_struct *work)
 	    !(ufshcd_get_uic_cmd_result(hba))) {
 
 		if (ufshcd_make_hba_operational(hba))
-			dev_err(&hba->pdev->dev,
+			dev_err(hba->dev,
 				"cc: hba not operational state\n");
 		return;
 	}
@@ -1507,7 +1507,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	free_slot = ufshcd_get_tm_free_slot(hba);
 	if (free_slot >= hba->nutmrs) {
 		spin_unlock_irqrestore(host->host_lock, flags);
-		dev_err(&hba->pdev->dev, "Task management queue full\n");
+		dev_err(hba->dev, "Task management queue full\n");
 		err = FAILED;
 		goto out;
 	}
@@ -1550,7 +1550,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 					 &hba->tm_condition) != 0),
 					 60 * HZ);
 	if (!err) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Task management command timed-out\n");
 		err = FAILED;
 		goto out;
@@ -1685,57 +1685,6 @@ static struct scsi_host_template ufshcd_driver_template = {
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
@@ -1746,108 +1695,59 @@ static void ufshcd_hba_free(struct ufs_hba *hba)
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
@@ -1855,17 +1755,11 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1887,93 +1781,65 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
-- 
1.7.9.5

