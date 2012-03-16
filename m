From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/7] block: ioctl to zero block ranges
Date: Fri, 16 Mar 2012 14:43:16 -0400
Message-ID: <1331923399-30987-5-git-send-email-martin.petersen@oracle.com>
References: <1331923399-30987-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51631 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab2CPSnh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Mar 2012 14:43:37 -0400
In-Reply-To: <1331923399-30987-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, jbottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

Introduce a BLKZEROOUT ioctl which can be used to clear block ranges by
way of blkdev_issue_zeroout().

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 block/ioctl.c      |   27 +++++++++++++++++++++++++++
 include/linux/fs.h |    1 +
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index ba15b2d..0c6e633 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -132,6 +132,22 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 	return blkdev_issue_discard(bdev, start, len, GFP_KERNEL, flags);
 }
 
+static int blk_ioctl_zeroout(struct block_device *bdev, uint64_t start,
+			     uint64_t len)
+{
+	if (start & 511)
+		return -EINVAL;
+	if (len & 511)
+		return -EINVAL;
+	start >>= 9;
+	len >>= 9;
+
+	if (start + len > (i_size_read(bdev->bd_inode) >> 9))
+		return -EINVAL;
+
+	return blkdev_issue_zeroout(bdev, start, len, GFP_KERNEL);
+}
+
 static int put_ushort(unsigned long arg, unsigned short val)
 {
 	return put_user(val, (unsigned short __user *)arg);
@@ -247,6 +263,17 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		return blk_ioctl_discard(bdev, range[0], range[1],
 					 cmd == BLKSECDISCARD);
 	}
+	case BLKZEROOUT: {
+		uint64_t range[2];
+
+		if (!(mode & FMODE_WRITE))
+			return -EBADF;
+
+		if (copy_from_user(range, (void __user *)arg, sizeof(range)))
+			return -EFAULT;
+
+		return blk_ioctl_zeroout(bdev, range[0], range[1]);
+	}
 
 	case HDIO_GETGEO: {
 		struct hd_geometry geo;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 386da09..e918ef7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -320,6 +320,7 @@ struct inodes_stat_t {
 #define BLKDISCARDZEROES _IO(0x12,124)
 #define BLKSECDISCARD _IO(0x12,125)
 #define BLKROTATIONAL _IO(0x12,126)
+#define BLKZEROOUT _IO(0x12,127)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
-- 
1.7.7.6

