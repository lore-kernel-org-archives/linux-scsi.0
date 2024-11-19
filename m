Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2226743AA9;
	Tue, 19 Nov 2024 00:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976130; cv=none; b=ZU0XmmZ71qnHpv/A6DJCA9+WV0LAuR+1p0BzTQGA1dI+bSimweTCdulNjhY1xGOjRwkG3r7wfSEq04innosq6On1QVPPl2mu6ZtNCiadHs/j4mYdYwqPnfEXXFSFAXvb/m44snh6CIYz0Vf0uiMS7+yC44aNgDjvydmjSxnioWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976130; c=relaxed/simple;
	bh=mdIxfJhSFQPyVT3iSEGDD2aJ3TX4T6DDjjaCvbgFg6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3PNhAiesJlszCFTcXbriMBpXw+sDcbfSbxMaI2q4QeMRvpoCpxjjPCinSnfMOOia/LE2dQGk/HTHFujCmuAEpgYMSKkHGP//To1NMRNU1x7e/FjLe5yl++gdjoOujEjG7RdphOcd3XlK9E5OBH+2VK7fok7/KFiMLTljS/HaZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KdH5/LU0; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KdH5/LU0"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XsljD50SYzlgMVS;
	Tue, 19 Nov 2024 00:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976124; x=1734568125; bh=QmQfh
	cd5qbOt9dLDyXYo6dHH1hE32kIzV5l++g1im1s=; b=KdH5/LU0JMXJQ/+XEuRuA
	VYjk3xHApK4ebWBIMLU18k/oJyBUE55Pgb902y3P2vPF7QWj42r1Of8rLaPB9kDP
	NyCyfCce4pf0q/7vtg8wJ5puCAYNuK104nZ93hThVohEsNVMpcUqO5SqyUvVYPuf
	1LQnMfuTyWoqCi1rNLJfngh6mlCfuK6FaKsrLicys6xTI58uxenWEfxiU75VPKSG
	/iLkiHb2abUuWFAgDcoM9i1XwlcF3HnukLJ4xkr7pPXP+0p1C2LD+cHaIA4XF83p
	Bkh9xXQzlcPwuTEBvYFfqd4soPMN1+x3o3xfjAsQwrB6T7P9+ZiXxxv0C4SCf4uK
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Pvnirn-g1omd; Tue, 19 Nov 2024 00:28:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xslj72vS7zlgTWQ;
	Tue, 19 Nov 2024 00:28:43 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 09/26] mq-deadline: Remove a local variable
Date: Mon, 18 Nov 2024 16:27:58 -0800
Message-ID: <20241119002815.600608-10-bvanassche@acm.org>
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

Since commit fde02699c242 ("block: mq-deadline: Remove support for zone
write locking"), the local variable 'insert_before' is assigned once and
is used once. Hence remove this local variable.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/mq-deadline.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index acdc28756d9d..2edf84b1bc2a 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -699,8 +699,6 @@ static void dd_insert_request(struct blk_mq_hw_ctx *h=
ctx, struct request *rq,
 		list_add(&rq->queuelist, &per_prio->dispatch);
 		rq->fifo_time =3D jiffies;
 	} else {
-		struct list_head *insert_before;
-
 		deadline_add_rq_rb(per_prio, rq);
=20
 		if (rq_mergeable(rq)) {
@@ -713,8 +711,7 @@ static void dd_insert_request(struct blk_mq_hw_ctx *h=
ctx, struct request *rq,
 		 * set expire time and add to fifo list
 		 */
 		rq->fifo_time =3D jiffies + dd->fifo_expire[data_dir];
-		insert_before =3D &per_prio->fifo_list[data_dir];
-		list_add_tail(&rq->queuelist, insert_before);
+		list_add_tail(&rq->queuelist, &per_prio->fifo_list[data_dir]);
 	}
 }
=20
