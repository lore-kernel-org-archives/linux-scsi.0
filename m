From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 30/36] aha1542: Use shost_printk instead of printk
Date: Fri,  6 Feb 2015 23:11:51 +0100
Message-ID: <1423260717-15944-31-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56971 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386AbbBFWQJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:16:09 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8I-0006fF-6l
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:14 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   67 +++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 6e44a7f..d607f59 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -105,10 +105,8 @@ static int aha1542_outb(unsigned int base, u8 val)
 	unsigned long flags;
 
 	while (1) {
-		if (!wait_mask(STATUS(base), CDF, 0, CDF, 0)) {
-			printk(KERN_ERR "aha1542_outb failed");
+		if (!wait_mask(STATUS(base), CDF, 0, CDF, 0))
 			return 1;
-		}
 		spin_lock_irqsave(&aha1542_lock, flags);
 		if (inb(STATUS(base)) & CDF) {
 			spin_unlock_irqrestore(&aha1542_lock, flags);
@@ -128,7 +126,6 @@ static int aha1542_out(unsigned int base, u8 *buf, int len)
 	while (len--) {
 		if (!wait_mask(STATUS(base), CDF, 0, CDF, 0)) {
 			spin_unlock_irqrestore(&aha1542_lock, flags);
-			printk(KERN_ERR "aha1542_out failed(%d): ", len + 1);
 			return 1;
 		}
 		outb(*buf++, DATA(base));
@@ -151,8 +148,6 @@ static int aha1542_in(unsigned int base, u8 *buf, int len, int timeout)
 	while (len--) {
 		if (!wait_mask(STATUS(base), DF, DF, 0, timeout)) {
 			spin_unlock_irqrestore(&aha1542_lock, flags);
-			if (timeout == 0)
-				printk(KERN_ERR "aha1542_in failed(%d): ", len + 1);
 			return 1;
 		}
 		*buf++ = inb(DATA(base));
@@ -284,7 +279,7 @@ static void aha1542_intr_handle(struct Scsi_Host *sh)
 #ifdef DEBUG
 	{
 		flag = inb(INTRFLAGS(sh->io_port));
-		printk(KERN_DEBUG "aha1542_intr_handle: ");
+		shost_printk(KERN_DEBUG, sh, "aha1542_intr_handle: ");
 		if (!(flag & ANYINTR))
 			printk("no interrupt?");
 		if (flag & MBIF)
@@ -334,7 +329,7 @@ static void aha1542_intr_handle(struct Scsi_Host *sh)
 			spin_unlock_irqrestore(&aha1542_lock, flags);
 			/* Hmm, no mail.  Must have read it the last time around */
 			if (!number_serviced)
-				printk(KERN_WARNING "aha1542.c: interrupt received, but no mail.\n");
+				shost_printk(KERN_WARNING, sh, "interrupt received, but no mail.\n");
 			return;
 		};
 
@@ -347,7 +342,7 @@ static void aha1542_intr_handle(struct Scsi_Host *sh)
 #ifdef DEBUG
 		{
 			if (ccb[mbo].tarstat | ccb[mbo].hastat)
-				printk(KERN_DEBUG "aha1542_command: returning %x (status %d)\n",
+				shost_printk(KERN_DEBUG, sh, "aha1542_command: returning %x (status %d)\n",
 				       ccb[mbo].tarstat + ((int) ccb[mbo].hastat << 16), mb[mbi].status);
 		};
 #endif
@@ -356,14 +351,14 @@ static void aha1542_intr_handle(struct Scsi_Host *sh)
 			continue;	/* Aborted command not found */
 
 #ifdef DEBUG
-		printk(KERN_DEBUG "...done %d %d\n", mbo, mbi);
+		shost_printk(KERN_DEBUG, sh, "...done %d %d\n", mbo, mbi);
 #endif
 
 		tmp_cmd = aha1542->int_cmds[mbo];
 
 		if (!tmp_cmd || !tmp_cmd->scsi_done) {
-			printk(KERN_WARNING "aha1542_intr_handle: Unexpected interrupt\n");
-			printk(KERN_WARNING "tarstat=%x, hastat=%x idlun=%x ccb#=%d \n", ccb[mbo].tarstat,
+			shost_printk(KERN_WARNING, sh, "Unexpected interrupt\n");
+			shost_printk(KERN_WARNING, sh, "tarstat=%x, hastat=%x idlun=%x ccb#=%d\n", ccb[mbo].tarstat,
 			       ccb[mbo].hastat, ccb[mbo].idlun, mbo);
 			return;
 		}
@@ -389,7 +384,7 @@ static void aha1542_intr_handle(struct Scsi_Host *sh)
 
 #ifdef DEBUG
 		if (errstatus)
-			printk(KERN_DEBUG "(aha1542 error:%x %x %x) ", errstatus,
+			shost_printk(KERN_DEBUG, sh, "(aha1542 error:%x %x %x) ", errstatus,
 			       ccb[mbo].hastat, ccb[mbo].tarstat);
 #endif
 
@@ -433,7 +428,8 @@ static irqreturn_t do_aha1542_intr_handle(int dummy, void *dev_id)
 
 static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct scsi_cmnd *))
 {
-	struct aha1542_hostdata *aha1542 = shost_priv(cmd->device->host);
+	struct Scsi_Host *sh = cmd->device->host;
+	struct aha1542_hostdata *aha1542 = shost_priv(sh);
 	u8 direction;
 	u8 target = cmd->device->id;
 	u8 lun = cmd->device->lun;
@@ -465,10 +461,10 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 	else
 		i = -1;
 	if (done)
-		printk(KERN_DEBUG "aha1542_queuecommand: dev %d cmd %02x pos %d len %d ", target, *cmd->cmnd, i, bufflen);
+		shost_printk(KERN_DEBUG, sh, "aha1542_queuecommand: dev %d cmd %02x pos %d len %d ", target, *cmd->cmnd, i, bufflen);
 	else
-		printk(KERN_DEBUG "aha1542_command: dev %d cmd %02x pos %d len %d ", target, *cmd->cmnd, i, bufflen);
-	printk(KERN_DEBUG "aha1542_queuecommand: dumping scsi cmd:");
+		shost_printk(KERN_DEBUG, sh, "aha1542_command: dev %d cmd %02x pos %d len %d ", target, *cmd->cmnd, i, bufflen);
+	shost_printk(KERN_DEBUG, sh, "aha1542_queuecommand: dumping scsi cmd:");
 	for (i = 0; i < cmd->cmd_len; i++)
 		printk("%02x ", cmd->cmnd[i]);
 	printk("\n");
@@ -501,7 +497,7 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 	spin_unlock_irqrestore(&aha1542_lock, flags);
 
 #ifdef DEBUG
-	printk(KERN_DEBUG "Sending command (%d %x)...", mbo, done);
+	shost_printk(KERN_DEBUG, sh, "Sending command (%d %x)...", mbo, done);
 #endif
 
 	any2scsi(mb[mbo].ccbptr, isa_virt_to_bus(&ccb[mbo]));	/* This gets trashed for some reason */
@@ -561,7 +557,7 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 #ifdef DEBUG
 	{
 		int i;
-		printk(KERN_DEBUG "aha1542_command: sending.. ");
+		shost_printk(KERN_DEBUG, sh, "aha1542_command: sending.. ");
 		for (i = 0; i < sizeof(ccb[mbo]) - 10; i++)
 			printk("%02x ", ((u8 *) &ccb[mbo])[i]);
 	};
@@ -597,7 +593,7 @@ static void setup_mailboxes(struct Scsi_Host *sh)
 	aha1542_intr_reset(sh->io_port);	/* reset interrupts, so they don't block */
 	any2scsi((mb_cmd + 2), isa_virt_to_bus(mb));
 	if (aha1542_out(sh->io_port, mb_cmd, 5))
-		printk(KERN_ERR "aha1542_detect: failed setting up mailboxes\n");
+		shost_printk(KERN_ERR, sh, "failed setting up mailboxes\n");
 	aha1542_intr_reset(sh->io_port);
 }
 
@@ -612,7 +608,7 @@ static int aha1542_getconfig(struct Scsi_Host *sh)
 	aha1542_outb(sh->io_port, CMD_RETCONF);
 	aha1542_in(sh->io_port, inquiry_result, 3, 0);
 	if (!wait_mask(INTRFLAGS(sh->io_port), INTRMASK, HACC, 0, 0))
-		printk(KERN_ERR "aha1542_detect: query board settings\n");
+		shost_printk(KERN_ERR, sh, "error querying board settings\n");
 	aha1542_intr_reset(sh->io_port);
 	switch (inquiry_result[0]) {
 	case 0x80:
@@ -633,7 +629,7 @@ static int aha1542_getconfig(struct Scsi_Host *sh)
 		sh->dma_channel = 0xFF;
 		break;
 	default:
-		printk(KERN_ERR "Unable to determine Adaptec DMA priority.  Disabling board\n");
+		shost_printk(KERN_ERR, sh, "Unable to determine DMA channel.\n");
 		return -1;
 	};
 	switch (inquiry_result[1]) {
@@ -656,7 +652,7 @@ static int aha1542_getconfig(struct Scsi_Host *sh)
 		sh->irq = 9;
 		break;
 	default:
-		printk(KERN_ERR "Unable to determine Adaptec IRQ level.  Disabling board\n");
+		shost_printk(KERN_ERR, sh, "Unable to determine IRQ level.\n");
 		return -1;
 	};
 	sh->this_id = inquiry_result[2] & 7;
@@ -694,7 +690,7 @@ static int aha1542_mbenable(struct Scsi_Host *sh)
 	};
 	while (0) {
 fail:
-		printk(KERN_ERR "aha1542_mbenable: Mailbox init failed\n");
+		shost_printk(KERN_ERR, sh, "Mailbox init failed\n");
 	}
 	aha1542_intr_reset(sh->io_port);
 	return retval;
@@ -713,7 +709,7 @@ static int aha1542_query(struct Scsi_Host *sh)
 	aha1542_outb(sh->io_port, CMD_INQUIRY);
 	aha1542_in(sh->io_port, inquiry_result, 4, 0);
 	if (!wait_mask(INTRFLAGS(sh->io_port), INTRMASK, HACC, 0, 0))
-		printk(KERN_ERR "aha1542_detect: query card type\n");
+		shost_printk(KERN_ERR, sh, "error querying card type\n");
 	aha1542_intr_reset(sh->io_port);
 
 	aha1542->bios_translation = BIOS_TRANSLATION_6432;	/* Default case */
@@ -725,7 +721,7 @@ static int aha1542_query(struct Scsi_Host *sh)
 	 */
 
 	if (inquiry_result[0] == 0x43) {
-		printk(KERN_INFO "aha1542.c: Emulation mode not supported for AHA 174N hardware.\n");
+		shost_printk(KERN_INFO, sh, "Emulation mode not supported for AHA-1740 hardware, use aha1740 driver instead.\n");
 		return 1;
 	};
 
@@ -784,7 +780,7 @@ static void aha1542_set_bus_times(struct Scsi_Host *sh, int bus_on, int bus_off,
 	aha1542_intr_reset(sh->io_port);
 	return;
 fail:
-	printk(KERN_ERR "setting bus on/off-time failed\n");
+	shost_printk(KERN_ERR, sh, "setting bus on/off-time failed\n");
 	aha1542_intr_reset(sh->io_port);
 }
 
@@ -794,6 +790,7 @@ static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct
 	unsigned int base_io = io[indx];
 	struct Scsi_Host *sh;
 	struct aha1542_hostdata *aha1542;
+	char dma_info[] = "no DMA";
 
 	if (base_io == 0)
 		return NULL;
@@ -821,23 +818,23 @@ static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct
 	if (aha1542_getconfig(sh) == -1)
 		goto unregister;
 
-	printk(KERN_INFO "Adaptec AHA-1542 (SCSI-ID %d) at IO 0x%x, IRQ %d", sh->this_id, base_io, sh->irq);
 	if (sh->dma_channel != 0xFF)
-		printk(", DMA %d", sh->dma_channel);
-	printk("\n");
+		snprintf(dma_info, sizeof(dma_info), "DMA %d", sh->dma_channel);
+	shost_printk(KERN_INFO, sh, "Adaptec AHA-1542 (SCSI-ID %d) at IO 0x%x, IRQ %d, %s\n",
+				sh->this_id, base_io, sh->irq, dma_info);
 	if (aha1542->bios_translation == BIOS_TRANSLATION_25563)
-		printk(KERN_INFO "aha1542.c: Using extended bios translation\n");
+		shost_printk(KERN_INFO, sh, "Using extended bios translation\n");
 
 	setup_mailboxes(sh);
 
 	if (request_irq(sh->irq, do_aha1542_intr_handle, 0,
 					"aha1542", sh)) {
-		printk(KERN_ERR "Unable to allocate IRQ for adaptec controller.\n");
+		shost_printk(KERN_ERR, sh, "Unable to allocate IRQ.\n");
 		goto unregister;
 	}
 	if (sh->dma_channel != 0xFF) {
 		if (request_dma(sh->dma_channel, "aha1542")) {
-			printk(KERN_ERR "Unable to allocate DMA channel for Adaptec.\n");
+			shost_printk(KERN_ERR, sh, "Unable to allocate DMA channel.\n");
 			goto free_irq;
 		}
 		if (sh->dma_channel == 0 || sh->dma_channel >= 5) {
@@ -979,7 +976,7 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 	 * out.  We do not try and restart any commands or anything - 
 	 * the strategy handler takes care of that crap.
 	 */
-	printk(KERN_WARNING "Sent BUS RESET to scsi host %d\n", cmd->device->host->host_no);
+	shost_printk(KERN_WARNING, cmd->device->host, "Sent BUS RESET to scsi host %d\n", cmd->device->host->host_no);
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		if (aha1542->int_cmds[i] != NULL) {
@@ -1105,7 +1102,7 @@ static int aha1542_pnp_probe(struct pnp_dev *pdev, const struct pnp_device_id *i
 		/* The card can be queried for its DMA, we have
 		   the DMA set up that is enough */
 
-		printk(KERN_INFO "ISAPnP found an AHA1535 at I/O 0x%03X\n", io[indx]);
+		dev_info(&pdev->dev, "ISAPnP found an AHA1535 at I/O 0x%03X", io[indx]);
 	}
 
 	sh = aha1542_hw_init(&driver_template, &pdev->dev, indx);
-- 
Ondrej Zary

