From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI core: fix leakage of scsi_cmnd's
Date: Fri, 09 Sep 2005 13:40:23 -0500
Message-ID: <1126291223.4799.35.camel@mulgrave>
References: <Pine.LNX.4.44L0.0509081640260.4545-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:9642 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932573AbVIISkc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2005 14:40:32 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509081640260.4545-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Dailey, Nate" <Nate.Dailey@stratus.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2005-09-08 at 16:49 -0400, Alan Stern wrote:
> This hasn't been tested very thoroughly, so please look through it 
> carefully.

Actually, just one problem and one cosmetic fix:

1) We need to dequeue for the loop and kill case (it seems easiest
simply to dequeue in the scsi_kill_request() routine)
2) There's no real need to drop the queue lock.  __scsi_done() is lock
agnostic, so since there's no requirement, let's just leave it in to
avoid any locking issues.

Thanks,

James

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1370,7 +1370,8 @@ static void scsi_kill_request(struct req
 {
 	struct scsi_cmnd *cmd = req->special;
 
-	spin_unlock(q->queue_lock);
+	blkdev_dequeue_request(req);
+
 	if (unlikely(cmd == NULL)) {
 		printk(KERN_CRIT "impossible request in %s.\n",
 				 __FUNCTION__);
@@ -1381,7 +1382,6 @@ static void scsi_kill_request(struct req
 	cmd->result = DID_NO_CONNECT << 16;
 	atomic_inc(&cmd->device->iorequest_cnt);
 	__scsi_done(cmd);
-	spin_lock(q->queue_lock);
 }
 
 /*
@@ -1432,7 +1432,6 @@ static void scsi_request_fn(struct reque
 		if (unlikely(!scsi_device_online(sdev))) {
 			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to offline device\n",
 			       sdev->host->host_no, sdev->id, sdev->lun);
-			blkdev_dequeue_request(req);
 			scsi_kill_request(req, q);
 			continue;
 		}


