From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 10/11] zfcp: Add trace records for recovery actions.
Date: Thu, 27 Mar 2008 14:22:04 +0100
Message-ID: <20080327133030.781888000@de.ibm.com>
References: <20080327132154.826339000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:2659 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759594AbYC0Nae (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2008 09:30:34 -0400
Content-Disposition: inline; filename=zfcp_rec_dbf_record_action.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

This patch writes trace records for various phases of a recovery action:
action being created, action being processed, action continueing
asynchronously, action gone, action timed out, action dismissed etc.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |   35 +++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_def.h |    9 +++++++++
 drivers/s390/scsi/zfcp_erp.c |    6 ++++++
 drivers/s390/scsi/zfcp_ext.h |    1 +
 4 files changed, 51 insertions(+)

--- a/drivers/s390/scsi/zfcp_def.h	2008-03-27 13:47:58.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2008-03-27 13:48:19.000000000 +0100
@@ -307,10 +307,18 @@ struct zfcp_rec_dbf_record_trigger {
 	u64 fcp_lun;
 } __attribute__ ((packed));
 
+struct zfcp_rec_dbf_record_action {
+	u32 status;
+	u32 step;
+	u64 action;
+	u64 fsf_req;
+} __attribute__ ((packed));
+
 struct zfcp_rec_dbf_record {
 	u8 id;
 	u8 id2;
 	union {
+		struct zfcp_rec_dbf_record_action action;
 		struct zfcp_rec_dbf_record_thread thread;
 		struct zfcp_rec_dbf_record_target target;
 		struct zfcp_rec_dbf_record_trigger trigger;
@@ -318,6 +326,7 @@ struct zfcp_rec_dbf_record {
 } __attribute__ ((packed));
 
 enum {
+	ZFCP_REC_DBF_ID_ACTION,
 	ZFCP_REC_DBF_ID_THREAD,
 	ZFCP_REC_DBF_ID_TARGET,
 	ZFCP_REC_DBF_ID_TRIGGER,
--- a/drivers/s390/scsi/zfcp_erp.c	2008-03-27 13:47:58.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-03-27 13:48:19.000000000 +0100
@@ -893,8 +893,10 @@ zfcp_erp_strategy_check_fsfreq(struct zf
 						 "a_ca_disreq");
 				erp_action->fsf_req->status |=
 					ZFCP_STATUS_FSFREQ_DISMISSED;
+				zfcp_rec_dbf_event_action(142, erp_action);
 			}
 			if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT) {
+				zfcp_rec_dbf_event_action(143, erp_action);
 				ZFCP_LOG_NORMAL("error: erp step timed out "
 						"(action=%d, fsf_req=%p)\n ",
 						erp_action->action,
@@ -3162,6 +3164,8 @@ zfcp_erp_action_dequeue(struct zfcp_erp_
 	debug_text_event(adapter->erp_dbf, 4, "a_actdeq");
 	debug_event(adapter->erp_dbf, 4, &erp_action->action, sizeof (int));
 	list_del(&erp_action->list);
+	zfcp_rec_dbf_event_action(144, erp_action);
+
 	switch (erp_action->action) {
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
 		atomic_clear_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
@@ -3305,6 +3309,7 @@ static void zfcp_erp_action_to_running(s
 	debug_text_event(adapter->erp_dbf, 6, "a_toru");
 	debug_event(adapter->erp_dbf, 6, &erp_action->action, sizeof (int));
 	list_move(&erp_action->list, &erp_action->adapter->erp_running_head);
+	zfcp_rec_dbf_event_action(145, erp_action);
 }
 
 static void zfcp_erp_action_to_ready(struct zfcp_erp_action *erp_action)
@@ -3314,6 +3319,7 @@ static void zfcp_erp_action_to_ready(str
 	debug_text_event(adapter->erp_dbf, 6, "a_tore");
 	debug_event(adapter->erp_dbf, 6, &erp_action->action, sizeof (int));
 	list_move(&erp_action->list, &erp_action->adapter->erp_ready_head);
+	zfcp_rec_dbf_event_action(146, erp_action);
 }
 
 void zfcp_erp_port_boxed(struct zfcp_port *port, u8 id, u64 ref)
--- a/drivers/s390/scsi/zfcp_ext.h	2008-03-27 13:47:58.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-03-27 13:48:19.000000000 +0100
@@ -173,6 +173,7 @@ extern void zfcp_rec_dbf_event_unit(u8 i
 extern void zfcp_rec_dbf_event_trigger(u8 id, u64 ref, u8 want, u8 need,
 				       u64 action, struct zfcp_adapter *,
 				       struct zfcp_port *, struct zfcp_unit *);
+extern void zfcp_rec_dbf_event_action(u8 id, struct zfcp_erp_action *);
 
 extern void zfcp_hba_dbf_event_fsf_response(struct zfcp_fsf_req *);
 extern void zfcp_hba_dbf_event_fsf_unsol(const char *, struct zfcp_adapter *,
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 13:47:58.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 13:48:19.000000000 +0100
@@ -524,6 +524,7 @@ static const char *zfcp_rec_dbf_tags[] =
 	[ZFCP_REC_DBF_ID_THREAD] = "thread",
 	[ZFCP_REC_DBF_ID_TARGET] = "target",
 	[ZFCP_REC_DBF_ID_TRIGGER] = "trigger",
+	[ZFCP_REC_DBF_ID_ACTION] = "action",
 };
 
 static const char *zfcp_rec_dbf_ids[] = {
@@ -671,6 +672,11 @@ static const char *zfcp_rec_dbf_ids[] = 
 	[139]	= "hbaapi unit shutdown",
 	[140]	= "qdio error",
 	[141]	= "scsi host reset",
+	[142]	= "dismissing fsf request for recovery action",
+	[143]	= "recovery action timed out",
+	[144]	= "recovery action gone",
+	[145]	= "recovery action being processed",
+	[146]	= "recovery action ready for next step",
 };
 
 static int zfcp_rec_dbf_view_format(debug_info_t *id, struct debug_view *view,
@@ -708,6 +714,12 @@ static int zfcp_rec_dbf_view_format(debu
 		zfcp_dbf_out(&p, "port_status", "0x%08x", r->u.trigger.ps);
 		zfcp_dbf_out(&p, "unit_status", "0x%08x", r->u.trigger.us);
 		break;
+	case ZFCP_REC_DBF_ID_ACTION:
+		zfcp_dbf_out(&p, "erp_action", "0x%016Lx", r->u.action.action);
+		zfcp_dbf_out(&p, "fsf_req", "0x%016Lx", r->u.action.fsf_req);
+		zfcp_dbf_out(&p, "status", "0x%08Lx", r->u.action.status);
+		zfcp_dbf_out(&p, "step", "0x%08Lx", r->u.action.step);
+		break;
 	}
 	sprintf(p, "\n");
 	return (p - buf) + 1;
@@ -861,6 +873,29 @@ void zfcp_rec_dbf_event_trigger(u8 id2, 
 	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
 }
 
+/**
+ * zfcp_rec_dbf_event_action - trace event showing progress of recovery action
+ * @id2: identifier
+ * @erp_action: error recovery action struct pointer
+ */
+void zfcp_rec_dbf_event_action(u8 id2, struct zfcp_erp_action *erp_action)
+{
+	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_rec_dbf_record *r = &adapter->rec_dbf_buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->rec_dbf_lock, flags);
+	memset(r, 0, sizeof(*r));
+	r->id = ZFCP_REC_DBF_ID_ACTION;
+	r->id2 = id2;
+	r->u.action.action = (u64)erp_action;
+	r->u.action.status = erp_action->status;
+	r->u.action.step = erp_action->step;
+	r->u.action.fsf_req = (u64)erp_action->fsf_req;
+	debug_event(adapter->rec_dbf, 4, r, sizeof(*r));
+	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
+}
+
 static void
 _zfcp_san_dbf_event_common_ct(const char *tag, struct zfcp_fsf_req *fsf_req,
 			      u32 s_id, u32 d_id, void *buffer, int buflen)

-- 
