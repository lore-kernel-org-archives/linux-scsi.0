From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [BLOCK] Allow tag 0 to be generated
Date: Mon, 10 Jan 2011 11:27:49 -0800 (PST)
Message-ID: <835205.47474.qm@web31809.mail.mud.yahoo.com>
References: <4D2B555C.5090109@fusionio.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:28905 "HELO
	web31809.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752029Ab1AJT1v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2011 14:27:51 -0500
In-Reply-To: <4D2B555C.5090109@fusionio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

--- On Mon, 1/10/11, Jens Axboe <jaxboe@fusionio.com> wrote:
> > That commit isn't a valid sha in my tree. What commit
> do you mean?
> > 
> >> skipped tag 0 by virtue of setting last_tag to
> >> 0. This commit sets it to -1, in order to start
> >> and loop over from 0, thus generating tags
> >> [0,max_tag-1], instead of [1,max_tag-1].
> > 
> > Irregardless, patch looks good. That's definitely a
> bug. Thanks!
> 
> But not in my kernel, what tree are you looking at? I don't
> remember
> seeing any tag patches, and they should be in my tree if
> there are.

It applies on top of this patch:

>From 67869fb9fdfa04503b250d59e086c15f1698aea0 Mon Sep 17 00:00:00 2001
From: Luben Tuikov <ltuikov@yahoo.com>
Date: Wed, 24 Nov 2010 14:18:27 -0800
Subject: [PATCH] [BLOCK] Preliminary increasing tag sequence implementation

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 block/blk-tag.c        |   15 +++++++++++++--
 include/linux/blkdev.h |    1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/block/blk-tag.c b/block/blk-tag.c
index ece65fc..f792e98 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -130,6 +130,7 @@ init_tag_map(struct request_queue *q, struct blk_queue_tag *tags, int depth)
        tags->max_depth = depth;
        tags->tag_index = tag_index;
        tags->tag_map = tag_map;
+       tags->last_tag = 0;
 
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
@@ -364,12 +367,20 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
                        return 1;
        }
 
+       if (bqt->last_tag == bqt->max_depth-1)
+               bqt->last_tag = 0;
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
index aae86fd..228efcc 100644
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


