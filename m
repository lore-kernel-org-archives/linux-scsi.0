From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v7 4/9] Remove offline devices when removing a host
Date: Thu, 06 Dec 2012 16:55:58 +0100
Message-ID: <50C0C00E.60709@acm.org>
References: <50C0BEEE.4040907@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:50984 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423862Ab2LFPz7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2012 10:55:59 -0500
In-Reply-To: <50C0BEEE.4040907@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Currently __scsi_remove_device() skips devices that are visible and
offline. Make sure that these devices get removed by changing their
device state into SDEV_DEL at the start of __scsi_remove_device().
Also, avoid that __scsi_remove_device() gets called a second time
for devices that are in state SDEV_CANCEL when scsi_forget_host()
is invoked.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/scsi_scan.c  |    2 +-
 drivers/scsi/scsi_sysfs.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..0612fba 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1889,7 +1889,7 @@ void scsi_forget_host(struct Scsi_Host *shost)
  restart:
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
-		if (sdev->sdev_state == SDEV_DEL)
+		if (scsi_device_being_removed(sdev))
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		__scsi_remove_device(sdev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 2ff7ba5..4348f12 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -959,8 +959,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	unsigned long flags;
 
 	if (sdev->is_visible) {
-		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
-			return;
+		WARN_ON_ONCE(scsi_device_set_state(sdev, SDEV_CANCEL) != 0 &&
+			     scsi_device_set_state(sdev, SDEV_DEL) != 0);
 
 		bsg_unregister_queue(sdev->request_queue);
 		device_unregister(&sdev->sdev_dev);
-- 
1.7.10.4

