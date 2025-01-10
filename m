Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E8E214209;
	Fri, 10 Jan 2025 16:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526421; cv=none; b=R1ZNgeJTWKLVYPcxaLzJMK03dloQ0XYOy8RweAw2GDjwjQSAt53N13seej0w6EXMsxrrFwvkMuS01hQ7TGSDBUzHeh7SP+CcJ3WFpHL69s9YGI/LaUoH0okY4JJvLldBwnV/4IZcZOsJTNrXQcTB3e/FpPXyl0qIrF1v+0ECT8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526421; c=relaxed/simple;
	bh=acSNL6VJuwcxl8u3g9fPp0k3KcJTFgUi5vnjUgLuaZg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y11TNSg02ZFX3y5F24ZfYgQ0ENhNngwfzkBX+x8YhMTSfHxDNRCKXaZNlvL16eYJBV8T2t9jxQ8BkBCfW5LzF9udAEnWEAH5T9u6/GNzW3fCKarfddddDFl9/ZGykXQIOpGWJ+UeWmQL/X9bo8/Wf69jezWojI8YX4n+cETfNPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z0fhl7Xx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z0fhl7Xx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9860EC4CED6;
	Fri, 10 Jan 2025 16:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736526420;
	bh=acSNL6VJuwcxl8u3g9fPp0k3KcJTFgUi5vnjUgLuaZg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Z0fhl7Xx0B6viqZtmfP0ve2EFvhh9Umxb2dsQCLc+9Z5RtM4/eB9v2/aVulpakmXC
	 xixeQVwz1yFTwOC7YOsLR3VuEcVRQzACUejnveh3W+ahiNxWzbtOtKZ+Ru1b5FpLFu
	 H05rlru2fC6uC+l3lQQk+Z0xgbh93H4GF7keUesoqABEU8QktZabrvjfXmZ36vpCdc
	 OrdKDKhw4QFL9nsrDOZZvr9HX2Kofaum4CaFQuXEPWtpPtMOpdGPOhBk6oXdM9sydK
	 43peoEW6bvrCFcZVg50pkPxlld/99avxof/pFnMkPm11kYJSN09zgG4zzuHf7cuOw0
	 g7gA1v8nqy47Q==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 10 Jan 2025 17:26:44 +0100
Subject: [PATCH v5 6/9] lib/group_cpus: honor housekeeping config when
 grouping CPUs
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250110-isolcpus-io-queues-v5-6-0e4f118680b0@kernel.org>
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

group_cpus_evenly distributes all present CPUs into groups. This ignores
the isolcpus configuration and assigns isolated CPUs into the groups.

Make group_cpus_evenly aware of isolcpus configuration and use the
housekeeping CPU mask as base for distributing the available CPUs into
groups.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 lib/group_cpus.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 79 insertions(+), 3 deletions(-)

diff --git a/lib/group_cpus.c b/lib/group_cpus.c
index 016c6578a07616959470b47121459a16a1bc99e5..ba112dda527552a031dff083e77b748ac2629ca8 100644
--- a/lib/group_cpus.c
+++ b/lib/group_cpus.c
@@ -8,6 +8,7 @@
 #include <linux/cpu.h>
 #include <linux/sort.h>
 #include <linux/group_cpus.h>
+#include <linux/sched/isolation.h>
 
 #ifdef CONFIG_SMP
 
@@ -330,7 +331,7 @@ static int __group_cpus_evenly(unsigned int startgrp, unsigned int numgrps,
 }
 
 /**
- * group_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
+ * group_possible_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
  * @numgrps: number of groups
  * @nummasks: number of initialized cpumasks
  *
@@ -346,8 +347,8 @@ static int __group_cpus_evenly(unsigned int startgrp, unsigned int numgrps,
  * We guarantee in the resulted grouping that all CPUs are covered, and
  * no same CPU is assigned to multiple groups
  */
-struct cpumask *group_cpus_evenly(unsigned int numgrps,
-				  unsigned int *nummasks)
+static struct cpumask *group_possible_cpus_evenly(unsigned int numgrps,
+						  unsigned int *nummasks)
 {
 	unsigned int curgrp = 0, nr_present = 0, nr_others = 0;
 	cpumask_var_t *node_to_cpumask;
@@ -427,6 +428,81 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps,
 	*nummasks = nr_present + nr_others;
 	return masks;
 }
+
+/**
+ * group_mask_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
+ * @numgrps: number of groups
+ * @cpu_mask: CPU to consider for the grouping
+ * @nummasks: number of initialized cpusmasks
+ *
+ * Return: cpumask array if successful, NULL otherwise. And each element
+ * includes CPUs assigned to this group.
+ *
+ * Try to put close CPUs from viewpoint of CPU and NUMA locality into
+ * same group. Allocate present CPUs on these groups evenly.
+ */
+static struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
+					      const struct cpumask *cpu_mask,
+					      unsigned int *nummasks)
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
+	ret = __group_cpus_evenly(0, numgrps, node_to_cpumask, cpu_mask, nmsk,
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
+
+/**
+ * group_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
+ * @numgrps: number of groups
+ * @nummasks: number of initialized cpusmasks
+ *
+ * Return: cpumask array if successful, NULL otherwise.
+ *
+ * group_possible_cpus_evently() is used for distributing the cpus on all
+ * possible cpus in absence of isolcpus command line argument.
+ * group_mask_cpu_evenly() is used when the isolcpus command line
+ * argument is used with managed_irq option. In this case only the
+ * housekeeping CPUs are considered.
+ */
+struct cpumask *group_cpus_evenly(unsigned int numgrps,
+				  unsigned int *nummasks)
+{
+	if (housekeeping_enabled(HK_TYPE_MANAGED_IRQ)) {
+		return group_mask_cpus_evenly(numgrps,
+				housekeeping_cpumask(HK_TYPE_MANAGED_IRQ),
+				nummasks);
+	}
+
+	return group_possible_cpus_evenly(numgrps, nummasks);
+}
 #else /* CONFIG_SMP */
 struct cpumask *group_cpus_evenly(unsigned int numgrps,
 				  unsigned int *nummasks)

-- 
2.47.1

