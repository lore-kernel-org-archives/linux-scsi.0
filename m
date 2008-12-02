From: michaelc@cs.wisc.edu
Subject: [PATCH 07/13] iscsi_tcp: add iscsi_tcp prefix to iscsi_tcp functions
Date: Tue,  2 Dec 2008 00:32:10 -0600
Message-ID: <1228199536-12595-8-git-send-email-michaelc@cs.wisc.edu>
References: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-2-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-3-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-4-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-5-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-6-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-7-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52443 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbYLBGcZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2008 01:32:25 -0500
In-Reply-To: <1228199536-12595-7-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Add iscsi_tcp prefix to most functions. Some are not changed
becuase they are going to move in the next patch.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   38 ++++++++++++++++----------------------
 1 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index f70b68f..1db6d3b 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -516,12 +516,11 @@ static void iscsi_tcp_cleanup_task(struct iscsi_task *task)
 }
 
 /**
- * iscsi_data_in - SCSI Data-In Response processing
+ * iscsi_tcp_data_in - SCSI Data-In Response processing
  * @conn: iscsi connection
  * @task: scsi command task
- **/
-static int
-iscsi_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
+ */
+static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
@@ -554,12 +553,11 @@ iscsi_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 }
 
 /**
- * iscsi_r2t_rsp - iSCSI R2T Response processing
+ * iscsi_tcp_r2t_rsp - iSCSI R2T Response processing
  * @conn: iscsi connection
  * @task: scsi command task
- **/
-static int
-iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
+ */
+static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 {
 	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
@@ -710,7 +708,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		if (!task)
 			rc = ISCSI_ERR_BAD_ITT;
 		else
-			rc = iscsi_data_in(conn, task);
+			rc = iscsi_tcp_data_in(conn, task);
 		if (rc) {
 			spin_unlock(&conn->session->lock);
 			break;
@@ -765,7 +763,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		else if (ahslen)
 			rc = ISCSI_ERR_AHSLEN;
 		else if (task->sc->sc_data_direction == DMA_TO_DEVICE)
-			rc = iscsi_r2t_rsp(conn, task);
+			rc = iscsi_tcp_r2t_rsp(conn, task);
 		else
 			rc = ISCSI_ERR_PROTO;
 		spin_unlock(&conn->session->lock);
@@ -1053,8 +1051,7 @@ iscsi_tcp_state_change(struct sock *sk)
  * iscsi_write_space - Called when more output buffer space is available
  * @sk: socket space is available for
  **/
-static void
-iscsi_write_space(struct sock *sk)
+static void iscsi_tcp_write_space(struct sock *sk)
 {
 	struct iscsi_conn *conn = (struct iscsi_conn*)sk->sk_user_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
@@ -1064,8 +1061,7 @@ iscsi_write_space(struct sock *sk)
 	scsi_queue_work(conn->session->host, &conn->xmitwork);
 }
 
-static void
-iscsi_conn_set_callbacks(struct iscsi_conn *conn)
+static void iscsi_tcp_conn_set_callbacks(struct iscsi_conn *conn)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct sock *sk = tcp_conn->sock->sk;
@@ -1078,12 +1074,11 @@ iscsi_conn_set_callbacks(struct iscsi_conn *conn)
 	tcp_conn->old_write_space = sk->sk_write_space;
 	sk->sk_data_ready = iscsi_tcp_data_ready;
 	sk->sk_state_change = iscsi_tcp_state_change;
-	sk->sk_write_space = iscsi_write_space;
+	sk->sk_write_space = iscsi_tcp_write_space;
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
-static void
-iscsi_conn_restore_callbacks(struct iscsi_tcp_conn *tcp_conn)
+static void iscsi_conn_restore_callbacks(struct iscsi_tcp_conn *tcp_conn)
 {
 	struct sock *sk = tcp_conn->sock->sk;
 
@@ -1098,10 +1093,9 @@ iscsi_conn_restore_callbacks(struct iscsi_tcp_conn *tcp_conn)
 }
 
 /**
- * iscsi_xmit - TCP transmit
+ * iscsi_tcp_xmit - TCP transmit
  **/
-static int
-iscsi_xmit(struct iscsi_conn *conn)
+static int iscsi_tcp_xmit(struct iscsi_conn *conn)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_segment *segment = &tcp_conn->out.segment;
@@ -1159,7 +1153,7 @@ static int iscsi_tcp_flush(struct iscsi_task *task)
 	int rc;
 
 	while (iscsi_tcp_xmit_qlen(conn)) {
-		rc = iscsi_xmit(conn);
+		rc = iscsi_tcp_xmit(conn);
 		if (rc == 0)
 			return -EAGAIN;
 		if (rc < 0)
@@ -1625,7 +1619,7 @@ iscsi_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	sk->sk_sndtimeo = 15 * HZ; /* FIXME: make it configurable */
 	sk->sk_allocation = GFP_ATOMIC;
 
-	iscsi_conn_set_callbacks(conn);
+	iscsi_tcp_conn_set_callbacks(conn);
 	tcp_conn->sendpage = tcp_conn->sock->ops->sendpage;
 	/*
 	 * set receive state machine into initial state
-- 
1.5.6.5

