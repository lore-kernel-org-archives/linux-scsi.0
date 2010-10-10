From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/4] tcm: Move SYNCHRONIZE_CACHE_* emulation into transport_emulate_control_cdb()
Date: Sat,  9 Oct 2010 20:48:56 -0700
Message-ID: <1286682536-4905-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates TCM Core to perform SYNCHRONIZE_CACHE and SYNCHRONIZE_CACHE_16
emulation using the unified control CDB infrastructure.  This includes adding a
new struct se_subsystem_api_cdb->emulate_sync_cache() caller used in
transport_emulate_control_cdb(), and removing the original struct se_subsystem_api
->do_sync_cache_range() and transport_generic_synchronize_cache() code.

This patch also updates IBLOCK and FILEIO to set ->emulate_sync_cache() and
hooks up the existing SYNCHRONIZE_CACHE_* logic to the new caller.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c      |   15 ++++++----
 drivers/target/target_core_iblock.c    |   12 +++++---
 drivers/target/target_core_transport.c |   45 ++++++++-----------------------
 include/target/target_core_transport.h |    8 +-----
 4 files changed, 29 insertions(+), 51 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 55e9ad5..62b4b4e 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -724,12 +724,15 @@ int __fd_do_sync_cache_range(
 	return 0;
 }
 
-void fd_do_sync_cache_range(
-	struct se_cmd *cmd,
-	unsigned long long lba,
-	u32 size_in_bytes)
+/*
+ * Called by target_core_transport():transport_emulate_control_cdb()
+ * to emulate SYCHRONIZE_CACHE_*
+ */
+void fd_emulate_sync_cache(struct se_task *task)
 {
-	__fd_do_sync_cache_range(cmd, lba, size_in_bytes);	
+	struct se_cmd *cmd = TASK_CMD(task);
+
+	__fd_do_sync_cache_range(cmd, T_TASK(cmd)->t_task_lba, cmd->data_length);
 }
 
 /*
@@ -1182,7 +1185,6 @@ static struct se_subsystem_api fileio_template = {
 	.activate_device	= fd_activate_device,
 	.deactivate_device	= fd_deactivate_device,
 	.free_device		= fd_free_device,
-	.do_sync_cache_range	= fd_do_sync_cache_range,
 	.dpo_emulated		= fd_emulated_dpo,
 	.fua_write_emulated	= fd_emulated_fua_write,
 	.fua_read_emulated	= fd_emulated_fua_read,
@@ -1217,6 +1219,7 @@ static struct se_subsystem_api_cdb fileio_cdb_template = {
 	.emulate_read_cap16	= fd_emulate_read_cap16,
 	.emulate_unmap		= fd_emulate_unmap,
 	.emulate_write_same	= fd_emulate_write_same_unmap,
+	.emulate_sync_cache	= fd_emulate_sync_cache,
 };
 
 int __init fileio_module_init(void)
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index a0a9ea3..061c513 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -508,11 +508,13 @@ static int __iblock_do_sync_cache(struct se_device *dev)
 	return 0;
 }
 
-void iblock_do_sync_cache_range(
-	struct se_cmd *cmd,
-	unsigned long long lba,
-	u32 size_in_bytes)
+/*
+ * Called by target_core_transport():transport_emulate_control_cdb()
+ * to emulate SYCHRONIZE_CACHE_*
+ */
+void iblock_emulate_sync_cache(struct se_task *task)
 {
+	struct se_cmd *cmd = TASK_CMD(task);
 	int ret, immed = (T_TASK(cmd)->t_task_cdb[1] & 0x2);
 	/*
 	 * If the Immediate bit is set, queue up the GOOD response
@@ -1102,7 +1104,6 @@ static struct se_subsystem_api iblock_template = {
 	.activate_device	= iblock_activate_device,
 	.deactivate_device	= iblock_deactivate_device,
 	.free_device		= iblock_free_device,
-	.do_sync_cache_range	= iblock_do_sync_cache_range,
 	.dpo_emulated		= iblock_emulated_dpo,
 	.fua_write_emulated	= iblock_emulated_fua_write,
 	.fua_read_emulated	= iblock_emulated_fua_read,
@@ -1138,6 +1139,7 @@ static struct se_subsystem_api_cdb iblock_cdb_template = {
 	.emulate_read_cap16	= iblock_emulate_read_cap16,
 	.emulate_unmap		= iblock_emulate_unmap,
 	.emulate_write_same	= iblock_emulate_write_same_unmap,
+	.emulate_sync_cache	= iblock_emulate_sync_cache,
 };
 
 int __init iblock_module_init(void)
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ae3ce18..bd48b6e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1178,10 +1178,7 @@ void transport_complete_cmd(struct se_cmd *cmd, int success)
 
 /*
  * Completion function used by TCM subsystem plugins (such as FILEIO)
- * for queueing up response from a struct se_subsystem_api
- * ->do_sync_cache() and ->do_sync_cache_range().  This completion is
- * enabled by setting 'struct se_cmd->se_cmd_flags |= SCF_EMULATE_SYNC_CACHE |
- * SCF_EMULATE_CDB_ASYNC
+ * for queueing up response from struct se_subsystem_api->do_task()
  */
 void transport_complete_sync_cache(struct se_cmd *cmd, int good)
 {
@@ -5480,27 +5477,6 @@ int transport_get_sense_data(struct se_cmd *cmd)
 	return -1;
 }
 
-static int transport_generic_synchronize_cache(struct se_cmd *cmd)
-{
-	struct se_device *dev = cmd->se_dev;
-	/*
-	 * We may be flushing the entire cache or only a specific
-	 * range of LBAs.  The ->do_sync_cache_range() caller is expected
-	 * to handle any LBA -> offset conversion.
-	 */
-	if (TRANSPORT(dev)->do_sync_cache_range == NULL) {
-		printk(KERN_ERR "TRANSPORT(dev)->do_sync_cache_range is NULL\n");
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-	}
-	/*
-	 * The TCM subsystem plugin is expected to handle the
-	 * completion of the SYNCHRONIZE_CACHE op emulation
-	 */
-	TRANSPORT(dev)->do_sync_cache_range(cmd, T_TASK(cmd)->t_task_lba,
-					cmd->data_length);
-	return 0;
-}
-
 /*
  * Used for TCM/IBLOCK and TCM/FILEIO for block/blk-lib.c level discard support.
  * Note this is not used for TCM/pSCSI passthrough
@@ -5662,6 +5638,15 @@ int transport_emulate_control_cdb(struct se_task *task)
 			break;
 		}
 		break;
+	case SYNCHRONIZE_CACHE:
+	case 0x91: /* SYNCHRONIZE_CACHE_16: */
+		if (!(api_cdb->emulate_sync_cache)) {
+			printk(KERN_ERR "SYNCHRONIZE_CACHE emulation not supported"
+					" for: %s\n", TRANSPORT(dev)->name);
+			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
+		}
+		api_cdb->emulate_sync_cache(task);
+		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case ERASE:
 	case REZERO_UNIT:
@@ -6303,12 +6288,10 @@ static int transport_generic_cmd_sequencer(
 		if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)
 			break;
 		/*
-		 * Setup the transport_generic_synchronize_cache() callback
-		 * Also set SCF_EMULATE_CDB_ASYNC to ensure asynchronous operation
+		 * Set SCF_EMULATE_CDB_ASYNC to ensure asynchronous operation
 		 * for SYNCHRONIZE_CACHE* Immed=1 case in __transport_execute_tasks()
 		 */
-		cmd->transport_emulate_cdb = &transport_generic_synchronize_cache;
-		cmd->se_cmd_flags |= (SCF_EMULATE_SYNC_CACHE | SCF_EMULATE_CDB_ASYNC);
+		cmd->se_cmd_flags |= SCF_EMULATE_CDB_ASYNC;
 		/*
 		 * Check to ensure that LBA + Range does not exceed past end of
 		 * device.
@@ -7309,10 +7292,6 @@ int transport_get_sectors(struct se_cmd *cmd)
 {
 	struct se_device *dev = SE_DEV(cmd);
 
-	if (!(cmd->se_cmd_flags & SCF_EMULATE_SYNC_CACHE) &&
-	    !(cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
-		return 0;
-
 	T_TASK(cmd)->t_tasks_sectors =
 		(cmd->data_length / DEV_ATTRIB(dev)->block_size);
 	if (!(T_TASK(cmd)->t_tasks_sectors))
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 31e726f..8e59144 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -324,6 +324,7 @@ struct se_subsystem_api_cdb {
 	int (*emulate_read_cap16)(struct se_task *);
 	int (*emulate_unmap)(struct se_task *);
 	int (*emulate_write_same)(struct se_task *);
+	void (*emulate_sync_cache)(struct se_task *);
 };
 
 /*
@@ -434,13 +435,6 @@ struct se_subsystem_api {
 	 */
 	int (*do_tmr)(struct se_cmd *cmd);
 	/*
-	 * do_sync_cache_range():
-	 *
-	 * Notify subsystem backstore when a SYNCHRONIZE_CACHE w/ explict
-	 * LBA + Range has been received with WriteCache=1
-	 */
-	void (*do_sync_cache_range)(struct se_cmd *, unsigned long long, u32);
-	/*
 	 * dpo_emulated():
 	 */
 	int (*dpo_emulated)(struct se_device *);
-- 
1.5.6.5
