Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F4C233920;
	Mon, 20 Jul 2026 14:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784556691; cv=none; b=JMk5FBrjynhdPbuVO3oL/YqlLxZfCrtHILjjpSH41bJgoNeFVHL93EWuJokTZ167FqlT9Oxyb/gxgGUrNEZNSZXBA7QHQENaYtEYU/Vs2pg0vSGdZYrKy8LHijDujuaDqSqfWQeeDH9Bmz8q/vb7b1KbefKZn1T29B/3peHhaFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784556691; c=relaxed/simple;
	bh=aKgk7WJQ2y6hkMjZ2T2pN9NhrkaaUZcdCyA14QVEjIQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tfROlnLFSibprFCcZudVDQ1MrOfvl/zKKyRtDuXIL5mzjen2ZZG3e1VfP4Wt69mnlg/T/pszmECJMGJduWpAAuOUqvqLH+NDbuZs2WfFAysXUz6RzG1HaqyByzyDtxgHynyiAeSzN4af+a+1GNuQPJYR8F05pJe4Lg3moJd5b0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=O1HV7DSG; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="O1HV7DSG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=CO9Al5GPtC4ZgyEFmL+3ZuFzpk3dAPxBpTXH8Cw7El0=;
	b=O1HV7DSG1m9bI5mUv2LKR3+Hn8M7/nSd+owcWqYg/oWQ2HCFeaXyEBSKpD/o0R
	JrzyrsLQM6sBLXdCyVkkw7xwpJCx3qGgHz7UaTIzhk7yJeo5B0bzSz8anfEF54hm
	wzUigODQItMi3+91HByBVWFBI1haarrp0IoOjUQ4P9onE=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgD3Xw9gLF5qWUvpIg--.12525S3;
	Mon, 20 Jul 2026 22:10:43 +0800 (CST)
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
Subject: [RFC PATCH 1/4] common: add UAPI for SQ/CQ doorbell polling
Date: Mon, 20 Jul 2026 22:10:37 +0800
Message-Id: <20260720141040.181946-2-r4o5m6e8o@163.com>
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
X-CM-TRANSID:PigvCgD3Xw9gLF5qWUvpIg--.12525S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxCw43Gr4fCr1UCw48XrW7CFg_yoWrXFyUpF
	WkCrW3Xr4UXa4xCrZ5G3WUtry3Xas3CF43G3yagw1j9F9IqFy8Zw4Dur4avay2vrWvyryx
	Xrn2qryUC34DArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UNTmDUUUUU=
X-CM-SenderInfo: 3uurkzkwhy0qqrwthudrp/xtbCzQNVympeLGONpgAA3B

From: Yufeng Wang <wangyufeng@kylinos.cn>

Define VIRTIO_F_SQCQ_POLL (bit 42) and the associated SQ/CQ doorbell
structures for split virtqueue polling mode.

  - include/uapi/linux/virtio_config.h: feature bit 42
  - include/uapi/linux/virtio_ring.h: struct vring_sq, struct vring_cq
    (128-byte aligned for cache-line isolation on ARM Neoverse N2/V2)
  - include/uapi/linux/virtio_pci.h: sqe/cqe_ring PCI config registers
    at offsets 64-76

Signed-off-by: Yufeng Wang <wangyufeng@kylinos.cn>
---
 include/uapi/linux/virtio_config.h |  8 +++++++-
 include/uapi/linux/virtio_pci.h    |  9 +++++++++
 include/uapi/linux/virtio_ring.h   | 25 +++++++++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index 2445f365bce7..dbda23e44b62 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -52,7 +52,7 @@
  * rest are per-device feature bits.
  */
 #define VIRTIO_TRANSPORT_F_START	28
-#define VIRTIO_TRANSPORT_F_END		42
+#define VIRTIO_TRANSPORT_F_END		43
 
 #ifndef VIRTIO_CONFIG_NO_LEGACY
 /* Do we get callbacks when the ring is completely used, even if we've
@@ -120,4 +120,10 @@
  */
 #define VIRTIO_F_ADMIN_VQ		41
 
+/*
+ * This feature indicates that both driver and device support
+ * SQ/CQ polling mode to replace interrupt-based notifications.
+ */
+#define VIRTIO_F_SQCQ_POLL		42
+
 #endif /* _UAPI_LINUX_VIRTIO_CONFIG_H */
diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index e732e3456e27..f5058d1b4b16 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -193,6 +193,11 @@ struct virtio_pci_modern_common_cfg {
 
 	__le16 admin_queue_index;	/* read-only */
 	__le16 admin_queue_num;		/* read-only */
+
+	__le32 sqe_ring_lo;		/* read-write: SQ DMA addr low */
+	__le32 sqe_ring_hi;		/* read-write: SQ DMA addr high */
+	__le32 cqe_ring_lo;		/* read-write: CQ DMA addr low */
+	__le32 cqe_ring_hi;		/* read-write: CQ DMA addr high */
 };
 
 /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
@@ -235,6 +240,10 @@ struct virtio_pci_cfg_cap {
 #define VIRTIO_PCI_COMMON_Q_RESET	58
 #define VIRTIO_PCI_COMMON_ADM_Q_IDX	60
 #define VIRTIO_PCI_COMMON_ADM_Q_NUM	62
+#define VIRTIO_PCI_COMMON_SQE_LO	64
+#define VIRTIO_PCI_COMMON_SQE_HI	68
+#define VIRTIO_PCI_COMMON_CQE_LO	72
+#define VIRTIO_PCI_COMMON_CQE_HI	76
 
 #endif /* VIRTIO_PCI_NO_MODERN */
 
diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
index 3c478582a3c2..d1f2b9584d7c 100644
--- a/include/uapi/linux/virtio_ring.h
+++ b/include/uapi/linux/virtio_ring.h
@@ -131,6 +131,31 @@ struct vring_used {
 	vring_used_elem_t ring[];
 };
 
+/*
+ * SQ/CQ doorbell structures for polling mode (VIRTIO_F_SQCQ_POLL).
+ * These are allocated separately from the vring and their DMA addresses
+ * are communicated via PCI config space registers.
+ *
+ * Ownership:
+ *   SQ: Guest writes idx, Device reads it.
+ *   CQ: Device writes idx, Guest reads it.
+ *
+ * Flags (8-bit):
+ *   Set to 1 before sleeping, cleared to 0 after waking up.
+ *   Direct assignment — no read-modify-write.
+ */
+struct vring_sq {
+	__virtio64 idx;			/* Producer position (updated by guest) */
+	__u8 sq_need_wakeup;		/* 1 = device should be woken on next kick */
+	__u8 reserved[55];		/* Reserved for future use */
+} __attribute__((aligned(128)));
+
+struct vring_cq {
+	__virtio64 idx;			/* Producer position (updated by device) */
+	__u8 cq_need_wakeup;		/* 1 = guest should be woken on completion */
+	__u8 reserved[55];		/* Reserved for future use */
+} __attribute__((aligned(128)));
+
 /*
  * The ring element addresses are passed between components with different
  * alignments assumptions. Thus, we might need to decrease the compiler-selected
-- 
2.34.1

