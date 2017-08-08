From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/6] hpsa: Ignore errors for unsupported LV_DEVICE_ID VPD page
Date: Tue,  8 Aug 2017 10:35:13 +0200
Message-ID: <1502181315-102499-5-git-send-email-hare@suse.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51881 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751868AbdHHIfS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Aug 2017 04:35:18 -0400
In-Reply-To: <1502181315-102499-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Older controller do not support the LV_DEVICE_ID VPD page, so
we shouldn't print out an error message here.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4ebf5d4..dbd5fbc 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3814,7 +3814,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 	memset(this_device->device_id, 0,
 		sizeof(this_device->device_id));
 	if (hpsa_get_device_id(h, scsi3addr, this_device->device_id, 8,
-		sizeof(this_device->device_id)))
+		sizeof(this_device->device_id) < 0))
 		dev_err(&h->pdev->dev,
 			"hpsa%d: %s: can't get device id for host %d:C0:T%d:L%d\t%s\t%.16s\n",
 			h->ctlr, __func__,
-- 
1.8.5.6
