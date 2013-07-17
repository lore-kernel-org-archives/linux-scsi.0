From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: [PATCH v4 3/4] [SCSI] sg: checking sdp->detached isn't protected when open
Date: Wed, 17 Jul 2013 23:34:05 +0800
Message-ID: <1374075246-22923-4-git-send-email-vaughan.cao@oracle.com>
References: <20130715203730.GA21804@logfs.org>
 <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: joern@logfs.org
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, vaughan.cao@oracle.com
List-Id: linux-scsi@vger.kernel.org

@detached is set under the protection of sg_index_lock. Without getting the
lock, new sfp will be added during sg removal and there is no chance for it
to be picked out. So check with sg_index_lock held in sg_add_sfp().

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 drivers/scsi/sg.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 671b760..4d2a19f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -196,7 +196,7 @@ static void sg_remove_scat(Sg_scatter_hold * schp);
 static void sg_build_reserve(Sg_fd * sfp, int req_size);
 static void sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size);
 static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
-static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev);
+static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev, int * reason);
 static void sg_remove_sfp(struct kref *);
 static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
 static Sg_request *sg_add_request(Sg_fd * sfp);
@@ -295,21 +295,14 @@ sg_open(struct inode *inode, struct file *filp)
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
+	if (!(sfp = sg_add_sfp(sdp, dev, &retval)))
 		goto sem_out;
-	}
+	filp->private_data = sfp;
 	retval = 0;
 
 	if (retval) {
@@ -2047,15 +2040,18 @@ sg_remove_request(Sg_fd * sfp, Sg_request * srp)
 }
 
 static Sg_fd *
-sg_add_sfp(Sg_device * sdp, int dev)
+sg_add_sfp(Sg_device * sdp, int dev, int * reason)
 {
 	Sg_fd *sfp;
 	unsigned long iflags;
 	int bufflen;
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
-	if (!sfp)
+	if (!sfp) {
+		if (reason)
+			*reason = -ENOMEM;
 		return NULL;
+	}
 
 	init_waitqueue_head(&sfp->read_wait);
 	rwlock_init(&sfp->rq_list_lock);
@@ -2070,6 +2066,12 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
 	sfp->parentdp = sdp;
 	write_lock_irqsave(&sg_index_lock, iflags);
+	if (sdp->detached) {
+		write_unlock_irqrestore(&sg_index_lock, iflags);
+		if (reason)
+			*reason = -ENODEV;
+		return NULL;
+	}
 	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
 	write_unlock_irqrestore(&sg_index_lock, iflags);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp: sfp=0x%p\n", sfp));
-- 
1.7.11.7
