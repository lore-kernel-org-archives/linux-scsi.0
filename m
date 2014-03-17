From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/39] scsi: avoid taking host_lock in scsi_run_queue unless nessecary
Date: Mon, 17 Mar 2014 06:27:41 -0700
Message-ID: <20140317133132.655867077@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0008-scsi-avoid-taking-host_lock-in-scsi_run_queue-unless.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If we don't have starved devices we don't need to take the host lock
to iterate over them.  Also split the function up to be more clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 62ec84b..aa6a581 100644
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
