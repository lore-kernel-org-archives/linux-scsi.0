From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.6 patch] fix NCR53C9x.c compile warning
Date: Sat, 20 Dec 2003 00:13:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20031219231321.GA12750@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I got the following compile warning in 2.6.0-test11-mm1:

<--  snip  -->

...
  CC [M]  drivers/scsi/NCR53C9x.o
drivers/scsi/NCR53C9x.c: In function `esp_do_data':
drivers/scsi/NCR53C9x.c:1838: warning: unused variable `flags'
...

<--  snip  -->


The following patch fixes this warning:


--- linux-2.6.0-test11-mm1-modular-no-smp/drivers/scsi/NCR53C9x.c.old	2003-12-19 23:26:15.000000000 +0100
+++ linux-2.6.0-test11-mm1-modular-no-smp/drivers/scsi/NCR53C9x.c	2003-12-19 23:27:10.000000000 +0100
@@ -1835,7 +1835,10 @@
 		/* loop */
 		while (hmuch) {
 			int j, fifo_stuck = 0, newphase;
-			unsigned long flags, timeout;
+			unsigned long timeout;
+#if 0
+			unsigned long flags;
+#endif
 #if 0
 			if ( i % 10 )
 				ESPDATA(("\r"));



Please apply
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
