From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Mon, 2 Apr 2007 04:59:43 +0900
Message-ID: <20070401195943.GA29627@htj.dyndns.org>
References: <460CDBA6.5030608@gmail.com> <1175257751.3760.19.camel@mulgrave.il.steeleye.com> <460D12B8.6050101@gmail.com> <1175278774.3760.44.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.225]:16692 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbXDAT7v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Apr 2007 15:59:51 -0400
Received: by wr-out-0506.google.com with SMTP id 76so1339254wra
        for <linux-scsi@vger.kernel.org>; Sun, 01 Apr 2007 12:59:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1175278774.3760.44.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: gregkh@suse.de, hugh@veritas.com, cornelia.huck@de.ibm.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello, James, Greg.

On Fri, Mar 30, 2007 at 01:19:34PM -0500, James Bottomley wrote:
> That's sort of what I was reaching for too ... it just looks to me that
> all the sysfs glue is in kobject, so they make a good candidate for the
> pure sysfs objects.  Whatever we do, there has to be breakable cross
> linking between the driver's tree and the sysfs representation ... of
> course, nasty things like ksets get in the way of considering the
> objects as separate, sigh.

The dependency between kobject and sysfs doesn't seem to be that
tight.  I managed to break them such that sysfs can disconnect from
its kobject on deletion _without_ changing sysfs/kobject API.

> > This way the sysfs reference counting can be put completely out of
> > picture without impacting the rest of code.  Handling symlink and
> > suicidal attributes might need some extra attention but I think they can
> > be done.
> 
> True ... but you'll also have to implement something within sysfs to do
> refcounting ... it needs to know how long to keep its nodes around.

sysfs_dirent already had reference counter and plays that role quite
nicely.

Okay, here's preliminary patch.  I've tested it very lightly so it's
likely to contain bugs and definitely needs to be splitted.

Dependencies between sysfs/kobject objects are clearer now and I think
I got the locking and referencing correct.  This patch immediately
fixes 'sysfs attr grabbing the wrong kobject and module' problem -
sysfs and module lifetimes are unrelated now.  We can drop
half-working attr->owner.

* A sysfs node no longer hold reference to its kobject.  It just
  attaches itself to the kobject on creation and detaches on deletion.

* For a dir node, sysfs_dirent no longer directly points to kobject.
  It points to sysfs_dir which contains pointer to kobject and a rwsem
  to protect it.

* An open file doesn't hold a reference to kobject.  It holds a
  reference to sysfs_dirent.  kobject pointer is verified and
  show/store are performed with rwsem read-locked.  Deletion
  disconnects the sysfs from its kobject while the rwsem is
  write-locked.  This mechanism replaces buffer orphaning and kobject
  validation during open.

* attr ops is determined on sysfs node creation not on open.  This is
  a step toward making kobject opaque in sysfs.

* bin files are handled similarly but mmap makes the open file hold
  reference to the kobject till it's closed.  Any better ideas?

* symlink is reimplemented in terms of sysfs_dirents instead of
  kobjects.  sysfs_dirent->s_parent is added and each sysfs_dirent
  holds reference to its parent.  Currently walking up the tree
  requires read locking and unlocking sysfs_dir at each level.  This
  can be removed if name is added to sysfs_dirent.

* As kobject can be disconnected anytime and sysfs code still needs to
  look follow dentry link in kobject, kobject->dentry is protected by
  dcache_lock.  Once kobject becomes opaque to sysfs, this hack can go
  away.  All in all, making kobject completely opaque in sysfs isn't
  too far away after this patch although it would require mass code
  update.

What do you think about this approach?  If it's acceptable, I'll test
further and split the patch into logical steps to get it reviewed
better.

Thanks.

---
 fs/sysfs/bin.c     |  121 +++++++++++++++++++++++++++++++---------
 fs/sysfs/dir.c     |  134 ++++++++++++++++++++++++++++++++++++++------
 fs/sysfs/file.c    |  158 ++++++++++++++++++++++-------------------------------
 fs/sysfs/inode.c   |   25 --------
 fs/sysfs/mount.c   |    9 ---
 fs/sysfs/symlink.c |  115 +++++++++++++++++++++++---------------
 fs/sysfs/sysfs.h   |   75 +++++--------------------
 7 files changed, 366 insertions(+), 271 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index d3b9f5f..0c4671b 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -20,26 +20,41 @@
 
 #include "sysfs.h"
 
+struct bin_buffer {
+	struct mutex	mutex;
+	void		*buffer;
+	int		mmapped;
+};
+
 static int
 fill_read(struct dentry *dentry, char *buffer, loff_t off, size_t count)
 {
 	struct bin_attribute * attr = to_bin_attr(dentry);
-	struct kobject * kobj = to_kobj(dentry->d_parent);
+	struct sysfs_dirent * sd = dentry->d_parent->d_fsdata;
+	struct kobject * kobj;
+	int rc;
 
 	if (!attr->read)
 		return -EIO;
 
-	return attr->read(kobj, buffer, off, count);
+	kobj = sysfs_get_kobj(sd);
+	if (!kobj)
+		return -ENODEV;
+
+	rc = attr->read(kobj, buffer, off, count);
+
+	sysfs_put_kobj(sd);
+
+	return rc;
 }
 
 static ssize_t
 read(struct file * file, char __user * userbuf, size_t count, loff_t * off)
 {
-	char *buffer = file->private_data;
+	struct bin_buffer *bb = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
-	int ret;
 
 	if (count > PAGE_SIZE)
 		count = PAGE_SIZE;
@@ -51,18 +66,23 @@ read(struct file * file, char __user * userbuf, size_t count, loff_t * off)
 			count = size - offs;
 	}
 
-	ret = fill_read(dentry, buffer, offs, count);
-	if (ret < 0) 
-		return ret;
-	count = ret;
+	mutex_lock(&bb->mutex);
 
-	if (copy_to_user(userbuf, buffer, count))
-		return -EFAULT;
+	count = fill_read(dentry, bb->buffer, offs, count);
+	if (count < 0)
+		goto out_unlock;
+
+	if (copy_to_user(userbuf, bb->buffer, count)) {
+		count = -EFAULT;
+		goto out_unlock;
+	}
 
 	pr_debug("offs = %lld, *off = %lld, count = %zd\n", offs, *off, count);
 
 	*off = offs + count;
 
+ out_unlock:
+	mutex_unlock(&bb->mutex);
 	return count;
 }
 
@@ -70,18 +90,28 @@ static int
 flush_write(struct dentry *dentry, char *buffer, loff_t offset, size_t count)
 {
 	struct bin_attribute *attr = to_bin_attr(dentry);
-	struct kobject *kobj = to_kobj(dentry->d_parent);
+	struct sysfs_dirent * sd = dentry->d_parent->d_fsdata;
+	struct kobject * kobj;
+	int rc;
 
 	if (!attr->write)
 		return -EIO;
 
-	return attr->write(kobj, buffer, offset, count);
+	kobj = sysfs_get_kobj(sd);
+	if (!kobj)
+		return -ENODEV;
+
+	rc = attr->write(kobj, buffer, offset, count);
+
+	sysfs_put_kobj(sd);
+
+	return rc;
 }
 
 static ssize_t write(struct file * file, const char __user * userbuf,
 		     size_t count, loff_t * off)
 {
-	char *buffer = file->private_data;
+	struct bin_buffer *bb = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
@@ -95,34 +125,60 @@ static ssize_t write(struct file * file, const char __user * userbuf,
 			count = size - offs;
 	}
 
-	if (copy_from_user(buffer, userbuf, count))
-		return -EFAULT;
+	mutex_lock(&bb->mutex);
 
-	count = flush_write(dentry, buffer, offs, count);
+	if (copy_from_user(bb->buffer, userbuf, count)) {
+		count = -EFAULT;
+		goto out_unlock;
+	}
+
+	count = flush_write(dentry, bb->buffer, offs, count);
 	if (count > 0)
 		*off = offs + count;
+
+ out_unlock:
+	mutex_unlock(&bb->mutex);
 	return count;
 }
 
 static int mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct bin_buffer *bb = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
 	struct bin_attribute *attr = to_bin_attr(dentry);
-	struct kobject *kobj = to_kobj(dentry->d_parent);
+	struct sysfs_dirent *sd = dentry->d_parent->d_fsdata;
+	struct kobject *kobj;
+	int rc;
 
 	if (!attr->mmap)
 		return -EINVAL;
 
-	return attr->mmap(kobj, attr, vma);
+	kobj = sysfs_get_kobj(sd);
+	if (!kobj)
+		return -ENODEV;
+
+	mutex_lock(&bb->mutex);
+
+	rc = attr->mmap(kobj, attr, vma);
+
+	if (rc == 0 && !bb->mmapped)
+		bb->mmapped = 1;
+	else
+		sysfs_put_kobj(sd);
+
+	mutex_unlock(&bb->mutex);
+
+	return rc;
 }
 
 static int open(struct inode * inode, struct file * file)
 {
-	struct kobject *kobj = sysfs_get_kobject(file->f_path.dentry->d_parent);
+	struct sysfs_dirent *sd = sysfs_get(file->f_path.dentry->d_parent->d_fsdata);
 	struct bin_attribute * attr = to_bin_attr(file->f_path.dentry);
+	struct bin_buffer *bb = NULL;
 	int error = -EINVAL;
 
-	if (!kobj || !attr)
+	if (!attr)
 		goto Done;
 
 	/* Grab the module reference for this attribute if we have one */
@@ -137,30 +193,41 @@ static int open(struct inode * inode, struct file * file)
 		goto Error;
 
 	error = -ENOMEM;
-	file->private_data = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!file->private_data)
+	bb = kzalloc(sizeof(*bb), GFP_KERNEL);
+	if (!bb)
 		goto Error;
 
+	bb->buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!bb->buffer)
+		goto Error;
+
+	mutex_init(&bb->mutex);
+	file->private_data = bb;
+
 	error = 0;
     goto Done;
 
  Error:
+	kfree(bb);
 	module_put(attr->attr.owner);
  Done:
 	if (error)
-		kobject_put(kobj);
+		sysfs_put(sd);
 	return error;
 }
 
 static int release(struct inode * inode, struct file * file)
 {
-	struct kobject * kobj = to_kobj(file->f_path.dentry->d_parent);
+	struct sysfs_dirent * sd = file->f_path.dentry->d_parent->d_fsdata;
 	struct bin_attribute * attr = to_bin_attr(file->f_path.dentry);
-	u8 * buffer = file->private_data;
+	struct bin_buffer *bb = file->private_data;
 
-	kobject_put(kobj);
+	if (bb->mmapped)
+		sysfs_put_kobj(sd);
+	sysfs_put(sd);
 	module_put(attr->attr.owner);
-	kfree(buffer);
+	kfree(bb->buffer);
+	kfree(bb);
 	return 0;
 }
 
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 85a6686..e6e38f8 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -30,10 +30,60 @@ static struct dentry_operations sysfs_dentry_ops = {
 	.d_iput		= sysfs_d_iput,
 };
 
+void release_sysfs_dirent(struct sysfs_dirent * sd)
+{
+	struct sysfs_dirent *parent_sd;
+
+ repeat:
+	parent_sd = sd->s_parent;
+	if (sd->s_type & SYSFS_KOBJ_LINK) {
+		struct sysfs_symlink * sl = sd->s_element;
+		kfree(sl->link_name);
+		sysfs_put(sl->target_sd);
+	}
+	kfree(sd->s_element);
+	kfree(sd->s_iattr);
+	kmem_cache_free(sysfs_dir_cachep, sd);
+
+	sd = parent_sd;
+	if (sd && atomic_dec_and_test(&sd->s_count))
+		goto repeat;
+}
+
+struct kobject *sysfs_get_kobj(struct sysfs_dirent *sd)
+{
+	struct sysfs_dir *sdir = sd->s_element;
+
+	if (unlikely(!sd))
+		return NULL;
+
+	BUG_ON(!(sd->s_type & SYSFS_DIR));
+
+	down_read(&sdir->rwsem);
+	if (sdir->kobj)
+		return sdir->kobj;
+	up_read(&sdir->rwsem);
+
+	return NULL;
+}
+
+void sysfs_put_kobj(struct sysfs_dirent *sd)
+{
+	struct sysfs_dir *sdir = sd->s_element;
+
+	if (unlikely(!sd))
+		return;
+
+	BUG_ON(!(sd->s_type & SYSFS_DIR) || !sdir->kobj);
+
+	up_read(&sdir->rwsem);
+}
+
 /*
  * Allocates a new sysfs_dirent and links it to the parent sysfs_dirent
  */
-static struct sysfs_dirent * __sysfs_new_dirent(void * element)
+static struct sysfs_dirent * __sysfs_new_dirent(struct sysfs_dirent *parent_sd,
+						void * element)
 {
 	struct sysfs_dirent * sd;
 
@@ -46,6 +96,7 @@ static struct sysfs_dirent * __sysfs_new_dirent(void * element)
 	INIT_LIST_HEAD(&sd->s_children);
 	INIT_LIST_HEAD(&sd->s_sibling);
 	sd->s_element = element;
+	sd->s_parent = sysfs_get(parent_sd);
 
 	return sd;
 }
@@ -61,7 +112,7 @@ static struct sysfs_dirent * sysfs_new_dirent(struct sysfs_dirent *parent_sd,
 						void * element)
 {
 	struct sysfs_dirent *sd;
-	sd = __sysfs_new_dirent(element);
+	sd = __sysfs_new_dirent(parent_sd, element);
 	__sysfs_list_dirent(parent_sd, sd);
 	return sd;
 }
@@ -93,11 +144,12 @@ int sysfs_dirent_exist(struct sysfs_dirent *parent_sd,
 
 
 static struct sysfs_dirent *
-__sysfs_make_dirent(struct dentry *dentry, void *element, mode_t mode, int type)
+__sysfs_make_dirent(struct sysfs_dirent *parent_sd, struct dentry *dentry,
+		    void *element, mode_t mode, int type)
 {
 	struct sysfs_dirent * sd;
 
-	sd = __sysfs_new_dirent(element);
+	sd = __sysfs_new_dirent(parent_sd, element);
 	if (!sd)
 		goto out;
 
@@ -118,7 +170,7 @@ int sysfs_make_dirent(struct sysfs_dirent * parent_sd, struct dentry * dentry,
 {
 	struct sysfs_dirent *sd;
 
-	sd = __sysfs_make_dirent(dentry, element, mode, type);
+	sd = __sysfs_make_dirent(parent_sd, dentry, element, mode, type);
 	__sysfs_list_dirent(parent_sd, sd);
 
 	return sd ? 0 : -ENOMEM;
@@ -147,20 +199,42 @@ static int init_symlink(struct inode * inode)
 	return 0;
 }
 
-static int create_dir(struct kobject * k, struct dentry * p,
+static int create_dir(struct kobject * kobj, struct dentry * p,
 		      const char * n, struct dentry ** d)
 {
+	struct sysfs_ops *ops = NULL;
+	struct sysfs_dir *sdir;
 	int error;
 	umode_t mode = S_IFDIR| S_IRWXU | S_IRUGO | S_IXUGO;
 
+	/* if the kobject has no ktype, then we assume that it is a
+	 * subsystem itself, and use ops for it.
+	 */
+	if (kobj->kset && kobj->kset->ktype)
+		ops = kobj->kset->ktype->sysfs_ops;
+	else if (kobj->ktype)
+		ops = kobj->ktype->sysfs_ops;
+	else
+		ops = &subsys_sysfs_ops;
+
+	/* allocate and initialize sysfs_dir */
+	sdir = kzalloc(sizeof(*sdir), GFP_KERNEL);
+	if (!sdir)
+		return -ENOMEM;
+
+	init_rwsem(&sdir->rwsem);
+	sdir->kobj = kobj;
+	sdir->ops = ops;
+
+	/* allocate and link sysfs_dirent */
 	mutex_lock(&p->d_inode->i_mutex);
 	*d = lookup_one_len(n, p, strlen(n));
 	if (!IS_ERR(*d)) {
  		if (sysfs_dirent_exist(p->d_fsdata, n))
   			error = -EEXIST;
   		else
-			error = sysfs_make_dirent(p->d_fsdata, *d, k, mode,
-								SYSFS_DIR);
+			error = sysfs_make_dirent(p->d_fsdata, *d, sdir, mode,
+						  SYSFS_DIR);
 		if (!error) {
 			error = sysfs_create(*d, mode, init_dir);
 			if (!error) {
@@ -181,6 +255,9 @@ static int create_dir(struct kobject * k, struct dentry * p,
 	} else
 		error = PTR_ERR(*d);
 	mutex_unlock(&p->d_inode->i_mutex);
+
+	if (error)
+		kfree(sdir);
 	return error;
 }
 
@@ -304,11 +381,21 @@ const struct inode_operations sysfs_dir_inode_operations = {
 static void remove_dir(struct dentry * d)
 {
 	struct dentry * parent = dget(d->d_parent);
-	struct sysfs_dirent * sd;
+	struct sysfs_dirent * sd = d->d_fsdata;
+	struct sysfs_dir * sdir = sd->s_element;
+
+	down_write(&sdir->rwsem);
+	/* clear kobject->dentry only if @d is not a shadow */
+	if (sdir->kobj->dentry == d) {
+		spin_lock(&dcache_lock);
+		sdir->kobj->dentry = NULL;
+		spin_unlock(&dcache_lock);
+	}
+	sdir->kobj = NULL;
+	up_write(&sdir->rwsem);
 
 	mutex_lock(&parent->d_inode->i_mutex);
 	d_delete(d);
-	sd = d->d_fsdata;
  	list_del_init(&sd->s_sibling);
 	sysfs_put(sd);
 	if (d->d_inode)
@@ -367,7 +454,6 @@ static void __sysfs_remove_dir(struct dentry *dentry)
 void sysfs_remove_dir(struct kobject * kobj)
 {
 	__sysfs_remove_dir(kobj->dentry);
-	kobj->dentry = NULL;
 }
 
 int sysfs_rename_dir(struct kobject * kobj, struct dentry *new_parent,
@@ -636,13 +722,14 @@ int sysfs_make_shadowed_dir(struct kobject *kobj,
 
 struct dentry *sysfs_create_shadow_dir(struct kobject *kobj)
 {
-	struct sysfs_dirent *sd;
-	struct dentry *parent, *dir, *shadow;
-	struct inode *inode;
+	struct dentry *dir = kobj->dentry;
+	struct inode *inode = dir->d_inode;
+	struct dentry *parent = dir->d_parent;
+	struct sysfs_dirent *parent_sd = parent->d_fsdata;
+	struct sysfs_dir *parent_sdir = parent_sd->s_element;
+	struct dentry *shadow = NULL;
+	struct sysfs_dir *sdir = NULL;
 
-	dir = kobj->dentry;
-	inode = dir->d_inode;
-	parent = dir->d_parent;
 	shadow = ERR_PTR(-EINVAL);
 	if (!sysfs_is_shadowed_inode(inode))
 		goto out;
@@ -651,8 +738,16 @@ struct dentry *sysfs_create_shadow_dir(struct kobject *kobj)
 	if (!shadow)
 		goto nomem;
 
-	sd = __sysfs_make_dirent(shadow, kobj, inode->i_mode, SYSFS_DIR);
-	if (!sd)
+	sdir = kzalloc(sizeof(*sdir), GFP_KERNEL);
+	if (!sdir)
+		goto nomem;
+
+	init_rwsem(&sdir->rwsem);
+	sdir->kobj = kobj;
+	sdir->ops = parent_sdir->ops;
+
+	if (!__sysfs_make_dirent(parent_sd, shadow, sdir, inode->i_mode,
+				 SYSFS_DIR))
 		goto nomem;
 
 	d_instantiate(shadow, igrab(inode));
@@ -666,6 +761,7 @@ out:
 	return shadow;
 nomem:
 	dput(shadow);
+	kfree(sdir);
 	shadow = ERR_PTR(-ENOMEM);
 	goto out;
 }
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index fc46333..88a1d94 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -46,34 +46,19 @@ subsys_attr_store(struct kobject * kobj, struct attribute * attr,
 	return ret;
 }
 
-static struct sysfs_ops subsys_sysfs_ops = {
+struct sysfs_ops subsys_sysfs_ops = {
 	.show	= subsys_attr_show,
 	.store	= subsys_attr_store,
 };
 
-/**
- *	add_to_collection - add buffer to a collection
- *	@buffer:	buffer to be added
- *	@node:		inode of set to add to
- */
-
-static inline void
-add_to_collection(struct sysfs_buffer *buffer, struct inode *node)
-{
-	struct sysfs_buffer_collection *set = node->i_private;
-
-	mutex_lock(&node->i_mutex);
-	list_add(&buffer->associates, &set->associates);
-	mutex_unlock(&node->i_mutex);
-}
-
-static inline void
-remove_from_collection(struct sysfs_buffer *buffer, struct inode *node)
-{
-	mutex_lock(&node->i_mutex);
-	list_del(&buffer->associates);
-	mutex_unlock(&node->i_mutex);
-}
+struct sysfs_buffer {
+	size_t				count;
+	loff_t				pos;
+	char				* page;
+	struct semaphore		sem;
+	int				needs_read_fill;
+	int				event;
+};
 
 /**
  *	fill_read_buffer - allocate and fill buffer from object.
@@ -88,10 +73,11 @@ remove_from_collection(struct sysfs_buffer *buffer, struct inode *node)
  */
 static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer)
 {
-	struct sysfs_dirent * sd = dentry->d_fsdata;
+	struct sysfs_dirent * attr_sd = dentry->d_fsdata;
+	struct sysfs_dirent * sd = dentry->d_parent->d_fsdata;
+	struct sysfs_dir * sdir = sd->s_element;
 	struct attribute * attr = to_attr(dentry);
-	struct kobject * kobj = to_kobj(dentry->d_parent);
-	struct sysfs_ops * ops = buffer->ops;
+	struct kobject * kobj;
 	int ret = 0;
 	ssize_t count;
 
@@ -100,8 +86,15 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 	if (!buffer->page)
 		return -ENOMEM;
 
-	buffer->event = atomic_read(&sd->s_event);
-	count = ops->show(kobj,attr,buffer->page);
+	kobj = sysfs_get_kobj(sd);
+	if (!kobj)
+		return -ENODEV;
+
+	buffer->event = atomic_read(&attr_sd->s_event);
+	count = sdir->ops->show(kobj,attr,buffer->page);
+
+	sysfs_put_kobj(sd);
+
 	BUG_ON(count > (ssize_t)PAGE_SIZE);
 	if (count >= 0) {
 		buffer->needs_read_fill = 0;
@@ -169,10 +162,7 @@ sysfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 	down(&buffer->sem);
 	if (buffer->needs_read_fill) {
-		if (buffer->orphaned)
-			retval = -ENODEV;
-		else
-			retval = fill_read_buffer(file->f_path.dentry,buffer);
+		retval = fill_read_buffer(file->f_path.dentry,buffer);
 		if (retval)
 			goto out;
 	}
@@ -229,11 +219,21 @@ fill_write_buffer(struct sysfs_buffer * buffer, const char __user * buf, size_t
 static int 
 flush_write_buffer(struct dentry * dentry, struct sysfs_buffer * buffer, size_t count)
 {
+	struct sysfs_dirent * sd = dentry->d_parent->d_fsdata;
+	struct sysfs_dir * sdir = sd->s_element;
 	struct attribute * attr = to_attr(dentry);
-	struct kobject * kobj = to_kobj(dentry->d_parent);
-	struct sysfs_ops * ops = buffer->ops;
+	struct kobject * kobj;
+	int rc;
+
+	kobj = sysfs_get_kobj(sd);
+	if (!kobj)
+		return -ENODEV;
+
+	rc = sdir->ops->store(kobj,attr,buffer->page,count);
+
+	sysfs_put_kobj(sd);
 
-	return ops->store(kobj,attr,buffer->page,count);
+	return rc;
 }
 
 
@@ -261,65 +261,41 @@ sysfs_write_file(struct file *file, const char __user *buf, size_t count, loff_t
 	ssize_t len;
 
 	down(&buffer->sem);
-	if (buffer->orphaned) {
-		len = -ENODEV;
-		goto out;
-	}
+
 	len = fill_write_buffer(buffer, buf, count);
 	if (len > 0)
 		len = flush_write_buffer(file->f_path.dentry, buffer, len);
 	if (len > 0)
 		*ppos += len;
-out:
+
 	up(&buffer->sem);
 	return len;
 }
 
 static int sysfs_open_file(struct inode *inode, struct file *file)
 {
-	struct kobject *kobj = sysfs_get_kobject(file->f_path.dentry->d_parent);
+	struct sysfs_dirent *sd = sysfs_get(file->f_path.dentry->d_parent->d_fsdata);
 	struct attribute * attr = to_attr(file->f_path.dentry);
-	struct sysfs_buffer_collection *set;
+	struct sysfs_dir *sdir;
 	struct sysfs_buffer * buffer;
-	struct sysfs_ops * ops = NULL;
 	int error = 0;
 
-	if (!kobj || !attr)
+	if (!attr)
 		goto Einval;
 
-	/* Grab the module reference for this attribute if we have one */
-	if (!try_module_get(attr->owner)) {
-		error = -ENODEV;
-		goto Done;
-	}
-
-	/* if the kobject has no ktype, then we assume that it is a subsystem
-	 * itself, and use ops for it.
-	 */
-	if (kobj->kset && kobj->kset->ktype)
-		ops = kobj->kset->ktype->sysfs_ops;
-	else if (kobj->ktype)
-		ops = kobj->ktype->sysfs_ops;
-	else
-		ops = &subsys_sysfs_ops;
+	sdir = sd->s_element;
 
 	/* No sysfs operations, either from having no subsystem,
 	 * or the subsystem have no operations.
 	 */
-	if (!ops)
-		goto Eaccess;
-
-	/* make sure we have a collection to add our buffers to */
-	mutex_lock(&inode->i_mutex);
-	if (!(set = inode->i_private)) {
-		if (!(set = inode->i_private = kmalloc(sizeof(struct sysfs_buffer_collection), GFP_KERNEL))) {
-			error = -ENOMEM;
-			goto Done;
-		} else {
-			INIT_LIST_HEAD(&set->associates);
-		}
+	if (!sdir->ops)
+		return -EINVAL;
+
+	/* Grab the module reference for this attribute if we have one */
+	if (!try_module_get(attr->owner)) {
+		error = -ENODEV;
+		goto Done;
 	}
-	mutex_unlock(&inode->i_mutex);
 
 	/* File needs write support.
 	 * The inode's perms must say it's ok, 
@@ -327,7 +303,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	 */
 	if (file->f_mode & FMODE_WRITE) {
 
-		if (!(inode->i_mode & S_IWUGO) || !ops->store)
+		if (!(inode->i_mode & S_IWUGO) || !sdir->ops->store)
 			goto Eaccess;
 
 	}
@@ -337,7 +313,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	 * must be a show method for it.
 	 */
 	if (file->f_mode & FMODE_READ) {
-		if (!(inode->i_mode & S_IRUGO) || !ops->show)
+		if (!(inode->i_mode & S_IRUGO) || !sdir->ops->show)
 			goto Eaccess;
 	}
 
@@ -346,11 +322,8 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	 */
 	buffer = kzalloc(sizeof(struct sysfs_buffer), GFP_KERNEL);
 	if (buffer) {
-		INIT_LIST_HEAD(&buffer->associates);
 		init_MUTEX(&buffer->sem);
 		buffer->needs_read_fill = 1;
-		buffer->ops = ops;
-		add_to_collection(buffer, inode);
 		file->private_data = buffer;
 	} else
 		error = -ENOMEM;
@@ -364,20 +337,18 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	module_put(attr->owner);
  Done:
 	if (error)
-		kobject_put(kobj);
+		sysfs_put(sd);
 	return error;
 }
 
 static int sysfs_release(struct inode * inode, struct file * filp)
 {
-	struct kobject * kobj = to_kobj(filp->f_path.dentry->d_parent);
+	struct sysfs_dirent * sd = filp->f_path.dentry->d_parent->d_fsdata;
 	struct attribute * attr = to_attr(filp->f_path.dentry);
 	struct module * owner = attr->owner;
 	struct sysfs_buffer * buffer = filp->private_data;
 
-	if (buffer)
-		remove_from_collection(buffer, inode);
-	kobject_put(kobj);
+	sysfs_put(sd);
 	/* After this point, attr should not be accessed. */
 	module_put(owner);
 
@@ -406,18 +377,25 @@ static int sysfs_release(struct inode * inode, struct file * filp)
 static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 {
 	struct sysfs_buffer * buffer = filp->private_data;
-	struct kobject * kobj = to_kobj(filp->f_path.dentry->d_parent);
 	struct sysfs_dirent * sd = filp->f_path.dentry->d_fsdata;
-	int res = 0;
+	struct kobject *kobj;
+
+	kobj = sysfs_get_kobj(sd);
+	if (!kobj)
+		goto trigger;
 
 	poll_wait(filp, &kobj->poll, wait);
 
-	if (buffer->event != atomic_read(&sd->s_event)) {
-		res = POLLERR|POLLPRI;
-		buffer->needs_read_fill = 1;
-	}
+	sysfs_put_kobj(sd);
 
-	return res;
+	if (buffer->event != atomic_read(&sd->s_event))
+		goto trigger;
+
+	return 0;
+
+ trigger:
+	buffer->needs_read_fill = 1;
+	return POLLERR|POLLPRI;
 }
 
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 4de5c6b..441a757 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -220,24 +220,6 @@ const unsigned char * sysfs_get_name(struct sysfs_dirent *sd)
 	return NULL;
 }
 
-static inline void orphan_all_buffers(struct inode *node)
-{
-	struct sysfs_buffer_collection *set;
-	struct sysfs_buffer *buf;
-
-	mutex_lock_nested(&node->i_mutex, I_MUTEX_CHILD);
-	set = node->i_private;
-	if (set) {
-		list_for_each_entry(buf, &set->associates, associates) {
-			down(&buf->sem);
-			buf->orphaned = 1;
-			up(&buf->sem);
-		}
-	}
-	mutex_unlock(&node->i_mutex);
-}
-
-
 /*
  * Unhashes the dentry corresponding to given sysfs_dirent
  * Called with parent inode's i_mutex held.
@@ -245,23 +227,16 @@ static inline void orphan_all_buffers(struct inode *node)
 void sysfs_drop_dentry(struct sysfs_dirent * sd, struct dentry * parent)
 {
 	struct dentry * dentry = sd->s_dentry;
-	struct inode *inode;
 
 	if (dentry) {
 		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry) && dentry->d_inode)) {
-			inode = dentry->d_inode;
-			spin_lock(&inode->i_lock);
-			__iget(inode);
-			spin_unlock(&inode->i_lock);
 			dget_locked(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 			simple_unlink(parent->d_inode, dentry);
-			orphan_all_buffers(inode);
-			iput(inode);
 		} else {
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 23a48a3..5541041 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -19,15 +19,13 @@ struct vfsmount *sysfs_mount;
 struct super_block * sysfs_sb = NULL;
 struct kmem_cache *sysfs_dir_cachep;
 
-static void sysfs_clear_inode(struct inode *inode);
-
 static const struct super_operations sysfs_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= sysfs_delete_inode,
-	.clear_inode	= sysfs_clear_inode,
 };
 
 static struct sysfs_dirent sysfs_root = {
+	.s_count	= ATOMIC_INIT(1),
 	.s_sibling	= LIST_HEAD_INIT(sysfs_root.s_sibling),
 	.s_children	= LIST_HEAD_INIT(sysfs_root.s_children),
 	.s_element	= NULL,
@@ -35,11 +33,6 @@ static struct sysfs_dirent sysfs_root = {
 	.s_iattr	= NULL,
 };
 
-static void sysfs_clear_inode(struct inode *inode)
-{
-	kfree(inode->i_private);
-}
-
 static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *inode;
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 7b9c5bf..ddc067d 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -11,43 +11,65 @@
 
 #include "sysfs.h"
 
-static int object_depth(struct kobject * kobj)
+static int object_depth(struct sysfs_dirent * sd)
 {
-	struct kobject * p = kobj;
+	struct sysfs_dirent * p;
 	int depth = 0;
-	do { depth++; } while ((p = p->parent));
+
+	for (p = sd; p->s_parent; p = p->s_parent)
+		depth++;
+
 	return depth;
 }
 
-static int object_path_length(struct kobject * kobj)
+static int object_path_length(struct sysfs_dirent * sd)
 {
-	struct kobject * p = kobj;
+	struct sysfs_dirent * p;
 	int length = 1;
-	do {
-		length += strlen(kobject_name(p)) + 1;
-		p = p->parent;
-	} while (p);
+
+	for (p = sd; p->s_parent; p = p->s_parent) {
+		struct kobject *kobj;
+
+		kobj = sysfs_get_kobj(p);
+		if (!kobj)
+			return -ENOENT;
+
+		length += strlen(kobject_name(kobj)) + 1;
+
+		sysfs_put_kobj(p);
+	}
+
 	return length;
 }
 
-static void fill_object_path(struct kobject * kobj, char * buffer, int length)
+static int fill_object_path(struct sysfs_dirent * sd, char * buffer, int length)
 {
-	struct kobject * p;
+	struct sysfs_dirent * p;
 
 	--length;
-	for (p = kobj; p; p = p->parent) {
-		int cur = strlen(kobject_name(p));
+	for (p = sd; p->s_parent; p = p->s_parent) {
+		struct kobject *kobj = sysfs_get_kobj(p);
+		int cur;
+
+		if (!kobj)
+			return -ENOENT;
+
+		cur = strlen(kobject_name(kobj));
 
 		/* back up enough to print this bus id with '/' */
 		length -= cur;
-		strncpy(buffer + length,kobject_name(p),cur);
+		strncpy(buffer + length, kobject_name(kobj), cur);
 		*(buffer + --length) = '/';
+
+		sysfs_put_kobj(p);
 	}
+
+	return 0;
 }
 
-static int sysfs_add_link(struct dentry * parent, const char * name, struct kobject * target)
+static int sysfs_add_link(struct sysfs_dirent * parent_sd, const char * name,
+			  struct sysfs_dirent * target_sd)
 {
-	struct sysfs_dirent * parent_sd = parent->d_fsdata;
 	struct sysfs_symlink * sl;
 	int error = 0;
 
@@ -61,14 +83,13 @@ static int sysfs_add_link(struct dentry * parent, const char * name, struct kobj
 		goto exit2;
 
 	strcpy(sl->link_name, name);
-	sl->target_kobj = kobject_get(target);
+	sl->target_sd = sysfs_get(target_sd);
 
 	error = sysfs_make_dirent(parent_sd, NULL, sl, S_IFLNK|S_IRWXUGO,
 				SYSFS_KOBJ_LINK);
 	if (!error)
 		return 0;
 
-	kobject_put(target);
 	kfree(sl->link_name);
 exit2:
 	kfree(sl);
@@ -85,6 +106,8 @@ exit1:
 int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char * name)
 {
 	struct dentry *dentry = NULL;
+	struct sysfs_dirent *parent_sd = NULL;
+	struct sysfs_dirent *target_sd = NULL;
 	int error = -EEXIST;
 
 	BUG_ON(!name);
@@ -97,11 +120,26 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 
 	if (!dentry)
 		return -EFAULT;
+	parent_sd = dentry->d_fsdata;
+
+	/* target->dentry can go away beneath us but is protected with
+	 * dcache_lock.  Fetch target_sd from it.
+	 */
+	spin_lock(&dcache_lock);
+	if (target->dentry)
+		target_sd = sysfs_get(target->dentry->d_fsdata);
+	spin_unlock(&dcache_lock);
+
+	if (!target_sd)
+		return -ENOENT;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
 	if (!sysfs_dirent_exist(dentry->d_fsdata, name))
-		error = sysfs_add_link(dentry, name, target);
+		error = sysfs_add_link(parent_sd, name, target_sd);
 	mutex_unlock(&dentry->d_inode->i_mutex);
+
+	sysfs_put(target_sd);
+
 	return error;
 }
 
@@ -117,14 +155,14 @@ void sysfs_remove_link(struct kobject * kobj, const char * name)
 	sysfs_hash_and_remove(kobj->dentry,name);
 }
 
-static int sysfs_get_target_path(struct kobject * kobj, struct kobject * target,
-				 char *path)
+static int sysfs_get_target_path(struct sysfs_dirent * parent_sd,
+				 struct sysfs_dirent * target_sd, char *path)
 {
 	char * s;
-	int depth, size;
+	int depth, size, rc;
 
-	depth = object_depth(kobj);
-	size = object_path_length(target) + depth * 3 - 1;
+	depth = object_depth(parent_sd);
+	size = object_path_length(target_sd) + depth * 3 - 1;
 	if (size > PATH_MAX)
 		return -ENAMETOOLONG;
 
@@ -133,35 +171,24 @@ static int sysfs_get_target_path(struct kobject * kobj, struct kobject * target,
 	for (s = path; depth--; s += 3)
 		strcpy(s,"../");
 
-	fill_object_path(target, path, size);
-	pr_debug("%s: path = '%s'\n", __FUNCTION__, path);
+	rc = fill_object_path(target_sd, path, size);
+	pr_debug("%s: rc = %d path = '%s'\n", __FUNCTION__, rc, path);
 
-	return 0;
+	return rc;
 }
 
 static int sysfs_getlink(struct dentry *dentry, char * path)
 {
-	struct kobject *kobj, *target_kobj;
-	int error = 0;
-
-	kobj = sysfs_get_kobject(dentry->d_parent);
-	if (!kobj)
-		return -EINVAL;
-
-	target_kobj = sysfs_get_kobject(dentry);
-	if (!target_kobj) {
-		kobject_put(kobj);
-		return -EINVAL;
-	}
+	struct sysfs_dirent *parent_sd = dentry->d_parent->d_fsdata;
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct sysfs_symlink *sl = sd->s_element;
+	int error;
 
 	down_read(&sysfs_rename_sem);
-	error = sysfs_get_target_path(kobj, target_kobj, path);
+	error = sysfs_get_target_path(parent_sd, sl->target_sd, path);
 	up_read(&sysfs_rename_sem);
-	
-	kobject_put(kobj);
-	kobject_put(target_kobj);
-	return error;
 
+	return error;
 }
 
 static void *sysfs_follow_link(struct dentry *dentry, struct nameidata *nd)
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index a77c57e..912a6e9 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -1,5 +1,6 @@
 struct sysfs_dirent {
 	atomic_t		s_count;
+	struct sysfs_dirent	* s_parent;
 	struct list_head	s_sibling;
 	struct list_head	s_children;
 	void 			* s_element;
@@ -10,13 +11,28 @@ struct sysfs_dirent {
 	atomic_t		s_event;
 };
 
+struct sysfs_dir {
+	struct rw_semaphore	rwsem;	/* protects kobj and kobj->dentry */
+	struct kobject		* kobj;	/* associated kobj */
+	struct sysfs_ops	* ops;
+};
+
+struct sysfs_symlink {
+	char			* link_name;
+	struct sysfs_dirent	* target_sd;
+};
+
 extern struct vfsmount * sysfs_mount;
 extern struct kmem_cache *sysfs_dir_cachep;
+extern struct sysfs_ops subsys_sysfs_ops;
 
 extern void sysfs_delete_inode(struct inode *inode);
 extern struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent *);
 extern int sysfs_create(struct dentry *, int mode, int (*init)(struct inode *));
 
+extern void release_sysfs_dirent(struct sysfs_dirent * sd);
+extern struct kobject *sysfs_get_kobj(struct sysfs_dirent *sd);
+extern void sysfs_put_kobj(struct sysfs_dirent *sd);
 extern int sysfs_dirent_exist(struct sysfs_dirent *, const unsigned char *);
 extern int sysfs_make_dirent(struct sysfs_dirent *, struct dentry *, void *,
 				umode_t, int);
@@ -40,33 +56,6 @@ extern const struct file_operations bin_fops;
 extern const struct inode_operations sysfs_dir_inode_operations;
 extern const struct inode_operations sysfs_symlink_inode_operations;
 
-struct sysfs_symlink {
-	char * link_name;
-	struct kobject * target_kobj;
-};
-
-struct sysfs_buffer {
-	struct list_head		associates;
-	size_t				count;
-	loff_t				pos;
-	char				* page;
-	struct sysfs_ops		* ops;
-	struct semaphore		sem;
-	int				orphaned;
-	int				needs_read_fill;
-	int				event;
-};
-
-struct sysfs_buffer_collection {
-	struct list_head	associates;
-};
-
-static inline struct kobject * to_kobj(struct dentry * dentry)
-{
-	struct sysfs_dirent * sd = dentry->d_fsdata;
-	return ((struct kobject *) sd->s_element);
-}
-
 static inline struct attribute * to_attr(struct dentry * dentry)
 {
 	struct sysfs_dirent * sd = dentry->d_fsdata;
@@ -79,36 +68,6 @@ static inline struct bin_attribute * to_bin_attr(struct dentry * dentry)
 	return ((struct bin_attribute *) sd->s_element);
 }
 
-static inline struct kobject *sysfs_get_kobject(struct dentry *dentry)
-{
-	struct kobject * kobj = NULL;
-
-	spin_lock(&dcache_lock);
-	if (!d_unhashed(dentry)) {
-		struct sysfs_dirent * sd = dentry->d_fsdata;
-		if (sd->s_type & SYSFS_KOBJ_LINK) {
-			struct sysfs_symlink * sl = sd->s_element;
-			kobj = kobject_get(sl->target_kobj);
-		} else
-			kobj = kobject_get(sd->s_element);
-	}
-	spin_unlock(&dcache_lock);
-
-	return kobj;
-}
-
-static inline void release_sysfs_dirent(struct sysfs_dirent * sd)
-{
-	if (sd->s_type & SYSFS_KOBJ_LINK) {
-		struct sysfs_symlink * sl = sd->s_element;
-		kfree(sl->link_name);
-		kobject_put(sl->target_kobj);
-		kfree(sl);
-	}
-	kfree(sd->s_iattr);
-	kmem_cache_free(sysfs_dir_cachep, sd);
-}
-
 static inline struct sysfs_dirent * sysfs_get(struct sysfs_dirent * sd)
 {
 	if (sd) {
@@ -120,7 +79,7 @@ static inline struct sysfs_dirent * sysfs_get(struct sysfs_dirent * sd)
 
 static inline void sysfs_put(struct sysfs_dirent * sd)
 {
-	if (atomic_dec_and_test(&sd->s_count))
+	if (sd && atomic_dec_and_test(&sd->s_count))
 		release_sysfs_dirent(sd);
 }
 
