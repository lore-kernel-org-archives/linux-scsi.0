From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [2.5 PATCH] Fix SCSI compile for non ISA DMA systems
Date: Fri, 18 Apr 2003 17:57:49 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030418080205.0A03B2C106@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:32991 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S262930AbTDRHuI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2003 03:50:08 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[ Is this correct?  Should it be BUG() if shost->dma_channel != 0xff
  and !CONFIG_GENERIC_ISA_DMA?  Thanks, Rusty. ]

From:  Matt Porter <porter@cox.net>

  [kernel/dma.o:free_dma() depends on CONFIG_GENERIC_ISA_DMA]
  
  ===== drivers/scsi/hosts.c 1.56 vs edited =====

--- trivial-2.5.67-bk8/drivers/scsi/hosts.c.orig	2003-04-18 17:43:55.000000000 +1000
+++ trivial-2.5.67-bk8/drivers/scsi/hosts.c	2003-04-18 17:43:55.000000000 +1000
@@ -183,8 +183,10 @@
 {
 	if (shost->irq)
 		free_irq(shost->irq, NULL);
+#ifdef CONFIG_GENERIC_ISA_DMA
 	if (shost->dma_channel != 0xff)
 		free_dma(shost->dma_channel);
+#endif
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
 
-- 
  Don't blame me: the Monkey is driving
  File: Matt Porter <porter@cox.net>: [2.5 PATCH] Fix SCSI compile for non ISA DMA systems
