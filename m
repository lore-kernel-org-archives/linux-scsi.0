From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 02/39] megaraid_sas: cpu select rework.
Date: Wed,  8 Feb 2017 01:28:56 -0800
Message-ID: <1486546173-20713-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:32934 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933059AbdBHJaB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 04:30:01 -0500
Received: by mail-pg0-f45.google.com with SMTP id 204so47585168pge.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 01:30:01 -0800 (PST)
In-Reply-To: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

No functional change. Code refactor.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 175 ++++++++++++++++------------
 1 file changed, 100 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 54728b3..514c306 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1819,6 +1819,73 @@ static void megasas_stream_detect(struct megasas_instance *instance,
 }
 
 /**
+ * megasas_set_raidflag_cpu_affinity - This function sets the cpu
+ * affinity (cpu of the controller) and raid_flags in the raid context
+ * based on IO type.
+ *
+ * @praid_context:	IO RAID context
+ * @raid:		LD raid map
+ * @fp_possible:	Is fast path possible?
+ * @is_read:		Is read IO?
+ *
+ */
+static void
+megasas_set_raidflag_cpu_affinity(union RAID_CONTEXT_UNION *praid_context,
+				  struct MR_LD_RAID *raid, bool fp_possible,
+				  u8 is_read)
+{
+	u8 cpu_sel = MR_RAID_CTX_CPUSEL_0;
+	struct RAID_CONTEXT_G35 *rctx_g35;
+
+	rctx_g35 = &praid_context->raid_context_g35;
+	if (fp_possible) {
+		if (is_read) {
+			if ((raid->cpuAffinity.pdRead.cpu0) &&
+			    (raid->cpuAffinity.pdRead.cpu1))
+				cpu_sel = MR_RAID_CTX_CPUSEL_FCFS;
+			else if (raid->cpuAffinity.pdRead.cpu1)
+				cpu_sel = MR_RAID_CTX_CPUSEL_1;
+		} else {
+			if ((raid->cpuAffinity.pdWrite.cpu0) &&
+			    (raid->cpuAffinity.pdWrite.cpu1))
+				cpu_sel = MR_RAID_CTX_CPUSEL_FCFS;
+			else if (raid->cpuAffinity.pdWrite.cpu1)
+				cpu_sel = MR_RAID_CTX_CPUSEL_1;
+			/* Fast path cache by pass capable R0/R1 VD */
+			if ((raid->level <= 1) &&
+			    (raid->capability.fp_cache_bypass_capable)) {
+				rctx_g35->routing_flags.bits.sld = 1;
+				rctx_g35->raid_flags =
+					(MR_RAID_FLAGS_IO_SUB_TYPE_CACHE_BYPASS
+					<< MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT);
+			}
+		}
+	} else {
+		if (is_read) {
+			if ((raid->cpuAffinity.ldRead.cpu0) &&
+			    (raid->cpuAffinity.ldRead.cpu1))
+				cpu_sel = MR_RAID_CTX_CPUSEL_FCFS;
+			else if (raid->cpuAffinity.ldRead.cpu1)
+				cpu_sel = MR_RAID_CTX_CPUSEL_1;
+		} else {
+			if ((raid->cpuAffinity.ldWrite.cpu0) &&
+			    (raid->cpuAffinity.ldWrite.cpu1))
+				cpu_sel = MR_RAID_CTX_CPUSEL_FCFS;
+			else if (raid->cpuAffinity.ldWrite.cpu1)
+				cpu_sel = MR_RAID_CTX_CPUSEL_1;
+
+			if (rctx_g35->stream_detected &&
+			    (raid->level == 5) &&
+			    (raid->writeMode == MR_RL_WRITE_THROUGH_MODE) &&
+			    (cpu_sel == MR_RAID_CTX_CPUSEL_FCFS))
+				cpu_sel = MR_RAID_CTX_CPUSEL_0;
+		}
+	}
+
+	rctx_g35->routing_flags.bits.cpu_sel = cpu_sel;
+}
+
+/**
  * megasas_build_ldio_fusion -	Prepares IOs to devices
  * @instance:		Adapter soft state
  * @scp:		SCSI command
@@ -1832,8 +1899,10 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 			  struct scsi_cmnd *scp,
 			  struct megasas_cmd_fusion *cmd)
 {
-	u8 fp_possible;
-	u32 start_lba_lo, start_lba_hi, device_id, datalength = 0, ld;
+	bool fp_possible;
+	u16 ld;
+	u32 start_lba_lo, start_lba_hi, device_id, datalength = 0;
+	u32 scsi_buff_len;
 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
 	struct IO_REQUEST_INFO io_info;
@@ -1842,7 +1911,8 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 	u8 *raidLUN;
 	unsigned long spinlock_flags;
 	union RAID_CONTEXT_UNION *praid_context;
-	struct MR_LD_RAID *raid;
+	struct MR_LD_RAID *raid = NULL;
+	struct MR_PRIV_DEVICE *mrdev_priv;
 
 	device_id = MEGASAS_DEV_INDEX(scp);
 
@@ -1858,7 +1928,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 
 	start_lba_lo = 0;
 	start_lba_hi = 0;
-	fp_possible = 0;
+	fp_possible = false;
 
 	/*
 	 * 6-byte READ(0x08) or WRITE(0x0A) cdb
@@ -1915,7 +1985,8 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 	io_info.numBlocks = datalength;
 	io_info.ldTgtId = device_id;
 	io_info.r1_alt_dev_handle = MR_PD_INVALID;
-	io_request->DataLength = cpu_to_le32(scsi_bufflen(scp));
+	scsi_buff_len = scsi_bufflen(scp);
+	io_request->DataLength = cpu_to_le32(scsi_buff_len);
 
 	if (scp->sc_data_direction == PCI_DMA_FROMDEVICE)
 		io_info.isRead = 1;
@@ -1927,12 +1998,12 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 	if ((MR_TargetIdToLdGet(device_id, local_map_ptr) >=
 		instance->fw_supported_vd_count) || (!fusion->fast_path_io)) {
 		io_request->RaidContext.raid_context.reg_lock_flags  = 0;
-		fp_possible = 0;
+		fp_possible = false;
 	} else {
 		if (MR_BuildRaidContext(instance, &io_info,
 					&io_request->RaidContext.raid_context,
 					local_map_ptr, &raidLUN))
-			fp_possible = io_info.fpOkForIo;
+			fp_possible = (io_info.fpOkForIo > 0) ? true : false;
 	}
 
 	/* Use raw_smp_processor_id() for now until cmd->request->cpu is CPU
@@ -1941,6 +2012,8 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 	cmd->request_desc->SCSIIO.MSIxIndex = instance->msix_vectors ?
 		raw_smp_processor_id() % instance->msix_vectors : 0;
 
+	praid_context = &io_request->RaidContext;
+
 	if (instance->is_ventura) {
 		spin_lock_irqsave(&instance->stream_lock, spinlock_flags);
 		megasas_stream_detect(instance, cmd, &io_info);
@@ -1948,12 +2021,28 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 		/* In ventura if stream detected for a read and it is read ahead
 		 *  capable make this IO as LDIO
 		 */
-		if (io_request->RaidContext.raid_context_g35.stream_detected &&
-				io_info.isRead && io_info.ra_capable)
+		if (praid_context->raid_context_g35.stream_detected &&
+		    io_info.isRead && io_info.ra_capable)
 			fp_possible = false;
-	}
 
-	praid_context = &io_request->RaidContext;
+		if (io_info.r1_alt_dev_handle != MR_PD_INVALID) {
+			mrdev_priv = scp->device->hostdata;
+
+			if (atomic_inc_return(&instance->fw_outstanding) >
+				(instance->host->can_queue)) {
+				fp_possible = false;
+				atomic_dec(&instance->fw_outstanding);
+			}
+		}
+
+		/* If raid is NULL, set CPU affinity to default CPU0 */
+		if (raid)
+			megasas_set_raidflag_cpu_affinity(praid_context,
+				raid, fp_possible, io_info.isRead);
+		else
+			praid_context->raid_context_g35.routing_flags.bits.cpu_sel =
+				MR_RAID_CTX_CPUSEL_0;
+	}
 
 	if (fp_possible) {
 		megasas_set_pd_lba(io_request, scp->cmd_len, &io_info, scp,
@@ -2016,36 +2105,6 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 		io_request->DevHandle = io_info.devHandle;
 		/* populate the LUN field */
 		memcpy(io_request->LUN, raidLUN, 8);
-		if (instance->is_ventura) {
-			if (io_info.isRead) {
-				if ((raid->cpuAffinity.pdRead.cpu0) &&
-					(raid->cpuAffinity.pdRead.cpu1))
-					praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-					= MR_RAID_CTX_CPUSEL_FCFS;
-				else if (raid->cpuAffinity.pdRead.cpu1)
-					praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-					= MR_RAID_CTX_CPUSEL_1;
-				else
-					praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-					= MR_RAID_CTX_CPUSEL_0;
-			} else {
-			if ((raid->cpuAffinity.pdWrite.cpu0)
-			&& (raid->cpuAffinity.pdWrite.cpu1))
-				praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-					= MR_RAID_CTX_CPUSEL_FCFS;
-				else if (raid->cpuAffinity.pdWrite.cpu1)
-					praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-					= MR_RAID_CTX_CPUSEL_1;
-				else
-					praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-					= MR_RAID_CTX_CPUSEL_0;
-				if (praid_context->raid_context_g35.routing_flags.bits.sld) {
-					praid_context->raid_context_g35.raid_flags
-					= (MR_RAID_FLAGS_IO_SUB_TYPE_CACHE_BYPASS
-					<< MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT);
-				}
-			}
-		}
 	} else {
 		io_request->RaidContext.raid_context.timeout_value =
 			cpu_to_le16(local_map_ptr->raidMap.fpPdIoTimeoutSec);
@@ -2074,40 +2133,6 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 		io_request->Function = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
 		io_request->DevHandle = cpu_to_le16(device_id);
 
-		if (instance->is_ventura) {
-			if (io_info.isRead) {
-				if ((raid->cpuAffinity.ldRead.cpu0)
-				&& (raid->cpuAffinity.ldRead.cpu1))
-					praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-					= MR_RAID_CTX_CPUSEL_FCFS;
-				else if (raid->cpuAffinity.ldRead.cpu1)
-					praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-						= MR_RAID_CTX_CPUSEL_1;
-				else
-					praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-						= MR_RAID_CTX_CPUSEL_0;
-			} else {
-				if ((raid->cpuAffinity.ldWrite.cpu0) &&
-					(raid->cpuAffinity.ldWrite.cpu1))
-					praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-						= MR_RAID_CTX_CPUSEL_FCFS;
-				else if (raid->cpuAffinity.ldWrite.cpu1)
-					praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-						= MR_RAID_CTX_CPUSEL_1;
-				else
-					praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-					= MR_RAID_CTX_CPUSEL_0;
-
-				if (io_request->RaidContext.raid_context_g35.stream_detected
-					&& (raid->level == 5) &&
-					(raid->writeMode == MR_RL_WRITE_THROUGH_MODE)) {
-					if (praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-						== MR_RAID_CTX_CPUSEL_FCFS)
-						praid_context->raid_context_g35.routing_flags.bits.cpu_sel
-							= MR_RAID_CTX_CPUSEL_0;
-				}
-			}
-		}
 	} /* Not FP */
 }
 
-- 
2.8.3
