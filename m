From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Wed, 25 Jun 2008 15:57:41 +0200
Message-ID: <20080625135741.GA20851@kernel.dk>
References: <20080619160342.GJ4392@parisc-linux.org> <20080625134705.GZ20851@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:12722 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942AbYFYN5p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 09:57:45 -0400
Content-Disposition: inline
In-Reply-To: <20080625134705.GZ20851@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Wed, Jun 25 2008, Jens Axboe wrote:
> On Thu, Jun 19 2008, Matthew Wilcox wrote:
> > Use the noop elevator by default for drives that do not spin
> > 
> > [Not for applying]
> > 
> > SSDs do not benefit from the elevator.  It just wastes precious CPU cycles.
> > By selecting the noop elevator by default, we can shave a few microseconds
> > off each IO.
> > 
> > I've brazenly stolen sd_vpd_inquiry from mkp's patch here:
> > 
> > http://marc.info/?l=linux-scsi&m=121264354724277&w=2
> > 
> > No need to have two copies of that ... but this will conflict with his code.
> > 
> > On to the self-criticism:
> > 
> > I don't intend the final version of this patch to include a printk for
> > the RPM or even a printk to say we switched IO elevator.  I think we're
> > too verbose in SCSI as it is.
> > 
> > I think there's an opportunity to improve sd_vpd_inquiry() to remove
> > some of the duplicate code between sd_set_elevator() and sd_block_limits,
> > but it's not terribly important.
> > 
> > The switching of the elevators isn't particularly nice.  I assume that
> > elevator_init("noop") cannot fail, which isn't true.  It would be nice
> > to use the #if 0 block instead, but that causes a null ptr dereference
> > inside sysfs -- I suspect something isn't set up correctly.
> 
> I disagree with this approach. For now, lets just add a queue flag that
> says the device doesn't have a seek penalty and let the io schedulers do
> what they need to avoid that (it'd be a one-liner change to cfq and as).
> There's more to io scheduling than just seek reduction, so this is the
> wrong direction to take imo.

OK, a two liner for CFQ. Something like this would be much better I
think - maintain the check in SCSI but flag the queue as seek-free if
SSD is detected, and let the lower layer worry about the details. Much
cleaner, doesn't allow dirty SCSI fingers where they don't belong.

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8dd8641..afbf6e0 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -410,6 +410,18 @@ void blk_queue_update_dma_alignment(struct request_queue *q, int mask)
 }
 EXPORT_SYMBOL(blk_queue_update_dma_alignment);
 
+void blk_queue_seek_free(struct request_queue *q, int set)
+{
+	/*
+	 * initialization stuff, don't worry about concurrency
+	 */
+	if (set)
+		queue_flag_set_unlocked(QUEUE_FLAG_SEEKFREE, q);
+	else
+		queue_flag_clear_unlocked(QUEUE_FLAG_SEEKFREE, q);
+}
+EXPORT_SYMBOL(blk_queue_seek_free);
+
 static int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d01b411..3f654d9 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1423,7 +1423,8 @@ retry:
 		cfq_init_prio_data(cfqq, ioc);
 
 		if (is_sync) {
-			if (!cfq_class_idle(cfqq))
+			if (!cfq_class_idle(cfqq) &&
+			    !test_bit(QUEUE_FLAG_SEEKFREE, &cfqd->queue->queue_flags))
 				cfq_mark_cfqq_idle_window(cfqq);
 			cfq_mark_cfqq_sync(cfqq);
 		}
@@ -1680,7 +1681,8 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	/*
 	 * Don't idle for async or idle io prio class
 	 */
-	if (!cfq_cfqq_sync(cfqq) || cfq_class_idle(cfqq))
+	if (!cfq_cfqq_sync(cfqq) || cfq_class_idle(cfqq) ||
+	    test_bit(QUEUE_FLAG_SEEKFREE, &cfqd->queue->queue_flags))
 		return;
 
 	enable_idle = cfq_cfqq_idle_window(cfqq);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d2a1b71..8e77cb5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -409,6 +409,7 @@ struct request_queue
 #define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
 #define QUEUE_FLAG_BIDI		9	/* queue supports bidi requests */
 #define QUEUE_FLAG_NOMERGES    10	/* disable merge attempts */
+#define QUEUE_FLAG_SEEKFREE    11	/* seeks are free */
 
 static inline int queue_is_locked(struct request_queue *q)
 {
@@ -757,6 +758,7 @@ extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_update_dma_alignment(struct request_queue *, int);
+extern void blk_queue_seek_free(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 extern int blk_queue_ordered(struct request_queue *, unsigned, prepare_flush_fn *);

-- 
Jens Axboe

