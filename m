From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 2/7] mptfusion: mptbase cleanup, split driver support, DMA
	32_BIT_MASK
Date: Wed, 20 Apr 2005 11:43:54 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C020C435D@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C545D0.857BE2D0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:49369 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261770AbVDTRoI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 13:44:08 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id j3KHf46U013262
	for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 10:41:04 -0700 (PDT)
Received: from nacos172.ad.lsil.com (cos1.co.lsil.com [172.21.35.122])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id j3KHi3Vc020841
	for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 10:44:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C545D0.857BE2D0
Content-Type: text/plain;
	charset="iso-8859-1"

mptfusion patch 2/7:

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-kernel/3.03.00/

Changelog:

(1) mptbase.c: Move registering pci ids to scsi lld drivers 
(2) mptbase.c: Use the DMA_32BIT_MASK constant
(3) mptbase.c: Fix for multiple pci domains
(4) mptbase.c: Remove le32 conversion from BlockSize, which was u8 size
(5) mptbase.c: Remove credits, -sralston references , update copyright
(6) mptbase.c: split driver support

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


------_=_NextPart_000_01C545D0.857BE2D0
Content-Type: application/octet-stream;
	name="patch-2-mptbase.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch-2-mptbase.patch"

--- b/drivers/message/fusion/mptbase.c	2005-04-19 08:38:57.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.c	2005-04-19 14:13:27.000000000 =
-0600=0A=
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
@@ -218,35 +177,9 @@=0A=
 static void	mpt_sp_log_info(MPT_ADAPTER *ioc, u32 log_info);=0A=
 =0A=
 /* module entry point */=0A=
-static int  __devinit mptbase_probe (struct pci_dev *, const struct =
pci_device_id *);=0A=
-static void __devexit mptbase_remove(struct pci_dev *);=0A=
-static void mptbase_shutdown(struct device * );=0A=
 static int  __init    fusion_init  (void);=0A=
 static void __exit    fusion_exit  (void);=0A=
 =0A=
-/**********************************************************************=
******=0A=
- * Supported hardware=0A=
- */=0A=
-=0A=
-static struct pci_device_id mptbase_pci_table[] =3D {=0A=
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC909,=0A=
-		PCI_ANY_ID, PCI_ANY_ID },=0A=
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC929,=0A=
-		PCI_ANY_ID, PCI_ANY_ID },=0A=
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC919,=0A=
-		PCI_ANY_ID, PCI_ANY_ID },=0A=
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC929X,=0A=
-		PCI_ANY_ID, PCI_ANY_ID },=0A=
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC919X,=0A=
-		PCI_ANY_ID, PCI_ANY_ID },=0A=
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1030,=0A=
-		PCI_ANY_ID, PCI_ANY_ID },=0A=
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_1030_53C1035,=0A=
-		PCI_ANY_ID, PCI_ANY_ID },=0A=
-	{0}	/* Terminating entry */=0A=
-};=0A=
-MODULE_DEVICE_TABLE(pci, mptbase_pci_table);=0A=
-=0A=
 #define CHIPREG_READ32(addr) 		readl_relaxed(addr)=0A=
 #define CHIPREG_READ32_dmasync(addr)	readl(addr)=0A=
 #define CHIPREG_WRITE32(addr,val) 	writel(val, addr)=0A=
@@ -330,8 +263,7 @@=0A=
 					ioc->name, mr, req_idx));=0A=
 			DBG_DUMP_REPLY_FRAME(mr)=0A=
 =0A=
-			/* NEW!  20010301 -sralston=0A=
-			 *  Check/log IOC log info=0A=
+			/*  Check/log IOC log info=0A=
 			 */=0A=
 			ioc_stat =3D le16_to_cpu(mr->u.reply.IOCStatus);=0A=
 			if (ioc_stat & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE) {=0A=
@@ -357,9 +289,7 @@=0A=
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
@@ -725,11 +655,9 @@=0A=
 mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, int =
cb_idx)=0A=
 {=0A=
 	MPT_ADAPTER	*ioc;=0A=
-	int 		error=3D0;=0A=
 =0A=
 	if (cb_idx < 1 || cb_idx >=3D MPT_MAX_PROTOCOL_DRIVERS) {=0A=
-		error=3D -EINVAL;=0A=
-		return error;=0A=
+		return -EINVAL;=0A=
 	}=0A=
 =0A=
 	MptDeviceDriverHandlers[cb_idx] =3D dd_cbfunc;=0A=
@@ -737,14 +665,12 @@=0A=
 	/* call per pci device probe entry point */=0A=
 	list_for_each_entry(ioc, &ioc_list, list) {=0A=
 		if(dd_cbfunc->probe) {=0A=
-			error =3D dd_cbfunc->probe(ioc->pcidev,=0A=
+			dd_cbfunc->probe(ioc->pcidev,=0A=
 			  ioc->pcidev->driver->id_table);=0A=
-			if(error !=3D 0)=0A=
-				return error;=0A=
   		}=0A=
 	 }=0A=
 =0A=
-	return error;=0A=
+	return 0;=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -1058,7 +984,7 @@=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
- *	mptbase_probe - Install a PCI intelligent MPT adapter.=0A=
+ *	mpt_attach - Install a PCI intelligent MPT adapter.=0A=
  *	@pdev: Pointer to pci_dev structure=0A=
  *=0A=
  *	This routine performs all the steps necessary to bring the IOC =
of=0A=
@@ -1073,8 +999,8 @@=0A=
  *=0A=
  *	TODO: Add support for polled controllers=0A=
  */=0A=
-static int __devinit=0A=
-mptbase_probe(struct pci_dev *pdev, const struct pci_device_id *id)=0A=
+int=0A=
+mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)=0A=
 {=0A=
 	MPT_ADAPTER	*ioc;=0A=
 	u8		__iomem *mem;=0A=
@@ -1084,7 +1010,6 @@=0A=
 	u32		 psize;=0A=
 	int		 ii;=0A=
 	int		 r =3D -ENODEV;=0A=
-	u64		 mask =3D 0xffffffffffffffffULL;=0A=
 	u8		 revision;=0A=
 	u8		 pcixcmd;=0A=
 	static int	 mpt_ids =3D 0;=0A=
@@ -1097,15 +1022,15 @@=0A=
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
@@ -1303,8 +1228,7 @@=0A=
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
@@ -1354,13 +1278,13 @@=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
- *	mptbase_remove - Remove a PCI intelligent MPT adapter.=0A=
+ *	mpt_detach - Remove a PCI intelligent MPT adapter.=0A=
  *	@pdev: Pointer to pci_dev structure=0A=
  *=0A=
  */=0A=
 =0A=
-static void __devexit=0A=
-mptbase_remove(struct pci_dev *pdev)=0A=
+void=0A=
+mpt_detach(struct pci_dev *pdev)=0A=
 {=0A=
 	MPT_ADAPTER 	*ioc =3D pci_get_drvdata(pdev);=0A=
 	char pname[32];=0A=
@@ -1397,43 +1321,21 @@=0A=
 	pci_set_drvdata(pdev, NULL);=0A=
 }=0A=
 =0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/*=0A=
- *	mptbase_shutdown -=0A=
- *=0A=
- */=0A=
-static void=0A=
-mptbase_shutdown(struct device * dev)=0A=
-{=0A=
-	int ii;=0A=
-=0A=
-	/* call per device driver shutdown entry point */=0A=
-	for(ii=3D0; ii<MPT_MAX_PROTOCOL_DRIVERS; ii++) {=0A=
-		if(MptDeviceDriverHandlers[ii] &&=0A=
-		  MptDeviceDriverHandlers[ii]->shutdown) {=0A=
-			MptDeviceDriverHandlers[ii]->shutdown(dev);=0A=
-		}=0A=
-	}=0A=
-=0A=
-}=0A=
-=0A=
-=0A=
 =
/***********************************************************************=
***=0A=
  * Power Management=0A=
  */=0A=
 #ifdef CONFIG_PM=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
- *	mptbase_suspend - Fusion MPT base driver suspend routine.=0A=
+ *	mpt_suspend - Fusion MPT base driver suspend routine.=0A=
  *=0A=
  *=0A=
  */=0A=
-static int=0A=
-mptbase_suspend(struct pci_dev *pdev, pm_message_t state)=0A=
+int=0A=
+mpt_suspend(struct pci_dev *pdev, pm_message_t state)=0A=
 {=0A=
 	u32 device_state;=0A=
 	MPT_ADAPTER *ioc =3D pci_get_drvdata(pdev);=0A=
-	int ii;=0A=
 =0A=
 	switch(state)=0A=
 	{=0A=
@@ -1453,14 +1355,6 @@=0A=
 	"pci-suspend: pdev=3D0x%p, slot=3D%s, Entering operating state =
[D%d]\n",=0A=
 		ioc->name, pdev, pci_name(pdev), device_state);=0A=
 =0A=
-	/* call per device driver suspend entry point */=0A=
-	for(ii=3D0; ii<MPT_MAX_PROTOCOL_DRIVERS; ii++) {=0A=
-		if(MptDeviceDriverHandlers[ii] &&=0A=
-		  MptDeviceDriverHandlers[ii]->suspend) {=0A=
-			MptDeviceDriverHandlers[ii]->suspend(pdev, state);=0A=
-		}=0A=
-	}=0A=
-=0A=
 	pci_save_state(pdev);=0A=
 =0A=
 	/* put ioc into READY_STATE */=0A=
@@ -1484,18 +1378,18 @@=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
- *	mptbase_resume - Fusion MPT base driver resume routine.=0A=
+ *	mpt_resume - Fusion MPT base driver resume routine.=0A=
  *=0A=
  *=0A=
  */=0A=
-static int=0A=
-mptbase_resume(struct pci_dev *pdev)=0A=
+int=0A=
+mpt_resume(struct pci_dev *pdev)=0A=
 {=0A=
 	MPT_ADAPTER *ioc =3D pci_get_drvdata(pdev);=0A=
 	u32 device_state =3D pdev->current_state;=0A=
 	int recovery_state;=0A=
 	int ii;=0A=
-=0A=
+	=0A=
 	printk(MYIOC_s_INFO_FMT=0A=
 	"pci-resume: pdev=3D0x%p, slot=3D%s, Previous operating state =
[D%d]\n",=0A=
 		ioc->name, pdev, pci_name(pdev), device_state);=0A=
@@ -1533,14 +1427,6 @@=0A=
 			"pci-resume: success\n", ioc->name);=0A=
 	}=0A=
 =0A=
-	/* call per device driver resume entry point */=0A=
-	for(ii=3D0; ii<MPT_MAX_PROTOCOL_DRIVERS; ii++) {=0A=
-		if(MptDeviceDriverHandlers[ii] &&=0A=
-		  MptDeviceDriverHandlers[ii]->resume) {=0A=
-			MptDeviceDriverHandlers[ii]->resume(pdev);=0A=
-		}=0A=
-	}=0A=
-=0A=
 	return 0;=0A=
 }=0A=
 #endif=0A=
@@ -1719,8 +1605,7 @@=0A=
 		ioc->alt_ioc->active =3D 1;=0A=
 	}=0A=
 =0A=
-	/* NEW!  20010120 -sralston=0A=
-	 *  Enable MPT base driver management of EventNotification=0A=
+	/*  Enable MPT base driver management of EventNotification=0A=
 	 *  and EventAck handling.=0A=
 	 */=0A=
 	if ((ret =3D=3D 0) && (!ioc->facts.EventState))=0A=
@@ -1729,9 +1614,7 @@=0A=
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
@@ -1829,37 +1712,43 @@=0A=
 static void=0A=
 mpt_detect_bound_ports(MPT_ADAPTER *ioc, struct pci_dev *pdev)=0A=
 {=0A=
-	unsigned int match_lo, match_hi;=0A=
+	struct pci_dev *peer=3DNULL;=0A=
+	unsigned int slot =3D PCI_SLOT(pdev->devfn);=0A=
+	unsigned int func =3D PCI_FUNC(pdev->devfn);=0A=
 	MPT_ADAPTER *ioc_srch;=0A=
 =0A=
-	match_lo =3D pdev->devfn-1;=0A=
-	match_hi =3D pdev->devfn+1;=0A=
-	dprintk((MYIOC_s_INFO_FMT "PCI bus/devfn=3D%x/%x, searching for devfn =
match on %x or %x\n",=0A=
-			ioc->name, pdev->bus->number, pdev->devfn, match_lo, match_hi));=0A=
+	dprintk((MYIOC_s_INFO_FMT "PCI device %s devfn=3D%x/%x,"=0A=
+	    " searching for devfn match on %x or %x\n",=0A=
+		ioc->name, pci_name(pdev), pdev->devfn,=0A=
+		func-1, func+1));=0A=
+=0A=
+	peer =3D pci_get_slot(pdev->bus, PCI_DEVFN(slot,func-1));=0A=
+	if (!peer) {=0A=
+		peer =3D pci_get_slot(pdev->bus, PCI_DEVFN(slot,func+1));=0A=
+		if (!peer)=0A=
+			return;=0A=
+	}=0A=
 =0A=
 	list_for_each_entry(ioc_srch, &ioc_list, list) {=0A=
 		struct pci_dev *_pcidev =3D ioc_srch->pcidev;=0A=
-=0A=
-		if ((_pcidev->device =3D=3D pdev->device) &&=0A=
-		    (_pcidev->bus->number =3D=3D pdev->bus->number) &&=0A=
-		    (_pcidev->devfn =3D=3D match_lo || _pcidev->devfn =3D=3D =
match_hi) ) {=0A=
+		if (_pcidev =3D=3D peer) {=0A=
 			/* Paranoia checks */=0A=
 			if (ioc->alt_ioc !=3D NULL) {=0A=
 				printk(KERN_WARNING MYNAM ": Oops, already bound (%s <=3D=3D> =
%s)!\n",=0A=
-						ioc->name, ioc->alt_ioc->name);=0A=
+					ioc->name, ioc->alt_ioc->name);=0A=
 				break;=0A=
 			} else if (ioc_srch->alt_ioc !=3D NULL) {=0A=
 				printk(KERN_WARNING MYNAM ": Oops, already bound (%s <=3D=3D> =
%s)!\n",=0A=
-						ioc_srch->name, ioc_srch->alt_ioc->name);=0A=
+					ioc_srch->name, ioc_srch->alt_ioc->name);=0A=
 				break;=0A=
 			}=0A=
 			dprintk((KERN_INFO MYNAM ": FOUND! binding %s <=3D=3D> %s\n",=0A=
-					ioc->name, ioc_srch->name));=0A=
+				ioc->name, ioc_srch->name));=0A=
 			ioc_srch->alt_ioc =3D ioc;=0A=
 			ioc->alt_ioc =3D ioc_srch;=0A=
-			break;=0A=
 		}=0A=
 	}=0A=
+	pci_dev_put(peer);=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -2333,7 +2222,7 @@=0A=
 			return -55;=0A=
 		}=0A=
 =0A=
-		r =3D sz =3D le32_to_cpu(facts->BlockSize);=0A=
+		r =3D sz =3D facts->BlockSize;=0A=
 		vv =3D ((63 / (sz * 4)) + 1) & 0x03;=0A=
 		ioc->NB_for_64_byte_frame =3D vv;=0A=
 		while ( sz )=0A=
@@ -4250,7 +4139,7 @@=0A=
 				if ((ioc->spi_data.busType =3D=3D =
MPI_SCSIPORTPAGE0_PHY_SIGNAL_HVD) ||=0A=
 					(ioc->spi_data.busType =3D=3D MPI_SCSIPORTPAGE0_PHY_SIGNAL_SE))  =
{=0A=
 =0A=
-					if (ioc->spi_data.minSyncFactor < MPT_ULTRA)=0A=
+				if (ioc->spi_data.minSyncFactor < MPT_ULTRA)=0A=
 						ioc->spi_data.minSyncFactor =3D MPT_ULTRA;=0A=
 				}=0A=
 			}=0A=
@@ -4753,9 +4642,7 @@=0A=
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
@@ -4861,9 +4748,7 @@=0A=
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
@@ -5130,20 +5015,26 @@=0A=
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
@@ -5832,6 +5723,12 @@=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+EXPORT_SYMBOL(mpt_attach);=0A=
+EXPORT_SYMBOL(mpt_detach);=0A=
+#ifdef CONFIG_PM=0A=
+EXPORT_SYMBOL(mpt_resume);=0A=
+EXPORT_SYMBOL(mpt_suspend);=0A=
+#endif=0A=
 EXPORT_SYMBOL(ioc_list);=0A=
 EXPORT_SYMBOL(mpt_proc_root_dir);=0A=
 EXPORT_SYMBOL(mpt_register);=0A=
@@ -5860,19 +5757,6 @@=0A=
 EXPORT_SYMBOL(mpt_alloc_fw_memory);=0A=
 EXPORT_SYMBOL(mpt_free_fw_memory);=0A=
 =0A=
-static struct pci_driver mptbase_driver =3D {=0A=
-	.name		=3D "mptbase",=0A=
-	.id_table	=3D mptbase_pci_table,=0A=
-	.probe		=3D mptbase_probe,=0A=
-	.remove		=3D __devexit_p(mptbase_remove),=0A=
-	.driver         =3D {=0A=
-		.shutdown =3D mptbase_shutdown,=0A=
-        },=0A=
-#ifdef CONFIG_PM=0A=
-	.suspend	=3D mptbase_suspend,=0A=
-	.resume		=3D mptbase_resume,=0A=
-#endif=0A=
-};=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
@@ -5884,7 +5768,6 @@=0A=
 fusion_init(void)=0A=
 {=0A=
 	int i;=0A=
-	int r;=0A=
 =0A=
 	show_mptmod_ver(my_NAME, my_VERSION);=0A=
 	printk(KERN_INFO COPYRIGHT "\n");=0A=
@@ -5896,8 +5779,7 @@=0A=
 		MptResetHandlers[i] =3D NULL;=0A=
 	}=0A=
 =0A=
-	/* NEW!  20010120 -sralston=0A=
-	 *  Register ourselves (mptbase) in order to facilitate=0A=
+	/*  Register ourselves (mptbase) in order to facilitate=0A=
 	 *  EventNotification handling.=0A=
 	 */=0A=
 	mpt_base_index =3D mpt_register(mpt_base_reply, MPTBASE_DRIVER);=0A=
@@ -5913,11 +5795,7 @@=0A=
 #ifdef CONFIG_PROC_FS=0A=
 	(void) procmpt_create();=0A=
 #endif=0A=
-	r =3D pci_register_driver(&mptbase_driver);=0A=
-	if(r)=0A=
-		return(r);=0A=
-=0A=
-	return r;=0A=
+	return 0;=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -5933,7 +5811,6 @@=0A=
 =0A=
 	dexitprintk((KERN_INFO MYNAM ": fusion_exit() called!\n"));=0A=
 =0A=
-	pci_unregister_driver(&mptbase_driver);=0A=
 	mpt_reset_deregister(mpt_base_index);=0A=
 =0A=
 #ifdef CONFIG_PROC_FS=0A=
@@ -5941,6 +5818,5 @@=0A=
 #endif=0A=
 }=0A=
 =0A=
-=0A=
 module_init(fusion_init);=0A=
 module_exit(fusion_exit);=0A=
--- b/drivers/message/fusion/mptbase.h	2005-04-19 08:38:57.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.h	2005-04-19 14:13:27.000000000 =
-0600=0A=
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
@@ -71,7 +65,6 @@=0A=
 #include "lsi/mpi_fc.h"		/* Fibre Channel (lowlevel) support */=0A=
 #include "lsi/mpi_targ.h"	/* SCSI/FCP Target protcol support */=0A=
 #include "lsi/mpi_tool.h"	/* Tools support */=0A=
-#include "lsi/fc_log.h"=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 =0A=
@@ -80,11 +73,11 @@=0A=
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
@@ -203,7 +196,9 @@=0A=
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
@@ -212,11 +207,6 @@=0A=
 struct mpt_pci_driver{=0A=
 	int  (*probe) (struct pci_dev *dev, const struct pci_device_id =
*id);=0A=
 	void (*remove) (struct pci_dev *dev);=0A=
-	void (*shutdown) (struct device * dev);=0A=
-#ifdef CONFIG_PM=0A=
-	int  (*resume) (struct pci_dev *dev);=0A=
-	int  (*suspend) (struct pci_dev *dev, pm_message_t state);=0A=
-#endif=0A=
 };=0A=
 =0A=
 /*=0A=
@@ -483,6 +473,7 @@=0A=
 	u8		 forceDv;		/* 1 to force DV scheduling */=0A=
 	u8		 noQas;			/* Disable QAS for this adapter */=0A=
 	u8		 Saf_Te;		/* 1 to force all Processors as SAF-TE if Inquiry data =
length is too short to check for SAF-TE */=0A=
+	u8		 mpt_dv;		/* command line option: enhanced=3D1, basic=3D0 */=0A=
 	u8		 rsvd[1];=0A=
 } ScsiCfgData;=0A=
 =0A=
@@ -576,6 +567,9 @@=0A=
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
@@ -773,12 +767,6 @@=0A=
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
@@ -898,6 +886,11 @@=0A=
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
@@ -931,6 +924,12 @@=0A=
 /*=0A=
  *  Public entry points...=0A=
  */=0A=
+extern int	 mpt_attach(struct pci_dev *pdev, const struct =
pci_device_id *id);=0A=
+extern void	 mpt_detach(struct pci_dev *pdev);=0A=
+#ifdef CONFIG_PM=0A=
+extern int	 mpt_suspend(struct pci_dev *pdev, pm_message_t state);=0A=
+extern int	 mpt_resume(struct pci_dev *pdev);=0A=
+#endif=0A=
 extern int	 mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS =
dclass);=0A=
 extern void	 mpt_deregister(int cb_idx);=0A=
 extern int	 mpt_event_register(int cb_idx, MPT_EVHANDLER =
ev_cbfunc);=0A=

------_=_NextPart_000_01C545D0.857BE2D0--
