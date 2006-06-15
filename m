From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: PATCH: atari sleep_on noise
Date: Thu, 15 Jun 2006 16:35:49 +0100
Message-ID: <1150385750.3490.88.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:31376 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S1030647AbWFOPTY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 11:19:24 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by lxorguk.ukuu.org.uk (8.13.6/8.13.4) with ESMTP id k5FFZomT006342
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2006 16:35:50 +0100
Received: (from alan@localhost)
	by localhost.localdomain (8.13.6/8.13.6/Submit) id k5FFZoxL006341
	for linux-scsi@vger.kernel.org; Thu, 15 Jun 2006 16:35:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dunno if anyone cares, dunno if its actually neccessary given the
local_irq_save but it cuts down on the noise when removing deprecated
bits and it seems trivial ...

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.17-rc6/drivers/scsi/atari_scsi.c linux-2.6.17-rc6/drivers/scsi/atari_scsi.c
--- linux.vanilla-2.6.17-rc6/drivers/scsi/atari_scsi.c	2006-06-06 14:01:13.000000000 +0100
+++ linux-2.6.17-rc6/drivers/scsi/atari_scsi.c	2006-06-14 18:03:03.000000000 +0100
@@ -559,8 +559,8 @@
 
 	local_irq_save(flags);
 
-	while( !in_interrupt() && falcon_got_lock && stdma_others_waiting() )
-		sleep_on( &falcon_fairness_wait );
+	if( !in_interrupt())
+		wait_event(&falcon_fairness_wait, falcon_got_lock && stdma_others_waiting());
 
 	while (!falcon_got_lock) {
 		if (in_interrupt())
@@ -573,7 +573,7 @@
 			wake_up( &falcon_try_wait );
 		}
 		else {
-			sleep_on( &falcon_try_wait );
+			wait_event(&falcon_try_wait, !falcon_trying_lock );
 		}
 	}	
 

