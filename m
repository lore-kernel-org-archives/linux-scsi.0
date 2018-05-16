From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/42] proc: simplify proc_register calling conventions
Date: Wed, 16 May 2018 11:43:08 +0200
Message-ID: <20180516094346.20506-5-hch@lst.de>
References: <20180516094346.20506-1-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516094346.20506-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Return registered entry on success, return NULL on failure and free the
passed in entry.  Also expose it in internal.h as we'll start using it
in proc_net.c soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/proc/generic.c  | 44 ++++++++++++++++++--------------------------
 fs/proc/internal.h |  2 ++
 2 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 2078e70e1595..bd8480ff0d35 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -346,13 +346,12 @@ static const struct inode_operations proc_dir_inode_operations = {
 	.setattr	= proc_notify_change,
 };
 
-static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp)
+/* returns the registered entry, or frees dp and returns NULL on failure */
+struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
+		struct proc_dir_entry *dp)
 {
-	int ret;
-
-	ret = proc_alloc_inum(&dp->low_ino);
-	if (ret)
-		return ret;
+	if (proc_alloc_inum(&dp->low_ino))
+		goto out_free_entry;
 
 	write_lock(&proc_subdir_lock);
 	dp->parent = dir;
@@ -360,12 +359,16 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
 		WARN(1, "proc_dir_entry '%s/%s' already registered\n",
 		     dir->name, dp->name);
 		write_unlock(&proc_subdir_lock);
-		proc_free_inum(dp->low_ino);
-		return -EEXIST;
+		goto out_free_inum;
 	}
 	write_unlock(&proc_subdir_lock);
 
-	return 0;
+	return dp;
+out_free_inum:
+	proc_free_inum(dp->low_ino);
+out_free_entry:
+	pde_free(dp);
+	return NULL;
 }
 
 static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
@@ -443,10 +446,7 @@ struct proc_dir_entry *proc_symlink(const char *name,
 		if (ent->data) {
 			strcpy((char*)ent->data,dest);
 			ent->proc_iops = &proc_link_inode_operations;
-			if (proc_register(parent, ent) < 0) {
-				pde_free(ent);
-				ent = NULL;
-			}
+			ent = proc_register(parent, ent);
 		} else {
 			pde_free(ent);
 			ent = NULL;
@@ -470,11 +470,9 @@ struct proc_dir_entry *proc_mkdir_data(const char *name, umode_t mode,
 		ent->proc_fops = &proc_dir_operations;
 		ent->proc_iops = &proc_dir_inode_operations;
 		parent->nlink++;
-		if (proc_register(parent, ent) < 0) {
-			pde_free(ent);
+		ent = proc_register(parent, ent);
+		if (!ent)
 			parent->nlink--;
-			ent = NULL;
-		}
 	}
 	return ent;
 }
@@ -505,11 +503,9 @@ struct proc_dir_entry *proc_create_mount_point(const char *name)
 		ent->proc_fops = NULL;
 		ent->proc_iops = NULL;
 		parent->nlink++;
-		if (proc_register(parent, ent) < 0) {
-			pde_free(ent);
+		ent = proc_register(parent, ent);
+		if (!ent)
 			parent->nlink--;
-			ent = NULL;
-		}
 	}
 	return ent;
 }
@@ -539,11 +535,7 @@ struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
 	pde->proc_fops = proc_fops;
 	pde->data = data;
 	pde->proc_iops = &proc_file_inode_operations;
-	if (proc_register(parent, pde) < 0)
-		goto out_free;
-	return pde;
-out_free:
-	pde_free(pde);
+	return proc_register(parent, pde);
 out:
 	return NULL;
 }
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 0f1692e63cb6..488e67490312 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -162,6 +162,8 @@ extern bool proc_fill_cache(struct file *, struct dir_context *, const char *, i
 /*
  * generic.c
  */
+struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
+		struct proc_dir_entry *dp);
 extern struct dentry *proc_lookup(struct inode *, struct dentry *, unsigned int);
 struct dentry *proc_lookup_de(struct inode *, struct dentry *, struct proc_dir_entry *);
 extern int proc_readdir(struct file *, struct dir_context *);
-- 
2.17.0
