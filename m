Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0451A2135CF;
	Fri, 10 Jan 2025 16:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526414; cv=none; b=L4DkHjbyfqHhawN4JYdQ5TLOB3XhX8bsrYQO8YNU8SjJ2Tu98tKhz2B6ubfI3d8e23WYJr3yhdGsy1yGGDXYZQ8qZBDCpAdgGh1Y1VcfNZnlrRtPkhNoQzs1K0zrKJvNEYyll+q6KN0eqGKmxKUwJkafHjrDFfvg61kdjUWCI4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526414; c=relaxed/simple;
	bh=7KONgCPE9Ymk0Paeq6W03Cji817hrNEc4cLzoY7jtxk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GTl+bactlqnk6jaEE6FtgYTfmk9o7WW8ot6mApYNpZkRkMij+lS9mOzFrA8uBG4aX1cdAceVakssRb9CoUSYRPjm/jmbdJJQ627wX8tOE7lFpX3mUQRzl+KIu/fHQpwderaVo4ng8CWHHRiX/OKL1LJncxFSz2nCs8D1CZa/GIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SGoFF60h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SGoFF60h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B95DC4CEE3;
	Fri, 10 Jan 2025 16:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736526413;
	bh=7KONgCPE9Ymk0Paeq6W03Cji817hrNEc4cLzoY7jtxk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SGoFF60hidDrBhvkwkP8fKG8mLcaHrEmpWtnixxZbRQUiS0yRmkrcUIHLLaoui3FV
	 nECZr9rjjMWh4IqgtKgkMBe1c9PIdin5yS91ubVuSfXL3zgNLme4+EW+9ytOOi2CC9
	 dPEbEgjithMuJxvTEtj00f3fNmual//ZkRU9mITN5v9fNZw2ytIQ3JySeJygM+2YI/
	 qGSiu3DHHk2fbuoxJbm+05Mno1bHLVUCYEivSEuEElxAFXmZPwZ9fXKbjCUJglbso2
	 qWYj6SewkNywxo9CAOOMWTYPzD9mTcX+6YF8OPzX4x0EaG0pkOb5JIgWGR9C4hzKjt
	 Ea08Eym1qoH2g==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 10 Jan 2025 17:26:41 +0100
Subject: [PATCH v5 3/9] nvme-pci: use block layer helpers to calculate num
 of queues
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250110-isolcpus-io-queues-v5-3-0e4f118680b0@kernel.org>
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

Multiqueue devices should only allocate queues for the housekeeping CPUs
when isolcpus=managed_irq is set. This avoids that the isolated CPUs get
disturbed with OS workload.

Use helpers which calculates the correct number of queues which should
be used when isolcpus is used.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 drivers/nvme/host/pci.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 709328a67f915aede5c6bae956e1bdd5e6f3f1bc..4af22f09ed8474676edd118477344ed32236c497 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -81,7 +81,7 @@ static int io_queue_count_set(const char *val, const struct kernel_param *kp)
 	int ret;
 
 	ret = kstrtouint(val, 10, &n);
-	if (ret != 0 || n > num_possible_cpus())
+	if (ret != 0 || n > blk_mq_num_possible_queues(0))
 		return -EINVAL;
 	return param_set_uint(val, kp);
 }
@@ -2439,7 +2439,8 @@ static unsigned int nvme_max_io_queues(struct nvme_dev *dev)
 	 */
 	if (dev->ctrl.quirks & NVME_QUIRK_SHARED_TAGS)
 		return 1;
-	return num_possible_cpus() + dev->nr_write_queues + dev->nr_poll_queues;
+	return blk_mq_num_possible_queues(0) + dev->nr_write_queues +
+		dev->nr_poll_queues;
 }
 
 static int nvme_setup_io_queues(struct nvme_dev *dev)

-- 
2.47.1

