From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] block: introduce REQ_FLUSH flag
Date: Thu, 24 Jun 2010 00:07:31 +0900
Message-ID: <1277305652-2306-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1277305652-2306-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39444 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab0FWPLJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2010 11:11:09 -0400
In-Reply-To: <1277305652-2306-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

SCSI-ml needs a way to mark a request as flush request in
q->prepare_flush_fn because it needs to identify them later (e.g. in
q->request_fn or prep_rq_fn).

queue_flush sets REQ_HARDBARRIER in rq->cmd_flags however the block
layer also sends normal REQ_TYPE_FS requests with REQ_HARDBARRIER. So
SCSI-ml can't use REQ_HARDBARRIER to identify flush requests.

We could change the block layer to clear REQ_HARDBARRIER bit before
sending non flush requests to the lower layers. However, intorudcing
the new flag looks cleaner (surely easier).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-barrier.c |    2 +-
 include/linux/bio.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 4646f6d..ce4e9b8 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -143,7 +143,7 @@ static void queue_flush(struct request_queue *q, unsigned which)
 	}
 
 	blk_rq_init(q, rq);
-	rq->cmd_flags = REQ_HARDBARRIER;
+	rq->cmd_flags = REQ_HARDBARRIER | REQ_FLUSH;
 	rq->rq_disk = q->orig_bar_rq->rq_disk;
 	rq->end_io = end_io;
 	q->prepare_flush_fn(q, rq);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4d379c8..331bd0a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -152,6 +152,7 @@ enum rq_flag_bits {
 	__REQ_SYNC,		/* request is sync (sync write or read) */
 	__REQ_META,		/* metadata io request */
 	__REQ_DISCARD,		/* request to discard sectors */
+	__REQ_FLUSH,		/* request for cache flush */
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
 
 	/* bio only flags */
@@ -187,6 +188,7 @@ enum rq_flag_bits {
 #define REQ_SYNC		(1 << __REQ_SYNC)
 #define REQ_META		(1 << __REQ_META)
 #define REQ_DISCARD		(1 << __REQ_DISCARD)
+#define REQ_FLUSH		(1 << __REQ_FLUSH)
 #define REQ_NOIDLE		(1 << __REQ_NOIDLE)
 
 #define REQ_FAILFAST_MASK \
-- 
1.6.5

