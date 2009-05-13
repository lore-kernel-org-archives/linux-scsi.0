From: michaelc@cs.wisc.edu
Subject: [PATCH 09/13] libiscsi: handle cleanup task races
Date: Wed, 13 May 2009 17:57:46 -0500
Message-ID: <12422554752623-git-send-email-michaelc@cs.wisc.edu>
References: <12422554702856-git-send-email-michaelc@cs.wisc.edu>
 <12422554711659-git-send-email-michaelc@cs.wisc.edu>
 <12422554711865-git-send-email-michaelc@cs.wisc.edu>
 <1242255472240-git-send-email-michaelc@cs.wisc.edu>
 <12422554724154-git-send-email-michaelc@cs.wisc.edu>
 <12422554733484-git-send-email-michaelc@cs.wisc.edu>
 <12422554731307-git-send-email-michaelc@cs.wisc.edu>
 <12422554742374-git-send-email-michaelc@cs.wisc.edu>
 <12422554743206-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51861 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762121AbZEMW55 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 18:57:57 -0400
In-Reply-To: <12422554743206-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

bnx2i needs to send a hardware specific cleanup command if
a command has not completed normally (iscsi/scsi response from
target), and the session is still ok (this is the case when we
send a TMF to stop the command).

At this time it will need to drop the session lock. The problem
with the current code is that fail_all_commands assumes we
will hold the lock the entire time, so it uses list_for_each_entry_safe.
If while bnx2i drops the session lock multiple cmds complete then
list_for_each_entry_safe will not handle this correctly.

This patch removes the running lists and just has us loop over
the cmds array (in later patches we will then replace that
array with a block tag map at the session level). It also fixes
up the completion path so that if the TMF code and the normal recv
path were completing the same command then they both do not try
to do release the refcount taken when the task is queued.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |  225 ++++++++++++++++++++++++-----------------------
 include/scsi/libiscsi.h |    5 +-
 2 files changed, 118 insertions(+), 112 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c648bd3..a9d7e52 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -109,7 +109,7 @@ iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
 		 * if the window closed with IO queued, then kick the
 		 * xmit thread
 		 */
-		if (!list_empty(&session->leadconn->xmitqueue) ||
+		if (!list_empty(&session->leadconn->cmdqueue) ||
 		    !list_empty(&session->leadconn->mgmtqueue)) {
 			if (!(session->tt->caps & CAP_DATA_PATH_OFFLOAD))
 				iscsi_conn_queue_work(session->leadconn);
@@ -366,7 +366,6 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 		return -EIO;
 
 	task->state = ISCSI_TASK_RUNNING;
-	list_move_tail(&task->running, &conn->run_list);
 
 	conn->scsicmd_pdus_cnt++;
 	ISCSI_DBG_SESSION(session, "iscsi prep [%s cid %d sc %p cdb 0x%x "
@@ -382,26 +381,23 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 }
 
 /**
- * iscsi_complete_command - finish a task
+ * iscsi_free_task - free a task
  * @task: iscsi cmd task
  *
  * Must be called with session lock.
  * This function returns the scsi command to scsi-ml or cleans
  * up mgmt tasks then returns the task to the pool.
  */
-static void iscsi_complete_command(struct iscsi_task *task)
+static void iscsi_free_task(struct iscsi_task *task)
 {
 	struct iscsi_conn *conn = task->conn;
 	struct iscsi_session *session = conn->session;
 	struct scsi_cmnd *sc = task->sc;
 
 	session->tt->cleanup_task(task);
-	list_del_init(&task->running);
-	task->state = ISCSI_TASK_COMPLETED;
+	task->state = ISCSI_TASK_FREE;
 	task->sc = NULL;
 
-	if (conn->task == task)
-		conn->task = NULL;
 	/*
 	 * login task is preallocated so do not free
 	 */
@@ -410,9 +406,6 @@ static void iscsi_complete_command(struct iscsi_task *task)
 
 	__kfifo_put(session->cmdpool.queue, (void*)&task, sizeof(void*));
 
-	if (conn->ping_task == task)
-		conn->ping_task = NULL;
-
 	if (sc) {
 		task->sc = NULL;
 		/* SCSI eh reuses commands to verify us */
@@ -435,7 +428,7 @@ EXPORT_SYMBOL_GPL(__iscsi_get_task);
 static void __iscsi_put_task(struct iscsi_task *task)
 {
 	if (atomic_dec_and_test(&task->refcount))
-		iscsi_complete_command(task);
+		iscsi_free_task(task);
 }
 
 void iscsi_put_task(struct iscsi_task *task)
@@ -448,14 +441,50 @@ void iscsi_put_task(struct iscsi_task *task)
 }
 EXPORT_SYMBOL_GPL(iscsi_put_task);
 
+/**
+ * iscsi_complete_task - finish a task
+ * @task: iscsi cmd task
+ *
+ * Must be called with session lock.
+ */
+static void iscsi_complete_task(struct iscsi_task *task)
+{
+	struct iscsi_conn *conn = task->conn;
+
+	if (task->state == ISCSI_TASK_COMPLETED)
+		return;
+	WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
+
+	task->state = ISCSI_TASK_COMPLETED;
+
+	if (!list_empty(&task->running))
+		list_del_init(&task->running);
+
+	if (conn->task == task)
+		conn->task = NULL;
+
+	if (conn->ping_task == task)
+		conn->ping_task = NULL;
+
+	/* release get from queueing */
+	__iscsi_put_task(task);
+}
+
 /*
- * session lock must be held
+ * session lock must be held and if not called for a task that is
+ * still pending or from the xmit thread, then xmit thread must
+ * be suspended.
  */
-static void fail_command(struct iscsi_conn *conn, struct iscsi_task *task,
-			 int err)
+static void fail_scsi_task(struct iscsi_task *task, int err)
 {
+	struct iscsi_conn *conn = task->conn;
 	struct scsi_cmnd *sc;
 
+	/*
+	 * if a command completes and we get a successful tmf response
+	 * we will hit this because the scsi eh abort code does not take
+	 * a ref to the task.
+	 */
 	sc = task->sc;
 	if (!sc)
 		return;
@@ -475,10 +504,7 @@ static void fail_command(struct iscsi_conn *conn, struct iscsi_task *task,
 		scsi_in(sc)->resid = scsi_in(sc)->length;
 	}
 
-	if (conn->task == task)
-		conn->task = NULL;
-	/* release ref from queuecommand */
-	__iscsi_put_task(task);
+	iscsi_complete_task(task);
 }
 
 static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
@@ -518,7 +544,6 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 		session->state = ISCSI_STATE_LOGGING_OUT;
 
 	task->state = ISCSI_TASK_RUNNING;
-	list_move_tail(&task->running, &conn->mgmt_run_list);
 	ISCSI_DBG_SESSION(session, "mgmtpdu [op 0x%x hdr->itt 0x%x "
 			  "datalen %d]\n", hdr->opcode & ISCSI_OPCODE_MASK,
 			  hdr->itt, task->data_count);
@@ -564,6 +589,8 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	atomic_set(&task->refcount, 1);
 	task->conn = conn;
 	task->sc = NULL;
+	INIT_LIST_HEAD(&task->running);
+	task->state = ISCSI_TASK_PENDING;
 
 	if (data_size) {
 		memcpy(task->data, data, data_size);
@@ -575,7 +602,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		if (conn->session->tt->alloc_pdu(task, hdr->opcode)) {
 			iscsi_conn_printk(KERN_ERR, conn, "Could not allocate "
 					 "pdu for mgmt task.\n");
-			goto requeue_task;
+			goto free_task;
 		}
 	}
 
@@ -591,30 +618,22 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 						   task->conn->session->age);
 	}
 
-	INIT_LIST_HEAD(&task->running);
-	list_add_tail(&task->running, &conn->mgmtqueue);
-
 	if (session->tt->caps & CAP_DATA_PATH_OFFLOAD) {
 		if (iscsi_prep_mgmt_task(conn, task))
 			goto free_task;
 
 		if (session->tt->xmit_task(task))
 			goto free_task;
-
-	} else
+	} else {
+		list_add_tail(&task->running, &conn->mgmtqueue);
 		iscsi_conn_queue_work(conn);
+	}
 
 	return task;
 
 free_task:
 	__iscsi_put_task(task);
 	return NULL;
-
-requeue_task:
-	if (task != conn->login_task)
-		__kfifo_put(session->cmdpool.queue, (void*)&task,
-			    sizeof(void*));
-	return NULL;
 }
 
 int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
@@ -709,11 +728,10 @@ invalid_datalen:
 			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
 	}
 out:
-	ISCSI_DBG_SESSION(session, "done [sc %p res %d itt 0x%x]\n",
+	ISCSI_DBG_SESSION(session, "cmd rsp done [sc %p res %d itt 0x%x]\n",
 			  sc, sc->result, task->itt);
 	conn->scsirsp_pdus_cnt++;
-
-	__iscsi_put_task(task);
+	iscsi_complete_task(task);
 }
 
 /**
@@ -747,8 +765,11 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
 	}
 
+	ISCSI_DBG_SESSION(conn->session, "data in with status done "
+			  "[sc %p res %d itt 0x%x]\n",
+			  sc, sc->result, task->itt);
 	conn->scsirsp_pdus_cnt++;
-	__iscsi_put_task(task);
+	iscsi_complete_task(task);
 }
 
 static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
@@ -969,7 +990,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		}
 
 		iscsi_tmf_rsp(conn, hdr);
-		__iscsi_put_task(task);
+		iscsi_complete_task(task);
 		break;
 	case ISCSI_OP_NOOP_IN:
 		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
@@ -987,7 +1008,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			goto recv_pdu;
 
 		mod_timer(&conn->transport_timer, jiffies + conn->recv_timeout);
-		__iscsi_put_task(task);
+		iscsi_complete_task(task);
 		break;
 	default:
 		rc = ISCSI_ERR_BAD_OPCODE;
@@ -999,7 +1020,7 @@ out:
 recv_pdu:
 	if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
 		rc = ISCSI_ERR_CONN_FAILED;
-	__iscsi_put_task(task);
+	iscsi_complete_task(task);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(__iscsi_complete_pdu);
@@ -1176,7 +1197,12 @@ void iscsi_requeue_task(struct iscsi_task *task)
 {
 	struct iscsi_conn *conn = task->conn;
 
-	list_move_tail(&task->running, &conn->requeue);
+	/*
+	 * this may be on the requeue list already if the xmit_task callout
+	 * is handling the r2ts while we are adding new ones
+	 */
+	if (list_empty(&task->running))
+		list_add_tail(&task->running, &conn->requeue);
 	iscsi_conn_queue_work(conn);
 }
 EXPORT_SYMBOL_GPL(iscsi_requeue_task);
@@ -1216,6 +1242,7 @@ check_mgmt:
 	while (!list_empty(&conn->mgmtqueue)) {
 		conn->task = list_entry(conn->mgmtqueue.next,
 					 struct iscsi_task, running);
+		list_del_init(&conn->task->running);
 		if (iscsi_prep_mgmt_task(conn, conn->task)) {
 			__iscsi_put_task(conn->task);
 			conn->task = NULL;
@@ -1227,23 +1254,26 @@ check_mgmt:
 	}
 
 	/* process pending command queue */
-	while (!list_empty(&conn->xmitqueue)) {
+	while (!list_empty(&conn->cmdqueue)) {
 		if (conn->tmf_state == TMF_QUEUED)
 			break;
 
-		conn->task = list_entry(conn->xmitqueue.next,
+		conn->task = list_entry(conn->cmdqueue.next,
 					 struct iscsi_task, running);
+		list_del_init(&conn->task->running);
 		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
-			fail_command(conn, conn->task, DID_IMM_RETRY << 16);
+			fail_scsi_task(conn->task, DID_IMM_RETRY << 16);
 			continue;
 		}
 		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
 		if (rc) {
 			if (rc == -ENOMEM) {
+				list_add_tail(&conn->task->running,
+					      &conn->cmdqueue);
 				conn->task = NULL;
 				goto again;
 			} else
-				fail_command(conn, conn->task, DID_ABORT << 16);
+				fail_scsi_task(conn->task, DID_ABORT << 16);
 			continue;
 		}
 		rc = iscsi_xmit_task(conn);
@@ -1270,8 +1300,8 @@ check_mgmt:
 
 		conn->task = list_entry(conn->requeue.next,
 					 struct iscsi_task, running);
+		list_del_init(&conn->task->running);
 		conn->task->state = ISCSI_TASK_RUNNING;
-		list_move_tail(conn->requeue.next, &conn->run_list);
 		rc = iscsi_xmit_task(conn);
 		if (rc)
 			goto again;
@@ -1412,7 +1442,6 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		reason = FAILURE_OOM;
 		goto reject;
 	}
-	list_add_tail(&task->running, &conn->xmitqueue);
 
 	if (session->tt->caps & CAP_DATA_PATH_OFFLOAD) {
 		reason = iscsi_prep_scsi_cmd_pdu(task);
@@ -1429,8 +1458,10 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 			reason = FAILURE_SESSION_NOT_READY;
 			goto prepd_reject;
 		}
-	} else
+	} else {
+		list_add_tail(&task->running, &conn->cmdqueue);
 		iscsi_conn_queue_work(conn);
+	}
 
 	session->queued_cmdsn++;
 	spin_unlock(&session->lock);
@@ -1439,7 +1470,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 
 prepd_reject:
 	sc->scsi_done = NULL;
-	iscsi_complete_command(task);
+	iscsi_complete_task(task);
 reject:
 	spin_unlock(&session->lock);
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
@@ -1449,7 +1480,7 @@ reject:
 
 prepd_fault:
 	sc->scsi_done = NULL;
-	iscsi_complete_command(task);
+	iscsi_complete_task(task);
 fault:
 	spin_unlock(&session->lock);
 	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
@@ -1618,44 +1649,24 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
  * Fail commands. session lock held and recv side suspended and xmit
  * thread flushed
  */
-static void fail_all_commands(struct iscsi_conn *conn, unsigned lun,
-			      int error)
+static void fail_scsi_tasks(struct iscsi_conn *conn, unsigned lun,
+			    int error)
 {
-	struct iscsi_task *task, *tmp;
-
-	if (conn->task) {
-		if (lun == -1 ||
-		    (conn->task->sc && conn->task->sc->device->lun == lun))
-			conn->task = NULL;
-	}
+	struct iscsi_task *task;
+	int i;
 
-	/* flush pending */
-	list_for_each_entry_safe(task, tmp, &conn->xmitqueue, running) {
-		if (lun == task->sc->device->lun || lun == -1) {
-			ISCSI_DBG_SESSION(conn->session,
-					  "failing pending sc %p itt 0x%x\n",
-					  task->sc, task->itt);
-			fail_command(conn, task, error << 16);
-		}
-	}
+	for (i = 0; i < conn->session->cmds_max; i++) {
+		task = conn->session->cmds[i];
+		if (!task->sc || task->state == ISCSI_TASK_FREE)
+			continue;
 
-	list_for_each_entry_safe(task, tmp, &conn->requeue, running) {
-		if (lun == task->sc->device->lun || lun == -1) {
-			ISCSI_DBG_SESSION(conn->session,
-					  "failing requeued sc %p itt 0x%x\n",
-					  task->sc, task->itt);
-			fail_command(conn, task, error << 16);
-		}
-	}
+		if (lun != -1 && lun != task->sc->device->lun)
+			continue;
 
-	/* fail all other running */
-	list_for_each_entry_safe(task, tmp, &conn->run_list, running) {
-		if (lun == task->sc->device->lun || lun == -1) {
-			ISCSI_DBG_SESSION(conn->session,
-					 "failing in progress sc %p itt 0x%x\n",
-					 task->sc, task->itt);
-			fail_command(conn, task, error << 16);
-		}
+		ISCSI_DBG_SESSION(conn->session,
+				  "failing sc %p itt 0x%x state %d\n",
+				  task->sc, task->itt, task->state);
+		fail_scsi_task(task, error << 16);
 	}
 }
 
@@ -1859,7 +1870,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	}
 
 	if (task->state == ISCSI_TASK_PENDING) {
-		fail_command(conn, task, DID_ABORT << 16);
+		fail_scsi_task(task, DID_ABORT << 16);
 		goto success;
 	}
 
@@ -1890,7 +1901,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		 * then sent more data for the cmd.
 		 */
 		spin_lock(&session->lock);
-		fail_command(conn, task, DID_ABORT << 16);
+		fail_scsi_task(task, DID_ABORT << 16);
 		conn->tmf_state = TMF_INITIAL;
 		spin_unlock(&session->lock);
 		iscsi_start_tx(conn);
@@ -1997,7 +2008,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	iscsi_suspend_tx(conn);
 
 	spin_lock_bh(&session->lock);
-	fail_all_commands(conn, sc->device->lun, DID_ERROR);
+	fail_scsi_tasks(conn, sc->device->lun, DID_ERROR);
 	conn->tmf_state = TMF_INITIAL;
 	spin_unlock_bh(&session->lock);
 
@@ -2304,6 +2315,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 		if (cmd_task_size)
 			task->dd_data = &task[1];
 		task->itt = cmd_i;
+		task->state = ISCSI_TASK_FREE;
 		INIT_LIST_HEAD(&task->running);
 	}
 
@@ -2390,10 +2402,8 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	conn->transport_timer.data = (unsigned long)conn;
 	conn->transport_timer.function = iscsi_check_transport_timeouts;
 
-	INIT_LIST_HEAD(&conn->run_list);
-	INIT_LIST_HEAD(&conn->mgmt_run_list);
 	INIT_LIST_HEAD(&conn->mgmtqueue);
-	INIT_LIST_HEAD(&conn->xmitqueue);
+	INIT_LIST_HEAD(&conn->cmdqueue);
 	INIT_LIST_HEAD(&conn->requeue);
 	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
 
@@ -2561,27 +2571,24 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 EXPORT_SYMBOL_GPL(iscsi_conn_start);
 
 static void
-flush_control_queues(struct iscsi_session *session, struct iscsi_conn *conn)
+fail_mgmt_tasks(struct iscsi_session *session, struct iscsi_conn *conn)
 {
-	struct iscsi_task *task, *tmp;
+	struct iscsi_task *task;
+	int i;
 
-	/* handle pending */
-	list_for_each_entry_safe(task, tmp, &conn->mgmtqueue, running) {
-		ISCSI_DBG_SESSION(session, "flushing pending mgmt task "
-				  "itt 0x%x\n", task->itt);
-		/* release ref from prep task */
-		__iscsi_put_task(task);
-	}
+	for (i = 0; i < conn->session->cmds_max; i++) {
+		task = conn->session->cmds[i];
+		if (task->sc)
+			continue;
 
-	/* handle running */
-	list_for_each_entry_safe(task, tmp, &conn->mgmt_run_list, running) {
-		ISCSI_DBG_SESSION(session, "flushing running mgmt task "
-				  "itt 0x%x\n", task->itt);
-		/* release ref from prep task */
-		__iscsi_put_task(task);
-	}
+		if (task->state == ISCSI_TASK_FREE)
+			continue;
 
-	conn->task = NULL;
+		ISCSI_DBG_SESSION(conn->session,
+				  "failing mgmt itt 0x%x state %d\n",
+				  task->itt, task->state);
+		iscsi_complete_task(task);
+	}
 }
 
 static void iscsi_start_session_recovery(struct iscsi_session *session,
@@ -2638,10 +2645,10 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 	 */
 	spin_lock_bh(&session->lock);
 	if (flag == STOP_CONN_RECOVER)
-		fail_all_commands(conn, -1, DID_TRANSPORT_DISRUPTED);
+		fail_scsi_tasks(conn, -1, DID_TRANSPORT_DISRUPTED);
 	else
-		fail_all_commands(conn, -1, DID_ERROR);
-	flush_control_queues(session, conn);
+		fail_scsi_tasks(conn, -1, DID_ERROR);
+	fail_mgmt_tasks(session, conn);
 	spin_unlock_bh(&session->lock);
 	mutex_unlock(&session->eh_mutex);
 }
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 88d33a4..facae71 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -82,6 +82,7 @@ enum {
 
 
 enum {
+	ISCSI_TASK_FREE,
 	ISCSI_TASK_COMPLETED,
 	ISCSI_TASK_PENDING,
 	ISCSI_TASK_RUNNING,
@@ -181,9 +182,7 @@ struct iscsi_conn {
 
 	/* xmit */
 	struct list_head	mgmtqueue;	/* mgmt (control) xmit queue */
-	struct list_head	mgmt_run_list;	/* list of control tasks */
-	struct list_head	xmitqueue;	/* data-path cmd queue */
-	struct list_head	run_list;	/* list of cmds in progress */
+	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
 	unsigned long		suspend_tx;	/* suspend Tx */
-- 
1.5.2.1

