From: Andi Kleen <ak@muc.de>
Subject: [PATCH] Add compat_ioctl to SD
Date: 18 Jan 2005 12:12:02 +0100
Message-ID: <20050118111202.GF43344@muc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:44806 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S261269AbVARLMD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 06:12:03 -0500
Date: Tue, 18 Jan 2005 12:12:02 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org


Add compat_ioctl entry point to SD

Requires the compat_ioctl for block devices patch I sent earlier
to linux-kernel.

Signed-off-by: Andi Kleen <ak@muc.de>

diff -u linux-2.6.11-rc1-bk4/drivers/scsi/sd.c-o linux-2.6.11-rc1-bk4/drivers/scsi/sd.c
--- linux-2.6.11-rc1-bk4/drivers/scsi/sd.c-o	2005-01-17 10:39:40.000000000 +0100
+++ linux-2.6.11-rc1-bk4/drivers/scsi/sd.c	2005-01-18 04:55:17.000000000 +0100
@@ -738,11 +738,50 @@
 	sd_revalidate_disk(sdkp->disk);
 }
 
+
+#ifdef CONFIG_COMPAT
+/* 
+ * This gets directly called from VFS. When the ioctl 
+ * is not recognized we go back to the other translation paths. 
+ */
+static long sd_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct block_device *bdev = file->f_dentry->d_inode->i_bdev;
+	struct gendisk *disk = bdev->bd_disk;
+	struct scsi_device *sdev = scsi_disk(disk)->device;
+
+	/*
+	 * If we are in the middle of error recovery, don't let anyone
+	 * else try and use this device.  Also, if error recovery fails, it
+	 * may try and take the device offline, in which case all further
+	 * access to the device is prohibited.
+	 */
+	if (!scsi_block_when_processing_errors(sdev))
+		return -ENODEV;
+	       
+	if (sdev->host->hostt->compat_ioctl) {
+		int ret;
+
+		ret = sdev->host->hostt->compat_ioctl(sdev, cmd, (void __user *)arg);
+
+		return ret;
+	}
+
+	/* 
+	 * Let the static ioctl translation table take care of it.
+	 */
+	return -ENOIOCTLCMD; 
+}
+#endif
+
 static struct block_device_operations sd_fops = {
 	.owner			= THIS_MODULE,
 	.open			= sd_open,
 	.release		= sd_release,
 	.ioctl			= sd_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl		= sd_compat_ioctl,
+#endif
 	.media_changed		= sd_media_changed,
 	.revalidate_disk	= sd_revalidate_disk,
 };
