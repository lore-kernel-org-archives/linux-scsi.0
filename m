Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8354A21
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 05:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790486840; cv=none; b=VpodBaugOEZPB/vCET/zCcj6egpeXRsXHonEMiW+jizBi8z3o6+xT8YBSWdPJdWsmhz44cmgb7YR+laYXIcrBltJqwyGe6u0W10Bb2EgMPaTlwLuVbM4V6D3xNG8E2Bcj3mh9GTIveV1uWfpHmc5ZhHp4pHTrGN3blwtSnluxlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790486840; c=relaxed/simple;
	bh=95auq7eSTIeoKQWyu2Z6Gq72mzRIxzoIWWEyRyU3/cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3RBbv8MaLR+Q1EZX3qw8AkO8E9+jq8bE864fjacimj2J8PZPpYWrdrvrXF1bvoemjyv5QfIazHbVJSSOThGdSwS+hhix3UckyjlFh2ziAMAPUx/Kb8JbGTcka9a6iINvMRB8O008V/5Bg8hrSkmfIUh/NQNlJen2FG3K9rnKVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NtJAXX7Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NtJAXX7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D419F1F000FF;
	Sun, 27 Sep 2026 05:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790486839;
	bh=7QXRwDfik8WzeWY7sY7VJ/m7YyKmSAWhMFISA55kh8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtJAXX7ZS3/AyexO6ASdTuWKhGrhwlDRAl/FlE06yVl482dN7C8jjgVqQ4aI9BfZO
	 4SzPS14j8DynqxcBRuRR5QuH6iVA+whnhQ2OUoafZYkU9rj+ctXqmmQsXMaQ3JMyjm
	 1P4KIK9cs9zWGNb013HDusdzUuWHnr91C8X4LffD6dM8M2odM/1EXHivY+JIa5/fuX
	 08dHiLWgMl9KpRxxYXWchGMTaWLwufb8Nw/q9iGCQncGJwIBpWWIf5M5Rax1ujmhdm
	 koSUBeuzh7nha/GY3ogM5J13eCcRqG/myAmFnM2xmt2bpLCPWf14G2oV6Zqe3SEfKH
	 4FQ7cAWVixcAg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v9 08/11] scsi: scsi_debug: Advance the write pointer over the data written
Date: Sun, 27 Sep 2026 07:26:59 +0200
Message-ID: <20260927052650.567035-21-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260927052650.567035-13-cassel@kernel.org>
References: <20260927052650.567035-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3223; i=cassel@kernel.org; h=from:subject; bh=95auq7eSTIeoKQWyu2Z6Gq72mzRIxzoIWWEyRyU3/cg=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2rFTQXsD06oJTiXBiylIlHuekqokHhepr1zTeKl3QH ZBo/WVzRykLgxgXg6yYIovvD5f9xd3uU44r3rGBmcPKBDKEgYtTACZyYykjw231OQ13Flkb7Hb7 bj3hoU3er+Nm38xs5szQ/7bkwC5PDkaGf6b1iVcfV/j+Eujj911QonczZteRenmtZ3n2a62trik 68gIA
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
index 904a3e5952e4..d18f0d71aab6 100644
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
 
@@ -5347,9 +5347,10 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		 * writes behaviour as possible.
 		 */
 		ret = do_device_access(sip, scp, sg_off, lba, num, group, true, true);
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

