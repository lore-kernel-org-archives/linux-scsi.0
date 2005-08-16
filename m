From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [RFC] embryonic RAID class
Date: Tue, 16 Aug 2005 18:27:34 -0500
Message-ID: <1124234854.8419.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:46047 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750736AbVHPX1g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Aug 2005 19:27:36 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j7GNRZA20572
	for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2005 19:27:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

The idea behind a RAID class is to provide a uniform interface to all
RAID subsystems (both hardware and software) in the kernel.

To do that, I've made this class a transport class that's entirely
subsystem independent (although the matching routines have to match per
subsystem, as you'll see looking at the code).  I put it in the scsi
subdirectory purely because I needed somewhere to play with it, but it's
not a scsi specific module.

I used a fusion raid card as the test bed for this; with that kind of
card, this is the type of class output you get:

jejb@titanic> ls -l /sys/class/raid_devices/20\:0\:0\:0/
total 0
lrwxrwxrwx  1 root root     0 Aug 16 17:21 component-0 -> ../../../devices/pci0000:80/0000:80:04.0/host20/target20:1:0/20:1:0:0/
lrwxrwxrwx  1 root root     0 Aug 16 17:21 component-1 -> ../../../devices/pci0000:80/0000:80:04.0/host20/target20:1:1/20:1:1:0/
lrwxrwxrwx  1 root root     0 Aug 16 17:21 device -> ../../../devices/pci0000:80/0000:80:04.0/host20/target20:0:0/20:0:0:0/
-r--r--r--  1 root root 16384 Aug 16 17:21 level
-r--r--r--  1 root root 16384 Aug 16 17:21 resync
-r--r--r--  1 root root 16384 Aug 16 17:21 state

So it's really simple: for a SCSI device representing a hardware raid,
it shows the raid level, the array state, the resync % complete (if the
state is resyncing) and the underlying components of the RAID (these are
exposed in fusion on the virtual channel 1).

As you can see, this type of information can be exported by almost
anything, including software raid.

The more difficult trick, of course, is going to be getting it to
perform configuration type actions with writable attributes.

James


diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1,5 +1,11 @@
 menu "SCSI device support"
 
+config RAID_ATTRS
+	tristate "RAID Transport Class"
+	default n
+	---help---
+	  Provides RAID
+
 config SCSI
 	tristate "SCSI device support"
 	---help---
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -22,6 +22,8 @@ subdir-$(CONFIG_PCMCIA)		+= pcmcia
 
 obj-$(CONFIG_SCSI)		+= scsi_mod.o
 
+obj-$(CONFIG_RAID_ATTRS)	+= raid_class.o
+
 # --- NOTE ORDERING HERE ---
 # For kernel non-modular link, transport attributes need to
 # be initialised before drivers
diff --git a/drivers/scsi/raid_class.c b/drivers/scsi/raid_class.c
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/raid_class.c
@@ -0,0 +1,250 @@
+/*
+ * RAID Attributes
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/raid_class.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+
+#define RAID_NUM_ATTRS	3
+
+struct raid_internal {
+	struct raid_template r;
+	struct raid_function_template *f;
+	/* The actual attributes */
+	struct class_device_attribute private_attrs[RAID_NUM_ATTRS];
+	/* The array of null terminated pointers to attributes 
+	 * needed by scsi_sysfs.c */
+	struct class_device_attribute *attrs[RAID_NUM_ATTRS + 1];
+};
+
+struct raid_component {
+	struct list_head node;
+	struct device *dev;
+	int num;
+};
+
+#define to_raid_internal(tmpl)	container_of(tmpl, struct raid_internal, r)
+
+#define tc_to_raid_internal(tcont) ({					\
+	struct raid_template *r =					\
+		container_of(tcont, struct raid_template, raid_attrs);	\
+	to_raid_internal(r);						\
+})
+
+#define ac_to_raid_internal(acont) ({					\
+	struct transport_container *tc =				\
+		container_of(acont, struct transport_container, ac);	\
+	tc_to_raid_internal(tc);					\
+})
+
+#define class_device_to_raid_internal(cdev) ({				\
+	struct attribute_container *ac =				\
+		attribute_container_classdev_to_container(cdev);	\
+	ac_to_raid_internal(ac);					\
+})
+	
+
+static int raid_match(struct attribute_container *cont, struct device *dev)
+{
+	/* We have to look for every subsystem that could house
+	 * emulated RAID devices, so start with SCSI */
+	struct raid_internal *i = ac_to_raid_internal(cont);
+
+	if (scsi_is_sdev_device(dev)) {
+		struct scsi_device *sdev = to_scsi_device(dev);
+
+		if (i->f->cookie != sdev->host->hostt)
+			return 0;
+
+		return i->f->is_raid(dev);
+	}
+	/* FIXME: look at other subsystems too */
+	return 0;
+}
+
+static int raid_setup(struct transport_container *tc, struct device *dev,
+		       struct class_device *cdev)
+{
+	struct raid_data *rd;
+
+	BUG_ON(class_get_devdata(cdev));
+
+	rd = kmalloc(sizeof(*rd), GFP_KERNEL);
+	if (!rd)
+		return -ENOMEM;
+
+	memset(rd, 0, sizeof(*rd));
+	INIT_LIST_HEAD(&rd->component_list);
+	class_set_devdata(cdev, rd);
+		
+	return 0;
+}
+
+static int raid_remove(struct transport_container *tc, struct device *dev,
+		       struct class_device *cdev)
+{
+	struct raid_data *rd = class_get_devdata(cdev);
+	struct raid_component *rc, *next;
+	class_set_devdata(cdev, NULL);
+	list_for_each_entry_safe(rc, next, &rd->component_list, node) {
+		char buf[40];
+		snprintf(buf, sizeof(buf), "component-%d", rc->num);
+		list_del(&rc->node);
+		sysfs_remove_link(&cdev->kobj, buf);
+		kfree(rc);
+	}
+	kfree(class_get_devdata(cdev));
+	return 0;
+}
+
+static DECLARE_TRANSPORT_CLASS(raid_class,
+			       "raid_devices",
+			       raid_setup,
+			       raid_remove,
+			       NULL);
+
+static struct {
+	enum raid_state	value;
+	char		*name;
+} raid_states[] = {
+	{ RAID_ACTIVE, "active" },
+	{ RAID_DEGRADED, "degraded" },
+	{ RAID_RESYNCING, "resyncing" },
+	{ RAID_OFFLINE, "offline" },
+};
+
+static const char *raid_state_name(enum raid_state state)
+{
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < sizeof(raid_states)/sizeof(raid_states[0]); i++) {
+		if (raid_states[i].value == state) {
+			name = raid_states[i].name;
+			break;
+		}
+	}
+	return name;
+}
+
+
+#define raid_attr_show_internal(attr, fmt, var, code)			\
+static ssize_t raid_show_##attr(struct class_device *cdev, char *buf)	\
+{									\
+	struct raid_data *rd = class_get_devdata(cdev);			\
+	code								\
+	return snprintf(buf, 20, #fmt "\n", var);			\
+}
+
+#define raid_attr_ro_states(attr, states, code)				\
+raid_attr_show_internal(attr, %s, name,					\
+	const char *name;						\
+	code								\
+	name = raid_##states##_name(rd->attr);				\
+)									\
+static CLASS_DEVICE_ATTR(attr, S_IRUGO, raid_show_##attr, NULL)
+
+
+#define raid_attr_ro_internal(attr, code)				\
+raid_attr_show_internal(attr, %d, rd->attr, code)			\
+static CLASS_DEVICE_ATTR(attr, S_IRUGO, raid_show_##attr, NULL)
+
+#define ATTR_CODE(attr)							\
+	struct raid_internal *i = class_device_to_raid_internal(cdev);	\
+	if (i->f->get_##attr)						\
+		i->f->get_##attr(cdev->dev);
+
+#define raid_attr_ro(attr)	raid_attr_ro_internal(attr, )
+#define raid_attr_ro_fn(attr)	raid_attr_ro_internal(attr, ATTR_CODE(attr))
+#define raid_attr_ro_state(attr)	raid_attr_ro_states(attr, attr, ATTR_CODE(attr))
+
+raid_attr_ro(level);
+raid_attr_ro_fn(resync);
+raid_attr_ro_state(state);
+
+void raid_component_add(struct raid_template *r,struct device *raid_dev,
+			struct device *component_dev)
+{
+	struct class_device *cdev =
+		attribute_container_find_class_device(&r->raid_attrs.ac,
+						      raid_dev);
+	struct raid_component *rc;
+	struct raid_data *rd = class_get_devdata(cdev);
+	char buf[40];
+
+	rc = kmalloc(sizeof(*rc), GFP_KERNEL);
+	if (!rc)
+		return;
+
+	INIT_LIST_HEAD(&rc->node);
+	rc->dev = component_dev;
+	rc->num = rd->component_count++;
+
+	snprintf(buf, sizeof(buf), "component-%d", rc->num);
+	list_add_tail(&rc->node, &rd->component_list);
+	sysfs_create_link(&cdev->kobj, &component_dev->kobj, buf);
+}
+EXPORT_SYMBOL(raid_component_add);
+
+struct raid_template *
+raid_class_attach(struct raid_function_template *ft)
+{
+	struct raid_internal *i = kmalloc(sizeof(struct raid_internal),
+					  GFP_KERNEL);
+	int count = 0;
+
+	if (unlikely(!i))
+		return NULL;
+
+	memset(i, 0, sizeof(*i));
+
+	i->f = ft;
+
+	i->r.raid_attrs.ac.class = &raid_class.class;
+	i->r.raid_attrs.ac.match = raid_match;
+	i->r.raid_attrs.ac.attrs = &i->attrs[0];
+
+	attribute_container_register(&i->r.raid_attrs.ac);
+
+	i->attrs[count++] = &class_device_attr_level;
+	i->attrs[count++] = &class_device_attr_resync;
+	i->attrs[count++] = &class_device_attr_state;
+
+	i->attrs[count] = NULL;
+	BUG_ON(count > RAID_NUM_ATTRS);
+
+	return &i->r;
+}
+EXPORT_SYMBOL(raid_class_attach);
+
+void
+raid_class_release(struct raid_template *r)
+{
+	struct raid_internal *i = to_raid_internal(r);
+
+	attribute_container_unregister(&i->r.raid_attrs.ac);
+
+	kfree(i);
+}
+EXPORT_SYMBOL(raid_class_release);
+
+static __init int raid_init(void)
+{
+	return transport_class_register(&raid_class);
+}
+
+static __exit void raid_exit(void)
+{
+	transport_class_unregister(&raid_class);
+}
+
+MODULE_AUTHOR("James Bottomley");
+MODULE_DESCRIPTION("RAID device class");
+MODULE_LICENSE("GPL");
+
+module_init(raid_init);
+module_exit(raid_exit);
+
diff --git a/include/linux/raid_class.h b/include/linux/raid_class.h
new file mode 100644
--- /dev/null
+++ b/include/linux/raid_class.h
@@ -0,0 +1,59 @@
+/*
+ */
+#include <linux/transport_class.h>
+
+struct raid_template {
+	struct transport_container raid_attrs;
+};
+
+struct raid_function_template {
+	void *cookie;
+	int (*is_raid)(struct device *);
+	void (*get_resync)(struct device *);
+	void (*get_state)(struct device *);
+};
+
+enum raid_state {
+	RAID_ACTIVE = 1,
+	RAID_DEGRADED,
+	RAID_RESYNCING,
+	RAID_OFFLINE,
+};
+
+struct raid_data {
+	struct list_head component_list;
+	int component_count;
+	int level;
+	enum raid_state state;
+	int resync;
+};
+
+#define DEFINE_RAID_ATTRIBUTE(type, attr)				      \
+static inline void							      \
+raid_set_##attr(struct raid_template *r, struct device *dev, type value) {    \
+	struct class_device *cdev =					      \
+		attribute_container_find_class_device(&r->raid_attrs.ac, dev);\
+	struct raid_data *rd;						      \
+	BUG_ON(!cdev);							      \
+	rd = class_get_devdata(cdev);					      \
+	rd->attr = value;						      \
+}									      \
+static inline type							      \
+raid_get_##attr(struct raid_template *r, struct device *dev) {		      \
+	struct class_device *cdev =					      \
+		attribute_container_find_class_device(&r->raid_attrs.ac, dev);\
+	struct raid_data *rd;						      \
+	BUG_ON(!cdev);							      \
+	rd = class_get_devdata(cdev);					      \
+	return rd->attr;						      \
+}
+
+DEFINE_RAID_ATTRIBUTE(int, level)
+DEFINE_RAID_ATTRIBUTE(int, resync)
+DEFINE_RAID_ATTRIBUTE(enum raid_state, state)
+	
+struct raid_template *raid_class_attach(struct raid_function_template *);
+void raid_class_release(struct raid_template *);
+
+void raid_component_add(struct raid_template *, struct device *,
+			struct device *);


