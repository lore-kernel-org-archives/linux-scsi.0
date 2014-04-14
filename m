From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/7] block: all blk-mq requests are tagged
Date: Mon, 14 Apr 2014 10:30:12 +0200
Message-ID: <1397464212-4454-8-git-send-email-hch@lst.de>
References: <blk-mq updates>
 <1397464212-4454-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:43825 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaDNI2I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Apr 2014 04:28:08 -0400
In-Reply-To: <1397464212-4454-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Matias Bjorling <m@bjorling.me>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Instead of setting the REQ_QUEUED flag on each of them just take it into
account in the only macro checking it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/blkdev.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 99617cf..7c0e72f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1102,7 +1102,8 @@ static inline bool blk_needs_flush_plug(struct task_struct *tsk)
 /*
  * tag stuff
  */
-#define blk_rq_tagged(rq)		((rq)->cmd_flags & REQ_QUEUED)
+#define blk_rq_tagged(rq) \
+	((rq)->mq_ctx || ((rq)->cmd_flags & REQ_QUEUED))
 extern int blk_queue_start_tag(struct request_queue *, struct request *);
 extern struct request *blk_queue_find_tag(struct request_queue *, int);
 extern void blk_queue_end_tag(struct request_queue *, struct request *);
-- 
1.7.10.4

