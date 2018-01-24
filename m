From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] scsi_debug: Use scsi-mq if it has been enabled
Date: Tue, 23 Jan 2018 16:39:58 -0800
Message-ID: <20180124003958.3945-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31656 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752705AbeAXAj7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2018 19:39:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>

Since we want to remove the single queue code from the SCSI core
at the appropriate time and since scsi-mq performs better than
scsi-sq even when using only a single hardware queue, use scsi-mq
if it has been enabled.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a5986dae9020..40df3eea72c8 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5782,7 +5782,7 @@ static int sdebug_driver_probe(struct device * dev)
 	}
 	/* Decide whether to tell scsi subsystem that we want mq */
 	/* Following should give the same answer for each host */
-	sdebug_mq_active = shost_use_blk_mq(hpnt) && (submit_queues > 1);
+	sdebug_mq_active = shost_use_blk_mq(hpnt);
 	if (sdebug_mq_active)
 		hpnt->nr_hw_queues = submit_queues;
 
-- 
2.15.1
