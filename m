From: Andi Kleen <ak@muc.de>
Subject: [PATCH] Add compat_ioctl to osst
Date: 18 Jan 2005 12:13:18 +0100
Message-ID: <20050118111318.GG43344@muc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:38414 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S261263AbVARLNT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 06:13:19 -0500
Date: Tue, 18 Jan 2005 12:13:18 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, osst@riede.org

Add compat_ioctl to osst

Signed-off-by: Andi Kleen <ak@muc.de>

diff -u linux-2.6.11-rc1-bk4/drivers/scsi/osst.c-o linux-2.6.11-rc1-bk4/drivers/scsi/osst.c
--- linux-2.6.11-rc1-bk4/drivers/scsi/osst.c-o	2005-01-17 10:39:40.000000000 +0100
+++ linux-2.6.11-rc1-bk4/drivers/scsi/osst.c	2005-01-18 05:14:59.000000000 +0100
@@ -5117,6 +5117,22 @@
 	return retval;
 }
 
+#ifdef CONFIG_COMPAT
+static long osst_compat_ioctl(struct file * file, unsigned int cmd_in, unsigned long arg)
+{
+	struct osst_tape *STp = file->private_data;
+	struct scsi_device *sdev = STp->device;
+	int ret = -ENOIOCTLCMD;
+	if (sdev->host->hostt->compat_ioctl) {
+
+		ret = sdev->host->hostt->compat_ioctl(sdev, cmd_in, arg);
+
+	}
+	return ret;
+}
+#endif
+
+
 

 /* Memory handling routines */
 
@@ -5452,6 +5468,9 @@
 	.read =         osst_read,
 	.write =        osst_write,
 	.ioctl =        osst_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = osst_compat_ioctl,
+#endif
 	.open =         os_scsi_tape_open,
 	.flush =        os_scsi_tape_flush,
 	.release =      os_scsi_tape_close,
