Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBBE18E25;
	Tue, 19 Nov 2024 00:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976133; cv=none; b=ZsYGQbropjQF9OJ2jjbsX8n9406v2gzG7OXbdv7sFF8I3945MFZq3E98DNFaFYnEyYA3ascY8aiCnMeCr468gYbaVPbJuY3tTqpD0xqmYk2UOBfl276yHvgM/ZV4d9ETI+q4dN7qWHoG2rbgI7dUoeBWQBQxMzjGhuJ9fCf1pQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976133; c=relaxed/simple;
	bh=QFQoLX2vfi6NRsME0p2vQj6OMR+B0rwhneMp/2n/bMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoKk2E+VSU2hTQ0JZAfw3yc5U31Fg8fPpZK6kMximlUdI44GVrbDhyx6N4ISZ9uoVZrzGebystMsWPt0qM/Zf+daUCaxuqV/gMbq2yf7+dao65KAmfotbuhfmtsCflPzxpp9QMF4wLyrBr8/edskfxtqg0Typs3ABvM7AtDC80Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MDJfSRNG; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MDJfSRNG"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XsljH1kJSzlgMVT;
	Tue, 19 Nov 2024 00:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976128; x=1734568129; bh=/hnkz
	coA8QROymJcNm6a8ampF92BXmIteYFFiUE/6Qw=; b=MDJfSRNGgZprxvgm8HYgn
	G2Njs8Hiq9gplkDPxPrwJnOcPDsGgWI6cCXG9cxIwgQQXed8DPG+EBPfS/A6OwvN
	T/qJtD85LDI5xKsp4J8Hxcn02bqXbpSFFpLNlV7YD1zdNaQNjiEZ0Goa0sd2l+yt
	i3uQH9MWjuG83EyDdQT+A6dGC0c8ZhEOSmrmcISVHd1fTO4CizjDnUOEe+7ymzsM
	lozw4LCmSMJ+Ta/iAucInONi3SzfIyCINCdz7C3XoUvRFftF+/Y51L8RXnGMFsp7
	Z2ITL7uP5xFWf48kCLsFDV7KqI01i5yJ01i7lyXNu7T5Wc/Kl8h/oGWnNXuzc6nl
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Vngy7NXZOmoJ; Tue, 19 Nov 2024 00:28:48 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XsljB4MRrzlgT1K;
	Tue, 19 Nov 2024 00:28:46 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 11/26] block: Optimize blk_mq_submit_bio() for the cache hit scenario
Date: Mon, 18 Nov 2024 16:28:00 -0800
Message-ID: <20241119002815.600608-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
In-Reply-To: <20241119002815.600608-1-bvanassche@acm.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Help the CPU branch predictor in case of a cache hit by handling the cach=
e
hit scenario first.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ece567b1b6be..56a6b5bef39f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3123,12 +3123,12 @@ void blk_mq_submit_bio(struct bio *bio)
 		goto queue_exit;
=20
 new_request:
-	if (!rq) {
+	if (rq) {
+		blk_mq_use_cached_rq(rq, plug, bio);
+	} else {
 		rq =3D blk_mq_get_new_requests(q, plug, bio, nr_segs);
 		if (unlikely(!rq))
 			goto queue_exit;
-	} else {
-		blk_mq_use_cached_rq(rq, plug, bio);
 	}
=20
 	trace_block_getrq(bio);
