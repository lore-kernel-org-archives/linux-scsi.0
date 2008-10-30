From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 1/9] osdfs: osd Swiss army knife
Date: Thu, 30 Oct 2008 16:30:46 +0200
Message-ID: <1225377046-25231-1-git-send-email-bharrosh@panasas.com>
References: <4909C41A.7000406@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:52168 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbYJ3PLd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 11:11:33 -0400
In-Reply-To: <4909C41A.7000406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Avishay Traeger <avishay@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

In this patch are all the osd infrastructure that will be used later
by the file system.

Also the declarations of constants, on disk structures, and prototypes.

And the Kbuild+Kconfig files needed to build the osdfs module.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/osdfs/Kbuild   |   24 ++++
 fs/osdfs/Kconfig  |   13 ++
 fs/osdfs/common.h |  154 ++++++++++++++++++++++++++
 fs/osdfs/osd.c    |  316 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/osdfs/osdfs.h  |  180 ++++++++++++++++++++++++++++++
 5 files changed, 687 insertions(+), 0 deletions(-)
 create mode 100644 fs/osdfs/Kbuild
 create mode 100644 fs/osdfs/Kconfig
 create mode 100644 fs/osdfs/common.h
 create mode 100644 fs/osdfs/osd.c
 create mode 100644 fs/osdfs/osdfs.h

diff --git a/fs/osdfs/Kbuild b/fs/osdfs/Kbuild
new file mode 100644
index 0000000..19d709e
--- /dev/null
+++ b/fs/osdfs/Kbuild
@@ -0,0 +1,24 @@
+#
+# Kbuild for the OSDFS module
+#
+# Copyright (C) 2008 Panasas Inc.  All rights reserved.
+#
+# Authors:
+#   Boaz Harrosh <bharrosh@panasas.com>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2
+#
+# Kbuild - Gets included from the Kernels Makefile and build system
+#
+
+ifneq ($(OSD_INC),)
+# we are built out-of-tree Kconfigure everything as on
+CONFIG_OSDFS_FS=m
+EXTRA_CFLAGS += -DCONFIG_OSDFS_FS -DCONFIG_OSDFS_FS_MODULE
+EXTRA_CFLAGS += -I$(OSD_INC)
+# EXTRA_CFLAGS += -DCONFIG_OSDFS_DEBUG
+endif
+
+osdfs-objs := osd.o
+obj-$(CONFIG_OSDFS_FS) += osdfs.o
diff --git a/fs/osdfs/Kconfig b/fs/osdfs/Kconfig
new file mode 100644
index 0000000..843bf82
--- /dev/null
+++ b/fs/osdfs/Kconfig
@@ -0,0 +1,13 @@
+config OSDFS_FS
+	tristate "OSD based file system support"
+	depends on SCSI_OSD_ULD
+	help
+	  OSDFS is a file system that uses an OSD storage device,
+	  as its backing storage.
+
+# Debugging-related stuff
+config OSDFS_DEBUG
+	bool "Enable debugging"
+	depends on OSDFS_FS
+	help
+	  This option enables OSDFS debug prints.
diff --git a/fs/osdfs/common.h b/fs/osdfs/common.h
new file mode 100644
index 0000000..37886f7
--- /dev/null
+++ b/fs/osdfs/common.h
@@ -0,0 +1,154 @@
+/*
+ * Copyright (C) 2005, 2006
+ * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
+ * Copyright (C) 2005, 2006
+ * International Business Machines
+ *
+ * Copyrights for code taken from ext2:
+ *     Copyright (C) 1992, 1993, 1994, 1995
+ *     Remy Card (card@masi.ibp.fr)
+ *     Laboratoire MASI - Institut Blaise Pascal
+ *     Universite Pierre et Marie Curie (Paris VI)
+ *     from
+ *     linux/fs/minix/inode.c
+ *     Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ * This file is part of osdfs.
+ *
+ * osdfs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.  Since it is based on ext2, and the only
+ * valid version of GPL for the Linux kernel is version 2, the only valid
+ * version of GPL for osdfs is version 2.
+ *
+ * osdfs is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with osdfs; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef __OSDFS_COM_H__
+#define __OSDFS_COM_H__
+
+#include <linux/types.h>
+#include <linux/timex.h>
+
+#include <scsi/osd_attributes.h>
+#include <scsi/osd_initiator.h>
+#include <scsi/osd_sec.h>
+
+/****************************************************************************
+ * Object ID related defines
+ * NOTE: inode# = object ID - OSDFS_OBJ_OFF
+ ****************************************************************************/
+#define OSDFS_OBJ_OFF	0x10000	/* offset for objects */
+#define OSDFS_SUPER_ID	0x10000	/* object ID for on-disk superblock */
+#define OSDFS_BM_ID	0x10001	/* object ID for ID bitmap */
+#define OSDFS_ROOT_ID	0x10002	/* object ID for root directory */
+#define OSDFS_TEST_ID	0x10003	/* object ID for test object */
+
+/* osdfs Application specific page/attribute */
+#ifndef OSD_PAGE_NUM_IBM_UOBJ_FS_DATA
+# define OSD_PAGE_NUM_IBM_UOBJ_FS_DATA	   (OSD_APAGE_APP_DEFINED_FIRST + 3)
+# define OSD_ATTR_NUM_IBM_UOBJ_FS_DATA_INODE 1
+#endif
+
+/*
+ * The maximum number of files we can have is limited by the size of the
+ * inode number.  This is the largest object ID that the file system supports.
+ * Object IDs 0, 1, and 2 are always in use (see above defines).
+ */
+enum {
+	OSDFS_UINT64_MAX = (~0LL),
+	OSDFS_MAX_INO_ID = (sizeof(ino_t) * 8 == 64) ? OSDFS_UINT64_MAX :
+					(1LL << (sizeof(ino_t) * 8 - 1)),
+	OSDFS_MAX_ID	 = (OSDFS_MAX_INO_ID - 1 - OSDFS_OBJ_OFF),
+};
+
+/****************************************************************************
+ * Misc.
+ ****************************************************************************/
+#define OSDFS_BLKSHIFT	12
+#define OSDFS_BLKSIZE	(1UL << OSDFS_BLKSHIFT)
+
+/****************************************************************************
+ * superblock-related things
+ ****************************************************************************/
+#define OSDFS_SUPER_MAGIC	0x5DF5
+
+/*
+ * The file system control block - stored in an object's data (mainly, the one
+ * with ID OSDFS_SUPER_ID).  This is where the in-memory superblock is stored
+ * on disk.  Right now it just has a magic value, which is basically a sanity
+ * check on our ability to communicate with the object store.
+ */
+struct osdfs_fscb {
+	uint32_t  s_nextid;	/* Highest object ID used */
+	uint32_t  s_numfiles;	/* Number of files on fs */
+	uint16_t  s_magic;	/* Magic signature */
+	uint16_t  s_newfs;	/* Non-zero if this is a new fs */
+};
+
+/****************************************************************************
+ * inode-related things
+ ****************************************************************************/
+#define OSDFS_INO_ATTR_SIZE	64
+#define OSDFS_IDATA		15
+
+/*
+ * The file control block - stored in an object's attributes.  This is where
+ * the in-memory inode is stored on disk.
+ */
+struct osdfs_fcb {
+	uint16_t  i_mode;         	/* File mode */
+	uint16_t  i_links_count;  	/* Links count */
+	uint32_t  i_uid;          	/* Owner Uid */
+	uint32_t  i_gid;          	/* Group Id */
+	uint32_t  i_atime;        	/* Access time */
+	uint32_t  i_ctime;        	/* Creation time */
+	uint32_t  i_mtime;        	/* Modification time */
+	uint32_t  i_flags;        	/* File flags */
+	uint32_t  i_version;      	/* File version */
+	uint32_t  i_generation;   	/* File version (for NFS) */
+	uint64_t  i_size;		/* Size of the file */
+	uint64_t  i_objs;         	/* Other objects for file - not used */
+	uint32_t  i_data[OSDFS_IDATA];	/* Short symlink names and device #s */
+};
+
+/****************************************************************************
+ * dentry-related things
+ ****************************************************************************/
+#define OSDFS_NAME_LEN	255
+
+/*
+ * The on-disk directory entry
+ */
+struct osdfs_dir_entry {
+	uint32_t	inode;			/* inode number           */
+	uint16_t	rec_len;		/* directory entry length */
+	uint8_t		name_len;		/* name length            */
+	uint8_t		file_type;		/* umm...file type        */
+	char		name[OSDFS_NAME_LEN];	/* file name              */
+};
+
+enum {
+	OSDFS_FT_UNKNOWN,
+	OSDFS_FT_REG_FILE,
+	OSDFS_FT_DIR,
+	OSDFS_FT_CHRDEV,
+	OSDFS_FT_BLKDEV,
+	OSDFS_FT_FIFO,
+	OSDFS_FT_SOCK,
+	OSDFS_FT_SYMLINK,
+	OSDFS_FT_MAX
+};
+
+#define OSDFS_DIR_PAD			4
+#define OSDFS_DIR_ROUND			(OSDFS_DIR_PAD - 1)
+#define OSDFS_DIR_REC_LEN(name_len)	(((name_len) + 8 + OSDFS_DIR_ROUND) & \
+					 ~OSDFS_DIR_ROUND)
+#endif
diff --git a/fs/osdfs/osd.c b/fs/osdfs/osd.c
new file mode 100644
index 0000000..18574b4
--- /dev/null
+++ b/fs/osdfs/osd.c
@@ -0,0 +1,316 @@
+/*
+ * Copyright (C) 2005, 2006
+ * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
+ * Copyright (C) 2005, 2006
+ * International Business Machines
+ *
+ * This file is part of osdfs.
+ *
+ * osdfs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.  Since it is based on ext2, and the only
+ * valid version of GPL for the Linux kernel is version 2, the only valid
+ * version of GPL for osdfs is version 2.
+ *
+ * osdfs is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with osdfs; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <scsi/scsi_device.h>
+
+#include "osdfs.h"
+
+int check_ok(struct osd_request *req)
+{
+	return req->request->errors;
+}
+
+void make_credential(uint8_t cred_a[OSD_CAP_LEN], uint64_t pid, uint64_t oid)
+{
+	struct osd_obj_id obj = {
+		.partition = pid,
+		.id = oid
+	};
+
+	osd_sec_init_nosec_doall_caps(cred_a, &obj, false, true);
+}
+
+/*
+ * Perform a synchronous OSD operation.
+ */
+int osdfs_sync_op(struct osd_request *req, int timeout, uint8_t *credential)
+{
+	int ret;
+
+	req->timeout = timeout;
+	ret = osd_finalize_request(req, 0, credential, NULL);
+	if (ret) {
+		OSDFS_DBGMSG("Faild to osd_finalize_request() => %d\n", ret);
+		return ret;
+	}
+
+	ret = osd_execute_request(req);
+
+	if (ret)
+		OSDFS_DBGMSG("osd_execute_request() => %d\n", ret);
+	/* osd_req_decode_sense(or, ret); */
+	return ret;
+}
+
+/*
+ * Perform an asynchronous OSD operation.
+ */
+int osdfs_async_op(struct osd_request *req, osd_req_done_fn *async_done,
+		   void *caller_context, char *credential)
+{
+	int ret;
+
+	ret = osd_finalize_request(req, 0, credential, NULL);
+	if (ret) {
+		OSDFS_DBGMSG("Faild to osd_finalize_request() => %d\n", ret);
+		return ret;
+	}
+
+	ret = osd_execute_request_async(req, async_done, caller_context);
+
+	if (ret)
+		OSDFS_DBGMSG("osd_execute_request_async() => %d\n", ret);
+	return ret;
+}
+
+int prepare_get_attr_list_add_entry(struct osd_request *req,
+				    uint32_t page_num,
+				    uint32_t attr_num,
+				    uint32_t attr_len)
+{
+	struct osd_attr attr = {
+		.page = page_num,
+		.attr_id = attr_num,
+		.len = attr_len,
+	};
+
+	return osd_req_add_get_attr_list(req, &attr, 1);
+}
+
+int prepare_set_attr_list_add_entry(struct osd_request *req,
+				    uint32_t page_num,
+				    uint32_t attr_num,
+				    uint16_t attr_len,
+				    const unsigned char *attr_val)
+{
+	struct osd_attr attr = {
+		.page = page_num,
+		.attr_id = attr_num,
+		.len = attr_len,
+		.val_ptr = (u8 *)attr_val,
+	};
+
+	return osd_req_add_set_attr_list(req, &attr, 1);
+}
+
+int extract_next_attr_from_req(struct osd_request *req,
+	uint32_t *page_num, uint32_t *attr_num,
+	uint16_t *attr_len, uint8_t **attr_val)
+{
+	struct osd_attr attr = {.page = 0}; /* start with zeros */
+	void *iter = NULL;
+	int nelem;
+
+	do {
+		nelem = 1;
+		osd_req_decode_get_attr_list(req, &attr, &nelem, &iter);
+		if ((attr.page == *page_num) && (attr.attr_id == *attr_num)) {
+			*attr_len = attr.len;
+			*attr_val = attr.val_ptr;
+			return 0;
+		}
+	} while (iter);
+
+	return -EIO;
+}
+
+struct osd_request *prepare_osd_format_lun(struct osd_dev *dev,
+					   uint64_t formatted_capacity)
+{
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+
+	if (!or)
+		return NULL;
+
+	osd_req_format(or, formatted_capacity);
+
+	return or;
+}
+
+struct osd_request *prepare_osd_create_partition(struct osd_dev *dev,
+						 uint64_t requested_id)
+{
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+
+	if (!or)
+		return NULL;
+
+	osd_req_create_partition(or, requested_id);
+
+	return or;
+}
+
+struct osd_request *prepare_osd_remove_partition(struct osd_dev *dev,
+						 uint64_t requested_id)
+{
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+
+	if (!or)
+		return NULL;
+
+	osd_req_remove_partition(or, requested_id);
+
+	return or;
+}
+
+struct osd_request *prepare_osd_create(struct osd_dev *dev,
+				     uint64_t part_id,
+				     uint64_t requested_id)
+{
+	struct osd_obj_id obj = {
+		.partition = part_id,
+		.id = requested_id
+	};
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+
+	if (!or)
+		return NULL;
+
+	osd_req_create_object(or, &obj);
+
+	return or;
+}
+
+struct osd_request *prepare_osd_remove(struct osd_dev *dev,
+				     uint64_t part_id,
+				     uint64_t obj_id)
+{
+	struct osd_obj_id obj = {
+		.partition = part_id,
+		.id = obj_id
+	};
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+
+	if (!or)
+		return NULL;
+
+	osd_req_remove_object(or, &obj);
+
+	return or;
+}
+
+struct osd_request *prepare_osd_set_attr(struct osd_dev *dev,
+				       uint64_t part_id,
+				       uint64_t obj_id)
+{
+	struct osd_obj_id obj = {
+		.partition = part_id,
+		.id = obj_id
+	};
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+
+	if (!or)
+		return NULL;
+
+	osd_req_set_attributes(or, &obj);
+
+	return or;
+}
+
+struct osd_request *prepare_osd_get_attr(struct osd_dev *dev,
+				       uint64_t part_id,
+				       uint64_t obj_id)
+{
+	struct osd_obj_id obj = {
+		.partition = part_id,
+		.id = obj_id
+	};
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+
+	if (!or)
+		return NULL;
+
+	osd_req_get_attributes(or, &obj);
+
+	return or;
+}
+
+struct osd_request *prepare_osd_read(struct osd_dev *dev,
+				   uint64_t part_id,
+				   uint64_t obj_id,
+				   uint64_t length,
+				   uint64_t offset,
+				   int cmd_data_use_sg,
+				   unsigned char *cmd_data)
+{
+	struct osd_obj_id obj = {
+		.partition = part_id,
+		.id = obj_id
+	};
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+	struct request_queue *req_q = dev->scsi_dev->request_queue;
+	struct bio *bio;
+
+	if (!or)
+		return NULL;
+
+	BUG_ON(cmd_data_use_sg);
+	bio = bio_map_kern(req_q, cmd_data, length, or->alloc_flags);
+	if (!bio) {
+		osd_end_request(or);
+		return NULL;
+	}
+
+	osd_req_read(or, &obj, bio, offset);
+	OSDFS_DBGMSG("osd_req_read(p=%llX, ob=%llX, l=%llu, of=%llu)\n",
+		part_id, obj_id, length, offset);
+	return or;
+}
+
+struct osd_request *prepare_osd_write(struct osd_dev *dev,
+				    uint64_t part_id,
+				    uint64_t obj_id,
+				    uint64_t length,
+				    uint64_t offset,
+				    int cmd_data_use_sg,
+				    const unsigned char *cmd_data)
+{
+	struct osd_obj_id obj = {
+		.partition = part_id,
+		.id = obj_id
+	};
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+	struct request_queue *req_q = dev->scsi_dev->request_queue;
+	struct bio *bio;
+
+	if (!or)
+		return NULL;
+
+	BUG_ON(cmd_data_use_sg);
+	bio = bio_map_kern(req_q, (u8 *)cmd_data, length, or->alloc_flags);
+	if (!bio) {
+		osd_end_request(or);
+		return NULL;
+	}
+
+	osd_req_write(or, &obj, bio, offset);
+	OSDFS_DBGMSG("osd_req_write(p=%llX, ob=%llX, l=%llu, of=%llu)\n",
+		part_id, obj_id, length, offset);
+	return or;
+}
+
+void free_osd_req(struct osd_request *req)
+{
+	osd_end_request(req);
+}
diff --git a/fs/osdfs/osdfs.h b/fs/osdfs/osdfs.h
new file mode 100644
index 0000000..30472b7
--- /dev/null
+++ b/fs/osdfs/osdfs.h
@@ -0,0 +1,180 @@
+/*
+ * Copyright (C) 2005, 2006
+ * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
+ * Copyright (C) 2005, 2006
+ * International Business Machines
+ *
+ * Copyrights for code taken from ext2:
+ *     Copyright (C) 1992, 1993, 1994, 1995
+ *     Remy Card (card@masi.ibp.fr)
+ *     Laboratoire MASI - Institut Blaise Pascal
+ *     Universite Pierre et Marie Curie (Paris VI)
+ *     from
+ *     linux/fs/minix/inode.c
+ *     Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ * This file is part of osdfs.
+ *
+ * osdfs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.  Since it is based on ext2, and the only
+ * valid version of GPL for the Linux kernel is version 2, the only valid
+ * version of GPL for osdfs is version 2.
+ *
+ * osdfs is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with osdfs; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/fs.h>
+#include <linux/time.h>
+#include "common.h"
+
+#ifndef __OSDFS_H__
+#define __OSDFS_H__
+
+#define OSDFS_ERR(fmt, a...) printk(KERN_ERR "osdfs: " fmt, ##a)
+
+#ifdef CONFIG_OSDFS_DEBUG
+#define OSDFS_DBGMSG(fmt, a...) \
+	printk(KERN_NOTICE "osdfs @%s:%d: " fmt, __func__, __LINE__, ##a)
+#else
+#define OSDFS_DBGMSG(fmt, a...) \
+	do {} while (0)
+#endif
+
+/*
+ * our extension to the in-memory superblock
+ */
+struct osdfs_sb_info {
+	struct osd_dev	*s_dev;			/* returned by get_osd_dev    */
+	uint64_t	s_pid;			/* partition ID of file system*/
+	int		s_timeout;		/* timeout for OSD operations */
+	uint32_t	s_nextid;		/* highest object ID used     */
+	uint32_t	s_numfiles;		/* number of files on fs      */
+	spinlock_t	s_next_gen_lock;	/* spinlock for gen # update  */
+	u32		s_next_generation;	/* next gen # to use          */
+	atomic_t	s_curr_pending;		/* number of pending commands */
+	uint8_t		s_cred[OSD_CAP_LEN];	/* all-powerful credential    */
+};
+
+/*
+ * our inode flags
+ */
+#ifdef ARCH_HAS_ATOMIC_UNSIGNED
+typedef unsigned osdfs_iflags_t;
+#else
+typedef unsigned long osdfs_iflags_t;
+#endif
+
+#define OBJ_2BCREATED	0	/* object will be created soon*/
+#define OBJ_CREATED	1	/* object has been created on the osd*/
+
+#define Obj2BCreated(oi) \
+	test_bit(OBJ_2BCREATED, &(oi->i_flags))
+#define SetObj2BCreated(oi) \
+	set_bit(OBJ_2BCREATED, &(oi->i_flags))
+
+#define ObjCreated(oi) \
+	test_bit(OBJ_CREATED, &(oi->i_flags))
+#define SetObjCreated(oi) \
+	set_bit(OBJ_CREATED, &(oi->i_flags))
+
+/*
+ * our extension to the in-memory inode
+ */
+struct osdfs_i_info {
+	osdfs_iflags_t i_flags;            /* various atomic flags            */
+	__le32	       i_data[OSDFS_IDATA];/*short symlink names and device #s*/
+	uint32_t       i_dir_start_lookup; /* which page to start lookup      */
+	wait_queue_head_t i_wq;            /* wait queue for inode            */
+	uint64_t       i_objs;             /*other objs for file (not used)   */
+	uint8_t        i_cred[OSD_CAP_LEN];/* all-powerful credential         */
+	struct inode   vfs_inode;          /* normal in-memory inode          */
+};
+
+/*
+ * get to our inode from the vfs inode
+ */
+static inline struct osdfs_i_info *OSDFS_I(struct inode *inode)
+{
+	return container_of(inode, struct osdfs_i_info, vfs_inode);
+}
+
+/*************************
+ * function declarations *
+ *************************/
+/* osd.c                 */
+void make_credential(uint8_t[], uint64_t, uint64_t);
+int check_ok(struct osd_request *);
+int osdfs_sync_op(struct osd_request *, int, uint8_t *);
+int osdfs_async_op(struct osd_request *, osd_req_done_fn *, void *, char *);
+
+int prepare_get_attr_list_add_entry(struct osd_request *req,
+				    uint32_t page_num,
+				    uint32_t attr_num,
+				    uint32_t attr_len);
+int prepare_set_attr_list_add_entry(struct osd_request *req,
+				    uint32_t page_num,
+				    uint32_t attr_num,
+				    uint16_t attr_len,
+				    const unsigned char *attr_val);
+int extract_next_attr_from_req(struct osd_request *req,
+			       uint32_t *page_num, uint32_t *attr_num,
+			       uint16_t *attr_len, uint8_t **attr_val);
+struct osd_request *prepare_osd_format_lun(struct osd_dev *dev,
+					   uint64_t formatted_capacity);
+struct osd_request *prepare_osd_create_partition(struct osd_dev *dev,
+						 uint64_t requested_id);
+struct osd_request *prepare_osd_remove_partition(struct osd_dev *dev,
+						 uint64_t requested_id);
+struct osd_request *prepare_osd_create(struct osd_dev *dev,
+				       uint64_t part_id,
+				       uint64_t requested_id);
+struct osd_request *prepare_osd_remove(struct osd_dev *dev,
+				       uint64_t part_id,
+				       uint64_t obj_id);
+struct osd_request *prepare_osd_set_attr(struct osd_dev *dev,
+					 uint64_t part_id,
+					 uint64_t obj_id);
+struct osd_request *prepare_osd_get_attr(struct osd_dev *dev,
+					 uint64_t part_id,
+					 uint64_t obj_id);
+struct osd_request *prepare_osd_read(struct osd_dev *dev,
+				     uint64_t part_id,
+				     uint64_t obj_id,
+				     uint64_t length,
+				     uint64_t offset,
+				     int cmd_data_use_sg,
+				     unsigned char *cmd_data);
+struct osd_request *prepare_osd_write(struct osd_dev *dev,
+				      uint64_t part_id,
+				      uint64_t obj_id,
+				      uint64_t length,
+				      uint64_t offset,
+				      int cmd_data_use_sg,
+				      const unsigned char *cmd_data);
+struct osd_request *prepare_osd_list(struct osd_dev *dev,
+				     uint64_t part_id,
+				     uint32_t list_id,
+				     uint64_t alloc_len,
+				     uint64_t initial_obj_id,
+				     int use_sg,
+				     void *data);
+int extract_list_from_req(struct osd_request *req,
+			  uint64_t *total_matches_p,
+			  uint64_t *num_ids_retrieved_p,
+			  uint64_t *list_of_ids_p[],
+			  int      *is_list_of_partitions_p,
+			  int      *list_isnt_up_to_date_p,
+			  uint64_t *continuation_tag_p,
+			  uint32_t *list_id_for_more_p);
+
+void free_osd_req(struct osd_request *req);
+
+#endif
-- 
1.6.0.1

