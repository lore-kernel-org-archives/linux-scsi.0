From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/3] pci: New PCI-E reset API
Date: Mon, 19 Feb 2007 08:47:13 -0600
Message-ID: <17750.2150451348$1171896494@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: greg@kroah.com
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org, brking@linux.vnet.ibm.com, linux-pci@atrey.karlin.mff.cuni.cz
List-Id: linux-scsi@vger.kernel.org


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
