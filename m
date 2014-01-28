From: Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH 3/3] m68k/atari - atari_scsi lock fixes: punt if deadlocked
Date: Wed, 29 Jan 2014 12:55:24 +1300
Message-ID: <1390953324-19962-4-git-send-email-schmitz@debian.org>
References: <1388664474-1710039-3-git-send-email-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64222 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbaA1Xzu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jan 2014 18:55:50 -0500
In-Reply-To: <1388664474-1710039-3-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-m68k@vger.kernel.org
Cc: geert@linux-m68k.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org, arnd@arndb.de, Michael Schmitz <schmitz@debian.org>

In case a SCSI command is queued from softirq context, and another
driver currently holds the ST-DMA lock, tell the SCSI midlevel to
hold off queueing commands for now. Something will hopefully resume
play later.

Signed-off-by: Michael Schmitz <schmitz@debian.org>
---
 drivers/scsi/atari_NCR5380.c |   12 +++++++++---
 drivers/scsi/atari_scsi.c    |   26 +++++++++++++++++++++-----
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 465e63d..90a90e8 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -967,9 +967,15 @@ static int NCR5380_queue_command_lck(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
 	 * alter queues and touch the lock.
 	 */
 	if (!IS_A_TT()) {
-		/* perhaps stop command timer here */
-		falcon_get_lock();
-		/* perhaps restart command timer here */
+		/* MSch 20140119: check whether obtaining the ST-DMA lock did
+		 * succeed.
+		 * If the lock could not be acquired without risking to
+		 * deadlock, i.e. from softirq context with ST-DMA currently
+		 * otherwise locked, defer queueing further commands.
+		 */
+		if (falcon_get_lock()) {
+			return SCSI_MLQUEUE_HOST_BUSY;
+		}
 	}
 	if (!(hostdata->issue_queue) || (cmd->cmnd[0] == REQUEST_SENSE)) {
 		LIST(cmd, hostdata->issue_queue);
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 5e19509..2b62ce2 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -197,7 +197,7 @@ static unsigned long atari_dma_xfer_len(unsigned long wanted_len,
 static irqreturn_t scsi_tt_intr(int irq, void *dummy);
 static irqreturn_t scsi_falcon_intr(int irq, void *dummy);
 static void falcon_release_lock_if_possible(struct NCR5380_hostdata *hostdata);
-static void falcon_get_lock(void);
+static int falcon_get_lock(void);
 #ifdef CONFIG_ATARI_SCSI_RESET_BOOT
 static void atari_scsi_reset_boot(void);
 #endif
@@ -541,24 +541,39 @@ static void falcon_release_lock_if_possible(struct NCR5380_hostdata *hostdata)
  * Complicated, complicated.... Sigh...
  */
 
-static void falcon_get_lock(void)
+static int falcon_get_lock(void)
 {
 	unsigned long flags;
 
 	if (IS_A_TT())
-		return;
+		return 0;
 
 	local_irq_save(flags);
 
 	wait_event_cmd(falcon_fairness_wait,
-		in_irq() || !falcon_got_lock || !stdma_others_waiting(),
+		in_interrupt() || !falcon_got_lock || !stdma_others_waiting(),
 		local_irq_restore(flags),
 		local_irq_save(flags));
 
 	while (!falcon_got_lock) {
 		if (in_irq())
-			panic("Falcon SCSI hasn't ST-DMA lock in interrupt");
+			panic("Falcon SCSI hasn't got ST-DMA lock in irq");
 		if (!falcon_trying_lock) {
+			if (in_interrupt()) {
+				if (stdma_islocked()) {
+					/* MSch 20140119: problem -
+					 * cannot schedule in interrupt!
+					 * Unless stdma_lock can be modified
+					 * to interruptible wait, this will
+					 * be needed to avoid deadlocking here!
+					 * Return error to indicate command
+					 * queueing would deadlock, and allow
+					 * queue_command() to stall queueing.
+					 */
+					local_irq_restore(flags);
+					return 1;
+				}
+			}
 			falcon_trying_lock = 1;
 			stdma_lock(scsi_falcon_intr, NULL);
 			falcon_got_lock = 1;
@@ -575,6 +590,7 @@ static void falcon_get_lock(void)
 	local_irq_restore(flags);
 	if (!falcon_got_lock)
 		panic("Falcon SCSI: someone stole the lock :-(\n");
+	return 0;
 }
 
 
-- 
1.7.0.4

