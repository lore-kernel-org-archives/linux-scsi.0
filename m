From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/3] scsi_debug: simplify offset calculation for dif_storep
Date: Sun, 21 Apr 2013 18:17:59 +0900
Message-ID: <1366535879-20775-4-git-send-email-akinobu.mita@gmail.com>
References: <1366535879-20775-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:45896 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3DUJSb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Apr 2013 05:18:31 -0400
Received: by mail-da0-f44.google.com with SMTP id z20so2610942dae.3
        for <linux-scsi@vger.kernel.org>; Sun, 21 Apr 2013 02:18:30 -0700 (PDT)
In-Reply-To: <1366535879-20775-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

dif_storep is declared as pointer to unsigned char type.  But it is
actually used to store vmalloced array of struct sd_dif_tuple.

This changes the type of dif_storep to the pointer to struct sd_dif_tuple.
It simplifies offset calculation for dif_storep and enables to remove
hardcoded size of struct sd_dif_tuple.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ffbdb4c..e69cbc2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -258,7 +258,7 @@ struct sdebug_queued_cmd {
 static struct sdebug_queued_cmd queued_arr[SCSI_DEBUG_CANQUEUE];
 
 static unsigned char * fake_storep;	/* ramdisk storage */
-static unsigned char *dif_storep;	/* protection info */
+static struct sd_dif_tuple *dif_storep;	/* protection info */
 static void *map_storep;		/* provisioning map */
 
 static unsigned long map_size;
@@ -277,11 +277,6 @@ static char sdebug_proc_name[] = "scsi_debug";
 
 static struct bus_type pseudo_lld_bus;
 
-static inline sector_t dif_offset(sector_t sector)
-{
-	return sector << 3;
-}
-
 static struct device_driver sdebug_driverfs_driver = {
 	.name 		= sdebug_proc_name,
 	.bus		= &pseudo_lld_bus,
@@ -1653,7 +1648,7 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 
 	start_sec = do_div(tmp_sec, sdebug_store_sectors);
 
-	sdt = (struct sd_dif_tuple *)(dif_storep + dif_offset(start_sec));
+	sdt = dif_storep + start_sec;
 
 	for (i = 0 ; i < sectors ; i++) {
 		u16 csum;
@@ -1708,16 +1703,17 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 		ei_lba++;
 	}
 
-	resid = sectors * 8; /* Bytes of protection data to copy into sgl */
+	/* Bytes of protection data to copy into sgl */
+	resid = sectors * sizeof(*dif_storep);
 	sector = start_sec;
 
 	scsi_for_each_prot_sg(SCpnt, psgl, scsi_prot_sg_count(SCpnt), i) {
 		int len = min(psgl->length, resid);
 
 		paddr = kmap_atomic(sg_page(psgl)) + psgl->offset;
-		memcpy(paddr, dif_storep + dif_offset(sector), len);
+		memcpy(paddr, dif_storep + sector, len);
 
-		sector += len >> 3;
+		sector += len / sizeof(*dif_storep);
 		if (sector >= sdebug_store_sectors) {
 			/* Force wrap */
 			tmp_sec = sector;
@@ -1891,7 +1887,7 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			 * correctness we need to verify each sector
 			 * before writing it to "stable" storage
 			 */
-			memcpy(dif_storep + dif_offset(sector), sdt, 8);
+			memcpy(dif_storep + sector, sdt, sizeof(*sdt));
 
 			sector++;
 
-- 
1.8.1.4

