From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: [PATCH 2.6 ] 2.6.3- MPT Fusion driver 3.00.04 update
Date: Wed, 25 Feb 2004 11:16:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703EF97E5@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C3FBBA.C8127ED0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36763 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261402AbUBYQRF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 11:17:05 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C3FBBA.C8127ED0
Content-Type: text/plain;
	charset="iso-8859-1"

Heres a new patch for MPT Fusion driver version 3.00.04

More hot plug fix's.

You can download full source and 3.00.04 patches here:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-patches/3.00.04
/

Eric Moore
Staff Engineer
Standard Storage Products Division
LSI Logic Corporation
4420 Arrowswest Drive
Colorado Springs, CO 80907
Email: emoore@lsil.com
Web: http://www.lsilogic.com/



------_=_NextPart_000_01C3FBBA.C8127ED0
Content-Type: application/octet-stream;
	name="mptlinux-3.00.04.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptlinux-3.00.04.patch"

diff -uarN linux-2.6.3-ref/drivers/message/fusion/Kconfig =
linux-2.6.3/drivers/message/fusion/Kconfig=0A=
--- linux-2.6.3-ref/drivers/message/fusion/Kconfig	2004-02-17 =
20:59:59.000000000 -0700=0A=
+++ linux-2.6.3/drivers/message/fusion/Kconfig	2004-02-24 =
17:19:50.000000000 -0700=0A=
@@ -3,7 +3,6 @@=0A=
 =0A=
 config FUSION=0A=
 	tristate "Fusion MPT (base + ScsiHost) drivers"=0A=
-	depends on BLK_DEV_SD=0A=
 	---help---=0A=
 	  LSI Logic Fusion(TM) Message Passing Technology (MPT) device =
support=0A=
 	  provides high performance SCSI host initiator, and LAN [1] =
interface=0A=
@@ -14,41 +13,6 @@=0A=
 =0A=
 	  [1] LAN is not supported on parallel SCSI medium.=0A=
 =0A=
-	  These drivers require a Fusion MPT compatible PCI adapter =
installed=0A=
-	  in the host system.  MPT adapters contain specialized I/O =
processors=0A=
-	  to handle I/O workload, and more importantly to offload this =
work=0A=
-	  from the host CPU(s).=0A=
-=0A=
-	  If you have Fusion MPT hardware and want to use it, you can say=0A=
-	  Y or M here to add MPT (base + ScsiHost) drivers.=0A=
-	  <Y> =3D build lib (fusion), and link [static] into the kernel =
[2]=0A=
-	  proper=0A=
-	  <M> =3D compiled as [dynamic] modules [3] named: (mptbase,=0A=
-	  mptscsih)=0A=
-=0A=
-	  [2] In order enable capability to boot the linux kernel=0A=
-	  natively from a Fusion MPT target device, you MUST=0A=
-	  answer Y here! (currently requires CONFIG_BLK_DEV_SD)=0A=
-	  [3] To compile this support as modules, choose M here.=0A=
-=0A=
-	  If unsure, say N.=0A=
-=0A=
-	  If you say Y or M here you will get a choice of these=0A=
-	  additional protocol and support module options:         Module =
Name:=0A=
-	  <M>   Enhanced SCSI error reporting                     (isense)=0A=
-	  <M>   Fusion MPT misc device (ioctl) driver             (mptctl)=0A=
-	  <M>   Fusion MPT LAN driver                             (mptlan)=0A=
-=0A=
-	  ---=0A=
-	  Fusion MPT is trademark of LSI Logic Corporation, and its=0A=
-	  architecture is based on LSI Logic's Message Passing Interface =
(MPI)=0A=
-	  specification.=0A=
-=0A=
-config FUSION_BOOT=0A=
-	bool=0A=
-	depends on FUSION=3Dy=0A=
-	default y=0A=
-=0A=
 config FUSION_MAX_SGE=0A=
 	int "Maximum number of scatter gather entries"=0A=
 	depends on FUSION=0A=
@@ -62,7 +26,6 @@=0A=
 	  necessary (or recommended) unless the user will be running =0A=
 	  large I/O's via the raw interface.=0A=
 =0A=
-#  How can we force these options to module or nothing?=0A=
 config FUSION_ISENSE=0A=
 	tristate "Enhanced SCSI error reporting"=0A=
 	depends on MODULES && FUSION && m=0A=
@@ -132,17 +95,4 @@=0A=
 =0A=
 	  If unsure whether you really want or need this, say N.=0A=
 =0A=
-	  NOTES: This feature is NOT available nor supported for =
linux-2.2.x=0A=
-	  kernels.  You must be building a linux-2.3.x or linux-2.4.x =
kernel=0A=
-	  in order to configure this option.=0A=
-	  Support for building this feature into the linux kernel is not=0A=
-	  yet available.=0A=
-=0A=
-#  if [ "$CONFIG_FUSION_LAN" !=3D "n" ]; then=0A=
-#    define_bool CONFIG_NET_FC y=0A=
-#  fi=0A=
-# These <should> be define_tristate, but we leave them define_bool=0A=
-# for backward compatibility with pre-linux-2.2.15 kernels.=0A=
-# (Bugzilla:fibrebugs, #384)=0A=
 endmenu=0A=
-=0A=
diff -uarN linux-2.6.3-ref/drivers/message/fusion/mptbase.c =
linux-2.6.3/drivers/message/fusion/mptbase.c=0A=
--- linux-2.6.3-ref/drivers/message/fusion/mptbase.c	2004-02-17 =
20:57:20.000000000 -0700=0A=
+++ linux-2.6.3/drivers/message/fusion/mptbase.c	2004-02-24 =
17:17:53.000000000 -0700=0A=
@@ -714,6 +714,7 @@=0A=
 			MptCallbacks[i] =3D cbfunc;=0A=
 			MptDriverClass[i] =3D dclass;=0A=
 			MptEvHandlers[i] =3D NULL;=0A=
+			MptDeviceDriverHandlers[i] =3D NULL;=0A=
 			last_drv_idx =3D i;=0A=
 			if (cbfunc !=3D mpt_base_reply) {=0A=
 				mpt_inc_use_count();=0A=
@@ -838,11 +839,28 @@=0A=
 int=0A=
 mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, int =
cb_idx)=0A=
 {=0A=
-	if (cb_idx < 1 || cb_idx >=3D MPT_MAX_PROTOCOL_DRIVERS)=0A=
-		return -1;=0A=
+	MPT_ADAPTER	*ioc;=0A=
+	int 		error=3D0;=0A=
+=0A=
+	if (cb_idx < 1 || cb_idx >=3D MPT_MAX_PROTOCOL_DRIVERS) {=0A=
+		error=3D -EINVAL;=0A=
+		return error;=0A=
+	}=0A=
 =0A=
 	MptDeviceDriverHandlers[cb_idx] =3D dd_cbfunc;=0A=
-	return 0;=0A=
+=0A=
+	/* call per pci device probe entry point */=0A=
+	for(ioc =3D mpt_adapter_find_first(); ioc !=3D NULL;=0A=
+	  ioc =3D mpt_adapter_find_next(ioc)) {=0A=
+		if(dd_cbfunc->probe) {=0A=
+			error =3D dd_cbfunc->probe(ioc->pcidev,=0A=
+			  ioc->pcidev->driver->id_table);=0A=
+			if(error !=3D 0)=0A=
+				return error;=0A=
+  		}=0A=
+	 }=0A=
+=0A=
+	return error;=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -1497,14 +1515,20 @@=0A=
 			|| (ioc->chip_type =3D=3D C1035) || (ioc->chip_type =3D=3D =
FC929X))=0A=
 		mpt_detect_bound_ports(ioc, pdev);=0A=
 =0A=
-	if ((r =3D mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP, =
CAN_SLEEP)) !=3D 0) {=0A=
-		printk(KERN_WARNING MYNAM ": WARNING - %s did not initialize =
properly! (%d)\n",=0A=
-				ioc->name, r);=0A=
-	}=0A=
-=0A=
-	if(r !=3D 0 )=0A=
+	if ((r =3D mpt_do_ioc_recovery(ioc,=0A=
+	  MPT_HOSTEVENT_IOC_BRINGUP, CAN_SLEEP)) !=3D 0) {=0A=
+		printk(KERN_WARNING MYNAM=0A=
+		  ": WARNING - %s did not initialize properly! (%d)\n",=0A=
+		  ioc->name, r);=0A=
+=0A=
+		Q_DEL_ITEM(ioc);=0A=
+		mpt_adapters[ioc->id] =3D NULL;=0A=
+		free_irq(ioc->pci_irq, ioc);=0A=
+		iounmap(mem);=0A=
+		kfree(ioc);=0A=
+		pci_set_drvdata(pdev, NULL);=0A=
 		return r;=0A=
-=0A=
+	}=0A=
 =0A=
 	/* call per device driver probe entry point */=0A=
 	for(ii=3D0; ii<MPT_MAX_PROTOCOL_DRIVERS; ii++) {=0A=
diff -uarN linux-2.6.3-ref/drivers/message/fusion/mptbase.h =
linux-2.6.3/drivers/message/fusion/mptbase.h=0A=
--- linux-2.6.3-ref/drivers/message/fusion/mptbase.h	2004-02-17 =
20:57:17.000000000 -0700=0A=
+++ linux-2.6.3/drivers/message/fusion/mptbase.h	2004-02-24 =
16:42:19.000000000 -0700=0A=
@@ -80,8 +80,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2003 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.00.02"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.00.02"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.00.04"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.00.04"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=
diff -uarN linux-2.6.3-ref/drivers/message/fusion/mptlan.c =
linux-2.6.3/drivers/message/fusion/mptlan.c=0A=
--- linux-2.6.3-ref/drivers/message/fusion/mptlan.c	2004-02-17 =
20:57:57.000000000 -0700=0A=
+++ linux-2.6.3/drivers/message/fusion/mptlan.c	2004-02-24 =
16:46:29.000000000 -0700=0A=
@@ -1437,7 +1437,7 @@=0A=
 	SET_MODULE_OWNER(dev);=0A=
 =0A=
 	if (register_netdev(dev) !=3D 0) {=0A=
-		kfree(dev);=0A=
+		free_netdev(dev);=0A=
 		dev =3D NULL;=0A=
 	}=0A=
 	return dev;=0A=
diff -uarN linux-2.6.3-ref/drivers/message/fusion/mptscsih.c =
linux-2.6.3/drivers/message/fusion/mptscsih.c=0A=
--- linux-2.6.3-ref/drivers/message/fusion/mptscsih.c	2004-02-17 =
20:57:30.000000000 -0700=0A=
+++ linux-2.6.3/drivers/message/fusion/mptscsih.c	2004-02-24 =
16:40:51.000000000 -0700=0A=
@@ -197,11 +197,11 @@=0A=
 static int	mptscsih_setup(char *str);=0A=
 =0A=
 /* module entry point */=0A=
-static int  __init    mptscsih_init  (void);=0A=
-static void    mptscsih_exit  (void);=0A=
+static int  __init   mptscsih_init  (void);=0A=
+static void __exit   mptscsih_exit  (void);=0A=
 =0A=
-static int  __devinit mptscsih_probe (struct pci_dev *, const struct =
pci_device_id *);=0A=
-static void __devexit mptscsih_remove(struct pci_dev *);=0A=
+static int  mptscsih_probe (struct pci_dev *, const struct =
pci_device_id *);=0A=
+static void mptscsih_remove(struct pci_dev *);=0A=
 static void mptscsih_shutdown(struct device *);=0A=
 #ifdef CONFIG_PM=0A=
 static int mptscsih_suspend(struct pci_dev *pdev, u32 state);=0A=
@@ -1405,7 +1405,7 @@=0A=
  *=0A=
  */=0A=
 =0A=
-static int  __devinit=0A=
+static int=0A=
 mptscsih_probe(struct pci_dev *pdev, const struct pci_device_id =
*id)=0A=
 {=0A=
 	struct Scsi_Host	*sh =3D NULL;=0A=
@@ -1418,6 +1418,7 @@=0A=
 	int			 numSGE =3D 0;=0A=
 	int			 scale;=0A=
 	u8			*mem;=0A=
+	int			error=3D0;=0A=
 =0A=
 	for (portnum=3D0; portnum < ioc->facts.NumberOfPorts; portnum++) {=0A=
 =0A=
@@ -1542,8 +1543,10 @@=0A=
 			 */=0A=
 			sz =3D hd->ioc->req_depth * sizeof(void *);=0A=
 			mem =3D kmalloc(sz, GFP_ATOMIC);=0A=
-			if (mem =3D=3D NULL)=0A=
+			if (mem =3D=3D NULL) {=0A=
+				error =3D -ENOMEM;=0A=
 				goto mptscsih_probe_failed;=0A=
+			}=0A=
 =0A=
 			memset(mem, 0, sz);=0A=
 			hd->ScsiLookup =3D (struct scsi_cmnd **) mem;=0A=
@@ -1551,15 +1554,19 @@=0A=
 			dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p, sz=3D%d\n",=0A=
 				 ioc->name, hd->ScsiLookup, sz));=0A=
 =0A=
-			if (mptscsih_initChainBuffers(hd, 1) < 0)=0A=
+			if (mptscsih_initChainBuffers(hd, 1) < 0) {=0A=
+				error =3D -EINVAL;=0A=
 				goto mptscsih_probe_failed;=0A=
+			}=0A=
 =0A=
 			/* Allocate memory for free and doneQ's=0A=
 			 */=0A=
 			sz =3D sh->can_queue * sizeof(MPT_DONE_Q);=0A=
 			mem =3D kmalloc(sz, GFP_ATOMIC);=0A=
-			if (mem =3D=3D NULL)=0A=
+			if (mem =3D=3D NULL) {=0A=
+				error =3D -ENOMEM;=0A=
 				goto mptscsih_probe_failed;=0A=
+			}=0A=
 =0A=
 			memset(mem, 0xFF, sz);=0A=
 			hd->memQ =3D mem;=0A=
@@ -1591,8 +1598,10 @@=0A=
 			 */=0A=
 			sz =3D sh->max_id * sizeof(void *);=0A=
 			mem =3D kmalloc(sz, GFP_ATOMIC);=0A=
-			if (mem =3D=3D NULL)=0A=
+			if (mem =3D=3D NULL) {=0A=
+				error =3D -ENOMEM;=0A=
 				goto mptscsih_probe_failed;=0A=
+			}=0A=
 =0A=
 			memset(mem, 0, sz);=0A=
 			hd->Targets =3D (VirtDevice **) mem;=0A=
@@ -1683,7 +1692,8 @@=0A=
 =0A=
 			mpt_scsi_hosts++;=0A=
 =0A=
-			if(scsi_add_host (sh, &ioc->pcidev->dev)) {=0A=
+			error =3D scsi_add_host (sh, &ioc->pcidev->dev);=0A=
+			if(error) {=0A=
 				dprintk((KERN_ERR MYNAM,=0A=
 				  "scsi_add_host failed\n"));=0A=
 				goto mptscsih_probe_failed;=0A=
@@ -1691,7 +1701,6 @@=0A=
 =0A=
 			scsi_scan_host(sh);=0A=
 			return 0;=0A=
-=0A=
 		} /* scsi_host_alloc */=0A=
 =0A=
 	} /* for each adapter port */=0A=
@@ -1699,8 +1708,7 @@=0A=
 mptscsih_probe_failed:=0A=
 =0A=
 	mptscsih_remove(pdev);=0A=
-	return -ENODEV;=0A=
-=0A=
+	return error;=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -1710,7 +1718,7 @@=0A=
  *=0A=
  *=0A=
  */=0A=
-static void __devexit=0A=
+static void=0A=
 mptscsih_remove(struct pci_dev *pdev)=0A=
 {=0A=
 	MPT_ADAPTER 		*ioc =3D pci_get_drvdata(pdev);=0A=
@@ -1828,6 +1836,7 @@=0A=
 	}=0A=
 =0A=
 	scsi_host_put(host);=0A=
+	mpt_scsi_hosts--;=0A=
 =0A=
 }=0A=
 =0A=
@@ -1911,7 +1920,7 @@=0A=
 =0A=
 static struct mpt_pci_driver mptscsih_driver =3D {=0A=
 	.probe		=3D mptscsih_probe,=0A=
-	.remove		=3D __devexit_p(mptscsih_remove),=0A=
+	.remove		=3D mptscsih_remove,=0A=
 	.shutdown	=3D mptscsih_shutdown,=0A=
 #ifdef CONFIG_PM=0A=
 	.suspend	=3D mptscsih_suspend,=0A=
@@ -1928,10 +1937,9 @@=0A=
  *=0A=
  *	Returns 0 for success, non-zero for failure.=0A=
  */=0A=
-static int=0A=
-__init mptscsih_init(void)=0A=
+static int __init=0A=
+mptscsih_init(void)=0A=
 {=0A=
-	MPT_ADAPTER		*ioc;=0A=
 =0A=
 	show_mptmod_ver(my_NAME, my_VERSION);=0A=
 =0A=
@@ -1939,12 +1947,6 @@=0A=
 	ScsiTaskCtx =3D mpt_register(mptscsih_taskmgmt_complete, =
MPTSCSIH_DRIVER);=0A=
 	ScsiScanDvCtx =3D mpt_register(mptscsih_scandv_complete, =
MPTSCSIH_DRIVER);=0A=
 =0A=
-	if(mpt_device_driver_register(&mptscsih_driver,=0A=
-	  MPTSCSIH_DRIVER) !=3D 0 ) {=0A=
-		dprintk((KERN_INFO MYNAM=0A=
-		": failed to register dd callbacks\n"));=0A=
-	}=0A=
-=0A=
 	if (mpt_event_register(ScsiDoneCtx, mptscsih_event_process) =3D=3D 0) =
{=0A=
 		dprintk((KERN_INFO MYNAM=0A=
 		  ": Registered for IOC event notifications\n"));=0A=
@@ -1961,20 +1963,13 @@=0A=
 		mptscsih_setup(mptscsih);=0A=
 #endif=0A=
 =0A=
-	/* probing for devices */=0A=
-	for(ioc =3D mpt_adapter_find_first(); ioc !=3D NULL;=0A=
-	  ioc =3D mpt_adapter_find_next(ioc)) {=0A=
-		if(mptscsih_probe(ioc->pcidev, ioc->pcidev->driver->id_table)) {=0A=
-			dprintk((KERN_INFO MYNAM ": probe failed\n"));=0A=
-			return -ENODEV;=0A=
-		}=0A=
+	if(mpt_device_driver_register(&mptscsih_driver,=0A=
+	  MPTSCSIH_DRIVER) !=3D 0 ) {=0A=
+		dprintk((KERN_INFO MYNAM=0A=
+		": failed to register dd callbacks\n"));=0A=
 	}=0A=
 =0A=
-	if (mpt_scsi_hosts > 0)=0A=
-		return 0;=0A=
-=0A=
-	mptscsih_exit();=0A=
-	return -ENODEV;=0A=
+	return 0;=0A=
 =0A=
 }=0A=
 =0A=
@@ -1984,7 +1979,7 @@=0A=
  *	mptscsih_exit - Unregisters MPT adapter(s)=0A=
  *=0A=
  */=0A=
-static void=0A=
+static void __exit=0A=
 mptscsih_exit(void)=0A=
 {=0A=
 	MPT_ADAPTER	*ioc;=0A=

------_=_NextPart_000_01C3FBBA.C8127ED0--
