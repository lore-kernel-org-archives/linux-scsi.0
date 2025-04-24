Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9D82949F1;
	Thu, 24 Apr 2025 18:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745518810; cv=none; b=dUx6sxIc6bDlx7H9qVre0EkIxXaycCwCMTThAh/9Em+aYFWC9pHKPvjEvHxsuFh4LPb6XRIFjxvvh801ZqIFlPdyoTrIbkbTCav8XuHfHuOBJGjL/NDEfN2r8MGnoNFtVIdQnmVfSDRgRbpfnZ+LiPsY5CVbFMeEs5hhSkWFmYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745518810; c=relaxed/simple;
	bh=ZzXctOeUvdzZq7E43MFmzj1XIDOOZfBrFh235iH0XOE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gKEM3kPDvaYLUpnU4Mmc/iB8JBze0oXpKRO8BS7IHnISUaKELOHtwrwExOBAYR4AdytZFCW/v4v7uwWjzY2dpTRe6Ma6B836jDRe3aZQj2nnwyUe3Mh9iFytWbhyRTdo7Y6nwlRqDk0+hHZ1TcwNgkH3xVPSjzbR7A7DXOiXc3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P3yHszTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P3yHszTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FC0C4AF0B;
	Thu, 24 Apr 2025 18:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745518809;
	bh=ZzXctOeUvdzZq7E43MFmzj1XIDOOZfBrFh235iH0XOE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=P3yHszTIDoFLhLy3ZcAgleg8u8tq9hRoxYf6mN/qZfyjKT80K5YBhxRY4YWIpbLv4
	 r5xCswJlpgyG13Ij4q8+suYqHAqUz9sffsVS3zhABMsdCSA5tsi1DdViS9bZwj27Y+
	 vs1E0iCBQz/JxNf0O+JqYIDHpvS3jJcKBCBSRNcoDuqQOlbbZjC8eNb3+mUkMfC9v3
	 PxBlmjblcB66XahWpNtmlPfRcJfJyfprb9aObxPQSkSX6NUZPDEZwRRmg58k4z8ZGk
	 VUCmc94aYwc5CkKWt2TYIWhcNN6erq/G7iunk0FuSFtqdMWvoNKF30pYy51lEd7U7Y
	 79mQ7Eg/gBTcQ==
From: Daniel Wagner <wagi@kernel.org>
Date: Thu, 24 Apr 2025 20:19:47 +0200
Subject: [PATCH v6 8/9] blk-mq: use hk cpus only when isolcpus=io_queue is
 enabled
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250424-isolcpus-io-queues-v6-8-9a53a870ca1f@kernel.org>
References: <20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org>
In-Reply-To: <20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
 Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, storagedev@microchip.com, 
 virtualization@lists.linux.dev, GR-QLogic-Storage-Upstream@marvell.com, 
 Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

When isolcpus=io_queue is enabled all hardware queues should run on
the housekeeping CPUs only. Thus ignore the affinity mask provided by
the driver. Also we can't use blk_mq_map_queues because it will map all
CPUs to first hctx unless, the CPU is the same as the hctx has the
affinity set to, e.g. 8 CPUs with isolcpus=io_queue,2-3,6-7 config

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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 block/blk-mq-cpumap.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 6e6b3e989a5676186b5a31296a1b94b7602f1542..2d678d1db2b5196fc2b2ce5678fdb0cb6bad26e0 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -22,8 +22,8 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
 {
 	unsigned int num;
 
-	if (housekeeping_enabled(HK_TYPE_MANAGED_IRQ))
-		mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ);
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
+		mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
 
 	num = cpumask_weight(mask);
 	return min_not_zero(num, max_queues);
@@ -61,11 +61,73 @@ unsigned int blk_mq_num_online_queues(unsigned int max_queues)
 }
 EXPORT_SYMBOL_GPL(blk_mq_num_online_queues);
 
+/*
+ * blk_mq_map_hk_queues - Create housekeeping CPU to hardware queue mapping
+ * @qmap:	CPU to hardware queue map
+ *
+ * Create a housekeeping CPU to hardware queue mapping in @qmap. If the
+ * isolcpus feature is enabled and blk_mq_map_hk_queues returns true,
+ * @qmap contains a valid configuration honoring the io_queue
+ * configuration. If the isolcpus feature is disabled this function
+ * returns false.
+ */
+static bool blk_mq_map_hk_queues(struct blk_mq_queue_map *qmap)
+{
+	struct cpumask *hk_masks;
+	cpumask_var_t isol_mask;
+	unsigned int queue, cpu, nr_masks;
+
+	if (!housekeeping_enabled(HK_TYPE_IO_QUEUE))
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
+		       housekeeping_cpumask(HK_TYPE_IO_QUEUE));
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
2.49.0

