From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: [PATCH 2.4 ] 2.4.25-rc2 - MPT Fusion driver 2.05.11.03 update
Date: Fri, 13 Feb 2004 16:40:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703EF9163@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C3F279.F7074800"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:33971 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S267235AbUBMVkY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 16:40:24 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: marcelo.tosatti@cyclades.com

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C3F279.F7074800
Content-Type: text/plain;
	charset="iso-8859-1"

Heres a new patch for MPT Fusion driver version 2.05.11.03

It address issues mptctl IOCTL interface in ia64 and x86_64.

You can download full source and 2.05.11.03 patches here:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.05.11.03/

Eric Moore
Staff Engineer
Standard Storage Products Division
LSI Logic Corporation
4420 Arrowswest Drive
Colorado Springs, CO 80907
Tel: (719) 533-7056
Email: emoore@lsil.com
Web: http://www.lsilogic.com/


------_=_NextPart_000_01C3F279.F7074800
Content-Type: application/octet-stream;
	name="mptlinux-2.05.11.03.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptlinux-2.05.11.03.patch"

diff -uarN linux-2.4.25-rc2-ref/drivers/message/fusion/linux_compat.h =
linux-2.4.25-rc2/drivers/message/fusion/linux_compat.h=0A=
--- linux-2.4.25-rc2-ref/drivers/message/fusion/linux_compat.h	=
2004-02-10 16:54:38.000000000 -0700=0A=
+++ linux-2.4.25-rc2/drivers/message/fusion/linux_compat.h	2004-02-12 =
11:07:27.000000000 -0700=0A=
@@ -12,7 +12,7 @@=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 =0A=
 =0A=
-#if (defined(__sparc__) && defined(__sparc_v9__)) || =
defined(__x86_64__) || defined(__ia64__)=0A=
+#if (defined(__sparc__) && defined(__sparc_v9__)) || =
defined(__x86_64__)=0A=
 #define MPT_CONFIG_COMPAT=0A=
 #endif=0A=
 =0A=
diff -uarN linux-2.4.25-rc2-ref/drivers/message/fusion/mptbase.h =
linux-2.4.25-rc2/drivers/message/fusion/mptbase.h=0A=
--- linux-2.4.25-rc2-ref/drivers/message/fusion/mptbase.h	2004-02-10 =
16:54:38.000000000 -0700=0A=
+++ linux-2.4.25-rc2/drivers/message/fusion/mptbase.h	2004-02-12 =
11:07:27.000000000 -0700=0A=
@@ -80,8 +80,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2003 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"2.05.11.01"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-2.05.11.01"=0A=
+#define MPT_LINUX_VERSION_COMMON	"2.05.11.03"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-2.05.11.03"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=
diff -uarN linux-2.4.25-rc2-ref/drivers/message/fusion/mptctl.c =
linux-2.4.25-rc2/drivers/message/fusion/mptctl.c=0A=
--- linux-2.4.25-rc2-ref/drivers/message/fusion/mptctl.c	2004-02-10 =
16:54:38.000000000 -0700=0A=
+++ linux-2.4.25-rc2/drivers/message/fusion/mptctl.c	2004-02-12 =
09:30:19.000000000 -0700=0A=
@@ -82,6 +82,7 @@=0A=
 #include <linux/types.h>=0A=
 #include <linux/pci.h>=0A=
 #include <linux/miscdevice.h>=0A=
+#include <linux/smp_lock.h>=0A=
 =0A=
 #include <asm/io.h>=0A=
 #include <asm/uaccess.h>=0A=
@@ -2715,7 +2716,6 @@=0A=
 						      unsigned long,=0A=
 						      struct file *));=0A=
 int unregister_ioctl32_conversion(unsigned int cmd);=0A=
-extern asmlinkage int sys_ioctl(unsigned int fd, unsigned int cmd, =
unsigned long arg);=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /* compat_XXX functions are used to provide a conversion between=0A=
@@ -2725,6 +2725,19 @@=0A=
  * to ensure the structure contents is properly processed by =
mptctl.=0A=
  */=0A=
 static int=0A=
+compat_mptctl_ioctl(unsigned int fd, unsigned int cmd,=0A=
+			unsigned long arg, struct file *filp)=0A=
+{=0A=
+	int ret;=0A=
+=0A=
+	lock_kernel();=0A=
+	dctlprintk((KERN_INFO MYNAM "::compat_mptctl_ioctl() called\n"));=0A=
+	ret =3D mptctl_ioctl(filp->f_dentry->d_inode, filp, cmd, arg);=0A=
+	unlock_kernel();=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+static int=0A=
 compat_mptfwxfer_ioctl(unsigned int fd, unsigned int cmd,=0A=
 			unsigned long arg, struct file *filp)=0A=
 {=0A=
@@ -2864,30 +2877,31 @@=0A=
 	}=0A=
 =0A=
 #ifdef MPT_CONFIG_COMPAT=0A=
-	err =3D register_ioctl32_conversion(MPTIOCINFO, sys_ioctl);=0A=
+	err =3D register_ioctl32_conversion(MPTIOCINFO, =
compat_mptctl_ioctl);=0A=
 	if (++where && err) goto out_fail;=0A=
-	err =3D register_ioctl32_conversion(MPTIOCINFO1, sys_ioctl);=0A=
+	err =3D register_ioctl32_conversion(MPTIOCINFO1, =
compat_mptctl_ioctl);=0A=
 	if (++where && err) goto out_fail;=0A=
-	err =3D register_ioctl32_conversion(MPTTARGETINFO, sys_ioctl);=0A=
+	err =3D register_ioctl32_conversion(MPTTARGETINFO, =
compat_mptctl_ioctl);=0A=
 	if (++where && err) goto out_fail;=0A=
-	err =3D register_ioctl32_conversion(MPTTEST, sys_ioctl);=0A=
+	err =3D register_ioctl32_conversion(MPTTEST, compat_mptctl_ioctl);=0A=
 	if (++where && err) goto out_fail;=0A=
-	err =3D register_ioctl32_conversion(MPTEVENTQUERY, sys_ioctl);=0A=
+	err =3D register_ioctl32_conversion(MPTEVENTQUERY, =
compat_mptctl_ioctl);=0A=
 	if (++where && err) goto out_fail;=0A=
-	err =3D register_ioctl32_conversion(MPTEVENTENABLE, sys_ioctl);=0A=
+	err =3D register_ioctl32_conversion(MPTEVENTENABLE, =
compat_mptctl_ioctl);=0A=
 	if (++where && err) goto out_fail;=0A=
-	err =3D register_ioctl32_conversion(MPTEVENTREPORT, sys_ioctl);=0A=
+	err =3D register_ioctl32_conversion(MPTEVENTREPORT, =
compat_mptctl_ioctl);=0A=
 	if (++where && err) goto out_fail;=0A=
-	err =3D register_ioctl32_conversion(MPTHARDRESET, sys_ioctl);=0A=
+	err =3D register_ioctl32_conversion(MPTHARDRESET, =
compat_mptctl_ioctl);=0A=
 	if (++where && err) goto out_fail;=0A=
 	err =3D register_ioctl32_conversion(MPTCOMMAND32, =
compat_mpt_command);=0A=
 	if (++where && err) goto out_fail;=0A=
 	err =3D register_ioctl32_conversion(MPTFWDOWNLOAD32,=0A=
 					  compat_mptfwxfer_ioctl);=0A=
 	if (++where && err) goto out_fail;=0A=
-	err =3D register_ioctl32_conversion(HP_GETHOSTINFO, sys_ioctl);=0A=
+	err =3D register_ioctl32_conversion(HP_GETHOSTINFO, =
compat_mptctl_ioctl);=0A=
 	if (++where && err) goto out_fail;=0A=
-	err =3D register_ioctl32_conversion(HP_GETTARGETINFO, sys_ioctl);=0A=
+	err =3D register_ioctl32_conversion(HP_GETTARGETINFO,=0A=
+	    				compat_mptctl_ioctl);=0A=
 	if (++where && err) goto out_fail;=0A=
 #endif=0A=
 =0A=
diff -uarN linux-2.4.25-rc2-ref/drivers/message/fusion/mptscsih.c =
linux-2.4.25-rc2/drivers/message/fusion/mptscsih.c=0A=
--- linux-2.4.25-rc2-ref/drivers/message/fusion/mptscsih.c	2004-02-10 =
16:54:38.000000000 -0700=0A=
+++ linux-2.4.25-rc2/drivers/message/fusion/mptscsih.c	2004-02-10 =
11:33:39.000000000 -0700=0A=
@@ -914,8 +914,8 @@=0A=
 			sc->resid =3D sc->request_bufflen - xfer_cnt;=0A=
 			dprintk((KERN_NOTICE "  SET sc->resid=3D%02xh\n", sc->resid));=0A=
 #endif=0A=
-			if (sc->underflow > xfer_cnt) {=0A=
-				sc->result =3D DID_SOFT_ERROR;=0A=
+			if((xfer_cnt =3D=3D 0 ) || (sc->underflow > xfer_cnt)) {=0A=
+				sc->result =3D DID_SOFT_ERROR << 16;=0A=
 			}=0A=
 =0A=
 			/* Report Queue Full=0A=

------_=_NextPart_000_01C3F279.F7074800--
