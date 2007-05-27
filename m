From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 1/5] SCSI/initio PCI DMA fix
Date: Sun, 27 May 2007 10:53:57 -0400
Message-ID: <20070527145357.GA17085@havoc.gtf.org>
References: <20070527145200.GA17017@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:33553 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbXE0Ox5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 May 2007 10:53:57 -0400
Content-Disposition: inline
In-Reply-To: <20070527145200.GA17017@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>


The 'pci_dev' member of HCS is referenced during PCI DMA, but never
actually assigned a value.  Let's give it a useful value.

Has this driver been broken since PCI DMA support was added in Oct 2003?

Signed-off-by: Jeff Garzik <jeff@garzik.org>

a5eec1873b5934de70c589ad0f4596f78c4d0dd3
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 7e7635c..8951494 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -583,7 +583,8 @@ void tul_read_eeprom(WORD CurBase)
 }				/* read_eeprom */
 
 static int Addi91u_into_Adapter_table(WORD wBIOS, WORD wBASE, BYTE bInterrupt,
-				      BYTE bBus, BYTE bDevice)
+				      BYTE bBus, BYTE bDevice,
+				      struct pci_dev *pci_dev)
 {
 	int i, j;
 
@@ -609,6 +610,7 @@ static int Addi91u_into_Adapter_table(WORD wBIOS, WORD wBASE, BYTE bInterrupt,
 		i91u_adpt[i].ADPT_BIOS = wBIOS;
 		i91u_adpt[i].ADPT_Bus = bBus;
 		i91u_adpt[i].ADPT_Device = bDevice;
+		i91u_adpt[i].pci_dev = pci_dev;
 		return 0;
 	}
 	return 1;
@@ -642,6 +644,7 @@ static void tul_stop_bm(HCS * pCurHcb)
 /***************************************************************************/
 static void get_tulipPCIConfig(HCS * pCurHcb, int ch_idx)
 {
+	pCurHcb->pci_dev = i91u_adpt[ch_idx].pci_dev;
 	pCurHcb->HCS_Base = i91u_adpt[ch_idx].ADPT_BASE;	/* Supply base address  */
 	pCurHcb->HCS_BIOS = i91u_adpt[ch_idx].ADPT_BIOS;	/* Supply BIOS address  */
 	pCurHcb->HCS_Intr = i91u_adpt[ch_idx].ADPT_INTR;	/* Supply interrupt line */
@@ -2789,7 +2792,8 @@ static int tul_NewReturnNumberOfAdapters(void)
 							(pDev->resource[0].start),
 						       	pDev->irq,
 						       	pDev->bus->number,
-					       		(pDev->devfn >> 3)
+					       		(pDev->devfn >> 3),
+							pDev
 		    		) == 0)
 				iAdapters++;
 		}
diff --git a/drivers/scsi/initio.h b/drivers/scsi/initio.h
index acb67a4..dcd42e2 100644
--- a/drivers/scsi/initio.h
+++ b/drivers/scsi/initio.h
@@ -529,6 +529,7 @@ typedef struct I91u_Adpt_Struc {
 	UBYTE ADPT_Bus;		/* 2 */
 	UBYTE ADPT_Device;	/* 3 */
 	UBYTE ADPT_INTR;	/* 4 */
+	struct pci_dev *pci_dev;
 } INI_ADPT_STRUCT;
 
 
