From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH 1/2] [SCSI] Print only a single message "rejecting I/O to device being removed"
Date: Fri, 3 Nov 2006 01:17:30 -0800 (PST)
Message-ID: <96894.60447.qm@web31813.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:23887 "HELO
	web31813.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1752317AbWKCJRb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Nov 2006 04:17:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

... at device removal.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/scsi/scsi_lib.c    |   10 +++++++---
 drivers/scsi/scsi_scan.c   |    1 +
 include/scsi/scsi_device.h |    3 +++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7b0f9a3..f0de7ca 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1302,9 +1302,13 @@ static int scsi_prep_fn(struct request_q
 			if(specials_only == SDEV_QUIESCE ||
 					specials_only == SDEV_BLOCK)
 				goto defer;
-			
-			sdev_printk(KERN_ERR, sdev,
-				    "rejecting I/O to device being removed\n");
+
+			if (sdev->num_rej_messages > 0) {
+				sdev->num_rej_messages--;
+				sdev_printk(KERN_ERR, sdev,
+					    "rejecting I/O to device "
+					    "being removed\n");
+			}
 			goto kill;
 		}
 			
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1a5474b..ad988df 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -223,6 +223,7 @@ static struct scsi_device *scsi_alloc_sd
 	INIT_LIST_HEAD(&sdev->cmd_list);
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	spin_lock_init(&sdev->list_lock);
+	sdev->num_rej_messages = SCSI_DEV_NUM_REJ_MESSAGES;
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
 	sdev->sdev_target = starget;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 895d212..4b0785c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -140,6 +140,9 @@ struct scsi_device {
 
 	struct execute_work	ew; /* used to get process context on put */
 
+#define SCSI_DEV_NUM_REJ_MESSAGES 1
+	int	num_rej_messages;
+
 	enum scsi_device_state sdev_state;
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
-- 
1.4.3.3.g6cec


