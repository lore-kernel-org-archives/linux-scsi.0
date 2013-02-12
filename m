From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 3/5] virtio-scsi: push vq lock/unlock into virtscsi_vq_done
Date: Tue, 12 Feb 2013 14:06:29 +0100
Message-ID: <1360674391-2661-4-git-send-email-pbonzini@redhat.com>
References: <1360674391-2661-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1360674391-2661-1-git-send-email-pbonzini@redhat.com>
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
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, JBottomley@parallels.com, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Avoid duplicated code in all of the callers.

Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 3dd4ec5..3d77210 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -165,28 +165,30 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 	sc->scsi_done(sc);
 }
 
-static void virtscsi_vq_done(struct virtio_scsi *vscsi, struct virtqueue *vq,
+static void virtscsi_vq_done(struct virtio_scsi *vscsi,
+			     struct virtio_scsi_vq *virtscsi_vq,
 			     void (*fn)(struct virtio_scsi *vscsi, void *buf))
 {
 	void *buf;
 	unsigned int len;
+	unsigned long flags;
+	struct virtqueue *vq = virtscsi_vq->vq;
 
+	spin_lock_irqsave(&virtscsi_vq->vq_lock, flags);
 	do {
 		virtqueue_disable_cb(vq);
 		while ((buf = virtqueue_get_buf(vq, &len)) != NULL)
 			fn(vscsi, buf);
 	} while (!virtqueue_enable_cb(vq));
+	spin_unlock_irqrestore(&virtscsi_vq->vq_lock, flags);
 }
 
 static void virtscsi_req_done(struct virtqueue *vq)
 {
 	struct Scsi_Host *sh = virtio_scsi_host(vq->vdev);
 	struct virtio_scsi *vscsi = shost_priv(sh);
-	unsigned long flags;
 
-	spin_lock_irqsave(&vscsi->req_vq.vq_lock, flags);
-	virtscsi_vq_done(vscsi, vq, virtscsi_complete_cmd);
-	spin_unlock_irqrestore(&vscsi->req_vq.vq_lock, flags);
+	virtscsi_vq_done(vscsi, &vscsi->req_vq, virtscsi_complete_cmd);
 };
 
 static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
@@ -203,11 +205,8 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
 {
 	struct Scsi_Host *sh = virtio_scsi_host(vq->vdev);
 	struct virtio_scsi *vscsi = shost_priv(sh);
-	unsigned long flags;
 
-	spin_lock_irqsave(&vscsi->ctrl_vq.vq_lock, flags);
-	virtscsi_vq_done(vscsi, vq, virtscsi_complete_free);
-	spin_unlock_irqrestore(&vscsi->ctrl_vq.vq_lock, flags);
+	virtscsi_vq_done(vscsi, &vscsi->ctrl_vq, virtscsi_complete_free);
 };
 
 static int virtscsi_kick_event(struct virtio_scsi *vscsi,
@@ -342,11 +341,8 @@ static void virtscsi_event_done(struct virtqueue *vq)
 {
 	struct Scsi_Host *sh = virtio_scsi_host(vq->vdev);
 	struct virtio_scsi *vscsi = shost_priv(sh);
-	unsigned long flags;
 
-	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
-	virtscsi_vq_done(vscsi, vq, virtscsi_complete_event);
-	spin_unlock_irqrestore(&vscsi->event_vq.vq_lock, flags);
+	virtscsi_vq_done(vscsi, &vscsi->event_vq, virtscsi_complete_event);
 };
 
 /**
-- 
1.7.1
