From: Andi Kleen <ak@muc.de>
Subject: [PATCH] Add compat_ioctl to SG
Date: 18 Jan 2005 12:07:43 +0100
Message-ID: <20050118110743.GD43344@muc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:44556 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S261269AbVARLHs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 06:07:48 -0500
Date: Tue, 18 Jan 2005 12:07:43 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, dgilbert@interlog.com

Add compat_ioctl forwarder to SG. 

Signed-off-by: Andi Kleen <ak@muc.de>

diff -u linux-2.6.11-rc1-bk4/drivers/scsi/sg.c-o linux-2.6.11-rc1-bk4/drivers/scsi/sg.c
--- linux-2.6.11-rc1-bk4/drivers/scsi/sg.c-o	2005-01-04 12:13:07.000000000 +0100
+++ linux-2.6.11-rc1-bk4/drivers/scsi/sg.c	2005-01-18 05:24:28.000000000 +0100
@@ -1037,6 +1037,29 @@
 	}
 }
 
+#ifdef CONFIG_COMPAT
+static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
+{
+	Sg_device *sdp;
+	Sg_fd *sfp;
+	struct scsi_device *sdev;
+
+	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+		return -ENXIO;
+
+	sdev = sdp->device;
+	if (sdev->host->hostt->compat_ioctl) { 
+		int ret;
+
+		ret = sdev->host->hostt->compat_ioctl(sdev, cmd_in, (void __user *)arg);
+
+		return ret;
+	}
+	
+	return -ENOIOCTLCMD;
+}
+#endif
+
 static unsigned int
 sg_poll(struct file *filp, poll_table * wait)
 {
@@ -1343,6 +1366,9 @@
 	.write = sg_write,
 	.poll = sg_poll,
 	.ioctl = sg_ioctl,
+#ifdef CONFIG_COMPAT
+	.ioctl = sg_compat_ioctl,
+#endif
 	.open = sg_open,
 	.mmap = sg_mmap,
 	.release = sg_release,
