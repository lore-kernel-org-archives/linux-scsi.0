From: akpm@osdl.org
Subject: [patch 2/3] scsi ch.c build fix
Date: Fri, 04 Mar 2005 04:36:17 -0800
Message-ID: <200503041236.j24CacqC026412@shell0.pdx.osdl.net>
Received: from fire.osdl.org ([65.172.181.4]:4328 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262946AbVCDMgx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2005 07:36:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org



- workaround for gcc-2.95 macro expansion bug

- fix a warning:

  drivers/scsi/ch.c:100: warning: `ch_ioctl_compat' declared `static' but never defined


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 25-akpm/drivers/scsi/ch.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ch.c~scsi-ch-build-fix drivers/scsi/ch.c
--- 25/drivers/scsi/ch.c~scsi-ch-build-fix	2005-02-19 02:48:16.000000000 -0800
+++ 25-akpm/drivers/scsi/ch.c	2005-02-19 02:48:54.000000000 -0800
@@ -82,7 +82,7 @@ static char *vendor_labels[CH_TYPES-4] =
 // module_param_string_array(vendor_labels, NULL, 0444);
 
 #define dprintk(fmt, arg...)    if (debug) \
-        printk(KERN_DEBUG "%s: " fmt, ch->name, ##arg)
+        printk(KERN_DEBUG "%s: " fmt, ch->name , ##arg)
 #define vprintk(fmt, arg...)    if (verbose) \
         printk(KERN_INFO "%s: " fmt, ch->name, ##arg)
 
@@ -96,8 +96,10 @@ static int  ch_open(struct inode * inode
 static int  ch_release(struct inode * inode, struct file * filp);
 static int  ch_ioctl(struct inode * inode, struct file * filp,
 		     unsigned int cmd, unsigned long arg);
+#ifdef CONFIG_COMPAT
 static long ch_ioctl_compat(struct file * filp,
 			    unsigned int cmd, unsigned long arg);
+#endif
 
 typedef struct {
 	struct list_head    list;
_
