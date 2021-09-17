Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81BF0C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 578A26112E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhIQGyb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:54:31 -0400
Received: from verein.lst.de ([213.95.11.211]:43793 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229456AbhIQGya (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Sep 2021 02:54:30 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CCE9B67373; Fri, 17 Sep 2021 08:53:05 +0200 (CEST)
Date:   Fri, 17 Sep 2021 08:53:05 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: cleanup request queue before releasing
 gendisk
Message-ID: <20210917065305.GA24012@lst.de>
References: <20210915092547.990285-1-ming.lei@redhat.com> <20210915134008.GA13933@lst.de> <YUKfl9Qqsluh+5FX@T590> <20210916101451.GA26782@lst.de> <YUM6uFHqfjWMM5BH@T590> <20210916142009.GA12603@lst.de> <YUQOBKa67R9pEunr@T590.Home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUQOBKa67R9pEunr@T590.Home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 17, 2021 at 11:39:48AM +0800, Ming Lei wrote:
> If we do that, q->disk is really unnecessary, so looks the fix of
> 'd152c682f03c block: add an explicit ->disk backpointer to the request_queue'
> isn't good.
> The original issue added in 'edb0872f44ec block: move the
> bdi from the request_queue to the gendisk' can be fixed simply by moving
> the two lines code in blk_unregister_queue() to blk_cleanup_queue():
> 
>         kobject_uevent(&q->kobj, KOBJ_REMOVE);
>         kobject_del(&q->kobj);

Well, it is still useful to not do the device model dance, especially as
uses of queue->disk will grow in 5.16.

Anyway, can you give this patch a spin?  I've done some basic testing
including nvme surprise removal locally.  Note that just like
blk_cleanup_queue this doesn't actually wait for the freeze to finish.
Eventually we should do that, but I'm sure this will show tons of issues
with drivers not properly cleaning up.

diff --git a/block/blk-core.c b/block/blk-core.c
index 5454db2fa263b..18287c443ae81 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -49,7 +49,6 @@
 #include "blk-mq.h"
 #include "blk-mq-sched.h"
 #include "blk-pm.h"
-#include "blk-rq-qos.h"
 
 struct dentry *blk_debugfs_root;
 
@@ -385,13 +384,8 @@ void blk_cleanup_queue(struct request_queue *q)
 	 */
 	blk_freeze_queue(q);
 
-	rq_qos_exit(q);
-
 	blk_queue_flag_set(QUEUE_FLAG_DEAD, q);
 
-	/* for synchronous bio-based driver finish in-flight integrity i/o */
-	blk_flush_integrity();
-
 	blk_sync_queue(q);
 	if (queue_is_mq(q))
 		blk_mq_exit_queue(q);
@@ -470,19 +464,26 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 
 static inline int bio_queue_enter(struct bio *bio)
 {
-	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
+	struct gendisk *disk = bio->bi_bdev->bd_disk;
 	bool nowait = bio->bi_opf & REQ_NOWAIT;
 	int ret;
 
-	ret = blk_queue_enter(q, nowait ? BLK_MQ_REQ_NOWAIT : 0);
+	ret = blk_queue_enter(disk->queue, nowait ? BLK_MQ_REQ_NOWAIT : 0);
 	if (unlikely(ret)) {
-		if (nowait && !blk_queue_dying(q))
+		if (nowait && !blk_queue_dying(disk->queue))
 			bio_wouldblock_error(bio);
 		else
 			bio_io_error(bio);
+		return ret;
 	}
 
-	return ret;
+	if (unlikely(!disk_live(disk))) {
+		blk_queue_exit(disk->queue);
+		bio_io_error(bio);
+		return -ENODEV;
+	}
+
+	return 0;
 }
 
 void blk_queue_exit(struct request_queue *q)
diff --git a/block/genhd.c b/block/genhd.c
index 7b6e5e1cf9564..8abe12dca76f2 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -26,6 +26,7 @@
 #include <linux/badblocks.h>
 
 #include "blk.h"
+#include "blk-rq-qos.h"
 
 static struct kobject *block_depr;
 
@@ -559,6 +560,8 @@ EXPORT_SYMBOL(device_add_disk);
  */
 void del_gendisk(struct gendisk *disk)
 {
+	struct request_queue *q = disk->queue;
+
 	might_sleep();
 
 	if (WARN_ON_ONCE(!disk_live(disk) && !(disk->flags & GENHD_FL_HIDDEN)))
@@ -572,6 +575,21 @@ void del_gendisk(struct gendisk *disk)
 	blk_drop_partitions(disk);
 	mutex_unlock(&disk->open_mutex);
 
+	/*
+	 * Prevent new I/O from crossing bio_queue_enter().
+	 */
+	blk_freeze_queue_start(q);
+	if (queue_is_mq(q))
+		blk_mq_wake_waiters(q);
+	/* Make blk_queue_enter() reexamine the DYING flag. */
+	wake_up_all(&q->mq_freeze_wq);
+
+	rq_qos_exit(q);
+	blk_sync_queue(q);
+	blk_flush_integrity();
+	/* allow using passthrough request again after the queue is torn down */
+	blk_mq_unfreeze_queue(q);
+
 	fsync_bdev(disk->part0);
 	__invalidate_device(disk->part0, true);
 
