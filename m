From: michaelc@cs.wisc.edu
Subject: [PATCH 23/25] libiscsi, iser, tcp: remove recv_lock
Date: Wed, 21 May 2008 15:54:18 -0500
Message-ID: <1211403260-5487-24-git-send-email-michaelc@cs.wisc.edu>
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
 <1211403260-5487-11-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-12-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-13-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-14-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-15-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-16-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-17-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-18-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-19-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-20-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-21-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-22-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-23-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708AbYEUUyj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:39 -0400
In-Reply-To: <1211403260-5487-23-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The recv lock was defined so the iscsi layer could block
the recv path from processing IO during recovery. It
turns out iser just set a lock to that pointer which was pointless.

We now disconnect the transport connection before doing recovery
so we do not need the recv lock. For iscsi_tcp we still stop
the recv path incase older tools are being used.

This patch also has iscsi_itt_to_ctask user grab the session lock
and has the caller access the task with the lock or get a ref
to it in case the target is broken and sends a tmf success response
then sends data or a response for the command that was supposed to
be affected bty the tmf.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |   20 ++--
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    2 -
 drivers/infiniband/ulp/iser/iser_initiator.c |    6 +
 drivers/scsi/iscsi_tcp.c                     |   73 +++++++------
 drivers/scsi/libiscsi.c                      |  152 +++++++++++++++-----------
 include/scsi/libiscsi.h                      |    8 +-
 6 files changed, 144 insertions(+), 117 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 08edbaf..c02eabd 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -281,9 +281,6 @@ iscsi_iser_conn_create(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 	conn->max_recv_dlength = 128;
 
 	iser_conn = conn->dd_data;
-	/* currently this is the only field which need to be initiated */
-	rwlock_init(&iser_conn->lock);
-
 	conn->dd_data = iser_conn;
 	iser_conn->iscsi_conn = conn;
 
@@ -342,9 +339,6 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 	ib_conn->iser_conn = iser_conn;
 	iser_conn->ib_conn  = ib_conn;
 	iser_conn_get(ib_conn);
-
-	conn->recv_lock = &iser_conn->lock;
-
 	return 0;
 }
 
@@ -355,12 +349,18 @@ iscsi_iser_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;
 	struct iser_conn *ib_conn = iser_conn->ib_conn;
 
-	iscsi_conn_stop(cls_conn, flag);
 	/*
-	 * There is no unbind event so the stop callback
-	 * must release the ref from the bind.
+	 * Userspace may have goofed up and not bound the connection or
+	 * might have only partially setup the connection.
 	 */
-	iser_conn_put(ib_conn);
+	if (ib_conn) {
+		iscsi_conn_stop(cls_conn, flag);
+		/*
+		 * There is no unbind event so the stop callback
+		 * must release the ref from the bind.
+		 */
+		iser_conn_put(ib_conn);
+	}
 	iser_conn->ib_conn = NULL;
 }
 
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index cdf4876..a547ede 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -263,8 +263,6 @@ struct iser_conn {
 struct iscsi_iser_conn {
 	struct iscsi_conn            *iscsi_conn;/* ptr to iscsi conn */
 	struct iser_conn             *ib_conn;   /* iSER IB conn      */
-
-	rwlock_t		     lock;
 };
 
 struct iscsi_iser_task {
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 35af60a..c360839 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -558,7 +558,12 @@ void iser_rcv_completion(struct iser_desc *rx_desc,
 	opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 
 	if (opcode == ISCSI_OP_SCSI_CMD_RSP) {
+		spin_lock(&conn->iscsi_conn->session->lock);
 		task = iscsi_itt_to_ctask(conn->iscsi_conn, hdr->itt);
+		if (task)
+			__iscsi_get_task(task);
+		spin_unlock(&conn->iscsi_conn->session->lock);
+
 		if (!task)
 			iser_err("itt can't be matched to task!!! "
 				 "conn %p opcode %d itt %d\n",
@@ -568,6 +573,7 @@ void iser_rcv_completion(struct iser_desc *rx_desc,
 			iser_dbg("itt %d task %p\n",hdr->itt, task);
 			iser_task->status = ISER_TASK_STATUS_COMPLETED;
 			iser_task_rdma_finalize(iser_task);
+			iscsi_put_task(task);
 		}
 	}
 	iser_dto_buffs_release(dto);
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 7552dd8..af7ee45 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -741,7 +741,6 @@ static int
 iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 {
 	int rc = 0, opcode, ahslen;
-	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_task *task;
 
@@ -770,17 +769,17 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 
 	switch(opcode) {
 	case ISCSI_OP_SCSI_DATA_IN:
+		spin_lock(&conn->session->lock);
 		task = iscsi_itt_to_ctask(conn, hdr->itt);
 		if (!task)
-			return ISCSI_ERR_BAD_ITT;
-		if (!task->sc)
-			return ISCSI_ERR_NO_SCSI_CMD;
+			rc = ISCSI_ERR_BAD_ITT;
+		else
+			rc = iscsi_data_rsp(conn, task);
+		if (rc) {
+			spin_unlock(&conn->session->lock);
+			break;
+		}
 
-		spin_lock(&conn->session->lock);
-		rc = iscsi_data_rsp(conn, task);
-		spin_unlock(&conn->session->lock);
-		if (rc)
-			return rc;
 		if (tcp_conn->in.datalen) {
 			struct iscsi_tcp_task *tcp_task = task->dd_data;
 			struct hash_desc *rx_hash = NULL;
@@ -801,15 +800,19 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 				  "datalen=%d)\n", tcp_conn,
 				  tcp_task->data_offset,
 				  tcp_conn->in.datalen);
-			return iscsi_segment_seek_sg(&tcp_conn->in.segment,
-						     sdb->table.sgl,
-						     sdb->table.nents,
-						     tcp_task->data_offset,
-						     tcp_conn->in.datalen,
-						     iscsi_tcp_process_data_in,
-						     rx_hash);
+			rc = iscsi_segment_seek_sg(&tcp_conn->in.segment,
+						   sdb->table.sgl,
+						   sdb->table.nents,
+						   tcp_task->data_offset,
+						   tcp_conn->in.datalen,
+						   iscsi_tcp_process_data_in,
+						   rx_hash);
+			spin_unlock(&conn->session->lock);
+			return rc;
 		}
-		/* fall through */
+		rc = __iscsi_complete_pdu(conn, hdr, NULL, 0);
+		spin_unlock(&conn->session->lock);
+		break;
 	case ISCSI_OP_SCSI_CMD_RSP:
 		if (tcp_conn->in.datalen) {
 			iscsi_tcp_data_recv_prep(tcp_conn);
@@ -818,20 +821,17 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
 		break;
 	case ISCSI_OP_R2T:
+		spin_lock(&conn->session->lock);
 		task = iscsi_itt_to_ctask(conn, hdr->itt);
 		if (!task)
-			return ISCSI_ERR_BAD_ITT;
-		if (!task->sc)
-			return ISCSI_ERR_NO_SCSI_CMD;
-
-		if (ahslen)
+			rc = ISCSI_ERR_BAD_ITT;
+		else if (ahslen)
 			rc = ISCSI_ERR_AHSLEN;
-		else if (task->sc->sc_data_direction == DMA_TO_DEVICE) {
-			spin_lock(&session->lock);
+		else if (task->sc->sc_data_direction == DMA_TO_DEVICE)
 			rc = iscsi_r2t_rsp(conn, task);
-			spin_unlock(&session->lock);
-		} else
+		else
 			rc = ISCSI_ERR_PROTO;
+		spin_unlock(&conn->session->lock);
 		break;
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_TEXT_RSP:
@@ -1553,7 +1553,6 @@ iscsi_tcp_release_conn(struct iscsi_conn *conn)
 
 	spin_lock_bh(&session->lock);
 	tcp_conn->sock = NULL;
-	conn->recv_lock = NULL;
 	spin_unlock_bh(&session->lock);
 	sockfd_put(sock);
 }
@@ -1578,6 +1577,19 @@ static void
 iscsi_tcp_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+
+	/* userspace may have goofed up and not bound us */
+	if (!tcp_conn->sock)
+		return;
+	/*
+	 * Make sure our recv side is stopped.
+	 * Older tools called conn stop before ep_disconnect
+	 * so IO could still be coming in.
+	 */
+	write_lock_bh(&tcp_conn->sock->sk->sk_callback_lock);
+	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+	write_unlock_bh(&tcp_conn->sock->sk->sk_callback_lock);
 
 	iscsi_conn_stop(cls_conn, flag);
 	iscsi_tcp_release_conn(conn);
@@ -1671,13 +1683,6 @@ iscsi_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	sk->sk_sndtimeo = 15 * HZ; /* FIXME: make it configurable */
 	sk->sk_allocation = GFP_ATOMIC;
 
-	/* FIXME: disable Nagle's algorithm */
-
-	/*
-	 * Intercept TCP callbacks for sendfile like receive
-	 * processing.
-	 */
-	conn->recv_lock = &sk->sk_callback_lock;
 	iscsi_conn_set_callbacks(conn);
 	tcp_conn->sendpage = tcp_conn->sock->ops->sendpage;
 	/*
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c723e60..9c267b4 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -362,10 +362,11 @@ static void iscsi_complete_command(struct iscsi_task *task)
 	}
 }
 
-static void __iscsi_get_task(struct iscsi_task *task)
+void __iscsi_get_task(struct iscsi_task *task)
 {
 	atomic_inc(&task->refcount);
 }
+EXPORT_SYMBOL_GPL(__iscsi_get_task);
 
 static void __iscsi_put_task(struct iscsi_task *task)
 {
@@ -403,9 +404,13 @@ static void fail_command(struct iscsi_conn *conn, struct iscsi_task *task,
 		conn->session->queued_cmdsn--;
 	else
 		conn->session->tt->cleanup_task(conn, task);
+	/*
+	 * Check if cleanup_task dropped the lock and the command completed,
+	 */
+	if (!task->sc)
+		return;
 
 	sc->result = err;
-
 	if (!scsi_bidi_cmnd(sc))
 		scsi_set_resid(sc, scsi_bufflen(sc));
 	else {
@@ -697,6 +702,31 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 }
 
 /**
+ * iscsi_itt_to_task - look up task by itt
+ * @conn: iscsi connection
+ * @itt: itt
+ *
+ * This should be used for mgmt tasks like login and nops, or if
+ * the LDD's itt space does not include the session age.
+ *
+ * The session lock must be held.
+ */
+static struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt)
+{
+	struct iscsi_session *session = conn->session;
+	uint32_t i;
+
+	if (itt == RESERVED_ITT)
+		return NULL;
+
+	i = get_itt(itt);
+	if (i >= session->cmds_max)
+		return NULL;
+
+	return session->cmds[i];
+}
+
+/**
  * __iscsi_complete_pdu - complete pdu
  * @conn: iscsi conn
  * @hdr: iscsi header
@@ -707,8 +737,8 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
  * queuecommand or send generic. session lock must be held and verify
  * itt must have been called.
  */
-static int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
-				char *data, int datalen)
+int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+			 char *data, int datalen)
 {
 	struct iscsi_session *session = conn->session;
 	int opcode = hdr->opcode & ISCSI_OPCODE_MASK, rc = 0;
@@ -758,22 +788,36 @@ static int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		goto out;
 	}
 
-	task = session->cmds[itt];
 	switch(opcode) {
 	case ISCSI_OP_SCSI_CMD_RSP:
-		if (!task->sc) {
-			rc = ISCSI_ERR_NO_SCSI_CMD;
-			break;
-		}
-		BUG_ON((void*)task != task->sc->SCp.ptr);
+	case ISCSI_OP_SCSI_DATA_IN:
+		task = iscsi_itt_to_ctask(conn, hdr->itt);
+		if (!task)
+			return ISCSI_ERR_BAD_ITT;
+		break;
+	case ISCSI_OP_R2T:
+		/*
+		 * LLD handles R2Ts if they need to.
+		 */
+		return 0;
+	case ISCSI_OP_LOGOUT_RSP:
+	case ISCSI_OP_LOGIN_RSP:
+	case ISCSI_OP_TEXT_RSP:
+	case ISCSI_OP_SCSI_TMFUNC_RSP:
+	case ISCSI_OP_NOOP_IN:
+		task = iscsi_itt_to_task(conn, hdr->itt);
+		if (!task)
+			return ISCSI_ERR_BAD_ITT;
+		break;
+	default:
+		return ISCSI_ERR_BAD_OPCODE;
+	}
+
+	switch(opcode) {
+	case ISCSI_OP_SCSI_CMD_RSP:
 		iscsi_scsi_cmd_rsp(conn, hdr, task, data, datalen);
 		break;
 	case ISCSI_OP_SCSI_DATA_IN:
-		if (!task->sc) {
-			rc = ISCSI_ERR_NO_SCSI_CMD;
-			break;
-		}
-		BUG_ON((void*)task != task->sc->SCp.ptr);
 		if (hdr->flags & ISCSI_FLAG_DATA_STATUS) {
 			conn->scsirsp_pdus_cnt++;
 			iscsi_update_cmdsn(session,
@@ -781,9 +825,6 @@ static int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			__iscsi_put_task(task);
 		}
 		break;
-	case ISCSI_OP_R2T:
-		/* LLD handles this for now */
-		break;
 	case ISCSI_OP_LOGOUT_RSP:
 		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
 		if (datalen) {
@@ -841,6 +882,7 @@ recv_pdu:
 	__iscsi_put_task(task);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(__iscsi_complete_pdu);
 
 int iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		       char *data, int datalen)
@@ -857,7 +899,6 @@ EXPORT_SYMBOL_GPL(iscsi_complete_pdu);
 int iscsi_verify_itt(struct iscsi_conn *conn, itt_t itt)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_task *task;
 	uint32_t i;
 
 	if (itt == RESERVED_ITT)
@@ -867,8 +908,7 @@ int iscsi_verify_itt(struct iscsi_conn *conn, itt_t itt)
 	    (session->age << ISCSI_AGE_SHIFT)) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "received itt %x expected session age (%x)\n",
-				  (__force u32)itt,
-				  session->age & ISCSI_AGE_MASK);
+				  (__force u32)itt, session->age);
 		return ISCSI_ERR_BAD_ITT;
 	}
 
@@ -879,42 +919,36 @@ int iscsi_verify_itt(struct iscsi_conn *conn, itt_t itt)
 				   "%u.\n", i, session->cmds_max);
 		return ISCSI_ERR_BAD_ITT;
 	}
-
-	task = session->cmds[i];
-	if (task->sc && task->sc->SCp.phase != session->age) {
-		iscsi_conn_printk(KERN_ERR, conn,
-				  "iscsi: task's session age %d, "
-				  "expected %d\n", task->sc->SCp.phase,
-				  session->age);
-		return ISCSI_ERR_SESSION_FAILED;
-	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_verify_itt);
 
-struct iscsi_task *
-iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt)
+/**
+ * iscsi_itt_to_ctask - look up ctask by itt
+ * @conn: iscsi connection
+ * @itt: itt
+ *
+ * This should be used for cmd tasks.
+ *
+ * The session lock must be held.
+ */
+struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt)
 {
-	struct iscsi_session *session = conn->session;
 	struct iscsi_task *task;
-	uint32_t i;
 
 	if (iscsi_verify_itt(conn, itt))
 		return NULL;
 
-	if (itt == RESERVED_ITT)
+	task = iscsi_itt_to_task(conn, itt);
+	if (!task || !task->sc)
 		return NULL;
 
-	i = get_itt(itt);
-	if (i >= session->cmds_max)
-		return NULL;
-
-	task = session->cmds[i];
-	if (!task->sc)
-		return NULL;
-
-	if (task->sc->SCp.phase != session->age)
+	if (task->sc->SCp.phase != conn->session->age) {
+		iscsi_session_printk(KERN_ERR, conn->session,
+				  "task's session age %d, expected %d\n",
+				  task->sc->SCp.phase, conn->session->age);
 		return NULL;
+	}
 
 	return task;
 }
@@ -1620,16 +1654,20 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	switch (conn->tmf_state) {
 	case TMF_SUCCESS:
 		spin_unlock_bh(&session->lock);
+		/*
+		 * stop tx side incase the target had sent a abort rsp but
+		 * the initiator was still writing out data.
+		 */
 		iscsi_suspend_tx(conn);
 		/*
-		 * clean up task if aborted. grab the recv lock as a writer
+		 * we do not stop the recv side because targets have been
+		 * good and have never sent us a successful tmf response
+		 * then sent more data for the cmd.
 		 */
-		write_lock_bh(conn->recv_lock);
 		spin_lock(&session->lock);
 		fail_command(conn, task, DID_ABORT << 16);
 		conn->tmf_state = TMF_INITIAL;
 		spin_unlock(&session->lock);
-		write_unlock_bh(conn->recv_lock);
 		iscsi_start_tx(conn);
 		goto success_unlocked;
 	case TMF_TIMEDOUT:
@@ -1729,13 +1767,11 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	spin_unlock_bh(&session->lock);
 
 	iscsi_suspend_tx(conn);
-	/* need to grab the recv lock then session lock */
-	write_lock_bh(conn->recv_lock);
+
 	spin_lock(&session->lock);
 	fail_all_commands(conn, sc->device->lun, DID_ERROR);
 	conn->tmf_state = TMF_INITIAL;
 	spin_unlock(&session->lock);
-	write_unlock_bh(conn->recv_lock);
 
 	iscsi_start_tx(conn);
 	goto done;
@@ -2257,17 +2293,6 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 	}
 
 	/*
-	 * The LLD either freed/unset the lock on us, or userspace called
-	 * stop but did not create a proper connection (connection was never
-	 * bound or it was unbound then stop was called).
-	 */
-	if (!conn->recv_lock) {
-		spin_unlock_bh(&session->lock);
-		mutex_unlock(&session->eh_mutex);
-		return;
-	}
-
-	/*
 	 * When this is called for the in_login state, we only want to clean
 	 * up the login task and connection. We do not need to block and set
 	 * the recovery state again
@@ -2283,11 +2308,6 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 	spin_unlock_bh(&session->lock);
 
 	iscsi_suspend_tx(conn);
-
-	write_lock_bh(conn->recv_lock);
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
-	write_unlock_bh(conn->recv_lock);
-
 	/*
 	 * for connection level recovery we should not calculate
 	 * header digest. conn->hdr_size used for optimization
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 5bf0187..5e75bb7 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -139,11 +139,6 @@ struct iscsi_conn {
 	void			*dd_data;	/* iscsi_transport data */
 	struct iscsi_session	*session;	/* parent session */
 	/*
-	 * LLDs should set this lock. It protects the transport recv
-	 * code
-	 */
-	rwlock_t		*recv_lock;
-	/*
 	 * conn_stop() flag: stop to recover, stop to terminate
 	 */
         int			stop_stage;
@@ -374,10 +369,13 @@ extern int iscsi_conn_send_pdu(struct iscsi_cls_conn *, struct iscsi_hdr *,
 				char *, uint32_t);
 extern int iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
 			      char *, int);
+extern int __iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
+				char *, int);
 extern int iscsi_verify_itt(struct iscsi_conn *, itt_t);
 extern struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *, itt_t);
 extern void iscsi_requeue_task(struct iscsi_task *task);
 extern void iscsi_put_task(struct iscsi_task *task);
+extern void __iscsi_get_task(struct iscsi_task *task);
 
 /*
  * generic helpers
-- 
1.5.4.1

