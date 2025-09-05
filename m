Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01F9302160;
	Fri,  5 Sep 2025 15:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757084423; cv=none; b=mnU0OLmiZjpIZ/o6G/zv0WWayMhu3gA3zA5dmb/Zwm9unWmbv/r9P+OzTa8aOTshxoSk9P5rxMVQlF6iPhQYphA1xe+srusO2x+IJnFJW9n6mSG0MQpd+ph9zX/62Zn6jycJiTnUxsm7V8+QeVZdB0Dwruj6peBlJsvl9YAZ+vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757084423; c=relaxed/simple;
	bh=2v7bxc9EDvGbPUx12PCfOO335CQ1KQF9NiHv3L5/cgE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JqBhfb0T/1eSj9ZjcJ5apMk0O8iWI6HLE5I4ZGDs9P4IJ+sXPK2eHrTPA0XYkRhNUGUks+jo7CwX8P6G0O3C0U5GqXE+08ydyCn6Yy1igghOzO79nxb6NCY1joAkw/YT8HAD0qCHeDkNeivJ0Dwbj0bdMOULMqZabyOq/P/0pCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYK0q88o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYK0q88o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5318EC4CEFB;
	Fri,  5 Sep 2025 15:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757084422;
	bh=2v7bxc9EDvGbPUx12PCfOO335CQ1KQF9NiHv3L5/cgE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jYK0q88oThugXgoE47fgFny1Kd4QkHJfWDMrbqCZ2bX524uk+igsJSP9tWUDq+3dI
	 XEV34HdJo+MofOFS1XOn/zVy2bJBztrTe+IawbiiTpepm0YQg5sNCwL5lJp/hYa1pu
	 lG6l/xFY47zWkwg4rAGuEuj/jsZYlfz4DP0PfL/WNsFWY6zSba9f2HMufqSizHEUod
	 T+0BRUVz8EeqhNecB1v4So7FV46f4DZBgWYkQ+N4xHhT9PwqlOxOY5LC3WGThjdCI8
	 UfzMr3LYwkUxLzPLjIaOMgh3PVNyEOMN/lJ0XmkLDSspwyQCltUzOaESFdEm45bm9l
	 mdYAz4sbi5Szw==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 05 Sep 2025 16:59:57 +0200
Subject: [PATCH v8 11/12] blk-mq: prevent offlining hk CPUs with associated
 online isolated CPUs
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250905-isolcpus-io-queues-v8-11-885984c5daca@kernel.org>
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

When isolcpus=io_queue is enabled, and the last housekeeping CPU for a
given hctx goes offline, there would be no CPU left to handle I/O. To
prevent I/O stalls, prevent offlining housekeeping CPUs that are still
serving isolated CPUs.

When isolcpus=io_queue is enabled and the last housekeeping CPU
for a given hctx goes offline, no CPU would be left to handle I/O.
To prevent I/O stalls, disallow offlining housekeeping CPUs that are
still serving isolated CPUs.

Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 block/blk-mq.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ba3a4b77f5786e5372adce53e4fff5aa2ace24aa..d48be77919e671a81077f7042103699a80959664 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3683,6 +3683,43 @@ static bool blk_mq_hctx_has_requests(struct blk_mq_hw_ctx *hctx)
 	return data.has_rq;
 }
 
+static bool blk_mq_hctx_can_offline_hk_cpu(struct blk_mq_hw_ctx *hctx,
+					   unsigned int this_cpu)
+{
+	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+
+	for (int i = 0; i < hctx->nr_ctx; i++) {
+		struct blk_mq_ctx *ctx = hctx->ctxs[i];
+
+		if (ctx->cpu == this_cpu)
+			continue;
+
+		/*
+		 * Check if this context has at least one online
+		 * housekeeping CPU; in this case the hardware context is
+		 * usable.
+		 */
+		if (cpumask_test_cpu(ctx->cpu, hk_mask) &&
+		    cpu_online(ctx->cpu))
+			break;
+
+		/*
+		 * The context doesn't have any online housekeeping CPUs,
+		 * but there might be an online isolated CPU mapped to
+		 * it.
+		 */
+		if (cpu_is_offline(ctx->cpu))
+			continue;
+
+		pr_warn("%s: trying to offline hctx%d but there is still an online isolcpu CPU %d mapped to it\n",
+			hctx->queue->disk->disk_name,
+			hctx->queue_num, ctx->cpu);
+		return false;
+	}
+
+	return true;
+}
+
 static bool blk_mq_hctx_has_online_cpu(struct blk_mq_hw_ctx *hctx,
 		unsigned int this_cpu)
 {
@@ -3714,6 +3751,11 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
 	struct blk_mq_hw_ctx *hctx = hlist_entry_safe(node,
 			struct blk_mq_hw_ctx, cpuhp_online);
 
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
+		if (!blk_mq_hctx_can_offline_hk_cpu(hctx, cpu))
+			return -EINVAL;
+	}
+
 	if (blk_mq_hctx_has_online_cpu(hctx, cpu))
 		return 0;
 

-- 
2.51.0

