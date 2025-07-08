Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B430A1F3FED;
	Tue,  8 Jul 2025 22:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752012469; cv=none; b=GB4+N+mG8K3WcMHqWcWB9O66+Eim4qhuyvTGaFxrq+Ow74hQTkqdvIL8KY4Kpt+p4cNA/tCCmlPDLOxCKyFsajZJh9Y75mKkf99yZjHD2wOCoR5rgvU2n/bjwRSbJT/AerGVIOMxz0zE9Wv0jMb6POHSv/OQ/LC5Xu8qxqXIv5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752012469; c=relaxed/simple;
	bh=a77SCiD3j1qYqt6U6FBpM7Xy6ms9Ge4O83rjWqo/NvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ichz913VowgkRjjMH6M5FJ4RkjKM9hiDt8uz9n11+gw0hLa+zKAmu1WO4xbiiQ3KI+yLj9m5JAydHfnmMF3zPeuLgUPN3QYKYO/ovAaK/CzDQxvZoihg5iq4KP42yxz6v4ylPV4khlhYEw9sGon1PB/5i9KUP1ImmnBejOIv7lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sWPuGi9X; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sWPuGi9X"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bcFbQ6KQDzlgqVk;
	Tue,  8 Jul 2025 22:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752012464; x=1754604465; bh=VG5EE
	ZDQ0flMfgCzq/7liXFux/KSBsdNCiPU4vcTawc=; b=sWPuGi9XpreIIVK85eKgX
	05BUlzakvVbkDFRIo2ZRdPBhC5D8E1+Hw8YmN41KspW1UrrSi+uTs+5h6etlaBFN
	hS7CBpWaYWC85M6EoD9AsVHm1inUzZViXpW9UIn/uIdmmBg4BF4Jll7AmoQSwlr0
	egF/faKbi1KQ42cEXhIiY/A80jghnmso3b127muQHBOMDjySvjzLRbIAwr3vJNqn
	tDuZH02e0WnnJgYAV0RJiUf6DgFuHZlCm2pFWZclTUFFn6uXsqJCGiK5L5aVtpWt
	qsM/R0Nic9aBxqSiEjOvX1XyC2l8707u8bykw7jCHcvZZIDWh4raONjA+It6udrz
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QT7KJAgyErOs; Tue,  8 Jul 2025 22:07:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bcFbH2kt9zlgqVq;
	Tue,  8 Jul 2025 22:07:38 +0000 (UTC)
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
Subject: [PATCH v20 01/13] block: Support block drivers that preserve the order of write requests
Date: Tue,  8 Jul 2025 15:06:58 -0700
Message-ID: <20250708220710.3897958-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250708220710.3897958-1-bvanassche@acm.org>
References: <20250708220710.3897958-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Some storage controllers preserve the request order per hardware queue.
Some but not all device mapper drivers preserve the bio order. Introduce
the request queue limit member variable 'driver_preserves_write_order' to
allow block drivers and device mapper drivers to indicate that the order
of write commands is preserved per hardware queue and hence that
serialization of writes per zone is not required if all pending writes ar=
e
submitted to the same hardware queue.

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
index 5f14c20c8bc0..4dec1d91b7f2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -413,6 +413,11 @@ struct queue_limits {
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
