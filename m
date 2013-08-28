From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: [PATCH v6 3/4] sg: checking sdp->detached isn't protected when open
Date: Wed, 28 Aug 2013 18:07:51 +0800
Message-ID: <1377684472-7815-4-git-send-email-vaughan.cao@oracle.com>
References: <1377662419.2005.12.camel@dabdike>
 <1377684472-7815-1-git-send-email-vaughan.cao@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377684472-7815-1-git-send-email-vaughan.cao@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: joern@logfs.org, vaughan.cao@oracle.com, dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

@detached is set under the protection of sg_index_lock. Without getting the
lock, new sfp will be added during sg removal and there is no chance for it
to be picked out. So check with sg_index_lock held in sg_add_sfp().

Changes from v5:
 * remove sem_out label.
Changes from v4:
 * use ERR_PTR series instead of adding another parameter in sg_add_sfp

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 drivers/scsi/sg.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index dcbd95f..6bffe52 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -295,10 +295,6 @@ sg_open(struct inode *inode, struct file *filp)
 	if (flags & O_EXCL)
 		sdp->exclude = 1;	/* used by release lock */
 
-	if (sdp->detached) {
-		retval = -ENODEV;
-		goto sem_out;
-	}
 	if (sfds_list_empty(sdp)) {	/* no existing opens on this device */
 		sdp->sgdebug = 0;
 		q = sdp->device->request_queue;
@@ -309,16 +305,16 @@ sg_open(struct inode *inode, struct file *filp)
 		/* retval is already provably zero at this point because of the
 		 * check after retval = scsi_autopm_get_device(sdp->device))
 		 */
-	else
-		retval = -ENOMEM;
-
-	if (retval) {
-sem_out:
+	else {
+		retval = PTR_ERR(sfp);
 		if (flags & O_EXCL) {
 			sdp->exclude = 0;	/* undo if error */
 			up_write(&sdp->o_sem);
 		} else
 			up_read(&sdp->o_sem);
+	}
+
+	if (retval) {
 error_out:
 		scsi_autopm_put_device(sdp->device);
 sdp_put:
@@ -2047,7 +2043,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (!sfp)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	init_waitqueue_head(&sfp->read_wait);
 	rwlock_init(&sfp->rq_list_lock);
@@ -2062,6 +2058,10 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
 	sfp->parentdp = sdp;
 	write_lock_irqsave(&sg_index_lock, iflags);
+	if (sdp->detached) {
+		write_unlock_irqrestore(&sg_index_lock, iflags);
+		return ERR_PTR(-ENODEV);
+	}
 	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
 	write_unlock_irqrestore(&sg_index_lock, iflags);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp: sfp=0x%p\n", sfp));
-- 
1.8.3.1
