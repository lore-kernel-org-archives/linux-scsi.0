From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: scsi_forget_host() and scsi_remove_device()
Date: Mon, 7 Jul 2003 12:06:50 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307071159240.612-100000@ida.rowland.org>
References: <20030706171129.B5690@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:1028 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S267100AbTGGPwQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2003 11:52:16 -0400
In-Reply-To: <20030706171129.B5690@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 6 Jul 2003, Christoph Hellwig wrote:

> a)  struct device/scsi_device misses a proper state bits that sais
>    "I'm gone now".  Mike is implementing this for scsi now but this
>    really needs to be handled at the driver model level as other subsystems
>    have the same problems.
> 
> I'm waiting for Mike to post his patches and will attack a) after that.
> In fact it's quite easy and I could just do it now :)

I'm not sure exactly what you have in mind, but here's an example patch
that does something along the lines you're talking about.  You mentioned
earlier that there needs to be a way to tell sysfs not to make any more
call-backs because the item in question has gone away.  This patch does
exactly that for attribute files.  It guarantees that after
sys_remove_file() -- or the driver model equivalent -- returns, there will
be no calls to the attribute's show() or store() methods.  This isn't 
currently true, because a process can hold an attribute file open even 
after it has been removed.

I implented this in a klugy kind of way, so it shouldn't be considered for 
inclusion in the kernel until someone has cleaned it up.

Is this the sort of thing you're looking for?

Alan Stern


===== bin.c 1.7 vs edited =====
--- 1.7/fs/sysfs/bin.c	Thu Jun 12 12:40:23 2003
+++ edited/fs/sysfs/bin.c	Mon Jul  7 11:34:00 2003
@@ -17,8 +17,15 @@
 {
 	struct bin_attribute * attr = dentry->d_fsdata;
 	struct kobject * kobj = dentry->d_parent->d_fsdata;
+	int rc;
 
-	return attr->read(kobj, buffer, off, count);
+	down(&dentry->d_inode->i_sem);
+	if (ATTR_GONE(dentry))
+		rc = -ENXIO;
+	else
+		rc = attr->read(kobj, buffer, off, count);
+	up(&dentry->d_inode->i_sem);
+	return rc;
 }
 
 static ssize_t
@@ -61,8 +68,15 @@
 {
 	struct bin_attribute *attr = dentry->d_fsdata;
 	struct kobject *kobj = dentry->d_parent->d_fsdata;
+	int rc;
 
-	return attr->write(kobj, buffer, offset, count);
+	down(&dentry->d_inode->i_sem);
+	if (ATTR_GONE(dentry))
+		rc = -ENXIO;
+	else
+		rc = attr->write(kobj, buffer, offset, count);
+	up(&dentry->d_inode->i_sem);
+	return rc;
 }
 
 static ssize_t write(struct file * file, const char __user * userbuf,
===== dir.c 1.2 vs edited =====
--- 1.2/fs/sysfs/dir.c	Mon Mar 17 08:45:12 2003
+++ edited/fs/sysfs/dir.c	Mon Jul  7 11:23:07 2003
@@ -98,6 +98,9 @@
 			 * Unlink and unhash.
 			 */
 			spin_unlock(&dcache_lock);
+			down(&d->d_inode->i_sem);
+			SET_ATTR_GONE(d);
+			up(&d->d_inode->i_sem);
 			simple_unlink(dentry->d_inode,d);
 			dput(d);
 			spin_lock(&dcache_lock);
===== file.c 1.7 vs edited =====
--- 1.7/fs/sysfs/file.c	Wed Jul  2 17:35:09 2003
+++ edited/fs/sysfs/file.c	Mon Jul  7 11:32:43 2003
@@ -77,8 +77,9 @@
  */
 static int fill_read_buffer(struct file * file, struct sysfs_buffer * buffer)
 {
-	struct attribute * attr = file->f_dentry->d_fsdata;
-	struct kobject * kobj = file->f_dentry->d_parent->d_fsdata;
+	struct dentry * dentry = file->f_dentry;
+	struct attribute * attr = dentry->d_fsdata;
+	struct kobject * kobj = dentry->d_parent->d_fsdata;
 	struct sysfs_ops * ops = buffer->ops;
 	int ret = 0;
 	ssize_t count;
@@ -88,7 +89,12 @@
 	if (!buffer->page)
 		return -ENOMEM;
 
-	count = ops->show(kobj,attr,buffer->page);
+	down(&dentry->d_inode->i_sem);
+	if (ATTR_GONE(dentry))
+		count = -ENXIO;
+	else
+		count = ops->show(kobj,attr,buffer->page);
+	up(&dentry->d_inode->i_sem);
 	if (count >= 0)
 		buffer->count = count;
 	else
@@ -198,11 +204,19 @@
 static int 
 flush_write_buffer(struct file * file, struct sysfs_buffer * buffer, size_t count)
 {
-	struct attribute * attr = file->f_dentry->d_fsdata;
-	struct kobject * kobj = file->f_dentry->d_parent->d_fsdata;
+	struct dentry * dentry = file->f_dentry;
+	struct attribute * attr = dentry->d_fsdata;
+	struct kobject * kobj = dentry->d_parent->d_fsdata;
 	struct sysfs_ops * ops = buffer->ops;
+	int rc;
 
-	return ops->store(kobj,attr,buffer->page,count);
+	down(&dentry->d_inode->i_sem);
+	if (ATTR_GONE(dentry))
+		rc = -ENXIO;
+	else
+		rc = ops->store(kobj,attr,buffer->page,count);
+	up(&dentry->d_inode->i_sem);
+	return rc;
 }
 
 
===== inode.c 1.18 vs edited =====
--- 1.18/fs/sysfs/inode.c	Mon Jun  9 13:37:23 2003
+++ edited/fs/sysfs/inode.c	Mon Jul  7 11:23:07 2003
@@ -11,6 +11,7 @@
 #include <linux/pagemap.h>
 #include <linux/namei.h>
 #include <linux/backing-dev.h>
+#include "sysfs.h"
 extern struct super_block * sysfs_sb;
 
 static struct address_space_operations sysfs_aops = {
@@ -97,6 +98,9 @@
 			pr_debug("sysfs: Removing %s (%d)\n", victim->d_name.name,
 				 atomic_read(&victim->d_count));
 
+			down(&victim->d_inode->i_sem);
+			SET_ATTR_GONE(victim);
+			up(&victim->d_inode->i_sem);
 			simple_unlink(dir->d_inode,victim);
 			d_delete(victim);
 		}
===== sysfs.h 1.1 vs edited =====
--- 1.1/fs/sysfs/sysfs.h	Wed Mar  5 00:02:34 2003
+++ edited/fs/sysfs/sysfs.h	Mon Jul  7 11:30:03 2003
@@ -4,7 +4,16 @@
 extern struct inode * sysfs_new_inode(mode_t mode);
 extern int sysfs_create(struct dentry *, int mode, int (*init)(struct inode *));
 
-extern struct dentry * sysfs_get_dentry(struct dentry *, char *);
+extern struct dentry * sysfs_get_dentry(struct dentry *, const char *);
 
 extern void sysfs_hash_and_remove(struct dentry * dir, const char * name);
 
+/*
+ * Misuse an attribute's inode's i_mode: set it to 0 to indicate that the
+ * attribute file has been removed.
+ */
+
+#define ATTR_GONE(dentry)	((dentry)->d_inode->i_mode == 0)
+
+#define SET_ATTR_GONE(dentry)	do {		\
+		(dentry)->d_inode->i_mode = 0;	} while (0)

