From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: [PATCH v5 3/4] [SCSI] sg: checking sdp->detached isn't protected when open
Date: Mon, 22 Jul 2013 12:40:32 +0800
Message-ID: <1374468033-8947-4-git-send-email-vaughan.cao@oracle.com>
References: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
 <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51244 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab3GVEi3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jul 2013 00:38:29 -0400
In-Reply-To: <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joern@logfs.org
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, vaughan.cao@oracle.com

@detached is set under the protection of sg_index_lock. Without getting the
lock, new sfp will be added during sg removal and there is no chance for it
to be picked out. So check with sg_index_lock held in sg_add_sfp().

Changes from v4:
 * use ERR_PTR series instead of adding another parameter in sg_add_sfp

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 drivers/scsi/sg.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 671b760..f0e4785 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -295,21 +295,17 @@ sg_open(struct inode *inode, struct file *filp)
 	if (flags & O_EXCL)
 		sdp->exclude = 1;	/* used by release lock */
 
-	if (sdp->detached) {
-		retval = -ENODEV;
-		goto sem_out;
-	}
 	if (sfds_list_empty(sdp)) {	/* no existing opens on this device */
 		sdp->sgdebug = 0;
 		q = sdp->device->request_queue;
 		sdp->sg_tablesize = queue_max_segments(q);
 	}
-	if ((sfp = sg_add_sfp(sdp, dev)))
-		filp->private_data = sfp;
-	else {
-		retval = -ENOMEM;
+	sfp = sg_add_sfp(sdp, dev);
+	if (IS_ERR(sfp)) {
+		retval = PTR_ERR(sfp);
 		goto sem_out;
 	}
+	filp->private_data = sfp;
 	retval = 0;
 
 	if (retval) {
@@ -2055,7 +2051,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (!sfp)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	init_waitqueue_head(&sfp->read_wait);
 	rwlock_init(&sfp->rq_list_lock);
@@ -2070,6 +2066,10 @@ sg_add_sfp(Sg_device * sdp, int dev)
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
1.7.11.7

