From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 1/3] lib/sg_pool.c: improve APIs for allocating sg pool
Date: Sun, 28 Apr 2019 15:39:30 +0800
Message-ID: <20190428073932.9898-2-ming.lei@redhat.com>
References: <20190428073932.9898-1-ming.lei@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190428073932.9898-1-ming.lei@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>, "Ewan D . Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Chuck Lever <chuck.lever@oracle.com>, netdev@vger.kernel.org, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Now sg_alloc_table_chained() allows user to provide one preallocated
SGL, and returns simply if the requested number isn't bigger than size of
that SGL. This way is nice for inline small SGL to small IO request.

However, scattergather code only allows that size of the 1st preallocated
SGL is SG_CHUNK_SIZE(128), and this way isn't flexiable and useful, because
it may take too much memory(4KB) to pre-allocat one such size SGL for each
IO request, especially block layer always pre-allocates IO request structure.
Instead it is more friendly to pre-allocate one small size inline SGL just
for small IO.

Introduces one extra parameter to sg_alloc_table_chained() and sg_free_table_chained()
for specifying size of the pre-allocated SGL, then the 'first_chunk' SGL can
include any number of entries.

Both __sg_free_table() and __sg_alloc_table() assumes that each SGL has
same size except for the last one, changes code to allow both to accept
variant size for the 1st preallocated SGL.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: netdev@vger.kernel.org
Cc: linux-nvme@lists.infradead.org
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/nvme/host/fc.c            |  7 ++++---
 drivers/nvme/host/rdma.c          |  7 ++++---
 drivers/nvme/target/loop.c        |  4 ++--
 drivers/scsi/scsi_lib.c           | 10 ++++++----
 include/linux/scatterlist.h       | 11 +++++++----
 lib/scatterlist.c                 | 36 +++++++++++++++++++++++-------------
 lib/sg_pool.c                     | 37 +++++++++++++++++++++++++++----------
 net/sunrpc/xprtrdma/svc_rdma_rw.c |  5 +++--
 8 files changed, 76 insertions(+), 41 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 31637f8ef22e..9b42ef82a273 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2112,7 +2112,8 @@ nvme_fc_map_data(struct nvme_fc_ctrl *ctrl, struct request *rq,
 
 	freq->sg_table.sgl = freq->first_sgl;
 	ret = sg_alloc_table_chained(&freq->sg_table,
-			blk_rq_nr_phys_segments(rq), freq->sg_table.sgl);
+			blk_rq_nr_phys_segments(rq), freq->sg_table.sgl,
+			SG_CHUNK_SIZE);
 	if (ret)
 		return -ENOMEM;
 
@@ -2122,7 +2123,7 @@ nvme_fc_map_data(struct nvme_fc_ctrl *ctrl, struct request *rq,
 	freq->sg_cnt = fc_dma_map_sg(ctrl->lport->dev, freq->sg_table.sgl,
 				op->nents, dir);
 	if (unlikely(freq->sg_cnt <= 0)) {
-		sg_free_table_chained(&freq->sg_table, true);
+		sg_free_table_chained(&freq->sg_table, SG_CHUNK_SIZE);
 		freq->sg_cnt = 0;
 		return -EFAULT;
 	}
@@ -2148,7 +2149,7 @@ nvme_fc_unmap_data(struct nvme_fc_ctrl *ctrl, struct request *rq,
 
 	nvme_cleanup_cmd(rq);
 
-	sg_free_table_chained(&freq->sg_table, true);
+	sg_free_table_chained(&freq->sg_table, SG_CHUNK_SIZE);
 
 	freq->sg_cnt = 0;
 }
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 11a5ecae78c8..2022a196d2a7 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1155,7 +1155,7 @@ static void nvme_rdma_unmap_data(struct nvme_rdma_queue *queue,
 				    WRITE ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 
 	nvme_cleanup_cmd(rq);
-	sg_free_table_chained(&req->sg_table, true);
+	sg_free_table_chained(&req->sg_table, SG_CHUNK_SIZE);
 }
 
 static int nvme_rdma_set_sg_null(struct nvme_command *c)
@@ -1270,7 +1270,8 @@ static int nvme_rdma_map_data(struct nvme_rdma_queue *queue,
 
 	req->sg_table.sgl = req->first_sgl;
 	ret = sg_alloc_table_chained(&req->sg_table,
-			blk_rq_nr_phys_segments(rq), req->sg_table.sgl);
+			blk_rq_nr_phys_segments(rq), req->sg_table.sgl,
+			SG_CHUNK_SIZE);
 	if (ret)
 		return -ENOMEM;
 
@@ -1310,7 +1311,7 @@ static int nvme_rdma_map_data(struct nvme_rdma_queue *queue,
 			req->nents, rq_data_dir(rq) ==
 			WRITE ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 out_free_table:
-	sg_free_table_chained(&req->sg_table, true);
+	sg_free_table_chained(&req->sg_table, SG_CHUNK_SIZE);
 	return ret;
 }
 
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index b9f623ab01f3..b3e2f42a3644 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -77,7 +77,7 @@ static void nvme_loop_complete_rq(struct request *req)
 	struct nvme_loop_iod *iod = blk_mq_rq_to_pdu(req);
 
 	nvme_cleanup_cmd(req);
-	sg_free_table_chained(&iod->sg_table, true);
+	sg_free_table_chained(&iod->sg_table, SG_CHUNK_SIZE);
 	nvme_complete_rq(req);
 }
 
@@ -171,7 +171,7 @@ static blk_status_t nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		iod->sg_table.sgl = iod->first_sgl;
 		if (sg_alloc_table_chained(&iod->sg_table,
 				blk_rq_nr_phys_segments(req),
-				iod->sg_table.sgl))
+				iod->sg_table.sgl, SG_CHUNK_SIZE))
 			return BLK_STS_RESOURCE;
 
 		iod->req.sg = iod->sg_table.sgl;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6b2570a5642d..c37263c123eb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -541,9 +541,9 @@ static void scsi_uninit_cmd(struct scsi_cmnd *cmd)
 static void scsi_mq_free_sgtables(struct scsi_cmnd *cmd)
 {
 	if (cmd->sdb.table.nents)
-		sg_free_table_chained(&cmd->sdb.table, true);
+		sg_free_table_chained(&cmd->sdb.table, SG_CHUNK_SIZE);
 	if (scsi_prot_sg_count(cmd))
-		sg_free_table_chained(&cmd->prot_sdb->table, true);
+		sg_free_table_chained(&cmd->prot_sdb->table, SG_CHUNK_SIZE);
 }
 
 static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
@@ -976,7 +976,8 @@ static blk_status_t scsi_init_sgtable(struct request *req,
 	 * If sg table allocation fails, requeue request later.
 	 */
 	if (unlikely(sg_alloc_table_chained(&sdb->table,
-			blk_rq_nr_phys_segments(req), sdb->table.sgl)))
+			blk_rq_nr_phys_segments(req), sdb->table.sgl,
+			SG_CHUNK_SIZE)))
 		return BLK_STS_RESOURCE;
 
 	/* 
@@ -1030,7 +1031,8 @@ blk_status_t scsi_init_io(struct scsi_cmnd *cmd)
 		ivecs = blk_rq_count_integrity_sg(rq->q, rq->bio);
 
 		if (sg_alloc_table_chained(&prot_sdb->table, ivecs,
-				prot_sdb->table.sgl)) {
+				prot_sdb->table.sgl,
+				SG_CHUNK_SIZE)) {
 			ret = BLK_STS_RESOURCE;
 			goto out_free_sgtables;
 		}
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index b4be960c7e5d..e1d4cf5ab28a 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -266,10 +266,11 @@ int sg_split(struct scatterlist *in, const int in_mapped_nents,
 typedef struct scatterlist *(sg_alloc_fn)(unsigned int, gfp_t);
 typedef void (sg_free_fn)(struct scatterlist *, unsigned int);
 
-void __sg_free_table(struct sg_table *, unsigned int, bool, sg_free_fn *);
+void __sg_free_table(struct sg_table *, unsigned int, unsigned int,
+		     sg_free_fn *);
 void sg_free_table(struct sg_table *);
 int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int,
-		     struct scatterlist *, gfp_t, sg_alloc_fn *);
+		     struct scatterlist *, unsigned int, gfp_t, sg_alloc_fn *);
 int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
 int __sg_alloc_table_from_pages(struct sg_table *sgt, struct page **pages,
 				unsigned int n_pages, unsigned int offset,
@@ -331,9 +332,11 @@ size_t sg_zero_buffer(struct scatterlist *sgl, unsigned int nents,
 #endif
 
 #ifdef CONFIG_SG_POOL
-void sg_free_table_chained(struct sg_table *table, bool first_chunk);
+void sg_free_table_chained(struct sg_table *table,
+			   unsigned nents_first_chunk);
 int sg_alloc_table_chained(struct sg_table *table, int nents,
-			   struct scatterlist *first_chunk);
+			   struct scatterlist *first_chunk,
+			   unsigned nents_first_chunk);
 #endif
 
 /*
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 739dc9fe2c55..77ec8eec3fd0 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -181,7 +181,8 @@ static void sg_kfree(struct scatterlist *sg, unsigned int nents)
  * __sg_free_table - Free a previously mapped sg table
  * @table:	The sg table header to use
  * @max_ents:	The maximum number of entries per single scatterlist
- * @skip_first_chunk: don't free the (preallocated) first scatterlist chunk
+ * @nents_first_chunk: Number of entries int the (preallocated) first
+ * 	scatterlist chunk, 0 means no such preallocated first chunk
  * @free_fn:	Free function
  *
  *  Description:
@@ -191,9 +192,10 @@ static void sg_kfree(struct scatterlist *sg, unsigned int nents)
  *
  **/
 void __sg_free_table(struct sg_table *table, unsigned int max_ents,
-		     bool skip_first_chunk, sg_free_fn *free_fn)
+		     unsigned int nents_first_chunk, sg_free_fn *free_fn)
 {
 	struct scatterlist *sgl, *next;
+	unsigned curr_max_ents = nents_first_chunk ?: max_ents;
 
 	if (unlikely(!table->sgl))
 		return;
@@ -209,9 +211,9 @@ void __sg_free_table(struct sg_table *table, unsigned int max_ents,
 		 * sg_size is then one less than alloc size, since the last
 		 * element is the chain pointer.
 		 */
-		if (alloc_size > max_ents) {
-			next = sg_chain_ptr(&sgl[max_ents - 1]);
-			alloc_size = max_ents;
+		if (alloc_size > curr_max_ents) {
+			next = sg_chain_ptr(&sgl[curr_max_ents - 1]);
+			alloc_size = curr_max_ents;
 			sg_size = alloc_size - 1;
 		} else {
 			sg_size = alloc_size;
@@ -219,11 +221,12 @@ void __sg_free_table(struct sg_table *table, unsigned int max_ents,
 		}
 
 		table->orig_nents -= sg_size;
-		if (skip_first_chunk)
-			skip_first_chunk = false;
+		if (nents_first_chunk)
+			nents_first_chunk = 0;
 		else
 			free_fn(sgl, alloc_size);
 		sgl = next;
+		curr_max_ents = max_ents;
 	}
 
 	table->sgl = NULL;
@@ -246,6 +249,8 @@ EXPORT_SYMBOL(sg_free_table);
  * @table:	The sg table header to use
  * @nents:	Number of entries in sg list
  * @max_ents:	The maximum number of entries the allocator returns per call
+ * @nents_first_chunk: Number of entries int the (preallocated) first
+ * 	scatterlist chunk, 0 means no such preallocated chunk provided by user
  * @gfp_mask:	GFP allocation mask
  * @alloc_fn:	Allocator to use
  *
@@ -262,10 +267,13 @@ EXPORT_SYMBOL(sg_free_table);
  **/
 int __sg_alloc_table(struct sg_table *table, unsigned int nents,
 		     unsigned int max_ents, struct scatterlist *first_chunk,
-		     gfp_t gfp_mask, sg_alloc_fn *alloc_fn)
+		     unsigned int nents_first_chunk, gfp_t gfp_mask,
+		     sg_alloc_fn *alloc_fn)
 {
 	struct scatterlist *sg, *prv;
 	unsigned int left;
+	unsigned curr_max_ents = nents_first_chunk ?: max_ents;
+	unsigned prv_max_ents;
 
 	memset(table, 0, sizeof(*table));
 
@@ -281,8 +289,8 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents,
 	do {
 		unsigned int sg_size, alloc_size = left;
 
-		if (alloc_size > max_ents) {
-			alloc_size = max_ents;
+		if (alloc_size > curr_max_ents) {
+			alloc_size = curr_max_ents;
 			sg_size = alloc_size - 1;
 		} else
 			sg_size = alloc_size;
@@ -316,7 +324,7 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents,
 		 * If this is not the first mapping, chain previous part.
 		 */
 		if (prv)
-			sg_chain(prv, max_ents, sg);
+			sg_chain(prv, prv_max_ents, sg);
 		else
 			table->sgl = sg;
 
@@ -327,6 +335,8 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents,
 			sg_mark_end(&sg[sg_size - 1]);
 
 		prv = sg;
+		prv_max_ents = curr_max_ents;
+		curr_max_ents = max_ents;
 	} while (left);
 
 	return 0;
@@ -349,9 +359,9 @@ int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
 	int ret;
 
 	ret = __sg_alloc_table(table, nents, SG_MAX_SINGLE_ALLOC,
-			       NULL, gfp_mask, sg_kmalloc);
+			       NULL, 0, gfp_mask, sg_kmalloc);
 	if (unlikely(ret))
-		__sg_free_table(table, SG_MAX_SINGLE_ALLOC, false, sg_kfree);
+		__sg_free_table(table, SG_MAX_SINGLE_ALLOC, 0, sg_kfree);
 
 	return ret;
 }
diff --git a/lib/sg_pool.c b/lib/sg_pool.c
index d1c1e6388eaa..b3b8cf62ff49 100644
--- a/lib/sg_pool.c
+++ b/lib/sg_pool.c
@@ -69,18 +69,27 @@ static struct scatterlist *sg_pool_alloc(unsigned int nents, gfp_t gfp_mask)
 /**
  * sg_free_table_chained - Free a previously mapped sg table
  * @table:	The sg table header to use
- * @first_chunk: was first_chunk not NULL in sg_alloc_table_chained?
+ * @nents_first_chunk: size of the first_chunk SGL passed to
+ *		sg_alloc_table_chained
  *
  *  Description:
  *    Free an sg table previously allocated and setup with
  *    sg_alloc_table_chained().
  *
+ *    @nents_first_chunk has to be same with that same parameter passed
+ *    to sg_alloc_table_chained().
+ *
  **/
-void sg_free_table_chained(struct sg_table *table, bool first_chunk)
+void sg_free_table_chained(struct sg_table *table,
+		unsigned nents_first_chunk)
 {
-	if (first_chunk && table->orig_nents <= SG_CHUNK_SIZE)
+	if (table->orig_nents <= nents_first_chunk)
 		return;
-	__sg_free_table(table, SG_CHUNK_SIZE, first_chunk, sg_pool_free);
+
+	if (nents_first_chunk == 1)
+		nents_first_chunk = 0;
+
+	__sg_free_table(table, SG_CHUNK_SIZE, nents_first_chunk, sg_pool_free);
 }
 EXPORT_SYMBOL_GPL(sg_free_table_chained);
 
@@ -89,31 +98,39 @@ EXPORT_SYMBOL_GPL(sg_free_table_chained);
  * @table:	The sg table header to use
  * @nents:	Number of entries in sg list
  * @first_chunk: first SGL
+ * @nents_first_chunk: number of the SGL of @first_chunk
  *
  *  Description:
  *    Allocate and chain SGLs in an sg table. If @nents@ is larger than
- *    SG_CHUNK_SIZE a chained sg table will be setup.
+ *    @nents_first_chunk a chained sg table will be setup.
  *
  **/
 int sg_alloc_table_chained(struct sg_table *table, int nents,
-		struct scatterlist *first_chunk)
+		struct scatterlist *first_chunk, unsigned nents_first_chunk)
 {
 	int ret;
 
 	BUG_ON(!nents);
 
-	if (first_chunk) {
-		if (nents <= SG_CHUNK_SIZE) {
+	if (first_chunk && nents_first_chunk) {
+		if (nents <= nents_first_chunk) {
 			table->nents = table->orig_nents = nents;
 			sg_init_table(table->sgl, nents);
 			return 0;
 		}
 	}
 
+	/* User supposes that the 1st SGL includes real entry */
+	if (nents_first_chunk == 1) {
+		first_chunk = NULL;
+		nents_first_chunk = 0;
+	}
+
 	ret = __sg_alloc_table(table, nents, SG_CHUNK_SIZE,
-			       first_chunk, GFP_ATOMIC, sg_pool_alloc);
+			       first_chunk, nents_first_chunk,
+			       GFP_ATOMIC, sg_pool_alloc);
 	if (unlikely(ret))
-		sg_free_table_chained(table, (bool)first_chunk);
+		sg_free_table_chained(table, nents_first_chunk);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(sg_alloc_table_chained);
diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index 2121c9b4d275..48fe3b16b0d9 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -73,7 +73,8 @@ svc_rdma_get_rw_ctxt(struct svcxprt_rdma *rdma, unsigned int sges)
 
 	ctxt->rw_sg_table.sgl = ctxt->rw_first_sgl;
 	if (sg_alloc_table_chained(&ctxt->rw_sg_table, sges,
-				   ctxt->rw_sg_table.sgl)) {
+				   ctxt->rw_sg_table.sgl,
+				   SG_CHUNK_SIZE)) {
 		kfree(ctxt);
 		ctxt = NULL;
 	}
@@ -84,7 +85,7 @@ svc_rdma_get_rw_ctxt(struct svcxprt_rdma *rdma, unsigned int sges)
 static void svc_rdma_put_rw_ctxt(struct svcxprt_rdma *rdma,
 				 struct svc_rdma_rw_ctxt *ctxt)
 {
-	sg_free_table_chained(&ctxt->rw_sg_table, true);
+	sg_free_table_chained(&ctxt->rw_sg_table, SG_CHUNK_SIZE);
 
 	spin_lock(&rdma->sc_rw_ctxt_lock);
 	list_add(&ctxt->rw_list, &rdma->sc_rw_ctxts);
-- 
2.9.5
