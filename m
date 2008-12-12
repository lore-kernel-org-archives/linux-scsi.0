From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/ConfigFS 12/12]: Remove
	do_configfs_mkdir() and do_configfs_rmdir()
Date: Fri, 12 Dec 2008 01:37:02 -0800
Message-ID: <1229074622.4153.664.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:20180 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757034AbYLLJhF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 04:37:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>

>From 79f98e53a0b4906cd5b4bfadf2d65345c3dcf8a5 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 12 Dec 2008 01:07:06 -0800
Subject: [PATCH] [Target_Core_Mod/ConfigFS]: Remove do_configfs_mkdir() and do_configfs_rmdir()

This patch removes the temporary debug functions used for Target_Core_Mod and
LIO-Target v3.0 bringup, as required by the ConfigFS maintainer.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_configfs.c |  122 +------------------------------
 1 files changed, 4 insertions(+), 118 deletions(-)

diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 77950c1..0fceeab 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -34,19 +34,11 @@
 #include <linux/syscalls.h>
 #include <linux/configfs.h>
 
-#include <iscsi_debug.h>
-#include <iscsi_lists.h>
-#include <iscsi_protocol.h>
-#include <iscsi_debug_opcodes.h>
-#include <iscsi_target_core.h>
 #include <target_core_base.h>
-#include <iscsi_target_error.h>
 #include <target_core_device.h>
-#include <iscsi_target_device.h>
 #include <target_core_hba.h>
 #include <target_core_plugin.h>
 #include <target_core_transport.h>
-#include <iscsi_target.h>
 
 #ifdef SNMP_SUPPORT
 #include <linux/proc_fs.h>
@@ -325,116 +317,6 @@ extern struct config_item *target_fabric_configfs_find_by_name (
 	return(fabric);
 }
 
-static long do_configfs_mkdir (struct config_item *item, const char *path, int mode)
-{
-//	char *s;
-	struct dentry *dentry;
-	struct nameidata nd;
-	int error = 0;	
-#if 0
-	s = __getname();
-	if (IS_ERR(s)) {
-		printk("__getname() failed\n");
-		return(PTR_ERR(s));
-	}
-#endif
-	if ((error = path_lookup(path, LOOKUP_PARENT, &nd))) {
-		printk("path_lookup() failed for %s, error: %d\n", path, error);
-//		putname(s);
-		return(error);
-	}
-
-	dentry = lookup_create(&nd, 1);
-	error = PTR_ERR(dentry);
-	if (IS_ERR(dentry)) {
-		printk("lookup_create() returned error: %d\n", error);
-		goto out;
-	}
-
-	printk("Calling vfs_mkdir() d_inode: %p dentry: %p\n",
-		item->ci_dentry->d_inode, dentry);
-
-	error = vfs_mkdir(item->ci_dentry->d_inode, dentry, mode);
-	
-	dput(dentry);
-out:
-	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-	path_put(&nd.path);
-//	putname(s);
-
-	return(error);
-}
-
-#if 1
-
-/*
- * fs/namei.c:lookup_hash() is not defined as EXPORT_SYMBOL()
- */
-extern struct dentry *lookup_hash(struct nameidata *);
-
-static long do_configfs_rmdir (struct config_item *item, const char *path)
-{
-	struct dentry *dentry;
-	struct nameidata nd;
-	int error = 0;
-	
-	if ((error = path_lookup(path, LOOKUP_PARENT, &nd))) {
-		printk("path_lookup() failed for %s, error: %d\n", path, error);
-		return(error);
-	}
-
-	/*
-	 * lookup_hash() is not exported from fs/namei.c..
-	 */
-	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
-	dentry = lookup_hash(&nd);
-	error = PTR_ERR(dentry);
-	if (IS_ERR(dentry)) {
-		printk("lookup_hash() returned error: %d\n", error);
-		goto unlock;
-	}
-
-	printk("Calling vfs_rmdir() d_inode: %p dentry: %p\n",
-		item->ci_dentry->d_inode, dentry);
-
-	error = vfs_rmdir(item->ci_dentry->d_inode, dentry);
-
-	dput(dentry);
-unlock:
-	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-	path_put(&nd.path);
-
-	return(error);
-}
-
-#else
-
-static long do_configfs_rmdir (struct config_item *item, const char *path)
-{
-	struct dentry *dentry;
-	int error = 0;
-
-	mutex_lock(&item->ci_dentry->d_inode->i_mutex);	
-	dentry = lookup_one_len(path, item->ci_dentry, strlen(path));
-	error = PTR_ERR(dentry);
-	if (IS_ERR(dentry)) {
-		printk("lookup_one_len() returned error: %d\n", error);
-		goto unlock;
-	}
-
-	printk("Calling vfs_rmdir() d_inode: %p dentry: %p\n",
-		item->ci_dentry->d_inode, dentry);
-	error = vfs_rmdir(item->ci_dentry->d_inode, dentry);
-	printk("vfs_rmdir() returned %d\n", error);
-	
-	dput(dentry);
-unlock:
-	mutex_unlock(&item->ci_dentry->d_inode->i_mutex);
-	return(error);
-}
-
-#endif
-
 /*
  * Called 2nd from fabric module with returned parameter of
  * struct target_fabric_configfs * from target_fabric_configfs_init().
@@ -1112,6 +994,10 @@ extern int target_core_init_configfs (void)
 #endif
 	int ret;
 
+	printk("TARGET_CORE[0]: Loading Generic Kernel Storage Engine: %s on %s/%s"
+		" on "UTS_RELEASE"\n", TARGET_CORE_VERSION, utsname()->sysname,
+		utsname()->machine);
+
 	subsys = target_core_subsystem[0];	
 	config_group_init(&subsys->su_group);
 	mutex_init(&subsys->su_mutex);
-- 
1.5.4.1



