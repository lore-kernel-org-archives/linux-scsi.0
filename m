From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 12/14] scsi: move device online check to scsi_attempt_requeue_command
Date: Tue,  2 Sep 2008 09:05:41 -0700
Message-ID: <1220371543-15099-13-git-send-email-andmike@linux.vnet.ibm.com>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39487 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbYIBQFv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 12:05:51 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82G5oN1027591
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:50 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82G5oXN233560
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:50 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82G5oBk021391
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:50 -0400
In-Reply-To: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

Move the device online check from scsi_eh_flush_done_q to
scsi_attempt_requeue_command so that it can be shared by other callers and
simplifies scsi_eh_flush_done_q. To provide similar behavior also move
the setting of a zero result value to scsi_eh_finish_cmd.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_error.c |   26 ++++++--------------------
 drivers/scsi/scsi_lib.c   |    6 ++++++
 2 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 417f119..c9b5598 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -835,6 +835,8 @@ void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
 {
 	scmd->device->host->host_failed--;
 	scmd->eh_eflags = 0;
+	if (!scmd->result)
+		scmd->result |= (DRIVER_TIMEOUT << 24);
 	list_move_tail(&scmd->eh_entry, done_q);
 }
 EXPORT_SYMBOL(scsi_eh_finish_cmd);
@@ -1555,26 +1557,10 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
-		if (scsi_device_online(scmd->device)) {
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
-							  " retry cmd: %p\n",
-							  current->comm,
-							  scmd));
-			scsi_attempt_requeue_command(scmd,
-						     SCSI_MLQUEUE_DIS_RETRY);
-		} else {
-			/*
-			 * If just we got sense for the device (called
-			 * scsi_eh_get_sense), scmd->result is already
-			 * set, do not set DRIVER_TIMEOUT.
-			 */
-			if (!scmd->result)
-				scmd->result |= (DRIVER_TIMEOUT << 24);
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
-							" cmd: %p\n",
-							current->comm, scmd));
-			scsi_finish_command(scmd);
-		}
+		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
+						  "attempt retry cmd: %p\n",
+						  current->comm, scmd));
+		scsi_attempt_requeue_command(scmd, SCSI_MLQUEUE_DIS_RETRY);
 	}
 }
 EXPORT_SYMBOL(scsi_eh_flush_done_q);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3f01015..38c118f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -135,6 +135,12 @@ int scsi_attempt_requeue_command(struct scsi_cmnd *cmd, int reason)
 		return 0;
 	}
 
+	if (!scsi_device_online(cmd->device)) {
+		set_driver_byte(cmd, DRIVER_TIMEOUT);
+		scsi_finish_command(cmd);
+		return 0;
+	}
+
 	/*
 	 * Set the appropriate busy bit for the device/host.
 	 *
-- 
1.5.5.1

