From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_dh: only attach to SCSI devices
Date: Thu, 16 Feb 2017 08:33:14 +0100
Message-ID: <1487230394-84552-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59330 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752712AbdBPHdW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 02:33:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@inter.com>, linux-scsi@vger.kernel.org, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Any device might be setting a queuedata structure, so we need to
check if the queuedata really belongs to a SCSI device before
proceeding.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_dh.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index b8d3b97..da104ed 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -226,7 +226,9 @@ static struct scsi_device *get_sdev_from_queue(struct request_queue *q)
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	sdev = q->queuedata;
-	if (!sdev || !get_device(&sdev->sdev_gendev))
+	if (!sdev ||
+	    !scsi_is_sdev_device(&sdev->sdev_gendev) ||
+	    !get_device(&sdev->sdev_gendev))
 		sdev = NULL;
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-- 
1.8.5.6
