From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/6] block: Copy offload ioctl
Date: Wed, 28 May 2014 23:52:43 -0400
Message-ID: <1401335565-29865-5-git-send-email-martin.petersen@oracle.com>
References: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38850 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbaE2Dwt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 23:52:49 -0400
In-Reply-To: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Add an ioctl which can be used to clone a block range within a single
block device. This is useful for testing the copy offload code.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/ioctl.c           | 35 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h |  1 +
 2 files changed, 36 insertions(+)

diff --git a/block/ioctl.c b/block/ioctl.c
index 7d5c3b20af45..5efb6e666f18 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -201,6 +201,29 @@ static int blk_ioctl_zeroout(struct block_device *bdev, uint64_t start,
 	return blkdev_issue_zeroout(bdev, start, len, GFP_KERNEL);
 }
 
+static int blk_ioctl_copy(struct block_device *bdev, uint64_t src_offset,
+			  uint64_t dst_offset, uint64_t len)
+{
+	if (src_offset & 511)
+		return -EINVAL;
+	if (dst_offset & 511)
+		return -EINVAL;
+	if (len & 511)
+		return -EINVAL;
+	src_offset >>= 9;
+	dst_offset >>= 9;
+	len >>= 9;
+
+	if (src_offset + len > (i_size_read(bdev->bd_inode) >> 9))
+		return -EINVAL;
+
+	if (dst_offset + len > (i_size_read(bdev->bd_inode) >> 9))
+		return -EINVAL;
+
+	return blkdev_issue_copy(bdev, src_offset, bdev, dst_offset, len,
+				 GFP_KERNEL);
+}
+
 static int put_ushort(unsigned long arg, unsigned short val)
 {
 	return put_user(val, (unsigned short __user *)arg);
@@ -328,6 +351,18 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		return blk_ioctl_zeroout(bdev, range[0], range[1]);
 	}
 
+	case BLKCOPY: {
+		uint64_t range[3];
+
+		if (!(mode & FMODE_WRITE))
+			return -EBADF;
+
+		if (copy_from_user(range, (void __user *)arg, sizeof(range)))
+			return -EFAULT;
+
+		return blk_ioctl_copy(bdev, range[0], range[1], range[2]);
+	}
+
 	case HDIO_GETGEO: {
 		struct hd_geometry geo;
 
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index ca1a11bb4443..195c2c4cbacc 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -149,6 +149,7 @@ struct inodes_stat_t {
 #define BLKSECDISCARD _IO(0x12,125)
 #define BLKROTATIONAL _IO(0x12,126)
 #define BLKZEROOUT _IO(0x12,127)
+#define BLKCOPY _IO(0x12,128)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
-- 
1.9.0

