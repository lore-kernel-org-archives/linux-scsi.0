From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target]: Fix explict iSCSI Logout + iSCSI connection
	failure corner case
Date: Sat, 10 Jan 2009 17:33:20 -0800
Message-ID: <1231637600.4560.1143.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:48836 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754442AbZAKBdo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2009 20:33:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Greetings all,

This patch is made against lio-core-2.6.git/master
and tested on v2.6.28.  The lio-core-2.6.git tree can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Thanks,

--nab

>From 6fdadad6ac238cd1a5992c07de7acac0f44a7afb Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sat, 10 Jan 2009 16:50:16 -0800
Subject: [PATCH] [LIO-Target]: Fix explict iSCSI Logout + iSCSI connection failure corner case

While handling a iSCSI Logout with reason_code CLOSESESSION or a
same CID CLOSECONNECTION request, there was a scenario observed where if the
iSCSI connection where the Logout PDU was received on was to fail *before*
the iSCSI TX thread for said connection could call iscsi_send_logout_response(),
iscsi_close_connection() was being hung indefinately in iscsi_check_conn_usage_count()
waiting for a zero iscsi_conn_t reference count.

This patch moves up the iscsi_inc_conn_usage_count() and iscsi_inc_session_usage_count()
calls to iscsi_logout_closesession() and iscsi_logout_closeconnection() in iSCSI RX Thread
context.  This logic had previously been located in iscsi_send_logout_response() in iSCSI
TX Thread context, which in the case of iSCSI connection failure would cause the following
logic to trigger in iscsi_target.c:iscsi_close_connection():

        if (atomic_read(&conn->conn_logout_remove)) {
                if (conn->conn_logout_reason == CLOSESESSION) {
                        iscsi_dec_conn_usage_count(conn);
                        iscsi_dec_session_usage_count(sess);
                }
                if (conn->conn_logout_reason == CLOSECONNECTION)
                        iscsi_dec_conn_usage_count(conn);

                atomic_set(&conn->conn_logout_remove, 0);
                atomic_set(&sess->session_reinstatement, 0);
                atomic_set(&sess->session_fall_back_to_erl0, 1);
        }

This would incorrect call iscsi_dec_conn_usage_count() and iscsi_dec_session_usage_count()
(depending on logout_reason), even though the iSCSI TX thread context code had not reached
iscsi_send_logout_response() to actually increment the iscsi_conn_t and iscsi_session_t
reference counts.  This was because iscsi_conn_t->conn_logout_remove is set in
iscsi_logout_closesession() and iscsi_logout_closeconnection().

Tested with SC/S CLOSECONNECTION failure and MC/S same CID CLOSECONNECTION + iSCSI
connection failure cases on v2.6.28.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/lio-core/iscsi_target.c b/drivers/lio-core/iscsi_target.c
index 019fb08..8f572af 100644
--- a/drivers/lio-core/iscsi_target.c
+++ b/drivers/lio-core/iscsi_target.c
@@ -2684,16 +2684,17 @@ extern int iscsi_logout_closesession (iscsi_cmd_t *cmd, iscsi_conn_t *conn)
 	atomic_set(&sess->session_logout, 1);
 	atomic_set(&conn->conn_logout_remove, 1);
 	conn->conn_logout_reason = CLOSESESSION;
+
+	iscsi_inc_conn_usage_count(conn);
+	iscsi_inc_session_usage_count(sess);
 	
 	spin_lock_bh(&sess->conn_lock);
 	for (conn_p = sess->conn_head; conn_p; conn_p = conn_p->next) {
 		if (conn_p->conn_state != TARG_CONN_STATE_LOGGED_IN)
 			continue;
 		
-		iscsi_inc_conn_usage_count(conn_p);
 		TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
 		conn_p->conn_state = TARG_CONN_STATE_IN_LOGOUT;
-		iscsi_dec_conn_usage_count(conn_p);
 	}
 	spin_unlock_bh(&sess->conn_lock);
 	
@@ -2722,8 +2723,11 @@ extern int iscsi_logout_closeconnection (iscsi_cmd_t *cmd, iscsi_conn_t *conn)
 		spin_lock_bh(&conn->state_lock);
 		TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
 		conn->conn_state = TARG_CONN_STATE_IN_LOGOUT;
+
 		atomic_set(&conn->conn_logout_remove, 1);
 		conn->conn_logout_reason = CLOSECONNECTION;
+		iscsi_inc_conn_usage_count(conn);
+
 		spin_unlock_bh(&conn->state_lock);
 	} else {
 		/*
@@ -3503,24 +3507,22 @@ static inline int iscsi_send_logout_response (
 		TRACE(TRACE_ISCSI, "iSCSI session logout successful, setting"
 			" logout response to CONNORSESSCLOSEDSUCCESSFULLY.\n");
 		cmd->logout_response = CONNORSESSCLOSEDSUCCESSFULLY;
-		iscsi_inc_conn_usage_count(conn);
-		iscsi_inc_session_usage_count(sess);
 		break;
 	case CLOSECONNECTION:
 		if (cmd->logout_response == CIDNOTFOUND)
 			break;
+		/*
+		 * For CLOSECONNECTION logout requests carrying
+		 * a matching logout CID -> local CID, the reference
+		 * for the local CID will have been incremented in
+		 * iscsi_logout_closeconnection().
+		 * 
+		 * For CLOSECONNECTION logout requests carrying
+		 * a different CID than the connection it arrived
+		 * on, the connection responding to cmd->logout_cid
+		 * is stopped in iscsi_logout_post_handler_diffcid().
+		 */
 
-		if (conn->cid == cmd->logout_cid)
-			iscsi_inc_conn_usage_count(conn);
-		else {
-			/*
-			 * For CLOSECONNECTION logout requests carrying
-			 * a different CID than the connection it arrived
-			 * on, the connection responding to cmd->logout_cid
-			 * is stopped in iscsi_logout_post_handler_diffcid().
-			 */
-			do {} while(0);
-		}
 		TRACE(TRACE_ISCSI, "iSCSI CID: %hu logout on CID: %hu"
 			" successful.\n", cmd->logout_cid, conn->cid);
 		cmd->logout_response = CONNORSESSCLOSEDSUCCESSFULLY;
-- 
1.5.4.1



