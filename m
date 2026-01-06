Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DD833CEA8
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 19:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767726491; cv=none; b=pLwEo9y6bKHseoXZwnJKFGxbDQHziicT8l1KaNm+NPpq4C5UpUbsiO30ZxsCep7VFTdHYq1RpACA0NWlxQ9MOLeTUKIvQqq+ucJ9fDSffHG6v1X2OkIxxN8VUSkYfrAONC2AH2tkVk5DYTu97ObGWRinRixZgypSfRQmK20PyJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767726491; c=relaxed/simple;
	bh=IsZFIcxM9o0CA8AuM3b6IdI95VfLcyIUIcgqq5B3fAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4p/WIEjtPY/g+eLAMG2ugZG587VpRas2UHSo3VIZLFj8w3JZiqxAYWBYfZvjK0nAhGAjkIUoXNHkRA4Q4jQGzFNOXfeOEzds+AWTVkZnG5eESCwXQgVLduxxEve1b6EOt7PIGNt3meNpeTh1J7zgqMPcyTHbjwjEOo8fldb2FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0XSCYeT7; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0XSCYeT7"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dm1080Fy8z1XSkny;
	Tue,  6 Jan 2026 19:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1767726486; x=1770318487; bh=KDRGt
	5VH9gT4HG8N0nN+qylacY4YawUb78OY1NQoCD4=; b=0XSCYeT7+dsYIxnqoL+Fo
	GfoGRQ0rFxqhIlh9o4O1B//a3qtrHf6D+vwY8shTJQGojWNYK7ZGfEqiVEPpA2V7
	4ZBr9rWk89CyqV14vSkxXOf1Kpb141X61vfNRSVpL+wLbcxuqVdsqH3E/Mbwd2Fd
	azsvypiRDK5kLx7RKOQIQQ9KqgYbnNvzJlrmgg7lKrOQBFyOuP5ZrGxlu52/Vkft
	mpZ0DiGAYUN3lBUbTbTTQmegMSbNtJgOCTsiC/6z0dDSpKY/LT77+B+euI3e5Fwj
	JRcNepcNPX7dI2T2S25g/tFvqPPEOlgcMObH41HtBr19U0dPuwV73jMgDQcFTAgG
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kP3j3WrEDDkX; Tue,  6 Jan 2026 19:08:06 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dm1045Npcz1XPpVK;
	Tue,  6 Jan 2026 19:08:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v5 2/5] scsi: sd: Move the sd_config_discard() function definition
Date: Tue,  6 Jan 2026 12:07:45 -0700
Message-ID: <20260106190749.2549070-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
In-Reply-To: <20260106190749.2549070-1-bvanassche@acm.org>
References: <20260106190749.2549070-1-bvanassche@acm.org>
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
index 8da2a35499ed..692453004d78 100644
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
