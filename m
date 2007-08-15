From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Manage scsi_host correctly in 53c700-based drivers
Date: Wed, 15 Aug 2007 14:35:45 -0600
Message-ID: <20070815203545.GG16277@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43343 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbXHOUfq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2007 16:35:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Restructure the 53c700-based drivers so that:

 - They call scsi_host_alloc themselves rather than leaving it to
   NCR_700_detect.
 - NCR_700_detect now returns an int error rather than NULL, allowing
   drivers to do better error handling
 - hostdata is now allocated with the Scsi_Host rather than separately.
   Fixes a bug on 64-bit systems.
 - hostdata now accessed through shost_priv()
 - They handle calling scsi_host_put themselves at the appropriate time
   to avoid leaking Scsi_Hosts
 - Use of host->irq is avoided where possible

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 71ff3fb..19431de 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -275,33 +275,31 @@ NCR_700_offset_period_to_sxfer(struct NCR_700_Host_Parameters *hostdata,
 static inline __u8
 NCR_700_get_SXFER(struct scsi_device *SDp)
 {
-	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(SDp->host);
 
 	return NCR_700_offset_period_to_sxfer(hostdata,
 					      spi_offset(SDp->sdev_target),
 					      spi_period(SDp->sdev_target));
 }
 
-struct Scsi_Host *
-NCR_700_detect(struct scsi_host_template *tpnt,
-	       struct NCR_700_Host_Parameters *hostdata, struct device *dev)
+int NCR_700_detect(struct Scsi_Host *host, struct device *dev)
 {
 	dma_addr_t pScript, pSlots;
 	__u8 *memory;
 	__u32 *script;
-	struct Scsi_Host *host;
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
+	struct scsi_host_template *tpnt = host->hostt;
 	static int banner = 0;
-	int j;
+	int j, error;
 
-	if(tpnt->sdev_attrs == NULL)
+	if (!tpnt->sdev_attrs)
 		tpnt->sdev_attrs = NCR_700_dev_attrs;
 
 	memory = dma_alloc_noncoherent(hostdata->dev, TOTAL_MEM_SIZE,
 				       &pScript, GFP_KERNEL);
-	if(memory == NULL) {
-		printk(KERN_ERR "53c700: Failed to allocate memory for driver, detatching\n");
-		return NULL;
+	if (!memory) {
+		printk(KERN_ERR "53c700: Failed to allocate memory for driver, detaching\n");
+		return -ENOMEM;;
 	}
 
 	script = (__u32 *)memory;
@@ -336,9 +334,6 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	if(tpnt->proc_name == NULL)
 		tpnt->proc_name = "53c700";
 
-	host = scsi_host_alloc(tpnt, 4);
-	if (!host)
-		return NULL;
 	memset(hostdata->slots, 0, sizeof(struct NCR_700_command_slot)
 	       * NCR_700_COMMAND_SLOTS_PER_HOST);
 	for (j = 0; j < NCR_700_COMMAND_SLOTS_PER_HOST; j++) {
@@ -397,23 +392,22 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	/* reset the chip */
 	NCR_700_chip_reset(host);
 
-	if (scsi_add_host(host, dev)) {
+	error = scsi_add_host(host, dev);
+	if (error) {
 		dev_printk(KERN_ERR, dev, "53c700: scsi_add_host failed\n");
-		scsi_host_put(host);
-		return NULL;
+		return error;
 	}
 
 	spi_signalling(host) = hostdata->differential ? SPI_SIGNAL_HVD :
 		SPI_SIGNAL_SE;
 
-	return host;
+	return 0;
 }
 
 int
 NCR_700_release(struct Scsi_Host *host)
 {
-	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 
 	dma_free_noncoherent(hostdata->dev, TOTAL_MEM_SIZE,
 			       hostdata->script, hostdata->pScript);
@@ -440,8 +434,7 @@ NCR_700_identify(int can_disconnect, __u8 lun)
  * Inputs : host - SCSI host */
 static inline int
 NCR_700_data_residual (struct Scsi_Host *host) {
-	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 	int count, synchronous = 0;
 	unsigned int ddir;
 
@@ -649,8 +642,7 @@ NCR_700_internal_bus_reset(struct Scsi_Host *host)
 STATIC void
 NCR_700_chip_setup(struct Scsi_Host *host)
 {
-	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 	__u8 min_period;
 	__u8 min_xferp = (hostdata->chip710 ? NCR_710_MIN_XFERP : NCR_700_MIN_XFERP);
 
@@ -759,8 +751,7 @@ NCR_700_chip_setup(struct Scsi_Host *host)
 STATIC void
 NCR_700_chip_reset(struct Scsi_Host *host)
 {
-	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 	if(hostdata->chip710) {
 		NCR_700_writeb(SOFTWARE_RESET_710, host, ISTAT_REG);
 		udelay(100);
@@ -1286,8 +1277,7 @@ process_selection(struct Scsi_Host *host, __u32 dsp)
 	__u8 id = 0;	/* Squash compiler warning */
 	int count = 0;
 	__u32 resume_offset = 0;
-	struct NCR_700_Host_Parameters *hostdata =
-		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 	struct scsi_cmnd *SCp = hostdata->cmd;
 	__u8 sbcl;
 
@@ -1363,8 +1353,7 @@ process_selection(struct Scsi_Host *host, __u32 dsp)
 
 static inline void
 NCR_700_clear_fifo(struct Scsi_Host *host) {
-	const struct NCR_700_Host_Parameters *hostdata
-		= (struct NCR_700_Host_Parameters *)host->hostdata[0];
+	const struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 	if(hostdata->chip710) {
 		NCR_700_writeb(CLR_FIFO_710, host, CTEST8_REG);
 	} else {
@@ -1374,8 +1363,7 @@ NCR_700_clear_fifo(struct Scsi_Host *host) {
 
 static inline void
 NCR_700_flush_fifo(struct Scsi_Host *host) {
-	const struct NCR_700_Host_Parameters *hostdata
-		= (struct NCR_700_Host_Parameters *)host->hostdata[0];
+	const struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 	if(hostdata->chip710) {
 		NCR_700_writeb(FLUSH_DMA_FIFO_710, host, CTEST8_REG);
 		udelay(10);
@@ -1396,7 +1384,7 @@ NCR_700_start_command(struct scsi_cmnd *SCp)
 	struct NCR_700_command_slot *slot =
 		(struct NCR_700_command_slot *)SCp->host_scribble;
 	struct NCR_700_Host_Parameters *hostdata =
-		(struct NCR_700_Host_Parameters *)SCp->device->host->hostdata[0];
+						shost_priv(SCp->device->host);
 	__u16 count = 1;	/* for IDENTIFY message */
 	
 	if(hostdata->state != NCR_700_HOST_FREE) {
@@ -1482,8 +1470,7 @@ irqreturn_t
 NCR_700_intr(int irq, void *dev_id)
 {
 	struct Scsi_Host *host = (struct Scsi_Host *)dev_id;
-	struct NCR_700_Host_Parameters *hostdata =
-		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 	__u8 istat;
 	__u32 resume_offset = 0;
 	__u8 pun = 0xff, lun = 0xff;
@@ -1753,8 +1740,8 @@ NCR_700_intr(int irq, void *dev_id)
 STATIC int
 NCR_700_queuecommand(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *))
 {
-	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)SCp->device->host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata =
+						shost_priv(SCp->device->host);
 	__u32 move_ins;
 	enum dma_data_direction direction;
 	struct NCR_700_command_slot *slot;
@@ -1941,8 +1928,8 @@ STATIC int
 NCR_700_bus_reset(struct scsi_cmnd * SCp)
 {
 	DECLARE_COMPLETION_ONSTACK(complete);
-	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)SCp->device->host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata =
+						shost_priv(SCp->device->host);
 
 	scmd_printk(KERN_INFO, SCp,
 		"New error handler wants BUS reset, cmd %p\n\t", SCp);
@@ -1994,9 +1981,8 @@ STATIC void
 NCR_700_set_period(struct scsi_target *STp, int period)
 {
 	struct Scsi_Host *SHp = dev_to_shost(STp->dev.parent);
-	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)SHp->hostdata[0];
-	
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(SHp);
+
 	if(!hostdata->fast)
 		return;
 
@@ -2013,8 +1999,7 @@ STATIC void
 NCR_700_set_offset(struct scsi_target *STp, int offset)
 {
 	struct Scsi_Host *SHp = dev_to_shost(STp->dev.parent);
-	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)SHp->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(SHp);
 	int max_offset = hostdata->chip710
 		? NCR_710_MAX_OFFSET : NCR_700_MAX_OFFSET;
 	
@@ -2050,8 +2035,7 @@ NCR_700_slave_alloc(struct scsi_device *SDp)
 STATIC int
 NCR_700_slave_configure(struct scsi_device *SDp)
 {
-	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(SDp->host);
 
 	/* to do here: allocate memory; build a queue_full list */
 	if(SDp->tagged_supported) {
@@ -2094,8 +2078,7 @@ static int NCR_700_change_queue_type(struct scsi_device *SDp, int tag_type)
 {
 	int change_tag = ((tag_type ==0 &&  scsi_get_tag_type(SDp) != 0)
 			  || (tag_type != 0 && scsi_get_tag_type(SDp) == 0));
-	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(SDp->host);
 
 	scsi_set_tag_type(SDp, tag_type);
 
diff --git a/drivers/scsi/53c700.h b/drivers/scsi/53c700.h
index e06bdfe..e2372e4 100644
--- a/drivers/scsi/53c700.h
+++ b/drivers/scsi/53c700.h
@@ -54,8 +54,7 @@
 struct NCR_700_Host_Parameters;
 
 /* These are the externally used routines */
-struct Scsi_Host *NCR_700_detect(struct scsi_host_template *,
-		struct NCR_700_Host_Parameters *, struct device *);
+int NCR_700_detect(struct Scsi_Host *host, struct device *);
 int NCR_700_release(struct Scsi_Host *host);
 irqreturn_t NCR_700_intr(int, void *);
 
diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
index 3a80897..e432350 100644
--- a/drivers/scsi/NCR_D700.c
+++ b/drivers/scsi/NCR_D700.c
@@ -181,12 +181,13 @@ NCR_D700_probe_one(struct NCR_D700_private *p, int siop, int irq,
 	struct Scsi_Host *host;
 	int ret;
 
-	hostdata = kzalloc(sizeof(*hostdata), GFP_KERNEL);
-	if (!hostdata) {
-		printk(KERN_ERR "NCR D700: SIOP%d: Failed to allocate host"
-		       "data, detatching\n", siop);
+	host = scsi_host_alloc(&NCR_D700_driver_template, sizeof(*hostdata));
+	if (!host) {
+		printk(KERN_ERR "NCR D700: SIOP%d: Failed to allocate host, "
+		       "detaching\n", siop);
 		return -ENOMEM;
 	}
+	hostdata = shost_priv(host);
 
 	if (!request_region(region, 64, "NCR_D700")) {
 		printk(KERN_ERR "NCR D700: Failed to reserve IO region 0x%x\n",
@@ -195,18 +196,16 @@ NCR_D700_probe_one(struct NCR_D700_private *p, int siop, int irq,
 		goto region_failed;
 	}
 		
-	/* Fill in the three required pieces of hostdata */
+	/* Fill in the required pieces of hostdata */
 	hostdata->base = ioport_map(region, 64);
 	hostdata->differential = (((1<<siop) & differential) != 0);
 	hostdata->clock = NCR_D700_CLOCK_MHZ;
 	hostdata->burst_length = 8;
 
 	/* and register the siop */
-	host = NCR_700_detect(&NCR_D700_driver_template, hostdata, p->dev);
-	if (!host) {
-		ret = -ENOMEM;
+	ret = NCR_700_detect(host, p->dev);
+	if (ret)
 		goto detect_failed;
-	}
 
 	p->hosts[siop] = host;
 	/* FIXME: read this from SUS */
@@ -220,7 +219,7 @@ NCR_D700_probe_one(struct NCR_D700_private *p, int siop, int irq,
  detect_failed:
 	release_region(region, 64);
  region_failed:
-	kfree(hostdata);
+	scsi_host_put(host);
 
 	return ret;
 }
@@ -354,9 +353,9 @@ NCR_D700_remove_one(struct Scsi_Host *host)
 {
 	scsi_remove_host(host);
 	NCR_700_release(host);
-	kfree((struct NCR_700_Host_Parameters *)host->hostdata[0]);
 	free_irq(host->irq, host);
 	release_region(host->base, 64);
+	scsi_host_put(host);
 }
 
 static int __devexit
diff --git a/drivers/scsi/a4000t.c b/drivers/scsi/a4000t.c
index 0c758d1..abf96b8 100644
--- a/drivers/scsi/a4000t.c
+++ b/drivers/scsi/a4000t.c
@@ -37,22 +37,24 @@ static struct platform_device *a4000t_scsi_device;
 
 static int __devinit a4000t_probe(struct device *dev)
 {
-	struct Scsi_Host * host = NULL;
+	struct Scsi_Host *host;
 	struct NCR_700_Host_Parameters *hostdata;
+	int err = -ENODEV;
 
 	if (!(MACH_IS_AMIGA && AMIGAHW_PRESENT(A4000_SCSI)))
 		goto out;
 
+	err = -EBUSY;
 	if (!request_mem_region(A4000T_SCSI_ADDR, 0x1000,
 				"A4000T builtin SCSI"))
 		goto out;
 
-	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
-	if (hostdata == NULL) {
-		printk(KERN_ERR "a4000t-scsi: Failed to allocate host data\n");
+	err = -ENOMEM;
+	host = scsi_host_alloc(&a4000t_scsi_driver_template, sizeof(*hostdata));
+	if (!host)
 		goto out_release;
-	}
-	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
+
+	hostdata = shost_priv(host);
 
 	/* Fill in the required pieces of hostdata */
 	hostdata->base = (void __iomem *)ZTWO_VADDR(A4000T_SCSI_ADDR);
@@ -62,19 +64,19 @@ static int __devinit a4000t_probe(struct device *dev)
 	hostdata->dcntl_extra = EA_710;
 
 	/* and register the chip */
-	host = NCR_700_detect(&a4000t_scsi_driver_template, hostdata, dev);
-	if (!host) {
+	err = NCR_700_detect(host, dev);
+	if (err) {
 		printk(KERN_ERR "a4000t-scsi: No host detected; "
 				"board configuration problem?\n");
-		goto out_free;
+		goto out_put_host;
 	}
 
 	host->this_id = 7;
 	host->base = A4000T_SCSI_ADDR;
-	host->irq = IRQ_AMIGA_PORTS;
 
-	if (request_irq(host->irq, NCR_700_intr, IRQF_SHARED, "a4000t-scsi",
-			host)) {
+	err = request_irq(IRQ_AMIGA_PORTS, NCR_700_intr, IRQF_SHARED,
+			"a4000t-scsi", host);
+	if (err) {
 		printk(KERN_ERR "a4000t-scsi: request_irq failed\n");
 		goto out_put_host;
 	}
@@ -86,25 +88,21 @@ static int __devinit a4000t_probe(struct device *dev)
 
  out_put_host:
 	scsi_host_put(host);
- out_free:
-	kfree(hostdata);
  out_release:
 	release_mem_region(A4000T_SCSI_ADDR, 0x1000);
  out:
-	return -ENODEV;
+	return err;
 }
 
 static __devexit int a4000t_device_remove(struct device *dev)
 {
 	struct Scsi_Host *host = dev_get_drvdata(dev);
-	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 
 	scsi_remove_host(host);
-
 	NCR_700_release(host);
-	kfree(hostdata);
-	free_irq(host->irq, host);
+	free_irq(IRQ_AMIGA_PORTS, host);
 	release_mem_region(A4000T_SCSI_ADDR, 0x1000);
+	scsi_host_put(host);
 
 	return 0;
 }
diff --git a/drivers/scsi/bvme6000_scsi.c b/drivers/scsi/bvme6000_scsi.c
index cac3540..3e46a1a 100644
--- a/drivers/scsi/bvme6000_scsi.c
+++ b/drivers/scsi/bvme6000_scsi.c
@@ -36,19 +36,19 @@ static struct platform_device *bvme6000_scsi_device;
 static __devinit int
 bvme6000_probe(struct device *dev)
 {
-	struct Scsi_Host * host = NULL;
+	struct Scsi_Host *host;
 	struct NCR_700_Host_Parameters *hostdata;
 
 	if (!MACH_IS_BVME6000)
 		goto out;
 
-	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
-	if (hostdata == NULL) {
-		printk(KERN_ERR "bvme6000-scsi: "
-				"Failed to allocate host data\n");
+	host = scsi_host_alloc(&bvme6000_scsi_driver_template,
+				sizeof(*hostdata));
+	if (!host) {
+		printk(KERN_ERR "bvme6000-scsi: Failed to allocate host\n");
 		goto out;
 	}
-	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
+	hostdata = shost_priv(host);
 
 	/* Fill in the required pieces of hostdata */
 	hostdata->base = (void __iomem *)BVME_NCR53C710_BASE;
@@ -59,15 +59,13 @@ bvme6000_probe(struct device *dev)
 	hostdata->ctest7_extra = CTEST7_TT1;
 
 	/* and register the chip */
-	host = NCR_700_detect(&bvme6000_scsi_driver_template, hostdata, dev);
-	if (!host) {
+	if (NCR_700_detect(host, dev)) {
 		printk(KERN_ERR "bvme6000-scsi: No host detected; "
 				"board configuration problem?\n");
-		goto out_free;
+		goto out_put_host;
 	}
 	host->base = BVME_NCR53C710_BASE;
 	host->this_id = 7;
-	host->irq = BVME_IRQ_SCSI;
 	if (request_irq(BVME_IRQ_SCSI, NCR_700_intr, 0, "bvme6000-scsi",
 			host)) {
 		printk(KERN_ERR "bvme6000-scsi: request_irq failed\n");
@@ -81,8 +79,6 @@ bvme6000_probe(struct device *dev)
 
  out_put_host:
 	scsi_host_put(host);
- out_free:
-	kfree(hostdata);
  out:
 	return -ENODEV;
 }
@@ -91,12 +87,11 @@ static __devexit int
 bvme6000_device_remove(struct device *dev)
 {
 	struct Scsi_Host *host = dev_get_drvdata(dev);
-	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 
 	scsi_remove_host(host);
 	NCR_700_release(host);
-	kfree(hostdata);
-	free_irq(host->irq, host);
+	free_irq(BVME_IRQ_SCSI, host);
+	scsi_host_put(host);
 
 	return 0;
 }
diff --git a/drivers/scsi/lasi700.c b/drivers/scsi/lasi700.c
index 3126824..cbd45eb 100644
--- a/drivers/scsi/lasi700.c
+++ b/drivers/scsi/lasi700.c
@@ -101,12 +101,13 @@ lasi700_probe(struct parisc_device *dev)
 	struct NCR_700_Host_Parameters *hostdata;
 	struct Scsi_Host *host;
 
-	hostdata = kzalloc(sizeof(*hostdata), GFP_KERNEL);
-	if (!hostdata) {
-		printk(KERN_ERR "%s: Failed to allocate host data\n",
+	host = scsi_host_alloc(&lasi700_template, sizeof(*hostdata));
+	if (!host) {
+		printk(KERN_ERR "%s: Failed to allocate host\n",
 		       dev->dev.bus_id);
 		return -ENOMEM;
 	}
+	hostdata = shost_priv(host);
 
 	hostdata->dev = &dev->dev;
 	dma_set_mask(&dev->dev, DMA_32BIT_MASK);
@@ -124,12 +125,10 @@ lasi700_probe(struct parisc_device *dev)
 		hostdata->burst_length = 8;
 	}
 
-	host = NCR_700_detect(&lasi700_template, hostdata, &dev->dev);
-	if (!host)
-		goto out_kfree;
+	if (NCR_700_detect(host, &dev->dev))
+		goto out_put_host;
 	host->this_id = 7;
 	host->base = base;
-	host->irq = dev->irq;
 	if(request_irq(dev->irq, NCR_700_intr, IRQF_SHARED, "lasi700", host)) {
 		printk(KERN_ERR "lasi700: request_irq failed!\n");
 		goto out_put_host;
@@ -141,10 +140,8 @@ lasi700_probe(struct parisc_device *dev)
 	return 0;
 
  out_put_host:
-	scsi_host_put(host);
- out_kfree:
 	iounmap(hostdata->base);
-	kfree(hostdata);
+	scsi_host_put(host);
 	return -ENODEV;
 }
 
@@ -152,14 +149,13 @@ static int __exit
 lasi700_driver_remove(struct parisc_device *dev)
 {
 	struct Scsi_Host *host = dev_get_drvdata(&dev->dev);
-	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 
 	scsi_remove_host(host);
 	NCR_700_release(host);
-	free_irq(host->irq, host);
+	free_irq(dev->irq, host);
 	iounmap(hostdata->base);
-	kfree(hostdata);
+	scsi_host_put(host);
 
 	return 0;
 }
diff --git a/drivers/scsi/mvme16x_scsi.c b/drivers/scsi/mvme16x_scsi.c
index 1bdddad..a62c222 100644
--- a/drivers/scsi/mvme16x_scsi.c
+++ b/drivers/scsi/mvme16x_scsi.c
@@ -36,7 +36,7 @@ static struct platform_device *mvme16x_scsi_device;
 static __devinit int
 mvme16x_probe(struct device *dev)
 {
-	struct Scsi_Host * host = NULL;
+	struct Scsi_Host *host;
 	struct NCR_700_Host_Parameters *hostdata;
 
 	if (!MACH_IS_MVME16x)
@@ -48,13 +48,13 @@ mvme16x_probe(struct device *dev)
 		goto out;
 	}
 
-	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
-	if (hostdata == NULL) {
-		printk(KERN_ERR "mvme16x-scsi: "
-				"Failed to allocate host data\n");
+	host = scsi_host_alloc(&mvme16x_scsi_driver_template,
+				sizeof(*hostdata));
+	if (!host) {
+		printk(KERN_ERR "mvme16x-scsi: Failed to allocate host\n");
 		goto out;
 	}
-	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
+	hostdata = shost_priv(host);
 
 	/* Fill in the required pieces of hostdata */
 	hostdata->base = (void __iomem *)0xfff47000UL;
@@ -65,16 +65,15 @@ mvme16x_probe(struct device *dev)
 	hostdata->ctest7_extra = CTEST7_TT1;
 
 	/* and register the chip */
-	host = NCR_700_detect(&mvme16x_scsi_driver_template, hostdata, dev);
-	if (!host) {
+	if (NCR_700_detect(host, dev)) {
 		printk(KERN_ERR "mvme16x-scsi: No host detected; "
 				"board configuration problem?\n");
-		goto out_free;
+		goto out_put_host;
 	}
 	host->this_id = 7;
 	host->base = 0xfff47000UL;
-	host->irq = MVME16x_IRQ_SCSI;
-	if (request_irq(host->irq, NCR_700_intr, 0, "mvme16x-scsi", host)) {
+	if (request_irq(MVME16x_IRQ_SCSI, NCR_700_intr, 0, "mvme16x-scsi",
+			host)) {
 		printk(KERN_ERR "mvme16x-scsi: request_irq failed\n");
 		goto out_put_host;
 	}
@@ -96,8 +95,6 @@ mvme16x_probe(struct device *dev)
 
  out_put_host:
 	scsi_host_put(host);
- out_free:
-	kfree(hostdata);
  out:
 	return -ENODEV;
 }
@@ -106,8 +103,8 @@ static __devexit int
 mvme16x_device_remove(struct device *dev)
 {
 	struct Scsi_Host *host = dev_get_drvdata(dev);
-	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 
+	scsi_remove_host(host);
 	/* Disable scsi chip ints */
 	{
 		volatile unsigned long v;
@@ -116,10 +113,9 @@ mvme16x_device_remove(struct device *dev)
 		v &= ~0x10;
 		out_be32(0xfff4202c, v);
 	}
-	scsi_remove_host(host);
 	NCR_700_release(host);
-	kfree(hostdata);
-	free_irq(host->irq, host);
+	free_irq(MVME16x_IRQ_SCSI, host);
+	scsi_host_put(host);
 
 	return 0;
 }
diff --git a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
index d63d229..23ef3a8 100644
--- a/drivers/scsi/sim710.c
+++ b/drivers/scsi/sim710.c
@@ -98,26 +98,27 @@ static __devinit int
 sim710_probe_common(struct device *dev, unsigned long base_addr,
 		    int irq, int clock, int differential, int scsi_id)
 {
-	struct Scsi_Host * host = NULL;
-	struct NCR_700_Host_Parameters *hostdata =
-		kzalloc(sizeof(struct NCR_700_Host_Parameters),	GFP_KERNEL);
+	struct Scsi_Host *host;
+	struct NCR_700_Host_Parameters *hostdata;
 
 	printk(KERN_NOTICE "sim710: %s\n", dev->bus_id);
 	printk(KERN_NOTICE "sim710: irq = %d, clock = %d, base = 0x%lx, scsi_id = %d\n",
 	       irq, clock, base_addr, scsi_id);
 
-	if(hostdata == NULL) {
-		printk(KERN_ERR "sim710: Failed to allocate host data\n");
+	host = scsi_host_alloc(&sim710_driver_template, sizeof(*hostdata));
+	if (!host) {
+		printk(KERN_ERR "sim710: Failed to allocate host\n");
 		goto out;
 	}
+	hostdata = shost_priv(host);
 
 	if(request_region(base_addr, 64, "sim710") == NULL) {
 		printk(KERN_ERR "sim710: Failed to reserve IO region 0x%lx\n",
 		       base_addr);
-		goto out_free;
+		goto out_put_host;
 	}
 
-	/* Fill in the three required pieces of hostdata */
+	/* Fill in the required pieces of hostdata */
 	hostdata->base = ioport_map(base_addr, 64);
 	hostdata->differential = differential;
 	hostdata->clock = clock;
@@ -125,8 +126,7 @@ sim710_probe_common(struct device *dev, unsigned long base_addr,
 	hostdata->burst_length = 8;
 
 	/* and register the chip */
-	if((host = NCR_700_detect(&sim710_driver_template, hostdata, dev))
-	   == NULL) {
+	if (NCR_700_detect(host, dev)) {
 		printk(KERN_ERR "sim710: No host detected; card configuration problem?\n");
 		goto out_release;
 	}
@@ -135,7 +135,7 @@ sim710_probe_common(struct device *dev, unsigned long base_addr,
 	host->irq = irq;
 	if (request_irq(irq, NCR_700_intr, IRQF_SHARED, "sim710", host)) {
 		printk(KERN_ERR "sim710: request_irq failed\n");
-		goto out_put_host;
+		goto out_release;
 	}
 
 	dev_set_drvdata(dev, host);
@@ -143,12 +143,10 @@ sim710_probe_common(struct device *dev, unsigned long base_addr,
 
 	return 0;
 
- out_put_host:
-	scsi_host_put(host);
  out_release:
 	release_region(base_addr, 64);
- out_free:
-	kfree(hostdata);
+ out_put_host:
+	scsi_host_put(host);
  out:
 	return -ENODEV;
 }
@@ -157,14 +155,12 @@ static __devexit int
 sim710_device_remove(struct device *dev)
 {
 	struct Scsi_Host *host = dev_get_drvdata(dev);
-	struct NCR_700_Host_Parameters *hostdata =
-		(struct NCR_700_Host_Parameters *)host->hostdata[0];
 
 	scsi_remove_host(host);
 	NCR_700_release(host);
-	kfree(hostdata);
 	free_irq(host->irq, host);
 	release_region(host->base, 64);
+	scsi_host_put(host);
 	return 0;
 }
 
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 0a6b45b..bd42a78 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -75,12 +75,13 @@ static int __init snirm710_probe(struct platform_device *dev)
 		return -ENODEV;
 
 	base = res->start;
-	hostdata = kzalloc(sizeof(*hostdata), GFP_KERNEL);
-	if (!hostdata) {
-		printk(KERN_ERR "%s: Failed to allocate host data\n",
+	host = scsi_host_alloc(&snirm710_template, sizeof(*hostdata));
+	if (!host) {
+		printk(KERN_ERR "%s: Failed to allocate host\n",
 		       dev->dev.bus_id);
 		return -ENOMEM;
 	}
+	hostdata = shost_priv(host);
 
 	hostdata->dev = &dev->dev;
 	dma_set_mask(&dev->dev, DMA_32BIT_MASK);
@@ -92,9 +93,8 @@ static int __init snirm710_probe(struct platform_device *dev)
 	hostdata->chip710 = 1;
 	hostdata->burst_length = 4;
 
-	host = NCR_700_detect(&snirm710_template, hostdata, &dev->dev);
-	if (!host)
-		goto out_kfree;
+	if (NCR_700_detect(host, &dev->dev))
+		goto out_put_host;
 	host->this_id = 7;
 	host->base = base;
 	host->irq = platform_get_irq(dev, 0);
@@ -109,24 +109,21 @@ static int __init snirm710_probe(struct platform_device *dev)
 	return 0;
 
  out_put_host:
-	scsi_host_put(host);
- out_kfree:
 	iounmap(hostdata->base);
-	kfree(hostdata);
+	scsi_host_put(host);
 	return -ENODEV;
 }
 
 static int __exit snirm710_driver_remove(struct platform_device *dev)
 {
 	struct Scsi_Host *host = dev_get_drvdata(&dev->dev);
-	struct NCR_700_Host_Parameters *hostdata =
-		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 
 	scsi_remove_host(host);
 	NCR_700_release(host);
 	free_irq(host->irq, host);
 	iounmap(hostdata->base);
-	kfree(hostdata);
+	scsi_host_put(host);
 
 	return 0;
 }
diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index c822deb..cc99c22 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -69,7 +69,7 @@ static struct zorro_device_id zorro7xx_zorro_tbl[] __devinitdata = {
 static int __devinit zorro7xx_init_one(struct zorro_dev *z,
 				       const struct zorro_device_id *ent)
 {
-	struct Scsi_Host * host = NULL;
+	struct Scsi_Host *host;
 	struct NCR_700_Host_Parameters *hostdata;
 	struct zorro_driver_data *zdd;
 	unsigned long board, ioaddr;
@@ -89,13 +89,13 @@ static int __devinit zorro7xx_init_one(struct zorro_dev *z,
 		return -EBUSY;
 	}
 
-	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
-	if (hostdata == NULL) {
-		printk(KERN_ERR "zorro7xx: Failed to allocate host data\n");
+	host = scsi_host_alloc(&zorro7xx_scsi_driver_template,
+				sizeof(*hostdata));
+	if (!host) {
+		printk(KERN_ERR "zorro7xx: Failed to allocate host\n");
 		goto out_release;
 	}
-
-	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
+	hostdata = shost_priv(host);
 
 	/* Fill in the required pieces of hostdata */
 	if (ioaddr > 0x01000000)
@@ -112,22 +112,19 @@ static int __devinit zorro7xx_init_one(struct zorro_dev *z,
 	zorro7xx_scsi_driver_template.name = zdd->name;
 
 	/* and register the chip */
-	host = NCR_700_detect(&zorro7xx_scsi_driver_template, hostdata,
-			      &z->dev);
-	if (!host) {
+	if (NCR_700_detect(host, &z->dev)) {
 		printk(KERN_ERR "zorro7xx: No host detected; "
 				"board configuration problem?\n");
-		goto out_free;
+		goto out_put_host;
 	}
 
 	host->this_id = 7;
 	host->base = ioaddr;
-	host->irq = IRQ_AMIGA_PORTS;
 
-	if (request_irq(host->irq, NCR_700_intr, IRQF_SHARED, "zorro7xx-scsi",
-			host)) {
+	if (request_irq(IRQ_AMIGA_PORTS, NCR_700_intr, IRQF_SHARED,
+			"zorro7xx-scsi", host)) {
 		printk(KERN_ERR "zorro7xx: request_irq failed\n");
-		goto out_put_host;
+		goto out_unmap;
 	}
 
 	zorro_set_drvdata(z, host);
@@ -135,12 +132,11 @@ static int __devinit zorro7xx_init_one(struct zorro_dev *z,
 
 	return 0;
 
- out_put_host:
-	scsi_host_put(host);
- out_free:
+ out_unmap:
 	if (ioaddr > 0x01000000)
 		iounmap(hostdata->base);
-	kfree(hostdata);
+ out_put_host:
+	scsi_host_put(host);
  out_release:
 	zorro_release_device(z);
 
@@ -150,13 +146,11 @@ static int __devinit zorro7xx_init_one(struct zorro_dev *z,
 static __devexit void zorro7xx_remove_one(struct zorro_dev *z)
 {
 	struct Scsi_Host *host = zorro_get_drvdata(z);
-	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 
 	scsi_remove_host(host);
-
 	NCR_700_release(host);
-	kfree(hostdata);
-	free_irq(host->irq, host);
+	free_irq(IRQ_AMIGA_PORTS, host);
+	scsi_host_put(host);
 	zorro_release_device(z);
 }
 
-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
