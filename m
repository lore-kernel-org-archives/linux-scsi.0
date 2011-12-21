From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2] block: fix blk_queue_end_tag()
Date: Wed, 21 Dec 2011 10:09:13 -0800
Message-ID: <20111221180703.26525.17796.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Tao Ma <boyu.mt@taobao.com>, Meelis Roos <mroos@ut.ee>, linux-kernel@vger.kernel.org, Ed Nadolski <edmund.nadolski@intel.com>
List-Id: linux-scsi@vger.kernel.org

Commit 5e081591 "block: warn if tag is greater than real_max_depth"
cleaned up blk_queue_end_tag() to warn when the tag is truly invalid
(greater than real_max_depth).  However, it changed behavior in the tag
< max_depth case to not end the request.  Leading to triggering of
BUG_ON(blk_queued_rq(rq)) in the request completion path:

  http://marc.info/?l=linux-kernel&m=132204370518629&w=2

In order to allow blk_queue_resize_tags() to shrink the tag space
blk_queue_end_tag() must always complete tags with a value less than
real_max_depth regardless of the current max_depth.  The comment about
"handling the shrink case" seems to be what prompted changes in this
space, so remove it and BUG on all invalid tags (made even simpler by
Matthew's suggestion to use an unsigned compare).

Cc: Tao Ma <boyu.mt@taobao.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Reported-by: Meelis Roos <mroos@ut.ee>
Reported-by: Ed Nadolski <edmund.nadolski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
v2: kill the warn+comment, and, per Matthew, do an unsigned compare to
    catch the entire range of known invalid tags.

 block/blk-tag.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/block/blk-tag.c b/block/blk-tag.c
index e74d6d1..4af6f5c 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -282,18 +282,9 @@ EXPORT_SYMBOL(blk_queue_resize_tags);
 void blk_queue_end_tag(struct request_queue *q, struct request *rq)
 {
 	struct blk_queue_tag *bqt = q->queue_tags;
-	int tag = rq->tag;
+	unsigned tag = rq->tag; /* negative tags invalid */
 
-	BUG_ON(tag == -1);
-
-	if (unlikely(tag >= bqt->max_depth)) {
-		/*
-		 * This can happen after tag depth has been reduced.
-		 * But tag shouldn't be larger than real_max_depth.
-		 */
-		WARN_ON(tag >= bqt->real_max_depth);
-		return;
-	}
+	BUG_ON(tag >= bqt->real_max_depth);
 
 	list_del_init(&rq->queuelist);
 	rq->cmd_flags &= ~REQ_QUEUED;
