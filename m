From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm_vhost: Expose ABI version via VHOST_SCSI_GET_ABI_VERSION
Date: Tue, 24 Jul 2012 01:26:20 +0000
Message-ID: <1343093180-5598-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

As requested by Anthony, here is a patch against target-pending/for-next-merge
to expose an ABI version to userspace via a new VHOST_SCSI_GET_ABI_VERSION
ioctl operation.

As mentioned in the comment, ABI Rev 0 is for pre 2012 out-of-tree code, and
ABI Rev 1 (the current rev) is for current WIP v3.6 kernel merge candiate code.

I think this is what you had in mind, and hopefully it will make MST happy too.
The incremental vhost-scsi patches against Zhi's QEMU are going out shortly ahead
of cutting a new vhost-scsi RFC over the next days.

Please have a look and let me know if you have any concerns here.

Thanks!

Reported-by: Anthony Liguori <aliguori@us.ibm.com>
Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/tcm_vhost.c |    9 +++++++++
 drivers/vhost/tcm_vhost.h |   11 +++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/vhost/tcm_vhost.c b/drivers/vhost/tcm_vhost.c
index dc7e024..3f04169 100644
--- a/drivers/vhost/tcm_vhost.c
+++ b/drivers/vhost/tcm_vhost.c
@@ -977,6 +977,15 @@ static long vhost_scsi_ioctl(struct file *f, unsigned int ioctl,
 			return -EFAULT;
 
 		return vhost_scsi_clear_endpoint(vs, &backend);
+	case VHOST_SCSI_GET_ABI_VERSION:
+		if (copy_from_user(&backend, argp, sizeof backend))
+			return -EFAULT;
+
+		backend.abi_version = VHOST_SCSI_ABI_VERSION;
+
+		if (copy_to_user(argp, &backend, sizeof backend))
+			return -EFAULT;
+		return 0;
 	case VHOST_GET_FEATURES:
 		features = VHOST_FEATURES;
 		if (copy_to_user(featurep, &features, sizeof features))
diff --git a/drivers/vhost/tcm_vhost.h b/drivers/vhost/tcm_vhost.h
index e942df9..3d5378f 100644
--- a/drivers/vhost/tcm_vhost.h
+++ b/drivers/vhost/tcm_vhost.h
@@ -80,7 +80,17 @@ struct tcm_vhost_tport {
 
 #include <linux/vhost.h>
 
+/*
+ * Used by QEMU userspace to ensure a consistent vhost-scsi ABI.
+ *
+ * ABI Rev 0: All pre 2012 revisions used by prototype out-of-tree code
+ * ABI Rev 1: 2012 version for v3.6 kernel merge candiate
+ */
+
+#define VHOST_SCSI_ABI_VERSION	1
+
 struct vhost_scsi_target {
+	int abi_version;
 	unsigned char vhost_wwpn[TRANSPORT_IQN_LEN];
 	unsigned short vhost_tpgt;
 };
@@ -88,3 +98,4 @@ struct vhost_scsi_target {
 /* VHOST_SCSI specific defines */
 #define VHOST_SCSI_SET_ENDPOINT _IOW(VHOST_VIRTIO, 0x40, struct vhost_scsi_target)
 #define VHOST_SCSI_CLEAR_ENDPOINT _IOW(VHOST_VIRTIO, 0x41, struct vhost_scsi_target)
+#define VHOST_SCSI_GET_ABI_VERSION _IOW(VHOST_VIRTIO, 0x42, struct vhost_scsi_target)
-- 
1.7.2.5
