From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] 16) request_region check, 11-20
Date: Mon, 16 Dec 2002 21:49:39 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021216210038.8339A2C2CC@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk

(Included in 2.5)
From:  johnpol@2ka.mipt.ru

  here is one more trivial check.
  
  So please test and apply.
  
  	Evgeniy Polyakov ( s0mbre )
  

--- trivial-2.4.21-pre1/drivers/acorn/scsi/oak.c.orig	2002-12-16 17:22:38.000000000 +1100
+++ trivial-2.4.21-pre1/drivers/acorn/scsi/oak.c	2002-12-16 17:22:38.000000000 +1100
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
  File: johnpol@2ka.mipt.ru: 16) request_region check, 11-20
