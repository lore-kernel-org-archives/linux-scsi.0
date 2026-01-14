Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289C3322A1D
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2026 17:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768413076; cv=none; b=IJ2BHYhNCY5+1upiCzX3jixEqpCyuY98C9X+18XcAXLVItbd7RqXOHRaVh0miGrPaEBqut7KGaFxECdj2lm9Re+TFixq9/OuYf9lOoEgxxvzWN+7aCceaUtKgW2Cr36TRaGB6MBrwDe5MgShKDh+4Pf7eUlhDNswzenKUmZONAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768413076; c=relaxed/simple;
	bh=GVRqjSPehDJErncTcubQKrMFb+T/mkFMQSKQ+YyGa8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2uNVP4UGtJYfTyFKx1HrYrxEUtN3Oj9RNI8X8D3ldpK6CLwrOXqnSp6ihxzB7ApoNVJXC1vvHMdmPCtC2cGJphOHV9P9g7napfxYnSQcah2R/dZ/fvaBbQqN9jE9z5P1NJw/OYeFR0TbAr0YUYUNQW4SQz1LObzL0JiLriosyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=c8SslU0Z; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="c8SslU0Z"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4drtvg5WQczllCWj;
	Wed, 14 Jan 2026 17:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1768413070; x=1771005071; bh=viQQ9
	DvkWA5iUp1RPAPWfAojll+gp+OPS804IFrJO30=; b=c8SslU0ZT4F8IoYZnm1M6
	SdjszoNB06mf6Avaw00y15NcaV48msLvml2d+fCmCzbOAHYBajnpKL9C0BUHsV5q
	kjn8hZPWgqGNqSUIiBrfa2F4nG82n5RqCUoESZm+P4YdwUX8KjN4p64YA5RWG6t9
	mTLIOR1VRT3UxLiOyQUlf6YOgEyRfP3JJGiTpHIl7S+uKQlV2aMPxsdTQ8jT7/Tw
	i0Jha6ktWxAq7eacZGWElR/t6xbeb9aGabvPdIN9KnW/geeWr1l5Y/9xMf83NbPs
	wshc1xCwRnQMYYLgKGbAJLm3tQjxudLYa9u0Dp/OTTKoco2hMJFlBzVBAGeu37ay
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aDqaXPaY_oaM; Wed, 14 Jan 2026 17:51:10 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4drtvc4lknzllCWq;
	Wed, 14 Jan 2026 17:51:08 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v6 2/5] scsi: sd: Move the sd_config_discard() function definition
Date: Wed, 14 Jan 2026 09:50:50 -0800
Message-ID: <20260114175054.4118163-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260114175054.4118163-1-bvanassche@acm.org>
References: <20260114175054.4118163-1-bvanassche@acm.org>
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 114 +++++++++++++++++++++++-----------------------
 1 file changed, 56 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b30c50693372..28444c81bf82 100644
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
