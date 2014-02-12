From: <Sumit.Saxena@lsi.com>
Subject: [PATCH 2/4] megaraid_sas : Big endian code related fixes
Date: Wed, 12 Feb 2014 23:37:46 +0530
Message-ID: <201402121237.s1CCbUt6006995@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:31663
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751435AbaBLMh6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 07:37:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, kashyap.desai@lsi.com, aradford@gmail.com

Few big endian code related fixes.

Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 34452ea..a80e13e 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1347,9 +1347,15 @@ struct megasas_cmd;
 union megasas_evt_class_locale {
 
 	struct {
+#ifndef __BIG_ENDIAN_BITFIELD
 		u16 locale;
 		u8 reserved;
 		s8 class;
+#else
+		s8 class;
+		u8 reserved;
+		u16 locale;
+#endif
 	} __attribute__ ((packed)) members;
 
 	u32 word;
@@ -1728,7 +1734,7 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 		    struct IO_REQUEST_INFO *io_info,
 		    struct RAID_CONTEXT *pRAID_Context,
 		    struct MR_FW_RAID_MAP_ALL *map, u8 **raidLUN);
-u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_FW_RAID_MAP_ALL *map);
+u8 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_FW_RAID_MAP_ALL *map);
 struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
 u16 MR_ArPdGet(u32 ar, u32 arm, struct MR_FW_RAID_MAP_ALL *map);
 u16 MR_LdSpanArrayGet(u32 ld, u32 span, struct MR_FW_RAID_MAP_ALL *map);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index e24b6eb..2f3bd55 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -143,12 +143,12 @@ u16 MR_PdDevHandleGet(u32 pd, struct MR_FW_RAID_MAP_ALL *map)
 
 u16 MR_GetLDTgtId(u32 ld, struct MR_FW_RAID_MAP_ALL *map)
 {
-	return map->raidMap.ldSpanMap[ld].ldRaid.targetId;
+	return le16_to_cpu(map->raidMap.ldSpanMap[ld].ldRaid.targetId);
 }
 
-u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_FW_RAID_MAP_ALL *map)
+u8 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_FW_RAID_MAP_ALL *map)
 {
-	return le16_to_cpu(map->raidMap.ldTgtIdToLd[ldTgtId]);
+	return map->raidMap.ldTgtIdToLd[ldTgtId];
 }
 
 static struct MR_LD_SPAN *MR_LdSpanPtrGet(u32 ld, u32 span,
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2d292de..0de0e63 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1604,8 +1604,8 @@ megasas_build_dcdb_fusion(struct megasas_instance *instance,
 			MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT;
 		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
 			(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
-			io_request->IoFlags |=
-				MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH;
+			io_request->IoFlags |= cpu_to_le16(
+				MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH);
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY <<
 			 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
@@ -2422,7 +2422,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost)
 					instance->
 					cmd_list[cmd_fusion->sync_cmd_idx];
 					if (cmd_mfi->frame->dcmd.opcode ==
-					    MR_DCMD_LD_MAP_GET_INFO) {
+					    cpu_to_le32(MR_DCMD_LD_MAP_GET_INFO)) {
 						megasas_return_cmd(instance,
 								   cmd_mfi);
 						megasas_return_cmd_fusion(
