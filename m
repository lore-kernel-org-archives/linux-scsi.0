From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] 15) request_region check, 11-20
Date: Wed, 07 Aug 2002 14:23:05 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020807043052.A4CF84BA1@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-scsi@vger.kernel.org

From:  johnpol@2ka.mipt.ru

(Included in 2.5)
  here is one more trivial check.
  
  So please test and apply.
  
  	Evgeniy Polyakov ( s0mbre )
  

--- trivial-2.4.20-pre1/drivers/acorn/scsi/cumana_2.c.orig	2002-08-07 10:58:01.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/acorn/scsi/cumana_2.c	2002-08-07 10:58:01.000000000 +1000
@@ -382,8 +382,13 @@
 		ecs[count]->irq_data	= (void *)info->alatch;
 		ecs[count]->ops		= (expansioncard_ops_t *)&cumanascsi_2_ops;
 
-		request_region(host->io_port + CUMANASCSI2_FAS216_OFFSET,
-			       16 << CUMANASCSI2_FAS216_SHIFT, "cumanascsi2-fas");
+		if (!request_region(host->io_port + CUMANASCSI2_FAS216_OFFSET,
+			       16 << CUMANASCSI2_FAS216_SHIFT, "cumanascsi2-fas")) {
+			scsi_unregister(host);
+			ecard_release(ecs[count]);
+			break;
+		}
+			
 
 		if (host->irq != NO_IRQ &&
 		    request_irq(host->irq, cumanascsi_2_intr,
-- 
  Don't blame me: the Monkey is driving
