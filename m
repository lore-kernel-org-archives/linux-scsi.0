From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill obsolete typedefs and wrappers from tmscsim
Date: Thu, 24 Jun 2004 10:15:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040624081510.GA7950@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:59811 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263740AbUFXIPQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jun 2004 04:15:16 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: g.liakhovetski@gmx.de
Cc: linux-scsi@vger.kernel.org


--- 1.15/drivers/scsi/scsiiom.c	2004-06-23 21:43:11 +02:00
+++ edited/drivers/scsi/scsiiom.c	2004-06-23 22:13:54 +02:00
@@ -121,8 +121,8 @@
 	  }
 	else	/* write cmnd to bus */ 
 	  {
-	    PUCHAR ptr; UCHAR i;
-	    ptr = (PUCHAR) pSRB->pcmd->cmnd;
+	    u8 *ptr; UCHAR i;
+	    ptr = (u8 *) pSRB->pcmd->cmnd;
 	    for (i=0; i<pSRB->pcmd->cmd_len; i++)
 	      DC390_write8 (ScsiFifo, *(ptr++));
 	  }
@@ -159,13 +159,12 @@
 {
   PSRB pSRB;
   UCHAR dstate;
-  DEBUG0(USHORT pstate;PDEVDECL1);
+  DEBUG0(USHORT pstate; struct pci_dev *pdev = pACB->pdev);
   
-  DEBUG0(PDEVSET1);
-  DEBUG0(PCI_READ_CONFIG_WORD (PDEV, PCI_STATUS, &pstate));
+  DEBUG0(pci_read_config_word(pdev, PCI_STATUS, &pstate));
   DEBUG0(if (pstate & (PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_DETECTED_PARITY))\
 	{ printk(KERN_WARNING "DC390: PCI state = %04x!\n", pstate); \
-	  PCI_WRITE_CONFIG_WORD (PDEV, PCI_STATUS, (PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_DETECTED_PARITY));});
+	  pci_write_config_word(pdev, PCI_STATUS, (PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_DETECTED_PARITY));});
 
   dstate = DC390_read8 (DMA_Status); 
 
@@ -222,7 +221,7 @@
     PSRB   pSRB;
     UCHAR  sstatus=0;
     UCHAR  phase;
-    void   (*stateV)( PACB, PSRB, PUCHAR );
+    void   (*stateV)( PACB, PSRB, u8 *);
     UCHAR  istate, istatus;
 #if DMA_INT
     UCHAR  dstatus;
@@ -345,10 +344,10 @@
 }
 
 static void
-dc390_DataOut_0( PACB pACB, PSRB pSRB, PUCHAR psstatus)
+dc390_DataOut_0( PACB pACB, PSRB pSRB, u8 *psstatus)
 {
     UCHAR   sstatus;
-    PSGL    psgl;
+    struct scatterlist *psgl;
     UINT    ResidCnt, xferCnt;
     UCHAR   dstate = 0;
 
@@ -409,13 +408,13 @@
 }
 
 static void
-dc390_DataIn_0( PACB pACB, PSRB pSRB, PUCHAR psstatus)
+dc390_DataIn_0( PACB pACB, PSRB pSRB, u8 *psstatus)
 {
     UCHAR   sstatus, residual, bval;
-    PSGL    psgl;
+    struct scatterlist *psgl;
     UINT    ResidCnt, i;
     ULONG   xferCnt;
-    PUCHAR  ptr;
+    u8      *ptr;
 
     sstatus = *psstatus;
 
@@ -515,7 +514,7 @@
 	    if( residual )
 	    {
 		bval = DC390_read8 (ScsiFifo);	    /* get one residual byte */
-		ptr = (PUCHAR) bus_to_virt( pSRB->SGBusAddr );
+		ptr = (u8 *) bus_to_virt( pSRB->SGBusAddr );
 		*ptr = bval;
 		pSRB->SGBusAddr++; xferCnt++;
 		pSRB->TotalXferredLen++;
@@ -534,12 +533,12 @@
 }
 
 static void
-dc390_Command_0( PACB pACB, PSRB pSRB, PUCHAR psstatus)
+dc390_Command_0( PACB pACB, PSRB pSRB, u8 *psstatus)
 {
 }
 
 static void
-dc390_Status_0( PACB pACB, PSRB pSRB, PUCHAR psstatus)
+dc390_Status_0( PACB pACB, PSRB pSRB, u8 *psstatus)
 {
 
     pSRB->TargetStatus = DC390_read8 (ScsiFifo);
@@ -552,7 +551,7 @@
 }
 
 static void
-dc390_MsgOut_0( PACB pACB, PSRB pSRB, PUCHAR psstatus)
+dc390_MsgOut_0( PACB pACB, PSRB pSRB, u8 *psstatus)
 {
     if( pSRB->SRBState & (SRB_UNEXPECT_RESEL+SRB_ABORT_SENT) )
 	*psstatus = SCSI_NOP0;
@@ -740,12 +739,12 @@
 static void 
 dc390_restore_ptr (PACB pACB, PSRB pSRB)
 {
-    Scsi_Cmnd* pcmd = pSRB->pcmd;
-    PSGL psgl;
+    struct scsi_cmnd *pcmd = pSRB->pcmd;
+    struct scatterlist *psgl;
     pSRB->TotalXferredLen = 0;
     pSRB->SGIndex = 0;
     if (pcmd->use_sg) {
-	pSRB->pSegmentList = (PSGL) pcmd->request_buffer;
+	pSRB->pSegmentList = (struct scatterlist *)pcmd->request_buffer;
 	psgl = pSRB->pSegmentList;
 	//dc390_pci_sync(pSRB);
 
@@ -773,7 +772,7 @@
 
 	sg_dma_len(&pSRB->Segmentx) = pcmd->request_bufflen - pSRB->Saved_Ptr;
 	pSRB->SGcount = 1;
-	pSRB->pSegmentList = (PSGL) &pSRB->Segmentx;
+	pSRB->pSegmentList = (struct scatterlist *) &pSRB->Segmentx;
     } else {
 	 pSRB->SGcount = 0;
 	 printk (KERN_INFO "DC390: RESTORE_PTR message for Transfer without Scatter-Gather ??\n");
@@ -809,7 +808,7 @@
 
 /* read and eval received messages */
 static void
-dc390_MsgIn_0( PACB pACB, PSRB pSRB, PUCHAR psstatus)
+dc390_MsgIn_0( PACB pACB, PSRB pSRB, u8 *psstatus)
 {
     PDCB   pDCB = pACB->pActiveDCB;
 
@@ -885,7 +884,7 @@
 static void
 dc390_DataIO_Comm( PACB pACB, PSRB pSRB, UCHAR ioDir)
 {
-    PSGL   psgl;
+    struct scatterlist *psgl;
     ULONG  lval;
     PDCB   pDCB = pACB->pActiveDCB;
 
@@ -956,30 +955,30 @@
 
 
 static void
-dc390_DataOutPhase( PACB pACB, PSRB pSRB, PUCHAR psstatus)
+dc390_DataOutPhase( PACB pACB, PSRB pSRB, u8 *psstatus)
 {
     dc390_DataIO_Comm (pACB, pSRB, WRITE_DIRECTION);
 }
 
 static void
-dc390_DataInPhase( PACB pACB, PSRB pSRB, PUCHAR psstatus)
+dc390_DataInPhase( PACB pACB, PSRB pSRB, u8 *psstatus)
 {
     dc390_DataIO_Comm (pACB, pSRB, READ_DIRECTION);
 }
 
 static void
-dc390_CommandPhase( PACB pACB, PSRB pSRB, PUCHAR psstatus)
+dc390_CommandPhase( PACB pACB, PSRB pSRB, u8 *psstatus)
 {
     PDCB   pDCB;
     UCHAR  i, cnt;
-    PUCHAR ptr;
+    u8     *ptr;
 
     DC390_write8 (ScsiCmd, RESET_ATN_CMD);
     DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
     if( !(pSRB->SRBFlag & AUTO_REQSENSE) )
     {
-	cnt = (UCHAR) pSRB->pcmd->cmd_len;
-	ptr = (PUCHAR) pSRB->pcmd->cmnd;
+	cnt = (u8) pSRB->pcmd->cmd_len;
+	ptr = (u8 *) pSRB->pcmd->cmnd;
 	for(i=0; i < cnt; i++)
 	    DC390_write8 (ScsiFifo, *(ptr++));
     }
@@ -1000,7 +999,7 @@
 }
 
 static void
-dc390_StatusPhase( PACB pACB, PSRB pSRB, PUCHAR psstatus)
+dc390_StatusPhase( PACB pACB, PSRB pSRB, u8 *psstatus)
 {
     DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
     pSRB->SRBState = SRB_STATUS;
@@ -1009,10 +1008,10 @@
 }
 
 static void
-dc390_MsgOutPhase( PACB pACB, PSRB pSRB, PUCHAR psstatus)
+dc390_MsgOutPhase( PACB pACB, PSRB pSRB, u8 *psstatus)
 {
     UCHAR   bval, i, cnt;
-    PUCHAR  ptr;
+    u8     *ptr;
     PDCB    pDCB;
 
     DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
@@ -1022,7 +1021,7 @@
 	cnt = pSRB->MsgCnt;
 	if( cnt )
 	{
-	    ptr = (PUCHAR) pSRB->MsgOutBuf;
+	    ptr = (u8 *) pSRB->MsgOutBuf;
 	    for(i=0; i < cnt; i++)
 		DC390_write8 (ScsiFifo, *(ptr++));
 	    pSRB->MsgCnt = 0;
@@ -1062,7 +1061,7 @@
 }
 
 static void
-dc390_MsgInPhase( PACB pACB, PSRB pSRB, PUCHAR psstatus)
+dc390_MsgInPhase( PACB pACB, PSRB pSRB, u8 *psstatus)
 {
     DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
     if( !(pSRB->SRBState & SRB_MSGIN) )
@@ -1075,12 +1074,12 @@
 }
 
 static void
-dc390_Nop_0( PACB pACB, PSRB pSRB, PUCHAR psstatus)
+dc390_Nop_0( PACB pACB, PSRB pSRB, u8 *psstatus)
 {
 }
 
 static void
-dc390_Nop_1( PACB pACB, PSRB pSRB, PUCHAR psstatus)
+dc390_Nop_1( PACB pACB, PSRB pSRB, u8 *psstatus)
 {
 }
 
@@ -1330,9 +1329,9 @@
 dc390_SRBdone( PACB pACB, PDCB pDCB, PSRB pSRB )
 {
     UCHAR  bval, status, i;
-    PSCSICMD pcmd;
+    struct scsi_cmnd *pcmd;
     PSCSI_INQDATA  ptr;
-    PSGL   ptr2;
+    struct scatterlist *ptr2;
     ULONG  swlval;
 
     pcmd = pSRB->pcmd;
@@ -1340,9 +1339,11 @@
     dc390_pci_unmap(pSRB);
 
     status = pSRB->TargetStatus;
-    ptr = (PSCSI_INQDATA) (pcmd->request_buffer);
-    if( pcmd->use_sg )
-	ptr = (PSCSI_INQDATA) (page_address(((PSGL) ptr)->page) + ((PSGL) ptr)->offset);
+    if (pcmd->use_sg) {
+	    ptr2 = (struct scatterlist *) ptr;
+	    ptr = (PSCSI_INQDATA) (page_address(ptr2->page) + ptr2->offset);
+    } else
+	    ptr = (PSCSI_INQDATA) (pcmd->request_buffer);
 	
     DEBUG0(printk (" SRBdone (%02x,%08x), SRB %p, pid %li\n", status, pcmd->result,\
 		pSRB, pcmd->pid));
@@ -1395,8 +1396,6 @@
 	    pSRB->RetryCnt--;
 	    pSRB->AdaptStatus = 0;
 	    pSRB->TargetStatus = 0;
-	    //*((PUINT) &(pSRB->CmdBlock[0])) = pSRB->Segment0[0];
-	    //*((PUINT) &(pSRB->CmdBlock[4])) = pSRB->Segment0[1];
 	    /* Don't retry on TEST_UNIT_READY */
 	    if( pSRB->pcmd->cmnd[0] == TEST_UNIT_READY /* || pSRB->pcmd->cmnd[0] == START_STOP */)
 	    {
@@ -1569,12 +1568,12 @@
 
 /* Remove all SRBs from Going list and inform midlevel */
 static void
-dc390_DoingSRB_Done( PACB pACB, PSCSICMD cmd )
+dc390_DoingSRB_Done(PACB pACB, struct scsi_cmnd *cmd)
 {
     PDCB   pDCB, pdcb;
     PSRB   psrb, psrb2;
     UCHAR  i;
-    PSCSICMD pcmd;
+    struct scsi_cmnd *pcmd;
 
     pDCB = pACB->pLinkDCB;
     pdcb = pDCB;
@@ -1660,7 +1659,7 @@
 static void __inline__
 dc390_RequestSense( PACB pACB, PDCB pDCB, PSRB pSRB )
 {
-    PSCSICMD  pcmd;
+    struct scsi_cmnd *pcmd;
 
     pcmd = pSRB->pcmd;
 
===== drivers/scsi/tmscsim.c 1.42 vs edited =====
--- 1.42/drivers/scsi/tmscsim.c	2004-06-23 21:43:11 +02:00
+++ edited/drivers/scsi/tmscsim.c	2004-06-24 10:02:20 +02:00
@@ -221,11 +221,8 @@
 #endif
 #define DCBDEBUG1(x) C_NOP
 
-/* Includes */
+#include <linux/config.h>
 #include <linux/module.h>
-#include <asm/dma.h>
-#include <asm/io.h>
-#include <asm/system.h>
 #include <linux/delay.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
@@ -235,44 +232,30 @@
 #include <linux/pci.h>
 #include <linux/proc_fs.h>
 #include <linux/string.h>
-#include <linux/ctype.h>
 #include <linux/mm.h>
-#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/blkdev.h>
 #include <linux/timer.h>
 #include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <asm/io.h>
 
+#if 0
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#else
 #include "scsi.h"
+#endif
 #include <scsi/scsi_host.h>
-#include <linux/stat.h>
 #include <scsi/scsicam.h>
 
 #include "dc390.h"
 
 #define PCI_DEVICE_ID_AMD53C974 	PCI_DEVICE_ID_AMD_SCSI
 
-/* Locking */
-
-/* Note: Starting from 2.1.9x, the mid-level scsi code issues a 
- * spinlock_irqsave (&io_request_lock) before calling the driver's 
- * routines, so we don't need to lock, except in the IRQ handler.
- * The policy 3, let the midlevel scsi code do the io_request_locks
- * and us locking on a driver specific lock, shouldn't hurt anybody; it
- * just causes a minor performance degradation for setting the locks.
- */
 
-/* spinlock things
- * level 3: lock on both adapter specific locks and (global) io_request_lock
- * level 2: lock on adapter specific locks only
- * level 1: rely on the locking of the mid level code (io_request_lock)
- * undef  : traditional save_flags; cli; restore_flags;
- */
-
-#include <linux/init.h>
-#include <linux/spinlock.h>
-
-static struct pci_device_id tmscsim_pci_tbl[] = {
+ static struct pci_device_id tmscsim_pci_tbl[] = {
 	{
 		.vendor		= PCI_VENDOR_ID_AMD,
 		.device		= PCI_DEVICE_ID_AMD53C974,
@@ -283,44 +266,29 @@
 };
 MODULE_DEVICE_TABLE(pci, tmscsim_pci_tbl);
 
-/* These macros are used for uniform access to 2.0.x and 2.1.x PCI config space*/
-
-#define PDEV pdev
-#define PDEVDECL struct pci_dev *pdev
-#define PDEVDECL0 struct pci_dev *pdev = NULL
-#define PDEVDECL1 struct pci_dev *pdev
-#define PDEVSET pACB->pdev=pdev
-#define PDEVSET1 pdev=pACB->pdev
-#define PCI_WRITE_CONFIG_BYTE(pd, rv, bv) pci_write_config_byte (pd, rv, bv)
-#define PCI_READ_CONFIG_BYTE(pd, rv, bv) pci_read_config_byte (pd, rv, bv)
-#define PCI_WRITE_CONFIG_WORD(pd, rv, bv) pci_write_config_word (pd, rv, bv)
-#define PCI_READ_CONFIG_WORD(pd, rv, bv) pci_read_config_word (pd, rv, bv)
-#define PCI_PRESENT (1)
-#define PCI_GET_IO_AND_IRQ do{io_port = pci_resource_start (pdev, 0); irq = pdev->irq;} while(0)
-
 #include "tmscsim.h"
 
 static UCHAR dc390_StartSCSI( PACB pACB, PDCB pDCB, PSRB pSRB );
-static void dc390_DataOut_0( PACB pACB, PSRB pSRB, PUCHAR psstatus);
-static void dc390_DataIn_0( PACB pACB, PSRB pSRB, PUCHAR psstatus);
-static void dc390_Command_0( PACB pACB, PSRB pSRB, PUCHAR psstatus);
-static void dc390_Status_0( PACB pACB, PSRB pSRB, PUCHAR psstatus);
-static void dc390_MsgOut_0( PACB pACB, PSRB pSRB, PUCHAR psstatus);
-static void dc390_MsgIn_0( PACB pACB, PSRB pSRB, PUCHAR psstatus);
-static void dc390_DataOutPhase( PACB pACB, PSRB pSRB, PUCHAR psstatus);
-static void dc390_DataInPhase( PACB pACB, PSRB pSRB, PUCHAR psstatus);
-static void dc390_CommandPhase( PACB pACB, PSRB pSRB, PUCHAR psstatus);
-static void dc390_StatusPhase( PACB pACB, PSRB pSRB, PUCHAR psstatus);
-static void dc390_MsgOutPhase( PACB pACB, PSRB pSRB, PUCHAR psstatus);
-static void dc390_MsgInPhase( PACB pACB, PSRB pSRB, PUCHAR psstatus);
-static void dc390_Nop_0( PACB pACB, PSRB pSRB, PUCHAR psstatus);
-static void dc390_Nop_1( PACB pACB, PSRB pSRB, PUCHAR psstatus);
+static void dc390_DataOut_0( PACB pACB, PSRB pSRB, u8 *psstatus);
+static void dc390_DataIn_0( PACB pACB, PSRB pSRB, u8 *psstatus);
+static void dc390_Command_0( PACB pACB, PSRB pSRB, u8 *psstatus);
+static void dc390_Status_0( PACB pACB, PSRB pSRB, u8 *psstatus);
+static void dc390_MsgOut_0( PACB pACB, PSRB pSRB, u8 *psstatus);
+static void dc390_MsgIn_0( PACB pACB, PSRB pSRB, u8 *psstatus);
+static void dc390_DataOutPhase( PACB pACB, PSRB pSRB, u8 *psstatus);
+static void dc390_DataInPhase( PACB pACB, PSRB pSRB, u8 *psstatus);
+static void dc390_CommandPhase( PACB pACB, PSRB pSRB, u8 *psstatus);
+static void dc390_StatusPhase( PACB pACB, PSRB pSRB, u8 *psstatus);
+static void dc390_MsgOutPhase( PACB pACB, PSRB pSRB, u8 *psstatus);
+static void dc390_MsgInPhase( PACB pACB, PSRB pSRB, u8 *psstatus);
+static void dc390_Nop_0( PACB pACB, PSRB pSRB, u8 *psstatus);
+static void dc390_Nop_1( PACB pACB, PSRB pSRB, u8 *psstatus);
 
 static void dc390_SetXferRate( PACB pACB, PDCB pDCB );
 static void dc390_Disconnect( PACB pACB );
 static void dc390_Reselect( PACB pACB );
 static void dc390_SRBdone( PACB pACB, PDCB pDCB, PSRB pSRB );
-static void dc390_DoingSRB_Done( PACB pACB, PSCSICMD cmd );
+static void dc390_DoingSRB_Done( PACB pACB, struct scsi_cmnd * cmd);
 static void dc390_ScsiRstDetect( PACB pACB );
 static void dc390_ResetSCSIBus( PACB pACB );
 static void __inline__ dc390_RequestSense( PACB pACB, PDCB pDCB, PSRB pSRB );
@@ -328,7 +296,7 @@
 static void __inline__ dc390_EnableMsgOut_Abort (PACB, PSRB);
 static irqreturn_t do_DC390_Interrupt( int, void *, struct pt_regs *);
 
-static int    dc390_initAdapter( PSH psh, ULONG io_port, UCHAR Irq, UCHAR index );
+static int    dc390_initAdapter(struct Scsi_Host *psh, ULONG io_port, UCHAR Irq, UCHAR index );
 static void   dc390_updateDCB (PACB pACB, PDCB pDCB);
 
 static int DC390_proc_info (struct Scsi_Host *shpnt, char *buffer, char **start,
@@ -351,7 +319,7 @@
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("sd,sr,sg,st");
 
-static PVOID dc390_phase0[]={
+static void *dc390_phase0[]={
        dc390_DataOut_0,
        dc390_DataIn_0,
        dc390_Command_0,
@@ -363,7 +331,7 @@
        dc390_Nop_1
        };
 
-static PVOID dc390_phase1[]={
+static void *dc390_phase1[]={
        dc390_DataOutPhase,
        dc390_DataInPhase,
        dc390_CommandPhase,
@@ -419,7 +387,7 @@
  **********************************************************************/
 
 
-static void __devinit dc390_EnDisableCE( UCHAR mode, PDEVDECL, PUCHAR regval )
+static void __devinit dc390_EnDisableCE(u8 mode, struct pci_dev *pdev, u8 *regval)
 {
     UCHAR bval;
 
@@ -428,9 +396,9 @@
 	*regval = 0xc0;
     else
 	*regval = 0x80;
-    PCI_WRITE_CONFIG_BYTE(PDEV, *regval, bval);
+    pci_write_config_byte(pdev, *regval, bval);
     if(mode == DISABLE_CE)
-        PCI_WRITE_CONFIG_BYTE(PDEV, *regval, bval);
+        pci_write_config_byte(pdev, *regval, bval);
     udelay(160);
 }
 
@@ -438,9 +406,8 @@
 /* Override EEprom values with explicitly set values */
 static void __devinit dc390_EEprom_Override (UCHAR index)
 {
-    PUCHAR ptr;
-    UCHAR  id;
-    ptr = (PUCHAR) dc390_eepromBuf[index];
+    u8 *ptr = (u8 *) dc390_eepromBuf[index];
+    u8 id;
     
     /* Adapter Settings */
     if (tmscsim[0] != -2)
@@ -527,7 +494,7 @@
 __setup("tmscsim=", dc390_setup);
 #endif
 
-static void __devinit dc390_EEpromOutDI( PDEVDECL, PUCHAR regval, UCHAR Carry )
+static void __devinit dc390_EEpromOutDI(struct pci_dev *pdev, u8 *regval, u8 Carry)
 {
     UCHAR bval;
 
@@ -536,27 +503,27 @@
     {
 	bval = 0x40;
 	*regval = 0x80;
-	PCI_WRITE_CONFIG_BYTE(PDEV, *regval, bval);
+	pci_write_config_byte(pdev, *regval, bval);
     }
     udelay(160);
     bval |= 0x80;
-    PCI_WRITE_CONFIG_BYTE(PDEV, *regval, bval);
+    pci_write_config_byte(pdev, *regval, bval);
     udelay(160);
     bval = 0;
-    PCI_WRITE_CONFIG_BYTE(PDEV, *regval, bval);
+    pci_write_config_byte(pdev, *regval, bval);
     udelay(160);
 }
 
 
-static UCHAR __devinit dc390_EEpromInDO( PDEVDECL )
+static u8 __devinit dc390_EEpromInDO(struct pci_dev *pdev)
 {
     UCHAR bval;
 
-    PCI_WRITE_CONFIG_BYTE(PDEV, 0x80, 0x80);
+    pci_write_config_byte(pdev, 0x80, 0x80);
     udelay(160);
-    PCI_WRITE_CONFIG_BYTE(PDEV, 0x80, 0x40);
+    pci_write_config_byte(pdev, 0x80, 0x40);
     udelay(160);
-    PCI_READ_CONFIG_BYTE(PDEV, 0x00, &bval);
+    pci_read_config_byte(pdev, 0x00, &bval);
     if(bval == 0x22)
 	return(1);
     else
@@ -564,7 +531,7 @@
 }
 
 
-static USHORT __devinit dc390_EEpromGetData1( PDEVDECL )
+static u16 __devinit dc390_EEpromGetData1(struct pci_dev *pdev)
 {
     UCHAR i;
     UCHAR carryFlag;
@@ -574,14 +541,14 @@
     for(i=0; i<16; i++)
     {
 	wval <<= 1;
-	carryFlag = dc390_EEpromInDO(PDEV);
+	carryFlag = dc390_EEpromInDO(pdev);
 	wval |= carryFlag;
     }
     return(wval);
 }
 
 
-static void __devinit dc390_Prepare( PDEVDECL, PUCHAR regval, UCHAR EEpromCmd )
+static void __devinit dc390_Prepare(struct pci_dev *pdev, u8 *regval, u8 EEpromCmd)
 {
     UCHAR i,j;
     UCHAR carryFlag;
@@ -590,14 +557,14 @@
     j = 0x80;
     for(i=0; i<9; i++)
     {
-	dc390_EEpromOutDI(PDEV,regval,carryFlag);
+	dc390_EEpromOutDI(pdev, regval, carryFlag);
 	carryFlag = (EEpromCmd & j) ? 1 : 0;
 	j >>= 1;
     }
 }
 
 
-static void __devinit dc390_ReadEEprom( PDEVDECL, PUSHORT ptr)
+static void __devinit dc390_ReadEEprom(struct pci_dev *pdev, u16 *ptr)
 {
     UCHAR   regval,cmd;
     UCHAR   i;
@@ -605,10 +572,10 @@
     cmd = EEPROM_READ;
     for(i=0; i<0x40; i++)
     {
-	dc390_EnDisableCE(ENABLE_CE, PDEV, &regval);
-	dc390_Prepare(PDEV, &regval, cmd++);
-	*ptr++ = dc390_EEpromGetData1(PDEV);
-	dc390_EnDisableCE(DISABLE_CE, PDEV, &regval);
+	dc390_EnDisableCE(ENABLE_CE, pdev, &regval);
+	dc390_Prepare(pdev, &regval, cmd++);
+	*ptr++ = dc390_EEpromGetData1(pdev);
+	dc390_EnDisableCE(DISABLE_CE, pdev, &regval);
     }
 }
 
@@ -619,13 +586,13 @@
     dc390_eepromBuf[index][EE_DELAY] = interpd [dc390_eepromBuf[index][EE_DELAY]];
 }
 
-static UCHAR __devinit dc390_CheckEEpromCheckSum( PDEVDECL, UCHAR index )
+static UCHAR __devinit dc390_CheckEEpromCheckSum(struct pci_dev *pdev, u8 index)
 {
     UCHAR  i;
     char  EEbuf[128];
-    USHORT wval, *ptr = (PUSHORT)EEbuf;
+    USHORT wval, *ptr = (u16 *)EEbuf;
 
-    dc390_ReadEEprom( PDEV, ptr );
+    dc390_ReadEEprom(pdev, ptr);
     memcpy (dc390_eepromBuf[index], EEbuf, EE_ADAPT_SCSI_ID);
     memcpy (&dc390_eepromBuf[index][EE_ADAPT_SCSI_ID], 
 	    &EEbuf[REAL_EE_ADAPT_SCSI_ID], EE_LEN - EE_ADAPT_SCSI_ID);
@@ -675,22 +642,6 @@
  * Lists are managed using two pointers and eventually a counter
  */
 
-
-#if 0
-/* Look for a SCSI cmd in a SRB queue */
-static PSRB dc390_find_cmd_in_SRBq (PSCSICMD cmd, PSRB queue)
-{
-    PSRB q = queue;
-    while (q)
-    {
-	if (q->pcmd == cmd) return q;
-	q = q->pNextSRB;
-	if (q == queue) return 0;
-    }
-    return q;
-}
-#endif
-
 /* Return next free SRB */
 static __inline__ PSRB dc390_Free_get ( PACB pACB )
 {
@@ -916,7 +867,7 @@
 static int dc390_pci_map (PSRB pSRB)
 {
 	int error = 0;
-	Scsi_Cmnd *pcmd = pSRB->pcmd;
+	struct scsi_cmnd *pcmd = pSRB->pcmd;
 	struct pci_dev *pdev = pSRB->pSRBDCB->pDCBACB->pdev;
 	dc390_cmd_scp_t* cmdp = ((dc390_cmd_scp_t*)(&pcmd->SCp));
 
@@ -933,9 +884,9 @@
 		DEBUG1(printk("%s(): Mapped sense buffer %p at %x\n", __FUNCTION__, pcmd->sense_buffer, cmdp->saved_dma_handle));
 	/* Map SG list */
 	} else if (pcmd->use_sg) {
-		pSRB->pSegmentList	= (PSGL) pcmd->request_buffer;
+		pSRB->pSegmentList	= (struct scatterlist *) pcmd->request_buffer;
 		pSRB->SGcount		= pci_map_sg(pdev, pSRB->pSegmentList, pcmd->use_sg,
-						     scsi_to_pci_dma_dir(pcmd->sc_data_direction));
+						     pcmd->sc_data_direction);
 		/* TODO: error handling */
 		if (!pSRB->SGcount)
 			error = 1;
@@ -945,7 +896,7 @@
 	} else if (pcmd->request_buffer && pcmd->request_bufflen) {
 		pSRB->pSegmentList	= dc390_sg_build_single(&pSRB->Segmentx, pcmd->request_buffer, pcmd->request_bufflen);
 		pSRB->SGcount		= pci_map_sg(pdev, pSRB->pSegmentList, 1,
-						     scsi_to_pci_dma_dir(pcmd->sc_data_direction));
+						     pcmd->sc_data_direction);
 		cmdp->saved_dma_handle	= sg_dma_address(pSRB->pSegmentList);
 
 		/* TODO: error handling */
@@ -962,7 +913,7 @@
 /* Remove pci mapping */
 static void dc390_pci_unmap (PSRB pSRB)
 {
-	Scsi_Cmnd* pcmd = pSRB->pcmd;
+	struct scsi_cmnd *pcmd = pSRB->pcmd;
 	struct pci_dev *pdev = pSRB->pSRBDCB->pDCBACB->pdev;
 	DEBUG1(dc390_cmd_scp_t* cmdp = ((dc390_cmd_scp_t*)(&pcmd->SCp)));
 
@@ -970,10 +921,10 @@
 		pci_unmap_sg(pdev, &pSRB->Segmentx, 1, DMA_FROM_DEVICE);
 		DEBUG1(printk("%s(): Unmapped sense buffer at %x\n", __FUNCTION__, cmdp->saved_dma_handle));
 	} else if (pcmd->use_sg) {
-		pci_unmap_sg(pdev, pcmd->request_buffer, pcmd->use_sg, scsi_to_pci_dma_dir(pcmd->sc_data_direction));
+		pci_unmap_sg(pdev, pcmd->request_buffer, pcmd->use_sg, pcmd->sc_data_direction);
 		DEBUG1(printk("%s(): Unmapped SG at %p with %d elements\n", __FUNCTION__, pcmd->request_buffer, pcmd->use_sg));
 	} else if (pcmd->request_buffer && pcmd->request_bufflen) {
-		pci_unmap_sg(pdev, &pSRB->Segmentx, 1, scsi_to_pci_dma_dir(pcmd->sc_data_direction));
+		pci_unmap_sg(pdev, &pSRB->Segmentx, 1, pcmd->sc_data_direction);
 		DEBUG1(printk("%s(): Unmapped request buffer at %x\n", __FUNCTION__, cmdp->saved_dma_handle));
 	}
 }
@@ -987,7 +938,7 @@
  *
  ***********************************************************************/
 
-static void dc390_BuildSRB (Scsi_Cmnd* pcmd, PDCB pDCB, PSRB pSRB)
+static void dc390_BuildSRB (struct scsi_cmnd *pcmd, PDCB pDCB, PSRB pSRB)
 {
     pSRB->pSRBDCB = pDCB;
     pSRB->pcmd = pcmd;
@@ -1015,8 +966,8 @@
 }
 
 /***********************************************************************
- * Function : static int DC390_queue_command (Scsi_Cmnd *cmd,
- *					       void (*done)(Scsi_Cmnd *))
+ * Function : static int DC390_queue_command (struct scsi_cmnd *cmd,
+ *					       void (*done)(struct scsi_cmnd *))
  *
  * Purpose : enqueues a SCSI command
  *
@@ -1033,7 +984,8 @@
  *
  ***********************************************************************/
 
-static int DC390_queue_command (Scsi_Cmnd *cmd, void (* done)(Scsi_Cmnd *))
+static int DC390_queue_command(struct scsi_cmnd *cmd,
+		void (* done)(struct scsi_cmnd *))
 {
     PDCB   pDCB = (PDCB) cmd->device->hostdata;
     PSRB   pSRB;
@@ -1223,7 +1175,9 @@
 
 static void dc390_dumpinfo (PACB pACB, PDCB pDCB, PSRB pSRB)
 {
-    USHORT pstat; PDEVDECL1;
+    struct pci_dev *pdev;
+    USHORT pstat;
+
     if (!pDCB) pDCB = pACB->pActiveDCB;
     if (!pSRB && pDCB) pSRB = pDCB->pActiveSRB;
 
@@ -1257,14 +1211,16 @@
 	    DC390_read32(DMA_Wk_ByteCntr), DC390_read32(DMA_Wk_AddrCntr),
 	    DC390_read8(DMA_Status), DC390_read32(DMA_ScsiBusCtrl));
     DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT);
-    PDEVSET1; PCI_READ_CONFIG_WORD(PDEV, PCI_STATUS, &pstat);
+
+    pdev = pACB->pdev;
+    pci_read_config_word(pdev, PCI_STATUS, &pstat);
     printk ("DC390: Register dump: PCI Status: %04x\n", pstat);
     printk ("DC390: In case of driver trouble read linux/Documentation/scsi/tmscsim.txt\n");
 }
 
 
 /***********************************************************************
- * Function : int DC390_abort (Scsi_Cmnd *cmd)
+ * Function : int DC390_abort (struct scsi_cmnd *cmd)
  *
  * Purpose : Abort an errant SCSI command
  *
@@ -1275,7 +1231,7 @@
  * Status: Buggy !
  ***********************************************************************/
 
-static int DC390_abort (Scsi_Cmnd *cmd)
+static int DC390_abort (struct scsi_cmnd *cmd)
 {
     PDCB  pDCB = (PDCB) cmd->device->hostdata;
     PSRB  pSRB, psrb;
@@ -1470,7 +1426,7 @@
 #endif
 
 /***********************************************************************
- * Function : int DC390_reset (Scsi_Cmnd *cmd, ...)
+ * Function : int DC390_reset (struct scsi_cmnd *cmd, ...)
  *
  * Purpose : perform a hard reset on the SCSI bus
  *
@@ -1480,7 +1436,7 @@
  * Returns : 0 on success.
  ***********************************************************************/
 
-static int DC390_reset (Scsi_Cmnd *cmd)
+static int DC390_reset (struct scsi_cmnd *cmd)
 {
     UCHAR   bval;
     PACB    pACB = (PACB) cmd->device->host->hostdata;
@@ -1589,7 +1545,7 @@
  *	    io_port, Irq, index: Resources and adapter index
  ***********************************************************************/
 
-static void __devinit dc390_initACB (PSH psh, ULONG io_port, UCHAR Irq, UCHAR index)
+static void __devinit dc390_initACB (struct Scsi_Host *psh, ULONG io_port, UCHAR Irq, UCHAR index)
 {
     PACB    pACB;
     UCHAR   i;
@@ -1660,7 +1616,7 @@
  * Outputs: 0 on success, -1 on error
  ***********************************************************************/
 
-static int __devinit dc390_initAdapter (PSH psh, ULONG io_port, UCHAR Irq, UCHAR index)
+static int __devinit dc390_initAdapter (struct Scsi_Host *psh, ULONG io_port, UCHAR Irq, UCHAR index)
 {
     PACB   pACB, pACB2;
     UCHAR  dstate;
@@ -1731,13 +1687,14 @@
 }
 
 
-static void __devinit dc390_set_pci_cfg (PDEVDECL)
+static void __devinit dc390_set_pci_cfg (struct pci_dev *pdev)
 {
-	USHORT cmd;
-	PCI_READ_CONFIG_WORD (PDEV, PCI_COMMAND, &cmd);
+	u16 cmd;
+
+	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
 	cmd |= PCI_COMMAND_SERR | PCI_COMMAND_PARITY | PCI_COMMAND_IO;
-	PCI_WRITE_CONFIG_WORD (PDEV, PCI_COMMAND, cmd);
-	PCI_WRITE_CONFIG_WORD (PDEV, PCI_STATUS, (PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_DETECTED_PARITY));
+	pci_write_config_word(pdev, PCI_COMMAND, cmd);
+	pci_write_config_word(pdev, PCI_STATUS, (PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_DETECTED_PARITY));
 }
 
 /**
@@ -1858,7 +1815,7 @@
 	return 0;
 }
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "tmscsim", 
 	.proc_info		= DC390_proc_info,
===== drivers/scsi/tmscsim.h 1.7 vs edited =====
--- 1.7/drivers/scsi/tmscsim.h	2004-05-28 00:52:39 +02:00
+++ edited/drivers/scsi/tmscsim.h	2004-06-23 22:20:50 +02:00
@@ -29,17 +29,6 @@
 typedef u32		UINT;	/* 32 bits */
 typedef unsigned long	ULONG;	/* 32/64 bits */
 
-typedef UCHAR		*PUCHAR;
-typedef USHORT		*PUSHORT;
-typedef UINT		*PUINT;
-typedef ULONG		*PULONG;
-typedef Scsi_Host_Template	*PSHT;
-typedef struct Scsi_Host	*PSH;
-typedef Scsi_Device	*PSCSIDEV;
-typedef Scsi_Cmnd	*PSCSICMD;
-typedef void		*PVOID;
-typedef struct scatterlist  *PSGL, SGL;
-
 
 /*;-----------------------------------------------------------------------*/
 typedef  struct  _SyncMsg
@@ -81,11 +70,11 @@
 
 struct _SRB	*pNextSRB;
 struct _DCB	*pSRBDCB;
-PSCSICMD	pcmd;
-PSGL		pSegmentList;
+struct scsi_cmnd *pcmd;
+struct scatterlist *pSegmentList;
 
 /* 0x10: */
-SGL		Segmentx;	/* make a one entry of S/G list table */
+struct scatterlist Segmentx;	/* make a one entry of S/G list table */
 
 /* 0x1c: */
 ULONG		SGBusAddr;	/*;a segment starting address as seen by AM53C974A*/
@@ -135,11 +124,6 @@
 struct _DCB	*pNextDCB;
 struct _ACB	*pDCBACB;
 
-/* Aborted Commands */
-//PSCSICMD	AboIORBhead;
-//PSCSICMD	AboIORBtail;
-//ULONG		AboIORBcnt;
-
 /* 0x08: */
 /* Queued SRBs */
 PSRB		pWaitingSRB;
@@ -186,7 +170,7 @@
 */
 struct	_ACB
 {
-PSH		pScsiHost;
+struct Scsi_Host *pScsiHost;
 struct _ACB	*pNextACB;
 USHORT		IOPortBase;
 UCHAR		IRQLevel;
@@ -223,7 +207,7 @@
 UCHAR		MsgLen;
 UCHAR		Ignore_IRQ;	/* Not used */
 
-PDEVDECL1;			/* Pointer to PCI cfg. space */
+struct pci_dev	*pdev;
 
 ULONG		Cmds;
 UINT		SelLost;
