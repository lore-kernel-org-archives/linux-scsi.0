From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] [SCSI] sg: fix unkillable I/O wait deadlock with scsi-mq
Date: Wed, 11 Feb 2015 11:31:33 -0500
Message-ID: <54DB83E5.6020205@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cybernetics.com ([173.71.130.66]:24412 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbbBKQbf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2015 11:31:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-kernel@vger.kernel.org

When using the write()/read() interface for submitting commands, the
SCSI generic driver does not call blk_put_request() on a completed SCSI
command until userspace calls read() to get the command completion. 
Since scsi-mq uses a fixed number of preallocated requests, this makes
it possible for userspace to exhaust the entire preallocated supply of
requests, leading to deadlock with the user process stuck in a permanent
unkillable I/O wait in sg_write() -> ... -> blk_get_request() -> ... ->
bt_get().  Note that this deadlock can happen only if scsi-mq is
enabled.  Prevent the deadlock by calling blk_put_request() as soon as
the SCSI command completes instead of waiting for userspace to call read().

Cc: <stable@vger.kernel.org> # 3.17+
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

For inclusion in kernel 3.20.

I encountered this problem using mptsas (can_queue == 127) and 8 disks
connected via an expander.  I have a test program called cydiskbench
that spawns multiple threads, opens multiple /dev/sg* file descriptors,
and sends multiple disk read/write commands to each /dev/sg* file
descriptor.  I can vary the # of disks being tested and the command
queue depth per disk.  Whenever I chose test parameters such that
(n_disks * queue_depth_per_disk) > shost->can_queue, the test deadlocked
as described when scsi-mq was enabled but worked just fine with scsi-mq
disabled.

I will send a separate patch to fix the same problem in the bsg driver.

--- linux-3.19.0/drivers/scsi/sg.c.orig	2015-02-08 21:54:22.000000000 -0500
+++ linux-3.19.0/drivers/scsi/sg.c	2015-02-09 17:40:00.000000000 -0500
@@ -1350,6 +1350,17 @@ sg_rq_end_io(struct request *rq, int upt
 	}
 	/* Rely on write phase to clean out srp status values, so no "else" */
 
+	/*
+	 * Free the request as soon as it is complete so that its resources
+	 * can be reused without waiting for userspace to read() the
+	 * result.  But keep the associated bio (if any) around until
+	 * blk_rq_unmap_user() can be called from user context.
+	 */
+	srp->rq = NULL;
+	if (rq->cmd != rq->__cmd)
+		kfree(rq->cmd);
+	__blk_put_request(rq->q, rq);
+
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	if (unlikely(srp->orphan)) {
 		if (sfp->keep_orphan)
@@ -1777,10 +1788,10 @@ sg_finish_rem_req(Sg_request *srp)
 	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sfp->parentdp,
 				      "sg_finish_rem_req: res_used=%d\n",
 				      (int) srp->res_used));
+	if (srp->bio)
+		ret = blk_rq_unmap_user(srp->bio);
+
 	if (srp->rq) {
-		if (srp->bio)
-			ret = blk_rq_unmap_user(srp->bio);
-
 		if (srp->rq->cmd != srp->rq->__cmd)
 			kfree(srp->rq->cmd);
 		blk_put_request(srp->rq);

