From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] sd: fix up ->compat_ioctl
Date: Thu, 30 Oct 2014 10:27:06 +0100
Message-ID: <1414661229-15199-4-git-send-email-hch@lst.de>
References: <1414661229-15199-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50942 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758380AbaJ3J05 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 05:26:57 -0400
In-Reply-To: <1414661229-15199-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

No need to verify the passthrough ioctls, the real handler will
take care of that.  Also make sure not to block for resets on
O_NONBLOCK fds.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 61e50ae..baf5cf4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1541,31 +1541,19 @@ static int sd_compat_ioctl(struct block_device *bdev, fmode_t mode,
 			   unsigned int cmd, unsigned long arg)
 {
 	struct scsi_device *sdev = scsi_disk(bdev->bd_disk)->device;
-	int ret;
-
-	ret = scsi_verify_blk_ioctl(bdev, cmd);
-	if (ret < 0)
-		return ret;
+	int error;
 
-	/*
-	 * If we are in the middle of error recovery, don't let anyone
-	 * else try and use this device.  Also, if error recovery fails, it
-	 * may try and take the device offline, in which case all further
-	 * access to the device is prohibited.
-	 */
-	if (!scsi_block_when_processing_errors(sdev))
-		return -ENODEV;
+	error = scsi_ioctl_block_when_processing_errors(sdev, cmd,
+			mode & FMODE_NDELAY);
+	if (error)
+		return error;
 	       
-	if (sdev->host->hostt->compat_ioctl) {
-		ret = sdev->host->hostt->compat_ioctl(sdev, cmd, (void __user *)arg);
-
-		return ret;
-	}
-
 	/* 
 	 * Let the static ioctl translation table take care of it.
 	 */
-	return -ENOIOCTLCMD; 
+	if (!sdev->host->hostt->compat_ioctl)
+		return -ENOIOCTLCMD; 
+	return sdev->host->hostt->compat_ioctl(sdev, cmd, (void __user *)arg);
 }
 #endif
 
-- 
1.9.1

