From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] Convert sym2 to be hotplug-capable
Date: Wed, 16 Jul 2003 22:00:59 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030716210059.GR23808@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:29064 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S271076AbTGPUqJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2003 16:46:09 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.14)
	id 19ctOV-0006jt-NH
	for linux-scsi@vger.kernel.org; Wed, 16 Jul 2003 22:00:59 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch is on top of the patch I posted yesterday.  It..
 - Stops using Scsi_Cmnd etc typedefs
 - Removes the unused Scsi_Host_Template argument from sym53c8xx_pci_init
 - Converts sym53c8xx_2 to be a hotplug-capable driver

It boots for me on a box with 4 dual 1010 cards, but I'd appreciate other
feedback.

NOTE: This does not even attempt to preserve existing controller ordering.
But given how much I've seen symbios controllers move around under
the current setup (what?  you plugged in an 875 that happens to have
NVRAM on it?  Oh well then, let's just renumber all your other cards!),
I really don't care.

If you already deleted the patch from yesterday, a combined patch is
available from
http://ftp.linux.org.uk/pub/linux/willy/patches/sym53c8xx2-2.5.75.diff

diff -U2 linux-2.5.75-willy/drivers/scsi/sym53c8xx_2/sym_glue.c linux-2.5.75-willy/drivers/scsi/sym53c8xx_2/sym_glue.c
--- linux-2.5.75-willy/drivers/scsi/sym53c8xx_2/sym_glue.c	2003-07-15 16:19:01.000000000 -0600
+++ linux-2.5.75-willy/drivers/scsi/sym53c8xx_2/sym_glue.c	2003-07-16 14:34:47.000000000 -0600
@@ -224,5 +224,5 @@
 	struct semaphore sem;
 	struct timer_list timer;
-	void (*old_done)(Scsi_Cmnd *);
+	void (*old_done)(struct scsi_cmnd *);
 	int to_do;
 	int timed_out;
@@ -244,5 +244,5 @@
 
 #define SYM_UCMD_PTR(cmd)  ((ucmd_p)(&(cmd)->SCp))
-#define SYM_SCMD_PTR(ucmd) sym_que_entry(ucmd, Scsi_Cmnd, SCp)
+#define SYM_SCMD_PTR(ucmd) sym_que_entry(ucmd, struct scsi_cmnd, SCp)
 #define SYM_SOFTC_PTR(cmd) (((struct host_data *)cmd->device->host->hostdata)->ncb)
 
@@ -286,5 +286,5 @@
 #define bus_sg_dma_len(sc)	sg_dma_len(sc)
 
-static void __unmap_scsi_data(struct pci_dev *pdev, Scsi_Cmnd *cmd)
+static void __unmap_scsi_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
 {
 	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
@@ -302,5 +302,5 @@
 }
 
-static bus_addr_t __map_scsi_single_data(struct pci_dev *pdev, Scsi_Cmnd *cmd)
+static bus_addr_t __map_scsi_single_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
 {
 	bus_addr_t mapping;
@@ -317,5 +317,5 @@
 }
 
-static int __map_scsi_sg_data(struct pci_dev *pdev, Scsi_Cmnd *cmd)
+static int __map_scsi_sg_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
 {
 	int use_sg;
@@ -331,5 +331,5 @@
 }
 
-static void __sync_scsi_data(struct pci_dev *pdev, Scsi_Cmnd *cmd)
+static void __sync_scsi_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
 {
 	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
@@ -360,5 +360,5 @@
  *  Complete a pending CAM CCB.
  */
-void sym_xpt_done(hcb_p np, Scsi_Cmnd *ccb)
+void sym_xpt_done(hcb_p np, struct scsi_cmnd *ccb)
 {
 	sym_remque(&SYM_UCMD_PTR(ccb)->link_cmdq);
@@ -367,5 +367,5 @@
 }
 
-void sym_xpt_done2(hcb_p np, Scsi_Cmnd *ccb, int cam_status)
+void sym_xpt_done2(hcb_p np, struct scsi_cmnd *ccb, int cam_status)
 {
 	sym_set_cam_status(ccb, cam_status);
@@ -379,5 +379,5 @@
 void sym_print_addr (ccb_p cp)
 {
-	Scsi_Cmnd *cmd = cp->cam_ccb;
+	struct scsi_cmnd *cmd = cp->cam_ccb;
 	if (cmd)
 		printf("%s:%d:%d:", sym_name(SYM_SOFTC_PTR(cmd)),
@@ -440,5 +440,5 @@
 void sym_set_cam_result_error(hcb_p np, ccb_p cp, int resid)
 {
-	Scsi_Cmnd *csio = cp->cam_ccb;
+	struct scsi_cmnd *csio = cp->cam_ccb;
 	u_int cam_status, scsi_status, drv_status;
 
@@ -508,5 +508,5 @@
  *  Called on successfull INQUIRY response.
  */
-void sym_sniff_inquiry(hcb_p np, Scsi_Cmnd *cmd, int resid)
+void sym_sniff_inquiry(hcb_p np, struct scsi_cmnd *cmd, int resid)
 {
 	int retv;
@@ -529,5 +529,5 @@
  */
 
-static int sym_scatter_no_sglist(hcb_p np, ccb_p cp, Scsi_Cmnd *cmd)
+static int sym_scatter_no_sglist(hcb_p np, ccb_p cp, struct scsi_cmnd *cmd)
 {
 	struct sym_tblmove *data = &cp->phys.data[SYM_CONF_MAX_SG-1];
@@ -551,5 +551,5 @@
 }
 
-static int sym_scatter(hcb_p np, ccb_p cp, Scsi_Cmnd *cmd)
+static int sym_scatter(hcb_p np, ccb_p cp, struct scsi_cmnd *cmd)
 {
 	int segment;
@@ -588,7 +588,7 @@
  *  Queue a SCSI command.
  */
-static int sym_queue_command(hcb_p np, Scsi_Cmnd *ccb)
+static int sym_queue_command(hcb_p np, struct scsi_cmnd *ccb)
 {
-/*	Scsi_Device        *device    = ccb->device; */
+/*	struct scsi_device        *device    = ccb->device; */
 	tcb_p	tp;
 	lcb_p	lp;
@@ -653,5 +653,5 @@
  *  Setup buffers and pointers that address the CDB.
  */
-static int __inline sym_setup_cdb(hcb_p np, Scsi_Cmnd *ccb, ccb_p cp)
+static int __inline sym_setup_cdb(hcb_p np, struct scsi_cmnd *ccb, ccb_p cp)
 {
 	u32	cmd_ba;
@@ -679,5 +679,5 @@
  *  Setup pointers that address the data and start the I/O.
  */
-int sym_setup_data_and_start(hcb_p np, Scsi_Cmnd *csio, ccb_p cp)
+int sym_setup_data_and_start(hcb_p np, struct scsi_cmnd *csio, ccb_p cp)
 {
 	int dir;
@@ -836,5 +836,5 @@
 static void sym_requeue_awaiting_cmds(hcb_p np)
 {
-	Scsi_Cmnd *cmd;
+	struct scsi_cmnd *cmd;
 	ucmd_p ucp = SYM_UCMD_PTR(cmd);
 	SYM_QUEHEAD tmp_cmdq;
@@ -857,5 +857,5 @@
  *  Linux entry point of the queuecommand() function
  */
-int sym53c8xx_queue_command (Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
+int sym53c8xx_queue_command (struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
 	hcb_p  np  = SYM_SOFTC_PTR(cmd);
@@ -969,5 +969,5 @@
  *  Our general completion handler.
  */
-static void __sym_eh_done(Scsi_Cmnd *cmd, int timed_out)
+static void __sym_eh_done(struct scsi_cmnd *cmd, int timed_out)
 {
 	struct sym_eh_wait *ep = SYM_UCMD_PTR(cmd)->eh_wait;
@@ -994,10 +994,10 @@
  *  scsi_done() alias when error recovery is in progress. 
  */
-static void sym_eh_done(Scsi_Cmnd *cmd) { __sym_eh_done(cmd, 0); }
+static void sym_eh_done(struct scsi_cmnd *cmd) { __sym_eh_done(cmd, 0); }
 
 /*
  *  Some timeout handler to avoid waiting too long.
  */
-static void sym_eh_timeout(u_long p) { __sym_eh_done((Scsi_Cmnd *)p, 1); }
+static void sym_eh_timeout(u_long p) { __sym_eh_done((struct scsi_cmnd *)p, 1); }
 
 /*
@@ -1005,5 +1005,5 @@
  *  The 'op' argument tells what we have to do.
  */
-static int sym_eh_handler(int op, char *opname, Scsi_Cmnd *cmd)
+static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 {
 	hcb_p np = SYM_SOFTC_PTR(cmd);
@@ -1113,20 +1113,20 @@
  * Error handlers called from the eh thread (one thread per HBA).
  */
-int sym53c8xx_eh_abort_handler(Scsi_Cmnd *cmd)
+int sym53c8xx_eh_abort_handler(struct scsi_cmnd *cmd)
 {
 	return sym_eh_handler(SYM_EH_ABORT, "ABORT", cmd);
 }
 
-int sym53c8xx_eh_device_reset_handler(Scsi_Cmnd *cmd)
+int sym53c8xx_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
 	return sym_eh_handler(SYM_EH_DEVICE_RESET, "DEVICE RESET", cmd);
 }
 
-int sym53c8xx_eh_bus_reset_handler(Scsi_Cmnd *cmd)
+int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 {
 	return sym_eh_handler(SYM_EH_BUS_RESET, "BUS RESET", cmd);
 }
 
-int sym53c8xx_eh_host_reset_handler(Scsi_Cmnd *cmd)
+int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
 {
 	return sym_eh_handler(SYM_EH_HOST_RESET, "HOST RESET", cmd);
@@ -1225,5 +1225,5 @@
  */
 int
-sym53c8xx_slave_configure(Scsi_Device *device)
+sym53c8xx_slave_configure(struct scsi_device *device)
 {
 	struct Scsi_Host *host = device->host;
@@ -1788,5 +1788,5 @@
  */
 static int __init 
-sym_attach (Scsi_Host_Template *tpnt, int unit, sym_device *dev)
+sym_attach (struct scsi_host_template *tpnt, int unit, sym_device *dev)
 {
         struct host_data *host_data;
@@ -1823,5 +1823,5 @@
 	 *	Allocate host_data structure
 	 */
-        if (!(instance = scsi_register(tpnt, sizeof(*host_data))))
+        if (!(instance = scsi_host_alloc(tpnt, sizeof(*host_data))))
 	        goto attach_failed;
 	host_data = (struct host_data *) instance->hostdata;
@@ -1849,4 +1849,6 @@
 	np->s.host = instance;
 
+	pci_set_drvdata(dev->pdev, np);
+
 	SYM_INIT_LOCK_HCB(np);
 
@@ -2016,4 +2018,5 @@
 	 *  look for the SCSI devices on the bus ..
 	 */
+	scsi_add_host(instance, &dev->pdev->dev);
 	return 0;
 
@@ -2258,53 +2261,4 @@
 #endif
 
-#ifdef	SYM_CONF_PQS_PDS_SUPPORT
-/*
- *  Detect all NCR PQS/PDS boards and keep track of their bus nr.
- *
- *  The NCR PQS or PDS card is constructed as a DEC bridge
- *  behind which sit a proprietary NCR memory controller and
- *  four or two 53c875s as separate devices.  In its usual mode
- *  of operation, the 875s are slaved to the memory controller
- *  for all transfers.  We can tell if an 875 is part of a
- *  PQS/PDS or not since if it is, it will be on the same bus
- *  as the memory controller.  To operate with the Linux
- *  driver, the memory controller is disabled and the 875s
- *  freed to function independently.  The only wrinkle is that
- *  the preset SCSI ID (which may be zero) must be read in from
- *  a special configuration space register of the 875
- */
-#ifndef SYM_CONF_MAX_PQS_BUS
-#define SYM_CONF_MAX_PQS_BUS 16
-#endif
-static int pqs_bus[SYM_CONF_MAX_PQS_BUS] __initdata = { 0 };
-
-static void __init sym_detect_pqs_pds(void)
-{
-	short index;
-	struct pci_dev *dev = NULL;
-
-	for(index=0; index < SYM_CONF_MAX_PQS_BUS; index++) {
-		u_char tmp;
-
-		dev = pci_find_device(0x101a, 0x0009, dev);
-		if (dev == NULL) {
-			pqs_bus[index] = -1;
-			break;
-		}
-		printf_info(NAME53C8XX ": NCR PQS/PDS memory controller detected on bus %d\n", dev->bus->number);
-		pci_read_config_byte(dev, 0x44, &tmp);
-		/* bit 1: allow individual 875 configuration */
-		tmp |= 0x2;
-		pci_write_config_byte(dev, 0x44, tmp);
-		pci_read_config_byte(dev, 0x45, &tmp);
-		/* bit 2: drive individual 875 interrupts to the bus */
-		tmp |= 0x4;
-		pci_write_config_byte(dev, 0x45, tmp);
-
-		pqs_bus[index] = dev->bus->number;
-	}
-}
-#endif /* SYM_CONF_PQS_PDS_SUPPORT */
-
 /*
  *  Read and check the PCI configuration for any detected NCR 
@@ -2313,5 +2267,5 @@
  */
 static int __init
-sym53c8xx_pci_init(Scsi_Host_Template *tpnt, struct pci_dev *pdev, sym_device *device)
+sym53c8xx_pci_init(struct pci_dev *pdev, sym_device *device)
 {
 	u_short vendor_id, device_id, command, status_reg;
@@ -2530,24 +2484,5 @@
 }
 
-/*
- *  List of supported NCR chip ids
- */
-static u_short sym_chip_ids[] __initdata	= {
-	PCI_ID_SYM53C810,
-	PCI_ID_SYM53C815,
-	PCI_ID_SYM53C825,
-	PCI_ID_SYM53C860,
-	PCI_ID_SYM53C875,
-	PCI_ID_SYM53C875_2,
-	PCI_ID_SYM53C885,
-	PCI_ID_SYM53C875A,
-	PCI_ID_SYM53C895,
-	PCI_ID_SYM53C896,
-	PCI_ID_SYM53C895A,
-	PCI_ID_LSI53C1510D,
- 	PCI_ID_LSI53C1010,
- 	PCI_ID_LSI53C1010_2
-};
-
+#if 0
 /*
  *  Detect all 53c8xx hosts and then attach them.
@@ -2560,5 +2495,5 @@
  *  the order they are detected.
  */
-int __init sym53c8xx_detect(Scsi_Host_Template *tpnt)
+int __init sym53c8xx_detect(struct scsi_host_template *tpnt)
 {
 	struct pci_dev *pcidev;
@@ -2633,6 +2568,5 @@
 		devp = &devtbl[count];
 		devp->host_id = SYM_SETUP_HOST_ID;
-		devp->attach_done = 0;
-		if (sym53c8xx_pci_init(tpnt, pcidev, devp)) {
+		if (sym53c8xx_pci_init(pcidev, devp)) {
 			continue;
 		}
@@ -2745,5 +2679,5 @@
 	return attach_count;
 }
-
+#endif
 
 
@@ -2780,4 +2714,5 @@
 }
 
+#if 0
 int sym53c8xx_release(struct Scsi_Host *host)
 {
@@ -2786,19 +2721,17 @@
      return 0;
 }
+#endif
 
-/*
- * For bigots to keep silent. :)
- */
-#ifdef MODULE_LICENSE
 MODULE_LICENSE("Dual BSD/GPL");
-#endif
 
 /*
  * Driver host template.
  */
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template sym2_template = {
 	.name			= "sym53c8xx",
+#if 0
 	.detect			= sym53c8xx_detect,
 	.release		= sym53c8xx_release,
+#endif
 	.info			= sym53c8xx_info, 
 	.queuecommand		= sym53c8xx_queue_command,
@@ -2818 +2751,170 @@
-#include "../scsi_module.c"
+
+#ifdef _SYM_CONF_PQS_PDS_SUPPORT
+#if 0
+/*
+ *  Detect all NCR PQS/PDS boards and keep track of their bus nr.
+ *
+ *  The NCR PQS or PDS card is constructed as a DEC bridge
+ *  behind which sit a proprietary NCR memory controller and
+ *  four or two 53c875s as separate devices.  In its usual mode
+ *  of operation, the 875s are slaved to the memory controller
+ *  for all transfers.  We can tell if an 875 is part of a
+ *  PQS/PDS or not since if it is, it will be on the same bus
+ *  as the memory controller.  To operate with the Linux
+ *  driver, the memory controller is disabled and the 875s
+ *  freed to function independently.  The only wrinkle is that
+ *  the preset SCSI ID (which may be zero) must be read in from
+ *  a special configuration space register of the 875
+ */
+#ifndef SYM_CONF_MAX_PQS_BUS
+#define SYM_CONF_MAX_PQS_BUS 16
+#endif
+static int pqs_bus[SYM_CONF_MAX_PQS_BUS] __initdata = { 0 };
+
+static void __init sym_detect_pqs_pds(void)
+{
+	short index;
+	struct pci_dev *dev = NULL;
+
+	for(index=0; index < SYM_CONF_MAX_PQS_BUS; index++) {
+		u_char tmp;
+
+		dev = pci_find_device(0x101a, 0x0009, dev);
+		if (dev == NULL) {
+			pqs_bus[index] = -1;
+			break;
+		}
+		printf_info(NAME53C8XX ": NCR PQS/PDS memory controller detected on bus %d\n", dev->bus->number);
+		pci_read_config_byte(dev, 0x44, &tmp);
+		/* bit 1: allow individual 875 configuration */
+		tmp |= 0x2;
+		pci_write_config_byte(dev, 0x44, tmp);
+		pci_read_config_byte(dev, 0x45, &tmp);
+		/* bit 2: drive individual 875 interrupts to the bus */
+		tmp |= 0x4;
+		pci_write_config_byte(dev, 0x45, tmp);
+
+		pqs_bus[index] = dev->bus->number;
+	}
+}
+#endif
+
+static int pqs_probe()
+{
+}
+
+static void pqs_remove()
+{
+}
+
+static struct pci_device_id pqs_id_table[] __devinitdata = {
+	{ 0x101a, 0x0009, },
+};
+
+MODULE_DEVICE_TABLE(pci, pqs_id_table);
+
+static struct pci_driver pqs_driver = {
+	.name		= NAME53C8XX " (PQS)",
+	.id_table	= pqs_id_table,
+	.probe		= pqs_probe,
+	.remove		= __devexit_p(pqs_remove),
+};
+#endif /* PQS */
+
+static int attach_count;
+
+static int __devinit sym2_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
+{
+	sym_device sym_dev;
+	sym_nvram nvram;
+
+	sym_dev.host_id = SYM_SETUP_HOST_ID;
+	if (sym53c8xx_pci_init(pdev, &sym_dev))
+		return -ENODEV;
+	printk(KERN_INFO "%s: 53c%s detected\n", sym_name(&sym_dev), sym_dev.chip.name);
+
+	sym_dev.nvram = &nvram;
+	nvram.type = 0;
+#if SYM_CONF_NVRAM_SUPPORT
+	sym_get_nvram(&sym_dev, &nvram);
+#endif
+
+	if (sym_attach(&sym2_template, attach_count, &sym_dev))
+		return -ENODEV;
+
+	attach_count++;
+	return 0;
+}
+
+static void __devexit sym2_remove(struct pci_dev *pdev)
+{
+	sym_detach(pci_get_drvdata(pdev));
+	attach_count--;
+}
+
+static struct pci_device_id sym2_id_table[] __devinitdata = {
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C810,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C820,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL }, /* new */
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C825,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C815,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C810AP,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL }, /* new */
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C860,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1510,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C896,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C895,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C885,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C875,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C1510,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL }, /* new */
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C895A,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C875A,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1010_33,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1010_66,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C875J,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+};
+
+MODULE_DEVICE_TABLE(pci, sym2_id_table);
+
+static struct pci_driver sym2_driver = {
+	.name		= NAME53C8XX,
+	.id_table	= sym2_id_table,
+	.probe		= sym2_probe,
+	.remove		= __devexit_p(sym2_remove),
+};
+
+static int __init sym2_init(void)
+{
+#ifdef _SYM_CONF_PQS_PDS_SUPPORT
+	pci_register_driver(&pqs_driver);
+#endif
+	pci_register_driver(&sym2_driver);
+	return 0;
+}
+
+static void __exit sym2_exit(void)
+{
+	pci_unregister_driver(&sym2_driver);
+#ifdef _SYM_CONF_PQS_PDS_SUPPORT
+	pci_unregister_driver(&pqs_driver);
+#endif
+}
+
+module_init(sym2_init);
+module_exit(sym2_exit);

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
