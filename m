From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: RFC] [PATCH] helper function for retrieving scsi_cmd given host
	based block layer tag
Date: Tue, 19 Sep 2006 16:56:40 -0700
Message-ID: <1158710201.4358.8.camel@dcslnxpc.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:47688 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1750925AbWISX4l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 19:56:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org
Cc: open-iscsi@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>, Doug Maxey <dwm@enoyolf.org>, David Wagner <david.wagner@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Duane Grigsby <duane.grigsby@qlogic.com>

This was necessitated by the need for a function to get back
to a scsi_cmnd, when an hba the posts its (corresponding) completion 
interrupt with a block layer tag as its reference.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>

---

 block/ll_rw_blk.c       |    7 +------
 include/linux/blkdev.h  |    8 ++++++++
 include/scsi/scsi_tcq.h |   20 ++++++++++++++++++++
 3 files changed, 29 insertions(+), 6 deletions(-)

39a4a2005c490d22a3e5c4430e5e71375615de73
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 556a3d3..4aea565 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -837,12 +837,7 @@ EXPORT_SYMBOL(blk_queue_dma_alignment);
  **/
 struct request *blk_queue_find_tag(request_queue_t *q, int tag)
 {
-       struct blk_queue_tag *bqt = q->queue_tags;
-
-       if (unlikely(bqt == NULL || tag >= bqt->real_max_depth))
-               return NULL;
-
-       return bqt->tag_index[tag];
+       return blk_map_queue_find_tag(q->queue_tags, tag);
 }
 
 EXPORT_SYMBOL(blk_queue_find_tag);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 427b0d6..dd16ce9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -749,6 +749,14 @@ extern long blk_congestion_wait(int rw, 
 extern struct blk_queue_tag *blk_init_tags(int);
 extern void blk_free_tags(struct blk_queue_tag *);
 
+static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt, 
+                                               int tag)
+{
+       if (unlikely(bqt == NULL || tag >= bqt->real_max_depth))
+               return NULL;
+       return bqt->tag_index[tag];
+}
+
 extern void blk_rq_bio_prep(request_queue_t *, struct request *, struct bio *);
 extern int blkdev_issue_flush(struct block_device *, sector_t *);
 
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index d04d05a..1215ffe 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -144,4 +144,24 @@ static inline int scsi_init_shared_tag_m
        return shost->bqt ? 0 : -ENOMEM;
 }
 
+/**
+ * scsi_host_find_tag - find the tagged command by host
+ * @shost: pointer to scsi host
+ * @tag: tag of the scsi_cmnd
+ *
+ * Notes:
+ *     Only works with tags allocated by the generic blk layer.
+ */
+static inline struct scsi_cmnd *scsi_host_find_tag(struct Scsi_Host *shost,
+                                               int tag)
+{
+        struct request *req;
+
+        if (tag != SCSI_NO_TAG) {
+               req = blk_map_queue_find_tag(shost->bqt, tag);
+               return req ? (struct scsi_cmnd *)req->special : NULL;
+       }
+       return NULL;
+}
+
 #endif /* _SCSI_SCSI_TCQ_H */
-- 

