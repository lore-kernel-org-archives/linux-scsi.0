From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/14] lpfc 8.3.0 :  Add support for Power Management
	Suspend/Resume operations
Date: Thu, 4 Dec 2008 22:38:54 -0500
Message-ID: <1228448334.19053.37.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45889 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbYLEOnT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 09:43:19 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mB5EhI59004198
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 06:43:18 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lpfc 8.3.0 : Add support for Power Management Suspend/Resume operations

Implement lpfc_pci_suspend_one() and lpfc_pci_resume_one() and
register them in the pci_driver table.


Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_hbadisc.c |   13 +++--
 drivers/scsi/lpfc/lpfc_init.c    |  109 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+), 5 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -585,20 +585,25 @@ lpfc_do_work(void *p)
 	set_user_nice(current, -20);
 	phba->data_flags = 0;
 
-	while (1) {
+	while (!kthread_should_stop()) {
 		/* wait and check worker queue activities */
 		rc = wait_event_interruptible(phba->work_waitq,
 					(test_and_clear_bit(LPFC_DATA_READY,
 							    &phba->data_flags)
 					 || kthread_should_stop()));
-		BUG_ON(rc);
-
-		if (kthread_should_stop())
+		/* Signal wakeup shall terminate the worker thread */
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
+					"0433 Wakeup on signal: rc=x%x\n", rc);
 			break;
+		}
 
 		/* Attend pending lpfc data processing */
 		lpfc_work_done(phba);
 	}
+	phba->worker_thread = NULL;
+	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+			"0432 Worker thread stopped.\n");
 	return 0;
 }
 
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2708,7 +2708,7 @@ out:
  * @pdev: pointer to PCI device
  *
  * This routine is to be registered to the kernel's PCI subsystem. When an
- * Emulex HBA is removed from PCI bus. It perform all the necessary cleanup
+ * Emulex HBA is removed from PCI bus, it performs all the necessary cleanup
  * for the HBA device to be removed from the PCI subsystem properly.
  **/
 static void __devexit
@@ -2785,6 +2785,111 @@ lpfc_pci_remove_one(struct pci_dev *pdev)
 }
 
 /**
+ * lpfc_pci_suspend_one: lpfc PCI func to suspend device for power management.
+ * @pdev: pointer to PCI device
+ * @msg: power management message
+ *
+ * This routine is to be registered to the kernel's PCI subsystem to support
+ * system Power Management (PM). When PM invokes this method, it quiesces the
+ * device by stopping the driver's worker thread for the device, turning off
+ * device's interrupt and DMA, and bring the device offline. Note that as the
+ * driver implements the minimum PM requirements to a power-aware driver's PM
+ * support for suspend/resume -- all the possible PM messages (SUSPEND,
+ * HIBERNATE, FREEZE) to the suspend() method call will be treated as SUSPEND
+ * and the driver will fully reinitialize its device during resume() method
+ * call, the driver will set device to PCI_D3hot state in PCI config space
+ * instead of setting it according to the @msg provided by the PM.
+ *
+ * Return code
+ *   0 - driver suspended the device
+ *   Error otherwise
+ **/
+static int
+lpfc_pci_suspend_one(struct pci_dev *pdev, pm_message_t msg)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"0473 PCI device Power Management suspend.\n");
+
+	/* Bring down the device */
+	lpfc_offline_prep(phba);
+	lpfc_offline(phba);
+	kthread_stop(phba->worker_thread);
+
+	/* Disable interrupt from device */
+	lpfc_disable_intr(phba);
+
+	/* Save device state to PCI config space */
+	pci_save_state(pdev);
+	pci_set_power_state(pdev, PCI_D3hot);
+
+	return 0;
+}
+
+/**
+ * lpfc_pci_resume_one: lpfc PCI func to resume device for power management.
+ * @pdev: pointer to PCI device
+ *
+ * This routine is to be registered to the kernel's PCI subsystem to support
+ * system Power Management (PM). When PM invokes this method, it restores
+ * the device's PCI config space state and fully reinitializes the device
+ * and brings it online. Note that as the driver implements the minimum PM
+ * requirements to a power-aware driver's PM for suspend/resume -- all
+ * the possible PM messages (SUSPEND, HIBERNATE, FREEZE) to the suspend()
+ * method call will be treated as SUSPEND and the driver will fully
+ * reinitialize its device during resume() method call, the device will be
+ * set to PCI_D0 directly in PCI config space before restoring the state.
+ *
+ * Return code
+ *   0 - driver suspended the device
+ *   Error otherwise
+ **/
+static int
+lpfc_pci_resume_one(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+	int error;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"0452 PCI device Power Management resume.\n");
+
+	/* Restore device state from PCI config space */
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	if (pdev->is_busmaster)
+		pci_set_master(pdev);
+
+	/* Startup the kernel thread for this host adapter. */
+	phba->worker_thread = kthread_run(lpfc_do_work, phba,
+					"lpfc_worker_%d", phba->brd_no);
+	if (IS_ERR(phba->worker_thread)) {
+		error = PTR_ERR(phba->worker_thread);
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0434 PM resume failed to start worker "
+				"thread: error=x%x.\n", error);
+		return error;
+	}
+
+	/* Enable interrupt from device */
+	error = lpfc_enable_intr(phba);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0430 PM resume Failed to enable interrupt: "
+				"error=x%x.\n", error);
+		return error;
+	}
+
+	/* Restart HBA and bring it online */
+	lpfc_sli_brdrestart(phba);
+	lpfc_online(phba);
+
+	return 0;
+}
+
+/**
  * lpfc_io_error_detected: Driver method for handling PCI I/O error detected.
  * @pdev: pointer to PCI device.
  * @state: the current PCI connection state.
@@ -3036,6 +3141,8 @@ static struct pci_driver lpfc_driver = {
 	.id_table	= lpfc_id_table,
 	.probe		= lpfc_pci_probe_one,
 	.remove		= __devexit_p(lpfc_pci_remove_one),
+	.suspend        = lpfc_pci_suspend_one,
+	.resume         = lpfc_pci_resume_one,
 	.err_handler    = &lpfc_err_handler,
 };
 


