From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH 2/2] [SCSI] Print only 5 messages "rejecting I/O to dead device"
Date: Fri, 3 Nov 2006 01:18:40 -0800 (PST)
Message-ID: <349010.73249.qm@web31812.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:6839 "HELO
	web31812.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1752339AbWKCJSk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Nov 2006 04:18:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Also set to 5 printing of "rejecting I/O to device being
removed".  See commit ''Print only a single message
"rejecting I/O to device being removed"''.

When we do hot-unplug, those messages are printed so much
and so often that they overwhelm the CPU and cause soft
lockup.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/scsi/scsi_lib.c    |   11 +++++++----
 drivers/scsi/scsi_scan.c   |    3 ++-
 include/scsi/scsi_device.h |    5 +++--
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 802132e..8b208b4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1122,8 +1122,11 @@ static int scsi_prep_fn(struct request_q
 		if (sdev->sdev_state == SDEV_DEL) {
 			/* Device is fully deleted, no commands
 			 * at all allowed down */
-			sdev_printk(KERN_ERR, sdev,
-				    "rejecting I/O to dead device\n");
+			if (sdev->num_dead_messages > 0) {
+				sdev->num_dead_messages--;
+				sdev_printk(KERN_ERR, sdev,
+					    "rejecting I/O to dead device\n");
+			}
 			goto kill;
 		}
 		/* OK, we only allow special commands (i.e. not
@@ -1149,8 +1152,8 @@ static int scsi_prep_fn(struct request_q
 			    specials_only == SDEV_BLOCK)
 				goto defer;
 
-			if (sdev->num_rej_messages > 0) {
-				sdev->num_rej_messages--;
+			if (sdev->num_remv_messages > 0) {
+				sdev->num_remv_messages--;
 				sdev_printk(KERN_ERR, sdev,
 					    "rejecting I/O to device "
 					    "being removed\n");
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index aa374ed..c82ea82 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -169,7 +169,8 @@ static struct scsi_device *scsi_alloc_sd
 	INIT_LIST_HEAD(&sdev->cmd_list);
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	spin_lock_init(&sdev->list_lock);
-	sdev->num_rej_messages = SCSI_DEV_NUM_REJ_MESSAGES;
+	sdev->num_remv_messages = SCSI_DEV_NUM_MESSAGES;
+	sdev->num_dead_messages = SCSI_DEV_NUM_MESSAGES;
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
 	sdev->sdev_target = starget;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 14bc5ec..6e51f56 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -140,8 +140,9 @@ struct scsi_device {
 
 	struct execute_work	ew; /* used to get process context on put */
 
-#define SCSI_DEV_NUM_REJ_MESSAGES 1
-	int	num_rej_messages;
+#define SCSI_DEV_NUM_MESSAGES	5
+	int	num_remv_messages;
+	int	num_dead_messages;
 
 	enum scsi_device_state sdev_state;
 	unsigned long		sdev_data[0];
-- 
1.4.3.3.g6cec


