From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 05/14] scsi: Move blk_noretry_request
Date: Tue,  2 Sep 2008 09:05:34 -0700
Message-ID: <1220371543-15099-6-git-send-email-andmike@linux.vnet.ibm.com>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39480 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbYIBQFu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 12:05:50 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82G5liY027551
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:47 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82G5lUv191334
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:47 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82G5kPW021071
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:47 -0400
In-Reply-To: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

Move blk_noretry_request check to scsi_queue_insert.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_error.c |   15 +--------------
 drivers/scsi/scsi_lib.c   |    3 ++-
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index eb4290a..5c112e2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1449,19 +1449,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	return FAILED;
 
       maybe_retry:
-
-	/* we requeue for retry because the error was retryable, and
-	 * the request was not marked fast fail.  Note that above,
-	 * even if the request is marked fast fail, we still requeue
-	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
-	if (!blk_noretry_request(scmd->request)) {
 		return NEEDS_RETRY;
-	} else {
-		/*
-		 * no more retries - report this one back to upper level.
-		 */
-		return SUCCESS;
-	}
 }
 
 /**
@@ -1578,8 +1566,7 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
-		if (scsi_device_online(scmd->device) &&
-		    !blk_noretry_request(scmd->request)) {
+		if (scsi_device_online(scmd->device)) {
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
 							  " retry cmd: %p\n",
 							  current->comm,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index afb4b33..a085973 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -147,7 +147,8 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	else if (reason == SCSI_MLQUEUE_DEVICE_BUSY)
 		device->device_blocked = device->max_device_blocked;
 	else if (reason == SCSI_MLQUEUE_EH_RETRY) {
-		if (++cmd->retries > cmd->allowed) {
+		if (blk_noretry_request(cmd->request) ||
+		    ++cmd->retries > cmd->allowed) {
 			set_driver_byte(cmd, DRIVER_TIMEOUT);
 			scsi_finish_command(cmd);
 			return 0;
-- 
1.5.5.1

