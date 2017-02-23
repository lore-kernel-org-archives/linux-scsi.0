From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2] hpsa: expose enclosures
Date: Thu, 23 Feb 2017 11:55:03 +0100
Message-ID: <1487847303-82580-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37165 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751017AbdBWLNz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Feb 2017 06:13:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Don Brace <don.brace@microsemi.com>, Hannes Reinecke <hare@suse.com>

Some servers have a built-in enclosure which will show up on the
same bus as the internal physical devices. This patch fixes the
driver to expose them.

Cc: Don Brace <don.brace@microsemi.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 524a0c7..a77ed5a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4407,7 +4407,10 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 		 * Expose all devices except for physical devices that
 		 * are masked.
 		 */
-		if (MASKED_DEVICE(lunaddrbytes) && this_device->physical_device)
+		if (this_device->devtype == TYPE_ENCLOSURE)
+			this_device->expose_device = 1;
+		else if (MASKED_DEVICE(lunaddrbytes) &&
+			 this_device->physical_device)
 			this_device->expose_device = 0;
 		else
 			this_device->expose_device = 1;
-- 
1.8.5.6
