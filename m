From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 35/37] target: make the ->get_cdb method optional
Date: Fri, 14 Oct 2011 00:42:07 +0000
Message-ID: <1318552929-13341-36-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

The most commonly used file, iblock and rd backends have no use for
a per-task CDB and thus don't need a method to copy it into their
otherwise unused CDB fields.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c      |   12 ------------
 drivers/target/target_core_file.h      |    4 +---
 drivers/target/target_core_iblock.c    |    6 ------
 drivers/target/target_core_iblock.h    |    1 -
 drivers/target/target_core_rd.c        |   12 ------------
 drivers/target/target_core_rd.h        |    2 --
 drivers/target/target_core_transport.c |   26 ++++++++++++++------------
 7 files changed, 15 insertions(+), 48 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 524f41a..98aa583 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -609,17 +609,6 @@ static ssize_t fd_show_configfs_dev_params(
 	return bl;
 }
 
-/*	fd_get_cdb(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static unsigned char *fd_get_cdb(struct se_task *task)
-{
-	struct fd_request *req = FILE_REQ(task);
-
-	return req->fd_scsi_cdb;
-}
-
 /*	fd_get_device_rev(): (Part of se_subsystem_api_t template)
  *
  *
@@ -667,7 +656,6 @@ static struct se_subsystem_api fileio_template = {
 	.check_configfs_dev_params = fd_check_configfs_dev_params,
 	.set_configfs_dev_params = fd_set_configfs_dev_params,
 	.show_configfs_dev_params = fd_show_configfs_dev_params,
-	.get_cdb		= fd_get_cdb,
 	.get_device_rev		= fd_get_device_rev,
 	.get_device_type	= fd_get_device_type,
 	.get_blocks		= fd_get_blocks,
diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core_file.h
index daebd71..59e6e73 100644
--- a/drivers/target/target_core_file.h
+++ b/drivers/target/target_core_file.h
@@ -14,9 +14,7 @@
 
 struct fd_request {
 	struct se_task	fd_task;
-	/* SCSI CDB from iSCSI Command PDU */
-	unsigned char	fd_scsi_cdb[TCM_MAX_COMMAND_SIZE];
-} ____cacheline_aligned;
+};
 
 #define FBDF_HAS_PATH		0x01
 #define FBDF_HAS_SIZE		0x02
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 21a3677..bf074c4 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -618,11 +618,6 @@ fail:
 	return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
 }
 
-static unsigned char *iblock_get_cdb(struct se_task *task)
-{
-	return IBLOCK_REQ(task)->ib_scsi_cdb;
-}
-
 static u32 iblock_get_device_rev(struct se_device *dev)
 {
 	return SCSI_SPC_2; /* Returns SPC-3 in Initiator Data */
@@ -696,7 +691,6 @@ static struct se_subsystem_api iblock_template = {
 	.check_configfs_dev_params = iblock_check_configfs_dev_params,
 	.set_configfs_dev_params = iblock_set_configfs_dev_params,
 	.show_configfs_dev_params = iblock_show_configfs_dev_params,
-	.get_cdb		= iblock_get_cdb,
 	.get_device_rev		= iblock_get_device_rev,
 	.get_device_type	= iblock_get_device_type,
 	.get_blocks		= iblock_get_blocks,
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 7a76f66..5cf1860 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -8,7 +8,6 @@
 
 struct iblock_req {
 	struct se_task ib_task;
-	unsigned char ib_scsi_cdb[TCM_MAX_COMMAND_SIZE];
 	atomic_t ib_bio_cnt;
 	atomic_t ib_bio_err_cnt;
 } ____cacheline_aligned;
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index daf95db..5158d38 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -691,17 +691,6 @@ static ssize_t rd_show_configfs_dev_params(
 	return bl;
 }
 
-/*	rd_get_cdb(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static unsigned char *rd_get_cdb(struct se_task *task)
-{
-	struct rd_request *req = RD_REQ(task);
-
-	return req->rd_scsi_cdb;
-}
-
 static u32 rd_get_device_rev(struct se_device *dev)
 {
 	return SCSI_SPC_2; /* Returns SPC-3 in Initiator Data */
@@ -735,7 +724,6 @@ static struct se_subsystem_api rd_mcp_template = {
 	.check_configfs_dev_params = rd_check_configfs_dev_params,
 	.set_configfs_dev_params = rd_set_configfs_dev_params,
 	.show_configfs_dev_params = rd_show_configfs_dev_params,
-	.get_cdb		= rd_get_cdb,
 	.get_device_rev		= rd_get_device_rev,
 	.get_device_type	= rd_get_device_type,
 	.get_blocks		= rd_get_blocks,
diff --git a/drivers/target/target_core_rd.h b/drivers/target/target_core_rd.h
index 0d02773..784e56a 100644
--- a/drivers/target/target_core_rd.h
+++ b/drivers/target/target_core_rd.h
@@ -22,8 +22,6 @@ void rd_module_exit(void);
 struct rd_request {
 	struct se_task	rd_task;
 
-	/* SCSI CDB from iSCSI Command PDU */
-	unsigned char	rd_scsi_cdb[TCM_MAX_COMMAND_SIZE];
 	/* Offset from start of page */
 	u32		rd_offset;
 	/* Starting page in Ramdisk for request */
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4a787a0..8959696 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3932,7 +3932,6 @@ static int transport_allocate_data_tasks(
 	struct scatterlist *sgl,
 	unsigned int sgl_nents)
 {
-	unsigned char *cdb = NULL;
 	struct se_task *task;
 	struct se_device *dev = cmd->se_dev;
 	unsigned long flags;
@@ -3959,14 +3958,17 @@ static int transport_allocate_data_tasks(
 		task->task_sectors = min(sectors, dev_max_sectors);
 		task->task_size = task->task_sectors * sector_size;
 
-		cdb = dev->transport->get_cdb(task);
-		BUG_ON(!cdb);
+		if (dev->transport->get_cdb) {
+			unsigned char *cdb = dev->transport->get_cdb(task);
 
-		memcpy(cdb, cmd->t_task_cdb,
-		       scsi_command_size(cmd->t_task_cdb));
+			memcpy(cdb, cmd->t_task_cdb,
+			       scsi_command_size(cmd->t_task_cdb));
+
+			/* Update new cdb with updated lba/sectors */
+			cmd->transport_split_cdb(task->task_lba,
+						 task->task_sectors, cdb);
+		}
 
-		/* Update new cdb with updated lba/sectors */
-		cmd->transport_split_cdb(task->task_lba, task->task_sectors, cdb);
 		/*
 		 * This now assumes that passed sg_ents are in PAGE_SIZE chunks
 		 * in order to calculate the number per task SGL entries
@@ -4021,7 +4023,6 @@ static int
 transport_allocate_control_task(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	unsigned char *cdb;
 	struct se_task *task;
 	unsigned long flags;
 
@@ -4029,10 +4030,11 @@ transport_allocate_control_task(struct se_cmd *cmd)
 	if (!task)
 		return -ENOMEM;
 
-	cdb = dev->transport->get_cdb(task);
-	BUG_ON(!cdb);
-	memcpy(cdb, cmd->t_task_cdb,
-	       scsi_command_size(cmd->t_task_cdb));
+	if (dev->transport->get_cdb) {
+		unsigned char *cdb = dev->transport->get_cdb(task);
+
+		memcpy(cdb, cmd->t_task_cdb, scsi_command_size(cmd->t_task_cdb));
+	}
 
 	task->task_sg = kmalloc(sizeof(struct scatterlist) * cmd->t_data_nents,
 				GFP_KERNEL);
-- 
1.5.6.5
