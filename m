Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E3533991;
	Tue, 19 Nov 2024 00:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976128; cv=none; b=ev1C9dK+PFUPw/pxThCG+jgxaZ5BwxrxroUZi3Z1jIBMBlfw5FHATBUGYLLob5VQeH4deyAZqnQGdO1lPvMDc0k1fEgA/q/ZZ0Ev/q8UItwDAfFtMJmLTodnqGAbgvssTvRVp9vBn+GubkMyg5Y0aerc3DHrsoBJs4sx16xt8IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976128; c=relaxed/simple;
	bh=bMQkL84IxjkXmmPRY6YMAlz/aLP/ZnxOX+IgNNanzjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPcQH05OTEGkGILhKrlDdE6dTRZPKkvXIusbG01yDyRnsyn8O3RjAl1E3/pQCiXfDdLDoNcbe/lLGOXz3iKDeD8uZMgF1HfC23GWlnyS9STTWdf1tCAfbvwCEd/Hz0mWAY6pR4/QfC2BJjZTBAE5ouZcZBAQAzrZQN2m6MN5C1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0UwpC/BD; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0UwpC/BD"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XsljB2GQLzlgMVR;
	Tue, 19 Nov 2024 00:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976121; x=1734568122; bh=5SJWf
	5W2tyHPoFL/qgha2Dp6Z4cagmvWNWMma2DsGxg=; b=0UwpC/BDj5q586/vN759a
	lgzzxOC+jI1NvbHM8aloF/ErAqvbLbeyJjraaINqDLRmydAvYvqjhpwz/Q+DMu3J
	7WsDYxVza+ha3ILmmYvAdZFw9LzV9yy+MHwNeSiMyCb5CcmSKdLluFg4g9NwqAET
	AnX3rk8HfOtDskVRoOW/HvPsKVCWoFAvUeFLF74FYXB/xSW0mmdhhPTdeG+R4HBG
	fjf7U6HbOO/TRX5YCZcQNvFsofHc0K6wju9QdICDIlTSpDDu//Am4w/H1UwzHNzH
	JTLAmJwtr95G8Tt6Kq2D/FJDIXGpXTeQYV7t+YLPbXScjP0VU6hEVozokkAxs9Eq
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id f4KXGpne-O9z; Tue, 19 Nov 2024 00:28:41 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xslj33qnnzlgVnY;
	Tue, 19 Nov 2024 00:28:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v16 07/26] block: Support block drivers that preserve the order of write requests
Date: Mon, 18 Nov 2024 16:27:56 -0800
Message-ID: <20241119002815.600608-8-bvanassche@acm.org>
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

Many but not all storage controllers require serialization of zoned
writes. Introduce a new request queue limit member variable related to
write serialization. 'driver_preserves_write_order' allows block drivers
to indicate that the order of write commands is preserved per hardware
queue and hence that serialization of writes per zone is not required if
all pending writes are submitted to the same hardware queue.

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
index f1d4dfdc37a7..329d8b65a8d7 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -633,6 +633,8 @@ int blk_stack_limits(struct queue_limits *t, struct q=
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
index a1fd0ddce5cf..72be33d02d1f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -397,6 +397,11 @@ struct queue_limits {
=20
 	unsigned int		max_open_zones;
 	unsigned int		max_active_zones;
+	/*
+	 * Whether or not the block driver preserves the order of write
+	 * requests. Set by the block driver.
+	 */
+	bool			driver_preserves_write_order;
=20
 	/*
 	 * Drivers that set dma_alignment to less than 511 must be prepared to
