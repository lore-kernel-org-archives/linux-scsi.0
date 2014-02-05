From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/17] virtio_scsi: use cmd_size
Date: Wed, 05 Feb 2014 04:39:37 -0800
Message-ID: <20140205124020.142099443@bombadil.infradead.org>
References: <20140205123930.150608699@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaBEMkX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:40:23 -0500
Content-Disposition: inline; filename=0007-virtio_scsi-use-cmd_size.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

Taken almost entirely from Nicholas Bellinger's scsi-mq conversion.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/virtio_scsi.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 16bfd50..d9a6074 100644
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
+	struct virtio_scsi_cmd *cmd = (struct virtio_scsi_cmd *)(sc + 1);
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
-- 
1.7.10.4


