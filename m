From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 28/36] aha1542: Pass struct Scsi_Host * to functions
Date: Fri,  6 Feb 2015 23:11:49 +0100
Message-ID: <1423260717-15944-29-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56965 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758236AbbBFWP6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:15:58 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8H-0006fF-Nf
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:13 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Pass struct Scsi_Host * to functions instead of base address.
This reduces the number of parameters and is also required for printk
conversion.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |  125 ++++++++++++++++++++++++------------------------
 1 file changed, 63 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 16cb6f9..12b90a2 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -217,53 +217,53 @@ static int makecode(unsigned hosterr, unsigned scsierr)
 	return scsierr | (hosterr << 16);
 }
 
-static int aha1542_test_port(int bse, struct Scsi_Host *sh)
+static int aha1542_test_port(struct Scsi_Host *sh)
 {
 	u8 inquiry_result[4];
 	int i;
 
 	/* Quick and dirty test for presence of the card. */
-	if (inb(STATUS(bse)) == 0xff)
+	if (inb(STATUS(sh->io_port)) == 0xff)
 		return 0;
 
 	/* Reset the adapter. I ought to make a hard reset, but it's not really necessary */
 
 	/* In case some other card was probing here, reset interrupts */
-	aha1542_intr_reset(bse);	/* reset interrupts, so they don't block */
+	aha1542_intr_reset(sh->io_port);	/* reset interrupts, so they don't block */
 
-	outb(SRST | IRST /*|SCRST */ , CONTROL(bse));
+	outb(SRST | IRST /*|SCRST */ , CONTROL(sh->io_port));
 
 	mdelay(20);		/* Wait a little bit for things to settle down. */
 
 	/* Expect INIT and IDLE, any of the others are bad */
-	if (!wait_mask(STATUS(bse), STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0))
+	if (!wait_mask(STATUS(sh->io_port), STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0))
 		return 0;
 
 	/* Shouldn't have generated any interrupts during reset */
-	if (inb(INTRFLAGS(bse)) & INTRMASK)
+	if (inb(INTRFLAGS(sh->io_port)) & INTRMASK)
 		return 0;
 
 	/* Perform a host adapter inquiry instead so we do not need to set
 	   up the mailboxes ahead of time */
 
-	aha1542_outb(bse, CMD_INQUIRY);
+	aha1542_outb(sh->io_port, CMD_INQUIRY);
 
 	for (i = 0; i < 4; i++) {
-		if (!wait_mask(STATUS(bse), DF, DF, 0, 0))
+		if (!wait_mask(STATUS(sh->io_port), DF, DF, 0, 0))
 			return 0;
-		inquiry_result[i] = inb(DATA(bse));
+		inquiry_result[i] = inb(DATA(sh->io_port));
 	}
 
 	/* Reading port should reset DF */
-	if (inb(STATUS(bse)) & DF)
+	if (inb(STATUS(sh->io_port)) & DF)
 		return 0;
 
 	/* When HACC, command is completed, and we're though testing */
-	if (!wait_mask(INTRFLAGS(bse), HACC, HACC, 0, 0))
+	if (!wait_mask(INTRFLAGS(sh->io_port), HACC, HACC, 0, 0))
 		return 0;
 
 	/* Clear interrupts */
-	outb(IRST, CONTROL(bse));
+	outb(IRST, CONTROL(sh->io_port));
 
 	return 1;
 }
@@ -581,7 +581,7 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 static DEF_SCSI_QCMD(aha1542_queuecommand)
 
 /* Initialize mailboxes */
-static void setup_mailboxes(int bse, struct Scsi_Host *sh)
+static void setup_mailboxes(struct Scsi_Host *sh)
 {
 	struct aha1542_hostdata *aha1542 = shost_priv(sh);
 	int i;
@@ -594,43 +594,43 @@ static void setup_mailboxes(int bse, struct Scsi_Host *sh)
 		mb[i].status = mb[AHA1542_MAILBOXES + i].status = 0;
 		any2scsi(mb[i].ccbptr, isa_virt_to_bus(&ccb[i]));
 	};
-	aha1542_intr_reset(bse);	/* reset interrupts, so they don't block */
+	aha1542_intr_reset(sh->io_port);	/* reset interrupts, so they don't block */
 	any2scsi((mb_cmd + 2), isa_virt_to_bus(mb));
-	if (aha1542_out(bse, mb_cmd, 5))
+	if (aha1542_out(sh->io_port, mb_cmd, 5))
 		printk(KERN_ERR "aha1542_detect: failed setting up mailboxes\n");
-	aha1542_intr_reset(bse);
+	aha1542_intr_reset(sh->io_port);
 }
 
-static int aha1542_getconfig(int base_io, unsigned int *irq_level, unsigned char *dma_chan, unsigned int *scsi_id)
+static int aha1542_getconfig(struct Scsi_Host *sh)
 {
 	u8 inquiry_result[3];
 	int i;
-	i = inb(STATUS(base_io));
+	i = inb(STATUS(sh->io_port));
 	if (i & DF) {
-		i = inb(DATA(base_io));
+		i = inb(DATA(sh->io_port));
 	};
-	aha1542_outb(base_io, CMD_RETCONF);
-	aha1542_in(base_io, inquiry_result, 3, 0);
-	if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
+	aha1542_outb(sh->io_port, CMD_RETCONF);
+	aha1542_in(sh->io_port, inquiry_result, 3, 0);
+	if (!wait_mask(INTRFLAGS(sh->io_port), INTRMASK, HACC, 0, 0))
 		printk(KERN_ERR "aha1542_detect: query board settings\n");
-	aha1542_intr_reset(base_io);
+	aha1542_intr_reset(sh->io_port);
 	switch (inquiry_result[0]) {
 	case 0x80:
-		*dma_chan = 7;
+		sh->dma_channel = 7;
 		break;
 	case 0x40:
-		*dma_chan = 6;
+		sh->dma_channel = 6;
 		break;
 	case 0x20:
-		*dma_chan = 5;
+		sh->dma_channel = 5;
 		break;
 	case 0x01:
-		*dma_chan = 0;
+		sh->dma_channel = 0;
 		break;
 	case 0:
 		/* This means that the adapter, although Adaptec 1542 compatible, doesn't use a DMA channel.
 		   Currently only aware of the BusLogic BT-445S VL-Bus adapter which needs this. */
-		*dma_chan = 0xFF;
+		sh->dma_channel = 0xFF;
 		break;
 	default:
 		printk(KERN_ERR "Unable to determine Adaptec DMA priority.  Disabling board\n");
@@ -638,35 +638,35 @@ static int aha1542_getconfig(int base_io, unsigned int *irq_level, unsigned char
 	};
 	switch (inquiry_result[1]) {
 	case 0x40:
-		*irq_level = 15;
+		sh->irq = 15;
 		break;
 	case 0x20:
-		*irq_level = 14;
+		sh->irq = 14;
 		break;
 	case 0x8:
-		*irq_level = 12;
+		sh->irq = 12;
 		break;
 	case 0x4:
-		*irq_level = 11;
+		sh->irq = 11;
 		break;
 	case 0x2:
-		*irq_level = 10;
+		sh->irq = 10;
 		break;
 	case 0x1:
-		*irq_level = 9;
+		sh->irq = 9;
 		break;
 	default:
 		printk(KERN_ERR "Unable to determine Adaptec IRQ level.  Disabling board\n");
 		return -1;
 	};
-	*scsi_id = inquiry_result[2] & 7;
+	sh->this_id = inquiry_result[2] & 7;
 	return 0;
 }
 
 /* This function should only be called for 1542C boards - we can detect
    the special firmware settings and unlock the board */
 
-static int aha1542_mbenable(int base)
+static int aha1542_mbenable(struct Scsi_Host *sh)
 {
 	static u8 mbenable_cmd[3];
 	static u8 mbenable_result[2];
@@ -674,12 +674,12 @@ static int aha1542_mbenable(int base)
 
 	retval = BIOS_TRANSLATION_6432;
 
-	aha1542_outb(base, CMD_EXTBIOS);
-	if (aha1542_in(base, mbenable_result, 2, 100))
+	aha1542_outb(sh->io_port, CMD_EXTBIOS);
+	if (aha1542_in(sh->io_port, mbenable_result, 2, 100))
 		return retval;
-	if (!wait_mask(INTRFLAGS(base), INTRMASK, HACC, 0, 100))
+	if (!wait_mask(INTRFLAGS(sh->io_port), INTRMASK, HACC, 0, 100))
 		goto fail;
-	aha1542_intr_reset(base);
+	aha1542_intr_reset(sh->io_port);
 
 	if ((mbenable_result[0] & 0x08) || mbenable_result[1]) {
 		mbenable_cmd[0] = CMD_MBENABLE;
@@ -689,33 +689,34 @@ static int aha1542_mbenable(int base)
 		if ((mbenable_result[0] & 0x08) && (mbenable_result[1] & 0x03))
 			retval = BIOS_TRANSLATION_25563;
 
-		if (aha1542_out(base, mbenable_cmd, 3))
+		if (aha1542_out(sh->io_port, mbenable_cmd, 3))
 			goto fail;
 	};
 	while (0) {
 fail:
 		printk(KERN_ERR "aha1542_mbenable: Mailbox init failed\n");
 	}
-	aha1542_intr_reset(base);
+	aha1542_intr_reset(sh->io_port);
 	return retval;
 }
 
 /* Query the board to find out if it is a 1542 or a 1740, or whatever. */
-static int aha1542_query(int base_io, int *transl)
+static int aha1542_query(struct Scsi_Host *sh)
 {
+	struct aha1542_hostdata *aha1542 = shost_priv(sh);
 	u8 inquiry_result[4];
 	int i;
-	i = inb(STATUS(base_io));
+	i = inb(STATUS(sh->io_port));
 	if (i & DF) {
-		i = inb(DATA(base_io));
+		i = inb(DATA(sh->io_port));
 	};
-	aha1542_outb(base_io, CMD_INQUIRY);
-	aha1542_in(base_io, inquiry_result, 4, 0);
-	if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
+	aha1542_outb(sh->io_port, CMD_INQUIRY);
+	aha1542_in(sh->io_port, inquiry_result, 4, 0);
+	if (!wait_mask(INTRFLAGS(sh->io_port), INTRMASK, HACC, 0, 0))
 		printk(KERN_ERR "aha1542_detect: query card type\n");
-	aha1542_intr_reset(base_io);
+	aha1542_intr_reset(sh->io_port);
 
-	*transl = BIOS_TRANSLATION_6432;	/* Default case */
+	aha1542->bios_translation = BIOS_TRANSLATION_6432;	/* Default case */
 
 	/* For an AHA1740 series board, we ignore the board since there is a
 	   hardware bug which can lead to wrong blocks being returned if the board
@@ -731,7 +732,7 @@ static int aha1542_query(int base_io, int *transl)
 	/* Always call this - boards that do not support extended bios translation
 	   will ignore the command, and we will set the proper default */
 
-	*transl = aha1542_mbenable(base_io);
+	aha1542->bios_translation = aha1542_mbenable(sh);
 
 	return 0;
 }
@@ -807,13 +808,19 @@ static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct
 		goto release;
 	aha1542 = shost_priv(sh);
 
-	if (!aha1542_test_port(base_io, sh))
+	sh->unique_id = base_io;
+	sh->io_port = base_io;
+	sh->n_io_port = AHA1542_REGION_SIZE;
+	aha1542->aha1542_last_mbi_used = 2 * AHA1542_MAILBOXES - 1;
+	aha1542->aha1542_last_mbo_used = AHA1542_MAILBOXES - 1;
+
+	if (!aha1542_test_port(sh))
 		goto unregister;
 
 	aha1542_set_bus_times(indx);
-	if (aha1542_query(base_io, &aha1542->bios_translation))
+	if (aha1542_query(sh))
 		goto unregister;
-	if (aha1542_getconfig(base_io, &sh->irq, &sh->dma_channel, &sh->this_id) == -1)
+	if (aha1542_getconfig(sh) == -1)
 		goto unregister;
 
 	printk(KERN_INFO "Adaptec AHA-1542 (SCSI-ID %d) at IO 0x%x, IRQ %d", sh->this_id, base_io, sh->irq);
@@ -823,7 +830,7 @@ static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct
 	if (aha1542->bios_translation == BIOS_TRANSLATION_25563)
 		printk(KERN_INFO "aha1542.c: Using extended bios translation\n");
 
-	setup_mailboxes(base_io, sh);
+	setup_mailboxes(sh);
 
 	if (request_irq(sh->irq, do_aha1542_intr_handle, 0,
 					"aha1542", sh)) {
@@ -841,12 +848,6 @@ static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct
 		}
 	}
 
-	sh->unique_id = base_io;
-	sh->io_port = base_io;
-	sh->n_io_port = AHA1542_REGION_SIZE;
-	aha1542->aha1542_last_mbi_used = 2 * AHA1542_MAILBOXES - 1;
-	aha1542->aha1542_last_mbo_used = AHA1542_MAILBOXES - 1;
-
 	if (scsi_add_host(sh, pdev))
 		goto free_dma;
 
@@ -973,7 +974,7 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 	 * us again after host reset.
 	 */
 	if (reset_cmd & HRST)
-		setup_mailboxes(cmd->device->host->io_port, cmd->device->host);
+		setup_mailboxes(cmd->device->host);
 	/*
 	 * Now try to pick up the pieces.  For all pending commands,
 	 * free any internal data structures, and basically clear things
-- 
Ondrej Zary

