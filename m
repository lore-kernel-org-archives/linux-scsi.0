From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 24/36] aha1542: Always name Scsi_Host variables sh
Date: Fri,  6 Feb 2015 23:11:45 +0100
Message-ID: <1423260717-15944-25-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56961 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037AbbBFWPw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:15:52 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8H-0006fF-0C
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:13 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Make Scsi_Host variable names consistent - use sh everywhere.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   98 ++++++++++++++++++++++++------------------------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index dcc493d..7b06698 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -241,7 +241,7 @@ static int makecode(unsigned hosterr, unsigned scsierr)
 	return scsierr | (hosterr << 16);
 }
 
-static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
+static int aha1542_test_port(int bse, struct Scsi_Host *sh)
 {
 	u8 inquiry_result[4];
 	int i;
@@ -293,9 +293,9 @@ static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 }
 
 /* A "high" level interrupt handler */
-static void aha1542_intr_handle(struct Scsi_Host *shost)
+static void aha1542_intr_handle(struct Scsi_Host *sh)
 {
-	struct aha1542_hostdata *aha1542 = shost_priv(shost);
+	struct aha1542_hostdata *aha1542 = shost_priv(sh);
 	void (*my_done)(struct scsi_cmnd *) = NULL;
 	int errstatus, mbi, mbo, mbistatus;
 	int number_serviced;
@@ -307,7 +307,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 
 #ifdef DEBUG
 	{
-		flag = inb(INTRFLAGS(shost->io_port));
+		flag = inb(INTRFLAGS(sh->io_port));
 		printk(KERN_DEBUG "aha1542_intr_handle: ");
 		if (!(flag & ANYINTR))
 			printk("no interrupt?");
@@ -319,13 +319,13 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 			printk("HACC ");
 		if (flag & SCRD)
 			printk("SCRD ");
-		printk("status %02x\n", inb(STATUS(shost->io_port)));
+		printk("status %02x\n", inb(STATUS(sh->io_port)));
 	};
 #endif
 	number_serviced = 0;
 
 	while (1 == 1) {
-		flag = inb(INTRFLAGS(shost->io_port));
+		flag = inb(INTRFLAGS(sh->io_port));
 
 		/* Check for unusual interrupts.  If any of these happen, we should
 		   probably do something special, but for now just printing a message
@@ -339,7 +339,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 			if (flag & SCRD)
 				printk("SCRD ");
 		}
-		aha1542_intr_reset(shost->io_port);
+		aha1542_intr_reset(sh->io_port);
 
 		spin_lock_irqsave(&aha1542_lock, flags);
 		mbi = aha1542->aha1542_last_mbi_used + 1;
@@ -447,11 +447,11 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 static irqreturn_t do_aha1542_intr_handle(int dummy, void *dev_id)
 {
 	unsigned long flags;
-	struct Scsi_Host *shost = dev_id;
+	struct Scsi_Host *sh = dev_id;
 
-	spin_lock_irqsave(shost->host_lock, flags);
-	aha1542_intr_handle(shost);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_lock_irqsave(sh->host_lock, flags);
+	aha1542_intr_handle(sh);
+	spin_unlock_irqrestore(sh->host_lock, flags);
 	return IRQ_HANDLED;
 }
 
@@ -605,9 +605,9 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 static DEF_SCSI_QCMD(aha1542_queuecommand)
 
 /* Initialize mailboxes */
-static void setup_mailboxes(int bse, struct Scsi_Host *shpnt)
+static void setup_mailboxes(int bse, struct Scsi_Host *sh)
 {
-	struct aha1542_hostdata *aha1542 = shost_priv(shpnt);
+	struct aha1542_hostdata *aha1542 = shost_priv(sh);
 	int i;
 	struct mailbox *mb = aha1542->mb;
 	struct ccb *ccb = aha1542->ccb;
@@ -817,7 +817,7 @@ fail:
 static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct device *pdev, int indx)
 {
 	unsigned int base_io = io[indx];
-	struct Scsi_Host *shpnt;
+	struct Scsi_Host *sh;
 	struct aha1542_hostdata *aha1542;
 
 	if (base_io == 0)
@@ -826,80 +826,80 @@ static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct
 	if (!request_region(base_io, AHA1542_REGION_SIZE, "aha1542"))
 		return NULL;
 
-	shpnt = scsi_host_alloc(tpnt, sizeof(struct aha1542_hostdata));
-	if (!shpnt)
+	sh = scsi_host_alloc(tpnt, sizeof(struct aha1542_hostdata));
+	if (!sh)
 		goto release;
-	aha1542 = shost_priv(shpnt);
+	aha1542 = shost_priv(sh);
 
-	if (!aha1542_test_port(base_io, shpnt))
+	if (!aha1542_test_port(base_io, sh))
 		goto unregister;
 
 	aha1542_set_bus_times(indx);
 	if (aha1542_query(base_io, &aha1542->bios_translation))
 		goto unregister;
-	if (aha1542_getconfig(base_io, &shpnt->irq, &shpnt->dma_channel, &shpnt->this_id) == -1)
+	if (aha1542_getconfig(base_io, &sh->irq, &sh->dma_channel, &sh->this_id) == -1)
 		goto unregister;
 
-	printk(KERN_INFO "Adaptec AHA-1542 (SCSI-ID %d) at IO 0x%x, IRQ %d", shpnt->this_id, base_io, shpnt->irq);
-	if (shpnt->dma_channel != 0xFF)
-		printk(", DMA %d", shpnt->dma_channel);
+	printk(KERN_INFO "Adaptec AHA-1542 (SCSI-ID %d) at IO 0x%x, IRQ %d", sh->this_id, base_io, sh->irq);
+	if (sh->dma_channel != 0xFF)
+		printk(", DMA %d", sh->dma_channel);
 	printk("\n");
 	if (aha1542->bios_translation == BIOS_TRANSLATION_25563)
 		printk(KERN_INFO "aha1542.c: Using extended bios translation\n");
 
-	setup_mailboxes(base_io, shpnt);
+	setup_mailboxes(base_io, sh);
 
-	if (request_irq(shpnt->irq, do_aha1542_intr_handle, 0,
-					"aha1542", shpnt)) {
+	if (request_irq(sh->irq, do_aha1542_intr_handle, 0,
+					"aha1542", sh)) {
 		printk(KERN_ERR "Unable to allocate IRQ for adaptec controller.\n");
 		goto unregister;
 	}
-	if (shpnt->dma_channel != 0xFF) {
-		if (request_dma(shpnt->dma_channel, "aha1542")) {
+	if (sh->dma_channel != 0xFF) {
+		if (request_dma(sh->dma_channel, "aha1542")) {
 			printk(KERN_ERR "Unable to allocate DMA channel for Adaptec.\n");
 			goto free_irq;
 		}
-		if (shpnt->dma_channel == 0 || shpnt->dma_channel >= 5) {
-			set_dma_mode(shpnt->dma_channel, DMA_MODE_CASCADE);
-			enable_dma(shpnt->dma_channel);
+		if (sh->dma_channel == 0 || sh->dma_channel >= 5) {
+			set_dma_mode(sh->dma_channel, DMA_MODE_CASCADE);
+			enable_dma(sh->dma_channel);
 		}
 	}
 
-	shpnt->unique_id = base_io;
-	shpnt->io_port = base_io;
-	shpnt->n_io_port = AHA1542_REGION_SIZE;
+	sh->unique_id = base_io;
+	sh->io_port = base_io;
+	sh->n_io_port = AHA1542_REGION_SIZE;
 	aha1542->aha1542_last_mbi_used = 2 * AHA1542_MAILBOXES - 1;
 	aha1542->aha1542_last_mbo_used = AHA1542_MAILBOXES - 1;
 
-	if (scsi_add_host(shpnt, pdev))
+	if (scsi_add_host(sh, pdev))
 		goto free_dma;
 
-	scsi_scan_host(shpnt);
+	scsi_scan_host(sh);
 
-	return shpnt;
+	return sh;
 free_dma:
-	if (shpnt->dma_channel != 0xff)
-		free_dma(shpnt->dma_channel);
+	if (sh->dma_channel != 0xff)
+		free_dma(sh->dma_channel);
 free_irq:
-	free_irq(shpnt->irq, shpnt);
+	free_irq(sh->irq, sh);
 unregister:
-	scsi_host_put(shpnt);
+	scsi_host_put(sh);
 release:
 	release_region(base_io, AHA1542_REGION_SIZE);
 
 	return NULL;
 }
 
-static int aha1542_release(struct Scsi_Host *shost)
+static int aha1542_release(struct Scsi_Host *sh)
 {
-	scsi_remove_host(shost);
-	if (shost->dma_channel != 0xff)
-		free_dma(shost->dma_channel);
-	if (shost->irq)
-		free_irq(shost->irq, shost);
-	if (shost->io_port && shost->n_io_port)
-		release_region(shost->io_port, shost->n_io_port);
-	scsi_host_put(shost);
+	scsi_remove_host(sh);
+	if (sh->dma_channel != 0xff)
+		free_dma(sh->dma_channel);
+	if (sh->irq)
+		free_irq(sh->irq, sh);
+	if (sh->io_port && sh->n_io_port)
+		release_region(sh->io_port, sh->n_io_port);
+	scsi_host_put(sh);
 	return 0;
 }
 
-- 
Ondrej Zary

