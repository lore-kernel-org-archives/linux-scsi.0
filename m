Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA65EEBB;
	Thu, 17 Jul 2025 20:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752785917; cv=none; b=QW+g3hRhK5kcIcDRqs+nbVpUtfCJmukteok2IErPpVC46NU8oZPLYVondOnBt3HR5fdq7gYMmzxfVOQ5rZjkxrI4dW35p+7R+u5gROpyc2sdH+NPtVhKH4A4mQJfpcEIoj/k6aiFXULXO7sMLbU/dSP4A9erTVfoUCr1frYjsM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752785917; c=relaxed/simple;
	bh=Xk/spz0ltKLbpzkXY1ZvIE+5kgZSsWjem1aBJFNdmsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOk0NiJRBhZ4cN7HmSx6xtNoT8wStM18tUr6CZZ8cMN54M97gGkdzghz8uGZoTqp1RZ8qMT/X/huLH5Y979wVTBe3cA1ffKs/sbLMGoijJS4eI6uFQ9DL0ZdUp0gMfZu+sBBxxG4+p4xQLoHSX5l7P37pL2MsYUQp2moZhR94Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=e9ShJ0sn; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="e9ShJ0sn"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bjldQ4C42zm1742;
	Thu, 17 Jul 2025 20:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752785912; x=1755377913; bh=cHZ+C
	MX08VwpxegvK0JxXA+f4nVFeQ5nw7Oq96A8w9Q=; b=e9ShJ0snuCwVb0H44OyiO
	GlmayW2qGZV6m2HEG3etaWq13r169Bw329RcprYVyHUyOZj4oRt5O0KL4EnXY3zD
	KBCwn/JPCYsUxftw0soNiXjXte35Q4pBX1HV9M4pUXFlKJ9hQDTvizpmWWwaF7Q+
	oJtxb7qV80XAbROuS/ldHTglelZJ5EYMEAiVVPbOVCShn3gfQxEeCt4kDo48VQsZ
	LzO1RVYr8HDpsJw2MkVvgY3hDtKFkROIaGBH+kNPrdwzk/k5mti+Gv3mo8dAqbhu
	21PnnbEmmD2oo+4ZbXg6fmPNZxE23lbMn9lRyA33Gq+wap6e2FEcug/OOLeJoyvD
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SzMnVM-4NZbi; Thu, 17 Jul 2025 20:58:32 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bjldG2727zm0ytX;
	Thu, 17 Jul 2025 20:58:25 +0000 (UTC)
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
Subject: [PATCH v21 01/12] block: Support block devices that preserve the order of write requests
Date: Thu, 17 Jul 2025 13:57:57 -0700
Message-ID: <20250717205808.3292926-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250717205808.3292926-1-bvanassche@acm.org>
References: <20250717205808.3292926-1-bvanassche@acm.org>
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
Cc: Hannes Reinecke <hare@suse.de>
Cc: Nitesh Shetty <nj.shetty@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-settings.c   | 2 ++
 include/linux/blkdev.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a000daafbfb4..45ab1d644720 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -698,6 +698,8 @@ int blk_stack_limits(struct queue_limits *t, struct q=
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
