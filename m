From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH 06/11] megaraid_sas: Dynamic Raid Map Changes for SAS3.5 Generic Megaraid Controllers
Date: Thu,  1 Dec 2016 14:10:40 -0500
Message-ID: <1480619445-45073-7-git-send-email-sasikumar.pc@broadcom.com>
References: <1480619445-45073-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480619445-45073-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com, sasikumar.pc@broadcom.com
List-Id: linux-scsi@vger.kernel.org

From: root <sasikumar.pc@broadcom.com>

SAS3.5 Generic Megaraid Controllers FW will support new dynamic RaidMap to have different
sizes for different number of supported VDs.

This patch is depending on patch 5

Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |   7 +
 drivers/scsi/megaraid/megaraid_sas_base.c   |  57 ++++--
 drivers/scsi/megaraid/megaraid_sas_fp.c     | 278 +++++++++++++++++++++++++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 148 ++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 177 +++++++++++++++++-
 5 files changed, 602 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 9263ba3..2da47b9 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1437,6 +1437,12 @@ enum FW_BOOT_CONTEXT {
 #define MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT    14
 #define MR_MAX_MSIX_REG_ARRAY                   16
 #define MR_RDPQ_MODE_OFFSET			0X00800000
+
+#define MR_MAX_RAID_MAP_SIZE_OFFSET_SHIFT	16
+#define MR_MAX_RAID_MAP_SIZE_MASK		0x1FF
+#define MR_MIN_MAP_SIZE				0x10000
+/* 64k */
+
 #define MR_CAN_HANDLE_SYNC_CACHE_OFFSET		0X01000000
 
 /*
@@ -2155,6 +2161,7 @@ struct megasas_instance {
 	bool fw_sync_cache_support;
 	bool is_ventura;
 	bool msix_combined;
+	u16 maxRaidMapSize;
 };
 struct MR_LD_VF_MAP {
 	u32 size;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 86f25d5..b74609c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4427,8 +4427,7 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 static void megasas_update_ext_vd_details(struct megasas_instance *instance)
 {
 	struct fusion_context *fusion;
-	u32 old_map_sz;
-	u32 new_map_sz;
+	u32 ventura_map_sz = 0;
 
 	fusion = instance->ctrl_context;
 	/* For MFI based controllers return dummy success */
@@ -4458,21 +4457,37 @@ static void megasas_update_ext_vd_details(struct megasas_instance *instance)
 		instance->supportmax256vd ? "Extended VD(240 VD)firmware" :
 		"Legacy(64 VD) firmware");
 
-	old_map_sz = sizeof(struct MR_FW_RAID_MAP) +
-				(sizeof(struct MR_LD_SPAN_MAP) *
-				(instance->fw_supported_vd_count - 1));
-	new_map_sz = sizeof(struct MR_FW_RAID_MAP_EXT);
-	fusion->drv_map_sz = sizeof(struct MR_DRV_RAID_MAP) +
-				(sizeof(struct MR_LD_SPAN_MAP) *
-				(instance->drv_supported_vd_count - 1));
-
-	fusion->max_map_sz = max(old_map_sz, new_map_sz);
+	if (instance->maxRaidMapSize) {
+		ventura_map_sz = instance->maxRaidMapSize *
+						MR_MIN_MAP_SIZE; /* 64k */
+		fusion->current_map_sz = ventura_map_sz;
+		fusion->max_map_sz = ventura_map_sz;
+	} else {
+		fusion->old_map_sz =  sizeof(struct MR_FW_RAID_MAP) +
+					(sizeof(struct MR_LD_SPAN_MAP) *
+					(instance->fw_supported_vd_count - 1));
+		fusion->new_map_sz =  sizeof(struct MR_FW_RAID_MAP_EXT);
 
+		fusion->max_map_sz = max(fusion->old_map_sz, fusion->new_map_sz);
 
-	if (instance->supportmax256vd)
-		fusion->current_map_sz = new_map_sz;
-	else
-		fusion->current_map_sz = old_map_sz;
+		if (instance->supportmax256vd)
+			fusion->current_map_sz = fusion->new_map_sz;
+		else
+			fusion->current_map_sz = fusion->old_map_sz;
+	}
+	/* irrespective of FW raid maps, driver raid map is constant */
+	fusion->drv_map_sz = sizeof(struct MR_DRV_RAID_MAP_ALL);
+#if VD_EXT_DEBUG
+	dev_info(&instance->pdev->dev, "instance->maxRaidMapSize 0x%x \n ",
+			instance->maxRaidMapSize);
+	dev_info(&instance->pdev->dev,
+				"new_map_sz = 0x%x, old_map_sz = 0x%x, "
+				"ventura_map_sz = 0x%x, current_map_sz = 0x%x "
+				"fusion->drv_map_sz =0x%x, size of driver raid map 0x%lx\n",
+				fusion->new_map_sz, fusion->old_map_sz,
+				ventura_map_sz, fusion->current_map_sz,
+				fusion->drv_map_sz, sizeof(struct MR_DRV_RAID_MAP_ALL));
+#endif
 }
 
 /**
@@ -5013,7 +5028,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 {
 	u32 max_sectors_1;
 	u32 max_sectors_2;
-	u32 tmp_sectors, msix_enable, scratch_pad_2;
+	u32 tmp_sectors, msix_enable, scratch_pad_2, scratch_pad_3;
 	resource_size_t base_addr;
 	struct megasas_register_set __iomem *reg_set;
 	struct megasas_ctrl_info *ctrl_info = NULL;
@@ -5089,7 +5104,15 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			goto fail_ready_state;
 	}
 
-
+	if (instance->is_ventura) {
+		scratch_pad_3 = readl(&instance->reg_set->outbound_scratch_pad_3);
+#if VD_EXT_DEBUG
+		dev_info(&instance->pdev->dev, "scratch_pad3 0x%x\n", scratch_pad_3);
+#endif
+		instance->maxRaidMapSize = ((scratch_pad_3 >>
+						MR_MAX_RAID_MAP_SIZE_OFFSET_SHIFT) &
+						MR_MAX_RAID_MAP_SIZE_MASK);
+	}
 
 	/* Check if MSI-X is supported while in ready state */
 	msix_enable = (instance->instancet->read_fw_status_reg(reg_set) &
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 5922d15..546a543 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -179,18 +179,208 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 	struct fusion_context *fusion = instance->ctrl_context;
 	struct MR_FW_RAID_MAP_ALL     *fw_map_old    = NULL;
 	struct MR_FW_RAID_MAP         *pFwRaidMap    = NULL;
-	int i;
+	int i, j;
 	u16 ld_count;
+	struct MR_FW_RAID_MAP_DYNAMIC *fw_map_dyn;
+	struct MR_FW_RAID_MAP_EXT *fw_map_ext;
+	MR_RAID_MAP_DESC_TABLE *desc_table;
 
 
 	struct MR_DRV_RAID_MAP_ALL *drv_map =
 			fusion->ld_drv_map[(instance->map_id & 1)];
 	struct MR_DRV_RAID_MAP *pDrvRaidMap = &drv_map->raidMap;
+	void *raid_map_data = NULL;
+
+	memset(drv_map, 0, fusion->drv_map_sz);
+	memset(pDrvRaidMap->ldTgtIdToLd, 0xff, (sizeof(u16) * MAX_LOGICAL_DRIVES_DYN));
+
+	if (instance->maxRaidMapSize) {
+		fw_map_dyn = fusion->ld_map[(instance->map_id & 1)];
+#if VD_EXT_DEBUG
+			dev_dbg(&instance->pdev->dev,
+				" raidMapSize 0x%x fw_map_dyn->descTableOffset 0x%x, "
+				" descTableSize 0x%x descTableNumElements 0x%x\n",
+					le32_to_cpu(fw_map_dyn->raidMapSize),
+					le32_to_cpu(fw_map_dyn->descTableOffset),
+					le32_to_cpu(fw_map_dyn->descTableSize),
+					le32_to_cpu(fw_map_dyn->descTableNumElements));
+		dev_dbg(&instance->pdev->dev,
+				"drv map %p ldCount %d\n", drv_map, fw_map_dyn->ldCount);
+#endif
+		desc_table =
+		(MR_RAID_MAP_DESC_TABLE *)((void *)fw_map_dyn +
+		le32_to_cpu(fw_map_dyn->descTableOffset));
+		if (desc_table != fw_map_dyn->raidMapDescTable) {
+			dev_err(&instance->pdev->dev,
+				"offsets of desc table are not matching returning "
+				" FW raid map has been changed: desc %p original %p\n",
+				desc_table, fw_map_dyn->raidMapDescTable);
+		}
+		ld_count = (u16)le16_to_cpu(fw_map_dyn->ldCount);
+		pDrvRaidMap->ldCount = (__le16)cpu_to_le16(ld_count);
+		pDrvRaidMap->fpPdIoTimeoutSec = fw_map_dyn->fpPdIoTimeoutSec;
+		pDrvRaidMap->totalSize = sizeof(struct MR_DRV_RAID_MAP_ALL);
+		/* point to actual data starting point*/
+		raid_map_data = (void *)fw_map_dyn +
+						le32_to_cpu(fw_map_dyn->descTableOffset) +
+						le32_to_cpu(fw_map_dyn->descTableSize);
+
+		for (i = 0; i < le32_to_cpu(fw_map_dyn->descTableNumElements); ++i) {
+			if (!desc_table) {
+				dev_err(&instance->pdev->dev,
+					"desc table is null, coming out %p \n", desc_table);
+				return;
+			}
+#if VD_EXT_DEBUG
+			dev_err(&instance->pdev->dev,
+				"desc table %p \n", desc_table);
+			dev_err(&instance->pdev->dev,
+					"raidmap type %d, raidmapOffset 0x%x, "
+					" raid map number of elements 0%x, raidmapsize 0x%x\n",
+				desc_table->raidMapDescType,
+				desc_table->raidMapDescOffset,
+				desc_table->raidMapDescElements,
+				desc_table->raidMapDescBufferSize);
+#endif
+			switch (le32_to_cpu(desc_table->raidMapDescType)) {
+			case RAID_MAP_DESC_TYPE_DEVHDL_INFO:
+				fw_map_dyn->devHndlInfo = (struct MR_DEV_HANDLE_INFO *)
+							      (raid_map_data +
+								le32_to_cpu(desc_table->raidMapDescOffset));
+#if VD_EXT_DEBUG
+				dev_err(&instance->pdev->dev,
+				"devHndlInfo  address %p\n",
+				 fw_map_dyn->devHndlInfo);
+#endif
+				memcpy(pDrvRaidMap->devHndlInfo, fw_map_dyn->devHndlInfo,
+					sizeof(struct MR_DEV_HANDLE_INFO) *
+							le32_to_cpu(desc_table->raidMapDescElements));
+			break;
+			case RAID_MAP_DESC_TYPE_TGTID_INFO:
+					fw_map_dyn->ldTgtIdToLd = (u16 *) (raid_map_data +
+								le32_to_cpu(desc_table->raidMapDescOffset));
+#if VD_EXT_DEBUG
+			dev_err(&instance->pdev->dev,
+				"ldTgtIdToLd  address %p\n",
+					fw_map_dyn->ldTgtIdToLd);
+#endif
+			for (j = 0; j < le32_to_cpu(desc_table->raidMapDescElements); j++) {
+				pDrvRaidMap->ldTgtIdToLd[j] = fw_map_dyn->ldTgtIdToLd[j];
+#if VD_EXT_DEBUG
+				dev_err(&instance->pdev->dev,
+					" %d drv ldTgtIdToLd %d\n",
+						j, pDrvRaidMap->ldTgtIdToLd[j]);
+#endif
+			}
+			break;
+			case RAID_MAP_DESC_TYPE_ARRAY_INFO:
+				fw_map_dyn->arMapInfo = (struct MR_ARRAY_INFO *)
+				(raid_map_data + le32_to_cpu(desc_table->raidMapDescOffset));
+#if VD_EXT_DEBUG
+				dev_err(&instance->pdev->dev,
+					"arMapInfo  address %p\n",
+					 fw_map_dyn->arMapInfo);
+#endif
+
+				memcpy(pDrvRaidMap->arMapInfo, fw_map_dyn->arMapInfo,
+					sizeof(struct MR_ARRAY_INFO) *
+								le32_to_cpu(desc_table->raidMapDescElements));
+			break;
+			case RAID_MAP_DESC_TYPE_SPAN_INFO:
+				fw_map_dyn->ldSpanMap = (struct MR_LD_SPAN_MAP *)
+				(raid_map_data + le32_to_cpu(desc_table->raidMapDescOffset));
+				memcpy(pDrvRaidMap->ldSpanMap,
+						fw_map_dyn->ldSpanMap,
+						sizeof(struct MR_LD_SPAN_MAP) *
+						le32_to_cpu(desc_table->raidMapDescElements));
+#if VD_EXT_DEBUG
+				dev_err(&instance->pdev->dev,
+					"ldSpanMap  address %p\n",
+						fw_map_dyn->ldSpanMap);
+				dev_err(&instance->pdev->dev,
+				"MR_LD_SPAN_MAP size 0x%lx\n", sizeof(struct MR_LD_SPAN_MAP));
+				for (j = 0; j < ld_count; j++) {
+					printk("megaraid_sas(%d) : "
+					"fw_map_dyn->ldSpanMap[%d].ldRaid.targetId 0x%x "
+					"fw_map_dyn->ldSpanMap[%d].ldRaid.seqNum 0x%x size 0x%x\n",
+						j, j, fw_map_dyn->ldSpanMap[j].ldRaid.targetId, j,
+						fw_map_dyn->ldSpanMap[j].ldRaid.seqNum,
+						(u32)fw_map_dyn->ldSpanMap[j].ldRaid.rowSize);
+						printk("megaraid_sas(%d) : "
+						"pDrvRaidMap->ldSpanMap[%d].ldRaid.targetId 0x%x "
+						"pDrvRaidMap->ldSpanMap[%d].ldRaid.seqNum 0x%x size 0x%x\n",
+					j, j, pDrvRaidMap->ldSpanMap[j].ldRaid.targetId, j,
+					pDrvRaidMap->ldSpanMap[j].ldRaid.seqNum,
+					(u32)pDrvRaidMap->ldSpanMap[j].ldRaid.rowSize);
+						printk("megaraid_sas(%d) : "
+						"drv raid map all %p raid map %p LD RAID MAP %p/%p\n",
+					instance->unique_id, drv_map, pDrvRaidMap,
+					&fw_map_dyn->ldSpanMap[j].ldRaid,
+						&pDrvRaidMap->ldSpanMap[j].ldRaid);
+				}
+#endif
+			break;
+			default:
+				dev_err(&instance->pdev->dev,
+					"wrong number of desctableElements %d\n",
+								fw_map_dyn->descTableNumElements);
+			}
+			++desc_table;
+		}
+
+	} else if (instance->supportmax256vd) {
+		fw_map_ext = (struct MR_FW_RAID_MAP_EXT *) fusion->ld_map[(instance->map_id & 1)];
+		ld_count = (u16)le16_to_cpu(fw_map_ext->ldCount);
+		if (ld_count > MAX_LOGICAL_DRIVES_EXT) {
+			printk("megaraid_sas: LD count exposed in"
+			" RAID map in not valid\n");
+			return;
+		}
+#if VD_EXT_DEBUG
+		for (i = 0; i < ld_count; i++) {
+			printk("megaraid_sas(%d) : "
+				"Index 0x%x Target Id 0x%x Seq Num 0x%x Size 0/%llx\n",
+				instance->unique_id,
+					i, fw_map_ext->ldSpanMap[i].ldRaid.targetId,
+					fw_map_ext->ldSpanMap[i].ldRaid.seqNum,
+					fw_map_ext->ldSpanMap[i].ldRaid.size);
+		}
+#endif
+
+		pDrvRaidMap->ldCount = (__le16)cpu_to_le16(ld_count);
+		pDrvRaidMap->fpPdIoTimeoutSec = fw_map_ext->fpPdIoTimeoutSec;
+		for (i = 0; i < (MAX_LOGICAL_DRIVES_EXT); i++)
+			pDrvRaidMap->ldTgtIdToLd[i] = (u16)fw_map_ext->ldTgtIdToLd[i];
+
+		memcpy(pDrvRaidMap->ldSpanMap,
+				fw_map_ext->ldSpanMap,
+				sizeof(struct MR_LD_SPAN_MAP) *
+				ld_count);
+#if VD_EXT_DEBUG
+		for (i = 0; i < ld_count; i++) {
+				printk("megaraid_sas(%d) :"
+				" fw_map_ext->ldSpanMap[%d].ldRaid.targetId 0x%x "
+			"fw_map_ext->ldSpanMap[%d].ldRaid.seqNum 0x%x size 0x%x\n",
+			i, i, fw_map_ext->ldSpanMap[i].ldRaid.targetId, i,
+			fw_map_ext->ldSpanMap[i].ldRaid.seqNum,
+			(u32)fw_map_ext->ldSpanMap[i].ldRaid.rowSize);
+				printk("megaraid_sas(%d) :"
+				" pDrvRaidMap->ldSpanMap[%d].ldRaid.targetId 0x%x"
+			"pDrvRaidMap->ldSpanMap[%d].ldRaid.seqNum 0x%x size 0x%x\n", i, i,
+			pDrvRaidMap->ldSpanMap[i].ldRaid.targetId, i,
+			pDrvRaidMap->ldSpanMap[i].ldRaid.seqNum,
+			(u32)pDrvRaidMap->ldSpanMap[i].ldRaid.rowSize);
+				printk("megaraid_sas(%d) :"
+				" drv raid map all %p raid map %p LD RAID MAP %p/%p\n",
+			instance->unique_id, drv_map, pDrvRaidMap,
+			&fw_map_ext->ldSpanMap[i].ldRaid, &pDrvRaidMap->ldSpanMap[i].ldRaid);
+		}
+#endif
+		memcpy(pDrvRaidMap->arMapInfo, fw_map_ext->arMapInfo,
+			sizeof(struct MR_ARRAY_INFO) * MAX_API_ARRAYS_EXT);
+		memcpy(pDrvRaidMap->devHndlInfo, fw_map_ext->devHndlInfo,
+			sizeof(struct MR_DEV_HANDLE_INFO) * MAX_RAIDMAP_PHYSICAL_DEVICES);
 
-	if (instance->supportmax256vd) {
-		memcpy(fusion->ld_drv_map[instance->map_id & 1],
-			fusion->ld_map[instance->map_id & 1],
-			fusion->current_map_sz);
 		/* New Raid map will not set totalSize, so keep expected value
 		 * for legacy code in ValidateMapInfo
 		 */
@@ -213,16 +403,12 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 		}
 #endif
 
-		memset(drv_map, 0, fusion->drv_map_sz);
 		pDrvRaidMap->totalSize = pFwRaidMap->totalSize;
 		pDrvRaidMap->ldCount = (__le16)cpu_to_le16(ld_count);
 		pDrvRaidMap->fpPdIoTimeoutSec = pFwRaidMap->fpPdIoTimeoutSec;
 		for (i = 0; i < MAX_RAIDMAP_LOGICAL_DRIVES + MAX_RAIDMAP_VIEWS; i++)
 			pDrvRaidMap->ldTgtIdToLd[i] =
 				(u8)pFwRaidMap->ldTgtIdToLd[i];
-		for (i = (MAX_RAIDMAP_LOGICAL_DRIVES + MAX_RAIDMAP_VIEWS);
-			i < MAX_LOGICAL_DRIVES_EXT; i++)
-			pDrvRaidMap->ldTgtIdToLd[i] = 0xff;
 		for (i = 0; i < ld_count; i++) {
 			pDrvRaidMap->ldSpanMap[i] = pFwRaidMap->ldSpanMap[i];
 #if VD_EXT_DEBUG
@@ -279,7 +465,9 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance)
 	lbInfo = fusion->load_balance_info;
 	ldSpanInfo = fusion->log_to_span;
 
-	if (instance->supportmax256vd)
+	if (instance->maxRaidMapSize)
+		expected_size = sizeof(struct MR_DRV_RAID_MAP_ALL);
+	else if (instance->supportmax256vd)
 		expected_size = sizeof(struct MR_FW_RAID_MAP_EXT);
 	else
 		expected_size =
@@ -287,8 +475,9 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance)
 			(sizeof(struct MR_LD_SPAN_MAP) * le16_to_cpu(pDrvRaidMap->ldCount)));
 
 	if (le32_to_cpu(pDrvRaidMap->totalSize) != expected_size) {
-		dev_err(&instance->pdev->dev, "map info structure size 0x%x is not matching with ld count\n",
-		       (unsigned int) expected_size);
+		dev_err(&instance->pdev->dev, "megasas: map info structure"
+		" size 0x%x is not matching expected size 0x%x\n",
+			le32_to_cpu(pDrvRaidMap->totalSize), (unsigned int) expected_size);
 		dev_err(&instance->pdev->dev, "megasas: span map %x, pDrvRaidMap->totalSize : %x\n",
 			(unsigned int)sizeof(struct MR_LD_SPAN_MAP),
 			le32_to_cpu(pDrvRaidMap->totalSize));
@@ -796,9 +985,15 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 	}
 
 	*pdBlock += stripRef + le64_to_cpu(MR_LdSpanPtrGet(ld, span, map)->startBlk);
-	pRAID_Context->spanArm = (span << RAID_CTX_SPANARM_SPAN_SHIFT) |
-					physArm;
-	io_info->span_arm = pRAID_Context->spanArm;
+	if (instance->is_ventura) {
+		((RAID_CONTEXT_G35 *) pRAID_Context)->spanArm =
+				(span << RAID_CTX_SPANARM_SPAN_SHIFT) | physArm;
+		io_info->span_arm = (span << RAID_CTX_SPANARM_SPAN_SHIFT) | physArm;
+	} else {
+		pRAID_Context->spanArm =
+			(span << RAID_CTX_SPANARM_SPAN_SHIFT) | physArm;
+		io_info->span_arm = pRAID_Context->spanArm;
+	}
 	return retval;
 }
 
@@ -900,9 +1095,15 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 	}
 
 	*pdBlock += stripRef + le64_to_cpu(MR_LdSpanPtrGet(ld, span, map)->startBlk);
-	pRAID_Context->spanArm = (span << RAID_CTX_SPANARM_SPAN_SHIFT) |
-		physArm;
-	io_info->span_arm = pRAID_Context->spanArm;
+	if (instance->is_ventura) {
+		((RAID_CONTEXT_G35 *) pRAID_Context)->spanArm =
+				(span << RAID_CTX_SPANARM_SPAN_SHIFT) | physArm;
+		io_info->span_arm = (span << RAID_CTX_SPANARM_SPAN_SHIFT) | physArm;
+	} else {
+		pRAID_Context->spanArm =
+			(span << RAID_CTX_SPANARM_SPAN_SHIFT) | physArm;
+		io_info->span_arm = pRAID_Context->spanArm;
+	}
 	return retval;
 }
 
@@ -1113,7 +1314,7 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 	if (fusion->adapter_type == INVADER_SERIES)
 		pRAID_Context->regLockFlags = (isRead) ?
 			raid->regTypeReqOnRead : raid->regTypeReqOnWrite;
-	else
+	else if (!instance->is_ventura)
 		pRAID_Context->regLockFlags = (isRead) ?
 			REGION_TYPE_SHARED_READ : raid->regTypeReqOnWrite;
 	pRAID_Context->VirtualDiskTgtId = raid->targetId;
@@ -1137,6 +1338,11 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 		/* If IO on an invalid Pd, then FP is not possible.*/
 		if (io_info->devHandle == cpu_to_le16(MR_PD_INVALID))
 			io_info->fpOkForIo = FALSE;
+		/* if FP possible, set the SLUD bit in regLockFlags for ventura */
+		else if ((instance->is_ventura) &&
+			!isRead && (raid->writeMode == MR_RL_WRITE_BACK_MODE) &&
+				raid->capability.fpCacheBypassCapable)
+		 ((RAID_CONTEXT_G35 *) pRAID_Context)->routingFlags.bits.sld = 1;
 		/* set raid 1/10 fast path write capable bit in io_info */
 		if (io_info->fpOkForIo &&
 		    (io_info->r1_alt_dev_handle != MR_PD_INVALID) &&
@@ -1316,6 +1522,7 @@ u8 megasas_get_best_arm_pd(struct megasas_instance *instance,
 	struct fusion_context *fusion;
 	struct MR_LD_RAID  *raid;
 	struct MR_DRV_RAID_MAP_ALL *drv_map;
+	u16	pd1_devHandle;
 	u16     pend0, pend1, ld;
 	u64     diff0, diff1;
 	u8      bestArm, pd0, pd1, span, arm;
@@ -1341,23 +1548,34 @@ u8 megasas_get_best_arm_pd(struct megasas_instance *instance,
 	pd1 = MR_ArPdGet(arRef, (arm + 1) >= span_row_size ?
 		(arm + 1 - span_row_size) : arm + 1, drv_map);
 
-	/* get the pending cmds for the data and mirror arms */
-	pend0 = atomic_read(&lbInfo->scsi_pending_cmds[pd0]);
-	pend1 = atomic_read(&lbInfo->scsi_pending_cmds[pd1]);
+	/* Get PD1 Dev Handle */
 
-	/* Determine the disk whose head is nearer to the req. block */
-	diff0 = ABS_DIFF(block, lbInfo->last_accessed_block[pd0]);
-	diff1 = ABS_DIFF(block, lbInfo->last_accessed_block[pd1]);
-	bestArm = (diff0 <= diff1 ? arm : arm ^ 1);
+	pd1_devHandle = MR_PdDevHandleGet(pd1, drv_map);
 
-	if ((bestArm == arm && pend0 > pend1 + lb_pending_cmds)  ||
+	if (pd1_devHandle == MR_PD_INVALID) {
+		bestArm = arm;
+	} else {
+		/* get the pending cmds for the data and mirror arms */
+		pend0 = atomic_read(&lbInfo->scsi_pending_cmds[pd0]);
+		pend1 = atomic_read(&lbInfo->scsi_pending_cmds[pd1]);
+
+		/* Determine the disk whose head is nearer to the req. block */
+		diff0 = ABS_DIFF(block, lbInfo->last_accessed_block[pd0]);
+		diff1 = ABS_DIFF(block, lbInfo->last_accessed_block[pd1]);
+		/*bestArm = diff0<=diff1 ? arm : arm ^ 1;*/
+		bestArm = (diff0 <= diff1 ? arm : arm ^ 1);
+
+		/*Make balance count from 16 to 4 to keep driver in sync with Firmware*/
+		if ((bestArm == arm && pend0 > pend1 + lb_pending_cmds)  ||
 			(bestArm != arm && pend1 > pend0 + lb_pending_cmds))
 		bestArm ^= 1;
 
-	/* Update the last accessed block on the correct pd */
-	io_info->pd_after_lb = (bestArm == arm) ? pd0 : pd1;
+		/* Update the last accessed block on the correct pd */
+		io_info->span_arm = (span << RAID_CTX_SPANARM_SPAN_SHIFT) | bestArm;
+		io_info->pd_after_lb = (bestArm == arm) ? pd0:pd1;
+	}
+
 	lbInfo->last_accessed_block[io_info->pd_after_lb] = block + count - 1;
-	io_info->span_arm = (span << RAID_CTX_SPANARM_SPAN_SHIFT) | bestArm;
 #if SPAN_DEBUG
 	if (arm != bestArm)
 		dev_dbg(&instance->pdev->dev, "LSI Debug R1 Load balance "
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 116f300..e0b188d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1825,7 +1825,7 @@ static void megasas_stream_detect(struct megasas_instance *instance,
 			  struct megasas_cmd_fusion *cmd)
 {
 	u8 fp_possible;
-	u32 start_lba_lo, start_lba_hi, device_id, datalength = 0;
+	u32 start_lba_lo, start_lba_hi, device_id, datalength = 0, ld;
 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
 	struct IO_REQUEST_INFO io_info;
@@ -1833,6 +1833,8 @@ static void megasas_stream_detect(struct megasas_instance *instance,
 	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
 	u8 *raidLUN;
 	unsigned long spinlock_flags;
+	RAID_CONTEXT_UNION *pRAID_Context;
+	struct MR_LD_RAID *raid;
 
 	device_id = MEGASAS_DEV_INDEX(scp);
 
@@ -1911,6 +1913,8 @@ static void megasas_stream_detect(struct megasas_instance *instance,
 		io_info.isRead = 1;
 
 	local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
+	ld = MR_TargetIdToLdGet(device_id, local_map_ptr);
+	raid = MR_LdRaidGet(ld, local_map_ptr);
 
 	if ((MR_TargetIdToLdGet(device_id, local_map_ptr) >=
 		instance->fw_supported_vd_count) || (!fusion->fast_path_io)) {
@@ -1941,6 +1945,8 @@ static void megasas_stream_detect(struct megasas_instance *instance,
 			fp_possible = false;
 	}
 
+	pRAID_Context = &io_request->RaidContext;
+
 	if (fp_possible) {
 		megasas_set_pd_lba(io_request, scp->cmd_len, &io_info, scp,
 				   local_map_ptr, start_lba_lo);
@@ -1960,6 +1966,12 @@ static void megasas_stream_detect(struct megasas_instance *instance,
 			io_request->RaidContext.raid_context.regLockFlags |=
 			  (MR_RL_FLAGS_GRANT_DESTINATION_CUDA |
 			   MR_RL_FLAGS_SEQ_NUM_ENABLE);
+		} else if (instance->is_ventura) {
+			io_request->RaidContext.raid_context_g35.Type = MPI2_TYPE_CUDA;
+			io_request->RaidContext.raid_context_g35.nseg = 0x1;
+			io_request->RaidContext.raid_context_g35.routingFlags.bits.sqn = 1;
+			io_request->IoFlags |=
+				cpu_to_le16(MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH);
 		}
 		if ((fusion->load_balance_info[device_id].loadBalanceFlag) &&
 		    (io_info.isRead)) {
@@ -1969,6 +1981,13 @@ static void megasas_stream_detect(struct megasas_instance *instance,
 					&io_info);
 			scp->SCp.Status |= MEGASAS_LOAD_BALANCE_FLAG;
 			cmd->pd_r1_lb = io_info.pd_after_lb;
+			if (instance->is_ventura)
+				io_request->RaidContext.raid_context_g35.spanArm =
+					io_info.span_arm;
+			else
+				io_request->RaidContext.raid_context.spanArm =
+					io_info.span_arm;
+
 		} else
 			scp->SCp.Status &= ~MEGASAS_LOAD_BALANCE_FLAG;
 
@@ -1987,6 +2006,36 @@ static void megasas_stream_detect(struct megasas_instance *instance,
 		io_request->DevHandle = io_info.devHandle;
 		/* populate the LUN field */
 		memcpy(io_request->LUN, raidLUN, 8);
+		if (instance->is_ventura) {
+			if (io_info.isRead) {
+				if ((raid->cpuAffinity.pdRead.cpu0) &&
+							(raid->cpuAffinity.pdRead.cpu1))
+					pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+										MR_RAID_CTX_CPUSEL_FCFS;
+				else if (raid->cpuAffinity.pdRead.cpu1)
+					pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+										MR_RAID_CTX_CPUSEL_1;
+				else
+					pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+										MR_RAID_CTX_CPUSEL_0;
+			} else {
+				if ((raid->cpuAffinity.pdWrite.cpu0) &&
+							(raid->cpuAffinity.pdWrite.cpu1))
+					pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+										MR_RAID_CTX_CPUSEL_FCFS;
+				else if (raid->cpuAffinity.pdWrite.cpu1)
+					pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+										MR_RAID_CTX_CPUSEL_1;
+				else
+					pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+										MR_RAID_CTX_CPUSEL_0;
+				if (pRAID_Context->raid_context_g35.routingFlags.bits.sld) {
+					pRAID_Context->raid_context_g35.RAIDFlags =
+						(MR_RAID_FLAGS_IO_SUB_TYPE_CACHE_BYPASS
+						<< MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT);
+				}
+			}
+		}
 	} else {
 		io_request->RaidContext.raid_context.timeoutValue =
 			cpu_to_le16(local_map_ptr->raidMap.fpPdIoTimeoutSec);
@@ -1996,7 +2045,7 @@ static void megasas_stream_detect(struct megasas_instance *instance,
 		if (fusion->adapter_type == INVADER_SERIES) {
 			if (io_info.do_fp_rlbypass ||
 				(io_request->RaidContext.raid_context.regLockFlags ==
-													REGION_TYPE_UNUSED))
+					REGION_TYPE_UNUSED))
 				cmd->request_desc->SCSIIO.RequestFlags =
 					(MEGASAS_REQ_DESCRIPT_FLAGS_NO_LOCK <<
 					MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
@@ -2005,9 +2054,48 @@ static void megasas_stream_detect(struct megasas_instance *instance,
 				(MR_RL_FLAGS_GRANT_DESTINATION_CPU0 |
 				 MR_RL_FLAGS_SEQ_NUM_ENABLE);
 			io_request->RaidContext.raid_context.nseg = 0x1;
+		} else if (instance->is_ventura) {
+			io_request->RaidContext.raid_context_g35.Type = MPI2_TYPE_CUDA;
+			io_request->RaidContext.raid_context_g35.routingFlags.bits.sqn = 1;
+			io_request->RaidContext.raid_context_g35.nseg = 0x1;
 		}
 		io_request->Function = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
 		io_request->DevHandle = cpu_to_le16(device_id);
+
+		if (instance->is_ventura) {
+			if (io_info.isRead) {
+				if ((raid->cpuAffinity.ldRead.cpu0) &&
+						(raid->cpuAffinity.ldRead.cpu1))
+					pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+										MR_RAID_CTX_CPUSEL_FCFS;
+				else if (raid->cpuAffinity.ldRead.cpu1)
+					pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+										MR_RAID_CTX_CPUSEL_1;
+				else
+					pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+										MR_RAID_CTX_CPUSEL_0;
+			} else {
+				if ((raid->cpuAffinity.ldWrite.cpu0) &&
+							(raid->cpuAffinity.ldWrite.cpu1))
+					pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+										MR_RAID_CTX_CPUSEL_FCFS;
+				else if (raid->cpuAffinity.ldWrite.cpu1)
+					pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+										MR_RAID_CTX_CPUSEL_1;
+				else
+					pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+										MR_RAID_CTX_CPUSEL_0;
+
+				if (io_request->RaidContext.raid_context_g35.streamDetected &&
+					(raid->level == 5) &&
+								(raid->writeMode == MR_RL_WRITE_THROUGH_MODE)) {
+					if (pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel ==
+								MR_RAID_CTX_CPUSEL_FCFS)
+						pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+						MR_RAID_CTX_CPUSEL_0;
+				}
+			}
+		}
 	} /* Not FP */
 }
 
@@ -2072,7 +2160,8 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 
 		/* set RAID context values */
 		pRAID_Context->configSeqNum = raid->seqNum;
-		pRAID_Context->regLockFlags = REGION_TYPE_SHARED_READ;
+		if (!instance->is_ventura)
+			pRAID_Context->regLockFlags = REGION_TYPE_SHARED_READ;
 		pRAID_Context->timeoutValue = cpu_to_le16(raid->fpIoTimeoutForLd);
 
 		/* get the DevHandle for the PD (since this is
@@ -2146,8 +2235,11 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 			cpu_to_le16(device_id + (MAX_PHYSICAL_DEVICES - 1));
 		pRAID_Context->configSeqNum = pd_sync->seq[pd_index].seqNum;
 		io_request->DevHandle = pd_sync->seq[pd_index].devHandle;
-		pRAID_Context->regLockFlags |=
-			(MR_RL_FLAGS_SEQ_NUM_ENABLE|MR_RL_FLAGS_GRANT_DESTINATION_CUDA);
+		if (instance->is_ventura)
+			io_request->RaidContext.raid_context_g35.routingFlags.bits.sqn = 1;
+		else
+			pRAID_Context->regLockFlags |=
+				(MR_RL_FLAGS_SEQ_NUM_ENABLE|MR_RL_FLAGS_GRANT_DESTINATION_CUDA);
 		pRAID_Context->Type = MPI2_TYPE_CUDA;
 		pRAID_Context->nseg = 0x1;
 	} else if (fusion->fast_path_io) {
@@ -2267,11 +2359,15 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 		return 1;
 	}
 
-	/* numSGE store lower 8 bit of sge_count.
-	 * numSGEExt store higher 8 bit of sge_count
-	 */
-	io_request->RaidContext.raid_context.numSGE = sge_count;
-	io_request->RaidContext.raid_context.numSGEExt = (u8)(sge_count >> 8);
+	if (instance->is_ventura)
+		io_request->RaidContext.raid_context_g35.numSGE = sge_count;
+	else {
+		/* numSGE store lower 8 bit of sge_count.
+		 * numSGEExt store higher 8 bit of sge_count
+		 */
+		io_request->RaidContext.raid_context.numSGE = sge_count;
+		io_request->RaidContext.raid_context.numSGEExt = (u8)(sge_count >> 8);
+	}
 
 	io_request->SGLFlags = cpu_to_le16(MPI2_SGE_FLAGS_64_BIT_ADDRESSING);
 
@@ -2320,6 +2416,10 @@ void megasas_fpio_to_ldio(struct megasas_instance *instance,
 	struct megasas_cmd_fusion *cmd, struct scsi_cmnd *scmd)
 {
 	struct fusion_context *fusion;
+	RAID_CONTEXT_UNION *pRAID_Context;
+	struct MR_LD_RAID *raid;
+	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
+	u32 device_id, ld;
 	fusion = instance->ctrl_context;
 	
 	cmd->request_desc->SCSIIO.RequestFlags =
@@ -2343,6 +2443,34 @@ void megasas_fpio_to_ldio(struct megasas_instance *instance,
 	cmd->io_request->Control = 0;
 	cmd->io_request->EEDPBlockSize = 0;
 	cmd->isRaid_1_fp_write = 0;
+
+	device_id = MEGASAS_DEV_INDEX(cmd->scmd);
+	local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
+	ld = MR_TargetIdToLdGet(device_id, local_map_ptr);
+	raid = MR_LdRaidGet(ld, local_map_ptr);
+	pRAID_Context = &cmd->io_request->RaidContext;
+	if (cmd->scmd->sc_data_direction == PCI_DMA_FROMDEVICE) {
+		if ((raid->cpuAffinity.ldRead.cpu0) && (raid->cpuAffinity.ldRead.cpu1))
+			pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+								MR_RAID_CTX_CPUSEL_FCFS;
+		else if (raid->cpuAffinity.ldRead.cpu1)
+			pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+								MR_RAID_CTX_CPUSEL_1;
+		else
+			pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+								MR_RAID_CTX_CPUSEL_0;
+	} else {
+		if ((raid->cpuAffinity.ldWrite.cpu0) &&
+						(raid->cpuAffinity.ldWrite.cpu1))
+			pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+								MR_RAID_CTX_CPUSEL_FCFS;
+		else if (raid->cpuAffinity.ldWrite.cpu1)
+			pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+								MR_RAID_CTX_CPUSEL_1;
+		else
+			pRAID_Context->raid_context_g35.routingFlags.bits.cpuSel =
+								MR_RAID_CTX_CPUSEL_0;
+	}
 }
 /*megasas_prepate_secondRaid1_IO
  * It prepares the raid 1 second IO
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index aaa4924..8addf0e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -59,6 +59,8 @@
 #define	MR_RL_FLAGS_GRANT_DESTINATION_CPU1	    0x10
 #define	MR_RL_FLAGS_GRANT_DESTINATION_CUDA	    0x80
 #define MR_RL_FLAGS_SEQ_NUM_ENABLE		    0x8
+#define MR_RL_WRITE_THROUGH_MODE		    0x00
+#define MR_RL_WRITE_BACK_MODE			    0x01
 
 /* T10 PI defines */
 #define MR_PROT_INFO_TYPE_CONTROLLER                0x8
@@ -81,6 +83,11 @@
 enum MR_RAID_FLAGS_IO_SUB_TYPE {
 	MR_RAID_FLAGS_IO_SUB_TYPE_NONE = 0,
 	MR_RAID_FLAGS_IO_SUB_TYPE_SYSTEM_PD = 1,
+	MR_RAID_FLAGS_IO_SUB_TYPE_RMW_DATA     = 2,
+	MR_RAID_FLAGS_IO_SUB_TYPE_RMW_P        = 3,
+	MR_RAID_FLAGS_IO_SUB_TYPE_RMW_Q        = 4,
+	MR_RAID_FLAGS_IO_SUB_TYPE_CACHE_BYPASS = 6,
+	MR_RAID_FLAGS_IO_SUB_TYPE_LDIO_BW_LIMIT = 7
 };
 
 /*
@@ -677,14 +684,17 @@ struct MPI2_IOC_INIT_REQUEST {
 #define MAX_RAIDMAP_ROW_SIZE (MAX_ROW_SIZE)
 #define MAX_LOGICAL_DRIVES 64
 #define MAX_LOGICAL_DRIVES_EXT 256
+#define MAX_LOGICAL_DRIVES_DYN 512
 #define MAX_RAIDMAP_LOGICAL_DRIVES (MAX_LOGICAL_DRIVES)
 #define MAX_RAIDMAP_VIEWS (MAX_LOGICAL_DRIVES)
 #define MAX_ARRAYS 128
 #define MAX_RAIDMAP_ARRAYS (MAX_ARRAYS)
 #define MAX_ARRAYS_EXT	256
 #define MAX_API_ARRAYS_EXT (MAX_ARRAYS_EXT)
+#define MAX_API_ARRAYS_DYN 512
 #define MAX_PHYSICAL_DEVICES 256
 #define MAX_RAIDMAP_PHYSICAL_DEVICES (MAX_PHYSICAL_DEVICES)
+#define MAX_RAIDMAP_PHYSICAL_DEVICES_DYN 512
 #define MR_DCMD_LD_MAP_GET_INFO             0x0300e101
 #define MR_DCMD_SYSTEM_PD_MAP_GET_INFO      0x0200e102
 #define MR_DCMD_CTRL_SHARED_HOST_MEM_ALLOC  0x010e8485   /* SR-IOV HB alloc*/
@@ -731,12 +741,56 @@ struct MR_SPAN_BLOCK_INFO {
 	struct MR_SPAN_INFO block_span_info;
 };
 
+#define MR_RAID_CTX_CPUSEL_0		0
+#define MR_RAID_CTX_CPUSEL_1		1
+#define MR_RAID_CTX_CPUSEL_2		2
+#define MR_RAID_CTX_CPUSEL_3		3
+#define MR_RAID_CTX_CPUSEL_FCFS		0xF
+
+struct MR_CPU_AFFINITY_MASK {
+    union {
+		struct {
+#ifndef MFI_BIG_ENDIAN
+		u8  hwPath:1;
+		u8  cpu0:1;
+		u8  cpu1:1;
+		u8  cpu2:1;
+		u8  cpu3:1;
+		u8  reserved:3;
+#else
+		u8  reserved:3;
+		u8  cpu3:1;
+		u8  cpu2:1;
+		u8  cpu1:1;
+		u8  cpu0:1;
+		u8  hwPath:1;
+#endif
+		};
+		u8 coreMask;
+	};
+};
+
+struct MR_IO_AFFINITY {
+	union {
+		struct {
+			struct MR_CPU_AFFINITY_MASK pdRead;
+			struct MR_CPU_AFFINITY_MASK pdWrite;
+			struct MR_CPU_AFFINITY_MASK ldRead;
+			struct MR_CPU_AFFINITY_MASK ldWrite;
+			};
+		u32 word;
+		};
+	u8 maxCores;    /* Total cores + HW Path in ROC */
+	u8 reserved[3];
+};
+
 struct MR_LD_RAID {
 	struct {
 #if   defined(__BIG_ENDIAN_BITFIELD)
-		u32     reserved4:3;
+		u32     reserved4:2;
 		u32     fpCacheBypassCapable:1;
 		u32     fpRmwCapable:1;
+		u32     disableCoalescing:1;
 		u32     fpBypassRegionLock:1;
 		u32     tmCapable:1;
 		u32	fpNonRWCapable:1;
@@ -764,9 +818,10 @@ struct MR_LD_RAID {
 		u32	fpNonRWCapable:1;
 		u32     tmCapable:1;
 		u32     fpBypassRegionLock:1;
+		u32     disableCoalescing:1;
 		u32     fpRmwCapable:1;
 		u32     fpCacheBypassCapable:1;
-		u32     reserved4:3;
+		u32     reserved4:2;
 #endif
 	} capability;
 	__le32     reserved6;
@@ -793,7 +848,36 @@ struct MR_LD_RAID {
 
 	u8	LUN[8]; /* 0x24 8 byte LUN field used for SCSI IO's */
 	u8	fpIoTimeoutForLd;/*0x2C timeout value used by driver in FP IO*/
-	u8      reserved3[0x80-0x2D]; /* 0x2D */
+	/* Ox2D This LD accept priority boost of this type */
+	u8      ldAcceptPriorityType;
+	u8      reserved2[2];	        /* 0x2E - 0x2F */
+	/* 0x30 - 0x33, Logical block size for the LD */
+	u32     logicalBlockLength;
+	struct {
+#ifndef MFI_BIG_ENDIAN
+	/* 0x34, P_I_EXPONENT from READ CAPACITY 16 */
+	u32  ldPiExp           :4;
+	/* 0x34, LOGICAL BLOCKS PER PHYSICAL
+	*  BLOCK EXPONENT from READ CAPACITY 16 
+	*/
+	u32  ldLogicalBlockExp :4;
+	u32  reserved1:24;           /* 0x34 */
+#else
+	u32  reserved1:24;           /* 0x34 */
+	/* 0x34, LOGICAL BLOCKS PER PHYSICAL
+	*  BLOCK EXPONENT from READ CAPACITY 16 
+	*/
+	u32  ldLogicalBlockExp :4;
+	/* 0x34, P_I_EXPONENT from READ CAPACITY 16 */
+	u32  ldPiExp           :4;
+#endif
+    };                               /* 0x34 - 0x37 */
+	 /* 0x38 - 0x3f, This will determine which
+	 *  core will process LD IO and PD IO. 
+	 */
+    struct MR_IO_AFFINITY cpuAffinity;
+    /* Bit definiations are specified by MR_IO_AFFINITY */
+	u8      reserved3[0x80-0x40];    /* 0x40 - 0x7f */
 };
 
 struct MR_LD_SPAN_MAP {
@@ -851,6 +935,81 @@ struct MR_LD_TARGET_SYNC {
 	__le16 seqNum;
 };
 
+/*
+ * RAID Map descriptor Types.
+ * Each element should uniquely idetify one data structure in the RAID map
+ */
+typedef enum _MR_RAID_MAP_DESC_TYPE {
+	RAID_MAP_DESC_TYPE_DEVHDL_INFO    = 0x0,   /* MR_DEV_HANDLE_INFO data */
+	RAID_MAP_DESC_TYPE_TGTID_INFO     = 0x1,   /* target to Ld num Index map */
+	RAID_MAP_DESC_TYPE_ARRAY_INFO     = 0x2,   /* MR_ARRAY_INFO data */
+	RAID_MAP_DESC_TYPE_SPAN_INFO      = 0x3,   /* MR_LD_SPAN_MAP data */
+	RAID_MAP_DESC_TYPE_COUNT,
+} MR_RAID_MAP_DESC_TYPE;
+
+/*
+ * This table defines the offset, size and num elements  of each descriptor
+ * type in the RAID Map buffer
+ */
+typedef struct _MR_RAID_MAP_DESC_TABLE {
+	u32     raidMapDescType;           /* Raid map descriptor type */
+	u32     raidMapDescOffset;         /* Offset into the RAID map buffer where
+					                   *  descriptor data is saved 
+									   */
+	u32     raidMapDescBufferSize;    /* total size of the descriptor buffer */
+	u32     raidMapDescElements;      /* Number of elements contained in the
+						              *  descriptor buffer 
+									  */
+} MR_RAID_MAP_DESC_TABLE;
+
+/*
+ * Dynamic Raid Map Structure.
+ */
+struct MR_FW_RAID_MAP_DYNAMIC {
+    u32                 raidMapSize;   /* total size of RAID Map structure */
+    u32                 descTableOffset;/* Offset of desc table into RAID map*/
+    u32                 descTableSize;  /* Total Size of desc table */
+	/* Total Number of elements in the desc table */
+    u32                 descTableNumElements;
+    u64			reserved1;
+    u32			reserved2[3];	/*future use */
+	/* timeout value used by driver in FP IOs */
+    u8                  fpPdIoTimeoutSec;
+    u8                  reserved3[3];
+	/* when this seqNum increments, driver needs to release RMW buffers asap */
+    u32                 rmwFPSeqNum;
+    u16                 ldCount;         /* count of lds. */
+    u16                 arCount;         /* count of arrays */
+    u16                 spanCount;       /* count of spans */
+    u16                 reserved4[3];
+
+	/*
+	* The below structure of pointers is only to be used by the driver.
+	* This is added in the ,API to reduce the amount of code changes
+	* needed in the driver to support dynamic RAID map Firmware should
+	* not update these pointers while preparing the raid map
+	*/
+	union {
+		struct {
+			struct MR_DEV_HANDLE_INFO  *devHndlInfo;
+			u16                 *ldTgtIdToLd;
+			struct MR_ARRAY_INFO       *arMapInfo;
+			struct MR_LD_SPAN_MAP      *ldSpanMap;
+		};
+		u64 ptrStructureSize[RAID_MAP_DESC_TYPE_COUNT];
+    };
+
+    /*
+     * RAID Map descriptor table defines the layout of data in the RAID Map.
+	 * The size of the descriptor table itself could change.
+     */
+	 /* Variable Size descriptor Table. */
+    MR_RAID_MAP_DESC_TABLE     raidMapDescTable[RAID_MAP_DESC_TYPE_COUNT];
+	/* Variable Size buffer containing all data */
+    u32                     raidMapDescData[1];
+
+} ; /* Dynamicaly sized RAID MAp structure */
+
 #define IEEE_SGE_FLAGS_ADDR_MASK            (0x03)
 #define IEEE_SGE_FLAGS_SYSTEM_ADDR          (0x00)
 #define IEEE_SGE_FLAGS_IOCDDR_ADDR          (0x01)
@@ -960,9 +1119,9 @@ struct MR_DRV_RAID_MAP {
 	__le16                 spanCount;
 	__le16                 reserve3;
 
-	struct MR_DEV_HANDLE_INFO  devHndlInfo[MAX_RAIDMAP_PHYSICAL_DEVICES];
-	u8                  ldTgtIdToLd[MAX_LOGICAL_DRIVES_EXT];
-	struct MR_ARRAY_INFO       arMapInfo[MAX_API_ARRAYS_EXT];
+	struct MR_DEV_HANDLE_INFO  devHndlInfo[MAX_RAIDMAP_PHYSICAL_DEVICES_DYN];
+	u16                 ldTgtIdToLd[MAX_LOGICAL_DRIVES_DYN];
+	struct MR_ARRAY_INFO       arMapInfo[MAX_API_ARRAYS_DYN];
 	struct MR_LD_SPAN_MAP      ldSpanMap[1];
 
 };
@@ -974,7 +1133,7 @@ struct MR_DRV_RAID_MAP {
 struct MR_DRV_RAID_MAP_ALL {
 
 	struct MR_DRV_RAID_MAP raidMap;
-	struct MR_LD_SPAN_MAP      ldSpanMap[MAX_LOGICAL_DRIVES_EXT - 1];
+	struct MR_LD_SPAN_MAP      ldSpanMap[MAX_LOGICAL_DRIVES_DYN - 1];
 } __packed;
 
 
@@ -1094,7 +1253,7 @@ struct fusion_context {
 	u8	chain_offset_io_request;
 	u8	chain_offset_mfi_pthru;
 
-	struct MR_FW_RAID_MAP_ALL *ld_map[2];
+	struct MR_FW_RAID_MAP_DYNAMIC *ld_map[2];
 	dma_addr_t ld_map_phys[2];
 
 	/*Non dma-able memory. Driver local copy.*/
@@ -1102,6 +1261,8 @@ struct fusion_context {
 
 	u32 max_map_sz;
 	u32 current_map_sz;
+	u32 old_map_sz;
+	u32 new_map_sz;
 	u32 drv_map_sz;
 	u32 drv_map_pages;
 	struct MR_PD_CFG_SEQ_NUM_SYNC	*pd_seq_sync[JBOD_MAPS_COUNT];
-- 
1.8.3.1
