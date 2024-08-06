Received: from mail.nearlyone.de (mail.nearlyone.de [49.12.199.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A201C7B8A;
	Tue,  6 Aug 2024 12:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.199.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722946050; cv=none; b=LW2BYu3CRS+GcsYnYayTNHVR0BvdKHimVqvg5t21ipX1QxSCT4MfA/kVBCqzMiv2PN+XHBU+yk2XvPbhK1RUit/FgZKLbd1nTOJ2Bpx4NjAZh2kTPzkB1z+eWYx6LQaGNTUioCYyv99kW4tbXG/eesBHWoCyILpue5LU04UErNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722946050; c=relaxed/simple;
	bh=FiqnG+1OEQK9cci7cm31XJTlC91DbLNdsEa57Sllh0w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aaXJFjDyp0FTs9Qb1SbDc56646+a5CGId2ZLROOgXcZYiBam8XF9RDF6hivuToI75u2JZ5T/FmJw6aV7GOJdBs9Lct6XX1Jr5uehzGdYR50vMOTjm0ImLhxPpdlrk132Al4w3bcr1YeJJJXEL8ld0z86w779Ds2jdTM31dSBbYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=monom.org; dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b=dfNLMrOp; arc=none smtp.client-ip=49.12.199.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monom.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b="dfNLMrOp"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2DEC1DAE1C;
	Tue,  6 Aug 2024 14:07:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
	t=1722946046; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=uV7dh0N2larDX2g3QWTw2MMv1JZzOaYRQlPxw6dMC7A=;
	b=dfNLMrOpaD7bQ/KOm/zpAyiQ1W6K+FcWIAAib4dxAZxDcdl2ii+Sq9YGQfyUgAJveDpWmE
	xF4sHB7q1KwcLbUHD+x3YarFfjk3GXf+J6N27uHErZsPQjqQo37bp5tlW9LzncggL0za8e
	EjdZvNhp2l5lK9IQxulglmL89DvqPZbXnbViySyKbLoU9GA+8ic+st+9NZmE2BaZ1V12gd
	jIEdVhwBWOAHGr8bod/aJ0Gnay/ju3QDD5wluIkuEVKP7kfQP/zhHDxVxBdXOvibT5PIco
	Ee3DFTu94LZzYYHyTzfeJ57GBnBZLKqS2SvhOvcYhkikDaJ3OEjIZ6XU+sk8Kg==
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 06 Aug 2024 14:06:39 +0200
Subject: [PATCH v3 07/15] blk-mq: remove unused queue mapping helpers
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240806-isolcpus-io-queues-v3-7-da0eecfeaf8b@suse.de>
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

There are no users left of the pci and virtio queue mapping helpers.
Thus remove them.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 block/blk-mq-pci.c            | 39 ---------------------------------------
 block/blk-mq-virtio.c         | 41 +----------------------------------------
 include/linux/blk-mq-pci.h    |  5 -----
 include/linux/blk-mq-virtio.h |  5 -----
 4 files changed, 1 insertion(+), 89 deletions(-)

diff --git a/block/blk-mq-pci.c b/block/blk-mq-pci.c
index 71a73238aeb2..b69dd52d8719 100644
--- a/block/blk-mq-pci.c
+++ b/block/blk-mq-pci.c
@@ -2,49 +2,10 @@
 /*
  * Copyright (c) 2016 Christoph Hellwig.
  */
-#include <linux/kobject.h>
-#include <linux/blkdev.h>
 #include <linux/blk-mq-pci.h>
 #include <linux/pci.h>
 #include <linux/module.h>
 
-#include "blk-mq.h"
-
-/**
- * blk_mq_pci_map_queues - provide a default queue mapping for PCI device
- * @qmap:	CPU to hardware queue map.
- * @pdev:	PCI device associated with @set.
- * @offset:	Offset to use for the pci irq vector
- *
- * This function assumes the PCI device @pdev has at least as many available
- * interrupt vectors as @set has queues.  It will then query the vector
- * corresponding to each queue for it's affinity mask and built queue mapping
- * that maps a queue to the CPUs that have irq affinity for the corresponding
- * vector.
- */
-void blk_mq_pci_map_queues(struct blk_mq_queue_map *qmap, struct pci_dev *pdev,
-			   int offset)
-{
-	const struct cpumask *mask;
-	unsigned int queue, cpu;
-
-	for (queue = 0; queue < qmap->nr_queues; queue++) {
-		mask = pci_irq_get_affinity(pdev, queue + offset);
-		if (!mask)
-			goto fallback;
-
-		for_each_cpu(cpu, mask)
-			qmap->mq_map[cpu] = qmap->queue_offset + queue;
-	}
-
-	return;
-
-fallback:
-	WARN_ON_ONCE(qmap->nr_queues > 1);
-	blk_mq_clear_mq_map(qmap);
-}
-EXPORT_SYMBOL_GPL(blk_mq_pci_map_queues);
-
 /**
  * blk_mq_pci_get_queue_affinity - get affinity mask queue mapping for PCI device
  * @dev_data:	Pointer to struct pci_dev.
diff --git a/block/blk-mq-virtio.c b/block/blk-mq-virtio.c
index d3d33f8d69ce..0fd9f17a2f44 100644
--- a/block/blk-mq-virtio.c
+++ b/block/blk-mq-virtio.c
@@ -2,48 +2,9 @@
 /*
  * Copyright (c) 2016 Christoph Hellwig.
  */
-#include <linux/device.h>
 #include <linux/blk-mq-virtio.h>
-#include <linux/virtio_config.h>
+#include <linux/virtio.h>
 #include <linux/module.h>
-#include "blk-mq.h"
-
-/**
- * blk_mq_virtio_map_queues - provide a default queue mapping for virtio device
- * @qmap:	CPU to hardware queue map.
- * @vdev:	virtio device to provide a mapping for.
- * @first_vec:	first interrupt vectors to use for queues (usually 0)
- *
- * This function assumes the virtio device @vdev has at least as many available
- * interrupt vectors as @set has queues.  It will then query the vector
- * corresponding to each queue for it's affinity mask and built queue mapping
- * that maps a queue to the CPUs that have irq affinity for the corresponding
- * vector.
- */
-void blk_mq_virtio_map_queues(struct blk_mq_queue_map *qmap,
-		struct virtio_device *vdev, int first_vec)
-{
-	const struct cpumask *mask;
-	unsigned int queue, cpu;
-
-	if (!vdev->config->get_vq_affinity)
-		goto fallback;
-
-	for (queue = 0; queue < qmap->nr_queues; queue++) {
-		mask = vdev->config->get_vq_affinity(vdev, first_vec + queue);
-		if (!mask)
-			goto fallback;
-
-		for_each_cpu(cpu, mask)
-			qmap->mq_map[cpu] = qmap->queue_offset + queue;
-	}
-
-	return;
-
-fallback:
-	blk_mq_map_queues(qmap);
-}
-EXPORT_SYMBOL_GPL(blk_mq_virtio_map_queues);
 
 /**
  * blk_mq_virtio_get_queue_affinity - get affinity mask queue mapping for virtio device
diff --git a/include/linux/blk-mq-pci.h b/include/linux/blk-mq-pci.h
index 2e701f6f6341..e6de88da8eea 100644
--- a/include/linux/blk-mq-pci.h
+++ b/include/linux/blk-mq-pci.h
@@ -2,11 +2,6 @@
 #ifndef _LINUX_BLK_MQ_PCI_H
 #define _LINUX_BLK_MQ_PCI_H
 
-struct blk_mq_queue_map;
-struct pci_dev;
-
-void blk_mq_pci_map_queues(struct blk_mq_queue_map *qmap, struct pci_dev *pdev,
-			   int offset);
 const struct cpumask *blk_mq_pci_get_queue_affinity(void *dev_data, int offset,
 						    int queue);
 
diff --git a/include/linux/blk-mq-virtio.h b/include/linux/blk-mq-virtio.h
index 9d3273ba4abf..de01dfb36c43 100644
--- a/include/linux/blk-mq-virtio.h
+++ b/include/linux/blk-mq-virtio.h
@@ -2,11 +2,6 @@
 #ifndef _LINUX_BLK_MQ_VIRTIO_H
 #define _LINUX_BLK_MQ_VIRTIO_H
 
-struct blk_mq_queue_map;
-struct virtio_device;
-
-void blk_mq_virtio_map_queues(struct blk_mq_queue_map *qmap,
-		struct virtio_device *vdev, int first_vec);
 const struct cpumask *blk_mq_virtio_get_queue_affinity(void *dev_data,
 						       int offset,
 						       int queue);

-- 
2.46.0

