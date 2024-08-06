Received: from mail.nearlyone.de (mail.nearlyone.de [49.12.199.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27342A1CF;
	Tue,  6 Aug 2024 12:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.199.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722946043; cv=none; b=UOy4EaiM05xG770ihwUmtRo7cS9XnAClzw6AP77CIzKlhywVDvxZgiFB4xupQQwR57X5/R/YBWRR6/YL8xHssTT1fxhUt3wepQB0xFCcyiEOdB789cKSZrYype/bSMoLG6QOAW3uhlc7NWSvBVNavpuiEWVQGZnBTZarpyafvJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722946043; c=relaxed/simple;
	bh=5xZEpCamrisM3ZY1uhqwvg3xIwGtgCCiTTNrvm592ys=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EUqIHRb3dVj1YsYj41BfNX83LgFAE4zGPC2N6GARuhzj4wihcSxPC5kzuocbB/K/z0c3zXlI7UAaLRF7XcMRsu9sKszD+bS5VEWOHdD6puBV2devTc9ZlcfhwLjaexA3vMtq1o/VhdTxd4HPEaT3fd+sKKYXowlTtOVhy+76Iss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=monom.org; dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b=hGSOpiqr; arc=none smtp.client-ip=49.12.199.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monom.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b="hGSOpiqr"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6C9DEDAE18;
	Tue,  6 Aug 2024 14:07:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
	t=1722946037; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=dmrNqBrbkcKDE+U6rGD19skovid6loVHnpDbIXnwZRA=;
	b=hGSOpiqrvOiNJX+ty88Jun0oxEGwr3jmah6giDquz8VDjuAAtJwOhptpzSfWOSkQU3992x
	Ed25eqUxL90XOeI3JJlIEN294THOZEkJBIm3q7D9FHEOCG6fGxePp0WV1oukX8kFEELhnB
	K/eu+mSe0DJpUqBf8agTafzOegpmp0iuI7yJjM5f3hrTjSDR8I/l4yjBou3Xov/EVXwbJz
	/hsVv5vyr6DL5w4NCWk4VJkYbofxwHkQ026M29fsVnTMikVABwBtFzGoIYteBLm2FQdZQG
	W9HFiUm/MwZ2Qq3o3kAuUD7XcBVib/OlsTvFCW1DnQpqZhyE0JJV8g2sPCFXtw==
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 06 Aug 2024 14:06:35 +0200
Subject: [PATCH v3 03/15] blk-mq: introduce blk_mq_dev_map_queues
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240806-isolcpus-io-queues-v3-3-da0eecfeaf8b@suse.de>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
In-Reply-To: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Sagi Grimberg <sagi@grimberg.me>, Thomas Gleixner <tglx@linutronix.de>, 
 Christoph Hellwig <hch@lst.de>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 John Garry <john.g.garry@oracle.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, 
 Kashyap Desai <kashyap.desai@broadcom.com>, 
 Sumit Saxena <sumit.saxena@broadcom.com>, 
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
 Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, 
 Jonathan Corbet <corbet@lwn.net>
Cc: Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, 
 Hannes Reinecke <hare@suse.de>, 
 Sridhar Balaraman <sbalaraman@parallelwireless.com>, 
 "brookxu.cn" <brookxu.cn@gmail.com>, Ming Lei <ming.lei@redhat.com>, 
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
 virtualization@lists.linux.dev, megaraidlinux.pdl@broadcom.com, 
 mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, 
 storagedev@microchip.com, linux-doc@vger.kernel.org, 
 Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.14.0
X-Last-TLS-Session-Version: TLSv1.3

From: Ming Lei <ming.lei@redhat.com>

blk_mq_pci_map_queues and blk_mq_virtio_map_queues will create a CPU to
hardware queue mapping based on affinity information. These two
function share code which only differs on how the affinity information
is retrieved. Also there is the hisi_sas which open codes the same loop.

Thus introduce a new helper function for creating these mappings which
takes an callback function for fetching the affinity mask. Also
introduce common helper function for PCI and virtio devices to retrieve
affinity masks.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
[dwagner: - removed fallback mapping
          - added affintity helpers
	  - updated commit message]
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 block/blk-mq-cpumap.c         | 35 +++++++++++++++++++++++++++++++++++
 block/blk-mq-pci.c            | 18 ++++++++++++++++++
 block/blk-mq-virtio.c         | 19 +++++++++++++++++++
 include/linux/blk-mq-pci.h    |  2 ++
 include/linux/blk-mq-virtio.h |  3 +++
 include/linux/blk-mq.h        |  5 +++++
 6 files changed, 82 insertions(+)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 9638b25fd521..7037a2dc485f 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -54,3 +54,38 @@ int blk_mq_hw_queue_to_node(struct blk_mq_queue_map *qmap, unsigned int index)
 
 	return NUMA_NO_NODE;
 }
+
+/**
+ * blk_mq_dev_map_queues - Create CPU to hardware queue mapping
+ * @qmap:	CPU to hardware queue map.
+ * @dev_off:	Offset to use for the device.
+ * @dev_data:	Device data passed to get_queue_affinity().
+ * @get_queue_affinity:	Callback to retrieve queue affinity.
+ *
+ * Create a CPU to hardware queue mapping in @qmap. For each queue
+ * @get_queue_affinity will be called to retrieve the affinity for given
+ * queue.
+ */
+void blk_mq_dev_map_queues(struct blk_mq_queue_map *qmap,
+			   void *dev_data, int dev_off,
+			   get_queue_affinty_fn *get_queue_affinity)
+{
+	const struct cpumask *mask;
+	unsigned int queue, cpu;
+
+	for (queue = 0; queue < qmap->nr_queues; queue++) {
+		mask = get_queue_affinity(dev_data, dev_off, queue);
+		if (!mask)
+			goto fallback;
+
+		for_each_cpu(cpu, mask)
+			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+	}
+
+	return;
+
+fallback:
+	WARN_ON_ONCE(qmap->nr_queues > 1);
+	blk_mq_clear_mq_map(qmap);
+}
+EXPORT_SYMBOL_GPL(blk_mq_dev_map_queues);
diff --git a/block/blk-mq-pci.c b/block/blk-mq-pci.c
index d47b5c73c9eb..71a73238aeb2 100644
--- a/block/blk-mq-pci.c
+++ b/block/blk-mq-pci.c
@@ -44,3 +44,21 @@ void blk_mq_pci_map_queues(struct blk_mq_queue_map *qmap, struct pci_dev *pdev,
 	blk_mq_clear_mq_map(qmap);
 }
 EXPORT_SYMBOL_GPL(blk_mq_pci_map_queues);
+
+/**
+ * blk_mq_pci_get_queue_affinity - get affinity mask queue mapping for PCI device
+ * @dev_data:	Pointer to struct pci_dev.
+ * @offset:	Offset to use for the pci irq vector
+ * @queue:	Queue index
+ *
+ * This function returns for a queue the affinity mask for a PCI device.
+ * It is usually used as callback for blk_mq_dev_map_queues().
+ */
+const struct cpumask *blk_mq_pci_get_queue_affinity(void *dev_data, int offset,
+						    int queue)
+{
+	struct pci_dev *pdev = dev_data;
+
+	return pci_irq_get_affinity(pdev, offset + queue);
+}
+EXPORT_SYMBOL_GPL(blk_mq_pci_get_queue_affinity);
diff --git a/block/blk-mq-virtio.c b/block/blk-mq-virtio.c
index 68d0945c0b08..d3d33f8d69ce 100644
--- a/block/blk-mq-virtio.c
+++ b/block/blk-mq-virtio.c
@@ -44,3 +44,22 @@ void blk_mq_virtio_map_queues(struct blk_mq_queue_map *qmap,
 	blk_mq_map_queues(qmap);
 }
 EXPORT_SYMBOL_GPL(blk_mq_virtio_map_queues);
+
+/**
+ * blk_mq_virtio_get_queue_affinity - get affinity mask queue mapping for virtio device
+ * @dev_data:	Pointer to struct virtio_device.
+ * @offset:	Offset to use for the virtio irq vector
+ * @queue:	Queue index
+ *
+ * This function returns for a queue the affinity mask for a virtio device.
+ * It is usually used as callback for blk_mq_dev_map_queues().
+ */
+const struct cpumask *blk_mq_virtio_get_queue_affinity(void *dev_data,
+						       int offset,
+						       int queue)
+{
+	struct virtio_device *vdev = dev_data;
+
+	return virtio_get_vq_affinity(vdev, offset + queue);
+}
+EXPORT_SYMBOL_GPL(blk_mq_virtio_get_queue_affinity);
diff --git a/include/linux/blk-mq-pci.h b/include/linux/blk-mq-pci.h
index ca544e1d3508..2e701f6f6341 100644
--- a/include/linux/blk-mq-pci.h
+++ b/include/linux/blk-mq-pci.h
@@ -7,5 +7,7 @@ struct pci_dev;
 
 void blk_mq_pci_map_queues(struct blk_mq_queue_map *qmap, struct pci_dev *pdev,
 			   int offset);
+const struct cpumask *blk_mq_pci_get_queue_affinity(void *dev_data, int offset,
+						    int queue);
 
 #endif /* _LINUX_BLK_MQ_PCI_H */
diff --git a/include/linux/blk-mq-virtio.h b/include/linux/blk-mq-virtio.h
index 13226e9b22dd..9d3273ba4abf 100644
--- a/include/linux/blk-mq-virtio.h
+++ b/include/linux/blk-mq-virtio.h
@@ -7,5 +7,8 @@ struct virtio_device;
 
 void blk_mq_virtio_map_queues(struct blk_mq_queue_map *qmap,
 		struct virtio_device *vdev, int first_vec);
+const struct cpumask *blk_mq_virtio_get_queue_affinity(void *dev_data,
+						       int offset,
+						       int queue);
 
 #endif /* _LINUX_BLK_MQ_VIRTIO_H */
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 8d304b1d16b1..cfc96d6a3136 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -929,7 +929,12 @@ void blk_mq_freeze_queue_wait(struct request_queue *q);
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 				     unsigned long timeout);
 
+typedef const struct cpumask *(get_queue_affinty_fn)(void *dev_data,
+					      int dev_off, int queue_idx);
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap);
+void blk_mq_dev_map_queues(struct blk_mq_queue_map *qmap,
+			   void *dev_data, int dev_off,
+			   get_queue_affinty_fn *get_queue_affinity);
 void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues);
 
 void blk_mq_quiesce_queue_nowait(struct request_queue *q);

-- 
2.46.0

