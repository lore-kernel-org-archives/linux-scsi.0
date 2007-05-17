From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 17 May 2007 20:12:43 +0900
Message-ID: <20070517201243E.fujita.tomonori@lab.ntt.co.jp>
References: <20070517054811.GV23798@kernel.dk>
	<20070517145958P.fujita.tomonori@lab.ntt.co.jp>
	<464C1721.8030009@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:63033 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbXEQLOX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 07:14:23 -0400
In-Reply-To: <464C1721.8030009@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 17 May 2007 11:49:37 +0300

> FUJITA Tomonori wrote:
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Subject: Re: [PATCH v2] add bidi support for block pc requests
> > Date: Thu, 17 May 2007 07:48:13 +0200
> > 
> >> On Thu, May 17 2007, FUJITA Tomonori wrote:
> >>> From: Jens Axboe <jens.axboe@oracle.com>
> >>> Subject: Re: [PATCH v2] add bidi support for block pc requests
> >>> Date: Wed, 16 May 2007 19:53:22 +0200
> >>>
> >>>> On Wed, May 16 2007, Boaz Harrosh wrote:
> >>>>> now there are 2 issues with this:
> >>>>> 1. Even if I do blk_queue_max_phys_segments(q, 127); I still get
> >>>>>    requests for use_sg=128 which will crash the kernel.
> >>>> That sounds like a serious issue, it should definitely not happen. Stuff
> >>>> like that would bite other drivers as well, are you absolutely sure that
> >>>> is happening? Power-of-2 bug in your code, or in the SCSI code?
> >>> Boaz, how do you send requests to the scsi-ml, via fs, sg, or bsg?
> 
> These are regular fs (ext3) requests during bootup. The machine will not
> boot. (Usually from the read ahead code)
> Don't believe me look at the second patch Over Tomo's cleanup.
> If I define SCSI_MAX_SG_SEGMENTS to 127 it will crash even when I
> did in code:
> 	blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
> I suppose someone is looking at a different definition. Or there is
> another call I need to do for this to work.

I modified your patch a bit (sgtable allocation) and set
SCSI_MAX_SG_SEGMENTS to 127. My ppc64 box seems to work (with
iscsi_tcp and ipr drivers).

iscsi_tcp sets sg_tablesize to 255, but blk_queue_max_phys_segments
seems to work.

One thing that I found is:

+#define scsi_resid(cmd) ((cmd)->sg_table->resid)


This doesn't work for some drivers (at least ipr) since they set
cmd->resid even with commands without data transfer.

This patch is against my cleanup tree.

Boaz, btw, don't worry about scsi_tgt_lib.c on
scsi_alloc/free_sgtable. You can break it. I need to fix it for bidi anyway.


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 70454b4..d8fb9c4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -35,33 +35,34 @@ #define SG_MEMPOOL_SIZE		2
 
 struct scsi_host_sg_pool {
 	size_t		size;
-	char		*name; 
+	char		*name;
 	struct kmem_cache	*slab;
 	mempool_t	*pool;
 };
 
-#if (SCSI_MAX_PHYS_SEGMENTS < 32)
-#error SCSI_MAX_PHYS_SEGMENTS is too small
-#endif
+/*
+ * Should fit within a single page.
+ */
+
+enum { SCSI_MAX_SG_SEGMENTS = 127 };
+
+enum { SCSI_MAX_SG_SEGMENTS_CALC =
+	((PAGE_SIZE - sizeof(struct scsi_sg_table)) /
+	sizeof(struct scatterlist)) };
+
+#define SG_MEMPOOL_NR ARRAY_SIZE(scsi_sg_pools)
 
-#define SP(x) { x, "sgpool-" #x } 
+/*#define SG_MEMPOOL_NR (ARRAY_SIZE(scsi_sg_pools) - \
+                       (SCSI_MAX_SG_SEGMENTS < 254))*/
+
+#define SP(x) { x, "sgpool-" #x }
 static struct scsi_host_sg_pool scsi_sg_pools[] = {
-	SP(8),
-	SP(16),
-	SP(32),
-#if (SCSI_MAX_PHYS_SEGMENTS > 32)
-	SP(64),
-#if (SCSI_MAX_PHYS_SEGMENTS > 64)
-	SP(128),
-#if (SCSI_MAX_PHYS_SEGMENTS > 128)
-	SP(256),
-#if (SCSI_MAX_PHYS_SEGMENTS > 256)
-#error SCSI_MAX_PHYS_SEGMENTS is too large
-#endif
-#endif
-#endif
-#endif
-}; 	
+	SP(7),
+	SP(15),
+	SP(31),
+	SP(63),
+	SP(SCSI_MAX_SG_SEGMENTS)
+};
 #undef SP
 
 static void scsi_run_queue(struct request_queue *q);
@@ -701,60 +702,38 @@ static struct scsi_cmnd *scsi_end_reques
 	return NULL;
 }
 
-struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+static void scsi_free_sgtable(struct scsi_sg_table *sgt)
 {
-	struct scsi_host_sg_pool *sgp;
-	struct scatterlist *sgl;
-
-	BUG_ON(!cmd->use_sg);
-
-	switch (cmd->use_sg) {
-	case 1 ... 8:
-		cmd->sglist_len = 0;
-		break;
-	case 9 ... 16:
-		cmd->sglist_len = 1;
-		break;
-	case 17 ... 32:
-		cmd->sglist_len = 2;
-		break;
-#if (SCSI_MAX_PHYS_SEGMENTS > 32)
-	case 33 ... 64:
-		cmd->sglist_len = 3;
-		break;
-#if (SCSI_MAX_PHYS_SEGMENTS > 64)
-	case 65 ... 128:
-		cmd->sglist_len = 4;
-		break;
-#if (SCSI_MAX_PHYS_SEGMENTS  > 128)
-	case 129 ... 256:
-		cmd->sglist_len = 5;
-		break;
-#endif
-#endif
-#endif
-	default:
-		return NULL;
-	}
+	printk("%s %d %d\n", __FUNCTION__, sgt->this_sg_count, SG_MEMPOOL_NR);
+	BUG_ON(sgt->this_sg_count >= SG_MEMPOOL_NR);
 
-	sgp = scsi_sg_pools + cmd->sglist_len;
-	sgl = mempool_alloc(sgp->pool, gfp_mask);
-	return sgl;
+	mempool_free(sgt, scsi_sg_pools[sgt->this_sg_count].pool);
 }
 
-EXPORT_SYMBOL(scsi_alloc_sgtable);
-
-void scsi_free_sgtable(struct scatterlist *sgl, int index)
+static struct scsi_sg_table *scsi_alloc_sgtable(int nseg, gfp_t gfp_mask)
 {
 	struct scsi_host_sg_pool *sgp;
+	struct scsi_sg_table *sgt;
+	unsigned int idx;
 
-	BUG_ON(index >= SG_MEMPOOL_NR);
+	for (idx = 0; idx < SG_MEMPOOL_NR; idx++)
+		if (scsi_sg_pools[idx].size >= nseg)
+			goto found;
 
-	sgp = scsi_sg_pools + index;
-	mempool_free(sgl, sgp->pool);
-}
+	printk(KERN_ERR "scsi: bad segment count=%d\n", nseg);
+	BUG();
+found:
+	sgp = scsi_sg_pools + idx;
 
-EXPORT_SYMBOL(scsi_free_sgtable);
+	sgt = mempool_alloc(sgp->pool, gfp_mask);
+	if (unlikely(!sgt))
+		return NULL;
+
+	memset(sgt, 0, SG_TABLE_SIZEOF(sgp->size));
+	sgt->this_sg_count = idx;
+	sgt->sg_count = nseg;
+	return sgt;
+}
 
 /*
  * Function:    scsi_release_buffers()
@@ -775,15 +754,15 @@ EXPORT_SYMBOL(scsi_free_sgtable);
  */
 static void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
-	if (cmd->use_sg)
-		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
+	if (cmd->sg_table)
+		scsi_free_sgtable(cmd->sg_table);
 
-	/*
-	 * Zero these out.  They now point to freed memory, and it is
-	 * dangerous to hang onto the pointers.
-	 */
+	cmd->sg_table = NULL;
+
+	/*FIXME: make code backward compatible with old system */
 	cmd->request_buffer = NULL;
 	cmd->request_bufflen = 0;
+	cmd->use_sg = 0;
 }
 
 /*
@@ -817,13 +796,14 @@ static void scsi_release_buffers(struct
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count = cmd->request_bufflen;
+	int this_count = scsi_bufflen(cmd);
 	request_queue_t *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int clear_errors = 1;
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int sense_deferred = 0;
+	int resid = cmd->sg_table ? cmd->sg_table->resid : 0;
 
 	scsi_release_buffers(cmd);
 
@@ -849,7 +829,7 @@ void scsi_io_completion(struct scsi_cmnd
 				req->sense_len = len;
 			}
 		}
-		req->data_len = cmd->resid;
+		req->data_len = resid;
 	}
 
 	/*
@@ -859,7 +839,6 @@ void scsi_io_completion(struct scsi_cmnd
 	SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, "
 				      "%d bytes done.\n",
 				      req->nr_sectors, good_bytes));
-	SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n", cmd->use_sg));
 
 	if (clear_errors)
 		req->errors = 0;
@@ -991,44 +970,46 @@ EXPORT_SYMBOL(scsi_io_completion);
 static int scsi_init_io(struct scsi_cmnd *cmd)
 {
 	struct request     *req = cmd->request;
-	struct scatterlist *sgpnt;
 	int		   count;
+	struct scsi_sg_table *sgt;
 
-	/*
-	 * We used to not use scatter-gather for single segment request,
-	 * but now we do (it makes highmem I/O easier to support without
-	 * kmapping pages)
-	 */
-	cmd->use_sg = req->nr_phys_segments;
+	printk("%s %d %d %d\n", __FUNCTION__, __LINE__,
+	       req->nr_phys_segments, req->q->max_phys_segments);
 
 	/*
 	 * If sg table allocation fails, requeue request later.
 	 */
-	sgpnt = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
-	if (unlikely(!sgpnt)) {
+	sgt = scsi_alloc_sgtable(req->nr_phys_segments, GFP_ATOMIC);
+	if (unlikely(!sgt)) {
 		scsi_unprep_request(req);
 		return BLKPREP_DEFER;
 	}
 
 	req->buffer = NULL;
-	cmd->request_buffer = (char *) sgpnt;
 	if (blk_pc_request(req))
-		cmd->request_bufflen = req->data_len;
+		sgt->length = req->data_len;
 	else
-		cmd->request_bufflen = req->nr_sectors << 9;
+		sgt->length = req->nr_sectors << 9;
 
-	/* 
+	cmd->sg_table = sgt;
+	/*
 	 * Next, walk the list, and fill in the addresses and sizes of
 	 * each segment.
 	 */
-	count = blk_rq_map_sg(req->q, req, cmd->request_buffer);
-	if (likely(count <= cmd->use_sg)) {
-		cmd->use_sg = count;
+	count = blk_rq_map_sg(req->q, req, sgt->sglist);
+	if (likely(count <= sgt->sg_count)) {
+		sgt->sg_count = count;
+
+		/*FIXME: make code backward compatible with old system */
+		cmd->request_buffer = sgt->sglist;
+		cmd->request_bufflen = sgt->length;
+		cmd->use_sg = sgt->sg_count;
+
 		return BLKPREP_OK;
 	}
 
 	printk(KERN_ERR "Incorrect number of segments after building list\n");
-	printk(KERN_ERR "counted %d, received %d\n", count, cmd->use_sg);
+	printk(KERN_ERR "counted %d, received %d\n", count, scsi_sg_count(cmd));
 	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
 			req->current_nr_sectors);
 
@@ -1084,7 +1065,7 @@ static void scsi_blk_pc_done(struct scsi
 	 * successfully. Since this is a REQ_BLOCK_PC command the
 	 * caller should check the request's errors value
 	 */
-	scsi_io_completion(cmd, cmd->request_bufflen);
+	scsi_io_completion(cmd, scsi_bufflen(cmd));
 }
 
 static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
@@ -1113,9 +1094,7 @@ static int scsi_setup_blk_pc_cmnd(struct
 		BUG_ON(req->data_len);
 		BUG_ON(req->data);
 
-		cmd->request_bufflen = 0;
-		cmd->request_buffer = NULL;
-		cmd->use_sg = 0;
+		cmd->sg_table = NULL;
 		req->buffer = NULL;
 	}
 
@@ -1576,7 +1555,7 @@ struct request_queue *__scsi_alloc_queue
 		return NULL;
 
 	blk_queue_max_hw_segments(q, shost->sg_tablesize);
-	blk_queue_max_phys_segments(q, SCSI_MAX_PHYS_SEGMENTS);
+	blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
@@ -1667,12 +1646,18 @@ int __init scsi_init_queue(void)
 		return -ENOMEM;
 	}
 
+	printk(KERN_ERR
+		"SCSI: max_calc=%d page=%ld so_sgtable=%Zd so_scaterlist=%Zd\n",
+		SCSI_MAX_SG_SEGMENTS_CALC, PAGE_SIZE ,sizeof(struct scsi_sg_table),
+		sizeof(struct scatterlist)
+	);
+
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
-		int size = sgp->size * sizeof(struct scatterlist);
+		int size = SG_TABLE_SIZEOF(sgp->size);
 
 		sgp->slab = kmem_cache_create(sgp->name, size, 0,
-				SLAB_HWCACHE_ALIGN, NULL, NULL);
+				0, NULL, NULL);
 		if (!sgp->slab) {
 			printk(KERN_ERR "SCSI: can't init sg slab %s\n",
 					sgp->name);
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 996ff36..26f1dc0 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -11,6 +11,16 @@ struct scatterlist;
 struct Scsi_Host;
 struct scsi_device;
 
+struct scsi_sg_table {
+	unsigned length;
+	int resid;
+	short sg_count;
+	short this_sg_count;
+	struct scatterlist sglist[0];
+};
+
+#define SG_TABLE_SIZEOF(sg_count) ((sg_count)*sizeof(struct scatterlist) \
+                                   + sizeof(struct scsi_sg_table))
 
 /* embedded in scsi_cmnd */
 struct scsi_pointer {
@@ -68,10 +78,10 @@ #define MAX_COMMAND_SIZE	16
 
 	struct timer_list eh_timeout;	/* Used to time out the command. */
 	void *request_buffer;		/* Actual requested buffer */
+	struct scsi_sg_table *sg_table;
 
 	/* These elements define the operation we ultimately want to perform */
 	unsigned short use_sg;	/* Number of pieces of scatter-gather */
-	unsigned short sglist_len;	/* size of malloc'd scatter-gather list */
 
 	unsigned underflow;	/* Return error if less than
 				   this amount is transferred */
@@ -132,15 +142,12 @@ extern void *scsi_kmap_atomic_sg(struct
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
-extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
-extern void scsi_free_sgtable(struct scatterlist *, int);
-
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
 
-#define scsi_sg_count(cmd) ((cmd)->use_sg)
-#define scsi_sglist(cmd) ((struct scatterlist *)(cmd)->request_buffer)
-#define scsi_bufflen(cmd) ((cmd)->request_bufflen)
+#define scsi_sg_count(cmd) ((cmd)->sg_table ? (cmd)->sg_table->sg_count : 0)
+#define scsi_sglist(cmd) ((cmd)->sg_table ? (cmd)->sg_table->sglist : NULL)
+#define scsi_bufflen(cmd) ((cmd)->sg_table ? (cmd)->sg_table->length : 0)
 #define scsi_resid(cmd) ((cmd)->resid)
 
 #define scsi_for_each_sg(cmd, sg, nseg, __i)			\



