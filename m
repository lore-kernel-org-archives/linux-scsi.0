From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] fix fusion Kconfig oddities
Date: Mon, 23 Feb 2004 17:52:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703EF9677@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C3FA5F.A77F49C0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:32732 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262072AbUBWW7v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 17:59:51 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C3FA5F.A77F49C0
Content-Type: text/plain;
	charset="iso-8859-1"

I would like to propose the separating of the
mptscsih compilation from CONFIG_FUSION.
The CONFIG_LAN only depends on mptbase, so 
it should be okay to only compile *only* mptbase
from CONFIG_FUSION. 

Important note: all the arch defconfig 
would need to be modified to add 

CONFIG_FUSION_SCSI=M
or
CONFIG_FUSION_SCSI=y

Heres the attached patch to include the
changes proposed by Christoph.


Eric Moore
LSI Logic



On Saturday, February 21, 2004 12:35 PM, Christoph Hellwig wrote:
> 
>  - don't let FUSION depend on BLK_DEV_SD, no other LLDD does
>  - remove option FUSION_BOOT
>  - remove some overly verbose marketing blurb to make the help
>    text more similar to others
>  - remove dead comments
> 
> 
> --- 1.3/drivers/message/fusion/Kconfig	Fri Sep 12 05:19:35 2003
> +++ edited/drivers/message/fusion/Kconfig	Sat Feb 21 20:39:48 2004
> @@ -3,7 +3,6 @@
>  
>  config FUSION
>  	tristate "Fusion MPT (base + ScsiHost) drivers"
> -	depends on BLK_DEV_SD
>  	---help---
>  	  LSI Logic Fusion(TM) Message Passing Technology (MPT) 
> device support
>  	  provides high performance SCSI host initiator, and 
> LAN [1] interface
> @@ -14,41 +13,6 @@
>  
>  	  [1] LAN is not supported on parallel SCSI medium.
>  
> -	  These drivers require a Fusion MPT compatible PCI 
> adapter installed
> -	  in the host system.  MPT adapters contain specialized 
> I/O processors
> -	  to handle I/O workload, and more importantly to 
> offload this work
> -	  from the host CPU(s).
> -
> -	  If you have Fusion MPT hardware and want to use it, 
> you can say
> -	  Y or M here to add MPT (base + ScsiHost) drivers.
> -	  <Y> = build lib (fusion), and link [static] into the 
> kernel [2]
> -	  proper
> -	  <M> = compiled as [dynamic] modules [3] named: (mptbase,
> -	  mptscsih)
> -
> -	  [2] In order enable capability to boot the linux kernel
> -	  natively from a Fusion MPT target device, you MUST
> -	  answer Y here! (currently requires CONFIG_BLK_DEV_SD)
> -	  [3] To compile this support as modules, choose M here.
> -
> -	  If unsure, say N.
> -
> -	  If you say Y or M here you will get a choice of these
> -	  additional protocol and support module options:       
>   Module Name:
> -	  <M>   Enhanced SCSI error reporting                   
>   (isense)
> -	  <M>   Fusion MPT misc device (ioctl) driver           
>   (mptctl)
> -	  <M>   Fusion MPT LAN driver                           
>   (mptlan)
> -
> -	  ---
> -	  Fusion MPT is trademark of LSI Logic Corporation, and its
> -	  architecture is based on LSI Logic's Message Passing 
> Interface (MPI)
> -	  specification.
> -
> -config FUSION_BOOT
> -	bool
> -	depends on FUSION=y
> -	default y
> -
>  config FUSION_MAX_SGE
>  	int "Maximum number of scatter gather entries"
>  	depends on FUSION
> @@ -62,7 +26,6 @@
>  	  necessary (or recommended) unless the user will be running 
>  	  large I/O's via the raw interface.
>  
> -#  How can we force these options to module or nothing?
>  config FUSION_ISENSE
>  	tristate "Enhanced SCSI error reporting"
>  	depends on MODULES && FUSION && m
> @@ -132,17 +95,4 @@
>  
>  	  If unsure whether you really want or need this, say N.
>  
> -	  NOTES: This feature is NOT available nor supported 
> for linux-2.2.x
> -	  kernels.  You must be building a linux-2.3.x or 
> linux-2.4.x kernel
> -	  in order to configure this option.
> -	  Support for building this feature into the linux kernel is not
> -	  yet available.
> -
> -#  if [ "$CONFIG_FUSION_LAN" != "n" ]; then
> -#    define_bool CONFIG_NET_FC y
> -#  fi
> -# These <should> be define_tristate, but we leave them define_bool
> -# for backward compatibility with pre-linux-2.2.15 kernels.
> -# (Bugzilla:fibrebugs, #384)
>  endmenu
> -
> 


------_=_NextPart_000_01C3FA5F.A77F49C0
Content-Type: application/octet-stream;
	name="mptlinux.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptlinux.patch"

diff -uarN a/drivers/message/fusion/Kconfig =
b/drivers/message/fusion/Kconfig=0A=
--- a/drivers/message/fusion/Kconfig	2004-01-09 00:00:13.000000000 =
-0700=0A=
+++ b/drivers/message/fusion/Kconfig	2004-02-23 11:20:47.000000000 =
-0700=0A=
@@ -2,8 +2,8 @@=0A=
 menu "Fusion MPT device support"=0A=
 =0A=
 config FUSION=0A=
-	tristate "Fusion MPT (base + ScsiHost) drivers"=0A=
-	depends on BLK_DEV_SD=0A=
+	tristate "Fusion MPT base driver"=0A=
+	depends on PCI=0A=
 	---help---=0A=
 	  LSI Logic Fusion(TM) Message Passing Technology (MPT) device =
support=0A=
 	  provides high performance SCSI host initiator, and LAN [1] =
interface=0A=
@@ -14,46 +14,11 @@=0A=
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
 	default "40"=0A=
-	help=0A=
+	---help---=0A=
 	  This option allows you to specify the maximum number of scatter-=0A=
 	  gather entries per I/O. The driver defaults to 40, a reasonable =
number=0A=
 	  for most systems. However, the user may increase this up to 128.=0A=
@@ -62,7 +27,16 @@=0A=
 	  necessary (or recommended) unless the user will be running =0A=
 	  large I/O's via the raw interface.=0A=
 =0A=
-#  How can we force these options to module or nothing?=0A=
+config FUSION_SCSI=0A=
+	tristate "Fusion MPT ScsiHost driver"=0A=
+	depends on FUSION && SCSI=0A=
+	---help---=0A=
+	  This is a driver for SCSI host adapters using=0A=
+	  LSI Logic Fusion(TM) Message Passing Technology (MPT). =0A=
+=0A=
+	  If enabled by saying M to this, a driver named: mpscsih=0A=
+	  will be compiled.=0A=
+	  =0A=
 config FUSION_ISENSE=0A=
 	tristate "Enhanced SCSI error reporting"=0A=
 	depends on MODULES && FUSION && m=0A=
@@ -132,17 +106,4 @@=0A=
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
diff -uarN a/drivers/message/fusion/Makefile =
b/drivers/message/fusion/Makefile=0A=
--- a/drivers/message/fusion/Makefile	2004-01-08 23:59:45.000000000 =
-0700=0A=
+++ b/drivers/message/fusion/Makefile	2004-02-23 15:29:31.148656000 =
-0700=0A=
@@ -17,7 +17,7 @@=0A=
 =0A=
 # Fusion MPT drivers; recognized debug defines...=0A=
 #  MPT general:=0A=
-#EXTRA_CFLAGS +=3D -DDEBUG=0A=
+#EXTRA_CFLAGS +=3D -DMPT_DEBUG_SCSI=0A=
 #EXTRA_CFLAGS +=3D -DMPT_DEBUG=0A=
 #EXTRA_CFLAGS +=3D -DMPT_DEBUG_MSG_FRAME=0A=
 #EXTRA_CFLAGS +=3D -DMPT_DEBUG_SG=0A=
@@ -46,7 +46,8 @@=0A=
 =0A=
 =
#=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-} LSI_LOGIC=0A=
 =0A=
-obj-$(CONFIG_FUSION)		+=3D mptbase.o mptscsih.o=0A=
+obj-$(CONFIG_FUSION)		+=3D mptbase.o=0A=
+obj-$(CONFIG_FUSION_SCSI)	+=3D mptscsih.o=0A=
 obj-$(CONFIG_FUSION_ISENSE)	+=3D isense.o=0A=
 obj-$(CONFIG_FUSION_CTL)	+=3D mptctl.o=0A=
 obj-$(CONFIG_FUSION_LAN)	+=3D mptlan.o=0A=

------_=_NextPart_000_01C3FA5F.A77F49C0--
