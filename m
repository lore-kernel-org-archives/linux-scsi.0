From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: simplify and speed up task allocation
Date: Thu, 11 Nov 2010 01:48:00 -0800
Message-ID: <1289468880-26869-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm6-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.54]:44105 "HELO
	nm6-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752591Ab0KKJsF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 04:48:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

Allocate the se_task as part of the subsystem specific task, and remove the
task->transport_req pointer in favor of using container_of on the se_task.

Eventually we should move to a slab cache in each backend, but leave that
to a separate patch.

(Applied w/ a small typo fix causing a build failure in target_core_stgt.c)

Thanks hch!

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c      |   45 ++++++++++++------------
 drivers/target/target_core_file.h      |    1 +
 drivers/target/target_core_iblock.c    |   33 ++++++++----------
 drivers/target/target_core_iblock.h    |    1 +
 drivers/target/target_core_pscsi.c     |   58 +++++++++++++++----------------
 drivers/target/target_core_pscsi.h     |    1 +
 drivers/target/target_core_rd.c        |   54 ++++++++++++++---------------
 drivers/target/target_core_rd.h        |    2 +
 drivers/target/target_core_stgt.c      |   48 +++++++++++++-------------
 drivers/target/target_core_stgt.h      |    1 +
 drivers/target/target_core_transport.c |   28 ++-------------
 include/target/target_core_base.h      |    1 -
 include/target/target_core_transport.h |    5 +--
 13 files changed, 127 insertions(+), 151 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 2d72c08..217711f 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -282,13 +282,14 @@ static int fd_transport_complete(struct se_task *task)
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
 
@@ -298,9 +299,9 @@ static void *fd_allocate_request(
 		return NULL;
 	}
 
-	fd_req->fd_dev = dev->dev_ptr;
+	fd_req->fd_dev = SE_DEV(cmd)->dev_ptr;
 
-	return (void *)fd_req;
+	return &fd_req->fd_task;
 }
 
 static inline int fd_iovec_alloc(struct fd_request *req)
@@ -379,7 +380,7 @@ static static int fd_sendactor(
 {
 	unsigned long count = desc->count;
 	struct se_task *task = desc->arg.data;
-	struct fd_request *req = (struct fd_request *) task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 	struct scatterlist *sg = task->task_sg;
 
 	printk(KERN_INFO "page: %p offset: %lu size: %lu\n", page,
@@ -552,7 +553,7 @@ static int fd_do_task(struct se_task *task)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
 	struct se_device *dev = cmd->se_dev;
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 	int ret = 0;
 
 	req->fd_lba = task->task_lba;
@@ -598,7 +599,7 @@ static int fd_do_task(struct se_task *task)
  */
 static void fd_free_task(struct se_task *task)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	kfree(req->fd_iovs);
 	kfree(req);
@@ -727,7 +728,7 @@ static ssize_t fd_show_configfs_dev_params(
 static void fd_map_task_non_SG(struct se_task *task)
 {
 	struct se_cmd *cmd = TASK_CMD(task);
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	req->fd_bufflen		= task->task_size;
 	req->fd_buf		= (void *) T_TASK(cmd)->t_task_buf;
@@ -740,7 +741,7 @@ static void fd_map_task_non_SG(struct se_task *task)
  */
 static void fd_map_task_SG(struct se_task *task)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	req->fd_bufflen		= task->task_size;
 	req->fd_buf		= NULL;
@@ -753,7 +754,7 @@ static void fd_map_task_SG(struct se_task *task)
  */
 static int fd_CDB_none(struct se_task *task, u32 size)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	req->fd_data_direction	= FD_DATA_NONE;
 	req->fd_bufflen		= 0;
@@ -769,7 +770,7 @@ static int fd_CDB_none(struct se_task *task, u32 size)
  */
 static int fd_CDB_read_non_SG(struct se_task *task, u32 size)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	req->fd_data_direction = FD_DATA_READ;
 	fd_map_task_non_SG(task);
@@ -783,7 +784,7 @@ static int fd_CDB_read_non_SG(struct se_task *task, u32 size)
  */
 static int fd_CDB_read_SG(struct se_task *task, u32 size)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	req->fd_data_direction = FD_DATA_READ;
 	fd_map_task_SG(task);
@@ -797,7 +798,7 @@ static int fd_CDB_read_SG(struct se_task *task, u32 size)
  */
 static int fd_CDB_write_non_SG(struct se_task *task, u32 size)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	req->fd_data_direction = FD_DATA_WRITE;
 	fd_map_task_non_SG(task);
@@ -811,7 +812,7 @@ static int fd_CDB_write_non_SG(struct se_task *task, u32 size)
  */
 static int fd_CDB_write_SG(struct se_task *task, u32 size)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	req->fd_data_direction = FD_DATA_WRITE;
 	fd_map_task_SG(task);
@@ -834,7 +835,7 @@ static int fd_check_lba(unsigned long long lba, struct se_device *dev)
  */
 static int fd_check_for_SG(struct se_task *task)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	return req->fd_sg_count;
 }
@@ -845,7 +846,7 @@ static int fd_check_for_SG(struct se_task *task)
  */
 static unsigned char *fd_get_cdb(struct se_task *task)
 {
-	struct fd_request *req = task->transport_req;
+	struct fd_request *req = FILE_REQ(task);
 
 	return req->fd_scsi_cdb;
 }
@@ -906,7 +907,7 @@ static struct se_subsystem_api fileio_template = {
 	.fua_read_emulated	= fd_emulated_fua_read,
 	.write_cache_emulated	= fd_emulated_write_cache,
 	.transport_complete	= fd_transport_complete,
-	.allocate_request	= fd_allocate_request,
+	.alloc_task		= fd_alloc_task,
 	.do_task		= fd_do_task,
 	.do_sync_cache		= fd_emulate_sync_cache,
 	.free_task		= fd_free_task,
diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core_file.h
index 2780e49..bb783f5 100644
--- a/drivers/target/target_core_file.h
+++ b/drivers/target/target_core_file.h
@@ -21,6 +21,7 @@ extern struct se_global *se_global;
 #define RRF_GOT_LBA		0x02
 
 struct fd_request {
+	struct se_task	fd_task;
 	/* SCSI CDB from iSCSI Command PDU */
 	unsigned char	fd_scsi_cdb[TCM_MAX_COMMAND_SIZE];
 	/* Data Direction */
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index c182cc7..3a1a8b0 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -243,13 +243,13 @@ static int iblock_transport_complete(struct se_task *task)
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
 
@@ -259,9 +259,9 @@ static void *iblock_allocate_request(
 		return NULL;
 	}
 
-	ib_req->ib_dev = dev->dev_ptr;
+	ib_req->ib_dev = SE_DEV(cmd)->dev_ptr;
 	atomic_set(&ib_req->ib_bio_cnt, 0);
-	return ib_req;
+	return &ib_req->ib_task;
 }
 
 static unsigned long long iblock_emulate_read_cap_with_block_size(
@@ -407,7 +407,7 @@ int iblock_emulated_fua_read(struct se_device *dev)
 static int iblock_do_task(struct se_task *task)
 {
 	struct se_device *dev = task->task_se_cmd->se_dev;
-	struct iblock_req *req = (struct iblock_req *)task->transport_req;
+	struct iblock_req *req = IBLOCK_REQ(task);
 	struct iblock_dev *ibd = (struct iblock_dev *)req->ib_dev;
 	struct request_queue *q = bdev_get_queue(ibd->ibd_bd);
 	struct bio *bio = req->ib_bio, *nbio = NULL;
@@ -454,7 +454,7 @@ static int iblock_do_discard(struct se_device *dev, sector_t lba, u32 range)
 
 static void iblock_free_task(struct se_task *task)
 {
-	struct iblock_req *req = task->transport_req;
+	struct iblock_req *req = IBLOCK_REQ(task);
 	struct bio *bio, *hbio = req->ib_bio;
 	/*
 	 * We only release the bio(s) here if iblock_bio_done() has not called
@@ -468,7 +468,6 @@ static void iblock_free_task(struct se_task *task)
 	}
 
 	kfree(req);
-	task->transport_req = NULL;
 }
 
 enum {
@@ -639,7 +638,7 @@ static int iblock_map_task_SG(struct se_task *task)
 	struct se_cmd *cmd = task->task_se_cmd;
 	struct se_device *dev = SE_DEV(cmd);
 	struct iblock_dev *ib_dev = task->se_dev->dev_ptr;
-	struct iblock_req *ib_req = task->transport_req;
+	struct iblock_req *ib_req = IBLOCK_REQ(task);
 	struct bio *bio = NULL, *hbio = NULL, *tbio = NULL;
 	struct scatterlist *sg;
 	int ret = 0;
@@ -759,9 +758,7 @@ static int iblock_check_for_SG(struct se_task *task)
 
 static unsigned char *iblock_get_cdb(struct se_task *task)
 {
-	struct iblock_req *req = task->transport_req;
-
-	return req->ib_scsi_cdb;
+	return IBLOCK_REQ(task)->ib_scsi_cdb;
 }
 
 static u32 iblock_get_device_rev(struct se_device *dev)
@@ -791,7 +788,7 @@ static sector_t iblock_get_blocks(struct se_device *dev)
 static void iblock_bio_done(struct bio *bio, int err)
 {
 	struct se_task *task = bio->bi_private;
-	struct iblock_req *ibr = task->transport_req;
+	struct iblock_req *ibr = IBLOCK_REQ(task);
 	/*
 	 * Set -EIO if !BIO_UPTODATE and the passed is still err=0
 	 */
@@ -856,7 +853,7 @@ static struct se_subsystem_api iblock_template = {
 	.fua_read_emulated	= iblock_emulated_fua_read,
 	.write_cache_emulated	= iblock_emulated_write_cache,
 	.transport_complete	= iblock_transport_complete,
-	.allocate_request	= iblock_allocate_request,
+	.alloc_task		= iblock_alloc_task,
 	.do_task		= iblock_do_task,
 	.do_discard		= iblock_do_discard,
 	.do_sync_cache		= iblock_emulate_sync_cache,
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 0d1480f..db19984 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -12,6 +12,7 @@
 extern struct se_global *se_global;
 
 struct iblock_req {
+	struct se_task ib_task;
 	unsigned char ib_scsi_cdb[TCM_MAX_COMMAND_SIZE];
 	atomic_t ib_bio_cnt;
 	atomic_t ib_bio_err_cnt;
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 6f86175..d11957f 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -573,6 +573,12 @@ static void pscsi_free_device(void *p)
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
@@ -582,7 +588,7 @@ static int pscsi_transport_complete(struct se_task *task)
 	struct pscsi_dev_virt *pdv = task->se_dev->dev_ptr;
 	struct scsi_device *sd = pdv->pdv_sd;
 	int result;
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 	unsigned char *cdb = &pt->pscsi_cdb[0];
 
 	result = pt->pscsi_result;
@@ -660,23 +666,18 @@ after_mode_select:
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
@@ -693,7 +694,7 @@ static void *pscsi_allocate_request(
 	} else
 		pt->pscsi_cdb = &pt->__pscsi_cdb[0];
 
-	return pt;
+	return &pt->pscsi_task;
 }
 
 static inline void pscsi_blk_init_request(
@@ -736,7 +737,7 @@ static inline void pscsi_blk_init_request(
 */
 static int pscsi_blk_get_request(struct se_task *task)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 	struct pscsi_dev_virt *pdv = task->se_dev->dev_ptr;
 
 	pt->pscsi_req = blk_get_request(pdv->pdv_sd->request_queue,
@@ -760,7 +761,7 @@ static int pscsi_blk_get_request(struct se_task *task)
  */
 static int pscsi_do_task(struct se_task *task)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 	struct pscsi_dev_virt *pdv = task->se_dev->dev_ptr;
 	/*
 	 * Set the struct request->timeout value based on peripheral
@@ -784,16 +785,13 @@ static int pscsi_do_task(struct se_task *task)
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 }
 
-/*	pscsi_free_task(): (Part of se_subsystem_api_t template)
- *
- *
- */
 static void pscsi_free_task(struct se_task *task)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 	struct se_cmd *cmd = task->task_se_cmd;
+
 	/*
-	 * Release the extended CDB allocation from pscsi_allocate_request()
+	 * Release the extended CDB allocation from pscsi_alloc_task()
 	 * if one exists.
 	 */
 	if (T_TASK(cmd)->t_task_cdb != T_TASK(cmd)->__t_task_cdb)
@@ -1006,7 +1004,7 @@ static int __pscsi_map_task_SG(
 	u32 task_sg_num,
 	int bidi_read)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 	struct pscsi_dev_virt *pdv = task->se_dev->dev_ptr;
 	struct bio *bio = NULL, *hbio = NULL, *tbio = NULL;
 	struct page *page;
@@ -1177,7 +1175,7 @@ static int pscsi_map_task_SG(struct se_task *task)
 static int pscsi_map_task_non_SG(struct se_task *task)
 {
 	struct se_cmd *cmd = TASK_CMD(task);
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 	struct pscsi_dev_virt *pdv = task->se_dev->dev_ptr;
 	int ret = 0;
 
@@ -1196,7 +1194,7 @@ static int pscsi_map_task_non_SG(struct se_task *task)
 
 static int pscsi_CDB_none(struct se_task *task, u32 size)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 
 	pt->pscsi_direction = DMA_NONE;
 
@@ -1209,7 +1207,7 @@ static int pscsi_CDB_none(struct se_task *task, u32 size)
  */
 static int pscsi_CDB_read_non_SG(struct se_task *task, u32 size)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 
 	pt->pscsi_direction = DMA_FROM_DEVICE;
 
@@ -1225,7 +1223,7 @@ static int pscsi_CDB_read_non_SG(struct se_task *task, u32 size)
  */
 static int pscsi_CDB_read_SG(struct se_task *task, u32 size)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 
 	pt->pscsi_direction = DMA_FROM_DEVICE;
 	/*
@@ -1244,7 +1242,7 @@ static int pscsi_CDB_read_SG(struct se_task *task, u32 size)
  */
 static int pscsi_CDB_write_non_SG(struct se_task *task, u32 size)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 
 	pt->pscsi_direction = DMA_TO_DEVICE;
 
@@ -1260,7 +1258,7 @@ static int pscsi_CDB_write_non_SG(struct se_task *task, u32 size)
  */
 static int pscsi_CDB_write_SG(struct se_task *task, u32 size)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 
 	pt->pscsi_direction = DMA_TO_DEVICE;
 	/*
@@ -1297,7 +1295,7 @@ static int pscsi_check_for_SG(struct se_task *task)
  */
 static unsigned char *pscsi_get_cdb(struct se_task *task)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 
 	return pt->pscsi_cdb;
 }
@@ -1308,7 +1306,7 @@ static unsigned char *pscsi_get_cdb(struct se_task *task)
  */
 static unsigned char *pscsi_get_sense_buffer(struct se_task *task)
 {
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 
 	return (unsigned char *)&pt->pscsi_sense[0];
 }
@@ -1384,7 +1382,7 @@ static inline void pscsi_process_SAM_status(
 static void pscsi_req_done(struct request *req, int uptodate)
 {
 	struct se_task *task = req->end_io_data;
-	struct pscsi_plugin_task *pt = task->transport_req;
+	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 
 	pt->pscsi_result = req->errors;
 	pt->pscsi_resid = req->resid_len;
@@ -1417,7 +1415,7 @@ static struct se_subsystem_api pscsi_template = {
 	.create_virtdevice	= pscsi_create_virtdevice,
 	.free_device		= pscsi_free_device,
 	.transport_complete	= pscsi_transport_complete,
-	.allocate_request	= pscsi_allocate_request,
+	.alloc_task		= pscsi_alloc_task,
 	.do_task		= pscsi_do_task,
 	.free_task		= pscsi_free_task,
 	.check_configfs_dev_params = pscsi_check_configfs_dev_params,
diff --git a/drivers/target/target_core_pscsi.h b/drivers/target/target_core_pscsi.h
index 8d812fb..5d26bc3 100644
--- a/drivers/target/target_core_pscsi.h
+++ b/drivers/target/target_core_pscsi.h
@@ -25,6 +25,7 @@ extern struct se_global *se_global;
 #include <linux/kobject.h>
 
 struct pscsi_plugin_task {
+	struct se_task pscsi_task;
 	unsigned char *pscsi_cdb;
 	unsigned char __pscsi_cdb[TCM_MAX_COMMAND_SIZE];
 	unsigned char pscsi_sense[SCSI_SENSE_BUFFERSIZE];
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index d21ef0f..981098a 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -349,24 +349,24 @@ static int rd_transport_complete(struct se_task *task)
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
@@ -642,7 +642,7 @@ static int rd_MEMCPY_write(struct rd_request *req)
 static int rd_MEMCPY_do_task(struct se_task *task)
 {
 	struct se_device *dev = task->se_dev;
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 	int ret;
 
 	req->rd_lba = task->task_lba;
@@ -676,7 +676,7 @@ static int rd_DIRECT_with_offset(
 	u32 *se_mem_cnt,
 	u32 *task_offset)
 {
-	struct rd_request *req = (struct rd_request *)task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 	struct rd_dev *dev = req->rd_dev;
 	struct rd_dev_sg_table *table;
 	struct se_mem *se_mem;
@@ -779,7 +779,7 @@ static int rd_DIRECT_without_offset(
 	u32 *se_mem_cnt,
 	u32 *task_offset)
 {
-	struct rd_request *req = (struct rd_request *)task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 	struct rd_dev *dev = req->rd_dev;
 	struct rd_dev_sg_table *table;
 	struct se_mem *se_mem;
@@ -864,7 +864,7 @@ static int rd_DIRECT_do_se_mem_map(
 	u32 *task_offset_in)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 	u32 task_offset = *task_offset_in;
 	int ret;
 
@@ -986,9 +986,7 @@ static int rd_DIRECT_do_task(struct se_task *task)
  */
 static void rd_free_task(struct se_task *task)
 {
-	struct rd_request *req = task->transport_req;
-
-	kfree(req);
+	kfree(RD_REQ(task));
 }
 
 enum {
@@ -1091,7 +1089,7 @@ static ssize_t rd_show_configfs_dev_params(
 static void rd_map_task_non_SG(struct se_task *task)
 {
 	struct se_cmd *cmd = TASK_CMD(task);
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	req->rd_bufflen		= task->task_size;
 	req->rd_buf		= (void *) T_TASK(cmd)->t_task_buf;
@@ -1104,7 +1102,7 @@ static void rd_map_task_non_SG(struct se_task *task)
  */
 static void rd_map_task_SG(struct se_task *task)
 {
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	req->rd_bufflen		= task->task_size;
 	req->rd_buf		= task->task_sg;
@@ -1117,7 +1115,7 @@ static void rd_map_task_SG(struct se_task *task)
  */
 static int rd_CDB_none(struct se_task *task, u32 size)
 {
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	req->rd_data_direction	= RD_DATA_NONE;
 	req->rd_bufflen		= 0;
@@ -1133,7 +1131,7 @@ static int rd_CDB_none(struct se_task *task, u32 size)
  */
 static int rd_CDB_read_non_SG(struct se_task *task, u32 size)
 {
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	req->rd_data_direction = RD_DATA_READ;
 	rd_map_task_non_SG(task);
@@ -1147,7 +1145,7 @@ static int rd_CDB_read_non_SG(struct se_task *task, u32 size)
  */
 static int rd_CDB_read_SG(struct se_task *task, u32 size)
 {
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	req->rd_data_direction = RD_DATA_READ;
 	rd_map_task_SG(task);
@@ -1161,7 +1159,7 @@ static int rd_CDB_read_SG(struct se_task *task, u32 size)
  */
 static int rd_CDB_write_non_SG(struct se_task *task, u32 size)
 {
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	req->rd_data_direction = RD_DATA_WRITE;
 	rd_map_task_non_SG(task);
@@ -1175,7 +1173,7 @@ static int rd_CDB_write_non_SG(struct se_task *task, u32 size)
  */
 static int rd_CDB_write_SG(struct se_task *task, u32 size)
 {
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	req->rd_data_direction = RD_DATA_WRITE;
 	rd_map_task_SG(task);
@@ -1208,7 +1206,7 @@ static int rd_MEMCPY_check_lba(unsigned long long lba, struct se_device *dev)
  */
 static int rd_check_for_SG(struct se_task *task)
 {
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	return req->rd_sg_count;
 }
@@ -1219,7 +1217,7 @@ static int rd_check_for_SG(struct se_task *task)
  */
 static unsigned char *rd_get_cdb(struct se_task *task)
 {
-	struct rd_request *req = task->transport_req;
+	struct rd_request *req = RD_REQ(task);
 
 	return req->rd_scsi_cdb;
 }
@@ -1269,7 +1267,7 @@ static struct se_subsystem_api rd_dr_template = {
 	.transport_complete	= rd_transport_complete,
 	.allocate_DMA		= rd_DIRECT_allocate_DMA,
 	.free_DMA		= rd_DIRECT_free_DMA,
-	.allocate_request	= rd_allocate_request,
+	.alloc_task		= rd_alloc_task,
 	.do_task		= rd_DIRECT_do_task,
 	.free_task		= rd_free_task,
 	.check_configfs_dev_params = rd_check_configfs_dev_params,
@@ -1302,7 +1300,7 @@ static struct se_subsystem_api rd_mcp_template = {
 	.create_virtdevice	= rd_MEMCPY_create_virtdevice,
 	.free_device		= rd_free_device,
 	.transport_complete	= rd_transport_complete,
-	.allocate_request	= rd_allocate_request,
+	.alloc_task		= rd_alloc_task,
 	.do_task		= rd_MEMCPY_do_task,
 	.free_task		= rd_free_task,
 	.check_configfs_dev_params = rd_check_configfs_dev_params,
diff --git a/drivers/target/target_core_rd.h b/drivers/target/target_core_rd.h
index 2008807..bdc16f8 100644
--- a/drivers/target/target_core_rd.h
+++ b/drivers/target/target_core_rd.h
@@ -30,6 +30,8 @@ void rd_module_exit(void);
 #define RRF_GOT_LBA		0x02
 
 struct rd_request {
+	struct se_task	rd_task;
+
 	/* SCSI CDB from iSCSI Command PDU */
 	unsigned char	rd_scsi_cdb[TCM_MAX_COMMAND_SIZE];
 	/* Data Direction */
diff --git a/drivers/target/target_core_stgt.c b/drivers/target/target_core_stgt.c
index ee8eb9a..004173b 100644
--- a/drivers/target/target_core_stgt.c
+++ b/drivers/target/target_core_stgt.c
@@ -336,13 +336,19 @@ static void stgt_free_device(void *p)
 	kfree(sdv);
 }
 
+static inline struct stgt_plugin_task *STGT_TASK(struct se_task *task)
+{
+	return container_of(task, struct stgt_plugin_task, stgt_task);
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
@@ -352,23 +358,18 @@ static int stgt_transport_complete(struct se_task *task)
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
@@ -414,7 +415,7 @@ static int stgt_do_task(struct se_task *task)
  */
 static void stgt_free_task(struct se_task *task)
 {
-	struct stgt_plugin_task *st = (struct stgt_plugin_task *)task->transport_req;
+	struct stgt_plugin_task *st = STGT_TASK(task);
 
 	kfree(st);
 }
@@ -550,9 +551,9 @@ static int stgt_map_task_non_SG(struct se_task *task)
 
 static int stgt_CDB_none(struct se_task *task, u32 size)
 {
-	struct stgt_plugin_task *st = task->transport_req;
+	struct stgt_plugin_task *pt = STGT_TASK(task);
 
-	st->stgt_direction = DMA_NONE;
+	pt->stgt_direction = DMA_NONE;
 	return 0;
 }
 
@@ -562,7 +563,7 @@ static int stgt_CDB_none(struct se_task *task, u32 size)
  */
 static int stgt_CDB_read_non_SG(struct se_task *task, u32 size)
 {
-	struct stgt_plugin_task *pt = task->transport_req;
+	struct stgt_plugin_task *pt = STGT_TASK(task);
 
 	pt->stgt_direction = DMA_FROM_DEVICE;
 	return stgt_map_task_non_SG(task);
@@ -574,7 +575,7 @@ static int stgt_CDB_read_non_SG(struct se_task *task, u32 size)
  */
 static int stgt_CDB_read_SG(struct se_task *task, u32 size)
 {
-	struct stgt_plugin_task *pt = task->transport_req;
+	struct stgt_plugin_task *pt = STGT_TASK(task);
 
 	pt->stgt_direction = DMA_FROM_DEVICE;
 
@@ -590,7 +591,7 @@ static int stgt_CDB_read_SG(struct se_task *task, u32 size)
  */
 static int stgt_CDB_write_non_SG(struct se_task *task, u32 size)
 {
-	struct stgt_plugin_task *pt = task->transport_req;
+	struct stgt_plugin_task *pt = STGT_TASK(task);
 
 	pt->stgt_direction = DMA_TO_DEVICE;
 	return stgt_map_task_non_SG(task);
@@ -602,9 +603,9 @@ static int stgt_CDB_write_non_SG(struct se_task *task, u32 size)
  */
 static int stgt_CDB_write_SG(struct se_task *task, u32 size)
 {
-	struct stgt_plugin_task *st = task->transport_req;
+	struct stgt_plugin_task *pt = STGT_TASK(task);
 
-	st->stgt_direction = DMA_TO_DEVICE;
+	pt->stgt_direction = DMA_TO_DEVICE;
 
 	if (stgt_map_task_SG(task) < 0)
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
@@ -636,7 +637,7 @@ static int stgt_check_for_SG(struct se_task *task)
  */
 static unsigned char *stgt_get_cdb(struct se_task *task)
 {
-	struct stgt_plugin_task *pt = task->transport_req;
+	struct stgt_plugin_task *pt = STGT_TASK(task);
 
 	return pt->stgt_cdb;
 }
@@ -647,7 +648,7 @@ static unsigned char *stgt_get_cdb(struct se_task *task)
  */
 static unsigned char *stgt_get_sense_buffer(struct se_task *task)
 {
-	struct stgt_plugin_task *pt = task->transport_req;
+	struct stgt_plugin_task *pt = STGT_TASK(task);
 
 	return (unsigned char *)&pt->stgt_sense[0];
 }
@@ -729,13 +730,12 @@ static int stgt_transfer_response(struct scsi_cmnd *sc,
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
@@ -768,7 +768,7 @@ static struct se_subsystem_api stgt_template = {
 	.create_virtdevice	= stgt_create_virtdevice,
 	.free_device		= stgt_free_device,
 	.transport_complete	= stgt_transport_complete,
-	.allocate_request	= stgt_allocate_request,
+	.alloc_task		= stgt_alloc_task,
 	.do_task		= stgt_do_task,
 	.free_task		= stgt_free_task,
 	.check_configfs_dev_params = stgt_check_configfs_dev_params,
diff --git a/drivers/target/target_core_stgt.h b/drivers/target/target_core_stgt.h
index 399d91a..69c17ba 100644
--- a/drivers/target/target_core_stgt.h
+++ b/drivers/target/target_core_stgt.h
@@ -20,6 +20,7 @@ extern struct se_global *se_global;
 #include <linux/kobject.h>
 
 struct stgt_plugin_task {
+	struct se_task stgt_task;
 	unsigned char stgt_cdb[TCM_MAX_COMMAND_SIZE];
 	unsigned char stgt_sense[SCSI_SENSE_BUFFERSIZE];
 	int	stgt_direction;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f8d6605..fe80804 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -189,7 +189,6 @@ struct se_global *se_global;
 EXPORT_SYMBOL(se_global);
 
 struct kmem_cache *se_cmd_cache;
-struct kmem_cache *se_task_cache;
 struct kmem_cache *se_tmr_req_cache;
 struct kmem_cache *se_sess_cache;
 struct kmem_cache *se_hba_cache;
@@ -280,12 +279,6 @@ int init_se_global(void)
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
@@ -372,8 +365,6 @@ int init_se_global(void)
 out:
 	if (se_cmd_cache)
 		kmem_cache_destroy(se_cmd_cache);
-	if (se_task_cache)
-		kmem_cache_destroy(se_task_cache);
 	if (se_tmr_req_cache)
 		kmem_cache_destroy(se_tmr_req_cache);
 	if (se_sess_cache)
@@ -407,7 +398,6 @@ void release_se_global(void)
 		return;
 
 	kmem_cache_destroy(se_cmd_cache);
-	kmem_cache_destroy(se_task_cache);
 	kmem_cache_destroy(se_tmr_req_cache);
 	kmem_cache_destroy(se_sess_cache);
 	kmem_cache_destroy(se_hba_cache);
@@ -2337,8 +2327,8 @@ static struct se_task *transport_generic_get_task(
 	struct se_device *dev = SE_DEV(cmd);
 	unsigned long flags;
 
-	task = kmem_cache_zalloc(se_task_cache, GFP_KERNEL);
-	if (!(task)) {
+	task = dev->transport->alloc_task(cmd);
+	if (!task) {
 		printk(KERN_ERR "Unable to allocate struct se_task\n");
 		return NULL;
 	}
@@ -2353,12 +2343,6 @@ static struct se_task *transport_generic_get_task(
 
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
@@ -5599,12 +5583,11 @@ void transport_free_dev_tasks(struct se_cmd *cmd)
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
@@ -5612,9 +5595,6 @@ void transport_free_dev_tasks(struct se_cmd *cmd)
 			printk(KERN_ERR "task[%u] - task->se_dev is NULL\n",
 				task->task_no);
 		spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-
-		list_del(&task->t_list);
-		kmem_cache_free(se_task_cache, task);
 	}
 	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 49af478..0e434d7 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -477,7 +477,6 @@ struct se_task {
 	unsigned char	task_sense;
 	struct scatterlist *task_sg;
 	struct scatterlist *task_sg_bidi;
-	void		*transport_req;
 	u8		task_scsi_status;
 	u8		task_flags;
 	int		task_error_status;
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index a5be392..ce04b51 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -397,10 +397,7 @@ struct se_subsystem_api {
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
-- 
1.5.6.5

