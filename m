From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 45/48] hpsa: shorten the wait for the CISS doorbell mode
 change ack
Date: Wed, 14 Jan 2015 16:03:35 -0600
Message-ID: <20150114220335.21325.88685.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:59573 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbbANWEV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:04:21 -0500
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Shorten the wait for the CISS configuration table doorbell mode
change acknowledgment from 300-600 s to 20 s, which is the value
specified in the CISS specification that should be honored by
all controllers.

Wait using interruptible msleep() rather than uninterruptible
usleep_range(), which triggers rt_sched timeout errors if the
wait is long.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a92653a..89744a1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -60,8 +60,11 @@
 #define DRIVER_NAME "HP HPSA Driver (v " HPSA_DRIVER_VERSION ")"
 #define HPSA "hpsa"
 
-/* How long to wait (in milliseconds) for board to go into simple mode */
-#define MAX_CONFIG_WAIT 30000
+/* How long to wait for CISS doorbell communication */
+#define CLEAR_EVENT_WAIT_INTERVAL 20	/* ms for each msleep() call */
+#define MODE_CHANGE_WAIT_INTERVAL 10	/* ms for each msleep() call */
+#define MAX_CLEAR_EVENT_WAIT 30000	/* times 20 ms = 600 s */
+#define MAX_MODE_CHANGE_WAIT 2000	/* times 10 ms = 20 s */
 #define MAX_IOCTL_CONFIG_WAIT 1000
 
 /*define how many times we will try a command because of bus resets */
@@ -6194,14 +6197,14 @@ static void hpsa_wait_for_clear_event_notify_ack(struct ctlr_info *h)
 	u32 doorbell_value;
 	unsigned long flags;
 	/* wait until the clear_event_notify bit 6 is cleared by controller. */
-	for (i = 0; i < MAX_CONFIG_WAIT; i++) {
+	for (i = 0; i < MAX_CLEAR_EVENT_WAIT; i++) {
 		spin_lock_irqsave(&h->lock, flags);
 		doorbell_value = readl(h->vaddr + SA5_DOORBELL);
 		spin_unlock_irqrestore(&h->lock, flags);
 		if (!(doorbell_value & DOORBELL_CLEAR_EVENTS))
 			break;
 		/* delay and try again */
-		msleep(20);
+		msleep(CLEAR_EVENT_WAIT_INTERVAL);
 	}
 }
 
@@ -6215,14 +6218,14 @@ static void hpsa_wait_for_mode_change_ack(struct ctlr_info *h)
 	 * (e.g.: hot replace a failed 144GB drive in a RAID 5 set right
 	 * as we enter this code.)
 	 */
-	for (i = 0; i < MAX_CONFIG_WAIT; i++) {
+	for (i = 0; i < MAX_MODE_CHANGE_WAIT; i++) {
 		spin_lock_irqsave(&h->lock, flags);
 		doorbell_value = readl(h->vaddr + SA5_DOORBELL);
 		spin_unlock_irqrestore(&h->lock, flags);
 		if (!(doorbell_value & CFGTBL_ChangeReq))
 			break;
 		/* delay and try again */
-		usleep_range(10000, 20000);
+		msleep(MODE_CHANGE_WAIT_INTERVAL);
 	}
 }
 

