From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 08/13] aha1542: remove empty aha1542_stat
Date: Mon, 19 Jan 2015 23:37:52 +0100
Message-ID: <1421707077-25291-9-git-send-email-linux@rainbow-software.org>
References: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:44255 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbbASWiL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2015 17:38:11 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YDKxV-0006A4-IG
	for linux-scsi@vger.kernel.org; Mon, 19 Jan 2015 23:38:09 +0100
In-Reply-To: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index af1e8fa..ebc5476 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -154,12 +154,6 @@ static inline void aha1542_intr_reset(u16 base)
    }									\
  }
 
-static void aha1542_stat(void)
-{
-/*	int s = inb(STATUS), i = inb(INTRFLAGS);
-	printk("status=%x intrflags=%x\n", s, i, WAITnexttimeout-WAITtimeout); */
-}
-
 /* This is a bit complicated, but we need to make sure that an interrupt
    routine does not send something out while we are in the middle of this.
    Fortunately, it is only at boot time that multi-byte messages
@@ -196,7 +190,6 @@ fail:
 	if (got_lock)
 		spin_unlock_irqrestore(&aha1542_lock, flags);
 	printk(KERN_ERR "aha1542_out failed(%d): ", len + 1);
-	aha1542_stat();
 	return 1;
 }
 
@@ -217,7 +210,6 @@ static int aha1542_in(unsigned int base, u8 *cmdp, int len)
 fail:
 	spin_unlock_irqrestore(&aha1542_lock, flags);
 	printk(KERN_ERR "aha1542_in failed(%d): ", len + 1);
-	aha1542_stat();
 	return 1;
 }
 
@@ -590,7 +582,6 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 		printk(KERN_DEBUG "aha1542_queuecommand: dev %d cmd %02x pos %d len %d ", target, *cmd, i, bufflen);
 	else
 		printk(KERN_DEBUG "aha1542_command: dev %d cmd %02x pos %d len %d ", target, *cmd, i, bufflen);
-	aha1542_stat();
 	printk(KERN_DEBUG "aha1542_queuecommand: dumping scsi cmd:");
 	for (i = 0; i < SCpnt->cmd_len; i++)
 		printk("%02x ", cmd[i]);
@@ -691,12 +682,10 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 #endif
 
 	if (done) {
-		DEB(printk("aha1542_queuecommand: now waiting for interrupt ");
-		    aha1542_stat());
+		DEB(printk("aha1542_queuecommand: now waiting for interrupt "));
 		SCpnt->scsi_done = done;
 		mb[mbo].status = 1;
 		aha1542_out(SCpnt->device->host->io_port, &ahacmd, 1);	/* start scsi command */
-		DEB(aha1542_stat());
 	} else
 		printk("aha1542_queuecommand: done can't be NULL\n");
 
@@ -1017,11 +1006,8 @@ fail:
 				printk(", DMA priority %d", dma_chan);
 			printk("\n");
 
-			DEB(aha1542_stat());
 			setup_mailboxes(base_io, shpnt);
 
-			DEB(aha1542_stat());
-
 			DEB(printk("aha1542_detect: enable interrupt channel %d\n", irq_level));
 			spin_lock_irqsave(&aha1542_lock, flags);
 			if (request_irq(irq_level, do_aha1542_intr_handle, 0,
-- 
Ondrej Zary

