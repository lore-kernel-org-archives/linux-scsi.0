From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 11/17] advansys: Remove library version & serial numbers
Date: Sun, 16 Sep 2007 09:37:42 -0600
Message-ID: <11899570694075-git-send-email-matthew@wil.cx>
References: <1189867145.3339.3.camel@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:53198 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbXIPPhm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Sep 2007 11:37:42 -0400
In-Reply-To: <1189867145.3339.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

With the ASC and ADV libraries merged into the driver, there really is
no point in reporting their version numbers, or even trying to maintain
them.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   60 +++++++++++-----------------------------------
 1 files changed, 15 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index e09ab95..530765f 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -77,10 +77,6 @@
 /* Enable driver tracing. */
 /* #define ADVANSYS_DEBUG */
 
-#define ASC_LIB_VERSION_MAJOR  1
-#define ASC_LIB_VERSION_MINOR  24
-#define ASC_LIB_SERIAL_NUMBER  123
-
 /*
  * Portable Data Types
  *
@@ -554,8 +550,6 @@ typedef struct asc_dvc_cfg {
 	uchar isa_dma_speed;
 	uchar isa_dma_channel;
 	uchar chip_version;
-	ushort lib_serial_no;
-	ushort lib_version;
 	ushort mcode_date;
 	ushort mcode_version;
 	uchar max_tag_qng[ASC_MAX_TID + 1];
@@ -958,13 +952,6 @@ typedef struct asc_mc_saved {
 #define AscReadChipDvcID(port)            (uchar)inp((port)+IOP_REG_ID)
 #define AscWriteChipDvcID(port, data)     outp((port)+IOP_REG_ID, data)
 
-#define ADV_LIB_VERSION_MAJOR  5
-#define ADV_LIB_VERSION_MINOR  14
-
-/*
- * Define Adv Library required special types.
- */
-
 /*
  * Portable Data Types
  *
@@ -1856,7 +1843,6 @@ typedef struct adv_dvc_cfg {
 	ushort disc_enable;	/* enable disconnection */
 	uchar chip_version;	/* chip version */
 	uchar termination;	/* Term. Ctrl. bits 6-5 of SCSI_CFG1 register */
-	ushort lib_version;	/* Adv Library version number */
 	ushort control_flag;	/* Microcode Control Flag */
 	ushort mcode_date;	/* Microcode date */
 	ushort mcode_version;	/* Microcode version */
@@ -2637,18 +2623,13 @@ static void asc_prt_asc_dvc_cfg(ASC_DVC_CFG *h)
 	printk(" disc_enable 0x%x, sdtr_enable 0x%x,\n",
 	       h->disc_enable, h->sdtr_enable);
 
-	printk
-	    (" chip_scsi_id %d, isa_dma_speed %d, isa_dma_channel %d, chip_version %d,\n",
-	     h->chip_scsi_id, h->isa_dma_speed, h->isa_dma_channel,
-	     h->chip_version);
-
-	printk
-	    (" pci_device_id %d, lib_serial_no %u, lib_version %u, mcode_date 0x%x,\n",
-	     to_pci_dev(h->dev)->device, h->lib_serial_no, h->lib_version,
-	     h->mcode_date);
+	printk(" chip_scsi_id %d, isa_dma_speed %d, isa_dma_channel %d, "
+		"chip_version %d,\n", h->chip_scsi_id, h->isa_dma_speed,
+		h->isa_dma_channel, h->chip_version);
 
-	printk(" mcode_version %d, overrun_buf 0x%lx\n",
-	       h->mcode_version, (ulong)h->overrun_buf);
+	printk(" pci_device_id %d, mcode_date 0x%x, mcode_version %d, "
+		"overrun_buf 0x%p\n", to_pci_dev(h->dev)->device,
+		h->mcode_date, h->mcode_version, h->overrun_buf);
 }
 
 /*
@@ -2752,8 +2733,8 @@ static void asc_prt_adv_dvc_cfg(ADV_DVC_CFG *h)
 	printk("  chip_version 0x%x, mcode_date 0x%x\n",
 	       h->chip_version, h->mcode_date);
 
-	printk("  mcode_version 0x%x, pci_device_id 0x%x, lib_version %u\n",
-	       h->mcode_version, to_pci_dev(h->dev)->device, h->lib_version);
+	printk("  mcode_version 0x%x, pci_device_id 0x%x\n",
+	       h->mcode_version, to_pci_dev(h->dev)->device);
 
 	printk("  control_flag 0x%x\n", h->control_flag);
 }
@@ -3731,15 +3712,10 @@ static int asc_prt_asc_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 			   shost->host_no);
 	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen,
-			   " chip_version %u, lib_version 0x%x, lib_serial_no %u, mcode_date 0x%x\n",
-			   c->chip_version, c->lib_version, c->lib_serial_no,
-			   c->mcode_date);
-	ASC_PRT_NEXT();
-
-	len = asc_prt_line(cp, leftlen,
-			   " mcode_version 0x%x, err_code %u\n",
-			   c->mcode_version, v->err_code);
+	len = asc_prt_line(cp, leftlen, " chip_version %u, mcode_date 0x%x, "
+			   "mcode_version 0x%x, err_code %u\n",
+			   c->chip_version, c->mcode_date, c->mcode_version,
+			   v->err_code);
 	ASC_PRT_NEXT();
 
 	/* Current number of commands waiting for the host. */
@@ -3934,10 +3910,9 @@ static int asc_prt_adv_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 			   v->err_code);
 	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen,
-			   " chip_version %u, lib_version 0x%x, mcode_date 0x%x, mcode_version 0x%x\n",
-			   c->chip_version, c->lib_version, c->mcode_date,
-			   c->mcode_version);
+	len = asc_prt_line(cp, leftlen, " chip_version %u, mcode_date 0x%x, "
+			   "mcode_version 0x%x\n", c->chip_version,
+			   c->mcode_date, c->mcode_version);
 	ASC_PRT_NEXT();
 
 	AdvReadWordLram(iop_base, ASC_MC_TAGQNG_ABLE, tagqng_able);
@@ -11566,9 +11541,6 @@ static ushort __devinit AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 	asc_dvc->cfg->sdtr_enable = ASC_SCSI_WIDTH_BIT_SET;
 	asc_dvc->cfg->disc_enable = ASC_SCSI_WIDTH_BIT_SET;
 	asc_dvc->cfg->chip_scsi_id = ASC_DEF_CHIP_SCSI_ID;
-	asc_dvc->cfg->lib_serial_no = ASC_LIB_SERIAL_NUMBER;
-	asc_dvc->cfg->lib_version = (ASC_LIB_VERSION_MAJOR << 8) |
-	    ASC_LIB_VERSION_MINOR;
 	chip_version = AscGetChipVersion(iop_base, asc_dvc->bus_type);
 	asc_dvc->cfg->chip_version = chip_version;
 	asc_dvc->sdtr_period_tbl[0] = SYN_XFER_NS_0;
@@ -13542,8 +13514,6 @@ AdvInitGetConfig(struct pci_dev *pdev, struct asc_board *boardp)
 	if ((cmd & PCI_COMMAND_PARITY) == 0)
 		asc_dvc->cfg->control_flag |= CONTROL_FLAG_IGNORE_PERR;
 
-	asc_dvc->cfg->lib_version = (ADV_LIB_VERSION_MAJOR << 8) |
-	    ADV_LIB_VERSION_MINOR;
 	asc_dvc->cfg->chip_version =
 	    AdvGetChipVersion(iop_base, asc_dvc->bus_type);
 
-- 
1.5.2.4

