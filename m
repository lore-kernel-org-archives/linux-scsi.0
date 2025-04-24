Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A151729292A;
	Thu, 24 Apr 2025 18:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745518803; cv=none; b=C2VJyyxMaZYn6joG7gVbH0vJIeoGCsKN4AQ7yEw3sbo8/vvJCpSsXV7qk8DfryUrI8SXM6M4Am175f0Ym7UVl/TwLXIju2+9z6Nf9A4RhPHNWNUkohz2Sxjq1B5FcPZkR6vRNXgtuGdCerchH3YPd/tdjXU6xyhFbR2a/C/WavQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745518803; c=relaxed/simple;
	bh=ESLdMXYBM3B8MU09r7uQESEbFY24U9of5fSwsUyPBL4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mQEH25SHA4Ko2ezF44zEA3w3KMkSjJ9nqYjFzmGqGx8gwQiMwPJhc+VM7sbUVQj6UsJdD8JZNkehu/+fZce9hdt2XBv2OAkHUodoBziCEoXRzdm901p7MNuOShKhO8Q5eMyY1K3pAUPbc2iey4lAsB2CY7H3yuROZKr2xUfv8w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WSddQFb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WSddQFb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4049C4CEEE;
	Thu, 24 Apr 2025 18:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745518803;
	bh=ESLdMXYBM3B8MU09r7uQESEbFY24U9of5fSwsUyPBL4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=WSddQFb9HoKtNj6oN8xQVX7nVnG+gaRSYoD7m8LEVY3dlkMKfMZkSXpjhcca8ycRg
	 03cQHbU7111SE9ATw/9KS29owS6bvX/iWpOcrwwWOwbLO6sJN2RV9Ja+iPw9cVgijj
	 UeMPYH1J7Oon7hLiTMvqbiTeF/tBqbjvz4gibIgBqfPP7qtjteQMbIMFmBG5ZmQycU
	 xf9bZDpIJ4yu8iQ/2OTfWPk/OK0m0kdItX+XqhGlOYRZKh8ycg8JYZTUvUVZL78lVN
	 Yn24hf+C8wGB7Y2Z5CRVBOgTiqpLEzmakSCboCh7qsT2KF2l73scWgmAEUQWO+WVS4
	 BY+yOrg3h2f+Q==
From: Daniel Wagner <wagi@kernel.org>
Date: Thu, 24 Apr 2025 20:19:45 +0200
Subject: [PATCH v6 6/9] isolation: introduce io_queue isolcpus type
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250424-isolcpus-io-queues-v6-6-9a53a870ca1f@kernel.org>
References: <20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org>
In-Reply-To: <20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
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

Multiqueue drivers spreading IO queues on all CPUs for optimal
performance. The drivers are not aware of the CPU isolated requirement
and will spread all queues ignoring the isolcpus configuration.

Introduce a new isolcpus mask which allows the user to define on which
CPUs IO queues should be placed. This is similar to the managed_irq but
for drivers which do not use the managed IRQ infrastructure.

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
index 81bc8b329ef17cd3a3f5ae0a20ca02af3a1a69bc..687b11f900e31ab656e25cae263f15f6d8f46a9a 100644
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
2.49.0

