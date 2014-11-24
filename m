From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] scsi: never drop to untagged mode during queue ramp down
Date: Mon, 24 Nov 2014 15:36:19 +0100
Message-ID: <1416839781-26988-3-git-send-email-hch@lst.de>
References: <1416839781-26988-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46868 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306AbaKXOgd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 09:36:33 -0500
In-Reply-To: <1416839781-26988-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>

Dropping to untagged mode when ramping down a queue due to QUEUE FULL
events has two problems:

 - nothing in the midlayer or drivers ever moves back to tagged mode
   during queue ramp up.
 - cmd_per_lun isn't the untagged queue depth for many modern drivers
   that can handle multiple untagged commands, and this is the only
   place in the midlayer assuming that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 72282ae..6b0d524 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -820,12 +820,6 @@ int scsi_track_queue_full(struct scsi_device *sdev, int depth)
 
 	if (sdev->last_queue_full_count <= 10)
 		return 0;
-	if (sdev->last_queue_full_depth < 8) {
-		/* Drop back to untagged */
-		scsi_set_tag_type(sdev, 0);
-		scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun);
-		return -1;
-	}
 
 	return scsi_change_queue_depth(sdev, depth);
 }
-- 
1.9.1

