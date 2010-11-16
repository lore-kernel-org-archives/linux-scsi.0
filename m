From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] target: simplify se_task mapping
Date: Tue, 16 Nov 2010 12:38:02 -0500
Message-ID: <20101116173802.GA13716@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40643 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab0KPRiE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2010 12:38:04 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

Instead of having separate methods for mapping read/write CDBs
add a data_direction member to struct se_task abd unify the code
in the backends.  Also remove all kinds of unused copies of the
task state in the backend-specific task structures.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/target_core_file.c
===================================================================
--- lio-core.orig/drivers/target/target_core_file.c	2010-11-16 10:33:03.117004333 +0100
+++ lio-core/drivers/target/target_core_file.c	2010-11-16 12:26:05.116254863 +0100
@@ -304,41 +304,30 @@ fd_alloc_task(struct se_cmd *cmd)
 	return &fd_req->fd_task;
 }
 
-static inline int fd_iovec_alloc(struct fd_request *req)
-{
-	req->fd_iovs = kzalloc(sizeof(struct iovec) * req->fd_sg_count,
-				GFP_KERNEL);
-	if (!(req->fd_iovs)) {
-		printk(KERN_ERR "Unable to allocate req->fd_iovs\n");
-		return -1;
-	}
-
-	return 0;
-}
-
-static int fd_do_readv(struct fd_request *req, struct se_task *task)
+static int fd_do_readv(struct se_task *task)
 {
+	struct fd_request *req = FILE_REQ(task);
 	struct file *fd = req->fd_dev->fd_file;
 	struct scatterlist *sg = task->task_sg;
 	struct iovec *iov;
 	mm_segment_t old_fs;
-	loff_t pos = (req->fd_lba * DEV_ATTRIB(task->se_dev)->block_size);
+	loff_t pos = (task->task_lba * DEV_ATTRIB(task->se_dev)->block_size);
 	int ret = 0, i;
 
-	iov = kzalloc(sizeof(struct iovec) * req->fd_sg_count, GFP_KERNEL);
+	iov = kzalloc(sizeof(struct iovec) * task->task_sg_num, GFP_KERNEL);
 	if (!(iov)) {
 		printk(KERN_ERR "Unable to allocate fd_do_readv iov[]\n");
 		return -1;
 	}
 
-	for (i = 0; i < req->fd_sg_count; i++) {
+	for (i = 0; i < task->task_sg_num; i++) {
 		iov[i].iov_len = sg[i].length;
 		iov[i].iov_base = sg_virt(&sg[i]);
 	}
 
 	old_fs = get_fs();
 	set_fs(get_ds());
-	ret = vfs_readv(fd, &iov[0], req->fd_sg_count, &pos);
+	ret = vfs_readv(fd, &iov[0], task->task_sg_num, &pos);
 	set_fs(old_fs);
 
 	kfree(iov);
@@ -348,10 +337,10 @@ static int fd_do_readv(struct fd_request
 	 * block_device.
 	 */
 	if (S_ISBLK(fd->f_dentry->d_inode->i_mode)) {
-		if (ret < 0 || ret != req->fd_size) {
+		if (ret < 0 || ret != task->task_size) {
 			printk(KERN_ERR "vfs_readv() returned %d,"
 				" expecting %d for S_ISBLK\n", ret,
-				(int)req->fd_size);
+				(int)task->task_size);
 			return -1;
 		}
 	} else {
@@ -365,98 +354,35 @@ static int fd_do_readv(struct fd_request
 	return 1;
 }
 
-#if 0
-
-static void fd_sendfile_free_DMA(struct se_cmd *cmd)
-{
-	printk(KERN_INFO "Release reference to pages now..\n");
-}
-
-static static int fd_sendactor(
-	read_descriptor_t *desc,
-	struct page *page,
-	unsigned long offset,
-	unsigned long size)
+static int fd_do_writev(struct se_task *task)
 {
-	unsigned long count = desc->count;
-	struct se_task *task = desc->arg.data;
 	struct fd_request *req = FILE_REQ(task);
-	struct scatterlist *sg = task->task_sg;
-
-	printk(KERN_INFO "page: %p offset: %lu size: %lu\n", page,
-			offset, size);
-
-	__free_page(sg[req->fd_cur_offset].page);
-
-	printk(KERN_INFO "page_address(page): %p\n", page_address(page));
-	sg[req->fd_cur_offset].page = page;
-	sg[req->fd_cur_offset].offset = offset;
-	sg[req->fd_cur_offset].length = size;
-
-	printk(KERN_INFO "sg[%d:%p].page %p length: %d\n", req->fd_cur_offset,
-		&sg[req->fd_cur_offset], sg[req->fd_cur_offset].page,
-		sg[req->fd_cur_offset].length);
-
-	req->fd_cur_size += size;
-	printk(KERN_INFO "fd_cur_size: %u\n", req->fd_cur_size);
-
-	req->fd_cur_offset++;
-
-	desc->count--;
-	desc->written += size;
-	return size;
-}
-
-static int fd_do_sendfile(struct fd_request *req, struct se_task *task)
-{
-	int ret = 0;
-	struct file *fd = req->fd_dev->fd_file;
-
-	if (fd_seek(fd, req->fd_lba, DEV_ATTRIB(task->se_dev)->block_size) < 0)
-		return -1;
-
-	TASK_CMD(task)->transport_free_DMA = &fd_sendfile_free_DMA;
-
-	ret = fd->f_op->sendfile(fd, &fd->f_pos, req->fd_sg_count,
-			fd_sendactor, (void *)task);
-
-	if (ret < 0) {
-		printk(KERN_ERR "fd->f_op->sendfile() returned %d\n", ret);
-		return -1;
-	}
-
-	return 1;
-}
-#endif
-
-static int fd_do_writev(struct fd_request *req, struct se_task *task)
-{
 	struct file *fd = req->fd_dev->fd_file;
 	struct scatterlist *sg = task->task_sg;
 	struct iovec *iov;
 	mm_segment_t old_fs;
-	loff_t pos = (req->fd_lba * DEV_ATTRIB(task->se_dev)->block_size);
+	loff_t pos = (task->task_lba * DEV_ATTRIB(task->se_dev)->block_size);
 	int ret, i = 0;
 
-	iov = kzalloc(sizeof(struct iovec) * req->fd_sg_count, GFP_KERNEL);
+	iov = kzalloc(sizeof(struct iovec) * task->task_sg_num, GFP_KERNEL);
 	if (!(iov)) {
 		printk(KERN_ERR "Unable to allocate fd_do_writev iov[]\n");
 		return -1;
 	}
 
-	for (i = 0; i < req->fd_sg_count; i++) {
+	for (i = 0; i < task->task_sg_num; i++) {
 		iov[i].iov_len = sg[i].length;
 		iov[i].iov_base = sg_virt(&sg[i]);
 	}
 
 	old_fs = get_fs();
 	set_fs(get_ds());
-	ret = vfs_writev(fd, &iov[0], req->fd_sg_count, &pos);
+	ret = vfs_writev(fd, &iov[0], task->task_sg_num, &pos);
 	set_fs(old_fs);
 
 	kfree(iov);
 
-	if (ret < 0 || ret != req->fd_size) {
+	if (ret < 0 || ret != task->task_size) {
 		printk(KERN_ERR "vfs_writev() returned %d\n", ret);
 		return -1;
 	}
@@ -553,31 +479,21 @@ static int fd_do_task(struct se_task *ta
 {
 	struct se_cmd *cmd = task->task_se_cmd;
 	struct se_device *dev = cmd->se_dev;
-	struct fd_request *req = FILE_REQ(task);
 	int ret = 0;
 
-	req->fd_lba = task->task_lba;
-	req->fd_size = task->task_size;
 	/*
 	 * Call vectorized fileio functions to map struct scatterlist
 	 * physical memory addresses to struct iovec virtual memory.
 	 */
-	if (req->fd_data_direction == FD_DATA_READ)
-		ret = fd_do_readv(req, task);
-	else
-		ret = fd_do_writev(req, task);
-
-	if (ret < 0)
-		return ret;
+	if (task->task_data_direction == DMA_FROM_DEVICE) {
+		ret = fd_do_readv(task);
+	} else {
+		ret = fd_do_writev(task);
 
-	if (ret) {
-		/*
-		 * Check for Forced Unit Access WRITE emulation
-		 */
-		if ((DEV_ATTRIB(dev)->emulate_write_cache > 0) &&
-		    (DEV_ATTRIB(dev)->emulate_fua_write > 0) &&
-		    (req->fd_data_direction == FD_DATA_WRITE) &&
-		    (T_TASK(cmd)->t_tasks_fua)) {
+		if (ret > 0 &&
+		    DEV_ATTRIB(dev)->emulate_write_cache > 0 &&
+		    DEV_ATTRIB(dev)->emulate_fua_write > 0 &&
+		    T_TASK(cmd)->t_tasks_fua) {
 			/*
 			 * We might need to be a bit smarter here
 			 * and return some sense data to let the initiator
@@ -586,10 +502,14 @@ static int fd_do_task(struct se_task *ta
 			fd_emulate_write_fua(cmd, task);
 		}
 
+	}
+
+	if (ret < 0)
+		return ret;
+	if (ret) {
 		task->task_scsi_status = GOOD;
 		transport_complete_task(task, 1);
 	}
-
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 }
 
@@ -601,7 +521,6 @@ static void fd_free_task(struct se_task
 {
 	struct fd_request *req = FILE_REQ(task);
 
-	kfree(req->fd_iovs);
 	kfree(req);
 }
 
@@ -722,105 +641,6 @@ static ssize_t fd_show_configfs_dev_para
 	return bl;
 }
 
-/*	fd_map_task_non_SG():
- *
- *
- */
-static void fd_map_task_non_SG(struct se_task *task)
-{
-	struct se_cmd *cmd = TASK_CMD(task);
-	struct fd_request *req = FILE_REQ(task);
-
-	req->fd_bufflen		= task->task_size;
-	req->fd_buf		= (void *) T_TASK(cmd)->t_task_buf;
-	req->fd_sg_count	= 0;
-}
-
-/*	fd_map_task_SG():
- *
- *
- */
-static void fd_map_task_SG(struct se_task *task)
-{
-	struct fd_request *req = FILE_REQ(task);
-
-	req->fd_bufflen		= task->task_size;
-	req->fd_buf		= NULL;
-	req->fd_sg_count	= task->task_sg_num;
-}
-
-/*      fd_CDB_none():
- *
- *
- */
-static int fd_CDB_none(struct se_task *task, u32 size)
-{
-	struct fd_request *req = FILE_REQ(task);
-
-	req->fd_data_direction	= FD_DATA_NONE;
-	req->fd_bufflen		= 0;
-	req->fd_sg_count	= 0;
-	req->fd_buf		= NULL;
-
-	return 0;
-}
-
-/*	fd_CDB_read_non_SG():
- *
- *
- */
-static int fd_CDB_read_non_SG(struct se_task *task, u32 size)
-{
-	struct fd_request *req = FILE_REQ(task);
-
-	req->fd_data_direction = FD_DATA_READ;
-	fd_map_task_non_SG(task);
-
-	return 0;
-}
-
-/*	fd_CDB_read_SG):
- *
- *
- */
-static int fd_CDB_read_SG(struct se_task *task, u32 size)
-{
-	struct fd_request *req = FILE_REQ(task);
-
-	req->fd_data_direction = FD_DATA_READ;
-	fd_map_task_SG(task);
-
-	return req->fd_sg_count;
-}
-
-/*	fd_CDB_write_non_SG():
- *
- *
- */
-static int fd_CDB_write_non_SG(struct se_task *task, u32 size)
-{
-	struct fd_request *req = FILE_REQ(task);
-
-	req->fd_data_direction = FD_DATA_WRITE;
-	fd_map_task_non_SG(task);
-
-	return 0;
-}
-
-/*	fd_CDB_write_SG():
- *
- *
- */
-static int fd_CDB_write_SG(struct se_task *task, u32 size)
-{
-	struct fd_request *req = FILE_REQ(task);
-
-	req->fd_data_direction = FD_DATA_WRITE;
-	fd_map_task_SG(task);
-
-	return req->fd_sg_count;
-}
-
 /*	fd_check_lba():
  *
  *
@@ -830,17 +650,6 @@ static int fd_check_lba(unsigned long lo
 	return 0;
 }
 
-/*	fd_check_for_SG(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static int fd_check_for_SG(struct se_task *task)
-{
-	struct fd_request *req = FILE_REQ(task);
-
-	return req->fd_sg_count;
-}
-
 /*	fd_get_cdb(): (Part of se_subsystem_api_t template)
  *
  *
@@ -895,11 +704,6 @@ static struct se_subsystem_api fileio_te
 	.transport_type		= TRANSPORT_PLUGIN_VHBA_PDEV,
 	.attach_hba		= fd_attach_hba,
 	.detach_hba		= fd_detach_hba,
-	.cdb_none		= fd_CDB_none,
-	.cdb_read_non_SG	= fd_CDB_read_non_SG,
-	.cdb_read_SG		= fd_CDB_read_SG,
-	.cdb_write_non_SG	= fd_CDB_write_non_SG,
-	.cdb_write_SG		= fd_CDB_write_SG,
 	.allocate_virtdevice	= fd_allocate_virtdevice,
 	.create_virtdevice	= fd_create_virtdevice,
 	.free_device		= fd_free_device,
@@ -918,7 +722,6 @@ static struct se_subsystem_api fileio_te
 	.get_plugin_info	= fd_get_plugin_info,
 	.get_hba_info		= fd_get_hba_info,
 	.check_lba		= fd_check_lba,
-	.check_for_SG		= fd_check_for_SG,
 	.get_cdb		= fd_get_cdb,
 	.get_device_rev		= fd_get_device_rev,
 	.get_device_type	= fd_get_device_type,
Index: lio-core/drivers/target/target_core_file.h
===================================================================
--- lio-core.orig/drivers/target/target_core_file.h	2010-11-16 10:33:03.125004403 +0100
+++ lio-core/drivers/target/target_core_file.h	2010-11-16 10:34:05.928032340 +0100
@@ -11,10 +11,6 @@
 #define FD_BLOCKSIZE		512
 #define FD_MAX_SECTORS		1024
 
-#define FD_DATA_READ		1
-#define FD_DATA_WRITE		2
-#define FD_DATA_NONE		3
-
 extern struct se_global *se_global;
 
 #define RRF_EMULATE_CDB		0x01
@@ -24,26 +20,6 @@ struct fd_request {
 	struct se_task	fd_task;
 	/* SCSI CDB from iSCSI Command PDU */
 	unsigned char	fd_scsi_cdb[TCM_MAX_COMMAND_SIZE];
-	/* Data Direction */
-	u8		fd_data_direction;
-	/* Total length of request */
-	u32		fd_bufflen;
-	/* RD request flags */
-	u32		fd_req_flags;
-	/* Offset from start of page */
-	u32		fd_offset;
-	u32		fd_cur_size;
-	u32		fd_cur_offset;
-	/* Scatterlist count */
-	u32		fd_sg_count;
-	/* Logical Block Address */
-	unsigned long long	fd_lba;
-	u64		fd_size;
-	struct kiocb	fd_iocb;
-	struct iovec	*fd_iovs;
-	/* Data buffer containing scatterlists(s) or contingous
-	   memory segments */
-	void		*fd_buf;
 	/* FILEIO device */
 	struct fd_dev	*fd_dev;
 } ____cacheline_aligned;
@@ -65,8 +41,6 @@ struct fd_dev {
 	struct file	*fd_file;
 	/* FILEIO HBA device is connected to */
 	struct fd_host *fd_host;
-	int (*fd_do_read)(struct fd_request *, struct se_task *);
-	int (*fd_do_write)(struct fd_request *, struct se_task *);
 } ____cacheline_aligned;
 
 struct fd_host {
Index: lio-core/drivers/target/target_core_iblock.c
===================================================================
--- lio-core.orig/drivers/target/target_core_iblock.c	2010-11-16 10:33:03.134004613 +0100
+++ lio-core/drivers/target/target_core_iblock.c	2010-11-16 12:26:33.202041352 +0100
@@ -412,7 +412,7 @@ static int iblock_do_task(struct se_task
 	struct bio *bio = req->ib_bio, *nbio = NULL;
 	int rw;
 
-	if (TASK_CMD(task)->data_direction == DMA_TO_DEVICE) {
+	if (task->task_data_direction == DMA_TO_DEVICE) {
 		/*
 		 * Force data to disk if we pretend to not have a volatile
 		 * write cache, or the initiator set the Force Unit Access bit.
@@ -710,7 +710,7 @@ again:
 				" %u\n", task, bio->bi_vcnt);
 	}
 
-	return task->task_sg_num;
+	return 0;
 fail:
 	while (hbio) {
 		bio = hbio;
@@ -721,41 +721,11 @@ fail:
 	return ret;
 }
 
-static int iblock_CDB_none(struct se_task *task, u32 size)
-{
-	return 0;
-}
-
-static int iblock_CDB_read_non_SG(struct se_task *task, u32 size)
-{
-	return 0;
-}
-
-static int iblock_CDB_read_SG(struct se_task *task, u32 size)
-{
-	return iblock_map_task_SG(task);
-}
-
-static int iblock_CDB_write_non_SG(struct se_task *task, u32 size)
-{
-	return 0;
-}
-
-static int iblock_CDB_write_SG(struct se_task *task, u32 size)
-{
-	return iblock_map_task_SG(task);
-}
-
 static int iblock_check_lba(unsigned long long lba, struct se_device *dev)
 {
 	return 0;
 }
 
-static int iblock_check_for_SG(struct se_task *task)
-{
-	return task->task_sg_num;
-}
-
 static unsigned char *iblock_get_cdb(struct se_task *task)
 {
 	return IBLOCK_REQ(task)->ib_scsi_cdb;
@@ -838,11 +808,7 @@ static struct se_subsystem_api iblock_te
 	.owner			= THIS_MODULE,
 	.type			= IBLOCK,
 	.transport_type		= TRANSPORT_PLUGIN_VHBA_PDEV,
-	.cdb_none		= iblock_CDB_none,
-	.cdb_read_non_SG	= iblock_CDB_read_non_SG,
-	.cdb_read_SG		= iblock_CDB_read_SG,
-	.cdb_write_non_SG	= iblock_CDB_write_non_SG,
-	.cdb_write_SG		= iblock_CDB_write_SG,
+	.map_task_SG		= iblock_map_task_SG,
 	.attach_hba		= iblock_attach_hba,
 	.detach_hba		= iblock_detach_hba,
 	.allocate_virtdevice	= iblock_allocate_virtdevice,
@@ -864,7 +830,6 @@ static struct se_subsystem_api iblock_te
 	.get_plugin_info	= iblock_get_plugin_info,
 	.get_hba_info		= iblock_get_hba_info,
 	.check_lba		= iblock_check_lba,
-	.check_for_SG		= iblock_check_for_SG,
 	.get_cdb		= iblock_get_cdb,
 	.get_device_rev		= iblock_get_device_rev,
 	.get_device_type	= iblock_get_device_type,
Index: lio-core/drivers/target/target_core_iblock.h
===================================================================
--- lio-core.orig/drivers/target/target_core_iblock.h	2010-11-16 10:33:03.142010829 +0100
+++ lio-core/drivers/target/target_core_iblock.h	2010-11-16 10:34:05.936022143 +0100
@@ -16,8 +16,6 @@ struct iblock_req {
 	unsigned char ib_scsi_cdb[TCM_MAX_COMMAND_SIZE];
 	atomic_t ib_bio_cnt;
 	atomic_t ib_bio_err_cnt;
-	u32	ib_sg_count;
-	void	*ib_buf;
 	struct bio *ib_bio;
 	struct iblock_dev *ib_dev;
 } ____cacheline_aligned;
Index: lio-core/drivers/target/target_core_rd.c
===================================================================
--- lio-core.orig/drivers/target/target_core_rd.c	2010-11-16 10:34:05.085260863 +0100
+++ lio-core/drivers/target/target_core_rd.c	2010-11-16 12:27:09.238272596 +0100
@@ -394,6 +394,7 @@ static struct rd_dev_sg_table *rd_get_sg
  */
 static int rd_MEMCPY_read(struct rd_request *req)
 {
+	struct se_task *task = &req->rd_task;
 	struct rd_dev *dev = req->rd_dev;
 	struct rd_dev_sg_table *table;
 	struct scatterlist *sg_d, *sg_s;
@@ -407,11 +408,11 @@ static int rd_MEMCPY_read(struct rd_requ
 		return -1;
 
 	table_sg_end = (table->page_end_offset - req->rd_page);
-	sg_d = req->rd_buf;
+	sg_d = task->task_sg;
 	sg_s = &table->sg_table[req->rd_page - table->page_start_offset];
 #ifdef DEBUG_RAMDISK_MCP
 	printk(KERN_INFO "RD[%u]: Read LBA: %llu, Size: %u Page: %u, Offset:"
-		" %u\n", dev->rd_dev_id, req->rd_lba, req->rd_size,
+		" %u\n", dev->rd_dev_id, task->task_lba, req->rd_size,
 		req->rd_page, req->rd_offset);
 #endif
 	src_offset = rd_offset;
@@ -516,6 +517,7 @@ static int rd_MEMCPY_read(struct rd_requ
  */
 static int rd_MEMCPY_write(struct rd_request *req)
 {
+	struct se_task *task = &req->rd_task;
 	struct rd_dev *dev = req->rd_dev;
 	struct rd_dev_sg_table *table;
 	struct scatterlist *sg_d, *sg_s;
@@ -530,10 +532,10 @@ static int rd_MEMCPY_write(struct rd_req
 
 	table_sg_end = (table->page_end_offset - req->rd_page);
 	sg_d = &table->sg_table[req->rd_page - table->page_start_offset];
-	sg_s = req->rd_buf;
+	sg_s = task->task_sg;
 #ifdef DEBUG_RAMDISK_MCP
 	printk(KERN_INFO "RD[%d] Write LBA: %llu, Size: %u, Page: %u,"
-		" Offset: %u\n", dev->rd_dev_id, req->rd_lba, req->rd_size,
+		" Offset: %u\n", dev->rd_dev_id, task->task_lba, req->rd_size,
 		req->rd_page, req->rd_offset);
 #endif
 	dst_offset = rd_offset;
@@ -640,16 +642,17 @@ static int rd_MEMCPY_do_task(struct se_t
 {
 	struct se_device *dev = task->se_dev;
 	struct rd_request *req = RD_REQ(task);
+	unsigned long long lba;
 	int ret;
 
-	req->rd_lba = task->task_lba;
-	req->rd_page = (req->rd_lba * DEV_ATTRIB(dev)->block_size) / PAGE_SIZE;
-	req->rd_offset = (do_div(req->rd_lba,
+	req->rd_page = (task->task_lba * DEV_ATTRIB(dev)->block_size) / PAGE_SIZE;
+	lba = task->task_lba;
+	req->rd_offset = (do_div(lba,
 			  (PAGE_SIZE / DEV_ATTRIB(dev)->block_size))) *
 			   DEV_ATTRIB(dev)->block_size;
 	req->rd_size = task->task_size;
 
-	if (req->rd_data_direction == RD_DATA_READ)
+	if (task->task_data_direction == DMA_FROM_DEVICE)
 		ret = rd_MEMCPY_read(req);
 	else
 		ret = rd_MEMCPY_write(req);
@@ -689,8 +692,9 @@ static int rd_DIRECT_with_offset(
 	sg_s = &table->sg_table[req->rd_page - table->page_start_offset];
 #ifdef DEBUG_RAMDISK_DR
 	printk(KERN_INFO "%s DIRECT LBA: %llu, Size: %u Page: %u, Offset: %u\n",
-		(req->rd_data_direction != RD_DATA_READ) ? "Write" : "Read",
-		req->rd_lba, req->rd_size, req->rd_page, req->rd_offset);
+		(task->task_data_direction == DMA_TO_DEVICE) ?
+			"Write" : "Read",
+		task->task_lba, req->rd_size, req->rd_page, req->rd_offset);
 #endif
 	while (req->rd_size) {
 		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
@@ -790,8 +794,9 @@ static int rd_DIRECT_without_offset(
 	sg_s = &table->sg_table[req->rd_page - table->page_start_offset];
 #ifdef DEBUG_RAMDISK_DR
 	printk(KERN_INFO "%s DIRECT LBA: %llu, Size: %u, Page: %u\n",
-		(req->rd_data_direction != RD_DATA_READ) ? "Write" : "Read",
-		req->rd_lba, req->rd_size, req->rd_page);
+		(task->task_data_direction == DMA_TO_DEVICE) ?
+			"Write" : "Read",
+		task->task_lba, req->rd_size, req->rd_page);
 #endif
 	while (req->rd_size) {
 		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
@@ -863,13 +868,13 @@ static int rd_DIRECT_do_se_mem_map(
 	struct se_cmd *cmd = task->task_se_cmd;
 	struct rd_request *req = RD_REQ(task);
 	u32 task_offset = *task_offset_in;
+	unsigned long long lba;
 	int ret;
 
-	req->rd_lba = task->task_lba;
-	req->rd_req_flags = RRF_GOT_LBA;
-	req->rd_page = ((req->rd_lba * DEV_ATTRIB(task->se_dev)->block_size) /
+	req->rd_page = ((task->task_lba * DEV_ATTRIB(task->se_dev)->block_size) /
 			PAGE_SIZE);
-	req->rd_offset = (do_div(req->rd_lba,
+	lba = task->task_lba;
+	req->rd_offset = (do_div(lba,
 			  (PAGE_SIZE / DEV_ATTRIB(task->se_dev)->block_size))) *
 			   DEV_ATTRIB(task->se_dev)->block_size;
 	req->rd_size = task->task_size;
@@ -1032,105 +1037,6 @@ static ssize_t rd_show_configfs_dev_para
 	return bl;
 }
 
-/*	rd_map_task_non_SG():
- *
- *
- */
-static void rd_map_task_non_SG(struct se_task *task)
-{
-	struct se_cmd *cmd = TASK_CMD(task);
-	struct rd_request *req = RD_REQ(task);
-
-	req->rd_bufflen		= task->task_size;
-	req->rd_buf		= (void *) T_TASK(cmd)->t_task_buf;
-	req->rd_sg_count	= 0;
-}
-
-/*	rd_map_task_SG():
- *
- *
- */
-static void rd_map_task_SG(struct se_task *task)
-{
-	struct rd_request *req = RD_REQ(task);
-
-	req->rd_bufflen		= task->task_size;
-	req->rd_buf		= task->task_sg;
-	req->rd_sg_count	= task->task_sg_num;
-}
-
-/*      rd_CDB_none():
- *
- *
- */
-static int rd_CDB_none(struct se_task *task, u32 size)
-{
-	struct rd_request *req = RD_REQ(task);
-
-	req->rd_data_direction	= RD_DATA_NONE;
-	req->rd_bufflen		= 0;
-	req->rd_sg_count	= 0;
-	req->rd_buf		= NULL;
-
-	return 0;
-}
-
-/*	rd_CDB_read_non_SG():
- *
- *
- */
-static int rd_CDB_read_non_SG(struct se_task *task, u32 size)
-{
-	struct rd_request *req = RD_REQ(task);
-
-	req->rd_data_direction = RD_DATA_READ;
-	rd_map_task_non_SG(task);
-
-	return 0;
-}
-
-/*	rd_CDB_read_SG):
- *
- *
- */
-static int rd_CDB_read_SG(struct se_task *task, u32 size)
-{
-	struct rd_request *req = RD_REQ(task);
-
-	req->rd_data_direction = RD_DATA_READ;
-	rd_map_task_SG(task);
-
-	return req->rd_sg_count;
-}
-
-/*	rd_CDB_write_non_SG():
- *
- *
- */
-static int rd_CDB_write_non_SG(struct se_task *task, u32 size)
-{
-	struct rd_request *req = RD_REQ(task);
-
-	req->rd_data_direction = RD_DATA_WRITE;
-	rd_map_task_non_SG(task);
-
-	return 0;
-}
-
-/*	d_CDB_write_SG():
- *
- *
- */
-static int rd_CDB_write_SG(struct se_task *task, u32 size)
-{
-	struct rd_request *req = RD_REQ(task);
-
-	req->rd_data_direction = RD_DATA_WRITE;
-	rd_map_task_SG(task);
-
-	return req->rd_sg_count;
-}
-
 /*	rd_DIRECT_check_lba():
  *
  *
@@ -1150,17 +1056,6 @@ static int rd_MEMCPY_check_lba(unsigned
 	return 0;
 }
 
-/*	rd_check_for_SG(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static int rd_check_for_SG(struct se_task *task)
-{
-	struct rd_request *req = RD_REQ(task);
-
-	return req->rd_sg_count;
-}
-
 /*	rd_get_cdb(): (Part of se_subsystem_api_t template)
  *
  *
@@ -1204,11 +1099,6 @@ static struct se_subsystem_api rd_dr_tem
 	.name			= "rd_dr",
 	.type			= RAMDISK_DR,
 	.transport_type		= TRANSPORT_PLUGIN_VHBA_VDEV,
-	.cdb_none		= rd_CDB_none,
-	.cdb_read_non_SG	= rd_CDB_read_non_SG,
-	.cdb_read_SG		= rd_CDB_read_SG,
-	.cdb_write_non_SG	= rd_CDB_write_non_SG,
-	.cdb_write_SG		= rd_CDB_write_SG,
 	.attach_hba		= rd_attach_hba,
 	.detach_hba		= rd_detach_hba,
 	.allocate_virtdevice	= rd_DIRECT_allocate_virtdevice,
@@ -1224,7 +1114,6 @@ static struct se_subsystem_api rd_dr_tem
 	.get_plugin_info	= rd_dr_get_plugin_info,
 	.get_hba_info		= rd_get_hba_info,
 	.check_lba		= rd_DIRECT_check_lba,
-	.check_for_SG		= rd_check_for_SG,
 	.get_cdb		= rd_get_cdb,
 	.get_device_rev		= rd_get_device_rev,
 	.get_device_type	= rd_get_device_type,
@@ -1237,11 +1126,6 @@ static struct se_subsystem_api rd_mcp_te
 	.name			= "rd_mcp",
 	.type			= RAMDISK_MCP,
 	.transport_type		= TRANSPORT_PLUGIN_VHBA_VDEV,
-	.cdb_none		= rd_CDB_none,
-	.cdb_read_non_SG	= rd_CDB_read_non_SG,
-	.cdb_read_SG		= rd_CDB_read_SG,
-	.cdb_write_non_SG	= rd_CDB_write_non_SG,
-	.cdb_write_SG		= rd_CDB_write_SG,
 	.attach_hba		= rd_attach_hba,
 	.detach_hba		= rd_detach_hba,
 	.allocate_virtdevice	= rd_MEMCPY_allocate_virtdevice,
@@ -1257,7 +1141,6 @@ static struct se_subsystem_api rd_mcp_te
 	.get_plugin_info	= rd_mcp_get_plugin_info,
 	.get_hba_info		= rd_get_hba_info,
 	.check_lba		= rd_MEMCPY_check_lba,
-	.check_for_SG		= rd_check_for_SG,
 	.get_cdb		= rd_get_cdb,
 	.get_device_rev		= rd_get_device_rev,
 	.get_device_type	= rd_get_device_type,
Index: lio-core/drivers/target/target_core_rd.h
===================================================================
--- lio-core.orig/drivers/target/target_core_rd.h	2010-11-16 10:33:03.158012295 +0100
+++ lio-core/drivers/target/target_core_rd.h	2010-11-16 10:34:05.947005241 +0100
@@ -14,10 +14,6 @@
 #define RD_BLOCKSIZE		512
 #define RD_MAX_SECTORS		1024
 
-#define RD_DATA_READ		1
-#define RD_DATA_WRITE		2
-#define RD_DATA_NONE		3
-
 extern struct se_global *se_global;
 
 extern struct kmem_cache *se_mem_cache;
@@ -34,12 +30,6 @@ struct rd_request {
 
 	/* SCSI CDB from iSCSI Command PDU */
 	unsigned char	rd_scsi_cdb[TCM_MAX_COMMAND_SIZE];
-	/* Data Direction */
-	u8		rd_data_direction;
-	/* Total length of request */
-	u32		rd_bufflen;
-	/* RD request flags */
-	u32		rd_req_flags;
 	/* Offset from start of page */
 	u32		rd_offset;
 	/* Starting page in Ramdisk for request */
@@ -47,13 +37,7 @@ struct rd_request {
 	/* Total number of pages needed for request */
 	u32		rd_page_count;
 	/* Scatterlist count */
-	u32		rd_sg_count;
 	u32		rd_size;
-	/* Logical Block Address */
-	unsigned long long	rd_lba;
-	 /* Data buffer containing scatterlists(s) or
-	  * contiguous memory segments */
-	void		*rd_buf;
 	/* Ramdisk device */
 	struct rd_dev	*rd_dev;
 } ____cacheline_aligned;
Index: lio-core/drivers/target/target_core_stgt.c
===================================================================
--- lio-core.orig/drivers/target/target_core_stgt.c	2010-11-16 10:33:03.167012645 +0100
+++ lio-core/drivers/target/target_core_stgt.c	2010-11-16 12:27:23.619005311 +0100
@@ -383,7 +383,8 @@ static int stgt_do_task(struct se_task *
 	struct scsi_cmnd *sc;
 	int tag = MSG_SIMPLE_TAG;
 
-	sc = scsi_host_get_command(sh, st->stgt_direction, GFP_KERNEL);
+	sc = scsi_host_get_command(sh, task->task_data_direction,
+				   GFP_KERNEL);
 	if (!sc) {
 		printk(KERN_ERR "Unable to allocate memory for struct"
 			" scsi_cmnd\n");
@@ -532,88 +533,6 @@ static ssize_t stgt_show_configfs_dev_pa
 	return bl;
 }
 
-/*      stgt_map_task_SG():
- *
- *
- */
-static int stgt_map_task_SG(struct se_task *task)
-{
-	return 0;
-}
-
-/*	stgt_map_task_non_SG():
- *
- *
- */
-static int stgt_map_task_non_SG(struct se_task *task)
-{
-	return 0;
-}
-
-static int stgt_CDB_none(struct se_task *task, u32 size)
-{
-	struct stgt_plugin_task *pt = STGT_TASK(task);
-
-	pt->stgt_direction = DMA_NONE;
-	return 0;
-}
-
-/*	stgt_CDB_read_non_SG():
- *
- *
- */
-static int stgt_CDB_read_non_SG(struct se_task *task, u32 size)
-{
-	struct stgt_plugin_task *pt = STGT_TASK(task);
-
-	pt->stgt_direction = DMA_FROM_DEVICE;
-	return stgt_map_task_non_SG(task);
-}
-
-/*	stgt_CDB_read_SG():
- *
- *
- */
-static int stgt_CDB_read_SG(struct se_task *task, u32 size)
-{
-	struct stgt_plugin_task *pt = STGT_TASK(task);
-
-	pt->stgt_direction = DMA_FROM_DEVICE;
-
-	if (stgt_map_task_SG(task) < 0)
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-
-	return task->task_sg_num;
-}
-
-/*	stgt_CDB_write_non_SG():
- *
- *
- */
-static int stgt_CDB_write_non_SG(struct se_task *task, u32 size)
-{
-	struct stgt_plugin_task *pt = STGT_TASK(task);
-
-	pt->stgt_direction = DMA_TO_DEVICE;
-	return stgt_map_task_non_SG(task);
-}
-
-/*	stgt_CDB_write_SG():
- *
- *
- */
-static int stgt_CDB_write_SG(struct se_task *task, u32 size)
-{
-	struct stgt_plugin_task *pt = STGT_TASK(task);
-
-	pt->stgt_direction = DMA_TO_DEVICE;
-
-	if (stgt_map_task_SG(task) < 0)
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-
-	return task->task_sg_num;
-}
-
 /*	stgt_check_lba():
  *
  *
@@ -623,15 +542,6 @@ static int stgt_check_lba(unsigned long
 	return 0;
 }
 
-/*	stgt_check_for_SG():
- *
- *
- */
-static int stgt_check_for_SG(struct se_task *task)
-{
-	return task->task_sg_num;
-}
-
 /*	stgt_get_cdb():
  *
  *
@@ -758,11 +668,6 @@ static struct se_subsystem_api stgt_temp
 	.owner			= THIS_MODULE,
 	.type			= STGT,
 	.transport_type		= TRANSPORT_PLUGIN_VHBA_PDEV,
-	.cdb_none		= stgt_CDB_none,
-	.cdb_read_non_SG	= stgt_CDB_read_non_SG,
-	.cdb_read_SG		= stgt_CDB_read_SG,
-	.cdb_write_non_SG	= stgt_CDB_write_non_SG,
-	.cdb_write_SG		= stgt_CDB_write_SG,
 	.attach_hba		= stgt_attach_hba,
 	.detach_hba		= stgt_detach_hba,
 	.allocate_virtdevice	= stgt_allocate_virtdevice,
@@ -780,7 +685,6 @@ static struct se_subsystem_api stgt_temp
 	.get_plugin_info	= stgt_get_plugin_info,
 	.get_hba_info		= stgt_get_hba_info,
 	.check_lba		= stgt_check_lba,
-	.check_for_SG		= stgt_check_for_SG,
 	.get_cdb		= stgt_get_cdb,
 	.get_sense_buffer	= stgt_get_sense_buffer,
 	.get_device_rev		= stgt_get_device_rev,
Index: lio-core/drivers/target/target_core_pscsi.c
===================================================================
--- lio-core.orig/drivers/target/target_core_pscsi.c	2010-11-16 10:33:03.175004194 +0100
+++ lio-core/drivers/target/target_core_pscsi.c	2010-11-16 12:28:04.905004752 +0100
@@ -741,7 +741,8 @@ static int pscsi_blk_get_request(struct
 	struct pscsi_dev_virt *pdv = task->se_dev->dev_ptr;
 
 	pt->pscsi_req = blk_get_request(pdv->pdv_sd->request_queue,
-			(pt->pscsi_direction == DMA_TO_DEVICE), GFP_KERNEL);
+			(task->task_data_direction == DMA_TO_DEVICE),
+			GFP_KERNEL);
 	if (!(pt->pscsi_req) || IS_ERR(pt->pscsi_req)) {
 		printk(KERN_ERR "PSCSI: blk_get_request() failed: %ld\n",
 				IS_ERR(pt->pscsi_req));
@@ -1015,7 +1016,7 @@ static int __pscsi_map_task_SG(
 	int nr_pages = (task->task_size + task_sg[0].offset +
 			PAGE_SIZE - 1) >> PAGE_SHIFT;
 	int nr_vecs = 0, rc, ret = PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
-	int rw = (TASK_CMD(task)->data_direction == DMA_TO_DEVICE);
+	int rw = (task->task_data_direction == DMA_TO_DEVICE);
 
 	if (!task->task_size)
 		return 0;
@@ -1152,22 +1153,24 @@ fail:
 static int pscsi_map_task_SG(struct se_task *task)
 {
 	int ret;
+
 	/*
 	 * Setup the main struct request for the task->task_sg[] payload
 	 */
 
 	ret = __pscsi_map_task_SG(task, task->task_sg, task->task_sg_num, 0);
-	if (ret < 0)
-		return ret;
+	if (ret >= 0 && task->task_sg_bidi) {
+		/*
+		 * If present, set up the extra BIDI-COMMAND SCSI READ
+		 * struct request and payload.
+		 */
+		ret = __pscsi_map_task_SG(task, task->task_sg_bidi,
+					task->task_sg_num, 1);
+	}
 
-	if (!(task->task_sg_bidi))
-		return ret;
-	/*
-	 * If present, set up the extra BIDI-COMMAND SCSI READ
-	 * struct request and payload.
-	 */
-	return __pscsi_map_task_SG(task, task->task_sg_bidi,
-				task->task_sg_num, 1);
+	if (ret < 0)
+		return PYX_TRANSPORT_LU_COMM_FAILURE;
+	return 0;
 }
 
 /*	pscsi_map_task_non_SG():
@@ -1181,6 +1184,9 @@ static int pscsi_map_task_non_SG(struct
 	struct pscsi_dev_virt *pdv = task->se_dev->dev_ptr;
 	int ret = 0;
 
+	if (pscsi_blk_get_request(task) < 0)
+		return PYX_TRANSPORT_LU_COMM_FAILURE;
+
 	if (!task->task_size)
 		return 0;
 
@@ -1194,85 +1200,11 @@ static int pscsi_map_task_non_SG(struct
 	return 0;
 }
 
-static int pscsi_CDB_none(struct se_task *task, u32 size)
+static int pscsi_CDB_none(struct se_task *task)
 {
-	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
-
-	pt->pscsi_direction = DMA_NONE;
-
 	return pscsi_blk_get_request(task);
 }
 
-/*	pscsi_CDB_read_non_SG():
- *
- *
- */
-static int pscsi_CDB_read_non_SG(struct se_task *task, u32 size)
-{
-	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
-
-	pt->pscsi_direction = DMA_FROM_DEVICE;
-
-	if (pscsi_blk_get_request(task) < 0)
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-
-	return pscsi_map_task_non_SG(task);
-}
-
-/*	pscsi_CDB_read_SG():
- *
- *
- */
-static int pscsi_CDB_read_SG(struct se_task *task, u32 size)
-{
-	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
-
-	pt->pscsi_direction = DMA_FROM_DEVICE;
-	/*
-	 * pscsi_map_task_SG() calls block/blk-core.c:blk_make_request()
-	 * for >= v2.6.31 pSCSI
-	 */
-	if (pscsi_map_task_SG(task) < 0)
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-
-	return task->task_sg_num;
-}
-
-/*	pscsi_CDB_write_non_SG():
- *
- *
- */
-static int pscsi_CDB_write_non_SG(struct se_task *task, u32 size)
-{
-	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
-
-	pt->pscsi_direction = DMA_TO_DEVICE;
-
-	if (pscsi_blk_get_request(task) < 0)
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-
-	return pscsi_map_task_non_SG(task);
-}
-
-/*	pscsi_CDB_write_SG():
- *
- *
- */
-static int pscsi_CDB_write_SG(struct se_task *task, u32 size)
-{
-	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
-
-	pt->pscsi_direction = DMA_TO_DEVICE;
-	/*
-	 * pscsi_map_task_SG() calls block/blk-core.c:blk_make_request()
-	 * for >= v2.6.31 pSCSI
-	 */
-	if (pscsi_map_task_SG(task) < 0)
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-
-	return task->task_sg_num;
-}
-
 /*	pscsi_check_lba():
  *
  *
@@ -1282,15 +1214,6 @@ static int pscsi_check_lba(unsigned long
 	return 0;
 }
 
-/*	pscsi_check_for_SG():
- *
- *
- */
-static int pscsi_check_for_SG(struct se_task *task)
-{
-	return task->task_sg_num;
-}
-
 /*	pscsi_get_cdb():
  *
  *
@@ -1406,10 +1329,8 @@ static struct se_subsystem_api pscsi_tem
 	.type			= PSCSI,
 	.transport_type		= TRANSPORT_PLUGIN_PHBA_PDEV,
 	.cdb_none		= pscsi_CDB_none,
-	.cdb_read_non_SG	= pscsi_CDB_read_non_SG,
-	.cdb_read_SG		= pscsi_CDB_read_SG,
-	.cdb_write_non_SG	= pscsi_CDB_write_non_SG,
-	.cdb_write_SG		= pscsi_CDB_write_SG,
+	.map_task_non_SG	= pscsi_map_task_non_SG,
+	.map_task_SG		= pscsi_map_task_SG,
 	.attach_hba		= pscsi_attach_hba,
 	.detach_hba		= pscsi_detach_hba,
 	.pmode_enable_hba	= pscsi_pmode_enable_hba,
@@ -1426,7 +1347,6 @@ static struct se_subsystem_api pscsi_tem
 	.get_plugin_info	= pscsi_get_plugin_info,
 	.get_hba_info		= pscsi_get_hba_info,
 	.check_lba		= pscsi_check_lba,
-	.check_for_SG		= pscsi_check_for_SG,
 	.get_cdb		= pscsi_get_cdb,
 	.get_sense_buffer	= pscsi_get_sense_buffer,
 	.get_device_rev		= pscsi_get_device_rev,
Index: lio-core/drivers/target/target_core_stgt.h
===================================================================
--- lio-core.orig/drivers/target/target_core_stgt.h	2010-11-16 10:33:03.184012435 +0100
+++ lio-core/drivers/target/target_core_stgt.h	2010-11-16 10:34:05.966264356 +0100
@@ -23,7 +23,6 @@ struct stgt_plugin_task {
 	struct se_task stgt_task;
 	unsigned char stgt_cdb[TCM_MAX_COMMAND_SIZE];
 	unsigned char stgt_sense[SCSI_SENSE_BUFFERSIZE];
-	int	stgt_direction;
 	int	stgt_result;
 	u32	stgt_resid;
 	struct scsi_cmnd *stgt_cmd;
Index: lio-core/include/target/target_core_transport.h
===================================================================
--- lio-core.orig/include/target/target_core_transport.h	2010-11-16 10:34:05.083275321 +0100
+++ lio-core/include/target/target_core_transport.h	2010-11-16 10:34:05.973004473 +0100
@@ -303,23 +303,15 @@ struct se_subsystem_api {
 	/*
 	 * For SCF_SCSI_NON_DATA_CDB
 	 */
-	int (*cdb_none)(struct se_task *, u32);
+	int (*cdb_none)(struct se_task *);
 	/*
-	 * For READ SCF_SCSI_CONTROL_NONSG_IO_CDB
+	 * For SCF_SCSI_CONTROL_NONSG_IO_CDB
 	 */
-	int (*cdb_read_non_SG)(struct se_task *, u32);
+	int (*map_task_non_SG)(struct se_task *);
 	/*
-	 * For READ SCF_SCSI_DATA_SG_IO_CDB and SCF_SCSI_CONTROL_SG_IO_CDB
+	 * For SCF_SCSI_DATA_SG_IO_CDB and SCF_SCSI_CONTROL_SG_IO_CDB
 	 */
-	int (*cdb_read_SG)(struct se_task *, u32);
-	/*
-	 * For WRITE SCF_SCSI_CONTROL_NONSG_IO_CDB
-	 */
-	int (*cdb_write_non_SG)(struct se_task *, u32);
-	/*
-	 * For WRITE SCF_SCSI_DATA_SG_IO_CDB and SCF_SCSI_CONTROL_SG_IO_CDB
-	 */
-	int (*cdb_write_SG)(struct se_task *, u32);
+	int (*map_task_SG)(struct se_task *);
 	/*
 	 * attach_hba():
 	 */
@@ -438,10 +430,6 @@ struct se_subsystem_api {
 	 */
 	int (*check_lba)(unsigned long long lba, struct se_device *);
 	/*
-	 * check_for_SG():
-	 */
-	int (*check_for_SG)(struct se_task *);
-	/*
 	 * get_cdb():
 	 */
 	unsigned char *(*get_cdb)(struct se_task *);
Index: lio-core/drivers/target/target_core_transport.c
===================================================================
--- lio-core.orig/drivers/target/target_core_transport.c	2010-11-16 10:34:05.081254089 +0100
+++ lio-core/drivers/target/target_core_transport.c	2010-11-16 12:30:12.831254579 +0100
@@ -2257,6 +2257,7 @@ static struct se_task *transport_generic
 	task->task_no = T_TASK(cmd)->t_tasks_no++;
 	task->task_se_cmd = cmd;
 	task->se_dev = dev;
+	task->task_data_direction = data_direction;
 
 	DEBUG_SO("se_obj_ptr: %p\n", se_obj_ptr);
 
@@ -2269,28 +2270,6 @@ static struct se_task *transport_generic
 	return task;
 }
 
-static inline map_func_t transport_dev_get_map_SG(
-	struct se_device *dev,
-	int rw)
-{
-	return (rw == DMA_TO_DEVICE) ? dev->transport->cdb_write_SG :
-		dev->transport->cdb_read_SG;
-}
-
-static inline map_func_t transport_dev_get_map_non_SG(
-	struct se_device *dev,
-	int rw)
-{
-	return (rw == DMA_TO_DEVICE) ? dev->transport->cdb_write_non_SG :
-		dev->transport->cdb_read_non_SG;
-}
-
-static inline map_func_t transport_dev_get_map_none(
-	struct se_device *dev)
-{
-	return dev->transport->cdb_none;
-}
-
 static int transport_process_data_sg_transform(
 	struct se_cmd *cmd,
 	struct se_transform_info *ti)
@@ -2333,8 +2312,7 @@ static int transport_process_control_sg_
 	if (!(task))
 		return -1;
 
-	task->transport_map_task = transport_dev_get_map_SG(ti->se_obj_ptr,
-				cmd->data_direction);
+	task->transport_map_task = ti->se_obj_ptr->transport->map_task_SG;
 
 	cdb = TRANSPORT(dev)->get_cdb(task);
 	if (cdb)
@@ -2375,8 +2353,7 @@ static int transport_process_control_non
 	if (!(task))
 		return -1;
 
-	task->transport_map_task = transport_dev_get_map_non_SG(ti->se_obj_ptr,
-				cmd->data_direction);
+	task->transport_map_task = ti->se_obj_ptr->transport->map_task_non_SG;
 
 	cdb = TRANSPORT(dev)->get_cdb(task);
 	if (cdb)
@@ -2411,7 +2388,7 @@ static int transport_process_non_data_tr
 	if (!(task))
 		return -1;
 
-	task->transport_map_task = transport_dev_get_map_none(ti->se_obj_ptr);
+	task->transport_map_task = ti->se_obj_ptr->transport->cdb_none;
 
 	cdb = TRANSPORT(dev)->get_cdb(task);
 	if (cdb)
@@ -5994,8 +5971,8 @@ u32 transport_generic_get_cdb_count(
 		sectors -= task->task_sectors;
 		task->task_size = (task->task_sectors *
 				   DEV_ATTRIB(dev)->block_size);
-		task->transport_map_task = transport_dev_get_map_SG(dev,
-					data_direction);
+
+		task->transport_map_task = dev->transport->map_task_SG;
 
 		cdb = TRANSPORT(dev)->get_cdb(task);
 		if ((cdb)) {
@@ -6139,9 +6116,11 @@ int transport_generic_new_cmd(struct se_
 		if (atomic_read(&task->task_sent))
 			continue;
 
-		ret = task->transport_map_task(task, task->task_size);
-		if (ret < 0)
-			goto failure;
+		if (task->transport_map_task) {
+			ret = task->transport_map_task(task);
+			if (ret < 0)
+				goto failure;
+		}
 	}
 
 	/*
Index: lio-core/include/target/target_core_base.h
===================================================================
--- lio-core.orig/include/target/target_core_base.h	2010-11-16 10:34:05.089004054 +0100
+++ lio-core/include/target/target_core_base.h	2010-11-16 12:23:24.621013003 +0100
@@ -488,6 +488,7 @@ struct se_task {
 	u32		task_size;
 	u32		task_sg_num;
 	u32		task_sg_offset;
+	enum dma_data_direction	task_data_direction;
 	struct se_cmd *task_se_cmd;
 	struct se_device	*se_dev;
 	struct completion	task_stop_comp;
@@ -498,7 +499,7 @@ struct se_task {
 	atomic_t	task_stop;
 	atomic_t	task_state_active;
 	struct timer_list	task_timer;
-	int (*transport_map_task)(struct se_task *, u32);
+	int (*transport_map_task)(struct se_task *);
 	struct se_device *se_obj_ptr;
 	struct list_head t_list;
 	struct list_head t_execute_list;
