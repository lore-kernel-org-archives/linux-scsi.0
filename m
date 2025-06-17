Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49892E888F;
	Tue, 17 Jun 2025 13:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167828; cv=none; b=qq8EQCiMa/G/g9xS3Llqyp8DMK7BIikOIUnMxusp330BIgJxwhYQpxvjY5j/m6GaJidvQZ4nxlrKDl+xIygtGp/tyl7jDCRJEuW9c+Xl+LuCkK1ImN4P0/PzjtSUFXCdkcztFwgvByStixFtOQOEGglDmG1qKlciIVvewxe/2bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167828; c=relaxed/simple;
	bh=3edJmKoyUSjMTYlt2oNOEj/NOQQ/uX8bqeMbrf4iMm8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ebvZ06CTT6mtJZqiplYvAuyrf+yl1eYnmdqkzRpppMtsO//6YjIJ/xbCM2zBjaxB4BV3ipkU92Bwpd8a8uteJK4qLY5LKSWegRpLd+uCV6qRsxJUZ4P34H6rcKO6bJqDjEkUOiuiRJvyDxdAAuD/iZrWD3189Wcr13UikpBBMfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNYoPSYB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNYoPSYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D687C4CEE3;
	Tue, 17 Jun 2025 13:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750167828;
	bh=3edJmKoyUSjMTYlt2oNOEj/NOQQ/uX8bqeMbrf4iMm8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=MNYoPSYBKQ2E60FbE8av7UdKTeFZsKp3S1eSfPUOuJJhZWJ4nSpsIQXDbIrEEGshZ
	 iHANFRqB4+ogYxSrGyADEDNwXR5u9jn2P6HBuTrlP2slsKz9o9Y39tMu8j3JUETGla
	 83P1lNhc+taMFmbuSnKF2vIa4IKya0LP157KDLSkK0r3Q2gUfbztIrS8O/MKw3fRIX
	 gybwsEBPDiv3IDfOsLObyxSmGNQUIywBltt2JdllGdeuTEH4GMk/v1HYtlRutH1kQM
	 gpX41cp5n6zrWZjqstS3pKlN0WuFir/IqypxXI9urvSnxaGOh2xDOa1rhL2FCsp6t9
	 tYOyyzhTcmPsw==
From: Daniel Wagner <wagi@kernel.org>
Date: Tue, 17 Jun 2025 15:43:27 +0200
Subject: [PATCH 5/5] virtio: blk/scsi: use block layer helpers to calculate
 num of queues
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250617-isolcpus-queue-counters-v1-5-13923686b54b@kernel.org>
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
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 drivers/block/virtio_blk.c | 5 ++---
 drivers/scsi/virtio_scsi.c | 1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 30bca8cb7106040d3bbb11ba9e0b546510534324..e649fa67bac16b4f0c6e8e8f0e6bec111897c355 100644
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

