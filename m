From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 6/6] virtio-scsi: Enable DIF/DIX modes in SCSI host LLD
Date: Mon, 24 Feb 2014 05:32:30 +0000
Message-ID: <1393219950-18613-7-git-send-email-nab@daterainc.com>
References: <1393219950-18613-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1393219950-18613-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates virtscsi_probe() to setup all necessary Scsi_Host
level protection resources necessary to enable DIF on virtio-scsi
<-> vhost-scsi LUNs.  Currently hardcoded to 1.

It changes virtscsi_add_cmd() so that outgoing / incoming protection
SGLs are attached after each data payload, and is currently using the
unused virtio_scsi_cmd_req->prio bits to signal the total number of
prot_sgl_count for vhost/scsi to expect.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/virtio_scsi.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 16bfd50..294466d 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -440,7 +440,7 @@ static int virtscsi_add_cmd(struct virtqueue *vq,
 			    size_t req_size, size_t resp_size, gfp_t gfp)
 {
 	struct scsi_cmnd *sc = cmd->sc;
-	struct scatterlist *sgs[4], req, resp;
+	struct scatterlist *sgs[6], req, resp;
 	struct sg_table *out, *in;
 	unsigned out_num = 0, in_num = 0;
 
@@ -458,16 +458,22 @@ static int virtscsi_add_cmd(struct virtqueue *vq,
 	sgs[out_num++] = &req;
 
 	/* Data-out buffer.  */
-	if (out)
+	if (out) {
 		sgs[out_num++] = out->sgl;
+		if (scsi_prot_sg_count(sc))
+			sgs[out_num++] = scsi_prot_sglist(sc);
+	}
 
 	/* Response header.  */
 	sg_init_one(&resp, &cmd->resp, resp_size);
 	sgs[out_num + in_num++] = &resp;
 
 	/* Data-in buffer */
-	if (in)
+	if (in) {
 		sgs[out_num + in_num++] = in->sgl;
+		if (scsi_prot_sg_count(sc))
+			sgs[out_num + in_num++] = scsi_prot_sglist(sc);
+	}
 
 	return virtqueue_add_sgs(vq, sgs, out_num, in_num, cmd, gfp);
 }
@@ -498,6 +504,7 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 {
 	struct virtio_scsi_cmd *cmd;
 	int ret;
+	u8 prio = 0;
 
 	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
 	BUG_ON(scsi_sg_count(sc) > shost->sg_tablesize);
@@ -515,6 +522,10 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->sc = sc;
+
+	if (scsi_prot_sg_count(sc))
+		prio = (u8)scsi_prot_sg_count(sc);
+
 	cmd->req.cmd = (struct virtio_scsi_cmd_req){
 		.lun[0] = 1,
 		.lun[1] = sc->device->id,
@@ -522,7 +533,7 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 		.lun[3] = sc->device->lun & 0xff,
 		.tag = (unsigned long)sc,
 		.task_attr = VIRTIO_SCSI_S_SIMPLE,
-		.prio = 0,
+		.prio = prio,
 		.crn = 0,
 	};
 
@@ -871,7 +882,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 {
 	struct Scsi_Host *shost;
 	struct virtio_scsi *vscsi;
-	int err;
+	int err, host_prot;
 	u32 sg_elems, num_targets;
 	u32 cmd_per_lun;
 	u32 num_queues;
@@ -921,6 +932,17 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	shost->max_id = num_targets;
 	shost->max_channel = 0;
 	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;
+
+	/* FIXME: Figure out why this is broken.. */
+	if (1 || virtio_has_feature(vdev, VIRTIO_SCSI_F_T10_PI)) {
+		host_prot = SHOST_DIF_TYPE1_PROTECTION | SHOST_DIF_TYPE2_PROTECTION |
+			    SHOST_DIF_TYPE3_PROTECTION | SHOST_DIX_TYPE1_PROTECTION |
+			    SHOST_DIX_TYPE2_PROTECTION | SHOST_DIX_TYPE3_PROTECTION;
+
+		scsi_host_set_prot(shost, host_prot);
+		scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
+	}
+
 	err = scsi_add_host(shost, &vdev->dev);
 	if (err)
 		goto scsi_add_host_failed;
@@ -990,6 +1012,7 @@ static struct virtio_device_id id_table[] = {
 static unsigned int features[] = {
 	VIRTIO_SCSI_F_HOTPLUG,
 	VIRTIO_SCSI_F_CHANGE,
+	VIRTIO_SCSI_F_T10_PI,
 };
 
 static struct virtio_driver virtio_scsi_driver = {
-- 
1.7.10.4
