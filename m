From: michaelc@cs.wisc.edu
Subject: [PATCH 07/23] libiscsi: do not block session during logout
Date: Tue,  4 Dec 2007 18:42:21 -0600
Message-ID: <1196815377131-git-send-email-michaelc@cs.wisc.edu>
References: <11968153574025-git-send-email-michaelc@cs.wisc.edu>
 <119681536472-git-send-email-michaelc@cs.wisc.edu>
 <11968153663560-git-send-email-michaelc@cs.wisc.edu>
 <11968153713324-git-send-email-michaelc@cs.wisc.edu>
 <11968153753743-git-send-email-michaelc@cs.wisc.edu>
 <11968153751098-git-send-email-michaelc@cs.wisc.edu>
 <1196815376111-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbXLEAnC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:43:02 -0500
In-Reply-To: <1196815376111-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

There is not need to block the session during logout. Since
we are going to fail the commands that were blocked just fail them
immediately instead.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iser_initiator.c |   11 +--
 drivers/scsi/iscsi_tcp.c                     |    4 +-
 drivers/scsi/libiscsi.c                      |  153 ++++++++++++++------------
 include/scsi/libiscsi.h                      |    2 +
 include/scsi/scsi_transport_iscsi.h          |    1 +
 5 files changed, 89 insertions(+), 82 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index a6f2303..46fc9b7 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -617,15 +617,8 @@ void iser_snd_completion(struct iser_desc *tx_desc)
 		/* this arithmetic is legal by libiscsi dd_data allocation */
 		mtask = (void *) ((long)(void *)tx_desc -
 				  sizeof(struct iscsi_mgmt_task));
-		if (mtask->hdr->itt == RESERVED_ITT) {
-			struct iscsi_session *session = conn->session;
-
-			spin_lock(&conn->session->lock);
-			list_del(&mtask->running);
-			__kfifo_put(session->mgmtpool.queue, (void*)&mtask,
-				    sizeof(void*));
-			spin_unlock(&session->lock);
-		}
+		if (mtask->hdr->itt == RESERVED_ITT)
+			iscsi_free_mgmt_task(conn, mtask);
 	}
 }
 
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index f79a457..90eae8e 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1349,9 +1349,7 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
 		struct iscsi_session *session = conn->session;
 
 		spin_lock_bh(&session->lock);
-		list_del(&conn->mtask->running);
-		__kfifo_put(session->mgmtpool.queue, (void*)&conn->mtask,
-			    sizeof(void*));
+		iscsi_free_mgmt_task(conn, mtask);
 		spin_unlock_bh(&session->lock);
 	}
 	return 0;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d43f909..b7a2b9a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -37,9 +37,6 @@
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/libiscsi.h>
 
-static void fail_command(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
-			 int err);
-
 struct iscsi_session *
 class_to_transport_session(struct iscsi_cls_session *cls_session)
 {
@@ -274,6 +271,53 @@ static void __iscsi_put_ctask(struct iscsi_cmd_task *ctask)
 		iscsi_complete_command(ctask);
 }
 
+/*
+ * session lock must be held
+ */
+static void fail_command(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
+			 int err)
+{
+	struct scsi_cmnd *sc;
+
+	sc = ctask->sc;
+	if (!sc)
+		return;
+
+	if (ctask->state == ISCSI_TASK_PENDING)
+		/*
+		 * cmd never made it to the xmit thread, so we should not count
+		 * the cmd in the sequencing
+		 */
+		conn->session->queued_cmdsn--;
+	else
+		conn->session->tt->cleanup_cmd_task(conn, ctask);
+
+	sc->result = err;
+	scsi_set_resid(sc, scsi_bufflen(sc));
+	if (conn->ctask == ctask)
+		conn->ctask = NULL;
+	/* release ref from queuecommand */
+	__iscsi_put_ctask(ctask);
+}
+
+/**
+ * iscsi_free_mgmt_task - return mgmt task back to pool
+ * @conn: iscsi connection
+ * @mtask: mtask
+ *
+ * Must be called with session lock.
+ */
+void iscsi_free_mgmt_task(struct iscsi_conn *conn,
+			  struct iscsi_mgmt_task *mtask)
+{
+	list_del_init(&mtask->running);
+	if (conn->login_mtask == mtask)
+		return;
+	__kfifo_put(conn->session->mgmtpool.queue,
+		    (void*)&mtask, sizeof(void*));
+}
+EXPORT_SYMBOL_GPL(iscsi_free_mgmt_task);
+
 /**
  * iscsi_cmd_rsp - SCSI Command Response processing
  * @conn: iscsi connection
@@ -464,10 +508,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			 */
 			if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
 				rc = ISCSI_ERR_CONN_FAILED;
-			list_del_init(&mtask->running);
-			if (conn->login_mtask != mtask)
-				__kfifo_put(session->mgmtpool.queue,
-					    (void*)&mtask, sizeof(void*));
+			iscsi_free_mgmt_task(conn, mtask);
 			break;
 		case ISCSI_OP_SCSI_TMFUNC_RSP:
 			if (datalen) {
@@ -476,6 +517,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			}
 
 			iscsi_tmf_rsp(conn, hdr);
+			iscsi_free_mgmt_task(conn, mtask);
 			break;
 		case ISCSI_OP_NOOP_IN:
 			if (hdr->ttt != cpu_to_be32(ISCSI_RESERVED_TAG) || datalen) {
@@ -486,9 +528,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 			if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
 				rc = ISCSI_ERR_CONN_FAILED;
-			list_del_init(&mtask->running);
-			__kfifo_put(session->mgmtpool.queue,
-				    (void*)&mtask, sizeof(void*));
+			iscsi_free_mgmt_task(conn, mtask);
 			break;
 		default:
 			rc = ISCSI_ERR_BAD_OPCODE;
@@ -650,14 +690,12 @@ static void iscsi_prep_mtask(struct iscsi_conn *conn,
 static int iscsi_xmit_mtask(struct iscsi_conn *conn)
 {
 	struct iscsi_hdr *hdr = conn->mtask->hdr;
-	int rc, was_logout = 0;
+	int rc;
 
+	if ((hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGOUT)
+		conn->session->state = ISCSI_STATE_LOGGING_OUT;
 	spin_unlock_bh(&conn->session->lock);
-	if ((hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGOUT) {
-		conn->session->state = ISCSI_STATE_IN_RECOVERY;
-		iscsi_block_session(session_to_cls(conn->session));
-		was_logout = 1;
-	}
+
 	rc = conn->session->tt->xmit_mgmt_task(conn, conn->mtask);
 	spin_lock_bh(&conn->session->lock);
 	if (rc)
@@ -665,11 +703,6 @@ static int iscsi_xmit_mtask(struct iscsi_conn *conn)
 
 	/* done with this in-progress mtask */
 	conn->mtask = NULL;
-
-	if (was_logout) {
-		set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-		return -ENODATA;
-	}
 	return 0;
 }
 
@@ -763,6 +796,12 @@ check_mgmt:
 	while (!list_empty(&conn->mgmtqueue)) {
 		conn->mtask = list_entry(conn->mgmtqueue.next,
 					 struct iscsi_mgmt_task, running);
+		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
+			iscsi_free_mgmt_task(conn, conn->mtask);
+			conn->mtask = NULL;
+			continue;
+		}
+
 		iscsi_prep_mtask(conn, conn->mtask);
 		list_move_tail(conn->mgmtqueue.next, &conn->mgmt_run_list);
 		rc = iscsi_xmit_mtask(conn);
@@ -777,6 +816,10 @@ check_mgmt:
 
 		conn->ctask = list_entry(conn->xmitqueue.next,
 					 struct iscsi_cmd_task, running);
+		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
+			fail_command(conn, conn->ctask, DID_NO_CONNECT << 16);
+			continue;
+		}
 		if (iscsi_prep_scsi_cmd_pdu(conn->ctask)) {
 			fail_command(conn, conn->ctask, DID_ABORT << 16);
 			continue;
@@ -800,6 +843,12 @@ check_mgmt:
 		if (conn->session->fast_abort && conn->tmf_state != TMF_INITIAL)
 			break;
 
+		/*
+		 * we always do fastlogout - conn stop code will clean up.
+		 */
+		if (conn->session->state == ISCSI_STATE_LOGGING_OUT)
+			break;
+
 		conn->ctask = list_entry(conn->requeue.next,
 					 struct iscsi_cmd_task, running);
 		conn->ctask->state = ISCSI_TASK_RUNNING;
@@ -842,6 +891,7 @@ enum {
 	FAILURE_SESSION_TERMINATE,
 	FAILURE_SESSION_IN_RECOVERY,
 	FAILURE_SESSION_RECOVERY_TIMEOUT,
+	FAILURE_SESSION_LOGGING_OUT,
 };
 
 int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
@@ -879,12 +929,19 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 			goto reject;
 		}
 
-		if (session->state == ISCSI_STATE_RECOVERY_FAILED)
+		switch (session->state) {
+		case ISCSI_STATE_RECOVERY_FAILED:
 			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
-		else if (session->state == ISCSI_STATE_TERMINATE)
+			break;
+		case ISCSI_STATE_TERMINATE:
 			reason = FAILURE_SESSION_TERMINATE;
-		else
+			break;
+		case ISCSI_STATE_LOGGING_OUT:
+			reason = FAILURE_SESSION_LOGGING_OUT;
+			break;
+		default:
 			reason = FAILURE_SESSION_FREED;
+		}
 		goto fault;
 	}
 
@@ -1120,45 +1177,10 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	if (age != session->age ||
 	    session->state != ISCSI_STATE_LOGGED_IN)
 		return -ENOTCONN;
-
-	if (!list_empty(&mtask->running)) {
-		list_del_init(&mtask->running);
-		__kfifo_put(session->mgmtpool.queue, (void*)&mtask,
-			    sizeof(void*));
-	}
 	return 0;
 }
 
 /*
- * session lock must be held
- */
-static void fail_command(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
-			 int err)
-{
-	struct scsi_cmnd *sc;
-
-	sc = ctask->sc;
-	if (!sc)
-		return;
-
-	if (ctask->state == ISCSI_TASK_PENDING)
-		/*
-		 * cmd never made it to the xmit thread, so we should not count
-		 * the cmd in the sequencing
-		 */
-		conn->session->queued_cmdsn--;
-	else
-		conn->session->tt->cleanup_cmd_task(conn, ctask);
-
-	sc->result = err;
-	scsi_set_resid(sc, scsi_bufflen(sc));
-	if (conn->ctask == ctask)
-		conn->ctask = NULL;
-	/* release ref from queuecommand */
-	__iscsi_put_ctask(ctask);
-}
-
-/*
  * Fail commands. session lock held and recv side suspended and xmit
  * thread flushed
  */
@@ -1837,22 +1859,13 @@ flush_control_queues(struct iscsi_session *session, struct iscsi_conn *conn)
 	/* handle pending */
 	list_for_each_entry_safe(mtask, tmp, &conn->mgmtqueue, running) {
 		debug_scsi("flushing pending mgmt task itt 0x%x\n", mtask->itt);
-		list_del_init(&mtask->running);
-		if (mtask == conn->login_mtask)
-			continue;
-		__kfifo_put(session->mgmtpool.queue, (void*)&mtask,
-			    sizeof(void*));
+		iscsi_free_mgmt_task(conn, mtask);
 	}
 
 	/* handle running */
 	list_for_each_entry_safe(mtask, tmp, &conn->mgmt_run_list, running) {
 		debug_scsi("flushing running mgmt task itt 0x%x\n", mtask->itt);
-		list_del_init(&mtask->running);
-
-		if (mtask == conn->login_mtask)
-			continue;
-		__kfifo_put(session->mgmtpool.queue, (void*)&mtask,
-			   sizeof(void*));
+		iscsi_free_mgmt_task(conn, mtask);
 	}
 
 	conn->mtask = NULL;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 4b3e3c1..d68f745 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -346,6 +346,8 @@ extern int __iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
 extern int iscsi_verify_itt(struct iscsi_conn *, struct iscsi_hdr *,
 			    uint32_t *);
 extern void iscsi_requeue_ctask(struct iscsi_cmd_task *ctask);
+extern void iscsi_free_mgmt_task(struct iscsi_conn *conn,
+				 struct iscsi_mgmt_task *mtask);
 
 /*
  * generic helpers
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 7ff6199..b8d97bd 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -176,6 +176,7 @@ struct iscsi_cls_conn {
 #define ISCSI_STATE_TERMINATE		4
 #define ISCSI_STATE_IN_RECOVERY		5
 #define ISCSI_STATE_RECOVERY_FAILED	6
+#define ISCSI_STATE_LOGGING_OUT		7
 
 struct iscsi_cls_session {
 	struct list_head sess_list;		/* item in session_list */
-- 
1.5.1.2

