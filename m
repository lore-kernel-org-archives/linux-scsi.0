From: Christoph Hellwig <hch@lst.de>
Subject: Re: areca RAID driver
Date: Thu, 20 Apr 2006 21:48:31 +0200
Message-ID: <20060420194831.GA7923@lst.de>
References: <20060419155300.321c352e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:58318 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751169AbWDTTs6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Apr 2006 15:48:58 -0400
Content-Disposition: inline
In-Reply-To: <20060419155300.321c352e.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@suse.de>, erich <erich@areca.com.tw>, billion.wu@areca.com.tw, linux-scsi@vger.kernel.org

On Wed, Apr 19, 2006 at 03:53:00PM -0700, Andrew Morton wrote:
> 
> Gents, Erich thinks that the Areca driver is pretty much ready to go.
> 
> We still have the weird read-past-EOF problem if MAX_XFER_SECTORS=4096, but
> this version of the driver has it set to 512, which makes the problem go
> away.  I've suggested that we can set that problem aside for now.
> 
> I've put a copy of the latest diff at
> http://www.zip.com.au/~akpm/linux/patches/stuff/areca-raid-linux-scsi-driver.patch.
>  Could you please take a look sometime, decide how we should proceed?

It still doesn't address lots of the month-old comments.

Serious stuff:
 - doesn't follow one value per file in sysfs rule
 - arcmsr_device_probe (which should really be called arcmsr_probe!)
   doesn't propagate the pci_enable_device return value
 - ditto  for request_irq
 - please do proper goto unwinding in arcmsr_device_probe instead of
   calling arcmsr_pcidev_disattach in various places
 - arcmsr_report_sense_info is buggy.  all scsi-commands are S/G lists
   now.
 - pleaase don't put that odd "linux bug" workaround into
   arcmsr_queue_command.  If you can reproduce that bug please report it
   and we'll fix it.
 - the target 16 inquiry emulation is broken for the same reasons as the
   report_luns one above.  Care to explain why you need it at all?
 - I can't see any endianess handling in the whole driver.  Was this
   tested on a BE platform like powerpc?
 - the probe path is doing mmio access before pci_request_regions.
 - scsi_remove_host is called far too late
 - dma_addr_ts are casted to unsigned longs which doesn't work
   with 64bit dma and 32bit plattforms

Cosmetical stuff:

 - odd formated comments instead of kerneldoc / per CondingStyle
 - very odd variable naming, lots of uppercase and p prefixes
 - please kill all these useless forward-declarations and format
   the code in the natural call flow
 - the consistent_dma_mask is 32bits by default, not need to call
   pci_set_consistent_dma_mask


And there's probably a lot more issues.  Below is a patch that tries to
cleanup the pci driver entry points according to the above list.  Due
to all this moving things around it's pretty huge.


Index: hch/areca/drivers/scsi/arcmsr/arcmsr_hba.c
===================================================================
--- hch.orig/areca/drivers/scsi/arcmsr/arcmsr_hba.c	2006-04-20 21:05:10.000000000 +0200
+++ hch/areca/drivers/scsi/arcmsr/arcmsr_hba.c	2006-04-20 21:46:49.000000000 +0200
@@ -75,7 +73,6 @@
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 
-static int arcmsr_initialize(struct AdapterControlBlock *pACB, struct pci_dev *pdev);
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *pACB, struct scsi_cmnd *cmd);
 static int arcmsr_cmd_abort(struct scsi_cmnd *);
 static int arcmsr_bus_reset(struct scsi_cmnd *);
@@ -83,12 +80,6 @@
 				struct block_device *bdev, sector_t capacity, int *info);
 static int arcmsr_queue_command(struct scsi_cmnd * cmd,
 				void (*done) (struct scsi_cmnd *));
-static int arcmsr_device_probe(struct pci_dev *pdev,
-				const struct pci_device_id *id);
-static void arcmsr_device_remove(struct pci_dev *pdev);
-static void arcmsr_device_shutdown(struct pci_dev *pdev);
-static void arcmsr_pcidev_disattach(struct AdapterControlBlock *pACB);
-static void arcmsr_iop_init(struct AdapterControlBlock *pACB);
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *pACB);
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *pACB);
 static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *pACB);
@@ -121,33 +112,6 @@
 	.shost_attrs		= arcmsr_host_attrs,
 };
 
-static struct pci_device_id arcmsr_device_id_table[] = {
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1110)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1120)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1130)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1160)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1170)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1210)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1220)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1230)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1260)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1270)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1280)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1380)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1381)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1680)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1681)},
-	{0, 0}, /* Terminating entry */
-};
-MODULE_DEVICE_TABLE(pci, arcmsr_device_id_table);
-static struct pci_driver arcmsr_pci_driver = {
-	.name			= "arcmsr",
-	.id_table		= arcmsr_device_id_table,
-	.probe			= arcmsr_device_probe,
-	.remove			= arcmsr_device_remove,
-	.shutdown		= arcmsr_device_shutdown
-};
-
 static irqreturn_t arcmsr_do_interrupt(int irq, void *dev_id,
 	struct pt_regs *regs)
 {
@@ -191,56 +155,218 @@
 	return 0;
 }
 
-static int arcmsr_device_probe(struct pci_dev *pdev,
-	const struct pci_device_id *id)
+static void arcmsr_pci_unmap_dma(struct CommandControlBlock *pCCB)
 {
-	struct Scsi_Host *host;
-	struct AdapterControlBlock *pACB;
-	uint8_t bus, dev_fun;
+	struct AdapterControlBlock *acb = pCCB->pACB;
+	struct scsi_cmnd *pcmd = pCCB->pcmd;
 
-	if (pci_enable_device(pdev)) {
-		printk(KERN_NOTICE
-		"arcmsr: adapter probe pci_enable_device error \n");
-		return -ENODEV;
+	if (pcmd->use_sg != 0) {
+		struct scatterlist *sl;
+
+		sl = (struct scatterlist *)pcmd->request_buffer;
+		pci_unmap_sg(acb->pdev, sl, pcmd->use_sg, pcmd->sc_data_direction);
 	}
-	host = scsi_host_alloc(&arcmsr_scsi_host_template, sizeof (struct AdapterControlBlock));
-	if (!host) {
-		printk(KERN_NOTICE
-		"arcmsr: adapter probe scsi_host_alloc error \n");
-		pci_disable_device(pdev);
-		return -ENODEV;
-	}
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK))
-		printk(KERN_INFO
-		"ARECA RAID ADAPTER%d: 64BITS PCI BUS DMA ADDRESSING SUPPORTED\n"
-		, host->host_no);
-	else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK))
-		printk(KERN_INFO
-		"ARECA RAID ADAPTER%d: 32BITS PCI BUS DMA ADDRESSING SUPPORTED\n"
-		, host->host_no);
-	else {
+	else if (pcmd->request_bufflen != 0)
+		pci_unmap_single(acb->pdev,
+			(dma_addr_t)(unsigned long)pcmd->SCp.ptr,
+			pcmd->request_bufflen, pcmd->sc_data_direction);
+}
+
+static void arcmsr_ccb_complete(struct CommandControlBlock *pCCB, int stand_flag)
+{
+	struct AdapterControlBlock *acb = pCCB->pACB;
+	struct scsi_cmnd *pcmd = pCCB->pcmd;
+
+	arcmsr_pci_unmap_dma(pCCB);
+	if (stand_flag == 1)
+		atomic_dec(&acb->ccboutstandingcount);
+	pCCB->startdone = ARCMSR_CCB_DONE;
+	pCCB->ccb_flags = 0;
+	list_add_tail(&pCCB->list, &acb->ccb_free_list);
+	pcmd->scsi_done(pcmd);
+}
+
+static void arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit __iomem *reg = acb->pmu;
+	char *acb_firm_model = acb->firm_model;
+	char *acb_firm_version = acb->firm_version;
+	char __iomem *iop_firm_model = (char __iomem *) &reg->message_rwbuffer[15];
+	char __iomem *iop_firm_version = (char __iomem *) &reg->message_rwbuffer[17];
+	int count;
+
+	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
+	if (arcmsr_wait_msgint_ready(acb))
 		printk(KERN_NOTICE
-		"ARECA RAID ADAPTER%d: No suitable DMA available.\n"
-		, host->host_no);
-		pci_disable_device(pdev);
-		scsi_host_put(host);
-		return -ENOMEM;
+			"arcmsr%d: wait "
+			"'get adapter firmware miscellaneous data' timeout \n",
+			acb->host->host_no);
+	count = 8;
+	while (count) {
+		*acb_firm_model = readb(iop_firm_model);
+		acb_firm_model++;
+		iop_firm_model++;
+		count--;
 	}
-	if (pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
-		printk(KERN_NOTICE
-		"ARECA RAID ADAPTER%d:"
-		" No 32BIT coherent DMA adressing available\n"
-		, host->host_no);
-		pci_disable_device(pdev);
-		scsi_host_put(host);
+	count = 16;
+	while (count) {
+		*acb_firm_version = readb(iop_firm_version);
+		acb_firm_version++;
+		iop_firm_version++;
+		count--;
+	}
+
+	acb->firm_request_len = readl(&reg->message_rwbuffer[1]);
+	acb->firm_numbers_queue = readl(&reg->message_rwbuffer[2]);
+	acb->firm_sdram_size = readl(&reg->message_rwbuffer[3]);
+	acb->firm_hd_channels = readl(&reg->message_rwbuffer[4]);
+}
+
+
+static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
+{
+	struct pci_dev *pdev = acb->pdev;
+	struct MessageUnit __iomem *reg = acb->pmu;
+	u32 ccb_phyaddr_hi32;
+	void *dma_coherent;
+	dma_addr_t dma_coherent_handle, dma_addr;
+	struct CommandControlBlock *pccb_tmp;
+	int i, j;
+
+	dma_coherent = dma_alloc_coherent(&pdev->dev,
+			ARCMSR_MAX_FREECCB_NUM *
+			sizeof (struct CommandControlBlock) + 0x20,
+			&dma_coherent_handle, GFP_KERNEL);
+	if (!dma_coherent)
 		return -ENOMEM;
+
+	acb->dma_coherent = dma_coherent;
+	acb->dma_coherent_handle = dma_coherent_handle;
+
+	if (((unsigned long)dma_coherent & 0x1F)) {
+		dma_coherent = dma_coherent +
+			(0x20 - ((unsigned long)dma_coherent & 0x1F));
+		dma_coherent_handle = dma_coherent_handle +
+			(0x20 - ((unsigned long)dma_coherent_handle & 0x1F));
+	}
+
+	dma_addr = dma_coherent_handle;
+	pccb_tmp = (struct CommandControlBlock *)dma_coherent;
+	for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+		pccb_tmp->cdb_shifted_phyaddr = dma_addr >> 5;
+		pccb_tmp->pACB = acb;
+		acb->pccb_pool[i] = pccb_tmp;
+		list_add_tail(&pccb_tmp->list, &acb->ccb_free_list);
+		dma_addr = dma_addr + sizeof (struct CommandControlBlock);
+		pccb_tmp++;
+	}
+
+	acb->vir2phy_offset = (unsigned long)pccb_tmp -
+			      (unsigned long)dma_addr;
+	for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
+		for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
+			acb->devstate[i][j] = ARECA_RAID_GOOD;
+
+	/*
+	 * here we need to tell iop 331 our pccb_tmp.HighPart
+	 * if pccb_tmp.HighPart is not zero
+	 */
+	ccb_phyaddr_hi32 = (uint32_t) ((dma_coherent_handle >> 16) >> 16);
+	if (ccb_phyaddr_hi32 != 0) {
+		writel(ARCMSR_SIGNATURE_SET_CONFIG, &reg->message_rwbuffer[0]);
+		writel(ccb_phyaddr_hi32, &reg->message_rwbuffer[1]);
+		writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);
+		if (arcmsr_wait_msgint_ready(acb))
+			printk(KERN_NOTICE "arcmsr%d: "
+			       "'set ccb high part physical address' timeout\n",
+				acb->host->host_no);
+	}
+
+	writel(readl(&reg->outbound_intmask) |
+			ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE,
+	       &reg->outbound_intmask);
+	return 0;
+}
+
+static void arcmsr_iop_init(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit __iomem *reg = acb->pmu;
+	uint32_t intmask_org, mask, outbound_doorbell, firmware_state = 0;
+
+	do {
+		firmware_state = readl(&reg->outbound_msgaddr1);
+	} while (!(firmware_state & ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK));
+	intmask_org = readl(&reg->outbound_intmask)
+			| ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE;
+	arcmsr_get_firmware_spec(acb);
+
+	acb->acb_flags |= ACB_F_MSG_START_BGRB;
+	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);
+	if (arcmsr_wait_msgint_ready(acb)) {
+		printk(KERN_NOTICE "arcmsr%d: "
+		       "wait 'start adapter background rebulid' timeout\n",
+		       acb->host->host_no);
 	}
+
+	outbound_doorbell = readl(&reg->outbound_doorbell);
+	writel(outbound_doorbell, &reg->outbound_doorbell);
+	writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);
+	mask = ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE
+			| ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE);
+	writel(intmask_org & mask, &reg->outbound_intmask);
+	acb->outbound_int_enable = ~(intmask_org & mask) & 0x000000ff;
+	acb->acb_flags |= ACB_F_IOP_INITED;
+}
+
+static void arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit __iomem *reg = acb->pmu;
+
+	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
+	if (arcmsr_wait_msgint_ready(acb)) {
+		printk(KERN_NOTICE "arcmsr%d: "
+		       "wait 'abort all outstanding command' timeout\n",
+			acb->host->host_no);
+	}
+}
+
+static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct Scsi_Host *host;
+	struct AdapterControlBlock *acb;
+	u8 bus, dev_fun;
+	int error;
+
+	error = pci_enable_device(pdev);
+	if (error)
+		goto out;
+	pci_set_master(pdev);
+
+	host = scsi_host_alloc(&arcmsr_scsi_host_template,
+			sizeof(struct AdapterControlBlock));
+	if (!host) {
+		error = -ENOMEM;
+		goto out_disable_device;
+	}
+	acb = (struct AdapterControlBlock *)host->hostdata;
+	memset(acb, 0, sizeof (struct AdapterControlBlock));
+
+	error = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	if (error) {
+		error = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		if (error) {
+			printk(KERN_WARNING
+			       "scsi%d: No suitable DMA mask available\n",
+			       host->host_no);
+			goto out_host_put;
+		}
+	}
+
 	bus = pdev->bus->number;
 	dev_fun = pdev->devfn;
-	pACB = (struct AdapterControlBlock *) host->hostdata;
-	memset(pACB, 0, sizeof (struct AdapterControlBlock));
-	pACB->host = host;
-	pACB->pdev = pdev;
+
+	acb->host = host;
+	acb->pdev = pdev;
 	host->max_sectors = ARCMSR_MAX_XFER_SECTORS;
 	host->max_lun = ARCMSR_MAX_TARGETLUN;
 	host->max_id = ARCMSR_MAX_TARGETID;/*16:8*/
@@ -250,70 +376,155 @@
 	host->cmd_per_lun = ARCMSR_MAX_CMD_PERLUN;
 	host->this_id = ARCMSR_SCSI_INITIATOR_ID;
 	host->unique_id = (bus << 8) | dev_fun;
-	host->io_port = 0;
-	host->n_io_port = 0;
 	host->irq = pdev->irq;
-	pci_set_master(pdev);
-	if (arcmsr_initialize(pACB, pdev)) {
-		printk(KERN_NOTICE
-		"arcmsr%d: initialize got error \n"
-		, host->host_no);
-		pci_disable_device(pdev);
-		scsi_host_put(host);
-		return -ENODEV;
-	}
-	if (pci_request_regions(pdev, "arcmsr")) {
-		printk(KERN_NOTICE
-		"arcmsr%d: adapter probe: pci_request_regions failed \n"
-		, host->host_no);
-		arcmsr_pcidev_disattach(pACB);
-		return -ENODEV;
-	}
-	if (request_irq(pdev->irq, arcmsr_do_interrupt, SA_INTERRUPT | SA_SHIRQ,
-		"arcmsr", pACB)) {
-		printk(KERN_NOTICE
-		"arcmsr%d: request IRQ=%d failed !\n"
-		, host->host_no, pdev->irq);
-		arcmsr_pcidev_disattach(pACB);
-		return -ENODEV;
-	}
-	arcmsr_iop_init(pACB);
-	if (scsi_add_host(host, &pdev->dev)) {
-		printk(KERN_NOTICE
-		"arcmsr%d: scsi_add_host got error \n"
-		, host->host_no);
-		arcmsr_pcidev_disattach(pACB);
-		return -ENODEV;
+
+	error = pci_request_regions(pdev, "arcmsr");
+	if (error)
+		goto out_host_put;
+
+	acb->pmu = ioremap(pci_resource_start(pdev, 0),
+			   pci_resource_len(pdev, 0));
+	if (!acb->pmu) {
+		printk(KERN_NOTICE "arcmsr%d: memory"
+			" mapping region fail \n", acb->host->host_no);
+		goto out_release_regions;
 	}
-	arcmsr_alloc_sysfs_attr(pACB);
+
+	acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
+			   ACB_F_MESSAGE_RQBUFFER_CLEARED |
+			   ACB_F_MESSAGE_WQBUFFER_READED);
+	acb->acb_flags &= ~ACB_F_SCSISTOPADAPTER;
+	INIT_LIST_HEAD(&acb->ccb_free_list);
+
+	error = arcmsr_alloc_ccb_pool(acb);
+	if (error)
+		goto out_iounmap;
+
+	error = request_irq(pdev->irq, arcmsr_do_interrupt,
+			SA_INTERRUPT | SA_SHIRQ, "arcmsr", acb);
+	if (error)
+		goto out_free_ccb_pool;
+
+	arcmsr_iop_init(acb);
 	pci_set_drvdata(pdev, host);
+
+	error = scsi_add_host(host, &pdev->dev);
+	if (error)
+		goto out_free_irq;
+
+	arcmsr_alloc_sysfs_attr(acb);
 	scsi_scan_host(host);
 	return 0;
+
+ out_free_irq:
+	free_irq(pdev->irq, acb);
+ out_free_ccb_pool:
+	arcmsr_free_ccb_pool(acb);
+ out_iounmap:
+	iounmap(acb->pmu);
+ out_release_regions:
+	pci_release_regions(pdev);
+ out_host_put:
+	scsi_host_put(host);
+ out_disable_device:
+	pci_disable_device(pdev);
+ out:
+	return error;
 }
 
-static void arcmsr_device_remove(struct pci_dev *pdev)
+static void arcmsr_remove(struct pci_dev *pdev)
 {
-	struct Scsi_Host * host = pci_get_drvdata(pdev);
-	struct AdapterControlBlock *pACB = (struct AdapterControlBlock *) host->hostdata;
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	struct AdapterControlBlock *acb =
+		(struct AdapterControlBlock *) host->hostdata;
+	struct MessageUnit __iomem *reg = acb->pmu;
+	int poll_count = 0;
+
+	scsi_remove_host(host);
 
-	arcmsr_pcidev_disattach(pACB);
+	arcmsr_stop_adapter_bgrb(acb);
+	arcmsr_flush_adapter_cache(acb);
+	writel(readl(&reg->outbound_intmask) |
+		ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE,
+		&reg->outbound_intmask);
+	acb->acb_flags |= ACB_F_SCSISTOPADAPTER;
+	acb->acb_flags &= ~ACB_F_IOP_INITED;
+
+	for (poll_count = 0; poll_count < 256; poll_count++) {
+		if (!atomic_read(&acb->ccboutstandingcount))
+			break;
+		arcmsr_interrupt(acb);
+		msleep(25);
+	}
+
+	if (atomic_read(&acb->ccboutstandingcount)) {
+		int i;
+
+		arcmsr_abort_allcmd(acb);
+		for (i = 0; i < ARCMSR_MAX_OUTSTANDING_CMD; i++)
+			readl(&reg->outbound_queueport);
+		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+			struct CommandControlBlock *pCCB = acb->pccb_pool[i];
+			if (pCCB->startdone == ARCMSR_CCB_START) {
+				pCCB->startdone = ARCMSR_CCB_ABORTED;
+				pCCB->pcmd->result = DID_ABORT << 16;
+				arcmsr_ccb_complete(pCCB, 1);
+			}
+		}
+	}
+
+	free_irq(pdev->irq, acb);
+	iounmap(acb->pmu);
+	arcmsr_free_ccb_pool(acb);
+	pci_release_regions(pdev);
+
+	scsi_host_put(host);
+
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
 }
 
 static void arcmsr_device_shutdown(struct pci_dev *pdev)
 {
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
-	struct AdapterControlBlock *pACB = (struct AdapterControlBlock *) host->hostdata;
+	struct AdapterControlBlock *acb =
+		(struct AdapterControlBlock *)host->hostdata;
 
-	arcmsr_stop_adapter_bgrb(pACB);
-	arcmsr_flush_adapter_cache(pACB);
+	arcmsr_stop_adapter_bgrb(acb);
+	arcmsr_flush_adapter_cache(acb);
 }
 
+static struct pci_device_id arcmsr_device_id_table[] = {
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1110)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1120)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1130)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1160)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1170)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1210)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1220)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1230)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1260)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1270)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1280)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1380)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1381)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1680)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1681)},
+	{0, 0}, /* Terminating entry */
+};
+MODULE_DEVICE_TABLE(pci, arcmsr_device_id_table);
+
+static struct pci_driver arcmsr_pci_driver = {
+	.name			= "arcmsr",
+	.id_table		= arcmsr_device_id_table,
+	.probe			= arcmsr_probe,
+	.remove			= arcmsr_remove,
+	.shutdown		= arcmsr_device_shutdown,
+};
+
 static int arcmsr_module_init(void)
 {
-	int error = 0;
-
-	error = pci_register_driver(&arcmsr_pci_driver);
-	return error;
+	return pci_register_driver(&arcmsr_pci_driver);
 }
 
 static void arcmsr_module_exit(void)
@@ -323,23 +534,6 @@
 module_init(arcmsr_module_init);
 module_exit(arcmsr_module_exit);
 
-static void arcmsr_pci_unmap_dma(struct CommandControlBlock *pCCB)
-{
-	struct AdapterControlBlock *pACB = pCCB->pACB;
-	struct scsi_cmnd *pcmd = pCCB->pcmd;
-
-	if (pcmd->use_sg != 0) {
-		struct scatterlist *sl;
-
-		sl = (struct scatterlist *)pcmd->request_buffer;
-		pci_unmap_sg(pACB->pdev, sl, pcmd->use_sg, pcmd->sc_data_direction);
-	}
-	else if (pcmd->request_bufflen != 0)
-		pci_unmap_single(pACB->pdev,
-			(dma_addr_t)(unsigned long)pcmd->SCp.ptr,
-			pcmd->request_bufflen, pcmd->sc_data_direction);
-}
-
 static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit __iomem *reg=pACB->pmu;
@@ -351,20 +545,6 @@
 			, pACB->host->host_no);
 }
 
-static void arcmsr_ccb_complete(struct CommandControlBlock *pCCB, int stand_flag)
-{
-	struct AdapterControlBlock *pACB = pCCB->pACB;
-	struct scsi_cmnd *pcmd = pCCB->pcmd;
-
-	arcmsr_pci_unmap_dma(pCCB);
-	if (stand_flag == 1)
-		atomic_dec(&pACB->ccboutstandingcount);
-	pCCB->startdone = ARCMSR_CCB_DONE;
-	pCCB->ccb_flags = 0;
-	list_add_tail(&pCCB->list, &pACB->ccb_free_list);
-	pcmd->scsi_done(pcmd);
-}
-
 static void arcmsr_report_sense_info(struct CommandControlBlock *pCCB)
 {
 	struct scsi_cmnd *pcmd = pCCB->pcmd;
@@ -382,17 +562,6 @@
 	}
 }
 
-static void arcmsr_abort_allcmd(struct AdapterControlBlock *pACB)
-{
-	struct MessageUnit __iomem *reg = pACB->pmu;
-
-	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
-	if (arcmsr_wait_msgint_ready(pACB))
-		printk(KERN_NOTICE
-			"arcmsr%d: wait 'abort all outstanding command' timeout \n"
-			, pACB->host->host_no);
-}
-
 static uint8_t arcmsr_wait_msgint_ready(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit __iomem *reg = pACB->pmu;
@@ -1087,56 +1256,6 @@
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
-static void arcmsr_get_firmware_spec(struct AdapterControlBlock *pACB)
-{
-	struct MessageUnit __iomem *reg = pACB->pmu;
-	char *acb_firm_model = pACB->firm_model;
-	char *acb_firm_version = pACB->firm_version;
-	char __iomem *iop_firm_model = (char __iomem *) &reg->message_rwbuffer[15];
-	char __iomem *iop_firm_version = (char __iomem *) &reg->message_rwbuffer[17];
-	int count;
-
-	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
-	if (arcmsr_wait_msgint_ready(pACB))
-		printk(KERN_NOTICE
-			"arcmsr%d: wait "
-			"'get adapter firmware miscellaneous data' timeout \n"
-			, pACB->host->host_no);
-	count = 8;
-	while (count) {
-		*acb_firm_model = readb(iop_firm_model);
-		acb_firm_model++;
-		iop_firm_model++;
-		count--;
-	}
-	count = 16;
-	while (count) {
-		*acb_firm_version = readb(iop_firm_version);
-		acb_firm_version++;
-		iop_firm_version++;
-		count--;
-	}
-	printk(KERN_INFO
-		"ARECA RAID ADAPTER%d: FIRMWARE VERSION %s \n"
-		, pACB->host->host_no
-		, pACB->firm_version);
-	pACB->firm_request_len = readl(&reg->message_rwbuffer[1]);
-	pACB->firm_numbers_queue = readl(&reg->message_rwbuffer[2]);
-	pACB->firm_sdram_size = readl(&reg->message_rwbuffer[3]);
-	pACB->firm_hd_channels = readl(&reg->message_rwbuffer[4]);
-}
-
-static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *pACB)
-{
-	struct MessageUnit __iomem *reg = pACB->pmu;
-	pACB->acb_flags |= ACB_F_MSG_START_BGRB;
-	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);
-	if (arcmsr_wait_msgint_ready(pACB))
-		printk(KERN_NOTICE
-			"arcmsr%d: wait 'start adapter background rebulid' timeout \n"
-			, pACB->host->host_no);
-}
-
 static void arcmsr_polling_ccbdone(struct AdapterControlBlock *pACB, struct CommandControlBlock 	*poll_ccb)
 {
 	struct MessageUnit __iomem *reg = pACB->pmu;
@@ -1230,28 +1349,6 @@
 	}
 }
 
-static void arcmsr_iop_init(struct AdapterControlBlock *pACB)
-{
-	struct MessageUnit __iomem *reg = pACB->pmu;
-	uint32_t intmask_org, mask, outbound_doorbell, firmware_state = 0;
-
-	do {
-		firmware_state = readl(&reg->outbound_msgaddr1);
-	} while (!(firmware_state & ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK));
-	intmask_org = readl(&reg->outbound_intmask)
-			| ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE;
-	arcmsr_get_firmware_spec(pACB);
-	arcmsr_start_adapter_bgrb(pACB);
-	outbound_doorbell = readl(&reg->outbound_doorbell);
-	writel(outbound_doorbell, &reg->outbound_doorbell);
-	writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);
-	mask = ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE
-			| ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE);
-	writel(intmask_org & mask, &reg->outbound_intmask);
-	pACB->outbound_int_enable = ~(intmask_org & mask) & 0x000000ff;
-	pACB->acb_flags |= ACB_F_IOP_INITED;
-}
-
 static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
 {
 	struct AdapterControlBlock *pACB;
@@ -1404,136 +1501,3 @@
 	}
 	return buf;
 }
-
-static int arcmsr_initialize(struct AdapterControlBlock *pACB, struct pci_dev *pdev)
-{
-	struct MessageUnit __iomem *reg;
-	uint32_t intmask_org, ccb_phyaddr_hi32;
-	dma_addr_t dma_coherent_handle, dma_addr;
-	uint8_t pcicmd;
-	void *dma_coherent;
-	void __iomem *page_remapped;
-	int i, j;
-	struct CommandControlBlock *pccb_tmp;
-
-	pci_read_config_byte(pdev, PCI_COMMAND, &pcicmd);
-	pci_write_config_byte(pdev, PCI_COMMAND,
-		pcicmd | PCI_COMMAND_INVALIDATE | PCI_COMMAND_MASTER | PCI_COMMAND_MEMORY);
-	page_remapped = ioremap(pci_resource_start(pdev, 0),
-		pci_resource_len(pdev, 0));
-	if ( !page_remapped ) {
-		printk(KERN_NOTICE "arcmsr%d: memory"
-			" mapping region fail \n", pACB->host->host_no);
-		return -ENXIO;
-	}
-	pACB->pmu = (struct MessageUnit __iomem *)(page_remapped);
-	pACB->acb_flags |=
-		(ACB_F_MESSAGE_WQBUFFER_CLEARED
-		| ACB_F_MESSAGE_RQBUFFER_CLEARED
-		| ACB_F_MESSAGE_WQBUFFER_READED);
-	pACB->acb_flags &= ~ACB_F_SCSISTOPADAPTER;
-	INIT_LIST_HEAD(&pACB->ccb_free_list);
-	dma_coherent = dma_alloc_coherent(&pdev->dev
-		, ARCMSR_MAX_FREECCB_NUM * sizeof (struct CommandControlBlock) + 0x20
-		, &dma_coherent_handle, GFP_KERNEL);
-	if (!dma_coherent) {
-		printk(KERN_NOTICE
-			"arcmsr%d: dma_alloc_coherent got error \n"
-			, pACB->host->host_no);
-		return -ENOMEM;
-	}
-	pACB->dma_coherent = dma_coherent;
-	pACB->dma_coherent_handle = dma_coherent_handle;
-	memset(dma_coherent, 0, ARCMSR_MAX_FREECCB_NUM * sizeof (struct CommandControlBlock) +
-			0x20);
-	if (((unsigned long)dma_coherent & 0x1F) != 0) {
-		dma_coherent = dma_coherent + (0x20 - ((unsigned long)dma_coherent & 0x1F));
-		dma_coherent_handle = dma_coherent_handle
-			+ (0x20 - ((unsigned long)dma_coherent_handle & 0x1F));
-	}
-	dma_addr = dma_coherent_handle;
-	pccb_tmp = (struct CommandControlBlock *)dma_coherent;
-	for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
-		pccb_tmp->cdb_shifted_phyaddr = dma_addr >> 5;
-		pccb_tmp->pACB = pACB;
-		pACB->pccb_pool[i] = pccb_tmp;
-		list_add_tail(&pccb_tmp->list, &pACB->ccb_free_list);
-		dma_addr = dma_addr + sizeof (struct CommandControlBlock);
-		pccb_tmp++;
-	}
-	pACB->vir2phy_offset = (unsigned long)pccb_tmp - (unsigned long)dma_addr;
-	for(i = 0; i < ARCMSR_MAX_TARGETID; i++) {
-		for(j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
-			pACB->devstate[i][j] = ARECA_RAID_GOOD;
-	}
-	reg = pACB->pmu;
-	/*
-	*************************************************************
-	** here we need to tell iop 331 our pccb_tmp.HighPart
-	** if pccb_tmp.HighPart is not zero
-	*************************************************************
-	*/
-	ccb_phyaddr_hi32 = (uint32_t) ((dma_coherent_handle >> 16) >> 16);
-	if (ccb_phyaddr_hi32 != 0) {
-		writel(ARCMSR_SIGNATURE_SET_CONFIG, &reg->message_rwbuffer[0]);
-		writel(ccb_phyaddr_hi32, &reg->message_rwbuffer[1]);
-		writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);
-		if (arcmsr_wait_msgint_ready(pACB))
-			printk(KERN_NOTICE
-				"arcmsr%d: 'set ccb high part physical address' timeout \n"
-				, pACB->host->host_no);
-	}
-	intmask_org = readl(&reg->outbound_intmask);
-	writel(intmask_org | ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE
-			, &reg->outbound_intmask);
-	return 0;
-}
-
-static void arcmsr_pcidev_disattach(struct AdapterControlBlock *pACB)
-{
-	struct MessageUnit __iomem *reg = pACB->pmu;
-	struct pci_dev *pdev;
-	struct CommandControlBlock *pCCB;
-	struct Scsi_Host *host;
-	uint32_t intmask_org;
-	int i = 0, poll_count = 0;
-
-	arcmsr_stop_adapter_bgrb(pACB);
-	arcmsr_flush_adapter_cache(pACB);
-	intmask_org = readl(&reg->outbound_intmask);
-	writel(intmask_org | ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE
-			, &reg->outbound_intmask);
-	pACB->acb_flags |= ACB_F_SCSISTOPADAPTER;
-	pACB->acb_flags &= ~ACB_F_IOP_INITED;
-	if (atomic_read(&pACB->ccboutstandingcount) != 0) {
-		while (atomic_read(&pACB->ccboutstandingcount) != 0 && (poll_count < 256)) {
-			arcmsr_interrupt(pACB);
-			msleep(25);
-			poll_count++;
-		}
-		if (atomic_read(&pACB->ccboutstandingcount) != 0) {
-			arcmsr_abort_allcmd(pACB);
-			for(i = 0; i < ARCMSR_MAX_OUTSTANDING_CMD; i++)
-				readl(&reg->outbound_queueport);
-			for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
-				pCCB = pACB->pccb_pool[i];
-				if (pCCB->startdone == ARCMSR_CCB_START) {
-					pCCB->startdone = ARCMSR_CCB_ABORTED;
-					pCCB->pcmd->result = DID_ABORT << 16;
-					arcmsr_ccb_complete(pCCB, 1);
-				}
-			}
-		}
-	}
-	host = pACB->host;
-	pdev = pACB->pdev;
-	iounmap(pACB->pmu);
-	arcmsr_free_ccb_pool(pACB);
-	scsi_remove_host(host);
-	scsi_host_put(host);
-	free_irq(pdev->irq, pACB);
-	pci_release_regions(pdev);
-	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
-}
-
