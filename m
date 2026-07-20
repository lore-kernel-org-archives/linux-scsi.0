Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE1039E6E4;
	Mon, 20 Jul 2026 14:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784556706; cv=none; b=sOPSL68jgmY6fmwFzAIylSmjNGgo0VziQ0QZYgnTwaRq+OCsdi5nwnh0+zh8hlZM63a9iodrNaa2e9sch/fbsS69ooFuF+9sRQhPZ44aDuaTNA1lcR7gt6MY9VSAlMNIZ+oWQMjvRhlPUj7QyYFU5/7QbN3fy5sbMAmSE2q3+HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784556706; c=relaxed/simple;
	bh=yb0qCsLKZrZcL6wihEOGi5lj/DktoRSj4Pg7irMqigU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n90fg88QwBawKsx3aWJ7T8XMVVjOrQouNczaP90JNjk3Hfpi88W/l1UWoNseJyFUMTyZPBOWzL1ogkmT56SPfd3l0UgfjYxhzKUAjvRY0PlEh3GkATHIY7ZDj8P54nLfi+W3HqTr2bb2ig7IpX3U0SuhedZhey/hs1rP02VQOfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=TcDlmObR; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="TcDlmObR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=p7LQ9TPUGZKNlf/GqJcGoVkUE7Sm3aTjMQYFUDUjxzw=;
	b=TcDlmObRHpCJofBTn9ekM28ah3r98dnY6Z1rFlEXOEPNKJXbPJWOkg51ZCLCP5
	TAfBursw7iVOLAF3P7CMXhShl8CtDrJ2qBZfiVM13i/JNQv33oqab+M+9Vvkezwg
	gIyY5KFAKCkCUZlVI5SHokHQ7llHz7KKV6k3tvnrd4iQo=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgD3Xw9gLF5qWUvpIg--.12525S5;
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
Subject: [RFC PATCH 3/4] virtio: guest driver support for SQ/CQ polling
Date: Mon, 20 Jul 2026 22:10:39 +0800
Message-Id: <20260720141040.181946-4-r4o5m6e8o@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260720141040.181946-1-r4o5m6e8o@163.com>
References: <20260720141040.181946-1-r4o5m6e8o@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgD3Xw9gLF5qWUvpIg--.12525S5
X-Coremail-Antispam: 1Uf129KBjvAXoWfWr17GF48Zr43Zr48GrWDCFg_yoWrJF1rto
	WfJFsxJrn5Grn7ArWSgr1ftFWDZayqyFZxArs8urZ8Wa1jq3y5tF9rG3Z8JF1fAFyrKFn5
	AF12g34ftFyUtFWfn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUfxhLUUUUU
X-CM-SenderInfo: 3uurkzkwhy0qqrwthudrp/xtbCzQRWy2peLGSNuQAA3c

From: Yufeng Wang <wangyufeng@kylinos.cn>

Implement SQ/CQ doorbell polling in the guest kernel:

  - virtio_ring.c: SQ/CQ DMA allocation, virtqueue_notify() writes
    sq->idx via smp_store_release instead of MMIO kick; completion
    detection via more_used() (direct used-ring check)
  - virtio_sqcq_poll.c: per-device CQ poll thread with need_resched()
    cooperative spin, time-based spin budget, 1ms idle sleep
  - virtio_pci_modern.c: feature negotiation, PCI config space write
    for SQ/CQ DMA addresses, poll thread lifecycle
  - virtio.c: reject VIRTIO_F_SQCQ_POLL + VIRTIO_F_RING_PACKED
  - virtio_scsi.c: 10s window io_stats diagnostics output
  - do_softirq() after each completion callback (no hardware interrupt)

Signed-off-by: Yufeng Wang <wangyufeng@kylinos.cn>
---
 drivers/scsi/virtio_scsi.c             | 113 ++++++++-
 drivers/virtio/Makefile                |   2 +-
 drivers/virtio/virtio.c                |  10 +
 drivers/virtio/virtio_pci_common.c     |   3 +
 drivers/virtio/virtio_pci_modern.c     |  39 +++
 drivers/virtio/virtio_pci_modern_dev.c |  34 ++-
 drivers/virtio/virtio_ring.c           | 262 +++++++++++++++++++
 drivers/virtio/virtio_sqcq_poll.c      | 338 +++++++++++++++++++++++++
 include/linux/virtio.h                 |  25 ++
 include/linux/virtio_pci_modern.h      |   2 +
 10 files changed, 825 insertions(+), 3 deletions(-)
 create mode 100644 drivers/virtio/virtio_sqcq_poll.c

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 0ed8558dad72..f803bb62d22a 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -30,6 +30,7 @@
 #include <scsi/scsi_devinfo.h>
 #include <linux/seqlock.h>
 #include <linux/dma-mapping.h>
+#include <linux/ktime.h>
 
 #include "sd.h"
 
@@ -46,6 +47,8 @@ MODULE_PARM_DESC(virtscsi_poll_queues,
 struct virtio_scsi_cmd {
 	struct scsi_cmnd *sc;
 	struct completion *comp;
+	u64 submit_ns;			/* ktime_get_ns() at submission */
+	u64 notify_ns;			/* ktime_get_ns() after SQ doorbell */
 	union {
 		struct virtio_scsi_cmd_req       cmd;
 		struct virtio_scsi_cmd_req_pi    cmd_pi;
@@ -95,6 +98,22 @@ struct virtio_scsi {
 	struct virtio_scsi_event events[VIRTIO_SCSI_EVENT_LEN];
 	__dma_from_device_group_end();
 
+	/* I/O latency statistics (debugging) */
+	spinlock_t lat_lock;
+	u64 lat_sum_ns;
+	u64 lat_min_ns;
+	u64 lat_max_ns;
+	u64 lat_count;
+	u64 host_sum_ns;	/* notify → cq_detect (host transit) */
+	u64 cb_wait_sum_ns;	/* cq_detect → process (poll sched latency) */
+	u64 det_count;
+	u64 last_cq_detect_ns;	/* timestamp of last CQ detection */
+	unsigned long lat_last_print;
+
+	/* Completion interval tracking (matches host interval metric) */
+	u64 last_complete_ns;	/* ktime of last completion */
+	u64 ema_cmp_int_ns;	/* EMA of completion-to-completion interval */
+
 	struct virtio_scsi_vq req_vqs[];
 };
 
@@ -122,6 +141,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 	struct virtio_scsi_cmd *cmd = buf;
 	struct scsi_cmnd *sc = cmd->sc;
 	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
+	u64 cb_entry_ns = ktime_get_ns();
 
 	dev_dbg(&sc->device->sdev_gendev,
 		"cmd %p response %u status %#02x sense_len %u\n",
@@ -175,6 +195,88 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 			     VIRTIO_SCSI_SENSE_SIZE));
 	}
 
+	/* I/O latency tracking */
+	if (cmd->submit_ns) {
+		u64 now = ktime_get_ns();
+		u64 lat = now - cmd->submit_ns;
+		unsigned long flags;
+
+		spin_lock_irqsave(&vscsi->lat_lock, flags);
+		vscsi->lat_sum_ns += lat;
+		vscsi->lat_count++;
+		if (lat < vscsi->lat_min_ns || vscsi->lat_min_ns == 0)
+			vscsi->lat_min_ns = lat;
+		if (lat > vscsi->lat_max_ns)
+			vscsi->lat_max_ns = lat;
+
+		/* Completion interval EMA (matches host interval metric) */
+		if (vscsi->last_complete_ns) {
+			u64 cmp_int = now - vscsi->last_complete_ns;
+
+			if (vscsi->ema_cmp_int_ns == 0)
+				vscsi->ema_cmp_int_ns = cmp_int;
+			else
+				vscsi->ema_cmp_int_ns =
+					vscsi->ema_cmp_int_ns -
+					vscsi->ema_cmp_int_ns / 8 +
+					cmp_int / 8;
+		}
+		vscsi->last_complete_ns = now;
+
+		if (cmd->notify_ns && vscsi->last_cq_detect_ns) {
+			u64 host_lat = vscsi->last_cq_detect_ns -
+				cmd->notify_ns;
+			u64 cb_wait = cb_entry_ns -
+				vscsi->last_cq_detect_ns;
+
+			if (host_lat < 10ULL * NSEC_PER_SEC) {
+				vscsi->host_sum_ns += host_lat;
+				vscsi->cb_wait_sum_ns += cb_wait;
+				vscsi->det_count++;
+			}
+		}
+
+		/* 10s window — single consolidated output */
+		if (time_after(jiffies, vscsi->lat_last_print +
+					msecs_to_jiffies(10000)) &&
+		    vscsi->lat_count > 0) {
+			u64 avg_lat = vscsi->lat_sum_ns / vscsi->lat_count;
+			u64 host_lat = vscsi->det_count > 0 ?
+				vscsi->host_sum_ns / vscsi->det_count : 0;
+			u64 poll_lat = vscsi->det_count > 0 ?
+				vscsi->cb_wait_sum_ns / vscsi->det_count : 0;
+			u64 interval = 0;
+			unsigned int wk_kick;
+			unsigned long sleep_cnt;
+
+			wk_kick = virtqueue_get_sq_notify_stats(
+				vscsi->req_vqs[0].vq, &interval);
+			sleep_cnt = virtio_sqcq_poll_get_sleep_count(vscsi->vdev);
+
+			dev_info(&vscsi->vdev->dev,
+				 "io_stats: cq=%llu avg_lat=%lluns host_lat=%lluns poll_lat=%lluns min_lat=%lluns max_lat=%lluns interval=%lluns cmp_interval=%lluns wk_kick=%u sleep=%lu\n",
+				 vscsi->lat_count,
+				 avg_lat,
+				 host_lat,
+				 poll_lat,
+				 vscsi->lat_min_ns,
+				 vscsi->lat_max_ns,
+				 interval,
+				 vscsi->ema_cmp_int_ns,
+				 wk_kick,
+				 sleep_cnt);
+			vscsi->lat_sum_ns = 0;
+			vscsi->lat_count = 0;
+			vscsi->lat_min_ns = 0;
+			vscsi->lat_max_ns = 0;
+			vscsi->host_sum_ns = 0;
+			vscsi->cb_wait_sum_ns = 0;
+			vscsi->det_count = 0;
+			vscsi->lat_last_print = jiffies;
+		}
+		spin_unlock_irqrestore(&vscsi->lat_lock, flags);
+	}
+
 	scsi_done(sc);
 }
 
@@ -204,6 +306,7 @@ static void virtscsi_req_done(struct virtqueue *vq)
 	int index = vq->index - VIRTIO_SCSI_VQ_BASE;
 	struct virtio_scsi_vq *req_vq = &vscsi->req_vqs[index];
 
+	vscsi->last_cq_detect_ns = virtqueue_get_cq_detect_ns(vq);
 	virtscsi_vq_done(vscsi, req_vq, virtscsi_complete_cmd);
 };
 
@@ -514,8 +617,12 @@ static int virtscsi_add_cmd(struct virtio_scsi_vq *vq,
 
 	spin_unlock_irqrestore(&vq->vq_lock, flags);
 
-	if (needs_kick)
+	if (needs_kick) {
+		cmd->notify_ns = ktime_get_ns();
 		virtqueue_notify(vq->vq);
+	} else {
+		cmd->notify_ns = 0;
+	}
 	return err;
 }
 
@@ -605,6 +712,7 @@ static enum scsi_qc_status virtscsi_queuecommand(struct Scsi_Host *shost,
 	}
 
 	kick = (sc->flags & SCMD_LAST) != 0;
+	cmd->submit_ns = ktime_get_ns();
 	ret = virtscsi_add_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd), kick);
 	if (ret == -EIO) {
 		cmd->resp.cmd.response = VIRTIO_SCSI_S_BAD_TARGET;
@@ -895,6 +1003,9 @@ static int virtscsi_init(struct virtio_device *vdev,
 		virtscsi_init_vq(&vscsi->req_vqs[i - VIRTIO_SCSI_VQ_BASE],
 				 vqs[i]);
 
+	spin_lock_init(&vscsi->lat_lock);
+	vscsi->lat_last_print = jiffies;
+
 	virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
 	virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
 
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index eefcfe90d6b8..769e95ee5be4 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_VIRTIO) += virtio.o virtio_ring.o
+obj-$(CONFIG_VIRTIO) += virtio.o virtio_ring.o virtio_sqcq_poll.o
 obj-$(CONFIG_VIRTIO_ANCHOR) += virtio_anchor.o
 obj-$(CONFIG_VIRTIO_PCI_LIB) += virtio_pci_modern_dev.o
 obj-$(CONFIG_VIRTIO_PCI_LIB_LEGACY) += virtio_pci_legacy_dev.o
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 5bdc6b82b30b..d440e920f8e6 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -221,6 +221,16 @@ static int virtio_features_ok(struct virtio_device *dev)
 		}
 	}
 
+	/* SQ/CQ poll only supports split ring; reject packed ring
+	 * to avoid split-specific field access in virtqueue_notify().
+	 */
+	if (virtio_has_feature(dev, VIRTIO_F_SQCQ_POLL) &&
+	    virtio_has_feature(dev, VIRTIO_F_RING_PACKED)) {
+		dev_warn(&dev->dev,
+			 "VIRTIO_F_SQCQ_POLL is incompatible with VIRTIO_F_RING_PACKED\n");
+		return -ENODEV;
+	}
+
 	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
 		return 0;
 
diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index da97b6a988de..cd22651c73e2 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -268,6 +268,9 @@ void vp_del_vqs(struct virtio_device *vdev)
 	struct virtqueue *vq, *n;
 	int i;
 
+	/* Stop SQ/CQ poll thread before deleting virtqueues */
+	virtio_stop_sqcq_poll(vdev);
+
 	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
 		info = vp_is_avq(vdev, vq->index) ? vp_dev->admin_vq.info :
 						    vp_dev->vqs[vq->index];
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 6d8ae2a6a8ca..7a36ec4584a6 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -18,6 +18,7 @@
 #include <linux/virtio_pci_admin.h>
 #define VIRTIO_PCI_NO_LEGACY
 #define VIRTIO_RING_NO_LEGACY
+
 #include "virtio_pci_common.h"
 
 #define VIRTIO_AVQ_SGS_MAX	4
@@ -378,6 +379,9 @@ static void vp_transport_features(struct virtio_device *vdev, u64 features)
 
 	if (features & BIT_ULL(VIRTIO_F_ADMIN_VQ))
 		__virtio_set_bit(vdev, VIRTIO_F_ADMIN_VQ);
+
+	if (features & BIT_ULL(VIRTIO_F_SQCQ_POLL))
+		__virtio_set_bit(vdev, VIRTIO_F_SQCQ_POLL);
 }
 
 static int __vp_check_common_size_one_feature(struct virtio_device *vdev, u32 fbit,
@@ -413,6 +417,9 @@ static int vp_check_common_size(struct virtio_device *vdev)
 	if (vp_check_common_size_one_feature(vdev, VIRTIO_F_ADMIN_VQ, admin_queue_num))
 		return -EINVAL;
 
+	if (vp_check_common_size_one_feature(vdev, VIRTIO_F_SQCQ_POLL, cqe_ring_hi))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -578,6 +585,11 @@ static int vp_active_vq(struct virtqueue *vq, u16 msix_vec)
 				virtqueue_get_avail_addr(vq),
 				virtqueue_get_used_addr(vq));
 
+	if (virtqueue_sqcq_poll_active(vq))
+		vp_modern_queue_address_sqcq(mdev, index,
+					     virtqueue_get_sq_dma_addr(vq),
+					     virtqueue_get_cq_dma_addr(vq));
+
 	if (msix_vec != VIRTIO_MSI_NO_VECTOR) {
 		msix_vec = vp_modern_queue_vector(mdev, index, msix_vec);
 		if (msix_vec == VIRTIO_MSI_NO_VECTOR)
@@ -753,6 +765,27 @@ static int vp_modern_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 	if (rc)
 		return rc;
 
+	/* Start SQ/CQ poll thread if feature negotiated */
+	if (virtio_has_feature(vdev, VIRTIO_F_SQCQ_POLL)) {
+		dev_info(&vdev->dev, "VIRTIO_F_SQCQ_POLL negotiated, starting poll thread\n");
+		rc = virtio_start_sqcq_poll(vdev, 1000, 1000);
+		if (rc)
+			goto err_del_vqs;
+
+		list_for_each_entry(vq, &vdev->vqs, list) {
+			if (!virtqueue_sqcq_poll_active(vq))
+				continue;
+			rc = virtio_sqcq_poll_register_vq(vdev, vq);
+			if (rc) {
+				dev_err(&vdev->dev,
+					"failed to register vq %d (%s) with poll thread: %d\n",
+					vq->index,
+					vq->name ? vq->name : "?", rc);
+				goto err_stop_poll;
+			}
+		}
+	}
+
 	/* Select and activate all queues. Has to be done last: once we do
 	 * this, there's no way to go back except reset.
 	 */
@@ -760,6 +793,12 @@ static int vp_modern_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		vp_modern_set_queue_enable(&vp_dev->mdev, vq->index, true);
 
 	return 0;
+
+err_stop_poll:
+	virtio_stop_sqcq_poll(vdev);
+err_del_vqs:
+	vp_del_vqs(vdev);
+	return rc;
 }
 
 static void del_vq(struct virtio_pci_vq_info *info)
diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
index 413a8c353463..642b9a58751c 100644
--- a/drivers/virtio/virtio_pci_modern_dev.c
+++ b/drivers/virtio/virtio_pci_modern_dev.c
@@ -211,6 +211,14 @@ static inline void check_offsets(void)
 		     offsetof(struct virtio_pci_modern_common_cfg, admin_queue_index));
 	BUILD_BUG_ON(VIRTIO_PCI_COMMON_ADM_Q_NUM !=
 		     offsetof(struct virtio_pci_modern_common_cfg, admin_queue_num));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_SQE_LO !=
+		     offsetof(struct virtio_pci_modern_common_cfg, sqe_ring_lo));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_SQE_HI !=
+		     offsetof(struct virtio_pci_modern_common_cfg, sqe_ring_hi));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_CQE_LO !=
+		     offsetof(struct virtio_pci_modern_common_cfg, cqe_ring_lo));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_CQE_HI !=
+		     offsetof(struct virtio_pci_modern_common_cfg, cqe_ring_hi));
 }
 
 /*
@@ -300,7 +308,7 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
 	mdev->common = vp_modern_map_capability(mdev, common,
 			      sizeof(struct virtio_pci_common_cfg), 4, 0,
 			      offsetofend(struct virtio_pci_modern_common_cfg,
-					  admin_queue_num),
+					  cqe_ring_hi),
 			      &mdev->common_len, NULL);
 	if (!mdev->common)
 		goto err_map_common;
@@ -607,6 +615,30 @@ void vp_modern_queue_address(struct virtio_pci_modern_device *mdev,
 }
 EXPORT_SYMBOL_GPL(vp_modern_queue_address);
 
+/*
+ * vp_modern_queue_address_sqcq - set the SQ/CQ doorbell DMA addresses
+ * @mdev: the modern virtio-pci device
+ * @index: the queue index
+ * @sq_addr: DMA address of the SQ doorbell
+ * @cq_addr: DMA address of the CQ doorbell
+ */
+void vp_modern_queue_address_sqcq(struct virtio_pci_modern_device *mdev,
+				  u16 index, u64 sq_addr, u64 cq_addr)
+{
+	struct virtio_pci_modern_common_cfg __iomem *cfg;
+
+	cfg = (struct virtio_pci_modern_common_cfg __iomem *)mdev->common;
+
+	vp_iowrite16(index, &cfg->cfg.queue_select);
+
+	vp_iowrite64_twopart(sq_addr, &cfg->sqe_ring_lo,
+			     &cfg->sqe_ring_hi);
+
+	vp_iowrite64_twopart(cq_addr, &cfg->cqe_ring_lo,
+			     &cfg->cqe_ring_hi);
+}
+EXPORT_SYMBOL_GPL(vp_modern_queue_address_sqcq);
+
 /*
  * vp_modern_set_queue_enable - enable a virtqueue
  * @mdev: the modern virtio-pci device
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 335692d41617..a3aaf123ee74 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -270,10 +270,25 @@ struct vring_virtqueue {
 	bool last_add_time_valid;
 	ktime_t last_add_time;
 #endif
+
+	/* SQ/CQ polling state (VIRTIO_F_SQCQ_POLL) */
+	bool sqcq_poll;		/* Is SQ/CQ polling active? */
+	struct vring_sq *sq;	/* DMA-coherent SQ doorbell */
+	struct vring_cq *cq;	/* DMA-coherent CQ doorbell */
+	dma_addr_t sq_dma_addr;	/* DMA address of SQ */
+	dma_addr_t cq_dma_addr;	/* DMA address of CQ */
+	atomic_t sq_mmio_count;  /* MMIO kicks (sq_need_wakeup=1) */
+	u64 last_cq_detect_ns;	   /* ktime_get_ns() when CQ work first detected */
+	u64 sq_last_notify_ns;	   /* ktime of last sq->idx store */
+	u64 sq_ema_interval_ns;   /* EMA of sq->idx update interval (ns) */
 };
 
 static struct vring_desc_extra *vring_alloc_desc_extra(unsigned int num);
 static void vring_free(struct virtqueue *_vq);
+static int virtio_alloc_sqcq(struct virtio_device *vdev,
+			     struct vring_virtqueue *vq);
+static void virtio_free_sqcq(struct virtio_device *vdev,
+			     struct vring_virtqueue *vq);
 
 /*
  * Helpers.
@@ -1334,6 +1349,10 @@ static struct virtqueue *__vring_new_virtqueue_split(unsigned int index,
 	vq->layout = virtio_has_feature(vdev, VIRTIO_F_IN_ORDER) ?
 		     VQ_LAYOUT_SPLIT_IN_ORDER : VQ_LAYOUT_SPLIT;
 
+	vq->sqcq_poll = false;
+	vq->sq = NULL;
+	vq->cq = NULL;
+
 	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
 		vq->weak_barriers = false;
 
@@ -1385,6 +1404,17 @@ static struct virtqueue *vring_create_virtqueue_split(
 
 	to_vvq(vq)->we_own_ring = true;
 
+	if (virtio_has_feature(vdev, VIRTIO_F_SQCQ_POLL)) {
+		if (virtio_alloc_sqcq(vdev, to_vvq(vq))) {
+			/* vq is on vdev->vqs list; use vring_del_virtqueue()
+			 * to remove and free. vring_free_split() would
+			 * double-free via later vp_del_vqs().
+			 */
+			vring_del_virtqueue(vq);
+			return NULL;
+		}
+	}
+
 	return vq;
 }
 
@@ -2554,6 +2584,10 @@ static struct virtqueue *__vring_new_virtqueue_packed(unsigned int index,
 	vq->layout = virtio_has_feature(vdev, VIRTIO_F_IN_ORDER) ?
 		     VQ_LAYOUT_PACKED_IN_ORDER : VQ_LAYOUT_PACKED;
 
+	vq->sqcq_poll = false;
+	vq->sq = NULL;
+	vq->cq = NULL;
+
 	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
 		vq->weak_barriers = false;
 
@@ -3013,6 +3047,9 @@ bool virtqueue_kick_prepare(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
+	if (vq->sqcq_poll)
+		return true;
+
 	return VIRTQUEUE_CALL(vq, kick_prepare);
 }
 EXPORT_SYMBOL_GPL(virtqueue_kick_prepare);
@@ -3032,6 +3069,45 @@ bool virtqueue_notify(struct virtqueue *_vq)
 	if (unlikely(vq->broken))
 		return false;
 
+	/* SQ/CQ polling mode: update SQ idx instead of MMIO kick. */
+	if (vq->sqcq_poll) {
+		u16 new_sq_idx = vq->split.avail_idx_shadow;
+		u8 need_wakeup;
+
+		/* Release: make descriptor writes visible before sq->idx */
+		smp_store_release(&vq->sq->idx, new_sq_idx);
+
+		/* Track submission interval (matches host's interval metric) */
+		{
+			u64 _now = ktime_get_ns();
+
+			if (vq->sq_last_notify_ns) {
+				u64 _int = _now - vq->sq_last_notify_ns;
+
+				if (vq->sq_ema_interval_ns == 0)
+					vq->sq_ema_interval_ns = _int;
+				else
+					vq->sq_ema_interval_ns =
+						vq->sq_ema_interval_ns -
+						vq->sq_ema_interval_ns / 8 +
+						_int / 8;
+			}
+			vq->sq_last_notify_ns = _now;
+		}
+
+		/* Acquire: order sq->idx store before reading sq_need_wakeup.
+		 * Prevents stale read on ARM/RISC-V causing missed kick
+		 * when host has set sq_need_wakeup=1 and gone to sleep.
+		 */
+		need_wakeup = smp_load_acquire(&vq->sq->sq_need_wakeup);
+
+		/* Device poll thread is sleeping -- need MMIO kick to wake it */
+		if (!need_wakeup)
+			return true;
+		atomic_inc(&vq->sq_mmio_count);
+		/* Fall through to MMIO notify */
+	}
+
 	/* Prod other side to tell it about changes. */
 	if (!vq->notify(_vq)) {
 		vq->broken = true;
@@ -3230,6 +3306,12 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
+	/* SQ/CQ poll mode: wake the poll thread, let it handle completions */
+	if (vq->sqcq_poll) {
+		virtio_sqcq_poll_wake_thread(vq->vq.vdev);
+		return IRQ_HANDLED;
+	}
+
 	if (!more_used(vq)) {
 		pr_debug("virtqueue interrupt with no work for %p\n", vq);
 		return IRQ_NONE;
@@ -3250,6 +3332,7 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
 		data_race(vq->event_triggered = true);
 
 	pr_debug("virtqueue callback for %p (%p)\n", vq, vq->vq.callback);
+
 	if (vq->vq.callback)
 		vq->vq.callback(&vq->vq);
 
@@ -3468,6 +3551,8 @@ static void vring_free(struct virtqueue *_vq)
 		kfree(vq->split.desc_state);
 		kfree(vq->split.desc_extra);
 	}
+	if (vq->sqcq_poll)
+		virtio_free_sqcq(vq->vq.vdev, vq);
 }
 
 void vring_del_virtqueue(struct virtqueue *_vq)
@@ -3524,6 +3609,8 @@ void vring_transport_features(struct virtio_device *vdev)
 			break;
 		case VIRTIO_F_IN_ORDER:
 			break;
+		case VIRTIO_F_SQCQ_POLL:
+			break;
 		default:
 			/* We don't understand this bit. */
 			__virtio_clear_bit(vdev, i);
@@ -3663,6 +3750,181 @@ dma_addr_t virtqueue_get_used_addr(const struct virtqueue *_vq)
 }
 EXPORT_SYMBOL_GPL(virtqueue_get_used_addr);
 
+bool virtqueue_sqcq_poll_active(const struct virtqueue *_vq)
+{
+	const struct vring_virtqueue *vq = to_vvq(_vq);
+
+	return vq->sqcq_poll;
+}
+EXPORT_SYMBOL_GPL(virtqueue_sqcq_poll_active);
+
+/**
+ * virtqueue_disable_sqcq_poll - disable SQ/CQ poll mode for a virtqueue.
+ * @_vq: the virtqueue
+ *
+ * Clears sqcq_poll flag; restores MMIO kick + interrupt for this vq.
+ * Used for control/event queues that must not use the poll thread.
+ */
+void virtqueue_disable_sqcq_poll(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	vq->sqcq_poll = false;
+}
+EXPORT_SYMBOL_GPL(virtqueue_disable_sqcq_poll);
+
+dma_addr_t virtqueue_get_sq_dma_addr(const struct virtqueue *_vq)
+{
+	const struct vring_virtqueue *vq = to_vvq(_vq);
+
+	return vq->sq_dma_addr;
+}
+EXPORT_SYMBOL_GPL(virtqueue_get_sq_dma_addr);
+
+dma_addr_t virtqueue_get_cq_dma_addr(const struct virtqueue *_vq)
+{
+	const struct vring_virtqueue *vq = to_vvq(_vq);
+
+	return vq->cq_dma_addr;
+}
+EXPORT_SYMBOL_GPL(virtqueue_get_cq_dma_addr);
+
+/* Completion detection and sleep/wake accessors for the poll thread. */
+
+bool virtqueue_cq_poll_has_work(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	if (!vq->cq)
+		return false;
+
+	if (more_used(vq)) {
+		WRITE_ONCE(vq->last_cq_detect_ns, ktime_get_ns());
+		return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(virtqueue_cq_poll_has_work);
+
+unsigned int virtqueue_get_sq_notify_stats(struct virtqueue *_vq, u64 *interval)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	unsigned int mmio;
+
+	mmio = atomic_xchg(&vq->sq_mmio_count, 0);
+	if (interval)
+		*interval = vq->sq_ema_interval_ns;
+	return mmio;
+}
+EXPORT_SYMBOL_GPL(virtqueue_get_sq_notify_stats);
+
+void virtqueue_cq_set_need_wakeup(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	if (vq->cq)
+		/* Release: order prior used-ring reads before wakeup flag */
+		smp_store_release(&vq->cq->cq_need_wakeup, 1);
+}
+EXPORT_SYMBOL_GPL(virtqueue_cq_set_need_wakeup);
+
+void virtqueue_cq_clear_need_wakeup(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	if (vq->cq)
+		WRITE_ONCE(vq->cq->cq_need_wakeup, 0);
+}
+EXPORT_SYMBOL_GPL(virtqueue_cq_clear_need_wakeup);
+
+bool virtqueue_cq_recheck(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	if (!vq->cq)
+		return false;
+
+	/* Full barrier: order cq_need_wakeup store before used ring read */
+	smp_mb();
+	return more_used(vq);
+}
+EXPORT_SYMBOL_GPL(virtqueue_cq_recheck);
+
+u64 virtqueue_get_cq_detect_ns(const struct virtqueue *_vq)
+{
+	const struct vring_virtqueue *vq = to_vvq(_vq);
+
+	return READ_ONCE(vq->last_cq_detect_ns);
+}
+EXPORT_SYMBOL_GPL(virtqueue_get_cq_detect_ns);
+
+/*
+ * virtio_alloc_sqcq - allocate SQ/CQ doorbell structures for polling mode
+ * @vdev: the virtio device
+ * @vq: the vring_virtqueue to allocate for
+ *
+ * Called when VIRTIO_F_SQCQ_POLL is negotiated. Returns 0 on success.
+ */
+static int virtio_alloc_sqcq(struct virtio_device *vdev,
+			     struct vring_virtqueue *vq)
+{
+	struct device *dma_dev = vdev->dev.parent;
+
+	/* Control and event queues use traditional interrupt-driven I/O. */
+	if (vq->vq.name &&
+	    (strcmp(vq->vq.name, "control") == 0 ||
+	     strcmp(vq->vq.name, "event") == 0))
+		return 0;
+	size_t total = sizeof(struct vring_sq) + sizeof(struct vring_cq);
+	void *buf;
+
+	buf = dma_alloc_coherent(dma_dev, total, &vq->sq_dma_addr, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	memset(buf, 0, total);
+
+	vq->sq = buf;
+	vq->cq = buf + sizeof(struct vring_sq);
+	vq->cq_dma_addr = vq->sq_dma_addr + sizeof(struct vring_sq);
+	vq->sqcq_poll = true;
+	atomic_set(&vq->sq_mmio_count, 0);
+	vq->last_cq_detect_ns = 0;
+	vq->sq_last_notify_ns = 0;
+	vq->sq_ema_interval_ns = 0;
+
+	/* Diagnostic: dump SQ/CQ addresses for debug */
+	dev_dbg(&vdev->dev,
+		"vq %s: SQ/CQ doorbells kvirt=%p sq_dma=0x%llx cq_dma=0x%llx\n",
+		vq->vq.name ? vq->vq.name : "?",
+		buf,
+		(unsigned long long)vq->sq_dma_addr,
+		(unsigned long long)vq->cq_dma_addr);
+
+	return 0;
+}
+
+/*
+ * virtio_free_sqcq - free SQ/CQ doorbell structures
+ * @vdev: the virtio device
+ * @vq: the vring_virtqueue to free for
+ */
+static void virtio_free_sqcq(struct virtio_device *vdev,
+			     struct vring_virtqueue *vq)
+{
+	struct device *dma_dev = vdev->dev.parent;
+	size_t total = sizeof(struct vring_sq) + sizeof(struct vring_cq);
+
+	if (vq->sq) {
+		dma_free_coherent(dma_dev, total,
+				  vq->sq, vq->sq_dma_addr);
+		vq->sq = NULL;
+		vq->cq = NULL;
+	}
+	vq->sqcq_poll = false;
+}
+
 /* Only available for split ring */
 const struct vring *virtqueue_get_vring(const struct virtqueue *vq)
 {
diff --git a/drivers/virtio/virtio_sqcq_poll.c b/drivers/virtio/virtio_sqcq_poll.c
new file mode 100644
index 000000000000..411493218e93
--- /dev/null
+++ b/drivers/virtio/virtio_sqcq_poll.c
@@ -0,0 +1,338 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * virtio SQ/CQ polling thread.
+ *
+ * Replaces interrupt-based completion notification with a dedicated
+ * kernel thread that checks the used ring for completions. Uses the
+ * io_uring sqpoll pattern: busy-wait while active, then set
+ * NEED_WAKEUP and sleep when idle for a configurable timeout.
+ *
+ * Copyright (C) 2026
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/sched.h>
+#include <linux/completion.h>
+#include <linux/mutex.h>
+#include <linux/wait.h>
+#include <linux/sched/clock.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/kthread.h>
+#include <linux/virtio.h>
+#include <linux/virtio_config.h>
+#include <linux/virtio_ring.h>
+#include <linux/interrupt.h>
+
+/**
+ * struct virtio_sqcq_poll_data - per-device poll thread state.
+ *
+ * Follows the Host vhost_sqcq_poll_thread pattern.
+ */
+struct virtio_sqcq_poll_data {
+	struct mutex lock;
+
+	/* List of virtqueues served by this poll thread */
+	struct list_head vq_list;
+
+	struct task_struct *thread;
+	struct wait_queue_head wait;
+
+	unsigned int idle_timeout_us;	/* Sleep timeout (us) */
+	unsigned int busy_spin_us;	/* Busy-spin budget (us) */
+
+	unsigned long state;
+#define VIRTIO_SQ_THREAD_SHOULD_STOP	0
+
+	struct completion exited;
+	struct device *dev;		/* for dev_info() logging */
+
+	/* Poll thread diagnostic statistics */
+	unsigned long stat_sleep_count;
+};
+
+/**
+ * struct virtio_sqcq_vq_node - links a virtqueue to its poll_data.
+ */
+struct virtio_sqcq_vq_node {
+	struct virtqueue *vq;
+	struct list_head node;
+};
+
+static void virtio_sqcq_poll_wake(struct virtio_sqcq_poll_data *sqd)
+{
+	wake_up(&sqd->wait);
+}
+
+/**
+ * virtio_sqcq_poll_wake_thread - wake the CQ poll thread from IRQ context.
+ * @vdev: the virtio device
+ *
+ * Called by vring_interrupt() when SQ/CQ poll mode is active.  Wakes the
+ * poll thread so it can check the used ring and invoke completion
+ * callbacks in its own context, instead of handling completions directly
+ * from the hard-IRQ handler.
+ */
+void virtio_sqcq_poll_wake_thread(struct virtio_device *vdev)
+{
+	struct virtio_sqcq_poll_data *sqd = vdev->sqcq_poll_data;
+
+	if (sqd)
+		virtio_sqcq_poll_wake(sqd);
+}
+EXPORT_SYMBOL_GPL(virtio_sqcq_poll_wake_thread);
+
+unsigned long virtio_sqcq_poll_get_sleep_count(struct virtio_device *vdev)
+{
+	struct virtio_sqcq_poll_data *sqd = vdev->sqcq_poll_data;
+
+	if (!sqd)
+		return 0;
+
+	return xchg(&sqd->stat_sleep_count, 0);
+}
+EXPORT_SYMBOL_GPL(virtio_sqcq_poll_get_sleep_count);
+
+static int virtio_sqcq_poll_thread(void *data)
+{
+	struct virtio_sqcq_poll_data *sqd = data;
+	struct virtio_sqcq_vq_node *node;
+	ktime_t last_io_ts = ktime_get();
+	u64 spin_budget_ns = (u64)sqd->busy_spin_us * NSEC_PER_USEC;
+	int vq_count = 0;
+
+	/* Count registered vqs for the startup message */
+	mutex_lock(&sqd->lock);
+	list_for_each_entry(node, &sqd->vq_list, node)
+		vq_count++;
+	mutex_unlock(&sqd->lock);
+
+	dev_info(sqd->dev, "poll thread running, %d vqs, spin=%uus, idle=%uus\n",
+		 vq_count, sqd->busy_spin_us, sqd->idle_timeout_us);
+
+	while (!kthread_should_stop()) {
+		bool did_work = false;
+
+		if (test_bit(VIRTIO_SQ_THREAD_SHOULD_STOP, &sqd->state)) {
+			dev_info(sqd->dev, "poll thread stopping\n");
+			break;
+		}
+
+		if (signal_pending(current)) {
+			flush_signals(current);
+			continue;
+		}
+
+		mutex_lock(&sqd->lock);
+
+		/* Process completions on all registered virtqueues */
+		list_for_each_entry(node, &sqd->vq_list, node) {
+			while (virtqueue_cq_poll_has_work(node->vq)) {
+				if (node->vq->callback)
+					node->vq->callback(node->vq);
+				if (local_softirq_pending())
+					do_softirq();
+				did_work = true;
+			}
+		}
+
+		if (did_work) {
+			mutex_unlock(&sqd->lock);
+			last_io_ts = ktime_get();
+			continue;
+		}
+
+		/* No work — spin within the time budget from last_io_ts.
+		 * need_resched() + cpu_relax() for cooperative yielding,
+		 * same pattern as Host vhost_sqcq_poll_thread.
+		 */
+		if (spin_budget_ns > 0 &&
+		    ktime_to_ns(ktime_sub(ktime_get(), last_io_ts)) <
+				    (s64)spin_budget_ns) {
+			mutex_unlock(&sqd->lock);
+			if (need_resched())
+				cond_resched();
+			cpu_relax();
+			continue;
+		}
+
+		/* Spin budget expired — set cq_need_wakeup on all VQs
+		 * and sleep.  Double-check for work before sleeping to
+		 * close the lost-wakeup race.
+		 */
+		{
+			bool found_work = false;
+			DEFINE_WAIT(wait);
+
+			list_for_each_entry(node, &sqd->vq_list, node)
+				virtqueue_cq_set_need_wakeup(node->vq);
+
+			prepare_to_wait(&sqd->wait, &wait,
+					TASK_INTERRUPTIBLE);
+
+			list_for_each_entry(node, &sqd->vq_list, node) {
+				if (virtqueue_cq_recheck(node->vq)) {
+					found_work = true;
+					break;
+				}
+			}
+
+			if (!found_work) {
+				mutex_unlock(&sqd->lock);
+				schedule_timeout(
+					usecs_to_jiffies(sqd->idle_timeout_us));
+				sqd->stat_sleep_count++;
+				mutex_lock(&sqd->lock);
+			}
+
+			finish_wait(&sqd->wait, &wait);
+
+			list_for_each_entry(node, &sqd->vq_list, node)
+				virtqueue_cq_clear_need_wakeup(node->vq);
+		}
+
+		mutex_unlock(&sqd->lock);
+	}
+
+	complete(&sqd->exited);
+	return 0;
+}
+
+/**
+ * virtio_start_sqcq_poll - start the SQ/CQ poll thread for a device.
+ * @vdev: the virtio device
+ * @idle_timeout_us: idle timeout in microseconds before sleeping
+ * @busy_spin_us: busy-spin duration in microseconds before yielding
+ *
+ * Returns 0 on success, negative error on failure.
+ */
+int virtio_start_sqcq_poll(struct virtio_device *vdev,
+			   unsigned int idle_timeout_us,
+			   unsigned int busy_spin_us)
+{
+	struct virtio_sqcq_poll_data *sqd;
+
+	sqd = kzalloc(sizeof(*sqd), GFP_KERNEL);
+	if (!sqd)
+		return -ENOMEM;
+
+	mutex_init(&sqd->lock);
+	init_waitqueue_head(&sqd->wait);
+	INIT_LIST_HEAD(&sqd->vq_list);
+	init_completion(&sqd->exited);
+	sqd->idle_timeout_us = idle_timeout_us ? idle_timeout_us : 1000;
+	sqd->busy_spin_us = busy_spin_us;
+	sqd->dev = &vdev->dev;
+
+	sqd->thread = kthread_create(virtio_sqcq_poll_thread, sqd,
+				     "virtio-sqcq/%s", dev_name(&vdev->dev));
+	if (IS_ERR(sqd->thread)) {
+		kfree(sqd);
+		return PTR_ERR(sqd->thread);
+	}
+
+	vdev->sqcq_poll_data = sqd;
+	wake_up_process(sqd->thread);
+
+	dev_info(sqd->dev, "SQ/CQ poll thread started, idle_timeout=%uus, spin_us=%u\n",
+		 sqd->idle_timeout_us, sqd->busy_spin_us);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(virtio_start_sqcq_poll);
+
+/**
+ * virtio_stop_sqcq_poll - stop the SQ/CQ poll thread for a device.
+ * @vdev: the virtio device
+ */
+void virtio_stop_sqcq_poll(struct virtio_device *vdev)
+{
+	struct virtio_sqcq_poll_data *sqd = vdev->sqcq_poll_data;
+	struct virtio_sqcq_vq_node *node, *tmp;
+
+	if (!sqd)
+		return;
+
+	set_bit(VIRTIO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+
+	dev_info(sqd->dev, "SQ/CQ poll thread stopping\n");
+	virtio_sqcq_poll_wake(sqd);
+	wait_for_completion(&sqd->exited);
+
+	/* Reap kthread task_struct to avoid zombie thread leak.
+	 * Thread already exited via complete(); safe to call on
+	 * already-exited kthread.
+	 */
+	kthread_stop(sqd->thread);
+
+	/* Free all vq nodes */
+	list_for_each_entry_safe(node, tmp, &sqd->vq_list, node) {
+		list_del(&node->node);
+		kfree(node);
+	}
+
+	vdev->sqcq_poll_data = NULL;
+	kfree(sqd);
+}
+EXPORT_SYMBOL_GPL(virtio_stop_sqcq_poll);
+
+/**
+ * virtio_sqcq_poll_register_vq - register a virtqueue with the poll thread.
+ * @vdev: the virtio device
+ * @vq: the virtqueue to register
+ *
+ * The virtqueue must have VIRTIO_F_SQCQ_POLL active.
+ * Returns 0 on success, negative error on failure.
+ */
+int virtio_sqcq_poll_register_vq(struct virtio_device *vdev,
+				 struct virtqueue *vq)
+{
+	struct virtio_sqcq_poll_data *sqd = vdev->sqcq_poll_data;
+	struct virtio_sqcq_vq_node *node;
+
+	if (!sqd || !virtqueue_sqcq_poll_active(vq))
+		return -EINVAL;
+
+	node = kmalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+
+	node->vq = vq;
+
+	mutex_lock(&sqd->lock);
+	list_add_tail(&node->node, &sqd->vq_list);
+	mutex_unlock(&sqd->lock);
+
+	dev_info(sqd->dev, "vq index=%d (%s) registered with poll thread\n",
+		 vq->index, vq->name ? vq->name : "?");
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(virtio_sqcq_poll_register_vq);
+
+/**
+ * virtio_sqcq_poll_unregister_vq - unregister a virtqueue from the poll thread.
+ * @vdev: the virtio device
+ * @vq: the virtqueue to unregister
+ */
+void virtio_sqcq_poll_unregister_vq(struct virtio_device *vdev,
+				    struct virtqueue *vq)
+{
+	struct virtio_sqcq_poll_data *sqd = vdev->sqcq_poll_data;
+	struct virtio_sqcq_vq_node *node, *tmp;
+
+	if (!sqd)
+		return;
+
+	mutex_lock(&sqd->lock);
+	list_for_each_entry_safe(node, tmp, &sqd->vq_list, node) {
+		if (node->vq == vq) {
+			list_del(&node->node);
+			kfree(node);
+			break;
+		}
+	}
+	mutex_unlock(&sqd->lock);
+}
+EXPORT_SYMBOL_GPL(virtio_sqcq_poll_unregister_vq);
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 3bbc4cb6a672..8300e0946719 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -125,6 +125,28 @@ dma_addr_t virtqueue_get_desc_addr(const struct virtqueue *vq);
 dma_addr_t virtqueue_get_avail_addr(const struct virtqueue *vq);
 dma_addr_t virtqueue_get_used_addr(const struct virtqueue *vq);
 
+/* SQ/CQ polling (VIRTIO_F_SQCQ_POLL) */
+bool virtqueue_sqcq_poll_active(const struct virtqueue *vq);
+void virtqueue_disable_sqcq_poll(struct virtqueue *vq);
+dma_addr_t virtqueue_get_sq_dma_addr(const struct virtqueue *vq);
+dma_addr_t virtqueue_get_cq_dma_addr(const struct virtqueue *vq);
+u64 virtqueue_get_cq_detect_ns(const struct virtqueue *vq);
+int virtio_start_sqcq_poll(struct virtio_device *vdev,
+			   unsigned int idle_timeout_us,
+			   unsigned int busy_spin_us);
+void virtio_stop_sqcq_poll(struct virtio_device *vdev);
+void virtio_sqcq_poll_wake_thread(struct virtio_device *vdev);
+int virtio_sqcq_poll_register_vq(struct virtio_device *vdev,
+				 struct virtqueue *vq);
+void virtio_sqcq_poll_unregister_vq(struct virtio_device *vdev,
+				    struct virtqueue *vq);
+bool virtqueue_cq_poll_has_work(struct virtqueue *vq);
+unsigned int virtqueue_get_sq_notify_stats(struct virtqueue *vq, u64 *interval);
+unsigned long virtio_sqcq_poll_get_sleep_count(struct virtio_device *vdev);
+void virtqueue_cq_set_need_wakeup(struct virtqueue *vq);
+void virtqueue_cq_clear_need_wakeup(struct virtqueue *vq);
+bool virtqueue_cq_recheck(struct virtqueue *vq);
+
 int virtqueue_resize(struct virtqueue *vq, u32 num,
 		     void (*recycle)(struct virtqueue *vq, void *buf),
 		     void (*recycle_done)(struct virtqueue *vq));
@@ -165,6 +187,8 @@ struct virtio_admin_cmd {
  * @debugfs_dir: debugfs directory entry.
  * @debugfs_filter_features: features to be filtered set by debugfs.
  */
+struct virtio_sqcq_poll_data;
+
 struct virtio_device {
 	int index;
 	bool failed;
@@ -182,6 +206,7 @@ struct virtio_device {
 	VIRTIO_DECLARE_FEATURES(features);
 	void *priv;
 	union virtio_map vmap;
+	struct virtio_sqcq_poll_data *sqcq_poll_data; /* SQ/CQ poll thread state */
 #ifdef CONFIG_VIRTIO_DEBUG
 	struct dentry *debugfs_dir;
 	u64 debugfs_filter_features[VIRTIO_FEATURES_U64S];
diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
index 9a3f2fc53bd6..36810f9d23f3 100644
--- a/include/linux/virtio_pci_modern.h
+++ b/include/linux/virtio_pci_modern.h
@@ -145,6 +145,8 @@ u16 vp_modern_config_vector(struct virtio_pci_modern_device *mdev,
 void vp_modern_queue_address(struct virtio_pci_modern_device *mdev,
 			     u16 index, u64 desc_addr, u64 driver_addr,
 			     u64 device_addr);
+void vp_modern_queue_address_sqcq(struct virtio_pci_modern_device *mdev,
+				  u16 index, u64 sq_addr, u64 cq_addr);
 void vp_modern_set_queue_enable(struct virtio_pci_modern_device *mdev,
 				u16 idx, bool enable);
 bool vp_modern_get_queue_enable(struct virtio_pci_modern_device *mdev,
-- 
2.34.1

