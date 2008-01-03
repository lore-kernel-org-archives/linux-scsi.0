From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3/3] scsi: convert core to sg_ring
Date: Thu, 3 Jan 2008 19:55:46 +1100
Message-ID: <200801031955.46239.rusty@rustcorp.com.au>
References: <200801031800.02537.rusty@rustcorp.com.au> <200801031950.12090.rusty@rustcorp.com.au> <200801031954.33083.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:59393 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbYACI4D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jan 2008 03:56:03 -0500
In-Reply-To: <200801031954.33083.rusty@rustcorp.com.au>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org

A 'struct sg_ring *sg' element is added to struct scsi_cmd, and the
use_sg and __use_sg fields are removed.  If this field is null,
request_buffer point to the data (as was previously indicated by
use_sg == 0).

To ease transition, scsi_sglist() is now a backwards-compat routine
which chains the sg_ring entries so they can be iterated using
sg_next().  Once all the drivers which actually want to use chained
sgs are converted to sg_ring, the remaining drivers can revert to
using simple sg arrays.

The backwards-compat conversion is placed under an (always-on) config
option (CONFIG_SCSI_SG_CHAIN).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/scsi/Kconfig        |    6 +
 drivers/scsi/scsi_error.c   |   15 +--
 drivers/scsi/scsi_lib.c     |  219 +++++++++++++++++++++-----------------------
 drivers/scsi/scsi_lib_dma.c |   27 ++---
 drivers/scsi/scsi_tgt_lib.c |   17 +--
 include/scsi/scsi_cmnd.h    |   38 +++++--
 include/scsi/scsi_eh.h      |    6 -
 7 files changed, 170 insertions(+), 158 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -29,6 +29,12 @@ config SCSI
 
 	  However, do not compile this as a module if your root file system
 	  (the one containing the directory /) is located on a SCSI device.
+
+config SCSI_SG_CHAIN
+	bool
+	default y
+	---help---
+	  Support sg chaining for older SCSI drivers.
 
 config SCSI_DMA
 	bool
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
@@ -34,12 +34,20 @@
 #define SG_MEMPOOL_NR		ARRAY_SIZE(scsi_sg_pools)
 #define SG_MEMPOOL_SIZE		2
 
+/* If we support old-style SG chaining, we need an extra sg element to overwrite
+ * with the chain's next pointer. */
+#ifdef CONFIG_SCSI_SG_CHAIN
+#define SCSI_SG_PAD 1
+#else
+#define SCSI_SG_PAD 0
+#endif
+
 /*
  * The maximum number of SG segments that we will put inside a scatterlist
  * (unless chaining is used). Should ideally fit inside a single page, to
  * avoid a higher order allocation.
  */
-#define SCSI_MAX_SG_SEGMENTS	128
+#define SCSI_MAX_SG_SEGMENTS	(128 - SCSI_SG_PAD)
 
 struct scsi_host_sg_pool {
 	size_t		size;
@@ -707,7 +715,7 @@ static inline unsigned int scsi_sgtable_
 {
 	unsigned int index;
 
-	switch (nents) {
+	switch (nents + SCSI_SG_PAD) {
 	case 1 ... 8:
 		index = 0;
 		break;
@@ -737,21 +745,41 @@ static inline unsigned int scsi_sgtable_
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
@@ -760,32 +788,20 @@ struct scatterlist *scsi_alloc_sgtable(s
 
 		sgp = scsi_sg_pools + index;
 
-		sgl = mempool_alloc(sgp->pool, gfp_mask);
-		if (unlikely(!sgl))
+		sg = mempool_alloc(sgp->pool, gfp_mask);
+		if (unlikely(!sg))
 			goto enomem;
 
-		sg_init_table(sgl, sgp->size);
+		sg_ring_init(sg, sgp->size - SCSI_SG_PAD);
 
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
@@ -793,85 +809,21 @@ struct scatterlist *scsi_alloc_sgtable(s
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
@@ -892,13 +844,14 @@ EXPORT_SYMBOL(scsi_free_sgtable);
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
@@ -976,7 +929,10 @@ void scsi_io_completion(struct scsi_cmnd
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
@@ -1107,20 +1063,20 @@ static int scsi_init_io(struct scsi_cmnd
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
@@ -1135,9 +1091,7 @@ static int scsi_init_io(struct scsi_cmnd
 	 * Next, walk the list, and fill in the addresses and sizes of
 	 * each segment.
 	 */
-	count = blk_rq_map_sg(req->q, req, cmd->request_buffer);
-	BUG_ON(count > cmd->use_sg);
-	cmd->use_sg = count;
+	blk_rq_map_sg_ring(req->q, req, cmd->sg);
 	return BLKPREP_OK;
 }
 
@@ -1206,7 +1160,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_d
 
 		cmd->request_bufflen = 0;
 		cmd->request_buffer = NULL;
-		cmd->use_sg = 0;
+		cmd->sg = NULL;
 		req->buffer = NULL;
 	}
 
@@ -1765,7 +1719,7 @@ int __init scsi_init_queue(void)
 
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
-		int size = sgp->size * sizeof(struct scatterlist);
+		int size = sizeof(struct sg_ring) + sgp->size * sizeof(struct scatterlist);
 
 		sgp->slab = kmem_cache_create(sgp->name, size, 0,
 				SLAB_HWCACHE_ALIGN, NULL);
@@ -2523,3 +2477,46 @@ void scsi_kunmap_atomic_sg(void *virt)
 	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
 }
 EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
+
+#ifdef CONFIG_SCSI_SG_CHAIN
+int scsi_sg_count(struct scsi_cmnd *cmd)
+{
+	return sg_ring_num(cmd->sg);
+}
+EXPORT_SYMBOL(scsi_sg_count);
+
+struct scatterlist *scsi_sglist(struct scsi_cmnd *cmd)
+{
+	struct sg_ring *sg;
+	struct scatterlist *last = NULL;
+
+	if (!cmd->sg)
+		return NULL;
+
+	/* Convert to a chained sg. */
+	for (sg = cmd->sg; sg; sg = sg_ring_next(sg, cmd->sg)) {
+		unsigned int i;
+
+		/* We currently don't set up any 0-len sg rings, but
+		 * let's handle it anyway. */
+		if (!sg->num)
+			continue;
+
+		if (last)
+			last[1].page_link = ((unsigned long)&sg->sg[0] | 0x01);
+
+		/* Clear any end or chain bits. */
+		for (i = 0; i < sg->num; i++)
+			sg->sg[i].page_link &= ~0x3;
+		last = &sg->sg[sg->num - 1];
+	}
+
+	/* End marker */
+	last->page_link |= 0x02;
+
+	/* Assumes first one isn't empty. */
+	return &cmd->sg->sg[0];
+}
+EXPORT_SYMBOL(scsi_sglist);
+	
+#endif /* CONFIG_SCSI_SG_CHAIN */
diff --git a/drivers/scsi/scsi_lib_dma.c b/drivers/scsi/scsi_lib_dma.c
--- a/drivers/scsi/scsi_lib_dma.c
+++ b/drivers/scsi/scsi_lib_dma.c
@@ -5,6 +5,7 @@
 #include <linux/blkdev.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/sg_ring.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -15,22 +16,21 @@
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
 
@@ -40,11 +40,10 @@ EXPORT_SYMBOL(scsi_dma_map);
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
@@ -331,8 +331,8 @@ static void scsi_tgt_cmd_done(struct scs
 
 	scsi_tgt_uspace_send_status(cmd, tcmd->itn_id, tcmd->tag);
 
-	if (cmd->request_buffer)
-		scsi_free_sgtable(cmd);
+	if (cmd->sg)
+		scsi_free_sgring(cmd);
 
 	queue_work(scsi_tgtd, &tcmd->work);
 }
@@ -356,19 +356,15 @@ static int scsi_tgt_init_cmd(struct scsi
 static int scsi_tgt_init_cmd(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
 	struct request *rq = cmd->request;
-	int count;
 
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
-	BUG_ON(count > cmd->use_sg);
-	cmd->use_sg = count;
+	dprintk("cmd %p cnt %d %lu\n", cmd, rq->nr_phys_segments, rq_data_dir(rq));
+	blk_rq_map_sg_ring(rq->q, rq, cmd->request_buffer);
 	return 0;
 }
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -5,7 +5,7 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/timer.h>
-#include <linux/scatterlist.h>
+#include <linux/sg_ring.h>
 
 struct request;
 struct scatterlist;
@@ -17,8 +17,12 @@ struct scsi_pointer {
 struct scsi_pointer {
 	char *ptr;		/* data pointer */
 	int this_residual;	/* left in this buffer */
+#ifdef CONFIG_SCSI_SG_CHAIN
 	struct scatterlist *buffer;	/* which buffer */
 	int buffers_residual;	/* how many buffers left */
+#endif
+	struct sg_ring *sg;	/* which buffer ring */
+	int buffers_offset;	/* how many buffers of this sg already used */
 
         dma_addr_t dma_handle;
 
@@ -66,11 +70,8 @@ struct scsi_cmnd {
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
@@ -130,14 +131,28 @@ extern void *scsi_kmap_atomic_sg(struct 
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
-extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
-extern void scsi_free_sgtable(struct scsi_cmnd *);
+extern struct sg_ring *scsi_alloc_sgring(struct scsi_cmnd *, unsigned, gfp_t);
+extern void scsi_free_sgring(struct scsi_cmnd *);
 
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
 
-#define scsi_sg_count(cmd) ((cmd)->use_sg)
-#define scsi_sglist(cmd) ((struct scatterlist *)(cmd)->request_buffer)
+#ifdef CONFIG_SCSI_SG_CHAIN
+/* Deprecated: use sg_ring_num(cmd->sg) */
+extern int scsi_sg_count(struct scsi_cmnd *cmd);
+
+/* Deprecated: this routine converts the sg_ring into an sg chain:
+ * modern drivers should use cmd->sg directly. */
+extern struct scatterlist *scsi_sglist(struct scsi_cmnd *cmd);
+
+/* Deprecated: the modern way is to use sg_ring_for_each(cmd->sg,
+ * sgring, i): sgring->sg[i] is the current element.  Note that i does
+ * not always increase (it goes back to 0 when sgring is iterated). */
+#define scsi_for_each_sg(cmd, sg, nseg, __i)			\
+	for_each_sg(scsi_sglist(cmd), sg, nseg, __i)
+
+#endif /* CONFIG_SCSI_SG_CHAIN */
+
 #define scsi_bufflen(cmd) ((cmd)->request_bufflen)
 
 static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
@@ -150,7 +165,4 @@ static inline int scsi_get_resid(struct 
 	return cmd->resid;
 }
 
-#define scsi_for_each_sg(cmd, sg, nseg, __i)			\
-	for_each_sg(scsi_sglist(cmd), sg, nseg, __i)
-
 #endif /* _SCSI_SCSI_CMND_H */
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
