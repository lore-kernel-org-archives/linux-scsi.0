From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/3] virtio-scsi: initialize scatterlist structure
Date: Tue,  2 Oct 2012 17:25:46 +0200
Message-ID: <1349191548-7120-2-git-send-email-pbonzini@redhat.com>
References: <1349191548-7120-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1349191548-7120-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, "Richard W.M. Jones" <rjones@redhat.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Richard W.M. Jones <rjones@redhat.com>

The sg struct is used without being initialized, which breaks
when CONFIG_DEBUG_SG is enabled.

Cc: stable@vger.kernel.org
Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 3e79a2f..7554d78 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -219,7 +219,7 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 	struct scatterlist sg;
 	unsigned long flags;
 
-	sg_set_buf(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
+	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
 
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
 
-- 
1.7.1
