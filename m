From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] 16) request_region check, 11-20
Date: Wed, 07 Aug 2002 14:23:10 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020807043044.D3B0A4AB0@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-scsi@vger.kernel.org

From:  johnpol@2ka.mipt.ru

(Included in 2.5)
  here is one more trivial check.
  
  So please test and apply.
  
  	Evgeniy Polyakov ( s0mbre )
  

--- trivial-2.4.20-pre1/drivers/acorn/scsi/oak.c.orig	2002-08-07 10:58:01.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/acorn/scsi/oak.c	2002-08-07 10:58:01.000000000 +1000
@@ -134,7 +134,8 @@
 	ecard_claim(ecs[count]);
 
 	instance->n_io_port = 255;
-	request_region (instance->io_port, instance->n_io_port, "Oak SCSI");
+	if (!request_region (instance->io_port, instance->n_io_port, "Oak SCSI"))
+		break;
 
 	if (instance->irq != IRQ_NONE)
 	    if (request_irq(instance->irq, do_oakscsi_intr, SA_INTERRUPT, "Oak SCSI", NULL)) {
-- 
  Don't blame me: the Monkey is driving
