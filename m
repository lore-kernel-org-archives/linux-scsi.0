From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] drivers_scsi_NCR53C9x_c synchronize_irq() fix
Date: Tue, 06 Aug 2002 13:46:30 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020806035808.BC29B4B6A@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-scsi@vger.kernel.org

From:  Evgeniy Polyakov <johnpol@2ka.mipt.ru>

  Here is 6/6 of the drivers/{net,scsi} sychronize_irq() fix.
  Please test and apply.
  Against 2.5.29.
  
  -- 
  	Evgeniy Polyakov ( s0mbre )

--- trivial-2.5.30/drivers/scsi/NCR53C9x.c.orig	2002-08-06 13:18:06.000000000 +1000
+++ trivial-2.5.30/drivers/scsi/NCR53C9x.c	2002-08-06 13:18:06.000000000 +1000
@@ -1381,7 +1381,7 @@
 	don = esp->dma_ports_p(esp);
 	if(don) {
 		esp->dma_ints_off(esp);
-		synchronize_irq();
+		synchronize_irq(esp->irq);
 	}
 	if(esp->issue_SC) {
 		Scsi_Cmnd **prev, *this;
-- 
  Don't blame me: the Monkey is driving
