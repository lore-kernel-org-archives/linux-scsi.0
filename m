From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 2/5] SCSI/initio pci_dev, pci_dev->irq simplifications
Date: Sun, 27 May 2007 10:55:58 -0400
Message-ID: <20070527145558.GB17085@havoc.gtf.org>
References: <20070527145200.GA17017@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:33563 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbXE0Oz7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 May 2007 10:55:59 -0400
Content-Disposition: inline
In-Reply-To: <20070527145200.GA17017@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>


Now that pci_dev is available in the adapter table, we can logically
simplify Addi91u_into_Adapter_table(), HCS and INI_ADPT_STRUCT.

Signed-off-by: Jeff Garzik <jeff@garzik.org>

0151ba1cfeb6565bd1e79b5ba913423f19602d2e
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 8951494..d25a228 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -582,10 +582,9 @@ void tul_read_eeprom(WORD CurBase)
 	TUL_WR(CurBase + TUL_GCTRL, gctrl & ~TUL_GCTRL_EEPROM_BIT);
 }				/* read_eeprom */
 
-static int Addi91u_into_Adapter_table(WORD wBIOS, WORD wBASE, BYTE bInterrupt,
-				      BYTE bBus, BYTE bDevice,
-				      struct pci_dev *pci_dev)
+static int Addi91u_into_Adapter_table(WORD wBIOS, struct pci_dev *pci_dev)
 {
+	WORD wBASE = pci_dev->resource[0].start;
 	int i, j;
 
 	for (i = 0; i < MAX_SUPPORTED_ADAPTERS; i++) {
@@ -600,16 +599,14 @@ static int Addi91u_into_Adapter_table(WORD wBIOS, WORD wBASE, BYTE bInterrupt,
 		}
 		for (j = MAX_SUPPORTED_ADAPTERS - 1; j > i; j--) {
 			i91u_adpt[j].ADPT_BASE = i91u_adpt[j - 1].ADPT_BASE;
-			i91u_adpt[j].ADPT_INTR = i91u_adpt[j - 1].ADPT_INTR;
 			i91u_adpt[j].ADPT_BIOS = i91u_adpt[j - 1].ADPT_BIOS;
 			i91u_adpt[j].ADPT_Bus = i91u_adpt[j - 1].ADPT_Bus;
 			i91u_adpt[j].ADPT_Device = i91u_adpt[j - 1].ADPT_Device;
 		}
 		i91u_adpt[i].ADPT_BASE = wBASE;
-		i91u_adpt[i].ADPT_INTR = bInterrupt;
 		i91u_adpt[i].ADPT_BIOS = wBIOS;
-		i91u_adpt[i].ADPT_Bus = bBus;
-		i91u_adpt[i].ADPT_Device = bDevice;
+		i91u_adpt[i].ADPT_Bus = pci_dev->bus->number;
+		i91u_adpt[i].ADPT_Device = pci_dev->devfn >> 3;
 		i91u_adpt[i].pci_dev = pci_dev;
 		return 0;
 	}
@@ -623,7 +620,6 @@ static void init_i91uAdapter_table(void)
 	for (i = 0; i < MAX_SUPPORTED_ADAPTERS; i++) {	/* Initialize adapter structure */
 		i91u_adpt[i].ADPT_BIOS = 0xffff;
 		i91u_adpt[i].ADPT_BASE = 0xffff;
-		i91u_adpt[i].ADPT_INTR = 0xff;
 		i91u_adpt[i].ADPT_Bus = 0xff;
 		i91u_adpt[i].ADPT_Device = 0xff;
 	}
@@ -647,8 +643,6 @@ static void get_tulipPCIConfig(HCS * pCurHcb, int ch_idx)
 	pCurHcb->pci_dev = i91u_adpt[ch_idx].pci_dev;
 	pCurHcb->HCS_Base = i91u_adpt[ch_idx].ADPT_BASE;	/* Supply base address  */
 	pCurHcb->HCS_BIOS = i91u_adpt[ch_idx].ADPT_BIOS;	/* Supply BIOS address  */
-	pCurHcb->HCS_Intr = i91u_adpt[ch_idx].ADPT_INTR;	/* Supply interrupt line */
-	return;
 }
 
 /***************************************************************************/
@@ -777,7 +771,7 @@ static int init_tulip(HCS * pCurHcb, SCB * scbp, int tul_num_scb,
 		pCurHcb->HCS_MaxTags[i] = 0xFF;
 	}			/* for                          */
 	printk("i91u: PCI Base=0x%04X, IRQ=%d, BIOS=0x%04X0, SCSI ID=%d\n",
-	       pCurHcb->HCS_Base, pCurHcb->HCS_Intr,
+	       pCurHcb->HCS_Base, pCurHcb->pci_dev->irq,
 	       pCurHcb->HCS_BIOS, pCurHcb->HCS_SCSI_ID);
 /*------------------- reset SCSI Bus ---------------------------*/
 	if (pCurHcb->HCS_Config & HCC_SCSI_RESET) {
@@ -2788,13 +2782,7 @@ static int tul_NewReturnNumberOfAdapters(void)
 				continue;
 			}
 
-			if (Addi91u_into_Adapter_table(wBIOS,
-							(pDev->resource[0].start),
-						       	pDev->irq,
-						       	pDev->bus->number,
-					       		(pDev->devfn >> 3),
-							pDev
-		    		) == 0)
+			if (Addi91u_into_Adapter_table(wBIOS, pDev) == 0)
 				iAdapters++;
 		}
 	}
@@ -2865,15 +2853,17 @@ static int i91u_detect(struct scsi_host_template * tpnt)
 		hreg->unique_id = pHCB->HCS_Base;
 		hreg->max_id = pHCB->HCS_MaxTar;
 		hreg->max_lun = 32;	/* 10/21/97                     */
-		hreg->irq = pHCB->HCS_Intr;
+		hreg->irq = pHCB->pci_dev->irq;
 		hreg->this_id = pHCB->HCS_SCSI_ID;	/* Assign HCS index           */
 		hreg->base = (unsigned long)pHCB;
 		hreg->sg_tablesize = TOTAL_SG_ENTRY;	/* Maximun support is 32 */
 
 		/* Initial tulip chip           */
-		ok = request_irq(pHCB->HCS_Intr, i91u_intr, IRQF_DISABLED | IRQF_SHARED, "i91u", hreg);
+		ok = request_irq(pHCB->pci_dev->irq, i91u_intr,
+				 IRQF_DISABLED | IRQF_SHARED, "i91u", hreg);
 		if (ok < 0) {
-			printk(KERN_WARNING "i91u: unable to request IRQ %d\n\n", pHCB->HCS_Intr);
+			printk(KERN_ERR "i91u: unable to request IRQ %d\n\n",
+			       pHCB->pci_dev->irq);
 			return 0;
 		}
 	}
diff --git a/drivers/scsi/initio.h b/drivers/scsi/initio.h
index dcd42e2..817b696 100644
--- a/drivers/scsi/initio.h
+++ b/drivers/scsi/initio.h
@@ -528,7 +528,6 @@ typedef struct I91u_Adpt_Struc {
 	UWORD ADPT_BASE;	/* 1 */
 	UBYTE ADPT_Bus;		/* 2 */
 	UBYTE ADPT_Device;	/* 3 */
-	UBYTE ADPT_INTR;	/* 4 */
 	struct pci_dev *pci_dev;
 } INI_ADPT_STRUCT;
 
@@ -536,10 +535,15 @@ typedef struct I91u_Adpt_Struc {
 /***********************************************************************
 	      Host Adapter Control Structure
 ************************************************************************/
+/*
+ * TODO: Remove the "xxx_Unused" struct members only after determining
+ * that this struct does not have special GFP_DMA alignment/padding
+ * restrictions that hamper modification of Ha_Ctrl_Struc.
+ */
 typedef struct Ha_Ctrl_Struc {
 	UWORD HCS_Base;		/* 00 */
 	UWORD HCS_BIOS;		/* 02 */
-	UBYTE HCS_Intr;		/* 04 */
+	UBYTE HCS_Intr_Unused;	/* 04 */
 	UBYTE HCS_SCSI_ID;	/* 05 */
 	UBYTE HCS_MaxTar;	/* 06 */
 	UBYTE HCS_NumScbs;	/* 07 */
