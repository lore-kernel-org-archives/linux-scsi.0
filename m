From: Cong Meng <mc@linux.vnet.ibm.com>
Subject: [PATCH] virtio-scsi: hotplug suppot for virtio-scsi
Date: Wed, 20 Jun 2012 14:55:33 +0800
Message-ID: <1340175333-16803-1-git-send-email-mc@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, stefanha@linux.vnet.ibm.com, linuxram@us.ibm.com, Anthony Liguori <anthony@codemonkey.ws>, senwang@linux.vnet.ibm.com, zwanp@cn.ibm.com, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Cong Meng <mc@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

This patch implements the hotplug support for virtio-scsi.
When there is a device attached/detached, the virtio-scsi driver will be
signaled via event virtual queue and it will add/remove the scsi device 
in question automatically.

Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
Signed-off-by: Sen Wang <senwang@linux.vnet.ibm.com>
---
 drivers/scsi/virtio_scsi.c  |  109 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/virtio_scsi.h |    9 ++++
 2 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 1b38431..6dad625 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -25,6 +25,7 @@
 #include <scsi/scsi_cmnd.h>
 
 #define VIRTIO_SCSI_MEMPOOL_SZ 64
+#define VIRTIO_SCSI_EVENT_LEN 8
 
 /* Command queue element */
 struct virtio_scsi_cmd {
@@ -43,9 +44,15 @@ struct virtio_scsi_cmd {
 	} resp;
 } ____cacheline_aligned_in_smp;
 
+struct virtio_scsi_event_node {
+	struct virtio_scsi *vscsi;
+	struct virtio_scsi_event event;
+	struct work_struct work;
+};
+
 /* Driver instance state */
 struct virtio_scsi {
-	/* Protects ctrl_vq, req_vq and sg[] */
+	/* Protects ctrl_vq, event_vq, req_vq and sg[] */
 	spinlock_t vq_lock;
 
 	struct virtio_device *vdev;
@@ -53,6 +60,9 @@ struct virtio_scsi {
 	struct virtqueue *event_vq;
 	struct virtqueue *req_vq;
 
+	/* Get some buffers reday for event vq */
+	struct virtio_scsi_event_node event_list[VIRTIO_SCSI_EVENT_LEN];
+
 	/* For sglist construction when adding commands to the virtqueue.  */
 	struct scatterlist sg[];
 };
@@ -184,9 +194,93 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
 	virtscsi_vq_done(vq, virtscsi_complete_free);
 };
 
+static int virtscsi_kick_event(struct virtio_scsi *vscsi,
+			       struct virtio_scsi_event_node *event_node)
+{
+	int ret;
+	struct scatterlist sg;
+	unsigned long flags;
+
+	sg_set_buf(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
+
+	spin_lock_irqsave(&vscsi->vq_lock, flags);
+
+	ret = virtqueue_add_buf(vscsi->event_vq, &sg, 0, 1, event_node, GFP_ATOMIC);
+	if (ret >= 0)
+		virtqueue_kick(vscsi->event_vq);
+
+	spin_unlock_irqrestore(&vscsi->vq_lock, flags);
+
+	return ret;
+}
+
+static int virtscsi_kick_event_all(struct virtio_scsi *vscsi)
+{
+	int i;
+
+	for (i = 0; i < VIRTIO_SCSI_EVENT_LEN; i++) {
+		vscsi->event_list[i].vscsi = vscsi;
+		virtscsi_kick_event(vscsi, &vscsi->event_list[i]);
+	}
+
+	return 0;
+}
+
+static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
+                                            struct virtio_scsi_event *event)
+{
+	struct scsi_device *sdev;
+	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
+	unsigned int target = event->lun[1];
+	unsigned int lun = (event->lun[2] << 8) | event->lun[3];
+
+	switch (event->reason) {
+	case VIRTIO_SCSI_EVT_RESET_RESCAN:
+		scsi_add_device(shost, 0, target, lun);
+		break;
+	case VIRTIO_SCSI_EVT_RESET_REMOVED:
+		sdev = scsi_device_lookup(shost, 0, target, lun);
+		if (sdev) {
+			scsi_remove_device(sdev);
+			scsi_device_put(sdev);
+		} else {
+			pr_err("SCSI device %d 0 %d %d not found\n",
+				shost->host_no, target, lun);
+		}
+		break;
+	default:
+		pr_info("Unsupport virtio scsi event reason %x\n", event->reason);
+	}
+}
+
+static void virtscsi_handle_event(struct work_struct *work)
+{
+	struct virtio_scsi_event_node *event_node = 
+		container_of(work, struct virtio_scsi_event_node, work);
+	struct virtio_scsi *vscsi = event_node->vscsi;
+	struct virtio_scsi_event *event = &event_node->event;
+
+	switch (event->event) {
+	case VIRTIO_SCSI_T_TRANSPORT_RESET:
+		virtscsi_handle_transport_reset(vscsi, event);
+		break;
+	default:
+		pr_err("Unsupport virtio scsi event %x\n", event->event);
+	}
+	virtscsi_kick_event(vscsi, event_node);
+}
+
+static void virtscsi_complete_event(void *buf)
+{
+	struct virtio_scsi_event_node *event_node = buf;
+
+	INIT_WORK(&event_node->work, virtscsi_handle_event);
+	schedule_work(&event_node->work);
+}
+
 static void virtscsi_event_done(struct virtqueue *vq)
 {
-	virtscsi_vq_done(vq, virtscsi_complete_free);
+	virtscsi_vq_done(vq, virtscsi_complete_event);
 };
 
 static void virtscsi_map_sgl(struct scatterlist *sg, unsigned int *p_idx,
@@ -435,6 +529,11 @@ static int virtscsi_init(struct virtio_device *vdev,
 
 	virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
 	virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
+
+	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG)) {
+		virtscsi_kick_event_all(vscsi);
+	}
+
 	return 0;
 }
 
@@ -532,7 +631,13 @@ static struct virtio_device_id id_table[] = {
 	{ 0 },
 };
 
+static unsigned int features[] = {
+	VIRTIO_SCSI_F_HOTPLUG
+};
+
 static struct virtio_driver virtio_scsi_driver = {
+	.feature_table = features,
+	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name = KBUILD_MODNAME,
 	.driver.owner = THIS_MODULE,
 	.id_table = id_table,
diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
index 8ddeafd..dc8d305 100644
--- a/include/linux/virtio_scsi.h
+++ b/include/linux/virtio_scsi.h
@@ -69,6 +69,10 @@ struct virtio_scsi_config {
 	u32 max_lun;
 } __packed;
 
+/* Feature Bits */
+#define VIRTIO_SCSI_F_INOUT                    0
+#define VIRTIO_SCSI_F_HOTPLUG                  1
+
 /* Response codes */
 #define VIRTIO_SCSI_S_OK                       0
 #define VIRTIO_SCSI_S_OVERRUN                  1
@@ -105,6 +109,11 @@ struct virtio_scsi_config {
 #define VIRTIO_SCSI_T_TRANSPORT_RESET          1
 #define VIRTIO_SCSI_T_ASYNC_NOTIFY             2
 
+/* Reasons of transport reset event */
+#define VIRTIO_SCSI_EVT_RESET_HARD             0
+#define VIRTIO_SCSI_EVT_RESET_RESCAN           1
+#define VIRTIO_SCSI_EVT_RESET_REMOVED          2
+
 #define VIRTIO_SCSI_S_SIMPLE                   0
 #define VIRTIO_SCSI_S_ORDERED                  1
 #define VIRTIO_SCSI_S_HEAD                     2
-- 
1.7.7.6
