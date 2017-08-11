From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 1/2] scsi_lib: rework scsi_internal_device_unblock_nowait()
Date: Fri, 11 Aug 2017 08:53:46 +0200
Message-ID: <1502434427-101729-2-git-send-email-hare@suse.de>
References: <1502434427-101729-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51555 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751299AbdHKGxu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Aug 2017 02:53:50 -0400
In-Reply-To: <1502434427-101729-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Rework scsi_internal_device_unblock_nowait() into using a
switch statement.
No functional changes.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_lib.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1ae531b..9169396 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3074,19 +3074,24 @@ int scsi_internal_device_unblock_nowait(struct scsi_device *sdev,
 	 * Try to transition the scsi device to SDEV_RUNNING or one of the
 	 * offlined states and goose the device queue if successful.
 	 */
-	if ((sdev->sdev_state == SDEV_BLOCK) ||
-	    (sdev->sdev_state == SDEV_TRANSPORT_OFFLINE))
+	switch (sdev->sdev_state) {
+	case SDEV_BLOCK:
+	case SDEV_TRANSPORT_OFFLINE:
 		sdev->sdev_state = new_state;
-	else if (sdev->sdev_state == SDEV_CREATED_BLOCK) {
+		break;
+	case SDEV_CREATED_BLOCK:
 		if (new_state == SDEV_TRANSPORT_OFFLINE ||
 		    new_state == SDEV_OFFLINE)
 			sdev->sdev_state = new_state;
 		else
 			sdev->sdev_state = SDEV_CREATED;
-	} else if (sdev->sdev_state != SDEV_CANCEL &&
-		 sdev->sdev_state != SDEV_OFFLINE)
+		break;
+	case SDEV_CANCEL:
+	case SDEV_OFFLINE:
+		break;
+	default:
 		return -EINVAL;
-
+	}
 	scsi_start_queue(sdev);
 
 	return 0;
-- 
1.8.5.6
