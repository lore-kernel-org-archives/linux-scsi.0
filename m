From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 23/34] iscsi-target: split iscsi_target_rx_thread()
Date: Sun, 14 Feb 2016 23:15:30 +0530
Message-ID: <494c1253bad50c0173f7869a2a8ede5dbe5ed7a5.1455467089.git.varun@chelsio.com>
References: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:8588 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751481AbcBNRqG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Feb 2016 12:46:06 -0500
In-Reply-To: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com

split iscsi_target_rx_thread() into two parts,
1. iscsi_target_rx_thread() is common to all
   transport drivers, it will call Rx function
   registered by transport driver.

2. iscsit_rx_pdu() is Rx function for
   ISCSI_TCP transport.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c | 59 +++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index e2ec56f..485e33a 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -480,6 +480,7 @@ int iscsit_del_np(struct iscsi_np *np)
 
 static int iscsit_immediate_queue(struct iscsi_conn *, struct iscsi_cmd *, int);
 static int iscsit_response_queue(struct iscsi_conn *, struct iscsi_cmd *, int);
+static void iscsit_rx_pdu(struct iscsi_conn *);
 
 int iscsit_queue_rsp(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
@@ -521,6 +522,7 @@ static struct iscsit_transport iscsi_target_transport = {
 	.iscsit_queue_data_in	= iscsit_queue_rsp,
 	.iscsit_queue_status	= iscsit_queue_rsp,
 	.iscsit_aborted_task	= iscsit_aborted_task,
+	.iscsit_rx_pdu		= iscsit_rx_pdu,
 	.iscsit_get_sup_prot_ops = iscsit_get_sup_prot_ops,
 };
 
@@ -4112,30 +4114,12 @@ static bool iscsi_target_check_conn_state(struct iscsi_conn *conn)
 	return ret;
 }
 
-int iscsi_target_rx_thread(void *arg)
+static void iscsit_rx_pdu(struct iscsi_conn *conn)
 {
-	int ret, rc;
+	int ret;
 	u8 buffer[ISCSI_HDR_LEN], opcode;
 	u32 checksum = 0, digest = 0;
-	struct iscsi_conn *conn = arg;
 	struct kvec iov;
-	/*
-	 * Allow ourselves to be interrupted by SIGINT so that a
-	 * connection recovery / failure event can be triggered externally.
-	 */
-	allow_signal(SIGINT);
-	/*
-	 * Wait for iscsi_post_login_handler() to complete before allowing
-	 * incoming iscsi/tcp socket I/O, and/or failing the connection.
-	 */
-	rc = wait_for_completion_interruptible(&conn->rx_login_comp);
-	if (rc < 0 || iscsi_target_check_conn_state(conn))
-		return 0;
-
-	if (conn->conn_transport->iscsit_rx_pdu) {
-		conn->conn_transport->iscsit_rx_pdu(conn);
-		goto transport_err;
-	}
 
 	while (!kthread_should_stop()) {
 		/*
@@ -4153,7 +4137,7 @@ int iscsi_target_rx_thread(void *arg)
 		ret = rx_data(conn, &iov, 1, ISCSI_HDR_LEN);
 		if (ret != ISCSI_HDR_LEN) {
 			iscsit_rx_thread_wait_for_tcp(conn);
-			goto transport_err;
+			return;
 		}
 
 		if (conn->conn_ops->HeaderDigest) {
@@ -4163,7 +4147,7 @@ int iscsi_target_rx_thread(void *arg)
 			ret = rx_data(conn, &iov, 1, ISCSI_CRC_LEN);
 			if (ret != ISCSI_CRC_LEN) {
 				iscsit_rx_thread_wait_for_tcp(conn);
-				goto transport_err;
+				return;
 			}
 
 			iscsit_do_crypto_hash_buf(&conn->conn_rx_hash,
@@ -4187,7 +4171,7 @@ int iscsi_target_rx_thread(void *arg)
 		}
 
 		if (conn->conn_state == TARG_CONN_STATE_IN_LOGOUT)
-			goto transport_err;
+			return;
 
 		opcode = buffer[0] & ISCSI_OPCODE_MASK;
 
@@ -4198,15 +4182,38 @@ int iscsi_target_rx_thread(void *arg)
 			" while in Discovery Session, rejecting.\n", opcode);
 			iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 					  buffer);
-			goto transport_err;
+			return;
 		}
 
 		ret = iscsi_target_rx_opcode(conn, buffer);
 		if (ret < 0)
-			goto transport_err;
+			return;
 	}
+}
+
+int iscsi_target_rx_thread(void *arg)
+{
+	int rc;
+	struct iscsi_conn *conn = arg;
+
+	/*
+	 * Allow ourselves to be interrupted by SIGINT so that a
+	 * connection recovery / failure event can be triggered externally.
+	 */
+	allow_signal(SIGINT);
+	/*
+	 * Wait for iscsi_post_login_handler() to complete before allowing
+	 * incoming iscsi/tcp socket I/O, and/or failing the connection.
+	 */
+	rc = wait_for_completion_interruptible(&conn->rx_login_comp);
+	if (rc < 0 || iscsi_target_check_conn_state(conn))
+		return 0;
+
+	if (!conn->conn_transport->iscsit_rx_pdu)
+		return 0;
+
+	conn->conn_transport->iscsit_rx_pdu(conn);
 
-transport_err:
 	if (!signal_pending(current))
 		atomic_set(&conn->transport_failed, 1);
 	iscsit_take_action_for_connection_exit(conn);
-- 
2.0.2

