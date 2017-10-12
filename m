From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 3/8] nvmet/fc: Use sgl_alloc() and sgl_free()
Date: Thu, 12 Oct 2017 15:45:45 -0700
Message-ID: <20171012224550.25440-4-bart.vanassche@wdc.com>
References: <20171012224550.25440-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:62882 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753615AbdJLWrO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Oct 2017 18:47:14 -0400
In-Reply-To: <20171012224550.25440-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Bart Van Assche <bart.vanassche@wdc.com>, Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>, James Smart <james.smart@broadcom.com>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>

Use the sgl_alloc() and sgl_free() functions instead of open coding
these functions.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James Smart <james.smart@broadcom.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/target/Kconfig |  1 +
 drivers/nvme/target/fc.c    | 37 +++----------------------------------
 2 files changed, 4 insertions(+), 34 deletions(-)

diff --git a/drivers/nvme/target/Kconfig b/drivers/nvme/target/Kconfig
index 03e4ab65fe77..4d9715630e21 100644
--- a/drivers/nvme/target/Kconfig
+++ b/drivers/nvme/target/Kconfig
@@ -39,6 +39,7 @@ config NVME_TARGET_FC
 	tristate "NVMe over Fabrics FC target driver"
 	depends on NVME_TARGET
 	depends on HAS_DMA
+	select SGL_ALLOC
 	help
 	  This enables the NVMe FC target support, which allows exporting NVMe
 	  devices over FC.
diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 58e010bdda3e..02084539de5b 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -16,6 +16,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
+#include <linux/sgl_alloc.h>
 #include <linux/slab.h>
 #include <linux/blk-mq.h>
 #include <linux/parser.h>
@@ -1683,31 +1684,12 @@ static int
 nvmet_fc_alloc_tgt_pgs(struct nvmet_fc_fcp_iod *fod)
 {
 	struct scatterlist *sg;
-	struct page *page;
 	unsigned int nent;
-	u32 page_len, length;
-	int i = 0;
 
-	length = fod->total_length;
-	nent = DIV_ROUND_UP(length, PAGE_SIZE);
-	sg = kmalloc_array(nent, sizeof(struct scatterlist), GFP_KERNEL);
+	sg = sgl_alloc(fod->total_length, &nent, GFP_KERNEL);
 	if (!sg)
 		goto out;
 
-	sg_init_table(sg, nent);
-
-	while (length) {
-		page_len = min_t(u32, length, PAGE_SIZE);
-
-		page = alloc_page(GFP_KERNEL);
-		if (!page)
-			goto out_free_pages;
-
-		sg_set_page(&sg[i], page, page_len, 0);
-		length -= page_len;
-		i++;
-	}
-
 	fod->data_sg = sg;
 	fod->data_sg_cnt = nent;
 	fod->data_sg_cnt = fc_dma_map_sg(fod->tgtport->dev, sg, nent,
@@ -1717,14 +1699,6 @@ nvmet_fc_alloc_tgt_pgs(struct nvmet_fc_fcp_iod *fod)
 
 	return 0;
 
-out_free_pages:
-	while (i > 0) {
-		i--;
-		__free_page(sg_page(&sg[i]));
-	}
-	kfree(sg);
-	fod->data_sg = NULL;
-	fod->data_sg_cnt = 0;
 out:
 	return NVME_SC_INTERNAL;
 }
@@ -1732,18 +1706,13 @@ nvmet_fc_alloc_tgt_pgs(struct nvmet_fc_fcp_iod *fod)
 static void
 nvmet_fc_free_tgt_pgs(struct nvmet_fc_fcp_iod *fod)
 {
-	struct scatterlist *sg;
-	int count;
-
 	if (!fod->data_sg || !fod->data_sg_cnt)
 		return;
 
 	fc_dma_unmap_sg(fod->tgtport->dev, fod->data_sg, fod->data_sg_cnt,
 				((fod->io_dir == NVMET_FCP_WRITE) ?
 					DMA_FROM_DEVICE : DMA_TO_DEVICE));
-	for_each_sg(fod->data_sg, sg, fod->data_sg_cnt, count)
-		__free_page(sg_page(sg));
-	kfree(fod->data_sg);
+	sgl_free(fod->data_sg);
 	fod->data_sg = NULL;
 	fod->data_sg_cnt = 0;
 }
-- 
2.14.2
