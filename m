From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v2 06/16] iscsi-target: split iscsi_target_rx_thread()
Date: Sat,  9 Apr 2016 18:41:16 +0530
Message-ID: <f30eb551f28cb233f228c57fdecc585453472f6a.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

split iscsi_target_rx_thread() into two parts,
1. iscsi_target_rx_thread() is common to all
   transport drivers, it will call Rx function
   registered by transport driver.

2. iscsit_get_rx_pdu() is Rx function for
   ISCSI_TCP transport.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c | 59 +++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 4311636..98d96d4 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -480,6 +480,7 @@ int iscsit_del_np(struct iscsi_np *np)
 
 static int iscsit_immediate_queue(struct iscsi_conn *, struct iscsi_cmd *, int);
 static int iscsit_response_queue(struct iscsi_conn *, struct iscsi_cmd *, int);
+static void iscsit_get_rx_pdu(struct iscsi_conn *);
 
 static int iscsit_queue_rsp(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
@@ -678,6 +679,7 @@ static struct iscsit_transport iscsi_target_transport = {
 	.iscsit_alloc_pdu	= iscsit_alloc_pdu,
 	.iscsit_xmit_pdu	= iscsit_xmit_pdu,
 	.iscsit_xmit_datain_pdu = iscsit_xmit_datain_pdu,
+	.iscsit_get_rx_pdu	= iscsit_get_rx_pdu,
 	.iscsit_get_sup_prot_ops = iscsit_get_sup_prot_ops,
 };
 
@@ -3969,30 +3971,12 @@ static bool iscsi_target_check_conn_state(struct iscsi_conn *conn)
 	return ret;
 }
 
-int iscsi_target_rx_thread(void *arg)
+static void iscsit_get_rx_pdu(struct iscsi_conn *conn)
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
-	if (conn->conn_transport->iscsit_get_rx_pdu) {
-		conn->conn_transport->iscsit_get_rx_pdu(conn);
-		goto transport_err;
-	}
 
 	while (!kthread_should_stop()) {
 		/*
@@ -4010,7 +3994,7 @@ int iscsi_target_rx_thread(void *arg)
 		ret = rx_data(conn, &iov, 1, ISCSI_HDR_LEN);
 		if (ret != ISCSI_HDR_LEN) {
 			iscsit_rx_thread_wait_for_tcp(conn);
-			goto transport_err;
+			return;
 		}
 
 		if (conn->conn_ops->HeaderDigest) {
@@ -4020,7 +4004,7 @@ int iscsi_target_rx_thread(void *arg)
 			ret = rx_data(conn, &iov, 1, ISCSI_CRC_LEN);
 			if (ret != ISCSI_CRC_LEN) {
 				iscsit_rx_thread_wait_for_tcp(conn);
-				goto transport_err;
+				return;
 			}
 
 			iscsit_do_crypto_hash_buf(conn->conn_rx_hash,
@@ -4044,7 +4028,7 @@ int iscsi_target_rx_thread(void *arg)
 		}
 
 		if (conn->conn_state == TARG_CONN_STATE_IN_LOGOUT)
-			goto transport_err;
+			return;
 
 		opcode = buffer[0] & ISCSI_OPCODE_MASK;
 
@@ -4055,15 +4039,38 @@ int iscsi_target_rx_thread(void *arg)
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
+	if (!conn->conn_transport->iscsit_get_rx_pdu)
+		return 0;
+
+	conn->conn_transport->iscsit_get_rx_pdu(conn);
 
-transport_err:
 	if (!signal_pending(current))
 		atomic_set(&conn->transport_failed, 1);
 	iscsit_take_action_for_connection_exit(conn);
-- 
2.0.2
