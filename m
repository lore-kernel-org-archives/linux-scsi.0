From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 09/13] iscsi-target: Add Sequence/PDU list + DataIN response logic
Date: Sat, 23 Jul 2011 08:45:43 +0000
Message-ID: <1311410747-29947-10-git-send-email-nab@linux-iscsi.org>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34301 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1GWJJz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jul 2011 05:09:55 -0400
In-Reply-To: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds Sequence/PDU list logic used by RFC-3720 for
DataSequenceInOrder=[Yes,No] and DataPDUInOrder=[Yes,No].  It also
includes support for these modes of support for generating iSCSI
DataIN response data from iscsi_target.c:iscsi_send_data_in().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_datain_values.c |  531 ++++++++++++++++
 drivers/target/iscsi/iscsi_target_datain_values.h |   12 +
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |  664 +++++++++++++++++++++
 drivers/target/iscsi/iscsi_target_seq_pdu_list.h  |   86 +++
 4 files changed, 1293 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/iscsi/iscsi_target_datain_values.c
 create mode 100644 drivers/target/iscsi/iscsi_target_datain_values.h
 create mode 100644 drivers/target/iscsi/iscsi_target_seq_pdu_list.c
 create mode 100644 drivers/target/iscsi/iscsi_target_seq_pdu_list.h

diff --git a/drivers/target/iscsi/iscsi_target_datain_values.c b/drivers/target/iscsi/iscsi_target_datain_values.c
new file mode 100644
index 0000000..8c04951
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_datain_values.c
@@ -0,0 +1,531 @@
+/*******************************************************************************
+ * This file contains the iSCSI Target DataIN value generation functions.
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
+
+#include "iscsi_target_core.h"
+#include "iscsi_target_seq_pdu_list.h"
+#include "iscsi_target_erl1.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target.h"
+#include "iscsi_target_datain_values.h"
+
+struct iscsi_datain_req *iscsit_allocate_datain_req(void)
+{
+	struct iscsi_datain_req *dr;
+
+	dr = kmem_cache_zalloc(lio_dr_cache, GFP_ATOMIC);
+	if (!dr) {
+		pr_err("Unable to allocate memory for"
+				" struct iscsi_datain_req\n");
+		return NULL;
+	}
+	INIT_LIST_HEAD(&dr->dr_list);
+
+	return dr;
+}
+
+void iscsit_attach_datain_req(struct iscsi_cmd *cmd, struct iscsi_datain_req *dr)
+{
+	spin_lock(&cmd->datain_lock);
+	list_add_tail(&dr->dr_list, &cmd->datain_list);
+	spin_unlock(&cmd->datain_lock);
+}
+
+void iscsit_free_datain_req(struct iscsi_cmd *cmd, struct iscsi_datain_req *dr)
+{
+	spin_lock(&cmd->datain_lock);
+	list_del(&dr->dr_list);
+	spin_unlock(&cmd->datain_lock);
+
+	kmem_cache_free(lio_dr_cache, dr);
+}
+
+void iscsit_free_all_datain_reqs(struct iscsi_cmd *cmd)
+{
+	struct iscsi_datain_req *dr, *dr_tmp;
+
+	spin_lock(&cmd->datain_lock);
+	list_for_each_entry_safe(dr, dr_tmp, &cmd->datain_list, dr_list) {
+		list_del(&dr->dr_list);
+		kmem_cache_free(lio_dr_cache, dr);
+	}
+	spin_unlock(&cmd->datain_lock);
+}
+
+struct iscsi_datain_req *iscsit_get_datain_req(struct iscsi_cmd *cmd)
+{
+	struct iscsi_datain_req *dr;
+
+	if (list_empty(&cmd->datain_list)) {
+		pr_err("cmd->datain_list is empty for ITT:"
+			" 0x%08x\n", cmd->init_task_tag);
+		return NULL;
+	}
+	list_for_each_entry(dr, &cmd->datain_list, dr_list)
+		break;
+
+	return dr;
+}
+
+/*
+ *	For Normal and Recovery DataSequenceInOrder=Yes and DataPDUInOrder=Yes.
+ */
+static struct iscsi_datain_req *iscsit_set_datain_values_yes_and_yes(
+	struct iscsi_cmd *cmd,
+	struct iscsi_datain *datain)
+{
+	u32 next_burst_len, read_data_done, read_data_left;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_datain_req *dr;
+
+	dr = iscsit_get_datain_req(cmd);
+	if (!dr)
+		return NULL;
+
+	if (dr->recovery && dr->generate_recovery_values) {
+		if (iscsit_create_recovery_datain_values_datasequenceinorder_yes(
+					cmd, dr) < 0)
+			return NULL;
+
+		dr->generate_recovery_values = 0;
+	}
+
+	next_burst_len = (!dr->recovery) ?
+			cmd->next_burst_len : dr->next_burst_len;
+	read_data_done = (!dr->recovery) ?
+			cmd->read_data_done : dr->read_data_done;
+
+	read_data_left = (cmd->data_length - read_data_done);
+	if (!read_data_left) {
+		pr_err("ITT: 0x%08x read_data_left is zero!\n",
+				cmd->init_task_tag);
+		return NULL;
+	}
+
+	if ((read_data_left <= conn->conn_ops->MaxRecvDataSegmentLength) &&
+	    (read_data_left <= (conn->sess->sess_ops->MaxBurstLength -
+	     next_burst_len))) {
+		datain->length = read_data_left;
+
+		datain->flags |= (ISCSI_FLAG_CMD_FINAL | ISCSI_FLAG_DATA_STATUS);
+		if (conn->sess->sess_ops->ErrorRecoveryLevel > 0)
+			datain->flags |= ISCSI_FLAG_DATA_ACK;
+	} else {
+		if ((next_burst_len +
+		     conn->conn_ops->MaxRecvDataSegmentLength) <
+		     conn->sess->sess_ops->MaxBurstLength) {
+			datain->length =
+				conn->conn_ops->MaxRecvDataSegmentLength;
+			next_burst_len += datain->length;
+		} else {
+			datain->length = (conn->sess->sess_ops->MaxBurstLength -
+					  next_burst_len);
+			next_burst_len = 0;
+
+			datain->flags |= ISCSI_FLAG_CMD_FINAL;
+			if (conn->sess->sess_ops->ErrorRecoveryLevel > 0)
+				datain->flags |= ISCSI_FLAG_DATA_ACK;
+		}
+	}
+
+	datain->data_sn = (!dr->recovery) ? cmd->data_sn++ : dr->data_sn++;
+	datain->offset = read_data_done;
+
+	if (!dr->recovery) {
+		cmd->next_burst_len = next_burst_len;
+		cmd->read_data_done += datain->length;
+	} else {
+		dr->next_burst_len = next_burst_len;
+		dr->read_data_done += datain->length;
+	}
+
+	if (!dr->recovery) {
+		if (datain->flags & ISCSI_FLAG_DATA_STATUS)
+			dr->dr_complete = DATAIN_COMPLETE_NORMAL;
+
+		return dr;
+	}
+
+	if (!dr->runlength) {
+		if (datain->flags & ISCSI_FLAG_DATA_STATUS) {
+			dr->dr_complete =
+			    (dr->recovery == DATAIN_WITHIN_COMMAND_RECOVERY) ?
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY :
+				DATAIN_COMPLETE_CONNECTION_RECOVERY;
+		}
+	} else {
+		if ((dr->begrun + dr->runlength) == dr->data_sn) {
+			dr->dr_complete =
+			    (dr->recovery == DATAIN_WITHIN_COMMAND_RECOVERY) ?
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY :
+				DATAIN_COMPLETE_CONNECTION_RECOVERY;
+		}
+	}
+
+	return dr;
+}
+
+/*
+ *	For Normal and Recovery DataSequenceInOrder=No and DataPDUInOrder=Yes.
+ */
+static struct iscsi_datain_req *iscsit_set_datain_values_no_and_yes(
+	struct iscsi_cmd *cmd,
+	struct iscsi_datain *datain)
+{
+	u32 offset, read_data_done, read_data_left, seq_send_order;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_datain_req *dr;
+	struct iscsi_seq *seq;
+
+	dr = iscsit_get_datain_req(cmd);
+	if (!dr)
+		return NULL;
+
+	if (dr->recovery && dr->generate_recovery_values) {
+		if (iscsit_create_recovery_datain_values_datasequenceinorder_no(
+					cmd, dr) < 0)
+			return NULL;
+
+		dr->generate_recovery_values = 0;
+	}
+
+	read_data_done = (!dr->recovery) ?
+			cmd->read_data_done : dr->read_data_done;
+	seq_send_order = (!dr->recovery) ?
+			cmd->seq_send_order : dr->seq_send_order;
+
+	read_data_left = (cmd->data_length - read_data_done);
+	if (!read_data_left) {
+		pr_err("ITT: 0x%08x read_data_left is zero!\n",
+				cmd->init_task_tag);
+		return NULL;
+	}
+
+	seq = iscsit_get_seq_holder_for_datain(cmd, seq_send_order);
+	if (!seq)
+		return NULL;
+
+	seq->sent = 1;
+
+	if (!dr->recovery && !seq->next_burst_len)
+		seq->first_datasn = cmd->data_sn;
+
+	offset = (seq->offset + seq->next_burst_len);
+
+	if ((offset + conn->conn_ops->MaxRecvDataSegmentLength) >=
+	     cmd->data_length) {
+		datain->length = (cmd->data_length - offset);
+		datain->offset = offset;
+
+		datain->flags |= ISCSI_FLAG_CMD_FINAL;
+		if (conn->sess->sess_ops->ErrorRecoveryLevel > 0)
+			datain->flags |= ISCSI_FLAG_DATA_ACK;
+
+		seq->next_burst_len = 0;
+		seq_send_order++;
+	} else {
+		if ((seq->next_burst_len +
+		     conn->conn_ops->MaxRecvDataSegmentLength) <
+		     conn->sess->sess_ops->MaxBurstLength) {
+			datain->length =
+				conn->conn_ops->MaxRecvDataSegmentLength;
+			datain->offset = (seq->offset + seq->next_burst_len);
+
+			seq->next_burst_len += datain->length;
+		} else {
+			datain->length = (conn->sess->sess_ops->MaxBurstLength -
+					  seq->next_burst_len);
+			datain->offset = (seq->offset + seq->next_burst_len);
+
+			datain->flags |= ISCSI_FLAG_CMD_FINAL;
+			if (conn->sess->sess_ops->ErrorRecoveryLevel > 0)
+				datain->flags |= ISCSI_FLAG_DATA_ACK;
+
+			seq->next_burst_len = 0;
+			seq_send_order++;
+		}
+	}
+
+	if ((read_data_done + datain->length) == cmd->data_length)
+		datain->flags |= ISCSI_FLAG_DATA_STATUS;
+
+	datain->data_sn = (!dr->recovery) ? cmd->data_sn++ : dr->data_sn++;
+	if (!dr->recovery) {
+		cmd->seq_send_order = seq_send_order;
+		cmd->read_data_done += datain->length;
+	} else {
+		dr->seq_send_order = seq_send_order;
+		dr->read_data_done += datain->length;
+	}
+
+	if (!dr->recovery) {
+		if (datain->flags & ISCSI_FLAG_CMD_FINAL)
+			seq->last_datasn = datain->data_sn;
+		if (datain->flags & ISCSI_FLAG_DATA_STATUS)
+			dr->dr_complete = DATAIN_COMPLETE_NORMAL;
+
+		return dr;
+	}
+
+	if (!dr->runlength) {
+		if (datain->flags & ISCSI_FLAG_DATA_STATUS) {
+			dr->dr_complete =
+			    (dr->recovery == DATAIN_WITHIN_COMMAND_RECOVERY) ?
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY :
+				DATAIN_COMPLETE_CONNECTION_RECOVERY;
+		}
+	} else {
+		if ((dr->begrun + dr->runlength) == dr->data_sn) {
+			dr->dr_complete =
+			    (dr->recovery == DATAIN_WITHIN_COMMAND_RECOVERY) ?
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY :
+				DATAIN_COMPLETE_CONNECTION_RECOVERY;
+		}
+	}
+
+	return dr;
+}
+
+/*
+ *	For Normal and Recovery DataSequenceInOrder=Yes and DataPDUInOrder=No.
+ */
+static struct iscsi_datain_req *iscsit_set_datain_values_yes_and_no(
+	struct iscsi_cmd *cmd,
+	struct iscsi_datain *datain)
+{
+	u32 next_burst_len, read_data_done, read_data_left;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_datain_req *dr;
+	struct iscsi_pdu *pdu;
+
+	dr = iscsit_get_datain_req(cmd);
+	if (!dr)
+		return NULL;
+
+	if (dr->recovery && dr->generate_recovery_values) {
+		if (iscsit_create_recovery_datain_values_datasequenceinorder_yes(
+					cmd, dr) < 0)
+			return NULL;
+
+		dr->generate_recovery_values = 0;
+	}
+
+	next_burst_len = (!dr->recovery) ?
+			cmd->next_burst_len : dr->next_burst_len;
+	read_data_done = (!dr->recovery) ?
+			cmd->read_data_done : dr->read_data_done;
+
+	read_data_left = (cmd->data_length - read_data_done);
+	if (!read_data_left) {
+		pr_err("ITT: 0x%08x read_data_left is zero!\n",
+				cmd->init_task_tag);
+		return dr;
+	}
+
+	pdu = iscsit_get_pdu_holder_for_seq(cmd, NULL);
+	if (!pdu)
+		return dr;
+
+	if ((read_data_done + pdu->length) == cmd->data_length) {
+		pdu->flags |= (ISCSI_FLAG_CMD_FINAL | ISCSI_FLAG_DATA_STATUS);
+		if (conn->sess->sess_ops->ErrorRecoveryLevel > 0)
+			pdu->flags |= ISCSI_FLAG_DATA_ACK;
+
+		next_burst_len = 0;
+	} else {
+		if ((next_burst_len + conn->conn_ops->MaxRecvDataSegmentLength) <
+		     conn->sess->sess_ops->MaxBurstLength)
+			next_burst_len += pdu->length;
+		else {
+			pdu->flags |= ISCSI_FLAG_CMD_FINAL;
+			if (conn->sess->sess_ops->ErrorRecoveryLevel > 0)
+				pdu->flags |= ISCSI_FLAG_DATA_ACK;
+
+			next_burst_len = 0;
+		}
+	}
+
+	pdu->data_sn = (!dr->recovery) ? cmd->data_sn++ : dr->data_sn++;
+	if (!dr->recovery) {
+		cmd->next_burst_len = next_burst_len;
+		cmd->read_data_done += pdu->length;
+	} else {
+		dr->next_burst_len = next_burst_len;
+		dr->read_data_done += pdu->length;
+	}
+
+	datain->flags = pdu->flags;
+	datain->length = pdu->length;
+	datain->offset = pdu->offset;
+	datain->data_sn = pdu->data_sn;
+
+	if (!dr->recovery) {
+		if (datain->flags & ISCSI_FLAG_DATA_STATUS)
+			dr->dr_complete = DATAIN_COMPLETE_NORMAL;
+
+		return dr;
+	}
+
+	if (!dr->runlength) {
+		if (datain->flags & ISCSI_FLAG_DATA_STATUS) {
+			dr->dr_complete =
+			    (dr->recovery == DATAIN_WITHIN_COMMAND_RECOVERY) ?
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY :
+				DATAIN_COMPLETE_CONNECTION_RECOVERY;
+		}
+	} else {
+		if ((dr->begrun + dr->runlength) == dr->data_sn) {
+			dr->dr_complete =
+			    (dr->recovery == DATAIN_WITHIN_COMMAND_RECOVERY) ?
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY :
+				DATAIN_COMPLETE_CONNECTION_RECOVERY;
+		}
+	}
+
+	return dr;
+}
+
+/*
+ *	For Normal and Recovery DataSequenceInOrder=No and DataPDUInOrder=No.
+ */
+static struct iscsi_datain_req *iscsit_set_datain_values_no_and_no(
+	struct iscsi_cmd *cmd,
+	struct iscsi_datain *datain)
+{
+	u32 read_data_done, read_data_left, seq_send_order;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_datain_req *dr;
+	struct iscsi_pdu *pdu;
+	struct iscsi_seq *seq = NULL;
+
+	dr = iscsit_get_datain_req(cmd);
+	if (!dr)
+		return NULL;
+
+	if (dr->recovery && dr->generate_recovery_values) {
+		if (iscsit_create_recovery_datain_values_datasequenceinorder_no(
+					cmd, dr) < 0)
+			return NULL;
+
+		dr->generate_recovery_values = 0;
+	}
+
+	read_data_done = (!dr->recovery) ?
+			cmd->read_data_done : dr->read_data_done;
+	seq_send_order = (!dr->recovery) ?
+			cmd->seq_send_order : dr->seq_send_order;
+
+	read_data_left = (cmd->data_length - read_data_done);
+	if (!read_data_left) {
+		pr_err("ITT: 0x%08x read_data_left is zero!\n",
+				cmd->init_task_tag);
+		return NULL;
+	}
+
+	seq = iscsit_get_seq_holder_for_datain(cmd, seq_send_order);
+	if (!seq)
+		return NULL;
+
+	seq->sent = 1;
+
+	if (!dr->recovery && !seq->next_burst_len)
+		seq->first_datasn = cmd->data_sn;
+
+	pdu = iscsit_get_pdu_holder_for_seq(cmd, seq);
+	if (!pdu)
+		return NULL;
+
+	if (seq->pdu_send_order == seq->pdu_count) {
+		pdu->flags |= ISCSI_FLAG_CMD_FINAL;
+		if (conn->sess->sess_ops->ErrorRecoveryLevel > 0)
+			pdu->flags |= ISCSI_FLAG_DATA_ACK;
+
+		seq->next_burst_len = 0;
+		seq_send_order++;
+	} else
+		seq->next_burst_len += pdu->length;
+
+	if ((read_data_done + pdu->length) == cmd->data_length)
+		pdu->flags |= ISCSI_FLAG_DATA_STATUS;
+
+	pdu->data_sn = (!dr->recovery) ? cmd->data_sn++ : dr->data_sn++;
+	if (!dr->recovery) {
+		cmd->seq_send_order = seq_send_order;
+		cmd->read_data_done += pdu->length;
+	} else {
+		dr->seq_send_order = seq_send_order;
+		dr->read_data_done += pdu->length;
+	}
+
+	datain->flags = pdu->flags;
+	datain->length = pdu->length;
+	datain->offset = pdu->offset;
+	datain->data_sn = pdu->data_sn;
+
+	if (!dr->recovery) {
+		if (datain->flags & ISCSI_FLAG_CMD_FINAL)
+			seq->last_datasn = datain->data_sn;
+		if (datain->flags & ISCSI_FLAG_DATA_STATUS)
+			dr->dr_complete = DATAIN_COMPLETE_NORMAL;
+
+		return dr;
+	}
+
+	if (!dr->runlength) {
+		if (datain->flags & ISCSI_FLAG_DATA_STATUS) {
+			dr->dr_complete =
+			    (dr->recovery == DATAIN_WITHIN_COMMAND_RECOVERY) ?
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY :
+				DATAIN_COMPLETE_CONNECTION_RECOVERY;
+		}
+	} else {
+		if ((dr->begrun + dr->runlength) == dr->data_sn) {
+			dr->dr_complete =
+			    (dr->recovery == DATAIN_WITHIN_COMMAND_RECOVERY) ?
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY :
+				DATAIN_COMPLETE_CONNECTION_RECOVERY;
+		}
+	}
+
+	return dr;
+}
+
+struct iscsi_datain_req *iscsit_get_datain_values(
+	struct iscsi_cmd *cmd,
+	struct iscsi_datain *datain)
+{
+	struct iscsi_conn *conn = cmd->conn;
+
+	if (conn->sess->sess_ops->DataSequenceInOrder &&
+	    conn->sess->sess_ops->DataPDUInOrder)
+		return iscsit_set_datain_values_yes_and_yes(cmd, datain);
+	else if (!conn->sess->sess_ops->DataSequenceInOrder &&
+		  conn->sess->sess_ops->DataPDUInOrder)
+		return iscsit_set_datain_values_no_and_yes(cmd, datain);
+	else if (conn->sess->sess_ops->DataSequenceInOrder &&
+		 !conn->sess->sess_ops->DataPDUInOrder)
+		return iscsit_set_datain_values_yes_and_no(cmd, datain);
+	else if (!conn->sess->sess_ops->DataSequenceInOrder &&
+		   !conn->sess->sess_ops->DataPDUInOrder)
+		return iscsit_set_datain_values_no_and_no(cmd, datain);
+
+	return NULL;
+}
diff --git a/drivers/target/iscsi/iscsi_target_datain_values.h b/drivers/target/iscsi/iscsi_target_datain_values.h
new file mode 100644
index 0000000..646429a
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_datain_values.h
@@ -0,0 +1,12 @@
+#ifndef ISCSI_TARGET_DATAIN_VALUES_H
+#define ISCSI_TARGET_DATAIN_VALUES_H
+
+extern struct iscsi_datain_req *iscsit_allocate_datain_req(void);
+extern void iscsit_attach_datain_req(struct iscsi_cmd *, struct iscsi_datain_req *);
+extern void iscsit_free_datain_req(struct iscsi_cmd *, struct iscsi_datain_req *);
+extern void iscsit_free_all_datain_reqs(struct iscsi_cmd *);
+extern struct iscsi_datain_req *iscsit_get_datain_req(struct iscsi_cmd *);
+extern struct iscsi_datain_req *iscsit_get_datain_values(struct iscsi_cmd *,
+			struct iscsi_datain *);
+
+#endif   /*** ISCSI_TARGET_DATAIN_VALUES_H ***/
diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
new file mode 100644
index 0000000..fc69408
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
@@ -0,0 +1,664 @@
+/*******************************************************************************
+ * This file contains main functions related to iSCSI DataSequenceInOrder=No
+ * and DataPDUInOrder=No.
+ *
+ \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
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
+#include <linux/slab.h>
+#include <linux/random.h>
+
+#include "iscsi_target_core.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target_seq_pdu_list.h"
+
+#define OFFLOAD_BUF_SIZE	32768
+
+void iscsit_dump_seq_list(struct iscsi_cmd *cmd)
+{
+	int i;
+	struct iscsi_seq *seq;
+
+	pr_debug("Dumping Sequence List for ITT: 0x%08x:\n",
+			cmd->init_task_tag);
+
+	for (i = 0; i < cmd->seq_count; i++) {
+		seq = &cmd->seq_list[i];
+		pr_debug("i: %d, pdu_start: %d, pdu_count: %d,"
+			" offset: %d, xfer_len: %d, seq_send_order: %d,"
+			" seq_no: %d\n", i, seq->pdu_start, seq->pdu_count,
+			seq->offset, seq->xfer_len, seq->seq_send_order,
+			seq->seq_no);
+	}
+}
+
+void iscsit_dump_pdu_list(struct iscsi_cmd *cmd)
+{
+	int i;
+	struct iscsi_pdu *pdu;
+
+	pr_debug("Dumping PDU List for ITT: 0x%08x:\n",
+			cmd->init_task_tag);
+
+	for (i = 0; i < cmd->pdu_count; i++) {
+		pdu = &cmd->pdu_list[i];
+		pr_debug("i: %d, offset: %d, length: %d,"
+			" pdu_send_order: %d, seq_no: %d\n", i, pdu->offset,
+			pdu->length, pdu->pdu_send_order, pdu->seq_no);
+	}
+}
+
+static void iscsit_ordered_seq_lists(
+	struct iscsi_cmd *cmd,
+	u8 type)
+{
+	u32 i, seq_count = 0;
+
+	for (i = 0; i < cmd->seq_count; i++) {
+		if (cmd->seq_list[i].type != SEQTYPE_NORMAL)
+			continue;
+		cmd->seq_list[i].seq_send_order = seq_count++;
+	}
+}
+
+static void iscsit_ordered_pdu_lists(
+	struct iscsi_cmd *cmd,
+	u8 type)
+{
+	u32 i, pdu_send_order = 0, seq_no = 0;
+
+	for (i = 0; i < cmd->pdu_count; i++) {
+redo:
+		if (cmd->pdu_list[i].seq_no == seq_no) {
+			cmd->pdu_list[i].pdu_send_order = pdu_send_order++;
+			continue;
+		}
+		seq_no++;
+		pdu_send_order = 0;
+		goto redo;
+	}
+}
+
+/*
+ *	Generate count random values into array.
+ *	Use 0x80000000 to mark generates valued in array[].
+ */
+static void iscsit_create_random_array(u32 *array, u32 count)
+{
+	int i, j, k;
+
+	if (count == 1) {
+		array[0] = 0;
+		return;
+	}
+
+	for (i = 0; i < count; i++) {
+redo:
+		get_random_bytes(&j, sizeof(u32));
+		j = (1 + (int) (9999 + 1) - j) % count;
+		for (k = 0; k < i + 1; k++) {
+			j |= 0x80000000;
+			if ((array[k] & 0x80000000) && (array[k] == j))
+				goto redo;
+		}
+		array[i] = j;
+	}
+
+	for (i = 0; i < count; i++)
+		array[i] &= ~0x80000000;
+}
+
+static int iscsit_randomize_pdu_lists(
+	struct iscsi_cmd *cmd,
+	u8 type)
+{
+	int i = 0;
+	u32 *array, pdu_count, seq_count = 0, seq_no = 0, seq_offset = 0;
+
+	for (pdu_count = 0; pdu_count < cmd->pdu_count; pdu_count++) {
+redo:
+		if (cmd->pdu_list[pdu_count].seq_no == seq_no) {
+			seq_count++;
+			continue;
+		}
+		array = kzalloc(seq_count * sizeof(u32), GFP_KERNEL);
+		if (!array) {
+			pr_err("Unable to allocate memory"
+				" for random array.\n");
+			return -1;
+		}
+		iscsit_create_random_array(array, seq_count);
+
+		for (i = 0; i < seq_count; i++)
+			cmd->pdu_list[seq_offset+i].pdu_send_order = array[i];
+
+		kfree(array);
+
+		seq_offset += seq_count;
+		seq_count = 0;
+		seq_no++;
+		goto redo;
+	}
+
+	if (seq_count) {
+		array = kzalloc(seq_count * sizeof(u32), GFP_KERNEL);
+		if (!array) {
+			pr_err("Unable to allocate memory for"
+				" random array.\n");
+			return -1;
+		}
+		iscsit_create_random_array(array, seq_count);
+
+		for (i = 0; i < seq_count; i++)
+			cmd->pdu_list[seq_offset+i].pdu_send_order = array[i];
+
+		kfree(array);
+	}
+
+	return 0;
+}
+
+static int iscsit_randomize_seq_lists(
+	struct iscsi_cmd *cmd,
+	u8 type)
+{
+	int i, j = 0;
+	u32 *array, seq_count = cmd->seq_count;
+
+	if ((type == PDULIST_IMMEDIATE) || (type == PDULIST_UNSOLICITED))
+		seq_count--;
+	else if (type == PDULIST_IMMEDIATE_AND_UNSOLICITED)
+		seq_count -= 2;
+
+	if (!seq_count)
+		return 0;
+
+	array = kzalloc(seq_count * sizeof(u32), GFP_KERNEL);
+	if (!array) {
+		pr_err("Unable to allocate memory for random array.\n");
+		return -1;
+	}
+	iscsit_create_random_array(array, seq_count);
+
+	for (i = 0; i < cmd->seq_count; i++) {
+		if (cmd->seq_list[i].type != SEQTYPE_NORMAL)
+			continue;
+		cmd->seq_list[i].seq_send_order = array[j++];
+	}
+
+	kfree(array);
+	return 0;
+}
+
+static void iscsit_determine_counts_for_list(
+	struct iscsi_cmd *cmd,
+	struct iscsi_build_list *bl,
+	u32 *seq_count,
+	u32 *pdu_count)
+{
+	int check_immediate = 0;
+	u32 burstlength = 0, offset = 0;
+	u32 unsolicited_data_length = 0;
+	struct iscsi_conn *conn = cmd->conn;
+
+	if ((bl->type == PDULIST_IMMEDIATE) ||
+	    (bl->type == PDULIST_IMMEDIATE_AND_UNSOLICITED))
+		check_immediate = 1;
+
+	if ((bl->type == PDULIST_UNSOLICITED) ||
+	    (bl->type == PDULIST_IMMEDIATE_AND_UNSOLICITED))
+		unsolicited_data_length = (cmd->data_length >
+			conn->sess->sess_ops->FirstBurstLength) ?
+			conn->sess->sess_ops->FirstBurstLength : cmd->data_length;
+
+	while (offset < cmd->data_length) {
+		*pdu_count += 1;
+
+		if (check_immediate) {
+			check_immediate = 0;
+			offset += bl->immediate_data_length;
+			*seq_count += 1;
+			if (unsolicited_data_length)
+				unsolicited_data_length -=
+					bl->immediate_data_length;
+			continue;
+		}
+		if (unsolicited_data_length > 0) {
+			if ((offset + conn->conn_ops->MaxRecvDataSegmentLength)
+					>= cmd->data_length) {
+				unsolicited_data_length -=
+					(cmd->data_length - offset);
+				offset += (cmd->data_length - offset);
+				continue;
+			}
+			if ((offset + conn->conn_ops->MaxRecvDataSegmentLength)
+					>= conn->sess->sess_ops->FirstBurstLength) {
+				unsolicited_data_length -=
+					(conn->sess->sess_ops->FirstBurstLength -
+					offset);
+				offset += (conn->sess->sess_ops->FirstBurstLength -
+					offset);
+				burstlength = 0;
+				*seq_count += 1;
+				continue;
+			}
+
+			offset += conn->conn_ops->MaxRecvDataSegmentLength;
+			unsolicited_data_length -=
+				conn->conn_ops->MaxRecvDataSegmentLength;
+			continue;
+		}
+		if ((offset + conn->conn_ops->MaxRecvDataSegmentLength) >=
+		     cmd->data_length) {
+			offset += (cmd->data_length - offset);
+			continue;
+		}
+		if ((burstlength + conn->conn_ops->MaxRecvDataSegmentLength) >=
+		     conn->sess->sess_ops->MaxBurstLength) {
+			offset += (conn->sess->sess_ops->MaxBurstLength -
+					burstlength);
+			burstlength = 0;
+			*seq_count += 1;
+			continue;
+		}
+
+		burstlength += conn->conn_ops->MaxRecvDataSegmentLength;
+		offset += conn->conn_ops->MaxRecvDataSegmentLength;
+	}
+}
+
+
+/*
+ *	Builds PDU and/or Sequence list,  called while DataSequenceInOrder=No
+ *	and DataPDUInOrder=No.
+ */
+static int iscsit_build_pdu_and_seq_list(
+	struct iscsi_cmd *cmd,
+	struct iscsi_build_list *bl)
+{
+	int check_immediate = 0, datapduinorder, datasequenceinorder;
+	u32 burstlength = 0, offset = 0, i = 0;
+	u32 pdu_count = 0, seq_no = 0, unsolicited_data_length = 0;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_pdu *pdu = cmd->pdu_list;
+	struct iscsi_seq *seq = cmd->seq_list;
+
+	datapduinorder = conn->sess->sess_ops->DataPDUInOrder;
+	datasequenceinorder = conn->sess->sess_ops->DataSequenceInOrder;
+
+	if ((bl->type == PDULIST_IMMEDIATE) ||
+	    (bl->type == PDULIST_IMMEDIATE_AND_UNSOLICITED))
+		check_immediate = 1;
+
+	if ((bl->type == PDULIST_UNSOLICITED) ||
+	    (bl->type == PDULIST_IMMEDIATE_AND_UNSOLICITED))
+		unsolicited_data_length = (cmd->data_length >
+			conn->sess->sess_ops->FirstBurstLength) ?
+			conn->sess->sess_ops->FirstBurstLength : cmd->data_length;
+
+	while (offset < cmd->data_length) {
+		pdu_count++;
+		if (!datapduinorder) {
+			pdu[i].offset = offset;
+			pdu[i].seq_no = seq_no;
+		}
+		if (!datasequenceinorder && (pdu_count == 1)) {
+			seq[seq_no].pdu_start = i;
+			seq[seq_no].seq_no = seq_no;
+			seq[seq_no].offset = offset;
+			seq[seq_no].orig_offset = offset;
+		}
+
+		if (check_immediate) {
+			check_immediate = 0;
+			if (!datapduinorder) {
+				pdu[i].type = PDUTYPE_IMMEDIATE;
+				pdu[i++].length = bl->immediate_data_length;
+			}
+			if (!datasequenceinorder) {
+				seq[seq_no].type = SEQTYPE_IMMEDIATE;
+				seq[seq_no].pdu_count = 1;
+				seq[seq_no].xfer_len =
+					bl->immediate_data_length;
+			}
+			offset += bl->immediate_data_length;
+			pdu_count = 0;
+			seq_no++;
+			if (unsolicited_data_length)
+				unsolicited_data_length -=
+					bl->immediate_data_length;
+			continue;
+		}
+		if (unsolicited_data_length > 0) {
+			if ((offset +
+			     conn->conn_ops->MaxRecvDataSegmentLength) >=
+			     cmd->data_length) {
+				if (!datapduinorder) {
+					pdu[i].type = PDUTYPE_UNSOLICITED;
+					pdu[i].length =
+						(cmd->data_length - offset);
+				}
+				if (!datasequenceinorder) {
+					seq[seq_no].type = SEQTYPE_UNSOLICITED;
+					seq[seq_no].pdu_count = pdu_count;
+					seq[seq_no].xfer_len = (burstlength +
+						(cmd->data_length - offset));
+				}
+				unsolicited_data_length -=
+						(cmd->data_length - offset);
+				offset += (cmd->data_length - offset);
+				continue;
+			}
+			if ((offset +
+			     conn->conn_ops->MaxRecvDataSegmentLength) >=
+					conn->sess->sess_ops->FirstBurstLength) {
+				if (!datapduinorder) {
+					pdu[i].type = PDUTYPE_UNSOLICITED;
+					pdu[i++].length =
+					   (conn->sess->sess_ops->FirstBurstLength -
+						offset);
+				}
+				if (!datasequenceinorder) {
+					seq[seq_no].type = SEQTYPE_UNSOLICITED;
+					seq[seq_no].pdu_count = pdu_count;
+					seq[seq_no].xfer_len = (burstlength +
+					   (conn->sess->sess_ops->FirstBurstLength -
+						offset));
+				}
+				unsolicited_data_length -=
+					(conn->sess->sess_ops->FirstBurstLength -
+						offset);
+				offset += (conn->sess->sess_ops->FirstBurstLength -
+						offset);
+				burstlength = 0;
+				pdu_count = 0;
+				seq_no++;
+				continue;
+			}
+
+			if (!datapduinorder) {
+				pdu[i].type = PDUTYPE_UNSOLICITED;
+				pdu[i++].length =
+				     conn->conn_ops->MaxRecvDataSegmentLength;
+			}
+			burstlength += conn->conn_ops->MaxRecvDataSegmentLength;
+			offset += conn->conn_ops->MaxRecvDataSegmentLength;
+			unsolicited_data_length -=
+				conn->conn_ops->MaxRecvDataSegmentLength;
+			continue;
+		}
+		if ((offset + conn->conn_ops->MaxRecvDataSegmentLength) >=
+		     cmd->data_length) {
+			if (!datapduinorder) {
+				pdu[i].type = PDUTYPE_NORMAL;
+				pdu[i].length = (cmd->data_length - offset);
+			}
+			if (!datasequenceinorder) {
+				seq[seq_no].type = SEQTYPE_NORMAL;
+				seq[seq_no].pdu_count = pdu_count;
+				seq[seq_no].xfer_len = (burstlength +
+					(cmd->data_length - offset));
+			}
+			offset += (cmd->data_length - offset);
+			continue;
+		}
+		if ((burstlength + conn->conn_ops->MaxRecvDataSegmentLength) >=
+		     conn->sess->sess_ops->MaxBurstLength) {
+			if (!datapduinorder) {
+				pdu[i].type = PDUTYPE_NORMAL;
+				pdu[i++].length =
+					(conn->sess->sess_ops->MaxBurstLength -
+						burstlength);
+			}
+			if (!datasequenceinorder) {
+				seq[seq_no].type = SEQTYPE_NORMAL;
+				seq[seq_no].pdu_count = pdu_count;
+				seq[seq_no].xfer_len = (burstlength +
+					(conn->sess->sess_ops->MaxBurstLength -
+					burstlength));
+			}
+			offset += (conn->sess->sess_ops->MaxBurstLength -
+					burstlength);
+			burstlength = 0;
+			pdu_count = 0;
+			seq_no++;
+			continue;
+		}
+
+		if (!datapduinorder) {
+			pdu[i].type = PDUTYPE_NORMAL;
+			pdu[i++].length =
+				conn->conn_ops->MaxRecvDataSegmentLength;
+		}
+		burstlength += conn->conn_ops->MaxRecvDataSegmentLength;
+		offset += conn->conn_ops->MaxRecvDataSegmentLength;
+	}
+
+	if (!datasequenceinorder) {
+		if (bl->data_direction & ISCSI_PDU_WRITE) {
+			if (bl->randomize & RANDOM_R2T_OFFSETS) {
+				if (iscsit_randomize_seq_lists(cmd, bl->type)
+						< 0)
+					return -1;
+			} else
+				iscsit_ordered_seq_lists(cmd, bl->type);
+		} else if (bl->data_direction & ISCSI_PDU_READ) {
+			if (bl->randomize & RANDOM_DATAIN_SEQ_OFFSETS) {
+				if (iscsit_randomize_seq_lists(cmd, bl->type)
+						< 0)
+					return -1;
+			} else
+				iscsit_ordered_seq_lists(cmd, bl->type);
+		}
+#if 0
+		iscsit_dump_seq_list(cmd);
+#endif
+	}
+	if (!datapduinorder) {
+		if (bl->data_direction & ISCSI_PDU_WRITE) {
+			if (bl->randomize & RANDOM_DATAOUT_PDU_OFFSETS) {
+				if (iscsit_randomize_pdu_lists(cmd, bl->type)
+						< 0)
+					return -1;
+			} else
+				iscsit_ordered_pdu_lists(cmd, bl->type);
+		} else if (bl->data_direction & ISCSI_PDU_READ) {
+			if (bl->randomize & RANDOM_DATAIN_PDU_OFFSETS) {
+				if (iscsit_randomize_pdu_lists(cmd, bl->type)
+						< 0)
+					return -1;
+			} else
+				iscsit_ordered_pdu_lists(cmd, bl->type);
+		}
+#if 0
+		iscsit_dump_pdu_list(cmd);
+#endif
+	}
+
+	return 0;
+}
+
+/*
+ *	Only called while DataSequenceInOrder=No or DataPDUInOrder=No.
+ */
+int iscsit_do_build_list(
+	struct iscsi_cmd *cmd,
+	struct iscsi_build_list *bl)
+{
+	u32 pdu_count = 0, seq_count = 1;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_pdu *pdu = NULL;
+	struct iscsi_seq *seq = NULL;
+
+	iscsit_determine_counts_for_list(cmd, bl, &seq_count, &pdu_count);
+
+	if (!conn->sess->sess_ops->DataSequenceInOrder) {
+		seq = kzalloc(seq_count * sizeof(struct iscsi_seq), GFP_ATOMIC);
+		if (!seq) {
+			pr_err("Unable to allocate struct iscsi_seq list\n");
+			return -1;
+		}
+		cmd->seq_list = seq;
+		cmd->seq_count = seq_count;
+	}
+
+	if (!conn->sess->sess_ops->DataPDUInOrder) {
+		pdu = kzalloc(pdu_count * sizeof(struct iscsi_pdu), GFP_ATOMIC);
+		if (!pdu) {
+			pr_err("Unable to allocate struct iscsi_pdu list.\n");
+			kfree(seq);
+			return -1;
+		}
+		cmd->pdu_list = pdu;
+		cmd->pdu_count = pdu_count;
+	}
+
+	return iscsit_build_pdu_and_seq_list(cmd, bl);
+}
+
+struct iscsi_pdu *iscsit_get_pdu_holder(
+	struct iscsi_cmd *cmd,
+	u32 offset,
+	u32 length)
+{
+	u32 i;
+	struct iscsi_pdu *pdu = NULL;
+
+	if (!cmd->pdu_list) {
+		pr_err("struct iscsi_cmd->pdu_list is NULL!\n");
+		return NULL;
+	}
+
+	pdu = &cmd->pdu_list[0];
+
+	for (i = 0; i < cmd->pdu_count; i++)
+		if ((pdu[i].offset == offset) && (pdu[i].length == length))
+			return &pdu[i];
+
+	pr_err("Unable to locate PDU holder for ITT: 0x%08x, Offset:"
+		" %u, Length: %u\n", cmd->init_task_tag, offset, length);
+	return NULL;
+}
+
+struct iscsi_pdu *iscsit_get_pdu_holder_for_seq(
+	struct iscsi_cmd *cmd,
+	struct iscsi_seq *seq)
+{
+	u32 i;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_pdu *pdu = NULL;
+
+	if (!cmd->pdu_list) {
+		pr_err("struct iscsi_cmd->pdu_list is NULL!\n");
+		return NULL;
+	}
+
+	if (conn->sess->sess_ops->DataSequenceInOrder) {
+redo:
+		pdu = &cmd->pdu_list[cmd->pdu_start];
+
+		for (i = 0; pdu[i].seq_no != cmd->seq_no; i++) {
+#if 0
+			pr_debug("pdu[i].seq_no: %d, pdu[i].pdu"
+				"_send_order: %d, pdu[i].offset: %d,"
+				" pdu[i].length: %d\n", pdu[i].seq_no,
+				pdu[i].pdu_send_order, pdu[i].offset,
+				pdu[i].length);
+#endif
+			if (pdu[i].pdu_send_order == cmd->pdu_send_order) {
+				cmd->pdu_send_order++;
+				return &pdu[i];
+			}
+		}
+
+		cmd->pdu_start += cmd->pdu_send_order;
+		cmd->pdu_send_order = 0;
+		cmd->seq_no++;
+
+		if (cmd->pdu_start < cmd->pdu_count)
+			goto redo;
+
+		pr_err("Command ITT: 0x%08x unable to locate"
+			" struct iscsi_pdu for cmd->pdu_send_order: %u.\n",
+			cmd->init_task_tag, cmd->pdu_send_order);
+		return NULL;
+	} else {
+		if (!seq) {
+			pr_err("struct iscsi_seq is NULL!\n");
+			return NULL;
+		}
+#if 0
+		pr_debug("seq->pdu_start: %d, seq->pdu_count: %d,"
+			" seq->seq_no: %d\n", seq->pdu_start, seq->pdu_count,
+			seq->seq_no);
+#endif
+		pdu = &cmd->pdu_list[seq->pdu_start];
+
+		if (seq->pdu_send_order == seq->pdu_count) {
+			pr_err("Command ITT: 0x%08x seq->pdu_send"
+				"_order: %u equals seq->pdu_count: %u\n",
+				cmd->init_task_tag, seq->pdu_send_order,
+				seq->pdu_count);
+			return NULL;
+		}
+
+		for (i = 0; i < seq->pdu_count; i++) {
+			if (pdu[i].pdu_send_order == seq->pdu_send_order) {
+				seq->pdu_send_order++;
+				return &pdu[i];
+			}
+		}
+
+		pr_err("Command ITT: 0x%08x unable to locate iscsi"
+			"_pdu_t for seq->pdu_send_order: %u.\n",
+			cmd->init_task_tag, seq->pdu_send_order);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+struct iscsi_seq *iscsit_get_seq_holder(
+	struct iscsi_cmd *cmd,
+	u32 offset,
+	u32 length)
+{
+	u32 i;
+
+	if (!cmd->seq_list) {
+		pr_err("struct iscsi_cmd->seq_list is NULL!\n");
+		return NULL;
+	}
+
+	for (i = 0; i < cmd->seq_count; i++) {
+#if 0
+		pr_debug("seq_list[i].orig_offset: %d, seq_list[i]."
+			"xfer_len: %d, seq_list[i].seq_no %u\n",
+			cmd->seq_list[i].orig_offset, cmd->seq_list[i].xfer_len,
+			cmd->seq_list[i].seq_no);
+#endif
+		if ((cmd->seq_list[i].orig_offset +
+				cmd->seq_list[i].xfer_len) >=
+				(offset + length))
+			return &cmd->seq_list[i];
+	}
+
+	pr_err("Unable to locate Sequence holder for ITT: 0x%08x,"
+		" Offset: %u, Length: %u\n", cmd->init_task_tag, offset,
+		length);
+	return NULL;
+}
diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.h b/drivers/target/iscsi/iscsi_target_seq_pdu_list.h
new file mode 100644
index 0000000..0d52a10
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.h
@@ -0,0 +1,86 @@
+#ifndef ISCSI_SEQ_AND_PDU_LIST_H
+#define ISCSI_SEQ_AND_PDU_LIST_H
+
+/* struct iscsi_pdu->status */
+#define DATAOUT_PDU_SENT			1
+
+/* struct iscsi_seq->type */
+#define SEQTYPE_IMMEDIATE			1
+#define SEQTYPE_UNSOLICITED			2
+#define SEQTYPE_NORMAL				3
+
+/* struct iscsi_seq->status */
+#define DATAOUT_SEQUENCE_GOT_R2T		1
+#define DATAOUT_SEQUENCE_WITHIN_COMMAND_RECOVERY 2
+#define DATAOUT_SEQUENCE_COMPLETE		3
+
+/* iscsi_determine_counts_for_list() type */
+#define PDULIST_NORMAL				1
+#define PDULIST_IMMEDIATE			2
+#define PDULIST_UNSOLICITED			3
+#define PDULIST_IMMEDIATE_AND_UNSOLICITED	4
+
+/* struct iscsi_pdu->type */
+#define PDUTYPE_IMMEDIATE			1
+#define PDUTYPE_UNSOLICITED			2
+#define PDUTYPE_NORMAL				3
+
+/* struct iscsi_pdu->status */
+#define ISCSI_PDU_NOT_RECEIVED			0
+#define ISCSI_PDU_RECEIVED_OK			1
+#define ISCSI_PDU_CRC_FAILED			2
+#define ISCSI_PDU_TIMED_OUT			3
+
+/* struct iscsi_build_list->randomize */
+#define RANDOM_DATAIN_PDU_OFFSETS		0x01
+#define RANDOM_DATAIN_SEQ_OFFSETS		0x02
+#define RANDOM_DATAOUT_PDU_OFFSETS		0x04
+#define RANDOM_R2T_OFFSETS			0x08
+
+/* struct iscsi_build_list->data_direction */
+#define ISCSI_PDU_READ				0x01
+#define ISCSI_PDU_WRITE				0x02
+
+struct iscsi_build_list {
+	int		data_direction;
+	int		randomize;
+	int		type;
+	int		immediate_data_length;
+};
+
+struct iscsi_pdu {
+	int		status;
+	int		type;
+	u8		flags;
+	u32		data_sn;
+	u32		length;
+	u32		offset;
+	u32		pdu_send_order;
+	u32		seq_no;
+} ____cacheline_aligned;
+
+struct iscsi_seq {
+	int		sent;
+	int		status;
+	int		type;
+	u32		data_sn;
+	u32		first_datasn;
+	u32		last_datasn;
+	u32		next_burst_len;
+	u32		pdu_start;
+	u32		pdu_count;
+	u32		offset;
+	u32		orig_offset;
+	u32		pdu_send_order;
+	u32		r2t_sn;
+	u32		seq_send_order;
+	u32		seq_no;
+	u32		xfer_len;
+} ____cacheline_aligned;
+
+extern int iscsit_do_build_list(struct iscsi_cmd *, struct iscsi_build_list *);
+extern struct iscsi_pdu *iscsit_get_pdu_holder(struct iscsi_cmd *, u32, u32);
+extern struct iscsi_pdu *iscsit_get_pdu_holder_for_seq(struct iscsi_cmd *, struct iscsi_seq *);
+extern struct iscsi_seq *iscsit_get_seq_holder(struct iscsi_cmd *, u32, u32);
+
+#endif /* ISCSI_SEQ_AND_PDU_LIST_H */
-- 
1.7.6

