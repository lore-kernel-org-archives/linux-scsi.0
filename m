From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/2] scsi: sd: Remove LBPRZ dependency for discards
Date: Wed,  5 Apr 2017 07:41:11 -0400
Message-ID: <20170405114111.26864-2-martin.petersen@oracle.com>
References: <20170405114111.26864-1-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23443 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933600AbdDELl1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 07:41:27 -0400
In-Reply-To: <20170405114111.26864-1-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>

Separating discards and zeroout operations allows us to remove the LBPRZ
block zeroing constraints from discards and honor the device preferences
for UNMAP commands.

If supported by the device, we'll also choose UNMAP over one of the
WRITE SAME variants for discards.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index acf9d17b05d8..8cf34a8e3eea 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -685,24 +685,11 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	unsigned int logical_block_size = sdkp->device->sector_size;
 	unsigned int max_blocks = 0;
 
-	/*
-	 * When LBPRZ is reported, discard alignment and granularity
-	 * must be fixed to the logical block size. Otherwise the block
-	 * layer will drop misaligned portions of the request which can
-	 * lead to data corruption. If LBPRZ is not set, we honor the
-	 * device preference.
-	 */
-	if (sdkp->lbprz) {
-		q->limits.discard_alignment = 0;
-		q->limits.discard_granularity = logical_block_size;
-	} else {
-		q->limits.discard_alignment = sdkp->unmap_alignment *
-			logical_block_size;
-		q->limits.discard_granularity =
-			max(sdkp->physical_block_size,
-			    sdkp->unmap_granularity * logical_block_size);
-	}
-
+	q->limits.discard_alignment =
+		sdkp->unmap_alignment * logical_block_size;
+	q->limits.discard_granularity =
+		max(sdkp->physical_block_size,
+		    sdkp->unmap_granularity * logical_block_size);
 	sdkp->provisioning_mode = mode;
 
 	switch (mode) {
@@ -2842,7 +2829,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 				sd_config_discard(sdkp, SD_LBP_WS16);
 
 		} else {	/* LBP VPD page tells us what to use */
-			if (sdkp->lbpu && sdkp->max_unmap_blocks && !sdkp->lbprz)
+			if (sdkp->lbpu && sdkp->max_unmap_blocks)
 				sd_config_discard(sdkp, SD_LBP_UNMAP);
 			else if (sdkp->lbpws)
 				sd_config_discard(sdkp, SD_LBP_WS16);
-- 
2.12.0
