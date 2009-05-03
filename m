From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH -next] osd_uld: fix printk format warning
Date: Sun, 3 May 2009 20:02:38 +0100
Message-ID: <20090503190238.GZ8633@ZenIV.linux.org.uk>
References: <20090429092631.a76e79c5.randy.dunlap@oracle.com> <20090429185128.GN8633@ZenIV.linux.org.uk> <49F97DAF.2050605@panasas.com> <20090503183541.GX8633@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:44596 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbZECTCm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2009 15:02:42 -0400
Content-Disposition: inline
In-Reply-To: <20090503183541.GX8633@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-scsi@vger.kernel.org

On Sun, May 03, 2009 at 07:35:41PM +0100, Al Viro wrote:
> IDGI.  Why not simply do filp_open() and keep struct file * until the
> end to pin the thing down?  And turn your function into
> 	check that file->f_op is &osd_fops, if it isn't - ERR_PTR(-EINVAL),
> if it is - &((...)file->private_data)->od 
> 
> IOW, how about something like this (on top of previous patches)?

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 22b59e1..9fff4ca 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -173,68 +173,19 @@ static const struct file_operations osd_fops = {
 	.unlocked_ioctl = osd_uld_ioctl,
 };
 
-struct osd_dev *osduld_path_lookup(const char *name)
+struct osd_dev *osduld_device(struct file *file)
 {
-	struct path path;
-	struct inode *inode;
-	struct cdev *cdev;
-	struct osd_uld_device *uninitialized_var(oud);
-	int error;
-
-	if (!name || !*name) {
-		OSD_ERR("Mount with !path || !*path\n");
-		return ERR_PTR(-EINVAL);
-	}
-
-	error = kern_path(name, LOOKUP_FOLLOW, &path);
-	if (error) {
-		OSD_ERR("path_lookup of %s failed=>%d\n", name, error);
-		return ERR_PTR(error);
-	}
-
-	inode = path.dentry->d_inode;
-	error = -EINVAL; /* Not the right device e.g osd_uld_device */
-	if (!S_ISCHR(inode->i_mode)) {
-		OSD_DEBUG("!S_ISCHR()\n");
-		goto out;
-	}
-
-	cdev = inode->i_cdev;
-	if (!cdev) {
-		OSD_ERR("Before mounting an OSD Based filesystem\n");
-		OSD_ERR("  user-mode must open+close the %s device\n", name);
-		OSD_ERR("  Example: bash: echo < %s\n", name);
-		goto out;
-	}
+	struct osd_uld_device *oud;
 
 	/* The Magic wand. Is it our char-dev */
 	/* TODO: Support sg devices */
-	if (cdev->owner != THIS_MODULE) {
-		OSD_ERR("Error mounting %s - is not an OSD device\n", name);
-		goto out;
-	}
-
-	oud = container_of(cdev, struct osd_uld_device, cdev);
-
-	__uld_get(oud);
-	error = 0;
-
-out:
-	path_put(&path);
-	return error ? ERR_PTR(error) : &oud->od;
-}
-EXPORT_SYMBOL(osduld_path_lookup);
-
-void osduld_put_device(struct osd_dev *od)
-{
-	if (od) {
-		struct osd_uld_device *oud = container_of(od,
-						struct osd_uld_device, od);
+	if (file->f_op != &osd_fops)
+		return ERR_PTR(-EINVAL);
 
-		__uld_put(oud);
-	}
+	oud = file->private_data;
+	return &oud->od;
 }
-EXPORT_SYMBOL(osduld_put_device);
+EXPORT_SYMBOL(osduld_device);
 
 /*
  * Scsi Device operations
diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
index 0fd4c78..45e41f2 100644
--- a/fs/exofs/exofs.h
+++ b/fs/exofs/exofs.h
@@ -57,6 +57,7 @@
  * our extension to the in-memory superblock
  */
 struct exofs_sb_info {
+	struct file	*s_file;		/* underlying file */
 	struct osd_dev	*s_dev;			/* returned by get_osd_dev    */
 	osd_id		s_pid;			/* partition ID of file system*/
 	int		s_timeout;		/* timeout for OSD operations */
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 3cdb761..c3fcb6d 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -35,9 +35,10 @@
 
 #include <linux/string.h>
 #include <linux/parser.h>
-#include <linux/vfs.h>
+#include <linux/statfs.h>
 #include <linux/random.h>
 #include <linux/exportfs.h>
+#include <linux/file.h>
 
 #include "exofs.h"
 
@@ -271,7 +272,7 @@ static void exofs_put_super(struct super_block *sb)
 				  msecs_to_jiffies(100));
 	}
 
-	osduld_put_device(sbi->s_dev);
+	fput(sbi->s_file);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 }
@@ -295,13 +296,15 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_fs_info = sbi;
 
 	/* use mount options to fill superblock */
-	sbi->s_dev = osduld_path_lookup(opts->dev_name);
-	if (IS_ERR(sbi->s_dev)) {
-		ret = PTR_ERR(sbi->s_dev);
-		sbi->s_dev = NULL;
+	sbi->s_file = filp_open(opts->dev_name, O_RDWR, 0);
+	ret = PTR_ERR(sbi->s_file);
+	if (IS_ERR(sbi->s_file))
 		goto free_sbi;
-	}
 
+	sbi->s_dev = osduld_device(sbi->s_file);
+	ret = PTR_ERR(sbi->s_dev);
+	if (IS_ERR(sbi->s_dev))
+		goto close_sbi;
 	sbi->s_pid = opts->pid;
 	sbi->s_timeout = opts->timeout;
 
@@ -326,7 +329,7 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 			EXOFS_ERR(
 			       "exofs_fill_super: osd_start_request failed.\n");
 		ret = -ENOMEM;
-		goto free_sbi;
+		goto close_sbi;
 	}
 	ret = osd_req_read_kern(or, &obj, 0, &fscb, sizeof(fscb));
 	if (unlikely(ret)) {
@@ -334,7 +337,7 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 			EXOFS_ERR(
 			       "exofs_fill_super: osd_req_read_kern failed.\n");
 		ret = -ENOMEM;
-		goto free_sbi;
+		goto close_sbi;
 	}
 
 	ret = exofs_sync_op(or, sbi->s_timeout, sbi->s_cred);
@@ -342,7 +345,7 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 		if (!silent)
 			EXOFS_ERR("exofs_fill_super: exofs_sync_op failed.\n");
 		ret = -EIO;
-		goto free_sbi;
+		goto close_sbi;
 	}
 
 	sb->s_magic = le16_to_cpu(fscb.s_magic);
@@ -354,7 +357,7 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 		if (!silent)
 			EXOFS_ERR("ERROR: Bad magic value\n");
 		ret = -EINVAL;
-		goto free_sbi;
+		goto close_sbi;
 	}
 
 	/* start generation numbers from a random point */
@@ -368,14 +371,14 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 	if (IS_ERR(root)) {
 		EXOFS_ERR("ERROR: exofs_iget failed\n");
 		ret = PTR_ERR(root);
-		goto free_sbi;
+		goto close_sbi;
 	}
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root) {
 		iput(root);
 		EXOFS_ERR("ERROR: get root inode failed\n");
 		ret = -ENOMEM;
-		goto free_sbi;
+		goto close_sbi;
 	}
 
 	if (!S_ISDIR(root->i_mode)) {
@@ -384,7 +387,7 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 		EXOFS_ERR("ERROR: corrupt root inode (mode = %hd)\n",
 		       root->i_mode);
 		ret = -EINVAL;
-		goto free_sbi;
+		goto close_sbi;
 	}
 
 	ret = 0;
@@ -393,8 +396,9 @@ out:
 		osd_end_request(or);
 	return ret;
 
+close_sbi:
+	fput(sbi->s_file);
 free_sbi:
-	osduld_put_device(sbi->s_dev); /* NULL safe */
 	kfree(sbi);
 	goto out;
 }
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index b24d961..f9b6847 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -55,8 +55,8 @@ struct osd_dev {
 };
 
 /* Retrieve/return osd_dev(s) for use by Kernel clients */
-struct osd_dev *osduld_path_lookup(const char *dev_name); /*Use IS_ERR/ERR_PTR*/
-void osduld_put_device(struct osd_dev *od);
+struct file;
+struct osd_dev *osduld_device(struct file *); /*Use IS_ERR/ERR_PTR*/
 
 /* Add/remove test ioctls from external modules */
 typedef int (do_test_fn)(struct osd_dev *od, unsigned cmd, unsigned long arg);
