From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/4] tcm: Add SYNCHRONIZE_CACHE* CDB infrastructure and emulation
Date: Thu, 26 Aug 2010 21:33:03 -0700
Message-ID: <1282883583-10851-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:44811 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753037Ab0H0EdH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2010 00:33:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <teheo@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for SYNCHRONIZE_CACHE and SYNCHRONIZE_CACHE_16
CDB emulation using a 32-bit and 64-bit Logical Block Address (LBA) and
Number of Blocks Range (converted to bytes by TCM) on a per struct se_cmd +
single struct se_task context basis into struct se_subsystem_api backstores
based on the received LBA + Range using ->do_sync_cache() and
->do_sync_cache_range() API callers.

It adds the the new transport_generic_synchronize_cache(), which is assigned
to struct se_cmd->transport_emulate_cdb() when TCM is handling WriteCache
emulation.  This patch also sets T_TASK(cmd)->t_task_fua for WRITE_10,
WRITE_12, and WRITE_16 in transport_generic_cmd_sequencer(), which are
used for Forced Unit Access WRITE emulation in TCM/FILEIO.

It also adds a new callback mechinisim for SYNCHRONIZE_CACHE* and is
used by TCM/FILEIO (and other TCM subsystem plugins).  This patch adds a
common completion caller in transport_complete_sync_cache(), and adds the
SCF_EMULATE_CDB_ASYNC and SCF_EMULATE_SYNC_CACHE bits, and updates
__transport_execute_tasks() to skip local completion case when processing
a SYNCHRONIZE_CACHE* CDB.

It also adds a special case usage of transport_get_sectors() for
SCF_EMULATE_SYNC_CACHE to check to ensure the received LBA + Range does not
exceed past the end of the struct se_device.  Finally, this patch also adds a
passthrough for TCM/pSCSI to not setup the cmd->transport_emulate_cdb() caller,
and allows a method to disable the WriteCache, et al. emulation for an attached
struct scsi_device.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |  124 +++++++++++++++++++++++++++++--
 include/target/target_core_base.h      |    3 +
 2 files changed, 119 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 97b6254..076faa5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1168,6 +1168,32 @@ void transport_complete_cmd(struct se_cmd *cmd, int success)
 	cmd->transport_add_cmd_to_queue(cmd, t_state);
 }
 
+/*
+ * Completion function used by TCM subsystem plugins (such as FILEIO)
+ * for queueing up response from a struct se_subsystem_api
+ * ->do_sync_cache() and ->do_sync_cache_range().  This completion is
+ * enabled by setting 'struct se_cmd->se_cmd_flags |= SCF_EMULATE_SYNC_CACHE |
+ * SCF_EMULATE_CDB_ASYNC
+ */
+void transport_complete_sync_cache(struct se_cmd *cmd, int good)
+{
+	struct se_task *task = list_entry(T_TASK(cmd)->t_task_list.next,
+				struct se_task, t_list);
+
+	if (good) {
+		cmd->scsi_status = SAM_STAT_GOOD;
+		task->task_scsi_status = GOOD;
+	} else {
+		task->task_scsi_status = SAM_STAT_CHECK_CONDITION;
+		task->task_error_status = PYX_TRANSPORT_ILLEGAL_REQUEST;
+		TASK_CMD(task)->transport_error_status =
+					PYX_TRANSPORT_ILLEGAL_REQUEST;
+	}
+
+	transport_complete_task(task, good);
+}
+EXPORT_SYMBOL(transport_complete_sync_cache);
+
 /*	transport_complete_task():
  *
  *	Called from interrupt and non interrupt context depending
@@ -4143,11 +4169,15 @@ check_depth:
 		}
 		/*
 		 * Handle the successful completion for transport_emulate_cdb()
-		 * usage.
+		 * for synchronous operation, following SCF_EMULATE_CDB_ASYNC 
+		 * Otherwise the caller is expected to complete the task with
+		 * proper status.
 		 */
-		cmd->scsi_status = SAM_STAT_GOOD;
-		task->task_scsi_status = GOOD;
-		transport_complete_task(task, 1);
+		if (!(cmd->se_cmd_flags & SCF_EMULATE_CDB_ASYNC)) {
+			cmd->scsi_status = SAM_STAT_GOOD;
+			task->task_scsi_status = GOOD;
+			transport_complete_task(task, 1);
+		}
 	} else {
 		error = TRANSPORT(dev)->do_task(task);
 		if (error != 0) {
@@ -5141,6 +5171,42 @@ int transport_get_sense_data(struct se_cmd *cmd)
 	return -1;
 }
 
+static int transport_generic_synchronize_cache(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+	/*
+	 * Determine if we will be flushing the entire device.
+	 */
+	if ((T_TASK(cmd)->t_task_lba == 0) && (cmd->data_length == 0)) {
+		if (TRANSPORT(dev)->do_sync_cache == NULL) {
+			printk(KERN_ERR "TRANSPORT(dev)->do_sync_cache is NULL\n");
+			return PYX_TRANSPORT_LU_COMM_FAILURE;
+		}
+		/*
+		 * The TCM subsystem plugin is expected to handle the
+		 * completion of the SYNCHRONIZE_CACHE op emulation
+		 */
+		TRANSPORT(dev)->do_sync_cache(cmd);
+		return 0;
+	}
+	/*
+	 * Otherwise we are flushing a specific range of LBAs.  The
+	 * ->do_sync_cache_range() caller is expected to handle any
+	 * LBA -> offset conversion.
+	 */
+	if (TRANSPORT(dev)->do_sync_cache_range == NULL) {
+		printk(KERN_ERR "TRANSPORT(dev)->do_sync_cache_range is NULL\n");
+		return PYX_TRANSPORT_LU_COMM_FAILURE;
+	}
+	/*
+	 * The TCM subsystem plugin is expected to handle the
+	 * completion of the SYNCHRONIZE_CACHE op emulation
+	 */
+	TRANSPORT(dev)->do_sync_cache_range(cmd, T_TASK(cmd)->t_task_lba,
+					cmd->data_length);
+	return 0;
+}
+
 static inline void transport_dev_get_mem_buf(
 	struct se_device *dev,
 	struct se_cmd *cmd)
@@ -5313,6 +5379,7 @@ static int transport_generic_cmd_sequencer(
 		transport_get_maps(cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_10;
 		cmd->transport_get_lba = &transport_lba_32;
+		T_TASK(cmd)->t_task_fua = (cdb[1] & 0x8);
 		ret = TGCS_DATA_SG_IO_CDB;
 		break;
 	case WRITE_12:
@@ -5325,6 +5392,7 @@ static int transport_generic_cmd_sequencer(
 		transport_get_maps(cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_12;
 		cmd->transport_get_lba = &transport_lba_32;
+		T_TASK(cmd)->t_task_fua = (cdb[1] & 0x8);
 		ret = TGCS_DATA_SG_IO_CDB;
 		break;
 	case WRITE_16:
@@ -5337,6 +5405,7 @@ static int transport_generic_cmd_sequencer(
 		transport_get_maps(cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_16;
 		cmd->transport_get_long_lba = &transport_lba_64;
+		T_TASK(cmd)->t_task_fua = (cdb[1] & 0x8);
 		ret = TGCS_DATA_SG_IO_CDB;
 		break;
 	case 0xa3:
@@ -5617,6 +5686,46 @@ static int transport_generic_cmd_sequencer(
 				&core_scsi2_emulate_crh : NULL;
 		ret = TGCS_NON_DATA_CDB;
 		break;
+	case SYNCHRONIZE_CACHE:
+	case 0x91: /* SYNCHRONIZE_CACHE_16: */
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
+		cmd->transport_allocate_resources =
+				&transport_generic_allocate_none;
+		transport_get_maps(cmd);
+		/*
+		 * Extract LBA and range to be flushed for emulated SYNCHRONIZE_CACHE
+		 */
+		if (cdb[0] == SYNCHRONIZE_CACHE) {
+			sectors = transport_get_sectors_10(cdb, cmd, &sector_ret);
+			T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
+		} else {
+			sectors = transport_get_sectors_16(cdb, cmd, &sector_ret);
+			T_TASK(cmd)->t_task_lba = transport_lba_64(cdb);
+		}
+                if (sector_ret)
+                        return TGCS_UNSUPPORTED_CDB;
+
+                size = transport_get_size(sectors, cdb, cmd);
+		ret = TGCS_NON_DATA_CDB;
+		/*
+		 * For TCM/pSCSI passthrough, skip cmd->transport_emulate_cdb()
+		 */
+		if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)
+			break;
+		/*
+		 * Setup the transport_generic_synchronize_cache() callback
+		 * Also set SCF_EMULATE_CDB_ASYNC to ensure asynchronous operation
+		 * for SYNCHRONIZE_CACHE* Immed=1 case in __transport_execute_tasks()
+		 */
+		cmd->transport_emulate_cdb = &transport_generic_synchronize_cache;
+		cmd->se_cmd_flags |= (SCF_EMULATE_SYNC_CACHE | SCF_EMULATE_CDB_ASYNC);
+		/*
+		 * Check to ensure that LBA + Range does not exceed past end of
+		 * device.
+		 */
+		if (transport_get_sectors(cmd) < 0)
+			return TGCS_INVALID_CDB_FIELD;
+		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case GPCMD_CLOSE_TRACK:
 	case ERASE:
@@ -5627,7 +5736,6 @@ static int transport_generic_cmd_sequencer(
 	case GPCMD_SET_SPEED:
 	case SPACE:
 	case START_STOP:
-	case SYNCHRONIZE_CACHE:
 	case TEST_UNIT_READY:
 	case VERIFY:
 	case WRITE_FILEMARKS:
@@ -6435,12 +6543,12 @@ static inline long long transport_dev_end_lba(struct se_device *dev)
 	return dev->dev_sectors_total + 1;
 }
 
-int transport_get_sectors(
-	struct se_cmd *cmd)
+int transport_get_sectors(struct se_cmd *cmd)
 {
 	struct se_device *dev = SE_DEV(cmd);
 
-	if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
+	if (!(cmd->se_cmd_flags & SCF_EMULATE_SYNC_CACHE) &&
+	    !(cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
 		return 0;
 
 	T_TASK(cmd)->t_task_sectors =
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index a32762c..d6c2879 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -173,6 +173,8 @@
 #define SCF_PASSTHROUGH_SG_TO_MEM		0x00200000
 #define SCF_PASSTHROUGH_CONTIG_TO_SG		0x00400000
 #define SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC	0x00800000
+#define SCF_EMULATE_SYNC_CACHE			0x01000000
+#define SCF_EMULATE_CDB_ASYNC			0x02000000
 
 /* struct se_device->type */
 #define PSCSI					1
@@ -414,6 +416,7 @@ struct se_transport_task {
 	unsigned char		t_task_cdb[SCSI_CDB_SIZE];
 	unsigned long long	t_task_lba;
 	int			t_tasks_failed;
+	int			t_task_fua;
 	u32			t_task_cdbs;
 	u32			t_task_check;
 	u32			t_task_no;
-- 
1.5.6.5

