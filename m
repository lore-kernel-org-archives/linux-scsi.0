From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 2/9] osdfs: file and file_inode operations
Date: Thu, 30 Oct 2008 16:31:33 +0200
Message-ID: <1225377093-25261-1-git-send-email-bharrosh@panasas.com>
References: <4909C41A.7000406@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:52168 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbYJ3PL0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 11:11:26 -0400
In-Reply-To: <4909C41A.7000406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Avishay Traeger <avishay@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

implementation of the file_operations and inode_operations for
regular data files.

All file_operations are generic vfs implementations except
osdfs_truncate.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/osdfs/Kbuild  |    2 +-
 fs/osdfs/file.c  |   58 ++++++++++++++++++++++
 fs/osdfs/inode.c |  140 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/osdfs/osdfs.h |   11 ++++
 4 files changed, 210 insertions(+), 1 deletions(-)
 create mode 100644 fs/osdfs/file.c
 create mode 100644 fs/osdfs/inode.c

diff --git a/fs/osdfs/Kbuild b/fs/osdfs/Kbuild
index 19d709e..c8ca4ce 100644
--- a/fs/osdfs/Kbuild
+++ b/fs/osdfs/Kbuild
@@ -20,5 +20,5 @@ EXTRA_CFLAGS += -I$(OSD_INC)
 # EXTRA_CFLAGS += -DCONFIG_OSDFS_DEBUG
 endif
 
-osdfs-objs := osd.o
+osdfs-objs := osd.o inode.o file.o
 obj-$(CONFIG_OSDFS_FS) += osdfs.o
diff --git a/fs/osdfs/file.c b/fs/osdfs/file.c
new file mode 100644
index 0000000..3442979
--- /dev/null
+++ b/fs/osdfs/file.c
@@ -0,0 +1,58 @@
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
+#include <linux/buffer_head.h>
+
+#include "osdfs.h"
+
+static int osdfs_release_file(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+struct file_operations osdfs_file_operations = {
+	.llseek		= generic_file_llseek,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= generic_file_aio_write,
+	.mmap		= generic_file_mmap,
+	.open		= generic_file_open,
+	.release	= osdfs_release_file,
+	.fsync		= file_fsync,
+};
+
+struct inode_operations osdfs_file_inode_operations = {
+	.truncate	= osdfs_truncate,
+	.setattr	= osdfs_setattr,
+};
diff --git a/fs/osdfs/inode.c b/fs/osdfs/inode.c
new file mode 100644
index 0000000..e009eb0
--- /dev/null
+++ b/fs/osdfs/inode.c
@@ -0,0 +1,140 @@
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
+#include <linux/writeback.h>
+#include <linux/buffer_head.h>
+
+#include "osdfs.h"
+
+/*
+ * Test whether an inode is a fast symlink.
+ */
+static inline int osdfs_inode_is_fast_symlink(struct inode *inode)
+{
+	struct osdfs_i_info *oi = OSDFS_I(inode);
+
+	return S_ISLNK(inode->i_mode) && (oi->i_data[0] != 0);
+}
+
+/*
+ * get_block_t - Fill in a buffer_head
+ * An OSD takes care of block allocation so we just fake an allocation by
+ * putting in the inode's sector_t in the buffer_head.
+ * TODO: What about the case of create==0 and @iblock does not exist in the
+ * object?
+ */
+int osdfs_get_block(struct inode *inode, sector_t iblock,
+		    struct buffer_head *bh_result, int create)
+{
+	map_bh(bh_result, inode->i_sb, iblock);
+	return 0;
+}
+
+/******************************************************************************
+ * INODE OPERATIONS
+ *****************************************************************************/
+
+/*
+ * Truncate a file to the specified size - all we have to do is set the size
+ * attribute.  We make sure the object exists first.
+ */
+void osdfs_truncate(struct inode *inode)
+{
+	struct osdfs_sb_info *sbi = inode->i_sb->s_fs_info;
+	struct osdfs_i_info *oi = OSDFS_I(inode);
+	struct osd_request *req = NULL;
+	loff_t isize = i_size_read(inode);
+	uint64_t newsize;
+	int ret;
+
+	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)
+	     || S_ISLNK(inode->i_mode)))
+		return;
+	if (osdfs_inode_is_fast_symlink(inode))
+		return;
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		return;
+	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+
+	nobh_truncate_page(inode->i_mapping, isize, osdfs_get_block);
+
+	req = prepare_osd_set_attr(sbi->s_dev, sbi->s_pid,
+				 inode->i_ino + OSDFS_OBJ_OFF);
+	if (!req) {
+		printk(KERN_ERR "ERROR: prepare set_attr failed.\n");
+		goto fail;
+	}
+
+	newsize = cpu_to_be64((uint64_t) isize);
+	prepare_set_attr_list_add_entry(req, OSD_APAGE_OBJECT_INFORMATION,
+					OSD_ATTR_OI_LOGICAL_LENGTH, 8,
+					(unsigned char *)(&newsize));
+
+	/* if we are about to truncate an object, and it hasn't been
+	 * created yet, wait
+	 */
+	if (!ObjCreated(oi)) {
+		if (!Obj2BCreated(oi))
+			BUG();
+		else
+			wait_event(oi->i_wq, ObjCreated(oi));
+	}
+
+	ret = osdfs_sync_op(req, sbi->s_timeout, oi->i_cred);
+	free_osd_req(req);
+	if (ret)
+		goto fail;
+
+out:
+	mark_inode_dirty(inode);
+	return;
+fail:
+	make_bad_inode(inode);
+	goto out;
+}
+
+/*
+ * Set inode attributes - just call generic functions.
+ */
+int osdfs_setattr(struct dentry *dentry, struct iattr *iattr)
+{
+	struct inode *inode = dentry->d_inode;
+	int error;
+
+	error = inode_change_ok(inode, iattr);
+	if (error)
+		return error;
+
+	error = inode_setattr(inode, iattr);
+	return error;
+}
diff --git a/fs/osdfs/osdfs.h b/fs/osdfs/osdfs.h
index 30472b7..ea20411 100644
--- a/fs/osdfs/osdfs.h
+++ b/fs/osdfs/osdfs.h
@@ -177,4 +177,15 @@ int extract_list_from_req(struct osd_request *req,
 
 void free_osd_req(struct osd_request *req);
 
+/* inode.c               */
+void osdfs_truncate(struct inode *inode);
+int osdfs_setattr(struct dentry *, struct iattr *);
+
+/*********************
+ * operation vectors *
+ *********************/
+/* file.c            */
+extern struct inode_operations osdfs_file_inode_operations;
+extern struct file_operations osdfs_file_operations;
+
 #endif
-- 
1.6.0.1

