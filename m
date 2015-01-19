From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 13/13] aha1542: Remove unneeded gotos
Date: Mon, 19 Jan 2015 23:37:57 +0100
Message-ID: <1421707077-25291-14-git-send-email-linux@rainbow-software.org>
References: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:44275 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbbASWnY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2015 17:43:24 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YDKxW-0006A4-DM
	for linux-scsi@vger.kernel.org; Mon, 19 Jan 2015 23:38:10 +0100
In-Reply-To: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove gotos that are no longer needed.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   58 ++++++++++++++++--------------------------------
 1 file changed, 19 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 7bf4604..af2c69e 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -198,17 +198,16 @@ static int aha1542_in(unsigned int base, u8 *cmdp, int len, int timeout)
 
 	spin_lock_irqsave(&aha1542_lock, flags);
 	while (len--) {
-		if (!wait_mask(STATUS(base), DF, DF, 0, timeout))
-			goto fail;
+		if (!wait_mask(STATUS(base), DF, DF, 0, timeout)) {
+			spin_unlock_irqrestore(&aha1542_lock, flags);
+			if (timeout == 0)
+				printk(KERN_ERR "aha1542_in failed(%d): ", len + 1);
+			return 1;
+		}
 		*cmdp++ = inb(DATA(base));
 	}
 	spin_unlock_irqrestore(&aha1542_lock, flags);
 	return 0;
-fail:
-	spin_unlock_irqrestore(&aha1542_lock, flags);
-	if (timeout == 0)
-		printk(KERN_ERR "aha1542_in failed(%d): ", len + 1);
-	return 1;
 }
 
 static int makecode(unsigned hosterr, unsigned scsierr)
@@ -292,12 +291,12 @@ static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 	debug = 1;
 	/* Expect INIT and IDLE, any of the others are bad */
 	if (!wait_mask(STATUS(bse), STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0))
-		goto fail;
+		return 0;
 
 	debug = 2;
 	/* Shouldn't have generated any interrupts during reset */
 	if (inb(INTRFLAGS(bse)) & INTRMASK)
-		goto fail;
+		return 0;
 
 
 	/* Perform a host adapter inquiry instead so we do not need to set
@@ -311,19 +310,19 @@ static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 
 	while (len--) {
 		if (!wait_mask(STATUS(bse), DF, DF, 0, 0))
-			goto fail;
+			return 0;
 		*cmdp++ = inb(DATA(bse));
 	}
 
 	debug = 8;
 	/* Reading port should reset DF */
 	if (inb(STATUS(bse)) & DF)
-		goto fail;
+		return 0;
 
 	debug = 9;
 	/* When HACC, command is completed, and we're though testing */
 	if (!wait_mask(INTRFLAGS(bse), HACC, HACC, 0, 0))
-		goto fail;
+		return 0;
 	/* now initialize adapter */
 
 	debug = 10;
@@ -333,8 +332,6 @@ static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 	debug = 11;
 
 	return debug;		/* 1 = ok */
-fail:
-	return 0;		/* 0 = not ok */
 }
 
 static int aha1542_restart(struct Scsi_Host *shost)
@@ -692,11 +689,7 @@ static void setup_mailboxes(int bse, struct Scsi_Host *shpnt)
 	any2scsi((cmd + 2), isa_virt_to_bus(mb));
 	aha1542_out(bse, cmd, 5);
 	if (!wait_mask(INTRFLAGS(bse), INTRMASK, HACC, 0, 0))
-		goto fail;
-	while (0) {
-fail:
 		printk(KERN_ERR "aha1542_detect: failed setting up mailboxes\n");
-	}
 	aha1542_intr_reset(bse);
 }
 
@@ -711,11 +704,7 @@ static int aha1542_getconfig(int base_io, unsigned char *irq_level, unsigned cha
 	aha1542_outb(base_io, CMD_RETCONF);
 	aha1542_in(base_io, inquiry_result, 3, 0);
 	if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
-		goto fail;
-	while (0) {
-fail:
 		printk(KERN_ERR "aha1542_detect: query board settings\n");
-	}
 	aha1542_intr_reset(base_io);
 	switch (inquiry_result[0]) {
 	case 0x80:
@@ -816,11 +805,7 @@ static int aha1542_query(int base_io, int *transl)
 	aha1542_outb(base_io, CMD_INQUIRY);
 	aha1542_in(base_io, inquiry_result, 4, 0);
 	if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
-		goto fail;
-	while (0) {
-fail:
 		printk(KERN_ERR "aha1542_detect: query card type\n");
-	}
 	aha1542_intr_reset(base_io);
 
 	*transl = BIOS_TRANSLATION_6432;	/* Default case */
@@ -1147,8 +1132,10 @@ static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
 	spin_lock_irq(SCpnt->device->host->host_lock);
 
 	if (!wait_mask(STATUS(SCpnt->device->host->io_port),
-	     STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0))
-		goto fail;
+	     STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0)) {
+		spin_unlock_irq(SCpnt->device->host->host_lock);
+		return FAILED;
+	}
 
 	/*
 	 * Now try to pick up the pieces.  For all pending commands,
@@ -1182,10 +1169,6 @@ static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
 
 	spin_unlock_irq(SCpnt->device->host->host_lock);
 	return SUCCESS;
-
-fail:
-	spin_unlock_irq(SCpnt->device->host->host_lock);
-	return FAILED;
 }
 
 static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
@@ -1212,9 +1195,10 @@ static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
 	spin_lock_irq(SCpnt->device->host->host_lock);
 
 	if (!wait_mask(STATUS(SCpnt->device->host->io_port),
-	     STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0))
-		goto fail;
-
+	     STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0)) {
+		spin_unlock_irq(SCpnt->device->host->host_lock);
+		return FAILED;
+	}
 	/*
 	 * We need to do this too before the 1542 can interact with
 	 * us again.
@@ -1252,10 +1236,6 @@ static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
 
 	spin_unlock_irq(SCpnt->device->host->host_lock);
 	return SUCCESS;
-
-fail:
-	spin_unlock_irq(SCpnt->device->host->host_lock);
-	return FAILED;
 }
 
 static int aha1542_biosparam(struct scsi_device *sdev,
-- 
Ondrej Zary

