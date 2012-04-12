From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH 06/10] sg: prevent unwoken sleep
Date: Thu, 12 Apr 2012 17:33:58 -0400
Message-ID: <20120412213358.GF17388@logfs.org>
References: <20120412213217.GA17388@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:48498 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934985Ab2DLXae (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2012 19:30:34 -0400
Content-Disposition: inline
In-Reply-To: <20120412213217.GA17388@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

srp->done is protected by sfp->rq_list_lock everywhere, except for this
one case.  Result can be that the wake-up happens before the cacheline
with the changed srp->done has arrived, so the waiter can go back to
sleep and never be woken up again.

The wait_event_interruptible() means that anyone trying to debug this
unlikely race will likely notice everything working fine again, as the
next signal will unwedge things.  Evil.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/sg.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ba657a9..758e7b4 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -137,7 +137,8 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 	char res_used;		/* 1 -> using reserve buffer, 0 -> not ... */
 	char orphan;		/* 1 -> drop on sight, 0 -> normal */
 	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
-	volatile char done;	/* 0->before bh, 1->before read, 2->read */
+	/* done protected by rq_list_lock */
+	char done;		/* 0->before bh, 1->before read, 2->read */
 	struct request *rq;
 	struct bio *bio;
 	struct execute_work ew;
@@ -760,6 +761,17 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	return 0;
 }
 
+static int srp_done(Sg_fd *sfp, Sg_request *srp)
+{
+	unsigned long flags;
+	int ret;
+
+	read_lock_irqsave(&sfp->rq_list_lock, flags);
+	ret = srp->done;
+	read_unlock_irqrestore(&sfp->rq_list_lock, flags);
+	return ret;
+}
+
 static int
 sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
@@ -791,7 +803,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		if (result < 0)
 			return result;
 		result = wait_event_interruptible(sfp->read_wait,
-			(srp->done || sdp->detached));
+			(srp_done(sfp, srp) || sdp->detached));
 		if (sdp->detached)
 			return -ENODEV;
 		write_lock_irq(&sfp->rq_list_lock);
-- 
1.7.9.1

