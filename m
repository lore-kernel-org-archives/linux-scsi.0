From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/5] scsi_debug: fix buffer overrun when DIF/DIX is enabled and virtual_gb > 0
Date: Wed, 18 Sep 2013 21:27:24 +0900
Message-ID: <1379507248-15929-2-git-send-email-akinobu.mita@gmail.com>
References: <1379507248-15929-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:62227 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3IRM2e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Sep 2013 08:28:34 -0400
Received: by mail-pb0-f45.google.com with SMTP id mc17so6945926pbc.32
        for <linux-scsi@vger.kernel.org>; Wed, 18 Sep 2013 05:28:33 -0700 (PDT)
In-Reply-To: <1379507248-15929-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

If the module parameter virtual_gb is greater than 0, the READ command
may request the blocks which exceed actual ramdisk storage (fake_storep).
prot_verify_read() should treat those blocks as wrap around the end of
fake_storep.  But it actually causes fake_storep and dif_storep buffer
overruns.

This fixes these buffer overruns.  In order to simplify the fix,
this also introduces fake_store() and dif_store() which return
corresponding wrap around addresses.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 48 +++++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 01c0ffa..f640b6b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -293,6 +293,20 @@ static unsigned char ctrl_m_pg[] = {0xa, 10, 2, 0, 0, 0, 0, 0,
 static unsigned char iec_m_pg[] = {0x1c, 0xa, 0x08, 0, 0, 0, 0, 0,
 			           0, 0, 0x0, 0x0};
 
+static void *fake_store(unsigned long long lba)
+{
+	lba = do_div(lba, sdebug_store_sectors);
+
+	return fake_storep + lba * scsi_debug_sector_size;
+}
+
+static struct sd_dif_tuple *dif_store(sector_t sector)
+{
+	sector = do_div(sector, sdebug_store_sectors);
+
+	return dif_storep + sector;
+}
+
 static int sdebug_add_adapter(void);
 static void sdebug_remove_adapter(void);
 
@@ -1782,24 +1796,19 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 	struct scatterlist *psgl;
 	struct sd_dif_tuple *sdt;
 	sector_t sector;
-	sector_t tmp_sec = start_sec;
 	void *paddr;
+	const void *dif_store_end = dif_storep + sdebug_store_sectors;
 
-	start_sec = do_div(tmp_sec, sdebug_store_sectors);
-
-	sdt = dif_storep + start_sec;
-
-	for (i = 0 ; i < sectors ; i++) {
+	for (i = 0; i < sectors; i++) {
 		int ret;
 
-		if (sdt[i].app_tag == 0xffff)
-			continue;
-
 		sector = start_sec + i;
+		sdt = dif_store(sector);
 
-		ret = dif_verify(&sdt[i],
-				 fake_storep + sector * scsi_debug_sector_size,
-				 sector, ei_lba);
+		if (sdt->app_tag == 0xffff)
+			continue;
+
+		ret = dif_verify(sdt, fake_store(sector), sector, ei_lba);
 		if (ret) {
 			dif_errors++;
 			return ret;
@@ -1814,16 +1823,19 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 
 	scsi_for_each_prot_sg(SCpnt, psgl, scsi_prot_sg_count(SCpnt), i) {
 		int len = min(psgl->length, resid);
+		void *start = dif_store(sector);
+		int rest = 0;
+
+		if (dif_store_end < start + len)
+			rest = start + len - dif_store_end;
 
 		paddr = kmap_atomic(sg_page(psgl)) + psgl->offset;
-		memcpy(paddr, dif_storep + sector, len);
+		memcpy(paddr, start, len - rest);
+
+		if (rest)
+			memcpy(paddr + len - rest, dif_storep, rest);
 
 		sector += len / sizeof(*dif_storep);
-		if (sector >= sdebug_store_sectors) {
-			/* Force wrap */
-			tmp_sec = sector;
-			sector = do_div(tmp_sec, sdebug_store_sectors);
-		}
 		resid -= len;
 		kunmap_atomic(paddr);
 	}
-- 
1.8.3.1

