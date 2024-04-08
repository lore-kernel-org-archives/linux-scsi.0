Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9949A15C3;
	Mon,  8 Apr 2024 01:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712540493; cv=none; b=g4CBbSVAdiCiK9Fwo51se604b64gxr2foLUt6CA1gVc7DEZLVsuD2zlpNrpWTuSvlKJlhUZm+4R6CxHGIjTzvSpSrySb99fpNtmI0bk23rJ793YFUngJSUYwA9X98vP+v5VOC6g2MuzKcxSyo/u+/7eVovIVVzEkkSWNEGDwBIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712540493; c=relaxed/simple;
	bh=iGEVLC9YGivLU1QMrPXjUR/C6DUcKR6exN+/jtWzOmE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGDJWzRJGd4uw2JIAQBe34kZigP2u6xh0ERsY4rmf5t3pcMKMCuwrT8cOoMGQpYQ+JVxqyXdrZvwAoAPWSwVMKJPLZ95ikAaUeIhAis7U94hx1f7DVvifJAflVpUc4KXjU0/tHbxPXXbt/WQb6KCqJd1bvGSJ9K55phKslAJHKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GAYobnC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GAYobnC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053C0C43390;
	Mon,  8 Apr 2024 01:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712540493;
	bh=iGEVLC9YGivLU1QMrPXjUR/C6DUcKR6exN+/jtWzOmE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=GAYobnC8jmVdiUfRp+4E8ZBL3tC5XiVxaUPM17iFESW3DD2a41wvJeOGH0HzL58eE
	 xic8S8VLdz6A2sTwDFrWOEFZ3ovRmXA+xBlrgqqfZ66DElMmBY9u2TIXmwu1Sttq6Y
	 2F/8y7FAnDII6xaWz035qk8x4Su2B1Bbbrzoo6xF0Ra3i4S5IaDFOpwpKAf0eg3euX
	 3nSHmfCH4fxlR6LyWsgX8kUbJsIYZDi+WG0lrCBWTsl7MtA2/VGtgA/MaZGX6+DMRT
	 j2VW+9hUA1GowfpHj2o/mhPHktjvjnWo/MTDK05dOhK7br5Kc9aZgTrlQNZdSOYqdq
	 b04BYWbxoauBw==
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
Subject: [PATCH v7 01/28] block: Restore sector of flush requests
Date: Mon,  8 Apr 2024 10:41:01 +0900
Message-ID: <20240408014128.205141-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408014128.205141-1-dlemoal@kernel.org>
References: <20240408014128.205141-1-dlemoal@kernel.org>
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
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Tested-by: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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

