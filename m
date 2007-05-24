From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [PATCH 7/8] qla4xxx: Resubmission: ql4_mbx.c remove dead code
	bugfixes
Date: Wed, 23 May 2007 18:03:27 -0700
Message-ID: <1179968607.16099.18.camel@iscsi-sles10>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6089 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759762AbXEXBEa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 21:04:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, David Somayajulu <david.somayajulu@qlogic.com>, David Wagner <david.wagner@qlogic.com>

All all inbound mbx registers for all mbx commands. Remove dead code.

Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

 drivers/scsi/qla4xxx/ql4_mbx.c |  274 +++++++++++++++-------------------------
 1 files changed, 103 insertions(+), 171 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index f116ff9..35cd73c 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -6,6 +6,9 @@
  */
 
 #include "ql4_def.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
 
 
 /**
@@ -169,84 +172,6 @@ mbox_exit:
 	return status;
 }
 
-
-#if 0
-
-/**
- * qla4xxx_issue_iocb - issue mailbox iocb command
- * @ha: adapter state pointer.
- * @buffer: buffer pointer.
- * @phys_addr: physical address of buffer.
- * @size: size of buffer.
- *
- * Issues iocbs via mailbox commands.
- * TARGET_QUEUE_LOCK must be released.
- * ADAPTER_STATE_LOCK must be released.
- **/
-int
-qla4xxx_issue_iocb(struct scsi_qla_host * ha, void *buffer,
-		   dma_addr_t phys_addr, size_t size)
-{
-	uint32_t mbox_cmd[MBOX_REG_COUNT];
-	uint32_t mbox_sts[MBOX_REG_COUNT];
-	int status;
-
-	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
-	memset(&mbox_sts, 0, sizeof(mbox_sts));
-	mbox_cmd[0] = MBOX_CMD_EXECUTE_IOCB_A64;
-	mbox_cmd[1] = 0;
-	mbox_cmd[2] = LSDW(phys_addr);
-	mbox_cmd[3] = MSDW(phys_addr);
-	status = qla4xxx_mailbox_command(ha, 4, 1, &mbox_cmd[0], &mbox_sts[0]);
-	return status;
-}
-
-int qla4xxx_conn_close_sess_logout(struct scsi_qla_host * ha,
-				   uint16_t fw_ddb_index,
-				   uint16_t connection_id,
-				   uint16_t option)
-{
-	uint32_t mbox_cmd[MBOX_REG_COUNT];
-	uint32_t mbox_sts[MBOX_REG_COUNT];
-
-	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
-	memset(&mbox_sts, 0, sizeof(mbox_sts));
-	mbox_cmd[0] = MBOX_CMD_CONN_CLOSE_SESS_LOGOUT;
-	mbox_cmd[1] = fw_ddb_index;
-	mbox_cmd[2] = connection_id;
-	mbox_cmd[3] = LOGOUT_OPTION_RELOGIN;
-	if (qla4xxx_mailbox_command(ha, 4, 2, &mbox_cmd[0], &mbox_sts[0]) !=
-	    QLA_SUCCESS) {
-		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_CONN_CLOSE_SESS_LOGOUT "
-			      "option %04x failed sts %04X %04X",
-			      ha->host_no, __func__,
-			      option, mbox_sts[0], mbox_sts[1]));
-		if (mbox_sts[0] == 0x4005)
-			DEBUG2(printk("%s reason %04X\n", __func__,
-				      mbox_sts[1]));
-	}
-	return QLA_SUCCESS;
-}
-
-int qla4xxx_clear_database_entry(struct scsi_qla_host * ha,
-				 uint16_t fw_ddb_index)
-{
-	uint32_t mbox_cmd[MBOX_REG_COUNT];
-	uint32_t mbox_sts[MBOX_REG_COUNT];
-
-	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
-	memset(&mbox_sts, 0, sizeof(mbox_sts));
-	mbox_cmd[0] = MBOX_CMD_CLEAR_DATABASE_ENTRY;
-	mbox_cmd[1] = fw_ddb_index;
-	if (qla4xxx_mailbox_command(ha, 2, 5, &mbox_cmd[0], &mbox_sts[0]) !=
-	    QLA_SUCCESS)
-		return QLA_ERROR;
-
-	return QLA_SUCCESS;
-}
-
-#endif  /*  0  */
-
 /**
  * qla4xxx_initialize_fw_cb - initializes firmware control block.
  * @ha: Pointer to host adapter structure.
@@ -272,10 +197,13 @@ int qla4xxx_initialize_fw_cb(struct scsi
 	/* Get Initialize Firmware Control Block. */
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	mbox_cmd[0] = MBOX_CMD_GET_INIT_FW_CTRL_BLOCK;
 	mbox_cmd[2] = LSDW(init_fw_cb_dma);
 	mbox_cmd[3] = MSDW(init_fw_cb_dma);
-	if (qla4xxx_mailbox_command(ha, 4, 1, &mbox_cmd[0], &mbox_sts[0]) !=
+	mbox_cmd[4] = sizeof(struct init_fw_ctrl_blk);
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		dma_free_coherent(&ha->pdev->dev,
 				  sizeof(struct init_fw_ctrl_blk),
@@ -287,51 +215,56 @@ int qla4xxx_initialize_fw_cb(struct scsi
 	qla4xxx_init_rings(ha);
 
 	/* Fill in the request and response queue information. */
-	init_fw_cb->ReqQConsumerIndex = cpu_to_le16(ha->request_out);
-	init_fw_cb->ComplQProducerIndex = cpu_to_le16(ha->response_in);
-	init_fw_cb->ReqQLen = __constant_cpu_to_le16(REQUEST_QUEUE_DEPTH);
-	init_fw_cb->ComplQLen = __constant_cpu_to_le16(RESPONSE_QUEUE_DEPTH);
-	init_fw_cb->ReqQAddrLo = cpu_to_le32(LSDW(ha->request_dma));
-	init_fw_cb->ReqQAddrHi = cpu_to_le32(MSDW(ha->request_dma));
-	init_fw_cb->ComplQAddrLo = cpu_to_le32(LSDW(ha->response_dma));
-	init_fw_cb->ComplQAddrHi = cpu_to_le32(MSDW(ha->response_dma));
-	init_fw_cb->ShadowRegBufAddrLo =
+	init_fw_cb->pri.rqq_consumer_idx = cpu_to_le16(ha->request_out);
+	init_fw_cb->pri.compq_producer_idx = cpu_to_le16(ha->response_in);
+	init_fw_cb->pri.rqq_len = __constant_cpu_to_le16(REQUEST_QUEUE_DEPTH);
+	init_fw_cb->pri.compq_len = __constant_cpu_to_le16(RESPONSE_QUEUE_DEPTH);
+	init_fw_cb->pri.rqq_addr_lo = cpu_to_le32(LSDW(ha->request_dma));
+	init_fw_cb->pri.rqq_addr_hi = cpu_to_le32(MSDW(ha->request_dma));
+	init_fw_cb->pri.compq_addr_lo = cpu_to_le32(LSDW(ha->response_dma));
+	init_fw_cb->pri.compq_addr_hi = cpu_to_le32(MSDW(ha->response_dma));
+	init_fw_cb->pri.shdwreg_addr_lo =
 		cpu_to_le32(LSDW(ha->shadow_regs_dma));
-	init_fw_cb->ShadowRegBufAddrHi =
+	init_fw_cb->pri.shdwreg_addr_hi =
 		cpu_to_le32(MSDW(ha->shadow_regs_dma));
 
 	/* Set up required options. */
-	init_fw_cb->FwOptions |=
+	init_fw_cb->pri.fw_options |=
 		__constant_cpu_to_le16(FWOPT_SESSION_MODE |
 				       FWOPT_INITIATOR_MODE);
-	init_fw_cb->FwOptions &= __constant_cpu_to_le16(~FWOPT_TARGET_MODE);
+	init_fw_cb->pri.fw_options &= __constant_cpu_to_le16(~FWOPT_TARGET_MODE);
 
 	/* Save some info in adapter structure. */
-	ha->firmware_options = le16_to_cpu(init_fw_cb->FwOptions);
-	ha->tcp_options = le16_to_cpu(init_fw_cb->TCPOptions);
-	ha->heartbeat_interval = init_fw_cb->HeartbeatInterval;
-	memcpy(ha->ip_address, init_fw_cb->IPAddr,
-	       min(sizeof(ha->ip_address), sizeof(init_fw_cb->IPAddr)));
-	memcpy(ha->subnet_mask, init_fw_cb->SubnetMask,
-	       min(sizeof(ha->subnet_mask), sizeof(init_fw_cb->SubnetMask)));
-	memcpy(ha->gateway, init_fw_cb->GatewayIPAddr,
-	       min(sizeof(ha->gateway), sizeof(init_fw_cb->GatewayIPAddr)));
-	memcpy(ha->name_string, init_fw_cb->iSCSINameString,
+	ha->firmware_options = le16_to_cpu(init_fw_cb->pri.fw_options);
+	ha->tcp_options = le16_to_cpu(init_fw_cb->pri.ipv4_tcp_opts);
+	ha->heartbeat_interval = init_fw_cb->pri.hb_interval;
+	memcpy(ha->ip_address, init_fw_cb->pri.ipv4_addr,
+	       min(sizeof(ha->ip_address), sizeof(init_fw_cb->pri.ipv4_addr)));
+	memcpy(ha->subnet_mask, init_fw_cb->pri.ipv4_subnet,
+	       min(sizeof(ha->subnet_mask), sizeof(init_fw_cb->pri.ipv4_subnet)));
+	memcpy(ha->gateway, init_fw_cb->pri.ipv4_gw_addr,
+	       min(sizeof(ha->gateway), sizeof(init_fw_cb->pri.ipv4_gw_addr)));
+	memcpy(ha->name_string, init_fw_cb->pri.iscsi_name,
 	       min(sizeof(ha->name_string),
-		   sizeof(init_fw_cb->iSCSINameString)));
-	memcpy(ha->alias, init_fw_cb->Alias,
-	       min(sizeof(ha->alias), sizeof(init_fw_cb->Alias)));
+		   sizeof(init_fw_cb->pri.iscsi_name)));
+	/*memcpy(ha->alias, init_fw_cb->Alias,
+	       min(sizeof(ha->alias), sizeof(init_fw_cb->Alias)));*/
 
 	/* Save Command Line Paramater info */
-	ha->port_down_retry_count = le16_to_cpu(init_fw_cb->KeepAliveTimeout);
+	ha->port_down_retry_count = le16_to_cpu(init_fw_cb->pri.conn_ka_timeout);
 	ha->discovery_wait = ql4xdiscoverywait;
 
 	/* Send Initialize Firmware Control Block. */
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	mbox_cmd[0] = MBOX_CMD_INITIALIZE_FIRMWARE;
 	mbox_cmd[1] = 0;
 	mbox_cmd[2] = LSDW(init_fw_cb_dma);
 	mbox_cmd[3] = MSDW(init_fw_cb_dma);
-	if (qla4xxx_mailbox_command(ha, 4, 1, &mbox_cmd[0], &mbox_sts[0]) ==
+	mbox_cmd[4] = sizeof(struct init_fw_ctrl_blk);
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]) ==
 	    QLA_SUCCESS)
 		status = QLA_SUCCESS;
 	 else {
@@ -368,12 +301,14 @@ int qla4xxx_get_dhcp_ip_address(struct s
 	/* Get Initialize Firmware Control Block. */
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	memset(init_fw_cb, 0, sizeof(struct init_fw_ctrl_blk));
 	mbox_cmd[0] = MBOX_CMD_GET_INIT_FW_CTRL_BLOCK;
 	mbox_cmd[2] = LSDW(init_fw_cb_dma);
 	mbox_cmd[3] = MSDW(init_fw_cb_dma);
+	mbox_cmd[4] = sizeof(struct init_fw_ctrl_blk);
 
-	if (qla4xxx_mailbox_command(ha, 4, 1, &mbox_cmd[0], &mbox_sts[0]) !=
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: Failed to get init_fw_ctrl_blk\n",
 			      ha->host_no, __func__));
@@ -384,12 +319,12 @@ int qla4xxx_get_dhcp_ip_address(struct s
 	}
 
 	/* Save IP Address. */
-	memcpy(ha->ip_address, init_fw_cb->IPAddr,
-	       min(sizeof(ha->ip_address), sizeof(init_fw_cb->IPAddr)));
-	memcpy(ha->subnet_mask, init_fw_cb->SubnetMask,
-	       min(sizeof(ha->subnet_mask), sizeof(init_fw_cb->SubnetMask)));
-	memcpy(ha->gateway, init_fw_cb->GatewayIPAddr,
-	       min(sizeof(ha->gateway), sizeof(init_fw_cb->GatewayIPAddr)));
+	memcpy(ha->ip_address, init_fw_cb->pri.ipv4_addr,
+	       min(sizeof(ha->ip_address), sizeof(init_fw_cb->pri.ipv4_addr)));
+	memcpy(ha->subnet_mask, init_fw_cb->pri.ipv4_subnet,
+	       min(sizeof(ha->subnet_mask), sizeof(init_fw_cb->pri.ipv4_subnet)));
+	memcpy(ha->gateway, init_fw_cb->pri.ipv4_gw_addr,
+	       min(sizeof(ha->gateway), sizeof(init_fw_cb->pri.ipv4_gw_addr)));
 
 	dma_free_coherent(&ha->pdev->dev, sizeof(struct init_fw_ctrl_blk),
 			  init_fw_cb, init_fw_cb_dma);
@@ -409,8 +344,10 @@ int qla4xxx_get_firmware_state(struct sc
 	/* Get firmware version */
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	mbox_cmd[0] = MBOX_CMD_GET_FW_STATE;
-	if (qla4xxx_mailbox_command(ha, 1, 4, &mbox_cmd[0], &mbox_sts[0]) !=
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 4, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_GET_FW_STATE failed w/ "
 			      "status %04X\n", ha->host_no, __func__,
@@ -438,8 +375,10 @@ int qla4xxx_get_firmware_status(struct s
 	/* Get firmware version */
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	mbox_cmd[0] = MBOX_CMD_GET_FW_STATUS;
-	if (qla4xxx_mailbox_command(ha, 1, 3, &mbox_cmd[0], &mbox_sts[0]) !=
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 3, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_GET_FW_STATUS failed w/ "
 			      "status %04X\n", ha->host_no, __func__,
@@ -491,11 +430,14 @@ int qla4xxx_get_fwddb_entry(struct scsi_
 	}
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	mbox_cmd[0] = MBOX_CMD_GET_DATABASE_ENTRY;
 	mbox_cmd[1] = (uint32_t) fw_ddb_index;
 	mbox_cmd[2] = LSDW(fw_ddb_entry_dma);
 	mbox_cmd[3] = MSDW(fw_ddb_entry_dma);
-	if (qla4xxx_mailbox_command(ha, 4, 7, &mbox_cmd[0], &mbox_sts[0]) ==
+	mbox_cmd[4] = sizeof(struct dev_db_entry);
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 7, &mbox_cmd[0], &mbox_sts[0]) ==
 	    QLA_ERROR) {
 		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_GET_DATABASE_ENTRY failed"
 			      " with status 0x%04X\n", ha->host_no, __func__,
@@ -512,11 +454,11 @@ int qla4xxx_get_fwddb_entry(struct scsi_
 		dev_info(&ha->pdev->dev, "DDB[%d] MB0 %04x Tot %d Next %d "
 			   "State %04x ConnErr %08x %d.%d.%d.%d:%04d \"%s\"\n",
 			   fw_ddb_index, mbox_sts[0], mbox_sts[2], mbox_sts[3],
-			   mbox_sts[4], mbox_sts[5], fw_ddb_entry->ipAddr[0],
-			   fw_ddb_entry->ipAddr[1], fw_ddb_entry->ipAddr[2],
-			   fw_ddb_entry->ipAddr[3],
-			   le16_to_cpu(fw_ddb_entry->portNumber),
-			   fw_ddb_entry->iscsiName);
+			   mbox_sts[4], mbox_sts[5], fw_ddb_entry->ip_addr[0],
+			   fw_ddb_entry->ip_addr[1], fw_ddb_entry->ip_addr[2],
+			   fw_ddb_entry->ip_addr[3],
+			   le16_to_cpu(fw_ddb_entry->port),
+			   fw_ddb_entry->iscsi_name);
 	}
 	if (num_valid_ddb_entries)
 		*num_valid_ddb_entries = mbox_sts[2];
@@ -571,35 +513,10 @@ int qla4xxx_set_ddb_entry(struct scsi_ql
 	mbox_cmd[1] = (uint32_t) fw_ddb_index;
 	mbox_cmd[2] = LSDW(fw_ddb_entry_dma);
 	mbox_cmd[3] = MSDW(fw_ddb_entry_dma);
-	return qla4xxx_mailbox_command(ha, 4, 1, &mbox_cmd[0], &mbox_sts[0]);
-}
+	mbox_cmd[4] = sizeof(struct dev_db_entry);
 
-#if 0
-int qla4xxx_conn_open_session_login(struct scsi_qla_host * ha,
-				    uint16_t fw_ddb_index)
-{
-	int status = QLA_ERROR;
-	uint32_t mbox_cmd[MBOX_REG_COUNT];
-	uint32_t mbox_sts[MBOX_REG_COUNT];
-
-	/* Do not wait for completion. The firmware will send us an
-	 * ASTS_DATABASE_CHANGED (0x8014) to notify us of the login status.
-	 */
-	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
-	memset(&mbox_sts, 0, sizeof(mbox_sts));
-	mbox_cmd[0] = MBOX_CMD_CONN_OPEN_SESS_LOGIN;
-	mbox_cmd[1] = (uint32_t) fw_ddb_index;
-	mbox_cmd[2] = 0;
-	mbox_cmd[3] = 0;
-	mbox_cmd[4] = 0;
-	status = qla4xxx_mailbox_command(ha, 4, 0, &mbox_cmd[0], &mbox_sts[0]);
-	DEBUG2(printk("%s fw_ddb_index=%d status=%d mbx0_1=0x%x :0x%x\n",
-		      __func__, fw_ddb_index, status, mbox_sts[0],
-		      mbox_sts[1]);)
-
-		return status;
+	return qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]);
 }
-#endif  /*  0  */
 
 /**
  * qla4xxx_get_crash_record - retrieves crash record.
@@ -614,12 +531,14 @@ void qla4xxx_get_crash_record(struct scs
 	struct crash_record *crash_record = NULL;
 	dma_addr_t crash_record_dma = 0;
 	uint32_t crash_record_size = 0;
+
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_cmd));
 
 	/* Get size of crash record. */
 	mbox_cmd[0] = MBOX_CMD_GET_CRASH_RECORD;
-	if (qla4xxx_mailbox_command(ha, 5, 5, &mbox_cmd[0], &mbox_sts[0]) !=
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: ERROR: Unable to retrieve size!\n",
 			      ha->host_no, __func__));
@@ -639,11 +558,15 @@ void qla4xxx_get_crash_record(struct scs
 		goto exit_get_crash_record;
 
 	/* Get Crash Record. */
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_cmd));
+
 	mbox_cmd[0] = MBOX_CMD_GET_CRASH_RECORD;
 	mbox_cmd[2] = LSDW(crash_record_dma);
 	mbox_cmd[3] = MSDW(crash_record_dma);
 	mbox_cmd[4] = crash_record_size;
-	if (qla4xxx_mailbox_command(ha, 5, 5, &mbox_cmd[0], &mbox_sts[0]) !=
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS)
 		goto exit_get_crash_record;
 
@@ -655,7 +578,6 @@ exit_get_crash_record:
 				  crash_record, crash_record_dma);
 }
 
-#if 0
 /**
  * qla4xxx_get_conn_event_log - retrieves connection event log
  * @ha: Pointer to host adapter structure.
@@ -678,7 +600,8 @@ void qla4xxx_get_conn_event_log(struct s
 
 	/* Get size of crash record. */
 	mbox_cmd[0] = MBOX_CMD_GET_CONN_EVENT_LOG;
-	if (qla4xxx_mailbox_command(ha, 4, 5, &mbox_cmd[0], &mbox_sts[0]) !=
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS)
 		goto exit_get_event_log;
 
@@ -693,10 +616,14 @@ void qla4xxx_get_conn_event_log(struct s
 		goto exit_get_event_log;
 
 	/* Get Crash Record. */
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_cmd));
+
 	mbox_cmd[0] = MBOX_CMD_GET_CONN_EVENT_LOG;
 	mbox_cmd[2] = LSDW(event_log_dma);
 	mbox_cmd[3] = MSDW(event_log_dma);
-	if (qla4xxx_mailbox_command(ha, 4, 5, &mbox_cmd[0], &mbox_sts[0]) !=
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: ERROR: Unable to retrieve event "
 			      "log!\n", ha->host_no, __func__));
@@ -745,7 +672,6 @@ exit_get_event_log:
 		dma_free_coherent(&ha->pdev->dev, event_log_size, event_log,
 				  event_log_dma);
 }
-#endif  /*  0  */
 
 /**
  * qla4xxx_reset_lun - issues LUN Reset
@@ -773,11 +699,13 @@ int qla4xxx_reset_lun(struct scsi_qla_ho
 	 */
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	mbox_cmd[0] = MBOX_CMD_LUN_RESET;
 	mbox_cmd[1] = ddb_entry->fw_ddb_index;
 	mbox_cmd[2] = lun << 8;
 	mbox_cmd[5] = 0x01;	/* Immediate Command Enable */
-	qla4xxx_mailbox_command(ha, 6, 1, &mbox_cmd[0], &mbox_sts[0]);
+
+	qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]);
 	if (mbox_sts[0] != MBOX_STS_COMMAND_COMPLETE &&
 	    mbox_sts[0] != MBOX_STS_COMMAND_ERROR)
 		status = QLA_ERROR;
@@ -794,12 +722,14 @@ int qla4xxx_get_flash(struct scsi_qla_ho
 
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	mbox_cmd[0] = MBOX_CMD_READ_FLASH;
 	mbox_cmd[1] = LSDW(dma_addr);
 	mbox_cmd[2] = MSDW(dma_addr);
 	mbox_cmd[3] = offset;
 	mbox_cmd[4] = len;
-	if (qla4xxx_mailbox_command(ha, 5, 2, &mbox_cmd[0], &mbox_sts[0]) !=
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 2, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_READ_FLASH, failed w/ "
 		    "status %04X %04X, offset %08x, len %08x\n", ha->host_no,
@@ -825,8 +755,10 @@ int qla4xxx_get_fw_version(struct scsi_q
 	/* Get firmware version. */
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	mbox_cmd[0] = MBOX_CMD_ABOUT_FW;
-	if (qla4xxx_mailbox_command(ha, 4, 5, &mbox_cmd[0], &mbox_sts[0]) !=
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_ABOUT_FW failed w/ "
 		    "status %04X\n", ha->host_no, __func__, mbox_sts[0]));
@@ -855,7 +787,7 @@ static int qla4xxx_get_default_ddb(struc
 	mbox_cmd[2] = LSDW(dma_addr);
 	mbox_cmd[3] = MSDW(dma_addr);
 
-	if (qla4xxx_mailbox_command(ha, 4, 1, &mbox_cmd[0], &mbox_sts[0]) !=
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: failed status %04X\n",
 		     ha->host_no, __func__, mbox_sts[0]));
@@ -875,7 +807,7 @@ static int qla4xxx_req_ddb_entry(struct 
 	mbox_cmd[0] = MBOX_CMD_REQUEST_DATABASE_ENTRY;
 	mbox_cmd[1] = MAX_PRST_DEV_DB_ENTRIES;
 
-	if (qla4xxx_mailbox_command(ha, 2, 3, &mbox_cmd[0], &mbox_sts[0]) !=
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 3, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		if (mbox_sts[0] == MBOX_STS_COMMAND_ERROR) {
 			*ddb_index = mbox_sts[2];
@@ -918,23 +850,23 @@ int qla4xxx_send_tgts(struct scsi_qla_ho
 	if (ret_val != QLA_SUCCESS)
 		goto qla4xxx_send_tgts_exit;
 
-	memset((void *)fw_ddb_entry->iSCSIAlias, 0,
-	       sizeof(fw_ddb_entry->iSCSIAlias));
+	memset(fw_ddb_entry->iscsi_alias, 0,
+	       sizeof(fw_ddb_entry->iscsi_alias));
 
-	memset((void *)fw_ddb_entry->iscsiName, 0,
-	       sizeof(fw_ddb_entry->iscsiName));
+	memset(fw_ddb_entry->iscsi_name, 0,
+	       sizeof(fw_ddb_entry->iscsi_name));
 
-	memset((void *)fw_ddb_entry->ipAddr, 0, sizeof(fw_ddb_entry->ipAddr));
-	memset((void *)fw_ddb_entry->targetAddr, 0,
-	       sizeof(fw_ddb_entry->targetAddr));
+	memset(fw_ddb_entry->ip_addr, 0, sizeof(fw_ddb_entry->ip_addr));
+	memset(fw_ddb_entry->tgt_addr, 0,
+	       sizeof(fw_ddb_entry->tgt_addr));
 
 	fw_ddb_entry->options = (DDB_OPT_DISC_SESSION | DDB_OPT_TARGET);
-	fw_ddb_entry->portNumber = cpu_to_le16(ntohs(port));
+	fw_ddb_entry->port = cpu_to_le16(ntohs(port));
 
-	fw_ddb_entry->ipAddr[0] = *ip;
-	fw_ddb_entry->ipAddr[1] = *(ip + 1);
-	fw_ddb_entry->ipAddr[2] = *(ip + 2);
-	fw_ddb_entry->ipAddr[3] = *(ip + 3);
+	fw_ddb_entry->ip_addr[0] = *ip;
+	fw_ddb_entry->ip_addr[1] = *(ip + 1);
+	fw_ddb_entry->ip_addr[2] = *(ip + 2);
+	fw_ddb_entry->ip_addr[3] = *(ip + 3);
 
 	ret_val = qla4xxx_set_ddb_entry(ha, ddb_index, fw_ddb_entry_dma);
 

