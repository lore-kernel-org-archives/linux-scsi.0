From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct
	kobject source.
Date: Thu, 16 Oct 2008 23:55:55 -0700
Message-ID: <1224226555.5556.279.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-62ut5yn8Rk951cQbD2id"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Joel Becker <joel.becker@oracle.com>, Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org


--=-62ut5yn8Rk951cQbD2id
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Joel, Greg and Co,

Here is the the first working code for allowing configfs to handle
symlinks from sysfs struct kobject based code.  Here is the commit:
passing struct kobject into generic target_core_mod subsystem plugins
for locating struct block_device and struct scsi_device..  

-------------------------------------------------------------------------

In struct configfs_item_operations, added allow_link_kobject() and
drop_link_kobject() to allow struct kobject to be passed through
the configfs API.  The code for kobject symlink source sits along side
the exist configfs symlink code, and does not break existing apps that use
allow_link() or drop_link().

Also, there is two large FIXMEs with the first commit,  in
fs/configfs/symlink.c:configfs_symlink() related to comparing
struct nameidata nd.path.dentry->d_sb == sysfs_sb.

The 2nd is when doing a 'ls -la' inside of the config group directory
containg the symlink source from sysfs, the source link does not currently
appear..  I will be following up these two items..

Signed-off-by: Nicholas A. Bellinger
---
 fs/configfs/configfs_internal.h |    3 +-
 fs/configfs/symlink.c           |  168 +++++++++++++++++++++++++++------------
 include/linux/configfs.h        |    6 +-
 3 files changed, 123 insertions(+), 54 deletions(-)

the following commit can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commit;h=317aefe74354c0140dc8aebff1ef9467b6f0c9ba

Comments..?  I will send along my patch to
drivers/lio-core/target_core_configfs.c in a moment to demonstrate how
to pull it all together with struct config_item_operations
allow_link_kobject() and drop_link_kobject()..

--=-62ut5yn8Rk951cQbD2id
Content-Disposition: attachment; filename=0001-ConfigFS-Allow-symbolic-links-from-a-SysFS-struct.patch
Content-Type: application/mbox; name=0001-ConfigFS-Allow-symbolic-links-from-a-SysFS-struct.patch
Content-Transfer-Encoding: 7bit

>From 317aefe74354c0140dc8aebff1ef9467b6f0c9ba Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 16 Oct 2008 22:46:16 -0700
Subject: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct kobject source.

In struct configfs_item_operations, added allow_link_kobject() and
drop_link_kobject() to allow struct kobject to be passed through
the configfs API.  The code for kobject symlink source sits along side
the exist configfs symlink code, and does not break existing apps that use
allow_link() or drop_link().

Also, there is two large FIXMEs with the first commit,  in
fs/configfs/symlink.c:configfs_symlink() related to comparing
struct nameidata nd.path.dentry->d_sb == sysfs_sb.

The 2nd is when doing a 'ls -la' inside of the config group directory
containg the symlink source from sysfs, the source link does not currently
appear..  I will be following up these two items..

Signed-off-by: Nicholas A. Bellinger
---
 fs/configfs/configfs_internal.h |    3 +-
 fs/configfs/symlink.c           |  168 +++++++++++++++++++++++++++------------
 include/linux/configfs.h        |    6 +-
 3 files changed, 123 insertions(+), 54 deletions(-)

diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
index 762d287..3e310d9 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -94,7 +94,8 @@ extern int configfs_unlink(struct inode *dir, struct dentry *dentry);
 
 struct configfs_symlink {
 	struct list_head sl_list;
-	struct config_item *sl_target;
+	struct config_item *sl_target; /* Symlink source of ConfigFS */
+	struct kobject *sl_kobject; /* Symlink source of SysFS */
 };
 
 extern int configfs_create_link(struct configfs_symlink *sl,
diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index bf74973..15c0e48 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -22,18 +22,26 @@
  * 	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
  *
  * configfs Copyright (C) 2005 Oracle.  All rights reserved.
+ *
+ * Added ConfigFS <-> SysFS Symlink support for Linux-ISCSI.org
+ * Copyright (C) 2008 Nicholas A. Bellinger <nab@kernel.org>
  */
 
 #include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/namei.h>
-
+#include <linux/sysfs.h>
+#include <linux/kobject.h>
 #include <linux/configfs.h>
 #include "configfs_internal.h"
+#include "../sysfs/sysfs.h" // SysFS Internal
 
 /* Protects attachments of new symlinks */
 DEFINE_MUTEX(configfs_symlink_mutex);
 
+/* Used for sysfs kobject symlinks */
+extern struct super_block *sysfs_sb;
+
 static int item_depth(struct config_item * item)
 {
 	struct config_item * p = item;
@@ -80,7 +88,7 @@ static int create_link(struct config_item *parent_item,
 	if (!configfs_dirent_is_ready(target_sd))
 		goto out;
 	ret = -ENOMEM;
-	sl = kmalloc(sizeof(struct configfs_symlink), GFP_KERNEL);
+	sl = kzalloc(sizeof(struct configfs_symlink), GFP_KERNEL);
 	if (sl) {
 		sl->sl_target = config_item_get(item);
 		spin_lock(&configfs_dirent_lock);
@@ -107,34 +115,37 @@ out:
 	return ret;
 }
 
-
-static int get_target(const char *symname, struct nameidata *nd,
-		      struct config_item **target)
+static int create_link_sysfs(struct config_item *parent_item,
+			     struct kobject *kobj,
+			     struct dentry *dentry)
 {
-	int ret;
+	struct configfs_symlink *sl;
+	int ret = -ENOMEM;
 
-	ret = path_lookup(symname, LOOKUP_FOLLOW|LOOKUP_DIRECTORY, nd);
-	if (!ret) {
-		if (nd->path.dentry->d_sb == configfs_sb) {
-			*target = configfs_get_config_item(nd->path.dentry);
-			if (!*target) {
-				ret = -ENOENT;
-				path_put(&nd->path);
-			}
-		} else
-			ret = -EPERM;
+	sl = kzalloc(sizeof(struct configfs_symlink), GFP_KERNEL);
+	if (sl) {
+		/*
+		 * Grab the reference to sysfs's struct kobject.
+		 * It will be released in configfs_unlink().
+		 */
+		sl->sl_kobject = kobject_get(kobj);
+
+		ret = configfs_create_link(sl, parent_item->ci_dentry, dentry);
+		if (ret) { 
+			kobject_put(kobj);
+			kfree(sl);
+		}
 	}
 
 	return ret;
 }
 
-
 int configfs_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
 {
 	int ret;
 	struct nameidata nd;
 	struct configfs_dirent *sd;
-	struct config_item *parent_item;
+	struct config_item *parent_item = NULL;
 	struct config_item *target_item;
 	struct config_item_type *type;
 
@@ -156,30 +167,73 @@ int configfs_symlink(struct inode *dir, struct dentry *dentry, const char *symna
 
 	ret = -EPERM;
 	if (!type || !type->ct_item_ops ||
-	    !type->ct_item_ops->allow_link)
+	    (!(type->ct_item_ops->allow_link) &&
+	     !(type->ct_item_ops->allow_link_kobject)))
+		goto out;
+	/*
+	 * Populate struct nameidata nd with Symlink SOURCE fs/ pointers..
+	 */
+	if ((ret = path_lookup(symname, LOOKUP_FOLLOW|LOOKUP_DIRECTORY, &nd)) < 0)
 		goto out_put;
-
-	ret = get_target(symname, &nd, &target_item);
-	if (ret)
+	/*
+	 * First check if the symlink destination is coming from a configfs
+	 * struct config_item..
+	 */
+	if (nd.path.dentry->d_sb == configfs_sb) {
+		if (!(type->ct_item_ops->allow_link)) {
+			ret = -EPERM;
+			goto out_put;
+		}
+		if (!(target_item = configfs_get_config_item(nd.path.dentry))) {
+			ret = -ENOENT;
+			goto out_put;
+		}
+		if (!(ret = type->ct_item_ops->allow_link(parent_item, target_item))) {
+			mutex_lock(&configfs_symlink_mutex);
+			ret = create_link(parent_item, target_item, dentry);
+			mutex_unlock(&configfs_symlink_mutex);
+			if (ret && type->ct_item_ops->drop_link)
+				type->ct_item_ops->drop_link(parent_item,
+							     target_item);
+		}
+		/*
+		 * Release reference to ConfigFS Symlink SOURCE from 
+		 * configfs_get_config_item()
+		 */
+		config_item_put(target_item);
+//	} else if (nd.path.dentry->d_sb == sysfs_sb) {
+#warning FIXME: How to determine which nameidata is from sysfs..?
+	} else if (1) {
+		struct sysfs_dirent *sd = (struct sysfs_dirent *)nd.path.dentry->d_fsdata;
+		struct kobject *kobj = sd->s_dir.kobj;
+
+		if (!(type->ct_item_ops->allow_link_kobject)) {
+			ret = -EPERM;
+			goto out_put;
+		}
+		/*
+		 * Now from a sysfs struct kobject..
+		 */
+		printk("Using struct kobject: %s for symlink source, %s configfs destination\n",
+				kobject_name(kobj), config_item_name(parent_item));
+
+		if (!(ret = type->ct_item_ops->allow_link_kobject(parent_item, kobj))) {
+			mutex_lock(&configfs_symlink_mutex);
+			ret = create_link_sysfs(parent_item, kobj, dentry);
+			mutex_unlock(&configfs_symlink_mutex);
+			if (ret && type->ct_item_ops->drop_link_kobject)
+				type->ct_item_ops->drop_link_kobject(parent_item,
+								     kobj);
+		}
+	} else {
+		ret = -EPERM;
 		goto out_put;
-
-	ret = type->ct_item_ops->allow_link(parent_item, target_item);
-	if (!ret) {
-		mutex_lock(&configfs_symlink_mutex);
-		ret = create_link(parent_item, target_item, dentry);
-		mutex_unlock(&configfs_symlink_mutex);
-		if (ret && type->ct_item_ops->drop_link)
-			type->ct_item_ops->drop_link(parent_item,
-						     target_item);
 	}
 
-	config_item_put(target_item);
-	path_put(&nd.path);
-
 out_put:
-	config_item_put(parent_item);
-
+	path_put(&nd.path);
 out:
+	config_item_put(parent_item);
 	return ret;
 }
 
@@ -209,22 +263,34 @@ int configfs_unlink(struct inode *dir, struct dentry *dentry)
 	dput(dentry);
 	configfs_put(sd);
 
-	/*
-	 * drop_link() must be called before
-	 * list_del_init(&sl->sl_list), so that the order of
-	 * drop_link(this, target) and drop_item(target) is preserved.
-	 */
-	if (type && type->ct_item_ops &&
-	    type->ct_item_ops->drop_link)
-		type->ct_item_ops->drop_link(parent_item,
-					       sl->sl_target);
-
-	spin_lock(&configfs_dirent_lock);
-	list_del_init(&sl->sl_list);
-	spin_unlock(&configfs_dirent_lock);
+	if (sl->sl_target) {
+		/*
+		 * drop_link() must be called before list_del_init(&sl->sl_list),
+		 * so that the order of drop_link(this, target) and drop_item(target)
+		 * is preserved.
+		 */
+		if (type && type->ct_item_ops &&
+		    type->ct_item_ops->drop_link)
+			type->ct_item_ops->drop_link(parent_item, sl->sl_target);
 
-	/* Put reference from create_link() */
-	config_item_put(sl->sl_target);
+		spin_lock(&configfs_dirent_lock);
+		list_del_init(&sl->sl_list);
+		spin_unlock(&configfs_dirent_lock);
+		/*
+		 * Put reference from create_link()
+		 */
+		config_item_put(sl->sl_target);
+		sl->sl_target = NULL;
+	} else if (sl->sl_kobject) {
+		if (type && type->ct_item_ops &&
+		   type->ct_item_ops->drop_link_kobject)
+			type->ct_item_ops->drop_link_kobject(parent_item, sl->sl_kobject);
+		/*
+		 * Put reference from create_link_sysfs()
+		 */
+		kobject_put(sl->sl_kobject);
+		sl->sl_kobject = NULL;
+	}
 	kfree(sl);
 
 	config_item_put(parent_item);
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 7f62777..7b4e8ec 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -225,8 +225,10 @@ struct configfs_item_operations {
 	void (*release)(struct config_item *);
 	ssize_t	(*show_attribute)(struct config_item *, struct configfs_attribute *,char *);
 	ssize_t	(*store_attribute)(struct config_item *,struct configfs_attribute *,const char *, size_t);
-	int (*allow_link)(struct config_item *src, struct config_item *target);
-	int (*drop_link)(struct config_item *src, struct config_item *target);
+	int (*allow_link)(struct config_item *dst, struct config_item *src);
+	int (*drop_link)(struct config_item *dst, struct config_item *src);
+	int (*allow_link_kobject)(struct config_item *dst, struct kobject *src_kobj);
+	int (*drop_link_kobject)(struct config_item *dst, struct kobject *src_kobj);
 };
 
 struct configfs_group_operations {
-- 
1.5.4.1


--=-62ut5yn8Rk951cQbD2id--

