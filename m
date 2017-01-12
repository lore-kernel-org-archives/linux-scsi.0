From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/2] sd: Ignore zoned field for host-managed devices
Date: Thu, 12 Jan 2017 15:25:11 +0900
Message-ID: <20170112062511.20261-3-damien.lemoal@wdc.com>
References: <20170112062511.20261-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:13341 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdALGZ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2017 01:25:29 -0500
In-Reply-To: <20170112062511.20261-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun@tancheff.com>, Hannes Reinecke <hare@suse.de>, Damien Le Moal <damien.lemoal@wdc.com>

There is no good match of the zoned filed of the block device
characteristics page for host-managed devices. For these devices, the
zoning model is derived directly from the device type. So ignore the
zoned field for these drives.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d7aaacf..6e6d4a4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2784,13 +2784,21 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, q);
 	}
 
-	sdkp->zoned = (buffer[8] >> 4) & 3;
-	if (sdkp->zoned == 1)
-		q->limits.zoned = BLK_ZONED_HA;
-	else if (sdkp->device->type == TYPE_ZBC)
+	if (sdkp->device->type == TYPE_ZBC) {
+		/* Host-managed */
 		q->limits.zoned = BLK_ZONED_HM;
-	else
-		q->limits.zoned = BLK_ZONED_NONE;
+	} else {
+		sdkp->zoned = (buffer[8] >> 4) & 3;
+		if (sdkp->zoned == 1)
+			/* Host-aware */
+			q->limits.zoned = BLK_ZONED_HA;
+		else
+			/*
+			 * Treat drive-managed devices as
+			 * regular block devices.
+			 */
+			q->limits.zoned = BLK_ZONED_NONE;
+	}
 	if (blk_queue_is_zoned(q) && sdkp->first_scan)
 		sd_printk(KERN_NOTICE, sdkp, "Host-%s zoned block device\n",
 		      q->limits.zoned == BLK_ZONED_HM ? "managed" : "aware");
-- 
2.9.3

