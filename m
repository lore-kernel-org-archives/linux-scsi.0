From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 5/5] scsi_debug: fix sparse warnings related to data integrity field
Date: Wed, 18 Sep 2013 21:27:28 +0900
Message-ID: <1379507248-15929-6-git-send-email-akinobu.mita@gmail.com>
References: <1379507248-15929-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36570 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3IRM2l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Sep 2013 08:28:41 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa1so8176587pad.19
        for <linux-scsi@vger.kernel.org>; Wed, 18 Sep 2013 05:28:41 -0700 (PDT)
In-Reply-To: <1379507248-15929-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Each member in data integrity field tuple is big-endian.  But the
endianness of the values being compared with these members are not
annotated.  So this fixes these sparse warnings.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a21322d..80b8b10 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1745,25 +1745,22 @@ static int do_device_access(struct scsi_cmnd *scmd,
 	return ret;
 }
 
-static u16 dif_compute_csum(const void *buf, int len)
+static __be16 dif_compute_csum(const void *buf, int len)
 {
-	u16 csum;
+	__be16 csum;
 
-	switch (scsi_debug_guard) {
-	case 1:
-		csum = ip_compute_csum(buf, len);
-		break;
-	case 0:
+	if (scsi_debug_guard)
+		csum = (__force __be16)ip_compute_csum(buf, len);
+	else
 		csum = cpu_to_be16(crc_t10dif(buf, len));
-		break;
-	}
+
 	return csum;
 }
 
 static int dif_verify(struct sd_dif_tuple *sdt, const void *data,
 		      sector_t sector, u32 ei_lba)
 {
-	u16 csum = dif_compute_csum(data, scsi_debug_sector_size);
+	__be16 csum = dif_compute_csum(data, scsi_debug_sector_size);
 
 	if (sdt->guard_tag != csum) {
 		pr_err("%s: GUARD check failed on sector %lu rcvd 0x%04x, data 0x%04x\n",
@@ -1841,7 +1838,7 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 		sector = start_sec + i;
 		sdt = dif_store(sector);
 
-		if (sdt->app_tag == 0xffff)
+		if (sdt->app_tag == cpu_to_be16(0xffff))
 			continue;
 
 		ret = dif_verify(sdt, fake_store(sector), sector, ei_lba);
-- 
1.8.3.1

