From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 3/7] mptfusion: mptctl Remove credits and update copyright
Date: Tue, 19 Apr 2005 15:11:45 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C020C3D4C@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C54524.645CCDF0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:5879 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261667AbVDSVLy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 17:11:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C54524.645CCDF0
Content-Type: text/plain;
	charset="iso-8859-1"

mptfusion patch 3/7:

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-kernel/3.03.00/

Changelog:

(1) mptctl.c: Remove credits and update copyright
(2) mptctl.c: cleanup in get_iocinfo

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


 


------_=_NextPart_000_01C54524.645CCDF0
Content-Type: application/octet-stream;
	name="patch-3-mptctl"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch-3-mptctl"

--- b/drivers/message/fusion/mptctl.c	2005-04-19 08:37:22.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptctl.c	2005-04-19 14:13:52.000000000 =
-0600=0A=
@@ -1,40 +1,12 @@=0A=
 /*=0A=
  *  linux/drivers/message/fusion/mptctl.c=0A=
- *      Fusion MPT misc device (ioctl) driver.=0A=
- *      For use with PCI chip/adapter(s):=0A=
- *          LSIFC9xx/LSI409xx Fibre Channel=0A=
+ *      mpt Ioctl driver.=0A=
+ *      For use with LSI Logic PCI chip/adapters=0A=
  *      running LSI Logic Fusion MPT (Message Passing Technology) =
firmware.=0A=
  *=0A=
- *  Credits:=0A=
- *      This driver would not exist if not for Alan Cox's =
development=0A=
- *      of the linux i2o driver.=0A=
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
- *      A huge debt of gratitude is owed to David S. Miller (DaveM)=0A=
- *      for fixing much of the stupid and broken stuff in the early=0A=
- *      driver while porting to sparc64 platform.  THANK YOU!=0A=
- *=0A=
- *      A big THANKS to Eddie C. Dost for fixing the ioctl path=0A=
- *      and most importantly f/w download on sparc64 platform!=0A=
- *      (plus Eddie's other helpful hints and insights)=0A=
- *=0A=
- *      Thanks to Arnaldo Carvalho de Melo for finding and patching=0A=
- *      a potential memory leak in mptctl_do_fw_download(),=0A=
- *      and for some kmalloc insight:-)=0A=
- *=0A=
- *      (see also mptbase.c)=0A=
- *=0A=
- *  Copyright (c) 1999-2004 LSI Logic Corporation=0A=
- *  Originally By: Steven J. Ralston, Noah Romer=0A=
- *  (mailto:sjralston1@netscape.net)=0A=
+ *  Copyright (c) 1999-2005 LSI Logic Corporation=0A=
  *  (mailto:mpt_linux_developer@lsil.com)=0A=
  *=0A=
- *  $Id: mptctl.c,v 1.63 2002/12/03 21:26:33 pdelaney Exp $=0A=
  */=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
@@ -95,8 +67,8 @@=0A=
 #include <scsi/scsi_host.h>=0A=
 #include <scsi/scsi_tcq.h>=0A=
 =0A=
-#define COPYRIGHT	"Copyright (c) 1999-2004 LSI Logic Corporation"=0A=
-#define MODULEAUTHOR	"Steven J. Ralston, Noah Romer, Pamela =
Delaney"=0A=
+#define COPYRIGHT	"Copyright (c) 1999-2005 LSI Logic Corporation"=0A=
+#define MODULEAUTHOR	"LSI Logic Corporation"=0A=
 #include "mptbase.h"=0A=
 #include "mptctl.h"=0A=
 =0A=
@@ -1119,7 +1091,7 @@=0A=
 	int			numDevices =3D 0;=0A=
 	unsigned int		max_id;=0A=
 	int			ii;=0A=
-	int			port;=0A=
+	unsigned int		port;=0A=
 	int			cim_rev;=0A=
 	u8			revision;=0A=
 =0A=
@@ -1162,9 +1134,7 @@=0A=
 		return -ENODEV;=0A=
 	}=0A=
 =0A=
-	/* Verify the data transfer size is correct.=0A=
-	 * Ignore the port setting.=0A=
-	 */=0A=
+	/* Verify the data transfer size is correct. */=0A=
 	if (karg->hdr.maxDataSize !=3D data_size) {=0A=
 		printk(KERN_ERR "%s@%d::mptctl_getiocinfo - "=0A=
 			"Structure size mismatch. Command not completed.\n",=0A=
@@ -1181,6 +1151,8 @@=0A=
 	else=0A=
 		karg->adapterType =3D MPT_IOCTL_INTERFACE_SCSI;=0A=
 =0A=
+	if (karg->hdr.port > 1)=0A=
+		return -EINVAL;=0A=
 	port =3D karg->hdr.port;=0A=
 =0A=
 	karg->port =3D port;=0A=
--- b/drivers/message/fusion/mptctl.h	2005-03-02 00:38:09.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptctl.h	2005-04-19 14:13:52.000000000 =
-0600=0A=
@@ -5,22 +5,9 @@=0A=
  *          LSIFC9xx/LSI409xx Fibre Channel=0A=
  *      running LSI Logic Fusion MPT (Message Passing Technology) =
firmware.=0A=
  *=0A=
- *  Credits:=0A=
- *      This driver would not exist if not for Alan Cox's =
development=0A=
- *      of the linux i2o driver.=0A=
- *=0A=
- *      A huge debt of gratitude is owed to David S. Miller (DaveM)=0A=
- *      for fixing much of the stupid and broken stuff in the early=0A=
- *      driver while porting to sparc64 platform.  THANK YOU!=0A=
- *=0A=
- *      (see also mptbase.c)=0A=
- *=0A=
- *  Copyright (c) 1999-2004 LSI Logic Corporation=0A=
- *  Originally By: Steven J. Ralston=0A=
- *  (mailto:sjralston1@netscape.net)=0A=
+ *  Copyright (c) 1999-2005 LSI Logic Corporation=0A=
  *  (mailto:mpt_linux_developer@lsil.com)=0A=
  *=0A=
- *  $Id: mptctl.h,v 1.13 2002/12/03 21:26:33 pdelaney Exp $=0A=
  */=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=

------_=_NextPart_000_01C54524.645CCDF0--
