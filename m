From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Make discard granularity match logical block size when LBPRZ=1
Date: Tue, 11 Aug 2015 19:07:34 -0400
Message-ID: <1439334454-28754-1-git-send-email-martin.petersen@oracle.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

A device may report an OPTIMAL UNMAP GRANULARITY and UNMAP GRANULARITY
ALIGNMENT in the Block Limits VPD. These parameters describe the
device's internal provisioning allocation units. By default the block
layer will round and align any discard requests based on these limits.

If a device reports LBPRZ=1 to guarantee zeroes after discard, however,
it is imperative that the block layer does not leave out any parts of
the requested block range. Otherwise the device can not do the required
zeroing of any partial allocation units and this can lead to data
corruption.

Since the dm thinp personality relies on the block layer's current
behavior and is unable to deal with partial discard blocks we work
around the problem by setting the granularity to match the logical block
size when LBPRZ is enabled.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/sd.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a20da8c25b4f..14e7cd763233 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -636,11 +636,24 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	unsigned int max_blocks = 0;
 
 	q->limits.discard_zeroes_data = 0;
-	q->limits.discard_alignment = sdkp->unmap_alignment *
-		logical_block_size;
-	q->limits.discard_granularity =
-		max(sdkp->physical_block_size,
-		    sdkp->unmap_granularity * logical_block_size);
+
+	/*
+	 * When LBPRZ is set, discard alignment and granularity must be
+	 * fixed to the logical block size. Otherwise the block layer
+	 * will drop misaligned portions of the request which can lead
+	 * to data corruption. If LBPRZ is not set, we honor the device
+	 * preference.
+	 */
+	if (sdkp->lbprz) {
+		q->limits.discard_alignment = 0;
+		q->limits.discard_granularity = 1;
+	} else {
+		q->limits.discard_alignment = sdkp->unmap_alignment *
+			logical_block_size;
+		q->limits.discard_granularity =
+			max(sdkp->physical_block_size,
+			    sdkp->unmap_granularity * logical_block_size);
+	}
 
 	sdkp->provisioning_mode = mode;
 
-- 
2.4.3
