From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 11/11] zfcp: Fix sparse warning by providing new entry in dbf
Date: Mon, 19 May 2008 12:17:47 +0200
Message-ID: <20080519101834.344392000@de.ibm.com>
References: <20080519101736.590943000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:5728 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbYESKSh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 06:18:37 -0400
Content-Disposition: inline; filename=sparse-dbf.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Peschke <mp3@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

drivers/s390/scsi/zfcp_dbf.c:692:2: warning: context imbalance in
'zfcp_rec_dbf_event_thread' - different lock contexts for basic block

Replace the parameter indicating if the lock is held with a new entry
function that only acquires the lock. This makes the lock handling
more visible and removes the sparse warning.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |   23 +++++++++++++++++------
 drivers/s390/scsi/zfcp_erp.c |   18 +++++++++---------
 drivers/s390/scsi/zfcp_ext.h |    4 ++--
 3 files changed, 28 insertions(+), 17 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-05-19 11:36:24.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-05-19 11:37:28.000000000 +0200
@@ -670,24 +670,20 @@ static struct debug_view zfcp_rec_dbf_vi
  * zfcp_rec_dbf_event_thread - trace event related to recovery thread operation
  * @id2: identifier for event
  * @adapter: adapter
- * @lock: non-zero value indicates that erp_lock has not yet been acquired
+ * This function assumes that the caller is holding erp_lock.
  */
-void zfcp_rec_dbf_event_thread(u8 id2, struct zfcp_adapter *adapter, int lock)
+void zfcp_rec_dbf_event_thread(u8 id2, struct zfcp_adapter *adapter)
 {
 	struct zfcp_rec_dbf_record *r = &adapter->rec_dbf_buf;
 	unsigned long flags = 0;
 	struct list_head *entry;
 	unsigned ready = 0, running = 0, total;
 
-	if (lock)
-		read_lock_irqsave(&adapter->erp_lock, flags);
 	list_for_each(entry, &adapter->erp_ready_head)
 		ready++;
 	list_for_each(entry, &adapter->erp_running_head)
 		running++;
 	total = adapter->erp_total_count;
-	if (lock)
-		read_unlock_irqrestore(&adapter->erp_lock, flags);
 
 	spin_lock_irqsave(&adapter->rec_dbf_lock, flags);
 	memset(r, 0, sizeof(*r));
@@ -700,6 +696,21 @@ void zfcp_rec_dbf_event_thread(u8 id2, s
 	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
 }
 
+/**
+ * zfcp_rec_dbf_event_thread - trace event related to recovery thread operation
+ * @id2: identifier for event
+ * @adapter: adapter
+ * This function assumes that the caller does not hold erp_lock.
+ */
+void zfcp_rec_dbf_event_thread_lock(u8 id2, struct zfcp_adapter *adapter)
+{
+	unsigned long flags;
+
+	read_lock_irqsave(&adapter->erp_lock, flags);
+	zfcp_rec_dbf_event_thread(id2, adapter);
+	read_unlock_irqrestore(&adapter->erp_lock, flags);
+}
+
 static void zfcp_rec_dbf_event_target(u8 id2, void *ref,
 				      struct zfcp_adapter *adapter,
 				      atomic_t *status, atomic_t *erp_count,
--- a/drivers/s390/scsi/zfcp_erp.c	2008-05-19 11:28:32.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-05-19 11:37:28.000000000 +0200
@@ -783,7 +783,7 @@ zfcp_erp_action_ready(struct zfcp_erp_ac
 
 	zfcp_erp_action_to_ready(erp_action);
 	up(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread(2, adapter, 0);
+	zfcp_rec_dbf_event_thread(2, adapter);
 }
 
 /*
@@ -995,7 +995,7 @@ zfcp_erp_thread_kill(struct zfcp_adapter
 
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL, &adapter->status);
 	up(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread(2, adapter, 1);
+	zfcp_rec_dbf_event_thread_lock(2, adapter);
 
 	wait_event(adapter->erp_thread_wqh,
 		   !atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP,
@@ -1050,9 +1050,9 @@ zfcp_erp_thread(void *data)
 		 * no action in 'ready' queue to be processed and
 		 * thread is not to be killed
 		 */
-		zfcp_rec_dbf_event_thread(4, adapter, 1);
+		zfcp_rec_dbf_event_thread_lock(4, adapter);
 		down_interruptible(&adapter->erp_ready_sem);
-		zfcp_rec_dbf_event_thread(5, adapter, 1);
+		zfcp_rec_dbf_event_thread_lock(5, adapter);
 	}
 
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
@@ -2062,9 +2062,9 @@ zfcp_erp_adapter_strategy_open_fsf_xconf
 		 * _must_ be the one belonging to the 'exchange config
 		 * data' request.
 		 */
-		zfcp_rec_dbf_event_thread(6, adapter, 1);
+		zfcp_rec_dbf_event_thread_lock(6, adapter);
 		down(&adapter->erp_ready_sem);
-		zfcp_rec_dbf_event_thread(7, adapter, 1);
+		zfcp_rec_dbf_event_thread_lock(7, adapter);
 		if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT) {
 			ZFCP_LOG_INFO("error: exchange of configuration data "
 				      "for adapter %s timed out\n",
@@ -2118,9 +2118,9 @@ zfcp_erp_adapter_strategy_open_fsf_xport
 	}
 
 	ret = ZFCP_ERP_SUCCEEDED;
-	zfcp_rec_dbf_event_thread(8, adapter, 1);
+	zfcp_rec_dbf_event_thread_lock(8, adapter);
 	down(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread(9, adapter, 1);
+	zfcp_rec_dbf_event_thread_lock(9, adapter);
 	if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT) {
 		ZFCP_LOG_INFO("error: exchange port data timed out (adapter "
 			      "%s)\n", zfcp_get_busid_by_adapter(adapter));
@@ -2876,7 +2876,7 @@ static int zfcp_erp_action_enqueue(int w
 	/* finally put it into 'ready' queue and kick erp thread */
 	list_add_tail(&erp_action->list, &adapter->erp_ready_head);
 	up(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread(1, adapter, 0);
+	zfcp_rec_dbf_event_thread(1, adapter);
 	retval = 0;
  out:
 	zfcp_rec_dbf_event_trigger(id, ref, want, need, erp_action,
--- a/drivers/s390/scsi/zfcp_ext.h	2008-05-19 11:33:24.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-05-19 11:37:28.000000000 +0200
@@ -169,8 +169,8 @@ extern void zfcp_erp_port_access_changed
 extern void zfcp_erp_unit_access_changed(struct zfcp_unit *, u8, void *);
 
 /******************************** AUX ****************************************/
-extern void zfcp_rec_dbf_event_thread(u8 id, struct zfcp_adapter *adapter,
-				      int lock);
+extern void zfcp_rec_dbf_event_thread(u8 id, struct zfcp_adapter *adapter);
+extern void zfcp_rec_dbf_event_thread_lock(u8 id, struct zfcp_adapter *adapter);
 extern void zfcp_rec_dbf_event_adapter(u8 id, void *ref, struct zfcp_adapter *);
 extern void zfcp_rec_dbf_event_port(u8 id, void *ref, struct zfcp_port *port);
 extern void zfcp_rec_dbf_event_unit(u8 id, void *ref, struct zfcp_unit *unit);

-- 
