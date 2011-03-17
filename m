From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v3 11/12] iscsi-target: Add misc utility and debug logic
Date: Thu, 17 Mar 2011 14:53:16 -0700
Message-ID: <1300398797-24536-12-git-send-email-nab@linux-iscsi.org>
References: <1300398797-24536-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300398797-24536-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

=46rom: Nicholas Bellinger <nab@linux-iscsi.org>

This file adds iscsi_target_util.[c,h] code containing a number
of miscellaneous utility functions for iscsi_target_mod including
the following:

*) wrappers to TCM logic from iscsi_target.c for struct iscsi_cmd
allocation
*) received iSCSI Command Sequence Number (CmdSN) processing
*) Code for immediate / TX queues
*) Nopin Response + Response Timeout handlers
*) Primary sock_sendmsg() and sock_recvmsg() calls into Linux/Net
*) iSCSI SendTargets

It also contains iscsi_debug.h macros for CONFIG_ISCSI_TARGET_DEBUG

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_debug.h |  113 ++
 drivers/target/iscsi/iscsi_target_util.c  | 2611 +++++++++++++++++++++=
++++++++
 drivers/target/iscsi/iscsi_target_util.h  |  127 ++
 3 files changed, 2851 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/iscsi/iscsi_target_debug.h
 create mode 100644 drivers/target/iscsi/iscsi_target_util.c
 create mode 100644 drivers/target/iscsi/iscsi_target_util.h

diff --git a/drivers/target/iscsi/iscsi_target_debug.h b/drivers/target=
/iscsi/iscsi_target_debug.h
new file mode 100644
index 0000000..1356146
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_debug.h
@@ -0,0 +1,113 @@
+#ifndef ISCSI_DEBUG_H
+#define ISCSI_DEBUG_H
+
+/*
+ * Debugging Support
+ */
+
+#define TRACE_DEBUG	0x00000001	/* Verbose debugging */
+#define TRACE_SCSI	0x00000002	/* Stuff related to SCSI Mid-layer */
+#define TRACE_ISCSI	0x00000004	/* Stuff related to iSCSI */
+#define TRACE_NET	0x00000008	/* Stuff related to network code */
+#define TRACE_BUFF	0x00000010	/* For dumping raw data */
+#define TRACE_FILE	0x00000020	/* Used for __FILE__ */
+#define TRACE_LINE	0x00000040	/* Used for __LINE__ */
+#define TRACE_FUNCTION	0x00000080	/* Used for __FUNCTION__ */
+#define TRACE_SEM	0x00000100	/* Stuff related to semaphores */
+#define TRACE_ENTER_LEAVE 0x00000200	/* For entering/leaving functions=
 */
+#define TRACE_DIGEST	0x00000400	/* For Header/Data Digests */
+#define TRACE_PARAM	0x00000800	/* For parameters in parameters.c */
+#define TRACE_LOGIN	0x00001000	/* For login related code */
+#define TRACE_STATE	0x00002000	/* For conn/sess/cleanup states */
+#define TRACE_ERL0	0x00004000	/* For ErrorRecoveryLevel=3D0 */
+#define TRACE_ERL1	0x00008000	/* For ErrorRecoveryLevel=3D1 */
+#define TRACE_ERL2	0x00010000	/* For ErrorRecoveryLevel=3D2 */
+#define TRACE_TIMER	0x00020000	/* For various ERL timers */
+#define TRACE_R2T	0x00040000	/* For R2T callers */
+#define TRACE_SPINDLE	0x00080000	/* For Spindle callers */
+#define TRACE_SSLR	0x00100000	/* For SyncNSteering RX */
+#define TRACE_SSLT	0x00200000	/* For SyncNSteering TX */
+#define TRACE_CHANNEL	0x00400000	/* For SCSI Channels */
+#define TRACE_CMDSN	0x00800000	/* For Out of Order CmdSN execution */
+#define TRACE_NODEATTRIB 0x01000000	/* For Initiator Nodes */
+
+#define TRACE_VANITY		0x80000000	/* For all Vanity Noise */
+#define TRACE_ALL		0xffffffff	/* Turn on all flags */
+#define TRACE_ENDING		0x00000000	/* foo */
+
+#ifdef CONFIG_ISCSI_TARGET_DEBUG
+/*
+ * TRACE_VANITY, is always last!
+ */
+static unsigned int iscsi_trace =3D
+/*		TRACE_DEBUG | */
+/*		TRACE_SCSI | */
+/*		TRACE_ISCSI | */
+/*		TRACE_NET | */
+/*		TRACE_BUFF | */
+/*		TRACE_FILE | */
+/*		TRACE_LINE | */
+/*		TRACE_FUNCTION | */
+/*		TRACE_SEM | */
+
+/*		TRACE_DIGEST | */
+/*		TRACE_PARAM | */
+/*		TRACE_LOGIN | */
+/*		TRACE_STATE | */
+		TRACE_ERL0 |
+		TRACE_ERL1 |
+		TRACE_ERL2 |
+/*		TRACE_TIMER | */
+/*		TRACE_R2T | */
+/*		TRACE_SPINDLE | */
+/*		TRACE_SSLR | */
+/*		TRACE_SSLT | */
+/*		TRACE_CHANNEL | */
+/*		TRACE_CMDSN | */
+/*		TRACE_NODEATTRIB | */
+		TRACE_VANITY |
+		TRACE_ENDING;
+
+#define TRACE(trace, args...)					\
+{								\
+static char iscsi_trace_buff[256];				\
+								\
+if (iscsi_trace & trace) {					\
+	sprintf(iscsi_trace_buff, args);			\
+	if (iscsi_trace & TRACE_FUNCTION) {			\
+		printk(KERN_INFO "%s:%d: %s",  __func__, __LINE__, \
+			iscsi_trace_buff);			\
+	} else if (iscsi_trace&TRACE_FILE) {			\
+		printk(KERN_INFO "%s::%d: %s", __FILE__, __LINE__, \
+			iscsi_trace_buff);			\
+	} else if (iscsi_trace & TRACE_LINE) {			\
+		printk(KERN_INFO "%d: %s", __LINE__, iscsi_trace_buff);	\
+	} else {						\
+		printk(KERN_INFO "%s", iscsi_trace_buff);	\
+	}							\
+}								\
+}
+
+#define PRINT_BUFF(buff, len)					\
+if (iscsi_trace & TRACE_BUFF) {					\
+	int zzz;						\
+								\
+	printk(KERN_INFO "%d:\n", __LINE__);			\
+	for (zzz =3D 0; zzz < len; zzz++) {			\
+		if (zzz % 16 =3D=3D 0) {				\
+			if (zzz)				\
+				printk(KERN_INFO "\n");		\
+			printk(KERN_INFO "%4i: ", zzz);		\
+		}						\
+		printk(KERN_INFO "%02x ", (unsigned char) (buff)[zzz]);	\
+	}							\
+	if ((len + 1) % 16)					\
+		printk(KERN_INFO "\n");				\
+}
+
+#else /* !CONFIG_ISCSI_TARGET_DEBUG */
+#define TRACE(trace, args...)
+#define PRINT_BUFF(buff, len)
+#endif /* CONFIG_ISCSI_TARGET_DEBUG */
+
+#endif   /*** ISCSI_DEBUG_H ***/
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/=
iscsi/iscsi_target_util.c
new file mode 100644
index 0000000..15b8233
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -0,0 +1,2611 @@
+/*********************************************************************=
**********
+ * This file contains the iSCSI Target specific utility functions.
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
+#include <scsi/libsas.h> /* For TASK_ATTR_* */
+#include <scsi/iscsi_proto.h>
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+#include <target/target_core_tmr.h>
+#include <target/target_core_fabric_ops.h>
+#include <target/target_core_configfs.h>
+
+#include "iscsi_target_debug.h"
+#include "iscsi_target_core.h"
+#include "iscsi_target_parameters.h"
+#include "iscsi_target_seq_pdu_list.h"
+#include "iscsi_target_datain_values.h"
+#include "iscsi_target_erl0.h"
+#include "iscsi_target_erl1.h"
+#include "iscsi_target_erl2.h"
+#include "iscsi_target_tpg.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target.h"
+
+extern struct list_head g_tiqn_list;
+extern spinlock_t tiqn_lock;
+
+inline void iscsi_attach_cmd_to_queue(struct iscsi_conn *conn, struct =
iscsi_cmd *cmd)
+{
+	spin_lock_bh(&conn->cmd_lock);
+	list_add_tail(&cmd->i_list, &conn->conn_cmd_list);
+	spin_unlock_bh(&conn->cmd_lock);
+}
+
+/*
+ *	MUST be called with conn->cmd_lock held.
+ */
+inline void iscsi_remove_cmd_from_conn_list(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	list_del(&cmd->i_list);
+}
+
+inline void iscsi_ack_from_expstatsn(struct iscsi_conn *conn, u32 exp_=
statsn)
+{
+	struct iscsi_cmd *cmd;
+
+	conn->exp_statsn =3D exp_statsn;
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry(cmd, &conn->conn_cmd_list, i_list) {
+
+		spin_lock(&cmd->istate_lock);
+		if ((cmd->i_state =3D=3D ISTATE_SENT_STATUS) &&
+		    (cmd->stat_sn < exp_statsn)) {
+			cmd->i_state =3D ISTATE_REMOVE;
+			spin_unlock(&cmd->istate_lock);
+			iscsi_add_cmd_to_immediate_queue(cmd, conn,
+					cmd->i_state);
+			continue;
+		}
+		spin_unlock(&cmd->istate_lock);
+	}
+	spin_unlock_bh(&conn->cmd_lock);
+}
+
+/*
+ *	Called with sess->conn_lock held.
+ */
+void iscsi_remove_conn_from_list(struct iscsi_session *sess, struct is=
csi_conn *conn)
+{
+	list_del(&conn->conn_list);
+}
+
+/*
+ *	Called with cmd->r2t_lock held.
+ */
+int iscsi_add_r2t_to_list(
+	struct iscsi_cmd *cmd,
+	u32 offset,
+	u32 xfer_len,
+	int recovery,
+	u32 r2t_sn)
+{
+	struct iscsi_r2t *r2t;
+
+	r2t =3D kmem_cache_zalloc(lio_r2t_cache, GFP_ATOMIC);
+	if (!r2t) {
+		printk(KERN_ERR "Unable to allocate memory for struct iscsi_r2t.\n")=
;
+		return -1;
+	}
+	INIT_LIST_HEAD(&r2t->r2t_list);
+
+	r2t->recovery_r2t =3D recovery;
+	r2t->r2t_sn =3D (!r2t_sn) ? cmd->r2t_sn++ : r2t_sn;
+	r2t->offset =3D offset;
+	r2t->xfer_len =3D xfer_len;
+	list_add_tail(&r2t->r2t_list, &cmd->cmd_r2t_list);
+	spin_unlock_bh(&cmd->r2t_lock);
+
+	iscsi_add_cmd_to_immediate_queue(cmd, cmd->conn, ISTATE_SEND_R2T);
+
+	spin_lock_bh(&cmd->r2t_lock);
+	return 0;
+}
+
+struct iscsi_r2t *iscsi_get_r2t_for_eos(
+	struct iscsi_cmd *cmd,
+	u32 offset,
+	u32 length)
+{
+	struct iscsi_r2t *r2t;
+
+	spin_lock_bh(&cmd->r2t_lock);
+	list_for_each_entry(r2t, &cmd->cmd_r2t_list, r2t_list) {
+		if ((r2t->offset <=3D offset) &&
+		    (r2t->offset + r2t->xfer_len) >=3D (offset + length))
+			break;
+	}
+	spin_unlock_bh(&cmd->r2t_lock);
+
+	if (!r2t) {
+		printk(KERN_ERR "Unable to locate R2T for Offset: %u, Length:"
+				" %u\n", offset, length);
+		return NULL;
+	}
+
+	return r2t;
+}
+
+struct iscsi_r2t *iscsi_get_r2t_from_list(struct iscsi_cmd *cmd)
+{
+	struct iscsi_r2t *r2t;
+
+	spin_lock_bh(&cmd->r2t_lock);
+	list_for_each_entry(r2t, &cmd->cmd_r2t_list, r2t_list) {
+		if (!r2t->sent_r2t)
+			break;
+	}
+	spin_unlock_bh(&cmd->r2t_lock);
+
+	if (!r2t) {
+		printk(KERN_ERR "Unable to locate next R2T to send for ITT:"
+			" 0x%08x.\n", cmd->init_task_tag);
+		return NULL;
+	}
+
+	return r2t;
+}
+
+/*
+ *	Called with cmd->r2t_lock held.
+ */
+void iscsi_free_r2t(struct iscsi_r2t *r2t, struct iscsi_cmd *cmd)
+{
+	list_del(&r2t->r2t_list);
+	kmem_cache_free(lio_r2t_cache, r2t);
+}
+
+void iscsi_free_r2ts_from_list(struct iscsi_cmd *cmd)
+{
+	struct iscsi_r2t *r2t, *r2t_tmp;
+
+	spin_lock_bh(&cmd->r2t_lock);
+	list_for_each_entry_safe(r2t, r2t_tmp, &cmd->cmd_r2t_list, r2t_list) =
{
+		list_del(&r2t->r2t_list);
+		kmem_cache_free(lio_r2t_cache, r2t);
+	}
+	spin_unlock_bh(&cmd->r2t_lock);
+}
+
+/*	iscsi_allocate_cmd():
+ *
+ *	May be called from interrupt context.
+ */
+struct iscsi_cmd *iscsi_allocate_cmd(struct iscsi_conn *conn)
+{
+	struct iscsi_cmd *cmd;
+
+	cmd =3D kmem_cache_zalloc(lio_cmd_cache, GFP_ATOMIC);
+	if (!cmd) {
+		printk(KERN_ERR "Unable to allocate memory for struct iscsi_cmd.\n")=
;
+		return NULL;
+	}
+
+	cmd->conn	=3D conn;
+	INIT_LIST_HEAD(&cmd->i_list);
+	INIT_LIST_HEAD(&cmd->datain_list);
+	INIT_LIST_HEAD(&cmd->cmd_r2t_list);
+	init_completion(&cmd->reject_comp);
+	init_completion(&cmd->unsolicited_data_comp);
+	spin_lock_init(&cmd->datain_lock);
+	spin_lock_init(&cmd->dataout_timeout_lock);
+	spin_lock_init(&cmd->istate_lock);
+	spin_lock_init(&cmd->error_lock);
+	spin_lock_init(&cmd->r2t_lock);
+
+	return cmd;
+}
+
+/*
+ * Called from iscsi_handle_scsi_cmd()
+ */
+struct iscsi_cmd *iscsi_allocate_se_cmd(
+	struct iscsi_conn *conn,
+	u32 data_length,
+	int data_direction,
+	int iscsi_task_attr)
+{
+	struct iscsi_cmd *cmd;
+	struct se_cmd *se_cmd;
+	int sam_task_attr;
+
+	cmd =3D iscsi_allocate_cmd(conn);
+	if (!cmd)
+		return NULL;
+
+	cmd->data_direction =3D data_direction;
+	cmd->data_length =3D data_length;
+	/*
+	 * Figure out the SAM Task Attribute for the incoming SCSI CDB
+	 */
+	if ((iscsi_task_attr =3D=3D ISCSI_ATTR_UNTAGGED) ||
+	    (iscsi_task_attr =3D=3D ISCSI_ATTR_SIMPLE))
+		sam_task_attr =3D TASK_ATTR_SIMPLE;
+	else if (iscsi_task_attr =3D=3D ISCSI_ATTR_ORDERED)
+		sam_task_attr =3D TASK_ATTR_ORDERED;
+	else if (iscsi_task_attr =3D=3D ISCSI_ATTR_HEAD_OF_QUEUE)
+		sam_task_attr =3D TASK_ATTR_HOQ;
+	else if (iscsi_task_attr =3D=3D ISCSI_ATTR_ACA)
+		sam_task_attr =3D TASK_ATTR_ACA;
+	else {
+		printk(KERN_INFO "Unknown iSCSI Task Attribute: 0x%02x, using"
+			" TASK_ATTR_SIMPLE\n", iscsi_task_attr);
+		sam_task_attr =3D TASK_ATTR_SIMPLE;
+	}
+
+	se_cmd =3D &cmd->se_cmd;
+	/*
+	 * Initialize struct se_cmd descriptor from target_core_mod infrastru=
cture
+	 */
+	transport_init_se_cmd(se_cmd, &lio_target_fabric_configfs->tf_ops,
+			conn->sess->se_sess, data_length, data_direction,
+			sam_task_attr, &cmd->sense_buffer[0]);
+	return cmd;
+}
+
+struct iscsi_cmd *iscsi_allocate_se_cmd_for_tmr(
+	struct iscsi_conn *conn,
+	u8 function)
+{
+	struct iscsi_cmd *cmd;
+	struct se_cmd *se_cmd;
+	u8 tcm_function;
+
+	cmd =3D iscsi_allocate_cmd(conn);
+	if (!cmd)
+		return NULL;
+
+	cmd->data_direction =3D DMA_NONE;
+
+	cmd->tmr_req =3D kzalloc(sizeof(struct iscsi_tmr_req), GFP_KERNEL);
+	if (!cmd->tmr_req) {
+		printk(KERN_ERR "Unable to allocate memory for"
+			" Task Management command!\n");
+		return NULL;
+	}
+	/*
+	 * TASK_REASSIGN for ERL=3D2 / connection stays inside of
+	 * LIO-Target $FABRIC_MOD
+	 */
+	if (function =3D=3D ISCSI_TM_FUNC_TASK_REASSIGN)
+		return cmd;
+
+	se_cmd =3D &cmd->se_cmd;
+	/*
+	 * Initialize struct se_cmd descriptor from target_core_mod infrastru=
cture
+	 */
+	transport_init_se_cmd(se_cmd, &lio_target_fabric_configfs->tf_ops,
+				conn->sess->se_sess, 0, DMA_NONE,
+				TASK_ATTR_SIMPLE, &cmd->sense_buffer[0]);
+
+	switch (function) {
+	case ISCSI_TM_FUNC_ABORT_TASK:
+		tcm_function =3D TMR_ABORT_TASK;
+		break;
+	case ISCSI_TM_FUNC_ABORT_TASK_SET:
+		tcm_function =3D TMR_ABORT_TASK_SET;
+		break;
+	case ISCSI_TM_FUNC_CLEAR_ACA:
+		tcm_function =3D TMR_CLEAR_ACA;
+		break;
+	case ISCSI_TM_FUNC_CLEAR_TASK_SET:
+		tcm_function =3D TMR_CLEAR_TASK_SET;
+		break;
+	case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
+		tcm_function =3D TMR_LUN_RESET;
+		break;
+	case ISCSI_TM_FUNC_TARGET_WARM_RESET:
+		tcm_function =3D TMR_TARGET_WARM_RESET;
+		break;
+	case ISCSI_TM_FUNC_TARGET_COLD_RESET:
+		tcm_function =3D TMR_TARGET_COLD_RESET;
+		break;
+	default:
+		printk(KERN_ERR "Unknown iSCSI TMR Function:"
+			" 0x%02x\n", function);
+		goto out;
+	}
+
+	se_cmd->se_tmr_req =3D core_tmr_alloc_req(se_cmd,
+				(void *)cmd->tmr_req, tcm_function);
+	if (!se_cmd->se_tmr_req)
+		goto out;
+
+	cmd->tmr_req->se_tmr_req =3D se_cmd->se_tmr_req;
+
+	return cmd;
+out:
+	iscsi_release_cmd_to_pool(cmd);
+	if (se_cmd)
+		transport_free_se_cmd(se_cmd);
+	return NULL;
+}
+
+int iscsi_decide_list_to_build(
+	struct iscsi_cmd *cmd,
+	u32 immediate_data_length)
+{
+	struct iscsi_build_list bl;
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_session *sess =3D conn->sess;
+	struct iscsi_node_attrib *na;
+
+	if (sess->sess_ops->DataSequenceInOrder &&
+	    sess->sess_ops->DataPDUInOrder)
+		return 0;
+
+	if (cmd->data_direction =3D=3D DMA_NONE)
+		return 0;
+
+	na =3D iscsi_tpg_get_node_attrib(sess);
+	memset(&bl, 0, sizeof(struct iscsi_build_list));
+
+	if (cmd->data_direction =3D=3D DMA_FROM_DEVICE) {
+		bl.data_direction =3D ISCSI_PDU_READ;
+		bl.type =3D PDULIST_NORMAL;
+		if (na->random_datain_pdu_offsets)
+			bl.randomize |=3D RANDOM_DATAIN_PDU_OFFSETS;
+		if (na->random_datain_seq_offsets)
+			bl.randomize |=3D RANDOM_DATAIN_SEQ_OFFSETS;
+	} else {
+		bl.data_direction =3D ISCSI_PDU_WRITE;
+		bl.immediate_data_length =3D immediate_data_length;
+		if (na->random_r2t_offsets)
+			bl.randomize |=3D RANDOM_R2T_OFFSETS;
+
+		if (!cmd->immediate_data && !cmd->unsolicited_data)
+			bl.type =3D PDULIST_NORMAL;
+		else if (cmd->immediate_data && !cmd->unsolicited_data)
+			bl.type =3D PDULIST_IMMEDIATE;
+		else if (!cmd->immediate_data && cmd->unsolicited_data)
+			bl.type =3D PDULIST_UNSOLICITED;
+		else if (cmd->immediate_data && cmd->unsolicited_data)
+			bl.type =3D PDULIST_IMMEDIATE_AND_UNSOLICITED;
+	}
+
+	return iscsi_do_build_list(cmd, &bl);
+}
+
+struct iscsi_seq *iscsi_get_seq_holder_for_datain(
+	struct iscsi_cmd *cmd,
+	u32 seq_send_order)
+{
+	u32 i;
+
+	for (i =3D 0; i < cmd->seq_count; i++)
+		if (cmd->seq_list[i].seq_send_order =3D=3D seq_send_order)
+			return &cmd->seq_list[i];
+
+	return NULL;
+}
+
+struct iscsi_seq *iscsi_get_seq_holder_for_r2t(struct iscsi_cmd *cmd)
+{
+	u32 i;
+
+	if (!cmd->seq_list) {
+		printk(KERN_ERR "struct iscsi_cmd->seq_list is NULL!\n");
+		return NULL;
+	}
+
+	for (i =3D 0; i < cmd->seq_count; i++) {
+		if (cmd->seq_list[i].type !=3D SEQTYPE_NORMAL)
+			continue;
+		if (cmd->seq_list[i].seq_send_order =3D=3D cmd->seq_send_order) {
+			cmd->seq_send_order++;
+			return &cmd->seq_list[i];
+		}
+	}
+
+	return NULL;
+}
+
+struct iscsi_r2t *iscsi_get_holder_for_r2tsn(
+	struct iscsi_cmd *cmd,
+	u32 r2t_sn)
+{
+	struct iscsi_r2t *r2t;
+
+	spin_lock_bh(&cmd->r2t_lock);
+	list_for_each_entry(r2t, &cmd->cmd_r2t_list, r2t_list) {
+		if (r2t->r2t_sn =3D=3D r2t_sn)
+			break;
+	}
+	spin_unlock_bh(&cmd->r2t_lock);
+
+	return (r2t) ? r2t : NULL;
+}
+
+#define SERIAL_BITS	31
+#define MAX_BOUND	(u32)2147483647UL
+
+int serial_lt(u32 x, u32 y)
+{
+	return (x !=3D y) && (((x < y) && ((y - x) < MAX_BOUND)) ||
+		((x > y) && ((x - y) > MAX_BOUND)));
+}
+
+int serial_lte(u32 x, u32 y)
+{
+	return (x =3D=3D y) ? 1 : serial_lt(x, y);
+}
+
+int serial_gt(u32 x, u32 y)
+{
+	return (x !=3D y) && (((x < y) && ((y - x) > MAX_BOUND)) ||
+		((x > y) && ((x - y) < MAX_BOUND)));
+}
+
+int serial_gte(u32 x, u32 y)
+{
+	return (x =3D=3D y) ? 1 : serial_gt(x, y);
+}
+
+inline int iscsi_check_received_cmdsn(
+	struct iscsi_conn *conn,
+	struct iscsi_cmd *cmd,
+	u32 cmdsn)
+{
+	int ret;
+	/*
+	 * This is the proper method of checking received CmdSN against
+	 * ExpCmdSN and MaxCmdSN values, as well as accounting for out
+	 * or order CmdSNs due to multiple connection sessions and/or
+	 * CRC failures.
+	 */
+	spin_lock(&conn->sess->cmdsn_lock);
+	if (serial_gt(cmdsn, conn->sess->max_cmd_sn)) {
+		printk(KERN_ERR "Received CmdSN: 0x%08x is greater than"
+			" MaxCmdSN: 0x%08x, protocol error.\n", cmdsn,
+				conn->sess->max_cmd_sn);
+		spin_unlock(&conn->sess->cmdsn_lock);
+		return CMDSN_ERROR_CANNOT_RECOVER;
+	}
+
+	if (!conn->sess->cmdsn_outoforder) {
+		if (cmdsn =3D=3D conn->sess->exp_cmd_sn) {
+			conn->sess->exp_cmd_sn++;
+			TRACE(TRACE_CMDSN, "Received CmdSN matches ExpCmdSN,"
+				" incremented ExpCmdSN to: 0x%08x\n",
+					conn->sess->exp_cmd_sn);
+			ret =3D iscsi_execute_cmd(cmd, 0);
+			spin_unlock(&conn->sess->cmdsn_lock);
+
+			return (!ret) ? CMDSN_NORMAL_OPERATION :
+					CMDSN_ERROR_CANNOT_RECOVER;
+		} else if (serial_gt(cmdsn, conn->sess->exp_cmd_sn)) {
+			TRACE(TRACE_CMDSN, "Received CmdSN: 0x%08x is greater"
+				" than ExpCmdSN: 0x%08x, not acknowledging.\n",
+				cmdsn, conn->sess->exp_cmd_sn);
+			goto ooo_cmdsn;
+		} else {
+			printk(KERN_ERR "Received CmdSN: 0x%08x is less than"
+				" ExpCmdSN: 0x%08x, ignoring.\n", cmdsn,
+					conn->sess->exp_cmd_sn);
+			spin_unlock(&conn->sess->cmdsn_lock);
+			return CMDSN_LOWER_THAN_EXP;
+		}
+	} else {
+		int counter =3D 0;
+		u32 old_expcmdsn =3D 0;
+		if (cmdsn =3D=3D conn->sess->exp_cmd_sn) {
+			old_expcmdsn =3D conn->sess->exp_cmd_sn++;
+			TRACE(TRACE_CMDSN, "Got missing CmdSN: 0x%08x matches"
+				" ExpCmdSN, incremented ExpCmdSN to 0x%08x.\n",
+					cmdsn, conn->sess->exp_cmd_sn);
+
+			if (iscsi_execute_cmd(cmd, 0) < 0) {
+				spin_unlock(&conn->sess->cmdsn_lock);
+				return CMDSN_ERROR_CANNOT_RECOVER;
+			}
+		} else if (serial_gt(cmdsn, conn->sess->exp_cmd_sn)) {
+			TRACE(TRACE_CMDSN, "CmdSN: 0x%08x greater than"
+				" ExpCmdSN: 0x%08x, not acknowledging.\n",
+				cmdsn, conn->sess->exp_cmd_sn);
+			goto ooo_cmdsn;
+		} else {
+			printk(KERN_ERR "CmdSN: 0x%08x less than ExpCmdSN:"
+				" 0x%08x, ignoring.\n", cmdsn,
+				conn->sess->exp_cmd_sn);
+			spin_unlock(&conn->sess->cmdsn_lock);
+			return CMDSN_LOWER_THAN_EXP;
+		}
+
+		counter =3D iscsi_execute_ooo_cmdsns(conn->sess);
+		if (counter < 0) {
+			spin_unlock(&conn->sess->cmdsn_lock);
+			return CMDSN_ERROR_CANNOT_RECOVER;
+		}
+
+		if (counter =3D=3D conn->sess->ooo_cmdsn_count) {
+			if (conn->sess->ooo_cmdsn_count =3D=3D 1) {
+				TRACE(TRACE_CMDSN, "Received final missing"
+					" CmdSN: 0x%08x.\n", old_expcmdsn);
+			} else {
+				TRACE(TRACE_CMDSN, "Received final missing"
+					" CmdSNs: 0x%08x->0x%08x.\n",
+				old_expcmdsn, (conn->sess->exp_cmd_sn - 1));
+			}
+
+			conn->sess->ooo_cmdsn_count =3D 0;
+			conn->sess->cmdsn_outoforder =3D 0;
+		} else {
+			conn->sess->ooo_cmdsn_count -=3D counter;
+			TRACE(TRACE_CMDSN, "Still missing %hu CmdSN(s),"
+				" continuing out of order operation.\n",
+				conn->sess->ooo_cmdsn_count);
+		}
+		spin_unlock(&conn->sess->cmdsn_lock);
+		return CMDSN_NORMAL_OPERATION;
+	}
+
+ooo_cmdsn:
+	ret =3D iscsi_handle_ooo_cmdsn(conn->sess, cmd, cmdsn);
+	spin_unlock(&conn->sess->cmdsn_lock);
+	return ret;
+}
+
+int iscsi_check_unsolicited_dataout(struct iscsi_cmd *cmd, unsigned ch=
ar *buf)
+{
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct se_cmd *se_cmd =3D SE_CMD(cmd);
+	struct iscsi_data *hdr =3D (struct iscsi_data *) buf;
+	u32 payload_length =3D ntoh24(hdr->dlength);
+
+	if (conn->sess->sess_ops->InitialR2T) {
+		printk(KERN_ERR "Received unexpected unsolicited data"
+			" while InitialR2T=3DYes, protocol error.\n");
+		transport_send_check_condition_and_sense(se_cmd,
+				TCM_UNEXPECTED_UNSOLICITED_DATA, 0);
+		return -1;
+	}
+
+	if ((cmd->first_burst_len + payload_length) >
+	     conn->sess->sess_ops->FirstBurstLength) {
+		printk(KERN_ERR "Total %u bytes exceeds FirstBurstLength: %u"
+			" for this Unsolicited DataOut Burst.\n",
+			(cmd->first_burst_len + payload_length),
+				conn->sess->sess_ops->FirstBurstLength);
+		transport_send_check_condition_and_sense(se_cmd,
+				TCM_INCORRECT_AMOUNT_OF_DATA, 0);
+		return -1;
+	}
+
+	if (!(hdr->flags & ISCSI_FLAG_CMD_FINAL))
+		return 0;
+
+	if (((cmd->first_burst_len + payload_length) !=3D cmd->data_length) &=
&
+	    ((cmd->first_burst_len + payload_length) !=3D
+	      conn->sess->sess_ops->FirstBurstLength)) {
+		printk(KERN_ERR "Unsolicited non-immediate data received %u"
+			" does not equal FirstBurstLength: %u, and does"
+			" not equal ExpXferLen %u.\n",
+			(cmd->first_burst_len + payload_length),
+			conn->sess->sess_ops->FirstBurstLength, cmd->data_length);
+		transport_send_check_condition_and_sense(se_cmd,
+				TCM_INCORRECT_AMOUNT_OF_DATA, 0);
+		return -1;
+	}
+	return 0;
+}
+
+struct iscsi_cmd *iscsi_find_cmd_from_itt(
+	struct iscsi_conn *conn,
+	u32 init_task_tag)
+{
+	struct iscsi_cmd *cmd;
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry(cmd, &conn->conn_cmd_list, i_list) {
+		if (cmd->init_task_tag =3D=3D init_task_tag)
+			break;
+	}
+	spin_unlock_bh(&conn->cmd_lock);
+
+	if (!cmd) {
+		printk(KERN_ERR "Unable to locate ITT: 0x%08x on CID: %hu",
+			init_task_tag, conn->cid);
+		return NULL;
+	}
+
+	return cmd;
+}
+
+struct iscsi_cmd *iscsi_find_cmd_from_itt_or_dump(
+	struct iscsi_conn *conn,
+	u32 init_task_tag,
+	u32 length)
+{
+	struct iscsi_cmd *cmd;
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry(cmd, &conn->conn_cmd_list, i_list) {
+		if (cmd->init_task_tag =3D=3D init_task_tag)
+			break;
+	}
+	spin_unlock_bh(&conn->cmd_lock);
+
+	if (!cmd) {
+		printk(KERN_ERR "Unable to locate ITT: 0x%08x on CID: %hu,"
+			" dumping payload\n", init_task_tag, conn->cid);
+		if (length)
+			iscsi_dump_data_payload(conn, length, 1);
+		return NULL;
+	}
+
+	return cmd;
+}
+
+struct iscsi_cmd *iscsi_find_cmd_from_ttt(
+	struct iscsi_conn *conn,
+	u32 targ_xfer_tag)
+{
+	struct iscsi_cmd *cmd =3D NULL;
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry(cmd, &conn->conn_cmd_list, i_list) {
+		if (cmd->targ_xfer_tag =3D=3D targ_xfer_tag)
+			break;
+	}
+	spin_unlock_bh(&conn->cmd_lock);
+
+	if (!cmd) {
+		printk(KERN_ERR "Unable to locate TTT: 0x%08x on CID: %hu\n",
+			targ_xfer_tag, conn->cid);
+		return NULL;
+	}
+
+	return cmd;
+}
+
+int iscsi_find_cmd_for_recovery(
+	struct iscsi_session *sess,
+	struct iscsi_cmd **cmd_ptr,
+	struct iscsi_conn_recovery **cr_ptr,
+	u32 init_task_tag)
+{
+	int found_itt =3D 0;
+	struct iscsi_cmd *cmd =3D NULL;
+	struct iscsi_conn_recovery *cr;
+
+	/*
+	 * Scan through the inactive connection recovery list's command list.
+	 * If init_task_tag matches the command is still alligent.
+	 */
+	spin_lock(&sess->cr_i_lock);
+	list_for_each_entry(cr, &sess->cr_inactive_list, cr_list) {
+		spin_lock(&cr->conn_recovery_cmd_lock);
+		list_for_each_entry(cmd, &cr->conn_recovery_cmd_list, i_list) {
+			if (cmd->init_task_tag =3D=3D init_task_tag) {
+				found_itt =3D 1;
+				break;
+			}
+		}
+		spin_unlock(&cr->conn_recovery_cmd_lock);
+		if (found_itt)
+			break;
+	}
+	spin_unlock(&sess->cr_i_lock);
+
+	if (cmd) {
+		*cr_ptr =3D cr;
+		*cmd_ptr =3D cmd;
+		return -2;
+	}
+
+	found_itt =3D 0;
+
+	/*
+	 * Scan through the active connection recovery list's command list.
+	 * If init_task_tag matches the command is ready to be reassigned.
+	 */
+	spin_lock(&sess->cr_a_lock);
+	list_for_each_entry(cr, &sess->cr_active_list, cr_list) {
+		spin_lock(&cr->conn_recovery_cmd_lock);
+		list_for_each_entry(cmd, &cr->conn_recovery_cmd_list, i_list) {
+			if (cmd->init_task_tag =3D=3D init_task_tag) {
+				found_itt =3D 1;
+				break;
+			}
+		}
+		spin_unlock(&cr->conn_recovery_cmd_lock);
+		if (found_itt)
+			break;
+	}
+	spin_unlock(&sess->cr_a_lock);
+
+	if (!cmd || !cr)
+		return -1;
+
+	*cr_ptr =3D cr;
+	*cmd_ptr =3D cmd;
+
+	return 0;
+}
+
+void iscsi_add_cmd_to_immediate_queue(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn,
+	u8 state)
+{
+	struct iscsi_queue_req *qr;
+
+	qr =3D kmem_cache_zalloc(lio_qr_cache, GFP_ATOMIC);
+	if (!qr) {
+		printk(KERN_ERR "Unable to allocate memory for"
+				" struct iscsi_queue_req\n");
+		return;
+	}
+	INIT_LIST_HEAD(&qr->qr_list);
+	qr->cmd =3D cmd;
+	qr->state =3D state;
+
+	spin_lock_bh(&conn->immed_queue_lock);
+	list_add_tail(&qr->qr_list, &conn->immed_queue_list);
+	atomic_inc(&cmd->immed_queue_count);
+	atomic_set(&conn->check_immediate_queue, 1);
+	spin_unlock_bh(&conn->immed_queue_lock);
+
+	complete(&conn->tx_comp);
+}
+
+struct iscsi_queue_req *iscsi_get_cmd_from_immediate_queue(struct iscs=
i_conn *conn)
+{
+	struct iscsi_queue_req *qr;
+
+	spin_lock_bh(&conn->immed_queue_lock);
+	if (list_empty(&conn->immed_queue_list)) {
+		spin_unlock_bh(&conn->immed_queue_lock);
+		return NULL;
+	}
+	list_for_each_entry(qr, &conn->immed_queue_list, qr_list)
+		break;
+
+	list_del(&qr->qr_list);
+	if (qr->cmd)
+		atomic_dec(&qr->cmd->immed_queue_count);
+	spin_unlock_bh(&conn->immed_queue_lock);
+
+	return qr;
+}
+
+static void iscsi_remove_cmd_from_immediate_queue(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	struct iscsi_queue_req *qr, *qr_tmp;
+
+	spin_lock_bh(&conn->immed_queue_lock);
+	if (!atomic_read(&cmd->immed_queue_count)) {
+		spin_unlock_bh(&conn->immed_queue_lock);
+		return;
+	}
+
+	list_for_each_entry_safe(qr, qr_tmp, &conn->immed_queue_list, qr_list=
) {
+		if (qr->cmd !=3D cmd)
+			continue;
+
+		atomic_dec(&qr->cmd->immed_queue_count);
+		list_del(&qr->qr_list);
+		kmem_cache_free(lio_qr_cache, qr);
+	}
+	spin_unlock_bh(&conn->immed_queue_lock);
+
+	if (atomic_read(&cmd->immed_queue_count)) {
+		printk(KERN_ERR "ITT: 0x%08x immed_queue_count: %d\n",
+			cmd->init_task_tag,
+			atomic_read(&cmd->immed_queue_count));
+	}
+}
+
+void iscsi_add_cmd_to_response_queue(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn,
+	u8 state)
+{
+	struct iscsi_queue_req *qr;
+
+	qr =3D kmem_cache_zalloc(lio_qr_cache, GFP_ATOMIC);
+	if (!qr) {
+		printk(KERN_ERR "Unable to allocate memory for"
+			" struct iscsi_queue_req\n");
+		return;
+	}
+	INIT_LIST_HEAD(&qr->qr_list);
+	qr->cmd =3D cmd;
+	qr->state =3D state;
+
+	spin_lock_bh(&conn->response_queue_lock);
+	list_add_tail(&qr->qr_list, &conn->response_queue_list);
+	atomic_inc(&cmd->response_queue_count);
+	spin_unlock_bh(&conn->response_queue_lock);
+
+	complete(&conn->tx_comp);
+}
+
+struct iscsi_queue_req *iscsi_get_cmd_from_response_queue(struct iscsi=
_conn *conn)
+{
+	struct iscsi_queue_req *qr;
+
+	spin_lock_bh(&conn->response_queue_lock);
+	if (list_empty(&conn->response_queue_list)) {
+		spin_unlock_bh(&conn->response_queue_lock);
+		return NULL;
+	}
+
+	list_for_each_entry(qr, &conn->response_queue_list, qr_list)
+		break;
+
+	list_del(&qr->qr_list);
+	if (qr->cmd)
+		atomic_dec(&qr->cmd->response_queue_count);
+	spin_unlock_bh(&conn->response_queue_lock);
+
+	return qr;
+}
+
+static void iscsi_remove_cmd_from_response_queue(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	struct iscsi_queue_req *qr, *qr_tmp;
+
+	spin_lock_bh(&conn->response_queue_lock);
+	if (!(atomic_read(&cmd->response_queue_count))) {
+		spin_unlock_bh(&conn->response_queue_lock);
+		return;
+	}
+
+	list_for_each_entry_safe(qr, qr_tmp, &conn->response_queue_list,
+				qr_list) {
+		if (qr->cmd !=3D cmd)
+			continue;
+
+		atomic_dec(&qr->cmd->response_queue_count);
+		list_del(&qr->qr_list);
+		kmem_cache_free(lio_qr_cache, qr);
+	}
+	spin_unlock_bh(&conn->response_queue_lock);
+
+	if (atomic_read(&cmd->response_queue_count)) {
+		printk(KERN_ERR "ITT: 0x%08x response_queue_count: %d\n",
+			cmd->init_task_tag,
+			atomic_read(&cmd->response_queue_count));
+	}
+}
+
+void iscsi_remove_cmd_from_tx_queues(struct iscsi_cmd *cmd, struct isc=
si_conn *conn)
+{
+	iscsi_remove_cmd_from_immediate_queue(cmd, conn);
+	iscsi_remove_cmd_from_response_queue(cmd, conn);
+}
+
+void iscsi_free_queue_reqs_for_conn(struct iscsi_conn *conn)
+{
+	struct iscsi_queue_req *qr, *qr_tmp;
+
+	spin_lock_bh(&conn->immed_queue_lock);
+	list_for_each_entry_safe(qr, qr_tmp, &conn->immed_queue_list, qr_list=
) {
+		list_del(&qr->qr_list);
+		if (qr->cmd)
+			atomic_dec(&qr->cmd->immed_queue_count);
+
+		kmem_cache_free(lio_qr_cache, qr);
+	}
+	spin_unlock_bh(&conn->immed_queue_lock);
+
+	spin_lock_bh(&conn->response_queue_lock);
+	list_for_each_entry_safe(qr, qr_tmp, &conn->response_queue_list,
+			qr_list) {
+		list_del(&qr->qr_list);
+		if (qr->cmd)
+			atomic_dec(&qr->cmd->response_queue_count);
+
+		kmem_cache_free(lio_qr_cache, qr);
+	}
+	spin_unlock_bh(&conn->response_queue_lock);
+}
+
+void iscsi_release_cmd_direct(struct iscsi_cmd *cmd)
+{
+	iscsi_free_r2ts_from_list(cmd);
+	iscsi_free_all_datain_reqs(cmd);
+
+	kfree(cmd->buf_ptr);
+	kfree(cmd->pdu_list);
+	kfree(cmd->seq_list);
+	kfree(cmd->tmr_req);
+	kfree(cmd->iov_data);
+
+	kmem_cache_free(lio_cmd_cache, cmd);
+}
+
+void lio_release_cmd_direct(struct se_cmd *se_cmd)
+{
+	struct iscsi_cmd *cmd =3D container_of(se_cmd, struct iscsi_cmd, se_c=
md);
+
+	iscsi_release_cmd_direct(cmd);
+}
+
+void __iscsi_release_cmd_to_pool(struct iscsi_cmd *cmd, struct iscsi_s=
ession *sess)
+{
+	struct iscsi_conn *conn =3D cmd->conn;
+
+	iscsi_free_r2ts_from_list(cmd);
+	iscsi_free_all_datain_reqs(cmd);
+
+	kfree(cmd->buf_ptr);
+	kfree(cmd->pdu_list);
+	kfree(cmd->seq_list);
+	kfree(cmd->tmr_req);
+	kfree(cmd->iov_data);
+
+	if (conn)
+		iscsi_remove_cmd_from_tx_queues(cmd, conn);
+
+	kmem_cache_free(lio_cmd_cache, cmd);
+}
+
+void iscsi_release_cmd_to_pool(struct iscsi_cmd *cmd)
+{
+	if (!cmd->conn && !cmd->sess) {
+		iscsi_release_cmd_direct(cmd);
+	} else {
+		__iscsi_release_cmd_to_pool(cmd, (cmd->conn) ?
+			cmd->conn->sess : cmd->sess);
+	}
+}
+
+void lio_release_cmd_to_pool(struct se_cmd *se_cmd)
+{
+	struct iscsi_cmd *cmd =3D container_of(se_cmd, struct iscsi_cmd, se_c=
md);
+
+	iscsi_release_cmd_to_pool(cmd);
+}
+
+/*	iscsi_pack_lun():
+ *
+ *	Routine to pack an ordinary (LINUX) LUN 32-bit number
+ *		into an 8-byte LUN structure
+ *	(see SAM-2, Section 4.12.3 page 39)
+ *	Thanks to UNH for help with this :-).
+ */
+inline u64 iscsi_pack_lun(unsigned int lun)
+{
+	u64	result;
+
+	result =3D ((lun & 0xff) << 8);	/* LSB of lun into byte 1 big-endian =
*/
+
+	if (0) {
+		/* use flat space addressing method, SAM-2 Section 4.12.4
+			-	high-order 2 bits of byte 0 are 01
+			-	low-order 6 bits of byte 0 are MSB of the lun
+			-	all 8 bits of byte 1 are LSB of the lun
+			-	all other bytes (2 thru 7) are 0
+		 */
+		result |=3D 0x40 | ((lun >> 8) & 0x3f);
+	}
+	/* else use peripheral device addressing method, Sam-2 Section 4.12.5
+			-	high-order 2 bits of byte 0 are 00
+			-	low-order 6 bits of byte 0 are all 0
+			-	all 8 bits of byte 1 are the lun
+			-	all other bytes (2 thru 7) are 0
+	*/
+
+	return cpu_to_le64(result);
+}
+
+/*	iscsi_unpack_lun():
+ *
+ *	Routine to pack an 8-byte LUN structure into a ordinary (LINUX) 32-=
bit
+ *	LUN number (see SAM-2, Section 4.12.3 page 39)
+ *	Thanks to UNH for help with this :-).
+ */
+inline u32 iscsi_unpack_lun(unsigned char *lun_ptr)
+{
+	u32	result, temp;
+
+	result =3D *(lun_ptr+1);  /* LSB of lun from byte 1 big-endian */
+
+	switch (temp =3D ((*lun_ptr)>>6)) { /* high 2 bits of byte 0 big-endi=
an */
+	case 0: /* peripheral device addressing method, Sam-2 Section 4.12.5
+		-	high-order 2 bits of byte 0 are 00
+		-	low-order 6 bits of byte 0 are all 0
+		-	all 8 bits of byte 1 are the lun
+		-	all other bytes (2 thru 7) are 0
+		 */
+		if (*lun_ptr !=3D 0) {
+			printk(KERN_ERR "Illegal Byte 0 in LUN peripheral"
+				" device addressing method %u, expected 0\n",
+				*lun_ptr);
+		}
+		break;
+	case 1: /* flat space addressing method, SAM-2 Section 4.12.4
+		-	high-order 2 bits of byte 0 are 01
+		-	low-order 6 bits of byte 0 are MSB of the lun
+		-	all 8 bits of byte 1 are LSB of the lun
+		-	all other bytes (2 thru 7) are 0
+		 */
+		result +=3D ((*lun_ptr) & 0x3f) << 8;
+		break;
+	default: /* (extended) logical unit addressing */
+		printk(KERN_ERR "Unimplemented LUN addressing method %u, "
+			"PDA method used instead\n", temp);
+		break;
+	}
+
+	return result;
+}
+
+int iscsi_check_session_usage_count(struct iscsi_session *sess)
+{
+	spin_lock_bh(&sess->session_usage_lock);
+	if (atomic_read(&sess->session_usage_count)) {
+		atomic_set(&sess->session_waiting_on_uc, 1);
+		spin_unlock_bh(&sess->session_usage_lock);
+		if (in_interrupt())
+			return 2;
+
+		wait_for_completion(&sess->session_waiting_on_uc_comp);
+		return 1;
+	}
+	spin_unlock_bh(&sess->session_usage_lock);
+
+	return 0;
+}
+
+void iscsi_dec_session_usage_count(struct iscsi_session *sess)
+{
+	spin_lock_bh(&sess->session_usage_lock);
+	atomic_dec(&sess->session_usage_count);
+
+	if (!atomic_read(&sess->session_usage_count) &&
+	     atomic_read(&sess->session_waiting_on_uc))
+		complete(&sess->session_waiting_on_uc_comp);
+
+	spin_unlock_bh(&sess->session_usage_lock);
+}
+
+/*	iscsi_inc_session_usage_count():
+ *
+ *
+ */
+void iscsi_inc_session_usage_count(struct iscsi_session *sess)
+{
+
+	spin_lock_bh(&sess->session_usage_lock);
+	atomic_inc(&sess->session_usage_count);
+	spin_unlock_bh(&sess->session_usage_lock);
+}
+
+/*	iscsi_determine_sync_and_steering_counts():
+ *
+ *	Used before iscsi_do[rx,tx]_data() to determine iov and [rx,tx]_mar=
ker
+ *	array counts needed for sync and steering.
+ */
+static inline int iscsi_determine_sync_and_steering_counts(
+	struct iscsi_conn *conn,
+	struct iscsi_data_count *count)
+{
+	u32 length =3D count->data_length;
+	u32 marker, markint;
+
+	count->sync_and_steering =3D 1;
+
+	marker =3D (count->type =3D=3D ISCSI_RX_DATA) ?
+			conn->of_marker : conn->if_marker;
+	markint =3D (count->type =3D=3D ISCSI_RX_DATA) ?
+			(conn->conn_ops->OFMarkInt * 4) :
+			(conn->conn_ops->IFMarkInt * 4);
+	count->ss_iov_count =3D count->iov_count;
+
+	while (length > 0) {
+		if (length >=3D marker) {
+			count->ss_iov_count +=3D 3;
+			count->ss_marker_count +=3D 2;
+
+			length -=3D marker;
+			marker =3D markint;
+		} else
+			length =3D 0;
+	}
+
+	return 0;
+}
+
+/*	iscsi_set_sync_and_steering_values():
+ *
+ *	Setup conn->if_marker and conn->of_marker values based upon
+ *	the initial marker-less interval. (see iSCSI v19 A.2)
+ */
+int iscsi_set_sync_and_steering_values(struct iscsi_conn *conn)
+{
+	int login_ifmarker_count =3D 0, login_ofmarker_count =3D 0, next_mark=
er =3D 0;
+	/*
+	 * IFMarkInt and OFMarkInt are negotiated as 32-bit words.
+	 */
+	u32 IFMarkInt =3D (conn->conn_ops->IFMarkInt * 4);
+	u32 OFMarkInt =3D (conn->conn_ops->OFMarkInt * 4);
+
+	if (conn->conn_ops->OFMarker) {
+		/*
+		 * Account for the first Login Command received not
+		 * via iscsi_recv_msg().
+		 */
+		conn->of_marker +=3D ISCSI_HDR_LEN;
+		if (conn->of_marker <=3D OFMarkInt) {
+			conn->of_marker =3D (OFMarkInt - conn->of_marker);
+		} else {
+			login_ofmarker_count =3D (conn->of_marker / OFMarkInt);
+			next_marker =3D (OFMarkInt * (login_ofmarker_count + 1)) +
+					(login_ofmarker_count * MARKER_SIZE);
+			conn->of_marker =3D (next_marker - conn->of_marker);
+		}
+		conn->of_marker_offset =3D 0;
+		printk(KERN_INFO "Setting OFMarker value to %u based on Initial"
+			" Markerless Interval.\n", conn->of_marker);
+	}
+
+	if (conn->conn_ops->IFMarker) {
+		if (conn->if_marker <=3D IFMarkInt) {
+			conn->if_marker =3D (IFMarkInt - conn->if_marker);
+		} else {
+			login_ifmarker_count =3D (conn->if_marker / IFMarkInt);
+			next_marker =3D (IFMarkInt * (login_ifmarker_count + 1)) +
+					(login_ifmarker_count * MARKER_SIZE);
+			conn->if_marker =3D (next_marker - conn->if_marker);
+		}
+		printk(KERN_INFO "Setting IFMarker value to %u based on Initial"
+			" Markerless Interval.\n", conn->if_marker);
+	}
+
+	return 0;
+}
+
+unsigned char *iscsi_ntoa(u32 ip)
+{
+	static unsigned char buf[18];
+
+	memset(buf, 0, 18);
+	sprintf(buf, "%u.%u.%u.%u", ((ip >> 24) & 0xff), ((ip >> 16) & 0xff),
+			((ip >> 8) & 0xff), (ip & 0xff));
+
+	return buf;
+}
+
+void iscsi_ntoa2(unsigned char *buf, u32 ip)
+{
+	memset(buf, 0, 18);
+	sprintf(buf, "%u.%u.%u.%u", ((ip >> 24) & 0xff), ((ip >> 16) & 0xff),
+			((ip >> 8) & 0xff), (ip & 0xff));
+}
+
+#define NS_INT16SZ	 2
+#define NS_INADDRSZ	 4
+#define NS_IN6ADDRSZ	16
+
+/* const char *
+ * inet_ntop4(src, dst, size)
+ *	format an IPv4 address
+ * return:
+ *	`dst' (as a const)
+ * notes:
+ *	(1) uses no statics
+ *	(2) takes a unsigned char* not an in_addr as input
+ * author:
+ *	Paul Vixie, 1996.
+ */
+static const char *iscsi_ntop4(
+	const unsigned char *src,
+	char *dst,
+	size_t size)
+{
+	static const char *fmt =3D "%u.%u.%u.%u";
+	char tmp[sizeof "255.255.255.255"];
+	size_t len;
+
+	len =3D snprintf(tmp, sizeof tmp, fmt, src[0], src[1], src[2], src[3]=
);
+	if (len >=3D size) {
+		printk(KERN_ERR "len: %d >=3D size: %d\n", (int)len, (int)size);
+		return NULL;
+	}
+	memcpy(dst, tmp, len + 1);
+
+	return dst;
+}
+
+/* const char *
+ * isc_inet_ntop6(src, dst, size)
+ * convert IPv6 binary address into presentation (printable) format
+ * author:
+ *	Paul Vixie, 1996.
+ */
+const char *iscsi_ntop6(const unsigned char *src, char *dst, size_t si=
ze)
+{
+	/*
+	 * Note that int32_t and int16_t need only be "at least" large enough
+	 * to contain a value of the specified size.  On some systems, like
+	 * Crays, there is no such thing as an integer variable with 16 bits.
+	 * Keep this in mind if you think this function should have been code=
d
+	 * to use pointer overlays.  All the world's not a VAX.
+	 */
+	char tmp[sizeof "ffff:ffff:ffff:ffff:ffff:ffff:255.255.255.255"], *tp=
;
+	struct { int base, len; } best, cur;
+	unsigned int words[NS_IN6ADDRSZ / NS_INT16SZ];
+	int i, inc;
+
+	best.len =3D best.base =3D 0;
+	cur.len =3D cur.base =3D 0;
+
+	/*
+	 * Preprocess:
+	 *	Copy the input (bytewise) array into a wordwise array.
+	 *	Find the longest run of 0x00's in src[] for :: shorthanding.
+	 */
+	memset(words, '\0', sizeof words);
+	for (i =3D 0; i < NS_IN6ADDRSZ; i++)
+		words[i / 2] |=3D (src[i] << ((1 - (i % 2)) << 3));
+	best.base =3D -1;
+	cur.base =3D -1;
+	for (i =3D 0; i < (NS_IN6ADDRSZ / NS_INT16SZ); i++) {
+		if (words[i] =3D=3D 0) {
+			if (cur.base =3D=3D -1)
+				cur.base =3D i, cur.len =3D 1;
+			else
+				cur.len++;
+		} else {
+			if (cur.base !=3D -1) {
+				if (best.base =3D=3D -1 || cur.len > best.len)
+					best =3D cur;
+				cur.base =3D -1;
+			}
+		}
+	}
+	if (cur.base !=3D -1) {
+		if (best.base =3D=3D -1 || cur.len > best.len)
+			best =3D cur;
+	}
+	if (best.base !=3D -1 && best.len < 2)
+		best.base =3D -1;
+
+	/*
+	 * Format the result.
+	 */
+	tp =3D tmp;
+	for (i =3D 0; i < (NS_IN6ADDRSZ / NS_INT16SZ); i++) {
+		/* Are we inside the best run of 0x00's? */
+		if (best.base !=3D -1 && i >=3D best.base &&
+		    i < (best.base + best.len)) {
+			if (i =3D=3D best.base)
+				*tp++ =3D ':';
+			continue;
+		}
+		/* Are we following an initial run of 0x00s or any real hex? */
+		if (i !=3D 0)
+			*tp++ =3D ':';
+		/* Is this address an encapsulated IPv4? */
+		if (i =3D=3D 6 && best.base =3D=3D 0 &&
+		    (best.len =3D=3D 6 || (best.len =3D=3D 5 && words[5] =3D=3D 0xff=
ff))) {
+			if (!iscsi_ntop4(src+12, tp, sizeof tmp - (tp - tmp)))
+				return NULL;
+			tp +=3D strlen(tp);
+			break;
+		}
+		inc =3D snprintf(tp, 5, "%x", words[i]);
+		if (inc < 5)
+			return NULL;
+		tp +=3D inc;
+	}
+	/* Was it a trailing run of 0x00's? */
+	if (best.base !=3D -1 && (best.base + best.len) =3D=3D
+	    (NS_IN6ADDRSZ / NS_INT16SZ))
+		*tp++ =3D ':';
+	*tp++ =3D '\0';
+
+	/*
+	 * Check for overflow, copy, and we're done.
+	 */
+	if ((size_t)(tp - tmp) > size) {
+		printk(KERN_ERR "(size_t)(tp - tmp): %d > size: %d\n",
+			(int)(tp - tmp), (int)size);
+		return NULL;
+	}
+	memcpy(dst, tmp, tp - tmp);
+	return dst;
+}
+
+/* int
+ * inet_pton4(src, dst)
+ *	like inet_aton() but without all the hexadecimal and shorthand.
+ * return:
+ *	1 if `src' is a valid dotted quad, else 0.
+ * notice:
+ *	does not touch `dst' unless it's returning 1.
+ * author:
+ *	Paul Vixie, 1996.
+ */
+static int iscsi_pton4(const char *src, unsigned char *dst)
+{
+	static const char digits[] =3D "0123456789";
+	int saw_digit, octets, ch;
+	unsigned char tmp[NS_INADDRSZ], *tp;
+
+	saw_digit =3D 0;
+	octets =3D 0;
+	*(tp =3D tmp) =3D 0;
+	while ((ch =3D *src++) !=3D '\0') {
+		const char *pch;
+
+		pch =3D strchr(digits, ch);
+		if (pch !=3D NULL) {
+			unsigned int new =3D *tp * 10 + (pch - digits);
+
+			if (new > 255)
+				return 0;
+			*tp =3D new;
+			if (!saw_digit) {
+				if (++octets > 4)
+					return 0;
+				saw_digit =3D 1;
+			}
+		} else if (ch =3D=3D '.' && saw_digit) {
+			if (octets =3D=3D 4)
+				return 0;
+			*++tp =3D 0;
+			saw_digit =3D 0;
+		} else
+			return 0;
+	}
+	if (octets < 4)
+		return 0;
+	memcpy(dst, tmp, NS_INADDRSZ);
+	return 1;
+}
+
+/* int
+ * inet_pton6(src, dst)
+ *	convert presentation level address to network order binary form.
+ * return:
+ *	1 if `src' is a valid [RFC1884 2.2] address, else 0.
+ * notice:
+ *	(1) does not touch `dst' unless it's returning 1.
+ *	(2) :: in a full address is silently ignored.
+ * credit:
+ *	inspired by Mark Andrews.
+ * author:
+ *	Paul Vixie, 1996.
+ */
+int iscsi_pton6(const char *src, unsigned char *dst)
+{
+	static const char xdigits_l[] =3D "0123456789abcdef",
+			  xdigits_u[] =3D "0123456789ABCDEF";
+	unsigned char tmp[NS_IN6ADDRSZ], *tp, *endp, *colonp;
+	const char *xdigits, *curtok;
+	int ch, saw_xdigit;
+	unsigned int val;
+
+	memset((tp =3D tmp), '\0', NS_IN6ADDRSZ);
+	endp =3D tp + NS_IN6ADDRSZ;
+	colonp =3D NULL;
+	/* Leading :: requires some special handling. */
+	if (*src =3D=3D ':')
+		if (*++src !=3D ':')
+			return 0;
+	curtok =3D src;
+	saw_xdigit =3D 0;
+	val =3D 0;
+	while ((ch =3D *src++) !=3D '\0') {
+		const char *pch;
+
+		pch =3D strchr((xdigits =3D xdigits_l), ch);
+		if (pch =3D=3D NULL)
+			pch =3D strchr((xdigits =3D xdigits_u), ch);
+		if (pch !=3D NULL) {
+			val <<=3D 4;
+			val |=3D (pch - xdigits);
+			if (val > 0xffff)
+				return 0;
+			saw_xdigit =3D 1;
+			continue;
+		}
+		if (ch =3D=3D ':') {
+			curtok =3D src;
+			if (!saw_xdigit) {
+				if (colonp)
+					return 0;
+				colonp =3D tp;
+				continue;
+			}
+			if (tp + NS_INT16SZ > endp)
+				return 0;
+			*tp++ =3D (unsigned char) (val >> 8) & 0xff;
+			*tp++ =3D (unsigned char) val & 0xff;
+			saw_xdigit =3D 0;
+			val =3D 0;
+			continue;
+		}
+		if (ch =3D=3D '.' && ((tp + NS_INADDRSZ) <=3D endp) &&
+		    iscsi_pton4(curtok, tp) > 0) {
+			tp +=3D NS_INADDRSZ;
+			saw_xdigit =3D 0;
+			break;	/* '\0' was seen by inet_pton4(). */
+		}
+		return 0;
+	}
+	if (saw_xdigit) {
+		if (tp + NS_INT16SZ > endp)
+			return 0;
+		*tp++ =3D (unsigned char) (val >> 8) & 0xff;
+		*tp++ =3D (unsigned char) val & 0xff;
+	}
+	if (colonp !=3D NULL) {
+		/*
+		 * Since some memmove()'s erroneously fail to handle
+		 * overlapping regions, we'll do the shift by hand.
+		 */
+		const int n =3D tp - colonp;
+		int i;
+
+		for (i =3D 1; i <=3D n; i++) {
+			endp[-i] =3D colonp[n - i];
+			colonp[n - i] =3D 0;
+		}
+		tp =3D endp;
+	}
+	if (tp !=3D endp)
+		return 0;
+	memcpy(dst, tmp, NS_IN6ADDRSZ);
+	return 1;
+}
+
+struct iscsi_conn *iscsi_get_conn_from_cid(struct iscsi_session *sess,=
 u16 cid)
+{
+	struct iscsi_conn *conn;
+
+	spin_lock_bh(&sess->conn_lock);
+	list_for_each_entry(conn, &sess->sess_conn_list, conn_list) {
+		if ((conn->cid =3D=3D cid) &&
+		    (conn->conn_state =3D=3D TARG_CONN_STATE_LOGGED_IN)) {
+			iscsi_inc_conn_usage_count(conn);
+			spin_unlock_bh(&sess->conn_lock);
+			return conn;
+		}
+	}
+	spin_unlock_bh(&sess->conn_lock);
+
+	return NULL;
+}
+
+struct iscsi_conn *iscsi_get_conn_from_cid_rcfr(struct iscsi_session *=
sess, u16 cid)
+{
+	struct iscsi_conn *conn;
+
+	spin_lock_bh(&sess->conn_lock);
+	list_for_each_entry(conn, &sess->sess_conn_list, conn_list) {
+		if (conn->cid =3D=3D cid) {
+			iscsi_inc_conn_usage_count(conn);
+			spin_lock(&conn->state_lock);
+			atomic_set(&conn->connection_wait_rcfr, 1);
+			spin_unlock(&conn->state_lock);
+			spin_unlock_bh(&sess->conn_lock);
+			return conn;
+		}
+	}
+	spin_unlock_bh(&sess->conn_lock);
+
+	return NULL;
+}
+
+void iscsi_check_conn_usage_count(struct iscsi_conn *conn)
+{
+	spin_lock_bh(&conn->conn_usage_lock);
+	if (atomic_read(&conn->conn_usage_count)) {
+		atomic_set(&conn->conn_waiting_on_uc, 1);
+		spin_unlock_bh(&conn->conn_usage_lock);
+
+		wait_for_completion(&conn->conn_waiting_on_uc_comp);
+		return;
+	}
+	spin_unlock_bh(&conn->conn_usage_lock);
+}
+
+void iscsi_dec_conn_usage_count(struct iscsi_conn *conn)
+{
+	spin_lock_bh(&conn->conn_usage_lock);
+	atomic_dec(&conn->conn_usage_count);
+
+	if (!atomic_read(&conn->conn_usage_count) &&
+	     atomic_read(&conn->conn_waiting_on_uc))
+		complete(&conn->conn_waiting_on_uc_comp);
+
+	spin_unlock_bh(&conn->conn_usage_lock);
+}
+
+void iscsi_inc_conn_usage_count(struct iscsi_conn *conn)
+{
+	spin_lock_bh(&conn->conn_usage_lock);
+	atomic_inc(&conn->conn_usage_count);
+	spin_unlock_bh(&conn->conn_usage_lock);
+}
+
+void iscsi_async_msg_timer_function(unsigned long data)
+{
+	complete((struct completion *) data);
+}
+
+int iscsi_check_for_active_network_device(struct iscsi_conn *conn)
+{
+	struct net_device *net_dev;
+
+	if (!conn->net_if) {
+		printk(KERN_ERR "struct iscsi_conn->net_if is NULL for CID:"
+			" %hu\n", conn->cid);
+		return 0;
+	}
+	net_dev =3D conn->net_if;
+
+	return netif_carrier_ok(net_dev);
+}
+
+static void iscsi_handle_netif_timeout(unsigned long data)
+{
+	struct iscsi_conn *conn =3D (struct iscsi_conn *) data;
+
+	iscsi_inc_conn_usage_count(conn);
+
+	spin_lock_bh(&conn->netif_lock);
+	if (conn->netif_timer_flags & ISCSI_TF_STOP) {
+		spin_unlock_bh(&conn->netif_lock);
+		iscsi_dec_conn_usage_count(conn);
+		return;
+	}
+	conn->netif_timer_flags &=3D ~ISCSI_TF_RUNNING;
+
+	if (iscsi_check_for_active_network_device((void *)conn)) {
+		iscsi_start_netif_timer(conn);
+		spin_unlock_bh(&conn->netif_lock);
+		iscsi_dec_conn_usage_count(conn);
+		return;
+	}
+
+	printk(KERN_ERR "Detected PHY loss on Network Interface: %s for iSCSI=
"
+		" CID: %hu on SID: %u\n", conn->net_dev, conn->cid,
+			conn->sess->sid);
+
+	spin_unlock_bh(&conn->netif_lock);
+
+	iscsi_cause_connection_reinstatement(conn, 0);
+	iscsi_dec_conn_usage_count(conn);
+}
+
+void iscsi_get_network_interface_from_conn(struct iscsi_conn *conn)
+{
+	struct net_device *net_dev;
+
+	net_dev =3D dev_get_by_name(&init_net, conn->net_dev);
+	if (!net_dev) {
+		printk(KERN_ERR "Unable to locate active network interface:"
+			" %s\n", strlen(conn->net_dev) ?
+			conn->net_dev : "None");
+		conn->net_if =3D NULL;
+		return;
+	}
+
+	conn->net_if =3D net_dev;
+}
+
+/*      iscsi_start_netif_timer():
+ *
+ *	Called with conn->netif_lock held.
+ */
+void iscsi_start_netif_timer(struct iscsi_conn *conn)
+{
+	struct iscsi_portal_group *tpg =3D ISCSI_TPG_C(conn);
+
+	if (!conn->net_if)
+		return;
+
+	if (conn->netif_timer_flags & ISCSI_TF_RUNNING)
+		return;
+
+	init_timer(&conn->transport_timer);
+	conn->transport_timer.expires =3D
+		(get_jiffies_64() + ISCSI_TPG_ATTRIB(tpg)->netif_timeout * HZ);
+	conn->transport_timer.data =3D (unsigned long)conn;
+	conn->transport_timer.function =3D iscsi_handle_netif_timeout;
+	conn->netif_timer_flags &=3D ~ISCSI_TF_STOP;
+	conn->netif_timer_flags |=3D ISCSI_TF_RUNNING;
+	add_timer(&conn->transport_timer);
+}
+
+void iscsi_stop_netif_timer(struct iscsi_conn *conn)
+{
+	spin_lock_bh(&conn->netif_lock);
+	if (!(conn->netif_timer_flags & ISCSI_TF_RUNNING)) {
+		spin_unlock_bh(&conn->netif_lock);
+		return;
+	}
+	conn->netif_timer_flags |=3D ISCSI_TF_STOP;
+	spin_unlock_bh(&conn->netif_lock);
+
+	del_timer_sync(&conn->transport_timer);
+
+	spin_lock_bh(&conn->netif_lock);
+	conn->netif_timer_flags &=3D ~ISCSI_TF_RUNNING;
+	spin_unlock_bh(&conn->netif_lock);
+}
+
+static void iscsi_handle_nopin_response_timeout(unsigned long data)
+{
+	struct iscsi_conn *conn =3D (struct iscsi_conn *) data;
+
+	iscsi_inc_conn_usage_count(conn);
+
+	spin_lock_bh(&conn->nopin_timer_lock);
+	if (conn->nopin_response_timer_flags & ISCSI_TF_STOP) {
+		spin_unlock_bh(&conn->nopin_timer_lock);
+		iscsi_dec_conn_usage_count(conn);
+		return;
+	}
+
+	TRACE(TRACE_TIMER, "Did not receive response to NOPIN on CID: %hu on"
+		" SID: %u, failing connection.\n", conn->cid,
+			conn->sess->sid);
+	conn->nopin_response_timer_flags &=3D ~ISCSI_TF_RUNNING;
+	spin_unlock_bh(&conn->nopin_timer_lock);
+
+	{
+	struct iscsi_portal_group *tpg =3D conn->sess->tpg;
+	struct iscsi_tiqn *tiqn =3D tpg->tpg_tiqn;
+
+	if (tiqn) {
+		spin_lock_bh(&tiqn->sess_err_stats.lock);
+		strcpy(tiqn->sess_err_stats.last_sess_fail_rem_name,
+				(void *)conn->sess->sess_ops->InitiatorName);
+		tiqn->sess_err_stats.last_sess_failure_type =3D
+				ISCSI_SESS_ERR_CXN_TIMEOUT;
+		tiqn->sess_err_stats.cxn_timeout_errors++;
+		conn->sess->conn_timeout_errors++;
+		spin_unlock_bh(&tiqn->sess_err_stats.lock);
+	}
+	}
+
+	iscsi_cause_connection_reinstatement(conn, 0);
+	iscsi_dec_conn_usage_count(conn);
+}
+
+void iscsi_mod_nopin_response_timer(struct iscsi_conn *conn)
+{
+	struct iscsi_session *sess =3D conn->sess;
+	struct iscsi_node_attrib *na =3D iscsi_tpg_get_node_attrib(sess);
+
+	spin_lock_bh(&conn->nopin_timer_lock);
+	if (!(conn->nopin_response_timer_flags & ISCSI_TF_RUNNING)) {
+		spin_unlock_bh(&conn->nopin_timer_lock);
+		return;
+	}
+
+	mod_timer(&conn->nopin_response_timer,
+		(get_jiffies_64() + na->nopin_response_timeout * HZ));
+	spin_unlock_bh(&conn->nopin_timer_lock);
+}
+
+/*	iscsi_start_nopin_response_timer():
+ *
+ *	Called with conn->nopin_timer_lock held.
+ */
+void iscsi_start_nopin_response_timer(struct iscsi_conn *conn)
+{
+	struct iscsi_session *sess =3D conn->sess;
+	struct iscsi_node_attrib *na =3D iscsi_tpg_get_node_attrib(sess);
+
+	spin_lock_bh(&conn->nopin_timer_lock);
+	if (conn->nopin_response_timer_flags & ISCSI_TF_RUNNING) {
+		spin_unlock_bh(&conn->nopin_timer_lock);
+		return;
+	}
+
+	init_timer(&conn->nopin_response_timer);
+	conn->nopin_response_timer.expires =3D
+		(get_jiffies_64() + na->nopin_response_timeout * HZ);
+	conn->nopin_response_timer.data =3D (unsigned long)conn;
+	conn->nopin_response_timer.function =3D iscsi_handle_nopin_response_t=
imeout;
+	conn->nopin_response_timer_flags &=3D ~ISCSI_TF_STOP;
+	conn->nopin_response_timer_flags |=3D ISCSI_TF_RUNNING;
+	add_timer(&conn->nopin_response_timer);
+
+	TRACE(TRACE_TIMER, "Started NOPIN Response Timer on CID: %d to %u"
+		" seconds\n", conn->cid, na->nopin_response_timeout);
+	spin_unlock_bh(&conn->nopin_timer_lock);
+}
+
+void iscsi_stop_nopin_response_timer(struct iscsi_conn *conn)
+{
+	spin_lock_bh(&conn->nopin_timer_lock);
+	if (!(conn->nopin_response_timer_flags & ISCSI_TF_RUNNING)) {
+		spin_unlock_bh(&conn->nopin_timer_lock);
+		return;
+	}
+	conn->nopin_response_timer_flags |=3D ISCSI_TF_STOP;
+	spin_unlock_bh(&conn->nopin_timer_lock);
+
+	del_timer_sync(&conn->nopin_response_timer);
+
+	spin_lock_bh(&conn->nopin_timer_lock);
+	conn->nopin_response_timer_flags &=3D ~ISCSI_TF_RUNNING;
+	spin_unlock_bh(&conn->nopin_timer_lock);
+}
+
+static void iscsi_handle_nopin_timeout(unsigned long data)
+{
+	struct iscsi_conn *conn =3D (struct iscsi_conn *) data;
+
+	iscsi_inc_conn_usage_count(conn);
+
+	spin_lock_bh(&conn->nopin_timer_lock);
+	if (conn->nopin_timer_flags & ISCSI_TF_STOP) {
+		spin_unlock_bh(&conn->nopin_timer_lock);
+		iscsi_dec_conn_usage_count(conn);
+		return;
+	}
+	conn->nopin_timer_flags &=3D ~ISCSI_TF_RUNNING;
+	spin_unlock_bh(&conn->nopin_timer_lock);
+
+	iscsi_add_nopin(conn, 1);
+	iscsi_dec_conn_usage_count(conn);
+}
+
+/*
+ * Called with conn->nopin_timer_lock held.
+ */
+void __iscsi_start_nopin_timer(struct iscsi_conn *conn)
+{
+	struct iscsi_session *sess =3D conn->sess;
+	struct iscsi_node_attrib *na =3D iscsi_tpg_get_node_attrib(sess);
+	/*
+	* NOPIN timeout is disabled.
+	 */
+	if (!na->nopin_timeout)
+		return;
+
+	if (conn->nopin_timer_flags & ISCSI_TF_RUNNING)
+		return;
+
+	init_timer(&conn->nopin_timer);
+	conn->nopin_timer.expires =3D (get_jiffies_64() + na->nopin_timeout *=
 HZ);
+	conn->nopin_timer.data =3D (unsigned long)conn;
+	conn->nopin_timer.function =3D iscsi_handle_nopin_timeout;
+	conn->nopin_timer_flags &=3D ~ISCSI_TF_STOP;
+	conn->nopin_timer_flags |=3D ISCSI_TF_RUNNING;
+	add_timer(&conn->nopin_timer);
+
+	TRACE(TRACE_TIMER, "Started NOPIN Timer on CID: %d at %u second"
+		" interval\n", conn->cid, na->nopin_timeout);
+}
+
+void iscsi_start_nopin_timer(struct iscsi_conn *conn)
+{
+	struct iscsi_session *sess =3D conn->sess;
+	struct iscsi_node_attrib *na =3D iscsi_tpg_get_node_attrib(sess);
+	/*
+	 * NOPIN timeout is disabled..
+	 */
+	if (!na->nopin_timeout)
+		return;
+
+	spin_lock_bh(&conn->nopin_timer_lock);
+	if (conn->nopin_timer_flags & ISCSI_TF_RUNNING) {
+		spin_unlock_bh(&conn->nopin_timer_lock);
+		return;
+	}
+
+	init_timer(&conn->nopin_timer);
+	conn->nopin_timer.expires =3D (get_jiffies_64() + na->nopin_timeout *=
 HZ);
+	conn->nopin_timer.data =3D (unsigned long)conn;
+	conn->nopin_timer.function =3D iscsi_handle_nopin_timeout;
+	conn->nopin_timer_flags &=3D ~ISCSI_TF_STOP;
+	conn->nopin_timer_flags |=3D ISCSI_TF_RUNNING;
+	add_timer(&conn->nopin_timer);
+
+	TRACE(TRACE_TIMER, "Started NOPIN Timer on CID: %d at %u second"
+			" interval\n", conn->cid, na->nopin_timeout);
+	spin_unlock_bh(&conn->nopin_timer_lock);
+}
+
+void iscsi_stop_nopin_timer(struct iscsi_conn *conn)
+{
+	spin_lock_bh(&conn->nopin_timer_lock);
+	if (!(conn->nopin_timer_flags & ISCSI_TF_RUNNING)) {
+		spin_unlock_bh(&conn->nopin_timer_lock);
+		return;
+	}
+	conn->nopin_timer_flags |=3D ISCSI_TF_STOP;
+	spin_unlock_bh(&conn->nopin_timer_lock);
+
+	del_timer_sync(&conn->nopin_timer);
+
+	spin_lock_bh(&conn->nopin_timer_lock);
+	conn->nopin_timer_flags &=3D ~ISCSI_TF_RUNNING;
+	spin_unlock_bh(&conn->nopin_timer_lock);
+}
+
+int iscsi_allocate_iovecs_for_cmd(struct se_cmd *se_cmd)
+{
+	struct iscsi_cmd *cmd =3D container_of(se_cmd, struct iscsi_cmd, se_c=
md);
+	u32 iov_count =3D (T_TASK(se_cmd)->t_tasks_se_num =3D=3D 0) ? 1 :
+				T_TASK(se_cmd)->t_tasks_se_num;
+
+	iov_count +=3D TRANSPORT_IOV_DATA_BUFFER;
+
+	cmd->iov_data =3D kzalloc(iov_count * sizeof(struct iovec), GFP_KERNE=
L);
+	if (!cmd->iov_data)
+		return -ENOMEM;
+
+	cmd->orig_iov_data_count =3D iov_count;
+	return 0;
+}
+
+int iscsi_send_tx_data(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn,
+	int use_misc)
+{
+	int tx_sent, tx_size;
+	u32 iov_count;
+	struct iovec *iov;
+
+send_data:
+	tx_size =3D cmd->tx_size;
+
+	if (!use_misc) {
+		iov =3D &cmd->iov_data[0];
+		iov_count =3D cmd->iov_data_count;
+	} else {
+		iov =3D &cmd->iov_misc[0];
+		iov_count =3D cmd->iov_misc_count;
+	}
+
+	tx_sent =3D tx_data(conn, &iov[0], iov_count, tx_size);
+	if (tx_size !=3D tx_sent) {
+		if (tx_sent =3D=3D -EAGAIN) {
+			printk(KERN_ERR "tx_data() returned -EAGAIN\n");
+			goto send_data;
+		} else
+			return -1;
+	}
+	cmd->tx_size =3D 0;
+
+	return 0;
+}
+
+int iscsi_fe_sendpage_sg(
+	struct se_unmap_sg *u_sg,
+	struct iscsi_conn *conn)
+{
+	int tx_sent;
+	struct iscsi_cmd *cmd =3D (struct iscsi_cmd *)u_sg->fabric_cmd;
+	struct se_cmd *se_cmd =3D SE_CMD(cmd);
+	u32 len =3D cmd->tx_size, pg_len, se_len, se_off, tx_size;
+	struct iovec *iov =3D &cmd->iov_data[0];
+	struct page *page;
+	struct se_mem *se_mem =3D u_sg->cur_se_mem;
+
+send_hdr:
+	tx_size =3D (conn->conn_ops->HeaderDigest) ? ISCSI_HDR_LEN + CRC_LEN =
:
+			ISCSI_HDR_LEN;
+	tx_sent =3D tx_data(conn, iov, 1, tx_size);
+	if (tx_size !=3D tx_sent) {
+		if (tx_sent =3D=3D -EAGAIN) {
+			printk(KERN_ERR "tx_data() returned -EAGAIN\n");
+			goto send_hdr;
+		}
+		return -1;
+	}
+
+	len -=3D tx_size;
+	len -=3D u_sg->padding;
+	if (conn->conn_ops->DataDigest)
+		len -=3D CRC_LEN;
+
+	/*
+	 * Start calculating from the first page of current struct se_mem.
+	 */
+	page =3D se_mem->se_page;
+	pg_len =3D (PAGE_SIZE - se_mem->se_off);
+	se_len =3D se_mem->se_len;
+	if (se_len < pg_len)
+		pg_len =3D se_len;
+	se_off =3D se_mem->se_off;
+#if 0
+	printk(KERN_INFO "se: %p page: %p se_len: %d se_off: %d pg_len: %d\n"=
,
+		se_mem, page, se_len, se_off, pg_len);
+#endif
+	/*
+	 * Calucate new se_len and se_off based upon u_sg->t_offset into
+	 * the current struct se_mem and possibily a different page.
+	 */
+	while (u_sg->t_offset) {
+#if 0
+		printk(KERN_INFO "u_sg->t_offset: %d, page: %p se_len: %d"
+			" se_off: %d pg_len: %d\n", u_sg->t_offset, page,
+			se_len, se_off, pg_len);
+#endif
+		if (u_sg->t_offset >=3D pg_len) {
+			u_sg->t_offset -=3D pg_len;
+			se_len -=3D pg_len;
+			se_off =3D 0;
+			pg_len =3D PAGE_SIZE;
+			page++;
+		} else {
+			se_off +=3D u_sg->t_offset;
+			se_len -=3D u_sg->t_offset;
+			u_sg->t_offset =3D 0;
+		}
+	}
+
+	/*
+	 * Perform sendpage() for each page in the struct se_mem
+	 */
+	while (len) {
+#if 0
+		printk(KERN_INFO "len: %d page: %p se_len: %d se_off: %d\n",
+			len, page, se_len, se_off);
+#endif
+		if (se_len > len)
+			se_len =3D len;
+send_pg:
+		tx_sent =3D conn->sock->ops->sendpage(conn->sock,
+				page, se_off, se_len, 0);
+		if (tx_sent !=3D se_len) {
+			if (tx_sent =3D=3D -EAGAIN) {
+				printk(KERN_ERR "tcp_sendpage() returned"
+						" -EAGAIN\n");
+				goto send_pg;
+			}
+
+			printk(KERN_ERR "tcp_sendpage() failure: %d\n",
+					tx_sent);
+			return -1;
+		}
+
+		len -=3D se_len;
+		if (!(len))
+			break;
+
+		se_len -=3D tx_sent;
+		if (!(se_len)) {
+			list_for_each_entry_continue(se_mem,
+					T_TASK(se_cmd)->t_mem_list, se_list)
+				break;
+
+			if (!se_mem) {
+				printk(KERN_ERR "Unable to locate next struct se_mem\n");
+				return -1;
+			}
+
+			se_len =3D se_mem->se_len;
+			se_off =3D se_mem->se_off;
+			page =3D se_mem->se_page;
+		} else {
+			se_len =3D PAGE_SIZE;
+			se_off =3D 0;
+			page++;
+		}
+	}
+
+send_padding:
+	if (u_sg->padding) {
+		struct iovec *iov_p =3D
+			&cmd->iov_data[cmd->iov_data_count-2];
+
+		tx_sent =3D tx_data(conn, iov_p, 1, u_sg->padding);
+		if (u_sg->padding !=3D tx_sent) {
+			if (tx_sent =3D=3D -EAGAIN) {
+				printk(KERN_ERR "tx_data() returned -EAGAIN\n");
+				goto send_padding;
+			}
+			return -1;
+		}
+	}
+
+send_datacrc:
+	if (conn->conn_ops->DataDigest) {
+		struct iovec *iov_d =3D
+			&cmd->iov_data[cmd->iov_data_count-1];
+
+		tx_sent =3D tx_data(conn, iov_d, 1, CRC_LEN);
+		if (CRC_LEN !=3D tx_sent) {
+			if (tx_sent =3D=3D -EAGAIN) {
+				printk(KERN_ERR "tx_data() returned -EAGAIN\n");
+				goto send_datacrc;
+			}
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+/*      iscsi_tx_login_rsp():
+ *
+ *      This function is used for mainly sending a ISCSI_TARG_LOGIN_RS=
P PDU
+ *      back to the Initiator when an expection condition occurs with =
the
+ *      errors set in status_class and status_detail.
+ *
+ *      Parameters:     iSCSI Connection, Status Class, Status Detail.
+ *      Returns:        0 on success, -1 on error.
+ */
+int iscsi_tx_login_rsp(struct iscsi_conn *conn, u8 status_class, u8 st=
atus_detail)
+{
+	u8 iscsi_hdr[ISCSI_HDR_LEN];
+	int err;
+	struct iovec iov;
+	struct iscsi_login_rsp *hdr;
+
+	iscsi_collect_login_stats(conn, status_class, status_detail);
+
+	memset(&iov, 0, sizeof(struct iovec));
+	memset(&iscsi_hdr, 0x0, ISCSI_HDR_LEN);
+
+	hdr	=3D (struct iscsi_login_rsp *)&iscsi_hdr;
+	hdr->opcode		=3D ISCSI_OP_LOGIN_RSP;
+	hdr->status_class	=3D status_class;
+	hdr->status_detail	=3D status_detail;
+	hdr->itt		=3D cpu_to_be32(conn->login_itt);
+
+	iov.iov_base		=3D &iscsi_hdr;
+	iov.iov_len		=3D ISCSI_HDR_LEN;
+
+	PRINT_BUFF(iscsi_hdr, ISCSI_HDR_LEN);
+
+	err =3D tx_data(conn, &iov, 1, ISCSI_HDR_LEN);
+	if (err !=3D ISCSI_HDR_LEN) {
+		printk(KERN_ERR "tx_data returned less than expected\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+void iscsi_print_session_params(struct iscsi_session *sess)
+{
+	struct iscsi_conn *conn;
+
+	printk(KERN_INFO "-----------------------------[Session Params for"
+		" SID: %u]-----------------------------\n", sess->sid);
+	spin_lock_bh(&sess->conn_lock);
+	list_for_each_entry(conn, &sess->sess_conn_list, conn_list)
+		iscsi_dump_conn_ops(conn->conn_ops);
+	spin_unlock_bh(&sess->conn_lock);
+
+	iscsi_dump_sess_ops(sess->sess_ops);
+}
+
+static inline int iscsi_do_rx_data(
+	struct iscsi_conn *conn,
+	struct iscsi_data_count *count)
+{
+	int data =3D count->data_length, rx_loop =3D 0, total_rx =3D 0;
+	u32 rx_marker_val[count->ss_marker_count], rx_marker_iov =3D 0;
+	struct iovec iov[count->ss_iov_count];
+	mm_segment_t oldfs;
+	struct msghdr msg;
+
+	if (!conn || !conn->sock || !conn->conn_ops)
+		return -1;
+
+	memset(&msg, 0, sizeof(struct msghdr));
+
+	if (count->sync_and_steering) {
+		int size =3D 0;
+		u32 i, orig_iov_count =3D 0;
+		u32 orig_iov_len =3D 0, orig_iov_loc =3D 0;
+		u32 iov_count =3D 0, per_iov_bytes =3D 0;
+		u32 *rx_marker, old_rx_marker =3D 0;
+		struct iovec *iov_record;
+
+		memset(&rx_marker_val, 0,
+				count->ss_marker_count * sizeof(u32));
+		memset(&iov, 0, count->ss_iov_count * sizeof(struct iovec));
+
+		iov_record =3D count->iov;
+		orig_iov_count =3D count->iov_count;
+		rx_marker =3D &conn->of_marker;
+
+		i =3D 0;
+		size =3D data;
+		orig_iov_len =3D iov_record[orig_iov_loc].iov_len;
+		while (size > 0) {
+			TRACE(TRACE_SSLR, "rx_data: #1 orig_iov_len %u,"
+			" orig_iov_loc %u\n", orig_iov_len, orig_iov_loc);
+			TRACE(TRACE_SSLR, "rx_data: #2 rx_marker %u, size"
+				" %u\n", *rx_marker, size);
+
+			if (orig_iov_len >=3D *rx_marker) {
+				iov[iov_count].iov_len =3D *rx_marker;
+				iov[iov_count++].iov_base =3D
+					(iov_record[orig_iov_loc].iov_base +
+						per_iov_bytes);
+
+				iov[iov_count].iov_len =3D (MARKER_SIZE / 2);
+				iov[iov_count++].iov_base =3D
+					&rx_marker_val[rx_marker_iov++];
+				iov[iov_count].iov_len =3D (MARKER_SIZE / 2);
+				iov[iov_count++].iov_base =3D
+					&rx_marker_val[rx_marker_iov++];
+				old_rx_marker =3D *rx_marker;
+
+				/*
+				 * OFMarkInt is in 32-bit words.
+				 */
+				*rx_marker =3D (conn->conn_ops->OFMarkInt * 4);
+				size -=3D old_rx_marker;
+				orig_iov_len -=3D old_rx_marker;
+				per_iov_bytes +=3D old_rx_marker;
+
+				TRACE(TRACE_SSLR, "rx_data: #3 new_rx_marker"
+					" %u, size %u\n", *rx_marker, size);
+			} else {
+				iov[iov_count].iov_len =3D orig_iov_len;
+				iov[iov_count++].iov_base =3D
+					(iov_record[orig_iov_loc].iov_base +
+						per_iov_bytes);
+
+				per_iov_bytes =3D 0;
+				*rx_marker -=3D orig_iov_len;
+				size -=3D orig_iov_len;
+
+				if (size)
+					orig_iov_len =3D
+					iov_record[++orig_iov_loc].iov_len;
+
+				TRACE(TRACE_SSLR, "rx_data: #4 new_rx_marker"
+					" %u, size %u\n", *rx_marker, size);
+			}
+		}
+		data +=3D (rx_marker_iov * (MARKER_SIZE / 2));
+
+		msg.msg_iov	=3D &iov[0];
+		msg.msg_iovlen	=3D iov_count;
+
+		if (iov_count > count->ss_iov_count) {
+			printk(KERN_ERR "iov_count: %d, count->ss_iov_count:"
+				" %d\n", iov_count, count->ss_iov_count);
+			return -1;
+		}
+		if (rx_marker_iov > count->ss_marker_count) {
+			printk(KERN_ERR "rx_marker_iov: %d, count->ss_marker"
+				"_count: %d\n", rx_marker_iov,
+				count->ss_marker_count);
+			return -1;
+		}
+	} else {
+		msg.msg_iov	=3D count->iov;
+		msg.msg_iovlen	=3D count->iov_count;
+	}
+
+	while (total_rx < data) {
+		oldfs =3D get_fs();
+		set_fs(get_ds());
+
+		conn->sock->sk->sk_allocation =3D GFP_ATOMIC;
+		rx_loop =3D sock_recvmsg(conn->sock, &msg,
+				(data - total_rx), MSG_WAITALL);
+
+		set_fs(oldfs);
+
+		if (rx_loop <=3D 0) {
+			TRACE(TRACE_NET, "rx_loop: %d total_rx: %d\n",
+				rx_loop, total_rx);
+			return rx_loop;
+		}
+		total_rx +=3D rx_loop;
+		TRACE(TRACE_NET, "rx_loop: %d, total_rx: %d, data: %d\n",
+				rx_loop, total_rx, data);
+	}
+
+	if (count->sync_and_steering) {
+		int j;
+		for (j =3D 0; j < rx_marker_iov; j++) {
+			TRACE(TRACE_SSLR, "rx_data: #5 j: %d, offset: %d\n",
+				j, rx_marker_val[j]);
+			conn->of_marker_offset =3D rx_marker_val[j];
+		}
+		total_rx -=3D (rx_marker_iov * (MARKER_SIZE / 2));
+	}
+
+	return total_rx;
+}
+
+static inline int iscsi_do_tx_data(
+	struct iscsi_conn *conn,
+	struct iscsi_data_count *count)
+{
+	int data =3D count->data_length, total_tx =3D 0, tx_loop =3D 0;
+	u32 tx_marker_val[count->ss_marker_count], tx_marker_iov =3D 0;
+	struct iovec iov[count->ss_iov_count];
+	mm_segment_t oldfs;
+	struct msghdr msg;
+
+	if (!conn || !conn->sock || !conn->conn_ops)
+		return -1;
+
+	if (data <=3D 0) {
+		printk(KERN_ERR "Data length is: %d\n", data);
+		return -1;
+	}
+
+	memset(&msg, 0, sizeof(struct msghdr));
+
+	if (count->sync_and_steering) {
+		int size =3D 0;
+		u32 i, orig_iov_count =3D 0;
+		u32 orig_iov_len =3D 0, orig_iov_loc =3D 0;
+		u32 iov_count =3D 0, per_iov_bytes =3D 0;
+		u32 *tx_marker, old_tx_marker =3D 0;
+		struct iovec *iov_record;
+
+		memset(&tx_marker_val, 0,
+			count->ss_marker_count * sizeof(u32));
+		memset(&iov, 0, count->ss_iov_count * sizeof(struct iovec));
+
+		iov_record =3D count->iov;
+		orig_iov_count =3D count->iov_count;
+		tx_marker =3D &conn->if_marker;
+
+		i =3D 0;
+		size =3D data;
+		orig_iov_len =3D iov_record[orig_iov_loc].iov_len;
+		while (size > 0) {
+			TRACE(TRACE_SSLT, "tx_data: #1 orig_iov_len %u,"
+			" orig_iov_loc %u\n", orig_iov_len, orig_iov_loc);
+			TRACE(TRACE_SSLT, "tx_data: #2 tx_marker %u, size"
+				" %u\n", *tx_marker, size);
+
+			if (orig_iov_len >=3D *tx_marker) {
+				iov[iov_count].iov_len =3D *tx_marker;
+				iov[iov_count++].iov_base =3D
+					(iov_record[orig_iov_loc].iov_base +
+						per_iov_bytes);
+
+				tx_marker_val[tx_marker_iov] =3D
+						(size - *tx_marker);
+				iov[iov_count].iov_len =3D (MARKER_SIZE / 2);
+				iov[iov_count++].iov_base =3D
+					&tx_marker_val[tx_marker_iov++];
+				iov[iov_count].iov_len =3D (MARKER_SIZE / 2);
+				iov[iov_count++].iov_base =3D
+					&tx_marker_val[tx_marker_iov++];
+				old_tx_marker =3D *tx_marker;
+
+				/*
+				 * IFMarkInt is in 32-bit words.
+				 */
+				*tx_marker =3D (conn->conn_ops->IFMarkInt * 4);
+				size -=3D old_tx_marker;
+				orig_iov_len -=3D old_tx_marker;
+				per_iov_bytes +=3D old_tx_marker;
+
+				TRACE(TRACE_SSLT, "tx_data: #3 new_tx_marker"
+					" %u, size %u\n", *tx_marker, size);
+				TRACE(TRACE_SSLT, "tx_data: #4 offset %u\n",
+					tx_marker_val[tx_marker_iov-1]);
+			} else {
+				iov[iov_count].iov_len =3D orig_iov_len;
+				iov[iov_count++].iov_base
+					=3D (iov_record[orig_iov_loc].iov_base +
+						per_iov_bytes);
+
+				per_iov_bytes =3D 0;
+				*tx_marker -=3D orig_iov_len;
+				size -=3D orig_iov_len;
+
+				if (size)
+					orig_iov_len =3D
+					iov_record[++orig_iov_loc].iov_len;
+
+				TRACE(TRACE_SSLT, "tx_data: #5 new_tx_marker"
+					" %u, size %u\n", *tx_marker, size);
+			}
+		}
+
+		data +=3D (tx_marker_iov * (MARKER_SIZE / 2));
+
+		msg.msg_iov	=3D &iov[0];
+		msg.msg_iovlen =3D iov_count;
+
+		if (iov_count > count->ss_iov_count) {
+			printk(KERN_ERR "iov_count: %d, count->ss_iov_count:"
+				" %d\n", iov_count, count->ss_iov_count);
+			return -1;
+		}
+		if (tx_marker_iov > count->ss_marker_count) {
+			printk(KERN_ERR "tx_marker_iov: %d, count->ss_marker"
+				"_count: %d\n", tx_marker_iov,
+				count->ss_marker_count);
+			return -1;
+		}
+	} else {
+		msg.msg_iov	=3D count->iov;
+		msg.msg_iovlen	=3D count->iov_count;
+	}
+
+	while (total_tx < data) {
+		oldfs =3D get_fs();
+		set_fs(get_ds());
+
+		conn->sock->sk->sk_allocation =3D GFP_ATOMIC;
+		tx_loop =3D sock_sendmsg(conn->sock, &msg, (data - total_tx));
+
+		set_fs(oldfs);
+
+		if (tx_loop <=3D 0) {
+			TRACE(TRACE_NET, "tx_loop: %d total_tx %d\n",
+				tx_loop, total_tx);
+			return tx_loop;
+		}
+		total_tx +=3D tx_loop;
+		TRACE(TRACE_NET, "tx_loop: %d, total_tx: %d, data: %d\n",
+					tx_loop, total_tx, data);
+	}
+
+	if (count->sync_and_steering)
+		total_tx -=3D (tx_marker_iov * (MARKER_SIZE / 2));
+
+	return total_tx;
+}
+
+int rx_data(
+	struct iscsi_conn *conn,
+	struct iovec *iov,
+	int iov_count,
+	int data)
+{
+	struct iscsi_data_count c;
+
+	if (!conn || !conn->sock || !conn->conn_ops)
+		return -1;
+
+	memset(&c, 0, sizeof(struct iscsi_data_count));
+	c.iov =3D iov;
+	c.iov_count =3D iov_count;
+	c.data_length =3D data;
+	c.type =3D ISCSI_RX_DATA;
+
+	if (conn->conn_ops->OFMarker &&
+	   (conn->conn_state >=3D TARG_CONN_STATE_LOGGED_IN)) {
+		if (iscsi_determine_sync_and_steering_counts(conn, &c) < 0)
+			return -1;
+	}
+
+	return iscsi_do_rx_data(conn, &c);
+}
+
+int tx_data(
+	struct iscsi_conn *conn,
+	struct iovec *iov,
+	int iov_count,
+	int data)
+{
+	struct iscsi_data_count c;
+
+	if (!conn || !conn->sock || !conn->conn_ops)
+		return -1;
+
+	memset(&c, 0, sizeof(struct iscsi_data_count));
+	c.iov =3D iov;
+	c.iov_count =3D iov_count;
+	c.data_length =3D data;
+	c.type =3D ISCSI_TX_DATA;
+
+	if (conn->conn_ops->IFMarker &&
+	   (conn->conn_state >=3D TARG_CONN_STATE_LOGGED_IN)) {
+		if (iscsi_determine_sync_and_steering_counts(conn, &c) < 0)
+			return -1;
+	}
+
+	return iscsi_do_tx_data(conn, &c);
+}
+
+void iscsi_collect_login_stats(
+	struct iscsi_conn *conn,
+	u8 status_class,
+	u8 status_detail)
+{
+	struct iscsi_param *intrname =3D NULL;
+	struct iscsi_tiqn *tiqn;
+	struct iscsi_login_stats *ls;
+
+	tiqn =3D iscsi_snmp_get_tiqn(conn);
+	if (!(tiqn))
+		return;
+
+	ls =3D &tiqn->login_stats;
+
+	spin_lock(&ls->lock);
+	if (((conn->login_ip =3D=3D ls->last_intr_fail_addr) ||
+	    !(memcmp(conn->ipv6_login_ip, ls->last_intr_fail_ip6_addr,
+		IPV6_ADDRESS_SPACE))) &&
+	    ((get_jiffies_64() - ls->last_fail_time) < 10)) {
+		/* We already have the failure info for this login */
+		spin_unlock(&ls->lock);
+		return;
+	}
+
+	if (status_class =3D=3D ISCSI_STATUS_CLS_SUCCESS)
+		ls->accepts++;
+	else if (status_class =3D=3D ISCSI_STATUS_CLS_REDIRECT) {
+		ls->redirects++;
+		ls->last_fail_type =3D ISCSI_LOGIN_FAIL_REDIRECT;
+	} else if ((status_class =3D=3D ISCSI_STATUS_CLS_INITIATOR_ERR)  &&
+		 (status_detail =3D=3D ISCSI_LOGIN_STATUS_AUTH_FAILED)) {
+		ls->authenticate_fails++;
+		ls->last_fail_type =3D  ISCSI_LOGIN_FAIL_AUTHENTICATE;
+	} else if ((status_class =3D=3D ISCSI_STATUS_CLS_INITIATOR_ERR)  &&
+		 (status_detail =3D=3D ISCSI_LOGIN_STATUS_TGT_FORBIDDEN)) {
+		ls->authorize_fails++;
+		ls->last_fail_type =3D ISCSI_LOGIN_FAIL_AUTHORIZE;
+	} else if ((status_class =3D=3D ISCSI_STATUS_CLS_INITIATOR_ERR) &&
+		 (status_detail =3D=3D ISCSI_LOGIN_STATUS_INIT_ERR)) {
+		ls->negotiate_fails++;
+		ls->last_fail_type =3D ISCSI_LOGIN_FAIL_NEGOTIATE;
+	} else {
+		ls->other_fails++;
+		ls->last_fail_type =3D ISCSI_LOGIN_FAIL_OTHER;
+	}
+
+	/* Save initiator name, ip address and time, if it is a failed login =
*/
+	if (status_class !=3D ISCSI_STATUS_CLS_SUCCESS) {
+		if (conn->param_list)
+			intrname =3D iscsi_find_param_from_key(INITIATORNAME,
+							     conn->param_list);
+		strcpy(ls->last_intr_fail_name,
+		       (intrname ? intrname->value : "Unknown"));
+
+		if (conn->ipv6_login_ip !=3D NULL) {
+			memcpy(ls->last_intr_fail_ip6_addr,
+				conn->ipv6_login_ip, IPV6_ADDRESS_SPACE);
+			ls->last_intr_fail_addr =3D 0;
+		} else {
+			memset(ls->last_intr_fail_ip6_addr, 0,
+				IPV6_ADDRESS_SPACE);
+			ls->last_intr_fail_addr =3D conn->login_ip;
+		}
+		ls->last_fail_time =3D get_jiffies_64();
+	}
+
+	spin_unlock(&ls->lock);
+}
+
+struct iscsi_tiqn *iscsi_snmp_get_tiqn(struct iscsi_conn *conn)
+{
+	struct iscsi_portal_group *tpg;
+
+	if (!conn || !conn->sess)
+		return NULL;
+
+	tpg =3D conn->sess->tpg;
+	if (!tpg)
+		return NULL;
+
+	if (!tpg->tpg_tiqn)
+		return NULL;
+
+	return tpg->tpg_tiqn;
+}
+
+extern int iscsi_build_sendtargets_response(struct iscsi_cmd *cmd)
+{
+	char *ip, *payload =3D NULL;
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_portal_group *tpg;
+	struct iscsi_tiqn *tiqn;
+	struct iscsi_tpg_np *tpg_np;
+	int buffer_len, end_of_buf =3D 0, len =3D 0, payload_len =3D 0;
+	unsigned char buf[256];
+	unsigned char buf_ipv4[IPV4_BUF_SIZE];
+
+	buffer_len =3D (conn->conn_ops->MaxRecvDataSegmentLength > 32768) ?
+			32768 : conn->conn_ops->MaxRecvDataSegmentLength;
+
+	payload =3D kzalloc(buffer_len, GFP_KERNEL);
+	if (!payload) {
+		printk(KERN_ERR "Unable to allocate memory for sendtargets"
+			" response.\n");
+		return -1;
+	}
+
+	spin_lock(&tiqn_lock);
+	list_for_each_entry(tiqn, &g_tiqn_list, tiqn_list) {
+		memset(buf, 0, 256);
+
+		len =3D sprintf(buf, "TargetName=3D%s", tiqn->tiqn);
+		len +=3D 1;
+
+		if ((len + payload_len) > buffer_len) {
+			spin_unlock(&tiqn->tiqn_tpg_lock);
+			end_of_buf =3D 1;
+			goto eob;
+		}
+		memcpy((void *)payload + payload_len, buf, len);
+		payload_len +=3D len;
+
+		spin_lock(&tiqn->tiqn_tpg_lock);
+		list_for_each_entry(tpg, &tiqn->tiqn_tpg_list, tpg_list) {
+
+			spin_lock(&tpg->tpg_state_lock);
+			if ((tpg->tpg_state =3D=3D TPG_STATE_FREE) ||
+			    (tpg->tpg_state =3D=3D TPG_STATE_INACTIVE)) {
+				spin_unlock(&tpg->tpg_state_lock);
+				continue;
+			}
+			spin_unlock(&tpg->tpg_state_lock);
+
+			spin_lock(&tpg->tpg_np_lock);
+			list_for_each_entry(tpg_np, &tpg->tpg_gnp_list,
+					tpg_np_list) {
+				memset(buf, 0, 256);
+
+				if (tpg_np->tpg_np->np_flags & NPF_NET_IPV6)
+					ip =3D &tpg_np->tpg_np->np_ipv6[0];
+				else {
+					memset(buf_ipv4, 0, IPV4_BUF_SIZE);
+					iscsi_ntoa2(buf_ipv4,
+						tpg_np->tpg_np->np_ipv4);
+					ip =3D &buf_ipv4[0];
+				}
+
+				len =3D sprintf(buf, "TargetAddress=3D"
+					"%s%s%s:%hu,%hu",
+					(tpg_np->tpg_np->np_flags &
+						NPF_NET_IPV6) ?
+					"[" : "", ip,
+					(tpg_np->tpg_np->np_flags &
+						NPF_NET_IPV6) ?
+					"]" : "", tpg_np->tpg_np->np_port,
+					tpg->tpgt);
+				len +=3D 1;
+
+				if ((len + payload_len) > buffer_len) {
+					spin_unlock(&tpg->tpg_np_lock);
+					spin_unlock(&tiqn->tiqn_tpg_lock);
+					end_of_buf =3D 1;
+					goto eob;
+				}
+
+				memcpy((void *)payload + payload_len, buf, len);
+				payload_len +=3D len;
+			}
+			spin_unlock(&tpg->tpg_np_lock);
+		}
+		spin_unlock(&tiqn->tiqn_tpg_lock);
+eob:
+		if (end_of_buf)
+			break;
+	}
+	spin_unlock(&tiqn_lock);
+
+	cmd->buf_ptr =3D payload;
+
+	return payload_len;
+}
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/=
iscsi/iscsi_target_util.h
new file mode 100644
index 0000000..204bc20
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -0,0 +1,127 @@
+#ifndef ISCSI_TARGET_UTIL_H
+#define ISCSI_TARGET_UTIL_H
+
+#define MARKER_SIZE	8
+
+struct se_cmd;
+
+struct se_offset_map {
+	int                     map_reset;
+	u32                     iovec_length;
+	u32                     iscsi_offset;
+	u32                     current_offset;
+	u32                     orig_offset;
+	u32                     sg_count;
+	u32                     sg_current;
+	u32                     sg_length;
+	struct page		*sg_page;
+	struct se_mem		*map_se_mem;
+	struct se_mem		*map_orig_se_mem;
+	void			*iovec_base;
+} ____cacheline_aligned;
+
+struct se_map_sg {
+	int			sg_kmap_active:1;
+	u32			data_length;
+	u32			data_offset;
+	void			*fabric_cmd;
+	struct se_cmd		*se_cmd;
+	struct iovec		*iov;
+} ____cacheline_aligned;
+
+struct se_unmap_sg {
+	u32			data_length;
+	u32			sg_count;
+	u32			sg_offset;
+	u32			padding;
+	u32			t_offset;
+	void			*fabric_cmd;
+	struct se_cmd		*se_cmd;
+	struct se_offset_map	lmap;
+	struct se_mem		*cur_se_mem;
+} ____cacheline_aligned;
+
+extern void iscsi_attach_cmd_to_queue(struct iscsi_conn *, struct iscs=
i_cmd *);
+extern void iscsi_remove_cmd_from_conn_list(struct iscsi_cmd *, struct=
 iscsi_conn *);
+extern void iscsi_ack_from_expstatsn(struct iscsi_conn *, u32);
+extern void iscsi_remove_conn_from_list(struct iscsi_session *, struct=
 iscsi_conn *);
+extern int iscsi_add_r2t_to_list(struct iscsi_cmd *, u32, u32, int, u3=
2);
+extern struct iscsi_r2t *iscsi_get_r2t_for_eos(struct iscsi_cmd *, u32=
, u32);
+extern struct iscsi_r2t *iscsi_get_r2t_from_list(struct iscsi_cmd *);
+extern void iscsi_free_r2t(struct iscsi_r2t *, struct iscsi_cmd *);
+extern void iscsi_free_r2ts_from_list(struct iscsi_cmd *);
+extern struct iscsi_cmd *iscsi_allocate_cmd(struct iscsi_conn *);
+extern struct iscsi_cmd *iscsi_allocate_se_cmd(struct iscsi_conn *, u3=
2, int, int);
+extern struct iscsi_cmd *iscsi_allocate_se_cmd_for_tmr(struct iscsi_co=
nn *, u8);
+extern int iscsi_decide_list_to_build(struct iscsi_cmd *, u32);
+extern struct iscsi_seq *iscsi_get_seq_holder_for_datain(struct iscsi_=
cmd *, u32);
+extern struct iscsi_seq *iscsi_get_seq_holder_for_r2t(struct iscsi_cmd=
 *);
+extern struct iscsi_r2t *iscsi_get_holder_for_r2tsn(struct iscsi_cmd *=
, u32);
+extern int iscsi_check_received_cmdsn(struct iscsi_conn *, struct iscs=
i_cmd *, u32);
+extern int iscsi_check_unsolicited_dataout(struct iscsi_cmd *, unsigne=
d char *);
+extern struct iscsi_cmd *iscsi_find_cmd_from_itt(struct iscsi_conn *, =
u32);
+extern struct iscsi_cmd *iscsi_find_cmd_from_itt_or_dump(struct iscsi_=
conn *,
+			u32, u32);
+extern struct iscsi_cmd *iscsi_find_cmd_from_ttt(struct iscsi_conn *, =
u32);
+extern int iscsi_find_cmd_for_recovery(struct iscsi_session *, struct =
iscsi_cmd **,
+			struct iscsi_conn_recovery **, u32);
+extern void iscsi_add_cmd_to_immediate_queue(struct iscsi_cmd *, struc=
t iscsi_conn *, u8);
+extern struct iscsi_queue_req *iscsi_get_cmd_from_immediate_queue(stru=
ct iscsi_conn *);
+extern void iscsi_add_cmd_to_response_queue(struct iscsi_cmd *, struct=
 iscsi_conn *, u8);
+extern struct iscsi_queue_req *iscsi_get_cmd_from_response_queue(struc=
t iscsi_conn *);
+extern void iscsi_remove_cmd_from_tx_queues(struct iscsi_cmd *, struct=
 iscsi_conn *);
+extern void iscsi_free_queue_reqs_for_conn(struct iscsi_conn *);
+extern void iscsi_release_cmd_direct(struct iscsi_cmd *);
+extern void lio_release_cmd_direct(struct se_cmd *);
+extern void __iscsi_release_cmd_to_pool(struct iscsi_cmd *, struct isc=
si_session *);
+extern void iscsi_release_cmd_to_pool(struct iscsi_cmd *);
+extern void lio_release_cmd_to_pool(struct se_cmd *);
+extern u64 iscsi_pack_lun(unsigned int);
+extern u32 iscsi_unpack_lun(unsigned char *);
+extern int iscsi_check_session_usage_count(struct iscsi_session *);
+extern void iscsi_dec_session_usage_count(struct iscsi_session *);
+extern void iscsi_inc_session_usage_count(struct iscsi_session *);
+extern int iscsi_set_sync_and_steering_values(struct iscsi_conn *);
+extern unsigned char *iscsi_ntoa(u32);
+extern void iscsi_ntoa2(unsigned char *, u32);
+extern const char *iscsi_ntop6(const unsigned char *, char *, size_t);
+extern int iscsi_pton6(const char *, unsigned char *);
+extern struct iscsi_conn *iscsi_get_conn_from_cid(struct iscsi_session=
 *, u16);
+extern struct iscsi_conn *iscsi_get_conn_from_cid_rcfr(struct iscsi_se=
ssion *, u16);
+extern void iscsi_check_conn_usage_count(struct iscsi_conn *);
+extern void iscsi_dec_conn_usage_count(struct iscsi_conn *);
+extern void iscsi_inc_conn_usage_count(struct iscsi_conn *);
+extern void iscsi_async_msg_timer_function(unsigned long);
+extern int iscsi_check_for_active_network_device(struct iscsi_conn *);
+extern void iscsi_get_network_interface_from_conn(struct iscsi_conn *)=
;
+extern void iscsi_start_netif_timer(struct iscsi_conn *);
+extern void iscsi_stop_netif_timer(struct iscsi_conn *);
+extern void iscsi_mod_nopin_response_timer(struct iscsi_conn *);
+extern void iscsi_start_nopin_response_timer(struct iscsi_conn *);
+extern void iscsi_stop_nopin_response_timer(struct iscsi_conn *);
+extern void __iscsi_start_nopin_timer(struct iscsi_conn *);
+extern void iscsi_start_nopin_timer(struct iscsi_conn *);
+extern void iscsi_stop_nopin_timer(struct iscsi_conn *);
+extern int iscsi_allocate_iovecs_for_cmd(struct se_cmd *);
+extern int iscsi_send_tx_data(struct iscsi_cmd *, struct iscsi_conn *,=
 int);
+extern int iscsi_fe_sendpage_sg(struct se_unmap_sg *, struct iscsi_con=
n *);
+extern int iscsi_tx_login_rsp(struct iscsi_conn *, u8, u8);
+extern void iscsi_print_session_params(struct iscsi_session *);
+extern int iscsi_print_dev_to_proc(char *, char **, off_t, int);
+extern int iscsi_print_sessions_to_proc(char *, char **, off_t, int);
+extern int iscsi_print_tpg_to_proc(char *, char **, off_t, int);
+extern int rx_data(struct iscsi_conn *, struct iovec *, int, int);
+extern int tx_data(struct iscsi_conn *, struct iovec *, int, int);
+extern void iscsi_collect_login_stats(struct iscsi_conn *, u8, u8);
+extern struct iscsi_tiqn *iscsi_snmp_get_tiqn(struct iscsi_conn *);
+extern int iscsi_build_sendtargets_response(struct iscsi_cmd *);
+
+extern struct target_fabric_configfs *lio_target_fabric_configfs;
+extern struct iscsi_global *iscsi_global;
+extern struct kmem_cache *lio_cmd_cache;
+extern struct kmem_cache *lio_qr_cache;
+extern struct kmem_cache *lio_r2t_cache;
+
+extern int iscsi_add_nopin(struct iscsi_conn *, int);
+
+#endif /*** ISCSI_TARGET_UTIL_H ***/
--=20
1.7.4.1
