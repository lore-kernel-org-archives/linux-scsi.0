From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/5] qla2xxx: use memory_read_from_buffer()
Date: Thu, 24 Jul 2008 08:31:47 -0700
Message-ID: <1216913510-14767-2-git-send-email-andrew.vasquez@qlogic.com>
References: <20080724153108.GI561@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:23054 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbYGXPbw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 11:31:52 -0400
In-Reply-To: <20080724153108.GI561@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Akinobu Mita <akinobu.mita@gmail.com>

From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Vasquez <linux-driver@qlogic.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   44 ++++++++-------------------------------
 1 files changed, 9 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 612e3d0..fcec43a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -20,18 +20,12 @@ qla2x00_sysfs_read_fw_dump(struct kobject *kobj,
 {
 	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
-	char *rbuf = (char *)ha->fw_dump;
 
 	if (ha->fw_dump_reading == 0)
 		return 0;
-	if (off > ha->fw_dump_len)
-                return 0;
-	if (off + count > ha->fw_dump_len)
-		count = ha->fw_dump_len - off;
 
-	memcpy(buf, &rbuf[off], count);
-
-	return (count);
+	return memory_read_from_buffer(buf, count, &off, ha->fw_dump,
+					ha->fw_dump_len);
 }
 
 static ssize_t
@@ -94,20 +88,13 @@ qla2x00_sysfs_read_nvram(struct kobject *kobj,
 {
 	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
-	int		size = ha->nvram_size;
-	char		*nvram_cache = ha->nvram;
 
-	if (!capable(CAP_SYS_ADMIN) || off > size || count == 0)
+	if (!capable(CAP_SYS_ADMIN))
 		return 0;
-	if (off + count > size) {
-		size -= off;
-		count = size;
-	}
 
 	/* Read NVRAM data from cache. */
-	memcpy(buf, &nvram_cache[off], count);
-
-	return count;
+	return memory_read_from_buffer(buf, count, &off, ha->nvram,
+					ha->nvram_size);
 }
 
 static ssize_t
@@ -175,14 +162,9 @@ qla2x00_sysfs_read_optrom(struct kobject *kobj,
 
 	if (ha->optrom_state != QLA_SREADING)
 		return 0;
-	if (off > ha->optrom_region_size)
-		return 0;
-	if (off + count > ha->optrom_region_size)
-		count = ha->optrom_region_size - off;
 
-	memcpy(buf, &ha->optrom_buffer[off], count);
-
-	return count;
+	return memory_read_from_buffer(buf, count, &off, ha->optrom_buffer,
+					ha->optrom_region_size);
 }
 
 static ssize_t
@@ -374,20 +356,12 @@ qla2x00_sysfs_read_vpd(struct kobject *kobj,
 {
 	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
-	int           size = ha->vpd_size;
-	char          *vpd_cache = ha->vpd;
 
-	if (!capable(CAP_SYS_ADMIN) || off > size || count == 0)
+	if (!capable(CAP_SYS_ADMIN))
 		return 0;
-	if (off + count > size) {
-		size -= off;
-		count = size;
-	}
 
 	/* Read NVRAM data from cache. */
-	memcpy(buf, &vpd_cache[off], count);
-
-	return count;
+	return memory_read_from_buffer(buf, count, &off, ha->vpd, ha->vpd_size);
 }
 
 static ssize_t
-- 
1.6.0.rc0.42.g186458

