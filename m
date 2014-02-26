From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 5/7] scsi_debug: prepare to enable clustering
Date: Wed, 26 Feb 2014 22:57:02 +0900
Message-ID: <1393423024-8063-6-git-send-email-akinobu.mita@gmail.com>
References: <1393423024-8063-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:55823 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaBZN5b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Feb 2014 08:57:31 -0500
Received: by mail-pb0-f42.google.com with SMTP id rr13so1017191pbb.29
        for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2014 05:57:30 -0800 (PST)
In-Reply-To: <1393423024-8063-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Currently, clustering support for scsi_debug is disabled.  This is
because there are for_each_sg() loops which assume that each sg list
element is consisted with a single page.  But enabling clustering
support, each sg list element for scsi commands can be consisted with
multiple pages.

This replaces these for_each_sg() loops with sg mapping iterator which
is capable of handling each sg list element is consisted with multiple
pages.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Douglas Gilbert <dgilbert@interlog.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 109 +++++++++++++++++++++++++---------------------
 1 file changed, 59 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a102519..004b985 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1789,23 +1789,27 @@ static int dif_verify(struct sd_dif_tuple *sdt, const void *data,
 static void dif_copy_prot(struct scsi_cmnd *SCpnt, sector_t sector,
 			  unsigned int sectors, bool read)
 {
-	unsigned int i, resid;
-	struct scatterlist *psgl;
+	size_t resid;
 	void *paddr;
 	const void *dif_store_end = dif_storep + sdebug_store_sectors;
+	struct sg_mapping_iter miter;
 
 	/* Bytes of protection data to copy into sgl */
 	resid = sectors * sizeof(*dif_storep);
 
-	scsi_for_each_prot_sg(SCpnt, psgl, scsi_prot_sg_count(SCpnt), i) {
-		int len = min(psgl->length, resid);
+	sg_miter_start(&miter, scsi_prot_sglist(SCpnt),
+			scsi_prot_sg_count(SCpnt), SG_MITER_ATOMIC |
+			(read ? SG_MITER_TO_SG : SG_MITER_FROM_SG));
+
+	while (sg_miter_next(&miter) && resid > 0) {
+		size_t len = min(miter.length, resid);
 		void *start = dif_store(sector);
-		int rest = 0;
+		size_t rest = 0;
 
 		if (dif_store_end < start + len)
 			rest = start + len - dif_store_end;
 
-		paddr = kmap_atomic(sg_page(psgl)) + psgl->offset;
+		paddr = miter.addr;
 
 		if (read)
 			memcpy(paddr, start, len - rest);
@@ -1821,8 +1825,8 @@ static void dif_copy_prot(struct scsi_cmnd *SCpnt, sector_t sector,
 
 		sector += len / sizeof(*dif_storep);
 		resid -= len;
-		kunmap_atomic(paddr);
 	}
+	sg_miter_stop(&miter);
 }
 
 static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
@@ -1929,55 +1933,62 @@ void dump_sector(unsigned char *buf, int len)
 static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			     unsigned int sectors, u32 ei_lba)
 {
-	int i, j, ret;
+	int ret;
 	struct sd_dif_tuple *sdt;
-	struct scatterlist *dsgl;
-	struct scatterlist *psgl = scsi_prot_sglist(SCpnt);
-	void *daddr, *paddr;
+	void *daddr;
 	sector_t sector = start_sec;
 	int ppage_offset;
+	int dpage_offset;
+	struct sg_mapping_iter diter;
+	struct sg_mapping_iter piter;
 
 	BUG_ON(scsi_sg_count(SCpnt) == 0);
 	BUG_ON(scsi_prot_sg_count(SCpnt) == 0);
 
-	ppage_offset = 0;
-
-	/* For each data page */
-	scsi_for_each_sg(SCpnt, dsgl, scsi_sg_count(SCpnt), i) {
-		daddr = kmap_atomic(sg_page(dsgl)) + dsgl->offset;
-		paddr = kmap_atomic(sg_page(psgl)) + psgl->offset;
-
-		/* For each sector-sized chunk in data page */
-		for (j = 0; j < dsgl->length; j += scsi_debug_sector_size) {
+	sg_miter_start(&piter, scsi_prot_sglist(SCpnt),
+			scsi_prot_sg_count(SCpnt),
+			SG_MITER_ATOMIC | SG_MITER_FROM_SG);
+	sg_miter_start(&diter, scsi_sglist(SCpnt), scsi_sg_count(SCpnt),
+			SG_MITER_ATOMIC | SG_MITER_FROM_SG);
+
+	/* For each protection page */
+	while (sg_miter_next(&piter)) {
+		dpage_offset = 0;
+		if (WARN_ON(!sg_miter_next(&diter))) {
+			ret = 0x01;
+			goto out;
+		}
 
+		for (ppage_offset = 0; ppage_offset < piter.length;
+		     ppage_offset += sizeof(struct sd_dif_tuple)) {
 			/* If we're at the end of the current
-			 * protection page advance to the next one
+			 * data page advance to the next one
 			 */
-			if (ppage_offset >= psgl->length) {
-				kunmap_atomic(paddr);
-				psgl = sg_next(psgl);
-				BUG_ON(psgl == NULL);
-				paddr = kmap_atomic(sg_page(psgl))
-					+ psgl->offset;
-				ppage_offset = 0;
+			if (dpage_offset >= diter.length) {
+				if (WARN_ON(!sg_miter_next(&diter))) {
+					ret = 0x01;
+					goto out;
+				}
+				dpage_offset = 0;
 			}
 
-			sdt = paddr + ppage_offset;
+			sdt = piter.addr + ppage_offset;
+			daddr = diter.addr + dpage_offset;
 
-			ret = dif_verify(sdt, daddr + j, sector, ei_lba);
+			ret = dif_verify(sdt, daddr, sector, ei_lba);
 			if (ret) {
-				dump_sector(daddr + j, scsi_debug_sector_size);
+				dump_sector(daddr, scsi_debug_sector_size);
 				goto out;
 			}
 
 			sector++;
 			ei_lba++;
-			ppage_offset += sizeof(struct sd_dif_tuple);
+			dpage_offset += scsi_debug_sector_size;
 		}
-
-		kunmap_atomic(paddr);
-		kunmap_atomic(daddr);
+		diter.consumed = dpage_offset;
+		sg_miter_stop(&diter);
 	}
+	sg_miter_stop(&piter);
 
 	dif_copy_prot(SCpnt, start_sec, sectors, false);
 	dix_writes++;
@@ -1986,8 +1997,8 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 
 out:
 	dif_errors++;
-	kunmap_atomic(paddr);
-	kunmap_atomic(daddr);
+	sg_miter_stop(&diter);
+	sg_miter_stop(&piter);
 	return ret;
 }
 
@@ -2311,11 +2322,11 @@ static int resp_report_luns(struct scsi_cmnd * scp,
 static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 			    unsigned int num, struct sdebug_dev_info *devip)
 {
-	int i, j, ret = -1;
+	int j;
 	unsigned char *kaddr, *buf;
 	unsigned int offset;
-	struct scatterlist *sg;
 	struct scsi_data_buffer *sdb = scsi_in(scp);
+	struct sg_mapping_iter miter;
 
 	/* better not to use temporary buffer. */
 	buf = kmalloc(scsi_bufflen(scp), GFP_ATOMIC);
@@ -2328,22 +2339,20 @@ static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 	scsi_sg_copy_to_buffer(scp, buf, scsi_bufflen(scp));
 
 	offset = 0;
-	for_each_sg(sdb->table.sgl, sg, sdb->table.nents, i) {
-		kaddr = (unsigned char *)kmap_atomic(sg_page(sg));
-		if (!kaddr)
-			goto out;
+	sg_miter_start(&miter, sdb->table.sgl, sdb->table.nents,
+			SG_MITER_ATOMIC | SG_MITER_TO_SG);
 
-		for (j = 0; j < sg->length; j++)
-			*(kaddr + sg->offset + j) ^= *(buf + offset + j);
+	while (sg_miter_next(&miter)) {
+		kaddr = miter.addr;
+		for (j = 0; j < miter.length; j++)
+			*(kaddr + j) ^= *(buf + offset + j);
 
-		offset += sg->length;
-		kunmap_atomic(kaddr);
+		offset += miter.length;
 	}
-	ret = 0;
-out:
+	sg_miter_stop(&miter);
 	kfree(buf);
 
-	return ret;
+	return 0;
 }
 
 /* When timer goes off this function is called. */
-- 
1.8.3.2

