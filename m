Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D15213E88;
	Fri, 10 Jan 2025 16:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526418; cv=none; b=iVbPEPWt68CknT+2V6JlMJhWcP6uCCMrHqqGmYbfyzWMljZgSmThWXFoIQY3HdetZGI3oM3HBJ9mHNSCMs5M9wwdeCX9C3N6QhNVyRb9oyCjCRpKNUSEXU0tDFe3x5zkQiglCuO6qojUXcCF7iTwZpK04R5B6q54QBjSeBlruJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526418; c=relaxed/simple;
	bh=2WOikGN/ZqobQqHz6R5F6l81bCwlMDfxRu+pSaWFjzw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DpkQH2nmVBK6TFpAsnIRwxglEoxQybG49/wclUbuBJXVRJydJJdkBrz3roKGGaYMuVfdmiVt/CWNWyxZaD2qj8RxMctuQfk447eLhSgEHRmhMw+VKR7nxBefWgFoyw84ky/aLrlDEb7Ym+2RB1EZNNgHWUUXuCBKsidP3pTYdAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QwU9t/0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QwU9t/0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E13C4CED6;
	Fri, 10 Jan 2025 16:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736526418;
	bh=2WOikGN/ZqobQqHz6R5F6l81bCwlMDfxRu+pSaWFjzw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QwU9t/0nxb9qVso7q/8qOHCxbw3XJ06xXtDuidpB3Tg1BXgS0D3ZJxnFV/7hjC4rE
	 /lKP/IL569W8mJGxXaq4Em1yJTxk6mzSx3P7nvOhBIbrMy4Z/rd4sGpFAg5B40C2eY
	 IFPMxV0xAZVh3k0RY3YngN/+4EK87qSmY73dbheISoK63GL/klDISwivJ3F8WzkzYz
	 jABk+o6gHzGxMzPUNPP5hvjLzjvgmWAxKNoKmI/LjnVaYYLqf9mzwle86xrAUD1nVe
	 scBeTPVZYFajjLNU3yKHPTdxYExO+RzyqA4uqaE/uqtgf5WG34iW1ySVgh7m2MolVB
	 yDFj55MlmiRNw==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 10 Jan 2025 17:26:43 +0100
Subject: [PATCH v5 5/9] virtio: blk/scsi: use block layer helpers to
 calculate num of queues
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250110-isolcpus-io-queues-v5-5-0e4f118680b0@kernel.org>
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
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 drivers/block/virtio_blk.c | 5 ++---
 drivers/scsi/virtio_scsi.c | 1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 71a7ffeafb32ccd6329102d3166da7cbc8bc9539..c5b2ceebd645659d86299d07224d85bb7671a9a7 100644
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
index 60be1a0c61836ba643adcf9ad8d5b68563a86cb1..46ca0b82f57ce2211c7e2817dd40ee34e65bcbf9 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -919,6 +919,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	/* We need to know how many queues before we allocate. */
 	num_queues = virtscsi_config_get(vdev, num_queues) ? : 1;
 	num_queues = min_t(unsigned int, nr_cpu_ids, num_queues);
+	num_queues = blk_mq_num_possible_queues(num_queues);
 
 	num_targets = virtscsi_config_get(vdev, max_target) + 1;
 

-- 
2.47.1

