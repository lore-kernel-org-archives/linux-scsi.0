From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/5] iscsi: fix manamgement task oops
Date: Tue, 02 May 2006 19:46:40 -0500
Message-ID: <1146617200.2601.15.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:61613 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S965055AbWECAo2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2006 20:44:28 -0400
Received: from [192.168.0.4] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k430iRGI010713
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 2 May 2006 19:44:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

from patmans@us.ibm.com and michaelc@cs.wisc.edu

Fix bugs when forcing a mgmt task to fail and allow
session recovery to cleanup the session/connection
of any running mgmt tasks. When called during
the in login state.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 274a137..8c51f6c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1538,10 +1538,11 @@ flush_control_queues(struct iscsi_sessio
 	/* handle running */
 	list_for_each_entry_safe(mtask, tmp, &conn->mgmt_run_list, running) {
 		debug_scsi("flushing running mgmt task itt 0x%x\n", mtask->itt);
+		list_del(&mtask->running);
+
 		if (mtask == conn->login_mtask)
 			continue;
-		list_del(&mtask->running);
-		__kfifo_put(session->mgmtpool.queue, (void*)&conn->mtask,
+		__kfifo_put(session->mgmtpool.queue, (void*)&mtask,
 			   sizeof(void*));
 	}
 
@@ -1573,12 +1574,22 @@ static void fail_all_commands(struct isc
 void iscsi_start_session_recovery(struct iscsi_session *session,
 				  struct iscsi_conn *conn, int flag)
 {
+	int old_stop_stage;
+
 	spin_lock_bh(&session->lock);
-	if (conn->stop_stage == STOP_CONN_RECOVER ||
-	    conn->stop_stage == STOP_CONN_TERM) {
+	if (conn->stop_stage == STOP_CONN_TERM) {
 		spin_unlock_bh(&session->lock);
 		return;
 	}
+
+	/*
+	 * When this is called for the in_login state, we only want to clean
+	 * up the login task and connection.
+	 */
+	if (conn->stop_stage != STOP_CONN_RECOVER)
+		session->conn_cnt--;
+
+	old_stop_stage = conn->stop_stage;
 	conn->stop_stage = flag;
 	spin_unlock_bh(&session->lock);
 
@@ -1590,7 +1601,6 @@ void iscsi_start_session_recovery(struct
 	conn->c_stage = ISCSI_CONN_STOPPED;
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 
-	session->conn_cnt--;
 	if (session->conn_cnt == 0 || session->leadconn == conn)
 		session->state = ISCSI_STATE_FAILED;
 
@@ -1615,7 +1625,12 @@ void iscsi_start_session_recovery(struct
 		conn->hdrdgst_en = 0;
 		conn->datadgst_en = 0;
 
-		if (session->state == ISCSI_STATE_FAILED)
+		/*
+		 * if this is called from the eh and and from userspace
+		 * then we only need to block once.
+		 */
+		if (session->state == ISCSI_STATE_FAILED &&
+		    old_stop_stage != STOP_CONN_RECOVER)
 			iscsi_block_session(session_to_cls(session));
 	}
 	mutex_unlock(&conn->xmitmutex);


