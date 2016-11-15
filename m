From: Wei Fang <fangwei1@huawei.com>
Subject: [RFC PATCH] scsi:fc: avoid a permanent stop of the scsi device's request queue
Date: Tue, 15 Nov 2016 21:02:15 +0800
Message-ID: <1479214935-19968-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:55389 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751359AbcKONAS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2016 08:00:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org, Wei Fang <fangwei1@huawei.com>

A scan work can run simultaneously with fc_remote_port_delete().
If a scsi device is added to the ->__devices list in the scan work,
it can be touched and will be blocked in scsi_target_block(), and
QUEUE_FLAG_STOPPED will be setted to the scsi device's request queue.
But unfortunately, this flag will not be cleared when the scsi device
is being setted to the SDEV_RUNNING state in the end of the scan work.

After that, all the requests sending to the device will be blocked.

Fix this by flushing the scan work before blocking the device.

Reported-by: Zengxi Chen <chenzengxi@huawei.com>
Signed-off-by: Wei Fang <fangwei1@huawei.com>
---
 drivers/scsi/scsi_transport_fc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index e05c07f..0d476df 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2978,14 +2978,6 @@ fc_remote_port_delete(struct fc_rport  *rport)
 	unsigned long timeout = rport->dev_loss_tmo;
 	unsigned long flags;
 
-	/*
-	 * No need to flush the fc_host work_q's, as all adds are synchronous.
-	 *
-	 * We do need to reclaim the rport scan work element, so eventually
-	 * (in fc_rport_final_delete()) we'll flush the scsi host work_q if
-	 * there's still a scan pending.
-	 */
-
 	spin_lock_irqsave(shost->host_lock, flags);
 
 	if (rport->port_state != FC_PORTSTATE_ONLINE) {
@@ -3012,6 +3004,14 @@ fc_remote_port_delete(struct fc_rport  *rport)
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
+	/*
+	 * make sure no scan is pending before blocking it, otherwise
+	 * simultaneously scan may cause a permanent QUEUE_FLAG_STOPPED
+	 * flag set of the device's request queue.
+	 */
+	if (rport->flags & FC_RPORT_SCAN_PENDING)
+		scsi_flush_work(shost);
+
 	scsi_target_block(&rport->dev);
 
 	/* see if we need to kill io faster than waiting for device loss */
-- 
2.4.11

