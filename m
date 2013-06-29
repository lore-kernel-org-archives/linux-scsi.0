From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 6/6] scsi_debug: reduce duplication between prot_verify_read and prot_verify_write
Date: Sat, 29 Jun 2013 17:59:19 +0900
Message-ID: <1372496359-21100-7-git-send-email-akinobu.mita@gmail.com>
References: <1372496359-21100-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47439 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab3F2JAS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Jun 2013 05:00:18 -0400
Received: by mail-pd0-f180.google.com with SMTP id 10so1471384pdi.11
        for <linux-scsi@vger.kernel.org>; Sat, 29 Jun 2013 02:00:18 -0700 (PDT)
In-Reply-To: <1372496359-21100-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

In order to reduce code duplication between prot_verify_read() and
prot_verify_write(), this moves common code into the new functions.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Acked-by: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 139 ++++++++++++++++++----------------------------
 1 file changed, 54 insertions(+), 85 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index fc8b3aa..9790d56 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1710,6 +1710,52 @@ static int do_device_access(struct scsi_cmnd *scmd,
 	return ret;
 }
 
+static u16 dif_compute_csum(const void *buf, int len)
+{
+	u16 csum;
+
+	switch (scsi_debug_guard) {
+	case 1:
+		csum = ip_compute_csum(buf, len);
+		break;
+	case 0:
+		csum = cpu_to_be16(crc_t10dif(buf, len));
+		break;
+	default:
+		BUG();
+	}
+	return csum;
+}
+
+static int dif_verify(struct sd_dif_tuple *sdt, const void *data,
+		      sector_t sector, u32 ei_lba)
+{
+	u16 csum = dif_compute_csum(data, scsi_debug_sector_size);
+
+	if (sdt->guard_tag != csum) {
+		pr_err("%s: GUARD check failed on sector %lu rcvd 0x%04x, data 0x%04x\n",
+			__func__,
+			(unsigned long)sector,
+			be16_to_cpu(sdt->guard_tag),
+			be16_to_cpu(csum));
+		return 0x01;
+	}
+	if (scsi_debug_dif == SD_DIF_TYPE1_PROTECTION &&
+	    be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
+		pr_err("%s: REF check failed on sector %lu\n",
+			__func__, (unsigned long)sector);
+		return 0x03;
+	}
+	if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
+	    be32_to_cpu(sdt->ref_tag) != ei_lba) {
+		pr_err("%s: REF check failed on sector %lu\n",
+			__func__, (unsigned long)sector);
+			dif_errors++;
+		return 0x03;
+	}
+	return 0;
+}
+
 static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			    unsigned int sectors, u32 ei_lba)
 {
@@ -1725,53 +1771,19 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 	sdt = dif_storep + start_sec;
 
 	for (i = 0 ; i < sectors ; i++) {
-		u16 csum;
+		int ret;
 
 		if (sdt[i].app_tag == 0xffff)
 			continue;
 
 		sector = start_sec + i;
 
-		switch (scsi_debug_guard) {
-		case 1:
-			csum = ip_compute_csum(fake_storep +
-					       sector * scsi_debug_sector_size,
-					       scsi_debug_sector_size);
-			break;
-		case 0:
-			csum = crc_t10dif(fake_storep +
-					  sector * scsi_debug_sector_size,
-					  scsi_debug_sector_size);
-			csum = cpu_to_be16(csum);
-			break;
-		default:
-			BUG();
-		}
-
-		if (sdt[i].guard_tag != csum) {
-			printk(KERN_ERR "%s: GUARD check failed on sector %lu" \
-			       " rcvd 0x%04x, data 0x%04x\n", __func__,
-			       (unsigned long)sector,
-			       be16_to_cpu(sdt[i].guard_tag),
-			       be16_to_cpu(csum));
+		ret = dif_verify(&sdt[i],
+				 fake_storep + sector * scsi_debug_sector_size,
+				 sector, ei_lba);
+		if (ret) {
 			dif_errors++;
-			return 0x01;
-		}
-
-		if (scsi_debug_dif == SD_DIF_TYPE1_PROTECTION &&
-		    be32_to_cpu(sdt[i].ref_tag) != (sector & 0xffffffff)) {
-			printk(KERN_ERR "%s: REF check failed on sector %lu\n",
-			       __func__, (unsigned long)sector);
-			dif_errors++;
-			return 0x03;
-		}
-
-		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
-		    be32_to_cpu(sdt[i].ref_tag) != ei_lba) {
-			printk(KERN_ERR "%s: REF check failed on sector %lu\n",
-			       __func__, (unsigned long)sector);
-			dif_errors++;
-			return 0x03;
+			return ret;
 		}
 
 		ei_lba++;
@@ -1880,7 +1892,6 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 	sector_t tmp_sec = start_sec;
 	sector_t sector;
 	int ppage_offset;
-	unsigned short csum;
 
 	sector = do_div(tmp_sec, sdebug_store_sectors);
 
@@ -1911,50 +1922,8 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 
 			sdt = paddr + ppage_offset;
 
-			switch (scsi_debug_guard) {
-			case 1:
-				csum = ip_compute_csum(daddr + j,
-						       scsi_debug_sector_size);
-				break;
-			case 0:
-				csum = cpu_to_be16(crc_t10dif(daddr + j,
-						      scsi_debug_sector_size));
-				break;
-			default:
-				BUG();
-				ret = 0;
-				goto out;
-			}
-
-			if (sdt->guard_tag != csum) {
-				printk(KERN_ERR
-				       "%s: GUARD check failed on sector %lu " \
-				       "rcvd 0x%04x, calculated 0x%04x\n",
-				       __func__, (unsigned long)sector,
-				       be16_to_cpu(sdt->guard_tag),
-				       be16_to_cpu(csum));
-				ret = 0x01;
-				dump_sector(daddr + j, scsi_debug_sector_size);
-				goto out;
-			}
-
-			if (scsi_debug_dif == SD_DIF_TYPE1_PROTECTION &&
-			    be32_to_cpu(sdt->ref_tag)
-			    != (start_sec & 0xffffffff)) {
-				printk(KERN_ERR
-				       "%s: REF check failed on sector %lu\n",
-				       __func__, (unsigned long)sector);
-				ret = 0x03;
-				dump_sector(daddr + j, scsi_debug_sector_size);
-				goto out;
-			}
-
-			if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
-			    be32_to_cpu(sdt->ref_tag) != ei_lba) {
-				printk(KERN_ERR
-				       "%s: REF check failed on sector %lu\n",
-				       __func__, (unsigned long)sector);
-				ret = 0x03;
+			ret = dif_verify(sdt, daddr + j, start_sec, ei_lba);
+			if (ret) {
 				dump_sector(daddr + j, scsi_debug_sector_size);
 				goto out;
 			}
-- 
1.8.1.4

