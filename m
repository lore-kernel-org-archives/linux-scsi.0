From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 7/7] megaraid_sas : Endinaness related bug fixes
Date: Mon, 17 Nov 2014 15:24:28 +0530
Message-ID: <201411170958.sAH9w9jD008981@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com
List-Id: linux-scsi@vger.kernel.org

This patch addresses few endianness related bug fixes.

Cc: <stable@vger.kernel.org>

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c     |   17 +++++++++--------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   13 +++++++------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 246574b..460c6a3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -185,14 +185,15 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 		/* New Raid map will not set totalSize, so keep expected value
 		 * for legacy code in ValidateMapInfo
 		 */
-		pDrvRaidMap->totalSize = sizeof(struct MR_FW_RAID_MAP_EXT);
+		pDrvRaidMap->totalSize =
+			cpu_to_le32(sizeof(struct MR_FW_RAID_MAP_EXT));
 	} else {
 		fw_map_old = (struct MR_FW_RAID_MAP_ALL *)
 			fusion->ld_map[(instance->map_id & 1)];
 		pFwRaidMap = &fw_map_old->raidMap;
 
 #if VD_EXT_DEBUG
-		for (i = 0; i < pFwRaidMap->ldCount; i++) {
+		for (i = 0; i < le16_to_cpu(pFwRaidMap->ldCount); i++) {
 			dev_dbg(&instance->pdev->dev, "(%d) :Index 0x%x "
 				"Target Id 0x%x Seq Num 0x%x Size 0/%llx\n",
 				instance->unique_id, i,
@@ -204,12 +205,12 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 
 		memset(drv_map, 0, fusion->drv_map_sz);
 		pDrvRaidMap->totalSize = pFwRaidMap->totalSize;
-		pDrvRaidMap->ldCount = pFwRaidMap->ldCount;
+		pDrvRaidMap->ldCount = (__le16)pFwRaidMap->ldCount;
 		pDrvRaidMap->fpPdIoTimeoutSec = pFwRaidMap->fpPdIoTimeoutSec;
 		for (i = 0; i < MAX_RAIDMAP_LOGICAL_DRIVES + MAX_RAIDMAP_VIEWS; i++)
 			pDrvRaidMap->ldTgtIdToLd[i] =
 				(u8)pFwRaidMap->ldTgtIdToLd[i];
-		for (i = 0; i < pDrvRaidMap->ldCount; i++) {
+		for (i = 0; i < le16_to_cpu(pDrvRaidMap->ldCount); i++) {
 			pDrvRaidMap->ldSpanMap[i] = pFwRaidMap->ldSpanMap[i];
 #if VD_EXT_DEBUG
 			dev_dbg(&instance->pdev->dev,
@@ -270,7 +271,7 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance)
 	else
 		expected_size =
 			(sizeof(struct MR_FW_RAID_MAP) - sizeof(struct MR_LD_SPAN_MAP) +
-			(sizeof(struct MR_LD_SPAN_MAP) * le32_to_cpu(pDrvRaidMap->ldCount)));
+			(sizeof(struct MR_LD_SPAN_MAP) * le16_to_cpu(pDrvRaidMap->ldCount)));
 
 	if (le32_to_cpu(pDrvRaidMap->totalSize) != expected_size) {
 		dev_err(&instance->pdev->dev, "map info structure size 0x%x is not matching with ld count\n",
@@ -286,7 +287,7 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance)
 
 	mr_update_load_balance_params(drv_map, lbInfo);
 
-	num_lds = le32_to_cpu(drv_map->raidMap.ldCount);
+	num_lds = le16_to_cpu(drv_map->raidMap.ldCount);
 
 	/*Convert Raid capability values to CPU arch */
 	for (ldCount = 0; ldCount < num_lds; ldCount++) {
@@ -459,7 +460,7 @@ u32 mr_spanset_get_span_block(struct megasas_instance *instance,
 				quad = &map->raidMap.ldSpanMap[ld].
 					spanBlock[span].
 					block_span_info.quad[info];
-				if (le32_to_cpu(quad->diff == 0))
+				if (le32_to_cpu(quad->diff) == 0)
 					return SPAN_INVALID;
 				if (le64_to_cpu(quad->logStart) <= row  &&
 					row <= le64_to_cpu(quad->logEnd)  &&
@@ -522,7 +523,7 @@ static u64  get_row_from_strip(struct megasas_instance *instance,
 				span_set->span_row_data_width) * span_set->diff;
 		for (span = 0, span_offset = 0; span < raid->spanDepth; span++)
 			if (le32_to_cpu(map->raidMap.ldSpanMap[ld].spanBlock[span].
-				block_span_info.noElements >= info+1)) {
+				block_span_info.noElements) >= info+1) {
 				if (strip_offset >=
 					span_set->strip_offset[span])
 					span_offset++;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 4e259ed..71557f6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -882,7 +882,7 @@ megasas_sync_map_info(struct megasas_instance *instance)
 
 	map = fusion->ld_drv_map[instance->map_id & 1];
 
-	num_lds = le32_to_cpu(map->raidMap.ldCount);
+	num_lds = le16_to_cpu(map->raidMap.ldCount);
 
 	dcmd = &cmd->frame->dcmd;
 
@@ -1137,9 +1137,10 @@ megasas_fire_cmd_fusion(struct megasas_instance *instance,
 			struct megasas_register_set __iomem *regs)
 {
 #if defined(writeq) && defined(CONFIG_64BIT)
-	u64 req_data = (((u64)req_desc_hi << 32) | (u32)req_desc_lo);
+	u64 req_data = (((u64)le32_to_cpu(req_desc_hi) << 32) |
+			le32_to_cpu(req_desc_lo));
 
-	writeq(le64_to_cpu(req_data), &(regs)->inbound_low_queue_port);
+	writeq(req_data, &(regs)->inbound_low_queue_port);
 #else
 	unsigned long flags;
 
@@ -1337,7 +1338,7 @@ megasas_set_pd_lba(struct MPI2_RAID_SCSI_IO_REQUEST *io_request, u8 cdb_len,
 		/* Logical block reference tag */
 		io_request->CDB.EEDP32.PrimaryReferenceTag =
 			cpu_to_be32(ref_tag);
-		io_request->CDB.EEDP32.PrimaryApplicationTagMask = 0xffff;
+		io_request->CDB.EEDP32.PrimaryApplicationTagMask = cpu_to_be16(0xffff);
 		io_request->IoFlags = cpu_to_le16(32); /* Specify 32-byte cdb */
 
 		/* Transfer length */
@@ -1733,7 +1734,7 @@ megasas_build_dcdb_fusion(struct megasas_instance *instance,
 
 		/* set RAID context values */
 		pRAID_Context->regLockFlags     = REGION_TYPE_SHARED_READ;
-		pRAID_Context->timeoutValue     = raid->fpIoTimeoutForLd;
+		pRAID_Context->timeoutValue     = cpu_to_le16(raid->fpIoTimeoutForLd);
 		pRAID_Context->VirtualDiskTgtId = cpu_to_le16(device_id);
 		pRAID_Context->regLockRowLBA    = 0;
 		pRAID_Context->regLockLength    = 0;
@@ -2218,7 +2219,7 @@ build_mpt_mfi_pass_thru(struct megasas_instance *instance,
 	 * megasas_complete_cmd
 	 */
 
-	if (frame_hdr->flags & MFI_FRAME_DONT_POST_IN_REPLY_QUEUE)
+	if (frame_hdr->flags & cpu_to_le16(MFI_FRAME_DONT_POST_IN_REPLY_QUEUE))
 		cmd->flags = MFI_FRAME_DONT_POST_IN_REPLY_QUEUE;
 
 	fusion = instance->ctrl_context;
-- 
1.7.1
