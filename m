From: Adrian Bunk <bunk@fs.tum.de>
Subject: 2.4.28-pre3: broken ips update
Date: Mon, 13 Sep 2004 09:03:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040913070334.GD1937@fs.tum.de>
References: <20040911220117.GA4669@logos.cnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42501 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S266223AbUIMHEH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 03:04:07 -0400
Content-Disposition: inline
In-Reply-To: <20040911220117.GA4669@logos.cnet>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, ipslinux@adaptec.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, Sep 11, 2004 at 07:01:17PM -0300, Marcelo Tosatti wrote:
>...
> Summary of changes from v2.4.28-pre2 to v2.4.28-pre3
> ============================================
>...
> Jack Hammer:
>   o ServeRAID driver (ips) Version 7.10.18
>...

<--  snip  -->

...
gcc-3.4 -D__KERNEL__ 
-I/home/bunk/linux/kernel-2.4/linux-2.4.28-pre3-full/include -Wall 
-Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common 
-fomit-frame-pointer -pipe -mpreferred-stack-boundary=2 -march=athlon 
-fno-unit-at-a-time   -nostdinc -iwithprefix include 
-DKBUILD_BASENAME=ips  -c -o ips.o ips.c
In file included from ips.c:190:
ips.h:101: error: redefinition of typedef 'irqreturn_t'
/home/bunk/linux/kernel-2.4/linux-2.4.28-pre3-full/include/linux/interrupt.h:16: 
error: previous declaration of 'irqreturn_t' was here
make[3]: *** [ips.o] Error 1
make[3]: Leaving directory `/home/bunk/linux/kernel-2.4/linux-2.4.28-pre3-full/drivers/scsi'

<--  snip  -->


This update was obviously submitted without even testing the compilation 
of the driver (not to mention testing whether it actually works).


Even worse:

We had _exactly the same problem_ with the 7.00.15 driver in 
2.4.27-pre3, but 7.10.18 now simply reverts my (trivial) fix for this 
compile error.


Marcelo, can you please refuse patches from people who don't bother to 
do even the simplest compile testing when blindly submitting the latest 
version of a driver?


TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

