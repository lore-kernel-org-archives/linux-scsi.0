From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 10/18] scsi: Only add commands to the device command list if required by the LLD
Date: Fri, 19 May 2017 11:30:08 -0700
Message-ID: <20170519183016.12646-11-bart.vanassche@sandisk.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:18061 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752472AbdESSaZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 14:30:25 -0400
In-Reply-To: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>

Just like for the scsi-mq code path, in the single queue SCSI code
path only add commands to the per-device command list if required
by the SCSI LLD. This patch will make it easier to merge the
single-queue and multiqueue command initialization code.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi.c      |  9 +--------
 drivers/scsi/scsi_lib.c  | 52 +++++++++++++++++++++++++++++-------------------
 drivers/scsi/scsi_priv.h |  2 ++
 3 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 7bfbcfa7af40..485684aafb9b 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -108,14 +108,7 @@ EXPORT_SYMBOL(scsi_sd_pm_domain);
  */
 void scsi_put_command(struct scsi_cmnd *cmd)
 {
-	unsigned long flags;
-
-	/* serious error if the command hasn't come from a device list */
-	spin_lock_irqsave(&cmd->device->list_lock, flags);
-	BUG_ON(list_empty(&cmd->list));
-	list_del_init(&cmd->list);
-	spin_unlock_irqrestore(&cmd->device->list_lock, flags);
-
+	scsi_del_cmd_from_list(cmd);
 	BUG_ON(delayed_work_pending(&cmd->abort_work));
 }
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index efa5741cab02..a8d4f17ad5aa 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -583,19 +583,9 @@ static void scsi_mq_free_sgtables(struct scsi_cmnd *cmd)
 
 static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 {
-	struct scsi_device *sdev = cmd->device;
-	struct Scsi_Host *shost = sdev->host;
-	unsigned long flags;
-
 	scsi_mq_free_sgtables(cmd);
 	scsi_uninit_cmd(cmd);
-
-	if (shost->use_cmd_list) {
-		BUG_ON(list_empty(&cmd->list));
-		spin_lock_irqsave(&sdev->list_lock, flags);
-		list_del_init(&cmd->list);
-		spin_unlock_irqrestore(&sdev->list_lock, flags);
-	}
+	scsi_del_cmd_from_list(cmd);
 }
 
 /*
@@ -1133,6 +1123,35 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 }
 EXPORT_SYMBOL(scsi_init_io);
 
+/* Add a command to the list used by the aacraid and dpt_i2o drivers */
+void scsi_add_cmd_to_list(struct scsi_cmnd *cmd)
+{
+	struct scsi_device *sdev = cmd->device;
+	struct Scsi_Host *shost = sdev->host;
+	unsigned long flags;
+
+	if (shost->use_cmd_list) {
+		spin_lock_irqsave(&sdev->list_lock, flags);
+		list_add_tail(&cmd->list, &sdev->cmd_list);
+		spin_unlock_irqrestore(&sdev->list_lock, flags);
+	}
+}
+
+/* Remove a command from the list used by the aacraid and dpt_i2o drivers */
+void scsi_del_cmd_from_list(struct scsi_cmnd *cmd)
+{
+	struct scsi_device *sdev = cmd->device;
+	struct Scsi_Host *shost = sdev->host;
+	unsigned long flags;
+
+	if (shost->use_cmd_list) {
+		spin_lock_irqsave(&sdev->list_lock, flags);
+		BUG_ON(list_empty(&cmd->list));
+		list_del_init(&cmd->list);
+		spin_unlock_irqrestore(&sdev->list_lock, flags);
+	}
+}
+
 /* Called from inside blk_get_request() */
 static void scsi_initialize_rq(struct request *rq)
 {
@@ -1146,7 +1165,6 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 {
 	void *buf = cmd->sense_buffer;
 	void *prot = cmd->prot_sdb;
-	unsigned long flags;
 
 	/* zero out the cmd, except for the embedded scsi_request */
 	memset((char *)cmd + sizeof(cmd->req), 0,
@@ -1158,9 +1176,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 	cmd->jiffies_at_alloc = jiffies;
 
-	spin_lock_irqsave(&dev->list_lock, flags);
-	list_add_tail(&cmd->list, &dev->cmd_list);
-	spin_unlock_irqrestore(&dev->list_lock, flags);
+	scsi_add_cmd_to_list(cmd);
 }
 
 static int scsi_setup_scsi_cmnd(struct scsi_device *sdev, struct request *req)
@@ -1875,11 +1891,7 @@ static int scsi_mq_prep_fn(struct request *req)
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 	cmd->jiffies_at_alloc = jiffies;
 
-	if (shost->use_cmd_list) {
-		spin_lock_irq(&sdev->list_lock);
-		list_add_tail(&cmd->list, &sdev->cmd_list);
-		spin_unlock_irq(&sdev->list_lock);
-	}
+	scsi_add_cmd_to_list(cmd);
 
 	sg = (void *)cmd + sizeof(struct scsi_cmnd) + shost->hostt->cmd_size;
 	cmd->sdb.table.sgl = sg;
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index f86057842f9a..c11c1f9c912c 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -80,6 +80,8 @@ int scsi_eh_get_sense(struct list_head *work_q,
 int scsi_noretry_cmd(struct scsi_cmnd *scmd);
 
 /* scsi_lib.c */
+extern void scsi_add_cmd_to_list(struct scsi_cmnd *cmd);
+extern void scsi_del_cmd_from_list(struct scsi_cmnd *cmd);
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_device_unbusy(struct scsi_device *sdev);
 extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
-- 
2.12.2
