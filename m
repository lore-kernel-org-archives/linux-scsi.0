Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318DC2918DC;
	Thu, 24 Apr 2025 18:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745518801; cv=none; b=YgiyvgBQ9LW2oPION7GrLOmLMKj/ICsZFREDpuwaVHDmOx40knx4R538m2MVLsi6EQYV91C/G1mFwfN+9soprStaBsIQMnDNNPCXRYgk1zhn1cmmNXllyqknQB7pOv3l5LibpAnqs2kFbsW0LzYOLG0LBY5mTku7dFn+n01qZ1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745518801; c=relaxed/simple;
	bh=zDd5OXrJ5hx2XvXP+gWPa71BE69w4axt6D3acfXYsCI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Zjq0xtSmDCVGp82hqshsAXMZOYuBeTzcUJTcbP8Q61KXjlbALgfSUVPvpU3Fpm30vKkj92iQTY8oA/2x4p9kxhtdeHd1w/xSHW1LXAcwKdpjeotFnf7QRYiVUcdsGUw3ajTxIvTs9oGfMfg/8MYwi4w0V5iNgTe6yDDuuoFbdzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eNswffIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eNswffIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109FCC4CEEA;
	Thu, 24 Apr 2025 18:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745518800;
	bh=zDd5OXrJ5hx2XvXP+gWPa71BE69w4axt6D3acfXYsCI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=eNswffIyajw2Ybh0hWiGT1YzdiI2E03jK+EOVl3DnNYwUvuztcZDvqljcj8DICUci
	 lVTZWlT7b4rUBD6/kbjqUAgmZ3q0ZwO5nPh7NtfVlM2mF3z/sCunFrscSGI9HOOcvJ
	 Sh3lTfx9PG7HPLdKTjqFUWbwtOqpnGqRoMn1TITpasdvz3tjJqwGCGCGZgmoeiaMGF
	 PJrbbkGBgb9OWWHasFMg9zxkL+WekL3HOBr54ioJLF3WnzjnssFl3oY/WwP4blQM/L
	 z9QKxV6OhJ51Uzmul4Flnb31rGAlY2U18HqLUg0nuErMc2dxofaEBGrew5ZtzPBQd5
	 xWKmNfcWOpw9A==
From: Daniel Wagner <wagi@kernel.org>
Date: Thu, 24 Apr 2025 20:19:44 +0200
Subject: [PATCH v6 5/9] virtio: blk/scsi: use block layer helpers to
 calculate num of queues
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250424-isolcpus-io-queues-v6-5-9a53a870ca1f@kernel.org>
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
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 drivers/block/virtio_blk.c | 5 ++---
 drivers/scsi/virtio_scsi.c | 1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 7cffea01d868c6dcfe6734d3c89c1709fec07956..975036e8ddef5d622bab623843826ac26a0aa63d 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -976,9 +976,8 @@ static int init_vq(struct virtio_blk *vblk)
 		return -EINVAL;
 	}
 
-	num_vqs = min_t(unsigned int,
-			min_not_zero(num_request_queues, nr_cpu_ids),
-			num_vqs);
+	num_vqs = blk_mq_num_possible_queues(
+			min_not_zero(num_request_queues, num_vqs));
 
 	num_poll_vqs = min_t(unsigned int, poll_queues, num_vqs - 1);
 
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 21ce3e9401929cd273fde08b0944e8b47e1e66cc..96a69edddbe5555574fc8fed1ba7c82a99df4472 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -919,6 +919,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	/* We need to know how many queues before we allocate. */
 	num_queues = virtscsi_config_get(vdev, num_queues) ? : 1;
 	num_queues = min_t(unsigned int, nr_cpu_ids, num_queues);
+	num_queues = blk_mq_num_possible_queues(num_queues);
 
 	num_targets = virtscsi_config_get(vdev, max_target) + 1;
 

-- 
2.49.0

