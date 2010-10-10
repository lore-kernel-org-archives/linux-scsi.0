From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/4] tcm: Convert IBLOCK, FILEIO and RAMDISK subsystem code to transport_emulate_control_cdb()
Date: Sat,  9 Oct 2010 20:48:37 -0700
Message-ID: <1286682517-4863-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.ac4.yahoo.com ([76.13.13.243]:48521 "HELO
	smtp104.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760724Ab0JJDsm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2010 23:48:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the IBLOCK, FILEIO, and RAMDISK subsystem plugins to use
the unified caller transport_emulate_control_cdb() introduced in commit 4254bfebd2e.

This includes adding new [iblock,file,rd]_cdb_template API callers using existing
code for INQUIRY, READ_CAPACITY, SA READ_CAPACITY_16 and UNMAP CDB emulation, and
removes the legacy *_emulate_scsi_cdb() and their usage int *_do_task() dispatch
callers.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c   |  145 +++++++++-------------------------
 drivers/target/target_core_iblock.c |   87 +++------------------
 drivers/target/target_core_rd.c     |   91 +++-------------------
 3 files changed, 62 insertions(+), 261 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 1215f3c..33c6510 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -408,122 +408,47 @@ static int fd_emulate_read_cap16(struct se_task *task)
 		blocks_long);
 }
 
-/*	fd_emulate_scsi_cdb():
- *
- *
- */
-static int fd_emulate_scsi_cdb(struct se_task *task)
+static int fd_emulate_unmap(struct se_task *task)
 {
 	struct se_cmd *cmd = TASK_CMD(task);
 	struct fd_dev *fd_dev = task->se_dev->dev_ptr;
-	struct fd_request *fd_req = task->transport_req;
 	struct file *f = fd_dev->fd_file;
 	struct inode *i;
 	struct block_device *bd;
 	int ret;
 
-	switch (fd_req->fd_scsi_cdb[0]) {
-	case INQUIRY:
-		if (fd_emulate_inquiry(task) < 0)
-			return PYX_TRANSPORT_INVALID_CDB_FIELD;
-		break;
-	case READ_CAPACITY:
-		ret = fd_emulate_read_cap(task);
-		if (ret < 0)
-			return ret;
-		break;
-	case MODE_SENSE:
-		ret = transport_generic_emulate_modesense(TASK_CMD(task),
-				fd_req->fd_scsi_cdb, fd_req->fd_buf, 0,
-				TYPE_DISK);
-		if (ret < 0)
-			return ret;
-		break;
-	case MODE_SENSE_10:
-		ret = transport_generic_emulate_modesense(TASK_CMD(task),
-				fd_req->fd_scsi_cdb, fd_req->fd_buf, 1,
-				TYPE_DISK);
-		if (ret < 0)
-			return ret;
-		break;
-	case SERVICE_ACTION_IN:
-		if ((T_TASK(cmd)->t_task_cdb[1] & 0x1f) !=
-		     SAI_READ_CAPACITY_16) {
-			printk(KERN_ERR "Unsupported SA: 0x%02x\n",
-				T_TASK(cmd)->t_task_cdb[1] & 0x1f);
-			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
-		}
-		ret = fd_emulate_read_cap16(task);
-		if (ret < 0)
-			return ret;
-		break;
-	case REQUEST_SENSE:
-		ret = transport_generic_emulate_request_sense(cmd,
-				T_TASK(cmd)->t_task_cdb);
-		if (ret < 0)
-			return ret;
-		break;
-	case UNMAP:
-		i = igrab(f->f_mapping->host);
-		if (!(i)) {
-			printk(KERN_ERR "FILEIO: Unable to locate inode for"
-					" backend for UNMAP\n");
-			return PYX_TRANSPORT_LU_COMM_FAILURE;
-		}
-		/*
-		 * Currently for struct file w/o a struct block_device
-		 * backend we return a success..
-		 */	
-		if (!(S_ISBLK(i->i_mode))) {
-			printk(KERN_WARNING "Ignoring UNMAP for non BD"
-					" backend for struct file\n");
-			iput(i);
-			return PYX_TRANSPORT_LU_COMM_FAILURE;
-		}
-		bd = I_BDEV(f->f_mapping->host);
-		if (!(bd)) {
-			printk(KERN_ERR "FILEIO: Unable to locate struct"
-					" block_device for UNMAP\n");
-			iput(i);
-			return PYX_TRANSPORT_LU_COMM_FAILURE;
-		}
-		/*
-		 * Now call the transport_generic_unmap() -> blkdev_issue_discard()
-		 * wrapper to translate SCSI UNMAP into Linux/BLOCK discards on
-		 * LBA+Range descriptors in the UNMAP write paylaod.
-		 */
-		ret = transport_generic_unmap(cmd, bd);
-		if (ret < 0) {
-			iput(i);
-			return ret;
-		}
+	i = igrab(f->f_mapping->host);
+	if (!(i)) {
+		printk(KERN_ERR "FILEIO: Unable to locate inode for"
+				" backend for UNMAP\n");
+		return PYX_TRANSPORT_LU_COMM_FAILURE;
+	}
+	/*
+	 * Currently for struct file w/o a struct block_device
+	 * backend we return a success..
+	 */	
+	if (!(S_ISBLK(i->i_mode))) {
+		printk(KERN_WARNING "Ignoring UNMAP for non BD"
+				" backend for struct file\n");
 		iput(i);
-		break;
-	case ALLOW_MEDIUM_REMOVAL:
-	case ERASE:
-	case REZERO_UNIT:
-	case SEEK_10:
-	case SPACE:
-	case START_STOP:
-	case SYNCHRONIZE_CACHE:
-	case TEST_UNIT_READY:
-	case VERIFY:
-	case WRITE_FILEMARKS:
-	case RESERVE:
-	case RESERVE_10:
-	case RELEASE:
-	case RELEASE_10:
-		break;
-	default:
-		printk(KERN_ERR "Unsupported SCSI Opcode: 0x%02x for FILEIO\n",
-				fd_req->fd_scsi_cdb[0]);
-		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
+		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
+	bd = I_BDEV(f->f_mapping->host);
+	if (!(bd)) {
+		printk(KERN_ERR "FILEIO: Unable to locate struct"
+				" block_device for UNMAP\n");
+		iput(i);
+		return PYX_TRANSPORT_LU_COMM_FAILURE;
+	}
+	/*
+	 * Now call the transport_generic_unmap() -> blkdev_issue_discard()
+	 * wrapper to translate SCSI UNMAP into Linux/BLOCK discards on
+	 * LBA+Range descriptors in the UNMAP write paylaod.
+	 */
+	ret = transport_generic_unmap(cmd, bd);
+	iput(i);
 
-	task->task_scsi_status = GOOD;
-	transport_complete_task(task, 1);
-
-	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
+	return ret;
 }
 
 static int fd_emulate_write_same_unmap(struct se_task *task)
@@ -856,7 +781,7 @@ static int fd_do_task(struct se_task *task)
 	int ret = 0;
 
 	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
-		return fd_emulate_scsi_cdb(task);
+		return transport_emulate_control_cdb(task);
 	else if (T_TASK(cmd)->t_tasks_unmap)
 		return fd_emulate_write_same_unmap(task);
 
@@ -1288,11 +1213,19 @@ static struct se_subsystem_api fileio_template = {
 	.write_pending		= NULL,
 };
 
+static struct se_subsystem_api_cdb fileio_cdb_template = {
+	.emulate_inquiry	= fd_emulate_inquiry,
+	.emulate_read_cap	= fd_emulate_read_cap,
+	.emulate_read_cap16	= fd_emulate_read_cap16,
+	.emulate_unmap		= fd_emulate_unmap,
+};
+
 int __init fileio_module_init(void)
 {
 	int ret;
 
 	INIT_LIST_HEAD(&fileio_template.sub_api_list);
+	fileio_template.sub_cdb = &fileio_cdb_template;
 
 	ret = transport_subsystem_register(&fileio_template, THIS_MODULE);
 	if (ret < 0)
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 44d54a6..d102e0b 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -468,84 +468,13 @@ static int iblock_emulate_read_cap16(struct se_task *task)
 				TASK_CMD(task), blocks_long);
 }
 
-static int iblock_emulate_scsi_cdb(struct se_task *task)
+static int iblock_emulate_unmap(struct se_task *task)
 {
 	struct iblock_dev *ibd = task->se_dev->dev_ptr;
 	struct block_device *bd = ibd->ibd_bd;
 	struct se_cmd *cmd = TASK_CMD(task);
-	int ret;
-
-	switch (T_TASK(cmd)->t_task_cdb[0]) {
-	case INQUIRY:
-		if (iblock_emulate_inquiry(task) < 0)
-			return PYX_TRANSPORT_INVALID_CDB_FIELD;
-		break;
-	case READ_CAPACITY:
-		ret = iblock_emulate_read_cap(task);
-		if (ret < 0)
-			return ret;
-		break;
-	case MODE_SENSE:
-		ret = transport_generic_emulate_modesense(TASK_CMD(task),
-				T_TASK(cmd)->t_task_cdb,
-				T_TASK(cmd)->t_task_buf, 0, TYPE_DISK);
-		if (ret < 0)
-			return ret;
-		break;
-	case MODE_SENSE_10:
-		ret = transport_generic_emulate_modesense(TASK_CMD(task),
-				T_TASK(cmd)->t_task_cdb,
-			T_TASK(cmd)->t_task_buf, 1, TYPE_DISK);
-		if (ret < 0)
-			return ret;
-		break;
-	case SERVICE_ACTION_IN:
-		if ((T_TASK(cmd)->t_task_cdb[1] & 0x1f) !=
-		     SAI_READ_CAPACITY_16) {
-			printk(KERN_ERR "Unsupported SA: 0x%02x\n",
-				T_TASK(cmd)->t_task_cdb[1] & 0x1f);
-			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
-		}
-		ret = iblock_emulate_read_cap16(task);
-		if (ret < 0)
-			return ret;
-		break;
-	case REQUEST_SENSE:
-		ret = transport_generic_emulate_request_sense(cmd,
-				T_TASK(cmd)->t_task_cdb);
-		if (ret < 0)
-			return ret;
-		break;
-	case UNMAP:
-		ret = transport_generic_unmap(cmd, bd);
-		if (ret < 0)
-			return ret;
-		break;
-	case ALLOW_MEDIUM_REMOVAL:
-	case ERASE:
-	case REZERO_UNIT:
-	case SEEK_10:
-	case SPACE:
-	case START_STOP:
-	case SYNCHRONIZE_CACHE:
-	case TEST_UNIT_READY:
-	case VERIFY:
-	case WRITE_FILEMARKS:
-	case RESERVE:
-	case RESERVE_10:
-	case RELEASE:
-	case RELEASE_10:
-		break;
-	default:
-		printk(KERN_ERR "Unsupported SCSI Opcode: 0x%02x for iBlock\n",
-				T_TASK(cmd)->t_task_cdb[0]);
-		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
-	}
-
-	task->task_scsi_status = GOOD;
-	transport_complete_task(task, 1);
-
-	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
+	
+	return transport_generic_unmap(cmd, bd);
 }
 
 static int iblock_emulate_write_same_unmap(struct se_task *task)
@@ -654,7 +583,7 @@ static int iblock_do_task(struct se_task *task)
 	int ret;
 
 	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
-		return iblock_emulate_scsi_cdb(task);
+		return transport_emulate_control_cdb(task);
 	else if (T_TASK(task->task_se_cmd)->t_tasks_unmap)
 		return iblock_emulate_write_same_unmap(task);
 
@@ -1205,11 +1134,19 @@ static struct se_subsystem_api iblock_template = {
 	.write_pending		= NULL,
 };
 
+static struct se_subsystem_api_cdb iblock_cdb_template = {
+	.emulate_inquiry	= iblock_emulate_inquiry,
+	.emulate_read_cap	= iblock_emulate_read_cap,
+	.emulate_read_cap16	= iblock_emulate_read_cap16,
+	.emulate_unmap		= iblock_emulate_unmap,
+};
+
 int __init iblock_module_init(void)
 {
 	int ret;
 
 	INIT_LIST_HEAD(&iblock_template.sub_api_list);
+	iblock_template.sub_cdb = &iblock_cdb_template;
 
 	ret = transport_subsystem_register(&iblock_template, THIS_MODULE);
 	if (ret < 0)
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index c6e128a..fe27e59 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -434,84 +434,6 @@ static int rd_emulate_read_cap16(struct se_task *task)
 				blocks_long);
 }
 
-/*	rd_emulate_scsi_cdb():
- *
- *
- */
-static int rd_emulate_scsi_cdb(struct se_task *task)
-{
-	int ret;
-	struct se_cmd *cmd = TASK_CMD(task);
-	struct rd_request *rd_req = task->transport_req;
-
-	switch (rd_req->rd_scsi_cdb[0]) {
-	case INQUIRY:
-		if (rd_emulate_inquiry(task) < 0)
-			return PYX_TRANSPORT_INVALID_CDB_FIELD;
-		break;
-	case READ_CAPACITY:
-		ret = rd_emulate_read_cap(task);
-		if (ret < 0)
-			return ret;
-		break;
-	case MODE_SENSE:
-		ret = transport_generic_emulate_modesense(TASK_CMD(task),
-				rd_req->rd_scsi_cdb, rd_req->rd_buf, 0,
-				TYPE_DISK);
-		if (ret < 0)
-			return ret;
-		break;
-	case MODE_SENSE_10:
-		ret = transport_generic_emulate_modesense(TASK_CMD(task),
-				rd_req->rd_scsi_cdb, rd_req->rd_buf, 1,
-				TYPE_DISK);
-		if (ret < 0)
-			return ret;
-		break;
-	case SERVICE_ACTION_IN:
-		if ((T_TASK(cmd)->t_task_cdb[1] & 0x1f) !=
-		     SAI_READ_CAPACITY_16) {
-			printk(KERN_ERR "Unsupported SA: 0x%02x\n",
-					T_TASK(cmd)->t_task_cdb[1] & 0x1f);
-			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
-		}
-		ret = rd_emulate_read_cap16(task);
-		if (ret < 0)
-			return ret;
-		break;
-	case REQUEST_SENSE:
-		ret = transport_generic_emulate_request_sense(cmd,
-				T_TASK(cmd)->t_task_cdb);
-		if (ret < 0)
-			return ret;
-		break;
-	case ALLOW_MEDIUM_REMOVAL:
-	case ERASE:
-	case REZERO_UNIT:
-	case SEEK_10:
-	case SPACE:
-	case START_STOP:
-	case SYNCHRONIZE_CACHE:
-	case TEST_UNIT_READY:
-	case VERIFY:
-	case WRITE_FILEMARKS:
-	case RESERVE:
-	case RESERVE_10:
-	case RELEASE:
-	case RELEASE_10:
-		break;
-	default:
-		printk(KERN_ERR "Unsupported SCSI Opcode: 0x%02x for"
-			" RAMDISKs\n", rd_req->rd_scsi_cdb[0]);
-		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
-	}
-
-	task->task_scsi_status = GOOD;
-	transport_complete_task(task, 1);
-
-	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
-}
-
 /*	rd_get_sg_table():
  *
  *
@@ -789,7 +711,7 @@ static int rd_MEMCPY_do_task(struct se_task *task)
 	int ret;
 
 	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
-		return rd_emulate_scsi_cdb(task);
+		return transport_emulate_control_cdb(task);
 
 	req->rd_lba = task->task_lba;
 	req->rd_page = (req->rd_lba * DEV_ATTRIB(dev)->block_size) / PAGE_SIZE;
@@ -1117,7 +1039,7 @@ static int rd_DIRECT_allocate_DMA(struct se_cmd *cmd, u32 length, u32 dma_size)
 static int rd_DIRECT_do_task(struct se_task *task)
 {
 	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
-		return rd_emulate_scsi_cdb(task);
+		return transport_emulate_control_cdb(task);
 
 	/*
 	 * At this point the locally allocated RD tables have been mapped
@@ -1535,12 +1457,21 @@ static struct se_subsystem_api rd_mcp_template = {
 	.write_pending		= NULL,
 };
 
+static struct se_subsystem_api_cdb rd_cdb_template = {
+	.emulate_inquiry	= rd_emulate_inquiry,
+	.emulate_read_cap	= rd_emulate_read_cap,
+	.emulate_read_cap16	= rd_emulate_read_cap16,
+	.emulate_unmap		= NULL,
+};
+
 int __init rd_module_init(void)
 {
 	int ret;
 
 	INIT_LIST_HEAD(&rd_dr_template.sub_api_list);
+	rd_dr_template.sub_cdb = &rd_cdb_template;
 	INIT_LIST_HEAD(&rd_mcp_template.sub_api_list);
+	rd_mcp_template.sub_cdb = &rd_cdb_template;
 
 	ret = transport_subsystem_register(&rd_dr_template, NULL);
 	if (ret < 0)
-- 
1.5.6.5

