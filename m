From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 9/17] sym53c8xx: Remove ->device_id
Date: Fri,  5 Oct 2007 15:55:06 -0400
Message-ID: <11916141153365-git-send-email-matthew@wil.cx>
References: <11916141143747-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:54619 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761117AbXJETzV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:55:21 -0400
In-Reply-To: <11916141143747-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

Following the same path as ->revision_id, remove ->device_id

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/sym53c8xx_2/sym_fw.c    |    4 ++--
 drivers/scsi/sym53c8xx_2/sym_glue.c  |    4 +---
 drivers/scsi/sym53c8xx_2/sym_glue.h  |    1 -
 drivers/scsi/sym53c8xx_2/sym_hipd.c  |   16 ++++++++--------
 drivers/scsi/sym53c8xx_2/sym_hipd.h  |    1 -
 drivers/scsi/sym53c8xx_2/sym_nvram.c |    2 +-
 6 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_fw.c b/drivers/scsi/sym53c8xx_2/sym_fw.c
index 2be0ae1..3d4db80 100644
--- a/drivers/scsi/sym53c8xx_2/sym_fw.c
+++ b/drivers/scsi/sym53c8xx_2/sym_fw.c
@@ -205,13 +205,13 @@ sym_fw2_patch(struct sym_hcb *np)
 	 *  Remove a couple of work-arounds specific to C1010 if 
 	 *  they are not desirable. See `sym_fw2.h' for more details.
 	 */
-	if (!(np->device_id == PCI_DEVICE_ID_LSI_53C1010_66 &&
+	if (!(np->s.device->device == PCI_DEVICE_ID_LSI_53C1010_66 &&
 	      np->s.device->revision < 0x1 &&
 	      np->pciclk_khz < 60000)) {
 		scripta0->datao_phase[0] = cpu_to_scr(SCR_NO_OP);
 		scripta0->datao_phase[1] = cpu_to_scr(0);
 	}
-	if (!(np->device_id == PCI_DEVICE_ID_LSI_53C1010_33 /* &&
+	if (!(np->s.device->device == PCI_DEVICE_ID_LSI_53C1010_33 /* &&
 	      np->s.device->revision < 0xff */)) {
 		scripta0->sel_done[0] = cpu_to_scr(SCR_NO_OP);
 		scripta0->sel_done[1] = cpu_to_scr(0);
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index ef707a4..357903f 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1255,7 +1255,7 @@ static int sym_host_info(struct sym_hcb *np, char *ptr, off_t offset, int len)
 
 	copy_info(&info, "Chip " NAME53C "%s, device id 0x%x, "
 			 "revision id 0x%x\n", np->s.chip_name,
-			 np->device_id, np->s.device->revision);
+			 np->s.device->device, np->s.device->revision);
 	copy_info(&info, "At PCI address %s, IRQ " IRQ_FMT "\n",
 		pci_name(np->s.device), IRQ_PRM(np->s.device->irq));
 	copy_info(&info, "Min. period factor %d, %s SCSI BUS%s\n",
@@ -1410,7 +1410,6 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	np->verbose	= sym_driver_setup.verbose;
 	np->s.device	= pdev;
 	np->s.unit	= unit;
-	np->device_id	= dev->chip.device_id;
 	np->features	= dev->chip.features;
 	np->clock_divn	= dev->chip.nr_divisor;
 	np->maxoffs	= dev->chip.offset_max;
@@ -1528,7 +1527,6 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 static void __devinit sym_get_nvram(struct sym_device *devp, struct sym_nvram *nvp)
 {
 	devp->nvram = nvp;
-	devp->device_id = devp->chip.device_id;
 	nvp->type = 0;
 
 	sym_read_nvram(devp, nvp);
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
index d5ba5aa..b961f70 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -212,7 +212,6 @@ struct sym_device {
 	} s;
 	struct sym_chip chip;
 	struct sym_nvram *nvram;
-	u_short device_id;
 	u_char host_id;
 };
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 9f4198c..5443394 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -804,7 +804,7 @@ static int sym_prepare_setting(struct Scsi_Host *shost, struct sym_hcb *np, stru
 	 *  In dual channel mode, contention occurs if internal cycles
 	 *  are used. Disable internal cycles.
 	 */
-	if (np->device_id == PCI_DEVICE_ID_LSI_53C1010_33 &&
+	if (np->s.device->device == PCI_DEVICE_ID_LSI_53C1010_33 &&
 	    np->s.device->revision < 0x1)
 		np->rv_ccntl0	|=  DILS;
 
@@ -828,9 +828,9 @@ static int sym_prepare_setting(struct Scsi_Host *shost, struct sym_hcb *np, stru
 	 *  this driver. The generic ncr driver that does not use 
 	 *  LOAD/STORE instructions does not need this work-around.
 	 */
-	if ((np->device_id == PCI_DEVICE_ID_NCR_53C810 &&
+	if ((np->s.device->device == PCI_DEVICE_ID_NCR_53C810 &&
 	     np->s.device->revision >= 0x10 && np->s.device->revision <= 0x11) ||
-	    (np->device_id == PCI_DEVICE_ID_NCR_53C860 &&
+	    (np->s.device->device == PCI_DEVICE_ID_NCR_53C860 &&
 	     np->s.device->revision <= 0x1))
 		np->features &= ~(FE_WRIE|FE_ERL|FE_ERMP);
 
@@ -897,7 +897,7 @@ static int sym_prepare_setting(struct Scsi_Host *shost, struct sym_hcb *np, stru
 	if ((SYM_SETUP_SCSI_LED || 
 	     (nvram->type == SYM_SYMBIOS_NVRAM ||
 	      (nvram->type == SYM_TEKRAM_NVRAM &&
-	       np->device_id == PCI_DEVICE_ID_NCR_53C895))) &&
+	       np->s.device->device == PCI_DEVICE_ID_NCR_53C895))) &&
 	    !(np->features & FE_LEDC) && !(np->sv_gpcntl & 0x01))
 		np->features |= FE_LED0;
 
@@ -1798,7 +1798,7 @@ void sym_start_up (struct sym_hcb *np, int reason)
 	/*
 	 *  For now, disable AIP generation on C1010-66.
 	 */
-	if (np->device_id == PCI_DEVICE_ID_LSI_53C1010_66)
+	if (np->s.device->device == PCI_DEVICE_ID_LSI_53C1010_66)
 		OUTB(np, nc_aipcntl1, DISAIP);
 
 	/*
@@ -1808,7 +1808,7 @@ void sym_start_up (struct sym_hcb *np, int reason)
 	 *  that from SCRIPTS for each selection/reselection, but 
 	 *  I just don't want. :)
 	 */
-	if (np->device_id == PCI_DEVICE_ID_LSI_53C1010_33 &&
+	if (np->s.device->device == PCI_DEVICE_ID_LSI_53C1010_33 &&
 	    np->s.device->revision < 1)
 		OUTB(np, nc_stest1, INB(np, nc_stest1) | 0x30);
 
@@ -1817,9 +1817,9 @@ void sym_start_up (struct sym_hcb *np, int reason)
 	 *  Disable overlapped arbitration for some dual function devices, 
 	 *  regardless revision id (kind of post-chip-design feature. ;-))
 	 */
-	if (np->device_id == PCI_DEVICE_ID_NCR_53C875)
+	if (np->s.device->device == PCI_DEVICE_ID_NCR_53C875)
 		OUTB(np, nc_ctest0, (1<<5));
-	else if (np->device_id == PCI_DEVICE_ID_NCR_53C896)
+	else if (np->s.device->device == PCI_DEVICE_ID_NCR_53C896)
 		np->rv_ccntl0 |= DPR;
 
 	/*
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 3aa8060..b8908e1 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -918,7 +918,6 @@ struct sym_hcb {
 	/*
 	 *  General controller parameters and configuration.
 	 */
-	u_short	device_id;	/* PCI device id		*/
 	u_int	features;	/* Chip features map		*/
 	u_char	myaddr;		/* SCSI id of the adapter	*/
 	u_char	maxburst;	/* log base 2 of dwords burst	*/
diff --git a/drivers/scsi/sym53c8xx_2/sym_nvram.c b/drivers/scsi/sym53c8xx_2/sym_nvram.c
index 15d6929..5662fbb 100644
--- a/drivers/scsi/sym53c8xx_2/sym_nvram.c
+++ b/drivers/scsi/sym53c8xx_2/sym_nvram.c
@@ -696,7 +696,7 @@ static int sym_read_Tekram_nvram (struct sym_device *np, Tekram_nvram *nvram)
 	u_short	csum;
 	int x;
 
-	switch (np->device_id) {
+	switch (np->pdev->device) {
 	case PCI_DEVICE_ID_NCR_53C885:
 	case PCI_DEVICE_ID_NCR_53C895:
 	case PCI_DEVICE_ID_NCR_53C896:
-- 
1.4.4.2

