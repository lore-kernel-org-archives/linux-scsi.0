From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] remove blk_queue_activity_fn
Date: Tue, 05 Dec 2006 11:09:12 +0200
Message-ID: <45753738.3030607@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:42156 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968128AbWLEJJq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2006 04:09:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

While working on bidi support at struct request level
I have found that blk_queue_activity_fn is actually never used.
The only user is in ide-probe.c with this code:

	/* enable led activity for disk drives only */
	if (drive->media == ide_disk && hwif->led_act)
		blk_queue_activity_fn(q, hwif->led_act, drive);

And led_act is never initialized anywhere.
(Looking back at older kernels it was used in the PPC arch, but was removed around 2.6.18)
Unless it is all for future use off course.
(this patch is against linux-2.6-block.git as off 2006/12/4)


Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 0f82e12..45a4e64 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -127,13 +127,6 @@ struct backing_dev_info *blk_get_backing
 }
 EXPORT_SYMBOL(blk_get_backing_dev_info);

-void blk_queue_activity_fn(request_queue_t *q, activity_fn *fn, void *data)
-{
-	q->activity_fn = fn;
-	q->activity_data = data;
-}
-EXPORT_SYMBOL(blk_queue_activity_fn);
-
 /**
  * blk_queue_prep_rq - set a prepare_request function for queue
  * @q:		queue
@@ -236,8 +229,6 @@ void blk_queue_make_request(request_queu
 	 * by default assume old behaviour and bounce for any highmem page
 	 */
 	blk_queue_bounce_limit(q, BLK_BOUNCE_HIGH);
-
-	blk_queue_activity_fn(q, NULL, NULL);
 }

 EXPORT_SYMBOL(blk_queue_make_request);
@@ -2694,9 +2685,6 @@ static inline void add_request(request_q
 {
 	drive_stat_acct(req, req->nr_sectors, 1);

-	if (q->activity_fn)
-		q->activity_fn(q->activity_data, rq_data_dir(req));
-
 	/*
 	 * elevator indicated where it wants this request to be
 	 * inserted at elevator_merge time
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index dad9c47..5a5c565 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1000,10 +1000,6 @@ #endif /* CONFIG_PCI */
 	/* needs drive->queue to be set */
 	ide_toggle_bounce(drive, 1);

-	/* enable led activity for disk drives only */
-	if (drive->media == ide_disk && hwif->led_act)
-		blk_queue_activity_fn(q, hwif->led_act, drive);
-
 	return 0;
 }

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e1c7286..ea330d7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -342,7 +342,6 @@ typedef void (unplug_fn) (request_queue_

 struct bio_vec;
 typedef int (merge_bvec_fn) (request_queue_t *, struct bio *, struct bio_vec *);
-typedef void (activity_fn) (void *data, int rw);
 typedef int (issue_flush_fn) (request_queue_t *, struct gendisk *, sector_t *);
 typedef void (prepare_flush_fn) (request_queue_t *, struct request *);
 typedef void (softirq_done_fn)(struct request *);
@@ -384,7 +383,6 @@ struct request_queue
 	prep_rq_fn		*prep_rq_fn;
 	unplug_fn		*unplug_fn;
 	merge_bvec_fn		*merge_bvec_fn;
-	activity_fn		*activity_fn;
 	issue_flush_fn		*issue_flush_fn;
 	prepare_flush_fn	*prepare_flush_fn;
 	softirq_done_fn		*softirq_done_fn;
@@ -411,8 +409,6 @@ struct request_queue
 	 */
 	void			*queuedata;

-	void			*activity_data;
-
 	/*
 	 * queue needs bounce pages for pages above this limit
 	 */
@@ -677,7 +673,6 @@ extern void blk_sync_queue(struct reques
 extern void __blk_stop_queue(request_queue_t *q);
 extern void blk_run_queue(request_queue_t *);
 extern void blk_start_queueing(request_queue_t *);
-extern void blk_queue_activity_fn(request_queue_t *, activity_fn *, void *);
 extern int blk_rq_map_user(request_queue_t *, struct request *, void __user *, unsigned long);
 extern int blk_rq_unmap_user(struct request *);
 extern int blk_rq_map_kern(request_queue_t *, struct request *, void *, unsigned int, gfp_t);
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 9c20502..6ba219c 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -803,8 +803,6 @@ #endif
 	void		*hwif_data;	/* extra hwif data */

 	unsigned dma;
-
-	void (*led_act)(void *data, int rw);
 } ____cacheline_internodealigned_in_smp ide_hwif_t;

 /*

