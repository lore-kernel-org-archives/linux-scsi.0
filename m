From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [BLOCK] Tags should form increasing sequence
Date: Mon, 10 Jan 2011 11:47:20 -0800 (PST)
Message-ID: <987349.38793.qm@web31812.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:45867 "HELO
	web31812.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754210Ab1AJTrW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2011 14:47:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 block/blk-tag.c        |   19 +++++++++++++++----
 include/linux/blkdev.h |    1 +
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/block/blk-tag.c b/block/blk-tag.c
index ece65fc..744cea6 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -130,6 +130,7 @@ init_tag_map(struct request_queue *q, struct blk_queue_tag *tags, int depth)
        tags->max_depth = depth;
        tags->tag_index = tag_index;
        tags->tag_map = tag_map;
+       tags->last_tag = -1;
 
        return 0;
 fail:
@@ -222,7 +223,7 @@ int blk_queue_resize_tags(struct request_queue *q, int new_depth)
        struct blk_queue_tag *bqt = q->queue_tags;
        struct request **tag_index;
        unsigned long *tag_map;
-       int max_depth, nr_ulongs;
+       int max_depth, nr_ulongs, last_tag;
 
        if (!bqt)
                return -ENXIO;
@@ -251,6 +252,7 @@ int blk_queue_resize_tags(struct request_queue *q, int new_depth)
        tag_index = bqt->tag_index;
        tag_map = bqt->tag_map;
        max_depth = bqt->real_max_depth;
+       last_tag = bqt->last_tag;
 
        if (init_tag_map(q, bqt, new_depth))
                return -ENOMEM;
@@ -258,6 +260,7 @@ int blk_queue_resize_tags(struct request_queue *q, int new_depth)
        memcpy(bqt->tag_index, tag_index, max_depth * sizeof(struct request *));
        nr_ulongs = ALIGN(max_depth, BITS_PER_LONG) / BITS_PER_LONG;
        memcpy(bqt->tag_map, tag_map, nr_ulongs * sizeof(unsigned long));
+       bqt->last_tag = last_tag;
 
        kfree(tag_index);
        kfree(tag_map);
@@ -337,7 +340,7 @@ EXPORT_SYMBOL(blk_queue_end_tag);
 int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 {
        struct blk_queue_tag *bqt = q->queue_tags;
-       unsigned max_depth;
+       int max_depth;
        int tag;
 
        if (unlikely((rq->cmd_flags & REQ_QUEUED))) {
@@ -358,18 +361,26 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
        max_depth = bqt->max_depth;
        if (!rq_is_sync(rq) && max_depth > 1) {
                max_depth -= 2;
-               if (!max_depth)
+               if (max_depth <= 0)
                        max_depth = 1;
                if (q->in_flight[BLK_RW_ASYNC] > max_depth)
                        return 1;
        }
 
+       if (bqt->last_tag == bqt->max_depth-1)
+               bqt->last_tag = -1;
+
        do {
-               tag = find_first_zero_bit(bqt->tag_map, max_depth);
+               tag = find_next_zero_bit(bqt->tag_map,
+                                        max_depth,
+                                        bqt->last_tag+1);
                if (tag >= max_depth)
                        return 1;
 
        } while (test_and_set_bit_lock(tag, bqt->tag_map));
+
+       bqt->last_tag = tag;
+
        /*
         * We need lock ordering semantics given by test_and_set_bit_lock.
         * See blk_queue_end_tag for details.
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 36ab42c..852dc45 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -224,6 +224,7 @@ struct blk_queue_tag {
        int max_depth;                  /* what we will send to device */
        int real_max_depth;             /* what the array can hold */
        atomic_t refcnt;                /* map can be shared */
+       int last_tag;
 };
 
 #define BLK_SCSI_MAX_CMDS      (256)
-- 
1.7.2.2.165.gbc382

