From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH 04/11] megaraid_sas: SAS3.5 Generic Megaraid Controllers Stream Detection and IO Coalescing
Date: Fri,  2 Dec 2016 09:07:21 -0500
Message-ID: <1480687648-36380-5-git-send-email-sasikumar.pc@broadcom.com>
References: <1480687648-36380-1-git-send-email-sasikumar.pc@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480687648-36380-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, sumit.saxena@broadcom.com, thenzl@redhat.com, Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Detect sequential IO streams and pass those IOs directly to FW.

This patch is depending on patch 3

Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |   1 +
 drivers/scsi/megaraid/megaraid_sas_base.c   |  40 +++++++-
 drivers/scsi/megaraid/megaraid_sas_fp.c     |   2 +
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 151 +++++++++++++++++++++++-----
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 123 +++++++++++++++++++++-
 5 files changed, 287 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index af94f58..ee6bd5c 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2073,6 +2073,7 @@ struct megasas_instance {
 	/* used to sync fire the cmd to fw */
 	spinlock_t hba_lock;
 	/* used to synch producer, consumer ptrs in dpc */
+	spinlock_t stream_lock;
 	spinlock_t completion_lock;
 	struct dma_pool *frame_dma_pool;
 	struct dma_pool *sense_dma_pool;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 7c8c313..86f25d5 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5018,7 +5018,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	struct megasas_register_set __iomem *reg_set;
 	struct megasas_ctrl_info *ctrl_info = NULL;
 	unsigned long bar_list;
-	int i, loop, fw_msix_count = 0;
+	int i, j, loop, fw_msix_count = 0;
 	struct IOV_111 *iovPtr;
 	struct fusion_context *fusion;
 
@@ -5205,6 +5205,33 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	}
 
 	memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
+
+	/* stream detection initialization */
+	if (instance->is_ventura) {
+		fusion->streamDetectByLD =
+		kzalloc(sizeof(PTR_LD_STREAM_DETECT) * MAX_LOGICAL_DRIVES_EXT,
+				GFP_KERNEL);
+		if (!fusion->streamDetectByLD) {
+			dev_err(&instance->pdev->dev,
+					"unable to allocate stream detection for pool of LDs\n");
+			goto fail_get_ld_pd_list;
+		}
+		for (i = 0; i < MAX_LOGICAL_DRIVES_EXT; ++i) {
+			fusion->streamDetectByLD[i] =
+				kmalloc(sizeof(LD_STREAM_DETECT), GFP_KERNEL);
+			if (!fusion->streamDetectByLD[i]) {
+				dev_err(&instance->pdev->dev,
+					"unable to allocate stream detect by LD\n ");
+				 for (j = 0; j < i; ++j)
+					kfree(fusion->streamDetectByLD[j]);
+				kfree(fusion->streamDetectByLD);
+				fusion->streamDetectByLD = NULL;
+				goto fail_get_ld_pd_list;
+			}
+			fusion->streamDetectByLD[i]->mruBitMap = MR_STREAM_BITMAP;
+		}
+	}
+
 	if (megasas_ld_list_query(instance,
 				  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
 		megasas_get_ld_list(instance);
@@ -5324,6 +5351,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 	return 0;
 
+fail_get_ld_pd_list:
+	instance->instancet->disable_intr(instance);
 fail_get_pd_list:
 	instance->instancet->disable_intr(instance);
 	megasas_destroy_irqs(instance);
@@ -5860,6 +5889,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 
 	spin_lock_init(&instance->mfi_pool_lock);
 	spin_lock_init(&instance->hba_lock);
+	spin_lock_init(&instance->stream_lock);
 	spin_lock_init(&instance->completion_lock);
 
 	mutex_init(&instance->reset_mutex);
@@ -6360,6 +6390,14 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	if (instance->msix_vectors)
 		pci_disable_msix(instance->pdev);
 
+	if (instance->is_ventura) {
+		for (i = 0; i < MAX_LOGICAL_DRIVES_EXT; ++i)
+			kfree(fusion->streamDetectByLD[i]);
+		kfree(fusion->streamDetectByLD);
+		fusion->streamDetectByLD = NULL;
+	}
+
+
 	if (instance->ctrl_context) {
 		megasas_release_fusion(instance);
 			pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index f237d00..d9483bc 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -935,6 +935,8 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 
 	ld = MR_TargetIdToLdGet(ldTgtId, map);
 	raid = MR_LdRaidGet(ld, map);
+	/*check read ahead bit*/
+	io_info->raCapable = raid->capability.raCapable;
 
 	/*
 	 * if rowDataSize @RAID map and spanRowDataSize @SPAN INFO are zero
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 7f26b14..3ad929b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1704,6 +1704,81 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 }
 
 /**
+ * megasas_stream_detect -	stream detection on read and and write IOs
+ * @instance:		Adapter soft state
+ * @cmd:		    Command to be prepared
+ * @io_info:		IO Request info
+ *
+ */
+
+/** stream detection on read and and write IOs */
+static void megasas_stream_detect(struct megasas_instance *instance,
+				struct megasas_cmd_fusion *cmd,
+				struct IO_REQUEST_INFO *io_info)
+{
+	struct fusion_context *fusion = instance->ctrl_context;
+	u32 device_id = io_info->ldTgtId;
+	LD_STREAM_DETECT *current_ld_SD = fusion->streamDetectByLD[device_id];
+	u32 *track_stream = &current_ld_SD->mruBitMap, streamNum;
+	u32 shiftedValues, unshiftedValues;
+	u32 indexValueMask, shiftedValuesMask;
+	int i;
+	bool isReadAhead = false;
+	STREAM_DETECT *current_SD;
+	/* find possible stream */
+	for (i = 0; i < MAX_STREAMS_TRACKED; ++i) {
+		streamNum = (*track_stream >> (i * BITS_PER_INDEX_STREAM)) &
+			STREAM_MASK;
+		current_SD = &current_ld_SD->streamTrack[streamNum];
+	/* if we found a stream, update the raid
+	*  context and also update the mruBitMap 
+	*/
+	/*	boundary condition */
+		if (current_SD->nextSeqLBA && 
+				io_info->ldStartBlock >= current_SD->nextSeqLBA &&
+				(io_info->ldStartBlock <= (current_SD->nextSeqLBA+32)) &&
+				(current_SD->isRead == io_info->isRead)) {
+				if (io_info->ldStartBlock != current_SD->nextSeqLBA &&
+				(!io_info->isRead || !isReadAhead))
+				/*
+				*  Once the API availible we need to change this.
+				* At this point we are not allowing any gap
+				*/
+				continue;
+			cmd->io_request->RaidContext.raid_context_g35.streamDetected =
+																		true;
+			current_SD->nextSeqLBA =
+								io_info->ldStartBlock + io_info->numBlocks;
+			/*
+			*	update the mruBitMap LRU
+			*/
+			shiftedValuesMask = (1 <<  i * BITS_PER_INDEX_STREAM) - 1;
+			shiftedValues = ((*track_stream & shiftedValuesMask)
+						<< BITS_PER_INDEX_STREAM);
+			indexValueMask = STREAM_MASK << i * BITS_PER_INDEX_STREAM;
+			unshiftedValues =
+					*track_stream & ~(shiftedValuesMask | indexValueMask);
+			*track_stream = unshiftedValues | shiftedValues | streamNum;
+			return;
+
+		}
+
+	}
+	/*
+	* if we did not find any stream, create a new one from the least recently used
+	*/
+	streamNum =
+	(*track_stream >> ((MAX_STREAMS_TRACKED - 1) * BITS_PER_INDEX_STREAM)) &
+			STREAM_MASK;
+	current_SD = &current_ld_SD->streamTrack[streamNum];
+	current_SD->isRead = io_info->isRead;
+	current_SD->nextSeqLBA = io_info->ldStartBlock + io_info->numBlocks;
+	*track_stream = (((*track_stream & ZERO_LAST_STREAM) << 4) | streamNum);
+	return;
+
+}
+
+/**
  * megasas_build_ldio_fusion -	Prepares IOs to devices
  * @instance:		Adapter soft state
  * @scp:		SCSI command
@@ -1725,15 +1800,17 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 	struct fusion_context *fusion;
 	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
 	u8 *raidLUN;
+	unsigned long spinlock_flags;
 
 	device_id = MEGASAS_DEV_INDEX(scp);
 
 	fusion = instance->ctrl_context;
 
 	io_request = cmd->io_request;
-	io_request->RaidContext.VirtualDiskTgtId = cpu_to_le16(device_id);
-	io_request->RaidContext.status = 0;
-	io_request->RaidContext.exStatus = 0;
+	io_request->RaidContext.raid_context.VirtualDiskTgtId =
+										cpu_to_le16(device_id);
+	io_request->RaidContext.raid_context.status = 0;
+	io_request->RaidContext.raid_context.exStatus = 0;
 
 	req_desc = (union MEGASAS_REQUEST_DESCRIPTOR_UNION *)cmd->request_desc;
 
@@ -1804,11 +1881,11 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 
 	if ((MR_TargetIdToLdGet(device_id, local_map_ptr) >=
 		instance->fw_supported_vd_count) || (!fusion->fast_path_io)) {
-		io_request->RaidContext.regLockFlags  = 0;
+		io_request->RaidContext.raid_context.regLockFlags  = 0;
 		fp_possible = 0;
 	} else {
 		if (MR_BuildRaidContext(instance, &io_info,
-					&io_request->RaidContext,
+					&io_request->RaidContext.raid_context,
 					local_map_ptr, &raidLUN))
 			fp_possible = io_info.fpOkForIo;
 	}
@@ -1819,6 +1896,18 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 	cmd->request_desc->SCSIIO.MSIxIndex = instance->msix_vectors ?
 		raw_smp_processor_id() % instance->msix_vectors : 0;
 
+	if (instance->is_ventura) {
+		spin_lock_irqsave(&instance->stream_lock, spinlock_flags);
+		megasas_stream_detect(instance, cmd, &io_info);
+		spin_unlock_irqrestore(&instance->stream_lock, spinlock_flags);
+		/* In ventura if stream detected for a read and it is read ahead
+		*  capable make this IO as LDIO 
+		*/
+		if (io_request->RaidContext.raid_context_g35.streamDetected &&
+				io_info.isRead && io_info.raCapable)
+			fp_possible = false;
+	}
+
 	if (fp_possible) {
 		megasas_set_pd_lba(io_request, scp->cmd_len, &io_info, scp,
 				   local_map_ptr, start_lba_lo);
@@ -1827,15 +1916,15 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 			(MPI2_REQ_DESCRIPT_FLAGS_FP_IO
 			 << MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
 		if (fusion->adapter_type == INVADER_SERIES) {
-			if (io_request->RaidContext.regLockFlags ==
+			if (io_request->RaidContext.raid_context.regLockFlags ==
 			    REGION_TYPE_UNUSED)
 				cmd->request_desc->SCSIIO.RequestFlags =
 					(MEGASAS_REQ_DESCRIPT_FLAGS_NO_LOCK <<
 					MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
-			io_request->RaidContext.Type = MPI2_TYPE_CUDA;
-			io_request->RaidContext.nseg = 0x1;
+			io_request->RaidContext.raid_context.Type = MPI2_TYPE_CUDA;
+			io_request->RaidContext.raid_context.nseg = 0x1;
 			io_request->IoFlags |= cpu_to_le16(MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH);
-			io_request->RaidContext.regLockFlags |=
+			io_request->RaidContext.raid_context.regLockFlags |=
 			  (MR_RL_FLAGS_GRANT_DESTINATION_CUDA |
 			   MR_RL_FLAGS_SEQ_NUM_ENABLE);
 		}
@@ -1862,22 +1951,23 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 		/* populate the LUN field */
 		memcpy(io_request->LUN, raidLUN, 8);
 	} else {
-		io_request->RaidContext.timeoutValue =
+		io_request->RaidContext.raid_context.timeoutValue =
 			cpu_to_le16(local_map_ptr->raidMap.fpPdIoTimeoutSec);
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MEGASAS_REQ_DESCRIPT_FLAGS_LD_IO
 			 << MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
 		if (fusion->adapter_type == INVADER_SERIES) {
 			if (io_info.do_fp_rlbypass ||
-				(io_request->RaidContext.regLockFlags == REGION_TYPE_UNUSED))
+				(io_request->RaidContext.raid_context.regLockFlags ==
+													REGION_TYPE_UNUSED))
 				cmd->request_desc->SCSIIO.RequestFlags =
 					(MEGASAS_REQ_DESCRIPT_FLAGS_NO_LOCK <<
 					MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
-			io_request->RaidContext.Type = MPI2_TYPE_CUDA;
-			io_request->RaidContext.regLockFlags |=
+			io_request->RaidContext.raid_context.Type = MPI2_TYPE_CUDA;
+			io_request->RaidContext.raid_context.regLockFlags |=
 				(MR_RL_FLAGS_GRANT_DESTINATION_CPU0 |
 				 MR_RL_FLAGS_SEQ_NUM_ENABLE);
-			io_request->RaidContext.nseg = 0x1;
+			io_request->RaidContext.raid_context.nseg = 0x1;
 		}
 		io_request->Function = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
 		io_request->DevHandle = cpu_to_le16(device_id);
@@ -1913,7 +2003,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 	local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
 	io_request->DataLength = cpu_to_le32(scsi_bufflen(scmd));
 	/* get RAID_Context pointer */
-	pRAID_Context = &io_request->RaidContext;
+	pRAID_Context = &io_request->RaidContext.raid_context;
 	/* Check with FW team */
 	pRAID_Context->VirtualDiskTgtId = cpu_to_le16(device_id);
 	pRAID_Context->regLockRowLBA    = 0;
@@ -2000,7 +2090,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 
 	io_request = cmd->io_request;
 	/* get RAID_Context pointer */
-	pRAID_Context = &io_request->RaidContext;
+	pRAID_Context = &io_request->RaidContext.raid_context;
 	pRAID_Context->regLockFlags = 0;
 	pRAID_Context->regLockRowLBA = 0;
 	pRAID_Context->regLockLength = 0;
@@ -2094,9 +2184,9 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 	io_request->Control = 0;
 	io_request->EEDPBlockSize = 0;
 	io_request->ChainOffset = 0;
-	io_request->RaidContext.RAIDFlags = 0;
-	io_request->RaidContext.Type = 0;
-	io_request->RaidContext.nseg = 0;
+	io_request->RaidContext.raid_context.RAIDFlags = 0;
+	io_request->RaidContext.raid_context.Type = 0;
+	io_request->RaidContext.raid_context.nseg = 0;
 
 	memcpy(io_request->CDB.CDB32, scp->cmnd, scp->cmd_len);
 	/*
@@ -2143,8 +2233,8 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 	/* numSGE store lower 8 bit of sge_count.
 	 * numSGEExt store higher 8 bit of sge_count
 	 */
-	io_request->RaidContext.numSGE = sge_count;
-	io_request->RaidContext.numSGEExt = (u8)(sge_count >> 8);
+	io_request->RaidContext.raid_context.numSGE = sge_count;
+	io_request->RaidContext.raid_context.numSGEExt = (u8)(sge_count >> 8);
 
 	io_request->SGLFlags = cpu_to_le16(MPI2_SGE_FLAGS_64_BIT_ADDRESSING);
 
@@ -2303,8 +2393,8 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 			cmd_fusion->scmd->SCp.ptr = NULL;
 
 		scmd_local = cmd_fusion->scmd;
-		status = scsi_io_req->RaidContext.status;
-		extStatus = scsi_io_req->RaidContext.exStatus;
+		status = scsi_io_req->RaidContext.raid_context.status;
+		extStatus = scsi_io_req->RaidContext.raid_context.exStatus;
 
 		switch (scsi_io_req->Function) {
 		case MPI2_FUNCTION_SCSI_TASK_MGMT:
@@ -2337,8 +2427,8 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 		case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO Path */
 			/* Map the FW Cmd Status */
 			map_cmd_status(cmd_fusion, status, extStatus);
-			scsi_io_req->RaidContext.status = 0;
-			scsi_io_req->RaidContext.exStatus = 0;
+			scsi_io_req->RaidContext.raid_context.status = 0;
+			scsi_io_req->RaidContext.raid_context.exStatus = 0;
 			if (megasas_cmd_type(scmd_local) == READ_WRITE_LDIO)
 				atomic_dec(&instance->ldio_outstanding);
 			megasas_return_cmd_fusion(instance, cmd_fusion);
@@ -3393,7 +3483,7 @@ int megasas_check_mpio_paths(struct megasas_instance *instance,
 /* Core fusion reset function */
 int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 {
-	int retval = SUCCESS, i, convert = 0;
+	int retval = SUCCESS, i, j, convert = 0;
 	struct megasas_instance *instance;
 	struct megasas_cmd_fusion *cmd_fusion;
 	struct fusion_context *fusion;
@@ -3558,6 +3648,15 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 			shost_for_each_device(sdev, shost)
 				megasas_update_sdev_properties(sdev);
 
+			/* reset stream detection array */
+			if (instance->is_ventura) {
+				for (j = 0; j < MAX_LOGICAL_DRIVES_EXT; ++j) {
+					memset(fusion->streamDetectByLD[j], 0,
+									sizeof(LD_STREAM_DETECT));
+					fusion->streamDetectByLD[j]->mruBitMap = MR_STREAM_BITMAP;
+				}
+			}
+
 			clear_bit(MEGASAS_FUSION_IN_RESET,
 				  &instance->reset_flags);
 			instance->instancet->enable_intr(instance);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 9d22ade..9bb2f40 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -133,12 +133,100 @@ struct RAID_CONTEXT {
 	u8      resvd2;
 };
 
+/*
+* Raid Context structure which describes ventura MegaRAID specific
+* IO Paramenters ,This resides at offset 0x60 where the SGL normally
+* starts in MPT IO Frames
+*/
+typedef struct _RAID_CONTEXT_G35 {
+#if   defined(__BIG_ENDIAN_BITFIELD)
+	u16	resvd0:8;
+	u16	nseg:4;
+	u16	Type:4;
+#else
+	u16	Type:4;		    /* 0x00 */
+	u16	nseg:4;		    /* 0x00 */
+	u16     resvd0:8;
+#endif
+	u16     timeoutValue; /* 0x02 -0x03 */
+	union {
+		struct {
+#if	defined(__BIG_ENDIAN_BITFIELD)
+		u16	setDivert:4;
+		u16	cpuSel:4;
+		u16	log:1;
+		u16	rw:1;
+		u16	sbs:1;
+		u16	sqn:1;
+		u16	fwn:1;
+		u16	c2f:1;
+		u16	sld:1;
+		u16	reserved:1;
+#else
+		u16	reserved:1;
+		u16	sld:1;
+		u16	c2f:1;
+		u16	fwn:1;
+		u16	sqn:1;
+		u16	sbs:1;
+		u16	rw:1;
+		u16	log:1;
+		u16	cpuSel:4;
+		u16	setDivert:4;
+#endif
+			} bits;
+		u16 s;
+	} routingFlags;	/* 0x04 -0x05 routing flags */
+
+	u16     VirtualDiskTgtId;   /* 0x06 -0x07 */
+
+	u64     regLockRowLBA;      /* 0x08 - 0x0F */
+
+	u32     regLockLength;      /* 0x10 - 0x13 */
+
+	union {
+		u16     nextLMId;           /* 0x14 - 0x15 */
+		u16	peerSMID;	/* used for the raid 1/10 fp writes */
+	} smid;
+	u8      exStatus;       /* 0x16 : OUT */
+	u8      status;             /* 0x17 status */
+
+	u8      RAIDFlags;          /* 0x18 resvd[7:6], ioSubType[5:4],
+								* resvd[3:1], preferredCpu[0] 
+								*/
+	u8      spanArm;            /* 0x1C span[7:5], arm[4:0] */
+	u16	configSeqNum;           /* 0x1A -0x1B */
+#if   defined(__BIG_ENDIAN_BITFIELD)              /* 0x1C Â– 0x1D */
+	u16     streamDetected:1;
+	u16     reserved:3;
+	u16     numSGE:12;
+#else
+	u16     numSGE:12;
+	u16     reserved:3;
+	u16     streamDetected:1;
+#endif
+	u8      resvd2[2];          /* 0x1E-0x1F */
+} RAID_CONTEXT_G35;
+
+typedef union _RAID_CONTEXT_UNION {
+	struct RAID_CONTEXT raid_context;
+	RAID_CONTEXT_G35 raid_context_g35;
+} RAID_CONTEXT_UNION, *PRAID_CONTEXT_UNION;
+
 #define RAID_CTX_SPANARM_ARM_SHIFT	(0)
 #define RAID_CTX_SPANARM_ARM_MASK	(0x1f)
 
 #define RAID_CTX_SPANARM_SPAN_SHIFT	(5)
 #define RAID_CTX_SPANARM_SPAN_MASK	(0xE0)
 
+/* number of bits per index in U32 TrackStream */
+#define BITS_PER_INDEX_STREAM		4
+#define INVALID_STREAM_NUM              16
+#define MR_STREAM_BITMAP		0x76543210
+#define STREAM_MASK			((1 << BITS_PER_INDEX_STREAM) - 1)
+#define ZERO_LAST_STREAM		0x0fffffff
+#define MAX_STREAMS_TRACKED 		8
+
 /*
  * define region lock types
  */
@@ -409,7 +497,7 @@ struct MPI2_RAID_SCSI_IO_REQUEST {
 	u8                      LUN[8];                         /* 0x34 */
 	__le32			Control;                        /* 0x3C */
 	union MPI2_SCSI_IO_CDB_UNION  CDB;			/* 0x40 */
-	struct RAID_CONTEXT	RaidContext;                    /* 0x60 */
+	RAID_CONTEXT_UNION            RaidContext;  /* 0x60 */
 	union MPI2_SGE_IO_UNION       SGL;			/* 0x80 */
 };
 
@@ -656,11 +744,13 @@ struct MR_LD_RAID {
 		u32     encryptionType:8;
 		u32     pdPiMode:4;
 		u32     ldPiMode:4;
-		u32     reserved5:3;
+		u32     reserved5:2;
+		u32     raCapable:1;
 		u32     fpCapable:1;
 #else
 		u32     fpCapable:1;
-		u32     reserved5:3;
+		u32     raCapable:1;
+		u32     reserved5:2;
 		u32     ldPiMode:4;
 		u32     pdPiMode:4;
 		u32     encryptionType:8;
@@ -745,6 +835,7 @@ struct IO_REQUEST_INFO {
 	u64 start_row;
 	u8  span_arm;	/* span[7:5], arm[4:0] */
 	u8  pd_after_lb;
+	bool raCapable;
 };
 
 struct MR_LD_TARGET_SYNC {
@@ -930,6 +1021,31 @@ struct MR_PD_CFG_SEQ_NUM_SYNC {
 	struct MR_PD_CFG_SEQ seq[1];
 } __packed;
 
+/* stream detection */
+typedef struct _STREAM_DETECT {
+	u64 nextSeqLBA; /* next LBA to match sequential access */
+	struct megasas_cmd_fusion *first_cmd_fusion; /* first cmd in group */
+	struct megasas_cmd_fusion *last_cmd_fusion; /* last cmd in group */
+	u32 countCmdsInStream; /* count of host commands in this stream */
+	u16 numSGEsInGroup; /* total number of SGEs in grouped IOs */
+	u8 isRead; /* SCSI OpCode for this stream */
+	u8 groupDepth; /* total number of host commands in group */
+	bool groupFlush; /* TRUE if cannot add any more commands to this group */
+	u8 reserved[7]; /* pad to 64-bit alignment */
+} STREAM_DETECT, *PTR_STREAM_DETECT;
+
+typedef struct _LD_STREAM_DETECT {
+	bool writeBack; /* TRUE if WB, FALSE if WT */
+	bool FPWriteEnabled;
+	bool membersSSDs;
+	bool fpCacheBypassCapable;
+	u32 mruBitMap; /* bitmap used to track MRU and LRU stream indicies */
+	volatile long iosToFware; /* current count of RW IOs sent to Fware */
+	volatile long writeBytesOutstanding; /* not used in first implementation */
+	/* this is the array of stream detect structures (one per stream) */
+	STREAM_DETECT streamTrack[MAX_STREAMS_TRACKED];
+} LD_STREAM_DETECT, *PTR_LD_STREAM_DETECT;
+
 struct MPI2_IOC_INIT_RDPQ_ARRAY_ENTRY {
 	u64 RDPQBaseAddress;
 	u32 Reserved1;
@@ -983,6 +1099,7 @@ struct fusion_context {
 	struct LD_LOAD_BALANCE_INFO load_balance_info[MAX_LOGICAL_DRIVES_EXT];
 	LD_SPAN_INFO log_to_span[MAX_LOGICAL_DRIVES_EXT];
 	u8 adapter_type;
+	PTR_LD_STREAM_DETECT  *streamDetectByLD;
 };
 
 union desc_value {
-- 
1.8.3.1
