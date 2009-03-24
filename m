From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 23/26] qla2xxx: Don't cache VPD data for newer ISPs.
Date: Tue, 24 Mar 2009 09:08:17 -0700
Message-ID: <1237910900-30817-24-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29880 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762379AbZCXQIr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:47 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

As updates will occur using low-level option-rom manipulation
routines.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    8 ++++++--
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 18566ed..cac4441 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -96,7 +96,9 @@ qla2x00_sysfs_read_nvram(struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return 0;
 
-	/* Read NVRAM data from cache. */
+	if (IS_NOCACHE_VPD_TYPE(ha))
+		ha->isp_ops->read_optrom(vha, ha->vpd, ha->flt_region_nvram << 2,
+		    ha->nvram_size);
 	return memory_read_from_buffer(buf, count, &off, ha->nvram,
 					ha->nvram_size);
 }
@@ -380,7 +382,9 @@ qla2x00_sysfs_read_vpd(struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return 0;
 
-	/* Read NVRAM data from cache. */
+	if (IS_NOCACHE_VPD_TYPE(ha))
+		ha->isp_ops->read_optrom(vha, ha->vpd, ha->flt_region_vpd << 2,
+		    ha->vpd_size);
 	return memory_read_from_buffer(buf, count, &off, ha->vpd, ha->vpd_size);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e3d4d48..714ee67 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2343,6 +2343,7 @@ struct qla_hw_data {
 #define IS_NOPOLLING_TYPE(ha)	((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && \
 				(ha)->flags.msix_enabled)
 #define IS_FAC_REQUIRED(ha)	(IS_QLA81XX(ha))
+#define IS_NOCACHE_VPD_TYPE(ha)	(IS_QLA81XX(ha))
 
 #define IS_IIDMA_CAPABLE(ha)    ((ha)->device_type & DT_IIDMA)
 #define IS_FWI2_CAPABLE(ha)     ((ha)->device_type & DT_FWI2)
-- 
1.6.2.rc0.55.g30aa4f

