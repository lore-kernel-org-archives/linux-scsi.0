From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/2] sd_zbc: Remove superfluous assignments
Date: Tue, 28 Feb 2017 19:26:31 +0900
Message-ID: <20170228102631.16101-3-damien.lemoal@wdc.com>
References: <20170228102631.16101-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:53090 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751763AbdB1Kbb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 05:31:31 -0500
In-Reply-To: <20170228102631.16101-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>

From: Bart Van Assche <bart.vanassche@sandisk.com>

A value is assigned to the variable 'capacity' in sd_zbc_read_zones()
but that value is never used. Hence remove the variable 'capacity'.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>

The variable 'ret' is initialized in sd_zbc_read_zones() but that
initialization is not necessary.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 789c970..cf2c6a7 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -595,8 +595,7 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 int sd_zbc_read_zones(struct scsi_disk *sdkp,
 		      unsigned char *buf)
 {
-	sector_t capacity;
-	int ret = 0;
+	int ret;
 
 	if (!sd_is_zoned(sdkp))
 		/*
@@ -628,7 +627,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp,
 	ret = sd_zbc_check_capacity(sdkp, buf);
 	if (ret)
 		goto err;
-	capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 
 	/*
 	 * Check zone size: only devices with a constant zone size (except
-- 
2.9.3
