From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] initio: remove obsolete APIs, cleanup
Date: Wed, 29 Sep 2004 13:54:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929115439.GA26602@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:54989 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268326AbUI2Lyn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 07:54:43 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

This patch has the usual cleanups for the initio driver:

 - remove scsi.h APIs
 - add missing statics
 - remove the trivial internal queuing for the srb allocation failure case

but while doing that I noticed that the two source files use completely
different headers, and the interface between the two files often casted
to generic types just to cast it back to a separate defintion of the
same type again.  In one case the structures were even mismatching, but
because we allocated the bigger defintion and only passed pointers
around it actually worked..

Thanks to Rodrigo Severo for testing this patch.


--- 1.7/drivers/scsi/i91uscsi.c	2004-03-31 15:38:53 +02:00
+++ edited/drivers/scsi/i91uscsi.c	2004-09-06 18:57:46 +02:00
@@ -1,5 +1,4 @@
 /**************************************************************************
- * Initio 9100 device driver for Linux.
  *
  * Copyright (c) 1994-1998 Initio Corporation
  * Copyright (c) 1998 Bas Vermeulen <bvermeul@blackstar.xs4all.nl>
@@ -84,6 +83,8 @@
 #include <linux/blkdev.h>
 #include <asm/io.h>
 
+#include <scsi/scsi.h>
+
 #include "i91uscsi.h"
 
 /*--- external functions --*/
@@ -499,7 +500,7 @@
 		if (i91u_adpt[i].ADPT_BIOS == wBIOS) {
 			if (i91u_adpt[i].ADPT_BASE == wBASE) {
 				if (i91u_adpt[i].ADPT_Bus != 0xFF)
-					return (FAILURE);
+					return 1;
 			} else if (i91u_adpt[i].ADPT_BASE < wBASE)
 					continue;
 		}
@@ -515,9 +516,9 @@
 		i91u_adpt[i].ADPT_BIOS = wBIOS;
 		i91u_adpt[i].ADPT_Bus = bBus;
 		i91u_adpt[i].ADPT_Device = bDevice;
-		return (SUCCESSFUL);
+		return 0;
 	}
-	return (FAILURE);
+	return 1;
 }
 
 void init_i91uAdapter_table(void)
@@ -977,7 +978,7 @@
 }
 
 /***************************************************************************/
-int tul_abort_srb(HCS * pCurHcb, ULONG srbp)
+int tul_abort_srb(HCS * pCurHcb, struct scsi_cmnd *srbp)
 {
 	ULONG flags;
 	SCB *pTmpScb, *pPrevScb;
@@ -1004,7 +1005,7 @@
 	pPrevScb = pTmpScb = pCurHcb->HCS_FirstPend;	/* Check Pend queue */
 	while (pTmpScb != NULL) {
 		/* 07/27/98 */
-		if (pTmpScb->SCB_Srb == (unsigned char *) srbp) {
+		if (pTmpScb->SCB_Srb == srbp) {
 			if (pTmpScb == pCurHcb->HCS_ActScb) {
 				spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
 				return SCSI_ABORT_BUSY;
@@ -1030,7 +1031,7 @@
 	pPrevScb = pTmpScb = pCurHcb->HCS_FirstBusy;	/* Check Busy queue */
 	while (pTmpScb != NULL) {
 
-		if (pTmpScb->SCB_Srb == (unsigned char *) srbp) {
+		if (pTmpScb->SCB_Srb == srbp) {
 
 			if (pTmpScb == pCurHcb->HCS_ActScb) {
 				spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
@@ -1087,7 +1088,8 @@
 }
 
 /************************************************************************/
-int tul_device_reset(HCS * pCurHcb, ULONG pSrb, unsigned int target, unsigned int ResetFlags)
+int tul_device_reset(HCS * pCurHcb, struct scsi_cmnd *pSrb,
+		unsigned int target, unsigned int ResetFlags)
 {
 	ULONG flags;
 	SCB *pScb;
@@ -1114,7 +1116,7 @@
 		}
 		pScb = pCurHcb->HCS_FirstBusy;	/* Check Busy queue */
 		while (pScb != NULL) {
-			if (pScb->SCB_Srb == (unsigned char *) pSrb)
+			if (pScb->SCB_Srb == pSrb)
 				break;
 			pScb = pScb->SCB_NxtScb;
 		}
@@ -1136,7 +1138,7 @@
 
 	pScb->SCB_Srb = 0;
 	if (ResetFlags & SCSI_RESET_SYNCHRONOUS) {
-		pScb->SCB_Srb = (unsigned char *) pSrb;
+		pScb->SCB_Srb = pSrb;
 	}
 	tul_push_pend_scb(pCurHcb, pScb);	/* push this SCB to Pending queue */
 
@@ -1251,7 +1253,7 @@
 		tulip_scsi(pCurHcb);	/* Call tulip_scsi              */
 
 		while ((pCurScb = tul_find_done_scb(pCurHcb)) != NULL) {	/* find done entry */
-			if (pCurScb->SCB_TaStat == QUEUE_FULL) {
+			if (pCurScb->SCB_TaStat == INI_QUEUE_FULL) {
 				pCurHcb->HCS_MaxTags[pCurScb->SCB_Target] =
 				    pCurHcb->HCS_ActTags[pCurScb->SCB_Target] - 1;
 				pCurScb->SCB_TaStat = 0;
@@ -1409,11 +1411,7 @@
 			}
 		}
 	} else if (pCurScb->SCB_Opcode == AbortCmd) {
-		ULONG srbp;
-
-		srbp = (ULONG) pCurScb->SCB_Srb;
-/* 08/03/98 */
-		if (tul_abort_srb(pCurHcb, srbp) != 0) {
+		if (tul_abort_srb(pCurHcb, pCurScb->SCB_Srb) != 0) {
 
 
 			tul_unlink_pend_scb(pCurHcb, pCurScb);
===== drivers/scsi/i91uscsi.h 1.5 vs edited =====
--- 1.5/drivers/scsi/i91uscsi.h	2003-09-02 02:20:32 +02:00
+++ edited/drivers/scsi/i91uscsi.h	2004-09-06 18:57:46 +02:00
@@ -53,6 +53,7 @@
  *
  **************************************************************************/
 
+
 #include <linux/config.h>
 #include <linux/types.h>
 
@@ -67,22 +68,11 @@
 #define UDWORD  unsigned long
 #define U32     u32
 
-#ifndef FAILURE
-#define FAILURE  (-1)
-#endif
-
 #define TOTAL_SG_ENTRY		32
 #define MAX_SUPPORTED_ADAPTERS  8
 #define MAX_OFFSET		15
 #define MAX_TARGETS		16
 
-#define INI_VENDOR_ID   0x1101	/* Initio's PCI vendor ID       */
-#define I950_DEVICE_ID	0x9500	/* Initio's inic-950 product ID   */
-#define I940_DEVICE_ID	0x9400	/* Initio's inic-940 product ID   */
-#define I935_DEVICE_ID	0x9401	/* Initio's inic-935 product ID   */
-
-#define	_I91USCSI_H
-
 typedef struct {
 	unsigned short base;
 	unsigned short vec;
@@ -423,7 +413,7 @@
 	U32 SCB_SGPAddr;	/*44 SG List/Sense Buf phy. Addr. */
 	U32 SCB_SensePtr;	/*48 Sense data pointer */
 	void (*SCB_Post) (BYTE *, BYTE *);	/*4C POST routine */
-	unsigned char *SCB_Srb;	/*50 SRB Pointer */
+	struct scsi_cmnd *SCB_Srb;	/*50 SRB Pointer */
 	SG SCB_SGList[TOTAL_SG_ENTRY];	/*54 Start of SG list */
 } SCB;
 
@@ -472,7 +462,7 @@
 /* Error Codes for SCB_TaStat */
 #define TARGET_CHKCOND  0x02
 #define TARGET_BUSY     0x08
-#define QUEUE_FULL	0x28
+#define INI_QUEUE_FULL	0x28
 
 /* SCSI MESSAGE */
 #define MSG_COMP        0x00
@@ -586,11 +576,9 @@
 	UBYTE HCS_MaxTags[16];	/* 58 */
 	UBYTE HCS_ActTags[16];	/* 68 */
 	TCS HCS_Tcs[MAX_TARGETS];	/* 78 */
-	ULONG pSRB_head;	/* SRB save queue header     */
-	ULONG pSRB_tail;	/* SRB save queue tail       */
 	spinlock_t HCS_AvailLock;
 	spinlock_t HCS_SemaphLock;
-	spinlock_t pSRB_lock;	/* SRB queue lock            */
+	struct pci_dev *pci_dev;
 } HCS;
 
 /* Bit Definition for HCB_Config */
@@ -694,117 +682,6 @@
 #define DISC_ALLOW              0xC0	/* Disconnect is allowed        */
 #define SCSICMD_RequestSense    0x03
 
-
-/*----------------------------------------------------------------------*/
-/*                              PCI                                     */
-/*----------------------------------------------------------------------*/
-#define PCI_FUNCTION_ID         0xB1
-#define PCI_BIOS_PRESENT        0x01
-#define FIND_PCI_DEVICE         0x02
-#define FIND_PCI_CLASS_CODE     0x03
-#define GENERATE_SPECIAL_CYCLE  0x06
-#define READ_CONFIG_BYTE        0x08
-#define READ_CONFIG_WORD        0x09
-#define READ_CONFIG_DWORD       0x0A
-#define WRITE_CONFIG_BYTE       0x0B
-#define WRITE_CONFIG_WORD       0x0C
-#define WRITE_CONFIG_DWORD      0x0D
-
-#define SUCCESSFUL              0x00
-#define FUNC_NOT_SUPPORTED      0x81
-#define BAD_VENDOR_ID           0x83	/* Bad vendor ID                */
-#define DEVICE_NOT_FOUND        0x86	/* PCI device not found         */
-#define BAD_REGISTER_NUMBER     0x87
-
-#define MAX_PCI_DEVICES         21	/* Maximum devices supportted   */
-
-#define MAX_PCI_CHANL           4
-
-typedef struct _BIOS32_ENTRY_STRUCTURE {
-	DWORD Signatures;	/* Should be "_32_"             */
-	DWORD BIOS32Entry;	/* 32-bit physical address      */
-	BYTE Revision;		/* Revision level, should be 0  */
-	BYTE Length;		/* Multiply of 16, should be 1  */
-	BYTE CheckSum;		/* Checksum of whole structure  */
-	BYTE Reserved[5];	/* Reserved                     */
-} BIOS32_ENTRY_STRUCTURE, *PBIOS32_ENTRY_STRUCTURE;
-
-typedef struct {
-	union {
-		unsigned int eax;
-		struct {
-			unsigned short ax;
-		} word;
-		struct {
-			unsigned char al;
-			unsigned char ah;
-		} byte;
-	} eax;
-	union {
-		unsigned int ebx;
-		struct {
-			unsigned short bx;
-		} word;
-		struct {
-			unsigned char bl;
-			unsigned char bh;
-		} byte;
-	} ebx;
-	union {
-		unsigned int ecx;
-		struct {
-			unsigned short cx;
-		} word;
-		struct {
-			unsigned char cl;
-			unsigned char ch;
-		} byte;
-	} ecx;
-	union {
-		unsigned int edx;
-		struct {
-			unsigned short dx;
-		} word;
-		struct {
-			unsigned char dl;
-			unsigned char dh;
-		} byte;
-	} edx;
-	union {
-		unsigned int edi;
-		struct {
-			unsigned short di;
-		} word;
-	} edi;
-	union {
-		unsigned int esi;
-		struct {
-			unsigned short si;
-		} word;
-	} esi;
-} REGS;
-
-typedef union {			/* Union define for mechanism 1 */
-	struct {
-		unsigned char RegNum;
-		unsigned char FcnNum:3;
-		unsigned char DeviceNum:5;
-		unsigned char BusNum;
-		unsigned char Reserved:7;
-		unsigned char Enable:1;
-	} sConfigAdr;
-	unsigned long lConfigAdr;
-} CONFIG_ADR;
-
-typedef union {			/* Union define for mechanism 2 */
-	struct {
-		unsigned char RegNum;
-		unsigned char DeviceNum;
-		unsigned short Reserved;
-	} sHostAdr;
-	unsigned long lHostAdr;
-} HOST_ADR;
-
 typedef struct _HCSinfo {
 	ULONG base;
 	UCHAR vec;
@@ -841,3 +718,22 @@
 #define SCSI_RESET_BUS_RESET 0x100
 #define SCSI_RESET_HOST_RESET 0x200
 #define SCSI_RESET_ACTION   0xff
+
+extern void init_i91uAdapter_table(void);
+extern int Addi91u_into_Adapter_table(WORD, WORD, BYTE, BYTE, BYTE);
+extern int tul_ReturnNumberOfAdapters(void);
+extern void get_tulipPCIConfig(HCS * pHCB, int iChannel_index);
+extern int init_tulip(HCS * pHCB, SCB * pSCB, int tul_num_scb, BYTE * pbBiosAdr, int reset_time);
+extern SCB *tul_alloc_scb(HCS * pHCB);
+extern int tul_abort_srb(HCS * pHCB, struct scsi_cmnd * pSRB);
+extern void tul_exec_scb(HCS * pHCB, SCB * pSCB);
+extern void tul_release_scb(HCS * pHCB, SCB * pSCB);
+extern void tul_stop_bm(HCS * pHCB);
+extern int tul_reset_scsi(HCS * pCurHcb, int seconds);
+extern int tul_isr(HCS * pHCB);
+extern int tul_reset(HCS * pHCB, struct scsi_cmnd * pSRB, unsigned char target);
+extern int tul_reset_scsi_bus(HCS * pCurHcb);
+extern int tul_device_reset(HCS * pCurHcb, struct scsi_cmnd *pSrb,
+		unsigned int target, unsigned int ResetFlags);
+				/* ---- EXTERNAL VARIABLES ---- */
+extern HCS tul_hcs[];
--- 1.24/drivers/scsi/ini9100u.c	2004-05-12 17:46:21 +02:00
+++ edited/drivers/scsi/ini9100u.c	2004-09-06 18:57:46 +02:00
@@ -110,12 +110,6 @@
  *		- Re-add reset_bus support
  **************************************************************************/
 
-#define CVT_LINUX_VERSION(V,P,S)        (V * 65536 + P * 256 + S)
-
-#ifndef LINUX_VERSION_CODE
-#include <linux/version.h>
-#endif
-
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
@@ -132,45 +126,39 @@
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-
 #include <asm/io.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
-#include "ini9100u.h"
+#include <scsi/scsi_tcq.h>
 
-#ifdef DEBUG_i91u
-unsigned int i91u_debug = DEBUG_DEFAULT;
-#endif
+#include "i91uscsi.h"
 
-static Scsi_Host_Template driver_template = {
-	.proc_name	= "INI9100U",
-	.name		= i91u_REVID,
-	.detect		= i91u_detect,
-	.release	= i91u_release,
-	.queuecommand	= i91u_queue,
-//	.abort		= i91u_abort,
-//	.reset		= i91u_reset,
-	.eh_bus_reset_handler = i91u_bus_reset,
-	.bios_param	= i91u_biosparam,
-	.can_queue	= 1,
-	.this_id	= 1,
-	.sg_tablesize	= SG_ALL,
-	.cmd_per_lun 	= 1,
-	.use_clustering	= ENABLE_CLUSTERING,
-};
-#include "scsi_module.c"
+#define SENSE_SIZE		14
 
-char *i91uCopyright = "Copyright (C) 1996-98";
-char *i91uInitioName = "by Initio Corporation";
-char *i91uProductName = "INI-9X00U/UW";
-char *i91uVersion = "v1.04a";
+#define i91u_MAXQUEUE		2
+#define i91u_REVID "Initio INI-9X00U/UW SCSI device driver; Revision: 1.04a"
+
+#define INI_VENDOR_ID   0x1101	/* Initio's PCI vendor ID       */
+#define DMX_VENDOR_ID	0x134a	/* Domex's PCI vendor ID	*/
+#define I950_DEVICE_ID	0x9500	/* Initio's inic-950 product ID   */
+#define I940_DEVICE_ID	0x9400	/* Initio's inic-940 product ID   */
+#define I935_DEVICE_ID	0x9401	/* Initio's inic-935 product ID   */
+#define I920_DEVICE_ID	0x0002	/* Initio's other product ID      */
+
+#ifdef DEBUG_i91u
+static unsigned int i91u_debug = DEBUG_DEFAULT;
+#endif
 
 #define TULSZ(sz)     (sizeof(sz) / sizeof(sz[0]))
 #define TUL_RDWORD(x,y)         (short)(inl((int)((ULONG)((ULONG)x+(UCHAR)y)) ))
 
-/* set by i91_setup according to the command line */
-static int setup_called = 0;
+typedef struct PCI_ID_Struc {
+	unsigned short vendor_id;
+	unsigned short device_id;
+} PCI_ID;
 
 static int tul_num_ch = 4;	/* Maximum 4 adapters           */
 static int tul_num_scb;
@@ -181,33 +169,12 @@
 static int setup_debug = 0;
 #endif
 
-static char *setup_str = (char *) NULL;
-
-static void i91u_panic(char *msg);
-
 static void i91uSCBPost(BYTE * pHcb, BYTE * pScb);
 
 				/* ---- EXTERNAL FUNCTIONS ---- */
 					/* Get total number of adapters */
-extern void init_i91uAdapter_table(void);
-extern int Addi91u_into_Adapter_table(WORD, WORD, BYTE, BYTE, BYTE);
-extern int tul_ReturnNumberOfAdapters(void);
-extern void get_tulipPCIConfig(HCS * pHCB, int iChannel_index);
-extern int init_tulip(HCS * pHCB, SCB * pSCB, int tul_num_scb, BYTE * pbBiosAdr, int reset_time);
-extern SCB *tul_alloc_scb(HCS * pHCB);
-extern int tul_abort_srb(HCS * pHCB, Scsi_Cmnd * pSRB);
-extern void tul_exec_scb(HCS * pHCB, SCB * pSCB);
-extern void tul_release_scb(HCS * pHCB, SCB * pSCB);
-extern void tul_stop_bm(HCS * pHCB);
-extern int tul_reset_scsi(HCS * pCurHcb, int seconds);
-extern int tul_isr(HCS * pHCB);
-extern int tul_reset(HCS * pHCB, Scsi_Cmnd * pSRB, unsigned char target);
-extern int tul_reset_scsi_bus(HCS * pCurHcb);
-extern int tul_device_reset(HCS * pCurHcb, ULONG pSrb, unsigned int target, unsigned int ResetFlags);
-				/* ---- EXTERNAL VARIABLES ---- */
-extern HCS tul_hcs[];
 
-const PCI_ID i91u_pci_devices[] = {
+static const PCI_ID i91u_pci_devices[] = {
 	{ INI_VENDOR_ID, I950_DEVICE_ID },
 	{ INI_VENDOR_ID, I940_DEVICE_ID },
 	{ INI_VENDOR_ID, I935_DEVICE_ID },
@@ -215,57 +182,6 @@
 	{ DMX_VENDOR_ID, I920_DEVICE_ID },
 };
 
-/*
- *  queue services:
- */
-/*****************************************************************************
- Function name  : i91uAppendSRBToQueue
- Description    : This function will push current request into save list
- Input          : pSRB  -       Pointer to SCSI request block.
-		  pHCB  -       Pointer to host adapter structure
- Output         : None.
- Return         : None.
-*****************************************************************************/
-static void i91uAppendSRBToQueue(HCS * pHCB, Scsi_Cmnd * pSRB)
-{
-	ULONG flags;
-	spin_lock_irqsave(&(pHCB->pSRB_lock), flags);
-
-	pSRB->host_scribble = NULL;	/* Pointer to next */
-
-	if (pHCB->pSRB_head == NULL)
-		pHCB->pSRB_head = pSRB;
-	else
-		pHCB->pSRB_tail->host_scribble = (char *)pSRB;	/* Pointer to next */
-	pHCB->pSRB_tail = pSRB;
-
-	spin_unlock_irqrestore(&(pHCB->pSRB_lock), flags);
-	return;
-}
-
-/*****************************************************************************
- Function name  : i91uPopSRBFromQueue
- Description    : This function will pop current request from save list
- Input          : pHCB  -       Pointer to host adapter structure
- Output         : None.
- Return         : pSRB  -       Pointer to SCSI request block.
-*****************************************************************************/
-static Scsi_Cmnd *i91uPopSRBFromQueue(HCS * pHCB)
-{
-	Scsi_Cmnd *pSRB;
-	ULONG flags;
-
-	spin_lock_irqsave(&(pHCB->pSRB_lock), flags);
-
-	if ((pSRB = pHCB->pSRB_head) != NULL) {
-		pHCB->pSRB_head = (struct scsi_cmnd *)pHCB->pSRB_head->host_scribble;
-		pSRB->host_scribble = NULL;
-	}
-	spin_unlock_irqrestore(&(pHCB->pSRB_lock), flags);
-
-	return (pSRB);
-}
-
 static irqreturn_t i91u_intr(int irqno, void *dev_id, struct pt_regs *regs)
 {
 	struct Scsi_Host *dev = dev_id;
@@ -277,22 +193,7 @@
 	return IRQ_HANDLED;
 }
 
-/* called from init/main.c */
-
-void i91u_setup(char *str, int *ints)
-{
-	if (setup_called)
-		i91u_panic("i91u: i91u_setup called twice.\n");
-
-	setup_called = ints[0];
-	setup_str = str;
-
-#ifdef DEBUG_i91u
-	setup_debug = ints[0] >= 1 ? ints[1] : DEBUG_DEFAULT;
-#endif
-}
-
-int tul_NewReturnNumberOfAdapters(void)
+static int tul_NewReturnNumberOfAdapters(void)
 {
 	struct pci_dev *pDev = NULL;	/* Start from none              */
 	int iAdapters = 0;
@@ -331,7 +232,7 @@
 	return (iAdapters);
 }
 
-int i91u_detect(Scsi_Host_Template * tpnt)
+static int i91u_detect(struct scsi_host_template * tpnt)
 {
 	HCS *pHCB;
 	struct Scsi_Host *hreg;
@@ -340,20 +241,6 @@
 	ULONG dBiosAdr;
 	BYTE *pbBiosAdr;
 
-	tpnt->proc_name = "INI9100U";
-
-	if (setup_called) {	/* Setup by i91u_setup          */
-		printk("i91u: processing commandline: ");
-
-#ifdef DEBUG_i91u
-		if (setup_called > 1) {
-			printk("\ni91u: %s\n", setup_str);
-			printk("i91u: usage: i91u[=<DEBUG>]\n");
-			i91u_panic("i91u panics in line %d", __LINE__);
-		}
-		i91u_debug = setup_debug;
-#endif
-	}
 	/* Get total number of adapters in the motherboard */
 	iAdapters = tul_NewReturnNumberOfAdapters();
 	if (iAdapters == 0)	/* If no tulip founded, return */
@@ -386,9 +273,6 @@
 	for (i = 0, pHCB = &tul_hcs[0];		/* Get pointer for control block */
 	     i < tul_num_ch;
 	     i++, pHCB++) {
-		pHCB->pSRB_head = NULL;		/* Initial SRB save queue       */
-		pHCB->pSRB_tail = NULL;		/* Initial SRB save queue       */
-		pHCB->pSRB_lock = SPIN_LOCK_UNLOCKED;	/* SRB save queue lock */
 		get_tulipPCIConfig(pHCB, i);
 
 		dBiosAdr = pHCB->HCS_BIOS;
@@ -430,7 +314,7 @@
 	return 1;
 }
 
-static void i91uBuildSCB(HCS * pHCB, SCB * pSCB, Scsi_Cmnd * SCpnt)
+static void i91uBuildSCB(HCS * pHCB, SCB * pSCB, struct scsi_cmnd * SCpnt)
 {				/* Create corresponding SCB     */
 	struct scatterlist *pSrbSG;
 	SG *pSG;		/* Pointer to SG list           */
@@ -498,38 +382,29 @@
 	}
 }
 
-/* 
- *  Queue a command and setup interrupts for a free bus.
- */
-int i91u_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
+static int i91u_queuecommand(struct scsi_cmnd *cmd,
+		void (*done)(struct scsi_cmnd *))
 {
+	HCS *pHCB = (HCS *) cmd->device->host->base;
 	register SCB *pSCB;
-	HCS *pHCB;		/* Point to Host adapter control block */
 
-	if (SCpnt->device->lun > 16) {	/* 07/22/98 */
+	cmd->scsi_done = done;
 
-		SCpnt->result = (DID_TIME_OUT << 16);
-		done(SCpnt);	/* Notify system DONE           */
-		return (0);
-	}
-	pHCB = (HCS *) SCpnt->device->host->base;
+	pSCB = tul_alloc_scb(pHCB);
+	if (!pSCB)
+		return SCSI_MLQUEUE_HOST_BUSY;
 
-	SCpnt->scsi_done = done;
-	/* Get free SCSI control block  */
-	if ((pSCB = tul_alloc_scb(pHCB)) == NULL) {
-		i91uAppendSRBToQueue(pHCB, SCpnt);	/* Buffer this request  */
-		return (0);
-	}
-	i91uBuildSCB(pHCB, pSCB, SCpnt);
-	tul_exec_scb(pHCB, pSCB);	/* Start execute SCB            */
-	return (0);
+	i91uBuildSCB(pHCB, pSCB, cmd);
+	tul_exec_scb(pHCB, pSCB);
+	return 0;
 }
 
+#if 0 /* no new EH yet */
 /*
  *  Abort a queued command
  *  (commands that are on the bus can't be aborted easily)
  */
-int i91u_abort(Scsi_Cmnd * SCpnt)
+static int i91u_abort(struct scsi_cmnd * SCpnt)
 {
 	HCS *pHCB;
 
@@ -541,7 +416,7 @@
  *  Reset registers, reset a hanging bus and
  *  kill active and disconnected commands for target w/o soft reset
  */
-int i91u_reset(Scsi_Cmnd * SCpnt, unsigned int reset_flags)
+static int i91u_reset(struct scsi_cmnd * SCpnt, unsigned int reset_flags)
 {				/* I need Host Control Block Information */
 	HCS *pHCB;
 
@@ -550,10 +425,11 @@
 	if (reset_flags & (SCSI_RESET_SUGGEST_BUS_RESET | SCSI_RESET_SUGGEST_HOST_RESET))
 		return tul_reset_scsi_bus(pHCB);
 	else
-		return tul_device_reset(pHCB, (ULONG) SCpnt, SCpnt->device->id, reset_flags);
+		return tul_device_reset(pHCB, SCpnt, SCpnt->device->id, reset_flags);
 }
+#endif
 
-int i91u_bus_reset(Scsi_Cmnd * SCpnt)
+static int i91u_bus_reset(struct scsi_cmnd * SCpnt)
 {
 	HCS *pHCB;
 
@@ -565,7 +441,7 @@
 /*
  * Return the "logical geometry"
  */
-int i91u_biosparam(struct scsi_device *sdev, struct block_device *dev,
+static int i91u_biosparam(struct scsi_device *sdev, struct block_device *dev,
 		sector_t capacity, int *info_array)
 {
 	HCS *pHcb;		/* Point to Host adapter control block */
@@ -607,7 +483,7 @@
 	if (cmnd->SCp.ptr) {
 		dma_unmap_single(&pci_dev->dev,
 				 (dma_addr_t)((unsigned long)cmnd->SCp.ptr),
-				 SENSE_SIZE, SCSI_DATA_READ);
+				 SENSE_SIZE, DMA_FROM_DEVICE);
 		cmnd->SCp.ptr = NULL;
 	}
 
@@ -638,7 +514,7 @@
 *****************************************************************************/
 static void i91uSCBPost(BYTE * pHcb, BYTE * pScb)
 {
-	Scsi_Cmnd *pSRB;	/* Pointer to SCSI request block */
+	struct scsi_cmnd *pSRB;	/* Pointer to SCSI request block */
 	HCS *pHCB;
 	SCB *pSCB;
 
@@ -693,35 +569,36 @@
 
 	i91u_unmap_cmnd(pHCB->pci_dev, pSRB);
 	pSRB->scsi_done(pSRB);	/* Notify system DONE           */
-	if ((pSRB = i91uPopSRBFromQueue(pHCB)) != NULL)
-		/* Find the next pending SRB    */
-	{			/* Assume resend will success   */
-		/* Reuse old SCB                */
-		i91uBuildSCB(pHCB, pSCB, pSRB);		/* Create corresponding SCB     */
 
-		tul_exec_scb(pHCB, pSCB);	/* Start execute SCB            */
-	} else {		/* No Pending SRB               */
-		tul_release_scb(pHCB, pSCB);	/* Release SCB for current channel */
-	}
-	return;
-}
-
-/* 
- * Dump the current driver status and panic...
- */
-static void i91u_panic(char *msg)
-{
-	printk("\ni91u_panic: %s\n", msg);
-	panic("i91u panic");
+	tul_release_scb(pHCB, pSCB);	/* Release SCB for current channel */
 }
 
 /*
  * Release ressources
  */
-int i91u_release(struct Scsi_Host *hreg)
+static int i91u_release(struct Scsi_Host *hreg)
 {
 	free_irq(hreg->irq, hreg);
 	release_region(hreg->io_port, 256);
 	return 0;
 }
 MODULE_LICENSE("Dual BSD/GPL");
+
+static struct scsi_host_template driver_template = {
+	.proc_name	= "INI9100U",
+	.name		= i91u_REVID,
+	.detect		= i91u_detect,
+	.release	= i91u_release,
+	.queuecommand	= i91u_queuecommand,
+//	.abort		= i91u_abort,
+//	.reset		= i91u_reset,
+	.eh_bus_reset_handler = i91u_bus_reset,
+	.bios_param	= i91u_biosparam,
+	.can_queue	= 1,
+	.this_id	= 1,
+	.sg_tablesize	= SG_ALL,
+	.cmd_per_lun 	= 1,
+	.use_clustering	= ENABLE_CLUSTERING,
+};
+#include "scsi_module.c"
+
===== drivers/scsi/ini9100u.h 1.12 vs edited =====
--- 1.12/drivers/scsi/ini9100u.h	2004-04-30 20:39:30 +02:00
+++ edited/drivers/scsi/ini9100u.h	2004-09-06 18:57:46 +02:00
@@ -1,251 +0,0 @@
-/**************************************************************************
- * Initio 9100 device driver for Linux.
- *
- * Copyright (c) 1994-1998 Initio Corporation
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.  If not, write to
- * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- * --------------------------------------------------------------------------
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions, and the following disclaimer,
- *    without modification, immediately at the beginning of the file.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- * 3. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
- *
- * Where this Software is combined with software released under the terms of 
- * the GNU General Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
- *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
- *
- *************************************************************************
- *
- * Module: ini9100u.h
- * Description: INI-9100U/UW LINUX device driver header
- * Revision History:
- * 06/18/96 Harry Chen, Initial Version 1.00A (Beta)
- * 06/23/98 hc	- v1.01k
- *		- Get it work for kernel version >= 2.1.75
- * 12/09/98 bv	- v1.03a
- *		- Removed unused code
- * 12/13/98 bv	- v1.03b
- *		- Add spinlocks to HCS structure.
- * 21/01/99 bv	- v1.03e
- *		- Added PCI_ID structure
- **************************************************************************/
-
-#ifndef	CVT_LINUX_VERSION
-#define	CVT_LINUX_VERSION(V,P,S)	(((V) * 65536) + ((P) * 256) + (S))
-#endif
-
-#ifndef	LINUX_VERSION_CODE
-#include <linux/version.h>
-#endif
-#include <linux/types.h>
-
-extern int i91u_detect(Scsi_Host_Template *);
-extern int i91u_release(struct Scsi_Host *);
-extern int i91u_command(Scsi_Cmnd *);
-extern int i91u_queue(Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
-extern int i91u_abort(Scsi_Cmnd *);
-extern int i91u_reset(Scsi_Cmnd *, unsigned int);
-extern int i91u_bus_reset(Scsi_Cmnd *);
-extern int i91u_biosparam(struct scsi_device *, struct block_device *,
-		sector_t, int *);
-
-#define i91u_REVID "Initio INI-9X00U/UW SCSI device driver; Revision: 1.04a"
-
-#define VIRT_TO_BUS(i)  (unsigned int) virt_to_bus((void *)(i))
-#define ULONG   unsigned long
-#define USHORT  unsigned short
-#define UCHAR   unsigned char
-#define BYTE    u8
-#define WORD    unsigned short
-#define DWORD   unsigned long
-#define UBYTE   u8
-#define UWORD   unsigned short
-#define UDWORD  unsigned long
-#define U32   u32
-
-#ifndef TRUE
-#define TRUE     (1)		/* boolean true  */
-#endif
-#ifndef FALSE
-#define FALSE    (0)		/* boolean false */
-#endif
-#ifndef FAILURE
-#define FAILURE  (-1)
-#endif
-
-#define i91u_MAXQUEUE		2
-#define TOTAL_SG_ENTRY		32
-#define MAX_TARGETS		16
-#define SENSE_SIZE		14
-
-#define INI_VENDOR_ID   0x1101	/* Initio's PCI vendor ID       */
-#define DMX_VENDOR_ID	0x134a	/* Domex's PCI vendor ID	*/
-#define I950_DEVICE_ID	0x9500	/* Initio's inic-950 product ID   */
-#define I940_DEVICE_ID	0x9400	/* Initio's inic-940 product ID   */
-#define I935_DEVICE_ID	0x9401	/* Initio's inic-935 product ID   */
-#define I920_DEVICE_ID	0x0002	/* Initio's other product ID      */
-
-/************************************************************************/
-/*              Vendor ID/Device ID Pair Structure			*/
-/************************************************************************/
-typedef struct PCI_ID_Struc {
-	unsigned short vendor_id;
-	unsigned short device_id;
-} PCI_ID;
-
-/************************************************************************/
-/*              Scatter-Gather Element Structure                        */
-/************************************************************************/
-typedef struct SG_Struc {
-	U32 SG_Ptr;		/* Data Pointer */
-	U32 SG_Len;		/* Data Length */
-} SG;
-
-/***********************************************************************
-		SCSI Control Block
-************************************************************************/
-typedef struct Scsi_Ctrl_Blk {
-	U32 SCB_InitioReserved[9];	/* 0 */
-
-	UBYTE SCB_Opcode;	/*24 SCB command code */
-	UBYTE SCB_Flags;	/*25 SCB Flags */
-	UBYTE SCB_Target;	/*26 Target Id */
-	UBYTE SCB_Lun;		/*27 Lun */
-	U32 SCB_BufPtr;		/*28 Data Buffer Pointer */
-	U32 SCB_BufLen;		/*2C Data Allocation Length */
-	UBYTE SCB_SGLen;	/*30 SG list # */
-	UBYTE SCB_SenseLen;	/*31 Sense Allocation Length */
-	UBYTE SCB_HaStat;	/*32 */
-	UBYTE SCB_TaStat;	/*33 */
-	UBYTE SCB_CDBLen;	/*34 CDB Length */
-	UBYTE SCB_Ident;	/*35 Identify */
-	UBYTE SCB_TagMsg;	/*36 Tag Message */
-	UBYTE SCB_TagId;	/*37 Queue Tag */
-	UBYTE SCB_CDB[12];	/*38 */
-	U32 SCB_SGPAddr;	/*44 SG List/Sense Buf phy. Addr. */
-	U32 SCB_SensePtr;	/*48 Sense data pointer */
-	void (*SCB_Post) (BYTE *, BYTE *);	/*4C POST routine */
-	Scsi_Cmnd *SCB_Srb;	/*50 SRB Pointer */
-	SG SCB_SGList[TOTAL_SG_ENTRY];	/*54 Start of SG list */
-} SCB;
-
-/* Opcodes of SCB_Opcode */
-#define ExecSCSI        0x1
-#define BusDevRst       0x2
-#define AbortCmd        0x3
-
-/* Bit Definition for SCB_Flags */
-#define SCF_DONE        0x01
-#define SCF_POST        0x02
-#define SCF_SENSE       0x04
-#define SCF_DIR         0x18
-#define SCF_NO_DCHK     0x00
-#define SCF_DIN         0x08
-#define SCF_DOUT        0x10
-#define SCF_NO_XF       0x18
-#define SCF_POLL        0x40
-#define SCF_SG          0x80
-
-/* Error Codes for SCB_HaStat */
-#define HOST_SEL_TOUT   0x11
-#define HOST_DO_DU      0x12
-#define HOST_BUS_FREE   0x13
-#define HOST_BAD_PHAS   0x14
-#define HOST_INV_CMD    0x16
-#define HOST_SCSI_RST   0x1B
-#define HOST_DEV_RST    0x1C
-
-/* Error Codes for SCB_TaStat */
-#define TARGET_CHKCOND  0x02
-#define TARGET_BUSY     0x08
-
-/* Queue tag msg: Simple_quque_tag, Head_of_queue_tag, Ordered_queue_tag */
-#define MSG_STAG        0x20
-#define MSG_HTAG        0x21
-#define MSG_OTAG        0x22
-
-/***********************************************************************
-		Target Device Control Structure
-**********************************************************************/
-
-typedef struct Tar_Ctrl_Struc {
-	ULONG TCS_InitioReserved;	/* 0 */
-
-	UWORD TCS_DrvFlags;	/* 4 */
-	UBYTE TCS_DrvHead;	/* 6 */
-	UBYTE TCS_DrvSector;	/* 7 */
-} TCS;
-
-/***********************************************************************
-		Target Device Control Structure
-**********************************************************************/
-/* Bit Definition for TCF_DrvFlags */
-#define TCF_DRV_255_63          0x0400
-
-/***********************************************************************
-	      Host Adapter Control Structure
-************************************************************************/
-typedef struct Ha_Ctrl_Struc {
-	UWORD HCS_Base;		/* 00 */
-	UWORD HCS_BIOS;		/* 02 */
-	UBYTE HCS_Intr;		/* 04 */
-	UBYTE HCS_SCSI_ID;	/* 05 */
-	UBYTE HCS_MaxTar;	/* 06 */
-	UBYTE HCS_NumScbs;	/* 07 */
-
-	UBYTE HCS_Flags;	/* 08 */
-	UBYTE HCS_Index;	/* 09 */
-	UBYTE HCS_Reserved[2];	/* 0a */
-	ULONG HCS_InitioReserved[27];	/* 0C */
-	TCS HCS_Tcs[16];	/* 78 -> 16 Targets */
-	Scsi_Cmnd *pSRB_head;	/* SRB save queue header     */
-	Scsi_Cmnd *pSRB_tail;	/* SRB save queue tail       */
-	spinlock_t HCS_AvailLock;
-	spinlock_t HCS_SemaphLock;
-	spinlock_t pSRB_lock;
-	struct pci_dev *pci_dev;
-} HCS;
-
-/* Bit Definition for HCB_Flags */
-#define HCF_EXPECT_RESET        0x10
-
-/* SCSI related definition                                              */
-#define DISC_NOT_ALLOW          0x80	/* Disconnect is not allowed    */
-#define DISC_ALLOW              0xC0	/* Disconnect is allowed        */
