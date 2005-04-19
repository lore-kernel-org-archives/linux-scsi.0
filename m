From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 1/7] mptfusion: Kconfig Adding new bus type drivers for fu
	sion drivers.
Date: Tue, 19 Apr 2005 15:11:36 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C020C3D4A@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C54524.5F2F4600"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:5623 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261673AbVDSVL6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 17:11:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C54524.5F2F4600
Content-Type: text/plain;
	charset="iso-8859-1"

mptfusion patch 1/7:

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-kernel/3.03.00/

Changelog:

(1) Kconfig - added new mptspi and mptfc scsi lld drivers
(2) Kconfig - increased MAX_SGE from 40 to 128 
(2) Makefile - compilation support for split drivers
(3) Makefile - cleaned up debug defines; e.g. removed obsolete, added others



Signed-off-by: Eric Moore <Eric.Moore@lsil.com>





------_=_NextPart_000_01C54524.5F2F4600
Content-Type: application/octet-stream;
	name="patch-1-kconfig"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch-1-kconfig"

--- b/drivers/message/fusion/Kconfig	2005-03-02 00:38:38.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/Kconfig	2005-04-19 14:13:19.000000000 =
-0600=0A=
@@ -1,35 +1,50 @@=0A=
 =0A=
 menu "Fusion MPT device support"=0A=
 =0A=
-config FUSION=0A=
-	tristate "Fusion MPT (base + ScsiHost) drivers"=0A=
+config FUSION_SPI=0A=
+	tristate "Fusion MPT ScsiHost drivers for SPI"=0A=
 	depends on PCI && SCSI=0A=
 	---help---=0A=
-	  LSI Logic Fusion(TM) Message Passing Technology (MPT) device =
support=0A=
-	  provides high performance SCSI host initiator, and LAN [1] =
interface=0A=
-	  services to a host system.  The Fusion architecture is capable =
of=0A=
-	  duplexing these protocols on high-speed Fibre Channel=0A=
-	  (up to 2 GHz x 2 ports =3D 4 GHz) and parallel SCSI (up to =
Ultra-320)=0A=
-	  physical medium.=0A=
+	  SCSI HOST support for a parallel SCSI host adapters.=0A=
 =0A=
-	  [1] LAN is not supported on parallel SCSI medium.=0A=
+	  List of supported controllers:=0A=
+=0A=
+	  LSI53C1020=0A=
+	  LSI53C1020A=0A=
+	  LSI53C1030=0A=
+	  LSI53C1035=0A=
+=0A=
+config FUSION_FC=0A=
+	tristate "Fusion MPT ScsiHost drivers for FC"=0A=
+	depends on PCI && SCSI=0A=
+	---help---=0A=
+	  SCSI HOST support for a Fiber Channel host adapters.=0A=
+=0A=
+	  List of supported controllers:=0A=
+=0A=
+	  LSIFC909=0A=
+	  LSIFC919=0A=
+	  LSIFC919X=0A=
+	  LSIFC929=0A=
+	  LSIFC929X=0A=
+	  LSIFC929XL=0A=
 =0A=
 config FUSION_MAX_SGE=0A=
 	int "Maximum number of scatter gather entries"=0A=
-	depends on FUSION=0A=
-	default "40"=0A=
+	depends on FUSION_SPI || FUSION_FC=0A=
+	default "128"=0A=
 	help=0A=
 	  This option allows you to specify the maximum number of scatter-=0A=
 	  gather entries per I/O. The driver defaults to 40, a reasonable =
number=0A=
 	  for most systems. However, the user may increase this up to 128.=0A=
-	  Increasing this parameter will require significantly more memory =
=0A=
+	  Increasing this parameter will require significantly more memory=0A=
 	  on a per controller instance. Increasing the parameter is not=0A=
-	  necessary (or recommended) unless the user will be running =0A=
+	  necessary (or recommended) unless the user will be running=0A=
 	  large I/O's via the raw interface.=0A=
 =0A=
 config FUSION_CTL=0A=
 	tristate "Fusion MPT misc device (ioctl) driver"=0A=
-	depends on FUSION=0A=
+	depends on FUSION_SPI || FUSION_FC=0A=
 	---help---=0A=
 	  The Fusion MPT misc device driver provides specialized control=0A=
 	  of MPT adapters via system ioctl calls.  Use of ioctl calls to=0A=
@@ -48,7 +63,7 @@=0A=
 =0A=
 config FUSION_LAN=0A=
 	tristate "Fusion MPT LAN driver"=0A=
-	depends on FUSION && NET_FC=0A=
+	depends on FUSION_FC && NET_FC=0A=
 	---help---=0A=
 	  This module supports LAN IP traffic over Fibre Channel port(s)=0A=
 	  on Fusion MPT compatible hardware (LSIFC9xx chips).=0A=
--- b/drivers/message/fusion/Makefile	2005-03-02 00:38:13.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/Makefile	2005-04-19 14:13:19.000000000 =
-0600=0A=
@@ -1,52 +1,38 @@=0A=
-#=0A=
-# Makefile for the LSI Logic Fusion MPT (Message Passing Technology) =
drivers.=0A=
-#=0A=
-# Note! If you want to turn on various debug defines for an extended =
period of=0A=
-# time but don't want them lingering around in the Makefile when you =
pass it on=0A=
-# to someone else, use the MPT_CFLAGS env variable (thanks Steve). =
-nromer=0A=
-=0A=
-#=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-{ LSI_LOGIC=0A=
-=0A=
-#  Architecture-specific...=0A=
-#			# intel=0A=
-#EXTRA_CFLAGS +=3D -g=0A=
-#			# sparc64=0A=
-#EXTRA_CFLAGS +=3D -gstabs+=0A=
-=0A=
-EXTRA_CFLAGS +=3D ${MPT_CFLAGS}=0A=
-=0A=
 # Fusion MPT drivers; recognized debug defines...=0A=
 #  MPT general:=0A=
-#EXTRA_CFLAGS +=3D -DMPT_DEBUG_SCSI=0A=
 #EXTRA_CFLAGS +=3D -DMPT_DEBUG=0A=
 #EXTRA_CFLAGS +=3D -DMPT_DEBUG_MSG_FRAME=0A=
 #EXTRA_CFLAGS +=3D -DMPT_DEBUG_SG=0A=
+#EXTRA_CFLAGS +=3D -DMPT_DEBUG_EVENTS=0A=
+#EXTRA_CFLAGS +=3D -DMPT_DEBUG_INIT=0A=
+#EXTRA_CFLAGS +=3D -DMPT_DEBUG_EXIT=0A=
+#EXTRA_CFLAGS +=3D -DMPT_DEBUG_FAIL=0A=
+=0A=
 =0A=
 #=0A=
 # driver/module specifics...=0A=
 #=0A=
 #  For mptbase:=0A=
 #CFLAGS_mptbase.o +=3D -DMPT_DEBUG_HANDSHAKE=0A=
+#CFLAGS_mptbase.o +=3D -DMPT_DEBUG_CONFIG=0A=
+#CFLAGS_mptbase.o +=3D -DMPT_DEBUG_DL=0A=
 #CFLAGS_mptbase.o +=3D -DMPT_DEBUG_IRQ=0A=
+#CFLAGS_mptbase.o +=3D -DMPT_DEBUG_RESET=0A=
 #=0A=
 #  For mptscsih:=0A=
-#CFLAGS_mptscsih.o +=3D -DMPT_DEBUG_SCANDV=0A=
-#CFLAGS_mptscsih.o +=3D -DMPT_DEBUG_RESET=0A=
-#CFLAGS_mptscsih.o +=3D -DMPT_DEBUG_NEH=0A=
+#CFLAGS_mptscsih.o +=3D -DMPT_DEBUG_DV=0A=
+#CFLAGS_mptscsih.o +=3D -DMPT_DEBUG_NEGO=0A=
+#CFLAGS_mptscsih.o +=3D -DMPT_DEBUG_TM=0A=
+#CFLAGS_mptscsih.o +=3D -DMPT_DEBUG_SCSI=0A=
+#CFLAGS_mptscsih.o +=3D -DMPT_DEBUG_REPLY=0A=
 #=0A=
 #  For mptctl:=0A=
 #CFLAGS_mptctl.o +=3D -DMPT_DEBUG_IOCTL=0A=
 #=0A=
-#  For mptlan:=0A=
-#CFLAGS_mptlan.o +=3D -DMPT_LAN_IO_DEBUG=0A=
-#=0A=
-#  For isense:=0A=
-=0A=
-#  EXP...=0A=
-##mptscsih-objs	:=3D scsihost.o scsiherr.o=0A=
 =0A=
 =
#=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-} LSI_LOGIC=0A=
 =0A=
-obj-$(CONFIG_FUSION)		+=3D mptbase.o mptscsih.o=0A=
+obj-$(CONFIG_FUSION_SPI)	+=3D mptspi.o mptscsih.o mptbase.o=0A=
+obj-$(CONFIG_FUSION_FC)		+=3D mptfc.o mptscsih.o mptbase.o=0A=
 obj-$(CONFIG_FUSION_CTL)	+=3D mptctl.o=0A=
 obj-$(CONFIG_FUSION_LAN)	+=3D mptlan.o=0A=

------_=_NextPart_000_01C54524.5F2F4600--
