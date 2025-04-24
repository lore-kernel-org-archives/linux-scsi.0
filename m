Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4B7291145;
	Thu, 24 Apr 2025 18:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745518794; cv=none; b=EnbDDqnt2ZXBYMq5FAk3FjZCNRmLch1Ov2e2x731V1gyE/YDFHdnCo0lK89/0KZ4HKqTRN9gt+AyX1NjxXH1aA1fODhOq/SRfssXz389KMbA0IcQsRkcGbGNWpQi5B7iyMVmx5vAqosHfSGkvXEqMqsRU5noA1bAZ7stPTFocBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745518794; c=relaxed/simple;
	bh=ok6xPrZqMzj+pYA0b2w0oFvw0PB4VPK6RSYzfiVkDs4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=orlzLf7X/4PEcgSzehid4feRrlf+haGnKK9IrbqRvmPwlyPG+IL5oK6C7q3NDYbdqMDDBin0SeGKA4AFKrOWaWaxJIW1WfV2+JJq+r8TGx6+KJ+lDWpP3lyOWPO1uB9sXkeLjEvFMkOVqrbYCJWNLeJfJ8BNpc19T6v5RVMaN4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uBOlEZKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uBOlEZKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF269C4CEF0;
	Thu, 24 Apr 2025 18:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745518794;
	bh=ok6xPrZqMzj+pYA0b2w0oFvw0PB4VPK6RSYzfiVkDs4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=uBOlEZKBSib8YU5vBRS+rzjM30Tzh2DoF8SmxfVGZ40u4kG+z1iBuJ1YYa5TuzJ+E
	 K29lL3XrcN9mi/wlaQCz2p5XcvI0AEk4rqYIQj4Q0+1gfutkmTTAgFZfI7DDyXKOE2
	 oUpz/xbUodeoYK7oRUr7kcA4v2y3MJUwkNqPVA3TVDTSXki9wFUkhVN+BW6cIx9kqw
	 eLdDWGpof5wsS9ErUeSrom/DhdQ1S/5odHIVzYeceWhcEWbRs/kDb0u9h2mBL76cQA
	 WEZ4myBfmfOPbeVzlqzXY6DutFgxxU51roTLOh/LHFjsBcVgcnIhEf8lTnPIFSDCva
	 cMv9hQM3yn1tw==
From: Daniel Wagner <wagi@kernel.org>
Date: Thu, 24 Apr 2025 20:19:42 +0200
Subject: [PATCH v6 3/9] nvme-pci: use block layer helpers to calculate num
 of queues
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250424-isolcpus-io-queues-v6-3-9a53a870ca1f@kernel.org>
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

Multiqueue devices should only allocate queues for the housekeeping CPUs
when isolcpus=io_queue is set. This avoids that the isolated CPUs get
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
index b178d52eac1b7f7286e217226b9b3686d07b7b6c..2b1aa6833a12a5ecf7b293461a115026f97ea94c 100644
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
@@ -2448,7 +2448,8 @@ static unsigned int nvme_max_io_queues(struct nvme_dev *dev)
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

