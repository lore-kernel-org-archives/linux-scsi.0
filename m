From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 2/6] scsi_debug: fix incorrectly nested kmap_atomic()
Date: Sun, 26 May 2013 17:01:18 +0900
Message-ID: <1369555282-17864-3-git-send-email-akinobu.mita@gmail.com>
References: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45923 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759203Ab3EZIBu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 May 2013 04:01:50 -0400
Received: by mail-pb0-f41.google.com with SMTP id xb12so5742847pbc.0
        for <linux-scsi@vger.kernel.org>; Sun, 26 May 2013 01:01:50 -0700 (PDT)
In-Reply-To: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

In the function prot_verify_write(), kmap_atomic()/kunmap_atomic() for
data page and kmap_atomic()/kunmap_atomic() for protection information
page are not nested each other.

It worked perfectly before commit 3e4d3af501cccdc8a8cca41bdbe57d54ad7e7e73
("mm: stack based kmap_atomic()").  Because the kmap_atomic slot KM_IRQ0
was used for data page and the slot KM_IRQ1 was used for protection page.

But KM_types are gone and kmap_atomic() is using stack based implementation.
So two different kmap_atomic() usages must be strictly nested now.

This change ensures kmap_atomic() usage is strictly nested.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
---

* No changes from v2

 drivers/scsi/scsi_debug.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d51bddd..bcf73e4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1891,12 +1891,12 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 	BUG_ON(scsi_sg_count(SCpnt) == 0);
 	BUG_ON(scsi_prot_sg_count(SCpnt) == 0);
 
-	paddr = kmap_atomic(sg_page(psgl)) + psgl->offset;
 	ppage_offset = 0;
 
 	/* For each data page */
 	scsi_for_each_sg(SCpnt, dsgl, scsi_sg_count(SCpnt), i) {
 		daddr = kmap_atomic(sg_page(dsgl)) + dsgl->offset;
+		paddr = kmap_atomic(sg_page(psgl)) + psgl->offset;
 
 		/* For each sector-sized chunk in data page */
 		for (j = 0; j < dsgl->length; j += scsi_debug_sector_size) {
@@ -1980,19 +1980,18 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			ppage_offset += sizeof(struct sd_dif_tuple);
 		}
 
+		kunmap_atomic(paddr);
 		kunmap_atomic(daddr);
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

