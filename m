From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 2/3] PCI: Handle device quirks when accessing sysfs
	resource<N> entries
Date: Wed, 20 Mar 2013 22:35:02 -0600
Message-ID: <20130321043502.7229.43877.stgit@amt.stowe>
References: <20130321043449.7229.81056.stgit@amt.stowe>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130321043449.7229.81056.stgit@amt.stowe>
Sender: linux-kernel-owner@vger.kernel.org
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yuxiangl@marvell.com, yxlraid@gmail.com, greg@kroah.com, alex.williamson@redhat.com, kay@vrfy.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Sysfs includes entries to memory regions that back a PCI device's BARs.
The pci-sysfs entries backing I/O Port BARs can be accessed by userspace,
providing direct access to the device's registers.  File permissions
prevent random users from accessing the device's registers through these
files, but don't stop a privileged app that chooses to ignore the purpose
of these files from doing so.

There are devices with abnormally strict restrictions with respect to
accessing their registers; aspects that are typically handled by the
device's driver.  When these access restrictions are not followed - as
when a userspace app such as "udevadm info --attribute-walk
--path=/sys/..." parses though reading all the device's sysfs entries - it
can cause such devices to fail.

This patch introduces a quirking mechanism that can be used to detect
accesses that do no meet the device's restrictions, letting a device
specific method intervene and decide how to progress.

Reported-by: Xiangliang Yu <yuxiangl@marvell.com>
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/pci-sysfs.c |   11 +++----
 drivers/pci/pci.h       |   13 +++++++++
 drivers/pci/quirks.c    |   70 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9c6e9bb..8e80c33 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -974,10 +974,9 @@ pci_mmap_resource_wc(struct file *filp, struct kobject *kobj,
 	return pci_mmap_resource(kobj, attr, vma, 1);
 }
 
-static ssize_t
-pci_resource_io(struct file *filp, struct kobject *kobj,
-		struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count, bool write)
+ssize_t pci_resource_io(struct file *filp, struct kobject *kobj,
+			struct bin_attribute *attr, char *buf,
+			loff_t off, size_t count, bool write)
 {
 	struct pci_dev *pdev = to_pci_dev(container_of(kobj,
 						       struct device, kobj));
@@ -1027,7 +1026,7 @@ pci_read_resource_io(struct file *filp, struct kobject *kobj,
 		     struct bin_attribute *attr, char *buf,
 		     loff_t off, size_t count)
 {
-	return pci_resource_io(filp, kobj, attr, buf, off, count, false);
+	return pci_resource_io_filter(filp, kobj, attr, buf, off, count, false);
 }
 
 static ssize_t
@@ -1035,7 +1034,7 @@ pci_write_resource_io(struct file *filp, struct kobject *kobj,
 		      struct bin_attribute *attr, char *buf,
 		      loff_t off, size_t count)
 {
-	return pci_resource_io(filp, kobj, attr, buf, off, count, true);
+	return pci_resource_io_filter(filp, kobj, attr, buf, off, count, true);
 }
 
 /**
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 7346ee6..a47611d 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -29,6 +29,9 @@ extern int pci_mmap_fits(struct pci_dev *pdev, int resno,
 			 struct vm_area_struct *vmai,
 			 enum pci_mmap_api mmap_api);
 #endif
+extern ssize_t pci_resource_io(struct file *filp, struct kobject *kobj,
+			       struct bin_attribute *attr, char *buf,
+			       loff_t off, size_t count, bool write);
 int pci_probe_reset_function(struct pci_dev *dev);
 
 /**
@@ -308,11 +311,21 @@ struct pci_dev_reset_methods {
 
 #ifdef CONFIG_PCI_QUIRKS
 extern int pci_dev_specific_reset(struct pci_dev *dev, int probe);
+ssize_t pci_resource_io_filter(struct file *fp, struct kobject *kobj,
+			       struct bin_attribute *attr, char *buf,
+			       loff_t offset, size_t size, bool write);
 #else
 static inline int pci_dev_specific_reset(struct pci_dev *dev, int probe)
 {
 	return -ENOTTY;
 }
+static inline ssize_t
+pci_resource_io_filter(struct file *fp, struct kobject *kobj,
+		       struct bin_attribute *attr, char *buf,
+		       loff_t offset, size_t size, bool write)
+{
+	return pci_resource_io(fp, kobj, attr, buf, offset, size, write);
+}
 #endif
 
 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 0369fb6..8b68cd2 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3324,3 +3324,73 @@ int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags)
 
 	return -ENOTTY;
 }
+
+static ssize_t marvell9125_quirk(struct file *fp, struct kobject *kobj,
+				 struct bin_attribute *attr, char *buf,
+				 loff_t offset, size_t size, bool write)
+{
+	/*
+	 * Short circuit out of trying to access this device's I/O port
+	 * region.
+	 */
+	return -EINVAL;
+}
+
+static const struct pci_resource_io_quirk {
+        u16	vendor;
+        u16	device;
+	int	bar;
+	size_t	size;
+	loff_t	offset;
+	ssize_t (*iores_access)(struct file *fp, struct kobject *kobj,
+				struct bin_attribute *attr, char *buf,
+				loff_t offset, size_t size, bool write);
+} pci_resource_io_quirks[] = {
+	/*
+	 * Some devices have abnormally strict restrictions when accessing
+	 * their I/O port regions.
+	 * https://lkml.org/lkml/2013/3/16/168
+	 */
+        { PCI_VENDOR_ID_MARVELL_EXT, 0x9125, 1, 4, 0, marvell9125_quirk },
+        { PCI_VENDOR_ID_MARVELL_EXT, 0x9125, 1, 2, 2, marvell9125_quirk },
+        { PCI_VENDOR_ID_MARVELL_EXT, 0x9125, 1, 1, 0, marvell9125_quirk },
+        { PCI_VENDOR_ID_MARVELL_EXT, 0x9125, 1, 1, 1, marvell9125_quirk },
+        { PCI_VENDOR_ID_MARVELL_EXT, 0x9125, 1, 1, 3, marvell9125_quirk },
+        { PCI_VENDOR_ID_MARVELL_EXT, 0x9125, 3, 4, 0, marvell9125_quirk },
+        { PCI_VENDOR_ID_MARVELL_EXT, 0x9125, 3, 2, 2, marvell9125_quirk },
+        { PCI_VENDOR_ID_MARVELL_EXT, 0x9125, 3, 1, 0, marvell9125_quirk },
+        { PCI_VENDOR_ID_MARVELL_EXT, 0x9125, 3, 1, 1, marvell9125_quirk },
+        { PCI_VENDOR_ID_MARVELL_EXT, 0x9125, 3, 1, 3, marvell9125_quirk },
+        { 0 }
+};
+
+ssize_t pci_resource_io_filter(struct file *fp, struct kobject *kobj,
+			       struct bin_attribute *attr, char *buf,
+			       loff_t offset, size_t size, bool write)
+{
+	int bar;
+	struct resource *res = attr->private;
+	const struct pci_resource_io_quirk *i;
+	struct pci_dev *dev = to_pci_dev(container_of(kobj,
+						      struct device, kobj));
+
+	for (bar = 0; bar < PCI_ROM_RESOURCE; bar++)
+                if (res == &dev->resource[bar])
+                        break;
+	if (bar >= PCI_ROM_RESOURCE)
+                return -ENODEV;
+
+	for (i = pci_resource_io_quirks; i->iores_access; i++) {
+		if ((i->vendor == dev->vendor ||
+		     i->vendor == (u16)PCI_ANY_ID) &&
+		    (i->device == dev->device ||
+		     i->device == (u16)PCI_ANY_ID) &&
+		     i->bar == bar &&
+		     i->size == size &&
+		     i->offset == offset)
+			return i->iores_access(fp, kobj, attr, buf, offset,
+					       size, write);
+	}
+
+	return pci_resource_io(fp, kobj, attr, buf, offset, size, write);
+}
