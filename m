From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 6/8] scsi/ipr: Use sgl_alloc_order() and sgl_free_order()
Date: Thu, 12 Oct 2017 15:45:48 -0700
Message-ID: <20171012224550.25440-7-bart.vanassche@wdc.com>
References: <20171012224550.25440-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:30937 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753774AbdJLWrP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Oct 2017 18:47:15 -0400
In-Reply-To: <20171012224550.25440-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Brian King <brking@linux.vnet.ibm.com>

Use the sgl_alloc_order() and sgl_free_order() functions instead
of open coding these functions.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: linux-scsi@vger.kernel.org
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/Kconfig |  1 +
 drivers/scsi/ipr.c   | 50 +++++++++-----------------------------------------
 drivers/scsi/ipr.h   |  2 +-
 3 files changed, 11 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 41366339b950..d11e75e76195 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1058,6 +1058,7 @@ config SCSI_IPR
 	depends on PCI && SCSI && ATA
 	select FW_LOADER
 	select IRQ_POLL
+	select SGL_ALLOC
 	---help---
 	  This driver supports the IBM Power Linux family RAID adapters.
 	  This includes IBM pSeries 5712, 5703, 5709, and 570A, as well
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index f838bd73befa..b197995a6f34 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -76,6 +76,7 @@
 #include <linux/hdreg.h>
 #include <linux/reboot.h>
 #include <linux/stringify.h>
+#include <linux/sgl_alloc.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/processor.h>
@@ -3815,10 +3816,8 @@ static struct device_attribute ipr_iopoll_weight_attr = {
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
@@ -3826,45 +3825,18 @@ static struct ipr_sglist *ipr_alloc_ucode_buffer(int buf_len)
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
+	sglist->scatterlist = sgl_alloc_order(buf_len, order, &sglist->num_sg,
+					      GFP_KERNEL, false);
+	if (!sglist->scatterlist) {
+		kfree(sglist);
+		return NULL;
 	}
 
 	return sglist;
@@ -3882,11 +3854,7 @@ static struct ipr_sglist *ipr_alloc_ucode_buffer(int buf_len)
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
2.14.2
