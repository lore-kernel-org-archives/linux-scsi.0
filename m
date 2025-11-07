Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980FE1A9F96;
	Fri,  7 Nov 2025 23:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762559668; cv=none; b=LImOUOQqfhl2z/Bz400hX9/I/yOa6yzz2lqsqGzibd8HcpyUb8k3Kvw5nJgAYCQKa4LPpEbNYYamlvlZcuXVWzZ2xHasltfrY63LwPneMC34JRMppptQKIyfufIXNiiXJGXgDAacsXFJTEcNKM/pGrzY2Bf15mRk/06YqFubOsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762559668; c=relaxed/simple;
	bh=CbACIb4w1tFhnw4QYyjKqeq+3dMk4trNQ+x2/6EKh4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRZc5z8HJqZrZp51ZLM9uBaiBG9m9TJr3fyiliIE1xkWTlzay78P+hGuMl3Fn7JyZV6FP0LG+t59zIjY779Waxs6FupIMpW6UYGOi7V5fOzjD2kguLA7RCdYEZBk0DXBQbXGiTrdKzwRpO2WBAI08ZIytdHJxhNUYG8OyaSWXlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ULIsk4gZ; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ULIsk4gZ"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d3GB957nzzm17wj;
	Fri,  7 Nov 2025 23:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1762559664; x=1765151665; bh=ORkYr
	QRKQBr9W5GQe4OnZASRzssHHVDI5lpHJ0Cd8Cg=; b=ULIsk4gZlydfzkZIob/CH
	R6Ps2ZmmCsHGEjKjoMMDuDUgZsy/rluE9U0TtJiCezjqNlTin1DuWvriZH8IW6Ln
	V7oIsiKA+9i+8PfWYVh7ITBY2pd7OjtnKCcENu86ox7LzHT+XS4CjjxCOEn/UQS3
	RN3JujG2OAffQZhjxQrBKytYmHAJFioMV0w2t3yIEx8CDNjA/f2pRoMoJHzBIsoT
	iFdFIdP41fjm4QowlsCVqOkWtiJlYY1uJrCWOzTi02EFvK/XXLPhrN9Z4xRYWHsX
	kKyzt/EEjMSn2NL5PXlFeT36BYM9zYldBOGzvLAauvvd2W17vilGL4YqOtGw3aIV
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UVpgzZ1rfkMD; Fri,  7 Nov 2025 23:54:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d3GB43V72zm17wy;
	Fri,  7 Nov 2025 23:54:19 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v26 12/17] null_blk: Add the preserves_write_order attribute
Date: Fri,  7 Nov 2025 15:53:05 -0800
Message-ID: <20251107235310.2098676-13-bvanassche@acm.org>
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
index f1e67962ecae..76e82f9c53ca 100644
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
@@ -1977,6 +1979,8 @@ static int null_add_dev(struct nullb_device *dev)
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
index 6c4c4bbe7dad..93bd4d576674 100644
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
