From: Brian King <brking@us.ibm.com>
Subject: [PATCH] sg_cmd_done - another oops
Date: Fri, 04 Jun 2004 10:34:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40C0968E.4090309@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020008090903050705000503"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:1688 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265803AbUFDPfR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2004 11:35:17 -0400
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020008090903050705000503
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------020008090903050705000503
Content-Type: text/plain;
 name="sg_cmd_done_oops_again.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_cmd_done_oops_again.patch"


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


---

 linux-2.6.7-rc2-bjking1/drivers/scsi/sg.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/sg.c~sg_cmd_done_oops_again drivers/scsi/sg.c
--- linux-2.6.7-rc2/drivers/scsi/sg.c~sg_cmd_done_oops_again	2004-06-02 15:44:00.000000000 -0500
+++ linux-2.6.7-rc2-bjking1/drivers/scsi/sg.c	2004-06-02 15:45:01.000000000 -0500
@@ -723,6 +723,18 @@ sg_common_write(Sg_fd * sfp, Sg_request 
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
@@ -761,7 +773,7 @@ sg_ioctl(struct inode *inode, struct fil
 			while (1) {
 				result = 0;	/* following macro to beat race condition */
 				__wait_event_interruptible(sfp->read_wait,
-					(sdp->detached || sfp->closed || srp->done),
+					(sdp->detached || sfp->closed || sg_srp_done(srp, sfp)),
 							   result);
 				if (sdp->detached)
 					return -ENODEV;
@@ -772,7 +784,9 @@ sg_ioctl(struct inode *inode, struct fil
 				srp->orphan = 1;
 				return result;	/* -ERESTARTSYS because signal hit process */
 			}
+			write_lock_irqsave(&sfp->rq_list_lock, iflags);
 			srp->done = 2;
+			write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 			result = sg_new_read(sfp, p, SZ_SG_IO_HDR, srp);
 			return (result < 0) ? result : 0;
 		}
@@ -1215,6 +1229,7 @@ sg_cmd_done(Scsi_Cmnd * SCpnt)
 	Sg_device *sdp = NULL;
 	Sg_fd *sfp;
 	Sg_request *srp = NULL;
+	unsigned long iflags;
 
 	if (SCpnt && (SRpnt = SCpnt->sc_request))
 		srp = (Sg_request *) SRpnt->upper_private_data;
@@ -1303,8 +1318,10 @@ sg_cmd_done(Scsi_Cmnd * SCpnt)
 	if (sfp && srp) {
 		/* Now wake up any sg_read() that is waiting for this packet. */
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
+		write_lock_irqsave(&sfp->rq_list_lock, iflags);
 		srp->done = 1;
 		wake_up_interruptible(&sfp->read_wait);
+		write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	}
 }
 
@@ -1490,7 +1507,7 @@ sg_remove(struct class_device *cl_dev)
 				tsfp = sfp->nextfp;
 				for (srp = sfp->headrp; srp; srp = tsrp) {
 					tsrp = srp->nextrp;
-					if (sfp->closed || (0 == srp->done))
+					if (sfp->closed || (0 == sg_srp_done(srp, sfp)))
 						sg_finish_rem_req(srp);
 				}
 				if (sfp->closed) {
@@ -2472,7 +2489,7 @@ sg_remove_sfp(Sg_device * sdp, Sg_fd * s
 
 	for (srp = sfp->headrp; srp; srp = tsrp) {
 		tsrp = srp->nextrp;
-		if (srp->done)
+		if (sg_srp_done(srp, sfp))
 			sg_finish_rem_req(srp);
 		else
 			++dirty;

_

--------------020008090903050705000503--

