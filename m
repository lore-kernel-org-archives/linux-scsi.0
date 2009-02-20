From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/7] [Target_Core_Mod/FILEIO]: Add 4k sector/block size
	emulation support
Date: Fri, 20 Feb 2009 00:04:29 -0800
Message-ID: <1235117069.12375.1044.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755011AbZBTIFs@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Alan Stern <stern@rowland.harvard.edu>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

>From 2baeebdcbf070af9052545870c589ca2c8be2378 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 19 Feb 2009 19:39:59 -0800
Subject: [PATCH 5/7] [Target_Core_Mod/FILEIO]: Add 4k sector/block size emulation support

This patch adds support for 4k (and all non 512 byte) sector sizes for the
Target_Core_Mod/ConfigFS interaction with Linux/VFS struct file objects.

This patch updates fd_emulate_read_cap(), fd_emulate_read_cap16() for control path
CDB emulation, and fd_seek(), fd_do_readv(), fd_do_writev(), fd_do_sendfile()
fd_do_aio_write().  The last two functions have been updated, but are still currently
stubbed out and will be enabled in a future patch to Target_Core_Mod/FILEIO.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_file.c |   58 ++++++++++++++++++----------------
 1 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/drivers/lio-core/target_core_file.c b/drivers/lio-core/target_core_file.c
index 12faa15..0dd7cc0 100644
--- a/drivers/lio-core/target_core_file.c
+++ b/drivers/lio-core/target_core_file.c
@@ -435,20 +435,22 @@ extern int fd_emulate_inquiry (se_task_t *task)
 static int fd_emulate_read_cap (se_task_t *task)
 {
 	fd_dev_t *fd_dev = (fd_dev_t *) task->se_dev->dev_ptr;
-	u32 blocks = (fd_dev->fd_dev_size / FD_BLOCKSIZE);
+	u32 blocks = ((fd_dev->fd_dev_size / DEV_ATTRIB(task->se_dev)->block_size) - 1);
 	
-	if ((fd_dev->fd_dev_size / FD_BLOCKSIZE) >= 0x00000000ffffffff)
+	if (((fd_dev->fd_dev_size / DEV_ATTRIB(task->se_dev)->block_size) - 1) >=
+	     0x00000000ffffffff)
 		blocks = 0xffffffff;
 	
-	return(transport_generic_emulate_readcapacity(TASK_CMD(task), blocks, FD_BLOCKSIZE));
+	return(transport_generic_emulate_readcapacity(TASK_CMD(task), blocks));
 }
 
 static int fd_emulate_read_cap16 (se_task_t *task)
 {
 	fd_dev_t *fd_dev = (fd_dev_t *) task->se_dev->dev_ptr;
-	unsigned long long blocks_long = (fd_dev->fd_dev_size / FD_BLOCKSIZE);
+	unsigned long long blocks_long = ((fd_dev->fd_dev_size /
+				  DEV_ATTRIB(task->se_dev)->block_size) - 1);
 	
-	return(transport_generic_emulate_readcapacity_16(TASK_CMD(task), blocks_long, FD_BLOCKSIZE));
+	return(transport_generic_emulate_readcapacity_16(TASK_CMD(task), blocks_long));
 }
 
 /*	fd_emulate_scsi_cdb():
@@ -526,7 +528,7 @@ static inline int fd_iovec_alloc (fd_request_t *req)
 	return(0);
 }
 
-static inline int fd_seek (struct file *fd, unsigned long long lba)
+static inline int fd_seek (struct file *fd, unsigned long long lba, u32 block_size)
 {
 	mm_segment_t old_fs;
 	unsigned long long offset;
@@ -534,18 +536,18 @@ static inline int fd_seek (struct file *fd, unsigned long long lba)
 	old_fs = get_fs();
 	set_fs(get_ds());
 	if (fd->f_op->llseek)
-		offset = fd->f_op->llseek(fd, lba * FD_BLOCKSIZE, 0);
+		offset = fd->f_op->llseek(fd, lba * block_size, 0);
 	else
-		offset = default_llseek(fd, lba * FD_BLOCKSIZE, 0);
+		offset = default_llseek(fd, lba * block_size, 0);
 	set_fs(old_fs);
 #if 0
-	PYXPRINT("lba: %llu : FD_BLOCKSIZE: %d\n", lba, FD_BLOCKSIZE);
+	PYXPRINT("lba: %llu : block_size: %d\n", lba, block_size);
 	PYXPRINT("offset from llseek: %llu\n", offset);
-	PYXPRINT("(lba * FD_BLOCKSIZE): %llu\n", (lba * FD_BLOCKSIZE));
+	PYXPRINT("(lba * block_size): %llu\n", (lba * block_size));
 #endif	
-	if (offset != (lba * FD_BLOCKSIZE)) {
+	if (offset != (lba * block_size)) {
 		TRACE_ERROR("offset: %llu not equal to LBA: %llu\n",
-			offset, (lba * FD_BLOCKSIZE));
+			offset, (lba * block_size));
 		return(-1);
 	}
 
@@ -563,7 +565,7 @@ static int fd_do_readv (fd_request_t *req, se_task_t *task)
 
 	memset(iov, 0, sizeof(struct iovec) + req->fd_sg_count);
 
-	if (fd_seek(fd, req->fd_lba) < 0)
+	if (fd_seek(fd, req->fd_lba, DEV_ATTRIB(task->se_dev)->block_size) < 0)
 		return(-1);
 
 	for (i = 0; i < req->fd_sg_count; i++) {
@@ -607,6 +609,7 @@ static int fd_do_aio_read (fd_request_t *req, se_task_t *task)
 {
 	int ret = 0;
 	u32 i, length = 0;
+	u32 block_size = DEV_ATTRIB(task->se_dev)->block_size;
 	unsigned long long offset, lba = req->fd_lba;;
 	mm_segment_t old_fs;
 	struct file *fd = req->fd_dev->fd_file;
@@ -620,18 +623,18 @@ static int fd_do_aio_read (fd_request_t *req, se_task_t *task)
        old_fs = get_fs();
 	set_fs(get_ds());
          if (fd->f_op->llseek)
-             offset = fd->f_op->llseek(fd, lba * FD_BLOCKSIZE, 0);
+             offset = fd->f_op->llseek(fd, lba * block_size, 0);
               else
-         offset = default_llseek(fd, lba * FD_BLOCKSIZE, 0);
+         offset = default_llseek(fd, lba * block_size, 0);
         set_fs(old_fs);
 
-        PYXPRINT("lba: %llu : FD_BLOCKSIZE: %d\n", lba, FD_BLOCKSIZE);
+        PYXPRINT("lba: %llu : block_size: %d\n", lba, block_size);
         PYXPRINT("offset from llseek: %llu\n", offset);
-        PYXPRINT("(lba * FD_BLOCKSIZE): %llu\n", (lba * FD_BLOCKSIZE));
+        PYXPRINT("(lba * block_size): %llu\n", (lba * block_size));
 
-       if (offset != (lba * FD_BLOCKSIZE)) {
+       if (offset != (lba * block_size)) {
                 TRACE_ERROR("offset: %llu not equal to LBA: %llu\n",
-                        offset, (lba * FD_BLOCKSIZE));
+                        offset, (lba * block_size));
                 return(-1);
         }
 
@@ -717,7 +720,7 @@ static int fd_do_sendfile (fd_request_t *req, se_task_t *task)
 	int ret = 0;
 	struct file *fd = req->fd_dev->fd_file;
 
-	if (fd_seek(fd, req->fd_lba) < 0)
+	if (fd_seek(fd, req->fd_lba, DEV_ATTRIB(task->se_dev)->block_size) < 0)
 		return(-1);
 
 	TASK_CMD(task)->transport_free_DMA = &fd_sendfile_free_DMA;
@@ -745,7 +748,7 @@ static int fd_do_writev (fd_request_t *req, se_task_t *task)
 
 	memset(iov, 0, sizeof(struct iovec) + req->fd_sg_count);
 	
-	if (fd_seek(fd, req->fd_lba) < 0)
+	if (fd_seek(fd, req->fd_lba, DEV_ATTRIB(task->se_dev)->block_size) < 0)
 		return(-1);
 	
 	for (i = 0; i < req->fd_sg_count; i++) {
@@ -772,6 +775,7 @@ static int fd_do_aio_write (fd_request_t *req, se_task_t *task)
 {
 	int ret = 0;
 	u32 i, length = 0;
+	u32 block_size = DEV_ATTRIB(task->se_dev)->block_size;
 	unsigned long long offset, lba = req->fd_lba;
 	mm_segment_t old_fs;
 	struct file *fd = req->fd_dev->fd_file;
@@ -785,18 +789,18 @@ static int fd_do_aio_write (fd_request_t *req, se_task_t *task)
 	old_fs = get_fs();
 	set_fs(get_ds());
 	if (fd->f_op->llseek)
-		offset = fd->f_op->llseek(fd, lba * FD_BLOCKSIZE, 0);
+		offset = fd->f_op->llseek(fd, lba * block_size, 0);
 	else
-		offset = default_llseek(fd, lba * FD_BLOCKSIZE, 0);
+		offset = default_llseek(fd, lba * block_size, 0);
 	set_fs(old_fs);
 
-	PYXPRINT("lba: %llu : FD_BLOCKSIZE: %d\n", lba, FD_BLOCKSIZE);
+	PYXPRINT("lba: %llu : block_size: %d\n", lba, block_size);
 	PYXPRINT("offset from llseek: %llu\n", offset);
-	PYXPRINT("(lba * FD_BLOCKSIZE): %llu\n", (lba * FD_BLOCKSIZE));
+	PYXPRINT("(lba * block_size): %llu\n", (lba * block_size));
 
-	if (offset != (lba * FD_BLOCKSIZE)) {
+	if (offset != (lba * block_size)) {
 		TRACE_ERROR("offset: %llu not equal to LBA: %llu\n",
-			offset, (lba * FD_BLOCKSIZE));
+			offset, (lba * block_size));
 		return(-1);
 	}
 
-- 
1.5.4.1
