From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Convert i2o to compat_ioctl
Date: Tue, 5 Apr 2005 13:24:39 +0100
Message-ID: <20050405122439.GA31778@infradead.org>
References: <20050118112455.GK43344@muc.de> <20050331194118.GA24242@infradead.org> <424D2082.4010209@shadowconnect.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:8674 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261710AbVDEMZV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Apr 2005 08:25:21 -0400
Content-Disposition: inline
In-Reply-To: <424D2082.4010209@shadowconnect.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: Andi Kleen <ak@muc.de>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Fri, Apr 01, 2005 at 12:20:50PM +0200, Markus Lidel wrote:
> Hello,
> 
> Christoph Hellwig wrote:
> >Markus, is this patch actually okay?  I just talked to Andi about the
> >ioctl32 issues and he told me about this patch.
> 
> OK, i don't own a 64-bit system, so i couldn't test it out :-(
> 
> The only thing i would change is rename compat_i2o_cfg_ioctl() into 
> i2o_cfg_compat_ioctl() because all I2O specific functions begin with 
> "i2o_<osm-name>_"...

Okay, here's Andi's patch with that trivial change applied:

---- snip ----

Convert I2O to new compat_ioctl entry points

Also broken design in its compat handlers - CONFIG_COMPAT doesn't 
mean that there should be no native ioctls.

Signed-off-by: Andi Kleen <ak@muc.de>

diff -u linux-2.6.11-rc1-bk4/drivers/message/i2o/i2o_config.c-o linux-2.6.11-rc1-bk4/drivers/message/i2o/i2o_config.c
--- linux-2.6.11-rc1-bk4/drivers/message/i2o/i2o_config.c-o	2005-01-17 10:39:40.000000000 +0100
+++ linux-2.6.11-rc1-bk4/drivers/message/i2o/i2o_config.c	2005-01-18 06:27:24.000000000 +0100
@@ -54,6 +54,9 @@
 
 extern int i2o_parm_issue(struct i2o_device *, int, void *, int, void *, int);
 
+static int i2o_cfg_ioctl(struct inode *inode, struct file *fp, unsigned int cmd,
+			 unsigned long arg);
+
 static spinlock_t i2o_config_lock;::::::::::::::::::::::::::::::::::;
 
 #define MODINC(x,y) ((x) = ((x) + 1) % (y))
@@ -538,8 +541,7 @@
 }
 
 #ifdef CONFIG_COMPAT
-static int i2o_cfg_passthru32(unsigned fd, unsigned cmnd, unsigned long arg,
-			      struct file *file)
+static int i2o_cfg_passthru32(struct file *file, unsigned cmnd, unsigned long arg)
 {
 	struct i2o_cmd_passthru32 __user *cmd;
 	struct i2o_controller *c;
@@ -752,7 +754,26 @@
 	return rcode;
 }
 
-#else
+static long i2o_cfg_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
+{
+	int ret;
+	lock_kernel();		
+	switch (cmd) { 
+	case I2OGETIOPS:
+		ret = i2o_cfg_ioctl(NULL, file, cmd, arg);
+		break;
+	case I2OPASSTHRU32:
+		ret = i2o_cfg_passthru32(file, cmd, arg);
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
+		break;
+	}
+	unlock_kernel();
+	return ret;
+}
+
+#endif
 
 static int i2o_cfg_passthru(unsigned long arg)
 {
@@ -958,7 +979,6 @@
 	kfree(reply);
 	return rcode;
 }
-#endif
 
 /*
  * IOCTL Handler
@@ -1013,11 +1033,9 @@
 		ret = i2o_cfg_evt_get(arg, fp);
 		break;
 
-#ifndef CONFIG_COMPAT
 	case I2OPASSTHRU:
 		ret = i2o_cfg_passthru(arg);
 		break;
-#endif
 
 	default:
 		osm_debug("unknown ioctl called!\n");
@@ -1105,6 +1123,9 @@
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.ioctl = i2o_cfg_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = i2o_cfg_compat_ioctl,
+#endif
 	.open = cfg_open,
 	.release = cfg_release,
 	.fasync = cfg_fasync,
@@ -1134,19 +1155,11 @@
 		misc_deregister(&i2o_miscdev);
 		return -EBUSY;
 	}
-#ifdef CONFIG_COMPAT
-	register_ioctl32_conversion(I2OPASSTHRU32, i2o_cfg_passthru32);
-	register_ioctl32_conversion(I2OGETIOPS, (void *)sys_ioctl);
-#endif
 	return 0;
 }
 
 static void i2o_config_exit(void)
 {
-#ifdef CONFIG_COMPAT
-	unregister_ioctl32_conversion(I2OPASSTHRU32);
-	unregister_ioctl32_conversion(I2OGETIOPS);
-#endif
 	misc_deregister(&i2o_miscdev);
 	i2o_driver_unregister(&i2o_config_driver);
 }
