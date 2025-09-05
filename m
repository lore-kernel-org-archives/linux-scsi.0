Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CF9313294;
	Fri,  5 Sep 2025 15:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757084410; cv=none; b=EOgl94Ui6WcZmiK3sTlcvWYftSTKFJE+5Bz8zzdhuFdzCn8IXq8opt1N8rEyTL1zYwn07LKzNxJX5784Bvf/5UuwBZ3/L07lP0Qgn3Q6drJhTQ0aUlrLM5S+/9wSwiX7Vw1s3ZVMLuxotsPbhyr9uBGhapQjHH/BUWJqP5RGwrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757084410; c=relaxed/simple;
	bh=l0TS7kNWsBFisp5wVR6xD5H+1nN29rebF/xTWKzZjX4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oJqv9+mmhXKGBGqOT7dXub/NyQFfYbNqhva5jKj0T30LnnwSOENS0nmRX2P3rP5eTX8O7yKusWL9NgDpCM8Hs30BK0SCqK55lpa70hmplMinMRVoie21lnx28zcrM9BA9HE9pIByjxPXBs3ErJ5CWZ6ucJ+un+VWLOS569zGAzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lkgBXAXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lkgBXAXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD56C4CEF4;
	Fri,  5 Sep 2025 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757084409;
	bh=l0TS7kNWsBFisp5wVR6xD5H+1nN29rebF/xTWKzZjX4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=lkgBXAXocImjt2eAn/AdIFpsG0uxz1yt+IOnL9oyY772BW7AHt92SMDrVHMVSJ4ZS
	 7WQ0X514Pqa510sT9ogC5CURj2FpMhoYL6DY7hLT0c08LMm5oRKRt6LmNcPagcyeuX
	 dNrTUYCsorwjNGfx0zKnZyLJft9d0BqcqGfsVts++oB4OuE23Y4p0Czidbc2Xbuq8g
	 YhsaIfbNsb8k+z+WfpYrX+/g4XsjcBHhtXUUDI3klMSZ3FesNnvb/GrfuysVMfBA68
	 cSvRo0y6DXMlI19yauHccXucwSGqcyOSz5KfmDAVYxquFy3wb+1EqNi7Ldtl5ONNgK
	 1t4YkfcMT97sg==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 05 Sep 2025 16:59:52 +0200
Subject: [PATCH v8 06/12] nvme-pci: use block layer helpers to constrain
 queue affinity
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250905-isolcpus-io-queues-v8-6-885984c5daca@kernel.org>
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

Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
constraints provided by the block layer. This allows the NVMe driver
to avoid assigning interrupts to CPUs that the block layer has excluded
(e.g., isolated CPUs).

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 2c6d9506b172509fb35716eba456c375f52f5b86..1d9c13aeddb12fa39eef68b7288d1f13eb98a0d7 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2604,6 +2604,7 @@ static int nvme_setup_irqs(struct nvme_dev *dev, unsigned int nr_io_queues)
 		.pre_vectors	= 1,
 		.calc_sets	= nvme_calc_irq_sets,
 		.priv		= dev,
+		.mask		= blk_mq_possible_queue_affinity(),
 	};
 	unsigned int irq_queues, poll_queues;
 	unsigned int flags = PCI_IRQ_ALL_TYPES | PCI_IRQ_AFFINITY;

-- 
2.51.0

