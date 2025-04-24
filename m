Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44910294A0F;
	Thu, 24 Apr 2025 18:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745518812; cv=none; b=Tr2xTvWyE4qaA4guyed7VQiMu14QNuM/RXCRombc3UC6aAWtEExLmBfpxVw0qktK1GxiUo8o9VZxvfI+1SSRiTweX5Y2CBZQIeX/Hq44vqYvdJG0/oWHNY5VqjiZrDUdAZBh10UFkEvcMwHPG1v90xmQBvCo32yeXspMO+zv/K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745518812; c=relaxed/simple;
	bh=AXA4x2vMWdvsJD5ZZl+of9Llu+mBLzfjSGJCkdx0VW0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LpQ2SJTY2Lhj+K77UuAaCN6h7Nlkzd2WfmBpyq+0/U2S/4NhkVzc1lSdvPyaJwol19tRBHwIfftjZbWrhhxhjqUssy7exBbDAOBVTDpeK/yEdbiYRcYqfWr/h3t8ZHfVtKz3SgtzdDiWOofEm9YD81abiKp8V1PuRvsIH5mzlZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=how6HOg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="how6HOg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802EAC4CEEA;
	Thu, 24 Apr 2025 18:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745518812;
	bh=AXA4x2vMWdvsJD5ZZl+of9Llu+mBLzfjSGJCkdx0VW0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=how6HOg4xUd6cxF5Runi3vtMopYXzUiZqPCkh7yY5A/H6/k5svrmHDM7XiIz1q3ma
	 SCF02zEuUcIuA5CgDZOYO5ohyY0Hl+8gJ45yLDzOE5zjzceogSpzKcqViPBB1vwyAE
	 adOYVggFJIH2aIm2JAgS6zQEN7IcZngXyv5ZXJdLXkIU4W7Fl7MXvnJ/WcgwzAc1qt
	 2gK72HuBkvXifXx+WDd7V8ycU3/XlsFnP5XDYDE5fm/wBSRGtg5BB/ObPyXrMT+5mf
	 MKDTAQxnd07mHXF6gm14HkmEHDir9usojRd/B6GzJS3AlUT33zOUOq/02ruSNDwxum
	 9pixCn0zcieOg==
From: Daniel Wagner <wagi@kernel.org>
Date: Thu, 24 Apr 2025 20:19:48 +0200
Subject: [PATCH v6 9/9] blk-mq: prevent offlining hk CPU with associated
 online isolated CPUs
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250424-isolcpus-io-queues-v6-9-9a53a870ca1f@kernel.org>
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

When isolcpus=io_queue is enabled, and the last housekeeping CPU for a
given hctx would go offline, there would be no CPU left which handles
the IOs. To prevent IO stalls, prevent offlining housekeeping CPUs which
are still severing isolated CPUs..

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 block/blk-mq.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c2697db591091200cdb9f6e082e472b829701e4c..aff17673b773583dfb2b01cb2f5f010c456bd834 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3627,6 +3627,48 @@ static bool blk_mq_hctx_has_requests(struct blk_mq_hw_ctx *hctx)
 	return data.has_rq;
 }
 
+static bool blk_mq_hctx_check_isolcpus_online(struct blk_mq_hw_ctx *hctx, unsigned int cpu)
+{
+	const struct cpumask *hk_mask;
+	int i;
+
+	if (!housekeeping_enabled(HK_TYPE_IO_QUEUE))
+		return true;
+
+	hk_mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+
+	for (i = 0; i < hctx->nr_ctx; i++) {
+		struct blk_mq_ctx *ctx = hctx->ctxs[i];
+
+		if (ctx->cpu == cpu)
+			continue;
+
+		/*
+		 * Check if this context has at least one online
+		 * housekeeping CPU in this case the hardware context is
+		 * usable.
+		 */
+		if (cpumask_test_cpu(ctx->cpu, hk_mask) &&
+		    cpu_online(ctx->cpu))
+			break;
+
+		/*
+		 * The context doesn't have any online housekeeping CPUs
+		 * but there might be an online isolated CPU mapped to
+		 * it.
+		 */
+		if (cpu_is_offline(ctx->cpu))
+			continue;
+
+		pr_warn("%s: trying to offline hctx%d but there is still an online isolcpu CPU %d mapped to it\n",
+			hctx->queue->disk->disk_name,
+			hctx->queue_num, ctx->cpu);
+		return true;
+	}
+
+	return false;
+}
+
 static bool blk_mq_hctx_has_online_cpu(struct blk_mq_hw_ctx *hctx,
 		unsigned int this_cpu)
 {
@@ -3647,7 +3689,7 @@ static bool blk_mq_hctx_has_online_cpu(struct blk_mq_hw_ctx *hctx,
 
 		/* this hctx has at least one online CPU */
 		if (this_cpu != cpu)
-			return true;
+			return blk_mq_hctx_check_isolcpus_online(hctx, this_cpu);
 	}
 
 	return false;
@@ -3659,7 +3701,7 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
 			struct blk_mq_hw_ctx, cpuhp_online);
 
 	if (blk_mq_hctx_has_online_cpu(hctx, cpu))
-		return 0;
+		return -EINVAL;
 
 	/*
 	 * Prevent new request from being allocated on the current hctx.

-- 
2.49.0

