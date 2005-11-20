From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 4/5 RESEND] covert iscsi_tcp
Date: Sun, 20 Nov 2005 15:28:12 -0600
Message-ID: <1132522093.7983.21.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:6786 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932117AbVKTV2d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Nov 2005 16:28:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.orglinux-scsi@vger.kernel.org

convert open-iscsi to use new class/lib functions.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff -aurp linux-2.6.15-rc2/drivers/scsi/iscsi_tcp.c linux-2.6.15-rc2.diff/drivers/scsi/iscsi_tcp.c
--- linux-2.6.15-rc2/drivers/scsi/iscsi_tcp.c	2005-11-19 21:25:03.000000000 -0600
+++ linux-2.6.15-rc2.diff/drivers/scsi/iscsi_tcp.c	2005-11-20 15:10:15.000000000 -0600
@@ -314,8 +314,8 @@ out:
 	debug_scsi("done [sc %lx res %d itt 0x%x]\n",
 		   (long)sc, sc->result, ctask->itt);
 	conn->scsirsp_pdus_cnt++;
+	ctask->done(sc);
 	iscsi_ctask_cleanup(conn, ctask);
-	sc->scsi_done(sc);
 	return rc;
 }
 
@@ -988,8 +988,8 @@ done:
 		debug_scsi("done [sc %lx res %d itt 0x%x]\n",
 			   (long)sc, sc->result, ctask->itt);
 		conn->scsirsp_pdus_cnt++;
+		ctask->done(sc);
 		iscsi_ctask_cleanup(conn, ctask);
-		sc->scsi_done(sc);
 	}
 
 	return rc;
@@ -2296,14 +2296,8 @@ iscsi_xmitworker(void *data)
 	up(&conn->xmitsema);
 }
 
-#define FAILURE_BAD_HOST		1
-#define FAILURE_SESSION_FAILED		2
-#define FAILURE_SESSION_FREED		3
-#define FAILURE_WINDOW_CLOSED		4
-#define FAILURE_SESSION_TERMINATE	5
-
 static int
-iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
+iscsi_execute_task(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 {
 	struct Scsi_Host *host;
 	int reason = 0;
@@ -2311,7 +2305,6 @@ iscsi_queuecommand(struct scsi_cmnd *sc,
 	struct iscsi_conn *conn = NULL;
 	struct iscsi_cmd_task *ctask = NULL;
 
-	sc->scsi_done = done;
 	sc->result = 0;
 
 	host = sc->device->host;
@@ -2322,13 +2315,13 @@ iscsi_queuecommand(struct scsi_cmnd *sc,
 
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
 		if (session->state == ISCSI_STATE_FAILED) {
-			reason = FAILURE_SESSION_FAILED;
+			reason = ISCSI_FAILURE_SESSION_FAILED;
 			goto reject;
 		} else if (session->state == ISCSI_STATE_TERMINATE) {
-			reason = FAILURE_SESSION_TERMINATE;
+			reason = ISCSI_FAILURE_SESSION_TERMINATE;
 			goto fault;
 		}
-		reason = FAILURE_SESSION_FREED;
+		reason = ISCSI_FAILURE_SESSION_FREED;
 		goto fault;
 	}
 
@@ -2336,7 +2329,7 @@ iscsi_queuecommand(struct scsi_cmnd *sc,
 	 * Check for iSCSI window and take care of CmdSN wrap-around
 	 */
 	if ((int)(session->max_cmdsn - session->cmdsn) < 0) {
-		reason = FAILURE_WINDOW_CLOSED;
+		reason = ISCSI_FAILURE_WINDOW_CLOSED;
 		goto reject;
 	}
 
@@ -2345,6 +2338,7 @@ iscsi_queuecommand(struct scsi_cmnd *sc,
 	__kfifo_get(session->cmdpool.queue, (void*)&ctask, sizeof(void*));
 	BUG_ON(ctask->sc);
 
+	ctask->done = done;
 	sc->SCp.phase = session->age;
 	sc->SCp.ptr = (char*)ctask;
 	iscsi_cmd_init(conn, ctask, sc);
@@ -2356,36 +2350,20 @@ iscsi_queuecommand(struct scsi_cmnd *sc,
 		conn->id, (long)sc, ctask->itt, sc->request_bufflen,
 		session->cmdsn, session->max_cmdsn - session->exp_cmdsn + 1);
 	spin_unlock(&session->lock);
-
-        if (!in_interrupt() && !down_trylock(&conn->xmitsema)) {
-		spin_unlock_irq(host->host_lock);
-		if (iscsi_data_xmit(conn))
-			schedule_work(&conn->xmitwork);
-		up(&conn->xmitsema);
-		spin_lock_irq(host->host_lock);
-	} else
-		schedule_work(&conn->xmitwork);
+	schedule_work(&conn->xmitwork);
 
 	return 0;
 
 reject:
 	spin_unlock(&session->lock);
 	debug_scsi("cmd 0x%x rejected (%d)\n", sc->cmnd[0], reason);
-	return SCSI_MLQUEUE_HOST_BUSY;
+	return reason;
 
 fault:
 	spin_unlock(&session->lock);
 	printk(KERN_ERR "iscsi_tcp: cmd 0x%x is not queued (%d)\n",
 	       sc->cmnd[0], reason);
-	sc->sense_buffer[0] = 0x70;
-	sc->sense_buffer[2] = NOT_READY;
-	sc->sense_buffer[7] = 0x6;
-	sc->sense_buffer[12] = 0x08;
-	sc->sense_buffer[13] = 0x00;
-	sc->result = (DID_NO_CONNECT << 16);
-	sc->resid = sc->request_bufflen;
-	sc->scsi_done(sc);
-	return 0;
+	return reason;
 }
 
 static int
@@ -2443,17 +2421,13 @@ iscsi_pool_free(struct iscsi_queue *q, v
 	kfree(items);
 }
 
-static iscsi_connh_t
-iscsi_conn_create(iscsi_sessionh_t sessionh, uint32_t conn_idx)
+static int 
+iscsi_conn_create(struct Scsi_Host *shost, void *conndata, uint32_t conn_idx)
 {
-	struct iscsi_session *session = iscsi_ptr(sessionh);
-	struct iscsi_conn *conn = NULL;
+	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
+	struct iscsi_conn *conn = conndata;
 
-	conn = kmalloc(sizeof(struct iscsi_conn), GFP_KERNEL);
-	if (conn == NULL)
-		goto conn_alloc_fail;
 	memset(conn, 0, sizeof(struct iscsi_conn));
-
 	conn->c_stage = ISCSI_CONN_INITIAL_STAGE;
 	conn->in_progress = IN_PROGRESS_WAIT_HEADER;
 	conn->id = conn_idx;
@@ -2515,7 +2489,7 @@ iscsi_conn_create(iscsi_sessionh_t sessi
 	init_MUTEX(&conn->xmitsema);
 	init_waitqueue_head(&conn->ehwait);
 
-	return iscsi_handle(conn);
+	return 0;
 
 max_recv_dlenght_alloc_fail:
 	spin_lock_bh(&session->lock);
@@ -2531,15 +2505,13 @@ immqueue_alloc_fail:
 writequeue_alloc_fail:
 	kfifo_free(conn->xmitqueue);
 xmitqueue_alloc_fail:
-	kfree(conn);
-conn_alloc_fail:
-	return iscsi_handle(NULL);
+	return -ENOMEM;
 }
 
 static void
-iscsi_conn_destroy(iscsi_connh_t connh)
+iscsi_conn_destroy(void *data)
 {
-	struct iscsi_conn *conn = iscsi_ptr(connh);
+	struct iscsi_conn *conn = data;
 	struct iscsi_session *session = conn->session;
 
 	down(&conn->xmitsema);
@@ -2633,7 +2605,6 @@ iscsi_conn_destroy(iscsi_connh_t connh)
 	kfifo_free(conn->writequeue);
 	kfifo_free(conn->immqueue);
 	kfifo_free(conn->mgmtqueue);
-	kfree(conn);
 }
 
 static int
@@ -2769,7 +2740,6 @@ iscsi_conn_stop(iscsi_connh_t connh, int
 	struct iscsi_conn *conn = iscsi_ptr(connh);
 	struct iscsi_session *session = conn->session;
 	struct sock *sk;
-	unsigned long flags;
 
 	BUG_ON(!conn->sock);
 	sk = conn->sock->sk;
@@ -2779,7 +2749,6 @@ iscsi_conn_stop(iscsi_connh_t connh, int
 
 	down(&conn->xmitsema);
 
-	spin_lock_irqsave(session->host->host_lock, flags);
 	spin_lock(&session->lock);
 	conn->stop_stage = flag;
 	conn->c_stage = ISCSI_CONN_STOPPED;
@@ -2792,7 +2761,6 @@ iscsi_conn_stop(iscsi_connh_t connh, int
 		session->state = ISCSI_STATE_FAILED;
 
 	spin_unlock(&session->lock);
-	spin_unlock_irqrestore(session->host->host_lock, flags);
 
 	if (flag == STOP_CONN_TERM || flag == STOP_CONN_RECOVER) {
 		struct iscsi_cmd_task *ctask;
@@ -3247,7 +3215,7 @@ iscsi_r2tpool_free(struct iscsi_session 
 static struct scsi_host_template iscsi_sht = {
 	.name			= "iSCSI Initiator over TCP/IP, v."
 				  ISCSI_VERSION_STR,
-        .queuecommand           = iscsi_queuecommand,
+        .queuecommand           = iscsi_scsi_queuecmd,
 	.can_queue		= ISCSI_XMIT_CMDS_MAX - 1,
 	.sg_tablesize		= ISCSI_SG_TABLESIZE,
 	.cmd_per_lun		= ISCSI_CMD_PER_LUN,
@@ -3258,17 +3226,15 @@ static struct scsi_host_template iscsi_s
 	.this_id		= -1,
 };
 
-static iscsi_sessionh_t
-iscsi_session_create(uint32_t initial_cmdsn, struct Scsi_Host *host)
+static int
+iscsi_session_create(struct iscsi_host *ihost, struct Scsi_Host *shost,
+		     uint32_t initial_cmdsn)
 {
+	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
 	int cmd_i;
-	struct iscsi_session *session;
 
-	session = iscsi_hostdata(host->hostdata);
 	memset(session, 0, sizeof(struct iscsi_session));
-
-	session->host = host;
-	session->id = host->host_no;
+	session->host =  shost;
 	session->state = ISCSI_STATE_LOGGED_IN;
 	session->mgmtpool_max = ISCSI_MGMT_CMDS_MAX;
 	session->cmds_max = ISCSI_XMIT_CMDS_MAX;
@@ -3312,7 +3278,7 @@ iscsi_session_create(uint32_t initial_cm
 	if (iscsi_r2tpool_alloc(session))
 		goto r2tpool_alloc_fail;
 
-	return iscsi_handle(session);
+	return 0;
 
 r2tpool_alloc_fail:
 	for (cmd_i = 0; cmd_i < session->mgmtpool_max; cmd_i++)
@@ -3322,15 +3288,15 @@ immdata_alloc_fail:
 mgmtpool_alloc_fail:
 	iscsi_pool_free(&session->cmdpool, (void**)session->cmds);
 cmdpool_alloc_fail:
-	return iscsi_handle(NULL);
+	return -ENOMEM;
 }
 
 static void
-iscsi_session_destroy(iscsi_sessionh_t sessionh)
+iscsi_session_destroy(struct iscsi_host *ihost, struct Scsi_Host *shost)
 {
+	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
 	int cmd_i;
 	struct iscsi_data_task *dtask, *n;
-	struct iscsi_session *session = iscsi_ptr(sessionh);
 
 	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
 		struct iscsi_cmd_task *ctask = session->cmds[cmd_i];
@@ -3492,25 +3458,12 @@ iscsi_conn_set_param(iscsi_connh_t connh
 }
 
 static int
-iscsi_conn_get_param(iscsi_connh_t connh, enum iscsi_param param,
-		     uint32_t *value)
+iscsi_session_get_param(struct Scsi_Host *shost,
+			enum iscsi_param param, uint32_t *value)
 {
-	struct iscsi_conn *conn = iscsi_ptr(connh);
-	struct iscsi_session *session = conn->session;
+	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
 
 	switch(param) {
-	case ISCSI_PARAM_MAX_RECV_DLENGTH:
-		*value = conn->max_recv_dlength;
-		break;
-	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
-		*value = conn->max_xmit_dlength;
-		break;
-	case ISCSI_PARAM_HDRDGST_EN:
-		*value = conn->hdrdgst_en;
-		break;
-	case ISCSI_PARAM_DATADGST_EN:
-		*value = conn->datadgst_en;
-		break;
 	case ISCSI_PARAM_INITIAL_R2T_EN:
 		*value = session->initial_r2t_en;
 		break;
@@ -3548,6 +3501,31 @@ iscsi_conn_get_param(iscsi_connh_t connh
 	return 0;
 }
 
+static int
+iscsi_conn_get_param(void *data, enum iscsi_param param, uint32_t *value)
+{
+	struct iscsi_conn *conn = data;
+
+	switch(param) {
+	case ISCSI_PARAM_MAX_RECV_DLENGTH:
+		*value = conn->max_recv_dlength;
+		break;
+	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
+		*value = conn->max_xmit_dlength;
+		break;
+	case ISCSI_PARAM_HDRDGST_EN:
+		*value = conn->hdrdgst_en;
+		break;
+	case ISCSI_PARAM_DATADGST_EN:
+		*value = conn->datadgst_en;
+		break;
+	default:
+		return ISCSI_ERR_PARAM_NOT_FOUND;
+	}
+
+	return 0;
+}
+
 static void
 iscsi_conn_get_stats(iscsi_connh_t connh, struct iscsi_stats *stats)
 {
@@ -3592,6 +3570,7 @@ static struct iscsi_transport iscsi_tcp_
 				  | CAP_DATADGST,
 	.host_template		= &iscsi_sht,
 	.hostdata_size		= sizeof(struct iscsi_session),
+	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_conn		= 1,
 	.max_cmd_len		= ISCSI_TCP_MAX_CMD_LEN,
 	.create_session		= iscsi_session_create,
@@ -3600,18 +3579,21 @@ static struct iscsi_transport iscsi_tcp_
 	.bind_conn		= iscsi_conn_bind,
 	.destroy_conn		= iscsi_conn_destroy,
 	.set_param		= iscsi_conn_set_param,
-	.get_param		= iscsi_conn_get_param,
+	.get_conn_param		= iscsi_conn_get_param,
+	.get_session_param	= iscsi_session_get_param,
 	.start_conn		= iscsi_conn_start,
 	.stop_conn		= iscsi_conn_stop,
 	.send_pdu		= iscsi_conn_send_pdu,
 	.get_stats		= iscsi_conn_get_stats,
+	.execute_task		= iscsi_execute_task,
 };
 
+static struct scsi_transport_template *scsi_transport;
+static struct iscsi_host *ihost;
+
 static int __init
 iscsi_tcp_init(void)
 {
-	int error;
-
 	if (iscsi_max_lun < 1) {
 		printk(KERN_ERR "Invalid max_lun value of %u\n", iscsi_max_lun);
 		return -EINVAL;
@@ -3624,16 +3606,34 @@ iscsi_tcp_init(void)
 	if (!taskcache)
 		return -ENOMEM;
 
-	error = iscsi_register_transport(&iscsi_tcp_transport);
-	if (error)
-		kmem_cache_destroy(taskcache);
+	scsi_transport = iscsi_register_transport(&iscsi_tcp_transport);
+	if (!scsi_transport)
+		goto free_task_cache;
 
-	return error;
+	ihost = iscsi_alloc_iscsi_host(&iscsi_tcp_transport, scsi_transport);
+	if (!ihost)
+		goto unregister_transport;
+
+	if (iscsi_add_iscsi_host(ihost, NULL, "iscsi_tcp"))
+		goto free_iscsi_host;
+
+	return 0;
+
+free_iscsi_host:
+	iscsi_host_put(ihost);
+unregister_transport:
+	iscsi_unregister_transport(&iscsi_tcp_transport);
+free_task_cache:
+	kmem_cache_destroy(taskcache);
+	return -ENOMEM;
 }
 
 static void __exit
 iscsi_tcp_exit(void)
 {
+	iscsi_remove_iscsi_host(ihost);
+	iscsi_host_put(ihost);
+
 	iscsi_unregister_transport(&iscsi_tcp_transport);
 	kmem_cache_destroy(taskcache);
 }
diff -aurp linux-2.6.15-rc2/drivers/scsi/iscsi_tcp.h linux-2.6.15-rc2.diff/drivers/scsi/iscsi_tcp.h
--- linux-2.6.15-rc2/drivers/scsi/iscsi_tcp.h	2005-11-19 21:25:03.000000000 -0600
+++ linux-2.6.15-rc2.diff/drivers/scsi/iscsi_tcp.h	2005-11-20 15:10:15.000000000 -0600
@@ -214,7 +214,6 @@ struct iscsi_session {
 
 	/* control data */
 	struct Scsi_Host	*host;
-	int			id;
 	struct iscsi_conn	*leadconn;	/* leading connection */
 	spinlock_t		lock;		/* protects session state, *
 						 * sequence numbers,       *
@@ -317,6 +316,7 @@ struct iscsi_cmd_task {
 	struct iscsi_buf	immbuf;			/* for imm data digest */
 	struct iscsi_data_task   *dtask;		/* data task in progress*/
 	int			digest_offset;		/* for partial buff digest */
+	void			(*done)(struct scsi_cmnd *); /* completion fn */
 };
 
 #endif /* ISCSI_H */


