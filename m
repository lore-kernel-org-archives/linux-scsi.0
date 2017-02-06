From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 36/39] megaraid_sas: Cleanup VD_EXT_DEBUG and SPAN_DEBUG related debug prints
Date: Mon,  6 Feb 2017 02:00:09 -0800
Message-ID: <1486375212-17329-37-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:32805 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751709AbdBFKDO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:03:14 -0500
Received: by mail-pf0-f174.google.com with SMTP id y143so23107184pfb.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:03:08 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |   2 -
 drivers/scsi/megaraid/megaraid_sas_base.c   |  15 --
 drivers/scsi/megaraid/megaraid_sas_fp.c     | 266 +---------------------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   5 -
 4 files changed, 2 insertions(+), 286 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 1a9a283..eca6701 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1403,8 +1403,6 @@ struct megasas_ctrl_info {
 
 #define MEGASAS_FW_BUSY				1
 
-#define VD_EXT_DEBUG 0
-
 /* Driver's internal Logging levels*/
 #define OCR_LOGS    (1 << 0)
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b29cfd3..e282e00 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4598,17 +4598,6 @@ static void megasas_update_ext_vd_details(struct megasas_instance *instance)
 	}
 	/* irrespective of FW raid maps, driver raid map is constant */
 	fusion->drv_map_sz = sizeof(struct MR_DRV_RAID_MAP_ALL);
-
-#if VD_EXT_DEBUG
-	dev_info(&instance->pdev->dev, "instance->max_raid_mapsize 0x%x\n ",
-		instance->max_raid_mapsize);
-	dev_info(&instance->pdev->dev, "new_map_sz = 0x%x, old_map_sz = 0x%x\n",
-		fusion->new_map_sz, fusion->old_map_sz);
-	dev_info(&instance->pdev->dev, "ventura_map_sz = 0x%x, current_map_sz = 0x%x\n",
-		ventura_map_sz, fusion->current_map_sz);
-	dev_info(&instance->pdev->dev, "fusion->drv_map_sz =0x%x, size of driver raid map 0x%lx\n",
-		fusion->drv_map_sz, sizeof(struct MR_DRV_RAID_MAP_ALL));
-#endif
 }
 
 /**
@@ -5212,10 +5201,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (instance->is_ventura) {
 		scratch_pad_3 =
 			readl(&instance->reg_set->outbound_scratch_pad_3);
-#if VD_EXT_DEBUG
-		dev_info(&instance->pdev->dev, "scratch_pad3 0x%x\n",
-			scratch_pad_3);
-#endif
 		instance->max_raid_mapsize = ((scratch_pad_3 >>
 			MR_MAX_RAID_MAP_SIZE_OFFSET_SHIFT) &
 			MR_MAX_RAID_MAP_SIZE_MASK);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index a5517e7..7dc7708 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -77,7 +77,6 @@ MODULE_PARM_DESC(lb_pending_cmds, "Change raid-1 load balancing outstanding "
 #endif
 #define TRUE 1
 
-#define SPAN_DEBUG 0
 #define SPAN_ROW_SIZE(map, ld, index_) (MR_LdSpanPtrGet(ld, index_, map)->spanRowSize)
 #define SPAN_ROW_DATA_SIZE(map_, ld, index_)   (MR_LdSpanPtrGet(ld, index_, map)->spanRowDataSize)
 #define SPAN_INVALID  0xff
@@ -202,16 +201,6 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 
 	if (instance->max_raid_mapsize) {
 		fw_map_dyn = fusion->ld_map[(instance->map_id & 1)];
-#if VD_EXT_DEBUG
-		dev_dbg(&instance->pdev->dev, "raidMapSize 0x%x fw_map_dyn->descTableOffset 0x%x\n",
-			le32_to_cpu(fw_map_dyn->raid_map_size),
-			le32_to_cpu(fw_map_dyn->desc_table_offset));
-		dev_dbg(&instance->pdev->dev, "descTableSize 0x%x descTableNumElements 0x%x\n",
-			le32_to_cpu(fw_map_dyn->desc_table_size),
-			le32_to_cpu(fw_map_dyn->desc_table_num_elements));
-		dev_dbg(&instance->pdev->dev, "drv map %p ldCount %d\n",
-			drv_map, le16_to_cpu(fw_map_dyn->ld_count));
-#endif
 		desc_table =
 		(struct MR_RAID_MAP_DESC_TABLE *)((void *)fw_map_dyn + le32_to_cpu(fw_map_dyn->desc_table_offset));
 		if (desc_table != fw_map_dyn->raid_map_desc_table)
@@ -230,25 +219,10 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 			le32_to_cpu(fw_map_dyn->desc_table_size);
 
 		for (i = 0; i < le32_to_cpu(fw_map_dyn->desc_table_num_elements); ++i) {
-
-#if VD_EXT_DEBUG
-			dev_dbg(&instance->pdev->dev, "desc table %p\n",
-				desc_table);
-			dev_dbg(&instance->pdev->dev, "raidmap type %d, raidmapOffset 0x%x\n",
-				le32_to_cpu(desc_table->raid_map_desc_type),
-				le32_to_cpu(desc_table->raid_map_desc_offset));
-			dev_dbg(&instance->pdev->dev, "raid map number of elements 0%x, raidmapsize 0x%x\n",
-				le32_to_cpu(desc_table->raid_map_desc_elements),
-				le32_to_cpu(desc_table->raid_map_desc_buffer_size));
-#endif
 			switch (le32_to_cpu(desc_table->raid_map_desc_type)) {
 			case RAID_MAP_DESC_TYPE_DEVHDL_INFO:
 				fw_map_dyn->dev_hndl_info =
 				(struct MR_DEV_HANDLE_INFO *)(raid_map_data + le32_to_cpu(desc_table->raid_map_desc_offset));
-#if VD_EXT_DEBUG
-				dev_dbg(&instance->pdev->dev, "devHndlInfo  address %p\n",
-					fw_map_dyn->dev_hndl_info);
-#endif
 				memcpy(pDrvRaidMap->devHndlInfo,
 				fw_map_dyn->dev_hndl_info,
 				sizeof(struct MR_DEV_HANDLE_INFO) *
@@ -258,28 +232,15 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 				fw_map_dyn->ld_tgt_id_to_ld =
 				(u16 *) (raid_map_data +
 				le32_to_cpu(desc_table->raid_map_desc_offset));
-#if VD_EXT_DEBUG
-			dev_dbg(&instance->pdev->dev, "ldTgtIdToLd  address %p\n",
-				fw_map_dyn->ld_tgt_id_to_ld);
-#endif
 			for (j = 0; j < le32_to_cpu(desc_table->raid_map_desc_elements); j++) {
 				pDrvRaidMap->ldTgtIdToLd[j] =
 					le16_to_cpu(fw_map_dyn->ld_tgt_id_to_ld[j]);
-#if VD_EXT_DEBUG
-				dev_dbg(&instance->pdev->dev, " %d drv ldTgtIdToLd %d\n",
-					j, pDrvRaidMap->ldTgtIdToLd[j]);
-#endif
 			}
 			break;
 			case RAID_MAP_DESC_TYPE_ARRAY_INFO:
 				fw_map_dyn->ar_map_info =
 				(struct MR_ARRAY_INFO *)
 				(raid_map_data + le32_to_cpu(desc_table->raid_map_desc_offset));
-#if VD_EXT_DEBUG
-				dev_dbg(&instance->pdev->dev, "arMapInfo  address %p\n",
-					fw_map_dyn->ar_map_info);
-#endif
-
 				memcpy(pDrvRaidMap->arMapInfo,
 				fw_map_dyn->ar_map_info,
 				sizeof(struct MR_ARRAY_INFO) * le32_to_cpu(desc_table->raid_map_desc_elements));
@@ -291,34 +252,6 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 				memcpy(pDrvRaidMap->ldSpanMap,
 				fw_map_dyn->ld_span_map,
 				sizeof(struct MR_LD_SPAN_MAP) * le32_to_cpu(desc_table->raid_map_desc_elements));
-#if VD_EXT_DEBUG
-				dev_dbg(&instance->pdev->dev, "ldSpanMap  address %p\n",
-					fw_map_dyn->ld_span_map);
-				dev_dbg(&instance->pdev->dev, "MR_LD_SPAN_MAP size 0x%lx\n",
-					sizeof(struct MR_LD_SPAN_MAP));
-				for (j = 0; j < ld_count; j++) {
-					dev_dbg(&instance->pdev->dev, "megaraid_sas(%d) : fw_map_dyn->ldSpanMap[%d].ldRaid.targetId 0x%x\n",
-					j, j, fw_map_dyn->ld_span_map[j].ldRaid.targetId);
-					dev_dbg(&instance->pdev->dev, "fw_map_dyn->ldSpanMap[%d].ldRaid.seqNum 0x%x\n",
-					j, fw_map_dyn->ld_span_map[j].ldRaid.seqNum);
-					dev_dbg(&instance->pdev->dev, "fw_map_dyn->ld_span_map[%d].ldRaid.rowSize 0x%x\n",
-					j, (u32)fw_map_dyn->ld_span_map[j].ldRaid.rowSize);
-
-					dev_dbg(&instance->pdev->dev, "megaraid_sas(%d) :pDrvRaidMap->ldSpanMap[%d].ldRaid.targetId 0x%x\n",
-					j, j, pDrvRaidMap->ldSpanMap[j].ldRaid.targetId);
-					dev_dbg(&instance->pdev->dev, "DrvRaidMap->ldSpanMap[%d].ldRaid.seqNum 0x%x\n",
-					j, pDrvRaidMap->ldSpanMap[j].ldRaid.seqNum);
-					dev_dbg(&instance->pdev->dev, "pDrvRaidMap->ldSpanMap[%d].ldRaid.rowSize 0x%x\n",
-					j, (u32)pDrvRaidMap->ldSpanMap[j].ldRaid.rowSize);
-
-					dev_dbg(&instance->pdev->dev, "megaraid_sas(%d) : drv raid map all %p\n",
-					instance->unique_id, drv_map);
-					dev_dbg(&instance->pdev->dev, "raid map %p LD RAID MAP %p/%p\n",
-					pDrvRaidMap,
-					&fw_map_dyn->ld_span_map[j].ldRaid,
-					&pDrvRaidMap->ldSpanMap[j].ldRaid);
-				}
-#endif
 			break;
 			default:
 				dev_dbg(&instance->pdev->dev, "wrong number of desctableElements %d\n",
@@ -335,17 +268,6 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 			dev_dbg(&instance->pdev->dev, "megaraid_sas: LD count exposed in RAID map in not valid\n");
 			return;
 		}
-#if VD_EXT_DEBUG
-		for (i = 0; i < ld_count; i++) {
-			dev_dbg(&instance->pdev->dev, "megaraid_sas(%d) :Index 0x%x\n",
-				instance->unique_id, i);
-			dev_dbg(&instance->pdev->dev, "Target Id 0x%x\n",
-				fw_map_ext->ldSpanMap[i].ldRaid.targetId);
-			dev_dbg(&instance->pdev->dev, "Seq Num 0x%x Size 0/%llx\n",
-				fw_map_ext->ldSpanMap[i].ldRaid.seqNum,
-				fw_map_ext->ldSpanMap[i].ldRaid.size);
-		}
-#endif
 
 		pDrvRaidMap->ldCount = (__le16)cpu_to_le16(ld_count);
 		pDrvRaidMap->fpPdIoTimeoutSec = fw_map_ext->fpPdIoTimeoutSec;
@@ -354,29 +276,6 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 				(u16)fw_map_ext->ldTgtIdToLd[i];
 		memcpy(pDrvRaidMap->ldSpanMap, fw_map_ext->ldSpanMap,
 				sizeof(struct MR_LD_SPAN_MAP) * ld_count);
-#if VD_EXT_DEBUG
-		for (i = 0; i < ld_count; i++) {
-			dev_dbg(&instance->pdev->dev, "megaraid_sas(%d) : fw_map_ext->ldSpanMap[%d].ldRaid.targetId 0x%x\n",
-			i, i, fw_map_ext->ldSpanMap[i].ldRaid.targetId);
-			dev_dbg(&instance->pdev->dev, "fw_map_ext->ldSpanMap[%d].ldRaid.seqNum 0x%x\n",
-			i, fw_map_ext->ldSpanMap[i].ldRaid.seqNum);
-			dev_dbg(&instance->pdev->dev, "fw_map_ext->ldSpanMap[%d].ldRaid.rowSize 0x%x\n",
-			i, (u32)fw_map_ext->ldSpanMap[i].ldRaid.rowSize);
-
-			dev_dbg(&instance->pdev->dev, "megaraid_sas(%d) : pDrvRaidMap->ldSpanMap[%d].ldRaid.targetId 0x%x\n",
-			i, i, pDrvRaidMap->ldSpanMap[i].ldRaid.targetId);
-			dev_dbg(&instance->pdev->dev, "pDrvRaidMap->ldSpanMap[%d].ldRaid.seqNum 0x%x\n",
-			i, pDrvRaidMap->ldSpanMap[i].ldRaid.seqNum);
-			dev_dbg(&instance->pdev->dev, "pDrvRaidMap->ldSpanMap[%d].ldRaid.rowSize 0x%x\n",
-			i, (u32)pDrvRaidMap->ldSpanMap[i].ldRaid.rowSize);
-
-			dev_dbg(&instance->pdev->dev, "megaraid_sas(%d) : drv raid map all %p\n",
-			instance->unique_id, drv_map);
-			dev_dbg(&instance->pdev->dev, "raid map %p LD RAID MAP %p %p\n",
-			pDrvRaidMap, &fw_map_ext->ldSpanMap[i].ldRaid,
-			&pDrvRaidMap->ldSpanMap[i].ldRaid);
-		}
-#endif
 		memcpy(pDrvRaidMap->arMapInfo, fw_map_ext->arMapInfo,
 			sizeof(struct MR_ARRAY_INFO) * MAX_API_ARRAYS_EXT);
 		memcpy(pDrvRaidMap->devHndlInfo, fw_map_ext->devHndlInfo,
@@ -393,18 +292,6 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 			fusion->ld_map[(instance->map_id & 1)];
 		pFwRaidMap = &fw_map_old->raidMap;
 		ld_count = (u16)le32_to_cpu(pFwRaidMap->ldCount);
-
-#if VD_EXT_DEBUG
-		for (i = 0; i < ld_count; i++) {
-			dev_dbg(&instance->pdev->dev, "(%d) :Index 0x%x "
-				"Target Id 0x%x Seq Num 0x%x Size 0/%llx\n",
-				instance->unique_id, i,
-				fw_map_old->raidMap.ldSpanMap[i].ldRaid.targetId,
-				fw_map_old->raidMap.ldSpanMap[i].ldRaid.seqNum,
-				fw_map_old->raidMap.ldSpanMap[i].ldRaid.size);
-		}
-#endif
-
 		pDrvRaidMap->totalSize = pFwRaidMap->totalSize;
 		pDrvRaidMap->ldCount = (__le16)cpu_to_le16(ld_count);
 		pDrvRaidMap->fpPdIoTimeoutSec = pFwRaidMap->fpPdIoTimeoutSec;
@@ -413,26 +300,6 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 				(u8)pFwRaidMap->ldTgtIdToLd[i];
 		for (i = 0; i < ld_count; i++) {
 			pDrvRaidMap->ldSpanMap[i] = pFwRaidMap->ldSpanMap[i];
-#if VD_EXT_DEBUG
-			dev_dbg(&instance->pdev->dev,
-				"pFwRaidMap->ldSpanMap[%d].ldRaid.targetId 0x%x "
-				"pFwRaidMap->ldSpanMap[%d].ldRaid.seqNum 0x%x "
-				"size 0x%x\n", i, i,
-				pFwRaidMap->ldSpanMap[i].ldRaid.targetId,
-				pFwRaidMap->ldSpanMap[i].ldRaid.seqNum,
-				(u32)pFwRaidMap->ldSpanMap[i].ldRaid.rowSize);
-			dev_dbg(&instance->pdev->dev,
-				"pDrvRaidMap->ldSpanMap[%d].ldRaid.targetId 0x%x "
-				"pDrvRaidMap->ldSpanMap[%d].ldRaid.seqNum 0x%x "
-				"size 0x%x\n", i, i,
-				pDrvRaidMap->ldSpanMap[i].ldRaid.targetId,
-				pDrvRaidMap->ldSpanMap[i].ldRaid.seqNum,
-				(u32)pDrvRaidMap->ldSpanMap[i].ldRaid.rowSize);
-			dev_dbg(&instance->pdev->dev, "Driver raid map all %p "
-				"raid map %p LD RAID MAP %p/%p\n", drv_map,
-				pDrvRaidMap, &pFwRaidMap->ldSpanMap[i].ldRaid,
-				&pDrvRaidMap->ldSpanMap[i].ldRaid);
-#endif
 		}
 		memcpy(pDrvRaidMap->arMapInfo, pFwRaidMap->arMapInfo,
 			sizeof(struct MR_ARRAY_INFO) * MAX_RAIDMAP_ARRAYS);
@@ -548,91 +415,6 @@ u32 MR_GetSpanBlock(u32 ld, u64 row, u64 *span_blk,
 /*
 ******************************************************************************
 *
-* Function to print info about span set created in driver from FW raid map
-*
-* Inputs :
-* map    - LD map
-* ldSpanInfo - ldSpanInfo per HBA instance
-*/
-#if SPAN_DEBUG
-static int getSpanInfo(struct MR_DRV_RAID_MAP_ALL *map,
-	PLD_SPAN_INFO ldSpanInfo)
-{
-
-	u8   span;
-	u32    element;
-	struct MR_LD_RAID *raid;
-	LD_SPAN_SET *span_set;
-	struct MR_QUAD_ELEMENT    *quad;
-	int ldCount;
-	u16 ld;
-
-	for (ldCount = 0; ldCount < MAX_LOGICAL_DRIVES_EXT; ldCount++) {
-		ld = MR_TargetIdToLdGet(ldCount, map);
-			if (ld >= (MAX_LOGICAL_DRIVES_EXT - 1))
-				continue;
-		raid = MR_LdRaidGet(ld, map);
-		dev_dbg(&instance->pdev->dev, "LD %x: span_depth=%x\n",
-			ld, raid->spanDepth);
-		for (span = 0; span < raid->spanDepth; span++)
-			dev_dbg(&instance->pdev->dev, "Span=%x,"
-			" number of quads=%x\n", span,
-			le32_to_cpu(map->raidMap.ldSpanMap[ld].spanBlock[span].
-			block_span_info.noElements));
-		for (element = 0; element < MAX_QUAD_DEPTH; element++) {
-			span_set = &(ldSpanInfo[ld].span_set[element]);
-			if (span_set->span_row_data_width == 0)
-				break;
-
-			dev_dbg(&instance->pdev->dev, "Span Set %x:"
-				"width=%x, diff=%x\n", element,
-				(unsigned int)span_set->span_row_data_width,
-				(unsigned int)span_set->diff);
-			dev_dbg(&instance->pdev->dev, "logical LBA"
-				"start=0x%08lx, end=0x%08lx\n",
-				(long unsigned int)span_set->log_start_lba,
-				(long unsigned int)span_set->log_end_lba);
-			dev_dbg(&instance->pdev->dev, "span row start=0x%08lx,"
-				" end=0x%08lx\n",
-				(long unsigned int)span_set->span_row_start,
-				(long unsigned int)span_set->span_row_end);
-			dev_dbg(&instance->pdev->dev, "data row start=0x%08lx,"
-				" end=0x%08lx\n",
-				(long unsigned int)span_set->data_row_start,
-				(long unsigned int)span_set->data_row_end);
-			dev_dbg(&instance->pdev->dev, "data strip start=0x%08lx,"
-				" end=0x%08lx\n",
-				(long unsigned int)span_set->data_strip_start,
-				(long unsigned int)span_set->data_strip_end);
-
-			for (span = 0; span < raid->spanDepth; span++) {
-				if (le32_to_cpu(map->raidMap.ldSpanMap[ld].spanBlock[span].
-					block_span_info.noElements) >=
-					element + 1) {
-					quad = &map->raidMap.ldSpanMap[ld].
-						spanBlock[span].block_span_info.
-						quad[element];
-				dev_dbg(&instance->pdev->dev, "Span=%x,"
-					"Quad=%x, diff=%x\n", span,
-					element, le32_to_cpu(quad->diff));
-				dev_dbg(&instance->pdev->dev,
-					"offset_in_span=0x%08lx\n",
-					(long unsigned int)le64_to_cpu(quad->offsetInSpan));
-				dev_dbg(&instance->pdev->dev,
-					"logical start=0x%08lx, end=0x%08lx\n",
-					(long unsigned int)le64_to_cpu(quad->logStart),
-					(long unsigned int)le64_to_cpu(quad->logEnd));
-				}
-			}
-		}
-	}
-	return 0;
-}
-#endif
-
-/*
-******************************************************************************
-*
 * This routine calculates the Span block for given row using spanset.
 *
 * Inputs :
@@ -743,19 +525,7 @@ static u64  get_row_from_strip(struct megasas_instance *instance,
 				else
 					break;
 			}
-#if SPAN_DEBUG
-		dev_info(&instance->pdev->dev, "Strip 0x%llx,"
-			"span_set_Strip 0x%llx, span_set_Row 0x%llx"
-			"data width 0x%llx span offset 0x%x\n", strip,
-			(unsigned long long)span_set_Strip,
-			(unsigned long long)span_set_Row,
-			(unsigned long long)span_set->span_row_data_width,
-			span_offset);
-		dev_info(&instance->pdev->dev, "For strip 0x%llx"
-			"row is 0x%llx\n", strip,
-			(unsigned long long) span_set->data_row_start +
-			(unsigned long long) span_set_Row + (span_offset - 1));
-#endif
+
 		retval = (span_set->data_row_start + span_set_Row +
 				(span_offset - 1));
 		return retval;
@@ -872,11 +642,7 @@ static u32 get_arm_from_strip(struct megasas_instance *instance,
 				else
 					break;
 			}
-#if SPAN_DEBUG
-		dev_info(&instance->pdev->dev, "get_arm_from_strip:"
-			"for ld=0x%x strip=0x%lx arm is  0x%x\n", ld,
-			(long unsigned int)strip, (strip_offset - span_offset));
-#endif
+
 		retval = (strip_offset - span_offset);
 		return retval;
 	}
@@ -1239,17 +1005,6 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 		}
 		io_info->start_span	= startlba_span;
 		io_info->start_row	= start_row;
-#if SPAN_DEBUG
-		dev_dbg(&instance->pdev->dev, "Check Span number from %s %d"
-			"for row 0x%llx, start strip 0x%llx end strip 0x%llx"
-			" span 0x%x\n", __func__, __LINE__,
-			(unsigned long long)start_row,
-			(unsigned long long)start_strip,
-			(unsigned long long)endStrip, startlba_span);
-		dev_dbg(&instance->pdev->dev, "start_row 0x%llx endRow 0x%llx"
-			"Start span 0x%x\n", (unsigned long long)start_row,
-			(unsigned long long)endRow, startlba_span);
-#endif
 	} else {
 		start_row = mega_div64_32(start_strip, raid->rowDataSize);
 		endRow    = mega_div64_32(endStrip, raid->rowDataSize);
@@ -1383,12 +1138,6 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 				return TRUE;
 		}
 	}
-
-#if SPAN_DEBUG
-	/* Just for testing what arm we get for strip.*/
-	if (io_info->IoforUnevenSpan)
-		get_arm_from_strip(instance, ld, start_strip, map);
-#endif
 	return TRUE;
 }
 
@@ -1502,10 +1251,6 @@ void mr_update_span_set(struct MR_DRV_RAID_MAP_ALL *map,
 			break;
 	    }
 	}
-#if SPAN_DEBUG
-	getSpanInfo(map, ldSpanInfo);
-#endif
-
 }
 
 void mr_update_load_balance_params(struct MR_DRV_RAID_MAP_ALL *drv_map,
@@ -1594,13 +1339,6 @@ u8 megasas_get_best_arm_pd(struct megasas_instance *instance,
 	}
 
 	lbInfo->last_accessed_block[io_info->pd_after_lb] = block + count - 1;
-#if SPAN_DEBUG
-	if (arm != bestArm)
-		dev_dbg(&instance->pdev->dev, "LSI Debug R1 Load balance "
-			"occur - span 0x%x arm 0x%x bestArm 0x%x "
-			"io_info->span_arm 0x%x\n",
-			span, arm, bestArm, io_info->span_arm);
-#endif
 	return io_info->pd_after_lb;
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 65971a9d..0cfc831 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1061,11 +1061,6 @@ megasas_get_ld_map_info(struct megasas_instance *instance)
 
 	memset(ci, 0, fusion->max_map_sz);
 	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
-#if VD_EXT_DEBUG
-	dev_dbg(&instance->pdev->dev,
-		"%s sending MR_DCMD_LD_MAP_GET_INFO with size %d\n",
-		__func__, cpu_to_le32(size_map_info));
-#endif
 	dcmd->cmd = MFI_CMD_DCMD;
 	dcmd->cmd_status = 0xFF;
 	dcmd->sge_count = 1;
-- 
2.8.3
