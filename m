From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.5 patch] fix the compilation of sym53c416.c
Date: Tue, 25 Feb 2003 18:53:10 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030225175310.GQ7685@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org


In 2.5.63 I get the following compile error in drivers/scsi/sym53c416.c:


<--  snip  -->

...
  gcc -Wp,-MD,drivers/scsi/.sym53c416.o.d -D__KERNEL__ -Iinclude -Wall 
-Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common 
-pipe -mpreferred-stack-boundary=2 -march=k6 
-Iinclude/asm-i386/mach-default -nostdinc -iwithprefix include    
-DKBUILD_BASENAME=sym53c416 -DKBUILD_MODNAME=sym53c416 -c -o 
drivers/scsi/sym53c416.o drivers/scsi/sym53c416.c
drivers/scsi/sym53c416.c: In function `sym53c416_detect':
drivers/scsi/sym53c416.c:682: too many arguments to function 
`pnp_activate_dev'
make[2]: *** [drivers/scsi/sym53c416.o] Error 1

<--  snip  -->


The following patch fixes it:


--- linux-2.5.63-notfull/drivers/scsi/sym53c416.c.old	2003-02-25 18:49:37.000000000 +0100
+++ linux-2.5.63-notfull/drivers/scsi/sym53c416.c	2003-02-25 18:50:13.000000000 +0100
@@ -679,7 +679,7 @@
 				printk(KERN_WARNING "sym53c416: unable to attach PnP device.\n");
 				continue;
 			}
-			if(pnp_activate_dev(idev, NULL)<0)
+			if(pnp_activate_dev(idev) < 0)
 			{
 				printk(KERN_WARNING "sym53c416: unable to activate PnP device.\n");
 				pnp_device_detach(idev);



cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

