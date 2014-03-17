From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/39] scsi: do not manipulate device reference counts in
 scsi_get/put_command
Date: Mon, 17 Mar 2014 06:27:42 -0700
Message-ID: <20140317133132.852634994@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0009-scsi-do-not-manipulate-device-reference-counts-in-sc.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Many callers won't need this and we can optimize them away.  In addition
the handling in the __-prefixed variants was inconsistant to start with.

Based on an earlier patch from Bart Van Assche.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c         |   37 ++++++++++++-------------------------
 drivers/scsi/scsi_error.c   |    6 ++++++
 drivers/scsi/scsi_lib.c     |   12 +++++++++++-
 drivers/scsi/scsi_tgt_lib.c |    3 ++-
 include/scsi/scsi_cmnd.h    |    3 +--
 5 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index fb86479..2b12983 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -284,27 +284,19 @@ EXPORT_SYMBOL_GPL(__scsi_get_command);
  */
 struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
 {
-	struct scsi_cmnd *cmd;
+	struct scsi_cmnd *cmd = __scsi_get_command(dev->host, gfp_mask);
+	unsigned long flags;
 
-	/* Bail if we can't get a reference to the device */
-	if (!get_device(&dev->sdev_gendev))
+	if (unlikely(cmd == NULL))
 		return NULL;
 
-	cmd = __scsi_get_command(dev->host, gfp_mask);
-
-	if (likely(cmd != NULL)) {
-		unsigned long flags;
-
-		cmd->device = dev;
-		INIT_LIST_HEAD(&cmd->list);
-		INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
-		spin_lock_irqsave(&dev->list_lock, flags);
-		list_add_tail(&cmd->list, &dev->cmd_list);
-		spin_unlock_irqrestore(&dev->list_lock, flags);
-		cmd->jiffies_at_alloc = jiffies;
-	} else
-		put_device(&dev->sdev_gendev);
-
+	cmd->device = dev;
+	INIT_LIST_HEAD(&cmd->list);
+	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
+	spin_lock_irqsave(&dev->list_lock, flags);
+	list_add_tail(&cmd->list, &dev->cmd_list);
+	spin_unlock_irqrestore(&dev->list_lock, flags);
+	cmd->jiffies_at_alloc = jiffies;
 	return cmd;
 }
 EXPORT_SYMBOL(scsi_get_command);
@@ -313,10 +305,8 @@ EXPORT_SYMBOL(scsi_get_command);
  * __scsi_put_command - Free a struct scsi_cmnd
  * @shost: dev->host
  * @cmd: Command to free
- * @dev: parent scsi device
  */
-void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
-			struct device *dev)
+void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 {
 	unsigned long flags;
 
@@ -331,8 +321,6 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 
 	if (likely(cmd != NULL))
 		scsi_pool_free_command(shost->cmd_pool, cmd);
-
-	put_device(dev);
 }
 EXPORT_SYMBOL(__scsi_put_command);
 
@@ -346,7 +334,6 @@ EXPORT_SYMBOL(__scsi_put_command);
  */
 void scsi_put_command(struct scsi_cmnd *cmd)
 {
-	struct scsi_device *sdev = cmd->device;
 	unsigned long flags;
 
 	/* serious error if the command hasn't come from a device list */
@@ -357,7 +344,7 @@ void scsi_put_command(struct scsi_cmnd *cmd)
 
 	cancel_delayed_work(&cmd->abort_work);
 
-	__scsi_put_command(cmd->device->host, cmd, &sdev->sdev_gendev);
+	__scsi_put_command(cmd->device->host, cmd);
 }
 EXPORT_SYMBOL(scsi_put_command);
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 78b004d..771c16b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2288,6 +2288,11 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	if (scsi_autopm_get_host(shost) < 0)
 		return FAILED;
 
+	if (!get_device(&dev->sdev_gendev)) {
+		rtn = FAILED;
+		goto out_put_autopm_host;
+	}
+
 	scmd = scsi_get_command(dev, GFP_KERNEL);
 	blk_rq_init(NULL, &req);
 	scmd->request = &req;
@@ -2345,6 +2350,7 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	scsi_run_host_queues(shost);
 
 	scsi_next_command(scmd);
+out_put_autopm_host:
 	scsi_autopm_put_host(shost);
 	return rtn;
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index aa6a581..f8a77d8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -95,6 +95,7 @@ static void scsi_unprep_request(struct request *req)
 	req->special = NULL;
 
 	scsi_put_command(cmd);
+	put_device(&cmd->device->sdev_gendev);
 }
 
 /**
@@ -529,6 +530,7 @@ void scsi_next_command(struct scsi_cmnd *cmd)
 	get_device(&sdev->sdev_gendev);
 
 	scsi_put_command(cmd);
+	put_device(&sdev->sdev_gendev);
 	scsi_run_queue(q);
 
 	/* ok to remove device now */
@@ -1116,6 +1118,7 @@ err_exit:
 	scsi_release_buffers(cmd);
 	cmd->request->special = NULL;
 	scsi_put_command(cmd);
+	put_device(&cmd->device->sdev_gendev);
 	return error;
 }
 EXPORT_SYMBOL(scsi_init_io);
@@ -1126,9 +1129,15 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 	struct scsi_cmnd *cmd;
 
 	if (!req->special) {
+		/* Bail if we can't get a reference to the device */
+		if (!get_device(&sdev->sdev_gendev))
+			return NULL;
+
 		cmd = scsi_get_command(sdev, GFP_ATOMIC);
-		if (unlikely(!cmd))
+		if (unlikely(!cmd)) {
+			put_device(&sdev->sdev_gendev);
 			return NULL;
+		}
 		req->special = cmd;
 	} else {
 		cmd = req->special;
@@ -1291,6 +1300,7 @@ int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 			struct scsi_cmnd *cmd = req->special;
 			scsi_release_buffers(cmd);
 			scsi_put_command(cmd);
+			put_device(&cmd->device->sdev_gendev);
 			req->special = NULL;
 		}
 		break;
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 84a1fdf..e51add0 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -155,7 +155,8 @@ void scsi_host_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	__blk_put_request(q, rq);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	__scsi_put_command(shost, cmd, &shost->shost_gendev);
+	__scsi_put_command(shost, cmd);
+	put_device(&shost->shost_gendev);
 }
 EXPORT_SYMBOL_GPL(scsi_host_put_command);
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 91558a1..414edf9 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -142,8 +142,7 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
 extern struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *, gfp_t);
 extern void scsi_put_command(struct scsi_cmnd *);
-extern void __scsi_put_command(struct Scsi_Host *, struct scsi_cmnd *,
-			       struct device *);
+extern void __scsi_put_command(struct Scsi_Host *, struct scsi_cmnd *);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
-- 
1.7.10.4
