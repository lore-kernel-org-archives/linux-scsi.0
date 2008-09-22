From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 03/13] scsi: Move blk_noretry_request
Date: Mon, 22 Sep 2008 09:33:32 -0700
Message-ID: <1222101222-15079-4-git-send-email-andmike@linux.vnet.ibm.com>
References: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:52600 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYIVQeB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2008 12:34:01 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8MGQ1Yr016802
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 12:26:01 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8MGXxkp171052
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 10:33:59 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8MMXwcR004932
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:33:58 -0600
Received: from localhost.localdomain (desktop-andmike.beaverton.ibm.com [9.47.22.92])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m8MMXlYL003971
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:33:57 -0600
In-Reply-To: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Move blk_noretry_request check to scsi_queue_insert.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_error.c |   15 +--------------
 drivers/scsi/scsi_lib.c   |    3 ++-
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 55bf0e5..4eabb1a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1422,19 +1422,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
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
@@ -1551,8 +1539,7 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
-		if (scsi_device_online(scmd->device) &&
-		    !blk_noretry_request(scmd->request)) {
+		if (scsi_device_online(scmd->device)) {
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
 							  " retry cmd: %p\n",
 							  current->comm,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 557e511..2b65167 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -154,7 +154,8 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 		starget->target_blocked = starget->max_target_blocked;
 		break;
 	case SCSI_MLQUEUE_EH_RETRY:
-		if (++cmd->retries > cmd->allowed) {
+		if (blk_noretry_request(cmd->request) ||
+		    ++cmd->retries > cmd->allowed) {
 			set_driver_byte(cmd, DRIVER_TIMEOUT);
 			scsi_finish_command(cmd);
 			return 0;
-- 
1.5.5.1

