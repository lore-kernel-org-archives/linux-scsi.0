Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79762FC3D4;
	Wed,  2 Jul 2025 16:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751474057; cv=none; b=Clc4XOOl+dBNGYW7Vy4AE7f7zR96EBh5oE4ft0PIg5CVyuCfMQnT5Zs9FMz3wsG65tmh2E8vhbvQK65H5Cjb6aQMhXHEMXRIOiJq7r0Adm/909PT8btH+Ayn/0UR+lPZKu+Z2Rv/2M/GR+yejX/1FY647j3CntNLRsRpRj+dMAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751474057; c=relaxed/simple;
	bh=no7srF5DCCtVCNnfmr2KY5yHBkIVauk7JN1MWUBHxlM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QLVRdgpfCNYqPIaK6aISW+bbTOP3b5u78uxLjBGurMCLgO4xPyBBFguULLsJvHy+8myaaNE7TBVgZ6y62K0bjJTAcU66Sb6dGuQ+eJI8wAaJZNLi8vsawrkG+9ymzTs/0OlIeQT0gJwIUvBGjl3GeS/k51AbJdRwAtuVLEHdBEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LPtcZJnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LPtcZJnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C98C4CEEF;
	Wed,  2 Jul 2025 16:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751474055;
	bh=no7srF5DCCtVCNnfmr2KY5yHBkIVauk7JN1MWUBHxlM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LPtcZJnSpALosEABqfsTSY/FPfU43+97B1C8/qDFNnacZLWqAbIrrpE35wSR94mvf
	 6IURwIieYLaPD1MBRL0cpYtlTybxxF0Z5AABDLk4IS8Iq5hUlPzCsMRoLqeAANNRUv
	 6fxaJidD0Y+frVr0oiLeD+hltwnpOouDsiYqYnsVJaLGJT9j7MHcygJOuTWntmdTlV
	 CGXcKui3j3nEPT3htws9T9GM0BvOgTdg9Zli50040yjk/losmiJtlQf1+fMl887Qx5
	 HZWPxBco+DPW+LARTpJkfvt5cL6nPQJAGvtl2b0qQ0vi+N7qjIbzMU75Eifs/TGSgx
	 ILE/uHs/YyjXA==
From: Daniel Wagner <wagi@kernel.org>
Date: Wed, 02 Jul 2025 18:33:54 +0200
Subject: [PATCH v7 04/10] nvme-pci: use block layer helpers to constrain
 queue affinity
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250702-isolcpus-io-queues-v7-4-557aa7eacce4@kernel.org>
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

Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
constraints provided by the block layer. This allows the NVMe driver
to avoid assigning interrupts to CPUs that the block layer has excluded
(e.g., isolated CPUs).

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index a509dc1f1d1400bc0de6d2f9424c126d9b966751..5293d5a3e5ee19427bec834741258be134bdc2c9 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2589,6 +2589,7 @@ static int nvme_setup_irqs(struct nvme_dev *dev, unsigned int nr_io_queues)
 		.pre_vectors	= 1,
 		.calc_sets	= nvme_calc_irq_sets,
 		.priv		= dev,
+		.mask		= blk_mq_possible_queue_affinity(),
 	};
 	unsigned int irq_queues, poll_queues;
 	unsigned int flags = PCI_IRQ_ALL_TYPES | PCI_IRQ_AFFINITY;

-- 
2.50.0

