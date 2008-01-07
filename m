From: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Mon, 7 Jan 2008 10:09:44 +0800
Message-ID: <20080107020944.GA3637@darkstar.te-china.tietoenator.com>
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
	<478120D9.5090404@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <478120D9.5090404@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James.Bottomley@HansenPartnership.com, dbrownell@users.sourceforge.net, rtc-linux@googlegroups.com, linux-scsi@vger.kernel.org, a.zummo@towertech.it, peterz@infradead.org, gregkh@suse.de, linux-kernel@vger.kernel.org, david-b@pacbell.net, krh@redhat.com, stern@rowland.harvard.edu, cbou@mail.ru, spi-devel-general@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 06, 2008 at 07:41:29PM +0100, Stefan Richter wrote:
> Dave Young wrote:
> > Convert semaphore to mutex in struct class.
> > All the patches in this series should be applyed simultaneously
> 
> Therefore you eventually need to repost it as a single patch.  It can't
> go into one of the maintainer trees otherwise, because they only take
> fully bijectable patches.  (Kernel must build and run at any point in
> between any patch series.)
> 
> > toc:
> > ---
> > 1-driver-core-struct-class-convert-semaphore-to-mutex.patch
> > 2-i2c-struct-class-convert-semaphore-to-mutex.patch
> > 3-ieee1394-struct-class-convert-semaphore-to-mutex.patch
> > 4-power-struct-class-convert-semaphore-to-mutex.patch
> > 5-rtc-struct-class-convert-semaphore-to-mutex.patch
> > 6-scsi-struct-class-convert-semaphore-to-mutex.patch
> > 7-spi-struct-class-convert-semaphore-to-mutex.patch
> 
> I was going to test it at runtime on top of 2.6.24-rc6, but the first
> and second patch depend on stuff in -mm.  So, my laziness wins for now,
> as -mm is not my cup of tea.
> 
> About your changelog:
> 
> 	"xyz: convert semaphore to mutex in struct class
> 
> 	Use mutex instead of semaphore in struct class.
> 
> 	Signed-off-by: Dave Young <hidave.darkstar@gmail.com>"
> 
> You don't need the second line because it says the same as the first
> line.  Either kill it, or replace it by an explanation _why_ the
> semaphore is to be replaced by mutex.  (I guess you do it because they
> are lighter-weight, both in semantics and in implementation, and because
> there are better facilities to debug mutexes...)

Thanks for your comment, I rewrite it for 2.6.24-rc7 as a all-in-one patch, please see following. Drop i2c maintainer and list in cc because there's no changes about i2c in this patch:

Convert semaphore to mutex in struct class

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
drivers/base/class.c              |   22 ++++++++++----------
drivers/base/core.c               |   18 +++++++----------
drivers/ieee1394/nodemgr.c        |   40 +++++++++++++++++++-------------------
drivers/power/apm_power.c         |    6 ++---
drivers/power/power_supply_core.c |    8 +++----
drivers/rtc/interface.c           |    4 +--
drivers/scsi/hosts.c              |    4 +--
drivers/spi/spi.c                 |    4 +--
include/linux/device.h            |    3 +-
9 files changed, 54 insertions(+), 55 deletions(-)

diff -upr a/linux-2.6.24-rc7/drivers/base/class.c linux-2.6.24-rc7/drivers/base/class.c
--- a/linux-2.6.24-rc7/drivers/base/class.c	2008-01-07 08:56:05.000000000 +0800
+++ linux-2.6.24-rc7/drivers/base/class.c	2008-01-07 09:12:49.000000000 +0800
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
@@ -822,7 +822,7 @@ int class_interface_register(struct clas
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->add_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	return 0;
 }
@@ -836,7 +836,7 @@ void class_interface_unregister(struct c
 	if (!parent)
 		return;
 
-	down(&parent->sem);
+	mutex_lock(&parent->mutex);
 	list_del_init(&class_intf->node);
 	if (class_intf->remove) {
 		list_for_each_entry(class_dev, &parent->children, node)
@@ -846,7 +846,7 @@ void class_interface_unregister(struct c
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->remove_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	class_put(parent);
 }
diff -upr a/linux-2.6.24-rc7/drivers/base/core.c linux-2.6.24-rc7/drivers/base/core.c
--- a/linux-2.6.24-rc7/drivers/base/core.c	2008-01-07 08:56:05.000000000 +0800
+++ linux-2.6.24-rc7/drivers/base/core.c	2008-01-07 09:39:11.000000000 +0800
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
diff -upr a/linux-2.6.24-rc7/drivers/ieee1394/nodemgr.c linux-2.6.24-rc7/drivers/ieee1394/nodemgr.c
--- a/linux-2.6.24-rc7/drivers/ieee1394/nodemgr.c	2008-01-07 08:56:06.000000000 +0800
+++ linux-2.6.24-rc7/drivers/ieee1394/nodemgr.c	2008-01-07 09:26:47.000000000 +0800
@@ -733,16 +733,16 @@ static void nodemgr_remove_uds(struct no
 	struct unit_directory *tmp, *ud;
 
 	/* Iteration over nodemgr_ud_class.devices has to be protected by
-	 * nodemgr_ud_class.sem, but device_unregister() will eventually
-	 * take nodemgr_ud_class.sem too. Therefore pick out one ud at a time,
-	 * release the semaphore, and then unregister the ud. Since this code
+	 * nodemgr_ud_class.mutex, but device_unregister() will eventually
+	 * take nodemgr_ud_class.mutex too. Therefore pick out one ud at a time,
+	 * unlock the mutex, and then unregister the ud. Since this code
 	 * may be called from other contexts besides the knodemgrds, protect the
-	 * gap after release of the semaphore by nodemgr_serialize_remove_uds.
+	 * gap after unlock of the mutex by nodemgr_serialize_remove_uds.
 	 */
 	mutex_lock(&nodemgr_serialize_remove_uds);
 	for (;;) {
 		ud = NULL;
-		down(&nodemgr_ud_class.sem);
+		mutex_lock(&nodemgr_ud_class.mutex);
 		list_for_each_entry(dev, &nodemgr_ud_class.devices, node) {
 			tmp = container_of(dev, struct unit_directory,
 					   unit_dev);
@@ -751,7 +751,7 @@ static void nodemgr_remove_uds(struct no
 				break;
 			}
 		}
-		up(&nodemgr_ud_class.sem);
+		mutex_unlock(&nodemgr_ud_class.mutex);
 		if (ud == NULL)
 			break;
 		device_unregister(&ud->unit_dev);
@@ -888,7 +888,7 @@ static struct node_entry *find_entry_by_
 	struct device *dev;
 	struct node_entry *ne, *ret_ne = NULL;
 
-	down(&nodemgr_ne_class.sem);
+	mutex_lock(&nodemgr_ne_class.mutex);
 	list_for_each_entry(dev, &nodemgr_ne_class.devices, node) {
 		ne = container_of(dev, struct node_entry, node_dev);
 
@@ -897,7 +897,7 @@ static struct node_entry *find_entry_by_
 			break;
 		}
 	}
-	up(&nodemgr_ne_class.sem);
+	mutex_unlock(&nodemgr_ne_class.mutex);
 
 	return ret_ne;
 }
@@ -909,7 +909,7 @@ static struct node_entry *find_entry_by_
 	struct device *dev;
 	struct node_entry *ne, *ret_ne = NULL;
 
-	down(&nodemgr_ne_class.sem);
+	mutex_lock(&nodemgr_ne_class.mutex);
 	list_for_each_entry(dev, &nodemgr_ne_class.devices, node) {
 		ne = container_of(dev, struct node_entry, node_dev);
 
@@ -918,7 +918,7 @@ static struct node_entry *find_entry_by_
 			break;
 		}
 	}
-	up(&nodemgr_ne_class.sem);
+	mutex_unlock(&nodemgr_ne_class.mutex);
 
 	return ret_ne;
 }
@@ -1384,7 +1384,7 @@ static void nodemgr_suspend_ne(struct no
 	ne->in_limbo = 1;
 	WARN_ON(device_create_file(&ne->device, &dev_attr_ne_in_limbo));
 
-	down(&nodemgr_ud_class.sem);
+	mutex_lock(&nodemgr_ud_class.mutex);
 	list_for_each_entry(dev, &nodemgr_ud_class.devices, node) {
 		ud = container_of(dev, struct unit_directory, unit_dev);
 		if (ud->ne != ne)
@@ -1404,7 +1404,7 @@ static void nodemgr_suspend_ne(struct no
 			device_release_driver(&ud->device);
 		put_driver(drv);
 	}
-	up(&nodemgr_ud_class.sem);
+	mutex_unlock(&nodemgr_ud_class.mutex);
 }
 
 
@@ -1417,7 +1417,7 @@ static void nodemgr_resume_ne(struct nod
 	ne->in_limbo = 0;
 	device_remove_file(&ne->device, &dev_attr_ne_in_limbo);
 
-	down(&nodemgr_ud_class.sem);
+	mutex_lock(&nodemgr_ud_class.mutex);
 	list_for_each_entry(dev, &nodemgr_ud_class.devices, node) {
 		ud = container_of(dev, struct unit_directory, unit_dev);
 		if (ud->ne != ne)
@@ -1434,7 +1434,7 @@ static void nodemgr_resume_ne(struct nod
 		}
 		put_driver(drv);
 	}
-	up(&nodemgr_ud_class.sem);
+	mutex_unlock(&nodemgr_ud_class.mutex);
 
 	HPSB_DEBUG("Node resumed: ID:BUS[" NODE_BUS_FMT "]  GUID[%016Lx]",
 		   NODE_BUS_ARGS(ne->host, ne->nodeid), (unsigned long long)ne->guid);
@@ -1449,7 +1449,7 @@ static void nodemgr_update_pdrv(struct n
 	struct hpsb_protocol_driver *pdrv;
 	int error;
 
-	down(&nodemgr_ud_class.sem);
+	mutex_lock(&nodemgr_ud_class.mutex);
 	list_for_each_entry(dev, &nodemgr_ud_class.devices, node) {
 		ud = container_of(dev, struct unit_directory, unit_dev);
 		if (ud->ne != ne)
@@ -1470,7 +1470,7 @@ static void nodemgr_update_pdrv(struct n
 			device_release_driver(&ud->device);
 		put_driver(drv);
 	}
-	up(&nodemgr_ud_class.sem);
+	mutex_unlock(&nodemgr_ud_class.mutex);
 }
 
 
@@ -1545,7 +1545,7 @@ static void nodemgr_node_probe(struct ho
 	 * while probes are time-consuming. (Well, those probes need some
 	 * improvement...) */
 
-	down(&nodemgr_ne_class.sem);
+	mutex_lock(&nodemgr_ne_class.mutex);
 	list_for_each_entry(dev, &nodemgr_ne_class.devices, node) {
 		ne = container_of(dev, struct node_entry, node_dev);
 		if (!ne->needs_probe)
@@ -1556,7 +1556,7 @@ static void nodemgr_node_probe(struct ho
 		if (ne->needs_probe)
 			nodemgr_probe_ne(hi, ne, generation);
 	}
-	up(&nodemgr_ne_class.sem);
+	mutex_unlock(&nodemgr_ne_class.mutex);
 
 
 	/* If we had a bus reset while we were scanning the bus, it is
@@ -1775,14 +1775,14 @@ int nodemgr_for_each_host(void *data, in
 	struct hpsb_host *host;
 	int error = 0;
 
-	down(&hpsb_host_class.sem);
+	mutex_lock(&hpsb_host_class.mutex);
 	list_for_each_entry(dev, &hpsb_host_class.devices, node) {
 		host = container_of(dev, struct hpsb_host, host_dev);
 
 		if ((error = cb(host, data)))
 			break;
 	}
-	up(&hpsb_host_class.sem);
+	mutex_unlock(&hpsb_host_class.mutex);
 
 	return error;
 }
diff -upr a/linux-2.6.24-rc7/drivers/power/apm_power.c linux-2.6.24-rc7/drivers/power/apm_power.c
--- a/linux-2.6.24-rc7/drivers/power/apm_power.c	2008-01-07 08:56:08.000000000 +0800
+++ linux-2.6.24-rc7/drivers/power/apm_power.c	2008-01-07 09:27:05.000000000 +0800
@@ -207,10 +207,10 @@ static void apm_battery_apm_get_power_st
 	union power_supply_propval status;
 	union power_supply_propval capacity, time_to_full, time_to_empty;
 
-	down(&power_supply_class->sem);
+	mutex_lock(&power_supply_class->mutex);
 	find_main_battery();
 	if (!main_battery) {
-		up(&power_supply_class->sem);
+		mutex_unlock(&power_supply_class->mutex);
 		return;
 	}
 
@@ -278,7 +278,7 @@ static void apm_battery_apm_get_power_st
 		}
 	}
 
-	up(&power_supply_class->sem);
+	mutex_unlock(&power_supply_class->mutex);
 }
 
 static int __init apm_battery_init(void)
diff -upr a/linux-2.6.24-rc7/drivers/power/power_supply_core.c linux-2.6.24-rc7/drivers/power/power_supply_core.c
--- a/linux-2.6.24-rc7/drivers/power/power_supply_core.c	2007-10-10 04:31:38.000000000 +0800
+++ linux-2.6.24-rc7/drivers/power/power_supply_core.c	2008-01-07 09:27:05.000000000 +0800
@@ -31,7 +31,7 @@ static void power_supply_changed_work(st
 	for (i = 0; i < psy->num_supplicants; i++) {
 		struct device *dev;
 
-		down(&power_supply_class->sem);
+		mutex_lock(&power_supply_class->mutex);
 		list_for_each_entry(dev, &power_supply_class->devices, node) {
 			struct power_supply *pst = dev_get_drvdata(dev);
 
@@ -40,7 +40,7 @@ static void power_supply_changed_work(st
 					pst->external_power_changed(pst);
 			}
 		}
-		up(&power_supply_class->sem);
+		mutex_unlock(&power_supply_class->mutex);
 	}
 
 	power_supply_update_leds(psy);
@@ -60,7 +60,7 @@ int power_supply_am_i_supplied(struct po
 	union power_supply_propval ret = {0,};
 	struct device *dev;
 
-	down(&power_supply_class->sem);
+	mutex_lock(&power_supply_class->mutex);
 	list_for_each_entry(dev, &power_supply_class->devices, node) {
 		struct power_supply *epsy = dev_get_drvdata(dev);
 		int i;
@@ -76,7 +76,7 @@ int power_supply_am_i_supplied(struct po
 		}
 	}
 out:
-	up(&power_supply_class->sem);
+	mutex_unlock(&power_supply_class->mutex);
 
 	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, ret.intval);
 
diff -upr a/linux-2.6.24-rc7/drivers/rtc/interface.c linux-2.6.24-rc7/drivers/rtc/interface.c
--- a/linux-2.6.24-rc7/drivers/rtc/interface.c	2008-01-07 08:56:08.000000000 +0800
+++ linux-2.6.24-rc7/drivers/rtc/interface.c	2008-01-07 09:27:11.000000000 +0800
@@ -256,7 +256,7 @@ struct rtc_device *rtc_class_open(char *
 	struct device *dev;
 	struct rtc_device *rtc = NULL;
 
-	down(&rtc_class->sem);
+	mutex_lock(&rtc_class->mutex);
 	list_for_each_entry(dev, &rtc_class->devices, node) {
 		if (strncmp(dev->bus_id, name, BUS_ID_SIZE) == 0) {
 			dev = get_device(dev);
@@ -272,7 +272,7 @@ struct rtc_device *rtc_class_open(char *
 			rtc = NULL;
 		}
 	}
-	up(&rtc_class->sem);
+	mutex_unlock(&rtc_class->mutex);
 
 	return rtc;
 }
diff -upr a/linux-2.6.24-rc7/drivers/scsi/hosts.c linux-2.6.24-rc7/drivers/scsi/hosts.c
--- a/linux-2.6.24-rc7/drivers/scsi/hosts.c	2008-01-07 08:56:09.000000000 +0800
+++ linux-2.6.24-rc7/drivers/scsi/hosts.c	2008-01-07 09:25:42.000000000 +0800
@@ -443,7 +443,7 @@ struct Scsi_Host *scsi_host_lookup(unsig
 	struct class_device *cdev;
 	struct Scsi_Host *shost = ERR_PTR(-ENXIO), *p;
 
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(cdev, &class->children, node) {
 		p = class_to_shost(cdev);
 		if (p->host_no == hostnum) {
@@ -451,7 +451,7 @@ struct Scsi_Host *scsi_host_lookup(unsig
 			break;
 		}
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return shost;
 }
diff -upr a/linux-2.6.24-rc7/drivers/spi/spi.c linux-2.6.24-rc7/drivers/spi/spi.c
--- a/linux-2.6.24-rc7/drivers/spi/spi.c	2008-01-07 08:56:09.000000000 +0800
+++ linux-2.6.24-rc7/drivers/spi/spi.c	2008-01-07 09:26:30.000000000 +0800
@@ -501,7 +501,7 @@ struct spi_master *spi_busnum_to_master(
 	struct spi_master	*master = NULL;
 	struct spi_master	*m;
 
-	down(&spi_master_class.sem);
+	mutex_lock(&spi_master_class.mutex);
 	list_for_each_entry(dev, &spi_master_class.children, node) {
 		m = container_of(dev, struct spi_master, dev);
 		if (m->bus_num == bus_num) {
@@ -509,7 +509,7 @@ struct spi_master *spi_busnum_to_master(
 			break;
 		}
 	}
-	up(&spi_master_class.sem);
+	mutex_unlock(&spi_master_class.mutex);
 	return master;
 }
 EXPORT_SYMBOL_GPL(spi_busnum_to_master);
diff -upr a/linux-2.6.24-rc7/include/linux/device.h linux-2.6.24-rc7/include/linux/device.h
--- a/linux-2.6.24-rc7/include/linux/device.h	2008-01-07 08:56:11.000000000 +0800
+++ linux-2.6.24-rc7/include/linux/device.h	2008-01-07 09:19:29.000000000 +0800
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
+	struct mutex		mutex;	/* locks both the children and interfaces lists */
 
 	struct class_attribute		* class_attrs;
 	struct class_device_attribute	* class_dev_attrs;

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
