Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAE21FAC53;
	Tue, 17 Dec 2024 18:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734460206; cv=none; b=KYk/yTpEXcpA8q37MdzzpRbXYIji01CuoABEy0omzoDgpemrSlK9n1sU/HqZG7pYwiks09Ailcu0zLek1gbYpam3ZkrnPGUj+9Oj+pvo9nLnsUqll01NYZIkEefbROlyvdlHXnSNA1tzyF1oMefmTjB6BKdFdOI5M+V4+tV4yyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734460206; c=relaxed/simple;
	bh=6NgFV7+SLJHkzCci3gNbm7cBYHWTyZIkNamwDIlbLeY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Bj6HiztUGL39yxOUV/zzs8LHw7kcroQFEP5yfrXmmVy+nwmnyZ/+4M9TpiJ3a0W0cY1QmPrtBQWlqpb43catXnn5MPco1XktayKkFMdmuL8F7UAqY1gQ9wU5l3IZaRqyDbKR39rKyGIlQ0qj3Fb5jSel4PlrHIpuO7/9xQSkVZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s6Kv27+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s6Kv27+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEDBC4CED7;
	Tue, 17 Dec 2024 18:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734460206;
	bh=6NgFV7+SLJHkzCci3gNbm7cBYHWTyZIkNamwDIlbLeY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=s6Kv27+RnXSPrl2jQCg0fkmNWjHVSiB/hAypqxFY66hSV7caMFNcFSK9tefnE2j9D
	 4VbA1/GbM9ZVKy8tWqx699sdcqv9NCX8Pbgz/cDonCQ1O4uhOltf/ng8vOftMg8qLI
	 lmxKzV9+CUUzhx85La7dhEaQgYdecAI5Ogz0N/F6chL7REarIP7YADQY4s+x45YeFH
	 vV5ptlSjGSqA+RYyXOk99DPYju/HT35KkViwL5WI2VvpjJK6uNHYY5ZLa1KLPSUkk7
	 xMfjlLKxelpJ/H5zZtseSfB/nl/OowQ7AE/vSLMPBeemE+TXvoPmt90w9y20mhLuQh
	 bglrtOGwWgJRA==
From: Daniel Wagner <wagi@kernel.org>
Date: Tue, 17 Dec 2024 19:29:43 +0100
Subject: [PATCH v4 9/9] blk-mq: issue warning when offlining hctx with
 online isolcpus
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241217-isolcpus-io-queues-v4-9-5d355fbb1e14@kernel.org>
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

When we offlining a hardware context which also serves isolcpus mapped
to it, any IO issued by the isolcpus will stall as there is nothing
which handles the interrupts etc.

This configuration/setup is not supported at this point thus just issue
a warning.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 block/blk-mq.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index de15c0c76f874a2a863b05a23e0f3dba20cb6488..f9af0f5dd6aac8da855777acf2ffc61128f15a74 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3619,6 +3619,45 @@ static bool blk_mq_hctx_has_requests(struct blk_mq_hw_ctx *hctx)
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
@@ -3638,8 +3677,10 @@ static bool blk_mq_hctx_has_online_cpu(struct blk_mq_hw_ctx *hctx,
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

