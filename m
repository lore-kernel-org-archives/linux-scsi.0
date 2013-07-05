From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v14 4/6] Rework scsi_internal_device_unblock()
Date: Fri, 05 Jul 2013 15:26:43 +0200
Message-ID: <51D6C993.1030409@acm.org>
References: <51D6C885.9050000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:60165 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab3GEN0p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jul 2013 09:26:45 -0400
In-Reply-To: <51D6C885.9050000@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, David Milburn <dmilburn@redhat.com>

Modify scsi_internal_device_unblock() such that it uses
scsi_device_set_state() to change the device state. This is only
possible by changing scsi_device_set_state() such that it allows
the transition from SDEV_CREATED_BLOCK to the SDEV_OFFLINE and
SDEV_TRANSPORT_OFFLINE states. Notes:
- All callers of scsi_internal_device_unblock() ignore the return
  value of this function.
- Since the SDEV_CREATED_BLOCK to SDEV_{TRANSPORT_,}OFFLINE transition
  is now allowed, direct scsi_device_set_state() calls that change the
  device state from SDEV_CREATED_BLOCK into SDEV_*OFFLINE will now
  proceed instead of being rejected.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 124392f..9eb05a7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2147,6 +2147,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_RUNNING:
 		case SDEV_QUIESCE:
 		case SDEV_BLOCK:
+		case SDEV_CREATED_BLOCK:
 			break;
 		default:
 			goto illegal;
@@ -2501,29 +2502,21 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
 {
 	struct request_queue *q = sdev->request_queue; 
 	unsigned long flags;
+	int res;
 
 	/*
 	 * Try to transition the scsi device to SDEV_RUNNING or one of the
 	 * offlined states and goose the device queue if successful.
 	 */
-	if ((sdev->sdev_state == SDEV_BLOCK) ||
-	    (sdev->sdev_state == SDEV_TRANSPORT_OFFLINE))
-		sdev->sdev_state = new_state;
-	else if (sdev->sdev_state == SDEV_CREATED_BLOCK) {
-		if (new_state == SDEV_TRANSPORT_OFFLINE ||
-		    new_state == SDEV_OFFLINE)
-			sdev->sdev_state = new_state;
-		else
-			sdev->sdev_state = SDEV_CREATED;
-	} else if (sdev->sdev_state != SDEV_CANCEL &&
-		 sdev->sdev_state != SDEV_OFFLINE)
-		return -EINVAL;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	blk_start_queue(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	return 0;
+	if (sdev->sdev_state == SDEV_CREATED_BLOCK && new_state == SDEV_RUNNING)
+		new_state = SDEV_CREATED;
+	res = scsi_device_set_state(sdev, new_state);
+	if (!scsi_device_blocked(sdev)) {
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_start_queue(q);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	}
+	return res;
 }
 EXPORT_SYMBOL_GPL(scsi_internal_device_unblock);
 
-- 
1.7.10.4

