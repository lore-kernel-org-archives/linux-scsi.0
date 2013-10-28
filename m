From: Asias He <asias@redhat.com>
Subject: [PATCH] virtio-scsi: Fix hotcpu_notifier use-after-free with
	virtscsi_freeze
Date: Mon, 28 Oct 2013 16:01:03 +0800
Message-ID: <1382947263-22145-1-git-send-email-asias@redhat.com>
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
To: kvm@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

vqs are freed in virtscsi_freeze but the hotcpu_notifier is not
unregistered. We will have a use-after-free usage when the notifier
callback is called after virtscsi_freeze.

Signed-off-by: Asias He <asias@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 74b88ef..b26f1a5 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -957,6 +957,10 @@ static void virtscsi_remove(struct virtio_device *vdev)
 #ifdef CONFIG_PM
 static int virtscsi_freeze(struct virtio_device *vdev)
 {
+	struct Scsi_Host *sh = virtio_scsi_host(vdev);
+	struct virtio_scsi *vscsi = shost_priv(sh);
+
+	unregister_hotcpu_notifier(&vscsi->nb);
 	virtscsi_remove_vqs(vdev);
 	return 0;
 }
@@ -965,8 +969,17 @@ static int virtscsi_restore(struct virtio_device *vdev)
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
1.8.3.1
