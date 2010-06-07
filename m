From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [tgt]: Convert bs_sg to use BSG v4 interface
Date: Mon,  7 Jun 2010 03:52:06 -0700
Message-ID: <1275907926-9494-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: stgt-devel <stgt@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike
Cc: James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds initial support for the block layer implementation of the sg v4 interface
(BSG) -> STGT with a new struct backingstore_template bsg_bst sharing code with the
original sg_bst.  It adds for new function bs_bsg_cmd_submit() for incoming write I/O
and bs_bsg_cmd_complete() for polling read I/O using include/linux/bsg.h:struct sg_io_v4.

This patch also removes the legacy SG_IO functions and struct backingstore_template sg_bst
at Tomo-san's request.  Also chk_bsg_device() is still using a hardcoded 254 major value
for BSG as does not appear in include/linux/major.h.

So far this has been tested with STGT/iSCSI <-> BSG <-> TCM_Loop SPC-4 iSCSI Target
Port emulation and is able to mkfs, fsck and mount a filesystem from a TCM/IBLOCK
Linux LVM kernel level backstore

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 usr/bs_sg.c     |  174 +++++++++++++++++++++++++++++++++---------------------
 usr/scsi_cmnd.h |    7 ++
 2 files changed, 113 insertions(+), 68 deletions(-)

diff --git a/usr/bs_sg.c b/usr/bs_sg.c
index f01a3ef..5e6580c 100644
--- a/usr/bs_sg.c
+++ b/usr/bs_sg.c
@@ -3,6 +3,9 @@
  *
  * Copyright (C) 2008 Alexander Nezhinsky <nezhinsky@gmail.com>
  *
+ * Converted to linux/block/bsg.c support using struct sg_io_v4.
+ * Copyright (C) 2010 Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
  * published by the Free Software Foundation, version 2 of the
@@ -33,6 +36,7 @@
 #include <sys/stat.h>
 #include <sys/epoll.h>
 #include <scsi/sg.h>
+#include <linux/bsg.h>
 
 #include "list.h"
 #include "util.h"
@@ -45,6 +49,14 @@
 #define BS_SG_TIMEOUT	2000
 #define BS_SG_SHIFT	9
 
+//#define BSG_DEBUG_IO
+
+#ifdef BSG_DEBUG_IO
+#define BSG_IO(x...) eprintf(x)
+#else
+#define BSG_IO(x...)
+#endif
+
 static int graceful_read(int fd, void *p_read, int to_read)
 {
 	int err;
@@ -85,7 +97,7 @@ static int graceful_write(int fd, void *p_write, int to_write)
 	return 0;
 }
 
-static int bs_sg_rw(int host_no, struct scsi_cmd *cmd)
+static int bs_bsg_rw(int host_no, struct scsi_cmd *cmd)
 {
 	int ret;
 	unsigned char key = ILLEGAL_REQUEST;
@@ -107,7 +119,7 @@ static int bs_sg_rw(int host_no, struct scsi_cmd *cmd)
 	return SAM_STAT_CHECK_CONDITION;
 }
 
-static void set_cmd_failed(struct scsi_cmd *cmd)
+static int set_cmd_failed(struct scsi_cmd *cmd)
 {
 	int result = SAM_STAT_CHECK_CONDITION;
 	uint16_t asc = ASC_READ_ERROR;
@@ -115,74 +127,91 @@ static void set_cmd_failed(struct scsi_cmd *cmd)
 
 	scsi_set_result(cmd, result);
 	sense_data_build(cmd, key, asc);
+
+	return result;
 }
 
-static int bs_sg_cmd_submit(struct scsi_cmd *cmd)
+static int bs_bsg_cmd_submit(struct scsi_cmd *cmd)
 {
 	struct scsi_lu *dev = cmd->dev;
 	int fd = dev->fd;
-	struct sg_io_hdr io_hdr;
+	struct sg_io_v4 *io_hdr = &cmd->cmd_bsg_hdr;
 	int err = 0;
-
-	memset(&io_hdr, 0, sizeof(io_hdr));
-	io_hdr.interface_id = 'S';
-	io_hdr.cmd_len = cmd->scb_len;
-	io_hdr.cmdp = cmd->scb;
-
-	if (scsi_get_data_dir(cmd) == DATA_WRITE) {
-		io_hdr.dxfer_direction = SG_DXFER_TO_DEV;
-		io_hdr.dxfer_len = scsi_get_out_length(cmd);
-		io_hdr.dxferp = (void *)scsi_get_out_buffer(cmd);
-	} else {
-		io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
-		io_hdr.dxfer_len = scsi_get_in_length(cmd);
-		io_hdr.dxferp = (void *)scsi_get_in_buffer(cmd);
-	}
-	io_hdr.mx_sb_len = sizeof(cmd->sense_buffer);
-	io_hdr.sbp = cmd->sense_buffer;
-	io_hdr.timeout = BS_SG_TIMEOUT;
-	io_hdr.pack_id = -1;
-	io_hdr.usr_ptr = cmd;
-	io_hdr.flags |= SG_FLAG_DIRECT_IO;
-
-	err = graceful_write(fd, &io_hdr, sizeof(io_hdr));
+	/*
+	 * Following linux/include/linux/bsg.h
+	 */
+	/* [i] 'Q' to differentiate from v3 */
+	io_hdr->guard = 'Q';
+	io_hdr->protocol = BSG_PROTOCOL_SCSI;
+	io_hdr->subprotocol = BSG_SUB_PROTOCOL_SCSI_CMD;
+	io_hdr->request_len = cmd->scb_len;
+	io_hdr->request = (unsigned long )cmd->scb;
+
+	io_hdr->dout_xfer_len = scsi_get_out_length(cmd);
+	io_hdr->dout_xferp = (unsigned long)scsi_get_out_buffer(cmd);
+	io_hdr->din_xfer_len = scsi_get_in_length(cmd);
+	io_hdr->din_xferp = (unsigned long)scsi_get_in_buffer(cmd);
+
+	io_hdr->max_response_len = sizeof(cmd->sense_buffer);
+	/* SCSI: (auto)sense data */
+	io_hdr->response = (unsigned long)cmd->sense_buffer;
+	/* Using the same 2000 millisecond timeout.. */
+	io_hdr->timeout = BS_SG_TIMEOUT;
+	/* [i->o] unused internally */
+	io_hdr->usr_ptr = (unsigned long)cmd;
+	BSG_IO("[%d] Set io_hdr->usr_ptr from cmd: %p\n", getpid(), cmd);
+	/* Bsg does Q_AT_HEAD by default */
+	io_hdr->flags |= BSG_FLAG_Q_AT_TAIL;
+
+	BSG_IO("[%d] Calling graceful_write for CDB: 0x%02x\n", getpid(), cmd->scb[0]);
+	err = graceful_write(fd, &cmd->cmd_bsg_hdr, sizeof(struct sg_io_v4));
 	if (!err)
 		set_cmd_async(cmd);
 	else {
 		eprintf("failed to start cmd 0x%p\n", cmd);
-		set_cmd_failed(cmd);
+		return set_cmd_failed(cmd);
 	}
+
 	return 0;
 }
 
-static void bs_sg_cmd_complete(int fd, int events, void *data)
+static void bs_bsg_cmd_complete(int fd, int events, void *data)
 {
-	struct sg_io_hdr io_hdr;
+	struct sg_io_v4 io_hdr;
 	struct scsi_cmd *cmd;
 	int err;
 
+	BSG_IO("[%d] bs_bsg_cmd_complete() called!\n", getpid());
 	memset(&io_hdr, 0, sizeof(io_hdr));
-	io_hdr.interface_id = 'S';
-	io_hdr.pack_id = -1;
+	/* [i] 'Q' to differentiate from v3 */
+	io_hdr.guard = 'Q';
 
 	err = graceful_read(fd, &io_hdr, sizeof(io_hdr));
 	if (err)
 		return;
 
-	cmd = (struct scsi_cmd *)io_hdr.usr_ptr;
-	if (!io_hdr.status) {
-		scsi_set_out_resid(cmd, io_hdr.resid);
-		scsi_set_in_resid(cmd, io_hdr.resid);
+	cmd = (struct scsi_cmd *)(unsigned long)io_hdr.usr_ptr;
+	BSG_IO("BSG Using cmd: %p for io_hdr.usr_ptr\n", cmd);
+	/*
+	 * Check SCSI: command completion status
+	 * */
+	if (!io_hdr.device_status) {
+		scsi_set_out_resid(cmd, io_hdr.dout_resid);
+		scsi_set_in_resid(cmd, io_hdr.din_resid);
 	} else {
-		cmd->sense_len = io_hdr.sb_len_wr;
+		/*
+		 * NAB: Used by linux/block/bsg.c:bsg_ioctl(), is this
+		 * right..?
+		 */
+		cmd->sense_len = SCSI_SENSE_BUFFERSIZE;
 		scsi_set_out_resid_by_actual(cmd, 0);
 		scsi_set_in_resid_by_actual(cmd, 0);
 	}
-
-	cmd->scsi_cmd_done(cmd, io_hdr.status);
+	BSG_IO("[%d] BSG() Calling cmd->scsi_cmd_done()\n", getpid());
+	cmd->scsi_cmd_done(cmd, io_hdr.device_status);
 }
 
-static int chk_sg_device(char *path)
+static int chk_bsg_device(char *path)
 {
 	struct stat st;
 
@@ -191,21 +220,23 @@ static int chk_sg_device(char *path)
 		return -1;
 	}
 
-	if (S_ISCHR(st.st_mode) && major(st.st_rdev) == SCSI_GENERIC_MAJOR)
+	/* This is not yet defined in include/linux/major.h.. */
+	if (S_ISCHR(st.st_mode) && major(st.st_rdev) == 254)
 		return 0;
-	else
-		return -1;
+
+	return -1;
 }
 
-static int init_sg_device(int fd)
+static int init_bsg_device(int fd)
 {
 	int t, err;
 
-	err = ioctl(fd, SG_GET_VERSION_NUM, &t);
-	if ((err < 0) || (t < 30000)) {
-		eprintf("sg driver prior to 3.x\n");
+	err = ioctl(fd, SG_GET_COMMAND_Q, &t);
+	if (err < 0) {
+		eprintf("SG_GET_COMMAND_Q for bsd failed: %d\n", err);
 		return -1;
 	}
+	eprintf("bsg: Using max_queue: %d\n", t);
 
 	t = BS_SG_RESVD_SZ;
 	err = ioctl(fd, SG_SET_RESERVED_SIZE, &t);
@@ -217,7 +248,7 @@ static int init_sg_device(int fd)
 	return 0;
 }
 
-static int bs_sg_init(struct scsi_lu *lu)
+static int bs_bsg_init(struct scsi_lu *lu)
 {
 	/*
 	 * Setup struct scsi_lu->cmd_perform() passthrough pointer
@@ -233,11 +264,17 @@ static int bs_sg_init(struct scsi_lu *lu)
 	return 0;
 }
 
-static int bs_sg_open(struct scsi_lu *lu, char *path, int *fd, uint64_t *size)
+static int bs_bsg_open(struct scsi_lu *lu, char *path, int *fd, uint64_t *size)
 {
+	void (*cmd_complete)(int, int, void *) = NULL;
 	int sg_fd, err;
 
-	err = chk_sg_device(path);
+	if (!(strstr(path, "/dev/bsg/"))) {
+		eprintf("%s Not a valid BSG character device\n", path);
+		return -EINVAL;
+	}
+
+	err = chk_bsg_device(path);
 	if (err) {
 		eprintf("Not recognized %s as an SG device\n", path);
 		return -EINVAL;
@@ -249,13 +286,14 @@ static int bs_sg_open(struct scsi_lu *lu, char *path, int *fd, uint64_t *size)
 		return sg_fd;
 	}
 
-	err = init_sg_device(sg_fd);
+	cmd_complete = &bs_bsg_cmd_complete;
+	err = init_bsg_device(sg_fd);
 	if (err) {
 		eprintf("Failed to initialize sg device %s\n", path);
 		return err;
 	}
 
-	err = tgt_event_add(sg_fd, EPOLLIN, bs_sg_cmd_complete, NULL);
+	err = tgt_event_add(sg_fd, EPOLLIN, cmd_complete, NULL);
 	if (err) {
 		eprintf("Failed to add sg device event %s\n", path);
 		return err;
@@ -266,17 +304,17 @@ static int bs_sg_open(struct scsi_lu *lu, char *path, int *fd, uint64_t *size)
 	return 0;
 }
 
-static void bs_sg_close(struct scsi_lu *lu)
+static void bs_bsg_close(struct scsi_lu *lu)
 {
 	close(lu->fd);
 }
 
-static int bs_sg_cmd_done(struct scsi_cmd *cmd)
+static int bs_bsg_cmd_done(struct scsi_cmd *cmd)
 {
 	return 0;
 }
 
-static int bs_sg_lu_init(struct scsi_lu *lu)
+static int bs_bsg_lu_init(struct scsi_lu *lu)
 {
 	if (spc_lu_init(lu))
 		return TGTADM_NOMEM;
@@ -284,28 +322,28 @@ static int bs_sg_lu_init(struct scsi_lu *lu)
 	return 0;
 }
 
-static struct backingstore_template sg_bst = {
-	.bs_name		= "sg",
+static struct backingstore_template bsg_bst = {
+	.bs_name		= "bsg",
 	.bs_datasize		= 0,
-	.bs_init		= bs_sg_init,
-	.bs_open		= bs_sg_open,
-	.bs_close		= bs_sg_close,
-	.bs_cmd_submit		= bs_sg_cmd_submit,
-	.bs_cmd_done		= bs_sg_cmd_done,
+	.bs_init		= bs_bsg_init,
+	.bs_open		= bs_bsg_open,
+	.bs_close		= bs_bsg_close,
+	.bs_cmd_submit		= bs_bsg_cmd_submit,
+	.bs_cmd_done		= bs_bsg_cmd_done,
 };
 
-static struct device_type_template sg_template = {
+static struct device_type_template bsg_template = {
 	.type			= TYPE_PT,
-	.lu_init		= bs_sg_lu_init,
+	.lu_init		= bs_bsg_lu_init,
 	.lu_config		= spc_lu_config,
 	.lu_online		= spc_lu_online,
 	.lu_offline		= spc_lu_offline,
 	.lu_exit		= spc_lu_exit,
-	.cmd_passthrough	= bs_sg_rw,
+	.cmd_passthrough	= bs_bsg_rw,
 };
 
-__attribute__((constructor)) static void bs_sg_constructor(void)
+__attribute__((constructor)) static void bs_bsg_constructor(void)
 {
-	register_backingstore_template(&sg_bst);
-	device_type_register(&sg_template);
+	register_backingstore_template(&bsg_bst);
+	device_type_register(&bsg_template);
 }
diff --git a/usr/scsi_cmnd.h b/usr/scsi_cmnd.h
index 011f3e6..67a46c3 100644
--- a/usr/scsi_cmnd.h
+++ b/usr/scsi_cmnd.h
@@ -17,6 +17,9 @@ struct scsi_data_buffer {
 	uint64_t buffer;
 };
 
+#include <scsi/sg.h>
+#include <linux/bsg.h>
+
 struct scsi_cmd {
 	struct target *c_target;
 	/* linked it_nexus->cmd_hash_list */
@@ -31,6 +34,10 @@ struct scsi_cmd {
 	enum data_direction data_dir;
 	struct scsi_data_buffer in_sdb;
 	struct scsi_data_buffer out_sdb;
+	/* Used for bs_sg.c:bs_bs_cmd_submit() */
+	struct sg_iovec cmd_sg_iovec;
+	/* used for bs_sg.c:bs_bsg_cmd_submit() */
+	struct sg_io_v4 cmd_bsg_hdr;
 
 	uint64_t cmd_itn_id;
 	uint64_t offset;
-- 
1.5.6.5
