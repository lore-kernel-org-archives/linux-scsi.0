From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 3/4] vhost: Add vhost_scsi specific defines
Date: Wed, 11 Jul 2012 21:15:03 +0000
Message-ID: <1342041304-29728-4-git-send-email-nab@linux-iscsi.org>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41285 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202Ab2GKVR4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jul 2012 17:17:56 -0400
In-Reply-To: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@risingtidesystems.com>

From: Nicholas Bellinger <nab@risingtidesystems.com>

This patch adds the initial vhost_scsi_ioctl() callers for VHOST_SCSI_SET_ENDPOINT
and VHOST_SCSI_CLEAR_ENDPOINT respectively, and also adds struct vhost_vring_target
that is used by tcm_vhost code when locating target ports during qemu setup.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Zhi Yong Wu <wuzhy@cn.ibm.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
Signed-off-by: Nicholas A. Bellinger <nab@risingtidesystems.com>
---
 include/linux/vhost.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/vhost.h b/include/linux/vhost.h
index e847f1e..33b313b 100644
--- a/include/linux/vhost.h
+++ b/include/linux/vhost.h
@@ -24,7 +24,11 @@ struct vhost_vring_state {
 struct vhost_vring_file {
 	unsigned int index;
 	int fd; /* Pass -1 to unbind from file. */
+};
 
+struct vhost_vring_target {
+	unsigned char vhost_wwpn[224];
+	unsigned short vhost_tpgt;
 };
 
 struct vhost_vring_addr {
@@ -121,6 +125,11 @@ struct vhost_memory {
  * device.  This can be used to stop the ring (e.g. for migration). */
 #define VHOST_NET_SET_BACKEND _IOW(VHOST_VIRTIO, 0x30, struct vhost_vring_file)
 
+/* VHOST_SCSI specific defines */
+
+#define VHOST_SCSI_SET_ENDPOINT _IOW(VHOST_VIRTIO, 0x40, struct vhost_vring_target)
+#define VHOST_SCSI_CLEAR_ENDPOINT _IOW(VHOST_VIRTIO, 0x41, struct vhost_vring_target)
+
 /* Feature bits */
 /* Log all write descriptors. Can be changed while device is active. */
 #define VHOST_F_LOG_ALL 26
-- 
1.7.2.5

