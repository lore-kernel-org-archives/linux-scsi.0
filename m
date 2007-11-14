From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/2] SG: Convert SCSI to use scatterlist helpers for sg
	chaining
Date: Wed, 14 Nov 2007 12:47:33 +0100
Message-ID: <20071114114732.GC5064@kernel.dk>
References: <20071114114620.GA5064@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:25498 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbXKNLsg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Nov 2007 06:48:36 -0500
Received: from nelson.home.kernel.dk (nelson.home.kernel.dk [192.168.0.33])
	by kernel.dk (Postfix) with ESMTP id 4D47625718E
	for <linux-scsi@vger.kernel.org>; Wed, 14 Nov 2007 12:48:32 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20071114114620.GA5064@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


>From 7b2421e1c075d3c262e28d0598608141add2e7da Mon Sep 17 00:00:00 2001
From: Jens Axboe <jens.axboe@oracle.com>
Date: Wed, 14 Nov 2007 12:36:47 +0100
Subject: [PATCH] SG: Convert SCSI to use scatterlist helpers for sg chaining

Also change scsi_alloc_sgtable() to just return 0/failure, since it
maps to the command passed in. ->request_buffer is now no longer needed,
once drivers are adapted to use scsi_sglist() it can be killed.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/scsi_lib.c     |  137 ++++++-------------------------------------
 drivers/scsi/scsi_tgt_lib.c |    3 +-
 include/scsi/scsi_cmnd.h    |    7 +-
 3 files changed, 23 insertions(+), 124 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0e81e4c..1fb3c2e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -737,138 +737,40 @@ static inline unsigned int scsi_sgtable_index(unsigned short nents)
 	return index;
 }
 
-struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+static void scsi_sg_free(struct scatterlist *sgl, unsigned int nents)
 {
 	struct scsi_host_sg_pool *sgp;
-	struct scatterlist *sgl, *prev, *ret;
-	unsigned int index;
-	int this, left;
-
-	BUG_ON(!cmd->use_sg);
-
-	left = cmd->use_sg;
-	ret = prev = NULL;
-	do {
-		this = left;
-		if (this > SCSI_MAX_SG_SEGMENTS) {
-			this = SCSI_MAX_SG_SEGMENTS - 1;
-			index = SG_MEMPOOL_NR - 1;
-		} else
-			index = scsi_sgtable_index(this);
-
-		left -= this;
 
-		sgp = scsi_sg_pools + index;
-
-		sgl = mempool_alloc(sgp->pool, gfp_mask);
-		if (unlikely(!sgl))
-			goto enomem;
+	sgp = scsi_sg_pools + scsi_sgtable_index(nents);
+	mempool_free(sgl, sgp->pool);
+}
 
-		sg_init_table(sgl, sgp->size);
+static struct scatterlist *scsi_sg_alloc(unsigned int nents, gfp_t gfp_mask)
+{
+	struct scsi_host_sg_pool *sgp;
 
-		/*
-		 * first loop through, set initial index and return value
-		 */
-		if (!ret)
-			ret = sgl;
+	sgp = scsi_sg_pools + scsi_sgtable_index(nents);
+	return mempool_alloc(sgp->pool, gfp_mask);
+}
 
-		/*
-		 * chain previous sglist, if any. we know the previous
-		 * sglist must be the biggest one, or we would not have
-		 * ended up doing another loop.
-		 */
-		if (prev)
-			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
+int scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+{
+	int ret;
 
-		/*
-		 * if we have nothing left, mark the last segment as
-		 * end-of-list
-		 */
-		if (!left)
-			sg_mark_end(&sgl[this - 1]);
+	BUG_ON(!cmd->use_sg);
 
-		/*
-		 * don't allow subsequent mempool allocs to sleep, it would
-		 * violate the mempool principle.
-		 */
-		gfp_mask &= ~__GFP_WAIT;
-		gfp_mask |= __GFP_HIGH;
-		prev = sgl;
-	} while (left);
+	ret = __sg_alloc_table(&cmd->sg_table, cmd->use_sg, gfp_mask,
+					scsi_sg_alloc, scsi_sg_free);
 
-	/*
-	 * ->use_sg may get modified after dma mapping has potentially
-	 * shrunk the number of segments, so keep a copy of it for free.
-	 */
-	cmd->__use_sg = cmd->use_sg;
+	cmd->request_buffer = cmd->sg_table.sgl;
 	return ret;
-enomem:
-	if (ret) {
-		/*
-		 * Free entries chained off ret. Since we were trying to
-		 * allocate another sglist, we know that all entries are of
-		 * the max size.
-		 */
-		sgp = scsi_sg_pools + SG_MEMPOOL_NR - 1;
-		prev = ret;
-		ret = &ret[SCSI_MAX_SG_SEGMENTS - 1];
-
-		while ((sgl = sg_chain_ptr(ret)) != NULL) {
-			ret = &sgl[SCSI_MAX_SG_SEGMENTS - 1];
-			mempool_free(sgl, sgp->pool);
-		}
-
-		mempool_free(prev, sgp->pool);
-	}
-	return NULL;
 }
 
 EXPORT_SYMBOL(scsi_alloc_sgtable);
 
 void scsi_free_sgtable(struct scsi_cmnd *cmd)
 {
-	struct scatterlist *sgl = cmd->request_buffer;
-	struct scsi_host_sg_pool *sgp;
-
-	/*
-	 * if this is the biggest size sglist, check if we have
-	 * chained parts we need to free
-	 */
-	if (cmd->__use_sg > SCSI_MAX_SG_SEGMENTS) {
-		unsigned short this, left;
-		struct scatterlist *next;
-		unsigned int index;
-
-		left = cmd->__use_sg - (SCSI_MAX_SG_SEGMENTS - 1);
-		next = sg_chain_ptr(&sgl[SCSI_MAX_SG_SEGMENTS - 1]);
-		while (left && next) {
-			sgl = next;
-			this = left;
-			if (this > SCSI_MAX_SG_SEGMENTS) {
-				this = SCSI_MAX_SG_SEGMENTS - 1;
-				index = SG_MEMPOOL_NR - 1;
-			} else
-				index = scsi_sgtable_index(this);
-
-			left -= this;
-
-			sgp = scsi_sg_pools + index;
-
-			if (left)
-				next = sg_chain_ptr(&sgl[sgp->size - 1]);
-
-			mempool_free(sgl, sgp->pool);
-		}
-
-		/*
-		 * Restore original, will be freed below
-		 */
-		sgl = cmd->request_buffer;
-		sgp = scsi_sg_pools + SG_MEMPOOL_NR - 1;
-	} else
-		sgp = scsi_sg_pools + scsi_sgtable_index(cmd->__use_sg);
-
-	mempool_free(sgl, sgp->pool);
+	__sg_free_table(&cmd->sg_table, scsi_sg_free);
 }
 
 EXPORT_SYMBOL(scsi_free_sgtable);
@@ -1119,8 +1021,7 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 	/*
 	 * If sg table allocation fails, requeue request later.
 	 */
-	cmd->request_buffer = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
-	if (unlikely(!cmd->request_buffer)) {
+	if (unlikely(scsi_alloc_sgtable(cmd, GFP_ATOMIC))) {
 		scsi_unprep_request(req);
 		return BLKPREP_DEFER;
 	}
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index a91761c..742e1e3 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -359,8 +359,7 @@ static int scsi_tgt_init_cmd(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 	int count;
 
 	cmd->use_sg = rq->nr_phys_segments;
-	cmd->request_buffer = scsi_alloc_sgtable(cmd, gfp_mask);
-	if (!cmd->request_buffer)
+	if (scsi_alloc_sgtable(cmd, gfp_mask))
 		return -ENOMEM;
 
 	cmd->request_bufflen = rq->data_len;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 3f47e52..40f7c7c 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -8,7 +8,6 @@
 #include <linux/scatterlist.h>
 
 struct request;
-struct scatterlist;
 struct Scsi_Host;
 struct scsi_device;
 
@@ -68,8 +67,8 @@ struct scsi_cmnd {
 	void *request_buffer;		/* Actual requested buffer */
 
 	/* These elements define the operation we ultimately want to perform */
+	struct sg_table sg_table;
 	unsigned short use_sg;	/* Number of pieces of scatter-gather */
-	unsigned short __use_sg;
 
 	unsigned underflow;	/* Return error if less than
 				   this amount is transferred */
@@ -128,14 +127,14 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
-extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
+extern int scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
 extern void scsi_free_sgtable(struct scsi_cmnd *);
 
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
 
 #define scsi_sg_count(cmd) ((cmd)->use_sg)
-#define scsi_sglist(cmd) ((struct scatterlist *)(cmd)->request_buffer)
+#define scsi_sglist(cmd) ((cmd)->sg_table.sgl)
 #define scsi_bufflen(cmd) ((cmd)->request_bufflen)
 
 static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
-- 
1.5.3.GIT

-- 
Jens Axboe

