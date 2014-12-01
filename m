From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v8 42/50] virtio_scsi: v1.0 support
Date: Mon, 1 Dec 2014 18:06:18 +0200
Message-ID: <1417449619-24896-43-git-send-email-mst@redhat.com>
References: <1417449619-24896-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1417449619-24896-1-git-send-email-mst@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: thuth@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, rusty@au1.ibm.com, virtualization@lists.linux-foundation.org, dahi@linux.vnet.ibm.com, "James E.J. Bottomley" <JBottomley@parallels.com>, pbonzini@redhat.com, David Miller <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

Note: for consistency, and to avoid sparse errors,
  convert all fields, even those no longer in use
  for virtio v1.0.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/virtio_scsi.h | 32 +++++++++++++++-------------
 drivers/scsi/virtio_scsi.c  | 51 ++++++++++++++++++++++++++++-----------------
 2 files changed, 49 insertions(+), 34 deletions(-)

diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
index de429d1..af44864 100644
--- a/include/linux/virtio_scsi.h
+++ b/include/linux/virtio_scsi.h
@@ -27,13 +27,15 @@
 #ifndef _LINUX_VIRTIO_SCSI_H
 #define _LINUX_VIRTIO_SCSI_H
 
+#include <linux/virtio_types.h>
+
 #define VIRTIO_SCSI_CDB_SIZE   32
 #define VIRTIO_SCSI_SENSE_SIZE 96
 
 /* SCSI command request, followed by data-out */
 struct virtio_scsi_cmd_req {
 	u8 lun[8];		/* Logical Unit Number */
-	u64 tag;		/* Command identifier */
+	__virtio64 tag;		/* Command identifier */
 	u8 task_attr;		/* Task attribute */
 	u8 prio;		/* SAM command priority field */
 	u8 crn;
@@ -43,20 +45,20 @@ struct virtio_scsi_cmd_req {
 /* SCSI command request, followed by protection information */
 struct virtio_scsi_cmd_req_pi {
 	u8 lun[8];		/* Logical Unit Number */
-	u64 tag;		/* Command identifier */
+	__virtio64 tag;		/* Command identifier */
 	u8 task_attr;		/* Task attribute */
 	u8 prio;		/* SAM command priority field */
 	u8 crn;
-	u32 pi_bytesout;	/* DataOUT PI Number of bytes */
-	u32 pi_bytesin;		/* DataIN PI Number of bytes */
+	__virtio32 pi_bytesout;	/* DataOUT PI Number of bytes */
+	__virtio32 pi_bytesin;		/* DataIN PI Number of bytes */
 	u8 cdb[VIRTIO_SCSI_CDB_SIZE];
 } __packed;
 
 /* Response, followed by sense data and data-in */
 struct virtio_scsi_cmd_resp {
-	u32 sense_len;		/* Sense data length */
-	u32 resid;		/* Residual bytes in data buffer */
-	u16 status_qualifier;	/* Status qualifier */
+	__virtio32 sense_len;		/* Sense data length */
+	__virtio32 resid;		/* Residual bytes in data buffer */
+	__virtio16 status_qualifier;	/* Status qualifier */
 	u8 status;		/* Command completion status */
 	u8 response;		/* Response values */
 	u8 sense[VIRTIO_SCSI_SENSE_SIZE];
@@ -64,10 +66,10 @@ struct virtio_scsi_cmd_resp {
 
 /* Task Management Request */
 struct virtio_scsi_ctrl_tmf_req {
-	u32 type;
-	u32 subtype;
+	__virtio32 type;
+	__virtio32 subtype;
 	u8 lun[8];
-	u64 tag;
+	__virtio64 tag;
 } __packed;
 
 struct virtio_scsi_ctrl_tmf_resp {
@@ -76,20 +78,20 @@ struct virtio_scsi_ctrl_tmf_resp {
 
 /* Asynchronous notification query/subscription */
 struct virtio_scsi_ctrl_an_req {
-	u32 type;
+	__virtio32 type;
 	u8 lun[8];
-	u32 event_requested;
+	__virtio32 event_requested;
 } __packed;
 
 struct virtio_scsi_ctrl_an_resp {
-	u32 event_actual;
+	__virtio32 event_actual;
 	u8 response;
 } __packed;
 
 struct virtio_scsi_event {
-	u32 event;
+	__virtio32 event;
 	u8 lun[8];
-	u32 reason;
+	__virtio32 reason;
 } __packed;
 
 struct virtio_scsi_config {
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index b83846f..d9ec806 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -158,7 +158,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 		sc, resp->response, resp->status, resp->sense_len);
 
 	sc->result = resp->status;
-	virtscsi_compute_resid(sc, resp->resid);
+	virtscsi_compute_resid(sc, virtio32_to_cpu(vscsi->vdev, resp->resid));
 	switch (resp->response) {
 	case VIRTIO_SCSI_S_OK:
 		set_host_byte(sc, DID_OK);
@@ -196,10 +196,13 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 		break;
 	}
 
-	WARN_ON(resp->sense_len > VIRTIO_SCSI_SENSE_SIZE);
+	WARN_ON(virtio32_to_cpu(vscsi->vdev, resp->sense_len) >
+		VIRTIO_SCSI_SENSE_SIZE);
 	if (sc->sense_buffer) {
 		memcpy(sc->sense_buffer, resp->sense,
-		       min_t(u32, resp->sense_len, VIRTIO_SCSI_SENSE_SIZE));
+		       min_t(u32,
+			     virtio32_to_cpu(vscsi->vdev, resp->sense_len),
+			     VIRTIO_SCSI_SENSE_SIZE));
 		if (resp->sense_len)
 			set_driver_byte(sc, DRIVER_SENSE);
 	}
@@ -323,7 +326,7 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
 	unsigned int target = event->lun[1];
 	unsigned int lun = (event->lun[2] << 8) | event->lun[3];
 
-	switch (event->reason) {
+	switch (virtio32_to_cpu(vscsi->vdev, event->reason)) {
 	case VIRTIO_SCSI_EVT_RESET_RESCAN:
 		scsi_add_device(shost, 0, target, lun);
 		break;
@@ -349,8 +352,8 @@ static void virtscsi_handle_param_change(struct virtio_scsi *vscsi,
 	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
 	unsigned int target = event->lun[1];
 	unsigned int lun = (event->lun[2] << 8) | event->lun[3];
-	u8 asc = event->reason & 255;
-	u8 ascq = event->reason >> 8;
+	u8 asc = virtio32_to_cpu(vscsi->vdev, event->reason) & 255;
+	u8 ascq = virtio32_to_cpu(vscsi->vdev, event->reason) >> 8;
 
 	sdev = scsi_device_lookup(shost, 0, target, lun);
 	if (!sdev) {
@@ -374,12 +377,14 @@ static void virtscsi_handle_event(struct work_struct *work)
 	struct virtio_scsi *vscsi = event_node->vscsi;
 	struct virtio_scsi_event *event = &event_node->event;
 
-	if (event->event & VIRTIO_SCSI_T_EVENTS_MISSED) {
-		event->event &= ~VIRTIO_SCSI_T_EVENTS_MISSED;
+	if (event->event &
+	    cpu_to_virtio32(vscsi->vdev, VIRTIO_SCSI_T_EVENTS_MISSED)) {
+		event->event &= ~cpu_to_virtio32(vscsi->vdev,
+						   VIRTIO_SCSI_T_EVENTS_MISSED);
 		scsi_scan_host(virtio_scsi_host(vscsi->vdev));
 	}
 
-	switch (event->event) {
+	switch (virtio32_to_cpu(vscsi->vdev, event->event)) {
 	case VIRTIO_SCSI_T_NO_EVENT:
 		break;
 	case VIRTIO_SCSI_T_TRANSPORT_RESET:
@@ -482,26 +487,28 @@ static int virtscsi_kick_cmd(struct virtio_scsi_vq *vq,
 	return err;
 }
 
-static void virtio_scsi_init_hdr(struct virtio_scsi_cmd_req *cmd,
+static void virtio_scsi_init_hdr(struct virtio_device *vdev,
+				 struct virtio_scsi_cmd_req *cmd,
 				 struct scsi_cmnd *sc)
 {
 	cmd->lun[0] = 1;
 	cmd->lun[1] = sc->device->id;
 	cmd->lun[2] = (sc->device->lun >> 8) | 0x40;
 	cmd->lun[3] = sc->device->lun & 0xff;
-	cmd->tag = (unsigned long)sc;
+	cmd->tag = cpu_to_virtio64(vdev, (unsigned long)sc);
 	cmd->task_attr = VIRTIO_SCSI_S_SIMPLE;
 	cmd->prio = 0;
 	cmd->crn = 0;
 }
 
-static void virtio_scsi_init_hdr_pi(struct virtio_scsi_cmd_req_pi *cmd_pi,
+static void virtio_scsi_init_hdr_pi(struct virtio_device *vdev,
+				    struct virtio_scsi_cmd_req_pi *cmd_pi,
 				    struct scsi_cmnd *sc)
 {
 	struct request *rq = sc->request;
 	struct blk_integrity *bi;
 
-	virtio_scsi_init_hdr((struct virtio_scsi_cmd_req *)cmd_pi, sc);
+	virtio_scsi_init_hdr(vdev, (struct virtio_scsi_cmd_req *)cmd_pi, sc);
 
 	if (!rq || !scsi_prot_sg_count(sc))
 		return;
@@ -509,9 +516,13 @@ static void virtio_scsi_init_hdr_pi(struct virtio_scsi_cmd_req_pi *cmd_pi,
 	bi = blk_get_integrity(rq->rq_disk);
 
 	if (sc->sc_data_direction == DMA_TO_DEVICE)
-		cmd_pi->pi_bytesout = blk_rq_sectors(rq) * bi->tuple_size;
+		cmd_pi->pi_bytesout = cpu_to_virtio32(vdev,
+							blk_rq_sectors(rq) *
+							bi->tuple_size);
 	else if (sc->sc_data_direction == DMA_FROM_DEVICE)
-		cmd_pi->pi_bytesin = blk_rq_sectors(rq) * bi->tuple_size;
+		cmd_pi->pi_bytesin = cpu_to_virtio32(vdev,
+						       blk_rq_sectors(rq) *
+						       bi->tuple_size);
 }
 
 static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
@@ -536,11 +547,11 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
 
 	if (virtio_has_feature(vscsi->vdev, VIRTIO_SCSI_F_T10_PI)) {
-		virtio_scsi_init_hdr_pi(&cmd->req.cmd_pi, sc);
+		virtio_scsi_init_hdr_pi(vscsi->vdev, &cmd->req.cmd_pi, sc);
 		memcpy(cmd->req.cmd_pi.cdb, sc->cmnd, sc->cmd_len);
 		req_size = sizeof(cmd->req.cmd_pi);
 	} else {
-		virtio_scsi_init_hdr(&cmd->req.cmd, sc);
+		virtio_scsi_init_hdr(vscsi->vdev, &cmd->req.cmd, sc);
 		memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
 		req_size = sizeof(cmd->req.cmd);
 	}
@@ -655,7 +666,8 @@ static int virtscsi_device_reset(struct scsi_cmnd *sc)
 	cmd->sc = sc;
 	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
 		.type = VIRTIO_SCSI_T_TMF,
-		.subtype = VIRTIO_SCSI_T_TMF_LOGICAL_UNIT_RESET,
+		.subtype = cpu_to_virtio32(vscsi->vdev,
+					     VIRTIO_SCSI_T_TMF_LOGICAL_UNIT_RESET),
 		.lun[0] = 1,
 		.lun[1] = sc->device->id,
 		.lun[2] = (sc->device->lun >> 8) | 0x40,
@@ -713,7 +725,7 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
 		.lun[1] = sc->device->id,
 		.lun[2] = (sc->device->lun >> 8) | 0x40,
 		.lun[3] = sc->device->lun & 0xff,
-		.tag = (unsigned long)sc,
+		.tag = cpu_to_virtio64(vscsi->vdev, (unsigned long)sc),
 	};
 	return virtscsi_tmf(vscsi, cmd);
 }
@@ -1073,6 +1085,7 @@ static unsigned int features[] = {
 	VIRTIO_SCSI_F_HOTPLUG,
 	VIRTIO_SCSI_F_CHANGE,
 	VIRTIO_SCSI_F_T10_PI,
+	VIRTIO_F_VERSION_1,
 };
 
 static struct virtio_driver virtio_scsi_driver = {
-- 
MST
