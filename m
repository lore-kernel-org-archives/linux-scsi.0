From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH 04/10] sg: use wait_event_interruptible()
Date: Thu, 12 Apr 2012 17:33:25 -0400
Message-ID: <20120412213325.GD17388@logfs.org>
References: <20120412213217.GA17388@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:37804 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966241Ab2DLXaA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2012 19:30:00 -0400
Content-Disposition: inline
In-Reply-To: <20120412213217.GA17388@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Afaics the use of __wait_event_interruptible() as opposed to
wait_event_interruptible() is purely historic.  So let's follow the rest
of the kernel and check the condition before prepare_to_wait() - and
also make the code a bit nicer.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/sg.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index be812e0..1a0be4f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -268,9 +268,8 @@ sg_open(struct inode *inode, struct file *filp)
 			retval = -EBUSY;
 			goto error_out;
 		}
-		res = 0;
-		__wait_event_interruptible(sdp->o_excl_wait,
-					   ((!list_empty(&sdp->sfds) || sdp->exclude) ? 0 : (sdp->exclude = 1)), res);
+		res = wait_event_interruptible(sdp->o_excl_wait,
+					   ((!list_empty(&sdp->sfds) || sdp->exclude) ? 0 : (sdp->exclude = 1)));
 		if (res) {
 			retval = res;	/* -ERESTARTSYS because signal hit process */
 			goto error_out;
@@ -280,9 +279,7 @@ sg_open(struct inode *inode, struct file *filp)
 			retval = -EBUSY;
 			goto error_out;
 		}
-		res = 0;
-		__wait_event_interruptible(sdp->o_excl_wait, (!sdp->exclude),
-					   res);
+		res = wait_event_interruptible(sdp->o_excl_wait, !sdp->exclude);
 		if (res) {
 			retval = res;	/* -ERESTARTSYS because signal hit process */
 			goto error_out;
@@ -398,10 +395,9 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 			retval = -EAGAIN;
 			goto free_old_hdr;
 		}
-		retval = 0; /* following macro beats race condition */
-		__wait_event_interruptible(sfp->read_wait,
+		retval = wait_event_interruptible(sfp->read_wait,
 			(sdp->detached ||
-			(srp = sg_get_rq_mark(sfp, req_pack_id))), retval);
+			(srp = sg_get_rq_mark(sfp, req_pack_id))));
 		if (sdp->detached) {
 			retval = -ENODEV;
 			goto free_old_hdr;
@@ -797,9 +793,8 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 				 1, read_only, 1, &srp);
 		if (result < 0)
 			return result;
-		result = 0;	/* following macro to beat race condition */
-		__wait_event_interruptible(sfp->read_wait,
-			(srp->done || sdp->detached), result);
+		result = wait_event_interruptible(sfp->read_wait,
+			(srp->done || sdp->detached));
 		if (sdp->detached)
 			return -ENODEV;
 		write_lock_irq(&sfp->rq_list_lock);
-- 
1.7.9.1

