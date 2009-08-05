From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 2/11] mpt2sas: [Resend] Host Reset code cleanup
Date: Wed, 5 Aug 2009 11:36:42 +0530
Message-ID: <20090805060642.GC13733@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og120.obsmtp.com ([64.18.2.18]:38258 "EHLO
	exprod7og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbZHEG1q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 02:27:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Set SDEV_RUNNING from contents of the interrupt, instead of work threads.
Moved rescanning the devices, updating handles, and deleting not responding
devices to the same contents at the host reset handling.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index f3da592..458ce80 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3500,5 +3500,8 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
 	ioc->ioc_reset_in_progress = 0;
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
+
+	if (!r)
+		_base_reset_handler(ioc, MPT2_IOC_RUNNING);
 	return r;
 }
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 286c185..f6d3cfa 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -119,6 +119,7 @@
 #define MPT2_IOC_PRE_RESET		1 /* prior to host reset */
 #define MPT2_IOC_AFTER_RESET		2 /* just after host reset */
 #define MPT2_IOC_DONE_RESET		3 /* links re-initialized */
+#define MPT2_IOC_RUNNING		4 /* shost running */
 
 /*
  * logging format
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index b1326bf..ef35b8a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -103,7 +103,6 @@ struct sense_info {
 };
 
 
-#define MPT2SAS_RESCAN_AFTER_HOST_RESET (0xFFFF)
 /**
  * struct fw_event_work - firmware event struct
  * @list: link list framework
@@ -2405,27 +2404,6 @@ _scsih_check_topo_delete_events(struct MPT2SAS_ADAPTER *ioc,
 }
 
 /**
- * _scsih_queue_rescan - queue a topology rescan from user context
- * @ioc: per adapter object
- *
- * Return nothing.
- */
-static void
-_scsih_queue_rescan(struct MPT2SAS_ADAPTER *ioc)
-{
-	struct fw_event_work *fw_event;
-
-	if (ioc->wait_for_port_enable_to_complete)
-		return;
-	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
-	if (!fw_event)
-		return;
-	fw_event->event = MPT2SAS_RESCAN_AFTER_HOST_RESET;
-	fw_event->ioc = ioc;
-	_scsih_fw_event_add(ioc, fw_event);
-}
-
-/**
  * _scsih_flush_running_cmds - completing outstanding commands.
  * @ioc: per adapter object
  *
@@ -2456,46 +2434,6 @@ _scsih_flush_running_cmds(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
- * mpt2sas_scsih_reset_handler - reset callback handler (for scsih)
- * @ioc: per adapter object
- * @reset_phase: phase
- *
- * The handler for doing any required cleanup or initialization.
- *
- * The reset phase can be MPT2_IOC_PRE_RESET, MPT2_IOC_AFTER_RESET,
- * MPT2_IOC_DONE_RESET
- *
- * Return nothing.
- */
-void
-mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
-{
-	switch (reset_phase) {
-	case MPT2_IOC_PRE_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
-		    "MPT2_IOC_PRE_RESET\n", ioc->name, __func__));
-		_scsih_fw_event_off(ioc);
-		break;
-	case MPT2_IOC_AFTER_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
-		    "MPT2_IOC_AFTER_RESET\n", ioc->name, __func__));
-		if (ioc->tm_cmds.status & MPT2_CMD_PENDING) {
-			ioc->tm_cmds.status |= MPT2_CMD_RESET;
-			mpt2sas_base_free_smid(ioc, ioc->tm_cmds.smid);
-			complete(&ioc->tm_cmds.done);
-		}
-		_scsih_fw_event_on(ioc);
-		_scsih_flush_running_cmds(ioc);
-		break;
-	case MPT2_IOC_DONE_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
-		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
-		_scsih_queue_rescan(ioc);
-		break;
-	}
-}
-
-/**
  * _scsih_setup_eedp - setup MPI request for EEDP transfer
  * @scmd: pointer to scsi command object
  * @mpi_request: pointer to the SCSI_IO reqest message frame
@@ -5105,22 +5043,9 @@ static void
 _scsih_remove_unresponding_devices(struct MPT2SAS_ADAPTER *ioc)
 {
 	struct _sas_device *sas_device, *sas_device_next;
-	struct _sas_node *sas_expander, *sas_expander_next;
+	struct _sas_node *sas_expander;
 	struct _raid_device *raid_device, *raid_device_next;
-	unsigned long flags;
 
-	_scsih_search_responding_sas_devices(ioc);
-	_scsih_search_responding_raid_devices(ioc);
-	_scsih_search_responding_expanders(ioc);
-
-	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-	ioc->shost_recovery = 0;
-	if (ioc->shost->shost_state == SHOST_RECOVERY) {
-		printk(MPT2SAS_INFO_FMT "putting controller into "
-		    "SHOST_RUNNING\n", ioc->name);
-		scsi_host_set_state(ioc->shost, SHOST_RUNNING);
-	}
-	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 
 	list_for_each_entry_safe(sas_device, sas_device_next,
 	    &ioc->sas_device_list, list) {
@@ -5156,16 +5081,63 @@ _scsih_remove_unresponding_devices(struct MPT2SAS_ADAPTER *ioc)
 		_scsih_raid_device_remove(ioc, raid_device);
 	}
 
-	list_for_each_entry_safe(sas_expander, sas_expander_next,
-	    &ioc->sas_expander_list, list) {
+ retry_expander_search:
+	sas_expander = NULL;
+	list_for_each_entry(sas_expander, &ioc->sas_expander_list, list) {
 		if (sas_expander->responding) {
 			sas_expander->responding = 0;
 			continue;
 		}
-		printk("\tremoving expander: handle(0x%04x), "
-		    " sas_addr(0x%016llx)\n", sas_expander->handle,
-		    (unsigned long long)sas_expander->sas_address);
 		_scsih_expander_remove(ioc, sas_expander->handle);
+		goto retry_expander_search;
+	}
+}
+
+/**
+ * mpt2sas_scsih_reset_handler - reset callback handler (for scsih)
+ * @ioc: per adapter object
+ * @reset_phase: phase
+ *
+ * The handler for doing any required cleanup or initialization.
+ *
+ * The reset phase can be MPT2_IOC_PRE_RESET, MPT2_IOC_AFTER_RESET,
+ * MPT2_IOC_DONE_RESET
+ *
+ * Return nothing.
+ */
+void
+mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
+{
+	switch (reset_phase) {
+	case MPT2_IOC_PRE_RESET:
+		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		    "MPT2_IOC_PRE_RESET\n", ioc->name, __func__));
+		_scsih_fw_event_off(ioc);
+		break;
+	case MPT2_IOC_AFTER_RESET:
+		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		    "MPT2_IOC_AFTER_RESET\n", ioc->name, __func__));
+		if (ioc->tm_cmds.status & MPT2_CMD_PENDING) {
+			ioc->tm_cmds.status |= MPT2_CMD_RESET;
+			mpt2sas_base_free_smid(ioc, ioc->tm_cmds.smid);
+			complete(&ioc->tm_cmds.done);
+		}
+		_scsih_fw_event_on(ioc);
+		_scsih_flush_running_cmds(ioc);
+		break;
+	case MPT2_IOC_DONE_RESET:
+		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
+		_scsih_sas_host_refresh(ioc, 0);
+		_scsih_search_responding_sas_devices(ioc);
+		_scsih_search_responding_raid_devices(ioc);
+		_scsih_search_responding_expanders(ioc);
+		break;
+	case MPT2_IOC_RUNNING:
+		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		    "MPT2_IOC_RUNNING\n", ioc->name, __func__));
+		_scsih_remove_unresponding_devices(ioc);
+		break;
 	}
 }
 
@@ -5185,14 +5157,6 @@ _firmware_event_work(struct work_struct *work)
 	unsigned long flags;
 	struct MPT2SAS_ADAPTER *ioc = fw_event->ioc;
 
-	/* This is invoked by calling _scsih_queue_rescan(). */
-	if (fw_event->event == MPT2SAS_RESCAN_AFTER_HOST_RESET) {
-		_scsih_fw_event_free(ioc, fw_event);
-		_scsih_sas_host_refresh(ioc, 1);
-		_scsih_remove_unresponding_devices(ioc);
-		return;
-	}
-
 	/* the queue is being flushed so ignore this event */
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
 	if (ioc->fw_events_off || ioc->remove_host) {
