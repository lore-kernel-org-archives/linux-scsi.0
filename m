From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [RFT v3] eata: Convert eata driver as normal PCI and platform
 device drivers
Date: Thu, 24 Sep 2015 12:28:57 +0800
Message-ID: <56037C09.5050201@linux.intel.com>
References: <20150916134211.GA21535@infradead.org>
 <1442907023-12709-1-git-send-email-jiang.liu@linux.intel.com>
 <5601D550.5000801@internode.on.net>
 <1442961929.15264.4.camel@HansenPartnership.com>
 <5601E5FE.7020706@internode.on.net> <56023771.5010006@linux.intel.com>
 <5602829C.5090500@internode.on.net>
 <1443019207.2240.27.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000304080807000203050805"
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1443019207.2240.27.camel@HansenPartnership.com>
Sender: linux-pci-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Hannes Reinecke <hare@suse.de>, Ballabio Dario <dario.ballabio@emc.com>, Christoph Hellwig <hch@infradead.org>, Dario Ballabio <ballabio_dario@emc.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000304080807000203050805
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 2015/9/23 22:40, James Bottomley wrote:
> On Wed, 2015-09-23 at 20:14 +0930, Arthur Marsh wrote:
>>
>> Jiang Liu wrote on 23/09/15 14:54:
>>
>>> Hi Arthur,
>>> 	I have found the cause of the warning messages, it's caused
>>> by a flaw in the conversion. But according to my understanding,
>>> it isn't related to the kexec/kdump failure. Could you please help
>>> to test the attached new version?
>>> Thanks!
>>> Gerry
>>>
>>
>> Thanks, the patch worked, I could successfully unload and reload the 
>> eata module, and perform a kexec reboot with the eata module loading 
>> successfully afterwards.
> 
> Great, so the bug was unconditionally unregistering the platform driver
> when it would fail to attach if none of the legacy IO ports were
> detected.
> 
> I think the driver needs a bit of a tidy up.  There's no need at all to
> use ida_get_simple(): the only reason for a dense array of numbers was
> for storing the hba private data in the array you got rid of; we can now
> simply use shost->host_no ... it's more useful anyway because the
> numbers match those SCSI is using.
> 
> Also, if you insist on converting the printk's to dev warn, you no
> longer need to print out the driver name ... dev_printk already prints
> out the device and driver name as the prefix.
> 
> The if (error == 0) is usually written as if (!error) but that's minor.
Hi James,
	Thanks for review. How about the attached patch which addresses
the three suggestions from you?
Thanks!
Gerry


> 
> Thanks for doing the conversion,
> 
> James
> 
> 

--------------000304080807000203050805
Content-Type: text/x-patch;
 name="0001-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-.patch"

>From aeb4859ff2c86434814cfc88f1a36481f3dcbc86 Mon Sep 17 00:00:00 2001
From: Jiang Liu <jiang.liu@linux.intel.com>
Date: Thu, 24 Sep 2015 12:24:33 +0800
Subject: [PATCH]


Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/scsi/eata.c |  234 +++++++++++++++++++++------------------------------
 1 file changed, 97 insertions(+), 137 deletions(-)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 11813a72c2e9..ceeba4d7b4ff 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -487,7 +487,6 @@
 #include <linux/stat.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
-#include <linux/idr.h>
 #include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/spinlock.h>
@@ -818,7 +817,6 @@ struct hostdata {
 	unsigned int cp_stat[MAX_MAILBOXES];	/* FREE, IN_USE, LOCKED, IN_RESET */
 	unsigned int last_cp_used;	/* Index of last mailbox used */
 	unsigned int iocount;	/* Total i/o done for this board */
-	int board_number;	/* Number of this board */
 	char board_name[16];	/* Name of this board */
 	int in_reset;		/* True if board is doing a reset */
 	int target_to[MAX_TARGET][MAX_CHANNEL];	/* N. of timeout errors on target */
@@ -835,7 +833,6 @@ struct hostdata {
 };
 
 static const char *driver_name = "EATA";
-static DEFINE_IDA(eata2x_ida);
 static struct platform_device *eata2x_platform_devs[MAX_BOARDS];
 static bool eata2x_platform_driver_registered;
 
@@ -864,6 +861,10 @@ static unsigned long io_port[] = {
 #define DEV2H(x)   be32_to_cpu(x)
 #define H2DEV16(x) cpu_to_be16(x)
 #define DEV2H16(x) be16_to_cpu(x)
+#define dev_warn_on(dev, cond, fmt, ...)	\
+	if (cond) dev_warn(dev, fmt, ##__VA_ARGS__)
+#define dev_info_on(dev, cond, fmt, ...)	\
+	if (cond) dev_info(dev, fmt, ##__VA_ARGS__)
 
 /* But transfer orientation from the 16 bit data register is Little Endian */
 #define REG2H(x)   le16_to_cpu(x)
@@ -1029,47 +1030,32 @@ static int port_detect(unsigned long port_base, struct device *dev)
 	unsigned char dma_channel_table[4] = { 5, 6, 7, 0 };
 	struct Scsi_Host *shost;
 	struct hostdata *ha;
-	char name[16];
-	int idx, ret = -ENODEV;
-
-	idx = ida_simple_get(&eata2x_ida, 0, MAX_BOARDS, GFP_KERNEL);
-	if (idx < 0) {
-		ret = idx;
-		goto fail;
-	}
+	int ret = -ENODEV;
 
 	shost = scsi_host_alloc(&driver_template, sizeof(struct hostdata));
 	if (shost == NULL) {
-		dev_warn(dev, "%s: unable to alloc host, detaching.\n",
-			 driver_name);
+		dev_warn(dev, "unable to alloc host, detaching.\n");
 		ret = -ENOMEM;
-		goto freeid;
+		goto fail;
 	}
 
-	sprintf(name, "%s%d", driver_name, idx);
-
 	if (!request_region(port_base, REGION_SIZE, driver_name)) {
-#if defined(DEBUG_DETECT)
-		printk("%s: address 0x%03lx in use, skipping probe.\n", name,
-		       port_base);
-#endif
+		dev_warn_on(dev, config_enabled(DEBUG_DETECT),
+			    "address 0x%03lx in use, skipping probe.\n",
+			    port_base);
 		goto freeshost;
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
 
@@ -1083,16 +1069,15 @@ static int port_detect(unsigned long port_base, struct device *dev)
 
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
@@ -1102,7 +1087,7 @@ static int port_detect(unsigned long port_base, struct device *dev)
 		protocol_rev = 'C';
 
 	if (protocol_rev != 'A' && info.forcaddr) {
-		printk("%s: warning, port address has been forced.\n", name);
+		dev_warn(dev, "warning, port address has been forced.\n");
 		bus_type = "PCI";
 		is_pci = 1;
 		subversion = ESA;
@@ -1128,47 +1113,40 @@ static int port_detect(unsigned long port_base, struct device *dev)
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
+	dev_info_on(dev, subversion == ESA && !info.irq_tr,
+		    "warning, LEVEL triggering is suggested for IRQ %u.\n",
+		     irq);
 
 	if (dev_is_pci(dev))
 		pdev = to_pci_dev(dev);
-	if (is_pci && !pdev)
-		dev_warn(dev, "%s: warning, failed to get pci_dev structure.\n",
-			 name);
+	dev_warn_on(dev, is_pci && !pdev,
+		    "warning, failed to get pci_dev structure.\n");
 	if (pdev && (irq != pdev->irq)) {
-		printk("%s: IRQ %u mapped to IO-APIC IRQ %u.\n", name, irq,
-		       pdev->irq);
+		dev_info(dev, "IRQ %u mapped to IO-APIC IRQ %u.\n",
+			 irq, pdev->irq);
 		irq = pdev->irq;
 	}
 
@@ -1176,14 +1154,13 @@ static int port_detect(unsigned long port_base, struct device *dev)
 	if (request_irq(irq, do_interrupt_handler,
 			(subversion == ESA) ? IRQF_SHARED : 0,
 			driver_name, shost)) {
-		printk("%s: unable to allocate IRQ %u, detaching.\n", name,
-		       irq);
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
@@ -1195,9 +1172,8 @@ static int port_detect(unsigned long port_base, struct device *dev)
 					   &cf_dma_addr);
 
 		if (!cf) {
-			printk
-			    ("%s: config, pci_alloc_consistent failed, detaching.\n",
-			     name);
+			dev_warn(dev,
+				 "config, pci_alloc_consistent failed, detaching.\n");
 			goto freedma;
 		}
 
@@ -1206,9 +1182,8 @@ static int port_detect(unsigned long port_base, struct device *dev)
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
@@ -1234,7 +1209,6 @@ static int port_detect(unsigned long port_base, struct device *dev)
 	ha->protocol_rev = protocol_rev;
 	ha->is_pci = is_pci;
 	ha->pdev = pdev;
-	ha->board_number = idx;
 
 	if (ha->subversion == ESA)
 		shost->unchecked_isa_dma = 0;
@@ -1251,19 +1225,19 @@ static int port_detect(unsigned long port_base, struct device *dev)
 
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
 
@@ -1299,9 +1273,9 @@ static int port_detect(unsigned long port_base, struct device *dev)
 		gfp_t gfp_mask = (shost->unchecked_isa_dma ? GFP_DMA : 0) | GFP_ATOMIC;
 		ha->cp[i].sglist = kmalloc(sz, gfp_mask);
 		if (!ha->cp[i].sglist) {
-			printk
-			    ("%s: kmalloc SGlist failed, mbox %d, detaching.\n",
-			     ha->board_name, i);
+			dev_err(dev,
+				"kmalloc SGlist failed, mbox %d, detaching.\n",
+				i);
 			goto free_cp_dma_addr;
 		}
 	}
@@ -1309,7 +1283,7 @@ static int port_detect(unsigned long port_base, struct device *dev)
 	if (!(ha->sp_cpu_addr = pci_alloc_consistent(ha->pdev,
 							sizeof(struct mssp),
 							&ha->sp_dma_addr))) {
-		printk("%s: pci_alloc_consistent failed, detaching.\n", ha->board_name);
+		dev_err(dev, "pci_alloc_consistent failed, detaching.\n");
 		goto free_sglist;
 	}
 
@@ -1322,61 +1296,52 @@ static int port_detect(unsigned long port_base, struct device *dev)
 	if (tag_mode != TAG_DISABLED && tag_mode != TAG_SIMPLE)
 		tag_mode = TAG_ORDERED;
 
-	if (idx == 0) {
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
+		      "config options -> tm:%d, lc:%c, mq:%d, rs:%c, et:%c, "
+		      "ip:%c, ep:%c, pp:%c.\n", tag_mode, YESNO(linked_comm),
+		      max_queue_depth, YESNO(rev_scan), YESNO(ext_tran),
+		      YESNO(isa_probe), YESNO(eisa_probe), YESNO(pci_probe));
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
+		    "Vers. 0x%x, ocs %u, tar %u, trnxfr %u, more %u, SYNC 0x%x, "
+		    "sec. %u, infol %d, cpl %d spl %d.\n", info.version,
+		    info.ocsena, info.tarsup, info.trnxfr, info.morsup,
+		    info.sync, info.second, info.data_len, info.cp_len,
+		    info.sp_len);
+	dev_info_on(dev, config_enabled(DEBUG_DETECT) &&
+			 (protocol_rev == 'B' || protocol_rev == 'C'),
+		    "isaena %u, forcaddr %u, max_id %u, max_chan %u, "
+		    "large_sg %u, res1 %u.\n", info.isaena, info.forcaddr,
+		    info.max_id, info.max_chan, info.large_sg, info.res1);
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
 
 	ret = scsi_add_host(shost, NULL);
 	if (!ret) {
 		dev_set_drvdata(dev, shost);
 		scsi_scan_host(shost);
-		return idx;
+		return 0;
 	}
 
 	if (ha->sp_cpu_addr)
@@ -1400,8 +1365,6 @@ freelock:
 	release_region(port_base, REGION_SIZE);
 freeshost:
 	scsi_host_put(shost);
-freeid:
-	ida_simple_remove(&eata2x_ida, idx);
 fail:
 	return ret;
 }
@@ -1429,7 +1392,6 @@ static void port_remove(struct device *dev)
 		free_dma(shost->dma_channel);
 	free_irq(shost->irq, shost);
 	release_region(shost->io_port, shost->n_io_port);
-	ida_simple_remove(&eata2x_ida, ha->board_number);
 	scsi_host_put(shost);
 }
 
@@ -1513,19 +1475,17 @@ static int eata2x_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	unsigned long port_base;
 
 	if (pci_enable_device(dev)) {
-		if (config_enabled(DEBUG_PCI_DETECT))
-			pr_warn("%s: detect, bus %d, devfn 0x%x, pci_enable_device failed.\n",
-				driver_name, dev->bus->number, dev->devfn);
+		dev_warn_on(&dev->dev, config_enabled(DEBUG_PCI_DETECT),
+			    "detect, bus %d, devfn 0x%x, pci_enable_device failed.\n",
+			    dev->bus->number, dev->devfn);
 		goto out_error;
 	}
 
 	addr = pci_resource_start(dev, 0);
 	port_base = addr + PCI_BASE_ADDRESS_0;
-	if (config_enabled(DEBUG_PCI_DETECT))
-		dev_dbg(&dev->dev,
-			"%s: detect, bus %d, devfn 0x%x, addr 0x%x.\n",
-			driver_name, dev->bus->number, dev->devfn,
-			(unsigned int)addr);
+	dev_info_on(&dev->dev, config_enabled(DEBUG_PCI_DETECT),
+		    "detect, bus %d, devfn 0x%x, addr 0x%x.\n",
+		    dev->bus->number, dev->devfn, (unsigned int)addr);
 
 	if (setup_done) {
 		/*
@@ -1576,7 +1536,7 @@ static int eata2x_register_pci_driver(void)
 		return 0;
 	if (!pci_register_driver(&eata2x_pci_driver))
 		return 1;
-	pr_warn("%s: failed to register PCI device driver.\n", driver_name);
+	pr_warn("failed to register PCI device driver.\n");
 	return -ENODEV;
 }
 
@@ -1637,7 +1597,7 @@ static int eata2x_probe_platform_devices(void)
 			if (!eisa_probe)
 				io_port[k] = SKIP;
 		}
-	for (k = 0; error == 0 && io_port[k]; k++) {
+	for (k = 0; !error && io_port[k]; k++) {
 		if (io_port[k] == SKIP)
 			continue;
 		res.start = io_port[k];
@@ -1649,9 +1609,9 @@ static int eata2x_probe_platform_devices(void)
 		else
 			eata2x_platform_devs[idx++] = pdev;
 	}
-	if (error == 0) {
+	if (!error) {
 		error = platform_driver_probe(driver, eata2x_platform_probe);
-		if (error == 0)
+		if (!error)
 			eata2x_platform_driver_registered = true;
 	}
 	for (k = 0; k < idx; k++) {
-- 
1.7.10.4


--------------000304080807000203050805--
