From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC 1/2] block: implement drain buffers
Date: Mon, 14 Jan 2008 10:01:35 -0600
Message-ID: <1200326495.3159.7.camel@localhost.localdomain>
References: <11992723701811-git-send-email-htejun@gmail.com>
	 <11992723711076-git-send-email-htejun@gmail.com>
	 <1199986236.3141.51.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36331 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbYANQBl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2008 11:01:41 -0500
In-Reply-To: <1199986236.3141.51.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>

Jens pointed out that I need to lower both phys and hw segments in the
drain set up, so an updated patch is attached.

James

---

>From 7d5cff0af8a2d4017d0b5246aaef33327b053495 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Thu, 10 Jan 2008 11:30:36 -0600
Subject: block: implement drain buffers

These DMA drain buffer implementations in drivers are pretty horrible
to do in terms of manipulating the scatterlist.  Plus they're being
done at least in drivers/ide and drivers/ata, so we now have code
duplication.

The one use case for this, as I understand it is AHCI controllers doing
PIO mode to mmc devices but translating this to DMA at the controller
level.

So, what about adding a callback to the block layer that permits the
adding of the drain buffer for the problem devices.  The idea is that
you'd do this in slave_configure after you find one of these devices.

The beauty of doing it in the block layer is that it quietly adds the
drain buffer to the end of the sg list, so it automatically gets mapped
(and unmapped) without anything unusual having to be done to the
scatterlist in driver/scsi or drivers/ata and without any alteration to
the transfer length.

Jens, could you check I've got the logic of adding and removing the
sizes correct (anything I've missed that could result in a size leak on
request processing?) and that you are OK with the basic concept?  I'm
afraid it's ugly, but it's a lot less ugly than having drivers/ata
trying to append to the scatterlist.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/elevator.c       |   26 ++++++++++++++++++++++++-
 block/ll_rw_blk.c      |   49 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    4 +++
 3 files changed, 78 insertions(+), 1 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index e452deb..9897f20 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -743,7 +743,21 @@ struct request *elv_next_request(struct request_queue *q)
 			q->boundary_rq = NULL;
 		}
 
-		if ((rq->cmd_flags & REQ_DONTPREP) || !q->prep_rq_fn)
+		if (rq->cmd_flags & REQ_DONTPREP)
+			break;
+
+		if (q->dma_drain_size && rq->data_len) {
+			/*
+			 * make sure space for the drain appears we
+			 * know we can do this because max_hw_segments
+			 * has been adjusted to be one fewer than the
+			 * device can handle
+			 */
+			rq->nr_phys_segments++;
+			rq->nr_hw_segments++;
+		}
+
+		if (!q->prep_rq_fn)
 			break;
 
 		ret = q->prep_rq_fn(q, rq);
@@ -756,6 +770,16 @@ struct request *elv_next_request(struct request_queue *q)
 			 * avoid resource deadlock.  REQ_STARTED will
 			 * prevent other fs requests from passing this one.
 			 */
+			if (q->dma_drain_size && rq->data_len &&
+			    !(rq->cmd_flags & REQ_DONTPREP)) {
+				/*
+				 * remove the space for the drain we added
+				 * so that we don't add it again
+				 */
+				--rq->nr_phys_segments;
+				--rq->nr_hw_segments;
+			}
+
 			rq = NULL;
 			break;
 		} else if (ret == BLKPREP_KILL) {
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 14af36c..72f536c 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -726,6 +726,45 @@ void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
 EXPORT_SYMBOL(blk_queue_stack_limits);
 
 /**
+ * blk_queue_dma_drain - Set up a drain buffer for excess dma.
+ *
+ * @q:  the request queue for the device
+ * @buf:	physically contiguous buffer
+ * @size:	size of the buffer in bytes
+ *
+ * Some devices have excess DMA problems and can't simply discard (or
+ * zero fill) the unwanted piece of the transfer.  They have to have a
+ * real area of memory to transfer it into.  The use case for this is
+ * ATAPI devices in DMA mode.  If the packet command causes a transfer
+ * bigger than the transfer size some HBAs will lock up if there
+ * aren't DMA elements to contain the excess transfer.  What this API
+ * does is adjust the queue so that the buf is always appended
+ * silently to the scatterlist.
+ *
+ * Note: This routine adjusts max_hw_segments to make room for
+ * appending the drain buffer.  If you call
+ * blk_queue_max_hw_segments() or blk_queue_max_phys_segments() after
+ * calling this routine, you must set the limit to one fewer than your
+ * device can support otherwise there won't be room for the drain
+ * buffer.
+ */
+int blk_queue_dma_drain(struct request_queue *q, void *buf,
+				unsigned int size)
+{
+	if (q->max_hw_segments < 2 || q->max_phys_segments < 2)
+		return -EINVAL;
+	/* make room for appending the drain */
+	--q->max_hw_segments;
+	--q->max_phys_segments;
+	q->dma_drain_buffer = buf;
+	q->dma_drain_size = size;
+
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(blk_queue_dma_drain);
+
+/**
  * blk_queue_segment_boundary - set boundary rules for segment merging
  * @q:  the request queue for the device
  * @mask:  the memory boundary mask
@@ -1379,6 +1418,16 @@ new_segment:
 		bvprv = bvec;
 	} /* segments in rq */
 
+	if (q->dma_drain_size) {
+		sg->page_link &= ~0x02;
+		sg = sg_next(sg);
+		sg_set_page(sg, virt_to_page(q->dma_drain_buffer),
+			    q->dma_drain_size,
+			    ((unsigned long)q->dma_drain_buffer) &
+			    (PAGE_SIZE - 1));
+		nsegs++;
+	}
+
 	if (sg)
 		sg_mark_end(sg);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 81e99e5..e8bd5cf 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -431,6 +431,8 @@ struct request_queue
 	unsigned int		max_segment_size;
 
 	unsigned long		seg_boundary_mask;
+	void			*dma_drain_buffer;
+	unsigned int		dma_drain_size;
 	unsigned int		dma_alignment;
 
 	struct blk_queue_tag	*queue_tags;
@@ -762,6 +764,8 @@ extern void blk_queue_max_hw_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_hardsect_size(struct request_queue *, unsigned short);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
+extern int blk_queue_dma_drain(struct request_queue *q, void *buf,
+			       unsigned int size);
 extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
-- 
1.5.3.7



