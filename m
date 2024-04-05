Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8177D4204F;
	Fri,  5 Apr 2024 04:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712292163; cv=none; b=eY/6OGJsHjpkpID61JmLZSMYgdyG0Oqt4uYczuoDItRJBNoc1si2t1M6Eb8hoDhy4VpVx5rwZPk/xPvtE6JAvKrv1y1nnfixCOMbIbRIzHRNVHE9MKzlQJQkRPb9qCUftM3cOJuKcpXgJHVXChnL1cDxmUcX3z0ML/Rxo39Prm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712292163; c=relaxed/simple;
	bh=iziYpzXvYEHu2nCN/JikIgPE5N7UOGj+TVBZ2NBKtZo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuZmrfNwWTKIFkJF8siLQPyc/vHzrwY7fDzepzgqUBCuIOn0RpyxxNziuLZmw5lwEJoMqpu/BWjkiyvoW7KqgFZGWtsEg91+s1cYrGnsE1iHeYiVclLESaTBSC+LpXO1DonbXR/HwiZrw0pXKe7CA2leSNxW/XNwSkfWS8mzIWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g+ysEPSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g+ysEPSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA7CC43390;
	Fri,  5 Apr 2024 04:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712292163;
	bh=iziYpzXvYEHu2nCN/JikIgPE5N7UOGj+TVBZ2NBKtZo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=g+ysEPSf6P85YC1wbQxx7JcAExqRiFpzoKuE6C3lpkIx/SEc5q0as67MdGS+E03Kp
	 u1fmnFnMI/8PrDIrD8FuCzd9WUcIPXs4/rhUJ2wvjgVegy9VZRwUQxDkvP7V4IDC4W
	 3fES56DjIIhciknkTGzGV4zQz9HtMgk0HD/anBzzR2EyliECRBHyiaBNNA8apgYJ11
	 BXuzeMWFzqohjhR45SsCwJS49kRHWkMsLfqSPdpFhIsYntReCH8ykaLTPx2kHg9DGW
	 zqBEqHfEwJrkCRozgI2DTfFbRov2+t7mHgX+cKSSYQT0gt8b6CnELF5OU9hGe7i30n
	 Wsm/W7ogZmm5g==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v6 23/28] block: Do not check zone type in blk_check_zone_append()
Date: Fri,  5 Apr 2024 13:42:02 +0900
Message-ID: <20240405044207.1123462-24-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240405044207.1123462-1-dlemoal@kernel.org>
References: <20240405044207.1123462-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zone append operations are only allowed to target sequential write
required zones. blk_check_zone_append() uses bio_zone_is_seq() to check
this. However, this check is not necessary because:
1) For NVMe ZNS namespace devices, only sequential write required zones
   exist, making the zone type check useless.
2) For null_blk, the driver will fail the request anyway, thus notifying
   the user that a conventional zone was targeted.
3) For all other zoned devices, zone append is now emulated using zone
   write plugging, which checks that a zone append operation does not
   target a conventional zone.

In preparation for the removal of zone write locking and its
conventional zone bitmap (used by bio_zone_is_seq()), remove the
bio_zone_is_seq() call from blk_check_zone_append().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 block/blk-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3bf28149e104..e1a5344c2257 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -589,8 +589,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 		return BLK_STS_NOTSUPP;
 
 	/* The bio sector must point to the start of a sequential zone */
-	if (!bdev_is_zone_start(bio->bi_bdev, bio->bi_iter.bi_sector) ||
-	    !bio_zone_is_seq(bio))
+	if (!bdev_is_zone_start(bio->bi_bdev, bio->bi_iter.bi_sector))
 		return BLK_STS_IOERR;
 
 	/*
-- 
2.44.0

