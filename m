From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/3][-mm] add class_reclassify macro
Date: Wed, 28 May 2008 09:48:40 -0600
Message-ID: <20080528154840.GJ22636@parisc-linux.org>
References: <20080520095553.GA3201@darkstar.te-china.tietoenator.com> <20080520030232.fc91b64e.akpm@linux-foundation.org> <20080520172139.GA11666@kroah.com> <a8e1da0805262342g2dec037eqfdf376e66459e758@mail.gmail.com> <20080526235934.8a28bfba.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753038AbYE1Psz@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080526235934.8a28bfba.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, Greg KH <greg@kroah.com>, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 26, 2008 at 11:59:34PM -0700, Andrew Morton wrote:
> If that semaphore is being used as a mutex then we should convert it to
> a mutex (dammit).

Right.

> Leaving it implemented as a semphore is not the proper way of
> suppressing the lockdep warnings.  It would be better to convert it to
> a mutex then add suitable (and suitably commented) open-coded lockdep
> annotations to suppress the runtime warnings.

We don't even have to go that far.  Here's all that's needed:

diff -u a/drivers/base/class.c b/drivers/base/class.c
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -134,7 +134,7 @@
 	}
 }
 
-int class_register(struct class *cls)
+int __class_register(struct class *cls, struct lock_class_key *key)
 {
 	int error;
 
@@ -143,7 +143,7 @@
 	INIT_LIST_HEAD(&cls->devices);
 	INIT_LIST_HEAD(&cls->interfaces);
 	kset_init(&cls->class_dirs);
-	mutex_init(&cls->mutex);
+	__mutex_init(&cls->mutex, "struct class mutex", key);
 	error = kobject_set_name(&cls->subsys.kobj, "%s", cls->name);
 	if (error)
 		return error;
@@ -389,7 +389,7 @@
 
 EXPORT_SYMBOL_GPL(class_create_file);
 EXPORT_SYMBOL_GPL(class_remove_file);
-EXPORT_SYMBOL_GPL(class_register);
+EXPORT_SYMBOL_GPL(__class_register);
 EXPORT_SYMBOL_GPL(class_unregister);
 EXPORT_SYMBOL_GPL(class_create);
 EXPORT_SYMBOL_GPL(class_destroy);
diff -u a/include/linux/device.h b/include/linux/device.h
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/klist.h>
 #include <linux/list.h>
+#include <linux/lockdep.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/module.h>
@@ -200,7 +201,14 @@
 	int (*resume)(struct device *dev);
 };
 
-extern int __must_check class_register(struct class *class);
+#define class_register(class)			\
+({						\
+	static struct lock_class_key __key;	\
+	__class_register(class, &__key);	\
+})
+
+extern int __must_check __class_register(struct class *class,
+					struct lock_class_key *key);
 extern void class_unregister(struct class *class);
 extern int class_for_each_device(struct class *class, void *data,
 				 int (*fn)(struct device *dev, void *data));

And here's a replacement patch for what's in your tree (to improve git
bisectability):

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/base/class.c b/drivers/base/class.c
index e085af0..d28cb5f 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -134,7 +134,7 @@ static void remove_class_attrs(struct class *cls)
 	}
 }
 
-int class_register(struct class *cls)
+int __class_register(struct class *cls, struct lock_class_key *key)
 {
 	int error;
 
@@ -143,7 +143,7 @@ int class_register(struct class *cls)
 	INIT_LIST_HEAD(&cls->devices);
 	INIT_LIST_HEAD(&cls->interfaces);
 	kset_init(&cls->class_dirs);
-	init_MUTEX(&cls->sem);
+	__mutex_init(&cls->mutex, "struct class mutex", key);
 	error = kobject_set_name(&cls->subsys.kobj, "%s", cls->name);
 	if (error)
 		return error;
@@ -261,7 +261,7 @@ char *make_class_name(const char *name, struct kobject *kobj)
  * We check the return of @fn each time. If it returns anything
  * other than 0, we break out and return that value.
  *
- * Note, we hold class->sem in this function, so it can not be
+ * Note, we hold class->mutex in this function, so it can not be
  * re-acquired in @fn, otherwise it will self-deadlocking. For
  * example, calls to add or remove class members would be verboten.
  */
@@ -273,7 +273,7 @@ int class_for_each_device(struct class *class, void *data,
 
 	if (!class)
 		return -EINVAL;
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev, &class->devices, node) {
 		dev = get_device(dev);
 		if (dev) {
@@ -284,7 +284,7 @@ int class_for_each_device(struct class *class, void *data,
 		if (error)
 			break;
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return error;
 }
@@ -306,7 +306,7 @@ EXPORT_SYMBOL_GPL(class_for_each_device);
  *
  * Note, you will need to drop the reference with put_device() after use.
  *
- * We hold class->sem in this function, so it can not be
+ * We hold class->mutex in this function, so it can not be
  * re-acquired in @match, otherwise it will self-deadlocking. For
  * example, calls to add or remove class members would be verboten.
  */
@@ -319,7 +319,7 @@ struct device *class_find_device(struct class *class, void *data,
 	if (!class)
 		return NULL;
 
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev, &class->devices, node) {
 		dev = get_device(dev);
 		if (dev) {
@@ -331,7 +331,7 @@ struct device *class_find_device(struct class *class, void *data,
 		} else
 			break;
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return found ? dev : NULL;
 }
@@ -349,13 +349,13 @@ int class_interface_register(struct class_interface *class_intf)
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
@@ -368,13 +368,13 @@ void class_interface_unregister(struct class_interface *class_intf)
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
@@ -389,7 +389,7 @@ int __init classes_init(void)
 
 EXPORT_SYMBOL_GPL(class_create_file);
 EXPORT_SYMBOL_GPL(class_remove_file);
-EXPORT_SYMBOL_GPL(class_register);
+EXPORT_SYMBOL_GPL(__class_register);
 EXPORT_SYMBOL_GPL(class_unregister);
 EXPORT_SYMBOL_GPL(class_create);
 EXPORT_SYMBOL_GPL(class_destroy);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 72eccae..068d3de 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -20,7 +20,6 @@
 #include <linux/notifier.h>
 #include <linux/genhd.h>
 #include <linux/kallsyms.h>
-#include <linux/semaphore.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -833,7 +832,7 @@ int device_add(struct device *dev)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
 	if (dev->class) {
-		down(&dev->class->sem);
+		mutex_lock(&dev->class->mutex);
 		/* tie the class to the device */
 		list_add_tail(&dev->node, &dev->class->devices);
 
@@ -841,7 +840,7 @@ int device_add(struct device *dev)
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
 			if (class_intf->add_dev)
 				class_intf->add_dev(dev, class_intf);
-		up(&dev->class->sem);
+		mutex_unlock(&dev->class->mutex);
 	}
  Done:
 	put_device(dev);
@@ -937,14 +936,14 @@ void device_del(struct device *dev)
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
diff --git a/include/linux/device.h b/include/linux/device.h
index 14616e8..718f4c0 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -16,10 +16,12 @@
 #include <linux/kobject.h>
 #include <linux/klist.h>
 #include <linux/list.h>
+#include <linux/lockdep.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pm.h>
+#include <linux/mutex.h>
 #include <linux/semaphore.h>
 #include <asm/atomic.h>
 #include <asm/device.h>
@@ -186,7 +188,7 @@ struct class {
 	struct list_head	devices;
 	struct list_head	interfaces;
 	struct kset		class_dirs;
-	struct semaphore	sem; /* locks children, devices, interfaces */
+	struct mutex		mutex; /* locks devices, interfaces */
 	struct class_attribute		*class_attrs;
 	struct device_attribute		*dev_attrs;
 
@@ -199,7 +201,14 @@ struct class {
 	int (*resume)(struct device *dev);
 };
 
-extern int __must_check class_register(struct class *class);
+#define class_register(class)			\
+({						\
+	static struct lock_class_key __key;	\
+	__class_register(class, &__key);	\
+})
+
+extern int __must_check __class_register(struct class *class,
+					struct lock_class_key *key);
 extern void class_unregister(struct class *class);
 extern int class_for_each_device(struct class *class, void *data,
 				 int (*fn)(struct device *dev, void *data));

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
