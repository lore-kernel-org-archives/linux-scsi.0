From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH] block: introduce poison tracking for block devices
Date: Thu, 19 Nov 2015 14:15:58 -0700
Message-ID: <1447967758-30506-1-git-send-email-vishal.l.verma@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19567 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934316AbbKSVQT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2015 16:16:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, NeilBrown <neilb@suse.com>

This patch copies the badblock management code from md-raid to use it
for tracking bad/'poison' sectors on a per-block device level.

NVDIMM devices, which behave more like DRAM, may develop bad cache
lines, or 'poison'. A block device exposed by the pmem driver can
then consume poison via a read (or write), and cause a machine check.
On platforms without machine check recovery features, this would
mean a crash.

The block device maintaining a runtime list of all known poison can
directly avoid this, and also provide a path forward to enable proper
handling/recovery for DAX faults on such a device.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---

This really is a copy-paste + a few modifications of the badblock management
code + sysfs representation from md.

In this RFC, I want to make sure this path sounds acceptable for the use case
described above, for NVDIMMs. Eventually, I think the md badblock management
and this should be refactored to use the same code - I think this should be
easy to do:
- move the badblocks struct and associated functions into a header file (along
  the lines of include/linux/list.h)
- embed the structure into whatever needs to use this list (in case of md, this
  would be 'rdev', in the nvdimm case, the gendisk)
- call the functions from badblocks.h as needed to manipulate the list.
- The sysfs show/store functions in badblocks.h would be generic variants, with
  wrappers being present in md and gendisk to fit into their respective sysfs
  layouts

If this looks generally reasonable, I'll post a v2 with this refactoring done.

 block/genhd.c         | 502 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/genhd.h |  26 +++
 2 files changed, 528 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 0c706f3..de99d28 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -23,6 +23,15 @@
 
 #include "blk.h"
 
+#define BB_LEN_MASK	(0x00000000000001FFULL)
+#define BB_OFFSET_MASK	(0x7FFFFFFFFFFFFE00ULL)
+#define BB_ACK_MASK	(0x8000000000000000ULL)
+#define BB_MAX_LEN	512
+#define BB_OFFSET(x)	(((x) & BB_OFFSET_MASK) >> 9)
+#define BB_LEN(x)	(((x) & BB_LEN_MASK) + 1)
+#define BB_ACK(x)	(!!((x) & BB_ACK_MASK))
+#define BB_MAKE(a, l, ack) (((a)<<9) | ((l)-1) | ((u64)(!!(ack)) << 63))
+
 static DEFINE_MUTEX(block_class_lock);
 struct kobject *block_depr;
 
@@ -670,6 +679,496 @@ void del_gendisk(struct gendisk *disk)
 }
 EXPORT_SYMBOL(del_gendisk);
 
+int disk_poison_list_init(struct gendisk *disk)
+{
+	disk->plist = kmalloc(sizeof(*disk->plist), GFP_KERNEL);
+	if (!disk->plist)
+		return -ENOMEM;
+	disk->plist->count = 0;
+	disk->plist->shift = 0;
+	disk->plist->page = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	seqlock_init(&disk->plist->lock);
+	if (disk->plist->page == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL(disk_poison_list_init);
+
+/* Bad block management.
+ * We can record which blocks on each device are 'bad' and so just
+ * fail those blocks, or that stripe, rather than the whole device.
+ * Entries in the bad-block table are 64bits wide.  This comprises:
+ * Length of bad-range, in sectors: 0-511 for lengths 1-512
+ * Start of bad-range, sector offset, 54 bits (allows 8 exbibytes)
+ *  A 'shift' can be set so that larger blocks are tracked and
+ *  consequently larger devices can be covered.
+ * 'Acknowledged' flag - 1 bit. - the most significant bit.
+ *
+ * Locking of the bad-block table uses a seqlock so md_is_badblock
+ * might need to retry if it is very unlucky.
+ * We will sometimes want to check for bad blocks in a bi_end_io function,
+ * so we use the write_seqlock_irq variant.
+ *
+ * When looking for a bad block we specify a range and want to
+ * know if any block in the range is bad.  So we binary-search
+ * to the last range that starts at-or-before the given endpoint,
+ * (or "before the sector after the target range")
+ * then see if it ends after the given start.
+ * We return
+ *  0 if there are no known bad blocks in the range
+ *  1 if there are known bad block which are all acknowledged
+ * -1 if there are bad blocks which have not yet been acknowledged in metadata.
+ * plus the start/length of the first bad section we overlap.
+ */
+int disk_check_poison(struct gendisk *disk, sector_t s, int sectors,
+		   sector_t *first_bad, int *bad_sectors)
+{
+	struct disk_poison *bb = disk->plist;
+	int hi;
+	int lo;
+	u64 *p = bb->page;
+	int rv;
+	sector_t target = s + sectors;
+	unsigned seq;
+
+	if (bb->shift > 0) {
+		/* round the start down, and the end up */
+		s >>= bb->shift;
+		target += (1<<bb->shift) - 1;
+		target >>= bb->shift;
+		sectors = target - s;
+	}
+	/* 'target' is now the first block after the bad range */
+
+retry:
+	seq = read_seqbegin(&bb->lock);
+	lo = 0;
+	rv = 0;
+	hi = bb->count;
+
+	/* Binary search between lo and hi for 'target'
+	 * i.e. for the last range that starts before 'target'
+	 */
+	/* INVARIANT: ranges before 'lo' and at-or-after 'hi'
+	 * are known not to be the last range before target.
+	 * VARIANT: hi-lo is the number of possible
+	 * ranges, and decreases until it reaches 1
+	 */
+	while (hi - lo > 1) {
+		int mid = (lo + hi) / 2;
+		sector_t a = BB_OFFSET(p[mid]);
+		if (a < target)
+			/* This could still be the one, earlier ranges
+			 * could not. */
+			lo = mid;
+		else
+			/* This and later ranges are definitely out. */
+			hi = mid;
+	}
+	/* 'lo' might be the last that started before target, but 'hi' isn't */
+	if (hi > lo) {
+		/* need to check all range that end after 's' to see if
+		 * any are unacknowledged.
+		 */
+		while (lo >= 0 &&
+		       BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > s) {
+			if (BB_OFFSET(p[lo]) < target) {
+				/* starts before the end, and finishes after
+				 * the start, so they must overlap
+				 */
+				if (rv != -1 && BB_ACK(p[lo]))
+					rv = 1;
+				else
+					rv = -1;
+				*first_bad = BB_OFFSET(p[lo]);
+				*bad_sectors = BB_LEN(p[lo]);
+			}
+			lo--;
+		}
+	}
+
+	if (read_seqretry(&bb->lock, seq))
+		goto retry;
+
+	return rv;
+}
+EXPORT_SYMBOL_GPL(disk_check_poison);
+
+/*
+ * Add a range of bad blocks to the table.
+ * This might extend the table, or might contract it
+ * if two adjacent ranges can be merged.
+ * We binary-search to find the 'insertion' point, then
+ * decide how best to handle it.
+ */
+int disk_add_poison(struct gendisk *disk, sector_t s, int sectors,
+			    int acknowledged)
+{
+	struct disk_poison *bb = disk->plist;
+	u64 *p;
+	int lo, hi;
+	int rv = 1;
+	unsigned long flags;
+
+	if (bb->shift < 0)
+		/* badblocks are disabled */
+		return 0;
+
+	if (bb->shift) {
+		/* round the start down, and the end up */
+		sector_t next = s + sectors;
+		s >>= bb->shift;
+		next += (1<<bb->shift) - 1;
+		next >>= bb->shift;
+		sectors = next - s;
+	}
+
+	write_seqlock_irqsave(&bb->lock, flags);
+
+	p = bb->page;
+	lo = 0;
+	hi = bb->count;
+	/* Find the last range that starts at-or-before 's' */
+	while (hi - lo > 1) {
+		int mid = (lo + hi) / 2;
+		sector_t a = BB_OFFSET(p[mid]);
+		if (a <= s)
+			lo = mid;
+		else
+			hi = mid;
+	}
+	if (hi > lo && BB_OFFSET(p[lo]) > s)
+		hi = lo;
+
+	if (hi > lo) {
+		/* we found a range that might merge with the start
+		 * of our new range
+		 */
+		sector_t a = BB_OFFSET(p[lo]);
+		sector_t e = a + BB_LEN(p[lo]);
+		int ack = BB_ACK(p[lo]);
+		if (e >= s) {
+			/* Yes, we can merge with a previous range */
+			if (s == a && s + sectors >= e)
+				/* new range covers old */
+				ack = acknowledged;
+			else
+				ack = ack && acknowledged;
+
+			if (e < s + sectors)
+				e = s + sectors;
+			if (e - a <= BB_MAX_LEN) {
+				p[lo] = BB_MAKE(a, e-a, ack);
+				s = e;
+			} else {
+				/* does not all fit in one range,
+				 * make p[lo] maximal
+				 */
+				if (BB_LEN(p[lo]) != BB_MAX_LEN)
+					p[lo] = BB_MAKE(a, BB_MAX_LEN, ack);
+				s = a + BB_MAX_LEN;
+			}
+			sectors = e - s;
+		}
+	}
+	if (sectors && hi < bb->count) {
+		/* 'hi' points to the first range that starts after 's'.
+		 * Maybe we can merge with the start of that range */
+		sector_t a = BB_OFFSET(p[hi]);
+		sector_t e = a + BB_LEN(p[hi]);
+		int ack = BB_ACK(p[hi]);
+		if (a <= s + sectors) {
+			/* merging is possible */
+			if (e <= s + sectors) {
+				/* full overlap */
+				e = s + sectors;
+				ack = acknowledged;
+			} else
+				ack = ack && acknowledged;
+
+			a = s;
+			if (e - a <= BB_MAX_LEN) {
+				p[hi] = BB_MAKE(a, e-a, ack);
+				s = e;
+			} else {
+				p[hi] = BB_MAKE(a, BB_MAX_LEN, ack);
+				s = a + BB_MAX_LEN;
+			}
+			sectors = e - s;
+			lo = hi;
+			hi++;
+		}
+	}
+	if (sectors == 0 && hi < bb->count) {
+		/* we might be able to combine lo and hi */
+		/* Note: 's' is at the end of 'lo' */
+		sector_t a = BB_OFFSET(p[hi]);
+		int lolen = BB_LEN(p[lo]);
+		int hilen = BB_LEN(p[hi]);
+		int newlen = lolen + hilen - (s - a);
+		if (s >= a && newlen < BB_MAX_LEN) {
+			/* yes, we can combine them */
+			int ack = BB_ACK(p[lo]) && BB_ACK(p[hi]);
+			p[lo] = BB_MAKE(BB_OFFSET(p[lo]), newlen, ack);
+			memmove(p + hi, p + hi + 1,
+				(bb->count - hi - 1) * 8);
+			bb->count--;
+		}
+	}
+	while (sectors) {
+		/* didn't merge (it all).
+		 * Need to add a range just before 'hi' */
+		if (bb->count >= DISK_MAX_POISON) {
+			/* No room for more */
+			rv = 0;
+			break;
+		} else {
+			int this_sectors = sectors;
+			memmove(p + hi + 1, p + hi,
+				(bb->count - hi) * 8);
+			bb->count++;
+
+			if (this_sectors > BB_MAX_LEN)
+				this_sectors = BB_MAX_LEN;
+			p[hi] = BB_MAKE(s, this_sectors, acknowledged);
+			sectors -= this_sectors;
+			s += this_sectors;
+		}
+	}
+
+	bb->changed = 1;
+	if (!acknowledged)
+		bb->unacked_exist = 1;
+	write_sequnlock_irqrestore(&bb->lock, flags);
+
+	/* Make sure they get written out promptly */
+	/* TODO sysfs_notify_dirent_safe(disk->sysfs_state); */
+
+	return rv;
+}
+EXPORT_SYMBOL_GPL(disk_add_poison);
+
+/*
+ * Remove a range of bad blocks from the table.
+ * This may involve extending the table if we spilt a region,
+ * but it must not fail.  So if the table becomes full, we just
+ * drop the remove request.
+ */
+int disk_clear_poison(struct gendisk *disk, sector_t s, int sectors)
+{
+	struct disk_poison *bb = disk->plist;
+	u64 *p;
+	int lo, hi;
+	sector_t target = s + sectors;
+	int rv = 0;
+
+	if (bb->shift > 0) {
+		/* When clearing we round the start up and the end down.
+		 * This should not matter as the shift should align with
+		 * the block size and no rounding should ever be needed.
+		 * However it is better the think a block is bad when it
+		 * isn't than to think a block is not bad when it is.
+		 */
+		s += (1<<bb->shift) - 1;
+		s >>= bb->shift;
+		target >>= bb->shift;
+		sectors = target - s;
+	}
+
+	write_seqlock_irq(&bb->lock);
+
+	p = bb->page;
+	lo = 0;
+	hi = bb->count;
+	/* Find the last range that starts before 'target' */
+	while (hi - lo > 1) {
+		int mid = (lo + hi) / 2;
+		sector_t a = BB_OFFSET(p[mid]);
+		if (a < target)
+			lo = mid;
+		else
+			hi = mid;
+	}
+	if (hi > lo) {
+		/* p[lo] is the last range that could overlap the
+		 * current range.  Earlier ranges could also overlap,
+		 * but only this one can overlap the end of the range.
+		 */
+		if (BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > target) {
+			/* Partial overlap, leave the tail of this range */
+			int ack = BB_ACK(p[lo]);
+			sector_t a = BB_OFFSET(p[lo]);
+			sector_t end = a + BB_LEN(p[lo]);
+
+			if (a < s) {
+				/* we need to split this range */
+				if (bb->count >= DISK_MAX_POISON) {
+					rv = -ENOSPC;
+					goto out;
+				}
+				memmove(p+lo+1, p+lo, (bb->count - lo) * 8);
+				bb->count++;
+				p[lo] = BB_MAKE(a, s-a, ack);
+				lo++;
+			}
+			p[lo] = BB_MAKE(target, end - target, ack);
+			/* there is no longer an overlap */
+			hi = lo;
+			lo--;
+		}
+		while (lo >= 0 &&
+		       BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > s) {
+			/* This range does overlap */
+			if (BB_OFFSET(p[lo]) < s) {
+				/* Keep the early parts of this range. */
+				int ack = BB_ACK(p[lo]);
+				sector_t start = BB_OFFSET(p[lo]);
+				p[lo] = BB_MAKE(start, s - start, ack);
+				/* now low doesn't overlap, so.. */
+				break;
+			}
+			lo--;
+		}
+		/* 'lo' is strictly before, 'hi' is strictly after,
+		 * anything between needs to be discarded
+		 */
+		if (hi - lo > 1) {
+			memmove(p+lo+1, p+hi, (bb->count - hi) * 8);
+			bb->count -= (hi - lo - 1);
+		}
+	}
+
+	bb->changed = 1;
+out:
+	write_sequnlock_irq(&bb->lock);
+	return rv;
+}
+EXPORT_SYMBOL_GPL(disk_clear_poison);
+
+/*
+ * Acknowledge all bad blocks in a list.
+ * This only succeeds if ->changed is clear.  It is used by
+ * in-kernel metadata updates
+ */
+void disk_ack_all_poison(struct gendisk *disk)
+{
+	struct disk_poison *bb = disk->plist;
+
+	if (bb->page == NULL || bb->changed)
+		/* no point even trying */
+		return;
+	write_seqlock_irq(&bb->lock);
+
+	if (bb->changed == 0 && bb->unacked_exist) {
+		u64 *p = bb->page;
+		int i;
+		for (i = 0; i < bb->count ; i++) {
+			if (!BB_ACK(p[i])) {
+				sector_t start = BB_OFFSET(p[i]);
+				int len = BB_LEN(p[i]);
+				p[i] = BB_MAKE(start, len, 1);
+			}
+		}
+		bb->unacked_exist = 0;
+	}
+	write_sequnlock_irq(&bb->lock);
+}
+EXPORT_SYMBOL_GPL(disk_ack_all_poison);
+
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
+
+static ssize_t poison_list_show(struct device *dev,
+					struct device_attribute *attr,
+					char *page)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	struct disk_poison *bb = disk->plist;
+	size_t len;
+	int i;
+	u64 *p = bb->page;
+	unsigned seq;
+
+	if (bb->shift < 0)
+		return 0;
+
+retry:
+	seq = read_seqbegin(&bb->lock);
+
+	len = 0;
+	i = 0;
+
+	while (len < PAGE_SIZE && i < bb->count) {
+		sector_t s = BB_OFFSET(p[i]);
+		unsigned int length = BB_LEN(p[i]);
+
+		i++;
+		len += snprintf(page+len, PAGE_SIZE-len, "%llu %u\n",
+				(unsigned long long)s << bb->shift,
+				length << bb->shift);
+	}
+
+	if (read_seqretry(&bb->lock, seq))
+		goto retry;
+
+	return len;
+}
+
+#define DO_DEBUG 1
+
+static ssize_t poison_list_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *page, size_t len)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	unsigned long long sector;
+	int length;
+	char newline;
+#ifdef DO_DEBUG
+	/* Allow clearing via sysfs *only* for testing/debugging.
+	 * Normally only a successful write may clear a badblock
+	 */
+	int clear = 0;
+	if (page[0] == '-') {
+		clear = 1;
+		page++;
+	}
+#endif /* DO_DEBUG */
+
+	switch (sscanf(page, "%llu %d%c", &sector, &length, &newline)) {
+	case 3:
+		if (newline != '\n')
+			return -EINVAL;
+	case 2:
+		if (length <= 0)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+#ifdef DO_DEBUG
+	if (clear) {
+		disk_clear_poison(disk, sector, length);
+		return len;
+	}
+#endif /* DO_DEBUG */
+	if (disk_add_poison(disk, sector, length, 1))
+		return len;
+	else
+		return -ENOSPC;
+}
+
 /**
  * get_gendisk - get partitioning information for a given device
  * @devt: device to get partitioning information for
@@ -988,6 +1487,8 @@ static DEVICE_ATTR(discard_alignment, S_IRUGO, disk_discard_alignment_show,
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
+static DEVICE_ATTR(poison_list, S_IRUGO | S_IWUSR, poison_list_show,
+		poison_list_store);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
@@ -1009,6 +1510,7 @@ static struct attribute *disk_attrs[] = {
 	&dev_attr_capability.attr,
 	&dev_attr_stat.attr,
 	&dev_attr_inflight.attr,
+	&dev_attr_poison_list.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 2adbfa6..9acfe1b 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -163,6 +163,24 @@ struct disk_part_tbl {
 
 struct disk_events;
 
+#define DISK_MAX_POISON	(PAGE_SIZE/8)
+
+struct disk_poison {
+	int count;		/* count of bad blocks */
+	int unacked_exist;	/* there probably are unacknowledged
+				 * bad blocks.  This is only cleared
+				 * when a read discovers none
+				 */
+	int shift;		/* shift from sectors to block size
+				 * a -ve shift means badblocks are
+				 * disabled.*/
+	u64 *page;		/* badblock list */
+	int changed;
+	seqlock_t lock;
+	sector_t sector;
+	sector_t size;		/* in sectors */
+};
+
 struct gendisk {
 	/* major, first_minor and minors are input parameters only,
 	 * don't use directly.  Use disk_devt() and disk_max_parts().
@@ -201,6 +219,7 @@ struct gendisk {
 	struct blk_integrity *integrity;
 #endif
 	int node_id;
+	struct disk_poison *plist;
 };
 
 static inline struct gendisk *part_to_disk(struct hd_struct *part)
@@ -434,6 +453,13 @@ extern void disk_block_events(struct gendisk *disk);
 extern void disk_unblock_events(struct gendisk *disk);
 extern void disk_flush_events(struct gendisk *disk, unsigned int mask);
 extern unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask);
+extern int disk_poison_list_init(struct gendisk *disk);
+extern int disk_check_poison(struct gendisk *disk, sector_t s, int sectors,
+		   sector_t *first_bad, int *bad_sectors);
+extern int disk_add_poison(struct gendisk *disk, sector_t s, int sectors,
+			    int acknowledged);
+extern int disk_clear_poison(struct gendisk *disk, sector_t s, int sectors);
+extern void disk_ack_all_poison(struct gendisk *disk);
 
 /* drivers/char/random.c */
 extern void add_disk_randomness(struct gendisk *disk);
-- 
2.5.0

