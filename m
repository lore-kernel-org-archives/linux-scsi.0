From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod]: Update PSCSI, IBLOCK, FILEIO and
	RAMDISK for se_task_t->task_sg
Date: Tue, 02 Dec 2008 18:15:16 -0800
Message-ID: <1228270516.6229.139.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:22617 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753245AbYLCCPT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2008 21:15:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>

>From e030ca2b9bbb81402b3ed669bb5e1d54fed0dff7 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 2 Dec 2008 18:07:40 -0800
Subject: [PATCH] [Target_Core_Mod]: Update PSCSI, IBLOCK, FILEIO and RAMDISK for se_task_t->task_sg

This patch changes the generic target core subsystem plugins to use se_task_t->task_sg
and gets rid of a handful of casts from the original se_task_t->task_buf, which if present,
will always contain a contigious array of struct scatterlist memory.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_file.c   |   12 ++++++------
 drivers/lio-core/target_core_iblock.c |    4 ++--
 drivers/lio-core/target_core_pscsi.c  |   11 ++++-------
 drivers/lio-core/target_core_rd.c     |    2 +-
 4 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/lio-core/target_core_file.c b/drivers/lio-core/target_core_file.c
index 5b9b5dd..be1314d 100644
--- a/drivers/lio-core/target_core_file.c
+++ b/drivers/lio-core/target_core_file.c
@@ -586,7 +586,7 @@ static int fd_do_readv (fd_request_t *req, se_task_t *task)
 	u32 i;
 	mm_segment_t old_fs;
 	struct file *fd = req->fd_dev->fd_file;
-	struct scatterlist *sg = (struct scatterlist *) req->fd_buf;
+	struct scatterlist *sg = task->task_sg;
 	struct iovec iov[req->fd_sg_count];	
 
 	memset(iov, 0, sizeof(struct iovec) + req->fd_sg_count);
@@ -638,7 +638,7 @@ static int fd_do_aio_read (fd_request_t *req, se_task_t *task)
 	unsigned long long offset, lba = req->fd_lba;;
 	mm_segment_t old_fs;
 	struct file *fd = req->fd_dev->fd_file;
-	struct scatterlist *sg = (struct scatterlist *) req->fd_buf;
+	struct scatterlist *sg = task->task_sg;
 	struct iovec *iov;
 	struct kiocb	*iocb;
 
@@ -716,7 +716,7 @@ static int fd_sendactor (read_descriptor_t * desc, struct page *page, unsigned l
 	unsigned long count = desc->count;
 	se_task_t *task = desc->arg.data;
 	fd_request_t *req = (fd_request_t *) task->transport_req;	
-	struct scatterlist *sg = (struct scatterlist *) req->fd_buf;
+	struct scatterlist *sg = task->task_sg;
 
 //	PYXPRINT("page: %p offset: %lu size: %lu\n", page, offset, size);
 
@@ -767,7 +767,7 @@ static int fd_do_writev (fd_request_t *req, se_task_t *task)
 	int ret = 0;
 	u32 i;
 	struct file *fd = req->fd_dev->fd_file;
-	struct scatterlist *sg = (struct scatterlist *) req->fd_buf;
+	struct scatterlist *sg = task->task_sg;
 	mm_segment_t old_fs;
 	struct iovec iov[req->fd_sg_count];
 
@@ -803,7 +803,7 @@ static int fd_do_aio_write (fd_request_t *req, se_task_t *task)
 	unsigned long long offset, lba = req->fd_lba;
 	mm_segment_t old_fs;
 	struct file *fd = req->fd_dev->fd_file;
-	struct scatterlist *sg = (struct scatterlist *) req->fd_buf;
+	struct scatterlist *sg = task->task_sg;
 	struct iovec *iov;
 	struct kiocb    *iocb;
 
@@ -1065,7 +1065,7 @@ extern void fd_map_task_SG (se_task_t *task)
 	fd_request_t *req = (fd_request_t *) task->transport_req;
 
 	req->fd_bufflen		= task->task_size;
-	req->fd_buf		= (void *)task->task_buf;
+	req->fd_buf		= NULL;
 	req->fd_sg_count	= task->task_sg_num;
 
 	return;
diff --git a/drivers/lio-core/target_core_iblock.c b/drivers/lio-core/target_core_iblock.c
index 50e2a2a..962dc35 100644
--- a/drivers/lio-core/target_core_iblock.c
+++ b/drivers/lio-core/target_core_iblock.c
@@ -755,7 +755,7 @@ extern int iblock_map_task_SG (se_task_t *task)
 	iblock_dev_t *ib_dev = (iblock_dev_t *) task->iscsi_dev->dev_ptr;
 	iblock_req_t *ib_req = (iblock_req_t *) task->transport_req;
 	struct bio *bio = NULL, *hbio = NULL, *tbio = NULL;
-	struct scatterlist *sg = (struct scatterlist *)task->task_buf;
+	struct scatterlist *sg = task->task_sg;
 	int ret = 0;
 	u32 i, sg_num = task->task_sg_num;
 	u64 lba = task->task_lba;
@@ -769,7 +769,7 @@ extern int iblock_map_task_SG (se_task_t *task)
 	hbio = tbio = bio;
 	/*
 	 * Use fs/bio.c:bio_add_pages() to setup the bio_vec maplist
-	 * from LIO-SE se_mem_t -> task->task_buf -> struct scatterlist memory.
+	 * from LIO-SE se_mem_t -> task->task_sg -> struct scatterlist memory.
 	 */
 	for (i = 0; i < task->task_sg_num; i++) {
 		DEBUG_IBLOCK("task: %p bio: %p Calling bio_add_page(): page: %p len:"
diff --git a/drivers/lio-core/target_core_pscsi.c b/drivers/lio-core/target_core_pscsi.c
index 862ad26..0ce57e6 100644
--- a/drivers/lio-core/target_core_pscsi.c
+++ b/drivers/lio-core/target_core_pscsi.c
@@ -1165,22 +1165,19 @@ extern int pscsi_map_task_SG (se_task_t *task)
         pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
 	int ret = 0;
 
-	pt->pscsi_buf = (void *)task->task_buf;
+	pt->pscsi_buf = (void *)task->task_sg;
 
 	if (!task->task_size)
 		return(0);
 #if 0
 	if ((ret = blk_rq_map_sg(pdv->pdv_sd->request_queue,
-			pt->pscsi_req,
-			(struct scatterlist *)pt->pscsi_buf)) < 0) {
+			pt->pscsi_req, task->task_sg)) < 0) {
 		printk(KERN_ERR "PSCSI: blk_rq_map_sg() returned %d\n", ret);
 		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
 	}
 #else
-	if ((ret = scsi_req_map_sg(pt->pscsi_req,
-			(struct scatterlist *)pt->pscsi_buf,
-			task->task_sg_num, task->task_size,
-			GFP_KERNEL)) < 0) {
+	if ((ret = scsi_req_map_sg(pt->pscsi_req, task->task_sg,
+			task->task_sg_num, task->task_size, GFP_KERNEL)) < 0) {
 		printk(KERN_ERR "PSCSI: scsi_req_map_sg() failed: %d\n", ret);
 		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
 	}
diff --git a/drivers/lio-core/target_core_rd.c b/drivers/lio-core/target_core_rd.c
index 3bc0d77..ac32e4b 100644
--- a/drivers/lio-core/target_core_rd.c
+++ b/drivers/lio-core/target_core_rd.c
@@ -1195,7 +1195,7 @@ extern void rd_map_task_SG (se_task_t *task)
 	rd_request_t *req = (rd_request_t *) task->transport_req;
 
 	req->rd_bufflen		= task->task_size;
-	req->rd_buf		= (void *)task->task_buf;
+	req->rd_buf		= task->task_sg;
 	req->rd_sg_count	= task->task_sg_num;
 
 	return;
-- 
1.5.4.1



