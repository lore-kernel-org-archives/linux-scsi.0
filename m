Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DF021882B;
	Mon, 16 Jun 2025 22:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750113248; cv=none; b=Hr37puJpZrnAEcdt91sZOXduf6O7aQVgkPMOR01kBhDDpw+t+LmhHDMFqSxbVDy0uIpKo+6Tk+e0rwkqziwG7PYezM1C0S/y6RPVHDdq3gjS9kssF9wkBCu/bKg4YdeXQVT83rNLnasGDU/2k2UIt4nT44lJ5qgXeqPf7bAdtqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750113248; c=relaxed/simple;
	bh=6KWLiaHT2G15XUIgczC5dweZMYdMw2OhuVSwqi1N070=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AK5PvZzsDwCIOQ6ACuED8lgZHZmzK/tHNJ8bhpm2TFheIAlBs47/xhLRBMAO5q5qBTEjqjoEF6F7N1qcBXJF1PXmpUyDqk/kvUMAwdrL/RmXvMVEUNptmrIy4V0xuNY5d1tIsqAUdCb76HE/+JOXNaLUUzmv0akvv7ZIFIimK34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qvTjFTpY; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qvTjFTpY"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bLlCx37jwzlgqxq;
	Mon, 16 Jun 2025 22:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1750113243; x=1752705244; bh=zGhhv
	pwkmk/v+KzVsp65m2pIBhdvNNox27Y0g4lOBEw=; b=qvTjFTpYJO5nli7I2Q//5
	jlkplro1nyPJrzE5LyXs/Id0zkHh3nEv0ZTK1At92lfUrq5t5b6nk7Q6PqoUe8dF
	kUlTwmDBCJWKbkqAhyls9KKXkIaNLYXrTY7DJ4NQKP18qBdywi+gJBMNi0b/XfeK
	pc3dZEgBuwjlnCoVoM29w3o7HK8o8tjMmk1AGJn4dc2fNYpKxxS12RVRPNtI9jKl
	ZtBxXqfezPZk61F5EsqDuk5USXXLWmjJus38dm/mSdlQhkoE5Rb6hH+n8XsvVoe2
	e7Etf/69lLpTfaA1Xu4q5lk/rF2CDj63fJS6LShlAn+uwcLNGhXYN2IvDzVveaMk
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id E0Yb5wTW_FlQ; Mon, 16 Jun 2025 22:34:03 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bLlCn3P5XzlgqVy;
	Mon, 16 Jun 2025 22:33:56 +0000 (UTC)
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
Subject: [PATCH v18 01/12] block: Support block drivers that preserve the order of write requests
Date: Mon, 16 Jun 2025 15:33:01 -0700
Message-ID: <20250616223312.1607638-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
In-Reply-To: <20250616223312.1607638-1-bvanassche@acm.org>
References: <20250616223312.1607638-1-bvanassche@acm.org>
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
index a59880c809c7..6d01269f9fcf 100644
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
