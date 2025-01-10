Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32132147F5;
	Fri, 10 Jan 2025 16:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526423; cv=none; b=dnJv7bNCjxXOcMCWSQcnXQKK5Hd/UulrGl/lctW0AZsdXEYR0pISZxJEPGR0Qe2julmdDFhc7BFrCUt2ozfdve0rTBBdhyWZqdTPsk4rPY29rOvah/GHzUllRLwIXNeO1BMZN9C9labzOqDOFbJ4ZK82PAHIPgxnWdfXH+tOPLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526423; c=relaxed/simple;
	bh=5//HpnRrVhYs9UNL8zeF3rbaQciAX5RlpgaaiZHbgaI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SRnJrLdVQzMXjp6q6WXcbzjrOfux60+Gke+kLiELmTUMe2o4HDGFNkmbJERiTleScMcCHW6iJrbx1xgtoM6q/AUmMm7on0UCVFQKEDuRS0oWxAHDp0ePLRqIUraaaasyuH4iFjkUnXySRGSWquD0bgKeTpa4hUdOIjHS3/HstOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q6z3CTM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q6z3CTM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9D6C4CEE4;
	Fri, 10 Jan 2025 16:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736526423;
	bh=5//HpnRrVhYs9UNL8zeF3rbaQciAX5RlpgaaiZHbgaI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=q6z3CTM5LqYkAhnKyEgfu+nKe61Q+TUtw20L/MQGqybRIjNJX7ZZcP03cLORhgjxT
	 lIyHkdVGy/TU6WbCHVLsGpHswnsX0VtBKs/bnxMsCPlLxFVOsZsMibMUWlA7pWQVr1
	 xSj3/OEjYE2jmf+Dw7S4prkQZb+rthlXQlNtqtidzqznBaRr4582JQpxTovT3PMWG/
	 Rxa1OOZhRgUNI8AlTiPQt0zwi73Mo4N19V78W26HqkFe0wjn1eQKcX7yKLZqcqmlK+
	 eMc1FWD3EPE+RsEBiNth3A3hxrb8hBNJLWfqaxnfW0VJv4fJT1HhpIq/9RZH66UR/e
	 OKfsItufCQb5w==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 10 Jan 2025 17:26:45 +0100
Subject: [PATCH v5 7/9] blk-mq: use hk cpus only when isolcpus=managed_irq
 is enabled
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250110-isolcpus-io-queues-v5-7-0e4f118680b0@kernel.org>
References: <20250110-isolcpus-io-queues-v5-0-0e4f118680b0@kernel.org>
In-Reply-To: <20250110-isolcpus-io-queues-v5-0-0e4f118680b0@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
 Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, storagedev@microchip.com, 
 virtualization@lists.linux.dev, GR-QLogic-Storage-Upstream@marvell.com, 
 Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

When isolcpus=managed_irq is enabled all hardware queues should run on
the housekeeping CPUs only. Thus ignore the affinity mask provided by
the driver. Also we can't use blk_mq_map_queues because it will map all
CPUs to first hctx unless, the CPU is the same as the hctx has the
affinity set to, e.g. 8 CPUs with isolcpus=managed_irq,2-3,6-7 config

  queue mapping for /dev/nvme0n1
        hctx0: default 2 3 4 6 7
        hctx1: default 5
        hctx2: default 0
        hctx3: default 1

  PCI name is 00:05.0: nvme0n1
        irq 57 affinity 0-1 effective 1 is_managed:0 nvme0q0
        irq 58 affinity 4 effective 4 is_managed:1 nvme0q1
        irq 59 affinity 5 effective 5 is_managed:1 nvme0q2
        irq 60 affinity 0 effective 0 is_managed:1 nvme0q3
        irq 61 affinity 1 effective 1 is_managed:1 nvme0q4

where as with blk_mq_hk_map_queues we get

  queue mapping for /dev/nvme0n1
        hctx0: default 2 4
        hctx1: default 3 5
        hctx2: default 0 6
        hctx3: default 1 7

  PCI name is 00:05.0: nvme0n1
        irq 56 affinity 0-1 effective 1 is_managed:0 nvme0q0
        irq 61 affinity 4 effective 4 is_managed:1 nvme0q1
        irq 62 affinity 5 effective 5 is_managed:1 nvme0q2
        irq 63 affinity 0 effective 0 is_managed:1 nvme0q3
        irq 64 affinity 1 effective 1 is_managed:1 nvme0q4

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 block/blk-mq-cpumap.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 0923cccdcbcad75ad107c3636af15b723356e087..e78eebbbaf0a2e0e8e03a2b31087c62a9090808c 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -61,11 +61,73 @@ unsigned int blk_mq_num_online_queues(unsigned int max_queues)
 }
 EXPORT_SYMBOL_GPL(blk_mq_num_online_queues);
 
+/*
+ * blk_mq_map_hk_queues - Create housekeeping CPU to hardware queue mapping
+ * @qmap:	CPU to hardware queue map
+ *
+ * Create a housekeeping CPU to hardware queue mapping in @qmap. If the
+ * isolcpus feature is enabled and blk_mq_map_hk_queues returns true,
+ * @qmap contains a valid configuration honoring the managed_irq
+ * configuration. If the isolcpus feature is disabled this function
+ * returns false.
+ */
+static bool blk_mq_map_hk_queues(struct blk_mq_queue_map *qmap)
+{
+	struct cpumask *hk_masks;
+	cpumask_var_t isol_mask;
+	unsigned int queue, cpu, nr_masks;
+
+	if (!housekeeping_enabled(HK_TYPE_MANAGED_IRQ))
+		return false;
+
+	/* map housekeeping cpus to matching hardware context */
+	hk_masks = group_cpus_evenly(qmap->nr_queues, &nr_masks);
+	if (!hk_masks)
+		goto fallback;
+
+	for (queue = 0; queue < qmap->nr_queues; queue++) {
+		for_each_cpu(cpu, &hk_masks[queue % nr_masks])
+			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+	}
+
+	kfree(hk_masks);
+
+	/* map isolcpus to hardware context */
+	if (!alloc_cpumask_var(&isol_mask, GFP_KERNEL))
+		goto fallback;
+
+	queue = 0;
+	cpumask_andnot(isol_mask,
+		       cpu_possible_mask,
+		       housekeeping_cpumask(HK_TYPE_MANAGED_IRQ));
+
+	for_each_cpu(cpu, isol_mask) {
+		qmap->mq_map[cpu] = qmap->queue_offset + queue;
+		queue = (queue + 1) % qmap->nr_queues;
+	}
+
+	free_cpumask_var(isol_mask);
+
+	return true;
+
+fallback:
+	/* map all cpus to hardware context ignoring any affinity */
+	queue = 0;
+	for_each_possible_cpu(cpu) {
+		qmap->mq_map[cpu] = qmap->queue_offset + queue;
+		queue = (queue + 1) % qmap->nr_queues;
+	}
+	return true;
+}
+
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
 {
 	const struct cpumask *masks;
 	unsigned int queue, cpu, nr_masks;
 
+	if (blk_mq_map_hk_queues(qmap))
+		return;
+
 	masks = group_cpus_evenly(qmap->nr_queues, &nr_masks);
 	if (!masks) {
 		for_each_possible_cpu(cpu)
@@ -120,6 +182,9 @@ void blk_mq_map_hw_queues(struct blk_mq_queue_map *qmap,
 	if (!dev->bus->irq_get_affinity)
 		goto fallback;
 
+	if (blk_mq_map_hk_queues(qmap))
+		return;
+
 	for (queue = 0; queue < qmap->nr_queues; queue++) {
 		mask = dev->bus->irq_get_affinity(dev, queue + offset);
 		if (!mask)

-- 
2.47.1

