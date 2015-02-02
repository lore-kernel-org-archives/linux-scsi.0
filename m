From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] scsi: serialize ->rescan against ->remove
Date: Mon,  2 Feb 2015 14:01:24 +0100
Message-ID: <1422882086-1863-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59568 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbbBBNCr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2015 08:02:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>

Lock the device embedded in the scsi_device to protect against
concurrent calls to ->remove.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
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

