From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 8/8] target: remove struct se_transform_info
Date: Tue, 23 Nov 2010 17:31:01 -0500
Message-ID: <20101123223111.263485253@bombadil.infradead.org>
References: <20101123223053.574330460@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50183 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab0KWWbM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 17:31:12 -0500
Content-Disposition: inline; filename=kill-se_transform_info
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

No quite sure what the original use was, but these days it's almost
completely superflous.  Besides the two different ways to pass the
se_device that can also be retreived from the se_cmd it only contained
a set_counts flag for transport_generic_get_cdb_count, which can more
easily be passed directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/target_core_transport.c
===================================================================
--- lio-core.orig/drivers/target/target_core_transport.c	2010-11-23 22:49:12.398253389 +0100
+++ lio-core/drivers/target/target_core_transport.c	2010-11-23 23:06:36.652273294 +0100
@@ -203,17 +203,15 @@ typedef int (*map_func_t)(struct se_task
 
 static int transport_generic_write_pending(struct se_cmd *);
 static int transport_processing_thread(void *);
-static int transport_new_cmd_obj(struct se_cmd *cmd,
-		struct se_transform_info *ti, int post_execute);
+static int transport_new_cmd_obj(struct se_cmd *cmd);
 static int __transport_execute_tasks(struct se_device *dev);
 static void transport_complete_task_attr(struct se_cmd *cmd);
 static void transport_direct_request_timeout(struct se_cmd *cmd);
 static void transport_free_dev_tasks(struct se_cmd *cmd);
-static u32 transport_generic_get_cdb_count(
-		struct se_cmd *cmd, struct se_transform_info *ti,
+static u32 transport_generic_get_cdb_count(struct se_cmd *cmd,
 		unsigned long long starting_lba, u32 sectors,
 		enum dma_data_direction data_direction,
-		struct list_head *mem_list);
+		struct list_head *mem_list, int set_counts);
 static int transport_generic_get_mem(struct se_cmd *cmd, u32 length,
 		u32 dma_size);
 static int transport_generic_remove(struct se_cmd *cmd,
@@ -2063,15 +2061,9 @@ static inline void transport_generic_pre
 	}
 }
 
-/*	transport_generic_get_task():
- *
- *
- */
-static struct se_task *transport_generic_get_task(
-	struct se_transform_info *ti,
-	struct se_cmd *cmd,
-	void *se_obj_ptr,
-	enum dma_data_direction data_direction)
+static struct se_task *
+transport_generic_get_task(struct se_cmd *cmd,
+		enum dma_data_direction data_direction)
 {
 	struct se_task *task;
 	struct se_device *dev = SE_DEV(cmd);
@@ -2092,14 +2084,10 @@ static struct se_task *transport_generic
 	task->se_dev = dev;
 	task->task_data_direction = data_direction;
 
-	DEBUG_SO("se_obj_ptr: %p\n", se_obj_ptr);
-
 	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
 	list_add_tail(&task->t_list, &T_TASK(cmd)->t_task_list);
 	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 
-	task->se_obj_ptr = se_obj_ptr;
-
 	return task;
 }
 
@@ -2844,7 +2832,7 @@ static void transport_task_timeout_handl
  */
 static void transport_start_task_timer(struct se_task *task)
 {
-	struct se_device *dev = task->se_obj_ptr;
+	struct se_device *dev = task->se_dev;
 	int timeout;
 
 	if (task->task_flags & TF_RUNNING)
@@ -4081,7 +4069,6 @@ struct se_cmd *transport_allocate_passth
 	void *type_ptr)
 {
 	struct se_cmd *cmd;
-	struct se_transform_info ti;
 
 	cmd = transport_alloc_passthrough_cmd(length, data_direction);
 	if (!(cmd))
@@ -4116,14 +4103,6 @@ struct se_cmd *transport_allocate_passth
 	if (transport_generic_allocate_tasks(cmd, cdb) < 0)
 		goto fail;
 
-	memset(&ti, 0, sizeof(struct se_transform_info));
-	ti.ti_data_length = cmd->data_length;
-	ti.ti_dev = SE_LUN(cmd)->lun_se_dev;
-	ti.ti_se_cmd = cmd;
-	ti.se_obj_ptr = type_ptr;
-
-	DEBUG_SO("ti.se_obj_ptr: %p\n", ti.se_obj_ptr);
-
 	if (!mem) {
 		if (transport_allocate_resources(cmd) < 0)
 			goto fail;
@@ -4167,7 +4146,7 @@ struct se_cmd *transport_allocate_passth
 	if (transport_get_sectors(cmd) < 0)
 		goto fail;
 
-	if (transport_new_cmd_obj(cmd, &ti, 0) < 0)
+	if (transport_new_cmd_obj(cmd) < 0)
 		goto fail;
 
 	return cmd;
@@ -4836,10 +4815,7 @@ static int transport_get_sectors(struct
 	return 0;
 }
 
-static int transport_new_cmd_obj(
-	struct se_cmd *cmd,
-	struct se_transform_info *ti,
-	int post_execute)
+static int transport_new_cmd_obj(struct se_cmd *cmd)
 {
 	struct se_device *dev = SE_DEV(cmd);
 	u32 task_cdbs = 0, rc;
@@ -4848,8 +4824,8 @@ static int transport_new_cmd_obj(
 		task_cdbs++;
 		T_TASK(cmd)->t_task_cdbs++;
 	} else {
-		ti->ti_set_counts = 1;
-		ti->ti_dev = dev;
+		int set_counts = 1;
+
 		/*
 		 * Setup any BIDI READ tasks and memory from
 		 * T_TASK(cmd)->t_mem_bidi_list so the READ struct se_tasks
@@ -4857,26 +4833,28 @@ static int transport_new_cmd_obj(
 		 */
 		if ((T_TASK(cmd)->t_mem_bidi_list != NULL) &&
 		    (TRANSPORT(dev)->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV)) {
-			rc = transport_generic_get_cdb_count(cmd, ti,
+			rc = transport_generic_get_cdb_count(cmd,
 				T_TASK(cmd)->t_task_lba,
 				T_TASK(cmd)->t_tasks_sectors,
-				DMA_FROM_DEVICE, T_TASK(cmd)->t_mem_bidi_list);
+				DMA_FROM_DEVICE, T_TASK(cmd)->t_mem_bidi_list,
+				set_counts);
 			if (!(rc)) {
 				cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 				cmd->scsi_sense_reason =
 					TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 				return PYX_TRANSPORT_LU_COMM_FAILURE;
 			}
-			ti->ti_set_counts = 0;
+			set_counts = 0;
 		}
 		/*
 		 * Setup the tasks and memory from T_TASK(cmd)->t_mem_list
 		 * Note for BIDI transfers this will contain the WRITE payload
 		 */
-		task_cdbs = transport_generic_get_cdb_count(cmd, ti,
+		task_cdbs = transport_generic_get_cdb_count(cmd,
 				T_TASK(cmd)->t_task_lba,
 				T_TASK(cmd)->t_tasks_sectors,
-				cmd->data_direction, T_TASK(cmd)->t_mem_list);
+				cmd->data_direction, T_TASK(cmd)->t_mem_list,
+				set_counts);
 		if (!(task_cdbs)) {
 			cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 			cmd->scsi_sense_reason =
@@ -4893,16 +4871,9 @@ static int transport_new_cmd_obj(
 #endif
 	}
 
-	if (!post_execute) {
-		atomic_set(&T_TASK(cmd)->t_task_cdbs_left, task_cdbs);
-		atomic_set(&T_TASK(cmd)->t_task_cdbs_ex_left, task_cdbs);
-		atomic_set(&T_TASK(cmd)->t_task_cdbs_timeout_left, task_cdbs);
-	} else {
-		atomic_add(task_cdbs, &T_TASK(cmd)->t_task_cdbs_left);
-		atomic_add(task_cdbs, &T_TASK(cmd)->t_task_cdbs_ex_left);
-		atomic_add(task_cdbs, &T_TASK(cmd)->t_task_cdbs_timeout_left);
-	}
-
+	atomic_set(&T_TASK(cmd)->t_task_cdbs_left, task_cdbs);
+	atomic_set(&T_TASK(cmd)->t_task_cdbs_ex_left, task_cdbs);
+	atomic_set(&T_TASK(cmd)->t_task_cdbs_timeout_left, task_cdbs);
 	return 0;
 }
 
@@ -5479,11 +5450,11 @@ static int transport_do_se_mem_map(
 
 static u32 transport_generic_get_cdb_count(
 	struct se_cmd *cmd,
-	struct se_transform_info *ti,
-	unsigned long long starting_lba,
+	unsigned long long lba,
 	u32 sectors,
 	enum dma_data_direction data_direction,
-	struct list_head *mem_list)
+	struct list_head *mem_list,
+	int set_counts)
 {
 	unsigned char *cdb = NULL;
 	struct se_task *task;
@@ -5492,7 +5463,6 @@ static u32 transport_generic_get_cdb_cou
 	struct se_device *dev = SE_DEV(cmd);
 	int max_sectors_set = 0, ret;
 	u32 task_offset_in = 0, se_mem_cnt = 0, se_mem_bidi_cnt = 0, task_cdbs = 0;
-	unsigned long long lba;
 
 	if (!mem_list) {
 		printk(KERN_ERR "mem_list is NULL in transport_generic_get"
@@ -5514,25 +5484,13 @@ static u32 transport_generic_get_cdb_cou
 	    (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV))
 		se_mem_bidi = list_entry(T_TASK(cmd)->t_mem_bidi_list->next,
 					struct se_mem, se_list);
-	/*
-	 * Locate the start volume segment in which the received LBA will be
-	 * executed upon.
-	 */
-	ti->ti_lba = starting_lba;
-        ti->ti_obj_ptr = dev;
-	/*
-	 * Locate starting object from original starting_lba.
-	 */
-	lba = ti->ti_lba;
-	DEBUG_VOL("Starting Physical LBA(%llu)\n", lba);
 
 	while (sectors) {
-
 		DEBUG_VOL("ITT[0x%08x] LBA(%llu) SectorsLeft(%u) EOBJ(%llu)\n",
 			CMD_TFO(cmd)->get_task_tag(cmd), lba, sectors,
 			transport_dev_end_lba(dev));
 
-		task = transport_generic_get_task(ti, cmd, dev, data_direction);
+		task = transport_generic_get_task(cmd, data_direction);
 		if (!(task))
 			goto out;
 
@@ -5598,7 +5556,7 @@ static u32 transport_generic_get_cdb_cou
 			break;
 	}
 
-	if (ti->ti_set_counts) {
+	if (set_counts) {
 		atomic_inc(&T_TASK(cmd)->t_fe_count);
 		atomic_inc(&T_TASK(cmd)->t_se_count);
 	}
@@ -5613,16 +5571,14 @@ out:
 }
 
 static int
-transport_map_control_cmd_to_task(struct se_cmd *cmd,
-		struct se_transform_info *ti)
+transport_map_control_cmd_to_task(struct se_cmd *cmd)
 {
 	struct se_device *dev = SE_DEV(cmd);
 	unsigned char *cdb;
 	struct se_task *task;
 	int ret;
 
-	task = transport_generic_get_task(ti, cmd, ti->se_obj_ptr,
-				  cmd->data_direction);
+	task = transport_generic_get_task(cmd, cmd->data_direction);
 	if (!task)
 		return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
 
@@ -5673,18 +5629,15 @@ transport_map_control_cmd_to_task(struct
  *	 by transport_generic_cmd_sequencer() from the iSCSI Target RX process.
  *	 Any non zero return here is treated as an "out of resource' op here.
  */
+	/*
+	 * Generate struct se_task(s) and/or their payloads for this CDB.
+	 */
 static int transport_generic_new_cmd(struct se_cmd *cmd)
 {
 	struct se_portal_group *se_tpg;
-	struct se_transform_info ti;
 	struct se_task *task;
+	struct se_device *dev = SE_DEV(cmd);
 	int ret = 0;
-	/*
-	 * Generate struct se_task(s) and/or their payloads for this CDB.
-	 */
-	memset((void *)&ti, 0, sizeof(struct se_transform_info));
-	ti.ti_se_cmd = cmd;
-	ti.se_obj_ptr = SE_LUN(cmd)->lun_se_dev;
 
 	if (!(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)) {
 		/*
@@ -5704,7 +5657,7 @@ static int transport_generic_new_cmd(str
 		if (ret < 0)
 			return ret;
 
-		ret = transport_new_cmd_obj(cmd, &ti, 0);
+		ret = transport_new_cmd_obj(cmd);
 		if (ret < 0)
 			return ret;
 
@@ -5725,15 +5678,15 @@ static int transport_generic_new_cmd(str
 		list_for_each_entry(task, &T_TASK(cmd)->t_task_list, t_list) {
 			if (atomic_read(&task->task_sent))
 				continue;
-			if (!ti.se_obj_ptr->transport->map_task_SG)
+			if (!dev->transport->map_task_SG)
 				continue;
 
-			ret = ti.se_obj_ptr->transport->map_task_SG(task);
+			ret = dev->transport->map_task_SG(task);
 			if (ret < 0)
 				return ret;
 		}
 	} else {
-		ret = transport_map_control_cmd_to_task(cmd, &ti);
+		ret = transport_map_control_cmd_to_task(cmd);
 		if (ret < 0)
 			return ret;
 	}
Index: lio-core/drivers/target/lio-target/iscsi_target_core.h
===================================================================
--- lio-core.orig/drivers/target/lio-target/iscsi_target_core.h	2010-11-23 22:58:56.928252831 +0100
+++ lio-core/drivers/target/lio-target/iscsi_target_core.h	2010-11-23 22:59:01.677253459 +0100
@@ -281,7 +281,6 @@ do {							\
 
 struct iscsi_queue_req {
 	int			state;
-	void			*queue_se_obj_ptr;
 	struct se_obj_lun_type_s *queue_se_obj_api;
 	struct iscsi_cmd	*cmd;
 	struct list_head	qr_list;
Index: lio-core/include/target/target_core_base.h
===================================================================
--- lio-core.orig/include/target/target_core_base.h	2010-11-23 22:56:03.534253249 +0100
+++ lio-core/include/target/target_core_base.h	2010-11-23 23:04:51.742253320 +0100
@@ -486,16 +486,6 @@ struct se_task {
 #define TASK_CMD(task)	((struct se_cmd *)task->task_se_cmd)
 #define TASK_DEV(task)	((struct se_device *)task->se_dev)
 
-struct se_transform_info {
-	int		ti_set_counts;
-	u32		ti_data_length;
-	unsigned long long	ti_lba;
-	struct se_cmd *ti_se_cmd;
-	struct se_device *ti_dev;
-	struct se_device *se_obj_ptr;
-	struct se_device *ti_obj_ptr;
-} ____cacheline_aligned;
-
 struct se_cmd {
 	/* SAM response code being sent to initiator */
 	u8			scsi_status;

