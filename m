Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01183B38BC
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 08:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790670379; cv=none; b=b7ZA/2XqBgAAXb5LwsqBeyebaXpxMaGUMHWVy76qkEuVDMS+d9FlNt3VJfsk/j2893bZWgxeMD/JxV6+LB40g1r4sCSBy630+vSPvUHPM/U6T3PstzpPST7/LbpDz5fHuegTUB8RSsghquMwSXEX3ROfjO4pOKvVqH/w1r+dhgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790670379; c=relaxed/simple;
	bh=Bu0Y+mNcqaecE28dHePeB6JKrYgKvmRQLRkYKmB5y3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5zDIkx61mQCTPFKbt1aBy6//9PDtLKYEbTBrpGzHFmnLNGU8SfoB1YDE4NXTsp5ee97/n4wQIh5aq9x7cPQLKPIO8dxElY04awjZADDqx9iYRAxyC+Nho0jfkJDZubpbb1dsbDz6LSRmxXWXQgVAmx1ujI2CarZQ88kIjZ2mLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9GLzNk9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9GLzNk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B441F00893;
	Tue, 29 Sep 2026 08:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790670378;
	bh=15a6aGnpHjVnsqeFUm1BBnYrKba/8s2OC9wz0RX+GPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z9GLzNk9CTM24yQPFOHV2LNVwQLq47OYYCAd9Inlj5Iq12Cycb3vMvCyUr+RN+Lzv
	 cspA4Yo9WksmRJsvJVLXuwhMlIIDzFDUbHPVrCAwrUeHWWXZNTRVDdHzNRgUYrEd60
	 Zo42bJ+sf4CtCMBu/HniwswNj20SDceDmv/PUjBJFatEC62gZoZID3Rg4G7nraKCf5
	 ItwQcbMVP4fGIsXian9Kua2FNsJI2QtayGStCmNvfplYEVi9CcObLaYXttJxkfzybW
	 q6dw/I8ypb5SkpqtyAkY9EJR+bPCbQRnqSLhTe8lJF8TseRoX/WiUkU7JRTBuP9E1e
	 joxaAOs3mwIdg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v11 10/13] scsi: scsi_debug: Advance the write pointer over the data written
Date: Tue, 29 Sep 2026 10:25:07 +0200
Message-ID: <20260929082456.857423-25-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929082456.857423-15-cassel@kernel.org>
References: <20260929082456.857423-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3235; i=cassel@kernel.org; h=from:subject; bh=Bu0Y+mNcqaecE28dHePeB6JKrYgKvmRQLRkYKmB5y3g=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2l76928FRbnzw+ZSF/ba7azb+52TP/T4rgPncJLfsA gWtt7+XdpSyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAieywZ/lekL3M/U6ZjvH3V rcjWVyf++C+5z3z033SzCbcueq0Q4WRn+B8lv/Hjvq4dB3/xTWSS7XQ++qJK+W78/QPtXOKtyyx 0VNgA
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
index 7c1651f96ca1..98078fbeba37 100644
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
 
@@ -5351,9 +5351,10 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		ret = do_device_access(sip, scp,
 				       min_t(u64, sg_off, scsi_bufflen(scp)),
 				       lba, num, group, true, true);
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

