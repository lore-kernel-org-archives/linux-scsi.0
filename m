From: Fam Zheng <famz@redhat.com>
Subject: [PATCH] sd: Consider max_xfer_blocks if opt_xfer_blocks is unusable
Date: Mon, 27 Mar 2017 22:18:31 +0800
Message-ID: <20170327141831.20936-1-famz@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53236 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752059AbdC0OTD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Mar 2017 10:19:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, famz@redhat.com, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

If device reports a small max_xfer_blocks and a zero opt_xfer_blocks, we
end up using BLK_DEF_MAX_SECTORS, which is wrong and r/w of that size
may get error.

Fixes: ca369d51b3e ("block/sd: Fix device-imposed transfer length limits")
Signed-off-by: Fam Zheng <famz@redhat.com>
---
 drivers/scsi/sd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fcfeddc..e2e21ab 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2957,6 +2957,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
 	} else
 		rw_max = BLK_DEF_MAX_SECTORS;
+	rw_max = min_not_zero(rw_max, dev_max);
 
 	/* Combine with controller limits */
 	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
-- 
2.9.3
