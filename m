From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] 16) request_region check, 11-20
Date: Mon, 23 Jun 2003 17:00:03 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030623070136.1F08D2C2E7@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:36784 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S263761AbTFWGr3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2003 02:47:29 -0400
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk

(Included in 2.5)
From:  johnpol@2ka.mipt.ru

  here is one more trivial check.
  
  So please test and apply.
  
  	Evgeniy Polyakov ( s0mbre )
  

--- trivial-2.4.22-pre1/drivers/acorn/scsi/oak.c.orig	2003-06-23 16:39:46.000000000 +1000
+++ trivial-2.4.22-pre1/drivers/acorn/scsi/oak.c	2003-06-23 16:39:46.000000000 +1000
@@ -134,7 +134,8 @@
 	ecard_claim(ecs[count]);
 
 	instance->n_io_port = 255;
-	request_region (instance->io_port, instance->n_io_port, "Oak SCSI");
+	if (!request_region (instance->io_port, instance->n_io_port, "Oak SCSI"))
+		break;
 
 	if (instance->irq != IRQ_NONE)
 	    if (request_irq(instance->irq, do_oakscsi_intr, SA_INTERRUPT, "Oak SCSI", NULL)) {
-- 
  What is this? http://www.kernel.org/pub/linux/kernel/people/rusty/trivial/
  Don't blame me: the Monkey is driving
  File: johnpol@2ka.mipt.ru: 16) request_region check, 11-20
