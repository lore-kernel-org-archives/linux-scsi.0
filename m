From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH / RFC] sym53c8xx_2 dev_printk
Date: Fri, 20 Feb 2004 12:10:32 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040220201032.GF1113@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:22448 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261305AbUBTUF7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2004 15:05:59 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <willy@debian.org>

I sent a earlier copy of this patch to Matthew, but have not heard
anything back. I assumed that he was busy with more important tasks.

I ran this patch on a power 270 system and attached a portion of the
dmesg file.

One thing that might be good would be to shrink some message lines to
try to stay with in 80 cols.

Switching from sym_name to this id gives a quick id that can be found in
the the sysfs tree and which does not vary with hotplug / (insmod /
rmmod) events.

# dmesg output
PCI: Enabling device: (0000:00:0c.0), cmd 143
sym53c8xx 0000:00:0c.0: chip <875> rev 0x4 at pci 0000:00:0c.0 irq 17
sym53c8xx 0000:00:0c.0: No NVRAM, ID 7, Fast-20, SE, parity checking
sym53c8xx 0000:00:0c.0: SCSI BUS has been reset.
scsi0 : sym-2.1.18f
sym53c8xx 0000:00:0c.0: 0: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 16)
  Vendor: IBM       Model: IC35L036UWD210-0  Rev: S5BS
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym53c8xx 0000:00:0c.0: 0:0: tagged command queuing enabled, command queue depth 16.
  Vendor: IBM       Model: CDRM00203     !K  Rev: 1_06
  Type:   CD-ROM                             ANSI SCSI revision: 02
sym53c8xx 0000:00:0c.0: 8: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 16)
  Vendor: IBM       Model: ST336605LC        Rev: C50B
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym53c8xx 0000:00:0c.0: 8:0: tagged command queuing enabled, command queue depth 16.
sym53c8xx 0000:00:0c.0: 9: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 16)
  Vendor: IBM       Model: ST336605LC        Rev: C50B
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym53c8xx 0000:00:0c.0: 9:0: tagged command queuing enabled, command queue depth 16.
PCI: Enabling device: (0000:00:11.0), cmd 143
sym53c8xx 0000:00:11.0: chip <895> rev 0x2 at pci 0000:00:11.0 irq 20
sym53c8xx 0000:00:11.0: No NVRAM, ID 7, Fast-40, LVD, parity checking
sym53c8xx 0000:00:11.0: SCSI BUS has been reset.
scsi1 : sym-2.1.18f
sym53c8xx 0000:00:0c.0: 1: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 15)


-andmike
--
Michael Anderson
andmike@us.ibm.com

DESC
Add dev_printk support to the sym53c8xx_2 driver.

patch_version: Fri Feb 20 20:07:48 UTC 2004
EDESC


 patched-2.6-andmike/drivers/scsi/sym53c8xx_2/sym_fw.c    |   10 -
 patched-2.6-andmike/drivers/scsi/sym53c8xx_2/sym_glue.c  |  104 ++++------
 patched-2.6-andmike/drivers/scsi/sym53c8xx_2/sym_glue.h  |   37 ++-
 patched-2.6-andmike/drivers/scsi/sym53c8xx_2/sym_hipd.c  |  149 +++++++--------
 patched-2.6-andmike/drivers/scsi/sym53c8xx_2/sym_misc.c  |   10 -
 patched-2.6-andmike/drivers/scsi/sym53c8xx_2/sym_nvram.c |   14 -
 6 files changed, 170 insertions(+), 154 deletions(-)

diff -puN drivers/scsi/sym53c8xx_2/sym_fw.c~sym2-dev_printk drivers/scsi/sym53c8xx_2/sym_fw.c
--- patched-2.6/drivers/scsi/sym53c8xx_2/sym_fw.c~sym2-dev_printk	Fri Feb 20 17:47:18 2004
+++ patched-2.6-andmike/drivers/scsi/sym53c8xx_2/sym_fw.c	Fri Feb 20 17:47:18 2004
@@ -409,8 +409,8 @@ void sym_fw_bind_script (hcb_p np, u32 *
 		 *  command.
 		 */
 		if (opcode == 0) {
-			printf ("%s: ERROR0 IN SCRIPT at %d.\n",
-				sym_name(np), (int) (cur-start));
+			sym_printf_err(np, "ERROR0 IN SCRIPT at %d.\n",
+				(int) (cur-start));
 			MDELAY (10000);
 			++cur;
 			continue;
@@ -426,7 +426,7 @@ void sym_fw_bind_script (hcb_p np, u32 *
 		}
 
 		if (DEBUG_FLAGS & DEBUG_SCRIPT)
-			printf ("%d:  <%x>\n", (int) (cur-start),
+			sym_printf_debug(np, "%d:  <%x>\n", (int) (cur-start),
 				(unsigned)opcode);
 
 		/*
@@ -453,8 +453,8 @@ void sym_fw_bind_script (hcb_p np, u32 *
 			tmp1 = cur[1];
 			tmp2 = cur[2];
 			if ((tmp1 ^ tmp2) & 3) {
-				printf ("%s: ERROR1 IN SCRIPT at %d.\n",
-					sym_name(np), (int) (cur-start));
+				sym_printf_err(np, "ERROR1 IN SCRIPT at %d.\n",
+					(int) (cur-start));
 				MDELAY (10000);
 			}
 			/*
diff -puN drivers/scsi/sym53c8xx_2/sym_glue.c~sym2-dev_printk drivers/scsi/sym53c8xx_2/sym_glue.c
--- patched-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c~sym2-dev_printk	Fri Feb 20 17:47:18 2004
+++ patched-2.6-andmike/drivers/scsi/sym53c8xx_2/sym_glue.c	Fri Feb 20 17:47:18 2004
@@ -260,8 +260,8 @@ void sym_print_addr(struct sym_ccb *cp)
 {
 	struct scsi_cmnd *cmd = cp->cam_ccb;
 	if (cmd)
-		printf("%s:%d:%d:", sym_name(SYM_SOFTC_PTR(cmd)),
-				cmd->device->id, cmd->device->lun);
+		sym_printf(SYM_SOFTC_PTR(cmd), "%d:%d:", cmd->device->id,
+			   cmd->device->lun);
 }
 
 /*
@@ -269,12 +269,12 @@ void sym_print_addr(struct sym_ccb *cp)
  */
 void sym_xpt_async_bus_reset(struct sym_hcb *np)
 {
-	printf_notice("%s: SCSI BUS has been reset.\n", sym_name(np));
+	sym_printf_notice(np, "SCSI BUS has been reset.\n");
 	np->s.settle_time = jiffies + sym_driver_setup.settle_delay * HZ;
 	np->s.settle_time_valid = 1;
 	if (sym_verbose >= 2)
-		printf_info("%s: command processing suspended for %d seconds\n",
-			    sym_name(np), sym_driver_setup.settle_delay);
+		sym_printf_info(np, "command processing suspended for %d "
+			"seconds\n", sym_driver_setup.settle_delay);
 }
 
 /*
@@ -282,7 +282,7 @@ void sym_xpt_async_bus_reset(struct sym_
  */
 void sym_xpt_async_sent_bdr(struct sym_hcb *np, int target)
 {
-	printf_notice("%s: TARGET %d has been reset.\n", sym_name(np), target);
+	sym_printf_notice(np, "TARGET %d has been reset.\n", target);
 }
 
 /*
@@ -370,7 +370,7 @@ void sym_set_cam_result_error(struct sym
 	else {						/* Extended error */
 		if (sym_verbose) {
 			PRINT_ADDR(cp);
-			printf ("COMMAND FAILED (%x %x %x).\n",
+			sym_printf_info(np, "COMMAND FAILED (%x %x %x).\n",
 				cp->host_status, cp->ssss_status,
 				cp->xerr_status);
 		}
@@ -649,8 +649,8 @@ static void sym_timer(struct sym_hcb *np
 	if (np->s.settle_time_valid) {
 		if (time_before_eq(np->s.settle_time, thistime)) {
 			if (sym_verbose >= 2 )
-				printk("%s: command processing resumed\n",
-				       sym_name(np));
+				sym_printf_info(np,
+				       "command processing resumed\n");
 			np->s.settle_time_valid = 0;
 		}
 		return;
@@ -686,8 +686,7 @@ void sym_log_bus_error(struct sym_hcb *n
 	pci_read_config_word(np->s.device, PCI_STATUS, &pci_sts);
 	if (pci_sts & 0xf900) {
 		pci_write_config_word(np->s.device, PCI_STATUS, pci_sts);
-		printf("%s: PCI STATUS = 0x%04x\n",
-			sym_name(np), pci_sts & 0xf900);
+		sym_printf_err(np, "PCI STATUS = 0x%04x\n", pci_sts & 0xf900);
 	}
 }
 
@@ -765,7 +764,7 @@ static irqreturn_t sym53c8xx_intr(int ir
 	unsigned long flags;
 	struct sym_hcb *np = (struct sym_hcb *)dev_id;
 
-	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("[");
+	if (DEBUG_FLAGS & DEBUG_TINY) sym_printf_debug(np, "[");
 
 	spin_lock_irqsave(np->s.host->host_lock, flags);
 
@@ -779,7 +778,7 @@ static irqreturn_t sym53c8xx_intr(int ir
 
 	spin_unlock_irqrestore(np->s.host->host_lock, flags);
 
-	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("]\n");
+	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug(np, "]\n");
 
 	return IRQ_HANDLED;
 }
@@ -864,11 +863,9 @@ static int sym_eh_handler(int op, char *
 	int to_do = SYM_EH_DO_IGNORE;
 	int sts = -1;
 	struct sym_eh_wait eh, *ep = &eh;
-	char devname[20];
 
-	sprintf(devname, "%s:%d:%d", sym_name(np), cmd->device->id, cmd->device->lun);
-
-	printf_warning("%s: %s operation started.\n", devname, opname);
+	sym_printf_warning(np, "%s: %s operation started.\n",
+			   cmd->device->sdev_gendev.bus_id, opname);
 
 #if 0
 	/* This one should be the result of some race, thus to ignore */
@@ -958,7 +955,8 @@ finish:
 		if (ep->timed_out)
 			sts = -2;
 	}
-	printf_warning("%s: %s operation %s.\n", devname, opname,
+	sym_printf_warning(np, "%s: %s operation %s.\n",
+			cmd->device->sdev_gendev.bus_id, opname,
 			sts==0?"complete":sts==-2?"timed-out":"failed");
 	return sts? SCSI_FAILED : SCSI_SUCCESS;
 }
@@ -1009,10 +1007,9 @@ static void sym_tune_dev_queuing(struct 
 	lp->s.reqtags     = reqtags;
 
 	if (reqtags != oldtags) {
-		printf_info("%s:%d:%d: "
+		sym_printf_info(np, "%d:%d: "
 		         "tagged command queuing %s, command queue depth %d.\n",
-		          sym_name(np), target, lun,
-		          lp->s.reqtags ? "enabled" : "disabled",
+		          target, lun, lp->s.reqtags ? "enabled" : "disabled",
  		          lp->started_limit);
 	}
 }
@@ -1604,8 +1601,7 @@ static int sym_setup_bus_dma_mask(struct
 	if (np->features & FE_DAC) {
 		if (!pci_set_dma_mask(np->s.device, PciDmaMask)) {
 			np->use_dac = 1;
-			printf_info("%s: using 64 bit DMA addressing\n",
-					sym_name(np));
+			sym_printf_info(np, "using 64 bit DMA addressing\n");
 		} else {
 			if (pci_set_dma_mask(np->s.device, 0xffffffffUL))
 				goto out_err32;
@@ -1616,8 +1612,7 @@ static int sym_setup_bus_dma_mask(struct
 	return 0;
 
 out_err32:
-	printf_warning("%s: 32 BIT DMA ADDRESSING NOT SUPPORTED\n",
-			sym_name(np));
+	sym_printf_warning(np, "32 BIT DMA ADDRESSING NOT SUPPORTED\n");
 	return -1;
 }
 
@@ -1639,18 +1634,20 @@ static struct Scsi_Host * __devinit sym_
 	unsigned long flags;
 	struct sym_fw *fw;
 
-	printk(KERN_INFO
-		"sym%d: <%s> rev 0x%x at pci %s "
 #ifdef __sparc__
-		"irq %s\n",
-#else
-		"irq %d\n",
-#endif
-		unit, dev->chip.name, dev->chip.revision_id,
+	/*
+	 * sparc's irq is a string.
+	 */
+	dev_printk(KERN_INFO, &dev->pdev->dev,
+		"chip <%s> rev 0x%x at pci %s irq %s\n",
+		dev->chip.name, dev->chip.revision_id,
 		pci_name(dev->pdev),
-#ifdef __sparc__
 		__irq_itoa(dev->s.irq));
 #else
+	dev_printk(KERN_INFO, &dev->pdev->dev,
+		"chip <%s> rev 0x%x at pci %s irq %d\n",
+		dev->chip.name, dev->chip.revision_id,
+		pci_name(dev->pdev),
 		dev->s.irq);
 #endif
 
@@ -1704,7 +1701,6 @@ static struct Scsi_Host * __devinit sym_
 	 *  Edit its name.
 	 */
 	strlcpy(np->s.chip_name, dev->chip.name, sizeof(np->s.chip_name));
-	sprintf(np->s.inst_name, "sym%d", np->s.unit);
 
 	/*
 	 *  Ask/tell the system about DMA addressing.
@@ -1722,10 +1718,10 @@ static struct Scsi_Host * __devinit sym_
 #ifndef SYM_CONF_IOMAPPED
 	np->s.mmio_va = ioremap(dev->s.base_c, np->s.io_ws);
 	if (!np->s.mmio_va) {
-		printf_err("%s: can't map PCI MMIO region\n", sym_name(np));
+		sym_printf_err(np, "can't map PCI MMIO region\n");
 		goto attach_failed;
 	} else if (sym_verbose > 1)
-		printf_info("%s: using memory mapped IO\n", sym_name(np));
+		sym_printf_info(np, "using memory mapped IO\n");
 #endif /* !defined SYM_CONF_IOMAPPED */
 
 	np->s.io_port = dev->s.io_port;
@@ -1743,8 +1739,7 @@ static struct Scsi_Host * __devinit sym_
 			np->ram_ws = 4096;
 		np->s.ram_va = ioremap(dev->s.base_2_c, np->ram_ws);
 		if (!np->s.ram_va) {
-			printf_err("%s: can't map PCI MEMORY region\n",
-				sym_name(np));
+			sym_printf_err(np, "can't map PCI MEMORY region\n");
 			goto attach_failed;
 		}
 	}
@@ -1763,8 +1758,7 @@ static struct Scsi_Host * __devinit sym_
 	 */
 	if (request_irq(dev->s.irq, sym53c8xx_intr, SA_SHIRQ,
 			NAME53C8XX, np)) {
-		printf_err("%s: request irq %d failure\n",
-			sym_name(np), dev->s.irq);
+		sym_printf_err(np, "request irq %d failure\n", dev->s.irq);
 		goto attach_failed;
 	}
 	np->s.irq = dev->s.irq;
@@ -1823,13 +1817,13 @@ static struct Scsi_Host * __devinit sym_
 	return instance;
 
  reset_failed:
-	printf_err("%s: FATAL ERROR: CHECK SCSI BUS - CABLES, "
-		   "TERMINATION, DEVICE POWER etc.!\n", sym_name(np));
+	sym_printf_err(np, " FATAL ERROR: CHECK SCSI BUS - CABLES, "
+		   "TERMINATION, DEVICE POWER etc.!\n");
 	spin_unlock_irqrestore(instance->host_lock, flags);
  attach_failed:
 	if (!instance)
 		return NULL;
-	printf_info("%s: giving up ...\n", sym_name(np));
+	dev_printk(KERN_INFO, &dev->pdev->dev, "giving up ...\n");
 	if (np)
 		sym_free_resources(np);
 	scsi_host_put(instance);
@@ -2026,10 +2020,6 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 	u_short device_id, status_reg;
 	u_char revision;
 
-	/* Choose some short name for this device */
-	sprintf(device->s.inst_name, "sym.%d.%d.%d", pdev->bus->number,
-			PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
-
 	device_id = pdev->device;
 
 	io_port = pdev->resource[0].start;
@@ -2060,7 +2050,7 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 	 */
 	chip = sym_lookup_pci_chip_table(device_id, revision);
 	if (!chip) {
-		printf_info("%s: device not supported\n", sym_name(device));
+		dev_printk(KERN_INFO, &pdev->dev, "device not supported\n");
 		return -1;
 	}
 
@@ -2070,14 +2060,14 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 	 */
 #ifdef SYM_CONF_IOMAPPED
 	if (!io_port) {
-		printf_info("%s: IO base address disabled.\n",
-			    sym_name(device));
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "IO base address disabled.\n");
 		return -1;
 	}
 #else
 	if (!base) {
-		printf_info("%s: MMIO base address disabled.\n",
-			    sym_name(device));
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "MMIO base address disabled.\n");
 		return -1;
 	}
 #endif
@@ -2101,9 +2091,9 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 			ram_val = readl_raw(ram_ptr + ram_size - 16);
 			iounmap(ram_ptr);
 			if (ram_val == 0x52414944) {
-				printf_info("%s: not initializing, "
-					    "driven by RAID controller.\n",
-					    sym_name(device));
+				dev_printk(KERN_INFO, &pdev->dev,
+					   "not initializing, driven by "
+					   "RAID controller.\n");
 				return -1;
 			}
 		}
@@ -2179,7 +2169,7 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
  */
 static int sym_detach(struct sym_hcb *np)
 {
-	printk("%s: detaching ...\n", sym_name(np));
+	sym_printf_info(np, "detaching ...\n");
 
 	del_timer_sync(&np->s.timer);
 
@@ -2188,7 +2178,7 @@ static int sym_detach(struct sym_hcb *np
 	 * We should use sym_soft_reset(), but we don't want to do 
 	 * so, since we may not be safe if interrupts occur.
 	 */
-	printk("%s: resetting chip\n", sym_name(np));
+	sym_printf_info(np, "resetting chip\n");
 	OUTB (nc_istat, SRST);
 	UDELAY (10);
 	OUTB (nc_istat, 0);
diff -puN drivers/scsi/sym53c8xx_2/sym_glue.h~sym2-dev_printk drivers/scsi/sym53c8xx_2/sym_glue.h
--- patched-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h~sym2-dev_printk	Fri Feb 20 17:47:18 2004
+++ patched-2.6-andmike/drivers/scsi/sym53c8xx_2/sym_glue.h	Fri Feb 20 17:47:18 2004
@@ -93,17 +93,38 @@
 #define SYM_OPT_LIMIT_COMMAND_REORDERING
 #define	SYM_OPT_ANNOUNCE_TRANSFER_RATE
 
+#define sym_printk(level, symp, args...)	\
+		dev_printk(level, &(symp)->s.device->dev, ## args)
+
 /*
  *  Print a message with severity.
  */
-#define printf_emerg(args...)	printk(KERN_EMERG args)
-#define	printf_alert(args...)	printk(KERN_ALERT args)
-#define	printf_crit(args...)	printk(KERN_CRIT args)
-#define	printf_err(args...)	printk(KERN_ERR	args)
-#define	printf_warning(args...)	printk(KERN_WARNING args)
-#define	printf_notice(args...)	printk(KERN_NOTICE args)
-#define	printf_info(args...)	printk(KERN_INFO args)
-#define	printf_debug(args...)	printk(KERN_DEBUG args)
+#define sym_printf_emerg(symp, args...)	\
+	sym_printk(KERN_EMERG, symp, args)
+#define	sym_printf_alert(symp, args...)	\
+	sym_printk(KERN_ALERT, symp, args)
+#define	sym_printf_crit(symp, args...)	\
+	sym_printk(KERN_CRIT, symp, args)
+#define	sym_printf_err(symp, args...)	\
+	sym_printk(KERN_ERR, symp, args)
+#define	sym_printf_warning(symp, args...)	\
+	sym_printk(KERN_WARNING, symp, args)
+#define	sym_printf_notice(symp, args...)	\
+	sym_printk(KERN_NOTICE, symp, args)
+#define	sym_printf_info(symp, args...)	\
+	sym_printk(KERN_INFO, symp, args)
+#define	sym_printf_debug(symp, args...)	\
+	sym_printk(KERN_DEBUG, symp, args)
+
+/*
+ * sym_printf: use info level.
+ */
+#define	sym_printf(symp, args...)	sym_printf_info(symp, args)
+
+/*
+ * No prefix or level printf's:
+ */
+#define	printf_debug(symp, args...)	printk(args)
 #define	printf(args...)		printk(args)
 
 /*
diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.c~sym2-dev_printk drivers/scsi/sym53c8xx_2/sym_hipd.c
--- patched-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c~sym2-dev_printk	Fri Feb 20 17:47:18 2004
+++ patched-2.6-andmike/drivers/scsi/sym53c8xx_2/sym_hipd.c	Fri Feb 20 17:47:18 2004
@@ -81,6 +81,7 @@ char *sym_driver_name(void)
 {
 	return SYM_DRIVER_NAME;
 }
+
 /*
  *  Print a buffer in hexadecimal format.
  */
@@ -106,12 +107,12 @@ static void sym_printl_hex (char *label,
  */
 static void sym_print_target (hcb_p np, int target)
 {
-	printf ("%s:%d:", sym_name(np), target);
+	sym_printf(np, "%d:", target);
 }
 
 static void sym_print_lun(hcb_p np, int target, int lun)
 {
-	printf ("%s:%d:%d:", sym_name(np), target, lun);
+	sym_printf(np, "%d:%d:", target, lun);
 }
 
 /*
@@ -241,8 +242,8 @@ static void sym_soft_reset (hcb_p np)
 	}
 	OUTB (nc_istat, 0);
 	if (!i)
-		printf("%s: unable to abort current chip operation, "
-		       "ISTAT=0x%02x.\n", sym_name(np), istat);
+		sym_printf_warning(np, "unable to abort current chip "
+			"operation, ISTAT=0x%02x.\n", istat);
 do_chip_reset:
 	sym_chip_reset (np);
 }
@@ -293,11 +294,11 @@ int sym_reset_scsi_bus(hcb_p np, int ena
 		term &= 0x3ffff;
 
 	if (term != (2<<7)) {
-		printf("%s: suspicious SCSI data while resetting the BUS.\n",
-			sym_name(np));
-		printf("%s: %sdp0,d7-0,rst,req,ack,bsy,sel,atn,msg,c/d,i/o = "
+		sym_printf_warning(np,
+			"suspicious SCSI data while resetting the BUS.\n");
+		sym_printf_warning(np,
+			"%sdp0,d7-0,rst,req,ack,bsy,sel,atn,msg,c/d,i/o = "
 			"0x%lx, expecting 0x%lx\n",
-			sym_name(np),
 			(np->features & FE_WIDE) ? "dp1,d15-8," : "",
 			(u_long)term, (u_long)(2<<7));
 		if (SYM_SETUP_SCSI_BUS_CHECK == 1)
@@ -323,7 +324,7 @@ static void sym_selectclock(hcb_p np, u_
 	}
 
 	if (sym_verbose >= 2)
-		printf ("%s: enabling clock multiplier\n", sym_name(np));
+		sym_printf_info(np, "enabling clock multiplier\n");
 
 	OUTB(nc_stest1, DBLEN);	   /* Enable clock multiplier		  */
 	/*
@@ -335,8 +336,8 @@ static void sym_selectclock(hcb_p np, u_
 		while (!(INB(nc_stest4) & LCKFRQ) && --i > 0)
 			UDELAY (20);
 		if (!i)
-			printf("%s: the chip cannot lock the frequency\n",
-				sym_name(np));
+			sym_printf_warning(np,
+				"the chip cannot lock the frequency\n");
 	} else
 		UDELAY ((50+10));
 	OUTB(nc_stest3, HSC);		/* Halt the scsi clock		*/
@@ -433,8 +434,8 @@ static unsigned getfreq (hcb_p np, int g
 		f = (f * 2) / 3;
 
 	if (sym_verbose >= 2)
-		printf ("%s: Delay (GEN=%d): %u msec, %u KHz\n",
-			sym_name(np), gen, ms/4, f);
+		sym_printf_info(np, "Delay (GEN=%d): %u msec, %u KHz\n",
+			gen, ms/4, f);
 
 	return f;
 }
@@ -467,7 +468,7 @@ static void sym_getclock (hcb_p np, int 
 	 */
 	if (mult > 1 && (stest1 & (DBLEN+DBLSEL)) == DBLEN+DBLSEL) {
 		if (sym_verbose >= 2)
-			printf ("%s: clock multiplier found\n", sym_name(np));
+			sym_printf_info(np, "clock multiplier found\n");
 		np->multiplier = mult;
 	}
 
@@ -481,7 +482,7 @@ static void sym_getclock (hcb_p np, int 
 		f1 = sym_getfreq (np);
 
 		if (sym_verbose)
-			printf ("%s: chip clock is %uKHz\n", sym_name(np), f1);
+			sym_printf_info(np, "chip clock is %uKHz\n", f1);
 
 		if	(f1 <	45000)		f1 =  40000;
 		else if (f1 <	55000)		f1 =  50000;
@@ -489,8 +490,7 @@ static void sym_getclock (hcb_p np, int 
 
 		if (f1 < 80000 && mult > 1) {
 			if (sym_verbose >= 2)
-				printf ("%s: clock multiplier assumed\n",
-					sym_name(np));
+				sym_printf_info(np, "clock multiplier assumed\n");
 			np->multiplier	= mult;
 		}
 	} else {
@@ -696,8 +696,8 @@ static void sym_print_targets_flag(hcb_p
 			continue;
 		if (np->target[i].usrflags & mask) {
 			if (!cnt++)
-				printf("%s: %s disabled for targets",
-					sym_name(np), msg);
+				sym_printf_info(np, "%s disabled for targets",
+					msg);
 			printf(" %d", i);
 		}
 	}
@@ -1072,7 +1072,7 @@ static int sym_prepare_setting(hcb_p np,
 	 *  Let user know about the settings.
 	 */
 	i = nvram->type;
-	printf("%s: %s NVRAM, ID %d, Fast-%d, %s, %s\n", sym_name(np),
+	sym_printf_info(np, "%s NVRAM, ID %d, Fast-%d, %s, %s\n",
 		i  == SYM_SYMBIOS_NVRAM ? "Symbios" :
 		(i == SYM_TEKRAM_NVRAM  ? "Tekram" : "No"),
 		np->myaddr,
@@ -1085,27 +1085,28 @@ static int sym_prepare_setting(hcb_p np,
 	 *  Tell him more on demand.
 	 */
 	if (sym_verbose) {
-		printf("%s: %s IRQ line driver%s\n",
-			sym_name(np),
+		sym_printf_info(np, "%s IRQ line driver%s\n",
 			np->rv_dcntl & IRQM ? "totem pole" : "open drain",
 			np->ram_ba ? ", using on-chip SRAM" : "");
-		printf("%s: using %s firmware.\n", sym_name(np), np->fw_name);
+		sym_printf_info(np, "using %s firmware.\n", np->fw_name);
 		if (np->features & FE_NOPM)
-			printf("%s: handling phase mismatch from SCRIPTS.\n", 
-			       sym_name(np));
+			sym_printf_info(np,
+				"handling phase mismatch from SCRIPTS.\n");
 	}
 	/*
 	 *  And still more.
 	 */
 	if (sym_verbose >= 2) {
-		printf ("%s: initial SCNTL3/DMODE/DCNTL/CTEST3/4/5 = "
+		sym_printf_info(np,
+			"initial SCNTL3/DMODE/DCNTL/CTEST3/4/5 = "
 			"(hex) %02x/%02x/%02x/%02x/%02x/%02x\n",
-			sym_name(np), np->sv_scntl3, np->sv_dmode, np->sv_dcntl,
+			np->sv_scntl3, np->sv_dmode, np->sv_dcntl,
 			np->sv_ctest3, np->sv_ctest4, np->sv_ctest5);
 
-		printf ("%s: final   SCNTL3/DMODE/DCNTL/CTEST3/4/5 = "
+		sym_printf_info(np,
+			"final   SCNTL3/DMODE/DCNTL/CTEST3/4/5 = "
 			"(hex) %02x/%02x/%02x/%02x/%02x/%02x\n",
-			sym_name(np), np->rv_scntl3, np->rv_dmode, np->rv_dcntl,
+			np->rv_scntl3, np->rv_dmode, np->rv_dcntl,
 			np->rv_ctest3, np->rv_ctest4, np->rv_ctest5);
 	}
 	/*
@@ -1141,7 +1142,8 @@ static int sym_regtest (hcb_p np)
 #else
 	if ((data & 0xe2f0fffd) != 0x02000080) {
 #endif
-		printf ("CACHE TEST FAILED: reg dstat-sstat2 readback %x.\n",
+		sym_printf_warning(np,
+			"CACHE TEST FAILED: reg dstat-sstat2 readback %x.\n",
 			(unsigned) data);
 		return (0x10);
 	};
@@ -1186,7 +1188,7 @@ restart_test:
 		if (INB(nc_istat) & (INTF|SIP|DIP))
 			break;
 	if (i>=SYM_SNOOP_TIMEOUT) {
-		printf ("CACHE TEST FAILED: timeout.\n");
+		sym_printf_warning(np, "CACHE TEST FAILED: timeout.\n");
 		return (0x20);
 	};
 	/*
@@ -1195,15 +1197,15 @@ restart_test:
 	dstat = INB (nc_dstat);
 #if 1	/* Band aiding for broken hardwares that fail PCI parity */
 	if ((dstat & MDPE) && (np->rv_ctest4 & MPEE)) {
-		printf ("%s: PCI DATA PARITY ERROR DETECTED - "
-			"DISABLING MASTER DATA PARITY CHECKING.\n",
-			sym_name(np));
+		sym_printf_warning(np, "PCI DATA PARITY ERROR DETECTED - "
+			"DISABLING MASTER DATA PARITY CHECKING.\n");
 		np->rv_ctest4 &= ~MPEE;
 		goto restart_test;
 	}
 #endif
 	if (dstat & (MDPE|BF|IID)) {
-		printf ("CACHE TEST FAILED: DMA error (dstat=0x%02x).", dstat);
+		sym_printf_warning(np,
+			"CACHE TEST FAILED: DMA error (dstat=0x%02x).", dstat);
 		return (0x80);
 	}
 	/*
@@ -1220,8 +1222,10 @@ restart_test:
 	 *  Check termination position.
 	 */
 	if (pc != SCRIPTZ_BA (np, snoopend)+8) {
-		printf ("CACHE TEST FAILED: script execution failed.\n");
-		printf ("start=%08lx, pc=%08lx, end=%08lx\n", 
+		sym_printf_warning(np,
+			"CACHE TEST FAILED: script execution failed.\n");
+		sym_printf_warning(np,
+			"start=%08lx, pc=%08lx, end=%08lx\n",
 			(u_long) SCRIPTZ_BA (np, snooptest), (u_long) pc,
 			(u_long) SCRIPTZ_BA (np, snoopend) +8);
 		return (0x40);
@@ -1230,17 +1234,20 @@ restart_test:
 	 *  Show results.
 	 */
 	if (host_wr != sym_rd) {
-		printf ("CACHE TEST FAILED: host wrote %d, chip read %d.\n",
+		sym_printf_warning(np,
+			"CACHE TEST FAILED: host wrote %d, chip read %d.\n",
 			(int) host_wr, (int) sym_rd);
 		err |= 1;
 	};
 	if (host_rd != sym_wr) {
-		printf ("CACHE TEST FAILED: chip wrote %d, host read %d.\n",
+		sym_printf_warning(np,
+			"CACHE TEST FAILED: chip wrote %d, host read %d.\n",
 			(int) sym_wr, (int) host_rd);
 		err |= 2;
 	};
 	if (sym_bk != sym_wr) {
-		printf ("CACHE TEST FAILED: chip wrote %d, read back %d.\n",
+		sym_printf_warning(np,
+			"CACHE TEST FAILED: chip wrote %d, read back %d.\n",
 			(int) sym_wr, (int) sym_bk);
 		err |= 4;
 	};
@@ -1306,8 +1313,9 @@ static void sym_log_hard_error(hcb_p np,
 		script_name	= "mem";
 	}
 
-	printf ("%s:%d: ERROR (%x:%x) (%x-%x-%x) (%x/%x/%x) @ (%s %x:%08x).\n",
-		sym_name (np), (unsigned)INB (nc_sdid)&0x0f, dstat, sist,
+	sym_printf_err(np,
+		"%d: ERROR (%x:%x) (%x-%x-%x) (%x/%x/%x) @ (%s %x:%08x).\n",
+		(unsigned)INB (nc_sdid)&0x0f, dstat, sist,
 		(unsigned)INB (nc_socl),   (unsigned)INB (nc_sbcl),
 		(unsigned)INB (nc_sbdl),   (unsigned)INB (nc_sxfer),
 		(unsigned)INB (nc_scntl3),
@@ -1316,11 +1324,11 @@ static void sym_log_hard_error(hcb_p np,
 
 	if (((script_ofs & 3) == 0) &&
 	    (unsigned)script_ofs < script_size) {
-		printf ("%s: script cmd = %08x\n", sym_name(np),
+		sym_printf_err(np, "script cmd = %08x\n",
 			scr_to_cpu((int) *(u32 *)(script_base + script_ofs)));
 	}
 
-        printf ("%s: regdump:", sym_name(np));
+        sym_printf_err(np, "regdump:");
         for (i=0; i<24;i++)
             printf (" %02x", (unsigned)INB_OFF(i));
         printf (".\n");
@@ -1628,7 +1636,7 @@ void sym_put_start_queue(hcb_p np, ccb_p
 	np->squeueput = qidx;
 
 	if (DEBUG_FLAGS & DEBUG_QUEUE)
-		printf ("%s: queuepos=%d.\n", sym_name (np), np->squeueput);
+		sym_printf(np, "queuepos=%d.\n", np->squeueput);
 
 	/*
 	 *  Script processor may be waiting for reselect.
@@ -1721,8 +1729,8 @@ static int sym_wakeup_done (hcb_p np)
 			++n;
 		}
 		else
-			printf ("%s: bad DSA (%x) in done queue.\n",
-				sym_name(np), (u_int) dsa);
+			sym_printf(np, "bad DSA (%x) in done queue.\n",
+				(u_int) dsa);
 	}
 	np->dqueueget = i;
 
@@ -1956,8 +1964,7 @@ void sym_start_up (hcb_p np, int reason)
 	 */
 	if (np->ram_ba) {
 		if (sym_verbose >= 2)
-			printf ("%s: Downloading SCSI SCRIPTS.\n",
-				sym_name(np));
+			sym_printf_info(np, "Downloading SCSI SCRIPTS.\n");
 		if (np->ram_ws == 8192) {
 			OUTRAM_OFF(4096, np->scriptb0, np->scriptb_sz);
 			phys =  scr_to_cpu(np->scr_ram_seg);
@@ -2251,7 +2258,7 @@ static void sym_int_sto (hcb_p np)
  */
 static void sym_int_udc (hcb_p np)
 {
-	printf ("%s: unexpected disconnect\n", sym_name(np));
+	sym_printf_warning(np, "unexpected disconnect\n");
 	sym_recover_scsi_int(np, HS_UNEXPECTED);
 }
 
@@ -2272,7 +2279,7 @@ static void sym_int_sbmc (hcb_p np)
 	/*
 	 *  Notify user.
 	 */
-	printf("%s: SCSI BUS mode change from %s to %s.\n", sym_name(np),
+	sym_printf(np, "SCSI BUS mode change from %s to %s.\n",
 		sym_scsi_bus_mode(np->scsi_mode), sym_scsi_bus_mode(scsi_mode));
 
 	/*
@@ -2317,8 +2324,9 @@ static void sym_int_par (hcb_p np, u_sho
 	int phase	= cmd & 7;
 	ccb_p	cp	= sym_ccb_from_dsa(np, dsa);
 
-	printf("%s: SCSI parity error detected: SCR1=%d DBC=%x SBCL=%x\n",
-		sym_name(np), hsts, dbc, sbcl);
+	sym_printf_warning(np,
+		"SCSI parity error detected: SCR1=%d DBC=%x SBCL=%x\n",
+		hsts, dbc, sbcl);
 
 	/*
 	 *  Check that the chip is connected to the SCSI BUS.
@@ -2512,14 +2520,13 @@ static void sym_int_ma (hcb_p np)
 	};
 
 	if (!vdsp) {
-		printf ("%s: interrupted SCRIPT address not found.\n", 
-			sym_name (np));
+		sym_printf(np, "interrupted SCRIPT address not found.\n");
 		goto reset_all;
 	}
 
 	if (!cp) {
-		printf ("%s: SCSI phase error fixup: CCB already dequeued.\n", 
-			sym_name (np));
+		sym_printf(np,
+			"SCSI phase error fixup: CCB already dequeued.\n");
 		goto reset_all;
 	}
 
@@ -2908,7 +2915,7 @@ void sym_interrupt (hcb_p np)
 	 *  ponding status and restart the SCRIPTS.
 	 */
 	if (sist & RST) {
-		printf("%s: SCSI BUS reset detected.\n", sym_name(np));
+		sym_printf_info(np, "SCSI BUS reset detected.\n");
 		sym_start_up (np, 1);
 		return;
 	};
@@ -2945,9 +2952,9 @@ unknown_int:
 	 *  We just miss the cause of the interrupt. :(
 	 *  Print a message. The timeout will do the real work.
 	 */
-	printf(	"%s: unknown interrupt(s) ignored, "
+	sym_printf_info(np, "unknown interrupt(s) ignored, "
 		"ISTAT=0x%x DSTAT=0x%x SIST=0x%x\n",
-		sym_name(np), istat, dstat, sist);
+		istat, dstat, sist);
 }
 
 /*
@@ -4505,24 +4512,24 @@ static void sym_int_sir (hcb_p np)
 	 *  that.
 	 */
 	case SIR_SEL_ATN_NO_MSG_OUT:
-		printf ("%s:%d: No MSG OUT phase after selection with ATN.\n",
-			sym_name (np), target);
+		sym_printf_warning(np, "%d: No MSG OUT phase after selection "
+			" with ATN.\n", target);
 		goto out_stuck;
 	/*
 	 *  The device didn't switch to MSG IN phase after 
 	 *  having reseleted the initiator.
 	 */
 	case SIR_RESEL_NO_MSG_IN:
-		printf ("%s:%d: No MSG IN phase after reselection.\n",
-			sym_name (np), target);
+		sym_printf_warning(np, "%d: No MSG IN phase after "
+			"reselection.\n", target);
 		goto out_stuck;
 	/*
 	 *  After reselection, the device sent a message that wasn't 
 	 *  an IDENTIFY.
 	 */
 	case SIR_RESEL_NO_IDENTIFY:
-		printf ("%s:%d: No IDENTIFY after reselection.\n",
-			sym_name (np), target);
+		sym_printf_warning(np, "%d: No IDENTIFY after reselection.\n",
+			target);
 		goto out_stuck;
 	/*
 	 *  The device reselected a LUN we donnot know about.
@@ -4551,8 +4558,8 @@ static void sym_int_sir (hcb_p np)
 	case SIR_RESEL_ABORTED:
 		np->lastmsg = np->msgout[0];
 		np->msgout[0] = M_NOOP;
-		printf ("%s:%d: message %x sent on bad reselection.\n",
-			sym_name (np), target, np->lastmsg);
+		sym_printf_warning(np, "%d: message %x sent on bad "
+			"reselection.\n", target, np->lastmsg);
 		goto out;
 	/*
 	 *  The SCRIPTS let us know that a message has been 
@@ -5792,8 +5799,8 @@ int sym_hcb_attach(hcb_p np, struct sym_
 	 */
 	i = sym_getpciclock(np);
 	if (i > 37000 && !(np->features & FE_66MHZ))
-		printf("%s: PCI BUS clock seems too high: %u KHz.\n",
-			sym_name(np), i);
+		sym_printf_err(np,
+			"PCI BUS clock seems too high: %u KHz.\n", i);
 
 	/*
 	 *  Allocate the start queue.
@@ -5969,7 +5976,7 @@ int sym_hcb_attach(hcb_p np, struct sym_
 	 *  Now check the cache handling of the pci chipset.
 	 */
 	if (sym_snooptest (np)) {
-		printf("%s: CACHE INCORRECTLY CONFIGURED.\n", sym_name(np));
+		sym_printf_err(np, "CACHE INCORRECTLY CONFIGURED.\n");
 		goto attach_failed;
 	};
 
diff -puN drivers/scsi/sym53c8xx_2/sym_misc.c~sym2-dev_printk drivers/scsi/sym53c8xx_2/sym_misc.c
--- patched-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c~sym2-dev_printk	Fri Feb 20 17:47:18 2004
+++ patched-2.6-andmike/drivers/scsi/sym53c8xx_2/sym_misc.c	Fri Feb 20 17:47:18 2004
@@ -202,16 +202,16 @@ void sym_announce_transfer_rate(hcb_p np
 			f10 = 100000 << (__tcurr.width ? 1 : 0);
 			mb10 = (f10 + period/2) / period;
 		}
-		printf_info (
-		    "%s:%d: %s %sSCSI %d.%d MB/s %s (%d.%d ns, offset %d)\n",
-		    sym_name(np), target, scsi, __tcurr.width? "WIDE " : "",
+		sym_printf_info(np,
+		    "%d: %s %sSCSI %d.%d MB/s %s (%d.%d ns, offset %d)\n",
+		    target, scsi, __tcurr.width? "WIDE " : "",
 		    mb10/10, mb10%10,
 		    (__tcurr.options & PPR_OPT_DT) ? "DT" : "ST",
 		    period/10, period%10, __tcurr.offset);
 	}
 	else
-		printf_info ("%s:%d: %sasynchronous.\n", 
-		             sym_name(np), target, __tcurr.width? "wide " : "");
+		sym_printf_info(np, "%d: %sasynchronous.\n", target,
+			__tcurr.width? "wide " : "");
 }
 #undef __tprev
 #undef __tcurr
diff -puN drivers/scsi/sym53c8xx_2/sym_nvram.c~sym2-dev_printk drivers/scsi/sym53c8xx_2/sym_nvram.c
--- patched-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c~sym2-dev_printk	Fri Feb 20 17:47:18 2004
+++ patched-2.6-andmike/drivers/scsi/sym53c8xx_2/sym_nvram.c	Fri Feb 20 17:47:18 2004
@@ -172,8 +172,8 @@ static void sym_display_Symbios_nvram(st
 	int i;
 
 	/* display Symbios nvram host data */
-	printf("%s: HOST ID=%d%s%s%s%s%s%s\n",
-		sym_name(np), nvram->host_id & 0x0f,
+	sym_printf(np, "HOST ID=%d%s%s%s%s%s%s\n",
+		nvram->host_id & 0x0f,
 		(nvram->flags  & SYMBIOS_SCAM_ENABLE)	? " SCAM"	:"",
 		(nvram->flags  & SYMBIOS_PARITY_ENABLE)	? " PARITY"	:"",
 		(nvram->flags  & SYMBIOS_VERBOSE_MSGS)	? " VERBOSE"	:"", 
@@ -184,8 +184,7 @@ static void sym_display_Symbios_nvram(st
 	/* display Symbios nvram drive data */
 	for (i = 0 ; i < 15 ; i++) {
 		struct Symbios_target *tn = &nvram->target[i];
-		printf("%s-%d:%s%s%s%s WIDTH=%d SYNC=%d TMO=%d\n",
-		sym_name(np), i,
+		sym_printf(np, "%d:%s%s%s%s WIDTH=%d SYNC=%d TMO=%d\n", i,
 		(tn->flags & SYMBIOS_DISCONNECT_ENABLE)	? " DISC"	: "",
 		(tn->flags & SYMBIOS_SCAN_AT_BOOT_TIME)	? " SCAN_BOOT"	: "",
 		(tn->flags & SYMBIOS_SCAN_LUNS)		? " SCAN_LUNS"	: "",
@@ -216,8 +215,8 @@ static void sym_display_Tekram_nvram(str
 	case 2: rem = " REMOVABLE=all";		break;
 	}
 
-	printf("%s: HOST ID=%d%s%s%s%s%s%s%s%s%s BOOT DELAY=%d tags=%d\n",
-		sym_name(np), nvram->host_id & 0x0f,
+	sym_printf(np, "HOST ID=%d%s%s%s%s%s%s%s%s%s BOOT DELAY=%d tags=%d\n",
+		nvram->host_id & 0x0f,
 		(nvram->flags1 & SYMBIOS_SCAM_ENABLE)	? " SCAM"	:"",
 		(nvram->flags & TEKRAM_MORE_THAN_2_DRIVES) ? " >2DRIVES":"",
 		(nvram->flags & TEKRAM_DRIVES_SUP_1GB)	? " >1GB"	:"",
@@ -234,8 +233,7 @@ static void sym_display_Tekram_nvram(str
 		struct Tekram_target *tn = &nvram->target[i];
 		j = tn->sync_index & 0xf;
 		sync = Tekram_sync[j];
-		printf("%s-%d:%s%s%s%s%s%s PERIOD=%d\n",
-		sym_name(np), i,
+		sym_printf(np, "%d:%s%s%s%s%s%s PERIOD=%d\n", i,
 		(tn->flags & TEKRAM_PARITY_CHECK)	? " PARITY"	: "",
 		(tn->flags & TEKRAM_SYNC_NEGO)		? " SYNC"	: "",
 		(tn->flags & TEKRAM_DISCONNECT_ENABLE)	? " DISC"	: "",

_
