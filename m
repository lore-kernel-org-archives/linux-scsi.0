From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] 2/2 Use bus dev_attrs to create scsi_device attributes
Date: Wed, 30 Mar 2005 20:07:02 +0200
Message-ID: <20050330180702.GA4654@vrfy.org>
References: <20050302194432.GA9743@us.ibm.com> <20050302194553.GA9776@us.ibm.com> <20050302194647.GB9776@us.ibm.com> <20050316224551.GA21918@us.ibm.com> <1111071201.5994.4.camel@mulgrave> <20050317170853.GA3006@kroah.com> <20050330031555.GA18871@vrfy.org> <20050330042043.GA9002@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from soundwarez.org ([217.160.171.123]:57276 "EHLO soundwarez.org")
	by vger.kernel.org with ESMTP id S262372AbVC3SHD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2005 13:07:03 -0500
Content-Disposition: inline
In-Reply-To: <20050330042043.GA9002@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Mar 29, 2005 at 08:20:43PM -0800, Greg KH wrote:
> On Wed, Mar 30, 2005 at 05:15:55AM +0200, Kay Sievers wrote:
> >  /**
> > + * sysfs_chmod_file - update the modified mode value on an object attribute.
> > + * @kobj: object we're acting for.
> > + * @mode: file permissions.
> > + *
> > + */
> > +int sysfs_chmod_file(struct kobject *kobj, const struct attribute *attr)
> 
> Your documentation doesn't match up with your function arguments :)

Bah, I tried both versions. :)

> Shouldn't you want an extra mode variable?  Makes it easier to override
> than remembering to change the mode in the attribute before calling the
> function.

If that's better, sure. Here is a new patch.

Thanks,
Kay

---
sysfs: allow changing the permissions for already created attributes

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>

===== fs/sysfs/file.c 1.23 vs edited =====
--- 1.23/fs/sysfs/file.c	2005-02-26 15:48:19 +01:00
+++ edited/fs/sysfs/file.c	2005-03-30 20:01:16 +02:00
@@ -428,6 +428,41 @@ int sysfs_update_file(struct kobject * k
 
 
 /**
+ * sysfs_chmod_file - update the modified mode value on an object attribute.
+ * @kobj: object we're acting for.
+ * @attr: attribute descriptor.
+ * @mode: file permissions.
+ *
+ */
+int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
+{
+	struct dentry *dir = kobj->dentry;
+	struct dentry *victim;
+	struct sysfs_dirent *sd;
+	umode_t umode = (mode & S_IALLUGO) | S_IFREG;
+	int res = -ENOENT;
+
+	down(&dir->d_inode->i_sem);
+	victim = sysfs_get_dentry(dir, attr->name);
+	if (!IS_ERR(victim)) {
+		if (victim->d_inode &&
+		    (victim->d_parent->d_inode == dir->d_inode)) {
+			sd = victim->d_fsdata;
+			attr->mode = mode;
+			sd->s_mode = umode;
+			victim->d_inode->i_mode = umode;
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
+++ edited/include/linux/sysfs.h	2005-03-30 15:06:23 +02:00
@@ -99,6 +99,9 @@ sysfs_create_file(struct kobject *, cons
 extern int
 sysfs_update_file(struct kobject *, const struct attribute *);
 
+extern int
+sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode);
+
 extern void
 sysfs_remove_file(struct kobject *, const struct attribute *);
 
@@ -137,6 +140,10 @@ static inline int sysfs_create_file(stru
 }
 
 static inline int sysfs_update_file(struct kobject * k, const struct attribute * a)
+{
+	return 0;
+}
+static inline int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 {
 	return 0;
 }

