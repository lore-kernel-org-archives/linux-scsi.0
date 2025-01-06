Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EE21DC05D;
	Mon,  6 Jan 2025 10:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736158042; cv=none; b=YZteQ/5vdCgOyJ/2XnR0kB10GWr6pzEpLxVIWSDCoJlUV/1OVckpV3MSyUZ4fFIbczt05yBsYSJhcPeyDb5UR65H5Ku6gjSLbJUccszCm1zgJA9VUj4wJuqAuzeK5dblPJSV870/SOJGC5lOnvlu2Af3DOcoj0eM5VCB4jSMLPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736158042; c=relaxed/simple;
	bh=9L+LQ1B2t5ni9IkmaODon7t/uJa3vqClUoW++DLASLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5LUCbQq0pBwEm6KFROKRLJZrLPGFGfz+jtP1Wmmupk1CwVXroXGgBxbUmw5GCIOi6gl6vDvu0RkjvgIDCkiZvezTFkIgb254jX3vdUohkpmNCfJTsmI/9vc8NzgtJFEy5cip222XdpuAI/c4THNCTzIJYxa+IxYCGgW9JRaOxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ha9D8wqJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ha9D8wqJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QcJrAkXza/kgjN9ldeyFMdunh4NKKijDslOdD+6Y9ww=; b=ha9D8wqJgEh2XOGBJWenyOQvf5
	CZ3gHlWFKqbKLyjdNo0jcmca3MXa770wkgZCLHW+frAEAdNdCz38W/mIB6xFkk7mC5xA9sH4Jk3Xt
	X0HTC/yIzAVJVS1B9L05eIxbHhpOgE5NJCjHLPnOMqYEv+8bDVLm+lfkvuWKz2wWM/XmfsQQb92BO
	NR+XYgjwI+hAX7xuli3D78jDiDh7Lvh4n9JQakSsJzBaCKxzGXr+4yCbSp/LY3LCjapGDRx+hC6Pm
	FXfi6xn+q0CWhBv3YGfdd7O18UbYeFLfg8Q1g+gLsumduAYFasF8C0b7nigq/AELjzYWeCrz/RbCb
	oUNCGK6Q==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUk0r-00000000ncv-0JEL;
	Mon, 06 Jan 2025 10:07:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	nbd@other.debian.org,
	virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 08/10] nvme: freeze queue after taking limits lock
Date: Mon,  6 Jan 2025 11:06:21 +0100
Message-ID: <20250106100645.850445-9-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106100645.850445-1-hch@lst.de>
References: <20250106100645.850445-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Work towards a consistent locking order by always freezing the queue
inside the limits lock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 42283d268500..c6b7884bb343 100644
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

