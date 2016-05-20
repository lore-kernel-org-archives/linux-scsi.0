From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Fix rw_max for devices that report an optimal xfer size
Date: Thu, 19 May 2016 23:16:34 -0400
Message-ID: <1463714194-14258-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25376 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbcETDQs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2016 23:16:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org#4.4+

For historic reasons, io_opt is in bytes and max_sectors in block layer
sectors. This interface inconsistency is error prone and should be
fixed. But for 4.4--4.7 let's make the unit difference explicit via a
wrapper function.

Fixes: d0eb20a863ba ("sd: Optimal I/O size is in bytes, not sectors")
Cc: stable@vger.kernel.org # 4.4+
Reported-by: Fam Zheng <famz@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 8 ++++----
 drivers/scsi/sd.h | 5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f459dff30512..60bff78e9ead 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2867,10 +2867,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	if (sdkp->opt_xfer_blocks &&
 	    sdkp->opt_xfer_blocks <= dev_max &&
 	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS &&
-	    sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_SIZE)
-		rw_max = q->limits.io_opt =
-			sdkp->opt_xfer_blocks * sdp->sector_size;
-	else
+	    logical_to_bytes(sdp, sdkp->opt_xfer_blocks) >= PAGE_SIZE) {
+		q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
+		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
+	} else
 		rw_max = BLK_DEF_MAX_SECTORS;
 
 	/* Combine with controller limits */
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 654630bb7d0e..765a6f1ac1b7 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -151,6 +151,11 @@ static inline sector_t logical_to_sectors(struct scsi_device *sdev, sector_t blo
 	return blocks << (ilog2(sdev->sector_size) - 9);
 }
 
+static inline unsigned int logical_to_bytes(struct scsi_device *sdev, sector_t blocks)
+{
+	return blocks * sdev->sector_size;
+}
+
 /*
  * A DIF-capable target device can be formatted with different
  * protection schemes.  Currently 0 through 3 are defined:
-- 
2.7.4

