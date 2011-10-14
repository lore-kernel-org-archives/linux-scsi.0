From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 36/37] target: replace ->get_cdb with a target_get_task_cdb helper
Date: Fri, 14 Oct 2011 00:42:08 +0000
Message-ID: <1318552929-13341-37-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33529 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab1JNAqQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2011 20:46:16 -0400
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

From: Christoph Hellwig <hch@infradead.org>

Instead of calling out to the backends from the core to get a per-task
CDB and then modify it for the LBA/len pair used for this CDB provide
a helper that writes the adjusted CDB into a provided buffer and call
this method from ->do_task in pscsi.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_cdb.c       |   16 ++++++++++++++++
 drivers/target/target_core_pscsi.c     |   15 ++-------------
 drivers/target/target_core_transport.c |   18 ------------------
 include/target/target_core_transport.h |    5 +----
 4 files changed, 19 insertions(+), 35 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 0d02391..fb0b630 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -1265,3 +1265,19 @@ transport_emulate_control_cdb(struct se_task *task)
 
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 }
+
+/*
+ * Write a CDB into @cdb that is based on the one the intiator sent us,
+ * but updated to only cover the sectors that the current task handles.
+ */
+void target_get_task_cdb(struct se_task *task, unsigned char *cdb)
+{
+	struct se_cmd *cmd = task->task_se_cmd;
+
+	memcpy(cdb, cmd->t_task_cdb, scsi_command_size(cmd->t_task_cdb));
+	if (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) {
+		cmd->transport_split_cdb(task->task_lba, task->task_sectors,
+					 cdb);
+	}
+}
+EXPORT_SYMBOL(target_get_task_cdb);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index b347862..936b9fe 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1068,6 +1068,8 @@ static int pscsi_do_task(struct se_task *task)
 	struct bio *hbio;
 	int ret;
 
+	target_get_task_cdb(task, pt->pscsi_cdb);
+
 	if (task->task_se_cmd->se_cmd_flags & SCF_SCSI_NON_DATA_CDB) {
 		req = blk_get_request(pdv->pdv_sd->request_queue,
 				(task->task_data_direction == DMA_TO_DEVICE),
@@ -1150,18 +1152,6 @@ fail:
 	return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
 }
 
-
-/*	pscsi_get_cdb():
- *
- *
- */
-static unsigned char *pscsi_get_cdb(struct se_task *task)
-{
-	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
-
-	return pt->pscsi_cdb;
-}
-
 /*	pscsi_get_sense_buffer():
  *
  *
@@ -1276,7 +1266,6 @@ static struct se_subsystem_api pscsi_template = {
 	.check_configfs_dev_params = pscsi_check_configfs_dev_params,
 	.set_configfs_dev_params = pscsi_set_configfs_dev_params,
 	.show_configfs_dev_params = pscsi_show_configfs_dev_params,
-	.get_cdb		= pscsi_get_cdb,
 	.get_sense_buffer	= pscsi_get_sense_buffer,
 	.get_device_rev		= pscsi_get_device_rev,
 	.get_device_type	= pscsi_get_device_type,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8959696..3025a6f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3958,17 +3958,6 @@ static int transport_allocate_data_tasks(
 		task->task_sectors = min(sectors, dev_max_sectors);
 		task->task_size = task->task_sectors * sector_size;
 
-		if (dev->transport->get_cdb) {
-			unsigned char *cdb = dev->transport->get_cdb(task);
-
-			memcpy(cdb, cmd->t_task_cdb,
-			       scsi_command_size(cmd->t_task_cdb));
-
-			/* Update new cdb with updated lba/sectors */
-			cmd->transport_split_cdb(task->task_lba,
-						 task->task_sectors, cdb);
-		}
-
 		/*
 		 * This now assumes that passed sg_ents are in PAGE_SIZE chunks
 		 * in order to calculate the number per task SGL entries
@@ -4022,7 +4011,6 @@ static int transport_allocate_data_tasks(
 static int
 transport_allocate_control_task(struct se_cmd *cmd)
 {
-	struct se_device *dev = cmd->se_dev;
 	struct se_task *task;
 	unsigned long flags;
 
@@ -4030,12 +4018,6 @@ transport_allocate_control_task(struct se_cmd *cmd)
 	if (!task)
 		return -ENOMEM;
 
-	if (dev->transport->get_cdb) {
-		unsigned char *cdb = dev->transport->get_cdb(task);
-
-		memcpy(cdb, cmd->t_task_cdb, scsi_command_size(cmd->t_task_cdb));
-	}
-
 	task->task_sg = kmalloc(sizeof(struct scatterlist) * cmd->t_data_nents,
 				GFP_KERNEL);
 	if (!task->task_sg) {
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index c5eb259..171c235 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -190,6 +190,7 @@ extern int transport_generic_do_tmr(struct se_cmd *);
 extern int core_alua_check_nonop_delay(struct se_cmd *);
 /* From target_core_cdb.c */
 extern int transport_emulate_control_cdb(struct se_task *);
+extern void target_get_task_cdb(struct se_task *task, unsigned char *cdb);
 
 /*
  * Each se_transport_task_t can have N number of possible struct se_task's
@@ -309,10 +310,6 @@ struct se_subsystem_api {
 	ssize_t (*show_configfs_dev_params)(struct se_hba *, struct se_subsystem_dev *,
 						char *);
 	/*
-	 * get_cdb():
-	 */
-	unsigned char *(*get_cdb)(struct se_task *);
-	/*
 	 * get_device_rev():
 	 */
 	u32 (*get_device_rev)(struct se_device *);
-- 
1.5.6.5

