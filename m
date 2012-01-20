From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v4 3/3] virtio-scsi: add power management support
Date: Fri, 20 Jan 2012 17:45:39 +0100
Message-ID: <1327077939-7084-4-git-send-email-pbonzini@redhat.com>
References: <1327077939-7084-1-git-send-email-pbonzini@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1327077939-7084-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch adds freeze/restore handlers for the HBA.  Block queues
are managed independently by the disk devices.

Cc: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	The feature has been merged in the virtio core for 3.3, so the patch
	is new in v4.

 drivers/scsi/virtio_scsi.c |   26 +++++++++++++++++++++++---
 1 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 68104cd..efccd72 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -406,8 +406,8 @@ static struct scsi_host_template virtscsi_host_template = {
 				  &__val, sizeof(__val)); \
 	})
 
-static int __devinit virtscsi_init(struct virtio_device *vdev,
-				   struct virtio_scsi *vscsi)
+static int virtscsi_init(struct virtio_device *vdev,
+			 struct virtio_scsi *vscsi)
 {
 	int err;
 	struct virtqueue *vqs[3];
@@ -491,7 +491,7 @@ virtscsi_init_failed:
 	return err;
 }
 
-static void __devexit virtscsi_remove_vqs(struct virtio_device *vdev)
+static void virtscsi_remove_vqs(struct virtio_device *vdev)
 {
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
@@ -509,6 +509,22 @@ static void __devexit virtscsi_remove(struct virtio_device *vdev)
 	scsi_host_put(shost);
 }
 
+#ifdef CONFIG_PM
+static int virtscsi_freeze(struct virtio_device *vdev)
+{
+	virtscsi_remove_vqs(vdev);
+	return 0;
+}
+
+static int virtscsi_restore(struct virtio_device *vdev)
+{
+	struct Scsi_Host *sh = virtio_scsi_host(vdev);
+	struct virtio_scsi *vscsi = shost_priv(sh);
+
+	return virtscsi_init(vdev, vscsi);
+}
+#endif
+
 static struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_SCSI, VIRTIO_DEV_ANY_ID },
 	{ 0 },
@@ -519,6 +535,10 @@ static struct virtio_driver virtio_scsi_driver = {
 	.driver.owner = THIS_MODULE,
 	.id_table = id_table,
 	.probe = virtscsi_probe,
+#ifdef CONFIG_PM
+	.freeze = virtscsi_freeze,
+	.restore = virtscsi_restore,
+#endif
 	.remove = __devexit_p(virtscsi_remove),
 };
 
-- 
1.7.1

