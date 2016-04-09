From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v2 02/16] iscsi-target: add int (*iscsit_xmit_pdu)()
Date: Sat,  9 Apr 2016 18:41:12 +0530
Message-ID: <d55c42a5c5465a3c5e5226e7ba1e49e5d357a94c.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

Add int (*iscsit_xmit_pdu)() to
struct iscsit_transport, iscsi-target
uses this callback to transmit an
iSCSI PDU.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c    | 391 +++++++++------------------------
 include/target/iscsi/iscsi_transport.h |   2 +
 2 files changed, 102 insertions(+), 291 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index fdb33ba..0e7a481 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -504,6 +504,79 @@ static void *iscsit_alloc_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 	return cmd->pdu;
 }
 
+static void iscsit_do_crypto_hash_buf(struct ahash_request *, const void *,
+				      u32, u32, u8 *, u8 *);
+static void iscsit_tx_thread_wait_for_tcp(struct iscsi_conn *);
+
+static int iscsit_xmit_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+			   const void *data_buf, u32 data_buf_len)
+{
+	struct iscsi_hdr *hdr = (struct iscsi_hdr *)cmd->pdu;
+	struct kvec *iov;
+	u32 niov = 0, tx_size = ISCSI_HDR_LEN;
+	int ret;
+
+	iov = &cmd->iov_misc[0];
+	iov[niov].iov_base	= cmd->pdu;
+	iov[niov++].iov_len	= ISCSI_HDR_LEN;
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(conn->conn_tx_hash, hdr,
+					  ISCSI_HDR_LEN, 0, NULL,
+					  (u8 *)header_digest);
+
+		iov[0].iov_len += ISCSI_CRC_LEN;
+		tx_size += ISCSI_CRC_LEN;
+		pr_debug("Attaching CRC32C HeaderDigest"
+			 " to opcode 0x%x 0x%08x\n",
+			 hdr->opcode, *header_digest);
+	}
+
+	if (data_buf_len) {
+		u32 padding = ((-data_buf_len) & 3);
+
+		iov[niov].iov_base	= (void *)data_buf;
+		iov[niov++].iov_len	= data_buf_len;
+		tx_size += data_buf_len;
+
+		if (padding != 0) {
+			iov[niov].iov_base = &cmd->pad_bytes;
+			iov[niov++].iov_len = padding;
+			tx_size += padding;
+			pr_debug("Attaching %u additional"
+				 " padding bytes.\n", padding);
+		}
+
+		if (conn->conn_ops->DataDigest) {
+			iscsit_do_crypto_hash_buf(conn->conn_tx_hash,
+						  data_buf, data_buf_len,
+						  padding,
+						  (u8 *)&cmd->pad_bytes,
+						  (u8 *)&cmd->data_crc);
+
+			iov[niov].iov_base = &cmd->data_crc;
+			iov[niov++].iov_len = ISCSI_CRC_LEN;
+			tx_size += ISCSI_CRC_LEN;
+			pr_debug("Attached DataDigest for %u"
+				 " bytes opcode 0x%x, CRC 0x%08x\n",
+				 data_buf_len, hdr->opcode, cmd->data_crc);
+		}
+	}
+
+	cmd->iov_misc_count = niov;
+	cmd->tx_size = tx_size;
+
+	ret = iscsit_send_tx_data(cmd, conn, 1);
+	if (ret < 0) {
+		iscsit_tx_thread_wait_for_tcp(conn);
+		return ret;
+	}
+
+	return 0;
+}
+
 static enum target_prot_op iscsit_get_sup_prot_ops(struct iscsi_conn *conn)
 {
 	return TARGET_PROT_NORMAL;
@@ -525,6 +598,7 @@ static struct iscsit_transport iscsi_target_transport = {
 	.iscsit_queue_status	= iscsit_queue_rsp,
 	.iscsit_aborted_task	= iscsit_aborted_task,
 	.iscsit_alloc_pdu	= iscsit_alloc_pdu,
+	.iscsit_xmit_pdu	= iscsit_xmit_pdu,
 	.iscsit_get_sup_prot_ops = iscsit_get_sup_prot_ops,
 };
 
@@ -2540,7 +2614,6 @@ static int iscsit_send_conn_drop_async_message(
 {
 	struct iscsi_async *hdr;
 
-	cmd->tx_size = ISCSI_HDR_LEN;
 	cmd->iscsi_opcode = ISCSI_OP_ASYNC_EVENT;
 
 	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
@@ -2561,25 +2634,11 @@ static int iscsit_send_conn_drop_async_message(
 	hdr->param2		= cpu_to_be16(conn->sess->sess_ops->DefaultTime2Wait);
 	hdr->param3		= cpu_to_be16(conn->sess->sess_ops->DefaultTime2Retain);
 
-	if (conn->conn_ops->HeaderDigest) {
-		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
-
-		iscsit_do_crypto_hash_buf(conn->conn_tx_hash, hdr,
-				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
-
-		cmd->tx_size += ISCSI_CRC_LEN;
-		pr_debug("Attaching CRC32C HeaderDigest to"
-			" Async Message 0x%08x\n", *header_digest);
-	}
-
-	cmd->iov_misc[0].iov_base	= cmd->pdu;
-	cmd->iov_misc[0].iov_len	= cmd->tx_size;
-	cmd->iov_misc_count		= 1;
-
 	pr_debug("Sending Connection Dropped Async Message StatSN:"
 		" 0x%08x, for CID: %hu on CID: %hu\n", cmd->stat_sn,
 			cmd->logout_cid, conn->cid);
-	return 0;
+
+	return conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL, 0);
 }
 
 static void iscsit_tx_thread_wait_for_tcp(struct iscsi_conn *conn)
@@ -2857,8 +2916,7 @@ static int
 iscsit_send_logout(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
 	struct iscsi_logout_rsp *hdr;
-	struct kvec *iov;
-	int niov = 0, tx_size, rc;
+	int rc;
 
 	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
 	if (unlikely(!hdr))
@@ -2871,26 +2929,7 @@ iscsit_send_logout(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 		return rc;
 	}
 
-	tx_size = ISCSI_HDR_LEN;
-	iov = &cmd->iov_misc[0];
-	iov[niov].iov_base	= cmd->pdu;
-	iov[niov++].iov_len	= ISCSI_HDR_LEN;
-
-	if (conn->conn_ops->HeaderDigest) {
-		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
-
-		iscsit_do_crypto_hash_buf(conn->conn_tx_hash, &cmd->pdu[0],
-				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
-
-		iov[0].iov_len += ISCSI_CRC_LEN;
-		tx_size += ISCSI_CRC_LEN;
-		pr_debug("Attaching CRC32C HeaderDigest to"
-			" Logout Response 0x%08x\n", *header_digest);
-	}
-	cmd->iov_misc_count = niov;
-	cmd->tx_size = tx_size;
-
-	return 0;
+	return conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL, 0);
 }
 
 void
@@ -2930,7 +2969,7 @@ static int iscsit_send_unsolicited_nopin(
 	int want_response)
 {
 	struct iscsi_nopin *hdr;
-	int tx_size = ISCSI_HDR_LEN, ret;
+	int ret;
 
 	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
 	if (unlikely(!hdr))
@@ -2938,30 +2977,12 @@ static int iscsit_send_unsolicited_nopin(
 
 	iscsit_build_nopin_rsp(cmd, conn, hdr, false);
 
-	if (conn->conn_ops->HeaderDigest) {
-		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
-
-		iscsit_do_crypto_hash_buf(conn->conn_tx_hash, hdr,
-				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
-
-		tx_size += ISCSI_CRC_LEN;
-		pr_debug("Attaching CRC32C HeaderDigest to"
-			" NopIN 0x%08x\n", *header_digest);
-	}
-
-	cmd->iov_misc[0].iov_base	= cmd->pdu;
-	cmd->iov_misc[0].iov_len	= tx_size;
-	cmd->iov_misc_count	= 1;
-	cmd->tx_size		= tx_size;
-
 	pr_debug("Sending Unsolicited NOPIN TTT: 0x%08x StatSN:"
 		" 0x%08x CID: %hu\n", hdr->ttt, cmd->stat_sn, conn->cid);
 
-	ret = iscsit_send_tx_data(cmd, conn, 1);
-	if (ret < 0) {
-		iscsit_tx_thread_wait_for_tcp(conn);
+	ret = conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL, 0);
+	if (ret < 0)
 		return ret;
-	}
 
 	spin_lock_bh(&cmd->istate_lock);
 	cmd->i_state = want_response ?
@@ -2975,9 +2996,6 @@ static int
 iscsit_send_nopin(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
 	struct iscsi_nopin *hdr;
-	struct kvec *iov;
-	u32 padding = 0;
-	int niov = 0, tx_size;
 
 	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
 	if (unlikely(!hdr))
@@ -2985,69 +3003,20 @@ iscsit_send_nopin(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 
 	iscsit_build_nopin_rsp(cmd, conn, hdr, true);
 
-	tx_size = ISCSI_HDR_LEN;
-	iov = &cmd->iov_misc[0];
-	iov[niov].iov_base	= cmd->pdu;
-	iov[niov++].iov_len	= ISCSI_HDR_LEN;
-
-	if (conn->conn_ops->HeaderDigest) {
-		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
-
-		iscsit_do_crypto_hash_buf(conn->conn_tx_hash, hdr,
-				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
-
-		iov[0].iov_len += ISCSI_CRC_LEN;
-		tx_size += ISCSI_CRC_LEN;
-		pr_debug("Attaching CRC32C HeaderDigest"
-			" to NopIn 0x%08x\n", *header_digest);
-	}
-
 	/*
 	 * NOPOUT Ping Data is attached to struct iscsi_cmd->buf_ptr.
 	 * NOPOUT DataSegmentLength is at struct iscsi_cmd->buf_ptr_size.
 	 */
-	if (cmd->buf_ptr_size) {
-		iov[niov].iov_base	= cmd->buf_ptr;
-		iov[niov++].iov_len	= cmd->buf_ptr_size;
-		tx_size += cmd->buf_ptr_size;
-
-		pr_debug("Echoing back %u bytes of ping"
-			" data.\n", cmd->buf_ptr_size);
-
-		padding = ((-cmd->buf_ptr_size) & 3);
-		if (padding != 0) {
-			iov[niov].iov_base = &cmd->pad_bytes;
-			iov[niov++].iov_len = padding;
-			tx_size += padding;
-			pr_debug("Attaching %u additional"
-				" padding bytes.\n", padding);
-		}
-		if (conn->conn_ops->DataDigest) {
-			iscsit_do_crypto_hash_buf(conn->conn_tx_hash,
-				cmd->buf_ptr, cmd->buf_ptr_size,
-				padding, (u8 *)&cmd->pad_bytes,
-				(u8 *)&cmd->data_crc);
+	pr_debug("Echoing back %u bytes of ping data.\n", cmd->buf_ptr_size);
 
-			iov[niov].iov_base = &cmd->data_crc;
-			iov[niov++].iov_len = ISCSI_CRC_LEN;
-			tx_size += ISCSI_CRC_LEN;
-			pr_debug("Attached DataDigest for %u"
-				" bytes of ping data, CRC 0x%08x\n",
-				cmd->buf_ptr_size, cmd->data_crc);
-		}
-	}
-
-	cmd->iov_misc_count = niov;
-	cmd->tx_size = tx_size;
-
-	return 0;
+	return conn->conn_transport->iscsit_xmit_pdu(conn, cmd, cmd->buf_ptr,
+						     cmd->buf_ptr_size);
 }
 
 static int iscsit_send_r2t(
 	struct iscsi_cmd *cmd,
 	struct iscsi_conn *conn)
 {
-	int tx_size = 0;
 	struct iscsi_r2t *r2t;
 	struct iscsi_r2t_rsp *hdr;
 	int ret;
@@ -3075,38 +3044,18 @@ static int iscsit_send_r2t(
 	hdr->data_offset	= cpu_to_be32(r2t->offset);
 	hdr->data_length	= cpu_to_be32(r2t->xfer_len);
 
-	cmd->iov_misc[0].iov_base	= cmd->pdu;
-	cmd->iov_misc[0].iov_len	= ISCSI_HDR_LEN;
-	tx_size += ISCSI_HDR_LEN;
-
-	if (conn->conn_ops->HeaderDigest) {
-		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
-
-		iscsit_do_crypto_hash_buf(conn->conn_tx_hash, hdr,
-				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
-
-		cmd->iov_misc[0].iov_len += ISCSI_CRC_LEN;
-		tx_size += ISCSI_CRC_LEN;
-		pr_debug("Attaching CRC32 HeaderDigest for R2T"
-			" PDU 0x%08x\n", *header_digest);
-	}
-
 	pr_debug("Built %sR2T, ITT: 0x%08x, TTT: 0x%08x, StatSN:"
 		" 0x%08x, R2TSN: 0x%08x, Offset: %u, DDTL: %u, CID: %hu\n",
 		(!r2t->recovery_r2t) ? "" : "Recovery ", cmd->init_task_tag,
 		r2t->targ_xfer_tag, ntohl(hdr->statsn), r2t->r2t_sn,
 			r2t->offset, r2t->xfer_len, conn->cid);
 
-	cmd->iov_misc_count = 1;
-	cmd->tx_size = tx_size;
-
 	spin_lock_bh(&cmd->r2t_lock);
 	r2t->sent_r2t = 1;
 	spin_unlock_bh(&cmd->r2t_lock);
 
-	ret = iscsit_send_tx_data(cmd, conn, 1);
+	ret = conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL, 0);
 	if (ret < 0) {
-		iscsit_tx_thread_wait_for_tcp(conn);
 		return ret;
 	}
 
@@ -3235,10 +3184,9 @@ EXPORT_SYMBOL(iscsit_build_rsp_pdu);
 static int iscsit_send_response(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
 	struct iscsi_scsi_rsp *hdr;
-	struct kvec *iov;
-	u32 padding = 0, tx_size = 0;
-	int iov_count = 0;
 	bool inc_stat_sn = (cmd->i_state == ISTATE_SEND_STATUS);
+	void *data_buf = NULL;
+	u32 padding = 0, data_buf_len = 0;
 
 	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
 	if (unlikely(!hdr))
@@ -3246,11 +3194,6 @@ static int iscsit_send_response(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 
 	iscsit_build_rsp_pdu(cmd, conn, inc_stat_sn, hdr);
 
-	iov = &cmd->iov_misc[0];
-	iov[iov_count].iov_base	= cmd->pdu;
-	iov[iov_count++].iov_len = ISCSI_HDR_LEN;
-	tx_size += ISCSI_HDR_LEN;
-
 	/*
 	 * Attach SENSE DATA payload to iSCSI Response PDU
 	 */
@@ -3262,56 +3205,23 @@ static int iscsit_send_response(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 
 		padding		= -(cmd->se_cmd.scsi_sense_length) & 3;
 		hton24(hdr->dlength, (u32)cmd->se_cmd.scsi_sense_length);
-		iov[iov_count].iov_base	= cmd->sense_buffer;
-		iov[iov_count++].iov_len =
-				(cmd->se_cmd.scsi_sense_length + padding);
-		tx_size += cmd->se_cmd.scsi_sense_length;
+		data_buf = cmd->sense_buffer;
+		data_buf_len = cmd->se_cmd.scsi_sense_length + padding;
 
 		if (padding) {
 			memset(cmd->sense_buffer +
 				cmd->se_cmd.scsi_sense_length, 0, padding);
-			tx_size += padding;
 			pr_debug("Adding %u bytes of padding to"
 				" SENSE.\n", padding);
 		}
 
-		if (conn->conn_ops->DataDigest) {
-			iscsit_do_crypto_hash_buf(conn->conn_tx_hash,
-				cmd->sense_buffer,
-				(cmd->se_cmd.scsi_sense_length + padding),
-				0, NULL, (u8 *)&cmd->data_crc);
-
-			iov[iov_count].iov_base    = &cmd->data_crc;
-			iov[iov_count++].iov_len     = ISCSI_CRC_LEN;
-			tx_size += ISCSI_CRC_LEN;
-
-			pr_debug("Attaching CRC32 DataDigest for"
-				" SENSE, %u bytes CRC 0x%08x\n",
-				(cmd->se_cmd.scsi_sense_length + padding),
-				cmd->data_crc);
-		}
-
 		pr_debug("Attaching SENSE DATA: %u bytes to iSCSI"
 				" Response PDU\n",
 				cmd->se_cmd.scsi_sense_length);
 	}
 
-	if (conn->conn_ops->HeaderDigest) {
-		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
-
-		iscsit_do_crypto_hash_buf(conn->conn_tx_hash, cmd->pdu,
-				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
-
-		iov[0].iov_len += ISCSI_CRC_LEN;
-		tx_size += ISCSI_CRC_LEN;
-		pr_debug("Attaching CRC32 HeaderDigest for Response"
-				" PDU 0x%08x\n", *header_digest);
-	}
-
-	cmd->iov_misc_count = iov_count;
-	cmd->tx_size = tx_size;
-
-	return 0;
+	return conn->conn_transport->iscsit_xmit_pdu(conn, cmd, data_buf,
+						     data_buf_len);
 }
 
 static u8 iscsit_convert_tcm_tmr_rsp(struct se_tmr_req *se_tmr)
@@ -3358,7 +3268,6 @@ static int
 iscsit_send_task_mgt_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
 	struct iscsi_tm_rsp *hdr;
-	u32 tx_size = 0;
 
 	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
 	if (unlikely(!hdr))
@@ -3366,26 +3275,7 @@ iscsit_send_task_mgt_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 
 	iscsit_build_task_mgt_rsp(cmd, conn, hdr);
 
-	cmd->iov_misc[0].iov_base	= cmd->pdu;
-	cmd->iov_misc[0].iov_len	= ISCSI_HDR_LEN;
-	tx_size += ISCSI_HDR_LEN;
-
-	if (conn->conn_ops->HeaderDigest) {
-		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
-
-		iscsit_do_crypto_hash_buf(conn->conn_tx_hash, hdr,
-				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
-
-		cmd->iov_misc[0].iov_len += ISCSI_CRC_LEN;
-		tx_size += ISCSI_CRC_LEN;
-		pr_debug("Attaching CRC32 HeaderDigest for Task"
-			" Mgmt Response PDU 0x%08x\n", *header_digest);
-	}
-
-	cmd->iov_misc_count = 1;
-	cmd->tx_size = tx_size;
-
-	return 0;
+	return conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL, 0);
 }
 
 static bool iscsit_check_inaddr_any(struct iscsi_np *np)
@@ -3622,60 +3512,21 @@ static int iscsit_send_text_rsp(
 	struct iscsi_conn *conn)
 {
 	struct iscsi_text_rsp *hdr;
-	struct kvec *iov;
-	u32 tx_size = 0;
-	int text_length, iov_count = 0, rc;
+	int text_length;
 
 	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
 	if (unlikely(!hdr))
 		return -ENOMEM;
 
-	rc = iscsit_build_text_rsp(cmd, conn, hdr, ISCSI_TCP);
-	if (rc < 0) {
+	text_length = iscsit_build_text_rsp(cmd, conn, hdr, ISCSI_TCP);
+	if (text_length < 0) {
 		if (conn->conn_transport->iscsit_free_pdu)
 			conn->conn_transport->iscsit_free_pdu(conn, cmd);
-		return rc;
-	}
-
-	text_length = rc;
-	iov = &cmd->iov_misc[0];
-	iov[iov_count].iov_base = cmd->pdu;
-	iov[iov_count++].iov_len = ISCSI_HDR_LEN;
-	iov[iov_count].iov_base	= cmd->buf_ptr;
-	iov[iov_count++].iov_len = text_length;
-
-	tx_size += (ISCSI_HDR_LEN + text_length);
-
-	if (conn->conn_ops->HeaderDigest) {
-		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
-
-		iscsit_do_crypto_hash_buf(conn->conn_tx_hash, hdr,
-				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
-
-		iov[0].iov_len += ISCSI_CRC_LEN;
-		tx_size += ISCSI_CRC_LEN;
-		pr_debug("Attaching CRC32 HeaderDigest for"
-			" Text Response PDU 0x%08x\n", *header_digest);
-	}
-
-	if (conn->conn_ops->DataDigest) {
-		iscsit_do_crypto_hash_buf(conn->conn_tx_hash,
-				cmd->buf_ptr, text_length,
-				0, NULL, (u8 *)&cmd->data_crc);
-
-		iov[iov_count].iov_base	= &cmd->data_crc;
-		iov[iov_count++].iov_len = ISCSI_CRC_LEN;
-		tx_size	+= ISCSI_CRC_LEN;
-
-		pr_debug("Attaching DataDigest for %u bytes of text"
-			" data, CRC 0x%08x\n", text_length,
-			cmd->data_crc);
+		return text_length;
 	}
 
-	cmd->iov_misc_count = iov_count;
-	cmd->tx_size = tx_size;
-
-	return 0;
+	return conn->conn_transport->iscsit_xmit_pdu(conn, cmd, cmd->buf_ptr,
+						     text_length);
 }
 
 void
@@ -3700,8 +3551,6 @@ static int iscsit_send_reject(
 	struct iscsi_conn *conn)
 {
 	struct iscsi_reject *hdr;
-	struct kvec *iov;
-	u32 iov_count = 0, tx_size;
 
 	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
 	if (unlikely(!hdr))
@@ -3709,44 +3558,11 @@ static int iscsit_send_reject(
 
 	iscsit_build_reject(cmd, conn, hdr);
 
-	iov = &cmd->iov_misc[0];
-	iov[iov_count].iov_base = cmd->pdu;
-	iov[iov_count++].iov_len = ISCSI_HDR_LEN;
-	iov[iov_count].iov_base = cmd->buf_ptr;
-	iov[iov_count++].iov_len = ISCSI_HDR_LEN;
-
-	tx_size = (ISCSI_HDR_LEN + ISCSI_HDR_LEN);
-
-	if (conn->conn_ops->HeaderDigest) {
-		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
-
-		iscsit_do_crypto_hash_buf(conn->conn_tx_hash, hdr,
-				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
-
-		iov[0].iov_len += ISCSI_CRC_LEN;
-		tx_size += ISCSI_CRC_LEN;
-		pr_debug("Attaching CRC32 HeaderDigest for"
-			" REJECT PDU 0x%08x\n", *header_digest);
-	}
-
-	if (conn->conn_ops->DataDigest) {
-		iscsit_do_crypto_hash_buf(conn->conn_tx_hash, cmd->buf_ptr,
-				ISCSI_HDR_LEN, 0, NULL, (u8 *)&cmd->data_crc);
-
-		iov[iov_count].iov_base = &cmd->data_crc;
-		iov[iov_count++].iov_len  = ISCSI_CRC_LEN;
-		tx_size += ISCSI_CRC_LEN;
-		pr_debug("Attaching CRC32 DataDigest for REJECT"
-				" PDU 0x%08x\n", cmd->data_crc);
-	}
-
-	cmd->iov_misc_count = iov_count;
-	cmd->tx_size = tx_size;
-
 	pr_debug("Built Reject PDU StatSN: 0x%08x, Reason: 0x%02x,"
 		" CID: %hu\n", ntohl(hdr->statsn), hdr->reason, conn->cid);
 
-	return 0;
+	return conn->conn_transport->iscsit_xmit_pdu(conn, cmd, cmd->buf_ptr,
+						     ISCSI_HDR_LEN);
 }
 
 void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
@@ -3939,13 +3755,6 @@ check_rsp_state:
 	if (ret < 0)
 		goto err;
 
-	if (iscsit_send_tx_data(cmd, conn, 1) < 0) {
-		iscsit_tx_thread_wait_for_tcp(conn);
-		iscsit_unmap_iovec(cmd);
-		goto err;
-	}
-	iscsit_unmap_iovec(cmd);
-
 	switch (state) {
 	case ISTATE_SEND_LOGOUTRSP:
 		if (!iscsit_logout_post_handler(cmd, conn))
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index 526b715..f09973f 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -24,6 +24,8 @@ struct iscsit_transport {
 	void (*iscsit_aborted_task)(struct iscsi_conn *, struct iscsi_cmd *);
 	void *(*iscsit_alloc_pdu)(struct iscsi_conn *, struct iscsi_cmd *);
 	void (*iscsit_free_pdu)(struct iscsi_conn *, struct iscsi_cmd *);
+	int (*iscsit_xmit_pdu)(struct iscsi_conn *, struct iscsi_cmd *,
+			       const void *, u32);
 	enum target_prot_op (*iscsit_get_sup_prot_ops)(struct iscsi_conn *);
 };
 
-- 
2.0.2
