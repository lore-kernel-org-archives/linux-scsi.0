From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 04/33] scsi: convert to using sg helpers
Date: Mon, 16 Jul 2007 11:47:18 +0200
Message-ID: <11845792672912-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9305 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759454AbXGPJsg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:36 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@SteelEye.com

This converts the SCSI mid layer to using the sg helpers for looking up
sg elements, instead of doing it manually.

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@SteelEye.com
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/scsi_lib.c  |   21 ++++++++++++---------
 include/scsi/scsi_cmnd.h |    2 +-
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1f5a07b..9fe66f8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -17,6 +17,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/hardirq.h>
+#include <linux/scatterlist.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -302,14 +303,15 @@ static int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl,
 	struct request_queue *q = rq->q;
 	int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	unsigned int data_len = 0, len, bytes, off;
+	struct scatterlist *sg;
 	struct page *page;
 	struct bio *bio = NULL;
 	int i, err, nr_vecs = 0;
 
-	for (i = 0; i < nsegs; i++) {
-		page = sgl[i].page;
-		off = sgl[i].offset;
-		len = sgl[i].length;
+	for_each_sg(sgl, sg, nsegs, i) {
+		page = sg->page;
+		off = sg->offset;
+		len = sg->length;
 		data_len += len;
 
 		while (len > 0) {
@@ -2240,18 +2242,19 @@ EXPORT_SYMBOL_GPL(scsi_target_unblock);
  *
  * Returns virtual address of the start of the mapped page
  */
-void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
+void *scsi_kmap_atomic_sg(struct scatterlist *sgl, int sg_count,
 			  size_t *offset, size_t *len)
 {
 	int i;
 	size_t sg_len = 0, len_complete = 0;
+	struct scatterlist *sg;
 	struct page *page;
 
 	WARN_ON(!irqs_disabled());
 
-	for (i = 0; i < sg_count; i++) {
+	for_each_sg(sgl, sg, sg_count, i) {
 		len_complete = sg_len; /* Complete sg-entries */
-		sg_len += sg[i].length;
+		sg_len += sg->length;
 		if (sg_len > *offset)
 			break;
 	}
@@ -2265,10 +2268,10 @@ void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 	}
 
 	/* Offset starting from the beginning of first page in this sg-entry */
-	*offset = *offset - len_complete + sg[i].offset;
+	*offset = *offset - len_complete + sg->offset;
 
 	/* Assumption: contiguous pages can be accessed as "page + i" */
-	page = nth_page(sg[i].page, (*offset >> PAGE_SHIFT));
+	page = nth_page(sg->page, (*offset >> PAGE_SHIFT));
 	*offset &= ~PAGE_MASK;
 
 	/* Bytes in this sg-entry from *offset to the end of the page */
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 53e1705..a059f1b 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -153,6 +153,6 @@ static inline int scsi_get_resid(struct scsi_cmnd *cmd)
 }
 
 #define scsi_for_each_sg(cmd, sg, nseg, __i)			\
-	for (__i = 0, sg = scsi_sglist(cmd); __i < (nseg); __i++, (sg)++)
+	for_each_sg(scsi_sglist(cmd), sg, nseg, __i)
 
 #endif /* _SCSI_SCSI_CMND_H */
-- 
1.5.3.rc0.90.gbaa79

