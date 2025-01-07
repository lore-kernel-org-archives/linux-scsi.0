Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF461D8E12;
	Tue,  7 Jan 2025 06:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736231522; cv=none; b=sZsVYy+KRkPH/9SFam7e6XMvNfucdY0MkEHKprZylLzim6dyQJobEFNVkWB7vFstAmZKGItQeXrm6PIlHStkVf+P/AXriMFVlUdXX4UQTufU9RqtkKjQN0Z2Z1krbvZ+PS0PSXhlhYLNHQrx0PeYij1fdo6EY7wuVIixCjzkmqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736231522; c=relaxed/simple;
	bh=qO8qTDzzUWpoUUS38rG1RyDTJUhg9EdyEOHI/VKZwB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMwMZcjLljsD3js8bEnnSA5+OQPCNn7BwkfEgDZhKmwMUPF2QCmk9ZGkLEgsEGVxAtSg4Jz7vI9cskUIeQiAdhxjfmSzFqnwy7cLd/0/06ch/E/shPxYQGC1ttVA3s16lc5OZvcoKd1asM4VyfFIPMozOHnuiZ5Uo17ARdBzbQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aeMnUBD/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aeMnUBD/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=a8AkwchBZAjJWtrY4RK7VKovX+Wf21I567Bat+cuJTY=; b=aeMnUBD/8o4mvdTJ00kxg3CPq3
	l6SQRlA1VspG9tc+XKh3piZjFvxwACqm2lrjCspqEPKfky79zlAYUbI5RrznlZ11m3ctkxbIyA/gF
	puREtODgxWCGeYNL7qDY6dsBELstwZkSq38Trvxg874HpikFXVjYaKS3GQwByoVbxaAzFYfSfj0/k
	X8cqGpYcXcq/M5oJSi+emsvhBrj/Hatya/CQWT9CN0xV4hYXQw6JsUxrbg08OJX1N667IcAX5JavG
	4yX6OM6r89gvyH1vLYq2uvYjTDJDAtr8z7TjO5tCEimhoGelmr05UIbTt8rxnd7+jUW7f6Yp45GGJ
	dEx9+oww==;
Received: from 2a02-8389-2341-5b80-d467-d75d-35bf-0eb6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d467:d75d:35bf:eb6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tV37s-00000003dyf-2phg;
	Tue, 07 Jan 2025 06:31:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	nbd@other.debian.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 6/8] nvme: fix queue freeze vs limits lock order
Date: Tue,  7 Jan 2025 07:30:38 +0100
Message-ID: <20250107063120.1011593-7-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250107063120.1011593-1-hch@lst.de>
References: <20250107063120.1011593-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Match the locking order used by the core block code by only freezing
the queue after taking the limits lock.

Unlike most queue updates this does not use the
queue_limits_commit_update_frozen helper as the nvme driver want the
queue frozen for more than just the limits update.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index c2250ddef5a2..1ccf17f6ea7f 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2128,9 +2128,10 @@ static int nvme_update_ns_info_generic(struct nvme_ns *ns,
 	struct queue_limits lim;
 	int ret;
 
-	blk_mq_freeze_queue(ns->disk->queue);
 	lim = queue_limits_start_update(ns->disk->queue);
 	nvme_set_ctrl_limits(ns->ctrl, &lim);
+
+	blk_mq_freeze_queue(ns->disk->queue);
 	ret = queue_limits_commit_update(ns->disk->queue, &lim);
 	set_disk_ro(ns->disk, nvme_ns_is_readonly(ns, info));
 	blk_mq_unfreeze_queue(ns->disk->queue);
@@ -2177,12 +2178,12 @@ static int nvme_update_ns_info_block(struct nvme_ns *ns,
 			goto out;
 	}
 
+	lim = queue_limits_start_update(ns->disk->queue);
+
 	blk_mq_freeze_queue(ns->disk->queue);
 	ns->head->lba_shift = id->lbaf[lbaf].ds;
 	ns->head->nuse = le64_to_cpu(id->nuse);
 	capacity = nvme_lba_to_sect(ns->head, le64_to_cpu(id->nsze));
-
-	lim = queue_limits_start_update(ns->disk->queue);
 	nvme_set_ctrl_limits(ns->ctrl, &lim);
 	nvme_configure_metadata(ns->ctrl, ns->head, id, nvm, info);
 	nvme_set_chunk_sectors(ns, id, &lim);
@@ -2285,6 +2286,7 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 		struct queue_limits *ns_lim = &ns->disk->queue->limits;
 		struct queue_limits lim;
 
+		lim = queue_limits_start_update(ns->head->disk->queue);
 		blk_mq_freeze_queue(ns->head->disk->queue);
 		/*
 		 * queue_limits mixes values that are the hardware limitations
@@ -2301,7 +2303,6 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 		 * the splitting limits in to make sure we still obey possibly
 		 * lower limitations of other controllers.
 		 */
-		lim = queue_limits_start_update(ns->head->disk->queue);
 		lim.logical_block_size = ns_lim->logical_block_size;
 		lim.physical_block_size = ns_lim->physical_block_size;
 		lim.io_min = ns_lim->io_min;
-- 
2.45.2

