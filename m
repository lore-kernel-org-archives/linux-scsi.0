From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] sysfs: add filter function to groups
Date: Mon, 29 Oct 2007 10:16:59 -0500
Message-ID: <1193671019.3383.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52093 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752300AbXJ2PRO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 11:17:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

In the SCSI transport classes (and soon to be in the AEN event
subsystem) we have a lot of need for a grouping that doesn't include all
files in the group.  We basically want to show capability by which file
is present.  A classic example of this is the SPI transport class
connected to the 53c700 card.  It's incapable of doing all of the modern
LVD functions, so we don't show any of those capabilities in its sysfs
directory.  However, we have a lot of horrible logic to generate
separate per host groupings of attributes for this.  We would be able to
use the standard sysfs group attributes *if* there were a way of
filtering them so that certain attributes didn't appear.

This patch is a first pass at adding a filter function to the group
attributes, just to see how the idea flies.  If everyone's OK with this,
I think the next thing that we might do is add bitmap functions (so
every bit in the bitmap has a name, but also might not appear) to
groups.

The kzalloc in kernel/params.c is to stop the system crashing on boot
with a bogus filter function pointer.

Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

----

There's one final thing; if you're OK with this, can you ack it and let
me take it through the SCSI tree?  we're building functionality that
will depend on this.

Thanks,

James

Index: BUILD-2.6/fs/sysfs/group.c
===================================================================
--- BUILD-2.6.orig/fs/sysfs/group.c	2007-10-28 17:27:04.000000000 -0500
+++ BUILD-2.6/fs/sysfs/group.c	2007-10-29 00:55:49.000000000 -0500
@@ -16,25 +16,31 @@
 #include "sysfs.h"
 
 
-static void remove_files(struct sysfs_dirent *dir_sd,
+static void remove_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 			 const struct attribute_group *grp)
 {
 	struct attribute *const* attr;
+	int i;
 
-	for (attr = grp->attrs; *attr; attr++)
-		sysfs_hash_and_remove(dir_sd, (*attr)->name);
+	for (i = 0, attr = grp->attrs; *attr; i++, attr++)
+		if (grp->filter_show &&
+		    grp->filter_show(kobj, i))
+			sysfs_hash_and_remove(dir_sd, (*attr)->name);
 }
 
-static int create_files(struct sysfs_dirent *dir_sd,
+static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 			const struct attribute_group *grp)
 {
 	struct attribute *const* attr;
-	int error = 0;
+	int error = 0, i;
 
-	for (attr = grp->attrs; *attr && !error; attr++)
-		error = sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
+	for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++)
+		if (grp->filter_show &&
+		    grp->filter_show(kobj, i))
+			error |=
+				sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
 	if (error)
-		remove_files(dir_sd, grp);
+		remove_files(dir_sd, kobj, grp);
 	return error;
 }
 
@@ -54,7 +60,7 @@ int sysfs_create_group(struct kobject * 
 	} else
 		sd = kobj->sd;
 	sysfs_get(sd);
-	error = create_files(sd, grp);
+	error = create_files(sd, kobj, grp);
 	if (error) {
 		if (grp->name)
 			sysfs_remove_subdir(sd);
@@ -75,7 +81,7 @@ void sysfs_remove_group(struct kobject *
 	} else
 		sd = sysfs_get(dir_sd);
 
-	remove_files(sd, grp);
+	remove_files(sd, kobj, grp);
 	if (grp->name)
 		sysfs_remove_subdir(sd);
 
Index: BUILD-2.6/include/linux/sysfs.h
===================================================================
--- BUILD-2.6.orig/include/linux/sysfs.h	2007-10-28 17:20:06.000000000 -0500
+++ BUILD-2.6/include/linux/sysfs.h	2007-10-29 00:37:18.000000000 -0500
@@ -32,6 +32,7 @@ struct attribute {
 
 struct attribute_group {
 	const char		*name;
+	int			(*filter_show)(struct kobject *, int);
 	struct attribute	**attrs;
 };
 
Index: BUILD-2.6/kernel/params.c
===================================================================
--- BUILD-2.6.orig/kernel/params.c	2007-10-29 01:18:43.000000000 -0500
+++ BUILD-2.6/kernel/params.c	2007-10-29 01:18:49.000000000 -0500
@@ -472,7 +472,7 @@ param_sysfs_setup(struct module_kobject 
 			sizeof(mp->grp.attrs[0]));
 	size[1] = (valid_attrs + 1) * sizeof(mp->grp.attrs[0]);
 
-	mp = kmalloc(size[0] + size[1], GFP_KERNEL);
+	mp = kzalloc(size[0] + size[1], GFP_KERNEL);
 	if (!mp)
 		return ERR_PTR(-ENOMEM);
 


