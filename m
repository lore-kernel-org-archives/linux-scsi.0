Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EC62E8B7A;
	Tue, 14 Oct 2025 21:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478903; cv=none; b=azVRJw5+5cy2MV7WLY+nSdQ1eqEGKOwiHmMVpYd2NXI71mpw840BHp15pg3oAmV9raVN2iGR7IZIUucrWUn2DaM5tuDSBSfoQFpn4bVKN1FN6sf9T1meyFEKWSGzHc4T5X161cgkPyDoxtGvE7Rmbi+YkLQvX6t7+/SyeqNk59o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478903; c=relaxed/simple;
	bh=LHI3+dssTH8ltlzh1v+Wpa6Sp9SfOug4tJlK6/gn9DM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGgakrALDsWw7tGSRdWHYtnm8/TG9FWSD6tkTeXbUYRmRTGCBJijsZ1TN2pSaNfZhkfslkAOze4jS50A+3Rew/mv7XfX4Gv2GCDa2CSlnf+hkrfeUzJHaJg147MTntms5FMqgt5AdscB8Xjs1CyVrbLN5tVDn3SYaELBhzZpXng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zbi8Kszj; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zbi8Kszj"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmSgS6G8kzm0yVD;
	Tue, 14 Oct 2025 21:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760478899; x=1763070900; bh=yiULL
	XPilBYdnCO3SuZwRutGJK6ns0AV24Hubd+F/ZM=; b=zbi8KszjhAwy+T1nCpDiF
	88tHI0X7HWZVLqCDQmk9aG/qIFYzxGuNKwgncmvEiMpZoqFscW1RzB98W/Kvn0mS
	yYvYRg6AN5C4a/kJPyP1UwRJEfE8hH8vtc+XICcABIW2V0QK8gJSkvA8zm3y+ZkW
	qSJ7W/AD3pu8xVnPUq0P4riYxrywq2nHrdViFoufZA+V3AAvEC9NeO/9CANS9itp
	24cKwTdHrOo7WHiIZ3qWdMyhg/4aOu4HSnt2Fple64vGKT2Sq4ay6Cr2xcIILM0/
	HbLHXgx49zAVEPlUckI1RClumUPHK87WAi7AoYBFcDE7VQ8HMtHKn0EDFeT7qLiQ
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sv9JmFodYIZb; Tue, 14 Oct 2025 21:54:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmSgM3Ft0zm0yVF;
	Tue, 14 Oct 2025 21:54:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v25 01/20] block: Support block devices that preserve the order of write requests
Date: Tue, 14 Oct 2025 14:54:09 -0700
Message-ID: <20251014215428.3686084-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014215428.3686084-1-bvanassche@acm.org>
References: <20251014215428.3686084-1-bvanassche@acm.org>
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
index 54cffaae4df4..553ec729a5b1 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -771,6 +771,8 @@ int blk_stack_limits(struct queue_limits *t, struct q=
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
index 70b671a9a7f7..9af9d97e31af 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -346,6 +346,12 @@ typedef unsigned int __bitwise blk_features_t;
 #define BLK_FEAT_ATOMIC_WRITES \
 	((__force blk_features_t)(1u << 16))
=20
+/*
+ * The request order is preserved per hardware queue by the block driver=
 and by
+ * the block device. Set by the block driver.
+ */
+#define BLK_FEAT_ORDERED_HWQ		((__force blk_features_t)(1u << 17))
+
 /*
  * Flags automatically inherited when stacking limits.
  */
