From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x [3/6] - cleanup adapter init
Date: Thu, 21 Aug 2003 20:16:19 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030821101619.GD7570@twibble.org>
References: <20030821101348.GA7570@twibble.org> <20030821101434.GB7570@twibble.org> <20030821101525.GC7570@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:32914 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S262540AbTHUKRG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2003 06:17:06 -0400
Content-Disposition: inline
In-Reply-To: <20030821101525.GC7570@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

Cleanup of the adapter initialization sequence. Now it's clear what
is going on and what has been done at any point. It also keeps the
initialization of various things together and not spread out over a
bunch of different functions. This then made it possible to ensure
that appropriate the resources were correctly released in the event
of failure.


diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2003-08-19 23:26:14.095115728 +1000
+++ b/drivers/scsi/dc395x.c	2003-08-19 23:26:21.672963720 +1000
@@ -224,14 +224,14 @@
 #define DC395x_SMP_IO_UNLOCK(dev,irq_flags)	spin_unlock_irqrestore(((struct Scsi_Host*)dev)->host_lock,irq_flags)
 
 
-#define DC395x_read8(acb,address)		(u8)(inb(acb->IOPortBase + (address)))
+#define DC395x_read8(acb,address)		(u8)(inb(acb->io_port_base + (address)))
 #define DC395x_read8_(address, base)		(u8)(inb((USHORT)(base) + (address)))
-#define DC395x_read16(acb,address)		(u16)(inw(acb->IOPortBase + (address)))
-#define DC395x_read32(acb,address)		(u32)(inl(acb->IOPortBase + (address)))
-#define DC395x_write8(acb,address,value)	outb((value), acb->IOPortBase + (address))
+#define DC395x_read16(acb,address)		(u16)(inw(acb->io_port_base + (address)))
+#define DC395x_read32(acb,address)		(u32)(inl(acb->io_port_base + (address)))
+#define DC395x_write8(acb,address,value)	outb((value), acb->io_port_base + (address))
 #define DC395x_write8_(address,value,base)	outb((value), (USHORT)(base) + (address))
-#define DC395x_write16(acb,address,value)	outw((value), acb->IOPortBase + (address))
-#define DC395x_write32(acb,address,value)	outl((value), acb->IOPortBase + (address))
+#define DC395x_write16(acb,address,value)	outw((value), acb->io_port_base + (address))
+#define DC395x_write32(acb,address,value)	outl((value), acb->io_port_base + (address))
 
 
 #define BUS_ADDR(sg)		sg_dma_address(&(sg))
@@ -383,7 +383,8 @@
 struct AdapterCtlBlk {
 	struct Scsi_Host *scsi_host;
 
-	u16 IOPortBase;
+	u16 io_port_base;
+	u16 io_port_len;
 
 	struct list_head dcb_list;		/* head of going dcb list */
 	struct DeviceCtlBlk *dcb_run_robin;
@@ -1793,7 +1794,6 @@
 {
 	if (timer_pending(&acb->selto_timer))
 		return;
-	init_timer(&acb->selto_timer);
 	acb->selto_timer.function = selection_timeout_missed;
 	acb->selto_timer.data = (unsigned long) acb;
 	if (time_before
@@ -4839,293 +4839,6 @@
 
 
 
-
-
-
-#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
-/*
- * Memory for trace buffers
- */
-static
-void free_tracebufs(struct AdapterCtlBlk *acb, int srb_idx)
-{
-	int i;
-	const unsigned bufs_per_page = PAGE_SIZE / DEBUGTRACEBUFSZ;
-	for (i = 0; i < srb_idx; i += bufs_per_page) {
-		/*dprintkl(KERN_DEBUG, "Free tracebuf %p (for %i)\n", */
-		/*      acb->srb_array[i].debugtrace, i); */
-		dc395x_kfree(acb->srb_array[i].debugtrace);
-	}
-}
-
-
-static
-int alloc_tracebufs(struct AdapterCtlBlk *acb)
-{
-	const unsigned mem_needed =
-	    (DC395x_MAX_SRB_CNT + 1) * DEBUGTRACEBUFSZ;
-	int pages = (mem_needed + (PAGE_SIZE - 1)) / PAGE_SIZE;
-	const unsigned bufs_per_page = PAGE_SIZE / DEBUGTRACEBUFSZ;
-	int srb_idx = 0;
-	unsigned i = 0;
-	unsigned char *ptr;
-	/*dprintkl(KERN_DEBUG, "Alloc %i pages for tracebufs\n", pages); */
-	while (pages--) {
-		ptr = dc395x_kmalloc(PAGE_SIZE, GFP_KERNEL);
-		if (!ptr) {
-			free_tracebufs(acb, srb_idx);
-			return 1;
-		}
-		/*dprintkl(KERN_DEBUG, "Alloc %li bytes at %p for tracebuf %i\n", */
-		/*      PAGE_SIZE, ptr, srb_idx); */
-		i = 0;
-		while (i < bufs_per_page && srb_idx < DC395x_MAX_SRB_CNT)
-			acb->srb_array[srb_idx++].debugtrace =
-			    ptr + (i++ * DEBUGTRACEBUFSZ);
-	}
-	if (i < bufs_per_page) {
-		acb->srb.debugtrace = ptr + (i * DEBUGTRACEBUFSZ);
-		acb->srb.debugtrace[0] = 0;
-	} else
-		dprintkl(KERN_DEBUG, "No space for tmsrb tracebuf reserved?!\n");
-	return 0;
-}
-#endif
-
-
-/* Free SG tables */
-static void free_sg_tables(struct AdapterCtlBlk *acb, int srb_idx)
-{
-	int i;
-	const unsigned srbs_per_page =
-	    PAGE_SIZE / (DC395x_MAX_SG_LISTENTRY * sizeof(struct SGentry));
-	for (i = 0; i < srb_idx; i += srbs_per_page) {
-		/*dprintkl(KERN_DEBUG, "Free SG segs %p (for %i)\n", */
-		/*      acb->srb_array[i].segment_x, i); */
-		dc395x_kfree(acb->srb_array[i].segment_x);
-	}
-}
-
-
-/*
- * Allocate SG tables; as we have to pci_map them, an SG list (struct SGentry*)
- * should never cross a page boundary */
-static int alloc_sg_tables(struct AdapterCtlBlk *acb)
-{
-	const unsigned mem_needed =
-	    (DC395x_MAX_SRB_CNT +
-	     1) * DC395x_MAX_SG_LISTENTRY * sizeof(struct SGentry);
-	int pages = (mem_needed + (PAGE_SIZE - 1)) / PAGE_SIZE;
-	const unsigned srbs_per_page =
-	    PAGE_SIZE / (DC395x_MAX_SG_LISTENTRY * sizeof(struct SGentry));
-	int srb_idx = 0;
-	unsigned i = 0;
-	struct SGentry *ptr;
-	/*dprintkl(KERN_DEBUG, "Alloc %i pages for SG tables\n", pages); */
-	while (pages--) {
-		ptr = (struct SGentry *) dc395x_kmalloc(PAGE_SIZE, GFP_KERNEL);
-		if (!ptr) {
-			free_sg_tables(acb, srb_idx);
-			return 1;
-		}
-		/*dprintkl(KERN_DEBUG, "Alloc %li bytes at %p for SG segments %i\n", */
-		/*      PAGE_SIZE, ptr, srb_idx); */
-		i = 0;
-		while (i < srbs_per_page && srb_idx < DC395x_MAX_SRB_CNT)
-			acb->srb_array[srb_idx++].segment_x =
-			    ptr + (i++ * DC395x_MAX_SG_LISTENTRY);
-	}
-	if (i < srbs_per_page)
-		acb->srb.segment_x =
-		    ptr + (i * DC395x_MAX_SG_LISTENTRY);
-	else
-		dprintkl(KERN_DEBUG, "No space for tmsrb SG table reserved?!\n");
-	return 0;
-}
-
-
-/*
- ********************************************************************
- * scsiio
- *		init_acb
- ********************************************************************
- */
-static void __init link_srb(struct AdapterCtlBlk *acb)
-{
-	int i;
-
-	for (i = 0; i < acb->srb_count - 1; i++)
-		srb_free_insert(acb, &acb->srb_array[i]);
-}
-
-
-/*
- ***********************************************************************
- *		host_init
- *
- * Function : static void init_acb
- *  Purpose :  initialize the internal structures for a given SCSI host
- *   Inputs : host - pointer to this host adapter's structure
- ***********************************************************************
- */
-static
-int __init init_acb(struct Scsi_Host *host, u32 io_port, u8 irq)
-{
-	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)host->hostdata;
-	struct NvRamType *eeprom = &acb->eeprom;
-	u16 i;
-
-	host->max_cmd_len = 24;
-	host->can_queue = DC395x_MAX_CMD_QUEUE;
-	host->cmd_per_lun = DC395x_MAX_CMD_PER_LUN;
-	host->this_id = (int) eeprom->scsi_id;
-	host->io_port = io_port;
-	host->n_io_port = 0x80;
-	host->dma_channel = -1;
-	host->unique_id = io_port;
-	host->irq = irq;
-	host->last_reset = jiffies;
-
-
-	host->max_id = 16;
-	if (host->max_id - 1 == eeprom->scsi_id)
-		host->max_id--;
-#ifdef	CONFIG_SCSI_MULTI_LUN
-	if (eeprom->channel_cfg & NAC_SCANLUN)
-		host->max_lun = 8;
-	else
-		host->max_lun = 1;
-#else
-	host->max_lun = 1;
-#endif
-	/*
-	 ********************************
-	 */
-	acb->scsi_host = host;
-	acb->IOPortBase = (u16) io_port;
-	acb->dcb_run_robin = NULL;
-	acb->active_dcb = NULL;
-	acb->srb_count = DC395x_MAX_SRB_CNT;
-	acb->scsi_host->this_id = eeprom->scsi_id;
-	acb->hostid_bit = (1 << acb->scsi_host->this_id);
-	/*acb->scsi_host->this_lun = 0; */
-	acb->irq_level = irq;
-	acb->tag_max_num = 1 << eeprom->max_tag;
-	if (acb->tag_max_num > 30)
-		acb->tag_max_num = 30;
-	acb->acb_flag = 0;	/* RESET_DETECT, RESET_DONE, RESET_DEV */
-	acb->scan_devices = 1;
-	acb->msg_len = 0;
-	acb->gmode2 = eeprom->channel_cfg;
-	if (eeprom->channel_cfg & NAC_SCANLUN)
-		acb->lun_chk = 1;
-	/* 
-	 * link all device's SRB Q of this adapter 
-	 */
-	if (alloc_sg_tables(acb)) {
-		dprintkl(KERN_DEBUG, "SG table allocation failed!\n");
-		return 1;
-	}
-#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
-	if (alloc_tracebufs(acb)) {
-		dprintkl(KERN_DEBUG, "SG trace buffer allocation failed!\n");
-		free_sg_tables(acb, DC395x_MAX_SRB_CNT);
-		return 1;
-	}
-#endif
-	INIT_LIST_HEAD(&acb->dcb_list);
-	INIT_LIST_HEAD(&acb->srb_free_list);
-	link_srb(acb);
-
-	/* 
-	 * temp SRB for Q tag used or abort command used 
-	 */
-	acb->tmp_srb = &acb->srb;
-	init_timer(&acb->waiting_timer);
-
-	for (i = 0; i < DC395x_MAX_SCSI_ID; i++)
-		acb->dcb_map[i] = 0;
-	dprintkdbg(DBG_0, "acb = %p, pdcb_map = %p, psrb_array = %p\n", acb,
-	       acb->dcb_map, acb->srb_array);
-	dprintkdbg(DBG_0, "ACB size= %04x, DCB size= %04x, SRB size= %04x\n",
-	       sizeof(struct AdapterCtlBlk), sizeof(struct DeviceCtlBlk),
-	       sizeof(struct ScsiReqBlk));
-	return 0;
-}
-
-
-/*===========================================================================
-                                Init
-  ===========================================================================*/
-/**
- * init_adapter - Initialize the SCSI chip control registers
- *
- * @host:	This hosts adapter strcuture
- * @io_port:	The base I/O port
- * @irq:	IRQ
- *
- * Returns 0 if the initialization succeeds, any other value on failure.
- **/
-static
-int __init init_adapter(struct Scsi_Host *host, u32 io_port, u8 irq)
-{
-	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)host->hostdata;
-	struct NvRamType *eeprom = &acb->eeprom;
-
-	if (!request_region(io_port, host->n_io_port, DC395X_NAME)) {
-		dprintkl(KERN_ERR, "Failed to reserve IO region 0x%x\n", io_port);
-		return -1;
-	}
-	if (request_irq(irq, dc395x_interrupt, SA_SHIRQ, DC395X_NAME, acb)) {
-	    	/* release the region we just claimed */
-		release_region(io_port, host->n_io_port);
-		dprintkl(KERN_INFO, "Failed to register IRQ!\n");
-		return -1;
-	}
-
-	acb->IOPortBase = io_port;
-
-	/* selection timeout = 250 ms */
-	acb->sel_timeout = DC395x_SEL_TIMEOUT;
-
-	/* Mask all the interrupt */
-	DC395x_write8(acb, TRM_S1040_DMA_INTEN, 0x00);
-	DC395x_write8(acb, TRM_S1040_SCSI_INTEN, 0x00);
-
-	/* Reset SCSI module */
-	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_RSTMODULE);
-
-	/* Reset PCI/DMA module */
-	DC395x_write8(acb, TRM_S1040_DMA_CONTROL, DMARESETMODULE);
-	udelay(20);
-
-	/* program configuration 0 */
-	acb->config = HCC_AUTOTERM | HCC_PARITY;
-	if (DC395x_read8(acb, TRM_S1040_GEN_STATUS) & WIDESCSI)
-		acb->config |= HCC_WIDE_CARD;
-
-	if (eeprom->channel_cfg & NAC_POWERON_SCSI_RESET)
-		acb->config |= HCC_SCSI_RESET;
-
-	if (acb->config & HCC_SCSI_RESET) {
-		dprintkl(KERN_INFO, "Performing initial SCSI bus reset\n");
-		DC395x_write8(acb, TRM_S1040_SCSI_CONTROL, DO_RSTSCSI);
-
-		/*while (!( DC395x_read8(acb, TRM_S1040_SCSI_INTSTATUS) & INT_SCSIRESET )); */
-		/*spin_unlock_irq (&io_request_lock); */
-		udelay(500);
-
-		acb->scsi_host->last_reset =
-		    jiffies + HZ / 2 +
-		    HZ * acb->eeprom.delay_time;
-
-		/*spin_lock_irq (&io_request_lock); */
-	}
-	set_basic_config(acb);
-	return 0;
-}
-
-
 /**
  * trms1040_wait_30us: wait for 30 us
  *
@@ -5431,20 +5144,161 @@
 }
 
 
+
+
 /**
- * print_config - print adapter connection and termination
+ * print_eeprom_settings - output the eeprom settings
+ * to the kernel log so people can see what they were.
+ *
+ * @eeprom: The eeprom data strucutre to show details for.
+ **/
+static
+void __init print_eeprom_settings(struct NvRamType *eeprom)
+{
+	dprintkl(KERN_INFO, "Used settings: AdapterID=%02i, Speed=%i(%02i.%01iMHz), dev_mode=0x%02x\n",
+	       eeprom->scsi_id,
+	       eeprom->target[0].period,
+	       clock_speed[eeprom->target[0].period] / 10,
+	       clock_speed[eeprom->target[0].period] % 10,
+	       eeprom->target[0].cfg0);
+	dprintkl(KERN_INFO, "               AdaptMode=0x%02x, Tags=%i(%02i), DelayReset=%is\n",
+	       eeprom->channel_cfg,
+	       eeprom->max_tag,
+	       1 << eeprom->max_tag,
+	       eeprom->delay_time);
+}
+
+
+
+#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
+/*
+ * Memory for trace buffers
+ */
+static
+void free_tracebufs(struct AdapterCtlBlk *acb)
+{
+	int i;
+	const unsigned bufs_per_page = PAGE_SIZE / DEBUGTRACEBUFSZ;
+
+	for (i = 0; i < srb_idx; i += bufs_per_page)
+		if (acb->srb_array[i].debugtrace)
+			dc395x_kfree(acb->srb_array[i].debugtrace);
+}
+
+
+static
+int alloc_tracebufs(struct AdapterCtlBlk *acb)
+{
+	const unsigned mem_needed =
+	    (DC395x_MAX_SRB_CNT + 1) * DEBUGTRACEBUFSZ;
+	int pages = (mem_needed + (PAGE_SIZE - 1)) / PAGE_SIZE;
+	const unsigned bufs_per_page = PAGE_SIZE / DEBUGTRACEBUFSZ;
+	int srb_idx = 0;
+	unsigned i = 0;
+	unsigned char *ptr;
+
+	for (i = 0; i < DC395x_MAX_SRB_CNT; i++)
+		acb->srb_array[i].debugtrace = NULL;
+
+	while (pages--) {
+		ptr = dc395x_kmalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!ptr) {
+			free_tracebufs(acb);
+			return 1;
+		}
+		/*dprintkl(KERN_DEBUG, "Alloc %li bytes at %p for tracebuf %i\n", */
+		/*      PAGE_SIZE, ptr, srb_idx); */
+		i = 0;
+		while (i < bufs_per_page && srb_idx < DC395x_MAX_SRB_CNT)
+			acb->srb_array[srb_idx++].debugtrace =
+			    ptr + (i++ * DEBUGTRACEBUFSZ);
+	}
+	if (i < bufs_per_page) {
+		acb->srb.debugtrace = ptr + (i * DEBUGTRACEBUFSZ);
+		acb->srb.debugtrace[0] = 0;
+	} else
+		dprintkl(KERN_DEBUG, "No space for tmsrb tracebuf reserved?!\n");
+	return 0;
+}
+#else
+static void free_tracebufs(struct AdapterCtlBlk *acb) {}
+static int alloc_tracebufs(struct AdapterCtlBlk *acb) { return 0; }
+#endif
+
+/* Free SG tables */
+static
+void adapter_sg_tables_free(struct AdapterCtlBlk *acb)
+{
+	int i;
+	const unsigned srbs_per_page = PAGE_SIZE/(DC395x_MAX_SG_LISTENTRY
+						  *sizeof(struct SGentry));
+
+	for (i = 0; i < DC395x_MAX_SRB_CNT; i += srbs_per_page)
+		if (acb->srb_array[i].segment_x)
+			dc395x_kfree(acb->srb_array[i].segment_x);
+}
+
+
+/*
+ * Allocate SG tables; as we have to pci_map them, an SG list (struct SGentry*)
+ * should never cross a page boundary */
+static
+int __init adapter_sg_tables_alloc(struct AdapterCtlBlk *acb)
+{
+	const unsigned mem_needed = (DC395x_MAX_SRB_CNT+1)
+	                            *DC395x_MAX_SG_LISTENTRY
+	                            *sizeof(struct SGentry);
+	int pages = (mem_needed+(PAGE_SIZE-1))/PAGE_SIZE;
+	const unsigned srbs_per_page = PAGE_SIZE/(DC395x_MAX_SG_LISTENTRY
+	                                          *sizeof(struct SGentry));
+	int srb_idx = 0;
+	unsigned i = 0;
+	struct SGentry *ptr;
+
+	for (i = 0; i < DC395x_MAX_SRB_CNT; i++)
+		acb->srb_array[i].segment_x = NULL;
+
+	dprintkdbg(DBG_1, "Allocate %i pages for SG tables\n", pages);
+	while (pages--) {
+		ptr = (struct SGentry *)dc395x_kmalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!ptr) {
+			adapter_sg_tables_free(acb);
+			return 1;
+		}
+		dprintkdbg(DBG_1, "Allocate %li bytes at %p for SG segments %i\n",
+				  PAGE_SIZE, ptr, srb_idx);
+		i = 0;
+		while (i < srbs_per_page && srb_idx < DC395x_MAX_SRB_CNT)
+			acb->srb_array[srb_idx++].segment_x =
+			    ptr + (i++ * DC395x_MAX_SG_LISTENTRY);
+	}
+	if (i < srbs_per_page)
+		acb->srb.segment_x =
+		    ptr + (i * DC395x_MAX_SG_LISTENTRY);
+	else
+		dprintkl(KERN_DEBUG, "No space for tmsrb SG table reserved?!\n");
+	return 0;
+}
+
+
+
+/**
+ * adapter_print_config - print adapter connection and termination
  * config
  *
- * @acb:	adapter control block
+ * The io port in the adapter needs to have been set before calling
+ * this function.
+ *
+ * @acb: The adapter to print the information for.
  **/
 static
-void __init print_config(struct AdapterCtlBlk *acb)
+void __init adapter_print_config(struct AdapterCtlBlk *acb)
 {
 	u8 bval;
 
 	bval = DC395x_read8(acb, TRM_S1040_GEN_STATUS);
-	dprintkl(KERN_INFO, "%c: Connectors: ",
-	       ((bval & WIDESCSI) ? 'W' : ' '));
+	dprintkl(KERN_INFO, "%s Connectors: ",
+	       ((bval & WIDESCSI) ? "(Wide)" : ""));
 	if (!(bval & CON5068))
 		printk("ext%s ", !(bval & EXT68HIGH) ? "68" : "50");
 	if (!(bval & CON68))
@@ -5471,77 +5325,235 @@
 
 
 /**
- * print_eeprom_settings - output the eeprom settings
- * to the kernel log so people can see what they were.
+ * adapter_init_params - Initialize the various parameters in the
+ * adapter structure. Note that the pointer to the scsi_host is set
+ * early (when this instance is created) and the io_port and irq
+ * values are set later after they have been reserved. This just gets
+ * everything set to a good starting position.
  *
- * @eeprom: The eeprom data strucutre to show details for.
+ * The eeprom structure in the adapter needs to have been set before
+ * calling this function.
+ *
+ * @acb: The adapter to initialize.
  **/
 static
-void __init print_eeprom_settings(struct NvRamType *eeprom)
+void __init adapter_init_params(struct AdapterCtlBlk *acb)
 {
-	dprintkl(KERN_INFO, "Used settings: AdapterID=%02i, Speed=%i(%02i.%01iMHz), dev_mode=0x%02x\n",
-	       eeprom->scsi_id,
-	       eeprom->target[0].period,
-	       clock_speed[eeprom->target[0].period] / 10,
-	       clock_speed[eeprom->target[0].period] % 10,
-	       eeprom->target[0].cfg0);
-	dprintkl(KERN_INFO, "               AdaptMode=0x%02x, Tags=%i(%02i), DelayReset=%is\n",
-	       eeprom->channel_cfg,
-	       eeprom->max_tag,
-	       1 << eeprom->max_tag,
-	       eeprom->delay_time);
+	struct NvRamType *eeprom = &acb->eeprom;
+	int i;
+
+	/* NOTE: acb->scsi_host is set at scsi_host/acb creation time */
+	/* NOTE: acb->io_port_base is set at port registration time */
+	/* NOTE: acb->io_port_len is set at port registration time */
+
+	INIT_LIST_HEAD(&acb->dcb_list);
+	acb->dcb_run_robin = NULL;
+	acb->active_dcb = NULL;
+
+	INIT_LIST_HEAD(&acb->srb_free_list);
+	/*  temp SRB for Q tag used or abort command used  */
+	acb->tmp_srb = &acb->srb;
+	init_timer(&acb->waiting_timer);
+	init_timer(&acb->selto_timer);
+
+	acb->srb_count = DC395x_MAX_SRB_CNT;
+
+	acb->sel_timeout = DC395x_SEL_TIMEOUT;	/* timeout=250ms */
+	/* NOTE: acb->irq_level is set at IRQ registration time */
+
+	acb->tag_max_num = 1 << eeprom->max_tag;
+	if (acb->tag_max_num > 30)
+		acb->tag_max_num = 30;
+
+	acb->acb_flag = 0;	/* RESET_DETECT, RESET_DONE, RESET_DEV */
+	acb->gmode2 = eeprom->channel_cfg;
+	acb->config = 0;	/* NOTE: actually set in adapter_init_chip */
+
+	if (eeprom->channel_cfg & NAC_SCANLUN)
+		acb->lun_chk = 1;
+	acb->scan_devices = 1;
+
+	acb->scsi_host->this_id = eeprom->scsi_id;
+	acb->hostid_bit = (1 << acb->scsi_host->this_id);
+
+	for (i = 0; i < DC395x_MAX_SCSI_ID; i++)
+		acb->dcb_map[i] = 0;
+
+	acb->msg_len = 0;
+	
+	/* link static array of srbs into the srb free list */
+	for (i = 0; i < acb->srb_count - 1; i++)
+		srb_free_insert(acb, &acb->srb_array[i]);
 }
 
 
-/*
- *********************************************************************
- *			DC395x_detect
+/**
+ * adapter_init_host - Initialize the scsi host instance based on
+ * values that we have already stored in the adapter instance. There's
+ * some mention that a lot of these are deprecated, so we won't use
+ * them (we'll use the ones in the adapter instance) but we'll fill
+ * them in in case something else needs them.
  *
- *      Function : static int host_init (struct Scsi_Host *host)
- *       Purpose : initialize the internal structures for a given SCSI host
- *        Inputs : host - pointer to this host adapter's structure/
- * Preconditions : when this function is called, the chip_type
- *		   field of the acb structure MUST have been set.
- *********************************************************************
- */
+ * The eeprom structure, irq and io ports in the adapter need to have
+ * been set before calling this function.
+ *
+ * @host: The scsi host instance to fill in the values for.
+ **/
 static
-struct Scsi_Host *__init host_init(Scsi_Host_Template * host_template,
-				   u32 io_port, u8 irq)
+void __init adapter_init_scsi_host(struct Scsi_Host *host)
 {
-	struct Scsi_Host *host;
-	struct AdapterCtlBlk *acb;
+        struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)host->hostdata;
+	struct NvRamType *eeprom = &acb->eeprom;
+        
+	host->max_cmd_len = 24;
+	host->can_queue = DC395x_MAX_CMD_QUEUE;
+	host->cmd_per_lun = DC395x_MAX_CMD_PER_LUN;
+	host->this_id = (int)eeprom->scsi_id;
+	host->io_port = acb->io_port_base;
+	host->n_io_port = acb->io_port_len;
+	host->dma_channel = -1;
+	host->unique_id = acb->io_port_base;
+	host->irq = acb->irq_level;
+	host->last_reset = jiffies;
 
-	host = scsi_host_alloc(host_template, sizeof(struct AdapterCtlBlk));
-	if (!host) {
-		dprintkl(KERN_INFO, "scsi_host_alloc failed\n");
+	host->max_id = 16;
+	if (host->max_id - 1 == eeprom->scsi_id)
+		host->max_id--;
+
+#ifdef CONFIG_SCSI_MULTI_LUN
+	if (eeprom->channel_cfg & NAC_SCANLUN)
+		host->max_lun = 8;
+	else
+		host->max_lun = 1;
+#else
+	host->max_lun = 1;
+#endif
+
+}
+
+
+/**
+ * adapter_init_chip - Get the chip into a know state and figure out
+ * some of the settings that apply to this adapter.
+ *
+ * The io port in the adapter needs to have been set before calling
+ * this function. The config will be configured correctly on return.
+ *
+ * @acb: The adapter which we are to init.
+ **/
+void __init adapter_init_chip(struct AdapterCtlBlk *acb)
+{
+        struct NvRamType *eeprom = &acb->eeprom;
+        
+        /* Mask all the interrupt */
+	DC395x_write8(acb, TRM_S1040_DMA_INTEN, 0x00);
+	DC395x_write8(acb, TRM_S1040_SCSI_INTEN, 0x00);
+
+	/* Reset SCSI module */
+	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_RSTMODULE);
+
+	/* Reset PCI/DMA module */
+	DC395x_write8(acb, TRM_S1040_DMA_CONTROL, DMARESETMODULE);
+	udelay(20);
+
+	/* program configuration 0 */
+	acb->config = HCC_AUTOTERM | HCC_PARITY;
+	if (DC395x_read8(acb, TRM_S1040_GEN_STATUS) & WIDESCSI)
+		acb->config |= HCC_WIDE_CARD;
+
+	if (eeprom->channel_cfg & NAC_POWERON_SCSI_RESET)
+		acb->config |= HCC_SCSI_RESET;
+
+	if (acb->config & HCC_SCSI_RESET) {
+		dprintkl(KERN_INFO, "Performing initial SCSI bus reset\n");
+		DC395x_write8(acb, TRM_S1040_SCSI_CONTROL, DO_RSTSCSI);
+
+		/*while (!( DC395x_read8(acb, TRM_S1040_SCSI_INTSTATUS) & INT_SCSIRESET )); */
+		/*spin_unlock_irq (&io_request_lock); */
+		udelay(500);
+
+		acb->scsi_host->last_reset =
+		    jiffies + HZ / 2 +
+		    HZ * acb->eeprom.delay_time;
+
+		/*spin_lock_irq (&io_request_lock); */
+	}
+}
+
+
+/**
+ * init_adapter - Grab the resource for the card, setup the adapter
+ * information, set the card into a known state, create the various
+ * tables etc etc. This basically gets all adapter information all up
+ * to date, intialised and gets the chip in sync with it.
+ *
+ * @host:	This hosts adapter structure
+ * @io_port:	The base I/O port
+ * @irq:	IRQ
+ *
+ * Returns 0 if the initialization succeeds, any other value on
+ * failure.
+ **/
+static
+int __init adapter_init(struct AdapterCtlBlk *acb, u32 io_port, u32 io_port_len, u8 irq)
+{
+	if (!request_region(io_port, io_port_len, DC395X_NAME)) {
+		dprintkl(KERN_ERR, "Failed to reserve IO region 0x%x\n", io_port);
 		goto failed;
 	}
- 	acb = (struct AdapterCtlBlk *)host->hostdata;
+	/* store port base to indicate we have registered it */
+	acb->io_port_base = io_port;
+	acb->io_port_len = io_port_len;
+	
+	if (request_irq(irq, dc395x_interrupt, SA_SHIRQ, DC395X_NAME, acb)) {
+	    	/* release the region we just claimed */
+		dprintkl(KERN_INFO, "Failed to register IRQ\n");
+		goto failed;
+	}
+	/* store irq to indicate we have registered it */
+	acb->irq_level = irq;
 
+	/* get eeprom configuration information and command line settings etc */
 	check_eeprom(&acb->eeprom, (u16)io_port);
  	print_eeprom_settings(&acb->eeprom);
 
- 	if (init_acb(host, io_port, irq)) {
+	/* setup adapter control block */	
+	adapter_init_params(acb);
+	
+	/* display card connectors/termination settings */
+ 	adapter_print_config(acb);
+
+	if (adapter_sg_tables_alloc(acb)) {
+		dprintkl(KERN_DEBUG, "Memory allocation for SG tables failed\n");
 		goto failed;
 	}
- 	print_config(acb);
-
- 	if (init_adapter(host, io_port, irq)) {
-		dprintkl(KERN_INFO, "DC395x_initAdapter initial ERROR\n");
+	if (alloc_tracebufs(acb)) {
+		dprintkl(KERN_DEBUG, "Memory allocation for trace buffers failed\n");
 		goto failed;
 	}
+	adapter_init_scsi_host(acb->scsi_host);
+	adapter_init_chip(acb);
+	set_basic_config(acb);
 
-	return host;
+	dprintkdbg(DBG_0, "adapter_init: acb=%p, pdcb_map=%p "
+	                  "psrb_array=%p ACB size=%04x, DCB size=%04x "
+	                  "SRB size=%04x\n",
+		   acb, acb->dcb_map, acb->srb_array, sizeof(struct AdapterCtlBlk),
+		   sizeof(struct DeviceCtlBlk), sizeof(struct ScsiReqBlk));
+	return 0;
 
 failed:
-	if (host)
-		scsi_host_put(host);
-	return NULL;
+	if (acb->irq_level)
+		free_irq(acb->irq_level, acb);
+	if (acb->io_port_base)
+		release_region(acb->io_port_base, acb->io_port_len);
+	adapter_sg_tables_free(acb);
+	free_tracebufs(acb);
+
+	return 1;
 }
 
-#undef SEARCH
-#undef YESNO
-#undef SCANF
+
 
 
 /*
@@ -5568,6 +5580,7 @@
 #undef SPRINTF
 #define SPRINTF(args...) pos += sprintf(pos, args)
 
+#undef YESNO
 #define YESNO(YN) \
  if (YN) SPRINTF(" Yes ");\
  else SPRINTF(" No  ")
@@ -5594,7 +5607,7 @@
 	SPRINTF("SCSI Host Nr %i, ", host->host_no);
 	SPRINTF("DC395U/UW/F DC315/U %s\n",
 		(acb->config & HCC_WIDE_CARD) ? "Wide" : "");
-	SPRINTF("IOPortBase 0x%04x, ", acb->IOPortBase);
+	SPRINTF("io_port_base 0x%04x, ", acb->io_port_base);
 	SPRINTF("irq_level 0x%02x, ", acb->irq_level);
 	SPRINTF(" SelTimeout %ims\n", (1638 * acb->sel_timeout) / 1000);
 
@@ -5730,9 +5743,9 @@
 
 	/* release chip resources */
 #if debug_enabled(DBG_TRACE|DBG_TRACEALL)
-	free_tracebufs(acb, DC395x_MAX_SRB_CNT);
+	free_tracebufs(acb);
 #endif
-	free_sg_tables(acb, DC395x_MAX_SRB_CNT);
+	adapter_sg_tables_free(acb);
 }
 
 
@@ -5786,6 +5799,22 @@
 
 
 /**
+ * banner_display - Display banner on first instance of driver
+ * initialized.
+ **/
+static
+void banner_display(void)
+{
+	static int banner_done = 0;
+	if (!banner_done)
+	{
+		dprintkl(KERN_INFO, "%s %s\n", DC395X_BANNER, DC395X_VERSION);
+		banner_done = 1;
+	}
+}
+
+
+/**
  * dc395x_init_one - Initialise a single instance of the adapter.
  *
  * The PCI layer will call this once for each instance of the adapter
@@ -5802,51 +5831,55 @@
 int __devinit dc395x_init_one(struct pci_dev *dev,
 			      const struct pci_device_id *id)
 {
-	unsigned int io_port;
-	u8 irq;
 	struct Scsi_Host *scsi_host;
-	static int banner_done = 0;
-	int error = 0;
-
-	dprintkdbg(DBG_0, "Init one instance of the dc395x\n");
-	if (!banner_done)
-	{
-		dprintkl(KERN_INFO, "%s %s\n", DC395X_BANNER, DC395X_VERSION);
-		banner_done = 1;
-	}
+	struct AdapterCtlBlk *acb;
+	unsigned int io_port_base;
+	unsigned int io_port_len;
+	u8 irq;
+	
+	dprintkdbg(DBG_0, "Init one instance (%s)\n", pci_name(dev));
+	banner_display();
 
 	if (pci_enable_device(dev))
 	{
 		dprintkl(KERN_INFO, "PCI Enable device failed.\n");
 		return -ENODEV;
 	}
-
-	dprintkdbg(DBG_0, "Get resources...\n");
-	io_port = pci_resource_start(dev, 0) & PCI_BASE_ADDRESS_IO_MASK;
+	io_port_base = pci_resource_start(dev, 0) & PCI_BASE_ADDRESS_IO_MASK;
+	io_port_len = 0x80;	/* XXX: use pci_resource_len? */
 	irq = dev->irq;
-	dprintkdbg(DBG_0, "IO_PORT=%04x,IRQ=%x\n", (unsigned int) io_port, irq);
+	dprintkdbg(DBG_0, "IO_PORT=%04x, IRQ=%x\n", io_port_base, dev->irq);
 
-	scsi_host = host_init(&dc395x_driver_template, io_port, irq);
-	if (!scsi_host)
-	{
-		dprintkdbg(DBG_0, "host_init failed\n");
+	/* allocate scsi host information (includes out adapter) */
+	scsi_host = scsi_host_alloc(&dc395x_driver_template,
+				    sizeof(struct AdapterCtlBlk));
+	if (!scsi_host) {
+		dprintkl(KERN_INFO, "scsi_host_alloc failed\n");
 		return -ENOMEM;
 	}
-	((struct AdapterCtlBlk *)(scsi_host->hostdata))->dev = dev;
+ 	acb = (struct AdapterCtlBlk*)scsi_host->hostdata;
+ 	acb->scsi_host = scsi_host;
+
+	/* initialise the adapter and everything we need */
+ 	if (adapter_init(acb, io_port_base, io_port_len, irq)) {
+		dprintkl(KERN_INFO, "DC395x_initAdapter initial ERROR\n");
+		scsi_host_put(scsi_host);
+		return -ENODEV;
+	}
+
 	pci_set_master(dev);
 	pci_set_drvdata(dev, scsi_host);
 
 	/* get the scsi mid level to scan for new devices on the bus */
-	error = scsi_add_host(scsi_host, &dev->dev);
-	if (error) {
+	if (scsi_add_host(scsi_host, &dev->dev)) {
 		dprintkl(KERN_ERR, "scsi_add_host failed\n");
-                error = -ENODEV;
                 host_release(scsi_host);
                 scsi_host_put(scsi_host);
-	} else
-        	scsi_scan_host(scsi_host);
+		return -ENODEV;
+	}
+	scsi_scan_host(scsi_host);
         	
-	return error;
+	return 0;
 }
 
 
-- 
 Jamie Lenehan <lenehan@twibble.org>
