From: Andrew Morton <akpm@osdl.org>
Subject: SCSI kobject unregistration ordering problem
Date: Mon, 13 Oct 2003 15:12:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031013151254.521d882e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:4816 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262015AbTJMWMl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Oct 2003 18:12:41 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Patrick Mochel <mochel@osdl.org>, Greg KH <greg@kroah.com>, Andrey Borzenkov <arvidjaar@mail.ru>


Guys,

I have the below patch queued, but Greg and Pat don't like it because

> > For one, the fact a parent is unregistered before its children violates
> > the intended semantics of the interface. #$^!@#$ SCSI. They know this, and
> > they should not be doing it.
>
> Exactly, that's why I do not want this patch applied.  The SCSI people
> have said they would fix this problem, as they should.  Let's not paper
> over the issue with this kobject patch.

So it looks like SCSI needs fixing.  Could someone please take care of this?
Thanks.




From: Andrey Borzenkov <arvidjaar@mail.ru>

It is possible that parent is removed before child when child is in use. 
Trivial example is mounted USB storage when you unplug it. The kobject for 
USB device is removed but subordinate SCSI device remains. Then kernel oopses 
on attempt to release child e.g. umount removed USB storage. This patch fixes 
two problems:

- kset_hotplug.  It oopses in get_kobj_path_length because child->parent
  points to nowhere - even if parent has not yet been overwritten, its name
  is already freed.

  The patch moves kobject_put for parent from unlink() into
  kobject_cleanup for child making sure reference to parents exists for as
  long as child is there and may use it.

- after this oops has been fixed I got next one now in sysfs.  The
  problem is sysfs_remove_dir would unlink all children including
  directories for subordinate kobjects.  Resulting in dget/dput mismatch. 
  I usually got oops due to the fact that d_delete in remove_dir would free
  inode and then simple_rmdir would try to access it.

  The patch avoids calling extra d_delete/unlink on already-deleted
  dentry.  I hate this patch but anything better apparently requires
  complete redesign of sysfs implementation.  Unlinking busy directory is
  otherwise impossible and I am afraid it will show itself somewhere else.



 25-akpm/fs/sysfs/dir.c |   12 ++++++++++--
 25-akpm/lib/kobject.c  |    4 ++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff -puN fs/sysfs/dir.c~kobject-oops-fixes fs/sysfs/dir.c
--- 25/fs/sysfs/dir.c~kobject-oops-fixes	Thu Oct  9 01:46:51 2003
+++ 25-akpm/fs/sysfs/dir.c	Thu Oct  9 01:46:51 2003
@@ -82,8 +82,16 @@ static void remove_dir(struct dentry * d
 {
 	struct dentry * parent = dget(d->d_parent);
 	down(&parent->d_inode->i_sem);
-	d_delete(d);
-	simple_rmdir(parent->d_inode,d);
+	/*
+	 * It is possible that parent has already been removed, in which
+	 * case directory is already unhashed and dput.
+	 * Note that this won't update parent->d_inode->i_nlink; OTOH
+	 * parent should already be dead
+	 */
+	if (!d_unhashed(d)) {
+		d_delete(d);
+		simple_rmdir(parent->d_inode,d);
+	}
 
 	pr_debug(" o %s removing done (%d)\n",d->d_name.name,
 		 atomic_read(&d->d_count));
diff -puN lib/kobject.c~kobject-oops-fixes lib/kobject.c
--- 25/lib/kobject.c~kobject-oops-fixes	Thu Oct  9 01:46:51 2003
+++ 25-akpm/lib/kobject.c	Thu Oct  9 01:46:51 2003
@@ -236,8 +236,6 @@ static void unlink(struct kobject * kobj
 		list_del_init(&kobj->entry);
 		up_write(&kobj->kset->subsys->rwsem);
 	}
-	if (kobj->parent) 
-		kobject_put(kobj->parent);
 	kobject_put(kobj);
 }
 
@@ -457,6 +455,8 @@ void kobject_cleanup(struct kobject * ko
 	if (kobj->k_name != kobj->name)
 		kfree(kobj->k_name);
 	kobj->k_name = NULL;
+	if (kobj->parent)
+		kobject_put(kobj->parent);
 	if (t && t->release)
 		t->release(kobj);
 	if (s)

_

