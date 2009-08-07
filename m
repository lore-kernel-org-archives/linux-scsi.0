From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 7/9] mpt2sas: crash due to Watchdog is active while OS in standby mode
Date: Fri, 7 Aug 2009 19:37:59 +0530
Message-ID: <20090807140752.GH5807@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:60773 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbZHGO37 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 10:29:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com, stable@kernel.org

Fix oops ocurring at hibernation time.  This oops was due to the firmware fault
watchdog timer still running after we freed resources. To fix the issue we need
to terminate the watchdog timer at hibernation time.

---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index ed9965e..c29c4f9 100644
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
@@ -3209,7 +3267,6 @@ int
 mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 {
 	int r, i;
-	unsigned long	 flags;
 
 	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
 	    __func__));
@@ -3292,23 +3349,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
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
@@ -3341,20 +3382,11 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
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
 	kfree(ioc->pfacts);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 286c185..a299357 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -673,6 +673,8 @@ typedef void (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID,
 
 /* base shared API */
 extern struct list_head mpt2sas_ioc_list;
+void mpt2sas_base_start_watchdog(struct MPT2SAS_ADAPTER *ioc);
+void mpt2sas_base_stop_watchdog(struct MPT2SAS_ADAPTER *ioc);
 
 int mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc);
 void mpt2sas_base_detach(struct MPT2SAS_ADAPTER *ioc);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 25c8d82..2e9a444 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5824,6 +5824,7 @@ _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
 	u32 device_state;
 
+	mpt2sas_base_stop_watchdog(ioc);
 	flush_scheduled_work();
 	scsi_block_requests(shost);
 	device_state = pci_choose_state(pdev, state);
@@ -5866,6 +5867,7 @@ _scsih_resume(struct pci_dev *pdev)
 
 	mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP, SOFT_RESET);
 	scsi_unblock_requests(shost);
+	mpt2sas_base_start_watchdog(ioc);
 	return 0;
 }
 #endif /* CONFIG_PM */
