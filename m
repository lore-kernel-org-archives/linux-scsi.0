From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 1/5] Use msleep() instead of schedule_timeout
Date: Tue, 08 Dec 2009 15:38:12 -0600
Message-ID: <20091208213812.23493.20587.stgit@beardog.cce.hp.com>
References: <20091208213514.23493.86458.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:31559 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbZLHVgQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2009 16:36:16 -0500
In-Reply-To: <20091208213514.23493.86458.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, smcameron@yahoo.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Use msleep() instead of schedule_timeout

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   27 ++++++++++++++-------------
 drivers/scsi/hpsa.h |    4 ++--
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3c079a4..dc5e518 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1933,7 +1933,7 @@ static int wait_for_device_to_become_ready(struct ctlr_info *h,
 {
 	int rc = 0;
 	int count = 0;
-	int waittime = HZ;
+	int waittime = 1; /* seconds */
 	struct CommandList *c;
 
 	c = cmd_special_alloc(h);
@@ -1950,11 +1950,11 @@ static int wait_for_device_to_become_ready(struct ctlr_info *h,
 		 * the TUR right away, the reset will just abort it.
 		 */
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(waittime);
+		msleep(1000 * waittime);
 		count++;
 
 		/* Increase wait time with each try, up to a point. */
-		if (waittime < (HZ * HPSA_MAX_WAIT_INTERVAL_SECS))
+		if (waittime < HPSA_MAX_WAIT_INTERVAL_SECS)
 			waittime = waittime * 2;
 
 		/* Send the Test Unit Ready */
@@ -1972,7 +1972,7 @@ static int wait_for_device_to_become_ready(struct ctlr_info *h,
 			break;
 
 		dev_warn(&h->pdev->dev, "waiting %d secs "
-			"for device to become ready.\n", waittime / HZ);
+			"for device to become ready.\n", waittime);
 		rc = 1; /* device not ready. */
 	}
 
@@ -2838,8 +2838,8 @@ static __devinit int hpsa_message(struct pci_dev *pdev, unsigned char opcode,
 		tag = readl(vaddr + SA5_REPLY_PORT_OFFSET);
 		if (HPSA_TAG_DISCARD_ERROR_BITS(tag) == paddr32)
 			break;
-		schedule_timeout_uninterruptible(
-			HPSA_MSG_SEND_RETRY_INTERVAL_SECS * HZ);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		msleep(HPSA_MSG_SEND_RETRY_INTERVAL_MSECS);
 	}
 
 	iounmap(vaddr);
@@ -2953,7 +2953,7 @@ static __devinit int hpsa_hard_reset_controller(struct pci_dev *pdev)
 	pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
 
 	set_current_state(TASK_UNINTERRUPTIBLE);
-	schedule_timeout(HZ >> 1);
+	msleep(500);
 
 	/* enter the D0 power management state */
 	pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
@@ -2961,7 +2961,7 @@ static __devinit int hpsa_hard_reset_controller(struct pci_dev *pdev)
 	pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
 
 	set_current_state(TASK_UNINTERRUPTIBLE);
-	schedule_timeout(HZ >> 1);
+	msleep(500);
 
 	/* Restore the PCI configuration space.  The Open CISS
 	 * Specification says, "Restore the PCI Configuration
@@ -3187,8 +3187,8 @@ static int hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
 		scratchpad = readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 		if (scratchpad == HPSA_FIRMWARE_READY)
 			break;
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(HPSA_BOARD_READY_POLL_INTERVAL);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		msleep(HPSA_BOARD_READY_POLL_INTERVAL_MSECS);
 	}
 	if (scratchpad != HPSA_FIRMWARE_READY) {
 		dev_warn(&pdev->dev, "board not ready, timed out.\n");
@@ -3262,8 +3262,8 @@ static int hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
 		if (!(readl(h->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
 			break;
 		/* delay and try again */
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(10);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		msleep(10);
 	}
 
 #ifdef HPSA_DEBUG
@@ -3302,7 +3302,8 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 
 		/* Some devices (notably the HP Smart Array 5i Controller)
 		   need a little pause here */
-		schedule_timeout_uninterruptible(HPSA_POST_RESET_PAUSE);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		msleep(HPSA_POST_RESET_PAUSE_MSECS);
 
 		/* Now try to get the controller to respond to a no-op */
 		for (i = 0; i < HPSA_POST_RESET_NOOP_RETRIES; i++) {
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index ffa8c50..6bd1949 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -108,7 +108,7 @@ struct ctlr_info {
 #define HPSA_BUS_RESET_MSG 2
 #define HPSA_HOST_RESET_MSG 3
 #define HPSA_MSG_SEND_RETRY_LIMIT 10
-#define HPSA_MSG_SEND_RETRY_INTERVAL_SECS 1
+#define HPSA_MSG_SEND_RETRY_INTERVAL_MSECS 1000
 
 /* Maximum time in seconds driver will wait for command completions
  * when polling before giving up.
@@ -139,7 +139,7 @@ struct ctlr_info {
 #define HPSA_BOARD_READY_ITERATIONS \
 	((HPSA_BOARD_READY_WAIT_SECS * 1000) / \
 		HPSA_BOARD_READY_POLL_INTERVAL_MSECS)
-#define HPSA_POST_RESET_PAUSE (30 * HZ)
+#define HPSA_POST_RESET_PAUSE_MSECS (3000)
 #define HPSA_POST_RESET_NOOP_RETRIES (12)
 
 /*  Defining the diffent access_menthods */

