From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.6 patch] SCSI gdth: kill #define __devinitdata
Date: Mon, 9 Aug 2004 21:41:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040809194105.GW26174@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:2279 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S266919AbUHITlM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Aug 2004 15:41:12 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: achim_leubner@adaptec.com
Cc: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

I got the following warning in 2.6.8-rc3-mm2:

<--  snip  -->

...
  CC      drivers/scsi/gdth.o
drivers/scsi/gdth.c:622:1: warning: "__devinitdata" redefined
In file included from include/linux/moduleparam.h:4,
                 from include/linux/module.h:20,
                 from drivers/scsi/gdth.c:375:
include/linux/init.h:227:1: warning: this is the location of the 
previous definition
...

<--  snip  -->


The #define in question seems bogus, and the following patch simply 
removes it:


Signed-off-by: Adrian Bunk <bunk@fs.tum.de>

--- linux-2.6.8-rc3-mm2-full-3.4/drivers/scsi/gdth.c.old	2004-08-09 20:59:07.000000000 +0200
+++ linux-2.6.8-rc3-mm2-full-3.4/drivers/scsi/gdth.c	2004-08-09 21:03:02.000000000 +0200
@@ -618,9 +618,6 @@
 };
 
 /* __initfunc, __initdata macros */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-#define __devinitdata
-#endif
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 #define GDTH_INITFUNC(type, func)       type __init func 
 #include <linux/init.h>

