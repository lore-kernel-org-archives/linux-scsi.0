From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH 07/10] sg: protect sdp->exclude
Date: Thu, 12 Apr 2012 17:34:19 -0400
Message-ID: <20120412213418.GG17388@logfs.org>
References: <20120412213217.GA17388@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:48500 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964888Ab2DLXaz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2012 19:30:55 -0400
Content-Disposition: inline
In-Reply-To: <20120412213217.GA17388@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

sdp->exclude was previously protected by the BKL.  The sg_mutex, which
replaced the BKL, only semi-protected it, as it was missing from
sg_release() and sg_proc_seq_show_debug().  Take an explicit spinlock
for it.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/sg.c |   36 +++++++++++++++++++++++++++++-------
 1 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 758e7b4..a70018e 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -105,6 +105,7 @@ static int sg_add(struct device *, struct class_interface *);
 static void sg_remove(struct device *, struct class_interface *);
 
 static DEFINE_MUTEX(sg_mutex);
+static DEFINE_SPINLOCK(sg_open_exclusive_lock);
 
 static DEFINE_IDR(sg_index_idr);
 static DEFINE_RWLOCK(sg_index_lock);	/* Also used to lock
@@ -173,7 +174,8 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 	u32 index;		/* device index number */
 	struct list_head sfds;
 	volatile char detached;	/* 0->attached, 1->detached pending removal */
-	volatile char exclude;	/* opened for exclusive access */
+	/* exclude protected by sg_open_exclusive_lock */
+	char exclude;		/* opened for exclusive access */
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
 	struct gendisk *disk;
 	struct cdev * cdev;	/* char_dev [sysfs: /sys/cdev/major/sg<n>] */
@@ -221,6 +223,26 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 	return blk_verify_command(cmd, filp->f_mode & FMODE_WRITE);
 }
 
+static int get_exclude(Sg_device *sdp)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
+	ret = sdp->exclude;
+	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
+	return ret;
+}
+
+static void set_exclude(Sg_device *sdp, char val)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
+	sdp->exclude = val;
+	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
+}
+
 static int
 sg_open(struct inode *inode, struct file *filp)
 {
@@ -269,17 +291,17 @@ sg_open(struct inode *inode, struct file *filp)
 			goto error_out;
 		}
 		res = wait_event_interruptible(sdp->o_excl_wait,
-					   ((!list_empty(&sdp->sfds) || sdp->exclude) ? 0 : (sdp->exclude = 1)));
+					   ((!list_empty(&sdp->sfds) || get_exclude(sdp)) ? 0 : set_exclude(sdp, 1), 1));
 		if (res) {
 			retval = res;	/* -ERESTARTSYS because signal hit process */
 			goto error_out;
 		}
-	} else if (sdp->exclude) {	/* some other fd has an exclusive lock on dev */
+	} else if (get_exclude(sdp)) {	/* some other fd has an exclusive lock on dev */
 		if (flags & O_NONBLOCK) {
 			retval = -EBUSY;
 			goto error_out;
 		}
-		res = wait_event_interruptible(sdp->o_excl_wait, !sdp->exclude);
+		res = wait_event_interruptible(sdp->o_excl_wait, !get_exclude(sdp));
 		if (res) {
 			retval = res;	/* -ERESTARTSYS because signal hit process */
 			goto error_out;
@@ -298,7 +320,7 @@ sg_open(struct inode *inode, struct file *filp)
 		filp->private_data = sfp;
 	else {
 		if (flags & O_EXCL) {
-			sdp->exclude = 0;	/* undo if error */
+			set_exclude(sdp, 0);	/* undo if error */
 			wake_up_interruptible(&sdp->o_excl_wait);
 		}
 		retval = -ENOMEM;
@@ -329,7 +351,7 @@ sg_release(struct inode *inode, struct file *filp)
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 
-	sdp->exclude = 0;
+	set_exclude(sdp, 0);
 	wake_up_interruptible(&sdp->o_excl_wait);
 
 	scsi_autopm_put_device(sdp->device);
@@ -2602,7 +2624,7 @@ static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
 			     scsidp->lun,
 			     scsidp->host->hostt->emulated);
 		seq_printf(s, " sg_tablesize=%d excl=%d\n",
-			   sdp->sg_tablesize, sdp->exclude);
+			   sdp->sg_tablesize, get_exclude(sdp));
 		sg_proc_debug_helper(s, sdp);
 	}
 	read_unlock_irqrestore(&sg_index_lock, iflags);
-- 
1.7.9.1

