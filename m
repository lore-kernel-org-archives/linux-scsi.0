Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C044323AB8F;
	Thu, 24 Jul 2025 21:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753394319; cv=none; b=HGfY44CuekSvJ4TVDToIYr+ZXCOuGTRXRnWor3yk+rutsmhDi3wObdKPqcAfQvnz4cPTQoGmiH8IUU5WNVnXyDuwdIfByJEsO59jfTvlUvUVtnX9JkUwRMKUU5MdjckODsUdndJoOpnX5/wuxbBsUWvwboeQ8OAcGKi0UQLUno4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753394319; c=relaxed/simple;
	bh=KD49hVVjl7HFiVseyzjqHESAjKwqe/0wdxKuOTAOGgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THpzKg0xsIfHXaeuZe54WroirJEBE5SLKdxwK0v3X+dZLtaD0WkNuEfOoOEajEAos8QEKlBABfe5hc6j6wJpiuMDcSPnO8HBS+NmefUZ/HdL6OA6aQDJ9TH+Zu9BAnk8iVFfn2q17u6iss0bHJyb9WnrZcNx+APiHjy7E4dEnJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UQRb4QbY; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UQRb4QbY"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bp4dQ0fBgzlgqVB;
	Thu, 24 Jul 2025 21:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1753394312; x=1755986313; bh=aXMKF
	tBB8Z76C9a40LetHwrXjeC/fI5eOcWLC6q0cms=; b=UQRb4QbYnSZB4wyk16kbx
	YRpRGk0VAQ1O0ScM6reXGNHjr/QWPs50Wwv0A2mVK30kSvm4XO9R1vcFd1FZBIcy
	Ec9t5MuHIeFTa8SHB+5Gk2PhGSA959U/iMyb+FCo4PbtUmRnzOT3ZsWKsH4lpBYR
	gS4LKv5NGbYv36N565z/2+I5BFT4CAememGmAX0lihT69juyn9hVFhH3cYQ6ZFLi
	G8qlfPZPgrD0HlSXFsM3Qh2axb/a9EN9uLvn3y2SJf+bJh4mi+GqIVBCgRvpJgm/
	HVkJj5klj6wZkdtN0zKlgAvMsgZpZhKWZgRQzNKA3UBDJ+SAXuDNm9axtEsE6DcZ
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fMFDaQGjTP6h; Thu, 24 Jul 2025 21:58:32 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bp4dK0mBNzlgqVS;
	Thu, 24 Jul 2025 21:58:28 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v22 09/14] null_blk: Add the preserves_write_order attribute
Date: Thu, 24 Jul 2025 14:56:58 -0700
Message-ID: <20250724215703.2910510-10-bvanassche@acm.org>
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
index aa163ae9b2aa..8ead29140a3e 100644
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
