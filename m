From: domen@coderock.org
Subject: [patch 04/11] FlashPoint.c: remove _useless_ #define's.
Date: Sun, 06 Mar 2005 23:27:01 +0100
Message-ID: <20050306222701.782A51EDA4@trashy.coderock.org>
Received: from coderock.org ([193.77.147.115]:16815 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261543AbVCFW33 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2005 17:29:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, adobriyan@mail.ru



* Remove references on DOS, WIN95_16, OS2, OTHER_16, NETWARE, NT, WIN95_32,
  OTHER_32, SOLARIS_REAL_MODE, COMPILER_16_BIT.
* All #ifdefs that depend on them are simplified (read: deleted).
* Remove UNIX, COMPILER_32_BIT. Only "#if defined" and "#endif" lines are
  deleted for these.
* Shrink FlashPoint.c by 30k as a result.

Signed-off-by: Alexey Dobriyan <adobriyan@mail.ru>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/FlashPoint.c | 1109 -------------------------------------
 1 files changed, 4 insertions(+), 1105 deletions(-)

diff -puN drivers/scsi/FlashPoint.c~defines-drivers_scsi_FlashPoint drivers/scsi/FlashPoint.c
--- kj/drivers/scsi/FlashPoint.c~defines-drivers_scsi_FlashPoint	2005-03-05 16:11:59.000000000 +0100
+++ kj-domen/drivers/scsi/FlashPoint.c	2005-03-05 16:11:59.000000000 +0100
@@ -22,7 +22,6 @@
 #ifndef CONFIG_SCSI_OMIT_FLASHPOINT
 
 
-#define UNIX
 #define FW_TYPE		_SCCB_MGR_
 #define MAX_CARDS	8
 #undef BUSTYPE_PCI
@@ -182,15 +181,6 @@
 
 #define CRCMASK	0xA001
 
-/*  In your osflags.h file, please ENSURE that only ONE OS FLAG 
-    is on at a time !!! Also, please make sure you turn set the 
- 	 variable FW_TYPE to either _UCB_MGR_ or _SCCB_MGR_  !!! */
-
-#if defined(DOS) || defined(WIN95_16) || defined(OS2) || defined(OTHER_16)
-   #define       COMPILER_16_BIT 1
-#elif defined(NETWARE) || defined(NT) || defined(WIN95_32) || defined(UNIX) || defined(OTHER_32) || defined(SOLARIS_REAL_MODE)
-   #define       COMPILER_32_BIT 1
-#endif
 
 
 #define     BL_VENDOR_ID      0x104B
@@ -222,17 +212,10 @@ typedef unsigned long * PULONG;
 typedef void *          PVOID;
 
 
-#if defined(COMPILER_16_BIT)
-typedef unsigned char far       * uchar_ptr;
-typedef unsigned short far      * ushort_ptr;
-typedef unsigned long far       * ulong_ptr;
-#endif  /* 16_BIT_COMPILER */
 
-#if defined(COMPILER_32_BIT)
 typedef unsigned char           * uchar_ptr;
 typedef unsigned short          * ushort_ptr;
 typedef unsigned long           * ulong_ptr;
-#endif  /* 32_BIT_COMPILER */
 
 
 /*	 			NEW TYPE DEFINITIONS (shared with Mylex North)
@@ -251,21 +234,12 @@ typedef unsigned long           * ulong_
 #define u16bits	unsigned s16bits
 #define u32bits	unsigned s32bits
 
-#if defined(COMPILER_16_BIT)
-
-typedef u08bits far 	* pu08bits;
-typedef u16bits far 	* pu16bits;
-typedef u32bits far	* pu32bits;
 
-#endif	/* COMPILER_16_BIT */
-
-#if defined(COMPILER_32_BIT)
 
 typedef u08bits 	* pu08bits;
 typedef u16bits 	* pu16bits;
 typedef u32bits 	* pu32bits;
 
-#endif	/* COMPILER_32_BIT */
 
 
 #define BIT(x)          ((UCHAR)(1<<(x)))    /* single-bit mask in bit position x */
@@ -273,73 +247,10 @@ typedef u32bits 	* pu32bits;
 
 
 
-#if defined(DOS)
-/*#include <dos.h>*/
-	#undef inportb          /* undefine for Borland Lib */
-	#undef inport           /* they may have define I/O function in LIB */
-	#undef outportb
-	#undef outport
-
-	#define OS_InPortByte(ioport) 		inportb(ioport)
-	#define OS_InPortWord(ioport) 		inport(ioport)
-	#define OS_InPortLong(ioport)			inportq(ioport, val)
-	#define OS_OutPortByte(ioport, val) outportb(ioport, val)
-	#define OS_OutPortWord(ioport, val)	outport(ioport, val)
-	#define OS_OutPortLong(ioport)		outportq(ioport, val)
-#endif	/* DOS */
-
-#if defined(NETWARE) || defined(OTHER_32) ||  defined(OTHER_16)
-	extern u08bits	OS_InPortByte(u32bits ioport);
-	extern u16bits	OS_InPortWord(u32bits ioport);
-	extern u32bits	OS_InPortLong(u32bits ioport);
-
-	extern OS_InPortByteBuffer(u32bits ioport, pu08bits buffer, u32bits count);
-	extern OS_InPortWordBuffer(u32bits ioport, pu16bits buffer, u32bits count);
-	extern OS_OutPortByte(u32bits ioport, u08bits val);
-	extern OS_OutPortWord(u32bits ioport, u16bits val);
-	extern OS_OutPortLong(u32bits ioport, u32bits val);
-	extern OS_OutPortByteBuffer(u32bits ioport, pu08bits buffer, u32bits count);
-	extern OS_OutPortWordBuffer(u32bits ioport, pu16bits buffer, u32bits count);
-#endif	/* NETWARE || OTHER_32 || OTHER_16 */
-
-#if defined (NT) || defined(WIN95_32) || defined(WIN95_16)
-	#if defined(NT)
-
-		extern __declspec(dllimport) u08bits ScsiPortReadPortUchar(pu08bits ioport);
-		extern __declspec(dllimport) u16bits ScsiPortReadPortUshort(pu16bits ioport);
-		extern __declspec(dllimport) u32bits ScsiPortReadPortUlong(pu32bits ioport);
-		extern __declspec(dllimport) void ScsiPortWritePortUchar(pu08bits ioport, u08bits val);
-		extern __declspec(dllimport) void ScsiPortWritePortUshort(pu16bits port, u16bits val);
-		extern __declspec(dllimport) void ScsiPortWritePortUlong(pu32bits port, u32bits val);
-
-	#else
-
-		extern u08bits ScsiPortReadPortUchar(pu08bits ioport);
-		extern u16bits ScsiPortReadPortUshort(pu16bits ioport);
-		extern u32bits ScsiPortReadPortUlong(pu32bits ioport);
-		extern void ScsiPortWritePortUchar(pu08bits ioport, u08bits val);
-		extern void ScsiPortWritePortUshort(pu16bits port, u16bits val);
-		extern void ScsiPortWritePortUlong(pu32bits port, u32bits val);
-	#endif
 
 
-	#define OS_InPortByte(ioport) ScsiPortReadPortUchar((pu08bits) ioport)
-	#define OS_InPortWord(ioport) ScsiPortReadPortUshort((pu16bits) ioport)
-	#define OS_InPortLong(ioport) ScsiPortReadPortUlong((pu32bits) ioport)
-
-	#define OS_OutPortByte(ioport, val) ScsiPortWritePortUchar((pu08bits) ioport, (u08bits) val)
-	#define OS_OutPortWord(ioport, val) ScsiPortWritePortUshort((pu16bits) ioport, (u16bits) val)
-	#define OS_OutPortLong(ioport, val) ScsiPortWritePortUlong((pu32bits) ioport, (u32bits) val)
-	#define OS_OutPortByteBuffer(ioport, buffer, count) \
-		ScsiPortWritePortBufferUchar((pu08bits)&port, (pu08bits) buffer, (u32bits) count)
-	#define OS_OutPortWordBuffer(ioport, buffer, count) \
-		ScsiPortWritePortBufferUshort((pu16bits)&port, (pu16bits) buffer, (u32bits) count)
-
-	#define OS_Lock(x)
-	#define OS_UnLock(x)
-#endif /* NT || WIN95_32 || WIN95_16 */
 
-#if defined (UNIX) && !defined(OS_InPortByte)
+#if !defined(OS_InPortByte)
 	#define OS_InPortByte(ioport)    inb((u16bits)ioport)
 	#define OS_InPortWord(ioport)    inw((u16bits)ioport)
 	#define OS_InPortLong(ioport)    inl((u16bits)ioport)
@@ -349,43 +260,10 @@ typedef u32bits 	* pu32bits;
 
 	#define OS_Lock(x)
 	#define OS_UnLock(x)
-#endif /* UNIX */
-
-
-#if defined(OS2)
-	extern u08bits	inb(u32bits ioport);
-	extern u16bits	inw(u32bits ioport);
-	extern void	outb(u32bits ioport, u08bits val);
-	extern void	outw(u32bits ioport, u16bits val);
-
-	#define OS_InPortByte(ioport)			inb(ioport)
-	#define OS_InPortWord(ioport)			inw(ioport)
-	#define OS_OutPortByte(ioport, val)	outb(ioport, val)
-	#define OS_OutPortWord(ioport, val)	outw(ioport, val)
-	extern u32bits	OS_InPortLong(u32bits ioport);
-	extern void	OS_OutPortLong(u32bits ioport, u32bits val);
-
-	#define OS_Lock(x)
-	#define OS_UnLock(x)
-#endif /* OS2 */
-
-#if defined(SOLARIS_REAL_MODE)
-
-extern unsigned char    inb(unsigned long ioport);
-extern unsigned short   inw(unsigned long ioport);
+#endif /* !defined(OS_InPortByte) */
 
-#define OS_InPortByte(ioport)    inb(ioport)
-#define OS_InPortWord(ioport)    inw(ioport)
 
-extern void OS_OutPortByte(unsigned long ioport, unsigned char val);
-extern void OS_OutPortWord(unsigned long ioport, unsigned short val);
-extern unsigned long  OS_InPortLong(unsigned long ioport);
-extern void     OS_OutPortLong(unsigned long ioport, unsigned long val);
 
-#define OS_Lock(x)
-#define OS_UnLock(x)
-
-#endif  /* SOLARIS_REAL_MODE */
 
 #endif  /* __GLOBALS_H__ */
 
@@ -418,28 +296,12 @@ extern void     OS_OutPortLong(unsigned 
 #define debug_size 32
 #endif
 
-#if defined(DOS)
-
-   typedef struct _SCCB near *PSCCB;
-	#if (FW_TYPE == _SCCB_MGR_)
-   	typedef void (*CALL_BK_FN)(PSCCB);
-	#endif
-
-#elif defined(OS2)
-
-   typedef struct _SCCB far *PSCCB;
-	#if (FW_TYPE == _SCCB_MGR_)
-   	typedef void (far *CALL_BK_FN)(PSCCB);
-	#endif
-
-#else
 
    typedef struct _SCCB *PSCCB;
 	#if (FW_TYPE == _SCCB_MGR_)
    	typedef void (*CALL_BK_FN)(PSCCB);
 	#endif
 
-#endif
 
 
 typedef struct SCCBMgr_info {
@@ -466,15 +328,7 @@ typedef struct SCCBMgr_info {
    ULONG    si_secondary_range;
 } SCCBMGR_INFO;
 
-#if defined(DOS)
    typedef SCCBMGR_INFO *      PSCCBMGR_INFO;
-#else
-   #if defined (COMPILER_16_BIT)
-   typedef SCCBMGR_INFO far *  PSCCBMGR_INFO;
-   #else
-   typedef SCCBMGR_INFO *      PSCCBMGR_INFO;
-   #endif
-#endif // defined(DOS)
 
 
 
@@ -676,19 +530,6 @@ typedef struct _SCCB {
 
 #if (FW_TYPE == _SCCB_MGR_)
 
- #if defined (DOS)
-	int    SccbMgr_sense_adapter(PSCCBMGR_INFO pCardInfo);
-	USHORT SccbMgr_config_adapter(PSCCBMGR_INFO pCardInfo);
-	void  SccbMgr_start_sccb(USHORT pCurrCard, PSCCB p_SCCB);
-	int   SccbMgr_abort_sccb(USHORT pCurrCard, PSCCB p_SCCB);
-	UCHAR SccbMgr_my_int(USHORT pCurrCard);
-	int   SccbMgr_isr(USHORT pCurrCard);
-	void  SccbMgr_scsi_reset(USHORT pCurrCard);
-	void  SccbMgr_timer_expired(USHORT pCurrCard);
-	USHORT SccbMgr_status(USHORT pCurrCard);
-	void SccbMgr_unload_card(USHORT pCurrCard);
-
- #else    //non-DOS
 
 	int   SccbMgr_sense_adapter(PSCCBMGR_INFO pCardInfo);
 	ULONG SccbMgr_config_adapter(PSCCBMGR_INFO pCardInfo);
@@ -702,7 +543,6 @@ typedef struct _SCCB {
 	void  SccbMgr_timer_expired(ULONG pCurrCard);
 	void SccbMgr_unload_card(ULONG pCurrCard);
 
-  #endif
 #endif  // (FW_TYPE == _SCCB_MGR_)
 
 #endif  /* __SCCB_H__ */
@@ -740,27 +580,17 @@ typedef struct _SCCB {
 #define HARP_REVD    1
 
 
-#if defined(DOS)
-#define QUEUE_DEPTH     8+1            /*1 for Normal disconnect 0 for Q'ing. */
-#else
 #define QUEUE_DEPTH     254+1            /*1 for Normal disconnect 32 for Q'ing. */
-#endif   // defined(DOS)
 
 #define	MAX_MB_CARDS	4					/* Max. no of cards suppoerted on Mother Board */
 
 #define WIDE_SCSI       1
 
 #if defined(WIDE_SCSI)
-   #if defined(DOS)
-      #define MAX_SCSI_TAR    16
-      #define MAX_LUN         8
-		#define LUN_MASK			0x07
-   #else
       #define MAX_SCSI_TAR    16
       #define MAX_LUN         32
 		#define LUN_MASK			0x1f
 	
-   #endif
 #else
    #define MAX_SCSI_TAR    8
    #define MAX_LUN         8
@@ -784,83 +614,17 @@ typedef struct _SCCB {
 
 
 
-#if defined(DOS)
 
-/*#include <dos.h>*/
-	#define RD_HARPOON(ioport)          (OS_InPortByte(ioport))
-	#define RDW_HARPOON(ioport)         (OS_InPortWord(ioport))
-	#define WR_HARPOON(ioport,val)      (OS_OutPortByte(ioport,val))
-	#define WRW_HARPOON(ioport,val)     (OS_OutPortWord(ioport,val))
-
-	#define RD_HARP32(port,offset,data)  asm{db 66h;         \
-                                       push ax;             \
-                                       mov dx,port;         \
-                                       add dx, offset;      \
-                                       db 66h;              \
-                                       in ax,dx;            \
-                                       db 66h;              \
-                                       mov word ptr data,ax;\
-                                       db 66h;              \
-                                       pop ax}
-
-	#define WR_HARP32(port,offset,data) asm{db 66h;          \
-                                       push ax;             \
-                                       mov dx,port;         \
-                                       add dx, offset;      \
-                                       db 66h;              \
-                                       mov ax,word ptr data;\
-                                       db 66h;              \
-                                       out dx,ax;           \
-                                       db 66h;              \
-                                       pop ax}
-#endif	/* DOS */
-
-#if defined(NETWARE) || defined(OTHER_32) ||  defined(OTHER_16)
-	#define RD_HARPOON(ioport)     OS_InPortByte((unsigned long)ioport)
-	#define RDW_HARPOON(ioport)    OS_InPortWord((unsigned long)ioport)
-	#define RD_HARP32(ioport,offset,data) (data = OS_InPortLong(ioport + offset))
-	#define WR_HARPOON(ioport,val) OS_OutPortByte((ULONG)ioport,(UCHAR) val)
-	#define WRW_HARPOON(ioport,val)  OS_OutPortWord((ULONG)ioport,(USHORT)val)
-	#define WR_HARP32(ioport,offset,data)  OS_OutPortLong((ioport + offset), data)
-#endif	/* NETWARE || OTHER_32 || OTHER_16 */
-
-#if defined(NT) || defined(WIN95_32) || defined(WIN95_16)
-	#define RD_HARPOON(ioport)          OS_InPortByte((ULONG)ioport)
-	#define RDW_HARPOON(ioport)         OS_InPortWord((ULONG)ioport)
-	#define RD_HARP32(ioport,offset,data) (data = OS_InPortLong((ULONG)(ioport + offset)))
-	#define WR_HARPOON(ioport,val)      OS_OutPortByte((ULONG)ioport,(UCHAR) val)
-	#define WRW_HARPOON(ioport,val)     OS_OutPortWord((ULONG)ioport,(USHORT)val)
-	#define WR_HARP32(ioport,offset,data)  OS_OutPortLong((ULONG)(ioport + offset), data)
-#endif /* NT || WIN95_32 || WIN95_16 */
 
-#if defined (UNIX)
+
 	#define RD_HARPOON(ioport)          OS_InPortByte((u32bits)ioport)
 	#define RDW_HARPOON(ioport)         OS_InPortWord((u32bits)ioport)
 	#define RD_HARP32(ioport,offset,data) (data = OS_InPortLong((u32bits)(ioport + offset)))
 	#define WR_HARPOON(ioport,val)      OS_OutPortByte((u32bits)ioport,(u08bits) val)
 	#define WRW_HARPOON(ioport,val)       OS_OutPortWord((u32bits)ioport,(u16bits)val)
 	#define WR_HARP32(ioport,offset,data)  OS_OutPortLong((u32bits)(ioport + offset), data)
-#endif /* UNIX */
 
-#if defined(OS2)
-	#define RD_HARPOON(ioport)          OS_InPortByte((unsigned long)ioport)
-	#define RDW_HARPOON(ioport)         OS_InPortWord((unsigned long)ioport)
-	#define RD_HARP32(ioport,offset,data) (data = OS_InPortLong((ULONG)(ioport + offset)))
-	#define WR_HARPOON(ioport,val)      OS_OutPortByte((ULONG)ioport,(UCHAR) val)
-	#define WRW_HARPOON(ioport,val)       OS_OutPortWord((ULONG)ioport,(USHORT)val)
-	#define WR_HARP32(ioport,offset,data)  OS_OutPortLong(((ULONG)(ioport + offset)), data)
-#endif /* OS2 */
-
-#if defined(SOLARIS_REAL_MODE)
-
-	#define RD_HARPOON(ioport)          OS_InPortByte((unsigned long)ioport)
-	#define RDW_HARPOON(ioport)         OS_InPortWord((unsigned long)ioport)
-	#define RD_HARP32(ioport,offset,data) (data = OS_InPortLong((ULONG)(ioport + offset)))
-	#define WR_HARPOON(ioport,val)      OS_OutPortByte((ULONG)ioport,(UCHAR) val)
-	#define WRW_HARPOON(ioport,val)       OS_OutPortWord((ULONG)ioport,(USHORT)val)
-	#define WR_HARP32(ioport,offset,data)  OS_OutPortLong((ULONG)(ioport + offset), (ULONG)data)
 
-#endif  /* SOLARIS_REAL_MODE */
 
 #endif  /* __BLX30_H__ */
 
@@ -919,16 +683,8 @@ typedef struct _SCCB {
 #define  EE_WIDE_SCSI      BIT(7)
 
 
-#if defined(DOS)
-   typedef struct SCCBMgr_tar_info near *PSCCBMgr_tar_info;
-
-#elif defined(OS2)
-   typedef struct SCCBMgr_tar_info far *PSCCBMgr_tar_info;
-
-#else
    typedef struct SCCBMgr_tar_info *PSCCBMgr_tar_info;
 
-#endif
 
 
 typedef struct SCCBMgr_tar_info {
@@ -949,11 +705,7 @@ typedef struct SCCBMgr_tar_info {
 typedef struct NVRAMInfo {
 	UCHAR		niModel;								/* Model No. of card */
 	UCHAR		niCardNo;							/* Card no. */
-#if defined(DOS)
-	USHORT	niBaseAddr;							/* Port Address of card */
-#else
 	ULONG		niBaseAddr;							/* Port Address of card */
-#endif
 	UCHAR		niSysConf;							/* Adapter Configuration byte - Byte 16 of eeprom map */
 	UCHAR		niScsiConf;							/* SCSI Configuration byte - Byte 17 of eeprom map */
 	UCHAR		niScamConf;							/* SCAM Configuration byte - Byte 20 of eeprom map */
@@ -962,13 +714,7 @@ typedef struct NVRAMInfo {
 	UCHAR		niScamTbl[MAX_SCSI_TAR][4];	/* Compressed Scam name string of Targets */
 }NVRAMINFO;
 
-#if defined(DOS)
-typedef NVRAMINFO near *PNVRamInfo;
-#elif defined (OS2)
-typedef NVRAMINFO far *PNVRamInfo;
-#else
 typedef NVRAMINFO *PNVRamInfo;
-#endif
 
 #define	MODEL_LT		1
 #define	MODEL_DL		2
@@ -984,11 +730,7 @@ typedef struct SCCBcard {
    PADAPTER_INFO cardInfo;
 #endif
 
-#if defined(DOS)
-   USHORT ioPort;
-#else
    ULONG ioPort;
-#endif
 
    USHORT cmdCounter;
    UCHAR  discQCount;
@@ -1002,13 +744,7 @@ typedef struct SCCBcard {
       
 }SCCBCARD;
 
-#if defined(DOS)
-typedef struct SCCBcard near *PSCCBcard;
-#elif defined (OS2)
-typedef struct SCCBcard far *PSCCBcard;
-#else
 typedef struct SCCBcard *PSCCBcard;
-#endif
 
 
 #define F_TAG_STARTED		0x01
@@ -1972,15 +1708,6 @@ typedef struct SCCBscam_info {
                                  xfercnt <<= 16,\
                                  xfercnt |= RDW_HARPOON((USHORT)(port+hp_xfercnt_0)))
  */
-#if defined(DOS)
-#define HP_SETUP_ADDR_CNT(port,addr,count) (WRW_HARPOON((USHORT)(port+hp_host_addr_lo), (USHORT)(addr & 0x0000FFFFL)),\
-         addr >>= 16,\
-         WRW_HARPOON((USHORT)(port+hp_host_addr_hmi), (USHORT)(addr & 0x0000FFFFL)),\
-         WR_HARP32(port,hp_xfercnt_0,count),\
-         WRW_HARPOON((USHORT)(port+hp_xfer_cnt_lo), (USHORT)(count & 0x0000FFFFL)),\
-         count >>= 16,\
-         WR_HARPOON(port+hp_xfer_cnt_hi, (count & 0xFF)))
-#else
 #define HP_SETUP_ADDR_CNT(port,addr,count) (WRW_HARPOON((port+hp_host_addr_lo), (USHORT)(addr & 0x0000FFFFL)),\
          addr >>= 16,\
          WRW_HARPOON((port+hp_host_addr_hmi), (USHORT)(addr & 0x0000FFFFL)),\
@@ -1988,7 +1715,6 @@ typedef struct SCCBscam_info {
          WRW_HARPOON((port+hp_xfer_cnt_lo), (USHORT)(count & 0x0000FFFFL)),\
          count >>= 16,\
          WR_HARPOON(port+hp_xfer_cnt_hi, (count & 0xFF)))
-#endif
 
 #define ACCEPT_MSG(port) {while(RD_HARPOON(port+hp_scsisig) & SCSI_REQ){}\
                           WR_HARPOON(port+hp_scsisig, S_ILL_PH);}
@@ -2029,32 +1755,6 @@ void WriteNVRam(PSCCBcard pCurrCard,PUCB
 void UpdateCheckSum(u32bits baseport);
 #endif // (FW_TYPE==_UCB_MGR_)
 
-#if defined(DOS)
-UCHAR sfm(USHORT port, PSCCB pcurrSCCB);
-void  scsiStartAuto(USHORT port);
-UCHAR sisyncn(USHORT port, UCHAR p_card, UCHAR syncFlag);
-void  ssel(USHORT port, UCHAR p_card);
-void  sres(USHORT port, UCHAR p_card, PSCCBcard pCurrCard);
-void  sdecm(UCHAR message, USHORT port, UCHAR p_card);
-void  shandem(USHORT port, UCHAR p_card,PSCCB pCurrSCCB);
-void  stsyncn(USHORT port, UCHAR p_card);
-void  sisyncr(USHORT port,UCHAR sync_pulse, UCHAR offset);
-void  sssyncv(USHORT p_port, UCHAR p_id, UCHAR p_sync_value, PSCCBMgr_tar_info currTar_Info);
-void  sresb(USHORT port, UCHAR p_card);
-void  sxfrp(USHORT p_port, UCHAR p_card);
-void  schkdd(USHORT port, UCHAR p_card);
-UCHAR RdStack(USHORT port, UCHAR index);
-void  WrStack(USHORT portBase, UCHAR index, UCHAR data);
-UCHAR ChkIfChipInitialized(USHORT ioPort);
-
-#if defined(V302)
-UCHAR GetTarLun(USHORT port, UCHAR p_card, UCHAR our_target, PSCCBcard pCurrCard, PUCHAR tag, PUCHAR lun);
-#endif
-
-void SendMsg(USHORT port, UCHAR message);
-void  queueFlushTargSccb(UCHAR p_card, UCHAR thisTarg, UCHAR error_code);
-UCHAR scsellDOS(USHORT p_port, UCHAR targ_id);
-#else
 UCHAR sfm(ULONG port, PSCCB pcurrSCCB);
 void  scsiStartAuto(ULONG port);
 UCHAR sisyncn(ULONG port, UCHAR p_card, UCHAR syncFlag);
@@ -2078,22 +1778,15 @@ UCHAR GetTarLun(ULONG port, UCHAR p_card
 
 void SendMsg(ULONG port, UCHAR message);
 void  queueFlushTargSccb(UCHAR p_card, UCHAR thisTarg, UCHAR error_code);
-#endif
 
 void  ssenss(PSCCBcard pCurrCard);
 void  sinits(PSCCB p_sccb, UCHAR p_card);
 void  RNVRamData(PNVRamInfo pNvRamInfo);
 
 #if defined(WIDE_SCSI)
-   #if defined(DOS)
-   UCHAR siwidn(USHORT port, UCHAR p_card);
-   void  stwidn(USHORT port, UCHAR p_card);
-   void  siwidr(USHORT port, UCHAR width);
-   #else
    UCHAR siwidn(ULONG port, UCHAR p_card);
    void  stwidn(ULONG port, UCHAR p_card);
    void  siwidr(ULONG port, UCHAR width);
-   #endif
 #endif
 
 
@@ -2109,15 +1802,6 @@ USHORT CalcCrc16(UCHAR buffer[]);
 UCHAR  CalcLrc(UCHAR buffer[]);
 
 
-#if defined(DOS)
-void  Wait1Second(USHORT p_port);
-void  Wait(USHORT p_port, UCHAR p_delay);
-void  utilEEWriteOnOff(USHORT p_port,UCHAR p_mode);
-void  utilEEWrite(USHORT p_port, USHORT ee_data, USHORT ee_addr);
-USHORT utilEERead(USHORT p_port, USHORT ee_addr);
-USHORT utilEEReadOrg(USHORT p_port, USHORT ee_addr);
-void  utilEESendCmdAddr(USHORT p_port, UCHAR ee_cmd, USHORT ee_addr);
-#else
 void  Wait1Second(ULONG p_port);
 void  Wait(ULONG p_port, UCHAR p_delay);
 void  utilEEWriteOnOff(ULONG p_port,UCHAR p_mode);
@@ -2125,28 +1809,9 @@ void  utilEEWrite(ULONG p_port, USHORT e
 USHORT utilEERead(ULONG p_port, USHORT ee_addr);
 USHORT utilEEReadOrg(ULONG p_port, USHORT ee_addr);
 void  utilEESendCmdAddr(ULONG p_port, UCHAR ee_cmd, USHORT ee_addr);
-#endif
 
 
 
-#if defined(OS2)
-   void  far phaseDataOut(ULONG port, UCHAR p_card);
-   void  far phaseDataIn(ULONG port, UCHAR p_card);
-   void  far phaseCommand(ULONG port, UCHAR p_card);
-   void  far phaseStatus(ULONG port, UCHAR p_card);
-   void  far phaseMsgOut(ULONG port, UCHAR p_card);
-   void  far phaseMsgIn(ULONG port, UCHAR p_card);
-   void  far phaseIllegal(ULONG port, UCHAR p_card);
-#else
-   #if defined(DOS)
-      void  phaseDataOut(USHORT port, UCHAR p_card);
-      void  phaseDataIn(USHORT port, UCHAR p_card);
-      void  phaseCommand(USHORT port, UCHAR p_card);
-      void  phaseStatus(USHORT port, UCHAR p_card);
-      void  phaseMsgOut(USHORT port, UCHAR p_card);
-      void  phaseMsgIn(USHORT port, UCHAR p_card);
-      void  phaseIllegal(USHORT port, UCHAR p_card);
-   #else
       void  phaseDataOut(ULONG port, UCHAR p_card);
       void  phaseDataIn(ULONG port, UCHAR p_card);
       void  phaseCommand(ULONG port, UCHAR p_card);
@@ -2154,63 +1819,34 @@ void  utilEESendCmdAddr(ULONG p_port, UC
       void  phaseMsgOut(ULONG port, UCHAR p_card);
       void  phaseMsgIn(ULONG port, UCHAR p_card);
       void  phaseIllegal(ULONG port, UCHAR p_card);
-   #endif
-#endif
 
-#if defined(DOS)
-void  phaseDecode(USHORT port, UCHAR p_card);
-void  phaseChkFifo(USHORT port, UCHAR p_card);
-void  phaseBusFree(USHORT p_port, UCHAR p_card);
-#else
 void  phaseDecode(ULONG port, UCHAR p_card);
 void  phaseChkFifo(ULONG port, UCHAR p_card);
 void  phaseBusFree(ULONG p_port, UCHAR p_card);
-#endif
 
 
 
 
-#if defined(DOS)
-void  XbowInit(USHORT port, UCHAR scamFlg);
-void  BusMasterInit(USHORT p_port);
-int   DiagXbow(USHORT port);
-int   DiagBusMaster(USHORT port);
-void  DiagEEPROM(USHORT p_port);
-#else
 void  XbowInit(ULONG port, UCHAR scamFlg);
 void  BusMasterInit(ULONG p_port);
 int   DiagXbow(ULONG port);
 int   DiagBusMaster(ULONG port);
 void  DiagEEPROM(ULONG p_port);
-#endif
 
 
 
 
-#if defined(DOS)
-void  busMstrAbort(USHORT port);
-UCHAR busMstrTimeOut(USHORT port);
-void  dataXferProcessor(USHORT port, PSCCBcard pCurrCard);
-void  busMstrSGDataXferStart(USHORT port, PSCCB pCurrSCCB);
-void  busMstrDataXferStart(USHORT port, PSCCB pCurrSCCB);
-void  hostDataXferAbort(USHORT port, UCHAR p_card, PSCCB pCurrSCCB);
-#else
 void  busMstrAbort(ULONG port);
 UCHAR busMstrTimeOut(ULONG port);
 void  dataXferProcessor(ULONG port, PSCCBcard pCurrCard);
 void  busMstrSGDataXferStart(ULONG port, PSCCB pCurrSCCB);
 void  busMstrDataXferStart(ULONG port, PSCCB pCurrSCCB);
 void  hostDataXferAbort(ULONG port, UCHAR p_card, PSCCB pCurrSCCB);
-#endif
 void  hostDataXferRestart(PSCCB currSCCB);
 
 
-#if defined (DOS)
-UCHAR SccbMgr_bad_isr(USHORT p_port, UCHAR p_card, PSCCBcard pCurrCard, USHORT p_int);
-#else
 UCHAR SccbMgr_bad_isr(ULONG p_port, UCHAR p_card, PSCCBcard pCurrCard, USHORT p_int);
 
-#endif
 
 void  SccbMgrTableInitAll(void);
 void  SccbMgrTableInitCard(PSCCBcard pCurrCard, UCHAR p_card);
@@ -2220,22 +1856,6 @@ void  SccbMgrTableInitTarget(UCHAR p_car
 
 void  scini(UCHAR p_card, UCHAR p_our_id, UCHAR p_power_up);
 
-#if defined(DOS)
-int   scarb(USHORT p_port, UCHAR p_sel_type);
-void  scbusf(USHORT p_port);
-void  scsel(USHORT p_port);
-void  scasid(UCHAR p_card, USHORT p_port);
-UCHAR scxferc(USHORT p_port, UCHAR p_data);
-UCHAR scsendi(USHORT p_port, UCHAR p_id_string[]);
-UCHAR sciso(USHORT p_port, UCHAR p_id_string[]);
-void  scwirod(USHORT p_port, UCHAR p_data_bit);
-void  scwiros(USHORT p_port, UCHAR p_data_bit);
-UCHAR scvalq(UCHAR p_quintet);
-UCHAR scsell(USHORT p_port, UCHAR targ_id);
-void  scwtsel(USHORT p_port);
-void  inisci(UCHAR p_card, USHORT p_port, UCHAR p_our_id);
-void  scsavdi(UCHAR p_card, USHORT p_port);
-#else
 int   scarb(ULONG p_port, UCHAR p_sel_type);
 void  scbusf(ULONG p_port);
 void  scsel(ULONG p_port);
@@ -2250,17 +1870,11 @@ UCHAR scsell(ULONG p_port, UCHAR targ_id
 void  scwtsel(ULONG p_port);
 void  inisci(UCHAR p_card, ULONG p_port, UCHAR p_our_id);
 void  scsavdi(UCHAR p_card, ULONG p_port);
-#endif
 UCHAR scmachid(UCHAR p_card, UCHAR p_id_string[]);
 
 
-#if defined(DOS)
-void  autoCmdCmplt(USHORT p_port, UCHAR p_card);
-void  autoLoadDefaultMap(USHORT p_port);
-#else
 void  autoCmdCmplt(ULONG p_port, UCHAR p_card);
 void  autoLoadDefaultMap(ULONG p_port);
-#endif
 
 
 
@@ -2271,10 +1885,6 @@ void  autoLoadDefaultMap(ULONG p_port);
 	void  OS_enable_int(unsigned char intvec);
 	void  OS_delay(unsigned long count);
 	int   OS_VirtToPhys(u32bits CardHandle, u32bits *physaddr, u32bits *virtaddr);
-	#if !(defined(UNIX) || defined(OS2) || defined(SOLARIS_REAL_MODE)) 
-	void  OS_Lock(PSCCBMGR_INFO pCardInfo);
-	void  OS_UnLock(PSCCBMGR_INFO pCardInfo);
-#endif // if FW_TYPE == ...
 
 #endif
 
@@ -2282,21 +1892,10 @@ extern SCCBCARD BL_Card[MAX_CARDS];
 extern SCCBMGR_TAR_INFO sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR];
 
 
-#if defined(OS2)
-   extern void (far *s_PhaseTbl[8]) (ULONG, UCHAR);
-#else
-   #if defined(DOS)
-      extern void (*s_PhaseTbl[8]) (USHORT, UCHAR);
-   #else
       extern void (*s_PhaseTbl[8]) (ULONG, UCHAR);
-   #endif
-#endif
 
 extern SCCBSCAM_INFO scamInfo[MAX_SCSI_TAR];
 extern NVRAMINFO nvRamInfo[MAX_MB_CARDS];
-#if defined(DOS) || defined(OS2)
-extern UCHAR temp_id_string[ID_STRING_LENGTH];
-#endif
 extern UCHAR scamHAString[];
 
 
@@ -2307,17 +1906,7 @@ extern UCHAR debug_index[MAX_CARDS];
 void Debug_Load(UCHAR p_card, UCHAR p_bug_data);
 #endif
 
-#if (FW_TYPE==_SCCB_MGR_)
-#if defined(DOS)
-   extern UCHAR first_time;
-#endif
-#endif /* (FW_TYPE==_SCCB_MGR_) */
 
-#if (FW_TYPE==_UCB_MGR_)
-#if defined(DOS)
-   extern u08bits first_time;
-#endif
-#endif /* (FW_TYPE==_UCB_MGR_) */
 
 #if defined(BUGBUG)
 void Debug_Load(UCHAR p_card, UCHAR p_bug_data);
@@ -2378,15 +1967,7 @@ extern SCCBCARD BL_Card[MAX_CARDS];
 extern NVRAMINFO nvRamInfo[MAX_MB_CARDS];
 extern UCHAR mbCards;
 
-#if defined (OS2)
-   extern void (far *s_PhaseTbl[8]) (ULONG, UCHAR);
-#else
-   #if defined(DOS)
-      extern void (*s_PhaseTbl[8]) (USHORT, UCHAR);
-   #else
       extern void (*s_PhaseTbl[8]) (ULONG, UCHAR);
-   #endif
-#endif
 
 
 #if defined(BUGBUG)
@@ -2408,25 +1989,14 @@ void Debug_Load(UCHAR p_card, UCHAR p_bu
 
 int SccbMgr_sense_adapter(PSCCBMGR_INFO pCardInfo)
 {
-#if defined(DOS)
-#else
    static UCHAR first_time = 1;
-#endif
 
    UCHAR i,j,id,ScamFlg;
    USHORT temp,temp2,temp3,temp4,temp5,temp6;
-#if defined(DOS)
-   USHORT ioport;
-#else
    ULONG ioport;
-#endif
 	PNVRamInfo pCurrNvRam;
 
-#if defined(DOS)
-   ioport = (USHORT)pCardInfo->si_baseaddr;
-#else
    ioport = pCardInfo->si_baseaddr;
-#endif
 
 
    if (RD_HARPOON(ioport+hp_vendor_id_0) != ORION_VEND_0)
@@ -2712,27 +2282,15 @@ int SccbMgr_sense_adapter(PSCCBMGR_INFO 
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-USHORT SccbMgr_config_adapter(PSCCBMGR_INFO pCardInfo)
-#else
 ULONG SccbMgr_config_adapter(PSCCBMGR_INFO pCardInfo)
-#endif
 {
    PSCCBcard CurrCard = NULL;
 	PNVRamInfo pCurrNvRam;
    UCHAR i,j,thisCard, ScamFlg;
    USHORT temp,sync_bit_map,id;
-#if defined(DOS)
-   USHORT ioport;
-#else
    ULONG ioport;
-#endif
 
-#if defined(DOS)
-   ioport = (USHORT)pCardInfo->si_baseaddr;
-#else
    ioport = pCardInfo->si_baseaddr;
-#endif
 
    for(thisCard =0; thisCard <= MAX_CARDS; thisCard++) {
 
@@ -2915,11 +2473,7 @@ ULONG SccbMgr_config_adapter(PSCCBMGR_IN
    WR_HARPOON((ioport+hp_semaphore),
       (UCHAR)(RD_HARPOON((ioport+hp_semaphore)) | SCCB_MGR_PRESENT));
 
-#if defined(DOS)
-   return((USHORT)CurrCard);
-#else
    return((ULONG)CurrCard);
-#endif
 }
 
 #else  			/* end (FW_TYPE==_SCCB_MGR_)  */
@@ -2977,10 +2531,7 @@ STATIC s32bits probe_adapter(PADAPTER_IN
    u16bits temp,temp2,temp3,temp4;
    u08bits i,j,id;
 
-#if defined(DOS)
-#else
    static u08bits first_time = 1;
-#endif
    BASE_PORT ioport;
 	PNVRamInfo pCurrNvRam;
 
@@ -3886,11 +3437,7 @@ void ReadNVRam(PSCCBcard pCurrCard,PUCB 
 	u08bits *pdata;
 	u16bits i,numwrds,numbytes,offset,temp;
 	u08bits OneMore = FALSE;
-#if defined(DOS)
-	u16bits ioport;
-#else
 	u32bits ioport;
-#endif
 
 	numbytes = (u16bits) p_ucb->UCB_datalen;
 	ioport  = pCurrCard->ioPort;
@@ -3944,11 +3491,7 @@ void WriteNVRam(PSCCBcard pCurrCard,PUCB
 		u16bits  tempw;
 	} temp2;
 
-#if defined(DOS)
-	u16bits ioport;
-#else
 	u32bits ioport;
-#endif
 
 	numbytes = (u16bits) p_ucb->UCB_datalen;
 	ioport  = pCurrCard->ioPort;
@@ -4058,27 +3601,14 @@ void SccbMgr_restore_native_state(CARD_H
 #if (FW_TYPE==_UCB_MGR_)
 void SccbMgr_unload_card(CARD_HANDLE pCurrCard)
 #else
-#if defined(DOS)
-void SccbMgr_unload_card(USHORT pCurrCard)
-#else
 void SccbMgr_unload_card(ULONG pCurrCard)
 #endif
-#endif
 {
 	UCHAR i;
-#if defined(DOS)
-	USHORT portBase;
-	USHORT regOffset;
-#else
 	ULONG portBase;
 	ULONG regOffset;
-#endif
 	ULONG scamData;
-#if defined(OS2)
-	ULONG far *pScamTbl;
-#else
 	ULONG *pScamTbl;
-#endif
 	PNVRamInfo pCurrNvRam;
 
 	pCurrNvRam = ((PSCCBcard)pCurrCard)->pNvRamInfo;
@@ -4097,11 +3627,7 @@ void SccbMgr_unload_card(ULONG pCurrCard
 
 		for(i = 0; i < MAX_SCSI_TAR; i++){
 			regOffset = hp_aramBase + 64 + i*4;
-#if defined(OS2)
-			pScamTbl = (ULONG far *) &pCurrNvRam->niScamTbl[i];
-#else
 			pScamTbl = (ULONG *) &pCurrNvRam->niScamTbl[i];
-#endif
 			scamData = *pScamTbl;
 			WR_HARP32(portBase, regOffset, scamData);
 		}
@@ -4116,19 +3642,10 @@ void SccbMgr_unload_card(ULONG pCurrCard
 void RNVRamData(PNVRamInfo pNvRamInfo)
 {
 	UCHAR i;
-#if defined(DOS)
-	USHORT portBase;
-	USHORT regOffset;
-#else
 	ULONG portBase;
 	ULONG regOffset;
-#endif
 	ULONG scamData;
-#if defined (OS2)
-	ULONG far *pScamTbl;
-#else
 	ULONG *pScamTbl;
-#endif
 
 	pNvRamInfo->niModel    = RdStack(pNvRamInfo->niBaseAddr, 0);
 	pNvRamInfo->niSysConf  = RdStack(pNvRamInfo->niBaseAddr, 1);
@@ -4144,31 +3661,19 @@ void RNVRamData(PNVRamInfo pNvRamInfo)
 	for(i = 0; i < MAX_SCSI_TAR; i++){
 		regOffset = hp_aramBase + 64 + i*4;
 		RD_HARP32(portBase, regOffset, scamData);
-#if defined(OS2)
-		pScamTbl = (ULONG far *) &pNvRamInfo->niScamTbl[i];
-#else
 		pScamTbl = (ULONG *) &pNvRamInfo->niScamTbl[i];
-#endif
 		*pScamTbl = scamData;
 	}
 
 }
 
-#if defined(DOS)
-UCHAR RdStack(USHORT portBase, UCHAR index)
-#else
 UCHAR RdStack(ULONG portBase, UCHAR index)
-#endif
 {
 	WR_HARPOON(portBase + hp_stack_addr, index);
 	return(RD_HARPOON(portBase + hp_stack_data));
 }
 
-#if defined(DOS)
-void WrStack(USHORT portBase, UCHAR index, UCHAR data)
-#else
 void WrStack(ULONG portBase, UCHAR index, UCHAR data)
-#endif
 {
 	WR_HARPOON(portBase + hp_stack_addr, index);
 	WR_HARPOON(portBase + hp_stack_data, data);
@@ -4178,12 +3683,8 @@ void WrStack(ULONG portBase, UCHAR index
 #if (FW_TYPE==_UCB_MGR_)
 u08bits ChkIfChipInitialized(BASE_PORT ioPort)
 #else
-#if defined(DOS)
-UCHAR ChkIfChipInitialized(USHORT ioPort)
-#else
 UCHAR ChkIfChipInitialized(ULONG ioPort)
 #endif
-#endif
 {
 	if((RD_HARPOON(ioPort + hp_arb_id) & 0x0f) != RdStack(ioPort, 4))
 		return(FALSE);
@@ -4208,18 +3709,10 @@ UCHAR ChkIfChipInitialized(ULONG ioPort)
 #if (FW_TYPE==_UCB_MGR_)
 void SccbMgr_start_sccb(CARD_HANDLE pCurrCard, PUCB p_ucb)
 #else
-#if defined(DOS)
-void SccbMgr_start_sccb(USHORT pCurrCard, PSCCB p_Sccb)
-#else
 void SccbMgr_start_sccb(ULONG pCurrCard, PSCCB p_Sccb)
 #endif
-#endif
 {
-#if defined(DOS)
-   USHORT ioport;
-#else
    ULONG ioport;
-#endif
    UCHAR thisCard, lun;
 	PSCCB pSaveSccb;
    CALL_BK_FN callback;
@@ -4448,11 +3941,7 @@ void SccbMgr_start_sccb(ULONG pCurrCard,
 
             ((PSCCBcard) pCurrCard)->currentSCCB = p_Sccb;
 			   mOS_UnLock((PSCCBcard)pCurrCard);
-#if defined(DOS)
-            ssel((USHORT)p_Sccb->SccbIOPort,thisCard);
-#else
 	    ssel(p_Sccb->SccbIOPort,thisCard);
-#endif
 			   mOS_Lock((PSCCBcard)pCurrCard);
          }
 
@@ -4491,19 +3980,11 @@ void SccbMgr_start_sccb(ULONG pCurrCard,
 #if (FW_TYPE==_UCB_MGR_)
 s32bits SccbMgr_abort_sccb(CARD_HANDLE pCurrCard, PUCB p_ucb)
 #else
-#if defined(DOS)
-int SccbMgr_abort_sccb(USHORT pCurrCard, PSCCB p_Sccb)
-#else
 int SccbMgr_abort_sccb(ULONG pCurrCard, PSCCB p_Sccb)
 #endif
-#endif
 
 {
-#if defined(DOS)
-	USHORT ioport;
-#else
 	ULONG ioport;
-#endif
 
 	UCHAR thisCard;
 	CALL_BK_FN callback;
@@ -4629,27 +4110,16 @@ int SccbMgr_abort_sccb(ULONG pCurrCard, 
 #if (FW_TYPE==_UCB_MGR_)
 u08bits SccbMgr_my_int(CARD_HANDLE pCurrCard)
 #else
-#if defined(DOS)
-UCHAR SccbMgr_my_int(USHORT pCurrCard)
-#else
 UCHAR SccbMgr_my_int(ULONG pCurrCard)
 #endif
-#endif
 {
-#if defined(DOS)
-   USHORT ioport;
-#else
    ULONG ioport;
-#endif
 
    ioport = ((PSCCBcard)pCurrCard)->ioPort;
 
    if (RD_HARPOON(ioport+hp_int_status) & INT_ASSERTED)
    {
 
-#if defined(DOS)
-      MDISABLE_INT(ioport);
-#endif
 
       return(TRUE);
    }
@@ -4673,22 +4143,14 @@ UCHAR SccbMgr_my_int(ULONG pCurrCard)
 #if (FW_TYPE==_UCB_MGR_)
 s32bits SccbMgr_isr(CARD_HANDLE pCurrCard)
 #else
-#if defined(DOS)
-int SccbMgr_isr(USHORT pCurrCard)
-#else
 int SccbMgr_isr(ULONG pCurrCard)
 #endif
-#endif
 {
    PSCCB currSCCB;
    UCHAR thisCard,result,bm_status, bm_int_st;
    USHORT hp_int;
    UCHAR i, target;
-#if defined(DOS)
-   USHORT ioport;
-#else
    ULONG ioport;
-#endif
 
    mOS_Lock((PSCCBcard)pCurrCard);
 
@@ -4950,11 +4412,7 @@ int SccbMgr_isr(ULONG pCurrCard)
  *              processing time.
  *
  *---------------------------------------------------------------------*/
-#if defined(DOS)
-UCHAR SccbMgr_bad_isr(USHORT p_port, UCHAR p_card, PSCCBcard pCurrCard, USHORT p_int)
-#else
 UCHAR SccbMgr_bad_isr(ULONG p_port, UCHAR p_card, PSCCBcard pCurrCard, USHORT p_int)
-#endif
 {
 #if defined(HARP_REVX)
    ULONG timer;
@@ -5140,12 +4598,8 @@ PNVRamInfo pCurrNvRam;
 #if (FW_TYPE==_UCB_MGR_)
 void SccbMgr_scsi_reset(CARD_HANDLE pCurrCard)
 #else
-#if defined(DOS)
-void SccbMgr_scsi_reset(USHORT pCurrCard)
-#else
 void SccbMgr_scsi_reset(ULONG pCurrCard)
 #endif
-#endif
 {
    UCHAR thisCard;
 
@@ -5204,31 +4658,11 @@ void SccbMgr_scsi_reset(ULONG pCurrCard)
 #if (FW_TYPE==_UCB_MGR_)
 void SccbMgr_timer_expired(CARD_HANDLE pCurrCard)
 #else
-#if defined(DOS)
-void SccbMgr_timer_expired(USHORT pCurrCard)
-#else
 void SccbMgr_timer_expired(ULONG pCurrCard)
 #endif
-#endif
 {
 }
 
-#if defined(DOS)
-/*---------------------------------------------------------------------
- *
- * Function: SccbMgr_status
- *
- * Description: This function returns the number of outstanding SCCB's.
- *              This is specific to the DOS enviroment, which needs this
- *              to help them keep protected and real mode commands staight.
- *
- *---------------------------------------------------------------------*/
-
-USHORT SccbMgr_status(USHORT pCurrCard)
-{
-   return(BL_Card[pCurrCard].cmdCounter);
-}
-#endif
 
 /*---------------------------------------------------------------------
  *
@@ -5398,18 +4832,12 @@ SCCBSCAM_INFO scamInfo[MAX_SCSI_TAR] = {
 NVRAMINFO nvRamInfo[MAX_MB_CARDS] = { { 0 } };
 
 
-#if defined(OS2)
-void (far *s_PhaseTbl[8]) (ULONG, UCHAR) = { 0 };
-UCHAR temp_id_string[ID_STRING_LENGTH] = { 0 };
-#elif defined(SOLARIS_REAL_MODE) || defined(__STDC__)
+#if defined(__STDC__)
 void (*s_PhaseTbl[8]) (ULONG, UCHAR) = { 0 };
 #else
 void (*s_PhaseTbl[8]) ();
 #endif
 
-#if defined(DOS)
-UCHAR first_time = 0;
-#endif
 
 UCHAR mbCards = 0;
 UCHAR scamHAString[] = {0x63, 0x07, 'B', 'U', 'S', 'L', 'O', 'G', 'I', 'C', \
@@ -5476,11 +4904,7 @@ void Debug_Load(UCHAR p_card, UCHAR p_bu
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-UCHAR sfm(USHORT port, PSCCB pCurrSCCB)
-#else
 UCHAR sfm(ULONG port, PSCCB pCurrSCCB)
-#endif
 {
 	UCHAR message;
 	USHORT TimeOutLoop;
@@ -5553,27 +4977,12 @@ UCHAR sfm(ULONG port, PSCCB pCurrSCCB)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void ssel(USHORT port, UCHAR p_card)
-#else
 void ssel(ULONG port, UCHAR p_card)
-#endif
 {
 
-#if defined(DOS)
-   UCHAR auto_loaded, i, target, *theCCB;
-#elif defined(OS2)
-   UCHAR auto_loaded, i, target;
-   UCHAR far *theCCB;
-#else
    UCHAR auto_loaded, i, target, *theCCB;
-#endif
 
-#if defined(DOS)
-   USHORT cdb_reg;
-#else
    ULONG cdb_reg;
-#endif
    PSCCBcard CurrCard;
    PSCCB currSCCB;
    PSCCBMgr_tar_info currTar_Info;
@@ -5599,10 +5008,6 @@ void ssel(ULONG port, UCHAR p_card)
 		lun = 0;
 
 
-#if defined(DOS)
-   currTar_Info->TarLUNBusy[lun] = TRUE;
-
-#else
 
    if (CurrCard->globalFlags & F_TAG_STARTED)
       {
@@ -5651,7 +5056,6 @@ void ssel(ULONG port, UCHAR p_card)
         currTar_Info->TarLUNBusy[lun] = TRUE;
         }
 
-#endif /* DOS */
 
 
 
@@ -5765,7 +5169,6 @@ void ssel(ULONG port, UCHAR p_card)
    if (!auto_loaded)
       {
 
-#if !defined(DOS)
       if (currSCCB->ControlByte & F_USE_CMD_Q)
          {
 
@@ -5832,7 +5235,6 @@ void ssel(ULONG port, UCHAR p_card)
 
       else
          {
-#endif   /* !DOS */
 
          WRW_HARPOON((port+ID_MSG_STRT),BRH_OP+ALWAYS+NTCMD);
 
@@ -5842,16 +5244,10 @@ void ssel(ULONG port, UCHAR p_card)
          currSCCB->Sccb_scsistat = SELECT_ST;
 
          WR_HARPOON(port+hp_autostart_3, (SELECT+SELCHK_STRT));
-#if !defined(DOS)
          }
-#endif
 
 
-#if defined(OS2)
-      theCCB = (UCHAR far *)&currSCCB->Cdb[0];
-#else
       theCCB = (UCHAR *)&currSCCB->Cdb[0];
-#endif
 
       cdb_reg = port + CMD_STRT;
 
@@ -5905,20 +5301,11 @@ void ssel(ULONG port, UCHAR p_card)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void sres(USHORT port, UCHAR p_card, PSCCBcard pCurrCard)
-#else
 void sres(ULONG port, UCHAR p_card, PSCCBcard pCurrCard)
-#endif
 {
 
 #if defined(V302)
-#ifdef DOS
-   UCHAR our_target,message, msgRetryCount;
-   extern UCHAR lun, tag;
-#else
    UCHAR our_target,message,lun,tag, msgRetryCount;
-#endif
 
 #else  /* V302 */
    UCHAR our_target, message, lun = 0, tag, msgRetryCount;
@@ -6030,7 +5417,6 @@ void sres(ULONG port, UCHAR p_card, PSCC
 				{
 					lun = message & (UCHAR)LUN_MASK;
 
-#if !defined(DOS)
 					if ((currTar_Info->TarStatus & TAR_TAG_Q_MASK) == TAG_Q_TRYING)
 					{
 						if (currTar_Info->TarTagQ_Cnt != 0)
@@ -6063,7 +5449,6 @@ void sres(ULONG port, UCHAR p_card, PSCC
 						} /*End Q cnt != 0 */
 
 					} /*End Tag cmds supported! */
-#endif /* !DOS */
 
 				} /*End valid ID message.  */
 
@@ -6194,11 +5579,7 @@ void sres(ULONG port, UCHAR p_card, PSCC
 
 #if defined(V302)
 
-#if defined(DOS)
-UCHAR GetTarLun(USHORT port, UCHAR p_card, UCHAR our_target, PSCCBcard pCurrCard, PUCHAR tag, PUCHAR lun)
-#else
 UCHAR GetTarLun(ULONG port, UCHAR p_card, UCHAR our_target, PSCCBcard pCurrCard, PUCHAR tag, PUCHAR lun)
-#endif
 {
    UCHAR message;
    PSCCBMgr_tar_info currTar_Info;
@@ -6230,7 +5611,6 @@ UCHAR GetTarLun(ULONG port, UCHAR p_card
 			{
 				*lun = message & (UCHAR)LUN_MASK;
 
-#if !defined(DOS)
 				if ((currTar_Info->TarStatus & TAR_TAG_Q_MASK) == TAG_Q_TRYING)
 				{
 					if (currTar_Info->TarTagQ_Cnt != 0)
@@ -6259,7 +5639,6 @@ UCHAR GetTarLun(ULONG port, UCHAR p_card
 					} /*End Q cnt != 0 */
 
 				} /*End Tag cmds supported! */
-#endif /* !DOS */
 
 			} /*End valid ID message.  */
 
@@ -6287,11 +5666,7 @@ UCHAR GetTarLun(ULONG port, UCHAR p_card
 
 #endif /* V302 */
 
-#if defined(DOS)
-void SendMsg(USHORT port, UCHAR message)
-#else
 void SendMsg(ULONG port, UCHAR message)
-#endif
 {
 	while(!(RD_HARPOON(port+hp_scsisig) & SCSI_REQ))
 	{
@@ -6340,11 +5715,7 @@ void SendMsg(ULONG port, UCHAR message)
  *              target device.
  *
  *---------------------------------------------------------------------*/
-#if defined(DOS)
-void sdecm(UCHAR message, USHORT port, UCHAR p_card)
-#else
 void sdecm(UCHAR message, ULONG port, UCHAR p_card)
-#endif
 {
 	PSCCB currSCCB;
 	PSCCBcard CurrCard;
@@ -6525,11 +5896,7 @@ void sdecm(UCHAR message, ULONG port, UC
  * Description: Decide what to do with the extended message.
  *
  *---------------------------------------------------------------------*/
-#if defined(DOS)
-void shandem(USHORT port, UCHAR p_card, PSCCB pCurrSCCB)
-#else
 void shandem(ULONG port, UCHAR p_card, PSCCB pCurrSCCB)
-#endif
 {
 	UCHAR length,message;
 
@@ -6610,11 +5977,7 @@ void shandem(ULONG port, UCHAR p_card, P
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-UCHAR sisyncn(USHORT port, UCHAR p_card, UCHAR syncFlag)
-#else
 UCHAR sisyncn(ULONG port, UCHAR p_card, UCHAR syncFlag)
-#endif
 {
    PSCCB currSCCB;
    PSCCBMgr_tar_info currTar_Info;
@@ -6689,11 +6052,7 @@ UCHAR sisyncn(ULONG port, UCHAR p_card, 
  *              necessary.
  *
  *---------------------------------------------------------------------*/
-#if defined(DOS)
-void stsyncn(USHORT port, UCHAR p_card)
-#else
 void stsyncn(ULONG port, UCHAR p_card)
-#endif
 {
    UCHAR sync_msg,offset,sync_reg,our_sync_msg;
    PSCCB currSCCB;
@@ -6830,11 +6189,7 @@ void stsyncn(ULONG port, UCHAR p_card)
  * Description: Answer the targets sync message.
  *
  *---------------------------------------------------------------------*/
-#if defined(DOS)
-void sisyncr(USHORT port,UCHAR sync_pulse, UCHAR offset)
-#else
 void sisyncr(ULONG port,UCHAR sync_pulse, UCHAR offset)
-#endif
 {
    ARAM_ACCESS(port);
    WRW_HARPOON((port+SYNC_MSGS+0), (MPM_OP+AMSG_OUT+SMEXT ));
@@ -6867,11 +6222,7 @@ void sisyncr(ULONG port,UCHAR sync_pulse
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-UCHAR siwidn(USHORT port, UCHAR p_card)
-#else
 UCHAR siwidn(ULONG port, UCHAR p_card)
-#endif
 {
    PSCCB currSCCB;
    PSCCBMgr_tar_info currTar_Info;
@@ -6923,11 +6274,7 @@ UCHAR siwidn(ULONG port, UCHAR p_card)
  *              necessary.
  *
  *---------------------------------------------------------------------*/
-#if defined(DOS)
-void stwidn(USHORT port, UCHAR p_card)
-#else
 void stwidn(ULONG port, UCHAR p_card)
-#endif
 {
    UCHAR width;
    PSCCB currSCCB;
@@ -7007,11 +6354,7 @@ void stwidn(ULONG port, UCHAR p_card)
  * Description: Answer the targets Wide nego message.
  *
  *---------------------------------------------------------------------*/
-#if defined(DOS)
-void siwidr(USHORT port, UCHAR width)
-#else
 void siwidr(ULONG port, UCHAR width)
-#endif
 {
    ARAM_ACCESS(port);
    WRW_HARPOON((port+SYNC_MSGS+0), (MPM_OP+AMSG_OUT+SMEXT ));
@@ -7042,11 +6385,7 @@ void siwidr(ULONG port, UCHAR width)
  *              ID specified.
  *
  *---------------------------------------------------------------------*/
-#if defined(DOS)
-void sssyncv(USHORT p_port, UCHAR p_id, UCHAR p_sync_value,PSCCBMgr_tar_info currTar_Info)
-#else
 void sssyncv(ULONG p_port, UCHAR p_id, UCHAR p_sync_value,PSCCBMgr_tar_info currTar_Info)
-#endif
 {
    UCHAR index;
 
@@ -7117,11 +6456,7 @@ void sssyncv(ULONG p_port, UCHAR p_id, U
  * Description: Reset the desired card's SCSI bus.
  *
  *---------------------------------------------------------------------*/
-#if defined(DOS)
-void sresb(USHORT port, UCHAR p_card)
-#else
 void sresb(ULONG port, UCHAR p_card)
-#endif
 {
    UCHAR scsiID, i;
 
@@ -7243,11 +6578,7 @@ void ssenss(PSCCBcard pCurrCard)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void sxfrp(USHORT p_port, UCHAR p_card)
-#else
 void sxfrp(ULONG p_port, UCHAR p_card)
-#endif
 {
    UCHAR curr_phz;
 
@@ -7329,11 +6660,7 @@ void sxfrp(ULONG p_port, UCHAR p_card)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void schkdd(USHORT port, UCHAR p_card)
-#else
 void schkdd(ULONG port, UCHAR p_card)
-#endif
 {
    USHORT TimeOutLoop;
 	UCHAR sPhase;
@@ -7556,15 +6883,7 @@ void sinits(PSCCB p_sccb, UCHAR p_card)
 extern SCCBCARD BL_Card[MAX_CARDS];
 extern SCCBMGR_TAR_INFO sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR];
 
-#if defined(OS2)
-   extern void (far *s_PhaseTbl[8]) (ULONG, UCHAR);
-#else
-   #if defined(DOS)
-      extern void (*s_PhaseTbl[8]) (USHORT, UCHAR);
-   #else
       extern void (*s_PhaseTbl[8]) (ULONG, UCHAR);
-   #endif
-#endif
 */
 
 /*---------------------------------------------------------------------
@@ -7575,22 +6894,10 @@ extern SCCBMGR_TAR_INFO sccbMgrTbl[MAX_C
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void phaseDecode(USHORT p_port, UCHAR p_card)
-#else
 void phaseDecode(ULONG p_port, UCHAR p_card)
-#endif
 {
    unsigned char phase_ref;
-#if defined(OS2)
-   void (far *phase) (ULONG, UCHAR);
-#else
-   #if defined(DOS)
-      void (*phase) (USHORT, UCHAR);
-   #else
       void (*phase) (ULONG, UCHAR);
-   #endif
-#endif
 
 
    DISABLE_AUTO(p_port);
@@ -7612,15 +6919,7 @@ void phaseDecode(ULONG p_port, UCHAR p_c
  *
  *---------------------------------------------------------------------*/
 
-#if defined(OS2)
-void far phaseDataOut(ULONG port, UCHAR p_card)
-#else
-#if defined(DOS)
-void phaseDataOut(USHORT port, UCHAR p_card)
-#else
 void phaseDataOut(ULONG port, UCHAR p_card)
-#endif
-#endif
 {
 
    PSCCB currSCCB;
@@ -7671,15 +6970,7 @@ void phaseDataOut(ULONG port, UCHAR p_ca
  *
  *---------------------------------------------------------------------*/
 
-#if defined(OS2)
-void far phaseDataIn(ULONG port, UCHAR p_card)
-#else
-#if defined(DOS)
-void phaseDataIn(USHORT port, UCHAR p_card)
-#else
 void phaseDataIn(ULONG port, UCHAR p_card)
-#endif
-#endif
 {
 
    PSCCB currSCCB;
@@ -7726,22 +7017,10 @@ void phaseDataIn(ULONG port, UCHAR p_car
  *
  *---------------------------------------------------------------------*/
 
-#if defined(OS2)
-void far phaseCommand(ULONG p_port, UCHAR p_card)
-#else
-#if defined(DOS)
-void phaseCommand(USHORT p_port, UCHAR p_card)
-#else
 void phaseCommand(ULONG p_port, UCHAR p_card)
-#endif
-#endif
 {
    PSCCB currSCCB;
-#if defined(DOS)
-   USHORT cdb_reg;
-#else
    ULONG cdb_reg;
-#endif
    UCHAR i;
 
    currSCCB = BL_Card[p_card].currentSCCB;
@@ -7790,15 +7069,7 @@ void phaseCommand(ULONG p_port, UCHAR p_
  *
  *---------------------------------------------------------------------*/
 
-#if defined(OS2)
-void far phaseStatus(ULONG port, UCHAR p_card)
-#else
-#if defined(DOS)
-void phaseStatus(USHORT port, UCHAR p_card)
-#else
 void phaseStatus(ULONG port, UCHAR p_card)
-#endif
-#endif
 {
    /* Start-up the automation to finish off this command and let the
       isr handle the interrupt for command complete when it comes in.
@@ -7820,15 +7091,7 @@ void phaseStatus(ULONG port, UCHAR p_car
  *
  *---------------------------------------------------------------------*/
 
-#if defined(OS2)
-void far phaseMsgOut(ULONG port, UCHAR p_card)
-#else
-#if defined(DOS)
-void phaseMsgOut(USHORT port, UCHAR p_card)
-#else
 void phaseMsgOut(ULONG port, UCHAR p_card)
-#endif
-#endif
 {
 	UCHAR message,scsiID;
 	PSCCB currSCCB;
@@ -7976,15 +7239,7 @@ void phaseMsgOut(ULONG port, UCHAR p_car
  *
  *---------------------------------------------------------------------*/
 
-#if defined(OS2)
-void far phaseMsgIn(ULONG port, UCHAR p_card)
-#else
-#if defined(DOS)
-void phaseMsgIn(USHORT port, UCHAR p_card)
-#else
 void phaseMsgIn(ULONG port, UCHAR p_card)
-#endif
-#endif
 {
 	UCHAR message;
 	PSCCB currSCCB;
@@ -8037,15 +7292,7 @@ void phaseMsgIn(ULONG port, UCHAR p_card
  *
  *---------------------------------------------------------------------*/
 
-#if defined(OS2)
-void far phaseIllegal(ULONG port, UCHAR p_card)
-#else
-#if defined(DOS)
-void phaseIllegal(USHORT port, UCHAR p_card)
-#else
 void phaseIllegal(ULONG port, UCHAR p_card)
-#endif
-#endif
 {
    PSCCB currSCCB;
 
@@ -8073,11 +7320,7 @@ void phaseIllegal(ULONG port, UCHAR p_ca
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void phaseChkFifo(USHORT port, UCHAR p_card)
-#else
 void phaseChkFifo(ULONG port, UCHAR p_card)
-#endif
 {
    ULONG xfercnt;
    PSCCB currSCCB;
@@ -8116,22 +7359,7 @@ void phaseChkFifo(ULONG port, UCHAR p_ca
 
 
 
-#if defined(DOS)
-   asm { mov dx,port;
-      add dx,hp_xfercnt_2;
-      in  al,dx;
-      dec dx;
-      xor ah,ah;
-      mov word ptr xfercnt+2,ax;
-      in  al,dx;
-      dec dx;
-      mov ah,al;
-      in  al,dx;
-      mov word ptr xfercnt,ax;
-      }
-#else
    GET_XFER_CNT(port,xfercnt);
-#endif
 
 
    WR_HARPOON(port+hp_xfercnt_0, 0x00);
@@ -8170,11 +7398,7 @@ void phaseChkFifo(ULONG port, UCHAR p_ca
  *              because of command complete or from a disconnect.
  *
  *---------------------------------------------------------------------*/
-#if defined(DOS)
-void phaseBusFree(USHORT port, UCHAR p_card)
-#else
 void phaseBusFree(ULONG port, UCHAR p_card)
-#endif
 {
    PSCCB currSCCB;
 
@@ -8217,7 +7441,6 @@ void phaseBusFree(ULONG port, UCHAR p_ca
 	      sccbMgrTbl[p_card][currSCCB->TargID].TarEEValue &= ~EE_WIDE_SCSI;
 	      }
 
-#if !defined(DOS)
       else if(currSCCB->Sccb_scsistat == SELECT_Q_ST)
 	      {
 	      /* Make sure this is not a phony BUS_FREE.  If we were
@@ -8236,7 +7459,6 @@ void phaseBusFree(ULONG port, UCHAR p_ca
 	         return;
 	         }
          }
-#endif
 
       else
 	      {
@@ -8312,17 +7534,9 @@ extern SCCBCARD BL_Card[MAX_CARDS];
  * Description: Load the Automation RAM with the defualt map values.
  *
  *---------------------------------------------------------------------*/
-#if defined(DOS)
-void autoLoadDefaultMap(USHORT p_port)
-#else
 void autoLoadDefaultMap(ULONG p_port)
-#endif
 {
-#if defined(DOS)
-   USHORT map_addr;
-#else
    ULONG map_addr;
-#endif
 
    ARAM_ACCESS(p_port);
    map_addr = p_port + hp_aramBase;
@@ -8428,11 +7642,7 @@ void autoLoadDefaultMap(ULONG p_port)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void autoCmdCmplt(USHORT p_port, UCHAR p_card)
-#else
 void autoCmdCmplt(ULONG p_port, UCHAR p_card)
-#endif
 {
    PSCCB currSCCB;
    UCHAR status_byte;
@@ -8721,11 +7931,7 @@ void Debug_Load(UCHAR p_card, UCHAR p_bu
  *              
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void dataXferProcessor(USHORT port, PSCCBcard pCurrCard)
-#else
 void dataXferProcessor(ULONG port, PSCCBcard pCurrCard)
-#endif
 {
    PSCCB currSCCB;
 
@@ -8763,20 +7969,12 @@ void dataXferProcessor(ULONG port, PSCCB
  * Description:
  *
  *---------------------------------------------------------------------*/
-#if defined(DOS)
-void busMstrSGDataXferStart(USHORT p_port, PSCCB pcurrSCCB)
-#else
 void busMstrSGDataXferStart(ULONG p_port, PSCCB pcurrSCCB)
-#endif
 {
    ULONG count,addr,tmpSGCnt;
    UINT sg_index;
    UCHAR sg_count, i;
-#if defined(DOS)
-   USHORT reg_offset;
-#else
    ULONG reg_offset;
-#endif
 
 
    if (pcurrSCCB->Sccb_XferState & F_HOST_XFER_DIR) {
@@ -8802,17 +8000,6 @@ void busMstrSGDataXferStart(ULONG p_port
    while ((sg_count < (UCHAR)SG_BUF_CNT) &&
       ((ULONG)(sg_index * (UINT)SG_ELEMENT_SIZE) < pcurrSCCB->DataLength) ) {
 
-#if defined(COMPILER_16_BIT) && !defined(DOS)
-      tmpSGCnt += *(((ULONG far *)pcurrSCCB->DataPointer)+
-         (sg_index * 2));
-
-      count |= *(((ULONG far *)pcurrSCCB->DataPointer)+
-         (sg_index * 2));
-
-      addr = *(((ULONG far *)pcurrSCCB->DataPointer)+
-         ((sg_index * 2) + 1));
-
-#else
       tmpSGCnt += *(((ULONG *)pcurrSCCB->DataPointer)+
          (sg_index * 2));
 
@@ -8821,7 +8008,6 @@ void busMstrSGDataXferStart(ULONG p_port
 
       addr = *(((ULONG *)pcurrSCCB->DataPointer)+
          ((sg_index * 2) + 1));
-#endif
 
 
       if ((!sg_count) && (pcurrSCCB->Sccb_SGoffset)) {
@@ -8888,11 +8074,7 @@ void busMstrSGDataXferStart(ULONG p_port
  * Description: 
  *
  *---------------------------------------------------------------------*/
-#if defined(DOS)
-void busMstrDataXferStart(USHORT p_port, PSCCB pcurrSCCB)
-#else
 void busMstrDataXferStart(ULONG p_port, PSCCB pcurrSCCB)
-#endif
 {
    ULONG addr,count;
 
@@ -8909,37 +8091,7 @@ void busMstrDataXferStart(ULONG p_port, 
 
       }
 
-#if defined(DOS)
-   asm { mov dx,p_port;
-         mov ax,word ptr count;
-         add dx,hp_xfer_cnt_lo;
-         out dx,al;
-         inc dx;
-         xchg ah,al
-         out dx,al;
-         inc dx;
-         mov ax,word ptr count+2;
-         out dx,al;
-         inc dx;
-         inc dx;
-         mov ax,word ptr addr;
-         out dx,al;
-         inc dx;
-         xchg ah,al
-         out dx,al;
-         inc dx;
-         mov ax,word ptr addr+2;
-         out dx,al;
-         inc dx;
-         xchg ah,al
-         out dx,al;
-         }
-
-   WR_HARP32(p_port,hp_xfercnt_0,count);
-
-#else
    HP_SETUP_ADDR_CNT(p_port,addr,count);
-#endif
 
 
    if (pcurrSCCB->Sccb_XferState & F_HOST_XFER_DIR) {
@@ -8975,11 +8127,7 @@ void busMstrDataXferStart(ULONG p_port, 
  *               command busy is also time out, it'll just give up.
  *
  *---------------------------------------------------------------------*/
-#if defined(DOS)
-UCHAR busMstrTimeOut(USHORT p_port)
-#else
 UCHAR busMstrTimeOut(ULONG p_port)
-#endif
 {
    ULONG timeout;
 
@@ -9017,11 +8165,7 @@ UCHAR busMstrTimeOut(ULONG p_port)
  * Description: Abort any in progress transfer.
  *
  *---------------------------------------------------------------------*/
-#if defined(DOS)
-void hostDataXferAbort(USHORT port, UCHAR p_card, PSCCB pCurrSCCB)
-#else
 void hostDataXferAbort(ULONG port, UCHAR p_card, PSCCB pCurrSCCB)
-#endif
 {
 
    ULONG timeout;
@@ -9092,22 +8236,12 @@ void hostDataXferAbort(ULONG port, UCHAR
 
             sg_ptr--;
 
-#if defined(COMPILER_16_BIT) && !defined(DOS)
-            if (remain_cnt > (ULONG)(*(((ULONG far *)pCurrSCCB->
-               DataPointer) + (sg_ptr * 2)))) {
-
-               remain_cnt -= (ULONG)(*(((ULONG far *)pCurrSCCB->
-                  DataPointer) + (sg_ptr * 2)));
-               }
-
-#else
             if (remain_cnt > (ULONG)(*(((ULONG *)pCurrSCCB->
                DataPointer) + (sg_ptr * 2)))) {
 
                remain_cnt -= (ULONG)(*(((ULONG *)pCurrSCCB->
                   DataPointer) + (sg_ptr * 2)));
                }
-#endif
 
             else {
 
@@ -9309,11 +8443,7 @@ void hostDataXferRestart(PSCCB currSCCB)
 {
    ULONG data_count;
    UINT  sg_index;
-#if defined(COMPILER_16_BIT) && !defined(DOS)
-   ULONG far *sg_ptr;
-#else
    ULONG *sg_ptr;
-#endif
 
    if (currSCCB->Sccb_XferState & F_SG_XFER) {
 
@@ -9322,11 +8452,7 @@ void hostDataXferRestart(PSCCB currSCCB)
       sg_index = 0xffff;         /*Index by long words into sg list. */
       data_count = 0;            /*Running count of SG xfer counts. */
 
-#if defined(COMPILER_16_BIT) && !defined(DOS)
-      sg_ptr = (ULONG far *)currSCCB->DataPointer;
-#else
       sg_ptr = (ULONG *)currSCCB->DataPointer;
-#endif
 
       while (data_count < currSCCB->Sccb_ATC) {
 
@@ -9392,9 +8518,6 @@ extern SCCBMGR_TAR_INFO sccbMgrTbl[MAX_C
 extern SCCBCARD BL_Card[MAX_CARDS];
 extern SCCBSCAM_INFO scamInfo[MAX_SCSI_TAR];
 extern NVRAMINFO nvRamInfo[MAX_MB_CARDS];
-#if defined(DOS) || defined(OS2)
-extern UCHAR temp_id_string[ID_STRING_LENGTH];
-#endif
 extern UCHAR scamHAString[];
 */
 /*---------------------------------------------------------------------
@@ -9411,12 +8534,7 @@ void scini(UCHAR p_card, UCHAR p_our_id,
 #if defined(SCAM_LEV_2)
    UCHAR loser,assigned_id;
 #endif
-#if defined(DOS)
-
-   USHORT p_port;
-#else
    ULONG p_port;
-#endif
 
    UCHAR i,k,ScamFlg ;
    PSCCBcard currCard;
@@ -9591,16 +8709,6 @@ void scini(UCHAR p_card, UCHAR p_our_id,
       }
 
 
-#if defined(DOS)
-   for (i=0; i < MAX_SCSI_TAR; i++)
-   {
-     	if (((ScamFlg & SCAM_ENABLED) && (scamInfo[i].state == LEGACY))
-			|| (i != p_our_id))
-        	{
-         scsellDOS(p_port,i);
-  	      }
-  	}
-#endif
 
 /*
    for (i=0,k=0; i < MAX_SCSI_TAR; i++)
@@ -9626,11 +8734,7 @@ void scini(UCHAR p_card, UCHAR p_our_id,
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-int scarb(USHORT p_port, UCHAR p_sel_type)
-#else
 int scarb(ULONG p_port, UCHAR p_sel_type)
-#endif
 {
    if (p_sel_type == INIT_SELTD)
       {
@@ -9693,11 +8797,7 @@ int scarb(ULONG p_port, UCHAR p_sel_type
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void scbusf(USHORT p_port)
-#else
 void scbusf(ULONG p_port)
-#endif
 {
    WR_HARPOON(p_port+hp_page_ctrl,
       (RD_HARPOON(p_port+hp_page_ctrl) | G_INT_DISABLE));
@@ -9737,20 +8837,9 @@ void scbusf(ULONG p_port)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void scasid(UCHAR p_card, USHORT p_port)
-#else
 void scasid(UCHAR p_card, ULONG p_port)
-#endif
 {
-#if defined(DOS) || defined(OS2)
-   /* Use external defined in global space area, instead of Stack
-      space. WIN/95 DOS doesnot work TINY mode. The OS doesnot intialize
-      SS equal to DS. Thus the array allocated on stack doesnot get
-      access correctly */
-#else
    UCHAR temp_id_string[ID_STRING_LENGTH];
-#endif
 
    UCHAR i,k,scam_id;
 	UCHAR crcBytes[3];
@@ -9836,11 +8925,7 @@ void scasid(UCHAR p_card, ULONG p_port)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void scsel(USHORT p_port)
-#else
 void scsel(ULONG p_port)
-#endif
 {
 
    WR_HARPOON(p_port+hp_scsisig, SCSI_SEL);
@@ -9874,11 +8959,7 @@ void scsel(ULONG p_port)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-UCHAR scxferc(USHORT p_port, UCHAR p_data)
-#else
 UCHAR scxferc(ULONG p_port, UCHAR p_data)
-#endif
 {
    UCHAR curr_data, ret_data;
 
@@ -9929,11 +9010,7 @@ UCHAR scxferc(ULONG p_port, UCHAR p_data
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-UCHAR scsendi(USHORT p_port, UCHAR p_id_string[])
-#else
 UCHAR scsendi(ULONG p_port, UCHAR p_id_string[])
-#endif
 {
    UCHAR ret_data,byte_cnt,bit_cnt,defer;
 
@@ -9986,11 +9063,7 @@ UCHAR scsendi(ULONG p_port, UCHAR p_id_s
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-UCHAR sciso(USHORT p_port, UCHAR p_id_string[])
-#else
 UCHAR sciso(ULONG p_port, UCHAR p_id_string[])
-#endif
 {
    UCHAR ret_data,the_data,byte_cnt,bit_cnt;
 
@@ -10051,11 +9124,7 @@ UCHAR sciso(ULONG p_port, UCHAR p_id_str
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void scwirod(USHORT p_port, UCHAR p_data_bit)
-#else
 void scwirod(ULONG p_port, UCHAR p_data_bit)
-#endif
 {
    UCHAR i;
 
@@ -10084,11 +9153,7 @@ void scwirod(ULONG p_port, UCHAR p_data_
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void scwiros(USHORT p_port, UCHAR p_data_bit)
-#else
 void scwiros(ULONG p_port, UCHAR p_data_bit)
-#endif
 {
    UCHAR i;
 
@@ -10142,17 +9207,9 @@ UCHAR scvalq(UCHAR p_quintet)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-UCHAR scsell(USHORT p_port, UCHAR targ_id)
-#else
 UCHAR scsell(ULONG p_port, UCHAR targ_id)
-#endif
 {
-#if defined(DOS)
-   USHORT i;
-#else
    ULONG i;
-#endif
 
    WR_HARPOON(p_port+hp_page_ctrl,
       (RD_HARPOON(p_port+hp_page_ctrl) | G_INT_DISABLE));
@@ -10221,90 +9278,6 @@ UCHAR scsell(ULONG p_port, UCHAR targ_id
       }
 }
 
-#if defined(DOS)
-/*---------------------------------------------------------------------
- *
- * Function: scsell for DOS
- *
- * Description: Select the specified device ID using a selection timeout
- *              less than 2ms.  This was specially required to solve
- *              the problem with Plextor 12X CD-ROM drive. This drive
- *					 was responding the Selection at the end of 4ms and 
- *					 hanging the system.
- *
- *---------------------------------------------------------------------*/
-
-UCHAR scsellDOS(USHORT p_port, UCHAR targ_id)
-{
-   USHORT i;
-
-   WR_HARPOON(p_port+hp_page_ctrl,
-      (RD_HARPOON(p_port+hp_page_ctrl) | G_INT_DISABLE));
-
-   ARAM_ACCESS(p_port);
-
-   WR_HARPOON(p_port+hp_addstat,(RD_HARPOON(p_port+hp_addstat) | SCAM_TIMER));
-   WR_HARPOON(p_port+hp_seltimeout,TO_2ms);
-
-
-   for (i = p_port+CMD_STRT; i < p_port+CMD_STRT+12; i+=2) {
-      WRW_HARPOON(i, (MPM_OP+ACOMMAND));
-      }
-   WRW_HARPOON(i, (BRH_OP+ALWAYS+    NP));
-
-   WRW_HARPOON((p_port+hp_intstat),
-	       (RESET | TIMEOUT | SEL | BUS_FREE | AUTO_INT));
-
-   WR_HARPOON(p_port+hp_select_id, targ_id);
-
-   WR_HARPOON(p_port+hp_portctrl_0, SCSI_PORT);
-   WR_HARPOON(p_port+hp_autostart_3, (SELECT | CMD_ONLY_STRT));
-   WR_HARPOON(p_port+hp_scsictrl_0, (SEL_TAR | ENA_RESEL));
-
-
-   while (!(RDW_HARPOON((p_port+hp_intstat)) &
-	    (RESET | PROG_HLT | TIMEOUT | AUTO_INT))) {}
-
-   if (RDW_HARPOON((p_port+hp_intstat)) & RESET)
-         Wait(p_port, TO_250ms);
-
-   DISABLE_AUTO(p_port);
-
-   WR_HARPOON(p_port+hp_addstat,(RD_HARPOON(p_port+hp_addstat) & ~SCAM_TIMER));
-   WR_HARPOON(p_port+hp_seltimeout,TO_290ms);
-
-   SGRAM_ACCESS(p_port);
-
-   if (RDW_HARPOON((p_port+hp_intstat)) & (RESET | TIMEOUT) ) {
-
-      WRW_HARPOON((p_port+hp_intstat),
-		  (RESET | TIMEOUT | SEL | BUS_FREE | PHASE));
-
-      WR_HARPOON(p_port+hp_page_ctrl,
-         (RD_HARPOON(p_port+hp_page_ctrl) & ~G_INT_DISABLE));
-
-      return(FALSE);  /*No legacy device */
-      }
-
-   else {
-
-      while(!(RDW_HARPOON((p_port+hp_intstat)) & BUS_FREE)) {
-				if (RD_HARPOON(p_port+hp_scsisig) & SCSI_REQ)
-					{
-					WR_HARPOON(p_port+hp_scsisig, (SCSI_ACK + S_ILL_PH));
-      			ACCEPT_MSG(p_port);
-					}
-		}
-
-      WRW_HARPOON((p_port+hp_intstat), CLR_ALL_INT_1);
-
-      WR_HARPOON(p_port+hp_page_ctrl,
-         (RD_HARPOON(p_port+hp_page_ctrl) & ~G_INT_DISABLE));
-
-      return(TRUE);  /*Found one of them oldies! */
-      }
-}
-#endif  /* DOS */
 
 /*---------------------------------------------------------------------
  *
@@ -10314,11 +9287,7 @@ UCHAR scsellDOS(USHORT p_port, UCHAR tar
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void scwtsel(USHORT p_port)
-#else
 void scwtsel(ULONG p_port)
-#endif
 {
    while(!(RDW_HARPOON((p_port+hp_intstat)) & SCAM_SEL)) {}
 }
@@ -10332,11 +9301,7 @@ void scwtsel(ULONG p_port)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void inisci(UCHAR p_card, USHORT p_port, UCHAR p_our_id)
-#else
 void inisci(UCHAR p_card, ULONG p_port, UCHAR p_our_id)
-#endif
 {
    UCHAR i,k,max_id;
    USHORT ee_data;
@@ -10537,11 +9502,7 @@ UCHAR scmachid(UCHAR p_card, UCHAR p_id_
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void scsavdi(UCHAR p_card, USHORT p_port)
-#else
 void scsavdi(UCHAR p_card, ULONG p_port)
-#endif
 {
    UCHAR i,k,max_id;
    USHORT ee_data,sum_data;
@@ -10621,11 +9582,7 @@ void scsavdi(UCHAR p_card, ULONG p_port)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void XbowInit(USHORT port, UCHAR ScamFlg)
-#else
 void XbowInit(ULONG port, UCHAR ScamFlg)
-#endif
 {
 UCHAR i;
 
@@ -10700,11 +9657,7 @@ UCHAR i;
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void BusMasterInit(USHORT p_port)
-#else
 void BusMasterInit(ULONG p_port)
-#endif
 {
 
 
@@ -10719,12 +9672,6 @@ void BusMasterInit(ULONG p_port)
    WR_HARPOON(p_port+hp_ee_ctrl, (SCSI_TERM_ENA_H));
 
 
-#if defined(NT)
-
-   WR_HARPOON(p_port+hp_pci_cmd_cfg, (RD_HARPOON(p_port+hp_pci_cmd_cfg)
-      & ~MEM_SPACE_ENA));
-
-#endif
 
    RD_HARPOON(p_port+hp_int_status);        /*Clear interrupts. */
    WR_HARPOON(p_port+hp_int_mask, (INT_CMD_COMPL | SCSI_INTERRUPT));
@@ -10741,11 +9688,7 @@ void BusMasterInit(ULONG p_port)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-int DiagXbow(USHORT port)
-#else
 int DiagXbow(ULONG port)
-#endif
 {
    unsigned char fifo_cnt,loop_cnt;
 
@@ -10827,11 +9770,7 @@ int DiagXbow(ULONG port)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-int DiagBusMaster(USHORT port)
-#else
 int DiagBusMaster(ULONG port)
-#endif
 {
    UCHAR testdata;
 
@@ -10870,11 +9809,7 @@ int DiagBusMaster(ULONG port)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void DiagEEPROM(USHORT p_port)
-#else
 void DiagEEPROM(ULONG p_port)
-#endif
 
 {
    USHORT index,temp,max_wd_cnt;
@@ -11640,11 +10575,7 @@ void  utilUpdateResidual(PSCCB p_SCCB)
 {
    ULONG partial_cnt;
    UINT  sg_index;
-#if defined(COMPILER_16_BIT) && !defined(DOS)
-   ULONG far *sg_ptr;
-#else
    ULONG *sg_ptr;
-#endif
 
    if (p_SCCB->Sccb_XferState & F_ALL_XFERRED) {
 
@@ -11657,11 +10588,7 @@ void  utilUpdateResidual(PSCCB p_SCCB)
 
 		 sg_index = p_SCCB->Sccb_sgseg;
 
-#if defined(COMPILER_16_BIT) && !defined(DOS)
-		 sg_ptr = (ULONG far *)p_SCCB->DataPointer;
-#else
 		 sg_ptr = (ULONG *)p_SCCB->DataPointer;
-#endif
 
 		 if (p_SCCB->Sccb_SGoffset) {
 
@@ -11694,11 +10621,7 @@ void  utilUpdateResidual(PSCCB p_SCCB)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void Wait1Second(USHORT p_port)
-#else
 void Wait1Second(ULONG p_port)
-#endif
 {
    UCHAR i;
 
@@ -11723,11 +10646,7 @@ void Wait1Second(ULONG p_port)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void Wait(USHORT p_port, UCHAR p_delay)
-#else
 void Wait(ULONG p_port, UCHAR p_delay)
-#endif
 {
    UCHAR old_timer;
    UCHAR green_flag;
@@ -11775,11 +10694,7 @@ void Wait(ULONG p_port, UCHAR p_delay)
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void utilEEWriteOnOff(USHORT p_port,UCHAR p_mode)
-#else
 void utilEEWriteOnOff(ULONG p_port,UCHAR p_mode)
-#endif
 {
    UCHAR ee_value;
 
@@ -11808,11 +10723,7 @@ void utilEEWriteOnOff(ULONG p_port,UCHAR
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void utilEEWrite(USHORT p_port, USHORT ee_data, USHORT ee_addr)
-#else
 void utilEEWrite(ULONG p_port, USHORT ee_data, USHORT ee_addr)
-#endif
 {
 
    UCHAR ee_value;
@@ -11863,11 +10774,7 @@ void utilEEWrite(ULONG p_port, USHORT ee
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-USHORT utilEERead(USHORT p_port, USHORT ee_addr)
-#else
 USHORT utilEERead(ULONG p_port, USHORT ee_addr)
-#endif
 {
    USHORT i, ee_data1, ee_data2;
 
@@ -11897,11 +10804,7 @@ USHORT utilEERead(ULONG p_port, USHORT e
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-USHORT utilEEReadOrg(USHORT p_port, USHORT ee_addr)
-#else
 USHORT utilEEReadOrg(ULONG p_port, USHORT ee_addr)
-#endif
 {
 
    UCHAR ee_value;
@@ -11949,11 +10852,7 @@ USHORT utilEEReadOrg(ULONG p_port, USHOR
  *
  *---------------------------------------------------------------------*/
 
-#if defined(DOS)
-void utilEESendCmdAddr(USHORT p_port, UCHAR ee_cmd, USHORT ee_addr)
-#else
 void utilEESendCmdAddr(ULONG p_port, UCHAR ee_cmd, USHORT ee_addr)
-#endif
 {
    UCHAR ee_value;
    UCHAR narrow_flg;
_
