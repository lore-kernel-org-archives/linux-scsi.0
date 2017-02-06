From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 20/39] megaraid_sas: big endian support changes
Date: Mon,  6 Feb 2017 01:59:53 -0800
Message-ID: <1486375212-17329-21-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:36159 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbdBFKC0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:02:26 -0500
Received: by mail-pg0-f54.google.com with SMTP id v184so27414514pgv.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:02:20 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Fix endiannes fixes for Ventura specific.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  15 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  70 ++++++++++-------
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 115 +++++++++++++++++-----------
 3 files changed, 122 insertions(+), 78 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 9d5d485..68582d9 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -210,7 +210,7 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 			le32_to_cpu(fw_map_dyn->desc_table_size),
 			le32_to_cpu(fw_map_dyn->desc_table_num_elements));
 		dev_dbg(&instance->pdev->dev, "drv map %p ldCount %d\n",
-			drv_map, fw_map_dyn->ld_count);
+			drv_map, le16_to_cpu(fw_map_dyn->ld_count));
 #endif
 		desc_table =
 		(struct MR_RAID_MAP_DESC_TABLE *)((void *)fw_map_dyn + le32_to_cpu(fw_map_dyn->desc_table_offset));
@@ -222,7 +222,8 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 		pDrvRaidMap->ldCount = (__le16)cpu_to_le16(ld_count);
 		pDrvRaidMap->fpPdIoTimeoutSec =
 			fw_map_dyn->fp_pd_io_timeout_sec;
-		pDrvRaidMap->totalSize = sizeof(struct MR_DRV_RAID_MAP_ALL);
+		pDrvRaidMap->totalSize =
+			cpu_to_le32(sizeof(struct MR_DRV_RAID_MAP_ALL));
 		/* point to actual data starting point*/
 		raid_map_data = (void *)fw_map_dyn +
 			le32_to_cpu(fw_map_dyn->desc_table_offset) +
@@ -234,11 +235,11 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 			dev_dbg(&instance->pdev->dev, "desc table %p\n",
 				desc_table);
 			dev_dbg(&instance->pdev->dev, "raidmap type %d, raidmapOffset 0x%x\n",
-				desc_table->raid_map_desc_type,
-				desc_table->raid_map_desc_offset);
+				le32_to_cpu(desc_table->raid_map_desc_type),
+				le32_to_cpu(desc_table->raid_map_desc_offset));
 			dev_dbg(&instance->pdev->dev, "raid map number of elements 0%x, raidmapsize 0x%x\n",
-				desc_table->raid_map_desc_elements,
-				desc_table->raid_map_desc_buffer_size);
+				le32_to_cpu(desc_table->raid_map_desc_elements),
+				le32_to_cpu(desc_table->raid_map_desc_buffer_size));
 #endif
 			switch (le32_to_cpu(desc_table->raid_map_desc_type)) {
 			case RAID_MAP_DESC_TYPE_DEVHDL_INFO:
@@ -263,7 +264,7 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 #endif
 			for (j = 0; j < le32_to_cpu(desc_table->raid_map_desc_elements); j++) {
 				pDrvRaidMap->ldTgtIdToLd[j] =
-				fw_map_dyn->ld_tgt_id_to_ld[j];
+					le16_to_cpu(fw_map_dyn->ld_tgt_id_to_ld[j]);
 #if VD_EXT_DEBUG
 				dev_dbg(&instance->pdev->dev, " %d drv ldTgtIdToLd %d\n",
 					j, pDrvRaidMap->ldTgtIdToLd[j]);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index b68babc..cf3e2f8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2077,7 +2077,7 @@ static void megasas_stream_detect(struct megasas_instance *instance,
 			 */
 			continue;
 
-		cmd->io_request->RaidContext.raid_context_g35.stream_detected = true;
+		SET_STREAM_DETECTED(cmd->io_request->RaidContext.raid_context_g35);
 		current_sd->next_seq_lba =
 		io_info->ldStartBlock + io_info->numBlocks;
 		/*
@@ -2151,7 +2151,8 @@ megasas_set_raidflag_cpu_affinity(union RAID_CONTEXT_UNION *praid_context,
 			/* Fast path cache by pass capable R0/R1 VD */
 			if ((raid->level <= 1) &&
 			    (raid->capability.fp_cache_bypass_capable)) {
-				rctx_g35->routing_flags.bits.sld = 1;
+				rctx_g35->routing_flags |=
+					(1 << MR_RAID_CTX_ROUTINGFLAGS_SLD_SHIFT);
 				rctx_g35->raid_flags =
 					(MR_RAID_FLAGS_IO_SUB_TYPE_CACHE_BYPASS
 					<< MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT);
@@ -2171,7 +2172,7 @@ megasas_set_raidflag_cpu_affinity(union RAID_CONTEXT_UNION *praid_context,
 			else if (raid->cpuAffinity.ldWrite.cpu1)
 				cpu_sel = MR_RAID_CTX_CPUSEL_1;
 
-			if (rctx_g35->stream_detected &&
+			if (is_stream_detected(rctx_g35) &&
 			    (raid->level == 5) &&
 			    (raid->writeMode == MR_RL_WRITE_THROUGH_MODE) &&
 			    (cpu_sel == MR_RAID_CTX_CPUSEL_FCFS))
@@ -2179,7 +2180,8 @@ megasas_set_raidflag_cpu_affinity(union RAID_CONTEXT_UNION *praid_context,
 		}
 	}
 
-	rctx_g35->routing_flags.bits.cpu_sel = cpu_sel;
+	rctx_g35->routing_flags |=
+		(cpu_sel << MR_RAID_CTX_ROUTINGFLAGS_CPUSEL_SHIFT);
 
 	/* Always give priority to MR_RAID_FLAGS_IO_SUB_TYPE_LDIO_BW_LIMIT
 	 * vs MR_RAID_FLAGS_IO_SUB_TYPE_CACHE_BYPASS.
@@ -2330,7 +2332,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 		/* In ventura if stream detected for a read and it is read ahead
 		 *  capable make this IO as LDIO
 		 */
-		if (praid_context->raid_context_g35.stream_detected &&
+		if (is_stream_detected(&io_request->RaidContext.raid_context_g35) &&
 		    io_info.isRead && io_info.ra_capable)
 			fp_possible = false;
 
@@ -2365,8 +2367,8 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 				raid, fp_possible, io_info.isRead,
 				scsi_buff_len);
 		else
-			praid_context->raid_context_g35.routing_flags.bits.cpu_sel =
-				MR_RAID_CTX_CPUSEL_0;
+			praid_context->raid_context_g35.routing_flags |=
+				(MR_RAID_CTX_CPUSEL_0 << MR_RAID_CTX_ROUTINGFLAGS_CPUSEL_SHIFT);
 	}
 
 	if (fp_possible) {
@@ -2390,12 +2392,14 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 			  (MR_RL_FLAGS_GRANT_DESTINATION_CUDA |
 			   MR_RL_FLAGS_SEQ_NUM_ENABLE);
 		} else if (instance->is_ventura) {
-			io_request->RaidContext.raid_context_g35.type
-				= MPI2_TYPE_CUDA;
-			io_request->RaidContext.raid_context_g35.nseg = 0x1;
-			io_request->RaidContext.raid_context_g35.routing_flags.bits.sqn = 1;
+			io_request->RaidContext.raid_context_g35.nseg_type |=
+						(1 << RAID_CONTEXT_NSEG_SHIFT);
+			io_request->RaidContext.raid_context_g35.nseg_type |=
+						(MPI2_TYPE_CUDA << RAID_CONTEXT_TYPE_SHIFT);
+			io_request->RaidContext.raid_context_g35.routing_flags |=
+						(1 << MR_RAID_CTX_ROUTINGFLAGS_SQN_SHIFT);
 			io_request->IoFlags |=
-			cpu_to_le16(MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH);
+				cpu_to_le16(MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH);
 		}
 		if (fusion->load_balance_info &&
 			(fusion->load_balance_info[device_id].loadBalanceFlag) &&
@@ -2453,10 +2457,12 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 				 MR_RL_FLAGS_SEQ_NUM_ENABLE);
 			io_request->RaidContext.raid_context.nseg = 0x1;
 		} else if (instance->is_ventura) {
-			io_request->RaidContext.raid_context_g35.type
-				= MPI2_TYPE_CUDA;
-			io_request->RaidContext.raid_context_g35.routing_flags.bits.sqn = 1;
-			io_request->RaidContext.raid_context_g35.nseg = 0x1;
+			io_request->RaidContext.raid_context_g35.routing_flags |=
+					(1 << MR_RAID_CTX_ROUTINGFLAGS_SQN_SHIFT);
+			io_request->RaidContext.raid_context_g35.nseg_type |=
+					(1 << RAID_CONTEXT_NSEG_SHIFT);
+			io_request->RaidContext.raid_context_g35.nseg_type |=
+					(MPI2_TYPE_CUDA << RAID_CONTEXT_TYPE_SHIFT);
 		}
 		io_request->Function = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
 		io_request->DevHandle = cpu_to_le16(device_id);
@@ -2606,17 +2612,23 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 			pRAID_Context->virtual_disk_tgt_id =
 				pd_sync->seq[pd_index].pd_target_id;
 		else
-		pRAID_Context->virtual_disk_tgt_id =
-			cpu_to_le16(device_id + (MAX_PHYSICAL_DEVICES - 1));
+			pRAID_Context->virtual_disk_tgt_id =
+				cpu_to_le16(device_id + (MAX_PHYSICAL_DEVICES - 1));
 		pRAID_Context->config_seq_num = pd_sync->seq[pd_index].seqNum;
 		io_request->DevHandle = pd_sync->seq[pd_index].devHandle;
-		if (instance->is_ventura)
-			io_request->RaidContext.raid_context_g35.routing_flags.bits.sqn = 1;
-		else
-		pRAID_Context->reg_lock_flags |=
-			(MR_RL_FLAGS_SEQ_NUM_ENABLE|MR_RL_FLAGS_GRANT_DESTINATION_CUDA);
-		pRAID_Context->type = MPI2_TYPE_CUDA;
-		pRAID_Context->nseg = 0x1;
+		if (instance->is_ventura) {
+			io_request->RaidContext.raid_context_g35.routing_flags |=
+				(1 << MR_RAID_CTX_ROUTINGFLAGS_SQN_SHIFT);
+			io_request->RaidContext.raid_context_g35.nseg_type |=
+							(1 << RAID_CONTEXT_NSEG_SHIFT);
+			io_request->RaidContext.raid_context_g35.nseg_type |=
+							(MPI2_TYPE_CUDA << RAID_CONTEXT_TYPE_SHIFT);
+		} else {
+			pRAID_Context->type = MPI2_TYPE_CUDA;
+			pRAID_Context->nseg = 0x1;
+			pRAID_Context->reg_lock_flags |=
+				(MR_RL_FLAGS_SEQ_NUM_ENABLE|MR_RL_FLAGS_GRANT_DESTINATION_CUDA);
+		}
 	} else if (fusion->fast_path_io) {
 		pRAID_Context->virtual_disk_tgt_id = cpu_to_le16(device_id);
 		pRAID_Context->config_seq_num = 0;
@@ -2731,9 +2743,11 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 		return 1;
 	}
 
-	if (instance->is_ventura)
-		io_request->RaidContext.raid_context_g35.num_sge = sge_count;
-	else {
+	if (instance->is_ventura) {
+		set_num_sge(io_request->RaidContext.raid_context_g35, sge_count);
+		cpu_to_le16s(&io_request->RaidContext.raid_context_g35.routing_flags);
+		cpu_to_le16s(&io_request->RaidContext.raid_context_g35.nseg_type);
+	} else {
 		/* numSGE store lower 8 bit of sge_count.
 		 * numSGEExt store higher 8 bit of sge_count
 		 */
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index f25a262..6c22337 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -148,44 +148,13 @@ struct RAID_CONTEXT {
  * starts in MPT IO Frames
  */
 struct RAID_CONTEXT_G35 {
-#if   defined(__BIG_ENDIAN_BITFIELD)
-	u16	resvd0:8;
-	u16	nseg:4;
-	u16	type:4;
-#else
-	u16	type:4;		    /* 0x00 */
-	u16	nseg:4;		    /* 0x00 */
-	u16 resvd0:8;
-#endif
+	#define RAID_CONTEXT_NSEG_MASK	0x00F0
+	#define RAID_CONTEXT_NSEG_SHIFT	4
+	#define RAID_CONTEXT_TYPE_MASK	0x000F
+	#define RAID_CONTEXT_TYPE_SHIFT	0
+	u16		nseg_type;
 	u16 timeout_value; /* 0x02 -0x03 */
-	union {
-		struct {
-#if	defined(__BIG_ENDIAN_BITFIELD)
-		u16	set_divert:4;
-		u16	cpu_sel:4;
-		u16	log:1;
-		u16	rw:1;
-		u16	sbs:1;
-		u16	sqn:1;
-		u16	fwn:1;
-		u16	c2f:1;
-		u16	sld:1;
-		u16	reserved:1;
-#else
-		u16	reserved:1;
-		u16	sld:1;
-		u16	c2f:1;
-		u16	fwn:1;
-		u16	sqn:1;
-		u16	sbs:1;
-		u16	rw:1;
-		u16	log:1;
-		u16	cpu_sel:4;
-		u16	set_divert:4;
-#endif
-			} bits;
-		u16 s;
-	} routing_flags;	/* 0x04 -0x05 routing flags */
+	u16		routing_flags;	// 0x04 -0x05 routing flags
 	u16 virtual_disk_tgt_id;   /* 0x06 -0x07 */
 	u64 reg_lock_row_lba;      /* 0x08 - 0x0F */
 	u32 reg_lock_length;      /* 0x10 - 0x13 */
@@ -200,18 +169,78 @@ struct RAID_CONTEXT_G35 {
 				 */
 	u8 span_arm;            /* 0x1C span[7:5], arm[4:0] */
 	u16	config_seq_num;           /* 0x1A -0x1B */
+	union {
+		/*
+		 * Bit format:
+		 *	 ---------------------------------
+		 *	 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
+		 *	 ---------------------------------
+		 * Byte0 |    numSGE[7]- numSGE[0]	 |
+		 *	 ---------------------------------
+		 * Byte1 |SD | resvd     | numSGE 8-11   |
+		 *        --------------------------------
+		 */
+		#define NUM_SGE_MASK_LOWER	0xFF
+		#define NUM_SGE_MASK_UPPER	0x0F
+		#define NUM_SGE_SHIFT_UPPER	8
+		#define STREAM_DETECT_SHIFT	7
+		#define STREAM_DETECT_MASK	0x80
+		struct {
 #if   defined(__BIG_ENDIAN_BITFIELD) /* 0x1C - 0x1D */
-	u16 stream_detected:1;
-	u16 reserved:3;
-	u16 num_sge:12;
+			u16 stream_detected:1;
+			u16 reserved:3;
+			u16 num_sge:12;
 #else
-	u16 num_sge:12;
-	u16 reserved:3;
-	u16 stream_detected:1;
+			u16 num_sge:12;
+			u16 reserved:3;
+			u16 stream_detected:1;
 #endif
+		} bits;
+		u8 bytes[2];
+	} u;
 	u8 resvd2[2];          /* 0x1E-0x1F */
 };
 
+#define MR_RAID_CTX_ROUTINGFLAGS_SLD_SHIFT	1
+#define MR_RAID_CTX_ROUTINGFLAGS_C2D_SHIFT	2
+#define MR_RAID_CTX_ROUTINGFLAGS_FWD_SHIFT	3
+#define MR_RAID_CTX_ROUTINGFLAGS_SQN_SHIFT	4
+#define MR_RAID_CTX_ROUTINGFLAGS_SBS_SHIFT	5
+#define MR_RAID_CTX_ROUTINGFLAGS_RW_SHIFT	6
+#define MR_RAID_CTX_ROUTINGFLAGS_LOG_SHIFT	7
+#define MR_RAID_CTX_ROUTINGFLAGS_CPUSEL_SHIFT	8
+#define MR_RAID_CTX_ROUTINGFLAGS_CPUSEL_MASK	0x0F00
+#define MR_RAID_CTX_ROUTINGFLAGS_SETDIVERT_SHIFT	12
+#define MR_RAID_CTX_ROUTINGFLAGS_SETDIVERT_MASK	0xF000
+
+static inline void set_num_sge(struct RAID_CONTEXT_G35 rctx_g35,
+			       u16 sge_count)
+{
+	rctx_g35.u.bytes[0] = (u8)(sge_count & NUM_SGE_MASK_LOWER);
+	rctx_g35.u.bytes[1] |= (u8)((sge_count >> NUM_SGE_SHIFT_UPPER)
+							& NUM_SGE_MASK_UPPER);
+}
+
+static inline u16 get_num_sge(struct RAID_CONTEXT_G35 rctx_g35)
+{
+	u16 sge_count;
+
+	sge_count = (u16)(((rctx_g35.u.bytes[1] & NUM_SGE_MASK_UPPER)
+			<< NUM_SGE_SHIFT_UPPER) | (rctx_g35.u.bytes[0]));
+	return sge_count;
+}
+
+#define SET_STREAM_DETECTED(rctx_g35) \
+	(rctx_g35.u.bytes[1] |= STREAM_DETECT_MASK)
+
+#define CLEAR_STREAM_DETECTED(rctx_g35) \
+	(rctx_g35.u.bytes[1] &= ~(STREAM_DETECT_MASK))
+
+static inline bool is_stream_detected(struct RAID_CONTEXT_G35 *rctx_g35)
+{
+	return ((rctx_g35->u.bytes[1] & STREAM_DETECT_MASK));
+}
+
 union RAID_CONTEXT_UNION {
 	struct RAID_CONTEXT raid_context;
 	struct RAID_CONTEXT_G35 raid_context_g35;
-- 
2.8.3
