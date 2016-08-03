From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH 1/2] bio/zbc support for zone cache
Date: Wed,  3 Aug 2016 14:06:44 -0500
Message-ID: <1470251205-4916-2-git-send-email-shaun@tancheff.com>
References: <1470251205-4916-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470251205-4916-1-git-send-email-shaun@tancheff.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Josh Bingaman <josh.bingaman@seagate.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Hannes Reinecke <hare@suse.de>, Damien Le Moal <damien.lemoal@hgst.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, Toshi Kani <toshi.kani@hpe.com>, Kent Overstreet <kent.overstreet@gmail.com>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-scsi@vger.kernel.org

Zone actions (Open/Close/Reset) update zone cache on success.

Add helpers for
- Zone actions to update zone cache
- Zone report to translate cache to ZBC format structs

Update blkreport to pull from zone cache instead of querying media.

Added open explicit and closed states for zone cache

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>

Cc: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>

---
 block/blk-lib.c        |   3 +-
 block/blk-zoned.c      | 190 +++++++++++++++++++++++++++++++++++++++++++++++++
 block/ioctl.c          |  39 +++++++---
 include/linux/blkdev.h |  14 +++-
 4 files changed, 234 insertions(+), 12 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 6dcdcbf..92898ec 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -6,7 +6,6 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/scatterlist.h>
-#include <linux/blkzoned_api.h>
 
 #include "blk.h"
 
@@ -358,6 +357,8 @@ int blkdev_issue_zone_action(struct block_device *bdev, unsigned int op,
 	bio_set_op_attrs(bio, op, op_flags);
 	ret = submit_bio_wait(bio);
 	bio_put(bio);
+	if (ret == 0)
+		update_zone_state(bdev, sector, op);
 	return ret;
 }
 EXPORT_SYMBOL(blkdev_issue_zone_action);
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 975e863..799676b 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -68,3 +68,193 @@ void blk_drop_zones(struct request_queue *q)
 	q->zones = RB_ROOT;
 }
 EXPORT_SYMBOL_GPL(blk_drop_zones);
+
+static void __set_zone_state(struct blk_zone *zone, int op)
+{
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+		return;
+
+	switch (op) {
+	case REQ_OP_ZONE_OPEN:
+		zone->state = BLK_ZONE_OPEN_EXPLICIT;
+		break;
+	case REQ_OP_ZONE_CLOSE:
+		zone->state = BLK_ZONE_CLOSED;
+		break;
+	case REQ_OP_ZONE_RESET:
+		zone->wp = zone->start;
+		break;
+	default:
+		WARN_ONCE(1, "%s: invalid op code: %u\n", __func__, op);
+	}
+}
+
+void update_zone_state(struct block_device *bdev, sector_t lba, unsigned int op)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct blk_zone *zone = NULL;
+
+	if (lba == ~0ul) {
+		struct rb_node *node;
+
+		for (node = rb_first(&q->zones); node; node = rb_next(node)) {
+			zone = rb_entry(node, struct blk_zone, node);
+			__set_zone_state(zone, op);
+		}
+		return;
+	}
+	zone = blk_lookup_zone(q, lba);
+	if (zone)
+		__set_zone_state(zone, op);
+}
+EXPORT_SYMBOL_GPL(update_zone_state);
+
+void bzrpt_fill(struct block_device *bdev, struct bdev_zone_report *bzrpt,
+		size_t sz, sector_t lba, u8 opt)
+{
+	u64 clen = ~0ul;
+	struct blk_zone *zone = NULL;
+	struct rb_node *node = NULL;
+	struct request_queue *q = bdev_get_queue(bdev);
+	u32 max_entries = (sz - sizeof(struct bdev_zone_report))
+			/  sizeof(struct bdev_zone_descriptor);
+	u32 entry;
+	int len_diffs = 0;
+	int type_diffs = 0;
+	u8 ctype;
+	u8 same = 0;
+
+	zone = blk_lookup_zone(q, lba);
+	if (zone)
+		node = &zone->node;
+
+	for (entry = 0;
+	     entry < max_entries && node;
+	     entry++, node = rb_next(node)) {
+		u64 wp;
+		u8 cond = 0;
+		u8 flgs = 0;
+
+		zone = rb_entry(node, struct blk_zone, node);
+		if (blk_zone_is_cmr(zone))
+			wp = zone->start + zone->len;
+		else
+			wp = zone->wp;
+
+		bzrpt->descriptors[entry].lba_start = cpu_to_be64(zone->start);
+		bzrpt->descriptors[entry].length = cpu_to_be64(zone->len);
+		bzrpt->descriptors[entry].type = zone->type;
+		bzrpt->descriptors[entry].lba_wptr = cpu_to_be64(wp);
+
+		switch (zone->state) {
+		case BLK_ZONE_NO_WP:
+			cond = ZCOND_CONVENTIONAL;
+			break;
+		case BLK_ZONE_OPEN:
+			cond = ZCOND_ZC2_OPEN_IMPLICIT;
+			break;
+		case BLK_ZONE_OPEN_EXPLICIT:
+			cond = ZCOND_ZC3_OPEN_EXPLICIT;
+			break;
+		case BLK_ZONE_CLOSED:
+			cond = ZCOND_ZC4_CLOSED;
+			break;
+		case BLK_ZONE_READONLY:
+			cond = ZCOND_ZC6_READ_ONLY;
+			break;
+		case BLK_ZONE_OFFLINE:
+			cond = ZCOND_ZC7_OFFLINE;
+			break;
+		default:
+			cond = 5; /* not mapable */
+			break;
+		}
+		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+			flgs |= 0x02;
+		if (zone->wp == zone->start)
+			flgs |= 0x01; /* flag as reset */
+		bzrpt->descriptors[entry].flags = cond << 4 | flgs;
+		bzrpt->descriptor_count = cpu_to_be32(entry+1);
+
+		switch (opt & 0x3f) {
+		case ZOPT_RESET:
+		case ZOPT_ZC1_EMPTY:
+			if (zone->wp != zone->start)
+				continue;
+			break;
+		case ZOPT_ZC5_FULL:
+			if (zone->wp >= (zone->start + zone->len))
+				continue;
+			break;
+		case ZOPT_ZC2_OPEN_IMPLICIT:
+			if (zone->state != BLK_ZONE_OPEN)
+				continue;
+			break;
+		case ZOPT_ZC3_OPEN_EXPLICIT:
+			if (zone->state != BLK_ZONE_OPEN_EXPLICIT)
+				continue;
+			break;
+		case ZOPT_ZC4_CLOSED:
+			if (zone->state != BLK_ZONE_CLOSED)
+				continue;
+			break;
+		case ZOPT_NON_SEQ:
+		case ZOPT_NON_WP_ZONES:
+			if (zone->state == BLK_ZONE_NO_WP)
+				continue;
+			break;
+		case ZOPT_ZC6_READ_ONLY:
+			if (zone->state == BLK_ZONE_READONLY)
+				continue;
+			break;
+		case ZOPT_ZC7_OFFLINE:
+			if (zone->state == BLK_ZONE_OFFLINE)
+				continue;
+			break;
+		default:
+			break;
+		}
+		/* if same code only applies to returned zones */
+		if (opt & ZOPT_PARTIAL_FLAG) {
+			if (clen != ~0ul) {
+				clen = zone->len;
+				ctype = zone->type;
+			}
+			if (zone->len != clen)
+				len_diffs++;
+			if (zone->type != ctype)
+				type_diffs++;
+			ctype = zone->type;
+		}
+	}
+
+	/* if same code only applies to all zones */
+	if (!(opt & ZOPT_PARTIAL_FLAG)) {
+		for (node = rb_first(&q->zones); node; node = rb_next(node)) {
+			zone = rb_entry(node, struct blk_zone, node);
+			if (clen != ~0ul) {
+				clen = zone->len;
+				ctype = zone->type;
+			}
+			if (zone->len != clen)
+				len_diffs++;
+			if (zone->type != ctype)
+				type_diffs++;
+			ctype = zone->type;
+		}
+	}
+
+	if (len_diffs == 0) {
+		if (type_diffs == 0)
+			same = ZS_ALL_SAME;
+		else
+			same = ZS_SAME_LEN_DIFF_TYPES;
+	} else if (len_diffs == 1 && type_diffs == 0) {
+		same = ZS_LAST_DIFFERS;
+	} else {
+		same = ZS_ALL_DIFFERENT;
+	}
+	bzrpt->same_field = same;
+	bzrpt->maximum_lba = i_size_read(bdev->bd_inode);
+}
+EXPORT_SYMBOL_GPL(bzrpt_fill);
diff --git a/block/ioctl.c b/block/ioctl.c
index a2a6c2c..44c8cb7 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -7,7 +7,6 @@
 #include <linux/backing-dev.h>
 #include <linux/fs.h>
 #include <linux/blktrace_api.h>
-#include <linux/blkzoned_api.h>
 #include <linux/pr.h>
 #include <asm/uaccess.h>
 
@@ -201,11 +200,13 @@ static int blk_zoned_report_ioctl(struct block_device *bdev, fmode_t mode,
 	int error = -EFAULT;
 	gfp_t gfp = GFP_KERNEL | GFP_DMA;
 	struct bdev_zone_report_io *zone_iodata = NULL;
+	struct bdev_zone_report *bzrpt = NULL;
 	int order = 0;
 	struct page *pgs = NULL;
 	u32 alloc_size = PAGE_SIZE;
 	unsigned long op_flags = 0;
-	u8 opt = 0;
+	sector_t lba = 0ul;
+	u8 opt;
 
 	if (!(mode & FMODE_READ))
 		return -EBADF;
@@ -219,6 +220,30 @@ static int blk_zoned_report_ioctl(struct block_device *bdev, fmode_t mode,
 		error = -EFAULT;
 		goto report_zones_out;
 	}
+
+	lba = zone_iodata->data.in.zone_locator_lba;
+	opt = zone_iodata->data.in.report_option;
+
+#ifdef CONFIG_BLK_DEV_ZONED
+	if (zone_iodata->data.in.return_page_count > alloc_size) {
+		alloc_size = zone_iodata->data.in.return_page_count;
+		bzrpt = kzalloc(alloc_size, GFP_KERNEL);
+		if (bzrpt) {
+			free_page((unsigned long)zone_iodata);
+			zone_iodata = (void *)bzrpt;
+		} else {
+			/* Result requires DMA capable memory */
+			pr_err("Not enough memory available for request.\n");
+			error = -ENOMEM;
+			goto report_zones_out;
+		}
+	}
+	(void)op_flags;
+	bzrpt_fill(bdev, &zone_iodata->data.out, alloc_size, lba, opt);
+	error = 0;
+	if (copy_to_user(parg, zone_iodata, alloc_size))
+		error = -EFAULT;
+#else
 	if (zone_iodata->data.in.return_page_count > alloc_size) {
 		int npages;
 
@@ -234,7 +259,6 @@ static int blk_zoned_report_ioctl(struct block_device *bdev, fmode_t mode,
 			}
 			order = ilog2(npages);
 			memset(mem, 0, alloc_size);
-			memcpy(mem, zone_iodata, sizeof(*zone_iodata));
 			free_page((unsigned long)zone_iodata);
 			zone_iodata = mem;
 		} else {
@@ -244,21 +268,20 @@ static int blk_zoned_report_ioctl(struct block_device *bdev, fmode_t mode,
 			goto report_zones_out;
 		}
 	}
-	opt = zone_iodata->data.in.report_option;
-	error = blkdev_issue_zone_report(bdev, op_flags,
-			zone_iodata->data.in.zone_locator_lba, opt,
+	error = blkdev_issue_zone_report(bdev, op_flags, lba, opt,
 			pgs ? pgs : virt_to_page(zone_iodata),
 			alloc_size, GFP_KERNEL);
-
 	if (error)
 		goto report_zones_out;
-
 	if (copy_to_user(parg, zone_iodata, alloc_size))
 		error = -EFAULT;
+#endif
 
 report_zones_out:
 	if (pgs)
 		__free_pages(pgs, order);
+	else if (bzrpt)
+		kfree(bzrpt);
 	else if (zone_iodata)
 		free_page((unsigned long)zone_iodata);
 	return error;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9b2f5e8..c1b4e2f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -24,6 +24,7 @@
 #include <linux/rcupdate.h>
 #include <linux/percpu-refcount.h>
 #include <linux/scatterlist.h>
+#include <linux/blkzoned_api.h>
 
 struct module;
 struct scsi_ioctl_command;
@@ -275,6 +276,8 @@ enum blk_zone_state {
 	BLK_ZONE_UNKNOWN,
 	BLK_ZONE_NO_WP,
 	BLK_ZONE_OPEN,
+	BLK_ZONE_OPEN_EXPLICIT,
+	BLK_ZONE_CLOSED,
 	BLK_ZONE_READONLY,
 	BLK_ZONE_OFFLINE,
 	BLK_ZONE_BUSY,
@@ -291,9 +294,9 @@ struct blk_zone {
 	void *private_data;
 };
 
-#define blk_zone_is_smr(z) ((z)->type == BLK_ZONE_TYPE_SEQWRITE_REQ ||	\
-			    (z)->type == BLK_ZONE_TYPE_SEQWRITE_PREF)
-
+#define blk_zone_is_seq_req(z) ((z)->type == BLK_ZONE_TYPE_SEQWRITE_REQ)
+#define blk_zone_is_seq_pref(z) ((z)->type == BLK_ZONE_TYPE_SEQWRITE_PREF)
+#define blk_zone_is_smr(z) (blk_zone_is_seq_req(z) || blk_zone_is_seq_pref(z))
 #define blk_zone_is_cmr(z) ((z)->type == BLK_ZONE_TYPE_CONVENTIONAL)
 #define blk_zone_is_full(z) ((z)->wp == (z)->start + (z)->len)
 #define blk_zone_is_empty(z) ((z)->wp == (z)->start)
@@ -302,8 +305,13 @@ extern struct blk_zone *blk_lookup_zone(struct request_queue *, sector_t);
 extern struct blk_zone *blk_insert_zone(struct request_queue *,
 					struct blk_zone *);
 extern void blk_drop_zones(struct request_queue *);
+extern void update_zone_state(struct block_device *, sector_t, unsigned int);
+extern void bzrpt_fill(struct block_device *, struct bdev_zone_report *, size_t,
+		       sector_t, u8);
 #else
 static inline void blk_drop_zones(struct request_queue *q) { };
+static inline void update_zone_state(struct block_device *bdev,
+				     sector_t lba, unsigned int op) {}
 #endif
 
 struct queue_limits {
-- 
2.8.1
