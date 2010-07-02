From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] block: introduce REQ_FLUSH flag
Date: Fri,  2 Jul 2010 16:33:24 +0900
Message-ID: <1278056005-25438-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278056005-25438-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:41488 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677Ab0GBHeQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jul 2010 03:34:16 -0400
In-Reply-To: <1278056005-25438-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, axboe@kernel.dk
Cc: hch@lst.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

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
index 7c6f4a7..a348242 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -143,7 +143,7 @@ static void queue_flush(struct request_queue *q, unsigned which)
 	}
 
 	blk_rq_init(q, rq);
-	rq->cmd_flags = REQ_HARDBARRIER;
+	rq->cmd_flags = REQ_HARDBARRIER | REQ_FLUSH;
 	rq->rq_disk = q->bar_rq.rq_disk;
 	rq->end_io = end_io;
 	q->prepare_flush_fn(q, rq);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4d379c8..f655b54 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -174,6 +174,7 @@ enum rq_flag_bits {
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_COPY_USER,	/* contains copies of user pages */
 	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
+	__REQ_FLUSH,		/* request for cache flush */
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
 	__REQ_NR_BITS,		/* stops here */
@@ -213,6 +214,7 @@ enum rq_flag_bits {
 #define REQ_ALLOCED		(1 << __REQ_ALLOCED)
 #define REQ_COPY_USER		(1 << __REQ_COPY_USER)
 #define REQ_INTEGRITY		(1 << __REQ_INTEGRITY)
+#define REQ_FLUSH		(1 << __REQ_FLUSH)
 #define REQ_IO_STAT		(1 << __REQ_IO_STAT)
 #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
 
-- 
1.6.5

