From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH v4 2/2] mpt2sas: Refcount fw_events and fix unsafe list usage
Date: Thu, 13 Aug 2015 18:48:10 -0700
Message-ID: <5710d5e272a19c252db0171133a1092be00208f2.1439510240.git.calvinowens@fb.com>
References: <c4742680984986864719f36e691883815e6b5d55.1439510240.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c4742680984986864719f36e691883815e6b5d55.1439510240.git.calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, calvinowens@fb.com, Joe Lawrence <joe.lawrence@stratus.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

The fw_event_work struct is concurrently referenced at shutdown, so
add a refcount to protect it, and refactor the code to use it.

Additionally, refactor _scsih_fw_event_cleanup_queue() such that it
no longer iterates over the list without holding the lock, since
_firmware_event_work() concurrently deletes items from the list.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
Changes in v4: None

Changes in v3:
	* Add a break condition to the REMOVE_UNRESPONDING_DEVICES fw_event,
	  which can loop over a sleep forever (5m+ at least) at unloading. I
	  don't think anything prevented this before, but taking the fw_event
	  object off the list at the top of _firmware_event_work() seems to have
	  made it more likely to happen.

Changes in v2:
	* Squished patches 4-6 into one patch
	* Remove the fw_event from fw_event_list at the start of
	  _firmware_event_work()
	* Explicitly seperate fw_event_list removal from fw_event freeing

drivers/scsi/mpt2sas/mpt2sas_scsih.c | 112 ++++++++++++++++++++++++++++-------
 1 file changed, 91 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 5eca3a4..c0ff55b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -176,9 +176,37 @@ struct fw_event_work {
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
 static struct raid_template *mpt2sas_raid_template;
 
@@ -2872,36 +2900,39 @@ _scsih_fw_event_add(struct MPT2SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 		return;
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	fw_event_work_get(fw_event);
 	list_add_tail(&fw_event->list, &ioc->fw_event_list);
 	INIT_DELAYED_WORK(&fw_event->delayed_work, _firmware_event_work);
+	fw_event_work_get(fw_event);
 	queue_delayed_work(ioc->firmware_event_thread,
 	    &fw_event->delayed_work, 0);
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
-_scsih_fw_event_free(struct MPT2SAS_ADAPTER *ioc, struct fw_event_work
+_scsih_fw_event_del_from_list(struct MPT2SAS_ADAPTER *ioc, struct fw_event_work
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
 
-
 /**
  * _scsih_error_recovery_delete_devices - remove devices not responding
  * @ioc: per adapter object
@@ -2916,13 +2947,14 @@ _scsih_error_recovery_delete_devices(struct MPT2SAS_ADAPTER *ioc)
 	if (ioc->is_driver_loading)
 		return;
 
-	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	fw_event = alloc_fw_event_work(0);
 	if (!fw_event)
 		return;
 
 	fw_event->event = MPT2SAS_REMOVE_UNRESPONDING_DEVICES;
 	fw_event->ioc = ioc;
 	_scsih_fw_event_add(ioc, fw_event);
+	fw_event_work_put(fw_event);
 }
 
 /**
@@ -2936,12 +2968,29 @@ mpt2sas_port_enable_complete(struct MPT2SAS_ADAPTER *ioc)
 {
 	struct fw_event_work *fw_event;
 
-	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	fw_event = alloc_fw_event_work(0);
 	if (!fw_event)
 		return;
 	fw_event->event = MPT2SAS_PORT_ENABLE_COMPLETE;
 	fw_event->ioc = ioc;
 	_scsih_fw_event_add(ioc, fw_event);
+	fw_event_work_put(fw_event);
+}
+
+static struct fw_event_work *dequeue_next_fw_event(struct MPT2SAS_ADAPTER *ioc)
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
@@ -2956,17 +3005,25 @@ mpt2sas_port_enable_complete(struct MPT2SAS_ADAPTER *ioc)
 static void
 _scsih_fw_event_cleanup_queue(struct MPT2SAS_ADAPTER *ioc)
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
+		if (cancel_delayed_work_sync(&fw_event->delayed_work))
+			fw_event_work_put(fw_event);
+
+		fw_event_work_put(fw_event);
 	}
 }
 
@@ -4447,13 +4504,14 @@ _scsih_send_event_to_turn_on_pfa_led(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 {
 	struct fw_event_work *fw_event;
 
-	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	fw_event = alloc_fw_event_work(0);
 	if (!fw_event)
 		return;
 	fw_event->event = MPT2SAS_TURN_ON_PFA_LED;
 	fw_event->device_handle = handle;
 	fw_event->ioc = ioc;
 	_scsih_fw_event_add(ioc, fw_event);
+	fw_event_work_put(fw_event);
 }
 
 /**
@@ -7554,17 +7612,27 @@ _firmware_event_work(struct work_struct *work)
 	    struct fw_event_work, delayed_work.work);
 	struct MPT2SAS_ADAPTER *ioc = fw_event->ioc;
 
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
 
 	switch (fw_event->event) {
 	case MPT2SAS_REMOVE_UNRESPONDING_DEVICES:
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
@@ -7613,7 +7681,8 @@ _firmware_event_work(struct work_struct *work)
 		_scsih_sas_ir_operation_status_event(ioc, fw_event);
 		break;
 	}
-	_scsih_fw_event_free(ioc, fw_event);
+out:
+	fw_event_work_put(fw_event);
 }
 
 /**
@@ -7751,7 +7820,7 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 	}
 
 	sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
-	fw_event = kzalloc(sizeof(*fw_event) + sz, GFP_ATOMIC);
+	fw_event = alloc_fw_event_work(sz);
 	if (!fw_event) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
@@ -7764,6 +7833,7 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 	fw_event->VP_ID = mpi_reply->VP_ID;
 	fw_event->event = event;
 	_scsih_fw_event_add(ioc, fw_event);
+	fw_event_work_put(fw_event);
 	return;
 }
 
-- 
2.5.0
