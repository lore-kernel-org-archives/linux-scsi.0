From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 08/12] iscsi-target: Add Sequence/PDU list + DataIN response logic
Date: Mon, 14 Mar 2011 04:57:05 -0700
Message-ID: <1300103829-10337-9-git-send-email-nab@linux-iscsi.org>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

=46rom: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds Sequence/PDU list logic used by RFC-3720 for
DataSequenceInOrder=3D[Yes,No] and DataPDUInOrder=3D[Yes,No].  It also
includes support for these modes of support for generating iSCSI
DataIN response data from iscsi_target.c:iscsi_send_data_in().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_seq_and_pdu_list.c     |  712 +++++++++++++=
++++++++
 drivers/target/iscsi/iscsi_seq_and_pdu_list.h     |   88 +++
 drivers/target/iscsi/iscsi_target_datain_values.c |  549 +++++++++++++=
+++
 drivers/target/iscsi/iscsi_target_datain_values.h |   15 +
 4 files changed, 1364 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/iscsi/iscsi_seq_and_pdu_list.c
 create mode 100644 drivers/target/iscsi/iscsi_seq_and_pdu_list.h
 create mode 100644 drivers/target/iscsi/iscsi_target_datain_values.c
 create mode 100644 drivers/target/iscsi/iscsi_target_datain_values.h

diff --git a/drivers/target/iscsi/iscsi_seq_and_pdu_list.c b/drivers/ta=
rget/iscsi/iscsi_seq_and_pdu_list.c
new file mode 100644
index 0000000..732215f
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_seq_and_pdu_list.c
@@ -0,0 +1,712 @@
+/*********************************************************************=
**********
+ * This file contains main functions related to iSCSI DataSequenceInOr=
der=3DNo
+ * and DataPDUInOrder=3DNo.
+ *
+ * Copyright (c) 2003 PyX Technologies, Inc.
+ * Copyright (c) 2006-2007 SBE, Inc.  All Rights Reserved.
+ =C2=A9 Copyright 2007-2011 RisingTide Systems LLC.
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
+#include <linux/slab.h>
+#include <linux/random.h>
+
+#include "iscsi_debug.h"
+#include "iscsi_target_core.h"
+#include "iscsi_target_util.h"
+#include "iscsi_seq_and_pdu_list.h"
+
+#define OFFLOAD_BUF_SIZE	32768
+
+/*	iscsi_dump_seq_list():
+ *
+ *
+ */
+void iscsi_dump_seq_list(struct iscsi_cmd *cmd)
+{
+	int i;
+	struct iscsi_seq *seq;
+
+	printk(KERN_INFO "Dumping Sequence List for ITT: 0x%08x:\n",
+			cmd->init_task_tag);
+
+	for (i =3D 0; i < cmd->seq_count; i++) {
+		seq =3D &cmd->seq_list[i];
+		printk(KERN_INFO "i: %d, pdu_start: %d, pdu_count: %d,"
+			" offset: %d, xfer_len: %d, seq_send_order: %d,"
+			" seq_no: %d\n", i, seq->pdu_start, seq->pdu_count,
+			seq->offset, seq->xfer_len, seq->seq_send_order,
+			seq->seq_no);
+	}
+}
+
+/*	iscsi_dump_pdu_list():
+ *
+ *
+ */
+void iscsi_dump_pdu_list(struct iscsi_cmd *cmd)
+{
+	int i;
+	struct iscsi_pdu *pdu;
+
+	printk(KERN_INFO "Dumping PDU List for ITT: 0x%08x:\n",
+			cmd->init_task_tag);
+
+	for (i =3D 0; i < cmd->pdu_count; i++) {
+		pdu =3D &cmd->pdu_list[i];
+		printk(KERN_INFO "i: %d, offset: %d, length: %d,"
+			" pdu_send_order: %d, seq_no: %d\n", i, pdu->offset,
+			pdu->length, pdu->pdu_send_order, pdu->seq_no);
+	}
+}
+
+/*	iscsi_ordered_seq_lists():
+ *
+ *
+ */
+static inline void iscsi_ordered_seq_lists(
+	struct iscsi_cmd *cmd,
+	u8 type)
+{
+	u32 i, seq_count =3D 0;
+
+	for (i =3D 0; i < cmd->seq_count; i++) {
+		if (cmd->seq_list[i].type !=3D SEQTYPE_NORMAL)
+			continue;
+		cmd->seq_list[i].seq_send_order =3D seq_count++;
+	}
+}
+
+/*	iscsi_ordered_pdu_lists():
+ *
+ *
+ */
+static inline void iscsi_ordered_pdu_lists(
+	struct iscsi_cmd *cmd,
+	u8 type)
+{
+	u32 i, pdu_send_order =3D 0, seq_no =3D 0;
+
+	for (i =3D 0; i < cmd->pdu_count; i++) {
+redo:
+		if (cmd->pdu_list[i].seq_no =3D=3D seq_no) {
+			cmd->pdu_list[i].pdu_send_order =3D pdu_send_order++;
+			continue;
+		}
+		seq_no++;
+		pdu_send_order =3D 0;
+		goto redo;
+	}
+}
+
+/*	iscsi_create_random_array():
+ *
+ *	Generate count random values into array.
+ *	Use 0x80000000 to mark generates valued in array[].
+ */
+static inline void iscsi_create_random_array(u32 *array, u32 count)
+{
+	int i, j, k;
+
+	if (count =3D=3D 1) {
+		array[0] =3D 0;
+		return;
+	}
+
+	for (i =3D 0; i < count; i++) {
+redo:
+		get_random_bytes(&j, sizeof(u32));
+		j =3D (1 + (int) (9999 + 1) - j) % count;
+		for (k =3D 0; k < i + 1; k++) {
+			j |=3D 0x80000000;
+			if ((array[k] & 0x80000000) && (array[k] =3D=3D j))
+				goto redo;
+		}
+		array[i] =3D j;
+	}
+
+	for (i =3D 0; i < count; i++)
+		array[i] &=3D ~0x80000000;
+
+	return;
+}
+
+/*	iscsi_randomize_pdu_lists():
+ *
+ *
+ */
+static inline int iscsi_randomize_pdu_lists(
+	struct iscsi_cmd *cmd,
+	u8 type)
+{
+	int i =3D 0;
+	u32 *array, pdu_count, seq_count =3D 0, seq_no =3D 0, seq_offset =3D =
0;
+
+	for (pdu_count =3D 0; pdu_count < cmd->pdu_count; pdu_count++) {
+redo:
+		if (cmd->pdu_list[pdu_count].seq_no =3D=3D seq_no) {
+			seq_count++;
+			continue;
+		}
+		array =3D kzalloc(seq_count * sizeof(u32), GFP_KERNEL);
+		if (!(array)) {
+			printk(KERN_ERR "Unable to allocate memory"
+				" for random array.\n");
+			return -1;
+		}
+		iscsi_create_random_array(array, seq_count);
+
+		for (i =3D 0; i < seq_count; i++)
+			cmd->pdu_list[seq_offset+i].pdu_send_order =3D array[i];
+
+		kfree(array);
+
+		seq_offset +=3D seq_count;
+		seq_count =3D 0;
+		seq_no++;
+		goto redo;
+	}
+
+	if (seq_count) {
+		array =3D kzalloc(seq_count * sizeof(u32), GFP_KERNEL);
+		if (!(array)) {
+			printk(KERN_ERR "Unable to allocate memory for"
+				" random array.\n");
+			return -1;
+		}
+		iscsi_create_random_array(array, seq_count);
+
+		for (i =3D 0; i < seq_count; i++)
+			cmd->pdu_list[seq_offset+i].pdu_send_order =3D array[i];
+
+		kfree(array);
+	}
+
+	return 0;
+}
+
+/*	iscsi_randomize_seq_lists():
+ *
+ *
+ */
+static inline int iscsi_randomize_seq_lists(
+	struct iscsi_cmd *cmd,
+	u8 type)
+{
+	int i, j =3D 0;
+	u32 *array, seq_count =3D cmd->seq_count;
+
+	if ((type =3D=3D PDULIST_IMMEDIATE) || (type =3D=3D PDULIST_UNSOLICIT=
ED))
+		seq_count--;
+	else if (type =3D=3D PDULIST_IMMEDIATE_AND_UNSOLICITED)
+		seq_count -=3D 2;
+
+	if (!seq_count)
+		return 0;
+
+	array =3D kzalloc(seq_count * sizeof(u32), GFP_KERNEL);
+	if (!(array)) {
+		printk(KERN_ERR "Unable to allocate memory for random array.\n");
+		return -1;
+	}
+	iscsi_create_random_array(array, seq_count);
+
+	for (i =3D 0; i < cmd->seq_count; i++) {
+		if (cmd->seq_list[i].type !=3D SEQTYPE_NORMAL)
+			continue;
+		cmd->seq_list[i].seq_send_order =3D array[j++];
+	}
+
+	kfree(array);
+	return 0;
+}
+
+/*	iscsi_determine_counts_for_list():
+ *
+ *
+ */
+static inline void iscsi_determine_counts_for_list(
+	struct iscsi_cmd *cmd,
+	struct iscsi_build_list *bl,
+	u32 *seq_count,
+	u32 *pdu_count)
+{
+	int check_immediate =3D 0;
+	u32 burstlength =3D 0, offset =3D 0;
+	u32 unsolicited_data_length =3D 0;
+	struct iscsi_conn *conn =3D CONN(cmd);
+
+	if ((bl->type =3D=3D PDULIST_IMMEDIATE) ||
+	    (bl->type =3D=3D PDULIST_IMMEDIATE_AND_UNSOLICITED))
+		check_immediate =3D 1;
+
+	if ((bl->type =3D=3D PDULIST_UNSOLICITED) ||
+	    (bl->type =3D=3D PDULIST_IMMEDIATE_AND_UNSOLICITED))
+		unsolicited_data_length =3D (cmd->data_length >
+			SESS_OPS_C(conn)->FirstBurstLength) ?
+			SESS_OPS_C(conn)->FirstBurstLength : cmd->data_length;
+
+	while (offset < cmd->data_length) {
+		*pdu_count +=3D 1;
+
+		if (check_immediate) {
+			check_immediate =3D 0;
+			offset +=3D bl->immediate_data_length;
+			*seq_count +=3D 1;
+			if (unsolicited_data_length)
+				unsolicited_data_length -=3D
+					bl->immediate_data_length;
+			continue;
+		}
+		if (unsolicited_data_length > 0) {
+			if ((offset + CONN_OPS(conn)->MaxRecvDataSegmentLength)
+					>=3D cmd->data_length) {
+				unsolicited_data_length -=3D
+					(cmd->data_length - offset);
+				offset +=3D (cmd->data_length - offset);
+				continue;
+			}
+			if ((offset + CONN_OPS(conn)->MaxRecvDataSegmentLength)
+					>=3D SESS_OPS_C(conn)->FirstBurstLength) {
+				unsolicited_data_length -=3D
+					(SESS_OPS_C(conn)->FirstBurstLength -
+					offset);
+				offset +=3D (SESS_OPS_C(conn)->FirstBurstLength -
+					offset);
+				burstlength =3D 0;
+				*seq_count +=3D 1;
+				continue;
+			}
+
+			offset +=3D CONN_OPS(conn)->MaxRecvDataSegmentLength;
+			unsolicited_data_length -=3D
+				CONN_OPS(conn)->MaxRecvDataSegmentLength;
+			continue;
+		}
+		if ((offset + CONN_OPS(conn)->MaxRecvDataSegmentLength) >=3D
+		     cmd->data_length) {
+			offset +=3D (cmd->data_length - offset);
+			continue;
+		}
+		if ((burstlength + CONN_OPS(conn)->MaxRecvDataSegmentLength) >=3D
+		     SESS_OPS_C(conn)->MaxBurstLength) {
+			offset +=3D (SESS_OPS_C(conn)->MaxBurstLength -
+					burstlength);
+			burstlength =3D 0;
+			*seq_count +=3D 1;
+			continue;
+		}
+
+		burstlength +=3D CONN_OPS(conn)->MaxRecvDataSegmentLength;
+		offset +=3D CONN_OPS(conn)->MaxRecvDataSegmentLength;
+	}
+}
+
+
+/*	iscsi_build_pdu_and_seq_list():
+ *
+ *	Builds PDU and/or Sequence list,  called while DataSequenceInOrder=3D=
No
+ *	and DataPDUInOrder=3DNo.
+ */
+static inline int iscsi_build_pdu_and_seq_list(
+	struct iscsi_cmd *cmd,
+	struct iscsi_build_list *bl)
+{
+	int check_immediate =3D 0, datapduinorder, datasequenceinorder;
+	u32 burstlength =3D 0, offset =3D 0, i =3D 0;
+	u32 pdu_count =3D 0, seq_no =3D 0, unsolicited_data_length =3D 0;
+	struct iscsi_conn *conn =3D CONN(cmd);
+	struct iscsi_pdu *pdu =3D cmd->pdu_list;
+	struct iscsi_seq *seq =3D cmd->seq_list;
+
+	datapduinorder =3D SESS_OPS_C(conn)->DataPDUInOrder;
+	datasequenceinorder =3D SESS_OPS_C(conn)->DataSequenceInOrder;
+
+	if ((bl->type =3D=3D PDULIST_IMMEDIATE) ||
+	    (bl->type =3D=3D PDULIST_IMMEDIATE_AND_UNSOLICITED))
+		check_immediate =3D 1;
+
+	if ((bl->type =3D=3D PDULIST_UNSOLICITED) ||
+	    (bl->type =3D=3D PDULIST_IMMEDIATE_AND_UNSOLICITED))
+		unsolicited_data_length =3D (cmd->data_length >
+			SESS_OPS_C(conn)->FirstBurstLength) ?
+			SESS_OPS_C(conn)->FirstBurstLength : cmd->data_length;
+
+	while (offset < cmd->data_length) {
+		pdu_count++;
+		if (!datapduinorder) {
+			pdu[i].offset =3D offset;
+			pdu[i].seq_no =3D seq_no;
+		}
+		if (!datasequenceinorder && (pdu_count =3D=3D 1)) {
+			seq[seq_no].pdu_start =3D i;
+			seq[seq_no].seq_no =3D seq_no;
+			seq[seq_no].offset =3D offset;
+			seq[seq_no].orig_offset =3D offset;
+		}
+
+		if (check_immediate) {
+			check_immediate =3D 0;
+			if (!datapduinorder) {
+				pdu[i].type =3D PDUTYPE_IMMEDIATE;
+				pdu[i++].length =3D bl->immediate_data_length;
+			}
+			if (!datasequenceinorder) {
+				seq[seq_no].type =3D SEQTYPE_IMMEDIATE;
+				seq[seq_no].pdu_count =3D 1;
+				seq[seq_no].xfer_len =3D
+					bl->immediate_data_length;
+			}
+			offset +=3D bl->immediate_data_length;
+			pdu_count =3D 0;
+			seq_no++;
+			if (unsolicited_data_length)
+				unsolicited_data_length -=3D
+					bl->immediate_data_length;
+			continue;
+		}
+		if (unsolicited_data_length > 0) {
+			if ((offset +
+			     CONN_OPS(conn)->MaxRecvDataSegmentLength) >=3D
+			     cmd->data_length) {
+				if (!datapduinorder) {
+					pdu[i].type =3D PDUTYPE_UNSOLICITED;
+					pdu[i].length =3D
+						(cmd->data_length - offset);
+				}
+				if (!datasequenceinorder) {
+					seq[seq_no].type =3D SEQTYPE_UNSOLICITED;
+					seq[seq_no].pdu_count =3D pdu_count;
+					seq[seq_no].xfer_len =3D (burstlength +
+						(cmd->data_length - offset));
+				}
+				unsolicited_data_length -=3D
+						(cmd->data_length - offset);
+				offset +=3D (cmd->data_length - offset);
+				continue;
+			}
+			if ((offset +
+			     CONN_OPS(conn)->MaxRecvDataSegmentLength) >=3D
+					SESS_OPS_C(conn)->FirstBurstLength) {
+				if (!datapduinorder) {
+					pdu[i].type =3D PDUTYPE_UNSOLICITED;
+					pdu[i++].length =3D
+					   (SESS_OPS_C(conn)->FirstBurstLength -
+						offset);
+				}
+				if (!datasequenceinorder) {
+					seq[seq_no].type =3D SEQTYPE_UNSOLICITED;
+					seq[seq_no].pdu_count =3D pdu_count;
+					seq[seq_no].xfer_len =3D (burstlength +
+					   (SESS_OPS_C(conn)->FirstBurstLength -
+						offset));
+				}
+				unsolicited_data_length -=3D
+					(SESS_OPS_C(conn)->FirstBurstLength -
+						offset);
+				offset +=3D (SESS_OPS_C(conn)->FirstBurstLength -
+						offset);
+				burstlength =3D 0;
+				pdu_count =3D 0;
+				seq_no++;
+				continue;
+			}
+
+			if (!datapduinorder) {
+				pdu[i].type =3D PDUTYPE_UNSOLICITED;
+				pdu[i++].length =3D
+				     CONN_OPS(conn)->MaxRecvDataSegmentLength;
+			}
+			burstlength +=3D CONN_OPS(conn)->MaxRecvDataSegmentLength;
+			offset +=3D CONN_OPS(conn)->MaxRecvDataSegmentLength;
+			unsolicited_data_length -=3D
+				CONN_OPS(conn)->MaxRecvDataSegmentLength;
+			continue;
+		}
+		if ((offset + CONN_OPS(conn)->MaxRecvDataSegmentLength) >=3D
+		     cmd->data_length) {
+			if (!datapduinorder) {
+				pdu[i].type =3D PDUTYPE_NORMAL;
+				pdu[i].length =3D (cmd->data_length - offset);
+			}
+			if (!datasequenceinorder) {
+				seq[seq_no].type =3D SEQTYPE_NORMAL;
+				seq[seq_no].pdu_count =3D pdu_count;
+				seq[seq_no].xfer_len =3D (burstlength +
+					(cmd->data_length - offset));
+			}
+			offset +=3D (cmd->data_length - offset);
+			continue;
+		}
+		if ((burstlength + CONN_OPS(conn)->MaxRecvDataSegmentLength) >=3D
+		     SESS_OPS_C(conn)->MaxBurstLength) {
+			if (!datapduinorder) {
+				pdu[i].type =3D PDUTYPE_NORMAL;
+				pdu[i++].length =3D
+					(SESS_OPS_C(conn)->MaxBurstLength -
+						burstlength);
+			}
+			if (!datasequenceinorder) {
+				seq[seq_no].type =3D SEQTYPE_NORMAL;
+				seq[seq_no].pdu_count =3D pdu_count;
+				seq[seq_no].xfer_len =3D (burstlength +
+					(SESS_OPS_C(conn)->MaxBurstLength -
+					burstlength));
+			}
+			offset +=3D (SESS_OPS_C(conn)->MaxBurstLength -
+					burstlength);
+			burstlength =3D 0;
+			pdu_count =3D 0;
+			seq_no++;
+			continue;
+		}
+
+		if (!datapduinorder) {
+			pdu[i].type =3D PDUTYPE_NORMAL;
+			pdu[i++].length =3D
+				CONN_OPS(conn)->MaxRecvDataSegmentLength;
+		}
+		burstlength +=3D CONN_OPS(conn)->MaxRecvDataSegmentLength;
+		offset +=3D CONN_OPS(conn)->MaxRecvDataSegmentLength;
+	}
+
+	if (!datasequenceinorder) {
+		if (bl->data_direction & ISCSI_PDU_WRITE) {
+			if (bl->randomize & RANDOM_R2T_OFFSETS) {
+				if (iscsi_randomize_seq_lists(cmd, bl->type)
+						< 0)
+					return -1;
+			} else
+				iscsi_ordered_seq_lists(cmd, bl->type);
+		} else if (bl->data_direction & ISCSI_PDU_READ) {
+			if (bl->randomize & RANDOM_DATAIN_SEQ_OFFSETS) {
+				if (iscsi_randomize_seq_lists(cmd, bl->type)
+						< 0)
+					return -1;
+			} else
+				iscsi_ordered_seq_lists(cmd, bl->type);
+		}
+#if 0
+		iscsi_dump_seq_list(cmd);
+#endif
+	}
+	if (!datapduinorder) {
+		if (bl->data_direction & ISCSI_PDU_WRITE) {
+			if (bl->randomize & RANDOM_DATAOUT_PDU_OFFSETS) {
+				if (iscsi_randomize_pdu_lists(cmd, bl->type)
+						< 0)
+					return -1;
+			} else
+				iscsi_ordered_pdu_lists(cmd, bl->type);
+		} else if (bl->data_direction & ISCSI_PDU_READ) {
+			if (bl->randomize & RANDOM_DATAIN_PDU_OFFSETS) {
+				if (iscsi_randomize_pdu_lists(cmd, bl->type)
+						< 0)
+					return -1;
+			} else
+				iscsi_ordered_pdu_lists(cmd, bl->type);
+		}
+#if 0
+		iscsi_dump_pdu_list(cmd);
+#endif
+	}
+
+	return 0;
+}
+
+/*	iscsi_do_build_list():
+ *
+ *	Only called while DataSequenceInOrder=3DNo or DataPDUInOrder=3DNo.
+ */
+int iscsi_do_build_list(
+	struct iscsi_cmd *cmd,
+	struct iscsi_build_list *bl)
+{
+	u32 pdu_count =3D 0, seq_count =3D 1;
+	struct iscsi_conn *conn =3D CONN(cmd);
+	struct iscsi_pdu *pdu =3D NULL;
+	struct iscsi_seq *seq =3D NULL;
+
+	iscsi_determine_counts_for_list(cmd, bl, &seq_count, &pdu_count);
+
+	if (!SESS_OPS_C(conn)->DataSequenceInOrder) {
+		seq =3D kzalloc(seq_count * sizeof(struct iscsi_seq), GFP_ATOMIC);
+		if (!(seq)) {
+			printk(KERN_ERR "Unable to allocate struct iscsi_seq list\n");
+			return -1;
+		}
+		cmd->seq_list =3D seq;
+		cmd->seq_count =3D seq_count;
+	}
+
+	if (!SESS_OPS_C(conn)->DataPDUInOrder) {
+		pdu =3D kzalloc(pdu_count * sizeof(struct iscsi_pdu), GFP_ATOMIC);
+		if (!(pdu)) {
+			printk(KERN_ERR "Unable to allocate struct iscsi_pdu list.\n");
+			kfree(seq);
+			return -1;
+		}
+		cmd->pdu_list =3D pdu;
+		cmd->pdu_count =3D pdu_count;
+	}
+
+	return iscsi_build_pdu_and_seq_list(cmd, bl);
+}
+
+/*	iscsi_get_pdu_holder():
+ *
+ *
+ */
+struct iscsi_pdu *iscsi_get_pdu_holder(
+	struct iscsi_cmd *cmd,
+	u32 offset,
+	u32 length)
+{
+	u32 i;
+	struct iscsi_pdu *pdu =3D NULL;
+
+	if (!cmd->pdu_list) {
+		printk(KERN_ERR "struct iscsi_cmd->pdu_list is NULL!\n");
+		return NULL;
+	}
+
+	pdu =3D &cmd->pdu_list[0];
+
+	for (i =3D 0; i < cmd->pdu_count; i++)
+		if ((pdu[i].offset =3D=3D offset) && (pdu[i].length =3D=3D length))
+			return &pdu[i];
+
+	printk(KERN_ERR "Unable to locate PDU holder for ITT: 0x%08x, Offset:=
"
+		" %u, Length: %u\n", cmd->init_task_tag, offset, length);
+	return NULL;
+}
+
+/*	iscsi_get_pdu_holder_for_seq():
+ *
+ *
+ */
+struct iscsi_pdu *iscsi_get_pdu_holder_for_seq(
+	struct iscsi_cmd *cmd,
+	struct iscsi_seq *seq)
+{
+	u32 i;
+	struct iscsi_conn *conn =3D CONN(cmd);
+	struct iscsi_pdu *pdu =3D NULL;
+
+	if (!cmd->pdu_list) {
+		printk(KERN_ERR "struct iscsi_cmd->pdu_list is NULL!\n");
+		return NULL;
+	}
+
+	if (SESS_OPS_C(conn)->DataSequenceInOrder) {
+redo:
+		pdu =3D &cmd->pdu_list[cmd->pdu_start];
+
+		for (i =3D 0; pdu[i].seq_no !=3D cmd->seq_no; i++) {
+#if 0
+			printk(KERN_INFO "pdu[i].seq_no: %d, pdu[i].pdu"
+				"_send_order: %d, pdu[i].offset: %d,"
+				" pdu[i].length: %d\n", pdu[i].seq_no,
+				pdu[i].pdu_send_order, pdu[i].offset,
+				pdu[i].length);
+#endif
+			if (pdu[i].pdu_send_order =3D=3D cmd->pdu_send_order) {
+				cmd->pdu_send_order++;
+				return &pdu[i];
+			}
+		}
+
+		cmd->pdu_start +=3D cmd->pdu_send_order;
+		cmd->pdu_send_order =3D 0;
+		cmd->seq_no++;
+
+		if (cmd->pdu_start < cmd->pdu_count)
+			goto redo;
+
+		printk(KERN_ERR "Command ITT: 0x%08x unable to locate"
+			" struct iscsi_pdu for cmd->pdu_send_order: %u.\n",
+			cmd->init_task_tag, cmd->pdu_send_order);
+		return NULL;
+	} else {
+		if (!seq) {
+			printk(KERN_ERR "struct iscsi_seq is NULL!\n");
+			return NULL;
+		}
+#if 0
+		printk(KERN_INFO "seq->pdu_start: %d, seq->pdu_count: %d,"
+			" seq->seq_no: %d\n", seq->pdu_start, seq->pdu_count,
+			seq->seq_no);
+#endif
+		pdu =3D &cmd->pdu_list[seq->pdu_start];
+
+		if (seq->pdu_send_order =3D=3D seq->pdu_count) {
+			printk(KERN_ERR "Command ITT: 0x%08x seq->pdu_send"
+				"_order: %u equals seq->pdu_count: %u\n",
+				cmd->init_task_tag, seq->pdu_send_order,
+				seq->pdu_count);
+			return NULL;
+		}
+
+		for (i =3D 0; i < seq->pdu_count; i++) {
+			if (pdu[i].pdu_send_order =3D=3D seq->pdu_send_order) {
+				seq->pdu_send_order++;
+				return &pdu[i];
+			}
+		}
+
+		printk(KERN_ERR "Command ITT: 0x%08x unable to locate iscsi"
+			"_pdu_t for seq->pdu_send_order: %u.\n",
+			cmd->init_task_tag, seq->pdu_send_order);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/*	iscsi_get_seq_holder():
+ *
+ *
+ */
+struct iscsi_seq *iscsi_get_seq_holder(
+	struct iscsi_cmd *cmd,
+	u32 offset,
+	u32 length)
+{
+	u32 i;
+
+	if (!cmd->seq_list) {
+		printk(KERN_ERR "struct iscsi_cmd->seq_list is NULL!\n");
+		return NULL;
+	}
+
+	for (i =3D 0; i < cmd->seq_count; i++) {
+#if 0
+		printk(KERN_INFO "seq_list[i].orig_offset: %d, seq_list[i]."
+			"xfer_len: %d, seq_list[i].seq_no %u\n",
+			cmd->seq_list[i].orig_offset, cmd->seq_list[i].xfer_len,
+			cmd->seq_list[i].seq_no);
+#endif
+		if ((cmd->seq_list[i].orig_offset +
+				cmd->seq_list[i].xfer_len) >=3D
+				(offset + length))
+			return &cmd->seq_list[i];
+	}
+
+	printk(KERN_ERR "Unable to locate Sequence holder for ITT: 0x%08x,"
+		" Offset: %u, Length: %u\n", cmd->init_task_tag, offset,
+		length);
+	return NULL;
+}
diff --git a/drivers/target/iscsi/iscsi_seq_and_pdu_list.h b/drivers/ta=
rget/iscsi/iscsi_seq_and_pdu_list.h
new file mode 100644
index 0000000..7b4c1bd
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_seq_and_pdu_list.h
@@ -0,0 +1,88 @@
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
+	u8		data_direction;
+	u8		randomize;
+	u8		type;
+	u32		immediate_data_length;
+} ____cacheline_aligned;
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
+extern struct iscsi_global *iscsi_global;
+
+extern int iscsi_do_build_list(struct iscsi_cmd *, struct iscsi_build_=
list *);
+extern struct iscsi_pdu *iscsi_get_pdu_holder(struct iscsi_cmd *, u32,=
 u32);
+extern struct iscsi_pdu *iscsi_get_pdu_holder_for_seq(struct iscsi_cmd=
 *, struct iscsi_seq *);
+extern struct iscsi_seq *iscsi_get_seq_holder(struct iscsi_cmd *, u32,=
 u32);
+
+#endif /* ISCSI_SEQ_AND_PDU_LIST_H */
diff --git a/drivers/target/iscsi/iscsi_target_datain_values.c b/driver=
s/target/iscsi/iscsi_target_datain_values.c
new file mode 100644
index 0000000..b6986d3
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_datain_values.c
@@ -0,0 +1,549 @@
+/*********************************************************************=
**********
+ * This file contains the iSCSI Target DataIN value generation functio=
ns.
+ *
+ * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
+ * Copyright (c) 2006 SBE, Inc.  All Rights Reserved.
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
+#include <linux/delay.h>
+#include <linux/string.h>
+#include <linux/timer.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/smp_lock.h>
+#include <linux/in.h>
+#include <scsi/iscsi_proto.h>
+
+#include "iscsi_debug.h"
+#include "iscsi_target_core.h"
+#include "iscsi_seq_and_pdu_list.h"
+#include "iscsi_target_erl1.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target_datain_values.h"
+
+struct iscsi_datain_req *iscsi_allocate_datain_req(void)
+{
+	struct iscsi_datain_req *dr;
+
+	dr =3D kmem_cache_zalloc(lio_dr_cache, GFP_ATOMIC);
+	if (!(dr)) {
+		printk(KERN_ERR "Unable to allocate memory for"
+				" struct iscsi_datain_req\n");
+		return NULL;
+	}
+	INIT_LIST_HEAD(&dr->dr_list);
+
+	return dr;
+}
+
+void iscsi_attach_datain_req(struct iscsi_cmd *cmd, struct iscsi_datai=
n_req *dr)
+{
+	spin_lock(&cmd->datain_lock);
+	list_add_tail(&dr->dr_list, &cmd->datain_list);
+	spin_unlock(&cmd->datain_lock);
+}
+
+void iscsi_free_datain_req(struct iscsi_cmd *cmd, struct iscsi_datain_=
req *dr)
+{
+	spin_lock(&cmd->datain_lock);
+	list_del(&dr->dr_list);
+	spin_unlock(&cmd->datain_lock);
+
+	kmem_cache_free(lio_dr_cache, dr);
+}
+
+void iscsi_free_all_datain_reqs(struct iscsi_cmd *cmd)
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
+struct iscsi_datain_req *iscsi_get_datain_req(struct iscsi_cmd *cmd)
+{
+	struct iscsi_datain_req *dr;
+
+	if (list_empty(&cmd->datain_list)) {
+		printk(KERN_ERR "cmd->datain_list is empty for ITT:"
+			" 0x%08x\n", cmd->init_task_tag);
+		return NULL;
+	}
+	list_for_each_entry(dr, &cmd->datain_list, dr_list)
+		break;
+
+	return dr;
+}
+
+/*	iscsi_set_datain_values_yes_and_yes():
+ *
+ *	For Normal and Recovery DataSequenceInOrder=3DYes and DataPDUInOrde=
r=3DYes.
+ */
+static inline struct iscsi_datain_req *iscsi_set_datain_values_yes_and=
_yes(
+	struct iscsi_cmd *cmd,
+	struct iscsi_datain *datain)
+{
+	u32 next_burst_len, read_data_done, read_data_left;
+	struct iscsi_conn *conn =3D CONN(cmd);
+	struct iscsi_datain_req *dr;
+
+	dr =3D iscsi_get_datain_req(cmd);
+	if (!(dr))
+		return NULL;
+
+	if (dr->recovery && dr->generate_recovery_values) {
+		if (iscsi_create_recovery_datain_values_datasequenceinorder_yes(
+					cmd, dr) < 0)
+			return NULL;
+
+		dr->generate_recovery_values =3D 0;
+	}
+
+	next_burst_len =3D (!dr->recovery) ?
+			cmd->next_burst_len : dr->next_burst_len;
+	read_data_done =3D (!dr->recovery) ?
+			cmd->read_data_done : dr->read_data_done;
+
+	read_data_left =3D (cmd->data_length - read_data_done);
+	if (!(read_data_left)) {
+		printk(KERN_ERR "ITT: 0x%08x read_data_left is zero!\n",
+				cmd->init_task_tag);
+		return NULL;
+	}
+
+	if ((read_data_left <=3D CONN_OPS(conn)->MaxRecvDataSegmentLength) &&
+	    (read_data_left <=3D (SESS_OPS_C(conn)->MaxBurstLength -
+	     next_burst_len))) {
+		datain->length =3D read_data_left;
+
+		datain->flags |=3D (ISCSI_FLAG_CMD_FINAL | ISCSI_FLAG_DATA_STATUS);
+		if (SESS_OPS_C(conn)->ErrorRecoveryLevel > 0)
+			datain->flags |=3D ISCSI_FLAG_DATA_ACK;
+	} else {
+		if ((next_burst_len +
+		     CONN_OPS(conn)->MaxRecvDataSegmentLength) <
+		     SESS_OPS_C(conn)->MaxBurstLength) {
+			datain->length =3D
+				CONN_OPS(conn)->MaxRecvDataSegmentLength;
+			next_burst_len +=3D datain->length;
+		} else {
+			datain->length =3D (SESS_OPS_C(conn)->MaxBurstLength -
+					  next_burst_len);
+			next_burst_len =3D 0;
+
+			datain->flags |=3D ISCSI_FLAG_CMD_FINAL;
+			if (SESS_OPS_C(conn)->ErrorRecoveryLevel > 0)
+				datain->flags |=3D ISCSI_FLAG_DATA_ACK;
+		}
+	}
+
+	datain->data_sn =3D (!dr->recovery) ? cmd->data_sn++ : dr->data_sn++;
+	datain->offset =3D read_data_done;
+
+	if (!dr->recovery) {
+		cmd->next_burst_len =3D next_burst_len;
+		cmd->read_data_done +=3D datain->length;
+	} else {
+		dr->next_burst_len =3D next_burst_len;
+		dr->read_data_done +=3D datain->length;
+	}
+
+	if (!dr->recovery) {
+		if (datain->flags & ISCSI_FLAG_DATA_STATUS)
+			dr->dr_complete =3D DATAIN_COMPLETE_NORMAL;
+
+		return dr;
+	}
+
+	if (!dr->runlength) {
+		if (datain->flags & ISCSI_FLAG_DATA_STATUS) {
+			dr->dr_complete =3D
+			    (dr->recovery =3D=3D DATAIN_WITHIN_COMMAND_RECOVERY) ?
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY :
+				DATAIN_COMPLETE_CONNECTION_RECOVERY;
+		}
+	} else {
+		if ((dr->begrun + dr->runlength) =3D=3D dr->data_sn) {
+			dr->dr_complete =3D
+			    (dr->recovery =3D=3D DATAIN_WITHIN_COMMAND_RECOVERY) ?
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY :
+				DATAIN_COMPLETE_CONNECTION_RECOVERY;
+		}
+	}
+
+	return dr;
+}
+
+/*	iscsi_set_datain_values_no_and_yes():
+ *
+ *	For Normal and Recovery DataSequenceInOrder=3DNo and DataPDUInOrder=
=3DYes.
+ */
+static inline struct iscsi_datain_req *iscsi_set_datain_values_no_and_=
yes(
+	struct iscsi_cmd *cmd,
+	struct iscsi_datain *datain)
+{
+	u32 offset, read_data_done, read_data_left, seq_send_order;
+	struct iscsi_conn *conn =3D CONN(cmd);
+	struct iscsi_datain_req *dr;
+	struct iscsi_seq *seq;
+
+	dr =3D iscsi_get_datain_req(cmd);
+	if (!(dr))
+		return NULL;
+
+	if (dr->recovery && dr->generate_recovery_values) {
+		if (iscsi_create_recovery_datain_values_datasequenceinorder_no(
+					cmd, dr) < 0)
+			return NULL;
+
+		dr->generate_recovery_values =3D 0;
+	}
+
+	read_data_done =3D (!dr->recovery) ?
+			cmd->read_data_done : dr->read_data_done;
+	seq_send_order =3D (!dr->recovery) ?
+			cmd->seq_send_order : dr->seq_send_order;
+
+	read_data_left =3D (cmd->data_length - read_data_done);
+	if (!(read_data_left)) {
+		printk(KERN_ERR "ITT: 0x%08x read_data_left is zero!\n",
+				cmd->init_task_tag);
+		return NULL;
+	}
+
+	seq =3D iscsi_get_seq_holder_for_datain(cmd, seq_send_order);
+	if (!(seq))
+		return NULL;
+
+	seq->sent =3D 1;
+
+	if (!dr->recovery && !seq->next_burst_len)
+		seq->first_datasn =3D cmd->data_sn;
+
+	offset =3D (seq->offset + seq->next_burst_len);
+
+	if ((offset + CONN_OPS(conn)->MaxRecvDataSegmentLength) >=3D
+	     cmd->data_length) {
+		datain->length =3D (cmd->data_length - offset);
+		datain->offset =3D offset;
+
+		datain->flags |=3D ISCSI_FLAG_CMD_FINAL;
+		if (SESS_OPS_C(conn)->ErrorRecoveryLevel > 0)
+			datain->flags |=3D ISCSI_FLAG_DATA_ACK;
+
+		seq->next_burst_len =3D 0;
+		seq_send_order++;
+	} else {
+		if ((seq->next_burst_len +
+		     CONN_OPS(conn)->MaxRecvDataSegmentLength) <
+		     SESS_OPS_C(conn)->MaxBurstLength) {
+			datain->length =3D
+				CONN_OPS(conn)->MaxRecvDataSegmentLength;
+			datain->offset =3D (seq->offset + seq->next_burst_len);
+
+			seq->next_burst_len +=3D datain->length;
+		} else {
+			datain->length =3D (SESS_OPS_C(conn)->MaxBurstLength -
+					  seq->next_burst_len);
+			datain->offset =3D (seq->offset + seq->next_burst_len);
+
+			datain->flags |=3D ISCSI_FLAG_CMD_FINAL;
+			if (SESS_OPS_C(conn)->ErrorRecoveryLevel > 0)
+				datain->flags |=3D ISCSI_FLAG_DATA_ACK;
+
+			seq->next_burst_len =3D 0;
+			seq_send_order++;
+		}
+	}
+
+	if ((read_data_done + datain->length) =3D=3D cmd->data_length)
+		datain->flags |=3D ISCSI_FLAG_DATA_STATUS;
+
+	datain->data_sn =3D (!dr->recovery) ? cmd->data_sn++ : dr->data_sn++;
+	if (!dr->recovery) {
+		cmd->seq_send_order =3D seq_send_order;
+		cmd->read_data_done +=3D datain->length;
+	} else {
+		dr->seq_send_order =3D seq_send_order;
+		dr->read_data_done +=3D datain->length;
+	}
+
+	if (!dr->recovery) {
+		if (datain->flags & ISCSI_FLAG_CMD_FINAL)
+			seq->last_datasn =3D datain->data_sn;
+		if (datain->flags & ISCSI_FLAG_DATA_STATUS)
+			dr->dr_complete =3D DATAIN_COMPLETE_NORMAL;
+
+		return dr;
+	}
+
+	if (!dr->runlength) {
+		if (datain->flags & ISCSI_FLAG_DATA_STATUS) {
+			dr->dr_complete =3D
+			    (dr->recovery =3D=3D DATAIN_WITHIN_COMMAND_RECOVERY) ?
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY :
+				DATAIN_COMPLETE_CONNECTION_RECOVERY;
+		}
+	} else {
+		if ((dr->begrun + dr->runlength) =3D=3D dr->data_sn) {
+			dr->dr_complete =3D
+			    (dr->recovery =3D=3D DATAIN_WITHIN_COMMAND_RECOVERY) ?
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY :
+				DATAIN_COMPLETE_CONNECTION_RECOVERY;
+		}
+	}
+
+	return dr;
+}
+
+/*	iscsi_set_datain_values_yes_and_no():
+ *
+ *	For Normal and Recovery DataSequenceInOrder=3DYes and DataPDUInOrde=
r=3DNo.
+ */
+static inline struct iscsi_datain_req *iscsi_set_datain_values_yes_and=
_no(
+	struct iscsi_cmd *cmd,
+	struct iscsi_datain *datain)
+{
+	u32 next_burst_len, read_data_done, read_data_left;
+	struct iscsi_conn *conn =3D CONN(cmd);
+	struct iscsi_datain_req *dr;
+	struct iscsi_pdu *pdu;
+
+	dr =3D iscsi_get_datain_req(cmd);
+	if (!(dr))
+		return NULL;
+
+	if (dr->recovery && dr->generate_recovery_values) {
+		if (iscsi_create_recovery_datain_values_datasequenceinorder_yes(
+					cmd, dr) < 0)
+			return NULL;
+
+		dr->generate_recovery_values =3D 0;
+	}
+
+	next_burst_len =3D (!dr->recovery) ?
+			cmd->next_burst_len : dr->next_burst_len;
+	read_data_done =3D (!dr->recovery) ?
+			cmd->read_data_done : dr->read_data_done;
+
+	read_data_left =3D (cmd->data_length - read_data_done);
+	if (!(read_data_left)) {
+		printk(KERN_ERR "ITT: 0x%08x read_data_left is zero!\n",
+				cmd->init_task_tag);
+		return dr;
+	}
+
+	pdu =3D iscsi_get_pdu_holder_for_seq(cmd, NULL);
+	if (!(pdu))
+		return dr;
+
+	if ((read_data_done + pdu->length) =3D=3D cmd->data_length) {
+		pdu->flags |=3D (ISCSI_FLAG_CMD_FINAL | ISCSI_FLAG_DATA_STATUS);
+		if (SESS_OPS_C(conn)->ErrorRecoveryLevel > 0)
+			pdu->flags |=3D ISCSI_FLAG_DATA_ACK;
+
+		next_burst_len =3D 0;
+	} else {
+		if ((next_burst_len + CONN_OPS(conn)->MaxRecvDataSegmentLength) <
+		     SESS_OPS_C(conn)->MaxBurstLength)
+			next_burst_len +=3D pdu->length;
+		else {
+			pdu->flags |=3D ISCSI_FLAG_CMD_FINAL;
+			if (SESS_OPS_C(conn)->ErrorRecoveryLevel > 0)
+				pdu->flags |=3D ISCSI_FLAG_DATA_ACK;
+
+			next_burst_len =3D 0;
+		}
+	}
+
+	pdu->data_sn =3D (!dr->recovery) ? cmd->data_sn++ : dr->data_sn++;
+	if (!dr->recovery) {
+		cmd->next_burst_len =3D next_burst_len;
+		cmd->read_data_done +=3D pdu->length;
+	} else {
+		dr->next_burst_len =3D next_burst_len;
+		dr->read_data_done +=3D pdu->length;
+	}
+
+	datain->flags =3D pdu->flags;
+	datain->length =3D pdu->length;
+	datain->offset =3D pdu->offset;
+	datain->data_sn =3D pdu->data_sn;
+
+	if (!dr->recovery) {
+		if (datain->flags & ISCSI_FLAG_DATA_STATUS)
+			dr->dr_complete =3D DATAIN_COMPLETE_NORMAL;
+
+		return dr;
+	}
+
+	if (!dr->runlength) {
+		if (datain->flags & ISCSI_FLAG_DATA_STATUS) {
+			dr->dr_complete =3D
+			    (dr->recovery =3D=3D DATAIN_WITHIN_COMMAND_RECOVERY) ?
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY :
+				DATAIN_COMPLETE_CONNECTION_RECOVERY;
+		}
+	} else {
+		if ((dr->begrun + dr->runlength) =3D=3D dr->data_sn) {
+			dr->dr_complete =3D
+			    (dr->recovery =3D=3D DATAIN_WITHIN_COMMAND_RECOVERY) ?
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY :
+				DATAIN_COMPLETE_CONNECTION_RECOVERY;
+		}
+	}
+
+	return dr;
+}
+
+/*	iscsi_set_datain_values_no_and_no():
+ *
+ *	For Normal and Recovery DataSequenceInOrder=3DNo and DataPDUInOrder=
=3DNo.
+ */
+static inline struct iscsi_datain_req *iscsi_set_datain_values_no_and_=
no(
+	struct iscsi_cmd *cmd,
+	struct iscsi_datain *datain)
+{
+	u32 read_data_done, read_data_left, seq_send_order;
+	struct iscsi_conn *conn =3D CONN(cmd);
+	struct iscsi_datain_req *dr;
+	struct iscsi_pdu *pdu;
+	struct iscsi_seq *seq =3D NULL;
+
+	dr =3D iscsi_get_datain_req(cmd);
+	if (!(dr))
+		return NULL;
+
+	if (dr->recovery && dr->generate_recovery_values) {
+		if (iscsi_create_recovery_datain_values_datasequenceinorder_no(
+					cmd, dr) < 0)
+			return NULL;
+
+		dr->generate_recovery_values =3D 0;
+	}
+
+	read_data_done =3D (!dr->recovery) ?
+			cmd->read_data_done : dr->read_data_done;
+	seq_send_order =3D (!dr->recovery) ?
+			cmd->seq_send_order : dr->seq_send_order;
+
+	read_data_left =3D (cmd->data_length - read_data_done);
+	if (!(read_data_left)) {
+		printk(KERN_ERR "ITT: 0x%08x read_data_left is zero!\n",
+				cmd->init_task_tag);
+		return NULL;
+	}
+
+	seq =3D iscsi_get_seq_holder_for_datain(cmd, seq_send_order);
+	if (!(seq))
+		return NULL;
+
+	seq->sent =3D 1;
+
+	if (!dr->recovery && !seq->next_burst_len)
+		seq->first_datasn =3D cmd->data_sn;
+
+	pdu =3D iscsi_get_pdu_holder_for_seq(cmd, seq);
+	if (!(pdu))
+		return NULL;
+
+	if (seq->pdu_send_order =3D=3D seq->pdu_count) {
+		pdu->flags |=3D ISCSI_FLAG_CMD_FINAL;
+		if (SESS_OPS_C(conn)->ErrorRecoveryLevel > 0)
+			pdu->flags |=3D ISCSI_FLAG_DATA_ACK;
+
+		seq->next_burst_len =3D 0;
+		seq_send_order++;
+	} else
+		seq->next_burst_len +=3D pdu->length;
+
+	if ((read_data_done + pdu->length) =3D=3D cmd->data_length)
+		pdu->flags |=3D ISCSI_FLAG_DATA_STATUS;
+
+	pdu->data_sn =3D (!dr->recovery) ? cmd->data_sn++ : dr->data_sn++;
+	if (!dr->recovery) {
+		cmd->seq_send_order =3D seq_send_order;
+		cmd->read_data_done +=3D pdu->length;
+	} else {
+		dr->seq_send_order =3D seq_send_order;
+		dr->read_data_done +=3D pdu->length;
+	}
+
+	datain->flags =3D pdu->flags;
+	datain->length =3D pdu->length;
+	datain->offset =3D pdu->offset;
+	datain->data_sn =3D pdu->data_sn;
+
+	if (!dr->recovery) {
+		if (datain->flags & ISCSI_FLAG_CMD_FINAL)
+			seq->last_datasn =3D datain->data_sn;
+		if (datain->flags & ISCSI_FLAG_DATA_STATUS)
+			dr->dr_complete =3D DATAIN_COMPLETE_NORMAL;
+
+		return dr;
+	}
+
+	if (!dr->runlength) {
+		if (datain->flags & ISCSI_FLAG_DATA_STATUS) {
+			dr->dr_complete =3D
+			    (dr->recovery =3D=3D DATAIN_WITHIN_COMMAND_RECOVERY) ?
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY :
+				DATAIN_COMPLETE_CONNECTION_RECOVERY;
+		}
+	} else {
+		if ((dr->begrun + dr->runlength) =3D=3D dr->data_sn) {
+			dr->dr_complete =3D
+			    (dr->recovery =3D=3D DATAIN_WITHIN_COMMAND_RECOVERY) ?
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY :
+				DATAIN_COMPLETE_CONNECTION_RECOVERY;
+		}
+	}
+
+	return dr;
+}
+
+/*	iscsi_get_datain_values():
+ *
+ *
+ */
+struct iscsi_datain_req *iscsi_get_datain_values(
+	struct iscsi_cmd *cmd,
+	struct iscsi_datain *datain)
+{
+	struct iscsi_conn *conn =3D CONN(cmd);
+
+	if (SESS_OPS_C(conn)->DataSequenceInOrder &&
+	    SESS_OPS_C(conn)->DataPDUInOrder)
+		return iscsi_set_datain_values_yes_and_yes(cmd, datain);
+	else if (!SESS_OPS_C(conn)->DataSequenceInOrder &&
+		  SESS_OPS_C(conn)->DataPDUInOrder)
+		return iscsi_set_datain_values_no_and_yes(cmd, datain);
+	else if (SESS_OPS_C(conn)->DataSequenceInOrder &&
+		 !SESS_OPS_C(conn)->DataPDUInOrder)
+		return iscsi_set_datain_values_yes_and_no(cmd, datain);
+	else if (!SESS_OPS_C(conn)->DataSequenceInOrder &&
+		   !SESS_OPS_C(conn)->DataPDUInOrder)
+		return iscsi_set_datain_values_no_and_no(cmd, datain);
+
+	return NULL;
+}
diff --git a/drivers/target/iscsi/iscsi_target_datain_values.h b/driver=
s/target/iscsi/iscsi_target_datain_values.h
new file mode 100644
index 0000000..6d44288
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_datain_values.h
@@ -0,0 +1,15 @@
+#ifndef ISCSI_TARGET_DATAIN_VALUES_H
+#define ISCSI_TARGET_DATAIN_VALUES_H
+
+extern struct iscsi_datain_req *iscsi_allocate_datain_req(void);
+extern void iscsi_attach_datain_req(struct iscsi_cmd *, struct iscsi_d=
atain_req *);
+extern void iscsi_free_datain_req(struct iscsi_cmd *, struct iscsi_dat=
ain_req *);
+extern void iscsi_free_all_datain_reqs(struct iscsi_cmd *);
+extern struct iscsi_datain_req *iscsi_get_datain_req(struct iscsi_cmd =
*);
+extern struct iscsi_datain_req *iscsi_get_datain_values(struct iscsi_c=
md *,
+			struct iscsi_datain *);
+
+extern struct iscsi_global *iscsi_global;
+extern struct kmem_cache *lio_dr_cache;
+
+#endif   /*** ISCSI_TARGET_DATAIN_VALUES_H ***/
--=20
1.7.4.1
