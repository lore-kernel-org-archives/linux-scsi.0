From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 10/11] mpt2sas: [Resend] OS is not going into hibernation mode.
Date: Wed, 5 Aug 2009 11:48:10 +0530
Message-ID: <20090805061810.GK13733@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:40505 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbZHEGjK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 02:39:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


(1) fix oops ocurring at hibernation time.  This oops was due to the firmware fault watchdog timer still running after we freed resources. To fix the issue we need to terminate the watchdog timer at hibernation time.

(2) fix another ocurring when the system resumes.  This oops was due to driver setting the pci drvdata to NULL on the prior hibernation.  Becuase it was set to NULL, upon resmume we assume the pci drvdata is non-zero, and we oops. To fix the ooops, we don't set pci drvdata to NULL at hibernation time.

(3) fix problem with driver timing out on the first MPI request with interrupts are enabled. The problem is isolated to SLES10, only when MSIX interrupt routing is enabled. To fix the problem the driver will need to backup and restore the MSIX interrupt vector table going into and out of hibernation.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index dbccf62..f9f0ae4 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -119,6 +119,64 @@ _base_fault_reset_work(struct work_struct *work)
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 }
 
+/**
+ * mpt2sas_base_start_watchdog - start the fault_reset_work_q
+ * @ioc: pointer to scsi command object
+ * Context: sleep.
+ *
+ * Return nothing.
+ */
+void
+mpt2sas_base_start_watchdog(struct MPT2SAS_ADAPTER *ioc)
+{
+	unsigned long	 flags;
+
+	if (ioc->fault_reset_work_q)
+		return;
+
+	/* initialize fault polling */
+	INIT_DELAYED_WORK(&ioc->fault_reset_work, _base_fault_reset_work);
+	snprintf(ioc->fault_reset_work_q_name,
+	    sizeof(ioc->fault_reset_work_q_name), "poll_%d_status", ioc->id);
+	ioc->fault_reset_work_q =
+		create_singlethread_workqueue(ioc->fault_reset_work_q_name);
+	if (!ioc->fault_reset_work_q) {
+		printk(MPT2SAS_ERR_FMT "%s: failed (line=%d)\n",
+		    ioc->name, __func__, __LINE__);
+			return;
+	}
+	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
+	if (ioc->fault_reset_work_q)
+		queue_delayed_work(ioc->fault_reset_work_q,
+		    &ioc->fault_reset_work,
+		    msecs_to_jiffies(FAULT_POLLING_INTERVAL));
+	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
+}
+
+/**
+ * mpt2sas_base_stop_watchdog - stop the fault_reset_work_q
+ * @ioc: pointer to scsi command object
+ * Context: sleep.
+ *
+ * Return nothing.
+ */
+void
+mpt2sas_base_stop_watchdog(struct MPT2SAS_ADAPTER *ioc)
+{
+	unsigned long	 flags;
+	struct workqueue_struct *wq;
+
+	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
+	wq = ioc->fault_reset_work_q;
+	ioc->fault_reset_work_q = NULL;
+	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
+	if (wq) {
+		if (!cancel_delayed_work(&ioc->fault_reset_work))
+			flush_workqueue(wq);
+		destroy_workqueue(wq);
+	}
+}
+
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 /**
  * _base_sas_ioc_info - verbose translation of the ioc status
@@ -889,13 +947,13 @@ _base_config_dma_addressing(struct MPT2SAS_ADAPTER *ioc, struct pci_dev *pdev)
 }
 
 /**
- * _base_save_msix_table - backup msix vector table
+ * mpt2sas_base_save_msix_table - backup msix vector table
  * @ioc: per adapter object
  *
  * This address an errata where diag reset clears out the table
  */
-static void
-_base_save_msix_table(struct MPT2SAS_ADAPTER *ioc)
+void
+mpt2sas_base_save_msix_table(struct MPT2SAS_ADAPTER *ioc)
 {
 	int i;
 
@@ -907,12 +965,12 @@ _base_save_msix_table(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
- * _base_restore_msix_table - this restores the msix vector table
+ * mpt2sas_base_restore_msix_table - this restores the msix vector table
  * @ioc: per adapter object
  *
  */
-static void
-_base_restore_msix_table(struct MPT2SAS_ADAPTER *ioc)
+void
+mpt2sas_base_restore_msix_table(struct MPT2SAS_ADAPTER *ioc)
 {
 	int i;
 
@@ -967,12 +1025,10 @@ _base_check_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 static void
 _base_disable_msix(struct MPT2SAS_ADAPTER *ioc)
 {
-	if (ioc->msix_enable) {
-		pci_disable_msix(ioc->pdev);
-		kfree(ioc->msix_table_backup);
-		ioc->msix_table_backup = NULL;
-		ioc->msix_enable = 0;
-	}
+	if (!ioc->msix_enable)
+		return;
+	pci_disable_msix(ioc->pdev);
+	ioc->msix_enable = 0;
 }
 
 /**
@@ -996,14 +1052,6 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	if (_base_check_enable_msix(ioc) != 0)
 		goto try_ioapic;
 
-	ioc->msix_table_backup = kcalloc(ioc->msix_vector_count,
-	    sizeof(u32), GFP_KERNEL);
-	if (!ioc->msix_table_backup) {
-		dfailprintk(ioc, printk(MPT2SAS_INFO_FMT "allocation for "
-		    "msix_table_backup failed!!!\n", ioc->name));
-		goto try_ioapic;
-	}
-
 	memset(&entries, 0, sizeof(struct msix_entry));
 	r = pci_enable_msix(ioc->pdev, &entries, 1);
 	if (r) {
@@ -1107,7 +1155,6 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER *ioc)
 		}
 	}
 
-	pci_set_drvdata(pdev, ioc->shost);
 	_base_mask_interrupts(ioc);
 	r = _base_enable_msix(ioc);
 	if (r)
@@ -1130,7 +1177,6 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER *ioc)
 	ioc->pci_irq = -1;
 	pci_release_selected_regions(ioc->pdev, ioc->bars);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 	return r;
 }
 
@@ -2946,7 +2992,7 @@ _base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 
 	printk(MPT2SAS_INFO_FMT "sending diag reset !!\n", ioc->name);
 
-	_base_save_msix_table(ioc);
+	mpt2sas_base_save_msix_table(ioc);
 
 	drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "clear interrupts\n",
 	    ioc->name));
@@ -3044,7 +3090,7 @@ _base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 		goto out;
 	}
 
-	_base_restore_msix_table(ioc);
+	mpt2sas_base_restore_msix_table(ioc);
 	printk(MPT2SAS_INFO_FMT "diag reset: SUCCESS\n", ioc->name);
 	return 0;
 
@@ -3192,7 +3238,6 @@ mpt2sas_base_free_resources(struct MPT2SAS_ADAPTER *ioc)
 	ioc->chip_phys = 0;
 	pci_release_selected_regions(ioc->pdev, ioc->bars);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 	return;
 }
 
@@ -3206,7 +3251,6 @@ int
 mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 {
 	int r, i;
-	unsigned long	 flags;
 
 	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
 	    __func__));
@@ -3215,6 +3259,18 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	if (r)
 		return r;
 
+	if (ioc->msix_enable) {
+		ioc->msix_table_backup = kcalloc(ioc->msix_vector_count,
+		    sizeof(u32), GFP_KERNEL);
+		if (!ioc->msix_table_backup) {
+			dfailprintk(ioc, printk(MPT2SAS_INFO_FMT
+			    "allocation for msix_table_backup failed!!!\n",
+			    ioc->name));
+			goto out_free_resources;
+		}
+	}
+
+	pci_set_drvdata(ioc->pdev, ioc->shost);
 	r = _base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESET);
 	if (r)
 		goto out_free_resources;
@@ -3287,23 +3343,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	if (r)
 		goto out_free_resources;
 
-	/* initialize fault polling */
-	INIT_DELAYED_WORK(&ioc->fault_reset_work, _base_fault_reset_work);
-	snprintf(ioc->fault_reset_work_q_name,
-	    sizeof(ioc->fault_reset_work_q_name), "poll_%d_status", ioc->id);
-	ioc->fault_reset_work_q =
-		create_singlethread_workqueue(ioc->fault_reset_work_q_name);
-	if (!ioc->fault_reset_work_q) {
-		printk(MPT2SAS_ERR_FMT "%s: failed (line=%d)\n",
-		    ioc->name, __func__, __LINE__);
-			goto out_free_resources;
-	}
-	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-	if (ioc->fault_reset_work_q)
-		queue_delayed_work(ioc->fault_reset_work_q,
-		    &ioc->fault_reset_work,
-		    msecs_to_jiffies(FAULT_POLLING_INTERVAL));
-	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
+	mpt2sas_base_start_watchdog(ioc);
 	return 0;
 
  out_free_resources:
@@ -3311,6 +3351,8 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	ioc->remove_host = 1;
 	mpt2sas_base_free_resources(ioc);
 	_base_release_memory_pools(ioc);
+	pci_set_drvdata(ioc->pdev, NULL);
+	kfree(ioc->msix_table_backup);
 	kfree(ioc->tm_cmds.reply);
 	kfree(ioc->transport_cmds.reply);
 	kfree(ioc->config_cmds.reply);
@@ -3336,22 +3378,15 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 void
 mpt2sas_base_detach(struct MPT2SAS_ADAPTER *ioc)
 {
-	unsigned long	 flags;
-	struct workqueue_struct *wq;
 
 	dexitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
 	    __func__));
 
-	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-	wq = ioc->fault_reset_work_q;
-	ioc->fault_reset_work_q = NULL;
-	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
-	if (!cancel_delayed_work(&ioc->fault_reset_work))
-		flush_workqueue(wq);
-	destroy_workqueue(wq);
-
+	mpt2sas_base_stop_watchdog(ioc);
 	mpt2sas_base_free_resources(ioc);
 	_base_release_memory_pools(ioc);
+	pci_set_drvdata(ioc->pdev, NULL);
+	kfree(ioc->msix_table_backup);
 	kfree(ioc->pfacts);
 	kfree(ioc->ctl_cmds.reply);
 	kfree(ioc->base_cmds.reply);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 1bc5eb7..22b7150 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -707,6 +707,10 @@ typedef void (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID,
 
 /* base shared API */
 extern struct list_head mpt2sas_ioc_list;
+void mpt2sas_base_start_watchdog(struct MPT2SAS_ADAPTER *ioc);
+void mpt2sas_base_stop_watchdog(struct MPT2SAS_ADAPTER *ioc);
+void mpt2sas_base_save_msix_table(struct MPT2SAS_ADAPTER *ioc);
+void mpt2sas_base_restore_msix_table(struct MPT2SAS_ADAPTER *ioc);
 
 int mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc);
 void mpt2sas_base_detach(struct MPT2SAS_ADAPTER *ioc);
@@ -820,7 +824,8 @@ void mpt2sas_ctl_add_to_event_log(struct MPT2SAS_ADAPTER *ioc,
     Mpi2EventNotificationReply_t *mpi_reply);
 
 /* transport shared API */
-void mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply);
+void mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID,
+    u32 reply);
 struct _sas_port *mpt2sas_transport_port_add(struct MPT2SAS_ADAPTER *ioc,
     u16 handle, u16 parent_handle);
 void mpt2sas_transport_port_remove(struct MPT2SAS_ADAPTER *ioc, u64 sas_address,
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 4f02e89..402615e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5789,6 +5789,7 @@ _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
 	u32 device_state;
 
+	mpt2sas_base_stop_watchdog(ioc);
 	flush_scheduled_work();
 	scsi_block_requests(shost);
 	device_state = pci_choose_state(pdev, state);
@@ -5831,6 +5832,7 @@ _scsih_resume(struct pci_dev *pdev)
 
 	mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP, SOFT_RESET);
 	scsi_unblock_requests(shost);
+	mpt2sas_base_start_watchdog(ioc);
 	return 0;
 }
 #endif /* CONFIG_PM */
