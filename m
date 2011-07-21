From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 097/103] target: Redo task allocation return value handling
Date: Thu, 21 Jul 2011 07:05:29 +0000
Message-ID: <1311231935-24635-98-git-send-email-nab@linux-iscsi.org>
References: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51685 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1GUH3h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2011 03:29:37 -0400
In-Reply-To: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

allocate_control_task and allocate_data_tasks each return the number
of tasks they allocated, or -errno. Make this a little cleaner, and
fix a bug where -errno would not be caught in transport_new_cmd_obj().

Suggested by hch.

(nab: Fix transport_allocate_tasks() return check for bidi operation)

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   32 +++++++++++++++-----------------
 1 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9cefdf4..8d84af1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3891,7 +3891,7 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 					      DMA_FROM_DEVICE,
 					      cmd->t_bidi_data_sg,
 					      cmd->t_bidi_data_nents);
-		if (!rc) {
+		if (rc <= 0) {
 			cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 			cmd->scsi_sense_reason =
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -3910,7 +3910,7 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 					     cmd->data_direction,
 					     cmd->t_data_sg,
 					     cmd->t_data_nents);
-	if (!task_cdbs) {
+	if (task_cdbs <= 0) {
 		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		cmd->scsi_sense_reason =
 			TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -4169,6 +4169,7 @@ transport_allocate_control_task(struct se_cmd *cmd)
 	unsigned char *cdb;
 	struct se_task *task;
 	unsigned long flags;
+	int ret = 0;
 
 	task = transport_generic_get_task(cmd, cmd->data_direction);
 	if (!task)
@@ -4197,16 +4198,19 @@ transport_allocate_control_task(struct se_cmd *cmd)
 
 	if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) {
 		if (dev->transport->map_task_SG)
-			return dev->transport->map_task_SG(task);
-		return 0;
+			ret = dev->transport->map_task_SG(task);
 	} else if (cmd->se_cmd_flags & SCF_SCSI_NON_DATA_CDB) {
 		if (dev->transport->cdb_none)
-			return dev->transport->cdb_none(task);
-		return 0;
+			ret = dev->transport->cdb_none(task);
 	} else {
+		pr_err("target: Unknown control cmd type!\n");
 		BUG();
-		return -ENOMEM;
 	}
+
+	/* Success! Return number of tasks allocated */
+	if (ret == 0)
+		return 1;
+	return ret;
 }
 
 static u32 transport_allocate_tasks(
@@ -4216,18 +4220,12 @@ static u32 transport_allocate_tasks(
 	struct scatterlist *sgl,
 	unsigned int sgl_nents)
 {
-	int ret;
-
-	if (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) {
+	if (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB)
 		return transport_allocate_data_tasks(cmd, lba, data_direction,
 						     sgl, sgl_nents);
-	} else {
-		ret = transport_allocate_control_task(cmd);
-		if (ret < 0)
-			return ret;
-		else
-			return 1;
-	}
+	else
+		return transport_allocate_control_task(cmd);
+
 }
 
 
-- 
1.7.6

