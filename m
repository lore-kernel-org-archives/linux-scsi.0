From: michaelc@cs.wisc.edu
Subject: [PATCH 12/13] libiscsi: add task aborted state
Date: Wed, 13 May 2009 17:57:49 -0500
Message-ID: <12422554763029-git-send-email-michaelc@cs.wisc.edu>
References: <12422554702856-git-send-email-michaelc@cs.wisc.edu>
 <12422554711659-git-send-email-michaelc@cs.wisc.edu>
 <12422554711865-git-send-email-michaelc@cs.wisc.edu>
 <1242255472240-git-send-email-michaelc@cs.wisc.edu>
 <12422554724154-git-send-email-michaelc@cs.wisc.edu>
 <12422554733484-git-send-email-michaelc@cs.wisc.edu>
 <12422554731307-git-send-email-michaelc@cs.wisc.edu>
 <12422554742374-git-send-email-michaelc@cs.wisc.edu>
 <12422554743206-git-send-email-michaelc@cs.wisc.edu>
 <12422554752623-git-send-email-michaelc@cs.wisc.edu>
 <12422554753201-git-send-email-michaelc@cs.wisc.edu>
 <12422554764013-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51876 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761210AbZEMW56 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 18:57:58 -0400
In-Reply-To: <12422554764013-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If a task did not complete normally due to a TMF, libiscsi will
now complete the task with the state ISCSI_TASK_ABRT_TMF. Drivers
like bnx2i that need to free resources if a command did not complete normally
can then check the task state. If a driver does not need to send
a special command if we have dropped the session then they can check
for ISCSI_TASK_ABRT_SESS_RECOV.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    7 +--
 drivers/scsi/libiscsi.c                  |   60 +++++++++++++++++------------
 drivers/scsi/libiscsi_tcp.c              |    4 +-
 include/scsi/libiscsi.h                  |    2 +
 4 files changed, 41 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index ffbe0c7..0ba6ec8 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -257,11 +257,8 @@ static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
 
-	/*
-	 * mgmt tasks do not need special cleanup and we do not
-	 * allocate anything in the init task callout
-	 */
-	if (!task->sc || task->state == ISCSI_TASK_PENDING)
+	/* mgmt tasks do not need special cleanup */
+	if (!task->sc)
 		return;
 
 	if (iser_task->status == ISER_TASK_STATUS_STARTED) {
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index dafa054..b00be6c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -443,18 +443,20 @@ EXPORT_SYMBOL_GPL(iscsi_put_task);
 /**
  * iscsi_complete_task - finish a task
  * @task: iscsi cmd task
+ * @state: state to complete task with
  *
  * Must be called with session lock.
  */
-static void iscsi_complete_task(struct iscsi_task *task)
+static void iscsi_complete_task(struct iscsi_task *task, int state)
 {
 	struct iscsi_conn *conn = task->conn;
 
-	if (task->state == ISCSI_TASK_COMPLETED)
+	if (task->state == ISCSI_TASK_COMPLETED ||
+	    task->state == ISCSI_TASK_ABRT_TMF ||
+	    task->state == ISCSI_TASK_ABRT_SESS_RECOV)
 		return;
 	WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
-
-	task->state = ISCSI_TASK_COMPLETED;
+	task->state = state;
 
 	if (!list_empty(&task->running))
 		list_del_init(&task->running);
@@ -478,6 +480,7 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 {
 	struct iscsi_conn *conn = task->conn;
 	struct scsi_cmnd *sc;
+	int state;
 
 	/*
 	 * if a command completes and we get a successful tmf response
@@ -488,14 +491,20 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 	if (!sc)
 		return;
 
-	if (task->state == ISCSI_TASK_PENDING)
+	if (task->state == ISCSI_TASK_PENDING) {
 		/*
 		 * cmd never made it to the xmit thread, so we should not count
 		 * the cmd in the sequencing
 		 */
 		conn->session->queued_cmdsn--;
+		/* it was never sent so just complete like normal */
+		state = ISCSI_TASK_COMPLETED;
+	} else if (err == DID_TRANSPORT_DISRUPTED)
+		state = ISCSI_TASK_ABRT_SESS_RECOV;
+	else
+		state = ISCSI_TASK_ABRT_TMF;
 
-	sc->result = err;
+	sc->result = err << 16;
 	if (!scsi_bidi_cmnd(sc))
 		scsi_set_resid(sc, scsi_bufflen(sc));
 	else {
@@ -503,7 +512,7 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 		scsi_in(sc)->resid = scsi_in(sc)->length;
 	}
 
-	iscsi_complete_task(task);
+	iscsi_complete_task(task, state);
 }
 
 static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
@@ -731,7 +740,7 @@ out:
 	ISCSI_DBG_SESSION(session, "cmd rsp done [sc %p res %d itt 0x%x]\n",
 			  sc, sc->result, task->itt);
 	conn->scsirsp_pdus_cnt++;
-	iscsi_complete_task(task);
+	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
 }
 
 /**
@@ -769,7 +778,7 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			  "[sc %p res %d itt 0x%x]\n",
 			  sc, sc->result, task->itt);
 	conn->scsirsp_pdus_cnt++;
-	iscsi_complete_task(task);
+	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
 }
 
 static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
@@ -990,7 +999,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		}
 
 		iscsi_tmf_rsp(conn, hdr);
-		iscsi_complete_task(task);
+		iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
 		break;
 	case ISCSI_OP_NOOP_IN:
 		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
@@ -1008,7 +1017,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			goto recv_pdu;
 
 		mod_timer(&conn->transport_timer, jiffies + conn->recv_timeout);
-		iscsi_complete_task(task);
+		iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
 		break;
 	default:
 		rc = ISCSI_ERR_BAD_OPCODE;
@@ -1020,7 +1029,7 @@ out:
 recv_pdu:
 	if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
 		rc = ISCSI_ERR_CONN_FAILED;
-	iscsi_complete_task(task);
+	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(__iscsi_complete_pdu);
@@ -1262,7 +1271,7 @@ check_mgmt:
 					 struct iscsi_task, running);
 		list_del_init(&conn->task->running);
 		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
-			fail_scsi_task(conn->task, DID_IMM_RETRY << 16);
+			fail_scsi_task(conn->task, DID_IMM_RETRY);
 			continue;
 		}
 		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
@@ -1273,7 +1282,7 @@ check_mgmt:
 				conn->task = NULL;
 				goto again;
 			} else
-				fail_scsi_task(conn->task, DID_ABORT << 16);
+				fail_scsi_task(conn->task, DID_ABORT);
 			continue;
 		}
 		rc = iscsi_xmit_task(conn);
@@ -1469,7 +1478,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 
 prepd_reject:
 	sc->scsi_done = NULL;
-	iscsi_complete_task(task);
+	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
 reject:
 	spin_unlock(&session->lock);
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
@@ -1479,7 +1488,7 @@ reject:
 
 prepd_fault:
 	sc->scsi_done = NULL;
-	iscsi_complete_task(task);
+	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
 fault:
 	spin_unlock(&session->lock);
 	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
@@ -1665,7 +1674,7 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, unsigned lun,
 		ISCSI_DBG_SESSION(conn->session,
 				  "failing sc %p itt 0x%x state %d\n",
 				  task->sc, task->itt, task->state);
-		fail_scsi_task(task, error << 16);
+		fail_scsi_task(task, error);
 	}
 }
 
@@ -1868,7 +1877,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	}
 
 	if (task->state == ISCSI_TASK_PENDING) {
-		fail_scsi_task(task, DID_ABORT << 16);
+		fail_scsi_task(task, DID_ABORT);
 		goto success;
 	}
 
@@ -1899,7 +1908,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		 * then sent more data for the cmd.
 		 */
 		spin_lock(&session->lock);
-		fail_scsi_task(task, DID_ABORT << 16);
+		fail_scsi_task(task, DID_ABORT);
 		conn->tmf_state = TMF_INITIAL;
 		spin_unlock(&session->lock);
 		iscsi_start_tx(conn);
@@ -2572,7 +2581,7 @@ static void
 fail_mgmt_tasks(struct iscsi_session *session, struct iscsi_conn *conn)
 {
 	struct iscsi_task *task;
-	int i;
+	int i, state;
 
 	for (i = 0; i < conn->session->cmds_max; i++) {
 		task = conn->session->cmds[i];
@@ -2585,7 +2594,11 @@ fail_mgmt_tasks(struct iscsi_session *session, struct iscsi_conn *conn)
 		ISCSI_DBG_SESSION(conn->session,
 				  "failing mgmt itt 0x%x state %d\n",
 				  task->itt, task->state);
-		iscsi_complete_task(task);
+		state = ISCSI_TASK_ABRT_SESS_RECOV;
+		if (task->state == ISCSI_TASK_PENDING)
+			state = ISCSI_TASK_COMPLETED;
+		iscsi_complete_task(task, state);
+
 	}
 }
 
@@ -2642,10 +2655,7 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 	 * flush queues.
 	 */
 	spin_lock_bh(&session->lock);
-	if (flag == STOP_CONN_RECOVER)
-		fail_scsi_tasks(conn, -1, DID_TRANSPORT_DISRUPTED);
-	else
-		fail_scsi_tasks(conn, -1, DID_ERROR);
+	fail_scsi_tasks(conn, -1, DID_TRANSPORT_DISRUPTED);
 	fail_mgmt_tasks(session, conn);
 	spin_unlock_bh(&session->lock);
 	mutex_unlock(&session->eh_mutex);
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index b84a1d8..2bc0709 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -440,8 +440,8 @@ void iscsi_tcp_cleanup_task(struct iscsi_task *task)
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct iscsi_r2t_info *r2t;
 
-	/* nothing to do for mgmt or pending tasks */
-	if (!task->sc || task->state == ISCSI_TASK_PENDING)
+	/* nothing to do for mgmt */
+	if (!task->sc)
 		return;
 
 	/* flush task's r2t queues */
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index facae71..196525c 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -86,6 +86,8 @@ enum {
 	ISCSI_TASK_COMPLETED,
 	ISCSI_TASK_PENDING,
 	ISCSI_TASK_RUNNING,
+	ISCSI_TASK_ABRT_TMF,		/* aborted due to TMF */
+	ISCSI_TASK_ABRT_SESS_RECOV,	/* aborted due to session recovery */
 };
 
 struct iscsi_r2t_info {
-- 
1.5.2.1

