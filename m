From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/3] Stop accepting SCSI requests before removing a device
Date: Fri, 04 May 2012 15:06:01 +0000
Message-ID: <4FA3F059.6020004@acm.org>
References: <4FA3EF10.3040104@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:41403 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758623Ab2EDPGJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2012 11:06:09 -0400
In-Reply-To: <4FA3EF10.3040104@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Mike Christie <michaelc@cs.wisc.edu>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tomas Henzl <thenzl@redhat.com>, Mike Snitzer <snitzer@redhat.com>

Source code inspection of __scsi_remove_device() revealed a
race condition in this function: no new SCSI requests must
be accepted for a SCSI device once device removal starts.

Reported-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <JBottomley@parallels.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/scsi/scsi_sysfs.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 42c35ff..f8fc240 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -955,12 +955,20 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	struct request_queue *q = sdev->request_queue;
+
+	/*
+	 * Stop accepting new requests before tearing down the
+	 * device. Note: the actual queue deallocation happens in
+	 * scsi_device_dev_release_usercontext().
+	 */
+	blk_cleanup_queue(q);
 
 	if (sdev->is_visible) {
 		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 			return;
 
-		bsg_unregister_queue(sdev->request_queue);
+		bsg_unregister_queue(q);
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		device_del(dev);
@@ -971,8 +979,6 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
 
-	/* Freeing the queue signals to block that we're done */
-	blk_cleanup_queue(sdev->request_queue);
 	put_device(dev);
 }
 
