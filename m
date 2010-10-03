From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] tcm/iblock,fileio: Add WRITE_SAME_16 w/ UNMAP=1 bit support
Date: Sat,  2 Oct 2010 17:53:49 -0700
Message-ID: <1286067229-14492-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:30568 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752361Ab0JCAxx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Oct 2010 20:53:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates TCM/IBLOCK and TCM/FILEIO code to support WRITE_SAME_16
w/ UNMAP=1 bit emulation following generic Block Discards support using
blk_issue_discard().  This includes setting DEV_ATTRIB(dev)->emulate_tpws=1
in [iblock,fd]_create_virtdevice() callers with blk_queue_discard()==1, and
the individual [iblock,fd]_emulate_write_same_unmap() to locate struct block_device,
and call the generic transport_generic_write_same() symbol from TCM Core.

So far this patch has been tested using 'sg_write_same -S' from TCM_Loop ->
IBLOCK+FILEIO -> scsi_debug LUNs.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c   |   47 ++++++++++++++++++++++++++++++++++-
 drivers/target/target_core_iblock.c |   21 +++++++++++++++-
 2 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 15f7847..1215f3c 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -256,8 +256,9 @@ static struct se_device *fd_create_virtdevice(
 					q->limits.discard_alignment;
 
 			DEV_ATTRIB(dev)->emulate_tpu = 1;
+			DEV_ATTRIB(dev)->emulate_tpws = 1;
 			printk(KERN_INFO "FILEIO: Enabling BLOCK Discard"
-				" and TPU=1 emulation\n");
+				" for TPU=1 and TPWS=1 emulation\n");
 		}
 	}
 
@@ -525,6 +526,48 @@ static int fd_emulate_scsi_cdb(struct se_task *task)
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 }
 
+static int fd_emulate_write_same_unmap(struct se_task *task)
+{
+	struct se_cmd *cmd = TASK_CMD(task);
+	struct fd_dev *fd_dev = task->se_dev->dev_ptr;
+	struct file *f = fd_dev->fd_file;
+	struct inode *i;
+	struct block_device *bd;
+	int ret;
+
+	i = igrab(f->f_mapping->host);
+	if (!(i)) {
+		printk(KERN_ERR "FILEIO: Unable to locate inode for"
+				" backend for WRITE_SAME\n");
+		return PYX_TRANSPORT_LU_COMM_FAILURE;
+	}
+	/*
+	 * Currently for struct file w/o a struct block_device
+	 * backend we return a success..
+	 */
+	if (!(S_ISBLK(i->i_mode))) {
+		printk(KERN_WARNING "Ignoring WRITE_SAME for non BD"
+				" backend for struct file\n");
+		iput(i);
+		return PYX_TRANSPORT_LU_COMM_FAILURE;
+	}
+	bd = I_BDEV(f->f_mapping->host);
+	if (!(bd)) {
+		printk(KERN_ERR "FILEIO: Unable to locate struct"
+				" block_device for WRITE_SAME\n");
+		iput(i);
+		return PYX_TRANSPORT_LU_COMM_FAILURE;
+	}
+	ret = transport_generic_write_same(cmd, bd);
+	iput(i);
+	if (ret < 0)
+		return ret;
+
+	task->task_scsi_status = GOOD;
+	transport_complete_task(task, 1);
+	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
+}
+
 static inline int fd_iovec_alloc(struct fd_request *req)
 {
 	req->fd_iovs = kzalloc(sizeof(struct iovec) * req->fd_sg_count,
@@ -814,6 +857,8 @@ static int fd_do_task(struct se_task *task)
 
 	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
 		return fd_emulate_scsi_cdb(task);
+	else if (T_TASK(cmd)->t_tasks_unmap)
+		return fd_emulate_write_same_unmap(task);
 
 	req->fd_lba = task->task_lba;
 	req->fd_size = task->task_size;
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index dc96fcf..44d54a6 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -241,8 +241,9 @@ static struct se_device *iblock_create_virtdevice(
 				q->limits.discard_alignment;
 
 		DEV_ATTRIB(dev)->emulate_tpu = 1;
+		DEV_ATTRIB(dev)->emulate_tpws = 1;
 		printk(KERN_INFO "IBLOCK: Enabling BLOCK Discard support"
-				" and TPU=1 emulation\n");
+				" for TPU=1 and TPWS=1 emulation\n");
 	}
 
 	return dev;
@@ -547,6 +548,22 @@ static int iblock_emulate_scsi_cdb(struct se_task *task)
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 }
 
+static int iblock_emulate_write_same_unmap(struct se_task *task)
+{
+	struct iblock_dev *ibd = task->se_dev->dev_ptr;
+	struct block_device *bd = ibd->ibd_bd;
+	struct se_cmd *cmd = TASK_CMD(task);
+	int ret;
+
+	ret = transport_generic_write_same(cmd, bd);
+	if (ret < 0)
+		return ret;
+
+	task->task_scsi_status = GOOD;
+	transport_complete_task(task, 1);
+	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
+}
+
 static int __iblock_do_sync_cache(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = (struct iblock_dev *)dev->dev_ptr;
@@ -638,6 +655,8 @@ static int iblock_do_task(struct se_task *task)
 
 	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
 		return iblock_emulate_scsi_cdb(task);
+	else if (T_TASK(task->task_se_cmd)->t_tasks_unmap)
+		return iblock_emulate_write_same_unmap(task);
 
 	while (bio) {
 		nbio = bio->bi_next;
-- 
1.5.6.5

