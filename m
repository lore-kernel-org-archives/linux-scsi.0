From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V7 8/8] scsi: sd_zbc: Fix zone information initialization
Date: Wed,  8 Nov 2017 17:11:18 +0900
Message-ID: <20171108081118.7632-9-damien.lemoal@wdc.com>
References: <20171108081118.7632-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171108081118.7632-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Make sure that the device request queue zone information (number of
zones and zone bitmaps) are reinitialized if the number of zones
changes (e.g. on a drive capacity change on revalidate).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index d2121e7738d7..6c348a211ebb 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -632,29 +632,29 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 		round_up(sdkp->capacity, sdkp->zone_blocks) >> sdkp->zone_shift;
 
 	/*
-	 * Wait for the disk capacity to stabilize before
-	 * initializing zone related information.
+	 * Initialize the device request queue information if the number
+	 * of zones changed.
 	 */
-	if (sdkp->first_scan)
-		return 0;
+	if (sdkp->nr_zones != q->nr_zones) {
 
-	if (!q->seq_zones_wlock) {
-		q->seq_zones_wlock = sd_zbc_alloc_zone_bitmap(sdkp);
-		if (!q->seq_zones_wlock) {
-			ret = -ENOMEM;
-			goto err;
-		}
-	}
+		sd_zbc_cleanup(sdkp);
 
-	if (!q->seq_zones_bitmap) {
-		ret = sd_zbc_setup_seq_zones_bitmap(sdkp);
-		if (ret) {
-			sd_zbc_cleanup(sdkp);
-			goto err;
+		q->nr_zones = sdkp->nr_zones;
+		if (sdkp->nr_zones) {
+			q->seq_zones_wlock = sd_zbc_alloc_zone_bitmap(sdkp);
+			if (!q->seq_zones_wlock) {
+				ret = -ENOMEM;
+				goto err;
+			}
+
+			ret = sd_zbc_setup_seq_zones_bitmap(sdkp);
+			if (ret) {
+				sd_zbc_cleanup(sdkp);
+				goto err;
+			}
 		}
-	}
 
-	q->nr_zones = sdkp->nr_zones;
+	}
 
 	return 0;
 
-- 
2.13.6
