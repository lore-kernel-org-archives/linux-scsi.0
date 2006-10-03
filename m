From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: Re: [RFC] [PATCH] helper function for retrieving scsi_cmd given
	host based block layer tag
Date: Tue, 03 Oct 2006 15:27:57 -0700
Message-ID: <1159914477.4859.4.camel@dcslnxpc.site>
References: <1158962434.4040.35.camel@dcslnxpc.site>
	 <0BB3E5E7462EEA4295BC02D49691DC074A3F84@AVEXCH1.qlogic.org>
	 <20061003191026.GU7778@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:38026 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1030624AbWJCW1y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2006 18:27:54 -0400
In-Reply-To: <20061003191026.GU7778@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, David Wagner <david.wagner@qlogic.com>

On Tue, 2006-10-03 at 21:10 +0200, Jens Axboe wrote:
> The content and indentation looks good, but it doesn't apply to the
> current tree. Care to rediff it?
Here it is. Thanks.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
Date: Tue Oct 3 14:52:51 2006 -0700


---

 block/ll_rw_blk.c       |    7 +------
 include/linux/blkdev.h  |    8 ++++++++
 include/scsi/scsi_tcq.h |   20 ++++++++++++++++++++
 3 files changed, 29 insertions(+), 6 deletions(-)

fd6b37cdcd6db09207461f56eeebd377bab49d01
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 83425fb..c847e17 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -840,12 +840,7 @@ EXPORT_SYMBOL(blk_queue_dma_alignment);
  **/
 struct request *blk_queue_find_tag(request_queue_t *q, int tag)
 {
-	struct blk_queue_tag *bqt = q->queue_tags;
-
-	if (unlikely(bqt == NULL || tag >= bqt->real_max_depth))
-		return NULL;
-
-	return bqt->tag_index[tag];
+	return blk_map_queue_find_tag(q->queue_tags, tag);
 }
 
 EXPORT_SYMBOL(blk_queue_find_tag);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1d79b8d..26f7856 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -769,6 +769,14 @@ extern struct blk_queue_tag *blk_init_ta
 extern void blk_free_tags(struct blk_queue_tag *);
 extern void blk_congestion_end(int rw);
 
+static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
+						int tag)
+{
+	if (unlikely(bqt == NULL || tag >= bqt->real_max_depth))
+		return NULL;
+	return bqt->tag_index[tag];
+}
+
 extern void blk_rq_bio_prep(request_queue_t *, struct request *, struct bio *);
 extern int blkdev_issue_flush(struct block_device *, sector_t *);
 
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index c247a28..cf4c219 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -144,5 +144,25 @@ static inline int scsi_init_shared_tag_m
 	return shost->bqt ? 0 : -ENOMEM;
 }
 
+/**
+ * scsi_host_find_tag - find the tagged command by host
+ * @shost:	pointer to scsi_host
+ * @tag:	tag of the scsi_cmnd
+ *
+ * Notes:
+ *	Only works with tags allocated by the generic blk layer.
+ **/
+static inline struct scsi_cmnd *scsi_host_find_tag(struct Scsi_Host *shost,
+						int tag)
+{
+	struct request *req;
+
+	if (tag != SCSI_NO_TAG) {
+		req = blk_map_queue_find_tag(shost->bqt, tag);
+		return req ? (struct scsi_cmnd *)req->special : NULL;
+	}
+	return NULL;
+}
+
 #endif /* CONFIG_BLOCK */
 #endif /* _SCSI_SCSI_TCQ_H */
-- 



