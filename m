From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [patch 8/8] mptfusion: kill fusion init called
Date: Thu, 18 Nov 2004 16:33:26 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C54677F@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C4CDC7.00C59030"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:13247 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261453AbUKSQLR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 11:11:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C4CDC7.00C59030
Content-Type: text/plain;
	charset="iso-8859-1"

The scsi early init problem is long gone, 
so no need to work around it anymore.
This patch previously submitted by hch@.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>





------_=_NextPart_000_01C4CDC7.00C59030
Content-Type: application/octet-stream;
	name="mptfusion-8.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptfusion-8.patch"

diff -uarN b/drivers/message/fusion/mptbase.c =
a/drivers/message/fusion/mptbase.c=0A=
--- b/drivers/message/fusion/mptbase.c	2004-11-18 11:23:04.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptbase.c	2004-11-18 13:03:20.000000000 =
-0700=0A=
@@ -155,7 +155,6 @@=0A=
 static MPT_RESETHANDLER		 =
MptResetHandlers[MPT_MAX_PROTOCOL_DRIVERS];=0A=
 static struct mpt_pci_driver 	=
*MptDeviceDriverHandlers[MPT_MAX_PROTOCOL_DRIVERS];=0A=
 =0A=
-static int	FusionInitCalled =3D 0;=0A=
 static int	mpt_base_index =3D -1;=0A=
 static int	last_drv_idx =3D -1;=0A=
 =0A=
@@ -601,22 +600,6 @@=0A=
 =0A=
 	last_drv_idx =3D -1;=0A=
 =0A=
-#ifndef MODULE=0A=
-	/*=0A=
-	 *  Handle possibility of the mptscsih_detect() routine getting=0A=
-	 *  called *before* fusion_init!=0A=
-	 */=0A=
-	if (!FusionInitCalled) {=0A=
-		dprintk((KERN_INFO MYNAM ": Hmmm, calling fusion_init from =
mpt_register!\n"));=0A=
-		/*=0A=
-		 *  NOTE! We'll get recursion here, as fusion_init()=0A=
-		 *  calls mpt_register()!=0A=
-		 */=0A=
-		fusion_init();=0A=
-		FusionInitCalled++;=0A=
-	}=0A=
-#endif=0A=
-=0A=
 	/*=0A=
 	 *  Search for empty callback slot in this order: =
{N,...,7,6,5,...,1}=0A=
 	 *  (slot/handle 0 is reserved!)=0A=
@@ -5904,11 +5887,6 @@=0A=
 	int i;=0A=
 	int r;=0A=
 =0A=
-	if (FusionInitCalled++) {=0A=
-		dprintk((KERN_INFO MYNAM ": INFO - Driver late-init entry point =
called\n"));=0A=
-		return 0;=0A=
-	}=0A=
-=0A=
 	show_mptmod_ver(my_NAME, my_VERSION);=0A=
 	printk(KERN_INFO COPYRIGHT "\n");=0A=
 =0A=
diff -uarN b/drivers/message/fusion/mptbase.h =
a/drivers/message/fusion/mptbase.h=0A=
--- b/drivers/message/fusion/mptbase.h	2004-11-18 13:12:10.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptbase.h	2004-11-18 13:12:22.000000000 =
-0700=0A=
@@ -83,8 +83,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2004 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.01.17"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.17"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.01.18"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.18"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=

------_=_NextPart_000_01C4CDC7.00C59030--
