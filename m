Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEB3302160;
	Fri,  5 Sep 2025 15:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757084416; cv=none; b=GBxJi5G+qik0x6cL8Xqel8ZNvvEM2ak2WnxvUV9TQeLRIZyM2inRxyiq7G+6fWHCGsp7ko1HlZZwRxWdDsvlZRomftPjFJ5pGdXok21zZHz4bJk5UnPSWhApiMkvw3KxvRCXpf6uwdSrUGL0fsGQfdojBC26h2MtI/beTB/PnF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757084416; c=relaxed/simple;
	bh=xQ0coLV1rItUOolPBiizTee/coH/W0d4cwoc/bXSQTQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=S3FPyWgEWOONbWMnFNX5Q4VvXfUfWxekMbMQ2reKmZdjGd3xFTvJDg8LISAD2vNw/5LMb9fAYBOPekxpbjzMT00w91kkOX6DqXVZoo5xm6G6vHvW20CCMFDs3lHrrVXcRuKQxO2LrtvTnr0nD0lvIs4sV7JWpvUNYmu2u7xi7Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gnDRCPLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gnDRCPLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5288C4CEF1;
	Fri,  5 Sep 2025 15:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757084415;
	bh=xQ0coLV1rItUOolPBiizTee/coH/W0d4cwoc/bXSQTQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gnDRCPLfnelef8NHhTpOmzX7p/wXoMt7SPngNMbvXPu94iSoz9yUp1Ps1rlynyQO0
	 Djb/P2PdZwvidDz0nJA2K3jKkwrDo/KtevSizOYxzeGAGx5ZQPf2P60i3sgV10EFcf
	 OuCE28SBJ6LMYP8a6mUcF2JVMFXktpIBrWMvCBz9tWkaZJzCFypghf1uuq2T/jJAvs
	 Egdeen08e+nKE8RrrHIlrwJeamR+vvwr2VYq4R3p2vkV3WGI4H7+TPpNdqDU6/RkPk
	 bsnUuUJJSqLChW8lC8LCch076awqu459VELUHIuqZSfe8MORP4sP0mJl4fzGvnofhI
	 YegWFsnOwfGnA==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 05 Sep 2025 16:59:54 +0200
Subject: [PATCH v8 08/12] virtio: blk/scsi: use block layer helpers to
 constrain queue affinity
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250905-isolcpus-io-queues-v8-8-885984c5daca@kernel.org>
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
constraints provided by the block layer. This allows the virtio drivers
to avoid assigning interrupts to CPUs that the block layer has excluded
(e.g., isolated CPUs).

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 drivers/block/virtio_blk.c | 4 +++-
 drivers/scsi/virtio_scsi.c | 5 ++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index e649fa67bac16b4f0c6e8e8f0e6bec111897c355..41b06540c7fb22fd1d2708338c514947c4bdeefe 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -963,7 +963,9 @@ static int init_vq(struct virtio_blk *vblk)
 	unsigned short num_vqs;
 	unsigned short num_poll_vqs;
 	struct virtio_device *vdev = vblk->vdev;
-	struct irq_affinity desc = { 0, };
+	struct irq_affinity desc = {
+		.mask = blk_mq_possible_queue_affinity(),
+	};
 
 	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_MQ,
 				   struct virtio_blk_config, num_queues,
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 96a69edddbe5555574fc8fed1ba7c82a99df4472..67dfb265bf9e54adc68978ac8d93187e6629c330 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -842,7 +842,10 @@ static int virtscsi_init(struct virtio_device *vdev,
 	u32 num_vqs, num_poll_vqs, num_req_vqs;
 	struct virtqueue_info *vqs_info;
 	struct virtqueue **vqs;
-	struct irq_affinity desc = { .pre_vectors = 2 };
+	struct irq_affinity desc = {
+		.pre_vectors = 2,
+		.mask = blk_mq_possible_queue_affinity(),
+	};
 
 	num_req_vqs = vscsi->num_queues;
 	num_vqs = num_req_vqs + VIRTIO_SCSI_VQ_BASE;

-- 
2.51.0

