From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/3] pci: New PCI-E reset API
Date: Mon, 19 Feb 2007 08:47:13 -0600
Message-ID: <44034.1112240732$1171896457@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44899 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932291AbXBSOrT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Feb 2007 09:47:19 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l1JElGrR019539
	for <linux-scsi@vger.kernel.org>; Mon, 19 Feb 2007 09:47:16 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l1JElGC5286596
	for <linux-scsi@vger.kernel.org>; Mon, 19 Feb 2007 09:47:16 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l1JElFor022728
	for <linux-scsi@vger.kernel.org>; Mon, 19 Feb 2007 09:47:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@kroah.com
Cc: linux-pci@atrey.karlin.mff.cuni.cz, paulus@samba.org, linuxppc-dev@ozlabs.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Adds a new API which can be used to issue various types
of PCI-E reset, including PCI-E warm reset and PCI-E hot reset.
This is needed for an ipr PCI-E adapter which does not properly
implement BIST. Running BIST on this adapter results in PCI-E
errors. The only reliable reset mechanism that exists on this
hardware is PCI Fundamental reset (warm reset). Since driving
this type of reset is architecture unique, this provides the
necessary hooks for architectures to add this support.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/pci/pci.c   |   29 +++++++++++++++++++++++++++++
 linux-2.6-bjking1/include/linux/pci.h |   14 ++++++++++++++
 2 files changed, 43 insertions(+)

diff -puN drivers/pci/pci.c~pci_pci_reset_api drivers/pci/pci.c
--- linux-2.6/drivers/pci/pci.c~pci_pci_reset_api	2007-02-16 10:10:30.000000000 -0600
+++ linux-2.6-bjking1/drivers/pci/pci.c	2007-02-16 10:10:30.000000000 -0600
@@ -893,6 +893,34 @@ pci_disable_device(struct pci_dev *dev)
 }
 
 /**
+ * pcibios_set_pcie_reset_state - set reset state for device dev
+ * @dev: the PCI-E device reset
+ * @state: Reset state to enter into
+ *
+ *
+ * Sets the PCI-E reset state for the device. This is the default
+ * implementation. Architecture implementations can override this.
+ */
+int __attribute__ ((weak)) pcibios_set_pcie_reset_state(struct pci_dev *dev,
+							enum pcie_reset_state state)
+{
+	return -EINVAL;
+}
+
+/**
+ * pci_set_pcie_reset_state - set reset state for device dev
+ * @dev: the PCI-E device reset
+ * @state: Reset state to enter into
+ *
+ *
+ * Sets the PCI reset state for the device.
+ */
+int pci_set_pcie_reset_state(struct pci_dev *dev, enum pcie_reset_state state)
+{
+	return pcibios_set_pcie_reset_state(dev, state);
+}
+
+/**
  * pci_enable_wake - enable device to generate PME# when suspended
  * @dev: - PCI device to operate on
  * @state: - Current state of device.
@@ -1374,4 +1402,5 @@ EXPORT_SYMBOL(pci_set_power_state);
 EXPORT_SYMBOL(pci_save_state);
 EXPORT_SYMBOL(pci_restore_state);
 EXPORT_SYMBOL(pci_enable_wake);
+EXPORT_SYMBOL_GPL(pci_set_pcie_reset_state);
 
diff -puN include/linux/pci.h~pci_pci_reset_api include/linux/pci.h
--- linux-2.6/include/linux/pci.h~pci_pci_reset_api	2007-02-16 10:10:30.000000000 -0600
+++ linux-2.6-bjking1/include/linux/pci.h	2007-02-16 10:10:30.000000000 -0600
@@ -96,6 +96,19 @@ enum pci_channel_state {
 	pci_channel_io_perm_failure = (__force pci_channel_state_t) 3,
 };
 
+typedef unsigned int __bitwise pcie_reset_state_t;
+
+enum pcie_reset_state {
+	/* Reset is NOT asserted (Use to deassert reset) */
+	pci_reset_normal = (__force pcie_reset_state_t) 1,
+
+	/* Use #PERST to reset PCI-E device */
+	pci_reset_pcie_warm_reset = (__force pcie_reset_state_t) 2,
+
+	/* Use PCI-E Hot Reset to reset device */
+	pci_reset_pcie_hot_reset = (__force pcie_reset_state_t) 3
+};
+
 typedef unsigned short __bitwise pci_bus_flags_t;
 enum pci_bus_flags {
 	PCI_BUS_FLAGS_NO_MSI = (__force pci_bus_flags_t) 1,
@@ -539,6 +552,7 @@ static inline int pci_is_managed(struct 
 
 void pci_disable_device(struct pci_dev *dev);
 void pci_set_master(struct pci_dev *dev);
+int pci_set_pcie_reset_state(struct pci_dev *dev, enum pcie_reset_state state);
 #define HAVE_PCI_SET_MWI
 int __must_check pci_set_mwi(struct pci_dev *dev);
 void pci_clear_mwi(struct pci_dev *dev);
_
