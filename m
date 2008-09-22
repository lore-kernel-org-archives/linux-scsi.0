From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 01/13] scsi: Move wait_for check
Date: Mon, 22 Sep 2008 09:33:30 -0700
Message-ID: <1222101222-15079-2-git-send-email-andmike@linux.vnet.ibm.com>
References: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:34455 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYIVQd5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2008 12:33:57 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8MGXvse005614
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 12:33:57 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8MGXuSc160496
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 10:33:56 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8MMXuvC004674
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:33:56 -0600
Received: from localhost.localdomain (desktop-andmike.beaverton.ibm.com [9.47.22.92])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m8MMXlYJ003971
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:33:51 -0600
In-Reply-To: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Move wait_for check to scsi_queue_insert.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_lib.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 517fd90..83a8aae 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -116,11 +116,20 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	struct scsi_device *device = cmd->device;
 	struct scsi_target *starget = scsi_target(device);
 	struct request_queue *q = device->request_queue;
+	unsigned long wait_for = (cmd->allowed + 1) * cmd->request->timeout;
 	unsigned long flags;
 
 	SCSI_LOG_MLQUEUE(1,
 		 printk("Inserting command %p into mlqueue\n", cmd));
 
+	if (time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
+		sdev_printk(KERN_ERR, cmd->device, "timing out command, "
+			    "waited %lus\n", wait_for/HZ);
+		set_driver_byte(cmd, DRIVER_TIMEOUT);
+		scsi_finish_command(cmd);
+		return 0;
+	}
+
 	/*
 	 * Set the appropriate busy bit for the device/host.
 	 *
@@ -1494,7 +1503,6 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 static void scsi_softirq_done(struct request *rq)
 {
 	struct scsi_cmnd *cmd = rq->special;
-	unsigned long wait_for = (cmd->allowed + 1) * rq->timeout;
 	int disposition;
 
 	INIT_LIST_HEAD(&cmd->eh_entry);
@@ -1509,13 +1517,6 @@ static void scsi_softirq_done(struct request *rq)
 		atomic_inc(&cmd->device->ioerr_cnt);
 
 	disposition = scsi_decide_disposition(cmd);
-	if (disposition != SUCCESS &&
-	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
-		sdev_printk(KERN_ERR, cmd->device,
-			    "timing out command, waited %lus\n",
-			    wait_for/HZ);
-		disposition = SUCCESS;
-	}
 			
 	scsi_log_completion(cmd, disposition);
 
-- 
1.5.5.1

