From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH v2] BLOCK: fix bio.bi_rw handling
Date: Thu, 12 Aug 2010 14:31:06 +0200
Message-ID: <1281616266-4709-3-git-send-email-jslaby@suse.cz>
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.pripojeni.net ([217.66.174.14]:55226 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933152Ab0HLMbo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2010 08:31:44 -0400
In-Reply-To: <1281616266-4709-1-git-send-email-jslaby@suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, jirislaby@gmail.com, linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>

Return of the bi_rw tests is no longer bool after commit 74450be1. But
results of such tests are stored in bools. This doesn't fit in there
for some compilers (gcc 4.5 here), so either use !! magic to get real
bools or use ulong where the result is assigned somewhere.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c     |    6 +++---
 drivers/block/loop.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 207af0d..29fd2cc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1198,9 +1198,9 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	int el_ret;
 	unsigned int bytes = bio->bi_size;
 	const unsigned short prio = bio_prio(bio);
-	const bool sync = (bio->bi_rw & REQ_SYNC);
-	const bool unplug = (bio->bi_rw & REQ_UNPLUG);
-	const unsigned int ff = bio->bi_rw & REQ_FAILFAST_MASK;
+	const bool sync = !!(bio->bi_rw & REQ_SYNC);
+	const bool unplug = !!(bio->bi_rw & REQ_UNPLUG);
+	const unsigned long ff = bio->bi_rw & REQ_FAILFAST_MASK;
 	int rw_flags;
 
 	if ((bio->bi_rw & REQ_HARDBARRIER) &&
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index e647537..0ba2899 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -476,7 +476,7 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 	pos = ((loff_t) bio->bi_sector << 9) + lo->lo_offset;
 
 	if (bio_rw(bio) == WRITE) {
-		bool barrier = (bio->bi_rw & REQ_HARDBARRIER);
+		bool barrier = !!(bio->bi_rw & REQ_HARDBARRIER);
 		struct file *file = lo->lo_backing_file;
 
 		if (barrier) {
-- 
1.7.2.1


