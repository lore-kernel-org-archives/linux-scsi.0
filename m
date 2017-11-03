From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v3 6/8] scsi/ipr: Use sgl_alloc_order() and sgl_free_order()
Date: Fri, 3 Nov 2017 15:23:37 -0700
Message-ID: <20171103222339.26540-7-bart.vanassche@wdc.com>
References: <20171103222339.26540-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:46889 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752425AbdKCWXo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2017 18:23:44 -0400
In-Reply-To: <20171103222339.26540-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Herbert Xu <herbert@gondor.apana.org.au>, Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

Use the sgl_alloc_order() and sgl_free_order() functions instead
of open coding these functions.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/Kconfig |  1 +
 drivers/scsi/ipr.c   | 49 ++++++++-----------------------------------------
 drivers/scsi/ipr.h   |  2 +-
 3 files changed, 10 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 766955318005..d918115afdca 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1059,6 +1059,7 @@ config SCSI_IPR
 	depends on PCI && SCSI && ATA
 	select FW_LOADER
 	select IRQ_POLL
+	select SGL_ALLOC
 	---help---
 	  This driver supports the IBM Power Linux family RAID adapters.
 	  This includes IBM pSeries 5712, 5703, 5709, and 570A, as well
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index f838bd73befa..6fed5db6255e 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3815,10 +3815,8 @@ static struct device_attribute ipr_iopoll_weight_attr = {
  **/
 static struct ipr_sglist *ipr_alloc_ucode_buffer(int buf_len)
 {
-	int sg_size, order, bsize_elem, num_elem, i, j;
+	int sg_size, order;
 	struct ipr_sglist *sglist;
-	struct scatterlist *scatterlist;
-	struct page *page;
 
 	/* Get the minimum size per scatter/gather element */
 	sg_size = buf_len / (IPR_MAX_SGLIST - 1);
@@ -3826,45 +3824,18 @@ static struct ipr_sglist *ipr_alloc_ucode_buffer(int buf_len)
 	/* Get the actual size per element */
 	order = get_order(sg_size);
 
-	/* Determine the actual number of bytes per element */
-	bsize_elem = PAGE_SIZE * (1 << order);
-
-	/* Determine the actual number of sg entries needed */
-	if (buf_len % bsize_elem)
-		num_elem = (buf_len / bsize_elem) + 1;
-	else
-		num_elem = buf_len / bsize_elem;
-
 	/* Allocate a scatter/gather list for the DMA */
-	sglist = kzalloc(sizeof(struct ipr_sglist) +
-			 (sizeof(struct scatterlist) * (num_elem - 1)),
-			 GFP_KERNEL);
-
+	sglist = kzalloc(sizeof(struct ipr_sglist), GFP_KERNEL);
 	if (sglist == NULL) {
 		ipr_trace;
 		return NULL;
 	}
-
-	scatterlist = sglist->scatterlist;
-	sg_init_table(scatterlist, num_elem);
-
 	sglist->order = order;
-	sglist->num_sg = num_elem;
-
-	/* Allocate a bunch of sg elements */
-	for (i = 0; i < num_elem; i++) {
-		page = alloc_pages(GFP_KERNEL, order);
-		if (!page) {
-			ipr_trace;
-
-			/* Free up what we already allocated */
-			for (j = i - 1; j >= 0; j--)
-				__free_pages(sg_page(&scatterlist[j]), order);
-			kfree(sglist);
-			return NULL;
-		}
-
-		sg_set_page(&scatterlist[i], page, 0, 0);
+	sglist->scatterlist = sgl_alloc_order(buf_len, order, false, GFP_KERNEL,
+					      &sglist->num_sg);
+	if (!sglist->scatterlist) {
+		kfree(sglist);
+		return NULL;
 	}
 
 	return sglist;
@@ -3882,11 +3853,7 @@ static struct ipr_sglist *ipr_alloc_ucode_buffer(int buf_len)
  **/
 static void ipr_free_ucode_buffer(struct ipr_sglist *sglist)
 {
-	int i;
-
-	for (i = 0; i < sglist->num_sg; i++)
-		__free_pages(sg_page(&sglist->scatterlist[i]), sglist->order);
-
+	sgl_free_order(sglist->scatterlist, sglist->order);
 	kfree(sglist);
 }
 
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index c7f0e9e3cd7d..93570734cbfb 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1454,7 +1454,7 @@ struct ipr_sglist {
 	u32 num_sg;
 	u32 num_dma_sg;
 	u32 buffer_len;
-	struct scatterlist scatterlist[1];
+	struct scatterlist *scatterlist;
 };
 
 enum ipr_sdt_state {
-- 
2.14.3
