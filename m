From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/3] sd: Disable discard_zeroes_data for UNMAP
Date: Fri,  7 Nov 2014 00:08:13 -0500
Message-ID: <1415336894-15327-3-git-send-email-martin.petersen@oracle.com>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

The T10 SBC UNMAP command does not provide any hard guarantees that
blocks will return zeroes on a subsequent READ. This is due to the fact
that the device server is free to silently ignore all or parts of the
request.

The only way to ensure that a block consistently returns zeroes after
being unmapped is to use WRITE SAME with the UNMAP bit set. Should the
device be unable to unmap one or more blocks described by the command it
is required to manually write zeroes to them.

Until now we have preferred UNMAP over the WRITE SAME variants to
accommodate thinly provisioned devices that predated the final SBC-3
spec. This patch changes the heuristic so that we favor WRITE SAME(16)
or (10) over UNMAP if these commands are marked as supported in the
Logical Block Provisioning VPD page.

The patch also disables discard_zeroes_data for devices operating in
UNMAP mode.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b041eca8955d..95bfb7bfbb9d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -656,7 +656,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	unsigned int logical_block_size = sdkp->device->sector_size;
 	unsigned int max_blocks = 0;
 
-	q->limits.discard_zeroes_data = sdkp->lbprz;
+	q->limits.discard_zeroes_data = 0;
 	q->limits.discard_alignment = sdkp->unmap_alignment *
 		logical_block_size;
 	q->limits.discard_granularity =
@@ -680,11 +680,13 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	case SD_LBP_WS16:
 		max_blocks = min_not_zero(sdkp->max_ws_blocks,
 					  (u32)SD_MAX_WS16_BLOCKS);
+		q->limits.discard_zeroes_data = sdkp->lbprz;
 		break;
 
 	case SD_LBP_WS10:
 		max_blocks = min_not_zero(sdkp->max_ws_blocks,
 					  (u32)SD_MAX_WS10_BLOCKS);
+		q->limits.discard_zeroes_data = sdkp->lbprz;
 		break;
 
 	case SD_LBP_ZERO:
@@ -2622,12 +2624,12 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 
 		} else {	/* LBP VPD page tells us what to use */
 
-			if (sdkp->lbpu && sdkp->max_unmap_blocks)
-				sd_config_discard(sdkp, SD_LBP_UNMAP);
-			else if (sdkp->lbpws)
+			if (sdkp->lbpws)
 				sd_config_discard(sdkp, SD_LBP_WS16);
 			else if (sdkp->lbpws10)
 				sd_config_discard(sdkp, SD_LBP_WS10);
+			else if (sdkp->lbpu && sdkp->max_unmap_blocks)
+				sd_config_discard(sdkp, SD_LBP_UNMAP);
 			else
 				sd_config_discard(sdkp, SD_LBP_DISABLE);
 		}
-- 
1.9.3

