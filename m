From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 03/14] scsi: Move wait_for check
Date: Tue,  2 Sep 2008 09:05:32 -0700
Message-ID: <1220371543-15099-4-git-send-email-andmike@linux.vnet.ibm.com>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48179 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbYIBQFv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 12:05:51 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82G5nKh031070
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:49 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82G5kDG194024
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:46 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82G5j2s020980
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:46 -0400
In-Reply-To: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

Move wait_for check to scsi_queue_insert.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_lib.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ff5d56b..b340087 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -115,11 +115,20 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_device *device = cmd->device;
 	struct request_queue *q = device->request_queue;
+	unsigned long wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
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
@@ -1421,19 +1430,11 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 static void scsi_softirq_done(struct request *rq)
 {
 	struct scsi_cmnd *cmd = rq->completion_data;
-	unsigned long wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
 	int disposition;
 
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
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

