From: Long Li <longli@microsoft.com>
Subject: [PATCH] Use the correct size to set block max sectors
Date: Thu, 26 May 2016 17:08:28 -0700
Message-ID: <1464307708-4315-1-git-send-email-longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The block sector size should be in unit of 512 bytes, not in bytes.

Signed-off-by: Long Li <longli@microsoft.com>

---
 drivers/scsi/sd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 428c03e..4bce17e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2862,9 +2862,11 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	if (sdkp->opt_xfer_blocks &&
 	    sdkp->opt_xfer_blocks <= dev_max &&
 	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS &&
-	    sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_SIZE)
-		rw_max = q->limits.io_opt =
+	    sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_SIZE) {
+		q->limits.io_opt =
 			sdkp->opt_xfer_blocks * sdp->sector_size;
+		rw_max = (q->limits.io_opt >> 9);
+	}
 	else
 		rw_max = BLK_DEF_MAX_SECTORS;
 
-- 
1.8.5.6
