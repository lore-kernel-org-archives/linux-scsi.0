From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH] - mptfusion - fix panic loading driver statically compile
	d
Date: Thu, 28 Apr 2005 16:15:23 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C0225D199@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C54C3F.C5E92A10"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:17036 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262288AbVD1WPe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2005 18:15:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, akpm@osdl.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C54C3F.C5E92A10
Content-Type: text/plain;
	charset="iso-8859-1"

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-kernel/3.03.01/

Changelog:
(1) For statically linked drivers, fusion_init was not called,
added call from mpt_register so its called when one of the scsi lld load.
(2) little endian fix in mpt_put_msg_frame/mpt_get_msg_frame
(3) Clarify help desc in Kconfig for FUSION_MAX_SGE.


Signed-off-by: Eric Moore <Eric.Moore@lsil.com>







------_=_NextPart_000_01C54C3F.C5E92A10
Content-Type: application/octet-stream;
	name="mptlinux-3.03.01.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptlinux-3.03.01.patch"

diff -uarN b/drivers/message/fusion/Kconfig =
a/drivers/message/fusion/Kconfig=0A=
--- b/drivers/message/fusion/Kconfig	2005-04-25 15:45:54.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/Kconfig	2005-04-28 14:48:40.000000000 =
-0600=0A=
@@ -36,17 +36,16 @@=0A=
 	  LSIFC929XL=0A=
 =0A=
 config FUSION_MAX_SGE=0A=
-	int "Maximum number of scatter gather entries"=0A=
+	int "Maximum number of scatter gather entries (16 - 128)"=0A=
 	depends on FUSION_SPI || FUSION_FC=0A=
 	default "128"=0A=
+	range 16 128=0A=
 	help=0A=
 	  This option allows you to specify the maximum number of scatter-=0A=
-	  gather entries per I/O. The driver defaults to 40, a reasonable =
number=0A=
-	  for most systems. However, the user may increase this up to 128.=0A=
-	  Increasing this parameter will require significantly more memory=0A=
-	  on a per controller instance. Increasing the parameter is not=0A=
-	  necessary (or recommended) unless the user will be running=0A=
-	  large I/O's via the raw interface.=0A=
+	  gather entries per I/O. The driver default is 128, which matches=0A=
+	  SCSI_MAX_PHYS_SEGMENTS. However, it may decreased down to 16.=0A=
+	  Decreasing this parameter will reduce memory requirements=0A=
+	  on a per controller instance.=0A=
 =0A=
 config FUSION_CTL=0A=
 	tristate "Fusion MPT misc device (ioctl) driver"=0A=
diff -uarN b/drivers/message/fusion/mptbase.c =
a/drivers/message/fusion/mptbase.c=0A=
--- b/drivers/message/fusion/mptbase.c	2005-04-25 15:45:54.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.c	2005-04-28 14:46:43.000000000 =
-0600=0A=
@@ -113,6 +113,7 @@=0A=
 					/* Reset handler lookup table */=0A=
 static MPT_RESETHANDLER		 =
MptResetHandlers[MPT_MAX_PROTOCOL_DRIVERS];=0A=
 static struct mpt_pci_driver 	=
*MptDeviceDriverHandlers[MPT_MAX_PROTOCOL_DRIVERS];=0A=
+static int	FusionInitCalled =3D 0;=0A=
 =0A=
 static int	mpt_base_index =3D -1;=0A=
 static int	last_drv_idx =3D -1;=0A=
@@ -360,15 +361,8 @@=0A=
 		}=0A=
 =0A=
 		if (freeme) {=0A=
-			unsigned long flags;=0A=
-=0A=
 			/*  Put Request back on FreeQ!  */=0A=
-			spin_lock_irqsave(&ioc->FreeQlock, flags);=0A=
-			list_add_tail(&mf->u.frame.linkage.list, &ioc->FreeQ);=0A=
-#ifdef MFCNT=0A=
-			ioc->mfcnt--;=0A=
-#endif=0A=
-			spin_unlock_irqrestore(&ioc->FreeQlock, flags);=0A=
+			mpt_free_msg_frame(ioc, mf);=0A=
 		}=0A=
 =0A=
 		mb();=0A=
@@ -530,6 +524,21 @@=0A=
 =0A=
 	last_drv_idx =3D -1;=0A=
 =0A=
+#ifndef MODULE=0A=
+	/*=0A=
+	 *  Handle possibility of the mptscsih_detect() routine getting=0A=
+	 *  called *before* fusion_init!=0A=
+	 */=0A=
+	if (!FusionInitCalled) {=0A=
+		dinitprintk((KERN_INFO MYNAM ": Hmmm, calling fusion_init from =
mpt_register!\n"));=0A=
+		/*=0A=
+		 *  NOTE! We'll get recursion here, as fusion_init()=0A=
+		 *  calls mpt_register()!=0A=
+		 */=0A=
+		fusion_init();=0A=
+		FusionInitCalled++;=0A=
+	}=0A=
+#endif=0A=
 	/*=0A=
 	 *  Search for empty callback slot in this order: =
{N,...,7,6,5,...,1}=0A=
 	 *  (slot/handle 0 is reserved!)=0A=
@@ -735,8 +744,8 @@=0A=
 		mf->u.frame.hwhdr.msgctxu.fld.cb_idx =3D handle;	/* byte */=0A=
 		req_offset =3D (u8 *)mf - (u8 *)ioc->req_frames;=0A=
 								/* u16! */=0A=
-		req_idx =3D cpu_to_le16(req_offset / ioc->req_sz);=0A=
-		mf->u.frame.hwhdr.msgctxu.fld.req_idx =3D req_idx;=0A=
+		req_idx =3D req_offset / ioc->req_sz;=0A=
+		mf->u.frame.hwhdr.msgctxu.fld.req_idx =3D cpu_to_le16(req_idx);=0A=
 		mf->u.frame.hwhdr.msgctxu.fld.rsvd =3D 0;=0A=
 		ioc->RequestNB[req_idx] =3D ioc->NB_for_64_byte_frame; /* Default, =
will be changed if necessary in SG generation */=0A=
 #ifdef MFCNT=0A=
@@ -782,8 +791,8 @@=0A=
 	mf->u.frame.hwhdr.msgctxu.fld.cb_idx =3D handle;		/* byte */=0A=
 	req_offset =3D (u8 *)mf - (u8 *)ioc->req_frames;=0A=
 								/* u16! */=0A=
-	req_idx =3D cpu_to_le16(req_offset / ioc->req_sz);=0A=
-	mf->u.frame.hwhdr.msgctxu.fld.req_idx =3D req_idx;=0A=
+	req_idx =3D req_offset / ioc->req_sz;=0A=
+	mf->u.frame.hwhdr.msgctxu.fld.req_idx =3D cpu_to_le16(req_idx);=0A=
 	mf->u.frame.hwhdr.msgctxu.fld.rsvd =3D 0;=0A=
 =0A=
 #ifdef MPT_DEBUG_MSG_FRAME=0A=
@@ -5769,6 +5778,11 @@=0A=
 {=0A=
 	int i;=0A=
 =0A=
+	if (FusionInitCalled++) {=0A=
+		dprintk((KERN_INFO MYNAM ": INFO - Driver late-init entry point =
called\n"));=0A=
+		return 0;=0A=
+	}=0A=
+	=0A=
 	show_mptmod_ver(my_NAME, my_VERSION);=0A=
 	printk(KERN_INFO COPYRIGHT "\n");=0A=
 =0A=
diff -uarN b/drivers/message/fusion/mptbase.h =
a/drivers/message/fusion/mptbase.h=0A=
--- b/drivers/message/fusion/mptbase.h	2005-04-25 15:45:54.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.h	2005-04-28 14:47:25.000000000 =
-0600=0A=
@@ -76,8 +76,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.03.00"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.00"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.03.01"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.01"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=

------_=_NextPart_000_01C54C3F.C5E92A10--
