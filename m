From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 10/20] target/iscsi: Remove iscsi_target_debug.h and usage of TRACE() & printk()
Date: Thu,  7 Jul 2011 15:33:21 -0700
Message-ID: <1310078011-15504-11-git-send-email-agrover@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab1GGWdq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2011 18:33:46 -0400
In-Reply-To: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

This should have the effect of quieting dmesg output when there are no
issues, and yet still allow these messages to be enabled during a debugging
session if needs be.

Replaced all printk(KERN_ERR) with pr_err()

Replaced all printk(KERN_INFO) with pr_debug()

Replaced all uses of TRACE() with pr_debug()

Moved PRINT_BUFF macro to iscsi_target_util.c, only place it's used

Remove iscsi debug config option

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/iscsi/Kconfig                      |    9 -
 drivers/target/iscsi/iscsi_target.c               |  319 ++++++++++-----------
 drivers/target/iscsi/iscsi_target_auth.c          |   84 +++---
 drivers/target/iscsi/iscsi_target_configfs.c      |   76 +++---
 drivers/target/iscsi/iscsi_target_datain_values.c |   13 +-
 drivers/target/iscsi/iscsi_target_debug.h         |  113 --------
 drivers/target/iscsi/iscsi_target_device.c        |    3 +-
 drivers/target/iscsi/iscsi_target_erl0.c          |   67 +++---
 drivers/target/iscsi/iscsi_target_erl1.c          |   65 ++---
 drivers/target/iscsi/iscsi_target_erl2.c          |   25 +-
 drivers/target/iscsi/iscsi_target_login.c         |  105 ++++----
 drivers/target/iscsi/iscsi_target_nego.c          |   89 +++---
 drivers/target/iscsi/iscsi_target_nodeattrib.c    |   41 ++--
 drivers/target/iscsi/iscsi_target_parameters.c    |  259 +++++++++---------
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |   43 ++--
 drivers/target/iscsi/iscsi_target_tmr.c           |   49 ++--
 drivers/target/iscsi/iscsi_target_tpg.c           |   77 +++---
 drivers/target/iscsi/iscsi_target_tq.c            |   27 +-
 drivers/target/iscsi/iscsi_target_util.c          |  128 +++++----
 19 files changed, 731 insertions(+), 861 deletions(-)
 delete mode 100644 drivers/target/iscsi/iscsi_target_debug.h

diff --git a/drivers/target/iscsi/Kconfig b/drivers/target/iscsi/Kconfig
index b927796..564ff4e 100644
--- a/drivers/target/iscsi/Kconfig
+++ b/drivers/target/iscsi/Kconfig
@@ -6,12 +6,3 @@ config ISCSI_TARGET
 	help
 	Say M here to enable the ConfigFS enabled Linux-iSCSI.org iSCSI
 	Target Mode Stack.
-
-if ISCSI_TARGET
-
-config ISCSI_TARGET_DEBUG
-	bool "LIO-Target iscsi_debug.h ring buffer messages"
-	help
-	Say Y here to enable the legacy DEBUG_ISCSI macros in iscsi_debug.h
-
-endif
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index fd83beb..f0681ca 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -29,7 +29,6 @@
 #include <target/target_core_tmr.h>
 #include <target/target_core_transport.h>
 
-#include "iscsi_target_debug.h"
 #include "iscsi_target_core.h"
 #include "iscsi_target_parameters.h"
 #include "iscsi_target_seq_pdu_list.h"
@@ -122,14 +121,14 @@ struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf)
 	int ret;
 
 	if (strlen(buf) > ISCSI_IQN_LEN) {
-		printk(KERN_ERR "Target IQN exceeds %d bytes\n",
+		pr_err("Target IQN exceeds %d bytes\n",
 				ISCSI_IQN_LEN);
 		return ERR_PTR(-EINVAL);
 	}
 
 	tiqn = kzalloc(sizeof(struct iscsi_tiqn), GFP_KERNEL);
 	if (!tiqn) {
-		printk(KERN_ERR "Unable to allocate struct iscsi_tiqn\n");
+		pr_err("Unable to allocate struct iscsi_tiqn\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -143,7 +142,7 @@ struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf)
 	spin_lock_init(&tiqn->logout_stats.lock);
 
 	if (!idr_pre_get(&tiqn_idr, GFP_KERNEL)) {
-		printk(KERN_ERR "idr_pre_get() for tiqn_idr failed\n");
+		pr_err("idr_pre_get() for tiqn_idr failed\n");
 		kfree(tiqn);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -152,7 +151,7 @@ struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf)
 	spin_lock(&tiqn_lock);
 	ret = idr_get_new(&tiqn_idr, NULL, &tiqn->tiqn_index);
 	if (ret < 0) {
-		printk("idr_get_new() failed for tiqn->tiqn_index\n");
+		pr_err("idr_get_new() failed for tiqn->tiqn_index\n");
 		spin_unlock(&tiqn_lock);
 		kfree(tiqn);
 		return ERR_PTR(ret);
@@ -160,7 +159,7 @@ struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf)
 	list_add_tail(&tiqn->tiqn_list, &g_tiqn_list);
 	spin_unlock(&tiqn_lock);
 
-	printk(KERN_INFO "CORE[0] - Added iSCSI Target IQN: %s\n", tiqn->tiqn);
+	pr_debug("CORE[0] - Added iSCSI Target IQN: %s\n", tiqn->tiqn);
 
 	return tiqn;
 
@@ -189,7 +188,7 @@ void iscsit_del_tiqn(struct iscsi_tiqn *tiqn)
 	 * fabric and control code paths.
 	 */
 	if (iscsit_set_tiqn_shutdown(tiqn) < 0) {
-		printk(KERN_ERR "iscsit_set_tiqn_shutdown() failed\n");
+		pr_err("iscsit_set_tiqn_shutdown() failed\n");
 		return;
 	}
 
@@ -200,7 +199,7 @@ void iscsit_del_tiqn(struct iscsi_tiqn *tiqn)
 	idr_remove(&tiqn_idr, tiqn->tiqn_index);
 	spin_unlock(&tiqn_lock);
 
-	printk(KERN_INFO "CORE[0] - Deleted iSCSI Target IQN: %s\n",
+	pr_debug("CORE[0] - Deleted iSCSI Target IQN: %s\n",
 			tiqn->tiqn);
 	kfree(tiqn);
 }
@@ -217,7 +216,7 @@ int iscsit_access_np(struct iscsi_np *np, struct iscsi_portal_group *tpg)
 		return -1;
 	}
 	if (np->np_login_tpg) {
-		printk(KERN_ERR "np->np_login_tpg() is not NULL!\n");
+		pr_err("np->np_login_tpg() is not NULL!\n");
 		spin_unlock_bh(&np->np_thread_lock);
 		return -1;
 	}
@@ -338,7 +337,7 @@ struct iscsi_np *iscsit_add_np(
 
 	np = kzalloc(sizeof(struct iscsi_np), GFP_KERNEL);
 	if (!np) {
-		printk(KERN_ERR "Unable to allocate memory for struct iscsi_np\n");
+		pr_err("Unable to allocate memory for struct iscsi_np\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -366,7 +365,7 @@ struct iscsi_np *iscsit_add_np(
 
 	np->np_thread = kthread_run(iscsi_target_login_thread, np, "iscsi_np");
 	if (IS_ERR(np->np_thread)) {
-		printk(KERN_ERR "Unable to create kthread: iscsi_np\n");
+		pr_err("Unable to create kthread: iscsi_np\n");
 		ret = PTR_ERR(np->np_thread);
 		kfree(np);
 		return ERR_PTR(ret);
@@ -384,7 +383,7 @@ struct iscsi_np *iscsit_add_np(
 	list_add_tail(&np->np_list, &g_np_list);
 	spin_unlock_bh(&np_lock);
 
-	printk(KERN_INFO "CORE[0] - Added Network Portal: %s:%hu on %s\n",
+	pr_debug("CORE[0] - Added Network Portal: %s:%hu on %s\n",
 		np->np_ip, np->np_port, (np->np_network_transport == ISCSI_TCP) ?
 		"TCP" : "SCTP");
 
@@ -467,7 +466,7 @@ int iscsit_del_np(struct iscsi_np *np)
 	list_del(&np->np_list);
 	spin_unlock_bh(&np_lock);
 
-	printk(KERN_INFO "CORE[0] - Removed Network Portal: %s:%hu on %s\n",
+	pr_debug("CORE[0] - Removed Network Portal: %s:%hu on %s\n",
 		np->np_ip, np->np_port, (np->np_network_transport == ISCSI_TCP) ?
 		"TCP" : "SCTP");
 
@@ -479,11 +478,11 @@ static int __init iscsi_target_init_module(void)
 {
 	int ret = 0;
 
-	printk(KERN_INFO "iSCSI-Target "ISCSIT_VERSION"\n");
+	pr_debug("iSCSI-Target "ISCSIT_VERSION"\n");
 
 	iscsit_global = kzalloc(sizeof(struct iscsit_global), GFP_KERNEL);
 	if (!iscsit_global) {
-		printk(KERN_ERR "Unable to allocate memory for iscsit_global\n");
+		pr_err("Unable to allocate memory for iscsit_global\n");
 		return -1;
 	}
 	mutex_init(&auth_id_lock);
@@ -501,7 +500,7 @@ static int __init iscsi_target_init_module(void)
 
 	if (iscsi_allocate_thread_sets(TARGET_THREAD_SET_COUNT) !=
 			TARGET_THREAD_SET_COUNT) {
-		printk(KERN_ERR "iscsi_allocate_thread_sets() returned"
+		pr_err("iscsi_allocate_thread_sets() returned"
 			" unexpected value!\n");
 		goto ts_out1;
 	}
@@ -510,7 +509,7 @@ static int __init iscsi_target_init_module(void)
 			sizeof(struct iscsi_cmd), __alignof__(struct iscsi_cmd),
 			0, NULL);
 	if (!lio_cmd_cache) {
-		printk(KERN_ERR "Unable to kmem_cache_create() for"
+		pr_err("Unable to kmem_cache_create() for"
 				" lio_cmd_cache\n");
 		goto ts_out2;
 	}
@@ -519,7 +518,7 @@ static int __init iscsi_target_init_module(void)
 			sizeof(struct iscsi_queue_req),
 			__alignof__(struct iscsi_queue_req), 0, NULL);
 	if (!lio_qr_cache) {
-		printk(KERN_ERR "nable to kmem_cache_create() for"
+		pr_err("nable to kmem_cache_create() for"
 				" lio_qr_cache\n");
 		goto cmd_out;
 	}
@@ -528,7 +527,7 @@ static int __init iscsi_target_init_module(void)
 			sizeof(struct iscsi_datain_req),
 			__alignof__(struct iscsi_datain_req), 0, NULL);
 	if (!lio_dr_cache) {
-		printk(KERN_ERR "Unable to kmem_cache_create() for"
+		pr_err("Unable to kmem_cache_create() for"
 				" lio_dr_cache\n");
 		goto qr_out;
 	}
@@ -537,7 +536,7 @@ static int __init iscsi_target_init_module(void)
 			sizeof(struct iscsi_ooo_cmdsn),
 			__alignof__(struct iscsi_ooo_cmdsn), 0, NULL);
 	if (!lio_ooo_cache) {
-		printk(KERN_ERR "Unable to kmem_cache_create() for"
+		pr_err("Unable to kmem_cache_create() for"
 				" lio_ooo_cache\n");
 		goto dr_out;
 	}
@@ -546,7 +545,7 @@ static int __init iscsi_target_init_module(void)
 			sizeof(struct iscsi_r2t), __alignof__(struct iscsi_r2t),
 			0, NULL);
 	if (!lio_r2t_cache) {
-		printk(KERN_ERR "Unable to kmem_cache_create() for"
+		pr_err("Unable to kmem_cache_create() for"
 				" lio_r2t_cache\n");
 		goto ooo_out;
 	}
@@ -615,7 +614,7 @@ int iscsit_add_reject(
 
 	cmd->buf_ptr = kzalloc(ISCSI_HDR_LEN, GFP_KERNEL);
 	if (!cmd->buf_ptr) {
-		printk(KERN_ERR "Unable to allocate memory for cmd->buf_ptr\n");
+		pr_err("Unable to allocate memory for cmd->buf_ptr\n");
 		iscsit_release_cmd(cmd);
 		return -1;
 	}
@@ -647,7 +646,7 @@ int iscsit_add_reject_from_cmd(
 	int ret;
 
 	if (!cmd->conn) {
-		printk(KERN_ERR "cmd->conn is NULL for ITT: 0x%08x\n",
+		pr_err("cmd->conn is NULL for ITT: 0x%08x\n",
 				cmd->init_task_tag);
 		return -1;
 	}
@@ -662,7 +661,7 @@ int iscsit_add_reject_from_cmd(
 
 	cmd->buf_ptr = kzalloc(ISCSI_HDR_LEN, GFP_KERNEL);
 	if (!cmd->buf_ptr) {
-		printk(KERN_ERR "Unable to allocate memory for cmd->buf_ptr\n");
+		pr_err("Unable to allocate memory for cmd->buf_ptr\n");
 		iscsit_release_cmd(cmd);
 		return -1;
 	}
@@ -769,7 +768,7 @@ static int iscsit_allocate_iovecs(struct iscsi_cmd *cmd)
 
 	cmd->iov_data = kzalloc(iov_count * sizeof(struct kvec), GFP_KERNEL);
 	if (!cmd->iov_data) {
-		printk(KERN_ERR "Unable to allocate cmd->iov_data\n");
+		pr_err("Unable to allocate cmd->iov_data\n");
 		return -ENOMEM;
 	}
 
@@ -864,7 +863,7 @@ static int iscsit_handle_scsi_cmd(
 
 	if (!(hdr->flags & ISCSI_FLAG_CMD_WRITE) &&
 	    !(hdr->flags & ISCSI_FLAG_CMD_FINAL)) {
-		printk(KERN_ERR "ISCSI_FLAG_CMD_WRITE & ISCSI_FLAG_CMD_FINAL"
+		pr_err("ISCSI_FLAG_CMD_WRITE & ISCSI_FLAG_CMD_FINAL"
 				" not set. Bad iSCSI Initiator.\n");
 		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
 				buf, conn);
@@ -884,7 +883,7 @@ static int iscsit_handle_scsi_cmd(
 			goto done;
 		}
 
-		printk(KERN_ERR "ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE"
+		pr_err("ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE"
 			" set when Expected Data Transfer Length is 0 for"
 			" CDB: 0x%02x. Bad iSCSI Initiator.\n", hdr->cdb[0]);
 		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
@@ -894,7 +893,7 @@ done:
 
 	if (!(hdr->flags & ISCSI_FLAG_CMD_READ) &&
 	    !(hdr->flags & ISCSI_FLAG_CMD_WRITE) && (hdr->data_length != 0)) {
-		printk(KERN_ERR "ISCSI_FLAG_CMD_READ and/or ISCSI_FLAG_CMD_WRITE"
+		pr_err("ISCSI_FLAG_CMD_READ and/or ISCSI_FLAG_CMD_WRITE"
 			" MUST be set if Expected Data Transfer Length is not 0."
 			" Bad iSCSI Initiator\n");
 		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
@@ -903,20 +902,20 @@ done:
 
 	if ((hdr->flags & ISCSI_FLAG_CMD_READ) &&
 	    (hdr->flags & ISCSI_FLAG_CMD_WRITE)) {
-		printk(KERN_ERR "Bidirectional operations not supported!\n");
+		pr_err("Bidirectional operations not supported!\n");
 		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
 				buf, conn);
 	}
 
 	if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
-		printk(KERN_ERR "Illegally set Immediate Bit in iSCSI Initiator"
+		pr_err("Illegally set Immediate Bit in iSCSI Initiator"
 				" Scsi Command PDU.\n");
 		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
 				buf, conn);
 	}
 
 	if (payload_length && !conn->sess->sess_ops->ImmediateData) {
-		printk(KERN_ERR "ImmediateData=No but DataSegmentLength=%u,"
+		pr_err("ImmediateData=No but DataSegmentLength=%u,"
 			" protocol error.\n", payload_length);
 		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
 				buf, conn);
@@ -924,7 +923,7 @@ done:
 
 	if ((hdr->data_length == payload_length) &&
 	    (!(hdr->flags & ISCSI_FLAG_CMD_FINAL))) {
-		printk(KERN_ERR "Expected Data Transfer Length and Length of"
+		pr_err("Expected Data Transfer Length and Length of"
 			" Immediate Data are the same, but ISCSI_FLAG_CMD_FINAL"
 			" bit is not set protocol error\n");
 		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
@@ -932,7 +931,7 @@ done:
 	}
 
 	if (payload_length > hdr->data_length) {
-		printk(KERN_ERR "DataSegmentLength: %u is greater than"
+		pr_err("DataSegmentLength: %u is greater than"
 			" EDTL: %u, protocol error.\n", payload_length,
 				hdr->data_length);
 		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
@@ -940,7 +939,7 @@ done:
 	}
 
 	if (payload_length > conn->conn_ops->MaxRecvDataSegmentLength) {
-		printk(KERN_ERR "DataSegmentLength: %u is greater than"
+		pr_err("DataSegmentLength: %u is greater than"
 			" MaxRecvDataSegmentLength: %u, protocol error.\n",
 			payload_length, conn->conn_ops->MaxRecvDataSegmentLength);
 		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
@@ -948,7 +947,7 @@ done:
 	}
 
 	if (payload_length > conn->sess->sess_ops->FirstBurstLength) {
-		printk(KERN_ERR "DataSegmentLength: %u is greater than"
+		pr_err("DataSegmentLength: %u is greater than"
 			" FirstBurstLength: %u, protocol error.\n",
 			payload_length, conn->sess->sess_ops->FirstBurstLength);
 		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
@@ -965,7 +964,7 @@ done:
 		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES, 1,
 					buf, conn);
 
-	TRACE(TRACE_ISCSI, "Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
+	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
 		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
 		hdr->cmdsn, hdr->data_length, payload_length, conn->cid);
 
@@ -1010,7 +1009,7 @@ done:
 				get_unaligned_le64(&hdr->lun[0]));
 	if (ret < 0) {
 		if (SE_CMD(cmd)->scsi_sense_reason == TCM_NON_EXISTENT_LUN) {
-			TRACE(TRACE_VANITY, "Responding to non-acl'ed,"
+			pr_debug("Responding to non-acl'ed,"
 				" non-existent or non-exported iSCSI LUN:"
 				" 0x%016Lx\n", get_unaligned_le64(&hdr->lun[0]));
 		}
@@ -1256,7 +1255,7 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
 	hdr->offset		= be32_to_cpu(hdr->offset);
 
 	if (!payload_length) {
-		printk(KERN_ERR "DataOUT payload is ZERO, protocol error.\n");
+		pr_err("DataOUT payload is ZERO, protocol error.\n");
 		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
 					buf, conn);
 	}
@@ -1272,7 +1271,7 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
 	spin_unlock_bh(&conn->sess->session_stats_lock);
 
 	if (payload_length > conn->conn_ops->MaxRecvDataSegmentLength) {
-		printk(KERN_ERR "DataSegmentLength: %u is greater than"
+		pr_err("DataSegmentLength: %u is greater than"
 			" MaxRecvDataSegmentLength: %u\n", payload_length,
 			conn->conn_ops->MaxRecvDataSegmentLength);
 		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
@@ -1284,20 +1283,20 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
 	if (!cmd)
 		return 0;
 
-	TRACE(TRACE_ISCSI, "Got DataOut ITT: 0x%08x, TTT: 0x%08x,"
+	pr_debug("Got DataOut ITT: 0x%08x, TTT: 0x%08x,"
 		" DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
 		hdr->itt, hdr->ttt, hdr->datasn, hdr->offset,
 		payload_length, conn->cid);
 
 	if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
-		printk(KERN_ERR "Command ITT: 0x%08x received DataOUT after"
+		pr_err("Command ITT: 0x%08x received DataOUT after"
 			" last DataOUT received, dumping payload\n",
 			cmd->init_task_tag);
 		return iscsit_dump_data_payload(conn, payload_length, 1);
 	}
 
 	if (cmd->data_direction != DMA_TO_DEVICE) {
-		printk(KERN_ERR "Command ITT: 0x%08x received DataOUT for a"
+		pr_err("Command ITT: 0x%08x received DataOUT for a"
 			" NON-WRITE command.\n", cmd->init_task_tag);
 		return iscsit_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
 				1, 0, buf, cmd);
@@ -1306,7 +1305,7 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
 	iscsit_mod_dataout_timer(cmd);
 
 	if ((hdr->offset + payload_length) > cmd->data_length) {
-		printk(KERN_ERR "DataOut Offset: %u, Length %u greater than"
+		pr_err("DataOut Offset: %u, Length %u greater than"
 			" iSCSI Command EDTL %u, protocol error.\n",
 			hdr->offset, payload_length, cmd->data_length);
 		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
@@ -1317,7 +1316,7 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
 		int dump_unsolicited_data = 0;
 
 		if (conn->sess->sess_ops->InitialR2T) {
-			printk(KERN_ERR "Received unexpected unsolicited data"
+			pr_err("Received unexpected unsolicited data"
 				" while InitialR2T=Yes, protocol error.\n");
 			transport_send_check_condition_and_sense(SE_CMD(cmd),
 					TCM_UNEXPECTED_UNSOLICITED_DATA, 0);
@@ -1399,7 +1398,7 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
 		iov[iov_count].iov_base	= cmd->pad_bytes;
 		iov[iov_count++].iov_len = padding;
 		rx_size += padding;
-		TRACE(TRACE_ISCSI, "Receiving %u padding bytes.\n", padding);
+		pr_debug("Receiving %u padding bytes.\n", padding);
 	}
 
 	if (conn->conn_ops->DataDigest) {
@@ -1423,14 +1422,14 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
 						    cmd->pad_bytes);
 
 		if (checksum != data_crc) {
-			printk(KERN_ERR "ITT: 0x%08x, Offset: %u, Length: %u,"
+			pr_err("ITT: 0x%08x, Offset: %u, Length: %u,"
 				" DataSN: 0x%08x, CRC32C DataDigest 0x%08x"
 				" does not match computed 0x%08x\n",
 				hdr->itt, hdr->offset, payload_length,
 				hdr->datasn, checksum, data_crc);
 			data_crc_failed = 1;
 		} else {
-			TRACE(TRACE_DIGEST, "Got CRC32C DataDigest 0x%08x for"
+			pr_debug("Got CRC32C DataDigest 0x%08x for"
 				" %u bytes of Data Out\n", checksum,
 				payload_length);
 		}
@@ -1486,14 +1485,14 @@ static int iscsit_handle_nop_out(
 	hdr->exp_statsn		= be32_to_cpu(hdr->exp_statsn);
 
 	if ((hdr->itt == 0xFFFFFFFF) && !(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
-		printk(KERN_ERR "NOPOUT ITT is reserved, but Immediate Bit is"
+		pr_err("NOPOUT ITT is reserved, but Immediate Bit is"
 			" not set, protocol error.\n");
 		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
 					buf, conn);
 	}
 
 	if (payload_length > conn->conn_ops->MaxRecvDataSegmentLength) {
-		printk(KERN_ERR "NOPOUT Ping Data DataSegmentLength: %u is"
+		pr_err("NOPOUT Ping Data DataSegmentLength: %u is"
 			" greater than MaxRecvDataSegmentLength: %u, protocol"
 			" error.\n", payload_length,
 			conn->conn_ops->MaxRecvDataSegmentLength);
@@ -1501,7 +1500,7 @@ static int iscsit_handle_nop_out(
 					buf, conn);
 	}
 
-	TRACE(TRACE_ISCSI, "Got NOPOUT Ping %s ITT: 0x%08x, TTT: 0x%09x,"
+	pr_debug("Got NOPOUT Ping %s ITT: 0x%08x, TTT: 0x%09x,"
 		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, Length: %u\n",
 		(hdr->itt == 0xFFFFFFFF) ? "Response" : "Request",
 		hdr->itt, hdr->ttt, hdr->cmdsn, hdr->exp_statsn,
@@ -1535,7 +1534,7 @@ static int iscsit_handle_nop_out(
 		rx_size = payload_length;
 		ping_data = kzalloc(payload_length + 1, GFP_KERNEL);
 		if (!ping_data) {
-			printk(KERN_ERR "Unable to allocate memory for"
+			pr_err("Unable to allocate memory for"
 				" NOPOUT ping data.\n");
 			ret = -1;
 			goto out;
@@ -1547,7 +1546,7 @@ static int iscsit_handle_nop_out(
 
 		padding = ((-payload_length) & 3);
 		if (padding != 0) {
-			TRACE(TRACE_ISCSI, "Receiving %u additional bytes"
+			pr_debug("Receiving %u additional bytes"
 				" for padding.\n", padding);
 			iov[niov].iov_base	= &cmd->pad_bytes;
 			iov[niov++].iov_len	= padding;
@@ -1572,11 +1571,11 @@ static int iscsit_handle_nop_out(
 					(u8 *)&data_crc);
 
 			if (checksum != data_crc) {
-				printk(KERN_ERR "Ping data CRC32C DataDigest"
+				pr_err("Ping data CRC32C DataDigest"
 				" 0x%08x does not match computed 0x%08x\n",
 					checksum, data_crc);
 				if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-					printk(KERN_ERR "Unable to recover from"
+					pr_err("Unable to recover from"
 					" NOPOUT Ping DataCRC failure while in"
 						" ERL=0.\n");
 					ret = -1;
@@ -1586,14 +1585,14 @@ static int iscsit_handle_nop_out(
 					 * Silently drop this PDU and let the
 					 * initiator plug the CmdSN gap.
 					 */
-					TRACE(TRACE_ERL1, "Dropping NOPOUT"
+					pr_debug("Dropping NOPOUT"
 					" Command CmdSN: 0x%08x due to"
 					" DataCRC error.\n", hdr->cmdsn);
 					ret = 0;
 					goto out;
 				}
 			} else {
-				TRACE(TRACE_DIGEST, "Got CRC32C DataDigest"
+				pr_debug("Got CRC32C DataDigest"
 				" 0x%08x for %u bytes of ping data.\n",
 					checksum, payload_length);
 			}
@@ -1606,14 +1605,14 @@ static int iscsit_handle_nop_out(
 		cmd->buf_ptr = (void *)ping_data;
 		cmd->buf_ptr_size = payload_length;
 
-		TRACE(TRACE_ISCSI, "Got %u bytes of NOPOUT ping"
+		pr_debug("Got %u bytes of NOPOUT ping"
 			" data.\n", payload_length);
-		TRACE(TRACE_ISCSI, "Ping Data: \"%s\"\n", ping_data);
+		pr_debug("Ping Data: \"%s\"\n", ping_data);
 	}
 
 	if (hdr->itt != 0xFFFFFFFF) {
 		if (!cmd) {
-			printk(KERN_ERR "Checking CmdSN for NOPOUT,"
+			pr_err("Checking CmdSN for NOPOUT,"
 				" but cmd is NULL!\n");
 			return -1;
 		}
@@ -1705,7 +1704,7 @@ static int iscsit_handle_task_mgt_cmd(
 	hdr->flags &= ~ISCSI_FLAG_CMD_FINAL;
 	function = hdr->flags;
 
-	TRACE(TRACE_ISCSI, "Got Task Management Request ITT: 0x%08x, CmdSN:"
+	pr_debug("Got Task Management Request ITT: 0x%08x, CmdSN:"
 		" 0x%08x, Function: 0x%02x, RefTaskTag: 0x%08x, RefCmdSN:"
 		" 0x%08x, CID: %hu\n", hdr->itt, hdr->cmdsn, function,
 		hdr->rtt, hdr->refcmdsn, conn->cid);
@@ -1713,13 +1712,13 @@ static int iscsit_handle_task_mgt_cmd(
 	if ((function != ISCSI_TM_FUNC_ABORT_TASK) &&
 	    ((function != ISCSI_TM_FUNC_TASK_REASSIGN) &&
 	     (hdr->rtt != ISCSI_RESERVED_TAG))) {
-		printk(KERN_ERR "RefTaskTag should be set to 0xFFFFFFFF.\n");
+		pr_err("RefTaskTag should be set to 0xFFFFFFFF.\n");
 		hdr->rtt = ISCSI_RESERVED_TAG;
 	}
 
 	if ((function == ISCSI_TM_FUNC_TASK_REASSIGN) &&
 			!(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
-		printk(KERN_ERR "Task Management Request TASK_REASSIGN not"
+		pr_err("Task Management Request TASK_REASSIGN not"
 			" issued as immediate command, bad iSCSI Initiator"
 				"implementation\n");
 		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
@@ -1798,7 +1797,7 @@ static int iscsit_handle_task_mgt_cmd(
 					buf, cmd);
 		break;
 	default:
-		printk(KERN_ERR "Unknown TMR function: 0x%02x, protocol"
+		pr_err("Unknown TMR function: 0x%02x, protocol"
 			" error.\n", function);
 		SE_CMD(cmd)->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		se_tmr->response = ISCSI_TMF_RSP_NOT_SUPPORTED;
@@ -1868,14 +1867,14 @@ static int iscsit_handle_text_cmd(
 	hdr->exp_statsn		= be32_to_cpu(hdr->exp_statsn);
 
 	if (payload_length > conn->conn_ops->MaxRecvDataSegmentLength) {
-		printk(KERN_ERR "Unable to accept text parameter length: %u"
+		pr_err("Unable to accept text parameter length: %u"
 			"greater than MaxRecvDataSegmentLength %u.\n",
 		       payload_length, conn->conn_ops->MaxRecvDataSegmentLength);
 		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
 					buf, conn);
 	}
 
-	TRACE(TRACE_ISCSI, "Got Text Request: ITT: 0x%08x, CmdSN: 0x%08x,"
+	pr_debug("Got Text Request: ITT: 0x%08x, CmdSN: 0x%08x,"
 		" ExpStatSN: 0x%08x, Length: %u\n", hdr->itt, hdr->cmdsn,
 		hdr->exp_statsn, payload_length);
 
@@ -1883,7 +1882,7 @@ static int iscsit_handle_text_cmd(
 	if (text_length) {
 		text_in = kzalloc(text_length, GFP_KERNEL);
 		if (!text_in) {
-			printk(KERN_ERR "Unable to allocate memory for"
+			pr_err("Unable to allocate memory for"
 				" incoming text parameters\n");
 			return -1;
 		}
@@ -1897,7 +1896,7 @@ static int iscsit_handle_text_cmd(
 			iov[niov].iov_base = cmd->pad_bytes;
 			iov[niov++].iov_len  = padding;
 			rx_size += padding;
-			TRACE(TRACE_ISCSI, "Receiving %u additional bytes"
+			pr_debug("Receiving %u additional bytes"
 					" for padding.\n", padding);
 		}
 		if (conn->conn_ops->DataDigest) {
@@ -1919,11 +1918,11 @@ static int iscsit_handle_text_cmd(
 					(u8 *)&data_crc);
 
 			if (checksum != data_crc) {
-				printk(KERN_ERR "Text data CRC32C DataDigest"
+				pr_err("Text data CRC32C DataDigest"
 					" 0x%08x does not match computed"
 					" 0x%08x\n", checksum, data_crc);
 				if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-					printk(KERN_ERR "Unable to recover from"
+					pr_err("Unable to recover from"
 					" Text Data digest failure while in"
 						" ERL=0.\n");
 					kfree(text_in);
@@ -1933,37 +1932,37 @@ static int iscsit_handle_text_cmd(
 					 * Silently drop this PDU and let the
 					 * initiator plug the CmdSN gap.
 					 */
-					TRACE(TRACE_ERL1, "Dropping Text"
+					pr_debug("Dropping Text"
 					" Command CmdSN: 0x%08x due to"
 					" DataCRC error.\n", hdr->cmdsn);
 					kfree(text_in);
 					return 0;
 				}
 			} else {
-				TRACE(TRACE_DIGEST, "Got CRC32C DataDigest"
+				pr_debug("Got CRC32C DataDigest"
 					" 0x%08x for %u bytes of text data.\n",
 						checksum, text_length);
 			}
 		}
 		text_in[text_length - 1] = '\0';
-		TRACE(TRACE_ISCSI, "Successfully read %d bytes of text"
+		pr_debug("Successfully read %d bytes of text"
 				" data.\n", text_length);
 
 		if (strncmp("SendTargets", text_in, 11) != 0) {
-			printk(KERN_ERR "Received Text Data that is not"
+			pr_err("Received Text Data that is not"
 				" SendTargets, cannot continue.\n");
 			kfree(text_in);
 			return -1;
 		}
 		text_ptr = strchr(text_in, '=');
 		if (!text_ptr) {
-			printk(KERN_ERR "No \"=\" separator found in Text Data,"
+			pr_err("No \"=\" separator found in Text Data,"
 				"  cannot continue.\n");
 			kfree(text_in);
 			return -1;
 		}
 		if (strncmp("=All", text_ptr, 4) != 0) {
-			printk(KERN_ERR "Unable to locate All value for"
+			pr_err("Unable to locate All value for"
 				" SendTargets key,  cannot continue.\n");
 			kfree(text_in);
 			return -1;
@@ -2010,7 +2009,7 @@ int iscsit_logout_closesession(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	struct iscsi_conn *conn_p;
 	struct iscsi_session *sess = conn->sess;
 
-	TRACE(TRACE_ISCSI, "Received logout request CLOSESESSION on CID: %hu"
+	pr_debug("Received logout request CLOSESESSION on CID: %hu"
 		" for SID: %u.\n", conn->cid, conn->sess->sid);
 
 	atomic_set(&sess->session_logout, 1);
@@ -2025,7 +2024,7 @@ int iscsit_logout_closesession(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 		if (conn_p->conn_state != TARG_CONN_STATE_LOGGED_IN)
 			continue;
 
-		TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
+		pr_debug("Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
 		conn_p->conn_state = TARG_CONN_STATE_IN_LOGOUT;
 	}
 	spin_unlock_bh(&sess->conn_lock);
@@ -2040,7 +2039,7 @@ int iscsit_logout_closeconnection(struct iscsi_cmd *cmd, struct iscsi_conn *conn
 	struct iscsi_conn *l_conn;
 	struct iscsi_session *sess = conn->sess;
 
-	TRACE(TRACE_ISCSI, "Received logout request CLOSECONNECTION for CID:"
+	pr_debug("Received logout request CLOSECONNECTION for CID:"
 		" %hu on CID: %hu.\n", cmd->logout_cid, conn->cid);
 
 	/*
@@ -2049,7 +2048,7 @@ int iscsit_logout_closeconnection(struct iscsi_cmd *cmd, struct iscsi_conn *conn
 	 */
 	if (conn->cid == cmd->logout_cid) {
 		spin_lock_bh(&conn->state_lock);
-		TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
+		pr_debug("Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
 		conn->conn_state = TARG_CONN_STATE_IN_LOGOUT;
 
 		atomic_set(&conn->conn_logout_remove, 1);
@@ -2087,11 +2086,11 @@ int iscsit_logout_removeconnforrecovery(struct iscsi_cmd *cmd, struct iscsi_conn
 {
 	struct iscsi_session *sess = conn->sess;
 
-	TRACE(TRACE_ERL2, "Received explicit REMOVECONNFORRECOVERY logout for"
+	pr_debug("Received explicit REMOVECONNFORRECOVERY logout for"
 		" CID: %hu on CID: %hu.\n", cmd->logout_cid, conn->cid);
 
 	if (sess->sess_ops->ErrorRecoveryLevel != 2) {
-		printk(KERN_ERR "Received Logout Request REMOVECONNFORRECOVERY"
+		pr_err("Received Logout Request REMOVECONNFORRECOVERY"
 			" while ERL!=2.\n");
 		cmd->logout_response = ISCSI_LOGOUT_RECOVERY_UNSUPPORTED;
 		iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
@@ -2099,7 +2098,7 @@ int iscsit_logout_removeconnforrecovery(struct iscsi_cmd *cmd, struct iscsi_conn
 	}
 
 	if (conn->cid == cmd->logout_cid) {
-		printk(KERN_ERR "Received Logout Request REMOVECONNFORRECOVERY"
+		pr_err("Received Logout Request REMOVECONNFORRECOVERY"
 			" with CID: %hu on CID: %hu, implementation error.\n",
 				cmd->logout_cid, conn->cid);
 		cmd->logout_response = ISCSI_LOGOUT_CLEANUP_FAILED;
@@ -2138,13 +2137,13 @@ static int iscsit_handle_logout_cmd(
 		spin_unlock(&tiqn->logout_stats.lock);
 	}
 
-	TRACE(TRACE_ISCSI, "Got Logout Request ITT: 0x%08x CmdSN: 0x%08x"
+	pr_debug("Got Logout Request ITT: 0x%08x CmdSN: 0x%08x"
 		" ExpStatSN: 0x%08x Reason: 0x%02x CID: %hu on CID: %hu\n",
 		hdr->itt, hdr->cmdsn, hdr->exp_statsn, reason_code,
 		hdr->cid, conn->cid);
 
 	if (conn->conn_state != TARG_CONN_STATE_LOGGED_IN) {
-		printk(KERN_ERR "Received logout request on connection that"
+		pr_err("Received logout request on connection that"
 			" is not in logged in state, ignoring request.\n");
 		return 0;
 	}
@@ -2208,7 +2207,7 @@ static int iscsit_handle_snack(
 	struct iscsi_conn *conn,
 	unsigned char *buf)
 {
-	u32 debug_type, unpacked_lun;
+	u32 unpacked_lun;
 	u64 lun;
 	struct iscsi_snack *hdr;
 
@@ -2222,14 +2221,13 @@ static int iscsit_handle_snack(
 	hdr->begrun		= be32_to_cpu(hdr->begrun);
 	hdr->runlength		= be32_to_cpu(hdr->runlength);
 
-	debug_type = (hdr->flags & 0x02) ? TRACE_ISCSI : TRACE_ERL1;
-	TRACE(debug_type, "Got ISCSI_INIT_SNACK, ITT: 0x%08x, ExpStatSN:"
+	pr_debug("Got ISCSI_INIT_SNACK, ITT: 0x%08x, ExpStatSN:"
 		" 0x%08x, Type: 0x%02x, BegRun: 0x%08x, RunLength: 0x%08x,"
 		" CID: %hu\n", hdr->itt, hdr->exp_statsn, hdr->flags,
 			hdr->begrun, hdr->runlength, conn->cid);
 
 	if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-		printk(KERN_ERR "Initiator sent SNACK request while in"
+		pr_err("Initiator sent SNACK request while in"
 			" ErrorRecoveryLevel=0.\n");
 		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
 					buf, conn);
@@ -2251,11 +2249,11 @@ static int iscsit_handle_snack(
 			hdr->runlength);
 	case ISCSI_FLAG_SNACK_TYPE_RDATA:
 		/* FIXME: Support R-Data SNACK */
-		printk(KERN_ERR "R-Data SNACK Not Supported.\n");
+		pr_err("R-Data SNACK Not Supported.\n");
 		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
 					buf, conn);
 	default:
-		printk(KERN_ERR "Unknown SNACK type 0x%02x, protocol"
+		pr_err("Unknown SNACK type 0x%02x, protocol"
 			" error.\n", hdr->flags & 0x0f);
 		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
 					buf, conn);
@@ -2322,12 +2320,12 @@ static int iscsit_handle_immediate_data(
 						    cmd->pad_bytes);
 
 		if (checksum != data_crc) {
-			printk(KERN_ERR "ImmediateData CRC32C DataDigest 0x%08x"
+			pr_err("ImmediateData CRC32C DataDigest 0x%08x"
 				" does not match computed 0x%08x\n", checksum,
 				data_crc);
 
 			if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-				printk(KERN_ERR "Unable to recover from"
+				pr_err("Unable to recover from"
 					" Immediate Data digest failure while"
 					" in ERL=0.\n");
 				iscsit_add_reject_from_cmd(
@@ -2341,7 +2339,7 @@ static int iscsit_handle_immediate_data(
 				return IMMEDIATE_DATA_ERL1_CRC_FAILURE;
 			}
 		} else {
-			TRACE(TRACE_DIGEST, "Got CRC32C DataDigest 0x%08x for"
+			pr_debug("Got CRC32C DataDigest 0x%08x for"
 				" %u bytes of Immediate Data\n", checksum,
 				length);
 		}
@@ -2433,7 +2431,7 @@ static int iscsit_send_conn_drop_async_message(
 				0, NULL, (u8 *)header_digest);
 
 		cmd->tx_size += ISCSI_CRC_LEN;
-		TRACE(TRACE_DIGEST, "Attaching CRC32C HeaderDigest to"
+		pr_debug("Attaching CRC32C HeaderDigest to"
 			" Async Message 0x%08x\n", *header_digest);
 	}
 
@@ -2441,7 +2439,7 @@ static int iscsit_send_conn_drop_async_message(
 	cmd->iov_misc[0].iov_len	= cmd->tx_size;
 	cmd->iov_misc_count		= 1;
 
-	TRACE(TRACE_ERL2, "Sending Connection Dropped Async Message StatSN:"
+	pr_debug("Sending Connection Dropped Async Message StatSN:"
 		" 0x%08x, for CID: %hu on CID: %hu\n", cmd->stat_sn,
 			cmd->logout_cid, conn->cid);
 	return 0;
@@ -2462,7 +2460,7 @@ static int iscsit_send_data_in(
 	memset(&datain, 0, sizeof(struct iscsi_datain));
 	dr = iscsit_get_datain_values(cmd, &datain);
 	if (!dr) {
-		printk(KERN_ERR "iscsit_get_datain_values failed for ITT: 0x%08x\n",
+		pr_err("iscsit_get_datain_values failed for ITT: 0x%08x\n",
 				cmd->init_task_tag);
 		return -1;
 	}
@@ -2471,7 +2469,7 @@ static int iscsit_send_data_in(
 	 * Be paranoid and double check the logic for now.
 	 */
 	if ((datain.offset + datain.length) > cmd->data_length) {
-		printk(KERN_ERR "Command ITT: 0x%08x, datain.offset: %u and"
+		pr_err("Command ITT: 0x%08x, datain.offset: %u and"
 			" datain.length: %u exceeds cmd->data_length: %u\n",
 			cmd->init_task_tag, datain.offset, datain.length,
 				cmd->data_length);
@@ -2550,7 +2548,7 @@ static int iscsit_send_data_in(
 		iov[0].iov_len += ISCSI_CRC_LEN;
 		tx_size += ISCSI_CRC_LEN;
 
-		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest"
+		pr_debug("Attaching CRC32 HeaderDigest"
 			" for DataIN PDU 0x%08x\n", *header_digest);
 	}
 
@@ -2567,7 +2565,7 @@ static int iscsit_send_data_in(
 		iov[iov_count++].iov_len	= cmd->padding;
 		tx_size += cmd->padding;
 
-		TRACE(TRACE_ISCSI, "Attaching %u padding bytes\n",
+		pr_debug("Attaching %u padding bytes\n",
 				cmd->padding);
 	}
 	if (conn->conn_ops->DataDigest) {
@@ -2578,14 +2576,14 @@ static int iscsit_send_data_in(
 		iov[iov_count++].iov_len = ISCSI_CRC_LEN;
 		tx_size += ISCSI_CRC_LEN;
 
-		TRACE(TRACE_DIGEST, "Attached CRC32C DataDigest %d bytes, crc"
+		pr_debug("Attached CRC32C DataDigest %d bytes, crc"
 			" 0x%08x\n", datain.length+cmd->padding, cmd->data_crc);
 	}
 
 	cmd->iov_data_count = iov_count;
 	cmd->tx_size = tx_size;
 
-	TRACE(TRACE_ISCSI, "Built DataIN ITT: 0x%08x, StatSN: 0x%08x,"
+	pr_debug("Built DataIN ITT: 0x%08x, StatSN: 0x%08x,"
 		" DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
 		cmd->init_task_tag, ntohl(hdr->statsn), ntohl(hdr->datasn),
 		ntohl(hdr->offset), datain.length, conn->cid);
@@ -2616,7 +2614,7 @@ static int iscsit_send_logout_response(
 	 */
 	switch (cmd->logout_reason) {
 	case ISCSI_LOGOUT_REASON_CLOSE_SESSION:
-		TRACE(TRACE_ISCSI, "iSCSI session logout successful, setting"
+		pr_debug("iSCSI session logout successful, setting"
 			" logout response to ISCSI_LOGOUT_SUCCESS.\n");
 		cmd->logout_response = ISCSI_LOGOUT_SUCCESS;
 		break;
@@ -2635,7 +2633,7 @@ static int iscsit_send_logout_response(
 		 * is stopped in iscsit_logout_post_handler_diffcid().
 		 */
 
-		TRACE(TRACE_ISCSI, "iSCSI CID: %hu logout on CID: %hu"
+		pr_debug("iSCSI CID: %hu logout on CID: %hu"
 			" successful.\n", cmd->logout_cid, conn->cid);
 		cmd->logout_response = ISCSI_LOGOUT_SUCCESS;
 		break;
@@ -2657,7 +2655,7 @@ static int iscsit_send_logout_response(
 		cr = iscsit_get_inactive_connection_recovery_entry(
 				conn->sess, cmd->logout_cid);
 		if (!cr) {
-			printk(KERN_ERR "Unable to locate CID: %hu for"
+			pr_err("Unable to locate CID: %hu for"
 			" REMOVECONNFORRECOVERY Logout Request.\n",
 				cmd->logout_cid);
 			cmd->logout_response = ISCSI_LOGOUT_CID_NOT_FOUND;
@@ -2666,13 +2664,13 @@ static int iscsit_send_logout_response(
 
 		iscsit_discard_cr_cmds_by_expstatsn(cr, cmd->exp_stat_sn);
 
-		TRACE(TRACE_ERL2, "iSCSI REMOVECONNFORRECOVERY logout"
+		pr_debug("iSCSI REMOVECONNFORRECOVERY logout"
 			" for recovery for CID: %hu on CID: %hu successful.\n",
 				cmd->logout_cid, conn->cid);
 		cmd->logout_response = ISCSI_LOGOUT_SUCCESS;
 		break;
 	default:
-		printk(KERN_ERR "Unknown cmd->logout_reason: 0x%02x\n",
+		pr_err("Unknown cmd->logout_reason: 0x%02x\n",
 				cmd->logout_reason);
 		return -1;
 	}
@@ -2704,13 +2702,13 @@ static int iscsit_send_logout_response(
 
 		iov[0].iov_len += ISCSI_CRC_LEN;
 		tx_size += ISCSI_CRC_LEN;
-		TRACE(TRACE_DIGEST, "Attaching CRC32C HeaderDigest to"
+		pr_debug("Attaching CRC32C HeaderDigest to"
 			" Logout Response 0x%08x\n", *header_digest);
 	}
 	cmd->iov_misc_count = niov;
 	cmd->tx_size = tx_size;
 
-	TRACE(TRACE_ISCSI, "Sending Logout Response ITT: 0x%08x StatSN:"
+	pr_debug("Sending Logout Response ITT: 0x%08x StatSN:"
 		" 0x%08x Response: 0x%02x CID: %hu on CID: %hu\n",
 		cmd->init_task_tag, cmd->stat_sn, hdr->response,
 		cmd->logout_cid, conn->cid);
@@ -2748,7 +2746,7 @@ static int iscsit_send_unsolicited_nopin(
 				0, NULL, (u8 *)header_digest);
 
 		tx_size += ISCSI_CRC_LEN;
-		TRACE(TRACE_DIGEST, "Attaching CRC32C HeaderDigest to"
+		pr_debug("Attaching CRC32C HeaderDigest to"
 			" NopIN 0x%08x\n", *header_digest);
 	}
 
@@ -2757,7 +2755,7 @@ static int iscsit_send_unsolicited_nopin(
 	cmd->iov_misc_count	= 1;
 	cmd->tx_size		= tx_size;
 
-	TRACE(TRACE_ISCSI, "Sending Unsolicited NOPIN TTT: 0x%08x StatSN:"
+	pr_debug("Sending Unsolicited NOPIN TTT: 0x%08x StatSN:"
 		" 0x%08x CID: %hu\n", hdr->ttt, cmd->stat_sn, conn->cid);
 
 	return 0;
@@ -2801,7 +2799,7 @@ static int iscsit_send_nopin_response(
 					
 		iov[0].iov_len += ISCSI_CRC_LEN;
 		tx_size += ISCSI_CRC_LEN;
-		TRACE(TRACE_DIGEST, "Attaching CRC32C HeaderDigest"
+		pr_debug("Attaching CRC32C HeaderDigest"
 			" to NopIn 0x%08x\n", *header_digest);
 	}
 
@@ -2814,7 +2812,7 @@ static int iscsit_send_nopin_response(
 		iov[niov++].iov_len	= cmd->buf_ptr_size;
 		tx_size += cmd->buf_ptr_size;
 
-		TRACE(TRACE_ISCSI, "Echoing back %u bytes of ping"
+		pr_debug("Echoing back %u bytes of ping"
 			" data.\n", cmd->buf_ptr_size);
 
 		padding = ((-cmd->buf_ptr_size) & 3);
@@ -2822,7 +2820,7 @@ static int iscsit_send_nopin_response(
 			iov[niov].iov_base = &cmd->pad_bytes;
 			iov[niov++].iov_len = padding;
 			tx_size += padding;
-			TRACE(TRACE_ISCSI, "Attaching %u additional"
+			pr_debug("Attaching %u additional"
 				" padding bytes.\n", padding);
 		}
 		if (conn->conn_ops->DataDigest) {
@@ -2834,7 +2832,7 @@ static int iscsit_send_nopin_response(
 			iov[niov].iov_base = &cmd->data_crc;
 			iov[niov++].iov_len = ISCSI_CRC_LEN;
 			tx_size += ISCSI_CRC_LEN;
-			TRACE(TRACE_DIGEST, "Attached DataDigest for %u"
+			pr_debug("Attached DataDigest for %u"
 				" bytes of ping data, CRC 0x%08x\n",
 				cmd->buf_ptr_size, cmd->data_crc);
 		}
@@ -2843,7 +2841,7 @@ static int iscsit_send_nopin_response(
 	cmd->iov_misc_count = niov;
 	cmd->tx_size = tx_size;
 
-	TRACE(TRACE_ISCSI, "Sending NOPIN Response ITT: 0x%08x, TTT:"
+	pr_debug("Sending NOPIN Response ITT: 0x%08x, TTT:"
 		" 0x%08x, StatSN: 0x%08x, Length %u\n", cmd->init_task_tag,
 		cmd->targ_xfer_tag, cmd->stat_sn, cmd->buf_ptr_size);
 
@@ -2855,7 +2853,6 @@ int iscsit_send_r2t(
 	struct iscsi_conn *conn)
 {
 	int tx_size = 0;
-	u32 trace_type;
 	struct iscsi_r2t *r2t;
 	struct iscsi_r2t_rsp *hdr;
 
@@ -2896,12 +2893,11 @@ int iscsit_send_r2t(
 
 		cmd->iov_misc[0].iov_len += ISCSI_CRC_LEN;
 		tx_size += ISCSI_CRC_LEN;
-		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for R2T"
+		pr_debug("Attaching CRC32 HeaderDigest for R2T"
 			" PDU 0x%08x\n", *header_digest);
 	}
 
-	trace_type = (!r2t->recovery_r2t) ? TRACE_ISCSI : TRACE_ERL1;
-	TRACE(trace_type, "Built %sR2T, ITT: 0x%08x, TTT: 0x%08x, StatSN:"
+	pr_debug("Built %sR2T, ITT: 0x%08x, TTT: 0x%08x, StatSN:"
 		" 0x%08x, R2TSN: 0x%08x, Offset: %u, DDTL: %u, CID: %hu\n",
 		(!r2t->recovery_r2t) ? "" : "Recovery ", cmd->init_task_tag,
 		r2t->targ_xfer_tag, ntohl(hdr->statsn), r2t->r2t_sn,
@@ -3000,7 +2996,7 @@ static int iscsit_send_status(
 	struct iscsi_conn *conn)
 {
 	u8 iov_count = 0, recovery;
-	u32 padding = 0, trace_type, tx_size = 0;
+	u32 padding = 0, tx_size = 0;
 	struct iscsi_scsi_rsp *hdr;
 	struct kvec *iov;
 
@@ -3054,7 +3050,7 @@ static int iscsit_send_status(
 			memset(SE_CMD(cmd)->sense_buffer +
 				SE_CMD(cmd)->scsi_sense_length, 0, padding);
 			tx_size += padding;
-			TRACE(TRACE_ISCSI, "Adding %u bytes of padding to"
+			pr_debug("Adding %u bytes of padding to"
 				" SENSE.\n", padding);
 		}
 
@@ -3068,13 +3064,13 @@ static int iscsit_send_status(
 			iov[iov_count++].iov_len     = ISCSI_CRC_LEN;
 			tx_size += ISCSI_CRC_LEN;
 
-			TRACE(TRACE_DIGEST, "Attaching CRC32 DataDigest for"
+			pr_debug("Attaching CRC32 DataDigest for"
 				" SENSE, %u bytes CRC 0x%08x\n",
 				(SE_CMD(cmd)->scsi_sense_length + padding),
 				cmd->data_crc);
 		}
 
-		TRACE(TRACE_ISCSI, "Attaching SENSE DATA: %u bytes to iSCSI"
+		pr_debug("Attaching SENSE DATA: %u bytes to iSCSI"
 				" Response PDU\n",
 				SE_CMD(cmd)->scsi_sense_length);
 	}
@@ -3088,15 +3084,14 @@ static int iscsit_send_status(
 
 		iov[0].iov_len += ISCSI_CRC_LEN;
 		tx_size += ISCSI_CRC_LEN;
-		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for Response"
+		pr_debug("Attaching CRC32 HeaderDigest for Response"
 				" PDU 0x%08x\n", *header_digest);
 	}
 
 	cmd->iov_misc_count = iov_count;
 	cmd->tx_size = tx_size;
 
-	trace_type = (!recovery) ? TRACE_ISCSI : TRACE_ERL1;
-	TRACE(trace_type, "Built %sSCSI Response, ITT: 0x%08x, StatSN: 0x%08x,"
+	pr_debug("Built %sSCSI Response, ITT: 0x%08x, StatSN: 0x%08x,"
 		" Response: 0x%02x, SAM Status: 0x%02x, CID: %hu\n",
 		(!recovery) ? "" : "Recovery ", cmd->init_task_tag,
 		cmd->stat_sn, 0x00, cmd->se_cmd.scsi_status, conn->cid);
@@ -3156,14 +3151,14 @@ static int iscsit_send_task_mgt_rsp(
 
 		cmd->iov_misc[0].iov_len += ISCSI_CRC_LEN;
 		tx_size += ISCSI_CRC_LEN;
-		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for Task"
+		pr_debug("Attaching CRC32 HeaderDigest for Task"
 			" Mgmt Response PDU 0x%08x\n", *header_digest);
 	}
 
 	cmd->iov_misc_count = 1;
 	cmd->tx_size = tx_size;
 
-	TRACE(TRACE_ERL2, "Built Task Management Response ITT: 0x%08x,"
+	pr_debug("Built Task Management Response ITT: 0x%08x,"
 		" StatSN: 0x%08x, Response: 0x%02x, CID: %hu\n",
 		cmd->init_task_tag, cmd->stat_sn, hdr->response, conn->cid);
 
@@ -3187,7 +3182,7 @@ static int iscsit_build_sendtargets_response(struct iscsi_cmd *cmd)
 
 	payload = kzalloc(buffer_len, GFP_KERNEL);
 	if (!payload) {
-		printk(KERN_ERR "Unable to allocate memory for sendtargets"
+		pr_err("Unable to allocate memory for sendtargets"
 				" response.\n");
 		return -ENOMEM;
 	}
@@ -3271,7 +3266,7 @@ static int iscsit_send_text_rsp(
 	padding = ((-text_length) & 3);
 	if (padding != 0) {
 		memset(cmd->buf_ptr + text_length, 0, padding);
-		TRACE(TRACE_ISCSI, "Attaching %u additional bytes for"
+		pr_debug("Attaching %u additional bytes for"
 			" padding.\n", padding);
 	}
 
@@ -3307,7 +3302,7 @@ static int iscsit_send_text_rsp(
 
 		iov[0].iov_len += ISCSI_CRC_LEN;
 		tx_size += ISCSI_CRC_LEN;
-		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for"
+		pr_debug("Attaching CRC32 HeaderDigest for"
 			" Text Response PDU 0x%08x\n", *header_digest);
 	}
 
@@ -3320,7 +3315,7 @@ static int iscsit_send_text_rsp(
 		iov[iov_count++].iov_len = ISCSI_CRC_LEN;
 		tx_size	+= ISCSI_CRC_LEN;
 
-		TRACE(TRACE_DIGEST, "Attaching DataDigest for %u bytes of text"
+		pr_debug("Attaching DataDigest for %u bytes of text"
 			" data, CRC 0x%08x\n", (text_length + padding),
 			cmd->data_crc);
 	}
@@ -3328,7 +3323,7 @@ static int iscsit_send_text_rsp(
 	cmd->iov_misc_count = iov_count;
 	cmd->tx_size = tx_size;
 
-	TRACE(TRACE_ISCSI, "Built Text Response: ITT: 0x%08x, StatSN: 0x%08x,"
+	pr_debug("Built Text Response: ITT: 0x%08x, StatSN: 0x%08x,"
 		" Length: %u, CID: %hu\n", cmd->init_task_tag, cmd->stat_sn,
 			text_length, conn->cid);
 	return 0;
@@ -3369,7 +3364,7 @@ static int iscsit_send_reject(
 
 		iov[0].iov_len += ISCSI_CRC_LEN;
 		tx_size += ISCSI_CRC_LEN;
-		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for"
+		pr_debug("Attaching CRC32 HeaderDigest for"
 			" REJECT PDU 0x%08x\n", *header_digest);
 	}
 
@@ -3381,14 +3376,14 @@ static int iscsit_send_reject(
 		iov[iov_count].iov_base = &cmd->data_crc;
 		iov[iov_count++].iov_len  = ISCSI_CRC_LEN;
 		tx_size += ISCSI_CRC_LEN;
-		TRACE(TRACE_DIGEST, "Attaching CRC32 DataDigest for REJECT"
+		pr_debug("Attaching CRC32 DataDigest for REJECT"
 				" PDU 0x%08x\n", cmd->data_crc);
 	}
 
 	cmd->iov_misc_count = iov_count;
 	cmd->tx_size = tx_size;
 
-	TRACE(TRACE_ISCSI, "Built Reject PDU StatSN: 0x%08x, Reason: 0x%02x,"
+	pr_debug("Built Reject PDU StatSN: 0x%08x, Reason: 0x%02x,"
 		" CID: %hu\n", ntohl(hdr->statsn), hdr->reason, conn->cid);
 
 	return 0;
@@ -3420,7 +3415,7 @@ void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
 	 */
 	ord = ts->thread_id % cpumask_weight(cpu_online_mask);
 #if 0
-	printk(KERN_INFO ">>>>>>>>>>>>>>>>>>>> Generated ord: %d from"
+	pr_debug(">>>>>>>>>>>>>>>>>>>> Generated ord: %d from"
 			" thread_id: %d\n", ord, ts->thread_id);
 #endif
 	for_each_online_cpu(cpu) {
@@ -3463,7 +3458,7 @@ static inline void iscsit_thread_check_cpumask(
 	memset(buf, 0, 128);
 	cpumask_scnprintf(buf, 128, conn->conn_cpumask);
 #if 0
-	printk(KERN_INFO ">>>>>>>>>>>>>> Calling set_cpus_allowed_ptr():"
+	pr_debug(">>>>>>>>>>>>>> Calling set_cpus_allowed_ptr():"
 			" %s for %s\n", buf, p->comm);
 #endif
 	set_cpus_allowed_ptr(p, conn->conn_cpumask);
@@ -3559,7 +3554,7 @@ get_immediate:
 						conn, 0);
 				break;
 			default:
-				printk(KERN_ERR "Unknown Opcode: 0x%02x ITT:"
+				pr_err("Unknown Opcode: 0x%02x ITT:"
 				" 0x%08x, i_state: %d on CID: %hu\n",
 				cmd->iscsi_opcode, cmd->init_task_tag, state,
 				conn->cid);
@@ -3594,7 +3589,7 @@ get_immediate:
 				spin_unlock_bh(&cmd->istate_lock);
 				break;
 			default:
-				printk(KERN_ERR "Unknown Opcode: 0x%02x ITT:"
+				pr_err("Unknown Opcode: 0x%02x ITT:"
 					" 0x%08x, i_state: %d on CID: %hu\n",
 					cmd->iscsi_opcode, cmd->init_task_tag,
 					state, conn->cid);
@@ -3664,7 +3659,7 @@ check_rsp_state:
 				ret = iscsit_send_text_rsp(cmd, conn);
 				break;
 			default:
-				printk(KERN_ERR "Unknown Opcode: 0x%02x ITT:"
+				pr_err("Unknown Opcode: 0x%02x ITT:"
 					" 0x%08x, i_state: %d on CID: %hu\n",
 					cmd->iscsi_opcode, cmd->init_task_tag,
 					state, conn->cid);
@@ -3748,7 +3743,7 @@ check_rsp_state:
 				sent_status = 1;
 				break;
 			default:
-				printk(KERN_ERR "Unknown Opcode: 0x%02x ITT:"
+				pr_err("Unknown Opcode: 0x%02x ITT:"
 					" 0x%08x, i_state: %d on CID: %hu\n",
 					cmd->iscsi_opcode, cmd->init_task_tag,
 					cmd->i_state, conn->cid);
@@ -3835,7 +3830,7 @@ restart:
 					0, NULL, (u8 *)&checksum);
 
 			if (digest != checksum) {
-				printk(KERN_ERR "HeaderDigest CRC32C failed,"
+				pr_err("HeaderDigest CRC32C failed,"
 					" received 0x%08x, computed 0x%08x\n",
 					digest, checksum);
 				/*
@@ -3847,7 +3842,7 @@ restart:
 				conn->sess->conn_digest_errors++;
 				spin_unlock_bh(&conn->sess->session_stats_lock);
 			} else {
-				TRACE(TRACE_DIGEST, "Got HeaderDigest CRC32C"
+				pr_debug("Got HeaderDigest CRC32C"
 						" 0x%08x\n", checksum);
 			}
 		}
@@ -3860,7 +3855,7 @@ restart:
 		if (conn->sess->sess_ops->SessionType &&
 		   ((!(opcode & ISCSI_OP_TEXT)) ||
 		    (!(opcode & ISCSI_OP_LOGOUT)))) {
-			printk(KERN_ERR "Received illegal iSCSI Opcode: 0x%02x"
+			pr_err("Received illegal iSCSI Opcode: 0x%02x"
 			" while in Discovery Session, rejecting.\n", opcode);
 			iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
 					buffer, conn);
@@ -3902,22 +3897,22 @@ restart:
 				goto transport_err;
 			break;
 		default:
-			printk(KERN_ERR "Got unknown iSCSI OpCode: 0x%02x\n",
+			pr_err("Got unknown iSCSI OpCode: 0x%02x\n",
 					opcode);
 			if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-				printk(KERN_ERR "Cannot recover from unknown"
+				pr_err("Cannot recover from unknown"
 				" opcode while ERL=0, closing iSCSI connection"
 				".\n");
 				goto transport_err;
 			}
 			if (!conn->conn_ops->OFMarker) {
-				printk(KERN_ERR "Unable to recover from unknown"
+				pr_err("Unable to recover from unknown"
 				" opcode while OFMarker=No, closing iSCSI"
 					" connection.\n");
 				goto transport_err;
 			}
 			if (iscsit_recover_from_unknown_opcode(conn) < 0) {
-				printk(KERN_ERR "Unable to recover from unknown"
+				pr_err("Unable to recover from unknown"
 					" opcode, closing iSCSI connection.\n");
 				goto transport_err;
 			}
@@ -4001,7 +3996,7 @@ int iscsit_close_connection(
 	int conn_logout = (conn->conn_state == TARG_CONN_STATE_IN_LOGOUT);
 	struct iscsi_session	*sess = conn->sess;
 
-	TRACE(TRACE_ISCSI, "Closing iSCSI connection CID %hu on SID:"
+	pr_debug("Closing iSCSI connection CID %hu on SID:"
 		" %u\n", conn->cid, sess->sid);
 	/*
 	 * Always up conn_logout_comp just in case the RX Thread is sleeping
@@ -4119,13 +4114,13 @@ int iscsit_close_connection(
 	}
 	conn->thread_set = NULL;
 
-	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_FREE.\n");
+	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
 	conn->conn_state = TARG_CONN_STATE_FREE;
 	kfree(conn);
 
 	spin_lock_bh(&sess->conn_lock);
 	atomic_dec(&sess->nconn);
-	printk(KERN_INFO "Decremented iSCSI connection count to %hu from node:"
+	pr_debug("Decremented iSCSI connection count to %hu from node:"
 		" %s\n", atomic_read(&sess->nconn),
 		sess->sess_ops->InitiatorName);
 	/*
@@ -4178,7 +4173,7 @@ int iscsit_close_connection(
 
 		return 0;
 	} else if (atomic_read(&sess->session_logout)) {
-		TRACE(TRACE_STATE, "Moving to TARG_SESS_STATE_FREE.\n");
+		pr_debug("Moving to TARG_SESS_STATE_FREE.\n");
 		sess->session_state = TARG_SESS_STATE_FREE;
 		spin_unlock_bh(&sess->conn_lock);
 
@@ -4187,7 +4182,7 @@ int iscsit_close_connection(
 
 		return 0;
 	} else {
-		TRACE(TRACE_STATE, "Moving to TARG_SESS_STATE_FAILED.\n");
+		pr_debug("Moving to TARG_SESS_STATE_FAILED.\n");
 		sess->session_state = TARG_SESS_STATE_FAILED;
 
 		if (!atomic_read(&sess->session_continuation)) {
@@ -4212,7 +4207,7 @@ int iscsit_close_session(struct iscsi_session *sess)
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 
 	if (atomic_read(&sess->nconn)) {
-		printk(KERN_ERR "%d connection(s) still exist for iSCSI session"
+		pr_err("%d connection(s) still exist for iSCSI session"
 			" to %s\n", atomic_read(&sess->nconn),
 			sess->sess_ops->InitiatorName);
 		BUG();
@@ -4258,15 +4253,15 @@ int iscsit_close_session(struct iscsi_session *sess)
 	iscsit_free_all_ooo_cmdsns(sess);
 
 	spin_lock_bh(&se_tpg->session_lock);
-	TRACE(TRACE_STATE, "Moving to TARG_SESS_STATE_FREE.\n");
+	pr_debug("Moving to TARG_SESS_STATE_FREE.\n");
 	sess->session_state = TARG_SESS_STATE_FREE;
-	printk(KERN_INFO "Released iSCSI session from node: %s\n",
+	pr_debug("Released iSCSI session from node: %s\n",
 			sess->sess_ops->InitiatorName);
 	tpg->nsessions--;
 	if (tpg->tpg_tiqn)
 		tpg->tpg_tiqn->tiqn_nsessions--;
 
-	printk(KERN_INFO "Decremented number of active iSCSI Sessions on"
+	pr_debug("Decremented number of active iSCSI Sessions on"
 		" iSCSI TPG: %hu to %u\n", tpg->tpgt, tpg->nsessions);
 
 	spin_lock(&sess_idr_lock);
@@ -4337,7 +4332,7 @@ static void iscsit_logout_post_handler_diffcid(
 		l_conn->sock->ops->shutdown(l_conn->sock, RCV_SHUTDOWN);
 
 	spin_lock_bh(&l_conn->state_lock);
-	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
+	pr_debug("Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
 	l_conn->conn_state = TARG_CONN_STATE_IN_LOGOUT;
 	spin_unlock_bh(&l_conn->state_lock);
 
@@ -4413,12 +4408,12 @@ void iscsit_fail_session(struct iscsi_session *sess)
 
 	spin_lock_bh(&sess->conn_lock);
 	list_for_each_entry(conn, &sess->sess_conn_list, conn_list) {
-		TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_CLEANUP_WAIT.\n");
+		pr_debug("Moving to TARG_CONN_STATE_CLEANUP_WAIT.\n");
 		conn->conn_state = TARG_CONN_STATE_CLEANUP_WAIT;
 	}
 	spin_unlock_bh(&sess->conn_lock);
 
-	TRACE(TRACE_STATE, "Moving to TARG_SESS_STATE_FAILED.\n");
+	pr_debug("Moving to TARG_SESS_STATE_FAILED.\n");
 	sess->session_state = TARG_SESS_STATE_FAILED;
 }
 
@@ -4548,7 +4543,7 @@ int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int force)
 	}
 	spin_unlock_bh(&se_tpg->session_lock);
 
-	TRACE(TRACE_ISCSI, "Released %d iSCSI Session(s) from Target Portal"
+	pr_debug("Released %d iSCSI Session(s) from Target Portal"
 			" Group: %hu\n", session_count, tpg->tpgt);
 	return 0;
 }
diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index a022c83..2fc8747 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -27,12 +27,6 @@
 #include "iscsi_target_nego.h"
 #include "iscsi_target_auth.h"
 
-#ifdef DEBUG_CHAP
-#define PRINT(x...)		printk(KERN_INFO x)
-#else
-#define PRINT(x...)
-#endif
-
 static unsigned char chap_asciihex_to_binaryhex(unsigned char val[2])
 {
 	unsigned char result = 0;
@@ -127,7 +121,7 @@ static void chap_gen_challenge(
 	*c_len += sprintf(c_str + *c_len, "CHAP_C=0x%s", challenge_asciihex);
 	*c_len += 1;
 
-	PRINT("[%s] Sending CHAP_C=0x%s\n\n", (caller) ? "server" : "client",
+	pr_debug("[%s] Sending CHAP_C=0x%s\n\n", (caller) ? "server" : "client",
 			challenge_asciihex);
 }
 
@@ -143,7 +137,7 @@ static struct iscsi_chap *chap_server_open(
 
 	if (!(auth->naf_flags & NAF_USERID_SET) ||
 	    !(auth->naf_flags & NAF_PASSWORD_SET)) {
-		printk(KERN_ERR "CHAP user or password not set for"
+		pr_err("CHAP user or password not set for"
 				" Initiator ACL\n");
 		return NULL;
 	}
@@ -157,24 +151,24 @@ static struct iscsi_chap *chap_server_open(
 	 * We only support MD5 MDA presently.
 	 */
 	if (strncmp(a_str, "CHAP_A=5", 8)) {
-		printk(KERN_ERR "CHAP_A is not MD5.\n");
+		pr_err("CHAP_A is not MD5.\n");
 		return NULL;
 	}
-	PRINT("[server] Got CHAP_A=5\n");
+	pr_debug("[server] Got CHAP_A=5\n");
 	/*
 	 * Send back CHAP_A set to MD5.
 	 */
 	*aic_len = sprintf(aic_str, "CHAP_A=5");
 	*aic_len += 1;
 	chap->digest_type = CHAP_DIGEST_MD5;
-	PRINT("[server] Sending CHAP_A=%d\n", chap->digest_type);
+	pr_debug("[server] Sending CHAP_A=%d\n", chap->digest_type);
 	/*
 	 * Set Identifier.
 	 */
 	chap->id = ISCSI_TPG_C(conn)->tpg_chap_id++;
 	*aic_len += sprintf(aic_str + *aic_len, "CHAP_I=%d", chap->id);
 	*aic_len += 1;
-	PRINT("[server] Sending CHAP_I=%d\n", chap->id);
+	pr_debug("[server] Sending CHAP_I=%d\n", chap->id);
 	/*
 	 * Generate Challenge.
 	 */
@@ -220,13 +214,13 @@ static int chap_server_compute_md5(
 
 	challenge = kzalloc(CHAP_CHALLENGE_STR_LEN, GFP_KERNEL);
 	if (!challenge) {
-		printk(KERN_ERR "Unable to allocate challenge buffer\n");
+		pr_err("Unable to allocate challenge buffer\n");
 		goto out;
 	}
 
 	challenge_binhex = kzalloc(CHAP_CHALLENGE_STR_LEN, GFP_KERNEL);
 	if (!challenge_binhex) {
-		printk(KERN_ERR "Unable to allocate challenge_binhex buffer\n");
+		pr_err("Unable to allocate challenge_binhex buffer\n");
 		goto out;
 	}
 	/*
@@ -234,38 +228,38 @@ static int chap_server_compute_md5(
 	 */
 	if (extract_param(nr_in_ptr, "CHAP_N", MAX_CHAP_N_SIZE, chap_n,
 				&type) < 0) {
-		printk(KERN_ERR "Could not find CHAP_N.\n");
+		pr_err("Could not find CHAP_N.\n");
 		goto out;
 	}
 	if (type == HEX) {
-		printk(KERN_ERR "Could not find CHAP_N.\n");
+		pr_err("Could not find CHAP_N.\n");
 		goto out;
 	}
 
 	if (memcmp(chap_n, auth->userid, strlen(auth->userid)) != 0) {
-		printk(KERN_ERR "CHAP_N values do not match!\n");
+		pr_err("CHAP_N values do not match!\n");
 		goto out;
 	}
-	PRINT("[server] Got CHAP_N=%s\n", chap_n);
+	pr_debug("[server] Got CHAP_N=%s\n", chap_n);
 	/*
 	 * Extract CHAP_R.
 	 */
 	if (extract_param(nr_in_ptr, "CHAP_R", MAX_RESPONSE_LENGTH, chap_r,
 				&type) < 0) {
-		printk(KERN_ERR "Could not find CHAP_R.\n");
+		pr_err("Could not find CHAP_R.\n");
 		goto out;
 	}
 	if (type != HEX) {
-		printk(KERN_ERR "Could not find CHAP_R.\n");
+		pr_err("Could not find CHAP_R.\n");
 		goto out;
 	}
 
-	PRINT("[server] Got CHAP_R=%s\n", chap_r);
+	pr_debug("[server] Got CHAP_R=%s\n", chap_r);
 	chap_string_to_hex(client_digest, chap_r, strlen(chap_r));
 
 	tfm = crypto_alloc_hash("md5", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "Unable to allocate struct crypto_hash\n");
+		pr_err("Unable to allocate struct crypto_hash\n");
 		goto out;
 	}
 	desc.tfm = tfm;
@@ -273,7 +267,7 @@ static int chap_server_compute_md5(
 
 	ret = crypto_hash_init(&desc);
 	if (ret < 0) {
-		printk(KERN_ERR "crypto_hash_init() failed\n");
+		pr_err("crypto_hash_init() failed\n");
 		crypto_free_hash(tfm);
 		goto out;
 	}
@@ -281,7 +275,7 @@ static int chap_server_compute_md5(
 	sg_init_one(&sg, (void *)&chap->id, 1);
 	ret = crypto_hash_update(&desc, &sg, 1);
 	if (ret < 0) {
-		printk(KERN_ERR "crypto_hash_update() failed for id\n");
+		pr_err("crypto_hash_update() failed for id\n");
 		crypto_free_hash(tfm);
 		goto out;
 	}
@@ -289,7 +283,7 @@ static int chap_server_compute_md5(
 	sg_init_one(&sg, (void *)&auth->password, strlen(auth->password));
 	ret = crypto_hash_update(&desc, &sg, strlen(auth->password));
 	if (ret < 0) {
-		printk(KERN_ERR "crypto_hash_update() failed for password\n");
+		pr_err("crypto_hash_update() failed for password\n");
 		crypto_free_hash(tfm);
 		goto out;
 	}
@@ -297,27 +291,27 @@ static int chap_server_compute_md5(
 	sg_init_one(&sg, (void *)chap->challenge, CHAP_CHALLENGE_LENGTH);
 	ret = crypto_hash_update(&desc, &sg, CHAP_CHALLENGE_LENGTH);
 	if (ret < 0) {
-		printk(KERN_ERR "crypto_hash_update() failed for challenge\n");
+		pr_err("crypto_hash_update() failed for challenge\n");
 		crypto_free_hash(tfm);
 		goto out;
 	}
 
 	ret = crypto_hash_final(&desc, server_digest);
 	if (ret < 0) {
-		printk(KERN_ERR "crypto_hash_final() failed for server digest\n");
+		pr_err("crypto_hash_final() failed for server digest\n");
 		crypto_free_hash(tfm);
 		goto out;
 	}
 	crypto_free_hash(tfm);
 
 	chap_binaryhex_to_asciihex(response, server_digest, MD5_SIGNATURE_SIZE);
-	PRINT("[server] MD5 Server Digest: %s\n", response);
+	pr_debug("[server] MD5 Server Digest: %s\n", response);
 
 	if (memcmp(server_digest, client_digest, MD5_SIGNATURE_SIZE) != 0) {
-		PRINT("[server] MD5 Digests do not match!\n\n");
+		pr_debug("[server] MD5 Digests do not match!\n\n");
 		goto out;
 	} else
-		PRINT("[server] MD5 Digests match, CHAP connetication"
+		pr_debug("[server] MD5 Digests match, CHAP connetication"
 				" successful.\n\n");
 	/*
 	 * One way authentication has succeeded, return now if mutual
@@ -332,7 +326,7 @@ static int chap_server_compute_md5(
 	 * Get CHAP_I.
 	 */
 	if (extract_param(nr_in_ptr, "CHAP_I", 10, identifier, &type) < 0) {
-		printk(KERN_ERR "Could not find CHAP_I.\n");
+		pr_err("Could not find CHAP_I.\n");
 		goto out;
 	}
 
@@ -344,25 +338,25 @@ static int chap_server_compute_md5(
 	/*
 	 * RFC 1994 says Identifier is no more than octet (8 bits).
 	 */
-	PRINT("[server] Got CHAP_I=%d\n", id);
+	pr_debug("[server] Got CHAP_I=%d\n", id);
 	/*
 	 * Get CHAP_C.
 	 */
 	if (extract_param(nr_in_ptr, "CHAP_C", CHAP_CHALLENGE_STR_LEN,
 			challenge, &type) < 0) {
-		printk(KERN_ERR "Could not find CHAP_C.\n");
+		pr_err("Could not find CHAP_C.\n");
 		goto out;
 	}
 
 	if (type != HEX) {
-		printk(KERN_ERR "Could not find CHAP_C.\n");
+		pr_err("Could not find CHAP_C.\n");
 		goto out;
 	}
-	PRINT("[server] Got CHAP_C=%s\n", challenge);
+	pr_debug("[server] Got CHAP_C=%s\n", challenge);
 	challenge_len = chap_string_to_hex(challenge_binhex, challenge,
 				strlen(challenge));
 	if (!challenge_len) {
-		printk(KERN_ERR "Unable to convert incoming challenge\n");
+		pr_err("Unable to convert incoming challenge\n");
 		goto out;
 	}
 	/*
@@ -370,7 +364,7 @@ static int chap_server_compute_md5(
 	 */
 	tfm = crypto_alloc_hash("md5", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "Unable to allocate struct crypto_hash\n");
+		pr_err("Unable to allocate struct crypto_hash\n");
 		goto out;
 	}
 	desc.tfm = tfm;
@@ -378,7 +372,7 @@ static int chap_server_compute_md5(
 
 	ret = crypto_hash_init(&desc);
 	if (ret < 0) {
-		printk(KERN_ERR "crypto_hash_init() failed\n");
+		pr_err("crypto_hash_init() failed\n");
 		crypto_free_hash(tfm);
 		goto out;
 	}
@@ -386,7 +380,7 @@ static int chap_server_compute_md5(
 	sg_init_one(&sg, (void *)&id, 1);
 	ret = crypto_hash_update(&desc, &sg, 1);
 	if (ret < 0) {
-		printk(KERN_ERR "crypto_hash_update() failed for id\n");
+		pr_err("crypto_hash_update() failed for id\n");
 		crypto_free_hash(tfm);
 		goto out;
 	}
@@ -395,7 +389,7 @@ static int chap_server_compute_md5(
 				strlen(auth->password_mutual));
 	ret = crypto_hash_update(&desc, &sg, strlen(auth->password_mutual));
 	if (ret < 0) {
-		printk(KERN_ERR "crypto_hash_update() failed for"
+		pr_err("crypto_hash_update() failed for"
 				" password_mutual\n");
 		crypto_free_hash(tfm);
 		goto out;
@@ -406,14 +400,14 @@ static int chap_server_compute_md5(
 	sg_init_one(&sg, (void *)challenge_binhex, challenge_len);
 	ret = crypto_hash_update(&desc, &sg, challenge_len);
 	if (ret < 0) {
-		printk(KERN_ERR "crypto_hash_update() failed for ma challenge\n");
+		pr_err("crypto_hash_update() failed for ma challenge\n");
 		crypto_free_hash(tfm);
 		goto out;
 	}
 
 	ret = crypto_hash_final(&desc, digest);
 	if (ret < 0) {
-		printk(KERN_ERR "crypto_hash_final() failed for ma digest\n");
+		pr_err("crypto_hash_final() failed for ma digest\n");
 		crypto_free_hash(tfm);
 		goto out;
 	}
@@ -423,7 +417,7 @@ static int chap_server_compute_md5(
 	 */
 	*nr_out_len = sprintf(nr_out_ptr, "CHAP_N=%s", auth->userid_mutual);
 	*nr_out_len += 1;
-	PRINT("[server] Sending CHAP_N=%s\n", auth->userid_mutual);
+	pr_debug("[server] Sending CHAP_N=%s\n", auth->userid_mutual);
 	/*
 	 * Convert response from binary hex to ascii hext.
 	 */
@@ -431,7 +425,7 @@ static int chap_server_compute_md5(
 	*nr_out_len += sprintf(nr_out_ptr + *nr_out_len, "CHAP_R=0x%s",
 			response);
 	*nr_out_len += 1;
-	PRINT("[server] Sending CHAP_R=0x%s\n", response);
+	pr_debug("[server] Sending CHAP_R=0x%s\n", response);
 	auth_ret = 0;
 out:
 	kfree(challenge);
@@ -455,7 +449,7 @@ static int chap_got_response(
 			return -1;
 		return 0;
 	default:
-		printk(KERN_ERR "Unknown CHAP digest type %d!\n",
+		pr_err("Unknown CHAP digest type %d!\n",
 				chap->digest_type);
 		return -1;
 	}
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index fe2799c..5599747 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -60,7 +60,7 @@ struct iscsi_portal_group *lio_get_tpg_from_tpg_item(
 	int ret;
 
 	if (!tpg) {
-		printk(KERN_ERR "Unable to locate struct iscsi_portal_group "
+		pr_err("Unable to locate struct iscsi_portal_group "
 			"pointer\n");
 		return NULL;
 	}
@@ -108,12 +108,12 @@ static ssize_t lio_target_np_store_sctp(
 
 	op = simple_strtoul(page, &endptr, 0);
 	if ((op != 1) && (op != 0)) {
-		printk(KERN_ERR "Illegal value for tpg_enable: %u\n", op);
+		pr_err("Illegal value for tpg_enable: %u\n", op);
 		return -EINVAL;
 	}
 	np = tpg_np->tpg_np;
 	if (!np) {
-		printk(KERN_ERR "Unable to locate struct iscsi_np from"
+		pr_err("Unable to locate struct iscsi_np from"
 				" struct iscsi_tpg_np\n");
 		return -EINVAL;
 	}
@@ -176,7 +176,7 @@ struct se_tpg_np *lio_target_call_addnptotpg(
 	char buf[MAX_PORTAL_LEN + 1];
 
 	if (strlen(name) > MAX_PORTAL_LEN) {
-		printk(KERN_ERR "strlen(name): %d exceeds MAX_PORTAL_LEN: %d\n",
+		pr_err("strlen(name): %d exceeds MAX_PORTAL_LEN: %d\n",
 			(int)strlen(name), MAX_PORTAL_LEN);
 		return ERR_PTR(-EOVERFLOW);
 	}
@@ -191,7 +191,7 @@ struct se_tpg_np *lio_target_call_addnptotpg(
 
 		str2 = strstr(str, "]");
 		if (!str2) {
-			printk(KERN_ERR "Unable to locate trailing \"]\""
+			pr_err("Unable to locate trailing \"]\""
 				" in IPv6 iSCSI network portal address\n");
 			return ERR_PTR(-EINVAL);
 		}
@@ -200,7 +200,7 @@ struct se_tpg_np *lio_target_call_addnptotpg(
 		str2++; /* Skip over the "]" */
 		port_str = strstr(str2, ":");
 		if (!port_str) {
-			printk(KERN_ERR "Unable to locate \":port\""
+			pr_err("Unable to locate \":port\""
 				" in IPv6 iSCSI network portal address\n");
 			return ERR_PTR(-EINVAL);
 		}
@@ -209,7 +209,7 @@ struct se_tpg_np *lio_target_call_addnptotpg(
 
 		ret = strict_strtoul(port_str, 0, &port);
 		if (ret < 0) {
-			printk("strict_strtoul() failed for port_str: %d\n", ret);
+			pr_err("strict_strtoul() failed for port_str: %d\n", ret);
 			return ERR_PTR(ret);
 		}
 		sock_in6 = (struct sockaddr_in6 *)&sockaddr;
@@ -218,14 +218,14 @@ struct se_tpg_np *lio_target_call_addnptotpg(
 		ret = in6_pton(str, IPV6_ADDRESS_SPACE,
 				(void *)&sock_in6->sin6_addr.in6_u, -1, &end);	
 		if (ret <= 0) {
-			printk(KERN_ERR "in6_pton returned: %d\n", ret);
+			pr_err("in6_pton returned: %d\n", ret);
 			return ERR_PTR(-EINVAL);
 		}
 	} else {
 		str = ip_str = &buf[0];
 		port_str = strstr(ip_str, ":");
 		if (!port_str) {
-			printk(KERN_ERR "Unable to locate \":port\""
+			pr_err("Unable to locate \":port\""
 				" in IPv4 iSCSI network portal address\n");
 			return ERR_PTR(-EINVAL);
 		}
@@ -234,7 +234,7 @@ struct se_tpg_np *lio_target_call_addnptotpg(
 
 		ret = strict_strtoul(port_str, 0, &port);
 		if (ret < 0) {
-			printk("strict_strtoul() failed for port_str: %d\n", ret);
+			pr_err("strict_strtoul() failed for port_str: %d\n", ret);
 			return ERR_PTR(ret);
 		}
 		sock_in = (struct sockaddr_in *)&sockaddr;
@@ -247,7 +247,7 @@ struct se_tpg_np *lio_target_call_addnptotpg(
 	if (ret < 0)
 		return ERR_PTR(-EINVAL);
 
-	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> %s TPGT: %hu"
+	pr_debug("LIO_Target_ConfigFS: REGISTER -> %s TPGT: %hu"
 		" PORTAL: %s\n",
 		config_item_name(&se_tpg->se_tpg_wwn->wwn_group.cg_item),
 		tpg->tpgt, name);
@@ -270,7 +270,7 @@ struct se_tpg_np *lio_target_call_addnptotpg(
 		iscsit_put_tpg(tpg);
 		return ERR_PTR(PTR_ERR(tpg_np));
 	}
-	printk(KERN_INFO "LIO_Target_ConfigFS: addnptotpg done!\n");
+	pr_debug("LIO_Target_ConfigFS: addnptotpg done!\n");
 
 	iscsit_put_tpg(tpg);
 	return &tpg_np->se_tpg_np;
@@ -291,7 +291,7 @@ static void lio_target_call_delnpfromtpg(
 		return;
 
 	se_tpg = &tpg->tpg_se_tpg;
-	printk(KERN_INFO "LIO_Target_ConfigFS: DEREGISTER -> %s TPGT: %hu"
+	pr_debug("LIO_Target_ConfigFS: DEREGISTER -> %s TPGT: %hu"
 		" PORTAL: %s:%hu\n", config_item_name(&se_tpg->se_tpg_wwn->wwn_group.cg_item),
 		tpg->tpgt, tpg_np->tpg_np->np_ip, tpg_np->tpg_np->np_port);
 
@@ -299,7 +299,7 @@ static void lio_target_call_delnpfromtpg(
 	if (ret < 0)
 		goto out;
 
-	printk(KERN_INFO "LIO_Target_ConfigFS: delnpfromtpg done!\n");
+	pr_debug("LIO_Target_ConfigFS: delnpfromtpg done!\n");
 out:
 	iscsit_put_tpg(tpg);
 }
@@ -739,24 +739,24 @@ static ssize_t lio_target_nacl_store_cmdsn_depth(
 
 	cmdsn_depth = simple_strtoul(page, &endptr, 0);
 	if (cmdsn_depth > TA_DEFAULT_CMDSN_DEPTH_MAX) {
-		printk(KERN_ERR "Passed cmdsn_depth: %u exceeds"
+		pr_err("Passed cmdsn_depth: %u exceeds"
 			" TA_DEFAULT_CMDSN_DEPTH_MAX: %u\n", cmdsn_depth,
 			TA_DEFAULT_CMDSN_DEPTH_MAX);
 		return -EINVAL;
 	}
 	acl_ci = &se_nacl->acl_group.cg_item;
 	if (!acl_ci) {
-		printk(KERN_ERR "Unable to locatel acl_ci\n");
+		pr_err("Unable to locatel acl_ci\n");
 		return -EINVAL;
 	}
 	tpg_ci = &acl_ci->ci_parent->ci_group->cg_item;
 	if (!tpg_ci) {
-		printk(KERN_ERR "Unable to locate tpg_ci\n");
+		pr_err("Unable to locate tpg_ci\n");
 		return -EINVAL;
 	}
 	wwn_ci = &tpg_ci->ci_group->cg_item;
 	if (!wwn_ci) {
-		printk(KERN_ERR "Unable to locate config_item wwn_ci\n");
+		pr_err("Unable to locate config_item wwn_ci\n");
 		return -EINVAL;
 	}
 
@@ -768,7 +768,7 @@ static ssize_t lio_target_nacl_store_cmdsn_depth(
 	ret = iscsit_tpg_set_initiator_node_queue_depth(tpg,
 				config_item_name(acl_ci), cmdsn_depth, 1);
 
-	printk(KERN_INFO "LIO_Target_ConfigFS: %s/%s Set CmdSN Window: %u for"
+	pr_debug("LIO_Target_ConfigFS: %s/%s Set CmdSN Window: %u for"
 		"InitiatorName: %s\n", config_item_name(wwn_ci),
 		config_item_name(tpg_ci), cmdsn_depth,
 		config_item_name(acl_ci));
@@ -792,7 +792,7 @@ static struct se_node_acl *lio_tpg_alloc_fabric_acl(
 
 	acl = kzalloc(sizeof(struct iscsi_node_acl), GFP_KERNEL);
 	if (!acl) {
-		printk(KERN_ERR "Unable to allocate memory for struct iscsi_node_acl\n");
+		pr_err("Unable to allocate memory for struct iscsi_node_acl\n");
 		return NULL;
 	}
 
@@ -833,7 +833,7 @@ static struct se_node_acl *lio_target_make_nodeacl(
 	stats_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 				GFP_KERNEL);
 	if (!stats_cg->default_groups) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 				" stats_cg->default_groups\n");
 		core_tpg_del_initiator_node_acl(se_tpg, se_nacl, 1);
 		kfree(acl);
@@ -1154,7 +1154,7 @@ static ssize_t lio_target_tpg_store_enable(
 
 	op = simple_strtoul(page, &endptr, 0);
 	if ((op != 1) && (op != 0)) {
-		printk(KERN_ERR "Illegal value for tpg_enable: %u\n", op);
+		pr_err("Illegal value for tpg_enable: %u\n", op);
 		return -EINVAL;
 	}
 
@@ -1211,7 +1211,7 @@ struct se_portal_group *lio_target_tiqn_addtpg(
 	*/
 	tpgt_str = strstr(name, "tpgt_");
 	if (!tpgt_str) {
-		printk(KERN_ERR "Unable to locate \"tpgt_#\" directory"
+		pr_err("Unable to locate \"tpgt_#\" directory"
 				" group\n");
 		return NULL;
 	}
@@ -1233,8 +1233,8 @@ struct se_portal_group *lio_target_tiqn_addtpg(
 	if (ret != 0)
 		goto out;
 
-	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn);
-	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> Allocated TPG: %s\n",
+	pr_debug("LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn);
+	pr_debug("LIO_Target_ConfigFS: REGISTER -> Allocated TPG: %s\n",
 			name);
 	return &tpg->tpg_se_tpg;
 out:
@@ -1253,7 +1253,7 @@ void lio_target_tiqn_deltpg(struct se_portal_group *se_tpg)
 	/*
 	 * iscsit_tpg_del_portal_group() assumes force=1
 	 */
-	printk(KERN_INFO "LIO_Target_ConfigFS: DEREGISTER -> Releasing TPG\n");
+	pr_debug("LIO_Target_ConfigFS: DEREGISTER -> Releasing TPG\n");
 	iscsit_tpg_del_portal_group(tiqn, tpg, 1);
 }
 
@@ -1294,7 +1294,7 @@ struct se_wwn *lio_target_call_coreaddtiqn(
 	stats_cg->default_groups = kzalloc(sizeof(struct config_group) * 6,
 				GFP_KERNEL);
 	if (!stats_cg->default_groups) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 				" stats_cg->default_groups\n");
 		iscsit_del_tiqn(tiqn);
 		return ERR_PTR(-ENOMEM);
@@ -1317,8 +1317,8 @@ struct se_wwn *lio_target_call_coreaddtiqn(
 	config_group_init_type_name(&WWN_STAT_GRPS(tiqn)->iscsi_logout_stats_group,
 			"iscsi_logout_stats", &iscsi_stat_logout_cit);
 
-	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn);
-	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> Allocated Node:"
+	pr_debug("LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn);
+	pr_debug("LIO_Target_ConfigFS: REGISTER -> Allocated Node:"
 			" %s\n", name);
 	return &tiqn->tiqn_wwn;
 }
@@ -1339,7 +1339,7 @@ void lio_target_call_coredeltiqn(
 	}
 	kfree(stats_cg->default_groups);
 
-	printk(KERN_INFO "LIO_Target_ConfigFS: DEREGISTER -> %s\n",
+	pr_debug("LIO_Target_ConfigFS: DEREGISTER -> %s\n",
 			tiqn->tiqn);
 	iscsit_del_tiqn(tiqn);
 }
@@ -1429,13 +1429,13 @@ static ssize_t iscsi_disc_store_enforce_discovery_auth(
 
 	op = simple_strtoul(page, &endptr, 0);
 	if ((op != 1) && (op != 0)) {
-		printk(KERN_ERR "Illegal value for enforce_discovery_auth:"
+		pr_err("Illegal value for enforce_discovery_auth:"
 				" %u\n", op);
 		return -EINVAL;
 	}
 
 	if (!discovery_tpg) {
-		printk(KERN_ERR "iscsit_global->discovery_tpg is NULL\n");
+		pr_err("iscsit_global->discovery_tpg is NULL\n");
 		return -EINVAL;
 	}
 
@@ -1453,7 +1453,7 @@ static ssize_t iscsi_disc_store_enforce_discovery_auth(
 
 		discovery_tpg->tpg_attrib.authentication = 1;
 		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth = 1;
-		printk(KERN_INFO "LIO-CORE[0] Successfully enabled"
+		pr_debug("LIO-CORE[0] Successfully enabled"
 			" authentication enforcement for iSCSI"
 			" Discovery TPG\n");
 	} else {
@@ -1465,7 +1465,7 @@ static ssize_t iscsi_disc_store_enforce_discovery_auth(
 
 		discovery_tpg->tpg_attrib.authentication = 0;
 		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth = 0;
-		printk(KERN_INFO "LIO-CORE[0] Successfully disabled"
+		pr_debug("LIO-CORE[0] Successfully disabled"
 			" authentication enforcement for iSCSI"
 			" Discovery TPG\n");
 	}
@@ -1775,7 +1775,7 @@ int iscsi_target_register_configfs(void)
 	lio_target_fabric_configfs = NULL;
 	fabric = target_fabric_configfs_init(THIS_MODULE, "iscsi");
 	if (IS_ERR(fabric)) {
-		printk(KERN_ERR "target_fabric_configfs_init() for"
+		pr_err("target_fabric_configfs_init() for"
 				" LIO-Target failed!\n");
 		return PTR_ERR(fabric);
 	}
@@ -1852,14 +1852,14 @@ int iscsi_target_register_configfs(void)
 
 	ret = target_fabric_configfs_register(fabric);
 	if (ret < 0) {
-		printk(KERN_ERR "target_fabric_configfs_register() for"
+		pr_err("target_fabric_configfs_register() for"
 				" LIO-Target failed!\n");
 		target_fabric_configfs_free(fabric);
 		return ret;
 	}
 
 	lio_target_fabric_configfs = fabric;
-	printk(KERN_INFO "LIO_TARGET[0] - Set fabric ->"
+	pr_debug("LIO_TARGET[0] - Set fabric ->"
 			" lio_target_fabric_configfs\n");
 	return 0;
 }
@@ -1877,6 +1877,6 @@ void iscsi_target_deregister_configfs(void)
 
 	target_fabric_configfs_deregister(lio_target_fabric_configfs);
 	lio_target_fabric_configfs = NULL;
-	printk(KERN_INFO "LIO_TARGET[0] - Cleared"
+	pr_debug("LIO_TARGET[0] - Cleared"
 				" lio_target_fabric_configfs\n");
 }
diff --git a/drivers/target/iscsi/iscsi_target_datain_values.c b/drivers/target/iscsi/iscsi_target_datain_values.c
index 92a134b..97b459f 100644
--- a/drivers/target/iscsi/iscsi_target_datain_values.c
+++ b/drivers/target/iscsi/iscsi_target_datain_values.c
@@ -20,7 +20,6 @@
 
 #include <scsi/iscsi_proto.h>
 
-#include "iscsi_target_debug.h"
 #include "iscsi_target_core.h"
 #include "iscsi_target_seq_pdu_list.h"
 #include "iscsi_target_erl1.h"
@@ -34,7 +33,7 @@ struct iscsi_datain_req *iscsit_allocate_datain_req(void)
 
 	dr = kmem_cache_zalloc(lio_dr_cache, GFP_ATOMIC);
 	if (!dr) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 				" struct iscsi_datain_req\n");
 		return NULL;
 	}
@@ -76,7 +75,7 @@ struct iscsi_datain_req *iscsit_get_datain_req(struct iscsi_cmd *cmd)
 	struct iscsi_datain_req *dr;
 
 	if (list_empty(&cmd->datain_list)) {
-		printk(KERN_ERR "cmd->datain_list is empty for ITT:"
+		pr_err("cmd->datain_list is empty for ITT:"
 			" 0x%08x\n", cmd->init_task_tag);
 		return NULL;
 	}
@@ -116,7 +115,7 @@ static struct iscsi_datain_req *iscsit_set_datain_values_yes_and_yes(
 
 	read_data_left = (cmd->data_length - read_data_done);
 	if (!read_data_left) {
-		printk(KERN_ERR "ITT: 0x%08x read_data_left is zero!\n",
+		pr_err("ITT: 0x%08x read_data_left is zero!\n",
 				cmd->init_task_tag);
 		return NULL;
 	}
@@ -215,7 +214,7 @@ static struct iscsi_datain_req *iscsit_set_datain_values_no_and_yes(
 
 	read_data_left = (cmd->data_length - read_data_done);
 	if (!read_data_left) {
-		printk(KERN_ERR "ITT: 0x%08x read_data_left is zero!\n",
+		pr_err("ITT: 0x%08x read_data_left is zero!\n",
 				cmd->init_task_tag);
 		return NULL;
 	}
@@ -336,7 +335,7 @@ static struct iscsi_datain_req *iscsit_set_datain_values_yes_and_no(
 
 	read_data_left = (cmd->data_length - read_data_done);
 	if (!read_data_left) {
-		printk(KERN_ERR "ITT: 0x%08x read_data_left is zero!\n",
+		pr_err("ITT: 0x%08x read_data_left is zero!\n",
 				cmd->init_task_tag);
 		return dr;
 	}
@@ -436,7 +435,7 @@ static struct iscsi_datain_req *iscsit_set_datain_values_no_and_no(
 
 	read_data_left = (cmd->data_length - read_data_done);
 	if (!read_data_left) {
-		printk(KERN_ERR "ITT: 0x%08x read_data_left is zero!\n",
+		pr_err("ITT: 0x%08x read_data_left is zero!\n",
 				cmd->init_task_tag);
 		return NULL;
 	}
diff --git a/drivers/target/iscsi/iscsi_target_debug.h b/drivers/target/iscsi/iscsi_target_debug.h
deleted file mode 100644
index 1356146..0000000
--- a/drivers/target/iscsi/iscsi_target_debug.h
+++ /dev/null
@@ -1,113 +0,0 @@
-#ifndef ISCSI_DEBUG_H
-#define ISCSI_DEBUG_H
-
-/*
- * Debugging Support
- */
-
-#define TRACE_DEBUG	0x00000001	/* Verbose debugging */
-#define TRACE_SCSI	0x00000002	/* Stuff related to SCSI Mid-layer */
-#define TRACE_ISCSI	0x00000004	/* Stuff related to iSCSI */
-#define TRACE_NET	0x00000008	/* Stuff related to network code */
-#define TRACE_BUFF	0x00000010	/* For dumping raw data */
-#define TRACE_FILE	0x00000020	/* Used for __FILE__ */
-#define TRACE_LINE	0x00000040	/* Used for __LINE__ */
-#define TRACE_FUNCTION	0x00000080	/* Used for __FUNCTION__ */
-#define TRACE_SEM	0x00000100	/* Stuff related to semaphores */
-#define TRACE_ENTER_LEAVE 0x00000200	/* For entering/leaving functions */
-#define TRACE_DIGEST	0x00000400	/* For Header/Data Digests */
-#define TRACE_PARAM	0x00000800	/* For parameters in parameters.c */
-#define TRACE_LOGIN	0x00001000	/* For login related code */
-#define TRACE_STATE	0x00002000	/* For conn/sess/cleanup states */
-#define TRACE_ERL0	0x00004000	/* For ErrorRecoveryLevel=0 */
-#define TRACE_ERL1	0x00008000	/* For ErrorRecoveryLevel=1 */
-#define TRACE_ERL2	0x00010000	/* For ErrorRecoveryLevel=2 */
-#define TRACE_TIMER	0x00020000	/* For various ERL timers */
-#define TRACE_R2T	0x00040000	/* For R2T callers */
-#define TRACE_SPINDLE	0x00080000	/* For Spindle callers */
-#define TRACE_SSLR	0x00100000	/* For SyncNSteering RX */
-#define TRACE_SSLT	0x00200000	/* For SyncNSteering TX */
-#define TRACE_CHANNEL	0x00400000	/* For SCSI Channels */
-#define TRACE_CMDSN	0x00800000	/* For Out of Order CmdSN execution */
-#define TRACE_NODEATTRIB 0x01000000	/* For Initiator Nodes */
-
-#define TRACE_VANITY		0x80000000	/* For all Vanity Noise */
-#define TRACE_ALL		0xffffffff	/* Turn on all flags */
-#define TRACE_ENDING		0x00000000	/* foo */
-
-#ifdef CONFIG_ISCSI_TARGET_DEBUG
-/*
- * TRACE_VANITY, is always last!
- */
-static unsigned int iscsi_trace =
-/*		TRACE_DEBUG | */
-/*		TRACE_SCSI | */
-/*		TRACE_ISCSI | */
-/*		TRACE_NET | */
-/*		TRACE_BUFF | */
-/*		TRACE_FILE | */
-/*		TRACE_LINE | */
-/*		TRACE_FUNCTION | */
-/*		TRACE_SEM | */
-
-/*		TRACE_DIGEST | */
-/*		TRACE_PARAM | */
-/*		TRACE_LOGIN | */
-/*		TRACE_STATE | */
-		TRACE_ERL0 |
-		TRACE_ERL1 |
-		TRACE_ERL2 |
-/*		TRACE_TIMER | */
-/*		TRACE_R2T | */
-/*		TRACE_SPINDLE | */
-/*		TRACE_SSLR | */
-/*		TRACE_SSLT | */
-/*		TRACE_CHANNEL | */
-/*		TRACE_CMDSN | */
-/*		TRACE_NODEATTRIB | */
-		TRACE_VANITY |
-		TRACE_ENDING;
-
-#define TRACE(trace, args...)					\
-{								\
-static char iscsi_trace_buff[256];				\
-								\
-if (iscsi_trace & trace) {					\
-	sprintf(iscsi_trace_buff, args);			\
-	if (iscsi_trace & TRACE_FUNCTION) {			\
-		printk(KERN_INFO "%s:%d: %s",  __func__, __LINE__, \
-			iscsi_trace_buff);			\
-	} else if (iscsi_trace&TRACE_FILE) {			\
-		printk(KERN_INFO "%s::%d: %s", __FILE__, __LINE__, \
-			iscsi_trace_buff);			\
-	} else if (iscsi_trace & TRACE_LINE) {			\
-		printk(KERN_INFO "%d: %s", __LINE__, iscsi_trace_buff);	\
-	} else {						\
-		printk(KERN_INFO "%s", iscsi_trace_buff);	\
-	}							\
-}								\
-}
-
-#define PRINT_BUFF(buff, len)					\
-if (iscsi_trace & TRACE_BUFF) {					\
-	int zzz;						\
-								\
-	printk(KERN_INFO "%d:\n", __LINE__);			\
-	for (zzz = 0; zzz < len; zzz++) {			\
-		if (zzz % 16 == 0) {				\
-			if (zzz)				\
-				printk(KERN_INFO "\n");		\
-			printk(KERN_INFO "%4i: ", zzz);		\
-		}						\
-		printk(KERN_INFO "%02x ", (unsigned char) (buff)[zzz]);	\
-	}							\
-	if ((len + 1) % 16)					\
-		printk(KERN_INFO "\n");				\
-}
-
-#else /* !CONFIG_ISCSI_TARGET_DEBUG */
-#define TRACE(trace, args...)
-#define PRINT_BUFF(buff, len)
-#endif /* CONFIG_ISCSI_TARGET_DEBUG */
-
-#endif   /*** ISCSI_DEBUG_H ***/
diff --git a/drivers/target/iscsi/iscsi_target_device.c b/drivers/target/iscsi/iscsi_target_device.c
index b855c68..40975df 100644
--- a/drivers/target/iscsi/iscsi_target_device.c
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -24,7 +24,6 @@
 #include <target/target_core_device.h>
 #include <target/target_core_transport.h>
 
-#include "iscsi_target_debug.h"
 #include "iscsi_target_core.h"
 #include "iscsi_target_device.h"
 #include "iscsi_target_tpg.h"
@@ -83,6 +82,6 @@ void iscsit_increment_maxcmdsn(struct iscsi_cmd *cmd, struct iscsi_session *sess
 
 	mutex_lock(&sess->cmdsn_mutex);
 	sess->max_cmd_sn += 1;
-	TRACE(TRACE_ISCSI, "Updated MaxCmdSN to 0x%08x\n", sess->max_cmd_sn);
+	pr_debug("Updated MaxCmdSN to 0x%08x\n", sess->max_cmd_sn);
 	mutex_unlock(&sess->cmdsn_mutex);
 }
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index c18dad5..863a29c 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -23,7 +23,6 @@
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>
 
-#include "iscsi_target_debug.h"
 #include "iscsi_target_core.h"
 #include "iscsi_target_seq_pdu_list.h"
 #include "iscsi_target_tq.h"
@@ -134,7 +133,7 @@ static int iscsit_dataout_within_command_recovery_check(
 	return DATAOUT_NORMAL;
 
 dump:
-	printk(KERN_ERR "Dumping DataOUT PDU Offset: %u Length: %d DataSN:"
+	pr_err("Dumping DataOUT PDU Offset: %u Length: %d DataSN:"
 		" 0x%08x\n", hdr->offset, payload_length, hdr->datasn);
 	return iscsit_dump_data_payload(conn, payload_length, 1);
 }
@@ -151,7 +150,7 @@ static int iscsit_dataout_check_unsolicited_sequence(
 
 	if ((hdr->offset < cmd->seq_start_offset) ||
 	   ((hdr->offset + payload_length) > cmd->seq_end_offset)) {
-		printk(KERN_ERR "Command ITT: 0x%08x with Offset: %u,"
+		pr_err("Command ITT: 0x%08x with Offset: %u,"
 		" Length: %u outside of Unsolicited Sequence %u:%u while"
 		" DataSequenceInOrder=Yes.\n", cmd->init_task_tag,
 		hdr->offset, payload_length, cmd->seq_start_offset,
@@ -162,7 +161,7 @@ static int iscsit_dataout_check_unsolicited_sequence(
 	first_burst_len = (cmd->first_burst_len + payload_length);
 
 	if (first_burst_len > conn->sess->sess_ops->FirstBurstLength) {
-		printk(KERN_ERR "Total %u bytes exceeds FirstBurstLength: %u"
+		pr_err("Total %u bytes exceeds FirstBurstLength: %u"
 			" for this Unsolicited DataOut Burst.\n",
 			first_burst_len, conn->sess->sess_ops->FirstBurstLength);
 		transport_send_check_condition_and_sense(SE_CMD(cmd),
@@ -185,7 +184,7 @@ static int iscsit_dataout_check_unsolicited_sequence(
 
 		if ((first_burst_len != cmd->data_length) &&
 		    (first_burst_len != conn->sess->sess_ops->FirstBurstLength)) {
-			printk(KERN_ERR "Unsolicited non-immediate data"
+			pr_err("Unsolicited non-immediate data"
 			" received %u does not equal FirstBurstLength: %u, and"
 			" does not equal ExpXferLen %u.\n", first_burst_len,
 				conn->sess->sess_ops->FirstBurstLength,
@@ -196,14 +195,14 @@ static int iscsit_dataout_check_unsolicited_sequence(
 		}
 	} else {
 		if (first_burst_len == conn->sess->sess_ops->FirstBurstLength) {
-			printk(KERN_ERR "Command ITT: 0x%08x reached"
+			pr_err("Command ITT: 0x%08x reached"
 			" FirstBurstLength: %u, but ISCSI_FLAG_CMD_FINAL is not set. protocol"
 				" error.\n", cmd->init_task_tag,
 				conn->sess->sess_ops->FirstBurstLength);
 			return DATAOUT_CANNOT_RECOVER;
 		}
 		if (first_burst_len == cmd->data_length) {
-			printk(KERN_ERR "Command ITT: 0x%08x reached"
+			pr_err("Command ITT: 0x%08x reached"
 			" ExpXferLen: %u, but ISCSI_FLAG_CMD_FINAL is not set. protocol"
 			" error.\n", cmd->init_task_tag, cmd->data_length);
 			return DATAOUT_CANNOT_RECOVER;
@@ -239,7 +238,7 @@ static int iscsit_dataout_check_sequence(
 		 */
 		if ((hdr->offset < cmd->seq_start_offset) ||
 		   ((hdr->offset + payload_length) > cmd->seq_end_offset)) {
-			printk(KERN_ERR "Command ITT: 0x%08x with Offset: %u,"
+			pr_err("Command ITT: 0x%08x with Offset: %u,"
 			" Length: %u outside of Sequence %u:%u while"
 			" DataSequenceInOrder=Yes.\n", cmd->init_task_tag,
 			hdr->offset, payload_length, cmd->seq_start_offset,
@@ -270,7 +269,7 @@ static int iscsit_dataout_check_sequence(
 	}
 
 	if (next_burst_len > conn->sess->sess_ops->MaxBurstLength) {
-		printk(KERN_ERR "Command ITT: 0x%08x, NextBurstLength: %u and"
+		pr_err("Command ITT: 0x%08x, NextBurstLength: %u and"
 			" Length: %u exceeds MaxBurstLength: %u. protocol"
 			" error.\n", cmd->init_task_tag,
 			(next_burst_len - payload_length),
@@ -296,14 +295,14 @@ static int iscsit_dataout_check_sequence(
 			     conn->sess->sess_ops->MaxBurstLength) &&
 			   ((cmd->write_data_done + payload_length) <
 			     cmd->data_length)) {
-				printk(KERN_ERR "Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL"
+				pr_err("Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL"
 				" before end of DataOUT sequence, protocol"
 				" error.\n", cmd->init_task_tag);
 				return DATAOUT_CANNOT_RECOVER;
 			}
 		} else {
 			if (next_burst_len < seq->xfer_len) {
-				printk(KERN_ERR "Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL"
+				pr_err("Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL"
 				" before end of DataOUT sequence, protocol"
 				" error.\n", cmd->init_task_tag);
 				return DATAOUT_CANNOT_RECOVER;
@@ -313,7 +312,7 @@ static int iscsit_dataout_check_sequence(
 		if (conn->sess->sess_ops->DataSequenceInOrder) {
 			if (next_burst_len ==
 					conn->sess->sess_ops->MaxBurstLength) {
-				printk(KERN_ERR "Command ITT: 0x%08x reached"
+				pr_err("Command ITT: 0x%08x reached"
 				" MaxBurstLength: %u, but ISCSI_FLAG_CMD_FINAL is"
 				" not set, protocol error.", cmd->init_task_tag,
 					conn->sess->sess_ops->MaxBurstLength);
@@ -321,7 +320,7 @@ static int iscsit_dataout_check_sequence(
 			}
 			if ((cmd->write_data_done + payload_length) ==
 					cmd->data_length) {
-				printk(KERN_ERR "Command ITT: 0x%08x reached"
+				pr_err("Command ITT: 0x%08x reached"
 				" last DataOUT PDU in sequence but ISCSI_FLAG_"
 				"CMD_FINAL is not set, protocol error.\n",
 					cmd->init_task_tag);
@@ -329,7 +328,7 @@ static int iscsit_dataout_check_sequence(
 			}
 		} else {
 			if (next_burst_len == seq->xfer_len) {
-				printk(KERN_ERR "Command ITT: 0x%08x reached"
+				pr_err("Command ITT: 0x%08x reached"
 				" last DataOUT PDU in sequence but ISCSI_FLAG_"
 				"CMD_FINAL is not set, protocol error.\n",
 					cmd->init_task_tag);
@@ -368,13 +367,13 @@ static int iscsit_dataout_check_datasn(
 	}
 
 	if (hdr->datasn > data_sn) {
-		printk(KERN_ERR "Command ITT: 0x%08x, received DataSN: 0x%08x"
+		pr_err("Command ITT: 0x%08x, received DataSN: 0x%08x"
 			" higher than expected 0x%08x.\n", cmd->init_task_tag,
 				hdr->datasn, data_sn);
 		recovery = 1;
 		goto recover;
 	} else if (hdr->datasn < data_sn) {
-		printk(KERN_ERR "Command ITT: 0x%08x, received DataSN: 0x%08x"
+		pr_err("Command ITT: 0x%08x, received DataSN: 0x%08x"
 			" lower than expected 0x%08x, discarding payload.\n",
 			cmd->init_task_tag, hdr->datasn, data_sn);
 		dump = 1;
@@ -385,7 +384,7 @@ static int iscsit_dataout_check_datasn(
 
 recover:
 	if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-		printk(KERN_ERR "Unable to perform within-command recovery"
+		pr_err("Unable to perform within-command recovery"
 				" while ERL=0.\n");
 		return DATAOUT_CANNOT_RECOVER;
 	}
@@ -417,7 +416,7 @@ static int iscsit_dataout_pre_datapduinorder_yes(
 	 */
 	if (conn->sess->sess_ops->DataSequenceInOrder) {
 		if (hdr->offset != cmd->write_data_done) {
-			printk(KERN_ERR "Command ITT: 0x%08x, received offset"
+			pr_err("Command ITT: 0x%08x, received offset"
 			" %u different than expected %u.\n", cmd->init_task_tag,
 				hdr->offset, cmd->write_data_done);
 			recovery = 1;
@@ -427,13 +426,13 @@ static int iscsit_dataout_pre_datapduinorder_yes(
 		struct iscsi_seq *seq = cmd->seq_ptr;
 
 		if (hdr->offset > seq->offset) {
-			printk(KERN_ERR "Command ITT: 0x%08x, received offset"
+			pr_err("Command ITT: 0x%08x, received offset"
 			" %u greater than expected %u.\n", cmd->init_task_tag,
 				hdr->offset, seq->offset);
 			recovery = 1;
 			goto recover;
 		} else if (hdr->offset < seq->offset) {
-			printk(KERN_ERR "Command ITT: 0x%08x, received offset"
+			pr_err("Command ITT: 0x%08x, received offset"
 			" %u less than expected %u, discarding payload.\n",
 				cmd->init_task_tag, hdr->offset, seq->offset);
 			dump = 1;
@@ -445,7 +444,7 @@ static int iscsit_dataout_pre_datapduinorder_yes(
 
 recover:
 	if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-		printk(KERN_ERR "Unable to perform within-command recovery"
+		pr_err("Unable to perform within-command recovery"
 				" while ERL=0.\n");
 		return DATAOUT_CANNOT_RECOVER;
 	}
@@ -478,7 +477,7 @@ static int iscsit_dataout_pre_datapduinorder_no(
 	case ISCSI_PDU_TIMED_OUT:
 		break;
 	case ISCSI_PDU_RECEIVED_OK:
-		printk(KERN_ERR "Command ITT: 0x%08x received already gotten"
+		pr_err("Command ITT: 0x%08x received already gotten"
 			" Offset: %u, Length: %u\n", cmd->init_task_tag,
 				hdr->offset, payload_length);
 		return iscsit_dump_data_payload(cmd->conn, payload_length, 1);
@@ -734,7 +733,7 @@ int iscsit_check_post_dataout(
 		return iscsit_dataout_post_crc_passed(cmd, buf);
 	else {
 		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-			printk(KERN_ERR "Unable to recover from DataOUT CRC"
+			pr_err("Unable to recover from DataOUT CRC"
 				" failure while ERL=0, closing session.\n");
 			iscsit_add_reject_from_cmd(ISCSI_REASON_DATA_DIGEST_ERROR,
 					1, 0, buf, cmd);
@@ -759,14 +758,14 @@ static void iscsit_handle_time2retain_timeout(unsigned long data)
 		return;
 	}
 	if (atomic_read(&sess->session_reinstatement)) {
-		printk(KERN_ERR "Exiting Time2Retain handler because"
+		pr_err("Exiting Time2Retain handler because"
 				" session_reinstatement=1\n");
 		spin_unlock_bh(&se_tpg->session_lock);
 		return;
 	}
 	sess->time2retain_timer_flags |= ISCSI_TF_EXPIRED;
 
-	printk(KERN_ERR "Time2Retain timer expired for SID: %u, cleaning up"
+	pr_err("Time2Retain timer expired for SID: %u, cleaning up"
 			" iSCSI session.\n", sess->sid);
 	{
 	struct iscsi_tiqn *tiqn = tpg->tpg_tiqn;
@@ -804,7 +803,7 @@ extern void iscsit_start_time2retain_handler(struct iscsi_session *sess)
 	if (sess->time2retain_timer_flags & ISCSI_TF_RUNNING)
 		return;
 
-	TRACE(TRACE_TIMER, "Starting Time2Retain timer for %u seconds on"
+	pr_debug("Starting Time2Retain timer for %u seconds on"
 		" SID: %u\n", sess->sess_ops->DefaultTime2Retain, sess->sid);
 
 	init_timer(&sess->time2retain_timer);
@@ -838,7 +837,7 @@ extern int iscsit_stop_time2retain_timer(struct iscsi_session *sess)
 
 	spin_lock_bh(&se_tpg->session_lock);
 	sess->time2retain_timer_flags &= ~ISCSI_TF_RUNNING;
-	TRACE(TRACE_TIMER, "Stopped Time2Retain Timer for SID: %u\n",
+	pr_debug("Stopped Time2Retain Timer for SID: %u\n",
 			sess->sid);
 	return 0;
 }
@@ -902,7 +901,7 @@ void iscsit_cause_connection_reinstatement(struct iscsi_conn *conn, int sleep)
 
 void iscsit_fall_back_to_erl0(struct iscsi_session *sess)
 {
-	TRACE(TRACE_ERL0, "Falling back to ErrorRecoveryLevel=0 for SID:"
+	pr_debug("Falling back to ErrorRecoveryLevel=0 for SID:"
 			" %u\n", sess->sid);
 
 	atomic_set(&sess->session_fall_back_to_erl0, 1);
@@ -917,7 +916,7 @@ static void iscsit_handle_connection_cleanup(struct iscsi_conn *conn)
 	    !atomic_read(&sess->session_fall_back_to_erl0))
 		iscsit_connection_recovery_transport_reset(conn);
 	else {
-		TRACE(TRACE_ERL0, "Performing cleanup for failed iSCSI"
+		pr_debug("Performing cleanup for failed iSCSI"
 			" Connection ID: %hu from %s\n", conn->cid,
 			sess->sess_ops->InitiatorName);
 		iscsit_close_connection(conn);
@@ -944,7 +943,7 @@ extern void iscsit_take_action_for_connection_exit(struct iscsi_conn *conn)
 		return;
 	}
 
-	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_CLEANUP_WAIT.\n");
+	pr_debug("Moving to TARG_CONN_STATE_CLEANUP_WAIT.\n");
 	conn->conn_state = TARG_CONN_STATE_CLEANUP_WAIT;
 	spin_unlock_bh(&conn->state_lock);
 
@@ -973,13 +972,13 @@ int iscsit_recover_from_unknown_opcode(struct iscsi_conn *conn)
 	 * Make sure the remaining bytes to next maker is a sane value.
 	 */
 	if (conn->of_marker > (conn->conn_ops->OFMarkInt * 4)) {
-		printk(KERN_ERR "Remaining bytes to OFMarker: %u exceeds"
+		pr_err("Remaining bytes to OFMarker: %u exceeds"
 			" OFMarkInt bytes: %u.\n", conn->of_marker,
 				conn->conn_ops->OFMarkInt * 4);
 		return -1;
 	}
 
-	TRACE(TRACE_ERL1, "Advancing %u bytes in TCP stream to get to the"
+	pr_debug("Advancing %u bytes in TCP stream to get to the"
 			" next OFMarker.\n", conn->of_marker);
 
 	if (iscsit_dump_data_payload(conn, conn->of_marker, 0) < 0)
@@ -990,12 +989,12 @@ int iscsit_recover_from_unknown_opcode(struct iscsi_conn *conn)
 	 */
 	if (conn->of_marker_offset > (ISCSI_HDR_LEN + (ISCSI_CRC_LEN * 2) +
 	    conn->conn_ops->MaxRecvDataSegmentLength)) {
-		printk(KERN_ERR "OfMarker offset value: %u exceeds limit.\n",
+		pr_err("OfMarker offset value: %u exceeds limit.\n",
 			conn->of_marker_offset);
 		return -1;
 	}
 
-	TRACE(TRACE_ERL1, "Discarding %u bytes of TCP stream to get to the"
+	pr_debug("Discarding %u bytes of TCP stream to get to the"
 			" next iSCSI Opcode.\n", conn->of_marker_offset);
 
 	if (iscsit_dump_data_payload(conn, conn->of_marker_offset, 0) < 0)
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index c4242d8..8db9377 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -23,7 +23,6 @@
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>
 
-#include "iscsi_target_debug.h"
 #include "iscsi_target_core.h"
 #include "iscsi_target_seq_pdu_list.h"
 #include "iscsi_target_datain_values.h"
@@ -58,7 +57,7 @@ int iscsit_dump_data_payload(
 
 	buf = kzalloc(length, GFP_ATOMIC);
 	if (!buf) {
-		printk(KERN_ERR "Unable to allocate %u bytes for offload"
+		pr_err("Unable to allocate %u bytes for offload"
 				" buffer.\n", length);
 		return -1;
 	}
@@ -153,7 +152,7 @@ static int iscsit_handle_r2t_snack(
 	 */
 	if ((cmd->cmd_flags & ICF_GOT_DATACK_SNACK) &&
 	    (begrun <= cmd->acked_data_sn)) {
-		printk(KERN_ERR "ITT: 0x%08x, R2T SNACK requesting"
+		pr_err("ITT: 0x%08x, R2T SNACK requesting"
 			" retransmission of R2TSN: 0x%08x to 0x%08x but already"
 			" acked to  R2TSN: 0x%08x by TMR TASK_REASSIGN,"
 			" protocol error.\n", cmd->init_task_tag, begrun,
@@ -166,7 +165,7 @@ static int iscsit_handle_r2t_snack(
 
 	if (runlength) {
 		if ((begrun + runlength) > cmd->r2t_sn) {
-			printk(KERN_ERR "Command ITT: 0x%08x received R2T SNACK"
+			pr_err("Command ITT: 0x%08x received R2T SNACK"
 			" with BegRun: 0x%08x, RunLength: 0x%08x, exceeds"
 			" current R2TSN: 0x%08x, protocol error.\n",
 			cmd->init_task_tag, begrun, runlength, cmd->r2t_sn);
@@ -256,7 +255,7 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 	struct iscsi_seq *first_seq = NULL, *seq = NULL;
 
 	if (!cmd->seq_list) {
-		printk(KERN_ERR "struct iscsi_cmd->seq_list is NULL!\n");
+		pr_err("struct iscsi_cmd->seq_list is NULL!\n");
 		return -1;
 	}
 
@@ -281,7 +280,7 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 		 */
 		if (!seq->sent) {
 #if 0
-			printk(KERN_ERR "Ignoring non-sent sequence 0x%08x ->"
+			pr_err("Ignoring non-sent sequence 0x%08x ->"
 				" 0x%08x\n\n", seq->first_datasn,
 				seq->last_datasn);
 #endif
@@ -296,7 +295,7 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 		if ((seq->first_datasn < begrun) &&
 				(seq->last_datasn < begrun)) {
 #if 0
-			printk(KERN_ERR "Pre BegRun sequence 0x%08x ->"
+			pr_err("Pre BegRun sequence 0x%08x ->"
 				" 0x%08x\n", seq->first_datasn,
 				seq->last_datasn);
 #endif
@@ -311,7 +310,7 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 		if ((seq->first_datasn <= begrun) &&
 				(seq->last_datasn >= begrun)) {
 #if 0
-			printk(KERN_ERR "Found sequence begrun: 0x%08x in"
+			pr_err("Found sequence begrun: 0x%08x in"
 				" 0x%08x -> 0x%08x\n", begrun,
 				seq->first_datasn, seq->last_datasn);
 #endif
@@ -371,7 +370,7 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 		if ((seq->first_datasn > begrun) ||
 				(seq->last_datasn > begrun)) {
 #if 0
-			printk(KERN_ERR "Post BegRun sequence 0x%08x -> 0x%08x\n",
+			pr_err("Post BegRun sequence 0x%08x -> 0x%08x\n",
 					seq->first_datasn, seq->last_datasn);
 #endif
 			seq->next_burst_len = seq->pdu_send_order = 0;
@@ -382,7 +381,7 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 	if (!found_seq) {
 		if (!begrun) {
 			if (!first_seq) {
-				printk(KERN_ERR "ITT: 0x%08x, Begrun: 0x%08x"
+				pr_err("ITT: 0x%08x, Begrun: 0x%08x"
 					" but first_seq is NULL\n",
 					cmd->init_task_tag, begrun);
 				return -1;
@@ -392,7 +391,7 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 			goto done;
 		}
 
-		printk(KERN_ERR "Unable to locate struct iscsi_seq for ITT: 0x%08x,"
+		pr_err("Unable to locate struct iscsi_seq for ITT: 0x%08x,"
 			" BegRun: 0x%08x, RunLength: 0x%08x while"
 			" DataSequenceInOrder=No and DataPDUInOrder=%s.\n",
 				cmd->init_task_tag, begrun, runlength,
@@ -418,7 +417,7 @@ static int iscsit_handle_recovery_datain(
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 
 	if (!atomic_read(&se_cmd->t_transport_complete)) {
-		printk(KERN_ERR "Ignoring ITT: 0x%08x Data SNACK\n",
+		pr_err("Ignoring ITT: 0x%08x Data SNACK\n",
 				cmd->init_task_tag);
 		return 0;
 	}
@@ -429,7 +428,7 @@ static int iscsit_handle_recovery_datain(
 	 */
 	if ((cmd->cmd_flags & ICF_GOT_DATACK_SNACK) &&
 	    (begrun <= cmd->acked_data_sn)) {
-		printk(KERN_ERR "ITT: 0x%08x, Data SNACK requesting"
+		pr_err("ITT: 0x%08x, Data SNACK requesting"
 			" retransmission of DataSN: 0x%08x to 0x%08x but"
 			" already acked to DataSN: 0x%08x by Data ACK SNACK,"
 			" protocol error.\n", cmd->init_task_tag, begrun,
@@ -444,7 +443,7 @@ static int iscsit_handle_recovery_datain(
 	 * Note: (cmd->data_sn - 1) will carry the maximum DataSN sent.
 	 */
 	if ((begrun + runlength) > (cmd->data_sn - 1)) {
-		printk(KERN_ERR "Initiator requesting BegRun: 0x%08x, RunLength"
+		pr_err("Initiator requesting BegRun: 0x%08x, RunLength"
 			": 0x%08x greater than maximum DataSN: 0x%08x.\n",
 				begrun, runlength, (cmd->data_sn - 1));
 		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
@@ -493,7 +492,7 @@ int iscsit_handle_recovery_datain_or_r2t(
 		return iscsit_handle_recovery_datain(cmd, buf, begrun,
 				runlength);
 	default:
-		printk(KERN_ERR "Unknown cmd->data_direction: 0x%02x\n",
+		pr_err("Unknown cmd->data_direction: 0x%02x\n",
 				cmd->data_direction);
 		return -1;
 	}
@@ -514,7 +513,7 @@ int iscsit_handle_status_snack(
 	int found_cmd;
 
 	if (conn->exp_statsn > begrun) {
-		printk(KERN_ERR "Got Status SNACK Begrun: 0x%08x, RunLength:"
+		pr_err("Got Status SNACK Begrun: 0x%08x, RunLength:"
 			" 0x%08x but already got ExpStatSN: 0x%08x on CID:"
 			" %hu.\n", begrun, runlength, conn->exp_statsn,
 			conn->cid);
@@ -536,7 +535,7 @@ int iscsit_handle_status_snack(
 		spin_unlock_bh(&conn->cmd_lock);
 
 		if (!found_cmd) {
-			printk(KERN_ERR "Unable to find StatSN: 0x%08x for"
+			pr_err("Unable to find StatSN: 0x%08x for"
 				" a Status SNACK, assuming this was a"
 				" protactic SNACK for an untransmitted"
 				" StatSN, ignoring.\n", begrun);
@@ -547,7 +546,7 @@ int iscsit_handle_status_snack(
 		spin_lock_bh(&cmd->istate_lock);
 		if (cmd->i_state == ISTATE_SEND_DATAIN) {
 			spin_unlock_bh(&cmd->istate_lock);
-			printk(KERN_ERR "Ignoring Status SNACK for BegRun:"
+			pr_err("Ignoring Status SNACK for BegRun:"
 				" 0x%08x, RunLength: 0x%08x, assuming this was"
 				" a protactic SNACK for an untransmitted"
 				" StatSN\n", begrun, runlength);
@@ -574,13 +573,13 @@ int iscsit_handle_data_ack(
 
 	cmd = iscsit_find_cmd_from_ttt(conn, targ_xfer_tag);
 	if (!cmd) {
-		printk(KERN_ERR "Data ACK SNACK for TTT: 0x%08x is"
+		pr_err("Data ACK SNACK for TTT: 0x%08x is"
 			" invalid.\n", targ_xfer_tag);
 		return -1;
 	}
 
 	if (begrun <= cmd->acked_data_sn) {
-		printk(KERN_ERR "ITT: 0x%08x Data ACK SNACK BegRUN: 0x%08x is"
+		pr_err("ITT: 0x%08x Data ACK SNACK BegRUN: 0x%08x is"
 			" less than the already acked DataSN: 0x%08x.\n",
 			cmd->init_task_tag, begrun, cmd->acked_data_sn);
 		return -1;
@@ -593,7 +592,7 @@ int iscsit_handle_data_ack(
 	cmd->cmd_flags |= ICF_GOT_DATACK_SNACK;
 	cmd->acked_data_sn = (begrun - 1);
 
-	TRACE(TRACE_ISCSI, "Received Data ACK SNACK for ITT: 0x%08x,"
+	pr_debug("Received Data ACK SNACK for ITT: 0x%08x,"
 		" updated acked DataSN to 0x%08x.\n",
 			cmd->init_task_tag, cmd->acked_data_sn);
 
@@ -793,7 +792,7 @@ static struct iscsi_ooo_cmdsn *iscsit_allocate_ooo_cmdsn(void)
 
 	ooo_cmdsn = kmem_cache_zalloc(lio_ooo_cache, GFP_ATOMIC);
 	if (!ooo_cmdsn) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 			" struct iscsi_ooo_cmdsn.\n");
 		return NULL;
 	}
@@ -899,7 +898,7 @@ int iscsit_execute_ooo_cmdsns(struct iscsi_session *sess)
 		cmd->i_state = cmd->deferred_i_state;
 		ooo_count++;
 		sess->exp_cmd_sn++;
-		TRACE(TRACE_CMDSN, "Executing out of order CmdSN: 0x%08x,"
+		pr_debug("Executing out of order CmdSN: 0x%08x,"
 			" incremented ExpCmdSN to 0x%08x.\n",
 			cmd->cmd_sn, sess->exp_cmd_sn);
 
@@ -1042,7 +1041,7 @@ int iscsit_execute_cmd(struct iscsi_cmd *cmd, int ooo)
 			lr = iscsit_logout_removeconnforrecovery(cmd, cmd->conn);
 			break;
 		default:
-			printk(KERN_ERR "Unknown iSCSI Logout Request Code:"
+			pr_err("Unknown iSCSI Logout Request Code:"
 				" 0x%02x\n", cmd->logout_reason);
 			return -1;
 		}
@@ -1050,7 +1049,7 @@ int iscsit_execute_cmd(struct iscsi_cmd *cmd, int ooo)
 		return lr;
 	default:
 		spin_unlock_bh(&cmd->istate_lock);
-		printk(KERN_ERR "Cannot perform out of order execution for"
+		pr_err("Cannot perform out of order execution for"
 		" unknown iSCSI Opcode: 0x%02x\n", cmd->iscsi_opcode);
 		return -1;
 	}
@@ -1131,7 +1130,7 @@ static int iscsit_set_dataout_timeout_values(
 
 	spin_lock_bh(&cmd->r2t_lock);
 	if (list_empty(&cmd->cmd_r2t_list)) {
-		printk(KERN_ERR "cmd->cmd_r2t_list is empty!\n");
+		pr_err("cmd->cmd_r2t_list is empty!\n");
 		spin_unlock_bh(&cmd->r2t_lock);
 		return -1;
 	}
@@ -1146,7 +1145,7 @@ static int iscsit_set_dataout_timeout_values(
 	}
 	spin_unlock_bh(&cmd->r2t_lock);
 
-	printk(KERN_ERR "Unable to locate any incomplete DataOUT"
+	pr_err("Unable to locate any incomplete DataOUT"
 		" sequences for ITT: 0x%08x.\n", cmd->init_task_tag);
 
 	return -1;
@@ -1177,13 +1176,13 @@ static void iscsit_handle_dataout_timeout(unsigned long data)
 	na = iscsit_tpg_get_node_attrib(sess);
 
 	if (!sess->sess_ops->ErrorRecoveryLevel) {
-		TRACE(TRACE_ERL0, "Unable to recover from DataOut timeout while"
+		pr_debug("Unable to recover from DataOut timeout while"
 			" in ERL=0.\n");
 		goto failure;
 	}
 
 	if (++cmd->dataout_timeout_retries == na->dataout_timeout_retries) {
-		TRACE(TRACE_TIMER, "Command ITT: 0x%08x exceeded max retries"
+		pr_debug("Command ITT: 0x%08x exceeded max retries"
 			" for DataOUT timeout %u, closing iSCSI connection.\n",
 			cmd->init_task_tag, na->dataout_timeout_retries);
 		goto failure;
@@ -1216,7 +1215,7 @@ static void iscsit_handle_dataout_timeout(unsigned long data)
 			&r2t_offset, &r2t_length) < 0)
 		goto failure;
 
-	TRACE(TRACE_TIMER, "Command ITT: 0x%08x timed out waiting for"
+	pr_debug("Command ITT: 0x%08x timed out waiting for"
 		" completion of %sDataOUT Sequence Offset: %u, Length: %u\n",
 		cmd->init_task_tag, (cmd->unsolicited_data) ? "Unsolicited " :
 		"", r2t_offset, r2t_length);
@@ -1250,7 +1249,7 @@ void iscsit_mod_dataout_timer(struct iscsi_cmd *cmd)
 
 	mod_timer(&cmd->dataout_timer,
 		(get_jiffies_64() + na->dataout_timeout * HZ));
-	TRACE(TRACE_TIMER, "Updated DataOUT timer for ITT: 0x%08x",
+	pr_debug("Updated DataOUT timer for ITT: 0x%08x",
 			cmd->init_task_tag);
 	spin_unlock_bh(&cmd->dataout_timeout_lock);
 }
@@ -1268,7 +1267,7 @@ void iscsit_start_dataout_timer(
 	if (cmd->dataout_timer_flags & ISCSI_TF_RUNNING)
 		return;
 
-	TRACE(TRACE_TIMER, "Starting DataOUT timer for ITT: 0x%08x on"
+	pr_debug("Starting DataOUT timer for ITT: 0x%08x on"
 		" CID: %hu.\n", cmd->init_task_tag, conn->cid);
 
 	init_timer(&cmd->dataout_timer);
@@ -1294,7 +1293,7 @@ void iscsit_stop_dataout_timer(struct iscsi_cmd *cmd)
 
 	spin_lock_bh(&cmd->dataout_timeout_lock);
 	cmd->dataout_timer_flags &= ~ISCSI_TF_RUNNING;
-	TRACE(TRACE_TIMER, "Stopped DataOUT Timer for ITT: 0x%08x\n",
+	pr_debug("Stopped DataOUT Timer for ITT: 0x%08x\n",
 			cmd->init_task_tag);
 	spin_unlock_bh(&cmd->dataout_timeout_lock);
 }
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index a810e59..fcbc861 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -23,7 +23,6 @@
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>
 
-#include "iscsi_target_debug.h"
 #include "iscsi_target_core.h"
 #include "iscsi_target_datain_values.h"
 #include "iscsi_target_util.h"
@@ -102,7 +101,7 @@ static int iscsit_attach_inactive_connection_recovery_entry(
 	list_add_tail(&cr->cr_list, &sess->cr_inactive_list);
 
 	sess->conn_recovery_count++;
-	TRACE(TRACE_ERL2, "Incremented connection recovery count to %u for"
+	pr_debug("Incremented connection recovery count to %u for"
 		" SID: %u\n", sess->conn_recovery_count, sess->sid);
 	spin_unlock(&sess->cr_i_lock);
 
@@ -197,7 +196,7 @@ int iscsit_remove_active_connection_recovery_entry(
 	list_del(&cr->cr_list);
 
 	sess->conn_recovery_count--;
-	TRACE(TRACE_ERL2, "Decremented connection recovery count to %u for"
+	pr_debug("Decremented connection recovery count to %u for"
 		" SID: %u\n", sess->conn_recovery_count, sess->sid);
 	spin_unlock(&sess->cr_a_lock);
 
@@ -227,7 +226,7 @@ int iscsit_remove_cmd_from_connection_recovery(
 	struct iscsi_conn_recovery *cr;
 
 	if (!cmd->cr) {
-		printk(KERN_ERR "struct iscsi_conn_recovery pointer for ITT: 0x%08x"
+		pr_err("struct iscsi_conn_recovery pointer for ITT: 0x%08x"
 			" is NULL!\n", cmd->init_task_tag);
 		BUG();
 	}
@@ -256,7 +255,7 @@ void iscsit_discard_cr_cmds_by_expstatsn(
 		}
 
 		dropped_count++;
-		TRACE(TRACE_ERL2, "Dropping Acknowledged ITT: 0x%08x, StatSN:"
+		pr_debug("Dropping Acknowledged ITT: 0x%08x, StatSN:"
 			" 0x%08x, CID: %hu.\n", cmd->init_task_tag,
 				cmd->stat_sn, cr->cid);
 
@@ -274,17 +273,17 @@ void iscsit_discard_cr_cmds_by_expstatsn(
 	}
 	spin_unlock(&cr->conn_recovery_cmd_lock);
 
-	TRACE(TRACE_ERL2, "Dropped %u total acknowledged commands on"
+	pr_debug("Dropped %u total acknowledged commands on"
 		" CID: %hu less than old ExpStatSN: 0x%08x\n",
 			dropped_count, cr->cid, exp_statsn);
 
 	if (!cr->cmd_count) {
-		TRACE(TRACE_ERL2, "No commands to be reassigned for failed"
+		pr_debug("No commands to be reassigned for failed"
 			" connection CID: %hu on SID: %u\n",
 			cr->cid, sess->sid);
 		iscsit_remove_inactive_connection_recovery_entry(cr, sess);
 		iscsit_attach_active_connection_recovery_entry(sess, cr);
-		printk(KERN_INFO "iSCSI connection recovery successful for CID:"
+		pr_debug("iSCSI connection recovery successful for CID:"
 			" %hu on SID: %u\n", cr->cid, sess->sid);
 		iscsit_remove_active_connection_recovery_entry(cr, sess);
 	} else {
@@ -308,7 +307,7 @@ int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsi_conn *conn)
 			continue;
 
 		dropped_count++;
-		TRACE(TRACE_ERL2, "Dropping unacknowledged CmdSN:"
+		pr_debug("Dropping unacknowledged CmdSN:"
 		" 0x%08x during connection recovery on CID: %hu\n",
 			ooo_cmdsn->cmdsn, conn->cid);
 		iscsit_remove_ooo_cmdsn(sess, ooo_cmdsn);
@@ -334,7 +333,7 @@ int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsi_conn *conn)
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
-	TRACE(TRACE_ERL2, "Dropped %u total unacknowledged commands on CID:"
+	pr_debug("Dropped %u total unacknowledged commands on CID:"
 		" %hu for ExpCmdSN: 0x%08x.\n", dropped_count, conn->cid,
 				sess->exp_cmd_sn);
 	return 0;
@@ -354,7 +353,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 	 */
 	cr = kzalloc(sizeof(struct iscsi_conn_recovery), GFP_KERNEL);
 	if (!cr) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 			" struct iscsi_conn_recovery.\n");
 		return -1;
 	}
@@ -375,7 +374,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 
 		if ((cmd->iscsi_opcode != ISCSI_OP_SCSI_CMD) &&
 		    (cmd->iscsi_opcode != ISCSI_OP_NOOP_OUT)) {
-			TRACE(TRACE_ERL2, "Not performing realligence on"
+			pr_debug("Not performing realligence on"
 				" Opcode: 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x,"
 				" CID: %hu\n", cmd->iscsi_opcode,
 				cmd->init_task_tag, cmd->cmd_sn, conn->cid);
@@ -422,7 +421,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 		}
 
 		cmd_count++;
-		TRACE(TRACE_ERL2, "Preparing Opcode: 0x%02x, ITT: 0x%08x,"
+		pr_debug("Preparing Opcode: 0x%02x, ITT: 0x%08x,"
 			" CmdSN: 0x%08x, StatSN: 0x%08x, CID: %hu for"
 			" realligence.\n", cmd->iscsi_opcode,
 			cmd->init_task_tag, cmd->cmd_sn, cmd->stat_sn,
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 1b2ffe0..c54e500 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -25,7 +25,6 @@
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>
 
-#include "iscsi_target_debug.h"
 #include "iscsi_target_core.h"
 #include "iscsi_target_tq.h"
 #include "iscsi_target_device.h"
@@ -64,7 +63,7 @@ static int iscsi_login_init_conn(struct iscsi_conn *conn)
 	spin_lock_init(&conn->state_lock);
 
 	if (!(zalloc_cpumask_var(&conn->conn_cpumask, GFP_KERNEL))) {
-		printk(KERN_ERR "Unable to allocate conn->conn_cpumask\n");
+		pr_err("Unable to allocate conn->conn_cpumask\n");
 		return -ENOMEM;
 	}
 
@@ -86,7 +85,7 @@ int iscsi_login_setup_crypto(struct iscsi_conn *conn)
 	conn->conn_rx_hash.tfm = crypto_alloc_hash("crc32c", 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(conn->conn_rx_hash.tfm)) {
-		printk(KERN_ERR "crypto_alloc_hash() failed for conn_rx_tfm\n");
+		pr_err("crypto_alloc_hash() failed for conn_rx_tfm\n");
 		return -ENOMEM;
 	}
 
@@ -94,7 +93,7 @@ int iscsi_login_setup_crypto(struct iscsi_conn *conn)
 	conn->conn_tx_hash.tfm = crypto_alloc_hash("crc32c", 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(conn->conn_tx_hash.tfm)) {
-		printk(KERN_ERR "crypto_alloc_hash() failed for conn_tx_tfm\n");
+		pr_err("crypto_alloc_hash() failed for conn_tx_tfm\n");
 		crypto_free_hash(conn->conn_rx_hash.tfm);
 		return -ENOMEM;
 	}
@@ -108,7 +107,7 @@ static int iscsi_login_check_initiator_version(
 	u8 version_min)
 {
 	if ((version_max != 0x00) || (version_min != 0x00)) {
-		printk(KERN_ERR "Unsupported iSCSI IETF Pre-RFC Revision,"
+		pr_err("Unsupported iSCSI IETF Pre-RFC Revision,"
 			" version Min/Max 0x%02x/0x%02x, rejecting login.\n",
 			version_min, version_max);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
@@ -172,7 +171,7 @@ int iscsi_check_for_session_reinstatement(struct iscsi_conn *conn)
 	if (!sess)
 		return 0;
 
-	TRACE(TRACE_ERL0, "%s iSCSI Session SID %u is still active for %s,"
+	pr_debug("%s iSCSI Session SID %u is still active for %s,"
 		" preforming session reinstatement.\n", (sessiontype) ?
 		"Discovery" : "Normal", sess->sid,
 		sess->sess_ops->InitiatorName);
@@ -224,7 +223,7 @@ static int iscsi_login_zero_tsih_s1(
 	if (!sess) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		printk(KERN_ERR "Could not allocate memory for session\n");
+		pr_err("Could not allocate memory for session\n");
 		return -1;
 	}
 
@@ -248,7 +247,7 @@ static int iscsi_login_zero_tsih_s1(
 	spin_lock_init(&sess->ttt_lock);
 
 	if (!idr_pre_get(&sess_idr, GFP_KERNEL)) {
-		printk(KERN_ERR "idr_pre_get() for sess_idr failed\n");
+		pr_err("idr_pre_get() for sess_idr failed\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
 		return -1;	
@@ -269,7 +268,7 @@ static int iscsi_login_zero_tsih_s1(
 	if (!sess->sess_ops) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 				" struct iscsi_sess_ops.\n");
 		return -1;
 	}
@@ -365,7 +364,7 @@ int iscsi_login_disable_FIM_keys(
 
 	param = iscsi_find_param_from_key("OFMarker", param_list);
 	if (!param) {
-		printk(KERN_ERR "iscsi_find_param_from_key() for"
+		pr_err("iscsi_find_param_from_key() for"
 				" OFMarker failed\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
@@ -375,7 +374,7 @@ int iscsi_login_disable_FIM_keys(
 
 	param = iscsi_find_param_from_key("OFMarkInt", param_list);
 	if (!param) {
-		printk(KERN_ERR "iscsi_find_param_from_key() for"
+		pr_err("iscsi_find_param_from_key() for"
 				" IFMarker failed\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
@@ -385,7 +384,7 @@ int iscsi_login_disable_FIM_keys(
 
 	param = iscsi_find_param_from_key("IFMarker", param_list);
 	if (!param) {
-		printk(KERN_ERR "iscsi_find_param_from_key() for"
+		pr_err("iscsi_find_param_from_key() for"
 				" IFMarker failed\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
@@ -395,7 +394,7 @@ int iscsi_login_disable_FIM_keys(
 
 	param = iscsi_find_param_from_key("IFMarkInt", param_list);
 	if (!param) {
-		printk(KERN_ERR "iscsi_find_param_from_key() for"
+		pr_err("iscsi_find_param_from_key() for"
 				" IFMarker failed\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
@@ -453,7 +452,7 @@ static int iscsi_login_non_zero_tsih_s2(
 	 * If the Time2Retain handler has expired, the session is already gone.
 	 */
 	if (!sess) {
-		printk(KERN_ERR "Initiator attempting to add a connection to"
+		pr_err("Initiator attempting to add a connection to"
 			" a non-existent session, rejecting iSCSI Login.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_NO_SESSION);
@@ -515,7 +514,7 @@ int iscsi_login_post_auth_non_zero_tsih(
 	 */
 	conn_ptr = iscsit_get_conn_from_cid_rcfr(sess, cid);
 	if ((conn_ptr)) {
-		printk(KERN_ERR "Connection exists with CID %hu for %s,"
+		pr_err("Connection exists with CID %hu for %s,"
 			" performing connection reinstatement.\n",
 			conn_ptr->cid, sess->sess_ops->InitiatorName);
 
@@ -536,7 +535,7 @@ int iscsi_login_post_auth_non_zero_tsih(
 		cr = iscsit_get_inactive_connection_recovery_entry(
 				sess, cid);
 		if ((cr)) {
-			TRACE(TRACE_ERL2, "Performing implicit logout"
+			pr_debug("Performing implicit logout"
 				" for connection recovery on CID: %hu\n",
 					conn->cid);
 			iscsit_discard_cr_cmds_by_expstatsn(cr, exp_statsn);
@@ -549,11 +548,11 @@ int iscsi_login_post_auth_non_zero_tsih(
 	 * CID we go ahead and continue to add a new connection to the
 	 * session.
 	 */
-	TRACE(TRACE_LOGIN, "Adding CID %hu to existing session for %s.\n",
+	pr_debug("Adding CID %hu to existing session for %s.\n",
 			cid, sess->sess_ops->InitiatorName);
 
 	if ((atomic_read(&sess->nconn) + 1) > sess->sess_ops->MaxConnections) {
-		printk(KERN_ERR "Adding additional connection to this session"
+		pr_err("Adding additional connection to this session"
 			" would exceed MaxConnections %d, login failed.\n",
 				sess->sess_ops->MaxConnections);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
@@ -589,7 +588,7 @@ static int iscsi_post_login_handler(
 	iscsit_collect_login_stats(conn, ISCSI_STATUS_CLS_SUCCESS,
 			ISCSI_LOGIN_STATUS_ACCEPT);
 
-	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_LOGGED_IN.\n");
+	pr_debug("Moving to TARG_CONN_STATE_LOGGED_IN.\n");
 	conn->conn_state = TARG_CONN_STATE_LOGGED_IN;
 
 	iscsi_set_connection_parameters(conn->conn_ops, conn->param_list);
@@ -607,19 +606,19 @@ static int iscsi_post_login_handler(
 		spin_lock_bh(&sess->conn_lock);
 		atomic_set(&sess->session_continuation, 0);
 		if (sess->session_state == TARG_SESS_STATE_FAILED) {
-			TRACE(TRACE_STATE, "Moving to"
+			pr_debug("Moving to"
 					" TARG_SESS_STATE_LOGGED_IN.\n");
 			sess->session_state = TARG_SESS_STATE_LOGGED_IN;
 			stop_timer = 1;
 		}
 
-		printk(KERN_INFO "iSCSI Login successful on CID: %hu from %s to"
+		pr_debug("iSCSI Login successful on CID: %hu from %s to"
 			" %s:%hu,%hu\n", conn->cid, conn->login_ip, np->np_ip,
 				np->np_port, tpg->tpgt);
 
 		list_add_tail(&conn->conn_list, &sess->sess_conn_list);
 		atomic_inc(&sess->nconn);
-		printk(KERN_INFO "Incremented iSCSI Connection count to %hu"
+		pr_debug("Incremented iSCSI Connection count to %hu"
 			" from node: %s\n", atomic_read(&sess->nconn),
 			sess->sess_ops->InitiatorName);
 		spin_unlock_bh(&sess->conn_lock);
@@ -653,16 +652,16 @@ static int iscsi_post_login_handler(
 	spin_lock_bh(&se_tpg->session_lock);
 	__transport_register_session(&sess->tpg->tpg_se_tpg,
 			se_sess->se_node_acl, se_sess, (void *)sess);
-	TRACE(TRACE_STATE, "Moving to TARG_SESS_STATE_LOGGED_IN.\n");
+	pr_debug("Moving to TARG_SESS_STATE_LOGGED_IN.\n");
 	sess->session_state = TARG_SESS_STATE_LOGGED_IN;
 
-	printk(KERN_INFO "iSCSI Login successful on CID: %hu from %s to %s:%hu,%hu\n",
+	pr_debug("iSCSI Login successful on CID: %hu from %s to %s:%hu,%hu\n",
 		conn->cid, conn->login_ip, np->np_ip, np->np_port, tpg->tpgt);
 
 	spin_lock_bh(&sess->conn_lock);
 	list_add_tail(&conn->conn_list, &sess->sess_conn_list);
 	atomic_inc(&sess->nconn);
-	printk(KERN_INFO "Incremented iSCSI Connection count to %hu from node:"
+	pr_debug("Incremented iSCSI Connection count to %hu from node:"
 		" %s\n", atomic_read(&sess->nconn),
 		sess->sess_ops->InitiatorName);
 	spin_unlock_bh(&sess->conn_lock);
@@ -670,14 +669,14 @@ static int iscsi_post_login_handler(
 	sess->sid = tpg->sid++;
 	if (!sess->sid)
 		sess->sid = tpg->sid++;
-	printk(KERN_INFO "Established iSCSI session from node: %s\n",
+	pr_debug("Established iSCSI session from node: %s\n",
 			sess->sess_ops->InitiatorName);
 
 	tpg->nsessions++;
 	if (tpg->tpg_tiqn)
 		tpg->tpg_tiqn->tiqn_nsessions++;
 
-	printk(KERN_INFO "Incremented number of active iSCSI sessions to %u on"
+	pr_debug("Incremented number of active iSCSI sessions to %u on"
 		" iSCSI Target Portal Group: %hu\n", tpg->nsessions, tpg->tpgt);
 	spin_unlock_bh(&se_tpg->session_lock);
 
@@ -701,7 +700,7 @@ static void iscsi_handle_login_thread_timeout(unsigned long data)
 	struct iscsi_np *np = (struct iscsi_np *) data;
 
 	spin_lock_bh(&np->np_thread_lock);
-	printk(KERN_ERR "iSCSI Login timeout on Network Portal %s:%hu\n",
+	pr_err("iSCSI Login timeout on Network Portal %s:%hu\n",
 			np->np_ip, np->np_port);
 
 	if (np->np_login_timer_flags & ISCSI_TF_STOP) {
@@ -731,7 +730,7 @@ static void iscsi_start_login_thread_timer(struct iscsi_np *np)
 	np->np_login_timer_flags |= ISCSI_TF_RUNNING;
 	add_timer(&np->np_login_timer);
 
-	TRACE(TRACE_LOGIN, "Added timeout timer to iSCSI login request for"
+	pr_debug("Added timeout timer to iSCSI login request for"
 			" %u seconds.\n", TA_LOGIN_TIMEOUT);
 	spin_unlock_bh(&np->np_thread_lock);
 }
@@ -777,7 +776,7 @@ int iscsi_target_setup_login_socket(
 	case ISCSI_IWARP_SCTP:
 	case ISCSI_INFINIBAND:
 	default:
-		printk(KERN_ERR "Unsupported network_transport: %d\n",
+		pr_err("Unsupported network_transport: %d\n",
 				np->np_network_transport);
 		return -EINVAL;
 	}
@@ -785,7 +784,7 @@ int iscsi_target_setup_login_socket(
 	ret = sock_create(sockaddr->ss_family, np->np_sock_type,
 			np->np_ip_proto, &sock);
 	if (ret < 0) {
-		printk(KERN_ERR "sock_create() failed.\n");
+		pr_err("sock_create() failed.\n");
 		return ret;
 	}
 	np->np_socket = sock;
@@ -797,7 +796,7 @@ int iscsi_target_setup_login_socket(
 		if (!sock->file) {
 			sock->file = kzalloc(sizeof(struct file), GFP_KERNEL);
 			if (!sock->file) {
-				printk(KERN_ERR "Unable to allocate struct"
+				pr_err("Unable to allocate struct"
 						" file for SCTP\n");
 				ret = -ENOMEM;
 				goto fail;
@@ -824,7 +823,7 @@ int iscsi_target_setup_login_socket(
 		ret = kernel_setsockopt(sock, IPPROTO_TCP, TCP_NODELAY,
 				(char *)&opt, sizeof(opt));
 		if (ret < 0) {
-			printk(KERN_ERR "kernel_setsockopt() for TCP_NODELAY"
+			pr_err("kernel_setsockopt() for TCP_NODELAY"
 				" failed: %d\n", ret);
 			goto fail;
 		}
@@ -833,20 +832,20 @@ int iscsi_target_setup_login_socket(
 	ret = kernel_setsockopt(sock, SOL_SOCKET, SO_REUSEADDR,
 			(char *)&opt, sizeof(opt));
 	if (ret < 0) {
-		printk(KERN_ERR "kernel_setsockopt() for SO_REUSEADDR"
+		pr_err("kernel_setsockopt() for SO_REUSEADDR"
 			" failed\n");
 		goto fail;
 	}
 
 	ret = kernel_bind(sock, (struct sockaddr *)&np->np_sockaddr, len);
 	if (ret < 0) {
-		printk(KERN_ERR "kernel_bind() failed: %d\n", ret);
+		pr_err("kernel_bind() failed: %d\n", ret);
 		goto fail;
 	}
 
 	ret = kernel_listen(sock, backlog);
 	if (ret != 0) {
-		printk(KERN_ERR "kernel_listen() failed: %d\n", ret);
+		pr_err("kernel_listen() failed: %d\n", ret);
 		goto fail;
 	}
 
@@ -913,7 +912,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 			new_sock->file = kzalloc(
 					sizeof(struct file), GFP_KERNEL);
 			if (!new_sock->file) {
-				printk(KERN_ERR "Unable to allocate struct"
+				pr_err("Unable to allocate struct"
 						" file for SCTP\n");
 				sock_release(new_sock);
 				/* Get another socket */
@@ -927,7 +926,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 
 	conn = kzalloc(sizeof(struct iscsi_conn), GFP_KERNEL);
 	if (!conn) {
-		printk(KERN_ERR "Could not allocate memory for"
+		pr_err("Could not allocate memory for"
 			" new connection\n");
 		if (set_sctp_conn_flag) {
 			kfree(new_sock->file);
@@ -938,14 +937,14 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 		return 1;
 	}
 
-	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_FREE.\n");
+	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
 	conn->conn_state = TARG_CONN_STATE_FREE;
 	conn->sock = new_sock;
 
 	if (set_sctp_conn_flag)
 		conn->conn_flags |= CONNFLAG_SCTP_STRUCT_FILE;
 
-	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_XPT_UP.\n");
+	pr_debug("Moving to TARG_CONN_STATE_XPT_UP.\n");
 	conn->conn_state = TARG_CONN_STATE_XPT_UP;
 
 	/*
@@ -954,7 +953,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	 */
 	conn->conn_ops = kzalloc(sizeof(struct iscsi_conn_ops), GFP_KERNEL);
 	if (!conn->conn_ops) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 			" struct iscsi_conn_ops.\n");
 		goto new_sess_out;
 	}
@@ -970,13 +969,13 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	iov.iov_len	= ISCSI_HDR_LEN;
 
 	if (rx_data(conn, &iov, 1, ISCSI_HDR_LEN) <= 0) {
-		printk(KERN_ERR "rx_data() returned an error.\n");
+		pr_err("rx_data() returned an error.\n");
 		goto new_sess_out;
 	}
 
 	iscsi_opcode = (buffer[0] & ISCSI_OPCODE_MASK);
 	if (!(iscsi_opcode & ISCSI_OP_LOGIN)) {
-		printk(KERN_ERR "First opcode is not login request,"
+		pr_err("First opcode is not login request,"
 			" failing login request.\n");
 		goto new_sess_out;
 	}
@@ -996,7 +995,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	spin_lock_bh(&np->np_thread_lock);
 	if (np->np_thread_state != ISCSI_NP_THREAD_ACTIVE) {
 		spin_unlock_bh(&np->np_thread_lock);
-		printk(KERN_ERR "iSCSI Network Portal on %s:%hu currently not"
+		pr_err("iSCSI Network Portal on %s:%hu currently not"
 			" active.\n", np->np_ip, np->np_port);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_SVC_UNAVAILABLE);
@@ -1009,7 +1008,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 
 		if (conn->sock->ops->getname(conn->sock,
 				(struct sockaddr *)&sock_in6, &err, 1) < 0) {
-			printk(KERN_ERR "sock_ops->getname() failed.\n");
+			pr_err("sock_ops->getname() failed.\n");
 			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 					ISCSI_LOGIN_STATUS_TARGET_ERROR);
 			goto new_sess_out;
@@ -1019,20 +1018,20 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 				&sock_in6.sin6_addr.in6_u,
 				(char *)&conn->ipv6_login_ip[0],
 				IPV6_ADDRESS_SPACE))) {
-			printk(KERN_ERR "iscsi_ntop6() failed\n");
+			pr_err("iscsi_ntop6() failed\n");
 			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 					ISCSI_LOGIN_STATUS_TARGET_ERROR);
 			goto new_sess_out;
 		}
 #else
-		printk(KERN_INFO "Skipping iscsi_ntop6()\n");
+		pr_debug("Skipping iscsi_ntop6()\n");
 #endif
 	} else {
 		memset(&sock_in, 0, sizeof(struct sockaddr_in));
 
 		if (conn->sock->ops->getname(conn->sock,
 				(struct sockaddr *)&sock_in, &err, 1) < 0) {
-			printk(KERN_ERR "sock_ops->getname() failed.\n");
+			pr_err("sock_ops->getname() failed.\n");
 			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 					ISCSI_LOGIN_STATUS_TARGET_ERROR);
 			goto new_sess_out;
@@ -1043,12 +1042,12 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 
 	conn->network_transport = np->np_network_transport;
 
-	printk(KERN_INFO "Received iSCSI login request from %s on %s Network"
+	pr_debug("Received iSCSI login request from %s on %s Network"
 			" Portal %s:%hu\n", conn->login_ip,
 		(conn->network_transport == ISCSI_TCP) ? "TCP" : "SCTP",
 			np->np_ip, np->np_port);
 
-	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_IN_LOGIN.\n");
+	pr_debug("Moving to TARG_CONN_STATE_IN_LOGIN.\n");
 	conn->conn_state	= TARG_CONN_STATE_IN_LOGIN;
 
 	if (iscsi_login_check_initiator_version(conn, pdu->max_version,
@@ -1088,7 +1087,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 
 	tpg = conn->tpg;
 	if (!tpg) {
-		printk(KERN_ERR "Unable to locate struct iscsi_conn->tpg\n");
+		pr_err("Unable to locate struct iscsi_conn->tpg\n");
 		goto new_sess_out;
 	}
 
@@ -1108,7 +1107,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 		goto new_sess_out;
 
 	if (!conn->sess) {
-		printk(KERN_ERR "struct iscsi_conn session pointer is NULL!\n");
+		pr_err("struct iscsi_conn session pointer is NULL!\n");
 		goto new_sess_out;
 	}
 
@@ -1128,7 +1127,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	return 1;
 
 new_sess_out:
-	printk(KERN_ERR "iSCSI Login negotiation failed.\n");
+	pr_err("iSCSI Login negotiation failed.\n");
 	iscsit_collect_login_stats(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				  ISCSI_LOGIN_STATUS_INIT_ERR);
 	if (!zero_tsih || !conn->sess)
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 565dbea..79526f0 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -23,7 +23,6 @@
 #include <target/target_core_base.h>
 #include <target/target_core_tpg.h>
 
-#include "iscsi_target_debug.h"
 #include "iscsi_target_core.h"
 #include "iscsi_target_parameters.h"
 #include "iscsi_target_login.h"
@@ -91,7 +90,7 @@ int extract_param(
 		return -1;
 
 	if (len > max_length) {
-		printk(KERN_ERR "Length of input: %d exeeds max_length:"
+		pr_err("Length of input: %d exeeds max_length:"
 			" %d\n", len, max_length);
 		return -1;
 	}
@@ -120,14 +119,14 @@ static u32 iscsi_handle_authentication(
 		 */
 		se_nacl = conn->sess->se_sess->se_node_acl;
 		if (!se_nacl) {
-			printk(KERN_ERR "Unable to locate struct se_node_acl for"
+			pr_err("Unable to locate struct se_node_acl for"
 					" CHAP auth\n");
 			return -1;
 		}
 		iscsi_nacl = container_of(se_nacl, struct iscsi_node_acl,
 				se_node_acl);
 		if (!iscsi_nacl) {
-			printk(KERN_ERR "Unable to locate struct iscsi_node_acl for"
+			pr_err("Unable to locate struct iscsi_node_acl for"
 					" CHAP auth\n");
 			return -1;
 		}
@@ -187,7 +186,7 @@ static int iscsi_target_check_login_request(
 	case ISCSI_OP_LOGIN:
 		break;
 	default:
-		printk(KERN_ERR "Received unknown opcode 0x%02x.\n",
+		pr_err("Received unknown opcode 0x%02x.\n",
 				login_req->opcode & ISCSI_OPCODE_MASK);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
@@ -196,7 +195,7 @@ static int iscsi_target_check_login_request(
 
 	if ((login_req->flags & ISCSI_FLAG_LOGIN_CONTINUE) &&
 	    (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT)) {
-		printk(KERN_ERR "Login request has both ISCSI_FLAG_LOGIN_CONTINUE"
+		pr_err("Login request has both ISCSI_FLAG_LOGIN_CONTINUE"
 			" and ISCSI_FLAG_LOGIN_TRANSIT set, protocol error.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
@@ -209,7 +208,7 @@ static int iscsi_target_check_login_request(
 	rsp_nsg = (login_rsp->flags & ISCSI_FLAG_LOGIN_NEXT_STAGE_MASK);
 
 	if (req_csg != login->current_stage) {
-		printk(KERN_ERR "Initiator unexpectedly changed login stage"
+		pr_err("Initiator unexpectedly changed login stage"
 			" from %d to %d, login failed.\n", login->current_stage,
 			req_csg);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
@@ -220,7 +219,7 @@ static int iscsi_target_check_login_request(
 	if ((req_nsg == 2) || (req_csg >= 2) ||
 	   ((login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT) &&
 	    (req_nsg <= req_csg))) {
-		printk(KERN_ERR "Illegal login_req->flags Combination, CSG: %d,"
+		pr_err("Illegal login_req->flags Combination, CSG: %d,"
 			" NSG: %d, ISCSI_FLAG_LOGIN_TRANSIT: %d.\n", req_csg,
 			req_nsg, (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT));
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
@@ -230,7 +229,7 @@ static int iscsi_target_check_login_request(
 
 	if ((login_req->max_version != login->version_max) ||
 	    (login_req->min_version != login->version_min)) {
-		printk(KERN_ERR "Login request changed Version Max/Nin"
+		pr_err("Login request changed Version Max/Nin"
 			" unexpectedly to 0x%02x/0x%02x, protocol error\n",
 			login_req->max_version, login_req->min_version);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
@@ -239,7 +238,7 @@ static int iscsi_target_check_login_request(
 	}
 
 	if (memcmp(login_req->isid, login->isid, 6) != 0) {
-		printk(KERN_ERR "Login request changed ISID unexpectedly,"
+		pr_err("Login request changed ISID unexpectedly,"
 				" protocol error.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
@@ -247,7 +246,7 @@ static int iscsi_target_check_login_request(
 	}
 
 	if (login_req->itt != login->init_task_tag) {
-		printk(KERN_ERR "Login request changed ITT unexpectedly to"
+		pr_err("Login request changed ITT unexpectedly to"
 			" 0x%08x, protocol error.\n", login_req->itt);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
@@ -255,7 +254,7 @@ static int iscsi_target_check_login_request(
 	}
 
 	if (payload_length > MAX_KEY_VALUE_PAIRS) {
-		printk(KERN_ERR "Login request payload exceeds default"
+		pr_err("Login request payload exceeds default"
 			" MaxRecvDataSegmentLength: %u, protocol error.\n",
 				MAX_KEY_VALUE_PAIRS);
 		return -1;
@@ -276,7 +275,7 @@ static int iscsi_target_check_first_request(
 	list_for_each_entry(param, &conn->param_list->param_list, p_list) {
 		if (!strncmp(param->name, SESSIONTYPE, 11)) {
 			if (!IS_PSTATE_ACCEPTOR(param)) {
-				printk(KERN_ERR "SessionType key not received"
+				pr_err("SessionType key not received"
 					" in first login request.\n");
 				iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 					ISCSI_LOGIN_STATUS_MISSING_FIELDS);
@@ -291,7 +290,7 @@ static int iscsi_target_check_first_request(
 				if (!login->leading_connection)
 					continue;
 
-				printk(KERN_ERR "InitiatorName key not received"
+				pr_err("InitiatorName key not received"
 					" in first login request.\n");
 				iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 					ISCSI_LOGIN_STATUS_MISSING_FIELDS);
@@ -306,7 +305,7 @@ static int iscsi_target_check_first_request(
 			if (!login->leading_connection) {
 				se_nacl = conn->sess->se_sess->se_node_acl;
 				if (!se_nacl) {
-					printk(KERN_ERR "Unable to locate"
+					pr_err("Unable to locate"
 						" struct se_node_acl\n");
 					iscsit_tx_login_rsp(conn,
 							ISCSI_STATUS_CLS_INITIATOR_ERR,
@@ -316,7 +315,7 @@ static int iscsi_target_check_first_request(
 
 				if (strcmp(param->value,
 						se_nacl->initiatorname)) {
-					printk(KERN_ERR "Incorrect"
+					pr_err("Incorrect"
 						" InitiatorName: %s for this"
 						" iSCSI Initiator Node.\n",
 						param->value);
@@ -349,7 +348,7 @@ static int iscsi_target_do_tx_login_io(struct iscsi_conn *conn, struct iscsi_log
 	login_rsp->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	login_rsp->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
 
-	TRACE(TRACE_LOGIN, "Sending Login Response, Flags: 0x%02x, ITT: 0x%08x,"
+	pr_debug("Sending Login Response, Flags: 0x%02x, ITT: 0x%08x,"
 		" ExpCmdSN; 0x%08x, MaxCmdSN: 0x%08x, StatSN: 0x%08x, Length:"
 		" %u\n", login_rsp->flags, ntohl(login_rsp->itt),
 		ntohl(login_rsp->exp_cmdsn), ntohl(login_rsp->max_cmdsn),
@@ -392,7 +391,7 @@ static int iscsi_target_do_rx_login_io(struct iscsi_conn *conn, struct iscsi_log
 	login_req->cmdsn		= be32_to_cpu(login_req->cmdsn);
 	login_req->exp_statsn		= be32_to_cpu(login_req->exp_statsn);
 
-	TRACE(TRACE_LOGIN, "Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
+	pr_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
 		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
 		 login_req->flags, login_req->itt, login_req->cmdsn,
 		 login_req->exp_statsn, login_req->cid, payload_length);
@@ -433,7 +432,7 @@ static int iscsi_target_get_initial_payload(
 	login_req = (struct iscsi_login_req *) login->req;
 	payload_length = ntoh24(login_req->dlength);
 
-	TRACE(TRACE_LOGIN, "Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
+	pr_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
 		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, Length: %u\n",
 		login_req->flags, login_req->itt, login_req->cmdsn,
 		login_req->exp_statsn, payload_length);
@@ -500,11 +499,11 @@ static int iscsi_target_do_authentication(
 			param->value);
 	switch (authret) {
 	case 0:
-		printk(KERN_INFO "Received OK response"
+		pr_debug("Received OK response"
 		" from LIO Authentication, continuing.\n");
 		break;
 	case 1:
-		printk(KERN_INFO "iSCSI security negotiation"
+		pr_debug("iSCSI security negotiation"
 			" completed sucessfully.\n");
 		login->auth_complete = 1;
 		if ((login_req->flags & ISCSI_FLAG_LOGIN_NEXT_STAGE1) &&
@@ -516,13 +515,13 @@ static int iscsi_target_do_authentication(
 		return iscsi_target_check_for_existing_instances(
 				conn, login);
 	case 2:
-		printk(KERN_ERR "Security negotiation"
+		pr_err("Security negotiation"
 			" failed.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_AUTH_FAILED);
 		return -1;
 	default:
-		printk(KERN_ERR "Received unknown error %d from LIO"
+		pr_err("Received unknown error %d from LIO"
 				" Authentication\n", authret);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_TARGET_ERROR);
@@ -561,7 +560,7 @@ static int iscsi_target_handle_csg_zero(
 
 	if (ret > 0) {
 		if (login->auth_complete) {
-			printk(KERN_ERR "Initiator has already been"
+			pr_err("Initiator has already been"
 				" successfully authenticated, but is still"
 				" sending %s keys.\n", param->value);
 			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
@@ -588,7 +587,7 @@ static int iscsi_target_handle_csg_zero(
 	if (!iscsi_check_negotiated_keys(conn->param_list)) {
 		if (ISCSI_TPG_ATTRIB(ISCSI_TPG_C(conn))->authentication &&
 		    !strncmp(param->value, NONE, 4)) {
-			printk(KERN_ERR "Initiator sent AuthMethod=None but"
+			pr_err("Initiator sent AuthMethod=None but"
 				" Target is enforcing iSCSI Authentication,"
 					" login failed.\n");
 			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
@@ -654,7 +653,7 @@ static int iscsi_target_handle_csg_one(struct iscsi_conn *conn, struct iscsi_log
 
 	if (!login->auth_complete &&
 	     ISCSI_TPG_ATTRIB(ISCSI_TPG_C(conn))->authentication) {
-		printk(KERN_ERR "Initiator is requesting CSG: 1, has not been"
+		pr_err("Initiator is requesting CSG: 1, has not been"
 			 " successfully authenticated, and the Target is"
 			" enforcing iSCSI Authentication, login failed.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
@@ -682,7 +681,7 @@ static int iscsi_target_do_login(struct iscsi_conn *conn, struct iscsi_login *lo
 
 	while (1) {
 		if (++pdu_count > MAX_LOGIN_PDUS) {
-			printk(KERN_ERR "MAX_LOGIN_PDUS count reached.\n");
+			pr_err("MAX_LOGIN_PDUS count reached.\n");
 			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 					ISCSI_LOGIN_STATUS_TARGET_ERROR);
 			return -1;
@@ -707,7 +706,7 @@ static int iscsi_target_do_login(struct iscsi_conn *conn, struct iscsi_login *lo
 			}
 			break;
 		default:
-			printk(KERN_ERR "Illegal CSG: %d received from"
+			pr_err("Illegal CSG: %d received from"
 				" Initiator, protocol error.\n",
 				(login_req->flags & ISCSI_FLAG_LOGIN_CURRENT_STAGE_MASK)
 				>> 2);
@@ -780,7 +779,7 @@ static int iscsi_target_locate_portal(
 
 	tmpbuf = kzalloc(payload_length + 1, GFP_KERNEL);
 	if (!tmpbuf) {
-		printk(KERN_ERR "Unable to allocate memory for tmpbuf.\n");
+		pr_err("Unable to allocate memory for tmpbuf.\n");
 		return -1;
 	}
 
@@ -813,7 +812,7 @@ static int iscsi_target_locate_portal(
 	 * See 5.3.  Login Phase.
 	 */
 	if (!i_buf) {
-		printk(KERN_ERR "InitiatorName key not received"
+		pr_err("InitiatorName key not received"
 			" in first login request.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 			ISCSI_LOGIN_STATUS_MISSING_FIELDS);
@@ -831,7 +830,7 @@ static int iscsi_target_locate_portal(
 		if (!login->leading_connection)
 			goto get_target;
 
-		printk(KERN_ERR "SessionType key not received"
+		pr_err("SessionType key not received"
 			" in first login request.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 			ISCSI_LOGIN_STATUS_MISSING_FIELDS);
@@ -853,7 +852,7 @@ static int iscsi_target_locate_portal(
 		 * Setup crc32c modules from libcrypto
 		 */
 		if (iscsi_login_setup_crypto(conn) < 0) {
-			printk(KERN_ERR "iscsi_login_setup_crypto() failed\n");
+			pr_err("iscsi_login_setup_crypto() failed\n");
 			ret = -1;
 			goto out;
 		}
@@ -873,7 +872,7 @@ static int iscsi_target_locate_portal(
 
 get_target:
 	if (!t_buf) {
-		printk(KERN_ERR "TargetName key not received"
+		pr_err("TargetName key not received"
 			" in first login request while"
 			" SessionType=Normal.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
@@ -887,21 +886,21 @@ get_target:
 	 */
 	tiqn = iscsit_get_tiqn_for_login(t_buf);
 	if (!tiqn) {
-		printk(KERN_ERR "Unable to locate Target IQN: %s in"
+		pr_err("Unable to locate Target IQN: %s in"
 			" Storage Node\n", t_buf);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_SVC_UNAVAILABLE);
 		ret = -1;
 		goto out;
 	}
-	printk(KERN_INFO "Located Storage Object: %s\n", tiqn->tiqn);
+	pr_debug("Located Storage Object: %s\n", tiqn->tiqn);
 
 	/*
 	 * Locate Target Portal Group from Storage Node.
 	 */
 	conn->tpg = iscsit_get_tpg_from_np(tiqn, np);
 	if (!conn->tpg) {
-		printk(KERN_ERR "Unable to locate Target Portal Group"
+		pr_err("Unable to locate Target Portal Group"
 				" on %s\n", tiqn->tiqn);
 		iscsit_put_tiqn_for_login(tiqn);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
@@ -909,12 +908,12 @@ get_target:
 		ret = -1;
 		goto out;
 	}
-	printk(KERN_INFO "Located Portal Group Object: %hu\n", conn->tpg->tpgt);
+	pr_debug("Located Portal Group Object: %hu\n", conn->tpg->tpgt);
 	/*
 	 * Setup crc32c modules from libcrypto
 	 */
 	if (iscsi_login_setup_crypto(conn) < 0) {
-		printk(KERN_ERR "iscsi_login_setup_crypto() failed\n");
+		pr_err("iscsi_login_setup_crypto() failed\n");
 		ret = -1;
 		goto out;
 	}
@@ -952,7 +951,7 @@ get_target:
 	sess->se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
 			&conn->tpg->tpg_se_tpg, i_buf);
 	if (!sess->se_sess->se_node_acl) {
-		printk(KERN_ERR "iSCSI Initiator Node: %s is not authorized to"
+		pr_err("iSCSI Initiator Node: %s is not authorized to"
 			" access iSCSI target portal group: %hu.\n",
 				i_buf, conn->tpg->tpgt);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
@@ -976,7 +975,7 @@ struct iscsi_login *iscsi_target_init_negotiation(
 
 	login = kzalloc(sizeof(struct iscsi_login), GFP_KERNEL);
 	if (!login) {
-		printk(KERN_ERR "Unable to allocate memory for struct iscsi_login.\n");
+		pr_err("Unable to allocate memory for struct iscsi_login.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
 		goto out;
@@ -984,7 +983,7 @@ struct iscsi_login *iscsi_target_init_negotiation(
 
 	login->req = kzalloc(ISCSI_HDR_LEN, GFP_KERNEL);
 	if (!login->req) {
-		printk(KERN_ERR "Unable to allocate memory for Login Request.\n");
+		pr_err("Unable to allocate memory for Login Request.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
 		goto out;
@@ -993,7 +992,7 @@ struct iscsi_login *iscsi_target_init_negotiation(
 
 	login->req_buf = kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
 	if (!login->req_buf) {
-		printk(KERN_ERR "Unable to allocate memory for response buffer.\n");
+		pr_err("Unable to allocate memory for response buffer.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
 		goto out;
@@ -1008,7 +1007,7 @@ struct iscsi_login *iscsi_target_init_negotiation(
 	 *	Locates Target Portal from NP -> Target IQN
 	 */
 	if (iscsi_target_locate_portal(np, conn, login) < 0) {
-		printk(KERN_ERR "iSCSI Login negotiation failed.\n");
+		pr_err("iSCSI Login negotiation failed.\n");
 		goto out;
 	}
 
@@ -1029,7 +1028,7 @@ int iscsi_target_start_negotiation(
 
 	login->rsp = kzalloc(ISCSI_HDR_LEN, GFP_KERNEL);
 	if (!login->rsp) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 				" Login Response.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
@@ -1039,7 +1038,7 @@ int iscsi_target_start_negotiation(
 
 	login->rsp_buf = kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
 	if (!login->rsp_buf) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 			" request buffer.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
diff --git a/drivers/target/iscsi/iscsi_target_nodeattrib.c b/drivers/target/iscsi/iscsi_target_nodeattrib.c
index 96072c7..95d757e 100644
--- a/drivers/target/iscsi/iscsi_target_nodeattrib.c
+++ b/drivers/target/iscsi/iscsi_target_nodeattrib.c
@@ -21,7 +21,6 @@
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>
 
-#include "iscsi_target_debug.h"
 #include "iscsi_target_core.h"
 #include "iscsi_target_device.h"
 #include "iscsi_target_tpg.h"
@@ -58,19 +57,19 @@ extern int iscsit_na_dataout_timeout(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (dataout_timeout > NA_DATAOUT_TIMEOUT_MAX) {
-		printk(KERN_ERR "Requested DataOut Timeout %u larger than"
+		pr_err("Requested DataOut Timeout %u larger than"
 			" maximum %u\n", dataout_timeout,
 			NA_DATAOUT_TIMEOUT_MAX);
 		return -EINVAL;
 	} else if (dataout_timeout < NA_DATAOUT_TIMEOUT_MIX) {
-		printk(KERN_ERR "Requested DataOut Timeout %u smaller than"
+		pr_err("Requested DataOut Timeout %u smaller than"
 			" minimum %u\n", dataout_timeout,
 			NA_DATAOUT_TIMEOUT_MIX);
 		return -EINVAL;
 	}
 
 	a->dataout_timeout = dataout_timeout;
-	TRACE(TRACE_NODEATTRIB, "Set DataOut Timeout to %u for Initiator Node"
+	pr_debug("Set DataOut Timeout to %u for Initiator Node"
 		" %s\n", a->dataout_timeout, iscsit_na_get_initiatorname(acl));
 
 	return 0;
@@ -83,19 +82,19 @@ extern int iscsit_na_dataout_timeout_retries(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (dataout_timeout_retries > NA_DATAOUT_TIMEOUT_RETRIES_MAX) {
-		printk(KERN_ERR "Requested DataOut Timeout Retries %u larger"
+		pr_err("Requested DataOut Timeout Retries %u larger"
 			" than maximum %u", dataout_timeout_retries,
 				NA_DATAOUT_TIMEOUT_RETRIES_MAX);
 		return -EINVAL;
 	} else if (dataout_timeout_retries < NA_DATAOUT_TIMEOUT_RETRIES_MIN) {
-		printk(KERN_ERR "Requested DataOut Timeout Retries %u smaller"
+		pr_err("Requested DataOut Timeout Retries %u smaller"
 			" than minimum %u", dataout_timeout_retries,
 				NA_DATAOUT_TIMEOUT_RETRIES_MIN);
 		return -EINVAL;
 	}
 
 	a->dataout_timeout_retries = dataout_timeout_retries;
-	TRACE(TRACE_NODEATTRIB, "Set DataOut Timeout Retries to %u for"
+	pr_debug("Set DataOut Timeout Retries to %u for"
 		" Initiator Node %s\n", a->dataout_timeout_retries,
 		iscsit_na_get_initiatorname(acl));
 
@@ -114,19 +113,19 @@ extern int iscsit_na_nopin_timeout(
 	u32 orig_nopin_timeout = a->nopin_timeout;
 
 	if (nopin_timeout > NA_NOPIN_TIMEOUT_MAX) {
-		printk(KERN_ERR "Requested NopIn Timeout %u larger than maximum"
+		pr_err("Requested NopIn Timeout %u larger than maximum"
 			" %u\n", nopin_timeout, NA_NOPIN_TIMEOUT_MAX);
 		return -EINVAL;
 	} else if ((nopin_timeout < NA_NOPIN_TIMEOUT_MIN) &&
 		   (nopin_timeout != 0)) {
-		printk(KERN_ERR "Requested NopIn Timeout %u smaller than"
+		pr_err("Requested NopIn Timeout %u smaller than"
 			" minimum %u and not 0\n", nopin_timeout,
 			NA_NOPIN_TIMEOUT_MIN);
 		return -EINVAL;
 	}
 
 	a->nopin_timeout = nopin_timeout;
-	TRACE(TRACE_NODEATTRIB, "Set NopIn Timeout to %u for Initiator"
+	pr_debug("Set NopIn Timeout to %u for Initiator"
 		" Node %s\n", a->nopin_timeout,
 		iscsit_na_get_initiatorname(acl));
 	/*
@@ -164,19 +163,19 @@ extern int iscsit_na_nopin_response_timeout(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (nopin_response_timeout > NA_NOPIN_RESPONSE_TIMEOUT_MAX) {
-		printk(KERN_ERR "Requested NopIn Response Timeout %u larger"
+		pr_err("Requested NopIn Response Timeout %u larger"
 			" than maximum %u\n", nopin_response_timeout,
 				NA_NOPIN_RESPONSE_TIMEOUT_MAX);
 		return -EINVAL;
 	} else if (nopin_response_timeout < NA_NOPIN_RESPONSE_TIMEOUT_MIN) {
-		printk(KERN_ERR "Requested NopIn Response Timeout %u smaller"
+		pr_err("Requested NopIn Response Timeout %u smaller"
 			" than minimum %u\n", nopin_response_timeout,
 				NA_NOPIN_RESPONSE_TIMEOUT_MIN);
 		return -EINVAL;
 	}
 
 	a->nopin_response_timeout = nopin_response_timeout;
-	TRACE(TRACE_NODEATTRIB, "Set NopIn Response Timeout to %u for"
+	pr_debug("Set NopIn Response Timeout to %u for"
 		" Initiator Node %s\n", a->nopin_timeout,
 		iscsit_na_get_initiatorname(acl));
 
@@ -190,13 +189,13 @@ extern int iscsit_na_random_datain_pdu_offsets(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (random_datain_pdu_offsets != 0 && random_datain_pdu_offsets != 1) {
-		printk(KERN_ERR "Requested Random DataIN PDU Offsets: %u not"
+		pr_err("Requested Random DataIN PDU Offsets: %u not"
 			" 0 or 1\n", random_datain_pdu_offsets);
 		return -EINVAL;
 	}
 
 	a->random_datain_pdu_offsets = random_datain_pdu_offsets;
-	TRACE(TRACE_NODEATTRIB, "Set Random DataIN PDU Offsets to %u for"
+	pr_debug("Set Random DataIN PDU Offsets to %u for"
 		" Initiator Node %s\n", a->random_datain_pdu_offsets,
 		iscsit_na_get_initiatorname(acl));
 
@@ -210,13 +209,13 @@ extern int iscsit_na_random_datain_seq_offsets(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (random_datain_seq_offsets != 0 && random_datain_seq_offsets != 1) {
-		printk(KERN_ERR "Requested Random DataIN Sequence Offsets: %u"
+		pr_err("Requested Random DataIN Sequence Offsets: %u"
 			" not 0 or 1\n", random_datain_seq_offsets);
 		return -EINVAL;
 	}
 
 	a->random_datain_seq_offsets = random_datain_seq_offsets;
-	TRACE(TRACE_NODEATTRIB, "Set Random DataIN Sequence Offsets to %u for"
+	pr_debug("Set Random DataIN Sequence Offsets to %u for"
 		" Initiator Node %s\n", a->random_datain_seq_offsets,
 		iscsit_na_get_initiatorname(acl));
 
@@ -230,13 +229,13 @@ extern int iscsit_na_random_r2t_offsets(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (random_r2t_offsets != 0 && random_r2t_offsets != 1) {
-		printk(KERN_ERR "Requested Random R2T Offsets: %u not"
+		pr_err("Requested Random R2T Offsets: %u not"
 			" 0 or 1\n", random_r2t_offsets);
 		return -EINVAL;
 	}
 
 	a->random_r2t_offsets = random_r2t_offsets;
-	TRACE(TRACE_NODEATTRIB, "Set Random R2T Offsets to %u for"
+	pr_debug("Set Random R2T Offsets to %u for"
 		" Initiator Node %s\n", a->random_r2t_offsets,
 		iscsit_na_get_initiatorname(acl));
 
@@ -250,13 +249,13 @@ extern int iscsit_na_default_erl(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (default_erl != 0 && default_erl != 1 && default_erl != 2) {
-		printk(KERN_ERR "Requested default ERL: %u not 0, 1, or 2\n",
+		pr_err("Requested default ERL: %u not 0, 1, or 2\n",
 				default_erl);
 		return -EINVAL;
 	}
 
 	a->default_erl = default_erl;
-	TRACE(TRACE_NODEATTRIB, "Set use ERL0 flag to %u for Initiator"
+	pr_debug("Set use ERL0 flag to %u for Initiator"
 		" Node %s\n", a->default_erl,
 		iscsit_na_get_initiatorname(acl));
 
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 5511ea1..3e2ad2c 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -20,7 +20,6 @@
 
 #include <linux/slab.h>
 
-#include "iscsi_target_debug.h"
 #include "iscsi_target_core.h"
 #include "iscsi_target_util.h"
 #include "iscsi_target_parameters.h"
@@ -46,7 +45,7 @@ int iscsi_login_rx_data(
 
 	rx_got = rx_data(conn, &iov, 1, length);
 	if (rx_got != length) {
-		printk(KERN_ERR "rx_data returned %d, expecting %d.\n",
+		pr_err("rx_data returned %d, expecting %d.\n",
 				rx_got, length);
 		return -1;
 	}
@@ -80,7 +79,7 @@ int iscsi_login_tx_data(
 
 	tx_sent = tx_data(conn, &iov[0], 2, length);
 	if (tx_sent != length) {
-		printk(KERN_ERR "tx_data returned %d, expecting %d.\n",
+		pr_err("tx_data returned %d, expecting %d.\n",
 				tx_sent, length);
 		return -1;
 	}
@@ -90,47 +89,47 @@ int iscsi_login_tx_data(
 
 void iscsi_dump_conn_ops(struct iscsi_conn_ops *conn_ops)
 {
-	printk(KERN_INFO "HeaderDigest: %s\n", (conn_ops->HeaderDigest) ?
+	pr_debug("HeaderDigest: %s\n", (conn_ops->HeaderDigest) ?
 				"CRC32C" : "None");
-	printk(KERN_INFO "DataDigest: %s\n", (conn_ops->DataDigest) ?
+	pr_debug("DataDigest: %s\n", (conn_ops->DataDigest) ?
 				"CRC32C" : "None");
-	printk(KERN_INFO "MaxRecvDataSegmentLength: %u\n",
+	pr_debug("MaxRecvDataSegmentLength: %u\n",
 				conn_ops->MaxRecvDataSegmentLength);
-	printk(KERN_INFO "OFMarker: %s\n", (conn_ops->OFMarker) ? "Yes" : "No");
-	printk(KERN_INFO "IFMarker: %s\n", (conn_ops->IFMarker) ? "Yes" : "No");
+	pr_debug("OFMarker: %s\n", (conn_ops->OFMarker) ? "Yes" : "No");
+	pr_debug("IFMarker: %s\n", (conn_ops->IFMarker) ? "Yes" : "No");
 	if (conn_ops->OFMarker)
-		printk(KERN_INFO "OFMarkInt: %u\n", conn_ops->OFMarkInt);
+		pr_debug("OFMarkInt: %u\n", conn_ops->OFMarkInt);
 	if (conn_ops->IFMarker)
-		printk(KERN_INFO "IFMarkInt: %u\n", conn_ops->IFMarkInt);
+		pr_debug("IFMarkInt: %u\n", conn_ops->IFMarkInt);
 }
 
 void iscsi_dump_sess_ops(struct iscsi_sess_ops *sess_ops)
 {
-	printk(KERN_INFO "InitiatorName: %s\n", sess_ops->InitiatorName);
-	printk(KERN_INFO "InitiatorAlias: %s\n", sess_ops->InitiatorAlias);
-	printk(KERN_INFO "TargetName: %s\n", sess_ops->TargetName);
-	printk(KERN_INFO "TargetAlias: %s\n", sess_ops->TargetAlias);
-	printk(KERN_INFO "TargetPortalGroupTag: %hu\n",
+	pr_debug("InitiatorName: %s\n", sess_ops->InitiatorName);
+	pr_debug("InitiatorAlias: %s\n", sess_ops->InitiatorAlias);
+	pr_debug("TargetName: %s\n", sess_ops->TargetName);
+	pr_debug("TargetAlias: %s\n", sess_ops->TargetAlias);
+	pr_debug("TargetPortalGroupTag: %hu\n",
 			sess_ops->TargetPortalGroupTag);
-	printk(KERN_INFO "MaxConnections: %hu\n", sess_ops->MaxConnections);
-	printk(KERN_INFO "InitialR2T: %s\n",
+	pr_debug("MaxConnections: %hu\n", sess_ops->MaxConnections);
+	pr_debug("InitialR2T: %s\n",
 			(sess_ops->InitialR2T) ? "Yes" : "No");
-	printk(KERN_INFO "ImmediateData: %s\n", (sess_ops->ImmediateData) ?
+	pr_debug("ImmediateData: %s\n", (sess_ops->ImmediateData) ?
 			"Yes" : "No");
-	printk(KERN_INFO "MaxBurstLength: %u\n", sess_ops->MaxBurstLength);
-	printk(KERN_INFO "FirstBurstLength: %u\n", sess_ops->FirstBurstLength);
-	printk(KERN_INFO "DefaultTime2Wait: %hu\n", sess_ops->DefaultTime2Wait);
-	printk(KERN_INFO "DefaultTime2Retain: %hu\n",
+	pr_debug("MaxBurstLength: %u\n", sess_ops->MaxBurstLength);
+	pr_debug("FirstBurstLength: %u\n", sess_ops->FirstBurstLength);
+	pr_debug("DefaultTime2Wait: %hu\n", sess_ops->DefaultTime2Wait);
+	pr_debug("DefaultTime2Retain: %hu\n",
 			sess_ops->DefaultTime2Retain);
-	printk(KERN_INFO "MaxOutstandingR2T: %hu\n",
+	pr_debug("MaxOutstandingR2T: %hu\n",
 			sess_ops->MaxOutstandingR2T);
-	printk(KERN_INFO "DataPDUInOrder: %s\n",
+	pr_debug("DataPDUInOrder: %s\n",
 			(sess_ops->DataPDUInOrder) ? "Yes" : "No");
-	printk(KERN_INFO "DataSequenceInOrder: %s\n",
+	pr_debug("DataSequenceInOrder: %s\n",
 			(sess_ops->DataSequenceInOrder) ? "Yes" : "No");
-	printk(KERN_INFO "ErrorRecoveryLevel: %hu\n",
+	pr_debug("ErrorRecoveryLevel: %hu\n",
 			sess_ops->ErrorRecoveryLevel);
-	printk(KERN_INFO "SessionType: %s\n", (sess_ops->SessionType) ?
+	pr_debug("SessionType: %s\n", (sess_ops->SessionType) ?
 			"Discovery" : "Normal");
 }
 
@@ -139,7 +138,7 @@ void iscsi_print_params(struct iscsi_param_list *param_list)
 	struct iscsi_param *param;
 
 	list_for_each_entry(param, &param_list->param_list, p_list)
-		printk(KERN_INFO "%s: %s\n", param->name, param->value);
+		pr_debug("%s: %s\n", param->name, param->value);
 }
 
 static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *param_list,
@@ -150,20 +149,20 @@ static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *para
 
 	param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
 	if (!(param)) {
-		printk(KERN_ERR "Unable to allocate memory for parameter.\n");
+		pr_err("Unable to allocate memory for parameter.\n");
 		goto out;
 	}
 	INIT_LIST_HEAD(&param->p_list);
 
 	param->name = kzalloc(strlen(name) + 1, GFP_KERNEL);
 	if (!(param->name)) {
-		printk(KERN_ERR "Unable to allocate memory for parameter name.\n");
+		pr_err("Unable to allocate memory for parameter name.\n");
 		goto out;
 	}
 
 	param->value = kzalloc(strlen(value) + 1, GFP_KERNEL);
 	if (!(param->value)) {
-		printk(KERN_ERR "Unable to allocate memory for parameter value.\n");
+		pr_err("Unable to allocate memory for parameter value.\n");
 		goto out;
 	}
 
@@ -208,7 +207,7 @@ static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *para
 		param->type = TYPE_STRING;
 		break;
 	default:
-		printk(KERN_ERR "Unknown type_range 0x%02x\n",
+		pr_err("Unknown type_range 0x%02x\n",
 				param->type_range);
 		goto out;
 	}
@@ -233,7 +232,7 @@ int iscsi_create_default_params(struct iscsi_param_list **param_list_ptr)
 
 	pl = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
 	if (!(pl)) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 				" struct iscsi_param_list.\n");
 		return -1 ;
 	}
@@ -551,7 +550,7 @@ int iscsi_copy_param_list(
 
 	param_list = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
 	if (!(param_list)) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 				" struct iscsi_param_list.\n");
 		goto err_out;
 	}
@@ -568,7 +567,7 @@ int iscsi_copy_param_list(
 
 		new_param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
 		if (!(new_param)) {
-			printk(KERN_ERR "Unable to allocate memory for"
+			pr_err("Unable to allocate memory for"
 				" struct iscsi_param.\n");
 			goto err_out;
 		}
@@ -583,7 +582,7 @@ int iscsi_copy_param_list(
 
 		new_param->name = kzalloc(strlen(param->name) + 1, GFP_KERNEL);
 		if (!(new_param->name)) {
-			printk(KERN_ERR "Unable to allocate memory for"
+			pr_err("Unable to allocate memory for"
 				" parameter name.\n");
 			goto err_out;
 		}
@@ -591,7 +590,7 @@ int iscsi_copy_param_list(
 		new_param->value = kzalloc(strlen(param->value) + 1,
 				GFP_KERNEL);
 		if (!(new_param->value)) {
-			printk(KERN_ERR "Unable to allocate memory for"
+			pr_err("Unable to allocate memory for"
 				" parameter value.\n");
 			goto err_out;
 		}
@@ -607,7 +606,7 @@ int iscsi_copy_param_list(
 	if (!(list_empty(&param_list->param_list)))
 		*dst_param_list = param_list;
 	else {
-		printk(KERN_ERR "No parameters allocated.\n");
+		pr_err("No parameters allocated.\n");
 		goto err_out;
 	}
 
@@ -657,7 +656,7 @@ struct iscsi_param *iscsi_find_param_from_key(
 	struct iscsi_param *param;
 
 	if (!key || !param_list) {
-		printk(KERN_ERR "Key or parameter list pointer is NULL.\n");
+		pr_err("Key or parameter list pointer is NULL.\n");
 		return NULL;
 	}
 
@@ -666,7 +665,7 @@ struct iscsi_param *iscsi_find_param_from_key(
 			return param;
 	}
 
-	printk(KERN_ERR "Unable to locate key \"%s\".\n", key);
+	pr_err("Unable to locate key \"%s\".\n", key);
 	return NULL;
 }
 
@@ -674,7 +673,7 @@ int iscsi_extract_key_value(char *textbuf, char **key, char **value)
 {
 	*value = strchr(textbuf, '=');
 	if (!(*value)) {
-		printk(KERN_ERR "Unable to locate \"=\" seperator for key,"
+		pr_err("Unable to locate \"=\" seperator for key,"
 				" ignoring request.\n");
 		return -1;
 	}
@@ -692,14 +691,14 @@ int iscsi_update_param_value(struct iscsi_param *param, char *value)
 
 	param->value = kzalloc(strlen(value) + 1, GFP_KERNEL);
 	if (!(param->value)) {
-		printk(KERN_ERR "Unable to allocate memory for value.\n");
+		pr_err("Unable to allocate memory for value.\n");
 		return -1;
 	}
 
 	memcpy(param->value, value, strlen(value));
 	param->value[strlen(value)] = '\0';
 
-	TRACE(TRACE_PARAM, "iSCSI Parameter updated to %s=%s\n",
+	pr_debug("iSCSI Parameter updated to %s=%s\n",
 			param->name, param->value);
 	return 0;
 }
@@ -712,14 +711,14 @@ static int iscsi_add_notunderstood_response(
 	struct iscsi_extra_response *extra_response;
 
 	if (strlen(value) > VALUE_MAXLEN) {
-		printk(KERN_ERR "Value for notunderstood key \"%s\" exceeds %d,"
+		pr_err("Value for notunderstood key \"%s\" exceeds %d,"
 			" protocol error.\n", key, VALUE_MAXLEN);
 		return -1;
 	}
 
 	extra_response = kzalloc(sizeof(struct iscsi_extra_response), GFP_KERNEL);
 	if (!(extra_response)) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 			" struct iscsi_extra_response.\n");
 		return -1;
 	}
@@ -800,7 +799,7 @@ static void iscsi_check_proposer_for_optional_reply(struct iscsi_param *param)
 static int iscsi_check_boolean_value(struct iscsi_param *param, char *value)
 {
 	if (strcmp(value, YES) && strcmp(value, NO)) {
-		printk(KERN_ERR "Illegal value for \"%s\", must be either"
+		pr_err("Illegal value for \"%s\", must be either"
 			" \"%s\" or \"%s\".\n", param->name, YES, NO);
 		return -1;
 	}
@@ -818,14 +817,14 @@ static int iscsi_check_numerical_value(struct iscsi_param *param, char *value_pt
 /* #warning FIXME: Fix this */
 #if 0
 	if (strspn(endptr, WHITE_SPACE) != strlen(endptr)) {
-		printk(KERN_ERR "Illegal value \"%s\" for \"%s\".\n",
+		pr_err("Illegal value \"%s\" for \"%s\".\n",
 			value, param->name);
 		return -1;
 	}
 #endif
 	if (IS_TYPERANGE_0_TO_2(param)) {
 		if ((value < 0) || (value > 2)) {
-			printk(KERN_ERR "Illegal value for \"%s\", must be"
+			pr_err("Illegal value for \"%s\", must be"
 				" between 0 and 2.\n", param->name);
 			return -1;
 		}
@@ -833,7 +832,7 @@ static int iscsi_check_numerical_value(struct iscsi_param *param, char *value_pt
 	}
 	if (IS_TYPERANGE_0_TO_3600(param)) {
 		if ((value < 0) || (value > 3600)) {
-			printk(KERN_ERR "Illegal value for \"%s\", must be"
+			pr_err("Illegal value for \"%s\", must be"
 				" between 0 and 3600.\n", param->name);
 			return -1;
 		}
@@ -841,7 +840,7 @@ static int iscsi_check_numerical_value(struct iscsi_param *param, char *value_pt
 	}
 	if (IS_TYPERANGE_0_TO_32767(param)) {
 		if ((value < 0) || (value > 32767)) {
-			printk(KERN_ERR "Illegal value for \"%s\", must be"
+			pr_err("Illegal value for \"%s\", must be"
 				" between 0 and 32767.\n", param->name);
 			return -1;
 		}
@@ -849,7 +848,7 @@ static int iscsi_check_numerical_value(struct iscsi_param *param, char *value_pt
 	}
 	if (IS_TYPERANGE_0_TO_65535(param)) {
 		if ((value < 0) || (value > 65535)) {
-			printk(KERN_ERR "Illegal value for \"%s\", must be"
+			pr_err("Illegal value for \"%s\", must be"
 				" between 0 and 65535.\n", param->name);
 			return -1;
 		}
@@ -857,7 +856,7 @@ static int iscsi_check_numerical_value(struct iscsi_param *param, char *value_pt
 	}
 	if (IS_TYPERANGE_1_TO_65535(param)) {
 		if ((value < 1) || (value > 65535)) {
-			printk(KERN_ERR "Illegal value for \"%s\", must be"
+			pr_err("Illegal value for \"%s\", must be"
 				" between 1 and 65535.\n", param->name);
 			return -1;
 		}
@@ -865,7 +864,7 @@ static int iscsi_check_numerical_value(struct iscsi_param *param, char *value_pt
 	}
 	if (IS_TYPERANGE_2_TO_3600(param)) {
 		if ((value < 2) || (value > 3600)) {
-			printk(KERN_ERR "Illegal value for \"%s\", must be"
+			pr_err("Illegal value for \"%s\", must be"
 				" between 2 and 3600.\n", param->name);
 			return -1;
 		}
@@ -873,7 +872,7 @@ static int iscsi_check_numerical_value(struct iscsi_param *param, char *value_pt
 	}
 	if (IS_TYPERANGE_512_TO_16777215(param)) {
 		if ((value < 512) || (value > 16777215)) {
-			printk(KERN_ERR "Illegal value for \"%s\", must be"
+			pr_err("Illegal value for \"%s\", must be"
 				" between 512 and 16777215.\n", param->name);
 			return -1;
 		}
@@ -891,7 +890,7 @@ static int iscsi_check_numerical_range_value(struct iscsi_param *param, char *va
 
 	if ((strcmp(param->name, IFMARKINT)) &&
 			(strcmp(param->name, OFMARKINT))) {
-		printk(KERN_ERR "Only parameters \"%s\" or \"%s\" may contain a"
+		pr_err("Only parameters \"%s\" or \"%s\" may contain a"
 			" numerical range value.\n", IFMARKINT, OFMARKINT);
 		return -1;
 	}
@@ -901,7 +900,7 @@ static int iscsi_check_numerical_range_value(struct iscsi_param *param, char *va
 
 	tilde_ptr = strchr(value, '~');
 	if (!(tilde_ptr)) {
-		printk(KERN_ERR "Unable to locate numerical range indicator"
+		pr_err("Unable to locate numerical range indicator"
 			" \"~\" for \"%s\".\n", param->name);
 		return -1;
 	}
@@ -920,7 +919,7 @@ static int iscsi_check_numerical_range_value(struct iscsi_param *param, char *va
 	*tilde_ptr = '~';
 
 	if (right_val < left_val) {
-		printk(KERN_ERR "Numerical range for parameter \"%s\" contains"
+		pr_err("Numerical range for parameter \"%s\" contains"
 			" a right value which is less than the left.\n",
 				param->name);
 		return -1;
@@ -931,7 +930,7 @@ static int iscsi_check_numerical_range_value(struct iscsi_param *param, char *va
 	 */
 	tilde_ptr = strchr(param->value, '~');
 	if (!(tilde_ptr)) {
-		printk(KERN_ERR "Unable to locate numerical range indicator"
+		pr_err("Unable to locate numerical range indicator"
 			" \"~\" for \"%s\".\n", param->name);
 		return -1;
 	}
@@ -947,7 +946,7 @@ static int iscsi_check_numerical_range_value(struct iscsi_param *param, char *va
 	if (param->set_param) {
 		if ((left_val < local_left_val) ||
 		    (right_val < local_left_val)) {
-			printk(KERN_ERR "Passed value range \"%u~%u\" is below"
+			pr_err("Passed value range \"%u~%u\" is below"
 				" minimum left value \"%u\" for key \"%s\","
 				" rejecting.\n", left_val, right_val,
 				local_left_val, param->name);
@@ -956,7 +955,7 @@ static int iscsi_check_numerical_range_value(struct iscsi_param *param, char *va
 	} else {
 		if ((left_val < local_left_val) &&
 		    (right_val < local_left_val)) {
-			printk(KERN_ERR "Received value range \"%u~%u\" is"
+			pr_err("Received value range \"%u~%u\" is"
 				" below minimum left value \"%u\" for key"
 				" \"%s\", rejecting.\n", left_val, right_val,
 				local_left_val, param->name);
@@ -978,7 +977,7 @@ static int iscsi_check_string_or_list_value(struct iscsi_param *param, char *val
 		if (strcmp(value, KRB5) && strcmp(value, SPKM1) &&
 		    strcmp(value, SPKM2) && strcmp(value, SRP) &&
 		    strcmp(value, CHAP) && strcmp(value, NONE)) {
-			printk(KERN_ERR "Illegal value for \"%s\", must be"
+			pr_err("Illegal value for \"%s\", must be"
 				" \"%s\", \"%s\", \"%s\", \"%s\", \"%s\""
 				" or \"%s\".\n", param->name, KRB5,
 					SPKM1, SPKM2, SRP, CHAP, NONE);
@@ -987,7 +986,7 @@ static int iscsi_check_string_or_list_value(struct iscsi_param *param, char *val
 	}
 	if (IS_TYPERANGE_DIGEST_PARAM(param)) {
 		if (strcmp(value, CRC32C) && strcmp(value, NONE)) {
-			printk(KERN_ERR "Illegal value for \"%s\", must be"
+			pr_err("Illegal value for \"%s\", must be"
 				" \"%s\" or \"%s\".\n", param->name,
 					CRC32C, NONE);
 			return -1;
@@ -995,7 +994,7 @@ static int iscsi_check_string_or_list_value(struct iscsi_param *param, char *val
 	}
 	if (IS_TYPERANGE_SESSIONTYPE(param)) {
 		if (strcmp(value, DISCOVERY) && strcmp(value, NORMAL)) {
-			printk(KERN_ERR "Illegal value for \"%s\", must be"
+			pr_err("Illegal value for \"%s\", must be"
 				" \"%s\" or \"%s\".\n", param->name,
 					DISCOVERY, NORMAL);
 			return -1;
@@ -1092,7 +1091,7 @@ static int iscsi_check_acceptor_state(struct iscsi_param *param, char *value)
 	char *negoitated_value = NULL;
 
 	if (IS_PSTATE_ACCEPTOR(param)) {
-		printk(KERN_ERR "Received key \"%s\" twice, protocol error.\n",
+		pr_err("Received key \"%s\" twice, protocol error.\n",
 				param->name);
 		return -1;
 	}
@@ -1174,7 +1173,7 @@ static int iscsi_check_acceptor_state(struct iscsi_param *param, char *value)
 		negoitated_value = iscsi_check_valuelist_for_support(
 					param, value);
 		if (!(negoitated_value)) {
-			printk(KERN_ERR "Proposer's value list \"%s\" contains"
+			pr_err("Proposer's value list \"%s\" contains"
 				" no valid values from Acceptor's value list"
 				" \"%s\".\n", value, param->value);
 			return -1;
@@ -1193,7 +1192,7 @@ static int iscsi_check_acceptor_state(struct iscsi_param *param, char *value)
 static int iscsi_check_proposer_state(struct iscsi_param *param, char *value)
 {
 	if (IS_PSTATE_RESPONSE_GOT(param)) {
-		printk(KERN_ERR "Received key \"%s\" twice, protocol error.\n",
+		pr_err("Received key \"%s\" twice, protocol error.\n",
 				param->name);
 		return -1;
 	}
@@ -1211,13 +1210,13 @@ static int iscsi_check_proposer_state(struct iscsi_param *param, char *value)
 
 		tilde_ptr = strchr(value, '~');
 		if ((tilde_ptr)) {
-			printk(KERN_ERR "Illegal \"~\" in response for \"%s\".\n",
+			pr_err("Illegal \"~\" in response for \"%s\".\n",
 					param->name);
 			return -1;
 		}
 		tilde_ptr = strchr(param->value, '~');
 		if (!(tilde_ptr)) {
-			printk(KERN_ERR "Unable to locate numerical range"
+			pr_err("Unable to locate numerical range"
 				" indicator \"~\" for \"%s\".\n", param->name);
 			return -1;
 		}
@@ -1233,7 +1232,7 @@ static int iscsi_check_proposer_state(struct iscsi_param *param, char *value)
 
 		if ((recieved_value < left_val) ||
 		    (recieved_value > right_val)) {
-			printk(KERN_ERR "Illegal response \"%s=%u\", value must"
+			pr_err("Illegal response \"%s=%u\", value must"
 				" be between %u and %u.\n", param->name,
 				recieved_value, left_val, right_val);
 			return -1;
@@ -1243,7 +1242,7 @@ static int iscsi_check_proposer_state(struct iscsi_param *param, char *value)
 
 		comma_ptr = strchr(value, ',');
 		if ((comma_ptr)) {
-			printk(KERN_ERR "Illegal \",\" in response for \"%s\".\n",
+			pr_err("Illegal \",\" in response for \"%s\".\n",
 					param->name);
 			return -1;
 		}
@@ -1273,23 +1272,23 @@ static int iscsi_check_value(struct iscsi_param *param, char *value)
 			SET_PSTATE_REJECT(param);
 			return 0;
 		}
-		printk(KERN_ERR "Received %s=%s\n", param->name, value);
+		pr_err("Received %s=%s\n", param->name, value);
 		return -1;
 	}
 	if (!strcmp(value, IRRELEVANT)) {
-		TRACE(TRACE_LOGIN, "Received %s=%s\n", param->name, value);
+		pr_debug("Received %s=%s\n", param->name, value);
 		SET_PSTATE_IRRELEVANT(param);
 		return 0;
 	}
 	if (!strcmp(value, NOTUNDERSTOOD)) {
 		if (!IS_PSTATE_PROPOSER(param)) {
-			printk(KERN_ERR "Received illegal offer %s=%s\n",
+			pr_err("Received illegal offer %s=%s\n",
 				param->name, value);
 			return -1;
 		}
 
 /* #warning FIXME: Add check for X-ExtensionKey here */
-		printk(KERN_ERR "Standard iSCSI key \"%s\" cannot be answered"
+		pr_err("Standard iSCSI key \"%s\" cannot be answered"
 			" with \"%s\", protocol error.\n", param->name, value);
 		return -1;
 	}
@@ -1299,7 +1298,7 @@ static int iscsi_check_value(struct iscsi_param *param, char *value)
 		comma_ptr = strchr(value, ',');
 
 		if (comma_ptr && !IS_TYPE_VALUE_LIST(param)) {
-			printk(KERN_ERR "Detected value seperator \",\", but"
+			pr_err("Detected value seperator \",\", but"
 				" key \"%s\" does not allow a value list,"
 				" protocol error.\n", param->name);
 			return -1;
@@ -1308,7 +1307,7 @@ static int iscsi_check_value(struct iscsi_param *param, char *value)
 			*comma_ptr = '\0';
 
 		if (strlen(value) > VALUE_MAXLEN) {
-			printk(KERN_ERR "Value for key \"%s\" exceeds %d,"
+			pr_err("Value for key \"%s\" exceeds %d,"
 				" protocol error.\n", param->name,
 				VALUE_MAXLEN);
 			return -1;
@@ -1327,7 +1326,7 @@ static int iscsi_check_value(struct iscsi_param *param, char *value)
 			if (iscsi_check_string_or_list_value(param, value) < 0)
 				return -1;
 		} else {
-			printk(KERN_ERR "Huh? 0x%02x\n", param->type);
+			pr_err("Huh? 0x%02x\n", param->type);
 			return -1;
 		}
 
@@ -1348,7 +1347,7 @@ static struct iscsi_param *__iscsi_check_key(
 	struct iscsi_param *param;
 
 	if (strlen(key) > KEY_MAXLEN) {
-		printk(KERN_ERR "Length of key name \"%s\" exceeds %d.\n",
+		pr_err("Length of key name \"%s\" exceeds %d.\n",
 			key, KEY_MAXLEN);
 		return NULL;
 	}
@@ -1358,14 +1357,14 @@ static struct iscsi_param *__iscsi_check_key(
 		return NULL;
 
 	if ((sender & SENDER_INITIATOR) && !IS_SENDER_INITIATOR(param)) {
-		printk(KERN_ERR "Key \"%s\" may not be sent to %s,"
+		pr_err("Key \"%s\" may not be sent to %s,"
 			" protocol error.\n", param->name,
 			(sender & SENDER_RECEIVER) ? "target" : "initiator");
 		return NULL;
 	}
 
 	if ((sender & SENDER_TARGET) && !IS_SENDER_TARGET(param)) {
-		printk(KERN_ERR "Key \"%s\" may not be sent to %s,"
+		pr_err("Key \"%s\" may not be sent to %s,"
 			" protocol error.\n", param->name,
 			(sender & SENDER_RECEIVER) ? "initiator" : "target");
 		return NULL;
@@ -1385,7 +1384,7 @@ static struct iscsi_param *iscsi_check_key(
 	 * Key name length must not exceed 63 bytes. (See iSCSI v20 5.1)
 	 */
 	if (strlen(key) > KEY_MAXLEN) {
-		printk(KERN_ERR "Length of key name \"%s\" exceeds %d.\n",
+		pr_err("Length of key name \"%s\" exceeds %d.\n",
 			key, KEY_MAXLEN);
 		return NULL;
 	}
@@ -1395,20 +1394,20 @@ static struct iscsi_param *iscsi_check_key(
 		return NULL;
 
 	if ((sender & SENDER_INITIATOR) && !IS_SENDER_INITIATOR(param)) {
-		printk(KERN_ERR "Key \"%s\" may not be sent to %s,"
+		pr_err("Key \"%s\" may not be sent to %s,"
 			" protocol error.\n", param->name,
 			(sender & SENDER_RECEIVER) ? "target" : "initiator");
 		return NULL;
 	}
 	if ((sender & SENDER_TARGET) && !IS_SENDER_TARGET(param)) {
-		printk(KERN_ERR "Key \"%s\" may not be sent to %s,"
+		pr_err("Key \"%s\" may not be sent to %s,"
 				" protocol error.\n", param->name,
 			(sender & SENDER_RECEIVER) ? "initiator" : "target");
 		return NULL;
 	}
 
 	if (IS_PSTATE_ACCEPTOR(param)) {
-		printk(KERN_ERR "Key \"%s\" received twice, protocol error.\n",
+		pr_err("Key \"%s\" received twice, protocol error.\n",
 				key);
 		return NULL;
 	}
@@ -1417,16 +1416,16 @@ static struct iscsi_param *iscsi_check_key(
 		return param;
 
 	if (!(param->phase & phase)) {
-		printk(KERN_ERR "Key \"%s\" may not be negotiated during ",
+		pr_err("Key \"%s\" may not be negotiated during ",
 				param->name);
 		switch (phase) {
 		case PHASE_SECURITY:
-			printk(KERN_INFO "Security phase.\n");
+			pr_debug("Security phase.\n");
 			break;
 		case PHASE_OPERATIONAL:
-			printk(KERN_INFO "Operational phase.\n");
+			pr_debug("Operational phase.\n");
 		default:
-			printk(KERN_INFO "Unknown phase.\n");
+			pr_debug("Unknown phase.\n");
 		}
 		return NULL;
 	}
@@ -1489,7 +1488,7 @@ static int iscsi_enforce_integrity_rules(
 			if (strcmp(param->value, "1")) {
 				if (iscsi_update_param_value(param, "1") < 0)
 					return -1;
-				TRACE(TRACE_PARAM, "Reset \"%s\" to \"%s\".\n",
+				pr_debug("Reset \"%s\" to \"%s\".\n",
 					param->name, param->value);
 			}
 		}
@@ -1497,7 +1496,7 @@ static int iscsi_enforce_integrity_rules(
 			if (strcmp(param->value, "1")) {
 				if (iscsi_update_param_value(param, "1") < 0)
 					return -1;
-				TRACE(TRACE_PARAM, "Reset \"%s\" to \"%s\".\n",
+				pr_debug("Reset \"%s\" to \"%s\".\n",
 					param->name, param->value);
 			}
 		}
@@ -1510,7 +1509,7 @@ static int iscsi_enforce_integrity_rules(
 				sprintf(tmpbuf, "%u", MaxBurstLength);
 				if (iscsi_update_param_value(param, tmpbuf))
 					return -1;
-				TRACE(TRACE_PARAM, "Reset \"%s\" to \"%s\".\n",
+				pr_debug("Reset \"%s\" to \"%s\".\n",
 					param->name, param->value);
 			}
 		}
@@ -1518,14 +1517,14 @@ static int iscsi_enforce_integrity_rules(
 			if (iscsi_update_param_value(param, NO) < 0)
 				return -1;
 			IFMarker = 0;
-			TRACE(TRACE_PARAM, "Reset \"%s\" to \"%s\".\n",
+			pr_debug("Reset \"%s\" to \"%s\".\n",
 					param->name, param->value);
 		}
 		if (!strcmp(param->name, OFMARKER) && OFMarkInt_Reject) {
 			if (iscsi_update_param_value(param, NO) < 0)
 				return -1;
 			OFMarker = 0;
-			TRACE(TRACE_PARAM, "Reset \"%s\" to \"%s\".\n",
+			pr_debug("Reset \"%s\" to \"%s\".\n",
 					 param->name, param->value);
 		}
 		if (!strcmp(param->name, IFMARKINT) && !IFMarker) {
@@ -1534,7 +1533,7 @@ static int iscsi_enforce_integrity_rules(
 			param->state &= ~PSTATE_NEGOTIATE;
 			if (iscsi_update_param_value(param, IRRELEVANT) < 0)
 				return -1;
-			TRACE(TRACE_PARAM, "Reset \"%s\" to \"%s\".\n",
+			pr_debug("Reset \"%s\" to \"%s\".\n",
 					param->name, param->value);
 		}
 		if (!strcmp(param->name, OFMARKINT) && !OFMarker) {
@@ -1543,7 +1542,7 @@ static int iscsi_enforce_integrity_rules(
 			param->state &= ~PSTATE_NEGOTIATE;
 			if (iscsi_update_param_value(param, IRRELEVANT) < 0)
 				return -1;
-			TRACE(TRACE_PARAM, "Reset \"%s\" to \"%s\".\n",
+			pr_debug("Reset \"%s\" to \"%s\".\n",
 					param->name, param->value);
 		}
 	}
@@ -1562,7 +1561,7 @@ int iscsi_decode_text_input(
 
 	tmpbuf = kzalloc(length + 1, GFP_KERNEL);
 	if (!(tmpbuf)) {
-		printk(KERN_ERR "Unable to allocate memory for tmpbuf.\n");
+		pr_err("Unable to allocate memory for tmpbuf.\n");
 		return -1;
 	}
 
@@ -1580,7 +1579,7 @@ int iscsi_decode_text_input(
 			return -1;
 		}
 
-		TRACE(TRACE_PARAM, "Got key: %s=%s\n", key, value);
+		pr_debug("Got key: %s=%s\n", key, value);
 
 		if (phase & PHASE_SECURITY) {
 			if (iscsi_check_for_auth_key(key) > 0) {
@@ -1655,7 +1654,7 @@ int iscsi_encode_text_output(
 			*length += 1;
 			output_buf = textbuf + *length;
 			SET_PSTATE_RESPONSE_SENT(param);
-			TRACE(TRACE_PARAM, "Sending key: %s=%s\n",
+			pr_debug("Sending key: %s=%s\n",
 				param->name, param->value);
 			continue;
 		}
@@ -1669,7 +1668,7 @@ int iscsi_encode_text_output(
 			output_buf = textbuf + *length;
 			SET_PSTATE_PROPOSER(param);
 			iscsi_check_proposer_for_optional_reply(param);
-			TRACE(TRACE_PARAM, "Sending key: %s=%s\n",
+			pr_debug("Sending key: %s=%s\n",
 				param->name, param->value);
 		}
 	}
@@ -1678,7 +1677,7 @@ int iscsi_encode_text_output(
 		*length += sprintf(output_buf, "%s=%s", er->key, er->value);
 		*length += 1;
 		output_buf = textbuf + *length;
-		TRACE(TRACE_PARAM, "Sending key: %s=%s\n", er->key, er->value);
+		pr_debug("Sending key: %s=%s\n", er->key, er->value);
 	}
 	iscsi_release_extra_responses(param_list);
 
@@ -1696,7 +1695,7 @@ int iscsi_check_negotiated_keys(struct iscsi_param_list *param_list)
 		    !IS_PSTATE_RESPONSE_GOT(param) &&
 		    !IS_PSTATE_REPLY_OPTIONAL(param) &&
 		    !IS_PHASE_DECLARATIVE(param)) {
-			printk(KERN_ERR "No response for proposed key \"%s\".\n",
+			pr_err("No response for proposed key \"%s\".\n",
 					param->name);
 			ret = -1;
 		}
@@ -1747,48 +1746,48 @@ void iscsi_set_connection_parameters(
 	char *tmpptr;
 	struct iscsi_param *param;
 
-	printk(KERN_INFO "---------------------------------------------------"
+	pr_debug("---------------------------------------------------"
 			"---------------\n");
 	list_for_each_entry(param, &param_list->param_list, p_list) {
 		if (!IS_PSTATE_ACCEPTOR(param) && !IS_PSTATE_PROPOSER(param))
 			continue;
 		if (!strcmp(param->name, AUTHMETHOD)) {
-			printk(KERN_INFO "AuthMethod:                   %s\n",
+			pr_debug("AuthMethod:                   %s\n",
 				param->value);
 		} else if (!strcmp(param->name, HEADERDIGEST)) {
 			ops->HeaderDigest = !strcmp(param->value, CRC32C);
-			printk(KERN_INFO "HeaderDigest:                 %s\n",
+			pr_debug("HeaderDigest:                 %s\n",
 				param->value);
 		} else if (!strcmp(param->name, DATADIGEST)) {
 			ops->DataDigest = !strcmp(param->value, CRC32C);
-			printk(KERN_INFO "DataDigest:                   %s\n",
+			pr_debug("DataDigest:                   %s\n",
 				param->value);
 		} else if (!strcmp(param->name, MAXRECVDATASEGMENTLENGTH)) {
 			ops->MaxRecvDataSegmentLength =
 				simple_strtoul(param->value, &tmpptr, 0);
-			printk(KERN_INFO "MaxRecvDataSegmentLength:     %s\n",
+			pr_debug("MaxRecvDataSegmentLength:     %s\n",
 				param->value);
 		} else if (!strcmp(param->name, OFMARKER)) {
 			ops->OFMarker = !strcmp(param->value, YES);
-			printk(KERN_INFO "OFMarker:                     %s\n",
+			pr_debug("OFMarker:                     %s\n",
 				param->value);
 		} else if (!strcmp(param->name, IFMARKER)) {
 			ops->IFMarker = !strcmp(param->value, YES);
-			printk(KERN_INFO "IFMarker:                     %s\n",
+			pr_debug("IFMarker:                     %s\n",
 				param->value);
 		} else if (!strcmp(param->name, OFMARKINT)) {
 			ops->OFMarkInt =
 				simple_strtoul(param->value, &tmpptr, 0);
-			printk(KERN_INFO "OFMarkInt:                    %s\n",
+			pr_debug("OFMarkInt:                    %s\n",
 				param->value);
 		} else if (!strcmp(param->name, IFMARKINT)) {
 			ops->IFMarkInt =
 				simple_strtoul(param->value, &tmpptr, 0);
-			printk(KERN_INFO "IFMarkInt:                    %s\n",
+			pr_debug("IFMarkInt:                    %s\n",
 				param->value);
 		}
 	}
-	printk(KERN_INFO "----------------------------------------------------"
+	pr_debug("----------------------------------------------------"
 			"--------------\n");
 }
 
@@ -1800,7 +1799,7 @@ void iscsi_set_session_parameters(
 	char *tmpptr;
 	struct iscsi_param *param;
 
-	printk(KERN_INFO "----------------------------------------------------"
+	pr_debug("----------------------------------------------------"
 			"--------------\n");
 	list_for_each_entry(param, &param_list->param_list, p_list) {
 		if (!IS_PSTATE_ACCEPTOR(param) && !IS_PSTATE_PROPOSER(param))
@@ -1812,7 +1811,7 @@ void iscsi_set_session_parameters(
 				snprintf(ops->InitiatorName,
 						sizeof(ops->InitiatorName),
 						"%s", param->value);
-			printk(KERN_INFO "InitiatorName:                %s\n",
+			pr_debug("InitiatorName:                %s\n",
 				param->value);
 		} else if (!strcmp(param->name, INITIATORALIAS)) {
 			if (!param->value)
@@ -1820,7 +1819,7 @@ void iscsi_set_session_parameters(
 			snprintf(ops->InitiatorAlias,
 						sizeof(ops->InitiatorAlias),
 						"%s", param->value);
-			printk(KERN_INFO "InitiatorAlias:               %s\n",
+			pr_debug("InitiatorAlias:               %s\n",
 				param->value);
 		} else if (!strcmp(param->name, TARGETNAME)) {
 			if (!param->value)
@@ -1829,78 +1828,78 @@ void iscsi_set_session_parameters(
 				snprintf(ops->TargetName,
 						sizeof(ops->TargetName),
 						"%s", param->value);
-			printk(KERN_INFO "TargetName:                   %s\n",
+			pr_debug("TargetName:                   %s\n",
 				param->value);
 		} else if (!strcmp(param->name, TARGETALIAS)) {
 			if (!param->value)
 				continue;
 			snprintf(ops->TargetAlias, sizeof(ops->TargetAlias),
 					"%s", param->value);
-			printk(KERN_INFO "TargetAlias:                  %s\n",
+			pr_debug("TargetAlias:                  %s\n",
 				param->value);
 		} else if (!strcmp(param->name, TARGETPORTALGROUPTAG)) {
 			ops->TargetPortalGroupTag =
 				simple_strtoul(param->value, &tmpptr, 0);
-			printk(KERN_INFO "TargetPortalGroupTag:         %s\n",
+			pr_debug("TargetPortalGroupTag:         %s\n",
 				param->value);
 		} else if (!strcmp(param->name, MAXCONNECTIONS)) {
 			ops->MaxConnections =
 				simple_strtoul(param->value, &tmpptr, 0);
-			printk(KERN_INFO "MaxConnections:               %s\n",
+			pr_debug("MaxConnections:               %s\n",
 				param->value);
 		} else if (!strcmp(param->name, INITIALR2T)) {
 			ops->InitialR2T = !strcmp(param->value, YES);
-			 printk(KERN_INFO "InitialR2T:                   %s\n",
+			 pr_debug("InitialR2T:                   %s\n",
 				param->value);
 		} else if (!strcmp(param->name, IMMEDIATEDATA)) {
 			ops->ImmediateData = !strcmp(param->value, YES);
-			printk(KERN_INFO "ImmediateData:                %s\n",
+			pr_debug("ImmediateData:                %s\n",
 				param->value);
 		} else if (!strcmp(param->name, MAXBURSTLENGTH)) {
 			ops->MaxBurstLength =
 				simple_strtoul(param->value, &tmpptr, 0);
-			printk(KERN_INFO "MaxBurstLength:               %s\n",
+			pr_debug("MaxBurstLength:               %s\n",
 				param->value);
 		} else if (!strcmp(param->name, FIRSTBURSTLENGTH)) {
 			ops->FirstBurstLength =
 				simple_strtoul(param->value, &tmpptr, 0);
-			printk(KERN_INFO "FirstBurstLength:             %s\n",
+			pr_debug("FirstBurstLength:             %s\n",
 				param->value);
 		} else if (!strcmp(param->name, DEFAULTTIME2WAIT)) {
 			ops->DefaultTime2Wait =
 				simple_strtoul(param->value, &tmpptr, 0);
-			printk(KERN_INFO "DefaultTime2Wait:             %s\n",
+			pr_debug("DefaultTime2Wait:             %s\n",
 				param->value);
 		} else if (!strcmp(param->name, DEFAULTTIME2RETAIN)) {
 			ops->DefaultTime2Retain =
 				simple_strtoul(param->value, &tmpptr, 0);
-			printk(KERN_INFO "DefaultTime2Retain:           %s\n",
+			pr_debug("DefaultTime2Retain:           %s\n",
 				param->value);
 		} else if (!strcmp(param->name, MAXOUTSTANDINGR2T)) {
 			ops->MaxOutstandingR2T =
 				simple_strtoul(param->value, &tmpptr, 0);
-			printk(KERN_INFO "MaxOutstandingR2T:            %s\n",
+			pr_debug("MaxOutstandingR2T:            %s\n",
 				param->value);
 		} else if (!strcmp(param->name, DATAPDUINORDER)) {
 			ops->DataPDUInOrder = !strcmp(param->value, YES);
-			printk(KERN_INFO "DataPDUInOrder:               %s\n",
+			pr_debug("DataPDUInOrder:               %s\n",
 				param->value);
 		} else if (!strcmp(param->name, DATASEQUENCEINORDER)) {
 			ops->DataSequenceInOrder = !strcmp(param->value, YES);
-			printk(KERN_INFO "DataSequenceInOrder:          %s\n",
+			pr_debug("DataSequenceInOrder:          %s\n",
 				param->value);
 		} else if (!strcmp(param->name, ERRORRECOVERYLEVEL)) {
 			ops->ErrorRecoveryLevel =
 				simple_strtoul(param->value, &tmpptr, 0);
-			printk(KERN_INFO "ErrorRecoveryLevel:           %s\n",
+			pr_debug("ErrorRecoveryLevel:           %s\n",
 				param->value);
 		} else if (!strcmp(param->name, SESSIONTYPE)) {
 			ops->SessionType = !strcmp(param->value, DISCOVERY);
-			printk(KERN_INFO "SessionType:                  %s\n",
+			pr_debug("SessionType:                  %s\n",
 				param->value);
 		}
 	}
-	printk(KERN_INFO "----------------------------------------------------"
+	pr_debug("----------------------------------------------------"
 			"--------------\n");
 
 }
diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
index d787bb6..f0965a3 100644
--- a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
@@ -22,7 +22,6 @@
 #include <linux/slab.h>
 #include <linux/random.h>
 
-#include "iscsi_target_debug.h"
 #include "iscsi_target_core.h"
 #include "iscsi_target_util.h"
 #include "iscsi_target_seq_pdu_list.h"
@@ -34,12 +33,12 @@ void iscsit_dump_seq_list(struct iscsi_cmd *cmd)
 	int i;
 	struct iscsi_seq *seq;
 
-	printk(KERN_INFO "Dumping Sequence List for ITT: 0x%08x:\n",
+	pr_debug("Dumping Sequence List for ITT: 0x%08x:\n",
 			cmd->init_task_tag);
 
 	for (i = 0; i < cmd->seq_count; i++) {
 		seq = &cmd->seq_list[i];
-		printk(KERN_INFO "i: %d, pdu_start: %d, pdu_count: %d,"
+		pr_debug("i: %d, pdu_start: %d, pdu_count: %d,"
 			" offset: %d, xfer_len: %d, seq_send_order: %d,"
 			" seq_no: %d\n", i, seq->pdu_start, seq->pdu_count,
 			seq->offset, seq->xfer_len, seq->seq_send_order,
@@ -52,12 +51,12 @@ void iscsit_dump_pdu_list(struct iscsi_cmd *cmd)
 	int i;
 	struct iscsi_pdu *pdu;
 
-	printk(KERN_INFO "Dumping PDU List for ITT: 0x%08x:\n",
+	pr_debug("Dumping PDU List for ITT: 0x%08x:\n",
 			cmd->init_task_tag);
 
 	for (i = 0; i < cmd->pdu_count; i++) {
 		pdu = &cmd->pdu_list[i];
-		printk(KERN_INFO "i: %d, offset: %d, length: %d,"
+		pr_debug("i: %d, offset: %d, length: %d,"
 			" pdu_send_order: %d, seq_no: %d\n", i, pdu->offset,
 			pdu->length, pdu->pdu_send_order, pdu->seq_no);
 	}
@@ -138,7 +137,7 @@ redo:
 		}
 		array = kzalloc(seq_count * sizeof(u32), GFP_KERNEL);
 		if (!(array)) {
-			printk(KERN_ERR "Unable to allocate memory"
+			pr_err("Unable to allocate memory"
 				" for random array.\n");
 			return -1;
 		}
@@ -158,7 +157,7 @@ redo:
 	if (seq_count) {
 		array = kzalloc(seq_count * sizeof(u32), GFP_KERNEL);
 		if (!(array)) {
-			printk(KERN_ERR "Unable to allocate memory for"
+			pr_err("Unable to allocate memory for"
 				" random array.\n");
 			return -1;
 		}
@@ -190,7 +189,7 @@ static int iscsit_randomize_seq_lists(
 
 	array = kzalloc(seq_count * sizeof(u32), GFP_KERNEL);
 	if (!(array)) {
-		printk(KERN_ERR "Unable to allocate memory for random array.\n");
+		pr_err("Unable to allocate memory for random array.\n");
 		return -1;
 	}
 	iscsit_create_random_array(array, seq_count);
@@ -510,7 +509,7 @@ int iscsit_do_build_list(
 	if (!conn->sess->sess_ops->DataSequenceInOrder) {
 		seq = kzalloc(seq_count * sizeof(struct iscsi_seq), GFP_ATOMIC);
 		if (!(seq)) {
-			printk(KERN_ERR "Unable to allocate struct iscsi_seq list\n");
+			pr_err("Unable to allocate struct iscsi_seq list\n");
 			return -1;
 		}
 		cmd->seq_list = seq;
@@ -520,7 +519,7 @@ int iscsit_do_build_list(
 	if (!conn->sess->sess_ops->DataPDUInOrder) {
 		pdu = kzalloc(pdu_count * sizeof(struct iscsi_pdu), GFP_ATOMIC);
 		if (!(pdu)) {
-			printk(KERN_ERR "Unable to allocate struct iscsi_pdu list.\n");
+			pr_err("Unable to allocate struct iscsi_pdu list.\n");
 			kfree(seq);
 			return -1;
 		}
@@ -540,7 +539,7 @@ struct iscsi_pdu *iscsit_get_pdu_holder(
 	struct iscsi_pdu *pdu = NULL;
 
 	if (!cmd->pdu_list) {
-		printk(KERN_ERR "struct iscsi_cmd->pdu_list is NULL!\n");
+		pr_err("struct iscsi_cmd->pdu_list is NULL!\n");
 		return NULL;
 	}
 
@@ -550,7 +549,7 @@ struct iscsi_pdu *iscsit_get_pdu_holder(
 		if ((pdu[i].offset == offset) && (pdu[i].length == length))
 			return &pdu[i];
 
-	printk(KERN_ERR "Unable to locate PDU holder for ITT: 0x%08x, Offset:"
+	pr_err("Unable to locate PDU holder for ITT: 0x%08x, Offset:"
 		" %u, Length: %u\n", cmd->init_task_tag, offset, length);
 	return NULL;
 }
@@ -564,7 +563,7 @@ struct iscsi_pdu *iscsit_get_pdu_holder_for_seq(
 	struct iscsi_pdu *pdu = NULL;
 
 	if (!cmd->pdu_list) {
-		printk(KERN_ERR "struct iscsi_cmd->pdu_list is NULL!\n");
+		pr_err("struct iscsi_cmd->pdu_list is NULL!\n");
 		return NULL;
 	}
 
@@ -574,7 +573,7 @@ redo:
 
 		for (i = 0; pdu[i].seq_no != cmd->seq_no; i++) {
 #if 0
-			printk(KERN_INFO "pdu[i].seq_no: %d, pdu[i].pdu"
+			pr_debug("pdu[i].seq_no: %d, pdu[i].pdu"
 				"_send_order: %d, pdu[i].offset: %d,"
 				" pdu[i].length: %d\n", pdu[i].seq_no,
 				pdu[i].pdu_send_order, pdu[i].offset,
@@ -593,24 +592,24 @@ redo:
 		if (cmd->pdu_start < cmd->pdu_count)
 			goto redo;
 
-		printk(KERN_ERR "Command ITT: 0x%08x unable to locate"
+		pr_err("Command ITT: 0x%08x unable to locate"
 			" struct iscsi_pdu for cmd->pdu_send_order: %u.\n",
 			cmd->init_task_tag, cmd->pdu_send_order);
 		return NULL;
 	} else {
 		if (!seq) {
-			printk(KERN_ERR "struct iscsi_seq is NULL!\n");
+			pr_err("struct iscsi_seq is NULL!\n");
 			return NULL;
 		}
 #if 0
-		printk(KERN_INFO "seq->pdu_start: %d, seq->pdu_count: %d,"
+		pr_debug("seq->pdu_start: %d, seq->pdu_count: %d,"
 			" seq->seq_no: %d\n", seq->pdu_start, seq->pdu_count,
 			seq->seq_no);
 #endif
 		pdu = &cmd->pdu_list[seq->pdu_start];
 
 		if (seq->pdu_send_order == seq->pdu_count) {
-			printk(KERN_ERR "Command ITT: 0x%08x seq->pdu_send"
+			pr_err("Command ITT: 0x%08x seq->pdu_send"
 				"_order: %u equals seq->pdu_count: %u\n",
 				cmd->init_task_tag, seq->pdu_send_order,
 				seq->pdu_count);
@@ -624,7 +623,7 @@ redo:
 			}
 		}
 
-		printk(KERN_ERR "Command ITT: 0x%08x unable to locate iscsi"
+		pr_err("Command ITT: 0x%08x unable to locate iscsi"
 			"_pdu_t for seq->pdu_send_order: %u.\n",
 			cmd->init_task_tag, seq->pdu_send_order);
 		return NULL;
@@ -641,13 +640,13 @@ struct iscsi_seq *iscsit_get_seq_holder(
 	u32 i;
 
 	if (!cmd->seq_list) {
-		printk(KERN_ERR "struct iscsi_cmd->seq_list is NULL!\n");
+		pr_err("struct iscsi_cmd->seq_list is NULL!\n");
 		return NULL;
 	}
 
 	for (i = 0; i < cmd->seq_count; i++) {
 #if 0
-		printk(KERN_INFO "seq_list[i].orig_offset: %d, seq_list[i]."
+		pr_debug("seq_list[i].orig_offset: %d, seq_list[i]."
 			"xfer_len: %d, seq_list[i].seq_no %u\n",
 			cmd->seq_list[i].orig_offset, cmd->seq_list[i].xfer_len,
 			cmd->seq_list[i].seq_no);
@@ -658,7 +657,7 @@ struct iscsi_seq *iscsit_get_seq_holder(
 			return &cmd->seq_list[i];
 	}
 
-	printk(KERN_ERR "Unable to locate Sequence holder for ITT: 0x%08x,"
+	pr_err("Unable to locate Sequence holder for ITT: 0x%08x,"
 		" Offset: %u, Length: %u\n", cmd->init_task_tag, offset,
 		length);
 	return NULL;
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index 5d0bc07..1183c04 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -23,7 +23,6 @@
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>
 
-#include "iscsi_target_debug.h"
 #include "iscsi_target_core.h"
 #include "iscsi_target_seq_pdu_list.h"
 #include "iscsi_target_datain_values.h"
@@ -48,14 +47,14 @@ u8 iscsit_tmr_abort_task(
 
 	ref_cmd = iscsit_find_cmd_from_itt(conn, hdr->rtt);
 	if (!ref_cmd) {
-		printk(KERN_ERR "Unable to locate RefTaskTag: 0x%08x on CID:"
+		pr_err("Unable to locate RefTaskTag: 0x%08x on CID:"
 			" %hu.\n", hdr->rtt, conn->cid);
 		return ((hdr->refcmdsn >= conn->sess->exp_cmd_sn) &&
 			(hdr->refcmdsn <= conn->sess->max_cmd_sn)) ?
 			ISCSI_TMF_RSP_COMPLETE : ISCSI_TMF_RSP_NO_TASK;
 	}
 	if (ref_cmd->cmd_sn != hdr->refcmdsn) {
-		printk(KERN_ERR "RefCmdSN 0x%08x does not equal"
+		pr_err("RefCmdSN 0x%08x does not equal"
 			" task's CmdSN 0x%08x. Rejecting ABORT_TASK.\n",
 			hdr->refcmdsn, ref_cmd->cmd_sn);
 		return ISCSI_TMF_RSP_REJECTED;
@@ -84,7 +83,7 @@ int iscsit_tmr_task_warm_reset(
 		(struct iscsi_init_task_mgt_cmnd *) buf;
 #endif
 	if (!na->tmr_warm_reset) {
-		printk(KERN_ERR "TMR Opcode TARGET_WARM_RESET authorization"
+		pr_err("TMR Opcode TARGET_WARM_RESET authorization"
 			" failed for Initiator Node: %s\n",
 			sess->se_sess->se_node_acl->initiatorname);
 		 return -1;
@@ -104,7 +103,7 @@ int iscsit_tmr_task_cold_reset(
 	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
 	if (!na->tmr_cold_reset) {
-		printk(KERN_ERR "TMR Opcode TARGET_COLD_RESET authorization"
+		pr_err("TMR Opcode TARGET_COLD_RESET authorization"
 			" failed for Initiator Node: %s\n",
 			sess->se_sess->se_node_acl->initiatorname);
 		return -1;
@@ -127,23 +126,23 @@ u8 iscsit_tmr_task_reassign(
 	struct iscsi_tm *hdr = (struct iscsi_tm *) buf;
 	int ret;
 
-	TRACE(TRACE_ERL2, "Got TASK_REASSIGN TMR ITT: 0x%08x,"
+	pr_debug("Got TASK_REASSIGN TMR ITT: 0x%08x,"
 		" RefTaskTag: 0x%08x, ExpDataSN: 0x%08x, CID: %hu\n",
 		hdr->itt, hdr->rtt, hdr->exp_datasn, conn->cid);
 
 	if (conn->sess->sess_ops->ErrorRecoveryLevel != 2) {
-		printk(KERN_ERR "TMR TASK_REASSIGN not supported in ERL<2,"
+		pr_err("TMR TASK_REASSIGN not supported in ERL<2,"
 				" ignoring request.\n");
 		return ISCSI_TMF_RSP_NOT_SUPPORTED;
 	}
 
 	ret = iscsit_find_cmd_for_recovery(conn->sess, &ref_cmd, &cr, hdr->rtt);
 	if (ret == -2) {
-		printk(KERN_ERR "Command ITT: 0x%08x is still alligent to CID:"
+		pr_err("Command ITT: 0x%08x is still alligent to CID:"
 			" %hu\n", ref_cmd->init_task_tag, cr->cid);
 		return ISCSI_TMF_RSP_TASK_ALLEGIANT;
 	} else if (ret == -1) {
-		printk(KERN_ERR "Unable to locate RefTaskTag: 0x%08x in"
+		pr_err("Unable to locate RefTaskTag: 0x%08x in"
 			" connection recovery command list.\n", hdr->rtt);
 		return ISCSI_TMF_RSP_NO_TASK;
 	}
@@ -153,7 +152,7 @@ u8 iscsit_tmr_task_reassign(
 	 */
 	if (cr->maxrecvdatasegmentlength !=
 	    conn->conn_ops->MaxRecvDataSegmentLength) {
-		printk(KERN_ERR "Unable to perform connection recovery for"
+		pr_err("Unable to perform connection recovery for"
 			" differing MaxRecvDataSegmentLength, rejecting"
 			" TMR TASK_REASSIGN.\n");
 		return ISCSI_TMF_RSP_REJECTED;
@@ -185,7 +184,7 @@ static void iscsit_task_reassign_remove_cmd(
 	ret = iscsit_remove_cmd_from_connection_recovery(cmd, sess);
 	spin_unlock(&cr->conn_recovery_cmd_lock);
 	if (!ret) {
-		printk(KERN_INFO "iSCSI connection recovery successful for CID:"
+		pr_debug("iSCSI connection recovery successful for CID:"
 			" %hu on SID: %u\n", cr->cid, sess->sid);
 		iscsit_remove_active_connection_recovery_entry(cr, sess);
 	}
@@ -201,7 +200,7 @@ static int iscsit_task_reassign_complete_nop_out(
 	struct iscsi_conn_recovery *cr;
 
 	if (!cmd->cr) {
-		printk(KERN_ERR "struct iscsi_conn_recovery pointer for ITT: 0x%08x"
+		pr_err("struct iscsi_conn_recovery pointer for ITT: 0x%08x"
 			" is NULL!\n", cmd->init_task_tag);
 		return -1;
 	}
@@ -252,7 +251,7 @@ static int iscsit_task_reassign_complete_write(
 	 */
 	if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
 		if (!atomic_read(&cmd->transport_sent)) {
-			TRACE(TRACE_ERL2, "WRITE ITT: 0x%08x: t_state: %d"
+			pr_debug("WRITE ITT: 0x%08x: t_state: %d"
 				" never sent to transport\n",
 				cmd->init_task_tag, cmd->se_cmd.t_state);
 			return transport_generic_handle_data(se_cmd);
@@ -316,7 +315,7 @@ static int iscsit_task_reassign_complete_read(
 	}
 
 	if (!atomic_read(&cmd->transport_sent)) {
-		printk(KERN_INFO "READ ITT: 0x%08x: t_state: %d never sent to"
+		pr_debug("READ ITT: 0x%08x: t_state: %d never sent to"
 			" transport\n", cmd->init_task_tag,
 			SE_CMD(cmd)->t_state);
 		transport_generic_handle_cdb(se_cmd);
@@ -324,7 +323,7 @@ static int iscsit_task_reassign_complete_read(
 	}
 
 	if (!atomic_read(&se_cmd->t_transport_complete)) {
-		printk(KERN_ERR "READ ITT: 0x%08x: t_state: %d, never returned"
+		pr_err("READ ITT: 0x%08x: t_state: %d, never returned"
 			" from transport\n", cmd->init_task_tag,
 			SE_CMD(cmd)->t_state);
 		return -1;
@@ -370,7 +369,7 @@ static int iscsit_task_reassign_complete_scsi_cmnd(
 	struct iscsi_conn_recovery *cr;
 
 	if (!cmd->cr) {
-		printk(KERN_ERR "struct iscsi_conn_recovery pointer for ITT: 0x%08x"
+		pr_err("struct iscsi_conn_recovery pointer for ITT: 0x%08x"
 			" is NULL!\n", cmd->init_task_tag);
 		return -1;
 	}
@@ -403,7 +402,7 @@ static int iscsit_task_reassign_complete_scsi_cmnd(
 	case DMA_NONE:
 		return iscsit_task_reassign_complete_none(cmd, tmr_req);
 	default:
-		printk(KERN_ERR "Unknown cmd->data_direction: 0x%02x\n",
+		pr_err("Unknown cmd->data_direction: 0x%02x\n",
 				cmd->data_direction);
 		return -1;
 	}
@@ -421,7 +420,7 @@ static int iscsit_task_reassign_complete(
 	int ret = 0;
 
 	if (!se_tmr->ref_cmd) {
-		printk(KERN_ERR "TMR Request is missing a RefCmd struct iscsi_cmd.\n");
+		pr_err("TMR Request is missing a RefCmd struct iscsi_cmd.\n");
 		return -1;
 	}
 	se_cmd = se_tmr->ref_cmd;
@@ -437,7 +436,7 @@ static int iscsit_task_reassign_complete(
 		ret = iscsit_task_reassign_complete_scsi_cmnd(tmr_req, conn);
 		break;
 	default:
-		 printk(KERN_ERR "Illegal iSCSI Opcode 0x%02x during"
+		 pr_err("Illegal iSCSI Opcode 0x%02x during"
 			" command realligence\n", cmd->iscsi_opcode);
 		return -1;
 	}
@@ -445,7 +444,7 @@ static int iscsit_task_reassign_complete(
 	if (ret != 0)
 		return ret;
 
-	TRACE(TRACE_ERL2, "Completed connection realligence for Opcode: 0x%02x,"
+	pr_debug("Completed connection realligence for Opcode: 0x%02x,"
 		" ITT: 0x%08x to CID: %hu.\n", cmd->iscsi_opcode,
 			cmd->init_task_tag, conn->cid);
 
@@ -734,7 +733,7 @@ drop_unacknowledged_r2ts:
 			continue;
 
 		if (r2t->seq_complete) {
-			printk(KERN_ERR "Initiator is requesting R2Ts from"
+			pr_err("Initiator is requesting R2Ts from"
 				" R2TSN: 0x%08x, but R2TSN: 0x%08x, Offset: %u,"
 				" Length: %u is already complete."
 				"   BAD INITIATOR ERL=2 IMPLEMENTATION!\n",
@@ -808,7 +807,7 @@ int iscsit_check_task_reassign_expdatasn(
 	 */
 	if (ref_cmd->data_direction == DMA_FROM_DEVICE) {
 		if (tmr_req->exp_data_sn > ref_cmd->data_sn) {
-			printk(KERN_ERR "Received ExpDataSN: 0x%08x for READ"
+			pr_err("Received ExpDataSN: 0x%08x for READ"
 				" in TMR TASK_REASSIGN greater than command's"
 				" DataSN: 0x%08x.\n", tmr_req->exp_data_sn,
 				ref_cmd->data_sn);
@@ -816,7 +815,7 @@ int iscsit_check_task_reassign_expdatasn(
 		}
 		if ((ref_cmd->cmd_flags & ICF_GOT_DATACK_SNACK) &&
 		    (tmr_req->exp_data_sn <= ref_cmd->acked_data_sn)) {
-			printk(KERN_ERR "Received ExpDataSN: 0x%08x for READ"
+			pr_err("Received ExpDataSN: 0x%08x for READ"
 				" in TMR TASK_REASSIGN for previously"
 				" acknowledged DataIN: 0x%08x,"
 				" protocol error\n", tmr_req->exp_data_sn,
@@ -834,7 +833,7 @@ int iscsit_check_task_reassign_expdatasn(
 	 */
 	if (ref_cmd->data_direction == DMA_TO_DEVICE) {
 		if (tmr_req->exp_data_sn > ref_cmd->r2t_sn) {
-			printk(KERN_ERR "Received ExpDataSN: 0x%08x for WRITE"
+			pr_err("Received ExpDataSN: 0x%08x for WRITE"
 				" in TMR TASK_REASSIGN greater than command's"
 				" R2TSN: 0x%08x.\n", tmr_req->exp_data_sn,
 					ref_cmd->r2t_sn);
@@ -843,7 +842,7 @@ int iscsit_check_task_reassign_expdatasn(
 		return iscsit_task_reassign_prepare_write(tmr_req, conn);
 	}
 
-	printk(KERN_ERR "Unknown iSCSI data_direction: 0x%02x\n",
+	pr_err("Unknown iSCSI data_direction: 0x%02x\n",
 			ref_cmd->data_direction);
 
 	return -1;
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index b658857..1d5e7be 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -24,7 +24,6 @@
 #include <target/target_core_configfs.h>
 #include <target/target_core_tpg.h>
 
-#include "iscsi_target_debug.h"
 #include "iscsi_target_core.h"
 #include "iscsi_target_erl0.h"
 #include "iscsi_target_login.h"
@@ -40,7 +39,7 @@ struct iscsi_portal_group *iscsit_alloc_portal_group(struct iscsi_tiqn *tiqn, u1
 
 	tpg = kzalloc(sizeof(struct iscsi_portal_group), GFP_KERNEL);
 	if (!tpg) {
-		printk(KERN_ERR "Unable to allocate struct iscsi_portal_group\n");
+		pr_err("Unable to allocate struct iscsi_portal_group\n");
 		return NULL;
 	}
 
@@ -67,7 +66,7 @@ int iscsit_load_discovery_tpg(void)
 
 	tpg = iscsit_alloc_portal_group(NULL, 1);
 	if (!tpg) {
-		printk(KERN_ERR "Unable to allocate struct iscsi_portal_group\n");
+		pr_err("Unable to allocate struct iscsi_portal_group\n");
 		return -1;
 	}
 
@@ -105,7 +104,7 @@ int iscsit_load_discovery_tpg(void)
 	spin_unlock(&tpg->tpg_state_lock);
 
 	iscsit_global->discovery_tpg = tpg;
-	printk(KERN_INFO "CORE[0] - Allocated Discovery TPG\n");
+	pr_debug("CORE[0] - Allocated Discovery TPG\n");
 
 	return 0;
 out:
@@ -179,7 +178,7 @@ static void iscsit_clear_tpg_np_login_thread(
 	struct iscsi_portal_group *tpg)
 {
 	if (!tpg_np->tpg_np) {
-		printk(KERN_ERR "struct iscsi_tpg_np->tpg_np is NULL!\n");
+		pr_err("struct iscsi_tpg_np->tpg_np is NULL!\n");
 		return;
 	}
 
@@ -194,7 +193,7 @@ void iscsit_clear_tpg_np_login_threads(
 	spin_lock(&tpg->tpg_np_lock);
 	list_for_each_entry(tpg_np, &tpg->tpg_gnp_list, tpg_np_list) {
 		if (!tpg_np->tpg_np) {
-			printk(KERN_ERR "struct iscsi_tpg_np->tpg_np is NULL!\n");
+			pr_err("struct iscsi_tpg_np->tpg_np is NULL!\n");
 			continue;
 		}
 		spin_unlock(&tpg->tpg_np_lock);
@@ -226,7 +225,7 @@ static void iscsit_set_default_tpg_attribs(struct iscsi_portal_group *tpg)
 int iscsit_tpg_add_portal_group(struct iscsi_tiqn *tiqn, struct iscsi_portal_group *tpg)
 {
 	if (tpg->tpg_state != TPG_STATE_FREE) {
-		printk(KERN_ERR "Unable to add iSCSI Target Portal Group: %d"
+		pr_err("Unable to add iSCSI Target Portal Group: %d"
 			" while not in TPG_STATE_FREE state.\n", tpg->tpgt);
 		return -EEXIST;
 	}
@@ -244,7 +243,7 @@ int iscsit_tpg_add_portal_group(struct iscsi_tiqn *tiqn, struct iscsi_portal_gro
 	spin_lock(&tiqn->tiqn_tpg_lock);
 	list_add_tail(&tpg->tpg_list, &tiqn->tiqn_tpg_list);
 	tiqn->tiqn_ntpgs++;
-	printk(KERN_INFO "CORE[%s]_TPG[%hu] - Added iSCSI Target Portal Group\n",
+	pr_debug("CORE[%s]_TPG[%hu] - Added iSCSI Target Portal Group\n",
 			tiqn->tiqn, tpg->tpgt);
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
@@ -270,7 +269,7 @@ int iscsit_tpg_del_portal_group(
 	spin_unlock(&tpg->tpg_state_lock);
 
 	if (iscsit_release_sessions_for_tpg(tpg, force) < 0) {
-		printk(KERN_ERR "Unable to delete iSCSI Target Portal Group:"
+		pr_err("Unable to delete iSCSI Target Portal Group:"
 			" %hu while active sessions exist, and force=0\n",
 			tpg->tpgt);
 		tpg->tpg_state = old_state;
@@ -295,7 +294,7 @@ int iscsit_tpg_del_portal_group(
 	list_del(&tpg->tpg_list);
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
-	printk(KERN_INFO "CORE[%s]_TPG[%hu] - Deleted iSCSI Target Portal Group\n",
+	pr_debug("CORE[%s]_TPG[%hu] - Deleted iSCSI Target Portal Group\n",
 			tiqn->tiqn, tpg->tpgt);
 
 	kfree(tpg);
@@ -309,7 +308,7 @@ int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
 
 	spin_lock(&tpg->tpg_state_lock);
 	if (tpg->tpg_state == TPG_STATE_ACTIVE) {
-		printk(KERN_ERR "iSCSI target portal group: %hu is already"
+		pr_err("iSCSI target portal group: %hu is already"
 			" active, ignoring request.\n", tpg->tpgt);
 		spin_unlock(&tpg->tpg_state_lock);
 		return -EINVAL;
@@ -342,7 +341,7 @@ int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
 
 	spin_lock(&tiqn->tiqn_tpg_lock);
 	tiqn->tiqn_active_tpgs++;
-	printk(KERN_INFO "iSCSI_TPG[%hu] - Enabled iSCSI Target Portal Group\n",
+	pr_debug("iSCSI_TPG[%hu] - Enabled iSCSI Target Portal Group\n",
 			tpg->tpgt);
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
@@ -356,7 +355,7 @@ int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *tpg, int force)
 
 	spin_lock(&tpg->tpg_state_lock);
 	if (tpg->tpg_state == TPG_STATE_INACTIVE) {
-		printk(KERN_ERR "iSCSI Target Portal Group: %hu is already"
+		pr_err("iSCSI Target Portal Group: %hu is already"
 			" inactive, ignoring request.\n", tpg->tpgt);
 		spin_unlock(&tpg->tpg_state_lock);
 		return -EINVAL;
@@ -370,7 +369,7 @@ int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *tpg, int force)
 		spin_lock(&tpg->tpg_state_lock);
 		tpg->tpg_state = old_state;
 		spin_unlock(&tpg->tpg_state_lock);
-		printk(KERN_ERR "Unable to disable iSCSI Target Portal Group:"
+		pr_err("Unable to disable iSCSI Target Portal Group:"
 			" %hu while active sessions exist, and force=0\n",
 			tpg->tpgt);
 		return -EPERM;
@@ -382,7 +381,7 @@ int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *tpg, int force)
 
 	spin_lock(&tiqn->tiqn_tpg_lock);
 	tiqn->tiqn_active_tpgs--;
-	printk(KERN_INFO "iSCSI_TPG[%hu] - Disabled iSCSI Target Portal Group\n",
+	pr_debug("iSCSI_TPG[%hu] - Disabled iSCSI Target Portal Group\n",
 			tpg->tpgt);
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
@@ -432,7 +431,7 @@ struct iscsi_tpg_np *iscsit_tpg_add_network_portal(
 
 	tpg_np = kzalloc(sizeof(struct iscsi_tpg_np), GFP_KERNEL);
 	if (!tpg_np) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 				" struct iscsi_tpg_np.\n");
 		return ERR_PTR(-ENOMEM);
 	}
@@ -465,7 +464,7 @@ struct iscsi_tpg_np *iscsit_tpg_add_network_portal(
 		spin_unlock(&tpg_np_parent->tpg_np_parent_lock);
 	}
 
-	printk(KERN_INFO "CORE[%s] - Added Network Portal: %s:%hu,%hu on %s\n",
+	pr_debug("CORE[%s] - Added Network Portal: %s:%hu,%hu on %s\n",
 		tpg->tpg_tiqn->tiqn, np->np_ip, np->np_port, tpg->tpgt,
 		(np->np_network_transport == ISCSI_TCP) ? "TCP" : "SCTP");
 
@@ -479,7 +478,7 @@ static int iscsit_tpg_release_np(
 {
 	iscsit_clear_tpg_np_login_thread(tpg_np, tpg);
 
-	printk(KERN_INFO "CORE[%s] - Removed Network Portal: %s:%hu,%hu on %s\n",
+	pr_debug("CORE[%s] - Removed Network Portal: %s:%hu,%hu on %s\n",
 		tpg->tpg_tiqn->tiqn, np->np_ip, np->np_port, tpg->tpgt,
 		(np->np_network_transport == ISCSI_TCP) ? "TCP" : "SCTP");
 
@@ -502,7 +501,7 @@ int iscsit_tpg_del_network_portal(
 
 	np = tpg_np->tpg_np;
 	if (!np) {
-		printk(KERN_ERR "Unable to locate struct iscsi_np from"
+		pr_err("Unable to locate struct iscsi_np from"
 				" struct iscsi_tpg_np\n");
 		return -EINVAL;
 	}
@@ -518,7 +517,7 @@ int iscsit_tpg_del_network_portal(
 				tpg_np_child_list) {
 			ret = iscsit_tpg_del_network_portal(tpg, tpg_np_child);
 			if (ret < 0)
-				printk(KERN_ERR "iscsit_tpg_del_network_portal()"
+				pr_err("iscsit_tpg_del_network_portal()"
 					" failed: %d\n", ret);
 		}
 	} else {
@@ -559,7 +558,7 @@ int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((authentication != 1) && (authentication != 0)) {
-		printk(KERN_ERR "Illegal value for authentication parameter:"
+		pr_err("Illegal value for authentication parameter:"
 			" %u, ignoring request.\n", authentication);
 		return -1;
 	}
@@ -606,7 +605,7 @@ int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)
 
 out:
 	a->authentication = authentication;
-	printk(KERN_INFO "%s iSCSI Authentication Methods for TPG: %hu.\n",
+	pr_debug("%s iSCSI Authentication Methods for TPG: %hu.\n",
 		a->authentication ? "Enforcing" : "Disabling", tpg->tpgt);
 
 	return 0;
@@ -619,17 +618,17 @@ int iscsit_ta_login_timeout(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if (login_timeout > TA_LOGIN_TIMEOUT_MAX) {
-		printk(KERN_ERR "Requested Login Timeout %u larger than maximum"
+		pr_err("Requested Login Timeout %u larger than maximum"
 			" %u\n", login_timeout, TA_LOGIN_TIMEOUT_MAX);
 		return -EINVAL;
 	} else if (login_timeout < TA_LOGIN_TIMEOUT_MIN) {
-		printk(KERN_ERR "Requested Logout Timeout %u smaller than"
+		pr_err("Requested Logout Timeout %u smaller than"
 			" minimum %u\n", login_timeout, TA_LOGIN_TIMEOUT_MIN);
 		return -EINVAL;
 	}
 
 	a->login_timeout = login_timeout;
-	printk(KERN_INFO "Set Logout Timeout to %u for Target Portal Group"
+	pr_debug("Set Logout Timeout to %u for Target Portal Group"
 		" %hu\n", a->login_timeout, tpg->tpgt);
 
 	return 0;
@@ -642,19 +641,19 @@ int iscsit_ta_netif_timeout(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if (netif_timeout > TA_NETIF_TIMEOUT_MAX) {
-		printk(KERN_ERR "Requested Network Interface Timeout %u larger"
+		pr_err("Requested Network Interface Timeout %u larger"
 			" than maximum %u\n", netif_timeout,
 				TA_NETIF_TIMEOUT_MAX);
 		return -EINVAL;
 	} else if (netif_timeout < TA_NETIF_TIMEOUT_MIN) {
-		printk(KERN_ERR "Requested Network Interface Timeout %u smaller"
+		pr_err("Requested Network Interface Timeout %u smaller"
 			" than minimum %u\n", netif_timeout,
 				TA_NETIF_TIMEOUT_MIN);
 		return -EINVAL;
 	}
 
 	a->netif_timeout = netif_timeout;
-	printk(KERN_INFO "Set Network Interface Timeout to %u for"
+	pr_debug("Set Network Interface Timeout to %u for"
 		" Target Portal Group %hu\n", a->netif_timeout, tpg->tpgt);
 
 	return 0;
@@ -667,12 +666,12 @@ int iscsit_ta_generate_node_acls(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((flag != 0) && (flag != 1)) {
-		printk(KERN_ERR "Illegal value %d\n", flag);
+		pr_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 
 	a->generate_node_acls = flag;
-	printk(KERN_INFO "iSCSI_TPG[%hu] - Generate Initiator Portal Group ACLs: %s\n",
+	pr_debug("iSCSI_TPG[%hu] - Generate Initiator Portal Group ACLs: %s\n",
 		tpg->tpgt, (a->generate_node_acls) ? "Enabled" : "Disabled");
 
 	return 0;
@@ -685,19 +684,19 @@ int iscsit_ta_default_cmdsn_depth(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if (tcq_depth > TA_DEFAULT_CMDSN_DEPTH_MAX) {
-		printk(KERN_ERR "Requested Default Queue Depth: %u larger"
+		pr_err("Requested Default Queue Depth: %u larger"
 			" than maximum %u\n", tcq_depth,
 				TA_DEFAULT_CMDSN_DEPTH_MAX);
 		return -EINVAL;
 	} else if (tcq_depth < TA_DEFAULT_CMDSN_DEPTH_MIN) {
-		printk(KERN_ERR "Requested Default Queue Depth: %u smaller"
+		pr_err("Requested Default Queue Depth: %u smaller"
 			" than minimum %u\n", tcq_depth,
 				TA_DEFAULT_CMDSN_DEPTH_MIN);
 		return -EINVAL;
 	}
 
 	a->default_cmdsn_depth = tcq_depth;
-	printk(KERN_INFO "iSCSI_TPG[%hu] - Set Default CmdSN TCQ Depth to %u\n",
+	pr_debug("iSCSI_TPG[%hu] - Set Default CmdSN TCQ Depth to %u\n",
 		tpg->tpgt, a->default_cmdsn_depth);
 
 	return 0;
@@ -710,12 +709,12 @@ int iscsit_ta_cache_dynamic_acls(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((flag != 0) && (flag != 1)) {
-		printk(KERN_ERR "Illegal value %d\n", flag);
+		pr_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 
 	a->cache_dynamic_acls = flag;
-	printk(KERN_INFO "iSCSI_TPG[%hu] - Cache Dynamic Initiator Portal Group"
+	pr_debug("iSCSI_TPG[%hu] - Cache Dynamic Initiator Portal Group"
 		" ACLs %s\n", tpg->tpgt, (a->cache_dynamic_acls) ?
 		"Enabled" : "Disabled");
 
@@ -729,12 +728,12 @@ int iscsit_ta_demo_mode_write_protect(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((flag != 0) && (flag != 1)) {
-		printk(KERN_ERR "Illegal value %d\n", flag);
+		pr_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 
 	a->demo_mode_write_protect = flag;
-	printk(KERN_INFO "iSCSI_TPG[%hu] - Demo Mode Write Protect bit: %s\n",
+	pr_debug("iSCSI_TPG[%hu] - Demo Mode Write Protect bit: %s\n",
 		tpg->tpgt, (a->demo_mode_write_protect) ? "ON" : "OFF");
 
 	return 0;
@@ -747,12 +746,12 @@ int iscsit_ta_prod_mode_write_protect(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((flag != 0) && (flag != 1)) {
-		printk(KERN_ERR "Illegal value %d\n", flag);
+		pr_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 
 	a->prod_mode_write_protect = flag;
-	printk(KERN_INFO "iSCSI_TPG[%hu] - Production Mode Write Protect bit:"
+	pr_debug("iSCSI_TPG[%hu] - Production Mode Write Protect bit:"
 		" %s\n", tpg->tpgt, (a->prod_mode_write_protect) ?
 		"ON" : "OFF");
 
diff --git a/drivers/target/iscsi/iscsi_target_tq.c b/drivers/target/iscsi/iscsi_target_tq.c
index 8f8a4ca..0ecd22f 100644
--- a/drivers/target/iscsi/iscsi_target_tq.c
+++ b/drivers/target/iscsi/iscsi_target_tq.c
@@ -22,7 +22,6 @@
 #include <linux/list.h>
 #include <linux/bitmap.h>
 
-#include "iscsi_target_debug.h"
 #include "iscsi_target_core.h"
 #include "iscsi_target_tq.h"
 #include "iscsi_target.h"
@@ -85,7 +84,7 @@ extern int iscsi_allocate_thread_sets(u32 thread_pair_count)
 	for (i = 0; i < thread_pair_count; i++) {
 		ts = kzalloc(sizeof(struct iscsi_thread_set), GFP_KERNEL);
 		if (!(ts)) {
-			printk(KERN_ERR "Unable to allocate memory for"
+			pr_err("Unable to allocate memory for"
 					" thread set.\n");
 			return allocated_thread_pair_count;
 		}
@@ -97,7 +96,7 @@ extern int iscsi_allocate_thread_sets(u32 thread_pair_count)
 				iscsit_global->ts_bitmap_count, get_order(1));
 		spin_unlock(&ts_bitmap_lock);
 		if (thread_id < 0) {
-			printk(KERN_ERR "bitmap_find_free_region() failed for"
+			pr_err("bitmap_find_free_region() failed for"
 				" thread_set_bitmap\n");
 			kfree(ts);
 			return allocated_thread_pair_count;
@@ -119,7 +118,7 @@ extern int iscsi_allocate_thread_sets(u32 thread_pair_count)
 					ISCSI_TX_THREAD_NAME);
 		if (IS_ERR(ts->tx_thread)) {
 			dump_stack();
-			printk(KERN_ERR "Unable to start iscsi_target_tx_thread\n");
+			pr_err("Unable to start iscsi_target_tx_thread\n");
 			break;
 		}
 
@@ -127,7 +126,7 @@ extern int iscsi_allocate_thread_sets(u32 thread_pair_count)
 					ISCSI_RX_THREAD_NAME);
 		if (IS_ERR(ts->rx_thread)) {
 			kthread_stop(ts->tx_thread);
-			printk(KERN_ERR "Unable to start iscsi_target_rx_thread\n");
+			pr_err("Unable to start iscsi_target_rx_thread\n");
 			break;
 		}
 		ts->create_threads = 0;
@@ -136,7 +135,7 @@ extern int iscsi_allocate_thread_sets(u32 thread_pair_count)
 		allocated_thread_pair_count++;
 	}
 
-	printk(KERN_INFO "Spawned %d thread set(s) (%d total threads).\n",
+	pr_debug("Spawned %d thread set(s) (%d total threads).\n",
 		allocated_thread_pair_count, allocated_thread_pair_count * 2);
 	return allocated_thread_pair_count;
 }
@@ -173,7 +172,7 @@ extern void iscsi_deallocate_thread_sets(void)
 	}
 
 	if (released_count)
-		printk(KERN_INFO "Stopped %d thread set(s) (%d total threads)."
+		pr_debug("Stopped %d thread set(s) (%d total threads)."
 			"\n", released_count, released_count * 2);
 }
 
@@ -214,7 +213,7 @@ static void iscsi_deallocate_extra_thread_sets(void)
 	}
 
 	if (released_count) {
-		printk(KERN_INFO "Stopped %d thread set(s) (%d total threads)."
+		pr_debug("Stopped %d thread set(s) (%d total threads)."
 			"\n", released_count, released_count * 2);
 	}
 }
@@ -274,7 +273,7 @@ void iscsi_set_thread_clear(struct iscsi_conn *conn, u8 thread_clear)
 	struct iscsi_thread_set *ts = NULL;
 
 	if (!conn->thread_set) {
-		printk(KERN_ERR "struct iscsi_conn->thread_set is NULL\n");
+		pr_err("struct iscsi_conn->thread_set is NULL\n");
 		return;
 	}
 	ts = conn->thread_set;
@@ -296,7 +295,7 @@ void iscsi_set_thread_set_signal(struct iscsi_conn *conn, u8 signal_sent)
 	struct iscsi_thread_set *ts = NULL;
 
 	if (!conn->thread_set) {
-		printk(KERN_ERR "struct iscsi_conn->thread_set is NULL\n");
+		pr_err("struct iscsi_conn->thread_set is NULL\n");
 		return;
 	}
 	ts = conn->thread_set;
@@ -312,7 +311,7 @@ int iscsi_release_thread_set(struct iscsi_conn *conn)
 	struct iscsi_thread_set *ts = NULL;
 
 	if (!conn || !conn->thread_set) {
-		printk(KERN_ERR "connection or thread set pointer is NULL\n");
+		pr_err("connection or thread set pointer is NULL\n");
 		BUG();
 	}
 	ts = conn->thread_set;
@@ -449,7 +448,7 @@ sleep:
 		return NULL;
 
 	if (!ts->conn) {
-		printk(KERN_ERR "struct iscsi_thread_set->conn is NULL for"
+		pr_err("struct iscsi_thread_set->conn is NULL for"
 			" thread_id: %d, going back to sleep\n", ts->thread_id);
 		goto sleep;
 	}
@@ -501,7 +500,7 @@ sleep:
 		return NULL;
 
 	if (!ts->conn) {
-		printk(KERN_ERR "struct iscsi_thread_set->conn is NULL for "
+		pr_err("struct iscsi_thread_set->conn is NULL for "
 			" thread_id: %d, going back to sleep\n",
 			ts->thread_id);
 		goto sleep;
@@ -533,7 +532,7 @@ int iscsi_thread_set_init(void)
 	size = BITS_TO_LONGS(iscsit_global->ts_bitmap_count) * sizeof(long);
 	iscsit_global->ts_bitmap = kzalloc(size, GFP_KERNEL);
 	if (!(iscsit_global->ts_bitmap)) {
-		printk(KERN_ERR "Unable to allocate iscsit_global->ts_bitmap\n");
+		pr_err("Unable to allocate iscsit_global->ts_bitmap\n");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 4260888..8568d0a 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -27,7 +27,6 @@
 #include <target/target_core_fabric_ops.h>
 #include <target/target_core_configfs.h>
 
-#include "iscsi_target_debug.h"
 #include "iscsi_target_core.h"
 #include "iscsi_target_parameters.h"
 #include "iscsi_target_seq_pdu_list.h"
@@ -40,6 +39,23 @@
 #include "iscsi_target_util.h"
 #include "iscsi_target.h"
 
+#define PRINT_BUFF(buff, len)					\
+{								\
+	int zzz;						\
+								\
+	pr_debug("%d:\n", __LINE__);				\
+	for (zzz = 0; zzz < len; zzz++) {			\
+		if (zzz % 16 == 0) {				\
+			if (zzz)				\
+				pr_debug("\n");			\
+			pr_debug("%4i: ", zzz);			\
+		}						\
+		pr_debug("%02x ", (unsigned char) (buff)[zzz]);	\
+	}							\
+	if ((len + 1) % 16)					\
+		pr_debug("\n");					\
+}
+
 extern struct list_head g_tiqn_list;
 extern spinlock_t tiqn_lock;
 
@@ -57,7 +73,7 @@ int iscsit_add_r2t_to_list(
 
 	r2t = kmem_cache_zalloc(lio_r2t_cache, GFP_ATOMIC);
 	if (!r2t) {
-		printk(KERN_ERR "Unable to allocate memory for struct iscsi_r2t.\n");
+		pr_err("Unable to allocate memory for struct iscsi_r2t.\n");
 		return -1;
 	}
 	INIT_LIST_HEAD(&r2t->r2t_list);
@@ -92,7 +108,7 @@ struct iscsi_r2t *iscsit_get_r2t_for_eos(
 	}
 	spin_unlock_bh(&cmd->r2t_lock);
 
-	printk(KERN_ERR "Unable to locate R2T for Offset: %u, Length:"
+	pr_err("Unable to locate R2T for Offset: %u, Length:"
 			" %u\n", offset, length);
 	return NULL;
 }
@@ -110,7 +126,7 @@ struct iscsi_r2t *iscsit_get_r2t_from_list(struct iscsi_cmd *cmd)
 	}
 	spin_unlock_bh(&cmd->r2t_lock);
 
-	printk(KERN_ERR "Unable to locate next R2T to send for ITT:"
+	pr_err("Unable to locate next R2T to send for ITT:"
 			" 0x%08x.\n", cmd->init_task_tag);
 	return NULL;
 }
@@ -144,7 +160,7 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
 
 	cmd = kmem_cache_zalloc(lio_cmd_cache, gfp_mask);
 	if (!cmd) {
-		printk(KERN_ERR "Unable to allocate memory for struct iscsi_cmd.\n");
+		pr_err("Unable to allocate memory for struct iscsi_cmd.\n");
 		return NULL;
 	}
 
@@ -194,7 +210,7 @@ struct iscsi_cmd *iscsit_allocate_se_cmd(
 	else if (iscsi_task_attr == ISCSI_ATTR_ACA)
 		sam_task_attr = MSG_ACA_TAG;
 	else {
-		printk(KERN_INFO "Unknown iSCSI Task Attribute: 0x%02x, using"
+		pr_debug("Unknown iSCSI Task Attribute: 0x%02x, using"
 			" MSG_SIMPLE_TAG\n", iscsi_task_attr);
 		sam_task_attr = MSG_SIMPLE_TAG;
 	}
@@ -225,7 +241,7 @@ struct iscsi_cmd *iscsit_allocate_se_cmd_for_tmr(
 
 	cmd->tmr_req = kzalloc(sizeof(struct iscsi_tmr_req), GFP_KERNEL);
 	if (!cmd->tmr_req) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 			" Task Management command!\n");
 		return NULL;
 	}
@@ -267,7 +283,7 @@ struct iscsi_cmd *iscsit_allocate_se_cmd_for_tmr(
 		tcm_function = TMR_TARGET_COLD_RESET;
 		break;
 	default:
-		printk(KERN_ERR "Unknown iSCSI TMR Function:"
+		pr_err("Unknown iSCSI TMR Function:"
 			" 0x%02x\n", function);
 		goto out;
 	}
@@ -350,7 +366,7 @@ struct iscsi_seq *iscsit_get_seq_holder_for_r2t(struct iscsi_cmd *cmd)
 	u32 i;
 
 	if (!cmd->seq_list) {
-		printk(KERN_ERR "struct iscsi_cmd->seq_list is NULL!\n");
+		pr_err("struct iscsi_cmd->seq_list is NULL!\n");
 		return NULL;
 	}
 
@@ -395,26 +411,26 @@ static inline int iscsit_check_received_cmdsn(struct iscsi_session *sess, u32 cm
 	 * CRC failures.
 	 */
 	if (iscsi_sna_gt(cmdsn, sess->max_cmd_sn)) {
-		printk(KERN_ERR "Received CmdSN: 0x%08x is greater than"
+		pr_err("Received CmdSN: 0x%08x is greater than"
 		       " MaxCmdSN: 0x%08x, protocol error.\n", cmdsn,
 		       sess->max_cmd_sn);
 		ret = CMDSN_ERROR_CANNOT_RECOVER;
 
 	} else if (cmdsn == sess->exp_cmd_sn) {
 		sess->exp_cmd_sn++;
-		TRACE(TRACE_CMDSN, "Received CmdSN matches ExpCmdSN,"
+		pr_debug("Received CmdSN matches ExpCmdSN,"
 		      " incremented ExpCmdSN to: 0x%08x\n",
 		      sess->exp_cmd_sn);
 		ret = CMDSN_NORMAL_OPERATION;
 
 	} else if (iscsi_sna_gt(cmdsn, sess->exp_cmd_sn)) {
-		TRACE(TRACE_CMDSN, "Received CmdSN: 0x%08x is greater"
+		pr_debug("Received CmdSN: 0x%08x is greater"
 		      " than ExpCmdSN: 0x%08x, not acknowledging.\n",
 		      cmdsn, sess->exp_cmd_sn);
 		ret = CMDSN_HIGHER_THAN_EXP;
 
 	} else {
-		printk(KERN_ERR "Received CmdSN: 0x%08x is less than"
+		pr_err("Received CmdSN: 0x%08x is less than"
 		       " ExpCmdSN: 0x%08x, ignoring.\n", cmdsn,
 		       sess->exp_cmd_sn);
 		ret = CMDSN_LOWER_THAN_EXP;
@@ -469,7 +485,7 @@ int iscsit_check_unsolicited_dataout(struct iscsi_cmd *cmd, unsigned char *buf)
 	u32 payload_length = ntoh24(hdr->dlength);
 
 	if (conn->sess->sess_ops->InitialR2T) {
-		printk(KERN_ERR "Received unexpected unsolicited data"
+		pr_err("Received unexpected unsolicited data"
 			" while InitialR2T=Yes, protocol error.\n");
 		transport_send_check_condition_and_sense(se_cmd,
 				TCM_UNEXPECTED_UNSOLICITED_DATA, 0);
@@ -478,7 +494,7 @@ int iscsit_check_unsolicited_dataout(struct iscsi_cmd *cmd, unsigned char *buf)
 
 	if ((cmd->first_burst_len + payload_length) >
 	     conn->sess->sess_ops->FirstBurstLength) {
-		printk(KERN_ERR "Total %u bytes exceeds FirstBurstLength: %u"
+		pr_err("Total %u bytes exceeds FirstBurstLength: %u"
 			" for this Unsolicited DataOut Burst.\n",
 			(cmd->first_burst_len + payload_length),
 				conn->sess->sess_ops->FirstBurstLength);
@@ -493,7 +509,7 @@ int iscsit_check_unsolicited_dataout(struct iscsi_cmd *cmd, unsigned char *buf)
 	if (((cmd->first_burst_len + payload_length) != cmd->data_length) &&
 	    ((cmd->first_burst_len + payload_length) !=
 	      conn->sess->sess_ops->FirstBurstLength)) {
-		printk(KERN_ERR "Unsolicited non-immediate data received %u"
+		pr_err("Unsolicited non-immediate data received %u"
 			" does not equal FirstBurstLength: %u, and does"
 			" not equal ExpXferLen %u.\n",
 			(cmd->first_burst_len + payload_length),
@@ -520,7 +536,7 @@ struct iscsi_cmd *iscsit_find_cmd_from_itt(
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
-	printk(KERN_ERR "Unable to locate ITT: 0x%08x on CID: %hu",
+	pr_err("Unable to locate ITT: 0x%08x on CID: %hu",
 			init_task_tag, conn->cid);
 	return NULL;
 }
@@ -541,7 +557,7 @@ struct iscsi_cmd *iscsit_find_cmd_from_itt_or_dump(
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
-	printk(KERN_ERR "Unable to locate ITT: 0x%08x on CID: %hu,"
+	pr_err("Unable to locate ITT: 0x%08x on CID: %hu,"
 			" dumping payload\n", init_task_tag, conn->cid);
 	if (length)
 		iscsit_dump_data_payload(conn, length, 1);
@@ -564,7 +580,7 @@ struct iscsi_cmd *iscsit_find_cmd_from_ttt(
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
-	printk(KERN_ERR "Unable to locate TTT: 0x%08x on CID: %hu\n",
+	pr_err("Unable to locate TTT: 0x%08x on CID: %hu\n",
 			targ_xfer_tag, conn->cid);
 	return NULL;
 }
@@ -630,7 +646,7 @@ void iscsit_add_cmd_to_immediate_queue(
 
 	qr = kmem_cache_zalloc(lio_qr_cache, GFP_ATOMIC);
 	if (!qr) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 				" struct iscsi_queue_req\n");
 		return;
 	}
@@ -690,7 +706,7 @@ static void iscsit_remove_cmd_from_immediate_queue(
 	spin_unlock_bh(&conn->immed_queue_lock);
 
 	if (atomic_read(&cmd->immed_queue_count)) {
-		printk(KERN_ERR "ITT: 0x%08x immed_queue_count: %d\n",
+		pr_err("ITT: 0x%08x immed_queue_count: %d\n",
 			cmd->init_task_tag,
 			atomic_read(&cmd->immed_queue_count));
 	}
@@ -705,7 +721,7 @@ void iscsit_add_cmd_to_response_queue(
 
 	qr = kmem_cache_zalloc(lio_qr_cache, GFP_ATOMIC);
 	if (!qr) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 			" struct iscsi_queue_req\n");
 		return;
 	}
@@ -766,7 +782,7 @@ static void iscsit_remove_cmd_from_response_queue(
 	spin_unlock_bh(&conn->response_queue_lock);
 
 	if (atomic_read(&cmd->response_queue_count)) {
-		printk(KERN_ERR "ITT: 0x%08x response_queue_count: %d\n",
+		pr_err("ITT: 0x%08x response_queue_count: %d\n",
 			cmd->init_task_tag,
 			atomic_read(&cmd->response_queue_count));
 	}
@@ -922,7 +938,7 @@ int iscsit_set_sync_and_steering_values(struct iscsi_conn *conn)
 			conn->of_marker = (next_marker - conn->of_marker);
 		}
 		conn->of_marker_offset = 0;
-		printk(KERN_INFO "Setting OFMarker value to %u based on Initial"
+		pr_debug("Setting OFMarker value to %u based on Initial"
 			" Markerless Interval.\n", conn->of_marker);
 	}
 
@@ -935,7 +951,7 @@ int iscsit_set_sync_and_steering_values(struct iscsi_conn *conn)
 					(login_ifmarker_count * MARKER_SIZE);
 			conn->if_marker = (next_marker - conn->if_marker);
 		}
-		printk(KERN_INFO "Setting IFMarker value to %u based on Initial"
+		pr_debug("Setting IFMarker value to %u based on Initial"
 			" Markerless Interval.\n", conn->if_marker);
 	}
 
@@ -1055,7 +1071,7 @@ static void iscsit_handle_nopin_response_timeout(unsigned long data)
 		return;
 	}
 
-	TRACE(TRACE_TIMER, "Did not receive response to NOPIN on CID: %hu on"
+	pr_debug("Did not receive response to NOPIN on CID: %hu on"
 		" SID: %u, failing connection.\n", conn->cid,
 			conn->sess->sid);
 	conn->nopin_response_timer_flags &= ~ISCSI_TF_RUNNING;
@@ -1120,7 +1136,7 @@ void iscsit_start_nopin_response_timer(struct iscsi_conn *conn)
 	conn->nopin_response_timer_flags |= ISCSI_TF_RUNNING;
 	add_timer(&conn->nopin_response_timer);
 
-	TRACE(TRACE_TIMER, "Started NOPIN Response Timer on CID: %d to %u"
+	pr_debug("Started NOPIN Response Timer on CID: %d to %u"
 		" seconds\n", conn->cid, na->nopin_response_timeout);
 	spin_unlock_bh(&conn->nopin_timer_lock);
 }
@@ -1185,7 +1201,7 @@ void __iscsit_start_nopin_timer(struct iscsi_conn *conn)
 	conn->nopin_timer_flags |= ISCSI_TF_RUNNING;
 	add_timer(&conn->nopin_timer);
 
-	TRACE(TRACE_TIMER, "Started NOPIN Timer on CID: %d at %u second"
+	pr_debug("Started NOPIN Timer on CID: %d at %u second"
 		" interval\n", conn->cid, na->nopin_timeout);
 }
 
@@ -1213,7 +1229,7 @@ void iscsit_start_nopin_timer(struct iscsi_conn *conn)
 	conn->nopin_timer_flags |= ISCSI_TF_RUNNING;
 	add_timer(&conn->nopin_timer);
 
-	TRACE(TRACE_TIMER, "Started NOPIN Timer on CID: %d at %u second"
+	pr_debug("Started NOPIN Timer on CID: %d at %u second"
 			" interval\n", conn->cid, na->nopin_timeout);
 	spin_unlock_bh(&conn->nopin_timer_lock);
 }
@@ -1258,7 +1274,7 @@ send_data:
 	tx_sent = tx_data(conn, &iov[0], iov_count, tx_size);
 	if (tx_size != tx_sent) {
 		if (tx_sent == -EAGAIN) {
-			printk(KERN_ERR "tx_data() returned -EAGAIN\n");
+			pr_err("tx_data() returned -EAGAIN\n");
 			goto send_data;
 		} else
 			return -1;
@@ -1289,7 +1305,7 @@ send_hdr:
 	tx_sent = tx_data(conn, &iov, 1, tx_hdr_size);
 	if (tx_hdr_size != tx_sent) {
 		if (tx_sent == -EAGAIN) {
-			printk(KERN_ERR "tx_data() returned -EAGAIN\n");
+			pr_err("tx_data() returned -EAGAIN\n");
 			goto send_hdr;
 		}
 		return -1;
@@ -1310,12 +1326,12 @@ send_pg:
 					sg_page(sg), sg->offset + offset, sub_len, 0);
 		if (tx_sent != sub_len) {
 			if (tx_sent == -EAGAIN) {
-				printk(KERN_ERR "tcp_sendpage() returned"
+				pr_err("tcp_sendpage() returned"
 						" -EAGAIN\n");
 				goto send_pg;
 			}
 
-			printk(KERN_ERR "tcp_sendpage() failure: %d\n",
+			pr_err("tcp_sendpage() failure: %d\n",
 					tx_sent);
 			return -1;
 		}
@@ -1333,7 +1349,7 @@ send_padding:
 		tx_sent = tx_data(conn, iov_p, 1, cmd->padding);
 		if (cmd->padding != tx_sent) {
 			if (tx_sent == -EAGAIN) {
-				printk(KERN_ERR "tx_data() returned -EAGAIN\n");
+				pr_err("tx_data() returned -EAGAIN\n");
 				goto send_padding;
 			}
 			return -1;
@@ -1348,7 +1364,7 @@ send_datacrc:
 		tx_sent = tx_data(conn, iov_d, 1, ISCSI_CRC_LEN);
 		if (ISCSI_CRC_LEN != tx_sent) {
 			if (tx_sent == -EAGAIN) {
-				printk(KERN_ERR "tx_data() returned -EAGAIN\n");
+				pr_err("tx_data() returned -EAGAIN\n");
 				goto send_datacrc;
 			}
 			return -1;
@@ -1391,7 +1407,7 @@ int iscsit_tx_login_rsp(struct iscsi_conn *conn, u8 status_class, u8 status_deta
 
 	err = tx_data(conn, &iov, 1, ISCSI_HDR_LEN);
 	if (err != ISCSI_HDR_LEN) {
-		printk(KERN_ERR "tx_data returned less than expected\n");
+		pr_err("tx_data returned less than expected\n");
 		return -1;
 	}
 
@@ -1402,7 +1418,7 @@ void iscsit_print_session_params(struct iscsi_session *sess)
 {
 	struct iscsi_conn *conn;
 
-	printk(KERN_INFO "-----------------------------[Session Params for"
+	pr_debug("-----------------------------[Session Params for"
 		" SID: %u]-----------------------------\n", sess->sid);
 	spin_lock_bh(&sess->conn_lock);
 	list_for_each_entry(conn, &sess->sess_conn_list, conn_list)
@@ -1446,9 +1462,9 @@ static int iscsit_do_rx_data(
 		size = data;
 		orig_iov_len = iov_record[orig_iov_loc].iov_len;
 		while (size > 0) {
-			TRACE(TRACE_SSLR, "rx_data: #1 orig_iov_len %u,"
+			pr_debug("rx_data: #1 orig_iov_len %u,"
 			" orig_iov_loc %u\n", orig_iov_len, orig_iov_loc);
-			TRACE(TRACE_SSLR, "rx_data: #2 rx_marker %u, size"
+			pr_debug("rx_data: #2 rx_marker %u, size"
 				" %u\n", *rx_marker, size);
 
 			if (orig_iov_len >= *rx_marker) {
@@ -1473,7 +1489,7 @@ static int iscsit_do_rx_data(
 				orig_iov_len -= old_rx_marker;
 				per_iov_bytes += old_rx_marker;
 
-				TRACE(TRACE_SSLR, "rx_data: #3 new_rx_marker"
+				pr_debug("rx_data: #3 new_rx_marker"
 					" %u, size %u\n", *rx_marker, size);
 			} else {
 				iov[iov_count].iov_len = orig_iov_len;
@@ -1489,7 +1505,7 @@ static int iscsit_do_rx_data(
 					orig_iov_len =
 					iov_record[++orig_iov_loc].iov_len;
 
-				TRACE(TRACE_SSLR, "rx_data: #4 new_rx_marker"
+				pr_debug("rx_data: #4 new_rx_marker"
 					" %u, size %u\n", *rx_marker, size);
 			}
 		}
@@ -1499,12 +1515,12 @@ static int iscsit_do_rx_data(
 		iov_len	= iov_count;
 
 		if (iov_count > count->ss_iov_count) {
-			printk(KERN_ERR "iov_count: %d, count->ss_iov_count:"
+			pr_err("iov_count: %d, count->ss_iov_count:"
 				" %d\n", iov_count, count->ss_iov_count);
 			return -1;
 		}
 		if (rx_marker_iov > count->ss_marker_count) {
-			printk(KERN_ERR "rx_marker_iov: %d, count->ss_marker"
+			pr_err("rx_marker_iov: %d, count->ss_marker"
 				"_count: %d\n", rx_marker_iov,
 				count->ss_marker_count);
 			return -1;
@@ -1518,19 +1534,19 @@ static int iscsit_do_rx_data(
 		rx_loop = kernel_recvmsg(conn->sock, &msg, iov_p, iov_len,
 					(data - total_rx), MSG_WAITALL);
 		if (rx_loop <= 0) {
-			TRACE(TRACE_NET, "rx_loop: %d total_rx: %d\n",
+			pr_debug("rx_loop: %d total_rx: %d\n",
 				rx_loop, total_rx);
 			return rx_loop;
 		}
 		total_rx += rx_loop;
-		TRACE(TRACE_NET, "rx_loop: %d, total_rx: %d, data: %d\n",
+		pr_debug("rx_loop: %d, total_rx: %d, data: %d\n",
 				rx_loop, total_rx, data);
 	}
 
 	if (count->sync_and_steering) {
 		int j;
 		for (j = 0; j < rx_marker_iov; j++) {
-			TRACE(TRACE_SSLR, "rx_data: #5 j: %d, offset: %d\n",
+			pr_debug("rx_data: #5 j: %d, offset: %d\n",
 				j, rx_marker_val[j]);
 			conn->of_marker_offset = rx_marker_val[j];
 		}
@@ -1553,7 +1569,7 @@ static int iscsit_do_tx_data(
 		return -1;
 
 	if (data <= 0) {
-		printk(KERN_ERR "Data length is: %d\n", data);
+		pr_err("Data length is: %d\n", data);
 		return -1;
 	}
 
@@ -1579,9 +1595,9 @@ static int iscsit_do_tx_data(
 		size = data;
 		orig_iov_len = iov_record[orig_iov_loc].iov_len;
 		while (size > 0) {
-			TRACE(TRACE_SSLT, "tx_data: #1 orig_iov_len %u,"
+			pr_debug("tx_data: #1 orig_iov_len %u,"
 			" orig_iov_loc %u\n", orig_iov_len, orig_iov_loc);
-			TRACE(TRACE_SSLT, "tx_data: #2 tx_marker %u, size"
+			pr_debug("tx_data: #2 tx_marker %u, size"
 				" %u\n", *tx_marker, size);
 
 			if (orig_iov_len >= *tx_marker) {
@@ -1608,9 +1624,9 @@ static int iscsit_do_tx_data(
 				orig_iov_len -= old_tx_marker;
 				per_iov_bytes += old_tx_marker;
 
-				TRACE(TRACE_SSLT, "tx_data: #3 new_tx_marker"
+				pr_debug("tx_data: #3 new_tx_marker"
 					" %u, size %u\n", *tx_marker, size);
-				TRACE(TRACE_SSLT, "tx_data: #4 offset %u\n",
+				pr_debug("tx_data: #4 offset %u\n",
 					tx_marker_val[tx_marker_iov-1]);
 			} else {
 				iov[iov_count].iov_len = orig_iov_len;
@@ -1626,7 +1642,7 @@ static int iscsit_do_tx_data(
 					orig_iov_len =
 					iov_record[++orig_iov_loc].iov_len;
 
-				TRACE(TRACE_SSLT, "tx_data: #5 new_tx_marker"
+				pr_debug("tx_data: #5 new_tx_marker"
 					" %u, size %u\n", *tx_marker, size);
 			}
 		}
@@ -1637,12 +1653,12 @@ static int iscsit_do_tx_data(
 		iov_len = iov_count;
 
 		if (iov_count > count->ss_iov_count) {
-			printk(KERN_ERR "iov_count: %d, count->ss_iov_count:"
+			pr_err("iov_count: %d, count->ss_iov_count:"
 				" %d\n", iov_count, count->ss_iov_count);
 			return -1;
 		}
 		if (tx_marker_iov > count->ss_marker_count) {
-			printk(KERN_ERR "tx_marker_iov: %d, count->ss_marker"
+			pr_err("tx_marker_iov: %d, count->ss_marker"
 				"_count: %d\n", tx_marker_iov,
 				count->ss_marker_count);
 			return -1;
@@ -1656,12 +1672,12 @@ static int iscsit_do_tx_data(
 		tx_loop = kernel_sendmsg(conn->sock, &msg, iov_p, iov_len,
 					(data - total_tx));
 		if (tx_loop <= 0) {
-			TRACE(TRACE_NET, "tx_loop: %d total_tx %d\n",
+			pr_debug("tx_loop: %d total_tx %d\n",
 				tx_loop, total_tx);
 			return tx_loop;
 		}
 		total_tx += tx_loop;
-		TRACE(TRACE_NET, "tx_loop: %d, total_tx: %d, data: %d\n",
+		pr_debug("tx_loop: %d, total_tx: %d, data: %d\n",
 					tx_loop, total_tx, data);
 	}
 
-- 
1.7.1

