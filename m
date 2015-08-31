From: sumit.saxena@avagotech.com
Subject: [PATCH v3 01/10] megaraid_sas : Synchronize driver headers with
 firmware APIs
Date: Mon, 31 Aug 2015 17:22:51 +0530
Message-ID: <201508311158.t7VBwK6C031362@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([199.3.246.86]:52693 "EHLO
	sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbbHaLyO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 07:54:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Reviewed-by: Martin Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |   18 ++++++++++++++----
 drivers/scsi/megaraid/megaraid_sas_fusion.h |    3 ++-
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 20c3754..b0d373d 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -973,7 +973,11 @@ struct megasas_ctrl_info {
 
 	struct {
 #if defined(__BIG_ENDIAN_BITFIELD)
-		u32     reserved:12;
+		u32     reserved:8;
+		u32     supportExtendedSSCSize:1;
+		u32     supportDiskCacheSettingForSysPDs:1;
+		u32     supportCPLDUpdate:1;
+		u32     supportTTYLogCompression:1;
 		u32     discardCacheDuringLDDelete:1;
 		u32     supportSecurityonJBOD:1;
 		u32     supportCacheBypassModes:1;
@@ -1013,7 +1017,11 @@ struct megasas_ctrl_info {
 		u32     supportCacheBypassModes:1;
 		u32     supportSecurityonJBOD:1;
 		u32     discardCacheDuringLDDelete:1;
-		u32     reserved:12;
+		u32     supportTTYLogCompression:1;
+		u32     supportCPLDUpdate:1;
+		u32     supportDiskCacheSettingForSysPDs:1;
+		u32     supportExtendedSSCSize:1;
+		u32     reserved:8;
 #endif
 	} adapterOperations3;
 
@@ -1229,7 +1237,8 @@ union megasas_sgl_frame {
 typedef union _MFI_CAPABILITIES {
 	struct {
 #if   defined(__BIG_ENDIAN_BITFIELD)
-		u32     reserved:25;
+		u32     reserved:24;
+		u32	support_ext_queue_depth:1;
 		u32     security_protocol_cmds_fw:1;
 		u32     support_core_affinity:1;
 		u32     support_ndrive_r1_lb:1;
@@ -1245,7 +1254,8 @@ typedef union _MFI_CAPABILITIES {
 		u32     support_ndrive_r1_lb:1;
 		u32     support_core_affinity:1;
 		u32     security_protocol_cmds_fw:1;
-		u32     reserved:25;
+		u32	support_ext_queue_depth:1;
+		u32     reserved:24;
 #endif
 	} mfi_capabilities;
 	__le32		reg;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index ced6dc0..be1be8e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -117,7 +117,8 @@ struct RAID_CONTEXT {
 	u8      numSGE;
 	__le16	configSeqNum;
 	u8      spanArm;
-	u8      resvd2[3];
+	u8      priority;
+	u8      resvd2[2];
 };
 
 #define RAID_CTX_SPANARM_ARM_SHIFT	(0)
-- 
1.7.1

