From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH 08/10] sg: completely protect sfds
Date: Thu, 12 Apr 2012 17:34:46 -0400
Message-ID: <20120412213445.GH17388@logfs.org>
References: <20120412213217.GA17388@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:48503 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966235Ab2DLXbV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2012 19:31:21 -0400
Content-Disposition: inline
In-Reply-To: <20120412213217.GA17388@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

sfds is protected by sg_index_lock - except for sg_open(), where it
isn't.  Change that and add some documentation.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/sg.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index a70018e..a40b814 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -146,6 +146,7 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 } Sg_request;
 
 typedef struct sg_fd {		/* holds the state of a file descriptor */
+	/* sfd_siblings is protected by sg_index_lock */
 	struct list_head sfd_siblings;
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
@@ -172,6 +173,7 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 	wait_queue_head_t o_excl_wait;	/* queue open() when O_EXCL in use */
 	int sg_tablesize;	/* adapter's max scatter-gather table size */
 	u32 index;		/* device index number */
+	/* sfds is protected by sg_index_lock */
 	struct list_head sfds;
 	volatile char detached;	/* 0->attached, 1->detached pending removal */
 	/* exclude protected by sg_open_exclusive_lock */
@@ -243,6 +245,17 @@ static void set_exclude(Sg_device *sdp, char val)
 	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
 }
 
+static int sfds_list_empty(Sg_device *sdp)
+{
+	unsigned long flags;
+	int ret;
+
+	read_lock_irqsave(&sg_index_lock, flags);
+	ret = list_empty(&sdp->sfds);
+	read_unlock_irqrestore(&sg_index_lock, flags);
+	return ret;
+}
+
 static int
 sg_open(struct inode *inode, struct file *filp)
 {
@@ -286,12 +299,12 @@ sg_open(struct inode *inode, struct file *filp)
 			retval = -EPERM; /* Can't lock it with read only access */
 			goto error_out;
 		}
-		if (!list_empty(&sdp->sfds) && (flags & O_NONBLOCK)) {
+		if (!sfds_list_empty(sdp) && (flags & O_NONBLOCK)) {
 			retval = -EBUSY;
 			goto error_out;
 		}
 		res = wait_event_interruptible(sdp->o_excl_wait,
-					   ((!list_empty(&sdp->sfds) || get_exclude(sdp)) ? 0 : set_exclude(sdp, 1), 1));
+					   ((!sfds_list_empty(sdp) || get_exclude(sdp)) ? 0 : set_exclude(sdp, 1), 1));
 		if (res) {
 			retval = res;	/* -ERESTARTSYS because signal hit process */
 			goto error_out;
@@ -311,7 +324,7 @@ sg_open(struct inode *inode, struct file *filp)
 		retval = -ENODEV;
 		goto error_out;
 	}
-	if (list_empty(&sdp->sfds)) {	/* no existing opens on this device */
+	if (sfds_list_empty(sdp)) {	/* no existing opens on this device */
 		sdp->sgdebug = 0;
 		q = sdp->device->request_queue;
 		sdp->sg_tablesize = queue_max_segments(q);
-- 
1.7.9.1

