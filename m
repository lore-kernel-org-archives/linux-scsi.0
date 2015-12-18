From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH 03/15] megaraid_sas: Syncing request flags macro names with firmware
Date: Fri, 18 Dec 2015 18:56:56 +0530
Message-ID: <1450445228-26571-4-git-send-email-Sumit.Saxena@avagotech.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35088 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbbLRN2C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2015 08:28:02 -0500
Received: by mail-pa0-f45.google.com with SMTP id jx14so31890205pad.2
        for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2015 05:28:01 -0800 (PST)
In-Reply-To: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    6 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.h |    3 ++-
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
1.7.1

