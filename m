From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [patch -v3 22/22] qla2xxx: use memory_read_from_buffer
Date: Wed, 04 Jun 2008 20:56:55 +0900
Message-ID: <20080604115859.351267641@gmail.com>
References: <20080604115633.116832712@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:60935 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbYFDMLW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2008 08:11:22 -0400
Received: by wr-out-0506.google.com with SMTP id c48so5492wra.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Jun 2008 05:11:20 -0700 (PDT)
Content-Disposition: inline; filename=scsi-qla2xxx-use-memory-read-from-buffer.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Andrew Vasquez <linux-driver@qlogic.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Vasquez <linux-driver@qlogic.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/qla2xxx/qla_attr.c |   45 ++++++++--------------------------------
 1 file changed, 10 insertions(+), 35 deletions(-)

Index: 2.6-git/drivers/scsi/qla2xxx/qla_attr.c
===================================================================
--- 2.6-git.orig/drivers/scsi/qla2xxx/qla_attr.c
+++ 2.6-git/drivers/scsi/qla2xxx/qla_attr.c
@@ -8,6 +8,7 @@
 
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
+#include <linux/fs.h>
 
 static int qla24xx_vport_disable(struct fc_vport *, bool);
 
@@ -20,18 +21,12 @@ qla2x00_sysfs_read_fw_dump(struct kobjec
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
@@ -91,20 +86,13 @@ qla2x00_sysfs_read_nvram(struct kobject 
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
@@ -172,14 +160,9 @@ qla2x00_sysfs_read_optrom(struct kobject
 
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
@@ -371,20 +354,12 @@ qla2x00_sysfs_read_vpd(struct kobject *k
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
