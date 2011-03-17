From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v3 09/12] iscsi-target: Add iSCSI Error Recovery Hierarchy support
Date: Thu, 17 Mar 2011 14:53:14 -0700
Message-ID: <1300398797-24536-10-git-send-email-nab@linux-iscsi.org>
References: <1300398797-24536-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm4-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.206]:26775 "HELO
	nm4-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755985Ab1CQVyg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2011 17:54:36 -0400
In-Reply-To: <1300398797-24536-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

=46rom: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for RFC-3720 compatiable ErrorRecoveryLevel
support as defined in Section 6.1.5.  Error Recovery Hierarchy.

This includes support for iSCSI session reinstatement, iSCSI within
command and within connection recovery, and explict/implict connection
recovery (CSM-E and CSM-I) from state machines in Section 7 of RFC-3720=
=2E

These functions are called from iscsi_target.c to handle processing
based on the negotiated session-wide ErrorRecoveryLevel parameter.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_erl0.c | 1080 ++++++++++++++++++++++=
+
 drivers/target/iscsi/iscsi_target_erl0.h |   19 +
 drivers/target/iscsi/iscsi_target_erl1.c | 1378 ++++++++++++++++++++++=
++++++++
 drivers/target/iscsi/iscsi_target_erl1.h |   35 +
 drivers/target/iscsi/iscsi_target_erl2.c |  529 ++++++++++++
 drivers/target/iscsi/iscsi_target_erl2.h |   20 +
 6 files changed, 3061 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/iscsi/iscsi_target_erl0.c
 create mode 100644 drivers/target/iscsi/iscsi_target_erl0.h
 create mode 100644 drivers/target/iscsi/iscsi_target_erl1.c
 create mode 100644 drivers/target/iscsi/iscsi_target_erl1.h
 create mode 100644 drivers/target/iscsi/iscsi_target_erl2.c
 create mode 100644 drivers/target/iscsi/iscsi_target_erl2.h

diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/=
iscsi/iscsi_target_erl0.c
new file mode 100644
index 0000000..c4ec123
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -0,0 +1,1080 @@
+/*********************************************************************=
*********
+ * This file contains error recovery level zero functions used by
+ * the iSCSI Target driver.
+ *
+ * =C2=A9 Copyright 2007-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (=
GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *********************************************************************=
*********/
+
+#include <scsi/iscsi_proto.h>
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+
+#include "iscsi_target_debug.h"
+#include "iscsi_target_core.h"
+#include "iscsi_target_seq_pdu_list.h"
+#include "iscsi_target_tq.h"
+#include "iscsi_target_erl0.h"
+#include "iscsi_target_erl1.h"
+#include "iscsi_target_erl2.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target.h"
+
+/*	iscsi_set_dataout_sequence_values():
+ *
+ *	Used to set values in struct iscsi_cmd that iscsi_dataout_check_seq=
uence()
+ *	checks against to determine a PDU's Offset+Length is within the cur=
rent
+ *	DataOUT Sequence.  Used for DataSequenceInOrder=3DYes only.
+ */
+void iscsi_set_dataout_sequence_values(
+	struct iscsi_cmd *cmd)
+{
+	struct iscsi_conn *conn =3D cmd->conn;
+	/*
+	 * Still set seq_start_offset and seq_end_offset for Unsolicited
+	 * DataOUT, even if DataSequenceInOrder=3DNo.
+	 */
+	if (cmd->unsolicited_data) {
+		cmd->seq_start_offset =3D cmd->write_data_done;
+		cmd->seq_end_offset =3D (cmd->write_data_done +
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
+		cmd->seq_start_offset =3D cmd->write_data_done;
+		cmd->seq_end_offset =3D (cmd->data_length >
+			conn->sess->sess_ops->MaxBurstLength) ?
+			(cmd->write_data_done +
+			conn->sess->sess_ops->MaxBurstLength) : cmd->data_length;
+	} else {
+		cmd->seq_start_offset =3D cmd->seq_end_offset;
+		cmd->seq_end_offset =3D ((cmd->seq_end_offset +
+			conn->sess->sess_ops->MaxBurstLength) >=3D
+			cmd->data_length) ? cmd->data_length :
+			(cmd->seq_end_offset +
+			 conn->sess->sess_ops->MaxBurstLength);
+	}
+}
+
+/*	iscsi_dataout_within_command_recovery_check():
+ *
+ *
+ */
+static inline int iscsi_dataout_within_command_recovery_check(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_data *hdr =3D (struct iscsi_data *) buf;
+	u32 payload_length =3D ntoh24(hdr->dlength);
+
+	/*
+	 * We do the within-command recovery checks here as it is
+	 * the first function called in iscsi_check_pre_dataout().
+	 * Basically, if we are in within-command recovery and
+	 * the PDU does not contain the offset the sequence needs,
+	 * dump the payload.
+	 *
+	 * This only applies to DataPDUInOrder=3DYes, for
+	 * DataPDUInOrder=3DNo we only re-request the failed PDU
+	 * and check that all PDUs in a sequence are received
+	 * upon end of sequence.
+	 */
+	if (conn->sess->sess_ops->DataSequenceInOrder) {
+		if ((cmd->cmd_flags & ICF_WITHIN_COMMAND_RECOVERY) &&
+		    (cmd->write_data_done !=3D hdr->offset))
+			goto dump;
+
+		cmd->cmd_flags &=3D ~ICF_WITHIN_COMMAND_RECOVERY;
+	} else {
+		struct iscsi_seq *seq;
+
+		seq =3D iscsi_get_seq_holder(cmd, hdr->offset, payload_length);
+		if (!seq)
+			return DATAOUT_CANNOT_RECOVER;
+		/*
+		 * Set the struct iscsi_seq pointer to reuse later.
+		 */
+		cmd->seq_ptr =3D seq;
+
+		if (conn->sess->sess_ops->DataPDUInOrder) {
+			if ((seq->status =3D=3D
+			     DATAOUT_SEQUENCE_WITHIN_COMMAND_RECOVERY) &&
+			   ((seq->offset !=3D hdr->offset) ||
+			    (seq->data_sn !=3D hdr->datasn)))
+				goto dump;
+		} else {
+			if ((seq->status =3D=3D
+			     DATAOUT_SEQUENCE_WITHIN_COMMAND_RECOVERY) &&
+			    (seq->data_sn !=3D hdr->datasn))
+				goto dump;
+		}
+
+		if (seq->status =3D=3D DATAOUT_SEQUENCE_COMPLETE)
+			goto dump;
+
+		if (seq->status !=3D DATAOUT_SEQUENCE_COMPLETE)
+			seq->status =3D 0;
+	}
+
+	return DATAOUT_NORMAL;
+
+dump:
+	printk(KERN_ERR "Dumping DataOUT PDU Offset: %u Length: %d DataSN:"
+		" 0x%08x\n", hdr->offset, payload_length, hdr->datasn);
+	return iscsi_dump_data_payload(conn, payload_length, 1);
+}
+
+/*	iscsi_dataout_check_unsolicited_sequence():
+ *
+ *
+ */
+static inline int iscsi_dataout_check_unsolicited_sequence(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	u32 first_burst_len;
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_data *hdr =3D (struct iscsi_data *) buf;
+	u32 payload_length =3D ntoh24(hdr->dlength);
+
+
+	if ((hdr->offset < cmd->seq_start_offset) ||
+	   ((hdr->offset + payload_length) > cmd->seq_end_offset)) {
+		printk(KERN_ERR "Command ITT: 0x%08x with Offset: %u,"
+		" Length: %u outside of Unsolicited Sequence %u:%u while"
+		" DataSequenceInOrder=3DYes.\n", cmd->init_task_tag,
+		hdr->offset, payload_length, cmd->seq_start_offset,
+			cmd->seq_end_offset);
+		return DATAOUT_CANNOT_RECOVER;
+	}
+
+	first_burst_len =3D (cmd->first_burst_len + payload_length);
+
+	if (first_burst_len > conn->sess->sess_ops->FirstBurstLength) {
+		printk(KERN_ERR "Total %u bytes exceeds FirstBurstLength: %u"
+			" for this Unsolicited DataOut Burst.\n",
+			first_burst_len, conn->sess->sess_ops->FirstBurstLength);
+		transport_send_check_condition_and_sense(SE_CMD(cmd),
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
+		 * Ignore ISCSI_FLAG_CMD_FINAL checks while DataPDUInOrder=3DNo, end=
 of
+		 * sequence checks are handled in
+		 * iscsi_dataout_datapduinorder_no_fbit().
+		 */
+		if (!conn->sess->sess_ops->DataPDUInOrder)
+			goto out;
+
+		if ((first_burst_len !=3D cmd->data_length) &&
+		    (first_burst_len !=3D conn->sess->sess_ops->FirstBurstLength)) {
+			printk(KERN_ERR "Unsolicited non-immediate data"
+			" received %u does not equal FirstBurstLength: %u, and"
+			" does not equal ExpXferLen %u.\n", first_burst_len,
+				conn->sess->sess_ops->FirstBurstLength,
+				cmd->data_length);
+			transport_send_check_condition_and_sense(SE_CMD(cmd),
+					TCM_INCORRECT_AMOUNT_OF_DATA, 0);
+			return DATAOUT_CANNOT_RECOVER;
+		}
+	} else {
+		if (first_burst_len =3D=3D conn->sess->sess_ops->FirstBurstLength) {
+			printk(KERN_ERR "Command ITT: 0x%08x reached"
+			" FirstBurstLength: %u, but ISCSI_FLAG_CMD_FINAL is not set. protoc=
ol"
+				" error.\n", cmd->init_task_tag,
+				conn->sess->sess_ops->FirstBurstLength);
+			return DATAOUT_CANNOT_RECOVER;
+		}
+		if (first_burst_len =3D=3D cmd->data_length) {
+			printk(KERN_ERR "Command ITT: 0x%08x reached"
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
+/*	iscsi_dataout_check_sequence():
+ *
+ *
+ */
+static inline int iscsi_dataout_check_sequence(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	u32 next_burst_len;
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_seq *seq =3D NULL;
+	struct iscsi_data *hdr =3D (struct iscsi_data *) buf;
+	u32 payload_length =3D ntoh24(hdr->dlength);
+
+	/*
+	 * For DataSequenceInOrder=3DYes: Check that the offset and offset+le=
ngth
+	 * is within range as defined by iscsi_set_dataout_sequence_values().
+	 *
+	 * For DataSequenceInOrder=3DNo: Check that an struct iscsi_seq exist=
s for
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
+			printk(KERN_ERR "Command ITT: 0x%08x with Offset: %u,"
+			" Length: %u outside of Sequence %u:%u while"
+			" DataSequenceInOrder=3DYes.\n", cmd->init_task_tag,
+			hdr->offset, payload_length, cmd->seq_start_offset,
+				cmd->seq_end_offset);
+
+			if (iscsi_dump_data_payload(conn, payload_length, 1) < 0)
+				return DATAOUT_CANNOT_RECOVER;
+			return DATAOUT_WITHIN_COMMAND_RECOVERY;
+		}
+
+		next_burst_len =3D (cmd->next_burst_len + payload_length);
+	} else {
+		seq =3D iscsi_get_seq_holder(cmd, hdr->offset, payload_length);
+		if (!seq)
+			return DATAOUT_CANNOT_RECOVER;
+		/*
+		 * Set the struct iscsi_seq pointer to reuse later.
+		 */
+		cmd->seq_ptr =3D seq;
+
+		if (seq->status =3D=3D DATAOUT_SEQUENCE_COMPLETE) {
+			if (iscsi_dump_data_payload(conn, payload_length, 1) < 0)
+				return DATAOUT_CANNOT_RECOVER;
+			return DATAOUT_WITHIN_COMMAND_RECOVERY;
+		}
+
+		next_burst_len =3D (seq->next_burst_len + payload_length);
+	}
+
+	if (next_burst_len > conn->sess->sess_ops->MaxBurstLength) {
+		printk(KERN_ERR "Command ITT: 0x%08x, NextBurstLength: %u and"
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
+		 * Ignore ISCSI_FLAG_CMD_FINAL checks while DataPDUInOrder=3DNo, end=
 of
+		 * sequence checks are handled in
+		 * iscsi_dataout_datapduinorder_no_fbit().
+		 */
+		if (!conn->sess->sess_ops->DataPDUInOrder)
+			goto out;
+
+		if (conn->sess->sess_ops->DataSequenceInOrder) {
+			if ((next_burst_len <
+			     conn->sess->sess_ops->MaxBurstLength) &&
+			   ((cmd->write_data_done + payload_length) <
+			     cmd->data_length)) {
+				printk(KERN_ERR "Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL"
+				" before end of DataOUT sequence, protocol"
+				" error.\n", cmd->init_task_tag);
+				return DATAOUT_CANNOT_RECOVER;
+			}
+		} else {
+			if (next_burst_len < seq->xfer_len) {
+				printk(KERN_ERR "Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL"
+				" before end of DataOUT sequence, protocol"
+				" error.\n", cmd->init_task_tag);
+				return DATAOUT_CANNOT_RECOVER;
+			}
+		}
+	} else {
+		if (conn->sess->sess_ops->DataSequenceInOrder) {
+			if (next_burst_len =3D=3D
+					conn->sess->sess_ops->MaxBurstLength) {
+				printk(KERN_ERR "Command ITT: 0x%08x reached"
+				" MaxBurstLength: %u, but ISCSI_FLAG_CMD_FINAL is"
+				" not set, protocol error.", cmd->init_task_tag,
+					conn->sess->sess_ops->MaxBurstLength);
+				return DATAOUT_CANNOT_RECOVER;
+			}
+			if ((cmd->write_data_done + payload_length) =3D=3D
+					cmd->data_length) {
+				printk(KERN_ERR "Command ITT: 0x%08x reached"
+				" last DataOUT PDU in sequence but ISCSI_FLAG_"
+				"CMD_FINAL is not set, protocol error.\n",
+					cmd->init_task_tag);
+				return DATAOUT_CANNOT_RECOVER;
+			}
+		} else {
+			if (next_burst_len =3D=3D seq->xfer_len) {
+				printk(KERN_ERR "Command ITT: 0x%08x reached"
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
+/*	iscsi_dataout_check_datasn():
+ *
+ *	Called from:	iscsi_check_pre_dataout()
+ */
+static inline int iscsi_dataout_check_datasn(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	int dump =3D 0, recovery =3D 0;
+	u32 data_sn =3D 0;
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_data *hdr =3D (struct iscsi_data *) buf;
+	u32 payload_length =3D ntoh24(hdr->dlength);
+
+	/*
+	 * Considering the target has no method of re-requesting DataOUT
+	 * by DataSN, if we receieve a greater DataSN than expected we
+	 * assume the functions for DataPDUInOrder=3D[Yes,No] below will
+	 * handle it.
+	 *
+	 * If the DataSN is less than expected, dump the payload.
+	 */
+	if (conn->sess->sess_ops->DataSequenceInOrder)
+		data_sn =3D cmd->data_sn;
+	else {
+		struct iscsi_seq *seq =3D cmd->seq_ptr;
+		data_sn =3D seq->data_sn;
+	}
+
+	if (hdr->datasn > data_sn) {
+		printk(KERN_ERR "Command ITT: 0x%08x, received DataSN: 0x%08x"
+			" higher than expected 0x%08x.\n", cmd->init_task_tag,
+				hdr->datasn, data_sn);
+		recovery =3D 1;
+		goto recover;
+	} else if (hdr->datasn < data_sn) {
+		printk(KERN_ERR "Command ITT: 0x%08x, received DataSN: 0x%08x"
+			" lower than expected 0x%08x, discarding payload.\n",
+			cmd->init_task_tag, hdr->datasn, data_sn);
+		dump =3D 1;
+		goto dump;
+	}
+
+	return DATAOUT_NORMAL;
+
+recover:
+	if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+		printk(KERN_ERR "Unable to perform within-command recovery"
+				" while ERL=3D0.\n");
+		return DATAOUT_CANNOT_RECOVER;
+	}
+dump:
+	if (iscsi_dump_data_payload(conn, payload_length, 1) < 0)
+		return DATAOUT_CANNOT_RECOVER;
+
+	return (recovery || dump) ? DATAOUT_WITHIN_COMMAND_RECOVERY :
+				DATAOUT_NORMAL;
+}
+
+/*	iscsi_dataout_pre_datapduinorder_yes():
+ *
+ *
+ */
+static inline int iscsi_dataout_pre_datapduinorder_yes(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	int dump =3D 0, recovery =3D 0;
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_data *hdr =3D (struct iscsi_data *) buf;
+	u32 payload_length =3D ntoh24(hdr->dlength);
+
+	/*
+	 * For DataSequenceInOrder=3DYes: If the offset is greater than the g=
lobal
+	 * DataPDUInOrder=3DYes offset counter in struct iscsi_cmd a protcol =
error has
+	 * occured and fail the connection.
+	 *
+	 * For DataSequenceInOrder=3DNo: If the offset is greater than the pe=
r
+	 * sequence DataPDUInOrder=3DYes offset counter in struct iscsi_seq a=
 protocol
+	 * error has occured and fail the connection.
+	 */
+	if (conn->sess->sess_ops->DataSequenceInOrder) {
+		if (hdr->offset !=3D cmd->write_data_done) {
+			printk(KERN_ERR "Command ITT: 0x%08x, received offset"
+			" %u different than expected %u.\n", cmd->init_task_tag,
+				hdr->offset, cmd->write_data_done);
+			recovery =3D 1;
+			goto recover;
+		}
+	} else {
+		struct iscsi_seq *seq =3D cmd->seq_ptr;
+
+		if (hdr->offset > seq->offset) {
+			printk(KERN_ERR "Command ITT: 0x%08x, received offset"
+			" %u greater than expected %u.\n", cmd->init_task_tag,
+				hdr->offset, seq->offset);
+			recovery =3D 1;
+			goto recover;
+		} else if (hdr->offset < seq->offset) {
+			printk(KERN_ERR "Command ITT: 0x%08x, received offset"
+			" %u less than expected %u, discarding payload.\n",
+				cmd->init_task_tag, hdr->offset, seq->offset);
+			dump =3D 1;
+			goto dump;
+		}
+	}
+
+	return DATAOUT_NORMAL;
+
+recover:
+	if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+		printk(KERN_ERR "Unable to perform within-command recovery"
+				" while ERL=3D0.\n");
+		return DATAOUT_CANNOT_RECOVER;
+	}
+dump:
+	if (iscsi_dump_data_payload(conn, payload_length, 1) < 0)
+		return DATAOUT_CANNOT_RECOVER;
+
+	return (recovery) ? iscsi_recover_dataout_sequence(cmd,
+		hdr->offset, payload_length) :
+	       (dump) ? DATAOUT_WITHIN_COMMAND_RECOVERY : DATAOUT_NORMAL;
+}
+
+/*	iscsi_dataout_pre_datapduinorder_no():
+ *
+ *	Called from:	iscsi_check_pre_dataout()
+ */
+static inline int iscsi_dataout_pre_datapduinorder_no(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	struct iscsi_pdu *pdu;
+	struct iscsi_data *hdr =3D (struct iscsi_data *) buf;
+	u32 payload_length =3D ntoh24(hdr->dlength);
+
+	pdu =3D iscsi_get_pdu_holder(cmd, hdr->offset, payload_length);
+	if (!pdu)
+		return DATAOUT_CANNOT_RECOVER;
+
+	cmd->pdu_ptr =3D pdu;
+
+	switch (pdu->status) {
+	case ISCSI_PDU_NOT_RECEIVED:
+	case ISCSI_PDU_CRC_FAILED:
+	case ISCSI_PDU_TIMED_OUT:
+		break;
+	case ISCSI_PDU_RECEIVED_OK:
+		printk(KERN_ERR "Command ITT: 0x%08x received already gotten"
+			" Offset: %u, Length: %u\n", cmd->init_task_tag,
+				hdr->offset, payload_length);
+		return iscsi_dump_data_payload(cmd->conn, payload_length, 1);
+	default:
+		return DATAOUT_CANNOT_RECOVER;
+	}
+
+	return DATAOUT_NORMAL;
+}
+
+/*	iscsi_dataout_update_r2t():
+ *
+ *
+ */
+static int iscsi_dataout_update_r2t(struct iscsi_cmd *cmd, u32 offset,=
 u32 length)
+{
+	struct iscsi_r2t *r2t;
+
+	if (cmd->unsolicited_data)
+		return 0;
+
+	r2t =3D iscsi_get_r2t_for_eos(cmd, offset, length);
+	if (!r2t)
+		return -1;
+
+	spin_lock_bh(&cmd->r2t_lock);
+	r2t->seq_complete =3D 1;
+	cmd->outstanding_r2ts--;
+	spin_unlock_bh(&cmd->r2t_lock);
+
+	return 0;
+}
+
+/*	iscsi_dataout_update_datapduinorder_no():
+ *
+ *
+ */
+static int iscsi_dataout_update_datapduinorder_no(
+	struct iscsi_cmd *cmd,
+	u32 data_sn,
+	int f_bit)
+{
+	int ret =3D 0;
+	struct iscsi_pdu *pdu =3D cmd->pdu_ptr;
+
+	pdu->data_sn =3D data_sn;
+
+	switch (pdu->status) {
+	case ISCSI_PDU_NOT_RECEIVED:
+		pdu->status =3D ISCSI_PDU_RECEIVED_OK;
+		break;
+	case ISCSI_PDU_CRC_FAILED:
+		pdu->status =3D ISCSI_PDU_RECEIVED_OK;
+		break;
+	case ISCSI_PDU_TIMED_OUT:
+		pdu->status =3D ISCSI_PDU_RECEIVED_OK;
+		break;
+	default:
+		return DATAOUT_CANNOT_RECOVER;
+	}
+
+	if (f_bit) {
+		ret =3D iscsi_dataout_datapduinorder_no_fbit(cmd, pdu);
+		if (ret =3D=3D DATAOUT_CANNOT_RECOVER)
+			return ret;
+	}
+
+	return DATAOUT_NORMAL;
+}
+
+/*	iscsi_dataout_post_crc_passed():
+ *
+ *	Called from:	iscsi_check_post_dataout()
+ */
+static inline int iscsi_dataout_post_crc_passed(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	int ret, send_r2t =3D 0;
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_seq *seq =3D NULL;
+	struct iscsi_data *hdr =3D (struct iscsi_data *) buf;
+	u32 payload_length =3D ntoh24(hdr->dlength);
+
+	if (cmd->unsolicited_data) {
+		if ((cmd->first_burst_len + payload_length) =3D=3D
+		     conn->sess->sess_ops->FirstBurstLength) {
+			if (iscsi_dataout_update_r2t(cmd, hdr->offset,
+					payload_length) < 0)
+				return DATAOUT_CANNOT_RECOVER;
+			send_r2t =3D 1;
+		}
+
+		if (!conn->sess->sess_ops->DataPDUInOrder) {
+			ret =3D iscsi_dataout_update_datapduinorder_no(cmd,
+				hdr->datasn, (hdr->flags & ISCSI_FLAG_CMD_FINAL));
+			if (ret =3D=3D DATAOUT_CANNOT_RECOVER)
+				return ret;
+		}
+
+		cmd->first_burst_len +=3D payload_length;
+
+		if (conn->sess->sess_ops->DataSequenceInOrder)
+			cmd->data_sn++;
+		else {
+			seq =3D cmd->seq_ptr;
+			seq->data_sn++;
+			seq->offset +=3D payload_length;
+		}
+
+		if (send_r2t) {
+			if (seq)
+				seq->status =3D DATAOUT_SEQUENCE_COMPLETE;
+			cmd->first_burst_len =3D 0;
+			cmd->unsolicited_data =3D 0;
+		}
+	} else {
+		if (conn->sess->sess_ops->DataSequenceInOrder) {
+			if ((cmd->next_burst_len + payload_length) =3D=3D
+			     conn->sess->sess_ops->MaxBurstLength) {
+				if (iscsi_dataout_update_r2t(cmd, hdr->offset,
+						payload_length) < 0)
+					return DATAOUT_CANNOT_RECOVER;
+				send_r2t =3D 1;
+			}
+
+			if (!conn->sess->sess_ops->DataPDUInOrder) {
+				ret =3D iscsi_dataout_update_datapduinorder_no(
+						cmd, hdr->datasn,
+						(hdr->flags & ISCSI_FLAG_CMD_FINAL));
+				if (ret =3D=3D DATAOUT_CANNOT_RECOVER)
+					return ret;
+			}
+
+			cmd->next_burst_len +=3D payload_length;
+			cmd->data_sn++;
+
+			if (send_r2t)
+				cmd->next_burst_len =3D 0;
+		} else {
+			seq =3D cmd->seq_ptr;
+
+			if ((seq->next_burst_len + payload_length) =3D=3D
+			     seq->xfer_len) {
+				if (iscsi_dataout_update_r2t(cmd, hdr->offset,
+						payload_length) < 0)
+					return DATAOUT_CANNOT_RECOVER;
+				send_r2t =3D 1;
+			}
+
+			if (!conn->sess->sess_ops->DataPDUInOrder) {
+				ret =3D iscsi_dataout_update_datapduinorder_no(
+						cmd, hdr->datasn,
+						(hdr->flags & ISCSI_FLAG_CMD_FINAL));
+				if (ret =3D=3D DATAOUT_CANNOT_RECOVER)
+					return ret;
+			}
+
+			seq->data_sn++;
+			seq->offset +=3D payload_length;
+			seq->next_burst_len +=3D payload_length;
+
+			if (send_r2t) {
+				seq->next_burst_len =3D 0;
+				seq->status =3D DATAOUT_SEQUENCE_COMPLETE;
+			}
+		}
+	}
+
+	if (send_r2t && conn->sess->sess_ops->DataSequenceInOrder)
+		cmd->data_sn =3D 0;
+
+	cmd->write_data_done +=3D payload_length;
+
+	return (cmd->write_data_done =3D=3D cmd->data_length) ?
+		DATAOUT_SEND_TO_TRANSPORT : (send_r2t) ?
+		DATAOUT_SEND_R2T : DATAOUT_NORMAL;
+}
+
+/*	iscsi_dataout_post_crc_failed():
+ *
+ *	Called from:	iscsi_check_post_dataout()
+ */
+static inline int iscsi_dataout_post_crc_failed(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_pdu *pdu;
+	struct iscsi_data *hdr =3D (struct iscsi_data *) buf;
+	u32 payload_length =3D ntoh24(hdr->dlength);
+
+	if (conn->sess->sess_ops->DataPDUInOrder)
+		goto recover;
+
+	/*
+	 * The rest of this function is only called when DataPDUInOrder=3DNo.
+	 */
+	pdu =3D cmd->pdu_ptr;
+
+	switch (pdu->status) {
+	case ISCSI_PDU_NOT_RECEIVED:
+		pdu->status =3D ISCSI_PDU_CRC_FAILED;
+		break;
+	case ISCSI_PDU_CRC_FAILED:
+		break;
+	case ISCSI_PDU_TIMED_OUT:
+		pdu->status =3D ISCSI_PDU_CRC_FAILED;
+		break;
+	default:
+		return DATAOUT_CANNOT_RECOVER;
+	}
+
+recover:
+	return iscsi_recover_dataout_sequence(cmd, hdr->offset, payload_lengt=
h);
+}
+
+/*	iscsi_check_pre_dataout():
+ *
+ *	Called from iscsi_handle_data_out() before DataOUT Payload is recei=
ved
+ *	and CRC computed.
+ */
+extern int iscsi_check_pre_dataout(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf)
+{
+	int ret;
+	struct iscsi_conn *conn =3D cmd->conn;
+
+	ret =3D iscsi_dataout_within_command_recovery_check(cmd, buf);
+	if ((ret =3D=3D DATAOUT_WITHIN_COMMAND_RECOVERY) ||
+	    (ret =3D=3D DATAOUT_CANNOT_RECOVER))
+		return ret;
+
+	ret =3D iscsi_dataout_check_datasn(cmd, buf);
+	if ((ret =3D=3D DATAOUT_WITHIN_COMMAND_RECOVERY) ||
+	    (ret =3D=3D DATAOUT_CANNOT_RECOVER))
+		return ret;
+
+	if (cmd->unsolicited_data) {
+		ret =3D iscsi_dataout_check_unsolicited_sequence(cmd, buf);
+		if ((ret =3D=3D DATAOUT_WITHIN_COMMAND_RECOVERY) ||
+		    (ret =3D=3D DATAOUT_CANNOT_RECOVER))
+			return ret;
+	} else {
+		ret =3D iscsi_dataout_check_sequence(cmd, buf);
+		if ((ret =3D=3D DATAOUT_WITHIN_COMMAND_RECOVERY) ||
+		    (ret =3D=3D DATAOUT_CANNOT_RECOVER))
+			return ret;
+	}
+
+	return (conn->sess->sess_ops->DataPDUInOrder) ?
+		iscsi_dataout_pre_datapduinorder_yes(cmd, buf) :
+		iscsi_dataout_pre_datapduinorder_no(cmd, buf);
+}
+
+/*	iscsi_check_post_dataout():
+ *
+ *	Called from iscsi_handle_data_out() after DataOUT Payload is receiv=
ed
+ *	and CRC computed.
+ */
+int iscsi_check_post_dataout(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf,
+	u8 data_crc_failed)
+{
+	struct iscsi_conn *conn =3D cmd->conn;
+
+	cmd->dataout_timeout_retries =3D 0;
+
+	if (!data_crc_failed)
+		return iscsi_dataout_post_crc_passed(cmd, buf);
+	else {
+		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+			printk(KERN_ERR "Unable to recover from DataOUT CRC"
+				" failure while ERL=3D0, closing session.\n");
+			iscsi_add_reject_from_cmd(ISCSI_REASON_DATA_DIGEST_ERROR,
+					1, 0, buf, cmd);
+			return DATAOUT_CANNOT_RECOVER;
+		}
+
+		iscsi_add_reject_from_cmd(ISCSI_REASON_DATA_DIGEST_ERROR,
+				0, 0, buf, cmd);
+		return iscsi_dataout_post_crc_failed(cmd, buf);
+	}
+}
+
+/*	iscsi_handle_time2retain_timeout():
+ *
+ *
+ */
+static void iscsi_handle_time2retain_timeout(unsigned long data)
+{
+	struct iscsi_session *sess =3D (struct iscsi_session *) data;
+	struct iscsi_portal_group *tpg =3D ISCSI_TPG_S(sess);
+	struct se_portal_group *se_tpg =3D &tpg->tpg_se_tpg;
+
+	spin_lock_bh(&se_tpg->session_lock);
+	if (sess->time2retain_timer_flags & ISCSI_TF_STOP) {
+		spin_unlock_bh(&se_tpg->session_lock);
+		return;
+	}
+	if (atomic_read(&sess->session_reinstatement)) {
+		printk(KERN_ERR "Exiting Time2Retain handler because"
+				" session_reinstatement=3D1\n");
+		spin_unlock_bh(&se_tpg->session_lock);
+		return;
+	}
+	sess->time2retain_timer_flags |=3D ISCSI_TF_EXPIRED;
+
+	printk(KERN_ERR "Time2Retain timer expired for SID: %u, cleaning up"
+			" iSCSI session.\n", sess->sid);
+	{
+	struct iscsi_tiqn *tiqn =3D tpg->tpg_tiqn;
+
+	if (tiqn) {
+		spin_lock(&tiqn->sess_err_stats.lock);
+		strcpy(tiqn->sess_err_stats.last_sess_fail_rem_name,
+			(void *)sess->sess_ops->InitiatorName);
+		tiqn->sess_err_stats.last_sess_failure_type =3D
+				ISCSI_SESS_ERR_CXN_TIMEOUT;
+		tiqn->sess_err_stats.cxn_timeout_errors++;
+		sess->conn_timeout_errors++;
+		spin_unlock(&tiqn->sess_err_stats.lock);
+	}
+	}
+
+	spin_unlock_bh(&se_tpg->session_lock);
+	iscsi_close_session(sess);
+}
+
+/*	iscsi_start_session_cleanup_handler():
+ *
+ *
+ */
+extern void iscsi_start_time2retain_handler (struct iscsi_session *ses=
s)
+{
+	int tpg_active;
+
+	/*
+	 * Only start Time2Retain timer when the assoicated TPG is still in
+	 * an ACTIVE (eg: not disabled or shutdown) state.
+	 */
+	spin_lock(&ISCSI_TPG_S(sess)->tpg_state_lock);
+	tpg_active =3D (ISCSI_TPG_S(sess)->tpg_state =3D=3D TPG_STATE_ACTIVE)=
;
+	spin_unlock(&ISCSI_TPG_S(sess)->tpg_state_lock);
+
+	if (!tpg_active)
+		return;
+
+	if (sess->time2retain_timer_flags & ISCSI_TF_RUNNING)
+		return;
+
+	TRACE(TRACE_TIMER, "Starting Time2Retain timer for %u seconds on"
+		" SID: %u\n", sess->sess_ops->DefaultTime2Retain, sess->sid);
+
+	init_timer(&sess->time2retain_timer);
+	sess->time2retain_timer.expires =3D
+		(get_jiffies_64() + sess->sess_ops->DefaultTime2Retain * HZ);
+	sess->time2retain_timer.data =3D (unsigned long)sess;
+	sess->time2retain_timer.function =3D iscsi_handle_time2retain_timeout=
;
+	sess->time2retain_timer_flags &=3D ~ISCSI_TF_STOP;
+	sess->time2retain_timer_flags |=3D ISCSI_TF_RUNNING;
+	add_timer(&sess->time2retain_timer);
+}
+
+/*	iscsi_stop_time2retain_timer():
+ *
+ *	Called with spin_lock_bh(&struct se_portal_group->session_lock) hel=
d
+ */
+extern int iscsi_stop_time2retain_timer(struct iscsi_session *sess)
+{
+	struct iscsi_portal_group *tpg =3D ISCSI_TPG_S(sess);
+	struct se_portal_group *se_tpg =3D &tpg->tpg_se_tpg;
+
+	if (sess->time2retain_timer_flags & ISCSI_TF_EXPIRED)
+		return -1;
+
+	if (!(sess->time2retain_timer_flags & ISCSI_TF_RUNNING))
+		return 0;
+
+	sess->time2retain_timer_flags |=3D ISCSI_TF_STOP;
+	spin_unlock_bh(&se_tpg->session_lock);
+
+	del_timer_sync(&sess->time2retain_timer);
+
+	spin_lock_bh(&se_tpg->session_lock);
+	sess->time2retain_timer_flags &=3D ~ISCSI_TF_RUNNING;
+	TRACE(TRACE_TIMER, "Stopped Time2Retain Timer for SID: %u\n",
+			sess->sid);
+	return 0;
+}
+
+/*	iscsi_connection_reinstatement_rcfr():
+ *
+ *
+ */
+void iscsi_connection_reinstatement_rcfr(struct iscsi_conn *conn)
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
+/*	iscsi_cause_connection_reinstatement():
+ *
+ *
+ */
+void iscsi_cause_connection_reinstatement(struct iscsi_conn *conn, int=
 sleep)
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
+/*	iscsi_fall_back_to_erl0():
+ *
+ *
+ */
+void iscsi_fall_back_to_erl0(struct iscsi_session *sess)
+{
+	TRACE(TRACE_ERL0, "Falling back to ErrorRecoveryLevel=3D0 for SID:"
+			" %u\n", sess->sid);
+
+	atomic_set(&sess->session_fall_back_to_erl0, 1);
+}
+
+/*	iscsi_handle_connection_cleanup():
+ *
+ *
+ */
+static void iscsi_handle_connection_cleanup(struct iscsi_conn *conn)
+{
+	struct iscsi_session *sess =3D conn->sess;
+
+	if ((sess->sess_ops->ErrorRecoveryLevel =3D=3D 2) &&
+	    !atomic_read(&sess->session_reinstatement) &&
+	    !atomic_read(&sess->session_fall_back_to_erl0))
+		iscsi_connection_recovery_transport_reset(conn);
+	else {
+		TRACE(TRACE_ERL0, "Performing cleanup for failed iSCSI"
+			" Connection ID: %hu from %s\n", conn->cid,
+			sess->sess_ops->InitiatorName);
+		iscsi_close_connection(conn);
+	}
+}
+
+/*	iscsi_take_action_for_connection_exit():
+ *
+ *
+ */
+extern void iscsi_take_action_for_connection_exit(struct iscsi_conn *c=
onn)
+{
+	spin_lock_bh(&conn->state_lock);
+	if (atomic_read(&conn->connection_exit)) {
+		spin_unlock_bh(&conn->state_lock);
+		return;
+	}
+	atomic_set(&conn->connection_exit, 1);
+
+	if (conn->conn_state =3D=3D TARG_CONN_STATE_IN_LOGOUT) {
+		spin_unlock_bh(&conn->state_lock);
+		iscsi_close_connection(conn);
+		return;
+	}
+
+	if (conn->conn_state =3D=3D TARG_CONN_STATE_CLEANUP_WAIT) {
+		spin_unlock_bh(&conn->state_lock);
+		return;
+	}
+
+	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_CLEANUP_WAIT.\n");
+	conn->conn_state =3D TARG_CONN_STATE_CLEANUP_WAIT;
+	spin_unlock_bh(&conn->state_lock);
+
+	iscsi_handle_connection_cleanup(conn);
+}
+
+/*	iscsi_recover_from_unknown_opcode():
+ *
+ *	This is the simple function that makes the magic of
+ *	sync and steering happen in the follow paradoxical order:
+ *
+ *	0) Receive conn->of_marker (bytes left until next OFMarker)
+ *	   bytes into an offload buffer.  When we pass the exact number
+ *	   of bytes in conn->of_marker, iscsi_dump_data_payload() and hence
+ *	   rx_data() will automatically receive the identical u32 marker
+ *	   values and store it in conn->of_marker_offset;
+ *	1) Now conn->of_marker_offset will contain the offset to the start
+ *	   of the next iSCSI PDU.  Dump these remaining bytes into another
+ *	   offload buffer.
+ *	2) We are done!
+ *	   Next byte in the TCP stream will contain the next iSCSI PDU!
+ *	   Cool Huh?!
+ */
+int iscsi_recover_from_unknown_opcode(struct iscsi_conn *conn)
+{
+	/*
+	 * Make sure the remaining bytes to next maker is a sane value.
+	 */
+	if (conn->of_marker > (conn->conn_ops->OFMarkInt * 4)) {
+		printk(KERN_ERR "Remaining bytes to OFMarker: %u exceeds"
+			" OFMarkInt bytes: %u.\n", conn->of_marker,
+				conn->conn_ops->OFMarkInt * 4);
+		return -1;
+	}
+
+	TRACE(TRACE_ERL1, "Advancing %u bytes in TCP stream to get to the"
+			" next OFMarker.\n", conn->of_marker);
+
+	if (iscsi_dump_data_payload(conn, conn->of_marker, 0) < 0)
+		return -1;
+
+	/*
+	 * Make sure the offset marker we retrived is a valid value.
+	 */
+	if (conn->of_marker_offset > (ISCSI_HDR_LEN + (CRC_LEN * 2) +
+	    conn->conn_ops->MaxRecvDataSegmentLength)) {
+		printk(KERN_ERR "OfMarker offset value: %u exceeds limit.\n",
+			conn->of_marker_offset);
+		return -1;
+	}
+
+	TRACE(TRACE_ERL1, "Discarding %u bytes of TCP stream to get to the"
+			" next iSCSI Opcode.\n", conn->of_marker_offset);
+
+	if (iscsi_dump_data_payload(conn, conn->of_marker_offset, 0) < 0)
+		return -1;
+
+	return 0;
+}
diff --git a/drivers/target/iscsi/iscsi_target_erl0.h b/drivers/target/=
iscsi/iscsi_target_erl0.h
new file mode 100644
index 0000000..2056ce6
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_erl0.h
@@ -0,0 +1,19 @@
+#ifndef ISCSI_TARGET_ERL0_H
+#define ISCSI_TARGET_ERL0_H
+
+extern void iscsi_set_dataout_sequence_values(struct iscsi_cmd *);
+extern int iscsi_check_pre_dataout(struct iscsi_cmd *, unsigned char *=
);
+extern int iscsi_check_post_dataout(struct iscsi_cmd *, unsigned char =
*, u8);
+extern void iscsi_start_time2retain_handler(struct iscsi_session *);
+extern int iscsi_stop_time2retain_timer(struct iscsi_session *);
+extern void iscsi_connection_reinstatement_rcfr(struct iscsi_conn *);
+extern void iscsi_cause_connection_reinstatement(struct iscsi_conn *, =
int);
+extern void iscsi_fall_back_to_erl0(struct iscsi_session *);
+extern void iscsi_take_action_for_connection_exit(struct iscsi_conn *)=
;
+extern int iscsi_recover_from_unknown_opcode(struct iscsi_conn *);
+
+extern struct iscsi_global *iscsi_global;
+extern int iscsi_add_reject_from_cmd(u8, int, int, unsigned char *,
+			struct iscsi_cmd *);
+
+#endif   /*** ISCSI_TARGET_ERL0_H ***/
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/=
iscsi/iscsi_target_erl1.c
new file mode 100644
index 0000000..9507930
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -0,0 +1,1378 @@
+/*********************************************************************=
**********
+ * This file contains error recovery level one used by the iSCSI Targe=
t driver.
+ *
+ * =C2=A9 Copyright 2007-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (=
GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *********************************************************************=
*********/
+
+#include <linux/list.h>
+#include <scsi/iscsi_proto.h>
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+
+#include "iscsi_target_debug.h"
+#include "iscsi_target_core.h"
+#include "iscsi_target_seq_pdu_list.h"
+#include "iscsi_target_datain_values.h"
+#include "iscsi_target_device.h"
+#include "iscsi_target_tpg.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target_erl0.h"
+#include "iscsi_target_erl1.h"
+#include "iscsi_target_erl2.h"
+
+#define OFFLOAD_BUF_SIZE	32768
+
+/*	iscsi_dump_data_payload():
+ *
+ *	Used to dump excess datain payload for certain error recovery
+ *	situations.  Receive in OFFLOAD_BUF_SIZE max of datain per rx_data(=
).
+ *
+ *	dump_padding_digest denotes if padding and data digests need
+ *	to be dumped.
+ */
+int iscsi_dump_data_payload(
+	struct iscsi_conn *conn,
+	u32 buf_len,
+	int dump_padding_digest)
+{
+	char *buf, pad_bytes[4];
+	int ret =3D DATAOUT_WITHIN_COMMAND_RECOVERY, rx_got;
+	u32 length, padding, offset =3D 0, size;
+	struct iovec iov;
+
+	length =3D (buf_len > OFFLOAD_BUF_SIZE) ? OFFLOAD_BUF_SIZE : buf_len;
+
+	buf =3D kzalloc(length, GFP_ATOMIC);
+	if (!buf) {
+		printk(KERN_ERR "Unable to allocate %u bytes for offload"
+				" buffer.\n", length);
+		return -1;
+	}
+	memset(&iov, 0, sizeof(struct iovec));
+
+	while (offset < buf_len) {
+		size =3D ((offset + length) > buf_len) ?
+			(buf_len - offset) : length;
+
+		iov.iov_len =3D size;
+		iov.iov_base =3D buf;
+
+		rx_got =3D rx_data(conn, &iov, 1, size);
+		if (rx_got !=3D size) {
+			ret =3D DATAOUT_CANNOT_RECOVER;
+			goto out;
+		}
+
+		offset +=3D size;
+	}
+
+	if (!dump_padding_digest)
+		goto out;
+
+	padding =3D ((-buf_len) & 3);
+	if (padding !=3D 0) {
+		iov.iov_len =3D padding;
+		iov.iov_base =3D pad_bytes;
+
+		rx_got =3D rx_data(conn, &iov, 1, padding);
+		if (rx_got !=3D padding) {
+			ret =3D DATAOUT_CANNOT_RECOVER;
+			goto out;
+		}
+	}
+
+	if (conn->conn_ops->DataDigest) {
+		u32 data_crc;
+
+		iov.iov_len =3D CRC_LEN;
+		iov.iov_base =3D &data_crc;
+
+		rx_got =3D rx_data(conn, &iov, 1, CRC_LEN);
+		if (rx_got !=3D CRC_LEN) {
+			ret =3D DATAOUT_CANNOT_RECOVER;
+			goto out;
+		}
+	}
+
+out:
+	kfree(buf);
+	return ret;
+}
+
+/*	iscsi_send_recovery_r2t_for_snack():
+ *
+ *	Used for retransmitting R2Ts from a R2T SNACK request.
+ */
+static int iscsi_send_recovery_r2t_for_snack(
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
+	r2t->sent_r2t =3D 0;
+	spin_unlock_bh(&cmd->r2t_lock);
+
+	iscsi_add_cmd_to_immediate_queue(cmd, cmd->conn, ISTATE_SEND_R2T);
+
+	return 0;
+}
+
+/*	iscsi_handle_r2t_snack():
+ *
+ *
+ */
+static int iscsi_handle_r2t_snack(
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
+	    (begrun <=3D cmd->acked_data_sn)) {
+		printk(KERN_ERR "ITT: 0x%08x, R2T SNACK requesting"
+			" retransmission of R2TSN: 0x%08x to 0x%08x but already"
+			" acked to  R2TSN: 0x%08x by TMR TASK_REASSIGN,"
+			" protocol error.\n", cmd->init_task_tag, begrun,
+			(begrun + runlength), cmd->acked_data_sn);
+
+			return iscsi_add_reject_from_cmd(
+					ISCSI_REASON_PROTOCOL_ERROR,
+					1, 0, buf, cmd);
+	}
+
+	if (runlength) {
+		if ((begrun + runlength) > cmd->r2t_sn) {
+			printk(KERN_ERR "Command ITT: 0x%08x received R2T SNACK"
+			" with BegRun: 0x%08x, RunLength: 0x%08x, exceeds"
+			" current R2TSN: 0x%08x, protocol error.\n",
+			cmd->init_task_tag, begrun, runlength, cmd->r2t_sn);
+			return iscsi_add_reject_from_cmd(
+				ISCSI_REASON_BOOKMARK_INVALID, 1, 0, buf, cmd);
+		}
+		last_r2tsn =3D (begrun + runlength);
+	} else
+		last_r2tsn =3D cmd->r2t_sn;
+
+	while (begrun < last_r2tsn) {
+		r2t =3D iscsi_get_holder_for_r2tsn(cmd, begrun);
+		if (!r2t)
+			return -1;
+		if (iscsi_send_recovery_r2t_for_snack(cmd, r2t) < 0)
+			return -1;
+
+		begrun++;
+	}
+
+	return 0;
+}
+
+/*	iscsi_create_recovery_datain_values_datasequenceinorder_yes():
+ *
+ *	Generates Offsets and NextBurstLength based on Begrun and Runlength
+ *	carried in a Data SNACK or ExpDataSN in TMR TASK_REASSIGN.
+ *
+ *	For DataSequenceInOrder=3DYes and DataPDUInOrder=3D[Yes,No] only.
+ *
+ *	FIXME: How is this handled for a RData SNACK?
+ */
+int iscsi_create_recovery_datain_values_datasequenceinorder_yes(
+	struct iscsi_cmd *cmd,
+	struct iscsi_datain_req *dr)
+{
+	u32 data_sn =3D 0, data_sn_count =3D 0;
+	u32 pdu_start =3D 0, seq_no =3D 0;
+	u32 begrun =3D dr->begrun;
+	struct iscsi_conn *conn =3D cmd->conn;
+
+	while (begrun > data_sn++) {
+		data_sn_count++;
+		if ((dr->next_burst_len +
+		     conn->conn_ops->MaxRecvDataSegmentLength) <
+		     conn->sess->sess_ops->MaxBurstLength) {
+			dr->read_data_done +=3D
+				conn->conn_ops->MaxRecvDataSegmentLength;
+			dr->next_burst_len +=3D
+				conn->conn_ops->MaxRecvDataSegmentLength;
+		} else {
+			dr->read_data_done +=3D
+				(conn->sess->sess_ops->MaxBurstLength -
+				 dr->next_burst_len);
+			dr->next_burst_len =3D 0;
+			pdu_start +=3D data_sn_count;
+			data_sn_count =3D 0;
+			seq_no++;
+		}
+	}
+
+	if (!conn->sess->sess_ops->DataPDUInOrder) {
+		cmd->seq_no =3D seq_no;
+		cmd->pdu_start =3D pdu_start;
+		cmd->pdu_send_order =3D data_sn_count;
+	}
+
+	return 0;
+}
+
+/*	iscsi_create_recovery_datain_values_datasequenceinorder_no():
+ *
+ *	Generates Offsets and NextBurstLength based on Begrun and Runlength
+ *	carried in a Data SNACK or ExpDataSN in TMR TASK_REASSIGN.
+ *
+ *	For DataSequenceInOrder=3DNo and DataPDUInOrder=3D[Yes,No] only.
+ *
+ *	FIXME: How is this handled for a RData SNACK?
+ */
+int iscsi_create_recovery_datain_values_datasequenceinorder_no(
+	struct iscsi_cmd *cmd,
+	struct iscsi_datain_req *dr)
+{
+	int found_seq =3D 0, i;
+	u32 data_sn, read_data_done =3D 0, seq_send_order =3D 0;
+	u32 begrun =3D dr->begrun;
+	u32 runlength =3D dr->runlength;
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_seq *first_seq =3D NULL, *seq =3D NULL;
+
+	if (!cmd->seq_list) {
+		printk(KERN_ERR "struct iscsi_cmd->seq_list is NULL!\n");
+		return -1;
+	}
+
+	/*
+	 * Calculate read_data_done for all sequences containing a
+	 * first_datasn and last_datasn less than the BegRun.
+	 *
+	 * Locate the struct iscsi_seq the BegRun lies within and calculate
+	 * NextBurstLenghth up to the DataSN based on MaxRecvDataSegmentLengt=
h.
+	 *
+	 * Also use struct iscsi_seq->seq_send_order to determine where to st=
art.
+	 */
+	for (i =3D 0; i < cmd->seq_count; i++) {
+		seq =3D &cmd->seq_list[i];
+
+		if (!seq->seq_send_order)
+			first_seq =3D seq;
+
+		/*
+		 * No data has been transferred for this DataIN sequence, so the
+		 * seq->first_datasn and seq->last_datasn have not been set.
+		 */
+		if (!seq->sent) {
+#if 0
+			printk(KERN_ERR "Ignoring non-sent sequence 0x%08x ->"
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
+			printk(KERN_ERR "Pre BegRun sequence 0x%08x ->"
+				" 0x%08x\n", seq->first_datasn,
+				seq->last_datasn);
+#endif
+			read_data_done +=3D cmd->seq_list[i].xfer_len;
+			seq->next_burst_len =3D seq->pdu_send_order =3D 0;
+			continue;
+		}
+
+		/*
+		 * The BegRun lies within this DataIN sequence.
+		 */
+		if ((seq->first_datasn <=3D begrun) &&
+				(seq->last_datasn >=3D begrun)) {
+#if 0
+			printk(KERN_ERR "Found sequence begrun: 0x%08x in"
+				" 0x%08x -> 0x%08x\n", begrun,
+				seq->first_datasn, seq->last_datasn);
+#endif
+			seq_send_order =3D seq->seq_send_order;
+			data_sn =3D seq->first_datasn;
+			seq->next_burst_len =3D seq->pdu_send_order =3D 0;
+			found_seq =3D 1;
+
+			/*
+			 * For DataPDUInOrder=3DYes, while the first DataSN of
+			 * the sequence is less than the received BegRun, add
+			 * the MaxRecvDataSegmentLength to read_data_done and
+			 * to the sequence's next_burst_len;
+			 *
+			 * For DataPDUInOrder=3DNo, while the first DataSN of the
+			 * sequence is less than the received BegRun, find the
+			 * struct iscsi_pdu of the DataSN in question and add the
+			 * MaxRecvDataSegmentLength to read_data_done and to the
+			 * sequence's next_burst_len;
+			 */
+			if (conn->sess->sess_ops->DataPDUInOrder) {
+				while (data_sn < begrun) {
+					seq->pdu_send_order++;
+					read_data_done +=3D
+						conn->conn_ops->MaxRecvDataSegmentLength;
+					seq->next_burst_len +=3D
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
+					for (j =3D 0; j < seq->pdu_count; j++) {
+						pdu =3D &cmd->pdu_list[
+							seq->pdu_start + j];
+						if (pdu->data_sn =3D=3D data_sn) {
+							read_data_done +=3D
+								pdu->length;
+							seq->next_burst_len +=3D
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
+			printk(KERN_ERR "Post BegRun sequence 0x%08x -> 0x%08x\n",
+					seq->first_datasn, seq->last_datasn);
+#endif
+			seq->next_burst_len =3D seq->pdu_send_order =3D 0;
+			continue;
+		}
+	}
+
+	if (!found_seq) {
+		if (!begrun) {
+			if (!first_seq) {
+				printk(KERN_ERR "ITT: 0x%08x, Begrun: 0x%08x"
+					" but first_seq is NULL\n",
+					cmd->init_task_tag, begrun);
+				return -1;
+			}
+			seq_send_order =3D first_seq->seq_send_order;
+			seq->next_burst_len =3D seq->pdu_send_order =3D 0;
+			goto done;
+		}
+
+		printk(KERN_ERR "Unable to locate struct iscsi_seq for ITT: 0x%08x,"
+			" BegRun: 0x%08x, RunLength: 0x%08x while"
+			" DataSequenceInOrder=3DNo and DataPDUInOrder=3D%s.\n",
+				cmd->init_task_tag, begrun, runlength,
+			(conn->sess->sess_ops->DataPDUInOrder) ? "Yes" : "No");
+		return -1;
+	}
+
+done:
+	dr->read_data_done =3D read_data_done;
+	dr->seq_send_order =3D seq_send_order;
+
+	return 0;
+}
+
+/*	iscsi_handle_recovery_datain():
+ *
+ *
+ */
+static inline int iscsi_handle_recovery_datain(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf,
+	u32 begrun,
+	u32 runlength)
+{
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_datain_req *dr;
+	struct se_cmd *se_cmd =3D &cmd->se_cmd;
+
+	if (!atomic_read(&T_TASK(se_cmd)->t_transport_complete)) {
+		printk(KERN_ERR "Ignoring ITT: 0x%08x Data SNACK\n",
+				cmd->init_task_tag);
+		return 0;
+	}
+
+	/*
+	 * Make sure the initiator is not requesting retransmission
+	 * of DataSNs already acknowledged by a Data ACK SNACK.
+	 */
+	if ((cmd->cmd_flags & ICF_GOT_DATACK_SNACK) &&
+	    (begrun <=3D cmd->acked_data_sn)) {
+		printk(KERN_ERR "ITT: 0x%08x, Data SNACK requesting"
+			" retransmission of DataSN: 0x%08x to 0x%08x but"
+			" already acked to DataSN: 0x%08x by Data ACK SNACK,"
+			" protocol error.\n", cmd->init_task_tag, begrun,
+			(begrun + runlength), cmd->acked_data_sn);
+
+		return iscsi_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
+				1, 0, buf, cmd);
+	}
+
+	/*
+	 * Make sure BegRun and RunLength in the Data SNACK are sane.
+	 * Note: (cmd->data_sn - 1) will carry the maximum DataSN sent.
+	 */
+	if ((begrun + runlength) > (cmd->data_sn - 1)) {
+		printk(KERN_ERR "Initiator requesting BegRun: 0x%08x, RunLength"
+			": 0x%08x greater than maximum DataSN: 0x%08x.\n",
+				begrun, runlength, (cmd->data_sn - 1));
+		return iscsi_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
+				1, 0, buf, cmd);
+	}
+
+	dr =3D iscsi_allocate_datain_req();
+	if (!dr)
+		return iscsi_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+				1, 0, buf, cmd);
+
+	dr->data_sn =3D dr->begrun =3D begrun;
+	dr->runlength =3D runlength;
+	dr->generate_recovery_values =3D 1;
+	dr->recovery =3D DATAIN_WITHIN_COMMAND_RECOVERY;
+
+	iscsi_attach_datain_req(cmd, dr);
+
+	cmd->i_state =3D ISTATE_SEND_DATAIN;
+	iscsi_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+
+	return 0;
+}
+
+/*	iscsi_handle_recovery_datain_or_r2t():
+ *
+ *
+ */
+int iscsi_handle_recovery_datain_or_r2t(
+	struct iscsi_conn *conn,
+	unsigned char *buf,
+	u32 init_task_tag,
+	u32 targ_xfer_tag,
+	u32 begrun,
+	u32 runlength)
+{
+	struct iscsi_cmd *cmd;
+
+	cmd =3D iscsi_find_cmd_from_itt(conn, init_task_tag);
+	if (!cmd)
+		return 0;
+
+	/*
+	 * FIXME: This will not work for bidi commands.
+	 */
+	switch (cmd->data_direction) {
+	case DMA_TO_DEVICE:
+		return iscsi_handle_r2t_snack(cmd, buf, begrun, runlength);
+	case DMA_FROM_DEVICE:
+		return iscsi_handle_recovery_datain(cmd, buf, begrun,
+				runlength);
+	default:
+		printk(KERN_ERR "Unknown cmd->data_direction: 0x%02x\n",
+				cmd->data_direction);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*	iscsi_send_recovery_status():
+ *
+ *
+ */
+/* #warning FIXME: Status SNACK needs to be dependent on OPCODE!!! */
+int iscsi_handle_status_snack(
+	struct iscsi_conn *conn,
+	u32 init_task_tag,
+	u32 targ_xfer_tag,
+	u32 begrun,
+	u32 runlength)
+{
+	u32 last_statsn;
+	struct iscsi_cmd *cmd =3D NULL;
+
+	if (conn->exp_statsn > begrun) {
+		printk(KERN_ERR "Got Status SNACK Begrun: 0x%08x, RunLength:"
+			" 0x%08x but already got ExpStatSN: 0x%08x on CID:"
+			" %hu.\n", begrun, runlength, conn->exp_statsn,
+			conn->cid);
+		return 0;
+	}
+
+	last_statsn =3D (!runlength) ? conn->stat_sn : (begrun + runlength);
+
+	while (begrun < last_statsn) {
+		spin_lock_bh(&conn->cmd_lock);
+		list_for_each_entry(cmd, &conn->conn_cmd_list, i_list) {
+			if (cmd->stat_sn =3D=3D begrun)
+				break;
+		}
+		spin_unlock_bh(&conn->cmd_lock);
+
+		if (!cmd) {
+			printk(KERN_ERR "Unable to find StatSN: 0x%08x for"
+				" a Status SNACK, assuming this was a"
+				" protactic SNACK for an untransmitted"
+				" StatSN, ignoring.\n", begrun);
+			begrun++;
+			continue;
+		}
+
+		spin_lock_bh(&cmd->istate_lock);
+		if (cmd->i_state =3D=3D ISTATE_SEND_DATAIN) {
+			spin_unlock_bh(&cmd->istate_lock);
+			printk(KERN_ERR "Ignoring Status SNACK for BegRun:"
+				" 0x%08x, RunLength: 0x%08x, assuming this was"
+				" a protactic SNACK for an untransmitted"
+				" StatSN\n", begrun, runlength);
+			begrun++;
+			continue;
+		}
+		spin_unlock_bh(&cmd->istate_lock);
+
+		cmd->i_state =3D ISTATE_SEND_STATUS_RECOVERY;
+		iscsi_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+		begrun++;
+	}
+
+	return 0;
+}
+
+/*	iscsi_handle_data_ack():
+ *
+ *
+ */
+int iscsi_handle_data_ack(
+	struct iscsi_conn *conn,
+	u32 targ_xfer_tag,
+	u32 begrun,
+	u32 runlength)
+{
+	struct iscsi_cmd *cmd =3D NULL;
+
+	cmd =3D iscsi_find_cmd_from_ttt(conn, targ_xfer_tag);
+	if (!cmd) {
+		printk(KERN_ERR "Data ACK SNACK for TTT: 0x%08x is"
+			" invalid.\n", targ_xfer_tag);
+		return -1;
+	}
+
+	if (begrun <=3D cmd->acked_data_sn) {
+		printk(KERN_ERR "ITT: 0x%08x Data ACK SNACK BegRUN: 0x%08x is"
+			" less than the already acked DataSN: 0x%08x.\n",
+			cmd->init_task_tag, begrun, cmd->acked_data_sn);
+		return -1;
+	}
+
+	/*
+	 * For Data ACK SNACK, BegRun is the next expected DataSN.
+	 * (see iSCSI v19: 10.16.6)
+	 */
+	cmd->cmd_flags |=3D ICF_GOT_DATACK_SNACK;
+	cmd->acked_data_sn =3D (begrun - 1);
+
+	TRACE(TRACE_ISCSI, "Received Data ACK SNACK for ITT: 0x%08x,"
+		" updated acked DataSN to 0x%08x.\n",
+			cmd->init_task_tag, cmd->acked_data_sn);
+
+	return 0;
+}
+
+/*	iscsi_send_recovery_r2t():
+ *
+ *
+ */
+static int iscsi_send_recovery_r2t(
+	struct iscsi_cmd *cmd,
+	u32 offset,
+	u32 xfer_len)
+{
+	int ret;
+
+	spin_lock_bh(&cmd->r2t_lock);
+	ret =3D iscsi_add_r2t_to_list(cmd, offset, xfer_len, 1, 0);
+	spin_unlock_bh(&cmd->r2t_lock);
+
+	return ret;
+}
+
+/*	iscsi_dataout_datapduinorder_no_fbit():
+ *
+ *
+ */
+int iscsi_dataout_datapduinorder_no_fbit(
+	struct iscsi_cmd *cmd,
+	struct iscsi_pdu *pdu)
+{
+	int i, send_recovery_r2t =3D 0, recovery =3D 0;
+	u32 length =3D 0, offset =3D 0, pdu_count =3D 0, xfer_len =3D 0;
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_pdu *first_pdu =3D NULL;
+
+	/*
+	 * Get an struct iscsi_pdu pointer to the first PDU, and total PDU co=
unt
+	 * of the DataOUT sequence.
+	 */
+	if (conn->sess->sess_ops->DataSequenceInOrder) {
+		for (i =3D 0; i < cmd->pdu_count; i++) {
+			if (cmd->pdu_list[i].seq_no =3D=3D pdu->seq_no) {
+				if (!first_pdu)
+					first_pdu =3D &cmd->pdu_list[i];
+				 xfer_len +=3D cmd->pdu_list[i].length;
+				 pdu_count++;
+			} else if (pdu_count)
+				break;
+		}
+	} else {
+		struct iscsi_seq *seq =3D cmd->seq_ptr;
+
+		first_pdu =3D &cmd->pdu_list[seq->pdu_start];
+		pdu_count =3D seq->pdu_count;
+	}
+
+	if (!first_pdu || !pdu_count)
+		return DATAOUT_CANNOT_RECOVER;
+
+	/*
+	 * Loop through the ending DataOUT Sequence checking each struct iscs=
i_pdu.
+	 * The following ugly logic does batching of not received PDUs.
+	 */
+	for (i =3D 0; i < pdu_count; i++) {
+		if (first_pdu[i].status =3D=3D ISCSI_PDU_RECEIVED_OK) {
+			if (!send_recovery_r2t)
+				continue;
+
+			if (iscsi_send_recovery_r2t(cmd, offset, length) < 0)
+				return DATAOUT_CANNOT_RECOVER;
+
+			send_recovery_r2t =3D length =3D offset =3D 0;
+			continue;
+		}
+		/*
+		 * Set recovery =3D 1 for any missing, CRC failed, or timed
+		 * out PDUs to let the DataOUT logic know that this sequence
+		 * has not been completed yet.
+		 *
+		 * Also, only send a Recovery R2T for ISCSI_PDU_NOT_RECEIVED.
+		 * We assume if the PDU either failed CRC or timed out
+		 * that a Recovery R2T has already been sent.
+		 */
+		recovery =3D 1;
+
+		if (first_pdu[i].status !=3D ISCSI_PDU_NOT_RECEIVED)
+			continue;
+
+		if (!offset)
+			offset =3D first_pdu[i].offset;
+		length +=3D first_pdu[i].length;
+
+		send_recovery_r2t =3D 1;
+	}
+
+	if (send_recovery_r2t)
+		if (iscsi_send_recovery_r2t(cmd, offset, length) < 0)
+			return DATAOUT_CANNOT_RECOVER;
+
+	return (!recovery) ? DATAOUT_NORMAL : DATAOUT_WITHIN_COMMAND_RECOVERY=
;
+}
+
+/*	iscsi_recalculate_dataout_values():
+ *
+ *
+ */
+static int iscsi_recalculate_dataout_values(
+	struct iscsi_cmd *cmd,
+	u32 pdu_offset,
+	u32 pdu_length,
+	u32 *r2t_offset,
+	u32 *r2t_length)
+{
+	int i;
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_pdu *pdu =3D NULL;
+
+	if (conn->sess->sess_ops->DataSequenceInOrder) {
+		cmd->data_sn =3D 0;
+
+		if (conn->sess->sess_ops->DataPDUInOrder) {
+			*r2t_offset =3D cmd->write_data_done;
+			*r2t_length =3D (cmd->seq_end_offset -
+					cmd->write_data_done);
+			return 0;
+		}
+
+		*r2t_offset =3D cmd->seq_start_offset;
+		*r2t_length =3D (cmd->seq_end_offset - cmd->seq_start_offset);
+
+		for (i =3D 0; i < cmd->pdu_count; i++) {
+			pdu =3D &cmd->pdu_list[i];
+
+			if (pdu->status !=3D ISCSI_PDU_RECEIVED_OK)
+				continue;
+
+			if ((pdu->offset >=3D cmd->seq_start_offset) &&
+			   ((pdu->offset + pdu->length) <=3D
+			     cmd->seq_end_offset)) {
+				if (!cmd->unsolicited_data)
+					cmd->next_burst_len -=3D pdu->length;
+				else
+					cmd->first_burst_len -=3D pdu->length;
+
+				cmd->write_data_done -=3D pdu->length;
+				pdu->status =3D ISCSI_PDU_NOT_RECEIVED;
+			}
+		}
+	} else {
+		struct iscsi_seq *seq =3D NULL;
+
+		seq =3D iscsi_get_seq_holder(cmd, pdu_offset, pdu_length);
+		if (!seq)
+			return -1;
+
+		*r2t_offset =3D seq->orig_offset;
+		*r2t_length =3D seq->xfer_len;
+
+		cmd->write_data_done -=3D (seq->offset - seq->orig_offset);
+		if (cmd->immediate_data)
+			cmd->first_burst_len =3D cmd->write_data_done;
+
+		seq->data_sn =3D 0;
+		seq->offset =3D seq->orig_offset;
+		seq->next_burst_len =3D 0;
+		seq->status =3D DATAOUT_SEQUENCE_WITHIN_COMMAND_RECOVERY;
+
+		if (conn->sess->sess_ops->DataPDUInOrder)
+			return 0;
+
+		for (i =3D 0; i < seq->pdu_count; i++) {
+			pdu =3D &cmd->pdu_list[i+seq->pdu_start];
+
+			if (pdu->status !=3D ISCSI_PDU_RECEIVED_OK)
+				continue;
+
+			pdu->status =3D ISCSI_PDU_NOT_RECEIVED;
+		}
+	}
+
+	return 0;
+}
+
+/*	iscsi_recover_dataout_crc_sequence():
+ *
+ *
+ */
+int iscsi_recover_dataout_sequence(
+	struct iscsi_cmd *cmd,
+	u32 pdu_offset,
+	u32 pdu_length)
+{
+	u32 r2t_length =3D 0, r2t_offset =3D 0;
+
+	spin_lock_bh(&cmd->istate_lock);
+	cmd->cmd_flags |=3D ICF_WITHIN_COMMAND_RECOVERY;
+	spin_unlock_bh(&cmd->istate_lock);
+
+	if (iscsi_recalculate_dataout_values(cmd, pdu_offset, pdu_length,
+			&r2t_offset, &r2t_length) < 0)
+		return DATAOUT_CANNOT_RECOVER;
+
+	iscsi_send_recovery_r2t(cmd, r2t_offset, r2t_length);
+
+	return DATAOUT_WITHIN_COMMAND_RECOVERY;
+}
+
+/*	iscsi_allocate_ooo_cmdsn():
+ *
+ *
+ */
+static inline struct iscsi_ooo_cmdsn *iscsi_allocate_ooo_cmdsn(void)
+{
+	struct iscsi_ooo_cmdsn *ooo_cmdsn =3D NULL;
+
+	ooo_cmdsn =3D kmem_cache_zalloc(lio_ooo_cache, GFP_ATOMIC);
+	if (!ooo_cmdsn) {
+		printk(KERN_ERR "Unable to allocate memory for"
+			" struct iscsi_ooo_cmdsn.\n");
+		return NULL;
+	}
+	INIT_LIST_HEAD(&ooo_cmdsn->ooo_list);
+
+	return ooo_cmdsn;
+}
+
+/*	iscsi_attach_ooo_cmdsn():
+ *
+ *	Called with sess->cmdsn_lock held.
+ */
+static inline int iscsi_attach_ooo_cmdsn(
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
+		ooo_tail =3D list_entry(sess->sess_ooo_cmdsn_list.prev,
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
+	sess->ooo_cmdsn_count++;
+
+	TRACE(TRACE_CMDSN, "Set out of order CmdSN count for SID:"
+		" %u to %hu.\n", sess->sid, sess->ooo_cmdsn_count);
+
+	return 0;
+}
+
+/*	iscsi_remove_ooo_cmdsn()
+ *
+ *	Removes an struct iscsi_ooo_cmdsn from a session's list,
+ *	called with struct iscsi_session->cmdsn_lock held.
+ */
+void iscsi_remove_ooo_cmdsn(
+	struct iscsi_session *sess,
+	struct iscsi_ooo_cmdsn *ooo_cmdsn)
+{
+	list_del(&ooo_cmdsn->ooo_list);
+	kmem_cache_free(lio_ooo_cache, ooo_cmdsn);
+}
+
+/*	iscsi_clear_ooo_cmdsns_for_conn():
+ *
+ *
+ */
+void iscsi_clear_ooo_cmdsns_for_conn(struct iscsi_conn *conn)
+{
+	struct iscsi_ooo_cmdsn *ooo_cmdsn;
+	struct iscsi_session *sess =3D conn->sess;
+
+	spin_lock(&sess->cmdsn_lock);
+	list_for_each_entry(ooo_cmdsn, &sess->sess_ooo_cmdsn_list, ooo_list) =
{
+		if (ooo_cmdsn->cid !=3D conn->cid)
+			continue;
+
+		ooo_cmdsn->cmd =3D NULL;
+	}
+	spin_unlock(&sess->cmdsn_lock);
+}
+
+/*	iscsi_execute_ooo_cmdsns():
+ *
+ *	Called with sess->cmdsn_lock held.
+ */
+int iscsi_execute_ooo_cmdsns(struct iscsi_session *sess)
+{
+	int ooo_count =3D 0;
+	struct iscsi_cmd *cmd =3D NULL;
+	struct iscsi_ooo_cmdsn *ooo_cmdsn, *ooo_cmdsn_tmp;
+
+	list_for_each_entry_safe(ooo_cmdsn, ooo_cmdsn_tmp,
+				&sess->sess_ooo_cmdsn_list, ooo_list) {
+		if (ooo_cmdsn->cmdsn !=3D sess->exp_cmd_sn)
+			continue;
+
+		if (!ooo_cmdsn->cmd) {
+			sess->exp_cmd_sn++;
+			iscsi_remove_ooo_cmdsn(sess, ooo_cmdsn);
+			continue;
+		}
+
+		cmd =3D ooo_cmdsn->cmd;
+		cmd->i_state =3D cmd->deferred_i_state;
+		ooo_count++;
+		sess->exp_cmd_sn++;
+		TRACE(TRACE_CMDSN, "Executing out of order CmdSN: 0x%08x,"
+			" incremented ExpCmdSN to 0x%08x.\n",
+			cmd->cmd_sn, sess->exp_cmd_sn);
+
+		iscsi_remove_ooo_cmdsn(sess, ooo_cmdsn);
+
+		if (iscsi_execute_cmd(cmd, 1) < 0)
+			return -1;
+
+		continue;
+	}
+
+	return ooo_count;
+}
+
+/*	iscsi_execute_cmd():
+ *
+ *	Called either:
+ *
+ *	1. With sess->cmdsn_lock held from iscsi_execute_ooo_cmdsns()
+ *	or iscsi_check_received_cmdsn().
+ *	2. With no locks held directly from iscsi_handle_XXX_pdu() function=
s
+ *	for immediate commands.
+ */
+int iscsi_execute_cmd(struct iscsi_cmd *cmd, int ooo)
+{
+	struct se_cmd *se_cmd =3D &cmd->se_cmd;
+	int lr =3D 0;
+
+	spin_lock_bh(&cmd->istate_lock);
+	if (ooo)
+		cmd->cmd_flags &=3D ~ICF_OOO_CMDSN;
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
+				cmd->i_state =3D ISTATE_SEND_STATUS;
+				spin_unlock_bh(&cmd->istate_lock);
+				iscsi_add_cmd_to_response_queue(cmd, cmd->conn,
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
+					(cmd->unsolicited_data =3D=3D 0)) !=3D 0)
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
+						!=3D 0)
+					return 0;
+
+				iscsi_set_dataout_sequence_values(cmd);
+				iscsi_build_r2ts_for_cmd(cmd, cmd->conn, 0);
+			}
+			return 0;
+		}
+		/*
+		 * The default handler.
+		 */
+		spin_unlock_bh(&cmd->istate_lock);
+
+		if ((cmd->data_direction =3D=3D DMA_TO_DEVICE) &&
+		    !(cmd->cmd_flags & ICF_NON_IMMEDIATE_UNSOLICITED_DATA)) {
+			/*
+			 * Send the delayed TASK_ABORTED status for WRITEs if
+			 * no more nsolicitied data is expected.
+			 */
+			if (transport_check_aborted_status(se_cmd, 1) !=3D 0)
+				return 0;
+
+			iscsi_set_dataout_sequence_values(cmd);
+			spin_lock_bh(&cmd->dataout_timeout_lock);
+			iscsi_start_dataout_timer(cmd, cmd->conn);
+			spin_unlock_bh(&cmd->dataout_timeout_lock);
+		}
+		return transport_generic_handle_cdb(&cmd->se_cmd);
+
+	case ISCSI_OP_NOOP_OUT:
+	case ISCSI_OP_TEXT:
+		spin_unlock_bh(&cmd->istate_lock);
+		iscsi_add_cmd_to_response_queue(cmd, cmd->conn, cmd->i_state);
+		break;
+	case ISCSI_OP_SCSI_TMFUNC:
+		if (se_cmd->se_cmd_flags & SCF_SCSI_CDB_EXCEPTION) {
+			spin_unlock_bh(&cmd->istate_lock);
+			iscsi_add_cmd_to_response_queue(cmd, cmd->conn,
+					cmd->i_state);
+			return 0;
+		}
+		spin_unlock_bh(&cmd->istate_lock);
+
+		return transport_generic_handle_tmr(SE_CMD(cmd));
+	case ISCSI_OP_LOGOUT:
+		spin_unlock_bh(&cmd->istate_lock);
+		switch (cmd->logout_reason) {
+		case ISCSI_LOGOUT_REASON_CLOSE_SESSION:
+			lr =3D iscsi_logout_closesession(cmd, cmd->conn);
+			break;
+		case ISCSI_LOGOUT_REASON_CLOSE_CONNECTION:
+			lr =3D iscsi_logout_closeconnection(cmd, cmd->conn);
+			break;
+		case ISCSI_LOGOUT_REASON_RECOVERY:
+			lr =3D iscsi_logout_removeconnforrecovery(cmd, cmd->conn);
+			break;
+		default:
+			printk(KERN_ERR "Unknown iSCSI Logout Request Code:"
+				" 0x%02x\n", cmd->logout_reason);
+			return -1;
+		}
+
+		return lr;
+	default:
+		spin_unlock_bh(&cmd->istate_lock);
+		printk(KERN_ERR "Cannot perform out of order execution for"
+		" unknown iSCSI Opcode: 0x%02x\n", cmd->iscsi_opcode);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*	iscsi_free_all_ooo_cmdsns():
+ *
+ *
+ */
+void iscsi_free_all_ooo_cmdsns(struct iscsi_session *sess)
+{
+	struct iscsi_ooo_cmdsn *ooo_cmdsn, *ooo_cmdsn_tmp;
+
+	spin_lock(&sess->cmdsn_lock);
+	list_for_each_entry_safe(ooo_cmdsn, ooo_cmdsn_tmp,
+			&sess->sess_ooo_cmdsn_list, ooo_list) {
+
+		list_del(&ooo_cmdsn->ooo_list);
+		kmem_cache_free(lio_ooo_cache, ooo_cmdsn);
+	}
+	spin_unlock(&sess->cmdsn_lock);
+}
+
+/*	iscsi_handle_ooo_cmdsn():
+ *
+ *
+ */
+int iscsi_handle_ooo_cmdsn(
+	struct iscsi_session *sess,
+	struct iscsi_cmd *cmd,
+	u32 cmdsn)
+{
+	int batch =3D 0;
+	struct iscsi_ooo_cmdsn *ooo_cmdsn =3D NULL, *ooo_tail =3D NULL;
+
+	sess->cmdsn_outoforder =3D 1;
+
+	cmd->deferred_i_state		=3D cmd->i_state;
+	cmd->i_state			=3D ISTATE_DEFERRED_CMD;
+	cmd->cmd_flags			|=3D ICF_OOO_CMDSN;
+
+	if (list_empty(&sess->sess_ooo_cmdsn_list))
+		batch =3D 1;
+	else {
+		ooo_tail =3D list_entry(sess->sess_ooo_cmdsn_list.prev,
+				typeof(*ooo_tail), ooo_list);
+		if (ooo_tail->cmdsn !=3D (cmdsn - 1))
+			batch =3D 1;
+	}
+
+	ooo_cmdsn =3D iscsi_allocate_ooo_cmdsn();
+	if (!ooo_cmdsn)
+		return CMDSN_ERROR_CANNOT_RECOVER;
+
+	ooo_cmdsn->cmd			=3D cmd;
+	ooo_cmdsn->batch_count		=3D (batch) ?
+					  (cmdsn - sess->exp_cmd_sn) : 1;
+	ooo_cmdsn->cid			=3D cmd->conn->cid;
+	ooo_cmdsn->exp_cmdsn		=3D sess->exp_cmd_sn;
+	ooo_cmdsn->cmdsn		=3D cmdsn;
+
+	if (iscsi_attach_ooo_cmdsn(sess, ooo_cmdsn) < 0) {
+		kmem_cache_free(lio_ooo_cache, ooo_cmdsn);
+		return CMDSN_ERROR_CANNOT_RECOVER;
+	}
+
+	return CMDSN_HIGHER_THAN_EXP;
+}
+
+/*	 iscsi_set_dataout_timeout_values():
+ *
+ *
+ */
+static int iscsi_set_dataout_timeout_values(
+	struct iscsi_cmd *cmd,
+	u32 *offset,
+	u32 *length)
+{
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_r2t *r2t;
+
+	if (cmd->unsolicited_data) {
+		*offset =3D 0;
+		*length =3D (conn->sess->sess_ops->FirstBurstLength >
+			   cmd->data_length) ?
+			   cmd->data_length :
+			   conn->sess->sess_ops->FirstBurstLength;
+		return 0;
+	}
+
+	spin_lock_bh(&cmd->r2t_lock);
+	if (list_empty(&cmd->cmd_r2t_list)) {
+		printk(KERN_ERR "cmd->cmd_r2t_list is empty!\n");
+		spin_unlock_bh(&cmd->r2t_lock);
+		return -1;
+	}
+
+	list_for_each_entry(r2t, &cmd->cmd_r2t_list, r2t_list)
+		if (r2t->sent_r2t && !r2t->recovery_r2t && !r2t->seq_complete)
+			break;
+
+	if (!r2t) {
+		printk(KERN_ERR "Unable to locate any incomplete DataOUT"
+			" sequences for ITT: 0x%08x.\n", cmd->init_task_tag);
+		spin_unlock_bh(&cmd->r2t_lock);
+		return -1;
+	}
+
+	*offset =3D r2t->offset;
+	*length =3D r2t->xfer_len;
+
+	spin_unlock_bh(&cmd->r2t_lock);
+	return 0;
+}
+
+/*	iscsi_handle_dataout_timeout():
+ *
+ *	NOTE: Called from interrupt (timer) context.
+ */
+static void iscsi_handle_dataout_timeout(unsigned long data)
+{
+	u32 pdu_length =3D 0, pdu_offset =3D 0;
+	u32 r2t_length =3D 0, r2t_offset =3D 0;
+	struct iscsi_cmd *cmd =3D (struct iscsi_cmd *) data;
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_session *sess =3D NULL;
+	struct iscsi_node_attrib *na;
+
+	iscsi_inc_conn_usage_count(conn);
+
+	spin_lock_bh(&cmd->dataout_timeout_lock);
+	if (cmd->dataout_timer_flags & ISCSI_TF_STOP) {
+		spin_unlock_bh(&cmd->dataout_timeout_lock);
+		iscsi_dec_conn_usage_count(conn);
+		return;
+	}
+	cmd->dataout_timer_flags &=3D ~ISCSI_TF_RUNNING;
+	sess =3D conn->sess;
+	na =3D iscsi_tpg_get_node_attrib(sess);
+
+	if (!sess->sess_ops->ErrorRecoveryLevel) {
+		TRACE(TRACE_ERL0, "Unable to recover from DataOut timeout while"
+			" in ERL=3D0.\n");
+		goto failure;
+	}
+
+	if (++cmd->dataout_timeout_retries =3D=3D na->dataout_timeout_retries=
) {
+		TRACE(TRACE_TIMER, "Command ITT: 0x%08x exceeded max retries"
+			" for DataOUT timeout %u, closing iSCSI connection.\n",
+			cmd->init_task_tag, na->dataout_timeout_retries);
+		goto failure;
+	}
+
+	cmd->cmd_flags |=3D ICF_WITHIN_COMMAND_RECOVERY;
+
+	if (conn->sess->sess_ops->DataSequenceInOrder) {
+		if (conn->sess->sess_ops->DataPDUInOrder) {
+			pdu_offset =3D cmd->write_data_done;
+			if ((pdu_offset + (conn->sess->sess_ops->MaxBurstLength -
+			     cmd->next_burst_len)) > cmd->data_length)
+				pdu_length =3D (cmd->data_length -
+					cmd->write_data_done);
+			else
+				pdu_length =3D (conn->sess->sess_ops->MaxBurstLength -
+						cmd->next_burst_len);
+		} else {
+			pdu_offset =3D cmd->seq_start_offset;
+			pdu_length =3D (cmd->seq_end_offset -
+				cmd->seq_start_offset);
+		}
+	} else {
+		if (iscsi_set_dataout_timeout_values(cmd, &pdu_offset,
+				&pdu_length) < 0)
+			goto failure;
+	}
+
+	if (iscsi_recalculate_dataout_values(cmd, pdu_offset, pdu_length,
+			&r2t_offset, &r2t_length) < 0)
+		goto failure;
+
+	TRACE(TRACE_TIMER, "Command ITT: 0x%08x timed out waiting for"
+		" completion of %sDataOUT Sequence Offset: %u, Length: %u\n",
+		cmd->init_task_tag, (cmd->unsolicited_data) ? "Unsolicited " :
+		"", r2t_offset, r2t_length);
+
+	if (iscsi_send_recovery_r2t(cmd, r2t_offset, r2t_length) < 0)
+		goto failure;
+
+	iscsi_start_dataout_timer(cmd, conn);
+	spin_unlock_bh(&cmd->dataout_timeout_lock);
+	iscsi_dec_conn_usage_count(conn);
+
+	return;
+
+failure:
+	spin_unlock_bh(&cmd->dataout_timeout_lock);
+	iscsi_cause_connection_reinstatement(conn, 0);
+	iscsi_dec_conn_usage_count(conn);
+
+	return;
+}
+
+/*	iscsi_mod_dataout_timer():
+ *
+ *
+ */
+void iscsi_mod_dataout_timer(struct iscsi_cmd *cmd)
+{
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_session *sess =3D conn->sess;
+	struct iscsi_node_attrib *na =3D na =3D iscsi_tpg_get_node_attrib(ses=
s);
+
+	spin_lock_bh(&cmd->dataout_timeout_lock);
+	if (!(cmd->dataout_timer_flags & ISCSI_TF_RUNNING)) {
+		spin_unlock_bh(&cmd->dataout_timeout_lock);
+		return;
+	}
+
+	mod_timer(&cmd->dataout_timer,
+		(get_jiffies_64() + na->dataout_timeout * HZ));
+	TRACE(TRACE_TIMER, "Updated DataOUT timer for ITT: 0x%08x",
+			cmd->init_task_tag);
+	spin_unlock_bh(&cmd->dataout_timeout_lock);
+}
+
+/*	iscsi_start_dataout_timer():
+ *
+ *	Called with cmd->dataout_timeout_lock held.
+ */
+void iscsi_start_dataout_timer(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	struct iscsi_session *sess =3D conn->sess;
+	struct iscsi_node_attrib *na =3D na =3D iscsi_tpg_get_node_attrib(ses=
s);
+
+	if (cmd->dataout_timer_flags & ISCSI_TF_RUNNING)
+		return;
+
+	TRACE(TRACE_TIMER, "Starting DataOUT timer for ITT: 0x%08x on"
+		" CID: %hu.\n", cmd->init_task_tag, conn->cid);
+
+	init_timer(&cmd->dataout_timer);
+	cmd->dataout_timer.expires =3D (get_jiffies_64() + na->dataout_timeou=
t * HZ);
+	cmd->dataout_timer.data =3D (unsigned long)cmd;
+	cmd->dataout_timer.function =3D iscsi_handle_dataout_timeout;
+	cmd->dataout_timer_flags &=3D ~ISCSI_TF_STOP;
+	cmd->dataout_timer_flags |=3D ISCSI_TF_RUNNING;
+	add_timer(&cmd->dataout_timer);
+}
+
+/*	iscsi_stop_dataout_timer():
+ *
+ *
+ */
+void iscsi_stop_dataout_timer(struct iscsi_cmd *cmd)
+{
+	spin_lock_bh(&cmd->dataout_timeout_lock);
+	if (!(cmd->dataout_timer_flags & ISCSI_TF_RUNNING)) {
+		spin_unlock_bh(&cmd->dataout_timeout_lock);
+		return;
+	}
+	cmd->dataout_timer_flags |=3D ISCSI_TF_STOP;
+	spin_unlock_bh(&cmd->dataout_timeout_lock);
+
+	del_timer_sync(&cmd->dataout_timer);
+
+	spin_lock_bh(&cmd->dataout_timeout_lock);
+	cmd->dataout_timer_flags &=3D ~ISCSI_TF_RUNNING;
+	TRACE(TRACE_TIMER, "Stopped DataOUT Timer for ITT: 0x%08x\n",
+			cmd->init_task_tag);
+	spin_unlock_bh(&cmd->dataout_timeout_lock);
+}
diff --git a/drivers/target/iscsi/iscsi_target_erl1.h b/drivers/target/=
iscsi/iscsi_target_erl1.h
new file mode 100644
index 0000000..67aa37d
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_erl1.h
@@ -0,0 +1,35 @@
+#ifndef ISCSI_TARGET_ERL1_H
+#define ISCSI_TARGET_ERL1_H
+
+extern int iscsi_dump_data_payload(struct iscsi_conn *, u32, int);
+extern int iscsi_create_recovery_datain_values_datasequenceinorder_yes=
(
+			struct iscsi_cmd *, struct iscsi_datain_req *);
+extern int iscsi_create_recovery_datain_values_datasequenceinorder_no(
+			struct iscsi_cmd *, struct iscsi_datain_req *);
+extern int iscsi_handle_recovery_datain_or_r2t(struct iscsi_conn *, un=
signed char *,
+			u32, u32, u32, u32);
+extern int iscsi_handle_status_snack(struct iscsi_conn *, u32, u32,
+			u32, u32);
+extern int iscsi_handle_data_ack(struct iscsi_conn *, u32, u32, u32);
+extern int iscsi_dataout_datapduinorder_no_fbit(struct iscsi_cmd *, st=
ruct iscsi_pdu *);
+extern int iscsi_recover_dataout_sequence(struct iscsi_cmd *, u32, u32=
);
+extern void iscsi_clear_ooo_cmdsns_for_conn(struct iscsi_conn *);
+extern void iscsi_free_all_ooo_cmdsns(struct iscsi_session *);
+extern int iscsi_execute_ooo_cmdsns(struct iscsi_session *);
+extern int iscsi_execute_cmd(struct iscsi_cmd *, int);
+extern int iscsi_handle_ooo_cmdsn(struct iscsi_session *, struct iscsi=
_cmd *, u32);
+extern void iscsi_remove_ooo_cmdsn(struct iscsi_session *, struct iscs=
i_ooo_cmdsn *);
+extern void iscsi_mod_dataout_timer(struct iscsi_cmd *);
+extern void iscsi_start_dataout_timer(struct iscsi_cmd *, struct iscsi=
_conn *);
+extern void iscsi_stop_dataout_timer(struct iscsi_cmd *);
+
+extern struct kmem_cache *lio_ooo_cache;
+
+extern int iscsi_add_reject_from_cmd(u8, int, int, unsigned char *,
+			struct iscsi_cmd *);
+extern int iscsi_build_r2ts_for_cmd(struct iscsi_cmd *, struct iscsi_c=
onn *, int);
+extern int iscsi_logout_closesession(struct iscsi_cmd *, struct iscsi_=
conn *);
+extern int iscsi_logout_closeconnection(struct iscsi_cmd *, struct isc=
si_conn *);
+extern int iscsi_logout_removeconnforrecovery(struct iscsi_cmd *, stru=
ct iscsi_conn *);
+
+#endif /* ISCSI_TARGET_ERL1_H */
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/=
iscsi/iscsi_target_erl2.c
new file mode 100644
index 0000000..c4d0d0f
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -0,0 +1,529 @@
+/*********************************************************************=
**********
+ * This file contains error recovery level two functions used by
+ * the iSCSI Target driver.
+ *
+ * =C2=A9 Copyright 2007-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (=
GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *********************************************************************=
*********/
+
+#include <scsi/iscsi_proto.h>
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+
+#include "iscsi_target_debug.h"
+#include "iscsi_target_core.h"
+#include "iscsi_target_datain_values.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target_erl0.h"
+#include "iscsi_target_erl1.h"
+#include "iscsi_target_erl2.h"
+
+/*	iscsi_create_conn_recovery_datain_values():
+ *
+ *	FIXME: Does RData SNACK apply here as well?
+ */
+void iscsi_create_conn_recovery_datain_values(
+	struct iscsi_cmd *cmd,
+	u32 exp_data_sn)
+{
+	u32 data_sn =3D 0;
+	struct iscsi_conn *conn =3D cmd->conn;
+
+	cmd->next_burst_len =3D 0;
+	cmd->read_data_done =3D 0;
+
+	while (exp_data_sn > data_sn) {
+		if ((cmd->next_burst_len +
+		     conn->conn_ops->MaxRecvDataSegmentLength) <
+		     conn->sess->sess_ops->MaxBurstLength) {
+			cmd->read_data_done +=3D
+			       conn->conn_ops->MaxRecvDataSegmentLength;
+			cmd->next_burst_len +=3D
+			       conn->conn_ops->MaxRecvDataSegmentLength;
+		} else {
+			cmd->read_data_done +=3D
+				(conn->sess->sess_ops->MaxBurstLength -
+				cmd->next_burst_len);
+			cmd->next_burst_len =3D 0;
+		}
+		data_sn++;
+	}
+}
+
+/*	iscsi_create_conn_recovery_dataout_values():
+ *
+ *
+ */
+void iscsi_create_conn_recovery_dataout_values(
+	struct iscsi_cmd *cmd)
+{
+	u32 write_data_done =3D 0;
+	struct iscsi_conn *conn =3D cmd->conn;
+
+	cmd->data_sn =3D 0;
+	cmd->next_burst_len =3D 0;
+
+	while (cmd->write_data_done > write_data_done) {
+		if ((write_data_done + conn->sess->sess_ops->MaxBurstLength) <=3D
+		     cmd->write_data_done)
+			write_data_done +=3D conn->sess->sess_ops->MaxBurstLength;
+		else
+			break;
+	}
+
+	cmd->write_data_done =3D write_data_done;
+}
+
+/*	iscsi_attach_active_connection_recovery_entry():
+ *
+ *
+ */
+static int iscsi_attach_active_connection_recovery_entry(
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
+/*	iscsi_attach_inactive_connection_recovery():
+ *
+ *
+ */
+static int iscsi_attach_inactive_connection_recovery_entry(
+	struct iscsi_session *sess,
+	struct iscsi_conn_recovery *cr)
+{
+	spin_lock(&sess->cr_i_lock);
+	list_add_tail(&cr->cr_list, &sess->cr_inactive_list);
+
+	sess->conn_recovery_count++;
+	TRACE(TRACE_ERL2, "Incremented connection recovery count to %u for"
+		" SID: %u\n", sess->conn_recovery_count, sess->sid);
+	spin_unlock(&sess->cr_i_lock);
+
+	return 0;
+}
+
+/*	iscsi_get_inactive_connection_recovery_entry():
+ *
+ *
+ */
+struct iscsi_conn_recovery *iscsi_get_inactive_connection_recovery_ent=
ry(
+	struct iscsi_session *sess,
+	u16 cid)
+{
+	struct iscsi_conn_recovery *cr;
+
+	spin_lock(&sess->cr_i_lock);
+	list_for_each_entry(cr, &sess->cr_inactive_list, cr_list) {
+		if (cr->cid =3D=3D cid)
+			break;
+	}
+	spin_unlock(&sess->cr_i_lock);
+
+	return (cr) ? cr : NULL;
+}
+
+/*	iscsi_free_connection_recovery_entires():
+ *
+ *
+ */
+void iscsi_free_connection_recovery_entires(struct iscsi_session *sess=
)
+{
+	struct iscsi_cmd *cmd, *cmd_tmp;
+	struct iscsi_conn_recovery *cr, *cr_tmp;
+
+	spin_lock(&sess->cr_a_lock);
+	list_for_each_entry_safe(cr, cr_tmp, &sess->cr_active_list, cr_list) =
{
+		list_del(&cr->cr_list);
+		spin_unlock(&sess->cr_a_lock);
+
+		spin_lock(&cr->conn_recovery_cmd_lock);
+		list_for_each_entry_safe(cmd, cmd_tmp,
+				&cr->conn_recovery_cmd_list, i_list) {
+
+			list_del(&cmd->i_list);
+			cmd->conn =3D NULL;
+			spin_unlock(&cr->conn_recovery_cmd_lock);
+			if (!(SE_CMD(cmd)) ||
+			    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
+			    !(SE_CMD(cmd)->transport_wait_for_tasks))
+				__iscsi_release_cmd_to_pool(cmd, sess);
+			else
+				SE_CMD(cmd)->transport_wait_for_tasks(
+						SE_CMD(cmd), 1, 1);
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
+	list_for_each_entry_safe(cr, cr_tmp, &sess->cr_inactive_list, cr_list=
) {
+		list_del(&cr->cr_list);
+		spin_unlock(&sess->cr_i_lock);
+
+		spin_lock(&cr->conn_recovery_cmd_lock);
+		list_for_each_entry_safe(cmd, cmd_tmp,
+				&cr->conn_recovery_cmd_list, i_list) {
+
+			list_del(&cmd->i_list);
+			cmd->conn =3D NULL;
+			spin_unlock(&cr->conn_recovery_cmd_lock);
+			if (!(SE_CMD(cmd)) ||
+			    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
+			    !(SE_CMD(cmd)->transport_wait_for_tasks))
+				__iscsi_release_cmd_to_pool(cmd, sess);
+			else
+				SE_CMD(cmd)->transport_wait_for_tasks(
+						SE_CMD(cmd), 1, 1);
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
+/*	iscsi_remove_active_connection_recovery_entry():
+ *
+ *
+ */
+int iscsi_remove_active_connection_recovery_entry(
+	struct iscsi_conn_recovery *cr,
+	struct iscsi_session *sess)
+{
+	spin_lock(&sess->cr_a_lock);
+	list_del(&cr->cr_list);
+
+	sess->conn_recovery_count--;
+	TRACE(TRACE_ERL2, "Decremented connection recovery count to %u for"
+		" SID: %u\n", sess->conn_recovery_count, sess->sid);
+	spin_unlock(&sess->cr_a_lock);
+
+	kfree(cr);
+
+	return 0;
+}
+
+/*	iscsi_remove_inactive_connection_recovery_entry():
+ *
+ *
+ */
+int iscsi_remove_inactive_connection_recovery_entry(
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
+/*	iscsi_remove_cmd_from_connection_recovery():
+ *
+ *	Called with cr->conn_recovery_cmd_lock help.
+ */
+int iscsi_remove_cmd_from_connection_recovery(
+	struct iscsi_cmd *cmd,
+	struct iscsi_session *sess)
+{
+	struct iscsi_conn_recovery *cr;
+
+	if (!cmd->cr) {
+		printk(KERN_ERR "struct iscsi_conn_recovery pointer for ITT: 0x%08x"
+			" is NULL!\n", cmd->init_task_tag);
+		BUG();
+	}
+	cr =3D cmd->cr;
+
+	list_del(&cmd->i_list);
+	return --cr->cmd_count;
+}
+
+/*	iscsi_discard_cr_cmds_by_expstatsn():
+ *
+ *
+ */
+void iscsi_discard_cr_cmds_by_expstatsn(
+	struct iscsi_conn_recovery *cr,
+	u32 exp_statsn)
+{
+	u32 dropped_count =3D 0;
+	struct iscsi_cmd *cmd, *cmd_tmp;
+	struct iscsi_session *sess =3D cr->sess;
+
+	spin_lock(&cr->conn_recovery_cmd_lock);
+	list_for_each_entry_safe(cmd, cmd_tmp,
+			&cr->conn_recovery_cmd_list, i_list) {
+
+		if (((cmd->deferred_i_state !=3D ISTATE_SENT_STATUS) &&
+		     (cmd->deferred_i_state !=3D ISTATE_REMOVE)) ||
+		     (cmd->stat_sn >=3D exp_statsn)) {
+			continue;
+		}
+
+		dropped_count++;
+		TRACE(TRACE_ERL2, "Dropping Acknowledged ITT: 0x%08x, StatSN:"
+			" 0x%08x, CID: %hu.\n", cmd->init_task_tag,
+				cmd->stat_sn, cr->cid);
+
+		iscsi_remove_cmd_from_connection_recovery(cmd, sess);
+
+		spin_unlock(&cr->conn_recovery_cmd_lock);
+		if (!(SE_CMD(cmd)) ||
+		    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
+		    !(SE_CMD(cmd)->transport_wait_for_tasks))
+			__iscsi_release_cmd_to_pool(cmd, sess);
+		else
+			SE_CMD(cmd)->transport_wait_for_tasks(
+					SE_CMD(cmd), 1, 0);
+		spin_lock(&cr->conn_recovery_cmd_lock);
+	}
+	spin_unlock(&cr->conn_recovery_cmd_lock);
+
+	TRACE(TRACE_ERL2, "Dropped %u total acknowledged commands on"
+		" CID: %hu less than old ExpStatSN: 0x%08x\n",
+			dropped_count, cr->cid, exp_statsn);
+
+	if (!cr->cmd_count) {
+		TRACE(TRACE_ERL2, "No commands to be reassigned for failed"
+			" connection CID: %hu on SID: %u\n",
+			cr->cid, sess->sid);
+		iscsi_remove_inactive_connection_recovery_entry(cr, sess);
+		iscsi_attach_active_connection_recovery_entry(sess, cr);
+		printk(KERN_INFO "iSCSI connection recovery successful for CID:"
+			" %hu on SID: %u\n", cr->cid, sess->sid);
+		iscsi_remove_active_connection_recovery_entry(cr, sess);
+	} else {
+		iscsi_remove_inactive_connection_recovery_entry(cr, sess);
+		iscsi_attach_active_connection_recovery_entry(sess, cr);
+	}
+
+	return;
+}
+
+/*	iscsi_discard_unacknowledged_ooo_cmdsns_for_conn():
+ *
+ *
+ */
+int iscsi_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsi_conn=
 *conn)
+{
+	u32 dropped_count =3D 0;
+	struct iscsi_cmd *cmd, *cmd_tmp;
+	struct iscsi_ooo_cmdsn *ooo_cmdsn, *ooo_cmdsn_tmp;
+	struct iscsi_session *sess =3D conn->sess;
+
+	spin_lock(&sess->cmdsn_lock);
+	list_for_each_entry_safe(ooo_cmdsn, ooo_cmdsn_tmp,
+			&sess->sess_ooo_cmdsn_list, ooo_list) {
+
+		if (ooo_cmdsn->cid !=3D conn->cid)
+			continue;
+
+		dropped_count++;
+		TRACE(TRACE_ERL2, "Dropping unacknowledged CmdSN:"
+		" 0x%08x during connection recovery on CID: %hu\n",
+			ooo_cmdsn->cmdsn, conn->cid);
+		iscsi_remove_ooo_cmdsn(sess, ooo_cmdsn);
+	}
+	conn->sess->ooo_cmdsn_count -=3D dropped_count;
+	spin_unlock(&sess->cmdsn_lock);
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry_safe(cmd, cmd_tmp, &conn->conn_cmd_list, i_list) =
{
+		if (!(cmd->cmd_flags & ICF_OOO_CMDSN))
+			continue;
+
+		iscsi_remove_cmd_from_conn_list(cmd, conn);
+
+		spin_unlock_bh(&conn->cmd_lock);
+		if (!(SE_CMD(cmd)) ||
+		    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
+		    !(SE_CMD(cmd)->transport_wait_for_tasks))
+			__iscsi_release_cmd_to_pool(cmd, sess);
+		else
+			SE_CMD(cmd)->transport_wait_for_tasks(
+					SE_CMD(cmd), 1, 1);
+		spin_lock_bh(&conn->cmd_lock);
+	}
+	spin_unlock_bh(&conn->cmd_lock);
+
+	TRACE(TRACE_ERL2, "Dropped %u total unacknowledged commands on CID:"
+		" %hu for ExpCmdSN: 0x%08x.\n", dropped_count, conn->cid,
+				sess->exp_cmd_sn);
+	return 0;
+}
+
+/*	iscsi_prepare_cmds_for_realligance():
+ *
+ *
+ */
+int iscsi_prepare_cmds_for_realligance(struct iscsi_conn *conn)
+{
+	u32 cmd_count =3D 0;
+	struct iscsi_cmd *cmd, *cmd_tmp;
+	struct iscsi_conn_recovery *cr;
+
+	/*
+	 * Allocate an struct iscsi_conn_recovery for this connection.
+	 * Each struct iscsi_cmd contains an struct iscsi_conn_recovery point=
er
+	 * (struct iscsi_cmd->cr) so we need to allocate this before preparin=
g the
+	 * connection's command list for connection recovery.
+	 */
+	cr =3D kzalloc(sizeof(struct iscsi_conn_recovery), GFP_KERNEL);
+	if (!cr) {
+		printk(KERN_ERR "Unable to allocate memory for"
+			" struct iscsi_conn_recovery.\n");
+		return -1;
+	}
+	INIT_LIST_HEAD(&cr->cr_list);
+	INIT_LIST_HEAD(&cr->conn_recovery_cmd_list);
+	spin_lock_init(&cr->conn_recovery_cmd_lock);
+	/*
+	 * Only perform connection recovery on ISCSI_OP_SCSI_CMD or
+	 * ISCSI_OP_NOOP_OUT opcodes.  For all other opcodes call
+	 * iscsi_remove_cmd_from_conn_list() to release the command to the
+	 * session pool and remove it from the connection's list.
+	 *
+	 * Also stop the DataOUT timer, which will be restarted after
+	 * sending the TMR response.
+	 */
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry_safe(cmd, cmd_tmp, &conn->conn_cmd_list, i_list) =
{
+
+		if ((cmd->iscsi_opcode !=3D ISCSI_OP_SCSI_CMD) &&
+		    (cmd->iscsi_opcode !=3D ISCSI_OP_NOOP_OUT)) {
+			TRACE(TRACE_ERL2, "Not performing realligence on"
+				" Opcode: 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x,"
+				" CID: %hu\n", cmd->iscsi_opcode,
+				cmd->init_task_tag, cmd->cmd_sn, conn->cid);
+
+			iscsi_remove_cmd_from_conn_list(cmd, conn);
+
+			spin_unlock_bh(&conn->cmd_lock);
+			if (!(SE_CMD(cmd)) ||
+			    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
+			    !(SE_CMD(cmd)->transport_wait_for_tasks))
+				__iscsi_release_cmd_to_pool(cmd, conn->sess);
+			else
+				SE_CMD(cmd)->transport_wait_for_tasks(
+						SE_CMD(cmd), 1, 0);
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
+		     (cmd->cmd_sn >=3D conn->sess->exp_cmd_sn)) {
+			iscsi_remove_cmd_from_conn_list(cmd, conn);
+
+			spin_unlock_bh(&conn->cmd_lock);
+			if (!(SE_CMD(cmd)) ||
+			    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
+			    !(SE_CMD(cmd)->transport_wait_for_tasks))
+				__iscsi_release_cmd_to_pool(cmd, conn->sess);
+			else
+				SE_CMD(cmd)->transport_wait_for_tasks(
+						SE_CMD(cmd), 1, 1);
+			spin_lock_bh(&conn->cmd_lock);
+			continue;
+		}
+
+		cmd_count++;
+		TRACE(TRACE_ERL2, "Preparing Opcode: 0x%02x, ITT: 0x%08x,"
+			" CmdSN: 0x%08x, StatSN: 0x%08x, CID: %hu for"
+			" realligence.\n", cmd->iscsi_opcode,
+			cmd->init_task_tag, cmd->cmd_sn, cmd->stat_sn,
+			conn->cid);
+
+		cmd->deferred_i_state =3D cmd->i_state;
+		cmd->i_state =3D ISTATE_IN_CONNECTION_RECOVERY;
+
+		if (cmd->data_direction =3D=3D DMA_TO_DEVICE)
+			iscsi_stop_dataout_timer(cmd);
+
+		cmd->sess =3D conn->sess;
+
+		iscsi_remove_cmd_from_conn_list(cmd, conn);
+		spin_unlock_bh(&conn->cmd_lock);
+
+		iscsi_free_all_datain_reqs(cmd);
+
+		if ((SE_CMD(cmd)) &&
+		    (SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) &&
+		     SE_CMD(cmd)->transport_wait_for_tasks)
+			SE_CMD(cmd)->transport_wait_for_tasks(SE_CMD(cmd),
+					0, 0);
+		/*
+		 * Add the struct iscsi_cmd to the connection recovery cmd list
+		 */
+		spin_lock(&cr->conn_recovery_cmd_lock);
+		list_add_tail(&cmd->i_list, &cr->conn_recovery_cmd_list);
+		spin_unlock(&cr->conn_recovery_cmd_lock);
+
+		spin_lock_bh(&conn->cmd_lock);
+		cmd->cr =3D cr;
+		cmd->conn =3D NULL;
+	}
+	spin_unlock_bh(&conn->cmd_lock);
+
+	/*
+	 * Fill in the various values in the preallocated struct iscsi_conn_r=
ecovery.
+	 */
+	cr->cid =3D conn->cid;
+	cr->cmd_count =3D cmd_count;
+	cr->maxrecvdatasegmentlength =3D conn->conn_ops->MaxRecvDataSegmentLe=
ngth;
+	cr->sess =3D conn->sess;
+
+	iscsi_attach_inactive_connection_recovery_entry(conn->sess, cr);
+
+	return 0;
+}
+
+/*	iscsi_connection_recovery_transport_reset():
+ *
+ *
+ */
+int iscsi_connection_recovery_transport_reset(struct iscsi_conn *conn)
+{
+	atomic_set(&conn->connection_recovery, 1);
+
+	if (iscsi_close_connection(conn) < 0)
+		return -1;
+
+	return 0;
+}
diff --git a/drivers/target/iscsi/iscsi_target_erl2.h b/drivers/target/=
iscsi/iscsi_target_erl2.h
new file mode 100644
index 0000000..2cedae2
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_erl2.h
@@ -0,0 +1,20 @@
+#ifndef ISCSI_TARGET_ERL2_H
+#define ISCSI_TARGET_ERL2_H
+
+extern void iscsi_create_conn_recovery_datain_values(struct iscsi_cmd =
*, u32);
+extern void iscsi_create_conn_recovery_dataout_values(struct iscsi_cmd=
 *);
+extern struct iscsi_conn_recovery *iscsi_get_inactive_connection_recov=
ery_entry(
+			struct iscsi_session *, u16);
+extern void iscsi_free_connection_recovery_entires(struct iscsi_sessio=
n *);
+extern int iscsi_remove_active_connection_recovery_entry(
+			struct iscsi_conn_recovery *, struct iscsi_session *);
+extern int iscsi_remove_cmd_from_connection_recovery(struct iscsi_cmd =
*,
+			struct iscsi_session *);
+extern void iscsi_discard_cr_cmds_by_expstatsn(struct iscsi_conn_recov=
ery *, u32);
+extern int iscsi_discard_unacknowledged_ooo_cmdsns_for_conn(struct isc=
si_conn *);
+extern int iscsi_prepare_cmds_for_realligance(struct iscsi_conn *);
+extern int iscsi_connection_recovery_transport_reset(struct iscsi_conn=
 *);
+
+extern int iscsi_close_connection(struct iscsi_conn *);
+
+#endif /*** ISCSI_TARGET_ERL2_H ***/
--=20
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
