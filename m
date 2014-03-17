From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 16/39] virtio_scsi: use cmd_size
Date: Mon, 17 Mar 2014 06:27:49 -0700
Message-ID: <20140317133133.814453025@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0016-virtio_scsi-use-cmd_size.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

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
