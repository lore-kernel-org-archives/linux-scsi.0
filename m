Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF831F9AB4;
	Tue, 17 Dec 2024 18:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734460192; cv=none; b=Wi9uxDUzui52gSMT+y3/exMY2LOtstFR0FJ5fr/LM+MwhlqEBoBbZ4yvgCwKy6pmxME0OAHaWzAqUJm0A7NmkA1uoRyOBmaGe0gbBp0pqD2CJmfUwC+Eb12fzAF2RREexvSyZaHU4DiQjbOg7sBQdwA973Cbjix0sUtXjIzKZq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734460192; c=relaxed/simple;
	bh=J8AQ9XfymIw2GabflSCTi0yfwCmZTc/3XvdEqwuuAXs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RpxsFosSvUojEREMG8DednbKIcRlt5SAOjIWFtPpkniMMX4+FfYAJ100+CgTh0uZrYwIImBLh/hAlumNNWPZF3046Ug75jCeD5GftxpAiHm/aXtpdPvkGUDO1RmuBxkP1NCzZVLeOsFKsDh1bxiIQ12Lo7roXfBY2fs6f/LreAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lYcE5ER4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lYcE5ER4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BE3C4CEDF;
	Tue, 17 Dec 2024 18:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734460191;
	bh=J8AQ9XfymIw2GabflSCTi0yfwCmZTc/3XvdEqwuuAXs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=lYcE5ER4WqHafND2JV2YcmsMXvebT7xabLiuYqWbNUv5yN4UICqQu62xU4mKGC8og
	 16QjYsmOFoy3qOB73Qskervz60t9UQE8Hij7bIulPxKtsUyWT1B+5kflUjghgMRnhx
	 qr9reApEvmjcZWP0qGaCry7raoaM+oZT/wDYaW/cccY9slC/ptFO5DZ+rIbOTvvdYX
	 9x5zTaSm6kdHbxP31bj/hLMZlMQwQNDObpjrDK0PTQNCWtHbwCwMVH4ms4Gvv96bGW
	 +ujZuNGrq4jOpo2XBn8/5Ez5t8PtiET+jXDzAIR8b8Ljw+B1iHREBQ0T2TTSEcuh3N
	 SL6/lwveSYqwg==
From: Daniel Wagner <wagi@kernel.org>
Date: Tue, 17 Dec 2024 19:29:37 +0100
Subject: [PATCH v4 3/9] blk-mq: add number of queue calc helper
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241217-isolcpus-io-queues-v4-3-5d355fbb1e14@kernel.org>
References: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
In-Reply-To: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 Kashyap Desai <kashyap.desai@broadcom.com>, 
 Sumit Saxena <sumit.saxena@broadcom.com>, 
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
 Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, 
 Don Brace <don.brace@microchip.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Thomas Gleixner <tglx@linutronix.de>
Cc: Costa Shulyupin <costa.shul@redhat.com>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
 Ming Lei <ming.lei@redhat.com>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, 
 Hannes Reinecke <hare@suse.de>, 
 Sridhar Balaraman <sbalaraman@parallelwireless.com>, 
 "brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 storagedev@microchip.com, virtualization@lists.linux.dev, 
 Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

Multiqueue devices should only allocate queues for the housekeeping CPUs
when isolcpus=managed_irq is set. This avoids that the isolated CPUs get
disturbed with OS workload.

Add two variants of helpers which calculates the correct number of
queues which should be used. The need for two variants is necessary
because some drivers calculate their max number of queues based on the
possible CPU mask, others based on the online CPU mask.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 block/blk-mq-cpumap.c  | 45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blk-mq.h |  2 ++
 2 files changed, 47 insertions(+)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 85c0a7073bd8bff5d34aad1729d45d89da4c4bd1..b3a863c2db3231624685ab54a1810b22af4111f4 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -12,10 +12,55 @@
 #include <linux/cpu.h>
 #include <linux/group_cpus.h>
 #include <linux/device/bus.h>
+#include <linux/sched/isolation.h>
 
 #include "blk.h"
 #include "blk-mq.h"
 
+static unsigned int blk_mq_num_queues(const struct cpumask *mask,
+				      unsigned int max_queues)
+{
+	unsigned int num;
+
+	if (housekeeping_enabled(HK_TYPE_MANAGED_IRQ))
+		mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ);
+
+	num = cpumask_weight(mask);
+	return min_not_zero(num, max_queues);
+}
+
+/**
+ * blk_mq_num_possible_queues - Calc nr of queues for multiqueue devices
+ * @max_queues:	The maximal number of queues the hardware/driver
+ *		supports. If max_queues is 0, the argument is
+ *		ignored.
+ *
+ * Calculate the number of queues which should be used for a multiqueue
+ * device based on the number of possible cpu. The helper is considering
+ * isolcpus settings.
+ */
+unsigned int blk_mq_num_possible_queues(unsigned int max_queues)
+{
+	return blk_mq_num_queues(cpu_possible_mask, max_queues);
+}
+EXPORT_SYMBOL_GPL(blk_mq_num_possible_queues);
+
+/**
+ * blk_mq_num_online_queues - Calc nr of queues for multiqueue devices
+ * @max_queues:	The maximal number of queues the hardware/driver
+ *		supports. If max_queues is 0, the argument is
+ *		ignored.
+ *
+ * Calculate the number of queues which should be used for a multiqueue
+ * device based on the number of online cpus. The helper is considering
+ * isolcpus settings.
+ */
+unsigned int blk_mq_num_online_queues(unsigned int max_queues)
+{
+	return blk_mq_num_queues(cpu_online_mask, max_queues);
+}
+EXPORT_SYMBOL_GPL(blk_mq_num_online_queues);
+
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
 {
 	const struct cpumask *masks;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 769eab6247d4921e574e0828ab41a580a5a9f2fe..4f0f2ea64de2057750e88c2a3ff7d49e13a7bfc5 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -920,6 +920,8 @@ int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 void blk_mq_unfreeze_queue_non_owner(struct request_queue *q);
 void blk_freeze_queue_start_non_owner(struct request_queue *q);
 
+unsigned int blk_mq_num_possible_queues(unsigned int max_queues);
+unsigned int blk_mq_num_online_queues(unsigned int max_queues);
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap);
 void blk_mq_map_hw_queues(struct blk_mq_queue_map *qmap,
 			  struct device *dev, unsigned int offset);

-- 
2.47.1

