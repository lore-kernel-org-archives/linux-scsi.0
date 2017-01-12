From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/2] sd: Fix wrong DPOFUA disable in sd_read_cache_type
Date: Thu, 12 Jan 2017 15:25:10 +0900
Message-ID: <20170112062511.20261-2-damien.lemoal@wdc.com>
References: <20170112062511.20261-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:27265 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdALGZ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2017 01:25:26 -0500
In-Reply-To: <20170112062511.20261-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun@tancheff.com>, Hannes Reinecke <hare@suse.de>, Damien Le Moal <damien.lemoal@wdc.com>

Zoned block devices force the use of READ/WRITE(16) commands by setting
sdkp->use_16_for_rw and clearing sdkp->use_10_for_rw. This result in
DPOFUA always being disabled for these drives as the assumed use of
the deprecated READ/WRITE(6) commands only looks at sdkp->use_10_for_rw.
Strenghten the test by also checking that sdkp->use_16_for_rw is false.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b193304..d7aaacf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2600,7 +2600,8 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 		if (sdp->broken_fua) {
 			sd_first_printk(KERN_NOTICE, sdkp, "Disabling FUA\n");
 			sdkp->DPOFUA = 0;
-		} else if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw) {
+		} else if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw &&
+			   !sdkp->device->use_16_for_rw) {
 			sd_first_printk(KERN_NOTICE, sdkp,
 				  "Uses READ/WRITE(6), disabling FUA\n");
 			sdkp->DPOFUA = 0;
-- 
2.9.3

