From: Andi Kleen <ak@muc.de>
Subject: Re: [PATCH] Add compat_ioctl to SG
Date: 18 Jan 2005 12:43:50 +0100
Message-ID: <20050118114350.GM43344@muc.de>
References: <20050118110743.GD43344@muc.de> <41ECF499.9040501@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:20498 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S261273AbVARLnu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 06:43:50 -0500
Date: Tue, 18 Jan 2005 12:43:50 +0100
Content-Disposition: inline
In-Reply-To: <41ECF499.9040501@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Tue, Jan 18, 2005 at 09:35:53PM +1000, Douglas Gilbert wrote:
> Andi Kleen wrote:
> <snip>
> >@@ -1343,6 +1366,9 @@
> > 	.write = sg_write,
> > 	.poll = sg_poll,
> > 	.ioctl = sg_ioctl,
> >+#ifdef CONFIG_COMPAT
> >+	.ioctl = sg_compat_ioctl,
> >+#endif
> 
> Andi,
> Two initializations of ".ioctl" looks wrongs.
> Comparing with the patch to sd should that be:
>  +       .compat_ioctl = sg_compat_ioctl,

Yep, you're right. Thanks for catching it.  
#$@#!-compiler doesn't warn about that. Here's a corrected patch.

-Andi

Add compat_ioctl to SG driver

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
+	.compat_ioctl = sg_compat_ioctl,
+#endif
 	.open = sg_open,
 	.mmap = sg_mmap,
 	.release = sg_release,
