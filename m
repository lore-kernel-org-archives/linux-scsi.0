From: michaelc@cs.wisc.edu
Subject: [PATCH 3/3] libiscsi: add conn and scsi eh log debug flags
Date: Mon, 15 Jun 2009 22:11:10 -0500
Message-ID: <1245121870-2515-3-git-send-email-michaelc@cs.wisc.edu>
References: <1245121870-2515-1-git-send-email-michaelc@cs.wisc.edu>
 <1245121870-2515-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37385 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZFPDLT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jun 2009 23:11:19 -0400
In-Reply-To: <1245121870-2515-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Erez Zilber <erezzi.list@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Erez Zilber <erezzi.list@gmail.com>

Allow the user to control the debug logs in libiscsi. We will now
have a module param for connection, session & error handling.

[Mike Christie - Fixed up to compile on current code and added
missing ISCSI_DBG_EH conversions]

Signed-off-by: Erez Zilber <erezzi.list@gmail.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |  109 ++++++++++++++++++++++++++++-------------------
 1 files changed, 65 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index b55b799..716cc34 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -38,15 +38,30 @@
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/libiscsi.h>
 
-static int iscsi_dbg_lib;
-module_param_named(debug_libiscsi, iscsi_dbg_lib, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(debug_libiscsi, "Turn on debugging for libiscsi module. "
-		 "Set to 1 to turn on, and zero to turn off. Default "
-		 "is off.");
+static int iscsi_dbg_lib_conn;
+module_param_named(debug_libiscsi_conn, iscsi_dbg_lib_conn, int,
+		   S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug_libiscsi_conn,
+		 "Turn on debugging for connections in libiscsi module. "
+		 "Set to 1 to turn on, and zero to turn off. Default is off.");
+
+static int iscsi_dbg_lib_session;
+module_param_named(debug_libiscsi_session, iscsi_dbg_lib_session, int,
+		   S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug_libiscsi_session,
+		 "Turn on debugging for sessions in libiscsi module. "
+		 "Set to 1 to turn on, and zero to turn off. Default is off.");
+
+static int iscsi_dbg_lib_eh;
+module_param_named(debug_libiscsi_eh, iscsi_dbg_lib_eh, int,
+		   S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug_libiscsi_eh,
+		 "Turn on debugging for error handling in libiscsi module. "
+		 "Set to 1 to turn on, and zero to turn off. Default is off.");
 
 #define ISCSI_DBG_CONN(_conn, dbg_fmt, arg...)			\
 	do {							\
-		if (iscsi_dbg_lib)				\
+		if (iscsi_dbg_lib_conn)				\
 			iscsi_conn_printk(KERN_INFO, _conn,	\
 					     "%s " dbg_fmt,	\
 					     __func__, ##arg);	\
@@ -54,7 +69,15 @@ MODULE_PARM_DESC(debug_libiscsi, "Turn on debugging for libiscsi module. "
 
 #define ISCSI_DBG_SESSION(_session, dbg_fmt, arg...)			\
 	do {								\
-		if (iscsi_dbg_lib)					\
+		if (iscsi_dbg_lib_session)				\
+			iscsi_session_printk(KERN_INFO, _session,	\
+					     "%s " dbg_fmt,		\
+					     __func__, ##arg);		\
+	} while (0);
+
+#define ISCSI_DBG_EH(_session, dbg_fmt, arg...)				\
+	do {								\
+		if (iscsi_dbg_lib_eh)					\
 			iscsi_session_printk(KERN_INFO, _session,	\
 					     "%s " dbg_fmt,		\
 					     __func__, ##arg);		\
@@ -1561,10 +1584,10 @@ int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	spin_lock_bh(&session->lock);
 	if (session->state == ISCSI_STATE_TERMINATE) {
 failed:
-		iscsi_session_printk(KERN_INFO, session,
-				     "failing target reset: Could not log "
-				     "back into target [age %d]\n",
-				     session->age);
+		ISCSI_DBG_EH(session,
+			     "failing target reset: Could not log back into "
+			     "target [age %d]\n",
+			     session->age);
 		spin_unlock_bh(&session->lock);
 		mutex_unlock(&session->eh_mutex);
 		return FAILED;
@@ -1578,7 +1601,7 @@ failed:
 	 */
 	iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 
-	ISCSI_DBG_SESSION(session, "wait for relogin\n");
+	ISCSI_DBG_EH(session, "wait for relogin\n");
 	wait_event_interruptible(conn->ehwait,
 				 session->state == ISCSI_STATE_TERMINATE ||
 				 session->state == ISCSI_STATE_LOGGED_IN ||
@@ -1588,10 +1611,10 @@ failed:
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
-	if (session->state == ISCSI_STATE_LOGGED_IN)
-		iscsi_session_printk(KERN_INFO, session,
-				     "target reset succeeded\n");
-	else
+	if (session->state == ISCSI_STATE_LOGGED_IN) {
+		ISCSI_DBG_EH(session,
+			     "target reset succeeded\n");
+	} else
 		goto failed;
 	spin_unlock_bh(&session->lock);
 	mutex_unlock(&session->eh_mutex);
@@ -1607,7 +1630,7 @@ static void iscsi_tmf_timedout(unsigned long data)
 	spin_lock(&session->lock);
 	if (conn->tmf_state == TMF_QUEUED) {
 		conn->tmf_state = TMF_TIMEDOUT;
-		ISCSI_DBG_SESSION(session, "tmf timedout\n");
+		ISCSI_DBG_EH(session, "tmf timedout\n");
 		/* unblock eh_abort() */
 		wake_up(&conn->ehwait);
 	}
@@ -1627,7 +1650,7 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 		spin_unlock_bh(&session->lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 		spin_lock_bh(&session->lock);
-		ISCSI_DBG_SESSION(session, "tmf exec failure\n");
+		ISCSI_DBG_EH(session, "tmf exec failure\n");
 		return -EPERM;
 	}
 	conn->tmfcmd_pdus_cnt++;
@@ -1635,7 +1658,7 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	conn->tmf_timer.function = iscsi_tmf_timedout;
 	conn->tmf_timer.data = (unsigned long)conn;
 	add_timer(&conn->tmf_timer);
-	ISCSI_DBG_SESSION(session, "tmf set timeout\n");
+	ISCSI_DBG_EH(session, "tmf set timeout\n");
 
 	spin_unlock_bh(&session->lock);
 	mutex_unlock(&session->eh_mutex);
@@ -1733,7 +1756,7 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
 
-	ISCSI_DBG_SESSION(session, "scsi cmd %p timedout\n", sc);
+	ISCSI_DBG_EH(session, "scsi cmd %p timedout\n", sc);
 
 	spin_lock(&session->lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
@@ -1763,10 +1786,10 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 	 * nop as a ping.
 	 */
 	if (time_after_eq(task->last_xfer, task->last_timeout)) {
-		ISCSI_DBG_CONN(conn, "Command making progress. Asking "
-			       "scsi-ml for more time to complete. "
-			       "Last data recv at %lu. Last timeout was at "
-			       "%lu\n.", task->last_xfer, task->last_timeout);
+		ISCSI_DBG_EH(session, "Command making progress. Asking "
+			     "scsi-ml for more time to complete. "
+			     "Last data recv at %lu. Last timeout was at "
+			     "%lu\n.", task->last_xfer, task->last_timeout);
 		task->have_checked_conn = false;
 		rc = BLK_EH_RESET_TIMER;
 		goto done;
@@ -1806,8 +1829,8 @@ done:
 	if (task)
 		task->last_timeout = jiffies;
 	spin_unlock(&session->lock);
-	ISCSI_DBG_SESSION(session, "return %s\n", rc == BLK_EH_RESET_TIMER ?
-			  "timer reset" : "nh");
+	ISCSI_DBG_EH(session, "return %s\n", rc == BLK_EH_RESET_TIMER ?
+		     "timer reset" : "nh");
 	return rc;
 }
 
@@ -1877,7 +1900,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
 
-	ISCSI_DBG_SESSION(session, "aborting sc %p\n", sc);
+	ISCSI_DBG_EH(session, "aborting sc %p\n", sc);
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
@@ -1886,8 +1909,8 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	 * got the command.
 	 */
 	if (!sc->SCp.ptr) {
-		ISCSI_DBG_SESSION(session, "sc never reached iscsi layer or "
-				  "it completed.\n");
+		ISCSI_DBG_EH(session, "sc never reached iscsi layer or "
+				      "it completed.\n");
 		spin_unlock_bh(&session->lock);
 		mutex_unlock(&session->eh_mutex);
 		return SUCCESS;
@@ -1901,7 +1924,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	    sc->SCp.phase != session->age) {
 		spin_unlock_bh(&session->lock);
 		mutex_unlock(&session->eh_mutex);
-		ISCSI_DBG_SESSION(session, "failing abort due to dropped "
+		ISCSI_DBG_EH(session, "failing abort due to dropped "
 				  "session.\n");
 		return FAILED;
 	}
@@ -1911,13 +1934,12 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	age = session->age;
 
 	task = (struct iscsi_task *)sc->SCp.ptr;
-	ISCSI_DBG_SESSION(session, "aborting [sc %p itt 0x%x]\n",
-			  sc, task->itt);
+	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n",
+		     sc, task->itt);
 
 	/* task completed before time out */
 	if (!task->sc) {
-		ISCSI_DBG_SESSION(session, "sc completed while abort in "
-				  "progress\n");
+		ISCSI_DBG_EH(session, "sc completed while abort in progress\n");
 		goto success;
 	}
 
@@ -1966,8 +1988,8 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		if (!sc->SCp.ptr) {
 			conn->tmf_state = TMF_INITIAL;
 			/* task completed before tmf abort response */
-			ISCSI_DBG_SESSION(session, "sc completed while abort "
-					  "in progress\n");
+			ISCSI_DBG_EH(session, "sc completed while abort	in "
+					      "progress\n");
 			goto success;
 		}
 		/* fall through */
@@ -1979,16 +2001,16 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 success:
 	spin_unlock_bh(&session->lock);
 success_unlocked:
-	ISCSI_DBG_SESSION(session, "abort success [sc %p itt 0x%x]\n",
-			  sc, task->itt);
+	ISCSI_DBG_EH(session, "abort success [sc %p itt 0x%x]\n",
+		     sc, task->itt);
 	mutex_unlock(&session->eh_mutex);
 	return SUCCESS;
 
 failed:
 	spin_unlock_bh(&session->lock);
 failed_unlocked:
-	ISCSI_DBG_SESSION(session, "abort failed [sc %p itt 0x%x]\n", sc,
-			  task ? task->itt : 0);
+	ISCSI_DBG_EH(session, "abort failed [sc %p itt 0x%x]\n", sc,
+		     task ? task->itt : 0);
 	mutex_unlock(&session->eh_mutex);
 	return FAILED;
 }
@@ -2015,8 +2037,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
 
-	ISCSI_DBG_SESSION(session, "LU Reset [sc %p lun %u]\n",
-			  sc, sc->device->lun);
+	ISCSI_DBG_EH(session, "LU Reset [sc %p lun %u]\n", sc, sc->device->lun);
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
@@ -2070,8 +2091,8 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 unlock:
 	spin_unlock_bh(&session->lock);
 done:
-	ISCSI_DBG_SESSION(session, "dev reset result = %s\n",
-			 rc == SUCCESS ? "SUCCESS" : "FAILED");
+	ISCSI_DBG_EH(session, "dev reset result = %s\n",
+		     rc == SUCCESS ? "SUCCESS" : "FAILED");
 	mutex_unlock(&session->eh_mutex);
 	return rc;
 }
-- 
1.6.2.2

