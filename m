From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: [PATCH 2.6 ] 2.6.3-rc2-bk1- MPT Fusion driver 3.00.03 update
Date: Fri, 13 Feb 2004 16:40:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703EF9164@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C3F279.FB67E300"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36275 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S267236AbUBMVkb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 16:40:31 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C3F279.FB67E300
Content-Type: text/plain;
	charset="iso-8859-1"

Heres a new patch for MPT Fusion driver version 3.00.03

It address issues with proper hot plug implementation.

You can download full source and 3.00.03 patches here:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-patches/3.00.03
/

Eric Moore
Staff Engineer
Standard Storage Products Division
LSI Logic Corporation
4420 Arrowswest Drive
Colorado Springs, CO 80907
Tel: (719) 533-7056
Email: emoore@lsil.com
Web: http://www.lsilogic.com/


------_=_NextPart_000_01C3F279.FB67E300
Content-Type: application/octet-stream;
	name="mptlinux-3.00.03.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptlinux-3.00.03.patch"

diff -uarN linux-2.6.3-rc2-bk1-ref/drivers/message/fusion/mptbase.c =
linux-2.6.3-rc2-bk1/drivers/message/fusion/mptbase.c=0A=
--- linux-2.6.3-rc2-bk1-ref/drivers/message/fusion/mptbase.c	2004-02-12 =
13:00:29.178745648 -0700=0A=
+++ linux-2.6.3-rc2-bk1/drivers/message/fusion/mptbase.c	2004-02-12 =
12:20:08.000000000 -0700=0A=
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
@@ -1502,9 +1520,14 @@=0A=
 				ioc->name, r);=0A=
 	}=0A=
 =0A=
-	if(r !=3D 0 )=0A=
+	if(r !=3D 0 ) {=0A=
+		Q_DEL_ITEM(ioc);=0A=
+		mpt_adapters[ioc->id] =3D NULL;=0A=
+		free_irq(ioc->pci_irq, ioc);=0A=
+		iounmap(mem);=0A=
+		kfree(ioc);=0A=
 		return r;=0A=
-=0A=
+	}=0A=
 =0A=
 	/* call per device driver probe entry point */=0A=
 	for(ii=3D0; ii<MPT_MAX_PROTOCOL_DRIVERS; ii++) {=0A=
diff -uarN linux-2.6.3-rc2-bk1-ref/drivers/message/fusion/mptbase.h =
linux-2.6.3-rc2-bk1/drivers/message/fusion/mptbase.h=0A=
--- linux-2.6.3-rc2-bk1-ref/drivers/message/fusion/mptbase.h	2004-02-12 =
13:00:29.179745496 -0700=0A=
+++ linux-2.6.3-rc2-bk1/drivers/message/fusion/mptbase.h	2004-02-12 =
13:04:21.194473896 -0700=0A=
@@ -80,8 +80,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2003 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.00.02"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.00.02"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.00.03"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.00.03"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=
diff -uarN linux-2.6.3-rc2-bk1-ref/drivers/message/fusion/mptscsih.c =
linux-2.6.3-rc2-bk1/drivers/message/fusion/mptscsih.c=0A=
--- linux-2.6.3-rc2-bk1-ref/drivers/message/fusion/mptscsih.c	=
2004-02-12 13:00:29.235736984 -0700=0A=
+++ linux-2.6.3-rc2-bk1/drivers/message/fusion/mptscsih.c	2004-02-12 =
12:20:08.000000000 -0700=0A=
@@ -197,8 +197,8 @@=0A=
 static int	mptscsih_setup(char *str);=0A=
 =0A=
 /* module entry point */=0A=
-static int  __init    mptscsih_init  (void);=0A=
-static void    mptscsih_exit  (void);=0A=
+static int  __init   mptscsih_init  (void);=0A=
+static void __exit   mptscsih_exit  (void);=0A=
 =0A=
 static int  __devinit mptscsih_probe (struct pci_dev *, const struct =
pci_device_id *);=0A=
 static void __devexit mptscsih_remove(struct pci_dev *);=0A=
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
@@ -1828,6 +1836,7 @@=0A=
 	}=0A=
 =0A=
 	scsi_host_put(host);=0A=
+	mpt_scsi_hosts--;=0A=
 =0A=
 }=0A=
 =0A=
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

------_=_NextPart_000_01C3F279.FB67E300--
