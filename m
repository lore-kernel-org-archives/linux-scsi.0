Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6E9149C4E
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 23:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722901407; cv=none; b=YVKuZGDKUjl11GboLa5tF6veroIt71ZSImf0gkNIxW74KkVzwZGS0bwZX7TsCvPm7xkS8uF0jgTAoG+slm3RbonP4Hsi4tsRUwLMDAwkntvHMxQ4E/PBHYcQRtRJfFk2pYi6pxauNiHc2tl0egJQNuKb1cth0kMLiF5pgDXB6M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722901407; c=relaxed/simple;
	bh=REw2I9pPmIVucGWocpWPRdU0am64MZRGRT2JH1qcR1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q961TL10gDmyiyGuibNgRdvRsMbAaLG1RtSNoj5HN/p0gLfOpRsCvtX6qIZtTvDzZ50mgxh3XsJ3ceuHpsValwopv2zwUcfXUSgmL7pPuuT11+chPPVETVNJc91kuWqCtCSU4EzU41ST8duD5Kv5KP/4cz2h331FpF+dBxHr10E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=G5NAkDhB; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="G5NAkDhB"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WdCgK4jjCz6ClY9J;
	Mon,  5 Aug 2024 23:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1722901400; x=1725493401; bh=4XT0S
	rONfjEb1ffWqUTIkv9d69z3UZIkUKzmnGU1n6o=; b=G5NAkDhBdQnEaZ7Itp/+I
	3VpwXmMDfTlmer68dcK1mtg838LoOSUW+jEkb1o/viZ86gzmkBAf6OQF/b9TwWZf
	2JFzCeJrgyGd84iuv3NYMSAFBAT49QpOI3dVoZeGrrxE8ldPcKvmGHPbIwFI5NV+
	vCEIFbY5ll2WkIpV9/ZRndw+fyRCXgOBrN2xDuPLy0FJQdG6zEI5BM67HBP3wtEZ
	06KMtP1vJp9x5Ho2/CkV5vOJqzW5k/VOdS8/zaIT1b0jJPmfzBuQT3ct76UUO4O/
	K4Rxx2OmasS+dqnhGo1zzKmXibdg7zN5t3MjT7CBpPeyuBDIsmC1lMXQ4g4OhRX1
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JbcfuetAOZqq; Mon,  5 Aug 2024 23:43:20 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WdCgB5X0yz6ClY9F;
	Mon,  5 Aug 2024 23:43:18 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 3/6] scsi: sd: Move the sd_config_write_same() function definition
Date: Mon,  5 Aug 2024 16:42:46 -0700
Message-ID: <20240805234250.271828-4-bvanassche@acm.org>
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

Move the sd_config_write_same() function definition such that its forward
declaration can be removed.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 136 +++++++++++++++++++++++-----------------------
 1 file changed, 67 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 61a0c02b3246..b9a9b24ff027 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -103,8 +103,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
=20
 #define SD_MINORS	16
=20
-static void sd_config_write_same(struct scsi_disk *sdkp,
-		struct queue_limits *lim);
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
 static void scsi_disk_release(struct device *cdev);
@@ -175,6 +173,73 @@ static void sd_config_discard(struct scsi_disk *sdkp=
, struct queue_limits *lim,
 		(logical_block_size >> SECTOR_SHIFT);
 }
=20
+static void sd_disable_write_same(struct scsi_disk *sdkp)
+{
+	sdkp->device->no_write_same =3D 1;
+	sdkp->max_ws_blocks =3D 0;
+	blk_queue_disable_write_zeroes(sdkp->disk->queue);
+}
+
+static void sd_config_write_same(struct scsi_disk *sdkp,
+		struct queue_limits *lim)
+{
+	unsigned int logical_block_size =3D sdkp->device->sector_size;
+
+	if (sdkp->device->no_write_same) {
+		sdkp->max_ws_blocks =3D 0;
+		goto out;
+	}
+
+	/* Some devices can not handle block counts above 0xffff despite
+	 * supporting WRITE SAME(16). Consequently we default to 64k
+	 * blocks per I/O unless the device explicitly advertises a
+	 * bigger limit.
+	 */
+	if (sdkp->max_ws_blocks > SD_MAX_WS10_BLOCKS)
+		sdkp->max_ws_blocks =3D min_not_zero(sdkp->max_ws_blocks,
+						   (u32)SD_MAX_WS16_BLOCKS);
+	else if (sdkp->ws16 || sdkp->ws10 || sdkp->device->no_report_opcodes)
+		sdkp->max_ws_blocks =3D min_not_zero(sdkp->max_ws_blocks,
+						   (u32)SD_MAX_WS10_BLOCKS);
+	else {
+		sdkp->device->no_write_same =3D 1;
+		sdkp->max_ws_blocks =3D 0;
+	}
+
+	if (sdkp->lbprz && sdkp->lbpws)
+		sdkp->zeroing_mode =3D SD_ZERO_WS16_UNMAP;
+	else if (sdkp->lbprz && sdkp->lbpws10)
+		sdkp->zeroing_mode =3D SD_ZERO_WS10_UNMAP;
+	else if (sdkp->max_ws_blocks)
+		sdkp->zeroing_mode =3D SD_ZERO_WS;
+	else
+		sdkp->zeroing_mode =3D SD_ZERO_WRITE;
+
+	if (sdkp->max_ws_blocks &&
+	    sdkp->physical_block_size > logical_block_size) {
+		/*
+		 * Reporting a maximum number of blocks that is not aligned
+		 * on the device physical size would cause a large write same
+		 * request to be split into physically unaligned chunks by
+		 * __blkdev_issue_write_zeroes() even if the caller of this
+		 * functions took care to align the large request. So make sure
+		 * the maximum reported is aligned to the device physical block
+		 * size. This is only an optional optimization for regular
+		 * disks, but this is mandatory to avoid failure of large write
+		 * same requests directed at sequential write required zones of
+		 * host-managed ZBC disks.
+		 */
+		sdkp->max_ws_blocks =3D
+			round_down(sdkp->max_ws_blocks,
+				   bytes_to_logical(sdkp->device,
+						    sdkp->physical_block_size));
+	}
+
+out:
+	lim->max_write_zeroes_sectors =3D
+		sdkp->max_ws_blocks * (logical_block_size >> SECTOR_SHIFT);
+}
+
 static void sd_set_flush_flag(struct scsi_disk *sdkp,
 		struct queue_limits *lim)
 {
@@ -1078,73 +1143,6 @@ static blk_status_t sd_setup_write_zeroes_cmnd(str=
uct scsi_cmnd *cmd)
 	return sd_setup_write_same10_cmnd(cmd, false);
 }
=20
-static void sd_disable_write_same(struct scsi_disk *sdkp)
-{
-	sdkp->device->no_write_same =3D 1;
-	sdkp->max_ws_blocks =3D 0;
-	blk_queue_disable_write_zeroes(sdkp->disk->queue);
-}
-
-static void sd_config_write_same(struct scsi_disk *sdkp,
-		struct queue_limits *lim)
-{
-	unsigned int logical_block_size =3D sdkp->device->sector_size;
-
-	if (sdkp->device->no_write_same) {
-		sdkp->max_ws_blocks =3D 0;
-		goto out;
-	}
-
-	/* Some devices can not handle block counts above 0xffff despite
-	 * supporting WRITE SAME(16). Consequently we default to 64k
-	 * blocks per I/O unless the device explicitly advertises a
-	 * bigger limit.
-	 */
-	if (sdkp->max_ws_blocks > SD_MAX_WS10_BLOCKS)
-		sdkp->max_ws_blocks =3D min_not_zero(sdkp->max_ws_blocks,
-						   (u32)SD_MAX_WS16_BLOCKS);
-	else if (sdkp->ws16 || sdkp->ws10 || sdkp->device->no_report_opcodes)
-		sdkp->max_ws_blocks =3D min_not_zero(sdkp->max_ws_blocks,
-						   (u32)SD_MAX_WS10_BLOCKS);
-	else {
-		sdkp->device->no_write_same =3D 1;
-		sdkp->max_ws_blocks =3D 0;
-	}
-
-	if (sdkp->lbprz && sdkp->lbpws)
-		sdkp->zeroing_mode =3D SD_ZERO_WS16_UNMAP;
-	else if (sdkp->lbprz && sdkp->lbpws10)
-		sdkp->zeroing_mode =3D SD_ZERO_WS10_UNMAP;
-	else if (sdkp->max_ws_blocks)
-		sdkp->zeroing_mode =3D SD_ZERO_WS;
-	else
-		sdkp->zeroing_mode =3D SD_ZERO_WRITE;
-
-	if (sdkp->max_ws_blocks &&
-	    sdkp->physical_block_size > logical_block_size) {
-		/*
-		 * Reporting a maximum number of blocks that is not aligned
-		 * on the device physical size would cause a large write same
-		 * request to be split into physically unaligned chunks by
-		 * __blkdev_issue_write_zeroes() even if the caller of this
-		 * functions took care to align the large request. So make sure
-		 * the maximum reported is aligned to the device physical block
-		 * size. This is only an optional optimization for regular
-		 * disks, but this is mandatory to avoid failure of large write
-		 * same requests directed at sequential write required zones of
-		 * host-managed ZBC disks.
-		 */
-		sdkp->max_ws_blocks =3D
-			round_down(sdkp->max_ws_blocks,
-				   bytes_to_logical(sdkp->device,
-						    sdkp->physical_block_size));
-	}
-
-out:
-	lim->max_write_zeroes_sectors =3D
-		sdkp->max_ws_blocks * (logical_block_size >> SECTOR_SHIFT);
-}
-
 static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq =3D scsi_cmd_to_rq(cmd);
