From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: Re: Yet another hot unplug NULL pointer dereference (was Re: status of oops in sd_revalidate_disk?)
Date: Tue, 14 Feb 2012 19:11:16 +0000
Message-ID: <2173642.Y3HxI15Hxl@asus>
References: <4EE8E419.8010000@pre-sense.de> <CAO+b5-pCW-F1nD365TnEiAfoN7zKB4zXkk3uO6p5QyUPY2icsA@mail.gmail.com> <20120214143800.69703df9@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:35943 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab2BNTLV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2012 14:11:21 -0500
In-Reply-To: <20120214143800.69703df9@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, jbottomley@parallels.com, linux-scsi@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>, Axel Theilmann <theilmann@pre-sense.de>, linux-kernel@vger.kernel.org

On Feb 14 Stefan Richter wrote:
> Or asked differently, what is supposed to serialize the ->queuedata
> accesses?

How about avoiding to modify q->queuedata before scsi_free_queue() has been
invoked, e.g. as follows ? Note: the kfree() call in scsi_host_dev_release() probably
should be postponed until the last put on the queue has occurred.

>From 4d29b62c686a718d34d3b3f634306376b40dbdb6 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 14 Feb 2012 13:52:21 +0100
Subject: [PATCH] scsi-queuedata-null-deref-fix

---
 drivers/scsi/hosts.c      |    4 ++--
 drivers/scsi/scsi_lib.c   |   13 +++----------
 drivers/scsi/scsi_sysfs.c |    3 ---
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 351dc0b..5f34620 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -296,9 +296,9 @@ static void scsi_host_dev_release(struct device *dev)
 		destroy_workqueue(shost->work_q);
 	q = shost->uspace_req_q;
 	if (q) {
-		kfree(q->queuedata);
-		q->queuedata = NULL;
+		void *qd = q->queuedata;
 		scsi_free_queue(q);
+		kfree(qd);
 	}
 
 	scsi_destroy_command_freelist(shost);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f85cfa6..7c40303 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1491,7 +1491,9 @@ static void scsi_request_fn(struct request_queue *q)
 	struct scsi_cmnd *cmd;
 	struct request *req;
 
-	if (!sdev) {
+	BUG_ON(!sdev);
+
+	if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)) {
 		while ((req = blk_peek_request(q)) != NULL)
 			scsi_kill_request(req, q);
 		return;
@@ -1700,15 +1702,6 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 
 void scsi_free_queue(struct request_queue *q)
 {
-	unsigned long flags;
-
-	WARN_ON(q->queuedata);
-
-	/* cause scsi_request_fn() to kill all non-finished requests */
-	spin_lock_irqsave(q->queue_lock, flags);
-	q->request_fn(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
 	blk_cleanup_queue(q);
 }
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ea5658d..61dd107 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -976,9 +976,6 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
 
-	/* cause the request function to reject all I/O requests */
-	sdev->request_queue->queuedata = NULL;
-
 	/* Freeing the queue signals to block that we're done */
 	scsi_free_queue(sdev->request_queue);
 	put_device(dev);
-- 
1.7.7


