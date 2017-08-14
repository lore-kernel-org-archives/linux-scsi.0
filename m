From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 2/6] hpsa: disable volume status check for legacy boards
Date: Mon, 14 Aug 2017 13:19:11 +0200
Message-ID: <1502709555-15837-3-git-send-email-hare@suse.de>
References: <1502709555-15837-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54218 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752706AbdHNLTV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Aug 2017 07:19:21 -0400
In-Reply-To: <1502709555-15837-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Legacy boards might not support volume status, so assume
the volume is online here.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Acked-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index fbe7fbc..0b0b6dc 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3845,6 +3845,16 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		if (h->fw_support & MISC_FW_RAID_OFFLOAD_BASIC)
 			hpsa_get_ioaccel_status(h, scsi3addr, this_device);
 		volume_offline = hpsa_volume_offline(h, scsi3addr);
+		if (volume_offline == HPSA_VPD_LV_STATUS_UNSUPPORTED &&
+		    h->legacy_board) {
+			/*
+			 * Legacy boards might not support volume status
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
