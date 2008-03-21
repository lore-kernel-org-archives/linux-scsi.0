From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/2] sysfs: allow the group is_visible() method to return a
	mode and add an update API
Date: Fri, 21 Mar 2008 16:27:12 -0500
Message-ID: <1206134832.2961.64.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50204 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754859AbYCUV1R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 17:27:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

We have a problem in scsi_transport_spi in that we need to customise
not only the visibility of the attributes, but also their mode.  Fix
this by making the is_visible() callback return a mode, with 0
indicating is not visible.

Also add a sysfs_update_group() API to allow us to change either the
visibility or mode of the files at any time on the fly.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---

Greg, can I take this through SCSI, please ... assuming it's OK?  We
need this to fix up the SPI transport class.

Thanks,

James


 fs/sysfs/file.c       |   14 ++++++++++----
 fs/sysfs/group.c      |   47 +++++++++++++++++++++++++++++++++++------------
 fs/sysfs/sysfs.h      |    2 ++
 include/linux/sysfs.h |    4 +++-
 4 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 6f5954a..8f7ee10 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -490,11 +490,10 @@ const struct file_operations sysfs_file_operations = {
 	.poll		= sysfs_poll,
 };
 
-
-int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
-		   int type)
+int sysfs_add_file_mode(struct sysfs_dirent *dir_sd,
+			const struct attribute *attr, int type, mode_t amode)
 {
-	umode_t mode = (attr->mode & S_IALLUGO) | S_IFREG;
+	umode_t mode = (amode & S_IALLUGO) | S_IFREG;
 	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
 	int rc;
@@ -515,6 +514,13 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 }
 
 
+int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
+		   int type)
+{
+	return sysfs_add_file_mode(dir_sd, attr, type, attr->mode);
+}
+
+
 /**
  *	sysfs_create_file - create an attribute file for an object.
  *	@kobj:	object we're creating for. 
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 4779049..6c1232a 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -23,30 +23,38 @@ static void remove_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 	int i;
 
 	for (i = 0, attr = grp->attrs; *attr; i++, attr++)
-		if (!grp->is_visible ||
-		    grp->is_visible(kobj, *attr, i))
-			sysfs_hash_and_remove(dir_sd, (*attr)->name);
+		sysfs_hash_and_remove(dir_sd, (*attr)->name);
 }
 
 static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
-			const struct attribute_group *grp)
+			const struct attribute_group *grp, int update)
 {
 	struct attribute *const* attr;
 	int error = 0, i;
 
-	for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++)
-		if (!grp->is_visible ||
-		    grp->is_visible(kobj, *attr, i))
-			error |=
-				sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
+	for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++) {
+		mode_t mode = 0;
+
+		if (update)
+			sysfs_hash_and_remove(dir_sd, (*attr)->name);
+		if (grp->is_visible) {
+			mode = grp->is_visible(kobj, *attr, i);
+			if (!mode)
+				continue;
+		}
+		error = sysfs_add_file_mode(dir_sd, *attr, SYSFS_KOBJ_ATTR,
+					    (*attr)->mode | mode);
+		if (unlikely(error))
+			break;
+	}
 	if (error)
 		remove_files(dir_sd, kobj, grp);
 	return error;
 }
 
 
-int sysfs_create_group(struct kobject * kobj, 
-		       const struct attribute_group * grp)
+static int internal_create_group(struct kobject * kobj, int update,
+				 const struct attribute_group * grp)
 {
 	struct sysfs_dirent *sd;
 	int error;
@@ -60,7 +68,7 @@ int sysfs_create_group(struct kobject * kobj,
 	} else
 		sd = kobj->sd;
 	sysfs_get(sd);
-	error = create_files(sd, kobj, grp);
+	error = create_files(sd, kobj, grp, update);
 	if (error) {
 		if (grp->name)
 			sysfs_remove_subdir(sd);
@@ -69,6 +77,20 @@ int sysfs_create_group(struct kobject * kobj,
 	return error;
 }
 
+int sysfs_create_group(struct kobject * kobj,
+		       const struct attribute_group * grp)
+{
+	return internal_create_group(kobj, 0, grp);
+}
+
+int sysfs_update_group(struct kobject * kobj,
+		       const struct attribute_group * grp)
+{
+	return internal_create_group(kobj, 1, grp);
+}
+
+
+
 void sysfs_remove_group(struct kobject * kobj, 
 			const struct attribute_group * grp)
 {
@@ -95,4 +117,5 @@ void sysfs_remove_group(struct kobject * kobj,
 
 
 EXPORT_SYMBOL_GPL(sysfs_create_group);
+EXPORT_SYMBOL_GPL(sysfs_update_group);
 EXPORT_SYMBOL_GPL(sysfs_remove_group);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 52aaa8c..2915959 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -155,6 +155,8 @@ extern const struct file_operations sysfs_file_operations;
 int sysfs_add_file(struct sysfs_dirent *dir_sd,
 		   const struct attribute *attr, int type);
 
+int sysfs_add_file_mode(struct sysfs_dirent *dir_sd,
+			const struct attribute *attr, int type, mode_t amode);
 /*
  * bin.c
  */
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 0f388af..07d9c12 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -32,7 +32,7 @@ struct attribute {
 
 struct attribute_group {
 	const char		*name;
-	int			(*is_visible)(struct kobject *,
+	mode_t			(*is_visible)(struct kobject *,
 					      struct attribute *, int);
 	struct attribute	**attrs;
 };
@@ -105,6 +105,8 @@ void sysfs_remove_link(struct kobject *kobj, const char *name);
 
 int __must_check sysfs_create_group(struct kobject *kobj,
 				    const struct attribute_group *grp);
+int sysfs_update_group(struct kobject *kobj,
+		       const struct attribute_group *grp);
 void sysfs_remove_group(struct kobject *kobj,
 			const struct attribute_group *grp);
 int sysfs_add_file_to_group(struct kobject *kobj,
-- 
1.5.4.3



