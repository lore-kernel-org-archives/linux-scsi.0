Received: from mail.nearlyone.de (mail.nearlyone.de [49.12.199.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAE01CB33E;
	Tue,  6 Aug 2024 12:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.199.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722946068; cv=none; b=Bxn7WXwO4Y265iMZzeW95xUU77GpSxN8aGGBn4g99/dUJ9toR8m+0Dk+ZFuk+K7z6AfsSgM2hkgblAtbJFJjAZSzSjcE4NPsYnT3ST3xF198bvfc5xe2xBG0PfLXhI/2xVNTiXvbmpV9ptT++aAPJkD7GKJXK9ZB1qCecSF2eZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722946068; c=relaxed/simple;
	bh=EeSlh6HQgSapOe5YllNashjoq27f1osI04/1RQlyu0w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZzSI3Oe6klJYvd0SkfwoO8kv8DPZ7HKEDuebvIlKFN3KkH8EIvz73x8rH/ZCZZ1nifjEPwfKf8wnEjYz0q+LpbeC2nUNxfeAvoQWgu5iA1ssLkFZkxGyfuyTakwK6DhATInSzOmsLoZ6qqWdr8JGl2Zh54b3Lv3tB6g9lgVkmDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=monom.org; dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b=tTGUux5A; arc=none smtp.client-ip=49.12.199.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monom.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b="tTGUux5A"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 89206DAE28;
	Tue,  6 Aug 2024 14:07:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
	t=1722946063; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=K2bsze7ezb+slXPQ4bNAIIy8wybtR+D2TJArZapU+cQ=;
	b=tTGUux5AC/Uk20RXr+NxBO7HWhYzxcUt11TumR8DSPHGCBv6uxLlApfR3XG9AePQeQU5h+
	BV7HB7CPO6RrdHe/ocJaAE3caYnM1dn8AkvFhgikgXbNIxfR2ZB01H7LEc8WStUJ5Go0AP
	d/nx/I4+hCNzkMbRXoTyG1zsxM7fDyDqzhhzVSN/foeQsfFtIHF50v0GmEgi3VvLNWWTAW
	Dv5n56BIWsEkZ2AmjpksM5dqns6lO/Xw/9Q034k0hIgHiph0dSB1myGy5w3caNIE2BjiDn
	V+0Y5eN0PMpFkison9rMooG+Yfa+CduSYwsFSxqO5N1HvDYUAwIMvO/lSkJO6Q==
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 06 Aug 2024 14:06:47 +0200
Subject: [PATCH v3 15/15] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240806-isolcpus-io-queues-v3-15-da0eecfeaf8b@suse.de>
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

When isolcpus=io_queue is enabled all hardware queues should run on the
housekeeping CPUs only. Thus ignore the affinity mask provided by the
driver. Also we can't use blk_mq_map_queues because it will map all CPUs
to first hctx unless, the CPU is the same as the hctx has the affinity
set to, e.g. 8 CPUs with isolcpus=io_queue,2-3,6-7 config

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

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 block/blk-mq-cpumap.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index c1277763aeeb..7e026c2ffa02 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -60,11 +60,64 @@ unsigned int blk_mq_num_online_queues(unsigned int max_queues)
 }
 EXPORT_SYMBOL_GPL(blk_mq_num_online_queues);
 
+static bool blk_mq_hk_map_queues(struct blk_mq_queue_map *qmap)
+{
+	struct cpumask *hk_masks;
+	cpumask_var_t isol_mask;
+
+	unsigned int queue, cpu;
+
+	if (!housekeeping_enabled(HK_TYPE_IO_QUEUE))
+		return false;
+
+	/* map housekeeping cpus to matching hardware context */
+	hk_masks = group_cpus_evenly(qmap->nr_queues);
+	if (!hk_masks)
+		goto fallback;
+
+	for (queue = 0; queue < qmap->nr_queues; queue++) {
+		for_each_cpu(cpu, &hk_masks[queue])
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
 	unsigned int queue, cpu;
 
+	if (blk_mq_hk_map_queues(qmap))
+		return;
+
 	masks = group_cpus_evenly(qmap->nr_queues);
 	if (!masks) {
 		for_each_possible_cpu(cpu)
@@ -118,6 +171,9 @@ void blk_mq_dev_map_queues(struct blk_mq_queue_map *qmap,
 	const struct cpumask *mask;
 	unsigned int queue, cpu;
 
+	if (blk_mq_hk_map_queues(qmap))
+		return;
+
 	for (queue = 0; queue < qmap->nr_queues; queue++) {
 		mask = get_queue_affinity(dev_data, dev_off, queue);
 		if (!mask)

-- 
2.46.0

