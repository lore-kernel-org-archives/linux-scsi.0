From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] 15) request_region check, 11-20
Date: Mon, 23 Jun 2003 17:00:00 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030623070135.BEC4A2C275@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:34480 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S263462AbTFWGr3 (ORCPT
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
  

--- trivial-2.4.22-pre1/drivers/acorn/scsi/cumana_2.c.orig	2003-06-23 16:39:45.000000000 +1000
+++ trivial-2.4.22-pre1/drivers/acorn/scsi/cumana_2.c	2003-06-23 16:39:45.000000000 +1000
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
  What is this? http://www.kernel.org/pub/linux/kernel/people/rusty/trivial/
  Don't blame me: the Monkey is driving
  File: johnpol@2ka.mipt.ru: 15) request_region check, 11-20
