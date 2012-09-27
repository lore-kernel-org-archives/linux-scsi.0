From: Josh Taylor <joshua.taylor0@gmail.com>
Subject: [PATCH] Scsi: Fixed white space and tab errors.
Date: Wed, 26 Sep 2012 20:12:04 -0400
Message-ID: <1348704724-28407-1-git-send-email-joshua.taylor0@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:35553 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab2I0AMM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2012 20:12:12 -0400
Received: by qaas11 with SMTP id s11so451876qaa.19
        for <linux-scsi@vger.kernel.org>; Wed, 26 Sep 2012 17:12:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Josh Taylor <joshua.taylor0@gmail.com>

Signed-off-by: Josh Taylor <joshua.taylor0@gmail.com>
---
 drivers/scsi/scsi.c |   66 +++++++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2936b44..00aded9 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -126,7 +126,7 @@ static const char *const scsi_device_types[] = {
  * @type: type number to look up
  */
 
-const char * scsi_device_type(unsigned type)
+const char *scsi_device_type(unsigned type)
 {
 	if (type == 0x1e)
 		return "Well-known LUN   ";
@@ -609,7 +609,7 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 				printk("FAILED\n");
 				break;
 			case TIMEOUT_ERROR:
-				/* 
+				/*
 				 * If called via scsi_times_out.
 				 */
 				printk("TIMEOUT\n");
@@ -642,7 +642,7 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
 	cmd->serial_number = host->cmd_serial_number++;
-	if (cmd->serial_number == 0) 
+	if (cmd->serial_number == 0)
 		cmd->serial_number = host->cmd_serial_number++;
 }
 EXPORT_SYMBOL(scsi_cmd_get_serial);
@@ -675,7 +675,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 
 	/* Check to see if the scsi lld made this device blocked. */
 	if (unlikely(scsi_device_blocked(cmd->device))) {
-		/* 
+		/*
 		 * in blocked state, the command is just put back on
 		 * the device queue.  The suspend state has already
 		 * blocked the queue so future requests should not
@@ -694,7 +694,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
-	/* 
+	/*
 	 * If SCSI-2 or lower, store the LUN value in cmnd.
 	 */
 	if (cmd->device->scsi_level <= SCSI_2 &&
@@ -805,17 +805,17 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 
 	scsi_device_unbusy(sdev);
 
-        /*
-         * Clear the flags which say that the device/host is no longer
-         * capable of accepting new commands.  These are set in scsi_queue.c
-         * for both the queue full condition on a device, and for a
-         * host full condition on the host.
+	/*
+	 * Clear the flags which say that the device/host is no longer
+	 * capable of accepting new commands.  These are set in scsi_queue.c
+	 * for both the queue full condition on a device, and for a
+	 * host full condition on the host
 	 *
 	 * XXX(hch): What about locking?
-         */
-        shost->host_blocked = 0;
+	 */
+	shost->host_blocked = 0;
 	starget->target_blocked = 0;
-        sdev->device_blocked = 0;
+	sdev->device_blocked = 0;
 
 	/*
 	 * If we have valid sense information, then some kind of recovery
@@ -829,7 +829,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 				"(result %x)\n", cmd->result));
 
 	good_bytes = scsi_bufflen(cmd);
-        if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
+	if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
 		int old_good_bytes = good_bytes;
 		drv = scsi_cmd_to_driver(cmd);
 		if (drv->done)
@@ -894,22 +894,22 @@ void scsi_adjust_queue_depth(struct scsi_device *sdev, int tagged, int tags)
 
 	sdev->queue_depth = tags;
 	switch (tagged) {
-		case MSG_ORDERED_TAG:
-			sdev->ordered_tags = 1;
-			sdev->simple_tags = 1;
-			break;
-		case MSG_SIMPLE_TAG:
-			sdev->ordered_tags = 0;
-			sdev->simple_tags = 1;
-			break;
-		default:
-			sdev_printk(KERN_WARNING, sdev,
-				    "scsi_adjust_queue_depth, bad queue type, "
-				    "disabled\n");
-		case 0:
-			sdev->ordered_tags = sdev->simple_tags = 0;
-			sdev->queue_depth = tags;
-			break;
+	case MSG_ORDERED_TAG:
+		sdev->ordered_tags = 1;
+		sdev->simple_tags = 1;
+		break;
+	case MSG_SIMPLE_TAG:
+		sdev->ordered_tags = 0;
+		sdev->simple_tags = 1;
+		break;
+	default:
+		sdev_printk(KERN_WARNING, sdev,
+			    "scsi_adjust_queue_depth, bad queue type, "
+			    "disabled\n");
+	case 0:
+		sdev->ordered_tags = sdev->simple_tags = 0;
+		sdev->queue_depth = tags;
+		break;
 	}
  out:
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
@@ -961,7 +961,7 @@ int scsi_track_queue_full(struct scsi_device *sdev, int depth)
 		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 		return -1;
 	}
-	
+
 	if (sdev->ordered_tags)
 		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
 	else
@@ -1205,7 +1205,7 @@ struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *starget,
 	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
 		if (sdev->sdev_state == SDEV_DEL)
 			continue;
-		if (sdev->lun ==lun)
+		if (sdev->lun == lun)
 			return sdev;
 	}
 
@@ -1262,7 +1262,7 @@ struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
 
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel == channel && sdev->id == id &&
-				sdev->lun ==lun)
+				sdev->lun == lun)
 			return sdev;
 	}
 
-- 
1.7.9.5

