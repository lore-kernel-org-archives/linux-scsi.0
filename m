From: "IpsLinux" <ipslinux@Adaptec.com>
Subject: FW: [patch] 2.4.27-pre3: SCSI ips compile error
Date: Thu, 20 May 2004 10:02:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A121ABA5B472B74EB59076B8E3C8F0192AA46C@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:5089 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265108AbUETOCW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 10:02:22 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i4KC2Kg21937
	for <linux-scsi@vger.kernel.org>; Thu, 20 May 2004 05:02:20 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i4KE2Li25986
	for <linux-scsi@vger.kernel.org>; Thu, 20 May 2004 07:02:21 -0700
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 
Adaptec had already discovered this error also and were in the process
of testing an update.
I concur with this change.

Jack 


-----Original Message-----
From: Adrian Bunk [mailto:bunk@fs.tum.de]
Sent: Thursday, May 20, 2004 9:46 AM
To: Marcelo Tosatti; IpsLinux
Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: [patch] 2.4.27-pre3: SCSI ips compile error

On Tue, May 18, 2004 at 05:30:40PM -0300, Marcelo Tosatti wrote:
>...
> Summary of changes from v2.4.27-pre2 to v2.4.27-pre3 
>============================================
>...
> Jack Hammer:
>   o ServeRAID driver update to 7.00.15: sync with v2.6 ...

It was nice if people would actually test at least the compilation of
their changes instead of blindly submitting the latest version of a
driver...

<--  snip  -->

...
gcc -D__KERNEL__
-I/home/bunk/linux/kernel-2.4/linux-2.4.27-pre3-full/include -Wall
-Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common 
-fomit-frame-pointer -pipe -mpreferred-stack-boundary=2 -march=athlon   
-nostdinc -iwithprefix include -DKBUILD_BASENAME=ips  -c -o ips.o ips.c
In file included from ips.c:180:
ips.h:99: error: redefinition of `irqreturn_t'
/home/bunk/linux/kernel-2.4/linux-2.4.27-pre3-full/include/linux/interru
pt.h:16: 
error: `irqreturn_t' previously declared here
make[3]: *** [ips.o] Error 1
make[3]: Leaving directory
`/home/bunk/linux/kernel-2.4/linux-2.4.27-pre3-full/drivers/scsi'

<--  snip  -->


irqreturn_t was added to interrupt.h in 2.4.23, released nearly
6 months (!) ago.

Trivial fix below.

cu
Adrian



--- linux-2.4.27-pre3-full/drivers/scsi/ips.h.old	2004-05-19
21:40:58.000000000 +0200
+++ linux-2.4.27-pre3-full/drivers/scsi/ips.h	2004-05-19
21:42:01.000000000 +0200
@@ -95,11 +95,14 @@
       #define scsi_set_pci_device(sh,dev) (0)
    #endif
 
-   #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+   #if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,23)
       typedef void irqreturn_t;
       #define IRQ_NONE
       #define IRQ_HANDLED
       #define IRQ_RETVAL(x)
+   #endif
+
+   #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
       #define IPS_REGISTER_HOSTS(SHT)
scsi_register_module(MODULE_SCSI_HA,SHT)
       #define IPS_UNREGISTER_HOSTS(SHT)
scsi_unregister_module(MODULE_SCSI_HA,SHT)
       #define IPS_ADD_HOST(shost,device)
