From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v5 2/2] Add ioctl to issue ZBC/ZAC commands via block layer
Date: Mon, 20 Jun 2016 16:18:36 -0500
Message-ID: <1466457516-21843-3-git-send-email-shaun@tancheff.com>
References: <1466457516-21843-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1466457516-21843-1-git-send-email-shaun@tancheff.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

Add New ioctl types
    BLKREPORT    - Issue Report Zones to device.
    BLKOPENZONE  - Issue an Zone Action: Open Zone command.
    BLKCLOSEZONE - Issue an Zone Action: Close Zone command.
    BLKRESETZONE - Issue an Zone Action: Reset Zone command.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
v4:
 - Rebase on linux-next tag next-20160617.
 - Change bio flags to bio op's
---
 block/ioctl.c                     | 110 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/blkzoned_api.h |   6 +++
 include/uapi/linux/fs.h           |   1 +
 3 files changed, 117 insertions(+)

diff --git a/block/ioctl.c b/block/ioctl.c
index ed2397f..97e685e 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -7,6 +7,7 @@
 #include <linux/backing-dev.h>
 #include <linux/fs.h>
 #include <linux/blktrace_api.h>
+#include <linux/blkzoned_api.h>
 #include <linux/pr.h>
 #include <asm/uaccess.h>
 
@@ -194,6 +195,109 @@ int blkdev_reread_part(struct block_device *bdev)
 }
 EXPORT_SYMBOL(blkdev_reread_part);
 
+static int blk_zoned_report_ioctl(struct block_device *bdev, fmode_t mode,
+		void __user *parg)
+{
+	int error = -EFAULT;
+	gfp_t gfp = GFP_KERNEL;
+	struct bdev_zone_report_io *zone_iodata = NULL;
+	int order = 0;
+	struct page *pgs = NULL;
+	u32 alloc_size = PAGE_SIZE;
+	unsigned long op_flags = 0;
+	u8 opt = 0;
+
+	if (!(mode & FMODE_READ))
+		return -EBADF;
+
+	zone_iodata = (void *)get_zeroed_page(gfp);
+	if (!zone_iodata) {
+		error = -ENOMEM;
+		goto report_zones_out;
+	}
+	if (copy_from_user(zone_iodata, parg, sizeof(*zone_iodata))) {
+		error = -EFAULT;
+		goto report_zones_out;
+	}
+	if (zone_iodata->data.in.return_page_count > alloc_size) {
+		int npages;
+
+		alloc_size = zone_iodata->data.in.return_page_count;
+		npages = (alloc_size + PAGE_SIZE - 1) / PAGE_SIZE;
+		order =  ilog2(roundup_pow_of_two(npages));
+		pgs = alloc_pages(gfp, order);
+		if (pgs) {
+			void *mem = page_address(pgs);
+
+			if (!mem) {
+				error = -ENOMEM;
+				goto report_zones_out;
+			}
+			memset(mem, 0, alloc_size);
+			memcpy(mem, zone_iodata, sizeof(*zone_iodata));
+			free_page((unsigned long)zone_iodata);
+			zone_iodata = mem;
+		} else {
+			/* Result requires DMA capable memory */
+			pr_err("Not enough memory available for request.\n");
+			error = -ENOMEM;
+			goto report_zones_out;
+		}
+	}
+	opt = zone_iodata->data.in.report_option;
+	error = blkdev_issue_zone_report(bdev, op_flags,
+			zone_iodata->data.in.zone_locator_lba, opt,
+			pgs ? pgs : virt_to_page(zone_iodata),
+			alloc_size, GFP_KERNEL);
+
+	if (error)
+		goto report_zones_out;
+
+	if (copy_to_user(parg, zone_iodata, alloc_size))
+		error = -EFAULT;
+
+report_zones_out:
+	if (pgs)
+		__free_pages(pgs, order);
+	else if (zone_iodata)
+		free_page((unsigned long)zone_iodata);
+	return error;
+}
+
+static int blk_zoned_action_ioctl(struct block_device *bdev, fmode_t mode,
+				  unsigned int cmd, unsigned long arg)
+{
+	unsigned int op = 0;
+
+	if (!(mode & FMODE_WRITE))
+		return -EBADF;
+
+	/*
+	 * When acting on zones we explicitly disallow using a partition.
+	 */
+	if (bdev != bdev->bd_contains) {
+		pr_err("%s: All zone operations disallowed on this device\n",
+			__func__);
+		return -EFAULT;
+	}
+
+	switch (cmd) {
+	case BLKOPENZONE:
+		op = REQ_OP_ZONE_OPEN;
+		break;
+	case BLKCLOSEZONE:
+		op = REQ_OP_ZONE_CLOSE;
+		break;
+	case BLKRESETZONE:
+		op = REQ_OP_ZONE_RESET;
+		break;
+	default:
+		pr_err("%s: Unknown action: %u\n", __func__, cmd);
+		return -EINVAL;
+	}
+	return blkdev_issue_zone_action(bdev, op, 0, arg, GFP_KERNEL);
+}
+
 static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
 		unsigned long arg, unsigned long flags)
 {
@@ -568,6 +672,12 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKTRACESETUP:
 	case BLKTRACETEARDOWN:
 		return blk_trace_ioctl(bdev, cmd, argp);
+	case BLKREPORT:
+		return blk_zoned_report_ioctl(bdev, mode, argp);
+	case BLKOPENZONE:
+	case BLKCLOSEZONE:
+	case BLKRESETZONE:
+		return blk_zoned_action_ioctl(bdev, mode, cmd, arg);
 	case IOC_PR_REGISTER:
 		return blkdev_pr_register(bdev, argp);
 	case IOC_PR_RESERVE:
diff --git a/include/uapi/linux/blkzoned_api.h b/include/uapi/linux/blkzoned_api.h
index 48c17ad..3566de0 100644
--- a/include/uapi/linux/blkzoned_api.h
+++ b/include/uapi/linux/blkzoned_api.h
@@ -211,4 +211,10 @@ struct bdev_zone_report_io {
 	} data;
 } __packed;
 
+/* continuing from uapi/linux/fs.h: */
+#define BLKREPORT	_IOWR(0x12, 130, struct bdev_zone_report_io)
+#define BLKOPENZONE	_IO(0x12, 131)
+#define BLKCLOSEZONE	_IO(0x12, 132)
+#define BLKRESETZONE	_IO(0x12, 133)
+
 #endif /* _UAPI_BLKZONED_API_H */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 3b00f7c..c0b565b 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -222,6 +222,7 @@ struct fsxattr {
 #define BLKSECDISCARD _IO(0x12,125)
 #define BLKROTATIONAL _IO(0x12,126)
 #define BLKZEROOUT _IO(0x12,127)
+/* A jump here: See blkzoned_api.h, Reserving 130 to 133. */
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
-- 
2.8.1

