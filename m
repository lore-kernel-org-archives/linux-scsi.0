From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v5 2/3] virtio-scsi: add error handling
Date: Sun,  5 Feb 2012 12:16:01 +0100
Message-ID: <1328440562-19425-3-git-send-email-pbonzini@redhat.com>
References: <1328440562-19425-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62138 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab2BELQK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Feb 2012 06:16:10 -0500
In-Reply-To: <1328440562-19425-1-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, Pekka Enberg <penberg@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org

This commit adds basic error handling to the virtio-scsi
HBA device.  Task management functions are sent synchronously
via the control virtqueue.

Cc: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: kvm@vger.kernel.org
Acked-by: Pekka Enberg <penberg@kernel.org> 
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v3->v4: fixed 32-bit compilation; adjusted call to virtscsi_kick_cmd

	v2->v3: added mempool, used GFP_NOIO instead of GFP_ATOMIC,
	formatting fixes

	v1->v2: use scmd_printk

 drivers/scsi/virtio_scsi.c |   73 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 72 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 3f87ae0..68104cd 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -29,6 +29,7 @@
 /* Command queue element */
 struct virtio_scsi_cmd {
 	struct scsi_cmnd *sc;
+	struct completion *comp;
 	union {
 		struct virtio_scsi_cmd_req       cmd;
 		struct virtio_scsi_ctrl_tmf_req  tmf;
@@ -168,11 +169,12 @@ static void virtscsi_req_done(struct virtqueue *vq)
 	virtscsi_vq_done(vq, virtscsi_complete_cmd);
 };
 
-/* These are still stubs.  */
 static void virtscsi_complete_free(void *buf)
 {
 	struct virtio_scsi_cmd *cmd = buf;
 
+	if (cmd->comp)
+		complete_all(cmd->comp);
 	mempool_free(cmd, virtscsi_cmd_pool);
 }
 
@@ -306,12 +308,81 @@ out:
 	return ret;
 }
 
+static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
+{
+	DECLARE_COMPLETION_ONSTACK(comp);
+	int ret;
+
+	cmd->comp = &comp;
+	ret = virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd,
+			       sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
+			       GFP_NOIO);
+	if (ret < 0)
+		return FAILED;
+
+	wait_for_completion(&comp);
+	if (cmd->resp.tmf.response != VIRTIO_SCSI_S_OK &&
+	    cmd->resp.tmf.response != VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
+		return FAILED;
+
+	return SUCCESS;
+}
+
+static int virtscsi_device_reset(struct scsi_cmnd *sc)
+{
+	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
+	struct virtio_scsi_cmd *cmd;
+
+	sdev_printk(KERN_INFO, sc->device, "device reset\n");
+	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
+	if (!cmd)
+		return FAILED;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->sc = sc;
+	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
+		.type = VIRTIO_SCSI_T_TMF,
+		.subtype = VIRTIO_SCSI_T_TMF_LOGICAL_UNIT_RESET,
+		.lun[0] = 1,
+		.lun[1] = sc->device->id,
+		.lun[2] = (sc->device->lun >> 8) | 0x40,
+		.lun[3] = sc->device->lun & 0xff,
+	};
+	return virtscsi_tmf(vscsi, cmd);
+}
+
+static int virtscsi_abort(struct scsi_cmnd *sc)
+{
+	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
+	struct virtio_scsi_cmd *cmd;
+
+	scmd_printk(KERN_INFO, sc, "abort\n");
+	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
+	if (!cmd)
+		return FAILED;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->sc = sc;
+	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
+		.type = VIRTIO_SCSI_T_TMF,
+		.subtype = VIRTIO_SCSI_T_TMF_ABORT_TASK,
+		.lun[0] = 1,
+		.lun[1] = sc->device->id,
+		.lun[2] = (sc->device->lun >> 8) | 0x40,
+		.lun[3] = sc->device->lun & 0xff,
+		.tag = (unsigned long)sc,
+	};
+	return virtscsi_tmf(vscsi, cmd);
+}
+
 static struct scsi_host_template virtscsi_host_template = {
 	.module = THIS_MODULE,
 	.name = "Virtio SCSI HBA",
 	.proc_name = "virtio_scsi",
 	.queuecommand = virtscsi_queuecommand,
 	.this_id = -1,
+	.eh_abort_handler = virtscsi_abort,
+	.eh_device_reset_handler = virtscsi_device_reset,
 
 	.can_queue = 1024,
 	.dma_boundary = UINT_MAX,
-- 
1.7.1


