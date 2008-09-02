From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 04/14] scsi: Move retries check
Date: Tue,  2 Sep 2008 09:05:33 -0700
Message-ID: <1220371543-15099-5-git-send-email-andmike@linux.vnet.ibm.com>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42795 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbYIBQFr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 12:05:47 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82G5kLw023398
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:46 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82G5k2V188558
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:46 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82G5kFP021019
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:46 -0400
In-Reply-To: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

Move retries check to scsi_queue_insert.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_error.c |    8 ++------
 drivers/scsi/scsi_lib.c   |    7 +++++++
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4e30343..eb4290a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1347,8 +1347,6 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	case DID_SOFT_ERROR:
 		goto maybe_retry;
 	case DID_IMM_RETRY:
-		return NEEDS_RETRY;
-
 	case DID_REQUEUE:
 		return ADD_TO_MLQUEUE;
 	case DID_TRANSPORT_DISRUPTED:
@@ -1456,8 +1454,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 * the request was not marked fast fail.  Note that above,
 	 * even if the request is marked fast fail, we still requeue
 	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
-	if ((++scmd->retries) <= scmd->allowed
-	    && !blk_noretry_request(scmd->request)) {
+	if (!blk_noretry_request(scmd->request)) {
 		return NEEDS_RETRY;
 	} else {
 		/*
@@ -1582,8 +1579,7 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
 		if (scsi_device_online(scmd->device) &&
-		    !blk_noretry_request(scmd->request) &&
-		    (++scmd->retries <= scmd->allowed)) {
+		    !blk_noretry_request(scmd->request)) {
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
 							  " retry cmd: %p\n",
 							  current->comm,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b340087..afb4b33 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -146,6 +146,13 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 		host->host_blocked = host->max_host_blocked;
 	else if (reason == SCSI_MLQUEUE_DEVICE_BUSY)
 		device->device_blocked = device->max_device_blocked;
+	else if (reason == SCSI_MLQUEUE_EH_RETRY) {
+		if (++cmd->retries > cmd->allowed) {
+			set_driver_byte(cmd, DRIVER_TIMEOUT);
+			scsi_finish_command(cmd);
+			return 0;
+		}
+	}
 
 	/*
 	 * Decrement the counters, since these commands are no longer
-- 
1.5.5.1

