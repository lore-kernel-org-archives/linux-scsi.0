From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 4/8] nvmet/rdma: Use sgl_alloc() and sgl_free()
Date: Mon, 16 Oct 2017 15:49:36 -0700
Message-ID: <20171016224940.1332-5-bart.vanassche@wdc.com>
References: <20171016224940.1332-1-bart.vanassche@wdc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20171016224940.1332-1-bart.vanassche@wdc.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>
List-Id: linux-scsi@vger.kernel.org

Use the sgl_alloc() and sgl_free() functions instead of open coding
these functions.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/target/Kconfig |  1 +
 drivers/nvme/target/rdma.c  | 63 +++------------------------------------------
 2 files changed, 5 insertions(+), 59 deletions(-)

diff --git a/drivers/nvme/target/Kconfig b/drivers/nvme/target/Kconfig
index 4d9715630e21..5f4f8b16685f 100644
--- a/drivers/nvme/target/Kconfig
+++ b/drivers/nvme/target/Kconfig
@@ -29,6 +29,7 @@ config NVME_TARGET_RDMA
 	tristate "NVMe over Fabrics RDMA target support"
 	depends on INFINIBAND
 	depends on NVME_TARGET
+	select SGL_ALLOC
 	help
 	  This enables the NVMe RDMA target support, which allows exporting NVMe
 	  devices over RDMA.
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 76d2bb793afe..363d44c10b68 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -185,59 +185,6 @@ nvmet_rdma_put_rsp(struct nvmet_rdma_rsp *rsp)
 	spin_unlock_irqrestore(&rsp->queue->rsps_lock, flags);
 }
 
-static void nvmet_rdma_free_sgl(struct scatterlist *sgl, unsigned int nents)
-{
-	struct scatterlist *sg;
-	int count;
-
-	if (!sgl || !nents)
-		return;
-
-	for_each_sg(sgl, sg, nents, count)
-		__free_page(sg_page(sg));
-	kfree(sgl);
-}
-
-static int nvmet_rdma_alloc_sgl(struct scatterlist **sgl, unsigned int *nents,
-		u32 length)
-{
-	struct scatterlist *sg;
-	struct page *page;
-	unsigned int nent;
-	int i = 0;
-
-	nent = DIV_ROUND_UP(length, PAGE_SIZE);
-	sg = kmalloc_array(nent, sizeof(struct scatterlist), GFP_KERNEL);
-	if (!sg)
-		goto out;
-
-	sg_init_table(sg, nent);
-
-	while (length) {
-		u32 page_len = min_t(u32, length, PAGE_SIZE);
-
-		page = alloc_page(GFP_KERNEL);
-		if (!page)
-			goto out_free_pages;
-
-		sg_set_page(&sg[i], page, page_len, 0);
-		length -= page_len;
-		i++;
-	}
-	*sgl = sg;
-	*nents = nent;
-	return 0;
-
-out_free_pages:
-	while (i > 0) {
-		i--;
-		__free_page(sg_page(&sg[i]));
-	}
-	kfree(sg);
-out:
-	return NVME_SC_INTERNAL;
-}
-
 static int nvmet_rdma_alloc_cmd(struct nvmet_rdma_device *ndev,
 			struct nvmet_rdma_cmd *c, bool admin)
 {
@@ -484,7 +431,7 @@ static void nvmet_rdma_release_rsp(struct nvmet_rdma_rsp *rsp)
 	}
 
 	if (rsp->req.sg != &rsp->cmd->inline_sg)
-		nvmet_rdma_free_sgl(rsp->req.sg, rsp->req.sg_cnt);
+		sgl_free(rsp->req.sg);
 
 	if (unlikely(!list_empty_careful(&queue->rsp_wr_wait_list)))
 		nvmet_rdma_process_wr_wait_list(queue);
@@ -620,16 +567,14 @@ static u16 nvmet_rdma_map_sgl_keyed(struct nvmet_rdma_rsp *rsp,
 	u32 len = get_unaligned_le24(sgl->length);
 	u32 key = get_unaligned_le32(sgl->key);
 	int ret;
-	u16 status;
 
 	/* no data command? */
 	if (!len)
 		return 0;
 
-	status = nvmet_rdma_alloc_sgl(&rsp->req.sg, &rsp->req.sg_cnt,
-			len);
-	if (status)
-		return status;
+	rsp->req.sg = sgl_alloc(len, GFP_KERNEL, &rsp->req.sg_cnt);
+	if (!rsp->req.sg)
+		return NVME_SC_INTERNAL;
 
 	ret = rdma_rw_ctx_init(&rsp->rw, cm_id->qp, cm_id->port_num,
 			rsp->req.sg, rsp->req.sg_cnt, 0, addr, key,
-- 
2.14.2
