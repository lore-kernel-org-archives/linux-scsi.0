From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH 1/9] PCI: Global rescan-remove lock
Date: Fri, 10 Jan 2014 15:22:18 +0100
Message-ID: <25738007.GvRlERVdx3@vostro.rjw.lan>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <1992931.Zv6xBcN8V4@vostro.rjw.lan> <20440867.YaQfKrcfsQ@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from v094114.home.net.pl ([79.96.170.134]:52628 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753008AbaAJOQW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2014 09:16:22 -0500
In-Reply-To: <20440867.YaQfKrcfsQ@vostro.rjw.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>, Myron Stowe <myron.stowe@gmail.com>, Benjamin Herrenschmidt <benh@au1.ibm.com>, linux-scsi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

There are multiple PCI device addition and removal code paths that
may be run concurrently with the generic PCI bus rescan and device
removal that can be triggered via sysfs.  If that happens, it may
lead to multiple different, potentially dangerous race conditions.

The most straightforward way to address those problems is to run
the code in question under the same lock that is used by the
generic rescan/remove code in pci-sysfs.c.  To prepare for those
changes, move the definition of the global PCI remove/rescan lock
to probe.c and provide global wrappers, pci_lock_rescan_remove()
and pci_unlock_rescan_remove(), allowing drivers to manipulate
that lock.  Also provide pci_stop_and_remove_bus_device_locked()
for the callers of pci_stop_and_remove_bus_device() who only need
to hold the rescan/remove lock around it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/pci-sysfs.c |   19 +++++++------------
 drivers/pci/probe.c     |   18 ++++++++++++++++++
 drivers/pci/remove.c    |    8 ++++++++
 include/linux/pci.h     |    3 +++
 4 files changed, 36 insertions(+), 12 deletions(-)

Index: linux-pm/drivers/pci/pci-sysfs.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-sysfs.c
+++ linux-pm/drivers/pci/pci-sysfs.c
@@ -297,7 +297,6 @@ msi_bus_store(struct device *dev, struct
 }
 static DEVICE_ATTR_RW(msi_bus);
 
-static DEFINE_MUTEX(pci_remove_rescan_mutex);
 static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
 				size_t count)
 {
@@ -308,10 +307,10 @@ static ssize_t bus_rescan_store(struct b
 		return -EINVAL;
 
 	if (val) {
-		mutex_lock(&pci_remove_rescan_mutex);
+		pci_lock_rescan_remove();
 		while ((b = pci_find_next_bus(b)) != NULL)
 			pci_rescan_bus(b);
-		mutex_unlock(&pci_remove_rescan_mutex);
+		pci_unlock_rescan_remove();
 	}
 	return count;
 }
@@ -342,9 +341,9 @@ dev_rescan_store(struct device *dev, str
 		return -EINVAL;
 
 	if (val) {
-		mutex_lock(&pci_remove_rescan_mutex);
+		pci_lock_rescan_remove();
 		pci_rescan_bus(pdev->bus);
-		mutex_unlock(&pci_remove_rescan_mutex);
+		pci_unlock_rescan_remove();
 	}
 	return count;
 }
@@ -354,11 +353,7 @@ static struct device_attribute dev_resca
 
 static void remove_callback(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-
-	mutex_lock(&pci_remove_rescan_mutex);
-	pci_stop_and_remove_bus_device(pdev);
-	mutex_unlock(&pci_remove_rescan_mutex);
+	pci_stop_and_remove_bus_device_locked(to_pci_dev(dev));
 }
 
 static ssize_t
@@ -395,12 +390,12 @@ dev_bus_rescan_store(struct device *dev,
 		return -EINVAL;
 
 	if (val) {
-		mutex_lock(&pci_remove_rescan_mutex);
+		pci_lock_rescan_remove();
 		if (!pci_is_root_bus(bus) && list_empty(&bus->devices))
 			pci_rescan_bus_bridge_resize(bus->self);
 		else
 			pci_rescan_bus(bus);
-		mutex_unlock(&pci_remove_rescan_mutex);
+		pci_unlock_rescan_remove();
 	}
 	return count;
 }
Index: linux-pm/drivers/pci/probe.c
===================================================================
--- linux-pm.orig/drivers/pci/probe.c
+++ linux-pm/drivers/pci/probe.c
@@ -2014,6 +2014,24 @@ EXPORT_SYMBOL(pci_scan_slot);
 EXPORT_SYMBOL(pci_scan_bridge);
 EXPORT_SYMBOL_GPL(pci_scan_child_bus);
 
+/*
+ * pci_rescan_bus(), pci_rescan_bus_bridge_resize() and PCI device removal
+ * routines should always be executed under this mutex.
+ */
+static DEFINE_MUTEX(pci_rescan_remove_lock);
+
+void pci_lock_rescan_remove(void)
+{
+	mutex_lock(&pci_rescan_remove_lock);
+}
+EXPORT_SYMBOL_GPL(pci_lock_rescan_remove);
+
+void pci_unlock_rescan_remove(void)
+{
+	mutex_unlock(&pci_rescan_remove_lock);
+}
+EXPORT_SYMBOL_GPL(pci_unlock_rescan_remove);
+
 static int __init pci_sort_bf_cmp(const struct device *d_a, const struct device *d_b)
 {
 	const struct pci_dev *a = to_pci_dev(d_a);
Index: linux-pm/include/linux/pci.h
===================================================================
--- linux-pm.orig/include/linux/pci.h
+++ linux-pm/include/linux/pci.h
@@ -779,6 +779,7 @@ struct pci_dev *pci_dev_get(struct pci_d
 void pci_dev_put(struct pci_dev *dev);
 void pci_remove_bus(struct pci_bus *b);
 void pci_stop_and_remove_bus_device(struct pci_dev *dev);
+void pci_stop_and_remove_bus_device_locked(struct pci_dev *dev);
 void pci_stop_root_bus(struct pci_bus *bus);
 void pci_remove_root_bus(struct pci_bus *bus);
 void pci_setup_cardbus(struct pci_bus *bus);
@@ -1022,6 +1023,8 @@ void set_pcie_hotplug_bridge(struct pci_
 int pci_bus_find_capability(struct pci_bus *bus, unsigned int devfn, int cap);
 unsigned int pci_rescan_bus_bridge_resize(struct pci_dev *bridge);
 unsigned int pci_rescan_bus(struct pci_bus *bus);
+void pci_lock_rescan_remove(void);
+void pci_unlock_rescan_remove(void);
 
 /* Vital product data routines */
 ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
Index: linux-pm/drivers/pci/remove.c
===================================================================
--- linux-pm.orig/drivers/pci/remove.c
+++ linux-pm/drivers/pci/remove.c
@@ -114,6 +114,14 @@ void pci_stop_and_remove_bus_device(stru
 }
 EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
 
+void pci_stop_and_remove_bus_device_locked(struct pci_dev *dev)
+{
+	pci_lock_rescan_remove();
+	pci_stop_and_remove_bus_device(dev);
+	pci_unlock_rescan_remove();
+}
+EXPORT_SYMBOL_GPL(pci_stop_and_remove_bus_device_locked);
+
 void pci_stop_root_bus(struct pci_bus *bus)
 {
 	struct pci_dev *child, *tmp;

