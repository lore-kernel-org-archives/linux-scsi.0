From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH] RAID Cleanup for bio-split
Date: Sat, 23 Apr 2016 18:05:09 -0500
Message-ID: <1461452709-6702-1-git-send-email-shaun@tancheff.com>
References: <1460747777-8479-24-git-send-email-mchristi@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1460747777-8479-24-git-send-email-mchristi@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: mchristi@redhat.com, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Shaun Tancheff <shaun@tancheff.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

It looks like some minor changes slipped through on the RAID.

A couple of checks for REQ_PREFLUSH flag should also check for
bi_op matching REQ_OP_FLUSH.

Wrappers for sync_page_io() are passed READ/WRITE but need to
be passed REQ_OP_READ and REQ_OP_WRITE.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
 drivers/md/raid0.c  |  3 ++-
 drivers/md/raid1.c  | 13 +++++++------
 drivers/md/raid10.c | 21 ++++++++++-----------
 drivers/md/raid5.c  |  3 ++-
 4 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index f95463d..46e9ba8 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -458,7 +458,8 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 	struct md_rdev *tmp_dev;
 	struct bio *split;
 
-	if (unlikely(bio->bi_rw & REQ_PREFLUSH)) {
+	if (unlikely(bio->bi_rw & REQ_PREFLUSH) ||
+	    unlikely(bio->bi_op == REQ_OP_FLUSH)) {
 		md_flush_request(mddev, bio);
 		return;
 	}
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 2a2c177..f7c0577 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1771,12 +1771,12 @@ static void end_sync_write(struct bio *bio)
 }
 
 static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
-			    int sectors, struct page *page, int rw)
+			    int sectors, struct page *page, int op)
 {
-	if (sync_page_io(rdev, sector, sectors << 9, page, rw, 0, false))
+	if (sync_page_io(rdev, sector, sectors << 9, page, op, 0, false))
 		/* success */
 		return 1;
-	if (rw == WRITE) {
+	if (op == REQ_OP_WRITE) {
 		set_bit(WriteErrorSeen, &rdev->flags);
 		if (!test_and_set_bit(WantReplacement,
 				      &rdev->flags))
@@ -1883,7 +1883,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			rdev = conf->mirrors[d].rdev;
 			if (r1_sync_page_io(rdev, sect, s,
 					    bio->bi_io_vec[idx].bv_page,
-					    WRITE) == 0) {
+					    REQ_OP_WRITE) == 0) {
 				r1_bio->bios[d]->bi_end_io = NULL;
 				rdev_dec_pending(rdev, mddev);
 			}
@@ -2118,7 +2118,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 			if (rdev &&
 			    !test_bit(Faulty, &rdev->flags))
 				r1_sync_page_io(rdev, sect, s,
-						conf->tmppage, WRITE);
+						conf->tmppage, REQ_OP_WRITE);
 		}
 		d = start;
 		while (d != read_disk) {
@@ -2130,7 +2130,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 			if (rdev &&
 			    !test_bit(Faulty, &rdev->flags)) {
 				if (r1_sync_page_io(rdev, sect, s,
-						    conf->tmppage, READ)) {
+						    conf->tmppage, REQ_OP_READ)) {
 					atomic_add(s, &rdev->corrected_errors);
 					printk(KERN_INFO
 					       "md/raid1:%s: read error corrected "
@@ -2204,6 +2204,7 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 		}
 
 		wbio->bi_op = REQ_OP_WRITE;
+		wbio->bi_rw = 0;
 		wbio->bi_iter.bi_sector = r1_bio->sector;
 		wbio->bi_iter.bi_size = r1_bio->sectors << 9;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c5dc4e4..44e87c2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1364,8 +1364,7 @@ retry_write:
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
 			mbio->bi_op = op;
-			mbio->bi_rw =
-				do_sync | do_fua | do_sec;
+			mbio->bi_rw = do_sync | do_fua | do_sec;
 			mbio->bi_private = r10_bio;
 
 			atomic_inc(&r10_bio->remaining);
@@ -1408,8 +1407,7 @@ retry_write:
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
 			mbio->bi_op = op;
-			mbio->bi_rw =
-				do_sync | do_fua | do_sec;
+			mbio->bi_rw = do_sync | do_fua | do_sec;
 			mbio->bi_private = r10_bio;
 
 			atomic_inc(&r10_bio->remaining);
@@ -1452,7 +1450,8 @@ static void raid10_make_request(struct mddev *mddev, struct bio *bio)
 
 	struct bio *split;
 
-	if (unlikely(bio->bi_rw & REQ_PREFLUSH)) {
+	if (unlikely(bio->bi_rw & REQ_PREFLUSH) ||
+	    unlikely(bio->bi_op == REQ_OP_FLUSH)) {
 		md_flush_request(mddev, bio);
 		return;
 	}
@@ -2207,18 +2206,18 @@ static void check_decay_read_errors(struct mddev *mddev, struct md_rdev *rdev)
 }
 
 static int r10_sync_page_io(struct md_rdev *rdev, sector_t sector,
-			    int sectors, struct page *page, int rw)
+			    int sectors, struct page *page, int op)
 {
 	sector_t first_bad;
 	int bad_sectors;
 
 	if (is_badblock(rdev, sector, sectors, &first_bad, &bad_sectors)
-	    && (rw == READ || test_bit(WriteErrorSeen, &rdev->flags)))
+	    && (op == REQ_OP_READ || test_bit(WriteErrorSeen, &rdev->flags)))
 		return -1;
-	if (sync_page_io(rdev, sector, sectors << 9, page, rw, 0, false))
+	if (sync_page_io(rdev, sector, sectors << 9, page, op, 0, false))
 		/* success */
 		return 1;
-	if (rw == WRITE) {
+	if (op == REQ_OP_WRITE) {
 		set_bit(WriteErrorSeen, &rdev->flags);
 		if (!test_and_set_bit(WantReplacement, &rdev->flags))
 			set_bit(MD_RECOVERY_NEEDED,
@@ -2354,7 +2353,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 			if (r10_sync_page_io(rdev,
 					     r10_bio->devs[sl].addr +
 					     sect,
-					     s, conf->tmppage, WRITE)
+					     s, conf->tmppage, REQ_OP_WRITE)
 			    == 0) {
 				/* Well, this device is dead */
 				printk(KERN_NOTICE
@@ -2394,7 +2393,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 					     r10_bio->devs[sl].addr +
 					     sect,
 					     s, conf->tmppage,
-						 READ)) {
+						 REQ_OP_READ)) {
 			case 0:
 				/* Well, this device is dead */
 				printk(KERN_NOTICE
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8504862..3e5a9db 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5161,7 +5161,8 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	DEFINE_WAIT(w);
 	bool do_prepare;
 
-	if (unlikely(bi->bi_rw & REQ_PREFLUSH)) {
+	if (unlikely(bi->bi_rw & REQ_PREFLUSH) ||
+	    unlikely(bi->bi_op == REQ_OP_FLUSH)) {
 		int ret = r5l_handle_flush_request(conf->log, bi);
 
 		if (ret == 0)
-- 
2.8.1
