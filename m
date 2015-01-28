From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] scsi: serialize ->rescan against ->remove
Date: Thu, 29 Jan 2015 00:00:54 +0100
Message-ID: <1422486056-11591-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50911 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbbA2BVT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jan 2015 20:21:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>

Lock the device embedded in the scsi_device to protect against
concurrent calls to ->remove.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_scan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 983aed1..523faee 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1593,16 +1593,15 @@ EXPORT_SYMBOL(scsi_add_device);
 
 void scsi_rescan_device(struct device *dev)
 {
-	if (!dev->driver)
-		return;
-
-	if (try_module_get(dev->driver->owner)) {
+	device_lock(dev);
+	if (dev->driver && try_module_get(dev->driver->owner)) {
 		struct scsi_driver *drv = to_scsi_driver(dev->driver);
 
 		if (drv->rescan)
 			drv->rescan(dev);
 		module_put(dev->driver->owner);
 	}
+	device_unlock(dev);
 }
 EXPORT_SYMBOL(scsi_rescan_device);
 
-- 
1.9.1

