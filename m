From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] sd: fix cache flushing on module removal (and
	individual device removal)
Date: Thu, 31 Aug 2006 18:15:22 -0400
Message-ID: <1157062522.3666.10.camel@mulgrave.il.steeleye.com>
References: <1157058484.3666.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:4324 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964795AbWHaWPX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 18:15:23 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k7VMFN505993
	for <linux-scsi@vger.kernel.org>; Thu, 31 Aug 2006 18:15:23 -0400
In-Reply-To: <1157058484.3666.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2006-08-31 at 17:08 -0400, James Bottomley wrote:
> The fix isn't actually in sd: it's in scsi_device_get().  I modified it
> to allow devices to be returned in SDEV_CANCEL, but not SDEV_DEL.  This
> means that the device_remove_driver, which occurs in device_del() in
> scsi_remove_device() after the device has gone into SDEV_CANCEL is now
> effective at flushing the cache.

Actually, lets try that again, but with the correct patch.

James

Index: linux-2.6/drivers/scsi/scsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi.c
+++ linux-2.6/drivers/scsi/scsi.c
@@ -835,14 +835,14 @@ EXPORT_SYMBOL(scsi_track_queue_full);
  */
 int scsi_device_get(struct scsi_device *sdev)
 {
-	if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL)
+	if (sdev->sdev_state == SDEV_DEL)
 		return -ENXIO;
 	if (!get_device(&sdev->sdev_gendev))
 		return -ENXIO;
-	if (!try_module_get(sdev->host->hostt->module)) {
-		put_device(&sdev->sdev_gendev);
-		return -ENXIO;
-	}
+	/* We can fail this if we're doing SCSI operations
+	 * from module exit (like cache flush) */
+	try_module_get(sdev->host->hostt->module);
+
 	return 0;
 }
 EXPORT_SYMBOL(scsi_device_get);
@@ -857,7 +857,10 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-	module_put(sdev->host->hostt->module);
+	/* The module refcount will be zero if scsi_device_get()
+	 * was called from a module removal routine */
+	if (likely(module_refcount(sdev->host->hostt->module) != 0))
+		module_put(sdev->host->hostt->module);
 	put_device(&sdev->sdev_gendev);
 }
 EXPORT_SYMBOL(scsi_device_put);


