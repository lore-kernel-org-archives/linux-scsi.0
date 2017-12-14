From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] virtio_scsi: Implement 'native LUN' feature
Date: Thu, 14 Dec 2017 11:11:56 +0100
Message-ID: <1513246316-56019-4-git-send-email-hare@suse.de>
References: <1513246316-56019-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50294 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751916AbdLNKMA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Dec 2017 05:12:00 -0500
In-Reply-To: <1513246316-56019-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The 'native LUN' feature allows virtio-scsi to pass in the LUN
numbers from the underlying storage directly, without having
to modify the LUN number itself.
It works by shifting the existing LUN number down by 8 bytes,
and add the virtio-specific 8-byte LUN steering header.
With that virtio doesn't have to mangle the LUN number, allowing
us to pass the 'real' LUN number to the guest.
Of course, we do cut off the last 8 bytes of the 'real' LUN number,
but I'm not aware of any array utilizing that, so the impact should
be negligible.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/virtio_scsi.c       | 62 ++++++++++++++++++++++++++++++----------
 include/uapi/linux/virtio_scsi.h |  1 +
 2 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index f925fbd..63c2c85 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -356,8 +356,12 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
 	unsigned int target = event->lun[1];
-	unsigned int lun = (event->lun[2] << 8) | event->lun[3];
+	u64 lun;
 
+	if (virtio_has_feature(vscsi->vdev, VIRTIO_SCSI_F_NATIVE_LUN))
+		lun = scsilun_to_int((struct scsi_lun *)event->lun) >> 16;
+	else
+		lun = (event->lun[2] << 8) | event->lun[3];
 	switch (virtio32_to_cpu(vscsi->vdev, event->reason)) {
 	case VIRTIO_SCSI_EVT_RESET_RESCAN:
 		scsi_add_device(shost, 0, target, lun);
@@ -368,7 +372,7 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
 			scsi_remove_device(sdev);
 			scsi_device_put(sdev);
 		} else {
-			pr_err("SCSI device %d 0 %d %d not found\n",
+			pr_err("SCSI device %d 0 %d %llu not found\n",
 				shost->host_no, target, lun);
 		}
 		break;
@@ -383,13 +387,17 @@ static void virtscsi_handle_param_change(struct virtio_scsi *vscsi,
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
 	unsigned int target = event->lun[1];
-	unsigned int lun = (event->lun[2] << 8) | event->lun[3];
+	u64 lun;
 	u8 asc = virtio32_to_cpu(vscsi->vdev, event->reason) & 255;
 	u8 ascq = virtio32_to_cpu(vscsi->vdev, event->reason) >> 8;
 
+	if (virtio_has_feature(vscsi->vdev, VIRTIO_SCSI_F_NATIVE_LUN))
+		lun = scsilun_to_int((struct scsi_lun *)event->lun) >> 16;
+	else
+		lun = (event->lun[2] << 8) | event->lun[3];
 	sdev = scsi_device_lookup(shost, 0, target, lun);
 	if (!sdev) {
-		pr_err("SCSI device %d 0 %d %d not found\n",
+		pr_err("SCSI device %d 0 %d %llu not found\n",
 			shost->host_no, target, lun);
 		return;
 	}
@@ -524,10 +532,16 @@ static void virtio_scsi_init_hdr(struct virtio_device *vdev,
 				 int target_id,
 				 struct scsi_cmnd *sc)
 {
-	cmd->lun[0] = 1;
-	cmd->lun[1] = target_id;
-	cmd->lun[2] = (sc->device->lun >> 8) | 0x40;
-	cmd->lun[3] = sc->device->lun & 0xff;
+	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_NATIVE_LUN)) {
+		u64 lun = sc->device->lun << 16;
+		lun |= ((u64)1 << 8) | (u64)target_id;
+		int_to_scsilun(lun, (struct scsi_lun *)&cmd->lun);
+	} else {
+		cmd->lun[0] = 1;
+		cmd->lun[1] = target_id;
+		cmd->lun[2] = (sc->device->lun >> 8) | 0x40;
+		cmd->lun[3] = sc->device->lun & 0xff;
+	}
 	cmd->tag = cpu_to_virtio64(vdev, (unsigned long)sc);
 	cmd->task_attr = VIRTIO_SCSI_S_SIMPLE;
 	cmd->prio = 0;
@@ -776,11 +790,17 @@ static int virtscsi_device_reset(struct scsi_cmnd *sc)
 		.type = VIRTIO_SCSI_T_TMF,
 		.subtype = cpu_to_virtio32(vscsi->vdev,
 					     VIRTIO_SCSI_T_TMF_LOGICAL_UNIT_RESET),
-		.lun[0] = 1,
-		.lun[1] = target_id,
-		.lun[2] = (sc->device->lun >> 8) | 0x40,
-		.lun[3] = sc->device->lun & 0xff,
 	};
+	if (virtio_has_feature(vscsi->vdev, VIRTIO_SCSI_F_NATIVE_LUN)) {
+		u64 lun = sc->device->lun << 16;
+		lun |= ((u64)1 << 8) | (u64)target_id;
+		int_to_scsilun(lun, (struct scsi_lun *)&cmd->req.tmf.lun);
+	} else {
+		cmd->req.tmf.lun[0] = 1;
+		cmd->req.tmf.lun[1] = target_id;
+		cmd->req.tmf.lun[2] = (sc->device->lun >> 8) | 0x40;
+		cmd->req.tmf.lun[3] = sc->device->lun & 0xff;
+	}
 	return virtscsi_tmf(vscsi, cmd);
 }
 
@@ -851,10 +871,18 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
 		.subtype = VIRTIO_SCSI_T_TMF_ABORT_TASK,
 		.lun[0] = 1,
 		.lun[1] = target_id,
-		.lun[2] = (sc->device->lun >> 8) | 0x40,
-		.lun[3] = sc->device->lun & 0xff,
 		.tag = cpu_to_virtio64(vscsi->vdev, (unsigned long)sc),
 	};
+	if (virtio_has_feature(vscsi->vdev, VIRTIO_SCSI_F_NATIVE_LUN)) {
+		u64 lun = sc->device->lun << 16;
+		lun |= ((u64)1 << 8) | (u64)target_id;
+		int_to_scsilun(lun, (struct scsi_lun *)&cmd->req.tmf.lun);
+	} else {
+		cmd->req.tmf.lun[0] = 1;
+		cmd->req.tmf.lun[1] = target_id;
+		cmd->req.tmf.lun[2] = (sc->device->lun >> 8) | 0x40;
+		cmd->req.tmf.lun[3] = sc->device->lun & 0xff;
+	}
 	return virtscsi_tmf(vscsi, cmd);
 }
 
@@ -1429,7 +1457,10 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	/* LUNs > 256 are reported with format 1, so they go in the range
 	 * 16640-32767.
 	 */
-	shost->max_lun = virtscsi_config_get(vdev, max_lun) + 1 + 0x4000;
+	if (!virtio_has_feature(vdev, VIRTIO_SCSI_F_NATIVE_LUN))
+		shost->max_lun = virtscsi_config_get(vdev, max_lun) + 1 + 0x4000;
+	else
+		shost->max_lun = (u64)-1;
 	shost->max_id = num_targets;
 	shost->max_channel = 0;
 	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;
@@ -1522,6 +1553,7 @@ static int virtscsi_restore(struct virtio_device *vdev)
 	VIRTIO_SCSI_F_T10_PI,
 #endif
 	VIRTIO_SCSI_F_RESCAN,
+	VIRTIO_SCSI_F_NATIVE_LUN,
 };
 
 static struct virtio_driver virtio_scsi_driver = {
diff --git a/include/uapi/linux/virtio_scsi.h b/include/uapi/linux/virtio_scsi.h
index 762622e..30d275f 100644
--- a/include/uapi/linux/virtio_scsi.h
+++ b/include/uapi/linux/virtio_scsi.h
@@ -134,6 +134,7 @@ struct virtio_scsi_config {
 #define VIRTIO_SCSI_F_CHANGE                   2
 #define VIRTIO_SCSI_F_T10_PI                   3
 #define VIRTIO_SCSI_F_RESCAN                   4
+#define VIRTIO_SCSI_F_NATIVE_LUN               5
 
 /* Response codes */
 #define VIRTIO_SCSI_S_OK                       0
-- 
1.8.5.6
