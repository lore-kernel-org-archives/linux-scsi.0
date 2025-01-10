Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758482135A0;
	Fri, 10 Jan 2025 16:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526411; cv=none; b=e5N+m+IfBOx3wdRtqX3vwOnkq29/Yhe6eHSApCPQPT/ydoWszSUt+h5syehzpYjkLJxL2axqNwOlPKJmG6cSVsVBa8Twflu/WIcAqyvbtrQmhB4zlTdltTIxrsoo8G8uza49XA4U8uxj8IOZl8uXwp07gGEurhnngkVeAI9ZZnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526411; c=relaxed/simple;
	bh=QVb/GKe8Bqk7gvJ7t6g6sEH36EcUHUWPUDhvKJginFE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JG3mu79/YfJrPySN349dRtpa82/poKAdBElHJgN/yTin4xUCqLRpvk77vq97VefmyoUDFAgjxey3Gs5orOCUMDHjyE7zD2r+yrez9nSvR8xtHMzxEyt5gUDM8d4xb1M+Qj8sy7EvjpUOX74YT/mybVSLNCrk2FBMF3pz32Gb2JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KkqCRO+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KkqCRO+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55A8C4CEE0;
	Fri, 10 Jan 2025 16:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736526411;
	bh=QVb/GKe8Bqk7gvJ7t6g6sEH36EcUHUWPUDhvKJginFE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KkqCRO+h0O7VDRnPT7DUgC0u8T+jFoJKaRtYozvfbqZPexSXFY78WUhpbuCZwE/iU
	 THhWtXu515eUJkCX9AsKql7qOc9vFFDEPfy+PTBiKXIJyHPchIML3W5gdhENBmNpRu
	 QQU/Dabi56ixbc2okTxXq84HJpurQximMgOvunw2sPDUPUgfPL6P0gazOIkgfd8DOT
	 blv0125aOJX1h+xDLFvhI3RLTaSGH2ghQIKb2g4oEbaswV+2pOr+Uo8tlP4y83/LwN
	 aQGzFANvP+QrVXrwpFEet/4Ll6APTstXweiSjvK/cJdy8PM9TNeJJBGEd1gZJqKwAG
	 TucYSL5TiiAmQ==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 10 Jan 2025 17:26:40 +0100
Subject: [PATCH v5 2/9] blk-mq: add number of queue calc helper
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250110-isolcpus-io-queues-v5-2-0e4f118680b0@kernel.org>
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

Multiqueue devices should only allocate queues for the housekeeping CPUs
when isolcpus=managed_irq is set. This avoids that the isolated CPUs get
disturbed with OS workload.

Add two variants of helpers which calculates the correct number of
queues which should be used. The need for two variants is necessary
because some drivers calculate their max number of queues based on the
possible CPU mask, others based on the online CPU mask.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 block/blk-mq-cpumap.c  | 45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blk-mq.h |  2 ++
 2 files changed, 47 insertions(+)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 7d3dfe885dfac18711ae73eff510efe3877ffcb6..0923cccdcbcad75ad107c3636af15b723356e087 100644
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
index a0a9007cc1e36f89ebb21e699de3234a3cf9ef5b..f58172755e3464e305a86bbaa0a4509270fd7e0e 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -909,6 +909,8 @@ int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 void blk_mq_unfreeze_queue_non_owner(struct request_queue *q);
 void blk_freeze_queue_start_non_owner(struct request_queue *q);
 
+unsigned int blk_mq_num_possible_queues(unsigned int max_queues);
+unsigned int blk_mq_num_online_queues(unsigned int max_queues);
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap);
 void blk_mq_map_hw_queues(struct blk_mq_queue_map *qmap,
 			  struct device *dev, unsigned int offset);

-- 
2.47.1

