Received: from mail.nearlyone.de (mail.nearlyone.de [49.12.199.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613E41C57BB;
	Tue,  6 Aug 2024 12:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.199.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722946048; cv=none; b=oE2bxcfm0V+Po480xqBiVkFN9bM1XqJ4ctgfUzg9zW9sY6xsIB9MFa8uEUOtp1sBf8yJv6jok9V3IQfHbREwrJHSmTtYdlLgkqQ0JTC5CaBCAJSp+ysMGk0IuieAuAdLB8Ct1PWWsLwgyM9r8fDStN4fOthaisZ9KglRCBRxbME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722946048; c=relaxed/simple;
	bh=80CPp35HMnGk/QrnIEr7KyA0OTaqUtHxbsE54aWBNno=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sBX3B9t/WIvqgdDmJvuRttEoaE3ZyaW9BB5+OGc5B4uO04ERT8ET5Xt6+3t9hLOtaKMl6+sPGC/OoH4Xgpr6x06pQEtLoinfzi2lOr441JrnUT9DFaXmTSEYV0MgdM44l2X2Tq3xmb7gGe6p6A+Is24ZwI1enJ2Ma4r2IHbdV3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=monom.org; dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b=bFdE/NdF; arc=none smtp.client-ip=49.12.199.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monom.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b="bFdE/NdF"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C5C37DAE1B;
	Tue,  6 Aug 2024 14:07:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
	t=1722946044; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=gVgkRl5AhJ2SUFgxgB2iVGZTZ3mEQr8KMCr4SQK3Lvg=;
	b=bFdE/NdFUoVI4UlUon6XqoqWP9OBF+fswKi6sC7ewaa6hDnyd6cb4gcxoW08Z4sUJwyODS
	nEQCyq0gLQO8jOWcDPSkBLkNMRRFF0Igz8k96gwVTIIE36SlEQuegnqXwYfCosf5iG0EET
	GGQAwhus3zKZ0CZcVjF3LksgKUPhz30xTsnuidOADNtaAP4F4hz7i88yFuH7WZ++mEt0nd
	6/ELgpGqN9MeZTc/FyY/2UEg0EpkQtL/gTpgD2RJP208PLgoSc1eyeri6rhNa6VpAaNJ3h
	Ie85NDQER96b9WCwSFopN6+wfk1aoco5YVUmB0DmWDalIhyYwhu90vT4+eB5Bg==
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 06 Aug 2024 14:06:38 +0200
Subject: [PATCH v3 06/15] virtio: blk/scs: replace blk_mq_virtio_map_queues
 with blk_mq_dev_map_queues
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240806-isolcpus-io-queues-v3-6-da0eecfeaf8b@suse.de>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
In-Reply-To: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Sagi Grimberg <sagi@grimberg.me>, Thomas Gleixner <tglx@linutronix.de>, 
 Christoph Hellwig <hch@lst.de>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 John Garry <john.g.garry@oracle.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, 
 Kashyap Desai <kashyap.desai@broadcom.com>, 
 Sumit Saxena <sumit.saxena@broadcom.com>, 
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
 Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, 
 Jonathan Corbet <corbet@lwn.net>
Cc: Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, 
 Hannes Reinecke <hare@suse.de>, 
 Sridhar Balaraman <sbalaraman@parallelwireless.com>, 
 "brookxu.cn" <brookxu.cn@gmail.com>, Ming Lei <ming.lei@redhat.com>, 
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
 virtualization@lists.linux.dev, megaraidlinux.pdl@broadcom.com, 
 mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, 
 storagedev@microchip.com, linux-doc@vger.kernel.org, 
 Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.14.0
X-Last-TLS-Session-Version: TLSv1.3

Replace all users of blk_mq_virtio_map_queues with the more generic
blk_mq_dev_map_queues. This in preparation to retire
blk_mq_virtio_map_queues.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/block/virtio_blk.c | 3 ++-
 drivers/scsi/virtio_scsi.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 194417abc105..8f68037da00b 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1186,7 +1186,8 @@ static void virtblk_map_queues(struct blk_mq_tag_set *set)
 		if (i == HCTX_TYPE_POLL)
 			blk_mq_map_queues(&set->map[i]);
 		else
-			blk_mq_virtio_map_queues(&set->map[i], vblk->vdev, 0);
+			blk_mq_dev_map_queues(&set->map[i], vblk->vdev, 0,
+					      blk_mq_virtio_get_queue_affinity);
 	}
 }
 
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 8471f38b730e..8013a082598b 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -746,7 +746,8 @@ static void virtscsi_map_queues(struct Scsi_Host *shost)
 		if (i == HCTX_TYPE_POLL)
 			blk_mq_map_queues(map);
 		else
-			blk_mq_virtio_map_queues(map, vscsi->vdev, 2);
+			blk_mq_dev_map_queues(map, vscsi->vdev, 2,
+					      blk_mq_virtio_get_queue_affinity);
 	}
 }
 

-- 
2.46.0

