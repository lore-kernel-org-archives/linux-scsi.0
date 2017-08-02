From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] hpsa: disable volume status check for older controller
Date: Wed,  2 Aug 2017 17:05:56 +0200
Message-ID: <1501686356-56888-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42386 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752473AbdHBPGA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Aug 2017 11:06:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Older Controller might not support volume status, so disable
it if 'hpsa_allow_any' is present.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 2cf6ccc..bd063b8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3831,6 +3831,17 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		if (h->fw_support & MISC_FW_RAID_OFFLOAD_BASIC)
 			hpsa_get_ioaccel_status(h, scsi3addr, this_device);
 		volume_offline = hpsa_volume_offline(h, scsi3addr);
+		if (volume_offline == HPSA_VPD_LV_STATUS_UNSUPPORTED &&
+		    hpsa_allow_any) {
+			/*
+			 * Older controllers do not support
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
