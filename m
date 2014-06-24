From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] cleanup switch in scsi_adjust_queue_depth()
Date: Tue, 24 Jun 2014 19:23:45 -0400
Message-ID: <53AA0881.5000505@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070309070102010904080609"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59923 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbaFXXXu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2014 19:23:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>

This is a multi-part message in MIME format.
--------------070309070102010904080609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

While checking what scsi_adjust_queue_depth() did I
thought its switch statement could be clearer.

ChangeLog:
   - remove redundant assignment (to sdev->queue_depth)
   - re-order cases (thus removing the fall-through)

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------070309070102010904080609
Content-Type: text/x-patch;
 name="scsi_adjust_queue_depth1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scsi_adjust_queue_depth1.patch"

--- linux-3.15/drivers/scsi/scsi.c3151	2014-06-08 21:36:43.815551129 -0400
+++ linux-3.15/drivers/scsi/scsi.c	2014-06-24 19:17:02.474464807 -0400
@@ -850,6 +850,10 @@ void scsi_adjust_queue_depth(struct scsi
 
 	sdev->queue_depth = tags;
 	switch (tagged) {
+		case 0:
+			sdev->ordered_tags = 0;
+			sdev->simple_tags = 0;
+			break;
 		case MSG_ORDERED_TAG:
 			sdev->ordered_tags = 1;
 			sdev->simple_tags = 1;
@@ -859,13 +863,11 @@ void scsi_adjust_queue_depth(struct scsi
 			sdev->simple_tags = 1;
 			break;
 		default:
+			sdev->ordered_tags = 0;
+			sdev->simple_tags = 0;
 			sdev_printk(KERN_WARNING, sdev,
 				    "scsi_adjust_queue_depth, bad queue type, "
 				    "disabled\n");
-		case 0:
-			sdev->ordered_tags = sdev->simple_tags = 0;
-			sdev->queue_depth = tags;
-			break;
 	}
  out:
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);

--------------070309070102010904080609--
