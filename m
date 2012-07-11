From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 1/4] vhost: Separate vhost-net features from vhost features
Date: Wed, 11 Jul 2012 21:15:01 +0000
Message-ID: <1342041304-29728-2-git-send-email-nab@linux-iscsi.org>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41260 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab2GKVRu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jul 2012 17:17:50 -0400
In-Reply-To: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Asias He <asias@redhat.com>

From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

In order for other vhost devices to use the VHOST_FEATURES bits the
vhost-net specific bits need to be moved to their own VHOST_NET_FEATURES
constant.

(Asias: Update drivers/vhost/test.c to use VHOST_NET_FEATURES)

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Zhi Yong Wu <wuzhy@cn.ibm.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Asias He <asias@redhat.com>
Signed-off-by: Nicholas A. Bellinger <nab@risingtidesystems.com>
---
 drivers/vhost/net.c   |    4 ++--
 drivers/vhost/test.c  |    4 ++--
 drivers/vhost/vhost.h |    3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index f82a739..072cbba 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -823,14 +823,14 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 			return -EFAULT;
 		return vhost_net_set_backend(n, backend.index, backend.fd);
 	case VHOST_GET_FEATURES:
-		features = VHOST_FEATURES;
+		features = VHOST_NET_FEATURES;
 		if (copy_to_user(featurep, &features, sizeof features))
 			return -EFAULT;
 		return 0;
 	case VHOST_SET_FEATURES:
 		if (copy_from_user(&features, featurep, sizeof features))
 			return -EFAULT;
-		if (features & ~VHOST_FEATURES)
+		if (features & ~VHOST_NET_FEATURES)
 			return -EOPNOTSUPP;
 		return vhost_net_set_features(n, features);
 	case VHOST_RESET_OWNER:
diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 3de00d9..91d6f06 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -261,14 +261,14 @@ static long vhost_test_ioctl(struct file *f, unsigned int ioctl,
 			return -EFAULT;
 		return vhost_test_run(n, test);
 	case VHOST_GET_FEATURES:
-		features = VHOST_FEATURES;
+		features = VHOST_NET_FEATURES;
 		if (copy_to_user(featurep, &features, sizeof features))
 			return -EFAULT;
 		return 0;
 	case VHOST_SET_FEATURES:
 		if (copy_from_user(&features, featurep, sizeof features))
 			return -EFAULT;
-		if (features & ~VHOST_FEATURES)
+		if (features & ~VHOST_NET_FEATURES)
 			return -EOPNOTSUPP;
 		return vhost_test_set_features(n, features);
 	case VHOST_RESET_OWNER:
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 8de1fd5..07b9763 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -201,7 +201,8 @@ enum {
 	VHOST_FEATURES = (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
 			 (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
 			 (1ULL << VIRTIO_RING_F_EVENT_IDX) |
-			 (1ULL << VHOST_F_LOG_ALL) |
+			 (1ULL << VHOST_F_LOG_ALL),
+	VHOST_NET_FEATURES = VHOST_FEATURES |
 			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
 			 (1ULL << VIRTIO_NET_F_MRG_RXBUF),
 };
-- 
1.7.2.5

