From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] 15) request_region check, 11-20
Date: Thu, 06 Feb 2003 14:22:29 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030206053822.EC14D2C447@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk

(Included in 2.5)
From:  johnpol@2ka.mipt.ru

  here is one more trivial check.
  
  So please test and apply.
  
  	Evgeniy Polyakov ( s0mbre )
  

--- trivial-2.4.21-pre4/drivers/acorn/scsi/cumana_2.c.orig	2003-02-06 13:53:54.000000000 +1100
+++ trivial-2.4.21-pre4/drivers/acorn/scsi/cumana_2.c	2003-02-06 13:53:54.000000000 +1100
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
  File: johnpol@2ka.mipt.ru: 15) request_region check, 11-20
