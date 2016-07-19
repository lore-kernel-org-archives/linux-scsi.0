From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] block: add flag for single-threaded submission
Date: Tue, 19 Jul 2016 16:02:56 +0200
Message-ID: <1468936978-9124-2-git-send-email-hare@suse.de>
References: <1468936978-9124-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38396 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789AbcGSODF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 10:03:05 -0400
In-Reply-To: <1468936978-9124-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel-redhat.com@suse.de, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.de>

Some devices (most notably SMR drives) support only
one I/O stream eg for ensuring ordered I/O submission.
This patch adds a new block queue flag
'BLK_QUEUE_SINGLE' to support these devices.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c       | 2 ++
 include/linux/blkdev.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4bcf30a..ff08d77 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -320,6 +320,8 @@ inline void __blk_run_queue_uncond(struct request_queue *q)
 	 * number of active request_fn invocations such that blk_drain_queue()
 	 * can wait until all these request_fn calls have finished.
 	 */
+	if (blk_queue_single(q) && q->request_fn_active)
+		return;
 	q->request_fn_active++;
 	q->request_fn(q);
 	q->request_fn_active--;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c351444..2f7775a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -539,6 +539,7 @@ struct request_queue {
 #define QUEUE_FLAG_WC	       23	/* Write back caching */
 #define QUEUE_FLAG_FUA	       24	/* device supports FUA writes */
 #define QUEUE_FLAG_FLUSH_NQ    25	/* flush not queueuable */
+#define QUEUE_FLAG_SINGLE      26	/* single-threaded submission only */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -628,6 +629,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
 #define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
 	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
+#define blk_queue_single(q)	test_bit(QUEUE_FLAG_SINGLE, &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
-- 
1.8.5.6

