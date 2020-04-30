Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F45CC8300B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04E9220873
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgD3NUN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:60750 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726850AbgD3NUG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D2B35AED6;
        Thu, 30 Apr 2020 13:20:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: [PATCH RFC v3 06/41] virtio_scsi: use reserved commands for TMF
Date:   Thu, 30 Apr 2020 15:18:29 +0200
Message-Id: <20200430131904.5847-7-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Set two commands aside for TMF, and use reserved commands to issue
TMFs. With that we can drop the TMF memory pool.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/virtio_scsi.c | 105 ++++++++++++++++++---------------------------
 1 file changed, 41 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 0e0910c5b942..26054c29d897 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -35,10 +35,10 @@
 #define VIRTIO_SCSI_MEMPOOL_SZ 64
 #define VIRTIO_SCSI_EVENT_LEN 8
 #define VIRTIO_SCSI_VQ_BASE 2
+#define VIRTIO_SCSI_RESERVED_CMDS 2
 
 /* Command queue element */
 struct virtio_scsi_cmd {
-	struct scsi_cmnd *sc;
 	struct completion *comp;
 	union {
 		struct virtio_scsi_cmd_req       cmd;
@@ -86,9 +86,6 @@ struct virtio_scsi {
 	struct virtio_scsi_vq req_vqs[];
 };
 
-static struct kmem_cache *virtscsi_cmd_cache;
-static mempool_t *virtscsi_cmd_pool;
-
 static inline struct Scsi_Host *virtio_scsi_host(struct virtio_device *vdev)
 {
 	return vdev->priv;
@@ -108,7 +105,7 @@ static void virtscsi_compute_resid(struct scsi_cmnd *sc, u32 resid)
 static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_cmd *cmd = buf;
-	struct scsi_cmnd *sc = cmd->sc;
+	struct scsi_cmnd *sc = scsi_cmd_from_priv(cmd);
 	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
 
 	dev_dbg(&sc->device->sdev_gendev,
@@ -406,7 +403,7 @@ static int __virtscsi_add_cmd(struct virtqueue *vq,
 			    struct virtio_scsi_cmd *cmd,
 			    size_t req_size, size_t resp_size)
 {
-	struct scsi_cmnd *sc = cmd->sc;
+	struct scsi_cmnd *sc = scsi_cmd_from_priv(cmd);
 	struct scatterlist *sgs[6], req, resp;
 	struct sg_table *out, *in;
 	unsigned out_num = 0, in_num = 0;
@@ -557,8 +554,6 @@ static int virtscsi_queuecommand(struct Scsi_Host *shost,
 	dev_dbg(&sc->device->sdev_gendev,
 		"cmd %p CDB: %#02x\n", sc, sc->cmnd[0]);
 
-	cmd->sc = sc;
-
 	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
@@ -590,17 +585,17 @@ static int virtscsi_queuecommand(struct Scsi_Host *shost,
 static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 {
 	DECLARE_COMPLETION_ONSTACK(comp);
-	int ret = FAILED;
 
 	cmd->comp = &comp;
+
 	if (virtscsi_add_cmd(&vscsi->ctrl_vq, cmd,
 			      sizeof cmd->req.tmf, sizeof cmd->resp.tmf, true) < 0)
-		goto out;
+		return FAILED;
 
 	wait_for_completion(&comp);
 	if (cmd->resp.tmf.response == VIRTIO_SCSI_S_OK ||
 	    cmd->resp.tmf.response == VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
-		ret = SUCCESS;
+		return SUCCESS;
 
 	/*
 	 * The spec guarantees that all requests related to the TMF have
@@ -613,33 +608,36 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 	 * REQ_ATOM_COMPLETE has been set.
 	 */
 	virtscsi_poll_requests(vscsi);
-
-out:
-	mempool_free(cmd, virtscsi_cmd_pool);
-	return ret;
+	return FAILED;
 }
 
 static int virtscsi_device_reset(struct scsi_cmnd *sc)
 {
+	struct scsi_device *sdev = sc->device;
+	struct scsi_cmnd *reset_sc;
 	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
 	struct virtio_scsi_cmd *cmd;
+	int rc;
 
-	sdev_printk(KERN_INFO, sc->device, "device reset\n");
-	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
-	if (!cmd)
+	sdev_printk(KERN_INFO, sdev, "device reset\n");
+	reset_sc = scsi_get_reserved_cmd(sdev, DMA_NONE);
+	if (!reset_sc)
 		return FAILED;
-
+	cmd = scsi_cmd_priv(reset_sc);
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
 		.type = VIRTIO_SCSI_T_TMF,
 		.subtype = cpu_to_virtio32(vscsi->vdev,
 					     VIRTIO_SCSI_T_TMF_LOGICAL_UNIT_RESET),
 		.lun[0] = 1,
-		.lun[1] = sc->device->id,
-		.lun[2] = (sc->device->lun >> 8) | 0x40,
-		.lun[3] = sc->device->lun & 0xff,
+		.lun[1] = sdev->id,
+		.lun[2] = (sdev->lun >> 8) | 0x40,
+		.lun[3] = sdev->lun & 0xff,
 	};
-	return virtscsi_tmf(vscsi, cmd);
+	rc = virtscsi_tmf(vscsi, cmd);
+	scsi_put_reserved_cmd(reset_sc);
+
+	return rc;
 }
 
 static int virtscsi_device_alloc(struct scsi_device *sdevice)
@@ -679,25 +677,31 @@ static int virtscsi_change_queue_depth(struct scsi_device *sdev, int qdepth)
 
 static int virtscsi_abort(struct scsi_cmnd *sc)
 {
-	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
+	struct scsi_device *sdev = sc->device;
+	struct scsi_cmnd *reset_sc;
+	struct virtio_scsi *vscsi = shost_priv(sdev->host);
 	struct virtio_scsi_cmd *cmd;
+	int rc;
 
 	scmd_printk(KERN_INFO, sc, "abort\n");
-	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
-	if (!cmd)
+	reset_sc = scsi_get_reserved_cmd(sdev, DMA_NONE);
+	if (!reset_sc)
 		return FAILED;
+	cmd = scsi_cmd_priv(reset_sc);
 
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
 		.type = VIRTIO_SCSI_T_TMF,
 		.subtype = VIRTIO_SCSI_T_TMF_ABORT_TASK,
 		.lun[0] = 1,
-		.lun[1] = sc->device->id,
-		.lun[2] = (sc->device->lun >> 8) | 0x40,
-		.lun[3] = sc->device->lun & 0xff,
+		.lun[1] = sdev->id,
+		.lun[2] = (sdev->lun >> 8) | 0x40,
+		.lun[3] = sdev->lun & 0xff,
 		.tag = cpu_to_virtio64(vscsi->vdev, (unsigned long)sc),
 	};
-	return virtscsi_tmf(vscsi, cmd);
+	rc = virtscsi_tmf(vscsi, cmd);
+	scsi_put_reserved_cmd(reset_sc);
+	return rc;
 }
 
 static int virtscsi_map_queues(struct Scsi_Host *shost)
@@ -865,6 +869,11 @@ static int virtscsi_probe(struct virtio_device *vdev)
 		goto virtscsi_init_failed;
 
 	shost->can_queue = virtqueue_get_vring_size(vscsi->req_vqs[0].vq);
+	shost->can_queue -= VIRTIO_SCSI_RESERVED_CMDS;
+	if (shost->can_queue <= 0) {
+		err = -ENOMEM;
+		goto scsi_add_host_failed;
+	}
 
 	cmd_per_lun = virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
 	shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);
@@ -878,6 +887,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	shost->max_channel = 0;
 	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;
 	shost->nr_hw_queues = num_queues;
+	shost->nr_reserved_cmds = VIRTIO_SCSI_RESERVED_CMDS;
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_T10_PI)) {
@@ -979,45 +989,12 @@ static struct virtio_driver virtio_scsi_driver = {
 
 static int __init init(void)
 {
-	int ret = -ENOMEM;
-
-	virtscsi_cmd_cache = KMEM_CACHE(virtio_scsi_cmd, 0);
-	if (!virtscsi_cmd_cache) {
-		pr_err("kmem_cache_create() for virtscsi_cmd_cache failed\n");
-		goto error;
-	}
-
-
-	virtscsi_cmd_pool =
-		mempool_create_slab_pool(VIRTIO_SCSI_MEMPOOL_SZ,
-					 virtscsi_cmd_cache);
-	if (!virtscsi_cmd_pool) {
-		pr_err("mempool_create() for virtscsi_cmd_pool failed\n");
-		goto error;
-	}
-	ret = register_virtio_driver(&virtio_scsi_driver);
-	if (ret < 0)
-		goto error;
-
-	return 0;
-
-error:
-	if (virtscsi_cmd_pool) {
-		mempool_destroy(virtscsi_cmd_pool);
-		virtscsi_cmd_pool = NULL;
-	}
-	if (virtscsi_cmd_cache) {
-		kmem_cache_destroy(virtscsi_cmd_cache);
-		virtscsi_cmd_cache = NULL;
-	}
-	return ret;
+	return register_virtio_driver(&virtio_scsi_driver);
 }
 
 static void __exit fini(void)
 {
 	unregister_virtio_driver(&virtio_scsi_driver);
-	mempool_destroy(virtscsi_cmd_pool);
-	kmem_cache_destroy(virtscsi_cmd_cache);
 }
 module_init(init);
 module_exit(fini);
-- 
2.16.4

