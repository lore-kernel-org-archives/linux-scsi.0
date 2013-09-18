From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/5] scsi_debug: avoid partial copying PI from prot_sglist to dif_storep
Date: Wed, 18 Sep 2013 21:27:26 +0900
Message-ID: <1379507248-15929-4-git-send-email-akinobu.mita@gmail.com>
References: <1379507248-15929-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38020 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3IRM2h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Sep 2013 08:28:37 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj1so8237323pad.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Sep 2013 05:28:37 -0700 (PDT)
In-Reply-To: <1379507248-15929-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

If data integrity support is enabled, prot_verify_write() is called in
response to WRITE commands and it verifies protection info from
prot_sglist by comparing against data sglist, and copies protection info
to dif_storep.

When multiple blocks are transfered by a WRITE command, it verifies and
copies these blocks one by one.  So if it fails to verify protection
info in the middle of blocks, the actual data transfer to fake_storep
isn't proceeded at all although protection info for some blocks are
already copied to dif_storep.  Therefore, it breaks the data integrity
between fake_storep and dif_storep.

This fixes it by ensuring that copying protection info to dif_storep is
done after all blocks are successfully verified.  Reusing dif_copy_prot()
with supporting the opposite direction simplifies this fix.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 99e74d7..43369e9 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1790,7 +1790,7 @@ static int dif_verify(struct sd_dif_tuple *sdt, const void *data,
 }
 
 static void dif_copy_prot(struct scsi_cmnd *SCpnt, sector_t sector,
-			  unsigned int sectors)
+			  unsigned int sectors, bool read)
 {
 	unsigned int i, resid;
 	struct scatterlist *psgl;
@@ -1809,10 +1809,18 @@ static void dif_copy_prot(struct scsi_cmnd *SCpnt, sector_t sector,
 			rest = start + len - dif_store_end;
 
 		paddr = kmap_atomic(sg_page(psgl)) + psgl->offset;
-		memcpy(paddr, start, len - rest);
 
-		if (rest)
-			memcpy(paddr + len - rest, dif_storep, rest);
+		if (read)
+			memcpy(paddr, start, len - rest);
+		else
+			memcpy(start, paddr, len - rest);
+
+		if (rest) {
+			if (read)
+				memcpy(paddr + len - rest, dif_storep, rest);
+			else
+				memcpy(dif_storep, paddr + len - rest, rest);
+		}
 
 		sector += len / sizeof(*dif_storep);
 		resid -= len;
@@ -1845,7 +1853,7 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 		ei_lba++;
 	}
 
-	dif_copy_prot(SCpnt, start_sec, sectors);
+	dif_copy_prot(SCpnt, start_sec, sectors, true);
 	dix_reads++;
 
 	return 0;
@@ -1928,15 +1936,12 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 {
 	int i, j, ret;
 	struct sd_dif_tuple *sdt;
-	struct scatterlist *dsgl = scsi_sglist(SCpnt);
+	struct scatterlist *dsgl;
 	struct scatterlist *psgl = scsi_prot_sglist(SCpnt);
 	void *daddr, *paddr;
-	sector_t tmp_sec = start_sec;
-	sector_t sector;
+	sector_t sector = start_sec;
 	int ppage_offset;
 
-	sector = do_div(tmp_sec, sdebug_store_sectors);
-
 	BUG_ON(scsi_sg_count(SCpnt) == 0);
 	BUG_ON(scsi_prot_sg_count(SCpnt) == 0);
 
@@ -1964,25 +1969,13 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 
 			sdt = paddr + ppage_offset;
 
-			ret = dif_verify(sdt, daddr + j, start_sec, ei_lba);
+			ret = dif_verify(sdt, daddr + j, sector, ei_lba);
 			if (ret) {
 				dump_sector(daddr + j, scsi_debug_sector_size);
 				goto out;
 			}
 
-			/* Would be great to copy this in bigger
-			 * chunks.  However, for the sake of
-			 * correctness we need to verify each sector
-			 * before writing it to "stable" storage
-			 */
-			memcpy(dif_storep + sector, sdt, sizeof(*sdt));
-
 			sector++;
-
-			if (sector == sdebug_store_sectors)
-				sector = 0;	/* Force wrap */
-
-			start_sec++;
 			ei_lba++;
 			ppage_offset += sizeof(struct sd_dif_tuple);
 		}
@@ -1991,6 +1984,7 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 		kunmap_atomic(daddr);
 	}
 
+	dif_copy_prot(SCpnt, start_sec, sectors, false);
 	dix_writes++;
 
 	return 0;
-- 
1.8.3.1

