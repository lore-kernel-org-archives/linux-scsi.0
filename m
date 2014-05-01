From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] virtio_scsi: use cmd_size
Date: Thu,  1 May 2014 16:51:50 +0200
Message-ID: <1398955911-20688-2-git-send-email-hch@lst.de>
References: <1398955911-20688-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40820 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaEAOth (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2014 10:49:37 -0400
In-Reply-To: <1398955911-20688-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org

Taken almost entirely from Nicholas Bellinger's scsi-mq conversion.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |   25 +++++++------------------
 include/scsi/scsi_cmnd.h   |    9 +++++++++
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 16bfd50..5ec4a73 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -204,7 +204,6 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 			set_driver_byte(sc, DRIVER_SENSE);
 	}
 
-	mempool_free(cmd, virtscsi_cmd_pool);
 	sc->scsi_done(sc);
 
 	atomic_dec(&tgt->reqs);
@@ -279,8 +278,6 @@ static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
 
 	if (cmd->comp)
 		complete_all(cmd->comp);
-	else
-		mempool_free(cmd, virtscsi_cmd_pool);
 }
 
 static void virtscsi_ctrl_done(struct virtqueue *vq)
@@ -496,10 +493,9 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 				 struct virtio_scsi_vq *req_vq,
 				 struct scsi_cmnd *sc)
 {
-	struct virtio_scsi_cmd *cmd;
-	int ret;
-
 	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
+	struct virtio_scsi_cmd *cmd = scsi_cmd_priv(sc);
+
 	BUG_ON(scsi_sg_count(sc) > shost->sg_tablesize);
 
 	/* TODO: check feature bit and fail if unsupported?  */
@@ -508,11 +504,6 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 	dev_dbg(&sc->device->sdev_gendev,
 		"cmd %p CDB: %#02x\n", sc, sc->cmnd[0]);
 
-	ret = SCSI_MLQUEUE_HOST_BUSY;
-	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_ATOMIC);
-	if (!cmd)
-		goto out;
-
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->sc = sc;
 	cmd->req.cmd = (struct virtio_scsi_cmd_req){
@@ -531,13 +522,9 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 
 	if (virtscsi_kick_cmd(req_vq, cmd,
 			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
-			      GFP_ATOMIC) == 0)
-		ret = 0;
-	else
-		mempool_free(cmd, virtscsi_cmd_pool);
-
-out:
-	return ret;
+			      GFP_ATOMIC) != 0)
+		return SCSI_MLQUEUE_HOST_BUSY;
+	return 0;
 }
 
 static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
@@ -683,6 +670,7 @@ static struct scsi_host_template virtscsi_host_template_single = {
 	.name = "Virtio SCSI HBA",
 	.proc_name = "virtio_scsi",
 	.this_id = -1,
+	.cmd_size = sizeof(struct virtio_scsi_cmd),
 	.queuecommand = virtscsi_queuecommand_single,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
@@ -699,6 +687,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
 	.name = "Virtio SCSI HBA",
 	.proc_name = "virtio_scsi",
 	.this_id = -1,
+	.cmd_size = sizeof(struct virtio_scsi_cmd),
 	.queuecommand = virtscsi_queuecommand_multi,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index dd7c998..e016e2a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -133,6 +133,15 @@ struct scsi_cmnd {
 	unsigned char tag;	/* SCSI-II queued command tag */
 };
 
+/*
+ * Return the driver private allocation behind the command.
+ * Only works if cmd_size is set in the host template.
+ */
+static inline void *scsi_cmd_priv(struct scsi_cmnd *cmd)
+{
+	return cmd + 1;
+}
+
 /* make sure not to use it with REQ_TYPE_BLOCK_PC commands */
 static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 {
-- 
1.7.10.4

