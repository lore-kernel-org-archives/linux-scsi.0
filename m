From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] target: Fix tfo->write_pending() fabric callback ordering
Date: Mon, 13 Dec 2010 15:58:42 -0800
Message-ID: <1292284723-6806-2-git-send-email-nab@linux-iscsi.org>
References: <1292284723-6806-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm23.bullet.mail.sp2.yahoo.com ([98.139.91.93]:38855 "HELO
	nm23.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757027Ab0LMX6y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Dec 2010 18:58:54 -0500
In-Reply-To: <1292284723-6806-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves the call to transport_cmd_check_stop() to
clear the T_TASK(cmd)->t_transport_active=0 bit before calling
back into fabric module code via CMD_TFO(cmd)->write_pending()
in order to signal that WRITE data is ready to be transfered.

This fixes the case where transport_generic_handle_data() would have
to wait until T_TASK(cmd)->t_transport_active==0 before being able
to call transport_add_cmd_to_queue(cmd, TRANSPORT_PROCESS_WRITE)
to queue the completed WRITE paylods into TCM.  This allows
transport_generic_handle_data() to be called directly from interrupt
context code for HW target mode.

Note that the call to transport_cmd_check_stop() is safe with transport_off=1
preceeding CMD_TFO(cmd)->write_pending() because the se_cmd->se_lun pointer
is *not* being cleared for the write_pending case.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit 658efaabe00f86427761a0c79c38d757bb0e94fe)
---
 drivers/target/target_core_transport.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 63fb5ca..019ccbc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1995,18 +1995,13 @@ int transport_generic_handle_data(
 	struct se_cmd *cmd)
 {
 	/*
-	 * Make sure that the transport has been disabled by
-	 * transport_write_pending() before readding this struct se_cmd to the
-	 * processing queue.  If it has not yet been reset to zero by the
-	 * processing thread in transport_add_cmd_to_queue(), let other
-	 * processes run.  If a signal was received, then we assume the
-	 * connection is being failed/shutdown, so we return a failure.
+	 * For the software fabric case, then we assume the nexus is being
+	 * failed/shutdown when signals are pending from the kthread context
+	 * caller, so we return a failure.  For the HW target mode case running
+	 * in interrupt code, the signal_pending() check is skipped.
 	 */
-	while (atomic_read(&T_TASK(cmd)->t_transport_active)) {
-		msleep_interruptible(10);
-		if (signal_pending(current))
-			return -1;
-	}
+	if (!in_interrupt() && signal_pending(current))
+		return -1;
 	/*
 	 * If the received CDB has aleady been ABORTED by the generic
 	 * target engine, we now call transport_check_aborted_status()
@@ -5212,16 +5207,22 @@ static int transport_generic_write_pending(struct se_cmd *cmd)
 				T_TASK(cmd)->t_task_buf,
 				T_TASK(cmd)->t_task_pt_sgl);
 	/*
+	 * Clear the se_cmd for WRITE_PENDING status in order to set
+	 * T_TASK(cmd)->t_transport_active=0 so that transport_generic_handle_data
+	 * can be called from HW target mode interrupt code.  This is safe
+	 * to be called with transport_off=1 before the CMD_TFO(cmd)->write_pending
+	 * because the se_cmd->se_lun pointer is not being cleared.
+	 */
+	transport_cmd_check_stop(cmd, 1, 0);
+
+	/*
 	 * Call the fabric write_pending function here to let the
 	 * frontend know that WRITE buffers are ready.
 	 */
 	ret = CMD_TFO(cmd)->write_pending(cmd);
-	if (ret < 0) {
-		transport_cmd_check_stop(cmd, 1, 0);
+	if (ret < 0)
 		return ret;
-	}
 
-	transport_cmd_check_stop(cmd, 1, 0);
 	return PYX_TRANSPORT_WRITE_PENDING;
 }
 
-- 
1.5.6.5

