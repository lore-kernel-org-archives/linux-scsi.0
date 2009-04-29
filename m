From: Takahiro Yasui <tyasui@redhat.com>
Subject: [PATCH] limit state transitions in scsi_internal_device_unblock
Date: Wed, 29 Apr 2009 12:13:02 -0400
Message-ID: <49F87C8E.3090907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53878 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbZD2QMq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2009 12:12:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, mchristi@redhat.com, mbarrow@redhat.com

Hi James,

scsi timeout on two or more devices may cause extremely long execution
time for user applications because SDEV_OFFLINE state is changed to
SDEV_RUNNING state during scsi error recovery procedures triggered by
a bus reset or a host reset of scsi LLD, and scsi timeout can happens
on the same devices many times.

This happens because scsi_internal_device_unblock() changes device's
state to SDEV_RUNNING even if a device in other states than SDEV_BLOCK,
while the following two transitions are required in this function.

  SDEV_BLOCK -> SDEV_RUNNING
  SDEV_CREATED_BLOCK -> SDEV_CREATED

Otherwise, it returns -EINVAL.
 

Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---

 This is the updated patch based on comments from James and Matthew.
 One difference from Matthew's suggestion is the order of the
 state comparison, but it keeps the same order as the original code.

 drivers/scsi/scsi_lib.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

Index: linux-2.6.29/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6.29/drivers/scsi/scsi_lib.c
@@ -2629,20 +2629,18 @@ int
 scsi_internal_device_unblock(struct scsi_device *sdev)
 {
 	struct request_queue *q = sdev->request_queue; 
-	int err;
 	unsigned long flags;
 	
 	/* 
 	 * Try to transition the scsi device to SDEV_RUNNING
 	 * and goose the device queue if successful.  
 	 */
-	err = scsi_device_set_state(sdev, SDEV_RUNNING);
-	if (err) {
-		err = scsi_device_set_state(sdev, SDEV_CREATED);
-
-		if (err)
-			return err;
-	}
+	if (sdev->sdev_state == SDEV_BLOCK)
+		sdev->sdev_state = SDEV_RUNNING;
+	else if (sdev->sdev_state == SDEV_CREATED_BLOCK)
+		sdev->sdev_state = SDEV_CREATED;
+	else
+		return -EINVAL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_start_queue(q);


