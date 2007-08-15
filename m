From: michaelc@cs.wisc.edu
Subject: [PATCH 2/2] libiscsi: sync up iscsi and scsi eh's access to the connection
Date: Wed, 15 Aug 2007 01:38:30 -0500
Message-ID: <1187159912258-git-send-email-michaelc@cs.wisc.edu>
References: <11871599101926-git-send-email-michaelc@cs.wisc.edu>
 <11871599112120-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbXHOGih (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2007 02:38:37 -0400
In-Reply-To: <11871599112120-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The iscsi eh could be tearing down the session/connection while
the scsi eh is still sending task management functions. If when
we drop the session lock to grab the recv lock, the iscsi eh
tears down the connection we will oops.

This patch is made against scsi-rc-fixes. If there is time for patches
for 2.6.23, the please merge for that. The patch is pretty small and
fixes a bug.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   54 +++++++++++++++++++++++++++++++++++++---------
 include/scsi/libiscsi.h |    7 ++++++
 2 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f5915d4..efceed4 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1056,7 +1056,9 @@ static int iscsi_exec_abort_task(struct scsi_cmnd *sc,
 	ctask->mtask = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
 					    NULL, 0);
 	if (!ctask->mtask) {
+		spin_unlock_bh(&session->lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+		spin_lock_bh(&session->lock)
 		debug_scsi("abort sent failure [itt 0x%x]\n", ctask->itt);
 		return -EPERM;
 	}
@@ -1073,6 +1075,7 @@ static int iscsi_exec_abort_task(struct scsi_cmnd *sc,
 		debug_scsi("abort set timeout [itt 0x%x]\n", ctask->itt);
 	}
 	spin_unlock_bh(&session->lock);
+	mutex_unlock(&session->eh_mutex);
 	scsi_queue_work(session->host, &conn->xmitwork);
 
 	/*
@@ -1090,6 +1093,7 @@ static int iscsi_exec_abort_task(struct scsi_cmnd *sc,
 	if (signal_pending(current))
 		flush_signals(current);
 	del_timer_sync(&conn->tmabort_timer);
+	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
 	return 0;
 }
@@ -1165,31 +1169,45 @@ static void fail_command(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 	__iscsi_put_ctask(ctask);
 }
 
+static void iscsi_suspend_tx(struct iscsi_conn *conn)
+{
+	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	scsi_flush_work(conn->session->host);
+}
+
+static void iscsi_start_tx(struct iscsi_conn *conn)
+{
+	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	scsi_queue_work(conn->session->host, &conn->xmitwork);
+}
+
 int iscsi_eh_abort(struct scsi_cmnd *sc)
 {
+	struct Scsi_Host *host = sc->device->host;
+	struct iscsi_session *session = iscsi_hostdata(host->hostdata);
 	struct iscsi_cmd_task *ctask;
 	struct iscsi_conn *conn;
-	struct iscsi_session *session;
 	int rc;
 
+	mutex_lock(&session->eh_mutex);
+	spin_lock_bh(&session->lock);
 	/*
 	 * if session was ISCSI_STATE_IN_RECOVERY then we may not have
 	 * got the command.
 	 */
 	if (!sc->SCp.ptr) {
 		debug_scsi("sc never reached iscsi layer or it completed.\n");
+		spin_unlock_bh(&session->lock);
+		mutex_unlock(&session->eh_mutex);
 		return SUCCESS;
 	}
 
 	ctask = (struct iscsi_cmd_task *)sc->SCp.ptr;
 	conn = ctask->conn;
-	session = conn->session;
 
 	conn->eh_abort_cnt++;
 	debug_scsi("aborting [sc %p itt 0x%x]\n", sc, ctask->itt);
 
-	spin_lock_bh(&session->lock);
-
 	/*
 	 * If we are not logged in or we have started a new session
 	 * then let the host reset code handle this
@@ -1226,6 +1244,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	switch (conn->tmabort_state) {
 	case TMABORT_SUCCESS:
 		spin_unlock_bh(&session->lock);
+		iscsi_suspend_tx(conn);
 		/*
 		 * clean up task if aborted. grab the recv lock as a writer
 		 */
@@ -1234,11 +1253,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		fail_command(conn, ctask, DID_ABORT << 16);
 		spin_unlock(&session->lock);
 		write_unlock_bh(conn->recv_lock);
-		/*
-		 * make sure xmit thread is not still touching the
-		 * ctask/scsi_cmnd
-		 */
-		scsi_flush_work(session->host);
+		iscsi_start_tx(conn);
 		goto success_unlocked;
 	case TMABORT_NOT_FOUND:
 		if (!ctask->sc) {
@@ -1258,12 +1273,14 @@ success:
 	spin_unlock_bh(&session->lock);
 success_unlocked:
 	debug_scsi("abort success [sc %lx itt 0x%x]\n", (long)sc, ctask->itt);
+	mutex_unlock(&session->eh_mutex);
 	return SUCCESS;
 
 failed:
 	spin_unlock_bh(&session->lock);
 failed_unlocked:
 	debug_scsi("abort failed [sc %lx itt 0x%x]\n", (long)sc, ctask->itt);
+	mutex_unlock(&session->eh_mutex);
 	return FAILED;
 }
 EXPORT_SYMBOL_GPL(iscsi_eh_abort);
@@ -1410,6 +1427,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit,
 	session->max_cmdsn = initial_cmdsn + 1;
 	session->max_r2t = 1;
 	session->tt = iscsit;
+	mutex_init(&session->eh_mutex);
 
 	/* initialize SCSI PDU commands pool */
 	if (iscsi_pool_init(&session->cmdpool, session->cmds_max,
@@ -1743,9 +1761,22 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 {
 	int old_stop_stage;
 
+	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
 	if (conn->stop_stage == STOP_CONN_TERM) {
 		spin_unlock_bh(&session->lock);
+		mutex_unlock(&session->eh_mutex);
+		return;
+	}
+
+	/*
+	 * The LLD either freed/unset the lock on us, or userspace called
+	 * stop but did not create a proper connection (connection was never
+	 * bound or it was unbound then stop was called).
+	 */
+	if (!conn->recv_lock) {
+		spin_unlock_bh(&session->lock);
+		mutex_unlock(&session->eh_mutex);
 		return;
 	}
 
@@ -1762,9 +1793,9 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 	old_stop_stage = conn->stop_stage;
 	conn->stop_stage = flag;
 	conn->c_stage = ISCSI_CONN_STOPPED;
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	spin_unlock_bh(&session->lock);
-	scsi_flush_work(session->host);
+
+	iscsi_suspend_tx(conn);
 
 	write_lock_bh(conn->recv_lock);
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
@@ -1793,6 +1824,7 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 	fail_all_commands(conn);
 	flush_control_queues(session, conn);
 	spin_unlock_bh(&session->lock);
+	mutex_unlock(&session->eh_mutex);
 }
 
 void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 007d442..b4b3113 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -205,6 +205,13 @@ struct iscsi_queue {
 };
 
 struct iscsi_session {
+	/*
+	 * Syncs up the scsi eh thread with the iscsi eh thread when sending
+	 * task management functions. This must be taken before the session
+	 * and recv lock.
+	 */
+	struct mutex		eh_mutex;
+
 	/* iSCSI session-wide sequencing */
 	uint32_t		cmdsn;
 	uint32_t		exp_cmdsn;
-- 
1.5.1.2

