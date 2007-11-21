From: akpm@linux-foundation.org
Subject: [patch 14/23] SCSI/sym53c416: kill pointless irq handler loop and test
Date: Wed, 21 Nov 2007 15:12:26 -0800
Message-ID: <200711212312.lALNCQqg014145@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40210 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754884AbXKUXRu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2007 18:17:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jeff@garzik.org, jgarzik@redhat.com, willy@debian.org

From: Jeff Garzik <jeff@garzik.org>

- kill pointless irq handler loop to find base address, it is already
  passed to irq handler via Scsi_Host.

- kill now-pointless !base test.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sym53c416.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff -puN drivers/scsi/sym53c416.c~scsi-sym53c416-kill-pointless-irq-handler-loop-and-test drivers/scsi/sym53c416.c
--- a/drivers/scsi/sym53c416.c~scsi-sym53c416-kill-pointless-irq-handler-loop-and-test
+++ a/drivers/scsi/sym53c416.c
@@ -328,27 +328,13 @@ static __inline__ unsigned int sym53c416
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
_
