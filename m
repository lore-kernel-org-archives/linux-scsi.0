From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3/4] virtio-scsi: release sg_lock after add_buf
Date: Wed, 13 Jun 2012 16:56:33 +0200
Message-ID: <1339599394-13880-4-git-send-email-pbonzini@redhat.com>
References: <1339599394-13880-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339599394-13880-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We do not need the sglist after calling virtqueue_add_buf.  Hence we
can "pipeline" the locked operations and start preparing the sglist
for the next request while we kick the virtqueue.

Together with the previous two patches, this improves performance as
follows.  For a simple "if=/dev/sda of=/dev/null bs=128M iflag=direct"
(the source being a 10G disk, residing entirely in the host buffer cache),
the additional locking does not cause any penalty with only one dd
process, but 2 simultaneous I/O operations improve their times by 3%:

               number of simultaneous dd
                   1               2
 ----------------------------------------
 current        5.9958s        10.2640s
 patched        5.9531s         9.8663s

(Times are best of 10).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 0ecf95e..facfc90 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -281,11 +281,11 @@ static int virtscsi_kick_cmd(struct virtio_scsi *vscsi, struct virtio_scsi_vq *v
 
 	spin_lock(&vq->vq_lock);
 	ret = virtqueue_add_buf(vq->vq, vscsi->sg, out_num, in_num, cmd, gfp);
+	spin_unlock(&vscsi->sg_lock);
 	if (ret >= 0)
 		ret = virtqueue_kick_prepare(vq->vq);
 
-	spin_unlock(&vq->vq_lock);
-	spin_unlock_irqrestore(&vscsi->sg_lock, flags);
+	spin_unlock_irqrestore(&vq->vq_lock, flags);
 
 	if (ret > 0)
 		virtqueue_notify(vq->vq);
-- 
1.7.1
