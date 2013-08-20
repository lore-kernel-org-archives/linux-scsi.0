From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 6/7] Rename scsi_get_command() and scsi_put_command()
Date: Tue, 20 Aug 2013 14:09:57 +0200
Message-ID: <52135C95.7080705@acm.org>
References: <52135B99.2000102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:55146 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab3HTMJ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2013 08:09:58 -0400
In-Reply-To: <52135B99.2000102@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

Make it explicit which variants of scsi_get_command() and
scsi_put_command() manipulate the SCSI device reference count.

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c         |   23 ++++++++++++-----------
 drivers/scsi/scsi_error.c   |    2 +-
 drivers/scsi/scsi_lib.c     |   10 +++++-----
 drivers/scsi/scsi_tgt_lib.c |    2 +-
 include/scsi/scsi_cmnd.h    |    8 ++++----
 5 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index eaa808e..3d3eb74 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -281,13 +281,14 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 EXPORT_SYMBOL_GPL(__scsi_get_command);
 
 /**
- * scsi_get_command - Allocate and setup a scsi command block
+ * scsi_get_command_and_dev() - Allocate and setup a scsi command block
  * @dev: parent scsi device
  * @gfp_mask: allocator flags
  *
  * Returns:	The allocated scsi command structure.
  */
-struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
+struct scsi_cmnd *scsi_get_command_and_dev(struct scsi_device *dev,
+					   gfp_t gfp_mask)
 {
 	struct scsi_cmnd *cmd;
 
@@ -311,16 +312,16 @@ struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
 
 	return cmd;
 }
-EXPORT_SYMBOL(scsi_get_command);
+EXPORT_SYMBOL(scsi_get_command_and_dev);
 
 /**
- * __scsi_put_command - Free a struct scsi_cmnd
+ * __scsi_put_command_and_dev() - Free a struct scsi_cmnd
  * @shost: dev->host
  * @cmd: Command to free
  * @dev: parent scsi device
  */
-void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
-			struct device *dev)
+void __scsi_put_command_and_dev(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
+				struct device *dev)
 {
 	unsigned long flags;
 
@@ -337,17 +338,17 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 
 	put_device(dev);
 }
-EXPORT_SYMBOL(__scsi_put_command);
+EXPORT_SYMBOL(__scsi_put_command_and_dev);
 
 /**
- * scsi_put_command - Free a scsi command block
+ * scsi_put_command_and_dev() - Free a scsi command block
  * @cmd: command block to free
  *
  * Returns:	Nothing.
  *
  * Notes:	The command must not belong to any lists.
  */
-void scsi_put_command(struct scsi_cmnd *cmd)
+void scsi_put_command_and_dev(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
 	unsigned long flags;
@@ -358,9 +359,9 @@ void scsi_put_command(struct scsi_cmnd *cmd)
 	list_del_init(&cmd->list);
 	spin_unlock_irqrestore(&cmd->device->list_lock, flags);
 
-	__scsi_put_command(cmd->device->host, cmd, &sdev->sdev_gendev);
+	__scsi_put_command_and_dev(cmd->device->host, cmd, &sdev->sdev_gendev);
 }
-EXPORT_SYMBOL(scsi_put_command);
+EXPORT_SYMBOL(scsi_put_command_and_dev);
 
 static struct scsi_host_cmd_pool *scsi_get_host_cmd_pool(gfp_t gfp_mask)
 {
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2150596..4a1462a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1995,7 +1995,7 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	if (scsi_autopm_get_host(shost) < 0)
 		return FAILED;
 
-	scmd = scsi_get_command(dev, GFP_KERNEL);
+	scmd = scsi_get_command_and_dev(dev, GFP_KERNEL);
 	blk_rq_init(NULL, &req);
 	scmd->request = &req;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 905ac00..fc18403 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -116,7 +116,7 @@ static void scsi_unprep_request(struct request *req)
 	blk_unprep_request(req);
 	req->special = NULL;
 
-	scsi_put_command(cmd);
+	scsi_put_command_and_dev(cmd);
 }
 
 /**
@@ -545,7 +545,7 @@ void scsi_next_command(struct scsi_cmnd *cmd)
 	/* need to hold a reference on the device before we let go of the cmd */
 	get_device(&sdev->sdev_gendev);
 
-	scsi_put_command(cmd);
+	scsi_put_command_and_dev(cmd);
 	scsi_run_queue(q);
 
 	/* ok to remove device now */
@@ -1110,7 +1110,7 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 err_exit:
 	scsi_release_buffers(cmd);
 	cmd->request->special = NULL;
-	scsi_put_command(cmd);
+	scsi_put_command_and_dev(cmd);
 	return error;
 }
 EXPORT_SYMBOL(scsi_init_io);
@@ -1121,7 +1121,7 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 	struct scsi_cmnd *cmd;
 
 	if (!req->special) {
-		cmd = scsi_get_command(sdev, GFP_ATOMIC);
+		cmd = scsi_get_command_and_dev(sdev, GFP_ATOMIC);
 		if (unlikely(!cmd))
 			return NULL;
 		req->special = cmd;
@@ -1286,7 +1286,7 @@ int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 		if (req->special) {
 			struct scsi_cmnd *cmd = req->special;
 			scsi_release_buffers(cmd);
-			scsi_put_command(cmd);
+			scsi_put_command_and_dev(cmd);
 			req->special = NULL;
 		}
 		break;
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 84a1fdf..79d18c5 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -155,7 +155,7 @@ void scsi_host_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	__blk_put_request(q, rq);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	__scsi_put_command(shost, cmd, &shost->shost_gendev);
+	__scsi_put_command_and_dev(shost, cmd, &shost->shost_gendev);
 }
 EXPORT_SYMBOL_GPL(scsi_host_put_command);
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index de5f5d8..3649eef 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -138,11 +138,11 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
 }
 
-extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
+extern struct scsi_cmnd *scsi_get_command_and_dev(struct scsi_device *, gfp_t);
 extern struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *, gfp_t);
-extern void scsi_put_command(struct scsi_cmnd *);
-extern void __scsi_put_command(struct Scsi_Host *, struct scsi_cmnd *,
-			       struct device *);
+extern void scsi_put_command_and_dev(struct scsi_cmnd *);
+extern void __scsi_put_command_and_dev(struct Scsi_Host *, struct scsi_cmnd *,
+				       struct device *);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
-- 
1.7.10.4

