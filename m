Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60752E2658;
	Tue, 17 Jun 2025 13:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167812; cv=none; b=Em7DKxsTsYxIyVt4COZ6JBCItuEE7qQgzv18z9pzhbl7G6ggQL1cKrZ72/Wz07STs6HfrIj6/JWcDAp7xSHEvqtFGcPpchwc7w1T8feJFlnujTgpe0B1iB/zilFRQKfVyQy12a8ZgvEgW7kJcuE5+WU/AvslU9/+mLbGJ9xopRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167812; c=relaxed/simple;
	bh=y28xAfylXh2rdRLTqKxx7aDOa1vFkQYxy1i35oempSA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MoesUqbSVcnHqHaigrU1qZo9DfBcG3jMx4imCVxWvFZ2DPgCxPuHy3Nd0cpjr7eI0woLzIrjAJY0bpwuE/VRCsFDC/9/pfeu+VWTrx5TnKaLnGtIwDQyE8jqrC0OBItunifFNLUOST9NLDLsALOjWrp8f1nnWR+deqEsdwOmTuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pssgh3Al; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pssgh3Al"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE0DC4CEF1;
	Tue, 17 Jun 2025 13:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750167812;
	bh=y28xAfylXh2rdRLTqKxx7aDOa1vFkQYxy1i35oempSA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pssgh3Al5vy6j/4p9KScq/o/Ti3hh1aeNJWZm4FJ/snp05kXRmmrz4S1i6c16IstP
	 UrDa16/QS9nRYwLeHhWrEmCAbjxDbVTvxQ23QE3362vjm4LNPhpP1waumRGYKWwvkV
	 LaLPAQsjWy2lWBTvofNeUOlqbjQDAs7jBEmEs6golgP+ahVxEHQV8ZbdDF5+oEKBC1
	 zs79+xsqtgL69aenOLInKqyQL7UGhAPfZlp/iopBsGbMI5hx+yHB2jVqXsSpRCwq7m
	 RPNKULk4BKNw/6DANWA8GaRAlDVHfnaUqg68nQcNRUWdRfFtA8QdRRYUteKxAkn33U
	 IIzgBXfnYnlog==
From: Daniel Wagner <wagi@kernel.org>
Date: Tue, 17 Jun 2025 15:43:23 +0200
Subject: [PATCH 1/5] lib/group_cpus: Let group_cpu_evenly() return the
 number of initialized masks
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250617-isolcpus-queue-counters-v1-1-13923686b54b@kernel.org>
References: <20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org>
In-Reply-To: <20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, 
 "Michael S. Tsirkin" <mst@redhat.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
 Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 storagedev@microchip.com, virtualization@lists.linux.dev, 
 GR-QLogic-Storage-Upstream@marvell.com, Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

group_cpu_evenly() might have allocated less groups then requested:

group_cpu_evenly()
  __group_cpus_evenly()
    alloc_nodes_groups()
      # allocated total groups may be less than numgrps when
      # active total CPU number is less then numgrps

In this case, the caller will do an out of bound access because the
caller assumes the masks returned has numgrps.

Return the number of groups created so the caller can limit the access
range accordingly.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 block/blk-mq-cpumap.c        |  6 +++---
 drivers/virtio/virtio_vdpa.c |  9 +++++----
 fs/fuse/virtio_fs.c          |  6 +++---
 include/linux/group_cpus.h   |  2 +-
 kernel/irq/affinity.c        | 11 +++++------
 lib/group_cpus.c             | 16 ++++++++--------
 6 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 444798c5374f48088b661b519f2638bda8556cf2..269161252add756897fce1b65cae5b2e6aebd647 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -19,9 +19,9 @@
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
 {
 	const struct cpumask *masks;
-	unsigned int queue, cpu;
+	unsigned int queue, cpu, nr_masks;
 
-	masks = group_cpus_evenly(qmap->nr_queues);
+	masks = group_cpus_evenly(qmap->nr_queues, &nr_masks);
 	if (!masks) {
 		for_each_possible_cpu(cpu)
 			qmap->mq_map[cpu] = qmap->queue_offset;
@@ -29,7 +29,7 @@ void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
 	}
 
 	for (queue = 0; queue < qmap->nr_queues; queue++) {
-		for_each_cpu(cpu, &masks[queue])
+		for_each_cpu(cpu, &masks[queue % nr_masks])
 			qmap->mq_map[cpu] = qmap->queue_offset + queue;
 	}
 	kfree(masks);
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index 1f60c9d5cb1810a6f208c24bb2ac640d537391a0..a7b297dae4890c9d6002744b90fc133bbedb7b44 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -329,20 +329,21 @@ create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 
 	for (i = 0, usedvecs = 0; i < affd->nr_sets; i++) {
 		unsigned int this_vecs = affd->set_size[i];
+		unsigned int nr_masks;
 		int j;
-		struct cpumask *result = group_cpus_evenly(this_vecs);
+		struct cpumask *result = group_cpus_evenly(this_vecs, &nr_masks);
 
 		if (!result) {
 			kfree(masks);
 			return NULL;
 		}
 
-		for (j = 0; j < this_vecs; j++)
+		for (j = 0; j < nr_masks; j++)
 			cpumask_copy(&masks[curvec + j], &result[j]);
 		kfree(result);
 
-		curvec += this_vecs;
-		usedvecs += this_vecs;
+		curvec += nr_masks;
+		usedvecs += nr_masks;
 	}
 
 	/* Fill out vectors at the end that don't need affinity */
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 53c2626e90e723ad88f1aee69d7507b4f197ab13..3fbfb1a2942b753643015a45fa0c5d89ff72aa2f 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -862,7 +862,7 @@ static void virtio_fs_requests_done_work(struct work_struct *work)
 static void virtio_fs_map_queues(struct virtio_device *vdev, struct virtio_fs *fs)
 {
 	const struct cpumask *mask, *masks;
-	unsigned int q, cpu;
+	unsigned int q, cpu, nr_masks;
 
 	/* First attempt to map using existing transport layer affinities
 	 * e.g. PCIe MSI-X
@@ -882,7 +882,7 @@ static void virtio_fs_map_queues(struct virtio_device *vdev, struct virtio_fs *f
 	return;
 fallback:
 	/* Attempt to map evenly in groups over the CPUs */
-	masks = group_cpus_evenly(fs->num_request_queues);
+	masks = group_cpus_evenly(fs->num_request_queues, &nr_masks);
 	/* If even this fails we default to all CPUs use first request queue */
 	if (!masks) {
 		for_each_possible_cpu(cpu)
@@ -891,7 +891,7 @@ static void virtio_fs_map_queues(struct virtio_device *vdev, struct virtio_fs *f
 	}
 
 	for (q = 0; q < fs->num_request_queues; q++) {
-		for_each_cpu(cpu, &masks[q])
+		for_each_cpu(cpu, &masks[q % nr_masks])
 			fs->mq_map[cpu] = q + VQ_REQUEST;
 	}
 	kfree(masks);
diff --git a/include/linux/group_cpus.h b/include/linux/group_cpus.h
index e42807ec61f6e8cf3787af7daa0d8686edfef0a3..9d4e5ab6c314b31c09fda82c3f6ac18f77e9de36 100644
--- a/include/linux/group_cpus.h
+++ b/include/linux/group_cpus.h
@@ -9,6 +9,6 @@
 #include <linux/kernel.h>
 #include <linux/cpu.h>
 
-struct cpumask *group_cpus_evenly(unsigned int numgrps);
+struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks);
 
 #endif
diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
index 44a4eba80315cc098ecfa366ca1d88483641b12a..4013e6ad2b2f1cb91de12bb428b3281105f7d23b 100644
--- a/kernel/irq/affinity.c
+++ b/kernel/irq/affinity.c
@@ -69,21 +69,20 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 	 * have multiple sets, build each sets affinity mask separately.
 	 */
 	for (i = 0, usedvecs = 0; i < affd->nr_sets; i++) {
-		unsigned int this_vecs = affd->set_size[i];
-		int j;
-		struct cpumask *result = group_cpus_evenly(this_vecs);
+		unsigned int nr_masks, this_vecs = affd->set_size[i];
+		struct cpumask *result = group_cpus_evenly(this_vecs, &nr_masks);
 
 		if (!result) {
 			kfree(masks);
 			return NULL;
 		}
 
-		for (j = 0; j < this_vecs; j++)
+		for (int j = 0; j < nr_masks; j++)
 			cpumask_copy(&masks[curvec + j].mask, &result[j]);
 		kfree(result);
 
-		curvec += this_vecs;
-		usedvecs += this_vecs;
+		curvec += nr_masks;
+		usedvecs += nr_masks;
 	}
 
 	/* Fill out vectors at the end that don't need affinity */
diff --git a/lib/group_cpus.c b/lib/group_cpus.c
index ee272c4cefcc13907ce9f211f479615d2e3c9154..a075959ccb212ece84334e4859c884f4217d30b6 100644
--- a/lib/group_cpus.c
+++ b/lib/group_cpus.c
@@ -332,9 +332,11 @@ static int __group_cpus_evenly(unsigned int startgrp, unsigned int numgrps,
 /**
  * group_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
  * @numgrps: number of groups
+ * @nummasks: number of initialized cpumasks
  *
  * Return: cpumask array if successful, NULL otherwise. And each element
- * includes CPUs assigned to this group
+ * includes CPUs assigned to this group. nummasks contains the number
+ * of initialized masks which can be less than numgrps.
  *
  * Try to put close CPUs from viewpoint of CPU and NUMA locality into
  * same group, and run two-stage grouping:
@@ -344,7 +346,7 @@ static int __group_cpus_evenly(unsigned int startgrp, unsigned int numgrps,
  * We guarantee in the resulted grouping that all CPUs are covered, and
  * no same CPU is assigned to multiple groups
  */
-struct cpumask *group_cpus_evenly(unsigned int numgrps)
+struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
 {
 	unsigned int curgrp = 0, nr_present = 0, nr_others = 0;
 	cpumask_var_t *node_to_cpumask;
@@ -386,7 +388,7 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps)
 	ret = __group_cpus_evenly(curgrp, numgrps, node_to_cpumask,
 				  npresmsk, nmsk, masks);
 	if (ret < 0)
-		goto fail_build_affinity;
+		goto fail_node_to_cpumask;
 	nr_present = ret;
 
 	/*
@@ -405,10 +407,6 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps)
 	if (ret >= 0)
 		nr_others = ret;
 
- fail_build_affinity:
-	if (ret >= 0)
-		WARN_ON(nr_present + nr_others < numgrps);
-
  fail_node_to_cpumask:
 	free_node_to_cpumask(node_to_cpumask);
 
@@ -421,10 +419,11 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps)
 		kfree(masks);
 		return NULL;
 	}
+	*nummasks = min(nr_present + nr_others, numgrps);
 	return masks;
 }
 #else /* CONFIG_SMP */
-struct cpumask *group_cpus_evenly(unsigned int numgrps)
+struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
 {
 	struct cpumask *masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
 
@@ -433,6 +432,7 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps)
 
 	/* assign all CPUs(cpu 0) to the 1st group only */
 	cpumask_copy(&masks[0], cpu_possible_mask);
+	*nummasks = 1;
 	return masks;
 }
 #endif /* CONFIG_SMP */

-- 
2.49.0

