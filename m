From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] scsi: remove scsi_next_command
Date: Thu,  6 Nov 2014 08:40:26 +0100
Message-ID: <1415259630-20784-3-git-send-email-hch@lst.de>
References: <1415259630-20784-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51535 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaKFHk1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 02:40:27 -0500
In-Reply-To: <1415259630-20784-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>

There's only one caller left, so inline it and reduce the blk-mq vs !blk-mq
diff a litte bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 18 ++++--------------
 drivers/scsi/scsi_priv.h |  1 -
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 38f8c85..1a3546e8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -543,17 +543,6 @@ static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
 	put_device(&sdev->sdev_gendev);
 }
 
-void scsi_next_command(struct scsi_cmnd *cmd)
-{
-	struct scsi_device *sdev = cmd->device;
-	struct request_queue *q = sdev->request_queue;
-
-	scsi_put_command(cmd);
-	scsi_run_queue(q);
-
-	put_device(&sdev->sdev_gendev);
-}
-
 void scsi_run_host_queues(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
@@ -731,8 +720,6 @@ static bool scsi_end_request(struct request *req, int error,
 			kblockd_schedule_work(&sdev->requeue_work);
 		else
 			blk_mq_start_stopped_hw_queues(q, true);
-
-		put_device(&sdev->sdev_gendev);
 	} else {
 		unsigned long flags;
 
@@ -744,9 +731,12 @@ static bool scsi_end_request(struct request *req, int error,
 		spin_unlock_irqrestore(q->queue_lock, flags);
 
 		scsi_release_buffers(cmd);
-		scsi_next_command(cmd);
+
+		scsi_put_command(cmd);
+		scsi_run_queue(q);
 	}
 
+	put_device(&sdev->sdev_gendev);
 	return false;
 }
 
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 12b8e1b..2a382c1 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -84,7 +84,6 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd);
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_device_unbusy(struct scsi_device *sdev);
 extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
-extern void scsi_next_command(struct scsi_cmnd *cmd);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
-- 
1.9.1

