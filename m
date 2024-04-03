Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2FD6DD0D;
	Wed,  3 Apr 2024 08:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133771; cv=none; b=MvBJe8EtEvy7kUPOpOr7Bh7qQckN2IBJuM5zAZpl5jpxGLn6En0MMunpEIiARSgH/aQMxLmRdUElD8HLnH12uWr4b15QKk1yUtTE/XukDJCRY8V0xeMHCOwysubfWmI58+AFPeiJLINCWKgowH5zMY45HgfP8ibDaRcw1xpDcR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133771; c=relaxed/simple;
	bh=0yqNrZFOQaepbT+fRTCJM2qoLk9O4d9p9W1UQpJmlfM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSMyMMQ7RSAXvtiDpMGOhZbu0EqomIJEzLq+OXQHjEZdIqU/SsimLUcYRmM+vPIRa3NQqU8Njq8xCSpCHk4v/ayfO+cO2dplZsNLyWrsS1/Pf2DxQc+1PFmaf7Vw6z3DHUoE7+C4vX9QFOwipfyDDmf0kuKPFpdCzD+Gnx5dzvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uqJ9MByV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uqJ9MByV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE91C43394;
	Wed,  3 Apr 2024 08:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712133771;
	bh=0yqNrZFOQaepbT+fRTCJM2qoLk9O4d9p9W1UQpJmlfM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=uqJ9MByVDd3BBQLQSsK1x/yWrySpilKOm/RLIxvuKfeyUqBIFthIE5MKv9YKWrCni
	 vdRhCxJPsKzrHJ7+/hopblPAgubVekt5u2pzwOkyIdrLdVriTxYWNgLc098hmprZ8f
	 lDHe785zp+/zxdfpBqu9CixS4Vbh0aCcEk6r7JntGeqbeDCHFCTuGec3RM6KYjNRDz
	 jupg3G6PUHRVXHt+5zzhRk25di//W9IrfYfabB9LeDy1Ib0Bkfp0xKEDAZnu8HgGsk
	 Wj4rWyx6tElZS9IQYf6jLnpIODaOjlrQtBfQZKsebUGj+vQbNp/w5aHydC7OYlyLM0
	 brHxrpDybZr1w==
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
Subject: [PATCH v5 01/28] block: Restore sector of flush requests
Date: Wed,  3 Apr 2024 17:42:20 +0900
Message-ID: <20240403084247.856481-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403084247.856481-1-dlemoal@kernel.org>
References: <20240403084247.856481-1-dlemoal@kernel.org>
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

