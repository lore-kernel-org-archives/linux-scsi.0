Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6A8207A22;
	Fri,  7 Nov 2025 23:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762559615; cv=none; b=sWnfv/iWEmdrEptkZf+Qp2Xx9TAQXu9oh+Ce6+NsGidU3JTzPybpwRAWj8RGu8QIKoKH4Dj4bQTGYJDFe4OvsdNzPk45SogQgO8jIiE68vQscC2xcJziT5l3Xs0H/eOzZ8CvBvGfHPvj6le7HTwp1ZdYayVya/4lnzcFe62lG8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762559615; c=relaxed/simple;
	bh=Bo6wmpOtlElTIVpOQsLAkzwy+ZhvRfM9DLYx0XA/yU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Njq66Lg8C0aWNGsy2FUEdIv1ZAt1K3m1iu8J7ToUt0j+Y0RJLQFTKGG4UeeDLODYgicMUuOH4N7kiL398XjuRPg5B4IU1tu9lc8Z0WvoDrafzKf/hK1fXYiTAr+XDtpIg9sR/VC0EpAX0/yogWEKwrPub5JGdn17zOJVRQX/LAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oydhazCZ; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oydhazCZ"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d3G9910nMzm17wt;
	Fri,  7 Nov 2025 23:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1762559611; x=1765151612; bh=LVtiz
	nuuCfa5qyy+BfY2/xEeszgr6VBWwddcsa1rvDs=; b=oydhazCZTRQN4kLHgQ22l
	lGYudiOt7kGV+gS+H3JmeBxNkogLkc71j5Iw4AWampD8VBOJVV4OoDrG2AmVRNFF
	MbqVENeqEr/zUFoZRaq5ubaxU/p4iYxxHNHuQXKIkJ7oghfMp1tl+5wBYUwNOj43
	mm3I+3iaeii8Kuu2+hLLt3qaDvbwEmWwlpGgyePcVVmH6eHUL8RE81FhWtwtvv0O
	1UU0vRxGdmJmTZk+NM4SrB946m+PjfMtX7kMMGxvTn38pXjmH1QwzuMw8qaKupwC
	FwQgFFOyE4PCv7WaSXgaFD8Sc2tXV78l/J9NBaHfvyMpS1qRBKc1t/eXW0r1L7rL
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SUf_0r9W_dOR; Fri,  7 Nov 2025 23:53:31 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d3G936l42zm17wj;
	Fri,  7 Nov 2025 23:53:27 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v26 01/17] block: Support block devices that preserve the order of write requests
Date: Fri,  7 Nov 2025 15:52:54 -0800
Message-ID: <20251107235310.2098676-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107235310.2098676-1-bvanassche@acm.org>
References: <20251107235310.2098676-1-bvanassche@acm.org>
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
index 78dfef117623..edc25f2d803c 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -802,6 +802,8 @@ int blk_stack_limits(struct queue_limits *t, struct q=
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
index 2fff8a80dbd2..b97132252ec2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -348,6 +348,12 @@ typedef unsigned int __bitwise blk_features_t;
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
