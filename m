From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 10/13] scsi: move device online check to scsi_attempt_requeue_command
Date: Mon, 22 Sep 2008 09:33:39 -0700
Message-ID: <1222101222-15079-11-git-send-email-andmike@linux.vnet.ibm.com>
References: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:49720 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYIVQeI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2008 12:34:08 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8MGY6nf020822
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 12:34:06 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8MGY679191470
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 10:34:06 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8MMY6Sp005315
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:34:06 -0600
Received: from localhost.localdomain (desktop-andmike.beaverton.ibm.com [9.47.22.92])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m8MMXlYS003971
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:34:04 -0600
In-Reply-To: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Move the device online check from scsi_eh_flush_done_q to
scsi_attempt_requeue_command so that it can be shared by other callers and
simplifies scsi_eh_flush_done_q. To provide similar behavior also move
the setting of a zero result value to scsi_eh_finish_cmd.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_error.c |   26 ++++++--------------------
 drivers/scsi/scsi_lib.c   |    6 ++++++
 2 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c0254ec..4fbc28a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -774,6 +774,8 @@ void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
 {
 	scmd->device->host->host_failed--;
 	scmd->eh_eflags = 0;
+	if (!scmd->result)
+		scmd->result |= (DRIVER_TIMEOUT << 24);
 	list_move_tail(&scmd->eh_entry, done_q);
 }
 EXPORT_SYMBOL(scsi_eh_finish_cmd);
@@ -1529,26 +1531,10 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 
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
index 39c5929..8f09407 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -136,6 +136,12 @@ int scsi_attempt_requeue_command(struct scsi_cmnd *cmd, int reason)
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

