From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] sym 2.1.18j
Date: Sun, 4 Apr 2004 17:08:16 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040404160816.GT16469@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:18844 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262031AbUDDQIR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Apr 2004 12:08:17 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.22)
	id 1BAAAS-0005yz-PV
	for linux-scsi@vger.kernel.org; Sun, 04 Apr 2004 17:08:16 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


sym 2.1.18j:
 - Add SPI transport attributes (James Bottomley)
 - Use generic code to do Domain Validation (James Bottomley)
 - Stop using scsi_to_pci_dma_dir() (Christoph Hellwig)
 - Change some constants to their symbolic names (Grant Grundler)
 - Handle a race between a postponed command completing and the EH retrying
   it (James Bottomley)
 - If the auto request sense fails, issue a device reset (James Bottomley)

diff -urpNX dontdiff linus-2.6/drivers/scsi/Kconfig parisc-2.6/drivers/scsi/Kconfig
--- linus-2.6/drivers/scsi/Kconfig	Sun Apr  4 09:39:11 2004
+++ parisc-2.6/drivers/scsi/Kconfig	Sun Apr  4 09:24:09 2004
@@ -908,6 +908,7 @@ config 53C700_LE_ON_BE
 config SCSI_SYM53C8XX_2
 	tristate "SYM53C8XX Version 2 SCSI support"
 	depends on PCI && SCSI
+	select SCSI_SPI_ATTRS
 	---help---
 	  This driver supports the whole NCR53C8XX/SYM53C8XX family of
 	  PCI-SCSI controllers.  It also supports the subset of LSI53C10XX
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c	Sun Apr  4 09:39:17 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c	Sun Apr  4 09:24:14 2004
@@ -57,6 +57,10 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
 
 #include "sym_glue.h"
 #include "sym_nvram.h"
@@ -87,6 +91,8 @@ pci_get_base_address(struct pci_dev *pde
 /* This lock protects only the memory allocation/free.  */
 spinlock_t sym53c8xx_lock = SPIN_LOCK_UNLOCKED;
 
+static struct scsi_transport_template *sym2_transport_template = NULL;
+
 /*
  *  Wrappers to the generic memory allocator.
  */
@@ -171,7 +177,7 @@ struct sym_ucmd {		/* Override the SCSI 
 
 static void __unmap_scsi_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
 {
-	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
+	int dma_dir = cmd->sc_data_direction;
 
 	switch(SYM_UCMD_PTR(cmd)->data_mapped) {
 	case 2:
@@ -188,7 +194,7 @@ static void __unmap_scsi_data(struct pci
 static dma_addr_t __map_scsi_single_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
 {
 	dma_addr_t mapping;
-	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
+	int dma_dir = cmd->sc_data_direction;
 
 	mapping = pci_map_single(pdev, cmd->request_buffer,
 				 cmd->request_bufflen, dma_dir);
@@ -203,7 +209,7 @@ static dma_addr_t __map_scsi_single_data
 static int __map_scsi_sg_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
 {
 	int use_sg;
-	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
+	int dma_dir = cmd->sc_data_direction;
 
 	use_sg = pci_map_sg(pdev, cmd->buffer, cmd->use_sg, dma_dir);
 	if (use_sg > 0) {
@@ -216,7 +222,7 @@ static int __map_scsi_sg_data(struct pci
 
 static void __sync_scsi_data_for_cpu(struct pci_dev *pdev, struct scsi_cmnd *cmd)
 {
-	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
+	int dma_dir = cmd->sc_data_direction;
 
 	switch(SYM_UCMD_PTR(cmd)->data_mapped) {
 	case 2:
@@ -231,7 +237,7 @@ static void __sync_scsi_data_for_cpu(str
 
 static void __sync_scsi_data_for_device(struct pci_dev *pdev, struct scsi_cmnd *cmd)
 {
-	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
+	int dma_dir = cmd->sc_data_direction;
 
 	switch(SYM_UCMD_PTR(cmd)->data_mapped) {
 	case 2:
@@ -378,6 +384,13 @@ void sym_set_cam_result_error(struct sym
 			}
 #endif
 		} else {
+			/*
+			 * Error return from our internal request sense.  This
+			 * is bad: we must clear the contingent allegiance
+			 * condition otherwise the device will always return
+			 * BUSY.  Use a big stick.
+			 */
+			sym_reset_scsi_target(np, csio->device->id);
 			cam_status = DID_ERROR;
 		}
 	} else if (cp->host_status == HS_COMPLETE) 	/* Bad SCSI status */
@@ -594,7 +607,7 @@ int sym_setup_data_and_start(struct sym_
 	 *  No direction means no data.
 	 */
 	dir = csio->sc_data_direction;
-	if (dir != SCSI_DATA_NONE) {
+	if (dir != DMA_NONE) {
 		cp->segments = sym_scatter(np, cp, csio);
 		if (cp->segments < 0) {
 			if (cp->segments == -2)
@@ -918,7 +931,6 @@ prepare:
 	switch(to_do) {
 	default:
 	case SYM_EH_DO_IGNORE:
-		goto finish;
 		break;
 	case SYM_EH_DO_WAIT:
 		init_MUTEX_LOCKED(&ep->sem);
@@ -958,7 +970,6 @@ prepare:
 		to_do = SYM_EH_DO_IGNORE;
 	}
 
-finish:
 	ep->to_do = to_do;
 	/* Complete the command with locks held as required by the driver */
 	if (to_do == SYM_EH_DO_COMPLETE)
@@ -1152,6 +1163,8 @@ static int sym53c8xx_slave_configure(str
 	lp->s.scdev_depth = depth_to_use;
 	sym_tune_dev_queuing(np, device->id, device->lun, reqtags);
 
+	spi_dv_device(device);
+
 	return 0;
 }
 
@@ -1837,6 +1850,8 @@ static struct Scsi_Host * __devinit sym_
 	instance->can_queue	= (SYM_CONF_MAX_START-2);
 	instance->sg_tablesize	= SYM_CONF_MAX_SG;
 	instance->max_cmd_len	= 16;
+	BUG_ON(sym2_transport_template == NULL);
+	instance->transportt	= sym2_transport_template;
 
 	spin_unlock_irqrestore(instance->host_lock, flags);
 
@@ -2355,6 +2370,120 @@ static void __devexit sym2_remove(struct
 	attach_count--;
 }
 
+static void sym2_get_offset(struct scsi_device *sdev)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	spi_offset(sdev) = tp->tinfo.curr.offset;
+}
+
+static void sym2_set_offset(struct scsi_device *sdev, int offset)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	if (tp->tinfo.curr.options & PPR_OPT_DT) {
+		if (offset > np->maxoffs_dt)
+			offset = np->maxoffs_dt;
+	} else {
+		if (offset > np->maxoffs)
+			offset = np->maxoffs;
+	}
+	tp->tinfo.goal.offset = offset;
+}
+
+
+static void sym2_get_period(struct scsi_device *sdev)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	spi_period(sdev) = tp->tinfo.curr.period;
+}
+
+static void sym2_set_period(struct scsi_device *sdev, int period)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	if (period <= 9 && np->minsync_dt) {
+		if (period < np->minsync_dt)
+			period = np->minsync_dt;
+		tp->tinfo.goal.options = PPR_OPT_DT;
+		tp->tinfo.goal.period = period;
+		if (!tp->tinfo.curr.offset ||
+					tp->tinfo.curr.offset > np->maxoffs_dt)
+			tp->tinfo.goal.offset = np->maxoffs_dt;
+	} else {
+		if (period < np->minsync)
+			period = np->minsync;
+		tp->tinfo.goal.options = 0;
+		tp->tinfo.goal.period = period;
+		if (!tp->tinfo.curr.offset ||
+					tp->tinfo.curr.offset > np->maxoffs)
+			tp->tinfo.goal.offset = np->maxoffs;
+	}
+}
+
+static void sym2_get_width(struct scsi_device *sdev)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	spi_width(sdev) = tp->tinfo.curr.width ? 1 : 0;
+}
+
+static void sym2_set_width(struct scsi_device *sdev, int width)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	tp->tinfo.goal.width = width;
+}
+
+static void sym2_get_dt(struct scsi_device *sdev)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	spi_dt(sdev) = (tp->tinfo.curr.options & PPR_OPT_DT) ? 1 : 0;
+}
+
+static void sym2_set_dt(struct scsi_device *sdev, int dt)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	if (!dt) {
+		/* if clearing DT, then we may need to reduce the
+		 * period and the offset */
+		if (tp->tinfo.curr.period < np->minsync)
+			tp->tinfo.goal.period = np->minsync;
+		if (tp->tinfo.curr.offset > np->maxoffs)
+			tp->tinfo.goal.offset = np->maxoffs;
+		tp->tinfo.goal.options &= ~PPR_OPT_DT;
+	} else {
+		tp->tinfo.goal.options |= PPR_OPT_DT;
+	}
+}
+	
+
+static struct spi_function_template sym2_transport_functions = {
+	.set_offset	= sym2_set_offset,
+	.get_offset	= sym2_get_offset,
+	.show_offset	= 1,
+	.set_period	= sym2_set_period,
+	.get_period	= sym2_get_period,
+	.show_period	= 1,
+	.set_width	= sym2_set_width,
+	.get_width	= sym2_get_width,
+	.show_width	= 1,
+	.get_dt		= sym2_get_dt,
+	.set_dt		= sym2_set_dt,
+	.show_dt	= 1,
+};
+
 static struct pci_device_id sym2_id_table[] __devinitdata = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C810,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
@@ -2404,6 +2531,10 @@ static struct pci_driver sym2_driver = {
 
 static int __init sym2_init(void)
 {
+	sym2_transport_template = spi_attach_transport(&sym2_transport_functions);
+	if (!sym2_transport_template)
+		return -ENODEV;
+
 	pci_register_driver(&sym2_driver);
 	return 0;
 }
@@ -2411,6 +2542,7 @@ static int __init sym2_init(void)
 static void __exit sym2_exit(void)
 {
 	pci_unregister_driver(&sym2_driver);
+	spi_release_transport(sym2_transport_template);
 }
 
 module_init(sym2_init);
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	Sun Apr  4 09:39:17 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	Sun Apr  4 09:24:14 2004
@@ -66,9 +66,10 @@
 #  include <asm/irq.h>
 #endif
 
+#include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
-#include "../scsi.h"		/* XXX: DID_* */
 
 #ifndef bzero
 #define bzero(d, n)	memset((d), 0, (n))
@@ -341,18 +342,12 @@ typedef struct scsi_cmnd *cam_scsiio_p;/
 #define	CAM_RESRC_UNAVAIL	DID_ERROR
 
 /*
- *  Remap SCSI data direction values.
+ *  Remap data direction values.
  */
-#ifndef	SCSI_DATA_UNKNOWN
-#define	SCSI_DATA_UNKNOWN	0
-#define	SCSI_DATA_WRITE		1
-#define	SCSI_DATA_READ		2
-#define	SCSI_DATA_NONE		3
-#endif
-#define CAM_DIR_NONE		SCSI_DATA_NONE
-#define CAM_DIR_IN		SCSI_DATA_READ
-#define CAM_DIR_OUT		SCSI_DATA_WRITE
-#define CAM_DIR_UNKNOWN		SCSI_DATA_UNKNOWN
+#define CAM_DIR_NONE		DMA_NONE
+#define CAM_DIR_IN		DMA_FROM_DEVICE
+#define CAM_DIR_OUT		DMA_TO_DEVICE
+#define CAM_DIR_UNKNOWN		DMA_BIDIRECTIONAL
 
 /*
  *  These ones are used as return code from 
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	Sun Apr  4 09:39:17 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	Sun Apr  4 09:24:14 2004
@@ -50,7 +50,8 @@
  * SUCH DAMAGE.
  */
 
-#define SYM_DRIVER_NAME	"sym-2.1.18i"
+#define SYM_VERSION "2.1.18j"
+#define SYM_DRIVER_NAME	"sym-" SYM_VERSION
 
 #include "sym_glue.h"
 #include "sym_nvram.h"
@@ -3183,7 +3184,7 @@ static void sym_sir_bad_scsi_status(hcb_
 		/*
 		 *  patch requested size into sense command
 		 */
-		cp->sensecmd[0]		= 0x03;
+		cp->sensecmd[0]		= REQUEST_SENSE;
 		cp->sensecmd[1]		= 0;
 		if (tp->tinfo.curr.scsi_version <= 2 && cp->lun <= 7)
 			cp->sensecmd[1]	= cp->lun << 5;
@@ -5693,7 +5694,7 @@ if (resid)
 	 *  On standard INQUIRY response (EVPD and CmDt 
 	 *  not set), sniff out device capabilities.
 	 */
-	if (cp->cdb_buf[0] == 0x12 && !(cp->cdb_buf[1] & 0x3))
+	if (cp->cdb_buf[0] == INQUIRY && !(cp->cdb_buf[1] & 0x3))
 		sym_sniff_inquiry(np, cp->cam_ccb, resid);
 #endif
 

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
