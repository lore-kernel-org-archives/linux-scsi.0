Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F4F1DFE26;
	Mon, 30 Jun 2025 22:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322640; cv=none; b=tyVenutSHIiBTnSgiZutwIF/5And0ziPQjzncS473bFUo3DxH0pxjHiTe+AgkSVxRI5ip+lJx+drSnqsC69COzIRYdWTL7G1+8bzc74lFTJZR5s5cHDSXeylzsx6QYltyeOzL+vM0uk8Dg+HjKZM8kvdpx5iIZooD7mbTPl1xrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322640; c=relaxed/simple;
	bh=j+zfFX5l9YXF/gmj+AKFNefyGynCMQM9XgfWB074hd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBV1RWocQnxN/aIu6u9RU8MhAuonYyqvir8hnFdXciYe648M9XtbvLNS/vyxfUR54DVdocaV8YfnxVv14mudk07nc9sHmH5TUgGwUxQG6yItLlrX9PrRQljVT9zqxcxeMsRS9HAVgjgsgoug3amINe1wyZbSm1Wj//RAFjTTdUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UyyWkbRl; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UyyWkbRl"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bWLTT3vJ4zm0c2s;
	Mon, 30 Jun 2025 22:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1751322635; x=1753914636; bh=Hikzb
	WiQ5nziEjTnyANo1Gxs/hVQMR6DuR8Z/X04vfg=; b=UyyWkbRlTRrGNoIAsnMMw
	uvfXHxkxsKTN9XTPy6SI8rTOuSISVEgheKxStIqiFiPQMlVErfhIkdxZ2LBdR0Qo
	brrOyA863S9KSMdFndaoXdwG3aguvjF4lNaT5GGPqXpQtwq4SXateJzxWPzu6mKT
	13TzKC15fB40E/Es/YB4qB9YL9OWelxvJ1Hh/GyM7R23jl2y+GZvAJgwj/JqaYQk
	wX9cCpXf4W//371SQ+eaCNKO2u1TkszVdDOyM74CwVUts/zODj5T8IcNZThkSGJq
	O6ZN25ozvEPTW4YTkfEKG8JFXCf54OOuV0RH7KSQyVFzpbsIF/Zo696Z8PnLs/7b
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id COJcP1kQV9U8; Mon, 30 Jun 2025 22:30:35 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bWLTL1R0lzm0bfc;
	Mon, 30 Jun 2025 22:30:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v19 01/11] block: Support block drivers that preserve the order of write requests
Date: Mon, 30 Jun 2025 15:29:53 -0700
Message-ID: <20250630223003.2642594-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250630223003.2642594-1-bvanassche@acm.org>
References: <20250630223003.2642594-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Some storage controllers preserve the request order per hardware queue.
Introduce the request queue limit member variable
'driver_preserves_write_order' to allow block drivers to indicate that
the order of write commands is preserved per hardware queue and hence
that serialization of writes per zone is not required if all pending
writes are submitted to the same hardware queue.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Nitesh Shetty <nj.shetty@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-settings.c   | 2 ++
 include/linux/blkdev.h | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a000daafbfb4..bceb9a9cb5ba 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -814,6 +814,8 @@ int blk_stack_limits(struct queue_limits *t, struct q=
ueue_limits *b,
 	}
 	t->max_secure_erase_sectors =3D min_not_zero(t->max_secure_erase_sector=
s,
 						   b->max_secure_erase_sectors);
+	t->driver_preserves_write_order =3D t->driver_preserves_write_order &&
+		b->driver_preserves_write_order;
 	t->zone_write_granularity =3D max(t->zone_write_granularity,
 					b->zone_write_granularity);
 	if (!(t->features & BLK_FEAT_ZONED)) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a51f92b6c340..aa1990d94130 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -408,6 +408,11 @@ struct queue_limits {
=20
 	unsigned int		max_open_zones;
 	unsigned int		max_active_zones;
+	/*
+	 * Whether or not the block driver preserves the order of write
+	 * requests per hardware queue. Set by the block driver.
+	 */
+	bool			driver_preserves_write_order;
=20
 	/*
 	 * Drivers that set dma_alignment to less than 511 must be prepared to
