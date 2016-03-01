From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: [PATCH] eata: Convert eata driver as normal PCI and platform device drivers
Date: Tue,  1 Mar 2016 11:02:24 +0800
Message-ID: <1456801344-3318-1-git-send-email-jiang.liu@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dario Ballabio <ballabio_dario@emc.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Hannes Reinecke <hare@suse.de>, "Ballabio, Dario" <dario.ballabio@emc.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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
 drivers/scsi/eata.c |  624 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 342 insertions(+), 282 deletions(-)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 227dd2c2ec2f..a27a7201866d 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -486,6 +486,7 @@
 #include <linux/interrupt.h>
 #include <linux/stat.h>
 #include <linux/pci.h>
+#include <linux/platform_device.h>
 #include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/spinlock.h>
@@ -503,8 +504,6 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
 
-static int eata2x_detect(struct scsi_host_template *);
-static int eata2x_release(struct Scsi_Host *);
 static int eata2x_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 static int eata2x_eh_abort(struct scsi_cmnd *);
 static int eata2x_eh_host_reset(struct scsi_cmnd *);
@@ -513,9 +512,9 @@ static int eata2x_bios_param(struct scsi_device *, struct block_device *,
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
@@ -818,7 +817,6 @@ struct hostdata {
 	unsigned int cp_stat[MAX_MAILBOXES];	/* FREE, IN_USE, LOCKED, IN_RESET */
 	unsigned int last_cp_used;	/* Index of last mailbox used */
 	unsigned int iocount;	/* Total i/o done for this board */
-	int board_number;	/* Number of this board */
 	char board_name[16];	/* Name of this board */
 	int in_reset;		/* True if board is doing a reset */
 	int target_to[MAX_TARGET][MAX_CHANNEL];	/* N. of timeout errors on target */
@@ -834,12 +832,9 @@ struct hostdata {
 	struct mssp sp;		/* Local copy of sp buffer */
 };
 
-static struct Scsi_Host *sh[MAX_BOARDS];
 static const char *driver_name = "EATA";
-static char sha[MAX_BOARDS];
-
-/* Initialize num_boards so that ihdlr can work while detect is in progress */
-static unsigned int num_boards = MAX_BOARDS;
+static struct platform_device *eata2x_platform_devs[MAX_BOARDS];
+static bool eata2x_platform_driver_registered;
 
 static unsigned long io_port[] = {
 
@@ -850,10 +845,6 @@ static unsigned long io_port[] = {
 	/* First ISA */
 	0x1f0,
 
-	/* Space for MAX_PCI ports possibly reported by PCI_BIOS */
-	SKIP, SKIP, SKIP, SKIP, SKIP, SKIP, SKIP, SKIP,
-	SKIP, SKIP, SKIP, SKIP, SKIP, SKIP, SKIP, SKIP,
-
 	/* MAX_EISA ports */
 	0x1c88, 0x2c88, 0x3c88, 0x4c88, 0x5c88, 0x6c88, 0x7c88, 0x8c88,
 	0x9c88, 0xac88, 0xbc88, 0xcc88, 0xdc88, 0xec88, 0xfc88,
@@ -871,6 +862,18 @@ static unsigned long io_port[] = {
 #define H2DEV16(x) cpu_to_be16(x)
 #define DEV2H16(x) be16_to_cpu(x)
 
+#define dev_warn_on(dev, cond, fmt, ...)				\
+do {									\
+	if (cond)							\
+		dev_warn(dev, fmt, ##__VA_ARGS__);			\
+} while(0)
+
+#define dev_info_on(dev, cond, fmt, ...)				\
+do {									\
+	if (cond)							\
+		dev_info(dev, fmt, ##__VA_ARGS__);			\
+} while(0)
+
 /* But transfer orientation from the 16 bit data register is Little Endian */
 #define REG2H(x)   le16_to_cpu(x)
 
@@ -1024,90 +1027,43 @@ static int read_pio(unsigned long iobase, ushort * start, ushort * end)
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
-	char name[16];
+	int ret = -ENODEV;
 
-	sprintf(name, "%s%d", driver_name, j);
+	shost = scsi_host_alloc(&driver_template, sizeof(struct hostdata));
+	if (shost == NULL) {
+		dev_warn(dev, "unable to alloc host, detaching.\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
 
 	if (!request_region(port_base, REGION_SIZE, driver_name)) {
-#if defined(DEBUG_DETECT)
-		printk("%s: address 0x%03lx in use, skipping probe.\n", name,
-		       port_base);
-#endif
-		goto fail;
+		dev_warn_on(dev, config_enabled(DEBUG_DETECT),
+			    "address 0x%03lx in use, skipping probe.\n",
+			    port_base);
+		goto freeshost;
 	}
 
 	if (do_dma(port_base, 0, READ_CONFIG_PIO)) {
-#if defined(DEBUG_DETECT)
-		printk("%s: detect, do_dma failed at 0x%03lx.\n", name,
-		       port_base);
-#endif
+		dev_warn_on(dev, config_enabled(DEBUG_DETECT),
+			    "detect, do_dma failed at 0x%03lx.\n", port_base);
 		goto freelock;
 	}
 
 	/* Read the info structure */
 	if (read_pio(port_base, (ushort *) & info, (ushort *) & info.ipad[0])) {
-#if defined(DEBUG_DETECT)
-		printk("%s: detect, read_pio failed at 0x%03lx.\n", name,
-		       port_base);
-#endif
+		dev_warn_on(dev, config_enabled(DEBUG_DETECT),
+			    "detect, read_pio failed at 0x%03lx.\n", port_base);
 		goto freelock;
 	}
 
@@ -1121,16 +1077,15 @@ static int port_detect(unsigned long port_base, unsigned int j,
 
 	/* Check the controller "EATA" signature */
 	if (info.sign != EATA_SIG_BE) {
-#if defined(DEBUG_DETECT)
-		printk("%s: signature 0x%04x discarded.\n", name, info.sign);
-#endif
+		dev_warn_on(dev, config_enabled(DEBUG_DETECT),
+			    "signature 0x%04x discarded.\n", info.sign);
 		goto freelock;
 	}
 
 	if (info.data_len < EATA_2_0A_SIZE) {
-		printk
-		    ("%s: config structure size (%d bytes) too short, detaching.\n",
-		     name, info.data_len);
+		dev_warn(dev,
+			 "config structure size (%d bytes) too short, detaching.\n",
+			 info.data_len);
 		goto freelock;
 	} else if (info.data_len == EATA_2_0A_SIZE)
 		protocol_rev = 'A';
@@ -1140,7 +1095,7 @@ static int port_detect(unsigned long port_base, unsigned int j,
 		protocol_rev = 'C';
 
 	if (protocol_rev != 'A' && info.forcaddr) {
-		printk("%s: warning, port address has been forced.\n", name);
+		dev_warn(dev, "warning, port address has been forced.\n");
 		bus_type = "PCI";
 		is_pci = 1;
 		subversion = ESA;
@@ -1166,66 +1121,54 @@ static int port_detect(unsigned long port_base, unsigned int j,
 	}
 
 	if (!info.haaval || info.ata) {
-		printk
-		    ("%s: address 0x%03lx, unusable %s board (%d%d), detaching.\n",
-		     name, port_base, bus_type, info.haaval, info.ata);
+		dev_warn(dev,
+			 "address 0x%03lx, unusable %s board (%d%d), detaching.\n",
+			 port_base, bus_type, info.haaval, info.ata);
 		goto freelock;
 	}
 
 	if (info.drqvld) {
-		if (subversion == ESA)
-			printk("%s: warning, weird %s board using DMA.\n", name,
-			       bus_type);
-
+		dev_warn_on(dev, subversion == ESA,
+			    "warning, weird %s board using DMA.\n", bus_type);
 		subversion = ISA;
 		dma_channel = dma_channel_table[3 - info.drqx];
 	} else {
-		if (subversion == ISA)
-			printk("%s: warning, weird %s board not using DMA.\n",
-			       name, bus_type);
-
+		dev_warn_on(dev, subversion == ISA,
+			    "warning, weird %s board not using DMA.\n",
+			    bus_type);
 		subversion = ESA;
 		dma_channel = NO_DMA;
 	}
 
-	if (!info.dmasup)
-		printk("%s: warning, DMA protocol support not asserted.\n",
-		       name);
+	dev_warn_on(dev, !info.dmasup,
+		    "warning, DMA protocol support not asserted.\n");
 
 	irq = info.irq;
-
-	if (subversion == ESA && !info.irq_tr)
-		printk
-		    ("%s: warning, LEVEL triggering is suggested for IRQ %u.\n",
-		     name, irq);
-
-	if (is_pci) {
-		pdev = get_pci_dev(port_base);
-		if (!pdev)
-			printk
-			    ("%s: warning, failed to get pci_dev structure.\n",
-			     name);
-	} else
-		pdev = NULL;
-
+	dev_info_on(dev, subversion == ESA && !info.irq_tr,
+		    "warning, LEVEL triggering is suggested for IRQ %u.\n",
+		     irq);
+
+	if (dev_is_pci(dev))
+		pdev = to_pci_dev(dev);
+	dev_warn_on(dev, is_pci && !pdev,
+		    "warning, failed to get pci_dev structure.\n");
 	if (pdev && (irq != pdev->irq)) {
-		printk("%s: IRQ %u mapped to IO-APIC IRQ %u.\n", name, irq,
-		       pdev->irq);
+		dev_info(dev, "IRQ %u mapped to IO-APIC IRQ %u.\n",
+			 irq, pdev->irq);
 		irq = pdev->irq;
 	}
 
 	/* Board detected, allocate its IRQ */
 	if (request_irq(irq, do_interrupt_handler,
 			(subversion == ESA) ? IRQF_SHARED : 0,
-			driver_name, (void *)&sha[j])) {
-		printk("%s: unable to allocate IRQ %u, detaching.\n", name,
-		       irq);
+			driver_name, shost)) {
+		dev_warn(dev, "unable to allocate IRQ %u, detaching.\n", irq);
 		goto freelock;
 	}
 
 	if (subversion == ISA && request_dma(dma_channel, driver_name)) {
-		printk("%s: unable to allocate DMA channel %u, detaching.\n",
-		       name, dma_channel);
+		dev_warn(dev, "unable to allocate DMA channel %u, detaching.\n",
+			 dma_channel);
 		goto freeirq;
 	}
 #if defined(FORCE_CONFIG)
@@ -1237,9 +1180,8 @@ static int port_detect(unsigned long port_base, unsigned int j,
 					   &cf_dma_addr);
 
 		if (!cf) {
-			printk
-			    ("%s: config, pci_alloc_consistent failed, detaching.\n",
-			     name);
+			dev_warn(dev,
+				 "config, pci_alloc_consistent failed, detaching.\n");
 			goto freedma;
 		}
 
@@ -1248,9 +1190,8 @@ static int port_detect(unsigned long port_base, unsigned int j,
 		cf->ocena = 1;
 
 		if (do_dma(port_base, cf_dma_addr, SET_CONFIG_DMA)) {
-			printk
-			    ("%s: busy timeout sending configuration, detaching.\n",
-			     name);
+			dev_warn(dev,
+				 "busy timeout sending configuration, detaching.\n");
 			pci_free_consistent(pdev, sizeof(struct eata_config),
 					    cf, cf_dma_addr);
 			goto freedma;
@@ -1259,12 +1200,6 @@ static int port_detect(unsigned long port_base, unsigned int j,
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
@@ -1282,7 +1217,6 @@ static int port_detect(unsigned long port_base, unsigned int j,
 	ha->protocol_rev = protocol_rev;
 	ha->is_pci = is_pci;
 	ha->pdev = pdev;
-	ha->board_number = j;
 
 	if (ha->subversion == ESA)
 		shost->unchecked_isa_dma = 0;
@@ -1299,19 +1233,19 @@ static int port_detect(unsigned long port_base, unsigned int j,
 
 	}
 
-	strcpy(ha->board_name, name);
+	sprintf(ha->board_name, "%s%d", driver_name, shost->host_no);
 
 	/* DPT PM2012 does not allow to detect sg_tablesize correctly */
 	if (shost->sg_tablesize > MAX_SGLIST || shost->sg_tablesize < 2) {
-		printk("%s: detect, wrong n. of SG lists %d, fixed.\n",
-		       ha->board_name, shost->sg_tablesize);
+		dev_info(dev, "detect, wrong n. of SG lists %d, fixed.\n",
+			 shost->sg_tablesize);
 		shost->sg_tablesize = MAX_SGLIST;
 	}
 
 	/* DPT PM2012 does not allow to detect can_queue correctly */
 	if (shost->can_queue > MAX_MAILBOXES || shost->can_queue < 2) {
-		printk("%s: detect, wrong n. of mbox %d, fixed.\n",
-		       ha->board_name, shost->can_queue);
+		dev_info(dev, "detect, wrong n. of mbox %d, fixed.\n",
+			 shost->can_queue);
 		shost->can_queue = MAX_MAILBOXES;
 	}
 
@@ -1347,18 +1281,18 @@ static int port_detect(unsigned long port_base, unsigned int j,
 		gfp_t gfp_mask = (shost->unchecked_isa_dma ? GFP_DMA : 0) | GFP_ATOMIC;
 		ha->cp[i].sglist = kmalloc(sz, gfp_mask);
 		if (!ha->cp[i].sglist) {
-			printk
-			    ("%s: kmalloc SGlist failed, mbox %d, detaching.\n",
-			     ha->board_name, i);
-			goto release;
+			dev_err(dev,
+				"kmalloc SGlist failed, mbox %d, detaching.\n",
+				i);
+			goto free_cp_dma_addr;
 		}
 	}
 
 	if (!(ha->sp_cpu_addr = pci_alloc_consistent(ha->pdev,
 							sizeof(struct mssp),
 							&ha->sp_dma_addr))) {
-		printk("%s: pci_alloc_consistent failed, detaching.\n", ha->board_name);
-		goto release;
+		dev_err(dev, "pci_alloc_consistent failed, detaching.\n");
+		goto free_sglist;
 	}
 
 	if (max_queue_depth > MAX_TAGGED_CMD_PER_LUN)
@@ -1370,71 +1304,102 @@ static int port_detect(unsigned long port_base, unsigned int j,
 	if (tag_mode != TAG_DISABLED && tag_mode != TAG_SIMPLE)
 		tag_mode = TAG_ORDERED;
 
-	if (j == 0) {
-		printk
-		    ("EATA/DMA 2.0x: Copyright (C) 1994-2003 Dario Ballabio.\n");
-		printk
-		    ("%s config options -> tm:%d, lc:%c, mq:%d, rs:%c, et:%c, "
-		     "ip:%c, ep:%c, pp:%c.\n", driver_name, tag_mode,
-		     YESNO(linked_comm), max_queue_depth, YESNO(rev_scan),
-		     YESNO(ext_tran), YESNO(isa_probe), YESNO(eisa_probe),
-		     YESNO(pci_probe));
-	}
-
-	printk("%s: 2.0%c, %s 0x%03lx, IRQ %u, %s, SG %d, MB %d.\n",
-	       ha->board_name, ha->protocol_rev, bus_type,
-	       (unsigned long)shost->io_port, shost->irq, dma_name,
-	       shost->sg_tablesize, shost->can_queue);
-
-	if (shost->max_id > 8 || shost->max_lun > 8)
-		printk
-		    ("%s: wide SCSI support enabled, max_id %u, max_lun %llu.\n",
-		     ha->board_name, shost->max_id, shost->max_lun);
+	dev_info_once(dev,
+		      "EATA/DMA 2.0x: Copyright (C) 1994-2003 Dario Ballabio.\n");
+	dev_info_once(dev,
+		      "config options -> tm:%d, lc:%c, mq:%d, rs:%c, et:%c, ip:%c, ep:%c, pp:%c.\n",
+		      tag_mode, YESNO(linked_comm), max_queue_depth,
+		      YESNO(rev_scan), YESNO(ext_tran), YESNO(isa_probe),
+		      YESNO(eisa_probe), YESNO(pci_probe));
+
+	dev_info(dev, "2.0%c, %s 0x%03lx, IRQ %u, %s, SG %d, MB %d.\n",
+		 ha->protocol_rev, bus_type, (unsigned long)shost->io_port,
+		 shost->irq, dma_name, shost->sg_tablesize, shost->can_queue);
+	dev_info_on(dev, shost->max_id > 8 || shost->max_lun > 8,
+		    "wide SCSI support enabled, max_id %u, max_lun %llu.\n",
+		     shost->max_id, shost->max_lun);
 
 	for (i = 0; i <= shost->max_channel; i++)
-		printk("%s: SCSI channel %u enabled, host target ID %d.\n",
-		       ha->board_name, i, info.host_addr[3 - i]);
-
-#if defined(DEBUG_DETECT)
-	printk("%s: Vers. 0x%x, ocs %u, tar %u, trnxfr %u, more %u, SYNC 0x%x, "
-	       "sec. %u, infol %d, cpl %d spl %d.\n", name, info.version,
-	       info.ocsena, info.tarsup, info.trnxfr, info.morsup, info.sync,
-	       info.second, info.data_len, info.cp_len, info.sp_len);
-
-	if (protocol_rev == 'B' || protocol_rev == 'C')
-		printk("%s: isaena %u, forcaddr %u, max_id %u, max_chan %u, "
-		       "large_sg %u, res1 %u.\n", name, info.isaena,
-		       info.forcaddr, info.max_id, info.max_chan, info.large_sg,
-		       info.res1);
-
-	if (protocol_rev == 'C')
-		printk("%s: max_lun %u, m1 %u, idquest %u, pci %u, eisa %u, "
-		       "raidnum %u.\n", name, info.max_lun, info.m1,
-		       info.idquest, info.pci, info.eisa, info.raidnum);
-#endif
+		dev_info(dev, "SCSI channel %u enabled, host target ID %d.\n",
+			 i, info.host_addr[3 - i]);
+
+	dev_info_on(dev, config_enabled(DEBUG_DETECT),
+		    "Vers. 0x%x, ocs %u, tar %u, trnxfr %u, more %u, SYNC 0x%x, sec. %u, infol %d, cpl %d spl %d.\n",
+		    info.version, info.ocsena, info.tarsup, info.trnxfr,
+		    info.morsup, info.sync, info.second, info.data_len,
+		    info.cp_len, info.sp_len);
+	dev_info_on(dev, config_enabled(DEBUG_DETECT) &&
+			 (protocol_rev == 'B' || protocol_rev == 'C'),
+		    "isaena %u, forcaddr %u, max_id %u, max_chan %u, large_sg %u, res1 %u.\n",
+		    info.isaena, info.forcaddr, info.max_id, info.max_chan,
+		    info.large_sg, info.res1);
+	dev_info_on(dev, config_enabled(DEBUG_DETECT) && protocol_rev == 'C',
+		    "max_lun %u, m1 %u, idquest %u, pci %u, eisa %u, raidnum %u.\n",
+		    info.max_lun, info.m1, info.idquest, info.pci, info.eisa,
+		    info.raidnum);
 
 	if (ha->pdev) {
 		pci_set_master(ha->pdev);
 		if (pci_set_dma_mask(ha->pdev, DMA_BIT_MASK(32)))
-			printk("%s: warning, pci_set_dma_mask failed.\n",
-			       ha->board_name);
+			dev_warn(dev, "warning, pci_set_dma_mask failed.\n");
 	}
 
-	return 1;
+	ret = scsi_add_host(shost, NULL);
+	if (!ret) {
+		dev_set_drvdata(dev, shost);
+		scsi_scan_host(shost);
+		return 0;
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
+	scsi_host_put(shost);
 }
 
 static void internal_setup(char *str, int *ints)
@@ -1509,59 +1474,124 @@ static int option_setup(char *str)
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
+		dev_warn_on(&dev->dev, config_enabled(DEBUG_PCI_DETECT),
+			    "detect, bus %d, devfn 0x%x, pci_enable_device failed.\n",
+			    dev->bus->number, dev->devfn);
+		goto out_error;
+	}
 
-	for (k = 0; k < MAX_PCI; k++) {
+	addr = pci_resource_start(dev, 0);
+	port_base = addr + PCI_BASE_ADDRESS_0;
+	dev_info_on(&dev->dev, config_enabled(DEBUG_PCI_DETECT),
+		    "detect, bus %d, devfn 0x%x, addr 0x%x.\n",
+		    dev->bus->number, dev->devfn, (unsigned int)addr);
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
+	pr_warn("failed to register PCI device driver.\n");
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
@@ -1574,25 +1604,86 @@ static int eata2x_detect(struct scsi_host_template *tpnt)
 			if (!eisa_probe)
 				io_port[k] = SKIP;
 		}
-
-	if (pci_probe) {
-		if (!setup_done)
-			add_pci_ports();
+	for (k = 0; !error && io_port[k]; k++) {
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
+	if (!error) {
+		error = platform_driver_probe(driver, eata2x_platform_probe);
+		if (!error)
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
+
+	if (strlen(boot_options))
+		option_setup(boot_options);
+
+	/* io_port could have been modified when loading as a module */
+	if (config_enabled(MODULE) && io_port[0] != SKIP) {
+		setup_done = 1;
+		io_port[MAX_INT_PARAM] = 0;
+	}
 
-		if (j < MAX_BOARDS && port_detect(io_port[k], j, tpnt))
-			j++;
+	ret = eata2x_register_pci_driver();
+	if (ret >= 0) {
+		count += ret;
+		ret = eata2x_probe_platform_devices();
+		if (ret > 0)
+			count += ret;
 	}
+	if (ret >= 0 && count > 0)
+		return 0;
+
+	eata2x_remove_platform_devices();
+	eata2x_unregister_pci_driver();
+	return ret < 0 ? ret : -ENODEV;
+}
 
-	num_boards = j;
-	return j;
+static void __exit eata2x_exit(void)
+{
+	eata2x_remove_platform_devices();
+	eata2x_unregister_pci_driver();
 }
 
 static void map_dma(unsigned int i, struct hostdata *ha)
@@ -2527,51 +2618,20 @@ static irqreturn_t ihdlr(struct Scsi_Host *shost)
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
