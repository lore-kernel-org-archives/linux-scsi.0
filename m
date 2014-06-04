From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 3/6] virtio-scsi: avoid cancelling uninitialized work items
Date: Wed,  4 Jun 2014 12:11:40 +0200
Message-ID: <1401876703-10236-4-git-send-email-pbonzini@redhat.com>
References: <1401876703-10236-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401876703-10236-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, JBottomley@Parallels.com, venkateshs@google.com
List-Id: linux-scsi@vger.kernel.org

Calling the workqueue interface on uninitialized work items isn't a
good idea even if they're zeroed. It's not failing catastrophically only
through happy accidents.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index f0b4cdbfceb0..d66c4ee2c774 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -253,6 +253,8 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
 	virtscsi_vq_done(vscsi, &vscsi->ctrl_vq, virtscsi_complete_free);
 };
 
+static void virtscsi_handle_event(struct work_struct *work);
+
 static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 			       struct virtio_scsi_event_node *event_node)
 {
@@ -260,6 +262,7 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 	struct scatterlist sg;
 	unsigned long flags;
 
+	INIT_WORK(&event_node->work, virtscsi_handle_event);
 	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
 
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
@@ -377,7 +380,6 @@ static void virtscsi_complete_event(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_event_node *event_node = buf;
 
-	INIT_WORK(&event_node->work, virtscsi_handle_event);
 	schedule_work(&event_node->work);
 }
 
-- 
1.8.3.1
