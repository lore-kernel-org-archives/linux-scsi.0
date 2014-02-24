From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 5/6] vhost/scsi: Add new VIRTIO_SCSI_F_T10_PI feature bit
Date: Mon, 24 Feb 2014 05:32:29 +0000
Message-ID: <1393219950-18613-6-git-send-email-nab@daterainc.com>
References: <1393219950-18613-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1393219950-18613-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a VIRTIO_SCSI_F_T10_PI feature bit for signaling
host support of accepting T10 protection information SGLs from
virtio-scsi guest.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c        |    3 ++-
 include/linux/virtio_scsi.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 3bdb625..734a76c 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -169,7 +169,8 @@ enum {
 };
 
 enum {
-	VHOST_SCSI_FEATURES = VHOST_FEATURES | (1ULL << VIRTIO_SCSI_F_HOTPLUG)
+	VHOST_SCSI_FEATURES = VHOST_FEATURES | (1ULL << VIRTIO_SCSI_F_HOTPLUG) |
+					       (1ULL << VIRTIO_SCSI_F_T10_PI)
 };
 
 #define VHOST_SCSI_MAX_TARGET	256
diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
index 4195b97..dc3764b 100644
--- a/include/linux/virtio_scsi.h
+++ b/include/linux/virtio_scsi.h
@@ -97,6 +97,7 @@ struct virtio_scsi_config {
 #define VIRTIO_SCSI_F_INOUT                    0
 #define VIRTIO_SCSI_F_HOTPLUG                  1
 #define VIRTIO_SCSI_F_CHANGE                   2
+#define VIRTIO_SCSI_F_T10_PI                   3
 
 /* Response codes */
 #define VIRTIO_SCSI_S_OK                       0
-- 
1.7.10.4
