From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] scsi: sd_zbc: Disable zoned block devices with scsi-mq
Date: Thu, 17 Aug 2017 11:45:50 +0900
Message-ID: <20170817024550.9845-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:2616 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751522AbdHQCqt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 22:46:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>

blk-mq may not maintain write requests order at dispatch time. So host
managed drives will not reliably work. Worse, potential reordering of
write requests on requeue may cause the zone write locking code to
deadlock command dispatch to the disk. So for now, until the write
ordering issue is fixed, do not support zoned block devices with
scsi-mq by showing a 0 LBA capacity disk.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 8aa54779aac1..07bd8511102a 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -561,6 +561,19 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp,
 		 */
 		return 0;
 
+	/*
+	 * In the scsi-mq case, write ordering is not guaranteed so
+	 * host managed drives will not reliably work. Worse, zone write
+	 * locking can cause dispatch deadlocks. So for now, do not support
+	 * zoned block devices with scsi-mq by showing a 0 capacity disk.
+	 */
+	if (sdkp->disk->queue->mq_ops) {
+		if (sdkp->first_scan)
+			sd_printk(KERN_WARNING, sdkp,
+			  "Zoned block devices are not supported with scsi-mq\n");
+		ret = -ENODEV;
+		goto err;
+	}
 
 	/* Get zoned block device characteristics */
 	ret = sd_zbc_read_zoned_characteristics(sdkp, buf);
-- 
2.13.5
