Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4C32E1730
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2025 21:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765919263; cv=none; b=hRJNxiVlIN4QeywQLWpTOPhcKiyw6BswaNxSQiLGud4PZF6YuZmedCdaXcgcWlVIrvp6fo2D/Z/UKZKp4Z8BlqIUDQC5J+Npio17WzcFHC/09axBnXO09Cm4/XZcW9VpBpjebU7HB1eNSsKOLzP8md74DIbuPW56dvB5MsE5hvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765919263; c=relaxed/simple;
	bh=Cu5vrvlPgGjGRWsgdEUhCxrRkwOa266FrD96NzdqOvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpoJTPm4otZNMNWrIYSDMC7bVAqkweaDXrwEVsWYLQtGvqyFQ3SNeMlZY23KUzYbTTb8lNG2s3D31anBXEC2HBSicSn002CT0KUS/Bo+t0tuojOFgJx6Bn/jkDmOP5/zJh6ez0rOfucPcP+eRgQTC0ruBa2hudCOiGtL2JD1Teg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RZn60Fv7; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RZn60Fv7"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dW8dm6jwDzmP4t9;
	Tue, 16 Dec 2025 21:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1765919259; x=1768511260; bh=Azpct
	817KBFtDzsWL9yT8Ex2EPhPhoRG5RunqeY1zaM=; b=RZn60Fv7UhRSpI6Tz8OJi
	OBVvFq6KHU+DgVAiLTLSthbmeI/j2jstpIl1Az1+heXEkN348wVx29Isi1PDGNDV
	r9696uLOgmCMSFC4UfUXE+rxSF4QdAfIexTMp6Y8KxlOo4Ua8ykqxn9MufGqXqMc
	s4FghUJbcPaKPX12vNZNAXV1Jm3Qdsxjnbz9xji68q7dvRbHZzqFEZPZhKmOaRKr
	hFgZK+hihoWo89/SWPqQwX0tgi6uWmosUUI0LcQ1ZtLc4QmzRMJWmu/uIRKzs1Iy
	wUcQ3NZGVBg0AVigXLbu880x8qRPv/UMYLwg2TL8FiD8KGqCEN8+jIIUgpk6PLkO
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id I4qSrqdM7XzL; Tue, 16 Dec 2025 21:07:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dW8dk1q2vzmNLLr;
	Tue, 16 Dec 2025 21:07:37 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 2/5] scsi: sd: Move the sd_config_discard() function definition
Date: Tue, 16 Dec 2025 13:07:14 -0800
Message-ID: <20251216210719.57256-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.305.g3fc767764a-goog
In-Reply-To: <20251216210719.57256-1-bvanassche@acm.org>
References: <20251216210719.57256-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Move the sd_config_discard() function definition such that its
forward declaration can be removed.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 114 +++++++++++++++++++++++-----------------------
 1 file changed, 56 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0b479153abb8..d5cb313d1a91 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -102,8 +102,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
=20
 #define SD_MINORS	16
=20
-static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limit=
s *lim,
-		unsigned int mode);
 static void sd_config_write_same(struct scsi_disk *sdkp,
 		struct queue_limits *lim);
 static void  sd_revalidate_disk(struct gendisk *);
@@ -120,6 +118,62 @@ static const char *sd_cache_types[] =3D {
 	"write back, no read (daft)"
 };
=20
+static void sd_disable_discard(struct scsi_disk *sdkp)
+{
+	sdkp->provisioning_mode =3D SD_LBP_DISABLE;
+	blk_queue_disable_discard(sdkp->disk->queue);
+}
+
+static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limit=
s *lim,
+		unsigned int mode)
+{
+	unsigned int logical_block_size =3D sdkp->device->sector_size;
+	unsigned int max_blocks =3D 0;
+
+	lim->discard_alignment =3D sdkp->unmap_alignment * logical_block_size;
+	lim->discard_granularity =3D max(sdkp->physical_block_size,
+			sdkp->unmap_granularity * logical_block_size);
+	sdkp->provisioning_mode =3D mode;
+
+	switch (mode) {
+
+	case SD_LBP_FULL:
+	case SD_LBP_DISABLE:
+		break;
+
+	case SD_LBP_UNMAP:
+		max_blocks =3D min_not_zero(sdkp->max_unmap_blocks,
+					  (u32)SD_MAX_WS16_BLOCKS);
+		break;
+
+	case SD_LBP_WS16:
+		if (sdkp->device->unmap_limit_for_ws)
+			max_blocks =3D sdkp->max_unmap_blocks;
+		else
+			max_blocks =3D sdkp->max_ws_blocks;
+
+		max_blocks =3D min_not_zero(max_blocks, (u32)SD_MAX_WS16_BLOCKS);
+		break;
+
+	case SD_LBP_WS10:
+		if (sdkp->device->unmap_limit_for_ws)
+			max_blocks =3D sdkp->max_unmap_blocks;
+		else
+			max_blocks =3D sdkp->max_ws_blocks;
+
+		max_blocks =3D min_not_zero(max_blocks, (u32)SD_MAX_WS10_BLOCKS);
+		break;
+
+	case SD_LBP_ZERO:
+		max_blocks =3D min_not_zero(sdkp->max_ws_blocks,
+					  (u32)SD_MAX_WS10_BLOCKS);
+		break;
+	}
+
+	lim->max_hw_discard_sectors =3D max_blocks *
+		(logical_block_size >> SECTOR_SHIFT);
+}
+
 static void sd_set_flush_flag(struct scsi_disk *sdkp,
 		struct queue_limits *lim)
 {
@@ -865,62 +919,6 @@ static unsigned char sd_setup_protect_cmnd(struct sc=
si_cmnd *scmd,
 	return protect;
 }
=20
-static void sd_disable_discard(struct scsi_disk *sdkp)
-{
-	sdkp->provisioning_mode =3D SD_LBP_DISABLE;
-	blk_queue_disable_discard(sdkp->disk->queue);
-}
-
-static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limit=
s *lim,
-		unsigned int mode)
-{
-	unsigned int logical_block_size =3D sdkp->device->sector_size;
-	unsigned int max_blocks =3D 0;
-
-	lim->discard_alignment =3D sdkp->unmap_alignment * logical_block_size;
-	lim->discard_granularity =3D max(sdkp->physical_block_size,
-			sdkp->unmap_granularity * logical_block_size);
-	sdkp->provisioning_mode =3D mode;
-
-	switch (mode) {
-
-	case SD_LBP_FULL:
-	case SD_LBP_DISABLE:
-		break;
-
-	case SD_LBP_UNMAP:
-		max_blocks =3D min_not_zero(sdkp->max_unmap_blocks,
-					  (u32)SD_MAX_WS16_BLOCKS);
-		break;
-
-	case SD_LBP_WS16:
-		if (sdkp->device->unmap_limit_for_ws)
-			max_blocks =3D sdkp->max_unmap_blocks;
-		else
-			max_blocks =3D sdkp->max_ws_blocks;
-
-		max_blocks =3D min_not_zero(max_blocks, (u32)SD_MAX_WS16_BLOCKS);
-		break;
-
-	case SD_LBP_WS10:
-		if (sdkp->device->unmap_limit_for_ws)
-			max_blocks =3D sdkp->max_unmap_blocks;
-		else
-			max_blocks =3D sdkp->max_ws_blocks;
-
-		max_blocks =3D min_not_zero(max_blocks, (u32)SD_MAX_WS10_BLOCKS);
-		break;
-
-	case SD_LBP_ZERO:
-		max_blocks =3D min_not_zero(sdkp->max_ws_blocks,
-					  (u32)SD_MAX_WS10_BLOCKS);
-		break;
-	}
-
-	lim->max_hw_discard_sectors =3D max_blocks *
-		(logical_block_size >> SECTOR_SHIFT);
-}
-
 static void *sd_set_special_bvec(struct request *rq, unsigned int data_l=
en)
 {
 	struct page *page;
