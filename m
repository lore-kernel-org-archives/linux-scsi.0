From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 2/2] mpt3sas: Refcount fw_events and fix unsafe list usage
Date: Sun, 30 Aug 2015 07:54:39 +0000
Message-ID: <1440921279-9973-3-git-send-email-nab@daterainc.com>
References: <1440921279-9973-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440921279-9973-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Calvin Owens <calvinowens@fb.com>, Christoph Hellwig <hch@infradead.org>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, "MPT-FusionLinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, kernel-team <kernel-team@fb.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

The fw_event_work struct is concurrently referenced at shutdown, so
add a refcount to protect it, and refactor the code to use it.

Additionally, refactor _scsih_fw_event_cleanup_queue() such that it
no longer iterates over the list without holding the lock, since
_firmware_event_work() concurrently deletes items from the list.

This patch is a port of Calvin's PATCH-v4 for mpt2sas code.

Cc: Calvin Owens <calvinowens@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: MPT-FusionLinux.pdl <MPT-FusionLinux.pdl@avagotech.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 116 ++++++++++++++++++++++++++++-------
 1 file changed, 94 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 897153b..0431cd0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -175,6 +175,7 @@ struct sense_info {
  * @VP_ID: virtual port id
  * @ignore: flag meaning this event has been marked to ignore
  * @event: firmware event MPI2_EVENT_XXX defined in mpt2_ioc.h
+ * @refcount: reference count for fw_event_work
  * @event_data: reply event data payload follows
  *
  * This object stored on ioc->fw_event_list.
@@ -191,9 +192,37 @@ struct fw_event_work {
 	u8			VP_ID;
 	u8			ignore;
 	u16			event;
+	struct kref		refcount;
 	char			event_data[0] __aligned(4);
 };
 
+static void fw_event_work_free(struct kref *r)
+{
+	kfree(container_of(r, struct fw_event_work, refcount));
+}
+
+static void fw_event_work_get(struct fw_event_work *fw_work)
+{
+	kref_get(&fw_work->refcount);
+}
+
+static void fw_event_work_put(struct fw_event_work *fw_work)
+{
+	kref_put(&fw_work->refcount, fw_event_work_free);
+}
+
+static struct fw_event_work *alloc_fw_event_work(int len)
+{
+	struct fw_event_work *fw_event;
+
+	fw_event = kzalloc(sizeof(*fw_event) + len, GFP_ATOMIC);
+	if (!fw_event)
+		return NULL;
+
+	kref_init(&fw_event->refcount);
+	return fw_event;
+}
+
 /* raid transport support */
 static struct raid_template *mpt3sas_raid_template;
 
@@ -2594,32 +2623,36 @@ _scsih_fw_event_add(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 		return;
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	fw_event_work_get(fw_event);
 	INIT_LIST_HEAD(&fw_event->list);
 	list_add_tail(&fw_event->list, &ioc->fw_event_list);
 	INIT_WORK(&fw_event->work, _firmware_event_work);
+	fw_event_work_get(fw_event);
 	queue_work(ioc->firmware_event_thread, &fw_event->work);
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
 
 /**
- * _scsih_fw_event_free - delete fw_event
+ * _scsih_fw_event_del_from_list - delete fw_event from the list
  * @ioc: per adapter object
  * @fw_event: object describing the event
  * Context: This function will acquire ioc->fw_event_lock.
  *
- * This removes firmware event object from link list, frees associated memory.
+ * If the fw_event is on the fw_event_list, remove it and do a put.
  *
  * Return nothing.
  */
 static void
-_scsih_fw_event_free(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work
+_scsih_fw_event_del_from_list(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work
 	*fw_event)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
-	list_del(&fw_event->list);
-	kfree(fw_event);
+	if (!list_empty(&fw_event->list)) {
+		list_del_init(&fw_event->list);
+		fw_event_work_put(fw_event);
+	}
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
 
@@ -2639,14 +2672,14 @@ mpt3sas_send_trigger_data_event(struct MPT3SAS_ADAPTER *ioc,
 
 	if (ioc->is_driver_loading)
 		return;
-	fw_event = kzalloc(sizeof(*fw_event) + sizeof(*event_data),
-			   GFP_ATOMIC);
+	fw_event = alloc_fw_event_work(sizeof(*event_data));
 	if (!fw_event)
 		return;
 	fw_event->event = MPT3SAS_PROCESS_TRIGGER_DIAG;
 	fw_event->ioc = ioc;
 	memcpy(fw_event->event_data, event_data, sizeof(*event_data));
 	_scsih_fw_event_add(ioc, fw_event);
+	fw_event_work_put(fw_event);
 }
 
 /**
@@ -2662,12 +2695,13 @@ _scsih_error_recovery_delete_devices(struct MPT3SAS_ADAPTER *ioc)
 
 	if (ioc->is_driver_loading)
 		return;
-	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	fw_event = alloc_fw_event_work(0);
 	if (!fw_event)
 		return;
 	fw_event->event = MPT3SAS_REMOVE_UNRESPONDING_DEVICES;
 	fw_event->ioc = ioc;
 	_scsih_fw_event_add(ioc, fw_event);
+	fw_event_work_put(fw_event);
 }
 
 /**
@@ -2681,12 +2715,29 @@ mpt3sas_port_enable_complete(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct fw_event_work *fw_event;
 
-	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	fw_event = alloc_fw_event_work(0);
 	if (!fw_event)
 		return;
 	fw_event->event = MPT3SAS_PORT_ENABLE_COMPLETE;
 	fw_event->ioc = ioc;
 	_scsih_fw_event_add(ioc, fw_event);
+	fw_event_work_put(fw_event);
+}
+
+static struct fw_event_work *dequeue_next_fw_event(struct MPT3SAS_ADAPTER *ioc)
+{
+	unsigned long flags;
+	struct fw_event_work *fw_event = NULL;
+
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	if (!list_empty(&ioc->fw_event_list)) {
+		fw_event = list_first_entry(&ioc->fw_event_list,
+				struct fw_event_work, list);
+		list_del_init(&fw_event->list);
+	}
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+
+	return fw_event;
 }
 
 /**
@@ -2701,17 +2752,25 @@ mpt3sas_port_enable_complete(struct MPT3SAS_ADAPTER *ioc)
 static void
 _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 {
-	struct fw_event_work *fw_event, *next;
+	struct fw_event_work *fw_event;
 
 	if (list_empty(&ioc->fw_event_list) ||
 	     !ioc->firmware_event_thread || in_interrupt())
 		return;
 
-	list_for_each_entry_safe(fw_event, next, &ioc->fw_event_list, list) {
-		if (cancel_delayed_work_sync(&fw_event->delayed_work)) {
-			_scsih_fw_event_free(ioc, fw_event);
-			continue;
-		}
+	while ((fw_event = dequeue_next_fw_event(ioc))) {
+		/*
+		 * Wait on the fw_event to complete. If this returns 1, then
+		 * the event was never executed, and we need a put for the
+		 * reference the delayed_work had on the fw_event.
+		 *
+		 * If it did execute, we wait for it to finish, and the put will
+		 * happen from _firmware_event_work()
+		 */
+		if (cancel_work_sync(&fw_event->work))
+			fw_event_work_put(fw_event);
+
+		fw_event_work_put(fw_event);
 	}
 }
 
@@ -4214,13 +4273,14 @@ _scsih_send_event_to_turn_on_pfa_led(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 {
 	struct fw_event_work *fw_event;
 
-	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	fw_event = alloc_fw_event_work(0);
 	if (!fw_event)
 		return;
 	fw_event->event = MPT3SAS_TURN_ON_PFA_LED;
 	fw_event->device_handle = handle;
 	fw_event->ioc = ioc;
 	_scsih_fw_event_add(ioc, fw_event);
+	fw_event_work_put(fw_event);
 }
 
 /**
@@ -7436,10 +7496,11 @@ mpt3sas_scsih_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase)
 static void
 _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 {
+	_scsih_fw_event_del_from_list(ioc, fw_event);
+
 	/* the queue is being flushed so ignore this event */
-	if (ioc->remove_host ||
-	    ioc->pci_error_recovery) {
-		_scsih_fw_event_free(ioc, fw_event);
+	if (ioc->remove_host || ioc->pci_error_recovery) {
+		fw_event_work_put(fw_event);
 		return;
 	}
 
@@ -7450,8 +7511,17 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 			fw_event->event_data);
 		break;
 	case MPT3SAS_REMOVE_UNRESPONDING_DEVICES:
-		while (scsi_host_in_recovery(ioc->shost) || ioc->shost_recovery)
+		while (scsi_host_in_recovery(ioc->shost) ||
+				ioc->shost_recovery) {
+			/*
+			 * If we're unloading, bail. Otherwise, this can become
+			 * an infinite loop.
+			 */
+			if (ioc->remove_host)
+				goto out;
+
 			ssleep(1);
+		}
 		_scsih_remove_unresponding_sas_devices(ioc);
 		_scsih_scan_for_devices_after_reset(ioc);
 		break;
@@ -7496,7 +7566,8 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 		_scsih_sas_ir_operation_status_event(ioc, fw_event);
 		break;
 	}
-	_scsih_fw_event_free(ioc, fw_event);
+out:
+	fw_event_work_put(fw_event);
 }
 
 /**
@@ -7612,7 +7683,7 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	}
 
 	sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
-	fw_event = kzalloc(sizeof(*fw_event) + sz, GFP_ATOMIC);
+	fw_event = alloc_fw_event_work(sz);
 	if (!fw_event) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
@@ -7625,6 +7696,7 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	fw_event->VP_ID = mpi_reply->VP_ID;
 	fw_event->event = event;
 	_scsih_fw_event_add(ioc, fw_event);
+	fw_event_work_put(fw_event);
 	return 1;
 }
 
-- 
1.9.1
