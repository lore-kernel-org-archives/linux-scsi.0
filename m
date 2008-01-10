From: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Thu, 10 Jan 2008 17:48:43 +0800
Message-ID: <20080110094843.GA3014@darkstar.te-china.tietoenator.com>
References: <478227D5.8050402@s5r6.in-berlin.de> <20080107154404.GA10880@suse.de> <47825DC1.3090102@s5r6.in-berlin.de> <20080107172009.GA25943@suse.de> <a8e1da0801072305x3378c195qeb0bb7027030254c@mail.gmail.com> <20080108224837.GA19623@suse.de> <a8e1da0801081732i3677245chef1fda1fea65f7cf@mail.gmail.com> <20080109061316.GA3249@darkstar.te-china.tietoenator.com> <a8e1da0801082237x37d2a56eqee6db19017499dbc@mail.gmail.com> <a8e1da0801082239h198c4d45i5cd7cf183472a166@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:65041 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbYAJJpZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 04:45:25 -0500
Received: by fg-out-1718.google.com with SMTP id e21so620830fga.17
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jan 2008 01:45:23 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <a8e1da0801082239h198c4d45i5cd7cf183472a166@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru, linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>, krh@redhat.com, stern@rowland.harvard.edu, rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com

On Wed, Jan 09, 2008 at 02:39:23PM +0800, Dave Young wrote:
> On Jan 9, 2008 2:37 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> >
> > On Jan 9, 2008 2:13 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > >
> > > On Wed, Jan 09, 2008 at 09:32:48AM +0800, Dave Young wrote:
> > > > On Jan 9, 2008 6:48 AM, Greg KH <gregkh@suse.de> wrote:
> > > > > On Tue, Jan 08, 2008 at 03:05:10PM +0800, Dave Young wrote:
> > > > > > On Jan 8, 2008 1:20 AM, Greg KH <gregkh@suse.de> wrote:
> > > > > > > On Mon, Jan 07, 2008 at 06:13:37PM +0100, Stefan Richter wrote:
> > > > > > > > It's already in the driver core to the most part.  It remains to be seen
> > > > > > > > what is less complicated in the end:  Transparent mutex-protected list
> > > > > > > > accesses provided by driver core (requires the iterator), or all the
> > > > > > > > necessary locking done by the drivers themselves (requires some more
> > > > > > > > lock-taking but perhaps fewer lock instances overall in the drivers, and
> > > > > > > > respective redefinitions and documentation of the driver core API).
> > > > > > >
> > > > > > > I favor changing the driver core api and doing this kind of thing there.
> > > > > > > It keeps the drivers simpler and should hopefully make their lives
> > > > > > > easier.
> > > > > >
> > > > > > What about this?
> > > > > >
> > > > > > #define class_for_each_dev(pos, head, member) \
> > > > > >         for (mutex_lock(&(container_of(head, struct class, devices))->mutex), po
> > > > > > s = list_entry((head)->next, typeof(*pos), member); \
> > > > > >         prefetch(pos->member.next), &pos->member != (head) ? 1 : (mutex_unlock(&
> > > > > > (container_of(head, struct class, devices))->mutex), 0); \
> > > > > >         pos = list_entry(pos->member.next, typeof(*pos), member))
> > > > >
> > > > I'm wrong, it's same as before indeed.
> > > >
> > > > > Eeek, just make the thing a function please, where you pass the iterator
> > > > > function in, like the driver core has (driver_for_each_device)
> > > >
> > > > Ok, so need a new member of knode_class, I will update the patch later.
> > > > Thanks.
> > >
> > > Withdraw my post, sorry :)
> > >
> > > For now the mutex patch, I will only use the mutex to lock the devices list and write an iterater function.
> > > Most of the iterating is for finding some device in the list, so maybe need a match function just like drivers do?
> > >
> >
> > Drop one more mail address of David Brownell in cc list.
> > Sorry for this, david
> >
> gmail web client make me crazy.
Hi,
The patches are done on my side, please help to check. 

This is the first one of the series about driver core changes. 
If this one is accepted and there's no other problem I will post the others for maintainer's review (they need your comment and help because I don't know well about the specific driver logic).

Thanks a lot in advance.
---

1. convert class semaphore to mutex.
2. add class iterater functions to encapsulate the detail of class devices/children list iterating :
	class_for_each_device
	class_find_device
	class_for_each_child
	class_find_child


Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
 drivers/base/class.c   |   98 +++++++++++++++++++++++++++++++++++++++++++------
 drivers/base/core.c    |   18 ++++-----
 include/linux/device.h |   11 +++++
 3 files changed, 105 insertions(+), 22 deletions(-)

diff -upr linux/drivers/base/class.c linux.new/drivers/base/class.c
--- linux/drivers/base/class.c	2008-01-10 17:17:11.000000000 +0800
+++ linux.new/drivers/base/class.c	2008-01-10 17:17:11.000000000 +0800
@@ -144,7 +144,7 @@ int class_register(struct class * cls)
 	INIT_LIST_HEAD(&cls->devices);
 	INIT_LIST_HEAD(&cls->interfaces);
 	kset_init(&cls->class_dirs);
-	init_MUTEX(&cls->sem);
+	mutex_init(&cls->mutex);
 	error = kobject_set_name(&cls->subsys.kobj, "%s", cls->name);
 	if (error)
 		return error;
@@ -617,13 +617,13 @@ int class_device_add(struct class_device
 	kobject_uevent(&class_dev->kobj, KOBJ_ADD);
 
 	/* notify any interfaces this device is now here */
-	down(&parent_class->sem);
+	mutex_lock_nested(&parent_class->mutex, SINGLE_DEPTH_NESTING);
 	list_add_tail(&class_dev->node, &parent_class->children);
 	list_for_each_entry(class_intf, &parent_class->interfaces, node) {
 		if (class_intf->add)
 			class_intf->add(class_dev, class_intf);
 	}
-	up(&parent_class->sem);
+	mutex_unlock(&parent_class->mutex);
 
 	goto out1;
 
@@ -725,12 +725,12 @@ void class_device_del(struct class_devic
 	struct class_interface *class_intf;
 
 	if (parent_class) {
-		down(&parent_class->sem);
+		mutex_lock(&parent_class->mutex);
 		list_del_init(&class_dev->node);
 		list_for_each_entry(class_intf, &parent_class->interfaces, node)
 			if (class_intf->remove)
 				class_intf->remove(class_dev, class_intf);
-		up(&parent_class->sem);
+		mutex_unlock(&parent_class->mutex);
 	}
 
 	if (class_dev->dev) {
@@ -772,14 +772,14 @@ void class_device_destroy(struct class *
 	struct class_device *class_dev = NULL;
 	struct class_device *class_dev_tmp;
 
-	down(&cls->sem);
+	mutex_lock(&cls->mutex);
 	list_for_each_entry(class_dev_tmp, &cls->children, node) {
 		if (class_dev_tmp->devt == devt) {
 			class_dev = class_dev_tmp;
 			break;
 		}
 	}
-	up(&cls->sem);
+	mutex_unlock(&cls->mutex);
 
 	if (class_dev)
 		class_device_unregister(class_dev);
@@ -812,7 +812,7 @@ int class_interface_register(struct clas
 	if (!parent)
 		return -EINVAL;
 
-	down(&parent->sem);
+	mutex_lock(&parent->mutex);
 	list_add_tail(&class_intf->node, &parent->interfaces);
 	if (class_intf->add) {
 		list_for_each_entry(class_dev, &parent->children, node)
@@ -822,11 +822,87 @@ int class_interface_register(struct clas
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->add_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	return 0;
 }
 
+int class_for_each_device(struct class *class, void *data,
+			   int (*fn)(struct device *, void *))
+{
+	struct device *dev;
+	int error = 0;
+
+	if (!class)
+		return -EINVAL;
+	mutex_lock(&class->mutex);
+	list_for_each_entry(dev, &class->devices, node) {
+		error = fn(dev, data);
+		if (error)
+			break;
+	}
+	mutex_unlock(&class->mutex);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(class_for_each_device);
+
+struct device *class_find_device(struct class *class, void *data,
+				   int (*match)(struct device *, void *))
+{
+	struct device *dev;
+
+	if (!class)
+		return NULL;
+
+	mutex_lock(&class->mutex);
+	list_for_each_entry(dev, &class->devices, node)
+		if (match(dev, data) && get_device(dev))
+			break;
+	mutex_unlock(&class->mutex);
+
+	return dev;
+}
+EXPORT_SYMBOL_GPL(class_find_device);
+
+int class_for_each_child(struct class *class, void *data,
+			   int (*fn)(struct class_device *, void *))
+{
+	struct class_device *dev;
+	int error = 0;
+
+	if (!class)
+		return -EINVAL;
+	mutex_lock(&class->mutex);
+	list_for_each_entry(dev, &class->children, node) {
+		error = fn(dev, data);
+		if (error)
+			break;
+	}
+	mutex_unlock(&class->mutex);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(class_for_each_child);
+
+struct class_device *class_find_child(struct class *class, void *data,
+				   int (*match)(struct class_device *, void *))
+{
+	struct class_device *dev;
+
+	if (!class)
+		return NULL;
+
+	mutex_lock(&class->mutex);
+	list_for_each_entry(dev, &class->children, node)
+		if (match(dev, data) && class_device_get(dev))
+			break;
+	mutex_unlock(&class->mutex);
+
+	return dev;
+}
+EXPORT_SYMBOL_GPL(class_find_child);
+
 void class_interface_unregister(struct class_interface *class_intf)
 {
 	struct class * parent = class_intf->class;
@@ -836,7 +912,7 @@ void class_interface_unregister(struct c
 	if (!parent)
 		return;
 
-	down(&parent->sem);
+	mutex_lock(&parent->mutex);
 	list_del_init(&class_intf->node);
 	if (class_intf->remove) {
 		list_for_each_entry(class_dev, &parent->children, node)
@@ -846,7 +922,7 @@ void class_interface_unregister(struct c
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->remove_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	class_put(parent);
 }
diff -upr linux/drivers/base/core.c linux.new/drivers/base/core.c
--- linux/drivers/base/core.c	2008-01-10 17:17:11.000000000 +0800
+++ linux.new/drivers/base/core.c	2008-01-10 17:17:11.000000000 +0800
@@ -19,8 +19,6 @@
 #include <linux/kdev_t.h>
 #include <linux/notifier.h>
 
-#include <asm/semaphore.h>
-
 #include "base.h"
 #include "power/power.h"
 
@@ -783,7 +781,7 @@ int device_add(struct device *dev)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
 	if (dev->class) {
-		down(&dev->class->sem);
+		mutex_lock(&dev->class->mutex);
 		/* tie the class to the device */
 		list_add_tail(&dev->node, &dev->class->devices);
 
@@ -791,7 +789,7 @@ int device_add(struct device *dev)
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
 			if (class_intf->add_dev)
 				class_intf->add_dev(dev, class_intf);
-		up(&dev->class->sem);
+		mutex_unlock(&dev->class->mutex);
 	}
  Done:
 	put_device(dev);
@@ -928,14 +926,14 @@ void device_del(struct device * dev)
 			sysfs_remove_link(&dev->kobj, "device");
 		}
 
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
 
 		/* If we live in a parent class-directory, unreference it */
 		if (dev->kobj.parent->kset == &dev->class->class_dirs) {
@@ -946,7 +944,7 @@ void device_del(struct device * dev)
 			 * if we are the last child of our class, delete
 			 * our class-directory at this parent
 			 */
-			down(&dev->class->sem);
+			mutex_lock(&dev->class->mutex);
 			list_for_each_entry(d, &dev->class->devices, node) {
 				if (d == dev)
 					continue;
@@ -959,7 +957,7 @@ void device_del(struct device * dev)
 				kobject_del(dev->kobj.parent);
 
 			kobject_put(dev->kobj.parent);
-			up(&dev->class->sem);
+			mutex_unlock(&dev->class->mutex);
 		}
 	}
 	device_remove_file(dev, &uevent_attr);
@@ -1168,14 +1166,14 @@ void device_destroy(struct class *class,
 	struct device *dev = NULL;
 	struct device *dev_tmp;
 
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev_tmp, &class->devices, node) {
 		if (dev_tmp->devt == devt) {
 			dev = dev_tmp;
 			break;
 		}
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	if (dev)
 		device_unregister(dev);
diff -upr linux/include/linux/device.h linux.new/include/linux/device.h
--- linux/include/linux/device.h	2008-01-10 17:17:11.000000000 +0800
+++ linux.new/include/linux/device.h	2008-01-10 17:17:12.000000000 +0800
@@ -20,6 +20,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pm.h>
+#include <linux/mutex.h>
 #include <asm/semaphore.h>
 #include <asm/atomic.h>
 #include <asm/device.h>
@@ -180,7 +181,7 @@ struct class {
 	struct list_head	devices;
 	struct list_head	interfaces;
 	struct kset		class_dirs;
-	struct semaphore	sem;	/* locks both the children and interfaces lists */
+	struct mutex		mutex;
 
 	struct class_attribute		* class_attrs;
 	struct class_device_attribute	* class_dev_attrs;
@@ -197,6 +198,14 @@ struct class {
 	int	(*resume)(struct device *);
 };
 
+extern int class_for_each_device(struct class *class, void *data,
+				int (*fn)(struct device *dev, void *data));
+extern struct device *class_find_device(struct class *class, void *data,
+				   int (*match)(struct device *, void *));
+extern int class_for_each_child(struct class *class, void *data,
+			   int (*fn)(struct class_device *, void *));
+extern struct class_device *class_find_child(struct class *class, void *data,
+				   int (*match)(struct class_device *, void *));
 extern int __must_check class_register(struct class *);
 extern void class_unregister(struct class *);
 
