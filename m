From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: [PATCH v4 2/4] [SCSI] sg: no need sg_open_exclusive_lock
Date: Wed, 17 Jul 2013 23:34:04 +0800
Message-ID: <1374075246-22923-3-git-send-email-vaughan.cao@oracle.com>
References: <20130715203730.GA21804@logfs.org>
 <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: joern@logfs.org
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, vaughan.cao@oracle.com
List-Id: linux-scsi@vger.kernel.org

Open exclusive check is protected by o_sem, no need sg_open_exclusive_lock.
@exclude is used to record which type of rwsem we are holding.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 drivers/scsi/sg.c | 34 +++++-----------------------------
 1 file changed, 5 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index edc395a..671b760 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -103,8 +103,6 @@ static int scatter_elem_sz_prev = SG_SCATTER_SZ;
 static int sg_add(struct device *, struct class_interface *);
 static void sg_remove(struct device *, struct class_interface *);
 
-static DEFINE_SPINLOCK(sg_open_exclusive_lock);
-
 static DEFINE_IDR(sg_index_idr);
 static DEFINE_RWLOCK(sg_index_lock);	/* Also used to lock
 							   file descriptor list for device */
@@ -174,7 +172,6 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 	struct list_head sfds;
 	struct rw_semaphore o_sem;	/* exclude open should hold this rwsem */
 	volatile char detached;	/* 0->attached, 1->detached pending removal */
-	/* exclude protected by sg_open_exclusive_lock */
 	char exclude;		/* opened for exclusive access */
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
 	struct gendisk *disk;
@@ -224,27 +221,6 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 	return blk_verify_command(q, cmd, filp->f_mode & FMODE_WRITE);
 }
 
-static int get_exclude(Sg_device *sdp)
-{
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
-	ret = sdp->exclude;
-	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
-	return ret;
-}
-
-static int set_exclude(Sg_device *sdp, char val)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
-	sdp->exclude = val;
-	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
-	return val;
-}
-
 static int sfds_list_empty(Sg_device *sdp)
 {
 	unsigned long flags;
@@ -317,7 +293,7 @@ sg_open(struct inode *inode, struct file *filp)
 	}
 	/* Since write lock is held, no need to check sfd_list */
 	if (flags & O_EXCL)
-		set_exclude(sdp, 1);
+		sdp->exclude = 1;	/* used by release lock */
 
 	if (sdp->detached) {
 		retval = -ENODEV;
@@ -339,7 +315,7 @@ sg_open(struct inode *inode, struct file *filp)
 	if (retval) {
 sem_out:
 		if (flags & O_EXCL) {
-			set_exclude(sdp, 0);	/* undo if error */
+			sdp->exclude = 0;	/* undo if error */
 			up_write(&sdp->o_sem);
 		} else
 			up_read(&sdp->o_sem);
@@ -366,8 +342,8 @@ sg_release(struct inode *inode, struct file *filp)
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 
-	excl = get_exclude(sdp);
-	set_exclude(sdp, 0);
+	excl = sdp->exclude;
+	sdp->exclude = 0;
 	if (excl)
 		up_write(&sdp->o_sem);
 	else
@@ -2637,7 +2613,7 @@ static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
 			     scsidp->lun,
 			     scsidp->host->hostt->emulated);
 		seq_printf(s, " sg_tablesize=%d excl=%d\n",
-			   sdp->sg_tablesize, get_exclude(sdp));
+			   sdp->sg_tablesize, sdp->exclude);
 		sg_proc_debug_helper(s, sdp);
 	}
 	read_unlock_irqrestore(&sg_index_lock, iflags);
-- 
1.7.11.7
