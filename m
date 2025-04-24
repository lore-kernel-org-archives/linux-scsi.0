Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D342900AB;
	Thu, 24 Apr 2025 18:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745518792; cv=none; b=gjOnOZx62mT1X1OFcn1wkRa1LlL0Yg1mYyanwISQ/84LRRjL+9QgpQ1/R2GwnlmJB/1jnSSCo4JjwFQO3G6Y1tSxmzkSvcdE80Nje/LNjIf/CYTvt7/G9/l6CVsr5Xrnf9kDSc2ofZ09oqzYD2djQY+1S0436EQYX3R6meBQAZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745518792; c=relaxed/simple;
	bh=f6sLhWLNagZY9XRHD4d7BNg+tMcaz2lFqt2rqAjJjGg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kZqhr6OH7wiVTr6QmGgmYu7zNfuETtasy1xZjUgz28EPWKyti/u2gLPZe9iuZjXP87f/vvE0oUM6US3pORumZMXcHsa/9bhctPTIQ/Hpn7pvMtzxrns3jM1w11pfSHNMKglNsUA3TAIX2nAvGTtEFRJKzeIrEDblVieHwpIQh84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fbdMUKeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbdMUKeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1490DC4CEE3;
	Thu, 24 Apr 2025 18:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745518791;
	bh=f6sLhWLNagZY9XRHD4d7BNg+tMcaz2lFqt2rqAjJjGg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fbdMUKeGWwMjJERfSlSZeWEmQeMLGEdo6klkJmeyyVtR0QbTpM5JQWYx2vNqp69gG
	 HpXez2i1UI1CuXGApm8LQccBssU6R09hJqnHdbm0QeqO1cggMHntVkDLKyjU9ZPSqD
	 lj4+8RBDKymttnR6MDAFL7MQX/Yv+bYL7S0owsdIlfewG75LOjfjFbF7h3y+g/NtAV
	 859MrTH4dTHjMkfBadxWfKIMcf2zL8Z3blE/P8FvZvK0Mw4gd1EPwNwSlx24T/5Fj6
	 Xr+/tPIGTAnYwBQ8t1hqp6NWV2dFP6d8UqvrBCVvPe20YwegfX+DAUOxehUehE9cyW
	 ki0ZEVdusQOjA==
From: Daniel Wagner <wagi@kernel.org>
Date: Thu, 24 Apr 2025 20:19:41 +0200
Subject: [PATCH v6 2/9] blk-mq: add number of queue calc helper
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250424-isolcpus-io-queues-v6-2-9a53a870ca1f@kernel.org>
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

Multiqueue devices should only allocate queues for the housekeeping CPUs
when isolcpus=io_queue is set. This avoids that the isolated CPUs get
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
index 269161252add756897fce1b65cae5b2e6aebd647..6e6b3e989a5676186b5a31296a1b94b7602f1542 100644
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
index 8eb9b3310167c36f8a67ee8756a97d1274f8e73b..feed1dcaeef51c8db49d3fe667c64ecc824ce655 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -941,6 +941,8 @@ int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 void blk_mq_unfreeze_queue_non_owner(struct request_queue *q);
 void blk_freeze_queue_start_non_owner(struct request_queue *q);
 
+unsigned int blk_mq_num_possible_queues(unsigned int max_queues);
+unsigned int blk_mq_num_online_queues(unsigned int max_queues);
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap);
 void blk_mq_map_hw_queues(struct blk_mq_queue_map *qmap,
 			  struct device *dev, unsigned int offset);

-- 
2.49.0

