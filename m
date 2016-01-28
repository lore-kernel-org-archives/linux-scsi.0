From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH v2 06/15] megaraid_sas: Fastpath region lock bypass
Date: Thu, 28 Jan 2016 21:04:27 +0530
Message-ID: <1453995276-24955-7-git-send-email-sumit.saxena@avagotech.com>
References: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36734 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967018AbcA1Pfe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 10:35:34 -0500
Received: by mail-pf0-f171.google.com with SMTP id n128so25098249pfn.3
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 07:35:29 -0800 (PST)
In-Reply-To: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com, thenzl@redhat.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

Firmware will fill per LD data to tell driver that particular LD supports Region lock bypass or not. If yes, then 
Driver will send non FP LDIO to region lock bypass FIFO. With this change in driver, firmware will optimize certain
code to improve performance.

There are no changes in this patch from last time sent patch.

Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        | 8 ++++++--
 drivers/scsi/megaraid/megaraid_sas_fp.c     | 2 ++
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 6 ++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 8 +++++---
 4 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 773fc54..01135be 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1528,7 +1528,9 @@ union megasas_sgl_frame {
 typedef union _MFI_CAPABILITIES {
 	struct {
 #if   defined(__BIG_ENDIAN_BITFIELD)
-		u32     reserved:23;
+		u32     reserved:21;
+		u32     support_fp_rlbypass:1;
+		u32     support_vfid_in_ioframe:1;
 		u32     support_ext_io_size:1;
 		u32	support_ext_queue_depth:1;
 		u32     security_protocol_cmds_fw:1;
@@ -1548,7 +1550,9 @@ typedef union _MFI_CAPABILITIES {
 		u32     security_protocol_cmds_fw:1;
 		u32	support_ext_queue_depth:1;
 		u32     support_ext_io_size:1;
-		u32     reserved:23;
+		u32     support_vfid_in_ioframe:1;
+		u32     support_fp_rlbypass:1;
+		u32     reserved:21;
 #endif
 	} mfi_capabilities;
 	__le32		reg;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 741509b..e413113 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -1020,6 +1020,8 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 	/* assume this IO needs the full row - we'll adjust if not true */
 	regSize             = stripSize;
 
+	io_info->do_fp_rlbypass = raid->capability.fpBypassRegionLock;
+
 	/* Check if we can send this I/O via FastPath */
 	if (raid->capability.fpCapable) {
 		if (isRead)
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 4b0c86c..518b488 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -666,6 +666,8 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	if (instance->max_chain_frame_sz > MEGASAS_CHAIN_FRAME_SZ_MIN)
 		drv_ops->mfi_capabilities.support_ext_io_size = 1;
 
+	drv_ops->mfi_capabilities.support_fp_rlbypass = 1;
+
 	/* Convert capability to LE32 */
 	cpu_to_le32s((u32 *)&init_frame->driver_operations.mfi_capabilities);
 
@@ -1710,8 +1712,8 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 			(MEGASAS_REQ_DESCRIPT_FLAGS_LD_IO
 			 << MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
 		if (fusion->adapter_type == INVADER_SERIES) {
-			if (io_request->RaidContext.regLockFlags ==
-			    REGION_TYPE_UNUSED)
+			if (io_info.do_fp_rlbypass ||
+				(io_request->RaidContext.regLockFlags == REGION_TYPE_UNUSED))
 				cmd->request_desc->SCSIIO.RequestFlags =
 					(MEGASAS_REQ_DESCRIPT_FLAGS_NO_LOCK <<
 					MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index a1f1c0b..db0978d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -643,7 +643,8 @@ struct MR_SPAN_BLOCK_INFO {
 struct MR_LD_RAID {
 	struct {
 #if   defined(__BIG_ENDIAN_BITFIELD)
-		u32     reserved4:6;
+		u32     reserved4:5;
+		u32     fpBypassRegionLock:1;
 		u32     tmCapable:1;
 		u32	fpNonRWCapable:1;
 		u32     fpReadAcrossStripe:1;
@@ -667,7 +668,8 @@ struct MR_LD_RAID {
 		u32     fpReadAcrossStripe:1;
 		u32	fpNonRWCapable:1;
 		u32     tmCapable:1;
-		u32     reserved4:6;
+		u32     fpBypassRegionLock:1;
+		u32     reserved4:5;
 #endif
 	} capability;
 	__le32     reserved6;
@@ -737,7 +739,7 @@ struct IO_REQUEST_INFO {
 	u8 fpOkForIo;
 	u8 IoforUnevenSpan;
 	u8 start_span;
-	u8 reserved;
+	u8 do_fp_rlbypass;
 	u64 start_row;
 	u8  span_arm;	/* span[7:5], arm[4:0] */
 	u8  pd_after_lb;
-- 
1.8.3.1

