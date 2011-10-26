From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Check -ENOMEM to signal QUEUE_FULL from fabric callbacks
Date: Wed, 26 Oct 2011 07:12:58 +0000
Message-ID: <1319613178-8445-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56760 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab1JZHOi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2011 03:14:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes target core to also check for -ENOMEM from fabric callbacks
to signal QUEUE_FULL status, instead of just -EAGAIN in order to catch a
larger set of fabric failure cases that want to trigger QUEUE_FULL logic.
This includes the callbacks for ->write_pending(), ->queue_data_in() and
->queue_status().

It also makes transport_generic_write_pending() return zero upon QUEUE_FULL,
and removes two unnecessary -EAGAIN checks to catch write pending QUEUE_FULL
cases from transport_generic_new_cmd() failures in transport_handle_cdb_direct()
and transport_processing_thread():TRANSPORT_NEW_CMD_MAP state.

Reported-by: Bart Van Assche <bvanassche@acm.org>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index bfd420c..1821606 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -911,7 +911,7 @@ void transport_remove_task_from_execute_queue(
 }
 
 /*
- * Handle QUEUE_FULL / -EAGAIN status
+ * Handle QUEUE_FULL / -EAGAIN and -ENOMEM status
  */
 
 static void target_qf_do_work(struct work_struct *work)
@@ -1647,9 +1647,7 @@ int transport_handle_cdb_direct(
 	 * and call transport_generic_request_failure() if necessary..
 	 */
 	ret = transport_generic_new_cmd(cmd);
-	if (ret == -EAGAIN)
-		return 0;
-	else if (ret < 0) {
+	if (ret < 0) {
 		cmd->transport_error_status = ret;
 		transport_generic_request_failure(cmd, 0,
 				(cmd->data_direction != DMA_TO_DEVICE));
@@ -1888,7 +1886,7 @@ static void transport_generic_request_failure(
 				ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS);
 
 		ret = cmd->se_tfo->queue_status(cmd);
-		if (ret == -EAGAIN)
+		if (ret == -EAGAIN || ret == -ENOMEM)
 			goto queue_full;
 		goto check_stop;
 	case PYX_TRANSPORT_USE_SENSE_REASON:
@@ -1915,7 +1913,7 @@ static void transport_generic_request_failure(
 	else {
 		ret = transport_send_check_condition_and_sense(cmd,
 				cmd->scsi_sense_reason, 0);
-		if (ret == -EAGAIN)
+		if (ret == -EAGAIN || ret == -ENOMEM)
 			goto queue_full;
 	}
 
@@ -3310,7 +3308,7 @@ static void target_complete_ok_work(struct work_struct *work)
 		if (cmd->scsi_status) {
 			ret = transport_send_check_condition_and_sense(
 					cmd, reason, 1);
-			if (ret == -EAGAIN)
+			if (ret == -EAGAIN || ret == -ENOMEM)
 				goto queue_full;
 
 			transport_lun_remove_cmd(cmd);
@@ -3335,7 +3333,7 @@ static void target_complete_ok_work(struct work_struct *work)
 		spin_unlock(&cmd->se_lun->lun_sep_lock);
 
 		ret = cmd->se_tfo->queue_data_in(cmd);
-		if (ret == -EAGAIN)
+		if (ret == -EAGAIN || ret == -ENOMEM)
 			goto queue_full;
 		break;
 	case DMA_TO_DEVICE:
@@ -3356,14 +3354,14 @@ static void target_complete_ok_work(struct work_struct *work)
 			}
 			spin_unlock(&cmd->se_lun->lun_sep_lock);
 			ret = cmd->se_tfo->queue_data_in(cmd);
-			if (ret == -EAGAIN)
+			if (ret == -EAGAIN || ret == -ENOMEM)
 				goto queue_full;
 			break;
 		}
 		/* Fall through for DMA_TO_DEVICE */
 	case DMA_NONE:
 		ret = cmd->se_tfo->queue_status(cmd);
-		if (ret == -EAGAIN)
+		if (ret == -EAGAIN || ret == -ENOMEM)
 			goto queue_full;
 		break;
 	default:
@@ -3892,7 +3890,10 @@ EXPORT_SYMBOL(transport_generic_process_write);
 
 static void transport_write_pending_qf(struct se_cmd *cmd)
 {
-	if (cmd->se_tfo->write_pending(cmd) == -EAGAIN) {
+	int ret;
+
+	ret = cmd->se_tfo->write_pending(cmd);
+	if (ret == -EAGAIN || ret == -ENOMEM) {
 		pr_debug("Handling write_pending QUEUE__FULL: se_cmd: %p\n",
 			 cmd);
 		transport_handle_queue_full(cmd, cmd->se_dev);
@@ -3922,7 +3923,7 @@ static int transport_generic_write_pending(struct se_cmd *cmd)
 	 * frontend know that WRITE buffers are ready.
 	 */
 	ret = cmd->se_tfo->write_pending(cmd);
-	if (ret == -EAGAIN)
+	if (ret == -EAGAIN || ret == -ENOMEM)
 		goto queue_full;
 	else if (ret < 0)
 		return ret;
@@ -3933,7 +3934,7 @@ queue_full:
 	pr_debug("Handling write_pending QUEUE__FULL: se_cmd: %p\n", cmd);
 	cmd->t_state = TRANSPORT_COMPLETE_QF_WP;
 	transport_handle_queue_full(cmd, cmd->se_dev);
-	return ret;
+	return 0;
 }
 
 /**
@@ -4585,9 +4586,7 @@ get_cmd:
 				break;
 			}
 			ret = transport_generic_new_cmd(cmd);
-			if (ret == -EAGAIN)
-				break;
-			else if (ret < 0) {
+			if (ret < 0) {
 				cmd->transport_error_status = ret;
 				transport_generic_request_failure(cmd,
 					0, (cmd->data_direction !=
-- 
1.7.2.5

