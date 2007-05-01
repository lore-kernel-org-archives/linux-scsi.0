From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 4/4] bidi support: bidirectional request
Date: Wed, 2 May 2007 04:50:23 +0900 (JST)
Message-ID: <20070502043754N.fujita.tomonori@lab.ntt.co.jp>
References: <4634BE6B.3000808@panasas.com>
	<1177872588.3688.79.camel@mulgrave.il.steeleye.com>
	<20070430111157.GI21015@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:43510 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbXEATvI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 May 2007 15:51:08 -0400
In-Reply-To: <20070430111157.GI21015@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: James.Bottomley@SteelEye.com, bharrosh@panasas.com, tomof@acm.org, akpm@osdl.org, michaelc@cs.wisc.edu, hch@infradead.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, bhalevy@panasas.com

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 4/4] bidi support: bidirectional request
Date: Mon, 30 Apr 2007 13:11:57 +0200

> On Sun, Apr 29 2007, James Bottomley wrote:
> > On Sun, 2007-04-29 at 18:48 +0300, Boaz Harrosh wrote:
> > > FUJITA Tomonori wrote:
> > > > From: Boaz Harrosh <bharrosh@panasas.com>
> > > > Subject: [PATCH 4/4] bidi support: bidirectional request
> > > > Date: Sun, 15 Apr 2007 20:33:28 +0300
> > > > 
> > > >> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > > >> index 645d24b..16a02ee 100644
> > > >> --- a/include/linux/blkdev.h
> > > >> +++ b/include/linux/blkdev.h
> > > >> @@ -322,6 +322,7 @@ struct request {
> > > >>      void *end_io_data;
> > > >>
> > > >>      struct request_io_part uni;
> > > >> +    struct request_io_part bidi_read;
> > > >>  };
> > > > 
> > > > Would be more straightforward to have:
> > > > 
> > > > struct request_io_part in;
> > > > struct request_io_part out;
> > > > 
> > > 
> > > Yes I wish I could do that. For bidi supporting drivers this is the most logical.
> > > But for the 99.9% of uni-directional drivers, calling rq_uni(), and being some what on
> > > the hotish paths, this means we will need a pointer to a uni request_io_part.
> > > This is bad because:
> > > 1st- There is no defined stage in a request life where to definitely set that pointer,
> > >      specially in the preparation stages.
> > > 2nd- hacks like scsi_error.c/scsi_send_eh_cmnd() will not work at all. Now this is a
> > >      very bad spot already, and I have a short term fix for it in the SCSI-bidi patches
> > >      (not sent yet) but a more long term solution is needed. Once such hacks are
> > >      cleaned up we can do what you say. This is exactly why I use the access functions
> > >      rq_uni/rq_io/rq_in/rq_out and not open code access.
> > 
> > I'm still not really convinced about this approach.  The primary job of
> > the block layer is to manage and merge READ and WRITE requests.  It
> > serves a beautiful secondary function of queueing for arbitrary requests
> > it doesn't understand (REQ_TYPE_BLOCK_PC or REQ_TYPE_SPECIAL ... or
> > indeed any non REQ_TYPE_FS).
> > 
> > bidirectional requests fall into the latter category (there's nothing
> > really we can do to merge them ... they're just transported by the block
> > layer).  The only unusual feature is that they carry two bios.  I think
> > the drivers that actually support bidirectional will be a rarity, so it
> > might even be advisable to add it to the queue capability (refuse
> > bidirectional requests at the top rather than perturbing all the drivers
> > to process them).
> > 
> > So, what about REQ_TYPE_BIDIRECTIONAL rather than REQ_BIDI?  That will
> > remove it from the standard path and put it on the special command type
> > path where we can process it specially.  Additionally, if you take this
> > approach, you can probably simply chain the second bio through
> > req->special as an additional request in the stream.  The only thing
> > that would then need modification would be the dequeue of the block
> > driver (it would have to dequeue both requests and prepare them) and
> > that needs to be done only for drivers handling bidirectional requests.
> 
> I agree, I'm really not crazy about shuffling the entire request setup
> around just for something as exotic as bidirection commands. How about
> just keeping it simple - have a second request linked off the first one
> for the second data phase? So keep it completely seperate, not just
> overload ->special for 2nd bio list.
> 
> So basically just add a struct request pointer, so you can do rq =
> rq->next_rq or something for the next data phase. I bet this would be a
> LOT less invasive as well, and we can get by with a few helpers to
> support it.

This patch tried this approach. It's just for seeing how it works.

I added bidi support to open-iscsi and bsg and tested this patch
lightly. I've attached only a patch for the block layer and scsl-ml.
You can get all the patches are:

http://www.kernel.org/pub/linux/kernel/people/tomo/bidi

If we go with this approach, we need just minor changes to the block
layer. The overloading rq->special approach needs more but it's
reasonable too.

I need to add the proper error handling code, which might be a bit
tricky, but I think that it will not be so complicated.


> And it should definitely be a request type.

I'm not sure about this. I think that bidi can't be a request type to
trace bidi pc requests (we have bidi special requests like SMP). I use
REQ_BIDI though I've not implemented bidi trace code.


>From 7d278323ff8aad86fb82c823538f7ddfb6ded11c Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 2 May 2007 03:55:56 +0900
Subject: [PATCH] add bidi support

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/ll_rw_blk.c        |    1 +
 drivers/scsi/scsi_lib.c  |   72 +++++++++++++++++++++++++++++++++++++++-------
 include/linux/blkdev.h   |    7 ++++
 include/scsi/scsi_cmnd.h |    9 ++++++
 4 files changed, 78 insertions(+), 11 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index cf8752a..82842d6 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -256,6 +256,7 @@ static void rq_init(request_queue_t *q,
 	rq->end_io = NULL;
 	rq->end_io_data = NULL;
 	rq->completion_data = NULL;
+	rq->next_rq = NULL;
 }
 
 /**
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index be8e655..96541cb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -701,34 +701,36 @@ static struct scsi_cmnd *scsi_end_reques
 	return NULL;
 }
 
-struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+static struct scatterlist *do_scsi_alloc_sgtable(unsigned short use_sg,
+						 unsigned short *sglist_len,
+						 gfp_t gfp_mask)
 {
 	struct scsi_host_sg_pool *sgp;
 	struct scatterlist *sgl;
 
-	BUG_ON(!cmd->use_sg);
+	BUG_ON(!use_sg);
 
-	switch (cmd->use_sg) {
+	switch (use_sg) {
 	case 1 ... 8:
-		cmd->sglist_len = 0;
+		*sglist_len = 0;
 		break;
 	case 9 ... 16:
-		cmd->sglist_len = 1;
+		*sglist_len = 1;
 		break;
 	case 17 ... 32:
-		cmd->sglist_len = 2;
+		*sglist_len = 2;
 		break;
 #if (SCSI_MAX_PHYS_SEGMENTS > 32)
 	case 33 ... 64:
-		cmd->sglist_len = 3;
+		*sglist_len = 3;
 		break;
 #if (SCSI_MAX_PHYS_SEGMENTS > 64)
 	case 65 ... 128:
-		cmd->sglist_len = 4;
+		*sglist_len = 4;
 		break;
 #if (SCSI_MAX_PHYS_SEGMENTS  > 128)
 	case 129 ... 256:
-		cmd->sglist_len = 5;
+		*sglist_len = 5;
 		break;
 #endif
 #endif
@@ -737,11 +739,15 @@ #endif
 		return NULL;
 	}
 
-	sgp = scsi_sg_pools + cmd->sglist_len;
+	sgp = scsi_sg_pools + *sglist_len;
 	sgl = mempool_alloc(sgp->pool, gfp_mask);
 	return sgl;
 }
 
+struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+{
+	return do_scsi_alloc_sgtable(cmd->use_sg, &cmd->sglist_len, gfp_mask);
+}
 EXPORT_SYMBOL(scsi_alloc_sgtable);
 
 void scsi_free_sgtable(struct scatterlist *sgl, int index)
@@ -778,6 +784,9 @@ static void scsi_release_buffers(struct
 	if (cmd->use_sg)
 		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
 
+	if (cmd->ext_request_buffer.use_sg)
+		scsi_free_sgtable(cmd->ext_request_buffer.request_buffer,
+				  cmd->ext_request_buffer.sglist_len);
 	/*
 	 * Zero these out.  They now point to freed memory, and it is
 	 * dangerous to hang onto the pointers.
@@ -1106,9 +1115,48 @@ static int scsi_setup_blk_pc_cmnd(struct
 
 		BUG_ON(!req->nr_phys_segments);
 
+		if (blk_bidi_rq(req)) {
+			BUG_ON(!req->next_rq);
+
+			if (rq_data_dir(req) != WRITE ||
+			    rq_data_dir(req->next_rq) != READ) {
+				scsi_release_buffers(cmd);
+				scsi_put_command(cmd);
+				return BLKPREP_KILL;
+			}
+		}
+
 		ret = scsi_init_io(cmd);
 		if (unlikely(ret))
 			return ret;
+
+		if (blk_bidi_rq(req)) {
+			struct scsi_data_buffer *sdb = &cmd->ext_request_buffer;
+			struct scatterlist *sgpnt;
+			int count;
+
+			sdb->use_sg = req->nr_phys_segments;
+
+			sgpnt = do_scsi_alloc_sgtable(sdb->use_sg,
+						      &sdb->sglist_len,
+						      GFP_ATOMIC);
+			if (unlikely(!sgpnt)) {
+				scsi_release_buffers(cmd);
+				scsi_unprep_request(req);
+				return BLKPREP_DEFER;
+			}
+
+			sdb->request_buffer = sgpnt;
+			sdb->request_bufflen = req->next_rq->data_len;
+			count = blk_rq_map_sg(req->q, req->next_rq, sgpnt);
+			if (unlikely(count > sdb->use_sg)) {
+				scsi_free_sgtable(sgpnt, sdb->sglist_len);
+				scsi_release_buffers(cmd);
+				scsi_put_command(cmd);
+				return BLKPREP_KILL;
+			}
+			sdb->use_sg = count;
+		}
 	} else {
 		BUG_ON(req->data_len);
 		BUG_ON(req->data);
@@ -1122,7 +1170,9 @@ static int scsi_setup_blk_pc_cmnd(struct
 	BUILD_BUG_ON(sizeof(req->cmd) > sizeof(cmd->cmnd));
 	memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
 	cmd->cmd_len = req->cmd_len;
-	if (!req->data_len)
+	if (blk_bidi_rq(req))
+		cmd->sc_data_direction = DMA_BIDIRECTIONAL;
+	else if (!req->data_len)
 		cmd->sc_data_direction = DMA_NONE;
 	else if (rq_data_dir(req) == WRITE)
 		cmd->sc_data_direction = DMA_TO_DEVICE;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 83dcd8c..9d3bb4a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -199,6 +199,7 @@ enum rq_flag_bits {
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_RW_META,		/* metadata io request */
 	__REQ_NR_BITS,		/* stops here */
+	__REQ_BIDI,		/* bidirectional io request */
 };
 
 #define REQ_RW		(1 << __REQ_RW)
@@ -219,6 +220,7 @@ #define REQ_ORDERED_COLOR	(1 << __REQ_OR
 #define REQ_RW_SYNC	(1 << __REQ_RW_SYNC)
 #define REQ_ALLOCED	(1 << __REQ_ALLOCED)
 #define REQ_RW_META	(1 << __REQ_RW_META)
+#define REQ_BIDI	(1 << __REQ_BIDI)
 
 #define BLK_MAX_CDB	16
 
@@ -313,6 +315,9 @@ struct request {
 	 */
 	rq_end_io_fn *end_io;
 	void *end_io_data;
+
+	/* for bidi */
+	struct request *next_rq;
 };
 
 /*
@@ -478,6 +483,7 @@ #define QUEUE_FLAG_DEAD		5	/* queue bein
 #define QUEUE_FLAG_REENTER	6	/* Re-entrancy avoidance */
 #define QUEUE_FLAG_PLUGGED	7	/* queue is plugged */
 #define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
+#define QUEUE_FLAG_BIDI		9	/* bidirectional requests */
 
 enum {
 	/*
@@ -542,6 +548,7 @@ #define blk_pm_request(rq)	\
 #define blk_sorted_rq(rq)	((rq)->cmd_flags & REQ_SORTED)
 #define blk_barrier_rq(rq)	((rq)->cmd_flags & REQ_HARDBARRIER)
 #define blk_fua_rq(rq)		((rq)->cmd_flags & REQ_FUA)
+#define blk_bidi_rq(rq)		((rq)->cmd_flags & REQ_BIDI)
 
 #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a2e0c10..0e259e5 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -11,6 +11,12 @@ struct scatterlist;
 struct Scsi_Host;
 struct scsi_device;
 
+struct scsi_data_buffer {
+	unsigned short use_sg;       /* Number of pieces of scatter-gather */
+	unsigned short sglist_len;   /* size of malloc'd scatter-gather list */
+	void *request_buffer;        /* Actual requested buffer */
+	unsigned request_bufflen;    /* Actual request size */
+};
 
 /* embedded in scsi_cmnd */
 struct scsi_pointer {
@@ -117,6 +123,9 @@ #define SCSI_SENSE_BUFFERSIZE 	96
 
 	unsigned char tag;	/* SCSI-II queued command tag */
 	unsigned long pid;	/* Process ID, starts at 0. Unique per host. */
+
+	/* bidi in buffer */
+	struct scsi_data_buffer ext_request_buffer;
 };
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
-- 
1.4.3.2

