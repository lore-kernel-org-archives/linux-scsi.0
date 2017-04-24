From: damien.lemoal@wdc.com
Subject: [PATCH v2 6/7] sd_zbc: Remove superfluous assignments
Date: Mon, 24 Apr 2017 16:51:14 +0900
Message-ID: <20170424075115.30337-7-damien.lemoal@wdc.com>
References: <20170424075115.30337-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:22840 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1166215AbdDXHvu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 03:51:50 -0400
In-Reply-To: <20170424075115.30337-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>

From: Bart Van Assche <bart.vanassche@sandisk.com>

A value is assigned to the variable 'capacity' in sd_zbc_read_zones()
but that value is never used. Hence remove the variable 'capacity'.

[Damien: There is no need to initialize to 0 the variable 'ret'
in sd_zbc_read_zones()]

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index a792682..29ba1d7 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -560,8 +560,7 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 int sd_zbc_read_zones(struct scsi_disk *sdkp,
 		      unsigned char *buf)
 {
-	sector_t capacity;
-	int ret = 0;
+	int ret;
 
 	if (!sd_is_zoned(sdkp))
 		/*
@@ -593,7 +592,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp,
 	ret = sd_zbc_check_capacity(sdkp, buf);
 	if (ret)
 		goto err;
-	capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 
 	/*
 	 * Check zone size: only devices with a constant zone size (except
-- 
2.9.3
