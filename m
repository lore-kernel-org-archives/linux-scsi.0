From: Andi Kleen <ak@muc.de>
Subject: [PATCH] Add compat_ioctl to st
Date: 18 Jan 2005 12:06:13 +0100
Message-ID: <20050118110613.GC43344@muc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:7180 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S261265AbVARLGO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 06:06:14 -0500
Date: Tue, 18 Jan 2005 12:06:13 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org

Call new compat_ioctl host vector from tape driver

Signed-off-by: Andi Kleen <ak@muc.de>

diff -u linux-2.6.11-rc1-bk4/drivers/scsi/scsi_ioctl.c-o linux-2.6.11-rc1-bk4/drivers/scsi/scsi_ioctl.c
diff -u linux-2.6.11-rc1-bk4/drivers/scsi/st.c-o linux-2.6.11-rc1-bk4/drivers/scsi/st.c
--- linux-2.6.11-rc1-bk4/drivers/scsi/st.c-o	2005-01-04 12:13:07.000000000 +0100
+++ linux-2.6.11-rc1-bk4/drivers/scsi/st.c	2005-01-18 04:50:09.000000000 +0100
@@ -3425,6 +3425,22 @@
 	up(&STp->lock);
 	return retval;
 }
+
+#ifdef CONFIG_COMPAT
+static int st_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct scsi_tape *STp = file->private_data;
+	struct scsi_device *sdev = STp->device;
+	int ret = -ENOIOCTLCMD;
+	if (sdev->host->hostt->compat_ioctl) { 
+
+		ret = sdev->host->hostt->compat_ioctl(sdev, cmd, arg);
+
+	}
+	return ret;
+}
+#endif
+
 

 
 /* Try to allocate a new tape buffer. Calling function must not hold
@@ -3716,6 +3732,9 @@
 	.read =		st_read,
 	.write =	st_write,
 	.ioctl =	st_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = st_compat_ioctl,
+#endif
 	.open =		st_open,
 	.flush =	st_flush,
 	.release =	st_release,
