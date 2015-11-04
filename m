From: mchristi@redhat.com
Subject: [PATCH 14/32] block/fs/mm: pass in op and flags to
	submit_bio
Date: Wed,  4 Nov 2015 16:08:11 -0600
Message-ID: <1446674909-5371-15-git-send-email-mchristi@redhat.com>
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

This patch prepares submit_bio callers for the next
patches that split bi_rw into a operation and flags field.
Instead of passing in a bitmap with both the operation and
flags mixed in, the callers now pass them in seperately.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/bio.c                         |  2 +-
 block/blk-core.c                    | 13 +++++++------
 block/blk-lib.c                     | 11 ++++++++---
 drivers/block/drbd/drbd_actlog.c    |  2 +-
 drivers/block/drbd/drbd_bitmap.c    |  2 +-
 drivers/block/floppy.c              |  2 +-
 drivers/block/xen-blkback/blkback.c |  2 +-
 drivers/block/xen-blkfront.c        |  4 ++--
 drivers/md/bcache/journal.c         |  2 +-
 drivers/md/bcache/super.c           |  2 +-
 drivers/md/dm-bufio.c               |  2 +-
 drivers/md/dm-io.c                  |  2 +-
 drivers/md/dm-log-writes.c          |  6 +++---
 drivers/md/dm-thin.c                |  2 +-
 drivers/md/md.c                     |  4 ++--
 drivers/target/target_core_iblock.c |  4 ++--
 fs/btrfs/check-integrity.c          |  2 +-
 fs/btrfs/raid56.c                   | 10 +++++-----
 fs/buffer.c                         |  7 ++++---
 fs/direct-io.c                      |  2 +-
 fs/ext4/page-io.c                   |  6 +++---
 fs/ext4/readpage.c                  |  8 ++++----
 fs/f2fs/data.c                      | 10 +++++-----
 fs/gfs2/lops.c                      |  2 +-
 fs/gfs2/ops_fstype.c                |  2 +-
 fs/jfs/jfs_logmgr.c                 |  4 ++--
 fs/jfs/jfs_metapage.c               |  8 ++++----
 fs/logfs/dev_bdev.c                 |  8 ++++----
 fs/mpage.c                          |  2 +-
 fs/nfs/blocklayout/blocklayout.c    |  2 +-
 fs/nilfs2/segbuf.c                  |  2 +-
 fs/ocfs2/cluster/heartbeat.c        |  4 ++--
 fs/xfs/xfs_aops.c                   |  3 ++-
 fs/xfs/xfs_buf.c                    |  2 +-
 include/linux/fs.h                  |  2 +-
 kernel/power/swap.c                 |  2 +-
 mm/page_io.c                        |  4 ++--
 37 files changed, 81 insertions(+), 73 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 610c704..ae91ccb 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -873,7 +873,7 @@ int submit_bio_wait(int op, int flags, struct bio *bio)
 	init_completion(&ret.event);
 	bio->bi_private = &ret;
 	bio->bi_end_io = submit_bio_wait_endio;
-	submit_bio(op | flags | REQ_SYNC, bio);
+	submit_bio(op, flags | REQ_SYNC, bio);
 	wait_for_completion(&ret.event);
 
 	return ret.error;
diff --git a/block/blk-core.c b/block/blk-core.c
index 18e92a6..d325ece 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1976,7 +1976,8 @@ EXPORT_SYMBOL(generic_make_request);
 
 /**
  * submit_bio - submit a bio to the block device layer for I/O
- * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
+ * @op: REQ_OP_*
+ * @flags: rq_flag_bits
  * @bio: The &struct bio which describes the I/O
  *
  * submit_bio() is very similar in purpose to generic_make_request(), and
@@ -1984,9 +1985,9 @@ EXPORT_SYMBOL(generic_make_request);
  * interfaces; @bio must be presetup and ready for I/O.
  *
  */
-void submit_bio(int rw, struct bio *bio)
+void submit_bio(int op, int flags, struct bio *bio)
 {
-	bio->bi_rw |= rw;
+	bio->bi_rw |= op | flags;
 
 	/*
 	 * If it's a regular read/write or a barrier with data attached,
@@ -1995,12 +1996,12 @@ void submit_bio(int rw, struct bio *bio)
 	if (bio_has_data(bio)) {
 		unsigned int count;
 
-		if (unlikely(rw & REQ_WRITE_SAME))
+		if (unlikely(op == REQ_WRITE_SAME))
 			count = bdev_logical_block_size(bio->bi_bdev) >> 9;
 		else
 			count = bio_sectors(bio);
 
-		if (rw & WRITE) {
+		if (op == REQ_OP_WRITE) {
 			count_vm_events(PGPGOUT, count);
 		} else {
 			task_io_account_read(bio->bi_iter.bi_size);
@@ -2011,7 +2012,7 @@ void submit_bio(int rw, struct bio *bio)
 			char b[BDEVNAME_SIZE];
 			printk(KERN_DEBUG "%s(%d): %s block %Lu on %s (%u sectors)\n",
 			current->comm, task_pid_nr(current),
-				(rw & WRITE) ? "WRITE" : "READ",
+				bio_rw(bio) ? "WRITE" : "READ",
 				(unsigned long long)bio->bi_iter.bi_sector,
 				bdevname(bio->bi_bdev, b),
 				count);
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 0861c7a..49786b0 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -109,7 +109,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector = end_sect;
 
 		atomic_inc(&bb.done);
-		submit_bio(op | op_flags, bio);
+		submit_bio(op, op_flags, bio);
 
 		/*
 		 * We can loop for a long time in here, if someone does
@@ -189,7 +189,12 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		}
 
 		atomic_inc(&bb.done);
-		submit_bio(REQ_WRITE | REQ_WRITE_SAME, bio);
+		/*
+		 * REQ_WRITE being passed as a flag is temp until
+		 * code that assumes REQ_WRITE is set for WRITE_SAME
+		 * is converted.
+		 */
+		submit_bio(REQ_OP_WRITE_SAME, REQ_WRITE, bio);
 	}
 
 	/* Wait for bios in-flight */
@@ -250,7 +255,7 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		}
 		ret = 0;
 		atomic_inc(&bb.done);
-		submit_bio(WRITE, bio);
+		submit_bio(REQ_OP_WRITE, 0, bio);
 	}
 
 	/* Wait for bios in-flight */
diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index c290e8b..5ad6b09 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -177,7 +177,7 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 	if (drbd_insert_fault(device, (op == REQ_OP_WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD))
 		bio_io_error(bio);
 	else
-		submit_bio(op | op_flags, bio);
+		submit_bio(op, op_flags, bio);
 	wait_until_done_or_force_detached(device, bdev, &device->md_io.done);
 	if (!bio->bi_error)
 		err = device->md_io.error;
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 7ea1502..e8c65a4 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1024,7 +1024,7 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 		bio->bi_rw |= rw;
 		bio_io_error(bio);
 	} else {
-		submit_bio(rw, bio);
+		submit_bio(rw, 0, bio);
 		/* this should not count as user activity and cause the
 		 * resync to throttle -- see drbd_rs_should_slow_down(). */
 		atomic_add(len >> 9, &device->rs_sect_ev);
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 331363e..86758fa 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3817,7 +3817,7 @@ static int __floppy_read_block_0(struct block_device *bdev, int drive)
 	bio.bi_private = &cbdata;
 	bio.bi_end_io = floppy_rb0_cb;
 
-	submit_bio(READ, &bio);
+	submit_bio(REQ_OP_READ, 0, &bio);
 	process_fd_request();
 
 	init_completion(&cbdata.complete);
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index bfffab3..0ae456c 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -1368,7 +1368,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	blk_start_plug(&plug);
 
 	for (i = 0; i < nbio; i++)
-		submit_bio(operation | operation_flags, biolist[i]);
+		submit_bio(operation, operation_flags, biolist[i]);
 
 	/* Let the I/Os go.. */
 	blk_finish_plug(&plug);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index a69c02d..ec76178 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1591,7 +1591,7 @@ static int blkif_recover(struct blkfront_info *info)
 				bio_trim(cloned_bio, offset, size);
 				cloned_bio->bi_private = split_bio;
 				cloned_bio->bi_end_io = split_bio_end;
-				submit_bio(cloned_bio->bi_rw, cloned_bio);
+				submit_bio(cloned_bio->bi_rw, 0, cloned_bio);
 			}
 			/*
 			 * Now we have to wait for all those smaller bios to
@@ -1600,7 +1600,7 @@ static int blkif_recover(struct blkfront_info *info)
 			continue;
 		}
 		/* We don't need to split this bio */
-		submit_bio(bio->bi_rw, bio);
+		submit_bio(bio->bi_rw, 0, bio);
 	}
 
 	return 0;
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 29eba72..ba9192b 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -418,7 +418,7 @@ static void journal_discard_work(struct work_struct *work)
 	struct journal_device *ja =
 		container_of(work, struct journal_device, discard_work);
 
-	submit_bio(0, &ja->discard_bio);
+	submit_bio(0, 0, &ja->discard_bio);
 }
 
 static void do_journal_discard(struct cache *ca)
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 679a093..a987c90 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -238,7 +238,7 @@ static void __write_super(struct cache_sb *sb, struct bio *bio)
 	pr_debug("ver %llu, flags %llu, seq %llu",
 		 sb->version, sb->flags, sb->seq);
 
-	submit_bio(REQ_WRITE, bio);
+	submit_bio(REQ_OP_WRITE, 0, bio);
 }
 
 static void bch_write_bdev_super_unlock(struct closure *cl)
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 9d5ef0c..689e908 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -641,7 +641,7 @@ static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
 		ptr += PAGE_SIZE;
 	} while (len > 0);
 
-	submit_bio(rw, &b->bio);
+	submit_bio(rw, 0, &b->bio);
 }
 
 static void submit_io(struct dm_buffer *b, int rw, sector_t block,
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 6479096..f389380 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -358,7 +358,7 @@ static void do_region(int op, int op_flags, unsigned region,
 		}
 
 		atomic_inc(&io->count);
-		submit_bio(op | op_flags, bio);
+		submit_bio(op, op_flags, bio);
 	} while (remaining);
 }
 
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index b2912db..7bfaa91 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -226,7 +226,7 @@ static int write_metadata(struct log_writes_c *lc, void *entry,
 		DMERR("Couldn't add page to the log block");
 		goto error_bio;
 	}
-	submit_bio(WRITE, bio);
+	submit_bio(REQ_OP_WRITE, 0, bio);
 	return 0;
 error_bio:
 	bio_put(bio);
@@ -279,7 +279,7 @@ static int log_one_block(struct log_writes_c *lc,
 				   block->vecs[i].bv_len, 0);
 		if (ret != block->vecs[i].bv_len) {
 			atomic_inc(&lc->io_blocks);
-			submit_bio(WRITE, bio);
+			submit_bio(REQ_OP_WRITE, 0, bio);
 			bio = bio_alloc(GFP_KERNEL, block->vec_cnt - i);
 			if (!bio) {
 				DMERR("Couldn't alloc log bio");
@@ -301,7 +301,7 @@ static int log_one_block(struct log_writes_c *lc,
 		}
 		sector += block->vecs[i].bv_len >> SECTOR_SHIFT;
 	}
-	submit_bio(WRITE, bio);
+	submit_bio(REQ_OP_WRITE, 0, bio);
 out:
 	kfree(block->data);
 	kfree(block);
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 1500582..63a713d 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -366,7 +366,7 @@ static int __blkdev_issue_discard_async(struct block_device *bdev, sector_t sect
 	bio->bi_bdev = bdev;
 	bio->bi_iter.bi_size = nr_sects << 9;
 
-	submit_bio(REQ_OP_DISCARD | op_flags, bio);
+	submit_bio(REQ_OP_DISCARD, op_flags, bio);
 
 	return 0;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1ca5959..650d668 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -398,7 +398,7 @@ static void submit_flushes(struct work_struct *ws)
 			bi->bi_private = rdev;
 			bi->bi_bdev = rdev->bdev;
 			atomic_inc(&mddev->flush_pending);
-			submit_bio(WRITE_FLUSH, bi);
+			submit_bio(REQ_OP_WRITE, WRITE_FLUSH, bi);
 			rcu_read_lock();
 			rdev_dec_pending(rdev, mddev);
 		}
@@ -745,7 +745,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 	bio->bi_end_io = super_written;
 
 	atomic_inc(&mddev->pending_writes);
-	submit_bio(WRITE_FLUSH_FUA, bio);
+	submit_bio(REQ_OP_WRITE, WRITE_FLUSH_FUA, bio);
 }
 
 void md_super_wait(struct mddev *mddev)
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 25f75ab..3df7921 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -361,7 +361,7 @@ static void iblock_submit_bios(struct bio_list *list, int op, int op_flags)
 
 	blk_start_plug(&plug);
 	while ((bio = bio_list_pop(list)))
-		submit_bio(op | op_flags, bio);
+		submit_bio(op, op_flags, bio);
 	blk_finish_plug(&plug);
 }
 
@@ -405,7 +405,7 @@ iblock_execute_sync_cache(struct se_cmd *cmd)
 	bio->bi_bdev = ib_dev->ibd_bd;
 	if (!immed)
 		bio->bi_private = cmd;
-	submit_bio(WRITE_FLUSH, bio);
+	submit_bio(REQ_OP_WRITE, WRITE_FLUSH, bio);
 	return 0;
 }
 
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 515a92e..a5ff6e4 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -3061,7 +3061,7 @@ leave:
 void btrfsic_submit_bio(int op, int op_flags, struct bio *bio)
 {
 	__btrfsic_submit_bio(op | op_flags, bio);
-	submit_bio(op | op_flags, bio);
+	submit_bio(op, op_flags, bio);
 }
 
 int btrfsic_submit_bio_wait(int op, int op_flags, struct bio *bio)
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index fcf7265..dd1c7b0 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1319,7 +1319,7 @@ write_data:
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_write_end_io;
-		submit_bio(WRITE, bio);
+		submit_bio(REQ_OP_WRITE, 0, bio);
 	}
 	return;
 
@@ -1577,7 +1577,7 @@ static int raid56_rmw_stripe(struct btrfs_raid_bio *rbio)
 		btrfs_bio_wq_end_io(rbio->fs_info, bio,
 				    BTRFS_WQ_ENDIO_RAID56);
 
-		submit_bio(READ, bio);
+		submit_bio(REQ_OP_READ, 0, bio);
 	}
 	/* the actual write will happen once the reads are done */
 	return 0;
@@ -2103,7 +2103,7 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 		btrfs_bio_wq_end_io(rbio->fs_info, bio,
 				    BTRFS_WQ_ENDIO_RAID56);
 
-		submit_bio(READ, bio);
+		submit_bio(REQ_OP_READ, 0, bio);
 	}
 out:
 	return 0;
@@ -2461,7 +2461,7 @@ submit_write:
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_write_parity_end_io;
-		submit_bio(WRITE, bio);
+		submit_bio(REQ_OP_WRITE, 0, bio);
 	}
 	return;
 
@@ -2642,7 +2642,7 @@ static void raid56_parity_scrub_stripe(struct btrfs_raid_bio *rbio)
 		btrfs_bio_wq_end_io(rbio->fs_info, bio,
 				    BTRFS_WQ_ENDIO_RAID56);
 
-		submit_bio(READ, bio);
+		submit_bio(REQ_OP_READ, 0, bio);
 	}
 	/* the actual write will happen once the reads are done */
 	return;
diff --git a/fs/buffer.c b/fs/buffer.c
index 82283ab..a190c25 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3020,6 +3020,7 @@ static int submit_bh_wbc(int rw, struct buffer_head *bh,
 			 unsigned long bio_flags, struct writeback_control *wbc)
 {
 	struct bio *bio;
+	int op_flags = 0;
 
 	BUG_ON(!buffer_locked(bh));
 	BUG_ON(!buffer_mapped(bh));
@@ -3058,11 +3059,11 @@ static int submit_bh_wbc(int rw, struct buffer_head *bh,
 	guard_bio_eod(rw, bio);
 
 	if (buffer_meta(bh))
-		rw |= REQ_META;
+		op_flags |= REQ_META;
 	if (buffer_prio(bh))
-		rw |= REQ_PRIO;
+		op_flags |= REQ_PRIO;
 
-	submit_bio(rw, bio);
+	submit_bio(rw, op_flags, bio);
 	return 0;
 }
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 5e1b1a0..c72e9f4 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -402,7 +402,7 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 		sdio->submit_io(dio->op, dio->op_flags, bio, dio->inode,
 			       sdio->logical_offset_in_bio);
 	else
-		submit_bio(dio->op | dio->op_flags, bio);
+		submit_bio(dio->op, dio->op_flags, bio);
 
 	sdio->bio = NULL;
 	sdio->boundary = 0;
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 84ba4d2..4eb8fd9 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -354,10 +354,10 @@ void ext4_io_submit(struct ext4_io_submit *io)
 	struct bio *bio = io->io_bio;
 
 	if (bio) {
-		int io_op = io->io_wbc->sync_mode == WB_SYNC_ALL ?
-			    WRITE_SYNC : WRITE;
+		int io_op_flags = io->io_wbc->sync_mode == WB_SYNC_ALL ?
+			    WRITE_SYNC : 0;
 		bio_get(io->io_bio);
-		submit_bio(io_op, io->io_bio);
+		submit_bio(REQ_OP_WRITE, io_op_flags, io->io_bio);
 		bio_put(io->io_bio);
 	}
 	io->io_bio = NULL;
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 560af04..ac67d0f 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -271,7 +271,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
 		 */
 		if (bio && (last_block_in_bio != blocks[0] - 1)) {
 		submit_and_realloc:
-			submit_bio(READ, bio);
+			submit_bio(REQ_OP_READ, 0, bio);
 			bio = NULL;
 		}
 		if (bio == NULL) {
@@ -303,14 +303,14 @@ int ext4_mpage_readpages(struct address_space *mapping,
 		if (((map.m_flags & EXT4_MAP_BOUNDARY) &&
 		     (relative_block == map.m_len)) ||
 		    (first_hole != blocks_per_page)) {
-			submit_bio(READ, bio);
+			submit_bio(REQ_OP_READ, 0, bio);
 			bio = NULL;
 		} else
 			last_block_in_bio = blocks[blocks_per_page - 1];
 		goto next_page;
 	confused:
 		if (bio) {
-			submit_bio(READ, bio);
+			submit_bio(REQ_OP_READ, 0, bio);
 			bio = NULL;
 		}
 		if (!PageUptodate(page))
@@ -323,6 +323,6 @@ int ext4_mpage_readpages(struct address_space *mapping,
 	}
 	BUG_ON(pages && !list_empty(pages));
 	if (bio)
-		submit_bio(READ, bio);
+		submit_bio(REQ_OP_READ, 0, bio);
 	return 0;
 }
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index fb767e4f..94b090d 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -112,7 +112,7 @@ static void __submit_merged_bio(struct f2fs_bio_info *io)
 	else
 		trace_f2fs_submit_write_bio(io->sbi->sb, fio, io->bio);
 
-	submit_bio(fio->op | fio->op_flags, io->bio);
+	submit_bio(fio->op, fio->op_flags, io->bio);
 	io->bio = NULL;
 }
 
@@ -160,7 +160,7 @@ int f2fs_submit_page_bio(struct f2fs_io_info *fio)
 		return -EFAULT;
 	}
 
-	submit_bio(fio->op | fio->op_flags, bio);
+	submit_bio(fio->op, fio->op_flags, bio);
 	return 0;
 }
 
@@ -932,7 +932,7 @@ got_it:
 		 */
 		if (bio && (last_block_in_bio != block_nr - 1)) {
 submit_and_realloc:
-			submit_bio(READ, bio);
+			submit_bio(REQ_OP_READ, 0, bio);
 			bio = NULL;
 		}
 		if (bio == NULL) {
@@ -982,7 +982,7 @@ set_error_page:
 		goto next_page;
 confused:
 		if (bio) {
-			submit_bio(READ, bio);
+			submit_bio(REQ_OP_READ, 0, bio);
 			bio = NULL;
 		}
 		unlock_page(page);
@@ -992,7 +992,7 @@ next_page:
 	}
 	BUG_ON(pages && !list_empty(pages));
 	if (bio)
-		submit_bio(READ, bio);
+		submit_bio(REQ_OP_READ, 0, bio);
 	return 0;
 }
 
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 36b047a..8a230d1 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -241,7 +241,7 @@ void gfs2_log_flush_bio(struct gfs2_sbd *sdp, int op, int op_flags)
 {
 	if (sdp->sd_log_bio) {
 		atomic_inc(&sdp->sd_log_in_flight);
-		submit_bio(op | op_flags, sdp->sd_log_bio);
+		submit_bio(op, op_flags, sdp->sd_log_bio);
 		sdp->sd_log_bio = NULL;
 	}
 }
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 02586e7..72c48e2 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -246,7 +246,7 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector, int silent)
 
 	bio->bi_end_io = end_bio_io_page;
 	bio->bi_private = page;
-	submit_bio(READ_SYNC | REQ_META, bio);
+	submit_bio(REQ_OP_READ, READ_SYNC | REQ_META, bio);
 	wait_on_page_locked(page);
 	bio_put(bio);
 	if (!PageUptodate(page)) {
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index a69bdf2..c8e8176 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2010,7 +2010,7 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 		bio->bi_iter.bi_size = 0;
 		lbmIODone(bio);
 	} else {
-		submit_bio(READ_SYNC, bio);
+		submit_bio(REQ_OP_READ, READ_SYNC, bio);
 	}
 
 	wait_event(bp->l_ioevent, (bp->l_flag != lbmREAD));
@@ -2154,7 +2154,7 @@ static void lbmStartIO(struct lbuf * bp)
 		bio->bi_iter.bi_size = 0;
 		lbmIODone(bio);
 	} else {
-		submit_bio(WRITE_SYNC, bio);
+		submit_bio(REQ_OP_WRITE, WRITE_SYNC, bio);
 		INCREMENT(lmStat.submitted);
 	}
 }
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index a3eb316..fb64488 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -411,7 +411,7 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 			inc_io(page);
 			if (!bio->bi_iter.bi_size)
 				goto dump_bio;
-			submit_bio(WRITE, bio);
+			submit_bio(REQ_OP_WRITE, 0, bio);
 			nr_underway++;
 			bio = NULL;
 		} else
@@ -448,7 +448,7 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 		if (!bio->bi_iter.bi_size)
 			goto dump_bio;
 
-		submit_bio(WRITE, bio);
+		submit_bio(REQ_OP_WRITE, 0, bio);
 		nr_underway++;
 	}
 	if (redirty)
@@ -506,7 +506,7 @@ static int metapage_readpage(struct file *fp, struct page *page)
 				insert_metapage(page, NULL);
 			inc_io(page);
 			if (bio)
-				submit_bio(READ, bio);
+				submit_bio(REQ_OP_READ, 0, bio);
 
 			bio = bio_alloc(GFP_NOFS, 1);
 			bio->bi_bdev = inode->i_sb->s_bdev;
@@ -523,7 +523,7 @@ static int metapage_readpage(struct file *fp, struct page *page)
 			block_offset++;
 	}
 	if (bio)
-		submit_bio(READ, bio);
+		submit_bio(REQ_OP_READ, 0, bio);
 	else
 		unlock_page(page);
 
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index 149c480..6b1cab9 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -96,7 +96,7 @@ static int __bdev_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
 			bio->bi_private = sb;
 			bio->bi_end_io = writeseg_end_io;
 			atomic_inc(&super->s_pending_writes);
-			submit_bio(WRITE, bio);
+			submit_bio(REQ_OP_WRITE, 0, bio);
 
 			ofs += i * PAGE_SIZE;
 			index += i;
@@ -123,7 +123,7 @@ static int __bdev_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
 	bio->bi_private = sb;
 	bio->bi_end_io = writeseg_end_io;
 	atomic_inc(&super->s_pending_writes);
-	submit_bio(WRITE, bio);
+	submit_bio(REQ_OP_WRITE, 0, bio);
 	return 0;
 }
 
@@ -186,7 +186,7 @@ static int do_erase(struct super_block *sb, u64 ofs, pgoff_t index,
 			bio->bi_private = sb;
 			bio->bi_end_io = erase_end_io;
 			atomic_inc(&super->s_pending_writes);
-			submit_bio(WRITE, bio);
+			submit_bio(REQ_OP_WRITE, 0, bio);
 
 			ofs += i * PAGE_SIZE;
 			index += i;
@@ -207,7 +207,7 @@ static int do_erase(struct super_block *sb, u64 ofs, pgoff_t index,
 	bio->bi_private = sb;
 	bio->bi_end_io = erase_end_io;
 	atomic_inc(&super->s_pending_writes);
-	submit_bio(WRITE, bio);
+	submit_bio(REQ_OP_WRITE, 0, bio);
 	return 0;
 }
 
diff --git a/fs/mpage.c b/fs/mpage.c
index a7c3427..5580c95 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -59,7 +59,7 @@ static struct bio *mpage_bio_submit(int rw, struct bio *bio)
 {
 	bio->bi_end_io = mpage_end_io;
 	guard_bio_eod(rw, bio);
-	submit_bio(rw, bio);
+	submit_bio(rw, 0, bio);
 	return NULL;
 }
 
diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 9cd4eb3..6f0a19c 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -109,7 +109,7 @@ bl_submit_bio(int rw, struct bio *bio)
 		dprintk("%s submitting %s bio %u@%llu\n", __func__,
 			rw == READ ? "read" : "write", bio->bi_iter.bi_size,
 			(unsigned long long)bio->bi_iter.bi_sector);
-		submit_bio(rw, bio);
+		submit_bio(rw, 0, bio);
 	}
 	return NULL;
 }
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index f63620c..ed7b18f 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -368,7 +368,7 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
 
 	bio->bi_end_io = nilfs_end_bio_write;
 	bio->bi_private = segbuf;
-	submit_bio(mode, bio);
+	submit_bio(mode, 0, bio);
 	segbuf->sb_nbio++;
 
 	wi->bio = NULL;
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index fa15deb..2d0766c 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -459,7 +459,7 @@ static int o2hb_read_slots(struct o2hb_region *reg,
 		}
 
 		atomic_inc(&wc.wc_num_reqs);
-		submit_bio(READ, bio);
+		submit_bio(REQ_OP_READ, 0, bio);
 	}
 
 	status = 0;
@@ -491,7 +491,7 @@ static int o2hb_issue_node_write(struct o2hb_region *reg,
 	}
 
 	atomic_inc(&write_wc->wc_num_reqs);
-	submit_bio(WRITE_SYNC, bio);
+	submit_bio(REQ_OP_WRITE, WRITE_SYNC, bio);
 
 	status = 0;
 bail:
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 50ab287..4cdd020 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -373,7 +373,8 @@ xfs_submit_ioend_bio(
 	atomic_inc(&ioend->io_remaining);
 	bio->bi_private = ioend;
 	bio->bi_end_io = xfs_end_bio;
-	submit_bio(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE, bio);
+	submit_bio(REQ_OP_WRITE,
+		   wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : 0, bio);
 }
 
 STATIC struct bio *
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 0621d70..a39a397 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1187,7 +1187,7 @@ next_chunk:
 			flush_kernel_vmap_range(bp->b_addr,
 						xfs_buf_vmap_len(bp));
 		}
-		submit_bio(op | op_flags, bio);
+		submit_bio(op, op_flags, bio);
 		if (size)
 			goto next_chunk;
 	} else {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 601b842..ac1fd9b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2625,7 +2625,7 @@ static inline void remove_inode_hash(struct inode *inode)
 extern void inode_sb_list_add(struct inode *inode);
 
 #ifdef CONFIG_BLOCK
-extern void submit_bio(int, struct bio *);
+extern void submit_bio(int, int, struct bio *);
 extern int bdev_read_only(struct block_device *);
 #endif
 extern int set_blocksize(struct block_device *, int);
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index aa4ca997..0fea79b 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -272,7 +272,7 @@ static int hib_submit_io(int rw, int flags, pgoff_t page_off, void *addr,
 		bio->bi_end_io = hib_end_io;
 		bio->bi_private = hb;
 		atomic_inc(&hb->count);
-		submit_bio(rw, bio);
+		submit_bio(rw, flags, bio);
 	} else {
 		error = submit_bio_wait(rw, flags, bio);
 		bio_put(bio);
diff --git a/mm/page_io.c b/mm/page_io.c
index ec7ad22..bde21e3 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -317,7 +317,7 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 	count_vm_event(PSWPOUT);
 	set_page_writeback(page);
 	unlock_page(page);
-	submit_bio(REQ_OP_WRITE | op_flags, bio);
+	submit_bio(REQ_OP_WRITE, op_flags, bio);
 out:
 	return ret;
 }
@@ -360,7 +360,7 @@ int swap_readpage(struct page *page)
 		goto out;
 	}
 	count_vm_event(PSWPIN);
-	submit_bio(READ, bio);
+	submit_bio(REQ_OP_READ, 0, bio);
 out:
 	return ret;
 }
-- 
1.8.3.1
