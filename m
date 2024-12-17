Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DCD1FA832;
	Tue, 17 Dec 2024 18:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734460202; cv=none; b=YHqiksFtp70Gq082Y2TcBwmSj9D78g4l3A+/hHyVs38IPgmt6MaH5tbj82ixRPSkfXjqG0ZxcsB7fks5WVzeDkIbdt17Bp0u943SvzHFB7bF3I+rOvJquMy8d4cNFW962DNEGq6Qz2LmSKI4LvkuxDHVL63lUTq9+CywIR16FF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734460202; c=relaxed/simple;
	bh=dzcQYVyMq7ub0Uj13RUnX1qE3Yh3C14qRsIHuipGrl4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QcMbf4txpbj9Dzd8vuO4H3aupL+pg6w5KJd9XdmYtrLN2WmzHvzpItFubGeYVPHE+LCpx4rf7LfvmV1UHBz1JJtKl61C7Yl/KXILwiM73Qu+VQ3usw6rRS3nL1eDI0pmZJsX09sSkT+WRq9TE22N2NwGyCV6TD7zGjxXHhHw62w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nG8pG+od; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nG8pG+od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C648CC4CED3;
	Tue, 17 Dec 2024 18:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734460201;
	bh=dzcQYVyMq7ub0Uj13RUnX1qE3Yh3C14qRsIHuipGrl4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nG8pG+odeN1F8AWBvZ1AHzhJUVjMLxbf0U4UGyEmyvPLYagYuGY9t7D6ZG8IiLogH
	 S2Oo3if0xy+Q5mPj117g+Uf0Ip4jJ+G/rah17rpxaFZIvlI9CJ3BuTUfs0YKbntkrZ
	 eiVD1NSO9mSUGcJofDrvcHxvEDD8EE0ndWVTjudgJGwtvkvbNRrR7wXsq8weYPYIEw
	 VfV+68CSK2f0pSwNYoh1cPH0E5vWHCpefh8qNL5Okq3zMPBB+AoeQBh2QcftyjFvAE
	 VMd/nuashhEo2taaGbXUnHk6Jjt5OFpdIOIklZcK19PziWJxsEPYNg4ozj6meap0uX
	 0M2cZFIskAI4g==
From: Daniel Wagner <wagi@kernel.org>
Date: Tue, 17 Dec 2024 19:29:41 +0100
Subject: [PATCH v4 7/9] lib/group_cpus: honor housekeeping config when
 grouping CPUs
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241217-isolcpus-io-queues-v4-7-5d355fbb1e14@kernel.org>
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
 lib/group_cpus.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 75 insertions(+), 2 deletions(-)

diff --git a/lib/group_cpus.c b/lib/group_cpus.c
index 73da83ca2c45347a3a443d42d4f16801a47effd5..927e4ed634d0d9ca14235c977fc53d6f5f649396 100644
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
  *
  * Return: cpumask array if successful, NULL otherwise. And each element
@@ -345,7 +346,7 @@ static int __group_cpus_evenly(unsigned int startgrp, unsigned int numgrps,
  * We guarantee in the resulted grouping that all CPUs are covered, and
  * no same CPU is assigned to multiple groups
  */
-struct cpumask *group_cpus_evenly(unsigned int *numgrps)
+static struct cpumask *group_possible_cpus_evenly(unsigned int *numgrps)
 {
 	unsigned int curgrp = 0, nr_present = 0, nr_others = 0, nr_grps;
 	cpumask_var_t *node_to_cpumask;
@@ -426,6 +427,78 @@ struct cpumask *group_cpus_evenly(unsigned int *numgrps)
 	*numgrps = nr_present + nr_others;
 	return masks;
 }
+
+/**
+ * group_mask_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
+ * @numgrps: number of groups
+ * @cpu_mask: CPU to consider for the grouping
+ *
+ * Return: cpumask array if successful, NULL otherwise. And each element
+ * includes CPUs assigned to this group.
+ *
+ * Try to put close CPUs from viewpoint of CPU and NUMA locality into
+ * same group. Allocate present CPUs on these groups evenly.
+ */
+static struct cpumask *group_mask_cpus_evenly(unsigned int *numgrps,
+					      const struct cpumask *cpu_mask)
+{
+	cpumask_var_t *node_to_cpumask;
+	cpumask_var_t nmsk;
+	unsigned int nr_grps;
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
+	nr_grps = *numgrps;
+	masks = kcalloc(nr_grps, sizeof(*masks), GFP_KERNEL);
+	if (!masks)
+		goto fail_node_to_cpumask;
+
+	build_node_to_cpumask(node_to_cpumask);
+
+	ret = __group_cpus_evenly(0, nr_grps, node_to_cpumask, cpu_mask, nmsk,
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
+	*numgrps = ret;
+	return masks;
+}
+
+/**
+ * group_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
+ * @numgrps: number of groups
+ *
+ * Return: cpumask array if successful, NULL otherwise.
+ *
+ * group_possible_cpus_evently() is used for distributing the cpus on all
+ * possible cpus in absence of isolcpus command line argument.
+ * group_mask_cpu_evenly() is used when the isolcpus command line
+ * argument is used with managed_irq option. In this case only the
+ * housekeeping CPUs are considered.
+ */
+struct cpumask *group_cpus_evenly(unsigned int *numgrps)
+{
+	if (housekeeping_enabled(HK_TYPE_MANAGED_IRQ)) {
+		return group_mask_cpus_evenly(numgrps,
+				housekeeping_cpumask(HK_TYPE_MANAGED_IRQ));
+	}
+
+	return group_possible_cpus_evenly(numgrps);
+}
 #else /* CONFIG_SMP */
 struct cpumask *group_cpus_evenly(unsigned int *numgrps)
 {

-- 
2.47.1

