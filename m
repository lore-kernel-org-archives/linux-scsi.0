From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 5/6] iscsi update: fix command requeues during iscsi
	recovery
Date: Thu, 18 May 2006 20:31:42 -0500
Message-ID: <1148002302.3248.26.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:61572 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932209AbWESBeO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 21:34:14 -0400
Received: from [192.168.0.4] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k4J1Xqdh007221
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 20:34:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Do not flush queues then block session. This will cause commands
to needlessly swing around on us and remove goofy
recovery_failed field and replace with state value.

And do not start recovery from within the host reset function.
This causeis too many problems becuase open-iscsi was desinged to
call out to userspace then have userpscae decide if we should
go into recovery or kill the session.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 580c050..d810aca 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -487,6 +487,11 @@ void iscsi_conn_failure(struct iscsi_con
 	unsigned long flags;
 
 	spin_lock_irqsave(&session->lock, flags);
+	if (session->state == ISCSI_STATE_FAILED) {
+		spin_unlock_irqrestore(&session->lock, flags);
+		return;
+	}
+
 	if (session->conn_cnt == 1 || session->leadconn == conn)
 		session->state = ISCSI_STATE_FAILED;
 	spin_unlock_irqrestore(&session->lock, flags);
@@ -612,6 +617,7 @@ enum {
 	FAILURE_SESSION_FREED,
 	FAILURE_WINDOW_CLOSED,
 	FAILURE_SESSION_TERMINATE,
+	FAILURE_SESSION_IN_RECOVERY,
 	FAILURE_SESSION_RECOVERY_TIMEOUT,
 };
 
@@ -631,18 +637,30 @@ int iscsi_queuecommand(struct scsi_cmnd 
 
 	spin_lock(&session->lock);
 
-	if (session->state != ISCSI_STATE_LOGGED_IN) {
-		if (session->recovery_failed) {
-			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
-			goto fault;
-		} else if (session->state == ISCSI_STATE_FAILED) {
-			reason = FAILURE_SESSION_FAILED;
-			goto reject;
-		} else if (session->state == ISCSI_STATE_TERMINATE) {
-			reason = FAILURE_SESSION_TERMINATE;
+	/*
+	 * ISCSI_STATE_FAILED is a temp. state. The recovery
+	 * code will decide what is best to do with command queued
+	 * during this time
+	 */
+	if (session->state != ISCSI_STATE_LOGGED_IN &&
+	    session->state != ISCSI_STATE_FAILED) {
+		/*
+		 * to handle the race between when we set the recovery state
+		 * and block the session we requeue here (commands could
+		 * be entering our queuecommand while a block is starting
+		 * up because the block code is not locked)
+		 */
+		if (session->state == ISCSI_STATE_IN_RECOVERY) {
+			reason = FAILURE_SESSION_IN_RECOVERY;
 			goto fault;
 		}
-		reason = FAILURE_SESSION_FREED;
+
+		if (session->state == ISCSI_STATE_RECOVERY_FAILED)
+			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
+		else if (session->state == ISCSI_STATE_TERMINATE)
+			reason = FAILURE_SESSION_TERMINATE;
+		else
+			reason = FAILURE_SESSION_FREED;
 		goto fault;
 	}
 
@@ -728,8 +746,8 @@ iscsi_conn_send_generic(struct iscsi_con
 		 */
 		mtask = conn->login_mtask;
 	else {
-	        BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
-	        BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
+		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
+		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
 		nop->exp_statsn = cpu_to_be32(conn->exp_statsn);
 		if (!__kfifo_get(session->mgmtpool.queue,
@@ -803,7 +821,7 @@ void iscsi_session_recovery_timedout(str
 
 	spin_lock_bh(&session->lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
-		session->recovery_failed = 1;
+		session->state = ISCSI_STATE_RECOVERY_FAILED;
 		if (conn)
 			wake_up(&conn->ehwait);
 	}
@@ -838,20 +856,14 @@ failed:
 	 * we drop the lock here but the leadconn cannot be destoyed while
 	 * we are in the scsi eh
 	 */
-	if (fail_session) {
+	if (fail_session)
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-		/*
-		 * if userspace cannot respond then we must kick this off
-		 * here for it
-		 */
-		iscsi_start_session_recovery(session, conn, STOP_CONN_RECOVER);
-	}
 
 	debug_scsi("iscsi_eh_host_reset wait for relogin\n");
 	wait_event_interruptible(conn->ehwait,
 				 session->state == ISCSI_STATE_TERMINATE ||
 				 session->state == ISCSI_STATE_LOGGED_IN ||
-				 session->recovery_failed);
+				 session->state == ISCSI_STATE_RECOVERY_FAILED);
 	if (signal_pending(current))
 		flush_signals(current);
 
@@ -940,8 +952,7 @@ static int iscsi_exec_abort_task(struct 
 	wait_event_interruptible(conn->ehwait,
 				 sc->SCp.phase != session->age ||
 				 session->state != ISCSI_STATE_LOGGED_IN ||
-				 conn->tmabort_state != TMABORT_INITIAL ||
-				 session->recovery_failed);
+				 conn->tmabort_state != TMABORT_INITIAL);
 	if (signal_pending(current))
 		flush_signals(current);
 	del_timer_sync(&conn->tmabort_timer);
@@ -1491,7 +1502,6 @@ int iscsi_conn_start(struct iscsi_cls_co
 		conn->stop_stage = 0;
 		conn->tmabort_state = TMABORT_INITIAL;
 		session->age++;
-		session->recovery_failed = 0;
 		spin_unlock_bh(&session->lock);
 
 		iscsi_unblock_session(session_to_cls(session));
@@ -1566,8 +1576,8 @@ static void fail_all_commands(struct isc
 	conn->ctask = NULL;
 }
 
-void iscsi_start_session_recovery(struct iscsi_session *session,
-				  struct iscsi_conn *conn, int flag)
+static void iscsi_start_session_recovery(struct iscsi_session *session,
+					 struct iscsi_conn *conn, int flag)
 {
 	int old_stop_stage;
 
@@ -1597,17 +1607,8 @@ void iscsi_start_session_recovery(struct
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 
 	if (session->conn_cnt == 0 || session->leadconn == conn)
-		session->state = ISCSI_STATE_FAILED;
-
-	spin_unlock_bh(&session->lock);
+		session->state = ISCSI_STATE_IN_RECOVERY;
 
-	session->tt->terminate_conn(conn);
-	/*
-	 * flush queues.
-	 */
-	spin_lock_bh(&session->lock);
-	fail_all_commands(conn);
-	flush_control_queues(session, conn);
 	spin_unlock_bh(&session->lock);
 
 	/*
@@ -1619,18 +1620,26 @@ void iscsi_start_session_recovery(struct
 	if (flag == STOP_CONN_RECOVER) {
 		conn->hdrdgst_en = 0;
 		conn->datadgst_en = 0;
-
 		/*
 		 * if this is called from the eh and and from userspace
 		 * then we only need to block once.
 		 */
-		if (session->state == ISCSI_STATE_FAILED &&
+		if (session->state == ISCSI_STATE_IN_RECOVERY &&
 		    old_stop_stage != STOP_CONN_RECOVER)
 			iscsi_block_session(session_to_cls(session));
 	}
+
+	session->tt->terminate_conn(conn);
+	/*
+	 * flush queues.
+	 */
+	spin_lock_bh(&session->lock);
+	fail_all_commands(conn);
+	flush_control_queues(session, conn);
+	spin_unlock_bh(&session->lock);
+
 	mutex_unlock(&conn->xmitmutex);
 }
-EXPORT_SYMBOL_GPL(iscsi_start_session_recovery);
 
 void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 {
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 2dba929..17b28f0 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -210,7 +210,6 @@ struct iscsi_session {
 						 * - mgmtpool,		   *
 						 * - r2tpool		   */
 	int			state;		/* session state           */
-	int			recovery_failed;
 	struct list_head	item;
 	int			conn_cnt;
 	int			age;		/* counts session re-opens */
@@ -241,8 +240,6 @@ iscsi_session_setup(struct iscsi_transpo
 		    int, int, uint32_t, uint32_t *);
 extern void iscsi_session_teardown(struct iscsi_cls_session *);
 extern struct iscsi_session *class_to_transport_session(struct iscsi_cls_session *);
-extern void iscsi_start_session_recovery(struct iscsi_session *,
-					struct iscsi_conn *, int);
 extern void iscsi_session_recovery_timedout(struct iscsi_cls_session *);
 
 #define session_to_cls(_sess) \
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index c9e9475..92129b9 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -173,6 +173,8 @@ struct iscsi_cls_conn {
 #define ISCSI_STATE_LOGGED_IN		2
 #define ISCSI_STATE_FAILED		3
 #define ISCSI_STATE_TERMINATE		4
+#define ISCSI_STATE_IN_RECOVERY		5
+#define ISCSI_STATE_RECOVERY_FAILED	6
 
 struct iscsi_cls_session {
 	struct list_head sess_list;		/* item in session_list */


