From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] scsi: proper state checking and module refcount handling in scsi_device_get
Date: Thu, 29 Jan 2015 00:00:56 +0100
Message-ID: <1422486056-11591-3-git-send-email-hch@lst.de>
References: <1422486056-11591-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50912 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbbA2BVU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jan 2015 20:21:20 -0500
In-Reply-To: <1422486056-11591-1-git-send-email-hch@lst.de>
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
 drivers/scsi/scsi.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 9b38299..95f0293 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -982,15 +982,18 @@ EXPORT_SYMBOL(scsi_report_opcode);
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

