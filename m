From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 2/7] mptfusion: Cleanups, split driver support, DMA32_BIT_
	MASK support
Date: Tue, 29 Mar 2005 13:05:08 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C01C2B981@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C5349A.9B209960"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:23975 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261350AbVC2UFO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2005 15:05:14 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id j2TK2NJg001618
	for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2005 12:02:23 -0800 (PST)
Received: from nacos172.ad.lsil.com (cos1.co.lsil.com [172.21.35.122])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id j2TK5AXa017408
	for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2005 12:05:10 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C5349A.9B209960
Content-Type: text/plain;
	charset="iso-8859-1"

Changelog: mptbase.[c,h]

(1) Use the DMA_32BIT_MASK constant
(2) Remove credits, -sralston references , update copyright
(3) split driver support

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>



------_=_NextPart_000_01C5349A.9B209960
Content-Type: application/octet-stream;
	name="patch-2-mptbase"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch-2-mptbase"

diff -puN scsi-rc-fixes-2.6/drivers/message/fusion-3.01.20/mptbase.c =
scsi-rc-fixes-2.6/drivers/message/fusion/mptbase.c=0A=
--- scsi-rc-fixes-2.6/drivers/message/fusion-3.01.20/mptbase.c	=
2005-03-29 11:19:00.000000000 -0700=0A=
+++ scsi-rc-fixes-2.6/drivers/message/fusion/mptbase.c	2005-03-28 =
17:10:49.000000000 -0700=0A=
@@ -1,55 +1,13 @@=0A=
 /*=0A=
  *  linux/drivers/message/fusion/mptbase.c=0A=
- *      High performance SCSI + LAN / Fibre Channel device drivers.=0A=
  *      This is the Fusion MPT base driver which supports multiple=0A=
  *      (SCSI + LAN) specialized protocol drivers.=0A=
- *      For use with PCI chip/adapter(s):=0A=
- *          LSIFC9xx/LSI409xx Fibre Channel=0A=
+ *      For use with LSI Logic PCI chip/adapter(s)=0A=
  *      running LSI Logic Fusion MPT (Message Passing Technology) =
firmware.=0A=
  *=0A=
- *  Credits:=0A=
- *      There are lots of people not mentioned below that deserve =
credit=0A=
- *      and thanks but won't get it here - sorry in advance that =
you=0A=
- *      got overlooked.=0A=
- *=0A=
- *      This driver would not exist if not for Alan Cox's =
development=0A=
- *      of the linux i2o driver.=0A=
- *=0A=
- *      A special thanks to Noah Romer (LSI Logic) for tons of work=0A=
- *      and tough debugging on the LAN driver, especially early =
on;-)=0A=
- *      And to Roger Hickerson (LSI Logic) for tirelessly =
supporting=0A=
- *      this driver project.=0A=
- *=0A=
- *      A special thanks to Pamela Delaney (LSI Logic) for tons of =
work=0A=
- *      and countless enhancements while adding support for the =
1030=0A=
- *      chip family.  Pam has been instrumental in the development =
of=0A=
- *      of the 2.xx.xx series fusion drivers, and her contributions =
are=0A=
- *      far too numerous to hope to list in one place.=0A=
- *=0A=
- *      All manner of help from Stephen Shirron (LSI Logic):=0A=
- *      low-level FC analysis, debug + various fixes in FCxx =
firmware,=0A=
- *      initial port to alpha platform, various driver code =
optimizations,=0A=
- *      being a faithful sounding board on all sorts of issues & =
ideas,=0A=
- *      etc.=0A=
- *=0A=
- *      A huge debt of gratitude is owed to David S. Miller (DaveM)=0A=
- *      for fixing much of the stupid and broken stuff in the early=0A=
- *      driver while porting to sparc64 platform.  THANK YOU!=0A=
- *=0A=
- *      Special thanks goes to the I2O LAN driver people at the=0A=
- *      University of Helsinki, who, unbeknownst to them, provided=0A=
- *      the inspiration and initial structure for this driver.=0A=
- *=0A=
- *      A really huge debt of gratitude is owed to Eddie C. Dost=0A=
- *      for gobs of hard work fixing and optimizing LAN code.=0A=
- *      THANK YOU!=0A=
- *=0A=
- *  Copyright (c) 1999-2004 LSI Logic Corporation=0A=
- *  Originally By: Steven J. Ralston=0A=
- *  (mailto:sjralston1@netscape.net)=0A=
+ *  Copyright (c) 1999-2005 LSI Logic Corporation=0A=
  *  (mailto:mpt_linux_developer@lsil.com)=0A=
  *=0A=
- *  $Id: mptbase.c,v 1.126 2002/12/16 15:28:45 pdelaney Exp $=0A=
  */=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
@@ -101,6 +59,7 @@=0A=
 #include <linux/blkdev.h>=0A=
 #include <linux/delay.h>=0A=
 #include <linux/interrupt.h>		/* needed for in_interrupt() proto */=0A=
+#include <linux/dma-mapping.h>=0A=
 #include <asm/io.h>=0A=
 #ifdef CONFIG_MTRR=0A=
 #include <asm/mtrr.h>=0A=
@@ -330,8 +289,7 @@ mpt_interrupt(int irq, void *bus_id, str=0A=
 					ioc->name, mr, req_idx));=0A=
 			DBG_DUMP_REPLY_FRAME(mr)=0A=
 =0A=
-			/* NEW!  20010301 -sralston=0A=
-			 *  Check/log IOC log info=0A=
+			/*  Check/log IOC log info=0A=
 			 */=0A=
 			ioc_stat =3D le16_to_cpu(mr->u.reply.IOCStatus);=0A=
 			if (ioc_stat & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE) {=0A=
@@ -357,9 +315,7 @@ mpt_interrupt(int irq, void *bus_id, str=0A=
 				mr =3D (MPT_FRAME_HDR *) CAST_U32_TO_PTR(pa);=0A=
 			} else if (type =3D=3D MPI_CONTEXT_REPLY_TYPE_LAN) {=0A=
 				cb_idx =3D mpt_lan_index;=0A=
-				/*=0A=
-				 * BUG FIX!  20001218 -sralston=0A=
-				 *  Blind set of mf to NULL here was fatal=0A=
+				 /*  Blind set of mf to NULL here was fatal=0A=
 				 *  after lan_reply says "freeme"=0A=
 				 *  Fix sort of combined with an optimization here;=0A=
 				 *  added explicit check for case where lan_reply=0A=
@@ -737,6 +693,13 @@ mpt_device_driver_register(struct mpt_pc=0A=
 	/* call per pci device probe entry point */=0A=
 	list_for_each_entry(ioc, &ioc_list, list) {=0A=
 		if(dd_cbfunc->probe) {=0A=
+			if((cb_idx =3D=3D MPTSPI_DRIVER) &&=0A=
+			    (ioc->bus_type !=3D SCSI))=0A=
+				continue;=0A=
+			if((cb_idx =3D=3D MPTFC_DRIVER) && (ioc->bus_type !=3D FC))=0A=
+				continue;=0A=
+			if((cb_idx =3D=3D MPTSAS_DRIVER) && (ioc->bus_type !=3D SAS))=0A=
+				continue;=0A=
 			error =3D dd_cbfunc->probe(ioc->pcidev,=0A=
 			  ioc->pcidev->driver->id_table);=0A=
 			if(error !=3D 0)=0A=
@@ -1084,7 +1047,6 @@ mptbase_probe(struct pci_dev *pdev, cons=0A=
 	u32		 psize;=0A=
 	int		 ii;=0A=
 	int		 r =3D -ENODEV;=0A=
-	u64		 mask =3D 0xffffffffffffffffULL;=0A=
 	u8		 revision;=0A=
 	u8		 pcixcmd;=0A=
 	static int	 mpt_ids =3D 0;=0A=
@@ -1097,15 +1059,15 @@ mptbase_probe(struct pci_dev *pdev, cons=0A=
 	=0A=
 	dinitprintk((KERN_WARNING MYNAM ": mpt_adapter_install\n"));=0A=
 	=0A=
-	if (!pci_set_dma_mask(pdev, mask)) {=0A=
+	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {=0A=
 		dprintk((KERN_INFO MYNAM=0A=
 			": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n"));=0A=
-	} else if (pci_set_dma_mask(pdev, (u64) 0xffffffff)) {=0A=
+	} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {=0A=
 		printk(KERN_WARNING MYNAM ": 32 BIT PCI BUS DMA ADDRESSING NOT =
SUPPORTED\n");=0A=
 		return r;=0A=
 	}=0A=
 =0A=
-	if (!pci_set_consistent_dma_mask(pdev, mask))=0A=
+	if (!pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))=0A=
 		dprintk((KERN_INFO MYNAM=0A=
 			": Using 64 bit consistent mask\n"));=0A=
 	else=0A=
@@ -1303,8 +1265,7 @@ mptbase_probe(struct pci_dev *pdev, cons=0A=
 #endif=0A=
 	}=0A=
 =0A=
-	/* NEW!  20010220 -sralston=0A=
-	 * Check for "bound ports" (929, 929X, 1030, 1035) to reduce =
redundant resets.=0A=
+	/* Check for "bound ports" (929, 929X, 1030, 1035) to reduce =
redundant resets.=0A=
 	 */=0A=
 	mpt_detect_bound_ports(ioc, pdev);=0A=
 =0A=
@@ -1719,8 +1680,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3=0A=
 		ioc->alt_ioc->active =3D 1;=0A=
 	}=0A=
 =0A=
-	/* NEW!  20010120 -sralston=0A=
-	 *  Enable MPT base driver management of EventNotification=0A=
+	/*  Enable MPT base driver management of EventNotification=0A=
 	 *  and EventAck handling.=0A=
 	 */=0A=
 	if ((ret =3D=3D 0) && (!ioc->facts.EventState))=0A=
@@ -1729,9 +1689,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3=0A=
 	if (ioc->alt_ioc && alt_ioc_ready && =
!ioc->alt_ioc->facts.EventState)=0A=
 		(void) SendEventNotification(ioc->alt_ioc, 1);	/* 1=3DEnable =
EventNotification */=0A=
 =0A=
-	/* (Bugzilla:fibrebugs, #513)=0A=
-	 * Bug fix (part 2)!  20010905 -sralston=0A=
-	 *	Add additional "reason" check before call to GetLanConfigPages=0A=
+	/*	Add additional "reason" check before call to GetLanConfigPages=0A=
 	 *	(combined with GetIoUnitPage2 call).  This prevents a somewhat=0A=
 	 *	recursive scenario; GetLanConfigPages times out, timer expired=0A=
 	 *	routine calls HardResetHandler, which calls into here again,=0A=
@@ -4753,9 +4711,7 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS=0A=
 	u32		 flagsLength;=0A=
 	int		 in_isr;=0A=
 =0A=
-	/* (Bugzilla:fibrebugs, #513)=0A=
-	 * Bug fix (part 1)!  20010905 -sralston=0A=
-	 *	Prevent calling wait_event() (below), if caller happens=0A=
+	/*	Prevent calling wait_event() (below), if caller happens=0A=
 	 *	to be in ISR context, because that is fatal!=0A=
 	 */=0A=
 	in_isr =3D in_interrupt();=0A=
@@ -4861,9 +4817,7 @@ mpt_toolbox(MPT_ADAPTER *ioc, CONFIGPARM=0A=
 	u32		 flagsLength;=0A=
 	int		 in_isr;=0A=
 =0A=
-	/* (Bugzilla:fibrebugs, #513)=0A=
-	 * Bug fix (part 1)!  20010905 -sralston=0A=
-	 *	Prevent calling wait_event() (below), if caller happens=0A=
+	/*	Prevent calling wait_event() (below), if caller happens=0A=
 	 *	to be in ISR context, because that is fatal!=0A=
 	 */=0A=
 	in_isr =3D in_interrupt();=0A=
@@ -5130,20 +5084,26 @@ static int=0A=
 procmpt_version_read(char *buf, char **start, off_t offset, int =
request, int *eof, void *data)=0A=
 {=0A=
 	int	 ii;=0A=
-	int	 scsi, lan, ctl, targ, dmp;=0A=
+	int	 scsi, fc, sas, lan, ctl, targ, dmp;=0A=
 	char	*drvname;=0A=
 	int	 len;=0A=
 =0A=
 	len =3D sprintf(buf, "%s-%s\n", "mptlinux", =
MPT_LINUX_VERSION_COMMON);=0A=
 	len +=3D sprintf(buf+len, "  Fusion MPT base driver\n");=0A=
 =0A=
-	scsi =3D lan =3D ctl =3D targ =3D dmp =3D 0;=0A=
+	scsi =3D fc =3D sas =3D lan =3D ctl =3D targ =3D dmp =3D 0;=0A=
 	for (ii=3DMPT_MAX_PROTOCOL_DRIVERS-1; ii; ii--) {=0A=
 		drvname =3D NULL;=0A=
 		if (MptCallbacks[ii]) {=0A=
 			switch (MptDriverClass[ii]) {=0A=
-			case MPTSCSIH_DRIVER:=0A=
-				if (!scsi++) drvname =3D "SCSI host";=0A=
+			case MPTSPI_DRIVER:=0A=
+				if (!scsi++) drvname =3D "SPI host";=0A=
+				break;=0A=
+			case MPTFC_DRIVER:=0A=
+				if (!fc++) drvname =3D "FC host";=0A=
+				break;=0A=
+			case MPTSAS_DRIVER:=0A=
+				if (!sas++) drvname =3D "SAS host";=0A=
 				break;=0A=
 			case MPTLAN_DRIVER:=0A=
 				if (!lan++) drvname =3D "LAN";=0A=
@@ -5896,8 +5856,7 @@ fusion_init(void)=0A=
 		MptResetHandlers[i] =3D NULL;=0A=
 	}=0A=
 =0A=
-	/* NEW!  20010120 -sralston=0A=
-	 *  Register ourselves (mptbase) in order to facilitate=0A=
+	/*  Register ourselves (mptbase) in order to facilitate=0A=
 	 *  EventNotification handling.=0A=
 	 */=0A=
 	mpt_base_index =3D mpt_register(mpt_base_reply, MPTBASE_DRIVER);=0A=
diff -puN scsi-rc-fixes-2.6/drivers/message/fusion-3.01.20/mptbase.h =
scsi-rc-fixes-2.6/drivers/message/fusion/mptbase.h=0A=
--- scsi-rc-fixes-2.6/drivers/message/fusion-3.01.20/mptbase.h	=
2005-03-29 11:19:00.000000000 -0700=0A=
+++ scsi-rc-fixes-2.6/drivers/message/fusion/mptbase.h	2005-03-28 =
17:08:53.000000000 -0700=0A=
@@ -5,15 +5,9 @@=0A=
  *          LSIFC9xx/LSI409xx Fibre Channel=0A=
  *      running LSI Logic Fusion MPT (Message Passing Technology) =
firmware.=0A=
  *=0A=
- *  Credits:=0A=
- *     (see mptbase.c)=0A=
- *=0A=
- *  Copyright (c) 1999-2004 LSI Logic Corporation=0A=
- *  Originally By: Steven J. Ralston=0A=
- *  (mailto:sjralston1@netscape.net)=0A=
+ *  Copyright (c) 1999-2005 LSI Logic Corporation=0A=
  *  (mailto:mpt_linux_developer@lsil.com)=0A=
  *=0A=
- *  $Id: mptbase.h,v 1.144 2003/01/28 21:31:56 pdelaney Exp $=0A=
  */=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
@@ -80,11 +74,11 @@=0A=
 #endif=0A=
 =0A=
 #ifndef COPYRIGHT=0A=
-#define COPYRIGHT	"Copyright (c) 1999-2004 " MODULEAUTHOR=0A=
+#define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.01.20"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.20"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.03.00"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.00"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=
@@ -95,7 +89,7 @@=0A=
  *  Fusion MPT(linux) driver configurable stuff...=0A=
  */=0A=
 #define MPT_MAX_ADAPTERS		18=0A=
-#define MPT_MAX_PROTOCOL_DRIVERS	16=0A=
+#define MPT_MAX_PROTOCOL_DRIVERS	32=0A=
 #define MPT_MAX_BUS			1	/* Do not change */=0A=
 #define MPT_MAX_FC_DEVICES		255=0A=
 #define MPT_MAX_SCSI_DEVICES		16=0A=
@@ -203,7 +197,9 @@=0A=
 typedef enum {=0A=
 	MPTBASE_DRIVER,		/* MPT base class */=0A=
 	MPTCTL_DRIVER,		/* MPT ioctl class */=0A=
-	MPTSCSIH_DRIVER,	/* MPT SCSI host (initiator) class */=0A=
+	MPTSPI_DRIVER,		/* MPT SPI host class */=0A=
+	MPTFC_DRIVER,		/* MPT FC host class */=0A=
+	MPTSAS_DRIVER,		/* MPT SAS host class */=0A=
 	MPTLAN_DRIVER,		/* MPT LAN class */=0A=
 	MPTSTM_DRIVER,		/* MPT SCSI target mode class */=0A=
 	MPTUNKNOWN_DRIVER=0A=
@@ -483,6 +479,7 @@ typedef	struct _ScsiCfgData {=0A=
 	u8		 forceDv;		/* 1 to force DV scheduling */=0A=
 	u8		 noQas;			/* Disable QAS for this adapter */=0A=
 	u8		 Saf_Te;		/* 1 to force all Processors as SAF-TE if Inquiry data =
length is too short to check for SAF-TE */=0A=
+	u8		 mpt_dv;		/* command line option: enhanced=3D1, basic=3D0 */=0A=
 	u8		 rsvd[1];=0A=
 } ScsiCfgData;=0A=
 =0A=
@@ -576,6 +573,9 @@ typedef struct _MPT_ADAPTER=0A=
 	u8			 reload_fw;	/* Force a FW Reload on next reset */=0A=
 	u8			 NBShiftFactor;  /* NB Shift Factor based on Block Size (Facts)  =
*/     =0A=
 	u8			 pad1[4];=0A=
+	int			 DoneCtx;=0A=
+	int			 TaskCtx;=0A=
+	int			 InternalCtx;=0A=
 	struct list_head	 list; =0A=
 	struct net_device	*netdev;=0A=
 } MPT_ADAPTER;=0A=
@@ -773,12 +773,6 @@ typedef struct _mpt_sge {=0A=
 #define DBG_DUMP_TM_REPLY_FRAME(mfp)=0A=
 #endif=0A=
 =0A=
-#ifdef MPT_DEBUG_NEH=0A=
-#define nehprintk(x) printk x=0A=
-#else=0A=
-#define nehprintk(x)=0A=
-#endif=0A=
-=0A=
 #if defined(MPT_DEBUG_CONFIG) || defined(MPT_DEBUG)=0A=
 #define dcprintk(x) printk x=0A=
 #else=0A=
@@ -898,6 +892,11 @@ typedef struct _MPT_SCSI_HOST {=0A=
 	unsigned long		  soft_resets;		/* fw/external bus resets count */=0A=
 	unsigned long		  timeouts;		/* cmd timeouts */=0A=
 	ushort			  sel_timeout[MPT_MAX_FC_DEVICES];=0A=
+	char 			  *info_kbuf;=0A=
+	wait_queue_head_t	  scandv_waitq;=0A=
+	int			  scandv_wait_done;=0A=
+	long			  last_queue_full;=0A=
+	u8		 	  mpt_pq_filter;=0A=
 } MPT_SCSI_HOST;=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 =0A=

------_=_NextPart_000_01C5349A.9B209960--
