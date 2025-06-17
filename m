Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C451E2E3AE4;
	Tue, 17 Jun 2025 13:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167818; cv=none; b=IazezUMDINt8lMjeJn3fEO11JY1C/zPe+4ckJFiQcIv+RiDgpvhOiEiFnWagiadWBgOgqGq3W7kmtWkGbPuiqfDZrUzTtIZ2b6BQcDDal1m+o0YVF822C6EeYvwzT/xqP+huUo4iUFP4VmgbAaUM2K+AEG4m6rlF0w6UAE79AfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167818; c=relaxed/simple;
	bh=Wb0VVks1in8/wgvZy69kc6dxGdTcBSbAW1IQk4SRnXw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qaL0JY+oS3NuLjDodLH7bPoaPyoYBTnPwGfgVYAVqAWtrgCzbb5LPfFoZhrmpDv3o95OvQWjAyi3uDWZyIE7exdr1RZH3VurHRb37dWdqfwgyHL5FqnSYhHt+HgzDyDV7Ntd2tyc3uEJD4tXWQ0bqAh5roNAmmB1mVJPNqkFBPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hBzVWER+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hBzVWER+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5C4C4CEF1;
	Tue, 17 Jun 2025 13:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750167818;
	bh=Wb0VVks1in8/wgvZy69kc6dxGdTcBSbAW1IQk4SRnXw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=hBzVWER+QS2jJkuriCQIa4LyuNFDsINLSqZCoogErBxBKw4JN1mmn4iu72E0jirch
	 PPnW/Y1vgakKthwwc4M7/IgTA11CG1K9WXqrxvI7UBiPUmpUZeXZasTZMVjKqF9rZN
	 wB9wN+xmKxNTUjLXYBrKzNSqtwe+LyJgmSEErCtTTaIy73h77pqb03mf1b47bI6KRl
	 rFpYCVyw0NRmytgwI+oB2GyenYLXZclZ13elJZVH4WEwZmfT7sAjBBWpB1fXvCfSK1
	 UjCnqQNpzzbSbhTlnroe9JaSpHIxhBaQ58/M9I8M1VS/vXpNAW0LIXqPWHhPXueZtq
	 N41rxh/7TPJQQ==
From: Daniel Wagner <wagi@kernel.org>
Date: Tue, 17 Jun 2025 15:43:25 +0200
Subject: [PATCH 3/5] nvme-pci: use block layer helpers to calculate num of
 queues
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250617-isolcpus-queue-counters-v1-3-13923686b54b@kernel.org>
References: <20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org>
In-Reply-To: <20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, 
 "Michael S. Tsirkin" <mst@redhat.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
 Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 storagedev@microchip.com, virtualization@lists.linux.dev, 
 GR-QLogic-Storage-Upstream@marvell.com, Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

The calculation of the upper limit for queues does not depend solely on
the number of possible CPUs; for example, the isolcpus kernel
command-line option must also be considered.

To account for this, the block layer provides a helper function to
retrieve the maximum number of queues. Use it to set an appropriate
upper queue number limit.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 drivers/nvme/host/pci.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 8ff12e415cb5d1529d760b33f3e0cf3b8d1555f1..f134bf4f41b2581e4809e618250de7985b5c9701 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -97,7 +97,7 @@ static int io_queue_count_set(const char *val, const struct kernel_param *kp)
 	int ret;
 
 	ret = kstrtouint(val, 10, &n);
-	if (ret != 0 || n > num_possible_cpus())
+	if (ret != 0 || n > blk_mq_num_possible_queues(0))
 		return -EINVAL;
 	return param_set_uint(val, kp);
 }
@@ -2520,7 +2520,8 @@ static unsigned int nvme_max_io_queues(struct nvme_dev *dev)
 	 */
 	if (dev->ctrl.quirks & NVME_QUIRK_SHARED_TAGS)
 		return 1;
-	return num_possible_cpus() + dev->nr_write_queues + dev->nr_poll_queues;
+	return blk_mq_num_possible_queues(0) + dev->nr_write_queues +
+		dev->nr_poll_queues;
 }
 
 static int nvme_setup_io_queues(struct nvme_dev *dev)

-- 
2.49.0

