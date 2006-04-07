From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 3/5] iscsi: fix up iscsi eh
Date: Thu, 06 Apr 2006 21:13:39 -0500
Message-ID: <1144376019.11062.21.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56238 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932288AbWDGCPT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2006 22:15:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

The current iscsi_tcp eh is not nicely setup for dm-multipath
and performs some extra task management functions when they
are not needed.

The attached patch:

- Fixes the TMF issues. If a session is rebuilt
then we do not send aborts.

- Fixes the problem where if the host reset fired, we would
return SUCCESS even though we had not really done anything
yet. This ends up causing problem with scsi_error.c's TUR.

- If someone has turned on the userspace nop daemon code to try
and detect network problems before the scsi command timeout
we can now drop and clean up the session before the scsi command
timesout and fires the eh speeding up the time it takes for a
command to go from one patch to another. For network problems
we fail the command with DID_BUS_BUSY so if failfast is set
scsi_decide_disposition fails the command up to dm for it to
try on another path.

- And we had to add some basic iscsi session block code. Previously
if we were trying to repair a session we would retrun a MLQUEUE code
in the queuecommand. This worked but it was not the most efficient
or pretty thing to do since it would take a while to relogin
to the target. For iscsi_tcp/open-iscsi a lot of the iscsi error handler
is in userspace the block code is pretty bare. We will be
adding to that for qla4xxx.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 32b499c..5b2925a 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -82,6 +82,9 @@ module_param_named(max_lun, iscsi_max_lu
 /* global data */
 static kmem_cache_t *taskcache;
 
+#define session_to_cls(_sess) \
+	hostdata_session(_sess->host->hostdata)
+
 static inline void
 iscsi_buf_init_virt(struct iscsi_buf *ibuf, char *vbuf, int size)
 {
@@ -230,17 +233,19 @@ iscsi_hdr_extract(struct iscsi_conn *con
 	return 0;
 }
 
-static inline void
-iscsi_ctask_cleanup(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
+/*
+ * must be called with session lock
+ */
+static void
+__iscsi_ctask_cleanup(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
-	struct scsi_cmnd *sc = ctask->sc;
 	struct iscsi_session *session = conn->session;
+	struct scsi_cmnd *sc;
 
-	spin_lock(&session->lock);
-	if (unlikely(!sc)) {
-		spin_unlock(&session->lock);
+	sc = ctask->sc;
+	if (unlikely(!sc))
 		return;
-	}
+
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
 		struct iscsi_data_task *dtask, *n;
 		/* WRITE: cleanup Data-Out's if any */
@@ -252,7 +257,20 @@ iscsi_ctask_cleanup(struct iscsi_conn *c
 	ctask->xmstate = XMSTATE_IDLE;
 	ctask->r2t = NULL;
 	ctask->sc = NULL;
+	list_del(&ctask->running);
+
 	__kfifo_put(session->cmdpool.queue, (void*)&ctask, sizeof(void*));
+
+	sc->scsi_done(sc);
+}
+
+static void
+iscsi_ctask_cleanup(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
+{
+	struct iscsi_session *session = conn->session;
+
+	spin_lock(&session->lock);
+	__iscsi_ctask_cleanup(conn, ctask);
 	spin_unlock(&session->lock);
 }
 
@@ -311,7 +329,6 @@ out:
 		   (long)sc, sc->result, ctask->itt);
 	conn->scsirsp_pdus_cnt++;
 	iscsi_ctask_cleanup(conn, ctask);
-	sc->scsi_done(sc);
 	return rc;
 }
 
@@ -395,6 +412,7 @@ iscsi_solicit_data_init(struct iscsi_con
 
 	dtask = mempool_alloc(ctask->datapool, GFP_ATOMIC);
 	BUG_ON(!dtask);
+	INIT_LIST_HEAD(&dtask->item);
 	hdr = &dtask->hdr;
 	memset(hdr, 0, sizeof(struct iscsi_data));
 	hdr->ttt = r2t->ttt;
@@ -710,8 +728,6 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 			conn->tmfrsp_pdus_cnt++;
 			spin_lock(&session->lock);
 			if (conn->tmabort_state == TMABORT_INITIAL) {
-				__kfifo_put(session->mgmtpool.queue,
-						(void*)&mtask, sizeof(void*));
 				conn->tmabort_state =
 					((struct iscsi_tm_rsp *)hdr)->
 					response == ISCSI_TMF_RSP_COMPLETE ?
@@ -986,7 +1002,6 @@ done:
 			   (long)sc, sc->result, ctask->itt);
 		conn->scsirsp_pdus_cnt++;
 		iscsi_ctask_cleanup(conn, ctask);
-		sc->scsi_done(sc);
 	}
 
 	return rc;
@@ -1460,6 +1475,7 @@ iscsi_solicit_data_cont(struct iscsi_con
 
 	dtask = mempool_alloc(ctask->datapool, GFP_ATOMIC);
 	BUG_ON(!dtask);
+	INIT_LIST_HEAD(&dtask->item);
 	hdr = &dtask->hdr;
 	memset(hdr, 0, sizeof(struct iscsi_data));
 	hdr->ttt = r2t->ttt;
@@ -1506,6 +1522,7 @@ iscsi_unsolicit_data_init(struct iscsi_c
 
 	dtask = mempool_alloc(ctask->datapool, GFP_ATOMIC);
 	BUG_ON(!dtask);
+	INIT_LIST_HEAD(&dtask->item);
 	hdr = &dtask->hdr;
 	memset(hdr, 0, sizeof(struct iscsi_data));
 	hdr->ttt = cpu_to_be32(ISCSI_RESERVED_TAG);
@@ -1550,6 +1567,7 @@ iscsi_cmd_init(struct iscsi_conn *conn, 
 
 	BUG_ON(__kfifo_len(ctask->r2tqueue));
 
+	INIT_LIST_HEAD(&ctask->running);
 	ctask->sc = sc;
 	ctask->conn = conn;
 	ctask->hdr.opcode = ISCSI_OP_SCSI_CMD;
@@ -1680,7 +1698,7 @@ iscsi_mtask_xmit(struct iscsi_conn *conn
 		if (mtask->data_count)
 			mtask->xmstate |= XMSTATE_IMM_DATA;
 		if (conn->c_stage != ISCSI_CONN_INITIAL_STAGE &&
-	    	    conn->stop_stage != STOP_CONN_RECOVER &&
+		    conn->stop_stage != STOP_CONN_RECOVER &&
 		    conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &mtask->headbuf,
 					(u8*)mtask->hdrext);
@@ -2226,6 +2244,7 @@ iscsi_data_xmit(struct iscsi_conn *conn)
 	/* process command queue */
 	while (__kfifo_get(conn->xmitqueue, (void*)&conn->ctask,
 			   sizeof(void*))) {
+		list_add_tail(&conn->ctask->running, &conn->run_list);
 		if (iscsi_ctask_xmit(conn, conn->ctask))
 			goto again;
 	}
@@ -2277,11 +2296,14 @@ iscsi_xmitworker(void *data)
 	mutex_unlock(&conn->xmitmutex);
 }
 
-#define FAILURE_BAD_HOST		1
-#define FAILURE_SESSION_FAILED		2
-#define FAILURE_SESSION_FREED		3
-#define FAILURE_WINDOW_CLOSED		4
-#define FAILURE_SESSION_TERMINATE	5
+enum {
+	FAILURE_BAD_HOST = 1,
+	FAILURE_SESSION_FAILED,
+	FAILURE_SESSION_FREED,
+	FAILURE_WINDOW_CLOSED,
+	FAILURE_SESSION_TERMINATE,
+	FAILURE_SESSION_RECOVERY_TIMEOUT,
+};
 
 static int
 iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
@@ -2297,12 +2319,14 @@ iscsi_queuecommand(struct scsi_cmnd *sc,
 
 	host = sc->device->host;
 	session = iscsi_hostdata(host->hostdata);
-	BUG_ON(host != session->host);
 
 	spin_lock(&session->lock);
 
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
-		if (session->state == ISCSI_STATE_FAILED) {
+		if (session->recovery_failed) {
+			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
+			goto fault;
+		} else if (session->state == ISCSI_STATE_FAILED) {
 			reason = FAILURE_SESSION_FAILED;
 			goto reject;
 		} else if (session->state == ISCSI_STATE_TERMINATE) {
@@ -2350,11 +2374,6 @@ fault:
 	spin_unlock(&session->lock);
 	printk(KERN_ERR "iscsi_tcp: cmd 0x%x is not queued (%d)\n",
 	       sc->cmnd[0], reason);
-	sc->sense_buffer[0] = 0x70;
-	sc->sense_buffer[2] = NOT_READY;
-	sc->sense_buffer[7] = 0x6;
-	sc->sense_buffer[12] = 0x08;
-	sc->sense_buffer[13] = 0x00;
 	sc->result = (DID_NO_CONNECT << 16);
 	sc->resid = sc->request_bufflen;
 	sc->scsi_done(sc);
@@ -2445,6 +2464,7 @@ iscsi_conn_create(struct iscsi_cls_sessi
 	conn->id = conn_idx;
 	conn->exp_statsn = 0;
 	conn->tmabort_state = TMABORT_INITIAL;
+	INIT_LIST_HEAD(&conn->run_list);
 
 	/* initial operational parameters */
 	conn->hdr_size = sizeof(struct iscsi_hdr);
@@ -2701,6 +2721,22 @@ iscsi_conn_bind(struct iscsi_cls_session
 	return 0;
 }
 
+static void
+iscsi_session_recovery_timedout(struct iscsi_cls_session *csession)
+{
+	struct Scsi_Host *shost = iscsi_session_to_shost(csession);
+	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
+	struct iscsi_conn *conn = session->leadconn;
+
+	spin_lock_bh(&session->lock);
+	if (session->state != ISCSI_STATE_LOGGED_IN) {
+		session->recovery_failed = 1;
+		if (conn)
+			wake_up(&conn->ehwait);
+	}
+	spin_unlock_bh(&session->lock);
+}
+
 static int
 iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 {
@@ -2716,7 +2752,6 @@ iscsi_conn_start(struct iscsi_cls_conn *
 	}
 
 	sk = conn->sock->sk;
-
 	write_lock_bh(&sk->sk_callback_lock);
 	spin_lock_bh(&session->lock);
 	conn->c_stage = ISCSI_CONN_STARTED;
@@ -2732,8 +2767,13 @@ iscsi_conn_start(struct iscsi_cls_conn *
 		conn->stop_stage = 0;
 		conn->tmabort_state = TMABORT_INITIAL;
 		session->age++;
+		session->recovery_failed = 0;
+		spin_unlock_bh(&session->lock);
+		write_unlock_bh(&sk->sk_callback_lock);
+
+		iscsi_unblock_session(session_to_cls(session));
 		wake_up(&conn->ehwait);
-		break;
+		return 0;
 	case STOP_CONN_TERM:
 		session->conn_cnt++;
 		conn->stop_stage = 0;
@@ -2752,105 +2792,199 @@ iscsi_conn_start(struct iscsi_cls_conn *
 	return 0;
 }
 
-static void
-iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
+static int
+iscsi_ctask_mtask_cleanup(struct iscsi_cmd_task *ctask)
 {
-	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct iscsi_conn *conn = ctask->conn;
 	struct iscsi_session *session = conn->session;
+	struct iscsi_mgmt_task *mtask;
+
+	if (!ctask->mtask)
+		return -EINVAL;
+
+	while (__kfifo_get(conn->immqueue, (void*)&mtask, sizeof(void*))) {
+		if (mtask == ctask->mtask)
+			break;
+		__kfifo_put(conn->immqueue, (void*)&mtask, sizeof(void*));
+	}
+
+	__kfifo_put(session->mgmtpool.queue, (void*)&ctask->mtask,
+		    sizeof(void*));
+	ctask->mtask = NULL;
+	return 0;
+}
+
+static void
+fail_command(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask, int err)
+{
+	struct iscsi_r2t_info *r2t;
+	struct scsi_cmnd *sc;
+
+	/* flush ctask's r2t queues */
+	while (__kfifo_get(ctask->r2tqueue, (void*)&r2t, sizeof(void*)))
+		__kfifo_put(ctask->r2tpool.queue, (void*)&r2t, sizeof(void*));
+
+	iscsi_ctask_mtask_cleanup(ctask);
+
+	sc = ctask->sc;
+	if (!sc)
+		return;
+
+	sc->result = err;
+	sc->resid = sc->request_bufflen;
+
+	__iscsi_ctask_cleanup(conn, ctask);
+}
+
+/* Fail commands. Mutex and session lock held */
+static void
+fail_all_commands(struct iscsi_session *session, struct iscsi_conn *conn)
+{
+	struct iscsi_cmd_task *ctask, *tmp;
+
+	/* flush pending */	
+	while (__kfifo_get(conn->xmitqueue, (void*)&ctask, sizeof(void*))) {
+		debug_scsi("failing pending sc %p itt 0x%x\n", ctask->sc,
+			   ctask->itt);
+		fail_command(conn, ctask, DID_BUS_BUSY << 16);
+	}
+
+	/* fail running */
+	list_for_each_entry_safe(ctask, tmp, &conn->run_list, running) {
+		debug_scsi("failing in progress sc %p itt 0x%x\n",
+			   ctask->sc, ctask->itt);
+		fail_command(conn, ctask, DID_BUS_BUSY << 16);
+	}
+
+	conn->ctask = NULL;
+}
+
+static void
+flush_control_queues(struct iscsi_session *session, struct iscsi_conn *conn)
+{
+	struct iscsi_mgmt_task *mtask;
+
+	/* TODO: handle running pdus */
+	while (__kfifo_get(conn->immqueue, (void*)&mtask, sizeof(void*)) ||
+	       __kfifo_get(conn->mgmtqueue, (void*)&mtask, sizeof(void*))) {
+		if (mtask == conn->login_mtask)
+			continue;
+		__kfifo_put(session->mgmtpool.queue, (void*)&mtask,
+			    sizeof(void*));
+	}
+
+	if (conn->mtask && conn->mtask != conn->login_mtask)
+		__kfifo_put(session->mgmtpool.queue, (void*)&conn->mtask,
+			    sizeof(void*));
+	conn->mtask = NULL;
+}
+
+static void
+iscsi_suspend_conn_rx(struct iscsi_conn *conn)
+{
 	struct sock *sk;
-	unsigned long flags;
 
 	BUG_ON(!conn->sock);
 	sk = conn->sock->sk;
 	write_lock_bh(&sk->sk_callback_lock);
 	set_bit(SUSPEND_BIT, &conn->suspend_rx);
 	write_unlock_bh(&sk->sk_callback_lock);
+}
 
-	mutex_lock(&conn->xmitmutex);
-
-	spin_lock_irqsave(session->host->host_lock, flags);
-	spin_lock(&session->lock);
+static void
+iscsi_start_session_recovery(struct iscsi_session *session,
+			     struct iscsi_conn *conn, int flag)
+{
+	spin_lock_bh(&session->lock);
+	if (conn->stop_stage == STOP_CONN_RECOVER ||
+	    conn->stop_stage == STOP_CONN_TERM) {
+		spin_unlock_bh(&session->lock);
+		return;
+	}
 	conn->stop_stage = flag;
+	spin_unlock_bh(&session->lock);
+
+	iscsi_suspend_conn_rx(conn);
+
+	mutex_lock(&conn->xmitmutex);
+	spin_lock_bh(&session->lock);
 	conn->c_stage = ISCSI_CONN_STOPPED;
 	set_bit(SUSPEND_BIT, &conn->suspend_tx);
 
-	if (flag != STOP_CONN_SUSPEND)
-		session->conn_cnt--;
-
+	session->conn_cnt--;
 	if (session->conn_cnt == 0 || session->leadconn == conn)
 		session->state = ISCSI_STATE_FAILED;
 
-	spin_unlock(&session->lock);
-	spin_unlock_irqrestore(session->host->host_lock, flags);
-
-	if (flag == STOP_CONN_TERM || flag == STOP_CONN_RECOVER) {
-		struct iscsi_cmd_task *ctask;
-		struct iscsi_mgmt_task *mtask;
+	spin_unlock_bh(&session->lock);
 
-		/*
-		 * Socket must go now.
-		 */
-		sock_hold(conn->sock->sk);
-		iscsi_conn_restore_callbacks(conn);
-		sock_put(conn->sock->sk);
+	/*
+	 * Socket must go now.
+	 */
+	sock_hold(conn->sock->sk);
+	iscsi_conn_restore_callbacks(conn);
+	sock_put(conn->sock->sk);
 
-		/*
-		 * flush xmit queues.
-		 */
-		spin_lock_bh(&session->lock);
-		while (__kfifo_get(conn->writequeue, (void*)&ctask,
-			    sizeof(void*)) ||
-			__kfifo_get(conn->xmitqueue, (void*)&ctask,
-			    sizeof(void*))) {
-			struct iscsi_r2t_info *r2t;
-
-			/*
-			 * flush ctask's r2t queues
-			 */
-			while (__kfifo_get(ctask->r2tqueue, (void*)&r2t,
-				sizeof(void*)))
-				__kfifo_put(ctask->r2tpool.queue, (void*)&r2t,
-					    sizeof(void*));
+	/*
+	 * flush queues.
+	 */
+	spin_lock_bh(&session->lock);
+	fail_all_commands(session, conn);
+	flush_control_queues(session, conn);
+	spin_unlock_bh(&session->lock);
 
-			spin_unlock_bh(&session->lock);
-			local_bh_disable();
-			iscsi_ctask_cleanup(conn, ctask);
-			local_bh_enable();
-			spin_lock_bh(&session->lock);
-		}
-		conn->ctask = NULL;
-		while (__kfifo_get(conn->immqueue, (void*)&mtask,
-			   sizeof(void*)) ||
-			__kfifo_get(conn->mgmtqueue, (void*)&mtask,
-			   sizeof(void*))) {
-			__kfifo_put(session->mgmtpool.queue,
-				    (void*)&mtask, sizeof(void*));
-		}
-		conn->mtask = NULL;
-		spin_unlock_bh(&session->lock);
+	/*
+	 * release socket only after we stopped data_xmit()
+	 * activity and flushed all outstandings
+	 */
+	sock_release(conn->sock);
+	conn->sock = NULL;
 
-		/*
-		 * release socket only after we stopped data_xmit()
-		 * activity and flushed all outstandings
-		 */
-		sock_release(conn->sock);
-		conn->sock = NULL;
+	/*
+	 * for connection level recovery we should not calculate
+	 * header digest. conn->hdr_size used for optimization
+	 * in hdr_extract() and will be re-negotiated at
+	 * set_param() time.
+	 */
+	if (flag == STOP_CONN_RECOVER) {
+		conn->hdr_size = sizeof(struct iscsi_hdr);
+		conn->hdrdgst_en = 0;
+		conn->datadgst_en = 0;
 
-		/*
-		 * for connection level recovery we should not calculate
-		 * header digest. conn->hdr_size used for optimization
-		 * in hdr_extract() and will be re-negotiated at
-		 * set_param() time.
-		 */
-		if (flag == STOP_CONN_RECOVER) {
-			conn->hdr_size = sizeof(struct iscsi_hdr);
-			conn->hdrdgst_en = 0;
-			conn->datadgst_en = 0;
-		}
+		if (session->state == ISCSI_STATE_FAILED)
+			iscsi_block_session(session_to_cls(session));
 	}
 	mutex_unlock(&conn->xmitmutex);
 }
 
+static void
+iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
+{
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct iscsi_session *session = conn->session;
+
+	switch (flag) {
+	case STOP_CONN_RECOVER:
+	case STOP_CONN_TERM:
+		iscsi_start_session_recovery(session, conn, flag);
+		return;
+	case STOP_CONN_SUSPEND:
+		iscsi_suspend_conn_rx(conn);
+
+		mutex_lock(&conn->xmitmutex);
+		spin_lock_bh(&session->lock);
+
+		conn->stop_stage = flag;
+		conn->c_stage = ISCSI_CONN_STOPPED;
+		set_bit(SUSPEND_BIT, &conn->suspend_tx);
+
+		spin_unlock_bh(&session->lock);
+		mutex_unlock(&conn->xmitmutex);
+		break;
+	default:
+		printk(KERN_ERR "invalid stop flag %d\n", flag);
+	}
+}
+
 static int
 iscsi_conn_send_generic(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			char *data, uint32_t data_size)
@@ -2940,23 +3074,54 @@ iscsi_conn_send_generic(struct iscsi_con
 static int
 iscsi_eh_host_reset(struct scsi_cmnd *sc)
 {
-	struct iscsi_cmd_task *ctask = (struct iscsi_cmd_task *)sc->SCp.ptr;
-	struct iscsi_conn *conn = ctask->conn;
-	struct iscsi_session *session = conn->session;
+	struct Scsi_Host *host = sc->device->host;
+	struct iscsi_session *session = iscsi_hostdata(host->hostdata);
+	struct iscsi_conn *conn = session->leadconn;
+	int fail_session = 0;
 
 	spin_lock_bh(&session->lock);
 	if (session->state == ISCSI_STATE_TERMINATE) {
+failed:
 		debug_scsi("failing host reset: session terminated "
 			   "[CID %d age %d]", conn->id, session->age);
 		spin_unlock_bh(&session->lock);
 		return FAILED;
 	}
+
+	if (sc->SCp.phase == session->age) {
+		debug_scsi("failing connection CID %d due to SCSI host reset",
+			   conn->id);
+		fail_session = 1;
+	}
 	spin_unlock_bh(&session->lock);
 
-	debug_scsi("failing connection CID %d due to SCSI host reset "
-		   "[itt 0x%x age %d]", conn->id, ctask->itt,
-		   session->age);
-	iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+	/*
+	 * we drop the lock here but the leadconn cannot be destoyed while
+	 * we are in the scsi eh
+	 */
+	if (fail_session) {
+		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+		/*
+		 * if userspace cannot respond then we must kick this off
+		 * here for it
+		 */
+		iscsi_start_session_recovery(session, conn, STOP_CONN_RECOVER);
+	}
+
+	debug_scsi("iscsi_eh_host_reset wait for relogin\n");
+	wait_event_interruptible(conn->ehwait,
+				 session->state == ISCSI_STATE_TERMINATE ||
+				 session->state == ISCSI_STATE_LOGGED_IN ||
+				 session->recovery_failed);
+	if (signal_pending(current))
+		flush_signals(current);
+
+	spin_lock_bh(&session->lock);
+	if (session->state == ISCSI_STATE_LOGGED_IN)
+		printk(KERN_INFO "host reset succeeded\n");
+	else
+		goto failed;
+	spin_unlock_bh(&session->lock);
 
 	return SUCCESS;
 }
@@ -2970,8 +3135,6 @@ iscsi_tmabort_timedout(unsigned long dat
 
 	spin_lock(&session->lock);
 	if (conn->tmabort_state == TMABORT_INITIAL) {
-		__kfifo_put(session->mgmtpool.queue,
-				(void*)&ctask->mtask, sizeof(void*));
 		conn->tmabort_state = TMABORT_TIMEDOUT;
 		debug_scsi("tmabort timedout [sc %lx itt 0x%x]\n",
 			(long)ctask->sc, ctask->itt);
@@ -2981,186 +3144,163 @@ iscsi_tmabort_timedout(unsigned long dat
 	spin_unlock(&session->lock);
 }
 
+/* must be called with the mutex lock */
 static int
-iscsi_eh_abort(struct scsi_cmnd *sc)
+iscsi_exec_abort_task(struct scsi_cmnd *sc, struct iscsi_cmd_task *ctask)
 {
-	int rc;
-	struct iscsi_cmd_task *ctask = (struct iscsi_cmd_task *)sc->SCp.ptr;
 	struct iscsi_conn *conn = ctask->conn;
 	struct iscsi_session *session = conn->session;
-
-	conn->eh_abort_cnt++;
-	debug_scsi("aborting [sc %lx itt 0x%x]\n", (long)sc, ctask->itt);
+	struct iscsi_tm *hdr = &conn->tmhdr;
+	int rc;
 
 	/*
-	 * two cases for ERL=0 here:
-	 *
-	 * 1) connection-level failure;
-	 * 2) recovery due protocol error;
+	 * ctask timed out but session is OK requests must be serialized.
 	 */
-	mutex_lock(&conn->xmitmutex);
-	spin_lock_bh(&session->lock);
-	if (session->state != ISCSI_STATE_LOGGED_IN) {
-		if (session->state == ISCSI_STATE_TERMINATE) {
-			spin_unlock_bh(&session->lock);
-			mutex_unlock(&conn->xmitmutex);
-			goto failed;
-		}
-		spin_unlock_bh(&session->lock);
-	} else {
-		struct iscsi_tm *hdr = &conn->tmhdr;
-
-		/*
-		 * Still LOGGED_IN...
-		 */
+	memset(hdr, 0, sizeof(struct iscsi_tm));
+	hdr->opcode = ISCSI_OP_SCSI_TMFUNC | ISCSI_OP_IMMEDIATE;
+	hdr->flags = ISCSI_TM_FUNC_ABORT_TASK;
+	hdr->flags |= ISCSI_FLAG_CMD_FINAL;
+	memcpy(hdr->lun, ctask->hdr.lun, sizeof(hdr->lun));
+	hdr->rtt = ctask->hdr.itt;
+	hdr->refcmdsn = ctask->hdr.cmdsn;
 
-		if (!ctask->sc || sc->SCp.phase != session->age) {
-			/*
-			 * 1) ctask completed before time out. But session
-			 *    is still ok => Happy Retry.
-			 * 2) session was re-open during time out of ctask.
-			 */
-			spin_unlock_bh(&session->lock);
-			mutex_unlock(&conn->xmitmutex);
-			goto success;
-		}
-		conn->tmabort_state = TMABORT_INITIAL;
-		spin_unlock_bh(&session->lock);
+	rc = iscsi_conn_send_generic(conn, (struct iscsi_hdr *)hdr,
+				     NULL, 0);
+	if (rc) {
+		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+		debug_scsi("abort sent failure [itt 0x%x] %d", ctask->itt, rc);
+		return rc;
+	}
 
-		/*
-		 * ctask timed out but session is OK
-		 * ERL=0 requires task mgmt abort to be issued on each
-		 * failed command. requests must be serialized.
-		 */
-		memset(hdr, 0, sizeof(struct iscsi_tm));
-		hdr->opcode = ISCSI_OP_SCSI_TMFUNC | ISCSI_OP_IMMEDIATE;
-		hdr->flags = ISCSI_TM_FUNC_ABORT_TASK;
-		hdr->flags |= ISCSI_FLAG_CMD_FINAL;
-		memcpy(hdr->lun, ctask->hdr.lun, sizeof(hdr->lun));
-		hdr->rtt = ctask->hdr.itt;
-		hdr->refcmdsn = ctask->hdr.cmdsn;
+	debug_scsi("abort sent [itt 0x%x]\n", ctask->itt);
 
-		rc = iscsi_conn_send_generic(conn, (struct iscsi_hdr *)hdr,
-					     NULL, 0);
-		if (rc) {
-			iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-			debug_scsi("abort sent failure [itt 0x%x]", ctask->itt);
-		} else {
-			struct iscsi_r2t_info *r2t;
+	spin_lock_bh(&session->lock);
+	ctask->mtask = (struct iscsi_mgmt_task *)
+			session->mgmt_cmds[(hdr->itt & ITT_MASK) -
+					ISCSI_MGMT_ITT_OFFSET];
 
-			/*
-			 * TMF abort vs. TMF response race logic
-			 */
-			spin_lock_bh(&session->lock);
-			ctask->mtask = (struct iscsi_mgmt_task *)
-				session->mgmt_cmds[(hdr->itt & ITT_MASK) -
-							ISCSI_MGMT_ITT_OFFSET];
-			/*
-			 * have to flush r2tqueue to avoid r2t leaks
-			 */
-			while (__kfifo_get(ctask->r2tqueue, (void*)&r2t,
-				sizeof(void*))) {
-				__kfifo_put(ctask->r2tpool.queue, (void*)&r2t,
-					sizeof(void*));
-			}
-			if (conn->tmabort_state == TMABORT_INITIAL) {
-				conn->tmfcmd_pdus_cnt++;
-				conn->tmabort_timer.expires = 3*HZ + jiffies;
-				conn->tmabort_timer.function =
-						iscsi_tmabort_timedout;
-				conn->tmabort_timer.data = (unsigned long)ctask;
-				add_timer(&conn->tmabort_timer);
-				debug_scsi("abort sent [itt 0x%x]", ctask->itt);
-			} else {
-				if (!ctask->sc ||
-				    conn->tmabort_state == TMABORT_SUCCESS) {
-					conn->tmabort_state = TMABORT_INITIAL;
-					spin_unlock_bh(&session->lock);
-					mutex_unlock(&conn->xmitmutex);
-					goto success;
-				}
-				conn->tmabort_state = TMABORT_INITIAL;
-				iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-			}
-			spin_unlock_bh(&session->lock);
-		}
+	if (conn->tmabort_state == TMABORT_INITIAL) {
+		conn->tmfcmd_pdus_cnt++;
+		conn->tmabort_timer.expires = 10*HZ + jiffies;
+		conn->tmabort_timer.function = iscsi_tmabort_timedout;
+		conn->tmabort_timer.data = (unsigned long)ctask;
+		add_timer(&conn->tmabort_timer);
+		debug_scsi("abort set timeout [itt 0x%x]", ctask->itt);
 	}
+	spin_unlock_bh(&session->lock);
 	mutex_unlock(&conn->xmitmutex);
 
-
 	/*
 	 * block eh thread until:
 	 *
-	 * 1) abort response;
-	 * 2) abort timeout;
-	 * 3) session re-opened;
-	 * 4) session terminated;
-	 */
-	for (;;) {
-		int p_state = session->state;
+	 * 1) abort response
+	 * 2) abort timeout
+	 * 3) session is terminated or restarted or userspace has
+	 * given up on recovery
+	 */
+	wait_event_interruptible(conn->ehwait,
+				 sc->SCp.phase != session->age ||
+				 session->state != ISCSI_STATE_LOGGED_IN ||
+				 conn->tmabort_state != TMABORT_INITIAL ||
+				 session->recovery_failed);
+	if (signal_pending(current))
+		flush_signals(current);
+	del_timer_sync(&conn->tmabort_timer);
 
-		rc = wait_event_interruptible(conn->ehwait,
-			(p_state == ISCSI_STATE_LOGGED_IN ?
-			 (session->state == ISCSI_STATE_TERMINATE ||
-			  conn->tmabort_state != TMABORT_INITIAL) :
-			 (session->state == ISCSI_STATE_TERMINATE ||
-			  session->state == ISCSI_STATE_LOGGED_IN)));
-		if (rc) {
-			/* shutdown.. */
-			session->state = ISCSI_STATE_TERMINATE;
-			goto failed;
-		}
+	mutex_lock(&conn->xmitmutex);
+	return 0;
+}
 
-		if (signal_pending(current))
-			flush_signals(current);
+static int
+iscsi_eh_abort(struct scsi_cmnd *sc)
+{
+	struct iscsi_cmd_task *ctask = (struct iscsi_cmd_task *)sc->SCp.ptr;
+	struct iscsi_cmd_task *tmp_ctask;
+	struct iscsi_conn *conn = ctask->conn;
+	struct iscsi_session *session = conn->session;
+	int rc;
 
-		if (session->state == ISCSI_STATE_TERMINATE)
-			goto failed;
+	conn->eh_abort_cnt++;
+	debug_scsi("aborting [sc %p itt 0x%x]\n", sc, ctask->itt);
 
-		spin_lock_bh(&session->lock);
-		if (sc->SCp.phase == session->age &&
-		   (conn->tmabort_state == TMABORT_TIMEDOUT ||
-		    conn->tmabort_state == TMABORT_FAILED)) {
-			conn->tmabort_state = TMABORT_INITIAL;
-			if (!ctask->sc) {
-				/*
-				 * ctask completed before tmf abort response or
-				 * time out.
-				 * But session is still ok => Happy Retry.
-				 */
-				spin_unlock_bh(&session->lock);
-				break;
-			}
-			spin_unlock_bh(&session->lock);
-			iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-			continue;
+	mutex_lock(&conn->xmitmutex);
+	spin_lock_bh(&session->lock);
+
+	/*
+	 * If we are not logged in or we have started a new session
+	 * then let the host reset code handle this
+	 */
+	if (session->state != ISCSI_STATE_LOGGED_IN ||
+	    sc->SCp.phase != session->age)
+		goto failed;
+
+	/* ctask completed before time out */
+	if (!ctask->sc)
+		goto success;
+
+	/* what should we do here ? */
+	if (conn->ctask == ctask) {
+		printk(KERN_INFO "sc %p itt 0x%x partially sent. Failing "
+		       "abort\n", sc, ctask->itt);
+		goto failed;
+	}
+
+	/* check for the easy pending cmd abort */
+	while (__kfifo_get(conn->xmitqueue, (void*)&tmp_ctask, sizeof(void*))) {
+		if (tmp_ctask->itt == ctask->itt) {
+			debug_scsi("found pending task\n");
+			goto success;
 		}
+		__kfifo_put(conn->xmitqueue, (void*)&tmp_ctask, sizeof(void*));
+	}
+
+	conn->tmabort_state = TMABORT_INITIAL;
+
+	spin_unlock_bh(&session->lock);
+	rc = iscsi_exec_abort_task(sc, ctask);
+	spin_lock_bh(&session->lock);
+
+	iscsi_ctask_mtask_cleanup(ctask);
+	if (rc || sc->SCp.phase != session->age ||
+	    session->state != ISCSI_STATE_LOGGED_IN)
+		goto failed;
+
+	/* ctask completed before tmf abort response */
+	if (!ctask->sc) {
+		debug_scsi("sc completed while abort in progress\n");
+		goto success;
+	}
+
+	if (conn->tmabort_state != TMABORT_SUCCESS) {
 		spin_unlock_bh(&session->lock);
-		break;
+		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+		spin_lock_bh(&session->lock);
+		goto failed;
 	}
 
 success:
 	debug_scsi("abort success [sc %lx itt 0x%x]\n", (long)sc, ctask->itt);
-	rc = SUCCESS;
-	goto exit;
-
-failed:
-	debug_scsi("abort failed [sc %lx itt 0x%x]\n", (long)sc, ctask->itt);
-	rc = FAILED;
-
-exit:
-	del_timer_sync(&conn->tmabort_timer);
+	spin_unlock_bh(&session->lock);
 
-	mutex_lock(&conn->xmitmutex);
+	/* clean up task if aborted */
 	if (conn->sock) {
 		struct sock *sk = conn->sock->sk;
-
+	
 		write_lock_bh(&sk->sk_callback_lock);
-		iscsi_ctask_cleanup(conn, ctask);
+		spin_lock(&session->lock);
+		fail_command(conn, ctask, DRIVER_TIMEOUT << 24);
+		spin_unlock(&session->lock);
 		write_unlock_bh(&sk->sk_callback_lock);
 	}
 	mutex_unlock(&conn->xmitmutex);
-	return rc;
+	return SUCCESS;	
+
+failed:
+	spin_unlock_bh(&session->lock);
+	mutex_unlock(&conn->xmitmutex);
+
+	debug_scsi("abort failed [sc %lx itt 0x%x]\n", (long)sc, ctask->itt);
+	return FAILED;
 }
 
 static int
@@ -3359,16 +3499,6 @@ iscsi_conn_set_param(struct iscsi_cls_co
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
 
-	spin_lock_bh(&session->lock);
-	if (conn->c_stage != ISCSI_CONN_INITIAL_STAGE &&
-	    conn->stop_stage != STOP_CONN_RECOVER) {
-		printk(KERN_ERR "iscsi_tcp: can not change parameter [%d]\n",
-		       param);
-		spin_unlock_bh(&session->lock);
-		return 0;
-	}
-	spin_unlock_bh(&session->lock);
-
 	switch(param) {
 	case ISCSI_PARAM_MAX_RECV_DLENGTH: {
 		char *saveptr = conn->data;
@@ -3691,6 +3821,7 @@ static struct iscsi_transport iscsi_tcp_
 	.stop_conn		= iscsi_conn_stop,
 	.send_pdu		= iscsi_conn_send_pdu,
 	.get_stats		= iscsi_conn_get_stats,
+	.session_recovery_timedout = iscsi_session_recovery_timedout,
 };
 
 static int __init
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index ba26741..12ef641 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -159,6 +159,7 @@ struct iscsi_conn {
 	struct kfifo		*immqueue;	/* immediate xmit queue */
 	struct kfifo		*mgmtqueue;	/* mgmt (control) xmit queue */
 	struct kfifo		*xmitqueue;	/* data-path cmd queue */
+	struct list_head	run_list;	/* list of cmds in progress */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
 	struct mutex		xmitmutex;	/* serializes connection xmit,
 						 * access to kfifos:	  *
@@ -228,6 +229,7 @@ struct iscsi_session {
 						 * - mgmtpool,		   *
 						 * - r2tpool		   */
 	int			state;		/* session state           */
+	int			recovery_failed;
 	struct list_head	item;
 	void			*auth_client;
 	int			conn_cnt;
@@ -310,6 +312,7 @@ struct iscsi_cmd_task {
 	struct iscsi_conn	*conn;			/* used connection    */
 	struct iscsi_mgmt_task	*mtask;			/* tmf mtask in progr */
 
+	struct list_head	running;		/* running cmd list */
 	struct iscsi_r2t_info	*r2t;			/* in progress R2T    */
 	struct iscsi_queue	r2tpool;
 	struct kfifo		*r2tqueue;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 811bc8a..7f6b4dd 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -31,17 +31,17 @@
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/iscsi_if.h>
 
-#define ISCSI_SESSION_ATTRS 10
+#define ISCSI_SESSION_ATTRS 11
 #define ISCSI_CONN_ATTRS 10
+#define ISCSI_HOST_ATTRS 0
 
 struct iscsi_internal {
 	struct scsi_transport_template t;
 	struct iscsi_transport *iscsi_transport;
 	struct list_head list;
 	struct class_device cdev;
-	/*
-	 * We do not have any private or other attrs.
-	 */
+
+	struct class_device_attribute *host_attrs[ISCSI_HOST_ATTRS + 1];
 	struct transport_container conn_cont;
 	struct class_device_attribute *conn_attrs[ISCSI_CONN_ATTRS + 1];
 	struct transport_container session_cont;
@@ -114,6 +114,24 @@ static struct attribute_group iscsi_tran
 	.attrs = iscsi_transport_attrs,
 };
 
+static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
+			    struct class_device *cdev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	struct iscsi_host *ihost = shost->shost_data;
+
+	memset(ihost, 0, sizeof(*ihost));
+	INIT_LIST_HEAD(&ihost->sessions);
+	mutex_init(&ihost->mutex);
+	return 0;
+}
+
+static DECLARE_TRANSPORT_CLASS(iscsi_host_class,
+			       "iscsi_host",
+			       iscsi_setup_host,
+			       NULL,
+			       NULL);
+
 static DECLARE_TRANSPORT_CLASS(iscsi_session_class,
 			       "iscsi_session",
 			       NULL,
@@ -225,6 +243,54 @@ static int iscsi_is_session_dev(const st
 	return dev->release == iscsi_session_release;
 }
 
+static int iscsi_user_scan(struct Scsi_Host *shost, uint channel,
+			   uint id, uint lun)
+{
+	struct iscsi_host *ihost = shost->shost_data;
+	struct iscsi_cls_session *session;
+
+	mutex_lock(&ihost->mutex);
+	list_for_each_entry(session, &ihost->sessions, host_list) {
+		if ((channel == SCAN_WILD_CARD ||
+		     channel == session->channel) &&
+		    (id == SCAN_WILD_CARD || id == session->target_id))
+			scsi_scan_target(&session->dev, session->channel,
+					 session->target_id, lun, 1);
+	}
+	mutex_unlock(&ihost->mutex);
+
+	return 0;
+}
+
+static void session_recovery_timedout(void *data)
+{
+	struct iscsi_cls_session *session = data;
+
+	dev_printk(KERN_INFO, &session->dev, "session recovery timed out "
+		  "after %d secs\n", session->recovery_tmo);
+
+	if (session->transport->session_recovery_timedout)
+		session->transport->session_recovery_timedout(session);
+
+	scsi_target_unblock(&session->dev);
+}
+
+void iscsi_unblock_session(struct iscsi_cls_session *session)
+{
+	if (!cancel_delayed_work(&session->recovery_work))
+		flush_scheduled_work();
+	scsi_target_unblock(&session->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_unblock_session);
+
+void iscsi_block_session(struct iscsi_cls_session *session)
+{
+	scsi_target_block(&session->dev);
+	schedule_delayed_work(&session->recovery_work,
+			     session->recovery_tmo * HZ);
+}
+EXPORT_SYMBOL_GPL(iscsi_block_session);
+
 /**
  * iscsi_create_session - create iscsi class session
  * @shost: scsi host
@@ -233,8 +299,10 @@ static int iscsi_is_session_dev(const st
  * This can be called from a LLD or iscsi_transport.
  **/
 struct iscsi_cls_session *
-iscsi_create_session(struct Scsi_Host *shost, struct iscsi_transport *transport)
+iscsi_create_session(struct Scsi_Host *shost,
+		     struct iscsi_transport *transport, int channel)
 {
+	struct iscsi_host *ihost;
 	struct iscsi_cls_session *session;
 	int err;
 
@@ -246,13 +314,22 @@ iscsi_create_session(struct Scsi_Host *s
 	if (!session)
 		goto module_put;
 	session->transport = transport;
+	session->recovery_tmo = 120;
+	INIT_WORK(&session->recovery_work, session_recovery_timedout, session);
+	INIT_LIST_HEAD(&session->host_list);
+	INIT_LIST_HEAD(&session->sess_list);
 
 	if (transport->sessiondata_size)
 		session->dd_data = &session[1];
 
 	/* this is released in the dev's release function */
 	scsi_host_get(shost);
+	ihost = shost->shost_data;
+
 	session->sid = iscsi_session_nr++;
+	session->channel = channel;
+	session->target_id = ihost->next_target_id++;
+
 	snprintf(session->dev.bus_id, BUS_ID_SIZE, "session%u",
 		 session->sid);
 	session->dev.parent = &shost->shost_gendev;
@@ -265,6 +342,10 @@ iscsi_create_session(struct Scsi_Host *s
 	}
 	transport_register_device(&session->dev);
 
+	mutex_lock(&ihost->mutex);
+	list_add(&session->host_list, &ihost->sessions);
+	mutex_unlock(&ihost->mutex);
+
 	return session;
 
 free_session:
@@ -285,6 +366,16 @@ EXPORT_SYMBOL_GPL(iscsi_create_session);
  **/
 int iscsi_destroy_session(struct iscsi_cls_session *session)
 {
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
+	struct iscsi_host *ihost = shost->shost_data;
+
+	if (!cancel_delayed_work(&session->recovery_work))
+		flush_scheduled_work();
+
+	mutex_lock(&ihost->mutex);
+	list_del(&session->host_list);
+	mutex_unlock(&ihost->mutex);
+
 	transport_unregister_device(&session->dev);
 	device_unregister(&session->dev);
 	return 0;
@@ -435,7 +526,7 @@ iscsi_transport_create_session(struct sc
 	if (scsi_add_host(shost, NULL))
 		goto free_host;
 
-	session = iscsi_create_session(shost, transport);
+	session = iscsi_create_session(shost, transport, 0);
 	if (!session)
 		goto remove_host;
 
@@ -466,12 +557,13 @@ int iscsi_transport_destroy_session(stru
 	struct iscsi_cls_session *session;
 	unsigned long flags;
 
-	scsi_remove_host(shost);
 	session = hostdata_session(shost->hostdata);
 	spin_lock_irqsave(&sesslock, flags);
 	list_del(&session->sess_list);
 	spin_unlock_irqrestore(&sesslock, flags);
 	iscsi_destroy_session(session);
+
+	scsi_remove_host(shost);
 	/* ref from host alloc */
 	scsi_host_put(shost);
 	return 0;
@@ -594,6 +686,7 @@ iscsi_unicast_skb(struct mempool_zone *z
 	}
 
 	spin_lock_irqsave(&zone->freelock, flags);
+	INIT_LIST_HEAD(skb_to_lh(skb));
 	list_add(skb_to_lh(skb), &zone->freequeue);
 	spin_unlock_irqrestore(&zone->freelock, flags);
 
@@ -888,6 +981,11 @@ iscsi_set_param(struct iscsi_transport *
 		return -EINVAL;
 
 	switch (ev->u.set_param.param) {
+	case ISCSI_PARAM_SESS_RECOVERY_TMO:
+		iscsi_copy_param(ev, &value, data);
+		if (value != 0)
+			session->recovery_tmo = value;
+		break;
 	case ISCSI_PARAM_TARGET_NAME:
 		/* this should not change between logins */
 		if (session->targetname)
@@ -980,7 +1078,6 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 			ev->r.retcode = transport->start_conn(conn);
 		else
 			err = -EINVAL;
-
 		break;
 	case ISCSI_UEVENT_STOP_CONN:
 		conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
@@ -1198,6 +1295,7 @@ static ISCSI_CLASS_ATTR(priv_sess, field
 			NULL)
 iscsi_priv_session_attr(targetname, "%s");
 iscsi_priv_session_attr(tpgt, "%d");
+iscsi_priv_session_attr(recovery_tmo, "%d");
 
 #define iscsi_priv_conn_attr_show(field, format)			\
 static ssize_t								\
@@ -1289,6 +1387,24 @@ static int iscsi_conn_match(struct attri
 	return &priv->conn_cont.ac == cont;
 }
 
+static int iscsi_host_match(struct attribute_container *cont,
+			    struct device *dev)
+{
+	struct Scsi_Host *shost;
+	struct iscsi_internal *priv;
+
+	if (!scsi_is_host_device(dev))
+		return 0;
+
+	shost = dev_to_shost(dev);
+	if (!shost->transportt  ||
+	    shost->transportt->host_attrs.ac.class != &iscsi_host_class.class)
+		return 0;
+
+        priv = to_iscsi_internal(shost->transportt);
+        return &priv->t.host_attrs.ac == cont;
+}
+
 struct scsi_transport_template *
 iscsi_register_transport(struct iscsi_transport *tt)
 {
@@ -1307,6 +1423,7 @@ iscsi_register_transport(struct iscsi_tr
 		return NULL;
 	INIT_LIST_HEAD(&priv->list);
 	priv->iscsi_transport = tt;
+	priv->t.user_scan = iscsi_user_scan;
 
 	priv->cdev.class = &iscsi_transport_class;
 	snprintf(priv->cdev.class_id, BUS_ID_SIZE, "%s", tt->name);
@@ -1318,6 +1435,14 @@ iscsi_register_transport(struct iscsi_tr
 	if (err)
 		goto unregister_cdev;
 
+	/* host parameters */
+	priv->t.host_attrs.ac.attrs = &priv->host_attrs[0];
+	priv->t.host_attrs.ac.class = &iscsi_host_class.class;
+	priv->t.host_attrs.ac.match = iscsi_host_match;
+	priv->t.host_size = sizeof(struct iscsi_host);
+	priv->host_attrs[0] = NULL;
+	transport_container_register(&priv->t.host_attrs);
+
 	/* connection parameters */
 	priv->conn_cont.ac.attrs = &priv->conn_attrs[0];
 	priv->conn_cont.ac.class = &iscsi_connection_class.class;
@@ -1361,6 +1486,7 @@ iscsi_register_transport(struct iscsi_tr
 	SETUP_SESSION_RD_ATTR(data_pdu_in_order, ISCSI_PDU_INORDER_EN);
 	SETUP_SESSION_RD_ATTR(data_seq_in_order, ISCSI_DATASEQ_INORDER_EN);
 	SETUP_SESSION_RD_ATTR(erl, ISCSI_ERL);
+	SETUP_PRIV_SESSION_RD_ATTR(recovery_tmo);
 
 	if (tt->param_mask & ISCSI_TARGET_NAME)
 		SETUP_SESSION_RD_ATTR(targetname, ISCSI_TARGET_NAME);
@@ -1408,6 +1534,7 @@ int iscsi_unregister_transport(struct is
 
 	transport_container_unregister(&priv->conn_cont);
 	transport_container_unregister(&priv->session_cont);
+	transport_container_unregister(&priv->t.host_attrs);
 
 	sysfs_remove_group(&priv->cdev.kobj, &iscsi_transport_group);
 	class_device_unregister(&priv->cdev);
@@ -1451,10 +1578,14 @@ static __init int iscsi_transport_init(v
 	if (err)
 		return err;
 
-	err = transport_class_register(&iscsi_connection_class);
+	err = transport_class_register(&iscsi_host_class);
 	if (err)
 		goto unregister_transport_class;
 
+	err = transport_class_register(&iscsi_connection_class);
+	if (err)
+		goto unregister_host_class;
+
 	err = transport_class_register(&iscsi_session_class);
 	if (err)
 		goto unregister_conn_class;
@@ -1482,6 +1613,8 @@ unregister_session_class:
 	transport_class_unregister(&iscsi_session_class);
 unregister_conn_class:
 	transport_class_unregister(&iscsi_connection_class);
+unregister_host_class:
+	transport_class_unregister(&iscsi_host_class);
 unregister_transport_class:
 	class_unregister(&iscsi_transport_class);
 	return err;
@@ -1494,6 +1627,7 @@ static void __exit iscsi_transport_exit(
 	netlink_unregister_notifier(&iscsi_nl_notifier);
 	transport_class_unregister(&iscsi_connection_class);
 	transport_class_unregister(&iscsi_session_class);
+	transport_class_unregister(&iscsi_host_class);
 	class_unregister(&iscsi_transport_class);
 }
 
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 774ad54..b14ba7a 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -174,6 +174,7 @@ enum iscsi_param {
 	ISCSI_PARAM_TPGT,
 	ISCSI_PARAM_PERSISTENT_ADDRESS,
 	ISCSI_PARAM_PERSISTENT_PORT,
+	ISCSI_PARAM_SESS_RECOVERY_TMO,
 
 	/* pased in through bind conn using transport_fd */
 	ISCSI_PARAM_CONN_PORT,
@@ -201,6 +202,7 @@ enum iscsi_param {
 #define ISCSI_TPGT			(1 << ISCSI_PARAM_TPGT)
 #define ISCSI_PERSISTENT_ADDRESS	(1 << ISCSI_PARAM_PERSISTENT_ADDRESS)
 #define ISCSI_PERSISTENT_PORT		(1 << ISCSI_PARAM_PERSISTENT_PORT)
+#define ISCSI_SESS_RECOVERY_TMO		(1 << ISCSI_PARAM_SESS_RECOVERY_TMO)
 #define ISCSI_CONN_PORT			(1 << ISCSI_PARAM_CONN_PORT)
 #define ISCSI_CONN_ADDRESS		(1 << ISCSI_PARAM_CONN_ADDRESS)
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 4b20064..9d2b991 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -90,6 +90,7 @@ struct iscsi_transport {
 			 char *data, uint32_t data_size);
 	void (*get_stats) (struct iscsi_cls_conn *conn,
 			   struct iscsi_stats *stats);
+	void (*session_recovery_timedout) (struct iscsi_cls_session *session);
 };
 
 /*
@@ -130,12 +131,20 @@ struct iscsi_cls_conn {
 
 struct iscsi_cls_session {
 	struct list_head sess_list;		/* item in session_list */
+	struct list_head host_list;
 	struct iscsi_transport *transport;
 
 	/* iSCSI values used as unique id by userspace. */
 	char *targetname;
 	int tpgt;
 
+	/* recovery fields */
+	int recovery_tmo;
+	struct work_struct recovery_work;
+
+	int target_id;
+	int channel;
+
 	int sid;				/* session id */
 	void *dd_data;				/* LLD private data */
 	struct device dev;	/* sysfs transport/container device */
@@ -147,15 +156,23 @@ struct iscsi_cls_session {
 #define iscsi_session_to_shost(_session) \
 	dev_to_shost(_session->dev.parent)
 
+struct iscsi_host {
+	int next_target_id;
+	struct list_head sessions;
+	struct mutex mutex;
+};
+
 /*
  * session and connection functions that can be used by HW iSCSI LLDs
  */
 extern struct iscsi_cls_session *iscsi_create_session(struct Scsi_Host *shost,
-				struct iscsi_transport *t);
+				struct iscsi_transport *t, int channel);
 extern int iscsi_destroy_session(struct iscsi_cls_session *session);
 extern struct iscsi_cls_conn *iscsi_create_conn(struct iscsi_cls_session *sess,
 					    uint32_t cid);
 extern int iscsi_destroy_conn(struct iscsi_cls_conn *conn);
+extern void iscsi_unblock_session(struct iscsi_cls_session *session);
+extern void iscsi_block_session(struct iscsi_cls_session *session);
 
 /*
  * session functions used by software iscsi


