From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] a100u2w: cleanups
Date: Wed, 29 Sep 2004 18:18:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929161826.GA30602@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:35538 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268501AbUI2QSc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 12:18:32 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

 - mark all functions static
 - don't use scsi.h obsolete symbols
 - add my copyright boilerplate (more for last years work then the
   trivial nitpicks here)
 - comment formatting fixes
 - remove dead wood from a100u2w.h


--- 1.2/drivers/scsi/a100u2w.c	2004-09-29 17:03:12 +02:00
+++ edited/drivers/scsi/a100u2w.c	2004-09-29 17:58:18 +02:00
@@ -1,7 +1,8 @@
-/**************************************************************************
+/*
  * Initio A100 device driver for Linux.
  *
  * Copyright (c) 1994-1998 Initio Corporation
+ * Copyright (c) 2003-2004 Christoph Hellwig
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -50,13 +51,10 @@
  * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  * SUCH DAMAGE.
- *
- **************************************************************************
- * 
- * module: inia100.c
- * DESCRIPTION:
- * 	This is the Linux low-level SCSI driver for Initio INIA100 SCSI host
- * 	adapters
+ */
+
+/*
+ * Revision History:
  * 07/02/98 hl	- v.91n Initial drivers.
  * 09/14/98 hl - v1.01 Support new Kernel.
  * 09/22/98 hl - v1.01a Support reset.
@@ -71,13 +69,13 @@
  *          - Clean up interrupt handler registration
  *          - Fix memory leaks
  *          - Fix allocation of scsi host structs and private data
- * 18/11/03 Christoph Hellwig <hch@lst.de>
+ * 11/18/03 Christoph Hellwig <hch@lst.de>
  *	    - Port to new probing API
  *	    - Fix some more leaks in init failure cases
- * TODO:
- *	    - use list.h macros for SCB queue
- *	  ( - merge with i60uscsi.c )
- **************************************************************************/
+ * 9/28/04 Christoph Hellwig <hch@lst.de>
+ *	    - merge the two source files
+ *	    - remove internal queueing code
+ */
 
 #include <linux/module.h>
 #include <linux/errno.h>
@@ -91,6 +89,7 @@
 #include <linux/string.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
+
 #include <asm/io.h>
 #include <asm/irq.h>
 
@@ -98,42 +97,17 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
-#include "scsi.h"
 
 #include "a100u2w.h"
 
-#define ORC_RDWORD(x,y)         (short)(inl((int)((ULONG)((ULONG)x+(UCHAR)y)) ))
-
-char *inia100_Copyright = "Copyright (C) 1998-99";
-char *inia100_InitioName = "by Initio Corporation";
-char *inia100_ProductName = "INI-A100U2W";
-char *inia100_Version = "v1.02d";
 
 #define JIFFIES_TO_MS(t) ((t) * 1000 / HZ)
 #define MS_TO_JIFFIES(j) ((j * HZ) / 1000)
 
-/* ---- INTERNAL FUNCTIONS ---- */
-static UCHAR waitChipReady(ORC_HCS * hcsp);
-static UCHAR waitFWReady(ORC_HCS * hcsp);
-static UCHAR waitFWReady(ORC_HCS * hcsp);
-static UCHAR waitSCSIRSTdone(ORC_HCS * hcsp);
-static UCHAR waitHDOoff(ORC_HCS * hcsp);
-static UCHAR waitHDIset(ORC_HCS * hcsp, UCHAR * pData);
-static unsigned short get_FW_version(ORC_HCS * hcsp);
-static UCHAR set_NVRAM(ORC_HCS * hcsp, unsigned char address, unsigned char value);
-static UCHAR get_NVRAM(ORC_HCS * hcsp, unsigned char address, unsigned char *pDataIn);
-static int se2_rd_all(ORC_HCS * hcsp);
-static void se2_update_all(ORC_HCS * hcsp);	/* setup default pattern        */
-static void read_eeprom(ORC_HCS * hcsp);
-static UCHAR load_FW(ORC_HCS * hcsp);
-static void setup_SCBs(ORC_HCS * hcsp);
-static void initAFlag(ORC_HCS * hcsp);
-ORC_SCB *orc_alloc_scb(ORC_HCS * hcsp);
-
-/* ---- EXTERNAL FUNCTIONS ---- */
-extern void inia100SCBPost(BYTE * pHcb, BYTE * pScb);
+static ORC_SCB *orc_alloc_scb(ORC_HCS * hcsp);
+static void inia100SCBPost(BYTE * pHcb, BYTE * pScb);
 
-NVRAM nvram, *nvramp = &nvram;
+static NVRAM nvram, *nvramp = &nvram;
 static UCHAR dftNvRam[64] =
 {
 /*----------header -------------*/
@@ -192,72 +166,72 @@
 }
 
 /***************************************************************************/
-UCHAR waitChipReady(ORC_HCS * hcsp)
+static UCHAR waitChipReady(ORC_HCS * hcsp)
 {
 	int i;
 
 	for (i = 0; i < 10; i++) {	/* Wait 1 second for report timeout     */
 		if (ORC_RD(hcsp->HCS_Base, ORC_HCTRL) & HOSTSTOP)	/* Wait HOSTSTOP set */
-			return (TRUE);
+			return 1;
 		waitForPause(100);	/* wait 100ms before try again  */
 	}
-	return (FALSE);
+	return 0;
 }
 
 /***************************************************************************/
-UCHAR waitFWReady(ORC_HCS * hcsp)
+static UCHAR waitFWReady(ORC_HCS * hcsp)
 {
 	int i;
 
 	for (i = 0; i < 10; i++) {	/* Wait 1 second for report timeout     */
 		if (ORC_RD(hcsp->HCS_Base, ORC_HSTUS) & RREADY)		/* Wait READY set */
-			return (TRUE);
+			return 1;
 		waitForPause(100);	/* wait 100ms before try again  */
 	}
-	return (FALSE);
+	return 0;
 }
 
 /***************************************************************************/
-UCHAR waitSCSIRSTdone(ORC_HCS * hcsp)
+static UCHAR waitSCSIRSTdone(ORC_HCS * hcsp)
 {
 	int i;
 
 	for (i = 0; i < 10; i++) {	/* Wait 1 second for report timeout     */
 		if (!(ORC_RD(hcsp->HCS_Base, ORC_HCTRL) & SCSIRST))	/* Wait SCSIRST done */
-			return (TRUE);
+			return 1;
 		waitForPause(100);	/* wait 100ms before try again  */
 	}
-	return (FALSE);
+	return 0;
 }
 
 /***************************************************************************/
-UCHAR waitHDOoff(ORC_HCS * hcsp)
+static UCHAR waitHDOoff(ORC_HCS * hcsp)
 {
 	int i;
 
 	for (i = 0; i < 10; i++) {	/* Wait 1 second for report timeout     */
 		if (!(ORC_RD(hcsp->HCS_Base, ORC_HCTRL) & HDO))		/* Wait HDO off */
-			return (TRUE);
+			return 1;
 		waitForPause(100);	/* wait 100ms before try again  */
 	}
-	return (FALSE);
+	return 0;
 }
 
 /***************************************************************************/
-UCHAR waitHDIset(ORC_HCS * hcsp, UCHAR * pData)
+static UCHAR waitHDIset(ORC_HCS * hcsp, UCHAR * pData)
 {
 	int i;
 
 	for (i = 0; i < 10; i++) {	/* Wait 1 second for report timeout     */
 		if ((*pData = ORC_RD(hcsp->HCS_Base, ORC_HSTUS)) & HDI)
-			return (TRUE);	/* Wait HDI set */
+			return 1;	/* Wait HDI set */
 		waitForPause(100);	/* wait 100ms before try again  */
 	}
-	return (FALSE);
+	return 0;
 }
 
 /***************************************************************************/
-unsigned short get_FW_version(ORC_HCS * hcsp)
+static unsigned short get_FW_version(ORC_HCS * hcsp)
 {
 	UCHAR bData;
 	union {
@@ -267,16 +241,16 @@
 
 	ORC_WR(hcsp->HCS_Base + ORC_HDATA, ORC_CMD_VERSION);
 	ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);
-	if (waitHDOoff(hcsp) == FALSE)	/* Wait HDO off   */
-		return (FALSE);
+	if (waitHDOoff(hcsp) == 0)	/* Wait HDO off   */
+		return 0;
 
-	if (waitHDIset(hcsp, &bData) == FALSE)	/* Wait HDI set   */
-		return (FALSE);
+	if (waitHDIset(hcsp, &bData) == 0)	/* Wait HDI set   */
+		return 0;
 	Version.cVersion[0] = ORC_RD(hcsp->HCS_Base, ORC_HDATA);
 	ORC_WR(hcsp->HCS_Base + ORC_HSTUS, bData);	/* Clear HDI            */
 
-	if (waitHDIset(hcsp, &bData) == FALSE)	/* Wait HDI set   */
-		return (FALSE);
+	if (waitHDIset(hcsp, &bData) == 0)	/* Wait HDI set   */
+		return 0;
 	Version.cVersion[1] = ORC_RD(hcsp->HCS_Base, ORC_HDATA);
 	ORC_WR(hcsp->HCS_Base + ORC_HSTUS, bData);	/* Clear HDI            */
 
@@ -284,51 +258,51 @@
 }
 
 /***************************************************************************/
-UCHAR set_NVRAM(ORC_HCS * hcsp, unsigned char address, unsigned char value)
+static UCHAR set_NVRAM(ORC_HCS * hcsp, unsigned char address, unsigned char value)
 {
 	ORC_WR(hcsp->HCS_Base + ORC_HDATA, ORC_CMD_SET_NVM);	/* Write command */
 	ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);
-	if (waitHDOoff(hcsp) == FALSE)	/* Wait HDO off   */
-		return (FALSE);
+	if (waitHDOoff(hcsp) == 0)	/* Wait HDO off   */
+		return 0;
 
 	ORC_WR(hcsp->HCS_Base + ORC_HDATA, address);	/* Write address */
 	ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);
-	if (waitHDOoff(hcsp) == FALSE)	/* Wait HDO off   */
-		return (FALSE);
+	if (waitHDOoff(hcsp) == 0)	/* Wait HDO off   */
+		return 0;
 
 	ORC_WR(hcsp->HCS_Base + ORC_HDATA, value);	/* Write value  */
 	ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);
-	if (waitHDOoff(hcsp) == FALSE)	/* Wait HDO off   */
-		return (FALSE);
+	if (waitHDOoff(hcsp) == 0)	/* Wait HDO off   */
+		return 0;
 
-	return (TRUE);
+	return 1;
 }
 
 /***************************************************************************/
-UCHAR get_NVRAM(ORC_HCS * hcsp, unsigned char address, unsigned char *pDataIn)
+static UCHAR get_NVRAM(ORC_HCS * hcsp, unsigned char address, unsigned char *pDataIn)
 {
 	unsigned char bData;
 
 	ORC_WR(hcsp->HCS_Base + ORC_HDATA, ORC_CMD_GET_NVM);	/* Write command */
 	ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);
-	if (waitHDOoff(hcsp) == FALSE)	/* Wait HDO off   */
-		return (FALSE);
+	if (waitHDOoff(hcsp) == 0)	/* Wait HDO off   */
+		return 0;
 
 	ORC_WR(hcsp->HCS_Base + ORC_HDATA, address);	/* Write address */
 	ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);
-	if (waitHDOoff(hcsp) == FALSE)	/* Wait HDO off   */
-		return (FALSE);
+	if (waitHDOoff(hcsp) == 0)	/* Wait HDO off   */
+		return 0;
 
-	if (waitHDIset(hcsp, &bData) == FALSE)	/* Wait HDI set   */
-		return (FALSE);
+	if (waitHDIset(hcsp, &bData) == 0)	/* Wait HDI set   */
+		return 0;
 	*pDataIn = ORC_RD(hcsp->HCS_Base, ORC_HDATA);
 	ORC_WR(hcsp->HCS_Base + ORC_HSTUS, bData);	/* Clear HDI    */
 
-	return (TRUE);
+	return 1;
 }
 
 /***************************************************************************/
-void orc_exec_scb(ORC_HCS * hcsp, ORC_SCB * scbp)
+static void orc_exec_scb(ORC_HCS * hcsp, ORC_SCB * scbp)
 {
 	scbp->SCB_Status = ORCSCB_POST;
 	ORC_WR(hcsp->HCS_Base + ORC_PQUEUE, scbp->SCB_ScbIdx);
@@ -339,14 +313,14 @@
 /***********************************************************************
  Read SCSI H/A configuration parameters from serial EEPROM
 ************************************************************************/
-int se2_rd_all(ORC_HCS * hcsp)
+static int se2_rd_all(ORC_HCS * hcsp)
 {
 	int i;
 	UCHAR *np, chksum = 0;
 
 	np = (UCHAR *) nvramp;
 	for (i = 0; i < 64; i++, np++) {	/* <01> */
-		if (get_NVRAM(hcsp, (unsigned char) i, np) == FALSE)
+		if (get_NVRAM(hcsp, (unsigned char) i, np) == 0)
 			return -1;
 //      *np++ = get_NVRAM(hcsp, (unsigned char ) i);
 	}
@@ -364,7 +338,7 @@
 /************************************************************************
  Update SCSI H/A configuration parameters from serial EEPROM
 *************************************************************************/
-void se2_update_all(ORC_HCS * hcsp)
+static void se2_update_all(ORC_HCS * hcsp)
 {				/* setup default pattern  */
 	int i;
 	UCHAR *np, *np1, chksum = 0;
@@ -388,7 +362,7 @@
 /*************************************************************************
  Function name  : read_eeprom
 **************************************************************************/
-void read_eeprom(ORC_HCS * hcsp)
+static void read_eeprom(ORC_HCS * hcsp)
 {
 	if (se2_rd_all(hcsp) != 1) {
 		se2_update_all(hcsp);	/* setup default pattern        */
@@ -398,7 +372,7 @@
 
 
 /***************************************************************************/
-UCHAR load_FW(ORC_HCS * hcsp)
+static UCHAR load_FW(ORC_HCS * hcsp)
 {
 	U32 dData;
 	USHORT wBIOSAddress;
@@ -412,12 +386,12 @@
 	ORC_WRSHORT(hcsp->HCS_Base + ORC_EBIOSADR0, 0x00);
 	if (ORC_RD(hcsp->HCS_Base, ORC_EBIOSDATA) != 0x55) {
 		ORC_WR(hcsp->HCS_Base + ORC_GCFG, bData);	/* Disable EEPROM programming */
-		return (FALSE);
+		return 0;
 	}
 	ORC_WRSHORT(hcsp->HCS_Base + ORC_EBIOSADR0, 0x01);
 	if (ORC_RD(hcsp->HCS_Base, ORC_EBIOSDATA) != 0xAA) {
 		ORC_WR(hcsp->HCS_Base + ORC_GCFG, bData);	/* Disable EEPROM programming */
-		return (FALSE);
+		return 0;
 	}
 	ORC_WR(hcsp->HCS_Base + ORC_RISCCTL, PRGMRST | DOWNLOAD);	/* Enable SRAM programming */
 	pData = (UCHAR *) & dData;
@@ -454,18 +428,18 @@
 			if (ORC_RDLONG(hcsp->HCS_Base, ORC_RISCRAM) != dData) {
 				ORC_WR(hcsp->HCS_Base + ORC_RISCCTL, PRGMRST);	/* Reset program to 0 */
 				ORC_WR(hcsp->HCS_Base + ORC_GCFG, bData);	/*Disable EEPROM programming */
-				return (FALSE);
+				return 0;
 			}
 			pData = (UCHAR *) & dData;
 		}
 	}
 	ORC_WR(hcsp->HCS_Base + ORC_RISCCTL, PRGMRST);	/* Reset program to 0   */
 	ORC_WR(hcsp->HCS_Base + ORC_GCFG, bData);	/* Disable EEPROM programming */
-	return (TRUE);
+	return 1;
 }
 
 /***************************************************************************/
-void setup_SCBs(ORC_HCS * hcsp)
+static void setup_SCBs(ORC_HCS * hcsp)
 {
 	ORC_SCB *pVirScb;
 	int i;
@@ -480,8 +454,8 @@
 	ORC_WRLONG(hcsp->HCS_Base + ORC_SCBBASE1, hcsp->HCS_physScbArray);
 
 	/* setup scatter list address with one buffer */
-	pVirScb = (ORC_SCB *) hcsp->HCS_virScbArray;
-	pVirEscb = (ESCB *) hcsp->HCS_virEscbArray;
+	pVirScb = hcsp->HCS_virScbArray;
+	pVirEscb = hcsp->HCS_virEscbArray;
 
 	for (i = 0; i < ORC_MAXQUEUE; i++) {
 		pPhysEscb = (hcsp->HCS_physEscbArray + (sizeof(ESCB) * i));
@@ -509,7 +483,7 @@
 }
 
 /***************************************************************************/
-int init_orchid(ORC_HCS * hcsp)
+static int init_orchid(ORC_HCS * hcsp)
 {
 	UBYTE *readBytep;
 	USHORT revision;
@@ -521,12 +495,12 @@
 		revision = get_FW_version(hcsp);
 		if (revision == 0xFFFF) {
 			ORC_WR(hcsp->HCS_Base + ORC_HCTRL, DEVRST);	/* Reset Host Adapter   */
-			if (waitChipReady(hcsp) == FALSE)
+			if (waitChipReady(hcsp) == 0)
 				return (-1);
 			load_FW(hcsp);	/* Download FW                  */
 			setup_SCBs(hcsp);	/* Setup SCB HCS_Base and SCB Size registers */
 			ORC_WR(hcsp->HCS_Base + ORC_HCTRL, 0);	/* clear HOSTSTOP       */
-			if (waitFWReady(hcsp) == FALSE)
+			if (waitFWReady(hcsp) == 0)
 				return (-1);
 			/* Wait for firmware ready     */
 		} else {
@@ -534,14 +508,14 @@
 		}
 	} else {		/* Orchid is not Ready          */
 		ORC_WR(hcsp->HCS_Base + ORC_HCTRL, DEVRST);	/* Reset Host Adapter   */
-		if (waitChipReady(hcsp) == FALSE)
+		if (waitChipReady(hcsp) == 0)
 			return (-1);
 		load_FW(hcsp);	/* Download FW                  */
 		setup_SCBs(hcsp);	/* Setup SCB HCS_Base and SCB Size registers */
 		ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);	/* Do Hardware Reset &  */
 
 		/*     clear HOSTSTOP  */
-		if (waitFWReady(hcsp) == FALSE)		/* Wait for firmware ready      */
+		if (waitFWReady(hcsp) == 0)		/* Wait for firmware ready      */
 			return (-1);
 	}
 
@@ -576,7 +550,7 @@
  Output         : None.
  Return         : pSRB  -       Pointer to SCSI request block.
 *****************************************************************************/
-int orc_reset_scsi_bus(ORC_HCS * pHCB)
+static int orc_reset_scsi_bus(ORC_HCS * pHCB)
 {				/* I need Host Control Block Information */
 	ULONG flags;
 
@@ -585,7 +559,7 @@
 	initAFlag(pHCB);
 	/* reset scsi bus */
 	ORC_WR(pHCB->HCS_Base + ORC_HCTRL, SCSIRST);
-	if (waitSCSIRSTdone(pHCB) == FALSE) {
+	if (waitSCSIRSTdone(pHCB) == 0) {
 		spin_unlock_irqrestore(&(pHCB->BitAllocFlagLock), flags);
 		return FAILED;
 	} else {
@@ -602,7 +576,7 @@
  Output         : None.
  Return         : pSRB  -       Pointer to SCSI request block.
 *****************************************************************************/
-int orc_device_reset(ORC_HCS * pHCB, Scsi_Cmnd *SCpnt, unsigned int target)
+static int orc_device_reset(ORC_HCS * pHCB, struct scsi_cmnd *SCpnt, unsigned int target)
 {				/* I need Host Control Block Information */
 	ORC_SCB *pScb;
 	ESCB *pVirEscb;
@@ -615,7 +589,7 @@
 	pVirEscb = (ESCB *) NULL;
 
 	/* setup scatter list address with one buffer */
-	pVirScb = (ORC_SCB *) pHCB->HCS_virScbArray;
+	pVirScb = pHCB->HCS_virScbArray;
 
 	initAFlag(pHCB);
 	/* device reset */
@@ -655,7 +629,7 @@
 
 
 /***************************************************************************/
-ORC_SCB *__orc_alloc_scb(ORC_HCS * hcsp)
+static ORC_SCB *__orc_alloc_scb(ORC_HCS * hcsp)
 {
 	ORC_SCB *pTmpScb;
 	UCHAR Ch;
@@ -672,13 +646,13 @@
 			}
 		}
 		idx = index + 32 * i;
-		pTmpScb = (PVOID) ((ULONG) hcsp->HCS_virScbArray + (idx * sizeof(ORC_SCB)));
+		pTmpScb = (ORC_SCB *) ((ULONG) hcsp->HCS_virScbArray + (idx * sizeof(ORC_SCB)));
 		return (pTmpScb);
 	}
 	return (NULL);
 }
 
-ORC_SCB *orc_alloc_scb(ORC_HCS * hcsp)
+static ORC_SCB *orc_alloc_scb(ORC_HCS * hcsp)
 {
 	ORC_SCB *pTmpScb;
 	ULONG flags;
@@ -691,7 +665,7 @@
 
 
 /***************************************************************************/
-void orc_release_scb(ORC_HCS * hcsp, ORC_SCB * scbp)
+static void orc_release_scb(ORC_HCS * hcsp, ORC_SCB * scbp)
 {
 	ULONG flags;
 	UCHAR Index;
@@ -715,28 +689,28 @@
  Output         : None.
  Return         : pSRB  -       Pointer to SCSI request block.
 *****************************************************************************/
-int abort_SCB(ORC_HCS * hcsp, ORC_SCB * pScb)
+static int abort_SCB(ORC_HCS * hcsp, ORC_SCB * pScb)
 {
 	unsigned char bData, bStatus;
 
 	ORC_WR(hcsp->HCS_Base + ORC_HDATA, ORC_CMD_ABORT_SCB);	/* Write command */
 	ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);
-	if (waitHDOoff(hcsp) == FALSE)	/* Wait HDO off   */
-		return (FALSE);
+	if (waitHDOoff(hcsp) == 0)	/* Wait HDO off   */
+		return 0;
 
 	ORC_WR(hcsp->HCS_Base + ORC_HDATA, pScb->SCB_ScbIdx);	/* Write address */
 	ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);
-	if (waitHDOoff(hcsp) == FALSE)	/* Wait HDO off   */
-		return (FALSE);
+	if (waitHDOoff(hcsp) == 0)	/* Wait HDO off   */
+		return 0;
 
-	if (waitHDIset(hcsp, &bData) == FALSE)	/* Wait HDI set   */
-		return (FALSE);
+	if (waitHDIset(hcsp, &bData) == 0)	/* Wait HDI set   */
+		return 0;
 	bStatus = ORC_RD(hcsp->HCS_Base, ORC_HDATA);
 	ORC_WR(hcsp->HCS_Base + ORC_HSTUS, bData);	/* Clear HDI    */
 
 	if (bStatus == 1)	/* 0 - Successfully               */
-		return (FALSE);	/* 1 - Fail                     */
-	return (TRUE);
+		return 0;	/* 1 - Fail                     */
+	return 1;
 }
 
 /*****************************************************************************
@@ -747,7 +721,7 @@
  Output         : None.
  Return         : pSRB  -       Pointer to SCSI request block.
 *****************************************************************************/
-int orc_abort_srb(ORC_HCS * hcsp, Scsi_Cmnd *SCpnt)
+static int orc_abort_srb(ORC_HCS * hcsp, struct scsi_cmnd *SCpnt)
 {
 	ESCB *pVirEscb;
 	ORC_SCB *pVirScb;
@@ -756,7 +730,7 @@
 
 	spin_lock_irqsave(&(hcsp->BitAllocFlagLock), flags);
 
-	pVirScb = (ORC_SCB *) hcsp->HCS_virScbArray;
+	pVirScb = hcsp->HCS_virScbArray;
 
 	for (i = 0; i < ORC_MAXQUEUE; i++, pVirScb++) {
 		pVirEscb = pVirScb->SCB_EScb;
@@ -789,7 +763,7 @@
 	  HwDeviceExtension - HBA miniport driver's adapter data storage
  Return Value:
 ***********************************************************************/
-void orc_interrupt(
+static void orc_interrupt(
 			  ORC_HCS * hcsp
 )
 {
@@ -797,7 +771,7 @@
 	ORC_SCB *pScb;
 
 	if (ORC_RD(hcsp->HCS_Base, ORC_RQUEUECNT) == 0) {
-		return;		// (FALSE);
+		return;		// 0;
 
 	}
 	do {
@@ -808,7 +782,7 @@
 
 		inia100SCBPost((BYTE *) hcsp, (BYTE *) pScb);
 	} while (ORC_RD(hcsp->HCS_Base, ORC_RQUEUECNT));
-	return;			//(TRUE);
+	return;			//1;
 
 }				/* End of I1060Interrupt() */
 
@@ -962,7 +936,7 @@
  Output         : None.
  Return         : None.
 *****************************************************************************/
-void inia100SCBPost(BYTE * pHcb, BYTE * pScb)
+static void inia100SCBPost(BYTE * pHcb, BYTE * pScb)
 {
 	struct scsi_cmnd *pSRB;	/* Pointer to SCSI request block */
 	ORC_HCS *pHCB;
@@ -1198,7 +1172,7 @@
 } 
 
 static struct pci_device_id inia100_pci_tbl[] = {
-	{ORC_VENDOR_ID, ORC_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_INIT, 0x1060, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, inia100_pci_tbl);
===== drivers/scsi/a100u2w.h 1.19 vs edited =====
--- 1.19/drivers/scsi/a100u2w.h	2004-09-29 05:06:36 +02:00
+++ edited/drivers/scsi/a100u2w.h	2004-09-29 17:58:50 +02:00
@@ -1,4 +1,4 @@
-/**************************************************************************
+/*
  * Initio A100 device driver for Linux.
  *
  * Copyright (c) 1994-1998 Initio Corporation
@@ -50,27 +50,20 @@
  * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  * SUCH DAMAGE.
- *
- **************************************************************************
- *
- * Module: inia100.h
- * Description: INI-A100U2W LINUX device driver header
+ */
+
+/*
  * Revision History:
- *	06/18/98 HL, Initial production Version 1.02
- *	12/19/98 bv, Use spinlocks for 2.1.95 and up
- *	06/25/02 Doug Ledford <dledford@redhat.com>
- *		 - This and the i60uscsi.h file are almost identical,
- *		   merged them into a single header used by both .c files.
- ****************************************************************************/
-
-#include <linux/config.h>
-#include <linux/types.h>
-#include <linux/pci.h>
+ * 06/18/98 HL, Initial production Version 1.02
+ * 12/19/98 bv, Use spinlocks for 2.1.95 and up
+ * 06/25/02 Doug Ledford <dledford@redhat.com>
+ *	 - This and the i60uscsi.h file are almost identical,
+ *	   merged them into a single header used by both .c files.
+ */
 
 #define inia100_REVID "Initio INI-A100U2W SCSI device driver; Revision: 1.02d"
 
 #define ULONG   unsigned long
-#define PVOID   void *
 #define USHORT  unsigned short
 #define UCHAR   unsigned char
 #define BYTE    unsigned char
@@ -81,9 +74,6 @@
 #define UDWORD  unsigned long
 #define U32     u32
 
-#ifndef FAILURE
-#define FAILURE  (-1)
-#endif
 #if 1
 #define ORC_MAXQUEUE		245
 #define ORC_MAXTAGS		64
@@ -96,9 +86,6 @@
 #define MAX_TARGETS		16
 #define IMAX_CDB			15
 #define SENSE_SIZE		14
-#define SUCCESSFUL              0x00
-
-#define I920_DEVICE_ID	0x0002	/* Initio's inic-950 product ID   */
 
 /************************************************************************/
 /*              Scatter-Gather Element Structure                        */
@@ -120,23 +107,6 @@
 #define TCF_DRV_255_63     0x0400
 
 /********************************************************/
-/*      Orchid Configuration Register Set               */
-/********************************************************/
-#define ORC_PVID	0x00	/* Vendor ID                      */
-#define ORC_VENDOR_ID	0x1101	/* Orchid vendor ID               */
-#define ORC_PDID        0x02	/* Device ID                    */
-#define ORC_DEVICE_ID	0x1060	/* Orchid device ID               */
-#define ORC_COMMAND	0x04	/* Command                        */
-#define BUSMS		0x04	/* BUS MASTER Enable              */
-#define IOSPA		0x01	/* IO Space Enable                */
-#define ORC_STATUS	0x06	/* Status register                */
-#define ORC_REVISION	0x08	/* Revision number                */
-#define ORC_BASE	0x10	/* Base address                   */
-#define ORC_BIOS	0x50	/* Expansion ROM base address     */
-#define ORC_INT_NUM	0x3C	/* Interrupt line         */
-#define ORC_INT_PIN	0x3D	/* Interrupt pin          */
-
-/********************************************************/
 /*      Orchid Host Command Set                         */
 /********************************************************/
 #define ORC_CMD_NOP		0x00	/* Host command - NOP             */
@@ -265,27 +235,6 @@
 #define TARGET_TAG_FULL	0x28
 
 
-/* Queue tag msg: Simple_quque_tag, Head_of_queue_tag, Ordered_queue_tag */
-#define MSG_STAG	0x20
-#define MSG_HTAG	0x21
-#define MSG_OTAG	0x22
-
-#define MSG_IGNOREWIDE	0x23
-
-#define MSG_IDENT	0x80
-#define MSG_DISC	0x40	/* Disconnect allowed             */
-
-
-/* SCSI MESSAGE */
-#define	MSG_EXTEND	0x01
-#define	MSG_SDP		0x02
-#define	MSG_ABORT	0x06
-#define	MSG_REJ		0x07
-#define	MSG_NOP		0x08
-#define	MSG_PARITY	0x09
-#define	MSG_DEVRST	0x0C
-#define	MSG_STAG	0x20
-
 /***********************************************************************
 		Target Device Control Structure
 **********************************************************************/
@@ -296,7 +245,7 @@
 	UBYTE TCS_DrvHead;	/* 8 */
 	UWORD TCS_DrvFlags;	/* 4 */
 	UBYTE TCS_DrvSector;	/* 7 */
-} ORC_TCS, *PORC_TCS;
+} ORC_TCS;
 
 /* Bit Definition for TCF_DrvFlags */
 #define	TCS_DF_NODASD_SUPT	0x20	/* Suppress OS/2 DASD Mgr support */
@@ -320,9 +269,9 @@
 	USHORT HCS_Units;	/* Number of units this adapter  */
 	USHORT HCS_AFlags;	/* Adapter info. defined flags   */
 	ULONG HCS_Timeout;	/* Adapter timeout value   */
-	PVOID HCS_virScbArray;	/* 28 Virtual Pointer to SCB array     */
+	ORC_SCB *HCS_virScbArray;	/* 28 Virtual Pointer to SCB array */
 	dma_addr_t HCS_physScbArray;	/* Scb Physical address */
-	PVOID HCS_virEscbArray;	/* Virtual pointer to ESCB Scatter list */
+	ESCB *HCS_virEscbArray;	/* Virtual pointer to ESCB Scatter list */
 	dma_addr_t HCS_physEscbArray;	/* scatter list Physical address */
 	UBYTE TargetFlag[16];	/* 30  target configuration, TCF_EN_TAG */
 	UBYTE MaximumTags[16];	/* 40  ORC_MAX_SCBS */
@@ -352,46 +301,6 @@
 #define	HCS_AF_DISABLE_RESET	0x10	/* Adapter disable reset  */
 #define	HCS_AF_DISABLE_ADPT	0x80	/* Adapter disable                */
 
-
-/*---------------------------------------*/
-/* TimeOut for RESET to complete (30s)   */
-/*                                       */
-/* After a RESET the drive is checked    */
-/* every 200ms.                          */
-/*---------------------------------------*/
-#define DELAYED_RESET_MAX       (30*1000L)
-#define DELAYED_RESET_INTERVAL  200L
-
-/*----------------------------------------------*/
-/* TimeOut for IRQ from last interrupt (5s)     */
-/*----------------------------------------------*/
-#define IRQ_TIMEOUT_INTERVAL    (5*1000L)
-
-/*----------------------------------------------*/
-/* Retry Delay interval (200ms)                 */
-/*----------------------------------------------*/
-#define DELAYED_RETRY_INTERVAL  200L
-
-#define	INQUIRY_SIZE		36
-#define	CAPACITY_SIZE		8
-#define	DEFAULT_SENSE_LEN	14
-
-#define	DEVICE_NOT_FOUND	0x86
-
-/*----------------------------------------------*/
-/* Definition for PCI device                    */
-/*----------------------------------------------*/
-#define	MAX_PCI_DEVICES	21
-#define	MAX_PCI_BUSES	8
-
-typedef struct Adpt_Struc {
-        USHORT ADPT_BIOS;       /* 0 */
-        UBYTE ADPT_BASE;        /* 1 */
-        UBYTE ADPT_Bus;         /* 2 */
-        UBYTE ADPT_Device;      /* 3 */
-        UBYTE ADPT_Reserved[3];
-} JACS, *PJACS;
-
 typedef struct _NVRAM {
 /*----------header ---------------*/
         UCHAR SubVendorID0;     /* 00 - Sub Vendor ID           */
@@ -498,33 +407,10 @@
 #define NCC_RESET_TIME  0x0A    /* SCSI RESET recovering time     */
 #define NTC_DEFAULT     (NTC_1GIGA | NTC_NO_WIDESYNC | NTC_DISC_ENABLE)
 
-typedef union {                 /* Union define for mechanism 1   */
-        struct {
-                unsigned char RegNum;
-                unsigned char FcnNum:3;
-                unsigned char DeviceNum:5;
-                unsigned char BusNum;
-                unsigned char Reserved:7;
-                unsigned char Enable:1;
-        } sConfigAdr;
-        unsigned long lConfigAdr;
-} CONFIG_ADR;
-
-typedef union {                 /* Union define for mechanism 2   */
-        struct {
-                unsigned char RegNum;
-                unsigned char DeviceNum;
-                unsigned short Reserved;
-        } sHostAdr;
-        unsigned long lHostAdr;
-} HOST_ADR;
-
 #define ORC_RD(x,y)             (UCHAR)(inb(  (int)((ULONG)((ULONG)x+(UCHAR)y)) ))
+#define ORC_RDWORD(x,y)         (short)(inl((int)((ULONG)((ULONG)x+(UCHAR)y)) ))
 #define ORC_RDLONG(x,y)         (long)(inl((int)((ULONG)((ULONG)x+(UCHAR)y)) ))
 
 #define ORC_WR(     adr,data)   outb( (UCHAR)(data), (int)(adr))
 #define ORC_WRSHORT(adr,data)   outw( (UWORD)(data), (int)(adr))
 #define ORC_WRLONG( adr,data)   outl( (ULONG)(data), (int)(adr))
-
-
-
