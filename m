From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v8 2/2 RESEND] Add ioctl to issue ZBC/ZAC commands via block layer
Date: Wed, 24 Aug 2016 15:25:37 -0500
Message-ID: <20160824202537.30415-1-shaun@tancheff.com>
References: <20160822042010.32416-3-shaun@tancheff.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160822042010.32416-3-shaun@tancheff.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.de>, Josh Bingaman <josh.bingaman@seagate.com>, "David S . Miller" <davem@davemloft.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Guenter Roeck <linux@roeck-us.net>, Ming Lei <ming.lei@canonical.com>, Mike Christie <michaelc@cs.wisc.edu>, Keith Busch <keith.busch@intel.com>, Mike Snitzer <snitzer@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

(RESENDING to include f2fs, fs-devel and dm-devel)

Add support for ZBC ioctl's
    BLKREPORT     - Issue Report Zones to device.
    BLKZONEACTION - Issue a Zone Action (Close, Finish, Open, or Reset)

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
v8:
 - Changed ioctl for zone actions to a single ioctl that takes 
   a structure including the zone, zone action, all flag, and force option
 - Mapped REQ_META flag to 'force unit access' for zone operations
v6:
 - Added GFP_DMA to gfp mask.
v4:
 - Rebase on linux-next tag next-20160617.
 - Change bio flags to bio op's

 block/ioctl.c                     | 149 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/blkzoned_api.h |  30 +++++++-
 include/uapi/linux/fs.h           |   1 +
 3 files changed, 179 insertions(+), 1 deletion(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index ed2397f..d760523 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -194,6 +194,151 @@ int blkdev_reread_part(struct block_device *bdev)
 }
 EXPORT_SYMBOL(blkdev_reread_part);
 
+static int blk_zoned_report_ioctl(struct block_device *bdev, fmode_t mode,
+				  void __user *parg)
+{
+	int error = -EFAULT;
+	gfp_t gfp = GFP_KERNEL | GFP_DMA;
+	void *iopg = NULL;
+	struct bdev_zone_report_io *bzrpt = NULL;
+	int order = 0;
+	struct page *pgs = NULL;
+	u32 alloc_size = PAGE_SIZE;
+	unsigned int op_flags = 0;
+	u8 opt = 0;
+
+	if (!(mode & FMODE_READ))
+		return -EBADF;
+
+	iopg = (void *)get_zeroed_page(gfp);
+	if (!iopg) {
+		error = -ENOMEM;
+		goto report_zones_out;
+	}
+	bzrpt = iopg;
+	if (copy_from_user(bzrpt, parg, sizeof(*bzrpt))) {
+		error = -EFAULT;
+		goto report_zones_out;
+	}
+	if (bzrpt->data.in.return_page_count > alloc_size) {
+		int npages;
+
+		alloc_size = bzrpt->data.in.return_page_count;
+		npages = (alloc_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		pgs = alloc_pages(gfp, ilog2(npages));
+		if (pgs) {
+			void *mem = page_address(pgs);
+
+			if (!mem) {
+				error = -ENOMEM;
+				goto report_zones_out;
+			}
+			order = ilog2(npages);
+			memset(mem, 0, alloc_size);
+			memcpy(mem, bzrpt, sizeof(*bzrpt));
+			bzrpt = mem;
+		} else {
+			/* Result requires DMA capable memory */
+			pr_err("Not enough memory available for request.\n");
+			error = -ENOMEM;
+			goto report_zones_out;
+		}
+	} else {
+		alloc_size = bzrpt->data.in.return_page_count;
+	}
+	if (bzrpt->data.in.force_unit_access)
+		op_flags |= REQ_META;
+	opt = bzrpt->data.in.report_option;
+	error = blkdev_issue_zone_report(bdev, op_flags,
+			bzrpt->data.in.zone_locator_lba, opt,
+			pgs ? pgs : virt_to_page(iopg),
+			alloc_size, GFP_KERNEL);
+	if (error)
+		goto report_zones_out;
+
+	if (pgs) {
+		void *src = bzrpt;
+		u32 off = 0;
+
+		/*
+		 * When moving a multi-order page with GFP_DMA
+		 * the copy to user can trap "<spans multiple pages>"
+		 * so instead we copy out 1 page at a time.
+		 */
+		while (off < alloc_size && !error) {
+			u32 len = min_t(u32, PAGE_SIZE, alloc_size - off);
+
+			memcpy(iopg, src + off, len);
+			if (copy_to_user(parg + off, iopg, len))
+				error = -EFAULT;
+			off += len;
+		}
+	} else {
+		if (copy_to_user(parg, iopg, alloc_size))
+			error = -EFAULT;
+	}
+
+report_zones_out:
+	if (pgs)
+		__free_pages(pgs, order);
+	if (iopg)
+		free_page((unsigned long)iopg);
+	return error;
+}
+
+static int blk_zoned_action_ioctl(struct block_device *bdev, fmode_t mode,
+				  void __user *parg)
+{
+	unsigned int op = 0;
+	unsigned int op_flags = 0;
+	sector_t lba;
+	struct bdev_zone_action za;
+
+	if (!(mode & FMODE_WRITE))
+		return -EBADF;
+
+	/* When acting on zones we explicitly disallow using a partition. */
+	if (bdev != bdev->bd_contains) {
+		pr_err("%s: All zone operations disallowed on this device\n",
+			__func__);
+		return -EFAULT;
+	}
+
+	if (copy_from_user(&za, parg, sizeof(za)))
+		return -EFAULT;
+
+	switch (za.action) {
+	case ZONE_ACTION_CLOSE:
+		op = REQ_OP_ZONE_CLOSE;
+		break;
+	case ZONE_ACTION_FINISH:
+		op = REQ_OP_ZONE_FINISH;
+		break;
+	case ZONE_ACTION_OPEN:
+		op = REQ_OP_ZONE_OPEN;
+		break;
+	case ZONE_ACTION_RESET:
+		op = REQ_OP_ZONE_RESET;
+		break;
+	default:
+		pr_err("%s: Unknown action: %u\n", __func__, za.action);
+		return -EINVAL;
+	}
+
+	lba = za.zone_locator_lba;
+	if (za.all_zones) {
+		if (lba) {
+			pr_err("%s: if all_zones, LBA must be 0.\n", __func__);
+			return -EINVAL;
+		}
+		lba = ~0ul;
+	}
+	if (za.force_unit_access || lba == ~0ul)
+		op_flags |= REQ_META;
+
+	return blkdev_issue_zone_action(bdev, op, op_flags, lba, GFP_KERNEL);
+}
+
 static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
 		unsigned long arg, unsigned long flags)
 {
@@ -568,6 +713,10 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKTRACESETUP:
 	case BLKTRACETEARDOWN:
 		return blk_trace_ioctl(bdev, cmd, argp);
+	case BLKREPORT:
+		return blk_zoned_report_ioctl(bdev, mode, argp);
+	case BLKZONEACTION:
+		return blk_zoned_action_ioctl(bdev, mode, argp);
 	case IOC_PR_REGISTER:
 		return blkdev_pr_register(bdev, argp);
 	case IOC_PR_RESERVE:
diff --git a/include/uapi/linux/blkzoned_api.h b/include/uapi/linux/blkzoned_api.h
index d2bdba5..cd81a9f 100644
--- a/include/uapi/linux/blkzoned_api.h
+++ b/include/uapi/linux/blkzoned_api.h
@@ -115,6 +115,7 @@ enum bdev_zone_same {
  * @zone_locator_lba: starting lba for first [reported] zone
  * @return_page_count: number of *bytes* allocated for result
  * @report_option: see: zone_report_option enum
+ * @force_unit_access: Force report from media
  *
  * Used to issue report zones command to connected device
  */
@@ -122,6 +123,25 @@ struct bdev_zone_get_report {
 	__u64 zone_locator_lba;
 	__u32 return_page_count;
 	__u8  report_option;
+	__u8  force_unit_access;
+} __packed;
+
+/**
+ * struct bdev_zone_action - ioctl: Perform Zone Action
+ *
+ * @zone_locator_lba: starting lba for first [reported] zone
+ * @return_page_count: number of *bytes* allocated for result
+ * @action: One of the ZONE_ACTION_*'s Close,Finish,Open, or Reset
+ * @all_zones: Flag to indicate if command should apply to all zones.
+ * @force_unit_access: Force command to media and update zone cache on success
+ *
+ * Used to issue report zones command to connected device
+ */
+struct bdev_zone_action {
+	__u64 zone_locator_lba;
+	__u32 action;
+	__u8  all_zones;
+	__u8  force_unit_access;
 } __packed;
 
 /**
@@ -134,7 +154,6 @@ struct bdev_zone_get_report {
  * @lba_start: lba where the zone starts.
  * @lba_wptr: lba of the current write pointer.
  * @reserved: padding
- *
  */
 struct bdev_zone_descriptor {
 	__u8 type;
@@ -179,4 +198,13 @@ struct bdev_zone_report_io {
 	} data;
 } __packed;
 
+/* continuing from uapi/linux/fs.h: */
+#define BLKREPORT	_IOWR(0x12, 130, struct bdev_zone_report_io)
+#define BLKZONEACTION	_IOW(0x12, 131, struct bdev_zone_action)
+
+#define ZONE_ACTION_CLOSE	0x01
+#define ZONE_ACTION_FINISH	0x02
+#define ZONE_ACTION_OPEN	0x03
+#define ZONE_ACTION_RESET	0x04
+
 #endif /* _UAPI_BLKZONED_API_H */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 3b00f7c..350fb3f2 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -222,6 +222,7 @@ struct fsxattr {
 #define BLKSECDISCARD _IO(0x12,125)
 #define BLKROTATIONAL _IO(0x12,126)
 #define BLKZEROOUT _IO(0x12,127)
+/* A jump here: See blkzoned_api.h, Reserving 130 and 131. */
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
-- 
2.9.3

