From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Thu, 3 Nov 2016 16:27:22 -0600
Message-ID: <96320196-4074-c970-97f0-bffb74713990@sandisk.com>
References: <14379fd1-c9bd-ad75-ca7c-0632f3e3c5d1@sandisk.com>
 <1477706936.2850.27.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0069.outbound.protection.outlook.com ([104.47.40.69]:6832
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932105AbcKCW1a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Nov 2016 18:27:30 -0400
In-Reply-To: <1477706936.2850.27.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/28/2016 08:08 PM, James Bottomley wrote:
> This is a deadlock caused by an inversion issue in kernfs (suicide vs
> non-suicide removes); so fixing it in SCSI alone really isn't
> appropriate.  I count at least five other subsystems all using this
> mechanism, so they'll all be similarly affected.  It looks to be fairly
> simply fixable inside kernfs, so please fix it that way.

Hello James,

How about fixing this deadlock with the below patch?

Thanks,

Bart.

---
 drivers/base/core.c       | 45 +++++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/scsi_sysfs.c | 10 +++++++---
 fs/kernfs/dir.c           | 11 ++++++++++-
 fs/sysfs/file.c           | 42 +++++++++++++++++++++++++++++++++++++++---
 include/linux/device.h    |  6 ++++++
 include/linux/kernfs.h    |  6 ++++--
 include/linux/sysfs.h     | 16 ++++++++++++++++
 7 files changed, 123 insertions(+), 13 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index ce057a5..8f74abe 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -616,6 +616,46 @@ void device_remove_file(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(device_remove_file);
 
+struct device_self_removal_data {
+	void (*cb)(struct device *, const struct device_attribute *, void *);
+	struct device			*dev;
+	const struct device_attribute	*attr;
+	void				*data;
+};
+
+static void device_call_cb(struct kobject *kobj, const struct attribute *attr,
+			   void *data)
+{
+	const struct device_self_removal_data *srd = data;
+
+	srd->cb(srd->dev, srd->attr, srd->data);
+}
+
+/**
+ * device_remove_file_self_cb - remove sysfs attribute file from its own method
+ * @dev: device
+ * @attr: device attribute descriptor
+ * @cb: callback function called without holding the kernfs s_active lock
+ * @data: third argument passed to @cb
+ *
+ * See kernfs_remove_self() for details.
+ */
+bool device_remove_file_self_cb(struct device *dev,
+				const struct device_attribute *attr,
+				void (*cb)(struct device *,
+					   const struct device_attribute *,
+					   void *),
+				void *data)
+{
+	struct device_self_removal_data srd = { cb, dev, attr, data };
+
+	if (!dev)
+		return false;
+	return sysfs_remove_file_self_cb(&dev->kobj, &attr->attr, cb ?
+					 device_call_cb : NULL, &srd);
+}
+EXPORT_SYMBOL_GPL(device_remove_file_self_cb);
+
 /**
  * device_remove_file_self - remove sysfs attribute file from its own method.
  * @dev: device.
@@ -626,10 +666,7 @@ EXPORT_SYMBOL_GPL(device_remove_file);
 bool device_remove_file_self(struct device *dev,
 			     const struct device_attribute *attr)
 {
-	if (dev)
-		return sysfs_remove_file_self(&dev->kobj, &attr->attr);
-	else
-		return false;
+	return device_remove_file_self_cb(dev, attr, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(device_remove_file_self);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 0af9c91..2a30c9b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -705,14 +705,18 @@ store_rescan_field (struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field);
 
+static void sdev_delete_cb(struct device *dev,
+			   const struct device_attribute *attr, void *data)
+{
+	scsi_remove_device(to_scsi_device(dev));
+}
 static ssize_t
 sdev_store_delete(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
-	if (device_remove_file_self(dev, attr))
-		scsi_remove_device(to_scsi_device(dev));
+	device_remove_file_self_cb(dev, attr, sdev_delete_cb, NULL);
 	return count;
-};
+}
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
 
 static ssize_t
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index cf4c636..2831c8fa 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1313,6 +1313,8 @@ void kernfs_unbreak_active_protection(struct kernfs_node *kn)
 /**
  * kernfs_remove_self - remove a kernfs_node from its own method
  * @kn: the self kernfs_node to remove
+ * @cb: callback function called without holding the kernfs s_active lock
+ * @data: second argument passed to @cb
  *
  * The caller must be running off of a kernfs operation which is invoked
  * with an active reference - e.g. one of kernfs_ops.  This can be used to
@@ -1336,7 +1338,8 @@ void kernfs_unbreak_active_protection(struct kernfs_node *kn)
  * guarantee, for example, all concurrent writes to a "delete" file to
  * finish only after the whole operation is complete.
  */
-bool kernfs_remove_self(struct kernfs_node *kn)
+bool kernfs_remove_self(struct kernfs_node *kn,
+			void (*cb)(struct kernfs_node *, void *), void *data)
 {
 	bool ret;
 
@@ -1354,6 +1357,12 @@ bool kernfs_remove_self(struct kernfs_node *kn)
 	 */
 	if (!(kn->flags & KERNFS_SUICIDAL)) {
 		kn->flags |= KERNFS_SUICIDAL;
+		mutex_unlock(&kernfs_mutex);
+
+		if (cb)
+			cb(kn, data);
+
+		mutex_lock(&kernfs_mutex);
 		__kernfs_remove(kn);
 		kn->flags |= KERNFS_SUICIDED;
 		ret = true;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index b803213..e17085a 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -422,29 +422,65 @@ void sysfs_remove_file_ns(struct kobject *kobj, const struct attribute *attr,
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_file_ns);
 
+struct sysfs_self_removal_data {
+	void (*cb)(struct kobject *, const struct attribute *, void *);
+	struct kobject		*kobj;
+	const struct attribute	*attr;
+	void			*data;
+};
+
+static void sysfs_call_cb(struct kernfs_node *kn, void *data)
+{
+	const struct sysfs_self_removal_data *srd = data;
+
+	srd->cb(srd->kobj, srd->attr, srd->data);
+}
+
 /**
- * sysfs_remove_file_self - remove an object attribute from its own method
+ * sysfs_remove_file_self_cb - remove an object attribute from its own method
  * @kobj: object we're acting for
  * @attr: attribute descriptor
+ * @cb: callback function called without holding the kernfs s_active lock
+ * @data: third argument passed to @cb
  *
  * See kernfs_remove_self() for details.
  */
-bool sysfs_remove_file_self(struct kobject *kobj, const struct attribute *attr)
+bool sysfs_remove_file_self_cb(struct kobject *kobj,
+			       const struct attribute *attr,
+			       void (*cb)(struct kobject *,
+					  const struct attribute *,
+					  void *),
+			       void *data)
 {
 	struct kernfs_node *parent = kobj->sd;
 	struct kernfs_node *kn;
+	struct sysfs_self_removal_data srd = { cb, kobj, attr, data };
 	bool ret;
 
 	kn = kernfs_find_and_get(parent, attr->name);
 	if (WARN_ON_ONCE(!kn))
 		return false;
 
-	ret = kernfs_remove_self(kn);
+	ret = kernfs_remove_self(kn, cb ? sysfs_call_cb : NULL,
+				 &srd);
 
 	kernfs_put(kn);
 	return ret;
 }
 
+/**
+ * sysfs_remove_file_self - remove an object attribute from its own method
+ * @kobj: object we're acting for
+ * @attr: attribute descriptor
+ * @cb: callback function called without holding the kernfs s_active lock
+ *
+ * See kernfs_remove_self() for details.
+ */
+bool sysfs_remove_file_self(struct kobject *kobj, const struct attribute *attr)
+{
+	return sysfs_remove_file_self_cb(kobj, attr, NULL, NULL);
+}
+
 void sysfs_remove_files(struct kobject *kobj, const struct attribute **ptr)
 {
 	int i;
diff --git a/include/linux/device.h b/include/linux/device.h
index bc41e87..55c3abc 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -597,6 +597,12 @@ extern int device_create_file(struct device *device,
 			      const struct device_attribute *entry);
 extern void device_remove_file(struct device *dev,
 			       const struct device_attribute *attr);
+extern bool device_remove_file_self_cb(struct device *dev,
+				       const struct device_attribute *attr,
+				       void (*cb)(struct device *,
+						const struct device_attribute *,
+						void *),
+				       void *data);
 extern bool device_remove_file_self(struct device *dev,
 				    const struct device_attribute *attr);
 extern int __must_check device_create_bin_file(struct device *dev,
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 7056238..14f3ef2 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -309,7 +309,8 @@ void kernfs_activate(struct kernfs_node *kn);
 void kernfs_remove(struct kernfs_node *kn);
 void kernfs_break_active_protection(struct kernfs_node *kn);
 void kernfs_unbreak_active_protection(struct kernfs_node *kn);
-bool kernfs_remove_self(struct kernfs_node *kn);
+bool kernfs_remove_self(struct kernfs_node *kn,
+			void (*cb)(struct kernfs_node *, void *), void *data);
 int kernfs_remove_by_name_ns(struct kernfs_node *parent, const char *name,
 			     const void *ns);
 int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
@@ -399,7 +400,8 @@ static inline void kernfs_activate(struct kernfs_node *kn) { }
 
 static inline void kernfs_remove(struct kernfs_node *kn) { }
 
-static inline bool kernfs_remove_self(struct kernfs_node *kn)
+static inline bool kernfs_remove_self(struct kernfs_node *kn,
+				      void (*cb)(void *), void *data)
 { return false; }
 
 static inline int kernfs_remove_by_name_ns(struct kernfs_node *kn,
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index c6f0f0d..69f465e 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -234,6 +234,12 @@ int __must_check sysfs_chmod_file(struct kobject *kobj,
 				  const struct attribute *attr, umode_t mode);
 void sysfs_remove_file_ns(struct kobject *kobj, const struct attribute *attr,
 			  const void *ns);
+bool sysfs_remove_file_self_cb(struct kobject *kobj,
+			       const struct attribute *attr,
+			       void (*cb)(struct kobject *,
+					  const struct attribute *,
+					  void *),
+			       void *data);
 bool sysfs_remove_file_self(struct kobject *kobj, const struct attribute *attr);
 void sysfs_remove_files(struct kobject *kobj, const struct attribute **attr);
 
@@ -351,6 +357,16 @@ static inline void sysfs_remove_file_ns(struct kobject *kobj,
 {
 }
 
+static inline bool sysfs_remove_file_self_cb(struct kobject *kobj,
+					     const struct attribute *attr,
+					     void (*cb)(struct kobject *,
+						const struct attribute *,
+						void *),
+			       void *data);
+{
+	return false;
+}
+
 static inline bool sysfs_remove_file_self(struct kobject *kobj,
 					  const struct attribute *attr)
 {
-- 
2.10.1


