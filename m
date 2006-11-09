From: akpm@osdl.org
Subject: [patch 20/26] scsi: ips soft lockup during reset initialization
Date: Wed, 08 Nov 2006 19:56:26 -0800
Message-ID: <200611090356.kA93uR3w003995@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:4530 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1424012AbWKID4h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 22:56:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, jack_hammer@adaptec.com, nacc@us.ibm.com, nickpiggin@yahoo.com.au

From: Andrew Morton <akpm@osdl.org>

  Resetting the adapter causes the ServeRAID driver to exceed the max time
  allowed by the softlock watchdog.  Resetting the hardware can easily require
  30 or more seconds.  To avoid the

	"BUG: soft lockup detected on CPU#0!"

  result, this patch adds a touch_nmi_watchdog() to the driver's MDELAY macro.

Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: Jack Hammer <jack_hammer@adaptec.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/ips.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ips.h~scsi-ips-soft-lockup-during-reset-initialization-2 drivers/scsi/ips.h
--- a/drivers/scsi/ips.h~scsi-ips-soft-lockup-during-reset-initialization-2
+++ a/drivers/scsi/ips.h
@@ -51,6 +51,7 @@
    #define _IPS_H_
 
 #include <linux/version.h>
+#include <linux/nmi.h>
    #include <asm/uaccess.h>
    #include <asm/io.h>
 
@@ -116,9 +117,11 @@
             dev_printk(level , &((pcidev)->dev) , format , ## arg)
    #endif
 
-   #ifndef MDELAY
-      #define MDELAY mdelay
-   #endif
+   #define MDELAY(n)			\
+	do {				\
+		mdelay(n);		\
+		touch_nmi_watchdog();	\
+	} while (0)
 
    #ifndef min
       #define min(x,y) ((x) < (y) ? x : y)
_
