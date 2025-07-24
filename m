Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922AA21858A;
	Thu, 24 Jul 2025 21:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753394278; cv=none; b=Co4mjxcWzZswoSnz5hyHFu+rhECtUWyrrPjD9+PFz7mNJhNjvDai4aj9Kr/YLxM1c1mCKYg/sd4EGAdFUOnbQNb2557ilrGOxwxwPB+swPXIATPXXG5ODn55FCE1OeugU+xMtAJYerLZYCVZ34kwxcJejeIxAo+PoBMI4DEpuw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753394278; c=relaxed/simple;
	bh=n2/ZdxramHC9dJCgBO+ATFsWtWLXYuwpe53RMd7WQ6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sifaFMot4Cs19d6Uyqu9lsRJU/LRlwUrvEOYylu9N234zHd6EuGWYMNQv9QjG3vqmxxbDYtRUL0rPm5APe61xaY66EzIArJQaWnirI8nV6cMYn/U9NhBsoNqV2EjI2T9k4N8KASDUxR4+Ye8FN77u6LlyI+D92Otn/7JBr4iAyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BNTI+p3c; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BNTI+p3c"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bp4cg4V9ZzlgqVB;
	Thu, 24 Jul 2025 21:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1753394274; x=1755986275; bh=NgvXt
	TbtTmTy37Ese1U4PV/TpB9/lL2EBwiDdIM5384=; b=BNTI+p3ci5O1uRVH1W8n6
	RXAP8qCA6WDmpwYaELps6D2gD0KqkVjirGZy5JMPMFis9ylHXsmWv2qu7NdlQv+k
	rcFiRLD4/+kb5PmFiX4XDiT1SUxF1zkTtlmSZircT6jCW/r/ndD4XloHCBpWsuBf
	9C1gasU128nRhEPuVkqwFbpaOe4+AF9VXO9jelcSISh9vZylKa1TTkB2MLuEPu5h
	voa12A65dSgvb3ZqeeZB8rdhFD+wvEIsfV32OSTgbj54pZmBZ0BeKklQ6i4G6S+O
	64g4ji1mNBSndf1o490d/v0vPpLb7nfs14xeOu6ORRNQa6A3+XIeZGzoRch6AGEU
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9xpFYhYNoZTU; Thu, 24 Jul 2025 21:57:54 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bp4cZ0DVBzlgqV4;
	Thu, 24 Jul 2025 21:57:49 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v22 01/14] block: Support block devices that preserve the order of write requests
Date: Thu, 24 Jul 2025 14:56:50 -0700
Message-ID: <20250724215703.2910510-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
In-Reply-To: <20250724215703.2910510-1-bvanassche@acm.org>
References: <20250724215703.2910510-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Some storage controllers preserve the request order per hardware queue.
Some but not all device mapper drivers preserve the bio order. Introduce
the feature flag BLK_FEAT_ORDERED_HWQ to allow block drivers and stacked
drivers to indicate that the order of write commands is preserved per
hardware queue and hence that serialization of writes per zone is not
required if all pending writes are submitted to the same hardware queue.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-settings.c   | 2 ++
 include/linux/blkdev.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a6ac293f47e3..1ac35cbdcad0 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -714,6 +714,8 @@ int blk_stack_limits(struct queue_limits *t, struct q=
ueue_limits *b,
 		t->features &=3D ~BLK_FEAT_NOWAIT;
 	if (!(b->features & BLK_FEAT_POLL))
 		t->features &=3D ~BLK_FEAT_POLL;
+	if (!(b->features & BLK_FEAT_ORDERED_HWQ))
+		t->features &=3D ~BLK_FEAT_ORDERED_HWQ;
=20
 	t->flags |=3D (b->flags & BLK_FLAG_MISALIGNED);
=20
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5f14c20c8bc0..3ea6c77746c5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -337,6 +337,12 @@ typedef unsigned int __bitwise blk_features_t;
 /* skip this queue in blk_mq_(un)quiesce_tagset */
 #define BLK_FEAT_SKIP_TAGSET_QUIESCE	((__force blk_features_t)(1u << 13)=
)
=20
+/*
+ * The request order is preserved per hardware queue by the block driver=
 and by
+ * the block device.
+ */
+#define BLK_FEAT_ORDERED_HWQ		((__force blk_features_t)(1u << 14))
+
 /* undocumented magic for bcache */
 #define BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE \
 	((__force blk_features_t)(1u << 15))
