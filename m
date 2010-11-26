From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/4] target: remove passthrough support
Date: Thu, 25 Nov 2010 23:14:32 -0800
Message-ID: <1290755672-19819-5-git-send-email-nab@linux-iscsi.org>
References: <1290755672-19819-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm13-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.48]:47653 "HELO
	nm13-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752852Ab0KZHPP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Nov 2010 02:15:15 -0500
In-Reply-To: <1290755672-19819-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Christoph Hellwig <hch@lst.de>

The SCF_CMD_PASSTHROUGH cmd passthrough support, which is a method
of building an se_cmd for submission to a TCM backend se_device w/o
an active fabric module se_port.  This logic was originally used
to obtain standard INQUIRY, EVPD 0x80/0x83 INQUIRY, and READ_CAPACITY
during the backend ->create_virtdevice() -> se_device creation
process.

This includes the removal of the main transport_allocate_passthrough()
setup and completion code, along with the removal of a handful of
special cases in the primary I/O setup and completion path, as well as
code in transport_cmd_check_stop(), transport_lun_remove_cmd(), and
transport_processing_shutdown().

Finally, this simplifys the cruft in transport_release_cmd_to_pool()
now that SCF_CMD_PASSTHROUGH is no more..

Lightly tested and working OK with TCM_Loop + xfs_repair on
.37-rc2 w/ TCM/IBLOCK LVM backend.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tmr.c       |    5 +-
 drivers/target/target_core_transport.c |  480 ++++----------------------------
 include/target/target_core_base.h      |   38 ++--
 include/target/target_core_transport.h |    4 -
 4 files changed, 77 insertions(+), 450 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 1226138..7a54af7 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -248,11 +248,10 @@ int core_tmr_lun_reset(
 		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
 		spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-		DEBUG_LR("LUN_RESET: %s cmd: %p se_fabric_cmd_ptr: %p task: %p"
+		DEBUG_LR("LUN_RESET: %s cmd: %p task: %p"
 			" ITT/CmdSN: 0x%08x/0x%08x, i_state: %d, t_state/"
 			"def_t_state: %d/%d cdb: 0x%02x\n",
-			(preempt_and_abort_list) ? "Preempt" : "", cmd,
-			cmd->se_fabric_cmd_ptr, task,
+			(preempt_and_abort_list) ? "Preempt" : "", cmd, task,
 			CMD_TFO(cmd)->get_task_tag(cmd), 0,
 			CMD_TFO(cmd)->get_cmd_state(cmd), cmd->t_state,
 			cmd->deferred_t_state, T_TASK(cmd)->t_task_cdb[0]);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9004ab6..dbe5dbf 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -203,7 +203,6 @@ typedef int (*map_func_t)(struct se_task *, u32);
 
 static int transport_generic_write_pending(struct se_cmd *);
 static int transport_processing_thread(void *);
-static int transport_new_cmd_obj(struct se_cmd *cmd);
 static int __transport_execute_tasks(struct se_device *dev);
 static void transport_complete_task_attr(struct se_cmd *cmd);
 static void transport_direct_request_timeout(struct se_cmd *cmd);
@@ -232,47 +231,6 @@ static void transport_stop_all_task_timers(struct se_cmd *cmd);
 
 int transport_emulate_control_cdb(struct se_task *task);
 
-static char *transport_passthrough_get_fabric_name(void)
-{
-	return "PT";
-}
-
-static u32 transport_passthrough_get_task_tag(struct se_cmd *cmd)
-{
-	return 0;
-}
-
-static int transport_passthrough_get_cmd_state(struct se_cmd *cmd)
-{
-	return 0;
-}
-
-static void transport_passthrough_release_cmd_direct(struct se_cmd *cmd)
-{
-	return;
-}
-
-static u16 transport_passthrough_set_fabric_sense_len(
-	struct se_cmd *cmd,
-	u32 sense_len)
-{
-	return 0;
-}
-
-static u16 transport_passthrough_get_fabric_sense_len(void)
-{
-	return 0;
-}
-
-static struct target_core_fabric_ops passthrough_fabric_ops = {
-	.release_cmd_direct	= transport_passthrough_release_cmd_direct,
-	.get_fabric_name	= transport_passthrough_get_fabric_name,
-	.get_task_tag		= transport_passthrough_get_task_tag,
-	.get_cmd_state		= transport_passthrough_get_cmd_state,
-	.set_fabric_sense_len	= transport_passthrough_set_fabric_sense_len,
-	.get_fabric_sense_len	= transport_passthrough_get_fabric_sense_len,
-};
-
 int init_se_global(void)
 {
 	struct se_global *global;
@@ -668,12 +626,6 @@ static void transport_all_task_dev_remove_state(struct se_cmd *cmd)
 	}
 }
 
-static void transport_passthrough_check_stop(struct se_cmd *cmd)
-{
-	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)
-		complete(&T_TASK(cmd)->t_transport_passthrough_comp);
-}
-
 /*	transport_cmd_check_stop():
  *
  *	'transport_off = 1' determines if t_transport_active should be cleared.
@@ -727,8 +679,7 @@ static int transport_cmd_check_stop(
 		 * Clear struct se_cmd->se_lun before the transport_off == 2 handoff
 		 * to FE.
 		 */
-		if ((transport_off == 2) && !(cmd->se_cmd_flags &
-						SCF_CMD_PASSTHROUGH))
+		if (transport_off == 2)
 			cmd->se_lun = NULL;
 		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 
@@ -743,8 +694,7 @@ static int transport_cmd_check_stop(
 			 * Clear struct se_cmd->se_lun before the transport_off == 2
 			 * handoff to fabric module.
 			 */
-			if (!(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH))
-				cmd->se_lun = NULL;
+			cmd->se_lun = NULL;
 			/*
 			 * Some fabric modules like tcm_loop can release
 			 * their internally allocated I/O refrence now and
@@ -780,11 +730,6 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 
 	if (!lun)
 		return;
-	/*
-	 * Do not track passthrough struct se_cmd for now..
-	 */
-	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)
-		return;
 
 	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
 	if (!(atomic_read(&T_TASK(cmd)->transport_dev_active))) {
@@ -1322,10 +1267,8 @@ static void transport_release_all_cmds(struct se_device *dev)
 		spin_unlock_irqrestore(&dev->dev_queue_obj->cmd_queue_lock,
 				flags);
 
-		printk(KERN_ERR "Releasing %s ITT: 0x%08x, i_state: %u,"
+		printk(KERN_ERR "Releasing ITT: 0x%08x, i_state: %u,"
 			" t_state: %u directly\n",
-			(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH) ?
-			"Passthrough" : "Normal",
 			CMD_TFO(cmd)->get_task_tag(cmd),
 			CMD_TFO(cmd)->get_cmd_state(cmd), t_state);
 
@@ -1860,41 +1803,6 @@ void transport_device_setup_cmd(struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(transport_device_setup_cmd);
 
-static struct se_cmd *
-transport_alloc_passthrough_cmd(u32 data_length, int data_direction)
-{
-	struct se_cmd *cmd;
-	unsigned char *sense_buffer;
-	int gfp_type = (in_interrupt()) ? GFP_ATOMIC : GFP_KERNEL;
-
-	cmd = kmem_cache_zalloc(se_cmd_cache, gfp_type);
-	if (!(cmd)) {
-		printk(KERN_ERR "kmem_cache_alloc() failed for se_cmd_cache\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	sense_buffer = kzalloc(TRANSPORT_SENSE_BUFFER +
-			passthrough_fabric_ops.get_fabric_sense_len(), gfp_type);
-	if (!sense_buffer) {
-		printk(KERN_ERR "Unable to allocate memory for"
-			" cmd->sense_buffer\n");
-		kmem_cache_free(se_cmd_cache, cmd);
-		return NULL;
-	}
-	/*
-	 * Initialize the new struct se_cmd descriptor
-	 */
-	transport_init_se_cmd(cmd, &passthrough_fabric_ops, NULL,
-			      data_length, data_direction,
-			      TASK_ATTR_SIMPLE, sense_buffer);
-	/*
-	 * Setup the se_fabric_cmd_ptr assignment which will signal
-	 * TCM allocation of struct se_cmd in the release and free codepaths
-	 */
-	cmd->se_fabric_cmd_ptr = (void *)1;
-	return cmd;
-}
-
 /*
  * Used by fabric modules containing a local struct se_cmd within their
  * fabric dependent per I/O descriptor.
@@ -1920,8 +1828,6 @@ void transport_init_se_cmd(
 	init_completion(&T_TASK(cmd)->transport_lun_fe_stop_comp);
 	init_completion(&T_TASK(cmd)->transport_lun_stop_comp);
 	init_completion(&T_TASK(cmd)->t_transport_stop_comp);
-	init_completion(&T_TASK(cmd)->t_transport_passthrough_comp);
-	init_completion(&T_TASK(cmd)->t_transport_passthrough_wcomp);
 	spin_lock_init(&T_TASK(cmd)->t_state_lock);
 	atomic_set(&T_TASK(cmd)->transport_dev_active, 1);
 
@@ -1970,14 +1876,6 @@ void transport_free_se_cmd(
 	 */
 	if (T_TASK(se_cmd)->t_task_cdb != T_TASK(se_cmd)->__t_task_cdb)
 		kfree(T_TASK(se_cmd)->t_task_cdb);
-	/*
-	 * Only release the sense_buffer, t_task, and remaining se_cmd memory
-	 * if this descriptor was allocated with transport_alloc_se_cmd()
-	 */
-	if (se_cmd->se_fabric_cmd_ptr) {
-		kfree(se_cmd->sense_buffer);
-		kmem_cache_free(se_cmd_cache, se_cmd);
-	}
 }
 EXPORT_SYMBOL(transport_free_se_cmd);
 
@@ -2356,23 +2254,17 @@ static void transport_generic_request_failure(
 		cmd->scsi_sense_reason = TCM_INVALID_PARAMETER_LIST;
 		break;
 	case PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES:
-		if (!(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)) {
-			if (!sc)
-				transport_new_cmd_failure(cmd);
-			/*
-			 * Currently for PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES,
-			 * we force this session to fall back to session
-			 * recovery.
-			 */
-			CMD_TFO(cmd)->fall_back_to_erl0(cmd->se_sess);
-			CMD_TFO(cmd)->stop_session(cmd->se_sess, 0, 0);
+		if (!sc)
+			transport_new_cmd_failure(cmd);
+		/*
+		 * Currently for PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES,
+		 * we force this session to fall back to session
+		 * recovery.
+		 */
+		CMD_TFO(cmd)->fall_back_to_erl0(cmd->se_sess);
+		CMD_TFO(cmd)->stop_session(cmd->se_sess, 0, 0);
 
-			goto check_stop;
-		} else {
-			cmd->scsi_sense_reason =
-				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-		}
-		break;
+		goto check_stop;
 	case PYX_TRANSPORT_LU_COMM_FAILURE:
 	case PYX_TRANSPORT_ILLEGAL_REQUEST:
 		cmd->scsi_sense_reason = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -2404,9 +2296,7 @@ static void transport_generic_request_failure(
 				cmd->orig_fe_lun, 0x2C,
 				ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS);
 
-		if (!(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH))
-			CMD_TFO(cmd)->queue_status(cmd);
-
+		CMD_TFO(cmd)->queue_status(cmd);
 		goto check_stop;
 	case PYX_TRANSPORT_USE_SENSE_REASON:
 		/*
@@ -2429,7 +2319,7 @@ static void transport_generic_request_failure(
 check_stop:
 	transport_lun_remove_cmd(cmd);
 	if (!(transport_cmd_check_stop_to_fabric(cmd)))
-		transport_passthrough_check_stop(cmd);
+		;
 }
 
 static void transport_direct_request_timeout(struct se_cmd *cmd)
@@ -3820,147 +3710,6 @@ static int transport_generic_cmd_sequencer(
 
 static inline void transport_release_tasks(struct se_cmd *);
 
-struct se_cmd *transport_allocate_passthrough(
-	unsigned char *cdb,
-	int data_direction,
-	u32 se_cmd_flags,
-	void *mem,
-	u32 se_mem_num,
-	u32 length,
-	void *type_ptr)
-{
-	struct se_cmd *cmd;
-
-	cmd = transport_alloc_passthrough_cmd(length, data_direction);
-	if (!(cmd))
-		return NULL;
-	/*
-	 * Simulate an SE LUN entry need for passing SCSI CDBs into
-	 * struct se_cmd.
-	 */
-	cmd->se_lun = kzalloc(sizeof(struct se_lun), GFP_KERNEL);
-	if (!(cmd->se_lun)) {
-		printk(KERN_ERR "Unable to allocate cmd->se_lun\n");
-		goto fail;
-	}
-
-	spin_lock_init(&cmd->se_lun->lun_sep_lock);
-	cmd->se_orig_obj_ptr = type_ptr;
-	cmd->se_cmd_flags = se_cmd_flags;
-	SE_LUN(cmd)->lun_se_dev = (struct se_device *) type_ptr;
-
-	/*
-	 * Double check that the passed object is currently accepting CDBs
-	 */
-	if (se_dev_check_online(type_ptr) != 0) {
-		DEBUG_SO("se_dev_check_online() failed!\n");
-		goto fail;
-	}
-
-	cmd->data_length = length;
-	cmd->data_direction = data_direction;
-	cmd->se_cmd_flags |= SCF_CMD_PASSTHROUGH;
-
-	if (transport_generic_allocate_tasks(cmd, cdb) < 0)
-		goto fail;
-
-	if (!mem) {
-		if (transport_allocate_resources(cmd) < 0)
-			goto fail;
-	} else {
-		/*
-		 * Passed *mem will contain a list_head containing preformatted
-		 * struct se_mem elements...
-		 */
-		T_TASK(cmd)->t_mem_list = (struct list_head *)mem;
-		T_TASK(cmd)->t_tasks_se_num = se_mem_num;
-		cmd->se_cmd_flags |= SCF_CMD_PASSTHROUGH_NOALLOC;
-
-#ifdef DEBUG_PASSTHROUGH
-		{
-		u32 total_se_length = 0;
-		struct se_mem *se_mem, *se_mem_tmp;
-
-		DEBUG_PT("Preallocated se_mem_list: %p se_mem_num: %d\n",
-				mem, se_mem_num);
-
-		list_for_each_entry_safe(se_mem, se_mem_tmp,
-				T_TASK(cmd)->t_mem_list, se_list) {
-			total_se_length += se_mem->se_len;
-			DEBUG_PT("se_mem: %p se_mem->se_page: %p %d:%d\n",
-				se_mem, se_mem->se_page, se_mem->se_len,
-				se_mem->se_off);
-		}
-		DEBUG_PT("Total calculated total_se_length: %u\n",
-				total_se_length);
-
-		if (total_se_length != length) {
-			printk(KERN_ERR "Passed length: %u does not equal"
-				" total_se_length: %u\n", length,
-					total_se_length);
-			BUG();
-		}
-		}
-#endif
-	}
-
-	if (transport_get_sectors(cmd) < 0)
-		goto fail;
-
-	if (transport_new_cmd_obj(cmd) < 0)
-		goto fail;
-
-	return cmd;
-
-fail:
-	if (T_TASK(cmd))
-		transport_release_tasks(cmd);
-	kfree(T_TASK(cmd));
-	kfree(cmd->se_lun);
-	transport_free_se_cmd(cmd);
-
-	return NULL;
-}
-EXPORT_SYMBOL(transport_allocate_passthrough);
-
-void transport_passthrough_release(
-	struct se_cmd *cmd)
-{
-	if (!cmd) {
-		printk(KERN_ERR "transport_passthrough_release passed"
-			" NULL struct se_cmd\n");
-		return;
-	}
-
-	if (cmd->transport_wait_for_tasks)
-		cmd->transport_wait_for_tasks(cmd, 0, 0);
-
-	transport_generic_remove(cmd, 0, 0);
-}
-EXPORT_SYMBOL(transport_passthrough_release);
-
-static int transport_passthrough_complete(
-	struct se_cmd *cmd)
-{
-	if (se_dev_check_shutdown(cmd->se_orig_obj_ptr) != 0)
-		return -2;
-
-	switch (cmd->scsi_status) {
-	case 0x00: /* GOOD */
-		DEBUG_PT("SCSI Status: GOOD\n");
-		return 0;
-	case 0x02: /* CHECK_CONDITION */
-		DEBUG_PT("SCSI Status: CHECK_CONDITION\n");
-/* #warning FIXME: Do some basic return values for Sense Data */
-		return -1;
-	default:
-		DEBUG_PT("SCSI Status: 0x%02x\n", cmd->scsi_status);
-		return -1;
-	}
-
-	return 0;
-}
-
 /*
  * This function will copy a contiguous *src buffer into a destination
  * struct scatterlist array.
@@ -4047,28 +3796,6 @@ static void transport_memcpy_se_mem_read_contig(
 	}
 }
 
-int transport_generic_passthrough(struct se_cmd *cmd)
-{
-	int write = (cmd->data_direction == DMA_TO_DEVICE);
-	int no_alloc = (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH_NOALLOC);
-
-	if (transport_generic_handle_cdb(cmd) < 0)
-		return -1;
-
-	if (write && !no_alloc) {
-		if (wait_for_completion_interruptible(
-			&T_TASK(cmd)->t_transport_passthrough_wcomp) != 0)
-			return -1;
-
-		transport_generic_process_write(cmd);
-	}
-
-	wait_for_completion(&T_TASK(cmd)->t_transport_passthrough_comp);
-
-	return transport_passthrough_complete(cmd);
-}
-EXPORT_SYMBOL(transport_generic_passthrough);
-
 /*
  * Called from transport_generic_complete_ok() and
  * transport_generic_request_failure() to determine which dormant/delayed
@@ -4153,12 +3880,7 @@ static void transport_generic_complete_ok(struct se_cmd *cmd)
 	 * Check if we need to retrieve a sense buffer from
 	 * the struct se_cmd in question.
 	 */
-	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH) {
-		transport_lun_remove_cmd(cmd);
-		if (!(transport_cmd_check_stop_to_fabric(cmd)))
-			transport_passthrough_check_stop(cmd);
-		return;
-	} else if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) {
+	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) {
 		if (transport_get_sense_data(cmd) < 0)
 			reason = TCM_NON_EXISTENT_LUN;
 
@@ -4350,22 +4072,6 @@ static inline int transport_dec_and_check(struct se_cmd *cmd)
 	return 0;
 }
 
-static inline void transport_release_se_cmd(struct se_cmd *cmd)
-{
-	/*
-	 * Determine if this struct se_cmd descriptor was allocated
-	 * with __transport_alloc_se_cmd(), or is a member of a
-	 * TCM fabric module dependent descriptor.
-	 */
-	if (cmd->se_fabric_cmd_ptr) {
-		CMD_TFO(cmd)->release_cmd_direct(cmd);
-		transport_free_se_cmd(cmd);
-	} else {
-		transport_free_se_cmd(cmd);
-		CMD_TFO(cmd)->release_cmd_direct(cmd);
-	}
-}
-
 static void transport_release_fe_cmd(struct se_cmd *cmd)
 {
 	unsigned long flags;
@@ -4385,11 +4091,8 @@ static void transport_release_fe_cmd(struct se_cmd *cmd)
 	transport_release_tasks(cmd);
 free_pages:
 	transport_free_pages(cmd);
-
-	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)
-		kfree(cmd->se_lun);
-
-	transport_release_se_cmd(cmd);
+	transport_free_se_cmd(cmd);
+	CMD_TFO(cmd)->release_cmd_direct(cmd);
 }
 
 static int transport_generic_remove(
@@ -4426,13 +4129,11 @@ free_pages:
 	transport_free_pages(cmd);
 
 release_cmd:
-	if (release_to_pool && !(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH))
+	if (release_to_pool) {
 		transport_release_cmd_to_pool(cmd);
-	else {
-		if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)
-			kfree(cmd->se_lun);
-
-		transport_release_se_cmd(cmd);
+	} else {
+		transport_free_se_cmd(cmd);
+		CMD_TFO(cmd)->release_cmd_direct(cmd);
 	}
 
 	return 0;
@@ -5400,39 +5101,36 @@ static int transport_generic_new_cmd(struct se_cmd *cmd)
 	struct se_device *dev = SE_DEV(cmd);
 	int ret = 0;
 
-	if (!(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)) {
-		/*
-		 * Determine is the TCM fabric module has already allocated
-		 * physical memory, and is directly calling
-		 * transport_generic_map_mem_to_cmd() to setup beforehand
-		 * the linked list of physical memory at
-		 * T_TASK(cmd)->t_mem_list of struct se_mem->se_page
-		 */
-		if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)) {
-			ret = transport_allocate_resources(cmd);
-			if (ret < 0)
-				return ret;
-		}
-
-		ret = transport_get_sectors(cmd);
+	/*
+	 * Determine is the TCM fabric module has already allocated physical
+	 * memory, and is directly calling transport_generic_map_mem_to_cmd()
+	 * to setup beforehand the linked list of physical memory at
+	 * T_TASK(cmd)->t_mem_list of struct se_mem->se_page
+	 */
+	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)) {
+		ret = transport_allocate_resources(cmd);
 		if (ret < 0)
 			return ret;
+	}
 
-		ret = transport_new_cmd_obj(cmd);
-		if (ret < 0)
-			return ret;
+	ret = transport_get_sectors(cmd);
+	if (ret < 0)
+		return ret;
 
-		/*
-		 * Determine if the calling TCM fabric module is talking to
-		 * Linux/NET via kernel sockets and needs to allocate a
-		 * struct iovec array to complete the struct se_cmd
-		 */
-		se_tpg = SE_LUN(cmd)->lun_sep->sep_tpg;
-		if (TPG_TFO(se_tpg)->alloc_cmd_iovecs != NULL) {
-			ret = TPG_TFO(se_tpg)->alloc_cmd_iovecs(cmd);
-			if (ret < 0)
-				return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
-		}
+	ret = transport_new_cmd_obj(cmd);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Determine if the calling TCM fabric module is talking to
+	 * Linux/NET via kernel sockets and needs to allocate a
+	 * struct iovec array to complete the struct se_cmd
+	 */
+	se_tpg = SE_LUN(cmd)->lun_sep->sep_tpg;
+	if (TPG_TFO(se_tpg)->alloc_cmd_iovecs != NULL) {
+		ret = TPG_TFO(se_tpg)->alloc_cmd_iovecs(cmd);
+		if (ret < 0)
+			return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
 	}
 
 	if (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) {
@@ -5548,18 +5246,6 @@ static int transport_generic_write_pending(struct se_cmd *cmd)
 	unsigned long flags;
 	int ret;
 
-	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH) {
-		if (!(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH_NOALLOC)) {
-			complete(&T_TASK(cmd)->t_transport_passthrough_wcomp);
-			transport_cmd_check_stop(cmd, 1, 0);
-			return PYX_TRANSPORT_WRITE_PENDING;
-		}
-
-		transport_generic_process_write(cmd);
-		transport_cmd_check_stop(cmd, 1, 0);
-		return PYX_TRANSPORT_WRITE_PENDING;
-	}
-
 	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
 	cmd->t_state = TRANSPORT_WRITE_PENDING;
 	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
@@ -5593,44 +5279,11 @@ static int transport_generic_write_pending(struct se_cmd *cmd)
  */
 void transport_release_cmd_to_pool(struct se_cmd *cmd)
 {
-	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)
-		kfree(cmd->se_lun);
-	/*
-	 * A NULL cmd->se_fabric_cmd_ptr signals that the TCM fabric module
-	 * is using struct se_cmd as part of it's internal fabric per I/O
-	 * descriptor
-	 */
-	if (!(cmd->se_fabric_cmd_ptr)) {
-		transport_free_se_cmd(cmd);
-		/*
-		 * Make sure that this is only called for struct se_cmd
-		 * descriptors containing valid T_TASK(cmd) and CMD_TFO(cmd)
-		 * pointers
-		 */	
-		if ((T_TASK(cmd) && (CMD_TFO(cmd))))
-			CMD_TFO(cmd)->release_cmd_to_pool(cmd);
-		else {
-			printk(KERN_ERR "T_TASK(cmd) && (CMD_TFO(cmd) NULL for"
-				" se_fabric_cmd_ptr=NULL inside of"
-				" transport_release_cmd_to_pool()\n");
-			dump_stack();
-		}
-
-		return;
-	}
-	/*
-	 * Release explict allocated struct se_cmd->se_fabric_cmd_ptr in fabric
-	 */
-	if ((T_TASK(cmd) && (CMD_TFO(cmd))))
-		CMD_TFO(cmd)->release_cmd_to_pool(cmd);
-	else {
-		dump_stack();
-		printk(KERN_ERR "NULL T_TASK(cmd) && (CMD_TFO(cmd) for"
-			" se_fabric_cmd_ptr=1 inside of"
-			" transport_release_cmd_to_pool()\n");
-	}
+	BUG_ON(!T_TASK(cmd));
+	BUG_ON(!CMD_TFO(cmd));
 
 	transport_free_se_cmd(cmd);
+	CMD_TFO(cmd)->release_cmd_to_pool(cmd);
 }
 EXPORT_SYMBOL(transport_release_cmd_to_pool);
 
@@ -6132,9 +5785,7 @@ int transport_send_check_condition_and_sense(
 	cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER + offset;
 
 after_reason:
-	if (!(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH))
-		CMD_TFO(cmd)->queue_status(cmd);
-
+	CMD_TFO(cmd)->queue_status(cmd);
 	return 0;
 }
 EXPORT_SYMBOL(transport_send_check_condition_and_sense);
@@ -6143,9 +5794,6 @@ int transport_check_aborted_status(struct se_cmd *cmd, int send_status)
 {
 	int ret = 0;
 
-	if (!(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH))
-		return 0;
-
 	if (atomic_read(&T_TASK(cmd)->t_transport_aborted) != 0) {
 		if (!(send_status) ||
 		     (cmd->se_cmd_flags & SCF_SENT_DELAYED_TAS))
@@ -6166,8 +5814,6 @@ EXPORT_SYMBOL(transport_check_aborted_status);
 
 void transport_send_task_abort(struct se_cmd *cmd)
 {
-	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)
-		return;
 	/*
 	 * If there are still expected incoming fabric WRITEs, we wait
 	 * until until they have completed before sending a TASK_ABORTED
@@ -6355,8 +6001,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 					SE_DEV(cmd)->dev_queue_obj);
 
 				transport_lun_remove_cmd(cmd);
-				if (!(transport_cmd_check_stop(cmd, 1, 0)))
-					transport_passthrough_check_stop(cmd);
+				transport_cmd_check_stop(cmd, 1, 0);
 			} else {
 				spin_unlock_irqrestore(
 					&T_TASK(cmd)->t_state_lock, flags);
@@ -6366,9 +6011,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 
 				transport_lun_remove_cmd(cmd);
 
-				if (!(transport_cmd_check_stop(cmd, 1, 0)))
-					transport_passthrough_check_stop(cmd);
-				else
+				if (transport_cmd_check_stop(cmd, 1, 0))
 					transport_generic_remove(cmd, 0, 0);
 			}
 
@@ -6387,8 +6030,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 				SE_DEV(cmd)->dev_queue_obj);
 
 			transport_lun_remove_cmd(cmd);
-			if (!(transport_cmd_check_stop(cmd, 1, 0)))
-				transport_passthrough_check_stop(cmd);
+			transport_cmd_check_stop(cmd, 1, 0);
 		} else {
 			spin_unlock_irqrestore(
 				&T_TASK(cmd)->t_state_lock, flags);
@@ -6397,9 +6039,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 				SE_DEV(cmd)->dev_queue_obj);
 			transport_lun_remove_cmd(cmd);
 
-			if (!(transport_cmd_check_stop(cmd, 1, 0)))
-				transport_passthrough_check_stop(cmd);
-			else
+			if (transport_cmd_check_stop(cmd, 1, 0))
 				transport_generic_remove(cmd, 0, 0);
 		}
 
@@ -6425,14 +6065,10 @@ static void transport_processing_shutdown(struct se_device *dev)
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
 
 			transport_lun_remove_cmd(cmd);
-			if (!(transport_cmd_check_stop(cmd, 1, 0)))
-				transport_passthrough_check_stop(cmd);
+			transport_cmd_check_stop(cmd, 1, 0);
 		} else {
 			transport_lun_remove_cmd(cmd);
-
-			if (!(transport_cmd_check_stop(cmd, 1, 0)))
-				transport_passthrough_check_stop(cmd);
-			else
+			if (transport_cmd_check_stop(cmd, 1, 0))
 				transport_generic_remove(cmd, 0, 0);
 		}
 		spin_lock_irqsave(&dev->dev_queue_obj->cmd_queue_lock, flags);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index cd7d29d..7ccde37 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -111,24 +111,23 @@ enum se_cmd_flags_table {
 	SCF_SCSI_NON_DATA_CDB		= 0x00000040,
 	SCF_SCSI_CDB_EXCEPTION		= 0x00000080,
 	SCF_SCSI_RESERVATION_CONFLICT	= 0x00000100,
-	SCF_CMD_PASSTHROUGH		= 0x00000200,
-	SCF_CMD_PASSTHROUGH_NOALLOC	= 0x00000400,
-	SCF_SE_CMD_FAILED		= 0x00000800,
-	SCF_SE_LUN_CMD			= 0x00001000,
-	SCF_SE_ALLOW_EOO		= 0x00002000,
-	SCF_SE_DISABLE_ONLINE_CHECK	= 0x00004000,
-	SCF_SENT_CHECK_CONDITION	= 0x00008000,
-	SCF_OVERFLOW_BIT		= 0x00010000,
-	SCF_UNDERFLOW_BIT		= 0x00020000,
-	SCF_SENT_DELAYED_TAS		= 0x00040000,
-	SCF_ALUA_NON_OPTIMIZED		= 0x00080000,
-	SCF_DELAYED_CMD_FROM_SAM_ATTR	= 0x00100000,
-	SCF_PASSTHROUGH_SG_TO_MEM	= 0x00200000,
-	SCF_PASSTHROUGH_CONTIG_TO_SG	= 0x00400000,
-	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00800000,
-	SCF_EMULATE_SYNC_CACHE		= 0x01000000,
-	SCF_EMULATE_CDB_ASYNC		= 0x02000000,
-	SCF_EMULATE_SYNC_UNMAP		= 0x04000000
+	SCF_CMD_PASSTHROUGH_NOALLOC	= 0x00000200,
+	SCF_SE_CMD_FAILED		= 0x00000400,
+	SCF_SE_LUN_CMD			= 0x00000800,
+	SCF_SE_ALLOW_EOO		= 0x00001000,
+	SCF_SE_DISABLE_ONLINE_CHECK	= 0x00002000,
+	SCF_SENT_CHECK_CONDITION	= 0x00004000,
+	SCF_OVERFLOW_BIT		= 0x00008000,
+	SCF_UNDERFLOW_BIT		= 0x00010000,
+	SCF_SENT_DELAYED_TAS		= 0x00020000,
+	SCF_ALUA_NON_OPTIMIZED		= 0x00040000,
+	SCF_DELAYED_CMD_FROM_SAM_ATTR	= 0x00080000,
+	SCF_PASSTHROUGH_SG_TO_MEM	= 0x00100000,
+	SCF_PASSTHROUGH_CONTIG_TO_SG	= 0x00200000,
+	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00400000,
+	SCF_EMULATE_SYNC_CACHE		= 0x00800000,
+	SCF_EMULATE_CDB_ASYNC		= 0x01000000,
+	SCF_EMULATE_SYNC_UNMAP		= 0x02000000
 };
 	
 /* struct se_dev_entry->lun_flags and struct se_lun->lun_access */
@@ -431,8 +430,6 @@ struct se_transport_task {
 	atomic_t		transport_lun_stop;
 	spinlock_t		t_state_lock;
 	struct completion	t_transport_stop_comp;
-	struct completion	t_transport_passthrough_comp;
-	struct completion	t_transport_passthrough_wcomp;
 	struct completion	transport_lun_fe_stop_comp;
 	struct completion	transport_lun_stop_comp;
 	struct scatterlist	*t_tasks_sg_chained;
@@ -527,7 +524,6 @@ struct se_cmd {
 	struct se_device	*se_orig_obj_ptr;
 	struct se_lun		*se_lun;
 	/* Only used for internal passthrough and legacy TCM fabric modules */
-	void			*se_fabric_cmd_ptr;
 	struct se_session	*se_sess;
 	struct se_tmr_req	*se_tmr_req;
 	/* t_task is setup to t_task_backstore in transport_init_se_cmd() */
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 7b7df8f..20a701f 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -181,10 +181,6 @@ extern int transport_generic_handle_data(struct se_cmd *);
 extern int transport_generic_handle_tmr(struct se_cmd *);
 extern void __transport_stop_task_timer(struct se_task *, unsigned long *);
 extern unsigned char transport_asciihex_to_binaryhex(unsigned char val[2]);
-extern struct se_cmd *transport_allocate_passthrough(unsigned char *, int, u32,
-						void *, u32, u32, void *);
-extern void transport_passthrough_release(struct se_cmd *);
-extern int transport_generic_passthrough(struct se_cmd *);
 extern int transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *, u32,
 				struct scatterlist *, u32);
 extern int transport_clear_lun_from_sessions(struct se_lun *);
-- 
1.5.6.5

