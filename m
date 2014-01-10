From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH 5/9] PCI / hotplug: Use global PCI rescan-remove locking
Date: Fri, 10 Jan 2014 15:26:12 +0100
Message-ID: <1423879.kOD1JObQxJ@vostro.rjw.lan>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <1992931.Zv6xBcN8V4@vostro.rjw.lan> <20440867.YaQfKrcfsQ@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20440867.YaQfKrcfsQ@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>, Myron Stowe <myron.stowe@gmail.com>, Benjamin Herrenschmidt <benh@au1.ibm.com>, linux-scsi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Multiple race conditions are possible between PCI hotplug and the
generic PCI bus rescan and device removal that can be triggered via
sysfs.

To avoid those race conditions make PCI hotplug use global PCI
rescan-remove locking.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/cpci_hotplug_pci.c |   14 ++++++++++++--
 drivers/pci/hotplug/cpqphp_pci.c       |    8 +++++++-
 drivers/pci/hotplug/ibmphp_core.c      |   13 +++++++++++--
 drivers/pci/hotplug/pciehp_pci.c       |   17 +++++++++++++----
 drivers/pci/hotplug/rpadlpar_core.c    |   19 ++++++++++++++-----
 drivers/pci/hotplug/rpaphp_core.c      |    4 ++++
 drivers/pci/hotplug/s390_pci_hpc.c     |    4 +++-
 drivers/pci/hotplug/sgi_hotplug.c      |    5 +++++
 drivers/pci/hotplug/shpchp_pci.c       |   18 ++++++++++++++----
 9 files changed, 83 insertions(+), 19 deletions(-)

Index: linux-pm/drivers/pci/hotplug/rpadlpar_core.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/rpadlpar_core.c
+++ linux-pm/drivers/pci/hotplug/rpadlpar_core.c
@@ -354,10 +354,15 @@ int dlpar_remove_pci_slot(char *drc_name
 {
 	struct pci_bus *bus;
 	struct slot *slot;
+	int ret = 0;
+
+	pci_lock_rescan_remove();
 
 	bus = pcibios_find_pci_bus(dn);
-	if (!bus)
-		return -EINVAL;
+	if (!bus) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	pr_debug("PCI: Removing PCI slot below EADS bridge %s\n",
 		 bus->self ? pci_name(bus->self) : "<!PHB!>");
@@ -371,7 +376,8 @@ int dlpar_remove_pci_slot(char *drc_name
 			printk(KERN_ERR
 				"%s: unable to remove hotplug slot %s\n",
 				__func__, drc_name);
-			return -EIO;
+			ret = -EIO;
+			goto out;
 		}
 	}
 
@@ -382,7 +388,8 @@ int dlpar_remove_pci_slot(char *drc_name
 	if (pcibios_unmap_io_space(bus)) {
 		printk(KERN_ERR "%s: failed to unmap bus range\n",
 			__func__);
-		return -ERANGE;
+		ret = -ERANGE;
+		goto out;
 	}
 
 	/* Remove the EADS bridge device itself */
@@ -390,7 +397,9 @@ int dlpar_remove_pci_slot(char *drc_name
 	pr_debug("PCI: Now removing bridge device %s\n", pci_name(bus->self));
 	pci_stop_and_remove_bus_device(bus->self);
 
-	return 0;
+ out:
+	pci_unlock_rescan_remove();
+	return ret;
 }
 
 /**
Index: linux-pm/drivers/pci/hotplug/cpci_hotplug_pci.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/cpci_hotplug_pci.c
+++ linux-pm/drivers/pci/hotplug/cpci_hotplug_pci.c
@@ -254,9 +254,12 @@ int __ref cpci_configure_slot(struct slo
 {
 	struct pci_dev *dev;
 	struct pci_bus *parent;
+	int ret = 0;
 
 	dbg("%s - enter", __func__);
 
+	pci_lock_rescan_remove();
+
 	if (slot->dev == NULL) {
 		dbg("pci_dev null, finding %02x:%02x:%x",
 		    slot->bus->number, PCI_SLOT(slot->devfn), PCI_FUNC(slot->devfn));
@@ -277,7 +280,8 @@ int __ref cpci_configure_slot(struct slo
 		slot->dev = pci_get_slot(slot->bus, slot->devfn);
 		if (slot->dev == NULL) {
 			err("Could not find PCI device for slot %02x", slot->number);
-			return -ENODEV;
+			ret = -ENODEV;
+			goto out;
 		}
 	}
 	parent = slot->dev->bus;
@@ -294,8 +298,10 @@ int __ref cpci_configure_slot(struct slo
 
 	pci_bus_add_devices(parent);
 
+ out:
+	pci_unlock_rescan_remove();
 	dbg("%s - exit", __func__);
-	return 0;
+	return ret;
 }
 
 int cpci_unconfigure_slot(struct slot* slot)
@@ -308,6 +314,8 @@ int cpci_unconfigure_slot(struct slot* s
 		return -ENODEV;
 	}
 
+	pci_lock_rescan_remove();
+
 	list_for_each_entry_safe(dev, temp, &slot->bus->devices, bus_list) {
 		if (PCI_SLOT(dev->devfn) != PCI_SLOT(slot->devfn))
 			continue;
@@ -318,6 +326,8 @@ int cpci_unconfigure_slot(struct slot* s
 	pci_dev_put(slot->dev);
 	slot->dev = NULL;
 
+	pci_unlock_rescan_remove();
+
 	dbg("%s - exit", __func__);
 	return 0;
 }
Index: linux-pm/drivers/pci/hotplug/pciehp_pci.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/pciehp_pci.c
+++ linux-pm/drivers/pci/hotplug/pciehp_pci.c
@@ -39,22 +39,26 @@ int pciehp_configure_device(struct slot
 	struct pci_dev *dev;
 	struct pci_dev *bridge = p_slot->ctrl->pcie->port;
 	struct pci_bus *parent = bridge->subordinate;
-	int num;
+	int num, ret = 0;
 	struct controller *ctrl = p_slot->ctrl;
 
+	pci_lock_rescan_remove();
+
 	dev = pci_get_slot(parent, PCI_DEVFN(0, 0));
 	if (dev) {
 		ctrl_err(ctrl, "Device %s already exists "
 			 "at %04x:%02x:00, cannot hot-add\n", pci_name(dev),
 			 pci_domain_nr(parent), parent->number);
 		pci_dev_put(dev);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	num = pci_scan_slot(parent, PCI_DEVFN(0, 0));
 	if (num == 0) {
 		ctrl_err(ctrl, "No new device found\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	}
 
 	list_for_each_entry(dev, &parent->devices, bus_list)
@@ -73,7 +77,9 @@ int pciehp_configure_device(struct slot
 
 	pci_bus_add_devices(parent);
 
-	return 0;
+ out:
+	pci_unlock_rescan_remove();
+	return ret;
 }
 
 int pciehp_unconfigure_device(struct slot *p_slot)
@@ -92,6 +98,8 @@ int pciehp_unconfigure_device(struct slo
 	if (ret)
 		presence = 0;
 
+	pci_lock_rescan_remove();
+
 	/*
 	 * Stopping an SR-IOV PF device removes all the associated VFs,
 	 * which will update the bus->devices list and confuse the
@@ -126,5 +134,6 @@ int pciehp_unconfigure_device(struct slo
 		pci_dev_put(dev);
 	}
 
+	pci_unlock_rescan_remove();
 	return rc;
 }
Index: linux-pm/drivers/pci/hotplug/cpqphp_pci.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/cpqphp_pci.c
+++ linux-pm/drivers/pci/hotplug/cpqphp_pci.c
@@ -86,6 +86,8 @@ int cpqhp_configure_device (struct contr
 	struct pci_bus *child;
 	int num;
 
+	pci_lock_rescan_remove();
+
 	if (func->pci_dev == NULL)
 		func->pci_dev = pci_get_bus_and_slot(func->bus,PCI_DEVFN(func->device, func->function));
 
@@ -100,7 +102,7 @@ int cpqhp_configure_device (struct contr
 		func->pci_dev = pci_get_bus_and_slot(func->bus, PCI_DEVFN(func->device, func->function));
 		if (func->pci_dev == NULL) {
 			dbg("ERROR: pci_dev still null\n");
-			return 0;
+			goto out;
 		}
 	}
 
@@ -113,6 +115,8 @@ int cpqhp_configure_device (struct contr
 
 	pci_dev_put(func->pci_dev);
 
+ out:
+	pci_unlock_rescan_remove();
 	return 0;
 }
 
@@ -123,6 +127,7 @@ int cpqhp_unconfigure_device(struct pci_
 
 	dbg("%s: bus/dev/func = %x/%x/%x\n", __func__, func->bus, func->device, func->function);
 
+	pci_lock_rescan_remove();
 	for (j=0; j<8 ; j++) {
 		struct pci_dev* temp = pci_get_bus_and_slot(func->bus, PCI_DEVFN(func->device, j));
 		if (temp) {
@@ -130,6 +135,7 @@ int cpqhp_unconfigure_device(struct pci_
 			pci_stop_and_remove_bus_device(temp);
 		}
 	}
+	pci_unlock_rescan_remove();
 	return 0;
 }
 
Index: linux-pm/drivers/pci/hotplug/ibmphp_core.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/ibmphp_core.c
+++ linux-pm/drivers/pci/hotplug/ibmphp_core.c
@@ -718,6 +718,8 @@ static void ibm_unconfigure_device(struc
 					func->device, func->function);
 	debug("func->device << 3 | 0x0  = %x\n", func->device << 3 | 0x0);
 
+	pci_lock_rescan_remove();
+
 	for (j = 0; j < 0x08; j++) {
 		temp = pci_get_bus_and_slot(func->busno, (func->device << 3) | j);
 		if (temp) {
@@ -725,7 +727,10 @@ static void ibm_unconfigure_device(struc
 			pci_dev_put(temp);
 		}
 	}
+
 	pci_dev_put(func->dev);
+
+	pci_unlock_rescan_remove();
 }
 
 /*
@@ -780,6 +785,8 @@ static int ibm_configure_device(struct p
 	int flag = 0;	/* this is to make sure we don't double scan the bus,
 					for bridged devices primarily */
 
+	pci_lock_rescan_remove();
+
 	if (!(bus_structure_fixup(func->busno)))
 		flag = 1;
 	if (func->dev == NULL)
@@ -789,7 +796,7 @@ static int ibm_configure_device(struct p
 	if (func->dev == NULL) {
 		struct pci_bus *bus = pci_find_bus(0, func->busno);
 		if (!bus)
-			return 0;
+			goto out;
 
 		num = pci_scan_slot(bus,
 				PCI_DEVFN(func->device, func->function));
@@ -800,7 +807,7 @@ static int ibm_configure_device(struct p
 				PCI_DEVFN(func->device, func->function));
 		if (func->dev == NULL) {
 			err("ERROR... : pci_dev still NULL\n");
-			return 0;
+			goto out;
 		}
 	}
 	if (!(flag) && (func->dev->hdr_type == PCI_HEADER_TYPE_BRIDGE)) {
@@ -810,6 +817,8 @@ static int ibm_configure_device(struct p
 			pci_bus_add_devices(child);
 	}
 
+ out:
+	pci_unlock_rescan_remove();
 	return 0;
 }
 
Index: linux-pm/drivers/pci/hotplug/s390_pci_hpc.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/s390_pci_hpc.c
+++ linux-pm/drivers/pci/hotplug/s390_pci_hpc.c
@@ -80,7 +80,9 @@ static int enable_slot(struct hotplug_sl
 		goto out_deconfigure;
 
 	pci_scan_slot(slot->zdev->bus, ZPCI_DEVFN);
+	pci_lock_rescan_remove();
 	pci_bus_add_devices(slot->zdev->bus);
+	pci_unlock_rescan_remove();
 
 	return rc;
 
@@ -98,7 +100,7 @@ static int disable_slot(struct hotplug_s
 		return -EIO;
 
 	if (slot->zdev->pdev)
-		pci_stop_and_remove_bus_device(slot->zdev->pdev);
+		pci_stop_and_remove_bus_device_locked(slot->zdev->pdev);
 
 	rc = zpci_disable_device(slot->zdev);
 	if (rc)
Index: linux-pm/drivers/pci/hotplug/shpchp_pci.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/shpchp_pci.c
+++ linux-pm/drivers/pci/hotplug/shpchp_pci.c
@@ -40,7 +40,9 @@ int __ref shpchp_configure_device(struct
 	struct controller *ctrl = p_slot->ctrl;
 	struct pci_dev *bridge = ctrl->pci_dev;
 	struct pci_bus *parent = bridge->subordinate;
-	int num;
+	int num, ret = 0;
+
+	pci_lock_rescan_remove();
 
 	dev = pci_get_slot(parent, PCI_DEVFN(p_slot->device, 0));
 	if (dev) {
@@ -48,13 +50,15 @@ int __ref shpchp_configure_device(struct
 			 "at %04x:%02x:%02x, cannot hot-add\n", pci_name(dev),
 			 pci_domain_nr(parent), p_slot->bus, p_slot->device);
 		pci_dev_put(dev);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	num = pci_scan_slot(parent, PCI_DEVFN(p_slot->device, 0));
 	if (num == 0) {
 		ctrl_err(ctrl, "No new device found\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	}
 
 	list_for_each_entry(dev, &parent->devices, bus_list) {
@@ -75,7 +79,9 @@ int __ref shpchp_configure_device(struct
 
 	pci_bus_add_devices(parent);
 
-	return 0;
+ out:
+	pci_unlock_rescan_remove();
+	return ret;
 }
 
 int shpchp_unconfigure_device(struct slot *p_slot)
@@ -89,6 +95,8 @@ int shpchp_unconfigure_device(struct slo
 	ctrl_dbg(ctrl, "%s: domain:bus:dev = %04x:%02x:%02x\n",
 		 __func__, pci_domain_nr(parent), p_slot->bus, p_slot->device);
 
+	pci_lock_rescan_remove();
+
 	list_for_each_entry_safe(dev, temp, &parent->devices, bus_list) {
 		if (PCI_SLOT(dev->devfn) != p_slot->device)
 			continue;
@@ -108,6 +116,8 @@ int shpchp_unconfigure_device(struct slo
 		pci_stop_and_remove_bus_device(dev);
 		pci_dev_put(dev);
 	}
+
+	pci_unlock_rescan_remove();
 	return rc;
 }
 
Index: linux-pm/drivers/pci/hotplug/sgi_hotplug.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/sgi_hotplug.c
+++ linux-pm/drivers/pci/hotplug/sgi_hotplug.c
@@ -459,12 +459,15 @@ static int enable_slot(struct hotplug_sl
 		acpi_scan_lock_release();
 	}
 
+	pci_lock_rescan_remove();
+
 	/* Call the driver for the new device */
 	pci_bus_add_devices(slot->pci_bus);
 	/* Call the drivers for the new devices subordinate to PPB */
 	if (new_ppb)
 		pci_bus_add_devices(new_bus);
 
+	pci_unlock_rescan_remove();
 	mutex_unlock(&sn_hotplug_mutex);
 
 	if (rc == 0)
@@ -540,6 +543,7 @@ static int disable_slot(struct hotplug_s
 		acpi_scan_lock_release();
 	}
 
+	pci_lock_rescan_remove();
 	/* Free the SN resources assigned to the Linux device.*/
 	list_for_each_entry_safe(dev, temp, &slot->pci_bus->devices, bus_list) {
 		if (PCI_SLOT(dev->devfn) != slot->device_num + 1)
@@ -550,6 +554,7 @@ static int disable_slot(struct hotplug_s
 		pci_stop_and_remove_bus_device(dev);
 		pci_dev_put(dev);
 	}
+	pci_unlock_rescan_remove();
 
 	/* Remove the SSDT for the slot from the ACPI namespace */
 	if (SN_ACPI_BASE_SUPPORT() && ssdt_id) {
Index: linux-pm/drivers/pci/hotplug/rpaphp_core.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/rpaphp_core.c
+++ linux-pm/drivers/pci/hotplug/rpaphp_core.c
@@ -398,7 +398,9 @@ static int enable_slot(struct hotplug_sl
 		return retval;
 
 	if (state == PRESENT) {
+		pci_lock_rescan_remove();
 		pcibios_add_pci_devices(slot->bus);
+		pci_unlock_rescan_remove();
 		slot->state = CONFIGURED;
 	} else if (state == EMPTY) {
 		slot->state = EMPTY;
@@ -418,7 +420,9 @@ static int disable_slot(struct hotplug_s
 	if (slot->state == NOT_CONFIGURED)
 		return -EINVAL;
 
+	pci_lock_rescan_remove();
 	pcibios_remove_pci_devices(slot->bus);
+	pci_unlock_rescan_remove();
 	vm_unmap_aliases();
 
 	slot->state = NOT_CONFIGURED;
