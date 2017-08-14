From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 3/6] hpsa: Ignore errors for unsupported LV_DEVICE_ID VPD page
Date: Mon, 14 Aug 2017 13:19:12 +0200
Message-ID: <1502709555-15837-4-git-send-email-hare@suse.de>
References: <1502709555-15837-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54214 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752342AbdHNLTV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Aug 2017 07:19:21 -0400
In-Reply-To: <1502709555-15837-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Legacy boards might not support the LV_DEVICE_ID VPD page, so
we shouldn't print out an error message here.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0b0b6dc..b34ec42 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3827,7 +3827,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
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
