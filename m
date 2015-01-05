From: Fam Zheng <famz@redhat.com>
Subject: [PATCH] virtio-scsi: Fix the race condition in virtscsi_handle_event
Date: Mon,  5 Jan 2015 14:04:58 +0800
Message-ID: <1420437898-32419-1-git-send-email-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-scsi@vger.kernel.org

There is a race condition in virtscsi_handle_event, when many device
hotplug/unplug events flush in quickly.

The scsi_remove_device in virtscsi_handle_transport_reset may trigger
the BUG_ON in scsi_target_reap, because the state is altered behind it,
probably by scsi_scan_host of another event. I'm able to reproduce it by
repeatedly plugging and unplugging a scsi disk with the same lun number.

To make is safe, the mutex added in struct virtio_scsi is held in
virtscsi_handle_event, so that all the events are processed in a
synchronized way. With this lock, the panic goes away.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index c52bb5d..7f194d4 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -110,6 +110,9 @@ struct virtio_scsi {
 	/* CPU hotplug notifier */
 	struct notifier_block nb;
 
+	/* Protect the hotplug/unplug event handling */
+	struct mutex scan_lock;
+
 	/* Protected by event_vq lock */
 	bool stop_events;
 
@@ -377,6 +380,7 @@ static void virtscsi_handle_event(struct work_struct *work)
 	struct virtio_scsi *vscsi = event_node->vscsi;
 	struct virtio_scsi_event *event = &event_node->event;
 
+	mutex_lock(&vscsi->scan_lock);
 	if (event->event &
 	    cpu_to_virtio32(vscsi->vdev, VIRTIO_SCSI_T_EVENTS_MISSED)) {
 		event->event &= ~cpu_to_virtio32(vscsi->vdev,
@@ -397,6 +401,7 @@ static void virtscsi_handle_event(struct work_struct *work)
 		pr_err("Unsupport virtio scsi event %x\n", event->event);
 	}
 	virtscsi_kick_event(vscsi, event_node);
+	mutex_unlock(&vscsi->scan_lock);
 }
 
 static void virtscsi_complete_event(struct virtio_scsi *vscsi, void *buf)
@@ -894,6 +899,7 @@ static int virtscsi_init(struct virtio_device *vdev,
 	const char **names;
 	struct virtqueue **vqs;
 
+	mutex_init(&vscsi->scan_lock);
 	num_vqs = vscsi->num_queues + VIRTIO_SCSI_VQ_BASE;
 	vqs = kmalloc(num_vqs * sizeof(struct virtqueue *), GFP_KERNEL);
 	callbacks = kmalloc(num_vqs * sizeof(vq_callback_t *), GFP_KERNEL);
-- 
1.9.3
