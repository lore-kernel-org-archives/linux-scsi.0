From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH B2/5] SCSI: support for allocating large scatterlists
Date: Tue, 24 Jul 2007 12:01:23 +0300
Message-ID: <46A5BFE3.7090505@panasas.com>
References: <46A5BCB6.9050102@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:11097 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759424AbXGXJCP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 05:02:15 -0400
In-Reply-To: <46A5BCB6.9050102@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


    A slightly revised sg-chaining patch to accommodate
    for the cleanup of sg-pools allocations.

    from Jens:
      This is what enables large commands. If we need to allocate an
      sgtable that doesn't fit in a single page, allocate several
      SCSI_MAX_SG_SEGMENTS sized tables and chain them together.

      SCSI defaults to large chained sg tables, if the arch supports it.

    Was-Signed-by: Jens Axboe <jens.axboe@oracle.com>

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c  |  136 +++++++++++++++++++++++++++++++++++++++++++---
 include/scsi/scsi_cmnd.h |    1 +
 2 files changed, 129 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 71532f9..7ee5591 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -54,7 +54,11 @@ struct scsi_host_sg_pool {
 };
 static struct scsi_host_sg_pool scsi_sg_pools[SG_MEMPOOL_NR];
 
-
+/*
+ * IO limit For archs that have sg chaining. This limit is totally arbitrary,
+ * a setting of 2048 will get you at least 8mb ios.
+ */
+#define SCSI_MAX_SG_CHAIN_SEGMENTS	2048
 
 static void scsi_run_queue(struct request_queue *q);
 
@@ -712,21 +716,123 @@ static unsigned scsi_sgtable_index(unsigned nents)
 
 struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
-	unsigned int pool = scsi_sgtable_index(cmd->use_sg);
-	struct scatterlist *sgl;
+	struct scsi_host_sg_pool *sgp;
+	struct scatterlist *sgl, *prev, *ret;
+	unsigned int index;
+	int this, left;
+
+	BUG_ON(!cmd->use_sg);
+
+	left = cmd->use_sg;
+	ret = prev = NULL;
+	do {
+		this = left;
+		if (this > SCSI_MAX_SG_SEGMENTS) {
+			this = SCSI_MAX_SG_SEGMENTS - 1;
+			index = SG_MEMPOOL_NR - 1;
+		} else
+			index = scsi_sgtable_index(this);
 
-	sgl = mempool_alloc(scsi_sg_pools[pool].pool, gfp_mask);
-	if (unlikely(!sgl))
-		return NULL;
+		left -= this;
+
+		sgp = scsi_sg_pools + index;
+
+		sgl = mempool_alloc(sgp->pool, gfp_mask);
+		if (unlikely(!sgl))
+			goto enomem;
+
+		memset(sgl, 0, sizeof(*sgl) * sgp->size);
+
+		/*
+		 * first loop through, set initial index and return value
+		 */
+		if (!ret) {
+			cmd->sg_pool = index;
+			ret = sgl;
+		}
+
+		/*
+		 * chain previous sglist, if any. we know the previous
+		 * sglist must be the biggest one, or we would not have
+		 * ended up doing another loop.
+		 */
+		if (prev)
+			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
+
+		/*
+		 * don't allow subsequent mempool allocs to sleep, it would
+		 * violate the mempool principle.
+		 */
+		gfp_mask &= ~__GFP_WAIT;
+		gfp_mask |= __GFP_HIGH;
+		prev = sgl;
+	} while (left);
+
+	/*
+	 * ->use_sg may get modified after dma mapping has potentially
+	 * shrunk the number of segments, so keep a copy of it for free.
+	 */
+	cmd->__use_sg = cmd->use_sg;
+	return ret;
+enomem:
+	if (ret) {
+		/*
+		 * Free entries chained off ret. Since we were trying to
+		 * allocate another sglist, we know that all entries are of
+		 * the max size.
+		 */
+		sgp = scsi_sg_pools + SG_MEMPOOL_NR - 1;
+		prev = ret;
+		ret = &ret[SCSI_MAX_SG_SEGMENTS - 1];
+
+		while ((sgl = sg_chain_ptr(ret)) != NULL) {
+			ret = &sgl[SCSI_MAX_SG_SEGMENTS - 1];
+			mempool_free(sgl, sgp->pool);
+		}
 
-	cmd->sg_pool = pool;
-	return sgl;
+		mempool_free(prev, sgp->pool);
+	}
+	return NULL;
 }
 
 EXPORT_SYMBOL(scsi_alloc_sgtable);
 
 void scsi_free_sgtable(struct scsi_cmnd *cmd)
 {
+	struct scatterlist *sgl = cmd->request_buffer;
+	struct scsi_host_sg_pool *sgp;
+
+	/*
+	 * if this is the biggest size sglist, check if we have
+	 * chained parts we need to free
+	 */
+	if (cmd->__use_sg > SCSI_MAX_SG_SEGMENTS) {
+		unsigned short this, left;
+		struct scatterlist *next;
+		unsigned int index;
+
+		left = cmd->__use_sg - (SCSI_MAX_SG_SEGMENTS - 1);
+		next = sg_chain_ptr(&sgl[SCSI_MAX_SG_SEGMENTS - 1]);
+		while (left && next) {
+			sgl = next;
+			this = left;
+			if (this > SCSI_MAX_SG_SEGMENTS) {
+				this = SCSI_MAX_SG_SEGMENTS - 1;
+				index = SG_MEMPOOL_NR - 1;
+			} else
+				index = scsi_sgtable_index(this);
+
+			left -= this;
+
+			sgp = scsi_sg_pools + index;
+
+			if (left)
+				next = sg_chain_ptr(&sgl[sgp->size - 1]);
+
+			mempool_free(sgl, sgp->pool);
+		}
+	}
+
 	mempool_free(cmd->request_buffer, scsi_sg_pools[cmd->sg_pool].pool);
 }
 
@@ -1550,8 +1656,22 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	if (!q)
 		return NULL;
 
+	/*
+	 * this limit is imposed by hardware restrictions
+	 */
 	blk_queue_max_hw_segments(q, shost->sg_tablesize);
+
+	/*
+	 * In the future, sg chaining support will be mandatory and this
+	 * ifdef can then go away. Right now we don't have all archs
+	 * converted, so better keep it safe.
+	 */
+#ifdef ARCH_HAS_SG_CHAIN
+	blk_queue_max_phys_segments(q, SCSI_MAX_SG_CHAIN_SEGMENTS);
+#else
 	blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
+#endif
+
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 279a4df..7d0b2de 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -72,6 +72,7 @@ struct scsi_cmnd {
 	/* These elements define the operation we ultimately want to perform */
 	unsigned short use_sg;	/* Number of pieces of scatter-gather */
 	unsigned short sg_pool;	/* pool index of allocated sg array */
+	unsigned short __use_sg;
 
 	unsigned underflow;	/* Return error if less than
 				   this amount is transferred */
-- 
1.5.2.2.249.g45fd


