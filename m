From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: Re: [RFC] [PATCH] helper function for retrieving scsi_cmd given
	host based block layer tag
Date: Fri, 22 Sep 2006 15:00:34 -0700
Message-ID: <1158962434.4040.35.camel@dcslnxpc.site>
References: <1158710201.4358.8.camel@dcslnxpc.site>
	 <1158944997.4040.10.camel@dcslnxpc.site> <20060922191156.GL16556@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:5800 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S965198AbWIVWAe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 18:00:34 -0400
In-Reply-To: <20060922191156.GL16556@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, Doug Maxey <dwm@enoyolf.org>, David Wagner <david.wagner@qlogic.com>

On Fri, 2006-09-22 at 21:11 +0200, Jens Axboe wrote:
> On Fri, Sep 22 2006, David C Somayajulu wrote:
> > On Tue, 2006-09-19 at 16:56 -0700, David C Somayajulu wrote:
> > > This was necessitated by the need for a function to get back
> > > to a scsi_cmnd, when an hba the posts its (corresponding) completion 
> > > interrupt with a block layer tag as its reference.
> > Regenerated the patch with reference to
> > git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
> > Also fixed tabs.
> > 
> > Here is the link to the same patch with reference scsi-misc just in case
> > ( ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b10-k/blk_tag_helper_patch.txt  )
> > 
> > Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> > Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
> 
> It still fails for me:
> 
> axboe@nelson:/src/linux-2.6-block.git $ patch -p1 --dry-run < ~/1
> patching file block/ll_rw_blk.c
> Hunk #1 succeeded at 840 (offset 3 lines).
> patching file include/linux/blkdev.h
> Hunk #1 succeeded at 766 (offset 19 lines).
> patching file include/scsi/scsi_tcq.h
> Hunk #1 FAILED at 131.
> 1 out of 1 hunk FAILED -- saving rejects to file
> include/scsi/scsi_tcq.h.rej
> 
> I wonder if you are using the 'block' branch, not just the master
> branch? It seems to apply perfectly there, but that is just the same as
> Linus' tree. So when you have cloned the block git repo, there are a
> number of branches you can work against. The main branch with current
> changes is the 'block' branch, that is what you want to be making
> patches against.
> 
> I'll be away for the entire next week, so no rush on my end.
> 
I think I got it right this time. Here it is.
Thanks
David Somayajulu

---

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 4475fa4..a4a72bd 100644
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
index c55d470..10fd39d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -766,6 +766,14 @@ extern int blk_queue_resize_tags(request
 extern void blk_queue_invalidate_tags(request_queue_t *);
 extern long blk_congestion_wait(int rw, long timeout);
 
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
index d1d9b10..01b7481 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -131,5 +131,25 @@ static inline struct scsi_cmnd *scsi_fin
 	return sdev->current_cmnd;
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

---
