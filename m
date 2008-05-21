From: michaelc@cs.wisc.edu
Subject: [PATCH 10/25] libiscsi: modify libiscsi so it supports offloaded data paths
Date: Wed, 21 May 2008 15:54:05 -0500
Message-ID: <1211403260-5487-11-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-10-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936396AbYEUUya (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:30 -0400
In-Reply-To: <1211403260-5487-10-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch modifies libiscsi, so drivers like bnx2i and iser can execute
a command from queuecommand/send_pdu instead of having to be queued to
be run in a workq.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |  179 +++++++++++++++++++++++++++--------------------
 1 files changed, 104 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4bc63c4..1e605de 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -79,9 +79,11 @@ iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
 		 * xmit thread
 		 */
 		if (!list_empty(&session->leadconn->xmitqueue) ||
-		    !list_empty(&session->leadconn->mgmtqueue))
-			scsi_queue_work(session->host,
-					&session->leadconn->xmitwork);
+		    !list_empty(&session->leadconn->mgmtqueue)) {
+			if (!(session->tt->caps & CAP_DATA_PATH_OFFLOAD))
+				scsi_queue_work(session->host,
+						&session->leadconn->xmitwork);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(iscsi_update_cmdsn);
@@ -298,8 +300,12 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	WARN_ON(hdrlength >= 256);
 	hdr->hlength = hdrlength & 0xFF;
 
-	if (conn->session->tt->init_cmd_task(conn->ctask))
-		return EIO;
+	if (conn->session->tt->init_cmd_task &&
+	    conn->session->tt->init_cmd_task(ctask))
+		return -EIO;
+
+	ctask->state = ISCSI_TASK_RUNNING;
+	list_move_tail(&ctask->running, &conn->run_list);
 
 	conn->scsicmd_pdus_cnt++;
 	debug_scsi("iscsi prep [%s cid %d sc %p cdb 0x%x itt 0x%x "
@@ -334,7 +340,9 @@ static void iscsi_complete_command(struct iscsi_cmd_task *ctask)
 		conn->ctask = NULL;
 	list_del_init(&ctask->running);
 	__kfifo_put(session->cmdpool.queue, (void*)&ctask, sizeof(void*));
-	sc->scsi_done(sc);
+
+	if (sc->scsi_done)
+		sc->scsi_done(sc);
 }
 
 static void __iscsi_get_ctask(struct iscsi_cmd_task *ctask)
@@ -403,6 +411,50 @@ void iscsi_free_mgmt_task(struct iscsi_conn *conn,
 }
 EXPORT_SYMBOL_GPL(iscsi_free_mgmt_task);
 
+static int iscsi_prep_mtask(struct iscsi_conn *conn,
+			    struct iscsi_mgmt_task *mtask)
+{
+	struct iscsi_session *session = conn->session;
+	struct iscsi_hdr *hdr = mtask->hdr;
+	struct iscsi_nopout *nop = (struct iscsi_nopout *)hdr;
+
+	if (conn->session->state == ISCSI_STATE_LOGGING_OUT)
+		return -ENOTCONN;
+
+	if (hdr->opcode != (ISCSI_OP_LOGIN | ISCSI_OP_IMMEDIATE) &&
+	    hdr->opcode != (ISCSI_OP_TEXT | ISCSI_OP_IMMEDIATE))
+		nop->exp_statsn = cpu_to_be32(conn->exp_statsn);
+	/*
+	 * pre-format CmdSN for outgoing PDU.
+	 */
+	nop->cmdsn = cpu_to_be32(session->cmdsn);
+	if (hdr->itt != RESERVED_ITT) {
+		hdr->itt = build_itt(mtask->itt, session->age);
+		/*
+		 * TODO: We always use immediate, so we never hit this.
+		 * If we start to send tmfs or nops as non-immediate then
+		 * we should start checking the cmdsn numbers for mgmt tasks.
+		 */
+		if (conn->c_stage == ISCSI_CONN_STARTED &&
+		    !(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
+			session->queued_cmdsn++;
+			session->cmdsn++;
+		}
+	}
+
+	if (session->tt->init_mgmt_task)
+		session->tt->init_mgmt_task(conn, mtask);
+
+	if ((hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGOUT)
+		session->state = ISCSI_STATE_LOGGING_OUT;
+
+	list_move_tail(&mtask->running, &conn->mgmt_run_list);
+	debug_scsi("mgmtpdu [op 0x%x hdr->itt 0x%x datalen %d]\n",
+		   hdr->opcode & ISCSI_OPCODE_MASK, hdr->itt,
+		   mtask->data_count);
+	return 0;
+}
+
 static struct iscsi_mgmt_task *
 __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		      char *data, uint32_t data_size)
@@ -429,6 +481,12 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		if (!__kfifo_get(session->mgmtpool.queue,
 				 (void*)&mtask, sizeof(void*)))
 			return NULL;
+
+		if ((hdr->opcode == (ISCSI_OP_NOOP_OUT | ISCSI_OP_IMMEDIATE)) &&
+		     hdr->ttt == RESERVED_ITT) {
+			conn->ping_mtask = mtask;
+			conn->last_ping = jiffies;
+		}
 	}
 
 	if (data_size) {
@@ -440,6 +498,19 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	memcpy(mtask->hdr, hdr, sizeof(struct iscsi_hdr));
 	INIT_LIST_HEAD(&mtask->running);
 	list_add_tail(&mtask->running, &conn->mgmtqueue);
+
+	if (session->tt->caps & CAP_DATA_PATH_OFFLOAD) {
+		if (iscsi_prep_mtask(conn, mtask)) {
+			iscsi_free_mgmt_task(conn, mtask);
+			return NULL;
+		}
+
+		if (session->tt->xmit_mgmt_task(conn, mtask))
+			mtask = NULL;
+
+	} else
+		scsi_queue_work(conn->session->host, &conn->xmitwork);
+
 	return mtask;
 }
 
@@ -454,7 +525,6 @@ int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
 	if (!__iscsi_conn_send_pdu(conn, hdr, data, data_size))
 		err = -EPERM;
 	spin_unlock_bh(&session->lock);
-	scsi_queue_work(session->host, &conn->xmitwork);
 	return err;
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_send_pdu);
@@ -581,17 +651,8 @@ static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 		hdr.ttt = RESERVED_ITT;
 
 	mtask = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
-	if (!mtask) {
+	if (!mtask)
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
-		return;
-	}
-
-	/* only track our nops */
-	if (!rhdr) {
-		conn->ping_mtask = mtask;
-		conn->last_ping = jiffies;
-	}
-	scsi_queue_work(conn->session->host, &conn->xmitwork);
 }
 
 static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
@@ -868,56 +929,15 @@ void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_failure);
 
-static void iscsi_prep_mtask(struct iscsi_conn *conn,
-			     struct iscsi_mgmt_task *mtask)
-{
-	struct iscsi_session *session = conn->session;
-	struct iscsi_hdr *hdr = mtask->hdr;
-	struct iscsi_nopout *nop = (struct iscsi_nopout *)hdr;
-
-	if (hdr->opcode != (ISCSI_OP_LOGIN | ISCSI_OP_IMMEDIATE) &&
-	    hdr->opcode != (ISCSI_OP_TEXT | ISCSI_OP_IMMEDIATE))
-		nop->exp_statsn = cpu_to_be32(conn->exp_statsn);
-	/*
-	 * pre-format CmdSN for outgoing PDU.
-	 */
-	nop->cmdsn = cpu_to_be32(session->cmdsn);
-	if (hdr->itt != RESERVED_ITT) {
-		hdr->itt = build_itt(mtask->itt, session->age);
-		/*
-		 * TODO: We always use immediate, so we never hit this.
-		 * If we start to send tmfs or nops as non-immediate then
-		 * we should start checking the cmdsn numbers for mgmt tasks.
-		 */
-		if (conn->c_stage == ISCSI_CONN_STARTED &&
-		    !(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
-			session->queued_cmdsn++;
-			session->cmdsn++;
-		}
-	}
-
-	if (session->tt->init_mgmt_task)
-		session->tt->init_mgmt_task(conn, mtask);
-
-	debug_scsi("mgmtpdu [op 0x%x hdr->itt 0x%x datalen %d]\n",
-		   hdr->opcode & ISCSI_OPCODE_MASK, hdr->itt,
-		   mtask->data_count);
-}
-
 static int iscsi_xmit_mtask(struct iscsi_conn *conn)
 {
-	struct iscsi_hdr *hdr = conn->mtask->hdr;
 	int rc;
 
-	if ((hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGOUT)
-		conn->session->state = ISCSI_STATE_LOGGING_OUT;
 	spin_unlock_bh(&conn->session->lock);
-
 	rc = conn->session->tt->xmit_mgmt_task(conn, conn->mtask);
 	spin_lock_bh(&conn->session->lock);
 	if (rc)
 		return rc;
-
 	/* done with this in-progress mtask */
 	conn->mtask = NULL;
 	return 0;
@@ -961,7 +981,8 @@ static int iscsi_xmit_ctask(struct iscsi_conn *conn)
  * @ctask: ctask to requeue
  *
  * LLDs that need to run a ctask from the session workqueue should call
- * this. The session lock must be held.
+ * this. The session lock must be held. This should only be called
+ * by software drivers.
  */
 void iscsi_requeue_ctask(struct iscsi_cmd_task *ctask)
 {
@@ -1013,14 +1034,11 @@ check_mgmt:
 	while (!list_empty(&conn->mgmtqueue)) {
 		conn->mtask = list_entry(conn->mgmtqueue.next,
 					 struct iscsi_mgmt_task, running);
-		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
+		if (iscsi_prep_mtask(conn, conn->mtask)) {
 			iscsi_free_mgmt_task(conn, conn->mtask);
 			conn->mtask = NULL;
 			continue;
 		}
-
-		iscsi_prep_mtask(conn, conn->mtask);
-		list_move_tail(conn->mgmtqueue.next, &conn->mgmt_run_list);
 		rc = iscsi_xmit_mtask(conn);
 		if (rc)
 			goto again;
@@ -1041,9 +1059,6 @@ check_mgmt:
 			fail_command(conn, conn->ctask, DID_ABORT << 16);
 			continue;
 		}
-
-		conn->ctask->state = ISCSI_TASK_RUNNING;
-		list_move_tail(conn->xmitqueue.next, &conn->run_list);
 		rc = iscsi_xmit_ctask(conn);
 		if (rc)
 			goto again;
@@ -1192,8 +1207,6 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		reason = FAILURE_OOM;
 		goto reject;
 	}
-	session->queued_cmdsn++;
-
 	sc->SCp.phase = session->age;
 	sc->SCp.ptr = (char *)ctask;
 
@@ -1202,11 +1215,26 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	ctask->conn = conn;
 	ctask->sc = sc;
 	INIT_LIST_HEAD(&ctask->running);
-
 	list_add_tail(&ctask->running, &conn->xmitqueue);
-	spin_unlock(&session->lock);
 
-	scsi_queue_work(host, &conn->xmitwork);
+	if (session->tt->caps & CAP_DATA_PATH_OFFLOAD) {
+		if (iscsi_prep_scsi_cmd_pdu(ctask)) {
+			sc->result = DID_ABORT << 16;
+			sc->scsi_done = NULL;
+			iscsi_complete_command(ctask);
+			goto fault;
+		}
+		if (session->tt->xmit_cmd_task(conn, ctask)) {
+			sc->scsi_done = NULL;
+			iscsi_complete_command(ctask);
+			reason = FAILURE_SESSION_NOT_READY;
+			goto reject;
+		}
+	} else
+		scsi_queue_work(session->host, &conn->xmitwork);
+
+	session->queued_cmdsn++;
+	spin_unlock(&session->lock);
 	spin_lock(host->host_lock);
 	return 0;
 
@@ -1225,7 +1253,7 @@ fault:
 		scsi_out(sc)->resid = scsi_out(sc)->length;
 		scsi_in(sc)->resid = scsi_in(sc)->length;
 	}
-	sc->scsi_done(sc);
+	done(sc);
 	spin_lock(host->host_lock);
 	return 0;
 }
@@ -1344,7 +1372,6 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 
 	spin_unlock_bh(&session->lock);
 	mutex_unlock(&session->eh_mutex);
-	scsi_queue_work(session->host, &conn->xmitwork);
 
 	/*
 	 * block eh thread until:
@@ -1412,14 +1439,16 @@ static void fail_all_commands(struct iscsi_conn *conn, unsigned lun,
 void iscsi_suspend_tx(struct iscsi_conn *conn)
 {
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-	scsi_flush_work(conn->session->host);
+	if (!(conn->session->tt->caps & CAP_DATA_PATH_OFFLOAD))
+		scsi_flush_work(conn->session->host);
 }
 EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 
 static void iscsi_start_tx(struct iscsi_conn *conn)
 {
 	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-	scsi_queue_work(conn->session->host, &conn->xmitwork);
+	if (!(conn->session->tt->caps & CAP_DATA_PATH_OFFLOAD))
+		scsi_queue_work(conn->session->host, &conn->xmitwork);
 }
 
 static enum scsi_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *scmd)
-- 
1.5.4.1

