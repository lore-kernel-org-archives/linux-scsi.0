From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 099/103] target: change alloc_task call to take *cdb, not *cmd
Date: Thu, 21 Jul 2011 07:05:31 +0000
Message-ID: <1311231935-24635-100-git-send-email-nab@linux-iscsi.org>
References: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51704 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1GUH3l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2011 03:29:41 -0400
In-Reply-To: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

The transports really don't need the entire struct se_cmd to allocate
the memory for the se_task. If it wasn't for pscsi, they wouldn't even
need the *cdb.

Modify pscsi to allocate space for cdb at the end of pscsi_plugin_task,
instead of a separate allocation.

(nab: Fix bogus struct file assignments in fd_do_readv and fd_do_writev)

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c      |   10 ++++----
 drivers/target/target_core_file.h      |    2 -
 drivers/target/target_core_iblock.c    |    3 +-
 drivers/target/target_core_iblock.h    |    1 -
 drivers/target/target_core_pscsi.c     |   33 +++++--------------------------
 drivers/target/target_core_pscsi.h     |    3 +-
 drivers/target/target_core_rd.c        |    7 ++---
 drivers/target/target_core_rd.h        |    2 -
 drivers/target/target_core_transport.c |    2 +-
 include/target/target_core_transport.h |    2 +-
 10 files changed, 18 insertions(+), 47 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 60ee94e..bc1b336 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -257,7 +257,7 @@ static inline struct fd_request *FILE_REQ(struct se_task *task)
 
 
 static struct se_task *
-fd_alloc_task(struct se_cmd *cmd)
+fd_alloc_task(unsigned char *cdb)
 {
 	struct fd_request *fd_req;
 
@@ -267,15 +267,14 @@ fd_alloc_task(struct se_cmd *cmd)
 		return NULL;
 	}
 
-	fd_req->fd_dev = cmd->se_dev->dev_ptr;
-
 	return &fd_req->fd_task;
 }
 
 static int fd_do_readv(struct se_task *task)
 {
 	struct fd_request *req = FILE_REQ(task);
-	struct file *fd = req->fd_dev->fd_file;
+	struct fd_dev *dev = req->fd_task.se_dev->dev_ptr;
+	struct file *fd = dev->fd_file;
 	struct scatterlist *sg = task->task_sg;
 	struct iovec *iov;
 	mm_segment_t old_fs;
@@ -326,7 +325,8 @@ static int fd_do_readv(struct se_task *task)
 static int fd_do_writev(struct se_task *task)
 {
 	struct fd_request *req = FILE_REQ(task);
-	struct file *fd = req->fd_dev->fd_file;
+	struct fd_dev *dev = req->fd_task.se_dev->dev_ptr;
+	struct file *fd = dev->fd_file;
 	struct scatterlist *sg = task->task_sg;
 	struct iovec *iov;
 	mm_segment_t old_fs;
diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core_file.h
index 6386d3f..daebd71 100644
--- a/drivers/target/target_core_file.h
+++ b/drivers/target/target_core_file.h
@@ -16,8 +16,6 @@ struct fd_request {
 	struct se_task	fd_task;
 	/* SCSI CDB from iSCSI Command PDU */
 	unsigned char	fd_scsi_cdb[TCM_MAX_COMMAND_SIZE];
-	/* FILEIO device */
-	struct fd_dev	*fd_dev;
 } ____cacheline_aligned;
 
 #define FBDF_HAS_PATH		0x01
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 063f5a5..251fc66 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -221,7 +221,7 @@ static inline struct iblock_req *IBLOCK_REQ(struct se_task *task)
 }
 
 static struct se_task *
-iblock_alloc_task(struct se_cmd *cmd)
+iblock_alloc_task(unsigned char *cdb)
 {
 	struct iblock_req *ib_req;
 
@@ -231,7 +231,6 @@ iblock_alloc_task(struct se_cmd *cmd)
 		return NULL;
 	}
 
-	ib_req->ib_dev = cmd->se_dev->dev_ptr;
 	atomic_set(&ib_req->ib_bio_cnt, 0);
 	return &ib_req->ib_task;
 }
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 2aa1d27..a121cd1 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -12,7 +12,6 @@ struct iblock_req {
 	atomic_t ib_bio_cnt;
 	atomic_t ib_bio_err_cnt;
 	struct bio *ib_bio;
-	struct iblock_dev *ib_dev;
 } ____cacheline_aligned;
 
 #define IBDF_HAS_UDEV_PATH		0x01
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index ebc83ca..a2ce599 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -760,34 +760,20 @@ after_mode_select:
 }
 
 static struct se_task *
-pscsi_alloc_task(struct se_cmd *cmd)
+pscsi_alloc_task(unsigned char *cdb)
 {
 	struct pscsi_plugin_task *pt;
-	unsigned char *cdb = cmd->t_task_cdb;
 
-	pt = kzalloc(sizeof(struct pscsi_plugin_task), GFP_KERNEL);
+	/*
+	 * Dynamically alloc cdb space, since it may be larger than
+	 * TCM_MAX_COMMAND_SIZE
+	 */
+	pt = kzalloc(sizeof(*pt) + scsi_command_size(cdb), GFP_KERNEL);
 	if (!pt) {
 		pr_err("Unable to allocate struct pscsi_plugin_task\n");
 		return NULL;
 	}
 
-	/*
-	 * If TCM Core is signaling a > TCM_MAX_COMMAND_SIZE allocation,
-	 * allocate the extended CDB buffer for per struct se_task context
-	 * pt->pscsi_cdb now.
-	 */
-	if (cmd->t_task_cdb != cmd->__t_task_cdb) {
-
-		pt->pscsi_cdb = kzalloc(scsi_command_size(cdb), GFP_KERNEL);
-		if (!pt->pscsi_cdb) {
-			pr_err("pSCSI: Unable to allocate extended"
-					" pt->pscsi_cdb\n");
-			kfree(pt);
-			return NULL;
-		}
-	} else
-		pt->pscsi_cdb = &pt->__pscsi_cdb[0];
-
 	return &pt->pscsi_task;
 }
 
@@ -883,15 +869,8 @@ static int pscsi_do_task(struct se_task *task)
 static void pscsi_free_task(struct se_task *task)
 {
 	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
-	struct se_cmd *cmd = task->task_se_cmd;
 
 	/*
-	 * Release the extended CDB allocation from pscsi_alloc_task()
-	 * if one exists.
-	 */
-	if (cmd->t_task_cdb != cmd->__t_task_cdb)
-		kfree(pt->pscsi_cdb);
-	/*
 	 * We do not release the bio(s) here associated with this task, as
 	 * this is handled by bio_put() and pscsi_bi_endio().
 	 */
diff --git a/drivers/target/target_core_pscsi.h b/drivers/target/target_core_pscsi.h
index 280b689..ebf4f1a 100644
--- a/drivers/target/target_core_pscsi.h
+++ b/drivers/target/target_core_pscsi.h
@@ -23,13 +23,12 @@
 
 struct pscsi_plugin_task {
 	struct se_task pscsi_task;
-	unsigned char *pscsi_cdb;
-	unsigned char __pscsi_cdb[TCM_MAX_COMMAND_SIZE];
 	unsigned char pscsi_sense[SCSI_SENSE_BUFFERSIZE];
 	int	pscsi_direction;
 	int	pscsi_result;
 	u32	pscsi_resid;
 	struct request *pscsi_req;
+	unsigned char pscsi_cdb[0];
 } ____cacheline_aligned;
 
 #define PDF_HAS_CHANNEL_ID	0x01
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 5778bed..3dd81d2 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -309,7 +309,7 @@ static inline struct rd_request *RD_REQ(struct se_task *task)
 }
 
 static struct se_task *
-rd_alloc_task(struct se_cmd *cmd)
+rd_alloc_task(unsigned char *cdb)
 {
 	struct rd_request *rd_req;
 
@@ -318,7 +318,6 @@ rd_alloc_task(struct se_cmd *cmd)
 		pr_err("Unable to allocate struct rd_request\n");
 		return NULL;
 	}
-	rd_req->rd_dev = cmd->se_dev->dev_ptr;
 
 	return &rd_req->rd_task;
 }
@@ -352,7 +351,7 @@ static struct rd_dev_sg_table *rd_get_sg_table(struct rd_dev *rd_dev, u32 page)
 static int rd_MEMCPY_read(struct rd_request *req)
 {
 	struct se_task *task = &req->rd_task;
-	struct rd_dev *dev = req->rd_dev;
+	struct rd_dev *dev = req->rd_task.se_dev->dev_ptr;
 	struct rd_dev_sg_table *table;
 	struct scatterlist *sg_d, *sg_s;
 	void *dst, *src;
@@ -472,7 +471,7 @@ static int rd_MEMCPY_read(struct rd_request *req)
 static int rd_MEMCPY_write(struct rd_request *req)
 {
 	struct se_task *task = &req->rd_task;
-	struct rd_dev *dev = req->rd_dev;
+	struct rd_dev *dev = req->rd_task.se_dev->dev_ptr;
 	struct rd_dev_sg_table *table;
 	struct scatterlist *sg_d, *sg_s;
 	void *dst, *src;
diff --git a/drivers/target/target_core_rd.h b/drivers/target/target_core_rd.h
index bab9302..0d02773 100644
--- a/drivers/target/target_core_rd.h
+++ b/drivers/target/target_core_rd.h
@@ -32,8 +32,6 @@ struct rd_request {
 	u32		rd_page_count;
 	/* Scatterlist count */
 	u32		rd_size;
-	/* Ramdisk device */
-	struct rd_dev	*rd_dev;
 } ____cacheline_aligned;
 
 struct rd_dev_sg_table {
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5812756..55b6588 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1562,7 +1562,7 @@ transport_generic_get_task(struct se_cmd *cmd,
 	struct se_task *task;
 	struct se_device *dev = cmd->se_dev;
 
-	task = dev->transport->alloc_task(cmd);
+	task = dev->transport->alloc_task(cmd->t_task_cdb);
 	if (!task) {
 		pr_err("Unable to allocate struct se_task\n");
 		return NULL;
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 169b51e..7409576 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -292,7 +292,7 @@ struct se_subsystem_api {
 	 * drivers.  Provided out of convenience.
 	 */
 	int (*transport_complete)(struct se_task *task);
-	struct se_task *(*alloc_task)(struct se_cmd *);
+	struct se_task *(*alloc_task)(unsigned char *cdb);
 	/*
 	 * do_task():
 	 */
-- 
1.7.6

