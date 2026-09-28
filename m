Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0EF298CC4
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790580095; cv=none; b=aaqTWGtHOChJ1IqRnt8qsKjZMC/Xr/MaRyMVVgg7KZFZbfWtp7KI/a8yQvG7jkvXcgKV0drErbESnfmQBFdI90JEK1L9lYh6GO4XxYg9XShSAL4bA+LI1jvjdqJjgqPJuKKSi1JsW0t6e4RaF6cD1WUrbeNNayKa+3MF54yMNLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790580095; c=relaxed/simple;
	bh=ikGRovfG1GBDsBnk6Kwd5jQbGxx/TsI0rLocREVAIw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sav5UNzEEi7gaN6oT9rJb0lgEy/e+eK5YrxrfxrYlk0aCWsyt28LjbfANfX0h+Ly7jpzafFQOxlZCfk4c1pjr3fPuxAEXcLB3rVa9zrkRVJdNUETLvzJ1fj0y79SclEdp5x6zO/rfMcBmmnlDsLvBlogSapZ0aOO6s+Wom4kewI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cAm83ztP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cAm83ztP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740F41F00893;
	Mon, 28 Sep 2026 07:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790580093;
	bh=euJ48dxN+OPS0PpKJUv+9Mic122dMcUv7cVm207py9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cAm83ztPezA4yFzKR1M/gksrMn61ki8aZKTss+2KDHThkmTkTwOpOv+bmi9x0H36F
	 EdjK6uxGWGAyap8zNxs4eLDKpBEbYLtndzkIrJE2H/jy7q/8y69+SNgsaXE5OXpqVq
	 zq27vemB25vaIdy2yVLWkUYPtB+jCcBI1+q61oRb0QyAqS14mENzGtalmpESJ+63uv
	 bzk6ZGiCFMRvMuBwEDxpWjfvtUEJ+NnBHUZwh6LRwnza/pKICfniRTdj54ANntHnka
	 X/iIkKj5wMpbEXfv4jVqpkqWHslLED4eqdbQcbfNge7h0FLgepgldMgCFzbnlSpAbZ
	 WeT3XYiX1AMFg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v10 09/12] scsi: scsi_debug: Advance the write pointer over the data written
Date: Mon, 28 Sep 2026 09:21:12 +0200
Message-ID: <20260928072102.725566-23-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928072102.725566-14-cassel@kernel.org>
References: <20260928072102.725566-14-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3220; i=cassel@kernel.org; h=from:subject; bh=ikGRovfG1GBDsBnk6Kwd5jQbGxx/TsI0rLocREVAIw8=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2iab/dzhfuUz8Wkt39xGdndteuPLzb+h7tq/gxdG5G tbc0+KNO0pZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjAR2QRGhkUmCR9d2XuLDSZF F0tZTJljxvM0Q4BV9HHhDc8n2lMkrRgZTqhYvmm+XPPw9PUPrHsyfq1tkEy+2OA/h99zg06BtEQ MKwA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

resp_write_dt0() and resp_write_scat() advance the write pointer of a
sequential write required zone by the transfer length of the command
without looking at what do_device_access() returned, which is -1 when
the data direction of the command does not match the operation, and a
short byte count when the data-out buffer is smaller than the transfer
length. An initiator can produce both with SG_IO.

The zone then describes more data than is on the medium, and a write at
the position where the data really ends is terminated with UNALIGNED
WRITE COMMAND, so the zone has to be reset before it can be written to
again.

Advance the write pointer over the data that was written instead. As
do_device_access() does not write a partial physical block to such a
zone, that leaves the write pointer where a write can end.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
      zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2

issuing WRITE(16) through SG_IO with a data-out buffer shorter than the
transfer length of the command. A sixteen block write with a buffer of
twelve blocks leaves the write pointer of an empty sequential write
required zone eight blocks on, which is where the data it wrote ends,
and a following eight block write continues from there. An eight block
write with a buffer of one block writes nothing and leaves the write
pointer where it was.

Before this patch both advanced the write pointer by the full transfer
length, and a write at the end of the data that had actually been
written was then terminated with UNALIGNED WRITE COMMAND.
---
 drivers/scsi/scsi_debug.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index dd7132e92c27..f83440ab7966 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5179,9 +5179,9 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	if (unlikely(lbp))
 		map_region(sip, lba, num);
 
-	/* If ZBC zone then bump its write pointer */
-	if (sdebug_dev_is_zoned(devip))
-		zbc_inc_wp(devip, lba, num);
+	/* If ZBC zone then bump its write pointer over the data written */
+	if (sdebug_dev_is_zoned(devip) && ret > 0)
+		zbc_inc_wp(devip, lba, ret >> ilog2(sdebug_sector_size));
 	if (meta_data_locked)
 		sdeb_meta_write_unlock(sip);
 
@@ -5349,9 +5349,10 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		 */
 		ret = do_device_access(sip, scp, min_t(u64, sg_off, U32_MAX), lba,
 				       num, group, true, true);
-		/* If ZBC zone then bump its write pointer */
-		if (sdebug_dev_is_zoned(devip))
-			zbc_inc_wp(devip, lba, num);
+		/* If ZBC zone then bump its write pointer over the data written */
+		if (sdebug_dev_is_zoned(devip) && ret > 0)
+			zbc_inc_wp(devip, lba,
+				   ret >> ilog2(sdebug_sector_size));
 		if (unlikely(scsi_debug_lbp()))
 			map_region(sip, lba, num);
 		if (unlikely(-1 == ret)) {
-- 
2.55.0

