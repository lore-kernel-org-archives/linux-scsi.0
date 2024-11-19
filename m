Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69D518638;
	Tue, 19 Nov 2024 00:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976132; cv=none; b=D4VYiqEOdJidSms8tEJWo+b9jex2hyud4gOmp7TgoUSAKbyXC2qoe4P/67sJtmOO/yoF5h9SmpfgYjl7SGJl2ypy3gipzkWrYgAXVp4d5BmRHcZMkAPU4nlyrACtoieRTafnA5WbhZ2UMOaRFb8yL0JhdEAhhInRarFVvD6hnjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976132; c=relaxed/simple;
	bh=mJ4y40DOicBQ5BujFGiQk4Pp8sj5xwksoDUXKuUiBCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4thoRo0uoXO3nfzPCg1xSEFE4qrXW1kFU8xKGGMRAApWlRpwE/sVQTvHpjmbih8NjWiqD/AKYXV7LpDGLv9xCEEBUKFdWktVmYaWij7Yaq5fesM6lRIunmXdn7H7clEoG4qOsTKjqdXUncASlb704323DOqAV1GFRuyel/XT/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RnxWcMof; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RnxWcMof"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XsljF2pf3zlgTWQ;
	Tue, 19 Nov 2024 00:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976126; x=1734568127; bh=T6k78
	f57hdyUFAJFLQGLZF6bJ5r0i2KCdQTyofDwiRI=; b=RnxWcMof5R5aHXMdrMgDy
	Z/lee+6Ge3ZpSoL8+flrLUir8JxpVHFxwIUtBjyMXXbcD6fZvSHMXD3UXTK/Ga/O
	PVhQpiCTuWXs28AJiA+4cXnFizqCXtnnBJ3b2P+cPGQOL66ryqjHd5vV+QPpewAN
	KprnYfNFdJPNy5VSnDUKfyxAMfA25Edr6xDPJ/8BxmkQaFTwlLftH/q7bqd3oMFY
	0QmzuBslXcntjb8IvlFt97zpMNdqdphwax8gk3tE/AVauKxWUQChL4gzQFLoffHv
	luVxDpSfhpF1oWu1mQxgp+FaxEfwUKQR1znvf7fQnxPmoMzEtP4cILHDut6OXMLY
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id p-pf_4pXcS1X; Tue, 19 Nov 2024 00:28:46 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xslj902nnzlgT1M;
	Tue, 19 Nov 2024 00:28:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 10/26] blk-mq: Clean up blk_mq_requeue_work()
Date: Mon, 18 Nov 2024 16:27:59 -0800
Message-ID: <20241119002815.600608-11-bvanassche@acm.org>
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

Move a statement that occurs in both branches of an if-statement in front
of the if-statement. Fix a typo in a source code comment. No functionalit=
y
has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a45077e187b5..ece567b1b6be 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1553,19 +1553,17 @@ static void blk_mq_requeue_work(struct work_struc=
t *work)
=20
 	while (!list_empty(&rq_list)) {
 		rq =3D list_entry(rq_list.next, struct request, queuelist);
+		list_del_init(&rq->queuelist);
 		/*
-		 * If RQF_DONTPREP ist set, the request has been started by the
+		 * If RQF_DONTPREP is set, the request has been started by the
 		 * driver already and might have driver-specific data allocated
 		 * already.  Insert it into the hctx dispatch list to avoid
 		 * block layer merges for the request.
 		 */
-		if (rq->rq_flags & RQF_DONTPREP) {
-			list_del_init(&rq->queuelist);
+		if (rq->rq_flags & RQF_DONTPREP)
 			blk_mq_request_bypass_insert(rq, 0);
-		} else {
-			list_del_init(&rq->queuelist);
+		else
 			blk_mq_insert_request(rq, BLK_MQ_INSERT_AT_HEAD);
-		}
 	}
=20
 	while (!list_empty(&flush_list)) {
