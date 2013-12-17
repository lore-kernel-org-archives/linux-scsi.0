From: Jason Wang <jasowang@redhat.com>
Subject: [PATCH V2] virtio-scsi: Fix hotcpu_notifier use-after-free with
	virtscsi_freeze
Date: Tue, 17 Dec 2013 13:36:08 +0800
Message-ID: <1387258568-11309-1-git-send-email-jasowang@redhat.com>
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
To: kvm@vger.kernel.org, rusty@rustcorp.com.au
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

From: Asias He <asias.hejun@gmail.com>

vqs are freed in virtscsi_freeze but the hotcpu_notifier is not
unregistered. We will have a use-after-free usage when the notifier
callback is called after virtscsi_freeze.

Fixes: 285e71ea6f3583a85e27cb2b9a7d8c35d4c0d558
("virtio-scsi: reset virtqueue affinity when doing cpu hotplug")

Cc: stable@vger.kernel.org
Signed-off-by: Asias He <asias.hejun@gmail.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes from V1:
- Add "Fixes" line
- CC stable
---
 drivers/scsi/virtio_scsi.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index c3173dc..16bfd50 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -956,6 +956,10 @@ static void virtscsi_remove(struct virtio_device *vdev)
 #ifdef CONFIG_PM_SLEEP
 static int virtscsi_freeze(struct virtio_device *vdev)
 {
+	struct Scsi_Host *sh = virtio_scsi_host(vdev);
+	struct virtio_scsi *vscsi = shost_priv(sh);
+
+	unregister_hotcpu_notifier(&vscsi->nb);
 	virtscsi_remove_vqs(vdev);
 	return 0;
 }
@@ -964,8 +968,17 @@ static int virtscsi_restore(struct virtio_device *vdev)
 {
 	struct Scsi_Host *sh = virtio_scsi_host(vdev);
 	struct virtio_scsi *vscsi = shost_priv(sh);
+	int err;
+
+	err = virtscsi_init(vdev, vscsi);
+	if (err)
+		return err;
+
+	err = register_hotcpu_notifier(&vscsi->nb);
+	if (err)
+		vdev->config->del_vqs(vdev);
 
-	return virtscsi_init(vdev, vscsi);
+	return err;
 }
 #endif
 
-- 
1.8.3.2
