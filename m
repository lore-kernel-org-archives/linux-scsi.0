From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 20/37] target: remove unused se_subsystem_api methods
Date: Fri, 14 Oct 2011 00:41:52 +0000
Message-ID: <1318552929-13341-21-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

The cdb_none, map_data_SG and map_control_SG methods have no callers left
and can be removed now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   32 ++------------------------------
 include/target/target_core_transport.h |   12 ------------
 2 files changed, 2 insertions(+), 42 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e590526..ae1efc7 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4023,7 +4023,7 @@ static int transport_allocate_data_tasks(
 	struct se_task *task;
 	struct se_device *dev = cmd->se_dev;
 	unsigned long flags;
-	int task_count, i, ret;
+	int task_count, i;
 	sector_t sectors, dev_max_sectors = dev->se_sub_dev->se_dev_attrib.max_sectors;
 	u32 sector_size = dev->se_sub_dev->se_dev_attrib.block_size;
 	struct scatterlist *sg;
@@ -4101,20 +4101,6 @@ static int transport_allocate_data_tasks(
 		list_add_tail(&task->t_list, &cmd->t_task_list);
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 	}
-	/*
-	 * Now perform the memory map of task->task_sg[] into backend
-	 * subsystem memory..
-	 */
-	list_for_each_entry(task, &cmd->t_task_list, t_list) {
-		if (atomic_read(&task->task_sent))
-			continue;
-		if (!dev->transport->map_data_SG)
-			continue;
-
-		ret = dev->transport->map_data_SG(task);
-		if (ret < 0)
-			return 0;
-	}
 
 	return task_count;
 }
@@ -4126,7 +4112,6 @@ transport_allocate_control_task(struct se_cmd *cmd)
 	unsigned char *cdb;
 	struct se_task *task;
 	unsigned long flags;
-	int ret = 0;
 
 	task = transport_generic_get_task(cmd, cmd->data_direction);
 	if (!task)
@@ -4153,21 +4138,8 @@ transport_allocate_control_task(struct se_cmd *cmd)
 	list_add_tail(&task->t_list, &cmd->t_task_list);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-	if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) {
-		if (dev->transport->map_control_SG)
-			ret = dev->transport->map_control_SG(task);
-	} else if (cmd->se_cmd_flags & SCF_SCSI_NON_DATA_CDB) {
-		if (dev->transport->cdb_none)
-			ret = dev->transport->cdb_none(task);
-	} else {
-		pr_err("target: Unknown control cmd type!\n");
-		BUG();
-	}
-
 	/* Success! Return number of tasks allocated */
-	if (ret == 0)
-		return 1;
-	return ret;
+	return 1;
 }
 
 static u32 transport_allocate_tasks(
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index e67feeb..549b6b3 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -234,18 +234,6 @@ struct se_subsystem_api {
 	 */
 	struct list_head sub_api_list;
 	/*
-	 * For SCF_SCSI_NON_DATA_CDB
-	 */
-	int (*cdb_none)(struct se_task *);
-	/*
-	 * For SCF_SCSI_DATA_SG_IO_CDB
-	 */
-	int (*map_data_SG)(struct se_task *);
-	/*
-	 * For SCF_SCSI_CONTROL_SG_IO_CDB
-	 */
-	int (*map_control_SG)(struct se_task *);
-	/*
 	 * attach_hba():
 	 */
 	int (*attach_hba)(struct se_hba *, u32);
-- 
1.5.6.5
