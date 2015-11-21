From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 3/3] md: convert to use the generic badblocks code
Date: Fri, 20 Nov 2015 17:49:20 -0700
Message-ID: <1448066960-20119-4-git-send-email-vishal.l.verma@intel.com>
References: <1448066960-20119-1-git-send-email-vishal.l.verma@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63599 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163001AbbKUAtt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2015 19:49:49 -0500
In-Reply-To: <1448066960-20119-1-git-send-email-vishal.l.verma@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, NeilBrown <neilb@suse.com>, Jeff Moyer <jmoyer@redhat.com>

Retain badblocks as part of rdev, but use the accessor functions from
include/linux/badblocks for all manipulation.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/md/md.c | 495 +++-----------------------------------------------------
 drivers/md/md.h |  31 +---
 2 files changed, 21 insertions(+), 505 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c702de1..82994d7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -34,6 +34,7 @@
 
 #include <linux/kthread.h>
 #include <linux/blkdev.h>
+#include <linux/badblocks.h>
 #include <linux/sysctl.h>
 #include <linux/seq_file.h>
 #include <linux/fs.h>
@@ -1358,8 +1359,6 @@ static __le32 calc_sb_1_csum(struct mdp_superblock_1 *sb)
 	return cpu_to_le32(csum);
 }
 
-static int md_set_badblocks(struct badblocks *bb, sector_t s, int sectors,
-			    int acknowledged);
 static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_version)
 {
 	struct mdp_superblock_1 *sb;
@@ -1484,7 +1483,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 			count <<= sb->bblog_shift;
 			if (bb + 1 == 0)
 				break;
-			if (md_set_badblocks(&rdev->badblocks,
+			if (badblocks_set(&rdev->badblocks,
 					     sector, count, 1) == 0)
 				return -EINVAL;
 		}
@@ -2226,7 +2225,7 @@ repeat:
 			rdev_for_each(rdev, mddev) {
 				if (rdev->badblocks.changed) {
 					rdev->badblocks.changed = 0;
-					md_ack_all_badblocks(&rdev->badblocks);
+					ack_all_badblocks(&rdev->badblocks);
 					md_error(mddev, rdev);
 				}
 				clear_bit(Blocked, &rdev->flags);
@@ -2352,7 +2351,7 @@ repeat:
 			clear_bit(Blocked, &rdev->flags);
 
 		if (any_badblocks_changed)
-			md_ack_all_badblocks(&rdev->badblocks);
+			ack_all_badblocks(&rdev->badblocks);
 		clear_bit(BlockedBadBlocks, &rdev->flags);
 		wake_up(&rdev->blocked_wait);
 	}
@@ -2944,11 +2943,17 @@ static ssize_t recovery_start_store(struct md_rdev *rdev, const char *buf, size_
 static struct rdev_sysfs_entry rdev_recovery_start =
 __ATTR(recovery_start, S_IRUGO|S_IWUSR, recovery_start_show, recovery_start_store);
 
-static ssize_t
-badblocks_show(struct badblocks *bb, char *page, int unack);
-static ssize_t
-badblocks_store(struct badblocks *bb, const char *page, size_t len, int unack);
-
+/* sysfs access to bad-blocks list.
+ * We present two files.
+ * 'bad-blocks' lists sector numbers and lengths of ranges that
+ *    are recorded as bad.  The list is truncated to fit within
+ *    the one-page limit of sysfs.
+ *    Writing "sector length" to this file adds an acknowledged
+ *    bad block list.
+ * 'unacknowledged-bad-blocks' lists bad blocks that have not yet
+ *    been acknowledged.  Writing to this file adds bad blocks
+ *    without acknowledging them.  This is largely for testing.
+ */
 static ssize_t bb_show(struct md_rdev *rdev, char *page)
 {
 	return badblocks_show(&rdev->badblocks, page, 0);
@@ -8348,253 +8353,7 @@ void md_finish_reshape(struct mddev *mddev)
 }
 EXPORT_SYMBOL(md_finish_reshape);
 
-/* Bad block management.
- * We can record which blocks on each device are 'bad' and so just
- * fail those blocks, or that stripe, rather than the whole device.
- * Entries in the bad-block table are 64bits wide.  This comprises:
- * Length of bad-range, in sectors: 0-511 for lengths 1-512
- * Start of bad-range, sector offset, 54 bits (allows 8 exbibytes)
- *  A 'shift' can be set so that larger blocks are tracked and
- *  consequently larger devices can be covered.
- * 'Acknowledged' flag - 1 bit. - the most significant bit.
- *
- * Locking of the bad-block table uses a seqlock so md_is_badblock
- * might need to retry if it is very unlucky.
- * We will sometimes want to check for bad blocks in a bi_end_io function,
- * so we use the write_seqlock_irq variant.
- *
- * When looking for a bad block we specify a range and want to
- * know if any block in the range is bad.  So we binary-search
- * to the last range that starts at-or-before the given endpoint,
- * (or "before the sector after the target range")
- * then see if it ends after the given start.
- * We return
- *  0 if there are no known bad blocks in the range
- *  1 if there are known bad block which are all acknowledged
- * -1 if there are bad blocks which have not yet been acknowledged in metadata.
- * plus the start/length of the first bad section we overlap.
- */
-int md_is_badblock(struct badblocks *bb, sector_t s, int sectors,
-		   sector_t *first_bad, int *bad_sectors)
-{
-	int hi;
-	int lo;
-	u64 *p = bb->page;
-	int rv;
-	sector_t target = s + sectors;
-	unsigned seq;
-
-	if (bb->shift > 0) {
-		/* round the start down, and the end up */
-		s >>= bb->shift;
-		target += (1<<bb->shift) - 1;
-		target >>= bb->shift;
-		sectors = target - s;
-	}
-	/* 'target' is now the first block after the bad range */
-
-retry:
-	seq = read_seqbegin(&bb->lock);
-	lo = 0;
-	rv = 0;
-	hi = bb->count;
-
-	/* Binary search between lo and hi for 'target'
-	 * i.e. for the last range that starts before 'target'
-	 */
-	/* INVARIANT: ranges before 'lo' and at-or-after 'hi'
-	 * are known not to be the last range before target.
-	 * VARIANT: hi-lo is the number of possible
-	 * ranges, and decreases until it reaches 1
-	 */
-	while (hi - lo > 1) {
-		int mid = (lo + hi) / 2;
-		sector_t a = BB_OFFSET(p[mid]);
-		if (a < target)
-			/* This could still be the one, earlier ranges
-			 * could not. */
-			lo = mid;
-		else
-			/* This and later ranges are definitely out. */
-			hi = mid;
-	}
-	/* 'lo' might be the last that started before target, but 'hi' isn't */
-	if (hi > lo) {
-		/* need to check all range that end after 's' to see if
-		 * any are unacknowledged.
-		 */
-		while (lo >= 0 &&
-		       BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > s) {
-			if (BB_OFFSET(p[lo]) < target) {
-				/* starts before the end, and finishes after
-				 * the start, so they must overlap
-				 */
-				if (rv != -1 && BB_ACK(p[lo]))
-					rv = 1;
-				else
-					rv = -1;
-				*first_bad = BB_OFFSET(p[lo]);
-				*bad_sectors = BB_LEN(p[lo]);
-			}
-			lo--;
-		}
-	}
-
-	if (read_seqretry(&bb->lock, seq))
-		goto retry;
-
-	return rv;
-}
-EXPORT_SYMBOL_GPL(md_is_badblock);
-
-/*
- * Add a range of bad blocks to the table.
- * This might extend the table, or might contract it
- * if two adjacent ranges can be merged.
- * We binary-search to find the 'insertion' point, then
- * decide how best to handle it.
- */
-static int md_set_badblocks(struct badblocks *bb, sector_t s, int sectors,
-			    int acknowledged)
-{
-	u64 *p;
-	int lo, hi;
-	int rv = 1;
-	unsigned long flags;
-
-	if (bb->shift < 0)
-		/* badblocks are disabled */
-		return 0;
-
-	if (bb->shift) {
-		/* round the start down, and the end up */
-		sector_t next = s + sectors;
-		s >>= bb->shift;
-		next += (1<<bb->shift) - 1;
-		next >>= bb->shift;
-		sectors = next - s;
-	}
-
-	write_seqlock_irqsave(&bb->lock, flags);
-
-	p = bb->page;
-	lo = 0;
-	hi = bb->count;
-	/* Find the last range that starts at-or-before 's' */
-	while (hi - lo > 1) {
-		int mid = (lo + hi) / 2;
-		sector_t a = BB_OFFSET(p[mid]);
-		if (a <= s)
-			lo = mid;
-		else
-			hi = mid;
-	}
-	if (hi > lo && BB_OFFSET(p[lo]) > s)
-		hi = lo;
-
-	if (hi > lo) {
-		/* we found a range that might merge with the start
-		 * of our new range
-		 */
-		sector_t a = BB_OFFSET(p[lo]);
-		sector_t e = a + BB_LEN(p[lo]);
-		int ack = BB_ACK(p[lo]);
-		if (e >= s) {
-			/* Yes, we can merge with a previous range */
-			if (s == a && s + sectors >= e)
-				/* new range covers old */
-				ack = acknowledged;
-			else
-				ack = ack && acknowledged;
-
-			if (e < s + sectors)
-				e = s + sectors;
-			if (e - a <= BB_MAX_LEN) {
-				p[lo] = BB_MAKE(a, e-a, ack);
-				s = e;
-			} else {
-				/* does not all fit in one range,
-				 * make p[lo] maximal
-				 */
-				if (BB_LEN(p[lo]) != BB_MAX_LEN)
-					p[lo] = BB_MAKE(a, BB_MAX_LEN, ack);
-				s = a + BB_MAX_LEN;
-			}
-			sectors = e - s;
-		}
-	}
-	if (sectors && hi < bb->count) {
-		/* 'hi' points to the first range that starts after 's'.
-		 * Maybe we can merge with the start of that range */
-		sector_t a = BB_OFFSET(p[hi]);
-		sector_t e = a + BB_LEN(p[hi]);
-		int ack = BB_ACK(p[hi]);
-		if (a <= s + sectors) {
-			/* merging is possible */
-			if (e <= s + sectors) {
-				/* full overlap */
-				e = s + sectors;
-				ack = acknowledged;
-			} else
-				ack = ack && acknowledged;
-
-			a = s;
-			if (e - a <= BB_MAX_LEN) {
-				p[hi] = BB_MAKE(a, e-a, ack);
-				s = e;
-			} else {
-				p[hi] = BB_MAKE(a, BB_MAX_LEN, ack);
-				s = a + BB_MAX_LEN;
-			}
-			sectors = e - s;
-			lo = hi;
-			hi++;
-		}
-	}
-	if (sectors == 0 && hi < bb->count) {
-		/* we might be able to combine lo and hi */
-		/* Note: 's' is at the end of 'lo' */
-		sector_t a = BB_OFFSET(p[hi]);
-		int lolen = BB_LEN(p[lo]);
-		int hilen = BB_LEN(p[hi]);
-		int newlen = lolen + hilen - (s - a);
-		if (s >= a && newlen < BB_MAX_LEN) {
-			/* yes, we can combine them */
-			int ack = BB_ACK(p[lo]) && BB_ACK(p[hi]);
-			p[lo] = BB_MAKE(BB_OFFSET(p[lo]), newlen, ack);
-			memmove(p + hi, p + hi + 1,
-				(bb->count - hi - 1) * 8);
-			bb->count--;
-		}
-	}
-	while (sectors) {
-		/* didn't merge (it all).
-		 * Need to add a range just before 'hi' */
-		if (bb->count >= MD_MAX_BADBLOCKS) {
-			/* No room for more */
-			rv = 0;
-			break;
-		} else {
-			int this_sectors = sectors;
-			memmove(p + hi + 1, p + hi,
-				(bb->count - hi) * 8);
-			bb->count++;
-
-			if (this_sectors > BB_MAX_LEN)
-				this_sectors = BB_MAX_LEN;
-			p[hi] = BB_MAKE(s, this_sectors, acknowledged);
-			sectors -= this_sectors;
-			s += this_sectors;
-		}
-	}
-
-	bb->changed = 1;
-	if (!acknowledged)
-		bb->unacked_exist = 1;
-	write_sequnlock_irqrestore(&bb->lock, flags);
-
-	return rv;
-}
+/* Bad block management */
 
 int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 		       int is_new)
@@ -8604,8 +8363,7 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 		s += rdev->new_data_offset;
 	else
 		s += rdev->data_offset;
-	rv = md_set_badblocks(&rdev->badblocks,
-			      s, sectors, 0);
+	rv = badblocks_set(&rdev->badblocks, s, sectors, 0);
 	if (rv) {
 		/* Make sure they get written out promptly */
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
@@ -8617,101 +8375,6 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 }
 EXPORT_SYMBOL_GPL(rdev_set_badblocks);
 
-/*
- * Remove a range of bad blocks from the table.
- * This may involve extending the table if we spilt a region,
- * but it must not fail.  So if the table becomes full, we just
- * drop the remove request.
- */
-static int md_clear_badblocks(struct badblocks *bb, sector_t s, int sectors)
-{
-	u64 *p;
-	int lo, hi;
-	sector_t target = s + sectors;
-	int rv = 0;
-
-	if (bb->shift > 0) {
-		/* When clearing we round the start up and the end down.
-		 * This should not matter as the shift should align with
-		 * the block size and no rounding should ever be needed.
-		 * However it is better the think a block is bad when it
-		 * isn't than to think a block is not bad when it is.
-		 */
-		s += (1<<bb->shift) - 1;
-		s >>= bb->shift;
-		target >>= bb->shift;
-		sectors = target - s;
-	}
-
-	write_seqlock_irq(&bb->lock);
-
-	p = bb->page;
-	lo = 0;
-	hi = bb->count;
-	/* Find the last range that starts before 'target' */
-	while (hi - lo > 1) {
-		int mid = (lo + hi) / 2;
-		sector_t a = BB_OFFSET(p[mid]);
-		if (a < target)
-			lo = mid;
-		else
-			hi = mid;
-	}
-	if (hi > lo) {
-		/* p[lo] is the last range that could overlap the
-		 * current range.  Earlier ranges could also overlap,
-		 * but only this one can overlap the end of the range.
-		 */
-		if (BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > target) {
-			/* Partial overlap, leave the tail of this range */
-			int ack = BB_ACK(p[lo]);
-			sector_t a = BB_OFFSET(p[lo]);
-			sector_t end = a + BB_LEN(p[lo]);
-
-			if (a < s) {
-				/* we need to split this range */
-				if (bb->count >= MD_MAX_BADBLOCKS) {
-					rv = -ENOSPC;
-					goto out;
-				}
-				memmove(p+lo+1, p+lo, (bb->count - lo) * 8);
-				bb->count++;
-				p[lo] = BB_MAKE(a, s-a, ack);
-				lo++;
-			}
-			p[lo] = BB_MAKE(target, end - target, ack);
-			/* there is no longer an overlap */
-			hi = lo;
-			lo--;
-		}
-		while (lo >= 0 &&
-		       BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > s) {
-			/* This range does overlap */
-			if (BB_OFFSET(p[lo]) < s) {
-				/* Keep the early parts of this range. */
-				int ack = BB_ACK(p[lo]);
-				sector_t start = BB_OFFSET(p[lo]);
-				p[lo] = BB_MAKE(start, s - start, ack);
-				/* now low doesn't overlap, so.. */
-				break;
-			}
-			lo--;
-		}
-		/* 'lo' is strictly before, 'hi' is strictly after,
-		 * anything between needs to be discarded
-		 */
-		if (hi - lo > 1) {
-			memmove(p+lo+1, p+hi, (bb->count - hi) * 8);
-			bb->count -= (hi - lo - 1);
-		}
-	}
-
-	bb->changed = 1;
-out:
-	write_sequnlock_irq(&bb->lock);
-	return rv;
-}
-
 int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 			 int is_new)
 {
@@ -8719,133 +8382,11 @@ int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 		s += rdev->new_data_offset;
 	else
 		s += rdev->data_offset;
-	return md_clear_badblocks(&rdev->badblocks,
+	return badblocks_clear(&rdev->badblocks,
 				  s, sectors);
 }
 EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
 
-/*
- * Acknowledge all bad blocks in a list.
- * This only succeeds if ->changed is clear.  It is used by
- * in-kernel metadata updates
- */
-void md_ack_all_badblocks(struct badblocks *bb)
-{
-	if (bb->page == NULL || bb->changed)
-		/* no point even trying */
-		return;
-	write_seqlock_irq(&bb->lock);
-
-	if (bb->changed == 0 && bb->unacked_exist) {
-		u64 *p = bb->page;
-		int i;
-		for (i = 0; i < bb->count ; i++) {
-			if (!BB_ACK(p[i])) {
-				sector_t start = BB_OFFSET(p[i]);
-				int len = BB_LEN(p[i]);
-				p[i] = BB_MAKE(start, len, 1);
-			}
-		}
-		bb->unacked_exist = 0;
-	}
-	write_sequnlock_irq(&bb->lock);
-}
-EXPORT_SYMBOL_GPL(md_ack_all_badblocks);
-
-/* sysfs access to bad-blocks list.
- * We present two files.
- * 'bad-blocks' lists sector numbers and lengths of ranges that
- *    are recorded as bad.  The list is truncated to fit within
- *    the one-page limit of sysfs.
- *    Writing "sector length" to this file adds an acknowledged
- *    bad block list.
- * 'unacknowledged-bad-blocks' lists bad blocks that have not yet
- *    been acknowledged.  Writing to this file adds bad blocks
- *    without acknowledging them.  This is largely for testing.
- */
-
-static ssize_t
-badblocks_show(struct badblocks *bb, char *page, int unack)
-{
-	size_t len;
-	int i;
-	u64 *p = bb->page;
-	unsigned seq;
-
-	if (bb->shift < 0)
-		return 0;
-
-retry:
-	seq = read_seqbegin(&bb->lock);
-
-	len = 0;
-	i = 0;
-
-	while (len < PAGE_SIZE && i < bb->count) {
-		sector_t s = BB_OFFSET(p[i]);
-		unsigned int length = BB_LEN(p[i]);
-		int ack = BB_ACK(p[i]);
-		i++;
-
-		if (unack && ack)
-			continue;
-
-		len += snprintf(page+len, PAGE_SIZE-len, "%llu %u\n",
-				(unsigned long long)s << bb->shift,
-				length << bb->shift);
-	}
-	if (unack && len == 0)
-		bb->unacked_exist = 0;
-
-	if (read_seqretry(&bb->lock, seq))
-		goto retry;
-
-	return len;
-}
-
-#define DO_DEBUG 1
-
-static ssize_t
-badblocks_store(struct badblocks *bb, const char *page, size_t len, int unack)
-{
-	unsigned long long sector;
-	int length;
-	char newline;
-#ifdef DO_DEBUG
-	/* Allow clearing via sysfs *only* for testing/debugging.
-	 * Normally only a successful write may clear a badblock
-	 */
-	int clear = 0;
-	if (page[0] == '-') {
-		clear = 1;
-		page++;
-	}
-#endif /* DO_DEBUG */
-
-	switch (sscanf(page, "%llu %d%c", &sector, &length, &newline)) {
-	case 3:
-		if (newline != '\n')
-			return -EINVAL;
-	case 2:
-		if (length <= 0)
-			return -EINVAL;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-#ifdef DO_DEBUG
-	if (clear) {
-		md_clear_badblocks(bb, sector, length);
-		return len;
-	}
-#endif /* DO_DEBUG */
-	if (md_set_badblocks(bb, sector, length, !unack))
-		return len;
-	else
-		return -ENOSPC;
-}
-
 static int md_notify_reboot(struct notifier_block *this,
 			    unsigned long code, void *x)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ab33957..dd9fab8 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -17,6 +17,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
+#include <linux/badblocks.h>
 #include <linux/kobject.h>
 #include <linux/list.h>
 #include <linux/mm.h>
@@ -28,13 +29,6 @@
 
 #define MaxSector (~(sector_t)0)
 
-/* Bad block numbers are stored sorted in a single page.
- * 64bits is used for each block or extent.
- * 54 bits are sector number, 9 bits are extent size,
- * 1 bit is an 'acknowledged' flag.
- */
-#define MD_MAX_BADBLOCKS	(PAGE_SIZE/8)
-
 /*
  * MD's 'extended' device
  */
@@ -111,22 +105,7 @@ struct md_rdev {
 	struct kernfs_node *sysfs_state; /* handle for 'state'
 					   * sysfs entry */
 
-	struct badblocks {
-		int	count;		/* count of bad blocks */
-		int	unacked_exist;	/* there probably are unacknowledged
-					 * bad blocks.  This is only cleared
-					 * when a read discovers none
-					 */
-		int	shift;		/* shift from sectors to block size
-					 * a -ve shift means badblocks are
-					 * disabled.*/
-		u64	*page;		/* badblock list */
-		int	changed;
-		seqlock_t lock;
-
-		sector_t sector;
-		sector_t size;		/* in sectors */
-	} badblocks;
+	struct badblocks badblocks;
 };
 enum flag_bits {
 	Faulty,			/* device is known to have a fault */
@@ -183,13 +162,11 @@ enum flag_bits {
 #define BB_ACK(x)	(!!((x) & BB_ACK_MASK))
 #define BB_MAKE(a, l, ack) (((a)<<9) | ((l)-1) | ((u64)(!!(ack)) << 63))
 
-extern int md_is_badblock(struct badblocks *bb, sector_t s, int sectors,
-			  sector_t *first_bad, int *bad_sectors);
 static inline int is_badblock(struct md_rdev *rdev, sector_t s, int sectors,
 			      sector_t *first_bad, int *bad_sectors)
 {
 	if (unlikely(rdev->badblocks.count)) {
-		int rv = md_is_badblock(&rdev->badblocks, rdev->data_offset + s,
+		int rv = badblocks_check(&rdev->badblocks, rdev->data_offset + s,
 					sectors,
 					first_bad, bad_sectors);
 		if (rv)
@@ -202,8 +179,6 @@ extern int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 			      int is_new);
 extern int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 				int is_new);
-extern void md_ack_all_badblocks(struct badblocks *bb);
-
 struct md_cluster_info;
 
 struct mddev {
-- 
2.5.0

