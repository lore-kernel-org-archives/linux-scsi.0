From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: [PATCH 2.6 ] MPT Fusion driver 3.01.01 update
Date: Thu, 11 Mar 2004 12:32:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57040DAD5A@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C4078E.C60D08F0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:17873 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261558AbUCKRcK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2004 12:32:10 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C4078E.C60D08F0
Content-Type: text/plain;
	charset="iso-8859-1"

This is an update for the MPT Fusion drivers 2.6 kernel.
Version 3.01.01.

This is a fix for poor performance in RAID Volumes. 
The dvStatus was being cleared for hidden physical disks
when mptscsih_slave_destroy is called.

Also, I have fixed the warning comming from mptscsih_reset_timeouts.

You can download full source as well as the patches for this 
driver at:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-patches/3.01.01

This attached patch is against the 3.01.00 driver.


Eric Moore
Staff Engineer
Standard Storage Products Division
LSI Logic Corporation
4420 Arrowswest Drive
Colorado Springs, CO 80907
Email: emoore@lsil.com
Web: http://www.lsilogic.com/


------_=_NextPart_000_01C4078E.C60D08F0
Content-Type: application/octet-stream;
	name="mptlinux-3.01.01.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptlinux-3.01.01.patch"

diff -uarN b/drivers/message/fusion/mptbase.h =
a/drivers/message/fusion/mptbase.h=0A=
--- b/drivers/message/fusion/mptbase.h	2004-03-05 12:01:39.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptbase.h	2004-03-11 08:41:17.000000000 =
-0700=0A=
@@ -81,8 +81,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2004 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.01.00"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.00"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.01.01"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.01"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=
diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2004-03-05 12:01:39.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptscsih.c	2004-03-11 08:55:49.000000000 =
-0700=0A=
@@ -199,8 +199,8 @@=0A=
 static int	mptscsih_setup(char *str);=0A=
 =0A=
 /* module entry point */=0A=
-static int  __init    mptscsih_init  (void);=0A=
-static void __exit    mptscsih_exit  (void);=0A=
+static int  __init   mptscsih_init  (void);=0A=
+static void __exit   mptscsih_exit  (void);=0A=
 =0A=
 static int  mptscsih_probe (struct pci_dev *, const struct =
pci_device_id *);=0A=
 static void mptscsih_remove(struct pci_dev *);=0A=
@@ -1067,10 +1067,14 @@=0A=
 	Scsi_Cmnd	*SCpnt;=0A=
 	int		 ii;=0A=
 	int		 max =3D hd->ioc->req_depth;=0A=
+		=0A=
 =0A=
 	for (ii=3D 0; ii < max; ii++) {=0A=
 		if ((SCpnt =3D hd->ScsiLookup[ii]) !=3D NULL) {=0A=
-			mod_timer(&SCpnt->eh_timeout, jiffies + (HZ * 60));=0A=
+	/* calling mod_timer() panics in 2.6 kernel...=0A=
+	 * need to investigate=0A=
+	 */=0A=
+//			mod_timer(&SCpnt->eh_timeout, jiffies + (HZ * 60));=0A=
 			dtmprintk((MYIOC_s_WARN_FMT "resetting SCpnt=3D%p timeout + =
60HZ",=0A=
 				(hd && hd->ioc) ? hd->ioc->name : "ioc?", SCpnt));=0A=
 		}=0A=
@@ -1978,8 +1982,8 @@=0A=
  *	mptscsih_exit - Unregisters MPT adapter(s)=0A=
  *=0A=
  */=0A=
-static void=0A=
-__exit mptscsih_exit(void)=0A=
+static void __exit=0A=
+mptscsih_exit(void)=0A=
 {=0A=
 	MPT_ADAPTER	*ioc;=0A=
 =0A=
@@ -3339,6 +3343,7 @@=0A=
 	struct Scsi_Host	*host =3D device->host;=0A=
 	MPT_SCSI_HOST		*hd;=0A=
 	VirtDevice		*vdev;=0A=
+	int 			raid_volume=3D0;=0A=
 =0A=
 	hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
 =0A=
@@ -3361,25 +3366,33 @@=0A=
 			kfree(hd->Targets[device->id]);=0A=
 			hd->Targets[device->id] =3D NULL;=0A=
 =0A=
-			if (hd->is_spi) {=0A=
+			if (!hd->is_spi) =0A=
+				return;=0A=
+=0A=
+			if((hd->ioc->spi_data.isRaid) && (hd->ioc->spi_data.pIocPg3)) {=0A=
+			int i;=0A=
+				for(i=3D0;i<hd->ioc->spi_data.pIocPg3->NumPhysDisks &&=0A=
+					raid_volume=3D=3D0;i++)=0A=
+						=0A=
+					if(device->id =3D=3D =0A=
+					  hd->ioc->spi_data.pIocPg3->PhysDisk[i].PhysDiskNum) {=0A=
+						raid_volume=3D1;=0A=
+						hd->ioc->spi_data.forceDv |=3D=0A=
+						  MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
+					}=0A=
+			}=0A=
+=0A=
+			if(!raid_volume){=0A=
 				hd->ioc->spi_data.dvStatus[device->id] =3D=0A=
 				MPT_SCSICFG_NEGOTIATE;=0A=
 =0A=
 				if (hd->negoNvram =3D=3D 0)=0A=
 					hd->ioc->spi_data.dvStatus[device->id]=0A=
 					|=3D MPT_SCSICFG_DV_NOT_DONE;=0A=
-=0A=
-				/* Don't alter isRaid, not allowed to move=0A=
-				 * volumes on a running system.=0A=
-				 */=0A=
-				if (hd->ioc->spi_data.isRaid & (1 <<=0A=
-					(device->id)))=0A=
-					hd->ioc->spi_data.forceDv |=3D=0A=
-					MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
 			}=0A=
 		}=0A=
 	}=0A=
-=0A=
+	=0A=
 	return;=0A=
 }=0A=
 =0A=
@@ -3693,12 +3706,8 @@=0A=
 		 */=0A=
 		hd->resetPending =3D 1;=0A=
 =0A=
-#if 0		=0A=
-		/* calling mod_timer() panics in 2.6 kernel...=0A=
-		 * need to investigate=0A=
-		 */=0A=
 		mptscsih_reset_timeouts (hd);=0A=
-#endif=0A=
+	=0A=
 	} else if (reset_phase =3D=3D MPT_IOC_PRE_RESET) {=0A=
 		dtmprintk((MYIOC_s_WARN_FMT "Pre-Diag Reset\n", ioc->name));=0A=
 =0A=

------_=_NextPart_000_01C4078E.C60D08F0--
