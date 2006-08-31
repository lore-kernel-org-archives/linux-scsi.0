From: michaelc@cs.wisc.edu
Subject: [PATCH 2/12] add refcouting around ctask usage in main IO patch
Date: Thu, 31 Aug 2006 18:09:25 -0400
Message-ID: <11570621781978-git-send-email-michaelc@cs.wisc.edu>
References: <11570621752047-git-send-email-michaelc@cs.wisc.edu> <11570621761945-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:23430 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932288AbWHaXJW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 19:09:22 -0400
In-Reply-To: <11570621761945-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

It is possible that a ctask could be completing and getting
cleaned up at the same time, we are finishing up the last
data transfer. This could then result in the data transfer
code using stale or invalid values. This patch adds a refcount
to the ctask. When the count goes to zero then we know the
transmit thread and recv thread or softirq are not touching
it and we can safely release it.

The eh should not need to grab a reference because it only cleans
up a task if it has both the xmit mutex and recv lock (or recv
side suspended).
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   59 ++++++++++++++++++++++++++++++++++++++++-------
 include/scsi/libiscsi.h |    1 +
 2 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index a7c6e70..9584cbc 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -179,16 +179,15 @@ EXPORT_SYMBOL_GPL(iscsi_prep_scsi_cmd_pd
 
 /**
  * iscsi_complete_command - return command back to scsi-ml
- * @session: iscsi session
  * @ctask: iscsi cmd task
  *
  * Must be called with session lock.
  * This function returns the scsi command to scsi-ml and returns
  * the cmd task to the pool of available cmd tasks.
  */
-static void iscsi_complete_command(struct iscsi_session *session,
-				   struct iscsi_cmd_task *ctask)
+static void iscsi_complete_command(struct iscsi_cmd_task *ctask)
 {
+	struct iscsi_session *session = ctask->conn->session;
 	struct scsi_cmnd *sc = ctask->sc;
 
 	ctask->state = ISCSI_TASK_COMPLETED;
@@ -198,6 +197,35 @@ static void iscsi_complete_command(struc
 	sc->scsi_done(sc);
 }
 
+static void __iscsi_get_ctask(struct iscsi_cmd_task *ctask)
+{
+	atomic_inc(&ctask->refcount);
+}
+
+static void iscsi_get_ctask(struct iscsi_cmd_task *ctask)
+{
+	spin_lock_bh(&ctask->conn->session->lock);
+	__iscsi_get_ctask(ctask);
+	spin_unlock_bh(&ctask->conn->session->lock);
+}
+
+static void __iscsi_put_ctask(struct iscsi_cmd_task *ctask)
+{
+	struct iscsi_conn *conn = ctask->conn;
+
+	if (atomic_dec_and_test(&ctask->refcount)) {
+		conn->session->tt->cleanup_cmd_task(conn, ctask);
+		iscsi_complete_command(ctask);
+	}
+}
+
+static void iscsi_put_ctask(struct iscsi_cmd_task *ctask)
+{
+	spin_lock_bh(&ctask->conn->session->lock);
+	__iscsi_put_ctask(ctask);
+	spin_unlock_bh(&ctask->conn->session->lock);
+}
+
 /**
  * iscsi_cmd_rsp - SCSI Command Response processing
  * @conn: iscsi connection
@@ -274,7 +302,7 @@ out:
 		   (long)sc, sc->result, ctask->itt);
 	conn->scsirsp_pdus_cnt++;
 
-	iscsi_complete_command(conn->session, ctask);
+	__iscsi_put_ctask(ctask);
 	return rc;
 }
 
@@ -338,7 +366,7 @@ int __iscsi_complete_pdu(struct iscsi_co
 			BUG_ON((void*)ctask != ctask->sc->SCp.ptr);
 			if (hdr->flags & ISCSI_FLAG_DATA_STATUS) {
 				conn->scsirsp_pdus_cnt++;
-				iscsi_complete_command(session, ctask);
+				__iscsi_put_ctask(ctask);
 			}
 			break;
 		case ISCSI_OP_R2T:
@@ -563,7 +591,9 @@ static int iscsi_data_xmit(struct iscsi_
 	BUG_ON(conn->ctask && conn->mtask);
 
 	if (conn->ctask) {
+		iscsi_get_ctask(conn->ctask);
 		rc = tt->xmit_cmd_task(conn, conn->ctask);
+		iscsi_put_ctask(conn->ctask);
 		if (rc)
 			goto again;
 		/* done with this in-progress ctask */
@@ -604,12 +634,19 @@ static int iscsi_data_xmit(struct iscsi_
 					 struct iscsi_cmd_task, running);
 		conn->ctask->state = ISCSI_TASK_RUNNING;
 		list_move_tail(conn->xmitqueue.next, &conn->run_list);
+		__iscsi_get_ctask(conn->ctask);
 		spin_unlock_bh(&conn->session->lock);
 
 		rc = tt->xmit_cmd_task(conn, conn->ctask);
 		if (rc)
 			goto again;
+
 		spin_lock_bh(&conn->session->lock);
+		__iscsi_put_ctask(conn->ctask);
+		if (rc) {
+			spin_unlock_bh(&conn->session->lock);
+			goto again;
+		}
 	}
 	spin_unlock_bh(&conn->session->lock);
 	/* done with this ctask */
@@ -659,6 +696,7 @@ enum {
 	FAILURE_SESSION_FAILED,
 	FAILURE_SESSION_FREED,
 	FAILURE_WINDOW_CLOSED,
+	FAILURE_OOM,
 	FAILURE_SESSION_TERMINATE,
 	FAILURE_SESSION_IN_RECOVERY,
 	FAILURE_SESSION_RECOVERY_TIMEOUT,
@@ -717,10 +755,15 @@ int iscsi_queuecommand(struct scsi_cmnd 
 
 	conn = session->leadconn;
 
-	__kfifo_get(session->cmdpool.queue, (void*)&ctask, sizeof(void*));
+	if (!__kfifo_get(session->cmdpool.queue, (void*)&ctask,
+			 sizeof(void*))) {
+		reason = FAILURE_OOM;
+		goto reject;
+	}
 	sc->SCp.phase = session->age;
 	sc->SCp.ptr = (char *)ctask;
 
+	atomic_set(&ctask->refcount, 1);
 	ctask->state = ISCSI_TASK_PENDING;
 	ctask->mtask = NULL;
 	ctask->conn = conn;
@@ -1057,13 +1100,11 @@ static void fail_command(struct iscsi_co
 	sc = ctask->sc;
 	if (!sc)
 		return;
-
-	conn->session->tt->cleanup_cmd_task(conn, ctask);
 	iscsi_ctask_mtask_cleanup(ctask);
 
 	sc->result = err;
 	sc->resid = sc->request_bufflen;
-	iscsi_complete_command(conn->session, ctask);
+	__iscsi_put_ctask(ctask);
 }
 
 int iscsi_eh_abort(struct scsi_cmnd *sc)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 4900650..401192e 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -112,6 +112,7 @@ struct iscsi_cmd_task {
 
 	/* state set/tested under session->lock */
 	int			state;
+	atomic_t		refcount;
 	struct list_head	running;	/* running cmd list */
 	void			*dd_data;	/* driver/transport data */
 };
-- 
1.4.1.1

