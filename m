From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] sysfs: add filter function to groups
Date: Wed, 31 Oct 2007 09:38:04 -0500
Message-ID: <1193841484.3411.8.camel@localhost.localdomain>
References: <1193671019.3383.13.camel@localhost.localdomain>
	 <1193676852.2655.21.camel@lov.site>
	 <1193677071.3383.56.camel@localhost.localdomain>
	 <47261F50.3050901@s5r6.in-berlin.de>
	 <1193768743.3321.91.camel@localhost.localdomain>
	 <20071031035506.GH14910@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:40802 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756551AbXJaOiH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 10:38:07 -0400
In-Reply-To: <20071031035506.GH14910@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Kay Sievers <kay.sievers@vrfy.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, 2007-10-30 at 20:55 -0700, Greg KH wrote:
> OSame problem here, if grp->is_visible is not set, sysfs_add_file() would
> never be called, right?
> 
> Other than the logic problem (I think), I have no issue with this idea
> at all.  Care to redo this so it works?

It's a fair cop govenor ... new patch attached.

James

---
Index: BUILD-2.6/fs/sysfs/group.c
===================================================================
--- BUILD-2.6.orig/fs/sysfs/group.c	2007-10-28 17:27:04.000000000 -0500
+++ BUILD-2.6/fs/sysfs/group.c	2007-10-31 09:29:14.000000000 -0500
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
+		if (!grp->is_visible ||
+		    grp->is_visible(kobj, *attr, i))
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
+		if (!grp->is_visible ||
+		    grp->is_visible(kobj, *attr, i))
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
+++ BUILD-2.6/include/linux/sysfs.h	2007-10-30 13:24:06.000000000 -0500
@@ -32,6 +32,8 @@ struct attribute {
 
 struct attribute_group {
 	const char		*name;
+	int			(*is_visible)(struct kobject *,
+					      struct attribute *, int);
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
 


