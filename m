From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 03/05] scsi: make scsi_queue_insert() use blk_requeue_request()
Date: Thu, 21 Apr 2005 11:43:33 +0900
Message-ID: <20050421024333.GA19112@htj.dyndns.org>
References: <20050419231435.D85F89C0@htj.dyndns.org> <20050419231435.329FA30B@htj.dyndns.org> <1114039446.5933.17.camel@mulgrave> <4266F1D0.2060003@gmail.com> <1114049793.5000.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.200]:31671 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261182AbVDUCni (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 22:43:38 -0400
Received: by rproxy.gmail.com with SMTP id z35so323929rne
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 19:43:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1114049793.5000.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

 Hello, James.

 This is the modified patch with the comment (slightly modified).
With this patch, the next patch in this patchset complains about line
offset but it's okay.

 Thanks.


 Signed-off-by: Tejun Heo <htejun@gmail.com>


Index: scsi-reqfn-export/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_lib.c	2005-04-21 11:33:13.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_lib.c	2005-04-21 11:39:17.000000000 +0900
@@ -96,6 +96,8 @@ int scsi_insert_special_req(struct scsi_
 	return 0;
 }
 
+static void scsi_run_queue(struct request_queue *q);
+
 /*
  * Function:    scsi_queue_insert()
  *
@@ -119,6 +121,8 @@ int scsi_queue_insert(struct scsi_cmnd *
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_device *device = cmd->device;
+	struct request_queue *q = device->request_queue;
+	unsigned long flags;
 
 	SCSI_LOG_MLQUEUE(1,
 		 printk("Inserting command %p into mlqueue\n", cmd));
@@ -154,17 +158,22 @@ int scsi_queue_insert(struct scsi_cmnd *
 	scsi_device_unbusy(device);
 
 	/*
-	 * Insert this command at the head of the queue for it's device.
-	 * It will go before all other commands that are already in the queue.
+	 * Requeue this command.  It will go before all other commands
+	 * that are already in the queue.
 	 *
 	 * NOTE: there is magic here about the way the queue is plugged if
 	 * we have no outstanding commands.
 	 * 
-	 * Although this *doesn't* plug the queue, it does call the request
+	 * Although we *don't* plug the queue, we call the request
 	 * function.  The SCSI request function detects the blocked condition
 	 * and plugs the queue appropriately.
-	 */
-	blk_insert_request(device->request_queue, cmd->request, 1, cmd, 1);
+         */
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_requeue_request(q, cmd->request);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	scsi_run_queue(q);
+
 	return 0;
 }
 
