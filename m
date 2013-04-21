From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/3] scsi_debug: fix data integrity support on highmem machine
Date: Sun, 21 Apr 2013 18:17:57 +0900
Message-ID: <1366535879-20775-2-git-send-email-akinobu.mita@gmail.com>
References: <1366535879-20775-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:33035 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3DUJS1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Apr 2013 05:18:27 -0400
Received: by mail-da0-f52.google.com with SMTP id j17so293590dan.39
        for <linux-scsi@vger.kernel.org>; Sun, 21 Apr 2013 02:18:27 -0700 (PDT)
In-Reply-To: <1366535879-20775-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

kmap_atomic() is now using stack based implementation and doesn't take
the KM_type argument anymore.  So nesting kmap_atomic() calls must be
properly stacked.

This fixes nesting kmap_atomic() calls for scsi_sglist and scsi_prot_sglist
in prot_verify_write().

This also fixes another issue that invalid kmap address is used for
kunmap_atomic(): the kmap address 'daddr' is incremented in the loop for
each data page, and it can reach the next page boundary.

These problems trigger CONFIG_DEBUG_HIGHMEM warnings, protection errors,
and kernel crash when doing I/O for the storage installed by
'modprobe scsi_debug dif=1 dix=1' on x86_32 with highmem.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index aea4c2e..8fd30a5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1814,12 +1814,12 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 	BUG_ON(scsi_sg_count(SCpnt) == 0);
 	BUG_ON(scsi_prot_sg_count(SCpnt) == 0);
 
-	paddr = kmap_atomic(sg_page(psgl)) + psgl->offset;
 	ppage_offset = 0;
 
 	/* For each data page */
 	scsi_for_each_sg(SCpnt, dsgl, scsi_sg_count(SCpnt), i) {
 		daddr = kmap_atomic(sg_page(dsgl)) + dsgl->offset;
+		paddr = kmap_atomic(sg_page(psgl)) + psgl->offset;
 
 		/* For each sector-sized chunk in data page */
 		for (j = 0 ; j < dsgl->length ; j += scsi_debug_sector_size) {
@@ -1904,19 +1904,18 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			ppage_offset += sizeof(struct sd_dif_tuple);
 		}
 
-		kunmap_atomic(daddr);
+		kunmap_atomic(paddr);
+		kunmap_atomic(daddr - dsgl->length);
 	}
 
-	kunmap_atomic(paddr);
-
 	dix_writes++;
 
 	return 0;
 
 out:
 	dif_errors++;
-	kunmap_atomic(daddr);
 	kunmap_atomic(paddr);
+	kunmap_atomic(daddr);
 	return ret;
 }
 
-- 
1.8.1.4

