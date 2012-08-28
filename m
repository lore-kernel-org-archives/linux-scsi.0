From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH for 3.6 2/3] virtio-scsi: initialize scatterlist structure for events
Date: Tue, 28 Aug 2012 13:59:13 +0200
Message-ID: <1346155154-12915-3-git-send-email-pbonzini@redhat.com>
References: <1346155154-12915-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1346155154-12915-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, jbottomley@parallels.com, "Richard W.M. Jones" <rjones@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Richard W.M. Jones <rjones@redhat.com>

The sg struct for events is used without being initialized.  This
triggers a BUG_ON if CONFIG_DEBUG_SG is defined.

This was reported at https://bugzilla.redhat.com/show_bug.cgi?id=847548.

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
