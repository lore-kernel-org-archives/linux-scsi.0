From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 3/8] nvmet/fc: Use sgl_alloc() and sgl_free()
Date: Mon, 16 Oct 2017 15:49:35 -0700
Message-ID: <20171016224940.1332-4-bart.vanassche@wdc.com>
References: <20171016224940.1332-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:63940 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755798AbdJPWtn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2017 18:49:43 -0400
In-Reply-To: <20171016224940.1332-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>, James Smart <james.smart@broadcom.com>, Sagi Grimberg <sagi@grimberg.me>

Use the sgl_alloc() and sgl_free() functions instead of open coding
these functions.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James Smart <james.smart@broadcom.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/target/Kconfig |  1 +
 drivers/nvme/target/fc.c    | 36 ++----------------------------------
 2 files changed, 3 insertions(+), 34 deletions(-)

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
index 58e010bdda3e..20f96038c272 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1683,31 +1683,12 @@ static int
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
+	sg = sgl_alloc(fod->total_length, GFP_KERNEL, &nent);
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
@@ -1717,14 +1698,6 @@ nvmet_fc_alloc_tgt_pgs(struct nvmet_fc_fcp_iod *fod)
 
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
@@ -1732,18 +1705,13 @@ nvmet_fc_alloc_tgt_pgs(struct nvmet_fc_fcp_iod *fod)
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
