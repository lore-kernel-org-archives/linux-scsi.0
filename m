From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] tcm/fileio: Add UNMAP / Block DISCARD support
Date: Mon, 27 Sep 2010 15:51:49 -0700
Message-ID: <1285627910-6492-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.re3.yahoo.com ([66.196.96.85]:36076 "HELO
	smtp102.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760431Ab0I0Wvz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 18:51:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds UNMAP emulation support using Block layer DISCARD in fd_emulate_scsi_cdb()
-> transport_generic_unmap().  This includes the use of blk_queue_discard() in
fd_create_virtdevice() to determine when to set DEV_ATTRIB(dev)->emulate_tpe=1 to
signal to TCM Core to perform the necessary control CDB emulation for TPE=1 / UNMAP.

Note this patch igrab() + iput() when accessing struct block_device via
I_BDEV(file->f_mapping->host) that is required for transport_generic_unmap()
within fd_emulate_scsi_cdb().

Also note that when (S_ISBLK(inode->i_mode) is NULL, the TPE=1 and UNMAP emulation
are disabled for non BD struct file I/O.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c |   53 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 93d3f63..3b91556 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -235,6 +235,17 @@ static struct se_device *fd_create_virtdevice(
 
 	fd_dev->fd_dev_id = fd_host->fd_host_dev_id_count++;
 	fd_dev->fd_queue_depth = dev->queue_depth;
+	/*
+	 * Check for QUEUE_FLAG_DISCARD and enable TCM TPE emulation
+	 * if present for struct block_device backend
+	 */
+	if (S_ISBLK(inode->i_mode)) {
+		if (blk_queue_discard(bdev_get_queue(inode->i_bdev))) {
+			DEV_ATTRIB(dev)->emulate_tpe = 1;
+			printk(KERN_INFO "FILEIO: Enabling BLOCK Discard"
+				" and TPE=1 emulation\n");
+		}
+	}
 
 	printk(KERN_INFO "CORE_FILE[%u] - Added TCM FILEIO Device ID: %u at %s,"
 		" %llu total bytes\n", fd_host->fd_host_id, fd_dev->fd_dev_id,
@@ -388,9 +399,13 @@ static int fd_emulate_read_cap16(struct se_task *task)
  */
 static int fd_emulate_scsi_cdb(struct se_task *task)
 {
-	int ret;
 	struct se_cmd *cmd = TASK_CMD(task);
+	struct fd_dev *fd_dev = (struct fd_dev *) task->se_dev->dev_ptr;
 	struct fd_request *fd_req = (struct fd_request *) task->transport_req;
+	struct file *f = fd_dev->fd_file;
+	struct inode *i;
+	struct block_device *bd;
+	int ret;
 
 	switch (fd_req->fd_scsi_cdb[0]) {
 	case INQUIRY:
@@ -433,6 +448,42 @@ static int fd_emulate_scsi_cdb(struct se_task *task)
 		if (ret < 0)
 			return ret;
 		break;
+	case UNMAP:
+		i = igrab(f->f_mapping->host);
+		if (!(i)) {
+			printk(KERN_ERR "FILEIO: Unable to locate inode for"
+					" backend for UNMAP\n");
+			return PYX_TRANSPORT_LU_COMM_FAILURE;
+		}
+		/*
+		 * Currently for struct file w/o a struct block_device
+		 * backend we return a success..
+		 */	
+		if (!(S_ISBLK(i->i_mode))) {
+			printk(KERN_WARNING "Ignoring UNMAP for non BD"
+					" backend for struct file\n");
+			iput(i);
+			return PYX_TRANSPORT_LU_COMM_FAILURE;
+		}
+		bd = I_BDEV(f->f_mapping->host);
+		if (!(bd)) {
+			printk(KERN_ERR "FILEIO: Unable to locate struct"
+					" block_device for UNMAP\n");
+			iput(i);
+			return PYX_TRANSPORT_LU_COMM_FAILURE;
+		}
+		/*
+		 * Now call the transport_generic_unmap() -> blkdev_issue_discard()
+		 * wrapper to translate SCSI UNMAP into Linux/BLOCK discards on
+		 * LBA+Range descriptors in the UNMAP write paylaod.
+		 */
+		ret = transport_generic_unmap(cmd, bd);
+		if (ret < 0) {
+			iput(i);
+			return ret;
+		}
+		iput(i);
+		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case ERASE:
 	case REZERO_UNIT:
-- 
1.5.6.5

