Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7744222095;
	Thu, 28 Mar 2024 00:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586654; cv=none; b=TY+eZ8PF8GTvByCaHXykeOZcHaOVsoad1wjZ6j5X5hdkQJUcrYz34ETmKCY8QvWelK5PRZe+4oOumExvIeVM22x5+g/7SgJDASoJNN5uVEzGwQ/ssWFQJzYHr1fHZ7+X8/upNWutQE9yKwAr4BuU0m9yzB7agVr+mxWvcA3YirA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586654; c=relaxed/simple;
	bh=rYPOJKSR4ZSBZRsgiieElKMZRibpVnpNXcy2Px1D6dg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSTB2t2G98rYEUxMqi21LIIVyzixTpinyebp6lFYKJU5VTVntvCuBWH1oEtlotpayFI6I2K4jwYBDVJNrD4IslpH/TJz6PlNr02Lcp/tR/G6seEuN7SINtVIBgM2XtpadmyxvVvzh50jU0REqsYRaLPHFdAbKnT1xHHMGo4vvy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSr28L46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSr28L46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE35BC433B1;
	Thu, 28 Mar 2024 00:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711586654;
	bh=rYPOJKSR4ZSBZRsgiieElKMZRibpVnpNXcy2Px1D6dg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hSr28L46GSjT6HCZ3CNJQ41oyb8Jp2ooxmR9VBil0THT0V62/askYVUutCHumZJHa
	 2p9lsjzabiUZb6OFd3cukMXhAjo/RmjhTQFRcRK40HaTUKJEF2nuWByJYqSc/31RDN
	 k9SHZG4/Jb/XAr5y1w9teEoZ4TeWkjG8auqjjsq6pP1CddU6d/gQu2OVW5js00toLE
	 SsHkBi71xHEPCdasU1cskp6lSTdvtYE6PD8azAAkAsxUZ/DJ+eqV2zi/QIWzPVSPtO
	 KhhdDdTTAXs0aCOe6vHxnhsuzxJtU1OQ9XXT0/gXtHUzAoxdtWEKGZnF72djUHyk0g
	 rG5r/zwhrbXBA==
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
Subject: [PATCH v3 01/30] block: Do not force full zone append completion in req_bio_endio()
Date: Thu, 28 Mar 2024 09:43:40 +0900
Message-ID: <20240328004409.594888-2-dlemoal@kernel.org>
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

This reverts commit 748dc0b65ec2b4b7b3dbd7befcc4a54fdcac7988.

Partial zone append completions cannot be supported as there is no
guarantees that the fragmented data will be written sequentially in the
same manner as with a full command. Commit 748dc0b65ec2 ("block: fix
partial zone append completion handling in req_bio_endio()") changed
req_bio_endio() to always advance a partially failed BIO by its full
length, but this can lead to incorrect accounting. So revert this
change and let low level device drivers handle this case by always
failing completely zone append operations. With this revert, users will
still see an IO error for a partially completed zone append BIO.

Fixes: 748dc0b65ec2 ("block: fix partial zone append completion handling in req_bio_endio()")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-mq.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 555ada922cf0..32afb87efbd0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -770,16 +770,11 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 		/*
 		 * Partial zone append completions cannot be supported as the
 		 * BIO fragments may end up not being written sequentially.
-		 * For such case, force the completed nbytes to be equal to
-		 * the BIO size so that bio_advance() sets the BIO remaining
-		 * size to 0 and we end up calling bio_endio() before returning.
 		 */
-		if (bio->bi_iter.bi_size != nbytes) {
+		if (bio->bi_iter.bi_size != nbytes)
 			bio->bi_status = BLK_STS_IOERR;
-			nbytes = bio->bi_iter.bi_size;
-		} else {
+		else
 			bio->bi_iter.bi_sector = rq->__sector;
-		}
 	}
 
 	bio_advance(bio, nbytes);
-- 
2.44.0

