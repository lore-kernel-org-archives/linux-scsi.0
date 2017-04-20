From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/4] scsi: pmcraid: fix endianess sparse annotations
Date: Thu, 20 Apr 2017 19:54:47 +0200
Message-ID: <20170420175549.3435196-3-arnd@arndb.de>
References: <20170420175549.3435196-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:50940 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033676AbdDTR45 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 13:56:57 -0400
In-Reply-To: <20170420175549.3435196-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Johannes Berg <johannes.berg@intel.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The use of le32_to_cpu() etc in this driver looks completely arbitrary.
It may have made sense at some point, but it is not applied consistently,
so this driver presumably won't work on big-endian kernel builds.

Unfortunately it's unclear whether the type names or the calls to
le32_to_cpu() are the correct ones. I'm taking educated guesses here
and assume that most of the __le32 and __le16 annotations are correct,
adding the conversion helpers whereever we access those fields.

The exceptions are the 'fw_version' field that is always accessed as
big-endian, so I'm changing the type here, and the 'hrrq' values that
are accessed as little-endian, so I'm changing those the other way.

None of these changes should have any effect on little-endian
architectures like x86, but it addresses the sparse warnings.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/pmcraid.c | 95 +++++++++++++++++++++++++-------------------------
 drivers/scsi/pmcraid.h |  8 ++---
 2 files changed, 51 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 35087e94c2ad..58c7511c5bd5 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -175,7 +175,7 @@ static int pmcraid_slave_alloc(struct scsi_device *scsi_dev)
 			if (fw_version <= PMCRAID_FW_VERSION_1)
 				target = temp->cfg_entry.unique_flags1;
 			else
-				target = temp->cfg_entry.array_id & 0xFF;
+				target = le16_to_cpu(temp->cfg_entry.array_id) & 0xFF;
 
 			if (target > PMCRAID_MAX_VSET_TARGETS)
 				continue;
@@ -330,7 +330,7 @@ static void pmcraid_init_cmdblk(struct pmcraid_cmd *cmd, int index)
 		ioarcb->request_flags0 = 0;
 		ioarcb->request_flags1 = 0;
 		ioarcb->cmd_timeout = 0;
-		ioarcb->ioarcb_bus_addr &= (~0x1FULL);
+		ioarcb->ioarcb_bus_addr &= cpu_to_le64(~0x1FULL);
 		ioarcb->ioadl_bus_addr = 0;
 		ioarcb->ioadl_length = 0;
 		ioarcb->data_transfer_length = 0;
@@ -898,8 +898,7 @@ static void _pmcraid_fire_command(struct pmcraid_cmd *cmd)
 
 	/* driver writes lower 32-bit value of IOARCB address only */
 	mb();
-	iowrite32(le32_to_cpu(cmd->ioa_cb->ioarcb.ioarcb_bus_addr),
-		  pinstance->ioarrin);
+	iowrite32(le64_to_cpu(cmd->ioa_cb->ioarcb.ioarcb_bus_addr), pinstance->ioarrin);
 }
 
 /**
@@ -1051,7 +1050,7 @@ static void pmcraid_get_fwversion(struct pmcraid_cmd *cmd)
 					offsetof(struct pmcraid_ioarcb,
 						add_data.u.ioadl[0]));
 	ioarcb->ioadl_length = cpu_to_le32(sizeof(struct pmcraid_ioadl_desc));
-	ioarcb->ioarcb_bus_addr &= ~(0x1FULL);
+	ioarcb->ioarcb_bus_addr &= cpu_to_le64(~(0x1FULL));
 
 	ioarcb->request_flags0 |= NO_LINK_DESCS;
 	ioarcb->data_transfer_length = cpu_to_le32(data_size);
@@ -1077,7 +1076,7 @@ static void pmcraid_identify_hrrq(struct pmcraid_cmd *cmd)
 	struct pmcraid_ioarcb *ioarcb = &cmd->ioa_cb->ioarcb;
 	int index = cmd->hrrq_index;
 	__be64 hrrq_addr = cpu_to_be64(pinstance->hrrq_start_bus_addr[index]);
-	u32 hrrq_size = cpu_to_be32(sizeof(u32) * PMCRAID_MAX_CMD);
+	__be32 hrrq_size = cpu_to_be32(sizeof(u32) * PMCRAID_MAX_CMD);
 	void (*done_function)(struct pmcraid_cmd *);
 
 	pmcraid_reinit_cmdblk(cmd);
@@ -1202,7 +1201,7 @@ static struct pmcraid_cmd *pmcraid_init_hcam
 
 	ioadl[0].flags |= IOADL_FLAGS_READ_LAST;
 	ioadl[0].data_len = cpu_to_le32(rcb_size);
-	ioadl[0].address = cpu_to_le32(dma);
+	ioadl[0].address = cpu_to_le64(dma);
 
 	cmd->cmd_done = cmd_done;
 	return cmd;
@@ -1237,7 +1236,13 @@ static void pmcraid_prepare_cancel_cmd(
 )
 {
 	struct pmcraid_ioarcb *ioarcb = &cmd->ioa_cb->ioarcb;
-	__be64 ioarcb_addr = cmd_to_cancel->ioa_cb->ioarcb.ioarcb_bus_addr;
+	__be64 ioarcb_addr;
+
+	/* IOARCB address of the command to be cancelled is given in
+	 * cdb[2]..cdb[9] is Big-Endian format. Note that length bits in
+	 * IOARCB address are not masked.
+	 */
+	ioarcb_addr = cpu_to_be64(le64_to_cpu(cmd_to_cancel->ioa_cb->ioarcb.ioarcb_bus_addr));
 
 	/* Get the resource handle to where the command to be aborted has been
 	 * sent.
@@ -1247,11 +1252,6 @@ static void pmcraid_prepare_cancel_cmd(
 	memset(ioarcb->cdb, 0, PMCRAID_MAX_CDB_LEN);
 	ioarcb->cdb[0] = PMCRAID_ABORT_CMD;
 
-	/* IOARCB address of the command to be cancelled is given in
-	 * cdb[2]..cdb[9] is Big-Endian format. Note that length bits in
-	 * IOARCB address are not masked.
-	 */
-	ioarcb_addr = cpu_to_be64(ioarcb_addr);
 	memcpy(&(ioarcb->cdb[2]), &ioarcb_addr, sizeof(ioarcb_addr));
 }
 
@@ -1493,7 +1493,7 @@ static int pmcraid_notify_ccn(struct pmcraid_instance *pinstance)
 {
 	return pmcraid_notify_aen(pinstance,
 				pinstance->ccn.msg,
-				pinstance->ccn.hcam->data_len +
+				le32_to_cpu(pinstance->ccn.hcam->data_len) +
 				sizeof(struct pmcraid_hcam_hdr));
 }
 
@@ -1508,7 +1508,7 @@ static int pmcraid_notify_ldn(struct pmcraid_instance *pinstance)
 {
 	return pmcraid_notify_aen(pinstance,
 				pinstance->ldn.msg,
-				pinstance->ldn.hcam->data_len +
+				le32_to_cpu(pinstance->ldn.hcam->data_len) +
 				sizeof(struct pmcraid_hcam_hdr));
 }
 
@@ -1556,10 +1556,10 @@ static void pmcraid_handle_config_change(struct pmcraid_instance *pinstance)
 
 	pmcraid_info("CCN(%x): %x timestamp: %llx type: %x lost: %x flags: %x \
 		 res: %x:%x:%x:%x\n",
-		 pinstance->ccn.hcam->ilid,
+		 le32_to_cpu(pinstance->ccn.hcam->ilid),
 		 pinstance->ccn.hcam->op_code,
-		((pinstance->ccn.hcam->timestamp1) |
-		((pinstance->ccn.hcam->timestamp2 & 0xffffffffLL) << 32)),
+		(le32_to_cpu(pinstance->ccn.hcam->timestamp1) |
+		((le32_to_cpu(pinstance->ccn.hcam->timestamp2) & 0xffffffffLL) << 32)),
 		 pinstance->ccn.hcam->notification_type,
 		 pinstance->ccn.hcam->notification_lost,
 		 pinstance->ccn.hcam->flags,
@@ -1570,7 +1570,7 @@ static void pmcraid_handle_config_change(struct pmcraid_instance *pinstance)
 		 RES_IS_VSET(*cfg_entry) ?
 			(fw_version <= PMCRAID_FW_VERSION_1 ?
 				cfg_entry->unique_flags1 :
-					cfg_entry->array_id & 0xFF) :
+				le16_to_cpu(cfg_entry->array_id) & 0xFF) :
 			RES_TARGET(cfg_entry->resource_address),
 		 RES_LUN(cfg_entry->resource_address));
 
@@ -1658,7 +1658,7 @@ static void pmcraid_handle_config_change(struct pmcraid_instance *pinstance)
 			if (fw_version <= PMCRAID_FW_VERSION_1)
 				res->cfg_entry.unique_flags1 &= 0x7F;
 			else
-				res->cfg_entry.array_id &= 0xFF;
+				res->cfg_entry.array_id &= cpu_to_le16(0xFF);
 			res->change_detected = RES_CHANGE_DEL;
 			res->cfg_entry.resource_handle =
 				PMCRAID_INVALID_RES_HANDLE;
@@ -1716,8 +1716,8 @@ static void pmcraid_ioasc_logger(u32 ioasc, struct pmcraid_cmd *cmd)
 	/* log the error string */
 	pmcraid_err("cmd [%x] for resource %x failed with %x(%s)\n",
 		cmd->ioa_cb->ioarcb.cdb[0],
-		cmd->ioa_cb->ioarcb.resource_handle,
-		le32_to_cpu(ioasc), error_info->error_string);
+		le32_to_cpu(cmd->ioa_cb->ioarcb.resource_handle),
+		ioasc, error_info->error_string);
 }
 
 /**
@@ -2034,7 +2034,7 @@ static void pmcraid_fail_outstanding_cmds(struct pmcraid_instance *pinstance)
 		cmd->ioa_cb->ioasa.ioasc =
 			cpu_to_le32(PMCRAID_IOASC_IOA_WAS_RESET);
 		cmd->ioa_cb->ioasa.ilid =
-			cpu_to_be32(PMCRAID_DRIVER_ILID);
+			cpu_to_le32(PMCRAID_DRIVER_ILID);
 
 		/* In case the command timer is still running */
 		del_timer(&cmd->timer);
@@ -2532,7 +2532,7 @@ static void pmcraid_cancel_all(struct pmcraid_cmd *cmd, u32 sense)
 	ioarcb->ioadl_bus_addr = 0;
 	ioarcb->ioadl_length = 0;
 	ioarcb->data_transfer_length = 0;
-	ioarcb->ioarcb_bus_addr &= (~0x1FULL);
+	ioarcb->ioarcb_bus_addr &= cpu_to_le64((~0x1FULL));
 
 	/* writing to IOARRIN must be protected by host_lock, as mid-layer
 	 * schedule queuecommand while we are doing this
@@ -2695,8 +2695,8 @@ static int pmcraid_error_handler(struct pmcraid_cmd *cmd)
 		 * mid-layer
 		 */
 		if (ioasa->auto_sense_length != 0) {
-			short sense_len = ioasa->auto_sense_length;
-			int data_size = min_t(u16, le16_to_cpu(sense_len),
+			short sense_len = le16_to_cpu(ioasa->auto_sense_length);
+			int data_size = min_t(u16, sense_len,
 					      SCSI_SENSE_BUFFERSIZE);
 
 			memcpy(scsi_cmd->sense_buffer,
@@ -2918,7 +2918,7 @@ static struct pmcraid_cmd *pmcraid_abort_cmd(struct pmcraid_cmd *cmd)
 
 	pmcraid_info("aborting command CDB[0]= %x with index = %d\n",
 		cmd->ioa_cb->ioarcb.cdb[0],
-		cmd->ioa_cb->ioarcb.response_handle >> 2);
+		le32_to_cpu(cmd->ioa_cb->ioarcb.response_handle) >> 2);
 
 	init_completion(&cancel_cmd->wait_for_completion);
 	cancel_cmd->completion_req = 1;
@@ -3143,9 +3143,8 @@ pmcraid_init_ioadls(struct pmcraid_cmd *cmd, int sgcount)
 	int ioadl_count = 0;
 
 	if (ioarcb->add_cmd_param_length)
-		ioadl_count = DIV_ROUND_UP(ioarcb->add_cmd_param_length, 16);
-	ioarcb->ioadl_length =
-		sizeof(struct pmcraid_ioadl_desc) * sgcount;
+		ioadl_count = DIV_ROUND_UP(le16_to_cpu(ioarcb->add_cmd_param_length), 16);
+	ioarcb->ioadl_length = cpu_to_le32(sizeof(struct pmcraid_ioadl_desc) * sgcount);
 
 	if ((sgcount + ioadl_count) > (ARRAY_SIZE(ioarcb->add_data.u.ioadl))) {
 		/* external ioadls start at offset 0x80 from control_block
@@ -3153,7 +3152,7 @@ pmcraid_init_ioadls(struct pmcraid_cmd *cmd, int sgcount)
 		 * It is necessary to indicate to firmware that driver is
 		 * using ioadls to be treated as external to IOARCB.
 		 */
-		ioarcb->ioarcb_bus_addr &= ~(0x1FULL);
+		ioarcb->ioarcb_bus_addr &= cpu_to_le64(~(0x1FULL));
 		ioarcb->ioadl_bus_addr =
 			cpu_to_le64((cmd->ioa_cb_bus_addr) +
 				offsetof(struct pmcraid_ioarcb,
@@ -3167,7 +3166,7 @@ pmcraid_init_ioadls(struct pmcraid_cmd *cmd, int sgcount)
 
 		ioadl = &ioarcb->add_data.u.ioadl[ioadl_count];
 		ioarcb->ioarcb_bus_addr |=
-				DIV_ROUND_CLOSEST(sgcount + ioadl_count, 8);
+			cpu_to_le64(DIV_ROUND_CLOSEST(sgcount + ioadl_count, 8));
 	}
 
 	return ioadl;
@@ -3493,7 +3492,7 @@ static int pmcraid_queuecommand_lck(
 		     RES_IS_VSET(res->cfg_entry) ?
 			(fw_version <= PMCRAID_FW_VERSION_1 ?
 				res->cfg_entry.unique_flags1 :
-					res->cfg_entry.array_id & 0xFF) :
+				le16_to_cpu(res->cfg_entry.array_id) & 0xFF) :
 			RES_TARGET(res->cfg_entry.resource_address),
 		     RES_LUN(res->cfg_entry.resource_address));
 
@@ -3709,7 +3708,7 @@ static long pmcraid_ioctl_passthrough(
 		goto out_free_buffer;
 	}
 
-	request_size = buffer->ioarcb.data_transfer_length;
+	request_size = le32_to_cpu(buffer->ioarcb.data_transfer_length);
 
 	if (buffer->ioarcb.request_flags0 & TRANSFER_DIR_WRITE) {
 		access = VERIFY_READ;
@@ -3732,7 +3731,8 @@ static long pmcraid_ioctl_passthrough(
 	}
 
 	/* check if we have any additional command parameters */
-	if (buffer->ioarcb.add_cmd_param_length > PMCRAID_ADD_CMD_PARAM_LEN) {
+	if (le16_to_cpu(buffer->ioarcb.add_cmd_param_length)
+	     > PMCRAID_ADD_CMD_PARAM_LEN) {
 		rc = -EINVAL;
 		goto out_free_buffer;
 	}
@@ -3764,7 +3764,7 @@ static long pmcraid_ioctl_passthrough(
 			buffer->ioarcb.add_cmd_param_offset;
 		memcpy(ioarcb->add_data.u.add_cmd_params,
 			buffer->ioarcb.add_data.u.add_cmd_params,
-			buffer->ioarcb.add_cmd_param_length);
+			le16_to_cpu(buffer->ioarcb.add_cmd_param_length));
 	}
 
 	/* set hrrq number where the IOA should respond to. Note that all cmds
@@ -3834,10 +3834,10 @@ static long pmcraid_ioctl_passthrough(
 		wait_for_completion(&cmd->wait_for_completion);
 	} else if (!wait_for_completion_timeout(
 			&cmd->wait_for_completion,
-			msecs_to_jiffies(buffer->ioarcb.cmd_timeout * 1000))) {
+			msecs_to_jiffies(le16_to_cpu(buffer->ioarcb.cmd_timeout) * 1000))) {
 
 		pmcraid_info("aborting cmd %d (CDB[0] = %x) due to timeout\n",
-			le32_to_cpu(cmd->ioa_cb->ioarcb.response_handle >> 2),
+			le32_to_cpu(cmd->ioa_cb->ioarcb.response_handle) >> 2,
 			cmd->ioa_cb->ioarcb.cdb[0]);
 
 		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
@@ -3846,7 +3846,7 @@ static long pmcraid_ioctl_passthrough(
 
 		if (cancel_cmd) {
 			wait_for_completion(&cancel_cmd->wait_for_completion);
-			ioasc = cancel_cmd->ioa_cb->ioasa.ioasc;
+			ioasc = le32_to_cpu(cancel_cmd->ioa_cb->ioasa.ioasc);
 			pmcraid_return_cmd(cancel_cmd);
 
 			/* if abort task couldn't find the command i.e it got
@@ -4461,7 +4461,7 @@ static void pmcraid_worker_function(struct work_struct *workp)
 				if (fw_version <= PMCRAID_FW_VERSION_1)
 					target = res->cfg_entry.unique_flags1;
 				else
-					target = res->cfg_entry.array_id & 0xFF;
+					target = le16_to_cpu(res->cfg_entry.array_id) & 0xFF;
 				lun = PMCRAID_VSET_LUN_ID;
 			} else {
 				bus = PMCRAID_PHYS_BUS_ID;
@@ -4500,7 +4500,7 @@ static void pmcraid_tasklet_function(unsigned long instance)
 	unsigned long host_lock_flags;
 	spinlock_t *lockp; /* hrrq buffer lock */
 	int id;
-	__le32 resp;
+	u32 resp;
 
 	hrrq_vector = (struct pmcraid_isr_param *)instance;
 	pinstance = hrrq_vector->drv_inst;
@@ -5540,8 +5540,7 @@ static void pmcraid_set_timestamp(struct pmcraid_cmd *cmd)
 	struct pmcraid_ioarcb *ioarcb = &cmd->ioa_cb->ioarcb;
 	__be32 time_stamp_len = cpu_to_be32(PMCRAID_TIMESTAMP_LEN);
 	struct pmcraid_ioadl_desc *ioadl = ioarcb->add_data.u.ioadl;
-
-	__le64 timestamp;
+	u64 timestamp;
 
 	timestamp = ktime_get_real_seconds() * 1000;
 
@@ -5563,7 +5562,7 @@ static void pmcraid_set_timestamp(struct pmcraid_cmd *cmd)
 					offsetof(struct pmcraid_ioarcb,
 						add_data.u.ioadl[0]));
 	ioarcb->ioadl_length = cpu_to_le32(sizeof(struct pmcraid_ioadl_desc));
-	ioarcb->ioarcb_bus_addr &= ~(0x1FULL);
+	ioarcb->ioarcb_bus_addr &= cpu_to_le64(~(0x1FULL));
 
 	ioarcb->request_flags0 |= NO_LINK_DESCS;
 	ioarcb->request_flags0 |= TRANSFER_DIR_WRITE;
@@ -5622,7 +5621,7 @@ static void pmcraid_init_res_table(struct pmcraid_cmd *cmd)
 	list_for_each_entry_safe(res, temp, &pinstance->used_res_q, queue)
 		list_move_tail(&res->queue, &old_res);
 
-	for (i = 0; i < pinstance->cfg_table->num_entries; i++) {
+	for (i = 0; i < le16_to_cpu(pinstance->cfg_table->num_entries); i++) {
 		if (be16_to_cpu(pinstance->inq_data->fw_version) <=
 						PMCRAID_FW_VERSION_1)
 			cfgte = &pinstance->cfg_table->entries[i];
@@ -5677,7 +5676,7 @@ static void pmcraid_init_res_table(struct pmcraid_cmd *cmd)
 				 res->cfg_entry.resource_type,
 				 (fw_version <= PMCRAID_FW_VERSION_1 ?
 					res->cfg_entry.unique_flags1 :
-						res->cfg_entry.array_id & 0xFF),
+					le16_to_cpu(res->cfg_entry.array_id) & 0xFF),
 				 le32_to_cpu(res->cfg_entry.resource_address));
 		}
 	}
@@ -5715,7 +5714,7 @@ static void pmcraid_querycfg(struct pmcraid_cmd *cmd)
 	struct pmcraid_ioarcb *ioarcb = &cmd->ioa_cb->ioarcb;
 	struct pmcraid_ioadl_desc *ioadl = ioarcb->add_data.u.ioadl;
 	struct pmcraid_instance *pinstance = cmd->drv_inst;
-	int cfg_table_size = cpu_to_be32(sizeof(struct pmcraid_config_table));
+	__be32 cfg_table_size = cpu_to_be32(sizeof(struct pmcraid_config_table));
 
 	if (be16_to_cpu(pinstance->inq_data->fw_version) <=
 					PMCRAID_FW_VERSION_1)
@@ -5740,7 +5739,7 @@ static void pmcraid_querycfg(struct pmcraid_cmd *cmd)
 					offsetof(struct pmcraid_ioarcb,
 						add_data.u.ioadl[0]));
 	ioarcb->ioadl_length = cpu_to_le32(sizeof(struct pmcraid_ioadl_desc));
-	ioarcb->ioarcb_bus_addr &= ~(0x1FULL);
+	ioarcb->ioarcb_bus_addr &= cpu_to_le64(~0x1FULL);
 
 	ioarcb->request_flags0 |= NO_LINK_DESCS;
 	ioarcb->data_transfer_length =
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index 568b18a2f47d..01eb2bc16dc1 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -554,7 +554,7 @@ struct pmcraid_inquiry_data {
 	__u8	add_page_len;
 	__u8	length;
 	__u8	reserved2;
-	__le16	fw_version;
+	__be16	fw_version;
 	__u8	reserved3[16];
 };
 
@@ -697,13 +697,13 @@ struct pmcraid_instance {
 	dma_addr_t hrrq_start_bus_addr[PMCRAID_NUM_MSIX_VECTORS];
 
 	/* Pointer to 1st entry of HRRQ */
-	__be32 *hrrq_start[PMCRAID_NUM_MSIX_VECTORS];
+	__le32 *hrrq_start[PMCRAID_NUM_MSIX_VECTORS];
 
 	/* Pointer to last entry of HRRQ */
-	__be32 *hrrq_end[PMCRAID_NUM_MSIX_VECTORS];
+	__le32 *hrrq_end[PMCRAID_NUM_MSIX_VECTORS];
 
 	/* Pointer to current pointer of hrrq */
-	__be32 *hrrq_curr[PMCRAID_NUM_MSIX_VECTORS];
+	__le32 *hrrq_curr[PMCRAID_NUM_MSIX_VECTORS];
 
 	/* Lock for HRRQ access */
 	spinlock_t hrrq_lock[PMCRAID_NUM_MSIX_VECTORS];
-- 
2.9.0
