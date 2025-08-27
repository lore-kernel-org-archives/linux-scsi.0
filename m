Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5EF1D5CEA;
	Wed, 27 Aug 2025 21:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330219; cv=none; b=Fum4aD1+Xxa8uUDfxkosP1EfuOADvxnXNRsNBy89p/VBXYK/vHaRYvL8pbi10PP4mAkUKPGlKFnOMSYRxllgMDSGhki1XgvlErCLNfJBYRb800xgzfkXw2TpUjA19mUDiLFl2dccbh0Qvr8j0iR05E4rvteN5ad3ayvl9r4DsZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330219; c=relaxed/simple;
	bh=jm4vEhAIg+iIi0n0lNc9OTu9x3SuXNrJw32RMmGPQVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFEd+iBSF5CBeCZNOsDHlAudp3K2gtk2qed1zS7G0Nu2SQwvBVLTlSLLM2jqHoON2KmhktEfTR9hv13Xwn6v04h9cP0kW6VLsoXad5AZBJcYlB+gQCPX9CIksV3hUieqUkau5KrQB4rrvPUcqg9wEy5BnvNhH9A52p8ZEIWfVWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2O/91sOb; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2O/91sOb"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cByNy6VRpzm0yQ2;
	Wed, 27 Aug 2025 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756330209; x=1758922210; bh=ZmfK/
	Y8zql2lHkx0qTJIfDp2VePRZeUtRA4psWOo5vA=; b=2O/91sObNqu0gBfQYG5rG
	ONuggO74VGHk211CfSJQBa/Qaybg5Dz1y26GmpxjvYQXqWwyja4TaKlarhV0w6U1
	P6danqG+oS1d00IKxB920f5wvjJd5uf4f05XoE9Y/3JRJg7ViK9EZOZfwUmM3TTo
	lJLicNikn0uoQRhZOVzFjrFyVVwDGsEmImMi0eSMu6lYApKXsUC0yhkbpDebOnCL
	oz9gqHKxer9sH7SBoBcPIuSPGfxpbcSunxHz+wCqsuVX7ZDr21qZv/60QvuvdLew
	0r3ore2uwlOWpPlTBZ2qN3MhC0Ebgx8QNEmg7BTtXDoH9SGXDCB3NRa3EctLvFpR
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4x61Peynr9zA; Wed, 27 Aug 2025 21:30:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cByNs5Lz0zm174D;
	Wed, 27 Aug 2025 21:30:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v24 01/18] block: Support block devices that preserve the order of write requests
Date: Wed, 27 Aug 2025 14:29:20 -0700
Message-ID: <20250827212937.2759348-2-bvanassche@acm.org>
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
index d6438e6c276d..bcb9f115ba5a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -777,6 +777,8 @@ int blk_stack_limits(struct queue_limits *t, struct q=
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
index fe1797bbec42..23bb2a407368 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -338,6 +338,12 @@ typedef unsigned int __bitwise blk_features_t;
 /* skip this queue in blk_mq_(un)quiesce_tagset */
 #define BLK_FEAT_SKIP_TAGSET_QUIESCE	((__force blk_features_t)(1u << 13)=
)
=20
+/*
+ * The request order is preserved per hardware queue by the block driver=
 and by
+ * the block device. Set by the block driver.
+ */
+#define BLK_FEAT_ORDERED_HWQ		((__force blk_features_t)(1u << 14))
+
 /* undocumented magic for bcache */
 #define BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE \
 	((__force blk_features_t)(1u << 15))
