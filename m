From: Brian King <brking@us.ibm.com>
Subject: [PATCH] p00001_scsi_tcq_queue_lock
Date: Tue, 03 Aug 2004 12:49:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <410FD03E.6040305@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030905010501020100060003"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:61170 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266771AbUHCRt7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2004 13:49:59 -0400
List-Id: linux-scsi@vger.kernel.org
To: james Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------030905010501020100060003
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------030905010501020100060003
Content-Type: text/plain;
 name="p00001_scsi_tcq_queue_lock.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="p00001_scsi_tcq_queue_lock.patch"


Add locking to scsi_activate_tcq and scsi_deactivate_tcq to fix a race
condition that can occur when disabling tcqing with commands in flight.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc2-bjking1/include/scsi/scsi_tcq.h |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN include/scsi/scsi_tcq.h~scsi_tcq_queue_lock include/scsi/scsi_tcq.h
--- linux-2.6.8-rc2/include/scsi/scsi_tcq.h~scsi_tcq_queue_lock	2004-08-03 11:05:28.000000000 -0500
+++ linux-2.6.8-rc2-bjking1/include/scsi/scsi_tcq.h	2004-08-03 11:12:19.000000000 -0500
@@ -25,9 +25,13 @@
  **/
 static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
 {
+	unsigned long flags;
+
         if (sdev->tagged_supported) {
+		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 		if (!blk_queue_tagged(sdev->request_queue))
 			blk_queue_init_tags(sdev->request_queue, depth, NULL);
+		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
         }
 }
@@ -38,8 +42,12 @@ static inline void scsi_activate_tcq(str
  **/
 static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	if (blk_queue_tagged(sdev->request_queue))
 		blk_queue_free_tags(sdev->request_queue);
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 	scsi_adjust_queue_depth(sdev, 0, depth);
 }
 
_

--------------030905010501020100060003--

