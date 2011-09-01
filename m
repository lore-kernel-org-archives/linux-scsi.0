From: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
Date: Thu, 1 Sep 2011 13:09:30 -0700
Message-ID: <20110901130930.5caec2d4@jbarnes-desktop>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
	<1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20110901160724.GN9189@beardog.cce.hp.com>
	<1314898815.2823.33.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CAL1RGDWu4mBE3=0BC3iNnvfSSuT2pfGrXsBZBU-VB+tqZx7DeA@mail.gmail.com>
	<1314903038.3067.27.camel@dabdike>
	<20110901125938.7cb1da85@jbarnes-desktop>
	<20110901200349.GO9189@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/2VCi792opXk7_O=BrAOXoi+"
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20110901200349.GO9189@beardog.cce.hp.com>
Sender: linux-pci-owner@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>, scameron@beardog.cce.hp.com, Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com, linux-pci@vger.kernel.org, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

--MP_/2VCi792opXk7_O=BrAOXoi+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, 1 Sep 2011 15:03:49 -0500
scameron@beardog.cce.hp.com wrote:

> On Thu, Sep 01, 2011 at 12:59:38PM -0700, Jesse Barnes wrote:
> > On Thu, 01 Sep 2011 11:50:38 -0700
> > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > On Thu, 2011-09-01 at 10:58 -0700, Roland Dreier wrote:
> > > > > OK I found the bad commit,I got lucky... I lost some files but my
> > > > > machine was able to complete the bisection. CC involved people
> > > > 
> > > > > # bad: [b03e7495a862b028294f59fc87286d6d78ee7fa1] PCI: Set PCI-E Max Payload Size on fabric
> > > > 
> > > > Hi Eric,
> > > > 
> > > > I guess it would be useful to see "lspci -vv" output with a "good" kernel
> > > > and with that bad patch applied.  Most likely we should see some difference
> > > > somewhere in the MaxPayload fields in the PCI Express capability of
> > > > some device.
> > > > 
> > > > Either the RAID controller or something else lies, and puts a value
> > > > in the DevCap that it can't actually support, or else the patch is
> > > > buggy and puts something out of range in a DevCtl somewhere.
> > > 
> > > 
> > > While we investigate, I think the problems produced by the patch (data
> > > corruption) are serious enough to warrant reverting it, please Jesse.
> > 
> > Hm I haven't been paying attention to the compromise thread; how should
> > I share these changes?  Is master.kernel.org down indefinitely?  Is
> > there a new server at kernel.org I can use?
> 
> I can't answer that question, but I would like a copy of your revert
> patch(es) to test (as a simple patch --reverse of the original commit on the 3.1-rc4
> tree didn't go in cleanly).

Attached is the series.  Applies on top of my for-linus branch.

-- 
Jesse Barnes, Intel Open Source Technology Center

--MP_/2VCi792opXk7_O=BrAOXoi+
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0003-Revert-PCI-Set-PCI-E-Max-Payload-Size-on-fabric.patch

>From 1679df1a7dfdc880133c0c118d33a52db2108bba Mon Sep 17 00:00:00 2001
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Thu, 1 Sep 2011 12:36:25 -0700
Subject: [PATCH 3/3] Revert "PCI: Set PCI-E Max Payload Size on fabric"

This reverts commit b03e7495a862b028294f59fc87286d6d78ee7fa1.  This
patch has caused GPU hangs on radeon and data corruption in some SCSI
configurations, so revert it until we understand the problems and have a
fix.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/pci/acpi.c              |    9 ---
 drivers/pci/hotplug/pcihp_slot.c |   45 ++++++++++++-
 drivers/pci/pci.c                |   67 -----------------
 drivers/pci/probe.c              |  145 --------------------------------------
 include/linux/pci.h              |   15 +----
 5 files changed, 45 insertions(+), 236 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index c953302..ae3cb23 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -360,15 +360,6 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 		}
 	}
 
-	/* After the PCI-E bus has been walked and all devices discovered,
-	 * configure any settings of the fabric that might be necessary.
-	 */
-	if (bus) {
-		struct pci_bus *child;
-		list_for_each_entry(child, &bus->children, node)
-			pcie_bus_configure_settings(child, child->self->pcie_mpss);
-	}
-
 	if (!bus)
 		kfree(sd);
 
diff --git a/drivers/pci/hotplug/pcihp_slot.c b/drivers/pci/hotplug/pcihp_slot.c
index 753b21a..749fdf0 100644
--- a/drivers/pci/hotplug/pcihp_slot.c
+++ b/drivers/pci/hotplug/pcihp_slot.c
@@ -158,6 +158,47 @@ static void program_hpp_type2(struct pci_dev *dev, struct hpp_type2 *hpp)
 	 */
 }
 
+/* Program PCIE MaxPayload setting on device: ensure parent maxpayload <= device */
+static int pci_set_payload(struct pci_dev *dev)
+{
+       int pos, ppos;
+       u16 pctl, psz;
+       u16 dctl, dsz, dcap, dmax;
+       struct pci_dev *parent;
+
+       parent = dev->bus->self;
+       pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
+       if (!pos)
+               return 0;
+
+       /* Read Device MaxPayload capability and setting */
+       pci_read_config_word(dev, pos + PCI_EXP_DEVCTL, &dctl);
+       pci_read_config_word(dev, pos + PCI_EXP_DEVCAP, &dcap);
+       dsz = (dctl & PCI_EXP_DEVCTL_PAYLOAD) >> 5;
+       dmax = (dcap & PCI_EXP_DEVCAP_PAYLOAD);
+
+       /* Read Parent MaxPayload setting */
+       ppos = pci_find_capability(parent, PCI_CAP_ID_EXP);
+       if (!ppos)
+               return 0;
+       pci_read_config_word(parent, ppos + PCI_EXP_DEVCTL, &pctl);
+       psz = (pctl &  PCI_EXP_DEVCTL_PAYLOAD) >> 5;
+
+       /* If parent payload > device max payload -> error
+        * If parent payload > device payload -> set speed
+        * If parent payload <= device payload -> do nothing
+        */
+       if (psz > dmax)
+               return -1;
+       else if (psz > dsz) {
+               dev_info(&dev->dev, "Setting MaxPayload to %d\n", 128 << psz);
+               pci_write_config_word(dev, pos + PCI_EXP_DEVCTL,
+                                     (dctl & ~PCI_EXP_DEVCTL_PAYLOAD) +
+                                     (psz << 5));
+       }
+       return 0;
+}
+
 void pci_configure_slot(struct pci_dev *dev)
 {
 	struct pci_dev *cdev;
@@ -169,7 +210,9 @@ void pci_configure_slot(struct pci_dev *dev)
 			(dev->class >> 8) == PCI_CLASS_BRIDGE_PCI)))
 		return;
 
-	pcie_bus_configure_settings(dev->bus, dev->bus->self->pcie_mpss);
+       ret = pci_set_payload(dev);
+       if (ret)
+               dev_warn(&dev->dev, "could not set device max payload\n");
 
 	memset(&hpp, 0, sizeof(hpp));
 	ret = pci_get_hp_params(dev, &hpp);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 466fad6..08a95b3 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -77,8 +77,6 @@ unsigned long pci_cardbus_mem_size = DEFAULT_CARDBUS_MEM_SIZE;
 unsigned long pci_hotplug_io_size  = DEFAULT_HOTPLUG_IO_SIZE;
 unsigned long pci_hotplug_mem_size = DEFAULT_HOTPLUG_MEM_SIZE;
 
-enum pcie_bus_config_types pcie_bus_config = PCIE_BUS_PERFORMANCE;
-
 /*
  * The default CLS is used if arch didn't set CLS explicitly and not
  * all pci devices agree on the same value.  Arch can override either
@@ -3225,67 +3223,6 @@ out:
 EXPORT_SYMBOL(pcie_set_readrq);
 
 /**
- * pcie_get_mps - get PCI Express maximum payload size
- * @dev: PCI device to query
- *
- * Returns maximum payload size in bytes
- *    or appropriate error value.
- */
-int pcie_get_mps(struct pci_dev *dev)
-{
-	int ret, cap;
-	u16 ctl;
-
-	cap = pci_pcie_cap(dev);
-	if (!cap)
-		return -EINVAL;
-
-	ret = pci_read_config_word(dev, cap + PCI_EXP_DEVCTL, &ctl);
-	if (!ret)
-		ret = 128 << ((ctl & PCI_EXP_DEVCTL_PAYLOAD) >> 5);
-
-	return ret;
-}
-
-/**
- * pcie_set_mps - set PCI Express maximum payload size
- * @dev: PCI device to query
- * @rq: maximum payload size in bytes
- *    valid values are 128, 256, 512, 1024, 2048, 4096
- *
- * If possible sets maximum payload size
- */
-int pcie_set_mps(struct pci_dev *dev, int mps)
-{
-	int cap, err = -EINVAL;
-	u16 ctl, v;
-
-	if (mps < 128 || mps > 4096 || !is_power_of_2(mps))
-		goto out;
-
-	v = ffs(mps) - 8;
-	if (v > dev->pcie_mpss) 
-		goto out;
-	v <<= 5;
-
-	cap = pci_pcie_cap(dev);
-	if (!cap)
-		goto out;
-
-	err = pci_read_config_word(dev, cap + PCI_EXP_DEVCTL, &ctl);
-	if (err)
-		goto out;
-
-	if ((ctl & PCI_EXP_DEVCTL_PAYLOAD) != v) {
-		ctl &= ~PCI_EXP_DEVCTL_PAYLOAD;
-		ctl |= v;
-		err = pci_write_config_word(dev, cap + PCI_EXP_DEVCTL, ctl);
-	}
-out:
-	return err;
-}
-
-/**
  * pci_select_bars - Make BAR mask from the type of resource
  * @dev: the PCI device for which BAR mask is made
  * @flags: resource type mask to be selected
@@ -3568,10 +3505,6 @@ static int __init pci_setup(char *str)
 				pci_hotplug_io_size = memparse(str + 9, &str);
 			} else if (!strncmp(str, "hpmemsize=", 10)) {
 				pci_hotplug_mem_size = memparse(str + 10, &str);
-			} else if (!strncmp(str, "pcie_bus_safe", 13)) {
-				pcie_bus_config = PCIE_BUS_SAFE;
-			} else if (!strncmp(str, "pcie_bus_perf", 13)) {
-				pcie_bus_config = PCIE_BUS_PERFORMANCE;
 			} else {
 				printk(KERN_ERR "PCI: Unknown option `%s'\n",
 						str);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5becf7c..795c902 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -856,8 +856,6 @@ void set_pcie_port_type(struct pci_dev *pdev)
 	pdev->pcie_cap = pos;
 	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
 	pdev->pcie_type = (reg16 & PCI_EXP_FLAGS_TYPE) >> 4;
-	pci_read_config_word(pdev, pos + PCI_EXP_DEVCAP, &reg16);
-	pdev->pcie_mpss = reg16 & PCI_EXP_DEVCAP_PAYLOAD;
 }
 
 void set_pcie_hotplug_bridge(struct pci_dev *pdev)
@@ -1328,149 +1326,6 @@ int pci_scan_slot(struct pci_bus *bus, int devfn)
 	return nr;
 }
 
-static int pcie_find_smpss(struct pci_dev *dev, void *data)
-{
-	u8 *smpss = data;
-
-	if (!pci_is_pcie(dev))
-		return 0;
-
-	/* For PCIE hotplug enabled slots not connected directly to a
-	 * PCI-E root port, there can be problems when hotplugging
-	 * devices.  This is due to the possibility of hotplugging a
-	 * device into the fabric with a smaller MPS that the devices
-	 * currently running have configured.  Modifying the MPS on the
-	 * running devices could cause a fatal bus error due to an
-	 * incoming frame being larger than the newly configured MPS.
-	 * To work around this, the MPS for the entire fabric must be
-	 * set to the minimum size.  Any devices hotplugged into this
-	 * fabric will have the minimum MPS set.  If the PCI hotplug
-	 * slot is directly connected to the root port and there are not
-	 * other devices on the fabric (which seems to be the most
-	 * common case), then this is not an issue and MPS discovery
-	 * will occur as normal.
-	 */
-	if (dev->is_hotplug_bridge && (!list_is_singular(&dev->bus->devices) ||
-	    dev->bus->self->pcie_type != PCI_EXP_TYPE_ROOT_PORT))
-		*smpss = 0;
-
-	if (*smpss > dev->pcie_mpss)
-		*smpss = dev->pcie_mpss;
-
-	return 0;
-}
-
-static void pcie_write_mps(struct pci_dev *dev, int mps)
-{
-	int rc, dev_mpss;
-
-	dev_mpss = 128 << dev->pcie_mpss;
-
-	if (pcie_bus_config == PCIE_BUS_PERFORMANCE) {
-		if (dev->bus->self) {
-			dev_dbg(&dev->bus->dev, "Bus MPSS %d\n",
-				128 << dev->bus->self->pcie_mpss);
-
-			/* For "MPS Force Max", the assumption is made that
-			 * downstream communication will never be larger than
-			 * the MRRS.  So, the MPS only needs to be configured
-			 * for the upstream communication.  This being the case,
-			 * walk from the top down and set the MPS of the child
-			 * to that of the parent bus.
-			 */
-			mps = 128 << dev->bus->self->pcie_mpss;
-			if (mps > dev_mpss)
-				dev_warn(&dev->dev, "MPS configured higher than"
-					 " maximum supported by the device.  If"
-					 " a bus issue occurs, try running with"
-					 " pci=pcie_bus_safe.\n");
-		}
-
-		dev->pcie_mpss = ffs(mps) - 8;
-	}
-
-	rc = pcie_set_mps(dev, mps);
-	if (rc)
-		dev_err(&dev->dev, "Failed attempting to set the MPS\n");
-}
-
-static void pcie_write_mrrs(struct pci_dev *dev, int mps)
-{
-	int rc, mrrs;
-
-	if (pcie_bus_config == PCIE_BUS_PERFORMANCE) {
-		int dev_mpss = 128 << dev->pcie_mpss;
-
-		/* For Max performance, the MRRS must be set to the largest
-		 * supported value.  However, it cannot be configured larger
-		 * than the MPS the device or the bus can support.  This assumes
-		 * that the largest MRRS available on the device cannot be
-		 * smaller than the device MPSS.
-		 */
-		mrrs = mps < dev_mpss ? mps : dev_mpss;
-	} else
-		/* In the "safe" case, configure the MRRS for fairness on the
-		 * bus by making all devices have the same size
-		 */
-		mrrs = mps;
-
-
-	/* MRRS is a R/W register.  Invalid values can be written, but a
-	 * subsiquent read will verify if the value is acceptable or not.
-	 * If the MRRS value provided is not acceptable (e.g., too large),
-	 * shrink the value until it is acceptable to the HW.
- 	 */
-	while (mrrs != pcie_get_readrq(dev) && mrrs >= 128) {
-		rc = pcie_set_readrq(dev, mrrs);
-		if (rc)
-			dev_err(&dev->dev, "Failed attempting to set the MRRS\n");
-
-		mrrs /= 2;
-	}
-}
-
-static int pcie_bus_configure_set(struct pci_dev *dev, void *data)
-{
-	int mps = 128 << *(u8 *)data;
-
-	if (!pci_is_pcie(dev))
-		return 0;
-
-	dev_info(&dev->dev, "Dev MPS %d MPSS %d MRRS %d\n",
-		 pcie_get_mps(dev), 128<<dev->pcie_mpss, pcie_get_readrq(dev));
-
-	pcie_write_mps(dev, mps);
-	pcie_write_mrrs(dev, mps);
-
-	dev_info(&dev->dev, "Dev MPS %d MPSS %d MRRS %d\n",
-		 pcie_get_mps(dev), 128<<dev->pcie_mpss, pcie_get_readrq(dev));
-
-	return 0;
-}
-
-/* pcie_bus_configure_mps requires that pci_walk_bus work in a top-down,
- * parents then children fashion.  If this changes, then this code will not
- * work as designed.
- */
-void pcie_bus_configure_settings(struct pci_bus *bus, u8 mpss)
-{
-	u8 smpss = mpss;
-
-	if (!bus->self)
-		return;
-
-	if (!pci_is_pcie(bus->self))
-		return;
-
-	if (pcie_bus_config == PCIE_BUS_SAFE) {
-		pcie_find_smpss(bus->self, &smpss);
-		pci_walk_bus(bus, pcie_find_smpss, &smpss);
-	}
-
-	pcie_bus_configure_set(bus->self, &smpss);
-	pci_walk_bus(bus, pcie_bus_configure_set, &smpss);
-}
-
 unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 {
 	unsigned int devfn, pass, max = bus->secondary;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8c230cb..7968f9d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -251,8 +251,7 @@ struct pci_dev {
 	u8		revision;	/* PCI revision, low byte of class word */
 	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
 	u8		pcie_cap;	/* PCI-E capability offset */
-	u8		pcie_type:4;	/* PCI-E device/port type */
-	u8		pcie_mpss:3;	/* PCI-E Max Payload Size Supported */
+	u8		pcie_type;	/* PCI-E device/port type */
 	u8		rom_base_reg;	/* which config register controls the ROM */
 	u8		pin;  		/* which interrupt pin this device uses */
 
@@ -618,16 +617,6 @@ struct pci_driver {
 /* these external functions are only available when PCI support is enabled */
 #ifdef CONFIG_PCI
 
-extern void pcie_bus_configure_settings(struct pci_bus *bus, u8 smpss);
-
-enum pcie_bus_config_types {
-	PCIE_BUS_PERFORMANCE,
-	PCIE_BUS_SAFE,
-	PCIE_BUS_PEER2PEER,
-};
-
-extern enum pcie_bus_config_types pcie_bus_config;
-
 extern struct bus_type pci_bus_type;
 
 /* Do NOT directly access these two variables, unless you are arch specific pci
@@ -807,8 +796,6 @@ int pcix_get_mmrbc(struct pci_dev *dev);
 int pcix_set_mmrbc(struct pci_dev *dev, int mmrbc);
 int pcie_get_readrq(struct pci_dev *dev);
 int pcie_set_readrq(struct pci_dev *dev, int rq);
-int pcie_get_mps(struct pci_dev *dev);
-int pcie_set_mps(struct pci_dev *dev, int mps);
 int __pci_reset_function(struct pci_dev *dev);
 int pci_reset_function(struct pci_dev *dev);
 void pci_update_resource(struct pci_dev *dev, int resno);
-- 
1.7.1


--MP_/2VCi792opXk7_O=BrAOXoi+
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0002-PCI-Revert-PCI-export-pcie_bus_configure_settings-sy.patch

>From 00defdce8227eb5734367727003d725c012e92c8 Mon Sep 17 00:00:00 2001
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Thu, 1 Sep 2011 12:35:43 -0700
Subject: [PATCH 2/3] PCI: Revert "PCI: export pcie_bus_configure_settings symbol"

This reverts commit debc3b778508f59696ff188f0feca271dcbfa7d9, a fixup for
the next reverted patch.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/probe.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8473727..5becf7c 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1470,7 +1470,6 @@ void pcie_bus_configure_settings(struct pci_bus *bus, u8 mpss)
 	pcie_bus_configure_set(bus->self, &smpss);
 	pci_walk_bus(bus, pcie_bus_configure_set, &smpss);
 }
-EXPORT_SYMBOL_GPL(pcie_bus_configure_settings);
 
 unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 {
-- 
1.7.1


--MP_/2VCi792opXk7_O=BrAOXoi+
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-PCI-Revert-pci-fix-new-kernel-doc-warning-in-pci.c.patch

>From 7ec72e08c43fbf698e62eac1d509cfe8238c0b25 Mon Sep 17 00:00:00 2001
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Thu, 1 Sep 2011 12:32:55 -0700
Subject: [PATCH 1/3] PCI: Revert "pci: fix new kernel-doc warning in pci.c"

This reverts commit 47c08f3107270e5a439bc0106a308f7c48c9621d, a comment
fix up for the next revert.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 0ce6742..466fad6 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3250,7 +3250,7 @@ int pcie_get_mps(struct pci_dev *dev)
 /**
  * pcie_set_mps - set PCI Express maximum payload size
  * @dev: PCI device to query
- * @mps: maximum payload size in bytes
+ * @rq: maximum payload size in bytes
  *    valid values are 128, 256, 512, 1024, 2048, 4096
  *
  * If possible sets maximum payload size
-- 
1.7.1


--MP_/2VCi792opXk7_O=BrAOXoi+--
