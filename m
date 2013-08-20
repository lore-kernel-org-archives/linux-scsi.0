From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/7] Rework scsi_internal_device_unblock()
Date: Tue, 20 Aug 2013 14:07:28 +0200
Message-ID: <52135C00.8040706@acm.org>
References: <52135B99.2000102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:55146 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3HTMH3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2013 08:07:29 -0400
In-Reply-To: <52135B99.2000102@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>

Except for scsi_internal_device_unblock() all SCSI device state
changes happen via scsi_device_set_state(). Modify
scsi_internal_device_unblock() such that it uses
scsi_device_set_state() to change the device state. This requires
modifying scsi_device_set_state() such that it allows the
transition from SDEV_CREATED_BLOCK to the SDEV_OFFLINE and
SDEV_TRANSPORT_OFFLINE states.

Note: since the SDEV_CREATED_BLOCK to SDEV_{TRANSPORT_,}OFFLINE
transition is now allowed, direct scsi_device_set_state() calls
that change the device state from SDEV_CREATED_BLOCK into
SDEV_*OFFLINE will now proceed instead of being rejected. As far
as I have been able to verify this behavior change is fine for
all upstream SCSI transport drivers and SCSI LLDs.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Roland Dreier <roland@kernel.org>
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

