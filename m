Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E972630B52D;
	Tue, 14 Oct 2025 21:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478976; cv=none; b=pL0ADXRfz/onKhcO3gNkHO50H5cp+ZZr9rqQuMud4TFVqEImgEv04WdEzZVpWxDJj2yW4dmsZz5dWhlGK3QsffaBSay/eI7HCM16wSiGHauKi8I2s6Zw/E0ntQU27sMJp6YXKbXay03yq0FCcinTWdXSHu8AEPzMr+xT909JpKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478976; c=relaxed/simple;
	bh=3GTCInRSiXB8icjiI7aVCug1TbLNoQd5RusQVfSsU4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7w/LqLfyAVYEVsxI7aqfJTfMRQG1wjaGlGyCW7XTl7B8NoTb5W/3mjznkH+jEH7ii8XqcHFepkpbzxHW9p1yXUY/CQcLXf3IISgdkF7p9ZCCofnROWkPoRRZpd3vN8xup0EgvfFdYpHyxt2fO6DsTG/6lCbPaJLPAOgk01zopM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZvIZkhcU; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZvIZkhcU"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmSht1hvBzm0yVW;
	Tue, 14 Oct 2025 21:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760478972; x=1763070973; bh=ry6ZY
	feh99LUPWmnmcd5Ho2bfyDmb5UxmjOKcCvXu7I=; b=ZvIZkhcUwGBP4pJNDVAqJ
	f8K3TJn1kFPykQO/SOJMddrAAucycdAFghFVjFiEP1w9RWTfSQZIyf4qoA8/fSC7
	2d2sT44ClHclvPCrdmmd2WFepHpqMQtD9bMNQ8zBFc9o8Zx5J0SjEjQFr2l5grTS
	UhD7G61wzKlhyZXGlyp8miUE6hgW3dpkPzA+Zf86rBlj5WceEv3ebdjkpG4pWPqb
	WrbCQe44lhJhOGAhRM7vUgNiDY1T4N9Dpawj6l34Jww2eQftPGLE5LmVtobyhiBw
	mCPPwD60WkdDEFEvdyHut8jsmN7ggRf7zd8Z+7m/dhyZ3j/EJ5foSPUxZMoIMMAP
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nnJ_nc_cipeA; Tue, 14 Oct 2025 21:56:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmShm6ClZzm0yV3;
	Tue, 14 Oct 2025 21:56:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v25 15/20] null_blk: Add the preserves_write_order attribute
Date: Tue, 14 Oct 2025 14:54:23 -0700
Message-ID: <20251014215428.3686084-16-bvanassche@acm.org>
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

Support configuring the BLK_FEAT_ORDERED_HWQ flag in the null_blk driver =
to
make it easier to test write pipelining

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/block/null_blk/main.c     | 4 ++++
 drivers/block/null_blk/null_blk.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.=
c
index f982027e8c85..0284e64a1648 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -475,6 +475,7 @@ NULLB_DEVICE_ATTR(fua, bool, NULL);
 NULLB_DEVICE_ATTR(rotational, bool, NULL);
 NULLB_DEVICE_ATTR(badblocks_once, bool, NULL);
 NULLB_DEVICE_ATTR(badblocks_partial_io, bool, NULL);
+NULLB_DEVICE_ATTR(preserves_write_order, bool, NULL);
=20
 static ssize_t nullb_device_power_show(struct config_item *item, char *p=
age)
 {
@@ -613,6 +614,7 @@ static struct configfs_attribute *nullb_device_attrs[=
] =3D {
 	&nullb_device_attr_no_sched,
 	&nullb_device_attr_poll_queues,
 	&nullb_device_attr_power,
+	&nullb_device_attr_preserves_write_order,
 	&nullb_device_attr_queue_mode,
 	&nullb_device_attr_rotational,
 	&nullb_device_attr_shared_tag_bitmap,
@@ -1979,6 +1981,8 @@ static int null_add_dev(struct nullb_device *dev)
 	if (dev->virt_boundary)
 		lim.virt_boundary_mask =3D PAGE_SIZE - 1;
 	null_config_discard(nullb, &lim);
+	if (dev->preserves_write_order)
+		lim.features |=3D BLK_FEAT_ORDERED_HWQ;
 	if (dev->zoned) {
 		rv =3D null_init_zoned_dev(dev, &lim);
 		if (rv)
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/n=
ull_blk.h
index 7bb6128dbaaf..08b732cf853f 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -110,6 +110,7 @@ struct nullb_device {
 	bool shared_tag_bitmap; /* use hostwide shared tags */
 	bool fua; /* Support FUA */
 	bool rotational; /* Fake rotational device */
+	bool preserves_write_order;
 };
=20
 struct nullb {
