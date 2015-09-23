From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [RFT v3] eata: Convert eata driver as normal PCI and platform
 device drivers
Date: Wed, 23 Sep 2015 13:24:01 +0800
Message-ID: <56023771.5010006@linux.intel.com>
References: <20150916134211.GA21535@infradead.org>
 <1442907023-12709-1-git-send-email-jiang.liu@linux.intel.com>
 <5601D550.5000801@internode.on.net>
 <1442961929.15264.4.camel@HansenPartnership.com>
 <5601E5FE.7020706@internode.on.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040804010101070809030901"
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <5601E5FE.7020706@internode.on.net>
Sender: linux-pci-owner@vger.kernel.org
To: Arthur Marsh <arthur.marsh@internode.on.net>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Hannes Reinecke <hare@suse.de>, Ballabio Dario <dario.ballabio@emc.com>, Christoph Hellwig <hch@infradead.org>, Dario Ballabio <ballabio_dario@emc.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040804010101070809030901
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 2015/9/23 7:36, Arthur Marsh wrote:
> James Bottomley wrote on 23/09/15 08:15:
>> On Wed, 2015-09-23 at 07:55 +0930, Arthur Marsh wrote:
>> It looks to be some problem in shut down.  Can you simply remove and
>> re-insert the driver successfully?  If it's your root disk driver,
>> you'll have to do this from an initrd so as not to have root mounted
>> from the eata controller.
>>
>> If the remove and reinsert fails, it means we have a problem in the
>> driver shut down.  If not, it's likely something kexec related.
>>
>> James
> 
> OK, it looks like there was a problem with unloading the driver.
> 
> After un-mounting file systems on the disk attached to the SCSI
> controller using the eata driver I could do a:
> 
> modprobe -r eata
> 
> but received the output of the attached dmesg log.
> 
> Attempting to do
> 
> modprobe eata
> 
> after the previous modprobe -r eata resulted in a complete lock-up.
Hi Arthur,
	I have found the cause of the warning messages, it's caused
by a flaw in the conversion. But according to my understanding,
it isn't related to the kexec/kdump failure. Could you please help
to test the attached new version?
Thanks!
Gerry

> 
> Arthur.

--------------040804010101070809030901
Content-Type: text/x-patch;
 name="0001-eata-Convert-eata-driver-as-normal-PCI-and-platform-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-eata-Convert-eata-driver-as-normal-PCI-and-platform-.pa";
 filename*1="tch"

>From 2231506adf7da0944fac82ec38040cc2f70562f7 Mon Sep 17 00:00:00 2001
From: Jiang Liu <jiang.liu@linux.intel.com>
Date: Tue, 22 Sep 2015 10:16:20 +0800
Subject: [Bugfix v3] eata: Convert eata driver as normal PCI and platform
 device drivers
To: Thomas Gleixner <tglx@linutronix.de>,
    Bjorn Helgaas <bhelgaas@google.com>,
    Arthur Marsh <arthur.marsh@internode.on.net>,
    Hannes Reinecke <hare@suse.de>,
    Ballabio, Dario <dario.ballabio@emc.com>,
    Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org,
    linux-pci@vger.kernel.org,
    linux-scsi@vger.kernel.org,
    x86@kernel.org

Previously the eata driver just grabs and accesses eata PCI devices
without implementing a PCI device driver, that causes troubles with
latest IRQ related

Commit 991de2e59090 ("PCI, x86: Implement pcibios_alloc_irq() and
pcibios_free_irq()") changes the way to allocate PCI legacy IRQ
for PCI devices on x86 platforms. Instead of allocating PCI legacy
IRQs when pcibios_enable_device() gets called, now pcibios_alloc_irq()
will be called by pci_device_probe() to allocate PCI legacy IRQs
when binding PCI drivers to PCI devices.

But the eata driver directly accesses PCI devices without implementing
corresponding PCI drivers, so pcibios_alloc_irq() won't be called for
those PCI devices and wrong IRQ number may be used to manage the PCI
device.

This patch implements a PCI device driver to manage eata PCI devices,
so eata driver could properly cooperate with the PCI core. It also
provides headroom for PCI hotplug with eata driver.

It also represents non-PCI eata devices as platform devices, so it could
be managed as normal devices.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ballabio, Dario <dario.ballabio@emc.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 drivers/scsi/eata.c |  451 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 272 insertions(+), 179 deletions(-)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 227dd2c2ec2f..11813a72c2e9 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -486,6 +486,8 @@
 #include <linux/interrupt.h>
 #include <linux/stat.h>
 #include <linux/pci.h>
+#include <linux/platform_device.h>
+#include <linux/idr.h>
 #include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/spinlock.h>
@@ -503,8 +505,6 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
 
-static int eata2x_detect(struct scsi_host_template *);
-static int eata2x_release(struct Scsi_Host *);
 static int eata2x_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 static int eata2x_eh_abort(struct scsi_cmnd *);
 static int eata2x_eh_host_reset(struct scsi_cmnd *);
@@ -513,9 +513,9 @@ static int eata2x_bios_param(struct scsi_device *, struct block_device *,
 static int eata2x_slave_configure(struct scsi_device *);
 
 static struct scsi_host_template driver_template = {
+	.module = THIS_MODULE,
+	.proc_name = "eata2x",
 	.name = "EATA/DMA 2.0x rev. 8.10.00 ",
-	.detect = eata2x_detect,
-	.release = eata2x_release,
 	.queuecommand = eata2x_queuecommand,
 	.eh_abort_handler = eata2x_eh_abort,
 	.eh_host_reset_handler = eata2x_eh_host_reset,
@@ -834,12 +834,10 @@ struct hostdata {
 	struct mssp sp;		/* Local copy of sp buffer */
 };
 
-static struct Scsi_Host *sh[MAX_BOARDS];
 static const char *driver_name = "EATA";
-static char sha[MAX_BOARDS];
-
-/* Initialize num_boards so that ihdlr can work while detect is in progress */
-static unsigned int num_boards = MAX_BOARDS;
+static DEFINE_IDA(eata2x_ida);
+static struct platform_device *eata2x_platform_devs[MAX_BOARDS];
+static bool eata2x_platform_driver_registered;
 
 static unsigned long io_port[] = {
 
@@ -850,10 +848,6 @@ static unsigned long io_port[] = {
 	/* First ISA */
 	0x1f0,
 
-	/* Space for MAX_PCI ports possibly reported by PCI_BIOS */
-	SKIP, SKIP, SKIP, SKIP, SKIP, SKIP, SKIP, SKIP,
-	SKIP, SKIP, SKIP, SKIP, SKIP, SKIP, SKIP, SKIP,
-
 	/* MAX_EISA ports */
 	0x1c88, 0x2c88, 0x3c88, 0x4c88, 0x5c88, 0x6c88, 0x7c88, 0x8c88,
 	0x9c88, 0xac88, 0xbc88, 0xcc88, 0xdc88, 0xec88, 0xfc88,
@@ -1024,74 +1018,42 @@ static int read_pio(unsigned long iobase, ushort * start, ushort * end)
 	return 0;
 }
 
-static struct pci_dev *get_pci_dev(unsigned long port_base)
-{
-#if defined(CONFIG_PCI)
-	unsigned int addr;
-	struct pci_dev *dev = NULL;
-
-	while ((dev = pci_get_class(PCI_CLASS_STORAGE_SCSI << 8, dev))) {
-		addr = pci_resource_start(dev, 0);
-
-#if defined(DEBUG_PCI_DETECT)
-		printk("%s: get_pci_dev, bus %d, devfn 0x%x, addr 0x%x.\n",
-		       driver_name, dev->bus->number, dev->devfn, addr);
-#endif
-
-		/* we are in so much trouble for a pci hotplug system with this driver
-		 * anyway, so doing this at least lets people unload the driver and not
-		 * cause memory problems, but in general this is a bad thing to do (this
-		 * driver needs to be converted to the proper PCI api someday... */
-		pci_dev_put(dev);
-		if (addr + PCI_BASE_ADDRESS_0 == port_base)
-			return dev;
-	}
-#endif				/* end CONFIG_PCI */
-	return NULL;
-}
-
-static void enable_pci_ports(void)
-{
-#if defined(CONFIG_PCI)
-	struct pci_dev *dev = NULL;
-
-	while ((dev = pci_get_class(PCI_CLASS_STORAGE_SCSI << 8, dev))) {
-#if defined(DEBUG_PCI_DETECT)
-		printk("%s: enable_pci_ports, bus %d, devfn 0x%x.\n",
-		       driver_name, dev->bus->number, dev->devfn);
-#endif
-
-		if (pci_enable_device(dev))
-			printk
-			    ("%s: warning, pci_enable_device failed, bus %d devfn 0x%x.\n",
-			     driver_name, dev->bus->number, dev->devfn);
-	}
-
-#endif				/* end CONFIG_PCI */
-}
-
-static int port_detect(unsigned long port_base, unsigned int j,
-		struct scsi_host_template *tpnt)
+static int port_detect(unsigned long port_base, struct device *dev)
 {
 	unsigned char irq, dma_channel, subversion, i, is_pci = 0;
 	unsigned char protocol_rev;
 	struct eata_info info;
 	char *bus_type, dma_name[16];
-	struct pci_dev *pdev;
+	struct pci_dev *pdev = NULL;
 	/* Allowed DMA channels for ISA (0 indicates reserved) */
 	unsigned char dma_channel_table[4] = { 5, 6, 7, 0 };
 	struct Scsi_Host *shost;
 	struct hostdata *ha;
 	char name[16];
+	int idx, ret = -ENODEV;
 
-	sprintf(name, "%s%d", driver_name, j);
+	idx = ida_simple_get(&eata2x_ida, 0, MAX_BOARDS, GFP_KERNEL);
+	if (idx < 0) {
+		ret = idx;
+		goto fail;
+	}
+
+	shost = scsi_host_alloc(&driver_template, sizeof(struct hostdata));
+	if (shost == NULL) {
+		dev_warn(dev, "%s: unable to alloc host, detaching.\n",
+			 driver_name);
+		ret = -ENOMEM;
+		goto freeid;
+	}
+
+	sprintf(name, "%s%d", driver_name, idx);
 
 	if (!request_region(port_base, REGION_SIZE, driver_name)) {
 #if defined(DEBUG_DETECT)
 		printk("%s: address 0x%03lx in use, skipping probe.\n", name,
 		       port_base);
 #endif
-		goto fail;
+		goto freeshost;
 	}
 
 	if (do_dma(port_base, 0, READ_CONFIG_PIO)) {
@@ -1199,15 +1161,11 @@ static int port_detect(unsigned long port_base, unsigned int j,
 		    ("%s: warning, LEVEL triggering is suggested for IRQ %u.\n",
 		     name, irq);
 
-	if (is_pci) {
-		pdev = get_pci_dev(port_base);
-		if (!pdev)
-			printk
-			    ("%s: warning, failed to get pci_dev structure.\n",
-			     name);
-	} else
-		pdev = NULL;
-
+	if (dev_is_pci(dev))
+		pdev = to_pci_dev(dev);
+	if (is_pci && !pdev)
+		dev_warn(dev, "%s: warning, failed to get pci_dev structure.\n",
+			 name);
 	if (pdev && (irq != pdev->irq)) {
 		printk("%s: IRQ %u mapped to IO-APIC IRQ %u.\n", name, irq,
 		       pdev->irq);
@@ -1217,7 +1175,7 @@ static int port_detect(unsigned long port_base, unsigned int j,
 	/* Board detected, allocate its IRQ */
 	if (request_irq(irq, do_interrupt_handler,
 			(subversion == ESA) ? IRQF_SHARED : 0,
-			driver_name, (void *)&sha[j])) {
+			driver_name, shost)) {
 		printk("%s: unable to allocate IRQ %u, detaching.\n", name,
 		       irq);
 		goto freelock;
@@ -1259,12 +1217,6 @@ static int port_detect(unsigned long port_base, unsigned int j,
 	}
 #endif
 
-	sh[j] = shost = scsi_register(tpnt, sizeof(struct hostdata));
-	if (shost == NULL) {
-		printk("%s: unable to register host, detaching.\n", name);
-		goto freedma;
-	}
-
 	shost->io_port = port_base;
 	shost->unique_id = port_base;
 	shost->n_io_port = REGION_SIZE;
@@ -1282,7 +1234,7 @@ static int port_detect(unsigned long port_base, unsigned int j,
 	ha->protocol_rev = protocol_rev;
 	ha->is_pci = is_pci;
 	ha->pdev = pdev;
-	ha->board_number = j;
+	ha->board_number = idx;
 
 	if (ha->subversion == ESA)
 		shost->unchecked_isa_dma = 0;
@@ -1350,7 +1302,7 @@ static int port_detect(unsigned long port_base, unsigned int j,
 			printk
 			    ("%s: kmalloc SGlist failed, mbox %d, detaching.\n",
 			     ha->board_name, i);
-			goto release;
+			goto free_cp_dma_addr;
 		}
 	}
 
@@ -1358,7 +1310,7 @@ static int port_detect(unsigned long port_base, unsigned int j,
 							sizeof(struct mssp),
 							&ha->sp_dma_addr))) {
 		printk("%s: pci_alloc_consistent failed, detaching.\n", ha->board_name);
-		goto release;
+		goto free_sglist;
 	}
 
 	if (max_queue_depth > MAX_TAGGED_CMD_PER_LUN)
@@ -1370,7 +1322,7 @@ static int port_detect(unsigned long port_base, unsigned int j,
 	if (tag_mode != TAG_DISABLED && tag_mode != TAG_SIMPLE)
 		tag_mode = TAG_ORDERED;
 
-	if (j == 0) {
+	if (idx == 0) {
 		printk
 		    ("EATA/DMA 2.0x: Copyright (C) 1994-2003 Dario Ballabio.\n");
 		printk
@@ -1420,21 +1372,65 @@ static int port_detect(unsigned long port_base, unsigned int j,
 			       ha->board_name);
 	}
 
-	return 1;
+	ret = scsi_add_host(shost, NULL);
+	if (!ret) {
+		dev_set_drvdata(dev, shost);
+		scsi_scan_host(shost);
+		return idx;
+	}
 
-      freedma:
+	if (ha->sp_cpu_addr)
+		pci_free_consistent(ha->pdev, sizeof(struct mssp),
+				    ha->sp_cpu_addr, ha->sp_dma_addr);
+free_sglist:
+	for (i = 0; i < shost->can_queue; i++)
+		kfree((&ha->cp[i])->sglist);
+free_cp_dma_addr:
+	for (i = 0; i < shost->can_queue; i++)
+		pci_unmap_single(ha->pdev, ha->cp[i].cp_dma_addr,
+				 sizeof(struct mscp), PCI_DMA_BIDIRECTIONAL);
+#if defined(FORCE_CONFIG)
+freedma:
 	if (subversion == ISA)
 		free_dma(dma_channel);
-      freeirq:
-	free_irq(irq, &sha[j]);
-      freelock:
+#endif
+freeirq:
+	free_irq(irq, shost);
+freelock:
 	release_region(port_base, REGION_SIZE);
-      fail:
-	return 0;
+freeshost:
+	scsi_host_put(shost);
+freeid:
+	ida_simple_remove(&eata2x_ida, idx);
+fail:
+	return ret;
+}
 
-      release:
-	eata2x_release(shost);
-	return 0;
+static void port_remove(struct device *dev)
+{
+	struct Scsi_Host *shost = dev_get_drvdata(dev);
+	struct hostdata *ha;
+	unsigned int i;
+
+	if (!shost)
+		return;
+
+	scsi_remove_host(shost);
+	ha = (struct hostdata *)shost->hostdata;
+	for (i = 0; i < shost->can_queue; i++)
+		kfree((&ha->cp[i])->sglist);
+	for (i = 0; i < shost->can_queue; i++)
+		pci_unmap_single(ha->pdev, ha->cp[i].cp_dma_addr,
+				 sizeof(struct mscp), PCI_DMA_BIDIRECTIONAL);
+	if (ha->sp_cpu_addr)
+		pci_free_consistent(ha->pdev, sizeof(struct mssp),
+				    ha->sp_cpu_addr, ha->sp_dma_addr);
+	if (shost->dma_channel != NO_DMA)
+		free_dma(shost->dma_channel);
+	free_irq(shost->irq, shost);
+	release_region(shost->io_port, shost->n_io_port);
+	ida_simple_remove(&eata2x_ida, ha->board_number);
+	scsi_host_put(shost);
 }
 
 static void internal_setup(char *str, int *ints)
@@ -1509,59 +1505,126 @@ static int option_setup(char *str)
 	return 1;
 }
 
-static void add_pci_ports(void)
+#ifdef CONFIG_PCI
+static int eata2x_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
-#if defined(CONFIG_PCI)
-	unsigned int addr, k;
-	struct pci_dev *dev = NULL;
+	int i;
+	resource_size_t addr;
+	unsigned long port_base;
+
+	if (pci_enable_device(dev)) {
+		if (config_enabled(DEBUG_PCI_DETECT))
+			pr_warn("%s: detect, bus %d, devfn 0x%x, pci_enable_device failed.\n",
+				driver_name, dev->bus->number, dev->devfn);
+		goto out_error;
+	}
 
-	for (k = 0; k < MAX_PCI; k++) {
+	addr = pci_resource_start(dev, 0);
+	port_base = addr + PCI_BASE_ADDRESS_0;
+	if (config_enabled(DEBUG_PCI_DETECT))
+		dev_dbg(&dev->dev,
+			"%s: detect, bus %d, devfn 0x%x, addr 0x%x.\n",
+			driver_name, dev->bus->number, dev->devfn,
+			(unsigned int)addr);
+
+	if (setup_done) {
+		/*
+		 * Handle kernel or module parameter
+		 * . probe board if its port is specified by user
+		 * . otherwise ignore the board
+		 */
+		for (i = 1; i < MAX_INT_PARAM; i++)
+			if (io_port[i] == port_base) {
+				io_port[i] = SKIP;
+				break;
+			}
+		if (i >= MAX_INT_PARAM)
+			goto out_disable_device;
+	}
 
-		if (!(dev = pci_get_class(PCI_CLASS_STORAGE_SCSI << 8, dev)))
-			break;
+	if (port_detect(port_base, &dev->dev) >= 0)
+		return 0;
 
-		if (pci_enable_device(dev)) {
-#if defined(DEBUG_PCI_DETECT)
-			printk
-			    ("%s: detect, bus %d, devfn 0x%x, pci_enable_device failed.\n",
-			     driver_name, dev->bus->number, dev->devfn);
-#endif
+out_disable_device:
+	pci_disable_device(dev);
+out_error:
+	return -ENXIO;
+}
 
-			continue;
-		}
+static void eata2x_pci_remove(struct pci_dev *pdev)
+{
+	port_remove(&pdev->dev);
+	pci_disable_device(pdev);
+}
 
-		addr = pci_resource_start(dev, 0);
+static struct pci_device_id eata2x_tbl[] = {
+	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_SCSI << 8, PCI_ANY_ID) },
+	{ },
+};
+MODULE_DEVICE_TABLE(pci, eata2x_tbl);
 
-#if defined(DEBUG_PCI_DETECT)
-		printk("%s: detect, seq. %d, bus %d, devfn 0x%x, addr 0x%x.\n",
-		       driver_name, k, dev->bus->number, dev->devfn, addr);
-#endif
+static struct pci_driver eata2x_pci_driver = {
+	.name		= "eata_pci",
+	.id_table	= eata2x_tbl,
+	.probe		= eata2x_pci_probe,
+	.remove		= eata2x_pci_remove,
+};
 
-		/* Order addresses according to rev_scan value */
-		io_port[MAX_INT_PARAM + (rev_scan ? (MAX_PCI - k) : (1 + k))] =
-		    addr + PCI_BASE_ADDRESS_0;
-	}
+static int eata2x_register_pci_driver(void)
+{
+	if (!pci_probe)
+		return 0;
+	if (!pci_register_driver(&eata2x_pci_driver))
+		return 1;
+	pr_warn("%s: failed to register PCI device driver.\n", driver_name);
+	return -ENODEV;
+}
 
-	pci_dev_put(dev);
-#endif				/* end CONFIG_PCI */
+static void eata2x_unregister_pci_driver(void)
+{
+	pci_unregister_driver(&eata2x_pci_driver);
 }
+#else /* CONFIG_PCI */
+static inline int eata2x_register_pci_driver(void) { return 0; }
+static inline void eata2x_unregister_pci_driver(void) {}
+#endif /* CONFIG_PCI */
 
-static int eata2x_detect(struct scsi_host_template *tpnt)
+static int __init eata2x_platform_probe(struct platform_device *pdev)
 {
-	unsigned int j = 0, k;
+	int ret = -EIO;
+	struct resource *res;
 
-	tpnt->proc_name = "eata2x";
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res)
+		dev_warn(&pdev->dev, "failed to get base IOPORT.\n");
+	else
+		ret = port_detect(res->start, &pdev->dev);
 
-	if (strlen(boot_options))
-		option_setup(boot_options);
+	return ret >= 0 ? 0 : ret;
+}
 
-#if defined(MODULE)
-	/* io_port could have been modified when loading as a module */
-	if (io_port[0] != SKIP) {
-		setup_done = 1;
-		io_port[MAX_INT_PARAM] = 0;
-	}
-#endif
+static int __exit eata2x_platform_remove(struct platform_device *pdev)
+{
+	port_remove(&pdev->dev);
+	return 0;
+}
+
+static struct platform_driver eata2x_platform_driver = {
+	.remove = __exit_p(eata2x_platform_remove),
+	.driver = {
+		.name	= "eata_plat",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int eata2x_probe_platform_devices(void)
+{
+	int k, count = 0, idx = 0, error = 0;
+	struct platform_driver *driver = &eata2x_platform_driver;
+	struct platform_device *pdev;
+	struct resource res = {
+		.flags = IORESOURCE_IO,
+	};
 
 	for (k = MAX_INT_PARAM; io_port[k]; k++)
 		if (io_port[k] == SKIP)
@@ -1574,25 +1637,86 @@ static int eata2x_detect(struct scsi_host_template *tpnt)
 			if (!eisa_probe)
 				io_port[k] = SKIP;
 		}
-
-	if (pci_probe) {
-		if (!setup_done)
-			add_pci_ports();
+	for (k = 0; error == 0 && io_port[k]; k++) {
+		if (io_port[k] == SKIP)
+			continue;
+		res.start = io_port[k];
+		res.end = io_port[k] + REGION_SIZE - 1;
+		pdev = platform_device_register_simple(driver->driver.name,
+						       idx, &res, 1);
+		if (!pdev)
+			error = -ENOMEM;
 		else
-			enable_pci_ports();
+			eata2x_platform_devs[idx++] = pdev;
+	}
+	if (error == 0) {
+		error = platform_driver_probe(driver, eata2x_platform_probe);
+		if (error == 0)
+			eata2x_platform_driver_registered = true;
+	}
+	for (k = 0; k < idx; k++) {
+		pdev = eata2x_platform_devs[k];
+		if (error || platform_get_drvdata(pdev) == NULL) {
+			platform_device_unregister(pdev);
+			eata2x_platform_devs[idx] = NULL;
+		} else {
+			count++;
+		}
 	}
 
-	for (k = 0; io_port[k]; k++) {
+	return count;
+}
 
-		if (io_port[k] == SKIP)
-			continue;
+static void eata2x_remove_platform_devices(void)
+{
+	int idx;
+	struct platform_device *pdev;
+
+	if (eata2x_platform_driver_registered) {
+		platform_driver_unregister(&eata2x_platform_driver);
+		for (idx = 0; idx < MAX_BOARDS; idx++) {
+			pdev = eata2x_platform_devs[idx];
+			if (pdev) {
+				platform_device_unregister(pdev);
+				eata2x_platform_devs[idx] = NULL;
+			}
+		}
+		eata2x_platform_driver_registered = false;
+	}
+}
+
+static int __init eata2x_init(void)
+{
+	int ret, count = 0;
 
-		if (j < MAX_BOARDS && port_detect(io_port[k], j, tpnt))
-			j++;
+	if (strlen(boot_options))
+		option_setup(boot_options);
+
+	/* io_port could have been modified when loading as a module */
+	if (config_enabled(MODULE) && io_port[0] != SKIP) {
+		setup_done = 1;
+		io_port[MAX_INT_PARAM] = 0;
 	}
 
-	num_boards = j;
-	return j;
+	ret = eata2x_register_pci_driver();
+	if (ret >= 0) {
+		count += ret;
+		ret = eata2x_probe_platform_devices();
+		if (ret > 0)
+			count += ret;
+	}
+	if (ret >= 0 && count > 0)
+		return 0;
+
+	eata2x_remove_platform_devices();
+	eata2x_unregister_pci_driver();
+	return ret < 0 ? ret : -ENODEV;
+}
+
+static void __exit eata2x_exit(void)
+{
+	eata2x_remove_platform_devices();
+	eata2x_unregister_pci_driver();
 }
 
 static void map_dma(unsigned int i, struct hostdata *ha)
@@ -2527,51 +2651,20 @@ static irqreturn_t ihdlr(struct Scsi_Host *shost)
 	return IRQ_NONE;
 }
 
-static irqreturn_t do_interrupt_handler(int dummy, void *shap)
+static irqreturn_t do_interrupt_handler(int dummy, void *data)
 {
-	struct Scsi_Host *shost;
-	unsigned int j;
+	struct Scsi_Host *shost = data;
 	unsigned long spin_flags;
 	irqreturn_t ret;
 
-	/* Check if the interrupt must be processed by this handler */
-	if ((j = (unsigned int)((char *)shap - sha)) >= num_boards)
-		return IRQ_NONE;
-	shost = sh[j];
-
 	spin_lock_irqsave(shost->host_lock, spin_flags);
 	ret = ihdlr(shost);
 	spin_unlock_irqrestore(shost->host_lock, spin_flags);
 	return ret;
 }
 
-static int eata2x_release(struct Scsi_Host *shost)
-{
-	struct hostdata *ha = (struct hostdata *)shost->hostdata;
-	unsigned int i;
-
-	for (i = 0; i < shost->can_queue; i++)
-		kfree((&ha->cp[i])->sglist);
-
-	for (i = 0; i < shost->can_queue; i++)
-		pci_unmap_single(ha->pdev, ha->cp[i].cp_dma_addr,
-				 sizeof(struct mscp), PCI_DMA_BIDIRECTIONAL);
-
-	if (ha->sp_cpu_addr)
-		pci_free_consistent(ha->pdev, sizeof(struct mssp),
-				    ha->sp_cpu_addr, ha->sp_dma_addr);
-
-	free_irq(shost->irq, &sha[ha->board_number]);
-
-	if (shost->dma_channel != NO_DMA)
-		free_dma(shost->dma_channel);
-
-	release_region(shost->io_port, shost->n_io_port);
-	scsi_unregister(shost);
-	return 0;
-}
-
-#include "scsi_module.c"
+module_init(eata2x_init);
+module_exit(eata2x_exit);
 
 #ifndef MODULE
 __setup("eata=", option_setup);
-- 
1.7.10.4


--------------040804010101070809030901--
