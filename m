From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] sg: avoid blk_put_request/blk_rq_unmap_user in interrupt
Date: Wed, 4 Feb 2009 11:36:27 +0900
Message-ID: <20090204113613R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:55007 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbZBDCgr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Feb 2009 21:36:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, dgilbert@interlog.com, jens.axboe@oracle.com

This is against scsi-misc.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] sg: avoid blk_put_request/blk_rq_unmap_user in interrupt

This fixes the following oops:

http://marc.info/?l=linux-kernel&m=123316111415677&w=2

You can reproduce this bug by interrupting a program before a sg
response completes. This leads to the special sg state (the orphan
state), then sg calls blk_put_request in interrupt (rq->end_io).

The above bug report shows the recursive lock problem because sg calls
blk_put_request in interrupt. We could call __blk_put_request here
instead however we also need to handle blk_rq_unmap_user here, which
can't be called in interrupt too.

In the orphan state, we don't need to care about the data transfer
(the program revoked the command) so adding 'just free the resource'
mode to blk_rq_unmap_user is a possible option.

I prefer to avoid complicating the blk mapping API when possible. I
change the orphan state to call sg_finish_rem_req via
execute_in_process_context. We hold sg_fd->kref so sg_fd doesn't go
away until keventd_wq finishes our work. copy_from_user/to_user fails
so blk_rq_unmap_user just frees the resource without the data
transfer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ac1471b..912a9eb 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -138,6 +138,7 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 	volatile char done;	/* 0->before bh, 1->before read, 2->read */
 	struct request *rq;
 	struct bio *bio;
+	struct execute_work ew;
 } Sg_request;
 
 typedef struct sg_fd {		/* holds the state of a file descriptor */
@@ -1234,6 +1235,15 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	return 0;
 }
 
+static void sg_rq_end_io_usercontext(struct work_struct *work)
+{
+	struct sg_request *srp = container_of(work, struct sg_request, ew.work);
+	struct sg_fd *sfp = srp->parentfp;
+
+	sg_finish_rem_req(srp);
+	kref_put(&sfp->f_ref, sg_remove_sfp);
+}
+
 /*
  * This function is a "bottom half" handler that is called by the mid
  * level when a command is completed (or has failed).
@@ -1312,10 +1322,9 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 		 */
 		wake_up_interruptible(&sfp->read_wait);
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
+		kref_put(&sfp->f_ref, sg_remove_sfp);
 	} else
-		sg_finish_rem_req(srp); /* call with srp->done == 0 */
-
-	kref_put(&sfp->f_ref, sg_remove_sfp);
+		execute_in_process_context(sg_rq_end_io_usercontext, &srp->ew);
 }
 
 static struct file_operations sg_fops = {
-- 
1.6.0.6

