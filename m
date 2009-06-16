From: michaelc@cs.wisc.edu
Subject: [PATCH 1/3] libiscsi: don't run scsi eh if iscsi task is making progress
Date: Mon, 15 Jun 2009 22:11:08 -0500
Message-ID: <1245121870-2515-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37381 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbZFPDLR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jun 2009 23:11:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If we are sending or receiving data for the task successfully do
not run the scsi eh, because we know the task is making progress.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c     |   62 ++++++++++++++++++++++++++++++++++---------
 drivers/scsi/libiscsi_tcp.c |    6 +++-
 include/scsi/libiscsi.h     |    4 +++
 3 files changed, 57 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 59908ae..b55b799 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -954,6 +954,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		task = iscsi_itt_to_ctask(conn, hdr->itt);
 		if (!task)
 			return ISCSI_ERR_BAD_ITT;
+		task->last_xfer = jiffies;
 		break;
 	case ISCSI_OP_R2T:
 		/*
@@ -1192,10 +1193,12 @@ static int iscsi_xmit_task(struct iscsi_conn *conn)
 	spin_unlock_bh(&conn->session->lock);
 	rc = conn->session->tt->xmit_task(task);
 	spin_lock_bh(&conn->session->lock);
-	__iscsi_put_task(task);
-	if (!rc)
+	if (!rc) {
 		/* done with this task */
+		task->last_xfer = jiffies;
 		conn->task = NULL;
+	}
+	__iscsi_put_task(task);
 	return rc;
 }
 
@@ -1361,6 +1364,9 @@ static inline struct iscsi_task *iscsi_alloc_task(struct iscsi_conn *conn,
 	task->state = ISCSI_TASK_PENDING;
 	task->conn = conn;
 	task->sc = sc;
+	task->have_checked_conn = false;
+	task->last_timeout = jiffies;
+	task->last_xfer = jiffies;
 	INIT_LIST_HEAD(&task->running);
 	return task;
 }
@@ -1716,17 +1722,18 @@ static int iscsi_has_ping_timed_out(struct iscsi_conn *conn)
 		return 0;
 }
 
-static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *scmd)
+static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 {
+	enum blk_eh_timer_return rc = BLK_EH_NOT_HANDLED;
+	struct iscsi_task *task = NULL;
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
 	struct iscsi_conn *conn;
-	enum blk_eh_timer_return rc = BLK_EH_NOT_HANDLED;
 
-	cls_session = starget_to_session(scsi_target(scmd->device));
+	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
 
-	ISCSI_DBG_SESSION(session, "scsi cmd %p timedout\n", scmd);
+	ISCSI_DBG_SESSION(session, "scsi cmd %p timedout\n", sc);
 
 	spin_lock(&session->lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
@@ -1745,6 +1752,26 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *scmd)
 		goto done;
 	}
 
+	task = (struct iscsi_task *)sc->SCp.ptr;
+	if (!task)
+		goto done;
+	/*
+	 * If we have sent (at least queued to the network layer) a pdu or
+	 * recvd one for the task since the last timeout ask for
+	 * more time. If on the next timeout we have not made progress
+	 * we can check if it is the task or connection when we send the
+	 * nop as a ping.
+	 */
+	if (time_after_eq(task->last_xfer, task->last_timeout)) {
+		ISCSI_DBG_CONN(conn, "Command making progress. Asking "
+			       "scsi-ml for more time to complete. "
+			       "Last data recv at %lu. Last timeout was at "
+			       "%lu\n.", task->last_xfer, task->last_timeout);
+		task->have_checked_conn = false;
+		rc = BLK_EH_RESET_TIMER;
+		goto done;
+	}
+
 	if (!conn->recv_timeout && !conn->ping_timeout)
 		goto done;
 	/*
@@ -1755,20 +1782,29 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *scmd)
 		rc = BLK_EH_RESET_TIMER;
 		goto done;
 	}
+
+	/* Assumes nop timeout is shorter than scsi cmd timeout */
+	if (task->have_checked_conn)
+		goto done;
+
 	/*
-	 * if we are about to check the transport then give the command
-	 * more time
+	 * Checking the transport already or nop from a cmd timeout still
+	 * running
 	 */
-	if (time_before_eq(conn->last_recv + (conn->recv_timeout * HZ),
-			   jiffies)) {
+	if (conn->ping_task) {
+		task->have_checked_conn = true;
 		rc = BLK_EH_RESET_TIMER;
 		goto done;
 	}
 
-	/* if in the middle of checking the transport then give us more time */
-	if (conn->ping_task)
-		rc = BLK_EH_RESET_TIMER;
+	/* Make sure there is a transport check done */
+	iscsi_send_nopout(conn, NULL);
+	task->have_checked_conn = true;
+	rc = BLK_EH_RESET_TIMER;
+
 done:
+	if (task)
+		task->last_timeout = jiffies;
 	spin_unlock(&session->lock);
 	ISCSI_DBG_SESSION(session, "return %s\n", rc == BLK_EH_RESET_TIMER ?
 			  "timer reset" : "nh");
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 2bc0709..2e0746d 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -686,6 +686,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 				     "offset=%d, datalen=%d)\n",
 				      tcp_task->data_offset,
 				      tcp_conn->in.datalen);
+			task->last_xfer = jiffies;
 			rc = iscsi_segment_seek_sg(&tcp_conn->in.segment,
 						   sdb->table.sgl,
 						   sdb->table.nents,
@@ -713,9 +714,10 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 			rc = ISCSI_ERR_BAD_ITT;
 		else if (ahslen)
 			rc = ISCSI_ERR_AHSLEN;
-		else if (task->sc->sc_data_direction == DMA_TO_DEVICE)
+		else if (task->sc->sc_data_direction == DMA_TO_DEVICE) {
+			task->last_xfer = jiffies;
 			rc = iscsi_tcp_r2t_rsp(conn, task);
-		else
+		} else
 			rc = ISCSI_ERR_PROTO;
 		spin_unlock(&conn->session->lock);
 		break;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 196525c..61afeb5 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -125,6 +125,10 @@ struct iscsi_task {
 	struct scsi_cmnd	*sc;		/* associated SCSI cmd*/
 	struct iscsi_conn	*conn;		/* used connection    */
 
+	/* data processing tracking */
+	unsigned long		last_xfer;
+	unsigned long		last_timeout;
+	bool			have_checked_conn;
 	/* state set/tested under session->lock */
 	int			state;
 	atomic_t		refcount;
-- 
1.6.2.2

