From: michaelc@cs.wisc.edu
Subject: [PATCH 1/3] libiscsi: fix nop xmit failure handling
Date: Thu, 14 Jun 2012 23:15:45 -0500
Message-ID: <1339733747-14731-2-git-send-email-michaelc@cs.wisc.edu>
References: <1339733747-14731-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab2FOFFk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2012 01:05:40 -0400
In-Reply-To: <1339733747-14731-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If we cannot queue a nop, because we cannot allocate
resources then retry in recv timeout seconds.

Without this patch, last_ping does not get updated, so
we end up retrying right away.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   68 +++++++++++++++++++++++++++++++----------------
 1 files changed, 45 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 82c3fd4..5b4adc4 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -701,9 +701,10 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	uint8_t opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 	struct iscsi_task *task;
 	itt_t itt;
+	int err;
 
 	if (session->state == ISCSI_STATE_TERMINATE)
-		return NULL;
+		return ERR_PTR(-ENOTCONN);
 
 	if (opcode == ISCSI_OP_LOGIN || opcode == ISCSI_OP_TEXT) {
 		/*
@@ -715,20 +716,20 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		if (conn->login_task->state != ISCSI_TASK_FREE) {
 			iscsi_conn_printk(KERN_ERR, conn, "Login/Text in "
 					  "progress. Cannot start new task.\n");
-			return NULL;
+			return ERR_PTR(-EBUSY);
 		}
 
 		task = conn->login_task;
 	} else {
 		if (session->state != ISCSI_STATE_LOGGED_IN)
-			return NULL;
+			return ERR_PTR(-ENOTCONN);
 
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
 		if (!kfifo_out(&session->cmdpool.queue,
 				 (void*)&task, sizeof(void*)))
-			return NULL;
+			return ERR_PTR(-ENOMEM);
 	}
 	/*
 	 * released in complete pdu for task we expect a response for, and
@@ -748,7 +749,8 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		task->data_count = 0;
 
 	if (conn->session->tt->alloc_pdu) {
-		if (conn->session->tt->alloc_pdu(task, hdr->opcode)) {
+		err = conn->session->tt->alloc_pdu(task, hdr->opcode);
+		if (err) {
 			iscsi_conn_printk(KERN_ERR, conn, "Could not allocate "
 					 "pdu for mgmt task.\n");
 			goto free_task;
@@ -768,10 +770,12 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	}
 
 	if (!ihost->workq) {
-		if (iscsi_prep_mgmt_task(conn, task))
+		err = iscsi_prep_mgmt_task(conn, task);
+		if (err)
 			goto free_task;
 
-		if (session->tt->xmit_task(task))
+		err = session->tt->xmit_task(task);
+		if (err)
 			goto free_task;
 	} else {
 		list_add_tail(&task->running, &conn->mgmtqueue);
@@ -782,7 +786,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 free_task:
 	__iscsi_put_task(task);
-	return NULL;
+	return ERR_PTR(err);
 }
 
 int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
@@ -790,13 +794,15 @@ int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
-	int err = 0;
+	struct iscsi_task *task;
 
 	spin_lock_bh(&session->lock);
-	if (!__iscsi_conn_send_pdu(conn, hdr, data, data_size))
-		err = -EPERM;
+	task = __iscsi_conn_send_pdu(conn, hdr, data, data_size);
 	spin_unlock_bh(&session->lock);
-	return err;
+
+	if (IS_ERR(task))
+		return PTR_ERR(task);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_send_pdu);
 
@@ -940,13 +946,14 @@ static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	wake_up(&conn->ehwait);
 }
 
-static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
+static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 {
         struct iscsi_nopout hdr;
 	struct iscsi_task *task;
+	int err;
 
 	if (!rhdr && conn->ping_task)
-		return;
+		return -EEXIST;
 
 	memset(&hdr, 0, sizeof(struct iscsi_nopout));
 	hdr.opcode = ISCSI_OP_NOOP_OUT | ISCSI_OP_IMMEDIATE;
@@ -960,13 +967,19 @@ static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 		hdr.ttt = RESERVED_ITT;
 
 	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
-	if (!task)
-		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
-	else if (!rhdr) {
+	if (IS_ERR(task)) {
+		err = PTR_ERR(task);
+
+		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout. "
+				  "Error %d.\n", err);
+		return err;
+	} else if (!rhdr) {
 		/* only track our nops */
 		conn->ping_task = task;
 		conn->last_ping = jiffies;
 	}
+
+	return 0;
 }
 
 static int iscsi_nop_out_rsp(struct iscsi_task *task,
@@ -1766,14 +1779,13 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	struct iscsi_session *session = conn->session;
 	struct iscsi_task *task;
 
-	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
-				      NULL, 0);
-	if (!task) {
+	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
+	if (IS_ERR(task)) {
 		spin_unlock_bh(&session->lock);
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send TMF.\n");
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 		spin_lock_bh(&session->lock);
-		return -EPERM;
+		return PTR_ERR(task);
 	}
 	conn->tmfcmd_pdus_cnt++;
 	conn->tmf_timer.expires = timeout * HZ + jiffies;
@@ -2033,6 +2045,7 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 	struct iscsi_conn *conn = (struct iscsi_conn *)data;
 	struct iscsi_session *session = conn->session;
 	unsigned long recv_timeout, next_timeout = 0, last_recv;
+	int err;
 
 	spin_lock(&session->lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN)
@@ -2059,8 +2072,17 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 	if (time_before_eq(last_recv + recv_timeout, jiffies)) {
 		/* send a ping to try to provoke some traffic */
 		ISCSI_DBG_CONN(conn, "Sending nopout as ping\n");
-		iscsi_send_nopout(conn, NULL);
-		next_timeout = conn->last_ping + (conn->ping_timeout * HZ);
+		err = iscsi_send_nopout(conn, NULL);
+		if (!err || err == -EEXIST)
+			next_timeout = conn->last_ping +
+						(conn->ping_timeout * HZ);
+		else
+			/*
+			 * If we could not send due to resource error or slow
+			 * conn not taking things off of queue quick enough
+			 * then we do not want to drop the session.
+			 */
+			next_timeout = jiffies + recv_timeout;
 	} else
 		next_timeout = last_recv + recv_timeout;
 
-- 
1.7.7.6

