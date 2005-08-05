From: Tejun Heo <htejun@gmail.com>
Subject: Re: calling scsi_adjust_queue_depth() during I/O...
Date: Fri, 5 Aug 2005 21:33:01 +0900
Message-ID: <20050805123301.GA3311@htj.dyndns.org>
References: <20050804234155.GJ13374@plap.qlogic.org> <20050805075751.GN9369@suse.de> <20050805110911.GA22867@htj.dyndns.org> <42F350E6.2090109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.200]:62152 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S263001AbVHEMdH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2005 08:33:07 -0400
Received: by zproxy.gmail.com with SMTP id i11so343417nzh
        for <linux-scsi@vger.kernel.org>; Fri, 05 Aug 2005 05:33:06 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <42F350E6.2090109@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

>  Oops, forget about the previous mail.  Above patch make it into the 
> tree and it's the source of the problem.  My git HEAD was pointing at 
> the latest update but I haven't updated my cache, so I was looking at 
> the old source tree.  My apologies for the hassle and the bug.
> 
>  Original code was broken in the following two points.
> 
>  * tag_index wasn't allocated fully
>  * tag_map's extra bits were always initialized w/ 1's.
> 
>  The first bug is critical and the second bug prevents proper enlarging 
> of tag map.  However, the second bug effectively masks the first bug 
> avoiding critical problem.  My above mentioned patch broke things 
> seriously when reducing tag size on flight.
> 
>  Again, my apologies and patch will soon follow.

 Here's the fix.  It basically revives bqt->real_max_depth sans
allocation optimization in init_tag_map.  I've also added a comment
explicitly noting that tag map cannot be shrunk to prevent other
morons like me.  :-( Please try this one and let me know how it works.
If this is the correct fix, I'll repost properly to Jens and lkml with
detailed explanation on how it was broken in the original code and how
I broke it with my previous patch.  Sorry.


diff --git a/drivers/block/ll_rw_blk.c b/drivers/block/ll_rw_blk.c
--- a/drivers/block/ll_rw_blk.c
+++ b/drivers/block/ll_rw_blk.c
@@ -719,7 +719,7 @@ struct request *blk_queue_find_tag(reque
 {
 	struct blk_queue_tag *bqt = q->queue_tags;
 
-	if (unlikely(bqt == NULL || tag >= bqt->max_depth))
+	if (unlikely(bqt == NULL || tag >= bqt->real_max_depth))
 		return NULL;
 
 	return bqt->tag_index[tag];
@@ -798,6 +798,7 @@ init_tag_map(request_queue_t *q, struct 
 
 	memset(tag_index, 0, depth * sizeof(struct request *));
 	memset(tag_map, 0, nr_ulongs * sizeof(unsigned long));
+	tags->real_max_depth = depth;
 	tags->max_depth = depth;
 	tags->tag_index = tag_index;
 	tags->tag_map = tag_map;
@@ -872,11 +873,22 @@ int blk_queue_resize_tags(request_queue_
 		return -ENXIO;
 
 	/*
+	 * if we already have large enough real_max_depth.  just
+	 * adjust max_depth.  *NOTE* as requests with tag value
+	 * between new_depth and real_max_depth can be in-flight, tag
+	 * map cannot be shrunk.
+	 */
+	if (new_depth <= bqt->real_max_depth) {
+		bqt->max_depth = new_depth;
+		return 0;
+	}
+
+	/*
 	 * save the old state info, so we can copy it back
 	 */
 	tag_index = bqt->tag_index;
 	tag_map = bqt->tag_map;
-	max_depth = bqt->max_depth;
+	max_depth = bqt->real_max_depth;
 
 	if (init_tag_map(q, bqt, new_depth))
 		return -ENOMEM;
@@ -913,7 +925,7 @@ void blk_queue_end_tag(request_queue_t *
 
 	BUG_ON(tag == -1);
 
-	if (unlikely(tag >= bqt->max_depth))
+	if (unlikely(tag >= bqt->real_max_depth))
 		/*
 		 * This can happen after tag depth has been reduced.
 		 * FIXME: how about a warning or info message here?
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -301,6 +301,7 @@ struct blk_queue_tag {
 	struct list_head busy_list;	/* fifo list of busy tags */
 	int busy;			/* current depth */
 	int max_depth;			/* what we will send to device */
+	int real_max_depth;		/* what the array can hold */
 	atomic_t refcnt;		/* map can be shared */
 };
 

