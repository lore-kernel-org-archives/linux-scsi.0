From: Adrian Bunk <bunk@fs.tum.de>
Subject: [patch] 2.4.27-pre3: SCSI ips compile error
Date: Thu, 20 May 2004 15:46:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040520134604.GL24287@fs.tum.de>
References: <20040518203039.GA9970@logos.cnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:56303 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S265146AbUETNqL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 09:46:11 -0400
Content-Disposition: inline
In-Reply-To: <20040518203039.GA9970@logos.cnet>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, ipslinux@adaptec.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, May 18, 2004 at 05:30:40PM -0300, Marcelo Tosatti wrote:
>...
> Summary of changes from v2.4.27-pre2 to v2.4.27-pre3
> ============================================
>...
> Jack Hammer:
>   o ServeRAID driver update to 7.00.15: sync with v2.6
>...

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
/home/bunk/linux/kernel-2.4/linux-2.4.27-pre3-full/include/linux/interrupt.h:16: 
error: `irqreturn_t' previously declared here
make[3]: *** [ips.o] Error 1
make[3]: Leaving directory `/home/bunk/linux/kernel-2.4/linux-2.4.27-pre3-full/drivers/scsi'

<--  snip  -->


irqreturn_t was added to interrupt.h in 2.4.23, released nearly
6 months (!) ago.

Trivial fix below.

cu
Adrian



--- linux-2.4.27-pre3-full/drivers/scsi/ips.h.old	2004-05-19 21:40:58.000000000 +0200
+++ linux-2.4.27-pre3-full/drivers/scsi/ips.h	2004-05-19 21:42:01.000000000 +0200
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
       #define IPS_REGISTER_HOSTS(SHT)      scsi_register_module(MODULE_SCSI_HA,SHT)
       #define IPS_UNREGISTER_HOSTS(SHT)    scsi_unregister_module(MODULE_SCSI_HA,SHT)
       #define IPS_ADD_HOST(shost,device)
