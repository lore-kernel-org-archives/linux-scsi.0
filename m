From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] sym2 version 2.1.18n
Date: Wed, 29 Dec 2004 20:08:23 +0000
Message-ID: <20041229200823.GA18338@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:3219 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261411AbUL2UI2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Dec 2004 15:08:28 -0500
Received: from willy by www.linux.org.uk with local (Exim 4.33)
	id 1Cjk7L-0004MA-Of
	for linux-scsi@vger.kernel.org; Wed, 29 Dec 2004 20:08:23 +0000
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


sym2 version 2.1.18n:
 - Prevent querying for DT clocking on a single ended bus
 - Check the U3EN bit instead of the ULTRA3 bit
 - Only use PPR if SDTR is incapable of negotiating the desired options or
   speed
 - minsync bugfix (James Bottomley)
 - Always calculate what negotiation to perform inside sym_prepare_nego()
 - Delete unused SYM_OPT_HANDLE_IO_TIMEOUT and SYM_CONF_TIMEOUT_ORDER_MAX
   code (Christoph Hellwig)
 - Use SCSI-3 message names instead of SCSI-2 names
 - Remove private definitions of PCI IDs
 - Reorganise DMA mask setup
 - Fix comment tpyo
 - Make some needlessly global code static (Adrian Bunk)
 - Reorder some functions to eliminate predeclaration
 - Use memset instead of bzero
 - Consolidate and abstract SPARC's special IRQ printing
 - Convert hcb_p to struct sym_hcb *
 - Remove cam_ccb_p and cam_scsiio_p typedefs
 - Treat PA-RISC firmware as if it were a type of NVRAM

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_conf.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_conf.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_conf.h	2004-12-26 14:03:11.000000000 -0700
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_conf.h	2004-12-24 16:40:02.000000000 -0700
@@ -79,14 +79,6 @@
 /* #define SYM_CONF_IARB_SUPPORT */
 
 /*
- *  Number of lists for the optimization of the IO timeout handling.
- *  Not used under FreeBSD and Linux.
- */
-#ifndef SYM_CONF_TIMEOUT_ORDER_MAX
-#define SYM_CONF_TIMEOUT_ORDER_MAX	(8)
-#endif
-
-/*
  *  Only relevant if IARB support configured.
  *  - Max number of successive settings of IARB hints.
  *  - Set IARB on arbitration lost.
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h	2004-12-26 14:03:11.000000000 -0700
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h	2004-12-29 12:42:33.909114284 -0700
@@ -40,30 +40,10 @@
 #ifndef SYM_DEFS_H
 #define SYM_DEFS_H
 
-#define SYM_VERSION "2.1.18m"
+#define SYM_VERSION "2.1.18n"
 #define SYM_DRIVER_NAME	"sym-" SYM_VERSION
 
 /*
- *  PCI device identifier of SYMBIOS chips.
- */
-#define PCI_ID_SYM53C810	PCI_DEVICE_ID_NCR_53C810
-#define PCI_ID_SYM53C810AP	PCI_DEVICE_ID_LSI_53C810AP
-#define PCI_ID_SYM53C815	PCI_DEVICE_ID_NCR_53C815
-#define PCI_ID_SYM53C820	PCI_DEVICE_ID_NCR_53C820
-#define PCI_ID_SYM53C825	PCI_DEVICE_ID_NCR_53C825
-#define PCI_ID_SYM53C860	PCI_DEVICE_ID_NCR_53C860
-#define PCI_ID_SYM53C875	PCI_DEVICE_ID_NCR_53C875
-#define PCI_ID_SYM53C875_2	PCI_DEVICE_ID_NCR_53C875J
-#define PCI_ID_SYM53C885	PCI_DEVICE_ID_NCR_53C885
-#define PCI_ID_SYM53C895	PCI_DEVICE_ID_NCR_53C895
-#define PCI_ID_SYM53C896	PCI_DEVICE_ID_NCR_53C896
-#define PCI_ID_SYM53C895A	PCI_DEVICE_ID_LSI_53C895A
-#define PCI_ID_SYM53C875A	PCI_DEVICE_ID_LSI_53C875A
-#define PCI_ID_LSI53C1010_33	PCI_DEVICE_ID_LSI_53C1010_33
-#define PCI_ID_LSI53C1010_66	PCI_DEVICE_ID_LSI_53C1010_66
-#define PCI_ID_LSI53C1510D	PCI_DEVICE_ID_LSI_53C1510
-
-/*
  *	SYM53C8XX device features descriptor.
  */
 struct sym_pci_chip {
@@ -764,27 +744,27 @@ struct sym_tblsel {
 #define	M_RESTORE_DP	RESTORE_POINTERS
 #define	M_DISCONNECT	DISCONNECT
 #define	M_ID_ERROR	INITIATOR_ERROR
-#define	M_ABORT		ABORT
+#define	M_ABORT		ABORT_TASK_SET
 #define	M_REJECT	MESSAGE_REJECT
 #define	M_NOOP		NOP
 #define	M_PARITY	MSG_PARITY_ERROR
 #define	M_LCOMPLETE	LINKED_CMD_COMPLETE
 #define	M_FCOMPLETE	LINKED_FLG_CMD_COMPLETE
-#define	M_RESET		BUS_DEVICE_RESET
-#define	M_ABORT_TAG	(0x0d)
-#define	M_CLEAR_QUEUE	(0x0e)
+#define	M_RESET		TARGET_RESET
+#define	M_ABORT_TAG	ABORT_TASK
+#define	M_CLEAR_QUEUE	CLEAR_TASK_SET
 #define	M_INIT_REC	INITIATE_RECOVERY
 #define	M_REL_REC	RELEASE_RECOVERY
 #define	M_TERMINATE	(0x11)
 #define	M_SIMPLE_TAG	SIMPLE_QUEUE_TAG
 #define	M_HEAD_TAG	HEAD_OF_QUEUE_TAG
 #define	M_ORDERED_TAG	ORDERED_QUEUE_TAG
-#define	M_IGN_RESIDUE	(0x23)
+#define	M_IGN_RESIDUE	IGNORE_WIDE_RESIDUE
 
 #define	M_X_MODIFY_DP	EXTENDED_MODIFY_DATA_POINTER
 #define	M_X_SYNC_REQ	EXTENDED_SDTR
 #define	M_X_WIDE_REQ	EXTENDED_WDTR
-#define	M_X_PPR_REQ	(0x04)
+#define	M_X_PPR_REQ	EXTENDED_PPR
 
 /*
  *	PPR protocol options
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_fw.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_fw.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_fw.c	2004-12-26 14:03:11.000000000 -0700
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_fw.c	2004-12-24 16:40:02.000000000 -0700
@@ -223,13 +223,13 @@ sym_fw2_patch(struct sym_hcb *np)
 	 *  Remove a couple of work-arounds specific to C1010 if 
 	 *  they are not desirable. See `sym_fw2.h' for more details.
 	 */
-	if (!(np->device_id == PCI_ID_LSI53C1010_66 &&
+	if (!(np->device_id == PCI_DEVICE_ID_LSI_53C1010_66 &&
 	      np->revision_id < 0x1 &&
 	      np->pciclk_khz < 60000)) {
 		scripta0->datao_phase[0] = cpu_to_scr(SCR_NO_OP);
 		scripta0->datao_phase[1] = cpu_to_scr(0);
 	}
-	if (!(np->device_id == PCI_ID_LSI53C1010_33 &&
+	if (!(np->device_id == PCI_DEVICE_ID_LSI_53C1010_33 &&
 	      /* np->revision_id < 0xff */ 1)) {
 		scripta0->sel_done[0] = cpu_to_scr(SCR_NO_OP);
 		scripta0->sel_done[1] = cpu_to_scr(0);
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-12-26 14:03:11.000000000 -0700
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-12-24 16:40:02.000000000 -0700
@@ -55,6 +55,15 @@
 #define NAME53C		"sym53c"
 #define NAME53C8XX	"sym53c8xx"
 
+/* SPARC just has to be different ... */
+#ifdef __sparc__
+#define IRQ_FMT "%s"
+#define IRQ_PRM(x) __irq_itoa(x)
+#else
+#define IRQ_FMT "%d"
+#define IRQ_PRM(x) (x)
+#endif
+
 struct sym_driver_setup sym_driver_setup = SYM_LINUX_DRIVER_SETUP;
 unsigned int sym_debug_flags = 0;
 
@@ -147,7 +156,7 @@ pci_get_base_address(struct pci_dev *pde
 }
 
 /* This lock protects only the memory allocation/free.  */
-spinlock_t sym53c8xx_lock = SPIN_LOCK_UNLOCKED;
+static spinlock_t sym53c8xx_lock = SPIN_LOCK_UNLOCKED;
 
 static struct scsi_transport_template *sym2_transport_template = NULL;
 
@@ -285,7 +294,7 @@ void sym_xpt_done(struct sym_hcb *np, st
 	ccb->scsi_done(ccb);
 }
 
-void sym_xpt_done2(struct sym_hcb *np, struct scsi_cmnd *ccb, int cam_status)
+static void sym_xpt_done2(struct sym_hcb *np, struct scsi_cmnd *ccb, int cam_status)
 {
 	sym_set_cam_status(ccb, cam_status);
 	sym_xpt_done(np, ccb);
@@ -379,7 +388,7 @@ void sym_set_cam_result_error(struct sym
 			/*
 			 *  Bounce back the sense data to user.
 			 */
-			bzero(&csio->sense_buffer, sizeof(csio->sense_buffer));
+			memset(&csio->sense_buffer, 0, sizeof(csio->sense_buffer));
 			memcpy(csio->sense_buffer, cp->sns_bbuf,
 			      min(sizeof(csio->sense_buffer),
 				  (size_t)SYM_SNS_BBUF_LEN));
@@ -513,7 +522,7 @@ static int sym_queue_command(struct sym_
 	}
 
 	/*
-	 *  Retreive the target descriptor.
+	 *  Retrieve the target descriptor.
 	 */
 	tp = &np->target[ccb->device->id];
 
@@ -1277,7 +1286,7 @@ static int sym_user_command(struct sym_h
 	int		arg_len;
 	u_long 		target;
 
-	bzero(uc, sizeof(*uc));
+	memset(uc, 0, sizeof(*uc));
 
 	if (len > 0 && ptr[len-1] == '\n')
 		--len;
@@ -1467,18 +1476,8 @@ static int sym_host_info(struct sym_hcb 
 	copy_info(&info, "Chip " NAME53C "%s, device id 0x%x, "
 			 "revision id 0x%x\n",
 			 np->s.chip_name, np->device_id, np->revision_id);
-	copy_info(&info, "At PCI address %s, "
-#ifdef __sparc__
-		"IRQ %s\n",
-#else
-		"IRQ %d\n",
-#endif
-		pci_name(np->s.device),
-#ifdef __sparc__
-		__irq_itoa(np->s.irq));
-#else
-		(int) np->s.irq);
-#endif
+	copy_info(&info, "At PCI address %s, IRQ " IRQ_FMT "\n",
+		pci_name(np->s.device), IRQ_PRM(np->s.irq));
 	copy_info(&info, "Min. period factor %d, %s SCSI BUS%s\n",
 			 (int) (np->minsync_dt ? np->minsync_dt : np->minsync),
 			 np->maxwide ? "Wide" : "Narrow",
@@ -1558,32 +1557,23 @@ static void sym_free_resources(struct sy
  */
 static int sym_setup_bus_dma_mask(struct sym_hcb *np)
 {
-#if   SYM_CONF_DMA_ADDRESSING_MODE == 0
-	if (pci_set_dma_mask(np->s.device, 0xffffffffUL))
-		goto out_err32;
-#else
+#if SYM_CONF_DMA_ADDRESSING_MODE > 0
 #if   SYM_CONF_DMA_ADDRESSING_MODE == 1
-#define	PciDmaMask	0xffffffffffULL
+#define	DMA_DAC_MASK	0x000000ffffffffffULL /* 40-bit */
 #elif SYM_CONF_DMA_ADDRESSING_MODE == 2
-#define	PciDmaMask	0xffffffffffffffffULL
+#define	DMA_DAC_MASK	DMA_64BIT_MASK
 #endif
-	if (np->features & FE_DAC) {
-		if (!pci_set_dma_mask(np->s.device, PciDmaMask)) {
-			np->use_dac = 1;
-			printf_info("%s: using 64 bit DMA addressing\n",
-					sym_name(np));
-		} else {
-			if (pci_set_dma_mask(np->s.device, 0xffffffffUL))
-				goto out_err32;
-		}
+	if ((np->features & FE_DAC) &&
+			!pci_set_dma_mask(np->s.device, DMA_DAC_MASK)) {
+		np->use_dac = 1;
+		return 0;
 	}
-#undef	PciDmaMask
 #endif
-	return 0;
 
-out_err32:
-	printf_warning("%s: 32 BIT DMA ADDRESSING NOT SUPPORTED\n",
-			sym_name(np));
+	if (!pci_set_dma_mask(np->s.device, DMA_32BIT_MASK))
+		return 0;
+
+	printf_warning("%s: No suitable DMA available\n", sym_name(np));
 	return -1;
 }
 
@@ -1606,19 +1596,9 @@ static struct Scsi_Host * __devinit sym_
 	struct sym_fw *fw;
 
 	printk(KERN_INFO
-		"sym%d: <%s> rev 0x%x at pci %s "
-#ifdef __sparc__
-		"irq %s\n",
-#else
-		"irq %d\n",
-#endif
+		"sym%d: <%s> rev 0x%x at pci %s irq " IRQ_FMT "\n",
 		unit, dev->chip.name, dev->chip.revision_id,
-		pci_name(dev->pdev),
-#ifdef __sparc__
-		__irq_itoa(dev->s.irq));
-#else
-		dev->s.irq);
-#endif
+		pci_name(dev->pdev), IRQ_PRM(dev->s.irq));
 
 	/*
 	 *  Get the firmware for this chip.
@@ -1672,9 +1652,6 @@ static struct Scsi_Host * __devinit sym_
 	strlcpy(np->s.chip_name, dev->chip.name, sizeof(np->s.chip_name));
 	sprintf(np->s.inst_name, "sym%d", np->s.unit);
 
-	/*
-	 *  Ask/tell the system about DMA addressing.
-	 */
 	if (sym_setup_bus_dma_mask(np))
 		goto attach_failed;
 
@@ -2010,7 +1987,7 @@ sym_init_device(struct pci_dev *pdev, st
  * the preset SCSI ID (which may be zero) must be read in from
  * a special configuration space register of the 875.
  */
-void sym_config_pqs(struct pci_dev *pdev, struct sym_device *sym_dev)
+static void sym_config_pqs(struct pci_dev *pdev, struct sym_device *sym_dev)
 {
 	int slot;
 	u8 tmp;
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	2004-12-26 14:03:11.000000000 -0700
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	2004-12-24 16:40:02.000000000 -0700
@@ -58,13 +58,6 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 
-#ifndef bzero
-#define bzero(d, n)	memset((d), 0, (n))
-#endif
-
-/*
- *  General driver includes.
- */
 #include "sym_conf.h"
 #include "sym_defs.h"
 #include "sym_misc.h"
@@ -123,14 +116,6 @@
 typedef struct sym_tcb *tcb_p;
 typedef struct sym_lcb *lcb_p;
 typedef struct sym_ccb *ccb_p;
-typedef struct sym_hcb *hcb_p;
-
-/*
- *  Define a reference to the O/S dependent IO request.
- */
-typedef struct scsi_cmnd *cam_ccb_p;	/* Generic */
-typedef struct scsi_cmnd *cam_scsiio_p;/* SCSI I/O */
-
 
 /*
  *  IO functions definition for big/little endian CPU support.
@@ -525,7 +510,7 @@ sym_get_cam_status(struct scsi_cmnd *ccb
 /*
  *  Async handler for negotiations.
  */
-void sym_xpt_async_nego_wide(hcb_p np, int target);
+void sym_xpt_async_nego_wide(struct sym_hcb *np, int target);
 #define sym_xpt_async_nego_sync(np, target)	\
 	sym_announce_transfer_rate(np, target)
 #define sym_xpt_async_nego_ppr(np, target)	\
@@ -534,14 +519,14 @@ void sym_xpt_async_nego_wide(hcb_p np, i
 /*
  *  Build CAM result for a successful IO and for a failed IO.
  */
-static __inline void sym_set_cam_result_ok(hcb_p np, ccb_p cp, int resid)
+static __inline void sym_set_cam_result_ok(struct sym_hcb *np, ccb_p cp, int resid)
 {
 	struct scsi_cmnd *cmd = cp->cam_ccb;
 
 	cmd->resid = resid;
 	cmd->result = (((DID_OK) << 16) + ((cp->ssss_status) & 0x7f));
 }
-void sym_set_cam_result_error(hcb_p np, ccb_p cp, int resid);
+void sym_set_cam_result_error(struct sym_hcb *np, ccb_p cp, int resid);
 
 /*
  *  Other O/S specific methods.
@@ -549,13 +534,12 @@ void sym_set_cam_result_error(hcb_p np, 
 #define sym_cam_target_id(ccb)	(ccb)->target
 #define sym_cam_target_lun(ccb)	(ccb)->lun
 #define	sym_freeze_cam_ccb(ccb)	do { ; } while (0)
-void sym_xpt_done(hcb_p np, cam_ccb_p ccb);
-void sym_xpt_done2(hcb_p np, cam_ccb_p ccb, int cam_status);
+void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *ccb);
 void sym_print_addr (ccb_p cp);
-void sym_xpt_async_bus_reset(hcb_p np);
-void sym_xpt_async_sent_bdr(hcb_p np, int target);
-int  sym_setup_data_and_start (hcb_p np, cam_scsiio_p csio, ccb_p cp);
-void sym_log_bus_error(hcb_p np);
-void sym_sniff_inquiry(hcb_p np, struct scsi_cmnd *cmd, int resid);
+void sym_xpt_async_bus_reset(struct sym_hcb *np);
+void sym_xpt_async_sent_bdr(struct sym_hcb *np, int target);
+int  sym_setup_data_and_start (struct sym_hcb *np, struct scsi_cmnd *csio, ccb_p cp);
+void sym_log_bus_error(struct sym_hcb *np);
+void sym_sniff_inquiry(struct sym_hcb *np, struct scsi_cmnd *cmd, int resid);
 
 #endif /* SYM_GLUE_H */
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	2004-12-26 14:03:11.000000000 -0700
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	2004-12-29 12:40:39.207485509 -0700
@@ -47,14 +47,14 @@
 /*
  *  Needed function prototypes.
  */
-static void sym_int_ma (hcb_p np);
-static void sym_int_sir (hcb_p np);
-static ccb_p sym_alloc_ccb(hcb_p np);
-static ccb_p sym_ccb_from_dsa(hcb_p np, u32 dsa);
-static void sym_alloc_lcb_tags (hcb_p np, u_char tn, u_char ln);
-static void sym_complete_error (hcb_p np, ccb_p cp);
-static void sym_complete_ok (hcb_p np, ccb_p cp);
-static int sym_compute_residual(hcb_p np, ccb_p cp);
+static void sym_int_ma (struct sym_hcb *np);
+static void sym_int_sir (struct sym_hcb *np);
+static ccb_p sym_alloc_ccb(struct sym_hcb *np);
+static ccb_p sym_ccb_from_dsa(struct sym_hcb *np, u32 dsa);
+static void sym_alloc_lcb_tags (struct sym_hcb *np, u_char tn, u_char ln);
+static void sym_complete_error (struct sym_hcb *np, ccb_p cp);
+static void sym_complete_ok (struct sym_hcb *np, ccb_p cp);
+static int sym_compute_residual(struct sym_hcb *np, ccb_p cp);
 
 /*
  *  Returns the name of this driver.
@@ -86,12 +86,12 @@ static void sym_printl_hex (char *label,
  *  Print something which allows to retrieve the controler type, 
  *  unit, target, lun concerned by a kernel message.
  */
-static void sym_print_target (hcb_p np, int target)
+static void sym_print_target (struct sym_hcb *np, int target)
 {
 	printf ("%s:%d:", sym_name(np), target);
 }
 
-static void sym_print_lun(hcb_p np, int target, int lun)
+static void sym_print_lun(struct sym_hcb *np, int target, int lun)
 {
 	printf ("%s:%d:%d:", sym_name(np), target, lun);
 }
@@ -126,7 +126,7 @@ static void sym_print_msg (ccb_p cp, cha
 	printf (".\n");
 }
 
-static void sym_print_nego_msg (hcb_p np, int target, char *label, u_char *msg)
+static void sym_print_nego_msg (struct sym_hcb *np, int target, char *label, u_char *msg)
 {
 	PRINT_TARGET(np, target);
 	if (label)
@@ -184,7 +184,7 @@ static char *sym_scsi_bus_mode(int mode)
  *  On the other hand, LVD devices need some delay 
  *  to settle and report actual BUS mode in STEST4.
  */
-static void sym_chip_reset (hcb_p np)
+static void sym_chip_reset (struct sym_hcb *np)
 {
 	OUTB (nc_istat, SRST);
 	UDELAY (10);
@@ -201,7 +201,7 @@ static void sym_chip_reset (hcb_p np)
  *  So, we need to abort the current operation prior to 
  *  soft resetting the chip.
  */
-static void sym_soft_reset (hcb_p np)
+static void sym_soft_reset (struct sym_hcb *np)
 {
 	u_char istat = 0;
 	int i;
@@ -234,12 +234,12 @@ do_chip_reset:
  *
  *  The interrupt handler will reinitialize the chip.
  */
-static void sym_start_reset(hcb_p np)
+static void sym_start_reset(struct sym_hcb *np)
 {
 	(void) sym_reset_scsi_bus(np, 1);
 }
  
-int sym_reset_scsi_bus(hcb_p np, int enab_int)
+int sym_reset_scsi_bus(struct sym_hcb *np, int enab_int)
 {
 	u32 term;
 	int retv = 0;
@@ -293,7 +293,7 @@ out:
 /*
  *  Select SCSI clock frequency
  */
-static void sym_selectclock(hcb_p np, u_char scntl3)
+static void sym_selectclock(struct sym_hcb *np, u_char scntl3)
 {
 	/*
 	 *  If multiplier not present or not selected, leave here.
@@ -348,7 +348,7 @@ static void sym_selectclock(hcb_p np, u_
 /*
  *  calculate SCSI clock frequency (in KHz)
  */
-static unsigned getfreq (hcb_p np, int gen)
+static unsigned getfreq (struct sym_hcb *np, int gen)
 {
 	unsigned int ms = 0;
 	unsigned int f;
@@ -420,7 +420,7 @@ static unsigned getfreq (hcb_p np, int g
 	return f;
 }
 
-static unsigned sym_getfreq (hcb_p np)
+static unsigned sym_getfreq (struct sym_hcb *np)
 {
 	u_int f1, f2;
 	int gen = 8;
@@ -435,7 +435,7 @@ static unsigned sym_getfreq (hcb_p np)
 /*
  *  Get/probe chip SCSI clock frequency
  */
-static void sym_getclock (hcb_p np, int mult)
+static void sym_getclock (struct sym_hcb *np, int mult)
 {
 	unsigned char scntl3 = np->sv_scntl3;
 	unsigned char stest1 = np->sv_stest1;
@@ -492,7 +492,7 @@ static void sym_getclock (hcb_p np, int 
 /*
  *  Get/probe PCI clock frequency
  */
-static int sym_getpciclock (hcb_p np)
+static int sym_getpciclock (struct sym_hcb *np)
 {
 	int f = 0;
 
@@ -528,7 +528,7 @@ static u32 div_10M[] = {2*_5M, 3*_5M, 4*
  *  synchronous factor period.
  */
 static int 
-sym_getsync(hcb_p np, u_char dt, u_char sfac, u_char *divp, u_char *fakp)
+sym_getsync(struct sym_hcb *np, u_char dt, u_char sfac, u_char *divp, u_char *fakp)
 {
 	u32	clk = np->clock_khz;	/* SCSI clock frequency in kHz	*/
 	int	div = np->clock_divn;	/* Number of divisors supported	*/
@@ -648,7 +648,7 @@ sym_getsync(hcb_p np, u_char dt, u_char 
 /*
  *  Set initial io register bits from burst code.
  */
-static __inline void sym_init_burst(hcb_p np, u_char bc)
+static __inline void sym_init_burst(struct sym_hcb *np, u_char bc)
 {
 	np->rv_ctest4	&= ~0x80;
 	np->rv_dmode	&= ~(0x3 << 6);
@@ -668,7 +668,7 @@ static __inline void sym_init_burst(hcb_
 /*
  * Print out the list of targets that have some flag disabled by user.
  */
-static void sym_print_targets_flag(hcb_p np, int mask, char *msg)
+static void sym_print_targets_flag(struct sym_hcb *np, int mask, char *msg)
 {
 	int cnt;
 	int i;
@@ -696,7 +696,7 @@ static void sym_print_targets_flag(hcb_p
  *  is not safe on paper, but it seems to work quite 
  *  well. :)
  */
-static void sym_save_initial_setting (hcb_p np)
+static void sym_save_initial_setting (struct sym_hcb *np)
 {
 	np->sv_scntl0	= INB(nc_scntl0) & 0x0a;
 	np->sv_scntl3	= INB(nc_scntl3) & 0x07;
@@ -716,44 +716,11 @@ static void sym_save_initial_setting (hc
 		np->sv_ctest5	= INB(nc_ctest5) & 0x24;
 }
 
-#ifdef CONFIG_PARISC
-static u32 parisc_setup_hcb(hcb_p np, u32 period)
-{
-	unsigned long pdc_period;
-	char scsi_mode;
-	struct hardware_path hwpath;
-
-	/* Host firmware (PDC) keeps a table for crippling SCSI capabilities.
-	 * Many newer machines export one channel of 53c896 chip
-	 * as SE, 50-pin HD.  Also used for Multi-initiator SCSI clusters
-	 * to set the SCSI Initiator ID.
-	 */
-	get_pci_node_path(np->s.device, &hwpath);
-	if (!pdc_get_initiator(&hwpath, &np->myaddr, &pdc_period,
-				&np->maxwide, &scsi_mode))
-		return period;
-
-	if (scsi_mode >= 0) {
-		/* C3000 PDC reports period/mode */
-		SYM_SETUP_SCSI_DIFF = 0;
-		switch(scsi_mode) {
-		case 0:	np->scsi_mode = SMODE_SE; break;
-		case 1:	np->scsi_mode = SMODE_HVD; break;
-		case 2:	np->scsi_mode = SMODE_LVD; break;
-		default:	break;
-		}
-	}
-
-	return (u32) pdc_period;
-}
-#else
-static inline int parisc_setup_hcb(hcb_p np, u32 period) { return period; }
-#endif
 /*
  *  Prepare io register values used by sym_start_up() 
  *  according to selected and supported features.
  */
-static int sym_prepare_setting(hcb_p np, struct sym_nvram *nvram)
+static int sym_prepare_setting(struct sym_hcb *np, struct sym_nvram *nvram)
 {
 	u_char	burst_max;
 	u32	period;
@@ -816,8 +783,6 @@ static int sym_prepare_setting(hcb_p np,
 	 */
 	period = (4 * div_10M[0] + np->clock_khz - 1) / np->clock_khz;
 
-	period = parisc_setup_hcb(np, period);
-
 	if	(period <= 250)		np->minsync = 10;
 	else if	(period <= 303)		np->minsync = 11;
 	else if	(period <= 500)		np->minsync = 12;
@@ -880,7 +845,7 @@ static int sym_prepare_setting(hcb_p np,
 	 *  In dual channel mode, contention occurs if internal cycles
 	 *  are used. Disable internal cycles.
 	 */
-	if (np->device_id == PCI_ID_LSI53C1010_33 &&
+	if (np->device_id == PCI_DEVICE_ID_LSI_53C1010_33 &&
 	    np->revision_id < 0x1)
 		np->rv_ccntl0	|=  DILS;
 
@@ -904,9 +869,9 @@ static int sym_prepare_setting(hcb_p np,
 	 *  this driver. The generic ncr driver that does not use 
 	 *  LOAD/STORE instructions does not need this work-around.
 	 */
-	if ((np->device_id == PCI_ID_SYM53C810 &&
+	if ((np->device_id == PCI_DEVICE_ID_NCR_53C810 &&
 	     np->revision_id >= 0x10 && np->revision_id <= 0x11) ||
-	    (np->device_id == PCI_ID_SYM53C860 &&
+	    (np->device_id == PCI_DEVICE_ID_NCR_53C860 &&
 	     np->revision_id <= 0x1))
 		np->features &= ~(FE_WRIE|FE_ERL|FE_ERMP);
 
@@ -1000,7 +965,7 @@ static int sym_prepare_setting(hcb_p np,
 	if ((SYM_SETUP_SCSI_LED || 
 	     (nvram->type == SYM_SYMBIOS_NVRAM ||
 	      (nvram->type == SYM_TEKRAM_NVRAM &&
-	       np->device_id == PCI_ID_SYM53C895))) &&
+	       np->device_id == PCI_DEVICE_ID_NCR_53C895))) &&
 	    !(np->features & FE_LEDC) && !(np->sv_gpcntl & 0x01))
 		np->features |= FE_LED0;
 
@@ -1091,7 +1056,7 @@ static int sym_prepare_setting(hcb_p np,
  *  Has to be called with interrupts disabled.
  */
 #ifndef SYM_CONF_IOMAPPED
-static int sym_regtest (hcb_p np)
+static int sym_regtest (struct sym_hcb *np)
 {
 	register volatile u32 data;
 	/*
@@ -1115,7 +1080,7 @@ static int sym_regtest (hcb_p np)
 }
 #endif
 
-static int sym_snooptest (hcb_p np)
+static int sym_snooptest (struct sym_hcb *np)
 {
 	u32	sym_rd, sym_wr, sym_bk, host_rd, host_wr, pc, dstat;
 	int	i, err=0;
@@ -1241,7 +1206,7 @@ restart_test:
  *  First 24 register of the chip:
  *  	r0..rf
  */
-static void sym_log_hard_error(hcb_p np, u_short sist, u_char dstat)
+static void sym_log_hard_error(struct sym_hcb *np, u_short sist, u_char dstat)
 {
 	u32	dsp;
 	int	script_ofs;
@@ -1299,85 +1264,85 @@ static void sym_log_hard_error(hcb_p np,
 }
 
 static struct sym_pci_chip sym_pci_dev_table[] = {
- {PCI_ID_SYM53C810, 0x0f, "810", 4, 8, 4, 64,
+ {PCI_DEVICE_ID_NCR_53C810, 0x0f, "810", 4, 8, 4, 64,
  FE_ERL}
  ,
 #ifdef SYM_DEBUG_GENERIC_SUPPORT
- {PCI_ID_SYM53C810, 0xff, "810a", 4,  8, 4, 1,
+ {PCI_DEVICE_ID_NCR_53C810, 0xff, "810a", 4,  8, 4, 1,
  FE_BOF}
  ,
 #else
- {PCI_ID_SYM53C810, 0xff, "810a", 4,  8, 4, 1,
+ {PCI_DEVICE_ID_NCR_53C810, 0xff, "810a", 4,  8, 4, 1,
  FE_CACHE_SET|FE_LDSTR|FE_PFEN|FE_BOF}
  ,
 #endif
- {PCI_ID_SYM53C815, 0xff, "815", 4,  8, 4, 64,
+ {PCI_DEVICE_ID_NCR_53C815, 0xff, "815", 4,  8, 4, 64,
  FE_BOF|FE_ERL}
  ,
- {PCI_ID_SYM53C825, 0x0f, "825", 6,  8, 4, 64,
+ {PCI_DEVICE_ID_NCR_53C825, 0x0f, "825", 6,  8, 4, 64,
  FE_WIDE|FE_BOF|FE_ERL|FE_DIFF}
  ,
- {PCI_ID_SYM53C825, 0xff, "825a", 6,  8, 4, 2,
+ {PCI_DEVICE_ID_NCR_53C825, 0xff, "825a", 6,  8, 4, 2,
  FE_WIDE|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|FE_RAM|FE_DIFF}
  ,
- {PCI_ID_SYM53C860, 0xff, "860", 4,  8, 5, 1,
+ {PCI_DEVICE_ID_NCR_53C860, 0xff, "860", 4,  8, 5, 1,
  FE_ULTRA|FE_CACHE_SET|FE_BOF|FE_LDSTR|FE_PFEN}
  ,
- {PCI_ID_SYM53C875, 0x01, "875", 6, 16, 5, 2,
+ {PCI_DEVICE_ID_NCR_53C875, 0x01, "875", 6, 16, 5, 2,
  FE_WIDE|FE_ULTRA|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_DIFF|FE_VARCLK}
  ,
- {PCI_ID_SYM53C875, 0xff, "875", 6, 16, 5, 2,
+ {PCI_DEVICE_ID_NCR_53C875, 0xff, "875", 6, 16, 5, 2,
  FE_WIDE|FE_ULTRA|FE_DBLR|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_DIFF|FE_VARCLK}
  ,
- {PCI_ID_SYM53C875_2, 0xff, "875", 6, 16, 5, 2,
+ {PCI_DEVICE_ID_NCR_53C875J, 0xff, "875J", 6, 16, 5, 2,
  FE_WIDE|FE_ULTRA|FE_DBLR|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_DIFF|FE_VARCLK}
  ,
- {PCI_ID_SYM53C885, 0xff, "885", 6, 16, 5, 2,
+ {PCI_DEVICE_ID_NCR_53C885, 0xff, "885", 6, 16, 5, 2,
  FE_WIDE|FE_ULTRA|FE_DBLR|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_DIFF|FE_VARCLK}
  ,
 #ifdef SYM_DEBUG_GENERIC_SUPPORT
- {PCI_ID_SYM53C895, 0xff, "895", 6, 31, 7, 2,
+ {PCI_DEVICE_ID_NCR_53C895, 0xff, "895", 6, 31, 7, 2,
  FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|
  FE_RAM|FE_LCKFRQ}
  ,
 #else
- {PCI_ID_SYM53C895, 0xff, "895", 6, 31, 7, 2,
+ {PCI_DEVICE_ID_NCR_53C895, 0xff, "895", 6, 31, 7, 2,
  FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_LCKFRQ}
  ,
 #endif
- {PCI_ID_SYM53C896, 0xff, "896", 6, 31, 7, 4,
+ {PCI_DEVICE_ID_NCR_53C896, 0xff, "896", 6, 31, 7, 4,
  FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_LCKFRQ}
  ,
- {PCI_ID_SYM53C895A, 0xff, "895a", 6, 31, 7, 4,
+ {PCI_DEVICE_ID_LSI_53C895A, 0xff, "895a", 6, 31, 7, 4,
  FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_RAM8K|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_LCKFRQ}
  ,
- {PCI_ID_SYM53C875A, 0xff, "875a", 6, 31, 7, 4,
+ {PCI_DEVICE_ID_LSI_53C875A, 0xff, "875a", 6, 31, 7, 4,
  FE_WIDE|FE_ULTRA|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_LCKFRQ}
  ,
- {PCI_ID_LSI53C1010_33, 0x00, "1010-33", 6, 31, 7, 8,
+ {PCI_DEVICE_ID_LSI_53C1010_33, 0x00, "1010-33", 6, 31, 7, 8,
  FE_WIDE|FE_ULTRA3|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFBC|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_CRC|
  FE_C10}
  ,
- {PCI_ID_LSI53C1010_33, 0xff, "1010-33", 6, 31, 7, 8,
+ {PCI_DEVICE_ID_LSI_53C1010_33, 0xff, "1010-33", 6, 31, 7, 8,
  FE_WIDE|FE_ULTRA3|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFBC|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_CRC|
  FE_C10|FE_U3EN}
  ,
- {PCI_ID_LSI53C1010_66, 0xff, "1010-66", 6, 31, 7, 8,
+ {PCI_DEVICE_ID_LSI_53C1010_66, 0xff, "1010-66", 6, 31, 7, 8,
  FE_WIDE|FE_ULTRA3|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFBC|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_66MHZ|FE_CRC|
  FE_C10|FE_U3EN}
  ,
- {PCI_ID_LSI53C1510D, 0xff, "1510d", 6, 31, 7, 4,
+ {PCI_DEVICE_ID_LSI_53C1510, 0xff, "1510d", 6, 31, 7, 4,
  FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_IO256|FE_LEDC}
 };
@@ -1415,7 +1380,7 @@ sym_lookup_pci_chip_table (u_short devic
  *  This is only used if the direct mapping 
  *  has been unsuccessful.
  */
-int sym_lookup_dmap(hcb_p np, u32 h, int s)
+int sym_lookup_dmap(struct sym_hcb *np, u32 h, int s)
 {
 	int i;
 
@@ -1448,7 +1413,7 @@ new:
  *  Update IO registers scratch C..R so they will be 
  *  in sync. with queued CCB expectations.
  */
-static void sym_update_dmap_regs(hcb_p np)
+static void sym_update_dmap_regs(struct sym_hcb *np)
 {
 	int o, i;
 
@@ -1463,13 +1428,12 @@ static void sym_update_dmap_regs(hcb_p n
 }
 #endif
 
+/* Enforce all the fiddly SPI rules and the chip limitations */
 static void sym_check_goals(struct scsi_device *sdev)
 {
 	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
 	struct sym_trans *st = &np->target[sdev->id].tinfo.goal;
 
-	/* here we enforce all the fiddly SPI rules */
-
 	if (!scsi_device_wide(sdev))
 		st->width = 0;
 
@@ -1479,7 +1443,7 @@ static void sym_check_goals(struct scsi_
 		st->offset = 0;
 		return;
 	}
-		
+
 	if (scsi_device_dt(sdev)) {
 		if (scsi_device_dt_only(sdev))
 			st->options |= PPR_OPT_DT;
@@ -1490,7 +1454,8 @@ static void sym_check_goals(struct scsi_
 		st->options &= ~PPR_OPT_DT;
 	}
 
-	if (!(np->features & FE_ULTRA3))
+	/* Some targets fail to properly negotiate DT in SE mode */
+	if ((np->scsi_mode != SMODE_LVD) || !(np->features & FE_U3EN))
 		st->options &= ~PPR_OPT_DT;
 
 	if (st->options & PPR_OPT_DT) {
@@ -1520,38 +1485,31 @@ static void sym_check_goals(struct scsi_
  *  negotiation and the nego_status field of the CCB.
  *  Returns the size of the message in bytes.
  */
-static int sym_prepare_nego(hcb_p np, ccb_p cp, int nego, u_char *msgptr)
+static int sym_prepare_nego(struct sym_hcb *np, ccb_p cp, u_char *msgptr)
 {
 	tcb_p tp = &np->target[cp->target];
-	int msglen = 0;
 	struct scsi_device *sdev = tp->sdev;
+	struct sym_trans *goal = &tp->tinfo.goal;
+	struct sym_trans *curr = &tp->tinfo.curr;
+	int msglen = 0;
+	int nego;
 
 	if (likely(sdev))
 		sym_check_goals(sdev);
 
 	/*
-	 *  Early C1010 chips need a work-around for DT 
-	 *  data transfer to work.
+	 * Many devices implement PPR in a buggy way, so only use it if we
+	 * really want to.
 	 */
-	if (!(np->features & FE_U3EN))
-		tp->tinfo.goal.options = 0;
-	/*
-	 *  negotiate using PPR ?
-	 */
-	if (scsi_device_dt(sdev)) {
+	if ((goal->options & PPR_OPT_MASK) || (goal->period < 0xa)) {
 		nego = NS_PPR;
+	} else if (curr->width != goal->width) {
+		nego = NS_WIDE;
+	} else if (curr->period != goal->period ||
+		   curr->offset != goal->offset) {
+		nego = NS_SYNC;
 	} else {
-		/*
-		 *  negotiate wide transfers ?
-		 */
-		if (tp->tinfo.curr.width != tp->tinfo.goal.width)
-			nego = NS_WIDE;
-		/*
-		 *  negotiate synchronous transfers?
-		 */
-		else if (tp->tinfo.curr.period != tp->tinfo.goal.period ||
-			 tp->tinfo.curr.offset != tp->tinfo.goal.offset)
-			nego = NS_SYNC;
+		nego = 0;
 	}
 
 	switch (nego) {
@@ -1559,24 +1517,24 @@ static int sym_prepare_nego(hcb_p np, cc
 		msgptr[msglen++] = M_EXTENDED;
 		msgptr[msglen++] = 3;
 		msgptr[msglen++] = M_X_SYNC_REQ;
-		msgptr[msglen++] = tp->tinfo.goal.period;
-		msgptr[msglen++] = tp->tinfo.goal.offset;
+		msgptr[msglen++] = goal->period;
+		msgptr[msglen++] = goal->offset;
 		break;
 	case NS_WIDE:
 		msgptr[msglen++] = M_EXTENDED;
 		msgptr[msglen++] = 2;
 		msgptr[msglen++] = M_X_WIDE_REQ;
-		msgptr[msglen++] = tp->tinfo.goal.width;
+		msgptr[msglen++] = goal->width;
 		break;
 	case NS_PPR:
 		msgptr[msglen++] = M_EXTENDED;
 		msgptr[msglen++] = 6;
 		msgptr[msglen++] = M_X_PPR_REQ;
-		msgptr[msglen++] = tp->tinfo.goal.period;
+		msgptr[msglen++] = goal->period;
 		msgptr[msglen++] = 0;
-		msgptr[msglen++] = tp->tinfo.goal.offset;
-		msgptr[msglen++] = tp->tinfo.goal.width;
-		msgptr[msglen++] = tp->tinfo.goal.options & PPR_OPT_MASK;
+		msgptr[msglen++] = goal->offset;
+		msgptr[msglen++] = goal->width;
+		msgptr[msglen++] = goal->options & PPR_OPT_MASK;
 		break;
 	};
 
@@ -1598,7 +1556,7 @@ static int sym_prepare_nego(hcb_p np, cc
 /*
  *  Insert a job into the start queue.
  */
-void sym_put_start_queue(hcb_p np, ccb_p cp)
+void sym_put_start_queue(struct sym_hcb *np, ccb_p cp)
 {
 	u_short	qidx;
 
@@ -1630,13 +1588,6 @@ void sym_put_start_queue(hcb_p np, ccb_p
 #endif
 
 	/*
-	 *  Optionnaly, set the IO timeout condition.
-	 */
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-	sym_timeout_ccb(np, cp, sym_cam_timeout(cp->cam_ccb));
-#endif
-
-	/*
 	 *  Insert first the idle task and then our job.
 	 *  The MBs should ensure proper ordering.
 	 */
@@ -1664,7 +1615,7 @@ void sym_put_start_queue(hcb_p np, ccb_p
 /*
  *  Start next ready-to-start CCBs.
  */
-void sym_start_next_ccbs(hcb_p np, lcb_p lp, int maxn)
+void sym_start_next_ccbs(struct sym_hcb *np, lcb_p lp, int maxn)
 {
 	SYM_QUEHEAD *qp;
 	ccb_p cp;
@@ -1718,7 +1669,7 @@ void sym_start_next_ccbs(hcb_p np, lcb_p
  *  prevent out of order LOADs by the CPU from having 
  *  prefetched stale data prior to DMA having occurred.
  */
-static int sym_wakeup_done (hcb_p np)
+static int sym_wakeup_done (struct sym_hcb *np)
 {
 	ccb_p cp;
 	int i, n;
@@ -1752,10 +1703,64 @@ static int sym_wakeup_done (hcb_p np)
 }
 
 /*
+ *  Complete all CCBs queued to the COMP queue.
+ *
+ *  These CCBs are assumed:
+ *  - Not to be referenced either by devices or 
+ *    SCRIPTS-related queues and datas.
+ *  - To have to be completed with an error condition 
+ *    or requeued.
+ *
+ *  The device queue freeze count is incremented 
+ *  for each CCB that does not prevent this.
+ *  This function is called when all CCBs involved 
+ *  in error handling/recovery have been reaped.
+ */
+static void sym_flush_comp_queue(struct sym_hcb *np, int cam_status)
+{
+	SYM_QUEHEAD *qp;
+	ccb_p cp;
+
+	while ((qp = sym_remque_head(&np->comp_ccbq)) != 0) {
+		struct scsi_cmnd *ccb;
+		cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
+		sym_insque_tail(&cp->link_ccbq, &np->busy_ccbq);
+		/* Leave quiet CCBs waiting for resources */
+		if (cp->host_status == HS_WAIT)
+			continue;
+		ccb = cp->cam_ccb;
+		if (cam_status)
+			sym_set_cam_status(ccb, cam_status);
+#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
+		if (sym_get_cam_status(ccb) == CAM_REQUEUE_REQ) {
+			tcb_p tp = &np->target[cp->target];
+			lcb_p lp = sym_lp(np, tp, cp->lun);
+			if (lp) {
+				sym_remque(&cp->link2_ccbq);
+				sym_insque_tail(&cp->link2_ccbq,
+				                &lp->waiting_ccbq);
+				if (cp->started) {
+					if (cp->tag != NO_TAG)
+						--lp->started_tags;
+					else
+						--lp->started_no_tag;
+				}
+			}
+			cp->started = 0;
+			continue;
+		}
+#endif
+		sym_free_ccb(np, cp);
+		sym_freeze_cam_ccb(ccb);
+		sym_xpt_done(np, ccb);
+	}
+}
+
+/*
  *  Complete all active CCBs with error.
  *  Used on CHIP/SCSI RESET.
  */
-static void sym_flush_busy_queue (hcb_p np, int cam_status)
+static void sym_flush_busy_queue (struct sym_hcb *np, int cam_status)
 {
 	/*
 	 *  Move all active CCBs to the COMP queue 
@@ -1774,7 +1779,7 @@ static void sym_flush_busy_queue (hcb_p 
  *     1: SCSI BUS RESET delivered or received.
  *     2: SCSI BUS MODE changed.
  */
-void sym_start_up (hcb_p np, int reason)
+void sym_start_up (struct sym_hcb *np, int reason)
 {
  	int	i;
 	u32	phys;
@@ -1865,7 +1870,7 @@ void sym_start_up (hcb_p np, int reason)
 	/*
 	 *  For now, disable AIP generation on C1010-66.
 	 */
-	if (np->device_id == PCI_ID_LSI53C1010_66)
+	if (np->device_id == PCI_DEVICE_ID_LSI_53C1010_66)
 		OUTB (nc_aipcntl1, DISAIP);
 
 	/*
@@ -1875,7 +1880,7 @@ void sym_start_up (hcb_p np, int reason)
 	 *  that from SCRIPTS for each selection/reselection, but 
 	 *  I just don't want. :)
 	 */
-	if (np->device_id == PCI_ID_LSI53C1010_33 &&
+	if (np->device_id == PCI_DEVICE_ID_LSI_53C1010_33 &&
 	    np->revision_id < 1)
 		OUTB (nc_stest1, INB(nc_stest1) | 0x30);
 
@@ -1884,9 +1889,9 @@ void sym_start_up (hcb_p np, int reason)
 	 *  Disable overlapped arbitration for some dual function devices, 
 	 *  regardless revision id (kind of post-chip-design feature. ;-))
 	 */
-	if (np->device_id == PCI_ID_SYM53C875)
+	if (np->device_id == PCI_DEVICE_ID_NCR_53C875)
 		OUTB (nc_ctest0, (1<<5));
-	else if (np->device_id == PCI_ID_SYM53C896)
+	else if (np->device_id == PCI_DEVICE_ID_NCR_53C896)
 		np->rv_ccntl0 |= DPR;
 
 	/*
@@ -2010,7 +2015,7 @@ void sym_start_up (hcb_p np, int reason)
 /*
  *  Switch trans mode for current job and it's target.
  */
-static void sym_settrans(hcb_p np, int target, u_char opts, u_char ofs,
+static void sym_settrans(struct sym_hcb *np, int target, u_char opts, u_char ofs,
 			 u_char per, u_char wide, u_char div, u_char fak)
 {
 	SYM_QUEHEAD *qp;
@@ -2119,7 +2124,7 @@ static void sym_settrans(hcb_p np, int t
  *  We received a WDTR.
  *  Let everything be aware of the changes.
  */
-static void sym_setwide(hcb_p np, int target, u_char wide)
+static void sym_setwide(struct sym_hcb *np, int target, u_char wide)
 {
 	tcb_p tp = &np->target[target];
 
@@ -2138,7 +2143,7 @@ static void sym_setwide(hcb_p np, int ta
  *  Let everything be aware of the changes.
  */
 static void
-sym_setsync(hcb_p np, int target,
+sym_setsync(struct sym_hcb *np, int target,
             u_char ofs, u_char per, u_char div, u_char fak)
 {
 	tcb_p tp = &np->target[target];
@@ -2164,7 +2169,7 @@ sym_setsync(hcb_p np, int target,
  *  Let everything be aware of the changes.
  */
 static void 
-sym_setpprot(hcb_p np, int target, u_char opts, u_char ofs,
+sym_setpprot(struct sym_hcb *np, int target, u_char opts, u_char ofs,
              u_char per, u_char wide, u_char div, u_char fak)
 {
 	tcb_p tp = &np->target[target];
@@ -2205,7 +2210,7 @@ sym_setpprot(hcb_p np, int target, u_cha
  *  pushes a DSA into a queue, we can trust it when it 
  *  points to a CCB.
  */
-static void sym_recover_scsi_int (hcb_p np, u_char hsts)
+static void sym_recover_scsi_int (struct sym_hcb *np, u_char hsts)
 {
 	u32	dsp	= INL (nc_dsp);
 	u32	dsa	= INL (nc_dsa);
@@ -2256,7 +2261,7 @@ reset_all:
 /*
  *  chip exception handler for selection timeout
  */
-static void sym_int_sto (hcb_p np)
+static void sym_int_sto (struct sym_hcb *np)
 {
 	u32 dsp	= INL (nc_dsp);
 
@@ -2271,7 +2276,7 @@ static void sym_int_sto (hcb_p np)
 /*
  *  chip exception handler for unexpected disconnect
  */
-static void sym_int_udc (hcb_p np)
+static void sym_int_udc (struct sym_hcb *np)
 {
 	printf ("%s: unexpected disconnect\n", sym_name(np));
 	sym_recover_scsi_int(np, HS_UNEXPECTED);
@@ -2287,7 +2292,7 @@ static void sym_int_udc (hcb_p np)
  *  mode to eight bit asynchronous, etc...
  *  So, just reinitializing all except chip should be enough.
  */
-static void sym_int_sbmc (hcb_p np)
+static void sym_int_sbmc (struct sym_hcb *np)
 {
 	u_char scsi_mode = INB (nc_stest4) & SMODE;
 
@@ -2328,7 +2333,7 @@ static void sym_int_sbmc (hcb_p np)
  *    The chip will load the DSP with the phase mismatch 
  *    JUMP address and interrupt the host processor.
  */
-static void sym_int_par (hcb_p np, u_short sist)
+static void sym_int_par (struct sym_hcb *np, u_short sist)
 {
 	u_char	hsts	= INB (HS_PRT);
 	u32	dsp	= INL (nc_dsp);
@@ -2416,7 +2421,7 @@ reset_all:
  *  We have to construct a new transfer descriptor,
  *  to transfer the rest of the current block.
  */
-static void sym_int_ma (hcb_p np)
+static void sym_int_ma (struct sym_hcb *np)
 {
 	u32	dbc;
 	u32	rest;
@@ -2826,7 +2831,7 @@ reset_all:
  *  Use at your own decision and risk.
  */
 
-void sym_interrupt (hcb_p np)
+void sym_interrupt (struct sym_hcb *np)
 {
 	u_char	istat, istatc;
 	u_char	dstat;
@@ -2981,7 +2986,7 @@ unknown_int:
  *  It is called with SCRIPTS not running.
  */
 static int 
-sym_dequeue_from_squeue(hcb_p np, int i, int target, int lun, int task)
+sym_dequeue_from_squeue(struct sym_hcb *np, int i, int target, int lun, int task)
 {
 	int j;
 	ccb_p cp;
@@ -3025,60 +3030,6 @@ sym_dequeue_from_squeue(hcb_p np, int i,
 }
 
 /*
- *  Complete all CCBs queued to the COMP queue.
- *
- *  These CCBs are assumed:
- *  - Not to be referenced either by devices or 
- *    SCRIPTS-related queues and datas.
- *  - To have to be completed with an error condition 
- *    or requeued.
- *
- *  The device queue freeze count is incremented 
- *  for each CCB that does not prevent this.
- *  This function is called when all CCBs involved 
- *  in error handling/recovery have been reaped.
- */
-void sym_flush_comp_queue(hcb_p np, int cam_status)
-{
-	SYM_QUEHEAD *qp;
-	ccb_p cp;
-
-	while ((qp = sym_remque_head(&np->comp_ccbq)) != 0) {
-		cam_ccb_p ccb;
-		cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
-		sym_insque_tail(&cp->link_ccbq, &np->busy_ccbq);
-		/* Leave quiet CCBs waiting for resources */
-		if (cp->host_status == HS_WAIT)
-			continue;
-		ccb = cp->cam_ccb;
-		if (cam_status)
-			sym_set_cam_status(ccb, cam_status);
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-		if (sym_get_cam_status(ccb) == CAM_REQUEUE_REQ) {
-			tcb_p tp = &np->target[cp->target];
-			lcb_p lp = sym_lp(np, tp, cp->lun);
-			if (lp) {
-				sym_remque(&cp->link2_ccbq);
-				sym_insque_tail(&cp->link2_ccbq,
-				                &lp->waiting_ccbq);
-				if (cp->started) {
-					if (cp->tag != NO_TAG)
-						--lp->started_tags;
-					else
-						--lp->started_no_tag;
-				}
-			}
-			cp->started = 0;
-			continue;
-		}
-#endif
-		sym_free_ccb(np, cp);
-		sym_freeze_cam_ccb(ccb);
-		sym_xpt_done(np, ccb);
-	}
-}
-
-/*
  *  chip handler for bad SCSI status condition
  *
  *  In case of bad SCSI status, we unqueue all the tasks 
@@ -3096,14 +3047,13 @@ void sym_flush_comp_queue(hcb_p np, int 
  *  SCRATCHA is assumed to have been loaded with STARTPOS 
  *  before the SCRIPTS called the C code.
  */
-static void sym_sir_bad_scsi_status(hcb_p np, int num, ccb_p cp)
+static void sym_sir_bad_scsi_status(struct sym_hcb *np, int num, ccb_p cp)
 {
 	tcb_p tp	= &np->target[cp->target];
 	u32		startp;
 	u_char		s_status = cp->ssss_status;
 	u_char		h_flags  = cp->host_flags;
 	int		msglen;
-	int		nego;
 	int		i;
 
 	/*
@@ -3178,16 +3128,7 @@ static void sym_sir_bad_scsi_status(hcb_
 		 *  cp->nego_status is filled by sym_prepare_nego().
 		 */
 		cp->nego_status = 0;
-		nego = 0;
-		if	(tp->tinfo.curr.options & PPR_OPT_MASK)
-			nego = NS_PPR;
-		else if	(tp->tinfo.curr.width != BUS_8_BIT)
-			nego = NS_WIDE;
-		else if (tp->tinfo.curr.offset != 0)
-			nego = NS_SYNC;
-		if (nego)
-			msglen +=
-			sym_prepare_nego (np,cp, nego, &cp->scsi_smsg2[msglen]);
+		msglen += sym_prepare_nego(np, cp, &cp->scsi_smsg2[msglen]);
 		/*
 		 *  Message table indirect structure.
 		 */
@@ -3213,7 +3154,7 @@ static void sym_sir_bad_scsi_status(hcb_
 		/*
 		 *  sense data
 		 */
-		bzero(cp->sns_bbuf, SYM_SNS_BBUF_LEN);
+		memset(cp->sns_bbuf, 0, SYM_SNS_BBUF_LEN);
 		cp->phys.sense.addr	= cpu_to_scr(vtobus(cp->sns_bbuf));
 		cp->phys.sense.size	= cpu_to_scr(SYM_SNS_BBUF_LEN);
 
@@ -3263,7 +3204,7 @@ static void sym_sir_bad_scsi_status(hcb_
  *  - lun=-1  means any logical UNIT otherwise a given one.
  *  - task=-1 means any task, otherwise a given one.
  */
-int sym_clear_tasks(hcb_p np, int cam_status, int target, int lun, int task)
+int sym_clear_tasks(struct sym_hcb *np, int cam_status, int target, int lun, int task)
 {
 	SYM_QUEHEAD qtmp, *qp;
 	int i = 0;
@@ -3282,7 +3223,7 @@ int sym_clear_tasks(hcb_p np, int cam_st
 	 *  the BUSY queue.
 	 */
 	while ((qp = sym_remque_head(&qtmp)) != 0) {
-		cam_ccb_p ccb;
+		struct scsi_cmnd *ccb;
 		cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
 		ccb = cp->cam_ccb;
 		if (cp->host_status != HS_DISCONNECT ||
@@ -3346,7 +3287,7 @@ printf("XXXX TASK @%p CLEARED\n", cp);
  *  all the CCBs that should have been aborted by the 
  *  target according to our message.
  */
-static void sym_sir_task_recovery(hcb_p np, int num)
+static void sym_sir_task_recovery(struct sym_hcb *np, int num)
 {
 	SYM_QUEHEAD *qp;
 	ccb_p cp;
@@ -3698,7 +3639,7 @@ static void sym_sir_task_recovery(hcb_p 
  *  the corresponding values of dp_sg and dp_ofs.
  */
 
-static int sym_evaluate_dp(hcb_p np, ccb_p cp, u32 scr, int *ofs)
+static int sym_evaluate_dp(struct sym_hcb *np, ccb_p cp, u32 scr, int *ofs)
 {
 	u32	dp_scr;
 	int	dp_ofs, dp_sg, dp_sgmin;
@@ -3816,7 +3757,7 @@ out_err:
  *  is equivalent to a MODIFY DATA POINTER (offset=-1).
  */
 
-static void sym_modify_dp(hcb_p np, tcb_p tp, ccb_p cp, int ofs)
+static void sym_modify_dp(struct sym_hcb *np, tcb_p tp, ccb_p cp, int ofs)
 {
 	int dp_ofs	= ofs;
 	u32	dp_scr	= sym_get_script_dp (np, cp);
@@ -3915,7 +3856,7 @@ out_reject:
  *  a relevant information. :)
  */
 
-int sym_compute_residual(hcb_p np, ccb_p cp)
+int sym_compute_residual(struct sym_hcb *np, ccb_p cp)
 {
 	int dp_sg, dp_sgmin, resid = 0;
 	int dp_ofs = 0;
@@ -4015,7 +3956,7 @@ int sym_compute_residual(hcb_p np, ccb_p
  *  chip handler for SYNCHRONOUS DATA TRANSFER REQUEST (SDTR) message.
  */
 static int  
-sym_sync_nego_check(hcb_p np, int req, int target)
+sym_sync_nego_check(struct sym_hcb *np, int req, int target)
 {
 	u_char	chg, ofs, per, fak, div;
 
@@ -4096,7 +4037,7 @@ reject_it:
 	return -1;
 }
 
-static void sym_sync_nego(hcb_p np, tcb_p tp, ccb_p cp)
+static void sym_sync_nego(struct sym_hcb *np, tcb_p tp, ccb_p cp)
 {
 	int req = 1;
 	int result;
@@ -4133,7 +4074,7 @@ reject_it:
  *  chip handler for PARALLEL PROTOCOL REQUEST (PPR) message.
  */
 static int 
-sym_ppr_nego_check(hcb_p np, int req, int target)
+sym_ppr_nego_check(struct sym_hcb *np, int req, int target)
 {
 	tcb_p tp = &np->target[target];
 	unsigned char fak, div;
@@ -4176,7 +4117,7 @@ sym_ppr_nego_check(hcb_p np, int req, in
 
 	if (ofs) {
 		unsigned char minsync = dt ? np->minsync_dt : np->minsync;
-		if (per < np->minsync_dt) {
+		if (per < minsync) {
 			chg = 1;
 			per = minsync;
 		}
@@ -4242,7 +4183,7 @@ reject_it:
 	return -1;
 }
 
-static void sym_ppr_nego(hcb_p np, tcb_p tp, ccb_p cp)
+static void sym_ppr_nego(struct sym_hcb *np, tcb_p tp, ccb_p cp)
 {
 	int req = 1;
 	int result;
@@ -4279,7 +4220,7 @@ reject_it:
  *  chip handler for WIDE DATA TRANSFER REQUEST (WDTR) message.
  */
 static int  
-sym_wide_nego_check(hcb_p np, int req, int target)
+sym_wide_nego_check(struct sym_hcb *np, int req, int target)
 {
 	u_char	chg, wide;
 
@@ -4344,7 +4285,7 @@ reject_it:
 	return -1;
 }
 
-static void sym_wide_nego(hcb_p np, tcb_p tp, ccb_p cp)
+static void sym_wide_nego(struct sym_hcb *np, tcb_p tp, ccb_p cp)
 {
 	int req = 1;
 	int result;
@@ -4413,7 +4354,7 @@ reject_it:
  *  So, if a PPR makes problems, we may just want to 
  *  try a legacy negotiation later.
  */
-static void sym_nego_default(hcb_p np, tcb_p tp, ccb_p cp)
+static void sym_nego_default(struct sym_hcb *np, tcb_p tp, ccb_p cp)
 {
 	switch (cp->nego_status) {
 	case NS_PPR:
@@ -4443,7 +4384,7 @@ static void sym_nego_default(hcb_p np, t
  *  chip handler for MESSAGE REJECT received in response to 
  *  PPR, WIDE or SYNCHRONOUS negotiation.
  */
-static void sym_nego_rejected(hcb_p np, tcb_p tp, ccb_p cp)
+static void sym_nego_rejected(struct sym_hcb *np, tcb_p tp, ccb_p cp)
 {
 	sym_nego_default(np, tp, cp);
 	OUTB (HS_PRT, HS_BUSY);
@@ -4452,7 +4393,7 @@ static void sym_nego_rejected(hcb_p np, 
 /*
  *  chip exception handler for programmed interrupts.
  */
-static void sym_int_sir (hcb_p np)
+static void sym_int_sir (struct sym_hcb *np)
 {
 	u_char	num	= INB (nc_dsps);
 	u32	dsa	= INL (nc_dsa);
@@ -4726,7 +4667,7 @@ out_stuck:
 /*
  *  Acquire a control block
  */
-ccb_p sym_get_ccb (hcb_p np, u_char tn, u_char ln, u_char tag_order)
+ccb_p sym_get_ccb (struct sym_hcb *np, u_char tn, u_char ln, u_char tag_order)
 {
 	tcb_p tp = &np->target[tn];
 	lcb_p lp = sym_lp(np, tp, ln);
@@ -4875,7 +4816,7 @@ out_free:
 /*
  *  Release one control block
  */
-void sym_free_ccb (hcb_p np, ccb_p cp)
+void sym_free_ccb (struct sym_hcb *np, ccb_p cp)
 {
 	tcb_p tp = &np->target[cp->target];
 	lcb_p lp = sym_lp(np, tp, cp->lun);
@@ -4960,13 +4901,6 @@ void sym_free_ccb (hcb_p np, ccb_p cp)
 	sym_remque(&cp->link_ccbq);
 	sym_insque_head(&cp->link_ccbq, &np->free_ccbq);
 
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-	/*
-	 *  Cancel any pending timeout condition.
-	 */
-	sym_untimeout_ccb(np, cp);
-#endif
-
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 	if (lp) {
 		sym_remque(&cp->link2_ccbq);
@@ -4985,7 +4919,7 @@ void sym_free_ccb (hcb_p np, ccb_p cp)
 /*
  *  Allocate a CCB from memory and initialize its fixed part.
  */
-static ccb_p sym_alloc_ccb(hcb_p np)
+static ccb_p sym_alloc_ccb(struct sym_hcb *np)
 {
 	ccb_p cp = NULL;
 	int hcode;
@@ -5053,9 +4987,6 @@ static ccb_p sym_alloc_ccb(hcb_p np)
 	/*
 	 *  Chain into optionnal lists.
 	 */
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-	sym_insque_head(&cp->tmo_linkq, &np->tmo0_ccbq);
-#endif
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 	sym_insque_head(&cp->link2_ccbq, &np->dummy_ccbq);
 #endif
@@ -5072,7 +5003,7 @@ out_free:
 /*
  *  Look up a CCB from a DSA value.
  */
-static ccb_p sym_ccb_from_dsa(hcb_p np, u32 dsa)
+static ccb_p sym_ccb_from_dsa(struct sym_hcb *np, u32 dsa)
 {
 	int hcode;
 	ccb_p cp;
@@ -5092,7 +5023,7 @@ static ccb_p sym_ccb_from_dsa(hcb_p np, 
  *  Target control block initialisation.
  *  Nothing important to do at the moment.
  */
-static void sym_init_tcb (hcb_p np, u_char tn)
+static void sym_init_tcb (struct sym_hcb *np, u_char tn)
 {
 #if 0	/*  Hmmm... this checking looks paranoid. */
 	/*
@@ -5108,7 +5039,7 @@ static void sym_init_tcb (hcb_p np, u_ch
 /*
  *  Lun control block allocation and initialization.
  */
-lcb_p sym_alloc_lcb (hcb_p np, u_char tn, u_char ln)
+lcb_p sym_alloc_lcb (struct sym_hcb *np, u_char tn, u_char ln)
 {
 	tcb_p tp = &np->target[tn];
 	lcb_p lp = sym_lp(np, tp, ln);
@@ -5210,7 +5141,7 @@ fail:
 /*
  *  Allocate LCB resources for tagged command queuing.
  */
-static void sym_alloc_lcb_tags (hcb_p np, u_char tn, u_char ln)
+static void sym_alloc_lcb_tags (struct sym_hcb *np, u_char tn, u_char ln)
 {
 	tcb_p tp = &np->target[tn];
 	lcb_p lp = sym_lp(np, tp, ln);
@@ -5262,7 +5193,7 @@ fail:
 /*
  *  Queue a SCSI IO to the controller.
  */
-int sym_queue_scsiio(hcb_p np, cam_scsiio_p csio, ccb_p cp)
+int sym_queue_scsiio(struct sym_hcb *np, struct scsi_cmnd *csio, ccb_p cp)
 {
 	tcb_p	tp;
 	lcb_p	lp;
@@ -5273,7 +5204,7 @@ int sym_queue_scsiio(hcb_p np, cam_scsii
 	/*
 	 *  Keep track of the IO in our CCB.
 	 */
-	cp->cam_ccb = (cam_ccb_p) csio;
+	cp->cam_ccb = csio;
 
 	/*
 	 *  Retrieve the target descriptor.
@@ -5351,7 +5282,7 @@ int sym_queue_scsiio(hcb_p np, cam_scsii
 	    tp->tinfo.curr.offset  != tp->tinfo.goal.offset ||
 	    tp->tinfo.curr.options != tp->tinfo.goal.options) {
 		if (!tp->nego_cp && lp)
-			msglen += sym_prepare_nego(np, cp, 0, msgptr + msglen);
+			msglen += sym_prepare_nego(np, cp, msgptr + msglen);
 	}
 
 	/*
@@ -5401,7 +5332,7 @@ int sym_queue_scsiio(hcb_p np, cam_scsii
 /*
  *  Reset a SCSI target (all LUNs of this target).
  */
-int sym_reset_scsi_target(hcb_p np, int target)
+int sym_reset_scsi_target(struct sym_hcb *np, int target)
 {
 	tcb_p tp;
 
@@ -5420,7 +5351,7 @@ int sym_reset_scsi_target(hcb_p np, int 
 /*
  *  Abort a SCSI IO.
  */
-int sym_abort_ccb(hcb_p np, ccb_p cp, int timed_out)
+int sym_abort_ccb(struct sym_hcb *np, ccb_p cp, int timed_out)
 {
 	/*
 	 *  Check that the IO is active.
@@ -5450,7 +5381,7 @@ int sym_abort_ccb(hcb_p np, ccb_p cp, in
 	return 0;
 }
 
-int sym_abort_scsiio(hcb_p np, cam_ccb_p ccb, int timed_out)
+int sym_abort_scsiio(struct sym_hcb *np, struct scsi_cmnd *ccb, int timed_out)
 {
 	ccb_p cp;
 	SYM_QUEHEAD *qp;
@@ -5480,7 +5411,7 @@ int sym_abort_scsiio(hcb_p np, cam_ccb_p
  *  SCRATCHA is assumed to have been loaded with STARTPOS 
  *  before the SCRIPTS called the C code.
  */
-void sym_complete_error (hcb_p np, ccb_p cp)
+void sym_complete_error (struct sym_hcb *np, ccb_p cp)
 {
 	tcb_p tp;
 	lcb_p lp;
@@ -5614,11 +5545,11 @@ finish:
  *  The SCRIPTS processor is running while we are 
  *  completing successful commands.
  */
-void sym_complete_ok (hcb_p np, ccb_p cp)
+void sym_complete_ok (struct sym_hcb *np, ccb_p cp)
 {
 	tcb_p tp;
 	lcb_p lp;
-	cam_ccb_p ccb;
+	struct scsi_cmnd *ccb;
 	int resid;
 
 	/*
@@ -5724,7 +5655,7 @@ if (resid)
 /*
  *  Soft-attach the controller.
  */
-int sym_hcb_attach(hcb_p np, struct sym_fw *fw, struct sym_nvram *nvram)
+int sym_hcb_attach(struct sym_hcb *np, struct sym_fw *fw, struct sym_nvram *nvram)
 {
 	int i;
 
@@ -5815,17 +5746,9 @@ int sym_hcb_attach(hcb_p np, struct sym_
 	sym_que_init(&np->comp_ccbq);
 
 	/*
-	 *  Initializations for optional handling 
-	 *  of IO timeouts and device queueing.
+	 *  Initialization for optional handling 
+	 *  of device queueing.
 	 */
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-	sym_que_init(&np->tmo0_ccbq);
-	np->tmo_ccbq =
-		sym_calloc(2*SYM_CONF_TIMEOUT_ORDER_MAX*sizeof(SYM_QUEHEAD),
-			   "TMO_CCBQ");
-	for (i = 0 ; i < 2*SYM_CONF_TIMEOUT_ORDER_MAX ; i++)
-		sym_que_init(&np->tmo_ccbq[i]);
-#endif
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 	sym_que_init(&np->dummy_ccbq);
 #endif
@@ -5957,7 +5880,7 @@ attach_failed:
 /*
  *  Free everything that has been allocated for this device.
  */
-void sym_hcb_free(hcb_p np)
+void sym_hcb_free(struct sym_hcb *np)
 {
 	SYM_QUEHEAD *qp;
 	ccb_p cp;
@@ -5971,12 +5894,6 @@ void sym_hcb_free(hcb_p np)
 		sym_mfree_dma(np->scriptb0, np->scriptb_sz, "SCRIPTB0");
 	if (np->scripta0)
 		sym_mfree_dma(np->scripta0, np->scripta_sz, "SCRIPTA0");
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-	if (np->tmo_ccbq)
-		sym_mfree(np->tmo_ccbq,
-			  2*SYM_CONF_TIMEOUT_ORDER_MAX*sizeof(SYM_QUEHEAD),
-			  "TMO_CCBQ");
-#endif
 	if (np->squeue)
 		sym_mfree_dma(np->squeue, sizeof(u32)*(MAX_QUEUE*2), "SQUEUE");
 	if (np->dqueue)
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h	2004-12-26 14:03:11.000000000 -0700
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h	2004-12-24 16:40:03.000000000 -0700
@@ -749,7 +749,7 @@ struct sym_ccb {
 	/*
 	 *  Pointer to CAM ccb and related stuff.
 	 */
-	cam_ccb_p cam_ccb;	/* CAM scsiio ccb		*/
+	struct scsi_cmnd *cam_ccb;	/* CAM scsiio ccb		*/
 	u8	cdb_buf[16];	/* Copy of CDB			*/
 	u8	*sns_bbuf;	/* Bounce buffer for sense data	*/
 #ifndef	SYM_SNS_BBUF_LEN
@@ -796,10 +796,6 @@ struct sym_ccb {
 	/*
 	 *  Other fields.
 	 */
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-	SYM_QUEHEAD tmo_linkq;	/* Optional timeout handling	*/
-	u_int	tmo_clock;	/* (link and dealine value)	*/
-#endif
 	u32	ccb_ba;		/* BUS address of this CCB	*/
 	u_short	tag;		/* Tag for this transfer	*/
 				/*  NO_TAG means no tag		*/
@@ -946,8 +942,8 @@ struct sym_hcb {
 	struct sym_fwa_ba fwa_bas;	/* Useful SCRIPTA bus addresses	*/
 	struct sym_fwb_ba fwb_bas;	/* Useful SCRIPTB bus addresses	*/
 	struct sym_fwz_ba fwz_bas;	/* Useful SCRIPTZ bus addresses	*/
-	void		(*fw_setup)(hcb_p np, struct sym_fw *fw);
-	void		(*fw_patch)(hcb_p np);
+	void		(*fw_setup)(struct sym_hcb *np, struct sym_fw *fw);
+	void		(*fw_patch)(struct sym_hcb *np);
 	char		*fw_name;
 
 	/*
@@ -1025,15 +1021,6 @@ struct sym_hcb {
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 	SYM_QUEHEAD	dummy_ccbq;
 #endif
-	/*
-	 *  Optional handling of IO timeouts.
-	 */
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-	SYM_QUEHEAD tmo0_ccbq;
-	SYM_QUEHEAD *tmo_ccbq;	/* [2*SYM_TIMEOUT_ORDER_MAX] */
-	u_int	tmo_clock;
-	u_int	tmo_actq;
-#endif
 
 	/*
 	 *  IMMEDIATE ARBITRATION (IARB) control.
@@ -1082,54 +1069,39 @@ struct sym_hcb {
  *  FIRMWARES (sym_fw.c)
  */
 struct sym_fw * sym_find_firmware(struct sym_pci_chip *chip);
-void sym_fw_bind_script (hcb_p np, u32 *start, int len);
+void sym_fw_bind_script (struct sym_hcb *np, u32 *start, int len);
 
 /*
  *  Driver methods called from O/S specific code.
  */
 char *sym_driver_name(void);
 void sym_print_xerr(ccb_p cp, int x_status);
-int sym_reset_scsi_bus(hcb_p np, int enab_int);
+int sym_reset_scsi_bus(struct sym_hcb *np, int enab_int);
 struct sym_pci_chip *
 sym_lookup_pci_chip_table (u_short device_id, u_char revision);
-void sym_put_start_queue(hcb_p np, ccb_p cp);
+void sym_put_start_queue(struct sym_hcb *np, ccb_p cp);
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-void sym_start_next_ccbs(hcb_p np, lcb_p lp, int maxn);
+void sym_start_next_ccbs(struct sym_hcb *np, lcb_p lp, int maxn);
 #endif
-void sym_start_up (hcb_p np, int reason);
-void sym_interrupt (hcb_p np);
-void sym_flush_comp_queue(hcb_p np, int cam_status);
-int sym_clear_tasks(hcb_p np, int cam_status, int target, int lun, int task);
-ccb_p sym_get_ccb (hcb_p np, u_char tn, u_char ln, u_char tag_order);
-void sym_free_ccb (hcb_p np, ccb_p cp);
-lcb_p sym_alloc_lcb (hcb_p np, u_char tn, u_char ln);
-int sym_queue_scsiio(hcb_p np, cam_scsiio_p csio, ccb_p cp);
-int sym_abort_scsiio(hcb_p np, cam_ccb_p ccb, int timed_out);
-int sym_abort_ccb(hcb_p np, ccb_p cp, int timed_out);
-int sym_reset_scsi_target(hcb_p np, int target);
-void sym_hcb_free(hcb_p np);
-int sym_hcb_attach(hcb_p np, struct sym_fw *fw, struct sym_nvram *nvram);
-
-/*
- *  Optionnaly, the driver may handle IO timeouts.
- */
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-int sym_abort_ccb(hcb_p np, ccb_p cp, int timed_out);
-void sym_timeout_ccb(hcb_p np, ccb_p cp, u_int ticks);
-static void __inline sym_untimeout_ccb(hcb_p np, ccb_p cp)
-{
-	sym_remque(&cp->tmo_linkq);
-	sym_insque_head(&cp->tmo_linkq, &np->tmo0_ccbq);
-}
-void sym_clock(hcb_p np);
-#endif	/* SYM_OPT_HANDLE_IO_TIMEOUT */
+void sym_start_up (struct sym_hcb *np, int reason);
+void sym_interrupt (struct sym_hcb *np);
+int sym_clear_tasks(struct sym_hcb *np, int cam_status, int target, int lun, int task);
+ccb_p sym_get_ccb (struct sym_hcb *np, u_char tn, u_char ln, u_char tag_order);
+void sym_free_ccb (struct sym_hcb *np, ccb_p cp);
+lcb_p sym_alloc_lcb (struct sym_hcb *np, u_char tn, u_char ln);
+int sym_queue_scsiio(struct sym_hcb *np, struct scsi_cmnd *csio, ccb_p cp);
+int sym_abort_scsiio(struct sym_hcb *np, struct scsi_cmnd *ccb, int timed_out);
+int sym_abort_ccb(struct sym_hcb *np, ccb_p cp, int timed_out);
+int sym_reset_scsi_target(struct sym_hcb *np, int target);
+void sym_hcb_free(struct sym_hcb *np);
+int sym_hcb_attach(struct sym_hcb *np, struct sym_fw *fw, struct sym_nvram *nvram);
 
 /*
  *  Optionnaly, the driver may provide a function
  *  to announce transfer rate changes.
  */
 #ifdef	SYM_OPT_ANNOUNCE_TRANSFER_RATE
-void sym_announce_transfer_rate(hcb_p np, int target);
+void sym_announce_transfer_rate(struct sym_hcb *np, int target);
 #endif
 
 /*
@@ -1153,9 +1125,9 @@ do {									\
 	(data)->size = cpu_to_scr((((badd) >> 8) & 0xff000000) + len);	\
 } while (0)
 #elif SYM_CONF_DMA_ADDRESSING_MODE == 2
-int sym_lookup_dmap(hcb_p np, u32 h, int s);
+int sym_lookup_dmap(struct sym_hcb *np, u32 h, int s);
 static __inline void 
-sym_build_sge(hcb_p np, struct sym_tblmove *data, u64 badd, int len)
+sym_build_sge(struct sym_hcb *np, struct sym_tblmove *data, u64 badd, int len)
 {
 	u32 h = (badd>>32);
 	int s = (h&SYM_DMAP_MASK);
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_malloc.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_malloc.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_malloc.c	2004-12-26 14:03:11.000000000 -0700
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_malloc.c	2004-12-24 16:40:03.000000000 -0700
@@ -170,7 +170,7 @@ static void *__sym_calloc2(m_pool_p mp, 
 	}
 
 	if (p)
-		bzero(p, size);
+		memset(p, 0, size);
 	else if (uflags & SYM_MEM_WARN)
 		printf ("__sym_calloc2: failed to allocate %s[%d]\n", name, size);
 	return p;
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c	2004-12-26 14:03:11.000000000 -0700
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c	2004-12-24 16:40:03.000000000 -0700
@@ -37,109 +37,13 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#ifdef __FreeBSD__
-#include <dev/sym/sym_glue.h>
-#else
 #include "sym_glue.h"
-#endif
-
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-/*
- *  Optional CCB timeout handling.
- *
- *  This code is useful for O/Ses that allow or expect 
- *  SIMs (low-level drivers) to handle SCSI IO timeouts.
- *  It uses a power-of-two based algorithm of my own:) 
- *  that avoids scanning of lists, provided that:
- *
- *  - The IO does complete in less than half the associated
- *    timeout value.
- *  - The greatest delay between the queuing of the IO and 
- *    its completion is less than 
- *          (1<<(SYM_CONF_TIMEOUT_ORDER_MAX-1))/2 ticks.
- *
- *  For example, if tick is 1 second and the max order is 8,
- *  any IO that is completed within less than 64 seconds will 
- *  just be put into some list at queuing and be removed 
- *  at completion without any additionnal overhead.
- */
-
-/*
- *  Set a timeout condition on a CCB.
- */ 
-void sym_timeout_ccb(hcb_p np, ccb_p cp, u_int ticks)
-{
-	sym_remque(&cp->tmo_linkq);
-	cp->tmo_clock = np->tmo_clock + ticks;
-	if (!ticks) {
-		sym_insque_head(&cp->tmo_linkq, &np->tmo0_ccbq);
-	}
-	else {
-		int i = SYM_CONF_TIMEOUT_ORDER_MAX - 1;
-		while (i > 0) {
-			if (ticks >= (1<<(i+1)))
-				break;
-			--i;
-		}
-		if (!(np->tmo_actq & (1<<i)))
-			i += SYM_CONF_TIMEOUT_ORDER_MAX;
-		sym_insque_head(&cp->tmo_linkq, &np->tmo_ccbq[i]);
-	}
-}
-
-/*
- *  Walk a list of CCB and handle timeout conditions.
- *  Should never be called in normal situations.
- */
-static void sym_walk_ccb_tmo_list(hcb_p np, SYM_QUEHEAD *tmoq)
-{
-	SYM_QUEHEAD qtmp, *qp;
-	ccb_p cp;
-
-	sym_que_move(tmoq, &qtmp);
-	while ((qp = sym_remque_head(&qtmp)) != 0) {
-		sym_insque_head(qp, &np->tmo0_ccbq);
-		cp = sym_que_entry(qp, struct sym_ccb, tmo_linkq);
-		if (cp->tmo_clock     != np->tmo_clock &&
-		    cp->tmo_clock + 1 != np->tmo_clock)
-			sym_timeout_ccb(np, cp, cp->tmo_clock - np->tmo_clock);
-		else
-			sym_abort_ccb(np, cp, 1);
-	}
-}
-
-/*
- * Our clock handler called from the O/S specific side.
- */
-void sym_clock(hcb_p np)
-{
-	int i, j;
-	u_int tmp;
-
-	tmp = np->tmo_clock;
-	tmp ^= (++np->tmo_clock);
-
-	for (i = 0; i < SYM_CONF_TIMEOUT_ORDER_MAX; i++, tmp >>= 1) {
-		if (!(tmp & 1))
-			continue;
-		j = i;
-		if (np->tmo_actq & (1<<i))
-			j += SYM_CONF_TIMEOUT_ORDER_MAX;
-
-		if (!sym_que_empty(&np->tmo_ccbq[j])) {
-			sym_walk_ccb_tmo_list(np, &np->tmo_ccbq[j]);
-		}
-		np->tmo_actq ^= (1<<i);
-	}
-}
-#endif	/* SYM_OPT_HANDLE_IO_TIMEOUT */
-
 
 #ifdef	SYM_OPT_ANNOUNCE_TRANSFER_RATE
 /*
  *  Announce transfer rate if anything changed since last announcement.
  */
-void sym_announce_transfer_rate(hcb_p np, int target)
+void sym_announce_transfer_rate(struct sym_hcb *np, int target)
 {
 	tcb_p tp = &np->target[target];
 
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c	2004-12-26 14:03:11.000000000 -0700
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c	2004-12-24 16:40:03.000000000 -0700
@@ -68,6 +68,21 @@ void sym_nvram_setup_host(struct sym_hcb
 	case SYM_TEKRAM_NVRAM:
 		np->myaddr = nvram->data.Tekram.host_id & 0x0f;
 		break;
+#ifdef CONFIG_PARISC
+	case SYM_PARISC_PDC:
+		if (nvram->data.parisc.host_id != -1)
+			np->myaddr = nvram->data.parisc.host_id;
+		if (nvram->data.parisc.factor != -1)
+			np->minsync = nvram->data.parisc.factor;
+		if (nvram->data.parisc.width != -1)
+			np->maxwide = nvram->data.parisc.width;
+		switch (nvram->data.parisc.mode) {
+			case 0: np->scsi_mode = SMODE_SE; break;
+			case 1: np->scsi_mode = SMODE_HVD; break;
+			case 2: np->scsi_mode = SMODE_LVD; break;
+			default: break;
+		}
+#endif
 	default:
 		break;
 	}
@@ -702,6 +717,28 @@ static int sym_read_Tekram_nvram (struct
 	return 0;
 }
 
+#ifdef CONFIG_PARISC
+/*
+ * Host firmware (PDC) keeps a table for altering SCSI capabilities.
+ * Many newer machines export one channel of 53c896 chip as SE, 50-pin HD.
+ * Also used for Multi-initiator SCSI clusters to set the SCSI Initiator ID.
+ */
+static int sym_read_parisc_pdc(struct sym_device *np, struct pdc_initiator *pdc)
+{
+	struct hardware_path hwpath;
+	get_pci_node_path(np->pdev, &hwpath);
+	if (!pdc_get_initiator(&hwpath, pdc))
+		return 0;
+
+	return SYM_PARISC_PDC;
+}
+#else
+static int sym_read_parisc_pdc(struct sym_device *np, struct pdc_initiator *x)
+{
+	return 0;
+}
+#endif
+
 /*
  *  Try reading Symbios or Tekram NVRAM
  */
@@ -714,7 +751,7 @@ int sym_read_nvram(struct sym_device *np
 		nvp->type = SYM_TEKRAM_NVRAM;
 		sym_display_Tekram_nvram(np, &nvp->data.Tekram);
 	} else {
-		nvp->type = 0;
+		nvp->type = sym_read_parisc_pdc(np, &nvp->data.parisc);
 	}
 	return nvp->type;
 }
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.h	2004-12-26 14:03:11.000000000 -0700
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.h	2004-12-24 16:40:03.000000000 -0700
@@ -171,6 +171,10 @@ struct Tekram_nvram {
 typedef struct Tekram_nvram	Tekram_nvram;
 typedef struct Tekram_target	Tekram_target;
 
+#ifndef CONFIG_PARISC
+struct pdc_initiator { int dummy; };
+#endif
+
 /*
  *  Union of supported NVRAM formats.
  */
@@ -178,10 +182,12 @@ struct sym_nvram {
 	int type;
 #define	SYM_SYMBIOS_NVRAM	(1)
 #define	SYM_TEKRAM_NVRAM	(2)
+#define SYM_PARISC_PDC		(3)
 #if SYM_CONF_NVRAM_SUPPORT
 	union {
 		Symbios_nvram Symbios;
 		Tekram_nvram Tekram;
+		struct pdc_initiator parisc;
 	} data;
 #endif
 };

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
