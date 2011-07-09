From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 11/20] target/iscsi: Remove SE_CMD macro
Date: Fri,  8 Jul 2011 18:18:40 -0700
Message-ID: <1310174329-22228-12-git-send-email-agrover@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab1GIBTB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jul 2011 21:19:01 -0400
In-Reply-To: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Similar to macros that were in the core, we can remove this macro and
help make the code a little more straightforward.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c        |   90 ++++++++++++++--------------
 drivers/target/iscsi/iscsi_target_core.h   |    2 -
 drivers/target/iscsi/iscsi_target_device.c |    4 +-
 drivers/target/iscsi/iscsi_target_erl0.c   |    4 +-
 drivers/target/iscsi/iscsi_target_erl1.c   |    2 +-
 drivers/target/iscsi/iscsi_target_erl2.c   |   61 ++++++++-----------
 drivers/target/iscsi/iscsi_target_tmr.c    |   14 ++--
 drivers/target/iscsi/iscsi_target_util.c   |    2 +-
 8 files changed, 85 insertions(+), 94 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index f0681ca..3007956 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1008,7 +1008,7 @@ done:
 	ret = iscsit_get_lun_for_cmd(cmd, hdr->cdb,
 				get_unaligned_le64(&hdr->lun[0]));
 	if (ret < 0) {
-		if (SE_CMD(cmd)->scsi_sense_reason == TCM_NON_EXISTENT_LUN) {
+		if (cmd->se_cmd.scsi_sense_reason == TCM_NON_EXISTENT_LUN) {
 			pr_debug("Responding to non-acl'ed,"
 				" non-existent or non-exported iSCSI LUN:"
 				" 0x%016Lx\n", get_unaligned_le64(&hdr->lun[0]));
@@ -1027,7 +1027,7 @@ done:
 	 * allocate 1->N transport tasks (depending on sector count and
 	 * maximum request size the physical HBA(s) can handle.
 	 */
-	transport_ret = transport_generic_allocate_tasks(SE_CMD(cmd), hdr->cdb);
+	transport_ret = transport_generic_allocate_tasks(&cmd->se_cmd, hdr->cdb);
 	if (transport_ret == -ENOMEM) {
 		return iscsit_add_reject_from_cmd(
 				ISCSI_REASON_BOOKMARK_NO_RESOURCES,
@@ -1054,7 +1054,7 @@ attach_cmd:
 	 * Check if we need to delay processing because of ALUA
 	 * Active/NonOptimized primary access state..
 	 */
-	core_alua_check_nonop_delay(SE_CMD(cmd));
+	core_alua_check_nonop_delay(&cmd->se_cmd);
 	/*
 	 * Allocate and setup SGL used with transport_generic_map_mem_to_cmd().
 	 * also call iscsit_allocate_iovecs()
@@ -1117,7 +1117,7 @@ attach_cmd:
 	 * the backend memory allocation.
 	 */
 	ret = transport_generic_new_cmd(&cmd->se_cmd);
-	if ((ret < 0) || (SE_CMD(cmd)->se_cmd_flags & SCF_SE_CMD_FAILED)) {
+	if ((ret < 0) || (cmd->se_cmd.se_cmd_flags & SCF_SE_CMD_FAILED)) {
 		immed_ret = IMMEDIATE_DATA_NORMAL_OPERATION;
 		dump_immediate_data = 1;
 		goto after_immediate_data;
@@ -1301,7 +1301,7 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
 		return iscsit_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
 				1, 0, buf, cmd);
 	}
-	se_cmd = SE_CMD(cmd);
+	se_cmd = &cmd->se_cmd;
 	iscsit_mod_dataout_timer(cmd);
 
 	if ((hdr->offset + payload_length) > cmd->data_length) {
@@ -1318,7 +1318,7 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
 		if (conn->sess->sess_ops->InitialR2T) {
 			pr_err("Received unexpected unsolicited data"
 				" while InitialR2T=Yes, protocol error.\n");
-			transport_send_check_condition_and_sense(SE_CMD(cmd),
+			transport_send_check_condition_and_sense(&cmd->se_cmd,
 					TCM_UNEXPECTED_UNSOLICITED_DATA, 0);
 			return -1;
 		}
@@ -1457,7 +1457,7 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
 
 		iscsit_stop_dataout_timer(cmd);
 		return (!ooo_cmdsn) ? transport_generic_handle_data(
-					SE_CMD(cmd)) : 0;
+					&cmd->se_cmd) : 0;
 	} else /* DATAOUT_CANNOT_RECOVER */
 		return -1;
 
@@ -1740,7 +1740,7 @@ static int iscsit_handle_task_mgt_cmd(
 	cmd->targ_xfer_tag	= 0xFFFFFFFF;
 	cmd->cmd_sn		= hdr->cmdsn;
 	cmd->exp_stat_sn	= hdr->exp_statsn;
-	se_tmr			= SE_CMD(cmd)->se_tmr_req;
+	se_tmr			= cmd->se_cmd.se_tmr_req;
 	tmr_req			= cmd->tmr_req;
 	/*
 	 * Locate the struct se_lun for all TMRs not related to ERL=2 TASK_REASSIGN
@@ -1749,7 +1749,7 @@ static int iscsit_handle_task_mgt_cmd(
 		ret = iscsit_get_lun_for_tmr(cmd,
 				get_unaligned_le64(&hdr->lun[0]));
 		if (ret < 0) {
-			SE_CMD(cmd)->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+			cmd->se_cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 			se_tmr->response = ISCSI_TMF_RSP_NO_LUN;
 			goto attach;
 		}
@@ -1759,7 +1759,7 @@ static int iscsit_handle_task_mgt_cmd(
 	case ISCSI_TM_FUNC_ABORT_TASK:
 		se_tmr->response = iscsit_tmr_abort_task(cmd, buf);
 		if (se_tmr->response != ISCSI_TMF_RSP_COMPLETE) {
-			SE_CMD(cmd)->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+			cmd->se_cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 			goto attach;
 		}
 		break;
@@ -1770,14 +1770,14 @@ static int iscsit_handle_task_mgt_cmd(
 		break;
 	case ISCSI_TM_FUNC_TARGET_WARM_RESET:
 		if (iscsit_tmr_task_warm_reset(conn, tmr_req, buf) < 0) {
-			SE_CMD(cmd)->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+			cmd->se_cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 			se_tmr->response = ISCSI_TMF_RSP_AUTH_FAILED;
 			goto attach;
 		}
 		break;
 	case ISCSI_TM_FUNC_TARGET_COLD_RESET:
 		if (iscsit_tmr_task_cold_reset(conn, tmr_req, buf) < 0) {
-			SE_CMD(cmd)->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+			cmd->se_cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 			se_tmr->response = ISCSI_TMF_RSP_AUTH_FAILED;
 			goto attach;
 		}
@@ -1799,7 +1799,7 @@ static int iscsit_handle_task_mgt_cmd(
 	default:
 		pr_err("Unknown TMR function: 0x%02x, protocol"
 			" error.\n", function);
-		SE_CMD(cmd)->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+		cmd->se_cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		se_tmr->response = ISCSI_TMF_RSP_NOT_SUPPORTED;
 		goto attach;
 	}
@@ -1832,7 +1832,7 @@ attach:
 	 * Found the referenced task, send to transport for processing.
 	 */
 	if (se_tmr->call_transport)
-		return transport_generic_handle_tmr(SE_CMD(cmd));
+		return transport_generic_handle_tmr(&cmd->se_cmd);
 
 	/*
 	 * Could not find the referenced LUN, task, or Task Management
@@ -2489,7 +2489,7 @@ static int iscsit_send_data_in(
 	 * and Sense Data.
 	 */
 	if ((datain.flags & ISCSI_FLAG_DATA_STATUS) &&
-	    (SE_CMD(cmd)->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE))
+	    (cmd->se_cmd.se_cmd_flags & SCF_TRANSPORT_TASK_SENSE))
 		datain.flags &= ~ISCSI_FLAG_DATA_STATUS;
 	else {
 		if ((dr->dr_complete == DATAIN_COMPLETE_NORMAL) ||
@@ -2507,17 +2507,17 @@ static int iscsit_send_data_in(
 	hdr->opcode		= ISCSI_OP_SCSI_DATA_IN;
 	hdr->flags		= datain.flags;
 	if (hdr->flags & ISCSI_FLAG_DATA_STATUS) {
-		if (SE_CMD(cmd)->se_cmd_flags & SCF_OVERFLOW_BIT) {
+		if (cmd->se_cmd.se_cmd_flags & SCF_OVERFLOW_BIT) {
 			hdr->flags |= ISCSI_FLAG_DATA_OVERFLOW;
 			hdr->residual_count = cpu_to_be32(cmd->residual_count);
-		} else if (SE_CMD(cmd)->se_cmd_flags & SCF_UNDERFLOW_BIT) {
+		} else if (cmd->se_cmd.se_cmd_flags & SCF_UNDERFLOW_BIT) {
 			hdr->flags |= ISCSI_FLAG_DATA_UNDERFLOW;
 			hdr->residual_count = cpu_to_be32(cmd->residual_count);
 		}
 	}
 	hton24(hdr->dlength, datain.length);
 	if (hdr->flags & ISCSI_FLAG_DATA_ACK)
-		int_to_scsilun(SE_CMD(cmd)->orig_fe_lun,
+		int_to_scsilun(cmd->se_cmd.orig_fe_lun,
 				(struct scsi_lun *)&hdr->lun[0]);
 	else
 		put_unaligned_le64(0xFFFFFFFFFFFFFFFFULL, &hdr->lun[0]);
@@ -2589,7 +2589,7 @@ static int iscsit_send_data_in(
 		ntohl(hdr->offset), datain.length, conn->cid);
 
 	if (dr->dr_complete) {
-		*eodr = (SE_CMD(cmd)->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ?
+		*eodr = (cmd->se_cmd.se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ?
 				2 : 1;
 		iscsit_free_datain_req(cmd, dr);
 	}
@@ -2864,7 +2864,7 @@ int iscsit_send_r2t(
 	memset(hdr, 0, ISCSI_HDR_LEN);
 	hdr->opcode		= ISCSI_OP_R2T;
 	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
-	int_to_scsilun(SE_CMD(cmd)->orig_fe_lun,
+	int_to_scsilun(cmd->se_cmd.orig_fe_lun,
 			(struct scsi_lun *)&hdr->lun[0]);
 	hdr->itt		= cpu_to_be32(cmd->init_task_tag);
 	spin_lock_bh(&conn->sess->ttt_lock);
@@ -3012,15 +3012,15 @@ static int iscsit_send_status(
 	memset(hdr, 0, ISCSI_HDR_LEN);
 	hdr->opcode		= ISCSI_OP_SCSI_CMD_RSP;
 	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
-	if (SE_CMD(cmd)->se_cmd_flags & SCF_OVERFLOW_BIT) {
+	if (cmd->se_cmd.se_cmd_flags & SCF_OVERFLOW_BIT) {
 		hdr->flags |= ISCSI_FLAG_CMD_OVERFLOW;
 		hdr->residual_count = cpu_to_be32(cmd->residual_count);
-	} else if (SE_CMD(cmd)->se_cmd_flags & SCF_UNDERFLOW_BIT) {
+	} else if (cmd->se_cmd.se_cmd_flags & SCF_UNDERFLOW_BIT) {
 		hdr->flags |= ISCSI_FLAG_CMD_UNDERFLOW;
 		hdr->residual_count = cpu_to_be32(cmd->residual_count);
 	}
 	hdr->response		= cmd->iscsi_response;
-	hdr->cmd_status		= SE_CMD(cmd)->scsi_status;
+	hdr->cmd_status		= cmd->se_cmd.scsi_status;
 	hdr->itt		= cpu_to_be32(cmd->init_task_tag);
 	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
 
@@ -3036,19 +3036,19 @@ static int iscsit_send_status(
 	/*
 	 * Attach SENSE DATA payload to iSCSI Response PDU
 	 */
-	if (SE_CMD(cmd)->sense_buffer &&
-	   ((SE_CMD(cmd)->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
-	    (SE_CMD(cmd)->se_cmd_flags & SCF_EMULATED_TASK_SENSE))) {
-		padding		= -(SE_CMD(cmd)->scsi_sense_length) & 3;
-		hton24(hdr->dlength, SE_CMD(cmd)->scsi_sense_length);
-		iov[iov_count].iov_base	= SE_CMD(cmd)->sense_buffer;
+	if (cmd->se_cmd.sense_buffer &&
+	   ((cmd->se_cmd.se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
+	    (cmd->se_cmd.se_cmd_flags & SCF_EMULATED_TASK_SENSE))) {
+		padding		= -(cmd->se_cmd.scsi_sense_length) & 3;
+		hton24(hdr->dlength, cmd->se_cmd.scsi_sense_length);
+		iov[iov_count].iov_base	= cmd->se_cmd.sense_buffer;
 		iov[iov_count++].iov_len =
-				(SE_CMD(cmd)->scsi_sense_length + padding);
-		tx_size += SE_CMD(cmd)->scsi_sense_length;
+				(cmd->se_cmd.scsi_sense_length + padding);
+		tx_size += cmd->se_cmd.scsi_sense_length;
 
 		if (padding) {
-			memset(SE_CMD(cmd)->sense_buffer +
-				SE_CMD(cmd)->scsi_sense_length, 0, padding);
+			memset(cmd->se_cmd.sense_buffer +
+				cmd->se_cmd.scsi_sense_length, 0, padding);
 			tx_size += padding;
 			pr_debug("Adding %u bytes of padding to"
 				" SENSE.\n", padding);
@@ -3056,8 +3056,8 @@ static int iscsit_send_status(
 
 		if (conn->conn_ops->DataDigest) {
 			iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
-				SE_CMD(cmd)->sense_buffer,
-				(SE_CMD(cmd)->scsi_sense_length + padding),
+				cmd->se_cmd.sense_buffer,
+				(cmd->se_cmd.scsi_sense_length + padding),
 				0, NULL, (u8 *)&cmd->data_crc);
 
 			iov[iov_count].iov_base    = &cmd->data_crc;
@@ -3066,13 +3066,13 @@ static int iscsit_send_status(
 
 			pr_debug("Attaching CRC32 DataDigest for"
 				" SENSE, %u bytes CRC 0x%08x\n",
-				(SE_CMD(cmd)->scsi_sense_length + padding),
+				(cmd->se_cmd.scsi_sense_length + padding),
 				cmd->data_crc);
 		}
 
 		pr_debug("Attaching SENSE DATA: %u bytes to iSCSI"
 				" Response PDU\n",
-				SE_CMD(cmd)->scsi_sense_length);
+				cmd->se_cmd.scsi_sense_length);
 	}
 
 	if (conn->conn_ops->HeaderDigest) {
@@ -3122,7 +3122,7 @@ static int iscsit_send_task_mgt_rsp(
 	struct iscsi_cmd *cmd,
 	struct iscsi_conn *conn)
 {
-	struct se_tmr_req *se_tmr = SE_CMD(cmd)->se_tmr_req;
+	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
 	struct iscsi_tm_rsp *hdr;
 	u32 tx_size = 0;
 
@@ -3535,11 +3535,11 @@ get_immediate:
 				 * Determine if a struct se_cmd is assoicated with
 				 * this struct iscsi_cmd.
 				 */
-				if (!(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) &&
+				if (!(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD) &&
 				    !(cmd->tmr_req))
 					iscsit_release_cmd(cmd);
 				else
-					transport_generic_free_cmd(SE_CMD(cmd),
+					transport_generic_free_cmd(&cmd->se_cmd,
 								1, 0);
 				goto get_immediate;
 			case ISTATE_SEND_NOPIN_WANT_RESPONSE:
@@ -3941,13 +3941,13 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 	 */
 	spin_lock_bh(&conn->cmd_lock);
 	list_for_each_entry_safe(cmd, cmd_tmp, &conn->conn_cmd_list, i_list) {
-		if (!(SE_CMD(cmd)) ||
-		    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD)) {
+		if (!(&cmd->se_cmd) ||
+		    !(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD)) {
 
 			list_del(&cmd->i_list);
 			spin_unlock_bh(&conn->cmd_lock);
 			iscsit_increment_maxcmdsn(cmd, sess);
-			se_cmd = SE_CMD(cmd);
+			se_cmd = &cmd->se_cmd;
 			/*
 			 * Special cases for active iSCSI TMR, and
 			 * transport_lookup_cmd_lun() failing from
@@ -3955,7 +3955,7 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 			 */
 			if (cmd->tmr_req && se_cmd->transport_wait_for_tasks)
 				se_cmd->transport_wait_for_tasks(se_cmd, 1, 1);
-			else if (SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD)
+			else if (cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD)
 				transport_release_cmd(se_cmd);
 			else
 				iscsit_release_cmd(cmd);
@@ -3967,7 +3967,7 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 		spin_unlock_bh(&conn->cmd_lock);
 
 		iscsit_increment_maxcmdsn(cmd, sess);
-		se_cmd = SE_CMD(cmd);
+		se_cmd = &cmd->se_cmd;
 
 		if (se_cmd->transport_wait_for_tasks)
 			se_cmd->transport_wait_for_tasks(se_cmd, 1, 1);
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index c66a259..470ed55 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -482,8 +482,6 @@ struct iscsi_cmd {
 
 }  ____cacheline_aligned;
 
-#define SE_CMD(cmd)		(&(cmd)->se_cmd)
-
 struct iscsi_tmr_req {
 	bool			task_reassign:1;
 	u32			ref_cmd_sn;
diff --git a/drivers/target/iscsi/iscsi_target_device.c b/drivers/target/iscsi/iscsi_target_device.c
index 40975df..9e356de 100644
--- a/drivers/target/iscsi/iscsi_target_device.c
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -35,7 +35,7 @@ int iscsit_get_lun_for_tmr(
 {
 	u32 unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
 
-	return transport_lookup_tmr_lun(SE_CMD(cmd), unpacked_lun);
+	return transport_lookup_tmr_lun(&cmd->se_cmd, unpacked_lun);
 }
 
 int iscsit_get_lun_for_cmd(
@@ -45,7 +45,7 @@ int iscsit_get_lun_for_cmd(
 {
 	u32 unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
 
-	return transport_lookup_cmd_lun(SE_CMD(cmd), unpacked_lun);
+	return transport_lookup_cmd_lun(&cmd->se_cmd, unpacked_lun);
 }
 
 void iscsit_determine_maxcmdsn(struct iscsi_session *sess)
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 863a29c..1999bf8 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -164,7 +164,7 @@ static int iscsit_dataout_check_unsolicited_sequence(
 		pr_err("Total %u bytes exceeds FirstBurstLength: %u"
 			" for this Unsolicited DataOut Burst.\n",
 			first_burst_len, conn->sess->sess_ops->FirstBurstLength);
-		transport_send_check_condition_and_sense(SE_CMD(cmd),
+		transport_send_check_condition_and_sense(&cmd->se_cmd,
 				TCM_INCORRECT_AMOUNT_OF_DATA, 0);
 		return DATAOUT_CANNOT_RECOVER;
 	}
@@ -189,7 +189,7 @@ static int iscsit_dataout_check_unsolicited_sequence(
 			" does not equal ExpXferLen %u.\n", first_burst_len,
 				conn->sess->sess_ops->FirstBurstLength,
 				cmd->data_length);
-			transport_send_check_condition_and_sense(SE_CMD(cmd),
+			transport_send_check_condition_and_sense(&cmd->se_cmd,
 					TCM_INCORRECT_AMOUNT_OF_DATA, 0);
 			return DATAOUT_CANNOT_RECOVER;
 		}
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 8db9377..9fd3e9c 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -1027,7 +1027,7 @@ int iscsit_execute_cmd(struct iscsi_cmd *cmd, int ooo)
 		}
 		spin_unlock_bh(&cmd->istate_lock);
 
-		return transport_generic_handle_tmr(SE_CMD(cmd));
+		return transport_generic_handle_tmr(&cmd->se_cmd);
 	case ISCSI_OP_LOGOUT:
 		spin_unlock_bh(&cmd->istate_lock);
 		switch (cmd->logout_reason) {
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index fcbc861..69a1091 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -143,13 +143,12 @@ void iscsit_free_connection_recovery_entires(struct iscsi_session *sess)
 			list_del(&cmd->i_list);
 			cmd->conn = NULL;
 			spin_unlock(&cr->conn_recovery_cmd_lock);
-			if (!(SE_CMD(cmd)) ||
-			    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
-			    !(SE_CMD(cmd)->transport_wait_for_tasks))
+			if (!(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD) ||
+			    !(cmd->se_cmd.transport_wait_for_tasks))
 				iscsit_release_cmd(cmd);
 			else
-				SE_CMD(cmd)->transport_wait_for_tasks(
-						SE_CMD(cmd), 1, 1);
+				cmd->se_cmd.transport_wait_for_tasks(
+						&cmd->se_cmd, 1, 1);
 			spin_lock(&cr->conn_recovery_cmd_lock);
 		}
 		spin_unlock(&cr->conn_recovery_cmd_lock);
@@ -171,13 +170,12 @@ void iscsit_free_connection_recovery_entires(struct iscsi_session *sess)
 			list_del(&cmd->i_list);
 			cmd->conn = NULL;
 			spin_unlock(&cr->conn_recovery_cmd_lock);
-			if (!(SE_CMD(cmd)) ||
-			    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
-			    !(SE_CMD(cmd)->transport_wait_for_tasks))
+			if (!(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD) ||
+			    !(cmd->se_cmd.transport_wait_for_tasks))
 				iscsit_release_cmd(cmd);
 			else
-				SE_CMD(cmd)->transport_wait_for_tasks(
-						SE_CMD(cmd), 1, 1);
+				cmd->se_cmd.transport_wait_for_tasks(
+						&cmd->se_cmd, 1, 1);
 			spin_lock(&cr->conn_recovery_cmd_lock);
 		}
 		spin_unlock(&cr->conn_recovery_cmd_lock);
@@ -262,13 +260,12 @@ void iscsit_discard_cr_cmds_by_expstatsn(
 		iscsit_remove_cmd_from_connection_recovery(cmd, sess);
 
 		spin_unlock(&cr->conn_recovery_cmd_lock);
-		if (!(SE_CMD(cmd)) ||
-		    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
-		    !(SE_CMD(cmd)->transport_wait_for_tasks))
+		if (!(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD) ||
+		    !(cmd->se_cmd.transport_wait_for_tasks))
 			iscsit_release_cmd(cmd);
 		else
-			SE_CMD(cmd)->transport_wait_for_tasks(
-					SE_CMD(cmd), 1, 0);
+			cmd->se_cmd.transport_wait_for_tasks(
+					&cmd->se_cmd, 1, 0);
 		spin_lock(&cr->conn_recovery_cmd_lock);
 	}
 	spin_unlock(&cr->conn_recovery_cmd_lock);
@@ -322,13 +319,12 @@ int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsi_conn *conn)
 		list_del(&cmd->i_list);
 
 		spin_unlock_bh(&conn->cmd_lock);
-		if (!(SE_CMD(cmd)) ||
-		    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
-		    !(SE_CMD(cmd)->transport_wait_for_tasks))
+		if (!(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD) ||
+		    !(cmd->se_cmd.transport_wait_for_tasks))
 			iscsit_release_cmd(cmd);
 		else
-			SE_CMD(cmd)->transport_wait_for_tasks(
-					SE_CMD(cmd), 1, 1);
+			cmd->se_cmd.transport_wait_for_tasks(
+					&cmd->se_cmd, 1, 1);
 		spin_lock_bh(&conn->cmd_lock);
 	}
 	spin_unlock_bh(&conn->cmd_lock);
@@ -382,13 +378,12 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 			list_del(&cmd->i_list);
 			spin_unlock_bh(&conn->cmd_lock);
 
-			if (!(SE_CMD(cmd)) ||
-			    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
-			    !(SE_CMD(cmd)->transport_wait_for_tasks))
+			if (!(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD) ||
+			    !(cmd->se_cmd.transport_wait_for_tasks))
 				iscsit_release_cmd(cmd);
 			else
-				SE_CMD(cmd)->transport_wait_for_tasks(
-						SE_CMD(cmd), 1, 0);
+				cmd->se_cmd.transport_wait_for_tasks(
+						&cmd->se_cmd, 1, 0);
 			spin_lock_bh(&conn->cmd_lock);
 			continue;
 		}
@@ -409,13 +404,12 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 			list_del(&cmd->i_list);
 			spin_unlock_bh(&conn->cmd_lock);
 
-			if (!(SE_CMD(cmd)) ||
-			    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
-			    !(SE_CMD(cmd)->transport_wait_for_tasks))
+			if (!(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD) ||
+			    !(cmd->se_cmd.transport_wait_for_tasks))
 				iscsit_release_cmd(cmd);
 			else
-				SE_CMD(cmd)->transport_wait_for_tasks(
-						SE_CMD(cmd), 1, 1);
+				cmd->se_cmd.transport_wait_for_tasks(
+						&cmd->se_cmd, 1, 1);
 			spin_lock_bh(&conn->cmd_lock);
 			continue;
 		}
@@ -440,10 +434,9 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 
 		iscsit_free_all_datain_reqs(cmd);
 
-		if ((SE_CMD(cmd)) &&
-		    (SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) &&
-		     SE_CMD(cmd)->transport_wait_for_tasks)
-			SE_CMD(cmd)->transport_wait_for_tasks(SE_CMD(cmd),
+		if ((cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD) &&
+		     cmd->se_cmd.transport_wait_for_tasks)
+			cmd->se_cmd.transport_wait_for_tasks(&cmd->se_cmd,
 					0, 0);
 		/*
 		 * Add the struct iscsi_cmd to the connection recovery cmd list
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index 1183c04..dc90366 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -42,7 +42,7 @@ u8 iscsit_tmr_abort_task(
 	struct iscsi_cmd *ref_cmd;
 	struct iscsi_conn *conn = cmd->conn;
 	struct iscsi_tmr_req *tmr_req = cmd->tmr_req;
-	struct se_tmr_req *se_tmr = SE_CMD(cmd)->se_tmr_req;
+	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
 	struct iscsi_tm *hdr = (struct iscsi_tm *) buf;
 
 	ref_cmd = iscsit_find_cmd_from_itt(conn, hdr->rtt);
@@ -122,7 +122,7 @@ u8 iscsit_tmr_task_reassign(
 	struct iscsi_conn *conn = cmd->conn;
 	struct iscsi_conn_recovery *cr = NULL;
 	struct iscsi_tmr_req *tmr_req = cmd->tmr_req;
-	struct se_tmr_req *se_tmr = SE_CMD(cmd)->se_tmr_req;
+	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
 	struct iscsi_tm *hdr = (struct iscsi_tm *) buf;
 	int ret;
 
@@ -231,7 +231,7 @@ static int iscsit_task_reassign_complete_write(
 	int no_build_r2ts = 0;
 	u32 length = 0, offset = 0;
 	struct iscsi_conn *conn = cmd->conn;
-	struct se_cmd *se_cmd = SE_CMD(cmd);
+	struct se_cmd *se_cmd = &cmd->se_cmd;
 	/*
 	 * The Initiator must not send a R2T SNACK with a Begrun less than
 	 * the TMR TASK_REASSIGN's ExpDataSN.
@@ -301,7 +301,7 @@ static int iscsit_task_reassign_complete_read(
 {
 	struct iscsi_conn *conn = cmd->conn;
 	struct iscsi_datain_req *dr;
-	struct se_cmd *se_cmd = SE_CMD(cmd);
+	struct se_cmd *se_cmd = &cmd->se_cmd;
 	/*
 	 * The Initiator must not send a Data SNACK with a BegRun less than
 	 * the TMR TASK_REASSIGN's ExpDataSN.
@@ -317,7 +317,7 @@ static int iscsit_task_reassign_complete_read(
 	if (!atomic_read(&cmd->transport_sent)) {
 		pr_debug("READ ITT: 0x%08x: t_state: %d never sent to"
 			" transport\n", cmd->init_task_tag,
-			SE_CMD(cmd)->t_state);
+			cmd->se_cmd.t_state);
 		transport_generic_handle_cdb(se_cmd);
 		return 0;
 	}
@@ -325,7 +325,7 @@ static int iscsit_task_reassign_complete_read(
 	if (!atomic_read(&se_cmd->t_transport_complete)) {
 		pr_err("READ ITT: 0x%08x: t_state: %d, never returned"
 			" from transport\n", cmd->init_task_tag,
-			SE_CMD(cmd)->t_state);
+			cmd->se_cmd.t_state);
 		return -1;
 	}
 
@@ -459,7 +459,7 @@ static int iscsit_task_reassign_complete(
 extern int iscsit_tmr_post_handler(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
 	struct iscsi_tmr_req *tmr_req = cmd->tmr_req;
-	struct se_tmr_req *se_tmr = SE_CMD(cmd)->se_tmr_req;
+	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
 
 	if (tmr_req->task_reassign &&
 	   (se_tmr->response == ISCSI_TMF_RSP_COMPLETE))
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 8568d0a..842df2e 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -480,7 +480,7 @@ int iscsit_sequence_cmd(
 int iscsit_check_unsolicited_dataout(struct iscsi_cmd *cmd, unsigned char *buf)
 {
 	struct iscsi_conn *conn = cmd->conn;
-	struct se_cmd *se_cmd = SE_CMD(cmd);
+	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct iscsi_data *hdr = (struct iscsi_data *) buf;
 	u32 payload_length = ntoh24(hdr->dlength);
 
-- 
1.7.1

