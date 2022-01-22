Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BADCC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jan 2022 11:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbiAVLM6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jan 2022 06:12:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230228AbiAVLM6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Jan 2022 06:12:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642849977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G+NRXXc+hwDjuvMZtnwreB6eugOj8g0/jJ/eXBY93LM=;
        b=FuLc8ZE9VS9Vr+H2iyj+cEwBwNm+ToJlLdWK9Rcg0gWcmmhP+VxwwK2sXCR1PKsnRNizdw
        7fE1T8Ru2W6q7NNEazMiL/8ekerY6jchG9exa8rwQQ2lmLs0nt2gls+Cq9beVxhNUUI/Sz
        MOREVcOF5CAmBGEN/OQeMxbV0Fg+Wjk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-dQCM9ynzOlCq1WlgVh7rGg-1; Sat, 22 Jan 2022 06:12:52 -0500
X-MC-Unique: dQCM9ynzOlCq1WlgVh7rGg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B281818397A7;
        Sat, 22 Jan 2022 11:12:51 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0E7D752CF;
        Sat, 22 Jan 2022 11:12:47 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 13/13] block: don't drain file system I/O on del_gendisk
Date:   Sat, 22 Jan 2022 19:10:54 +0800
Message-Id: <20220122111054.1126146-14-ming.lei@redhat.com>
In-Reply-To: <20220122111054.1126146-1-ming.lei@redhat.com>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 8e141f9eb803 ("block: drain file system I/O on del_gendisk") is
added for avoiding to reference of q->disk after disk is released, since
disk release can be done before running into blk_cleanup_queue(),
but it can't avoid the issue completely, and the approach is very
fragile:

1) queue freezing can't drain FS I/O for bio based driver, so there is
still inflight bios after disk is deleted, so blk-cgroup shutdown
can't be moved to del_gendisk(); meantime elevator shutdown can't be
moved to del_gendisk() because freezing queue isn't enough to drain
io issue activities. So both block-cgroup and elevator code may still
refer to q->disk somewhere. Same with q->disk referring for bio based
driver.

2) the added flag of GD_DEAD may not be observed reliably in
__bio_queue_enter() because queue freezing might not imply rcu grace
period.

Now we have moved blkcg, rqos and elevator shutdown code into disk_release()
where it is guaranteed that no any FS IO is inflight. Meantime we only
account passthrough IO issued from userspace, where q->disk is always
valid. Then q->disk can be guaranteed to be referred before releasing
disk.

So not necessary to drain FS I/O in del_gendisk() any more.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c      | 21 +++++++++------------
 block/blk.h           |  1 -
 block/genhd.c         | 21 ---------------------
 include/linux/genhd.h |  1 -
 4 files changed, 9 insertions(+), 35 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bcb4d982cd80..2216360165c9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -270,8 +270,10 @@ void blk_put_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_put_queue);
 
-void blk_queue_start_drain(struct request_queue *q)
+void blk_set_queue_dying(struct request_queue *q)
 {
+	blk_queue_flag_set(QUEUE_FLAG_DYING, q);
+
 	/*
 	 * When queue DYING flag is set, we need to block new req
 	 * entering queue, so we call blk_freeze_queue_start() to
@@ -283,12 +285,6 @@ void blk_queue_start_drain(struct request_queue *q)
 	/* Make blk_queue_enter() reexamine the DYING flag. */
 	wake_up_all(&q->mq_freeze_wq);
 }
-
-void blk_set_queue_dying(struct request_queue *q)
-{
-	blk_queue_flag_set(QUEUE_FLAG_DYING, q);
-	blk_queue_start_drain(q);
-}
 EXPORT_SYMBOL_GPL(blk_set_queue_dying);
 
 /**
@@ -322,6 +318,9 @@ void blk_cleanup_queue(struct request_queue *q)
 
 	blk_queue_flag_set(QUEUE_FLAG_DEAD, q);
 
+	/* for synchronous bio-based driver finish in-flight integrity i/o */
+	blk_flush_integrity();
+
 	blk_sync_queue(q);
 	if (queue_is_mq(q)) {
 		blk_mq_cancel_work_sync(q);
@@ -381,10 +380,8 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 int __bio_queue_enter(struct request_queue *q, struct bio *bio)
 {
 	while (!blk_try_enter_queue(q, false)) {
-		struct gendisk *disk = bio->bi_bdev->bd_disk;
-
 		if (bio->bi_opf & REQ_NOWAIT) {
-			if (test_bit(GD_DEAD, &disk->state))
+			if (blk_queue_dying(q))
 				goto dead;
 			bio_wouldblock_error(bio);
 			return -EBUSY;
@@ -401,8 +398,8 @@ int __bio_queue_enter(struct request_queue *q, struct bio *bio)
 		wait_event(q->mq_freeze_wq,
 			   (!q->mq_freeze_depth &&
 			    blk_pm_resume_queue(false, q)) ||
-			   test_bit(GD_DEAD, &disk->state));
-		if (test_bit(GD_DEAD, &disk->state))
+			   blk_queue_dying(q));
+		if (blk_queue_dying(q))
 			goto dead;
 	}
 
diff --git a/block/blk.h b/block/blk.h
index a038e25d8637..6adedf97cba2 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -43,7 +43,6 @@ struct blk_flush_queue *blk_alloc_flush_queue(int node, int cmd_size,
 void blk_free_flush_queue(struct blk_flush_queue *q);
 
 void blk_freeze_queue(struct request_queue *q);
-void blk_queue_start_drain(struct request_queue *q);
 int __bio_queue_enter(struct request_queue *q, struct bio *bio);
 bool submit_bio_checks(struct bio *bio);
 
diff --git a/block/genhd.c b/block/genhd.c
index 2f0e92cdcf6d..90742679f949 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -569,8 +569,6 @@ EXPORT_SYMBOL(device_add_disk);
  */
 void del_gendisk(struct gendisk *disk)
 {
-	struct request_queue *q = disk->queue;
-
 	might_sleep();
 
 	if (WARN_ON_ONCE(!disk_live(disk) && !(disk->flags & GENHD_FL_HIDDEN)))
@@ -587,17 +585,8 @@ void del_gendisk(struct gendisk *disk)
 	fsync_bdev(disk->part0);
 	__invalidate_device(disk->part0, true);
 
-	/*
-	 * Fail any new I/O.
-	 */
-	set_bit(GD_DEAD, &disk->state);
 	set_capacity(disk, 0);
 
-	/*
-	 * Prevent new I/O from crossing bio_queue_enter().
-	 */
-	blk_queue_start_drain(q);
-
 	if (!(disk->flags & GENHD_FL_HIDDEN)) {
 		sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
 
@@ -619,16 +608,6 @@ void del_gendisk(struct gendisk *disk)
 		sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
 	pm_runtime_set_memalloc_noio(disk_to_dev(disk), false);
 	device_del(disk_to_dev(disk));
-
-	blk_mq_freeze_queue_wait(q);
-
-	blk_sync_queue(q);
-	blk_flush_integrity();
-	/*
-	 * Allow using passthrough request again after the queue is torn down.
-	 */
-	__blk_mq_unfreeze_queue(q, true);
-
 }
 EXPORT_SYMBOL(del_gendisk);
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 6906a45bc761..3e9f234495e4 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -108,7 +108,6 @@ struct gendisk {
 	unsigned long state;
 #define GD_NEED_PART_SCAN		0
 #define GD_READ_ONLY			1
-#define GD_DEAD				2
 #define GD_NATIVE_CAPACITY		3
 
 	struct mutex open_mutex;	/* open/close mutex */
-- 
2.31.1

