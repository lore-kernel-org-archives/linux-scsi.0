From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v2 01/16] iscsi-target: add callback to alloc and free PDU
Date: Sat,  9 Apr 2016 18:41:11 +0530
Message-ID: <674e8ae2dae3d6274dcb1abe6ddef253f6a71256.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:13140 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754068AbcDINMg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Apr 2016 09:12:36 -0400
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com

Add two callbacks to struct iscsit_transport -

1. void *(*iscsit_alloc_pdu)()
   iscsi-target uses this callback for
   iSCSI PDU allocation.

2. void (*iscsit_free_pdu)
   iscsi-target uses this callback
   to free an iSCSI PDU which was
   allocated by iscsit_alloc_pdu().

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c    | 76 ++++++++++++++++++++++++++++------
 include/target/iscsi/iscsi_transport.h |  2 +
 2 files changed, 65 insertions(+), 13 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 961202f..fdb33ba 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -499,6 +499,11 @@ static void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 	__iscsit_free_cmd(cmd, scsi_cmd, true);
 }
 
+static void *iscsit_alloc_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
+{
+	return cmd->pdu;
+}
+
 static enum target_prot_op iscsit_get_sup_prot_ops(struct iscsi_conn *conn)
 {
 	return TARGET_PROT_NORMAL;
@@ -519,6 +524,7 @@ static struct iscsit_transport iscsi_target_transport = {
 	.iscsit_queue_data_in	= iscsit_queue_rsp,
 	.iscsit_queue_status	= iscsit_queue_rsp,
 	.iscsit_aborted_task	= iscsit_aborted_task,
+	.iscsit_alloc_pdu	= iscsit_alloc_pdu,
 	.iscsit_get_sup_prot_ops = iscsit_get_sup_prot_ops,
 };
 
@@ -2537,7 +2543,10 @@ static int iscsit_send_conn_drop_async_message(
 	cmd->tx_size = ISCSI_HDR_LEN;
 	cmd->iscsi_opcode = ISCSI_OP_ASYNC_EVENT;
 
-	hdr			= (struct iscsi_async *) cmd->pdu;
+	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
+	if (unlikely(!hdr))
+		return -ENOMEM;
+
 	hdr->opcode		= ISCSI_OP_ASYNC_EVENT;
 	hdr->flags		= ISCSI_FLAG_CMD_FINAL;
 	cmd->init_task_tag	= RESERVED_ITT;
@@ -2630,7 +2639,7 @@ iscsit_build_datain_pdu(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 
 static int iscsit_send_datain(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
-	struct iscsi_data_rsp *hdr = (struct iscsi_data_rsp *)&cmd->pdu[0];
+	struct iscsi_data_rsp *hdr;
 	struct iscsi_datain datain;
 	struct iscsi_datain_req *dr;
 	struct kvec *iov;
@@ -2675,6 +2684,10 @@ static int iscsit_send_datain(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 			set_statsn = true;
 	}
 
+	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
+	if (unlikely(!hdr))
+		return -ENOMEM;
+
 	iscsit_build_datain_pdu(cmd, conn, &datain, hdr, set_statsn);
 
 	iov = &cmd->iov_data[0];
@@ -2843,13 +2856,20 @@ EXPORT_SYMBOL(iscsit_build_logout_rsp);
 static int
 iscsit_send_logout(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
+	struct iscsi_logout_rsp *hdr;
 	struct kvec *iov;
 	int niov = 0, tx_size, rc;
 
-	rc = iscsit_build_logout_rsp(cmd, conn,
-			(struct iscsi_logout_rsp *)&cmd->pdu[0]);
-	if (rc < 0)
+	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
+	if (unlikely(!hdr))
+		return -ENOMEM;
+
+	rc = iscsit_build_logout_rsp(cmd, conn, hdr);
+	if (rc < 0) {
+		if (conn->conn_transport->iscsit_free_pdu)
+			conn->conn_transport->iscsit_free_pdu(conn, cmd);
 		return rc;
+	}
 
 	tx_size = ISCSI_HDR_LEN;
 	iov = &cmd->iov_misc[0];
@@ -2909,9 +2929,13 @@ static int iscsit_send_unsolicited_nopin(
 	struct iscsi_conn *conn,
 	int want_response)
 {
-	struct iscsi_nopin *hdr = (struct iscsi_nopin *)&cmd->pdu[0];
+	struct iscsi_nopin *hdr;
 	int tx_size = ISCSI_HDR_LEN, ret;
 
+	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
+	if (unlikely(!hdr))
+		return -ENOMEM;
+
 	iscsit_build_nopin_rsp(cmd, conn, hdr, false);
 
 	if (conn->conn_ops->HeaderDigest) {
@@ -2950,11 +2974,15 @@ static int iscsit_send_unsolicited_nopin(
 static int
 iscsit_send_nopin(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
-	struct iscsi_nopin *hdr = (struct iscsi_nopin *)&cmd->pdu[0];
+	struct iscsi_nopin *hdr;
 	struct kvec *iov;
 	u32 padding = 0;
 	int niov = 0, tx_size;
 
+	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
+	if (unlikely(!hdr))
+		return -ENOMEM;
+
 	iscsit_build_nopin_rsp(cmd, conn, hdr, true);
 
 	tx_size = ISCSI_HDR_LEN;
@@ -3028,7 +3056,10 @@ static int iscsit_send_r2t(
 	if (!r2t)
 		return -1;
 
-	hdr			= (struct iscsi_r2t_rsp *) cmd->pdu;
+	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
+	if (unlikely(!hdr))
+		return -ENOMEM;
+
 	memset(hdr, 0, ISCSI_HDR_LEN);
 	hdr->opcode		= ISCSI_OP_R2T;
 	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
@@ -3203,12 +3234,16 @@ EXPORT_SYMBOL(iscsit_build_rsp_pdu);
 
 static int iscsit_send_response(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
-	struct iscsi_scsi_rsp *hdr = (struct iscsi_scsi_rsp *)&cmd->pdu[0];
+	struct iscsi_scsi_rsp *hdr;
 	struct kvec *iov;
 	u32 padding = 0, tx_size = 0;
 	int iov_count = 0;
 	bool inc_stat_sn = (cmd->i_state == ISTATE_SEND_STATUS);
 
+	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
+	if (unlikely(!hdr))
+		return -ENOMEM;
+
 	iscsit_build_rsp_pdu(cmd, conn, inc_stat_sn, hdr);
 
 	iov = &cmd->iov_misc[0];
@@ -3322,9 +3357,13 @@ EXPORT_SYMBOL(iscsit_build_task_mgt_rsp);
 static int
 iscsit_send_task_mgt_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
-	struct iscsi_tm_rsp *hdr = (struct iscsi_tm_rsp *)&cmd->pdu[0];
+	struct iscsi_tm_rsp *hdr;
 	u32 tx_size = 0;
 
+	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
+	if (unlikely(!hdr))
+		return -ENOMEM;
+
 	iscsit_build_task_mgt_rsp(cmd, conn, hdr);
 
 	cmd->iov_misc[0].iov_base	= cmd->pdu;
@@ -3582,14 +3621,21 @@ static int iscsit_send_text_rsp(
 	struct iscsi_cmd *cmd,
 	struct iscsi_conn *conn)
 {
-	struct iscsi_text_rsp *hdr = (struct iscsi_text_rsp *)cmd->pdu;
+	struct iscsi_text_rsp *hdr;
 	struct kvec *iov;
 	u32 tx_size = 0;
 	int text_length, iov_count = 0, rc;
 
+	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
+	if (unlikely(!hdr))
+		return -ENOMEM;
+
 	rc = iscsit_build_text_rsp(cmd, conn, hdr, ISCSI_TCP);
-	if (rc < 0)
+	if (rc < 0) {
+		if (conn->conn_transport->iscsit_free_pdu)
+			conn->conn_transport->iscsit_free_pdu(conn, cmd);
 		return rc;
+	}
 
 	text_length = rc;
 	iov = &cmd->iov_misc[0];
@@ -3653,10 +3699,14 @@ static int iscsit_send_reject(
 	struct iscsi_cmd *cmd,
 	struct iscsi_conn *conn)
 {
-	struct iscsi_reject *hdr = (struct iscsi_reject *)&cmd->pdu[0];
+	struct iscsi_reject *hdr;
 	struct kvec *iov;
 	u32 iov_count = 0, tx_size;
 
+	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
+	if (unlikely(!hdr))
+		return -ENOMEM;
+
 	iscsit_build_reject(cmd, conn, hdr);
 
 	iov = &cmd->iov_misc[0];
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index 90e37fa..526b715 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -22,6 +22,8 @@ struct iscsit_transport {
 	int (*iscsit_queue_data_in)(struct iscsi_conn *, struct iscsi_cmd *);
 	int (*iscsit_queue_status)(struct iscsi_conn *, struct iscsi_cmd *);
 	void (*iscsit_aborted_task)(struct iscsi_conn *, struct iscsi_cmd *);
+	void *(*iscsit_alloc_pdu)(struct iscsi_conn *, struct iscsi_cmd *);
+	void (*iscsit_free_pdu)(struct iscsi_conn *, struct iscsi_cmd *);
 	enum target_prot_op (*iscsit_get_sup_prot_ops)(struct iscsi_conn *);
 };
 
-- 
2.0.2

