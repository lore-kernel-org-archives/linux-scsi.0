From: mchristi@redhat.com
Subject: [PATCH 04/32] block: prepare blkdev_issue_discard for bi_rw split
Date: Wed,  4 Nov 2015 16:08:01 -0600
Message-ID: <1446674909-5371-5-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

The next patches will prepare the submit_bio users
for the split. There were a lot more users than
there were for submit_bio_wait, so if the conversion
was not a one liner, I broke it out into its own
patch.

This patch prepares blkdev_issue_discard.

There is some compat code left which will be dropped
in later patches in the series.
1. REQ_WRITE is still being set. This is because a lot
of code assumes it will be set for discard, flushes and
write sames.
2. submit_bio is still taking a bitmap. This is to make
the series git bisectable.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/blk-lib.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 9ebf653..0861c7a 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -42,7 +42,8 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
-	int type = REQ_WRITE | REQ_DISCARD;
+	int op = REQ_OP_DISCARD;
+	int op_flags = REQ_WRITE;
 	unsigned int granularity;
 	int alignment;
 	struct bio_batch bb;
@@ -63,7 +64,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	if (flags & BLKDEV_DISCARD_SECURE) {
 		if (!blk_queue_secdiscard(q))
 			return -EOPNOTSUPP;
-		type |= REQ_SECURE;
+		op_flags |= REQ_SECURE;
 	}
 
 	atomic_set(&bb.done, 1);
@@ -108,7 +109,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector = end_sect;
 
 		atomic_inc(&bb.done);
-		submit_bio(type, bio);
+		submit_bio(op | op_flags, bio);
 
 		/*
 		 * We can loop for a long time in here, if someone does
-- 
1.8.3.1
