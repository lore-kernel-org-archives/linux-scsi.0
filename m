From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: [PATCH 2.6 ] MPT Fusion driver 3.01.06 update
Date: Thu, 6 May 2004 15:36:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57045F11CE@exa-atlanta>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C433A1.7BC229D0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:57340 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262914AbUEFThP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2004 15:37:15 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C433A1.7BC229D0
Content-Type: text/plain;
	charset="iso-8859-1"

This is an update for the MPT Fusion drivers 2.6 kernel.

This is mpt version is 3.01.06  The attached patch is made
against 3.01.05 driver.

Changelog: MPI_IOCSTATUS_SCSI_PROTOCOL_ERROR; return DID_SOFT_ERROR.


You can download full source as well as the patches for this 
driver at:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-patches/3.01.06
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


------_=_NextPart_000_01C433A1.7BC229D0
Content-Type: application/octet-stream;
	name="mptlinux-3.01.06.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptlinux-3.01.06.patch"

diff -uarN b/drivers/message/fusion/mptbase.h =
a/drivers/message/fusion/mptbase.h=0A=
--- b/drivers/message/fusion/mptbase.h	2004-04-22 08:46:29.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.h	2004-05-04 16:34:55.000000000 =
-0600=0A=
@@ -81,8 +81,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2004 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.01.05"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.05"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.01.06"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.06"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=
diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2004-04-13 15:35:31.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptscsih.c	2004-05-04 16:38:32.000000000 =
-0600=0A=
@@ -940,10 +940,6 @@=0A=
 			break;=0A=
 =0A=
 		case MPI_IOCSTATUS_SCSI_PROTOCOL_ERROR:		/* 0x0047 */=0A=
-			if (pScsiReply->SCSIState & MPI_SCSI_STATE_TERMINATED) {=0A=
-				/*  Not real sure here either...  */=0A=
-				sc->result =3D DID_RESET << 16;=0A=
-			} else=0A=
 				sc->result =3D DID_SOFT_ERROR << 16;=0A=
 			break;=0A=
 =0A=

------_=_NextPart_000_01C433A1.7BC229D0--
