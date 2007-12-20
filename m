From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 4/5] sg_ring: Convert core scsi code to sg_ring.
Date: Thu, 20 Dec 2007 16:51:59 +1100
Message-ID: <200712201651.59283.rusty@rustcorp.com.au>
References: <200712201645.19035.rusty@rustcorp.com.au> <200712201649.31254.rusty@rustcorp.com.au> <200712201650.42299.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:52197 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbXLTFwH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Dec 2007 00:52:07 -0500
In-Reply-To: <200712201650.42299.rusty@rustcorp.com.au>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

(Update: explicit sg member to replace use_sg indicating it's a scatter gather)

Details:
1) The use_sg (and __use_sg) fields are removed: sg_rings contain their own
   count, and it's confusing to have two.
2) use_sg used to do double duty: if non-zero, it meant that the request_buffer
   actually pointed to a scatterlist.  Replace this with an explicit sg member:
   if NULL, then request_buffer contains a pointer to the raw data.
3) The scsi_sg_count(), scsi_sglist() and scsi_bufflen() wrappers are removed.
   scsi_sg_count() is no longer necessary, scsi_sglist() is now cmd->sg, and
   scsi_bufflen should just be cmd->request_bufflen if you need it.

If nothing else, the simplification of this logic shows why I prefer
sg_ring over scatterlist chaining.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -617,20 +617,21 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd 
 	ses->cmd_len = scmd->cmd_len;
 	memcpy(ses->cmnd, scmd->cmnd, sizeof(scmd->cmnd));
 	ses->data_direction = scmd->sc_data_direction;
+	ses->sg = scmd->sg;
 	ses->bufflen = scmd->request_bufflen;
 	ses->buffer = scmd->request_buffer;
-	ses->use_sg = scmd->use_sg;
 	ses->resid = scmd->resid;
 	ses->result = scmd->result;
 
 	if (sense_bytes) {
 		scmd->request_bufflen = min_t(unsigned,
 		                       sizeof(scmd->sense_buffer), sense_bytes);
-		sg_init_one(&ses->sense_sgl, scmd->sense_buffer,
-		                                       scmd->request_bufflen);
-		scmd->request_buffer = &ses->sense_sgl;
+
+		sg_ring_single(&ses->sense_sg.ring, scmd->sense_buffer,
+			       scmd->request_bufflen);
+		scmd->sg = &ses->sense_sg.ring;
+		scmd->request_buffer = NULL;
 		scmd->sc_data_direction = DMA_FROM_DEVICE;
-		scmd->use_sg = 1;
 		memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
 		scmd->cmnd[0] = REQUEST_SENSE;
 		scmd->cmnd[4] = scmd->request_bufflen;
@@ -639,7 +640,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd 
 		scmd->request_buffer = NULL;
 		scmd->request_bufflen = 0;
 		scmd->sc_data_direction = DMA_NONE;
-		scmd->use_sg = 0;
+		scmd->sg = NULL;
 		if (cmnd) {
 			memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
 			memcpy(scmd->cmnd, cmnd, cmnd_size);
@@ -678,7 +679,7 @@ void scsi_eh_restore_cmnd(struct scsi_cm
 	scmd->sc_data_direction = ses->data_direction;
 	scmd->request_bufflen = ses->bufflen;
 	scmd->request_buffer = ses->buffer;
-	scmd->use_sg = ses->use_sg;
+	scmd->sg = ses->sg;
 	scmd->resid = ses->resid;
 	scmd->result = ses->result;
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -17,7 +17,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/hardirq.h>
-#include <linux/scatterlist.h>
+#include <linux/sg_ring.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -737,21 +737,41 @@ static inline unsigned int scsi_sgtable_
 	return index;
 }
 
-struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+static void free_sgring(struct sg_ring *head)
 {
 	struct scsi_host_sg_pool *sgp;
-	struct scatterlist *sgl, *prev, *ret;
+	struct sg_ring *sg, *n;
+
+	/* Free any other entries in the ring. */
+	list_for_each_entry_safe(sg, n, &head->list, list) {
+		list_del(&sg->list);
+		sgp = scsi_sg_pools + scsi_sgtable_index(sg->max);
+		mempool_free(sg, sgp->pool);
+	}
+
+	/* Now free the head of the ring. */
+	BUG_ON(!list_empty(&head->list));
+
+	sgp = scsi_sg_pools + scsi_sgtable_index(head->max);
+	mempool_free(head, sgp->pool);
+}
+
+struct sg_ring *scsi_alloc_sgring(struct scsi_cmnd *cmd, unsigned int num,
+				  gfp_t gfp_mask)
+{
+	struct scsi_host_sg_pool *sgp;
+	struct sg_ring *sg, *ret;
 	unsigned int index;
 	int this, left;
 
-	BUG_ON(!cmd->use_sg);
+	BUG_ON(!num);
 
-	left = cmd->use_sg;
-	ret = prev = NULL;
+	left = num;
+	ret = NULL;
 	do {
 		this = left;
 		if (this > SCSI_MAX_SG_SEGMENTS) {
-			this = SCSI_MAX_SG_SEGMENTS - 1;
+			this = SCSI_MAX_SG_SEGMENTS;
 			index = SG_MEMPOOL_NR - 1;
 		} else
 			index = scsi_sgtable_index(this);
@@ -760,32 +780,20 @@ struct scatterlist *scsi_alloc_sgtable(s
 
 		sgp = scsi_sg_pools + index;
 
-		sgl = mempool_alloc(sgp->pool, gfp_mask);
-		if (unlikely(!sgl))
+		sg = mempool_alloc(sgp->pool, gfp_mask);
+		if (unlikely(!sg))
 			goto enomem;
 
-		sg_init_table(sgl, sgp->size);
+		sg_ring_init(sg, sgp->size);
 
 		/*
-		 * first loop through, set initial index and return value
+		 * first loop through, set return value, otherwise
+		 * attach this to the tail.
 		 */
 		if (!ret)
-			ret = sgl;
-
-		/*
-		 * chain previous sglist, if any. we know the previous
-		 * sglist must be the biggest one, or we would not have
-		 * ended up doing another loop.
-		 */
-		if (prev)
-			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
-
-		/*
-		 * if we have nothing left, mark the last segment as
-		 * end-of-list
-		 */
-		if (!left)
-			sg_mark_end(&sgl[this - 1]);
+			ret = sg;
+		else
+			list_add_tail(&sg->list, &ret->list);
 
 		/*
 		 * don't allow subsequent mempool allocs to sleep, it would
@@ -793,85 +801,21 @@ struct scatterlist *scsi_alloc_sgtable(s
 		 */
 		gfp_mask &= ~__GFP_WAIT;
 		gfp_mask |= __GFP_HIGH;
-		prev = sgl;
 	} while (left);
 
-	/*
-	 * ->use_sg may get modified after dma mapping has potentially
-	 * shrunk the number of segments, so keep a copy of it for free.
-	 */
-	cmd->__use_sg = cmd->use_sg;
 	return ret;
 enomem:
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
+	if (ret)
+		free_sgring(ret);
 	return NULL;
 }
+EXPORT_SYMBOL(scsi_alloc_sgring);
 
-EXPORT_SYMBOL(scsi_alloc_sgtable);
-
-void scsi_free_sgtable(struct scsi_cmnd *cmd)
+void scsi_free_sgring(struct scsi_cmnd *cmd)
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
+	free_sgring(cmd->sg);
 }
-
-EXPORT_SYMBOL(scsi_free_sgtable);
+EXPORT_SYMBOL(scsi_free_sgring);
 
 /*
  * Function:    scsi_release_buffers()
@@ -892,13 +836,14 @@ EXPORT_SYMBOL(scsi_free_sgtable);
  */
 static void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
-	if (cmd->use_sg)
-		scsi_free_sgtable(cmd);
+	if (cmd->sg)
+		scsi_free_sgring(cmd);
 
 	/*
 	 * Zero these out.  They now point to freed memory, and it is
 	 * dangerous to hang onto the pointers.
 	 */
+	cmd->sg = NULL;
 	cmd->request_buffer = NULL;
 	cmd->request_bufflen = 0;
 }
@@ -976,7 +921,10 @@ void scsi_io_completion(struct scsi_cmnd
 	SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, "
 				      "%d bytes done.\n",
 				      req->nr_sectors, good_bytes));
-	SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n", cmd->use_sg));
+	SCSI_LOG_HLCOMPLETE(1, printk("sg elems %d%s\n",
+				      cmd->sg ? cmd->sg->num : 0,
+				      cmd->sg && !list_empty(&cmd->sg->list) ?
+				      "+" : ""));
 
 	if (clear_errors)
 		req->errors = 0;
@@ -1106,20 +1054,20 @@ static int scsi_init_io(struct scsi_cmnd
 static int scsi_init_io(struct scsi_cmnd *cmd)
 {
 	struct request     *req = cmd->request;
-	int		   count;
 
 	/*
 	 * We used to not use scatter-gather for single segment request,
 	 * but now we do (it makes highmem I/O easier to support without
 	 * kmapping pages)
 	 */
-	cmd->use_sg = req->nr_phys_segments;
 
+	cmd->request_buffer = NULL;
 	/*
 	 * If sg table allocation fails, requeue request later.
 	 */
-	cmd->request_buffer = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
-	if (unlikely(!cmd->request_buffer)) {
+	cmd->sg = scsi_alloc_sgring(cmd, req->nr_phys_segments, GFP_ATOMIC);
+	if (unlikely(!cmd->sg)) {
+		BUG();
 		scsi_unprep_request(req);
 		return BLKPREP_DEFER;
 	}
@@ -1134,9 +1082,7 @@ static int scsi_init_io(struct scsi_cmnd
 	 * Next, walk the list, and fill in the addresses and sizes of
 	 * each segment.
 	 */
-	count = blk_rq_map_sg(req->q, req, cmd->request_buffer);
-	BUG_ON(count > cmd->use_sg);
-	cmd->use_sg = count;
+	blk_rq_map_sg_ring(req->q, req, cmd->sg);
 	return BLKPREP_OK;
 }
 
@@ -1193,7 +1139,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_d
 
 		cmd->request_bufflen = 0;
 		cmd->request_buffer = NULL;
-		cmd->use_sg = 0;
+		cmd->sg = NULL;
 		req->buffer = NULL;
 	}
 
@@ -1751,7 +1697,7 @@ int __init scsi_init_queue(void)
 
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
-		int size = sgp->size * sizeof(struct scatterlist);
+		int size = sizeof(struct sg_ring) + sgp->size * sizeof(struct scatterlist);
 
 		sgp->slab = kmem_cache_create(sgp->name, size, 0,
 				SLAB_HWCACHE_ALIGN, NULL);
diff --git a/drivers/scsi/scsi_lib_dma.c b/drivers/scsi/scsi_lib_dma.c
--- a/drivers/scsi/scsi_lib_dma.c
+++ b/drivers/scsi/scsi_lib_dma.c
@@ -15,22 +15,21 @@
  * scsi_dma_map - perform DMA mapping against command's sg lists
  * @cmd:	scsi command
  *
- * Returns the number of sg lists actually used, zero if the sg lists
- * is NULL, or -ENOMEM if the mapping failed.
+ * Returns -ENOMEM if the mapping failed, or the number of elements mapped
+ * (ie. sg_ring_num(cmd->sg)).
  */
 int scsi_dma_map(struct scsi_cmnd *cmd)
 {
-	int nseg = 0;
+	if (cmd->sg) {
+		struct device *dev = cmd->device->host->shost_gendev.parent;
+		int err;
 
-	if (scsi_sg_count(cmd)) {
-		struct device *dev = cmd->device->host->shost_gendev.parent;
-
-		nseg = dma_map_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
-				  cmd->sc_data_direction);
-		if (unlikely(!nseg))
-			return -ENOMEM;
+		err = dma_map_sg_ring(dev, cmd->sg, cmd->sc_data_direction);
+		if (err)
+			return err;
+		return sg_ring_num(cmd->sg);
 	}
-	return nseg;
+	return 0;
 }
 EXPORT_SYMBOL(scsi_dma_map);
 
@@ -40,11 +39,10 @@ EXPORT_SYMBOL(scsi_dma_map);
  */
 void scsi_dma_unmap(struct scsi_cmnd *cmd)
 {
-	if (scsi_sg_count(cmd)) {
+	if (cmd->sg) {
 		struct device *dev = cmd->device->host->shost_gendev.parent;
 
-		dma_unmap_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
-			     cmd->sc_data_direction);
+		dma_unmap_sg_ring(dev, cmd->sg, cmd->sc_data_direction);
 	}
 }
 EXPORT_SYMBOL(scsi_dma_unmap);
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -331,7 +331,7 @@ static void scsi_tgt_cmd_done(struct scs
 
 	scsi_tgt_uspace_send_status(cmd, tcmd->itn_id, tcmd->tag);
 
-	if (cmd->request_buffer)
+	if (cmd->sg)
 		scsi_free_sgtable(cmd);
 
 	queue_work(scsi_tgtd, &tcmd->work);
@@ -358,15 +358,14 @@ static int scsi_tgt_init_cmd(struct scsi
 	struct request *rq = cmd->request;
 	int count;
 
-	cmd->use_sg = rq->nr_phys_segments;
-	cmd->request_buffer = scsi_alloc_sgtable(cmd, gfp_mask);
-	if (!cmd->request_buffer)
+	cmd->sg = scsi_alloc_sgring(cmd, rq->nr_phys_segments, gfp_mask);
+	if (!cmd->sg)
 		return -ENOMEM;
-
+	cmd->request_buffer = NULL;
 	cmd->request_bufflen = rq->data_len;
 
-	dprintk("cmd %p cnt %d %lu\n", cmd, cmd->use_sg, rq_data_dir(rq));
-	count = blk_rq_map_sg(rq->q, rq, cmd->request_buffer);
+	dprintk("cmd %p cnt %d %lu\n", cmd, rq->nr_phys_segments, rq_data_dir(rq));
+	count = blk_rq_map_sg_ring(rq->q, rq, cmd->request_buffer);
 	BUG_ON(count > cmd->use_sg);
 	cmd->use_sg = count;
 	return 0;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -65,11 +65,8 @@ struct scsi_cmnd {
 	unsigned request_bufflen;	/* Actual request size */
 
 	struct timer_list eh_timeout;	/* Used to time out the command. */
-	void *request_buffer;		/* Actual requested buffer */
-
-	/* These elements define the operation we ultimately want to perform */
-	unsigned short use_sg;	/* Number of pieces of scatter-gather */
-	unsigned short __use_sg;
+	struct sg_ring *sg;	/* if it's a scatter-gather, otherwise... */
+	void *request_buffer;	/* Actual requested buffer */
 
 	unsigned underflow;	/* Return error if less than
 				   this amount is transferred */
@@ -128,15 +125,11 @@ extern void *scsi_kmap_atomic_sg(struct 
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
-extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
-extern void scsi_free_sgtable(struct scsi_cmnd *);
+extern struct sg_ring *scsi_alloc_sgring(struct scsi_cmnd *, unsigned, gfp_t);
+extern void scsi_free_sgring(struct scsi_cmnd *);
 
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
-
-#define scsi_sg_count(cmd) ((cmd)->use_sg)
-#define scsi_sglist(cmd) ((struct scatterlist *)(cmd)->request_buffer)
-#define scsi_bufflen(cmd) ((cmd)->request_bufflen)
 
 static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
 {
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -1,7 +1,7 @@
 #ifndef _SCSI_SCSI_EH_H
 #define _SCSI_SCSI_EH_H
 
-#include <linux/scatterlist.h>
+#include <linux/sg_ring.h>
 
 #include <scsi/scsi_cmnd.h>
 struct scsi_device;
@@ -75,10 +75,10 @@ struct scsi_eh_save {
 
 	void *buffer;
 	unsigned bufflen;
-	unsigned short use_sg;
+	struct sg_ring *sg;
 	int resid;
 
-	struct scatterlist sense_sgl;
+	DECLARE_SG_RING(sense_sg, 1);
 };
 
 extern void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd,
