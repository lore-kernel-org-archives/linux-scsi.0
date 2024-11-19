Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADCC2BAF4;
	Tue, 19 Nov 2024 00:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976128; cv=none; b=GW5ApUuYYpcbUqXJmtQDrqag9PU0jaFUehlyj99cLldrPwSiMkCJf1A10m+rBg80ocBUy3gyAumkNP4fBRbHYT55cEaIzfxKcKesUpBrhelzaVGyRjdUusi65nF8lhBLewAzgOW4ceaK6C6rGz0GU1FRArrJ09cNAJHD23a3TGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976128; c=relaxed/simple;
	bh=0aO/tJS1Fk2M9sXF8jIs8qBBa5ynBt417BVu3n/cZIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOn59MwPGTVEp6U68bFGgd8wqZl+kqRiCN9YtW2nY0ZocONFxJtCiLGwCrXMF6NtKsIJ4mYRzTJVoHRRhcd0n2R3g7bbV8LgJqMcdjn3+29TetuHJRdBCT889WHmvUKLTwx1prnV4Dq7W12zDJ+efd3xPQzxFozvwPrMNX2PWDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZNf9kpMW; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZNf9kpMW"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XsljB2C6mzlgMVN;
	Tue, 19 Nov 2024 00:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976123; x=1734568124; bh=NS2JS
	s8lR/V97xTiYuhrMQeh4/Cxjgl/9C2s/Uc66TA=; b=ZNf9kpMWmMMGbyu7biT5Y
	IqjRNnT/s9PcSooJ/3XQvq4WCYeWiWb7tbllvEdeLwfGvz8MXmlS2B3lBJvrY9c6
	ce/0HA/dXGt8LJ5e9QNz9ruXqAqhuVrfETgWf6DjozkM8tLfnKxE3R7hdCgMy+Yf
	YuCh/DdBpy4c9J1UJ82FS7lkNbr15HPojmV+BqKgFfLZUGVkscfpjwXf+80Hy4Y7
	Mn144lBp/SSXAxEvoQeQztSpTMEcEQAoOMorgap5I9q62Afbsqg0Tv4n+nphHVg+
	SIYupk8POAP63WDYIOsa1eqkBMFtTT86CjFdqXYrh/uXIz1pcDF8dSp0g0RLqXoJ
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3ZypB5pine44; Tue, 19 Nov 2024 00:28:43 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xslj55fvbzlgT1K;
	Tue, 19 Nov 2024 00:28:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 08/26] dm-linear: Report to the block layer that the write order is preserved
Date: Mon, 18 Nov 2024 16:27:57 -0800
Message-ID: <20241119002815.600608-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
In-Reply-To: <20241119002815.600608-1-bvanassche@acm.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Enable write pipelining if dm-linear is stacked on top of a driver that
supports write pipelining.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/md/dm-linear.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 49fb0f684193..967fbf856abc 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -148,6 +148,11 @@ static int linear_report_zones(struct dm_target *ti,
 #define linear_report_zones NULL
 #endif
=20
+static void linear_io_hints(struct dm_target *ti, struct queue_limits *l=
imits)
+{
+	limits->driver_preserves_write_order =3D true;
+}
+
 static int linear_iterate_devices(struct dm_target *ti,
 				  iterate_devices_callout_fn fn, void *data)
 {
@@ -209,6 +214,7 @@ static struct target_type linear_target =3D {
 	.map    =3D linear_map,
 	.status =3D linear_status,
 	.prepare_ioctl =3D linear_prepare_ioctl,
+	.io_hints =3D linear_io_hints,
 	.iterate_devices =3D linear_iterate_devices,
 	.direct_access =3D linear_dax_direct_access,
 	.dax_zero_page_range =3D linear_dax_zero_page_range,
