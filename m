From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFCv3 00/21] TCM Core and TCM_Loop patches for v2.6.37
Date: Mon, 8 Nov 2010 13:23:30 -0500
Message-ID: <20101108182330.GA3152@infradead.org>
References: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44918 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab0KHSXe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 13:23:34 -0500
Content-Disposition: inline
In-Reply-To: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>

Hi Nick,

some comments on the I/O path:

 - I think there are too many entry points and different kinds of pass
   through.  As a start transport_allocate_passthrough should go away,
   it can be replaced with retriving the inquiry/serial data from
   the device attributes.  pscsi can then do it's internal lowlevel
   INQUIRY on the device to fill them on probe.
   Second all the frontends should agree on one way to insert commands
   into the queue, and we should get rid of all the magic flags on the
   se_cmd to treat them slightly different.  That gives you a single
   I/O path for all users making the debugging a lot simpler.
 - the se_task / backend task allocation currently is rather
   inefficient. See my RFC patch below to unify them in a style similar
   to the VFS inode.  The backends should probably also switch to use
   slab caches and switch to a constistant foo_task naming, but that's
   left for later.
 - the cdb storage should move into the generic code, including the
   external allocation for large CDBs.
 - Same for the sense data.
 - the data_direction setup in the low-level drivers should be lifted
   into common code.
 - what's the point of keeping different SG/non-SG codepathes around?
   non-SG is a special case of an S/G list with 1 entry.  We've switched
   to the SG-only model in the scsi initiator layer long ago, and
   it simplifies a lot of things.  In addition the cdb_read*/
   cdb_write*/cdb_none routines should be merged into a single map_task
   method that looks at the data direction previously set in se_task.
   The methods map to common code alsmost all of the time anyway.
 - I really don't like all the function pointers in the se_cmd and the
   one in the se_task.  They're basically private to
   target_core_transport.c and should be replaced by flags, or even
   better by only reading their input information where it's actually
   used if possible.
 
And here's the RFC path for the simpler and faster task/request
allocation:


Index: lio-core-2.6/drivers/target/target_core_file.c
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_file.c	2010-11-08 18:33:49.181529678 +0100
+++ lio-core-2.6/drivers/target/target_core_file.c	2010-11-08 18:53:20.358196345 +0100
@@ -284,13 +284,14 @@ static int fd_transport_complete(struct
 	return 0;
 }
 
-/*	fd_allocate_request(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static void *fd_allocate_request(
-	struct se_task *task,
-	struct se_device *dev)
+static inline struct fd_request *FILE_REQ(struct se_task *task)
+{
+	return container_of(task, struct fd_request, fd_task);
+}
+
+
+static struct se_task *
+fd_alloc_task(struct se_cmd *cmd)
 {
 	struct fd_request *fd_req;
 
@@ -300,9 +301,9 @@ static void *fd_allocate_request(
 		return NULL;
 	}
 
-	fd_req->fd_dev = dev->dev_ptr;
+	fd_req->fd_dev = SE_DEV(cmd)->dev_ptr;
 
-	return (void *)fd_req;
+	return &fd_req->fd_task;
 }
 
 static inline int fd_iovec_alloc(struct fd_request *req)
@@ -381,7 +382,7 @@ static static int fd_sendactor(
 {
 	unsigned long count = desc->count;
 	struct se_task *task = desc->arg.data;
-	struct fd_request *req = (struct fd_request *) task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 	struct scatterlist *sg = task->task_sg;
 
 	printk(KERN_INFO "page: %p offset: %lu size: %lu\n", page,
@@ -592,7 +593,7 @@ static int fd_do_task(struct se_task *ta
 {
 	struct se_cmd *cmd = task->task_se_cmd;
 	struct se_device *dev = cmd->se_dev;
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 	int ret = 0;
 
 	req->fd_lba = task->task_lba;
@@ -642,7 +643,7 @@ static int fd_do_task(struct se_task *ta
  */
 static void fd_free_task(struct se_task *task)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	kfree(req->fd_iovs);
 	kfree(req);
@@ -785,7 +786,7 @@ static void __fd_get_dev_info(struct fd_
 static void fd_map_task_non_SG(struct se_task *task)
 {
 	struct se_cmd *cmd = TASK_CMD(task);
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	req->fd_bufflen		= task->task_size;
 	req->fd_buf		= (void *) T_TASK(cmd)->t_task_buf;
@@ -798,7 +799,7 @@ static void fd_map_task_non_SG(struct se
  */
 static void fd_map_task_SG(struct se_task *task)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	req->fd_bufflen		= task->task_size;
 	req->fd_buf		= NULL;
@@ -811,7 +812,7 @@ static void fd_map_task_SG(struct se_tas
  */
 static int fd_CDB_none(struct se_task *task, u32 size)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	req->fd_data_direction	= FD_DATA_NONE;
 	req->fd_bufflen		= 0;
@@ -827,7 +828,7 @@ static int fd_CDB_none(struct se_task *t
  */
 static int fd_CDB_read_non_SG(struct se_task *task, u32 size)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	req->fd_data_direction = FD_DATA_READ;
 	fd_map_task_non_SG(task);
@@ -841,7 +842,7 @@ static int fd_CDB_read_non_SG(struct se_
  */
 static int fd_CDB_read_SG(struct se_task *task, u32 size)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	req->fd_data_direction = FD_DATA_READ;
 	fd_map_task_SG(task);
@@ -855,7 +856,7 @@ static int fd_CDB_read_SG(struct se_task
  */
 static int fd_CDB_write_non_SG(struct se_task *task, u32 size)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	req->fd_data_direction = FD_DATA_WRITE;
 	fd_map_task_non_SG(task);
@@ -869,7 +870,7 @@ static int fd_CDB_write_non_SG(struct se
  */
 static int fd_CDB_write_SG(struct se_task *task, u32 size)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	req->fd_data_direction = FD_DATA_WRITE;
 	fd_map_task_SG(task);
@@ -892,7 +893,7 @@ static int fd_check_lba(unsigned long lo
  */
 static int fd_check_for_SG(struct se_task *task)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	return req->fd_sg_count;
 }
@@ -903,7 +904,7 @@ static int fd_check_for_SG(struct se_tas
  */
 static unsigned char *fd_get_cdb(struct se_task *task)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	return req->fd_scsi_cdb;
 }
@@ -964,7 +965,7 @@ static struct se_subsystem_api fileio_te
 	.fua_read_emulated	= fd_emulated_fua_read,
 	.write_cache_emulated	= fd_emulated_write_cache,
 	.transport_complete	= fd_transport_complete,
-	.allocate_request	= fd_allocate_request,
+	.alloc_task		= fd_alloc_task,
 	.do_task		= fd_do_task,
 	.do_sync_cache		= fd_emulate_sync_cache,
 	.free_task		= fd_free_task,
Index: lio-core-2.6/drivers/target/target_core_file.h
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_file.h	2010-11-08 18:33:49.194863013 +0100
+++ lio-core-2.6/drivers/target/target_core_file.h	2010-11-08 19:19:34.261529679 +0100
@@ -21,6 +21,7 @@ extern struct se_global *se_global;
 #define RRF_GOT_LBA		0x02
 
 struct fd_request {
+	struct se_task	fd_task;
 	/* SCSI CDB from iSCSI Command PDU */
 	unsigned char	fd_scsi_cdb[TCM_MAX_COMMAND_SIZE];
 	/* Data Direction */
Index: lio-core-2.6/drivers/target/target_core_iblock.c
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_iblock.c	2010-11-08 18:37:12.051529680 +0100
+++ lio-core-2.6/drivers/target/target_core_iblock.c	2010-11-08 18:54:12.738196343 +0100
@@ -253,13 +253,13 @@ static int iblock_transport_complete(str
 	return 0;
 }
 
-/*	iblock_allocate_request(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static void *iblock_allocate_request(
-	struct se_task *task,
-	struct se_device *dev)
+static inline struct iblock_req *IBLOCK_REQ(struct se_task *task)
+{
+	return container_of(task, struct iblock_req, ib_task);
+}
+
+static struct se_task *
+iblock_alloc_task(struct se_cmd *cmd)
 {
 	struct iblock_req *ib_req;
 
@@ -269,9 +269,9 @@ static void *iblock_allocate_request(
 		return NULL;
 	}
 
-	ib_req->ib_dev = dev->dev_ptr;
+	ib_req->ib_dev = SE_DEV(cmd)->dev_ptr;
 	atomic_set(&ib_req->ib_bio_cnt, 0);
-	return ib_req;
+	return &ib_req->ib_task;
 }
 
 static unsigned long long iblock_emulate_read_cap_with_block_size(
@@ -439,7 +439,7 @@ int iblock_emulated_fua_read(struct se_d
 static int iblock_do_task(struct se_task *task)
 {
 	struct se_device *dev = task->task_se_cmd->se_dev;
-	struct iblock_req *req = (struct iblock_req *)task->transport_req;
+	struct iblock_req *req = IBLOCK_REQ(task);
 	struct iblock_dev *ibd = (struct iblock_dev *)req->ib_dev;
 	struct request_queue *q = bdev_get_queue(ibd->ibd_bd);
 	struct bio *bio = req->ib_bio, *nbio = NULL;
@@ -490,7 +490,7 @@ static int iblock_do_discard(struct se_d
 
 static void iblock_free_task(struct se_task *task)
 {
-	struct iblock_req *req = task->transport_req;
+	struct iblock_req *req = IBLOCK_REQ(task);
 	struct bio *bio, *hbio = req->ib_bio;
 	/*
 	 * We only release the bio(s) here if iblock_bio_done() has not called
@@ -504,7 +504,6 @@ static void iblock_free_task(struct se_t
 	}
 
 	kfree(req);
-	task->transport_req = NULL;
 }
 
 static ssize_t iblock_set_configfs_dev_params(struct se_hba *hba,
@@ -697,7 +696,7 @@ static int iblock_map_task_SG(struct se_
 	struct se_cmd *cmd = task->task_se_cmd;
 	struct se_device *dev = SE_DEV(cmd);
 	struct iblock_dev *ib_dev = task->se_dev->dev_ptr;
-	struct iblock_req *ib_req = task->transport_req;
+	struct iblock_req *ib_req = IBLOCK_REQ(task);
 	struct bio *bio = NULL, *hbio = NULL, *tbio = NULL;
 	struct scatterlist *sg;
 	int ret = 0;
@@ -817,9 +816,7 @@ static int iblock_check_for_SG(struct se
 
 static unsigned char *iblock_get_cdb(struct se_task *task)
 {
-	struct iblock_req *req = task->transport_req;
-
-	return req->ib_scsi_cdb;
+	return IBLOCK_REQ(task)->ib_scsi_cdb;
 }
 
 static u32 iblock_get_device_rev(struct se_device *dev)
@@ -849,7 +846,7 @@ static sector_t iblock_get_blocks(struct
 static void iblock_bio_done(struct bio *bio, int err)
 {
 	struct se_task *task = bio->bi_private;
-	struct iblock_req *ibr = task->transport_req;
+	struct iblock_req *ibr = IBLOCK_REQ(task);
 	/*
 	 * Set -EIO if !BIO_UPTODATE and the passed is still err=0
 	 */
@@ -914,7 +911,7 @@ static struct se_subsystem_api iblock_te
 	.fua_read_emulated	= iblock_emulated_fua_read,
 	.write_cache_emulated	= iblock_emulated_write_cache,
 	.transport_complete	= iblock_transport_complete,
-	.allocate_request	= iblock_allocate_request,
+	.alloc_task		= iblock_alloc_task,
 	.do_task		= iblock_do_task,
 	.do_discard		= iblock_do_discard,
 	.do_sync_cache		= iblock_emulate_sync_cache,
Index: lio-core-2.6/drivers/target/target_core_iblock.h
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_iblock.h	2010-11-08 18:37:12.068196346 +0100
+++ lio-core-2.6/drivers/target/target_core_iblock.h	2010-11-08 18:37:47.664863030 +0100
@@ -12,6 +12,7 @@
 extern struct se_global *se_global;
 
 struct iblock_req {
+	struct se_task ib_task;
 	unsigned char ib_scsi_cdb[TCM_MAX_COMMAND_SIZE];
 	atomic_t ib_bio_cnt;
 	atomic_t ib_bio_err_cnt;
Index: lio-core-2.6/drivers/target/target_core_pscsi.c
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_pscsi.c	2010-11-08 18:41:14.521529681 +0100
+++ lio-core-2.6/drivers/target/target_core_pscsi.c	2010-11-08 18:59:57.218196347 +0100
@@ -602,6 +602,12 @@ static void pscsi_free_device(void *p)
 	kfree(pdv);
 }
 
+static inline struct pscsi_plugin_task *PSCSI_TASK(struct se_task *task)
+{
+	return container_of(task, struct pscsi_plugin_task, pscsi_task);
+}
+
+
 /*	pscsi_transport_complete():
  *
  *
@@ -611,7 +617,7 @@ static int pscsi_transport_complete(stru
 	struct pscsi_dev_virt *pdv = task->se_dev->dev_ptr;
 	struct scsi_device *sd = pdv->pdv_sd;
 	int result;
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 	unsigned char *cdb = &pt->pscsi_cdb[0];
 
 	result = pt->pscsi_result;
@@ -689,23 +695,18 @@ after_mode_select:
 	return 0;
 }
 
-/*	pscsi_allocate_request(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static void *pscsi_allocate_request(
-	struct se_task *task,
-	struct se_device *dev)
+static struct se_task *
+pscsi_alloc_task(struct se_cmd *cmd)
 {
-	struct se_cmd *cmd = task->task_se_cmd;
 	struct pscsi_plugin_task *pt;
 	unsigned char *cdb = T_TASK(cmd)->t_task_cdb;
 
 	pt = kzalloc(sizeof(struct pscsi_plugin_task), GFP_KERNEL);
-	if (!(pt)) {
+	if (!pt) {
 		printk(KERN_ERR "Unable to allocate struct pscsi_plugin_task\n");
 		return NULL;
 	}
+
 	/*
 	 * If TCM Core is signaling a > TCM_MAX_COMMAND_SIZE allocation,
 	 * allocate the extended CDB buffer for per struct se_task context
@@ -732,7 +733,7 @@ static void *pscsi_allocate_request(
 	} else
 		pt->pscsi_cdb = &pt->__pscsi_cdb[0];
 
-	return pt;
+	return &pt->pscsi_task;
 }
 
 static inline void pscsi_blk_init_request(
@@ -775,7 +776,7 @@ static inline void pscsi_blk_init_reques
 */
 static int pscsi_blk_get_request(struct se_task *task)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 	struct pscsi_dev_virt *pdv = task->se_dev->dev_ptr;
 
 	pt->pscsi_req = blk_get_request(pdv->pdv_sd->request_queue,
@@ -799,7 +800,7 @@ static int pscsi_blk_get_request(struct
  */
 static int pscsi_do_task(struct se_task *task)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 	struct pscsi_dev_virt *pdv = task->se_dev->dev_ptr;
 	/*
 	 * Set the struct request->timeout value based on peripheral
@@ -826,9 +827,9 @@ static int pscsi_do_task(struct se_task
  */
 static void pscsi_free_task(struct se_task *task)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 	/*
-	 * Release the extended CDB allocation from pscsi_allocate_request()
+	 * Release the extended CDB allocation from pscsi_alloc_task()
 	 * if one exists.
 	 */
 	if (task->task_se_cmd->se_cmd_flags & SCF_ECDB_ALLOCATION)
@@ -1084,7 +1085,7 @@ static int __pscsi_map_task_SG(
 	u32 task_sg_num,
 	int bidi_read)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 	struct pscsi_dev_virt *pdv = task->se_dev->dev_ptr;
 	struct bio *bio = NULL, *hbio = NULL, *tbio = NULL;
 	struct page *page;
@@ -1260,7 +1261,7 @@ static int pscsi_map_task_SG(struct se_t
 static int pscsi_map_task_non_SG(struct se_task *task)
 {
 	struct se_cmd *cmd = TASK_CMD(task);
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 	struct pscsi_dev_virt *pdv = task->se_dev->dev_ptr;
 	int ret = 0;
 
@@ -1279,7 +1280,7 @@ static int pscsi_map_task_non_SG(struct
 
 static int pscsi_CDB_none(struct se_task *task, u32 size)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 
 	pt->pscsi_direction = DMA_NONE;
 
@@ -1292,7 +1293,7 @@ static int pscsi_CDB_none(struct se_task
  */
 static int pscsi_CDB_read_non_SG(struct se_task *task, u32 size)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 
 	pt->pscsi_direction = DMA_FROM_DEVICE;
 
@@ -1308,7 +1309,7 @@ static int pscsi_CDB_read_non_SG(struct
  */
 static int pscsi_CDB_read_SG(struct se_task *task, u32 size)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 
 	pt->pscsi_direction = DMA_FROM_DEVICE;
 	/*
@@ -1327,7 +1328,7 @@ static int pscsi_CDB_read_SG(struct se_t
  */
 static int pscsi_CDB_write_non_SG(struct se_task *task, u32 size)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 
 	pt->pscsi_direction = DMA_TO_DEVICE;
 
@@ -1343,7 +1344,7 @@ static int pscsi_CDB_write_non_SG(struct
  */
 static int pscsi_CDB_write_SG(struct se_task *task, u32 size)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 
 	pt->pscsi_direction = DMA_TO_DEVICE;
 	/*
@@ -1380,7 +1381,7 @@ static int pscsi_check_for_SG(struct se_
  */
 static unsigned char *pscsi_get_cdb(struct se_task *task)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 
 	return pt->pscsi_cdb;
 }
@@ -1391,7 +1392,7 @@ static unsigned char *pscsi_get_cdb(stru
  */
 static unsigned char *pscsi_get_sense_buffer(struct se_task *task)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 
 	return (unsigned char *)&pt->pscsi_sense[0];
 }
@@ -1467,7 +1468,7 @@ static inline void pscsi_process_SAM_sta
 static void pscsi_req_done(struct request *req, int uptodate)
 {
 	struct se_task *task = req->end_io_data;
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 
 	pt->pscsi_result = req->errors;
 	pt->pscsi_resid = req->resid_len;
@@ -1500,7 +1501,7 @@ static struct se_subsystem_api pscsi_tem
 	.create_virtdevice	= pscsi_create_virtdevice,
 	.free_device		= pscsi_free_device,
 	.transport_complete	= pscsi_transport_complete,
-	.allocate_request	= pscsi_allocate_request,
+	.alloc_task		= pscsi_alloc_task,
 	.do_task		= pscsi_do_task,
 	.free_task		= pscsi_free_task,
 	.check_configfs_dev_params = pscsi_check_configfs_dev_params,
Index: lio-core-2.6/drivers/target/target_core_pscsi.h
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_pscsi.h	2010-11-08 18:41:14.531529680 +0100
+++ lio-core-2.6/drivers/target/target_core_pscsi.h	2010-11-08 18:46:40.261529681 +0100
@@ -28,6 +28,7 @@ extern struct se_global *se_global;
 #include <linux/kobject.h>
 
 struct pscsi_plugin_task {
+	struct se_task pscsi_task;
 	unsigned char *pscsi_cdb;
 	unsigned char __pscsi_cdb[TCM_MAX_COMMAND_SIZE];
 	unsigned char pscsi_sense[SCSI_SENSE_BUFFERSIZE];
Index: lio-core-2.6/drivers/target/target_core_rd.c
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_rd.c	2010-11-08 18:37:52.141529679 +0100
+++ lio-core-2.6/drivers/target/target_core_rd.c	2010-11-08 19:03:45.954863014 +0100
@@ -351,24 +351,24 @@ static int rd_transport_complete(struct
 	return 0;
 }
 
-/*	rd_allocate_request(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static void *rd_allocate_request(
-	struct se_task *task,
-	struct se_device *dev)
+static inline struct rd_request *RD_REQ(struct se_task *task)
+{
+	return container_of(task, struct rd_request, rd_task);
+}
+
+static struct se_task *
+rd_alloc_task(struct se_cmd *cmd)
 {
 	struct rd_request *rd_req;
 
 	rd_req = kzalloc(sizeof(struct rd_request), GFP_KERNEL);
-	if (!(rd_req)) {
+	if (!rd_req) {
 		printk(KERN_ERR "Unable to allocate struct rd_request\n");
 		return NULL;
 	}
-	rd_req->rd_dev = dev->dev_ptr;
+	rd_req->rd_dev = SE_DEV(cmd)->dev_ptr;
 
-	return (void *)rd_req;
+	return &rd_req->rd_task;
 }
 
 /*	rd_get_sg_table():
@@ -644,7 +644,7 @@ static int rd_MEMCPY_write(struct rd_req
 static int rd_MEMCPY_do_task(struct se_task *task)
 {
 	struct se_device *dev = task->se_dev;
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 	int ret;
 
 	req->rd_lba = task->task_lba;
@@ -678,7 +678,7 @@ static int rd_DIRECT_with_offset(
 	u32 *se_mem_cnt,
 	u32 *task_offset)
 {
-	struct rd_request *req = (struct rd_request *)task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 	struct rd_dev *dev = req->rd_dev;
 	struct rd_dev_sg_table *table;
 	struct se_mem *se_mem;
@@ -781,7 +781,7 @@ static int rd_DIRECT_without_offset(
 	u32 *se_mem_cnt,
 	u32 *task_offset)
 {
-	struct rd_request *req = (struct rd_request *)task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 	struct rd_dev *dev = req->rd_dev;
 	struct rd_dev_sg_table *table;
 	struct se_mem *se_mem;
@@ -866,7 +866,7 @@ static int rd_DIRECT_do_se_mem_map(
 	u32 *task_offset_in)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 	u32 task_offset = *task_offset_in;
 	int ret;
 
@@ -991,9 +991,7 @@ static int rd_DIRECT_do_task(struct se_t
  */
 static void rd_free_task(struct se_task *task)
 {
-	struct rd_request *req = task->transport_req;
-
-	kfree(req);
+	kfree(RD_REQ(task));
 }
 
 static ssize_t rd_set_configfs_dev_params(
@@ -1118,7 +1116,7 @@ static void __rd_get_dev_info(struct rd_
 static void rd_map_task_non_SG(struct se_task *task)
 {
 	struct se_cmd *cmd = TASK_CMD(task);
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	req->rd_bufflen		= task->task_size;
 	req->rd_buf		= (void *) T_TASK(cmd)->t_task_buf;
@@ -1131,7 +1129,7 @@ static void rd_map_task_non_SG(struct se
  */
 static void rd_map_task_SG(struct se_task *task)
 {
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	req->rd_bufflen		= task->task_size;
 	req->rd_buf		= task->task_sg;
@@ -1144,7 +1142,7 @@ static void rd_map_task_SG(struct se_tas
  */
 static int rd_CDB_none(struct se_task *task, u32 size)
 {
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	req->rd_data_direction	= RD_DATA_NONE;
 	req->rd_bufflen		= 0;
@@ -1160,7 +1158,7 @@ static int rd_CDB_none(struct se_task *t
  */
 static int rd_CDB_read_non_SG(struct se_task *task, u32 size)
 {
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	req->rd_data_direction = RD_DATA_READ;
 	rd_map_task_non_SG(task);
@@ -1174,7 +1172,7 @@ static int rd_CDB_read_non_SG(struct se_
  */
 static int rd_CDB_read_SG(struct se_task *task, u32 size)
 {
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	req->rd_data_direction = RD_DATA_READ;
 	rd_map_task_SG(task);
@@ -1188,7 +1186,7 @@ static int rd_CDB_read_SG(struct se_task
  */
 static int rd_CDB_write_non_SG(struct se_task *task, u32 size)
 {
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	req->rd_data_direction = RD_DATA_WRITE;
 	rd_map_task_non_SG(task);
@@ -1202,7 +1200,7 @@ static int rd_CDB_write_non_SG(struct se
  */
 static int rd_CDB_write_SG(struct se_task *task, u32 size)
 {
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	req->rd_data_direction = RD_DATA_WRITE;
 	rd_map_task_SG(task);
@@ -1235,7 +1233,7 @@ static int rd_MEMCPY_check_lba(unsigned
  */
 static int rd_check_for_SG(struct se_task *task)
 {
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	return req->rd_sg_count;
 }
@@ -1246,7 +1244,7 @@ static int rd_check_for_SG(struct se_tas
  */
 static unsigned char *rd_get_cdb(struct se_task *task)
 {
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	return req->rd_scsi_cdb;
 }
@@ -1296,7 +1294,7 @@ static struct se_subsystem_api rd_dr_tem
 	.transport_complete	= rd_transport_complete,
 	.allocate_DMA		= rd_DIRECT_allocate_DMA,
 	.free_DMA		= rd_DIRECT_free_DMA,
-	.allocate_request	= rd_allocate_request,
+	.alloc_task		= rd_alloc_task,
 	.do_task		= rd_DIRECT_do_task,
 	.free_task		= rd_free_task,
 	.check_configfs_dev_params = rd_check_configfs_dev_params,
@@ -1330,7 +1328,7 @@ static struct se_subsystem_api rd_mcp_te
 	.create_virtdevice	= rd_MEMCPY_create_virtdevice,
 	.free_device		= rd_free_device,
 	.transport_complete	= rd_transport_complete,
-	.allocate_request	= rd_allocate_request,
+	.alloc_task		= rd_alloc_task,
 	.do_task		= rd_MEMCPY_do_task,
 	.free_task		= rd_free_task,
 	.check_configfs_dev_params = rd_check_configfs_dev_params,
Index: lio-core-2.6/drivers/target/target_core_rd.h
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_rd.h	2010-11-08 18:37:52.151529680 +0100
+++ lio-core-2.6/drivers/target/target_core_rd.h	2010-11-08 18:38:58.954863015 +0100
@@ -30,6 +30,8 @@ void rd_module_exit(void);
 #define RRF_GOT_LBA		0x02
 
 struct rd_request {
+	struct se_task	rd_task;
+
 	/* SCSI CDB from iSCSI Command PDU */
 	unsigned char	rd_scsi_cdb[TCM_MAX_COMMAND_SIZE];
 	/* Data Direction */
Index: lio-core-2.6/drivers/target/target_core_stgt.c
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_stgt.c	2010-11-08 18:39:50.574863012 +0100
+++ lio-core-2.6/drivers/target/target_core_stgt.c	2010-11-08 19:00:20.074863014 +0100
@@ -336,13 +336,19 @@ static void stgt_free_device(void *p)
 	kfree(sdv);
 }
 
+static inline struct stgt_plugin_task *STGT_TASK(struct se_task *task)
+{
+	return container_of(task, struct st_plugin_task, stgt_task);
+}
+
+
 /*	pscsi_transport_complete():
  *
  *
  */
 static int stgt_transport_complete(struct se_task *task)
 {
-	struct stgt_plugin_task *st = task->transport_req;
+	struct stgt_plugin_task *st = STGT_TASK(task);
 	int result;
 
 	result = st->stgt_result;
@@ -352,23 +358,18 @@ static int stgt_transport_complete(struc
 	return 0;
 }
 
-/*	stgt_allocate_request(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static void *stgt_allocate_request(
-	struct se_task *task,
-	struct se_device *dev)
+static struct se_task *
+stgt_alloc_task(struct se_cmd *cmd)
 {
 	struct stgt_plugin_task *st;
 
 	st = kzalloc(sizeof(struct stgt_plugin_task), GFP_KERNEL);
-	if (!(st)) {
+	if (!st) {
 		printk(KERN_ERR "Unable to allocate struct stgt_plugin_task\n");
 		return NULL;
 	}
 
-	return st;
+	return &st->stgt_task;
 }
 
 /*      stgt_do_task(): (Part of se_subsystem_api_t template)
@@ -377,7 +378,7 @@ static void *stgt_allocate_request(
  */
 static int stgt_do_task(struct se_task *task)
 {
-	struct stgt_plugin_task *st = task->transport_req;
+	struct stgt_plugin_task *st = STGT_TASK(task);
 	struct Scsi_Host *sh = task->se_dev->se_hba->hba_ptr;
 	struct scsi_cmnd *sc;
 	int tag = MSG_SIMPLE_TAG;
@@ -414,7 +415,7 @@ static int stgt_do_task(struct se_task *
  */
 static void stgt_free_task(struct se_task *task)
 {
-	struct stgt_plugin_task *st = (struct stgt_plugin_task *)task->transport_req;
+	struct stgt_plugin_task *st = STGT_TASK(task);
 
 	kfree(st);
 }
@@ -629,7 +630,7 @@ static int stgt_map_task_non_SG(struct s
 
 static int stgt_CDB_none(struct se_task *task, u32 size)
 {
-	struct stgt_plugin_task *st = task->transport_req;
+	struct stgt_plugin_task *st = STGT_TASK(task);
 
 	st->stgt_direction = DMA_NONE;
 	return 0;
@@ -641,7 +642,7 @@ static int stgt_CDB_none(struct se_task
  */
 static int stgt_CDB_read_non_SG(struct se_task *task, u32 size)
 {
-	struct stgt_plugin_task *pt = task->transport_req;
+	struct stgt_plugin_task *st = STGT_TASK(task);
 
 	pt->stgt_direction = DMA_FROM_DEVICE;
 	return stgt_map_task_non_SG(task);
@@ -653,7 +654,7 @@ static int stgt_CDB_read_non_SG(struct s
  */
 static int stgt_CDB_read_SG(struct se_task *task, u32 size)
 {
-	struct stgt_plugin_task *pt = task->transport_req;
+	struct stgt_plugin_task *st = STGT_TASK(task);
 
 	pt->stgt_direction = DMA_FROM_DEVICE;
 
@@ -669,7 +670,7 @@ static int stgt_CDB_read_SG(struct se_ta
  */
 static int stgt_CDB_write_non_SG(struct se_task *task, u32 size)
 {
-	struct stgt_plugin_task *pt = task->transport_req;
+	struct stgt_plugin_task *st = STGT_TASK(task);
 
 	pt->stgt_direction = DMA_TO_DEVICE;
 	return stgt_map_task_non_SG(task);
@@ -681,7 +682,7 @@ static int stgt_CDB_write_non_SG(struct
  */
 static int stgt_CDB_write_SG(struct se_task *task, u32 size)
 {
-	struct stgt_plugin_task *st = task->transport_req;
+	struct stgt_plugin_task *st = STGT_TASK(task);
 
 	st->stgt_direction = DMA_TO_DEVICE;
 
@@ -715,7 +716,7 @@ static int stgt_check_for_SG(struct se_t
  */
 static unsigned char *stgt_get_cdb(struct se_task *task)
 {
-	struct stgt_plugin_task *pt = task->transport_req;
+	struct stgt_plugin_task *st = STGT_TASK(task);
 
 	return pt->stgt_cdb;
 }
@@ -726,7 +727,7 @@ static unsigned char *stgt_get_cdb(struc
  */
 static unsigned char *stgt_get_sense_buffer(struct se_task *task)
 {
-	struct stgt_plugin_task *pt = task->transport_req;
+	struct stgt_plugin_task *st = STGT_TASK(task);
 
 	return (unsigned char *)&pt->stgt_sense[0];
 }
@@ -808,13 +809,12 @@ static int stgt_transfer_response(struct
 			   void (*done)(struct scsi_cmnd *))
 {
 	struct se_task *task = (struct se_task *)sc->SCp.ptr;
-	struct stgt_plugin_task *st;
+	struct stgt_plugin_task *st = STGT_TASK(task);
 
 	if (!task) {
 		printk(KERN_ERR "struct se_task is NULL!\n");
 		BUG();
 	}
-	st = (struct stgt_plugin_task *)task->transport_req;
 	if (!st) {
 		printk(KERN_ERR "struct stgt_plugin_task is NULL!\n");
 		BUG();
@@ -847,7 +847,7 @@ static struct se_subsystem_api stgt_temp
 	.create_virtdevice	= stgt_create_virtdevice,
 	.free_device		= stgt_free_device,
 	.transport_complete	= stgt_transport_complete,
-	.allocate_request	= stgt_allocate_request,
+	.alloc_task		= stgt_alloc_task,
 	.do_task		= stgt_do_task,
 	.free_task		= stgt_free_task,
 	.check_configfs_dev_params = stgt_check_configfs_dev_params,
Index: lio-core-2.6/drivers/target/target_core_stgt.h
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_stgt.h	2010-11-08 18:40:10.978196347 +0100
+++ lio-core-2.6/drivers/target/target_core_stgt.h	2010-11-08 18:41:10.054863013 +0100
@@ -20,6 +20,7 @@ extern struct se_global *se_global;
 #include <linux/kobject.h>
 
 struct stgt_plugin_task {
+	struct se_task stgt_task;
 	unsigned char stgt_cdb[TCM_MAX_COMMAND_SIZE];
 	unsigned char stgt_sense[SCSI_SENSE_BUFFERSIZE];
 	int	stgt_direction;
Index: lio-core-2.6/drivers/target/target_core_transport.c
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_transport.c	2010-11-08 18:32:16.114863012 +0100
+++ lio-core-2.6/drivers/target/target_core_transport.c	2010-11-08 19:03:08.344863013 +0100
@@ -189,7 +189,6 @@ struct se_global *se_global;
 EXPORT_SYMBOL(se_global);
 
 struct kmem_cache *se_cmd_cache;
-struct kmem_cache *se_task_cache;
 struct kmem_cache *se_tmr_req_cache;
 struct kmem_cache *se_sess_cache;
 struct kmem_cache *se_hba_cache;
@@ -279,12 +278,6 @@ int init_se_global(void)
 		printk(KERN_ERR "kmem_cache_create for struct se_cmd failed\n");
 		goto out;
 	}
-	se_task_cache = kmem_cache_create("se_task_cache",
-			sizeof(struct se_task), __alignof__(struct se_task), 0, NULL);
-	if (!(se_task_cache)) {
-		printk(KERN_ERR "kmem_cache_create for struct se_task failed\n");
-		goto out;
-	}
 	se_tmr_req_cache = kmem_cache_create("se_tmr_cache",
 			sizeof(struct se_tmr_req), __alignof__(struct se_tmr_req),
 			0, NULL);
@@ -371,8 +364,6 @@ int init_se_global(void)
 out:
 	if (se_cmd_cache)
 		kmem_cache_destroy(se_cmd_cache);
-	if (se_task_cache)
-		kmem_cache_destroy(se_task_cache);
 	if (se_tmr_req_cache)
 		kmem_cache_destroy(se_tmr_req_cache);
 	if (se_sess_cache)
@@ -406,7 +397,6 @@ void release_se_global(void)
 		return;
 
 	kmem_cache_destroy(se_cmd_cache);
-	kmem_cache_destroy(se_task_cache);
 	kmem_cache_destroy(se_tmr_req_cache);
 	kmem_cache_destroy(se_sess_cache);
 	kmem_cache_destroy(se_hba_cache);
@@ -2450,8 +2440,8 @@ static struct se_task *transport_generic
 	struct se_device *dev = SE_DEV(cmd);
 	unsigned long flags;
 
-	task = kmem_cache_zalloc(se_task_cache, GFP_KERNEL);
-	if (!(task)) {
+	task = dev->transport->alloc_task(cmd);
+	if (!task) {
 		printk(KERN_ERR "Unable to allocate struct se_task\n");
 		return NULL;
 	}
@@ -2466,12 +2456,6 @@ static struct se_task *transport_generic
 
 	DEBUG_SO("se_obj_ptr: %p\n", se_obj_ptr);
 
-	task->transport_req = TRANSPORT(dev)->allocate_request(task, dev);
-	if (!(task->transport_req)) {
-		kmem_cache_free(se_task_cache, task);
-		return NULL;
-	}
-
 	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
 	list_add_tail(&task->t_list, &T_TASK(cmd)->t_task_list);
 	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
@@ -5703,12 +5687,11 @@ void transport_free_dev_tasks(struct se_
 		if (atomic_read(&task->task_active))
 			continue;
 
-		if (!task->transport_req)
-			continue;
-
 		kfree(task->task_sg_bidi);
 		kfree(task->task_sg);
 
+		list_del(&task->t_list);
+
 		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 		if (task->se_dev)
 			TRANSPORT(task->se_dev)->free_task(task);
@@ -5716,9 +5699,6 @@ void transport_free_dev_tasks(struct se_
 			printk(KERN_ERR "task[%u] - task->se_dev is NULL\n",
 				task->task_no);
 		spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-
-		list_del(&task->t_list);
-		kmem_cache_free(se_task_cache, task);
 	}
 	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 }
Index: lio-core-2.6/include/target/target_core_transport.h
===================================================================
--- lio-core-2.6.orig/include/target/target_core_transport.h	2010-11-08 18:33:13.384863013 +0100
+++ lio-core-2.6/include/target/target_core_transport.h	2010-11-08 18:45:51.271529681 +0100
@@ -406,10 +406,7 @@ struct se_subsystem_api {
 	 * drivers.  Provided out of convenience.
 	 */
 	int (*transport_complete)(struct se_task *task);
-	/*
-	 * allocate_request():
-	 */
-	void *(*allocate_request)(struct se_task *, struct se_device *);
+	struct se_task *(*alloc_task)(struct se_cmd *);
 	/*
 	 * allocate_buf():
 	 */
Index: lio-core-2.6/include/target/target_core_base.h
===================================================================
--- lio-core-2.6.orig/include/target/target_core_base.h	2010-11-08 19:00:40.734863012 +0100
+++ lio-core-2.6/include/target/target_core_base.h	2010-11-08 19:01:10.851529680 +0100
@@ -472,7 +472,6 @@ struct se_task {
 	unsigned char	task_sense;
 	struct scatterlist *task_sg;
 	struct scatterlist *task_sg_bidi;
-	void		*transport_req;
 	u8		task_scsi_status;
 	u8		task_flags;
 	int		task_error_status;
