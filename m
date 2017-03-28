From: Fam Zheng <famz@redhat.com>
Subject: [PATCH v2] sd: Consider max_xfer_blocks if opt_xfer_blocks is unusable
Date: Tue, 28 Mar 2017 12:41:26 +0800
Message-ID: <20170328044126.10006-1-famz@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750707AbdC1Eli (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Mar 2017 00:41:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, famz@redhat.com, linux-scsi@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

If device reports a small max_xfer_blocks and a zero opt_xfer_blocks, we
end up using BLK_DEF_MAX_SECTORS, which is wrong and r/w of that size
may get error.

Fixes: ca369d51b3e ("block/sd: Fix device-imposed transfer length limits")
Signed-off-by: Fam Zheng <famz@redhat.com>

---

v2: Fix granularity mismatch. [Martin]
---
 drivers/scsi/sd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fcfeddc..a5c7e67 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2957,6 +2957,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
 	} else
 		rw_max = BLK_DEF_MAX_SECTORS;
+	rw_max = min_not_zero(rw_max, logical_to_sectors(sdp, dev_max));
 
 	/* Combine with controller limits */
 	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
-- 
2.9.3
