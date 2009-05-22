From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 9/17] lpfc 8.3.2 : Addition of SLI4 Interface - Base
	Support - Part 6 of 6
Date: Fri, 22 May 2009 14:52:27 -0400
Message-ID: <1243018347.7729.55.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42083 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbZEVSw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 14:52:29 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n4MIqVk7029809
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2009 11:52:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Addition of SLI4 Interface - Base Support - Part 6 of 6

Adds new hardware and interface definitions.

Adds new interface routines - utilizing the reorganized layout of the
driver. Adds SLI-4 specific functions for attachment, initialization,
teardown, etc.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |  355 ++++++++++++++++++++++++------------------------------------
 1 file changed, 146 insertions(+), 209 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2009-05-22 13:17:16.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2009-05-22 13:17:37.000000000 -0400
@@ -7213,20 +7213,20 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 	error = lpfc_enable_pci_dev(phba);
 	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1401 Failed to enable pci device.\n");
+				"1409 Failed to enable pci device.\n");
 		goto out_free_phba;
 	}
 
-	/* Set up SLI API function jump table for PCI-device group-0 HBAs */
-	error = lpfc_api_table_setup(phba, LPFC_PCI_DEV_LP);
+	/* Set up SLI API function jump table for PCI-device group-1 HBAs */
+	error = lpfc_api_table_setup(phba, LPFC_PCI_DEV_OC);
 	if (error)
 		goto out_disable_pci_dev;
 
-	/* Set up SLI-3 specific device PCI memory space */
-	error = lpfc_sli_pci_mem_setup(phba);
+	/* Set up SLI-4 specific device PCI memory space */
+	error = lpfc_sli4_pci_mem_setup(phba);
 	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1402 Failed to set up pci memory space.\n");
+				"1410 Failed to set up pci memory space.\n");
 		goto out_disable_pci_dev;
 	}
 
@@ -7234,31 +7234,32 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 	error = lpfc_setup_driver_resource_phase1(phba);
 	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1403 Failed to set up driver resource.\n");
-		goto out_unset_pci_mem_s3;
+				"1411 Failed to set up driver resource.\n");
+		goto out_unset_pci_mem_s4;
 	}
 
-	/* Set up SLI-3 specific device driver resources */
-	error = lpfc_sli_driver_resource_setup(phba);
+	/* Set up SLI-4 Specific device driver resources */
+	error = lpfc_sli4_driver_resource_setup(phba);
 	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1404 Failed to set up driver resource.\n");
-		goto out_unset_pci_mem_s3;
+				"1412 Failed to set up driver resource.\n");
+		goto out_unset_pci_mem_s4;
 	}
 
 	/* Initialize and populate the iocb list per host */
-	error = lpfc_init_iocb_list(phba, LPFC_IOCB_LIST_CNT);
+	error = lpfc_init_iocb_list(phba,
+			phba->sli4_hba.max_cfg_param.max_xri);
 	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1405 Failed to initialize iocb list.\n");
-		goto out_unset_driver_resource_s3;
+				"1413 Failed to initialize iocb list.\n");
+		goto out_unset_driver_resource_s4;
 	}
 
 	/* Set up common device driver resources */
 	error = lpfc_setup_driver_resource_phase2(phba);
 	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1406 Failed to set up driver resource.\n");
+				"1414 Failed to set up driver resource.\n");
 		goto out_free_iocb_list;
 	}
 
@@ -7266,7 +7267,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 	error = lpfc_create_shost(phba);
 	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1407 Failed to create scsi host.\n");
+				"1415 Failed to create scsi host.\n");
 		goto out_unset_driver_resource;
 	}
 
@@ -7275,7 +7276,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 	error = lpfc_alloc_sysfs_attr(vport);
 	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1476 Failed to allocate sysfs attr\n");
+				"1416 Failed to allocate sysfs attr\n");
 		goto out_destroy_shost;
 	}
 
@@ -7285,52 +7286,51 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 		/* Put device to a known state before enabling interrupt */
 		lpfc_stop_port(phba);
 		/* Configure and enable interrupt */
-		intr_mode = lpfc_sli_enable_intr(phba, cfg_mode);
+		intr_mode = lpfc_sli4_enable_intr(phba, cfg_mode);
 		if (intr_mode == LPFC_INTR_ERROR) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0431 Failed to enable interrupt.\n");
+					"0426 Failed to enable interrupt.\n");
 			error = -ENODEV;
 			goto out_free_sysfs_attr;
 		}
-		/* SLI-3 HBA setup */
-		if (lpfc_sli_hba_setup(phba)) {
+		/* Set up SLI-4 HBA */
+		if (lpfc_sli4_hba_setup(phba)) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"1477 Failed to set up hba\n");
+					"1421 Failed to set up hba\n");
 			error = -ENODEV;
-			goto out_remove_device;
+			goto out_disable_intr;
 		}
 
-		/* Wait 50ms for the interrupts of previous mailbox commands */
-		msleep(50);
-		/* Check active interrupts on message signaled interrupts */
+		/* Send NOP mbx cmds for non-INTx mode active interrupt test */
+		if (intr_mode != 0)
+			mcnt = lpfc_sli4_send_nop_mbox_cmds(phba,
+							    LPFC_ACT_INTR_CNT);
+
+		/* Check active interrupts received only for MSI/MSI-X */
 		if (intr_mode == 0 ||
-		    phba->sli.slistat.sli_intr > LPFC_MSIX_VECTORS) {
+		    phba->sli.slistat.sli_intr >= LPFC_ACT_INTR_CNT) {
 			/* Log the current active interrupt mode */
 			phba->intr_mode = intr_mode;
 			lpfc_log_intr_mode(phba, intr_mode);
 			break;
-		} else {
-			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"0447 Configure interrupt mode (%d) "
-					"failed active interrupt test.\n",
-					intr_mode);
-			/* Disable the current interrupt mode */
-			lpfc_sli_disable_intr(phba);
-			/* Try next level of interrupt mode */
-			cfg_mode = --intr_mode;
 		}
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0451 Configure interrupt mode (%d) "
+				"failed active interrupt test.\n",
+				intr_mode);
+		/* Unset the preivous SLI-4 HBA setup */
+		lpfc_sli4_unset_hba(phba);
+		/* Try next level of interrupt mode */
+		cfg_mode = --intr_mode;
 	}
 
 	/* Perform post initialization setup */
 	lpfc_post_init_setup(phba);
 
-	/* Check if there are static vports to be created. */
-	lpfc_create_static_vport(phba);
-
 	return 0;
 
-out_remove_device:
-	lpfc_unset_hba(phba);
+out_disable_intr:
+	lpfc_sli4_disable_intr(phba);
 out_free_sysfs_attr:
 	lpfc_free_sysfs_attr(vport);
 out_destroy_shost:
@@ -7339,10 +7339,10 @@ out_unset_driver_resource:
 	lpfc_unset_driver_resource_phase2(phba);
 out_free_iocb_list:
 	lpfc_free_iocb_list(phba);
-out_unset_driver_resource_s3:
-	lpfc_sli_driver_resource_unset(phba);
-out_unset_pci_mem_s3:
-	lpfc_sli_pci_mem_unset(phba);
+out_unset_driver_resource_s4:
+	lpfc_sli4_driver_resource_unset(phba);
+out_unset_pci_mem_s4:
+	lpfc_sli4_pci_mem_unset(phba);
 out_disable_pci_dev:
 	lpfc_disable_pci_dev(phba);
 out_free_phba:
@@ -7351,28 +7351,29 @@ out_free_phba:
 }
 
 /**
- * lpfc_pci_remove_one_s3 - PCI func to unreg SLI-3 device from PCI subsystem.
+ * lpfc_pci_remove_one_s4 - PCI func to unreg SLI-4 device from PCI subsystem
  * @pdev: pointer to PCI device
  *
- * This routine is to be called to disattach a device with SLI-3 interface
- * spec from PCI subsystem. When an Emulex HBA with SLI-3 interface spec is
+ * This routine is called from the kernel's PCI subsystem to device with
+ * SLI-4 interface spec. When an Emulex HBA with SLI-4 interface spec is
  * removed from PCI bus, it performs all the necessary cleanup for the HBA
  * device to be removed from the PCI subsystem properly.
  **/
 static void __devexit
-lpfc_pci_remove_one_s3(struct pci_dev *pdev)
+lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 {
-	struct Scsi_Host  *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_vport **vports;
-	struct lpfc_hba   *phba = vport->phba;
+	struct lpfc_hba *phba = vport->phba;
 	int i;
-	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
 
+	/* Mark the device unloading flag */
 	spin_lock_irq(&phba->hbalock);
 	vport->load_flag |= FC_UNLOADING;
 	spin_unlock_irq(&phba->hbalock);
 
+	/* Free the HBA sysfs attributes */
 	lpfc_free_sysfs_attr(vport);
 
 	/* Release all the vports against this physical port */
@@ -7385,73 +7386,56 @@ lpfc_pci_remove_one_s3(struct pci_dev *p
 	/* Remove FC host and then SCSI host with the physical port */
 	fc_remove_host(shost);
 	scsi_remove_host(shost);
+
+	/* Perform cleanup on the physical port */
 	lpfc_cleanup(vport);
 
 	/*
-	 * Bring down the SLI Layer. This step disable all interrupts,
+	 * Bring down the SLI Layer. This step disables all interrupts,
 	 * clears the rings, discards all mailbox commands, and resets
-	 * the HBA.
+	 * the HBA FCoE function.
 	 */
+	lpfc_debugfs_terminate(vport);
+	lpfc_sli4_hba_unset(phba);
 
-	/* HBA interrupt will be diabled after this call */
-	lpfc_sli_hba_down(phba);
-	/* Stop kthread signal shall trigger work_done one more time */
-	kthread_stop(phba->worker_thread);
-	/* Final cleanup of txcmplq and reset the HBA */
-	lpfc_sli_brdrestart(phba);
-
-	lpfc_stop_hba_timers(phba);
 	spin_lock_irq(&phba->hbalock);
 	list_del_init(&vport->listentry);
 	spin_unlock_irq(&phba->hbalock);
 
-	lpfc_debugfs_terminate(vport);
-
-	/* Disable interrupt */
-	lpfc_sli_disable_intr(phba);
-
-	pci_set_drvdata(pdev, NULL);
-	scsi_host_put(shost);
-
-	/*
-	 * Call scsi_free before mem_free since scsi bufs are released to their
-	 * corresponding pools here.
+	/* Call scsi_free before lpfc_sli4_driver_resource_unset since scsi
+	 * buffers are released to their corresponding pools here.
 	 */
 	lpfc_scsi_free(phba);
-	lpfc_mem_free_all(phba);
+	lpfc_sli4_driver_resource_unset(phba);
 
-	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(),
-			  phba->hbqslimp.virt, phba->hbqslimp.phys);
+	/* Unmap adapter Control and Doorbell registers */
+	lpfc_sli4_pci_mem_unset(phba);
 
-	/* Free resources associated with SLI2 interface */
-	dma_free_coherent(&pdev->dev, SLI2_SLIM_SIZE,
-			  phba->slim2p.virt, phba->slim2p.phys);
-
-	/* unmap adapter SLIM and Control Registers */
-	iounmap(phba->ctrl_regs_memmap_p);
-	iounmap(phba->slim_memmap_p);
+	/* Release PCI resources and disable device's PCI function */
+	scsi_host_put(shost);
+	lpfc_disable_pci_dev(phba);
 
+	/* Finally, free the driver's device data structure */
 	lpfc_hba_free(phba);
 
-	pci_release_selected_regions(pdev, bars);
-	pci_disable_device(pdev);
+	return;
 }
 
 /**
- * lpfc_pci_suspend_one_s3 - PCI func to suspend SLI-3 device for power mgmnt
+ * lpfc_pci_suspend_one_s4 - PCI func to suspend SLI-4 device for power mgmnt
  * @pdev: pointer to PCI device
  * @msg: power management message
  *
- * This routine is to be called from the kernel's PCI subsystem to support
- * system Power Management (PM) to device with SLI-3 interface spec. When
- * PM invokes this method, it quiesces the device by stopping the driver's
- * worker thread for the device, turning off device's interrupt and DMA,
- * and bring the device offline. Note that as the driver implements the
- * minimum PM requirements to a power-aware driver's PM support for the
- * suspend/resume -- all the possible PM messages (SUSPEND, HIBERNATE, FREEZE)
- * to the suspend() method call will be treated as SUSPEND and the driver will
- * fully reinitialize its device during resume() method call, the driver will
- * set device to PCI_D3hot state in PCI config space instead of setting it
+ * This routine is called from the kernel's PCI subsystem to support system
+ * Power Management (PM) to device with SLI-4 interface spec. When PM invokes
+ * this method, it quiesces the device by stopping the driver's worker
+ * thread for the device, turning off device's interrupt and DMA, and bring
+ * the device offline. Note that as the driver implements the minimum PM
+ * requirements to a power-aware driver's PM support for suspend/resume -- all
+ * the possible PM messages (SUSPEND, HIBERNATE, FREEZE) to the suspend()
+ * method call will be treated as SUSPEND and the driver will fully
+ * reinitialize its device during resume() method call, the driver will set
+ * device to PCI_D3hot state in PCI config space instead of setting it
  * according to the @msg provided by the PM.
  *
  * Return code
@@ -7459,13 +7443,13 @@ lpfc_pci_remove_one_s3(struct pci_dev *p
  * 	Error otherwise
  **/
 static int
-lpfc_pci_suspend_one_s3(struct pci_dev *pdev, pm_message_t msg)
+lpfc_pci_suspend_one_s4(struct pci_dev *pdev, pm_message_t msg)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"0473 PCI device Power Management suspend.\n");
+			"0298 PCI device Power Management suspend.\n");
 
 	/* Bring down the device */
 	lpfc_offline_prep(phba);
@@ -7473,7 +7457,7 @@ lpfc_pci_suspend_one_s3(struct pci_dev *
 	kthread_stop(phba->worker_thread);
 
 	/* Disable interrupt from device */
-	lpfc_sli_disable_intr(phba);
+	lpfc_sli4_disable_intr(phba);
 
 	/* Save device state to PCI config space */
 	pci_save_state(pdev);
@@ -7483,26 +7467,26 @@ lpfc_pci_suspend_one_s3(struct pci_dev *
 }
 
 /**
- * lpfc_pci_resume_one_s3 - PCI func to resume SLI-3 device for power mgmnt
+ * lpfc_pci_resume_one_s4 - PCI func to resume SLI-4 device for power mgmnt
  * @pdev: pointer to PCI device
  *
- * This routine is to be called from the kernel's PCI subsystem to support
- * system Power Management (PM) to device with SLI-3 interface spec. When PM
- * invokes this method, it restores the device's PCI config space state and
- * fully reinitializes the device and brings it online. Note that as the
- * driver implements the minimum PM requirements to a power-aware driver's
- * PM for suspend/resume -- all the possible PM messages (SUSPEND, HIBERNATE,
- * FREEZE) to the suspend() method call will be treated as SUSPEND and the
- * driver will fully reinitialize its device during resume() method call,
- * the device will be set to PCI_D0 directly in PCI config space before
- * restoring the state.
+ * This routine is called from the kernel's PCI subsystem to support system
+ * Power Management (PM) to device with SLI-4 interface spac. When PM invokes
+ * this method, it restores the device's PCI config space state and fully
+ * reinitializes the device and brings it online. Note that as the driver
+ * implements the minimum PM requirements to a power-aware driver's PM for
+ * suspend/resume -- all the possible PM messages (SUSPEND, HIBERNATE, FREEZE)
+ * to the suspend() method call will be treated as SUSPEND and the driver
+ * will fully reinitialize its device during resume() method call, the device
+ * will be set to PCI_D0 directly in PCI config space before restoring the
+ * state.
  *
  * Return code
  * 	0 - driver suspended the device
  * 	Error otherwise
  **/
 static int
-lpfc_pci_resume_one_s3(struct pci_dev *pdev)
+lpfc_pci_resume_one_s4(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
@@ -7510,7 +7494,7 @@ lpfc_pci_resume_one_s3(struct pci_dev *p
 	int error;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"0452 PCI device Power Management resume.\n");
+			"0292 PCI device Power Management resume.\n");
 
 	/* Restore device state from PCI config space */
 	pci_set_power_state(pdev, PCI_D0);
@@ -7518,22 +7502,22 @@ lpfc_pci_resume_one_s3(struct pci_dev *p
 	if (pdev->is_busmaster)
 		pci_set_master(pdev);
 
-	/* Startup the kernel thread for this host adapter. */
+	 /* Startup the kernel thread for this host adapter. */
 	phba->worker_thread = kthread_run(lpfc_do_work, phba,
 					"lpfc_worker_%d", phba->brd_no);
 	if (IS_ERR(phba->worker_thread)) {
 		error = PTR_ERR(phba->worker_thread);
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0434 PM resume failed to start worker "
+				"0293 PM resume failed to start worker "
 				"thread: error=x%x.\n", error);
 		return error;
 	}
 
 	/* Configure and enable interrupt */
-	intr_mode = lpfc_sli_enable_intr(phba, phba->intr_mode);
+	intr_mode = lpfc_sli4_enable_intr(phba, phba->intr_mode);
 	if (intr_mode == LPFC_INTR_ERROR) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0430 PM resume Failed to enable interrupt\n");
+				"0294 PM resume Failed to enable interrupt\n");
 		return -EIO;
 	} else
 		phba->intr_mode = intr_mode;
@@ -7549,134 +7533,65 @@ lpfc_pci_resume_one_s3(struct pci_dev *p
 }
 
 /**
- * lpfc_io_error_detected_s3 - Method for handling SLI-3 device PCI I/O error
+ * lpfc_io_error_detected_s4 - Method for handling PCI I/O error to SLI-4 device
  * @pdev: pointer to PCI device.
  * @state: the current PCI connection state.
  *
- * This routine is called from the PCI subsystem for I/O error handling to
- * device with SLI-3 interface spec. This function is called by the PCI
- * subsystem after a PCI bus error affecting this device has been detected.
- * When this function is invoked, it will need to stop all the I/Os and
- * interrupt(s) to the device. Once that is done, it will return
- * PCI_ERS_RESULT_NEED_RESET for the PCI subsystem to perform proper recovery
- * as desired.
+ * This routine is called from the PCI subsystem for error handling to device
+ * with SLI-4 interface spec. This function is called by the PCI subsystem
+ * after a PCI bus error affecting this device has been detected. When this
+ * function is invoked, it will need to stop all the I/Os and interrupt(s)
+ * to the device. Once that is done, it will return PCI_ERS_RESULT_NEED_RESET
+ * for the PCI subsystem to perform proper recovery as desired.
  *
  * Return codes
  * 	PCI_ERS_RESULT_NEED_RESET - need to reset before recovery
  * 	PCI_ERS_RESULT_DISCONNECT - device could not be recovered
  **/
 static pci_ers_result_t
-lpfc_io_error_detected_s3(struct pci_dev *pdev, pci_channel_state_t state)
+lpfc_io_error_detected_s4(struct pci_dev *pdev, pci_channel_state_t state)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
-	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring  *pring;
-
-	if (state == pci_channel_io_perm_failure) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0472 PCI channel I/O permanent failure\n");
-		/* Block all SCSI devices' I/Os on the host */
-		lpfc_scsi_dev_block(phba);
-		/* Clean up all driver's outstanding SCSI I/Os */
-		lpfc_sli_flush_fcp_rings(phba);
-		return PCI_ERS_RESULT_DISCONNECT;
-	}
-
-	pci_disable_device(pdev);
-	/*
-	 * There may be I/Os dropped by the firmware.
-	 * Error iocb (I/O) on txcmplq and let the SCSI layer
-	 * retry it after re-establishing link.
-	 */
-	pring = &psli->ring[psli->fcp_ring];
-	lpfc_sli_abort_iocb_ring(phba, pring);
-
-	/* Disable interrupt */
-	lpfc_sli_disable_intr(phba);
-
-	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
 /**
- * lpfc_io_slot_reset_s3 - Method for restarting PCI SLI-3 device from scratch.
+ * lpfc_io_slot_reset_s4 - Method for restart PCI SLI-4 device from scratch
  * @pdev: pointer to PCI device.
  *
- * This routine is called from the PCI subsystem for error handling to
- * device with SLI-3 interface spec. This is called after PCI bus has been
- * reset to restart the PCI card from scratch, as if from a cold-boot.
- * During the PCI subsystem error recovery, after driver returns
+ * This routine is called from the PCI subsystem for error handling to device
+ * with SLI-4 interface spec. It is called after PCI bus has been reset to
+ * restart the PCI card from scratch, as if from a cold-boot. During the
+ * PCI subsystem error recovery, after the driver returns
  * PCI_ERS_RESULT_NEED_RESET, the PCI subsystem will perform proper error
- * recovery and then call this routine before calling the .resume method
- * to recover the device. This function will initialize the HBA device,
- * enable the interrupt, but it will just put the HBA to offline state
- * without passing any I/O traffic.
+ * recovery and then call this routine before calling the .resume method to
+ * recover the device. This function will initialize the HBA device, enable
+ * the interrupt, but it will just put the HBA to offline state without
+ * passing any I/O traffic.
  *
  * Return codes
  * 	PCI_ERS_RESULT_RECOVERED - the device has been recovered
  * 	PCI_ERS_RESULT_DISCONNECT - device could not be recovered
  */
 static pci_ers_result_t
-lpfc_io_slot_reset_s3(struct pci_dev *pdev)
+lpfc_io_slot_reset_s4(struct pci_dev *pdev)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
-	struct lpfc_sli *psli = &phba->sli;
-	uint32_t intr_mode;
-
-	dev_printk(KERN_INFO, &pdev->dev, "recovering from a slot reset.\n");
-	if (pci_enable_device_mem(pdev)) {
-		printk(KERN_ERR "lpfc: Cannot re-enable "
-			"PCI device after reset.\n");
-		return PCI_ERS_RESULT_DISCONNECT;
-	}
-
-	pci_restore_state(pdev);
-	if (pdev->is_busmaster)
-		pci_set_master(pdev);
-
-	spin_lock_irq(&phba->hbalock);
-	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
-	spin_unlock_irq(&phba->hbalock);
-
-	/* Configure and enable interrupt */
-	intr_mode = lpfc_sli_enable_intr(phba, phba->intr_mode);
-	if (intr_mode == LPFC_INTR_ERROR) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0427 Cannot re-enable interrupt after "
-				"slot reset.\n");
-		return PCI_ERS_RESULT_DISCONNECT;
-	} else
-		phba->intr_mode = intr_mode;
-
-	/* Take device offline; this will perform cleanup */
-	lpfc_offline(phba);
-	lpfc_sli_brdrestart(phba);
-
-	/* Log the current active interrupt mode */
-	lpfc_log_intr_mode(phba, phba->intr_mode);
-
 	return PCI_ERS_RESULT_RECOVERED;
 }
 
 /**
- * lpfc_io_resume_s3 - Method for resuming PCI I/O operation on SLI-3 device.
+ * lpfc_io_resume_s4 - Method for resuming PCI I/O operation to SLI-4 device
  * @pdev: pointer to PCI device
  *
  * This routine is called from the PCI subsystem for error handling to device
- * with SLI-3 interface spec. It is called when kernel error recovery tells
+ * with SLI-4 interface spec. It is called when kernel error recovery tells
  * the lpfc driver that it is ok to resume normal PCI operation after PCI bus
  * error recovery. After this call, traffic can start to flow from this device
  * again.
- */
+ **/
 static void
-lpfc_io_resume_s3(struct pci_dev *pdev)
+lpfc_io_resume_s4(struct pci_dev *pdev)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
-
-	lpfc_online(phba);
+	return;
 }
 
 /**
@@ -7707,6 +7622,10 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 		return -ENODEV;
 
 	switch (dev_id) {
+	case PCI_DEVICE_ID_TIGERSHARK:
+	case PCI_DEVICE_ID_TIGERSHARK_S:
+		rc = lpfc_pci_probe_one_s4(pdev, pid);
+		break;
 	default:
 		rc = lpfc_pci_probe_one_s3(pdev, pid);
 		break;
@@ -7734,6 +7653,9 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	case LPFC_PCI_DEV_LP:
 		lpfc_pci_remove_one_s3(pdev);
 		break;
+	case LPFC_PCI_DEV_OC:
+		lpfc_pci_remove_one_s4(pdev);
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1424 Invalid PCI device group: 0x%x\n",
@@ -7768,6 +7690,9 @@ lpfc_pci_suspend_one(struct pci_dev *pde
 	case LPFC_PCI_DEV_LP:
 		rc = lpfc_pci_suspend_one_s3(pdev, msg);
 		break;
+	case LPFC_PCI_DEV_OC:
+		rc = lpfc_pci_suspend_one_s4(pdev, msg);
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1425 Invalid PCI device group: 0x%x\n",
@@ -7801,6 +7726,9 @@ lpfc_pci_resume_one(struct pci_dev *pdev
 	case LPFC_PCI_DEV_LP:
 		rc = lpfc_pci_resume_one_s3(pdev);
 		break;
+	case LPFC_PCI_DEV_OC:
+		rc = lpfc_pci_resume_one_s4(pdev);
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1426 Invalid PCI device group: 0x%x\n",
@@ -7836,6 +7764,9 @@ lpfc_io_error_detected(struct pci_dev *p
 	case LPFC_PCI_DEV_LP:
 		rc = lpfc_io_error_detected_s3(pdev, state);
 		break;
+	case LPFC_PCI_DEV_OC:
+		rc = lpfc_io_error_detected_s4(pdev, state);
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1427 Invalid PCI device group: 0x%x\n",
@@ -7870,6 +7801,9 @@ lpfc_io_slot_reset(struct pci_dev *pdev)
 	case LPFC_PCI_DEV_LP:
 		rc = lpfc_io_slot_reset_s3(pdev);
 		break;
+	case LPFC_PCI_DEV_OC:
+		rc = lpfc_io_slot_reset_s4(pdev);
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1428 Invalid PCI device group: 0x%x\n",
@@ -7899,6 +7833,9 @@ lpfc_io_resume(struct pci_dev *pdev)
 	case LPFC_PCI_DEV_LP:
 		lpfc_io_resume_s3(pdev);
 		break;
+	case LPFC_PCI_DEV_OC:
+		lpfc_io_resume_s4(pdev);
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1429 Invalid PCI device group: 0x%x\n",


