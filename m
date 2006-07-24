From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/11] iscsi bugfixes: fix r2t handling
Date: Mon, 24 Jul 2006 15:47:15 -0500
Message-ID: <1153774035.1040.33.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:14528 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751440AbWGXUru (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 16:47:50 -0400
Received: from [192.168.0.7] (c-24-118-221-159.hsd1.mn.comcast.net [24.118.221.159])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k6OKlSwc012531
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 15:47:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The iscsi tcp code can pluck multiple rt2s from the tasks's r2tqueue
in the xmit code. This can result in the task being queued on the xmit queue
but gettting completed at the same time.

This patch fixes the above bug by making the fifo a list so
we always remove the entry on the list del.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 88dafdf..ab324d9 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -185,11 +185,19 @@ iscsi_hdr_extract(struct iscsi_tcp_conn 
  * must be called with session lock
  */
 static void
-__iscsi_ctask_cleanup(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
+iscsi_tcp_cleanup_ctask(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
+	struct iscsi_r2t_info *r2t;
 	struct scsi_cmnd *sc;
 
+	/* flush ctask's r2t queues */
+	while (__kfifo_get(tcp_ctask->r2tqueue, (void*)&r2t, sizeof(void*))) {
+		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
+			    sizeof(void*));
+		debug_scsi("iscsi_tcp_cleanup_ctask pending r2t dropped\n");
+	}
+
 	sc = ctask->sc;
 	if (unlikely(!sc))
 		return;
@@ -374,6 +382,7 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, s
 		spin_unlock(&session->lock);
 		return 0;
 	}
+
 	rc = __kfifo_get(tcp_ctask->r2tpool.queue, (void*)&r2t, sizeof(void*));
 	BUG_ON(!rc);
 
@@ -399,7 +408,7 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, s
 	tcp_ctask->exp_r2tsn = r2tsn + 1;
 	tcp_ctask->xmstate |= XMSTATE_SOL_HDR;
 	__kfifo_put(tcp_ctask->r2tqueue, (void*)&r2t, sizeof(void*));
-	__kfifo_put(conn->xmitqueue, (void*)&ctask, sizeof(void*));
+	list_move_tail(&ctask->running, &conn->xmitqueue);
 
 	scsi_queue_work(session->host, &conn->xmitwork);
 	conn->r2t_pdus_cnt++;
@@ -484,7 +493,7 @@ iscsi_tcp_hdr_recv(struct iscsi_conn *co
 			goto copy_hdr;
 
 		spin_lock(&session->lock);
-		__iscsi_ctask_cleanup(conn, tcp_conn->in.ctask);
+		iscsi_tcp_cleanup_ctask(conn, tcp_conn->in.ctask);
 		rc = __iscsi_complete_pdu(conn, hdr, NULL, 0);
 		spin_unlock(&session->lock);
 		break;
@@ -745,10 +754,11 @@ static int iscsi_scsi_data_in(struct isc
 done:
 	/* check for non-exceptional status */
 	if (tcp_conn->in.hdr->flags & ISCSI_FLAG_DATA_STATUS) {
-		debug_scsi("done [sc %lx res %d itt 0x%x]\n",
-			   (long)sc, sc->result, ctask->itt);
+		debug_scsi("done [sc %lx res %d itt 0x%x flags 0x%x]\n",
+			   (long)sc, sc->result, ctask->itt,
+			   tcp_conn->in.hdr->flags);
 		spin_lock(&conn->session->lock);
-		__iscsi_ctask_cleanup(conn, ctask);
+		iscsi_tcp_cleanup_ctask(conn, ctask);
 		__iscsi_complete_pdu(conn, tcp_conn->in.hdr, NULL, 0);
 		spin_unlock(&conn->session->lock);
 	}
@@ -769,7 +779,7 @@ iscsi_data_recv(struct iscsi_conn *conn)
 		break;
 	case ISCSI_OP_SCSI_CMD_RSP:
 		spin_lock(&conn->session->lock);
-		__iscsi_ctask_cleanup(conn, tcp_conn->in.ctask);
+		iscsi_tcp_cleanup_ctask(conn, tcp_conn->in.ctask);
 		spin_unlock(&conn->session->lock);
 	case ISCSI_OP_TEXT_RSP:
 	case ISCSI_OP_LOGIN_RSP:
@@ -1308,7 +1318,7 @@ iscsi_tcp_cmd_init(struct iscsi_cmd_task
 				    ctask->imm_count -
 				    ctask->unsol_count;
 
-		debug_scsi("cmd [itt %x total %d imm %d imm_data %d "
+		debug_scsi("cmd [itt 0x%x total %d imm %d imm_data %d "
 			   "r2t_data %d]\n",
 			   ctask->itt, ctask->total_length, ctask->imm_count,
 			   ctask->unsol_count, tcp_ctask->r2t_data_count);
@@ -1636,7 +1646,7 @@ handle_xmstate_sol_data(struct iscsi_con
 	}
 solicit_again:
 	/*
-	 * send Data-Out whitnin this R2T sequence.
+	 * send Data-Out within this R2T sequence.
 	 */
 	if (!r2t->data_count)
 		goto data_out_done;
@@ -1731,7 +1741,7 @@ handle_xmstate_w_pad(struct iscsi_conn *
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_data_task *dtask = tcp_ctask->dtask;
-	int sent, rc;
+	int sent = 0, rc;
 
 	tcp_ctask->xmstate &= ~XMSTATE_W_PAD;
 	iscsi_buf_init_iov(&tcp_ctask->sendbuf, (char*)&tcp_ctask->pad,
@@ -2002,20 +2012,6 @@ iscsi_tcp_conn_bind(struct iscsi_cls_ses
 }
 
 static void
-iscsi_tcp_cleanup_ctask(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
-{
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	struct iscsi_r2t_info *r2t;
-
-	/* flush ctask's r2t queues */
-	while (__kfifo_get(tcp_ctask->r2tqueue, (void*)&r2t, sizeof(void*)))
-		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
-			    sizeof(void*));
-
-	__iscsi_ctask_cleanup(conn, ctask);
-}
-
-static void
 iscsi_tcp_suspend_conn_rx(struct iscsi_conn *conn)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
@@ -2057,6 +2053,7 @@ iscsi_tcp_mgmt_init(struct iscsi_conn *c
 	iscsi_buf_init_iov(&tcp_mtask->headbuf, (char*)mtask->hdr,
 			   sizeof(struct iscsi_hdr));
 	tcp_mtask->xmstate = XMSTATE_IMM_HDR;
+	tcp_mtask->sent = 0;
 
 	if (mtask->data_count)
 		iscsi_buf_init_iov(&tcp_mtask->sendbuf, (char*)mtask->data,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7e6e031..1a8cd20 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -189,6 +189,7 @@ static void iscsi_complete_command(struc
 {
 	struct scsi_cmnd *sc = ctask->sc;
 
+	ctask->state = ISCSI_TASK_COMPLETED;
 	ctask->sc = NULL;
 	list_del_init(&ctask->running);
 	__kfifo_put(session->cmdpool.queue, (void*)&ctask, sizeof(void*));
@@ -568,20 +569,24 @@ static int iscsi_data_xmit(struct iscsi_
 	}
 
 	/* process command queue */
-	while (__kfifo_get(conn->xmitqueue, (void*)&conn->ctask,
-			   sizeof(void*))) {
+	spin_lock_bh(&conn->session->lock);
+	while (!list_empty(&conn->xmitqueue)) {
 		/*
 		 * iscsi tcp may readd the task to the xmitqueue to send
 		 * write data
 		 */
-		spin_lock_bh(&conn->session->lock);
-		if (list_empty(&conn->ctask->running))
-			list_add_tail(&conn->ctask->running, &conn->run_list);
+		conn->ctask = list_entry(conn->xmitqueue.next,
+					 struct iscsi_cmd_task, running);
+		conn->ctask->state = ISCSI_TASK_RUNNING;
+		list_move_tail(conn->xmitqueue.next, &conn->run_list);
 		spin_unlock_bh(&conn->session->lock);
+
 		rc = tt->xmit_cmd_task(conn, conn->ctask);
 		if (rc)
 			goto again;
+		spin_lock_bh(&conn->session->lock);
 	}
+	spin_unlock_bh(&conn->session->lock);
 	/* done with this ctask */
 	conn->ctask = NULL;
 
@@ -691,6 +696,7 @@ int iscsi_queuecommand(struct scsi_cmnd 
 	sc->SCp.phase = session->age;
 	sc->SCp.ptr = (char *)ctask;
 
+	ctask->state = ISCSI_TASK_PENDING;
 	ctask->mtask = NULL;
 	ctask->conn = conn;
 	ctask->sc = sc;
@@ -700,7 +706,7 @@ int iscsi_queuecommand(struct scsi_cmnd 
 
 	session->tt->init_cmd_task(ctask);
 
-	__kfifo_put(conn->xmitqueue, (void*)&ctask, sizeof(void*));
+	list_add_tail(&ctask->running, &conn->xmitqueue);
 	debug_scsi(
 	       "ctask enq [%s cid %d sc %lx itt 0x%x len %d cmdsn %d win %d]\n",
 		sc->sc_data_direction == DMA_TO_DEVICE ? "write" : "read",
@@ -977,31 +983,27 @@ static int iscsi_exec_abort_task(struct 
 /*
  * xmit mutex and session lock must be held
  */
-#define iscsi_remove_task(tasktype)					\
-static struct iscsi_##tasktype *					\
-iscsi_remove_##tasktype(struct kfifo *fifo, uint32_t itt)		\
-{									\
-	int i, nr_tasks = __kfifo_len(fifo) / sizeof(void*);		\
-	struct iscsi_##tasktype *task;					\
-									\
-	debug_scsi("searching %d tasks\n", nr_tasks);			\
-									\
-	for (i = 0; i < nr_tasks; i++) {				\
-		__kfifo_get(fifo, (void*)&task, sizeof(void*));		\
-		debug_scsi("check task %u\n", task->itt);		\
-									\
-		if (task->itt == itt) {					\
-			debug_scsi("matched task\n");			\
-			return task;					\
-		}							\
-									\
-		__kfifo_put(fifo, (void*)&task, sizeof(void*));		\
-	}								\
-	return NULL;							\
-}
+static struct iscsi_mgmt_task *
+iscsi_remove_mgmt_task(struct kfifo *fifo, uint32_t itt)
+{
+	int i, nr_tasks = __kfifo_len(fifo) / sizeof(void*);
+	struct iscsi_mgmt_task *task;
+
+	debug_scsi("searching %d tasks\n", nr_tasks);
+
+	for (i = 0; i < nr_tasks; i++) {
+		__kfifo_get(fifo, (void*)&task, sizeof(void*));
+		debug_scsi("check task %u\n", task->itt);
+
+		if (task->itt == itt) {
+			debug_scsi("matched task\n");
+			return task;
+		}
 
-iscsi_remove_task(mgmt_task);
-iscsi_remove_task(cmd_task);
+		__kfifo_put(fifo, (void*)&task, sizeof(void*));
+	}
+	return NULL;
+}
 
 static int iscsi_ctask_mtask_cleanup(struct iscsi_cmd_task *ctask)
 {
@@ -1043,7 +1045,6 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	struct iscsi_cmd_task *ctask = (struct iscsi_cmd_task *)sc->SCp.ptr;
 	struct iscsi_conn *conn = ctask->conn;
 	struct iscsi_session *session = conn->session;
-	struct iscsi_cmd_task *pending_ctask;
 	int rc;
 
 	conn->eh_abort_cnt++;
@@ -1071,17 +1072,8 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		goto failed;
 	}
 
-	/* check for the easy pending cmd abort */
-	pending_ctask = iscsi_remove_cmd_task(conn->xmitqueue, ctask->itt);
-	if (pending_ctask) {
-		/* iscsi_tcp queues write transfers on the xmitqueue */
-		if (list_empty(&pending_ctask->running)) {
-			debug_scsi("found pending task\n");
-			goto success;
-		} else
-			__kfifo_put(conn->xmitqueue, (void*)&pending_ctask,
-				    sizeof(void*));
-	}
+	if (ctask->state == ISCSI_TASK_PENDING)
+		goto success;
 
 	conn->tmabort_state = TMABORT_INITIAL;
 
@@ -1263,6 +1255,7 @@ iscsi_session_setup(struct iscsi_transpo
 		if (cmd_task_size)
 			ctask->dd_data = &ctask[1];
 		ctask->itt = cmd_i;
+		INIT_LIST_HEAD(&ctask->running);
 	}
 
 	spin_lock_init(&session->lock);
@@ -1282,6 +1275,7 @@ iscsi_session_setup(struct iscsi_transpo
 		if (mgmt_task_size)
 			mtask->dd_data = &mtask[1];
 		mtask->itt = ISCSI_MGMT_ITT_OFFSET + cmd_i;
+		INIT_LIST_HEAD(&mtask->running);
 	}
 
 	if (scsi_add_host(shost, NULL))
@@ -1361,12 +1355,7 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 	conn->tmabort_state = TMABORT_INITIAL;
 	INIT_LIST_HEAD(&conn->run_list);
 	INIT_LIST_HEAD(&conn->mgmt_run_list);
-
-	/* initialize general xmit PDU commands queue */
-	conn->xmitqueue = kfifo_alloc(session->cmds_max * sizeof(void*),
-					GFP_KERNEL, NULL);
-	if (conn->xmitqueue == ERR_PTR(-ENOMEM))
-		goto xmitqueue_alloc_fail;
+	INIT_LIST_HEAD(&conn->xmitqueue);
 
 	/* initialize general immediate & non-immediate PDU commands queue */
 	conn->immqueue = kfifo_alloc(session->mgmtpool_max * sizeof(void*),
@@ -1410,8 +1399,6 @@ login_mtask_alloc_fail:
 mgmtqueue_alloc_fail:
 	kfifo_free(conn->immqueue);
 immqueue_alloc_fail:
-	kfifo_free(conn->xmitqueue);
-xmitqueue_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
 	return NULL;
 }
@@ -1489,7 +1476,6 @@ void iscsi_conn_teardown(struct iscsi_cl
 		session->cmdsn = session->max_cmdsn = session->exp_cmdsn = 1;
 	spin_unlock_bh(&session->lock);
 
-	kfifo_free(conn->xmitqueue);
 	kfifo_free(conn->immqueue);
 	kfifo_free(conn->mgmtqueue);
 
@@ -1572,7 +1558,7 @@ static void fail_all_commands(struct isc
 	struct iscsi_cmd_task *ctask, *tmp;
 
 	/* flush pending */
-	while (__kfifo_get(conn->xmitqueue, (void*)&ctask, sizeof(void*))) {
+	list_for_each_entry_safe(ctask, tmp, &conn->xmitqueue, running) {
 		debug_scsi("failing pending sc %p itt 0x%x\n", ctask->sc,
 			   ctask->itt);
 		fail_command(conn, ctask, DID_BUS_BUSY << 16);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index ba27608..e71d6e9 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -83,6 +83,12 @@ struct iscsi_mgmt_task {
 	struct list_head	running;
 };
 
+enum {
+	ISCSI_TASK_COMPLETED,
+	ISCSI_TASK_PENDING,
+	ISCSI_TASK_RUNNING,
+};
+
 struct iscsi_cmd_task {
 	/*
 	 * Becuae LLDs allocate their hdr differently, this is a pointer to
@@ -101,6 +107,8 @@ struct iscsi_cmd_task {
 	struct iscsi_conn	*conn;		/* used connection    */
 	struct iscsi_mgmt_task	*mtask;		/* tmf mtask in progr */
 
+	/* state set/tested under session->lock */
+	int			state;
 	struct list_head	running;	/* running cmd list */
 	void			*dd_data;	/* driver/transport data */
 };
@@ -134,7 +142,7 @@ struct iscsi_conn {
 	struct kfifo		*immqueue;	/* immediate xmit queue */
 	struct kfifo		*mgmtqueue;	/* mgmt (control) xmit queue */
 	struct list_head	mgmt_run_list;	/* list of control tasks */
-	struct kfifo		*xmitqueue;	/* data-path cmd queue */
+	struct list_head	xmitqueue;	/* data-path cmd queue */
 	struct list_head	run_list;	/* list of cmds in progress */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
 	/*


