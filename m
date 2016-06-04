From: Long Li <longli@microsoft.com>
Subject: [PATCH] sd: remove redundant check for BLK_DEF_MAX_SECTORS
Date: Fri,  3 Jun 2016 20:57:58 -0700
Message-ID: <1465012678-32547-1-git-send-email-longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Long Li <longli@microsoft.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

q->limits.max_sectors is already checked against BLK_DEF_MAX_SECTORS in __scsi_alloc_queue(), when it calls blk_queue_max_hw_sectors(). There is no need to check it again in sd.

This change also allows a SCSI driver set an maximum sector size bigger than BLK_DEF_MAX_SECTORS, without returning values on optional VPD page 0xb0 "Block Limits".

Signed-off-by: Long Li <longli@microsoft.com>

---
 drivers/scsi/sd.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 60bff78..d8c4047 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2870,11 +2870,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	    logical_to_bytes(sdp, sdkp->opt_xfer_blocks) >= PAGE_SIZE) {
 		q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
 		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
-	} else
-		rw_max = BLK_DEF_MAX_SECTORS;
-
-	/* Combine with controller limits */
-	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
+		q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
+	}
 
 	set_capacity(disk, logical_to_sectors(sdp, sdkp->capacity));
 	sd_config_write_same(sdkp);
-- 
2.7.4
