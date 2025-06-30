Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD9B2EA149;
	Mon, 30 Jun 2025 22:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322662; cv=none; b=Rxi9Iyik4c41WLiLC/n6J3ZMUuuzUdmEg8l9abZxWfOOm945/3z2Y4cKej4QLpT3pXq6fqBYzXTpS9k2vyog14yzruM86LYC8313rIYHlkjNYL194WfKbf8QpaygfcgxchUPdL9sv9Z2OvepQYCyWhGa/PTPdtT6y+cOWGFLhd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322662; c=relaxed/simple;
	bh=Zu6vSqmxcukieee3JufQ7CZA9MPWG9AOrjYb8HYU918=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfheJnS5l6izS2farR6vqWuz6hKm4ptKu4eQNA1iGtHn+GiKElOmDw22i9eqY8LOjff9N4pSM8qI6NTE7TTgEN/UMqXGnyrut7oXGwaeHcRJiUSixHUlaIE72MH6UeRgzGV+5hK7EU7d63qb5EzmZGXgWqz6t48Md04bTcJ8nCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XCLgt3LA; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XCLgt3LA"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bWLTv65Q0zm0bfj;
	Mon, 30 Jun 2025 22:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1751322658; x=1753914659; bh=UZVZc
	BJ6evy4O6Ie4aey7pelKnBwOFg5FdqzgsjjCj0=; b=XCLgt3LAdX0D9d5SRSFdy
	6o9NqResOYCBDgGfNW6CeQ/ZJsBSqQMiHva6J5eMyTQUbicTZAfvrspaiJbce8Ht
	1lH49ahhkM/5taeVUl24MzeLCuqjBQYBIP4K7otFUXufj9v++23+8A0jJYh7RTDy
	o3s4U/znhr4G9vDzUKlcEiSepBmtC/hVr+g/4BuZqneP82jP3xHbXDIRpvR7jMUJ
	nGreYOl0owY2LcujCL182DOFmxfP1M5OvvA4PJlZjbDp0ZxX5SK9F+EApO1J/myV
	aczkowq+e54SGExxa8G5zAcixWMeDVlAYMa88fHk7REtN65iKxNt4bbPzwcbCM9H
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id F2qxRhm-qId5; Mon, 30 Jun 2025 22:30:58 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bWLTp5fSbzm0bff;
	Mon, 30 Jun 2025 22:30:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v19 06/11] null_blk: Add the preserves_write_order attribute
Date: Mon, 30 Jun 2025 15:29:58 -0700
Message-ID: <20250630223003.2642594-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250630223003.2642594-1-bvanassche@acm.org>
References: <20250630223003.2642594-1-bvanassche@acm.org>
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
