From: Andi Kleen <ak@muc.de>
Subject: [PATCH] Convert i2o to compat_ioctl
Date: 18 Jan 2005 12:24:55 +0100
Message-ID: <20050118112455.GK43344@muc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:44559 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S261273AbVARLY4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 06:24:56 -0500
Date: Tue, 18 Jan 2005 12:24:55 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, Markus.Lidel@shadowconnect.com, linux-scsi@vger.kernel.org

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
 static spinlock_t i2o_config_lock;
 
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
+static long compat_i2o_cfg_ioctl(struct file *file, unsigned cmd, unsigned long arg)
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
+	.compat_ioctl = compat_i2o_cfg_ioctl,
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
