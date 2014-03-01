From: Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH 3/3] m68k/atari - atari_scsi: punt if deadlocked
Date: Sat,  1 Mar 2014 20:51:05 +1300
Message-ID: <1393660265-19384-4-git-send-email-schmitz@debian.org>
References: <1393660265-19384-1-git-send-email-schmitz@debian.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1393660265-19384-1-git-send-email-schmitz@debian.org>
Sender: linux-m68k-owner@vger.kernel.org
To: linux-m68k@vger.kernel.org
Cc: geert@linux-m68k.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org, arnd@arndb.de, Michael Schmitz <schmitz@debian.org>
List-Id: linux-scsi@vger.kernel.org

In case a SCSI command is queued from softirq context, and another
driver currently holds the ST-DMA lock, tell the SCSI midlevel to
hold off queueing commands for now. Midlevel will resume play later.

Signed-off-by: Michael Schmitz <schmitz@debian.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/atari_NCR5380.c |   12 +++++++++---
 drivers/scsi/atari_scsi.c    |   24 ++++++++++++++++++++----
 2 files changed, 29 insertions(+), 7 deletions(-)

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
index 4ae0c1a..30c7385 100644
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
@@ -541,12 +541,12 @@ static void falcon_release_lock_if_possible(struct NCR5380_hostdata *hostdata)
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
 
@@ -557,8 +557,23 @@ static void falcon_get_lock(void)
 
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
