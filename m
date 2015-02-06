From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 19/36] aha1542: rework hw_init
Date: Fri,  6 Feb 2015 23:11:40 +0100
Message-ID: <1423260717-15944-20-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56976 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758292AbbBFWQU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:16:20 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8G-0006fF-4l
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:12 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Cleanup hw_init, use goto for error handling.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |  139 ++++++++++++++++++++----------------------------
 drivers/scsi/aha1542.h |    1 +
 2 files changed, 59 insertions(+), 81 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 4849d02..8c915d7 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -657,7 +657,7 @@ static void setup_mailboxes(int bse, struct Scsi_Host *shpnt)
 	aha1542_intr_reset(bse);
 }
 
-static int aha1542_getconfig(int base_io, unsigned char *irq_level, unsigned char *dma_chan, unsigned char *scsi_id)
+static int aha1542_getconfig(int base_io, unsigned int *irq_level, unsigned char *dma_chan, unsigned int *scsi_id)
 {
 	u8 inquiry_result[3];
 	int i;
@@ -901,99 +901,76 @@ fail:
 /* return non-zero on detection */
 static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct device *pdev, int indx)
 {
-	unsigned char dma_chan;
-	unsigned char irq_level;
-	unsigned char scsi_id;
-	unsigned long flags;
-	unsigned int base_io;
-	int trans;
-	struct Scsi_Host *shpnt = NULL;
+	unsigned int base_io = bases[indx];
+	struct Scsi_Host *shpnt;
 	struct aha1542_hostdata *aha1542;
 
-	DEB(printk("aha1542_detect: \n"));
-
-	tpnt->proc_name = "aha1542";
-
-		if (bases[indx] != 0 && request_region(bases[indx], 4, "aha1542")) {
-			shpnt = scsi_host_alloc(tpnt,
-					sizeof(struct aha1542_hostdata));
-
-			if(shpnt==NULL) {
-				release_region(bases[indx], 4);
-				return NULL;
-			}
-			aha1542 = shost_priv(shpnt);
-			if (!aha1542_test_port(bases[indx], shpnt))
-				goto unregister;
+	if (base_io == 0)
+		return NULL;
 
-			base_io = bases[indx];
+	if (!request_region(base_io, AHA1542_REGION_SIZE, "aha1542"))
+		return NULL;
 
-			aha1542_set_bus_times(indx);
+	shpnt = scsi_host_alloc(tpnt, sizeof(struct aha1542_hostdata));
+	if (!shpnt)
+		goto release;
+	aha1542 = shost_priv(shpnt);
 
-			if (aha1542_query(base_io, &trans))
-				goto unregister;
+	if (!aha1542_test_port(base_io, shpnt))
+		goto unregister;
 
-			if (aha1542_getconfig(base_io, &irq_level, &dma_chan, &scsi_id) == -1)
-				goto unregister;
+	aha1542_set_bus_times(indx);
+	if (aha1542_query(base_io, &aha1542->bios_translation))
+		goto unregister;
+	if (aha1542_getconfig(base_io, &shpnt->irq, &shpnt->dma_channel, &shpnt->this_id) == -1)
+		goto unregister;
 
-			printk(KERN_INFO "Configuring Adaptec (SCSI-ID %d) at IO:%x, IRQ %d", scsi_id, base_io, irq_level);
-			if (dma_chan != 0xFF)
-				printk(", DMA priority %d", dma_chan);
-			printk("\n");
+	printk(KERN_INFO "Adaptec AHA-1542 (SCSI-ID %d) at IO 0x%x, IRQ %d", shpnt->this_id, base_io, shpnt->irq);
+	if (shpnt->dma_channel != 0xFF)
+		printk(", DMA %d", shpnt->dma_channel);
+	printk("\n");
+	if (aha1542->bios_translation == BIOS_TRANSLATION_25563)
+		printk(KERN_INFO "aha1542.c: Using extended bios translation\n");
 
-			setup_mailboxes(base_io, shpnt);
+	setup_mailboxes(base_io, shpnt);
 
-			DEB(printk("aha1542_detect: enable interrupt channel %d\n", irq_level));
-			spin_lock_irqsave(&aha1542_lock, flags);
-			if (request_irq(irq_level, do_aha1542_intr_handle, 0,
+	if (request_irq(shpnt->irq, do_aha1542_intr_handle, 0,
 					"aha1542", shpnt)) {
-				printk(KERN_ERR "Unable to allocate IRQ for adaptec controller.\n");
-				spin_unlock_irqrestore(&aha1542_lock, flags);
-				goto unregister;
-			}
-			if (dma_chan != 0xFF) {
-				if (request_dma(dma_chan, "aha1542")) {
-					printk(KERN_ERR "Unable to allocate DMA channel for Adaptec.\n");
-					free_irq(irq_level, shpnt);
-					spin_unlock_irqrestore(&aha1542_lock, flags);
-					goto unregister;
-				}
-				if (dma_chan == 0 || dma_chan >= 5) {
-					set_dma_mode(dma_chan, DMA_MODE_CASCADE);
-					enable_dma(dma_chan);
-				}
-			}
+		printk(KERN_ERR "Unable to allocate IRQ for adaptec controller.\n");
+		goto unregister;
+	}
+	if (shpnt->dma_channel != 0xFF) {
+		if (request_dma(shpnt->dma_channel, "aha1542")) {
+			printk(KERN_ERR "Unable to allocate DMA channel for Adaptec.\n");
+			goto free_irq;
+		}
+		if (shpnt->dma_channel == 0 || shpnt->dma_channel >= 5) {
+			set_dma_mode(shpnt->dma_channel, DMA_MODE_CASCADE);
+			enable_dma(shpnt->dma_channel);
+		}
+	}
 
-			shpnt->this_id = scsi_id;
-			shpnt->unique_id = base_io;
-			shpnt->io_port = base_io;
-			shpnt->n_io_port = 4;	/* Number of bytes of I/O space used */
-			shpnt->dma_channel = dma_chan;
-			shpnt->irq = irq_level;
-			aha1542->bios_translation = trans;
-			if (trans == BIOS_TRANSLATION_25563)
-				printk(KERN_INFO "aha1542.c: Using extended bios translation\n");
-			aha1542->aha1542_last_mbi_used = (2 * AHA1542_MAILBOXES - 1);
-			aha1542->aha1542_last_mbo_used = (AHA1542_MAILBOXES - 1);
-			memset(aha1542->SCint, 0, sizeof(aha1542->SCint));
-			spin_unlock_irqrestore(&aha1542_lock, flags);
+	shpnt->unique_id = base_io;
+	shpnt->io_port = base_io;
+	shpnt->n_io_port = AHA1542_REGION_SIZE;
+	aha1542->aha1542_last_mbi_used = 2 * AHA1542_MAILBOXES - 1;
+	aha1542->aha1542_last_mbo_used = AHA1542_MAILBOXES - 1;
 
-			if (scsi_add_host(shpnt, pdev)) {
-				if (shpnt->dma_channel != 0xff)
-					free_dma(shpnt->dma_channel);
-				free_irq(irq_level, shpnt);
-				goto unregister;
-			}
+	if (scsi_add_host(shpnt, pdev))
+		goto free_dma;
 
-			scsi_scan_host(shpnt);
+	scsi_scan_host(shpnt);
 
-			return shpnt;
+	return shpnt;
+free_dma:
+	if (shpnt->dma_channel != 0xff)
+		free_dma(shpnt->dma_channel);
+free_irq:
+	free_irq(shpnt->irq, shpnt);
 unregister:
-			release_region(bases[indx], 4);
-			scsi_host_put(shpnt);
-			return NULL;
-
-		};
+	scsi_host_put(shpnt);
+release:
+	release_region(base_io, AHA1542_REGION_SIZE);
 
 	return NULL;
 }
@@ -1001,10 +978,10 @@ unregister:
 static int aha1542_release(struct Scsi_Host *shost)
 {
 	scsi_remove_host(shost);
-	if (shost->irq)
-		free_irq(shost->irq, shost);
 	if (shost->dma_channel != 0xff)
 		free_dma(shost->dma_channel);
+	if (shost->irq)
+		free_irq(shost->irq, shost);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
 	scsi_host_put(shost);
diff --git a/drivers/scsi/aha1542.h b/drivers/scsi/aha1542.h
index 1333a23..f58792b 100644
--- a/drivers/scsi/aha1542.h
+++ b/drivers/scsi/aha1542.h
@@ -126,6 +126,7 @@ struct ccb {		/* Command Control Block 5.3 */
 					/* REQUEST SENSE */
 };
 
+#define AHA1542_REGION_SIZE 4
 #define AHA1542_MAILBOXES 8
 
 #endif
-- 
Ondrej Zary

