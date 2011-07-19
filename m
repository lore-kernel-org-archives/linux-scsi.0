From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: ->map_task_SG conversion to ->map_control_SG and ->map_data_SG
Date: Mon, 18 Jul 2011 23:00:10 -0700
Message-ID: <1311055210-5686-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm5-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.150]:27961 "HELO
	nm5-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751441Ab1GSFui (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2011 01:50:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch breaks up the ->map_task_SG() backend call into two seperate
->map_control_SG() and ->map_data_SG() in order to better address
IBLOCK and pSCSI.  IBLOCK only allocates bios for ->map_data_SG(), and
pSCSI will allocate a struct request for both cases.

This also drops following patch to target/iblock:

commit 338cdba84c710377aa94e60f33610cb293dd2e62
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Sat Jul 16 22:48:16 2011 -0700

    target/iblock: Make iblock_map_task_SG only for SCF_SCSI_DATA_SG_IO_CDB

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c    |    9 ++-------
 drivers/target/target_core_pscsi.c     |   14 +++++++++-----
 drivers/target/target_core_transport.c |    8 ++++----
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 957c208..7e12341 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -591,7 +591,7 @@ static struct bio *iblock_get_bio(
 	return bio;
 }
 
-static int iblock_map_task_SG(struct se_task *task)
+static int iblock_map_data_SG(struct se_task *task)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
 	struct se_device *dev = cmd->se_dev;
@@ -603,11 +603,6 @@ static int iblock_map_task_SG(struct se_task *task)
 	u32 i, sg_num = task->task_sg_nents;
 	sector_t block_lba;
 	/*
-	 * Only setup bios for SCF_SCSI_DATA_SG_IO_CDB type payloads
-	 */
-	if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
-		return 0;
-	/*
 	 * Do starting conversion up from non 512-byte blocksize with
 	 * struct se_task SCSI blocksize into Linux/Block 512 units for BIO.
 	 */
@@ -760,7 +755,7 @@ static struct se_subsystem_api iblock_template = {
 	.name			= "iblock",
 	.owner			= THIS_MODULE,
 	.transport_type		= TRANSPORT_PLUGIN_VHBA_PDEV,
-	.map_task_SG		= iblock_map_task_SG,
+	.map_data_SG		= iblock_map_data_SG,
 	.attach_hba		= iblock_attach_hba,
 	.detach_hba		= iblock_detach_hba,
 	.allocate_virtdevice	= iblock_allocate_virtdevice,
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index a2ce599..2b7b0da 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1049,7 +1049,7 @@ static inline struct bio *pscsi_get_bio(int sg_num)
 	return bio;
 }
 
-static int __pscsi_map_task_SG(
+static int __pscsi_map_SG(
 	struct se_task *task,
 	struct scatterlist *task_sg,
 	u32 task_sg_num,
@@ -1198,7 +1198,10 @@ fail:
 	return ret;
 }
 
-static int pscsi_map_task_SG(struct se_task *task)
+/*
+ * pSCSI maps both ->map_control_SG() and ->map_data_SG() to a single call.
+ */
+static int pscsi_map_SG(struct se_task *task)
 {
 	int ret;
 
@@ -1206,13 +1209,13 @@ static int pscsi_map_task_SG(struct se_task *task)
 	 * Setup the main struct request for the task->task_sg[] payload
 	 */
 
-	ret = __pscsi_map_task_SG(task, task->task_sg, task->task_sg_nents, 0);
+	ret = __pscsi_map_SG(task, task->task_sg, task->task_sg_nents, 0);
 	if (ret >= 0 && task->task_sg_bidi) {
 		/*
 		 * If present, set up the extra BIDI-COMMAND SCSI READ
 		 * struct request and payload.
 		 */
-		ret = __pscsi_map_task_SG(task, task->task_sg_bidi,
+		ret = __pscsi_map_SG(task, task->task_sg_bidi,
 					task->task_sg_nents, 1);
 	}
 
@@ -1340,7 +1343,8 @@ static struct se_subsystem_api pscsi_template = {
 	.owner			= THIS_MODULE,
 	.transport_type		= TRANSPORT_PLUGIN_PHBA_PDEV,
 	.cdb_none		= pscsi_CDB_none,
-	.map_task_SG		= pscsi_map_task_SG,
+	.map_control_SG		= pscsi_map_SG,
+	.map_data_SG		= pscsi_map_SG,
 	.attach_hba		= pscsi_attach_hba,
 	.detach_hba		= pscsi_detach_hba,
 	.pmode_enable_hba	= pscsi_pmode_enable_hba,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 27a3acd..8f9afdd 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4137,10 +4137,10 @@ static int transport_allocate_data_tasks(
 	list_for_each_entry(task, &cmd->t_task_list, t_list) {
 		if (atomic_read(&task->task_sent))
 			continue;
-		if (!dev->transport->map_task_SG)
+		if (!dev->transport->map_data_SG)
 			continue;
 
-		ret = dev->transport->map_task_SG(task);
+		ret = dev->transport->map_data_SG(task);
 		if (ret < 0)
 			return 0;
 	}
@@ -4183,8 +4183,8 @@ transport_allocate_control_task(struct se_cmd *cmd)
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) {
-		if (dev->transport->map_task_SG)
-			ret = dev->transport->map_task_SG(task);
+		if (dev->transport->map_control_SG)
+			ret = dev->transport->map_control_SG(task);
 	} else if (cmd->se_cmd_flags & SCF_SCSI_NON_DATA_CDB) {
 		if (dev->transport->cdb_none)
 			ret = dev->transport->cdb_none(task);
-- 
1.7.2.5

