Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B863A36CDF5;
	Fri,  5 Sep 2025 15:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757084407; cv=none; b=hfxf9cOlU3YcFkn0/tykb32Otbhm9D/fbcWhRBwk0ZxGISbMssflSU88BoWmoer+vUdxNvEOSrrnRJhHyo1uYj2uAWGkE6CyF41b8wTUmHInKa/ZlB560DMKQk9f8Ty4hf1KIDw5Ak5+Tlm6H2ob0+B03G3HdHYoirHGWdUQy1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757084407; c=relaxed/simple;
	bh=k9yHbvtPMHlYHOqTRLo94mbOtrFifM61dVhJv1sW7TA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=D2zFtOZtnqDXMIozey1SPsqSCBNn+4f78GbiLy0g44FutJP1vzC/nTfx8fCzxrxKSHUQZv16M/0KWiCl+ncW7ln8HVac5FKJoot41GNaOq2106EPLYOGoxv44/kthRGAiNNeW1n4NRqpsP33EmeDCq+3XnqjmhvONVwACso6fHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TUfOl6ro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TUfOl6ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA751C4CEF1;
	Fri,  5 Sep 2025 15:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757084407;
	bh=k9yHbvtPMHlYHOqTRLo94mbOtrFifM61dVhJv1sW7TA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TUfOl6rowYy65pIZImJDzszrx96/O7vbXzsUHYOaYE41jOv8bzdEaWX04wkpVhUjY
	 xI6fQJY5oeKo2oa4LmNSP2Z95GcUYnzPEXiDeDJ7z/uBwhgiZmCYI1SW6t+Vj6OJil
	 fpBdvAizcOber2iZUav2REjJYR8atrr18TsZWrmaCaOX7V8FPtNLjBICT9IxTYcZ7U
	 k5tUQVZ9oGbIkaW46sAQ9XlBzAmXlRasi53qi/RsPe5JLDNT0TIERdqtDP39p3ci0l
	 vkoups5mYCyx29arnmW5V6uc4mvH4/wLhvL55685uoRUuDffn9sxjmhMPziS589/bn
	 1N3WpK5PTj8sw==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 05 Sep 2025 16:59:51 +0200
Subject: [PATCH v8 05/12] blk-mq: add
 blk_mq_{online|possible}_queue_affinity
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250905-isolcpus-io-queues-v8-5-885984c5daca@kernel.org>
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

Introduce blk_mq_{online|possible}_queue_affinity, which returns the
queue-to-CPU mapping constraints defined by the block layer. This allows
other subsystems (e.g., IRQ affinity setup) to respect block layer
requirements.

It is necessary to provide versions for both the online and possible CPU
masks because some drivers want to spread their I/O queues only across
online CPUs, while others prefer to use all possible CPUs. And the mask
used needs to match with the number of queues requested
(see blk_num_{online|possible}_queues).

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 block/blk-mq-cpumap.c  | 24 ++++++++++++++++++++++++
 include/linux/blk-mq.h |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 705da074ad6c7e88042296f21b739c6d686a72b6..8244ecf878358c0b8de84458dcd5100c2f360213 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -26,6 +26,30 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
 	return min_not_zero(num, max_queues);
 }
 
+/**
+ * blk_mq_possible_queue_affinity - Return block layer queue affinity
+ *
+ * Returns an affinity mask that represents the queue-to-CPU mapping
+ * requested by the block layer based on possible CPUs.
+ */
+const struct cpumask *blk_mq_possible_queue_affinity(void)
+{
+	return cpu_possible_mask;
+}
+EXPORT_SYMBOL_GPL(blk_mq_possible_queue_affinity);
+
+/**
+ * blk_mq_online_queue_affinity - Return block layer queue affinity
+ *
+ * Returns an affinity mask that represents the queue-to-CPU mapping
+ * requested by the block layer based on online CPUs.
+ */
+const struct cpumask *blk_mq_online_queue_affinity(void)
+{
+	return cpu_online_mask;
+}
+EXPORT_SYMBOL_GPL(blk_mq_online_queue_affinity);
+
 /**
  * blk_mq_num_possible_queues - Calc nr of queues for multiqueue devices
  * @max_queues:	The maximum number of queues the hardware/driver
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2a5a828f19a0ba6ff0812daf40eed67f0e12ada1..1144017dce47af82f9d010e42bfbf26fa4ddf33f 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -947,6 +947,8 @@ int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 void blk_mq_unfreeze_queue_non_owner(struct request_queue *q);
 void blk_freeze_queue_start_non_owner(struct request_queue *q);
 
+const struct cpumask *blk_mq_possible_queue_affinity(void);
+const struct cpumask *blk_mq_online_queue_affinity(void);
 unsigned int blk_mq_num_possible_queues(unsigned int max_queues);
 unsigned int blk_mq_num_online_queues(unsigned int max_queues);
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap);

-- 
2.51.0

