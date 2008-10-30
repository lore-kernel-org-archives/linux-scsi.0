From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 3/9] osdfs: symlink_inode and fast_symlink_inode operations
Date: Thu, 30 Oct 2008 16:32:17 +0200
Message-ID: <1225377137-25287-1-git-send-email-bharrosh@panasas.com>
References: <4909C41A.7000406@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:52168 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbYJ3PLX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 11:11:23 -0400
In-Reply-To: <4909C41A.7000406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Avishay Traeger <avishay@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

Generic implementation of symlink ops.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/osdfs/Kbuild    |    2 +-
 fs/osdfs/osdfs.h   |    4 +++
 fs/osdfs/symlink.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 1 deletions(-)
 create mode 100644 fs/osdfs/symlink.c

diff --git a/fs/osdfs/Kbuild b/fs/osdfs/Kbuild
index c8ca4ce..eddba6a 100644
--- a/fs/osdfs/Kbuild
+++ b/fs/osdfs/Kbuild
@@ -20,5 +20,5 @@ EXTRA_CFLAGS += -I$(OSD_INC)
 # EXTRA_CFLAGS += -DCONFIG_OSDFS_DEBUG
 endif
 
-osdfs-objs := osd.o inode.o file.o
+osdfs-objs := osd.o inode.o file.o symlink.o
 obj-$(CONFIG_OSDFS_FS) += osdfs.o
diff --git a/fs/osdfs/osdfs.h b/fs/osdfs/osdfs.h
index ea20411..7610ce3 100644
--- a/fs/osdfs/osdfs.h
+++ b/fs/osdfs/osdfs.h
@@ -188,4 +188,8 @@ int osdfs_setattr(struct dentry *, struct iattr *);
 extern struct inode_operations osdfs_file_inode_operations;
 extern struct file_operations osdfs_file_operations;
 
+/* symlink.c         */
+extern struct inode_operations osdfs_symlink_inode_operations;
+extern struct inode_operations osdfs_fast_symlink_inode_operations;
+
 #endif
diff --git a/fs/osdfs/symlink.c b/fs/osdfs/symlink.c
new file mode 100644
index 0000000..7af5388
--- /dev/null
+++ b/fs/osdfs/symlink.c
@@ -0,0 +1,54 @@
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
+#include <linux/namei.h>
+
+#include "osdfs.h"
+
+static void *osdfs_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	struct osdfs_i_info *oi = OSDFS_I(dentry->d_inode);
+	nd_set_link(nd, (char *)oi->i_data);
+	return NULL;
+}
+
+struct inode_operations osdfs_symlink_inode_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= page_follow_link_light,
+	.put_link	= page_put_link,
+};
+
+struct inode_operations osdfs_fast_symlink_inode_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= osdfs_follow_link,
+};
-- 
1.6.0.1

