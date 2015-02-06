From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 33/36] aha1542: Don't reduce functionality with DEBUG enabled
Date: Fri,  6 Feb 2015 23:11:54 +0100
Message-ID: <1423260717-15944-34-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56972 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906AbbBFWQN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:16:13 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8I-0006fF-Nc
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:14 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Enabling DEBUG disables write commands and devices with ID > 1.
Remove this "feature" to allow real debugging.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 87017fb..a19fcb0 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -418,15 +418,7 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 	int mbo;
 	struct mailbox *mb = aha1542->mb;
 	struct ccb *ccb = aha1542->ccb;
-#ifdef DEBUG
-	int i;
 
-	if (target > 1) {
-		cmd->result = DID_TIME_OUT << 16;
-		done(cmd);
-		return 0;
-	}
-#endif
 	if (*cmd->cmnd == REQUEST_SENSE) {
 		/* Don't do the command - we have the sense data already */
 		cmd->result = 0;
@@ -434,19 +426,16 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 		return 0;
 	}
 #ifdef DEBUG
-	if (*cmd->cmnd == READ_10 || *cmd->cmnd == WRITE_10)
-		i = xscsi2int(cmd->cmnd + 2);
-	else if (*cmd->cmnd == READ_6 || *cmd->cmnd == WRITE_6)
-		i = scsi2int(cmd->cmnd + 2);
-	else
-		i = -1;
-	if (done)
-		shost_printk(KERN_DEBUG, sh, "aha1542_queuecommand: dev %d cmd %02x pos %d len %d ", target, *cmd->cmnd, i, bufflen);
-	else
-		shost_printk(KERN_DEBUG, sh, "aha1542_command: dev %d cmd %02x pos %d len %d ", target, *cmd->cmnd, i, bufflen);
-	print_hex_dump_bytes("command: ", DUMP_PREFIX_NONE, cmd->cmnd, cmd->cmd_len);
-	if (*cmd->cmnd == WRITE_10 || *cmd->cmnd == WRITE_6)
-		return 0;	/* we are still testing, so *don't* write */
+	{
+		int i = -1;
+		if (*cmd->cmnd == READ_10 || *cmd->cmnd == WRITE_10)
+			i = xscsi2int(cmd->cmnd + 2);
+		else if (*cmd->cmnd == READ_6 || *cmd->cmnd == WRITE_6)
+			i = scsi2int(cmd->cmnd + 2);
+		shost_printk(KERN_DEBUG, sh, "aha1542_queuecommand: dev %d cmd %02x pos %d len %d",
+						target, *cmd->cmnd, i, bufflen);
+		print_hex_dump_bytes("command: ", DUMP_PREFIX_NONE, cmd->cmnd, cmd->cmd_len);
+	}
 #endif
 	/* Use the outgoing mailboxes in a round-robin fashion, because this
 	   is how the host adapter will scan for them */
-- 
Ondrej Zary

