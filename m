From: Andi Kleen <ak@muc.de>
Subject: [PATCH] Convert megaraid2 to compat_ioctl
Date: 18 Jan 2005 12:17:13 +0100
Message-ID: <20050118111713.GI43344@muc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:30217 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S261209AbVARLRN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 06:17:13 -0500
Date: Tue, 18 Jan 2005 12:17:13 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Convert megaraid2 driver to new compat_ioctl entry points.

I don't have easy access to hardware, so only compile tested.

Signed-off-by: Andi Kleen <ak@muc.de>

diff -u linux-2.6.11-rc1-bk4/drivers/scsi/megaraid/megaraid_mm.c-o linux-2.6.11-rc1-bk4/drivers/scsi/megaraid/megaraid_mm.c
--- linux-2.6.11-rc1-bk4/drivers/scsi/megaraid/megaraid_mm.c-o	2005-01-04 12:13:06.000000000 +0100
+++ linux-2.6.11-rc1-bk4/drivers/scsi/megaraid/megaraid_mm.c	2005-01-18 06:28:34.000000000 +0100
@@ -16,6 +16,7 @@
  */
 
 #include "megaraid_mm.h"
+#include <linux/smp_lock.h>
 
 
 // Entry points for char node driver
@@ -43,8 +44,7 @@
 static void mraid_mm_teardown_dma_pools(mraid_mmadp_t *);
 
 #ifdef CONFIG_COMPAT
-static int mraid_mm_compat_ioctl(unsigned int, unsigned int, unsigned long,
-		struct file *);
+static long mraid_mm_compat_ioctl(struct file *, unsigned int, unsigned long);
 #endif
 
 MODULE_AUTHOR("LSI Logic Corporation");
@@ -70,6 +70,9 @@
 static struct file_operations lsi_fops = {
 	.open	= mraid_mm_open,
 	.ioctl	= mraid_mm_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = mraid_mm_compat_ioctl,
+#endif
 	.owner	= THIS_MODULE,
 };
 
@@ -1180,8 +1183,6 @@
 
 	INIT_LIST_HEAD(&adapters_list_g);
 
-	register_ioctl32_conversion(MEGAIOCCMD, mraid_mm_compat_ioctl);
-
 	return 0;
 }
 
@@ -1190,13 +1191,15 @@
  * mraid_mm_compat_ioctl	: 32bit to 64bit ioctl conversion routine
  */
 #ifdef CONFIG_COMPAT
-static int
-mraid_mm_compat_ioctl(unsigned int fd, unsigned int cmd,
-			unsigned long arg, struct file *filep)
-{
-	struct inode *inode = filep->f_dentry->d_inode;
-
-	return mraid_mm_ioctl(inode, filep, cmd, arg);
+static long
+mraid_mm_compat_ioctl(struct file *filep, unsigned int cmd,
+		      unsigned long arg)
+{
+	int err;
+	lock_kernel();
+	err = mraid_mm_ioctl(NULL, filep, cmd, arg);
+	unlock_kernel();
+	return err;
 }
 #endif
 
@@ -1209,7 +1212,6 @@
 	con_log(CL_DLEVEL1 , ("exiting common mod\n"));
 
 	unregister_chrdev(majorno, "megadev");
-	unregister_ioctl32_conversion(MEGAIOCCMD);
 }
 
 module_init(mraid_mm_init);
