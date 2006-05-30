From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/5] iscsi update: dont switch states when just cleaning up
Date: Tue, 30 May 2006 00:37:20 -0500
Message-ID: <1148967440.3005.13.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:23735 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932135AbWE3F5a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 01:57:30 -0400
Received: from [192.168.0.7] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k4U5v9gA027082
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 30 May 2006 00:57:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

If recovery failed or we are in recovery only overwrite the state
if we are going to terminate the session or if we logged back in.

STOP_CONN_SUSPEND and conn_cnt are not used. We only support
a single connection session ATM, so cleanup that code while
we are working around it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index c66faee..2abda80 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1955,30 +1955,28 @@ iscsi_tcp_conn_bind(struct iscsi_cls_ses
 	if (err)
 		return err;
 
-	if (conn->stop_stage != STOP_CONN_SUSPEND) {
-		/* bind iSCSI connection and socket */
-		tcp_conn->sock = sock;
-
-		/* setup Socket parameters */
-		sk = sock->sk;
-		sk->sk_reuse = 1;
-		sk->sk_sndtimeo = 15 * HZ; /* FIXME: make it configurable */
-		sk->sk_allocation = GFP_ATOMIC;
+	/* bind iSCSI connection and socket */
+	tcp_conn->sock = sock;
 
-		/* FIXME: disable Nagle's algorithm */
+	/* setup Socket parameters */
+	sk = sock->sk;
+	sk->sk_reuse = 1;
+	sk->sk_sndtimeo = 15 * HZ; /* FIXME: make it configurable */
+	sk->sk_allocation = GFP_ATOMIC;
 
-		/*
-		 * Intercept TCP callbacks for sendfile like receive
-		 * processing.
-		 */
-		conn->recv_lock = &sk->sk_callback_lock;
-		iscsi_conn_set_callbacks(conn);
-		tcp_conn->sendpage = tcp_conn->sock->ops->sendpage;
-		/*
-		 * set receive state machine into initial state
-		 */
-		tcp_conn->in_progress = IN_PROGRESS_WAIT_HEADER;
-	}
+	/* FIXME: disable Nagle's algorithm */
+
+	/*
+	 * Intercept TCP callbacks for sendfile like receive
+	 * processing.
+	 */
+	conn->recv_lock = &sk->sk_callback_lock;
+	iscsi_conn_set_callbacks(conn);
+	tcp_conn->sendpage = tcp_conn->sock->ops->sendpage;
+	/*
+	 * set receive state machine into initial state
+	 */
+	tcp_conn->in_progress = IN_PROGRESS_WAIT_HEADER;
 
 	return 0;
 }
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d810aca..9630025 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -492,7 +492,7 @@ void iscsi_conn_failure(struct iscsi_con
 		return;
 	}
 
-	if (session->conn_cnt == 1 || session->leadconn == conn)
+	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
 	spin_unlock_irqrestore(&session->lock, flags);
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
@@ -652,7 +652,7 @@ int iscsi_queuecommand(struct scsi_cmnd 
 		 */
 		if (session->state == ISCSI_STATE_IN_RECOVERY) {
 			reason = FAILURE_SESSION_IN_RECOVERY;
-			goto fault;
+			goto reject;
 		}
 
 		if (session->state == ISCSI_STATE_RECOVERY_FAILED)
@@ -1411,8 +1411,8 @@ void iscsi_conn_teardown(struct iscsi_cl
 	struct iscsi_session *session = conn->session;
 	unsigned long flags;
 
-	mutex_lock(&conn->xmitmutex);
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	mutex_lock(&conn->xmitmutex);
 	if (conn->c_stage == ISCSI_CONN_INITIAL_STAGE) {
 		if (session->tt->suspend_conn_recv)
 			session->tt->suspend_conn_recv(conn);
@@ -1498,7 +1498,6 @@ int iscsi_conn_start(struct iscsi_cls_co
 		 * unblock eh_abort() if it is blocked. re-try all
 		 * commands after successful recovery
 		 */
-		session->conn_cnt++;
 		conn->stop_stage = 0;
 		conn->tmabort_state = TMABORT_INITIAL;
 		session->age++;
@@ -1508,13 +1507,7 @@ int iscsi_conn_start(struct iscsi_cls_co
 		wake_up(&conn->ehwait);
 		return 0;
 	case STOP_CONN_TERM:
-		session->conn_cnt++;
-		conn->stop_stage = 0;
-		break;
-	case STOP_CONN_SUSPEND:
 		conn->stop_stage = 0;
-		clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
-		clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 		break;
 	default:
 		break;
@@ -1589,28 +1582,24 @@ static void iscsi_start_session_recovery
 
 	/*
 	 * When this is called for the in_login state, we only want to clean
-	 * up the login task and connection.
+	 * up the login task and connection. We do not need to block and set
+	 * the recovery state again
 	 */
-	if (conn->stop_stage != STOP_CONN_RECOVER)
-		session->conn_cnt--;
+	if (flag == STOP_CONN_TERM)
+		session->state = ISCSI_STATE_TERMINATE;
+	else if (conn->stop_stage != STOP_CONN_RECOVER)
+		session->state = ISCSI_STATE_IN_RECOVERY;
 
 	old_stop_stage = conn->stop_stage;
 	conn->stop_stage = flag;
+	conn->c_stage = ISCSI_CONN_STOPPED;
+	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	spin_unlock_bh(&session->lock);
 
 	if (session->tt->suspend_conn_recv)
 		session->tt->suspend_conn_recv(conn);
 
 	mutex_lock(&conn->xmitmutex);
-	spin_lock_bh(&session->lock);
-	conn->c_stage = ISCSI_CONN_STOPPED;
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-
-	if (session->conn_cnt == 0 || session->leadconn == conn)
-		session->state = ISCSI_STATE_IN_RECOVERY;
-
-	spin_unlock_bh(&session->lock);
-
 	/*
 	 * for connection level recovery we should not calculate
 	 * header digest. conn->hdr_size used for optimization
@@ -1620,13 +1609,11 @@ static void iscsi_start_session_recovery
 	if (flag == STOP_CONN_RECOVER) {
 		conn->hdrdgst_en = 0;
 		conn->datadgst_en = 0;
-		/*
-		 * if this is called from the eh and and from userspace
-		 * then we only need to block once.
-		 */
 		if (session->state == ISCSI_STATE_IN_RECOVERY &&
-		    old_stop_stage != STOP_CONN_RECOVER)
+		    old_stop_stage != STOP_CONN_RECOVER) {
+			debug_scsi("blocking session\n");
 			iscsi_block_session(session_to_cls(session));
+		}
 	}
 
 	session->tt->terminate_conn(conn);
@@ -1651,20 +1638,6 @@ void iscsi_conn_stop(struct iscsi_cls_co
 	case STOP_CONN_TERM:
 		iscsi_start_session_recovery(session, conn, flag);
 		break;
-	case STOP_CONN_SUSPEND:
-		if (session->tt->suspend_conn_recv)
-			session->tt->suspend_conn_recv(conn);
-
-		mutex_lock(&conn->xmitmutex);
-		spin_lock_bh(&session->lock);
-
-		conn->stop_stage = flag;
-		conn->c_stage = ISCSI_CONN_STOPPED;
-		set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-
-		spin_unlock_bh(&session->lock);
-		mutex_unlock(&conn->xmitmutex);
-		break;
 	default:
 		printk(KERN_ERR "iscsi: invalid stop flag %d\n", flag);
 	}
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 17b28f0..cbf7e58 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -211,7 +211,6 @@ struct iscsi_session {
 						 * - r2tpool		   */
 	int			state;		/* session state           */
 	struct list_head	item;
-	int			conn_cnt;
 	int			age;		/* counts session re-opens */
 
 	struct list_head	connections;	/* list of connections */


