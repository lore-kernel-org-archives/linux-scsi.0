Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488352F7AAF;
	Fri,  5 Sep 2025 14:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757084399; cv=none; b=iCtL6laottQFzyN5VhiFJlecyHhUSpzTdPU2lKLv5OTCTKXH0XUo1x0c2L+73rg3Q8PYkjlUOaoDbxUT5BdJR95ududgbkaurrKjiFewaY1Ww7Eruayz6c6DPKLpmNq1ldGzSlqSIB00pW6EHG2FWODI5fNKDyFWErjQe4/InN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757084399; c=relaxed/simple;
	bh=Ih/lnoYEjRwJ9kf3CN+fftbLyJn7lxWHAcEr6PF1bbc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=U5PKFCrBpS31ATrm+JUtL23e8WvlX2b6VKarqXMZ7p+IBuLuC4c1YgbX9PwxLzykFGI/71kznn5g/OCz39g+07sGpGqmHXgSs3q73MSzjKtho9nfK/Z8pBitze0q1Jw+i8lvZ7vA1o0hQgikG11HSGEu/40gMGwJ4MdpRe0uxb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFljBf1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFljBf1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA92C4CEF7;
	Fri,  5 Sep 2025 14:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757084399;
	bh=Ih/lnoYEjRwJ9kf3CN+fftbLyJn7lxWHAcEr6PF1bbc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jFljBf1upPIqY3l+qKij+ARCKubM1zlNQayovr6PLcObyykM2E8VOF1wWT1EkSAk1
	 mUseo4DajSHooJsWAwhe2rimQlKW1fIJjLOjQd15Ct0w8hRsFvvICWwKD4J5s/Y1a4
	 D4+d95SHkiQoB6fzvUfdFMVDq6bXyGtUFw2QNH1Dc/46ara9OACVHwkXsbMdOswWMU
	 Sj3qQj4WaLjWKjfNdPjosCf6dpFuxjp0W9l6TumS0F1OOYxK4m218TlSR1Vr/BKIdy
	 OZ0spbSvJ3TpUwWlPucXweBvVH8xgamk1Kaf4bzzAJ+JSe37n8MtnnhaJ0mpP1C/vK
	 ssoKcX0IVVwuA==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 05 Sep 2025 16:59:48 +0200
Subject: [PATCH v8 02/12] lib/group_cpus: remove dead !SMP code
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250905-isolcpus-io-queues-v8-2-885984c5daca@kernel.org>
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

The support for the !SMP configuration has been removed from the core by
commit cac5cefbade9 ("sched/smp: Make SMP unconditional").

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 lib/group_cpus.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/lib/group_cpus.c b/lib/group_cpus.c
index 6d08ac05f371bf880571507d935d9eb501616a84..f254b232522d44c141cdc4e44e2c99a4148c08d6 100644
--- a/lib/group_cpus.c
+++ b/lib/group_cpus.c
@@ -9,8 +9,6 @@
 #include <linux/sort.h>
 #include <linux/group_cpus.h>
 
-#ifdef CONFIG_SMP
-
 static void grp_spread_init_one(struct cpumask *irqmsk, struct cpumask *nmsk,
 				unsigned int cpus_per_grp)
 {
@@ -425,22 +423,4 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
 	*nummasks = min(nr_present + nr_others, numgrps);
 	return masks;
 }
-#else /* CONFIG_SMP */
-struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
-{
-	struct cpumask *masks;
-
-	if (numgrps == 0)
-		return NULL;
-
-	masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
-	if (!masks)
-		return NULL;
-
-	/* assign all CPUs(cpu 0) to the 1st group only */
-	cpumask_copy(&masks[0], cpu_possible_mask);
-	*nummasks = 1;
-	return masks;
-}
-#endif /* CONFIG_SMP */
 EXPORT_SYMBOL_GPL(group_cpus_evenly);

-- 
2.51.0

