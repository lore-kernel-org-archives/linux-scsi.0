Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC5D3161CD;
	Fri,  5 Sep 2025 15:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757084420; cv=none; b=CHCJfeuZ4lY84n6oVNdAcZamn6gtm8ovQ7nSiwUZcge8kau1pCTZhmZx6VD8lBK5DlZQ5na3LcwKFZiQpQBNJRfgVd5natd3O88O2DSgyKahU9i1+KIgWwTYx++MGQCGtoAfPMrdxSQ2v4+DTLhiWXyQhWMZTkwIYY6njFvKni0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757084420; c=relaxed/simple;
	bh=rvLWWXeySKq98f4YapB2llgtV2IrFrE+xX8SsngAsrE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bh1jbWsAh9U59tscyrCapC/DdWgAoxAgzLEk9315ORxJJ3mHkPcfpWmRnxmBJ4Gcth04YJ9wtq/4+0C2VPj/igHtuSuWOMR3MdfoqWE+Th4AZfN+oA/78cQj6yujFP+SUC8VB6brqbP45St/oLp06RfJMwPOBc2u7p/9ivEvOZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=njaPiZL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="njaPiZL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76C4C4CEF4;
	Fri,  5 Sep 2025 15:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757084420;
	bh=rvLWWXeySKq98f4YapB2llgtV2IrFrE+xX8SsngAsrE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=njaPiZL99Y+E9U+rTMiZREdaxGxNouXidrceHo+17qzppVRg7Iz3YMMQsM7nT5cyT
	 MnvWoBdiPQfSHmQ8LgP90EOWLv5PRkKLfKOMxxI9o8/WAXdGEGE1EgHCHRLK30eTHm
	 F5Q1teZvodNehg8FuT2ryyL6TrKZOAiuriejebBCrg0FMvo26Ij2xHimeD0r7kiaEG
	 Bf3rU0X++pUWBBmK5M75ui2gwO0qBhDJLagqdducY5zUIGvL21h86cUhkATaErx/eu
	 Zr3IOCB0I5tNYtSHMMyia/LEEF7tFa8QuWIuLu62qu0lCeU6q5OysQG5foSdvbZLFT
	 UG7+MyKgmdNwg==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 05 Sep 2025 16:59:56 +0200
Subject: [PATCH v8 10/12] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250905-isolcpus-io-queues-v8-10-885984c5daca@kernel.org>
References: <20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org>
In-Reply-To: <20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 "Michael S. Tsirkin" <mst@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
 Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Aaron Tomlin <atomlin@atomlin.com>, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 storagedev@microchip.com, virtualization@lists.linux.dev, 
 GR-QLogic-Storage-Upstream@marvell.com, Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

Extend the capabilities of the generic CPU to hardware queue (hctx)
mapping code, so it maps houskeeping CPUs and isolated CPUs to the
hardware queues evenly.

A hctx is only operational when there is at least one online
housekeeping CPU assigned (aka active_hctx). Thus, check the final
mapping that there is no hctx which has only offline housekeeing CPU and
online isolated CPUs.

Example mapping result:

  16 online CPUs

  isolcpus=io_queue,2-3,6-7,12-13

Queue mapping:
        hctx0: default 0 2
        hctx1: default 1 3
        hctx2: default 4 6
        hctx3: default 5 7
        hctx4: default 8 12
        hctx5: default 9 13
        hctx6: default 10
        hctx7: default 11
        hctx8: default 14
        hctx9: default 15

IRQ mapping:
        irq 42 affinity 0 effective 0  nvme0q0
        irq 43 affinity 0 effective 0  nvme0q1
        irq 44 affinity 1 effective 1  nvme0q2
        irq 45 affinity 4 effective 4  nvme0q3
        irq 46 affinity 5 effective 5  nvme0q4
        irq 47 affinity 8 effective 8  nvme0q5
        irq 48 affinity 9 effective 9  nvme0q6
        irq 49 affinity 10 effective 10  nvme0q7
        irq 50 affinity 11 effective 11  nvme0q8
        irq 51 affinity 14 effective 14  nvme0q9
        irq 52 affinity 15 effective 15  nvme0q10

A corner case is when the number of online CPUs and present CPUs
differ and the driver asks for less queues than online CPUs, e.g.

  8 online CPUs, 16 possible CPUs

  isolcpus=io_queue,2-3,6-7,12-13
  virtio_blk.num_request_queues=2

Queue mapping:
        hctx0: default 0 1 2 3 4 5 6 7 8 12 13
        hctx1: default 9 10 11 14 15

IRQ mapping
        irq 27 affinity 0 effective 0 virtio0-config
        irq 28 affinity 0-1,4-5,8 effective 5 virtio0-req.0
        irq 29 affinity 9-11,14-15 effective 0 virtio0-req.1

Noteworthy is that for the normal/default configuration (!isoclpus) the
mapping will change for systems which have non hyperthreading CPUs. The
main assignment loop will completely rely that group_mask_cpus_evenly to
do the right thing. The old code would distribute the CPUs linearly over
the hardware context:

queue mapping for /dev/nvme0n1
        hctx0: default 0 8
        hctx1: default 1 9
        hctx2: default 2 10
        hctx3: default 3 11
        hctx4: default 4 12
        hctx5: default 5 13
        hctx6: default 6 14
        hctx7: default 7 15

The assign each hardware context the map generated by the
group_mask_cpus_evenly function:

queue mapping for /dev/nvme0n1
        hctx0: default 0 1
        hctx1: default 2 3
        hctx2: default 4 5
        hctx3: default 6 7
        hctx4: default 8 9
        hctx5: default 10 11
        hctx6: default 12 13
        hctx7: default 14 15

In case of hyperthreading CPUs, the resulting map stays the same.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 block/blk-mq-cpumap.c | 177 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 158 insertions(+), 19 deletions(-)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 8244ecf878358c0b8de84458dcd5100c2f360213..1e66882e4d5bd9f78d132f3a229a1577853f7a9f 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -17,12 +17,25 @@
 #include "blk.h"
 #include "blk-mq.h"
 
+static struct cpumask blk_hk_online_mask;
+
 static unsigned int blk_mq_num_queues(const struct cpumask *mask,
 				      unsigned int max_queues)
 {
 	unsigned int num;
 
-	num = cpumask_weight(mask);
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
+		const struct cpumask *hk_mask;
+		struct cpumask avail_mask;
+
+		hk_mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+		cpumask_and(&avail_mask, mask, hk_mask);
+
+		num = cpumask_weight(&avail_mask);
+	} else {
+		num = cpumask_weight(mask);
+	}
+
 	return min_not_zero(num, max_queues);
 }
 
@@ -31,9 +44,13 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
  *
  * Returns an affinity mask that represents the queue-to-CPU mapping
  * requested by the block layer based on possible CPUs.
+ * This helper takes isolcpus settings into account.
  */
 const struct cpumask *blk_mq_possible_queue_affinity(void)
 {
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
+		return housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+
 	return cpu_possible_mask;
 }
 EXPORT_SYMBOL_GPL(blk_mq_possible_queue_affinity);
@@ -46,6 +63,12 @@ EXPORT_SYMBOL_GPL(blk_mq_possible_queue_affinity);
  */
 const struct cpumask *blk_mq_online_queue_affinity(void)
 {
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
+		cpumask_and(&blk_hk_online_mask, cpu_online_mask,
+			    housekeeping_cpumask(HK_TYPE_IO_QUEUE));
+		return &blk_hk_online_mask;
+	}
+
 	return cpu_online_mask;
 }
 EXPORT_SYMBOL_GPL(blk_mq_online_queue_affinity);
@@ -57,7 +80,8 @@ EXPORT_SYMBOL_GPL(blk_mq_online_queue_affinity);
  *		ignored.
  *
  * Calculates the number of queues to be used for a multiqueue
- * device based on the number of possible CPUs.
+ * device based on the number of possible CPUs. This helper
+ * takes isolcpus settings into account.
  */
 unsigned int blk_mq_num_possible_queues(unsigned int max_queues)
 {
@@ -72,7 +96,8 @@ EXPORT_SYMBOL_GPL(blk_mq_num_possible_queues);
  *		ignored.
  *
  * Calculates the number of queues to be used for a multiqueue
- * device based on the number of online CPUs.
+ * device based on the number of online CPUs. This helper
+ * takes isolcpus settings into account.
  */
 unsigned int blk_mq_num_online_queues(unsigned int max_queues)
 {
@@ -80,23 +105,104 @@ unsigned int blk_mq_num_online_queues(unsigned int max_queues)
 }
 EXPORT_SYMBOL_GPL(blk_mq_num_online_queues);
 
+static bool blk_mq_validate(struct blk_mq_queue_map *qmap,
+			    const struct cpumask *active_hctx)
+{
+	/*
+	 * Verify if the mapping is usable when housekeeping
+	 * configuration is enabled
+	 */
+
+	for (int queue = 0; queue < qmap->nr_queues; queue++) {
+		int cpu;
+
+		if (cpumask_test_cpu(queue, active_hctx)) {
+			/*
+			 * This htcx has at least one online CPU thus it
+			 * is able to serve any assigned isolated CPU.
+			 */
+			continue;
+		}
+
+		/*
+		 * There is no housekeeping online CPU for this hctx, all
+		 * good as long as all non houskeeping CPUs are also
+		 * offline.
+		 */
+		for_each_online_cpu(cpu) {
+			if (qmap->mq_map[cpu] != queue)
+				continue;
+
+			pr_warn("Unable to create a usable CPU-to-queue mapping with the given constraints\n");
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static void blk_mq_map_fallback(struct blk_mq_queue_map *qmap)
+{
+	unsigned int cpu;
+
+	/*
+	 * Map all CPUs to the first hctx to ensure at least one online
+	 * CPU is serving it.
+	 */
+	for_each_possible_cpu(cpu)
+		qmap->mq_map[cpu] = 0;
+}
+
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
 {
-	const struct cpumask *masks;
+	struct cpumask *masks __free(kfree) = NULL;
+	const struct cpumask *constraint;
 	unsigned int queue, cpu, nr_masks;
+	cpumask_var_t active_hctx;
 
-	masks = group_cpus_evenly(qmap->nr_queues, &nr_masks);
-	if (!masks) {
-		for_each_possible_cpu(cpu)
-			qmap->mq_map[cpu] = qmap->queue_offset;
-		return;
-	}
+	if (!zalloc_cpumask_var(&active_hctx, GFP_KERNEL))
+		goto fallback;
+
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
+		constraint = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+	else
+		constraint = cpu_possible_mask;
+
+	/* Map CPUs to the hardware contexts (hctx) */
+	masks = group_mask_cpus_evenly(qmap->nr_queues, constraint, &nr_masks);
+	if (!masks)
+		goto free_fallback;
 
 	for (queue = 0; queue < qmap->nr_queues; queue++) {
-		for_each_cpu(cpu, &masks[queue % nr_masks])
-			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+		unsigned int idx = (qmap->queue_offset + queue) % nr_masks;
+
+		for_each_cpu(cpu, &masks[idx]) {
+			qmap->mq_map[cpu] = idx;
+
+			if (cpu_online(cpu))
+				cpumask_set_cpu(qmap->mq_map[cpu], active_hctx);
+		}
 	}
-	kfree(masks);
+
+	/* Map any unassigned CPU evenly to the hardware contexts (hctx) */
+	queue = cpumask_first(active_hctx);
+	for_each_cpu_andnot(cpu, cpu_possible_mask, constraint) {
+		qmap->mq_map[cpu] = (qmap->queue_offset + queue) % nr_masks;
+		queue = cpumask_next_wrap(queue, active_hctx);
+	}
+
+	if (!blk_mq_validate(qmap, active_hctx))
+		goto free_fallback;
+
+	free_cpumask_var(active_hctx);
+
+	return;
+
+free_fallback:
+	free_cpumask_var(active_hctx);
+
+fallback:
+	blk_mq_map_fallback(qmap);
 }
 EXPORT_SYMBOL_GPL(blk_mq_map_queues);
 
@@ -133,24 +239,57 @@ void blk_mq_map_hw_queues(struct blk_mq_queue_map *qmap,
 			  struct device *dev, unsigned int offset)
 
 {
-	const struct cpumask *mask;
+	cpumask_var_t active_hctx, mask;
 	unsigned int queue, cpu;
 
 	if (!dev->bus->irq_get_affinity)
 		goto fallback;
 
+	if (!zalloc_cpumask_var(&active_hctx, GFP_KERNEL))
+		goto fallback;
+
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
+		free_cpumask_var(active_hctx);
+		goto fallback;
+	}
+
+	/* Map CPUs to the hardware contexts (hctx) */
 	for (queue = 0; queue < qmap->nr_queues; queue++) {
-		mask = dev->bus->irq_get_affinity(dev, queue + offset);
-		if (!mask)
-			goto fallback;
+		const struct cpumask *affinity_mask;
+
+		affinity_mask = dev->bus->irq_get_affinity(dev, offset + queue);
+		if (!affinity_mask)
+			goto free_fallback;
 
-		for_each_cpu(cpu, mask)
+		for_each_cpu(cpu, affinity_mask) {
 			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+
+			cpumask_set_cpu(cpu, mask);
+			if (cpu_online(cpu))
+				cpumask_set_cpu(qmap->mq_map[cpu], active_hctx);
+		}
+	}
+
+	/* Map any unassigned CPU evenly to the hardware contexts (hctx) */
+	queue = cpumask_first(active_hctx);
+	for_each_cpu_andnot(cpu, cpu_possible_mask, mask) {
+		qmap->mq_map[cpu] = qmap->queue_offset + queue;
+		queue = cpumask_next_wrap(queue, active_hctx);
 	}
 
+	if (!blk_mq_validate(qmap, active_hctx))
+		goto free_fallback;
+
+	free_cpumask_var(active_hctx);
+	free_cpumask_var(mask);
+
 	return;
 
+free_fallback:
+	free_cpumask_var(active_hctx);
+	free_cpumask_var(mask);
+
 fallback:
-	blk_mq_map_queues(qmap);
+	blk_mq_map_fallback(qmap);
 }
 EXPORT_SYMBOL_GPL(blk_mq_map_hw_queues);

-- 
2.51.0

