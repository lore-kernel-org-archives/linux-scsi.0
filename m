From: Christoph Hellwig <hch@infradead.org>
Subject: Re: InitIO SCSI: Volunteers required
Date: Sun, 22 Apr 2007 15:14:24 +0100
Message-ID: <20070422141423.GA8928@infradead.org>
References: <20070420103849.7358f1f1@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33893 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030891AbXDVOO1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Apr 2007 10:14:27 -0400
Content-Disposition: inline
In-Reply-To: <20070420103849.7358f1f1@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, rene@exactcode.de, todorovic.s@googlemail.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 10:38:49AM +0100, Alan Cox wrote:
> I'm looking for some testers for a revamp of the initio driver. No real
> code changes other than to hopefully stop it exploding on load on 64bit,
> but a major reorganisation, commenting and "de-windowsification" so the
> code is actually readable and I can do the pci_find_device to
> pci_get_device transitions.

Once again a pci_get_device conversation isn't all that helpfull at all.
fortunately in this case I've done a patch to convert this driver to
proper pci probing in 2004, and I've attached the forward-ported version
below now that we've actually found some testers that weren't locatable
back then..

This doesn't change much outside the initialization and irq code, so
any additional de-crappyfication will hopefully apply ontop.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/initio.c
===================================================================
--- linux-2.6.orig/drivers/scsi/initio.c	2007-04-22 15:06:10.000000000 +0200
+++ linux-2.6/drivers/scsi/initio.c	2007-04-22 15:10:17.000000000 +0200
@@ -3,6 +3,7 @@
  *
  * Copyright (c) 1994-1998 Initio Corporation
  * Copyright (c) 1998 Bas Vermeulen <bvermeul@blackstar.xs4all.nl>
+ * Copyright (c) 2004 Christoph Hellwig <hch@lst.de>
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -137,60 +138,17 @@
 #include "initio.h"
 
 #define SENSE_SIZE		14
-
 #define i91u_MAXQUEUE		2
-#define i91u_REVID "Initio INI-9X00U/UW SCSI device driver; Revision: 1.04a"
 
-#define I950_DEVICE_ID	0x9500	/* Initio's inic-950 product ID   */
-#define I940_DEVICE_ID	0x9400	/* Initio's inic-940 product ID   */
-#define I935_DEVICE_ID	0x9401	/* Initio's inic-935 product ID   */
-#define I920_DEVICE_ID	0x0002	/* Initio's other product ID      */
+#define DEBUG_QUEUE		0
+#define DEBUG_STATE		0
 
 #ifdef DEBUG_i91u
 static unsigned int i91u_debug = DEBUG_DEFAULT;
-#endif
-
-#define TUL_RDWORD(x,y)         (short)(inl((int)((ULONG)((ULONG)x+(UCHAR)y)) ))
-
-typedef struct PCI_ID_Struc {
-	unsigned short vendor_id;
-	unsigned short device_id;
-} PCI_ID;
-
-static int tul_num_ch = 4;	/* Maximum 4 adapters           */
-static int tul_num_scb;
-static int tul_tag_enable = 1;
-static SCB *tul_scb;
-
-#ifdef DEBUG_i91u
 static int setup_debug = 0;
 #endif
 
 static void i91uSCBPost(BYTE * pHcb, BYTE * pScb);
-
-/* PCI Devices supported by this driver */
-static struct pci_device_id i91u_pci_devices[] = {
-	{ PCI_VENDOR_ID_INIT,  I950_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_INIT,  I940_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_INIT,  I935_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_INIT,  I920_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_DOMEX, I920_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ }
-};
-MODULE_DEVICE_TABLE(pci, i91u_pci_devices);
-
-#define DEBUG_INTERRUPT 0
-#define DEBUG_QUEUE     0
-#define DEBUG_STATE     0
-#define INT_DISC	0
-
-/*--- external functions --*/
-static void tul_se2_wait(void);
-
-/*--- forward refrence ---*/
-static SCB *tul_find_busy_scb(HCS * pCurHcb, WORD tarlun);
-static SCB *tul_find_done_scb(HCS * pCurHcb);
-
 static int tulip_main(HCS * pCurHcb);
 
 static int tul_next_state(HCS * pCurHcb);
@@ -239,16 +197,11 @@ static int tul_se2_rd_all(WORD CurBase);
 static void tul_se2_update_all(WORD CurBase);	/* setup default pattern */
 static void tul_read_eeprom(WORD CurBase);
 
-				/* ---- INTERNAL VARIABLES ---- */
-static HCS tul_hcs[MAX_SUPPORTED_ADAPTERS];
-static INI_ADPT_STRUCT i91u_adpt[MAX_SUPPORTED_ADAPTERS];
-
 /*NVRAM nvram, *nvramp = &nvram; */
 static NVRAM i91unvram;
 static NVRAM *i91unvramp;
 
 
-
 static UCHAR i91udftNvRam[64] =
 {
 /*----------- header -----------*/
@@ -582,52 +535,6 @@ void tul_read_eeprom(WORD CurBase)
 	TUL_WR(CurBase + TUL_GCTRL, gctrl & ~TUL_GCTRL_EEPROM_BIT);
 }				/* read_eeprom */
 
-static int Addi91u_into_Adapter_table(WORD wBIOS, WORD wBASE, BYTE bInterrupt,
-				      BYTE bBus, BYTE bDevice)
-{
-	int i, j;
-
-	for (i = 0; i < MAX_SUPPORTED_ADAPTERS; i++) {
-		if (i91u_adpt[i].ADPT_BIOS < wBIOS)
-			continue;
-		if (i91u_adpt[i].ADPT_BIOS == wBIOS) {
-			if (i91u_adpt[i].ADPT_BASE == wBASE) {
-				if (i91u_adpt[i].ADPT_Bus != 0xFF)
-					return 1;
-			} else if (i91u_adpt[i].ADPT_BASE < wBASE)
-					continue;
-		}
-		for (j = MAX_SUPPORTED_ADAPTERS - 1; j > i; j--) {
-			i91u_adpt[j].ADPT_BASE = i91u_adpt[j - 1].ADPT_BASE;
-			i91u_adpt[j].ADPT_INTR = i91u_adpt[j - 1].ADPT_INTR;
-			i91u_adpt[j].ADPT_BIOS = i91u_adpt[j - 1].ADPT_BIOS;
-			i91u_adpt[j].ADPT_Bus = i91u_adpt[j - 1].ADPT_Bus;
-			i91u_adpt[j].ADPT_Device = i91u_adpt[j - 1].ADPT_Device;
-		}
-		i91u_adpt[i].ADPT_BASE = wBASE;
-		i91u_adpt[i].ADPT_INTR = bInterrupt;
-		i91u_adpt[i].ADPT_BIOS = wBIOS;
-		i91u_adpt[i].ADPT_Bus = bBus;
-		i91u_adpt[i].ADPT_Device = bDevice;
-		return 0;
-	}
-	return 1;
-}
-
-static void init_i91uAdapter_table(void)
-{
-	int i;
-
-	for (i = 0; i < MAX_SUPPORTED_ADAPTERS; i++) {	/* Initialize adapter structure */
-		i91u_adpt[i].ADPT_BIOS = 0xffff;
-		i91u_adpt[i].ADPT_BASE = 0xffff;
-		i91u_adpt[i].ADPT_INTR = 0xff;
-		i91u_adpt[i].ADPT_Bus = 0xff;
-		i91u_adpt[i].ADPT_Device = 0xff;
-	}
-	return;
-}
-
 static void tul_stop_bm(HCS * pCurHcb)
 {
 
@@ -640,15 +547,6 @@ static void tul_stop_bm(HCS * pCurHcb)
 }
 
 /***************************************************************************/
-static void get_tulipPCIConfig(HCS * pCurHcb, int ch_idx)
-{
-	pCurHcb->HCS_Base = i91u_adpt[ch_idx].ADPT_BASE;	/* Supply base address  */
-	pCurHcb->HCS_BIOS = i91u_adpt[ch_idx].ADPT_BIOS;	/* Supply BIOS address  */
-	pCurHcb->HCS_Intr = i91u_adpt[ch_idx].ADPT_INTR;	/* Supply interrupt line */
-	return;
-}
-
-/***************************************************************************/
 static int tul_reset_scsi(HCS * pCurHcb, int seconds)
 {
 	TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_RST_BUS);
@@ -667,41 +565,11 @@ static int tul_reset_scsi(HCS * pCurHcb,
 	return (SCSI_RESET_SUCCESS);
 }
 
-/***************************************************************************/
-static int init_tulip(HCS * pCurHcb, SCB * scbp, int tul_num_scb,
-		      BYTE * pbBiosAdr, int seconds)
+static void init_tulip(HCS *pCurHcb, BYTE *pbBiosAdr)
 {
 	int i;
 	BYTE *pwFlags;
 	BYTE *pbHeads;
-	SCB *pTmpScb, *pPrevScb = NULL;
-
-	pCurHcb->HCS_NumScbs = tul_num_scb;
-	pCurHcb->HCS_Semaph = 1;
-	spin_lock_init(&pCurHcb->HCS_SemaphLock);
-	pCurHcb->HCS_JSStatus0 = 0;
-	pCurHcb->HCS_Scb = scbp;
-	pCurHcb->HCS_NxtPend = scbp;
-	pCurHcb->HCS_NxtAvail = scbp;
-	for (i = 0, pTmpScb = scbp; i < tul_num_scb; i++, pTmpScb++) {
-		pTmpScb->SCB_TagId = i;
-		if (i != 0)
-			pPrevScb->SCB_NxtScb = pTmpScb;
-		pPrevScb = pTmpScb;
-	}
-	pPrevScb->SCB_NxtScb = NULL;
-	pCurHcb->HCS_ScbEnd = pTmpScb;
-	pCurHcb->HCS_FirstAvail = scbp;
-	pCurHcb->HCS_LastAvail = pPrevScb;
-	spin_lock_init(&pCurHcb->HCS_AvailLock);
-	pCurHcb->HCS_FirstPend = NULL;
-	pCurHcb->HCS_LastPend = NULL;
-	pCurHcb->HCS_FirstBusy = NULL;
-	pCurHcb->HCS_LastBusy = NULL;
-	pCurHcb->HCS_FirstDone = NULL;
-	pCurHcb->HCS_LastDone = NULL;
-	pCurHcb->HCS_ActScb = NULL;
-	pCurHcb->HCS_ActTcs = NULL;
 
 	tul_read_eeprom(pCurHcb->HCS_Base);
 /*---------- get H/A configuration -------------*/
@@ -773,17 +641,13 @@ static int init_tulip(HCS * pCurHcb, SCB
 		pCurHcb->HCS_ActTags[i] = 0;
 		pCurHcb->HCS_MaxTags[i] = 0xFF;
 	}			/* for                          */
-	printk("i91u: PCI Base=0x%04X, IRQ=%d, BIOS=0x%04X0, SCSI ID=%d\n",
-	       pCurHcb->HCS_Base, pCurHcb->HCS_Intr,
-	       pCurHcb->HCS_BIOS, pCurHcb->HCS_SCSI_ID);
 /*------------------- reset SCSI Bus ---------------------------*/
 	if (pCurHcb->HCS_Config & HCC_SCSI_RESET) {
 		printk("i91u: Reset SCSI Bus ... \n");
-		tul_reset_scsi(pCurHcb, seconds);
+		tul_reset_scsi(pCurHcb, 10);
 	}
 	TUL_WR(pCurHcb->HCS_Base + TUL_SCFG1, 0x17);
 	TUL_WR(pCurHcb->HCS_Base + TUL_SIntEnable, 0xE9);
-	return (0);
 }
 
 /***************************************************************************/
@@ -1149,8 +1013,6 @@ static int tul_bad_seq(HCS * pCurHcb)
 {
 	SCB *pCurScb;
 
-	printk("tul_bad_seg c=%d\n", pCurHcb->HCS_Index);
-
 	if ((pCurScb = pCurHcb->HCS_ActScb) != NULL) {
 		tul_unlink_busy_scb(pCurHcb, pCurScb);
 		pCurScb->SCB_HaStat = HOST_BAD_PHAS;
@@ -1304,27 +1166,6 @@ static void tul_exec_scb(HCS * pCurHcb, 
 }
 
 /***************************************************************************/
-static int tul_isr(HCS * pCurHcb)
-{
-	/* Enter critical section       */
-
-	if (TUL_RD(pCurHcb->HCS_Base, TUL_Int) & TSS_INT_PENDING) {
-		if (pCurHcb->HCS_Semaph == 1) {
-			TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x1F);
-			/* Disable Tulip SCSI Int */
-			pCurHcb->HCS_Semaph = 0;
-
-			tulip_main(pCurHcb);
-
-			pCurHcb->HCS_Semaph = 1;
-			TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x0F);
-			return (1);
-		}
-	}
-	return (0);
-}
-
-/***************************************************************************/
 int tulip_main(HCS * pCurHcb)
 {
 	SCB *pCurScb;
@@ -2750,134 +2591,27 @@ int tul_wait_done_disc(HCS * pCurHcb)
 
 static irqreturn_t i91u_intr(int irqno, void *dev_id)
 {
-	struct Scsi_Host *dev = dev_id;
+	struct Scsi_Host *shost = dev_id;
+	HCS *pCurHcb = (HCS *)shost->hostdata;
 	unsigned long flags;
-	
-	spin_lock_irqsave(dev->host_lock, flags);
-	tul_isr((HCS *)dev->base);
-	spin_unlock_irqrestore(dev->host_lock, flags);
-	return IRQ_HANDLED;
-}
-
-static int tul_NewReturnNumberOfAdapters(void)
-{
-	struct pci_dev *pDev = NULL;	/* Start from none              */
-	int iAdapters = 0;
-	long dRegValue;
-	WORD wBIOS;
-	int i = 0;
 
-	init_i91uAdapter_table();
+	if (!TUL_RD(pCurHcb->HCS_Base, TUL_Int) & TSS_INT_PENDING)
+		return IRQ_NONE;
 
-	for (i = 0; i < ARRAY_SIZE(i91u_pci_devices); i++)
-	{
-		while ((pDev = pci_find_device(i91u_pci_devices[i].vendor, i91u_pci_devices[i].device, pDev)) != NULL) {
-			if (pci_enable_device(pDev))
-				continue;
-			pci_read_config_dword(pDev, 0x44, (u32 *) & dRegValue);
-			wBIOS = (UWORD) (dRegValue & 0xFF);
-			if (((dRegValue & 0xFF00) >> 8) == 0xFF)
-				dRegValue = 0;
-			wBIOS = (wBIOS << 8) + ((UWORD) ((dRegValue & 0xFF00) >> 8));
-			if (pci_set_dma_mask(pDev, DMA_32BIT_MASK)) {
-				printk(KERN_WARNING 
-				       "i91u: Could not set 32 bit DMA mask\n");
-				continue;
-			}
-
-			if (Addi91u_into_Adapter_table(wBIOS,
-							(pDev->resource[0].start),
-						       	pDev->irq,
-						       	pDev->bus->number,
-					       		(pDev->devfn >> 3)
-		    		) == 0)
-				iAdapters++;
-		}
-	}
-
-	return (iAdapters);
-}
-
-static int i91u_detect(struct scsi_host_template * tpnt)
-{
-	HCS *pHCB;
-	struct Scsi_Host *hreg;
-	unsigned long i;	/* 01/14/98                     */
-	int ok = 0, iAdapters;
-	ULONG dBiosAdr;
-	BYTE *pbBiosAdr;
-
-	/* Get total number of adapters in the motherboard */
-	iAdapters = tul_NewReturnNumberOfAdapters();
-	if (iAdapters == 0)	/* If no tulip founded, return */
-		return (0);
-
-	tul_num_ch = (iAdapters > tul_num_ch) ? tul_num_ch : iAdapters;
-	/* Update actually channel number */
-	if (tul_tag_enable) {	/* 1.01i                  */
-		tul_num_scb = MAX_TARGETS * i91u_MAXQUEUE;
-	} else {
-		tul_num_scb = MAX_TARGETS + 3;	/* 1-tape, 1-CD_ROM, 1- extra */
-	}			/* Update actually SCBs per adapter */
-
-	/* Get total memory needed for HCS */
-	i = tul_num_ch * sizeof(HCS);
-	memset((unsigned char *) &tul_hcs[0], 0, i);	/* Initialize tul_hcs 0 */
-	/* Get total memory needed for SCB */
-
-	for (; tul_num_scb >= MAX_TARGETS + 3; tul_num_scb--) {
-		i = tul_num_ch * tul_num_scb * sizeof(SCB);
-		if ((tul_scb = kmalloc(i, GFP_ATOMIC | GFP_DMA)) != NULL)
-			break;
-	}
-	if (tul_scb == NULL) {
-		printk("i91u: SCB memory allocation error\n");
-		return (0);
-	}
-	memset((unsigned char *) tul_scb, 0, i);
-
-	for (i = 0, pHCB = &tul_hcs[0];		/* Get pointer for control block */
-	     i < tul_num_ch;
-	     i++, pHCB++) {
-		get_tulipPCIConfig(pHCB, i);
-
-		dBiosAdr = pHCB->HCS_BIOS;
-		dBiosAdr = (dBiosAdr << 4);
-
-		pbBiosAdr = phys_to_virt(dBiosAdr);
-
-		init_tulip(pHCB, tul_scb + (i * tul_num_scb), tul_num_scb, pbBiosAdr, 10);
-		request_region(pHCB->HCS_Base, 256, "i91u"); /* Register */ 
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (pCurHcb->HCS_Semaph == 1) {
+		TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x1F);
+		/* Disable Tulip SCSI Int */
+		pCurHcb->HCS_Semaph = 0;
 
-		pHCB->HCS_Index = i;	/* 7/29/98 */
-		hreg = scsi_register(tpnt, sizeof(HCS));
-		if(hreg == NULL) {
-			release_region(pHCB->HCS_Base, 256);
-			return 0;
-		}
-		hreg->io_port = pHCB->HCS_Base;
-		hreg->n_io_port = 0xff;
-		hreg->can_queue = tul_num_scb;	/* 03/05/98                      */
-		hreg->unique_id = pHCB->HCS_Base;
-		hreg->max_id = pHCB->HCS_MaxTar;
-		hreg->max_lun = 32;	/* 10/21/97                     */
-		hreg->irq = pHCB->HCS_Intr;
-		hreg->this_id = pHCB->HCS_SCSI_ID;	/* Assign HCS index           */
-		hreg->base = (unsigned long)pHCB;
-		hreg->sg_tablesize = TOTAL_SG_ENTRY;	/* Maximun support is 32 */
+		tulip_main(pCurHcb);
 
-		/* Initial tulip chip           */
-		ok = request_irq(pHCB->HCS_Intr, i91u_intr, IRQF_DISABLED | IRQF_SHARED, "i91u", hreg);
-		if (ok < 0) {
-			printk(KERN_WARNING "i91u: unable to request IRQ %d\n\n", pHCB->HCS_Intr);
-			return 0;
-		}
+		pCurHcb->HCS_Semaph = 1;
+		TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x0F);
 	}
 
-	tpnt->this_id = -1;
-	tpnt->can_queue = 1;
-
-	return 1;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
 static void i91uBuildSCB(HCS * pHCB, SCB * pSCB, struct scsi_cmnd * SCpnt)
@@ -2951,8 +2685,8 @@ static void i91uBuildSCB(HCS * pHCB, SCB
 static int i91u_queuecommand(struct scsi_cmnd *cmd,
 		void (*done)(struct scsi_cmnd *))
 {
-	HCS *pHCB = (HCS *) cmd->device->host->base;
-	register SCB *pSCB;
+	HCS *pHCB = (HCS *)cmd->device->host->hostdata;
+	SCB *pSCB;
 
 	cmd->scsi_done = done;
 
@@ -2972,9 +2706,7 @@ static int i91u_queuecommand(struct scsi
  */
 static int i91u_abort(struct scsi_cmnd * SCpnt)
 {
-	HCS *pHCB;
-
-	pHCB = (HCS *) SCpnt->device->host->base;
+	HCS *pHCB = (HCS *) SCpnt->device->host->hostdata;
 	return tul_abort_srb(pHCB, SCpnt);
 }
 
@@ -2986,7 +2718,7 @@ static int i91u_reset(struct scsi_cmnd *
 {				/* I need Host Control Block Information */
 	HCS *pHCB;
 
-	pHCB = (HCS *) SCpnt->device->host->base;
+	pHCB = (HCS *) SCpnt->device->host->hostdata;
 
 	if (reset_flags & (SCSI_RESET_SUGGEST_BUS_RESET | SCSI_RESET_SUGGEST_HOST_RESET))
 		return tul_reset_scsi_bus(pHCB);
@@ -2997,9 +2729,7 @@ static int i91u_reset(struct scsi_cmnd *
 
 static int i91u_bus_reset(struct scsi_cmnd * SCpnt)
 {
-	HCS *pHCB;
-
-	pHCB = (HCS *) SCpnt->device->host->base;
+	HCS *pHCB = (HCS *) SCpnt->device->host->hostdata;
 
 	spin_lock_irq(SCpnt->device->host->host_lock);
 	tul_reset_scsi(pHCB, 0);
@@ -3014,11 +2744,8 @@ static int i91u_bus_reset(struct scsi_cm
 static int i91u_biosparam(struct scsi_device *sdev, struct block_device *dev,
 		sector_t capacity, int *info_array)
 {
-	HCS *pHcb;		/* Point to Host adapter control block */
-	TCS *pTcb;
-
-	pHcb = (HCS *) sdev->host->base;
-	pTcb = &pHcb->HCS_Tcs[sdev->id];
+	HCS *pHcb = (HCS *)sdev->host->hostdata;
+	TCS *pTcb = &pHcb->HCS_Tcs[sdev->id];
 
 	if (pTcb->TCS_DrvHead) {
 		info_array[0] = pTcb->TCS_DrvHead;
@@ -3143,32 +2870,179 @@ static void i91uSCBPost(BYTE * pHcb, BYT
 	tul_release_scb(pHCB, pSCB);	/* Release SCB for current channel */
 }
 
-/*
- * Release ressources
- */
-static int i91u_release(struct Scsi_Host *hreg)
+static struct scsi_host_template initio_template = {
+	.proc_name		= "INI9100U",
+	.name			= "Initio INI-9X00U/UW SCSI device driver",
+	.queuecommand		= i91u_queuecommand,
+	.eh_bus_reset_handler	= i91u_bus_reset,
+	.bios_param		= i91u_biosparam,
+	.can_queue		= MAX_TARGETS * i91u_MAXQUEUE,
+	.this_id		= 1,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= 1,
+	.use_clustering		= ENABLE_CLUSTERING,
+};
+
+static int __devinit initio_probe_one(struct pci_dev *pdev,
+		const struct pci_device_id *id)
 {
-	free_irq(hreg->irq, hreg);
-	release_region(hreg->io_port, 256);
+	struct Scsi_Host *shost;
+	HCS *pHCB;
+	SCB *pTmpScb, *pPrevScb = NULL, *scbp;
+	long dRegValue;
+	WORD wBIOS;
+	int error, i;
+
+	error = pci_enable_device(pdev);
+	if (error)
+		goto out;
+
+	pci_read_config_dword(pdev, 0x44, (u32 *) &dRegValue);
+	wBIOS = (UWORD) (dRegValue & 0xFF);
+	if (((dRegValue & 0xFF00) >> 8) == 0xFF)
+		dRegValue = 0;
+	wBIOS = (wBIOS << 8) + ((UWORD) ((dRegValue & 0xFF00) >> 8));
+
+	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+		printk(KERN_WARNING
+		       "initio: Could not set 32 bit DMA mask\n");
+		error = -ENODEV;
+		goto out_disable_device;
+	}
+
+	shost = scsi_host_alloc(&initio_template, sizeof(HCS));
+	if (!shost) {
+		printk(KERN_WARNING
+		       "initio: Could not allocate host structure.k\n");
+		error = -ENOMEM;
+		goto out_disable_device;
+	}
+
+	pHCB = (HCS *)shost->hostdata;
+	memset(pHCB, 0, sizeof(HCS));
+
+	pHCB->HCS_Base = pci_resource_start(pdev, 0);
+
+	if (!request_region(pHCB->HCS_Base, 256, "i91u")) {
+		printk(KERN_WARNING "initio: io port 0x%x, is busy.\n", pHCB->HCS_Base);
+		error = -ENODEV;
+		goto out_host_put;
+	}
+
+	pHCB->HCS_NumScbs = MAX_TARGETS * i91u_MAXQUEUE;
+
+	scbp = kmalloc(pHCB->HCS_NumScbs * sizeof(SCB), GFP_DMA);
+	if (!scbp) {
+		printk(KERN_WARNING "initio: cannot allocated SCB array.\n");
+		error = -ENOMEM;
+		goto out_release_region;
+	}
+	memset(scbp, 0, pHCB->HCS_NumScbs * sizeof(SCB));
+
+	pHCB->HCS_Semaph = 1;
+	spin_lock_init(&pHCB->HCS_SemaphLock);
+	pHCB->HCS_Scb = scbp;
+	pHCB->HCS_NxtPend = scbp;
+	pHCB->HCS_NxtAvail = scbp;
+	for (i = 0, pTmpScb = scbp; i < pHCB->HCS_NumScbs; i++, pTmpScb++) {
+		pTmpScb->SCB_TagId = i;
+		if (i != 0)
+			pPrevScb->SCB_NxtScb = pTmpScb;
+		pPrevScb = pTmpScb;
+	}
+	pHCB->HCS_ScbEnd = pTmpScb;
+	pHCB->HCS_FirstAvail = scbp;
+	pHCB->HCS_LastAvail = pPrevScb;
+	spin_lock_init(&pHCB->HCS_AvailLock);
+
+	init_tulip(pHCB, phys_to_virt(wBIOS << 4));
+
+	shost->io_port = pHCB->HCS_Base;
+	shost->n_io_port = 0xff;
+	shost->unique_id = pHCB->HCS_Base;
+	shost->max_id = pHCB->HCS_MaxTar;
+	shost->max_lun = 32;
+	shost->irq = pdev->irq;
+	shost->this_id = pHCB->HCS_SCSI_ID;
+	shost->base = pHCB->HCS_Base;
+	shost->sg_tablesize = TOTAL_SG_ENTRY;
+
+	error = request_irq(pdev->irq, i91u_intr,
+			IRQF_DISABLED|IRQF_SHARED, "i91u", shost);
+	if (error < 0) {
+		printk(KERN_WARNING "initio: unable to request IRQ %d\n",
+				pdev->irq);
+		goto out_free_scbs;
+	}
+
+	pci_set_drvdata(pdev, shost);
+
+	error = scsi_add_host(shost, &pdev->dev);
+	if (error)
+		goto out_free_irq;
+
+	scsi_scan_host(shost);
 	return 0;
-}
-MODULE_LICENSE("Dual BSD/GPL");
 
-static struct scsi_host_template driver_template = {
-	.proc_name	= "INI9100U",
-	.name		= i91u_REVID,
-	.detect		= i91u_detect,
-	.release	= i91u_release,
-	.queuecommand	= i91u_queuecommand,
-//	.abort		= i91u_abort,
-//	.reset		= i91u_reset,
-	.eh_bus_reset_handler = i91u_bus_reset,
-	.bios_param	= i91u_biosparam,
-	.can_queue	= 1,
-	.this_id	= 1,
-	.sg_tablesize	= SG_ALL,
-	.cmd_per_lun 	= 1,
-	.use_clustering	= ENABLE_CLUSTERING,
+ out_free_irq:
+	free_irq(pdev->irq, shost);
+ out_free_scbs:
+	kfree(pHCB->HCS_Scb);
+ out_release_region:
+	release_region(pHCB->HCS_Base, 256);
+ out_host_put:
+	scsi_host_put(shost);
+ out_disable_device:
+	pci_disable_device(pdev);
+ out:
+	return error;
+}
+
+static void __devexit initio_remove_one(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	HCS *pHCB = (HCS *)shost->hostdata;
+
+	scsi_remove_host(shost);
+
+	free_irq(pdev->irq, shost);
+	release_region(pHCB->HCS_Base, 256);
+
+	scsi_host_put(shost);
+	kfree(pHCB->HCS_Scb);
+	pci_disable_device(pdev);
+}
+
+static struct pci_device_id initio_pci_tbl[] = {
+	{PCI_VENDOR_ID_INIT, 0x9500, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_INIT, 0x9400, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_INIT, 0x9401, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_INIT, 0x0002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_DOMEX, 0x0002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{0,}
+};
+MODULE_DEVICE_TABLE(pci, initio_pci_tbl);
+
+static struct pci_driver initio_pci_driver = {
+	.name		= "initio",
+	.id_table	= initio_pci_tbl,
+	.probe		= initio_probe_one,
+	.remove		= __devexit_p(initio_remove_one),
 };
-#include "scsi_module.c"
 
+static int __init initio_init(void)
+{
+	return pci_register_driver(&initio_pci_driver);
+}
+
+static void __exit initio_exit(void)
+{
+	pci_unregister_driver(&initio_pci_driver);
+}
+
+MODULE_DESCRIPTION("Initio INI-9X00U/UW SCSI device driver");
+MODULE_AUTHOR("Initio Corporation");
+MODULE_LICENSE("Dual BSD/GPL");
+
+module_init(initio_init);
+module_exit(initio_exit);
Index: linux-2.6/drivers/scsi/initio.h
===================================================================
--- linux-2.6.orig/drivers/scsi/initio.h	2007-04-22 15:06:11.000000000 +0200
+++ linux-2.6/drivers/scsi/initio.h	2007-04-22 15:06:30.000000000 +0200
@@ -523,28 +523,16 @@ typedef struct Tar_Ctrl_Struc {
 #define TCF_DRV_EN_TAG          0x0800
 #define TCF_DRV_255_63          0x0400
 
-typedef struct I91u_Adpt_Struc {
-	UWORD ADPT_BIOS;	/* 0 */
-	UWORD ADPT_BASE;	/* 1 */
-	UBYTE ADPT_Bus;		/* 2 */
-	UBYTE ADPT_Device;	/* 3 */
-	UBYTE ADPT_INTR;	/* 4 */
-} INI_ADPT_STRUCT;
-
-
 /***********************************************************************
 	      Host Adapter Control Structure
 ************************************************************************/
 typedef struct Ha_Ctrl_Struc {
 	UWORD HCS_Base;		/* 00 */
-	UWORD HCS_BIOS;		/* 02 */
-	UBYTE HCS_Intr;		/* 04 */
 	UBYTE HCS_SCSI_ID;	/* 05 */
 	UBYTE HCS_MaxTar;	/* 06 */
 	UBYTE HCS_NumScbs;	/* 07 */
 
 	UBYTE HCS_Flags;	/* 08 */
-	UBYTE HCS_Index;	/* 09 */
 	UBYTE HCS_HaId;		/* 0A */
 	UBYTE HCS_Config;	/* 0B */
 	UWORD HCS_IdMask;	/* 0C */
@@ -681,14 +669,8 @@ typedef struct _NVRAM {
 #define DISC_ALLOW              0xC0	/* Disconnect is allowed        */
 #define SCSICMD_RequestSense    0x03
 
-typedef struct _HCSinfo {
-	ULONG base;
-	UCHAR vec;
-	UCHAR bios;		/* High byte of BIOS address */
-	USHORT BaseAndBios;	/* high byte: pHcsInfo->bios,low byte:pHcsInfo->base */
-} HCSINFO;
-
 #define TUL_RD(x,y)             (UCHAR)(inb(  (int)((ULONG)(x+y)) ))
+#define TUL_RDWORD(x,y)         (short)(inl((int)((ULONG)((ULONG)x+(UCHAR)y)) ))
 #define TUL_RDLONG(x,y)         (ULONG)(inl((int)((ULONG)(x+y)) ))
 #define TUL_WR(     adr,data)   outb( (UCHAR)(data), (int)(adr))
 #define TUL_WRSHORT(adr,data)   outw( (UWORD)(data), (int)(adr))
@@ -717,4 +699,3 @@ typedef struct _HCSinfo {
 #define SCSI_RESET_BUS_RESET 0x100
 #define SCSI_RESET_HOST_RESET 0x200
 #define SCSI_RESET_ACTION   0xff
-
