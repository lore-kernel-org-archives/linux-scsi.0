From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] move max_sectors intitalization fully to scsi_register
Date: Sun, 27 Apr 2003 17:18:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030427171855.A29698@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:24845 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S264676AbTD0PGn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 11:06:43 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Addresses the fixme in scsi_alloc_queue.


--- 1.57/drivers/scsi/hosts.c	Tue Apr 15 13:20:37 2003
+++ edited/drivers/scsi/hosts.c	Sun Apr 27 13:26:36 2003
@@ -424,8 +424,14 @@
 	shost->use_clustering = shost_tp->use_clustering;
 	if (!blk_nohighio)
 		shost->highmem_io = shost_tp->highmem_io;
-
-	shost->max_sectors = shost_tp->max_sectors;
+	if (!shost_tp->max_sectors) {
+		/*
+		 * Driver imposes no hard sector transfer limit.
+		 * start at machine infinity initially.
+		 */
+		shost->max_sectors = SCSI_DEFAULT_MAX_SECTORS;
+	} else
+		shost->max_sectors = shost_tp->max_sectors;
 	shost->use_blk_tcq = shost_tp->use_blk_tcq;
 
 	spin_lock(&scsi_host_list_lock);
--- 1.84/drivers/scsi/scsi_lib.c	Mon Apr 21 10:17:33 2003
+++ edited/drivers/scsi/scsi_lib.c	Sun Apr 27 14:19:35 2003
@@ -1257,28 +1236,15 @@
 	return BLK_BOUNCE_HIGH;
 }
 
-request_queue_t *scsi_alloc_queue(struct scsi_device *sdev)
+struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 {
-	request_queue_t *q;
-	struct Scsi_Host *shost;
+	struct Scsi_Host *shost = sdev->host;
+	struct request_queue *q = kmalloc(sizeof(*q), GFP_ATOMIC);
 
-	q = kmalloc(sizeof(*q), GFP_ATOMIC);
 	if (!q)
 		return NULL;
 	memset(q, 0, sizeof(*q));
 
-	/*
-	 * XXX move host code to scsi_register
-	 */
-	shost = sdev->host;
-	if (!shost->max_sectors) {
-		/*
-		 * Driver imposes no hard sector transfer limit.
-		 * start at machine infinity initially.
-		 */
-		shost->max_sectors = SCSI_DEFAULT_MAX_SECTORS;
-	}
-
 	blk_init_queue(q, scsi_request_fn, &sdev->sdev_lock);
 	blk_queue_prep_rq(q, scsi_prep_fn);
 
@@ -1289,11 +1255,10 @@
 
 	if (!shost->use_clustering)
 		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
-
 	return q;
 }
 
-void scsi_free_queue(request_queue_t *q)
+void scsi_free_queue(struct request_queue *q)
 {
 	blk_cleanup_queue(q);
 	kfree(q);
