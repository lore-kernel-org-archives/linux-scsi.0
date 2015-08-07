From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 1/7] megaraid_sas : Jbod sequence number support
Date: Fri, 7 Aug 2015 17:53:42 +0530
Message-ID: <201508071230.t77CTw3x021043@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sgpsmtp1.avagotech.com ([202.86.248.61]:41688 "EHLO
	sgpsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbbHGMax (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2015 08:30:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

Implemented JBOD map which will provide quick access for JBOD path and also provide sequence number.
This will help hardware to fail command to the FW in case of any sequence mismatch.

Fast Path IO for JBOD will refer JBOD map (which has sequence number per JBOD devices) 
instead of Raid map.  Earlier, driver use Raid map to get device handle for fast path IO,
which does not have sequence number information. Now, driver will use JBOD map for the same purpose.
As part of error handling, if JBOD map is failed/not supported by firmware; driver will continue legacy behavior.

Now there will be three IO path for JBOD (syspd)

JBOD map with sequence number (Fast Path)
Raid map without sequence number (Fast Path)
FW path via h/w exceptional queue deliberately setup devhandle 0xFFFF (FW path).

Driver send new DCMD MR_DCMD_SYSTEM_PD_MAP_GET_INFO for this purpose.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---

diff --git a/megaraid_sas.h b/megaraid_sas.h
index 20c3754..45500ba 100644
--- a/megaraid_sas.h
+++ b/megaraid_sas.h
@@ -973,7 +973,12 @@ struct megasas_ctrl_info {
 
 	struct {
 #if defined(__BIG_ENDIAN_BITFIELD)
-		u32     reserved:12;
+		u32     reserved:7;
+		u32     useSeqNumJbodFP:1;
+		u32     supportExtendedSSCSize:1;
+		u32     supportDiskCacheSettingForSysPDs:1;
+		u32     supportCPLDUpdate:1;
+		u32     supportTTYLogCompression:1;
 		u32     discardCacheDuringLDDelete:1;
 		u32     supportSecurityonJBOD:1;
 		u32     supportCacheBypassModes:1;
@@ -1013,7 +1018,12 @@ struct megasas_ctrl_info {
 		u32     supportCacheBypassModes:1;
 		u32     supportSecurityonJBOD:1;
 		u32     discardCacheDuringLDDelete:1;
-		u32     reserved:12;
+		u32     supportTTYLogCompression:1;
+		u32     supportCPLDUpdate:1;
+		u32     supportDiskCacheSettingForSysPDs:1;
+		u32     supportExtendedSSCSize:1;
+		u32     useSeqNumJbodFP:1;
+		u32     reserved:7;
 #endif
 	} adapterOperations3;
 
@@ -1690,6 +1700,7 @@ struct megasas_instance {
 	u32 crash_dump_drv_support;
 	u32 crash_dump_app_support;
 	u32 secure_jbod_support;
+	bool use_seqnum_jbod_fp;   /* Added for PD sequence */
 	spinlock_t crashdump_lock;
 
 	struct megasas_register_set __iomem *reg_set;
@@ -1769,7 +1780,9 @@ struct megasas_instance {
 	struct msix_entry msixentry[MEGASAS_MAX_MSIX_QUEUES];
 	struct megasas_irq_context irq_context[MEGASAS_MAX_MSIX_QUEUES];
 	u64 map_id;
+	u64 pd_seq_map_id;
 	struct megasas_cmd *map_update_cmd;
+	struct megasas_cmd *jbod_seq_cmd;
 	unsigned long bar;
 	long reset_flags;
 	struct mutex reset_mutex;
@@ -1985,6 +1998,9 @@ __le16 get_updated_dev_handle(struct megasas_instance *instance,
 void mr_update_load_balance_params(struct MR_DRV_RAID_MAP_ALL *map,
 	struct LD_LOAD_BALANCE_INFO *lbInfo);
 int megasas_get_ctrl_info(struct megasas_instance *instance);
+/* PD sequence */
+int
+megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend);
 int megasas_set_crash_dump_params(struct megasas_instance *instance,
 	u8 crash_buf_state);
 void megasas_free_host_crash_buffer(struct megasas_instance *instance);
@@ -2000,5 +2016,6 @@ void __megasas_return_cmd(struct megasas_instance *instance,
 void megasas_return_mfi_mpt_pthr(struct megasas_instance *instance,
 	struct megasas_cmd *cmd_mfi, struct megasas_cmd_fusion *cmd_fusion);
 int megasas_cmd_type(struct scsi_cmnd *cmd);
+void megasas_setup_jbod_map(struct megasas_instance *instance);
 
 #endif				/*LSI_MEGARAID_SAS_H */
diff --git a/megaraid_sas_base.c b/megaraid_sas_base.c
index 71b884d..1843a50 100644
--- a/megaraid_sas_base.c
+++ b/megaraid_sas_base.c
@@ -2833,7 +2833,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 	struct megasas_header *hdr = &cmd->frame->hdr;
 	unsigned long flags;
 	struct fusion_context *fusion = instance->ctrl_context;
-	u32 opcode;
+	u32 opcode, status;
 
 	/* flag for the retry reset */
 	cmd->retry_for_fw_reset = 0;
@@ -2941,6 +2941,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 			&& (cmd->frame->dcmd.mbox.b[1] == 1)) {
 			fusion->fast_path_io = 0;
 			spin_lock_irqsave(instance->host->host_lock, flags);
+			instance->map_update_cmd = NULL;
 			if (cmd->frame->hdr.cmd_status != 0) {
 				if (cmd->frame->hdr.cmd_status !=
 				    MFI_STAT_NOT_FOUND)
@@ -2979,6 +2980,27 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 			spin_unlock_irqrestore(&poll_aen_lock, flags);
 		}
 
+		/* FW has an updated PD sequence */
+		if ((opcode == MR_DCMD_SYSTEM_PD_MAP_GET_INFO) &&
+			(cmd->frame->dcmd.mbox.b[0] == 1)) {
+
+			spin_lock_irqsave(instance->host->host_lock, flags);
+			status = cmd->frame->hdr.cmd_status;
+			instance->jbod_seq_cmd = NULL;
+			megasas_return_cmd(instance, cmd);
+
+			if (status == MFI_STAT_OK) {
+				instance->pd_seq_map_id++;
+				/* Re-register a pd sync seq num cmd */
+				if (megasas_sync_pd_seq_num(instance, true))
+					instance->use_seqnum_jbod_fp = 0;
+			} else
+				instance->use_seqnum_jbod_fp = 0;
+
+			spin_unlock_irqrestore(instance->host->host_lock, flags);
+			break;
+		}
+
 		/*
 		 * See if got an event notification
 		 */
@@ -4135,6 +4157,8 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 		le32_to_cpus((u32 *)&ctrl_info->adapterOperations2);
 		le32_to_cpus((u32 *)&ctrl_info->adapterOperations3);
 		megasas_update_ext_vd_details(instance);
+		instance->use_seqnum_jbod_fp =
+			ctrl_info->adapterOperations3.useSeqNumJbodFP;
 		instance->is_imr = (ctrl_info->memory_size ? 0 : 1);
 		dev_info(&instance->pdev->dev,
 				"controller type\t: %s(%dMB)\n",
@@ -4482,6 +4506,62 @@ megasas_destroy_irqs(struct megasas_instance *instance) {
 }
 
 /**
+ * megasas_setup_jbod_map -	setup jbod map for FP seq_number.
+ * @instance:				Adapter soft state
+ * @is_probe:				Driver probe check
+ *
+ * Return 0 on success.
+ */
+void
+megasas_setup_jbod_map(struct megasas_instance *instance)
+{
+	int i;
+	struct fusion_context *fusion = instance->ctrl_context;
+	u32 pd_seq_map_sz;
+
+	pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
+		(sizeof(struct MR_PD_CFG_SEQ) * (MAX_PHYSICAL_DEVICES - 1));
+
+	if (reset_devices || !fusion ||
+		!instance->ctrl_info->adapterOperations3.useSeqNumJbodFP) {
+		dev_info(&instance->pdev->dev,
+			"Jbod map is not supported %s %d\n",
+			__func__, __LINE__);
+		instance->use_seqnum_jbod_fp = 0;
+		return;
+	}
+
+	if (fusion->pd_seq_sync[0])
+		goto skip_alloc;
+
+	for (i = 0; i < 2; i++) {
+		fusion->pd_seq_sync[i] = dma_alloc_coherent
+			(&instance->pdev->dev, pd_seq_map_sz,
+			&fusion->pd_seq_phys[i], GFP_KERNEL);
+		if (!fusion->pd_seq_sync[i]) {
+			dev_err(&instance->pdev->dev,
+				"Failed to allocate memory from %s %d\n",
+				__func__, __LINE__);
+			if (i == 1) {
+				dma_free_coherent(&instance->pdev->dev,
+					pd_seq_map_sz, fusion->pd_seq_sync[0],
+					fusion->pd_seq_phys[0]);
+				fusion->pd_seq_sync[0] = NULL;
+			}
+			instance->use_seqnum_jbod_fp = 0;
+			return;
+		}
+	}
+
+skip_alloc:
+	if (!megasas_sync_pd_seq_num(instance, false) &&
+		!megasas_sync_pd_seq_num(instance, true))
+		instance->use_seqnum_jbod_fp = 1;
+	else
+		instance->use_seqnum_jbod_fp = 0;
+}
+
+/**
  * megasas_init_fw -	Initializes the FW
  * @instance:		Adapter soft state
  *
@@ -4658,6 +4738,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	* the following function will get the PD LIST.
 	*/
 
+	megasas_setup_jbod_map(instance);
+
 	memset(instance->pd_list, 0 ,
 		(MEGASAS_MAX_PD * sizeof(struct megasas_pd_list)));
 	if (megasas_get_pd_list(instance) < 0) {
@@ -4751,6 +4833,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		instance->crash_dump_drv_support ? "yes" : "no");
 	dev_info(&instance->pdev->dev, "secure jbod		: %s\n",
 		instance->secure_jbod_support ? "yes" : "no");
+	dev_info(&instance->pdev->dev, "jbod sync map		: %s\n",
+		instance->use_seqnum_jbod_fp ? "yes" : "no");
 
 
 	instance->max_sectors_per_req = instance->max_num_sge *
@@ -5510,10 +5594,16 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 
 	if (instance->aen_cmd)
 		megasas_issue_blocked_abort_cmd(instance,
-			instance->aen_cmd, 30);
+			instance->aen_cmd,
+			MEGASAS_BLOCKED_CMD_TIMEOUT);
 	if (instance->map_update_cmd)
 		megasas_issue_blocked_abort_cmd(instance,
-			instance->map_update_cmd, 30);
+			instance->map_update_cmd,
+			MEGASAS_BLOCKED_CMD_TIMEOUT);
+	if (instance->jbod_seq_cmd)
+		megasas_issue_blocked_abort_cmd(instance,
+			instance->jbod_seq_cmd,
+			MEGASAS_BLOCKED_CMD_TIMEOUT);
 	dcmd = &cmd->frame->dcmd;
 
 	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
@@ -5648,6 +5738,7 @@ megasas_resume(struct pci_dev *pdev)
 		}
 		if (!megasas_get_map_info(instance))
 			megasas_sync_map_info(instance);
+
 	}
 	break;
 	default:
@@ -5680,6 +5771,7 @@ megasas_resume(struct pci_dev *pdev)
 	}
 
 	instance->instancet->enable_intr(instance);
+	megasas_setup_jbod_map(instance);
 	instance->unload = 0;
 
 	/*
@@ -5727,6 +5819,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 	struct fusion_context *fusion;
+	u32 pd_seq_map_sz;
 
 	instance = pci_get_drvdata(pdev);
 	instance->unload = 1;
@@ -5781,6 +5874,9 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	case PCI_DEVICE_ID_LSI_INVADER:
 	case PCI_DEVICE_ID_LSI_FURY:
 		megasas_release_fusion(instance);
+			pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
+				(sizeof(struct MR_PD_CFG_SEQ) *
+					(MAX_PHYSICAL_DEVICES - 1));
 		for (i = 0; i < 2 ; i++) {
 			if (fusion->ld_map[i])
 				dma_free_coherent(&instance->pdev->dev,
@@ -5790,6 +5886,11 @@ static void megasas_detach_one(struct pci_dev *pdev)
 			if (fusion->ld_drv_map[i])
 				free_pages((ulong)fusion->ld_drv_map[i],
 					fusion->drv_map_pages);
+				if (fusion->pd_seq_sync)
+					dma_free_coherent(&instance->pdev->dev,
+						pd_seq_map_sz,
+						fusion->pd_seq_sync[i],
+						fusion->pd_seq_phys[i]);
 		}
 		free_pages((ulong)instance->ctrl_context,
 			instance->ctrl_context_pages);
diff --git a/megaraid_sas_fusion.c b/megaraid_sas_fusion.c
index 46a0f8f..5e023a6 100644
--- a/megaraid_sas_fusion.c
+++ b/megaraid_sas_fusion.c
@@ -728,6 +728,83 @@ fail_get_cmd:
 	return ret;
 }
 
+/**
+ * megasas_sync_pd_seq_num -	JBOD SEQ MAP
+ * @instance:		Adapter soft state
+ * @pend:		set to 1, if it is pended jbod map.
+ *
+ * Issue Jbod map to the firmware. If it is pended command,
+ * issue command and return. If it is first instance of jbod map
+ * issue and receive command.
+ */
+int
+megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend) {
+	int ret = 0;
+	u32 pd_seq_map_sz;
+	struct megasas_cmd *cmd;
+	struct megasas_dcmd_frame *dcmd;
+	struct fusion_context *fusion = instance->ctrl_context;
+	struct MR_PD_CFG_SEQ_NUM_SYNC *pd_sync;
+	dma_addr_t pd_seq_h;
+
+	pd_sync = (void *)fusion->pd_seq_sync[(instance->pd_seq_map_id & 1)];
+	pd_seq_h = fusion->pd_seq_phys[(instance->pd_seq_map_id & 1)];
+	pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
+			(sizeof(struct MR_PD_CFG_SEQ) *
+			(MAX_PHYSICAL_DEVICES - 1));
+
+	cmd = megasas_get_cmd(instance);
+	if (!cmd) {
+		dev_err(&instance->pdev->dev,
+			"Could not get mfi cmd. Fail from %s %d\n",
+			__func__, __LINE__);
+		return -ENOMEM;
+	}
+
+	dcmd = &cmd->frame->dcmd;
+
+	memset(pd_sync, 0, pd_seq_map_sz);
+	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+	dcmd->cmd = MFI_CMD_DCMD;
+	dcmd->cmd_status = 0xFF;
+	dcmd->sge_count = 1;
+	dcmd->timeout = 0;
+	dcmd->pad_0 = 0;
+	dcmd->data_xfer_len = cpu_to_le32(pd_seq_map_sz);
+	dcmd->opcode = cpu_to_le32(MR_DCMD_SYSTEM_PD_MAP_GET_INFO);
+	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(pd_seq_h);
+	dcmd->sgl.sge32[0].length = cpu_to_le32(pd_seq_map_sz);
+
+	if (pend) {
+		dcmd->mbox.b[0] = MEGASAS_DCMD_MBOX_PEND_FLAG;
+		dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_WRITE);
+		instance->jbod_seq_cmd = cmd;
+		instance->instancet->issue_dcmd(instance, cmd);
+		return 0;
+	}
+
+	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_READ);
+
+	/* Below code is only for non pended DCMD */
+	if (instance->ctrl_context && !instance->mask_interrupts)
+		ret = megasas_issue_blocked_cmd(instance, cmd, 60);
+	else
+		ret = megasas_issue_polled(instance, cmd);
+
+	if (le32_to_cpu(pd_sync->count) > MAX_PHYSICAL_DEVICES) {
+		dev_warn(&instance->pdev->dev,
+			"driver supports max %d JBOD, but FW reports %d\n",
+			MAX_PHYSICAL_DEVICES, le32_to_cpu(pd_sync->count));
+		ret = -EINVAL;
+	}
+
+	if (!ret)
+		instance->pd_seq_map_id++;
+
+	megasas_return_cmd(instance, cmd);
+	return ret;
+}
+
 /*
  * megasas_get_ld_map_info -	Returns FW's ld_map structure
  * @instance:				Adapter soft state
@@ -1725,7 +1802,9 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 	u16 timeout_limit;
 	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
 	struct RAID_CONTEXT	*pRAID_Context;
+	struct MR_PD_CFG_SEQ_NUM_SYNC *pd_sync;
 	struct fusion_context *fusion = instance->ctrl_context;
+	pd_sync = (void *)fusion->pd_seq_sync[(instance->pd_seq_map_id - 1) & 1];
 
 	device_id = MEGASAS_DEV_INDEX(scmd);
 	pd_index = MEGASAS_PD_INDEX(scmd);
@@ -1734,16 +1813,38 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 	io_request = cmd->io_request;
 	/* get RAID_Context pointer */
 	pRAID_Context = &io_request->RaidContext;
+	pRAID_Context->regLockFlags = 0;
+	pRAID_Context->regLockRowLBA = 0;
+	pRAID_Context->regLockLength = 0;
 	io_request->DataLength = cpu_to_le32(scsi_bufflen(scmd));
 	io_request->LUN[1] = scmd->device->lun;
 	pRAID_Context->RAIDFlags = MR_RAID_FLAGS_IO_SUB_TYPE_SYSTEM_PD
 		<< MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT;
 
-	pRAID_Context->VirtualDiskTgtId = cpu_to_le16(device_id);
-	pRAID_Context->configSeqNum = 0;
-	local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
-	io_request->DevHandle =
-		local_map_ptr->raidMap.devHndlInfo[device_id].curDevHdl;
+	/* If FW supports PD sequence number */
+	if (instance->use_seqnum_jbod_fp &&
+		instance->pd_list[pd_index].driveType == TYPE_DISK) {
+		/* TgtId must be incremented by 255 as jbod seq number is index
+		 * below raid map
+		 */
+		pRAID_Context->VirtualDiskTgtId =
+			cpu_to_le16(device_id + (MAX_PHYSICAL_DEVICES - 1));
+		pRAID_Context->configSeqNum = pd_sync->seq[pd_index].seqNum;
+		io_request->DevHandle = pd_sync->seq[pd_index].devHandle;
+		pRAID_Context->regLockFlags |=
+			(MR_RL_FLAGS_SEQ_NUM_ENABLE|MR_RL_FLAGS_GRANT_DESTINATION_CUDA);
+	} else if (fusion->fast_path_io) {
+		pRAID_Context->VirtualDiskTgtId = cpu_to_le16(device_id);
+		pRAID_Context->configSeqNum = 0;
+		local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
+		io_request->DevHandle =
+			local_map_ptr->raidMap.devHndlInfo[device_id].curDevHdl;
+	} else {
+		/*Want to send all IO via FW path*/
+		pRAID_Context->VirtualDiskTgtId = cpu_to_le16(device_id);
+		pRAID_Context->configSeqNum = 0;
+		io_request->DevHandle = le16_to_cpu(0xFFFF);
+	}
 
 	cmd->request_desc->SCSIIO.DevHandle = io_request->DevHandle;
 	cmd->request_desc->SCSIIO.MSIxIndex =
@@ -1758,12 +1859,10 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 			(MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
 				MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
 		pRAID_Context->timeoutValue = cpu_to_le16(os_timeout_value);
+		pRAID_Context->VirtualDiskTgtId = cpu_to_le16(device_id);
 	} else {
 		/* system pd Fast Path */
 		io_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
-		pRAID_Context->regLockFlags = 0;
-		pRAID_Context->regLockRowLBA = 0;
-		pRAID_Context->regLockLength = 0;
 		timeout_limit = (scmd->device->type == TYPE_DISK) ?
 				255 : 0xFFFF;
 		pRAID_Context->timeoutValue =
@@ -1771,9 +1870,6 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 			timeout_limit : os_timeout_value);
 		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
 			(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
-			cmd->request_desc->SCSIIO.RequestFlags |=
-				(MEGASAS_REQ_DESCRIPT_FLAGS_NO_LOCK <<
-				MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
 			pRAID_Context->Type = MPI2_TYPE_CUDA;
 			pRAID_Context->nseg = 0x1;
 			io_request->IoFlags |=
@@ -2515,8 +2611,10 @@ void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
 			continue;
 		req_desc = megasas_get_request_descriptor
 					(instance, smid - 1);
-		if (req_desc && (cmd_mfi->frame->dcmd.opcode !=
-				cpu_to_le32(MR_DCMD_LD_MAP_GET_INFO)))
+		if (req_desc && ((cmd_mfi->frame->dcmd.opcode !=
+				cpu_to_le32(MR_DCMD_LD_MAP_GET_INFO)) &&
+				 (cmd_mfi->frame->dcmd.opcode !=
+				cpu_to_le32(MR_DCMD_SYSTEM_PD_MAP_GET_INFO))))
 			megasas_fire_cmd_fusion(instance, req_desc);
 		else
 			megasas_return_cmd(instance, cmd_mfi);
@@ -2819,6 +2917,8 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 			if (!megasas_get_map_info(instance))
 				megasas_sync_map_info(instance);
 
+			megasas_setup_jbod_map(instance);
+
 			clear_bit(MEGASAS_FUSION_IN_RESET,
 				  &instance->reset_flags);
 			instance->instancet->enable_intr(instance);
diff --git a/megaraid_sas_fusion.h b/megaraid_sas_fusion.h
index ced6dc0..498d852 100644
--- a/megaraid_sas_fusion.h
+++ b/megaraid_sas_fusion.h
@@ -486,6 +486,7 @@ struct MPI2_IOC_INIT_REQUEST {
 #define MAX_PHYSICAL_DEVICES 256
 #define MAX_RAIDMAP_PHYSICAL_DEVICES (MAX_PHYSICAL_DEVICES)
 #define MR_DCMD_LD_MAP_GET_INFO             0x0300e101
+#define MR_DCMD_SYSTEM_PD_MAP_GET_INFO      0x0200e102
 #define MR_DCMD_CTRL_SHARED_HOST_MEM_ALLOC  0x010e8485   /* SR-IOV HB alloc*/
 #define MR_DCMD_LD_VF_MAP_GET_ALL_LDS_111   0x03200200
 #define MR_DCMD_LD_VF_MAP_GET_ALL_LDS       0x03150200
@@ -789,6 +790,21 @@ struct MR_FW_RAID_MAP_EXT {
 	struct MR_LD_SPAN_MAP      ldSpanMap[MAX_LOGICAL_DRIVES_EXT];
 };
 
+/*
+ *  * define MR_PD_CFG_SEQ structure for system PDs
+ *   */
+struct MR_PD_CFG_SEQ {
+	__le16 seqNum;
+	__le16 devHandle;
+	u8  reserved[4];
+} __packed;
+
+struct MR_PD_CFG_SEQ_NUM_SYNC {
+	__le32 size;
+	__le32 count;
+	struct MR_PD_CFG_SEQ seq[1];
+} __packed;
+
 struct fusion_context {
 	struct megasas_cmd_fusion **cmd_list;
 	dma_addr_t req_frames_desc_phys;
@@ -828,6 +844,8 @@ struct fusion_context {
 	u32 current_map_sz;
 	u32 drv_map_sz;
 	u32 drv_map_pages;
+	struct MR_PD_CFG_SEQ_NUM_SYNC	*pd_seq_sync[2];
+	dma_addr_t pd_seq_phys[2];
 	u8 fast_path_io;
 	struct LD_LOAD_BALANCE_INFO load_balance_info[MAX_LOGICAL_DRIVES_EXT];
 	LD_SPAN_INFO log_to_span[MAX_LOGICAL_DRIVES_EXT];
-- 
1.8.3.1

