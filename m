From: Jens Axboe <axboe@suse.de>
Subject: queue <-> sdev reference counting problem
Date: Fri, 18 Mar 2005 12:36:10 +0100
Message-ID: <20050318113609.GC1821@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ns.virtualhost.dk ([195.184.98.160]:31416 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261582AbVCRLgM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2005 06:36:12 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>

Hi,

There is a problem with the way sdev is freed currently. The reason is
really that there is a circular referencing problem: the sdev needs to
hold on to the queue, but the queue (through the request function) also
needs to hold on to the sdev.

The easiest way to work-around this problem is to kill the sdev
reference in the queue when the sdev is freed. On invocation of
scsi_request_fn(), kill io to this device.

Signed-off-by: Jens Axboe <axboe@suse.de>

===== drivers/scsi/scsi_lib.c 1.151 vs edited =====
--- 1.151/drivers/scsi/scsi_lib.c	2005-02-17 20:17:22 +01:00
+++ edited/drivers/scsi/scsi_lib.c	2005-03-18 12:33:09 +01:00
@@ -1233,6 +1233,22 @@ static inline int scsi_host_queue_ready(
 }
 
 /*
+ * Kill requests for a dead device
+ */
+static void scsi_kill_requests(request_queue_t *q)
+{
+	struct request *req;
+
+	while ((req = elv_next_request(q)) != NULL) {
+		blkdev_dequeue_request(req);
+		req->flags |= REQ_QUIET;
+		while (end_that_request_first(req, 0, req->nr_sectors))
+			;
+		end_that_request_last(req);
+	}
+}
+
+/*
  * Function:    scsi_request_fn()
  *
  * Purpose:     Main strategy routine for SCSI.
@@ -1246,10 +1262,16 @@ static inline int scsi_host_queue_ready(
 static void scsi_request_fn(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
-	struct Scsi_Host *shost = sdev->host;
+	struct Scsi_Host *shost;
 	struct scsi_cmnd *cmd;
 	struct request *req;
 
+	if (!sdev) {
+		printk("scsi: killing requests for dead queue\n");
+		scsi_kill_requests(q);
+		return;
+	}
+
 	if(!get_device(&sdev->sdev_gendev))
 		/* We must be tearing the block queue down already */
 		return;
@@ -1258,6 +1280,7 @@ static void scsi_request_fn(struct reque
 	 * To start with, we keep looping until the queue is empty, or until
 	 * the host is no longer able to accept any more requests.
 	 */
+	shost = sdev->host;
 	while (!blk_queue_plugged(q)) {
 		int rtn;
 		/*
===== drivers/scsi/scsi_sysfs.c 1.69 vs edited =====
--- 1.69/drivers/scsi/scsi_sysfs.c	2005-02-17 02:05:37 +01:00
+++ edited/drivers/scsi/scsi_sysfs.c	2005-03-18 12:32:57 +01:00
@@ -168,8 +168,10 @@ void scsi_device_dev_release(struct devi
 	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
-	if (sdev->request_queue)
+	if (sdev->request_queue) {
+		sdev->request_queue->queuedata = NULL;
 		scsi_free_queue(sdev->request_queue);
+	}
 
 	scsi_target_reap(scsi_target(sdev));
 

-- 
Jens Axboe

