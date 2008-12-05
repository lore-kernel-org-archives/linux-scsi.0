From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 9/14] lpfc 8.3.0 :  Add active interrupt test for enabling
	MSI/MSI-X/INTx
Date: Thu, 4 Dec 2008 22:39:35 -0500
Message-ID: <1228448375.19053.51.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45946 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYLEOno (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 09:43:44 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mB5EhhkJ004255
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 06:43:43 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lpfc 8.3.0 : Added active interrupt test for enabling MSI/MSI-X/INTx

Per the recent discussions at the Linux Plumbers Conference, when
enabling MSI or MSI-X, generate a test interrupt to verify the
interrupt routing is working properly.  If the test interrupt fails,
fall back to MSI first, and if that fails as well, to INTx.  If the
interrupt test fails with INTx, log an error and fail the PCI probe.

Also changed the use of spin_(lock|unlock) to the _irq(save|restore)
variants in the interrupt handlers because with multi-message MSI-X,
both interrupt handlers can now run in parallel.


Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc.h      |    2 
 drivers/scsi/lpfc/lpfc_init.c |  410 +++++++++++++++++++++++++++--------------
 drivers/scsi/lpfc/lpfc_mbox.c |    6 -
 drivers/scsi/lpfc/lpfc_sli.c  |   38 ++--
 4 files changed, 302 insertions(+), 154 deletions(-)

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -592,6 +592,8 @@ struct lpfc_hba {
 
 	struct fc_host_statistics link_stats;
 	enum intr_type_t intr_type;
+	uint32_t intr_mode;
+#define LPFC_INTR_ERROR	0xFFFFFFFF
 	struct msix_entry msix_entries[LPFC_MSIX_VECTORS];
 
 	struct list_head port_list;
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2274,8 +2274,7 @@ lpfc_enable_msix(struct lpfc_hba *phba)
 				ARRAY_SIZE(phba->msix_entries));
 	if (rc) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0420 Enable MSI-X failed (%d), continuing "
-				"with MSI\n", rc);
+				"0420 PCI enable MSI-X failed (%d)\n", rc);
 		goto msi_fail_out;
 	} else
 		for (i = 0; i < LPFC_MSIX_VECTORS; i++)
@@ -2292,9 +2291,9 @@ lpfc_enable_msix(struct lpfc_hba *phba)
 	rc = request_irq(phba->msix_entries[0].vector, &lpfc_sp_intr_handler,
 			 IRQF_SHARED, LPFC_SP_DRIVER_HANDLER_NAME, phba);
 	if (rc) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0421 MSI-X slow-path request_irq failed "
-				"(%d), continuing with MSI\n", rc);
+				"(%d)\n", rc);
 		goto msi_fail_out;
 	}
 
@@ -2303,9 +2302,9 @@ lpfc_enable_msix(struct lpfc_hba *phba)
 			 IRQF_SHARED, LPFC_FP_DRIVER_HANDLER_NAME, phba);
 
 	if (rc) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0429 MSI-X fast-path request_irq failed "
-				"(%d), continuing with MSI\n", rc);
+				"(%d)\n", rc);
 		goto irq_fail_out;
 	}
 
@@ -2326,7 +2325,7 @@ lpfc_enable_msix(struct lpfc_hba *phba)
 		goto mbx_fail_out;
 	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
 	if (rc != MBX_SUCCESS) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
+		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
 				"0351 Config MSI mailbox command failed, "
 				"mbxCmd x%x, mbxStatus x%x\n",
 				pmb->mb.mbxCommand, pmb->mb.mbxStatus);
@@ -2375,6 +2374,195 @@ lpfc_disable_msix(struct lpfc_hba *phba)
 }
 
 /**
+ * lpfc_enable_msi: Enable MSI interrupt mode.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to enable the MSI interrupt mode. The kernel
+ * function pci_enable_msi() is called to enable the MSI vector. The
+ * device driver is responsible for calling the request_irq() to register
+ * MSI vector with a interrupt the handler, which is done in this function.
+ *
+ * Return codes
+ * 	0 - sucessful
+ * 	other values - error
+ */
+static int
+lpfc_enable_msi(struct lpfc_hba *phba)
+{
+	int rc;
+
+	rc = pci_enable_msi(phba->pcidev);
+	if (!rc)
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0462 PCI enable MSI mode success.\n");
+	else {
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0471 PCI enable MSI mode failed (%d)\n", rc);
+		return rc;
+	}
+
+	rc = request_irq(phba->pcidev->irq, lpfc_intr_handler,
+			 IRQF_SHARED, LPFC_DRIVER_NAME, phba);
+	if (rc) {
+		pci_disable_msi(phba->pcidev);
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"0478 MSI request_irq failed (%d)\n", rc);
+	}
+	return rc;
+}
+
+/**
+ * lpfc_disable_msi: Disable MSI interrupt mode.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to disable the MSI interrupt mode. The driver
+ * calls free_irq() on MSI vector it has done request_irq() on before
+ * calling pci_disable_msi(). Failure to do so results in a BUG_ON() and
+ * a device will be left with MSI enabled and leaks its vector.
+ */
+
+static void
+lpfc_disable_msi(struct lpfc_hba *phba)
+{
+	free_irq(phba->pcidev->irq, phba);
+	pci_disable_msi(phba->pcidev);
+	return;
+}
+
+/**
+ * lpfc_log_intr_mode: Log the active interrupt mode
+ * @phba: pointer to lpfc hba data structure.
+ * @intr_mode: active interrupt mode adopted.
+ *
+ * This routine it invoked to log the currently used active interrupt mode
+ * to the device.
+ */
+static void
+lpfc_log_intr_mode(struct lpfc_hba *phba, uint32_t intr_mode)
+{
+	switch (intr_mode) {
+	case 0:
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0470 Enable INTx interrupt mode.\n");
+		break;
+	case 1:
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0481 Enabled MSI interrupt mode.\n");
+		break;
+	case 2:
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0480 Enabled MSI-X interrupt mode.\n");
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0482 Illegal interrupt mode.\n");
+		break;
+	}
+	return;
+}
+
+static void
+lpfc_stop_port(struct lpfc_hba *phba)
+{
+	/* Clear all interrupt enable conditions */
+	writel(0, phba->HCregaddr);
+	readl(phba->HCregaddr); /* flush */
+	/* Clear all pending interrupts */
+	writel(0xffffffff, phba->HAregaddr);
+	readl(phba->HAregaddr); /* flush */
+
+	/* Reset some HBA SLI setup states */
+	lpfc_stop_phba_timers(phba);
+	phba->pport->work_port_events = 0;
+
+	return;
+}
+
+/**
+ * lpfc_enable_intr: Enable device interrupt.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to enable device interrupt and associate driver's
+ * interrupt handler(s) to interrupt vector(s). Depends on the interrupt
+ * mode configured to the driver, the driver will try to fallback from the
+ * configured interrupt mode to an interrupt mode which is supported by the
+ * platform, kernel, and device in the order of: MSI-X -> MSI -> IRQ.
+ *
+ * Return codes
+ *   0 - sucessful
+ *   other values - error
+ **/
+static uint32_t
+lpfc_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
+{
+	uint32_t intr_mode = LPFC_INTR_ERROR;
+	int retval;
+
+	if (cfg_mode == 2) {
+		/* Need to issue conf_port mbox cmd before conf_msi mbox cmd */
+		retval = lpfc_sli_config_port(phba, 3);
+		if (!retval) {
+			/* Now, try to enable MSI-X interrupt mode */
+			retval = lpfc_enable_msix(phba);
+			if (!retval) {
+				/* Indicate initialization to MSI-X mode */
+				phba->intr_type = MSIX;
+				intr_mode = 2;
+			}
+		}
+	}
+
+	/* Fallback to MSI if MSI-X initialization failed */
+	if (cfg_mode >= 1 && phba->intr_type == NONE) {
+		retval = lpfc_enable_msi(phba);
+		if (!retval) {
+			/* Indicate initialization to MSI mode */
+			phba->intr_type = MSI;
+			intr_mode = 1;
+		}
+	}
+
+	/* Fallback to INTx if both MSI-X/MSI initalization failed */
+	if (phba->intr_type == NONE) {
+		retval = request_irq(phba->pcidev->irq, lpfc_intr_handler,
+				     IRQF_SHARED, LPFC_DRIVER_NAME, phba);
+		if (!retval) {
+			/* Indicate initialization to INTx mode */
+			phba->intr_type = INTx;
+			intr_mode = 0;
+		}
+	}
+	return intr_mode;
+}
+
+/**
+ * lpfc_disable_intr: Disable device interrupt.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to disable device interrupt and disassociate the
+ * driver's interrupt handler(s) from interrupt vector(s). Depending on the
+ * interrupt mode, the driver will release the interrupt vector(s) for the
+ * message signaled interrupt.
+ **/
+static void
+lpfc_disable_intr(struct lpfc_hba *phba)
+{
+	/* Disable the currently initialized interrupt mode */
+	if (phba->intr_type == MSIX)
+		lpfc_disable_msix(phba);
+	else if (phba->intr_type == MSI)
+		lpfc_disable_msi(phba);
+	else if (phba->intr_type == INTx)
+		free_irq(phba->pcidev->irq, phba);
+
+	/* Reset interrupt management states */
+	phba->intr_type = NONE;
+	phba->sli.slistat.sli_intr = 0;
+
+	return;
+}
+
+/**
  * lpfc_pci_probe_one: lpfc PCI probe func to register device to PCI subsystem.
  * @pdev: pointer to PCI device
  * @pid: pointer to PCI device identifier
@@ -2404,6 +2592,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 	int error = -ENODEV, retval;
 	int  i, hbq_count;
 	uint16_t iotag;
+	uint32_t cfg_mode, intr_mode;
 	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
 	struct lpfc_adapter_event_header adapter_event;
 
@@ -2606,7 +2795,6 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 	lpfc_debugfs_initialize(vport);
 
 	pci_set_drvdata(pdev, shost);
-	phba->intr_type = NONE;
 
 	phba->MBslimaddr = phba->slim_memmap_p;
 	phba->HAregaddr = phba->ctrl_regs_memmap_p + HA_REG_OFFSET;
@@ -2614,63 +2802,58 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 	phba->HSregaddr = phba->ctrl_regs_memmap_p + HS_REG_OFFSET;
 	phba->HCregaddr = phba->ctrl_regs_memmap_p + HC_REG_OFFSET;
 
-	/* Configure and enable interrupt */
-	if (phba->cfg_use_msi == 2) {
-		/* Need to issue conf_port mbox cmd before conf_msi mbox cmd */
-		error = lpfc_sli_config_port(phba, 3);
-		if (error)
-			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0427 Firmware not capable of SLI 3 mode.\n");
-		else {
-			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0426 Firmware capable of SLI 3 mode.\n");
-			/* Now, try to enable MSI-X interrupt mode */
-			error = lpfc_enable_msix(phba);
-			if (!error) {
-				phba->intr_type = MSIX;
-				lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-						"0430 enable MSI-X mode.\n");
-			}
-		}
-	}
-
-	/* Fallback to MSI if MSI-X initialization failed */
-	if (phba->cfg_use_msi >= 1 && phba->intr_type == NONE) {
-		retval = pci_enable_msi(phba->pcidev);
-		if (!retval) {
-			phba->intr_type = MSI;
-			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"0473 enable MSI mode.\n");
-		} else
-			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"0452 enable IRQ mode.\n");
-	}
-
-	/* MSI-X is the only case the doesn't need to call request_irq */
-	if (phba->intr_type != MSIX) {
-		retval = request_irq(phba->pcidev->irq, lpfc_intr_handler,
-				     IRQF_SHARED, LPFC_DRIVER_NAME, phba);
-		if (retval) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT, "0451 Enable "
-					"interrupt handler failed\n");
-			error = retval;
-			goto out_disable_msi;
-		} else if (phba->intr_type != MSI)
-			phba->intr_type = INTx;
-	}
-
+	/* Configure sysfs attributes */
 	if (lpfc_alloc_sysfs_attr(vport)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1476 Failed to allocate sysfs attr\n");
 		error = -ENOMEM;
-		goto out_free_irq;
+		goto out_destroy_port;
 	}
 
-	if (lpfc_sli_hba_setup(phba)) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1477 Failed to set up hba\n");
-		error = -ENODEV;
-		goto out_remove_device;
+	cfg_mode = phba->cfg_use_msi;
+	while (true) {
+		/* Configure and enable interrupt */
+		intr_mode = lpfc_enable_intr(phba, cfg_mode);
+		if (intr_mode == LPFC_INTR_ERROR) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0426 Failed to enable interrupt.\n");
+			goto out_free_sysfs_attr;
+		}
+		/* HBA SLI setup */
+		if (lpfc_sli_hba_setup(phba)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"1477 Failed to set up hba\n");
+			error = -ENODEV;
+			goto out_remove_device;
+		}
+
+		/* Wait 50ms for the interrupts of previous mailbox commands */
+		msleep(50);
+		/* Check active interrupts received */
+		if (phba->sli.slistat.sli_intr > LPFC_MSIX_VECTORS) {
+			/* Log the current active interrupt mode */
+			phba->intr_mode = intr_mode;
+			lpfc_log_intr_mode(phba, intr_mode);
+			break;
+		} else {
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"0451 Configure interrupt mode (%d) "
+					"failed active interrupt test.\n",
+					intr_mode);
+			if (intr_mode == 0) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"0479 Failed to enable "
+						"interrupt.\n");
+				error = -ENODEV;
+				goto out_remove_device;
+			}
+			/* Stop HBA SLI setups */
+			lpfc_stop_port(phba);
+			/* Disable the current interrupt mode */
+			lpfc_disable_intr(phba);
+			/* Try next level of interrupt mode */
+			cfg_mode = --intr_mode;
+		}
 	}
 
 	/*
@@ -2700,22 +2883,15 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 	return 0;
 
 out_remove_device:
-	lpfc_free_sysfs_attr(vport);
 	spin_lock_irq(shost->host_lock);
 	vport->load_flag |= FC_UNLOADING;
 	spin_unlock_irq(shost->host_lock);
-out_free_irq:
 	lpfc_stop_phba_timers(phba);
 	phba->pport->work_port_events = 0;
-
-	if (phba->intr_type == MSIX)
-		lpfc_disable_msix(phba);
-	else
-		free_irq(phba->pcidev->irq, phba);
-
-out_disable_msi:
-	if (phba->intr_type == MSI)
-		pci_disable_msi(phba->pcidev);
+	lpfc_disable_intr(phba);
+out_free_sysfs_attr:
+	lpfc_free_sysfs_attr(vport);
+out_destroy_port:
 	destroy_port(vport);
 out_kthread_stop:
 	kthread_stop(phba->worker_thread);
@@ -2804,13 +2980,8 @@ lpfc_pci_remove_one(struct pci_dev *pdev)
 
 	lpfc_debugfs_terminate(vport);
 
-	if (phba->intr_type == MSIX)
-		lpfc_disable_msix(phba);
-	else {
-		free_irq(phba->pcidev->irq, phba);
-		if (phba->intr_type == MSI)
-			pci_disable_msi(phba->pcidev);
-	}
+	/* Disable interrupt */
+	lpfc_disable_intr(phba);
 
 	pci_set_drvdata(pdev, NULL);
 	scsi_host_put(shost);
@@ -2908,6 +3079,7 @@ lpfc_pci_resume_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+	uint32_t intr_mode;
 	int error;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -2930,19 +3102,22 @@ lpfc_pci_resume_one(struct pci_dev *pdev)
 		return error;
 	}
 
-	/* Enable interrupt from device */
-	error = lpfc_enable_intr(phba);
-	if (error) {
+	/* Configure and enable interrupt */
+	intr_mode = lpfc_enable_intr(phba, phba->intr_mode);
+	if (intr_mode == LPFC_INTR_ERROR) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0430 PM resume Failed to enable interrupt: "
-				"error=x%x.\n", error);
-		return error;
-	}
+				"0430 PM resume Failed to enable interrupt\n");
+		return -EIO;
+	} else
+		phba->intr_mode = intr_mode;
 
 	/* Restart HBA and bring it online */
 	lpfc_sli_brdrestart(phba);
 	lpfc_online(phba);
 
+	/* Log the current active interrupt mode */
+	lpfc_log_intr_mode(phba, phba->intr_mode);
+
 	return 0;
 }
 
@@ -2989,13 +3164,8 @@ static pci_ers_result_t lpfc_io_error_detected(struct pci_dev *pdev,
 	pring = &psli->ring[psli->fcp_ring];
 	lpfc_sli_abort_iocb_ring(phba, pring);
 
-	if (phba->intr_type == MSIX)
-		lpfc_disable_msix(phba);
-	else {
-		free_irq(phba->pcidev->irq, phba);
-		if (phba->intr_type == MSI)
-			pci_disable_msi(phba->pcidev);
-	}
+	/* Disable interrupt */
+	lpfc_disable_intr(phba);
 
 	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;
@@ -3023,7 +3193,7 @@ static pci_ers_result_t lpfc_io_slot_reset(struct pci_dev *pdev)
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 	struct lpfc_sli *psli = &phba->sli;
-	int error, retval;
+	uint32_t intr_mode;
 
 	dev_printk(KERN_INFO, &pdev->dev, "recovering from a slot reset.\n");
 	if (pci_enable_device_mem(pdev)) {
@@ -3040,55 +3210,23 @@ static pci_ers_result_t lpfc_io_slot_reset(struct pci_dev *pdev)
 	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
 	spin_unlock_irq(&phba->hbalock);
 
-	/* Enable configured interrupt method */
-	phba->intr_type = NONE;
-	if (phba->cfg_use_msi == 2) {
-		/* Need to issue conf_port mbox cmd before conf_msi mbox cmd */
-		error = lpfc_sli_config_port(phba, 3);
-		if (error)
-			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0478 Firmware not capable of SLI 3 mode.\n");
-		else {
-			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0479 Firmware capable of SLI 3 mode.\n");
-			/* Now, try to enable MSI-X interrupt mode */
-			error = lpfc_enable_msix(phba);
-			if (!error) {
-				phba->intr_type = MSIX;
-				lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-						"0480 enable MSI-X mode.\n");
-			}
-		}
-	}
-
-	/* Fallback to MSI if MSI-X initialization failed */
-	if (phba->cfg_use_msi >= 1 && phba->intr_type == NONE) {
-		retval = pci_enable_msi(phba->pcidev);
-		if (!retval) {
-			phba->intr_type = MSI;
-			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"0481 enable MSI mode.\n");
-		} else
-			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"0470 enable IRQ mode.\n");
-	}
-
-	/* MSI-X is the only case the doesn't need to call request_irq */
-	if (phba->intr_type != MSIX) {
-		retval = request_irq(phba->pcidev->irq, lpfc_intr_handler,
-				     IRQF_SHARED, LPFC_DRIVER_NAME, phba);
-		if (retval) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0471 Enable interrupt handler "
-					"failed\n");
-		} else if (phba->intr_type != MSI)
-			phba->intr_type = INTx;
-	}
+	/* Configure and enable interrupt */
+	intr_mode = lpfc_enable_intr(phba, phba->intr_mode);
+	if (intr_mode == LPFC_INTR_ERROR) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0427 Cannot re-enable interrupt after "
+				"slot reset.\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	} else
+		phba->intr_mode = intr_mode;
 
 	/* Take device offline; this will perform cleanup */
 	lpfc_offline(phba);
 	lpfc_sli_brdrestart(phba);
 
+	/* Log the current active interrupt mode */
+	lpfc_log_intr_mode(phba, phba->intr_mode);
+
 	return PCI_ERS_RESULT_RECOVERED;
 }
 
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1315,10 +1315,12 @@ lpfc_mbox_get(struct lpfc_hba * phba)
 void
 lpfc_mbox_cmpl_put(struct lpfc_hba * phba, LPFC_MBOXQ_t * mbq)
 {
+	unsigned long iflag;
+
 	/* This function expects to be called from interrupt context */
-	spin_lock(&phba->hbalock);
+	spin_lock_irqsave(&phba->hbalock, iflag);
 	list_add_tail(&mbq->list, &phba->sli.mboxq_cmpl);
-	spin_unlock(&phba->hbalock);
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
 	return;
 }
 
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5238,6 +5238,7 @@ lpfc_sp_intr_handler(int irq, void *dev_id)
 	uint32_t ha_copy;
 	uint32_t work_ha_copy;
 	unsigned long status;
+	unsigned long iflag;
 	uint32_t control;
 
 	MAILBOX_t *mbox, *pmbox;
@@ -5270,7 +5271,7 @@ lpfc_sp_intr_handler(int irq, void *dev_id)
 		if (unlikely(phba->link_state < LPFC_LINK_DOWN))
 			return IRQ_NONE;
 		/* Need to read HA REG for slow-path events */
-		spin_lock(&phba->hbalock);
+		spin_lock_irqsave(&phba->hbalock, iflag);
 		ha_copy = readl(phba->HAregaddr);
 		/* If somebody is waiting to handle an eratt don't process it
 		 * here. The brdkill function will do this.
@@ -5290,7 +5291,7 @@ lpfc_sp_intr_handler(int irq, void *dev_id)
 		writel((ha_copy & (HA_MBATT | HA_R2_CLR_MSK)),
 			phba->HAregaddr);
 		readl(phba->HAregaddr); /* flush */
-		spin_unlock(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
 	} else
 		ha_copy = phba->ha_copy;
 
@@ -5303,13 +5304,13 @@ lpfc_sp_intr_handler(int irq, void *dev_id)
 				 * Turn off Link Attention interrupts
 				 * until CLEAR_LA done
 				 */
-				spin_lock(&phba->hbalock);
+				spin_lock_irqsave(&phba->hbalock, iflag);
 				phba->sli.sli_flag &= ~LPFC_PROCESS_LA;
 				control = readl(phba->HCregaddr);
 				control &= ~HC_LAINT_ENA;
 				writel(control, phba->HCregaddr);
 				readl(phba->HCregaddr); /* flush */
-				spin_unlock(&phba->hbalock);
+				spin_unlock_irqrestore(&phba->hbalock, iflag);
 			}
 			else
 				work_ha_copy &= ~HA_LATT;
@@ -5324,7 +5325,7 @@ lpfc_sp_intr_handler(int irq, void *dev_id)
 				(HA_RXMASK  << (4*LPFC_ELS_RING)));
 			status >>= (4*LPFC_ELS_RING);
 			if (status & HA_RXMASK) {
-				spin_lock(&phba->hbalock);
+				spin_lock_irqsave(&phba->hbalock, iflag);
 				control = readl(phba->HCregaddr);
 
 				lpfc_debugfs_slow_ring_trc(phba,
@@ -5353,10 +5354,10 @@ lpfc_sp_intr_handler(int irq, void *dev_id)
 						(uint32_t)((unsigned long)
 						&phba->work_waitq));
 				}
-				spin_unlock(&phba->hbalock);
+				spin_unlock_irqrestore(&phba->hbalock, iflag);
 			}
 		}
-		spin_lock(&phba->hbalock);
+		spin_lock_irqsave(&phba->hbalock, iflag);
 		if (work_ha_copy & HA_ERATT)
 			lpfc_sli_read_hs(phba);
 		if ((work_ha_copy & HA_MBATT) && (phba->sli.mbox_active)) {
@@ -5368,7 +5369,7 @@ lpfc_sp_intr_handler(int irq, void *dev_id)
 			/* First check out the status word */
 			lpfc_sli_pcimem_bcopy(mbox, pmbox, sizeof(uint32_t));
 			if (pmbox->mbxOwner != OWN_HOST) {
-				spin_unlock(&phba->hbalock);
+				spin_unlock_irqrestore(&phba->hbalock, iflag);
 				/*
 				 * Stray Mailbox Interrupt, mbxCommand <cmd>
 				 * mbxStatus <status>
@@ -5385,7 +5386,7 @@ lpfc_sp_intr_handler(int irq, void *dev_id)
 				work_ha_copy &= ~HA_MBATT;
 			} else {
 				phba->sli.mbox_active = NULL;
-				spin_unlock(&phba->hbalock);
+				spin_unlock_irqrestore(&phba->hbalock, iflag);
 				phba->last_completion_time = jiffies;
 				del_timer(&phba->sli.mbox_tmo);
 				if (pmb->mbox_cmpl) {
@@ -5434,14 +5435,18 @@ lpfc_sp_intr_handler(int irq, void *dev_id)
 						goto send_current_mbox;
 					}
 				}
-				spin_lock(&phba->pport->work_port_lock);
+				spin_lock_irqsave(
+						&phba->pport->work_port_lock,
+						iflag);
 				phba->pport->work_port_events &=
 					~WORKER_MBOX_TMO;
-				spin_unlock(&phba->pport->work_port_lock);
+				spin_unlock_irqrestore(
+						&phba->pport->work_port_lock,
+						iflag);
 				lpfc_mbox_cmpl_put(phba, pmb);
 			}
 		} else
-			spin_unlock(&phba->hbalock);
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
 
 		if ((work_ha_copy & HA_MBATT) &&
 		    (phba->sli.mbox_active == NULL)) {
@@ -5457,9 +5462,9 @@ send_current_mbox:
 						"MBX_SUCCESS");
 		}
 
-		spin_lock(&phba->hbalock);
+		spin_lock_irqsave(&phba->hbalock, iflag);
 		phba->work_ha |= work_ha_copy;
-		spin_unlock(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		lpfc_worker_wake_up(phba);
 	}
 	return IRQ_HANDLED;
@@ -5491,6 +5496,7 @@ lpfc_fp_intr_handler(int irq, void *dev_id)
 	struct lpfc_hba  *phba;
 	uint32_t ha_copy;
 	unsigned long status;
+	unsigned long iflag;
 
 	/* Get the driver's phba structure from the dev_id and
 	 * assume the HBA is not interrupting.
@@ -5516,11 +5522,11 @@ lpfc_fp_intr_handler(int irq, void *dev_id)
 		/* Need to read HA REG for FCP ring and other ring events */
 		ha_copy = readl(phba->HAregaddr);
 		/* Clear up only attention source related to fast-path */
-		spin_lock(&phba->hbalock);
+		spin_lock_irqsave(&phba->hbalock, iflag);
 		writel((ha_copy & (HA_R0_CLR_MSK | HA_R1_CLR_MSK)),
 			phba->HAregaddr);
 		readl(phba->HAregaddr); /* flush */
-		spin_unlock(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
 	} else
 		ha_copy = phba->ha_copy;
 


