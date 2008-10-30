From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 6/9] osdfs: super_operations and file_system_type
Date: Thu, 30 Oct 2008 16:35:18 +0200
Message-ID: <1225377318-25375-1-git-send-email-bharrosh@panasas.com>
References: <4909C41A.7000406@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:52168 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbYJ3PLj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 11:11:39 -0400
In-Reply-To: <4909C41A.7000406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Avishay Traeger <avishay@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

This patch ties all operation vectors into a file system superblock
and registers the osdfs file_system_type at module's load time.

* The file system control block (AKA on-disk superblock) resides in
  an object with a special ID (defined in common.h).
  Information included in the file system control block is used to
  fill the in-memory superblock structure at mount time. This object
  is created before the file system is used by mkosdfs.c It contains
  information such as:
	- The file system's magic number
	- The next inode number to be allocated

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/osdfs/Kbuild  |    2 +-
 fs/osdfs/inode.c |  197 +++++++++++++++++++++-
 fs/osdfs/osdfs.h |   30 ++++
 fs/osdfs/super.c |  502 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 729 insertions(+), 2 deletions(-)
 create mode 100644 fs/osdfs/super.c

diff --git a/fs/osdfs/Kbuild b/fs/osdfs/Kbuild
index d6ac8d6..a005c04 100644
--- a/fs/osdfs/Kbuild
+++ b/fs/osdfs/Kbuild
@@ -20,5 +20,5 @@ EXTRA_CFLAGS += -I$(OSD_INC)
 # EXTRA_CFLAGS += -DCONFIG_OSDFS_DEBUG
 endif
 
-osdfs-objs := osd.o inode.o file.o symlink.o namei.o dir.o
+osdfs-objs := osd.o inode.o file.o symlink.o namei.o dir.o super.o
 obj-$(CONFIG_OSDFS_FS) += osdfs.o
diff --git a/fs/osdfs/inode.c b/fs/osdfs/inode.c
index 478805e..b140690 100644
--- a/fs/osdfs/inode.c
+++ b/fs/osdfs/inode.c
@@ -36,6 +36,8 @@
 
 #include "osdfs.h"
 
+static int osdfs_update_inode(struct inode *inode, int do_sync);
+
 /*
  * Test whether an inode is a fast symlink.
  */
@@ -47,6 +49,18 @@ static inline int osdfs_inode_is_fast_symlink(struct inode *inode)
 }
 
 /*
+ * Callback function from osdfs_delete_inode() - don't have much cleaning up to
+ * do.
+ */
+void delete_done(struct osd_request *req, void *p)
+{
+	struct osdfs_sb_info *sbi;
+	free_osd_req(req);
+	sbi = (struct osdfs_sb_info *)p;
+	atomic_dec(&sbi->s_curr_pending);
+}
+
+/*
  * get_block_t - Fill in a buffer_head
  * An OSD takes care of block allocation so we just fake an allocation by
  * putting in the inode's sector_t in the buffer_head.
@@ -61,6 +75,62 @@ int osdfs_get_block(struct inode *inode, sector_t iblock,
 }
 
 /*
+ * Called when the refcount of an inode reaches zero.  We remove the object
+ * from the OSD here.  We make sure the object was created before we try and
+ * delete it.
+ */
+void osdfs_delete_inode(struct inode *inode)
+{
+	struct osdfs_i_info *oi = OSDFS_I(inode);
+	struct osd_request *req = NULL;
+	struct super_block *sb = inode->i_sb;
+	struct osdfs_sb_info *sbi = sb->s_fs_info;
+	int ret;
+
+	truncate_inode_pages(&inode->i_data, 0);
+
+	if (is_bad_inode(inode))
+		goto no_delete;
+	mark_inode_dirty(inode);
+	osdfs_update_inode(inode, inode_needs_sync(inode));
+
+	inode->i_size = 0;
+	if (inode->i_blocks)
+		osdfs_truncate(inode);
+
+	clear_inode(inode);
+
+	req = prepare_osd_remove(sbi->s_dev, sbi->s_pid,
+				 inode->i_ino + OSDFS_OBJ_OFF);
+	if (!req) {
+		printk(KERN_ERR "ERROR: prepare_osd_remove failed\n");
+		return;
+	}
+
+	/* if we are deleting an obj that hasn't been created yet, wait */
+	if (!ObjCreated(oi)) {
+		if (!Obj2BCreated(oi))
+			BUG();
+		else
+			wait_event(oi->i_wq, ObjCreated(oi));
+	}
+
+	ret = osdfs_async_op(req, delete_done, sbi, oi->i_cred);
+	if (ret) {
+		printk(KERN_ERR
+		       "ERROR: @osdfs_delete_inode osdfs_async_op failed\n");
+		free_osd_req(req);
+		return;
+	}
+	atomic_inc(&sbi->s_curr_pending);
+
+	return;
+
+no_delete:
+	clear_inode(inode);
+}
+
+/*
  * Callback function when writepage finishes.  Check for errors, unlock, clean
  * up, etc.
  */
@@ -580,6 +650,132 @@ bad_inode:
 }
 
 /*
+ * Callback function from osdfs_update_inode().
+ */
+void updatei_done(struct osd_request *req, void *p)
+{
+	struct updatei_args *args = (struct updatei_args *)p;
+
+	free_osd_req(req);
+
+	atomic_dec(&args->sbi->s_curr_pending);
+
+	kfree(args->fcb);
+	kfree(args);
+	args = NULL;
+}
+
+/*
+ * Write the inode to the OSD.  Just fill up the struct, and set the attribute
+ * synchronously or asynchronously depending on the do_sync flag.
+ */
+static int osdfs_update_inode(struct inode *inode, int do_sync)
+{
+	struct osdfs_i_info *oi = OSDFS_I(inode);
+	struct super_block *sb = inode->i_sb;
+	struct osdfs_sb_info *sbi = sb->s_fs_info;
+	struct osd_request *req = NULL;
+	struct osdfs_fcb *fcb = NULL;
+	int ret;
+	int n;
+
+	fcb = kmalloc(sizeof(struct osdfs_fcb), GFP_KERNEL);
+	if (!fcb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	fcb->i_mode = cpu_to_be16(inode->i_mode);
+	fcb->i_uid = cpu_to_be32(inode->i_uid);
+	fcb->i_gid = cpu_to_be32(inode->i_gid);
+	fcb->i_links_count = cpu_to_be16(inode->i_nlink);
+	fcb->i_ctime = cpu_to_be32(inode->i_ctime.tv_sec);
+	fcb->i_atime = cpu_to_be32(inode->i_atime.tv_sec);
+	fcb->i_mtime = cpu_to_be32(inode->i_mtime.tv_sec);
+	fcb->i_size = cpu_to_be64(i_size_read(inode));
+	fcb->i_generation = cpu_to_be32(inode->i_generation);
+	fcb->i_objs = cpu_to_be64(oi->i_objs);
+
+	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
+		if (old_valid_dev(inode->i_rdev)) {
+			fcb->i_data[0] = old_encode_dev(inode->i_rdev);
+			fcb->i_data[1] = 0;
+		} else {
+			fcb->i_data[0] = 0;
+			fcb->i_data[1] = new_encode_dev(inode->i_rdev);
+			fcb->i_data[2] = 0;
+		}
+	} else
+		for (n = 0; n < OSDFS_IDATA; n++)
+			fcb->i_data[n] = oi->i_data[n];
+
+	req = prepare_osd_set_attr(sbi->s_dev, sbi->s_pid,
+				 (uint64_t) (inode->i_ino + OSDFS_OBJ_OFF));
+	if (!req) {
+		printk(KERN_ERR "ERROR: prepare set_attr failed.\n");
+		kfree(fcb);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	prepare_set_attr_list_add_entry(req,
+					OSD_PAGE_NUM_IBM_UOBJ_FS_DATA,
+					OSD_ATTR_NUM_IBM_UOBJ_FS_DATA_INODE,
+					OSDFS_INO_ATTR_SIZE,
+					(unsigned char *)fcb);
+
+	if (!ObjCreated(oi)) {
+		if (!Obj2BCreated(oi))
+			BUG();
+		else
+			wait_event(oi->i_wq, ObjCreated(oi));
+	}
+
+	if (do_sync) {
+		ret = osdfs_sync_op(req, sbi->s_timeout, oi->i_cred);
+		free_osd_req(req);
+		kfree(fcb);
+	} else {
+		struct updatei_args *args = NULL;
+
+		args = kmalloc(sizeof(struct updatei_args), GFP_KERNEL);
+		if (!args) {
+			kfree(fcb);
+			ret = -ENOMEM;
+			goto out;
+		}
+		args->sbi = sbi;
+		args->fcb = fcb;
+
+		ret = osdfs_async_op(req, updatei_done, args, oi->i_cred);
+		if (ret) {
+			free_osd_req(req);
+			kfree(fcb);
+			kfree(args);
+			goto out;
+		}
+		atomic_inc(&sbi->s_curr_pending);
+	}
+out:
+	return ret;
+}
+
+int osdfs_write_inode(struct inode *inode, int wait)
+{
+	return osdfs_update_inode(inode, wait);
+}
+
+int osdfs_sync_inode(struct inode *inode)
+{
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_ALL,
+		.nr_to_write = 0,	/* sys_fsync did this */
+	};
+
+	return sync_inode(inode, &wbc);
+}
+
+/*
  * Set inode attributes - just call generic functions.
  */
 int osdfs_setattr(struct dentry *dentry, struct iattr *iattr)
@@ -594,7 +790,6 @@ int osdfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	error = inode_setattr(inode, iattr);
 	return error;
 }
-
 /*
  * Callback function from osdfs_new_inode().  The important thing is that we
  * set the ObjCreated flag so that other methods know that the object exists on
diff --git a/fs/osdfs/osdfs.h b/fs/osdfs/osdfs.h
index 00c89f7..af8b998 100644
--- a/fs/osdfs/osdfs.h
+++ b/fs/osdfs/osdfs.h
@@ -49,6 +49,17 @@
 #endif
 
 /*
+ * struct to hold what we get from mount options
+ */
+struct osdfs_mountopt {
+	const char *dev_name;
+	uint64_t pid;
+	int timeout;
+	bool mkfs;
+	int format; /*in Mbyte*/
+};
+
+/*
  * our extension to the in-memory superblock
  */
 struct osdfs_sb_info {
@@ -107,6 +118,14 @@ static inline struct osdfs_i_info *OSDFS_I(struct inode *inode)
 }
 
 /*
+ * ugly struct so that we can pass two arguments to update_inode's callback
+ */
+struct updatei_args {
+	struct osdfs_sb_info	*sbi;
+	struct osdfs_fcb	*fcb;
+};
+
+/*
  * Maximum count of links to a file
  */
 #define OSDFS_LINK_MAX           32000
@@ -185,9 +204,17 @@ void free_osd_req(struct osd_request *req);
 /* inode.c               */
 void osdfs_truncate(struct inode *inode);
 extern struct inode *osdfs_iget(struct super_block *, unsigned long);
+extern int osdfs_write_inode(struct inode *, int);
+extern void osdfs_delete_inode(struct inode *);
 struct inode *osdfs_new_inode(struct inode *, int);
 int osdfs_setattr(struct dentry *, struct iattr *);
 
+/* super.c:              */
+#ifdef OSDFS_DEBUG
+void osdfs_dprint_internal(char *str, ...);
+#endif
+extern void osdfs_write_super(struct super_block *);
+
 /* dir.c:                */
 int osdfs_add_link(struct dentry *, struct inode *);
 ino_t osdfs_inode_by_name(struct inode *, struct dentry *);
@@ -217,6 +244,9 @@ extern struct address_space_operations osdfs_aops;
 extern struct inode_operations osdfs_dir_inode_operations;
 extern struct inode_operations osdfs_special_inode_operations;
 
+/* super.c           */
+extern struct super_operations osdfs_sops;
+
 /* symlink.c         */
 extern struct inode_operations osdfs_symlink_inode_operations;
 extern struct inode_operations osdfs_fast_symlink_inode_operations;
diff --git a/fs/osdfs/super.c b/fs/osdfs/super.c
new file mode 100644
index 0000000..095b960
--- /dev/null
+++ b/fs/osdfs/super.c
@@ -0,0 +1,502 @@
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
+#include <linux/string.h>
+#include <linux/parser.h>
+#include <linux/vfs.h>
+#include <linux/random.h>
+
+#include "osdfs.h"
+
+/******************************************************************************
+ * MOUNT OPTIONS
+ *****************************************************************************/
+
+/*
+ * osdfs-specific mount-time options.
+ */
+enum { Opt_lun, Opt_tid, Opt_pid, Opt_to, Opt_mkfs, Opt_format, Opt_err };
+
+/*
+ * Our mount-time options.  These should ideally be 64-bit unsigned, but the
+ * kernel's parsing functions do not currently support that.  32-bit should be
+ * sufficient for most applications now.
+ */
+static match_table_t tokens = {
+	{Opt_pid, "pid=%u"},
+	{Opt_to, "to=%u"},
+	{Opt_err, NULL}
+};
+
+/*
+ * The main option parsing method.  Also makes sure that all of the mandatory
+ * mount options were set.
+ */
+static int parse_options(char *options, struct osdfs_mountopt *opts)
+{
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+	int option;
+	int s_pid = 0;
+
+	OSDFS_DBGMSG("parse_options %s\n", options);
+	/* defaults */
+	memset(opts, 0, sizeof(*opts));
+	opts->timeout = 20;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_pid:
+			if (match_int(&args[0], &option))
+				return -EINVAL;
+			if (option < 65536) {
+				printk(KERN_ERR "Partition ID must be >= 65536");
+				return -EINVAL;
+			}
+			opts->pid = option;
+			s_pid = 1;
+			break;
+		case Opt_to:
+			if (match_int(&args[0], &option))
+				return -EINVAL;
+			if (option <= 0) {
+				printk(KERN_ERR "Timout must be > 0");
+				return -EINVAL;
+			}
+			opts->timeout = option;
+			break;
+		}
+	}
+
+	if (!s_pid) {
+		printk(KERN_ERR "Need to specify the following options:\n");
+		printk(KERN_ERR "-o tid=X,lun=Y,pid=Z\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/******************************************************************************
+ * INODE CACHE
+ *****************************************************************************/
+
+/*
+ * Our inode cache.  Isn't it pretty?
+ */
+static struct kmem_cache *osdfs_inode_cachep;
+
+/*
+ * Allocate an inode in the cache
+ */
+static struct inode *osdfs_alloc_inode(struct super_block *sb)
+{
+	struct osdfs_i_info *oi;
+
+	oi = kmem_cache_alloc(osdfs_inode_cachep, GFP_KERNEL);
+	if (!oi)
+		return NULL;
+
+	oi->vfs_inode.i_version = 1;
+	return &oi->vfs_inode;
+}
+
+/*
+ * Remove an inode from the cache
+ */
+static void osdfs_destroy_inode(struct inode *inode)
+{
+	kmem_cache_free(osdfs_inode_cachep, OSDFS_I(inode));
+}
+
+/*
+ * Initialize the inode
+ */
+static void osdfs_init_once(void *foo)
+{
+	struct osdfs_i_info *oi = foo;
+
+	inode_init_once(&oi->vfs_inode);
+}
+
+/*
+ * Create and initialize the inode cache
+ */
+static int init_inodecache(void)
+{
+	osdfs_inode_cachep = kmem_cache_create("osdfs_inode_cache",
+					       sizeof(struct osdfs_i_info),
+					       0, SLAB_RECLAIM_ACCOUNT,
+					       osdfs_init_once);
+	if (osdfs_inode_cachep == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+/*
+ * Destroy the inode cache
+ */
+static void destroy_inodecache(void)
+{
+	kmem_cache_destroy(osdfs_inode_cachep);
+}
+
+/******************************************************************************
+ * SUPERBLOCK FUNCTIONS
+ *****************************************************************************/
+
+/*
+ * Write the superblock to the OSD
+ */
+void osdfs_write_super(struct super_block *sb)
+{
+	struct osdfs_sb_info *sbi;
+	struct osdfs_fscb *fscb = NULL;
+	struct osd_request *req = NULL;
+
+	fscb = kzalloc(sizeof(struct osdfs_fscb), GFP_KERNEL);
+	if (!fscb)
+		return;
+
+	lock_kernel();
+	sbi = sb->s_fs_info;
+	fscb->s_nextid = sbi->s_nextid;
+	fscb->s_magic = sb->s_magic;
+	fscb->s_numfiles = sbi->s_numfiles;
+	fscb->s_newfs = 0;
+
+	req = prepare_osd_write(sbi->s_dev, sbi->s_pid, OSDFS_SUPER_ID,
+				sizeof(struct osdfs_fscb), 0, 0,
+				(unsigned char *)(fscb));
+	if (!req) {
+		printk(KERN_ERR "ERROR: write super failed.\n");
+		kfree(fscb);
+		return;
+	}
+
+	osdfs_sync_op(req, sbi->s_timeout, sbi->s_cred);
+	free_osd_req(req);
+	sb->s_dirt = 0;
+	unlock_kernel();
+	kfree(fscb);
+}
+
+/*
+ * This function is called when the vfs is freeing the superblock.  We just
+ * need to free our own part.
+ */
+static void osdfs_put_super(struct super_block *sb)
+{
+	int num_pend;
+	struct osdfs_sb_info *sbi = sb->s_fs_info;
+
+	/* make sure there are no pending commands */
+	for (num_pend = atomic_read(&sbi->s_curr_pending); num_pend > 0;
+	     num_pend = atomic_read(&sbi->s_curr_pending)) {
+		wait_queue_head_t wq;
+		init_waitqueue_head(&wq);
+		wait_event_timeout(wq,
+				  (atomic_read(&sbi->s_curr_pending) == 0),
+				  msecs_to_jiffies(100));
+	}
+
+	osduld_put_device(sbi->s_dev);
+	kfree(sb->s_fs_info);
+	sb->s_fs_info = NULL;
+}
+
+/*
+ * Read the superblock from the OSD and fill in the fields
+ */
+static int osdfs_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct inode *root;
+	struct osdfs_mountopt *opts = data;
+	struct osdfs_sb_info *sbi = NULL;    /*extended info                  */
+	struct osdfs_fscb fscb;		     /*on-disk superblock info        */
+	struct osd_request *req = NULL;
+	int ret;
+
+	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
+	if (!sbi)
+		return -ENOMEM;
+	sb->s_fs_info = sbi;
+
+	/* use mount options to fill superblock */
+	sbi->s_dev = osduld_path_lookup(opts->dev_name);
+	if (IS_ERR(sbi->s_dev)) {
+		ret = PTR_ERR(sbi->s_dev);
+		sbi->s_dev = NULL;
+		goto free_sbi;
+	}
+
+	sbi->s_pid = opts->pid;
+	sbi->s_timeout = opts->timeout;
+
+	/* fill in some other data by hand */
+	memset(sb->s_id, 0, sizeof(sb->s_id));
+	strcpy(sb->s_id, "osdfs");
+	sb->s_blocksize = OSDFS_BLKSIZE;
+	sb->s_blocksize_bits = OSDFS_BLKSHIFT;
+	atomic_set(&sbi->s_curr_pending, 0);
+	sb->s_bdev = NULL;
+	sb->s_dev = 0;
+
+	/* read data from on-disk superblock object */
+	make_credential(sbi->s_cred, sbi->s_pid, OSDFS_SUPER_ID);
+
+	req = prepare_osd_read(sbi->s_dev, sbi->s_pid, OSDFS_SUPER_ID,
+			       sizeof(struct osdfs_fscb), 0, 0,
+			       (unsigned char *)(&fscb));
+	if (!req) {
+		if (!silent)
+			printk(KERN_ERR
+			       "ERROR: could not prepare read request.\n");
+		ret = -ENOMEM;
+		goto free_sbi;
+	}
+
+	ret = osdfs_sync_op(req, sbi->s_timeout, sbi->s_cred);
+	if (ret != 0) {
+		if (!silent)
+			printk(KERN_ERR "ERROR: read super failed.\n");
+		ret = -EIO;
+		goto free_sbi;
+	}
+
+	sb->s_magic = fscb.s_magic;
+	sbi->s_nextid = fscb.s_nextid;
+	sbi->s_numfiles = fscb.s_numfiles;
+
+	/* make sure what we read from the object store is correct */
+	if (sb->s_magic != OSDFS_SUPER_MAGIC) {
+		if (!silent)
+			printk(KERN_ERR "ERROR: Bad magic value\n");
+		ret = -EINVAL;
+		goto free_sbi;
+	}
+
+	/* start generation numbers from a random point */
+	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
+	spin_lock_init(&sbi->s_next_gen_lock);
+
+	/* set up operation vectors */
+	sb->s_op = &osdfs_sops;
+	root = osdfs_iget(sb, OSDFS_ROOT_ID - OSDFS_OBJ_OFF);
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
+		goto free_sbi;
+	}
+	sb->s_root = d_alloc_root(root);
+	if (!sb->s_root) {
+		iput(root);
+		printk(KERN_ERR "ERROR: get root inode failed\n");
+		ret = -ENOMEM;
+		goto free_sbi;
+	}
+
+	if (!S_ISDIR(root->i_mode)) {
+		dput(sb->s_root);
+		sb->s_root = NULL;
+		printk(KERN_ERR "ERROR: corrupt root inode (mode = %hd)\n",
+		       root->i_mode);
+		ret = -EINVAL;
+		goto free_sbi;
+	}
+
+	ret = 0;
+out:
+	if (req)
+		free_osd_req(req);
+	return ret;
+
+free_sbi:
+	osduld_put_device(sbi->s_dev); /* NULL safe */
+	kfree(sbi);
+	goto out;
+}
+
+/*
+ * Set up the superblock (calls osdfs_fill_super eventually)
+ */
+static int osdfs_get_sb(struct file_system_type *type,
+			  int flags, const char *dev_name,
+			  void *data, struct vfsmount *mnt)
+{
+	struct osdfs_mountopt opts;
+	int ret;
+
+	ret = parse_options((char *) data, &opts);
+	if (ret)
+		return ret;
+
+	opts.dev_name = dev_name;
+	return get_sb_nodev(type, flags, &opts, osdfs_fill_super, mnt);
+}
+
+/*
+ * Return information about the file system state in the buffer.  This is used
+ * by the 'df' command, for example.
+ */
+static int osdfs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	struct super_block *sb = dentry->d_sb;
+	struct osdfs_sb_info *sbi = sb->s_fs_info;
+	uint8_t cred_a[OSD_CAP_LEN];
+	struct osd_request *req = NULL;
+	uint32_t page;
+	uint32_t attr;
+	uint16_t expected;
+	uint64_t capacity;
+	uint64_t used;
+	uint8_t *data;
+	int ret;
+
+	/* get used/capacity attributes */
+	make_credential(cred_a, sbi->s_pid, 0);
+
+	req = prepare_osd_get_attr(sbi->s_dev, sbi->s_pid, 0);
+	if (!req) {
+		printk(KERN_ERR "ERROR: prepare get_attr failed.\n");
+		return -1;
+	}
+
+	prepare_get_attr_list_add_entry(req,
+			OSD_APAGE_PARTITION_QUOTAS,
+			OSD_ATTR_PQ_CAPACITY_QUOTA,
+			8);
+
+	prepare_get_attr_list_add_entry(req,
+			OSD_APAGE_PARTITION_INFORMATION,
+			OSD_ATTR_PI_USED_CAPACITY,
+			8);
+
+	ret = osdfs_sync_op(req, sbi->s_timeout, cred_a);
+	if (ret)
+		goto out;
+
+	page = OSD_APAGE_PARTITION_QUOTAS;
+	attr = OSD_ATTR_PQ_CAPACITY_QUOTA;
+	expected = 8;
+	ret = extract_next_attr_from_req(req, &page, &attr, &expected, &data);
+	if (ret) {
+		printk(KERN_ERR "ERROR: extract attr from req failed\n");
+		goto out;
+	}
+	capacity = be64_to_cpu(*((uint64_t *)data));
+
+	page = OSD_APAGE_PARTITION_INFORMATION;
+	attr = OSD_ATTR_PI_USED_CAPACITY;
+	expected = 8;
+	ret = extract_next_attr_from_req(req, &page, &attr, &expected, &data);
+	if (ret) {
+		printk(KERN_ERR "ERROR: extract attr from req failed\n");
+		goto out;
+	}
+	used = be64_to_cpu(*((uint64_t *)data));
+
+	/* fill in the stats buffer */
+	buf->f_type = OSDFS_SUPER_MAGIC;
+	buf->f_bsize = OSDFS_BLKSIZE;
+	buf->f_blocks = (capacity >> OSDFS_BLKSHIFT);
+	buf->f_bfree = ((capacity - used) >> OSDFS_BLKSHIFT);
+	buf->f_bavail = buf->f_bfree;
+	buf->f_files = sbi->s_numfiles;
+	buf->f_ffree = OSDFS_MAX_ID - sbi->s_numfiles;
+	buf->f_namelen = OSDFS_NAME_LEN;
+out:
+	free_osd_req(req);
+
+	return ret;
+}
+
+struct super_operations osdfs_sops = {
+	.alloc_inode    = osdfs_alloc_inode,
+	.destroy_inode  = osdfs_destroy_inode,
+	.write_inode    = osdfs_write_inode,
+	.delete_inode   = osdfs_delete_inode,
+	.put_super      = osdfs_put_super,
+	.write_super    = osdfs_write_super,
+	.statfs         = osdfs_statfs,
+};
+
+/******************************************************************************
+ * INSMOD/RMMOD
+ *****************************************************************************/
+
+/*
+ * struct that describes this file system
+ */
+static struct file_system_type osdfs_type = {
+	.owner          = THIS_MODULE,
+	.name           = "osdfs",
+	.get_sb         = osdfs_get_sb,
+	.kill_sb        = generic_shutdown_super,
+};
+
+static int __init init_osdfs(void)
+{
+	int err;
+
+	err = init_inodecache();
+	if (err)
+		goto out;
+
+	err = register_filesystem(&osdfs_type);
+	if (err)
+		goto out_d;
+
+	return 0;
+out_d:
+	destroy_inodecache();
+out:
+	return err;
+}
+
+static void __exit exit_osdfs(void)
+{
+	unregister_filesystem(&osdfs_type);
+	destroy_inodecache();
+}
+
+MODULE_AUTHOR("Avishay Traeger <avishay@gmail.com>");
+MODULE_DESCRIPTION("osdfs");
+MODULE_LICENSE("GPL");
+
+module_init(init_osdfs)
+module_exit(exit_osdfs)
-- 
1.6.0.1

