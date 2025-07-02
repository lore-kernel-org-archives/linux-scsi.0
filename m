Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508C4309A56;
	Wed,  2 Jul 2025 16:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751474061; cv=none; b=ngEoWWBF+ZJdfVQwumyc+ouYQQu+H0EDWgaI5P3+cx/rh7pkCFoHN29IjuwQPudPh/AaKm0nOtSHTaAGX9MfY4jnCF9OZn3AnrryS5qlWVVt/gW+T1hBFoWD0sJxq2rxClqYXYbNUXXZm8JSIDBGWZHDc8fYr8+hfml2aGlX2x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751474061; c=relaxed/simple;
	bh=Myx+PZoZUcbDbjehTnwx+RA9vtGiiCFPLDBRtnu3gqg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=C+uTPBwf68Xna7G3Qwv6+Qa98+4GJuBAhFBeb5cv6cjY1n0IHTY38B7TWRebnPBe7dmoF4Dgl+GgMtc89C64r1pN+wDZlRQRTo5ExdhcsdCuWCCWCE13emWwvw5zySjd3ShuNBUEjgzNAlXYzXJxGQy+lsMaGSfOEGfuCg7Qss8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V934Qn+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V934Qn+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66086C4CEEF;
	Wed,  2 Jul 2025 16:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751474061;
	bh=Myx+PZoZUcbDbjehTnwx+RA9vtGiiCFPLDBRtnu3gqg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=V934Qn+90uC6vxOj2/uy0FXbhoVq2ub3PHObXMD0xrE/uiGT4LMsYYkzscg40r2BD
	 EOYnOft07Xmw7cCRbn63zkqqrSaxC/KSPv/W+B72P1jnRgOIRCS1pbYHWw44iQkrE3
	 fLcwLdiQxqNxRSsWHb/bqf6ZOeHexDmxG73j/CGBzgcH8DFxMR41ill6rntyx5qM+/
	 r2EfnwJYklWSlxriMJor4Dq1kaQn2Ox69ATZ0KQC2ZzZFmJxSaINLdGQl0gpDrNsY+
	 I5wU219HubMS5b9mn4GtacaaC0HOSEOpf9a9NYYiwvg9/Wng+p0IdFG6LV+CLmu+C9
	 SmwDx5om9SeEA==
From: Daniel Wagner <wagi@kernel.org>
Date: Wed, 02 Jul 2025 18:33:56 +0200
Subject: [PATCH v7 06/10] virtio: blk/scsi: use block layer helpers to
 constrain queue affinity
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250702-isolcpus-io-queues-v7-6-557aa7eacce4@kernel.org>
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
constraints provided by the block layer. This allows the virtio drivers
to avoid assigning interrupts to CPUs that the block layer has excluded
(e.g., isolated CPUs).

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
2.50.0

