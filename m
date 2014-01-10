From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH 8/9] powerpc / eeh_driver: Use global PCI rescan-remove locking
Date: Fri, 10 Jan 2014 15:28:38 +0100
Message-ID: <4447911.Q1f9tEzrXs@vostro.rjw.lan>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <1992931.Zv6xBcN8V4@vostro.rjw.lan> <20440867.YaQfKrcfsQ@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20440867.YaQfKrcfsQ@vostro.rjw.lan>
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>, Myron Stowe <myron.stowe@gmail.com>, Benjamin Herrenschmidt <benh@au1.ibm.com>, linux-scsi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Race conditions are theoretically possible between the PCI device
addition and removal in the PPC64 PCI error recovery driver and
the generic PCI bus rescan and device removal that can be triggered
via sysfs.

To avoid those race conditions make PPC64 PCI error recovery driver
use global PCI rescan-remove locking around PCI device addition and
removal.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 arch/powerpc/kernel/eeh_driver.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

Index: linux-pm/arch/powerpc/kernel/eeh_driver.c
===================================================================
--- linux-pm.orig/arch/powerpc/kernel/eeh_driver.c
+++ linux-pm/arch/powerpc/kernel/eeh_driver.c
@@ -369,7 +369,9 @@ static void *eeh_rmv_device(void *data,
 	edev->mode |= EEH_DEV_DISCONNECTED;
 	(*removed)++;
 
+	pci_lock_rescan_remove();
 	pci_stop_and_remove_bus_device(dev);
+	pci_unlock_rescan_remove();
 
 	return NULL;
 }
@@ -416,10 +418,13 @@ static int eeh_reset_device(struct eeh_p
 	 * into pcibios_add_pci_devices().
 	 */
 	eeh_pe_state_mark(pe, EEH_PE_KEEP);
-	if (bus)
+	if (bus) {
+		pci_lock_rescan_remove();
 		pcibios_remove_pci_devices(bus);
-	else if (frozen_bus)
+		pci_unlock_rescan_remove();
+	} else if (frozen_bus) {
 		eeh_pe_dev_traverse(pe, eeh_rmv_device, &removed);
+	}
 
 	/* Reset the pci controller. (Asserts RST#; resets config space).
 	 * Reconfigure bridges and devices. Don't try to bring the system
@@ -429,6 +434,8 @@ static int eeh_reset_device(struct eeh_p
 	if (rc)
 		return rc;
 
+	pci_lock_rescan_remove();
+
 	/* Restore PE */
 	eeh_ops->configure_bridge(pe);
 	eeh_pe_restore_bars(pe);
@@ -462,6 +469,7 @@ static int eeh_reset_device(struct eeh_p
 	pe->tstamp = tstamp;
 	pe->freeze_count = cnt;
 
+	pci_unlock_rescan_remove();
 	return 0;
 }
 
@@ -618,8 +626,11 @@ perm_error:
 	eeh_pe_dev_traverse(pe, eeh_report_failure, NULL);
 
 	/* Shut down the device drivers for good. */
-	if (frozen_bus)
+	if (frozen_bus) {
+		pci_lock_rescan_remove();
 		pcibios_remove_pci_devices(frozen_bus);
+		pci_unlock_rescan_remove();
+	}
 }
 
 static void eeh_handle_special_event(void)
@@ -692,6 +703,7 @@ static void eeh_handle_special_event(voi
 	if (rc == 2 || rc == 1)
 		eeh_handle_normal_event(pe);
 	else {
+		lock_pci_remove_rescan();
 		list_for_each_entry_safe(hose, tmp,
 			&hose_list, list_node) {
 			phb_pe = eeh_phb_pe_get(hose);
@@ -703,6 +715,7 @@ static void eeh_handle_special_event(voi
 			eeh_pe_dev_traverse(pe, eeh_report_failure, NULL);
 			pcibios_remove_pci_devices(bus);
 		}
+		unlock_pci_remove_rescan();
 	}
 }
 
