From: akpm@osdl.org
Subject: [patch 07/28] drivers/scsi/FlashPoint.c: remove trivial wrappers
Date: Wed, 08 Mar 2006 00:14:23 -0800
Message-ID: <200603080816.k288GDSR002169@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:20140 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1752097AbWCHIQQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com


From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/FlashPoint.c |   54 ++++++++++++------------------------
 1 files changed, 19 insertions(+), 35 deletions(-)

diff -puN drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-remove-trivial-wrappers drivers/scsi/FlashPoint.c
--- 25/drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-remove-trivial-wrappers	Mon Feb  6 14:49:57 2006
+++ 25-akpm/drivers/scsi/FlashPoint.c	Mon Feb  6 14:49:57 2006
@@ -26,25 +26,9 @@
 #undef BUSTYPE_PCI
 
 
-#define OS_InPortByte(port)		inb(port)
-#define OS_InPortWord(port)		inw(port)
-#define OS_InPortLong(port)		inl(port)
-#define OS_OutPortByte(port, value)	outb(value, port)
-#define OS_OutPortWord(port, value)	outw(value, port)
-#define OS_OutPortLong(port, value)	outl(value, port)
 
 
-/*
-  Define name replacements for compatibility with the Linux BusLogic Driver.
-*/
 
-#define SccbMgr_sense_adapter		FlashPoint_ProbeHostAdapter
-#define SccbMgr_config_adapter		FlashPoint_HardwareResetHostAdapter
-#define SccbMgr_unload_card		FlashPoint_ReleaseHostAdapter
-#define SccbMgr_start_sccb		FlashPoint_StartCCB
-#define SccbMgr_abort_sccb		FlashPoint_AbortCCB
-#define SccbMgr_my_int			FlashPoint_InterruptPending
-#define SccbMgr_isr			FlashPoint_HandleInterrupt
 
 
 
@@ -266,12 +250,12 @@ typedef struct _SCCB {
 #define SG_ELEMENT_SIZE 8              /*Eight byte per element. */
 
 
-#define RD_HARPOON(ioport)          OS_InPortByte((u32bits)ioport)
-#define RDW_HARPOON(ioport)         OS_InPortWord((u32bits)ioport)
-#define RD_HARP32(ioport,offset,data) (data = OS_InPortLong((u32bits)(ioport + offset)))
-#define WR_HARPOON(ioport,val)      OS_OutPortByte((u32bits)ioport,(u08bits) val)
-#define WRW_HARPOON(ioport,val)       OS_OutPortWord((u32bits)ioport,(u16bits)val)
-#define WR_HARP32(ioport,offset,data)  OS_OutPortLong((u32bits)(ioport + offset), data)
+#define RD_HARPOON(ioport)          inb((u32bits)ioport)
+#define RDW_HARPOON(ioport)         inw((u32bits)ioport)
+#define RD_HARP32(ioport,offset,data) (data = inl((u32bits)(ioport + offset)))
+#define WR_HARPOON(ioport,val)      outb((u08bits) val, (u32bits)ioport)
+#define WRW_HARPOON(ioport,val)       outw((u16bits)val, (u32bits)ioport)
+#define WR_HARP32(ioport,offset,data)  outl(data, (u32bits)(ioport + offset))
 
 
 #define  TAR_SYNC_MASK     (BIT(7)+BIT(6))
@@ -1130,13 +1114,13 @@ static void (*FPT_s_PhaseTbl[8]) (ULONG,
 
 /*---------------------------------------------------------------------
  *
- * Function: SccbMgr_sense_adapter
+ * Function: FlashPoint_ProbeHostAdapter
  *
  * Description: Setup and/or Search for cards and return info to caller.
  *
  *---------------------------------------------------------------------*/
 
-static int SccbMgr_sense_adapter(PSCCBMGR_INFO pCardInfo)
+static int FlashPoint_ProbeHostAdapter(PSCCBMGR_INFO pCardInfo)
 {
    static UCHAR first_time = 1;
 
@@ -1408,13 +1392,13 @@ static int SccbMgr_sense_adapter(PSCCBMG
 
 /*---------------------------------------------------------------------
  *
- * Function: SccbMgr_config_adapter
+ * Function: FlashPoint_HardwareResetHostAdapter
  *
  * Description: Setup adapter for normal operation (hard reset).
  *
  *---------------------------------------------------------------------*/
 
-static ULONG SccbMgr_config_adapter(PSCCBMGR_INFO pCardInfo)
+static ULONG FlashPoint_HardwareResetHostAdapter(PSCCBMGR_INFO pCardInfo)
 {
    PSCCBcard CurrCard = NULL;
 	PNVRamInfo pCurrNvRam;
@@ -1595,7 +1579,7 @@ static ULONG SccbMgr_config_adapter(PSCC
    return((ULONG)CurrCard);
 }
 
-static void SccbMgr_unload_card(ULONG pCurrCard)
+static void FlashPoint_ReleaseHostAdapter(ULONG pCurrCard)
 {
 	UCHAR i;
 	ULONG portBase;
@@ -1687,14 +1671,14 @@ static UCHAR FPT_ChkIfChipInitialized(UL
 }
 /*---------------------------------------------------------------------
  *
- * Function: SccbMgr_start_sccb
+ * Function: FlashPoint_StartCCB
  *
  * Description: Start a command pointed to by p_Sccb. When the
  *              command is completed it will be returned via the
  *              callback function.
  *
  *---------------------------------------------------------------------*/
-static void SccbMgr_start_sccb(ULONG pCurrCard, PSCCB p_Sccb)
+static void FlashPoint_StartCCB(ULONG pCurrCard, PSCCB p_Sccb)
 {
    ULONG ioport;
    UCHAR thisCard, lun;
@@ -1807,14 +1791,14 @@ static void SccbMgr_start_sccb(ULONG pCu
 
 /*---------------------------------------------------------------------
  *
- * Function: SccbMgr_abort_sccb
+ * Function: FlashPoint_AbortCCB
  *
  * Description: Abort the command pointed to by p_Sccb.  When the
  *              command is completed it will be returned via the
  *              callback function.
  *
  *---------------------------------------------------------------------*/
-static int SccbMgr_abort_sccb(ULONG pCurrCard, PSCCB p_Sccb)
+static int FlashPoint_AbortCCB(ULONG pCurrCard, PSCCB p_Sccb)
 {
 	ULONG ioport;
 
@@ -1908,13 +1892,13 @@ static int SccbMgr_abort_sccb(ULONG pCur
 
 /*---------------------------------------------------------------------
  *
- * Function: SccbMgr_my_int
+ * Function: FlashPoint_InterruptPending
  *
  * Description: Do a quick check to determine if there is a pending
  *              interrupt for this card and disable the IRQ Pin if so.
  *
  *---------------------------------------------------------------------*/
-static UCHAR SccbMgr_my_int(ULONG pCurrCard)
+static UCHAR FlashPoint_InterruptPending(ULONG pCurrCard)
 {
    ULONG ioport;
 
@@ -1934,14 +1918,14 @@ static UCHAR SccbMgr_my_int(ULONG pCurrC
 
 /*---------------------------------------------------------------------
  *
- * Function: SccbMgr_isr
+ * Function: FlashPoint_HandleInterrupt
  *
  * Description: This is our entry point when an interrupt is generated
  *              by the card and the upper level driver passes it on to
  *              us.
  *
  *---------------------------------------------------------------------*/
-static int SccbMgr_isr(ULONG pCurrCard)
+static int FlashPoint_HandleInterrupt(ULONG pCurrCard)
 {
    PSCCB currSCCB;
    UCHAR thisCard,result,bm_status, bm_int_st;
_
