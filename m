Received: from mail.nearlyone.de (mail.nearlyone.de [49.12.199.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CE01CB31C;
	Tue,  6 Aug 2024 12:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.199.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722946066; cv=none; b=AKgkJOWQ337TP1Pm9XZbl9kZlPpwyw738CjD6EVwfGY81MV3NqTj4wcL5n3EHYqLc2berCZeMeIknmfzvVw5sCJQjk/iRpN2XtOi5pvokHHr4PDqJWk56VgZasHHKxsG2HLFum8/UGjvy/k58GVGM8NmaRex00h2vle4uMsFNbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722946066; c=relaxed/simple;
	bh=4xNgx/Eb1X/+hfCHEviUArVRn24QXWkWpDvII35nF8Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RSGOB+CErG9ty7IhUuTKWdIcmkOZl+XkLEkiIHBiTWoRRmbx8YTOPh/10c3TIsPx/zoG8v7bY6LPLDg+x+3Zm3tUDVY8lBmUFh58AfajBtlnFjU6iQFfRT/gKwwsp7J4EeSo4FBM+fwGOstlcsqFutSmftspzvcnDqwklGAJgmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=monom.org; dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b=VjldReTT; arc=none smtp.client-ip=49.12.199.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monom.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b="VjldReTT"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 73D8EDAE26;
	Tue,  6 Aug 2024 14:07:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
	t=1722946061; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=01SA/ETFeIEmF8ZNMro6rqmj4KMi2qeg7vDPqXd61VM=;
	b=VjldReTTsvbzIN95Vq7AR8slamM5p2g4sQfg3Dcmn8w5s6JxmyoSZxLf9FagVrJwLPYqyR
	n1OHyeA2juHr4ozqwNPUdJRdoRwAGfB1B9msvQ8lm+P2mNG/b56199hUA2PR2iRRRqgqiG
	bdY3ZIf8J2Kdz0zSwrIg00V18ZVksTg7QIfvwhyZUqvUGOvFDn7UpK9xZCmUYmNrkY4jjO
	sIWS2vGZ201IrldvsmGqfNRLXzwgL0crclR2FvFoY8btS3HkswCqYGRsPtoxfEGmIDz+2L
	EgFZkXoREXIU5gtJU/v+9xNkEEMJ1rbJLUh4qtWmp2uMkS9ZwXLguWeFBIF5QA==
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 06 Aug 2024 14:06:46 +0200
Subject: [PATCH v3 14/15] lib/group_cpus.c: honor housekeeping config when
 grouping CPUs
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240806-isolcpus-io-queues-v3-14-da0eecfeaf8b@suse.de>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
In-Reply-To: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Sagi Grimberg <sagi@grimberg.me>, Thomas Gleixner <tglx@linutronix.de>, 
 Christoph Hellwig <hch@lst.de>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 John Garry <john.g.garry@oracle.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, 
 Kashyap Desai <kashyap.desai@broadcom.com>, 
 Sumit Saxena <sumit.saxena@broadcom.com>, 
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
 Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, 
 Jonathan Corbet <corbet@lwn.net>
Cc: Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, 
 Hannes Reinecke <hare@suse.de>, 
 Sridhar Balaraman <sbalaraman@parallelwireless.com>, 
 "brookxu.cn" <brookxu.cn@gmail.com>, Ming Lei <ming.lei@redhat.com>, 
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
 virtualization@lists.linux.dev, megaraidlinux.pdl@broadcom.com, 
 mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, 
 storagedev@microchip.com, linux-doc@vger.kernel.org, 
 Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.14.0
X-Last-TLS-Session-Version: TLSv1.3

group_cpus_evenly distributes all present CPUs into groups. This ignores
the isolcpus configuration and assigns isolated CPUs into the groups.

Make group_cpus_evenly aware of isolcpus configuration and use the
housekeeping CPU mask as base for distributing the available CPUs into
groups.

Fixes: 11ea68f553e2 ("genirq, sched/isolation: Isolate from handling managed interrupts")
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 lib/group_cpus.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 73 insertions(+), 2 deletions(-)

diff --git a/lib/group_cpus.c b/lib/group_cpus.c
index ee272c4cefcc..713c9fdd774a 100644
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
@@ -344,7 +345,7 @@ static int __group_cpus_evenly(unsigned int startgrp, unsigned int numgrps,
  * We guarantee in the resulted grouping that all CPUs are covered, and
  * no same CPU is assigned to multiple groups
  */
-struct cpumask *group_cpus_evenly(unsigned int numgrps)
+static struct cpumask *group_possible_cpus_evenly(unsigned int numgrps)
 {
 	unsigned int curgrp = 0, nr_present = 0, nr_others = 0;
 	cpumask_var_t *node_to_cpumask;
@@ -423,6 +424,76 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps)
 	}
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
+static struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
+					      const struct cpumask *cpu_mask)
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
+struct cpumask *group_cpus_evenly(unsigned int numgrps)
+{
+	const struct cpumask *hk_mask;
+
+	hk_mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+	if (!cpumask_empty(hk_mask))
+		return group_mask_cpus_evenly(numgrps, hk_mask);
+
+	return group_possible_cpus_evenly(numgrps);
+}
 #else /* CONFIG_SMP */
 struct cpumask *group_cpus_evenly(unsigned int numgrps)
 {

-- 
2.46.0

