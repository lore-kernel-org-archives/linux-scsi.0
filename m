Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C7E13E6D7;
	Mon, 25 Mar 2024 04:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711341897; cv=none; b=I5WgJjW+dBOLAAtrNhucOE5R6vLu5pfNfAC2eCEgKrz9p2I0eJzszf57Ck1ZTjlRaV3zP1Gkc7BWU7ZOic9bku2mzrNPSxaJqQhhO1ArxVchSn0y2WWqZLfOq7tpGnUdDdHxolFkvtLHxiKiFwizLCEwiaviF1EkedbVtCD9cI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711341897; c=relaxed/simple;
	bh=fJ2ybBbACCoTUM31bLsYbegcYwYQ5GsQ4QXTrnuthDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlbBtmdxD1hHGcpiScoqSntfqsPW63Lo8x3A+H44eekBMCmoXo91+Bh1wltSaXl53NXa4XZKhehoWBpqNmx8C1X7QyaetJCbHNGPnqswBXRxarPfO03zZtFkSoUiH2XirnhdLhkkr6IFX2NNxXoOXOFo6vWstXMXO4/wZVyY6dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eu/b25Up; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eu/b25Up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6D4C433F1;
	Mon, 25 Mar 2024 04:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711341897;
	bh=fJ2ybBbACCoTUM31bLsYbegcYwYQ5GsQ4QXTrnuthDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eu/b25UpGWQDJlL5z0TwPB9oYMBaMJv7o9Kx6gKOh5V6QB/IIzFi/Rxa6bvDlol/v
	 grGkqd1HmsLVvoqJgnrd8ZJFE9BIFwyZqbEgwc+uZSogNtwJUeNtKZlYlNKo16+x4s
	 7IGr6kQMvnesHInGkz1cDBs81D2EEzKXVaR/ChP8YY4/Xg+VEv71Dco6+LWnqENq92
	 tHmNiWe4fjdrihbrNCtnqr59wkHkuV1ceJGQyJLbR7zX6NACYuN6x+l/TywXtUBQxu
	 u/xvRzOsgk7nG5rLoixoGjcZRNwtSO+4tyF04SI+8Xt/k/8l80AqwnoEhMsPTFjUtY
	 wy7QKeSyE1Geg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 01/28] block: Restore sector of flush requests
Date: Mon, 25 Mar 2024 13:44:25 +0900
Message-ID: <20240325044452.3125418-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240325044452.3125418-1-dlemoal@kernel.org>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
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

