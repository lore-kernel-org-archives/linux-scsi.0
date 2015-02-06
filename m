From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 32/36] aha1542: Use print_hex_dump_bytes in debug code
Date: Fri,  6 Feb 2015 23:11:53 +0100
Message-ID: <1423260717-15944-33-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56959 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037AbbBFWPt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:15:49 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8I-0006fF-I6
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:14 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   34 ++++++++--------------------------
 1 file changed, 8 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 6d4532c..87017fb 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -381,14 +381,8 @@ static void aha1542_intr_handle(struct Scsi_Host *sh)
 		if (errstatus)
 			shost_printk(KERN_DEBUG, sh, "(aha1542 error:%x %x %x) ", errstatus,
 			       ccb[mbo].hastat, ccb[mbo].tarstat);
-		if (ccb[mbo].tarstat == 2) {
-			int i;
-
-			printk("aha1542_intr_handle: sense:");
-			for (i = 0; i < 12; i++)
-				printk("%02x ", ccb[mbo].cdb[ccb[mbo].cdblen + i]);
-			printk("\n");
-		}
+		if (ccb[mbo].tarstat == 2)
+			print_hex_dump_bytes("sense: ", DUMP_PREFIX_NONE, &ccb[mbo].cdb[ccb[mbo].cdblen], 12);
 		if (errstatus)
 			printk("aha1542_intr_handle: returning %6x\n", errstatus);
 #endif
@@ -450,10 +444,7 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 		shost_printk(KERN_DEBUG, sh, "aha1542_queuecommand: dev %d cmd %02x pos %d len %d ", target, *cmd->cmnd, i, bufflen);
 	else
 		shost_printk(KERN_DEBUG, sh, "aha1542_command: dev %d cmd %02x pos %d len %d ", target, *cmd->cmnd, i, bufflen);
-	shost_printk(KERN_DEBUG, sh, "aha1542_queuecommand: dumping scsi cmd:");
-	for (i = 0; i < cmd->cmd_len; i++)
-		printk("%02x ", cmd->cmnd[i]);
-	printk("\n");
+	print_hex_dump_bytes("command: ", DUMP_PREFIX_NONE, cmd->cmnd, cmd->cmd_len);
 	if (*cmd->cmnd == WRITE_10 || *cmd->cmnd == WRITE_6)
 		return 0;	/* we are still testing, so *don't* write */
 #endif
@@ -483,7 +474,7 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 	spin_unlock_irqrestore(&aha1542_lock, flags);
 
 #ifdef DEBUG
-	shost_printk(KERN_DEBUG, sh, "Sending command (%d %x)...", mbo, done);
+	shost_printk(KERN_DEBUG, sh, "Sending command (%d %p)...", mbo, done);
 #endif
 
 	any2scsi(mb[mbo].ccbptr, isa_virt_to_bus(&ccb[mbo]));	/* This gets trashed for some reason */
@@ -503,10 +494,8 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 	if (bufflen) {
 		struct scatterlist *sg;
 		struct chain *cptr;
-#ifdef DEBUG
-		unsigned char *ptr;
-#endif
 		int i, sg_count = scsi_sg_count(cmd);
+
 		ccb[mbo].op = 2;	/* SCSI Initiator Command  w/scatter-gather */
 		cmd->host_scribble = kmalloc(sizeof(*cptr)*sg_count,
 		                                         GFP_KERNEL | GFP_DMA);
@@ -524,10 +513,8 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 		any2scsi(ccb[mbo].datalen, sg_count * sizeof(struct chain));
 		any2scsi(ccb[mbo].dataptr, isa_virt_to_bus(cptr));
 #ifdef DEBUG
-		printk("cptr %x: ", cptr);
-		ptr = (unsigned char *) cptr;
-		for (i = 0; i < 18; i++)
-			printk("%02x ", ptr[i]);
+		shost_printk(KERN_DEBUG, sh, "cptr %p: ", cptr);
+		print_hex_dump_bytes("cptr: ", DUMP_PREFIX_NONE, cptr, 18);
 #endif
 	} else {
 		ccb[mbo].op = 0;	/* SCSI Initiator Command */
@@ -541,12 +528,7 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 	ccb[mbo].commlinkid = 0;
 
 #ifdef DEBUG
-	{
-		int i;
-		shost_printk(KERN_DEBUG, sh, "aha1542_command: sending.. ");
-		for (i = 0; i < sizeof(ccb[mbo]) - 10; i++)
-			printk("%02x ", ((u8 *) &ccb[mbo])[i]);
-	};
+	print_hex_dump_bytes("sending: ", DUMP_PREFIX_NONE, &ccb[mbo], sizeof(ccb[mbo]) - 10);
 #endif
 
 	if (done) {
-- 
Ondrej Zary

