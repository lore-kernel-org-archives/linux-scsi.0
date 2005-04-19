From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 03/05] scsi: make scsi_queue_insert() use blk_requeue_request()
Date: Wed, 20 Apr 2005 08:15:54 +0900 (KST)
Message-ID: <20050419231435.329FA30B@htj.dyndns.org>
References: <20050419231435.D85F89C0@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261751AbVDSXTA@vger.kernel.org>
In-Reply-To: <20050419231435.D85F89C0@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

03_scsi_REQ_SPECIAL_semantic_scsi_queue_insert.patch

	scsi_queue_insert() used to use blk_insert_request() for
	requeueing requests.  This depends on the unobvious behavior
	of blk_insert_request() setting REQ_SPECIAL and
	REQ_SOFTBARRIER when requeueing.  This patch makes
	scsi_queue_insert() use blk_requeue_request().  As REQ_SPECIAL
	means special requests and REQ_SOFTBARRIER is automatically
	handled by blk layer now, no flag needs to be set.

	Note that scsi_queue_insert() now calls scsi_run_queue()
	itself, and the prototype of the function is added right above
	scsi_queue_insert().  This is temporary, as later requeue path
	consolidation patchset removes scsi_queue_insert().  By adding
	temporary prototype, we can do away with unnecessarily moving
	functions.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_lib.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

Index: scsi-reqfn-export/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_lib.c	2005-04-20 08:13:34.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_lib.c	2005-04-20 08:13:34.000000000 +0900
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
@@ -154,17 +158,14 @@ int scsi_queue_insert(struct scsi_cmnd *
 	scsi_device_unbusy(device);
 
 	/*
-	 * Insert this command at the head of the queue for it's device.
-	 * It will go before all other commands that are already in the queue.
-	 *
-	 * NOTE: there is magic here about the way the queue is plugged if
-	 * we have no outstanding commands.
-	 * 
-	 * Although this *doesn't* plug the queue, it does call the request
-	 * function.  The SCSI request function detects the blocked condition
-	 * and plugs the queue appropriately.
+	 * Requeue the command.
 	 */
-	blk_insert_request(device->request_queue, cmd->request, 1, cmd, 1);
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_requeue_request(q, cmd->request);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	scsi_run_queue(q);
+
 	return 0;
 }
 
