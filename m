From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 16/20] target: Redo task allocation return value handling
Date: Thu,  7 Jul 2011 15:33:27 -0700
Message-ID: <1310078011-15504-17-git-send-email-agrover@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab1GGWds (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2011 18:33:48 -0400
In-Reply-To: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

allocate_control_task and allocate_data_tasks each return the number
of tasks they allocated, or -errno. Make this a little cleaner, and
fix a bug where -errno would not be caught in transport_new_cmd_obj().

Suggested by hch.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_transport.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2c81b10..00d7a7b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3916,7 +3916,7 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 					     cmd->data_direction,
 					     cmd->t_data_sg,
 					     cmd->t_data_nents);
-	if (!task_cdbs) {
+	if (task_cdbs <= 0) {
 		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		cmd->scsi_sense_reason =
 			TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -4163,6 +4163,7 @@ transport_allocate_control_task(struct se_cmd *cmd)
 	unsigned char *cdb;
 	struct se_task *task;
 	unsigned long flags;
+	int ret = 0;
 
 	task = transport_generic_get_task(cmd, cmd->data_direction);
 	if (!task)
@@ -4194,16 +4195,19 @@ transport_allocate_control_task(struct se_cmd *cmd)
 
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
@@ -4213,18 +4217,12 @@ static u32 transport_allocate_tasks(
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
1.7.1

