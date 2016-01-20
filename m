From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Optimal I/O size is in bytes, not sectors
Date: Wed, 20 Jan 2016 11:01:23 -0500
Message-ID: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50695 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934624AbcATQBb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2016 11:01:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: borntraeger@de.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>

Commit ca369d51b3e1 ("block/sd: Fix device-imposed transfer length
limits") accidentally switched optimal I/O size reporting from bytes to
block layer sectors.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4e08d1cd704d..ec163d08f6c3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2893,7 +2893,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS &&
 	    sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_CACHE_SIZE)
 		rw_max = q->limits.io_opt =
-			logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
+			sdkp->opt_xfer_blocks * sdp->sector_size;
 	else
 		rw_max = BLK_DEF_MAX_SECTORS;
 
-- 
2.5.0

