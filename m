From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: [PATCH 24/39] scsi/atari_scsi: use wait_event()
Date: Thu, 20 Jan 2005 16:11:36 -0800
Message-ID: <20050121001136.GM2600@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:11712 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261546AbVAUA2y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 19:28:54 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j0L0SrJX021613
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jan 2005 19:28:53 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0L0SrXM266370
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jan 2005 19:28:53 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j0L0SqXD005365
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jan 2005 19:28:52 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roman.Hodek@informatik.uni-erlangen.de, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, kernel-janitors@lists.osdl.org

Hi,

Please consider applying.

Description: Use wait_event() instead of the deprecated sleep_on() function. The
second replacement is more difficult, as there are various conditions which may
cause the while-loop to break, each resulting in a different effect.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

--- 2.6.11-rc1-kj-v/drivers/scsi/atari_scsi.c	2005-01-15 16:55:43.000000000 -0800
+++ 2.6.11-rc1-kj/drivers/scsi/atari_scsi.c	2005-01-20 16:08:25.000000000 -0800
@@ -67,6 +67,7 @@
 
 #include <linux/config.h>
 #include <linux/module.h>
+#include <linux/wait.h>
 
 #define NDEBUG (0)
 
@@ -559,24 +560,20 @@ static void falcon_get_lock( void )
 
 	local_irq_save(flags);
 
-	while( !in_interrupt() && falcon_got_lock && stdma_others_waiting() )
-		sleep_on( &falcon_fairness_wait );
-
-	while (!falcon_got_lock) {
-		if (in_interrupt())
-			panic( "Falcon SCSI hasn't ST-DMA lock in interrupt" );
-		if (!falcon_trying_lock) {
-			falcon_trying_lock = 1;
-			stdma_lock(scsi_falcon_intr, NULL);
-			falcon_got_lock = 1;
-			falcon_trying_lock = 0;
-			wake_up( &falcon_try_wait );
-		}
-		else {
-			sleep_on( &falcon_try_wait );
-		}
-	}	
+	wait_event(falcon_fairness_wait, (in_interrupt() ||
+			falcon_got_lock || stdma_others_waiting()));
 
+	wait_event(falcon_try_wait, (in_interrupt() ||
+				falcon_got_lock || !falcon_trying_lock));
+	if (in_interrupt())
+		panic( "Falcon SCSI hasn't ST-DMA lock in interrupt" );
+	if (!falcon_trying_lock) {
+		falcon_trying_lock = 1;
+		stdma_lock(scsi_falcon_intr, NULL);
+		falcon_got_lock = 1;
+		falcon_trying_lock = 0;
+		wake_up(&falcon_try_wait);
+	}
 	local_irq_restore(flags);
 	if (!falcon_got_lock)
 		panic("Falcon SCSI: someone stole the lock :-(\n");
