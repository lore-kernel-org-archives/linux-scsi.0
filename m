From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix warnings in new compat code for scsi
Date: Thu, 03 Feb 2005 20:39:22 -0600
Message-ID: <1107484762.5502.41.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:35774 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261705AbVBDCkE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Feb 2005 21:40:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

I just got around to applying and testing this.  I needed the attached
to get around the compile warnings it gave me on ia64

I've got to say, it doesn't look pretty to have the block layer
compat_ioctl returning long but the scsi one returning int; likewise
with the void __user *arg vs unsigned long arg.

James

===== drivers/scsi/osst.c 1.68 vs edited =====
--- 1.68/drivers/scsi/osst.c	2005-01-17 22:14:59 -06:00
+++ edited/drivers/scsi/osst.c	2005-02-03 20:16:18 -06:00
@@ -5129,7 +5129,7 @@
 	int ret = -ENOIOCTLCMD;
 	if (sdev->host->hostt->compat_ioctl) {
 
-		ret = sdev->host->hostt->compat_ioctl(sdev, cmd_in, arg);
+		ret = sdev->host->hostt->compat_ioctl(sdev, cmd_in, (void __user *)arg);
 
 	}
 	return ret;
===== drivers/scsi/st.c 1.99 vs edited =====
--- 1.99/drivers/scsi/st.c	2005-01-17 21:50:09 -06:00
+++ edited/drivers/scsi/st.c	2005-02-03 20:16:29 -06:00
@@ -3427,14 +3427,14 @@
 }
 
 #ifdef CONFIG_COMPAT
-static int st_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static long st_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct scsi_tape *STp = file->private_data;
 	struct scsi_device *sdev = STp->device;
 	int ret = -ENOIOCTLCMD;
 	if (sdev->host->hostt->compat_ioctl) { 
 
-		ret = sdev->host->hostt->compat_ioctl(sdev, cmd, arg);
+		ret = sdev->host->hostt->compat_ioctl(sdev, cmd, (void __user *)arg);
 
 	}
 	return ret;
===== drivers/scsi/aacraid/linit.c 1.45 vs edited =====
--- 1.45/drivers/scsi/aacraid/linit.c	2005-01-18 00:58:31 -06:00
+++ edited/drivers/scsi/aacraid/linit.c	2005-02-03 20:21:16 -06:00
@@ -514,10 +514,10 @@
 	return ret;
 }
 
-static long aac_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
+static int aac_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
-	return aac_compat_do_ioctl(dev, cmd, arg);
+	return aac_compat_do_ioctl(dev, cmd, (unsigned long)arg);
 }
 
 static long aac_compat_cfg_ioctl(struct file *file, unsigned cmd, unsigned long arg)


