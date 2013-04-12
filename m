From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v4 6/9] iscsi-target: Refactor RX PDU logic + export request PDU handling
Date: Fri, 12 Apr 2013 20:52:39 +0000
Message-ID: <1365799962-13543-7-git-send-email-nab@linux-iscsi.org>
References: <1365799962-13543-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1365799962-13543-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch refactors existing traditional iscsi RX side PDU handling
to use iscsit_transport, and exports the necessary logic for external
transport modules.

This includes:

- Refactor iscsit_handle_scsi_cmd() into PDU setup / processing
- Add updated iscsit_handle_scsi_cmd() for tradtional iscsi code
- Add iscsit_set_unsoliticed_dataout() wrapper
- Refactor iscsit_handle_data_out() into PDU check / processing
- Add updated iscsit_handle_data_out() for tradtional iscsi code
- Add iscsit_handle_nop_out() + iscsit_handle_task_mgt_cmd() to
  accept pre-allocated struct iscsi_cmd
- Add iscsit_build_r2ts_for_cmd() caller for iscsi_target_transport
  to handle ISTATE_SEND_R2T for TX immediate queue
- Refactor main traditional iscsi iscsi_target_rx_thread() PDU switch
  into iscsi_target_rx_opcode() using iscsit_allocate_cmd()
- Turn iscsi_target_rx_thread() process context into NOP for
  ib_isert side work-queue.

v3 changes:
- Add extra target_put_sess_cmd call in iscsit_add_reject_from_cmd
  after completion

v2 changes:

- Disable iscsit_ack_from_expstatsn() usage for RDMAExtentions=Yes
- Disable iscsit_allocate_datain_req() usage for RDMAExtentions=Yes
- Add target_get_sess_cmd() reference counting to
  iscsit_setup_scsi_cmd()
- Add TFO->lio_check_stop_free() fabric API caller
- Add export of iscsit_stop_dataout_timer() symbol
- Add iscsit_build_r2ts_for_cmd() for iscsit_transport->iscsit_get_dataout()
- Convert existing usage of iscsit_build_r2ts_for_cmd() to
  ->iscsit_get_dataout()
- Drop RDMAExtentions=Yes specific check in iscsit_build_r2ts_for_cmd()
- Fix RDMAExtentions -> RDMAExtensions typo (andy)
- Pass correct dump_payload value into iscsit_get_immediate_data()
  for iscsit_handle_scsi_cmd()

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c          |  486 ++++++++++++++++----------
 drivers/target/iscsi/iscsi_target.h          |    3 +-
 drivers/target/iscsi/iscsi_target_configfs.c |    9 +-
 drivers/target/iscsi/iscsi_target_erl1.c     |   13 +-
 drivers/target/iscsi/iscsi_target_login.c    |    3 +-
 drivers/target/iscsi/iscsi_target_nego.c     |   15 -
 drivers/target/iscsi/iscsi_target_tmr.c      |    3 +-
 drivers/target/iscsi/iscsi_target_util.c     |    1 +
 8 files changed, 331 insertions(+), 202 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index b01a10e..19d4e08 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -492,6 +492,7 @@ static struct iscsit_transport iscsi_target_transport = {
 	.iscsit_alloc_cmd	= iscsit_alloc_cmd,
 	.iscsit_get_login_rx	= iscsit_get_login_rx,
 	.iscsit_put_login_tx	= iscsit_put_login_tx,
+	.iscsit_get_dataout	= iscsit_build_r2ts_for_cmd,
 };
 
 static int __init iscsi_target_init_module(void)
@@ -650,6 +651,14 @@ static int iscsit_add_reject(
 	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
 
 	ret = wait_for_completion_interruptible(&cmd->reject_comp);
+	/*
+	 * Perform the kref_put now if se_cmd has been setup by
+	 * iscsit_setup_scsi_cmd()
+	 */
+	if (cmd->se_cmd.se_tfo != NULL) {
+		pr_debug("iscsi reject: calling target_put_sess_cmd >>>>>>\n");
+		target_put_sess_cmd(conn->sess->se_sess, &cmd->se_cmd);
+	}
 	if (ret != 0)
 		return -1;
 
@@ -698,11 +707,20 @@ int iscsit_add_reject_from_cmd(
 	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
 
 	ret = wait_for_completion_interruptible(&cmd->reject_comp);
+	/*
+	 * Perform the kref_put now if se_cmd has already been setup by
+	 * scsit_setup_scsi_cmd()
+	 */
+	if (cmd->se_cmd.se_tfo != NULL) {
+		pr_debug("iscsi reject: calling target_put_sess_cmd >>>>>>\n");
+		target_put_sess_cmd(conn->sess->se_sess, &cmd->se_cmd);
+	}
 	if (ret != 0)
 		return -1;
 
 	return (!fail_conn) ? 0 : -1;
 }
+EXPORT_SYMBOL(iscsit_add_reject_from_cmd);
 
 /*
  * Map some portion of the allocated scatterlist to an iovec, suitable for
@@ -761,6 +779,9 @@ static void iscsit_ack_from_expstatsn(struct iscsi_conn *conn, u32 exp_statsn)
 
 	conn->exp_statsn = exp_statsn;
 
+	if (conn->sess->sess_ops->RDMAExtensions)
+		return;
+
 	spin_lock_bh(&conn->cmd_lock);
 	list_for_each_entry(cmd, &conn->conn_cmd_list, i_conn_node) {
 		spin_lock(&cmd->istate_lock);
@@ -793,12 +814,10 @@ static int iscsit_allocate_iovecs(struct iscsi_cmd *cmd)
 	return 0;
 }
 
-static int iscsit_handle_scsi_cmd(
-	struct iscsi_conn *conn,
-	unsigned char *buf)
+int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+			  unsigned char *buf)
 {
-	int data_direction, payload_length, cmdsn_ret = 0, immed_ret;
-	struct iscsi_cmd *cmd = NULL;
+	int data_direction, payload_length;
 	struct iscsi_scsi_req *hdr;
 	int iscsi_task_attr;
 	int sam_task_attr;
@@ -821,8 +840,8 @@ static int iscsit_handle_scsi_cmd(
 	    !(hdr->flags & ISCSI_FLAG_CMD_FINAL)) {
 		pr_err("ISCSI_FLAG_CMD_WRITE & ISCSI_FLAG_CMD_FINAL"
 				" not set. Bad iSCSI Initiator.\n");
-		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
-				buf, conn);
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
+				1, 1, buf, cmd);
 	}
 
 	if (((hdr->flags & ISCSI_FLAG_CMD_READ) ||
@@ -842,8 +861,8 @@ static int iscsit_handle_scsi_cmd(
 		pr_err("ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE"
 			" set when Expected Data Transfer Length is 0 for"
 			" CDB: 0x%02x. Bad iSCSI Initiator.\n", hdr->cdb[0]);
-		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
-				buf, conn);
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
+				1, 1, buf, cmd);
 	}
 done:
 
@@ -852,29 +871,29 @@ done:
 		pr_err("ISCSI_FLAG_CMD_READ and/or ISCSI_FLAG_CMD_WRITE"
 			" MUST be set if Expected Data Transfer Length is not 0."
 			" Bad iSCSI Initiator\n");
-		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
-				buf, conn);
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
+				1, 1, buf, cmd);
 	}
 
 	if ((hdr->flags & ISCSI_FLAG_CMD_READ) &&
 	    (hdr->flags & ISCSI_FLAG_CMD_WRITE)) {
 		pr_err("Bidirectional operations not supported!\n");
-		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
-				buf, conn);
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
+				1, 1, buf, cmd);
 	}
 
 	if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
 		pr_err("Illegally set Immediate Bit in iSCSI Initiator"
 				" Scsi Command PDU.\n");
-		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
-				buf, conn);
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
+				1, 1, buf, cmd);
 	}
 
 	if (payload_length && !conn->sess->sess_ops->ImmediateData) {
 		pr_err("ImmediateData=No but DataSegmentLength=%u,"
 			" protocol error.\n", payload_length);
-		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
-				buf, conn);
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
+				1, 1, buf, cmd);
 	}
 
 	if ((be32_to_cpu(hdr->data_length )== payload_length) &&
@@ -882,43 +901,38 @@ done:
 		pr_err("Expected Data Transfer Length and Length of"
 			" Immediate Data are the same, but ISCSI_FLAG_CMD_FINAL"
 			" bit is not set protocol error\n");
-		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
-				buf, conn);
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
+				1, 1, buf, cmd);
 	}
 
 	if (payload_length > be32_to_cpu(hdr->data_length)) {
 		pr_err("DataSegmentLength: %u is greater than"
 			" EDTL: %u, protocol error.\n", payload_length,
 				hdr->data_length);
-		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
-				buf, conn);
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
+				1, 1, buf, cmd);
 	}
 
 	if (payload_length > conn->conn_ops->MaxXmitDataSegmentLength) {
 		pr_err("DataSegmentLength: %u is greater than"
 			" MaxXmitDataSegmentLength: %u, protocol error.\n",
 			payload_length, conn->conn_ops->MaxXmitDataSegmentLength);
-		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
-				buf, conn);
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
+				1, 1, buf, cmd);
 	}
 
 	if (payload_length > conn->sess->sess_ops->FirstBurstLength) {
 		pr_err("DataSegmentLength: %u is greater than"
 			" FirstBurstLength: %u, protocol error.\n",
 			payload_length, conn->sess->sess_ops->FirstBurstLength);
-		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
-					buf, conn);
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
+				1, 1, buf, cmd);
 	}
 
 	data_direction = (hdr->flags & ISCSI_FLAG_CMD_WRITE) ? DMA_TO_DEVICE :
 			 (hdr->flags & ISCSI_FLAG_CMD_READ) ? DMA_FROM_DEVICE :
 			  DMA_NONE;
 
-	cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
-	if (!cmd)
-		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES, 1,
-					 buf, conn);
-
 	cmd->data_direction = data_direction;
 	iscsi_task_attr = hdr->flags & ISCSI_FLAG_CMD_ATTR_MASK;
 	/*
@@ -961,7 +975,8 @@ done:
 	cmd->exp_stat_sn	= be32_to_cpu(hdr->exp_statsn);
 	cmd->first_burst_len	= payload_length;
 
-	if (cmd->data_direction == DMA_FROM_DEVICE) {
+	if (!conn->sess->sess_ops->RDMAExtensions &&
+	     cmd->data_direction == DMA_FROM_DEVICE) {
 		struct iscsi_datain_req *dr;
 
 		dr = iscsit_allocate_datain_req();
@@ -983,7 +998,10 @@ done:
 
 	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
 		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
-		hdr->cmdsn, hdr->data_length, payload_length, conn->cid);
+		hdr->cmdsn, be32_to_cpu(hdr->data_length), payload_length,
+		conn->cid);
+
+	target_get_sess_cmd(conn->sess->se_sess, &cmd->se_cmd, true);
 
 	cmd->sense_reason = transport_lookup_cmd_lun(&cmd->se_cmd,
 						     scsilun_to_int(&hdr->lun));
@@ -1017,12 +1035,24 @@ attach_cmd:
 	 */
 	core_alua_check_nonop_delay(&cmd->se_cmd);
 
-	if (iscsit_allocate_iovecs(cmd) < 0) {
-		return iscsit_add_reject_from_cmd(
-				ISCSI_REASON_BOOKMARK_NO_RESOURCES,
-				1, 0, buf, cmd);
-	}
+	return 0;
+}
+EXPORT_SYMBOL(iscsit_setup_scsi_cmd);
+
+void iscsit_set_unsoliticed_dataout(struct iscsi_cmd *cmd)
+{
+	iscsit_set_dataout_sequence_values(cmd);
+
+	spin_lock_bh(&cmd->dataout_timeout_lock);
+	iscsit_start_dataout_timer(cmd, cmd->conn);
+	spin_unlock_bh(&cmd->dataout_timeout_lock);
+}
+EXPORT_SYMBOL(iscsit_set_unsoliticed_dataout);
 
+int iscsit_process_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+			    struct iscsi_scsi_req *hdr)
+{
+	int cmdsn_ret = 0;
 	/*
 	 * Check the CmdSN against ExpCmdSN/MaxCmdSN here if
 	 * the Immediate Bit is not set, and no Immediate
@@ -1040,7 +1070,7 @@ attach_cmd:
 		else if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
 			return iscsit_add_reject_from_cmd(
 				ISCSI_REASON_PROTOCOL_ERROR,
-				1, 0, buf, cmd);
+				1, 0, (unsigned char *)hdr, cmd);
 	}
 
 	iscsit_ack_from_expstatsn(conn, be32_to_cpu(hdr->exp_statsn));
@@ -1049,13 +1079,8 @@ attach_cmd:
 	 * If no Immediate Data is attached, it's OK to return now.
 	 */
 	if (!cmd->immediate_data) {
-		if (!cmd->sense_reason && cmd->unsolicited_data) {
-			iscsit_set_dataout_sequence_values(cmd);
-
-			spin_lock_bh(&cmd->dataout_timeout_lock);
-			iscsit_start_dataout_timer(cmd, cmd->conn);
-			spin_unlock_bh(&cmd->dataout_timeout_lock);
-		}
+		if (!cmd->sense_reason && cmd->unsolicited_data)
+			iscsit_set_unsoliticed_dataout(cmd);
 
 		return 0;
 	}
@@ -1065,21 +1090,33 @@ attach_cmd:
 	 * thread.  They are processed in CmdSN order by
 	 * iscsit_check_received_cmdsn() below.
 	 */
-	if (cmd->sense_reason) {
-		immed_ret = IMMEDIATE_DATA_NORMAL_OPERATION;
-		goto after_immediate_data;
-	}
+	if (cmd->sense_reason)
+		return 1;
 	/*
 	 * Call directly into transport_generic_new_cmd() to perform
 	 * the backend memory allocation.
 	 */
 	cmd->sense_reason = transport_generic_new_cmd(&cmd->se_cmd);
-	if (cmd->sense_reason) {
-		immed_ret = IMMEDIATE_DATA_NORMAL_OPERATION;
+	if (cmd->sense_reason)
+		return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL(iscsit_process_scsi_cmd);
+
+static int
+iscsit_get_immediate_data(struct iscsi_cmd *cmd, struct iscsi_scsi_req *hdr,
+			  bool dump_payload)
+{
+	int cmdsn_ret = 0, immed_ret = IMMEDIATE_DATA_NORMAL_OPERATION;
+	/*
+	 * Special case for Unsupported SAM WRITE Opcodes and ImmediateData=Yes.
+	 */
+	if (dump_payload == true)
 		goto after_immediate_data;
-	}
 
-	immed_ret = iscsit_handle_immediate_data(cmd, buf, payload_length);
+	immed_ret = iscsit_handle_immediate_data(cmd, hdr,
+					cmd->first_burst_len);
 after_immediate_data:
 	if (immed_ret == IMMEDIATE_DATA_NORMAL_OPERATION) {
 		/*
@@ -1087,26 +1124,19 @@ after_immediate_data:
 		 * DataCRC, check against ExpCmdSN/MaxCmdSN if
 		 * Immediate Bit is not set.
 		 */
-		cmdsn_ret = iscsit_sequence_cmd(conn, cmd, hdr->cmdsn);
-		/*
-		 * Special case for Unsupported SAM WRITE Opcodes
-		 * and ImmediateData=Yes.
-		 */
+		cmdsn_ret = iscsit_sequence_cmd(cmd->conn, cmd, hdr->cmdsn);
+
 		if (cmd->sense_reason) {
-			if (iscsit_dump_data_payload(conn, payload_length, 1) < 0)
+			if (iscsit_dump_data_payload(cmd->conn,
+					cmd->first_burst_len, 1) < 0)
 				return -1;
-		} else if (cmd->unsolicited_data) {
-			iscsit_set_dataout_sequence_values(cmd);
-
-			spin_lock_bh(&cmd->dataout_timeout_lock);
-			iscsit_start_dataout_timer(cmd, cmd->conn);
-			spin_unlock_bh(&cmd->dataout_timeout_lock);
-		}
+		} else if (cmd->unsolicited_data)
+			iscsit_set_unsoliticed_dataout(cmd);
 
 		if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
 			return iscsit_add_reject_from_cmd(
 				ISCSI_REASON_PROTOCOL_ERROR,
-				1, 0, buf, cmd);
+				1, 0, (unsigned char *)hdr, cmd);
 
 	} else if (immed_ret == IMMEDIATE_DATA_ERL1_CRC_FAILURE) {
 		/*
@@ -1121,13 +1151,46 @@ after_immediate_data:
 		 * CmdSN and issue a retry to plug the sequence.
 		 */
 		cmd->i_state = ISTATE_REMOVE;
-		iscsit_add_cmd_to_immediate_queue(cmd, conn, cmd->i_state);
+		iscsit_add_cmd_to_immediate_queue(cmd, cmd->conn, cmd->i_state);
 	} else /* immed_ret == IMMEDIATE_DATA_CANNOT_RECOVER */
 		return -1;
 
 	return 0;
 }
 
+int iscsit_handle_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+			   unsigned char *buf)
+{
+	struct iscsi_scsi_req *hdr = (struct iscsi_scsi_req *)buf;
+	int rc, immed_data;
+	bool dump_payload = false;
+
+	rc = iscsit_setup_scsi_cmd(conn, cmd, buf);
+	if (rc < 0)
+		return rc;
+	/*
+	 * Allocation iovecs needed for struct socket operations for
+	 * traditional iSCSI block I/O.
+	 */
+	if (iscsit_allocate_iovecs(cmd) < 0) {
+		return iscsit_add_reject_from_cmd(
+				ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+				1, 0, buf, cmd);
+	}
+	immed_data = cmd->immediate_data;
+
+	rc = iscsit_process_scsi_cmd(conn, cmd, hdr);
+	if (rc < 0)
+		return rc;
+	else if (rc > 0)
+		dump_payload = true;
+
+	if (!immed_data)
+		return 0;
+
+	return iscsit_get_immediate_data(cmd, hdr, dump_payload);
+}
+
 static u32 iscsit_do_crypto_hash_sg(
 	struct hash_desc *hash,
 	struct iscsi_cmd *cmd,
@@ -1190,20 +1253,16 @@ static void iscsit_do_crypto_hash_buf(
 	crypto_hash_final(hash, data_crc);
 }
 
-static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
+int
+iscsit_check_dataout_hdr(struct iscsi_conn *conn, unsigned char *buf,
+			  struct iscsi_cmd **out_cmd)
 {
-	int iov_ret, ooo_cmdsn = 0, ret;
-	u8 data_crc_failed = 0;
-	u32 checksum, iov_count = 0, padding = 0, rx_got = 0;
-	u32 rx_size = 0, payload_length;
+	struct iscsi_data *hdr = (struct iscsi_data *)buf;
 	struct iscsi_cmd *cmd = NULL;
 	struct se_cmd *se_cmd;
-	struct iscsi_data *hdr;
-	struct kvec *iov;
 	unsigned long flags;
-
-	hdr			= (struct iscsi_data *) buf;
-	payload_length		= ntoh24(hdr->dlength);
+	u32 payload_length = ntoh24(hdr->dlength);
+	int rc;
 
 	if (!payload_length) {
 		pr_err("DataOUT payload is ZERO, protocol error.\n");
@@ -1236,7 +1295,7 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
 
 	pr_debug("Got DataOut ITT: 0x%08x, TTT: 0x%08x,"
 		" DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
-		hdr->itt, hdr->ttt, hdr->datasn, hdr->offset,
+		hdr->itt, hdr->ttt, hdr->datasn, ntohl(hdr->offset),
 		payload_length, conn->cid);
 
 	if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
@@ -1328,12 +1387,26 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
 	 * Preform DataSN, DataSequenceInOrder, DataPDUInOrder, and
 	 * within-command recovery checks before receiving the payload.
 	 */
-	ret = iscsit_check_pre_dataout(cmd, buf);
-	if (ret == DATAOUT_WITHIN_COMMAND_RECOVERY)
+	rc = iscsit_check_pre_dataout(cmd, buf);
+	if (rc == DATAOUT_WITHIN_COMMAND_RECOVERY)
 		return 0;
-	else if (ret == DATAOUT_CANNOT_RECOVER)
+	else if (rc == DATAOUT_CANNOT_RECOVER)
 		return -1;
 
+	*out_cmd = cmd;
+	return 0;
+}
+EXPORT_SYMBOL(iscsit_check_dataout_hdr);
+
+static int
+iscsit_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+		   struct iscsi_data *hdr)
+{
+	struct kvec *iov;
+	u32 checksum, iov_count = 0, padding = 0, rx_got = 0, rx_size = 0;
+	u32 payload_length = ntoh24(hdr->dlength);
+	int iov_ret, data_crc_failed = 0;
+
 	rx_size += payload_length;
 	iov = &cmd->iov_data[0];
 
@@ -1386,17 +1459,27 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
 				payload_length);
 		}
 	}
+
+	return data_crc_failed;
+}
+
+int
+iscsit_check_dataout_payload(struct iscsi_cmd *cmd, struct iscsi_data *hdr,
+			     bool data_crc_failed)
+{
+	struct iscsi_conn *conn = cmd->conn;
+	int rc, ooo_cmdsn;
 	/*
 	 * Increment post receive data and CRC values or perform
 	 * within-command recovery.
 	 */
-	ret = iscsit_check_post_dataout(cmd, buf, data_crc_failed);
-	if ((ret == DATAOUT_NORMAL) || (ret == DATAOUT_WITHIN_COMMAND_RECOVERY))
+	rc = iscsit_check_post_dataout(cmd, (unsigned char *)hdr, data_crc_failed);
+	if ((rc == DATAOUT_NORMAL) || (rc == DATAOUT_WITHIN_COMMAND_RECOVERY))
 		return 0;
-	else if (ret == DATAOUT_SEND_R2T) {
+	else if (rc == DATAOUT_SEND_R2T) {
 		iscsit_set_dataout_sequence_values(cmd);
-		iscsit_build_r2ts_for_cmd(cmd, conn, false);
-	} else if (ret == DATAOUT_SEND_TO_TRANSPORT) {
+		conn->conn_transport->iscsit_get_dataout(conn, cmd, false);
+	} else if (rc == DATAOUT_SEND_TO_TRANSPORT) {
 		/*
 		 * Handle extra special case for out of order
 		 * Unsolicited Data Out.
@@ -1417,15 +1500,37 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
 
 	return 0;
 }
+EXPORT_SYMBOL(iscsit_check_dataout_payload);
 
-static int iscsit_handle_nop_out(
-	struct iscsi_conn *conn,
-	unsigned char *buf)
+static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
+{
+	struct iscsi_cmd *cmd;
+	struct iscsi_data *hdr = (struct iscsi_data *)buf;
+	int rc;
+	bool data_crc_failed = false;
+
+	rc = iscsit_check_dataout_hdr(conn, buf, &cmd);
+	if (rc < 0)
+		return rc;
+	else if (!cmd)
+		return 0;
+
+	rc = iscsit_get_dataout(conn, cmd, hdr);
+	if (rc < 0)
+		return rc;
+	else if (rc > 0)
+		data_crc_failed = true;
+
+	return iscsit_check_dataout_payload(cmd, hdr, data_crc_failed);
+}
+
+int iscsit_handle_nop_out(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+			unsigned char *buf)
 {
 	unsigned char *ping_data = NULL;
 	int cmdsn_ret, niov = 0, ret = 0, rx_got, rx_size;
 	u32 checksum, data_crc, padding = 0, payload_length;
-	struct iscsi_cmd *cmd = NULL;
+	struct iscsi_cmd *cmd_p = NULL;
 	struct kvec *iov = NULL;
 	struct iscsi_nopout *hdr;
 
@@ -1448,7 +1553,7 @@ static int iscsit_handle_nop_out(
 					buf, conn);
 	}
 
-	pr_debug("Got NOPOUT Ping %s ITT: 0x%08x, TTT: 0x%09x,"
+	pr_debug("Got NOPOUT Ping %s ITT: 0x%08x, TTT: 0x%08x,"
 		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, Length: %u\n",
 		hdr->itt == RESERVED_ITT ? "Response" : "Request",
 		hdr->itt, hdr->ttt, hdr->cmdsn, hdr->exp_statsn,
@@ -1461,7 +1566,6 @@ static int iscsit_handle_nop_out(
 	 * can contain ping data.
 	 */
 	if (hdr->ttt == cpu_to_be32(0xFFFFFFFF)) {
-		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
 		if (!cmd)
 			return iscsit_add_reject(
 					ISCSI_REASON_BOOKMARK_NO_RESOURCES,
@@ -1596,14 +1700,14 @@ static int iscsit_handle_nop_out(
 		/*
 		 * This was a response to a unsolicited NOPIN ping.
 		 */
-		cmd = iscsit_find_cmd_from_ttt(conn, be32_to_cpu(hdr->ttt));
-		if (!cmd)
+		cmd_p = iscsit_find_cmd_from_ttt(conn, be32_to_cpu(hdr->ttt));
+		if (!cmd_p)
 			return -1;
 
 		iscsit_stop_nopin_response_timer(conn);
 
-		cmd->i_state = ISTATE_REMOVE;
-		iscsit_add_cmd_to_immediate_queue(cmd, conn, cmd->i_state);
+		cmd_p->i_state = ISTATE_REMOVE;
+		iscsit_add_cmd_to_immediate_queue(cmd_p, conn, cmd_p->i_state);
 		iscsit_start_nopin_timer(conn);
 	} else {
 		/*
@@ -1627,12 +1731,12 @@ ping_out:
 	kfree(ping_data);
 	return ret;
 }
+EXPORT_SYMBOL(iscsit_handle_nop_out);
 
-static int iscsit_handle_task_mgt_cmd(
-	struct iscsi_conn *conn,
-	unsigned char *buf)
+int
+iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+			   unsigned char *buf)
 {
-	struct iscsi_cmd *cmd;
 	struct se_tmr_req *se_tmr;
 	struct iscsi_tmr_req *tmr_req;
 	struct iscsi_tm *hdr;
@@ -1661,18 +1765,13 @@ static int iscsit_handle_task_mgt_cmd(
 		pr_err("Task Management Request TASK_REASSIGN not"
 			" issued as immediate command, bad iSCSI Initiator"
 				"implementation\n");
-		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
-					buf, conn);
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
+					1, 1, buf, cmd);
 	}
 	if ((function != ISCSI_TM_FUNC_ABORT_TASK) &&
 	    be32_to_cpu(hdr->refcmdsn) != ISCSI_RESERVED_TAG)
 		hdr->refcmdsn = cpu_to_be32(ISCSI_RESERVED_TAG);
 
-	cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
-	if (!cmd)
-		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
-					 1, buf, conn);
-
 	cmd->data_direction = DMA_NONE;
 
 	cmd->tmr_req = kzalloc(sizeof(struct iscsi_tmr_req), GFP_KERNEL);
@@ -1843,6 +1942,7 @@ attach:
 	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
 	return 0;
 }
+EXPORT_SYMBOL(iscsit_handle_task_mgt_cmd);
 
 /* #warning FIXME: Support Text Command parameters besides SendTargets */
 static int iscsit_handle_text_cmd(
@@ -2105,13 +2205,12 @@ int iscsit_logout_removeconnforrecovery(struct iscsi_cmd *cmd, struct iscsi_conn
 	return 0;
 }
 
-static int iscsit_handle_logout_cmd(
-	struct iscsi_conn *conn,
-	unsigned char *buf)
+int
+iscsit_handle_logout_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+			unsigned char *buf)
 {
 	int cmdsn_ret, logout_remove = 0;
 	u8 reason_code = 0;
-	struct iscsi_cmd *cmd;
 	struct iscsi_logout *hdr;
 	struct iscsi_tiqn *tiqn = iscsit_snmp_get_tiqn(conn);
 
@@ -2135,14 +2234,10 @@ static int iscsit_handle_logout_cmd(
 	if (conn->conn_state != TARG_CONN_STATE_LOGGED_IN) {
 		pr_err("Received logout request on connection that"
 			" is not in logged in state, ignoring request.\n");
+		iscsit_release_cmd(cmd);
 		return 0;
 	}
 
-	cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
-	if (!cmd)
-		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES, 1,
-					buf, conn);
-
 	cmd->iscsi_opcode       = ISCSI_OP_LOGOUT;
 	cmd->i_state            = ISTATE_SEND_LOGOUTRSP;
 	cmd->immediate_cmd      = ((hdr->opcode & ISCSI_OP_IMMEDIATE) ? 1 : 0);
@@ -2192,6 +2287,7 @@ static int iscsit_handle_logout_cmd(
 
 	return logout_remove;
 }
+EXPORT_SYMBOL(iscsit_handle_logout_cmd);
 
 static int iscsit_handle_snack(
 	struct iscsi_conn *conn,
@@ -2259,7 +2355,7 @@ static void iscsit_rx_thread_wait_for_tcp(struct iscsi_conn *conn)
 
 static int iscsit_handle_immediate_data(
 	struct iscsi_cmd *cmd,
-	unsigned char *buf,
+	struct iscsi_scsi_req *hdr,
 	u32 length)
 {
 	int iov_ret, rx_got = 0, rx_size = 0;
@@ -2315,12 +2411,12 @@ static int iscsit_handle_immediate_data(
 					" in ERL=0.\n");
 				iscsit_add_reject_from_cmd(
 						ISCSI_REASON_DATA_DIGEST_ERROR,
-						1, 0, buf, cmd);
+						1, 0, (unsigned char *)hdr, cmd);
 				return IMMEDIATE_DATA_CANNOT_RECOVER;
 			} else {
 				iscsit_add_reject_from_cmd(
 						ISCSI_REASON_DATA_DIGEST_ERROR,
-						0, 0, buf, cmd);
+						0, 0, (unsigned char *)hdr, cmd);
 				return IMMEDIATE_DATA_ERL1_CRC_FAILURE;
 			}
 		} else {
@@ -2955,8 +3051,8 @@ static int iscsit_send_r2t(
  *		connection recovery.
  */
 int iscsit_build_r2ts_for_cmd(
-	struct iscsi_cmd *cmd,
 	struct iscsi_conn *conn,
+	struct iscsi_cmd *cmd,
 	bool recovery)
 {
 	int first_r2t = 1;
@@ -3758,6 +3854,83 @@ out:
 	return 0;
 }
 
+static int iscsi_target_rx_opcode(struct iscsi_conn *conn, unsigned char *buf)
+{
+	struct iscsi_hdr *hdr = (struct iscsi_hdr *)buf;
+	struct iscsi_cmd *cmd;
+	int ret = 0;
+
+	switch (hdr->opcode & ISCSI_OPCODE_MASK) {
+	case ISCSI_OP_SCSI_CMD:
+		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+		if (!cmd)
+			return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+						1, buf, conn);
+
+		ret = iscsit_handle_scsi_cmd(conn, cmd, buf);
+		break;
+	case ISCSI_OP_SCSI_DATA_OUT:
+		ret = iscsit_handle_data_out(conn, buf);
+		break;
+	case ISCSI_OP_NOOP_OUT:
+		cmd = NULL;
+		if (hdr->ttt == cpu_to_be32(0xFFFFFFFF)) {
+			cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+			if (!cmd)
+				return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+						1, buf, conn);
+		}
+		ret = iscsit_handle_nop_out(conn, cmd, buf);
+		break;
+	case ISCSI_OP_SCSI_TMFUNC:
+		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+		if (!cmd)
+			return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+						1, buf, conn);
+
+		ret = iscsit_handle_task_mgt_cmd(conn, cmd, buf);
+		break;
+	case ISCSI_OP_TEXT:
+		ret = iscsit_handle_text_cmd(conn, buf);
+		break;
+	case ISCSI_OP_LOGOUT:
+		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+		if (!cmd)
+			return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+						1, buf, conn);
+
+		ret = iscsit_handle_logout_cmd(conn, cmd, buf);
+		if (ret > 0)
+			wait_for_completion_timeout(&conn->conn_logout_comp,
+					SECONDS_FOR_LOGOUT_COMP * HZ);
+		break;
+	case ISCSI_OP_SNACK:
+		ret = iscsit_handle_snack(conn, buf);
+		break;
+	default:
+		pr_err("Got unknown iSCSI OpCode: 0x%02x\n", hdr->opcode);
+		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+			pr_err("Cannot recover from unknown"
+			" opcode while ERL=0, closing iSCSI connection.\n");
+			return -1;
+		}
+		if (!conn->conn_ops->OFMarker) {
+			pr_err("Unable to recover from unknown"
+			" opcode while OFMarker=No, closing iSCSI"
+				" connection.\n");
+			return -1;
+		}
+		if (iscsit_recover_from_unknown_opcode(conn) < 0) {
+			pr_err("Unable to recover from unknown"
+				" opcode, closing iSCSI connection.\n");
+			return -1;
+		}
+		break;
+	}
+
+	return ret;
+}
+
 int iscsi_target_rx_thread(void *arg)
 {
 	int ret;
@@ -3777,6 +3950,18 @@ restart:
 	if (!conn)
 		goto out;
 
+	if (conn->conn_transport->transport_type == ISCSI_INFINIBAND) {
+		struct completion comp;
+		int rc;
+
+		init_completion(&comp);
+		rc = wait_for_completion_interruptible(&comp);
+		if (rc < 0)
+			goto transport_err;
+
+		goto out;
+	}
+
 	while (!kthread_should_stop()) {
 		/*
 		 * Ensure that both TX and RX per connection kthreads
@@ -3848,62 +4033,9 @@ restart:
 			goto transport_err;
 		}
 
-		switch (opcode) {
-		case ISCSI_OP_SCSI_CMD:
-			if (iscsit_handle_scsi_cmd(conn, buffer) < 0)
-				goto transport_err;
-			break;
-		case ISCSI_OP_SCSI_DATA_OUT:
-			if (iscsit_handle_data_out(conn, buffer) < 0)
-				goto transport_err;
-			break;
-		case ISCSI_OP_NOOP_OUT:
-			if (iscsit_handle_nop_out(conn, buffer) < 0)
-				goto transport_err;
-			break;
-		case ISCSI_OP_SCSI_TMFUNC:
-			if (iscsit_handle_task_mgt_cmd(conn, buffer) < 0)
-				goto transport_err;
-			break;
-		case ISCSI_OP_TEXT:
-			if (iscsit_handle_text_cmd(conn, buffer) < 0)
-				goto transport_err;
-			break;
-		case ISCSI_OP_LOGOUT:
-			ret = iscsit_handle_logout_cmd(conn, buffer);
-			if (ret > 0) {
-				wait_for_completion_timeout(&conn->conn_logout_comp,
-						SECONDS_FOR_LOGOUT_COMP * HZ);
-				goto transport_err;
-			} else if (ret < 0)
-				goto transport_err;
-			break;
-		case ISCSI_OP_SNACK:
-			if (iscsit_handle_snack(conn, buffer) < 0)
-				goto transport_err;
-			break;
-		default:
-			pr_err("Got unknown iSCSI OpCode: 0x%02x\n",
-					opcode);
-			if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-				pr_err("Cannot recover from unknown"
-				" opcode while ERL=0, closing iSCSI connection"
-				".\n");
-				goto transport_err;
-			}
-			if (!conn->conn_ops->OFMarker) {
-				pr_err("Unable to recover from unknown"
-				" opcode while OFMarker=No, closing iSCSI"
-					" connection.\n");
-				goto transport_err;
-			}
-			if (iscsit_recover_from_unknown_opcode(conn) < 0) {
-				pr_err("Unable to recover from unknown"
-					" opcode, closing iSCSI connection.\n");
-				goto transport_err;
-			}
-			break;
-		}
+		ret = iscsi_target_rx_opcode(conn, buffer);
+		if (ret < 0)
+			goto transport_err;
 	}
 
 transport_err:
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
index b1a1e63..a0050b2 100644
--- a/drivers/target/iscsi/iscsi_target.h
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -16,11 +16,12 @@ extern int iscsit_reset_np_thread(struct iscsi_np *, struct iscsi_tpg_np *,
 				struct iscsi_portal_group *);
 extern int iscsit_del_np(struct iscsi_np *);
 extern int iscsit_add_reject_from_cmd(u8, int, int, unsigned char *, struct iscsi_cmd *);
+extern void iscsit_set_unsoliticed_dataout(struct iscsi_cmd *);
 extern int iscsit_logout_closesession(struct iscsi_cmd *, struct iscsi_conn *);
 extern int iscsit_logout_closeconnection(struct iscsi_cmd *, struct iscsi_conn *);
 extern int iscsit_logout_removeconnforrecovery(struct iscsi_cmd *, struct iscsi_conn *);
 extern int iscsit_send_async_msg(struct iscsi_conn *, u16, u8, u8);
-extern int iscsit_build_r2ts_for_cmd(struct iscsi_cmd *, struct iscsi_conn *, bool recovery);
+extern int iscsit_build_r2ts_for_cmd(struct iscsi_conn *, struct iscsi_cmd *, bool recovery);
 extern void iscsit_thread_get_cpumask(struct iscsi_conn *);
 extern int iscsi_target_tx_thread(void *);
 extern int iscsi_target_rx_thread(void *);
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index c78b824..ce3d321 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1543,9 +1543,10 @@ static int lio_queue_data_in(struct se_cmd *se_cmd)
 static int lio_write_pending(struct se_cmd *se_cmd)
 {
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
+	struct iscsi_conn *conn = cmd->conn;
 
 	if (!cmd->immediate_data && !cmd->unsolicited_data)
-		return iscsit_build_r2ts_for_cmd(cmd, cmd->conn, false);
+		return conn->conn_transport->iscsit_get_dataout(conn, cmd, false);
 
 	return 0;
 }
@@ -1696,6 +1697,11 @@ static void lio_set_default_node_attributes(struct se_node_acl *se_acl)
 	iscsit_set_default_node_attribues(acl);
 }
 
+static int lio_check_stop_free(struct se_cmd *se_cmd)
+{
+	return target_put_sess_cmd(se_cmd->se_sess, se_cmd);
+}
+
 static void lio_release_cmd(struct se_cmd *se_cmd)
 {
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
@@ -1741,6 +1747,7 @@ int iscsi_target_register_configfs(void)
 	fabric->tf_ops.tpg_alloc_fabric_acl = &lio_tpg_alloc_fabric_acl;
 	fabric->tf_ops.tpg_release_fabric_acl = &lio_tpg_release_fabric_acl;
 	fabric->tf_ops.tpg_get_inst_index = &lio_tpg_get_inst_index;
+	fabric->tf_ops.check_stop_free = &lio_check_stop_free,
 	fabric->tf_ops.release_cmd = &lio_release_cmd;
 	fabric->tf_ops.shutdown_session = &lio_tpg_shutdown_session;
 	fabric->tf_ops.close_session = &lio_tpg_close_session;
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 0b52a23..7816af6 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -22,6 +22,7 @@
 #include <scsi/iscsi_proto.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
+#include <target/iscsi/iscsi_transport.h>
 
 #include "iscsi_target_core.h"
 #include "iscsi_target_seq_pdu_list.h"
@@ -53,6 +54,9 @@ int iscsit_dump_data_payload(
 	u32 length, padding, offset = 0, size;
 	struct kvec iov;
 
+	if (conn->sess->sess_ops->RDMAExtensions)
+		return 0;
+
 	length = (buf_len > OFFLOAD_BUF_SIZE) ? OFFLOAD_BUF_SIZE : buf_len;
 
 	buf = kzalloc(length, GFP_ATOMIC);
@@ -919,6 +923,7 @@ int iscsit_execute_ooo_cmdsns(struct iscsi_session *sess)
 int iscsit_execute_cmd(struct iscsi_cmd *cmd, int ooo)
 {
 	struct se_cmd *se_cmd = &cmd->se_cmd;
+	struct iscsi_conn *conn = cmd->conn;
 	int lr = 0;
 
 	spin_lock_bh(&cmd->istate_lock);
@@ -981,7 +986,7 @@ int iscsit_execute_cmd(struct iscsi_cmd *cmd, int ooo)
 					return 0;
 
 				iscsit_set_dataout_sequence_values(cmd);
-				iscsit_build_r2ts_for_cmd(cmd, cmd->conn, false);
+				conn->conn_transport->iscsit_get_dataout(conn, cmd, false);
 			}
 			return 0;
 		}
@@ -999,10 +1004,7 @@ int iscsit_execute_cmd(struct iscsi_cmd *cmd, int ooo)
 			if (transport_check_aborted_status(se_cmd, 1) != 0)
 				return 0;
 
-			iscsit_set_dataout_sequence_values(cmd);
-			spin_lock_bh(&cmd->dataout_timeout_lock);
-			iscsit_start_dataout_timer(cmd, cmd->conn);
-			spin_unlock_bh(&cmd->dataout_timeout_lock);
+			iscsit_set_unsoliticed_dataout(cmd);
 		}
 		return transport_handle_cdb_direct(&cmd->se_cmd);
 
@@ -1290,3 +1292,4 @@ void iscsit_stop_dataout_timer(struct iscsi_cmd *cmd)
 			cmd->init_task_tag);
 	spin_unlock_bh(&cmd->dataout_timeout_lock);
 }
+EXPORT_SYMBOL(iscsit_stop_dataout_timer);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index e6a8269..bb5d5c5 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1068,8 +1068,7 @@ int iscsit_get_login_rx(struct iscsi_conn *conn, struct iscsi_login *login)
 	if (login->first_request) {
 		login_req = (struct iscsi_login_req *)login->req;
 		login->leading_connection = (!login_req->tsih) ? 1 : 0;
-		login->current_stage	=
-			(login_req->flags & ISCSI_FLAG_LOGIN_CURRENT_STAGE_MASK) >> 2;
+		login->current_stage	= ISCSI_LOGIN_CURRENT_STAGE(login_req->flags);
 		login->version_min	= login_req->min_version;
 		login->version_max	= login_req->max_version;
 		memcpy(login->isid, login_req->isid, 6);
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 879a0cb..7ad9120 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -691,21 +691,6 @@ int iscsi_target_locate_portal(
 	login_req = (struct iscsi_login_req *) login->req;
 	payload_length = ntoh24(login_req->dlength);
 
-	login->first_request	= 1;
-	login->leading_connection = (!login_req->tsih) ? 1 : 0;
-	login->current_stage	= ISCSI_LOGIN_CURRENT_STAGE(login_req->flags);
-	login->version_min	= login_req->min_version;
-	login->version_max	= login_req->max_version;
-	memcpy(login->isid, login_req->isid, 6);
-	login->cmd_sn		= be32_to_cpu(login_req->cmdsn);
-	login->init_task_tag	= login_req->itt;
-	login->initial_exp_statsn = be32_to_cpu(login_req->exp_statsn);
-	login->cid		= be16_to_cpu(login_req->cid);
-	login->tsih		= be16_to_cpu(login_req->tsih);
-
-	if (iscsi_target_get_initial_payload(conn, login) < 0)
-		return -1;
-
 	tmpbuf = kzalloc(payload_length + 1, GFP_KERNEL);
 	if (!tmpbuf) {
 		pr_err("Unable to allocate memory for tmpbuf.\n");
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index 9d4417a..16ca0ef 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -23,6 +23,7 @@
 #include <scsi/iscsi_proto.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
+#include <target/iscsi/iscsi_transport.h>
 
 #include "iscsi_target_core.h"
 #include "iscsi_target_seq_pdu_list.h"
@@ -301,7 +302,7 @@ static int iscsit_task_reassign_complete_write(
 	/*
 	 * iscsit_build_r2ts_for_cmd() can handle the rest from here.
 	 */
-	return iscsit_build_r2ts_for_cmd(cmd, conn, true);
+	return conn->conn_transport->iscsit_get_dataout(conn, cmd, true);
 }
 
 static int iscsit_task_reassign_complete_read(
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 0b73f90..2cc6c9a 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -317,6 +317,7 @@ int iscsit_sequence_cmd(
 
 	return ret;
 }
+EXPORT_SYMBOL(iscsit_sequence_cmd);
 
 int iscsit_check_unsolicited_dataout(struct iscsi_cmd *cmd, unsigned char *buf)
 {
-- 
1.7.2.5
