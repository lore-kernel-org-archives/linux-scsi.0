From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 1/7] mptfusion: Adding new bus type drivers for fusion dri
	vers.
Date: Tue, 29 Mar 2005 13:05:01 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C01C2B97F@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C5349A.96EFC0F0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:22695 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261348AbVC2UFG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2005 15:05:06 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id j2TK2FJg001614
	for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2005 12:02:15 -0800 (PST)
Received: from nacos172.ad.lsil.com (cos1.co.lsil.com [172.21.35.122])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id j2TK52D6017360
	for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2005 12:05:02 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C5349A.96EFC0F0
Content-Type: text/plain;
	charset="iso-8859-1"

Changelog

(1) Kconfig - adding new mptspi and mptfc drivers
(2) Makefile - updates so new split driver can be compiled
(3) Makefile - adding other debug defines 

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>





------_=_NextPart_000_01C5349A.96EFC0F0
Content-Type: application/octet-stream;
	name="patch-1-kconfig"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch-1-kconfig"

diff -puN scsi-rc-fixes-2.6/drivers/message/fusion-3.01.20/Kconfig =
scsi-rc-fixes-2.6/drivers/message/fusion/Kconfig=0A=
--- scsi-rc-fixes-2.6/drivers/message/fusion-3.01.20/Kconfig	2005-03-29 =
11:19:00.000000000 -0700=0A=
+++ scsi-rc-fixes-2.6/drivers/message/fusion/Kconfig	2005-03-24 =
16:21:52.000000000 -0700=0A=
@@ -2,8 +2,8 @@=0A=
 menu "Fusion MPT device support"=0A=
 =0A=
 config FUSION=0A=
-	tristate "Fusion MPT (base + ScsiHost) drivers"=0A=
-	depends on PCI && SCSI=0A=
+	tristate "Fusion MPT (base) drivers"=0A=
+	depends on PCI=0A=
 	---help---=0A=
 	  LSI Logic Fusion(TM) Message Passing Technology (MPT) device =
support=0A=
 	  provides high performance SCSI host initiator, and LAN [1] =
interface=0A=
@@ -14,6 +14,34 @@ config FUSION=0A=
 =0A=
 	  [1] LAN is not supported on parallel SCSI medium.=0A=
 =0A=
+config FUSION_SPI=0A=
+	tristate "Fusion MPT (ScsiHost) drivers for SPI"=0A=
+	depends on FUSION && SCSI=0A=
+	---help---=0A=
+	This is SCSI HOST support for a parallel SCSI host adapters.=0A=
+=0A=
+	List of supported controllers:=0A=
+=0A=
+	LSI53C1020=0A=
+	LSI53C1020A=0A=
+	LSI53C1030=0A=
+	LSI53C1035=0A=
+=0A=
+config FUSION_FC=0A=
+	tristate "Fusion MPT (ScsiHost) drivers for FC"=0A=
+	depends on FUSION && SCSI=0A=
+	---help---=0A=
+	This is SCSI HOST support for a Fiber Channel host adapters.=0A=
+=0A=
+	List of supported controllers:=0A=
+=0A=
+	LSIFC909=0A=
+	LSIFC919=0A=
+	LSIFC919X=0A=
+	LSIFC929=0A=
+	LSIFC929X=0A=
+	LSIFC929XL=0A=
+=0A=
 config FUSION_MAX_SGE=0A=
 	int "Maximum number of scatter gather entries"=0A=
 	depends on FUSION=0A=
diff -puN scsi-rc-fixes-2.6/drivers/message/fusion-3.01.20/Makefile =
scsi-rc-fixes-2.6/drivers/message/fusion/Makefile=0A=
--- scsi-rc-fixes-2.6/drivers/message/fusion-3.01.20/Makefile	=
2005-03-29 11:19:00.000000000 -0700=0A=
+++ scsi-rc-fixes-2.6/drivers/message/fusion/Makefile	2005-03-28 =
16:48:36.000000000 -0700=0A=
@@ -1,52 +1,39 @@=0A=
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
+obj-$(CONFIG_FUSION)		+=3D mptbase.o=0A=
+obj-$(CONFIG_FUSION_SPI)	+=3D mptspi.o mptscsih.o=0A=
+obj-$(CONFIG_FUSION_FC)		+=3D mptfc.o mptscsih.o=0A=
 obj-$(CONFIG_FUSION_CTL)	+=3D mptctl.o=0A=
 obj-$(CONFIG_FUSION_LAN)	+=3D mptlan.o=0A=
Common subdirectories: =
scsi-rc-fixes-2.6/drivers/message/fusion-3.01.20/lsi and =
scsi-rc-fixes-2.6/drivers/message/fusion/lsi=0A=
 =0A=

------_=_NextPart_000_01C5349A.96EFC0F0--
