From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] scsi: proper state checking and module refcount handling in scsi_device_get
Date: Mon,  2 Feb 2015 14:01:26 +0100
Message-ID: <1422882086-1863-3-git-send-email-hch@lst.de>
References: <1422882086-1863-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59570 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163AbbBBNCr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2015 08:02:47 -0500
In-Reply-To: <1422882086-1863-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>

This effectively reverts commits 85b6c7 ("[SCSI] sd: fix cache flushing on
module removal (and individual device removal)" and dc4515ea ("scsi: always
increment reference count").

We now never call scsi_device_get from the shutdown path, and the fact
that we started grabbing reference there in commit 85b6c7 turned out
turned out to create more problems than it solves, and required
workarounds for workarounds for workarounds. Move back to properly checking
the device state and carefully handle module refcounting.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 9b38299..9b7fd0b 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -979,18 +979,24 @@ EXPORT_SYMBOL(scsi_report_opcode);
  * Description: Gets a reference to the scsi_device and increments the use count
  * of the underlying LLDD module.  You must hold host_lock of the
  * parent Scsi_Host or already have a reference when calling this.
+ *
+ * This will fail if a device is deleted or cancelled, or when the LLD module
+ * is in the process of being unloaded.
  */
 int scsi_device_get(struct scsi_device *sdev)
 {
-	if (sdev->sdev_state == SDEV_DEL)
-		return -ENXIO;
+	if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL)
+		goto fail;
 	if (!get_device(&sdev->sdev_gendev))
-		return -ENXIO;
-	/* We can fail try_module_get if we're doing SCSI operations
-	 * from module exit (like cache flush) */
-	__module_get(sdev->host->hostt->module);
-
+		goto fail;
+	if (!try_module_get(sdev->host->hostt->module))
+		goto fail_put_device;
 	return 0;
+
+fail_put_device:
+	put_device(&sdev->sdev_gendev);
+fail:
+	return -ENXIO;
 }
 EXPORT_SYMBOL(scsi_device_get);
 
-- 
1.9.1

