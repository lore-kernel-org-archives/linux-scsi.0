From: "Adam J. Richter" <adam@yggdrasil.com>
Subject: Untested port of parisc_device to generic device interface
Date: Fri, 8 Nov 2002 17:28:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211090128.RAA31693@adam.yggdrasil.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: andmike@us.ibm.com, hch@lst.de, parisc-linux@lists.parisc-linux.org

James Bottomley wrote:
>A full abstraction would require the sync point functions that the 53c700 uses
>so that they can optimize away on unnecessary architectures.

	For the moment, I've added the following inline routine to
my linux/dma-ops.h in my generic DMA mapping patch.  I haven't even
tried to compile it, but you should get the picture.

extern void (*_wback_fake_consistent)(void *vaddr, int len);
static inline void wback_fake_consistent(void *vaddr, int len)
{
#ifdef DMA_CONSISTENT_IS_FAKE
	(*_wback_fake_consistent)(vaddr, len);
#endif
}

	The parisc initialization can set _wback_fake_consistent to
either a no-op or dma_cache_wback depending on the architecture that
it is booted on.

>If you're
>signing up to do this right, then I can try it out in the 53c700.  I still
>have two parisc machines, one which cannot do consistent allocations and one
>which can.

	I'll sign up to try if you'll help me, and, most importantly,
to me, get it shepherded into Linus's tree promptly once it looks good.

	To start with, here is another completely untested patch that
I haven't even tried to compile that attempts to port the parisc device
type to the generic device model.  I have deliberately not included any
changes that would make it dependent on my generic DMA routine facility.

	If we could get this patch working, "blessed" as needed,
and into Linus's releases, then I think that would simplify adding
a fake_dma_consistent mechanism that the drivers/net/lasi_82596.c
and drivers/scsi/{lasi700,53c700,etc.}.c could use.

	I think it would be much easier to get this patch integrated
first, as that the next step will probably rely heavily on it.

	One question about the machine that has no consistent memory
option: does it take PCI cards?  If so, then all PCI device drivers
should theoretically use something like wback_fake_consistent.
If not, then it sounds like the facility needs only to apply to
generic DMA operations for "parisc" bus cards.

	I've added parisc-linux@lists.parisc-linux.org to the
cc list and plan to drop linux-scsi from this tangent in my subsequent
responses.

Adam J. Richter     __     ______________   575 Oroville Road
adam@yggdrasil.com     \ /                  Milpitas, California 95035
+1 408 309-6081         | g g d r a s i l   United States of America
                         "Free Software For The Rest Of Us."



diff -u -r linux-2.5.46/include/asm-parisc/hardware.h linux/include/asm-parisc/hardware.h
--- linux-2.5.46/include/asm-parisc/hardware.h	Wed Oct 30 21:32:15 2002
+++ linux/include/asm-parisc/hardware.h	Fri Nov  8 01:49:09 2002
@@ -1,6 +1,7 @@
 #ifndef _PARISC_HARDWARE_H
 #define _PARISC_HARDWARE_H
 
+#include <linux/device.h>
 #include <asm/pdc.h>
 
 struct parisc_device_id {
@@ -26,14 +27,10 @@
 struct parisc_device {
 	unsigned long   hpa;		/* Hard Physical Address */
 	struct parisc_device_id id;
-	struct parisc_device *parent;
-	struct parisc_device *sibling;
-	struct parisc_device *child;
-	struct parisc_driver *driver;	/* Driver for this device */
-	void		*sysdata;	/* Driver instance private data */
 	char		name[80];	/* The hardware description */
 	int		irq;
 
+	struct device	device;
 	char		hw_path;        /* The module number on this bus */
 	unsigned int	num_addrs;	/* some devices have additional address ranges. */
 	unsigned long	*addr;          /* which will be stored here */
@@ -66,10 +63,10 @@
 extern char *cpu_name_version[][2]; /* mapping from enum cpu_type to strings */
 
 struct parisc_driver {
-	struct parisc_driver *next;
 	char *name; 
 	const struct parisc_device_id *id_table;
 	int (*probe) (struct parisc_device *dev); /* New device discovered */
+	struct device_driver driver;
 };
 
 struct io_module {
@@ -128,6 +125,26 @@
 #define HPHW_FAULTY    31
 
 
+static inline struct parisc_device *to_parisc_dev(struct device *dev)
+{
+	return container_of(dev, struct parisc_device, device);
+}
+
+static inline struct parisc_driver *to_parisc_drv(struct driver *dev)
+{
+	return container_of(drv, struct parisc_driver, driver);
+}
+
+static inline void *parisc_get_drvdata(struct parisc_device *pa_dev)
+{
+	return dev_get_drvdata(pa_dev->device);
+}
+
+static inline void parisc_set_drvdata(struct parisc_device *pa_dev, void *ptr)
+{
+	dev_set_drvdata(pa_dev->device, ptr);
+}
+
 /* hardware.c: */
 extern const char *parisc_hardware_description(struct parisc_device_id *id);
 extern enum cpu_type parisc_get_cpu_type(unsigned long hversion);
@@ -135,12 +152,13 @@
 struct pci_dev;
 
 /* drivers.c: */
+extern struct bus_type parisc_bus_type;
 extern struct parisc_device *alloc_pa_dev(unsigned long hpa,
 		struct hardware_path *path);
 extern int register_parisc_device(struct parisc_device *dev);
 extern int register_parisc_driver(struct parisc_driver *driver);
 extern int count_parisc_driver(struct parisc_driver *driver);
-extern int unregister_parisc_driver(struct parisc_driver *driver);
+extern void unregister_parisc_driver(struct parisc_driver *driver);
 extern void walk_central_bus(void);
 extern void fixup_child_irqs(struct parisc_device *parent, int irqbase,
 		int (*choose)(struct parisc_device *parent));
diff -u -r linux-2.5.46/arch/parisc/kernel/drivers.c linux/arch/parisc/kernel/drivers.c
--- linux-2.5.46/arch/parisc/kernel/drivers.c	Mon Nov  4 21:35:43 2002
+++ linux/arch/parisc/kernel/drivers.c	Fri Nov  8 02:05:25 2002
@@ -27,17 +27,8 @@
 /* See comments in include/asm-parisc/pci.h */
 struct pci_dma_ops *hppa_dma_ops;
 
-static struct parisc_driver *pa_drivers;
 static struct parisc_device root;
 
-/* This lock protects the pa_drivers list _only_ since all parisc_devices
- * are registered before smp_init() is called.  If you wish to add devices
- * after that, this muct be serialised somehow.  I recommend a semaphore
- * rather than a spinlock since driver ->probe functions are allowed to
- * sleep (for example when allocating memory).
- */
-static spinlock_t pa_lock = SPIN_LOCK_UNLOCKED;
-
 #define for_each_padev(dev) \
 	for (dev = root.child; dev != NULL; dev = next_dev(dev))
 
@@ -53,20 +44,13 @@
  */
 struct parisc_device *next_dev(struct parisc_device *dev)
 {
-	if (dev->child) {
-		return check_dev(dev->child);
-	} else if (dev->sibling) {
-		return dev->sibling;
-	}
+	struct device *next =
+		list_entry(dev->device.next, struct device, g_list);
 
-	/* Exhausted tree at this level, time to go up. */
-	do {
-		dev = dev->parent;
-		if (dev && dev->sibling)
-			return dev->sibling;
-	} while (dev != &root);
-
-	return NULL;
+	if (next->parent == NULL) /* end of list.  back at root */
+		return NULL;
+	else
+		return container_of(next, struct parisc_device, device);
 }
 
 /**
@@ -74,8 +58,11 @@
  * @driver: the PA-RISC driver to try
  * @dev: the PA-RISC device to try
  */
-static int match_device(struct parisc_driver *driver, struct parisc_device *dev)
+static int
+parisc_match_device(struct device_driver *gendrv, struct device *gendev)
 {
+	struct parisc_driver *driver = to_parisc_driver(gendrv);
+	struct parisc_device *dev = to_parisc_device(gendev);
 	const struct parisc_device_id *ids;
 
 	for (ids = driver->id_table; ids->sversion; ids++) {
@@ -96,10 +83,14 @@
 	return 0;
 }
 
-static void claim_device(struct parisc_driver *driver, struct parisc_device *dev)
+static int parisc_device_probe(struct device *dev)
 {
-	dev->driver = driver;
-	request_mem_region(dev->hpa, 0x1000, driver->name);
+	struct parisc_device *pa_dev = to_parisc_device(dev);
+	struct parisc_driver *pa_drv = to_parisc_driver(dev->driver);
+	int err = (*pa_drv->probe)(pa_dev);
+	if (!err)
+		request_mem_region(dev->hpa, 0x1000, driver->name);
+	return err;
 }
 
 /**
@@ -108,37 +99,22 @@
  */
 int register_parisc_driver(struct parisc_driver *driver)
 {
-	struct parisc_device *device;
-
-	if (driver->next) {
-		printk(KERN_WARNING 
-		       "BUG: Skipping previously registered driver: %s\n",
-		       driver->name);
-		return 1;
-	}
-
-	for_each_padev(device) {
-		if (device->driver)
-			continue;
-		if (!match_device(driver, device))
-			continue;
-
-		if (driver->probe(device) < 0)
-			continue;
-		claim_device(driver, device);
-	}
+	driver->driver.bus_type = &parisc_bus_type;
+	driver->driver.probe = parisc_device_probe;
+	return driver_register(&driver->driver);
+}
 
-	/* Note that the list is in reverse order of registration.  This
-	 * may be significant if we ever actually support hotplug and have
-	 * multiple drivers capable of claiming the same chip.
-	 */
-
-	spin_lock(&pa_lock);
-	driver->next = pa_drivers;
-	pa_drivers = driver;
-	spin_unlock(&pa_lock);
+struct count_arg {
+	struct driver *driver;
+	int count;
+};
 
-	return 0;
+static void count_callback(struct device *dev, void *data)
+{
+	struct count_arg *arg = data;
+	
+	if (parisc_match_device(&arg->driver, dev))
+		(arg->count)++;
 }
 
 /**
@@ -148,17 +124,14 @@
  * Use by IOMMU support to "guess" the right size IOPdir.
  * Formula is something like memsize/(num_iommu * entry_size).
  */
-int count_parisc_driver(struct parisc_driver *driver)
+int count_parisc_driver(struct parisc_driver *pa_driver)
 {
-	struct parisc_device *device;
-	int cnt = 0;
-
-	for_each_padev(device) {
-		if (match_device(driver, device))
-			cnt++;
-	}
-
-	return cnt;
+	struct count_arg arg;
+  
+	arg.driver = &pa_driver->driver;
+	arg.count = 0;
+	bus_for_each_dev(arg.driver->bus, &arg, count_callback);
+	return arg.count;
 }
 
 
@@ -167,42 +140,9 @@
  * unregister_parisc_driver - Unregister this driver from the list of drivers
  * @driver: the PA-RISC driver to unregister
  */
-int unregister_parisc_driver(struct parisc_driver *driver)
+void unregister_parisc_driver(struct parisc_driver *driver)
 {
-	struct parisc_device *dev;
-
-	spin_lock(&pa_lock);
-
-	if (pa_drivers == driver) {
-		/* was head of list - update head */
-		pa_drivers = driver->next;
-	} else {
-		struct parisc_driver *prev = pa_drivers;
-
-		while (prev && driver != prev->next) {
-			prev = prev->next;
-		}
-
-		if (!prev) {
-			printk(KERN_WARNING "unregister_parisc_driver: %s wasn't registered\n", driver->name);
-		} else {
-			/* Drop driver from list */
-			prev->next = driver->next;
-			driver->next = NULL;
-		}
-
-	}
-
-	spin_unlock(&pa_lock);
-
-	for_each_padev(dev) {
-		if (dev->driver != driver)
-			continue;
-		dev->driver = NULL;
-		release_mem_region(dev->hpa, 0x1000);
-	}
-
-	return 0;
+	driver_unregister(&driver->driver);
 }
 
 static struct parisc_device *find_device_by_addr(unsigned long hpa)
@@ -335,7 +275,8 @@
 	memset(dev, 0, sizeof(*dev));
 	dev->hw_path = id;
 	dev->id.hw_type = HPHW_FAULTY;
-	dev->parent = parent;
+	dev->device.bus_type = &parisc_bus_type;
+	dev->device.parent = &parent->device;
 	dev->sibling = *insert;
 	*insert = dev;
 	return dev;
@@ -429,32 +370,11 @@
  *
  * Search the driver list for a driver that is willing to manage
  * this device.
+ * WARNING: This routine now returns 0 on success. --Adam J. Richter 2002.11.08
  */
 int register_parisc_device(struct parisc_device *dev)
 {
-	struct parisc_driver *driver;
-
-	if (!dev)
-		return 0;
-
-	if (dev->driver)
-		return 1;
-	
-	spin_lock(&pa_lock);
-
-	/* Locate a driver which agrees to manage this device.  */
-	for (driver = pa_drivers; driver; driver = driver->next) {
-		if (!match_device(driver,dev))
-			continue;
-		if (driver->probe(dev) == 0)
-			break;
-	}
-
-	if (driver != NULL) {
-		claim_device(driver, dev);
-	}
-	spin_unlock(&pa_lock);
-	return driver != NULL;
+	return device_register(&dev->device);
 }
 
 #define BC_PORT_MASK 0x8
@@ -588,3 +508,8 @@
 		print_parisc_device(dev);
 	}
 }
+
+struct bus_type parisc_bus_type = {
+	.name =		"parisc",
+	.match =	parisc_match_device,
+};
diff -u -r linux-2.5.46/arch/parisc/kernel/processor.c linux/arch/parisc/kernel/processor.c
--- linux-2.5.46/arch/parisc/kernel/processor.c	Mon Nov  4 21:35:44 2002
+++ linux/arch/parisc/kernel/processor.c	Fri Nov  8 01:00:32 2002
@@ -370,9 +370,9 @@
 };
 
 static struct parisc_driver cpu_driver = {
-	name:		"CPU",
-	id_table:	processor_tbl,
-	probe:		processor_probe
+	.name =		"CPU",
+	.id_table =	processor_tbl,
+	.probe =	processor_probe
 };
 
 /**
diff -u -r linux-2.5.46/drivers/parisc/sba_iommu.c linux/drivers/parisc/sba_iommu.c
--- linux-2.5.46/drivers/parisc/sba_iommu.c	Fri Nov  8 01:28:15 2002
+++ linux/drivers/parisc/sba_iommu.c	Fri Nov  8 01:43:35 2002
@@ -1988,7 +1988,7 @@
 		return(1);
 	}
 
-	dev->sysdata = (void *) sba_dev;
+	parisc_set_drvdata(dev, sba_dev);
 	memset(sba_dev, 0, sizeof(struct sba_device));
 
 	for(i=0; i<MAX_IOC; i++)
@@ -2041,7 +2041,7 @@
  */
 void * sba_get_iommu(struct parisc_device *pci_hba)
 {
-	struct sba_device *sba = (struct sba_device *) pci_hba->parent->sysdata;
+	struct sba_device *sba = parisc_get_drvdata(pci_hba->parent);
 	char t = pci_hba->parent->id.hw_type;
 	int iocnum = (pci_hba->hw_path >> 3);	/* rope # */
 
