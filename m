Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF3B3FBED4;
	Fri, 24 Apr 2026 22:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777070571; cv=none; b=Vh+RHhA8MfWqBpu90cKG/4Nzhui1mOyvzuedN53ieGIR7YWJLwCtLHz3xRtP+Z8KgMbQBKugMBfqixBGbY8f8KuZzTeNF+IRjM6F/US+2rvz2jI8vhHB2WHHdK5g55eAtfDUZIt/ugUbSKtFzoWmIMEhvM+1bf92fcYIh1TF2/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777070571; c=relaxed/simple;
	bh=VmHREFg0sP5iGKWhsxQ0gnkojEOXLrvU96kmREemGyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biPt9ZdNOyj/h5zCaxpYXfSTSK1q0ZYx42Vvoin8gFPtEHWyPFW/j7MI2lTW4LE1TIlAJnxwss0CAxQeZJ41pZR9NDkd1pXpdj5qWndd6EtOLkdM1xgahXAf9I1/QPOlehF/1BklMTPEybelB8BDxWTjfcZTN9OccxfSju+Dl6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mJJt0tAd; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mJJt0tAd"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g2Sdt2sj6z1XLHYm;
	Fri, 24 Apr 2026 22:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777070558; x=1779662559; bh=hn5gt
	/kr7QDgHfqk6BJtfvqJ62o4kkrmwOKTA2D2kLY=; b=mJJt0tAd9F+e7XezCKlu+
	cMif01CMnok1UpTVdunNApamb3sxfj5lSTzixS/6imv6K6BFtWSWD6L3OVydV10h
	Y/QJy6zIp0IrelzGTzpXolfFjgUKEzXMzEDPUc77tlirppNFgYcP2gjGUufP5XJ9
	CcUfmNrZ14Dmh3N7kBdVenvCJOmCHvTlbTL9hW/67TBWNYNbpCfc5ImgOgVJg+tm
	+4wcm/I5aYg0N+JkbjByHd5CqEY12WTCYbkCdvvGApLYBBKvPHtiIvDRzEtVGXjK
	6bt8RMxSpNaEhZiKJcL38rYWDqcx0kTAjg7OSi1kcx3XxckhOiteClSqViXO3tlZ
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id x6VTYr4bWKdD; Fri, 24 Apr 2026 22:42:38 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g2Sdm63KVz1XLF2r;
	Fri, 24 Apr 2026 22:42:36 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 11/12] dm-linear: Enable copy offloading
Date: Fri, 24 Apr 2026 15:42:00 -0700
Message-ID: <20260424224201.1949243-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
In-Reply-To: <20260424224201.1949243-1-bvanassche@acm.org>
References: <20260424224201.1949243-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Set BLK_FEAT_STACKING_COPY_OFFL and max_copy_hw_sectors to enable copy
offloading.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/md/dm-linear.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 38c17846deb0..3de8bf5f11fb 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -119,6 +119,11 @@ static void linear_status(struct dm_target *ti, stat=
us_type_t type,
 	}
 }
=20
+static void linear_io_hints(struct dm_target *ti, struct queue_limits *l=
imits)
+{
+	limits->features |=3D BLK_FEAT_STACKING_COPY_OFFL;
+}
+
 static int linear_prepare_ioctl(struct dm_target *ti, struct block_devic=
e **bdev,
 				unsigned int cmd, unsigned long arg,
 				bool *forward)
@@ -211,6 +216,7 @@ static struct target_type linear_target =3D {
 	.dtr    =3D linear_dtr,
 	.map    =3D linear_map,
 	.status =3D linear_status,
+	.io_hints =3D linear_io_hints,
 	.prepare_ioctl =3D linear_prepare_ioctl,
 	.iterate_devices =3D linear_iterate_devices,
 	.direct_access =3D linear_dax_direct_access,
