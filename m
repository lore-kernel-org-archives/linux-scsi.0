Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917502FB0AA;
	Fri,  5 Sep 2025 15:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757084403; cv=none; b=TMz9SkIvLiu4xZC89nthkExwvUxnqqi1/3jOppGKwmgnxpFGXfNMwNdl3wRQjhiqeIZruOpfxoC/t+MJkHCCil4xNBpd1CdvYr19pMVWjBv0pWrTLoFIEiJau0p0Dtw7y2FYajepsnx9sQSl3S9Ggqud5osox2o0xKizNqCUrsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757084403; c=relaxed/simple;
	bh=Wl3psk4yz/I2G8DI01Law+whUjHAwMS8E1qTNfYn1II=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=e9p+vn01VsYxix2hcVbidJWguGHOxwBn+6XOWfcIovfL3iRN7hZD4pkntcB9nFPR7VA2/DKcRhzaIlXnOLumjfiBfjTOOp8Xb6rR/2FWhKkZy63S9ofcTWL/zrPTR0gCj/I3CH9txl5ePLYQXBTYYTspZP4hlfKIvuXSW0+fI5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SaT+LIQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SaT+LIQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7500CC4CEF1;
	Fri,  5 Sep 2025 15:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757084402;
	bh=Wl3psk4yz/I2G8DI01Law+whUjHAwMS8E1qTNfYn1II=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SaT+LIQY8gRZt5r3JVPE1VWAE8BYv07xDKmOFisly2MQ8sY4al6qxlaF2zI0WhKEh
	 446bMLnHaRbPHdKu7sNk94f7iiYST/dS/DXbORlBOVSV36UFwWP7+OJFtu7Wn0g2ht
	 UN70PcJv0qPMcFRW+KGGWbHz+P9FoS2kKZLpzwX8TjPvAqV5HtNu1LPthyijYuYev2
	 evd6JFbSO2js6tD1WTkwy2J6gClBk9xelW93j2sb0F8Yb+nnqe79be/lIkZCyDbntr
	 qiy5hfr2X/GP447D6Q5GztXgkP1SoS5uoyohCF69dsDuyJ7CYDucD3PtFxTCadOVQ5
	 guIM4e8sHiSOw==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 05 Sep 2025 16:59:49 +0200
Subject: [PATCH v8 03/12] lib/group_cpus: Add group_mask_cpus_evenly()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250905-isolcpus-io-queues-v8-3-885984c5daca@kernel.org>
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

group_mask_cpu_evenly() allows the caller to pass in a CPU mask that
should be evenly distributed. This new function is a more generic
version of the existing group_cpus_evenly(), which always distributes
all present CPUs into groups.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 include/linux/group_cpus.h |  3 +++
 lib/group_cpus.c           | 59 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/include/linux/group_cpus.h b/include/linux/group_cpus.h
index 9d4e5ab6c314b31c09fda82c3f6ac18f77e9de36..defab4123a82fa37cb2a9920029be8e3e121ca0d 100644
--- a/include/linux/group_cpus.h
+++ b/include/linux/group_cpus.h
@@ -10,5 +10,8 @@
 #include <linux/cpu.h>
 
 struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks);
+struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
+				       const struct cpumask *mask,
+				       unsigned int *nummasks);
 
 #endif
diff --git a/lib/group_cpus.c b/lib/group_cpus.c
index f254b232522d44c141cdc4e44e2c99a4148c08d6..ec0852132266618f540c580422f254684129ce90 100644
--- a/lib/group_cpus.c
+++ b/lib/group_cpus.c
@@ -8,6 +8,7 @@
 #include <linux/cpu.h>
 #include <linux/sort.h>
 #include <linux/group_cpus.h>
+#include <linux/sched/isolation.h>
 
 static void grp_spread_init_one(struct cpumask *irqmsk, struct cpumask *nmsk,
 				unsigned int cpus_per_grp)
@@ -424,3 +425,61 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
 	return masks;
 }
 EXPORT_SYMBOL_GPL(group_cpus_evenly);
+
+/**
+ * group_mask_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
+ * @numgrps: number of cpumasks to create
+ * @mask: CPUs to consider for the grouping
+ * @nummasks: number of initialized cpusmasks
+ *
+ * Return: cpumask array if successful, NULL otherwise. Only the CPUs
+ * marked in the mask will be considered for the grouping. And each
+ * element includes CPUs assigned to this group. nummasks contains the
+ * number of initialized masks which can be less than numgrps. cpu_mask
+ *
+ * Try to put close CPUs from viewpoint of CPU and NUMA locality into
+ * same group, and run two-stage grouping:
+ *	1) allocate present CPUs on these groups evenly first
+ *	2) allocate other possible CPUs on these groups evenly
+ *
+ * We guarantee in the resulted grouping that all CPUs are covered, and
+ * no same CPU is assigned to multiple groups
+ */
+struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
+				       const struct cpumask *mask,
+				       unsigned int *nummasks)
+{
+	cpumask_var_t *node_to_cpumask;
+	cpumask_var_t nmsk;
+	int ret = -ENOMEM;
+	struct cpumask *masks = NULL;
+
+	if (!zalloc_cpumask_var(&nmsk, GFP_KERNEL))
+		return NULL;
+
+	node_to_cpumask = alloc_node_to_cpumask();
+	if (!node_to_cpumask)
+		goto fail_nmsk;
+
+	masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
+	if (!masks)
+		goto fail_node_to_cpumask;
+
+	build_node_to_cpumask(node_to_cpumask);
+
+	ret = __group_cpus_evenly(0, numgrps, node_to_cpumask, mask, nmsk,
+				  masks);
+
+fail_node_to_cpumask:
+	free_node_to_cpumask(node_to_cpumask);
+
+fail_nmsk:
+	free_cpumask_var(nmsk);
+	if (ret < 0) {
+		kfree(masks);
+		return NULL;
+	}
+	*nummasks = ret;
+	return masks;
+}
+EXPORT_SYMBOL_GPL(group_mask_cpus_evenly);

-- 
2.51.0

