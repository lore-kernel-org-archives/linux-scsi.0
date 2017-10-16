From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 8/8] scsi/pmcraid: Use sgl_alloc_order() and sgl_free_order()
Date: Mon, 16 Oct 2017 15:49:40 -0700
Message-ID: <20171016224940.1332-9-bart.vanassche@wdc.com>
References: <20171016224940.1332-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:22354 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755926AbdJPWto (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2017 18:49:44 -0400
In-Reply-To: <20171016224940.1332-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>

Use the sgl_alloc_order() and sgl_free_order() functions instead
of open coding these functions.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
---
 drivers/scsi/Kconfig   |  1 +
 drivers/scsi/pmcraid.c | 43 ++++---------------------------------------
 drivers/scsi/pmcraid.h |  2 +-
 3 files changed, 6 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d11e75e76195..632200ec36a6 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1576,6 +1576,7 @@ config ZFCP
 config SCSI_PMCRAID
 	tristate "PMC SIERRA Linux MaxRAID adapter support"
 	depends on PCI && SCSI && NET
+	select SGL_ALLOC
 	---help---
 	  This driver supports the PMC SIERRA MaxRAID adapters.
 
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index b4d6cd8cd1ad..95fc0352f9bb 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3232,12 +3232,7 @@ static int pmcraid_build_ioadl(
  */
 static void pmcraid_free_sglist(struct pmcraid_sglist *sglist)
 {
-	int i;
-
-	for (i = 0; i < sglist->num_sg; i++)
-		__free_pages(sg_page(&(sglist->scatterlist[i])),
-			     sglist->order);
-
+	sgl_free_order(sglist->scatterlist, sglist->order);
 	kfree(sglist);
 }
 
@@ -3254,50 +3249,20 @@ static void pmcraid_free_sglist(struct pmcraid_sglist *sglist)
 static struct pmcraid_sglist *pmcraid_alloc_sglist(int buflen)
 {
 	struct pmcraid_sglist *sglist;
-	struct scatterlist *scatterlist;
-	struct page *page;
-	int num_elem, i, j;
 	int sg_size;
 	int order;
-	int bsize_elem;
 
 	sg_size = buflen / (PMCRAID_MAX_IOADLS - 1);
 	order = (sg_size > 0) ? get_order(sg_size) : 0;
-	bsize_elem = PAGE_SIZE * (1 << order);
-
-	/* Determine the actual number of sg entries needed */
-	if (buflen % bsize_elem)
-		num_elem = (buflen / bsize_elem) + 1;
-	else
-		num_elem = buflen / bsize_elem;
 
 	/* Allocate a scatter/gather list for the DMA */
-	sglist = kzalloc(sizeof(struct pmcraid_sglist) +
-			 (sizeof(struct scatterlist) * (num_elem - 1)),
-			 GFP_KERNEL);
-
+	sglist = kzalloc(sizeof(struct pmcraid_sglist), GFP_KERNEL);
 	if (sglist == NULL)
 		return NULL;
 
-	scatterlist = sglist->scatterlist;
-	sg_init_table(scatterlist, num_elem);
 	sglist->order = order;
-	sglist->num_sg = num_elem;
-	sg_size = buflen;
-
-	for (i = 0; i < num_elem; i++) {
-		page = alloc_pages(GFP_KERNEL|GFP_DMA|__GFP_ZERO, order);
-		if (!page) {
-			for (j = i - 1; j >= 0; j--)
-				__free_pages(sg_page(&scatterlist[j]), order);
-			kfree(sglist);
-			return NULL;
-		}
-
-		sg_set_page(&scatterlist[i], page,
-			sg_size < bsize_elem ? sg_size : bsize_elem, 0);
-		sg_size -= bsize_elem;
-	}
+	sgl_alloc_order(buflen, order, false,
+			GFP_KERNEL | GFP_DMA | __GFP_ZERO, &sglist->num_sg);
 
 	return sglist;
 }
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index 44da91712115..754ef30927e2 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -542,7 +542,7 @@ struct pmcraid_sglist {
 	u32 order;
 	u32 num_sg;
 	u32 num_dma_sg;
-	struct scatterlist scatterlist[1];
+	struct scatterlist *scatterlist;
 };
 
 /* page D0 inquiry data of focal point resource */
-- 
2.14.2
