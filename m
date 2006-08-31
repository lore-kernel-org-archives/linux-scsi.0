From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] sd: fix cache flushing on module removal (and individual
	device removal)
Date: Thu, 31 Aug 2006 17:08:04 -0400
Message-ID: <1157058484.3666.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:51938 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751150AbWHaVIH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 17:08:07 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k7VL84502324
	for <linux-scsi@vger.kernel.org>; Thu, 31 Aug 2006 17:08:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The fix isn't actually in sd: it's in scsi_device_get().  I modified it
to allow devices to be returned in SDEV_CANCEL, but not SDEV_DEL.  This
means that the device_remove_driver, which occurs in device_del() in
scsi_remove_device() after the device has gone into SDEV_CANCEL is now
effective at flushing the cache.

James

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 94df671..3294863 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -851,7 +851,7 @@ EXPORT_SYMBOL(scsi_track_queue_full);
  */
 int scsi_device_get(struct scsi_device *sdev)
 {
-	if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL)
+	if (sdev->sdev_state == SDEV_DEL)
 		return -ENXIO;
 	if (!get_device(&sdev->sdev_gendev))
 		return -ENXIO;


