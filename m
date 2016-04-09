From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v2 03/16] iscsi-target: add int (*iscsit_xmit_datain_pdu)()
Date: Sat,  9 Apr 2016 18:41:13 +0530
Message-ID: <9cf062fac7d7501001cd9cdf6b29db59314dc086.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:58288 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754272AbcDINNC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Apr 2016 09:13:02 -0400
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com

Add int (*iscsit_xmit_datain_pdu)() to
struct iscsit_transport, iscsi-target
uses this callback to transmit a DATAIN
iSCSI PDU.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c    | 143 +++++++++++++++++++--------------
 include/target/iscsi/iscsi_transport.h |   3 +
 2 files changed, 86 insertions(+), 60 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 0e7a481..9e65e5d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -577,6 +577,84 @@ static int iscsit_xmit_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	return 0;
 }
 
+static int iscsit_map_iovec(struct iscsi_cmd *, struct kvec *, u32, u32);
+static void iscsit_unmap_iovec(struct iscsi_cmd *);
+static u32 iscsit_do_crypto_hash_sg(struct ahash_request *, struct iscsi_cmd *,
+				    u32, u32, u32, u8 *);
+static int
+iscsit_xmit_datain_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+		       struct iscsi_datain_req *dr, struct iscsi_datain *datain)
+{
+	struct kvec *iov;
+	u32 iov_count = 0, tx_size = 0;
+	int ret, iov_ret;
+
+	iov = &cmd->iov_data[0];
+	iov[iov_count].iov_base	= cmd->pdu;
+	iov[iov_count++].iov_len = ISCSI_HDR_LEN;
+	tx_size += ISCSI_HDR_LEN;
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(conn->conn_tx_hash, cmd->pdu,
+					  ISCSI_HDR_LEN, 0, NULL,
+					  (u8 *)header_digest);
+
+		iov[0].iov_len += ISCSI_CRC_LEN;
+		tx_size += ISCSI_CRC_LEN;
+
+		pr_debug("Attaching CRC32 HeaderDigest for DataIN PDU 0x%08x\n",
+			 *header_digest);
+	}
+
+	iov_ret = iscsit_map_iovec(cmd, &cmd->iov_data[1],
+				   datain->offset, datain->length);
+	if (iov_ret < 0)
+		return -1;
+
+	iov_count += iov_ret;
+	tx_size += datain->length;
+
+	cmd->padding = ((-datain->length) & 3);
+	if (cmd->padding) {
+		iov[iov_count].iov_base		= cmd->pad_bytes;
+		iov[iov_count++].iov_len	= cmd->padding;
+		tx_size += cmd->padding;
+
+		pr_debug("Attaching %u padding bytes\n", cmd->padding);
+	}
+
+	if (conn->conn_ops->DataDigest) {
+		cmd->data_crc = iscsit_do_crypto_hash_sg(conn->conn_tx_hash,
+							 cmd, datain->offset,
+							 datain->length,
+							 cmd->padding,
+							 cmd->pad_bytes);
+
+		iov[iov_count].iov_base	= &cmd->data_crc;
+		iov[iov_count++].iov_len = ISCSI_CRC_LEN;
+		tx_size += ISCSI_CRC_LEN;
+
+		pr_debug("Attached CRC32C DataDigest %d bytes, crc 0x%08x\n",
+			 datain->length + cmd->padding, cmd->data_crc);
+	}
+
+	cmd->iov_data_count = iov_count;
+	cmd->tx_size = tx_size;
+
+	ret = iscsit_fe_sendpage_sg(cmd, conn);
+
+	iscsit_unmap_iovec(cmd);
+
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
@@ -599,6 +677,7 @@ static struct iscsit_transport iscsi_target_transport = {
 	.iscsit_aborted_task	= iscsit_aborted_task,
 	.iscsit_alloc_pdu	= iscsit_alloc_pdu,
 	.iscsit_xmit_pdu	= iscsit_xmit_pdu,
+	.iscsit_xmit_datain_pdu = iscsit_xmit_datain_pdu,
 	.iscsit_get_sup_prot_ops = iscsit_get_sup_prot_ops,
 };
 
@@ -2701,9 +2780,7 @@ static int iscsit_send_datain(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	struct iscsi_data_rsp *hdr;
 	struct iscsi_datain datain;
 	struct iscsi_datain_req *dr;
-	struct kvec *iov;
-	u32 iov_count = 0, tx_size = 0;
-	int eodr = 0, ret, iov_ret;
+	int eodr = 0, ret;
 	bool set_statsn = false;
 
 	memset(&datain, 0, sizeof(struct iscsi_datain));
@@ -2749,64 +2826,10 @@ static int iscsit_send_datain(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 
 	iscsit_build_datain_pdu(cmd, conn, &datain, hdr, set_statsn);
 
-	iov = &cmd->iov_data[0];
-	iov[iov_count].iov_base	= cmd->pdu;
-	iov[iov_count++].iov_len	= ISCSI_HDR_LEN;
-	tx_size += ISCSI_HDR_LEN;
-
-	if (conn->conn_ops->HeaderDigest) {
-		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
-
-		iscsit_do_crypto_hash_buf(conn->conn_tx_hash, cmd->pdu,
-				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
-
-		iov[0].iov_len += ISCSI_CRC_LEN;
-		tx_size += ISCSI_CRC_LEN;
-
-		pr_debug("Attaching CRC32 HeaderDigest"
-			" for DataIN PDU 0x%08x\n", *header_digest);
-	}
-
-	iov_ret = iscsit_map_iovec(cmd, &cmd->iov_data[1],
-				datain.offset, datain.length);
-	if (iov_ret < 0)
-		return -1;
-
-	iov_count += iov_ret;
-	tx_size += datain.length;
-
-	cmd->padding = ((-datain.length) & 3);
-	if (cmd->padding) {
-		iov[iov_count].iov_base		= cmd->pad_bytes;
-		iov[iov_count++].iov_len	= cmd->padding;
-		tx_size += cmd->padding;
-
-		pr_debug("Attaching %u padding bytes\n",
-				cmd->padding);
-	}
-	if (conn->conn_ops->DataDigest) {
-		cmd->data_crc = iscsit_do_crypto_hash_sg(conn->conn_tx_hash, cmd,
-			 datain.offset, datain.length, cmd->padding, cmd->pad_bytes);
-
-		iov[iov_count].iov_base	= &cmd->data_crc;
-		iov[iov_count++].iov_len = ISCSI_CRC_LEN;
-		tx_size += ISCSI_CRC_LEN;
-
-		pr_debug("Attached CRC32C DataDigest %d bytes, crc"
-			" 0x%08x\n", datain.length+cmd->padding, cmd->data_crc);
-	}
-
-	cmd->iov_data_count = iov_count;
-	cmd->tx_size = tx_size;
-
-	ret = iscsit_fe_sendpage_sg(cmd, conn);
-
-	iscsit_unmap_iovec(cmd);
-
-	if (ret < 0) {
-		iscsit_tx_thread_wait_for_tcp(conn);
+	ret = conn->conn_transport->iscsit_xmit_datain_pdu(conn, cmd,
+							   dr, &datain);
+	if (ret < 0)
 		return ret;
-	}
 
 	if (dr->dr_complete) {
 		eodr = (cmd->se_cmd.se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ?
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index f09973f..77ae41e 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -26,6 +26,9 @@ struct iscsit_transport {
 	void (*iscsit_free_pdu)(struct iscsi_conn *, struct iscsi_cmd *);
 	int (*iscsit_xmit_pdu)(struct iscsi_conn *, struct iscsi_cmd *,
 			       const void *, u32);
+	int (*iscsit_xmit_datain_pdu)(struct iscsi_conn *, struct iscsi_cmd *,
+				      struct iscsi_datain_req *,
+				      struct iscsi_datain *);
 	enum target_prot_op (*iscsit_get_sup_prot_ops)(struct iscsi_conn *);
 };
 
-- 
2.0.2

