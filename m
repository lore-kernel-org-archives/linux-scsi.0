From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/6] qla2xxx: Correct address range checking for option-rom updates.
Date: Thu,  5 Mar 2009 11:07:00 -0800
Message-ID: <1236280025-89526-2-git-send-email-andrew.vasquez@qlogic.com>
References: <1236280025-89526-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:5602 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbZCETHI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2009 14:07:08 -0500
In-Reply-To: <1236280025-89526-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index f4c5722..ee9d401 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -244,12 +244,6 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 		if (ha->optrom_state != QLA_SWAITING)
 			break;
 
-		if (start & 0xfff) {
-			qla_printk(KERN_WARNING, ha,
-			    "Invalid start region 0x%x/0x%x.\n", start, size);
-			return -EINVAL;
-		}
-
 		ha->optrom_region_start = start;
 		ha->optrom_region_size = start + size > ha->optrom_size ?
 		    ha->optrom_size - start : size;
@@ -303,8 +297,7 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 		else if (start == (ha->flt_region_boot * 4) ||
 		    start == (ha->flt_region_fw * 4))
 			valid = 1;
-		else if ((IS_QLA25XX(ha) || IS_QLA81XX(ha)) &&
-		    start == (ha->flt_region_vpd_nvram * 4))
+		else if (IS_QLA25XX(ha) || IS_QLA81XX(ha))
 		    valid = 1;
 		if (!valid) {
 			qla_printk(KERN_WARNING, ha,
-- 
1.6.2.rc0.55.g30aa4f

