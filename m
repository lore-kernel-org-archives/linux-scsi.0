From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/5] scsi_debug: factor out copying PI from dif_storep to prot_sglist
Date: Wed, 18 Sep 2013 21:27:25 +0900
Message-ID: <1379507248-15929-3-git-send-email-akinobu.mita@gmail.com>
References: <1379507248-15929-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:49707 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3IRM2f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Sep 2013 08:28:35 -0400
Received: by mail-pb0-f52.google.com with SMTP id wz12so6899190pbc.25
        for <linux-scsi@vger.kernel.org>; Wed, 18 Sep 2013 05:28:35 -0700 (PDT)
In-Reply-To: <1379507248-15929-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

If data integrity support is enabled, prot_verify_read() is called in
response to READ commands and it verifies protection info from dif_storep
by comparing against fake_storep, and copies protection info to
prot_sglist.

This factors out the portion of copying protection info into a separate
function.  It will also be reused in the next change after supporting
the opposite direction (copying prot_sglist to dif_storep).

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 52 ++++++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f640b6b..99e74d7 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1789,37 +1789,16 @@ static int dif_verify(struct sd_dif_tuple *sdt, const void *data,
 	return 0;
 }
 
-static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
-			    unsigned int sectors, u32 ei_lba)
+static void dif_copy_prot(struct scsi_cmnd *SCpnt, sector_t sector,
+			  unsigned int sectors)
 {
 	unsigned int i, resid;
 	struct scatterlist *psgl;
-	struct sd_dif_tuple *sdt;
-	sector_t sector;
 	void *paddr;
 	const void *dif_store_end = dif_storep + sdebug_store_sectors;
 
-	for (i = 0; i < sectors; i++) {
-		int ret;
-
-		sector = start_sec + i;
-		sdt = dif_store(sector);
-
-		if (sdt->app_tag == 0xffff)
-			continue;
-
-		ret = dif_verify(sdt, fake_store(sector), sector, ei_lba);
-		if (ret) {
-			dif_errors++;
-			return ret;
-		}
-
-		ei_lba++;
-	}
-
 	/* Bytes of protection data to copy into sgl */
 	resid = sectors * sizeof(*dif_storep);
-	sector = start_sec;
 
 	scsi_for_each_prot_sg(SCpnt, psgl, scsi_prot_sg_count(SCpnt), i) {
 		int len = min(psgl->length, resid);
@@ -1839,7 +1818,34 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 		resid -= len;
 		kunmap_atomic(paddr);
 	}
+}
+
+static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
+			    unsigned int sectors, u32 ei_lba)
+{
+	unsigned int i;
+	struct sd_dif_tuple *sdt;
+	sector_t sector;
+
+	for (i = 0; i < sectors; i++) {
+		int ret;
+
+		sector = start_sec + i;
+		sdt = dif_store(sector);
+
+		if (sdt->app_tag == 0xffff)
+			continue;
+
+		ret = dif_verify(sdt, fake_store(sector), sector, ei_lba);
+		if (ret) {
+			dif_errors++;
+			return ret;
+		}
+
+		ei_lba++;
+	}
 
+	dif_copy_prot(SCpnt, start_sec, sectors);
 	dix_reads++;
 
 	return 0;
-- 
1.8.3.1

