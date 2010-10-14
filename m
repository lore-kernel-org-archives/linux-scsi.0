From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Convert UNMAP + WRITE_SAME_* to IBLOCK only support
Date: Wed, 13 Oct 2010 23:27:49 -0700
Message-ID: <1287037669-27870-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp105.sbc.mail.ac4.yahoo.com ([76.13.13.244]:37328 "HELO
	smtp105.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754757Ab0JNG14 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2010 02:27:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch series converts the existing transport_generic_unmap() and
transport_generic_write_same() code to be called directly from TCM code
using transport_emulate_control_cdb().  It also converts the primary
struct se_subsystem_api->do_discard() to accept an 'sector_t lba' and
'u32 range' that is passed from SCSI UNMAP/WRITE_SAME emulation down
to generic block level discard logic in TCM/IBLOCK.

This patch also makes emulate_tpu and emulate_tpws now disabled by default,
even when the underlying struct block_device supports Discard during IBLOCK
device creation.  This means that these two attrs will need to be enabled
on a per $HBA/$DEV/attrib/ basis to explictly activate SCSI UNMAP/WRITE_SAME
support.

Finally, this patch also drops the Generic Block Discard support in TCM/FILEIO
as there is really not a safe way to do this yet.

Thanks again to hch for his input on this item!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Reported-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_device.c    |   18 +++++
 drivers/target/target_core_file.c      |  127 +-------------------------------
 drivers/target/target_core_iblock.c    |   41 ++---------
 drivers/target/target_core_transport.c |   27 ++++---
 include/target/target_core_transport.h |    9 +--
 5 files changed, 43 insertions(+), 179 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 070da98..5364259 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1231,6 +1231,15 @@ int se_dev_set_emulate_tpu(struct se_device *dev, int flag)
 		printk(KERN_ERR "Illegal value %d\n", flag);
 		return -1;
 	}
+	/*
+	 * We expect this value to be non-zero when generic Block Layer
+	 * Discard supported is detected iblock_create_virtdevice().
+	 */
+	if (!(DEV_ATTRIB(dev)->max_unmap_block_desc_count)) {
+		printk(KERN_ERR "Generic Block Discard not supported\n");
+		return -ENOSYS;
+	}
+
 	DEV_ATTRIB(dev)->emulate_tpu = flag;
 	printk(KERN_INFO "dev[%p]: SE Device Thin Provisioning UNMAP bit: %d\n",
 				dev, flag);
@@ -1243,6 +1252,15 @@ int se_dev_set_emulate_tpws(struct se_device *dev, int flag)
 		printk(KERN_ERR "Illegal value %d\n", flag);
 		return -1;
 	}
+	/*
+	 * We expect this value to be non-zero when generic Block Layer
+	 * Discard supported is detected iblock_create_virtdevice().
+	 */
+	if (!(DEV_ATTRIB(dev)->max_unmap_block_desc_count)) {
+		printk(KERN_ERR "Generic Block Discard not supported\n");
+		return -ENOSYS;
+	}
+
 	DEV_ATTRIB(dev)->emulate_tpws = flag;
 	printk(KERN_INFO "dev[%p]: SE Device Thin Provisioning WRITE_SAME: %d\n",
 				dev, flag);
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 3a68932..6c3f9e5 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -235,32 +235,6 @@ static struct se_device *fd_create_virtdevice(
 
 	fd_dev->fd_dev_id = fd_host->fd_host_dev_id_count++;
 	fd_dev->fd_queue_depth = dev->queue_depth;
-	/*
-	 * Check for QUEUE_FLAG_DISCARD and enable TCM TPE emulation
-	 * if present for struct block_device backend
-	 */
-	if (S_ISBLK(inode->i_mode)) {
-		if (blk_queue_discard(bdev_get_queue(inode->i_bdev))) {
-			struct block_device *bd = inode->i_bdev;
-			struct request_queue *q = bdev_get_queue(bd);
-			
-			DEV_ATTRIB(dev)->max_unmap_lba_count =
-					q->limits.max_discard_sectors;
-			/*
-			 * Currently hardcoded to 1 in Linux/SCSI code..
-			 */
-			DEV_ATTRIB(dev)->max_unmap_block_desc_count = 1;
-			DEV_ATTRIB(dev)->unmap_granularity =
-					q->limits.discard_granularity;
-			DEV_ATTRIB(dev)->unmap_granularity_alignment =
-					q->limits.discard_alignment;
-
-			DEV_ATTRIB(dev)->emulate_tpu = 1;
-			DEV_ATTRIB(dev)->emulate_tpws = 1;
-			printk(KERN_INFO "FILEIO: Enabling BLOCK Discard"
-				" for TPU=1 and TPWS=1 emulation\n");
-		}
-	}
 
 	printk(KERN_INFO "CORE_FILE[%u] - Added TCM FILEIO Device ID: %u at %s,"
 		" %llu total bytes\n", fd_host->fd_host_id, fd_dev->fd_dev_id,
@@ -358,91 +332,6 @@ static void *fd_allocate_request(
 	return (void *)fd_req;
 }
 
-static int fd_emulate_unmap(struct se_task *task)
-{
-	struct se_cmd *cmd = TASK_CMD(task);
-	struct fd_dev *fd_dev = task->se_dev->dev_ptr;
-	struct file *f = fd_dev->fd_file;
-	struct inode *i;
-	struct block_device *bd;
-	int ret;
-
-	i = igrab(f->f_mapping->host);
-	if (!(i)) {
-		printk(KERN_ERR "FILEIO: Unable to locate inode for"
-				" backend for UNMAP\n");
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-	}
-	/*
-	 * Currently for struct file w/o a struct block_device
-	 * backend we return a success..
-	 */	
-	if (!(S_ISBLK(i->i_mode))) {
-		printk(KERN_WARNING "Ignoring UNMAP for non BD"
-				" backend for struct file\n");
-		iput(i);
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-	}
-	bd = I_BDEV(f->f_mapping->host);
-	if (!(bd)) {
-		printk(KERN_ERR "FILEIO: Unable to locate struct"
-				" block_device for UNMAP\n");
-		iput(i);
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-	}
-	/*
-	 * Now call the transport_generic_unmap() -> blkdev_issue_discard()
-	 * wrapper to translate SCSI UNMAP into Linux/BLOCK discards on
-	 * LBA+Range descriptors in the UNMAP write paylaod.
-	 */
-	ret = transport_generic_unmap(cmd, bd);
-	iput(i);
-
-	return ret;
-}
-
-static int fd_emulate_write_same_unmap(struct se_task *task)
-{
-	struct se_cmd *cmd = TASK_CMD(task);
-	struct fd_dev *fd_dev = task->se_dev->dev_ptr;
-	struct file *f = fd_dev->fd_file;
-	struct inode *i;
-	struct block_device *bd;
-	int ret;
-
-	i = igrab(f->f_mapping->host);
-	if (!(i)) {
-		printk(KERN_ERR "FILEIO: Unable to locate inode for"
-				" backend for WRITE_SAME\n");
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-	}
-	/*
-	 * Currently for struct file w/o a struct block_device
-	 * backend we return a success..
-	 */
-	if (!(S_ISBLK(i->i_mode))) {
-		printk(KERN_WARNING "Ignoring WRITE_SAME for non BD"
-				" backend for struct file\n");
-		iput(i);
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-	}
-	bd = I_BDEV(f->f_mapping->host);
-	if (!(bd)) {
-		printk(KERN_ERR "FILEIO: Unable to locate struct"
-				" block_device for WRITE_SAME\n");
-		iput(i);
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-	}
-	ret = transport_generic_write_same(cmd, bd);
-	iput(i);
-	if (ret < 0)
-		return ret;
-
-	task->task_scsi_status = GOOD;
-	transport_complete_task(task, 1);
-	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
-}
-
 static inline int fd_iovec_alloc(struct fd_request *req)
 {
 	req->fd_iovs = kzalloc(sizeof(struct iovec) * req->fd_sg_count,
@@ -774,20 +663,6 @@ static int fd_do_task(struct se_task *task)
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 }
 
-static int fd_do_discard(struct se_task *task, enum blk_discard_type type)
-{
-	if (type == DISCARD_UNMAP)
-		return fd_emulate_unmap(task);
-	else if (type == DISCARD_WRITE_SAME_UNMAP)
-		return fd_emulate_write_same_unmap(task);
-	else {
-		printk(KERN_ERR "Unsupported discard_type_t: %d\n", type);
-		return -ENOSYS;
-	}
-
-	return -ENOSYS;
-}
-
 /*	fd_free_task(): (Part of se_subsystem_api_t template)
  *
  *
@@ -1172,7 +1047,7 @@ static struct se_subsystem_api fileio_template = {
 	.transport_complete	= fd_transport_complete,
 	.allocate_request	= fd_allocate_request,
 	.do_task		= fd_do_task,
-	.do_discard		= fd_do_discard,
+	.do_discard		= NULL,
 	.do_sync_cache		= fd_emulate_sync_cache,
 	.free_task		= fd_free_task,
 	.check_configfs_dev_params = fd_check_configfs_dev_params,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index e740265..463f992 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -213,10 +213,8 @@ static struct se_device *iblock_create_virtdevice(
 		DEV_ATTRIB(dev)->unmap_granularity_alignment =
 				q->limits.discard_alignment;
 
-		DEV_ATTRIB(dev)->emulate_tpu = 1;
-		DEV_ATTRIB(dev)->emulate_tpws = 1;
-		printk(KERN_INFO "IBLOCK: Enabling BLOCK Discard support"
-				" for TPU=1 and TPWS=1 emulation\n");
+		printk(KERN_INFO "IBLOCK: BLOCK Discard support available,"
+				" disabled by default\n");
 	}
 
 	return dev;
@@ -392,22 +390,6 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 	return blocks_long;
 }
 
-static int iblock_emulate_write_same_unmap(struct se_task *task)
-{
-	struct iblock_dev *ibd = task->se_dev->dev_ptr;
-	struct block_device *bd = ibd->ibd_bd;
-	struct se_cmd *cmd = TASK_CMD(task);
-	int ret;
-
-	ret = transport_generic_write_same(cmd, bd);
-	if (ret < 0)
-		return ret;
-
-	task->task_scsi_status = GOOD;
-	transport_complete_task(task, 1);
-	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
-}
-
 static int __iblock_do_sync_cache(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = (struct iblock_dev *)dev->dev_ptr;
@@ -532,22 +514,13 @@ static int iblock_do_task(struct se_task *task)
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 }
 
-static int iblock_do_discard(struct se_task *task, enum blk_discard_type type)
+static int iblock_do_discard(struct se_device *dev, sector_t lba, u32 range)
 {
-	struct iblock_dev *ibd = task->se_dev->dev_ptr;
+	struct iblock_dev *ibd = dev->dev_ptr;
 	struct block_device *bd = ibd->ibd_bd;
-	struct se_cmd *cmd = TASK_CMD(task);
-
-	if (type == DISCARD_UNMAP)
-		return transport_generic_unmap(cmd, bd);	
-	else if (type == DISCARD_WRITE_SAME_UNMAP)
-		return iblock_emulate_write_same_unmap(task);	
-	else {
-		printk(KERN_ERR "Unsupported discard_type_t: %d\n", type);
-		return -ENOSYS;
-	}
-
-	return -ENOSYS;
+	int barrier = 0;
+	
+	return blkdev_issue_discard(bd, lba, range, GFP_KERNEL, barrier);
 }
 
 static void iblock_free_task(struct se_task *task)
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4a30fb9..44376a3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5475,14 +5475,15 @@ int transport_get_sense_data(struct se_cmd *cmd)
  * Used for TCM/IBLOCK and TCM/FILEIO for block/blk-lib.c level discard support.
  * Note this is not used for TCM/pSCSI passthrough
  */
-int transport_generic_unmap(struct se_cmd *cmd, struct block_device *bdev)
+static int transport_generic_unmap(struct se_task *task)
 {
+	struct se_cmd *cmd = TASK_CMD(task);
 	struct se_device *dev = SE_DEV(cmd);
 	unsigned char *buf = T_TASK(cmd)->t_task_buf, *ptr = NULL;
 	unsigned char *cdb = &T_TASK(cmd)->t_task_cdb[0];
 	sector_t lba;
 	unsigned int size = cmd->data_length, range;
-	int barrier = 0, ret, offset = 8; /* First UNMAP block descriptor starts at 8 byte offset */
+	int ret, offset = 8; /* First UNMAP block descriptor starts at 8 byte offset */
 	unsigned short dl, bd_dl;
 
 	/* Skip over UNMAP header */
@@ -5499,7 +5500,7 @@ int transport_generic_unmap(struct se_cmd *cmd, struct block_device *bdev)
 		printk(KERN_INFO "UNMAP: Using lba: %llu and range: %u\n",
                 (unsigned long long)lba, range);
 
-		ret = blkdev_issue_discard(bdev, lba, range, GFP_KERNEL, barrier);
+		ret = TRANSPORT(dev)->do_discard(dev, lba, range);
 		if (ret < 0) {
 			printk(KERN_ERR "blkdev_issue_discard() failed: %d\n", ret);
 			return -1;
@@ -5509,20 +5510,22 @@ int transport_generic_unmap(struct se_cmd *cmd, struct block_device *bdev)
 		size -= 16;
 	}
 
+	task->task_scsi_status = GOOD;
+	transport_complete_task(task, 1);
 	return 0;
 }
-EXPORT_SYMBOL(transport_generic_unmap);
 
 /*
  * Used for TCM/IBLOCK and TCM/FILEIO for block/blk-lib.c level discard support.
  * Note this is not used for TCM/pSCSI passthrough
  */
-int transport_generic_write_same(struct se_cmd *cmd, struct block_device *bdev)
+static int transport_generic_write_same(struct se_task *task)
 {
+	struct se_cmd *cmd = TASK_CMD(task);
 	struct se_device *dev = SE_DEV(cmd);
 	sector_t lba;
 	unsigned int range;
-	int barrier = 0, ret;
+	int ret;
 
 	lba = T_TASK(cmd)->t_task_lba;
 	range = (cmd->data_length / TRANSPORT(dev)->get_blocksize(dev));
@@ -5530,14 +5533,16 @@ int transport_generic_write_same(struct se_cmd *cmd, struct block_device *bdev)
 	printk(KERN_INFO "WRITE_SAME UNMAP: LBA: %llu Range: %u\n",
                 (unsigned long long)lba, range);
 
-	ret = blkdev_issue_discard(bdev, lba, range, GFP_KERNEL, barrier);
+	ret = TRANSPORT(dev)->do_discard(dev, lba, range);
 	if (ret < 0) {
 		printk(KERN_INFO "blkdev_issue_discard() failed for WRITE_SAME\n");
 		return -1;
 	}
+
+	task->task_scsi_status = GOOD;
+	transport_complete_task(task, 1);
 	return 0;
 }
-EXPORT_SYMBOL(transport_generic_write_same);
 
 /*
  * Used by TCM subsystem plugins IBLOCK, FILEIO, and RAMDISK as a
@@ -5610,7 +5615,7 @@ int transport_emulate_control_cdb(struct se_task *task)
 					TRANSPORT(dev)->name);
 			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 		}
-		ret = TRANSPORT(dev)->do_discard(task, DISCARD_UNMAP);
+		ret = transport_generic_unmap(task);
 		if (ret < 0)
 			return ret;
 		break;
@@ -5620,7 +5625,7 @@ int transport_emulate_control_cdb(struct se_task *task)
 					" for: %s\n", TRANSPORT(dev)->name);
 			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 		}
-		ret = TRANSPORT(dev)->do_discard(task, DISCARD_WRITE_SAME_UNMAP);
+		ret = transport_generic_write_same(task);
 		if (ret < 0)
 			return ret;
 		break;
@@ -5633,7 +5638,7 @@ int transport_emulate_control_cdb(struct se_task *task)
 					" supported for: %s\n", TRANSPORT(dev)->name);
 				return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 			}
-			ret = TRANSPORT(dev)->do_discard(task, DISCARD_WRITE_SAME_UNMAP);
+			ret = transport_generic_write_same(task);
 			if (ret < 0)
 				return ret;
 			break;
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 1f29cf3..c156098 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -127,11 +127,6 @@
 
 #define MOD_MAX_SECTORS(ms, bs)			(ms % (PAGE_SIZE / bs))
 
-enum blk_discard_type {
-	DISCARD_UNMAP,
-	DISCARD_WRITE_SAME_UNMAP,
-};
-
 struct se_mem;
 struct se_subsystem_api;
 
@@ -243,8 +238,6 @@ extern int transport_generic_emulate_modesense(struct se_cmd *,
 extern int transport_generic_emulate_request_sense(struct se_cmd *,
 						   unsigned char *);
 extern int transport_get_sense_data(struct se_cmd *);
-extern int transport_generic_unmap(struct se_cmd *, struct block_device *);
-extern int transport_generic_write_same(struct se_cmd *, struct block_device *);
 extern int transport_emulate_control_cdb(struct se_task *);
 extern struct se_cmd *transport_allocate_passthrough(unsigned char *, int, u32,
 						void *, u32, u32, void *);
@@ -471,7 +464,7 @@ struct se_subsystem_api {
 	 * Used by virtual subsystem plugins IBLOCK and FILEIO to emulate
 	 * UNMAP and WRITE_SAME_* w/ UNMAP=1 <-> Linux/Block Discard
 	 */
-	int (*do_discard)(struct se_task *, enum blk_discard_type);
+	int (*do_discard)(struct se_device *, sector_t, u32);
 	/*
 	 * Used  by virtual subsystem plugins IBLOCK and FILEIO to emulate
 	 * SYNCHRONIZE_CACHE_* <-> Linux/Block blkdev_issue_flush()
-- 
1.5.6.5

