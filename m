From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] SCSI/sym53c416: kill pointless irq handler loop and test
Date: Fri, 26 Oct 2007 05:40:31 -0400 (EDT)
Message-ID: <24e87e4aa5edf701f61c260ff1e5e504752c379b.1193390975.git.jeff@garzik.org>
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:56867 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759372AbXJZJlL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 05:41:11 -0400
In-Reply-To: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org

- kill pointless irq handler loop to find base address, it is already
  passed to irq handler via Scsi_Host.

- kill now-pointless !base test.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/scsi/sym53c416.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index 90cee94..1f6fd16 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -328,27 +328,13 @@ static __inline__ unsigned int sym53c416_write(int base, unsigned char *buffer,
 static irqreturn_t sym53c416_intr_handle(int irq, void *dev_id)
 {
 	struct Scsi_Host *dev = dev_id;
-	int base = 0;
+	int base = dev->io_port;
 	int i;
 	unsigned long flags = 0;
 	unsigned char status_reg, pio_int_reg, int_reg;
 	struct scatterlist *sg;
 	unsigned int tot_trans = 0;
 
-	/* We search the base address of the host adapter which caused the interrupt */
-	/* FIXME: should pass dev_id sensibly as hosts[i] */
-	for(i = 0; i < host_index && !base; i++)
-		if(irq == hosts[i].irq)
-			base = hosts[i].base;
-	/* If no adapter found, we cannot handle the interrupt. Leave a message */
-	/* and continue. This should never happen...                            */
-	if(!base)
-	{
-		printk(KERN_ERR "sym53c416: No host adapter defined for interrupt %d\n", irq);
-		return IRQ_NONE;
-	}
-	/* Now we have the base address and we can start handling the interrupt */
-
 	spin_lock_irqsave(dev->host_lock,flags);
 	status_reg = inb(base + STATUS_REG);
 	pio_int_reg = inb(base + PIO_INT_REG);
-- 
1.5.2.4

