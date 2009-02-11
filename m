From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH -stable 2.6.28.x] sg: avoid
 blk_put_request/blk_rq_unmap_user in interrupt
Date: Wed, 11 Feb 2009 14:50:18 +0900
Message-ID: <20090211145014C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:43087 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZBKFvQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2009 00:51:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stable@kernel.org
Cc: hias@horus.com, rjw@sisk.pl, James.Bottomley@HansenPartnership.com, dgilbert@interlog.com, linux-scsi@vger.kernel.org

This patch is against 2.6.28.x, fixes a regression from 2.6.27.

This is the modified version of the following patch that is planed to
merged into 2.6.30-rc1 in scsi-misc tree:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=b35fe25ae156830f85a305afaba837b084458e7a

scsi-misc tree has other patches to fix sg oops so the above patch
can't be cleanly applied to 2.6.28.x. These patches are too large for
2.6.28.x (needs more testings) so sg in 2.6.28.x still has the oops
bugs for now even with this patch. I expect that these patches will go
into stable trees too after 2.6.30-rc1 (that is, after more people
test them).

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH -stable 2.6.28.x] sg: avoid blk_put_request/blk_rq_unmap_user in interrupt

This fixes the following oops:

http://bugzilla.kernel.org/show_bug.cgi?id=12612

You can reproduce this bug by interrupting a program before a sg
response completes. This leads to the special sg state (the orphan
state), then sg calls blk_put_request in interrupt (rq->end_io).

The above bug report shows the recursive lock problem because sg calls
blk_put_request in interrupt. We could call __blk_put_request here
instead however we also need to handle blk_rq_unmap_user here, which
can't be called in interrupt too.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5103855..66be131 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -137,6 +137,7 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 	volatile char done;	/* 0->before bh, 1->before read, 2->read */
 	struct request *rq;
 	struct bio *bio;
+	struct execute_work ew;
 } Sg_request;
 
 typedef struct sg_fd {		/* holds the state of a file descriptor */
@@ -1240,6 +1241,20 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	return 0;
 }
 
+static void sg_rq_end_io_usercontext(struct work_struct *work)
+{
+	struct sg_request *srp = container_of(work, struct sg_request, ew.work);
+	struct sg_fd *sfp = srp->parentfp;
+	struct sg_device *sdp = sfp->parentdp;
+
+	sg_finish_rem_req(srp);
+	if (sfp->closed && !sfp->headrp) {
+		SCSI_LOG_TIMEOUT(1, printk("sg_cmd_done: already closed, final cleanup\n"));
+		if (!sg_remove_sfp(sdp, sfp))
+			scsi_device_put(sdp->device);
+	}
+}
+
 /*
  * This function is a "bottom half" handler that is called by the mid
  * level when a command is completed (or has failed).
@@ -1305,20 +1320,14 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 
 	if (sfp->closed) {	/* whoops this fd already released, cleanup */
 		SCSI_LOG_TIMEOUT(1, printk("sg_cmd_done: already closed, freeing ...\n"));
-		sg_finish_rem_req(srp);
+		execute_in_process_context(sg_rq_end_io_usercontext, &srp->ew);
 		srp = NULL;
-		if (NULL == sfp->headrp) {
-			SCSI_LOG_TIMEOUT(1, printk("sg_cmd_done: already closed, final cleanup\n"));
-			if (0 == sg_remove_sfp(sdp, sfp)) {	/* device still present */
-				scsi_device_put(sdp->device);
-			}
-			sfp = NULL;
-		}
 	} else if (srp && srp->orphan) {
 		if (sfp->keep_orphan)
 			srp->sg_io_owned = 0;
 		else {
-			sg_finish_rem_req(srp);
+			execute_in_process_context(sg_rq_end_io_usercontext,
+						   &srp->ew);
 			srp = NULL;
 		}
 	}
-- 
1.6.0.6

