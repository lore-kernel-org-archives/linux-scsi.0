From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 22/36] aha1542: clean up cmd variables
Date: Fri,  6 Feb 2015 23:11:43 +0100
Message-ID: <1423260717-15944-23-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56978 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758340AbbBFWQ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:16:26 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8G-0006fF-Io
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:12 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Make sure that there's no variable named cmd

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   53 ++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 1615865..dbe4659 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -124,7 +124,7 @@ static inline bool wait_mask(u16 port, u8 mask, u8 allof, u8 noneof, int timeout
    routine does not send something out while we are in the middle of this.
    Fortunately, it is only at boot time that multi-byte messages
    are ever sent. */
-static int aha1542_outb(unsigned int base, u8 cmd)
+static int aha1542_outb(unsigned int base, u8 val)
 {
 	unsigned long flags;
 
@@ -138,13 +138,13 @@ static int aha1542_outb(unsigned int base, u8 cmd)
 			spin_unlock_irqrestore(&aha1542_lock, flags);
 			continue;
 		}
-		outb(cmd, DATA(base));
+		outb(val, DATA(base));
 		spin_unlock_irqrestore(&aha1542_lock, flags);
 		return 0;
 	}
 }
 
-static int aha1542_out(unsigned int base, u8 *cmdp, int len)
+static int aha1542_out(unsigned int base, u8 *buf, int len)
 {
 	unsigned long flags;
 
@@ -155,7 +155,7 @@ static int aha1542_out(unsigned int base, u8 *cmdp, int len)
 			printk(KERN_ERR "aha1542_out failed(%d): ", len + 1);
 			return 1;
 		}
-		outb(*cmdp++, DATA(base));
+		outb(*buf++, DATA(base));
 	}
 	spin_unlock_irqrestore(&aha1542_lock, flags);
 	if (!wait_mask(INTRFLAGS(base), INTRMASK, HACC, 0, 0))
@@ -167,7 +167,7 @@ static int aha1542_out(unsigned int base, u8 *cmdp, int len)
 /* Only used at boot time, so we do not need to worry about latency as much
    here */
 
-static int aha1542_in(unsigned int base, u8 *cmdp, int len, int timeout)
+static int aha1542_in(unsigned int base, u8 *buf, int len, int timeout)
 {
 	unsigned long flags;
 
@@ -179,7 +179,7 @@ static int aha1542_in(unsigned int base, u8 *cmdp, int len, int timeout)
 				printk(KERN_ERR "aha1542_in failed(%d): ", len + 1);
 			return 1;
 		}
-		*cmdp++ = inb(DATA(base));
+		*buf++ = inb(DATA(base));
 	}
 	spin_unlock_irqrestore(&aha1542_lock, flags);
 	return 0;
@@ -244,8 +244,7 @@ static int makecode(unsigned hosterr, unsigned scsierr)
 static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 {
 	u8 inquiry_result[4];
-	u8 *cmdp;
-	int len;
+	int i;
 
 	/* Quick and dirty test for presence of the card. */
 	if (inb(STATUS(bse)) == 0xff)
@@ -273,13 +272,10 @@ static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 
 	aha1542_outb(bse, CMD_INQUIRY);
 
-	len = 4;
-	cmdp = &inquiry_result[0];
-
-	while (len--) {
+	for (i = 0; i < 4; i++) {
 		if (!wait_mask(STATUS(bse), DF, DF, 0, 0))
 			return 0;
-		*cmdp++ = inb(DATA(bse));
+		inquiry_result[i] = inb(DATA(bse));
 	}
 
 	/* Reading port should reset DF */
@@ -463,7 +459,6 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 {
 	struct aha1542_hostdata *aha1542 = shost_priv(SCpnt->device->host);
 	u8 direction;
-	u8 *cmd = (u8 *) SCpnt->cmnd;
 	u8 target = SCpnt->device->id;
 	u8 lun = SCpnt->device->lun;
 	unsigned long flags;
@@ -480,28 +475,28 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 	    }
 	);
 
-	if (*cmd == REQUEST_SENSE) {
+	if (*SCpnt->cmnd == REQUEST_SENSE) {
 		/* Don't do the command - we have the sense data already */
 		SCpnt->result = 0;
 		done(SCpnt);
 		return 0;
 	}
 #ifdef DEBUG
-	if (*cmd == READ_10 || *cmd == WRITE_10)
-		i = xscsi2int(cmd + 2);
-	else if (*cmd == READ_6 || *cmd == WRITE_6)
-		i = scsi2int(cmd + 2);
+	if (*SCpnt->cmnd == READ_10 || *SCpnt->cmnd == WRITE_10)
+		i = xscsi2int(SCpnt->cmnd + 2);
+	else if (*SCpnt->cmnd == READ_6 || *SCpnt->cmnd == WRITE_6)
+		i = scsi2int(SCpnt->cmnd + 2);
 	else
 		i = -1;
 	if (done)
-		printk(KERN_DEBUG "aha1542_queuecommand: dev %d cmd %02x pos %d len %d ", target, *cmd, i, bufflen);
+		printk(KERN_DEBUG "aha1542_queuecommand: dev %d cmd %02x pos %d len %d ", target, *SCpnt->cmnd, i, bufflen);
 	else
-		printk(KERN_DEBUG "aha1542_command: dev %d cmd %02x pos %d len %d ", target, *cmd, i, bufflen);
+		printk(KERN_DEBUG "aha1542_command: dev %d cmd %02x pos %d len %d ", target, *SCpnt->cmnd, i, bufflen);
 	printk(KERN_DEBUG "aha1542_queuecommand: dumping scsi cmd:");
 	for (i = 0; i < SCpnt->cmd_len; i++)
-		printk("%02x ", cmd[i]);
+		printk("%02x ", SCpnt->cmnd[i]);
 	printk("\n");
-	if (*cmd == WRITE_10 || *cmd == WRITE_6)
+	if (*SCpnt->cmnd == WRITE_10 || *SCpnt->cmnd == WRITE_6)
 		return 0;	/* we are still testing, so *don't* write */
 #endif
 	/* Use the outgoing mailboxes in a round-robin fashion, because this
@@ -540,12 +535,12 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 	ccb[mbo].cdblen = SCpnt->cmd_len;
 
 	direction = 0;
-	if (*cmd == READ_10 || *cmd == READ_6)
+	if (*SCpnt->cmnd == READ_10 || *SCpnt->cmnd == READ_6)
 		direction = 8;
-	else if (*cmd == WRITE_10 || *cmd == WRITE_6)
+	else if (*SCpnt->cmnd == WRITE_10 || *SCpnt->cmnd == WRITE_6)
 		direction = 16;
 
-	memcpy(ccb[mbo].cdb, cmd, ccb[mbo].cdblen);
+	memcpy(ccb[mbo].cdb, SCpnt->cmnd, ccb[mbo].cdblen);
 
 	if (bufflen) {
 		struct scatterlist *sg;
@@ -617,15 +612,15 @@ static void setup_mailboxes(int bse, struct Scsi_Host *shpnt)
 	struct mailbox *mb = aha1542->mb;
 	struct ccb *ccb = aha1542->ccb;
 
-	u8 cmd[5] = { CMD_MBINIT, AHA1542_MAILBOXES, 0, 0, 0};
+	u8 mb_cmd[5] = { CMD_MBINIT, AHA1542_MAILBOXES, 0, 0, 0};
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		mb[i].status = mb[AHA1542_MAILBOXES + i].status = 0;
 		any2scsi(mb[i].ccbptr, isa_virt_to_bus(&ccb[i]));
 	};
 	aha1542_intr_reset(bse);	/* reset interrupts, so they don't block */
-	any2scsi((cmd + 2), isa_virt_to_bus(mb));
-	if (aha1542_out(bse, cmd, 5))
+	any2scsi((mb_cmd + 2), isa_virt_to_bus(mb));
+	if (aha1542_out(bse, mb_cmd, 5))
 		printk(KERN_ERR "aha1542_detect: failed setting up mailboxes\n");
 	aha1542_intr_reset(bse);
 }
-- 
Ondrej Zary

