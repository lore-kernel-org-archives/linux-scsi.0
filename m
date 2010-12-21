From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] scsi: remove bogus use of struct execute_work in sg
Date: Tue, 21 Dec 2010 16:02:00 +0100
Message-ID: <1292943721-4519-6-git-send-email-tj@kernel.org>
References: <1292943721-4519-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:38790 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab0LUPCQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Dec 2010 10:02:16 -0500
In-Reply-To: <1292943721-4519-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, Eric.Moore@lsi.com, dgilbert@interlog.com
Cc: Tejun Heo <tj@kernel.org>

execute_work usage in sg is bogus.  execute_in_process_context() is
never used and ew is used purely as wrapper around work_struct which
is superflous.  Use work_struct directly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 909ed9e..403998c 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -139,7 +139,7 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 	volatile char done;	/* 0->before bh, 1->before read, 2->read */
 	struct request *rq;
 	struct bio *bio;
-	struct execute_work ew;
+	struct work_struct work;
 } Sg_request;
 
 typedef struct sg_fd {		/* holds the state of a file descriptor */
@@ -162,7 +162,7 @@ typedef struct sg_fd {		/* holds the state of a file descriptor */
 	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
 	char mmap_called;	/* 0 -> mmap() never called on this fd */
 	struct kref f_ref;
-	struct execute_work ew;
+	struct work_struct work;
 } Sg_fd;
 
 typedef struct sg_device { /* holds the state of each scsi generic device */
@@ -1248,7 +1248,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 
 static void sg_rq_end_io_usercontext(struct work_struct *work)
 {
-	struct sg_request *srp = container_of(work, struct sg_request, ew.work);
+	struct sg_request *srp = container_of(work, struct sg_request, work);
 	struct sg_fd *sfp = srp->parentfp;
 
 	sg_finish_rem_req(srp);
@@ -1335,8 +1335,8 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
 		kref_put(&sfp->f_ref, sg_remove_sfp);
 	} else {
-		INIT_WORK(&srp->ew.work, sg_rq_end_io_usercontext);
-		schedule_work(&srp->ew.work);
+		INIT_WORK(&srp->work, sg_rq_end_io_usercontext);
+		schedule_work(&srp->work);
 	}
 }
 
@@ -2089,7 +2089,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 
 static void sg_remove_sfp_usercontext(struct work_struct *work)
 {
-	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
+	struct sg_fd *sfp = container_of(work, struct sg_fd, work);
 	struct sg_device *sdp = sfp->parentdp;
 
 	/* Cleanup any responses which were never read(). */
@@ -2126,8 +2126,8 @@ static void sg_remove_sfp(struct kref *kref)
 	write_unlock_irqrestore(&sg_index_lock, iflags);
 	wake_up_interruptible(&sdp->o_excl_wait);
 
-	INIT_WORK(&sfp->ew.work, sg_remove_sfp_usercontext);
-	schedule_work(&sfp->ew.work);
+	INIT_WORK(&sfp->work, sg_remove_sfp_usercontext);
+	schedule_work(&sfp->work);
 }
 
 static int
-- 
1.7.1

