From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 02/13] scsi: Move retries check
Date: Mon, 22 Sep 2008 09:33:31 -0700
Message-ID: <1222101222-15079-3-git-send-email-andmike@linux.vnet.ibm.com>
References: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:51861 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbYIVQeA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2008 12:34:00 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8MGXwJa013726
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 12:33:58 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8MGXvjI138160
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 10:33:57 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8MMXvnU004823
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:33:57 -0600
Received: from localhost.localdomain (desktop-andmike.beaverton.ibm.com [9.47.22.92])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m8MMXlYK003971
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:33:56 -0600
In-Reply-To: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Move retries check to scsi_queue_insert.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_error.c |    8 ++------
 drivers/scsi/scsi_lib.c   |    7 +++++++
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d8000ef..55bf0e5 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1320,8 +1320,6 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	case DID_SOFT_ERROR:
 		goto maybe_retry;
 	case DID_IMM_RETRY:
-		return NEEDS_RETRY;
-
 	case DID_REQUEUE:
 		return ADD_TO_MLQUEUE;
 	case DID_TRANSPORT_DISRUPTED:
@@ -1429,8 +1427,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 * the request was not marked fast fail.  Note that above,
 	 * even if the request is marked fast fail, we still requeue
 	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
-	if ((++scmd->retries) <= scmd->allowed
-	    && !scsi_noretry_cmd(scmd)) {
+	if (!blk_noretry_request(scmd->request)) {
 		return NEEDS_RETRY;
 	} else {
 		/*
@@ -1555,8 +1552,7 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
 		if (scsi_device_online(scmd->device) &&
-		    !scsi_noretry_cmd(scmd) &&
-		    (++scmd->retries <= scmd->allowed)) {
+		    !blk_noretry_request(scmd->request)) {
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
 							  " retry cmd: %p\n",
 							  current->comm,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 83a8aae..557e511 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -153,6 +153,13 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	case SCSI_MLQUEUE_TARGET_BUSY:
 		starget->target_blocked = starget->max_target_blocked;
 		break;
+	case SCSI_MLQUEUE_EH_RETRY:
+		if (++cmd->retries > cmd->allowed) {
+			set_driver_byte(cmd, DRIVER_TIMEOUT);
+			scsi_finish_command(cmd);
+			return 0;
+		}
+		break;
 	}
 
 	/*
-- 
1.5.5.1

