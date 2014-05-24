From: Venkatesh Srinivas <venkateshs@google.com>
Subject: [PATCH] virtio-scsi: Implement change_queue_depth for virtscsi targets
Date: Fri, 23 May 2014 18:07:45 -0700
Message-ID: <1400893665-13128-1-git-send-email-venkateshs@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-scsi@vger.kernel.org, pbonzini@redhat.com, nab@daterainc.com, virtualization@lists.linux-foundation.org, martin.petersen@oracle.com, digitaleric@google.com, vsrinivas@ops101.org
List-Id: linux-scsi@vger.kernel.org

change_queue_depth allows changing per-target queue depth via sysfs.

It also allows the SCSI midlayer to ramp down the number of concurrent
inflight requests in response to a SCSI BUSY status response and allows
the midlayer to ramp the count back up to the device maximum when the
BUSY condition has resolved.

Signed-off-by: Venkatesh Srinivas <venkateshs@google.com>
---
 drivers/scsi/virtio_scsi.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index db3b494..6cd39cd 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -26,6 +26,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_tcq.h>
 
 #define VIRTIO_SCSI_MEMPOOL_SZ 64
 #define VIRTIO_SCSI_EVENT_LEN 8
@@ -633,6 +634,36 @@ static int virtscsi_device_reset(struct scsi_cmnd *sc)
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
@@ -684,6 +715,7 @@ static struct scsi_host_template virtscsi_host_template_single = {
 	.proc_name = "virtio_scsi",
 	.this_id = -1,
 	.queuecommand = virtscsi_queuecommand_single,
+	.change_queue_depth = virtscsi_change_queue_depth,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
 
@@ -700,6 +732,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
 	.proc_name = "virtio_scsi",
 	.this_id = -1,
 	.queuecommand = virtscsi_queuecommand_multi,
+	.change_queue_depth = virtscsi_change_queue_depth,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
 
-- 
1.9.1.423.g4596e3a
