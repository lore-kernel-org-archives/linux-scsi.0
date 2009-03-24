From: stoyboyker@gmail.com
Subject: [PATCH 06/13] [scsi] changed ioctls to unlocked
Date: Tue, 24 Mar 2009 16:12:41 -0500
Message-ID: <1237929168-15341-7-git-send-email-stoyboyker@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:6868 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZCXVNR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 17:13:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

From: Stoyan Gaydarov <stoyboyker@gmail.com>

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 drivers/scsi/osst.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 0ea78d9..80e7e98 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -4856,9 +4856,10 @@ static int os_scsi_tape_close(struct inode * inode, struct file * filp)
 
 
 /* The ioctl command */
-static int osst_ioctl(struct inode * inode,struct file * file,
-	 unsigned int cmd_in, unsigned long arg)
+static long osst_ioctl(struct file * file, unsigned int cmd_in,
+	unsigned long arg)
 {
+	lock_kernel();
 	int		      i, cmd_nr, cmd_type, blk, retval = 0;
 	struct st_modedef   * STm;
 	struct st_partstat  * STps;
@@ -4867,8 +4868,10 @@ static int osst_ioctl(struct inode * inode,struct file * file,
 	char		    * name  = tape_name(STp);
 	void	    __user  * p     = (void __user *)arg;
 
-	if (mutex_lock_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock)) {
+		unlock_kernel();
 		return -ERESTARTSYS;
+	}
 
 #if DEBUG
 	if (debugging && !STp->in_use) {
@@ -5187,6 +5190,7 @@ out:
 
 	mutex_unlock(&STp->lock);
 
+	unlock_kernel();
 	return retval;
 }
 
@@ -5542,7 +5546,7 @@ static const struct file_operations osst_fops = {
 	.owner =        THIS_MODULE,
 	.read =         osst_read,
 	.write =        osst_write,
-	.ioctl =        osst_ioctl,
+	.unlocked_ioctl =        osst_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = osst_compat_ioctl,
 #endif
-- 
1.6.2

