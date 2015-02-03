From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 6/9] vhost/scsi: Set VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits
Date: Tue,  3 Feb 2015 06:30:00 +0000
Message-ID: <1422945003-24538-7-git-send-email-nab@daterainc.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1422945003-24538-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Signal support of VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits
required for virtio-scsi 1.0 spec layout requirements.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index e1fe003..c25fdd7 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -173,7 +173,9 @@ enum {
 /* Note: can't set VIRTIO_F_VERSION_1 yet, since that implies ANY_LAYOUT. */
 enum {
 	VHOST_SCSI_FEATURES = VHOST_FEATURES | (1ULL << VIRTIO_SCSI_F_HOTPLUG) |
-					       (1ULL << VIRTIO_SCSI_F_T10_PI)
+					       (1ULL << VIRTIO_SCSI_F_T10_PI) |
+					       (1ULL << VIRTIO_F_ANY_LAYOUT) |
+					       (1ULL << VIRTIO_F_VERSION_1)
 };
 
 #define VHOST_SCSI_MAX_TARGET	256
@@ -1626,7 +1628,10 @@ static void vhost_scsi_handle_kick(struct vhost_work *work)
 						poll.work);
 	struct vhost_scsi *vs = container_of(vq->dev, struct vhost_scsi, dev);
 
-	vhost_scsi_handle_vq(vs, vq);
+	if (vhost_has_feature(vq, VIRTIO_F_ANY_LAYOUT))
+		vhost_scsi_handle_vqal(vs, vq);
+	else
+		vhost_scsi_handle_vq(vs, vq);
 }
 
 static void vhost_scsi_flush_vq(struct vhost_scsi *vs, int index)
-- 
1.9.1
