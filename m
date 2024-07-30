Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD28B183098
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2024 21:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722373290; cv=none; b=eKW0NQAJojy2rThrajedaThkY9HiPMGHsbPbI2Iov+WnUQMFH05cJhpDMjKl7lqdF+kxLSmDcJFVmi7CZkN+ssl6+2l5GsvEjLDj9oXc3cQb7BAsA0inNGXoJASnvkwQHU1j+zNkTIUOnvNZele0X9z2Svi0McdjOxFyXk8uQUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722373290; c=relaxed/simple;
	bh=tcueXEYWUCXsd6Q04wwapFKjz87Rhx34RIpqHJhcPLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhlkm4O8qp/srirJ8ISB1Vchg9gIdE1jO367u1fclgzuW+wCTxzAOf1KlJR3ulQ3HNgZdqa0S16zjLMgseg5YfE0zQB+zGsSQRCEp+U5xbjQCtlgyMzuJf2jHyUwd/sGimbYc9yHhm69FJwXlZ2VutSh8auaMsrW3bXP3Yj7I0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VpMXpx+m; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VpMXpx+m"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WYSMB1nh5z6CmQvG;
	Tue, 30 Jul 2024 21:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1722373280; x=1724965281; bh=npT0P
	eHTMYyLMQYofV+NwKiIxZmsRKY/fnTX8a1bfLw=; b=VpMXpx+mafgS3XW+TlgI1
	/7YWEDOceRbpmvYtCsZHhY8P2xuh4WRtIGt3hLLp9X1XpFxk/YSNhlaZr8XngnEC
	tjitwzkEbQRwpa0EqV59MXRHiXvQWokuoknQLdstlji+eIcvpa0KONgmt+N/5UCv
	GzMW9kNw0PXPnb5IDjdDb1N/OIq6t5wqJb5sgAOqWMfc2hxZ5D8r74MmlPGcG3qe
	w2KqNvjqGrqO3wTrbZ0PfoPE1B24lCF4ZvNwf9eq9RFu3JKgsAfoxLftAwTT8U9j
	Soyy7VAvdDh1WMIyFxa+yoVOtk+hFWA/CSoQSq45rJoMyJ8qX4Fq9Hz8dr6C/1NM
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0dKs5yKCOUxt; Tue, 30 Jul 2024 21:01:20 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WYSM32Swgz6CmM5x;
	Tue, 30 Jul 2024 21:01:19 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/6] scsi: sd: Move the sd_config_discard() function definition
Date: Tue, 30 Jul 2024 14:00:37 -0700
Message-ID: <20240730210042.266504-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
In-Reply-To: <20240730210042.266504-1-bvanassche@acm.org>
References: <20240730210042.266504-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Move the sd_config_discard() function definition such that its
forward declaration can be removed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 114 +++++++++++++++++++++++-----------------------
 1 file changed, 56 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 58ea8c06205b..8b8a355435b4 100644
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
