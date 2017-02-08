From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 03/39] megaraid_sas: raid 1 fast path code optimize
Date: Wed,  8 Feb 2017 01:28:57 -0800
Message-ID: <1486546173-20713-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:35440 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753856AbdBHJao (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 04:30:44 -0500
Received: by mail-pg0-f47.google.com with SMTP id 194so47582628pgd.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 01:30:04 -0800 (PST)
In-Reply-To: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

fix in v2 - ex_status and status was wrongly re-used in megasas_complete_r1_command.
discussed below -
http://marc.info/?l=linux-scsi&m=148638763409385&w=2


No functional change. Code refactor.
Remove function megasas_fpio_to_ldio as we never require to convert fpio to ldio because of frame unavailability.
Grab extra frame of raid 1 write fast path before it creates first frame as Fast Path.
Removed is_raid_1_fp_write flag as raid 1 write fast path command is decided using r1_alt_dev_handle only.
Move resetting megasas_cmd_fusion fields at common function megasas_return_cmd_fusion.


Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  14 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 349 +++++++++-------------------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |   3 +-
 3 files changed, 118 insertions(+), 248 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index f1384b0..24258af 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -1338,20 +1338,8 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 					ref_in_start_stripe, io_info,
 					pRAID_Context, map);
 		/* If IO on an invalid Pd, then FP is not possible.*/
-		if (io_info->devHandle == cpu_to_le16(MR_PD_INVALID))
+		if (io_info->devHandle == MR_DEVHANDLE_INVALID)
 			io_info->fpOkForIo = FALSE;
-		/* if FP possible, set the SLUD bit in
-		 *  regLockFlags for ventura
-		 */
-		else if ((instance->is_ventura) && (!isRead) &&
-			(raid->writeMode == MR_RL_WRITE_BACK_MODE) &&
-			(raid->capability.fp_cache_bypass_capable))
-			((struct RAID_CONTEXT_G35 *) pRAID_Context)->routing_flags.bits.sld = 1;
-		/* set raid 1/10 fast path write capable bit in io_info */
-		if (io_info->fpOkForIo &&
-		    (io_info->r1_alt_dev_handle != MR_PD_INVALID) &&
-		    (raid->level == 1) && !isRead)
-			io_info->is_raid_1_fp_write = 1;
 		return retval;
 	} else if (isRead) {
 		uint stripIdx;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 514c306..7516589 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -181,7 +181,9 @@ inline void megasas_return_cmd_fusion(struct megasas_instance *instance,
 	struct megasas_cmd_fusion *cmd)
 {
 	cmd->scmd = NULL;
-	memset(cmd->io_request, 0, sizeof(struct MPI2_RAID_SCSI_IO_REQUEST));
+	memset(cmd->io_request, 0, MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE);
+	cmd->r1_alt_dev_handle = MR_DEVHANDLE_INVALID;
+	cmd->cmd_completed = false;
 }
 
 /**
@@ -701,7 +703,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 		memset(cmd->io_request, 0,
 		       sizeof(struct MPI2_RAID_SCSI_IO_REQUEST));
 		cmd->io_request_phys_addr = io_req_base_phys + offset;
-		cmd->is_raid_1_fp_write = 0;
+		cmd->r1_alt_dev_handle = MR_DEVHANDLE_INVALID;
 	}
 
 	if (megasas_create_sg_sense_fusion(instance))
@@ -1984,7 +1986,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 	io_info.ldStartBlock = ((u64)start_lba_hi << 32) | start_lba_lo;
 	io_info.numBlocks = datalength;
 	io_info.ldTgtId = device_id;
-	io_info.r1_alt_dev_handle = MR_PD_INVALID;
+	io_info.r1_alt_dev_handle = MR_DEVHANDLE_INVALID;
 	scsi_buff_len = scsi_bufflen(scp);
 	io_request->DataLength = cpu_to_le32(scsi_buff_len);
 
@@ -2025,7 +2027,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 		    io_info.isRead && io_info.ra_capable)
 			fp_possible = false;
 
-		if (io_info.r1_alt_dev_handle != MR_PD_INVALID) {
+		if (io_info.r1_alt_dev_handle != MR_DEVHANDLE_INVALID) {
 			mrdev_priv = scp->device->hostdata;
 
 			if (atomic_inc_return(&instance->fw_outstanding) >
@@ -2090,9 +2092,10 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 		} else
 			scp->SCp.Status &= ~MEGASAS_LOAD_BALANCE_FLAG;
 
-		cmd->is_raid_1_fp_write = io_info.is_raid_1_fp_write;
-		if (io_info.is_raid_1_fp_write)
+		if (instance->is_ventura)
 			cmd->r1_alt_dev_handle = io_info.r1_alt_dev_handle;
+		else
+			cmd->r1_alt_dev_handle = MR_DEVHANDLE_INVALID;
 
 		if ((raidLUN[0] == 1) &&
 			(local_map_ptr->raidMap.devHndlInfo[io_info.pd_after_lb].validHandles > 1)) {
@@ -2451,72 +2454,6 @@ megasas_get_request_descriptor(struct megasas_instance *instance, u16 index)
 	return (union MEGASAS_REQUEST_DESCRIPTOR_UNION *)p;
 }
 
-/*
- * megasas_fpio_to_ldio-
- * This function converts an fp io to ldio
- */
-
-void megasas_fpio_to_ldio(struct megasas_instance *instance,
-	struct megasas_cmd_fusion *cmd, struct scsi_cmnd *scmd)
-{
-	struct fusion_context *fusion;
-	union RAID_CONTEXT_UNION *praid_context;
-	struct MR_LD_RAID *raid;
-	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
-	u32 device_id, ld;
-
-	fusion = instance->ctrl_context;
-	cmd->request_desc->SCSIIO.RequestFlags =
-		(MEGASAS_REQ_DESCRIPT_FLAGS_LD_IO
-		<< MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
-	cmd->io_request->Function = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
-	cmd->io_request->DevHandle = cpu_to_le16(MEGASAS_DEV_INDEX(scmd));
-
-	/*remove FAST PATH ENABLE bit in IoFlags */
-	cmd->io_request->IoFlags &=
-	cpu_to_le16(~MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH);
-
-	/* if the numSGE > max_sge_in_main_sge set the chain offset*/
-	if (cmd->io_request->RaidContext.raid_context_g35.num_sge >
-		fusion->max_sge_in_main_msg)
-		cmd->io_request->ChainOffset = fusion->chain_offset_io_request;
-	memcpy(cmd->io_request->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
-	cmd->io_request->CDB.EEDP32.PrimaryReferenceTag = 0;
-	cmd->io_request->CDB.EEDP32.PrimaryApplicationTagMask = 0;
-	cmd->io_request->EEDPFlags = 0;
-	cmd->io_request->Control = 0;
-	cmd->io_request->EEDPBlockSize = 0;
-	cmd->is_raid_1_fp_write = 0;
-
-	device_id = MEGASAS_DEV_INDEX(cmd->scmd);
-	local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
-	ld = MR_TargetIdToLdGet(device_id, local_map_ptr);
-	raid = MR_LdRaidGet(ld, local_map_ptr);
-	praid_context = &cmd->io_request->RaidContext;
-	if (cmd->scmd->sc_data_direction == PCI_DMA_FROMDEVICE) {
-		if ((raid->cpuAffinity.ldRead.cpu0)
-		&& (raid->cpuAffinity.ldRead.cpu1))
-			praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-			= MR_RAID_CTX_CPUSEL_FCFS;
-		else if (raid->cpuAffinity.ldRead.cpu1)
-			praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-			= MR_RAID_CTX_CPUSEL_1;
-		else
-			praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-			= MR_RAID_CTX_CPUSEL_0;
-	} else {
-	if ((raid->cpuAffinity.ldWrite.cpu0)
-		&& (raid->cpuAffinity.ldWrite.cpu1))
-		praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-			= MR_RAID_CTX_CPUSEL_FCFS;
-	else if (raid->cpuAffinity.ldWrite.cpu1)
-		praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-			= MR_RAID_CTX_CPUSEL_1;
-	else
-		praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-		= MR_RAID_CTX_CPUSEL_0;
-	}
-}
 
 /* megasas_prepate_secondRaid1_IO
  *  It prepares the raid 1 second IO
@@ -2527,60 +2464,36 @@ void megasas_prepare_secondRaid1_IO(struct megasas_instance *instance,
 {
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc, *req_desc2 = NULL;
 	struct fusion_context *fusion;
-
 	fusion = instance->ctrl_context;
 	req_desc = cmd->request_desc;
-	if (r1_cmd) {
-		/* copy the io request frame as well
-		 *  as 8 SGEs data for r1 command
-		 */
-		memcpy(r1_cmd->io_request, cmd->io_request,
-			sizeof(struct MPI2_RAID_SCSI_IO_REQUEST));
-		memcpy(&r1_cmd->io_request->SGL, &cmd->io_request->SGL,
-				(fusion->max_sge_in_main_msg *
-				sizeof(union MPI2_SGE_IO_UNION)));
-		/*sense buffer is different for r1 command*/
-		r1_cmd->io_request->SenseBufferLowAddress =
-				cpu_to_le32(r1_cmd->sense_phys_addr);
-		r1_cmd->scmd = cmd->scmd;
-		req_desc2 =
-		megasas_get_request_descriptor(instance, r1_cmd->index-1);
-		if (req_desc2) {
-			req_desc2->Words = 0;
-			r1_cmd->request_desc = req_desc2;
-			req_desc2->SCSIIO.SMID =
-				cpu_to_le16(r1_cmd->index);
-			req_desc2->SCSIIO.RequestFlags =
-				req_desc->SCSIIO.RequestFlags;
-			r1_cmd->is_raid_1_fp_write = 1;
-			r1_cmd->request_desc->SCSIIO.DevHandle =
-				cmd->r1_alt_dev_handle;
-			r1_cmd->io_request->DevHandle = cmd->r1_alt_dev_handle;
-			cmd->io_request->RaidContext.raid_context_g35.smid.peer_smid =
-				 cpu_to_le16(r1_cmd->index);
-			r1_cmd->io_request->RaidContext.raid_context_g35.smid.peer_smid =
-				cpu_to_le16(cmd->index);
-			/* MSIxIndex of both commands request
-			 * descriptors should be same
-			 */
-			r1_cmd->request_desc->SCSIIO.MSIxIndex =
-				cmd->request_desc->SCSIIO.MSIxIndex;
-			/*span arm is different for r1 cmd*/
-			r1_cmd->io_request->RaidContext.raid_context_g35.span_arm =
+	/* copy the io request frame as well as 8 SGEs data for r1 command*/
+	memcpy(r1_cmd->io_request, cmd->io_request,
+	       (sizeof(struct MPI2_RAID_SCSI_IO_REQUEST)));
+	memcpy(&r1_cmd->io_request->SGL, &cmd->io_request->SGL,
+	       (fusion->max_sge_in_main_msg * sizeof(union MPI2_SGE_IO_UNION)));
+	/*sense buffer is different for r1 command*/
+	r1_cmd->io_request->SenseBufferLowAddress =
+			cpu_to_le32(r1_cmd->sense_phys_addr);
+	r1_cmd->scmd = cmd->scmd;
+	req_desc2 = megasas_get_request_descriptor(instance,
+						   (r1_cmd->index - 1));
+	req_desc2->Words = 0;
+	r1_cmd->request_desc = req_desc2;
+	req_desc2->SCSIIO.SMID = cpu_to_le16(r1_cmd->index);
+	req_desc2->SCSIIO.RequestFlags = req_desc->SCSIIO.RequestFlags;
+	r1_cmd->request_desc->SCSIIO.DevHandle = cmd->r1_alt_dev_handle;
+	r1_cmd->io_request->DevHandle = cmd->r1_alt_dev_handle;
+	r1_cmd->r1_alt_dev_handle = cmd->io_request->DevHandle;
+	cmd->io_request->RaidContext.raid_context_g35.smid.peer_smid =
+			cpu_to_le16(r1_cmd->index);
+	r1_cmd->io_request->RaidContext.raid_context_g35.smid.peer_smid =
+			cpu_to_le16(cmd->index);
+	/*MSIxIndex of both commands request descriptors should be same*/
+	r1_cmd->request_desc->SCSIIO.MSIxIndex =
+			cmd->request_desc->SCSIIO.MSIxIndex;
+	/*span arm is different for r1 cmd*/
+	r1_cmd->io_request->RaidContext.raid_context_g35.span_arm =
 			cmd->io_request->RaidContext.raid_context_g35.span_arm + 1;
-		} else {
-			megasas_return_cmd_fusion(instance, r1_cmd);
-			dev_info(&instance->pdev->dev,
-				"unable to get request descriptor, firing as normal IO\n");
-			atomic_dec(&instance->fw_outstanding);
-			megasas_fpio_to_ldio(instance, cmd, cmd->scmd);
-		}
-	} else {
-		dev_info(&instance->pdev->dev,
-			"unable to get command, firing as normal IO\n");
-		atomic_dec(&instance->fw_outstanding);
-		megasas_fpio_to_ldio(instance, cmd, cmd->scmd);
-	}
 }
 
 /**
@@ -2624,10 +2537,6 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 	index = cmd->index;
 
 	req_desc = megasas_get_request_descriptor(instance, index-1);
-	if (!req_desc) {
-		atomic_dec(&instance->fw_outstanding);
-		return SCSI_MLQUEUE_HOST_BUSY;
-	}
 
 	req_desc->Words = 0;
 	cmd->request_desc = req_desc;
@@ -2657,12 +2566,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 	/*	driver side count always should be less than max_fw_cmds
 	 *	to get new command
 	 */
-	if (cmd->is_raid_1_fp_write &&
-		atomic_inc_return(&instance->fw_outstanding) >
-			(instance->host->can_queue)) {
-		megasas_fpio_to_ldio(instance, cmd, cmd->scmd);
-		atomic_dec(&instance->fw_outstanding);
-	} else if (cmd->is_raid_1_fp_write) {
+	if (cmd->r1_alt_dev_handle != MR_DEVHANDLE_INVALID) {
 		r1_cmd = megasas_get_cmd_fusion(instance,
 				(scmd->request->tag + instance->max_fw_cmds));
 		megasas_prepare_secondRaid1_IO(instance, cmd, r1_cmd);
@@ -2684,6 +2588,61 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 }
 
 /**
+ * megasas_complete_r1_command -
+ * completes R1 FP write commands which has valid peer smid
+ * @instance:			Adapter soft state
+ * @cmd_fusion:			MPT command frame
+ *
+ */
+static inline void
+megasas_complete_r1_command(struct megasas_instance *instance,
+			    struct megasas_cmd_fusion *cmd)
+{
+	u8 *sense, status, ex_status;
+	u32 data_length;
+	u16 peer_smid;
+	struct fusion_context *fusion;
+	struct megasas_cmd_fusion *r1_cmd = NULL;
+	struct scsi_cmnd *scmd_local = NULL;
+	struct RAID_CONTEXT_G35 *rctx_g35;
+
+	rctx_g35 = &cmd->io_request->RaidContext.raid_context_g35;
+	fusion = instance->ctrl_context;
+	peer_smid = le16_to_cpu(rctx_g35->smid.peer_smid);
+
+	r1_cmd = fusion->cmd_list[peer_smid - 1];
+	scmd_local = cmd->scmd;
+	status = rctx_g35->status;
+	ex_status = rctx_g35->ex_status;
+	data_length = cmd->io_request->DataLength;
+	sense = cmd->sense;
+
+	cmd->cmd_completed = true;
+
+	/* Check if peer command is completed or not*/
+	if (r1_cmd->cmd_completed) {
+		rctx_g35 = &r1_cmd->io_request->RaidContext.raid_context_g35;
+		if (rctx_g35->status != MFI_STAT_OK) {
+			status = rctx_g35->status;
+			ex_status = rctx_g35->ex_status;
+			data_length = r1_cmd->io_request->DataLength;
+			sense = r1_cmd->sense;
+		}
+
+		megasas_return_cmd_fusion(instance, r1_cmd);
+		map_cmd_status(fusion, scmd_local, status, ex_status,
+			       le32_to_cpu(data_length), sense);
+		if (instance->ldio_threshold &&
+		    megasas_cmd_type(scmd_local) == READ_WRITE_LDIO)
+			atomic_dec(&instance->ldio_outstanding);
+		scmd_local->SCp.ptr = NULL;
+		megasas_return_cmd_fusion(instance, cmd);
+		scsi_dma_unmap(scmd_local);
+		scmd_local->scsi_done(scmd_local);
+	}
+}
+
+/**
  * complete_cmd_fusion -	Completes command
  * @instance:			Adapter soft state
  * Completes all commands that is in reply descriptor queue
@@ -2696,10 +2655,10 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 	struct MPI2_RAID_SCSI_IO_REQUEST *scsi_io_req;
 	struct fusion_context *fusion;
 	struct megasas_cmd *cmd_mfi;
-	struct megasas_cmd_fusion *cmd_fusion, *r1_cmd = NULL;
+	struct megasas_cmd_fusion *cmd_fusion;
 	u16 smid, num_completed;
-	u8 reply_descript_type, *sense;
-	u32 status, extStatus, device_id, data_length;
+	u8 reply_descript_type, *sense, status, extStatus;
+	u32 device_id, data_length;
 	union desc_value d_val;
 	struct LD_LOAD_BALANCE_INFO *lbinfo;
 	int threshold_reply_count = 0;
@@ -2729,25 +2688,11 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 
 	while (d_val.u.low != cpu_to_le32(UINT_MAX) &&
 	       d_val.u.high != cpu_to_le32(UINT_MAX)) {
-		   /*
-		    * Ensure that the peer command is NULL here in case a
-		    * command has completed but the R1 FP Write peer has
-		    * not completed yet.If not null, it's possible that
-		    * another thread will complete the peer
-		    * command and should not.
-		    */
-		r1_cmd = NULL;
 
 		smid = le16_to_cpu(reply_desc->SMID);
-
 		cmd_fusion = fusion->cmd_list[smid - 1];
-
-		scsi_io_req =
-			(struct MPI2_RAID_SCSI_IO_REQUEST *)
-		  cmd_fusion->io_request;
-
-		if (cmd_fusion->scmd)
-			cmd_fusion->scmd->SCp.ptr = NULL;
+		scsi_io_req = (struct MPI2_RAID_SCSI_IO_REQUEST *)
+						cmd_fusion->io_request;
 
 		scmd_local = cmd_fusion->scmd;
 		status = scsi_io_req->RaidContext.raid_context.status;
@@ -2768,88 +2713,33 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 			break;
 		case MPI2_FUNCTION_SCSI_IO_REQUEST:  /*Fast Path IO.*/
 			/* Update load balancing info */
-			device_id = MEGASAS_DEV_INDEX(scmd_local);
-			lbinfo = &fusion->load_balance_info[device_id];
-			/*
-			 * check for the raid 1/10 fast path writes
-			 */
-			if (!cmd_fusion->is_raid_1_fp_write &&
-				(cmd_fusion->scmd->SCp.Status &
-					MEGASAS_LOAD_BALANCE_FLAG)) {
+			if (fusion->load_balance_info &&
+			    (cmd_fusion->scmd->SCp.Status &
+			    MEGASAS_LOAD_BALANCE_FLAG)) {
+				device_id = MEGASAS_DEV_INDEX(scmd_local);
+				lbinfo = &fusion->load_balance_info[device_id];
 				atomic_dec(&lbinfo->scsi_pending_cmds[cmd_fusion->pd_r1_lb]);
-				cmd_fusion->scmd->SCp.Status &=
-					~MEGASAS_LOAD_BALANCE_FLAG;
-			} else if (cmd_fusion->is_raid_1_fp_write) {
-				/* get peer command */
-				if (cmd_fusion->index < instance->max_fw_cmds)
-					r1_cmd = fusion->cmd_list[(cmd_fusion->index +
-					instance->max_fw_cmds)-1];
-				else {
-					r1_cmd =
-					fusion->cmd_list[(cmd_fusion->index -
-						 instance->max_fw_cmds)-1];
-				}
-				cmd_fusion->cmd_completed = true;
+				cmd_fusion->scmd->SCp.Status &= ~MEGASAS_LOAD_BALANCE_FLAG;
 			}
-
-			if (reply_descript_type ==
-			    MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS) {
-				if (megasas_dbg_lvl == 5)
-					dev_err(&instance->pdev->dev, "\nFAST Path "
-					       "IO Success\n");
-			}
-			/* Fall thru and complete IO */
+			//Fall thru and complete IO
 		case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO Path */
-			/* Map the FW Cmd Status */
-			/*
-			 * check for the raid 1/10 fast path writes
-			 */
-			if (r1_cmd &&  r1_cmd->is_raid_1_fp_write
-				&& r1_cmd->cmd_completed) {
-				/*
-				 * if the peer  Raid  1/10 fast path failed,
-				 * mark IO as failed to the scsi layer.
-				 * over write the current status by the failed
-				 * status makes sure that if any one of
-				 * command fails,return fail status to
-				 * scsi layer
-				 */
-				if (r1_cmd->io_request->RaidContext.raid_context.status !=
-								MFI_STAT_OK) {
-					status =
-					r1_cmd->io_request->RaidContext.raid_context.status;
-					extStatus =
-					r1_cmd->io_request->RaidContext.raid_context.ex_status;
-					data_length =
-						r1_cmd->io_request->DataLength;
-					sense = r1_cmd->sense;
-				}
-				r1_cmd->io_request->RaidContext.raid_context.status = 0;
-				r1_cmd->io_request->RaidContext.raid_context.ex_status = 0;
-				cmd_fusion->is_raid_1_fp_write = 0;
-				r1_cmd->is_raid_1_fp_write = 0;
-				r1_cmd->cmd_completed = false;
-				cmd_fusion->cmd_completed = false;
-				megasas_return_cmd_fusion(instance, r1_cmd);
-			}
-			if (!cmd_fusion->is_raid_1_fp_write) {
+			atomic_dec(&instance->fw_outstanding);
+			if (cmd_fusion->r1_alt_dev_handle == MR_DEVHANDLE_INVALID) {
 				map_cmd_status(fusion, scmd_local, status,
-					extStatus, data_length, sense);
-				scsi_io_req->RaidContext.raid_context.status = 0;
-				scsi_io_req->RaidContext.raid_context.ex_status = 0;
-				if (instance->ldio_threshold
-					&& megasas_cmd_type(scmd_local) == READ_WRITE_LDIO)
+					       extStatus, le32_to_cpu(data_length),
+					       sense);
+				if (instance->ldio_threshold &&
+				    (megasas_cmd_type(scmd_local) == READ_WRITE_LDIO))
 					atomic_dec(&instance->ldio_outstanding);
+				scmd_local->SCp.ptr = NULL;
 				megasas_return_cmd_fusion(instance, cmd_fusion);
 				scsi_dma_unmap(scmd_local);
 				scmd_local->scsi_done(scmd_local);
-			}
-			atomic_dec(&instance->fw_outstanding);
-
+			} else	/* Optimal VD - R1 FP command completion. */
+				megasas_complete_r1_command(instance, cmd_fusion);
 			break;
 		case MEGASAS_MPI2_FUNCTION_PASSTHRU_IO_REQUEST: /*MFI command */
 			cmd_mfi = instance->cmd_list[cmd_fusion->sync_cmd_idx];
-
 			/* Poll mode. Dummy free.
 			 * In case of Interrupt mode, caller has reverse check.
 			 */
@@ -3896,7 +3786,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 {
 	int retval = SUCCESS, i, j, convert = 0;
 	struct megasas_instance *instance;
-	struct megasas_cmd_fusion *cmd_fusion, *mpt_cmd_fusion;
+	struct megasas_cmd_fusion *cmd_fusion, *r1_cmd;
 	struct fusion_context *fusion;
 	u32 abs_state, status_reg, reset_adapter;
 	u32 io_timeout_in_crash_mode = 0;
@@ -3973,15 +3863,8 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 			cmd_fusion = fusion->cmd_list[i];
 			/*check for extra commands issued by driver*/
 			if (instance->is_ventura) {
-				cmd_fusion->is_raid_1_fp_write = 0;
-				cmd_fusion->cmd_completed = false;
-				mpt_cmd_fusion =
-				fusion->cmd_list[i + instance->max_fw_cmds];
-				mpt_cmd_fusion->is_raid_1_fp_write = 0;
-				mpt_cmd_fusion->cmd_completed = false;
-				if (mpt_cmd_fusion->scmd)
-					megasas_return_cmd_fusion(instance,
-						mpt_cmd_fusion);
+				r1_cmd = fusion->cmd_list[i + instance->max_fw_cmds];
+				megasas_return_cmd_fusion(instance, r1_cmd);
 			}
 			scmd_local = cmd_fusion->scmd;
 			if (cmd_fusion->scmd) {
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 82a4ff7..9d9658e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -673,6 +673,7 @@ struct MPI2_IOC_INIT_REQUEST {
 
 /* mrpriv defines */
 #define MR_PD_INVALID 0xFFFF
+#define MR_DEVHANDLE_INVALID 0xFFFF
 #define MAX_SPAN_DEPTH 8
 #define MAX_QUAD_DEPTH	MAX_SPAN_DEPTH
 #define MAX_RAIDMAP_SPAN_DEPTH (MAX_SPAN_DEPTH)
@@ -921,7 +922,6 @@ struct IO_REQUEST_INFO {
 	u8  span_arm;	/* span[7:5], arm[4:0] */
 	u8  pd_after_lb;
 	u16 r1_alt_dev_handle; /* raid 1/10 only */
-	bool is_raid_1_fp_write;
 	bool ra_capable;
 };
 
@@ -1060,7 +1060,6 @@ struct megasas_cmd_fusion {
 	u32 index;
 	u8 pd_r1_lb;
 	struct completion done;
-	bool is_raid_1_fp_write;
 	u16 r1_alt_dev_handle; /* raid 1/10 only*/
 	bool cmd_completed;  /* raid 1/10 fp writes status holder */
 
-- 
2.8.3
