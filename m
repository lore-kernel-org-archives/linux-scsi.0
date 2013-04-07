From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v10 3/9] Avoid calling __scsi_remove_device() twice
Date: Sun, 07 Apr 2013 16:59:51 +0200
Message-ID: <516189E7.6020803@acm.org>
References: <516188E5.1040008@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:47636 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933861Ab3DGO7z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Apr 2013 10:59:55 -0400
In-Reply-To: <516188E5.1040008@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>

SCSI devices are added to the shost->__devices list from inside
scsi_alloc_sdev(). If something goes wrong during LUN scanning,
e.g. a transport layer failure occurs, then __scsi_remove_device()
can get invoked by the LUN scanning code for a SCSI device in
state SDEV_CREATED_BLOCK or SDEV_BLOCKED. If this happens then
the SCSI device has not yet been added to sysfs (is_visible == 0).
Make sure that if this happens these devices are transitioned
into state SDEV_DEL. This avoids that __scsi_remove_device()
gets invoked a second time by scsi_forget_host().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/scsi_lib.c   |    2 ++
 drivers/scsi/scsi_sysfs.c |    7 ++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d84cbd0..34cdcbc 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2176,6 +2176,8 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_OFFLINE:
 		case SDEV_TRANSPORT_OFFLINE:
 		case SDEV_CANCEL:
+		case SDEV_BLOCK:
+		case SDEV_CREATED_BLOCK:
 			break;
 		default:
 			goto illegal;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 34f1b39..f869ef85 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -956,8 +956,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	unsigned long flags;
 
 	if (sdev->is_visible) {
-		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
-			return;
+		WARN(scsi_device_set_state(sdev, SDEV_CANCEL) != 0,
+		     "%s: unexpected state %d\n", dev_name(&sdev->sdev_gendev),
+		     sdev->sdev_state);
 
 		bsg_unregister_queue(sdev->request_queue);
 		device_unregister(&sdev->sdev_dev);
@@ -971,7 +972,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	 * scsi_run_queue() invocations have finished before tearing down the
 	 * device.
 	 */
-	scsi_device_set_state(sdev, SDEV_DEL);
+	WARN_ON_ONCE(scsi_device_set_state(sdev, SDEV_DEL) != 0);
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
-- 
1.7.10.4

