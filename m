From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] sgtable over sglist (Re: [RFC 4/8] scsi-ml: scsi_sgtable
 implementation)
Date: Mon, 23 Jul 2007 23:08:13 +0900
Message-ID: <20070723225016C.tomof@acm.org>
References: <20070718180350.GD11657@kernel.dk>
	<469E6838.8070405@panasas.com>
	<20070718201709.GM11657@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:37143 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbXGWOK0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jul 2007 10:10:26 -0400
In-Reply-To: <20070718201709.GM11657@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: bhalevy@panasas.com, bharrosh@panasas.com, tomof@acm.org, michaelc@cs.wisc.edu, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-scsi@vger.kernel.orgfujita.tomonori@lab.ntt.co.jp

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC 4/8] scsi-ml: scsi_sgtable implementation
Date: Wed, 18 Jul 2007 22:17:10 +0200

> On Wed, Jul 18 2007, Benny Halevy wrote:
> > Jens Axboe wrote:
> > > On Wed, Jul 18 2007, Boaz Harrosh wrote:
> > >> Jens Axboe wrote:
> > >>> On Wed, Jul 18 2007, Boaz Harrosh wrote:
> > >>>> FUJITA Tomonori wrote:
> > >>>>> From: Mike Christie <michaelc@cs.wisc.edu>
> > >>>>> Subject: Re: [RFC 4/8] scsi-ml: scsi_sgtable implementation
> > >>>>> Date: Thu, 12 Jul 2007 14:09:44 -0500
> > >>>>>
> > >>>>>> Boaz Harrosh wrote:
> > >>>>>>> +/*
> > >>>>>>> + * Should fit within a single page.
> > >>>>>>> + */
> > >>>>>>> +enum { SCSI_MAX_SG_SEGMENTS =
> > >>>>>>> +	((PAGE_SIZE - sizeof(struct scsi_sgtable)) /
> > >>>>>>> +	sizeof(struct scatterlist)) };
> > >>>>>>> +
> > >>>>>>> +enum { SG_MEMPOOL_NR =
> > >>>>>>> +	(SCSI_MAX_SG_SEGMENTS >= 7) +
> > >>>>>>> +	(SCSI_MAX_SG_SEGMENTS >= 15) +
> > >>>>>>> +	(SCSI_MAX_SG_SEGMENTS >= 31) +
> > >>>>>>> +	(SCSI_MAX_SG_SEGMENTS >= 63) +
> > >>>>>>> +	(SCSI_MAX_SG_SEGMENTS >= 127) +
> > >>>>>>> +	(SCSI_MAX_SG_SEGMENTS >= 255) +
> > >>>>>>> +	(SCSI_MAX_SG_SEGMENTS >= 511)
> > >>>>>>> +};
> > >>>>>>>  
> > >>>>>> What does SCSI_MAX_SG_SEGMENTS end up being on x86 now? On x86_64 or 
> > >>>>>> some other arch, we were going over a page when doing 
> > >>>>>> SCSI_MAX_PHYS_SEGMENTS of 256 right?
> > >>>>> Seems that 170 with x86 and 127 with x86_64.
> > >>>>>
> > >>>> with scsi_sgtable we get one less than now
> > >>>>
> > >>>> Arch                      | SCSI_MAX_SG_SEGMENTS =  | sizeof(struct scatterlist)
> > >>>> --------------------------|-------------------------|---------------------------
> > >>>> x86_64                    | 127                     |32
> > >>>> i386 CONFIG_HIGHMEM64G=y  | 204                     |20
> > >>>> i386 other                | 255                     |16
> > >>>>
> > >>>> What's nice about this code is that now finally it is
> > >>>> automatically calculated in compile time. Arch people
> > >>>> don't have the headache "did I break SCSI-ml?". 
> > >>>> For example observe the current bug with i386 
> > >>>> CONFIG_HIGHMEM64G=y.
> > >>>>
> > >>>> The same should be done with BIO's. Than ARCHs with big
> > >>>> pages can gain even more.
> > >>>>
> > >>>>>> What happened to Jens's scatter list chaining and how does this relate 
> > >>>>>> to it then?
> > >>>>> With Jens' sglist, we can set SCSI_MAX_SG_SEGMENTS to whatever we
> > >>>>> want. We can remove the above code.
> > >>>>>
> > >>>>> We need to push this and Jens' sglist together in one merge window, I
> > >>>>> think.
> > >>>> No Tomo the above does not go away. What goes away is maybe:
> > >>> It does go away, since we can just set it to some safe value and use
> > >>> chaining to get us where we want.
> > >> In my patches SCSI_MAX_PHYS_SEGMENTS has went away it does not exist
> > >> anymore.
> > > 
> > > Sure, I could just kill it as well. The point is that it's a parallel
> > > development, there's nothing in your patch that helps the sg chaining
> > > whatsoever. The only "complex" thing in the SCSI layer for sg chaining,
> > > is chaining when allocating and walking that chain on freeing. That's
> > > it!
> > 
> > It seems like having the pool index in the sgtable structure simplifies
> > the implementation a bit for allocation and freeing of linked sgtables.
> > Boaz will send an example tomorrow (hopefully) showing how the merged
> > code looks like.
> 
> The index stuff isn't complex, so I don't think you can call that a real
> simplification. It's not for free either, there's a size cost to pay.

I think that the main issue of integrating sgtable and sglist is how
to put scatterlist to scsi_sgtable structure.

If we allocate a scsi_sgtable structure and sglists separately, the
code is pretty simple. But probably it's not the best way from the
perspective of performance.

If we put sglists into the scsi_sgtable structure (like Boaz's patch
does) and allocate and chain sglists only for large I/Os, we would
have the better performance (especially for small I/Os). But we will
have more complicated code.

I wrote my sgtable patch over Jens' sglist with the former way:

master.kernel.org:/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git sgtable


I also put Boaz's scsi_error, sd, and sr sgtable patches into the tree
so you can try it. I've tested this with only normal size I/Os (not
tested sglist code). I don't touch the sglist code much, so hopefully
it works.

I've attached the sgtable patch for review. It's against the
sglist-arch branch in Jens' tree.

---
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] move all the I/O descriptors to a new scsi_sgtable structure

based on Boaz Harrosh <bharrosh@panasas.com> scsi_sgtable patch.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c  |   92 +++++++++++++++++++++++++++------------------
 include/scsi/scsi_cmnd.h |   39 +++++++++++++------
 2 files changed, 82 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5fb1048..2fa1852 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -52,6 +52,8 @@ static struct scsi_host_sg_pool scsi_sg_pools[] = {
 };
 #undef SP
 
+static struct kmem_cache *scsi_sgtable_cache;
+
 static void scsi_run_queue(struct request_queue *q);
 
 /*
@@ -731,16 +733,27 @@ static inline unsigned int scsi_sgtable_index(unsigned short nents)
 	return index;
 }
 
-struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+struct scsi_sgtable *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask,
+					int sg_count)
 {
 	struct scsi_host_sg_pool *sgp;
 	struct scatterlist *sgl, *prev, *ret;
+	struct scsi_sgtable *sgt;
 	unsigned int index;
 	int this, left;
 
-	BUG_ON(!cmd->use_sg);
+	sgt = kmem_cache_zalloc(scsi_sgtable_cache, gfp_mask);
+	if (!sgt)
+		return NULL;
+
+	/*
+	 * don't allow subsequent mempool allocs to sleep, it would
+	 * violate the mempool principle.
+	 */
+	gfp_mask &= ~__GFP_WAIT;
+	gfp_mask |= __GFP_HIGH;
 
-	left = cmd->use_sg;
+	left = sg_count;
 	ret = prev = NULL;
 	do {
 		this = left;
@@ -764,7 +777,7 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 		 * first loop through, set initial index and return value
 		 */
 		if (!ret) {
-			cmd->sglist_len = index;
+			sgt->sglist_len = index;
 			ret = sgl;
 		}
 
@@ -776,21 +789,18 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 		if (prev)
 			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
 
-		/*
-		 * don't allow subsequent mempool allocs to sleep, it would
-		 * violate the mempool principle.
-		 */
-		gfp_mask &= ~__GFP_WAIT;
-		gfp_mask |= __GFP_HIGH;
 		prev = sgl;
 	} while (left);
 
 	/*
-	 * ->use_sg may get modified after dma mapping has potentially
+	 * ->sg_count may get modified after dma mapping has potentially
 	 * shrunk the number of segments, so keep a copy of it for free.
 	 */
-	cmd->__use_sg = cmd->use_sg;
-	return ret;
+	sgt->sg_count = sg_count;
+	sgt->__sg_count = sg_count;
+	sgt->sglist = ret;
+	cmd->sgtable = sgt;
+	return sgt;
 enomem:
 	if (ret) {
 		/*
@@ -809,6 +819,8 @@ enomem:
 
 		mempool_free(prev, sgp->pool);
 	}
+	kmem_cache_free(scsi_sgtable_cache, sgt);
+
 	return NULL;
 }
 
@@ -816,21 +828,22 @@ EXPORT_SYMBOL(scsi_alloc_sgtable);
 
 void scsi_free_sgtable(struct scsi_cmnd *cmd)
 {
-	struct scatterlist *sgl = cmd->request_buffer;
+	struct scsi_sgtable *sgt = cmd->sgtable;
+	struct scatterlist *sgl = sgt->sglist;
 	struct scsi_host_sg_pool *sgp;
 
-	BUG_ON(cmd->sglist_len >= SG_MEMPOOL_NR);
+	BUG_ON(sgt->sglist_len >= SG_MEMPOOL_NR);
 
 	/*
 	 * if this is the biggest size sglist, check if we have
 	 * chained parts we need to free
 	 */
-	if (cmd->__use_sg > SCSI_MAX_SG_SEGMENTS) {
+	if (sgt->__sg_count > SCSI_MAX_SG_SEGMENTS) {
 		unsigned short this, left;
 		struct scatterlist *next;
 		unsigned int index;
 
-		left = cmd->__use_sg - (SCSI_MAX_SG_SEGMENTS - 1);
+		left = sgt->__sg_count - (SCSI_MAX_SG_SEGMENTS - 1);
 		next = sg_chain_ptr(&sgl[SCSI_MAX_SG_SEGMENTS - 1]);
 		while (left && next) {
 			sgl = next;
@@ -854,11 +867,12 @@ void scsi_free_sgtable(struct scsi_cmnd *cmd)
 		/*
 		 * Restore original, will be freed below
 		 */
-		sgl = cmd->request_buffer;
+		sgl = sgt->sglist;
 	}
 
-	sgp = scsi_sg_pools + cmd->sglist_len;
+	sgp = scsi_sg_pools + sgt->sglist_len;
 	mempool_free(sgl, sgp->pool);
+	kmem_cache_free(scsi_sgtable_cache, sgt);
 }
 
 EXPORT_SYMBOL(scsi_free_sgtable);
@@ -882,15 +896,14 @@ EXPORT_SYMBOL(scsi_free_sgtable);
  */
 static void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
-	if (cmd->use_sg)
+	if (cmd->sgtable)
 		scsi_free_sgtable(cmd);
 
 	/*
 	 * Zero these out.  They now point to freed memory, and it is
 	 * dangerous to hang onto the pointers.
 	 */
-	cmd->request_buffer = NULL;
-	cmd->request_bufflen = 0;
+	cmd->sgtable = NULL;
 }
 
 /*
@@ -924,13 +937,14 @@ static void scsi_release_buffers(struct scsi_cmnd *cmd)
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
+	int resid = scsi_get_resid(cmd);
 
 	scsi_release_buffers(cmd);
 
@@ -956,7 +970,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				req->sense_len = len;
 			}
 		}
-		req->data_len = cmd->resid;
+		req->data_len = resid;
 	}
 
 	/*
@@ -1098,6 +1112,7 @@ EXPORT_SYMBOL(scsi_io_completion);
 static int scsi_init_io(struct scsi_cmnd *cmd)
 {
 	struct request     *req = cmd->request;
+	struct scsi_sgtable *sgt;
 	int		   count;
 
 	/*
@@ -1105,35 +1120,36 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 	 * but now we do (it makes highmem I/O easier to support without
 	 * kmapping pages)
 	 */
-	cmd->use_sg = req->nr_phys_segments;
+	sgt = scsi_alloc_sgtable(cmd, GFP_ATOMIC, req->nr_phys_segments);
 
 	/*
 	 * If sg table allocation fails, requeue request later.
 	 */
-	cmd->request_buffer = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
-	if (unlikely(!cmd->request_buffer)) {
+	if (unlikely(!sgt)) {
 		scsi_unprep_request(req);
 		return BLKPREP_DEFER;
 	}
 
+	cmd->sgtable = sgt;
+
 	req->buffer = NULL;
 	if (blk_pc_request(req))
-		cmd->request_bufflen = req->data_len;
+		sgt->length = req->data_len;
 	else
-		cmd->request_bufflen = req->nr_sectors << 9;
+		sgt->length = req->nr_sectors << 9;
 
 	/* 
 	 * Next, walk the list, and fill in the addresses and sizes of
 	 * each segment.
 	 */
-	count = blk_rq_map_sg(req->q, req, cmd->request_buffer);
-	if (likely(count <= cmd->use_sg)) {
-		cmd->use_sg = count;
+	count = blk_rq_map_sg(req->q, req, cmd->sgtable->sglist);
+	if (likely(count <= sgt->sg_count)) {
+		sgt->sg_count = count;
 		return BLKPREP_OK;
 	}
 
 	printk(KERN_ERR "Incorrect number of segments after building list\n");
-	printk(KERN_ERR "counted %d, received %d\n", count, cmd->use_sg);
+	printk(KERN_ERR "counted %d, received %d\n", count, sgt->sg_count);
 	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
 			req->current_nr_sectors);
 
@@ -1189,7 +1205,7 @@ static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
 	 * successfully. Since this is a REQ_BLOCK_PC command the
 	 * caller should check the request's errors value
 	 */
-	scsi_io_completion(cmd, cmd->request_bufflen);
+	scsi_io_completion(cmd, scsi_bufflen(cmd));
 }
 
 static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
@@ -1218,9 +1234,7 @@ static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 		BUG_ON(req->data_len);
 		BUG_ON(req->data);
 
-		cmd->request_bufflen = 0;
-		cmd->request_buffer = NULL;
-		cmd->use_sg = 0;
+		cmd->sgtable = NULL;
 		req->buffer = NULL;
 	}
 
@@ -1786,6 +1800,10 @@ int __init scsi_init_queue(void)
 		return -ENOMEM;
 	}
 
+	scsi_sgtable_cache = kmem_cache_create("scsi_sgtable",
+					       sizeof(struct scsi_sgtable),
+					       0, 0, NULL);
+
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
 		int size = sgp->size * sizeof(struct scatterlist);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 937b3c4..9ead940 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -11,6 +11,14 @@ struct scatterlist;
 struct Scsi_Host;
 struct scsi_device;
 
+struct scsi_sgtable {
+	unsigned length;
+	int resid;
+	short sg_count;
+	short __sg_count;
+	short sglist_len;
+	struct scatterlist *sglist;
+};
 
 /* embedded in scsi_cmnd */
 struct scsi_pointer {
@@ -64,10 +72,9 @@ struct scsi_cmnd {
 	/* These elements define the operation we are about to perform */
 #define MAX_COMMAND_SIZE	16
 	unsigned char cmnd[MAX_COMMAND_SIZE];
-	unsigned request_bufflen;	/* Actual request size */
 
 	struct timer_list eh_timeout;	/* Used to time out the command. */
-	void *request_buffer;		/* Actual requested buffer */
+	struct scsi_sgtable *sgtable;
 
 	/* These elements define the operation we ultimately want to perform */
 	unsigned short use_sg;	/* Number of pieces of scatter-gather */
@@ -83,10 +90,6 @@ struct scsi_cmnd {
 				   reconnects.   Probably == sector
 				   size */
 
-	int resid;		/* Number of bytes requested to be
-				   transferred less actual number
-				   transferred (0 if not supported) */
-
 	struct request *request;	/* The command we are
 				   	   working on */
 
@@ -133,24 +136,36 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
-extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
+extern struct scsi_sgtable *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t, int);
 extern void scsi_free_sgtable(struct scsi_cmnd *);
 
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
 
-#define scsi_sg_count(cmd) ((cmd)->use_sg)
-#define scsi_sglist(cmd) ((struct scatterlist *)(cmd)->request_buffer)
-#define scsi_bufflen(cmd) ((cmd)->request_bufflen)
+static inline unsigned scsi_sg_count(struct scsi_cmnd *cmd)
+{
+	return cmd->sgtable ? cmd->sgtable->sg_count : 0;
+}
+
+static inline struct scatterlist *scsi_sglist(struct scsi_cmnd *cmd)
+{
+	return cmd->sgtable ? cmd->sgtable->sglist : 0;
+}
+
+static inline unsigned scsi_bufflen(struct scsi_cmnd *cmd)
+{
+	return cmd->sgtable ? cmd->sgtable->length : 0;
+}
 
 static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
 {
-	cmd->resid = resid;
+	if (cmd->sgtable)
+		cmd->sgtable->resid = resid;
 }
 
 static inline int scsi_get_resid(struct scsi_cmnd *cmd)
 {
-	return cmd->resid;
+	return cmd->sgtable ? cmd->sgtable->resid : 0;
 }
 
 #define scsi_for_each_sg(cmd, sg, nseg, __i)			\
-- 
1.5.2.4

