From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 10/13] iscsi-target: Add iSCSI Error Recovery Hierarchy support
Date: Sat, 23 Jul 2011 08:45:44 +0000
Message-ID: <1311410747-29947-11-git-send-email-nab@linux-iscsi.org>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34309 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1GWJKA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jul 2011 05:10:00 -0400
In-Reply-To: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for RFC-3720 compatiable ErrorRecoveryLevel
support as defined in Section 6.1.5.  Error Recovery Hierarchy.

This includes support for iSCSI session reinstatement, iSCSI within
command and within connection recovery, and explict/implict connection
recovery (CSM-E and CSM-I) from state machines in Section 7 of RFC-3720.

These functions are called from iscsi_target.c to handle processing
based on the negotiated session-wide ErrorRecoveryLevel parameter.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_erl0.c | 1004 +++++++++++++++++++++++
 drivers/target/iscsi/iscsi_target_erl0.h |   15 +
 drivers/target/iscsi/iscsi_target_erl1.c | 1299 ++++++++++++++++++++++++++++++
 drivers/target/iscsi/iscsi_target_erl1.h |   26 +
 drivers/target/iscsi/iscsi_target_erl2.c |  474 +++++++++++
 drivers/target/iscsi/iscsi_target_erl2.h |   18 +
 6 files changed, 2836 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/iscsi/iscsi_target_erl0.c
 create mode 100644 drivers/target/iscsi/iscsi_target_erl0.h
 create mode 100644 drivers/target/iscsi/iscsi_target_erl1.c
 create mode 100644 drivers/target/iscsi/iscsi_target_erl1.h
 create mode 100644 drivers/target/iscsi/iscsi_target_erl2.c
 create mode 100644 drivers/target/iscsi/iscsi_target_erl2.h

diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
new file mode 100644
index 0000000..b7ffc3c
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -0,0 +1,1004 @@
+/******************************************************************************
+ * This file contains error recovery level zero functions used by
+ * the iSCSI Target driver.
+ *
+ * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ ******************************************************************************/
+
+#include <scsi/iscsi_proto.h>
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+
+#include "iscsi_target_core.h"
+#include "iscsi_target_seq_pdu_list.h"
+#include "iscsi_target_tq.h"
+#include "iscsi_target_erl0.h"
+#include "iscsi_target_erl1.h"
+#include "iscsi_target_erl2.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target.h"
+
+/*
+ *	Used to set values in struct iscsi_cmd that iscsit_dataout_check_sequence()
+ *	checks against to determine a PDU's Offset+Length is within the current
+ *	DataOUT Sequence.  Used for DataSequenceInOrder=Yes only.
+ */
+void iscsit_set_dataout_sequence_values(
+	struct iscsi_cmd *cmd)
+{
+	struct iscsi_conn *conn = cmd->conn;
+	/*
+	 * Still set seq_start_offset and seq_end_offset for Unsolicited
+	 * DataOUT, even if DataSequenceInOrder=No.
+	 */
+	if (cmd->unsolicited_data) {
+		cmd->seq_start_offset = cmd->write_data_done;
+		cmd->seq_end_offset = (cmd->write_data_done +
+			(cmd->data_length >
+			 conn->sess->sess_ops->FirstBurstLength) ?
+			conn->sess->sess_ops->FirstBurstLength : cmd->data_length);
+		return;
+	}
+
+	if (!conn->sess->sess_ops->DataSequenceInOrder)
+		return;
+
+	if (!cmd->seq_start_offset && !cmd->seq_end_offset) {
+		cmd->seq_start_offset = cmd->write_data_done;
+		cmd->seq_end_offset = (cmd->data_length >
+			conn->sess->sess_ops->MaxBurstLength) ?
+			(cmd->write_data_done +
+			conn->sess->sess_ops->MaxBurstLength) : cmd->data_length;
+	} else {
+		cmd->seq_start_offset = cmd->seq_end_offset;
+		cmd->seq_end_offset = ((cmd->seq_end_offset +
+			conn->sess->sess_ops->MaxBurstLength) >=
+			cmd->data_length) ? cmd->data_length :
+			(cmd->seq_end_offset +
+			 conn->sess->sess_ops->MaxBurstLength);
+	}
+}
+
+static int iscsit_dataout_within_command_recovery_check(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_data *hdr = (struct iscsi_data *) buf;
+	u32 payload_length = ntoh24(hdr->dlength);
+
+	/*
+	 * We do the within-command recovery checks here as it is
+	 * the first function called in iscsi_check_pre_dataout().
+	 * Basically, if we are in within-command recovery and
+	 * the PDU does not contain the offset the sequence needs,
+	 * dump the payload.
+	 *
+	 * This only applies to DataPDUInOrder=Yes, for
+	 * DataPDUInOrder=No we only re-request the failed PDU
+	 * and check that all PDUs in a sequence are received
+	 * upon end of sequence.
+	 */
+	if (conn->sess->sess_ops->DataSequenceInOrder) {
+		if ((cmd->cmd_flags & ICF_WITHIN_COMMAND_RECOVERY) &&
+		    (cmd->write_data_done != hdr->offset))
+			goto dump;
+
+		cmd->cmd_flags &= ~ICF_WITHIN_COMMAND_RECOVERY;
+	} else {
+		struct iscsi_seq *seq;
+
+		seq = iscsit_get_seq_holder(cmd, hdr->offset, payload_length);
+		if (!seq)
+			return DATAOUT_CANNOT_RECOVER;
+		/*
+		 * Set the struct iscsi_seq pointer to reuse later.
+		 */
+		cmd->seq_ptr = seq;
+
+		if (conn->sess->sess_ops->DataPDUInOrder) {
+			if ((seq->status ==
+			     DATAOUT_SEQUENCE_WITHIN_COMMAND_RECOVERY) &&
+			   ((seq->offset != hdr->offset) ||
+			    (seq->data_sn != hdr->datasn)))
+				goto dump;
+		} else {
+			if ((seq->status ==
+			     DATAOUT_SEQUENCE_WITHIN_COMMAND_RECOVERY) &&
+			    (seq->data_sn != hdr->datasn))
+				goto dump;
+		}
+
+		if (seq->status == DATAOUT_SEQUENCE_COMPLETE)
+			goto dump;
+
+		if (seq->status != DATAOUT_SEQUENCE_COMPLETE)
+			seq->status = 0;
+	}
+
+	return DATAOUT_NORMAL;
+
+dump:
+	pr_err("Dumping DataOUT PDU Offset: %u Length: %d DataSN:"
+		" 0x%08x\n", hdr->offset, payload_length, hdr->datasn);
+	return iscsit_dump_data_payload(conn, payload_length, 1);
+}
+
+static int iscsit_dataout_check_unsolicited_sequence(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	u32 first_burst_len;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_data *hdr = (struct iscsi_data *) buf;
+	u32 payload_length = ntoh24(hdr->dlength);
+
+
+	if ((hdr->offset < cmd->seq_start_offset) ||
+	   ((hdr->offset + payload_length) > cmd->seq_end_offset)) {
+		pr_err("Command ITT: 0x%08x with Offset: %u,"
+		" Length: %u outside of Unsolicited Sequence %u:%u while"
+		" DataSequenceInOrder=Yes.\n", cmd->init_task_tag,
+		hdr->offset, payload_length, cmd->seq_start_offset,
+			cmd->seq_end_offset);
+		return DATAOUT_CANNOT_RECOVER;
+	}
+
+	first_burst_len = (cmd->first_burst_len + payload_length);
+
+	if (first_burst_len > conn->sess->sess_ops->FirstBurstLength) {
+		pr_err("Total %u bytes exceeds FirstBurstLength: %u"
+			" for this Unsolicited DataOut Burst.\n",
+			first_burst_len, conn->sess->sess_ops->FirstBurstLength);
+		transport_send_check_condition_and_sense(&cmd->se_cmd,
+				TCM_INCORRECT_AMOUNT_OF_DATA, 0);
+		return DATAOUT_CANNOT_RECOVER;
+	}
+
+	/*
+	 * Perform various MaxBurstLength and ISCSI_FLAG_CMD_FINAL sanity
+	 * checks for the current Unsolicited DataOUT Sequence.
+	 */
+	if (hdr->flags & ISCSI_FLAG_CMD_FINAL) {
+		/*
+		 * Ignore ISCSI_FLAG_CMD_FINAL checks while DataPDUInOrder=No, end of
+		 * sequence checks are handled in
+		 * iscsit_dataout_datapduinorder_no_fbit().
+		 */
+		if (!conn->sess->sess_ops->DataPDUInOrder)
+			goto out;
+
+		if ((first_burst_len != cmd->data_length) &&
+		    (first_burst_len != conn->sess->sess_ops->FirstBurstLength)) {
+			pr_err("Unsolicited non-immediate data"
+			" received %u does not equal FirstBurstLength: %u, and"
+			" does not equal ExpXferLen %u.\n", first_burst_len,
+				conn->sess->sess_ops->FirstBurstLength,
+				cmd->data_length);
+			transport_send_check_condition_and_sense(&cmd->se_cmd,
+					TCM_INCORRECT_AMOUNT_OF_DATA, 0);
+			return DATAOUT_CANNOT_RECOVER;
+		}
+	} else {
+		if (first_burst_len == conn->sess->sess_ops->FirstBurstLength) {
+			pr_err("Command ITT: 0x%08x reached"
+			" FirstBurstLength: %u, but ISCSI_FLAG_CMD_FINAL is not set. protocol"
+				" error.\n", cmd->init_task_tag,
+				conn->sess->sess_ops->FirstBurstLength);
+			return DATAOUT_CANNOT_RECOVER;
+		}
+		if (first_burst_len == cmd->data_length) {
+			pr_err("Command ITT: 0x%08x reached"
+			" ExpXferLen: %u, but ISCSI_FLAG_CMD_FINAL is not set. protocol"
+			" error.\n", cmd->init_task_tag, cmd->data_length);
+			return DATAOUT_CANNOT_RECOVER;
+		}
+	}
+
+out:
+	return DATAOUT_NORMAL;
+}
+
+static int iscsit_dataout_check_sequence(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	u32 next_burst_len;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_seq *seq = NULL;
+	struct iscsi_data *hdr = (struct iscsi_data *) buf;
+	u32 payload_length = ntoh24(hdr->dlength);
+
+	/*
+	 * For DataSequenceInOrder=Yes: Check that the offset and offset+length
+	 * is within range as defined by iscsi_set_dataout_sequence_values().
+	 *
+	 * For DataSequenceInOrder=No: Check that an struct iscsi_seq exists for
+	 * offset+length tuple.
+	 */
+	if (conn->sess->sess_ops->DataSequenceInOrder) {
+		/*
+		 * Due to possibility of recovery DataOUT sent by the initiator
+		 * fullfilling an Recovery R2T, it's best to just dump the
+		 * payload here, instead of erroring out.
+		 */
+		if ((hdr->offset < cmd->seq_start_offset) ||
+		   ((hdr->offset + payload_length) > cmd->seq_end_offset)) {
+			pr_err("Command ITT: 0x%08x with Offset: %u,"
+			" Length: %u outside of Sequence %u:%u while"
+			" DataSequenceInOrder=Yes.\n", cmd->init_task_tag,
+			hdr->offset, payload_length, cmd->seq_start_offset,
+				cmd->seq_end_offset);
+
+			if (iscsit_dump_data_payload(conn, payload_length, 1) < 0)
+				return DATAOUT_CANNOT_RECOVER;
+			return DATAOUT_WITHIN_COMMAND_RECOVERY;
+		}
+
+		next_burst_len = (cmd->next_burst_len + payload_length);
+	} else {
+		seq = iscsit_get_seq_holder(cmd, hdr->offset, payload_length);
+		if (!seq)
+			return DATAOUT_CANNOT_RECOVER;
+		/*
+		 * Set the struct iscsi_seq pointer to reuse later.
+		 */
+		cmd->seq_ptr = seq;
+
+		if (seq->status == DATAOUT_SEQUENCE_COMPLETE) {
+			if (iscsit_dump_data_payload(conn, payload_length, 1) < 0)
+				return DATAOUT_CANNOT_RECOVER;
+			return DATAOUT_WITHIN_COMMAND_RECOVERY;
+		}
+
+		next_burst_len = (seq->next_burst_len + payload_length);
+	}
+
+	if (next_burst_len > conn->sess->sess_ops->MaxBurstLength) {
+		pr_err("Command ITT: 0x%08x, NextBurstLength: %u and"
+			" Length: %u exceeds MaxBurstLength: %u. protocol"
+			" error.\n", cmd->init_task_tag,
+			(next_burst_len - payload_length),
+			payload_length, conn->sess->sess_ops->MaxBurstLength);
+		return DATAOUT_CANNOT_RECOVER;
+	}
+
+	/*
+	 * Perform various MaxBurstLength and ISCSI_FLAG_CMD_FINAL sanity
+	 * checks for the current DataOUT Sequence.
+	 */
+	if (hdr->flags & ISCSI_FLAG_CMD_FINAL) {
+		/*
+		 * Ignore ISCSI_FLAG_CMD_FINAL checks while DataPDUInOrder=No, end of
+		 * sequence checks are handled in
+		 * iscsit_dataout_datapduinorder_no_fbit().
+		 */
+		if (!conn->sess->sess_ops->DataPDUInOrder)
+			goto out;
+
+		if (conn->sess->sess_ops->DataSequenceInOrder) {
+			if ((next_burst_len <
+			     conn->sess->sess_ops->MaxBurstLength) &&
+			   ((cmd->write_data_done + payload_length) <
+			     cmd->data_length)) {
+				pr_err("Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL"
+				" before end of DataOUT sequence, protocol"
+				" error.\n", cmd->init_task_tag);
+				return DATAOUT_CANNOT_RECOVER;
+			}
+		} else {
+			if (next_burst_len < seq->xfer_len) {
+				pr_err("Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL"
+				" before end of DataOUT sequence, protocol"
+				" error.\n", cmd->init_task_tag);
+				return DATAOUT_CANNOT_RECOVER;
+			}
+		}
+	} else {
+		if (conn->sess->sess_ops->DataSequenceInOrder) {
+			if (next_burst_len ==
+					conn->sess->sess_ops->MaxBurstLength) {
+				pr_err("Command ITT: 0x%08x reached"
+				" MaxBurstLength: %u, but ISCSI_FLAG_CMD_FINAL is"
+				" not set, protocol error.", cmd->init_task_tag,
+					conn->sess->sess_ops->MaxBurstLength);
+				return DATAOUT_CANNOT_RECOVER;
+			}
+			if ((cmd->write_data_done + payload_length) ==
+					cmd->data_length) {
+				pr_err("Command ITT: 0x%08x reached"
+				" last DataOUT PDU in sequence but ISCSI_FLAG_"
+				"CMD_FINAL is not set, protocol error.\n",
+					cmd->init_task_tag);
+				return DATAOUT_CANNOT_RECOVER;
+			}
+		} else {
+			if (next_burst_len == seq->xfer_len) {
+				pr_err("Command ITT: 0x%08x reached"
+				" last DataOUT PDU in sequence but ISCSI_FLAG_"
+				"CMD_FINAL is not set, protocol error.\n",
+					cmd->init_task_tag);
+				return DATAOUT_CANNOT_RECOVER;
+			}
+		}
+	}
+
+out:
+	return DATAOUT_NORMAL;
+}
+
+static int iscsit_dataout_check_datasn(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	int dump = 0, recovery = 0;
+	u32 data_sn = 0;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_data *hdr = (struct iscsi_data *) buf;
+	u32 payload_length = ntoh24(hdr->dlength);
+
+	/*
+	 * Considering the target has no method of re-requesting DataOUT
+	 * by DataSN, if we receieve a greater DataSN than expected we
+	 * assume the functions for DataPDUInOrder=[Yes,No] below will
+	 * handle it.
+	 *
+	 * If the DataSN is less than expected, dump the payload.
+	 */
+	if (conn->sess->sess_ops->DataSequenceInOrder)
+		data_sn = cmd->data_sn;
+	else {
+		struct iscsi_seq *seq = cmd->seq_ptr;
+		data_sn = seq->data_sn;
+	}
+
+	if (hdr->datasn > data_sn) {
+		pr_err("Command ITT: 0x%08x, received DataSN: 0x%08x"
+			" higher than expected 0x%08x.\n", cmd->init_task_tag,
+				hdr->datasn, data_sn);
+		recovery = 1;
+		goto recover;
+	} else if (hdr->datasn < data_sn) {
+		pr_err("Command ITT: 0x%08x, received DataSN: 0x%08x"
+			" lower than expected 0x%08x, discarding payload.\n",
+			cmd->init_task_tag, hdr->datasn, data_sn);
+		dump = 1;
+		goto dump;
+	}
+
+	return DATAOUT_NORMAL;
+
+recover:
+	if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+		pr_err("Unable to perform within-command recovery"
+				" while ERL=0.\n");
+		return DATAOUT_CANNOT_RECOVER;
+	}
+dump:
+	if (iscsit_dump_data_payload(conn, payload_length, 1) < 0)
+		return DATAOUT_CANNOT_RECOVER;
+
+	return (recovery || dump) ? DATAOUT_WITHIN_COMMAND_RECOVERY :
+				DATAOUT_NORMAL;
+}
+
+static int iscsit_dataout_pre_datapduinorder_yes(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	int dump = 0, recovery = 0;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_data *hdr = (struct iscsi_data *) buf;
+	u32 payload_length = ntoh24(hdr->dlength);
+
+	/*
+	 * For DataSequenceInOrder=Yes: If the offset is greater than the global
+	 * DataPDUInOrder=Yes offset counter in struct iscsi_cmd a protcol error has
+	 * occured and fail the connection.
+	 *
+	 * For DataSequenceInOrder=No: If the offset is greater than the per
+	 * sequence DataPDUInOrder=Yes offset counter in struct iscsi_seq a protocol
+	 * error has occured and fail the connection.
+	 */
+	if (conn->sess->sess_ops->DataSequenceInOrder) {
+		if (hdr->offset != cmd->write_data_done) {
+			pr_err("Command ITT: 0x%08x, received offset"
+			" %u different than expected %u.\n", cmd->init_task_tag,
+				hdr->offset, cmd->write_data_done);
+			recovery = 1;
+			goto recover;
+		}
+	} else {
+		struct iscsi_seq *seq = cmd->seq_ptr;
+
+		if (hdr->offset > seq->offset) {
+			pr_err("Command ITT: 0x%08x, received offset"
+			" %u greater than expected %u.\n", cmd->init_task_tag,
+				hdr->offset, seq->offset);
+			recovery = 1;
+			goto recover;
+		} else if (hdr->offset < seq->offset) {
+			pr_err("Command ITT: 0x%08x, received offset"
+			" %u less than expected %u, discarding payload.\n",
+				cmd->init_task_tag, hdr->offset, seq->offset);
+			dump = 1;
+			goto dump;
+		}
+	}
+
+	return DATAOUT_NORMAL;
+
+recover:
+	if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+		pr_err("Unable to perform within-command recovery"
+				" while ERL=0.\n");
+		return DATAOUT_CANNOT_RECOVER;
+	}
+dump:
+	if (iscsit_dump_data_payload(conn, payload_length, 1) < 0)
+		return DATAOUT_CANNOT_RECOVER;
+
+	return (recovery) ? iscsit_recover_dataout_sequence(cmd,
+		hdr->offset, payload_length) :
+	       (dump) ? DATAOUT_WITHIN_COMMAND_RECOVERY : DATAOUT_NORMAL;
+}
+
+static int iscsit_dataout_pre_datapduinorder_no(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	struct iscsi_pdu *pdu;
+	struct iscsi_data *hdr = (struct iscsi_data *) buf;
+	u32 payload_length = ntoh24(hdr->dlength);
+
+	pdu = iscsit_get_pdu_holder(cmd, hdr->offset, payload_length);
+	if (!pdu)
+		return DATAOUT_CANNOT_RECOVER;
+
+	cmd->pdu_ptr = pdu;
+
+	switch (pdu->status) {
+	case ISCSI_PDU_NOT_RECEIVED:
+	case ISCSI_PDU_CRC_FAILED:
+	case ISCSI_PDU_TIMED_OUT:
+		break;
+	case ISCSI_PDU_RECEIVED_OK:
+		pr_err("Command ITT: 0x%08x received already gotten"
+			" Offset: %u, Length: %u\n", cmd->init_task_tag,
+				hdr->offset, payload_length);
+		return iscsit_dump_data_payload(cmd->conn, payload_length, 1);
+	default:
+		return DATAOUT_CANNOT_RECOVER;
+	}
+
+	return DATAOUT_NORMAL;
+}
+
+static int iscsit_dataout_update_r2t(struct iscsi_cmd *cmd, u32 offset, u32 length)
+{
+	struct iscsi_r2t *r2t;
+
+	if (cmd->unsolicited_data)
+		return 0;
+
+	r2t = iscsit_get_r2t_for_eos(cmd, offset, length);
+	if (!r2t)
+		return -1;
+
+	spin_lock_bh(&cmd->r2t_lock);
+	r2t->seq_complete = 1;
+	cmd->outstanding_r2ts--;
+	spin_unlock_bh(&cmd->r2t_lock);
+
+	return 0;
+}
+
+static int iscsit_dataout_update_datapduinorder_no(
+	struct iscsi_cmd *cmd,
+	u32 data_sn,
+	int f_bit)
+{
+	int ret = 0;
+	struct iscsi_pdu *pdu = cmd->pdu_ptr;
+
+	pdu->data_sn = data_sn;
+
+	switch (pdu->status) {
+	case ISCSI_PDU_NOT_RECEIVED:
+		pdu->status = ISCSI_PDU_RECEIVED_OK;
+		break;
+	case ISCSI_PDU_CRC_FAILED:
+		pdu->status = ISCSI_PDU_RECEIVED_OK;
+		break;
+	case ISCSI_PDU_TIMED_OUT:
+		pdu->status = ISCSI_PDU_RECEIVED_OK;
+		break;
+	default:
+		return DATAOUT_CANNOT_RECOVER;
+	}
+
+	if (f_bit) {
+		ret = iscsit_dataout_datapduinorder_no_fbit(cmd, pdu);
+		if (ret == DATAOUT_CANNOT_RECOVER)
+			return ret;
+	}
+
+	return DATAOUT_NORMAL;
+}
+
+static int iscsit_dataout_post_crc_passed(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	int ret, send_r2t = 0;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_seq *seq = NULL;
+	struct iscsi_data *hdr = (struct iscsi_data *) buf;
+	u32 payload_length = ntoh24(hdr->dlength);
+
+	if (cmd->unsolicited_data) {
+		if ((cmd->first_burst_len + payload_length) ==
+		     conn->sess->sess_ops->FirstBurstLength) {
+			if (iscsit_dataout_update_r2t(cmd, hdr->offset,
+					payload_length) < 0)
+				return DATAOUT_CANNOT_RECOVER;
+			send_r2t = 1;
+		}
+
+		if (!conn->sess->sess_ops->DataPDUInOrder) {
+			ret = iscsit_dataout_update_datapduinorder_no(cmd,
+				hdr->datasn, (hdr->flags & ISCSI_FLAG_CMD_FINAL));
+			if (ret == DATAOUT_CANNOT_RECOVER)
+				return ret;
+		}
+
+		cmd->first_burst_len += payload_length;
+
+		if (conn->sess->sess_ops->DataSequenceInOrder)
+			cmd->data_sn++;
+		else {
+			seq = cmd->seq_ptr;
+			seq->data_sn++;
+			seq->offset += payload_length;
+		}
+
+		if (send_r2t) {
+			if (seq)
+				seq->status = DATAOUT_SEQUENCE_COMPLETE;
+			cmd->first_burst_len = 0;
+			cmd->unsolicited_data = 0;
+		}
+	} else {
+		if (conn->sess->sess_ops->DataSequenceInOrder) {
+			if ((cmd->next_burst_len + payload_length) ==
+			     conn->sess->sess_ops->MaxBurstLength) {
+				if (iscsit_dataout_update_r2t(cmd, hdr->offset,
+						payload_length) < 0)
+					return DATAOUT_CANNOT_RECOVER;
+				send_r2t = 1;
+			}
+
+			if (!conn->sess->sess_ops->DataPDUInOrder) {
+				ret = iscsit_dataout_update_datapduinorder_no(
+						cmd, hdr->datasn,
+						(hdr->flags & ISCSI_FLAG_CMD_FINAL));
+				if (ret == DATAOUT_CANNOT_RECOVER)
+					return ret;
+			}
+
+			cmd->next_burst_len += payload_length;
+			cmd->data_sn++;
+
+			if (send_r2t)
+				cmd->next_burst_len = 0;
+		} else {
+			seq = cmd->seq_ptr;
+
+			if ((seq->next_burst_len + payload_length) ==
+			     seq->xfer_len) {
+				if (iscsit_dataout_update_r2t(cmd, hdr->offset,
+						payload_length) < 0)
+					return DATAOUT_CANNOT_RECOVER;
+				send_r2t = 1;
+			}
+
+			if (!conn->sess->sess_ops->DataPDUInOrder) {
+				ret = iscsit_dataout_update_datapduinorder_no(
+						cmd, hdr->datasn,
+						(hdr->flags & ISCSI_FLAG_CMD_FINAL));
+				if (ret == DATAOUT_CANNOT_RECOVER)
+					return ret;
+			}
+
+			seq->data_sn++;
+			seq->offset += payload_length;
+			seq->next_burst_len += payload_length;
+
+			if (send_r2t) {
+				seq->next_burst_len = 0;
+				seq->status = DATAOUT_SEQUENCE_COMPLETE;
+			}
+		}
+	}
+
+	if (send_r2t && conn->sess->sess_ops->DataSequenceInOrder)
+		cmd->data_sn = 0;
+
+	cmd->write_data_done += payload_length;
+
+	return (cmd->write_data_done == cmd->data_length) ?
+		DATAOUT_SEND_TO_TRANSPORT : (send_r2t) ?
+		DATAOUT_SEND_R2T : DATAOUT_NORMAL;
+}
+
+static int iscsit_dataout_post_crc_failed(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_pdu *pdu;
+	struct iscsi_data *hdr = (struct iscsi_data *) buf;
+	u32 payload_length = ntoh24(hdr->dlength);
+
+	if (conn->sess->sess_ops->DataPDUInOrder)
+		goto recover;
+	/*
+	 * The rest of this function is only called when DataPDUInOrder=No.
+	 */
+	pdu = cmd->pdu_ptr;
+
+	switch (pdu->status) {
+	case ISCSI_PDU_NOT_RECEIVED:
+		pdu->status = ISCSI_PDU_CRC_FAILED;
+		break;
+	case ISCSI_PDU_CRC_FAILED:
+		break;
+	case ISCSI_PDU_TIMED_OUT:
+		pdu->status = ISCSI_PDU_CRC_FAILED;
+		break;
+	default:
+		return DATAOUT_CANNOT_RECOVER;
+	}
+
+recover:
+	return iscsit_recover_dataout_sequence(cmd, hdr->offset, payload_length);
+}
+
+/*
+ *	Called from iscsit_handle_data_out() before DataOUT Payload is received
+ *	and CRC computed.
+ */
+extern int iscsit_check_pre_dataout(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	int ret;
+	struct iscsi_conn *conn = cmd->conn;
+
+	ret = iscsit_dataout_within_command_recovery_check(cmd, buf);
+	if ((ret == DATAOUT_WITHIN_COMMAND_RECOVERY) ||
+	    (ret == DATAOUT_CANNOT_RECOVER))
+		return ret;
+
+	ret = iscsit_dataout_check_datasn(cmd, buf);
+	if ((ret == DATAOUT_WITHIN_COMMAND_RECOVERY) ||
+	    (ret == DATAOUT_CANNOT_RECOVER))
+		return ret;
+
+	if (cmd->unsolicited_data) {
+		ret = iscsit_dataout_check_unsolicited_sequence(cmd, buf);
+		if ((ret == DATAOUT_WITHIN_COMMAND_RECOVERY) ||
+		    (ret == DATAOUT_CANNOT_RECOVER))
+			return ret;
+	} else {
+		ret = iscsit_dataout_check_sequence(cmd, buf);
+		if ((ret == DATAOUT_WITHIN_COMMAND_RECOVERY) ||
+		    (ret == DATAOUT_CANNOT_RECOVER))
+			return ret;
+	}
+
+	return (conn->sess->sess_ops->DataPDUInOrder) ?
+		iscsit_dataout_pre_datapduinorder_yes(cmd, buf) :
+		iscsit_dataout_pre_datapduinorder_no(cmd, buf);
+}
+
+/*
+ *	Called from iscsit_handle_data_out() after DataOUT Payload is received
+ *	and CRC computed.
+ */
+int iscsit_check_post_dataout(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf,
+	u8 data_crc_failed)
+{
+	struct iscsi_conn *conn = cmd->conn;
+
+	cmd->dataout_timeout_retries = 0;
+
+	if (!data_crc_failed)
+		return iscsit_dataout_post_crc_passed(cmd, buf);
+	else {
+		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+			pr_err("Unable to recover from DataOUT CRC"
+				" failure while ERL=0, closing session.\n");
+			iscsit_add_reject_from_cmd(ISCSI_REASON_DATA_DIGEST_ERROR,
+					1, 0, buf, cmd);
+			return DATAOUT_CANNOT_RECOVER;
+		}
+
+		iscsit_add_reject_from_cmd(ISCSI_REASON_DATA_DIGEST_ERROR,
+				0, 0, buf, cmd);
+		return iscsit_dataout_post_crc_failed(cmd, buf);
+	}
+}
+
+static void iscsit_handle_time2retain_timeout(unsigned long data)
+{
+	struct iscsi_session *sess = (struct iscsi_session *) data;
+	struct iscsi_portal_group *tpg = ISCSI_TPG_S(sess);
+	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
+
+	spin_lock_bh(&se_tpg->session_lock);
+	if (sess->time2retain_timer_flags & ISCSI_TF_STOP) {
+		spin_unlock_bh(&se_tpg->session_lock);
+		return;
+	}
+	if (atomic_read(&sess->session_reinstatement)) {
+		pr_err("Exiting Time2Retain handler because"
+				" session_reinstatement=1\n");
+		spin_unlock_bh(&se_tpg->session_lock);
+		return;
+	}
+	sess->time2retain_timer_flags |= ISCSI_TF_EXPIRED;
+
+	pr_err("Time2Retain timer expired for SID: %u, cleaning up"
+			" iSCSI session.\n", sess->sid);
+	{
+	struct iscsi_tiqn *tiqn = tpg->tpg_tiqn;
+
+	if (tiqn) {
+		spin_lock(&tiqn->sess_err_stats.lock);
+		strcpy(tiqn->sess_err_stats.last_sess_fail_rem_name,
+			(void *)sess->sess_ops->InitiatorName);
+		tiqn->sess_err_stats.last_sess_failure_type =
+				ISCSI_SESS_ERR_CXN_TIMEOUT;
+		tiqn->sess_err_stats.cxn_timeout_errors++;
+		sess->conn_timeout_errors++;
+		spin_unlock(&tiqn->sess_err_stats.lock);
+	}
+	}
+
+	spin_unlock_bh(&se_tpg->session_lock);
+	iscsit_close_session(sess);
+}
+
+extern void iscsit_start_time2retain_handler(struct iscsi_session *sess)
+{
+	int tpg_active;
+	/*
+	 * Only start Time2Retain timer when the assoicated TPG is still in
+	 * an ACTIVE (eg: not disabled or shutdown) state.
+	 */
+	spin_lock(&ISCSI_TPG_S(sess)->tpg_state_lock);
+	tpg_active = (ISCSI_TPG_S(sess)->tpg_state == TPG_STATE_ACTIVE);
+	spin_unlock(&ISCSI_TPG_S(sess)->tpg_state_lock);
+
+	if (!tpg_active)
+		return;
+
+	if (sess->time2retain_timer_flags & ISCSI_TF_RUNNING)
+		return;
+
+	pr_debug("Starting Time2Retain timer for %u seconds on"
+		" SID: %u\n", sess->sess_ops->DefaultTime2Retain, sess->sid);
+
+	init_timer(&sess->time2retain_timer);
+	sess->time2retain_timer.expires =
+		(get_jiffies_64() + sess->sess_ops->DefaultTime2Retain * HZ);
+	sess->time2retain_timer.data = (unsigned long)sess;
+	sess->time2retain_timer.function = iscsit_handle_time2retain_timeout;
+	sess->time2retain_timer_flags &= ~ISCSI_TF_STOP;
+	sess->time2retain_timer_flags |= ISCSI_TF_RUNNING;
+	add_timer(&sess->time2retain_timer);
+}
+
+/*
+ *	Called with spin_lock_bh(&struct se_portal_group->session_lock) held
+ */
+extern int iscsit_stop_time2retain_timer(struct iscsi_session *sess)
+{
+	struct iscsi_portal_group *tpg = ISCSI_TPG_S(sess);
+	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
+
+	if (sess->time2retain_timer_flags & ISCSI_TF_EXPIRED)
+		return -1;
+
+	if (!(sess->time2retain_timer_flags & ISCSI_TF_RUNNING))
+		return 0;
+
+	sess->time2retain_timer_flags |= ISCSI_TF_STOP;
+	spin_unlock_bh(&se_tpg->session_lock);
+
+	del_timer_sync(&sess->time2retain_timer);
+
+	spin_lock_bh(&se_tpg->session_lock);
+	sess->time2retain_timer_flags &= ~ISCSI_TF_RUNNING;
+	pr_debug("Stopped Time2Retain Timer for SID: %u\n",
+			sess->sid);
+	return 0;
+}
+
+void iscsit_connection_reinstatement_rcfr(struct iscsi_conn *conn)
+{
+	spin_lock_bh(&conn->state_lock);
+	if (atomic_read(&conn->connection_exit)) {
+		spin_unlock_bh(&conn->state_lock);
+		goto sleep;
+	}
+
+	if (atomic_read(&conn->transport_failed)) {
+		spin_unlock_bh(&conn->state_lock);
+		goto sleep;
+	}
+	spin_unlock_bh(&conn->state_lock);
+
+	iscsi_thread_set_force_reinstatement(conn);
+
+sleep:
+	wait_for_completion(&conn->conn_wait_rcfr_comp);
+	complete(&conn->conn_post_wait_comp);
+}
+
+void iscsit_cause_connection_reinstatement(struct iscsi_conn *conn, int sleep)
+{
+	spin_lock_bh(&conn->state_lock);
+	if (atomic_read(&conn->connection_exit)) {
+		spin_unlock_bh(&conn->state_lock);
+		return;
+	}
+
+	if (atomic_read(&conn->transport_failed)) {
+		spin_unlock_bh(&conn->state_lock);
+		return;
+	}
+
+	if (atomic_read(&conn->connection_reinstatement)) {
+		spin_unlock_bh(&conn->state_lock);
+		return;
+	}
+
+	if (iscsi_thread_set_force_reinstatement(conn) < 0) {
+		spin_unlock_bh(&conn->state_lock);
+		return;
+	}
+
+	atomic_set(&conn->connection_reinstatement, 1);
+	if (!sleep) {
+		spin_unlock_bh(&conn->state_lock);
+		return;
+	}
+
+	atomic_set(&conn->sleep_on_conn_wait_comp, 1);
+	spin_unlock_bh(&conn->state_lock);
+
+	wait_for_completion(&conn->conn_wait_comp);
+	complete(&conn->conn_post_wait_comp);
+}
+
+void iscsit_fall_back_to_erl0(struct iscsi_session *sess)
+{
+	pr_debug("Falling back to ErrorRecoveryLevel=0 for SID:"
+			" %u\n", sess->sid);
+
+	atomic_set(&sess->session_fall_back_to_erl0, 1);
+}
+
+static void iscsit_handle_connection_cleanup(struct iscsi_conn *conn)
+{
+	struct iscsi_session *sess = conn->sess;
+
+	if ((sess->sess_ops->ErrorRecoveryLevel == 2) &&
+	    !atomic_read(&sess->session_reinstatement) &&
+	    !atomic_read(&sess->session_fall_back_to_erl0))
+		iscsit_connection_recovery_transport_reset(conn);
+	else {
+		pr_debug("Performing cleanup for failed iSCSI"
+			" Connection ID: %hu from %s\n", conn->cid,
+			sess->sess_ops->InitiatorName);
+		iscsit_close_connection(conn);
+	}
+}
+
+extern void iscsit_take_action_for_connection_exit(struct iscsi_conn *conn)
+{
+	spin_lock_bh(&conn->state_lock);
+	if (atomic_read(&conn->connection_exit)) {
+		spin_unlock_bh(&conn->state_lock);
+		return;
+	}
+	atomic_set(&conn->connection_exit, 1);
+
+	if (conn->conn_state == TARG_CONN_STATE_IN_LOGOUT) {
+		spin_unlock_bh(&conn->state_lock);
+		iscsit_close_connection(conn);
+		return;
+	}
+
+	if (conn->conn_state == TARG_CONN_STATE_CLEANUP_WAIT) {
+		spin_unlock_bh(&conn->state_lock);
+		return;
+	}
+
+	pr_debug("Moving to TARG_CONN_STATE_CLEANUP_WAIT.\n");
+	conn->conn_state = TARG_CONN_STATE_CLEANUP_WAIT;
+	spin_unlock_bh(&conn->state_lock);
+
+	iscsit_handle_connection_cleanup(conn);
+}
+
+/*
+ *	This is the simple function that makes the magic of
+ *	sync and steering happen in the follow paradoxical order:
+ *
+ *	0) Receive conn->of_marker (bytes left until next OFMarker)
+ *	   bytes into an offload buffer.  When we pass the exact number
+ *	   of bytes in conn->of_marker, iscsit_dump_data_payload() and hence
+ *	   rx_data() will automatically receive the identical u32 marker
+ *	   values and store it in conn->of_marker_offset;
+ *	1) Now conn->of_marker_offset will contain the offset to the start
+ *	   of the next iSCSI PDU.  Dump these remaining bytes into another
+ *	   offload buffer.
+ *	2) We are done!
+ *	   Next byte in the TCP stream will contain the next iSCSI PDU!
+ *	   Cool Huh?!
+ */
+int iscsit_recover_from_unknown_opcode(struct iscsi_conn *conn)
+{
+	/*
+	 * Make sure the remaining bytes to next maker is a sane value.
+	 */
+	if (conn->of_marker > (conn->conn_ops->OFMarkInt * 4)) {
+		pr_err("Remaining bytes to OFMarker: %u exceeds"
+			" OFMarkInt bytes: %u.\n", conn->of_marker,
+				conn->conn_ops->OFMarkInt * 4);
+		return -1;
+	}
+
+	pr_debug("Advancing %u bytes in TCP stream to get to the"
+			" next OFMarker.\n", conn->of_marker);
+
+	if (iscsit_dump_data_payload(conn, conn->of_marker, 0) < 0)
+		return -1;
+
+	/*
+	 * Make sure the offset marker we retrived is a valid value.
+	 */
+	if (conn->of_marker_offset > (ISCSI_HDR_LEN + (ISCSI_CRC_LEN * 2) +
+	    conn->conn_ops->MaxRecvDataSegmentLength)) {
+		pr_err("OfMarker offset value: %u exceeds limit.\n",
+			conn->of_marker_offset);
+		return -1;
+	}
+
+	pr_debug("Discarding %u bytes of TCP stream to get to the"
+			" next iSCSI Opcode.\n", conn->of_marker_offset);
+
+	if (iscsit_dump_data_payload(conn, conn->of_marker_offset, 0) < 0)
+		return -1;
+
+	return 0;
+}
diff --git a/drivers/target/iscsi/iscsi_target_erl0.h b/drivers/target/iscsi/iscsi_target_erl0.h
new file mode 100644
index 0000000..21acc9a
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_erl0.h
@@ -0,0 +1,15 @@
+#ifndef ISCSI_TARGET_ERL0_H
+#define ISCSI_TARGET_ERL0_H
+
+extern void iscsit_set_dataout_sequence_values(struct iscsi_cmd *);
+extern int iscsit_check_pre_dataout(struct iscsi_cmd *, unsigned char *);
+extern int iscsit_check_post_dataout(struct iscsi_cmd *, unsigned char *, u8);
+extern void iscsit_start_time2retain_handler(struct iscsi_session *);
+extern int iscsit_stop_time2retain_timer(struct iscsi_session *);
+extern void iscsit_connection_reinstatement_rcfr(struct iscsi_conn *);
+extern void iscsit_cause_connection_reinstatement(struct iscsi_conn *, int);
+extern void iscsit_fall_back_to_erl0(struct iscsi_session *);
+extern void iscsit_take_action_for_connection_exit(struct iscsi_conn *);
+extern int iscsit_recover_from_unknown_opcode(struct iscsi_conn *);
+
+#endif   /*** ISCSI_TARGET_ERL0_H ***/
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
new file mode 100644
index 0000000..9806507
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -0,0 +1,1299 @@
+/*******************************************************************************
+ * This file contains error recovery level one used by the iSCSI Target driver.
+ *
+ * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ ******************************************************************************/
+
+#include <linux/list.h>
+#include <scsi/iscsi_proto.h>
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+
+#include "iscsi_target_core.h"
+#include "iscsi_target_seq_pdu_list.h"
+#include "iscsi_target_datain_values.h"
+#include "iscsi_target_device.h"
+#include "iscsi_target_tpg.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target_erl0.h"
+#include "iscsi_target_erl1.h"
+#include "iscsi_target_erl2.h"
+#include "iscsi_target.h"
+
+#define OFFLOAD_BUF_SIZE	32768
+
+/*
+ *	Used to dump excess datain payload for certain error recovery
+ *	situations.  Receive in OFFLOAD_BUF_SIZE max of datain per rx_data().
+ *
+ *	dump_padding_digest denotes if padding and data digests need
+ *	to be dumped.
+ */
+int iscsit_dump_data_payload(
+	struct iscsi_conn *conn,
+	u32 buf_len,
+	int dump_padding_digest)
+{
+	char *buf, pad_bytes[4];
+	int ret = DATAOUT_WITHIN_COMMAND_RECOVERY, rx_got;
+	u32 length, padding, offset = 0, size;
+	struct kvec iov;
+
+	length = (buf_len > OFFLOAD_BUF_SIZE) ? OFFLOAD_BUF_SIZE : buf_len;
+
+	buf = kzalloc(length, GFP_ATOMIC);
+	if (!buf) {
+		pr_err("Unable to allocate %u bytes for offload"
+				" buffer.\n", length);
+		return -1;
+	}
+	memset(&iov, 0, sizeof(struct kvec));
+
+	while (offset < buf_len) {
+		size = ((offset + length) > buf_len) ?
+			(buf_len - offset) : length;
+
+		iov.iov_len = size;
+		iov.iov_base = buf;
+
+		rx_got = rx_data(conn, &iov, 1, size);
+		if (rx_got != size) {
+			ret = DATAOUT_CANNOT_RECOVER;
+			goto out;
+		}
+
+		offset += size;
+	}
+
+	if (!dump_padding_digest)
+		goto out;
+
+	padding = ((-buf_len) & 3);
+	if (padding != 0) {
+		iov.iov_len = padding;
+		iov.iov_base = pad_bytes;
+
+		rx_got = rx_data(conn, &iov, 1, padding);
+		if (rx_got != padding) {
+			ret = DATAOUT_CANNOT_RECOVER;
+			goto out;
+		}
+	}
+
+	if (conn->conn_ops->DataDigest) {
+		u32 data_crc;
+
+		iov.iov_len = ISCSI_CRC_LEN;
+		iov.iov_base = &data_crc;
+
+		rx_got = rx_data(conn, &iov, 1, ISCSI_CRC_LEN);
+		if (rx_got != ISCSI_CRC_LEN) {
+			ret = DATAOUT_CANNOT_RECOVER;
+			goto out;
+		}
+	}
+
+out:
+	kfree(buf);
+	return ret;
+}
+
+/*
+ *	Used for retransmitting R2Ts from a R2T SNACK request.
+ */
+static int iscsit_send_recovery_r2t_for_snack(
+	struct iscsi_cmd *cmd,
+	struct iscsi_r2t *r2t)
+{
+	/*
+	 * If the struct iscsi_r2t has not been sent yet, we can safely
+	 * ignore retransmission
+	 * of the R2TSN in question.
+	 */
+	spin_lock_bh(&cmd->r2t_lock);
+	if (!r2t->sent_r2t) {
+		spin_unlock_bh(&cmd->r2t_lock);
+		return 0;
+	}
+	r2t->sent_r2t = 0;
+	spin_unlock_bh(&cmd->r2t_lock);
+
+	iscsit_add_cmd_to_immediate_queue(cmd, cmd->conn, ISTATE_SEND_R2T);
+
+	return 0;
+}
+
+static int iscsit_handle_r2t_snack(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf,
+	u32 begrun,
+	u32 runlength)
+{
+	u32 last_r2tsn;
+	struct iscsi_r2t *r2t;
+
+	/*
+	 * Make sure the initiator is not requesting retransmission
+	 * of R2TSNs already acknowledged by a TMR TASK_REASSIGN.
+	 */
+	if ((cmd->cmd_flags & ICF_GOT_DATACK_SNACK) &&
+	    (begrun <= cmd->acked_data_sn)) {
+		pr_err("ITT: 0x%08x, R2T SNACK requesting"
+			" retransmission of R2TSN: 0x%08x to 0x%08x but already"
+			" acked to  R2TSN: 0x%08x by TMR TASK_REASSIGN,"
+			" protocol error.\n", cmd->init_task_tag, begrun,
+			(begrun + runlength), cmd->acked_data_sn);
+
+			return iscsit_add_reject_from_cmd(
+					ISCSI_REASON_PROTOCOL_ERROR,
+					1, 0, buf, cmd);
+	}
+
+	if (runlength) {
+		if ((begrun + runlength) > cmd->r2t_sn) {
+			pr_err("Command ITT: 0x%08x received R2T SNACK"
+			" with BegRun: 0x%08x, RunLength: 0x%08x, exceeds"
+			" current R2TSN: 0x%08x, protocol error.\n",
+			cmd->init_task_tag, begrun, runlength, cmd->r2t_sn);
+			return iscsit_add_reject_from_cmd(
+				ISCSI_REASON_BOOKMARK_INVALID, 1, 0, buf, cmd);
+		}
+		last_r2tsn = (begrun + runlength);
+	} else
+		last_r2tsn = cmd->r2t_sn;
+
+	while (begrun < last_r2tsn) {
+		r2t = iscsit_get_holder_for_r2tsn(cmd, begrun);
+		if (!r2t)
+			return -1;
+		if (iscsit_send_recovery_r2t_for_snack(cmd, r2t) < 0)
+			return -1;
+
+		begrun++;
+	}
+
+	return 0;
+}
+
+/*
+ *	Generates Offsets and NextBurstLength based on Begrun and Runlength
+ *	carried in a Data SNACK or ExpDataSN in TMR TASK_REASSIGN.
+ *
+ *	For DataSequenceInOrder=Yes and DataPDUInOrder=[Yes,No] only.
+ *
+ *	FIXME: How is this handled for a RData SNACK?
+ */
+int iscsit_create_recovery_datain_values_datasequenceinorder_yes(
+	struct iscsi_cmd *cmd,
+	struct iscsi_datain_req *dr)
+{
+	u32 data_sn = 0, data_sn_count = 0;
+	u32 pdu_start = 0, seq_no = 0;
+	u32 begrun = dr->begrun;
+	struct iscsi_conn *conn = cmd->conn;
+
+	while (begrun > data_sn++) {
+		data_sn_count++;
+		if ((dr->next_burst_len +
+		     conn->conn_ops->MaxRecvDataSegmentLength) <
+		     conn->sess->sess_ops->MaxBurstLength) {
+			dr->read_data_done +=
+				conn->conn_ops->MaxRecvDataSegmentLength;
+			dr->next_burst_len +=
+				conn->conn_ops->MaxRecvDataSegmentLength;
+		} else {
+			dr->read_data_done +=
+				(conn->sess->sess_ops->MaxBurstLength -
+				 dr->next_burst_len);
+			dr->next_burst_len = 0;
+			pdu_start += data_sn_count;
+			data_sn_count = 0;
+			seq_no++;
+		}
+	}
+
+	if (!conn->sess->sess_ops->DataPDUInOrder) {
+		cmd->seq_no = seq_no;
+		cmd->pdu_start = pdu_start;
+		cmd->pdu_send_order = data_sn_count;
+	}
+
+	return 0;
+}
+
+/*
+ *	Generates Offsets and NextBurstLength based on Begrun and Runlength
+ *	carried in a Data SNACK or ExpDataSN in TMR TASK_REASSIGN.
+ *
+ *	For DataSequenceInOrder=No and DataPDUInOrder=[Yes,No] only.
+ *
+ *	FIXME: How is this handled for a RData SNACK?
+ */
+int iscsit_create_recovery_datain_values_datasequenceinorder_no(
+	struct iscsi_cmd *cmd,
+	struct iscsi_datain_req *dr)
+{
+	int found_seq = 0, i;
+	u32 data_sn, read_data_done = 0, seq_send_order = 0;
+	u32 begrun = dr->begrun;
+	u32 runlength = dr->runlength;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_seq *first_seq = NULL, *seq = NULL;
+
+	if (!cmd->seq_list) {
+		pr_err("struct iscsi_cmd->seq_list is NULL!\n");
+		return -1;
+	}
+
+	/*
+	 * Calculate read_data_done for all sequences containing a
+	 * first_datasn and last_datasn less than the BegRun.
+	 *
+	 * Locate the struct iscsi_seq the BegRun lies within and calculate
+	 * NextBurstLenghth up to the DataSN based on MaxRecvDataSegmentLength.
+	 *
+	 * Also use struct iscsi_seq->seq_send_order to determine where to start.
+	 */
+	for (i = 0; i < cmd->seq_count; i++) {
+		seq = &cmd->seq_list[i];
+
+		if (!seq->seq_send_order)
+			first_seq = seq;
+
+		/*
+		 * No data has been transferred for this DataIN sequence, so the
+		 * seq->first_datasn and seq->last_datasn have not been set.
+		 */
+		if (!seq->sent) {
+#if 0
+			pr_err("Ignoring non-sent sequence 0x%08x ->"
+				" 0x%08x\n\n", seq->first_datasn,
+				seq->last_datasn);
+#endif
+			continue;
+		}
+
+		/*
+		 * This DataIN sequence is precedes the received BegRun, add the
+		 * total xfer_len of the sequence to read_data_done and reset
+		 * seq->pdu_send_order.
+		 */
+		if ((seq->first_datasn < begrun) &&
+				(seq->last_datasn < begrun)) {
+#if 0
+			pr_err("Pre BegRun sequence 0x%08x ->"
+				" 0x%08x\n", seq->first_datasn,
+				seq->last_datasn);
+#endif
+			read_data_done += cmd->seq_list[i].xfer_len;
+			seq->next_burst_len = seq->pdu_send_order = 0;
+			continue;
+		}
+
+		/*
+		 * The BegRun lies within this DataIN sequence.
+		 */
+		if ((seq->first_datasn <= begrun) &&
+				(seq->last_datasn >= begrun)) {
+#if 0
+			pr_err("Found sequence begrun: 0x%08x in"
+				" 0x%08x -> 0x%08x\n", begrun,
+				seq->first_datasn, seq->last_datasn);
+#endif
+			seq_send_order = seq->seq_send_order;
+			data_sn = seq->first_datasn;
+			seq->next_burst_len = seq->pdu_send_order = 0;
+			found_seq = 1;
+
+			/*
+			 * For DataPDUInOrder=Yes, while the first DataSN of
+			 * the sequence is less than the received BegRun, add
+			 * the MaxRecvDataSegmentLength to read_data_done and
+			 * to the sequence's next_burst_len;
+			 *
+			 * For DataPDUInOrder=No, while the first DataSN of the
+			 * sequence is less than the received BegRun, find the
+			 * struct iscsi_pdu of the DataSN in question and add the
+			 * MaxRecvDataSegmentLength to read_data_done and to the
+			 * sequence's next_burst_len;
+			 */
+			if (conn->sess->sess_ops->DataPDUInOrder) {
+				while (data_sn < begrun) {
+					seq->pdu_send_order++;
+					read_data_done +=
+						conn->conn_ops->MaxRecvDataSegmentLength;
+					seq->next_burst_len +=
+						conn->conn_ops->MaxRecvDataSegmentLength;
+					data_sn++;
+				}
+			} else {
+				int j;
+				struct iscsi_pdu *pdu;
+
+				while (data_sn < begrun) {
+					seq->pdu_send_order++;
+
+					for (j = 0; j < seq->pdu_count; j++) {
+						pdu = &cmd->pdu_list[
+							seq->pdu_start + j];
+						if (pdu->data_sn == data_sn) {
+							read_data_done +=
+								pdu->length;
+							seq->next_burst_len +=
+								pdu->length;
+						}
+					}
+					data_sn++;
+				}
+			}
+			continue;
+		}
+
+		/*
+		 * This DataIN sequence is larger than the received BegRun,
+		 * reset seq->pdu_send_order and continue.
+		 */
+		if ((seq->first_datasn > begrun) ||
+				(seq->last_datasn > begrun)) {
+#if 0
+			pr_err("Post BegRun sequence 0x%08x -> 0x%08x\n",
+					seq->first_datasn, seq->last_datasn);
+#endif
+			seq->next_burst_len = seq->pdu_send_order = 0;
+			continue;
+		}
+	}
+
+	if (!found_seq) {
+		if (!begrun) {
+			if (!first_seq) {
+				pr_err("ITT: 0x%08x, Begrun: 0x%08x"
+					" but first_seq is NULL\n",
+					cmd->init_task_tag, begrun);
+				return -1;
+			}
+			seq_send_order = first_seq->seq_send_order;
+			seq->next_burst_len = seq->pdu_send_order = 0;
+			goto done;
+		}
+
+		pr_err("Unable to locate struct iscsi_seq for ITT: 0x%08x,"
+			" BegRun: 0x%08x, RunLength: 0x%08x while"
+			" DataSequenceInOrder=No and DataPDUInOrder=%s.\n",
+				cmd->init_task_tag, begrun, runlength,
+			(conn->sess->sess_ops->DataPDUInOrder) ? "Yes" : "No");
+		return -1;
+	}
+
+done:
+	dr->read_data_done = read_data_done;
+	dr->seq_send_order = seq_send_order;
+
+	return 0;
+}
+
+static int iscsit_handle_recovery_datain(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf,
+	u32 begrun,
+	u32 runlength)
+{
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_datain_req *dr;
+	struct se_cmd *se_cmd = &cmd->se_cmd;
+
+	if (!atomic_read(&se_cmd->t_transport_complete)) {
+		pr_err("Ignoring ITT: 0x%08x Data SNACK\n",
+				cmd->init_task_tag);
+		return 0;
+	}
+
+	/*
+	 * Make sure the initiator is not requesting retransmission
+	 * of DataSNs already acknowledged by a Data ACK SNACK.
+	 */
+	if ((cmd->cmd_flags & ICF_GOT_DATACK_SNACK) &&
+	    (begrun <= cmd->acked_data_sn)) {
+		pr_err("ITT: 0x%08x, Data SNACK requesting"
+			" retransmission of DataSN: 0x%08x to 0x%08x but"
+			" already acked to DataSN: 0x%08x by Data ACK SNACK,"
+			" protocol error.\n", cmd->init_task_tag, begrun,
+			(begrun + runlength), cmd->acked_data_sn);
+
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
+				1, 0, buf, cmd);
+	}
+
+	/*
+	 * Make sure BegRun and RunLength in the Data SNACK are sane.
+	 * Note: (cmd->data_sn - 1) will carry the maximum DataSN sent.
+	 */
+	if ((begrun + runlength) > (cmd->data_sn - 1)) {
+		pr_err("Initiator requesting BegRun: 0x%08x, RunLength"
+			": 0x%08x greater than maximum DataSN: 0x%08x.\n",
+				begrun, runlength, (cmd->data_sn - 1));
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
+				1, 0, buf, cmd);
+	}
+
+	dr = iscsit_allocate_datain_req();
+	if (!dr)
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+				1, 0, buf, cmd);
+
+	dr->data_sn = dr->begrun = begrun;
+	dr->runlength = runlength;
+	dr->generate_recovery_values = 1;
+	dr->recovery = DATAIN_WITHIN_COMMAND_RECOVERY;
+
+	iscsit_attach_datain_req(cmd, dr);
+
+	cmd->i_state = ISTATE_SEND_DATAIN;
+	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+
+	return 0;
+}
+
+int iscsit_handle_recovery_datain_or_r2t(
+	struct iscsi_conn *conn,
+	unsigned char *buf,
+	u32 init_task_tag,
+	u32 targ_xfer_tag,
+	u32 begrun,
+	u32 runlength)
+{
+	struct iscsi_cmd *cmd;
+
+	cmd = iscsit_find_cmd_from_itt(conn, init_task_tag);
+	if (!cmd)
+		return 0;
+
+	/*
+	 * FIXME: This will not work for bidi commands.
+	 */
+	switch (cmd->data_direction) {
+	case DMA_TO_DEVICE:
+		return iscsit_handle_r2t_snack(cmd, buf, begrun, runlength);
+	case DMA_FROM_DEVICE:
+		return iscsit_handle_recovery_datain(cmd, buf, begrun,
+				runlength);
+	default:
+		pr_err("Unknown cmd->data_direction: 0x%02x\n",
+				cmd->data_direction);
+		return -1;
+	}
+
+	return 0;
+}
+
+/* #warning FIXME: Status SNACK needs to be dependent on OPCODE!!! */
+int iscsit_handle_status_snack(
+	struct iscsi_conn *conn,
+	u32 init_task_tag,
+	u32 targ_xfer_tag,
+	u32 begrun,
+	u32 runlength)
+{
+	struct iscsi_cmd *cmd = NULL;
+	u32 last_statsn;
+	int found_cmd;
+
+	if (conn->exp_statsn > begrun) {
+		pr_err("Got Status SNACK Begrun: 0x%08x, RunLength:"
+			" 0x%08x but already got ExpStatSN: 0x%08x on CID:"
+			" %hu.\n", begrun, runlength, conn->exp_statsn,
+			conn->cid);
+		return 0;
+	}
+
+	last_statsn = (!runlength) ? conn->stat_sn : (begrun + runlength);
+
+	while (begrun < last_statsn) {
+		found_cmd = 0;
+
+		spin_lock_bh(&conn->cmd_lock);
+		list_for_each_entry(cmd, &conn->conn_cmd_list, i_list) {
+			if (cmd->stat_sn == begrun) {
+				found_cmd = 1;
+				break;
+			}
+		}
+		spin_unlock_bh(&conn->cmd_lock);
+
+		if (!found_cmd) {
+			pr_err("Unable to find StatSN: 0x%08x for"
+				" a Status SNACK, assuming this was a"
+				" protactic SNACK for an untransmitted"
+				" StatSN, ignoring.\n", begrun);
+			begrun++;
+			continue;
+		}
+
+		spin_lock_bh(&cmd->istate_lock);
+		if (cmd->i_state == ISTATE_SEND_DATAIN) {
+			spin_unlock_bh(&cmd->istate_lock);
+			pr_err("Ignoring Status SNACK for BegRun:"
+				" 0x%08x, RunLength: 0x%08x, assuming this was"
+				" a protactic SNACK for an untransmitted"
+				" StatSN\n", begrun, runlength);
+			begrun++;
+			continue;
+		}
+		spin_unlock_bh(&cmd->istate_lock);
+
+		cmd->i_state = ISTATE_SEND_STATUS_RECOVERY;
+		iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+		begrun++;
+	}
+
+	return 0;
+}
+
+int iscsit_handle_data_ack(
+	struct iscsi_conn *conn,
+	u32 targ_xfer_tag,
+	u32 begrun,
+	u32 runlength)
+{
+	struct iscsi_cmd *cmd = NULL;
+
+	cmd = iscsit_find_cmd_from_ttt(conn, targ_xfer_tag);
+	if (!cmd) {
+		pr_err("Data ACK SNACK for TTT: 0x%08x is"
+			" invalid.\n", targ_xfer_tag);
+		return -1;
+	}
+
+	if (begrun <= cmd->acked_data_sn) {
+		pr_err("ITT: 0x%08x Data ACK SNACK BegRUN: 0x%08x is"
+			" less than the already acked DataSN: 0x%08x.\n",
+			cmd->init_task_tag, begrun, cmd->acked_data_sn);
+		return -1;
+	}
+
+	/*
+	 * For Data ACK SNACK, BegRun is the next expected DataSN.
+	 * (see iSCSI v19: 10.16.6)
+	 */
+	cmd->cmd_flags |= ICF_GOT_DATACK_SNACK;
+	cmd->acked_data_sn = (begrun - 1);
+
+	pr_debug("Received Data ACK SNACK for ITT: 0x%08x,"
+		" updated acked DataSN to 0x%08x.\n",
+			cmd->init_task_tag, cmd->acked_data_sn);
+
+	return 0;
+}
+
+static int iscsit_send_recovery_r2t(
+	struct iscsi_cmd *cmd,
+	u32 offset,
+	u32 xfer_len)
+{
+	int ret;
+
+	spin_lock_bh(&cmd->r2t_lock);
+	ret = iscsit_add_r2t_to_list(cmd, offset, xfer_len, 1, 0);
+	spin_unlock_bh(&cmd->r2t_lock);
+
+	return ret;
+}
+
+int iscsit_dataout_datapduinorder_no_fbit(
+	struct iscsi_cmd *cmd,
+	struct iscsi_pdu *pdu)
+{
+	int i, send_recovery_r2t = 0, recovery = 0;
+	u32 length = 0, offset = 0, pdu_count = 0, xfer_len = 0;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_pdu *first_pdu = NULL;
+
+	/*
+	 * Get an struct iscsi_pdu pointer to the first PDU, and total PDU count
+	 * of the DataOUT sequence.
+	 */
+	if (conn->sess->sess_ops->DataSequenceInOrder) {
+		for (i = 0; i < cmd->pdu_count; i++) {
+			if (cmd->pdu_list[i].seq_no == pdu->seq_no) {
+				if (!first_pdu)
+					first_pdu = &cmd->pdu_list[i];
+				 xfer_len += cmd->pdu_list[i].length;
+				 pdu_count++;
+			} else if (pdu_count)
+				break;
+		}
+	} else {
+		struct iscsi_seq *seq = cmd->seq_ptr;
+
+		first_pdu = &cmd->pdu_list[seq->pdu_start];
+		pdu_count = seq->pdu_count;
+	}
+
+	if (!first_pdu || !pdu_count)
+		return DATAOUT_CANNOT_RECOVER;
+
+	/*
+	 * Loop through the ending DataOUT Sequence checking each struct iscsi_pdu.
+	 * The following ugly logic does batching of not received PDUs.
+	 */
+	for (i = 0; i < pdu_count; i++) {
+		if (first_pdu[i].status == ISCSI_PDU_RECEIVED_OK) {
+			if (!send_recovery_r2t)
+				continue;
+
+			if (iscsit_send_recovery_r2t(cmd, offset, length) < 0)
+				return DATAOUT_CANNOT_RECOVER;
+
+			send_recovery_r2t = length = offset = 0;
+			continue;
+		}
+		/*
+		 * Set recovery = 1 for any missing, CRC failed, or timed
+		 * out PDUs to let the DataOUT logic know that this sequence
+		 * has not been completed yet.
+		 *
+		 * Also, only send a Recovery R2T for ISCSI_PDU_NOT_RECEIVED.
+		 * We assume if the PDU either failed CRC or timed out
+		 * that a Recovery R2T has already been sent.
+		 */
+		recovery = 1;
+
+		if (first_pdu[i].status != ISCSI_PDU_NOT_RECEIVED)
+			continue;
+
+		if (!offset)
+			offset = first_pdu[i].offset;
+		length += first_pdu[i].length;
+
+		send_recovery_r2t = 1;
+	}
+
+	if (send_recovery_r2t)
+		if (iscsit_send_recovery_r2t(cmd, offset, length) < 0)
+			return DATAOUT_CANNOT_RECOVER;
+
+	return (!recovery) ? DATAOUT_NORMAL : DATAOUT_WITHIN_COMMAND_RECOVERY;
+}
+
+static int iscsit_recalculate_dataout_values(
+	struct iscsi_cmd *cmd,
+	u32 pdu_offset,
+	u32 pdu_length,
+	u32 *r2t_offset,
+	u32 *r2t_length)
+{
+	int i;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_pdu *pdu = NULL;
+
+	if (conn->sess->sess_ops->DataSequenceInOrder) {
+		cmd->data_sn = 0;
+
+		if (conn->sess->sess_ops->DataPDUInOrder) {
+			*r2t_offset = cmd->write_data_done;
+			*r2t_length = (cmd->seq_end_offset -
+					cmd->write_data_done);
+			return 0;
+		}
+
+		*r2t_offset = cmd->seq_start_offset;
+		*r2t_length = (cmd->seq_end_offset - cmd->seq_start_offset);
+
+		for (i = 0; i < cmd->pdu_count; i++) {
+			pdu = &cmd->pdu_list[i];
+
+			if (pdu->status != ISCSI_PDU_RECEIVED_OK)
+				continue;
+
+			if ((pdu->offset >= cmd->seq_start_offset) &&
+			   ((pdu->offset + pdu->length) <=
+			     cmd->seq_end_offset)) {
+				if (!cmd->unsolicited_data)
+					cmd->next_burst_len -= pdu->length;
+				else
+					cmd->first_burst_len -= pdu->length;
+
+				cmd->write_data_done -= pdu->length;
+				pdu->status = ISCSI_PDU_NOT_RECEIVED;
+			}
+		}
+	} else {
+		struct iscsi_seq *seq = NULL;
+
+		seq = iscsit_get_seq_holder(cmd, pdu_offset, pdu_length);
+		if (!seq)
+			return -1;
+
+		*r2t_offset = seq->orig_offset;
+		*r2t_length = seq->xfer_len;
+
+		cmd->write_data_done -= (seq->offset - seq->orig_offset);
+		if (cmd->immediate_data)
+			cmd->first_burst_len = cmd->write_data_done;
+
+		seq->data_sn = 0;
+		seq->offset = seq->orig_offset;
+		seq->next_burst_len = 0;
+		seq->status = DATAOUT_SEQUENCE_WITHIN_COMMAND_RECOVERY;
+
+		if (conn->sess->sess_ops->DataPDUInOrder)
+			return 0;
+
+		for (i = 0; i < seq->pdu_count; i++) {
+			pdu = &cmd->pdu_list[i+seq->pdu_start];
+
+			if (pdu->status != ISCSI_PDU_RECEIVED_OK)
+				continue;
+
+			pdu->status = ISCSI_PDU_NOT_RECEIVED;
+		}
+	}
+
+	return 0;
+}
+
+int iscsit_recover_dataout_sequence(
+	struct iscsi_cmd *cmd,
+	u32 pdu_offset,
+	u32 pdu_length)
+{
+	u32 r2t_length = 0, r2t_offset = 0;
+
+	spin_lock_bh(&cmd->istate_lock);
+	cmd->cmd_flags |= ICF_WITHIN_COMMAND_RECOVERY;
+	spin_unlock_bh(&cmd->istate_lock);
+
+	if (iscsit_recalculate_dataout_values(cmd, pdu_offset, pdu_length,
+			&r2t_offset, &r2t_length) < 0)
+		return DATAOUT_CANNOT_RECOVER;
+
+	iscsit_send_recovery_r2t(cmd, r2t_offset, r2t_length);
+
+	return DATAOUT_WITHIN_COMMAND_RECOVERY;
+}
+
+static struct iscsi_ooo_cmdsn *iscsit_allocate_ooo_cmdsn(void)
+{
+	struct iscsi_ooo_cmdsn *ooo_cmdsn = NULL;
+
+	ooo_cmdsn = kmem_cache_zalloc(lio_ooo_cache, GFP_ATOMIC);
+	if (!ooo_cmdsn) {
+		pr_err("Unable to allocate memory for"
+			" struct iscsi_ooo_cmdsn.\n");
+		return NULL;
+	}
+	INIT_LIST_HEAD(&ooo_cmdsn->ooo_list);
+
+	return ooo_cmdsn;
+}
+
+/*
+ *	Called with sess->cmdsn_mutex held.
+ */
+static int iscsit_attach_ooo_cmdsn(
+	struct iscsi_session *sess,
+	struct iscsi_ooo_cmdsn *ooo_cmdsn)
+{
+	struct iscsi_ooo_cmdsn *ooo_tail, *ooo_tmp;
+	/*
+	 * We attach the struct iscsi_ooo_cmdsn entry to the out of order
+	 * list in increasing CmdSN order.
+	 * This allows iscsi_execute_ooo_cmdsns() to detect any
+	 * additional CmdSN holes while performing delayed execution.
+	 */
+	if (list_empty(&sess->sess_ooo_cmdsn_list))
+		list_add_tail(&ooo_cmdsn->ooo_list,
+				&sess->sess_ooo_cmdsn_list);
+	else {
+		ooo_tail = list_entry(sess->sess_ooo_cmdsn_list.prev,
+				typeof(*ooo_tail), ooo_list);
+		/*
+		 * CmdSN is greater than the tail of the list.
+		 */
+		if (ooo_tail->cmdsn < ooo_cmdsn->cmdsn)
+			list_add_tail(&ooo_cmdsn->ooo_list,
+					&sess->sess_ooo_cmdsn_list);
+		else {
+			/*
+			 * CmdSN is either lower than the head,  or somewhere
+			 * in the middle.
+			 */
+			list_for_each_entry(ooo_tmp, &sess->sess_ooo_cmdsn_list,
+						ooo_list) {
+				while (ooo_tmp->cmdsn < ooo_cmdsn->cmdsn)
+					continue;
+
+				list_add(&ooo_cmdsn->ooo_list,
+					&ooo_tmp->ooo_list);
+				break;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ *	Removes an struct iscsi_ooo_cmdsn from a session's list,
+ *	called with struct iscsi_session->cmdsn_mutex held.
+ */
+void iscsit_remove_ooo_cmdsn(
+	struct iscsi_session *sess,
+	struct iscsi_ooo_cmdsn *ooo_cmdsn)
+{
+	list_del(&ooo_cmdsn->ooo_list);
+	kmem_cache_free(lio_ooo_cache, ooo_cmdsn);
+}
+
+void iscsit_clear_ooo_cmdsns_for_conn(struct iscsi_conn *conn)
+{
+	struct iscsi_ooo_cmdsn *ooo_cmdsn;
+	struct iscsi_session *sess = conn->sess;
+
+	mutex_lock(&sess->cmdsn_mutex);
+	list_for_each_entry(ooo_cmdsn, &sess->sess_ooo_cmdsn_list, ooo_list) {
+		if (ooo_cmdsn->cid != conn->cid)
+			continue;
+
+		ooo_cmdsn->cmd = NULL;
+	}
+	mutex_unlock(&sess->cmdsn_mutex);
+}
+
+/*
+ *	Called with sess->cmdsn_mutex held.
+ */
+int iscsit_execute_ooo_cmdsns(struct iscsi_session *sess)
+{
+	int ooo_count = 0;
+	struct iscsi_cmd *cmd = NULL;
+	struct iscsi_ooo_cmdsn *ooo_cmdsn, *ooo_cmdsn_tmp;
+
+	list_for_each_entry_safe(ooo_cmdsn, ooo_cmdsn_tmp,
+				&sess->sess_ooo_cmdsn_list, ooo_list) {
+		if (ooo_cmdsn->cmdsn != sess->exp_cmd_sn)
+			continue;
+
+		if (!ooo_cmdsn->cmd) {
+			sess->exp_cmd_sn++;
+			iscsit_remove_ooo_cmdsn(sess, ooo_cmdsn);
+			continue;
+		}
+
+		cmd = ooo_cmdsn->cmd;
+		cmd->i_state = cmd->deferred_i_state;
+		ooo_count++;
+		sess->exp_cmd_sn++;
+		pr_debug("Executing out of order CmdSN: 0x%08x,"
+			" incremented ExpCmdSN to 0x%08x.\n",
+			cmd->cmd_sn, sess->exp_cmd_sn);
+
+		iscsit_remove_ooo_cmdsn(sess, ooo_cmdsn);
+
+		if (iscsit_execute_cmd(cmd, 1) < 0)
+			return -1;
+
+		continue;
+	}
+
+	return ooo_count;
+}
+
+/*
+ *	Called either:
+ *
+ *	1. With sess->cmdsn_mutex held from iscsi_execute_ooo_cmdsns()
+ *	or iscsi_check_received_cmdsn().
+ *	2. With no locks held directly from iscsi_handle_XXX_pdu() functions
+ *	for immediate commands.
+ */
+int iscsit_execute_cmd(struct iscsi_cmd *cmd, int ooo)
+{
+	struct se_cmd *se_cmd = &cmd->se_cmd;
+	int lr = 0;
+
+	spin_lock_bh(&cmd->istate_lock);
+	if (ooo)
+		cmd->cmd_flags &= ~ICF_OOO_CMDSN;
+
+	switch (cmd->iscsi_opcode) {
+	case ISCSI_OP_SCSI_CMD:
+		/*
+		 * Go ahead and send the CHECK_CONDITION status for
+		 * any SCSI CDB exceptions that may have occurred, also
+		 * handle the SCF_SCSI_RESERVATION_CONFLICT case here as well.
+		 */
+		if (se_cmd->se_cmd_flags & SCF_SCSI_CDB_EXCEPTION) {
+			if (se_cmd->se_cmd_flags &
+					SCF_SCSI_RESERVATION_CONFLICT) {
+				cmd->i_state = ISTATE_SEND_STATUS;
+				spin_unlock_bh(&cmd->istate_lock);
+				iscsit_add_cmd_to_response_queue(cmd, cmd->conn,
+						cmd->i_state);
+				return 0;
+			}
+			spin_unlock_bh(&cmd->istate_lock);
+			/*
+			 * Determine if delayed TASK_ABORTED status for WRITEs
+			 * should be sent now if no unsolicited data out
+			 * payloads are expected, or if the delayed status
+			 * should be sent after unsolicited data out with
+			 * ISCSI_FLAG_CMD_FINAL set in iscsi_handle_data_out()
+			 */
+			if (transport_check_aborted_status(se_cmd,
+					(cmd->unsolicited_data == 0)) != 0)
+				return 0;
+			/*
+			 * Otherwise send CHECK_CONDITION and sense for
+			 * exception
+			 */
+			return transport_send_check_condition_and_sense(se_cmd,
+					se_cmd->scsi_sense_reason, 0);
+		}
+		/*
+		 * Special case for delayed CmdSN with Immediate
+		 * Data and/or Unsolicited Data Out attached.
+		 */
+		if (cmd->immediate_data) {
+			if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
+				spin_unlock_bh(&cmd->istate_lock);
+				return transport_generic_handle_data(
+						&cmd->se_cmd);
+			}
+			spin_unlock_bh(&cmd->istate_lock);
+
+			if (!(cmd->cmd_flags &
+					ICF_NON_IMMEDIATE_UNSOLICITED_DATA)) {
+				/*
+				 * Send the delayed TASK_ABORTED status for
+				 * WRITEs if no more unsolicitied data is
+				 * expected.
+				 */
+				if (transport_check_aborted_status(se_cmd, 1)
+						!= 0)
+					return 0;
+
+				iscsit_set_dataout_sequence_values(cmd);
+				iscsit_build_r2ts_for_cmd(cmd, cmd->conn, 0);
+			}
+			return 0;
+		}
+		/*
+		 * The default handler.
+		 */
+		spin_unlock_bh(&cmd->istate_lock);
+
+		if ((cmd->data_direction == DMA_TO_DEVICE) &&
+		    !(cmd->cmd_flags & ICF_NON_IMMEDIATE_UNSOLICITED_DATA)) {
+			/*
+			 * Send the delayed TASK_ABORTED status for WRITEs if
+			 * no more nsolicitied data is expected.
+			 */
+			if (transport_check_aborted_status(se_cmd, 1) != 0)
+				return 0;
+
+			iscsit_set_dataout_sequence_values(cmd);
+			spin_lock_bh(&cmd->dataout_timeout_lock);
+			iscsit_start_dataout_timer(cmd, cmd->conn);
+			spin_unlock_bh(&cmd->dataout_timeout_lock);
+		}
+		return transport_handle_cdb_direct(&cmd->se_cmd);
+
+	case ISCSI_OP_NOOP_OUT:
+	case ISCSI_OP_TEXT:
+		spin_unlock_bh(&cmd->istate_lock);
+		iscsit_add_cmd_to_response_queue(cmd, cmd->conn, cmd->i_state);
+		break;
+	case ISCSI_OP_SCSI_TMFUNC:
+		if (se_cmd->se_cmd_flags & SCF_SCSI_CDB_EXCEPTION) {
+			spin_unlock_bh(&cmd->istate_lock);
+			iscsit_add_cmd_to_response_queue(cmd, cmd->conn,
+					cmd->i_state);
+			return 0;
+		}
+		spin_unlock_bh(&cmd->istate_lock);
+
+		return transport_generic_handle_tmr(&cmd->se_cmd);
+	case ISCSI_OP_LOGOUT:
+		spin_unlock_bh(&cmd->istate_lock);
+		switch (cmd->logout_reason) {
+		case ISCSI_LOGOUT_REASON_CLOSE_SESSION:
+			lr = iscsit_logout_closesession(cmd, cmd->conn);
+			break;
+		case ISCSI_LOGOUT_REASON_CLOSE_CONNECTION:
+			lr = iscsit_logout_closeconnection(cmd, cmd->conn);
+			break;
+		case ISCSI_LOGOUT_REASON_RECOVERY:
+			lr = iscsit_logout_removeconnforrecovery(cmd, cmd->conn);
+			break;
+		default:
+			pr_err("Unknown iSCSI Logout Request Code:"
+				" 0x%02x\n", cmd->logout_reason);
+			return -1;
+		}
+
+		return lr;
+	default:
+		spin_unlock_bh(&cmd->istate_lock);
+		pr_err("Cannot perform out of order execution for"
+		" unknown iSCSI Opcode: 0x%02x\n", cmd->iscsi_opcode);
+		return -1;
+	}
+
+	return 0;
+}
+
+void iscsit_free_all_ooo_cmdsns(struct iscsi_session *sess)
+{
+	struct iscsi_ooo_cmdsn *ooo_cmdsn, *ooo_cmdsn_tmp;
+
+	mutex_lock(&sess->cmdsn_mutex);
+	list_for_each_entry_safe(ooo_cmdsn, ooo_cmdsn_tmp,
+			&sess->sess_ooo_cmdsn_list, ooo_list) {
+
+		list_del(&ooo_cmdsn->ooo_list);
+		kmem_cache_free(lio_ooo_cache, ooo_cmdsn);
+	}
+	mutex_unlock(&sess->cmdsn_mutex);
+}
+
+int iscsit_handle_ooo_cmdsn(
+	struct iscsi_session *sess,
+	struct iscsi_cmd *cmd,
+	u32 cmdsn)
+{
+	int batch = 0;
+	struct iscsi_ooo_cmdsn *ooo_cmdsn = NULL, *ooo_tail = NULL;
+
+	cmd->deferred_i_state		= cmd->i_state;
+	cmd->i_state			= ISTATE_DEFERRED_CMD;
+	cmd->cmd_flags			|= ICF_OOO_CMDSN;
+
+	if (list_empty(&sess->sess_ooo_cmdsn_list))
+		batch = 1;
+	else {
+		ooo_tail = list_entry(sess->sess_ooo_cmdsn_list.prev,
+				typeof(*ooo_tail), ooo_list);
+		if (ooo_tail->cmdsn != (cmdsn - 1))
+			batch = 1;
+	}
+
+	ooo_cmdsn = iscsit_allocate_ooo_cmdsn();
+	if (!ooo_cmdsn)
+		return CMDSN_ERROR_CANNOT_RECOVER;
+
+	ooo_cmdsn->cmd			= cmd;
+	ooo_cmdsn->batch_count		= (batch) ?
+					  (cmdsn - sess->exp_cmd_sn) : 1;
+	ooo_cmdsn->cid			= cmd->conn->cid;
+	ooo_cmdsn->exp_cmdsn		= sess->exp_cmd_sn;
+	ooo_cmdsn->cmdsn		= cmdsn;
+
+	if (iscsit_attach_ooo_cmdsn(sess, ooo_cmdsn) < 0) {
+		kmem_cache_free(lio_ooo_cache, ooo_cmdsn);
+		return CMDSN_ERROR_CANNOT_RECOVER;
+	}
+
+	return CMDSN_HIGHER_THAN_EXP;
+}
+
+static int iscsit_set_dataout_timeout_values(
+	struct iscsi_cmd *cmd,
+	u32 *offset,
+	u32 *length)
+{
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_r2t *r2t;
+
+	if (cmd->unsolicited_data) {
+		*offset = 0;
+		*length = (conn->sess->sess_ops->FirstBurstLength >
+			   cmd->data_length) ?
+			   cmd->data_length :
+			   conn->sess->sess_ops->FirstBurstLength;
+		return 0;
+	}
+
+	spin_lock_bh(&cmd->r2t_lock);
+	if (list_empty(&cmd->cmd_r2t_list)) {
+		pr_err("cmd->cmd_r2t_list is empty!\n");
+		spin_unlock_bh(&cmd->r2t_lock);
+		return -1;
+	}
+
+	list_for_each_entry(r2t, &cmd->cmd_r2t_list, r2t_list) {
+		if (r2t->sent_r2t && !r2t->recovery_r2t && !r2t->seq_complete) {
+			*offset = r2t->offset;
+			*length = r2t->xfer_len;
+			spin_unlock_bh(&cmd->r2t_lock);
+			return 0;
+		}
+	}
+	spin_unlock_bh(&cmd->r2t_lock);
+
+	pr_err("Unable to locate any incomplete DataOUT"
+		" sequences for ITT: 0x%08x.\n", cmd->init_task_tag);
+
+	return -1;
+}
+
+/*
+ *	NOTE: Called from interrupt (timer) context.
+ */
+static void iscsit_handle_dataout_timeout(unsigned long data)
+{
+	u32 pdu_length = 0, pdu_offset = 0;
+	u32 r2t_length = 0, r2t_offset = 0;
+	struct iscsi_cmd *cmd = (struct iscsi_cmd *) data;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_session *sess = NULL;
+	struct iscsi_node_attrib *na;
+
+	iscsit_inc_conn_usage_count(conn);
+
+	spin_lock_bh(&cmd->dataout_timeout_lock);
+	if (cmd->dataout_timer_flags & ISCSI_TF_STOP) {
+		spin_unlock_bh(&cmd->dataout_timeout_lock);
+		iscsit_dec_conn_usage_count(conn);
+		return;
+	}
+	cmd->dataout_timer_flags &= ~ISCSI_TF_RUNNING;
+	sess = conn->sess;
+	na = iscsit_tpg_get_node_attrib(sess);
+
+	if (!sess->sess_ops->ErrorRecoveryLevel) {
+		pr_debug("Unable to recover from DataOut timeout while"
+			" in ERL=0.\n");
+		goto failure;
+	}
+
+	if (++cmd->dataout_timeout_retries == na->dataout_timeout_retries) {
+		pr_debug("Command ITT: 0x%08x exceeded max retries"
+			" for DataOUT timeout %u, closing iSCSI connection.\n",
+			cmd->init_task_tag, na->dataout_timeout_retries);
+		goto failure;
+	}
+
+	cmd->cmd_flags |= ICF_WITHIN_COMMAND_RECOVERY;
+
+	if (conn->sess->sess_ops->DataSequenceInOrder) {
+		if (conn->sess->sess_ops->DataPDUInOrder) {
+			pdu_offset = cmd->write_data_done;
+			if ((pdu_offset + (conn->sess->sess_ops->MaxBurstLength -
+			     cmd->next_burst_len)) > cmd->data_length)
+				pdu_length = (cmd->data_length -
+					cmd->write_data_done);
+			else
+				pdu_length = (conn->sess->sess_ops->MaxBurstLength -
+						cmd->next_burst_len);
+		} else {
+			pdu_offset = cmd->seq_start_offset;
+			pdu_length = (cmd->seq_end_offset -
+				cmd->seq_start_offset);
+		}
+	} else {
+		if (iscsit_set_dataout_timeout_values(cmd, &pdu_offset,
+				&pdu_length) < 0)
+			goto failure;
+	}
+
+	if (iscsit_recalculate_dataout_values(cmd, pdu_offset, pdu_length,
+			&r2t_offset, &r2t_length) < 0)
+		goto failure;
+
+	pr_debug("Command ITT: 0x%08x timed out waiting for"
+		" completion of %sDataOUT Sequence Offset: %u, Length: %u\n",
+		cmd->init_task_tag, (cmd->unsolicited_data) ? "Unsolicited " :
+		"", r2t_offset, r2t_length);
+
+	if (iscsit_send_recovery_r2t(cmd, r2t_offset, r2t_length) < 0)
+		goto failure;
+
+	iscsit_start_dataout_timer(cmd, conn);
+	spin_unlock_bh(&cmd->dataout_timeout_lock);
+	iscsit_dec_conn_usage_count(conn);
+
+	return;
+
+failure:
+	spin_unlock_bh(&cmd->dataout_timeout_lock);
+	iscsit_cause_connection_reinstatement(conn, 0);
+	iscsit_dec_conn_usage_count(conn);
+}
+
+void iscsit_mod_dataout_timer(struct iscsi_cmd *cmd)
+{
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_session *sess = conn->sess;
+	struct iscsi_node_attrib *na = na = iscsit_tpg_get_node_attrib(sess);
+
+	spin_lock_bh(&cmd->dataout_timeout_lock);
+	if (!(cmd->dataout_timer_flags & ISCSI_TF_RUNNING)) {
+		spin_unlock_bh(&cmd->dataout_timeout_lock);
+		return;
+	}
+
+	mod_timer(&cmd->dataout_timer,
+		(get_jiffies_64() + na->dataout_timeout * HZ));
+	pr_debug("Updated DataOUT timer for ITT: 0x%08x",
+			cmd->init_task_tag);
+	spin_unlock_bh(&cmd->dataout_timeout_lock);
+}
+
+/*
+ *	Called with cmd->dataout_timeout_lock held.
+ */
+void iscsit_start_dataout_timer(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	struct iscsi_session *sess = conn->sess;
+	struct iscsi_node_attrib *na = na = iscsit_tpg_get_node_attrib(sess);
+
+	if (cmd->dataout_timer_flags & ISCSI_TF_RUNNING)
+		return;
+
+	pr_debug("Starting DataOUT timer for ITT: 0x%08x on"
+		" CID: %hu.\n", cmd->init_task_tag, conn->cid);
+
+	init_timer(&cmd->dataout_timer);
+	cmd->dataout_timer.expires = (get_jiffies_64() + na->dataout_timeout * HZ);
+	cmd->dataout_timer.data = (unsigned long)cmd;
+	cmd->dataout_timer.function = iscsit_handle_dataout_timeout;
+	cmd->dataout_timer_flags &= ~ISCSI_TF_STOP;
+	cmd->dataout_timer_flags |= ISCSI_TF_RUNNING;
+	add_timer(&cmd->dataout_timer);
+}
+
+void iscsit_stop_dataout_timer(struct iscsi_cmd *cmd)
+{
+	spin_lock_bh(&cmd->dataout_timeout_lock);
+	if (!(cmd->dataout_timer_flags & ISCSI_TF_RUNNING)) {
+		spin_unlock_bh(&cmd->dataout_timeout_lock);
+		return;
+	}
+	cmd->dataout_timer_flags |= ISCSI_TF_STOP;
+	spin_unlock_bh(&cmd->dataout_timeout_lock);
+
+	del_timer_sync(&cmd->dataout_timer);
+
+	spin_lock_bh(&cmd->dataout_timeout_lock);
+	cmd->dataout_timer_flags &= ~ISCSI_TF_RUNNING;
+	pr_debug("Stopped DataOUT Timer for ITT: 0x%08x\n",
+			cmd->init_task_tag);
+	spin_unlock_bh(&cmd->dataout_timeout_lock);
+}
diff --git a/drivers/target/iscsi/iscsi_target_erl1.h b/drivers/target/iscsi/iscsi_target_erl1.h
new file mode 100644
index 0000000..85e67e2
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_erl1.h
@@ -0,0 +1,26 @@
+#ifndef ISCSI_TARGET_ERL1_H
+#define ISCSI_TARGET_ERL1_H
+
+extern int iscsit_dump_data_payload(struct iscsi_conn *, u32, int);
+extern int iscsit_create_recovery_datain_values_datasequenceinorder_yes(
+			struct iscsi_cmd *, struct iscsi_datain_req *);
+extern int iscsit_create_recovery_datain_values_datasequenceinorder_no(
+			struct iscsi_cmd *, struct iscsi_datain_req *);
+extern int iscsit_handle_recovery_datain_or_r2t(struct iscsi_conn *, unsigned char *,
+			u32, u32, u32, u32);
+extern int iscsit_handle_status_snack(struct iscsi_conn *, u32, u32,
+			u32, u32);
+extern int iscsit_handle_data_ack(struct iscsi_conn *, u32, u32, u32);
+extern int iscsit_dataout_datapduinorder_no_fbit(struct iscsi_cmd *, struct iscsi_pdu *);
+extern int iscsit_recover_dataout_sequence(struct iscsi_cmd *, u32, u32);
+extern void iscsit_clear_ooo_cmdsns_for_conn(struct iscsi_conn *);
+extern void iscsit_free_all_ooo_cmdsns(struct iscsi_session *);
+extern int iscsit_execute_ooo_cmdsns(struct iscsi_session *);
+extern int iscsit_execute_cmd(struct iscsi_cmd *, int);
+extern int iscsit_handle_ooo_cmdsn(struct iscsi_session *, struct iscsi_cmd *, u32);
+extern void iscsit_remove_ooo_cmdsn(struct iscsi_session *, struct iscsi_ooo_cmdsn *);
+extern void iscsit_mod_dataout_timer(struct iscsi_cmd *);
+extern void iscsit_start_dataout_timer(struct iscsi_cmd *, struct iscsi_conn *);
+extern void iscsit_stop_dataout_timer(struct iscsi_cmd *);
+
+#endif /* ISCSI_TARGET_ERL1_H */
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
new file mode 100644
index 0000000..91a4d17
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -0,0 +1,474 @@
+/*******************************************************************************
+ * This file contains error recovery level two functions used by
+ * the iSCSI Target driver.
+ *
+ * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ ******************************************************************************/
+
+#include <scsi/iscsi_proto.h>
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+
+#include "iscsi_target_core.h"
+#include "iscsi_target_datain_values.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target_erl0.h"
+#include "iscsi_target_erl1.h"
+#include "iscsi_target_erl2.h"
+#include "iscsi_target.h"
+
+/*
+ *	FIXME: Does RData SNACK apply here as well?
+ */
+void iscsit_create_conn_recovery_datain_values(
+	struct iscsi_cmd *cmd,
+	u32 exp_data_sn)
+{
+	u32 data_sn = 0;
+	struct iscsi_conn *conn = cmd->conn;
+
+	cmd->next_burst_len = 0;
+	cmd->read_data_done = 0;
+
+	while (exp_data_sn > data_sn) {
+		if ((cmd->next_burst_len +
+		     conn->conn_ops->MaxRecvDataSegmentLength) <
+		     conn->sess->sess_ops->MaxBurstLength) {
+			cmd->read_data_done +=
+			       conn->conn_ops->MaxRecvDataSegmentLength;
+			cmd->next_burst_len +=
+			       conn->conn_ops->MaxRecvDataSegmentLength;
+		} else {
+			cmd->read_data_done +=
+				(conn->sess->sess_ops->MaxBurstLength -
+				cmd->next_burst_len);
+			cmd->next_burst_len = 0;
+		}
+		data_sn++;
+	}
+}
+
+void iscsit_create_conn_recovery_dataout_values(
+	struct iscsi_cmd *cmd)
+{
+	u32 write_data_done = 0;
+	struct iscsi_conn *conn = cmd->conn;
+
+	cmd->data_sn = 0;
+	cmd->next_burst_len = 0;
+
+	while (cmd->write_data_done > write_data_done) {
+		if ((write_data_done + conn->sess->sess_ops->MaxBurstLength) <=
+		     cmd->write_data_done)
+			write_data_done += conn->sess->sess_ops->MaxBurstLength;
+		else
+			break;
+	}
+
+	cmd->write_data_done = write_data_done;
+}
+
+static int iscsit_attach_active_connection_recovery_entry(
+	struct iscsi_session *sess,
+	struct iscsi_conn_recovery *cr)
+{
+	spin_lock(&sess->cr_a_lock);
+	list_add_tail(&cr->cr_list, &sess->cr_active_list);
+	spin_unlock(&sess->cr_a_lock);
+
+	return 0;
+}
+
+static int iscsit_attach_inactive_connection_recovery_entry(
+	struct iscsi_session *sess,
+	struct iscsi_conn_recovery *cr)
+{
+	spin_lock(&sess->cr_i_lock);
+	list_add_tail(&cr->cr_list, &sess->cr_inactive_list);
+
+	sess->conn_recovery_count++;
+	pr_debug("Incremented connection recovery count to %u for"
+		" SID: %u\n", sess->conn_recovery_count, sess->sid);
+	spin_unlock(&sess->cr_i_lock);
+
+	return 0;
+}
+
+struct iscsi_conn_recovery *iscsit_get_inactive_connection_recovery_entry(
+	struct iscsi_session *sess,
+	u16 cid)
+{
+	struct iscsi_conn_recovery *cr;
+
+	spin_lock(&sess->cr_i_lock);
+	list_for_each_entry(cr, &sess->cr_inactive_list, cr_list) {
+		if (cr->cid == cid) {
+			spin_unlock(&sess->cr_i_lock);
+			return cr;
+		}
+	}
+	spin_unlock(&sess->cr_i_lock);
+
+	return NULL;
+}
+
+void iscsit_free_connection_recovery_entires(struct iscsi_session *sess)
+{
+	struct iscsi_cmd *cmd, *cmd_tmp;
+	struct iscsi_conn_recovery *cr, *cr_tmp;
+
+	spin_lock(&sess->cr_a_lock);
+	list_for_each_entry_safe(cr, cr_tmp, &sess->cr_active_list, cr_list) {
+		list_del(&cr->cr_list);
+		spin_unlock(&sess->cr_a_lock);
+
+		spin_lock(&cr->conn_recovery_cmd_lock);
+		list_for_each_entry_safe(cmd, cmd_tmp,
+				&cr->conn_recovery_cmd_list, i_list) {
+
+			list_del(&cmd->i_list);
+			cmd->conn = NULL;
+			spin_unlock(&cr->conn_recovery_cmd_lock);
+			if (!(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD) ||
+			    !(cmd->se_cmd.transport_wait_for_tasks))
+				iscsit_release_cmd(cmd);
+			else
+				cmd->se_cmd.transport_wait_for_tasks(
+						&cmd->se_cmd, 1, 1);
+			spin_lock(&cr->conn_recovery_cmd_lock);
+		}
+		spin_unlock(&cr->conn_recovery_cmd_lock);
+		spin_lock(&sess->cr_a_lock);
+
+		kfree(cr);
+	}
+	spin_unlock(&sess->cr_a_lock);
+
+	spin_lock(&sess->cr_i_lock);
+	list_for_each_entry_safe(cr, cr_tmp, &sess->cr_inactive_list, cr_list) {
+		list_del(&cr->cr_list);
+		spin_unlock(&sess->cr_i_lock);
+
+		spin_lock(&cr->conn_recovery_cmd_lock);
+		list_for_each_entry_safe(cmd, cmd_tmp,
+				&cr->conn_recovery_cmd_list, i_list) {
+
+			list_del(&cmd->i_list);
+			cmd->conn = NULL;
+			spin_unlock(&cr->conn_recovery_cmd_lock);
+			if (!(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD) ||
+			    !(cmd->se_cmd.transport_wait_for_tasks))
+				iscsit_release_cmd(cmd);
+			else
+				cmd->se_cmd.transport_wait_for_tasks(
+						&cmd->se_cmd, 1, 1);
+			spin_lock(&cr->conn_recovery_cmd_lock);
+		}
+		spin_unlock(&cr->conn_recovery_cmd_lock);
+		spin_lock(&sess->cr_i_lock);
+
+		kfree(cr);
+	}
+	spin_unlock(&sess->cr_i_lock);
+}
+
+int iscsit_remove_active_connection_recovery_entry(
+	struct iscsi_conn_recovery *cr,
+	struct iscsi_session *sess)
+{
+	spin_lock(&sess->cr_a_lock);
+	list_del(&cr->cr_list);
+
+	sess->conn_recovery_count--;
+	pr_debug("Decremented connection recovery count to %u for"
+		" SID: %u\n", sess->conn_recovery_count, sess->sid);
+	spin_unlock(&sess->cr_a_lock);
+
+	kfree(cr);
+
+	return 0;
+}
+
+int iscsit_remove_inactive_connection_recovery_entry(
+	struct iscsi_conn_recovery *cr,
+	struct iscsi_session *sess)
+{
+	spin_lock(&sess->cr_i_lock);
+	list_del(&cr->cr_list);
+	spin_unlock(&sess->cr_i_lock);
+
+	return 0;
+}
+
+/*
+ *	Called with cr->conn_recovery_cmd_lock help.
+ */
+int iscsit_remove_cmd_from_connection_recovery(
+	struct iscsi_cmd *cmd,
+	struct iscsi_session *sess)
+{
+	struct iscsi_conn_recovery *cr;
+
+	if (!cmd->cr) {
+		pr_err("struct iscsi_conn_recovery pointer for ITT: 0x%08x"
+			" is NULL!\n", cmd->init_task_tag);
+		BUG();
+	}
+	cr = cmd->cr;
+
+	list_del(&cmd->i_list);
+	return --cr->cmd_count;
+}
+
+void iscsit_discard_cr_cmds_by_expstatsn(
+	struct iscsi_conn_recovery *cr,
+	u32 exp_statsn)
+{
+	u32 dropped_count = 0;
+	struct iscsi_cmd *cmd, *cmd_tmp;
+	struct iscsi_session *sess = cr->sess;
+
+	spin_lock(&cr->conn_recovery_cmd_lock);
+	list_for_each_entry_safe(cmd, cmd_tmp,
+			&cr->conn_recovery_cmd_list, i_list) {
+
+		if (((cmd->deferred_i_state != ISTATE_SENT_STATUS) &&
+		     (cmd->deferred_i_state != ISTATE_REMOVE)) ||
+		     (cmd->stat_sn >= exp_statsn)) {
+			continue;
+		}
+
+		dropped_count++;
+		pr_debug("Dropping Acknowledged ITT: 0x%08x, StatSN:"
+			" 0x%08x, CID: %hu.\n", cmd->init_task_tag,
+				cmd->stat_sn, cr->cid);
+
+		iscsit_remove_cmd_from_connection_recovery(cmd, sess);
+
+		spin_unlock(&cr->conn_recovery_cmd_lock);
+		if (!(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD) ||
+		    !(cmd->se_cmd.transport_wait_for_tasks))
+			iscsit_release_cmd(cmd);
+		else
+			cmd->se_cmd.transport_wait_for_tasks(
+					&cmd->se_cmd, 1, 0);
+		spin_lock(&cr->conn_recovery_cmd_lock);
+	}
+	spin_unlock(&cr->conn_recovery_cmd_lock);
+
+	pr_debug("Dropped %u total acknowledged commands on"
+		" CID: %hu less than old ExpStatSN: 0x%08x\n",
+			dropped_count, cr->cid, exp_statsn);
+
+	if (!cr->cmd_count) {
+		pr_debug("No commands to be reassigned for failed"
+			" connection CID: %hu on SID: %u\n",
+			cr->cid, sess->sid);
+		iscsit_remove_inactive_connection_recovery_entry(cr, sess);
+		iscsit_attach_active_connection_recovery_entry(sess, cr);
+		pr_debug("iSCSI connection recovery successful for CID:"
+			" %hu on SID: %u\n", cr->cid, sess->sid);
+		iscsit_remove_active_connection_recovery_entry(cr, sess);
+	} else {
+		iscsit_remove_inactive_connection_recovery_entry(cr, sess);
+		iscsit_attach_active_connection_recovery_entry(sess, cr);
+	}
+}
+
+int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsi_conn *conn)
+{
+	u32 dropped_count = 0;
+	struct iscsi_cmd *cmd, *cmd_tmp;
+	struct iscsi_ooo_cmdsn *ooo_cmdsn, *ooo_cmdsn_tmp;
+	struct iscsi_session *sess = conn->sess;
+
+	mutex_lock(&sess->cmdsn_mutex);
+	list_for_each_entry_safe(ooo_cmdsn, ooo_cmdsn_tmp,
+			&sess->sess_ooo_cmdsn_list, ooo_list) {
+
+		if (ooo_cmdsn->cid != conn->cid)
+			continue;
+
+		dropped_count++;
+		pr_debug("Dropping unacknowledged CmdSN:"
+		" 0x%08x during connection recovery on CID: %hu\n",
+			ooo_cmdsn->cmdsn, conn->cid);
+		iscsit_remove_ooo_cmdsn(sess, ooo_cmdsn);
+	}
+	mutex_unlock(&sess->cmdsn_mutex);
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry_safe(cmd, cmd_tmp, &conn->conn_cmd_list, i_list) {
+		if (!(cmd->cmd_flags & ICF_OOO_CMDSN))
+			continue;
+
+		list_del(&cmd->i_list);
+
+		spin_unlock_bh(&conn->cmd_lock);
+		if (!(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD) ||
+		    !(cmd->se_cmd.transport_wait_for_tasks))
+			iscsit_release_cmd(cmd);
+		else
+			cmd->se_cmd.transport_wait_for_tasks(
+					&cmd->se_cmd, 1, 1);
+		spin_lock_bh(&conn->cmd_lock);
+	}
+	spin_unlock_bh(&conn->cmd_lock);
+
+	pr_debug("Dropped %u total unacknowledged commands on CID:"
+		" %hu for ExpCmdSN: 0x%08x.\n", dropped_count, conn->cid,
+				sess->exp_cmd_sn);
+	return 0;
+}
+
+int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
+{
+	u32 cmd_count = 0;
+	struct iscsi_cmd *cmd, *cmd_tmp;
+	struct iscsi_conn_recovery *cr;
+
+	/*
+	 * Allocate an struct iscsi_conn_recovery for this connection.
+	 * Each struct iscsi_cmd contains an struct iscsi_conn_recovery pointer
+	 * (struct iscsi_cmd->cr) so we need to allocate this before preparing the
+	 * connection's command list for connection recovery.
+	 */
+	cr = kzalloc(sizeof(struct iscsi_conn_recovery), GFP_KERNEL);
+	if (!cr) {
+		pr_err("Unable to allocate memory for"
+			" struct iscsi_conn_recovery.\n");
+		return -1;
+	}
+	INIT_LIST_HEAD(&cr->cr_list);
+	INIT_LIST_HEAD(&cr->conn_recovery_cmd_list);
+	spin_lock_init(&cr->conn_recovery_cmd_lock);
+	/*
+	 * Only perform connection recovery on ISCSI_OP_SCSI_CMD or
+	 * ISCSI_OP_NOOP_OUT opcodes.  For all other opcodes call
+	 * list_del(&cmd->i_list); to release the command to the
+	 * session pool and remove it from the connection's list.
+	 *
+	 * Also stop the DataOUT timer, which will be restarted after
+	 * sending the TMR response.
+	 */
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry_safe(cmd, cmd_tmp, &conn->conn_cmd_list, i_list) {
+
+		if ((cmd->iscsi_opcode != ISCSI_OP_SCSI_CMD) &&
+		    (cmd->iscsi_opcode != ISCSI_OP_NOOP_OUT)) {
+			pr_debug("Not performing realligence on"
+				" Opcode: 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x,"
+				" CID: %hu\n", cmd->iscsi_opcode,
+				cmd->init_task_tag, cmd->cmd_sn, conn->cid);
+
+			list_del(&cmd->i_list);
+			spin_unlock_bh(&conn->cmd_lock);
+
+			if (!(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD) ||
+			    !(cmd->se_cmd.transport_wait_for_tasks))
+				iscsit_release_cmd(cmd);
+			else
+				cmd->se_cmd.transport_wait_for_tasks(
+						&cmd->se_cmd, 1, 0);
+			spin_lock_bh(&conn->cmd_lock);
+			continue;
+		}
+
+		/*
+		 * Special case where commands greater than or equal to
+		 * the session's ExpCmdSN are attached to the connection
+		 * list but not to the out of order CmdSN list.  The one
+		 * obvious case is when a command with immediate data
+		 * attached must only check the CmdSN against ExpCmdSN
+		 * after the data is received.  The special case below
+		 * is when the connection fails before data is received,
+		 * but also may apply to other PDUs, so it has been
+		 * made generic here.
+		 */
+		if (!(cmd->cmd_flags & ICF_OOO_CMDSN) && !cmd->immediate_cmd &&
+		     (cmd->cmd_sn >= conn->sess->exp_cmd_sn)) {
+			list_del(&cmd->i_list);
+			spin_unlock_bh(&conn->cmd_lock);
+
+			if (!(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD) ||
+			    !(cmd->se_cmd.transport_wait_for_tasks))
+				iscsit_release_cmd(cmd);
+			else
+				cmd->se_cmd.transport_wait_for_tasks(
+						&cmd->se_cmd, 1, 1);
+			spin_lock_bh(&conn->cmd_lock);
+			continue;
+		}
+
+		cmd_count++;
+		pr_debug("Preparing Opcode: 0x%02x, ITT: 0x%08x,"
+			" CmdSN: 0x%08x, StatSN: 0x%08x, CID: %hu for"
+			" realligence.\n", cmd->iscsi_opcode,
+			cmd->init_task_tag, cmd->cmd_sn, cmd->stat_sn,
+			conn->cid);
+
+		cmd->deferred_i_state = cmd->i_state;
+		cmd->i_state = ISTATE_IN_CONNECTION_RECOVERY;
+
+		if (cmd->data_direction == DMA_TO_DEVICE)
+			iscsit_stop_dataout_timer(cmd);
+
+		cmd->sess = conn->sess;
+
+		list_del(&cmd->i_list);
+		spin_unlock_bh(&conn->cmd_lock);
+
+		iscsit_free_all_datain_reqs(cmd);
+
+		if ((cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD) &&
+		     cmd->se_cmd.transport_wait_for_tasks)
+			cmd->se_cmd.transport_wait_for_tasks(&cmd->se_cmd,
+					0, 0);
+		/*
+		 * Add the struct iscsi_cmd to the connection recovery cmd list
+		 */
+		spin_lock(&cr->conn_recovery_cmd_lock);
+		list_add_tail(&cmd->i_list, &cr->conn_recovery_cmd_list);
+		spin_unlock(&cr->conn_recovery_cmd_lock);
+
+		spin_lock_bh(&conn->cmd_lock);
+		cmd->cr = cr;
+		cmd->conn = NULL;
+	}
+	spin_unlock_bh(&conn->cmd_lock);
+	/*
+	 * Fill in the various values in the preallocated struct iscsi_conn_recovery.
+	 */
+	cr->cid = conn->cid;
+	cr->cmd_count = cmd_count;
+	cr->maxrecvdatasegmentlength = conn->conn_ops->MaxRecvDataSegmentLength;
+	cr->sess = conn->sess;
+
+	iscsit_attach_inactive_connection_recovery_entry(conn->sess, cr);
+
+	return 0;
+}
+
+int iscsit_connection_recovery_transport_reset(struct iscsi_conn *conn)
+{
+	atomic_set(&conn->connection_recovery, 1);
+
+	if (iscsit_close_connection(conn) < 0)
+		return -1;
+
+	return 0;
+}
diff --git a/drivers/target/iscsi/iscsi_target_erl2.h b/drivers/target/iscsi/iscsi_target_erl2.h
new file mode 100644
index 0000000..22f8d24
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_erl2.h
@@ -0,0 +1,18 @@
+#ifndef ISCSI_TARGET_ERL2_H
+#define ISCSI_TARGET_ERL2_H
+
+extern void iscsit_create_conn_recovery_datain_values(struct iscsi_cmd *, u32);
+extern void iscsit_create_conn_recovery_dataout_values(struct iscsi_cmd *);
+extern struct iscsi_conn_recovery *iscsit_get_inactive_connection_recovery_entry(
+			struct iscsi_session *, u16);
+extern void iscsit_free_connection_recovery_entires(struct iscsi_session *);
+extern int iscsit_remove_active_connection_recovery_entry(
+			struct iscsi_conn_recovery *, struct iscsi_session *);
+extern int iscsit_remove_cmd_from_connection_recovery(struct iscsi_cmd *,
+			struct iscsi_session *);
+extern void iscsit_discard_cr_cmds_by_expstatsn(struct iscsi_conn_recovery *, u32);
+extern int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsi_conn *);
+extern int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *);
+extern int iscsit_connection_recovery_transport_reset(struct iscsi_conn *);
+
+#endif /*** ISCSI_TARGET_ERL2_H ***/
-- 
1.7.6

