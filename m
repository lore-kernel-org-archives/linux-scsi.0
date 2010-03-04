From: "Hugh Daschbach" <hdasch@broadcom.com>
Subject: RE: System reboot hangs due to race against devices_kset->list
 triggered by SCSI FC workqueue
Date: Wed, 3 Mar 2010 19:25:29 -0800
Message-ID: <233671224A0FED4688218FFDBED26E1A517AC38CA5@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <233671224A0FED4688218FFDBED26E1A517AC38AB8@IRVEXCHCCR01.corp.ad.broadcom.com>
 <Pine.LNX.4.44L0.1003031524110.1485-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1003031524110.1485-100000@iolanthe.rowland.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>, David Vrabel <david.vrabel@csr.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, james Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>
List-Id: linux-scsi@vger.kernel.org

Alan Stern [mailto:stern@rowland.harvard.edu] writes:

> On Wed, 3 Mar 2010, Hugh Daschbach wrote:
>
>> > Can't we just protect the list?  What is wanting to write to the list
>> > while shutdown is happening?
>> 
>> Indeed, Alan suggested holding the kset spinlock while iterating the
>> list.  Unfortunately, the device shutdown routines may sleep.  At least
>> the SCSI sd_shutdown routine issues I/O to the device as part of
>> flushing device caches.  I would guess other subsystems sleep as well.
>
> What I meant was that you should hold the spinlock while finding and 
> unlinking the last device on the list.  Clearly you shouldn't hold it 
> while calling the device shutdown routine.

I misunderstood.  But I believe insertion and deletion is properly
serliaized.  It looks to me like the list structure is intact.  It's the
iterator that's been driven off into the weeds.

>> I'll try klist.  That looks like a good mediator between traversal and
>> removal.
>
> Yes, it removes a lot of difficulties.
>
> Alan Stern

Just to be clear, the list we're talking about is "list" in "struct
kset"  And the nodes of the list are chained by "entry" in "struct
kobject".  I just want to make sure that this is what's intended before
I get too far down the road.

At a minimum the change looks something like the patch below.  This
doesn't work yet.  And I'll need extensive testing in device plug and
unplug.  So I'm not looking for a detailed review.  But if I'm obviously
way off base, I'd like to know earlier rather than later.

Thanks for the guidance.

Hugh

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 58ae8e0..2c9b14a 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -18,6 +18,7 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/klist.h>
 #include <linux/sysfs.h>
 #include <linux/compiler.h>
 #include <linux/spinlock.h>
@@ -58,7 +59,7 @@ enum kobject_action {
 
 struct kobject {
 	const char		*name;
-	struct list_head	entry;
+	struct klist_node	entry;
 	struct kobject		*parent;
 	struct kset		*kset;
 	struct kobj_type	*ktype;
@@ -152,7 +153,7 @@ extern struct sysfs_ops kobj_sysfs_ops;
  * desired.
  */
 struct kset {
-	struct list_head list;
+	struct klist list;
 	spinlock_t list_lock;
 	struct kobject kobj;
 	struct kset_uevent_ops *uevent_ops;
diff --git a/include/linux/klist.h b/include/linux/klist.h
index e91a4e5..274fa91 100644
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -64,5 +64,6 @@ extern void klist_iter_init_node(struct klist *k, struct klist_iter *i,
 				 struct klist_node *n);
 extern void klist_iter_exit(struct klist_iter *i);
 extern struct klist_node *klist_next(struct klist_iter *i);
+extern struct klist_node *klist_prev(struct klist_iter *i);
 
 #endif
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 07851e9..4ea25b0 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1726,15 +1726,24 @@ out:
 }
 EXPORT_SYMBOL_GPL(device_move);
 
+static struct device *klist_node_to_dev(struct klist_node *node)
+{
+	struct kobject *kobj = container_of(node, struct kobject, entry);
+	return container_of(kobj, struct device, kobj);
+}
+
 /**
  * device_shutdown - call ->shutdown() on each device to shutdown.
  */
 void device_shutdown(void)
 {
-	struct device *dev, *devn;
+	struct device *dev;
+	struct klist_iter iter;
+	struct klist_node *node;
 
-	list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
-				kobj.entry) {
+	klist_iter_init(&devices_kset->list, &iter);
+	while ((node = klist_prev(&iter)) != NULL) {
+		dev = klist_node_to_dev(node);
 		if (dev->bus && dev->bus->shutdown) {
 			dev_dbg(dev, "shutdown\n");
 			dev->bus->shutdown(dev);
@@ -1743,6 +1751,7 @@ retry:
 			dev_dbg(dev, "shutdown\n");
 			dev->driver->shutdown(dev);
 		}
 	}
+	klist_iter_exit(&iter);
 	async_synchronize_full();
 }
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 0d90390..5d77600 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -160,6 +160,30 @@ EXPORT_SYMBOL_GPL(sysdev_class_unregister);
 
 static DEFINE_MUTEX(sysdev_drivers_lock);
 
+static struct sysdev_class *sysdev_next_class(struct klist_iter *iter)
+{
+	struct klist_node *node = klist_next(iter);
+	return node
+		? container_of(node, struct sysdev_class, kset.kobj.entry)
+		: NULL;
+}
+
+static struct sysdev_class *sysdev_prev_class(struct klist_iter *iter)
+{
+	struct klist_node *node = klist_prev(iter);
+	return node
+		? container_of(node, struct sysdev_class, kset.kobj.entry)
+		: NULL;
+}
+
+static struct sys_device *sysdev_next_sysdev(struct klist_iter *iter)
+{
+	struct klist_node *node = klist_prev(iter);
+	return node
+		? container_of(node, struct sys_device, kobj.entry)
+		: NULL;
+}
+
 /**
  *	sysdev_driver_register - Register auxillary driver
  *	@cls:	Device class driver belongs to.
@@ -193,8 +217,12 @@ int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
 		/* If devices of this class already exist, tell the driver */
 		if (drv->add) {
 			struct sys_device *dev;
-			list_for_each_entry(dev, &cls->kset.list, kobj.entry)
+			struct klist_iter device_iter;
+
+			klist_iter_init(&cls->kset.list, &device_iter);
+			while ((dev = sysdev_next_sysdev(&device_iter)) != NULL)
 				drv->add(dev);
+			klist_iter_exit(&device_iter);
 		}
 	} else {
 		err = -EINVAL;
@@ -218,8 +246,12 @@ void sysdev_driver_unregister(struct sysdev_class *cls,
 	if (cls) {
 		if (drv->remove) {
 			struct sys_device *dev;
-			list_for_each_entry(dev, &cls->kset.list, kobj.entry)
+			struct klist_iter device_iter;
+
+			klist_iter_init(&cls->kset.list, &device_iter);
+			while ((dev = sysdev_next_sysdev(&device_iter)) != NULL)
 				drv->remove(dev);
+			klist_iter_exit(&device_iter);
 		}
 		kset_put(&cls->kset);
 	}
@@ -312,18 +344,23 @@ void sysdev_unregister(struct sys_device *sysdev)
  */
 void sysdev_shutdown(void)
 {
+	struct klist_iter class_iter;
 	struct sysdev_class *cls;
 
 	pr_debug("Shutting Down System Devices\n");
 
 	mutex_lock(&sysdev_drivers_lock);
-	list_for_each_entry_reverse(cls, &system_kset->list, kset.kobj.entry) {
+
+	klist_iter_init(&system_kset->list, &class_iter);
+	while ((cls = sysdev_prev_class(&class_iter)) != NULL) {
+		struct klist_iter device_iter;
 		struct sys_device *sysdev;
 
 		pr_debug("Shutting down type '%s':\n",
 			 kobject_name(&cls->kset.kobj));
 
-		list_for_each_entry(sysdev, &cls->kset.list, kobj.entry) {
+		klist_iter_init(&cls->kset.list, &device_iter);
+		while ((sysdev = sysdev_next_sysdev(&device_iter)) != NULL) {
 			struct sysdev_driver *drv;
 			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
 
@@ -337,7 +374,9 @@ void sysdev_shutdown(void)
 			if (cls->shutdown)
 				cls->shutdown(sysdev);
 		}
+		klist_iter_exit(&device_iter);
 	}
+	klist_iter_exit(&class_iter);
 	mutex_unlock(&sysdev_drivers_lock);
 }
 
@@ -375,6 +414,9 @@ static void __sysdev_resume(struct sys_device *dev)
  */
 int sysdev_suspend(pm_message_t state)
 {
+	struct klist_iter class_iter;
+	struct klist_iter device_iter;
+	struct klist_iter err_device_iter;
 	struct sysdev_class *cls;
 	struct sys_device *sysdev, *err_dev;
 	struct sysdev_driver *drv, *err_drv;
@@ -392,15 +434,17 @@ int sysdev_suspend(pm_message_t state)
 
 	pr_debug("Suspending System Devices\n");
 
-	list_for_each_entry_reverse(cls, &system_kset->list, kset.kobj.entry) {
+	klist_iter_init(&system_kset->list, &class_iter);
+	while ((cls = sysdev_prev_class(&class_iter)) != NULL) {
 		pr_debug("Suspending type '%s':\n",
 			 kobject_name(&cls->kset.kobj));
 
-		list_for_each_entry(sysdev, &cls->kset.list, kobj.entry) {
+		klist_iter_init(&cls->kset.list, &device_iter);
+		while ((sysdev = sysdev_next_sysdev(&device_iter)) != NULL) {
 			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
 
 			/* Call auxillary drivers first */
-			list_for_each_entry(drv, &cls->drivers, entry) {
+			list_for_each_entry (drv, &cls->drivers, entry) {
 				if (drv->suspend) {
 					ret = drv->suspend(sysdev, state);
 					if (ret)
@@ -421,7 +465,9 @@ int sysdev_suspend(pm_message_t state)
 					cls->suspend);
 			}
 		}
+		klist_iter_exit(&device_iter);
 	}
+	klist_iter_exit(&class_iter);
 	return 0;
 	/* resume current sysdev */
 cls_driver:
@@ -441,20 +487,26 @@ aux_driver:
 	}
 
 	/* resume other sysdevs in current class */
-	list_for_each_entry(err_dev, &cls->kset.list, kobj.entry) {
+	klist_iter_init(&cls->kset.list, &err_device_iter);
+	while ((err_dev = sysdev_next_sysdev(&err_device_iter)) != NULL) {
 		if (err_dev == sysdev)
 			break;
 		pr_debug(" %s\n", kobject_name(&err_dev->kobj));
 		__sysdev_resume(err_dev);
 	}
+	klist_iter_exit(&err_device_iter);
 
 	/* resume other classes */
-	list_for_each_entry_continue(cls, &system_kset->list, kset.kobj.entry) {
-		list_for_each_entry(err_dev, &cls->kset.list, kobj.entry) {
+	while ((cls = sysdev_next_class(&class_iter)) != NULL) {
+		klist_iter_init(&cls->kset.list, &err_device_iter);
+		while ((err_dev = sysdev_next_sysdev(&err_device_iter))) {
 			pr_debug(" %s\n", kobject_name(&err_dev->kobj));
 			__sysdev_resume(err_dev);
 		}
+		klist_iter_exit(&err_device_iter);
 	}
+	klist_iter_exit(&device_iter);
+	klist_iter_exit(&class_iter);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(sysdev_suspend);
@@ -469,6 +521,8 @@ EXPORT_SYMBOL_GPL(sysdev_suspend);
  */
 int sysdev_resume(void)
 {
+	struct klist_iter class_iter;
+	struct klist_iter device_iter;
 	struct sysdev_class *cls;
 
 	WARN_ONCE(!irqs_disabled(),
@@ -476,18 +530,21 @@ int sysdev_resume(void)
 
 	pr_debug("Resuming System Devices\n");
 
-	list_for_each_entry(cls, &system_kset->list, kset.kobj.entry) {
+	while ((cls = sysdev_next_class(&class_iter)) != NULL) {
 		struct sys_device *sysdev;
 
 		pr_debug("Resuming type '%s':\n",
 			 kobject_name(&cls->kset.kobj));
 
-		list_for_each_entry(sysdev, &cls->kset.list, kobj.entry) {
+		klist_iter_init(&cls->kset.list, &device_iter);
+		while ((sysdev = sysdev_next_sysdev(&device_iter)) != NULL) {
 			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
 
 			__sysdev_resume(sysdev);
 		}
+		klist_iter_exit(&device_iter);
 	}
+	klist_iter_exit(&class_iter);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sysdev_resume);
diff --git a/lib/klist.c b/lib/klist.c
index 573d606..fcb19c8 100644
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -363,3 +363,44 @@ struct klist_node *klist_next(struct klist_iter *i)
 	return i->i_cur;
 }
 EXPORT_SYMBOL_GPL(klist_next);
+
+/**
+ * klist_prev - Ante up next previous in list.
+ * @i: Iterator structure.
+ *
+ * First grab list lock. Decrement the reference count of the last iterated
+ * node, if there was one. Grab the previous node, increment its reference
+ * count, drop the lock, and return that previous node.
+ */
+struct klist_node *klist_prev(struct klist_iter *i)
+{
+	void (*put)(struct klist_node *) = i->i_klist->put;
+	struct klist_node *last = i->i_cur;
+	struct klist_node *prev;
+
+	spin_lock(&i->i_klist->k_lock);
+
+	if (last) {
+		prev = to_klist_node(last->n_node.prev);
+		if (!klist_dec_and_del(last))
+			put = NULL;
+	} else
+		prev = to_klist_node(i->i_klist->k_list.prev);
+
+	i->i_cur = NULL;
+	while (prev != to_klist_node(&i->i_klist->k_list)) {
+		if (likely(!knode_dead(prev))) {
+			kref_get(&prev->n_ref);
+			i->i_cur = prev;
+			break;
+		}
+		prev = to_klist_node(prev->n_node.prev);
+	}
+
+	spin_unlock(&i->i_klist->k_lock);
+
+	if (put && last)
+		put(last);
+	return i->i_cur;
+}
+EXPORT_SYMBOL_GPL(klist_prev);
diff --git a/lib/kobject.c b/lib/kobject.c
index b512b74..96808c3 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -126,7 +126,7 @@ static void kobj_kset_join(struct kobject *kobj)
 
 	kset_get(kobj->kset);
 	spin_lock(&kobj->kset->list_lock);
-	list_add_tail(&kobj->entry, &kobj->kset->list);
+	klist_add_tail(&kobj->entry, &kobj->kset->list);
 	spin_unlock(&kobj->kset->list_lock);
 }
 
@@ -137,7 +137,7 @@ static void kobj_kset_leave(struct kobject *kobj)
 		return;
 
 	spin_lock(&kobj->kset->list_lock);
-	list_del_init(&kobj->entry);
+	klist_del(&kobj->entry);
 	spin_unlock(&kobj->kset->list_lock);
 	kset_put(kobj->kset);
 }
@@ -147,7 +147,6 @@ static void kobject_init_internal(struct kobject *kobj)
 	if (!kobj)
 		return;
 	kref_init(&kobj->kref);
-	INIT_LIST_HEAD(&kobj->entry);
 	kobj->state_in_sysfs = 0;
 	kobj->state_add_uevent_sent = 0;
 	kobj->state_remove_uevent_sent = 0;
@@ -671,7 +670,7 @@ EXPORT_SYMBOL_GPL(kobject_create_and_add);
 void kset_init(struct kset *k)
 {
 	kobject_init_internal(&k->kobj);
-	INIT_LIST_HEAD(&k->list);
+	klist_init(&k->list, NULL, NULL);
 	spin_lock_init(&k->list_lock);
 }
 
@@ -735,6 +734,14 @@ void kset_unregister(struct kset *k)
 	kobject_put(&k->kobj);
 }
 
+static struct kobject *kset_next_kobject(struct klist_iter *iter)
+{
+	struct klist_node *node = klist_next(iter);
+	return node
+		? container_of(node, struct kobject, entry)
+		: NULL;
+}
+
 /**
  * kset_find_obj - search for object in kset.
  * @kset: kset we're looking in.
@@ -746,17 +753,18 @@ void kset_unregister(struct kset *k)
  */
 struct kobject *kset_find_obj(struct kset *kset, const char *name)
 {
+	struct klist_iter i;
 	struct kobject *k;
 	struct kobject *ret = NULL;
 
-	spin_lock(&kset->list_lock);
-	list_for_each_entry(k, &kset->list, entry) {
+	klist_iter_init(&kset->list, &i);
+	while ((k = kset_next_kobject(&i))) {
 		if (kobject_name(k) && !strcmp(kobject_name(k), name)) {
 			ret = kobject_get(k);
 			break;
 		}
 	}
-	spin_unlock(&kset->list_lock);
+	klist_iter_exit(&i);
 	return ret;
 }
 
