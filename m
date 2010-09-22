From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] tcm: Add support for BIDI-COMMAND passthrough
Date: Tue, 21 Sep 2010 23:08:44 -0700
Message-ID: <1285135724-8329-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for BIDI-COMMAND passthrough into TCM Core by adding
new struct se_task->task_sg_bidi[] for the TCM/pSCSI backstore case to setup the
extra mapping for the SCSI READ payload from T_TASK(cmd)->t_mem_bidi_list.

This patch updates transport_generic_cmd_sequencer() to check for this case
with TCM/pSCSI plugin backstores and does the exntra task->task_sg_bidi[] allocation
in transport_calc_sg_num().  It also updates transport_generic_get_cdb_count()
and transport_do_se_mem_map() to handle the extra task->task_sg_bidi mapping
with a second call to transport_map_mem_to_sg().

This nice thing about this patch is that it allows TCM Core to still handle the
recieved XDWRITEREAD_* transfer length > backstore max_sectors case transparently.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |  105 +++++++++++++++++++++++++++----
 include/target/target_core_base.h      |    1 +
 2 files changed, 92 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a20a4a9..e514ffc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5399,7 +5399,7 @@ static int transport_generic_cmd_sequencer(
 {
 	struct se_device *dev = SE_DEV(cmd);
 	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
-	int ret, sector_ret = 0;
+	int ret, sector_ret = 0, passthrough;
 	u32 sectors = 0, size = 0, pr_reg_type = 0;
 	u16 service_action;
 	u8 alua_ascq = 0;
@@ -5587,8 +5587,15 @@ static int transport_generic_cmd_sequencer(
 				TCM_MAX_COMMAND_SIZE, cdb[7], service_action);
 			return TGCS_INVALID_CDB_FIELD;
 		}
+		/*
+		 * Determine if this is TCM/PSCSI device and we should disable
+		 * internal emulation for this CDB.
+		 */
+		passthrough = (TRANSPORT(dev)->transport_type ==
+					TRANSPORT_PLUGIN_PHBA_PDEV);
+
 		switch (service_action) {
-		case 0x0007: /* XDWRITE_READ_32 */
+		case XDWRITEREAD_32:
 			sectors = transport_get_sectors_32(cdb, cmd, &sector_ret);
 			if (sector_ret)
 				return TGCS_UNSUPPORTED_CDB;
@@ -5602,6 +5609,11 @@ static int transport_generic_cmd_sequencer(
 			cmd->transport_split_cdb = &split_cdb_XX_32;
 			cmd->transport_get_long_lba = &transport_lba_64_ext;
 			/*
+			 * Skip the remaining assignments for TCM/PSCSI passthrough
+			 */
+			if (passthrough)
+				break;
+			/*
 			 * Setup BIDI XOR callback to be run during
 			 * transport_generic_complete_ok()
 			 */
@@ -6475,6 +6487,7 @@ void transport_free_dev_tasks(struct se_cmd *cmd)
 		if (!task->transport_req)
 			continue;
 
+		kfree(task->task_sg_bidi);
 		kfree(task->task_sg);
 
 		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
@@ -7056,6 +7069,7 @@ extern u32 transport_calc_sg_num(
 	u32 task_offset)
 {
 	struct se_cmd *se_cmd = task->task_se_cmd;
+	struct se_device *se_dev = SE_DEV(se_cmd);
 	struct se_mem *se_mem = in_se_mem;
 	struct target_core_fabric_ops *tfo = CMD_TFO(se_cmd);
 	u32 sg_length, task_size = task->task_size, task_sg_num_padded;
@@ -7127,15 +7141,31 @@ next:
 				" task->task_sg\n");
 		return 0;
 	}
-
 	sg_init_table(&task->task_sg[0], task_sg_num_padded);
 	/*
+	 * Setup task->task_sg_bidi for SCSI READ payload for
+	 * TCM/pSCSI passthrough if present for BIDI-COMMAND
+	 */
+	if ((T_TASK(se_cmd)->t_mem_bidi_list != NULL) &&
+	    (TRANSPORT(se_dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)) {
+		task->task_sg_bidi = kzalloc(task_sg_num_padded *
+				sizeof(struct scatterlist), GFP_KERNEL);
+		if (!(task->task_sg_bidi)) {
+			printk(KERN_ERR "Unable to allocate memory for"
+				" task->task_sg_bidi\n");
+			return 0;
+		}
+		sg_init_table(&task->task_sg_bidi[0], task_sg_num_padded);
+	}
+	/*
 	 * For the chaining case, setup the proper end of SGL for the
 	 * initial submission struct task into struct se_subsystem_api.
 	 * This will be cleared later by transport_do_task_sg_chain()
 	 */
-	if (task->task_padded_sg)
+	if (task->task_padded_sg) {
 		sg_mark_end(&task->task_sg[task->task_sg_num - 1]);
+		sg_mark_end(&task->task_sg_bidi[task->task_sg_num - 1]);
+	}
 
 	DEBUG_SC("Successfully allocated task->task_sg_num(%u),"
 		" task_sg_num_padded(%u)\n", task->task_sg_num,
@@ -7485,17 +7515,34 @@ static int transport_do_se_mem_map(
 		return ret;
 	}
 	/*
-	 * Assume default that transport plugin speaks preallocated
-	 * scatterlists.
+	 * This is the normal path for all normal non BIDI and BIDI-COMMAND
+	 * WRITE payloads..  If we need to do BIDI READ passthrough for
+	 * TCM/pSCSI the first call to transport_do_se_mem_map ->
+	 * transport_calc_sg_num() -> transport_map_mem_to_sg() will do the
+	 * allocation for task->task_sg_bidi, and the subsequent call to
+	 * transport_do_se_mem_map() from transport_generic_get_cdb_count()
 	 */
-	if (!(transport_calc_sg_num(task, in_se_mem, task_offset)))
-		return -1;
-	/*
-	 * struct se_task->task_sg now contains the struct scatterlist array.
-	 */
-	return transport_map_mem_to_sg(task, se_mem_list, task->task_sg,
+	if (!(task->task_sg_bidi)) {
+		/*
+		 * Assume default that transport plugin speaks preallocated
+		 * scatterlists.
+		 */
+		if (!(transport_calc_sg_num(task, in_se_mem, task_offset)))
+			return -1;
+		/*
+		 * struct se_task->task_sg now contains the struct scatterlist array.
+		 */
+		return transport_map_mem_to_sg(task, se_mem_list, task->task_sg,
 					in_se_mem, out_se_mem, se_mem_cnt,
 					task_offset_in);
+	}
+	/*
+	 * Handle the se_mem_list -> struct task->task_sg_bidi
+	 * memory map for the extra BIDI READ payload
+	 */
+	return transport_map_mem_to_sg(task, se_mem_list, task->task_sg_bidi,
+				in_se_mem, out_se_mem, se_mem_cnt,
+				task_offset_in);
 }
 
 u32 transport_generic_get_cdb_count(
@@ -7509,9 +7556,10 @@ u32 transport_generic_get_cdb_count(
 	unsigned char *cdb = NULL;
 	struct se_task *task;
 	struct se_mem *se_mem = NULL, *se_mem_lout = NULL;
+	struct se_mem *se_mem_bidi = NULL, *se_mem_bidi_lout = NULL;
 	struct se_device *dev = SE_DEV(cmd);
 	int max_sectors_set = 0, ret;
-	u32 task_offset_in = 0, se_mem_cnt = 0, task_cdbs = 0;
+	u32 task_offset_in = 0, se_mem_cnt = 0, se_mem_bidi_cnt = 0, task_cdbs = 0;
 	unsigned long long lba;
 
 	if (!mem_list) {
@@ -7526,6 +7574,15 @@ u32 transport_generic_get_cdb_count(
 	if (!(list_empty(mem_list)))
 		se_mem = list_entry(mem_list->next, struct se_mem, se_list);
 	/*
+	 * Check for extra se_mem_bidi mapping for BIDI-COMMANDs to
+	 * struct se_task->task_sg_bidi for TCM/pSCSI passthrough operation
+	 */
+	if ((T_TASK(cmd)->t_mem_bidi_list != NULL) &&
+	    !(list_empty(T_TASK(cmd)->t_mem_bidi_list)) &&
+	    (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV))
+		se_mem_bidi = list_entry(T_TASK(cmd)->t_mem_bidi_list->next,
+					struct se_mem, se_list);
+	/*
 	 * Locate the start volume segment in which the received LBA will be
 	 * executed upon.
 	 */
@@ -7573,7 +7630,8 @@ u32 transport_generic_get_cdb_count(
 
 		/*
 		 * Perform the SE OBJ plugin and/or Transport plugin specific
-		 * mapping for T_TASK(cmd)->t_mem_list.
+		 * mapping for T_TASK(cmd)->t_mem_list. And setup the
+		 * task->task_sg and if necessary task->task_sg_bidi
 		 */
 		ret = transport_do_se_mem_map(dev, task, mem_list,
 				NULL, se_mem, &se_mem_lout, &se_mem_cnt,
@@ -7582,6 +7640,25 @@ u32 transport_generic_get_cdb_count(
 			goto out;
 
 		se_mem = se_mem_lout;
+		/*
+		 * Setup the T_TASK(cmd)->t_mem_bidi_list -> task->task_sg_bidi 
+		 * mapping for SCSI READ for BIDI-COMMAND passthrough with TCM/pSCSI
+		 *
+		 * Note that the first call to transport_do_se_mem_map() above will
+		 * allocate struct se_task->task_sg_bidi in transport_do_se_mem_map()
+		 * -> transport_calc_sg_num(), and the second here will do the
+		 * mapping for SCSI READ for BIDI-COMMAND passthrough with TCM/pSCSI.
+		 */
+		if (task->task_sg_bidi != NULL) {
+			ret = transport_do_se_mem_map(dev, task,
+				T_TASK(cmd)->t_mem_bidi_list, NULL,
+				se_mem_bidi, &se_mem_bidi_lout, &se_mem_bidi_cnt,
+				&task_offset_in);
+			if (ret < 0)
+				goto out;
+
+			se_mem_bidi = se_mem_bidi_lout;
+		}
 		task_cdbs++;
 
 		DEBUG_VOL("Incremented task_cdbs(%u) task->task_sg_num(%u)\n",
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b68dea1..b6f3b75 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -471,6 +471,7 @@ struct se_transport_task {
 struct se_task {
 	unsigned char	task_sense;
 	struct scatterlist *task_sg;
+	struct scatterlist *task_sg_bidi;
 	void		*transport_req;
 	u8		task_scsi_status;
 	u8		task_flags;
-- 
1.5.6.5
