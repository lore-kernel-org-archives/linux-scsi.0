From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH A3/5] SCSI: sg-chaining over scsi_sgtable
Date: Tue, 24 Jul 2007 11:59:13 +0300
Message-ID: <46A5BF61.20509@panasas.com>
References: <46A5BCB6.9050102@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13248 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761874AbXGXJAQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 05:00:16 -0400
In-Reply-To: <46A5BCB6.9050102@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


   Based on Jens code for sg-chaining but over scsi_sgtable implementation
   - Previous scsi_{alloc,free}_sgtable() renamed to scsi_{alloc,free}_sgtable_page()
   - scsi_{alloc,free}_sgtable() using the above now supports sg-chaining with multiple
     sgtable allocations.
   - Report arbitrary default of 2048 to block layer.

    from Jens:
      This is what enables large commands. If we need to allocate an
      sgtable that doesn't fit in a single page, allocate several
      SCSI_MAX_SG_SEGMENTS sized tables and chain them together.
      SCSI defaults to large chained sg tables, if the arch supports it.

 Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c |   89 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 262128c..13870b5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -59,6 +59,12 @@ static inline unsigned scsi_pool_size(int pool)
 	return scsi_sg_pools[pool].size;
 }
 
+/*
+ * IO limit For archs that have sg chaining. This limit is totally arbitrary,
+ * a setting of 2048 will get you at least 8mb ios.
+ */
+#define SCSI_MAX_SG_CHAIN_SEGMENTS	2048
+
 static void scsi_run_queue(struct request_queue *q);
 
 /*
@@ -713,7 +719,7 @@ static unsigned scsi_sgtable_index(unsigned nents)
 	return -1;
 }
 
-struct scsi_sgtable *scsi_alloc_sgtable(int sg_count, gfp_t gfp_mask)
+static struct scsi_sgtable *scsi_alloc_sgtable_page(int sg_count, gfp_t gfp_mask)
 {
 	unsigned int pool = scsi_sgtable_index(sg_count);
 	struct scsi_sgtable *sgt;
@@ -727,12 +733,77 @@ struct scsi_sgtable *scsi_alloc_sgtable(int sg_count, gfp_t gfp_mask)
 	sgt->sg_pool = pool;
 	return sgt;
 }
+
+struct scsi_sgtable *scsi_alloc_sgtable(int sg_count, gfp_t gfp_mask)
+{
+	struct scsi_sgtable *sgt, *prev, *ret;
+
+	if (sg_count <= SCSI_MAX_SG_SEGMENTS)
+		return scsi_alloc_sgtable_page(sg_count, gfp_mask);
+
+	ret = prev = NULL;
+	do {
+		int this;
+
+		if (sg_count > SCSI_MAX_SG_SEGMENTS) {
+			this = SCSI_MAX_SG_SEGMENTS - 1; /* room for chain */
+		} else {
+			this = sg_count;
+		}
+
+		sgt = scsi_alloc_sgtable_page(this, gfp_mask);
+		/*
+		 * FIXME: since second and on allocations are done 
+		 * ~__GFP_WAIT we can fail more easilly, but nothing
+		 * prevents us from trying smaller pools and chaining
+		 * more arrays. The last patch in the series does just
+		 * that.
+ 		 */
+		if (unlikely(!sgt))
+			goto enomem;
+
+		/* first loop through, set return value */
+		if (!ret)
+			ret = sgt;
+
+		/* chain previous sglist, if any */
+		if (prev)
+			sg_chain(prev->sglist, scsi_pool_size(prev->sg_pool),
+			                                           sgt->sglist);
+
+		/*
+		 * don't allow subsequent mempool allocs to sleep, it would
+		 * violate the mempool principle.
+		 */
+		gfp_mask &= ~__GFP_WAIT;
+		gfp_mask |= __GFP_HIGH;
+		sg_count -= this;
+		prev = sgt;
+	} while (sg_count);
+
+	return ret;
+enomem:
+	if (ret)
+		scsi_free_sgtable(ret);
+	return NULL;
+}
 EXPORT_SYMBOL(scsi_alloc_sgtable);
 
-void scsi_free_sgtable(struct scsi_sgtable *sgt)
+static void scsi_free_sgtable_page(struct scsi_sgtable *sgt)
 {
 	mempool_free(sgt, scsi_sg_pools[sgt->sg_pool].pool);
 }
+
+static void scsi_free_sgtable(struct scsi_sgtable *sgt)
+{
+	do {
+		struct scatterlist *next, *here_last;
+		here_last = &sgt->sglist[scsi_pool_size(sgt->sg_pool) - 1];
+		next = sg_is_chain(here_last) ? sg_chain_ptr(here_last) : NULL;
+		scsi_free_sgtable_page(sgt);
+		sgt = next ? ((struct scsi_sgtable*)next) - 1 : NULL;
+	} while(sgt);
+}
 EXPORT_SYMBOL(scsi_free_sgtable);
 
 /*
@@ -1550,8 +1621,22 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
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
-- 
1.5.2.2.249.g45fd


