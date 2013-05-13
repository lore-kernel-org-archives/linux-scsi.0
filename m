From: Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2, part 1 3/9] PCI: Convert alloc_pci_dev(void) to pci_alloc_dev(bus) instead
Date: Tue, 14 May 2013 00:08:27 +0800
Message-ID: <1368461313-4371-4-git-send-email-jiang.liu@huawei.com>
References: <1368461313-4371-1-git-send-email-jiang.liu@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368461313-4371-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>, Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "David S. Miller" <davem@davemloft.net>, David Airlie <airlied@linux.ie>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, Jiang Liu <jiang.liu@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Gu Zheng <guz.fnst@cn.fujitsu.com>

<marker to prevent gmail from removing below "From:">
From: Gu Zheng <guz.fnst@cn.fujitsu.com>

Use the new pci_alloc_dev(bus) to replace the existing using of
alloc_pci_dev(void).

v2:
  Follow Bjorn's correction to move pci_bus_put() to
  pci_release_dev() instead.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Airlie <airlied@linux.ie>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: sparclinux@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/powerpc/kernel/pci_of_scan.c | 3 +--
 arch/sparc/kernel/pci.c           | 3 +--
 drivers/char/agp/alpha-agp.c      | 2 +-
 drivers/char/agp/parisc-agp.c     | 2 +-
 drivers/pci/iov.c                 | 8 +++++---
 drivers/pci/probe.c               | 4 ++--
 drivers/scsi/megaraid.c           | 2 +-
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index 2a67e9b..24d01c4 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -128,7 +128,7 @@ struct pci_dev *of_create_pci_dev(struct device_node *node,
 	const char *type;
 	struct pci_slot *slot;
 
-	dev = alloc_pci_dev();
+	dev = pci_alloc_dev(bus);
 	if (!dev)
 		return NULL;
 	type = of_get_property(node, "device_type", NULL);
@@ -137,7 +137,6 @@ struct pci_dev *of_create_pci_dev(struct device_node *node,
 
 	pr_debug("    create device, devfn: %x, type: %s\n", devfn, type);
 
-	dev->bus = bus;
 	dev->dev.of_node = of_node_get(node);
 	dev->dev.parent = bus->bridge;
 	dev->dev.bus = &pci_bus_type;
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index baf4366..e5871fb 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -254,7 +254,7 @@ static struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 	const char *type;
 	u32 class;
 
-	dev = alloc_pci_dev();
+	dev = pci_alloc_dev(bus);
 	if (!dev)
 		return NULL;
 
@@ -281,7 +281,6 @@ static struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 		printk("    create device, devfn: %x, type: %s\n",
 		       devfn, type);
 
-	dev->bus = bus;
 	dev->sysdata = node;
 	dev->dev.parent = bus->bridge;
 	dev->dev.bus = &pci_bus_type;
diff --git a/drivers/char/agp/alpha-agp.c b/drivers/char/agp/alpha-agp.c
index dd84af4..199b8e9 100644
--- a/drivers/char/agp/alpha-agp.c
+++ b/drivers/char/agp/alpha-agp.c
@@ -174,7 +174,7 @@ alpha_core_agp_setup(void)
 	/*
 	 * Build a fake pci_dev struct
 	 */
-	pdev = alloc_pci_dev();
+	pdev = pci_alloc_dev(NULL);
 	if (!pdev)
 		return -ENOMEM;
 	pdev->vendor = 0xffff;
diff --git a/drivers/char/agp/parisc-agp.c b/drivers/char/agp/parisc-agp.c
index 94821ab..bf5d247 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -333,7 +333,7 @@ parisc_agp_setup(void __iomem *ioc_hpa, void __iomem *lba_hpa)
 	struct agp_bridge_data *bridge;
 	int error = 0;
 
-	fake_bridge_dev = alloc_pci_dev();
+	fake_bridge_dev = pci_alloc_dev(NULL);
 	if (!fake_bridge_dev) {
 		error = -ENOMEM;
 		goto fail;
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index ee599f2..24134cd 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -75,18 +75,20 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
 	struct pci_dev *virtfn;
 	struct resource *res;
 	struct pci_sriov *iov = dev->sriov;
+	struct pci_bus *bus;
 
-	virtfn = alloc_pci_dev();
+	virtfn = pci_alloc_dev(NULL);
 	if (!virtfn)
 		return -ENOMEM;
 
 	mutex_lock(&iov->dev->sriov->lock);
-	virtfn->bus = virtfn_add_bus(dev->bus, virtfn_bus(dev, id));
-	if (!virtfn->bus) {
+	bus = virtfn_add_bus(dev->bus, virtfn_bus(dev, id));
+	if (!bus) {
 		kfree(virtfn);
 		mutex_unlock(&iov->dev->sriov->lock);
 		return -ENOMEM;
 	}
+	virtfn->bus = pci_bus_get(bus);
 	virtfn->devfn = virtfn_devfn(dev, id);
 	virtfn->vendor = dev->vendor;
 	pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_DID, &virtfn->device);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 4f0bc0a..bc075a3 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1131,6 +1131,7 @@ static void pci_release_dev(struct device *dev)
 	struct pci_dev *pci_dev;
 
 	pci_dev = to_pci_dev(dev);
+	pci_bus_put(pci_dev->bus);
 	pci_release_capabilities(pci_dev);
 	pci_release_of_node(pci_dev);
 	kfree(pci_dev);
@@ -1269,11 +1270,10 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 	if (!pci_bus_read_dev_vendor_id(bus, devfn, &l, 60*1000))
 		return NULL;
 
-	dev = alloc_pci_dev();
+	dev = pci_alloc_dev(bus);
 	if (!dev)
 		return NULL;
 
-	dev->bus = bus;
 	dev->devfn = devfn;
 	dev->vendor = l & 0xffff;
 	dev->device = (l >> 16) & 0xffff;
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 9504ec0..e1660ca 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -2025,7 +2025,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 static inline int
 make_local_pdev(adapter_t *adapter, struct pci_dev **pdev)
 {
-	*pdev = alloc_pci_dev();
+	*pdev = pci_alloc_dev(NULL);
 
 	if( *pdev == NULL ) return -1;
 
-- 
1.8.1.2
