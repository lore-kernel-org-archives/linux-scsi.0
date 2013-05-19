From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 5/5] scsi_debug: reduce duplication between prot_verify_read and prot_verify_write
Date: Sun, 19 May 2013 22:42:09 +0900
Message-ID: <1368970929-20006-6-git-send-email-akinobu.mita@gmail.com>
References: <1368970929-20006-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:38106 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3ESNmm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 May 2013 09:42:42 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr4so4609393pbb.20
        for <linux-scsi@vger.kernel.org>; Sun, 19 May 2013 06:42:41 -0700 (PDT)
In-Reply-To: <1368970929-20006-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

In order to reduce code duplication between prot_verify_read() and
prot_verify_write(), this moves common code into the new functions.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---

* New patch from v2

 drivers/scsi/scsi_debug.c | 135 +++++++++++++++++++---------------------------
 1 file changed, 54 insertions(+), 81 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 152ead6..bd14e12 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1710,6 +1710,50 @@ static int do_device_access(struct scsi_cmnd *scmd,
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
+static int dif_verify(struct sd_dif_tuple *sdt, u16 csum, sector_t sector,
+		      u32 ei_lba)
+{
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
@@ -1726,52 +1770,21 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 
 	for (i = 0 ; i < sectors ; i++) {
 		u16 csum;
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
+		csum = dif_compute_csum(fake_storep +
+					sector * scsi_debug_sector_size,
+					scsi_debug_sector_size);
 
-		if (sdt[i].guard_tag != csum) {
-			printk(KERN_ERR "%s: GUARD check failed on sector %lu" \
-			       " rcvd 0x%04x, data 0x%04x\n", __func__,
-			       (unsigned long)sector,
-			       be16_to_cpu(sdt[i].guard_tag),
-			       be16_to_cpu(csum));
+		ret = dif_verify(&sdt[i], csum, sector, ei_lba);
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
@@ -1911,50 +1924,10 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 
 			sdt = paddr + ppage_offset;
 
-			switch (scsi_debug_guard) {
-			case 1:
-				csum = ip_compute_csum(daddr,
-						       scsi_debug_sector_size);
-				break;
-			case 0:
-				csum = cpu_to_be16(crc_t10dif(daddr,
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
-				dump_sector(daddr, scsi_debug_sector_size);
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
-				dump_sector(daddr, scsi_debug_sector_size);
-				goto out;
-			}
+			csum = dif_compute_csum(daddr, scsi_debug_sector_size);
 
-			if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
-			    be32_to_cpu(sdt->ref_tag) != ei_lba) {
-				printk(KERN_ERR
-				       "%s: REF check failed on sector %lu\n",
-				       __func__, (unsigned long)sector);
-				ret = 0x03;
+			ret = dif_verify(sdt, csum, start_sec, ei_lba);
+			if (ret) {
 				dump_sector(daddr, scsi_debug_sector_size);
 				goto out;
 			}
-- 
1.8.1.4

