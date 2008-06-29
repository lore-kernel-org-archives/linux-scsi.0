From: Elias Oltmanns <eo@nebensachen.de>
Subject: [PATCH] SCSI: Fix some locking issues
Date: Sun, 29 Jun 2008 13:38:05 +0200
Message-ID: <877ic8o4iq.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:45362 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428AbYF2LlS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2008 07:41:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: stable@kernel.org

Hi all,

the following patch applies to 2.6.26-rc8. However, the same issues
exist in the 2.6.25.y stable tree and the patch applies with offsets to
2.6.25.9; I haven't checked 2.6.24 and before.

Regards,

Elias


From: Elias Oltmanns <eo@nebensachen.de>
Subject: SCSI: Fix some locking issues

Make sure that host_blocked is consistently protected by the host_lock.
Similarly, device_block has to be protected by the queue_lock.  Also,
blk_plug_device() has to be called with the queue_lock held in
scsi_host_queue_ready().

Cc: stable@kernel.org
Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/scsi/scsi.c     |    6 ++++++
 drivers/scsi/scsi_lib.c |   13 +++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 110e776..b8b7982 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -826,8 +826,10 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
 	struct Scsi_Host *shost = sdev->host;
+	struct request_queue *q = sdev->request_queue;
 	struct scsi_driver *drv;
 	unsigned int good_bytes;
+	unsigned long flags;
 
 	scsi_device_unbusy(sdev);
 
@@ -839,8 +841,12 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 	 *
 	 * XXX(hch): What about locking?
          */
+	spin_lock_irqsave(shost->host_lock, flags);
         shost->host_blocked = 0;
+	spin_unlock(shost->host_lock);
+	spin_lock(q->queue_lock);
         sdev->device_blocked = 0;
+	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	/*
 	 * If we have valid sense information, then some kind of recovery
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a82d2fe..65d0c39 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -133,10 +133,15 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	 * if a command is requeued with no other commands outstanding
 	 * either for the device or for the host.
 	 */
-	if (reason == SCSI_MLQUEUE_HOST_BUSY)
+	if (reason == SCSI_MLQUEUE_HOST_BUSY) {
+		spin_lock_irqsave(host->host_lock, flags);
 		host->host_blocked = host->max_host_blocked;
-	else if (reason == SCSI_MLQUEUE_DEVICE_BUSY)
+		spin_unlock_irqrestore(host->host_lock, flags);
+	} else if (reason == SCSI_MLQUEUE_DEVICE_BUSY) {
+		spin_lock_irqsave(q->queue_lock, flags);
 		device->device_blocked = device->max_device_blocked;
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	}
 
 	/*
 	 * Decrement the counters, since these commands are no longer
@@ -1320,7 +1325,11 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 				printk("scsi%d unblocking host at zero depth\n",
 					shost->host_no));
 		} else {
+			spin_unlock(shost->host_lock);
+			spin_lock(q->queue_lock);
 			blk_plug_device(q);
+			spin_unlock(q->queue_lock);
+			spin_lock(shost->host_lock);
 			return 0;
 		}
 	}
