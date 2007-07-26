From: michaelc@cs.wisc.edu
Subject: [PATCH 4/4] libiscsi: fix cmd seqeunce number checking
Date: Thu, 26 Jul 2007 12:46:48 -0500
Message-ID: <1185472013396-git-send-email-michaelc@cs.wisc.edu>
References: <11854720083011-git-send-email-michaelc@cs.wisc.edu>
 <1185472010604-git-send-email-michaelc@cs.wisc.edu>
 <11854720113567-git-send-email-michaelc@cs.wisc.edu>
 <1185472013785-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122AbXGZRrE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 13:47:04 -0400
In-Reply-To: <1185472013785-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We should not be checking the cmd windown for just handling r2t responses.
And if the window closes in on us, always have scsi-ml requeue the command
from our queuecommand function.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   46 +++++++++++++++++++++++++---------------------
 include/scsi/libiscsi.h |    3 +++
 2 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 271a2d6..5606d1e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -596,9 +596,16 @@ static void iscsi_prep_mtask(struct iscsi_conn *conn,
 	nop->cmdsn = cpu_to_be32(session->cmdsn);
 	if (hdr->itt != RESERVED_ITT) {
 		hdr->itt = build_itt(mtask->itt, conn->id, session->age);
+		/*
+		 * TODO: We always use immediate, so we never hit this.
+		 * If we start to send tmfs or nops as non-immediate then
+		 * we should start checking the cmdsn numbers for mgmt tasks.
+		 */
 		if (conn->c_stage == ISCSI_CONN_STARTED &&
-		    !(hdr->opcode & ISCSI_OP_IMMEDIATE))
+		    !(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
+			session->queued_cmdsn++;
 			session->cmdsn++;
+		}
 	}
 
 	if (session->tt->init_mgmt_task)
@@ -641,9 +648,11 @@ static int iscsi_check_cmdsn_window_closed(struct iscsi_conn *conn)
 	/*
 	 * Check for iSCSI window and take care of CmdSN wrap-around
 	 */
-	if (!iscsi_sna_lte(session->cmdsn, session->max_cmdsn)) {
-		debug_scsi("iSCSI CmdSN closed. MaxCmdSN %u CmdSN %u\n",
-			   session->max_cmdsn, session->cmdsn);
+	if (!iscsi_sna_lte(session->queued_cmdsn, session->max_cmdsn)) {
+		debug_scsi("iSCSI CmdSN closed. ExpCmdSn %u MaxCmdSN %u "
+			   "CmdSN %u/%u\n", session->exp_cmdsn,
+			   session->max_cmdsn, session->cmdsn,
+			   session->queued_cmdsn);
 		return -ENOSPC;
 	}
 	return 0;
@@ -722,11 +731,6 @@ check_mgmt:
 
 	/* process command queue */
 	while (!list_empty(&conn->xmitqueue)) {
-		rc = iscsi_check_cmdsn_window_closed(conn);
-		if (rc) {
-			spin_unlock_bh(&conn->session->lock);
-			return rc;
-		}
 		/*
 		 * iscsi tcp may readd the task to the xmitqueue to send
 		 * write data
@@ -834,12 +838,6 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		goto fault;
 	}
 
-	/*
-	 * We check this here and in data xmit, because if we get to the point
-	 * that this check is hitting the window then we have enough IO in
-	 * flight and enough IO waiting to be transmitted it is better
-	 * to let the scsi/block layer queue up.
-	 */
 	if (iscsi_check_cmdsn_window_closed(conn)) {
 		reason = FAILURE_WINDOW_CLOSED;
 		goto reject;
@@ -850,6 +848,8 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		reason = FAILURE_OOM;
 		goto reject;
 	}
+	session->queued_cmdsn++;
+
 	sc->SCp.phase = session->age;
 	sc->SCp.ptr = (char *)ctask;
 
@@ -1140,7 +1140,13 @@ static void fail_command(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 	if (!sc)
 		return;
 
-	if (ctask->state != ISCSI_TASK_PENDING)
+	if (ctask->state == ISCSI_TASK_PENDING)
+		/*
+		 * cmd never made it to the xmit thread, so we should not count
+		 * the cmd in the sequencing
+		 */
+		conn->session->queued_cmdsn--;
+	else
 		conn->session->tt->cleanup_cmd_task(conn, ctask);
 	iscsi_ctask_mtask_cleanup(ctask);
 
@@ -1392,7 +1398,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit,
 	session->state = ISCSI_STATE_FREE;
 	session->mgmtpool_max = ISCSI_MGMT_CMDS_MAX;
 	session->cmds_max = cmds_max;
-	session->cmdsn = initial_cmdsn;
+	session->queued_cmdsn = session->cmdsn = initial_cmdsn;
 	session->exp_cmdsn = initial_cmdsn + 1;
 	session->max_cmdsn = initial_cmdsn + 1;
 	session->max_r2t = 1;
@@ -1616,11 +1622,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	kfree(conn->persistent_address);
 	__kfifo_put(session->mgmtpool.queue, (void*)&conn->login_mtask,
 		    sizeof(void*));
-	if (session->leadconn == conn) {
+	if (session->leadconn == conn)
 		session->leadconn = NULL;
-		/* no connections exits.. reset sequencing */
-		session->cmdsn = session->max_cmdsn = session->exp_cmdsn = 1;
-	}
 	spin_unlock_bh(&session->lock);
 
 	kfifo_free(conn->mgmtqueue);
@@ -1650,6 +1653,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	spin_lock_bh(&session->lock);
 	conn->c_stage = ISCSI_CONN_STARTED;
 	session->state = ISCSI_STATE_LOGGED_IN;
+	session->queued_cmdsn = session->cmdsn;
 
 	switch(conn->stop_stage) {
 	case STOP_CONN_RECOVER:
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 3f631b0..007d442 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -210,6 +210,9 @@ struct iscsi_session {
 	uint32_t		exp_cmdsn;
 	uint32_t		max_cmdsn;
 
+	/* This tracks the reqs queued into the initiator */
+	uint32_t		queued_cmdsn;
+
 	/* configuration */
 	int			initial_r2t_en;
 	unsigned		max_r2t;
-- 
1.5.1.2

