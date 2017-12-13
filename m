From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: check for device state in __scsi_remove_target()
Date: Wed, 13 Dec 2017 14:21:37 +0100
Message-ID: <1513171297-58020-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54137 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752888AbdLMNVk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Dec 2017 08:21:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

As it turned out device_get() doesn't use kref_get_unless_zero(),
so we will be always getting a device pointer.
So we need to check for the device state in __scsi_remove_target()
to avoid tripping over deleted objects.

Fixes: fbce4d9 ("scsi: fixup kernel warning during rmmod()")

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_sysfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index cbc0fe2..a04678b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1411,7 +1411,10 @@ static void __scsi_remove_target(struct scsi_target *starget)
 		 * check.
 		 */
 		if (sdev->channel != starget->channel ||
-		    sdev->id != starget->id ||
+		    sdev->id != starget->id)
+			continue;
+		if (sdev->sdev_state == SDEV_DEL ||
+		    sdev->sdev_state == SDEV_CANCEL ||
 		    !get_device(&sdev->sdev_gendev))
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
-- 
1.8.5.6
