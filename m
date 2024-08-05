Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AF1273FD
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 23:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722901404; cv=none; b=XudAEnFTk6VpPjhZnCjgAxoM6OAmO0/Jlvy8DlzLetPFg5UJ3I2AjCqL0gznVRzAeDu80Ck97dcUeJZ4a7Dg/8xlqA6T4OkjfOGmG4mdAYWUu8x8pbmeB5kOEqH1G7zVyKVy6fpQrKFuSTu58AeIVYtqO2cwvY6yl8PIYKRRrVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722901404; c=relaxed/simple;
	bh=RCgiNx69mKEvbPwxKIrfAgYU6gxYPRTeoHT+yf6mBh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrflHGcsn+zNaa0bt/yB7qukYUZe5V+FlPMmBX3SUuij5ZT1YshM7N0q0DTe9aewCkSffu9n22VA8ZmNIRFdKJ9TVaGnBcNA3rMxML9D+6CYvlixtgi+d6nVyutd4uX5/GM8bLmzgZRA0j/5ePa6bOD27grY0I2cR8D405nuKrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1TP2UAHl; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1TP2UAHl"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WdCgG3VCLz6ClY9H;
	Mon,  5 Aug 2024 23:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1722901398; x=1725493399; bh=gunkQ
	RB4dNOtR+VKS6eEAaWx2OxD823cAftWHYAQan8=; b=1TP2UAHlT31B6cVCGOYTW
	k4+wqnhOGDuvc7twAN4C0H9CWTLtu9kc6HgN7yELbSsdo9NeFc9T6xcwj68nwFe2
	x019piaDnvbcH8bRkLAu6OiJMJmvQW0jvJkwRzVGtfPvjwcckog0bb2UY9Ra1Otg
	6PLSwHLpV4F8su7oVs+SFRoaAvQoc2A+LdCz4c2pf/j0f2CkZjGc/Nq+R498Ubn2
	ezy0bFMGaG4o7V6xnh3CD9rzBpcMBZWxkzb5KBYxcNPuXv1TrM8J4swgnyq4y5S+
	d2xL7wovuH2ERcWYonIPVXv2o1/sRc2YMboGUychcANdszB1tsN4xpo3Z3tMydGG
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UeLukZ-EbO1s; Mon,  5 Aug 2024 23:43:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WdCg85J6Mz6CmLxj;
	Mon,  5 Aug 2024 23:43:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 2/6] scsi: sd: Move the sd_config_discard() function definition
Date: Mon,  5 Aug 2024 16:42:45 -0700
Message-ID: <20240805234250.271828-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
In-Reply-To: <20240805234250.271828-1-bvanassche@acm.org>
References: <20240805234250.271828-1-bvanassche@acm.org>
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
index 50be1f01f1c2..61a0c02b3246 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -103,8 +103,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
=20
 #define SD_MINORS	16
=20
-static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limit=
s *lim,
-		unsigned int mode);
 static void sd_config_write_same(struct scsi_disk *sdkp,
 		struct queue_limits *lim);
 static int  sd_revalidate_disk(struct gendisk *);
@@ -121,6 +119,62 @@ static const char *sd_cache_types[] =3D {
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
@@ -841,62 +895,6 @@ static unsigned char sd_setup_protect_cmnd(struct sc=
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
