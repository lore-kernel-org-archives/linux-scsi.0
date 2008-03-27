From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 07/11] zfcp: Add trace records for recovery thread and its queues
Date: Thu, 27 Mar 2008 14:22:01 +0100
Message-ID: <20080327133027.927216000@de.ibm.com>
References: <20080327132154.826339000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:57791 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759375AbYC0Nab (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2008 09:30:31 -0400
Content-Disposition: inline; filename=zfcp_rec_dbf_record_thread.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

This patch writes trace records which provide information about the
operation of the zfcp error recovery thread and the queues it works
on.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |   51 +++++++++++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_def.h |   12 ++++++++++
 drivers/s390/scsi/zfcp_erp.c |    9 +++++++
 drivers/s390/scsi/zfcp_ext.h |    3 ++
 4 files changed, 75 insertions(+)

--- a/drivers/s390/scsi/zfcp_erp.c	2008-03-27 12:58:16.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-03-27 13:47:18.000000000 +0100
@@ -788,6 +788,7 @@ zfcp_erp_action_ready(struct zfcp_erp_ac
 
 	zfcp_erp_action_to_ready(erp_action);
 	up(&adapter->erp_ready_sem);
+	zfcp_rec_dbf_event_thread(2, adapter, 0);
 }
 
 /*
@@ -1027,6 +1028,7 @@ zfcp_erp_thread_kill(struct zfcp_adapter
 
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL, &adapter->status);
 	up(&adapter->erp_ready_sem);
+	zfcp_rec_dbf_event_thread(2, adapter, 1);
 
 	wait_event(adapter->erp_thread_wqh,
 		   !atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP,
@@ -1084,7 +1086,9 @@ zfcp_erp_thread(void *data)
 		 * no action in 'ready' queue to be processed and
 		 * thread is not to be killed
 		 */
+		zfcp_rec_dbf_event_thread(4, adapter, 1);
 		down_interruptible(&adapter->erp_ready_sem);
+		zfcp_rec_dbf_event_thread(5, adapter, 1);
 		debug_text_event(adapter->erp_dbf, 5, "a_th_woken");
 	}
 
@@ -2150,7 +2154,9 @@ zfcp_erp_adapter_strategy_open_fsf_xconf
 		 * _must_ be the one belonging to the 'exchange config
 		 * data' request.
 		 */
+		zfcp_rec_dbf_event_thread(6, adapter, 1);
 		down(&adapter->erp_ready_sem);
+		zfcp_rec_dbf_event_thread(7, adapter, 1);
 		if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT) {
 			ZFCP_LOG_INFO("error: exchange of configuration data "
 				      "for adapter %s timed out\n",
@@ -2207,7 +2213,9 @@ zfcp_erp_adapter_strategy_open_fsf_xport
 	debug_text_event(adapter->erp_dbf, 6, "a_xport_ok");
 
 	ret = ZFCP_ERP_SUCCEEDED;
+	zfcp_rec_dbf_event_thread(8, adapter, 1);
 	down(&adapter->erp_ready_sem);
+	zfcp_rec_dbf_event_thread(9, adapter, 1);
 	if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT) {
 		ZFCP_LOG_INFO("error: exchange port data timed out (adapter "
 			      "%s)\n", zfcp_get_busid_by_adapter(adapter));
@@ -3091,6 +3099,7 @@ zfcp_erp_action_enqueue(int action,
 	/* finally put it into 'ready' queue and kick erp thread */
 	list_add_tail(&erp_action->list, &adapter->erp_ready_head);
 	up(&adapter->erp_ready_sem);
+	zfcp_rec_dbf_event_thread(1, adapter, 0);
 	retval = 0;
  out:
 	return retval;
--- a/drivers/s390/scsi/zfcp_def.h	2008-03-27 13:46:58.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2008-03-27 13:47:18.000000000 +0100
@@ -279,13 +279,25 @@ struct zfcp_erp_dbf_record {
 	u8 dummy[16];
 } __attribute__ ((packed));
 
+struct zfcp_rec_dbf_record_thread {
+	u32 sema;
+	u32 total;
+	u32 ready;
+	u32 running;
+} __attribute__ ((packed));
+
 struct zfcp_rec_dbf_record {
 	u8 id;
 	u8 id2;
 	union {
+		struct zfcp_rec_dbf_record_thread thread;
 	} u;
 } __attribute__ ((packed));
 
+enum {
+	ZFCP_REC_DBF_ID_THREAD,
+};
+
 struct zfcp_hba_dbf_record_response {
 	u32 fsf_command;
 	u64 fsf_reqid;
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 13:46:58.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 13:47:18.000000000 +0100
@@ -521,9 +521,19 @@ static struct debug_view zfcp_hba_dbf_vi
 };
 
 static const char *zfcp_rec_dbf_tags[] = {
+	[ZFCP_REC_DBF_ID_THREAD] = "thread",
 };
 
 static const char *zfcp_rec_dbf_ids[] = {
+	[1]	= "new",
+	[2]	= "ready",
+	[3]	= "kill",
+	[4]	= "down sleep",
+	[5]	= "down wakeup",
+	[6]	= "down sleep ecd",
+	[7]	= "down wakeup ecd",
+	[8]	= "down sleep epd",
+	[9]	= "down wakeup epd",
 };
 
 static int zfcp_rec_dbf_view_format(debug_info_t *id, struct debug_view *view,
@@ -536,6 +546,12 @@ static int zfcp_rec_dbf_view_format(debu
 	zfcp_dbf_outs(&p, "hint", zfcp_rec_dbf_ids[r->id2]);
 	zfcp_dbf_out(&p, "id", "%d", r->id2);
 	switch (r->id) {
+	case ZFCP_REC_DBF_ID_THREAD:
+		zfcp_dbf_out(&p, "sema", "%d", r->u.thread.sema);
+		zfcp_dbf_out(&p, "total", "%d", r->u.thread.total);
+		zfcp_dbf_out(&p, "ready", "%d", r->u.thread.ready);
+		zfcp_dbf_out(&p, "running", "%d", r->u.thread.running);
+		break;
 	}
 	sprintf(p, "\n");
 	return (p - buf) + 1;
@@ -550,6 +566,41 @@ static struct debug_view zfcp_rec_dbf_vi
 	NULL
 };
 
+/**
+ * zfcp_rec_dbf_event_thread - trace event related to recovery thread operation
+ * @id2: identifier for event
+ * @adapter: adapter
+ * @lock: non-zero value indicates that erp_lock has not yet been acquired
+ */
+void zfcp_rec_dbf_event_thread(u8 id2, struct zfcp_adapter *adapter, int lock)
+{
+	struct zfcp_rec_dbf_record *r = &adapter->rec_dbf_buf;
+	unsigned long flags = 0;
+	struct list_head *entry;
+	unsigned ready = 0, running = 0, total;
+
+	if (lock)
+		read_lock_irqsave(&adapter->erp_lock, flags);
+	list_for_each(entry, &adapter->erp_ready_head)
+		ready++;
+	list_for_each(entry, &adapter->erp_running_head)
+		running++;
+	total = adapter->erp_total_count;
+	if (lock)
+		read_unlock_irqrestore(&adapter->erp_lock, flags);
+
+	spin_lock_irqsave(&adapter->rec_dbf_lock, flags);
+	memset(r, 0, sizeof(*r));
+	r->id = ZFCP_REC_DBF_ID_THREAD;
+	r->id2 = id2;
+	r->u.thread.sema = atomic_read(&adapter->erp_ready_sem.count);
+	r->u.thread.total = total;
+	r->u.thread.ready = ready;
+	r->u.thread.running = running;
+	debug_event(adapter->rec_dbf, 5, r, sizeof(*r));
+	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
+}
+
 static void
 _zfcp_san_dbf_event_common_ct(const char *tag, struct zfcp_fsf_req *fsf_req,
 			      u32 s_id, u32 d_id, void *buffer, int buflen)
--- a/drivers/s390/scsi/zfcp_ext.h	2008-03-27 12:58:16.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-03-27 13:47:18.000000000 +0100
@@ -164,6 +164,9 @@ extern void zfcp_erp_port_access_changed
 extern void zfcp_erp_unit_access_changed(struct zfcp_unit *);
 
 /******************************** AUX ****************************************/
+extern void zfcp_rec_dbf_event_thread(u8 id, struct zfcp_adapter *adapter,
+				      int lock);
+
 extern void zfcp_hba_dbf_event_fsf_response(struct zfcp_fsf_req *);
 extern void zfcp_hba_dbf_event_fsf_unsol(const char *, struct zfcp_adapter *,
 					 struct fsf_status_read_buffer *);

-- 
