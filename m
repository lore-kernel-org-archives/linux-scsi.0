From: brking@us.ibm.com
Subject: [PATCH 1/1] sg: Fix oops of sg_cmd_done and sg_release race
Date: Wed, 27 Oct 2004 15:02:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200410272002.i9RK2nxZ281896@d01relay02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:63625 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262628AbUJ0UD1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 16:03:27 -0400
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, brking@us.ibm.com


Resending with a decent subject line...

This looks to have dropped through the cracks. Please apply.

The following patch fixes a race condition in sg of sg_cmd_done racing
with sg_release. I've seen this bug hit several times on test machines
and the following patch fixes it. The race is that if srp->done is set
and the waiting thread gets a spurious wakeup immediately afterwards,
then the waiting thread can end up executing and completing, then getting
closed, freeing sfp before the wake_up_interruptible is called, which
then will result in an oops. The oops is fixed by locking around the
setting srp->done to 1 and the wake_up, and also locking around the
checking of srp->done, which guarantees that the wake_up_interruptible
will always occur before the sleeping thread gets a chance to run.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.10-rc1-bk6-bjking1/drivers/scsi/sg.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/sg.c~sg_cmd_done_oops_again drivers/scsi/sg.c
--- linux-2.6.10-rc1-bk6/drivers/scsi/sg.c~sg_cmd_done_oops_again	2004-10-27 14:47:51.000000000 -0500
+++ linux-2.6.10-rc1-bk6-bjking1/drivers/scsi/sg.c	2004-10-27 14:47:51.000000000 -0500
@@ -735,6 +735,18 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 }
 
 static int
+sg_srp_done(Sg_request *srp, Sg_fd *sfp)
+{
+	unsigned long iflags;
+	int done;
+
+	read_lock_irqsave(&sfp->rq_list_lock, iflags);
+	done = srp->done;
+	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	return done;
+}
+
+static int
 sg_ioctl(struct inode *inode, struct file *filp,
 	 unsigned int cmd_in, unsigned long arg)
 {
@@ -773,7 +785,7 @@ sg_ioctl(struct inode *inode, struct fil
 			while (1) {
 				result = 0;	/* following macro to beat race condition */
 				__wait_event_interruptible(sfp->read_wait,
-					(sdp->detached || sfp->closed || srp->done),
+					(sdp->detached || sfp->closed || sg_srp_done(srp, sfp)),
 							   result);
 				if (sdp->detached)
 					return -ENODEV;
@@ -784,7 +796,9 @@ sg_ioctl(struct inode *inode, struct fil
 				srp->orphan = 1;
 				return result;	/* -ERESTARTSYS because signal hit process */
 			}
+			write_lock_irqsave(&sfp->rq_list_lock, iflags);
 			srp->done = 2;
+			write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 			result = sg_new_read(sfp, p, SZ_SG_IO_HDR, srp);
 			return (result < 0) ? result : 0;
 		}
@@ -1227,6 +1241,7 @@ sg_cmd_done(Scsi_Cmnd * SCpnt)
 	Sg_device *sdp = NULL;
 	Sg_fd *sfp;
 	Sg_request *srp = NULL;
+	unsigned long iflags;
 
 	if (SCpnt && (SRpnt = SCpnt->sc_request))
 		srp = (Sg_request *) SRpnt->upper_private_data;
@@ -1315,8 +1330,10 @@ sg_cmd_done(Scsi_Cmnd * SCpnt)
 	if (sfp && srp) {
 		/* Now wake up any sg_read() that is waiting for this packet. */
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
+		write_lock_irqsave(&sfp->rq_list_lock, iflags);
 		srp->done = 1;
 		wake_up_interruptible(&sfp->read_wait);
+		write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	}
 }
 
@@ -1510,7 +1527,7 @@ sg_remove(struct class_device *cl_dev)
 				tsfp = sfp->nextfp;
 				for (srp = sfp->headrp; srp; srp = tsrp) {
 					tsrp = srp->nextrp;
-					if (sfp->closed || (0 == srp->done))
+					if (sfp->closed || (0 == sg_srp_done(srp, sfp)))
 						sg_finish_rem_req(srp);
 				}
 				if (sfp->closed) {
@@ -2492,7 +2509,7 @@ sg_remove_sfp(Sg_device * sdp, Sg_fd * s
 
 	for (srp = sfp->headrp; srp; srp = tsrp) {
 		tsrp = srp->nextrp;
-		if (srp->done)
+		if (sg_srp_done(srp, sfp))
 			sg_finish_rem_req(srp);
 		else
 			++dirty;
_
