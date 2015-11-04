From: mchristi@redhat.com
Subject: [PATCH 20/32] md: set bi_op to REQ_OP
Date: Wed,  4 Nov 2015 16:08:17 -0600
Message-ID: <1446674909-5371-21-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This patch has md set the bi_op.

For compat reasons, we are still ORing the op into bi_rw. This
will be dropped in later patches in this series when everyone
is updated.

For discards, I am also still passing in REQ_WRITE in with the
flags, so code that has not yet been converted will work like
before. This will be cleaned up in later patches when everyone
is converted.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/md/raid1.c  |  9 +++++++++
 drivers/md/raid10.c | 13 +++++++++++++
 drivers/md/raid5.c  | 50 +++++++++++++++++++++++++++++++-------------------
 3 files changed, 53 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 527fdf5..94e5a63 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1051,6 +1051,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	int i, disks;
 	struct bitmap *bitmap;
 	unsigned long flags;
+	const int op = bio->bi_op;
 	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
 	const unsigned long do_flush_fua = (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
@@ -1164,6 +1165,7 @@ read_again:
 			mirror->rdev->data_offset;
 		read_bio->bi_bdev = mirror->rdev->bdev;
 		read_bio->bi_end_io = raid1_end_read_request;
+		read_bio->bi_op = REQ_OP_READ;
 		read_bio->bi_rw = READ | do_sync;
 		read_bio->bi_private = r1_bio;
 
@@ -1374,6 +1376,7 @@ read_again:
 				   conf->mirrors[i].rdev->data_offset);
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
+		mbio->bi_op = op;
 		mbio->bi_rw =
 			WRITE | do_flush_fua | do_sync | do_discard | do_same;
 		mbio->bi_private = r1_bio;
@@ -2017,6 +2020,7 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 		      !test_bit(MD_RECOVERY_SYNC, &mddev->recovery))))
 			continue;
 
+		wbio->bi_op = REQ_OP_WRITE;
 		wbio->bi_rw = WRITE;
 		wbio->bi_end_io = end_sync_write;
 		atomic_inc(&r1_bio->remaining);
@@ -2188,6 +2192,7 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 			wbio = bio_clone_mddev(r1_bio->master_bio, GFP_NOIO, mddev);
 		}
 
+		wbio->bi_op = REQ_OP_WRITE;
 		wbio->bi_rw = WRITE;
 		wbio->bi_iter.bi_sector = r1_bio->sector;
 		wbio->bi_iter.bi_size = r1_bio->sectors << 9;
@@ -2329,6 +2334,7 @@ read_more:
 		bio->bi_iter.bi_sector = r1_bio->sector + rdev->data_offset;
 		bio->bi_bdev = rdev->bdev;
 		bio->bi_end_io = raid1_end_read_request;
+		bio->bi_op  = REQ_OP_READ;
 		bio->bi_rw = READ | do_sync;
 		bio->bi_private = r1_bio;
 		if (max_sectors < r1_bio->sectors) {
@@ -2544,6 +2550,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 			if (i < conf->raid_disks)
 				still_degraded = 1;
 		} else if (!test_bit(In_sync, &rdev->flags)) {
+			bio->bi_op = REQ_OP_WRITE;
 			bio->bi_rw = WRITE;
 			bio->bi_end_io = end_sync_write;
 			write_targets ++;
@@ -2571,6 +2578,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 					if (disk < 0)
 						disk = i;
 				}
+				bio->bi_op = REQ_OP_READ;
 				bio->bi_rw = READ;
 				bio->bi_end_io = end_sync_read;
 				read_targets++;
@@ -2583,6 +2591,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 				 * if we are doing resync or repair. Otherwise, leave
 				 * this device alone for this sync request.
 				 */
+				bio->bi_op = REQ_OP_WRITE;
 				bio->bi_rw = WRITE;
 				bio->bi_end_io = end_sync_write;
 				write_targets++;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 69352a6..c7430f9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1058,6 +1058,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 	struct r10bio *r10_bio;
 	struct bio *read_bio;
 	int i;
+	const int op = bio->bi_op;
 	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
 	const unsigned long do_fua = (bio->bi_rw & REQ_FUA);
@@ -1156,6 +1157,7 @@ read_again:
 			choose_data_offset(r10_bio, rdev);
 		read_bio->bi_bdev = rdev->bdev;
 		read_bio->bi_end_io = raid10_end_read_request;
+		read_bio->bi_op = REQ_OP_READ;
 		read_bio->bi_rw = READ | do_sync;
 		read_bio->bi_private = r10_bio;
 
@@ -1363,6 +1365,7 @@ retry_write:
 							      rdev));
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
+			mbio->bi_op = op;
 			mbio->bi_rw =
 				WRITE | do_sync | do_fua | do_discard | do_same;
 			mbio->bi_private = r10_bio;
@@ -1406,6 +1409,7 @@ retry_write:
 						   r10_bio, rdev));
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
+			mbio->bi_op = op;
 			mbio->bi_rw =
 				WRITE | do_sync | do_fua | do_discard | do_same;
 			mbio->bi_private = r10_bio;
@@ -1988,6 +1992,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
 		tbio->bi_vcnt = vcnt;
 		tbio->bi_iter.bi_size = r10_bio->sectors << 9;
+		tbio->bi_op = REQ_OP_WRITE;
 		tbio->bi_rw = WRITE;
 		tbio->bi_private = r10_bio;
 		tbio->bi_iter.bi_sector = r10_bio->devs[i].addr;
@@ -2544,6 +2549,7 @@ read_more:
 	bio->bi_iter.bi_sector = r10_bio->devs[slot].addr
 		+ choose_data_offset(r10_bio, rdev);
 	bio->bi_bdev = rdev->bdev;
+	bio->bi_op = REQ_OP_READ;
 	bio->bi_rw = READ | do_sync;
 	bio->bi_private = r10_bio;
 	bio->bi_end_io = raid10_end_read_request;
@@ -3031,6 +3037,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				biolist = bio;
 				bio->bi_private = r10_bio;
 				bio->bi_end_io = end_sync_read;
+				bio->bi_op = REQ_OP_READ;
 				bio->bi_rw = READ;
 				from_addr = r10_bio->devs[j].addr;
 				bio->bi_iter.bi_sector = from_addr +
@@ -3057,6 +3064,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 					biolist = bio;
 					bio->bi_private = r10_bio;
 					bio->bi_end_io = end_sync_write;
+					bio->bi_op = REQ_OP_WRITE;
 					bio->bi_rw = WRITE;
 					bio->bi_iter.bi_sector = to_addr
 						+ rdev->data_offset;
@@ -3086,6 +3094,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				biolist = bio;
 				bio->bi_private = r10_bio;
 				bio->bi_end_io = end_sync_write;
+				bio->bi_op = REQ_OP_WRITE;
 				bio->bi_rw = WRITE;
 				bio->bi_iter.bi_sector = to_addr +
 					rdev->data_offset;
@@ -3206,6 +3215,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 			biolist = bio;
 			bio->bi_private = r10_bio;
 			bio->bi_end_io = end_sync_read;
+			bio->bi_op = REQ_OP_READ;
 			bio->bi_rw = READ;
 			bio->bi_iter.bi_sector = sector +
 				conf->mirrors[d].rdev->data_offset;
@@ -3228,6 +3238,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 			biolist = bio;
 			bio->bi_private = r10_bio;
 			bio->bi_end_io = end_sync_write;
+			bio->bi_op = REQ_OP_WRITE;
 			bio->bi_rw = WRITE;
 			bio->bi_iter.bi_sector = sector +
 				conf->mirrors[d].replacement->data_offset;
@@ -4311,6 +4322,7 @@ read_more:
 			       + rdev->data_offset);
 	read_bio->bi_private = r10_bio;
 	read_bio->bi_end_io = end_sync_read;
+	read_bio->bi_op = REQ_OP_READ;
 	read_bio->bi_rw = READ;
 	read_bio->bi_flags &= (~0UL << BIO_RESET_BITS);
 	read_bio->bi_error = 0;
@@ -4345,6 +4357,7 @@ read_more:
 			rdev2->new_data_offset;
 		b->bi_private = r10_bio;
 		b->bi_end_io = end_reshape_write;
+		b->bi_op = REQ_OP_WRITE;
 		b->bi_rw = WRITE;
 		b->bi_next = blist;
 		blist = b;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 49bb8d3..7480155 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -896,29 +896,39 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 	might_sleep();
 
 	for (i = disks; i--; ) {
-		int rw;
+		int op;
+		int op_flags = 0;
 		int replace_only = 0;
 		struct bio *bi, *rbi;
 		struct md_rdev *rdev, *rrdev = NULL;
 
 		sh = head_sh;
 		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags)) {
-			if (test_and_clear_bit(R5_WantFUA, &sh->dev[i].flags))
-				rw = WRITE_FUA;
-			else
-				rw = WRITE;
-			if (test_bit(R5_Discard, &sh->dev[i].flags))
-				rw |= REQ_DISCARD;
+			if (test_and_clear_bit(R5_WantFUA, &sh->dev[i].flags)) {
+				op = REQ_OP_WRITE;
+				op_flags = WRITE_FUA;
+			} else {
+				op = REQ_OP_WRITE;
+			}
+			if (test_bit(R5_Discard, &sh->dev[i].flags)) {
+				op = REQ_OP_DISCARD;
+				/*
+				 * this temporary for compat because drivers
+				 * expected this to be set for discards. It
+				 * will be removed in the next patches.
+				 */
+				op_flags |= REQ_WRITE;
+			}
 		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
-			rw = READ;
+			op = REQ_OP_READ;
 		else if (test_and_clear_bit(R5_WantReplace,
 					    &sh->dev[i].flags)) {
-			rw = WRITE;
+			op = REQ_OP_WRITE;
 			replace_only = 1;
 		} else
 			continue;
 		if (test_and_clear_bit(R5_SyncIO, &sh->dev[i].flags))
-			rw |= REQ_SYNC;
+			op_flags |= REQ_SYNC;
 
 again:
 		bi = &sh->dev[i].req;
@@ -932,7 +942,7 @@ again:
 			rdev = rrdev;
 			rrdev = NULL;
 		}
-		if (rw & WRITE) {
+		if (op_to_data_dir(op) == WRITE) {
 			if (replace_only)
 				rdev = NULL;
 			if (rdev == rrdev)
@@ -958,7 +968,7 @@ again:
 		 * need to check for writes.  We never accept write errors
 		 * on the replacement, so we don't to check rrdev.
 		 */
-		while ((rw & WRITE) && rdev &&
+		while ((op_to_data_dir(op) == WRITE) && rdev &&
 		       test_bit(WriteErrorSeen, &rdev->flags)) {
 			sector_t first_bad;
 			int bad_sectors;
@@ -1000,8 +1010,9 @@ again:
 
 			bio_reset(bi);
 			bi->bi_bdev = rdev->bdev;
-			bi->bi_rw = rw;
-			bi->bi_end_io = (rw & WRITE)
+			bi->bi_op = op;
+			bi->bi_rw = op | op_flags;
+			bi->bi_end_io = (op_to_data_dir(op) == WRITE)
 				? raid5_end_write_request
 				: raid5_end_read_request;
 			bi->bi_private = sh;
@@ -1032,7 +1043,7 @@ again:
 			 * If this is discard request, set bi_vcnt 0. We don't
 			 * want to confuse SCSI because SCSI will replace payload
 			 */
-			if (rw & REQ_DISCARD)
+			if (op == REQ_OP_DISCARD)
 				bi->bi_vcnt = 0;
 			if (rrdev)
 				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
@@ -1052,8 +1063,9 @@ again:
 
 			bio_reset(rbi);
 			rbi->bi_bdev = rrdev->bdev;
-			rbi->bi_rw = rw;
-			BUG_ON(!(rw & WRITE));
+			rbi->bi_op = op;
+			rbi->bi_rw = op | op_flags;
+			BUG_ON(!(op_to_data_dir(op)));
 			rbi->bi_end_io = raid5_end_write_request;
 			rbi->bi_private = sh;
 
@@ -1081,7 +1093,7 @@ again:
 			 * If this is discard request, set bi_vcnt 0. We don't
 			 * want to confuse SCSI because SCSI will replace payload
 			 */
-			if (rw & REQ_DISCARD)
+			if (op == REQ_OP_DISCARD)
 				rbi->bi_vcnt = 0;
 			if (conf->mddev->gendisk)
 				trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
@@ -1090,7 +1102,7 @@ again:
 			generic_make_request(rbi);
 		}
 		if (!rdev && !rrdev) {
-			if (rw & WRITE)
+			if (op_to_data_dir(op) == WRITE)
 				set_bit(STRIPE_DEGRADED, &sh->state);
 			pr_debug("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
-- 
1.8.3.1
