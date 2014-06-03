From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6/6] virtio-scsi: Implement change_queue_depth for virtscsi targets
Date: Tue,  3 Jun 2014 21:33:18 +0200
Message-ID: <1401823998-29167-7-git-send-email-pbonzini@redhat.com>
References: <1401823998-29167-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401823998-29167-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, JBottomley@Parallels.com, venkateshs@google.com
List-Id: linux-scsi@vger.kernel.org

From: Venkatesh Srinivas <venkateshs@google.com>

change_queue_depth allows changing per-target queue depth via sysfs.

It also allows the SCSI midlayer to ramp down the number of concurrent
inflight requests in response to a SCSI BUSY status response and allows
the midlayer to ramp the count back up to the device maximum when the
BUSY condition has resolved.

Signed-off-by: Venkatesh Srinivas <venkateshs@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index fda9fb358888..de0f8d9b3682 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -26,6 +26,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_tcq.h>
 #include <linux/seqlock.h>
 
 #define VIRTIO_SCSI_MEMPOOL_SZ 64
@@ -629,6 +630,36 @@ static int virtscsi_device_reset(struct scsi_cmnd *sc)
 	return virtscsi_tmf(vscsi, cmd);
 }
 
+/**
+ * virtscsi_change_queue_depth() - Change a virtscsi target's queue depth
+ * @sdev:	Virtscsi target whose queue depth to change
+ * @qdepth:	New queue depth
+ * @reason:	Reason for the queue depth change.
+ */
+static int virtscsi_change_queue_depth(struct scsi_device *sdev,
+				       int qdepth,
+				       int reason)
+{
+	struct Scsi_Host *shost = sdev->host;
+	int max_depth = shost->cmd_per_lun;
+
+	switch (reason) {
+	case SCSI_QDEPTH_QFULL: /* Drop qdepth in response to BUSY state */
+		scsi_track_queue_full(sdev, qdepth);
+		break;
+	case SCSI_QDEPTH_RAMP_UP: /* Raise qdepth after BUSY state resolved */
+	case SCSI_QDEPTH_DEFAULT: /* Manual change via sysfs */
+		scsi_adjust_queue_depth(sdev,
+					scsi_get_tag_type(sdev),
+					min(max_depth, qdepth));
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return sdev->queue_depth;
+}
+
 static int virtscsi_abort(struct scsi_cmnd *sc)
 {
 	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
@@ -683,6 +714,7 @@ static struct scsi_host_template virtscsi_host_template_single = {
 	.proc_name = "virtio_scsi",
 	.this_id = -1,
 	.queuecommand = virtscsi_queuecommand_single,
+	.change_queue_depth = virtscsi_change_queue_depth,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
 
@@ -699,6 +731,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
 	.proc_name = "virtio_scsi",
 	.this_id = -1,
 	.queuecommand = virtscsi_queuecommand_multi,
+	.change_queue_depth = virtscsi_change_queue_depth,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
 
-- 
1.8.3.1
