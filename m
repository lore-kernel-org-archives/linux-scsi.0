From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/9] scsi: avoid taking host_lock in scsi_run_queue unless nessecary
Date: Thu, 20 Feb 2014 14:20:54 -0800
Message-ID: <20140220222356.899671950@bombadil.infradead.org>
References: <20140220222052.717958451@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58121 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbaBTWX5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 17:23:57 -0500
Content-Disposition: inline; filename=0002-scsi-avoid-taking-host_lock-in-scsi_run_queue-unless.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org

If we don't have starved devices we don't need to take the host lock
to iterate over them.  Also split the function up to be more clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7bd7f0d..ad516c0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -385,29 +385,12 @@ static inline int scsi_host_is_busy(struct Scsi_Host *shost)
 	return 0;
 }
 
-/*
- * Function:	scsi_run_queue()
- *
- * Purpose:	Select a proper request queue to serve next
- *
- * Arguments:	q	- last request's queue
- *
- * Returns:     Nothing
- *
- * Notes:	The previous command was completely finished, start
- *		a new one if possible.
- */
-static void scsi_run_queue(struct request_queue *q)
+static void scsi_starved_list_run(struct Scsi_Host *shost)
 {
-	struct scsi_device *sdev = q->queuedata;
-	struct Scsi_Host *shost;
 	LIST_HEAD(starved_list);
+	struct scsi_device *sdev;
 	unsigned long flags;
 
-	shost = sdev->host;
-	if (scsi_target(sdev)->single_lun)
-		scsi_single_lun_run(sdev);
-
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_splice_init(&shost->starved_list, &starved_list);
 
@@ -459,6 +442,28 @@ static void scsi_run_queue(struct request_queue *q)
 	/* put any unprocessed entries back */
 	list_splice(&starved_list, &shost->starved_list);
 	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
+/*
+ * Function:   scsi_run_queue()
+ *
+ * Purpose:    Select a proper request queue to serve next
+ *
+ * Arguments:  q       - last request's queue
+ *
+ * Returns:     Nothing
+ *
+ * Notes:      The previous command was completely finished, start
+ *             a new one if possible.
+ */
+static void scsi_run_queue(struct request_queue *q)
+{
+	struct scsi_device *sdev = q->queuedata;
+
+	if (scsi_target(sdev)->single_lun)
+		scsi_single_lun_run(sdev);
+	if (!list_empty(&sdev->host->starved_list))
+		scsi_starved_list_run(sdev->host);
 
 	blk_run_queue(q);
 }
-- 
1.7.10.4


