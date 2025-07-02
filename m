Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC7A2FF473;
	Wed,  2 Jul 2025 16:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751474046; cv=none; b=D447aE6GmohTOE5A9x+Po0pMch62Ep11q7XATT/GZgO3pTL8kF5B/RQjjV5d2Kd4Vp8xsq0r0G/iVzT98V58FYxUEvOY03HcaLdM9zFriga9OwCLajRthpNLmpqH9LKgUB3tIc0AQ5XB2cNmtRqK5ty0VyMournR7sgloIBaAsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751474046; c=relaxed/simple;
	bh=2jFcWt4TaI6jb5x1qKdDvFAnJ6UQykVgbrYvKi3QUMk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FhwInI5zMmNGXpTCHyrXTf03ain0Gx+OytqR3cTxv9AXsL0D/3PHTI8Bm11NP4zzvRwG2FC+Xf3VLTwycRlRU1U3/Z9OuY2Q9egoqsJkhJUSPVM9R2LjsyK0Jy/gGy/tvvmjw7d36GgOKqVAf1+98fkVdC9CTvw2yAj98bN2vM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KwFrcAcD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KwFrcAcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8029DC4CEE7;
	Wed,  2 Jul 2025 16:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751474046;
	bh=2jFcWt4TaI6jb5x1qKdDvFAnJ6UQykVgbrYvKi3QUMk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KwFrcAcDdbuzwSvH/CtCJ3T9ilfoD/X2EoUJrhsI6MOdzufP0ARHIrCSe4GFqw+k9
	 g1rADfJVbg+TFBz7MG5tfRwvwuNj8HAecQjVqMGrIua3DHgB88RLLCCTXD5Q5/tj1m
	 /4/s2cRp1XoKTR4U5W6PYIOeEfCNqqwxCcmb+eImlUb0+gprn/Wn8j3/LkYFofR2jm
	 a7LHKtnyeH+0422XR4ZMpJNq7IlQb6zrlHsILfjM4CoJOl4zwiPwTIIEHOrWYAtZYB
	 1tj4lAwfa75M+KTP00sUdlKvj7oVuBR5v6aiCko7oVG2xfyV5prEmG/wMDcOK9Gkqb
	 ibHA4dXV/zUHQ==
From: Daniel Wagner <wagi@kernel.org>
Date: Wed, 02 Jul 2025 18:33:51 +0200
Subject: [PATCH v7 01/10] lib/group_cpus: Add group_masks_cpus_evenly()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250702-isolcpus-io-queues-v7-1-557aa7eacce4@kernel.org>
References: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
In-Reply-To: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
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
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, storagedev@microchip.com, 
 virtualization@lists.linux.dev, GR-QLogic-Storage-Upstream@marvell.com, 
 Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

group_mask_cpus_evenly() allows the caller to pass in a CPU mask that
should be evenly distributed. This new function is a more generic
version of the existing group_cpus_evenly(), which always distributes
all present CPUs into groups.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 include/linux/group_cpus.h |  3 +++
 lib/group_cpus.c           | 64 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/include/linux/group_cpus.h b/include/linux/group_cpus.h
index 9d4e5ab6c314b31c09fda82c3f6ac18f77e9de36..d4604dce1316a08400e982039006331f34c18ee8 100644
--- a/include/linux/group_cpus.h
+++ b/include/linux/group_cpus.h
@@ -10,5 +10,8 @@
 #include <linux/cpu.h>
 
 struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks);
+struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
+				       const struct cpumask *cpu_mask,
+				       unsigned int *nummasks);
 
 #endif
diff --git a/lib/group_cpus.c b/lib/group_cpus.c
index 6d08ac05f371bf880571507d935d9eb501616a84..00c9b7a10c8acd29239fe20d2a30fdae22ef74a5 100644
--- a/lib/group_cpus.c
+++ b/lib/group_cpus.c
@@ -8,6 +8,7 @@
 #include <linux/cpu.h>
 #include <linux/sort.h>
 #include <linux/group_cpus.h>
+#include <linux/sched/isolation.h>
 
 #ifdef CONFIG_SMP
 
@@ -425,6 +426,59 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
 	*nummasks = min(nr_present + nr_others, numgrps);
 	return masks;
 }
+EXPORT_SYMBOL_GPL(group_cpus_evenly);
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
+struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
+				       const struct cpumask *cpu_mask,
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
+EXPORT_SYMBOL_GPL(group_mask_cpus_evenly);
+
 #else /* CONFIG_SMP */
 struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
 {
@@ -442,5 +496,13 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
 	*nummasks = 1;
 	return masks;
 }
-#endif /* CONFIG_SMP */
 EXPORT_SYMBOL_GPL(group_cpus_evenly);
+
+struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
+				       const struct cpumask *cpu_mask,
+				       unsigned int *nummasks)
+{
+	return group_cpus_evenly(numgrps, nummasks);
+}
+EXPORT_SYMBOL_GPL(group_mask_cpus_evenly);
+#endif /* CONFIG_SMP */

-- 
2.50.0

