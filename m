From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4/5] virtio-scsi: pass struct virtio_scsi to virtqueue
	completion function
Date: Tue, 28 Aug 2012 13:54:16 +0200
Message-ID: <1346154857-12487-5-git-send-email-pbonzini@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
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
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

This will be needed soon in order to retrieve the per-target
struct.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 62fec04..6414ea0 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -107,7 +107,7 @@ static void virtscsi_compute_resid(struct scsi_cmnd *sc, u32 resid)
  *
  * Called with vq_lock held.
  */
-static void virtscsi_complete_cmd(void *buf)
+static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_cmd *cmd = buf;
 	struct scsi_cmnd *sc = cmd->sc;
@@ -168,7 +168,8 @@ static void virtscsi_complete_cmd(void *buf)
 	sc->scsi_done(sc);
 }
 
-static void virtscsi_vq_done(struct virtqueue *vq, void (*fn)(void *buf))
+static void virtscsi_vq_done(struct virtio_scsi *vscsi, struct virtqueue *vq,
+			     void (*fn)(struct virtio_scsi *vscsi, void *buf))
 {
 	void *buf;
 	unsigned int len;
@@ -176,7 +177,7 @@ static void virtscsi_vq_done(struct virtqueue *vq, void (*fn)(void *buf))
 	do {
 		virtqueue_disable_cb(vq);
 		while ((buf = virtqueue_get_buf(vq, &len)) != NULL)
-			fn(buf);
+			fn(vscsi, buf);
 	} while (!virtqueue_enable_cb(vq));
 }
 
@@ -187,11 +188,11 @@ static void virtscsi_req_done(struct virtqueue *vq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&vscsi->req_vq.vq_lock, flags);
-	virtscsi_vq_done(vq, virtscsi_complete_cmd);
+	virtscsi_vq_done(vscsi, vq, virtscsi_complete_cmd);
 	spin_unlock_irqrestore(&vscsi->req_vq.vq_lock, flags);
 };
 
-static void virtscsi_complete_free(void *buf)
+static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_cmd *cmd = buf;
 
@@ -208,7 +209,7 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&vscsi->ctrl_vq.vq_lock, flags);
-	virtscsi_vq_done(vq, virtscsi_complete_free);
+	virtscsi_vq_done(vscsi, vq, virtscsi_complete_free);
 	spin_unlock_irqrestore(&vscsi->ctrl_vq.vq_lock, flags);
 };
 
@@ -331,7 +332,7 @@ static void virtscsi_handle_event(struct work_struct *work)
 	virtscsi_kick_event(vscsi, event_node);
 }
 
-static void virtscsi_complete_event(void *buf)
+static void virtscsi_complete_event(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_event_node *event_node = buf;
 
@@ -346,7 +347,7 @@ static void virtscsi_event_done(struct virtqueue *vq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
-	virtscsi_vq_done(vq, virtscsi_complete_event);
+	virtscsi_vq_done(vscsi, vq, virtscsi_complete_event);
 	spin_unlock_irqrestore(&vscsi->event_vq.vq_lock, flags);
 };
 
-- 
1.7.1
