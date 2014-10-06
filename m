From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/26] scsi: Remove scsi_print_command when calling abort
Date: Mon,  6 Oct 2014 11:01:18 +0200
Message-ID: <1412586086-129821-19-git-send-email-hare@suse.de>
References: <1412586086-129821-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbaJFJBf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2014 05:01:35 -0400
In-Reply-To: <1412586086-129821-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Calling scsi_print_command should not be necessary during abort;
if the information is required one should enable scsi logging.

Reviewed-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/53c700.c        |  4 +---
 drivers/scsi/NCR5380.c       |  5 ++---
 drivers/scsi/arm/fas216.c    | 10 +++-------
 drivers/scsi/atari_NCR5380.c |  3 +--
 drivers/scsi/ps3rom.c        |  4 ----
 drivers/scsi/stex.c          |  9 +++------
 drivers/scsi/sun3_NCR5380.c  |  3 +--
 7 files changed, 11 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 179a24e..474cc6d 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1906,9 +1906,7 @@ NCR_700_abort(struct scsi_cmnd * SCp)
 {
 	struct NCR_700_command_slot *slot;
 
-	scmd_printk(KERN_INFO, SCp,
-		"New error handler wants to abort command\n\t");
-	scsi_print_command(SCp);
+	scmd_printk(KERN_INFO, SCp, "abort command\n");
 
 	slot = (struct NCR_700_command_slot *)SCp->host_scribble;
 
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 45da3c8..50873bb 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2666,9 +2666,8 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
 	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 	Scsi_Cmnd *tmp, **prev;
-	
-	printk(KERN_WARNING "scsi%d : aborting command\n", instance->host_no);
-	scsi_print_command(cmd);
+
+	scmd_printk(KERN_WARNING, cmd, "aborting command\n");
 
 	NCR5380_print_status(instance);
 
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index d2581cb..e64c3af 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2423,14 +2423,11 @@ int fas216_eh_abort(struct scsi_cmnd *SCpnt)
 
 	info->stats.aborts += 1;
 
-	printk(KERN_WARNING "scsi%d: abort command ", info->host->host_no);
-	__scsi_print_command(SCpnt->cmnd, SCpnt->cmd_len);
+	scmd_printk(KERN_WARNING, SCpnt, "abort command\n");
 
 	print_debug_list();
 	fas216_dumpstate(info);
 
-	printk(KERN_WARNING "scsi%d: abort %p ", info->host->host_no, SCpnt);
-
 	switch (fas216_find_command(info, SCpnt)) {
 	/*
 	 * We found the command, and cleared it out.  Either
@@ -2438,7 +2435,7 @@ int fas216_eh_abort(struct scsi_cmnd *SCpnt)
 	 * target, or the busylun bit is not set.
 	 */
 	case res_success:
-		printk("success\n");
+		scmd_printk(KERN_WARNING, SCpnt, "abort %p success\n", SCpnt);
 		result = SUCCESS;
 		break;
 
@@ -2448,14 +2445,13 @@ int fas216_eh_abort(struct scsi_cmnd *SCpnt)
 	 * if the bus is free.
 	 */
 	case res_hw_abort:
-		
 
 	/*
 	 * We are unable to abort the command for some reason.
 	 */
 	default:
 	case res_failed:
-		printk("failed\n");
+		scmd_printk(KERN_WARNING, SCpnt, "abort %p failed\n", SCpnt);
 		break;
 	}
 
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 79e6f04..229c61b 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -2623,8 +2623,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 	Scsi_Cmnd *tmp, **prev;
 	unsigned long flags;
 
-	printk(KERN_NOTICE "scsi%d: aborting command\n", HOSTNO);
-	scsi_print_command(cmd);
+	scmd_printk(KERN_NOTICE, cmd, "aborting command\n");
 
 	NCR5380_print_status(instance);
 
diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index ef23fab..b3b48b5 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -220,10 +220,6 @@ static int ps3rom_queuecommand_lck(struct scsi_cmnd *cmd,
 	unsigned char opcode;
 	int res;
 
-#ifdef DEBUG
-	scsi_print_command(cmd);
-#endif
-
 	priv->curr_cmd = cmd;
 	cmd->scsi_done = done;
 
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 1aa4bef..713af13 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1162,9 +1162,7 @@ static int stex_abort(struct scsi_cmnd *cmd)
 	int result = SUCCESS;
 	unsigned long flags;
 
-	printk(KERN_INFO DRV_NAME
-		"(%s): aborting command\n", pci_name(hba->pdev));
-	scsi_print_command(cmd);
+	scmd_printk(KERN_INFO, cmd, "aborting command\n");
 
 	base = hba->mmio_base;
 	spin_lock_irqsave(host->host_lock, flags);
@@ -1352,9 +1350,8 @@ static int stex_reset(struct scsi_cmnd *cmd)
 
 	hba = (struct st_hba *) &cmd->device->host->hostdata[0];
 
-	printk(KERN_INFO DRV_NAME
-		"(%s): resetting host\n", pci_name(hba->pdev));
-	scsi_print_command(cmd);
+	shost_printk(KERN_INFO, cmd->device->host,
+		     "resetting host\n");
 
 	return stex_do_reset(hba) ? FAILED : SUCCESS;
 }
diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 1a2367a..3abd796 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -2608,8 +2608,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
     struct scsi_cmnd *tmp, **prev;
     unsigned long flags;
 
-    printk(KERN_NOTICE "scsi%d: aborting command\n", HOSTNO);
-    scsi_print_command(cmd);
+    scmd_printk(KERN_NOTICE, cmd, "aborting command\n");
 
     NCR5380_print_status (instance);
 
-- 
1.8.5.2

