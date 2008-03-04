From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 04 Mar 2008 18:22:28 +0900
Message-ID: <20080304182228Z.fujita.tomonori@lab.ntt.co.jp>
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp>
	<20080304085944.GG6704@kernel.dk>
	<20080304180648W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:44800 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbYCDKF1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 05:05:27 -0500
In-Reply-To: <20080304180648W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, htejun@gmail.com
Cc: tomof@acm.org, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

On Tue, 04 Mar 2008 18:06:48 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Tue, 4 Mar 2008 09:59:46 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Tue, Mar 04 2008, FUJITA Tomonori wrote:
> > > On Tue, 04 Mar 2008 11:32:56 +0900
> > > Tejun Heo <htejun@gmail.com> wrote:
> > > 
> > > > FUJITA Tomonori wrote:
> > > > >> Yeah, libata did its own padding and needed to add draining.  Private
> > > > >> implementation was complex as hell and James suggested moving them to
> > > > >> block layer.  Are you suggesting moving them back to drivers?
> > > > > 
> > > > > No, I'm not. I've been working on the IOMMUs to remove such
> > > > > workarounds in LLDs.
> > > > > 
> > > > > What drivers need to do on this is just adding a padding length, that
> > > > > is, drivers don't need to change the structure of the sg list (like
> > > > > splitting a sg entry), right? And it doesn't break the SAS drivers
> > > > > that support SATAPI, does it?
> > > > > 
> > > > > But I agree that drivers want to get a complete sglist so I'm fine
> > > > > with adjusting sglist entries in the block layer with your secode
> > > > > patch (separate out padding from alignment). As we discussed, I'm fine
> > > > > with breaking sum(sg) == rq->data_len as long as rq->data_len means
> > > > > the true data length.
> > > > 
> > > > As long as the second patch is in, what value rq->data_len indicates
> > > > doesn't matter to drivers which don't use explicit padding or draining,
> > > > so the situation is much more controlled.  I don't care which value
> > > > rq->data_len would indicate.  I'd prefer it equal sum(sg) as that value
> > > > is what IDE and libata which will be the major users of padding and/or
> > > > draining expect in rq->data_len but fixing up that shouldn't be too
> > > > difficult.  I guess this can be determined by Jens.  If Jens likes
> > > > rq->data_len to contain requested transfer size, I'll post updated patches.
> > > 
> > > OK, I prefer rq->data_len means the true data length though you prefer
> > > rq->data_len means the allocated buffer length (the true data length
> > > plus padding and drain). We agree on other things. We can live with
> > > either way.
> > > 
> > > Jens, what's your preference?
> > 
> > I completely agree with you, ->data_len meaning true data length is way
> > cleaner imho. Only the driver should care for the padded length, all
> > other parts of the kernel only need to know what they actually got.
> 
> OK, now we can fix the whole SG_IO (and bsg handler) mess.
> 
> Here's my patch with a proper description. which several people have
> already tested (thanks!). Then we need an updated version of Tejun's
> separate out padding from alignment patch.

OK, I've updated his patch. Tejun, can you audit this?

Thanks,

=
From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] block: separate out padding from alignment

Block layer alignment was used for two different purposes - memory
alignment and padding.  This causes problems in lower layers because
drivers which only require memory alignment ends up with adjusted
rq->data_len.  Separate out padding such that padding occurs iff
driver explicitly requests it.

Tomo: restorethe code to update bio in blk_rq_map_user
      introduced by the commit 40b01b9bbdf51ae543a04744283bf2d56c4a6afa
      according to padding alignment.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-map.c           |   20 +++++++++++++-------
 block/blk-settings.c      |   17 +++++++++++++++++
 drivers/ata/libata-scsi.c |    3 ++-
 include/linux/blkdev.h    |    2 ++
 4 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index f559832..4e17dfd 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -43,6 +43,7 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 			     void __user *ubuf, unsigned int len)
 {
 	unsigned long uaddr;
+	unsigned int alignment;
 	struct bio *bio, *orig_bio;
 	int reading, ret;
 
@@ -53,8 +54,8 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 	 * direct dma. else, set up kernel bounce buffers
 	 */
 	uaddr = (unsigned long) ubuf;
-	if (!(uaddr & queue_dma_alignment(q)) &&
-	    !(len & queue_dma_alignment(q)))
+	alignment = queue_dma_alignment(q) | q->dma_pad_mask;
+	if (!(uaddr & alignment) && !(len & alignment))
 		bio = bio_map_user(q, NULL, uaddr, len, reading);
 	else
 		bio = bio_copy_user(q, uaddr, len, reading);
@@ -141,15 +142,20 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 
 	/*
 	 * __blk_rq_map_user() copies the buffers if starting address
-	 * or length isn't aligned.  As the copied buffer is always
-	 * page aligned, we know that there's enough room for padding.
-	 * Extend the last bio and update rq->data_len accordingly.
+	 * or length isn't aligned to dma_pad_mask.  As the copied
+	 * buffer is always page aligned, we know that there's enough
+	 * room for padding.  Extend the last bio and update
+	 * rq->data_len accordingly.
 	 *
 	 * On unmap, bio_uncopy_user() will use unmodified
 	 * bio_map_data pointed to by bio->bi_private.
 	 */
-	if (len & queue_dma_alignment(q)) {
-		unsigned int pad_len = (queue_dma_alignment(q) & ~len) + 1;
+	if (len & q->dma_pad_mask) {
+		unsigned int pad_len = (q->dma_pad_mask & ~len) + 1;
+		struct bio *bio = rq->biotail;
+
+		bio->bi_io_vec[bio->bi_vcnt - 1].bv_len += pad_len;
+		bio->bi_size += pad_len;
 
 		rq->extra_len += pad_len;
 	}
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 9a8ffdd..5fcb625 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -293,6 +293,23 @@ void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
 EXPORT_SYMBOL(blk_queue_stack_limits);
 
 /**
+ * blk_queue_dma_pad - set pad mask
+ * @q:     the request queue for the device
+ * @mask:  pad mask
+ *
+ * Set pad mask.  Direct IO requests are padded to the mask specified.
+ *
+ * Appending pad buffer to a request modifies ->data_len such that it
+ * includes the pad buffer.  The original requested data length can be
+ * obtained using blk_rq_raw_data_len().
+ **/
+void blk_queue_dma_pad(struct request_queue *q, unsigned int mask)
+{
+	q->dma_pad_mask = mask;
+}
+EXPORT_SYMBOL(blk_queue_dma_pad);
+
+/**
  * blk_queue_dma_drain - Set up a drain buffer for excess dma.
  *
  * @q:  the request queue for the device
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index fe47922..8f0e8f2 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -862,9 +862,10 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 		struct request_queue *q = sdev->request_queue;
 		void *buf;
 
-		/* set the min alignment */
+		/* set the min alignment and padding */
 		blk_queue_update_dma_alignment(sdev->request_queue,
 					       ATA_DMA_PAD_SZ - 1);
+		blk_queue_dma_pad(sdev->request_queue, ATA_DMA_PAD_SZ - 1);
 
 		/* configure draining */
 		buf = kmalloc(ATAPI_MAX_DRAIN, q->bounce_gfp | GFP_KERNEL);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b72526c..6f79d40 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -362,6 +362,7 @@ struct request_queue
 	unsigned long		seg_boundary_mask;
 	void			*dma_drain_buffer;
 	unsigned int		dma_drain_size;
+	unsigned int		dma_pad_mask;
 	unsigned int		dma_alignment;
 
 	struct blk_queue_tag	*queue_tags;
@@ -701,6 +702,7 @@ extern void blk_queue_max_hw_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_hardsect_size(struct request_queue *, unsigned short);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
+extern void blk_queue_dma_pad(struct request_queue *, unsigned int);
 extern int blk_queue_dma_drain(struct request_queue *q,
 			       dma_drain_needed_fn *dma_drain_needed,
 			       void *buf, unsigned int size);
-- 
1.5.3.6

