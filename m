From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][-mm] reclassify sg_sysfs_class for lockdep
Date: Wed, 28 May 2008 12:18:06 -0700
Message-ID: <20080528121806.a0207130.akpm@linux-foundation.org>
References: <20080527101009.GA3015@darkstar.te-china.tietoenator.com>
	<20080528144943.GI22636@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752436AbYE1TSJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2008 15:18:09 -0400
In-Reply-To: <20080528144943.GI22636@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: hidave.darkstar@gmail.com, greg@kroah.com, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 28 May 2008 08:49:43 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Tue, May 27, 2008 at 06:10:09PM +0800, Dave Young wrote:
> > As register sg_interface, the sg_add will be called, which then will
> > add device to sg_sysfs_class. This will cause lockdep warning,
> > please see following email
> > 
> > In this case the locks are from diffrent classi, one is sdev_class,
> > another is sg_sysfs_class 
> > 
> > Here reclassify the sg_sysfs_class for lockdep
> 
> Look, you've been told how to do this properly.  Send me the patch that
> does the mutex conversion and I'll do a patch on top of that.

Below.

>  I have no
> inclination to go wading in the cesspool of patches that is mm trying to
> find yours.

Feel free to identify the cessful patches so they can be fixed or dropped.


From: Dave Young <hidave.darkstar@gmail.com>

The class_device is already removed, so do the class->sem to mutex conversion.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/class.c   |   22 +++++++++++-----------
 drivers/base/core.c    |    9 ++++-----
 include/linux/device.h |    3 ++-
 3 files changed, 17 insertions(+), 17 deletions(-)

diff -puN drivers/base/class.c~struct-class-sem-to-mutex-converting drivers/base/class.c
--- a/drivers/base/class.c~struct-class-sem-to-mutex-converting
+++ a/drivers/base/class.c
@@ -143,7 +143,7 @@ int class_register(struct class *cls)
 	INIT_LIST_HEAD(&cls->devices);
 	INIT_LIST_HEAD(&cls->interfaces);
 	kset_init(&cls->class_dirs);
-	init_MUTEX(&cls->sem);
+	mutex_init(&cls->mutex);
 	error = kobject_set_name(&cls->subsys.kobj, "%s", cls->name);
 	if (error)
 		return error;
@@ -268,7 +268,7 @@ char *make_class_name(const char *name, 
  * We check the return of @fn each time. If it returns anything
  * other than 0, we break out and return that value.
  *
- * Note, we hold class->sem in this function, so it can not be
+ * Note, we hold class->mutex in this function, so it can not be
  * re-acquired in @fn, otherwise it will self-deadlocking. For
  * example, calls to add or remove class members would be verboten.
  */
@@ -280,7 +280,7 @@ int class_for_each_device(struct class *
 
 	if (!class)
 		return -EINVAL;
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev, &class->devices, node) {
 		if (start) {
 			if (start == dev)
@@ -293,7 +293,7 @@ int class_for_each_device(struct class *
 		if (error)
 			break;
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return error;
 }
@@ -316,7 +316,7 @@ EXPORT_SYMBOL_GPL(class_for_each_device)
  *
  * Note, you will need to drop the reference with put_device() after use.
  *
- * We hold class->sem in this function, so it can not be
+ * We hold class->mutex in this function, so it can not be
  * re-acquired in @match, otherwise it will self-deadlocking. For
  * example, calls to add or remove class members would be verboten.
  */
@@ -330,7 +330,7 @@ struct device *class_find_device(struct 
 	if (!class)
 		return NULL;
 
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev, &class->devices, node) {
 		if (start) {
 			if (start == dev)
@@ -344,7 +344,7 @@ struct device *class_find_device(struct 
 		} else
 			put_device(dev);
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return found ? dev : NULL;
 }
@@ -362,13 +362,13 @@ int class_interface_register(struct clas
 	if (!parent)
 		return -EINVAL;
 
-	down(&parent->sem);
+	mutex_lock(&parent->mutex);
 	list_add_tail(&class_intf->node, &parent->interfaces);
 	if (class_intf->add_dev) {
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->add_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	return 0;
 }
@@ -381,13 +381,13 @@ void class_interface_unregister(struct c
 	if (!parent)
 		return;
 
-	down(&parent->sem);
+	mutex_lock(&parent->mutex);
 	list_del_init(&class_intf->node);
 	if (class_intf->remove_dev) {
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->remove_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	class_put(parent);
 }
diff -puN drivers/base/core.c~struct-class-sem-to-mutex-converting drivers/base/core.c
--- a/drivers/base/core.c~struct-class-sem-to-mutex-converting
+++ a/drivers/base/core.c
@@ -20,7 +20,6 @@
 #include <linux/notifier.h>
 #include <linux/genhd.h>
 #include <linux/kallsyms.h>
-#include <linux/semaphore.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -889,7 +888,7 @@ int device_add(struct device *dev)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
 	if (dev->class) {
-		down(&dev->class->sem);
+		mutex_lock(&dev->class->mutex);
 		/* tie the class to the device */
 		list_add_tail(&dev->node, &dev->class->devices);
 
@@ -897,7 +896,7 @@ int device_add(struct device *dev)
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
 			if (class_intf->add_dev)
 				class_intf->add_dev(dev, class_intf);
-		up(&dev->class->sem);
+		mutex_unlock(&dev->class->mutex);
 	}
  Done:
 	put_device(dev);
@@ -998,14 +997,14 @@ void device_del(struct device *dev)
 	if (dev->class) {
 		device_remove_class_symlinks(dev);
 
-		down(&dev->class->sem);
+		mutex_lock(&dev->class->mutex);
 		/* notify any interfaces that the device is now gone */
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
 			if (class_intf->remove_dev)
 				class_intf->remove_dev(dev, class_intf);
 		/* remove the device from the class list */
 		list_del_init(&dev->node);
-		up(&dev->class->sem);
+		mutex_unlock(&dev->class->mutex);
 	}
 	device_remove_file(dev, &uevent_attr);
 	device_remove_attrs(dev);
diff -puN include/linux/device.h~struct-class-sem-to-mutex-converting include/linux/device.h
--- a/include/linux/device.h~struct-class-sem-to-mutex-converting
+++ a/include/linux/device.h
@@ -20,6 +20,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pm.h>
+#include <linux/mutex.h>
 #include <linux/semaphore.h>
 #include <asm/atomic.h>
 #include <asm/device.h>
@@ -185,7 +186,7 @@ struct class {
 	struct list_head	devices;
 	struct list_head	interfaces;
 	struct kset		class_dirs;
-	struct semaphore	sem; /* locks children, devices, interfaces */
+	struct mutex		mutex; /* locks devices, interfaces */
 	struct class_attribute		*class_attrs;
 	struct device_attribute		*dev_attrs;
 	struct kobject			*dev_kobj;
_

