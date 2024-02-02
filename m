Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B40617BC7;
	Fri,  2 Feb 2024 07:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859069; cv=none; b=lbUsBu9ncJvBCGjvMsaMQcAldkIBrBgG1wQIhm06H3Q5uO78MdSJ113gFIiyz6Niep907Hd80ERpG39kfhrdl33qU5UMdCrGGFDHgu/cpUiQidBviWllsGb60ZWDZuP/Y1wJIduVuTXiAdY9x4xmDGzgcuoQL2CNlrunPBMcPAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859069; c=relaxed/simple;
	bh=b0TTUxLvhqt6A+VBsQ9qsNE9ELWe3POmBpEzvqbQrmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZ8DANWMbN8o13skmRX1vGoiVcqz/sl6rKBILwpISAfHuZKdzm8TUF6BrMuv6Z5XYA0z5SzWysm35xsFN+HjPcGDqz22RR3o2pad4tBhsvTbgc2r2UfKIdH4Qygrk42UrTuzzYXAK8kQhjh7n2kAcIcSg+E62YZEbnh+7pBwrEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mVqo49XF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mVqo49XF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE7CC433F1;
	Fri,  2 Feb 2024 07:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859068;
	bh=b0TTUxLvhqt6A+VBsQ9qsNE9ELWe3POmBpEzvqbQrmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVqo49XFZoONVs6JPUEmNlpbF3XuPr6NViJytEmrjlQqvGPm7Ge04TRVwP8lrtmfv
	 uVhSd3Hny3NlJE0xz7bPdeD+bNlHDsBCKNU5uGxXg/xcD+4RDSwSnthPLUyO7TIIN2
	 6q3EgXo8/nwKj4EcmYjS7pDYXskIpSo1m+SxrsjdiLh+f4tqJ2K4ZgkYSb/NucjoIO
	 lCcSm+/3rt2Sz1Aq7k9tHJZ5eaIXgme3x1l5xsTgWcYp9W0bgX6AlOIxbCb3KrH1cC
	 7BN1gaEDFMLs0ThMn1p5kUDOKvblFwvJ+u6xGZuYBNeGNo2KV5gBeVokpZK3uPxL4g
	 EY1QCnfS0nb5A==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/26] block: Restore sector of flush requests
Date: Fri,  2 Feb 2024 16:30:39 +0900
Message-ID: <20240202073104.2418230-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202073104.2418230-1-dlemoal@kernel.org>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
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
2.43.0

