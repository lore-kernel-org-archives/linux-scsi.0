Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77857427FBD;
	Mon, 20 Jul 2026 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784556734; cv=none; b=iYw6185W9efek7HIaZxSOMHuaAEZhG5ANqUOGp+lhAyT8TER//EXE5RYqPJ44pmaqVjwXNmqBqWK9TmDhJG5IqMd/9iHULVwEu5IguN62VOhSJeh5wEHot4EdJMRnaXk04XgmCuSBgtWIZ0OpyUzC5J/OX2HH/swAqG5XoPLOAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784556734; c=relaxed/simple;
	bh=WbxGY50Ku1zh9Lld1IrD1p/ARRiklGi+UNXh7uJ52tU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZmhuA03TsKdJWcKFD/zA1KhjuWtKQVUFnscIV5xt1z3HR3AIkO8pOB5NiO4DpdosmpEhkG7u+c/x9NpJmDes6SaLutKXo5Sz9PTKQDhV2BEWvrFCqwmoouH+Z/0ov4zEHkhkDQp1Qd+cQhETzY/Hyg4ndELKacNdKZEomo2Sw4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=iEkuGX+g; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="iEkuGX+g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ww
	3/iniGVo4aD31R6OEa75hQHppDnik/1A2aoz8O7Yc=; b=iEkuGX+geVnx/VJ04O
	o66ydAr82RroxR7QFtZ5bdY7mv9Ec48daeGB/tflm4zBf0QQkv0DLalHV71LZ1pj
	azKwBZmSdQH+ZaKh1v2Gh8K8g+tLUFPs617gaPsqwPBBYWNSKInjfH9UslwdQDka
	fRZZ9P1vVWJKMJNCmE0xwXAOE=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgD3Xw9gLF5qWUvpIg--.12525S6;
	Mon, 20 Jul 2026 22:10:44 +0800 (CST)
From: "rom.wang" <r4o5m6e8o@163.com>
To: mst@redhat.com,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	stefanha@redhat.com
Cc: virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Yufeng Wang <wangyufeng@kylinos.cn>
Subject: [RFC PATCH 4/4] virtio: add SQ/CQ polling mode support for vhost-scsi
Date: Mon, 20 Jul 2026 22:10:40 +0800
Message-Id: <20260720141040.181946-5-r4o5m6e8o@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260720141040.181946-1-r4o5m6e8o@163.com>
References: <20260720141040.181946-1-r4o5m6e8o@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgD3Xw9gLF5qWUvpIg--.12525S6
X-Coremail-Antispam: 1Uf129KBjvAXoWfGF45CFyrZFyfGFWrur1rZwb_yoW8AFyUGo
	ZxKF1Iqr4DJw1UZrnI9r1xtFW5JF1vgF4UAr15u39xKay2y343KF95KanxAa4rAFyrtF18
	GFyfW3yrJay0qFZ5n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU2LIDUUUUU
X-CM-SenderInfo: 3uurkzkwhy0qqrwthudrp/xtbC8ARWy2peLGQf3AAA3W

From: Yufeng Wang <wangyufeng@kylinos.cn>

Implement the QEMU-side bridge layer for virtio SQ/CQ polling mode,
which replaces interrupt-based virtio notifications with io_uring-style
doorbell polling to eliminate VM exits in high-throughput scenarios.

UAPI headers: sync VIRTIO_F_SQCQ_POLL (bit 42), PCI common config
offsets (64-76), struct vring_sq/vring_cq, struct vhost_vring_sqcq_addr,
and VHOST_SET_VRING_SQCQ_ADDR ioctl (0x27) from Linux kernel.

VirtIO core: add sq/cq fields to VRing, with getter/setter functions.

PCI transport: handle SQE/CQE register read/write in common config,
gate SQ/CQ address forwarding on VIRTIO_F_SQCQ_POLL negotiation in
Q_ENABLE handler.

Vhost backend: add vhost_set_vring_sqcq_addr_op to VhostOps, implement
kernel backend via VHOST_SET_VRING_SQCQ_ADDR ioctl.

Vhost core: map SQ/CQ GPAs to HVAs in vhost_virtqueue_start() after
VHOST_SET_VRING_ADDR, call the new ioctl before VHOST_SET_VRING_KICK;
unmap in do_vhost_virtqueue_stop().

vhost-scsi: advertise VIRTIO_F_SQCQ_POLL in kernel_feature_bits[].

Signed-off-by: Yufeng Wang <wangyufeng@kylinos.cn>
---
 hw/scsi/vhost-scsi.c                          |  4 ++
 hw/virtio/vhost-backend.c                     |  7 +++
 hw/virtio/vhost.c                             | 54 +++++++++++++++++++
 hw/virtio/virtio-pci.c                        | 31 +++++++++++
 hw/virtio/virtio.c                            | 18 +++++++
 include/hw/virtio/vhost-backend.h             |  4 ++
 include/hw/virtio/vhost.h                     |  6 +++
 include/hw/virtio/virtio-pci.h                |  2 +
 include/hw/virtio/virtio.h                    |  3 ++
 include/standard-headers/linux/vhost_types.h  |  7 +++
 .../standard-headers/linux/virtio_config.h    |  5 +-
 include/standard-headers/linux/virtio_pci.h   |  4 ++
 include/standard-headers/linux/virtio_ring.h  | 30 +++++++++++
 linux-headers/linux/vhost.h                   |  4 ++
 14 files changed, 178 insertions(+), 1 deletion(-)

diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
index 699863c..bb7f3e8 100644
--- a/hw/scsi/vhost-scsi.c
+++ b/hw/scsi/vhost-scsi.c
@@ -40,6 +40,7 @@ static const int kernel_feature_bits[] = {
     VIRTIO_F_RING_RESET,
     VIRTIO_F_IN_ORDER,
     VIRTIO_F_NOTIFICATION_DATA,
+    VIRTIO_F_SQCQ_POLL,
     VHOST_INVALID_FEATURE_BIT
 };
 
@@ -361,6 +362,9 @@ static const Property vhost_scsi_properties[] = {
     DEFINE_PROP_BIT64("hotplug", VHostSCSICommon, host_features,
                                                   VIRTIO_SCSI_F_HOTPLUG,
                                                   false),
+    DEFINE_PROP_BIT64("sqcq_poll", VHostSCSICommon, host_features,
+                                                   VIRTIO_F_SQCQ_POLL,
+                                                   true),
     DEFINE_PROP_BOOL("migratable", VHostSCSICommon, migratable, false),
     DEFINE_PROP_BOOL("worker_per_virtqueue", VirtIOSCSICommon,
                      conf.worker_per_virtqueue, false),
diff --git a/hw/virtio/vhost-backend.c b/hw/virtio/vhost-backend.c
index 4367db0..a71b30b 100644
--- a/hw/virtio/vhost-backend.c
+++ b/hw/virtio/vhost-backend.c
@@ -115,6 +115,12 @@ static int vhost_kernel_set_vring_addr(struct vhost_dev *dev,
     return vhost_kernel_call(dev, VHOST_SET_VRING_ADDR, addr);
 }
 
+static int vhost_kernel_set_vring_sqcq_addr(struct vhost_dev *dev,
+                                            struct vhost_vring_sqcq_addr *addr)
+{
+    return vhost_kernel_call(dev, VHOST_SET_VRING_SQCQ_ADDR, addr);
+}
+
 static int vhost_kernel_set_vring_endian(struct vhost_dev *dev,
                                          struct vhost_vring_state *ring)
 {
@@ -368,6 +374,7 @@ const VhostOps kernel_ops = {
         .vhost_set_log_base = vhost_kernel_set_log_base,
         .vhost_set_mem_table = vhost_kernel_set_mem_table,
         .vhost_set_vring_addr = vhost_kernel_set_vring_addr,
+        .vhost_set_vring_sqcq_addr = vhost_kernel_set_vring_sqcq_addr,
         .vhost_set_vring_endian = vhost_kernel_set_vring_endian,
         .vhost_set_vring_num = vhost_kernel_set_vring_num,
         .vhost_set_vring_base = vhost_kernel_set_vring_base,
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 31e9704..8c82f98 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -22,6 +22,7 @@
 #include "qemu/memfd.h"
 #include "qemu/log.h"
 #include "standard-headers/linux/vhost_types.h"
+#include "standard-headers/linux/virtio_ring.h"
 #include "hw/virtio/virtio-bus.h"
 #include "hw/mem/memory-device.h"
 #include "migration/blocker.h"
@@ -1337,6 +1338,49 @@ int vhost_virtqueue_start(struct vhost_dev *dev,
         goto fail_alloc;
     }
 
+    /* SQ/CQ polling: map and pass to vhost if feature negotiated */
+    vq->sq = NULL;
+    vq->cq = NULL;
+    vq->sq_phys = virtio_queue_get_sq_addr(vdev, idx);
+    vq->cq_phys = virtio_queue_get_cq_addr(vdev, idx);
+
+    if (vq->sq_phys && vq->cq_phys &&
+        dev->vhost_ops->vhost_set_vring_sqcq_addr &&
+        virtio_has_feature(vdev->guest_features, VIRTIO_F_SQCQ_POLL)) {
+        struct vhost_vring_sqcq_addr sqcq_addr;
+
+        l = sizeof(struct vring_sq);
+        vq->sq = vhost_memory_map(dev, vq->sq_phys, &l, false);
+        if (!vq->sq) {
+            r = -ENOMEM;
+            goto fail_alloc;
+        }
+        vq->sq_size = l;
+
+        l = sizeof(struct vring_cq);
+        vq->cq = vhost_memory_map(dev, vq->cq_phys, &l, false);
+        if (!vq->cq) {
+            r = -ENOMEM;
+            vhost_memory_unmap(dev, vq->sq, vq->sq_size, 0, 0);
+            goto fail_alloc;
+        }
+        vq->cq_size = l;
+
+        memset(&sqcq_addr, 0, sizeof(sqcq_addr));
+        sqcq_addr.index = vhost_vq_index;
+        sqcq_addr.sq_user_addr = (uint64_t)(unsigned long)vq->sq;
+        sqcq_addr.cq_user_addr = (uint64_t)(unsigned long)vq->cq;
+        r = dev->vhost_ops->vhost_set_vring_sqcq_addr(dev, &sqcq_addr);
+        if (r < 0) {
+            VHOST_OPS_DEBUG(r, "vhost_set_vring_sqcq_addr failed");
+            vhost_memory_unmap(dev, vq->cq, vq->cq_size, 0, 0);
+            vhost_memory_unmap(dev, vq->sq, vq->sq_size, 0, 0);
+            vq->sq = NULL;
+            vq->cq = NULL;
+            goto fail_alloc;
+        }
+    }
+
     file.fd = event_notifier_get_fd(virtio_queue_get_host_notifier(vvq));
     r = dev->vhost_ops->vhost_set_vring_kick(dev, &file);
     if (r) {
@@ -1425,6 +1469,16 @@ static int do_vhost_virtqueue_stop(struct vhost_dev *dev,
                                                 vhost_vq_index);
     }
 
+    /* Unmap SQ/CQ if mapped */
+    if (vq->sq) {
+        vhost_memory_unmap(dev, vq->sq, vq->sq_size, 0, 0);
+        vq->sq = NULL;
+    }
+    if (vq->cq) {
+        vhost_memory_unmap(dev, vq->cq, vq->cq_size, 0, 0);
+        vq->cq = NULL;
+    }
+
     vhost_memory_unmap(dev, vq->used, virtio_queue_get_used_size(vdev, idx),
                        1, virtio_queue_get_used_size(vdev, idx));
     vhost_memory_unmap(dev, vq->avail, virtio_queue_get_avail_size(vdev, idx),
diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
index b273eb2..c88cba3 100644
--- a/hw/virtio/virtio-pci.c
+++ b/hw/virtio/virtio-pci.c
@@ -1623,6 +1623,18 @@ static uint64_t virtio_pci_common_read(void *opaque, hwaddr addr,
     case VIRTIO_PCI_COMMON_Q_RESET:
         val = proxy->vqs[vdev->queue_sel].reset;
         break;
+    case VIRTIO_PCI_COMMON_SQE_LO:
+        val = proxy->vqs[vdev->queue_sel].sq[0];
+        break;
+    case VIRTIO_PCI_COMMON_SQE_HI:
+        val = proxy->vqs[vdev->queue_sel].sq[1];
+        break;
+    case VIRTIO_PCI_COMMON_CQE_LO:
+        val = proxy->vqs[vdev->queue_sel].cq[0];
+        break;
+    case VIRTIO_PCI_COMMON_CQE_HI:
+        val = proxy->vqs[vdev->queue_sel].cq[1];
+        break;
     default:
         val = 0;
     }
@@ -1727,6 +1739,13 @@ static void virtio_pci_common_write(void *opaque, hwaddr addr,
                        proxy->vqs[vdev->queue_sel].avail[0],
                        ((uint64_t)proxy->vqs[vdev->queue_sel].used[1]) << 32 |
                        proxy->vqs[vdev->queue_sel].used[0]);
+            if (virtio_has_feature(vdev->guest_features, VIRTIO_F_SQCQ_POLL)) {
+                virtio_queue_set_sqcq(vdev, vdev->queue_sel,
+                    ((uint64_t)proxy->vqs[vdev->queue_sel].sq[1] << 32) |
+                    proxy->vqs[vdev->queue_sel].sq[0],
+                    ((uint64_t)proxy->vqs[vdev->queue_sel].cq[1] << 32) |
+                    proxy->vqs[vdev->queue_sel].cq[0]);
+            }
             proxy->vqs[vdev->queue_sel].enabled = 1;
             proxy->vqs[vdev->queue_sel].reset = 0;
             virtio_queue_enable(vdev, vdev->queue_sel);
@@ -1752,6 +1771,18 @@ static void virtio_pci_common_write(void *opaque, hwaddr addr,
     case VIRTIO_PCI_COMMON_Q_USEDHI:
         proxy->vqs[vdev->queue_sel].used[1] = val;
         break;
+    case VIRTIO_PCI_COMMON_SQE_LO:
+        proxy->vqs[vdev->queue_sel].sq[0] = val;
+        break;
+    case VIRTIO_PCI_COMMON_SQE_HI:
+        proxy->vqs[vdev->queue_sel].sq[1] = val;
+        break;
+    case VIRTIO_PCI_COMMON_CQE_LO:
+        proxy->vqs[vdev->queue_sel].cq[0] = val;
+        break;
+    case VIRTIO_PCI_COMMON_CQE_HI:
+        proxy->vqs[vdev->queue_sel].cq[1] = val;
+        break;
     case VIRTIO_PCI_COMMON_Q_RESET:
         if (val == 1) {
             proxy->vqs[vdev->queue_sel].reset = 1;
diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 3dc9423..42e39d9 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -111,6 +111,8 @@ typedef struct VRing
     hwaddr desc;
     hwaddr avail;
     hwaddr used;
+    hwaddr sq;
+    hwaddr cq;
     VRingMemoryRegionCaches *caches;
 } VRing;
 
@@ -2400,6 +2402,12 @@ void virtio_queue_set_rings(VirtIODevice *vdev, int n, hwaddr desc,
     virtio_init_region_cache(vdev, n);
 }
 
+void virtio_queue_set_sqcq(VirtIODevice *vdev, int n, hwaddr sq, hwaddr cq)
+{
+    vdev->vq[n].vring.sq = sq;
+    vdev->vq[n].vring.cq = cq;
+}
+
 void virtio_queue_set_num(VirtIODevice *vdev, int n, int num)
 {
     /* Don't allow guest to flip queue between existent and
@@ -3661,6 +3669,16 @@ hwaddr virtio_queue_get_used_addr(VirtIODevice *vdev, int n)
     return vdev->vq[n].vring.used;
 }
 
+hwaddr virtio_queue_get_sq_addr(VirtIODevice *vdev, int n)
+{
+    return vdev->vq[n].vring.sq;
+}
+
+hwaddr virtio_queue_get_cq_addr(VirtIODevice *vdev, int n)
+{
+    return vdev->vq[n].vring.cq;
+}
+
 hwaddr virtio_queue_get_desc_size(VirtIODevice *vdev, int n)
 {
     return sizeof(VRingDesc) * vdev->vq[n].vring.num;
diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/vhost-backend.h
index ff94fa1..911cd15 100644
--- a/include/hw/virtio/vhost-backend.h
+++ b/include/hw/virtio/vhost-backend.h
@@ -45,6 +45,7 @@ struct vhost_memory;
 struct vhost_vring_file;
 struct vhost_vring_state;
 struct vhost_vring_addr;
+struct vhost_vring_sqcq_addr;
 struct vhost_vring_worker;
 struct vhost_worker_state;
 struct vhost_scsi_target;
@@ -71,6 +72,8 @@ typedef int (*vhost_set_mem_table_op)(struct vhost_dev *dev,
                                       struct vhost_memory *mem);
 typedef int (*vhost_set_vring_addr_op)(struct vhost_dev *dev,
                                        struct vhost_vring_addr *addr);
+typedef int (*vhost_set_vring_sqcq_addr_op)(struct vhost_dev *dev,
+                                            struct vhost_vring_sqcq_addr *addr);
 typedef int (*vhost_set_vring_endian_op)(struct vhost_dev *dev,
                                          struct vhost_vring_state *ring);
 typedef int (*vhost_set_vring_num_op)(struct vhost_dev *dev,
@@ -178,6 +181,7 @@ typedef struct VhostOps {
     vhost_set_log_base_op vhost_set_log_base;
     vhost_set_mem_table_op vhost_set_mem_table;
     vhost_set_vring_addr_op vhost_set_vring_addr;
+    vhost_set_vring_sqcq_addr_op vhost_set_vring_sqcq_addr;
     vhost_set_vring_endian_op vhost_set_vring_endian;
     vhost_set_vring_num_op vhost_set_vring_num;
     vhost_set_vring_base_op vhost_set_vring_base;
diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index 08bbb4d..65056a0 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -27,6 +27,8 @@ struct vhost_virtqueue {
     void *desc;
     void *avail;
     void *used;
+    void *sq;           /* Mapped SQ doorbell */
+    void *cq;           /* Mapped CQ doorbell */
     int num;
     unsigned long long desc_phys;
     unsigned desc_size;
@@ -34,6 +36,10 @@ struct vhost_virtqueue {
     unsigned avail_size;
     unsigned long long used_phys;
     unsigned used_size;
+    unsigned long long sq_phys;  /* GPA of SQ doorbell */
+    unsigned long long cq_phys;  /* GPA of CQ doorbell */
+    unsigned sq_size;   /* Size of mapped SQ region */
+    unsigned cq_size;   /* Size of mapped CQ region */
     EventNotifier masked_notifier;
     EventNotifier error_notifier;
     EventNotifier masked_config_notifier;
diff --git a/include/hw/virtio/virtio-pci.h b/include/hw/virtio/virtio-pci.h
index 6397529..37103c7 100644
--- a/include/hw/virtio/virtio-pci.h
+++ b/include/hw/virtio/virtio-pci.h
@@ -122,6 +122,8 @@ typedef struct VirtIOPCIQueue {
   uint32_t desc[2];
   uint32_t avail[2];
   uint32_t used[2];
+  uint32_t sq[2];
+  uint32_t cq[2];
 } VirtIOPCIQueue;
 
 struct VirtIOPCIProxy {
diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 27cd98d..29f21f4 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -361,6 +361,7 @@ int virtio_queue_get_max_num(VirtIODevice *vdev, int n);
 int virtio_get_num_queues(VirtIODevice *vdev);
 void virtio_queue_set_rings(VirtIODevice *vdev, int n, hwaddr desc,
                             hwaddr avail, hwaddr used);
+void virtio_queue_set_sqcq(VirtIODevice *vdev, int n, hwaddr sq, hwaddr cq);
 void virtio_queue_update_rings(VirtIODevice *vdev, int n);
 void virtio_init_region_cache(VirtIODevice *vdev, int n);
 void virtio_queue_set_align(VirtIODevice *vdev, int n, int align);
@@ -408,6 +409,8 @@ bool virtio_queue_enabled_legacy(VirtIODevice *vdev, int n);
 bool virtio_queue_enabled(VirtIODevice *vdev, int n);
 hwaddr virtio_queue_get_avail_addr(VirtIODevice *vdev, int n);
 hwaddr virtio_queue_get_used_addr(VirtIODevice *vdev, int n);
+hwaddr virtio_queue_get_sq_addr(VirtIODevice *vdev, int n);
+hwaddr virtio_queue_get_cq_addr(VirtIODevice *vdev, int n);
 hwaddr virtio_queue_get_desc_size(VirtIODevice *vdev, int n);
 hwaddr virtio_queue_get_avail_size(VirtIODevice *vdev, int n);
 hwaddr virtio_queue_get_used_size(VirtIODevice *vdev, int n);
diff --git a/include/standard-headers/linux/vhost_types.h b/include/standard-headers/linux/vhost_types.h
index 79b53a9..ea96feb 100644
--- a/include/standard-headers/linux/vhost_types.h
+++ b/include/standard-headers/linux/vhost_types.h
@@ -151,6 +151,13 @@ struct vhost_scsi_target {
 	unsigned short reserved;
 };
 
+/* SQ/CQ polling mode */
+struct vhost_vring_sqcq_addr {
+	unsigned int index;
+	__u64 sq_user_addr;   /* SQ doorbell HVA */
+	__u64 cq_user_addr;   /* CQ doorbell HVA */
+};
+
 /* VHOST_VDPA specific definitions */
 
 struct vhost_vdpa_config {
diff --git a/include/standard-headers/linux/virtio_config.h b/include/standard-headers/linux/virtio_config.h
index 45be0fa..d73938e 100644
--- a/include/standard-headers/linux/virtio_config.h
+++ b/include/standard-headers/linux/virtio_config.h
@@ -52,7 +52,7 @@
  * rest are per-device feature bits.
  */
 #define VIRTIO_TRANSPORT_F_START	28
-#define VIRTIO_TRANSPORT_F_END		42
+#define VIRTIO_TRANSPORT_F_END		43
 
 #ifndef VIRTIO_CONFIG_NO_LEGACY
 /* Do we get callbacks when the ring is completely used, even if we've
@@ -118,4 +118,7 @@
  */
 #define VIRTIO_F_ADMIN_VQ		41
 
+/* SQ/CQ polling mode for io_uring-style doorbell polling */
+#define VIRTIO_F_SQCQ_POLL		42
+
 #endif /* _LINUX_VIRTIO_CONFIG_H */
diff --git a/include/standard-headers/linux/virtio_pci.h b/include/standard-headers/linux/virtio_pci.h
index 4c82513..cc585b6 100644
--- a/include/standard-headers/linux/virtio_pci.h
+++ b/include/standard-headers/linux/virtio_pci.h
@@ -235,6 +235,10 @@ struct virtio_pci_cfg_cap {
 #define VIRTIO_PCI_COMMON_Q_RESET	58
 #define VIRTIO_PCI_COMMON_ADM_Q_IDX	60
 #define VIRTIO_PCI_COMMON_ADM_Q_NUM	62
+#define VIRTIO_PCI_COMMON_SQE_LO	64
+#define VIRTIO_PCI_COMMON_SQE_HI	68
+#define VIRTIO_PCI_COMMON_CQE_LO	72
+#define VIRTIO_PCI_COMMON_CQE_HI	76
 
 #endif /* VIRTIO_PCI_NO_MODERN */
 
diff --git a/include/standard-headers/linux/virtio_ring.h b/include/standard-headers/linux/virtio_ring.h
index 22f6eb8..520b758 100644
--- a/include/standard-headers/linux/virtio_ring.h
+++ b/include/standard-headers/linux/virtio_ring.h
@@ -245,4 +245,34 @@ struct vring_packed_desc {
 	uint16_t flags;
 };
 
+/*
+ * struct vring_sq - Submission Queue doorbell for polling mode.
+ * Placed alongside the standard virtio split ring to enable
+ * kick-less notification from guest to host.
+ *
+ * @idx: Producer index (guest updates, corresponds to avail->idx)
+ * @sq_need_wakeup: device requests guest to kick when sleeping
+ * @reserved: Reserved for future use, pad to cache-line
+ */
+struct vring_sq {
+	__virtio64 idx;
+	uint8_t sq_need_wakeup;
+	uint8_t reserved[55];
+} __attribute__((aligned(128)));
+
+/*
+ * struct vring_cq - Completion Queue doorbell for polling mode.
+ * Placed alongside the standard virtio split ring to enable
+ * interrupt-less notification from host to guest.
+ *
+ * @idx: Producer index (device updates, corresponds to used->idx)
+ * @cq_need_wakeup: guest requests host to signal when sleeping
+ * @reserved: Reserved for future use, pad to cache-line
+ */
+struct vring_cq {
+	__virtio64 idx;
+	uint8_t cq_need_wakeup;
+	uint8_t reserved[55];
+} __attribute__((aligned(128)));
+
 #endif /* _LINUX_VIRTIO_RING_H */
diff --git a/linux-headers/linux/vhost.h b/linux-headers/linux/vhost.h
index c57674a..746d71f 100644
--- a/linux-headers/linux/vhost.h
+++ b/linux-headers/linux/vhost.h
@@ -123,6 +123,10 @@
 #define VHOST_SET_BACKEND_FEATURES _IOW(VHOST_VIRTIO, 0x25, __u64)
 #define VHOST_GET_BACKEND_FEATURES _IOR(VHOST_VIRTIO, 0x26, __u64)
 
+/* Set SQ/CQ doorbell addresses for polling mode */
+#define VHOST_SET_VRING_SQCQ_ADDR _IOW(VHOST_VIRTIO, 0x27, \
+				struct vhost_vring_sqcq_addr)
+
 /* VHOST_NET specific defines */
 
 /* Attach virtio net ring to a raw socket, or tap device.
-- 
2.34.1

