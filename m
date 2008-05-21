From: michaelc@cs.wisc.edu
Subject: [PATCH 12/25] iscsi_tcp: convert iscsi_tcp to support merged tasks
Date: Wed, 21 May 2008 15:54:07 -0500
Message-ID: <1211403260-5487-13-git-send-email-michaelc@cs.wisc.edu>
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
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936902AbYEUUyb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:31 -0400
In-Reply-To: <1211403260-5487-12-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Convert iscsi_tcp to support merged tasks.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |  130 +++++++++++++++++++---------------------------
 drivers/scsi/iscsi_tcp.h |    5 --
 2 files changed, 54 insertions(+), 81 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index f2a08f7..517bad1 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -498,11 +498,15 @@ iscsi_tcp_data_recv_prep(struct iscsi_tcp_conn *tcp_conn)
  * must be called with session lock
  */
 static void
-iscsi_tcp_cleanup_ctask(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
+iscsi_tcp_cleanup_task(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct iscsi_r2t_info *r2t;
 
+	/* nothing to do for mgmt ctasks */
+	if (!ctask->sc)
+		return;
+
 	/* flush ctask's r2t queues */
 	while (__kfifo_get(tcp_ctask->r2tqueue, (void*)&r2t, sizeof(void*))) {
 		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
@@ -521,7 +525,7 @@ iscsi_tcp_cleanup_ctask(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 /**
  * iscsi_data_rsp - SCSI Data-In Response processing
  * @conn: iscsi connection
- * @ctask: scsi command task
+ * @ctask: scsi command ctask
  **/
 static int
 iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
@@ -578,7 +582,7 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 /**
  * iscsi_solicit_data_init - initialize first Data-Out
  * @conn: iscsi connection
- * @ctask: scsi command task
+ * @ctask: scsi command ctask
  * @r2t: R2T info
  *
  * Notes:
@@ -620,7 +624,7 @@ iscsi_solicit_data_init(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 /**
  * iscsi_r2t_rsp - iSCSI R2T Response processing
  * @conn: iscsi connection
- * @ctask: scsi command task
+ * @ctask: scsi command ctask
  **/
 static int
 iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
@@ -646,7 +650,7 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 		return ISCSI_ERR_R2TSN;
 	}
 
-	/* fill-in new R2T associated with the task */
+	/* fill-in new R2T associated with the ctask */
 	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
 
 	if (!ctask->sc || session->state != ISCSI_STATE_LOGGED_IN) {
@@ -769,6 +773,8 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		ctask = iscsi_itt_to_ctask(conn, hdr->itt);
 		if (!ctask)
 			return ISCSI_ERR_BAD_ITT;
+		if (!ctask->sc)
+			return ISCSI_ERR_NO_SCSI_CMD;
 
 		spin_lock(&conn->session->lock);
 		rc = iscsi_data_rsp(conn, ctask);
@@ -815,6 +821,8 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		ctask = iscsi_itt_to_ctask(conn, hdr->itt);
 		if (!ctask)
 			return ISCSI_ERR_BAD_ITT;
+		if (!ctask->sc)
+			return ISCSI_ERR_NO_SCSI_CMD;
 
 		if (ahslen)
 			rc = ISCSI_ERR_AHSLEN;
@@ -1194,7 +1202,7 @@ iscsi_tcp_send_hdr_prep(struct iscsi_conn *conn, void *hdr, size_t hdrlen)
 
 	/* If header digest is enabled, compute the CRC and
 	 * place the digest into the same buffer. We make
-	 * sure that both iscsi_tcp_ctask and mtask have
+	 * sure that both iscsi_tcp_cmd_task and mctask have
 	 * sufficient room.
 	 */
 	if (conn->hdrdgst_en) {
@@ -1269,7 +1277,7 @@ iscsi_tcp_send_linear_data_prepare(struct iscsi_conn *conn, void *data,
 /**
  * iscsi_solicit_data_cont - initialize next Data-Out
  * @conn: iscsi connection
- * @ctask: scsi command task
+ * @ctask: scsi command ctask
  * @r2t: R2T info
  * @left: bytes left to transfer
  *
@@ -1316,19 +1324,37 @@ iscsi_solicit_data_cont(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 }
 
 /**
- * iscsi_tcp_ctask - Initialize iSCSI SCSI_READ or SCSI_WRITE commands
+ * iscsi_tcp_task - Initialize iSCSI SCSI_READ or SCSI_WRITE commands
  * @conn: iscsi connection
- * @ctask: scsi command task
+ * @ctask: scsi command ctask
  * @sc: scsi command
  **/
 static int
-iscsi_tcp_ctask_init(struct iscsi_cmd_task *ctask)
+iscsi_tcp_task_init(struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct iscsi_conn *conn = ctask->conn;
 	struct scsi_cmnd *sc = ctask->sc;
 	int err;
 
+	if (!sc) {
+		/*
+		 * mgmt ctasks do not have a scatterlist since they come
+		 * in from the iscsi interface.
+		 */
+		debug_scsi("mctask deq [cid %d itt 0x%x]\n", conn->id,
+			   ctask->itt);
+
+		/* Prepare PDU, optionally w/ immediate data */
+		iscsi_tcp_send_hdr_prep(conn, ctask->hdr, sizeof(*ctask->hdr));
+
+		/* If we have immediate data, attach a payload */
+		if (ctask->data_count)
+			iscsi_tcp_send_linear_data_prepare(conn, ctask->data,
+							   ctask->data_count);
+		return 0;
+	}
+
 	BUG_ON(__kfifo_len(tcp_ctask->r2tqueue));
 	tcp_ctask->sent = 0;
 	tcp_ctask->exp_datasn = 0;
@@ -1353,52 +1379,21 @@ iscsi_tcp_ctask_init(struct iscsi_cmd_task *ctask)
 	return 0;
 }
 
-/**
- * iscsi_tcp_mtask_xmit - xmit management(immediate) task
- * @conn: iscsi connection
- * @mtask: task management task
- *
- * Notes:
- *	The function can return -EAGAIN in which case caller must
- *	call it again later, or recover. '0' return code means successful
- *	xmit.
- **/
-static int
-iscsi_tcp_mtask_xmit(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
-{
-	int rc;
-
-	/* Flush any pending data first. */
-	rc = iscsi_tcp_flush(conn);
-	if (rc < 0)
-		return rc;
-
-	if (mtask->hdr->itt == RESERVED_ITT) {
-		struct iscsi_session *session = conn->session;
-
-		spin_lock_bh(&session->lock);
-		iscsi_free_mgmt_task(conn, mtask);
-		spin_unlock_bh(&session->lock);
-	}
-
-	return 0;
-}
-
 /*
- * iscsi_tcp_ctask_xmit - xmit normal PDU task
- * @conn: iscsi connection
- * @ctask: iscsi command task
+ * iscsi_tcp_task_xmit - xmit normal PDU ctask
+ * @ctask: iscsi command ctask
  *
  * We're expected to return 0 when everything was transmitted succesfully,
  * -EAGAIN if there's still data in the queue, or != 0 for any other kind
  * of error.
  */
 static int
-iscsi_tcp_ctask_xmit(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
+iscsi_tcp_task_xmit(struct iscsi_cmd_task *ctask)
 {
+	struct iscsi_conn *conn = ctask->conn;
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct scsi_cmnd *sc = ctask->sc;
-	struct scsi_data_buffer *sdb = scsi_out(sc);
+	struct scsi_data_buffer *sdb;
 	int rc = 0;
 
 flush:
@@ -1407,10 +1402,18 @@ flush:
 	if (rc < 0)
 		return rc;
 
+	/* mgmt command */
+	if (!sc) {
+		if (ctask->hdr->itt == RESERVED_ITT)
+			iscsi_put_ctask(ctask);
+		return 0;
+	}
+
 	/* Are we done already? */
 	if (sc->sc_data_direction != DMA_TO_DEVICE)
 		return 0;
 
+	sdb = scsi_out(sc);
 	if (ctask->unsol_count != 0) {
 		struct iscsi_data *hdr = &tcp_ctask->unsol_dtask.hdr;
 
@@ -1688,21 +1691,6 @@ free_socket:
 	return err;
 }
 
-/* called with host lock */
-static void
-iscsi_tcp_mtask_init(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
-{
-	debug_scsi("mtask deq [cid %d itt 0x%x]\n", conn->id, mtask->itt);
-
-	/* Prepare PDU, optionally w/ immediate data */
-	iscsi_tcp_send_hdr_prep(conn, mtask->hdr, sizeof(*mtask->hdr));
-
-	/* If we have immediate data, attach a payload */
-	if (mtask->data_count)
-		iscsi_tcp_send_linear_data_prepare(conn, mtask->data,
-						   mtask->data_count);
-}
-
 static int
 iscsi_r2tpool_alloc(struct iscsi_session *session)
 {
@@ -1710,7 +1698,7 @@ iscsi_r2tpool_alloc(struct iscsi_session *session)
 	int cmd_i;
 
 	/*
-	 * initialize per-task: R2T pool and xmit queue
+	 * initialize per-ctask: R2T pool and xmit queue
 	 */
 	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
 	        struct iscsi_cmd_task *ctask = session->cmds[cmd_i];
@@ -1880,13 +1868,12 @@ iscsi_tcp_session_create(struct Scsi_Host *shost, uint16_t cmds_max,
 
 	cls_session = iscsi_session_setup(&iscsi_tcp_transport, shost, cmds_max,
 					  sizeof(struct iscsi_tcp_cmd_task),
-					  sizeof(struct iscsi_tcp_mgmt_task),
 					  initial_cmdsn);
 	if (!cls_session)
 		goto remove_host;
 	session = cls_session->dd_data;
 
-	shost->can_queue = session->cmds_max;
+	shost->can_queue = session->scsi_cmds_max;
 	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
 		struct iscsi_cmd_task *ctask = session->cmds[cmd_i];
 		struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
@@ -1895,13 +1882,6 @@ iscsi_tcp_session_create(struct Scsi_Host *shost, uint16_t cmds_max,
 		ctask->hdr_max = sizeof(tcp_ctask->hdr) - ISCSI_DIGEST_SIZE;
 	}
 
-	for (cmd_i = 0; cmd_i < session->mgmtpool_max; cmd_i++) {
-		struct iscsi_mgmt_task *mtask = session->mgmt_cmds[cmd_i];
-		struct iscsi_tcp_mgmt_task *tcp_mtask = mtask->dd_data;
-
-		mtask->hdr = (struct iscsi_hdr *) &tcp_mtask->hdr;
-	}
-
 	if (iscsi_r2tpool_alloc(session))
 		goto remove_session;
 	return cls_session;
@@ -1999,11 +1979,9 @@ static struct iscsi_transport iscsi_tcp_transport = {
 	/* IO */
 	.send_pdu		= iscsi_conn_send_pdu,
 	.get_stats		= iscsi_conn_get_stats,
-	.init_cmd_task		= iscsi_tcp_ctask_init,
-	.init_mgmt_task		= iscsi_tcp_mtask_init,
-	.xmit_cmd_task		= iscsi_tcp_ctask_xmit,
-	.xmit_mgmt_task		= iscsi_tcp_mtask_xmit,
-	.cleanup_cmd_task	= iscsi_tcp_cleanup_ctask,
+	.init_task		= iscsi_tcp_task_init,
+	.xmit_task		= iscsi_tcp_task_xmit,
+	.cleanup_task		= iscsi_tcp_cleanup_task,
 	/* recovery */
 	.session_recovery_timedout = iscsi_session_recovery_timedout,
 };
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index ed0b991..c9c8633 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -103,11 +103,6 @@ struct iscsi_data_task {
 	char			hdrext[ISCSI_DIGEST_SIZE];/* Header-Digest */
 };
 
-struct iscsi_tcp_mgmt_task {
-	struct iscsi_hdr	hdr;
-	char			hdrext[ISCSI_DIGEST_SIZE]; /* Header-Digest */
-};
-
 struct iscsi_r2t_info {
 	__be32			ttt;		/* copied from R2T */
 	__be32			exp_statsn;	/* copied from R2T */
-- 
1.5.4.1

