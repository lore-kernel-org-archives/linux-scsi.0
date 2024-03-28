Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDDD2555B;
	Thu, 28 Mar 2024 00:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586656; cv=none; b=jgC/1/vm0s/ButSg1/qNleowW4GlmmOHhpQ19qmtOCONsyMPAAb4ttWXgGIwKMLwaWhM1lqCKlKh1bp8c4lAc8h0URSfij38TFwUVrcg0AUF0bTJZtNxoLeQX+baaVD0g/baNG+kvXEkHIAK8qpJdHCDa7MmMc4Pu1yDsUt5tQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586656; c=relaxed/simple;
	bh=0yqNrZFOQaepbT+fRTCJM2qoLk9O4d9p9W1UQpJmlfM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZENdnZRvOdrDqBpl7P0l4QArvsRhQDCAG3Ueid2/9LZGlQ6GK+A7EYDX8fi4XrY/c4MhvQFrvNuru/y+qy6ugeB9QcI1oEpi0JvHtm4XUYE69N700gCLWR4dR7elXC9JsRJYGRlr26dc0/w+sMfOlUl7/M33gkZHONpeoQBxCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QiW6pFr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QiW6pFr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6019EC433C7;
	Thu, 28 Mar 2024 00:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711586656;
	bh=0yqNrZFOQaepbT+fRTCJM2qoLk9O4d9p9W1UQpJmlfM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=QiW6pFr/eUS/uk+wgXcUsBVs8Pe7johbGXcF/GTHlSVTFiLAFFuwi1lJkYh6rM6d2
	 8vEMQnCYVqOWKNqnyUpOhdJ1PmHjUltIiy7C39B5qQw9IDao1A8A+Ji67Menyu/egt
	 fsupPKWxwgH1PgQ7AWKYSL74GLljsaJShI2Lk3l9Y3p7iyt/EgoCqT6krGDybvrg2C
	 xjoz96ZOWDVv+7aXai63nxdZi9bttfjq5R+d79ogg1nvTqv0nOeSvUoFqv2ARdDTL1
	 3LA6BjA2s9T/fG3BtvoiHf0Thtzvavc4BR4+0ZltR194VJtON+y3D3aNv/7C19u3ny
	 NVWGfAG11UApA==
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
Subject: [PATCH v3 02/30] block: Restore sector of flush requests
Date: Thu, 28 Mar 2024 09:43:41 +0900
Message-ID: <20240328004409.594888-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328004409.594888-1-dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On completion of a flush sequence, blk_flush_restore_request() restores
the bio of a request to the original submitted BIO. However, the last
use of the request in the flush sequence may have been for a POSTFLUSH
which does not have a sector. So make sure to restore the request sector
using the iter sector of the original BIO. This BIO has not changed yet
since the completions of the flush sequence intermediate steps use
requeueing of the request until all steps are completed.

Restoring the request sector ensures that blk_mq_end_request() will see
a valid sector as originally set when the flush BIO was submitted.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-flush.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index b0f314f4bc14..2f58ae018464 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -130,6 +130,7 @@ static void blk_flush_restore_request(struct request *rq)
 	 * original @rq->bio.  Restore it.
 	 */
 	rq->bio = rq->biotail;
+	rq->__sector = rq->bio->bi_iter.bi_sector;
 
 	/* make @rq a normal request */
 	rq->rq_flags &= ~RQF_FLUSH_SEQ;
-- 
2.44.0

