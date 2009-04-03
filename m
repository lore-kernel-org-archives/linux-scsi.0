From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] sg: fix q->queue_lock on scsi_error_handler path
Date: Fri, 3 Apr 2009 19:28:06 +0900
Message-ID: <20090403192745E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:59546 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759446AbZDCK2O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Apr 2009 06:28:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org

This is a fix for another fallout of the block layer conversion (sorry
again).

This should be go into 2.6.28.y and 2.6.29.y.

However, this should go with patches that I sent for 2.6.29.1 and
were dropped. So I don't use 'stable@kernel.org' tag.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] [PATCH] sg: fix q->queue_lock on scsi_error_handler path

sg_rq_end_io() is called via rq->end_io. In some rare cases,
sg_rq_end_io calls blk_put_request/blk_rq_unmap_user (when a program
issuing a command has gone before the command completion; e.g. by
interrupting a program issuing a command before the command
completes).

We can't call blk_put_request/blk_rq_unmap_user in interrupt so the
commit c96952ed7031e7c576ecf90cf95b8ec099d5295a uses
execute_in_process_context().

The problem is that scsi_error_handler() calls rq->end_io too. We
can't call blk_put_request/blk_rq_unmap_user too in this path (we hold
q->queue_lock).

To avoid the above problem, in these rare cases, this patch always
uses schedule_work() instead of execute_in_process_context().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 1e40518..82312df 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1312,8 +1312,10 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 		wake_up_interruptible(&sfp->read_wait);
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
 		kref_put(&sfp->f_ref, sg_remove_sfp);
-	} else
-		execute_in_process_context(sg_rq_end_io_usercontext, &srp->ew);
+	} else {
+		INIT_WORK(&srp->ew.work, sg_rq_end_io_usercontext);
+		schedule_work(&srp->ew.work);
+	}
 }
 
 static struct file_operations sg_fops = {
@@ -2099,7 +2101,8 @@ static void sg_remove_sfp(struct kref *kref)
 	write_unlock_irqrestore(&sg_index_lock, iflags);
 	wake_up_interruptible(&sdp->o_excl_wait);
 
-	execute_in_process_context(sg_remove_sfp_usercontext, &sfp->ew);
+	INIT_WORK(&sfp->ew.work, sg_remove_sfp_usercontext);
+	schedule_work(&sfp->ew.work);
 }
 
 static int
-- 
1.6.0.6

