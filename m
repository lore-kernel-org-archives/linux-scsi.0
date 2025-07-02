Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8B030B9A2;
	Wed,  2 Jul 2025 16:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751474064; cv=none; b=caPcreBHYsLBWYuTT40sFbECQjeFiXcOJB51/k0OgOKXN58kql3yTatkyyb5GCmRArTn5OEw53o+KN8mKZT3oEOYnUidoev27bsgm4TNNEcy21hEhdTBsSLpc2hNsMj3jKF5g1FI0giQsJexNpdzYNy95sQ3P2TuNdC2r+Nwpho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751474064; c=relaxed/simple;
	bh=pWxK3dXtb7yt/SLdpUa2c56b5nWqf/VUS4szDCMoRQM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NN3oyYal06FEU9Brn1lHx59rkdFlsAiI3gXnWGymuswzl3XR9uDiPgQI5/IAcV7pfT0Y1Sq9QMCXvCF6vRyY1XGh1Q9/ENr/Syrc+OdBj9nWT3gkpAMgmAMOZTF5XERLAy2yxOVOAV0XS/PMSXJEuVG89tonHM3G+ibToUSD4DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FyvSjLuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FyvSjLuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E3AC4CEE7;
	Wed,  2 Jul 2025 16:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751474063;
	bh=pWxK3dXtb7yt/SLdpUa2c56b5nWqf/VUS4szDCMoRQM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FyvSjLukQx1wRtaMLSqyLSxFSVirXVNQayunh+NAHb3GRlNHYHp/KIJT2skiVzBl4
	 9PnLDERQWm9RRe+hotegeoenru+U+K3vXHjPRdQJm4tKthb1KnJYu8BBY+DCB5+yIH
	 s9pvAY8wrRQJRMocif/F1IJb54djJ+bvliEvMI/7J7tC2bJSeK1g3+L8n1A4NK12r7
	 aWIoidN4yRwkIaYzuqL/lvTwTDHzRwHZM2yCdN4LOxJYlnuKvuqgQr5Tw6naOBkwD4
	 X7NJ43KX8aXGYxLihRHLAqyUwvWaSL6EkTkrTOWjG5MGPfHgrITJYCcQSGfOqmntyt
	 C6zduiiY97TkA==
From: Daniel Wagner <wagi@kernel.org>
Date: Wed, 02 Jul 2025 18:33:57 +0200
Subject: [PATCH v7 07/10] isolation: Introduce io_queue isolcpus type
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250702-isolcpus-io-queues-v7-7-557aa7eacce4@kernel.org>
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

Multiqueue drivers spread I/O queues across all CPUs for optimal
performance. However, these drivers are not aware of CPU isolation
requirements and will distribute queues without considering the isolcpus
configuration.

Introduce a new isolcpus mask that allows users to define which CPUs
should have I/O queues assigned. This is similar to managed_irq, but
intended for drivers that do not use the managed IRQ infrastructure

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 include/linux/sched/isolation.h | 1 +
 kernel/sched/isolation.c        | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index d8501f4709b583b8a1c91574446382f093bccdb1..6b6ae9c5b2f61a93c649a98ea27482b932627fca 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -9,6 +9,7 @@
 enum hk_type {
 	HK_TYPE_DOMAIN,
 	HK_TYPE_MANAGED_IRQ,
+	HK_TYPE_IO_QUEUE,
 	HK_TYPE_KERNEL_NOISE,
 	HK_TYPE_MAX,
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 93b038d48900a304a29ecc0c8aa8b7d419ea1397..c8cb0cf2b15a11524be73826f38bb2a0709c449c 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -11,6 +11,7 @@
 enum hk_flags {
 	HK_FLAG_DOMAIN		= BIT(HK_TYPE_DOMAIN),
 	HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
+	HK_FLAG_IO_QUEUE	= BIT(HK_TYPE_IO_QUEUE),
 	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
 };
 
@@ -224,6 +225,12 @@ static int __init housekeeping_isolcpus_setup(char *str)
 			continue;
 		}
 
+		if (!strncmp(str, "io_queue,", 9)) {
+			str += 9;
+			flags |= HK_FLAG_IO_QUEUE;
+			continue;
+		}
+
 		/*
 		 * Skip unknown sub-parameter and validate that it is not
 		 * containing an invalid character.

-- 
2.50.0

