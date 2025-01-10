Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0882C212FA7;
	Fri, 10 Jan 2025 16:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526426; cv=none; b=XhWUFNxRWkZyjZ5biSMu62+6WKIshOqGmG+PI0IyUFYreLLPNetoKDDf2kUjvlTVt1iBpj/UNGx0akeElsSadjaa+2+iNZ8NSxb/K04gLYBr1F7+4bWKnQq63nrgFPzqx0rlAr3NZkrUX3hpjl/Lp9FhDxyCZUoCkmY0K46abx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526426; c=relaxed/simple;
	bh=m9BSbBAD2bW8ZLYqHByMdg0GNOBvxPgl189ozbJAOes=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BPetOvAegE7GnjoKRXh3/81+TJgeXmXYiDQ3j+susRUDO5f/EygcKfPoucAB3M3VbCnEfjaC0S3KaOfre7smr/EjRaHSI6ngF84IzYXgbOsBMzACzTk+1F6wI0LLO0h9SLwEt2Ypi208zFSBsP71NSMmxA1h3rbWfLgLwQVznSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r+5ItLis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r+5ItLis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAC7C4CED6;
	Fri, 10 Jan 2025 16:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736526425;
	bh=m9BSbBAD2bW8ZLYqHByMdg0GNOBvxPgl189ozbJAOes=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=r+5ItLis6ADqjLZ00Y7vBeSuGNRtzNTJVGEtwoh4kB07EhnoA3SxtoGr/dXPCT3c1
	 kz15npsjmJ678zcsqURO9gI2VwV24kQrHFJH8kkBl1rqSWY9Q2rdrW45LjMvFwfE3q
	 gUZkNLyyS9gTBOQnQnKkYjVkcbaG4phZN0R2UQq8zj8yfYEgh3JzreHw95snCkDf3U
	 dzuAbKq/fk3DMi0Dlj8MuyNuzMUii/lRG/JyH7Qaxk62A+NN9twYCnys7GuW4Lu7Z4
	 XqvJ09YHEorEWgLvrag9v77l7BFp3nytx8ftJV8BEkJMxPVELC21G/pDlrM1pE9FXG
	 4hJk67zGncQoQ==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 10 Jan 2025 17:26:46 +0100
Subject: [PATCH v5 8/9] blk-mq: issue warning when offlining hctx with
 online isolcpus
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250110-isolcpus-io-queues-v5-8-0e4f118680b0@kernel.org>
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

When isolcpus=managed_irq is enabled, and the last housekeeping CPU for
a given hardware context goes offline, there is no CPU left which
handles the IOs anymore. If isolated CPUs mapped to this hardware
context are online and an application running on these isolated CPUs
issue an IO this will lead to stalls.

The kernel will not schedule IO to isolated CPUS thus this avoids IO
stalls.

Thus issue a warning when housekeeping CPUs are offlined for a hardware
context while there are still isolated CPUs online.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 block/blk-mq.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2e6132f778fd958aae3cad545e4b3dd623c9c304..43eab0db776d37ffd7eb6c084211b5e05d41a574 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3620,6 +3620,45 @@ static bool blk_mq_hctx_has_requests(struct blk_mq_hw_ctx *hctx)
 	return data.has_rq;
 }
 
+static void blk_mq_hctx_check_isolcpus_online(struct blk_mq_hw_ctx *hctx, unsigned int cpu)
+{
+	const struct cpumask *hk_mask;
+	int i;
+
+	if (!housekeeping_enabled(HK_TYPE_MANAGED_IRQ))
+		return;
+
+	hk_mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ);
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
+		pr_warn("%s: offlining hctx%d but there is still an online isolcpu CPU %d mapped to it, IO stalls expected\n",
+			hctx->queue->disk->disk_name,
+			hctx->queue_num, ctx->cpu);
+	}
+}
+
 static bool blk_mq_hctx_has_online_cpu(struct blk_mq_hw_ctx *hctx,
 		unsigned int this_cpu)
 {
@@ -3639,8 +3678,10 @@ static bool blk_mq_hctx_has_online_cpu(struct blk_mq_hw_ctx *hctx,
 			continue;
 
 		/* this hctx has at least one online CPU */
-		if (this_cpu != cpu)
+		if (this_cpu != cpu) {
+			blk_mq_hctx_check_isolcpus_online(hctx, this_cpu);
 			return true;
+		}
 	}
 
 	return false;

-- 
2.47.1

