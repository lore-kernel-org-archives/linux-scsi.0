From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] Revert "scsi: Fix a bdi reregistration race"
Date: Fri, 20 Nov 2015 14:11:01 -0800
Message-ID: <564F9A75.7000208@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0056.outbound.protection.outlook.com ([157.56.110.56]:17136
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932986AbbKTWLF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2015 17:11:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The SCSI sd driver probes SCSI devices asynchronously. The sd_remove()
function, called indirectly by device_del(), waits until asynchronous
probing has finished. Since the block layer queue must only be cleaned
up after probing has finished, device_del() has to be called before
blk_cleanup_queue(). Hence revert commit bf2cf3baa20b.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_sysfs.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 8d23122..f5ace2b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1110,7 +1110,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		scsi_dh_remove_device(sdev);
-	}
+		device_del(dev);
+	} else
+		put_device(&sdev->sdev_dev);
 
 	/*
 	 * Stop accepting new requests and wait until all queuecommand() and
@@ -1121,16 +1123,6 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
-	/*
-	 * Remove the device after blk_cleanup_queue() has been called such
-	 * a possible bdi_register() call with the same name occurs after
-	 * blk_cleanup_queue() has called bdi_destroy().
-	 */
-	if (sdev->is_visible)
-		device_del(dev);
-	else
-		put_device(&sdev->sdev_dev);
-
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
-- 
2.1.4

