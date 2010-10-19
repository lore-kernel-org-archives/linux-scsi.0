From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2] scsi: remove bogus use of struct execute_work in sg
Date: Tue, 19 Oct 2010 14:57:36 +0200
Message-ID: <4CBD95C0.6060302@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:47345 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab0JSM5z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Oct 2010 08:57:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkml <linux-kernel@vger.kernel.org>

execute_work usage in sg is bogus.  execute_in_process_context() is
never used and ew is used purely as wrapper around work_struct which
is superflous.  Use work_struct directly.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/sg.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: work/drivers/scsi/sg.c
===================================================================
--- work.orig/drivers/scsi/sg.c
+++ work/drivers/scsi/sg.c
@@ -137,7 +137,7 @@ typedef struct sg_request {	/* SG_MAX_QU
 	volatile char done;	/* 0->before bh, 1->before read, 2->read */
 	struct request *rq;
 	struct bio *bio;
-	struct execute_work ew;
+	struct work_struct work;
 } Sg_request;

 typedef struct sg_fd {		/* holds the state of a file descriptor */
@@ -160,7 +160,7 @@ typedef struct sg_fd {		/* holds the sta
 	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
 	char mmap_called;	/* 0 -> mmap() never called on this fd */
 	struct kref f_ref;
-	struct execute_work ew;
+	struct work_struct work;
 } Sg_fd;

 typedef struct sg_device { /* holds the state of each scsi generic device */
@@ -1246,7 +1246,7 @@ sg_mmap(struct file *filp, struct vm_are

 static void sg_rq_end_io_usercontext(struct work_struct *work)
 {
-	struct sg_request *srp = container_of(work, struct sg_request, ew.work);
+	struct sg_request *srp = container_of(work, struct sg_request, work);
 	struct sg_fd *sfp = srp->parentfp;

 	sg_finish_rem_req(srp);
@@ -1333,8 +1333,8 @@ static void sg_rq_end_io(struct request
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
 		kref_put(&sfp->f_ref, sg_remove_sfp);
 	} else {
-		INIT_WORK(&srp->ew.work, sg_rq_end_io_usercontext);
-		schedule_work(&srp->ew.work);
+		INIT_WORK(&srp->work, sg_rq_end_io_usercontext);
+		schedule_work(&srp->work);
 	}
 }

@@ -2086,7 +2086,7 @@ sg_add_sfp(Sg_device * sdp, int dev)

 static void sg_remove_sfp_usercontext(struct work_struct *work)
 {
-	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
+	struct sg_fd *sfp = container_of(work, struct sg_fd, work);
 	struct sg_device *sdp = sfp->parentdp;

 	/* Cleanup any responses which were never read(). */
@@ -2123,8 +2123,8 @@ static void sg_remove_sfp(struct kref *k
 	write_unlock_irqrestore(&sg_index_lock, iflags);
 	wake_up_interruptible(&sdp->o_excl_wait);

-	INIT_WORK(&sfp->ew.work, sg_remove_sfp_usercontext);
-	schedule_work(&sfp->ew.work);
+	INIT_WORK(&sfp->work, sg_remove_sfp_usercontext);
+	schedule_work(&sfp->work);
 }

 static int
