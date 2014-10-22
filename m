From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/18] blk-lib: fix error reporting
Date: Wed, 22 Oct 2014 09:26:04 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1410220925440.31351@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The function bio_batch_end_io ignores -EOPNOTSUPP. It doesn't matter for
discard (the device isn't required to discard anything, so missing the
error code and reporting success shouldn't cause any trouble). However,
for WRITE SAME command, missing the error code is obviously wrong. It may
fool the user into thinking that the data were written while in fact they
weren't.

Note that in device mapper, devices may be dynamically reconfigured, so a
device that supports WRITE SAME may stop supporting it at any time and
return -EOPNOTSUPP. Ignoring -EOPNOTSUPP is wrong.

This patch changes bio_batch->flags to an error field and stores the last
error there - so that the error is reported accurately and it isn't
ignored.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 block/blk-lib.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

Index: linux-3.16-rc3/block/blk-lib.c
===================================================================
--- linux-3.16-rc3.orig/block/blk-lib.c	2014-07-03 18:17:21.000000000 +0200
+++ linux-3.16-rc3/block/blk-lib.c	2014-07-03 18:36:52.000000000 +0200
@@ -11,7 +11,7 @@
 
 struct bio_batch {
 	atomic_t		done;
-	unsigned long		flags;
+	int			error;
 	struct completion	*wait;
 };
 
@@ -19,8 +19,8 @@ static void bio_batch_end_io(struct bio 
 {
 	struct bio_batch *bb = bio->bi_private;
 
-	if (err && (err != -EOPNOTSUPP))
-		clear_bit(BIO_UPTODATE, &bb->flags);
+	if (unlikely(err))
+		ACCESS_ONCE(bb->error) = err;
 	if (atomic_dec_and_test(&bb->done))
 		complete(bb->wait);
 	bio_put(bio);
@@ -78,7 +78,7 @@ int blkdev_issue_discard(struct block_de
 	}
 
 	atomic_set(&bb.done, 1);
-	bb.flags = 1 << BIO_UPTODATE;
+	bb.error = 0;
 	bb.wait = &wait;
 
 	blk_start_plug(&plug);
@@ -134,8 +134,8 @@ int blkdev_issue_discard(struct block_de
 	if (!atomic_dec_and_test(&bb.done))
 		wait_for_completion_io(&wait);
 
-	if (!test_bit(BIO_UPTODATE, &bb.flags))
-		ret = -EIO;
+	if (likely(!ret))
+		ret = bb.error;
 
 	return ret;
 }
@@ -172,7 +172,7 @@ int blkdev_issue_write_same(struct block
 		return -EOPNOTSUPP;
 
 	atomic_set(&bb.done, 1);
-	bb.flags = 1 << BIO_UPTODATE;
+	bb.error = 0;
 	bb.wait = &wait;
 
 	while (nr_sects) {
@@ -208,8 +208,8 @@ int blkdev_issue_write_same(struct block
 	if (!atomic_dec_and_test(&bb.done))
 		wait_for_completion_io(&wait);
 
-	if (!test_bit(BIO_UPTODATE, &bb.flags))
-		ret = -ENOTSUPP;
+	if (likely(!ret))
+		ret = bb.error;
 
 	return ret;
 }
@@ -236,7 +236,7 @@ static int __blkdev_issue_zeroout(struct
 	DECLARE_COMPLETION_ONSTACK(wait);
 
 	atomic_set(&bb.done, 1);
-	bb.flags = 1 << BIO_UPTODATE;
+	bb.error = 0;
 	bb.wait = &wait;
 
 	ret = 0;
@@ -270,9 +270,8 @@ static int __blkdev_issue_zeroout(struct
 	if (!atomic_dec_and_test(&bb.done))
 		wait_for_completion_io(&wait);
 
-	if (!test_bit(BIO_UPTODATE, &bb.flags))
-		/* One of bios in the batch was completed with error.*/
-		ret = -EIO;
+	if (likely(!ret))
+		ret = bb.error;
 
 	return ret;
 }
