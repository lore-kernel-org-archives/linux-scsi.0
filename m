From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 15/17] sym53c8xx: Make interrupt handler capable of returning IRQ_NONE
Date: Fri,  5 Oct 2007 15:55:12 -0400
Message-ID: <11916141153280-git-send-email-matthew@wil.cx>
References: <11916141143747-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:54635 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761144AbXJETzV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:55:21 -0400
In-Reply-To: <11916141143747-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

Make sym_interrupt return an irqreturn_t instead of void, and take a
Scsi_Host instead of a sym_hcb.  Pass the Scsi_Host to the interrupt
handler instead of the sym_hcb.  Rename the host_data to sym_data.
Keep a pci_dev pointer in the sym_data.  Rename the Scsi_Host from
instance to shost.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c |  107 +++++++++++++++++------------------
 drivers/scsi/sym53c8xx_2/sym_glue.h |    6 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   16 +++--
 drivers/scsi/sym53c8xx_2/sym_hipd.h |    2 +-
 4 files changed, 66 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index a82ed13..e515485 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -39,7 +39,6 @@
  */
 #include <linux/ctype.h>
 #include <linux/init.h>
-#include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/spinlock.h>
@@ -549,21 +548,23 @@ static int sym53c8xx_queue_command(struct scsi_cmnd *cmd,
  */
 static irqreturn_t sym53c8xx_intr(int irq, void *dev_id)
 {
-	struct sym_hcb *np = dev_id;
+	struct Scsi_Host *shost = dev_id;
+	struct sym_data *sym_data = shost_priv(shost);
+	irqreturn_t result;
 
 	/* Avoid spinloop trying to handle interrupts on frozen device */
-	if (pci_channel_offline(np->s.device))
+	if (pci_channel_offline(sym_data->pdev))
 		return IRQ_NONE;
 
 	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("[");
 
-	spin_lock(np->s.host->host_lock);
-	sym_interrupt(np);
-	spin_unlock(np->s.host->host_lock);
+	spin_lock(shost->host_lock);
+	result = sym_interrupt(shost);
+	spin_unlock(shost->host_lock);
 
 	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("]\n");
 
-	return IRQ_HANDLED;
+	return result;
 }
 
 /*
@@ -613,22 +614,19 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 	 */
 #define WAIT_FOR_PCI_RECOVERY	35
 	if (pci_channel_offline(pdev)) {
-		struct host_data *hostdata = shost_priv(host);
+		struct sym_data *sym_data = shost_priv(host);
 		struct completion *io_reset;
 		int finished_reset = 0;
 		init_completion(&eh_done);
 		spin_lock_irq(host->host_lock);
 		/* Make sure we didn't race */
 		if (pci_channel_offline(pdev)) {
-			if (!hostdata->io_reset)
-				hostdata->io_reset = &eh_done;
-			io_reset = hostdata->io_reset;
+			if (!sym_data->io_reset)
+				sym_data->io_reset = &eh_done;
+			io_reset = sym_data->io_reset;
 		} else {
-			io_reset = NULL;
-		}
-
-		if (!pci_channel_offline(pdev))
 			finished_reset = 1;
+		}
 		spin_unlock_irq(host->host_lock);
 		if (!finished_reset)
 			finished_reset = wait_for_completion_timeout(io_reset,
@@ -1273,9 +1271,9 @@ static void sym_free_resources(struct sym_hcb *np, struct pci_dev *pdev)
 static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 		int unit, struct sym_device *dev)
 {
-	struct host_data *host_data;
+	struct sym_data *sym_data;
 	struct sym_hcb *np = NULL;
-	struct Scsi_Host *instance = NULL;
+	struct Scsi_Host *shost;
 	struct pci_dev *pdev = dev->pdev;
 	unsigned long flags;
 	struct sym_fw *fw;
@@ -1289,15 +1287,12 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	 */
 	fw = sym_find_firmware(&dev->chip);
 	if (!fw)
-		goto attach_failed;
+		return NULL;
 
-	/*
-	 *	Allocate host_data structure
-	 */
-	instance = scsi_host_alloc(tpnt, sizeof(*host_data));
-	if (!instance)
-		goto attach_failed;
-	host_data = (struct host_data *) instance->hostdata;
+	shost = scsi_host_alloc(tpnt, sizeof(*sym_data));
+	if (!shost)
+		return NULL;
+	sym_data = shost_priv(shost);
 
 	/*
 	 *  Allocate immediately the host control block, 
@@ -1310,8 +1305,9 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 		goto attach_failed;
 	np->s.device = pdev;
 	np->bus_dmat = &pdev->dev; /* Result in 1 DMA pool per HBA */
-	host_data->ncb = np;
-	np->s.host = instance;
+	sym_data->ncb = np;
+	sym_data->pdev = pdev;
+	np->s.host = shost;
 
 	pci_set_drvdata(pdev, np);
 
@@ -1358,7 +1354,7 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	if (dev->ram_base)
 		np->ram_ba = (u32)dev->ram_base;
 
-	if (sym_hcb_attach(instance, fw, dev->nvram))
+	if (sym_hcb_attach(shost, fw, dev->nvram))
 		goto attach_failed;
 
 	/*
@@ -1366,7 +1362,8 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	 *  If we synchonize the C code with SCRIPTS on interrupt, 
 	 *  we do not want to share the INTR line at all.
 	 */
-	if (request_irq(pdev->irq, sym53c8xx_intr, IRQF_SHARED, NAME53C8XX, np)) {
+	if (request_irq(pdev->irq, sym53c8xx_intr, IRQF_SHARED, NAME53C8XX,
+								shost)) {
 		printf_err("%s: request irq %d failure\n",
 			sym_name(np), pdev->irq);
 		goto attach_failed;
@@ -1376,7 +1373,7 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	 *  After SCSI devices have been opened, we cannot
 	 *  reset the bus safely, so we do it here.
 	 */
-	spin_lock_irqsave(instance->host_lock, flags);
+	spin_lock_irqsave(shost->host_lock, flags);
 	if (sym_reset_scsi_bus(np, 0))
 		goto reset_failed;
 
@@ -1398,37 +1395,37 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	 *  Fill Linux host instance structure
 	 *  and return success.
 	 */
-	instance->max_channel	= 0;
-	instance->this_id	= np->myaddr;
-	instance->max_id	= np->maxwide ? 16 : 8;
-	instance->max_lun	= SYM_CONF_MAX_LUN;
-	instance->unique_id	= pci_resource_start(pdev, 0);
-	instance->cmd_per_lun	= SYM_CONF_MAX_TAG;
-	instance->can_queue	= (SYM_CONF_MAX_START-2);
-	instance->sg_tablesize	= SYM_CONF_MAX_SG;
-	instance->max_cmd_len	= 16;
+	shost->max_channel	= 0;
+	shost->this_id		= np->myaddr;
+	shost->max_id		= np->maxwide ? 16 : 8;
+	shost->max_lun		= SYM_CONF_MAX_LUN;
+	shost->unique_id	= pci_resource_start(pdev, 0);
+	shost->cmd_per_lun	= SYM_CONF_MAX_TAG;
+	shost->can_queue	= (SYM_CONF_MAX_START-2);
+	shost->sg_tablesize	= SYM_CONF_MAX_SG;
+	shost->max_cmd_len	= 16;
 	BUG_ON(sym2_transport_template == NULL);
-	instance->transportt	= sym2_transport_template;
+	shost->transportt	= sym2_transport_template;
 
 	/* 53c896 rev 1 errata: DMA may not cross 16MB boundary */
 	if (pdev->device == PCI_DEVICE_ID_NCR_53C896 && pdev->revision < 2)
-		instance->dma_boundary = 0xFFFFFF;
+		shost->dma_boundary = 0xFFFFFF;
 
-	spin_unlock_irqrestore(instance->host_lock, flags);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	return instance;
+	return shost;
 
  reset_failed:
 	printf_err("%s: FATAL ERROR: CHECK SCSI BUS - CABLES, "
 		   "TERMINATION, DEVICE POWER etc.!\n", sym_name(np));
-	spin_unlock_irqrestore(instance->host_lock, flags);
+	spin_unlock_irqrestore(shost->host_lock, flags);
  attach_failed:
-	if (!instance)
+	if (!shost)
 		return NULL;
 	printf_info("%s: giving up ...\n", sym_name(np));
 	if (np)
 		sym_free_resources(np, pdev);
-	scsi_host_put(instance);
+	scsi_host_put(shost);
 
 	return NULL;
  }
@@ -1701,7 +1698,7 @@ static int __devinit sym2_probe(struct pci_dev *pdev,
 {
 	struct sym_device sym_dev;
 	struct sym_nvram nvram;
-	struct Scsi_Host *instance;
+	struct Scsi_Host *shost;
 
 	memset(&sym_dev, 0, sizeof(sym_dev));
 	memset(&nvram, 0, sizeof(nvram));
@@ -1728,13 +1725,13 @@ static int __devinit sym2_probe(struct pci_dev *pdev,
 
 	sym_get_nvram(&sym_dev, &nvram);
 
-	instance = sym_attach(&sym2_template, attach_count, &sym_dev);
-	if (!instance)
+	shost = sym_attach(&sym2_template, attach_count, &sym_dev);
+	if (!shost)
 		goto free;
 
-	if (scsi_add_host(instance, &pdev->dev))
+	if (scsi_add_host(shost, &pdev->dev))
 		goto detach;
-	scsi_scan_host(instance);
+	scsi_scan_host(shost);
 
 	attach_count++;
 
@@ -1883,12 +1880,12 @@ static void sym2_io_resume(struct pci_dev *pdev)
 {
 	struct sym_hcb *np = pci_get_drvdata(pdev);
 	struct Scsi_Host *shost = np->s.host;
-	struct host_data *hostdata = shost_priv(shost);
+	struct sym_data *sym_data = shost_priv(shost);
 
 	spin_lock_irq(shost->host_lock);
-	if (hostdata->io_reset)
-		complete_all(hostdata->io_reset);
-	hostdata->io_reset = NULL;
+	if (sym_data->io_reset)
+		complete_all(sym_data->io_reset);
+	sym_data->io_reset = NULL;
 	spin_unlock_irq(shost->host_lock);
 }
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
index ab2de1c..98261a5 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -42,6 +42,7 @@
 
 #include <linux/completion.h>
 #include <linux/delay.h>
+#include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
 #include <linux/string.h>
@@ -217,14 +218,15 @@ struct sym_device {
 /*
  *  Driver host data structure.
  */
-struct host_data {
+struct sym_data {
 	struct sym_hcb *ncb;
 	struct completion *io_reset;		/* PCI error handling */
+	struct pci_dev *pdev;
 };
 
 static inline struct sym_hcb * sym_get_hcb(struct Scsi_Host *host)
 {
-	return ((struct host_data *)host->hostdata)->ncb;
+	return ((struct sym_data *)host->hostdata)->ncb;
 }
 
 #include "sym_fw.h"
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 13fd5b2..5d2079f 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -2760,8 +2760,9 @@ reset_all:
  *  Use at your own decision and risk.
  */
 
-void sym_interrupt (struct sym_hcb *np)
+irqreturn_t sym_interrupt(struct Scsi_Host *shost)
 {
+	struct sym_hcb *np = sym_get_hcb(shost);
 	u_char	istat, istatc;
 	u_char	dstat;
 	u_short	sist;
@@ -2786,7 +2787,7 @@ void sym_interrupt (struct sym_hcb *np)
 	}
 
 	if (!(istat & (SIP|DIP)))
-		return;
+		return (istat & INTF) ? IRQ_HANDLED : IRQ_NONE;
 
 #if 0	/* We should never get this one */
 	if (istat & CABRT)
@@ -2818,7 +2819,7 @@ void sym_interrupt (struct sym_hcb *np)
 		 * never clear. */
 		if (unlikely(sist == 0xffff && dstat == 0xff)) {
 			if (pci_channel_offline(np->s.device))
-				return;
+				return IRQ_NONE;
 		}
 	} while (istatc & (SIP|DIP));
 
@@ -2856,7 +2857,7 @@ void sym_interrupt (struct sym_hcb *np)
 		else if (dstat & SIR)	sym_int_sir(np);
 		else if (dstat & SSI)	OUTONB_STD();
 		else			goto unknown_int;
-		return;
+		return IRQ_HANDLED;
 	}
 
 	/*
@@ -2873,7 +2874,7 @@ void sym_interrupt (struct sym_hcb *np)
 	if (sist & RST) {
 		printf("%s: SCSI BUS reset detected.\n", sym_name(np));
 		sym_start_up (np, 1);
-		return;
+		return IRQ_HANDLED;
 	}
 
 	OUTB(np, nc_ctest3, np->rv_ctest3 | CLF);	/* clear dma fifo  */
@@ -2885,7 +2886,7 @@ void sym_interrupt (struct sym_hcb *np)
 		else if (sist & STO)	sym_int_sto (np);
 		else if (sist & UDC)	sym_int_udc (np);
 		else			goto unknown_int;
-		return;
+		return IRQ_HANDLED;
 	}
 
 	/*
@@ -2900,7 +2901,7 @@ void sym_interrupt (struct sym_hcb *np)
 	if ((sist & (GEN|HTH|SGE)) ||
 		(dstat & (MDPE|BF|ABRT|IID))) {
 		sym_start_reset(np);
-		return;
+		return IRQ_HANDLED;
 	}
 
 unknown_int:
@@ -2911,6 +2912,7 @@ unknown_int:
 	printf(	"%s: unknown interrupt(s) ignored, "
 		"ISTAT=0x%x DSTAT=0x%x SIST=0x%x\n",
 		sym_name(np), istat, dstat, sist);
+	return IRQ_NONE;
 }
 
 /*
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 4354571..a9c0866 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -1056,7 +1056,7 @@ void sym_start_next_ccbs(struct sym_hcb *np, struct sym_lcb *lp, int maxn);
 void sym_put_start_queue(struct sym_hcb *np, struct sym_ccb *cp);
 #endif
 void sym_start_up(struct sym_hcb *np, int reason);
-void sym_interrupt(struct sym_hcb *np);
+irqreturn_t sym_interrupt(struct Scsi_Host *);
 int sym_clear_tasks(struct sym_hcb *np, int cam_status, int target, int lun, int task);
 struct sym_ccb *sym_get_ccb(struct sym_hcb *np, struct scsi_cmnd *cmd, u_char tag_order);
 void sym_free_ccb(struct sym_hcb *np, struct sym_ccb *cp);
-- 
1.4.4.2

