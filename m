Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998712D97AB;
	Mon, 11 Aug 2025 20:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754943032; cv=none; b=HHA/3IkGaJSV3av2iZmPQczR9u0+r/WVy/9bHNqdta82Nm6zTzANQfdqEJgEFMQhVp4YDg5vXplD/EDzc3Jjy74sXHoAdaWSrYSjjAy4b6oIgF3nfeOsNs8UHJHTBBdqFNNO7v3TjJyIk7nBZ3szuCzILDZPwBNZXO6ZOWJ00oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754943032; c=relaxed/simple;
	bh=WUzqVzdwt8d5EbGXp9J8vx4usgIJngjvJJI0nVzMmEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXJ+IreodDjcAk8Tb8VcP2Pd1qYtMoPDpwj5IjIrahQTQgzg/V1CfWWnZFCVFp9hPaOf/MMx++Rw2O7FD2FLTIg5ZfxH6ebFcG9B0czvGTffHUMaXYXThofc0VA6997iKlsNGVjITDf+qjl4LsdFEywZdUnt0K4BmY2ik/wbPdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Dpvr+Y4x; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Dpvr+Y4x"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c15NP6t9czm0ytW;
	Mon, 11 Aug 2025 20:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754943028; x=1757535029; bh=KnpS9
	uoGMHDpkZkGMfRiBwHexHz3m9zb0LysquTCdFs=; b=Dpvr+Y4xJym0uC8Hid3oy
	Ju8QKNglncSIHWYePTKXlVILx+TM3WYJPUU1BAsFgk0w3tFtYHaeKi4BtjDnI2rq
	6Jd/vR381yIi2+RWWpCNiJh0IAWrD2caPoeaqBWNUNqbiKz74wD4PW6+WDMYmhYp
	KYczVCSl5apdjva0ytrcCCR7mnOx/K8XV/evk/yXiJzwUTgKVClKTgiPdvfX/PUG
	TTkdee+X4fPrE9x7cXiJCN5pi0hmWzO/ceEhD9wBdV2y0KYN0JEJ6qhWxUH6AX17
	ui4uJUEuPyZ2j1aqgPCD+qPGs+w42PgAczx9osli1CsfeGathmWodZKRlVOSqQ40
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PY1bRnNu6hzM; Mon, 11 Aug 2025 20:10:28 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c15NJ49kqzm1744;
	Mon, 11 Aug 2025 20:10:23 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v23 11/16] null_blk: Add the preserves_write_order attribute
Date: Mon, 11 Aug 2025 13:08:46 -0700
Message-ID: <20250811200851.626402-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811200851.626402-1-bvanassche@acm.org>
References: <20250811200851.626402-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Support configuring the BLK_FEAT_ORDERED_HWQ flag in the null_blk driver =
to
make it easier to test support for this feature flag.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/block/null_blk/main.c     | 4 ++++
 drivers/block/null_blk/null_blk.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.=
c
index 91642c9a3b29..86d72979d899 100644
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
