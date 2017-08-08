From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/6] hpsa: disable volume status check for older controller
Date: Tue,  8 Aug 2017 10:35:12 +0200
Message-ID: <1502181315-102499-4-git-send-email-hare@suse.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751927AbdHHIfU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Aug 2017 04:35:20 -0400
In-Reply-To: <1502181315-102499-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Older Controller might not support volume status, so assume
the volume is online here.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7ca6078..4ebf5d4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3832,6 +3832,17 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		if (h->fw_support & MISC_FW_RAID_OFFLOAD_BASIC)
 			hpsa_get_ioaccel_status(h, scsi3addr, this_device);
 		volume_offline = hpsa_volume_offline(h, scsi3addr);
+		if (volume_offline == HPSA_VPD_LV_STATUS_UNSUPPORTED &&
+		    !h->supported) {
+			/*
+			 * Older / unsupported controllers might not support
+			 * volume status
+			 */
+			dev_info(&h->pdev->dev,
+				 "C0:T%d:L%d Volume status not available, assuming online.\n",
+				 this_device->target, this_device->lun);
+			volume_offline = 0;
+		}
 		this_device->volume_offline = volume_offline;
 		if (volume_offline == HPSA_LV_FAILED) {
 			rc = HPSA_LV_FAILED;
-- 
1.8.5.6
