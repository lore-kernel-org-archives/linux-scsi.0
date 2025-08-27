Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2EC30CDB2;
	Wed, 27 Aug 2025 21:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330260; cv=none; b=t0DoRMaN4eeFN2CqQj+4de4fpCnCRoOqg+2ZOBPFF4xQP3sgvt29VpdF3n9N/j6JRn5ptrLMhfzmPkRHgRJdnwLLJlDfvpmWRDGcLcIgnFjwb31cUcQJ44rnQlgNVdRbQnuy6PF1OZhsdf7sQbLG9kEJve5a9DyuHJJzojMjndk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330260; c=relaxed/simple;
	bh=Ur4qheONGWopFxqBYsG0kqfHwJArllqKjNEazZ1VhYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMehM8oSvyVoAHobzXuPzSzdfw012yDBnl/6hQavUe1T1odj2uOQRS+7n5ZoXLT10NaiOgg7kpbgWtD60fMb4lJPhrUbm1LyFFPy7iPGRIQh09e3ercko9yVx/4u6ZNM4o4zLcxP7IzzHd5FdT2JevalfMcUccwQw7DRqjgEriM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=inJ5bmxI; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="inJ5bmxI"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cByPt54cLzm0ySh;
	Wed, 27 Aug 2025 21:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756330257; x=1758922258; bh=wW+nq
	wk7r8ZP5nyGsRldRUIBn/b69UiyL2OXH+Wsv7c=; b=inJ5bmxI+FiDycJHwsf+B
	hVAWcdJKOwSzCND9JoFvRsgPQHtgRFdidrtHZKVEbhgpZWF20bQUpxnI9dbO0B+J
	mpVrvZaTRufsubSAQ5hawBHZyiPGDj14f+T9usnsuPaz7qxCEdKUi9Ni4OTB5ycN
	XPoaBNzOHAyfCcqNNUbE9hhE/VEJUAql7IkhN9tHRT68KMWdK9ZQ65m58q6VtlCJ
	OCo3RimgB04pR7GJdiQWmS4Or09R9bczppRH10x7GKBtls66VXktD32WSwxu0n3h
	vZGsI18dMh1EOkUZtuqsPFyZ/9YfJSJC15jn5A1LM9BKC5wDQm130bpaTGJwJzU1
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fCEiahSjR-UD; Wed, 27 Aug 2025 21:30:57 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cByPn6qLbzm0yV7;
	Wed, 27 Aug 2025 21:30:53 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v24 11/18] blk-zoned: Document disk_zone_wplug_schedule_bio_work() locking
Date: Wed, 27 Aug 2025 14:29:30 -0700
Message-ID: <20250827212937.2759348-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
In-Reply-To: <20250827212937.2759348-1-bvanassche@acm.org>
References: <20250827212937.2759348-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Before adding more code in disk_zone_wplug_schedule_bio_work() that depen=
ds
on the zone write plug lock being held, document that all callers hold th=
is
lock.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index eb81278acb38..627a952477d1 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -785,6 +785,8 @@ static bool blk_zone_wplug_handle_reset_all(struct bi=
o *bio)
 static void disk_zone_wplug_schedule_bio_work(struct gendisk *disk,
 					      struct blk_zone_wplug *zwplug)
 {
+	lockdep_assert_held(&zwplug->lock);
+
 	/*
 	 * Take a reference on the zone write plug and schedule the submission
 	 * of the next plugged BIO. blk_zone_wplug_bio_work() will release the
