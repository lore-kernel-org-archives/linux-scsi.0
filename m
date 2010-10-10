From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/4] tcm: Move WRITE_SAME_* emulation into transport_emulate_control_cdb()
Date: Sat,  9 Oct 2010 20:48:47 -0700
Message-ID: <1286682527-4884-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.re3.yahoo.com ([66.196.96.84]:36546 "HELO
	smtp101.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760742Ab0JJDsw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2010 23:48:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates TCM Core to perform WRITE_SAME_16 and WRITE_SAME_32
w/ UNMAP=1 emulation using the unified control CDB infrastructure.  This
includes adding a new struct se_subsystem_api_cdb->emulate_write_same() caller
used in transport_emulate_control_cdb(), changing transport_generic_cmd_sequencer()
to return type TGCS_CONTROL_SG_IO_CDB and removing the now unnecessary
struct se_transport_task->t_tasks_unmap and SCF_ECDB_ALLOCATION define.

This patch also updates IBLOCK and FILEIO to set ->emulate_write_same()
and hooks up the existing WRITE_SAME_* -> Block Discard logic to the new
caller.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c      |    3 +-
 drivers/target/target_core_iblock.c    |    3 +-
 drivers/target/target_core_transport.c |   67 +++++++++++++++++--------------
 include/target/target_core_base.h      |    4 +-
 include/target/target_core_transport.h |    1 +
 5 files changed, 41 insertions(+), 37 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 33c6510..55e9ad5 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -782,8 +782,6 @@ static int fd_do_task(struct se_task *task)
 
 	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
 		return transport_emulate_control_cdb(task);
-	else if (T_TASK(cmd)->t_tasks_unmap)
-		return fd_emulate_write_same_unmap(task);
 
 	req->fd_lba = task->task_lba;
 	req->fd_size = task->task_size;
@@ -1218,6 +1216,7 @@ static struct se_subsystem_api_cdb fileio_cdb_template = {
 	.emulate_read_cap	= fd_emulate_read_cap,
 	.emulate_read_cap16	= fd_emulate_read_cap16,
 	.emulate_unmap		= fd_emulate_unmap,
+	.emulate_write_same	= fd_emulate_write_same_unmap,
 };
 
 int __init fileio_module_init(void)
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d102e0b..a0a9ea3 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -584,8 +584,6 @@ static int iblock_do_task(struct se_task *task)
 
 	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
 		return transport_emulate_control_cdb(task);
-	else if (T_TASK(task->task_se_cmd)->t_tasks_unmap)
-		return iblock_emulate_write_same_unmap(task);
 
 	while (bio) {
 		nbio = bio->bi_next;
@@ -1139,6 +1137,7 @@ static struct se_subsystem_api_cdb iblock_cdb_template = {
 	.emulate_read_cap	= iblock_emulate_read_cap,
 	.emulate_read_cap16	= iblock_emulate_read_cap16,
 	.emulate_unmap		= iblock_emulate_unmap,
+	.emulate_write_same	= iblock_emulate_write_same_unmap,
 };
 
 int __init iblock_module_init(void)
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2c86d0f..ae3ce18 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5552,13 +5552,6 @@ int transport_generic_write_same(struct se_cmd *cmd, struct block_device *bdev)
 	sector_t lba;
 	unsigned int range;
 	int barrier = 0, ret;
-	/*
-	 * If the UNMAP bit was not set, we should not be calling this to being with..
-	 */
-	if (!(T_TASK(cmd)->t_tasks_unmap)) {
-		dump_stack();
-		return -1;
-	}
 
 	lba = T_TASK(cmd)->t_task_lba;
 	range = (cmd->data_length / TRANSPORT(dev)->get_blocksize(dev));
@@ -5584,6 +5577,7 @@ int transport_emulate_control_cdb(struct se_task *task)
 	struct se_device *dev = SE_DEV(cmd);
 	struct se_subsystem_api_cdb *api_cdb = TRANSPORT(dev)->sub_cdb;
 	int ret;
+	unsigned short service_action;
 
 	switch (T_TASK(cmd)->t_task_cdb[0]) {
 	case INQUIRY:
@@ -5639,6 +5633,35 @@ int transport_emulate_control_cdb(struct se_task *task)
 		if (ret < 0)
 			return ret;
 		break;
+	case WRITE_SAME_16:
+		if (!(api_cdb->emulate_write_same)) {
+			printk(KERN_ERR "WRITE_SAME_16 emulation not supported"
+					" for: %s\n", TRANSPORT(dev)->name);
+			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
+		}
+		ret = api_cdb->emulate_write_same(task);
+		if (ret < 0)
+			return ret;
+		break;
+	case VARIABLE_LENGTH_CMD:
+		service_action = get_unaligned_be16(&T_TASK(cmd)->t_task_cdb[8]);
+		switch (service_action) {
+		case WRITE_SAME_32:
+			if (!(api_cdb->emulate_write_same)) {
+				printk(KERN_ERR "WRITE_SAME_32 SA emulation not"
+					" supported for: %s\n", TRANSPORT(dev)->name);
+				return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
+			}
+			ret = api_cdb->emulate_write_same(task);
+			if (ret < 0)
+				return ret;
+			break;
+		default:
+			printk(KERN_ERR "Unsupported VARIABLE_LENGTH_CMD SA:"
+					" 0x%02x\n", service_action);
+			break;
+		}
+		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case ERASE:
 	case REZERO_UNIT:
@@ -5951,13 +5974,12 @@ static int transport_generic_cmd_sequencer(
 			size = transport_get_size(sectors, cdb, cmd);
 			transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 			transport_get_maps(cmd);
-			cmd->transport_split_cdb = &split_cdb_XX_32;
-			cmd->transport_get_long_lba = &transport_lba_64_ext;
+			T_TASK(cmd)->t_task_lba = get_unaligned_be64(&cdb[12]);
 			/*
 			 * Skip the remaining assignments for TCM/PSCSI passthrough
 			 */
 			if (passthrough) {
-				ret = TGCS_DATA_SG_IO_CDB;
+				ret = TGCS_CONTROL_SG_IO_CDB;
 				break;
 			}
 			if ((cdb[10] & 0x04) || (cdb[10] & 0x02)) {
@@ -5971,18 +5993,11 @@ static int transport_generic_cmd_sequencer(
 			 * tpws with the UNMAP=1 bit set.
 			 */
 			if (!(cdb[10] & 0x08)) {
-				printk(KERN_ERR "WRITE_SAME w/ UNMAP bit not"
+				printk(KERN_ERR "WRITE_SAME w/o UNMAP bit not"
 					" supported for Block Discard Emulation\n");
 				return TGCS_INVALID_CDB_FIELD;
 			}
-			
-			cmd->se_cmd_flags |= SCF_EMULATE_SYNC_WRITE_SAME;
-			/*
-			 * Signal to TCM IBLOCK+FILEIO subsystem plugins that WRITE
-			 * tasks will be translated to SCSI UNMAP -> Block Discard
-			 */
-			T_TASK(cmd)->t_tasks_unmap = 1;
-			ret = TGCS_DATA_SG_IO_CDB;	
+			ret = TGCS_CONTROL_SG_IO_CDB;
 			break;
 		default:
 			printk(KERN_ERR "VARIABLE_LENGTH_CMD service action"
@@ -6332,8 +6347,7 @@ static int transport_generic_cmd_sequencer(
 		size = transport_get_size(sectors, cdb, cmd);
 		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
-		cmd->transport_split_cdb = &split_cdb_XX_16;
-		cmd->transport_get_long_lba = &transport_lba_64;
+		T_TASK(cmd)->t_task_lba = get_unaligned_be16(&cdb[2]);
 		passthrough = (TRANSPORT(dev)->transport_type ==
 				TRANSPORT_PLUGIN_PHBA_PDEV);
 		/*
@@ -6355,19 +6369,12 @@ static int transport_generic_cmd_sequencer(
 			 * tpws with the UNMAP=1 bit set.
 			 */
 			if (!(cdb[1] & 0x08)) {
-				printk(KERN_ERR "WRITE_SAME w/ UNMAP bit not "
+				printk(KERN_ERR "WRITE_SAME w/o UNMAP bit not "
 					" supported for Block Discard Emulation\n");
 				return TGCS_INVALID_CDB_FIELD;
 			}
-
-			cmd->se_cmd_flags |= SCF_EMULATE_SYNC_WRITE_SAME;
-			/*
-			 * Signal to TCM IBLOCK+FILEIO subsystem plugins that WRITE
-			 * tasks will be translated to SCSI UNMAP -> Block Discard
-			 */
-			T_TASK(cmd)->t_tasks_unmap = 1;
 		}
-		ret = TGCS_DATA_SG_IO_CDB;
+		ret = TGCS_CONTROL_SG_IO_CDB;
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case GPCMD_CLOSE_TRACK:
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index f13193a..eb546f4 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -138,8 +138,7 @@ enum se_cmd_flags_table {
 	SCF_EMULATE_SYNC_CACHE		= 0x01000000,
 	SCF_EMULATE_CDB_ASYNC		= 0x02000000,
 	SCF_EMULATE_SYNC_UNMAP		= 0x04000000,
-	SCF_ECDB_ALLOCATION		= 0x08000000,
-	SCF_EMULATE_SYNC_WRITE_SAME	= 0x10000000
+	SCF_ECDB_ALLOCATION		= 0x08000000
 };
 	
 /* struct se_device->type for known subsystem plugins */
@@ -432,7 +431,6 @@ struct se_transport_task {
 	int			t_tasks_failed;
 	int			t_tasks_fua;
 	int			t_tasks_bidi:1;
-	int			t_tasks_unmap:1;
 	u32			t_task_cdbs;
 	u32			t_tasks_check;
 	u32			t_tasks_no;
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 0374876..31e726f 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -323,6 +323,7 @@ struct se_subsystem_api_cdb {
 	int (*emulate_read_cap)(struct se_task *);
 	int (*emulate_read_cap16)(struct se_task *);
 	int (*emulate_unmap)(struct se_task *);
+	int (*emulate_write_same)(struct se_task *);
 };
 
 /*
-- 
1.5.6.5

