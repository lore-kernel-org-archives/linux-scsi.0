From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] 2/2 Use bus dev_attrs to create scsi_device attributes
Date: Wed, 30 Mar 2005 05:15:55 +0200
Message-ID: <20050330031555.GA18871@vrfy.org>
References: <20050302194432.GA9743@us.ibm.com> <20050302194553.GA9776@us.ibm.com> <20050302194647.GB9776@us.ibm.com> <20050316224551.GA21918@us.ibm.com> <1111071201.5994.4.camel@mulgrave> <20050317170853.GA3006@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from soundwarez.org ([217.160.171.123]:45710 "EHLO soundwarez.org")
	by vger.kernel.org with ESMTP id S261736AbVC3DQA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2005 22:16:00 -0500
Content-Disposition: inline
In-Reply-To: <20050317170853.GA3006@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Mar 17, 2005 at 09:08:53AM -0800, Greg KH wrote:
> On Thu, Mar 17, 2005 at 09:53:21AM -0500, James Bottomley wrote:
> > On Wed, 2005-03-16 at 14:45 -0800, Patrick Mansfield wrote:
> > > Any comments on this? Should I resend these patches?
> > 
> > Well, the basic comment is that there are a lot of features that SCSI
> > has that the driver core lacks:
> > 
> > 1) Attribute overrides.  This is actually part of the published API for SCSI
> > 2) Ability to add extra attributes---several drivers use this
> > 3) Ability to change attribute permissions based on capabilities.

> I would be very interested in seeing the above stuff move into the
> driver core.

Point 3) seems to work for me. :)

Thanks,
Kay

---
sysfs: allow change of permissions for already created attributes

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>

===== fs/sysfs/file.c 1.23 vs edited =====
--- 1.23/fs/sysfs/file.c	2005-02-26 15:48:19 +01:00
+++ edited/fs/sysfs/file.c	2005-03-30 04:16:46 +02:00
@@ -428,6 +428,39 @@ int sysfs_update_file(struct kobject * k
 
 
 /**
+ * sysfs_chmod_file - update the modified mode value on an object attribute.
+ * @kobj: object we're acting for.
+ * @mode: file permissions.
+ *
+ */
+int sysfs_chmod_file(struct kobject *kobj, const struct attribute *attr)
+{
+	struct dentry *dir = kobj->dentry;
+	struct dentry *victim;
+	struct sysfs_dirent *sd;
+	umode_t mode = (attr->mode & S_IALLUGO) | S_IFREG;
+	int res = -ENOENT;
+
+	down(&dir->d_inode->i_sem);
+	victim = sysfs_get_dentry(dir, attr->name);
+	if (!IS_ERR(victim)) {
+		if (victim->d_inode &&
+		    (victim->d_parent->d_inode == dir->d_inode)) {
+			sd = victim->d_fsdata;
+			sd->s_mode = mode;
+			victim->d_inode->i_mode = mode;
+			dput(victim);
+			res = 0;
+		}
+	}
+	up(&dir->d_inode->i_sem);
+
+	return res;
+}
+EXPORT_SYMBOL_GPL(sysfs_chmod_file);
+
+
+/**
  *	sysfs_remove_file - remove an object attribute.
  *	@kobj:	object we're acting for.
  *	@attr:	attribute descriptor.
===== include/linux/sysfs.h 1.39 vs edited =====
--- 1.39/include/linux/sysfs.h	2004-12-21 18:31:01 +01:00
+++ edited/include/linux/sysfs.h	2005-03-30 04:12:38 +02:00
@@ -99,6 +99,9 @@ sysfs_create_file(struct kobject *, cons
 extern int
 sysfs_update_file(struct kobject *, const struct attribute *);
 
+extern int
+sysfs_chmod_file(struct kobject *kobj, const struct attribute *attr);
+
 extern void
 sysfs_remove_file(struct kobject *, const struct attribute *);
 
@@ -137,6 +140,10 @@ static inline int sysfs_create_file(stru
 }
 
 static inline int sysfs_update_file(struct kobject * k, const struct attribute * a)
+{
+	return 0;
+}
+static inline int sysfs_chmod_file(struct kobject *kobj, const struct attribute *attr)
 {
 	return 0;
 }

