Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5667C25393A;
	Tue,  8 Jul 2025 22:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752012500; cv=none; b=M9tC2+JVWFTprVxzwy6wLBtSlil1jEYAhcDJOsgwYDVykjJsosQk6SgIh2qSrtiuSvnJfyUhbW87gJJOc+Oa1VZfkFWBNSp5KVSMGJRU/P4YK3+LYvnZqcGmSOozBi8/6UWNSWT0S44P0PwXDNTm/tb58QTQwfWV19Y0lCNeNQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752012500; c=relaxed/simple;
	bh=Zu6vSqmxcukieee3JufQ7CZA9MPWG9AOrjYb8HYU918=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLrlTpqwXSye4ke56kHNpVnQC+sMwEXgikVhEeJiHLjGHqfI+4GpKPoECKH16kzM91MY1WYjOi7kLLyUUG5aeQqRlDm0KTH1IBgQHM8qahaC749j29h0OcPEjV0dOJDiLKQOOGRF+f6cgIkM0VTfqQK7iaJDtV9l8vdZyHxU+ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QBMrS1Zz; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QBMrS1Zz"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bcFc23PxHzlh3sX;
	Tue,  8 Jul 2025 22:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752012497; x=1754604498; bh=UZVZc
	BJ6evy4O6Ie4aey7pelKnBwOFg5FdqzgsjjCj0=; b=QBMrS1ZzPQo2NgWsPxb42
	Gw7NHB5+dXIzTjmeJ06SgdI6q90BCQb4P/tFwcGw/gVo6KkT8iFxq40dD1IvbKx9
	ZYkojde92mCDm6q2nnuFUO5lMBHhgQusuRjtj9ofY+g9tA6ta3O4Z2Uq6Un4yBoF
	wIQod3CLFfumn2wqQxY5/UXXU/LVLm0PsG5coW8hEyNayKy5m6hs4bvdq9IYxop3
	qVyst1aRd4RQojwA0gnxQsvpMKuHe8603c6LNjeU6MIi50Vav3ROHh8ogljsMPVP
	WGI7QM5KHYf92P1OPR7F4jGg4iUayMAnCjcYFJOirNatzZ2DxOrp4nTSl7Rf7ILQ
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VtF7mSR_FdZl; Tue,  8 Jul 2025 22:08:17 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bcFbx34sGzlgqVk;
	Tue,  8 Jul 2025 22:08:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v20 08/13] null_blk: Add the preserves_write_order attribute
Date: Tue,  8 Jul 2025 15:07:05 -0700
Message-ID: <20250708220710.3897958-9-bvanassche@acm.org>
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

Support configuring the preserves_write_order in the null_blk driver to
make it easier to test support for this attribute.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/block/null_blk/main.c     | 3 +++
 drivers/block/null_blk/null_blk.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.=
c
index aa163ae9b2aa..45eaa6f0e983 100644
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
@@ -1979,6 +1981,7 @@ static int null_add_dev(struct nullb_device *dev)
 	if (dev->virt_boundary)
 		lim.virt_boundary_mask =3D PAGE_SIZE - 1;
 	null_config_discard(nullb, &lim);
+	lim.driver_preserves_write_order =3D dev->preserves_write_order;
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
