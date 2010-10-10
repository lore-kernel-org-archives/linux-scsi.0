From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/4] tcm: Unify subsystem plugin control CDB emulation
Date: Sat,  9 Oct 2010 20:48:28 -0700
Message-ID: <1286682508-4842-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a generic transport_emulate_control_cdb() caller used
by virtual IBLOCK, FILEIO and RAMDISK subsystem plugins for both
completely generic TCM CDB emulation, and CDB emulation requiring
information from subsystem plugin dependent code.

For the latter case inside of target_core_transport.h, this patch adds:

	struct se_subsystem_api_cdb {
	       int (*emulate_inquiry)(struct se_task *);
	       int (*emulate_read_cap)(struct se_task *);
	       int (*emulate_read_cap16)(struct se_task *);
	       int (*emulate_unmap)(struct se_task *);
	};

along with a struct se_subsystem_api->sub_cdb pointer that we now
expect IBLOCK, FILEIO and RAMDISK to set up this pointer before
calling transport_subsystem_register().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   88 ++++++++++++++++++++++++++++++++
 include/target/target_core_transport.h |   17 ++++++
 2 files changed, 105 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index aaec0cc..2c86d0f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5574,6 +5574,94 @@ int transport_generic_write_same(struct se_cmd *cmd, struct block_device *bdev)
 }
 EXPORT_SYMBOL(transport_generic_write_same);
 
+/*
+ * Used by TCM subsystem plugins IBLOCK, FILEIO, and RAMDISK as a
+ * generic non SCF_SCSI_DATA_SG_IO_CDB ops.
+ */
+int transport_emulate_control_cdb(struct se_task *task)
+{
+	struct se_cmd *cmd = TASK_CMD(task);
+	struct se_device *dev = SE_DEV(cmd);
+	struct se_subsystem_api_cdb *api_cdb = TRANSPORT(dev)->sub_cdb;
+	int ret;
+
+	switch (T_TASK(cmd)->t_task_cdb[0]) {
+	case INQUIRY:
+		if (api_cdb->emulate_inquiry(task) < 0)
+			return PYX_TRANSPORT_INVALID_CDB_FIELD;
+		break;
+	case READ_CAPACITY:
+		ret = api_cdb->emulate_read_cap(task);	
+		if (ret < 0)
+			return ret;
+		break;
+	case MODE_SENSE:
+		ret = transport_generic_emulate_modesense(TASK_CMD(task),
+				T_TASK(cmd)->t_task_cdb,
+				T_TASK(cmd)->t_task_buf, 0,
+				TRANSPORT(dev)->get_device_type(dev));
+		if (ret < 0)
+			return ret;
+		break;
+	case MODE_SENSE_10:
+		ret = transport_generic_emulate_modesense(TASK_CMD(task),
+				T_TASK(cmd)->t_task_cdb,
+				T_TASK(cmd)->t_task_buf, 1,
+				TRANSPORT(dev)->get_device_type(dev));
+		if (ret < 0)
+			return ret;
+		break;
+	case SERVICE_ACTION_IN:
+		switch (T_TASK(cmd)->t_task_cdb[1] & 0x1f) {
+		case SAI_READ_CAPACITY_16:
+			ret = api_cdb->emulate_read_cap16(task);
+			if (ret < 0)
+				return ret;
+			break;
+		default:
+			printk(KERN_ERR "Unsupported SA: 0x%02x\n",
+				T_TASK(cmd)->t_task_cdb[1] & 0x1f);
+			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
+		}
+	case REQUEST_SENSE:
+		ret = transport_generic_emulate_request_sense(cmd,
+				T_TASK(cmd)->t_task_cdb);
+		if (ret < 0)
+			return ret;
+		break;
+	case UNMAP:
+		if (!(api_cdb->emulate_unmap)) {
+			printk(KERN_ERR "UNMAP emulation not supported for: %s\n",
+					TRANSPORT(dev)->name);
+			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
+		}
+		ret = api_cdb->emulate_unmap(task);
+		if (ret < 0)
+			return ret;
+		break;
+	case ALLOW_MEDIUM_REMOVAL:
+	case ERASE:
+	case REZERO_UNIT:
+	case SEEK_10:
+	case SPACE:
+	case START_STOP:
+	case TEST_UNIT_READY:
+	case VERIFY:
+	case WRITE_FILEMARKS:
+		break;
+	default:
+		printk(KERN_ERR "Unsupported SCSI Opcode: 0x%02x for %s\n",
+			T_TASK(cmd)->t_task_cdb[0], TRANSPORT(dev)->name);
+		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
+	}
+	
+	task->task_scsi_status = GOOD;
+	transport_complete_task(task, 1);
+
+	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
+}
+EXPORT_SYMBOL(transport_emulate_control_cdb);
+
 static inline void transport_dev_get_mem_buf(
 	struct se_device *dev,
 	struct se_cmd *cmd)
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 74a56f1..0374876 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -241,6 +241,7 @@ extern int transport_generic_emulate_request_sense(struct se_cmd *,
 extern int transport_get_sense_data(struct se_cmd *);
 extern int transport_generic_unmap(struct se_cmd *, struct block_device *);
 extern int transport_generic_write_same(struct se_cmd *, struct block_device *);
+extern int transport_emulate_control_cdb(struct se_task *);
 extern struct se_cmd *transport_allocate_passthrough(unsigned char *, int, u32,
 						void *, u32, u32, void *);
 extern void transport_passthrough_release(struct se_cmd *);
@@ -314,6 +315,17 @@ struct se_mem {
 } ____cacheline_aligned;
 
 /*
+ * Used as a minimal template for per CDB specific emulation into TCM
+ * subsystem plugins.for those CDBs that cannot be emulated generically.
+ */
+struct se_subsystem_api_cdb {
+	int (*emulate_inquiry)(struct se_task *);
+	int (*emulate_read_cap)(struct se_task *);
+	int (*emulate_read_cap16)(struct se_task *);
+	int (*emulate_unmap)(struct se_task *);
+};
+
+/*
  * 	Each type of disk transport supported MUST have a template defined
  *	within its .h file.
  */
@@ -339,6 +351,11 @@ struct se_subsystem_api {
 	 */
 	struct module *sub_owner;
 	/*
+	 * Set of function pointers use for per CDB context emulation
+	 * by virtual IBLOCK, FILEIO, and RAMDISK subsystem plugins.
+	 */
+	struct se_subsystem_api_cdb *sub_cdb;
+	/*
 	 * Counter for struct se_hba reference
 	 */
 	atomic_t sub_api_hba_cnt;
-- 
1.5.6.5
