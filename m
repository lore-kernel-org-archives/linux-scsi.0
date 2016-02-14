From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 17/34] iscsi-target: split iscsit_send_conn_drop_async_message()
Date: Sun, 14 Feb 2016 23:12:11 +0530
Message-ID: <c5e4a6f880f18f712cf24ea529f2a9b3ac81303b.1455467089.git.varun@chelsio.com>
References: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

move code to form iscsi_async hdr to new function
iscsit_build_conn_drop_async_pdu(), so that
ISCSI_TCP_CXGB4 and other transport drivers
can reuse this code.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c    | 26 ++++++++++++++++++--------
 include/target/iscsi/iscsi_transport.h |  3 +++
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 6137e26..8bf3cfb 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2531,16 +2531,11 @@ static void iscsit_build_conn_drop_async_message(struct iscsi_conn *conn)
 	iscsit_dec_conn_usage_count(conn_p);
 }
 
-static int iscsit_send_conn_drop_async_message(
+void iscsit_build_conn_drop_async_pdu(
 	struct iscsi_cmd *cmd,
-	struct iscsi_conn *conn)
+	struct iscsi_conn *conn,
+	struct iscsi_async *hdr)
 {
-	struct iscsi_async *hdr;
-
-	cmd->tx_size = ISCSI_HDR_LEN;
-	cmd->iscsi_opcode = ISCSI_OP_ASYNC_EVENT;
-
-	hdr			= (struct iscsi_async *) cmd->pdu;
 	hdr->opcode		= ISCSI_OP_ASYNC_EVENT;
 	hdr->flags		= ISCSI_FLAG_CMD_FINAL;
 	cmd->init_task_tag	= RESERVED_ITT;
@@ -2554,6 +2549,21 @@ static int iscsit_send_conn_drop_async_message(
 	hdr->param1		= cpu_to_be16(cmd->logout_cid);
 	hdr->param2		= cpu_to_be16(conn->sess->sess_ops->DefaultTime2Wait);
 	hdr->param3		= cpu_to_be16(conn->sess->sess_ops->DefaultTime2Retain);
+}
+EXPORT_SYMBOL(iscsit_build_conn_drop_async_pdu);
+
+static int iscsit_send_conn_drop_async_message(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	struct iscsi_async *hdr;
+
+	cmd->tx_size = ISCSI_HDR_LEN;
+	cmd->iscsi_opcode = ISCSI_OP_ASYNC_EVENT;
+
+	hdr			= (struct iscsi_async *)cmd->pdu;
+
+	iscsit_build_conn_drop_async_pdu(cmd, conn, hdr);
 
 	if (conn->conn_ops->HeaderDigest) {
 		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index 746404a..a47124b 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -89,6 +89,9 @@ extern int iscsit_build_r2ts_for_cmd(struct iscsi_conn *, struct iscsi_cmd *,
 				     bool);
 extern void iscsit_build_r2t_pdu(struct iscsi_cmd *, struct iscsi_conn *,
 				 struct iscsi_r2t *, struct iscsi_r2t_rsp *);
+extern void iscsit_build_conn_drop_async_pdu(struct iscsi_cmd *,
+					     struct iscsi_conn *,
+					     struct iscsi_async *);
 /*
  * From iscsi_target_device.c
  */
-- 
2.0.2
