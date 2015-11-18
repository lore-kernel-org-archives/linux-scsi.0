From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 66/71] ncr5380: Fix soft lockups
Date: Wed, 18 Nov 2015 19:36:01 +1100
Message-ID: <20151118083519.587173753@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:43893 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932793AbbKRIqk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2015 03:46:40 -0500
Content-Disposition: inline; filename=ncr5380-max_sectors
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

When exercising dmx3191d using sequential IO from dd, the driver is sent
512 KiB WRITE commands and 128 KiB READs. For a PIO transfer, the rate is
is only about 300 KiB/s, so these are long-running commands.

Because of the rudimentary design of the chip, it is necessary to poll the
SCSI bus signals during PIO and this tends to hog the CPU. The driver will
accept new commands while others execute, and this causes a soft lockup
because the workqueue item will not terminate until the issue queue is
emptied.

Fix the non-esponsiveness and soft lockup issues by calling cond_resched()
after each command is completed and by limiting the transfer size for
drivers that don't use DMA in information transfer phases.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   10 ++++++++--
 drivers/scsi/atari_NCR5380.c |   10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:34:33.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:34:36.000000000 +1100
@@ -654,6 +654,10 @@ static int NCR5380_init(struct Scsi_Host
 
 	prepare_info(instance);
 
+#ifndef REAL_DMA
+	instance->max_sectors = 128;
+#endif
+
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(TARGET_COMMAND_REG, 0);
@@ -886,10 +890,10 @@ static void NCR5380_main(struct work_str
 	struct scsi_cmnd *cmd;
 	int done;
 	
-	spin_lock_irq(&hostdata->lock);
 	do {
 		done = 1;
 
+		spin_lock_irq(&hostdata->lock);
 		while (!hostdata->connected &&
 		       (cmd = dequeue_next_cmd(instance))) {
 
@@ -926,8 +930,10 @@ static void NCR5380_main(struct work_str
 			NCR5380_information_transfer(instance);
 			done = 0;
 		}
+		spin_unlock_irq(&hostdata->lock);
+		if (!done)
+			cond_resched();
 	} while (!done);
-	spin_unlock_irq(&hostdata->lock);
 }
 
 #ifndef DONT_USE_INTR
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-18 19:34:34.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-18 19:34:36.000000000 +1100
@@ -689,6 +689,10 @@ static int __init NCR5380_init(struct Sc
 
 	prepare_info(instance);
 
+#ifndef REAL_DMA
+	instance->max_sectors = 128;
+#endif
+
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(TARGET_COMMAND_REG, 0);
@@ -973,10 +977,10 @@ static void NCR5380_main(struct work_str
 	 * alter queues and touch the Falcon lock.
 	 */
 
-	spin_lock_irq(&hostdata->lock);
 	do {
 		done = 1;
 
+		spin_lock_irq(&hostdata->lock);
 		while (!hostdata->connected &&
 		       (cmd = dequeue_next_cmd(instance))) {
 
@@ -1023,8 +1027,10 @@ static void NCR5380_main(struct work_str
 			NCR5380_information_transfer(instance);
 			done = 0;
 		}
+		spin_unlock_irq(&hostdata->lock);
+		if (!done)
+			cond_resched();
 	} while (!done);
-	spin_unlock_irq(&hostdata->lock);
 }
 
 


