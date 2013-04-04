From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: [RFC-v3 7/9] iscsi-target: Refactor TX queue logic + export response PDU creation
Date: Thu,  4 Apr 2013 07:24:14 +0000
Message-ID: <1365060256-21506-8-git-send-email-nab@linux-iscsi.org>
References: <1365060256-21506-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365060256-21506-1-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alexander Nezhinsky <alexandern-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>

This patch refactors TX immediate + response queue handling to use
the new iscsit_transport API callers, and exports the necessary
traditional iscsi PDU response creation functions for iser-target
to utilize.

This includes:

- Add iscsit_build_datain_pdu() for DATAIN PDU init + convert
  iscsit_build_datain_pdu()
- Add iscsit_build_logout_rsp() for LOGOUT_RSP PDU init + convert
  iscsit_send_logout()
- Add iscsit_build_nopin_rsp() for NOPIN_RSP PDU init + convert
  iscsit_send_nopin()
- Add iscsit_build_rsp_pdu() for SCSI_RSP PDU init + convert
  iscsit_send_response()
- Add iscsit_build_task_mgt_rsp for TM_RSP PDU init + convert
  iscsit_send_task_mgt_rsp()
- Refactor immediate queue state switch into iscsit_immediate_queue()
- Convert handle_immediate_queue() to use iscsit_transport caller
- Refactor response queue state switch into iscsit_response_queue()
- Convert handle_response_queue to use iscsit_transport caller
- Export iscsit_logout_post_handler(), iscsit_increment_maxcmdsn()
  and iscsit_tmr_post_handler() for external transport module usage

v3 changes:
- Add iscsit_build_reject for REJECT PDU init + convert
  iscsit_send_reject()

v2 changes:

- Add iscsit_queue_rsp() for iscsit_transport->iscsit_queue_data_in()
  and iscsit_transport->iscsit_queue_status()
- Update lio_queue_data_in() to use ->iscsit_queue_data_in()
- Update lio_queue_status() to use ->iscsit_queue_status()
- Use mutex_trylock() in iscsit_increment_maxcmdsn()

Signed-off-by: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
---
 drivers/target/iscsi/iscsi_target.c          |  661 ++++++++++++++------------
 drivers/target/iscsi/iscsi_target_configfs.c |    7 +-
 drivers/target/iscsi/iscsi_target_device.c   |    7 +-
 drivers/target/iscsi/iscsi_target_tmr.c      |    1 +
 4 files changed, 374 insertions(+), 302 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 19d4e08..3948aa1 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -70,8 +70,7 @@ struct kmem_cache *lio_ooo_cache;
 struct kmem_cache *lio_r2t_cache;
 
 static int iscsit_handle_immediate_data(struct iscsi_cmd *,
-			unsigned char *buf, u32);
-static int iscsit_logout_post_handler(struct iscsi_cmd *, struct iscsi_conn *);
+			struct iscsi_scsi_req *, u32);
 
 struct iscsi_tiqn *iscsit_get_tiqn_for_login(unsigned char *buf)
 {
@@ -482,6 +481,15 @@ int iscsit_del_np(struct iscsi_np *np)
 	return 0;
 }
 
+static int iscsit_immediate_queue(struct iscsi_conn *, struct iscsi_cmd *, int);
+static int iscsit_response_queue(struct iscsi_conn *, struct iscsi_cmd *, int);
+
+static int iscsit_queue_rsp(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
+{
+	iscsit_add_cmd_to_response_queue(cmd, cmd->conn, cmd->i_state);
+	return 0;
+}
+
 static struct iscsit_transport iscsi_target_transport = {
 	.name			= "iSCSI/TCP",
 	.transport_type		= ISCSI_TCP,
@@ -493,6 +501,10 @@ static struct iscsit_transport iscsi_target_transport = {
 	.iscsit_get_login_rx	= iscsit_get_login_rx,
 	.iscsit_put_login_tx	= iscsit_put_login_tx,
 	.iscsit_get_dataout	= iscsit_build_r2ts_for_cmd,
+	.iscsit_immediate_queue	= iscsit_immediate_queue,
+	.iscsit_response_queue	= iscsit_response_queue,
+	.iscsit_queue_data_in	= iscsit_queue_rsp,
+	.iscsit_queue_status	= iscsit_queue_rsp,
 };
 
 static int __init iscsi_target_init_module(void)
@@ -651,14 +663,6 @@ static int iscsit_add_reject(
 	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
 
 	ret = wait_for_completion_interruptible(&cmd->reject_comp);
-	/*
-	 * Perform the kref_put now if se_cmd has been setup by
-	 * iscsit_setup_scsi_cmd()
-	 */
-	if (cmd->se_cmd.se_tfo != NULL) {
-		pr_debug("iscsi reject: calling target_put_sess_cmd >>>>>>\n");
-		target_put_sess_cmd(conn->sess->se_sess, &cmd->se_cmd);
-	}
 	if (ret != 0)
 		return -1;
 
@@ -2536,18 +2540,60 @@ static void iscsit_tx_thread_wait_for_tcp(struct iscsi_conn *conn)
 	}
 }
 
-static int iscsit_send_data_in(
-	struct iscsi_cmd *cmd,
-	struct iscsi_conn *conn)
+static void
+iscsit_build_datain_pdu(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
+			struct iscsi_datain *datain, struct iscsi_data_rsp *hdr,
+			bool set_statsn)
 {
-	int iov_ret = 0, set_statsn = 0;
-	u32 iov_count = 0, tx_size = 0;
+	hdr->opcode		= ISCSI_OP_SCSI_DATA_IN;
+	hdr->flags		= datain->flags;
+	if (hdr->flags & ISCSI_FLAG_DATA_STATUS) {
+		if (cmd->se_cmd.se_cmd_flags & SCF_OVERFLOW_BIT) {
+			hdr->flags |= ISCSI_FLAG_DATA_OVERFLOW;
+			hdr->residual_count = cpu_to_be32(cmd->se_cmd.residual_count);
+		} else if (cmd->se_cmd.se_cmd_flags & SCF_UNDERFLOW_BIT) {
+			hdr->flags |= ISCSI_FLAG_DATA_UNDERFLOW;
+			hdr->residual_count = cpu_to_be32(cmd->se_cmd.residual_count);
+		}
+	}
+	hton24(hdr->dlength, datain->length);
+	if (hdr->flags & ISCSI_FLAG_DATA_ACK)
+		int_to_scsilun(cmd->se_cmd.orig_fe_lun,
+				(struct scsi_lun *)&hdr->lun);
+	else
+		put_unaligned_le64(0xFFFFFFFFFFFFFFFFULL, &hdr->lun);
+
+	hdr->itt		= cmd->init_task_tag;
+
+	if (hdr->flags & ISCSI_FLAG_DATA_ACK)
+		hdr->ttt		= cpu_to_be32(cmd->targ_xfer_tag);
+	else
+		hdr->ttt		= cpu_to_be32(0xFFFFFFFF);
+	if (set_statsn)
+		hdr->statsn		= cpu_to_be32(cmd->stat_sn);
+	else
+		hdr->statsn		= cpu_to_be32(0xFFFFFFFF);
+
+	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+	hdr->datasn		= cpu_to_be32(datain->data_sn);
+	hdr->offset		= cpu_to_be32(datain->offset);
+
+	pr_debug("Built DataIN ITT: 0x%08x, StatSN: 0x%08x,"
+		" DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
+		cmd->init_task_tag, ntohl(hdr->statsn), ntohl(hdr->datasn),
+		ntohl(hdr->offset), datain->length, conn->cid);
+}
+
+static int iscsit_send_datain(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
+{
+	struct iscsi_data_rsp *hdr = (struct iscsi_data_rsp *)&cmd->pdu[0];
 	struct iscsi_datain datain;
 	struct iscsi_datain_req *dr;
-	struct iscsi_data_rsp *hdr;
 	struct kvec *iov;
-	int eodr = 0;
-	int ret;
+	u32 iov_count = 0, tx_size = 0;
+	int eodr = 0, ret, iov_ret;
+	bool set_statsn = false;
 
 	memset(&datain, 0, sizeof(struct iscsi_datain));
 	dr = iscsit_get_datain_values(cmd, &datain);
@@ -2556,7 +2602,6 @@ static int iscsit_send_data_in(
 				cmd->init_task_tag);
 		return -1;
 	}
-
 	/*
 	 * Be paranoid and double check the logic for now.
 	 */
@@ -2564,7 +2609,7 @@ static int iscsit_send_data_in(
 		pr_err("Command ITT: 0x%08x, datain.offset: %u and"
 			" datain.length: %u exceeds cmd->data_length: %u\n",
 			cmd->init_task_tag, datain.offset, datain.length,
-				cmd->se_cmd.data_length);
+			cmd->se_cmd.data_length);
 		return -1;
 	}
 
@@ -2588,47 +2633,13 @@ static int iscsit_send_data_in(
 		    (dr->dr_complete == DATAIN_COMPLETE_CONNECTION_RECOVERY)) {
 			iscsit_increment_maxcmdsn(cmd, conn->sess);
 			cmd->stat_sn = conn->stat_sn++;
-			set_statsn = 1;
+			set_statsn = true;
 		} else if (dr->dr_complete ==
-				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY)
-			set_statsn = 1;
+			   DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY)
+			set_statsn = true;
 	}
 
-	hdr	= (struct iscsi_data_rsp *) cmd->pdu;
-	memset(hdr, 0, ISCSI_HDR_LEN);
-	hdr->opcode		= ISCSI_OP_SCSI_DATA_IN;
-	hdr->flags		= datain.flags;
-	if (hdr->flags & ISCSI_FLAG_DATA_STATUS) {
-		if (cmd->se_cmd.se_cmd_flags & SCF_OVERFLOW_BIT) {
-			hdr->flags |= ISCSI_FLAG_DATA_OVERFLOW;
-			hdr->residual_count = cpu_to_be32(cmd->se_cmd.residual_count);
-		} else if (cmd->se_cmd.se_cmd_flags & SCF_UNDERFLOW_BIT) {
-			hdr->flags |= ISCSI_FLAG_DATA_UNDERFLOW;
-			hdr->residual_count = cpu_to_be32(cmd->se_cmd.residual_count);
-		}
-	}
-	hton24(hdr->dlength, datain.length);
-	if (hdr->flags & ISCSI_FLAG_DATA_ACK)
-		int_to_scsilun(cmd->se_cmd.orig_fe_lun,
-				(struct scsi_lun *)&hdr->lun);
-	else
-		put_unaligned_le64(0xFFFFFFFFFFFFFFFFULL, &hdr->lun);
-
-	hdr->itt		= cmd->init_task_tag;
-
-	if (hdr->flags & ISCSI_FLAG_DATA_ACK)
-		hdr->ttt		= cpu_to_be32(cmd->targ_xfer_tag);
-	else
-		hdr->ttt		= cpu_to_be32(0xFFFFFFFF);
-	if (set_statsn)
-		hdr->statsn		= cpu_to_be32(cmd->stat_sn);
-	else
-		hdr->statsn		= cpu_to_be32(0xFFFFFFFF);
-
-	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
-	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
-	hdr->datasn		= cpu_to_be32(datain.data_sn);
-	hdr->offset		= cpu_to_be32(datain.offset);
+	iscsit_build_datain_pdu(cmd, conn, &datain, hdr, set_statsn);
 
 	iov = &cmd->iov_data[0];
 	iov[iov_count].iov_base	= cmd->pdu;
@@ -2639,7 +2650,7 @@ static int iscsit_send_data_in(
 		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
 
 		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
-				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				(unsigned char *)cmd->pdu, ISCSI_HDR_LEN,
 				0, NULL, (u8 *)header_digest);
 
 		iov[0].iov_len += ISCSI_CRC_LEN;
@@ -2649,7 +2660,8 @@ static int iscsit_send_data_in(
 			" for DataIN PDU 0x%08x\n", *header_digest);
 	}
 
-	iov_ret = iscsit_map_iovec(cmd, &cmd->iov_data[1], datain.offset, datain.length);
+	iov_ret = iscsit_map_iovec(cmd, &cmd->iov_data[1],
+				datain.offset, datain.length);
 	if (iov_ret < 0)
 		return -1;
 
@@ -2680,11 +2692,6 @@ static int iscsit_send_data_in(
 	cmd->iov_data_count = iov_count;
 	cmd->tx_size = tx_size;
 
-	pr_debug("Built DataIN ITT: 0x%08x, StatSN: 0x%08x,"
-		" DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
-		cmd->init_task_tag, ntohl(hdr->statsn), ntohl(hdr->datasn),
-		ntohl(hdr->offset), datain.length, conn->cid);
-
 	/* sendpage is preferred but can't insert markers */
 	if (!conn->conn_ops->IFMarker)
 		ret = iscsit_fe_sendpage_sg(cmd, conn);
@@ -2707,16 +2714,13 @@ static int iscsit_send_data_in(
 	return eodr;
 }
 
-static int iscsit_send_logout_response(
-	struct iscsi_cmd *cmd,
-	struct iscsi_conn *conn)
+int
+iscsit_build_logout_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
+			struct iscsi_logout_rsp *hdr)
 {
-	int niov = 0, tx_size;
 	struct iscsi_conn *logout_conn = NULL;
 	struct iscsi_conn_recovery *cr = NULL;
 	struct iscsi_session *sess = conn->sess;
-	struct kvec *iov;
-	struct iscsi_logout_rsp *hdr;
 	/*
 	 * The actual shutting down of Sessions and/or Connections
 	 * for CLOSESESSION and CLOSECONNECTION Logout Requests
@@ -2785,9 +2789,6 @@ static int iscsit_send_logout_response(
 		return -1;
 	}
 
-	tx_size = ISCSI_HDR_LEN;
-	hdr			= (struct iscsi_logout_rsp *)cmd->pdu;
-	memset(hdr, 0, ISCSI_HDR_LEN);
 	hdr->opcode		= ISCSI_OP_LOGOUT_RSP;
 	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
 	hdr->response		= cmd->logout_response;
@@ -2799,6 +2800,27 @@ static int iscsit_send_logout_response(
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
 
+	pr_debug("Built Logout Response ITT: 0x%08x StatSN:"
+		" 0x%08x Response: 0x%02x CID: %hu on CID: %hu\n",
+		cmd->init_task_tag, cmd->stat_sn, hdr->response,
+		cmd->logout_cid, conn->cid);
+
+	return 0;
+}
+EXPORT_SYMBOL(iscsit_build_logout_rsp);
+
+static int
+iscsit_send_logout(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
+{
+	struct kvec *iov;
+	int niov = 0, tx_size, rc;
+
+	rc = iscsit_build_logout_rsp(cmd, conn,
+			(struct iscsi_logout_rsp *)&cmd->pdu[0]);
+	if (rc < 0)
+		return rc;
+
+	tx_size = ISCSI_HDR_LEN;
 	iov = &cmd->iov_misc[0];
 	iov[niov].iov_base	= cmd->pdu;
 	iov[niov++].iov_len	= ISCSI_HDR_LEN;
@@ -2807,7 +2829,7 @@ static int iscsit_send_logout_response(
 		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
 
 		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
-				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				(unsigned char *)&cmd->pdu[0], ISCSI_HDR_LEN,
 				0, NULL, (u8 *)header_digest);
 
 		iov[0].iov_len += ISCSI_CRC_LEN;
@@ -2818,14 +2840,37 @@ static int iscsit_send_logout_response(
 	cmd->iov_misc_count = niov;
 	cmd->tx_size = tx_size;
 
-	pr_debug("Sending Logout Response ITT: 0x%08x StatSN:"
-		" 0x%08x Response: 0x%02x CID: %hu on CID: %hu\n",
-		cmd->init_task_tag, cmd->stat_sn, hdr->response,
-		cmd->logout_cid, conn->cid);
-
 	return 0;
 }
 
+void
+iscsit_build_nopin_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
+		       struct iscsi_nopin *hdr, bool nopout_response)
+{
+	hdr->opcode		= ISCSI_OP_NOOP_IN;
+	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
+        hton24(hdr->dlength, cmd->buf_ptr_size);
+	if (nopout_response)
+		put_unaligned_le64(0xFFFFFFFFFFFFFFFFULL, &hdr->lun);
+	hdr->itt		= cmd->init_task_tag;
+	hdr->ttt		= cpu_to_be32(cmd->targ_xfer_tag);
+	cmd->stat_sn		= (nopout_response) ? conn->stat_sn++ :
+				  conn->stat_sn;
+	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
+
+	if (nopout_response)
+		iscsit_increment_maxcmdsn(cmd, conn->sess);
+
+	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+
+	pr_debug("Built NOPIN %s Response ITT: 0x%08x, TTT: 0x%08x,"
+		" StatSN: 0x%08x, Length %u\n", (nopout_response) ?
+		"Solicitied" : "Unsolicitied", cmd->init_task_tag,
+		cmd->targ_xfer_tag, cmd->stat_sn, cmd->buf_ptr_size);
+}
+EXPORT_SYMBOL(iscsit_build_nopin_rsp);
+
 /*
  *	Unsolicited NOPIN, either requesting a response or not.
  */
@@ -2834,20 +2879,10 @@ static int iscsit_send_unsolicited_nopin(
 	struct iscsi_conn *conn,
 	int want_response)
 {
-	int tx_size = ISCSI_HDR_LEN;
-	struct iscsi_nopin *hdr;
-	int ret;
+	struct iscsi_nopin *hdr = (struct iscsi_nopin *)&cmd->pdu[0];
+	int tx_size = ISCSI_HDR_LEN, ret;
 
-	hdr			= (struct iscsi_nopin *) cmd->pdu;
-	memset(hdr, 0, ISCSI_HDR_LEN);
-	hdr->opcode		= ISCSI_OP_NOOP_IN;
-	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
-	hdr->itt		= cmd->init_task_tag;
-	hdr->ttt		= cpu_to_be32(cmd->targ_xfer_tag);
-	cmd->stat_sn		= conn->stat_sn;
-	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
-	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
-	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+	iscsit_build_nopin_rsp(cmd, conn, hdr, false);
 
 	if (conn->conn_ops->HeaderDigest) {
 		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
@@ -2883,31 +2918,17 @@ static int iscsit_send_unsolicited_nopin(
 	return 0;
 }
 
-static int iscsit_send_nopin_response(
-	struct iscsi_cmd *cmd,
-	struct iscsi_conn *conn)
+static int
+iscsit_send_nopin(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
-	int niov = 0, tx_size;
-	u32 padding = 0;
+	struct iscsi_nopin *hdr = (struct iscsi_nopin *)&cmd->pdu[0];
 	struct kvec *iov;
-	struct iscsi_nopin *hdr;
-
-	tx_size = ISCSI_HDR_LEN;
-	hdr			= (struct iscsi_nopin *) cmd->pdu;
-	memset(hdr, 0, ISCSI_HDR_LEN);
-	hdr->opcode		= ISCSI_OP_NOOP_IN;
-	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
-	hton24(hdr->dlength, cmd->buf_ptr_size);
-	put_unaligned_le64(0xFFFFFFFFFFFFFFFFULL, &hdr->lun);
-	hdr->itt		= cmd->init_task_tag;
-	hdr->ttt		= cpu_to_be32(cmd->targ_xfer_tag);
-	cmd->stat_sn		= conn->stat_sn++;
-	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
+	u32 padding = 0;
+	int niov = 0, tx_size;
 
-	iscsit_increment_maxcmdsn(cmd, conn->sess);
-	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
-	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+	iscsit_build_nopin_rsp(cmd, conn, hdr, true);
 
+	tx_size = ISCSI_HDR_LEN;
 	iov = &cmd->iov_misc[0];
 	iov[niov].iov_base	= cmd->pdu;
 	iov[niov++].iov_len	= ISCSI_HDR_LEN;
@@ -2963,10 +2984,6 @@ static int iscsit_send_nopin_response(
 	cmd->iov_misc_count = niov;
 	cmd->tx_size = tx_size;
 
-	pr_debug("Sending NOPIN Response ITT: 0x%08x, TTT:"
-		" 0x%08x, StatSN: 0x%08x, Length %u\n", cmd->init_task_tag,
-		cmd->targ_xfer_tag, cmd->stat_sn, cmd->buf_ptr_size);
-
 	return 0;
 }
 
@@ -3127,24 +3144,16 @@ int iscsit_build_r2ts_for_cmd(
 	return 0;
 }
 
-static int iscsit_send_status(
-	struct iscsi_cmd *cmd,
-	struct iscsi_conn *conn)
+void iscsit_build_rsp_pdu(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
+			bool inc_stat_sn, struct iscsi_scsi_rsp *hdr)
 {
-	u8 iov_count = 0, recovery;
-	u32 padding = 0, tx_size = 0;
-	struct iscsi_scsi_rsp *hdr;
-	struct kvec *iov;
-
-	recovery = (cmd->i_state != ISTATE_SEND_STATUS);
-	if (!recovery)
+	if (inc_stat_sn)
 		cmd->stat_sn = conn->stat_sn++;
 
 	spin_lock_bh(&conn->sess->session_stats_lock);
 	conn->sess->rsp_pdus++;
 	spin_unlock_bh(&conn->sess->session_stats_lock);
 
-	hdr			= (struct iscsi_scsi_rsp *) cmd->pdu;
 	memset(hdr, 0, ISCSI_HDR_LEN);
 	hdr->opcode		= ISCSI_OP_SCSI_CMD_RSP;
 	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
@@ -3164,6 +3173,23 @@ static int iscsit_send_status(
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
 
+	pr_debug("Built SCSI Response, ITT: 0x%08x, StatSN: 0x%08x,"
+		" Response: 0x%02x, SAM Status: 0x%02x, CID: %hu\n",
+		cmd->init_task_tag, cmd->stat_sn, cmd->se_cmd.scsi_status,
+		cmd->se_cmd.scsi_status, conn->cid);
+}
+EXPORT_SYMBOL(iscsit_build_rsp_pdu);
+
+static int iscsit_send_response(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
+{
+	struct iscsi_scsi_rsp *hdr = (struct iscsi_scsi_rsp *)&cmd->pdu[0];
+	struct kvec *iov;
+	u32 padding = 0, tx_size = 0;
+	int iov_count = 0;
+	bool inc_stat_sn = (cmd->i_state == ISTATE_SEND_STATUS);
+
+	iscsit_build_rsp_pdu(cmd, conn, inc_stat_sn, hdr);
+
 	iov = &cmd->iov_misc[0];
 	iov[iov_count].iov_base	= cmd->pdu;
 	iov[iov_count++].iov_len = ISCSI_HDR_LEN;
@@ -3218,7 +3244,7 @@ static int iscsit_send_status(
 		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
 
 		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
-				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				(unsigned char *)cmd->pdu, ISCSI_HDR_LEN,
 				0, NULL, (u8 *)header_digest);
 
 		iov[0].iov_len += ISCSI_CRC_LEN;
@@ -3230,11 +3256,6 @@ static int iscsit_send_status(
 	cmd->iov_misc_count = iov_count;
 	cmd->tx_size = tx_size;
 
-	pr_debug("Built %sSCSI Response, ITT: 0x%08x, StatSN: 0x%08x,"
-		" Response: 0x%02x, SAM Status: 0x%02x, CID: %hu\n",
-		(!recovery) ? "" : "Recovery ", cmd->init_task_tag,
-		cmd->stat_sn, 0x00, cmd->se_cmd.scsi_status, conn->cid);
-
 	return 0;
 }
 
@@ -3257,16 +3278,12 @@ static u8 iscsit_convert_tcm_tmr_rsp(struct se_tmr_req *se_tmr)
 	}
 }
 
-static int iscsit_send_task_mgt_rsp(
-	struct iscsi_cmd *cmd,
-	struct iscsi_conn *conn)
+void
+iscsit_build_task_mgt_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
+			  struct iscsi_tm_rsp *hdr)
 {
 	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
-	struct iscsi_tm_rsp *hdr;
-	u32 tx_size = 0;
 
-	hdr			= (struct iscsi_tm_rsp *) cmd->pdu;
-	memset(hdr, 0, ISCSI_HDR_LEN);
 	hdr->opcode		= ISCSI_OP_SCSI_TMFUNC_RSP;
 	hdr->flags		= ISCSI_FLAG_CMD_FINAL;
 	hdr->response		= iscsit_convert_tcm_tmr_rsp(se_tmr);
@@ -3278,6 +3295,20 @@ static int iscsit_send_task_mgt_rsp(
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
 
+	pr_debug("Built Task Management Response ITT: 0x%08x,"
+		" StatSN: 0x%08x, Response: 0x%02x, CID: %hu\n",
+		cmd->init_task_tag, cmd->stat_sn, hdr->response, conn->cid);
+}
+EXPORT_SYMBOL(iscsit_build_task_mgt_rsp);
+
+static int
+iscsit_send_task_mgt_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
+{
+	struct iscsi_tm_rsp *hdr = (struct iscsi_tm_rsp *)&cmd->pdu[0];
+	u32 tx_size = 0;
+
+	iscsit_build_task_mgt_rsp(cmd, conn, hdr);
+
 	cmd->iov_misc[0].iov_base	= cmd->pdu;
 	cmd->iov_misc[0].iov_len	= ISCSI_HDR_LEN;
 	tx_size += ISCSI_HDR_LEN;
@@ -3298,10 +3329,6 @@ static int iscsit_send_task_mgt_rsp(
 	cmd->iov_misc_count = 1;
 	cmd->tx_size = tx_size;
 
-	pr_debug("Built Task Management Response ITT: 0x%08x,"
-		" StatSN: 0x%08x, Response: 0x%02x, CID: %hu\n",
-		cmd->init_task_tag, cmd->stat_sn, hdr->response, conn->cid);
-
 	return 0;
 }
 
@@ -3497,6 +3524,22 @@ static int iscsit_send_text_rsp(
 	return 0;
 }
 
+void
+iscsit_build_reject(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
+		    struct iscsi_reject *hdr)
+{
+	hdr->opcode		= ISCSI_OP_REJECT;
+	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
+	hton24(hdr->dlength, ISCSI_HDR_LEN);
+	hdr->ffffffff		= cpu_to_be32(0xffffffff);
+	cmd->stat_sn		= conn->stat_sn++;
+	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
+	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+
+}
+EXPORT_SYMBOL(iscsit_build_reject);
+
 static int iscsit_send_reject(
 	struct iscsi_cmd *cmd,
 	struct iscsi_conn *conn)
@@ -3505,18 +3548,9 @@ static int iscsit_send_reject(
 	struct iscsi_reject *hdr;
 	struct kvec *iov;
 
-	hdr			= (struct iscsi_reject *) cmd->pdu;
-	hdr->opcode		= ISCSI_OP_REJECT;
-	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
-	hton24(hdr->dlength, ISCSI_HDR_LEN);
-	hdr->ffffffff		= cpu_to_be32(0xffffffff);
-	cmd->stat_sn		= conn->stat_sn++;
-	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
-	hdr->exp_cmdsn	= cpu_to_be32(conn->sess->exp_cmd_sn);
-	hdr->max_cmdsn	= cpu_to_be32(conn->sess->max_cmd_sn);
+	iscsit_build_reject(cmd, conn, (struct iscsi_reject *)&cmd->pdu[0]);
 
 	iov = &cmd->iov_misc[0];
-
 	iov[iov_count].iov_base = cmd->pdu;
 	iov[iov_count++].iov_len = ISCSI_HDR_LEN;
 	iov[iov_count].iov_base = cmd->buf_ptr;
@@ -3613,55 +3647,41 @@ static inline void iscsit_thread_check_cpumask(
 	set_cpus_allowed_ptr(p, conn->conn_cpumask);
 }
 
-static int handle_immediate_queue(struct iscsi_conn *conn)
+static int
+iscsit_immediate_queue(struct iscsi_conn *conn, struct iscsi_cmd *cmd, int state)
 {
-	struct iscsi_queue_req *qr;
-	struct iscsi_cmd *cmd;
-	u8 state;
 	int ret;
 
-	while ((qr = iscsit_get_cmd_from_immediate_queue(conn))) {
-		atomic_set(&conn->check_immediate_queue, 0);
-		cmd = qr->cmd;
-		state = qr->state;
-		kmem_cache_free(lio_qr_cache, qr);
-
-		switch (state) {
-		case ISTATE_SEND_R2T:
-			ret = iscsit_send_r2t(cmd, conn);
-			if (ret < 0)
-				goto err;
-			break;
-		case ISTATE_REMOVE:
-			if (cmd->data_direction == DMA_TO_DEVICE)
-				iscsit_stop_dataout_timer(cmd);
-
-			spin_lock_bh(&conn->cmd_lock);
-			list_del(&cmd->i_conn_node);
-			spin_unlock_bh(&conn->cmd_lock);
+	switch (state) {
+	case ISTATE_SEND_R2T:
+		ret = iscsit_send_r2t(cmd, conn);
+		if (ret < 0)
+			goto err;
+		break;
+	case ISTATE_REMOVE:
+		spin_lock_bh(&conn->cmd_lock);
+		list_del(&cmd->i_conn_node);
+		spin_unlock_bh(&conn->cmd_lock);
 
-			iscsit_free_cmd(cmd);
-			continue;
-		case ISTATE_SEND_NOPIN_WANT_RESPONSE:
-			iscsit_mod_nopin_response_timer(conn);
-			ret = iscsit_send_unsolicited_nopin(cmd,
-							    conn, 1);
-			if (ret < 0)
-				goto err;
-			break;
-		case ISTATE_SEND_NOPIN_NO_RESPONSE:
-			ret = iscsit_send_unsolicited_nopin(cmd,
-							    conn, 0);
-			if (ret < 0)
-				goto err;
-			break;
-		default:
-			pr_err("Unknown Opcode: 0x%02x ITT:"
-			       " 0x%08x, i_state: %d on CID: %hu\n",
-			       cmd->iscsi_opcode, cmd->init_task_tag, state,
-			       conn->cid);
+		iscsit_free_cmd(cmd);
+		break;
+	case ISTATE_SEND_NOPIN_WANT_RESPONSE:
+		iscsit_mod_nopin_response_timer(conn);
+		ret = iscsit_send_unsolicited_nopin(cmd, conn, 1);
+		if (ret < 0)
 			goto err;
-		}
+		break;
+	case ISTATE_SEND_NOPIN_NO_RESPONSE:
+		ret = iscsit_send_unsolicited_nopin(cmd, conn, 0);
+		if (ret < 0)
+			goto err;
+		break;
+	default:
+		pr_err("Unknown Opcode: 0x%02x ITT:"
+		       " 0x%08x, i_state: %d on CID: %hu\n",
+		       cmd->iscsi_opcode, cmd->init_task_tag, state,
+		       conn->cid);
+		goto err;
 	}
 
 	return 0;
@@ -3670,128 +3690,149 @@ err:
 	return -1;
 }
 
-static int handle_response_queue(struct iscsi_conn *conn)
+static int
+iscsit_handle_immediate_queue(struct iscsi_conn *conn)
 {
+	struct iscsit_transport *t = conn->conn_transport;
 	struct iscsi_queue_req *qr;
 	struct iscsi_cmd *cmd;
 	u8 state;
 	int ret;
 
-	while ((qr = iscsit_get_cmd_from_response_queue(conn))) {
+	while ((qr = iscsit_get_cmd_from_immediate_queue(conn))) {
+		atomic_set(&conn->check_immediate_queue, 0);
 		cmd = qr->cmd;
 		state = qr->state;
 		kmem_cache_free(lio_qr_cache, qr);
 
-check_rsp_state:
-		switch (state) {
-		case ISTATE_SEND_DATAIN:
-			ret = iscsit_send_data_in(cmd, conn);
-			if (ret < 0)
-				goto err;
-			else if (!ret)
-				/* more drs */
-				goto check_rsp_state;
-			else if (ret == 1) {
-				/* all done */
-				spin_lock_bh(&cmd->istate_lock);
-				cmd->i_state = ISTATE_SENT_STATUS;
-				spin_unlock_bh(&cmd->istate_lock);
-
-				if (atomic_read(&conn->check_immediate_queue))
-					return 1;
+		ret = t->iscsit_immediate_queue(conn, cmd, state);
+		if (ret < 0)
+			return ret;
+	}
 
-				continue;
-			} else if (ret == 2) {
-				/* Still must send status,
-				   SCF_TRANSPORT_TASK_SENSE was set */
-				spin_lock_bh(&cmd->istate_lock);
-				cmd->i_state = ISTATE_SEND_STATUS;
-				spin_unlock_bh(&cmd->istate_lock);
-				state = ISTATE_SEND_STATUS;
-				goto check_rsp_state;
-			}
+	return 0;
+}
 
-			break;
-		case ISTATE_SEND_STATUS:
-		case ISTATE_SEND_STATUS_RECOVERY:
-			ret = iscsit_send_status(cmd, conn);
-			break;
-		case ISTATE_SEND_LOGOUTRSP:
-			ret = iscsit_send_logout_response(cmd, conn);
-			break;
-		case ISTATE_SEND_ASYNCMSG:
-			ret = iscsit_send_conn_drop_async_message(
-				cmd, conn);
-			break;
-		case ISTATE_SEND_NOPIN:
-			ret = iscsit_send_nopin_response(cmd, conn);
-			break;
-		case ISTATE_SEND_REJECT:
-			ret = iscsit_send_reject(cmd, conn);
-			break;
-		case ISTATE_SEND_TASKMGTRSP:
-			ret = iscsit_send_task_mgt_rsp(cmd, conn);
-			if (ret != 0)
-				break;
-			ret = iscsit_tmr_post_handler(cmd, conn);
-			if (ret != 0)
-				iscsit_fall_back_to_erl0(conn->sess);
-			break;
-		case ISTATE_SEND_TEXTRSP:
-			ret = iscsit_send_text_rsp(cmd, conn);
-			break;
-		default:
-			pr_err("Unknown Opcode: 0x%02x ITT:"
-			       " 0x%08x, i_state: %d on CID: %hu\n",
-			       cmd->iscsi_opcode, cmd->init_task_tag,
-			       state, conn->cid);
-			goto err;
-		}
+static int
+iscsit_response_queue(struct iscsi_conn *conn, struct iscsi_cmd *cmd, int state)
+{
+	int ret;
+
+check_rsp_state:
+	switch (state) {
+	case ISTATE_SEND_DATAIN:
+		ret = iscsit_send_datain(cmd, conn);
 		if (ret < 0)
 			goto err;
+		else if (!ret)
+			/* more drs */
+			goto check_rsp_state;
+		else if (ret == 1) {
+			/* all done */
+			spin_lock_bh(&cmd->istate_lock);
+			cmd->i_state = ISTATE_SENT_STATUS;
+			spin_unlock_bh(&cmd->istate_lock);
 
-		if (iscsit_send_tx_data(cmd, conn, 1) < 0) {
-			iscsit_tx_thread_wait_for_tcp(conn);
-			iscsit_unmap_iovec(cmd);
-			goto err;
+			if (atomic_read(&conn->check_immediate_queue))
+				return 1;
+
+			return 0;
+		} else if (ret == 2) {
+			/* Still must send status,
+			   SCF_TRANSPORT_TASK_SENSE was set */
+			spin_lock_bh(&cmd->istate_lock);
+			cmd->i_state = ISTATE_SEND_STATUS;
+			spin_unlock_bh(&cmd->istate_lock);
+			state = ISTATE_SEND_STATUS;
+			goto check_rsp_state;
 		}
-		iscsit_unmap_iovec(cmd);
 
-		switch (state) {
-		case ISTATE_SEND_LOGOUTRSP:
-			if (!iscsit_logout_post_handler(cmd, conn))
-				goto restart;
-			/* fall through */
-		case ISTATE_SEND_STATUS:
-		case ISTATE_SEND_ASYNCMSG:
-		case ISTATE_SEND_NOPIN:
-		case ISTATE_SEND_STATUS_RECOVERY:
-		case ISTATE_SEND_TEXTRSP:
-		case ISTATE_SEND_TASKMGTRSP:
+		break;
+	case ISTATE_SEND_STATUS:
+	case ISTATE_SEND_STATUS_RECOVERY:
+		ret = iscsit_send_response(cmd, conn);
+		break;
+	case ISTATE_SEND_LOGOUTRSP:
+		ret = iscsit_send_logout(cmd, conn);
+		break;
+	case ISTATE_SEND_ASYNCMSG:
+		ret = iscsit_send_conn_drop_async_message(
+			cmd, conn);
+		break;
+	case ISTATE_SEND_NOPIN:
+		ret = iscsit_send_nopin(cmd, conn);
+		if (!ret) {
 			spin_lock_bh(&cmd->istate_lock);
 			cmd->i_state = ISTATE_SENT_STATUS;
 			spin_unlock_bh(&cmd->istate_lock);
+			return 0;
+		}
+		break;
+	case ISTATE_SEND_REJECT:
+		ret = iscsit_send_reject(cmd, conn);
+		break;
+	case ISTATE_SEND_TASKMGTRSP:
+		ret = iscsit_send_task_mgt_rsp(cmd, conn);
+		if (ret != 0)
 			break;
-		case ISTATE_SEND_REJECT:
-			if (cmd->cmd_flags & ICF_REJECT_FAIL_CONN) {
-				cmd->cmd_flags &= ~ICF_REJECT_FAIL_CONN;
-				complete(&cmd->reject_comp);
-				goto err;
-			}
+		ret = iscsit_tmr_post_handler(cmd, conn);
+		if (ret != 0)
+			iscsit_fall_back_to_erl0(conn->sess);
+		break;
+	case ISTATE_SEND_TEXTRSP:
+		ret = iscsit_send_text_rsp(cmd, conn);
+		break;
+	default:
+		pr_err("Unknown Opcode: 0x%02x ITT:"
+		       " 0x%08x, i_state: %d on CID: %hu\n",
+		       cmd->iscsi_opcode, cmd->init_task_tag,
+		       state, conn->cid);
+		goto err;
+	}
+	if (ret < 0)
+		goto err;
+
+	if (iscsit_send_tx_data(cmd, conn, 1) < 0) {
+		iscsit_tx_thread_wait_for_tcp(conn);
+		iscsit_unmap_iovec(cmd);
+		goto err;
+	}
+	iscsit_unmap_iovec(cmd);
+
+	switch (state) {
+	case ISTATE_SEND_LOGOUTRSP:
+		if (!iscsit_logout_post_handler(cmd, conn))
+			goto restart;
+		/* fall through */
+	case ISTATE_SEND_STATUS:
+	case ISTATE_SEND_ASYNCMSG:
+	case ISTATE_SEND_NOPIN:
+	case ISTATE_SEND_STATUS_RECOVERY:
+	case ISTATE_SEND_TEXTRSP:
+	case ISTATE_SEND_TASKMGTRSP:
+		spin_lock_bh(&cmd->istate_lock);
+		cmd->i_state = ISTATE_SENT_STATUS;
+		spin_unlock_bh(&cmd->istate_lock);
+		break;
+	case ISTATE_SEND_REJECT:
+		if (cmd->cmd_flags & ICF_REJECT_FAIL_CONN) {
+			cmd->cmd_flags &= ~ICF_REJECT_FAIL_CONN;
 			complete(&cmd->reject_comp);
-			break;
-		default:
-			pr_err("Unknown Opcode: 0x%02x ITT:"
-			       " 0x%08x, i_state: %d on CID: %hu\n",
-			       cmd->iscsi_opcode, cmd->init_task_tag,
-			       cmd->i_state, conn->cid);
 			goto err;
 		}
-
-		if (atomic_read(&conn->check_immediate_queue))
-			return 1;
+		complete(&cmd->reject_comp);
+		break;
+	default:
+		pr_err("Unknown Opcode: 0x%02x ITT:"
+		       " 0x%08x, i_state: %d on CID: %hu\n",
+		       cmd->iscsi_opcode, cmd->init_task_tag,
+		       cmd->i_state, conn->cid);
+		goto err;
 	}
 
+	if (atomic_read(&conn->check_immediate_queue))
+		return 1;
+
 	return 0;
 
 err:
@@ -3800,6 +3841,27 @@ restart:
 	return -EAGAIN;
 }
 
+static int iscsit_handle_response_queue(struct iscsi_conn *conn)
+{
+	struct iscsit_transport *t = conn->conn_transport;
+	struct iscsi_queue_req *qr;
+	struct iscsi_cmd *cmd;
+	u8 state;
+	int ret;
+
+	while ((qr = iscsit_get_cmd_from_response_queue(conn))) {
+		cmd = qr->cmd;
+		state = qr->state;
+		kmem_cache_free(lio_qr_cache, qr);
+
+		ret = t->iscsit_response_queue(conn, cmd, state);
+		if (ret == 1 || ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 int iscsi_target_tx_thread(void *arg)
 {
 	int ret = 0;
@@ -3834,11 +3896,11 @@ restart:
 			goto transport_err;
 
 get_immediate:
-		ret = handle_immediate_queue(conn);
+		ret = iscsit_handle_immediate_queue(conn);
 		if (ret < 0)
 			goto transport_err;
 
-		ret = handle_response_queue(conn);
+		ret = iscsit_handle_response_queue(conn);
 		if (ret == 1)
 			goto get_immediate;
 		else if (ret == -EAGAIN)
@@ -4438,7 +4500,7 @@ static void iscsit_logout_post_handler_diffcid(
 /*
  *	Return of 0 causes the TX thread to restart.
  */
-static int iscsit_logout_post_handler(
+int iscsit_logout_post_handler(
 	struct iscsi_cmd *cmd,
 	struct iscsi_conn *conn)
 {
@@ -4496,6 +4558,7 @@ static int iscsit_logout_post_handler(
 	}
 	return ret;
 }
+EXPORT_SYMBOL(iscsit_logout_post_handler);
 
 void iscsit_fail_session(struct iscsi_session *sess)
 {
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index ce3d321..2704daf 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -27,6 +27,7 @@
 #include <target/target_core_fabric_configfs.h>
 #include <target/target_core_configfs.h>
 #include <target/configfs_macros.h>
+#include <target/iscsi/iscsi_transport.h>
 
 #include "iscsi_target_core.h"
 #include "iscsi_target_parameters.h"
@@ -1536,7 +1537,8 @@ static int lio_queue_data_in(struct se_cmd *se_cmd)
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
 
 	cmd->i_state = ISTATE_SEND_DATAIN;
-	iscsit_add_cmd_to_response_queue(cmd, cmd->conn, cmd->i_state);
+	cmd->conn->conn_transport->iscsit_queue_data_in(cmd->conn, cmd);
+
 	return 0;
 }
 
@@ -1568,7 +1570,8 @@ static int lio_queue_status(struct se_cmd *se_cmd)
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
 
 	cmd->i_state = ISTATE_SEND_STATUS;
-	iscsit_add_cmd_to_response_queue(cmd, cmd->conn, cmd->i_state);
+	cmd->conn->conn_transport->iscsit_queue_status(cmd->conn, cmd);
+
 	return 0;
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_device.c b/drivers/target/iscsi/iscsi_target_device.c
index bcc4098..1b74033 100644
--- a/drivers/target/iscsi/iscsi_target_device.c
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -60,8 +60,13 @@ void iscsit_increment_maxcmdsn(struct iscsi_cmd *cmd, struct iscsi_session *sess
 
 	cmd->maxcmdsn_inc = 1;
 
-	mutex_lock(&sess->cmdsn_mutex);
+	if (!mutex_trylock(&sess->cmdsn_mutex)) {
+		sess->max_cmd_sn += 1;
+		pr_debug("Updated MaxCmdSN to 0x%08x\n", sess->max_cmd_sn);
+		return;
+	}
 	sess->max_cmd_sn += 1;
 	pr_debug("Updated MaxCmdSN to 0x%08x\n", sess->max_cmd_sn);
 	mutex_unlock(&sess->cmdsn_mutex);
 }
+EXPORT_SYMBOL(iscsit_increment_maxcmdsn);
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index 16ca0ef..b997e5d 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -472,6 +472,7 @@ int iscsit_tmr_post_handler(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 
 	return 0;
 }
+EXPORT_SYMBOL(iscsit_tmr_post_handler);
 
 /*
  *	Nothing to do here, but leave it for good measure. :-)
-- 
1.7.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
