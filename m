Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A27D1DACAF;
	Mon,  6 Jan 2025 10:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736158035; cv=none; b=q8LlZoUDk/3uqDwTpMFK4ftwgN97vcMZViHk3J7h5+4GtXinliNjfgKIWLG1JDWtH7SYs+rgOeIEcuuZ9FSOlPXRYW9HQlpf0Bj+DjDnQ+l1CMyL4Rh413bAP/VWBicPVAMy29Mqs22RDpNZYN4bC6hSZTJyAQ2jQ8YtG4SvhCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736158035; c=relaxed/simple;
	bh=rgmTjAgtJmUa3nNaxXIV//sItE+upUZVDsaJENQittw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0W01Q0B0Dgmd+/mD6WI6JJF4NQM8EgWhFm2Z62wBZaI9Bs/2rCdxE0lQvsTwLX03Fjm6vZI0AxoHY1Eh7030qqUn3vIAo4EVbKfOR6aeLtS7h2kkshIJmeb7h+R23hddJNfeZWVHYTHFDsF08CzzqzcYkLYJaZOp8GQv3jyd+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gDd8lJdR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gDd8lJdR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GBHr+r0gFMC9Q2LFFRVxWSRq/duhK3fuTGmy1XB+hDM=; b=gDd8lJdR7fKQX7BXAG/11lVzUE
	Y1/k3wa2S/lZiio5Fwn7Xhoj0P49ZMuEKrXpBGxK8ZjOY0LCec1Kj7U65jikd+b1BocvpEFQqkywK
	8NWol7TplOA+yuX4M2tJ7LcZQt9ljCuRdV3cO7XhDX99Kapx++0JLmBEDqPMDr1y+lOjVq3Lr6WLq
	X8f+JbKjAG5J3D1M03PW8Em0dr5HZKK+1k06sEyGGf5y5IwXwAft1AeO6esirLS1ZZULx/hAJLXeF
	PChgDZfbG9RAzZv11mGXPtkLo3+E02CY86exEj+q2IU6lO5UOM+O2hIxzfWxjnDoj22wRTDzKwMll
	xzZiFJEg==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUk0m-00000000nX2-0QoC;
	Mon, 06 Jan 2025 10:07:04 +0000
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
Subject: [PATCH 06/10] virtio_blk: use queue_limits_commit_update_frozen in cache_type_store
Date: Mon,  6 Jan 2025 11:06:19 +0100
Message-ID: <20250106100645.850445-7-hch@lst.de>
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

So far cache_type_store didn't freeze the queue, fix that by using the
queue_limits_commit_update_frozen helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/virtio_blk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 0a987f195630..bbaa26b523b8 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1105,7 +1105,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 		lim.features |= BLK_FEAT_WRITE_CACHE;
 	else
 		lim.features &= ~BLK_FEAT_WRITE_CACHE;
-	i = queue_limits_commit_update(disk->queue, &lim);
+	i = queue_limits_commit_update_frozen(disk->queue, &lim);
 	if (i)
 		return i;
 	return count;
-- 
2.45.2

