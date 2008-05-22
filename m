From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] megaraid_mm: Remove BKL
Date: Thu, 22 May 2008 22:43:43 +0100
Message-ID: <20080522224343.34ee64d6@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53898 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760898AbYEVV4M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2008 17:56:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The mraid_mm_ioctl method is called by the compat handler without the BKL
so we drop the BKL from the normal path. 

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 0ad215e..1461e7e 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -20,7 +20,7 @@
 
 // Entry points for char node driver
 static int mraid_mm_open(struct inode *, struct file *);
-static int mraid_mm_ioctl(struct inode *, struct file *, uint, unsigned long);
+static long mraid_mm_ioctl(struct file *, uint, unsigned long);
 
 
 // routines to convert to and from the old the format
@@ -68,7 +68,7 @@ static wait_queue_head_t wait_q;
 
 static const struct file_operations lsi_fops = {
 	.open	= mraid_mm_open,
-	.ioctl	= mraid_mm_ioctl,
+	.unlocked_ioctl	= mraid_mm_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = mraid_mm_compat_ioctl,
 #endif
@@ -101,14 +101,13 @@ mraid_mm_open(struct inode *inode, struct file *filep)
 
 /**
  * mraid_mm_ioctl - module entry-point for ioctls
- * @inode	: inode (ignored)
  * @filep	: file operations pointer (ignored)
  * @cmd		: ioctl command
  * @arg		: user ioctl packet
  */
-static int
-mraid_mm_ioctl(struct inode *inode, struct file *filep, unsigned int cmd,
-							unsigned long arg)
+ 
+static long
+mraid_mm_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	uioc_t		*kioc;
 	char		signature[EXT_IOCTL_SIGN_SZ]	= {0};
@@ -1222,7 +1221,7 @@ mraid_mm_compat_ioctl(struct file *filep, unsigned int cmd,
 {
 	int err;
 
-	err = mraid_mm_ioctl(NULL, filep, cmd, arg);
+	err = mraid_mm_ioctl(filep, cmd, arg);
 
 	return err;
 }
