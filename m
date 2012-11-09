From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] virtio-scsi: Fix incorrect lock release order in virtscsi_kick_cmd
Date: Fri,  9 Nov 2012 06:29:52 +0000
Message-ID: <1352442592-2162-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <JBottomley@Parallels.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a regression bug in virtscsi_kick_cmd() that relinquishes
the acquired spinlocks in the incorrect order using the wrong spin_unlock
macros, namely releasing vq->vq_lock before tgt->tgt_lock while invoking
the calls to virtio_ring.c:virtqueue_add_buf() and friends.

This bug was originally introduced in v3.5-rc7 code with:

commit 2bd37f0fde99cbf8b78fb55f1128e8c3a63cf1da
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed Jun 13 16:56:34 2012 +0200

    [SCSI] virtio-scsi: split scatterlist per target

Go ahead and make sure that vq->vq_lock is relinquished w/ spin_unlock
first, then release tgt->tgt_lock w/ spin_unlock_irqrestore.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/virtio_scsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 595af1a..b2abb8a 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -417,11 +417,11 @@ static int virtscsi_kick_cmd(struct virtio_scsi_target_state *tgt,
 
 	spin_lock(&vq->vq_lock);
 	ret = virtqueue_add_buf(vq->vq, tgt->sg, out_num, in_num, cmd, gfp);
-	spin_unlock(&tgt->tgt_lock);
+	spin_unlock(&vq->vq_lock);
 	if (ret >= 0)
 		ret = virtqueue_kick_prepare(vq->vq);
 
-	spin_unlock_irqrestore(&vq->vq_lock, flags);
+	spin_unlock_irqrestore(&tgt->tgt_lock, flags);
 
 	if (ret > 0)
 		virtqueue_notify(vq->vq);
-- 
1.7.2.5
