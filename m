From: michaelc@cs.wisc.edu
Subject: [PATCH 04/13] iscsi_tcp: convert to new alloc_hdr api
Date: Tue,  2 Dec 2008 00:32:07 -0600
Message-ID: <1228199536-12595-5-git-send-email-michaelc@cs.wisc.edu>
References: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-2-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-3-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-4-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52416 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbYLBGcX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2008 01:32:23 -0500
In-Reply-To: <1228199536-12595-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This converts iscsi_tcp to the new api and modifies how
it handles r2ts.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |  249 ++++++++++++++++++++++------------------------
 drivers/scsi/iscsi_tcp.h |   21 +----
 2 files changed, 121 insertions(+), 149 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index d8066c0..739602e 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -57,13 +57,6 @@ MODULE_LICENSE("GPL");
 #define debug_tcp(fmt...)
 #endif
 
-#ifndef DEBUG_ASSERT
-#ifdef BUG_ON
-#undef BUG_ON
-#endif
-#define BUG_ON(expr)
-#endif
-
 static struct scsi_transport_template *iscsi_tcp_scsi_transport;
 static struct scsi_host_template iscsi_sht;
 static struct iscsi_transport iscsi_tcp_transport;
@@ -498,14 +491,13 @@ iscsi_tcp_data_recv_prep(struct iscsi_tcp_conn *tcp_conn)
 /*
  * must be called with session lock
  */
-static void
-iscsi_tcp_cleanup_task(struct iscsi_conn *conn, struct iscsi_task *task)
+static void iscsi_tcp_cleanup_task(struct iscsi_task *task)
 {
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct iscsi_r2t_info *r2t;
 
-	/* nothing to do for mgmt tasks */
-	if (!task->sc)
+	/* nothing to do for mgmt or pending tasks */
+	if (!task->sc || task->state == ISCSI_TASK_PENDING)
 		return;
 
 	/* flush task's r2t queues */
@@ -611,11 +603,11 @@ iscsi_solicit_data_init(struct iscsi_conn *conn, struct iscsi_task *task,
 static int
 iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 {
-	struct iscsi_r2t_info *r2t;
 	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_r2t_rsp *rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
+	struct iscsi_r2t_info *r2t;
 	int r2tsn = be32_to_cpu(rhdr->r2tsn);
 	int rc;
 
@@ -643,7 +635,12 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 	}
 
 	rc = __kfifo_get(tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
-	BUG_ON(!rc);
+	if (!rc) {
+		iscsi_conn_printk(KERN_ERR, conn, "Could not allocate R2T. "
+				  "Target has sent more R2Ts than it "
+				  "negotiated for or driver has has leaked.\n");
+		return ISCSI_ERR_PROTO;
+	}
 
 	r2t->exp_statsn = rhdr->statsn;
 	r2t->data_length = be32_to_cpu(rhdr->data_length);
@@ -672,9 +669,8 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 	}
 
 	r2t->ttt = rhdr->ttt; /* no flip */
-	r2t->solicit_datasn = 0;
-
-	iscsi_solicit_data_init(conn, task, r2t);
+	r2t->datasn = 0;
+	r2t->sent = 0;
 
 	tcp_task->exp_datasn = r2tsn + 1;
 	__kfifo_put(tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
@@ -1199,9 +1195,9 @@ iscsi_tcp_xmit_qlen(struct iscsi_conn *conn)
 	return segment->total_copied - segment->total_size;
 }
 
-static inline int
-iscsi_tcp_flush(struct iscsi_conn *conn)
+static int iscsi_tcp_flush(struct iscsi_task *task)
 {
+	struct iscsi_conn *conn = task->conn;
 	int rc;
 
 	while (iscsi_tcp_xmit_qlen(conn)) {
@@ -1364,14 +1360,49 @@ iscsi_solicit_data_cont(struct iscsi_conn *conn, struct iscsi_task *task,
 	return 1;
 }
 
+static int iscsi_tcp_pdu_init(struct iscsi_task *task,
+			      unsigned int offset, unsigned int count)
+{
+	struct iscsi_conn *conn = task->conn;
+	int err = 0;
+
+	iscsi_tcp_send_hdr_prep(conn, task->hdr, task->hdr_len);
+
+	if (!count)
+		return 0;
+
+	if (!task->sc)
+		iscsi_tcp_send_linear_data_prepare(conn, task->data, count);
+	else {
+		struct scsi_data_buffer *sdb = scsi_out(task->sc);
+
+		err = iscsi_tcp_send_data_prep(conn, sdb->table.sgl,
+					       sdb->table.nents, offset, count);
+	}
+
+	if (err) {
+		iscsi_conn_failure(conn, err);
+		return -EIO;
+	}
+	return 0;
+}
+
+static int iscsi_tcp_pdu_alloc(struct iscsi_task *task)
+{
+	struct iscsi_tcp_task *tcp_task = task->dd_data;
+
+	task->hdr = &tcp_task->hdr.hdrbuf;
+	task->hdr_max = sizeof(tcp_task->hdr) - ISCSI_DIGEST_SIZE;
+	return 0;
+}
+
 /**
  * iscsi_tcp_task - Initialize iSCSI SCSI_READ or SCSI_WRITE commands
  * @conn: iscsi connection
  * @task: scsi command task
  * @sc: scsi command
  **/
-static int
-iscsi_tcp_task_init(struct iscsi_task *task)
+static int iscsi_tcp_task_init(struct iscsi_task *task)
 {
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct iscsi_conn *conn = task->conn;
@@ -1386,40 +1417,57 @@ iscsi_tcp_task_init(struct iscsi_task *task)
 		debug_scsi("mtask deq [cid %d itt 0x%x]\n", conn->id,
 			   task->itt);
 
-		/* Prepare PDU, optionally w/ immediate data */
-		iscsi_tcp_send_hdr_prep(conn, task->hdr, sizeof(*task->hdr));
-
-		/* If we have immediate data, attach a payload */
-		if (task->data_count)
-			iscsi_tcp_send_linear_data_prepare(conn, task->data,
-							   task->data_count);
-		return 0;
+		return conn->session->tt->init_pdu(task, 0, task->data_count);
 	}
 
 	BUG_ON(__kfifo_len(tcp_task->r2tqueue));
-	tcp_task->sent = 0;
 	tcp_task->exp_datasn = 0;
 
 	/* Prepare PDU, optionally w/ immediate data */
 	debug_scsi("task deq [cid %d itt 0x%x imm %d unsol %d]\n",
 		    conn->id, task->itt, task->imm_count,
-		    task->unsol_count);
-	iscsi_tcp_send_hdr_prep(conn, task->hdr, task->hdr_len);
+		    task->unsol_r2t.data_length);
 
-	if (!task->imm_count)
-		return 0;
-
-	/* If we have immediate data, attach a payload */
-	err = iscsi_tcp_send_data_prep(conn, scsi_out(sc)->table.sgl,
-				       scsi_out(sc)->table.nents,
-				       0, task->imm_count);
+	err = conn->session->tt->init_pdu(task, 0, task->imm_count);
 	if (err)
 		return err;
-	tcp_task->sent += task->imm_count;
 	task->imm_count = 0;
 	return 0;
 }
 
+static struct iscsi_r2t_info *iscsi_tcp_get_curr_r2t(struct iscsi_task *task)
+{
+	struct iscsi_session *session = task->conn->session;
+	struct iscsi_tcp_task *tcp_task = task->dd_data;
+	struct iscsi_r2t_info *r2t = NULL;
+
+	if (iscsi_task_has_unsol_data(task))
+		r2t = &task->unsol_r2t;
+	else {
+		spin_lock_bh(&session->lock);
+		if (tcp_task->r2t) {
+			r2t = tcp_task->r2t;
+			/* Continue with this R2T? */
+			if (r2t->data_length <= r2t->sent) {
+				debug_scsi("  done with r2t %p\n", r2t);
+				__kfifo_put(tcp_task->r2tpool.queue,
+					    (void *)&tcp_task->r2t,
+					    sizeof(void *));
+				tcp_task->r2t = r2t = NULL;
+			}
+		}
+
+		if (r2t == NULL) {
+			__kfifo_get(tcp_task->r2tqueue,
+				    (void *)&tcp_task->r2t, sizeof(void *));
+			r2t = tcp_task->r2t;
+		}
+		spin_unlock_bh(&session->lock);
+	}
+
+	return r2t;
+}
+
 /*
  * iscsi_tcp_task_xmit - xmit normal PDU task
  * @task: iscsi command task
@@ -1428,108 +1476,52 @@ iscsi_tcp_task_init(struct iscsi_task *task)
  * -EAGAIN if there's still data in the queue, or != 0 for any other kind
  * of error.
  */
-static int
-iscsi_tcp_task_xmit(struct iscsi_task *task)
+static int iscsi_tcp_task_xmit(struct iscsi_task *task)
 {
 	struct iscsi_conn *conn = task->conn;
-	struct iscsi_tcp_task *tcp_task = task->dd_data;
-	struct scsi_cmnd *sc = task->sc;
-	struct scsi_data_buffer *sdb;
+	struct iscsi_session *session = conn->session;
+	struct iscsi_r2t_info *r2t;
 	int rc = 0;
 
 flush:
 	/* Flush any pending data first. */
-	rc = iscsi_tcp_flush(conn);
+	rc = session->tt->xmit_pdu(task);
 	if (rc < 0)
 		return rc;
 
 	/* mgmt command */
-	if (!sc) {
+	if (!task->sc) {
 		if (task->hdr->itt == RESERVED_ITT)
 			iscsi_put_task(task);
 		return 0;
 	}
 
 	/* Are we done already? */
-	if (sc->sc_data_direction != DMA_TO_DEVICE)
+	if (task->sc->sc_data_direction != DMA_TO_DEVICE)
 		return 0;
 
-	sdb = scsi_out(sc);
-	if (task->unsol_count != 0) {
-		struct iscsi_data *hdr = &tcp_task->unsol_dtask.hdr;
-
-		/* Prepare a header for the unsolicited PDU.
-		 * The amount of data we want to send will be
-		 * in task->data_count.
-		 * FIXME: return the data count instead.
-		 */
-		iscsi_prep_unsolicit_data_pdu(task, hdr);
-
-		debug_tcp("unsol dout [itt 0x%x doff %d dlen %d]\n",
-				task->itt, tcp_task->sent, task->data_count);
-
-		iscsi_tcp_send_hdr_prep(conn, hdr, sizeof(*hdr));
-		rc = iscsi_tcp_send_data_prep(conn, sdb->table.sgl,
-					      sdb->table.nents, tcp_task->sent,
-					      task->data_count);
-		if (rc)
-			goto fail;
-		tcp_task->sent += task->data_count;
-		task->unsol_count -= task->data_count;
-		goto flush;
-	} else {
-		struct iscsi_session *session = conn->session;
-		struct iscsi_r2t_info *r2t;
-
-		/* All unsolicited PDUs sent. Check for solicited PDUs.
-		 */
-		spin_lock_bh(&session->lock);
-		r2t = tcp_task->r2t;
-		if (r2t != NULL) {
-			/* Continue with this R2T? */
-			if (!iscsi_solicit_data_cont(conn, task, r2t)) {
-				debug_scsi("  done with r2t %p\n", r2t);
-
-				__kfifo_put(tcp_task->r2tpool.queue,
-					    (void*)&r2t, sizeof(void*));
-				tcp_task->r2t = r2t = NULL;
-			}
-		}
-
-		if (r2t == NULL) {
-			__kfifo_get(tcp_task->r2tqueue, (void*)&tcp_task->r2t,
-				    sizeof(void*));
-			r2t = tcp_task->r2t;
-		}
-		spin_unlock_bh(&session->lock);
-
+	r2t = iscsi_tcp_get_curr_r2t(task);
+	if (r2t == NULL) {
 		/* Waiting for more R2Ts to arrive. */
-		if (r2t == NULL) {
-			debug_tcp("no R2Ts yet\n");
-			return 0;
-		}
+		debug_tcp("no R2Ts yet\n");
+		return 0;
+	}
 
-		debug_scsi("sol dout %p [dsn %d itt 0x%x doff %d dlen %d]\n",
-			r2t, r2t->solicit_datasn - 1, task->itt,
-			r2t->data_offset + r2t->sent, r2t->data_count);
+	rc = conn->session->tt->alloc_pdu(task);
+	if (rc)
+		return rc;
+	iscsi_prep_data_out_pdu(task, r2t, (struct iscsi_data *) task->hdr);
 
-		iscsi_tcp_send_hdr_prep(conn, &r2t->dtask.hdr,
-					sizeof(struct iscsi_hdr));
+	debug_scsi("sol dout %p [dsn %d itt 0x%x doff %d dlen %d]\n",
+		   r2t, r2t->datasn - 1, task->hdr->itt,
+		   r2t->data_offset + r2t->sent, r2t->data_count);
 
-		rc = iscsi_tcp_send_data_prep(conn, sdb->table.sgl,
-					      sdb->table.nents,
-					      r2t->data_offset + r2t->sent,
-					      r2t->data_count);
-		if (rc)
-			goto fail;
-		tcp_task->sent += r2t->data_count;
-		r2t->sent += r2t->data_count;
-		goto flush;
-	}
-	return 0;
-fail:
-	iscsi_conn_failure(conn, rc);
-	return -EIO;
+	rc = conn->session->tt->init_pdu(task, r2t->data_offset + r2t->sent,
+					 r2t->data_count);
+	if (rc)
+		return rc;
+	r2t->sent += r2t->data_count;
+	goto flush;
 }
 
 static struct iscsi_cls_conn *
@@ -1751,13 +1743,14 @@ iscsi_r2tpool_alloc(struct iscsi_session *session)
 		struct iscsi_tcp_task *tcp_task = task->dd_data;
 
 		/*
-		 * pre-allocated x4 as much r2ts to handle race when
+		 * pre-allocated x2 as much r2ts to handle race when
 		 * target acks DataOut faster than we data_xmit() queues
 		 * could replenish r2tqueue.
 		 */
 
 		/* R2T pool */
-		if (iscsi_pool_init(&tcp_task->r2tpool, session->max_r2t * 4, NULL,
+		if (iscsi_pool_init(&tcp_task->r2tpool,
+				    session->max_r2t * 2, NULL,
 				    sizeof(struct iscsi_r2t_info))) {
 			goto r2t_alloc_fail;
 		}
@@ -1891,7 +1884,6 @@ iscsi_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
 	struct Scsi_Host *shost;
-	int cmd_i;
 
 	if (ep) {
 		printk(KERN_ERR "iscsi_tcp: invalid ep %p.\n", ep);
@@ -1919,14 +1911,6 @@ iscsi_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	session = cls_session->dd_data;
 
 	shost->can_queue = session->scsi_cmds_max;
-	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
-		struct iscsi_task *task = session->cmds[cmd_i];
-		struct iscsi_tcp_task *tcp_task = task->dd_data;
-
-		task->hdr = &tcp_task->hdr.cmd_hdr;
-		task->hdr_max = sizeof(tcp_task->hdr) - ISCSI_DIGEST_SIZE;
-	}
-
 	if (iscsi_r2tpool_alloc(session))
 		goto remove_session;
 	return cls_session;
@@ -2026,9 +2010,14 @@ static struct iscsi_transport iscsi_tcp_transport = {
 	/* IO */
 	.send_pdu		= iscsi_conn_send_pdu,
 	.get_stats		= iscsi_conn_get_stats,
+	/* iscsi task/cmd helpers */
 	.init_task		= iscsi_tcp_task_init,
 	.xmit_task		= iscsi_tcp_task_xmit,
 	.cleanup_task		= iscsi_tcp_cleanup_task,
+	/* low level pdu helpers */
+	.xmit_pdu		= iscsi_tcp_flush,
+	.init_pdu		= iscsi_tcp_pdu_init,
+	.alloc_pdu		= iscsi_tcp_pdu_alloc,
 	/* recovery */
 	.session_recovery_timedout = iscsi_session_recovery_timedout,
 };
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 498d8ca..0ed4773 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -98,25 +98,9 @@ struct iscsi_tcp_conn {
 	ssize_t (*sendpage)(struct socket *, struct page *, int, size_t, int);
 };
 
-struct iscsi_data_task {
-	struct iscsi_data	hdr;			/* PDU */
-	char			hdrext[ISCSI_DIGEST_SIZE];/* Header-Digest */
-};
-
-struct iscsi_r2t_info {
-	__be32			ttt;		/* copied from R2T */
-	__be32			exp_statsn;	/* copied from R2T */
-	uint32_t		data_length;	/* copied from R2T */
-	uint32_t		data_offset;	/* copied from R2T */
-	int			sent;		/* R2T sequence progress */
-	int			data_count;	/* DATA-Out payload progress */
-	int			solicit_datasn;
-	struct iscsi_data_task	dtask;		/* Data-Out header buf */
-};
-
 struct iscsi_tcp_task {
 	struct iscsi_hdr_buff {
-		struct iscsi_cmd	cmd_hdr;
+		struct iscsi_hdr	hdrbuf;
 		char			hdrextbuf[ISCSI_MAX_AHS_SIZE +
 		                                  ISCSI_DIGEST_SIZE];
 	} hdr;
@@ -124,10 +108,9 @@ struct iscsi_tcp_task {
 	int			sent;
 	uint32_t		exp_datasn;	/* expected target's R2TSN/DataSN */
 	int			data_offset;
-	struct iscsi_r2t_info	*r2t;		/* in progress R2T    */
+	struct iscsi_r2t_info	*r2t;		/* in progress solict R2T */
 	struct iscsi_pool	r2tpool;
 	struct kfifo		*r2tqueue;
-	struct iscsi_data_task	unsol_dtask;	/* Data-Out header buf */
 };
 
 #endif /* ISCSI_H */
-- 
1.5.6.5

