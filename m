From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH v2 03/15] megaraid_sas: Syncing request flags macro names with firmware
Date: Thu, 28 Jan 2016 21:04:24 +0530
Message-ID: <1453995276-24955-4-git-send-email-sumit.saxena@avagotech.com>
References: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33780 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966489AbcA1PfQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 10:35:16 -0500
Received: by mail-pf0-f179.google.com with SMTP id x125so25507042pfb.0
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 07:35:16 -0800 (PST)
In-Reply-To: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com, thenzl@redhat.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

There are no changes in this patch from last time sent patch.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 6 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 6e48707..1dc4537 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1666,7 +1666,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 				   local_map_ptr, start_lba_lo);
 		io_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
 		cmd->request_desc->SCSIIO.RequestFlags =
-			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY
+			(MPI2_REQ_DESCRIPT_FLAGS_FP_IO
 			 << MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
 		if (fusion->adapter_type == INVADER_SERIES) {
 			if (io_request->RaidContext.regLockFlags ==
@@ -1799,7 +1799,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 
 		/* build request descriptor */
 		cmd->request_desc->SCSIIO.RequestFlags =
-			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY <<
+			(MPI2_REQ_DESCRIPT_FLAGS_FP_IO <<
 			MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
 		cmd->request_desc->SCSIIO.DevHandle = devHandle;
 
@@ -1905,7 +1905,7 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 				cpu_to_le16(MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH);
 		}
 		cmd->request_desc->SCSIIO.RequestFlags =
-			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY <<
+			(MPI2_REQ_DESCRIPT_FLAGS_FP_IO <<
 				MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
 	}
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 473005c..a9e10c4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -176,7 +176,8 @@ enum REGION_TYPE {
 #define MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD           (0x0100)
 #define MPI2_SCSIIO_EEDPFLAGS_INSERT_OP             (0x0004)
 #define MPI2_FUNCTION_SCSI_IO_REQUEST               (0x00) /* SCSI IO */
-#define MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY           (0x06)
+#define MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY       (0x03)
+#define MPI2_REQ_DESCRIPT_FLAGS_FP_IO               (0x06)
 #define MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO                 (0x00)
 #define MPI2_SGE_FLAGS_64_BIT_ADDRESSING        (0x02)
 #define MPI2_SCSIIO_CONTROL_WRITE               (0x01000000)
-- 
1.8.3.1

