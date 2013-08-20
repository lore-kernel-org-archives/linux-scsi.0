From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 7/7] Micro-optimize scsi_next_command()
Date: Tue, 20 Aug 2013 14:10:41 +0200
Message-ID: <52135CC1.3000901@acm.org>
References: <52135B99.2000102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:55146 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab3HTMKm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2013 08:10:42 -0400
In-Reply-To: <52135B99.2000102@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

Eliminate a get_device() / put_device() pair from scsi_next_command().
Both are atomic operations hence removing these slightly improves
performance.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c         |   34 ++++++++++++++++++++--------------
 drivers/scsi/scsi_lib.c     |    7 +------
 drivers/scsi/scsi_tgt_lib.c |    3 ++-
 include/scsi/scsi_cmnd.h    |    4 ++--
 4 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3d3eb74..721f3cc 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -315,13 +315,11 @@ struct scsi_cmnd *scsi_get_command_and_dev(struct scsi_device *dev,
 EXPORT_SYMBOL(scsi_get_command_and_dev);
 
 /**
- * __scsi_put_command_and_dev() - Free a struct scsi_cmnd
+ * __scsi_put_command() - Free a struct scsi_cmnd but keep the sdev reference
  * @shost: dev->host
  * @cmd: Command to free
- * @dev: parent scsi device
  */
-void __scsi_put_command_and_dev(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
-				struct device *dev)
+void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 {
 	unsigned long flags;
 
@@ -335,10 +333,24 @@ void __scsi_put_command_and_dev(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 
 	if (likely(cmd != NULL))
 		scsi_pool_free_command(shost->cmd_pool, cmd);
+}
+EXPORT_SYMBOL(__scsi_put_command);
 
-	put_device(dev);
+/**
+ * scsi_put_command() - put the command but keep the sdev reference
+ */
+void scsi_put_command(struct scsi_cmnd *cmd)
+{
+	unsigned long flags;
+
+	/* serious error if the command hasn't come from a device list */
+	spin_lock_irqsave(&cmd->device->list_lock, flags);
+	BUG_ON(list_empty(&cmd->list));
+	list_del_init(&cmd->list);
+	spin_unlock_irqrestore(&cmd->device->list_lock, flags);
+
+	__scsi_put_command(cmd->device->host, cmd);
 }
-EXPORT_SYMBOL(__scsi_put_command_and_dev);
 
 /**
  * scsi_put_command_and_dev() - Free a scsi command block
@@ -351,15 +363,9 @@ EXPORT_SYMBOL(__scsi_put_command_and_dev);
 void scsi_put_command_and_dev(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
-	unsigned long flags;
-
-	/* serious error if the command hasn't come from a device list */
-	spin_lock_irqsave(&cmd->device->list_lock, flags);
-	BUG_ON(list_empty(&cmd->list));
-	list_del_init(&cmd->list);
-	spin_unlock_irqrestore(&cmd->device->list_lock, flags);
 
-	__scsi_put_command_and_dev(cmd->device->host, cmd, &sdev->sdev_gendev);
+	scsi_put_command(cmd);
+	put_device(&sdev->sdev_gendev);
 }
 EXPORT_SYMBOL(scsi_put_command_and_dev);
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fc18403..f382f7d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -542,13 +542,8 @@ void scsi_next_command(struct scsi_cmnd *cmd)
 	struct scsi_device *sdev = cmd->device;
 	struct request_queue *q = sdev->request_queue;
 
-	/* need to hold a reference on the device before we let go of the cmd */
-	get_device(&sdev->sdev_gendev);
-
-	scsi_put_command_and_dev(cmd);
+	scsi_put_command(cmd);
 	scsi_run_queue(q);
-
-	/* ok to remove device now */
 	put_device(&sdev->sdev_gendev);
 }
 
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 79d18c5..e51add0 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -155,7 +155,8 @@ void scsi_host_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	__blk_put_request(q, rq);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	__scsi_put_command_and_dev(shost, cmd, &shost->shost_gendev);
+	__scsi_put_command(shost, cmd);
+	put_device(&shost->shost_gendev);
 }
 EXPORT_SYMBOL_GPL(scsi_host_put_command);
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 3649eef..f2eb304 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -141,8 +141,8 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 extern struct scsi_cmnd *scsi_get_command_and_dev(struct scsi_device *, gfp_t);
 extern struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *, gfp_t);
 extern void scsi_put_command_and_dev(struct scsi_cmnd *);
-extern void __scsi_put_command_and_dev(struct Scsi_Host *, struct scsi_cmnd *,
-				       struct device *);
+extern void scsi_put_command(struct scsi_cmnd *);
+extern void __scsi_put_command(struct Scsi_Host *, struct scsi_cmnd *);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
-- 
1.7.10.4

