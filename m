From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH 09/10] sg: remove sg_mutex
Date: Thu, 12 Apr 2012 17:35:05 -0400
Message-ID: <20120412213505.GI17388@logfs.org>
References: <20120412213217.GA17388@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:48506 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966272Ab2DLXbl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2012 19:31:41 -0400
Content-Disposition: inline
In-Reply-To: <20120412213217.GA17388@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

With the exception of the detached field, sg_mutex no longer adds any
locking.  detached handling has been broken before and is still broken
and this patch does not seem to make things worse than they were to
begin with.

However, I have observed cases of tasks being blocked for >200s waiting
for sg_mutex.  So the removal clearly adds value for very little cost.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/sg.c |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index a40b814..0c646f2 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -104,7 +104,6 @@ static int scatter_elem_sz_prev = SG_SCATTER_SZ;
 static int sg_add(struct device *, struct class_interface *);
 static void sg_remove(struct device *, struct class_interface *);
 
-static DEFINE_MUTEX(sg_mutex);
 static DEFINE_SPINLOCK(sg_open_exclusive_lock);
 
 static DEFINE_IDR(sg_index_idr);
@@ -267,7 +266,6 @@ sg_open(struct inode *inode, struct file *filp)
 	int res;
 	int retval;
 
-	mutex_lock(&sg_mutex);
 	nonseekable_open(inode, filp);
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
 	sdp = sg_get_dev(dev);
@@ -349,7 +347,6 @@ sdp_put:
 sg_put:
 	if (sdp)
 		sg_put_dev(sdp);
-	mutex_unlock(&sg_mutex);
 	return retval;
 }
 
@@ -807,7 +804,7 @@ static int srp_done(Sg_fd *sfp, Sg_request *srp)
 	return ret;
 }
 
-static int
+static long
 sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
 	void __user *p = (void __user *)arg;
@@ -1117,18 +1114,6 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 	}
 }
 
-static long
-sg_unlocked_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
-{
-	int ret;
-
-	mutex_lock(&sg_mutex);
-	ret = sg_ioctl(filp, cmd_in, arg);
-	mutex_unlock(&sg_mutex);
-
-	return ret;
-}
-
 #ifdef CONFIG_COMPAT
 static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
@@ -1372,7 +1357,7 @@ static const struct file_operations sg_fops = {
 	.read = sg_read,
 	.write = sg_write,
 	.poll = sg_poll,
-	.unlocked_ioctl = sg_unlocked_ioctl,
+	.unlocked_ioctl = sg_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = sg_compat_ioctl,
 #endif
-- 
1.7.9.1

