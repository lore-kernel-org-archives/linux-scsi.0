Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F77495AE6
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 08:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789634780; cv=none; b=hysKvR3NDWeaCooM66BL9xd8MbfpgfKoccuO/VmvP9MqZq5Tf0pM9yxkli+DNnYhGzH3uht2F4f/kbsdxmScUGAiiBzn2k1NfP+PJO6REaJcuUE5C60EFWcH3hFYQudrDOAHmMO2t1JKPDSyJMXirP8rEoMqcu0COeyc9IPzU9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789634780; c=relaxed/simple;
	bh=cm5XJArtlAlQ9o7WC9DFkMpZjlg9uAIdrAUMeNSlGp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lp9dOrKELfhBaPnJxXJXHWj/sksbwutiwrIhsKROtBY7xXKkiKWec3yAdSAcbbK0MoZbC4EB9j9H0AtFRWiHG9pDtKdKP2tiYHnkxwJkbQLYLwragEOhgI5cLJWGZfWQZa6RsgTGF4WXmL7tu0gpPdFt4+Qclkijdvf0RQYzPIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iuaLYODi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iuaLYODi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627DA1F00899;
	Thu, 17 Sep 2026 08:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789634761;
	bh=oCR/4qk80g8xqcde3QlmECZDUlgPlJXE6/0ijKMiCGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iuaLYODip1GPhK+PJExG3SnsGsv3FlCsx/kJKYyTDZngM1x76G6yCAxsMqeZm/NOF
	 d984PxQ54ZhTUtQ4PMAOE+FVopyFc87c4Sqw+XhZGMWz+PGqe2R/s179JZsoCBvpLv
	 dD/iGgg52AaGEgupArPggmJB3P5f2cZCUXnnU20ydliSgjVnN4wWtl9RGPZrCj+mwy
	 D0HYaXB9ZugCDYJiUM3omR2cjLR2RTj2MwPN4lf3TW7D0hrCg69/2VeSPEBZh+2H2S
	 7px+DyOomgPx6/VnIwDkwcjA+ce1KE/ADOku1b2kzqdt73raEh10o5X3NdYX7aRk6T
	 UDRfrLD1Dx4nA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 1/2] scsi: scsi_debug: Enforce physical block alignment of zoned writes
Date: Thu, 17 Sep 2026 10:45:55 +0200
Message-ID: <20260917084553.559765-5-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917084553.559765-4-cassel@kernel.org>
References: <20260917084553.559765-4-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4057; i=cassel@kernel.org; h=from:subject; bh=cm5XJArtlAlQ9o7WC9DFkMpZjlg9uAIdrAUMeNSlGp4=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJWrziYfNy/9pWESYMsa+V8yW158T6L3R9vqRCqV35qZ Not/Uqgo5SFQYyLQVZMkcX3h8v+4m73KccV79jAzGFlAhnCwMUpABOpO8zI8G/H1eC9rK93cu/0 PPtn9UdrhtyX3xa4P2yvcTvX25QyXYiRYfqGranq7JOqgxcURXnNi52xVvbOpN0HhNnvLbhwYMs kXi4A
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

ZBC-3 r06 (T10/BSR INCITS 579), 4.5.3.3.2 Write access pattern
requirements for sequential write required zones, states:

  The device server terminates with CHECK CONDITION status, with the
  sense key set to ILLEGAL REQUEST, and the additional sense code set
  to UNALIGNED WRITE COMMAND a write command, other than an entire
  medium write same command, that specifies:
    a) the starting LBA in a sequential write required zone set to a
       value that is not equal to the write pointer for that sequential
       write required zone; or
    b) an ending LBA that is not equal to the last logical block within
       a physical block (see SBC-5).

That is why sd_zbc_read_zones() sets the zone_write_granularity queue
limit to the physical block size of a host-managed device, exposing the
constraint to user space.

check_zbc_access_params() implements condition a) but not condition b):
it verifies that a write to a sequential write required zone starts at
the write pointer of the zone, but never validates the ending LBA. As a
consequence, when scsi_debug emulates a host-managed device whose
physical block size is larger than its logical block size, for instance
with zbc=managed sector_size=512 physblk_exp=3, a write of a single
logical block at the write pointer of a sequential zone is accepted and
advances the write pointer by one logical block. The write pointer is
then no longer a multiple of the zone_write_granularity reported for the
device, so nothing can write at it at the granularity that was
advertised, and the zone can only be used again after being reset.

Implement condition b) as well, with the same sense data as the write
pointer check, as the standard gives both conditions the same sense key
and additional sense code. The exclusion of an entire medium write same
command needs no special case: such a command spans the whole medium, so
it is already terminated with WRITE BOUNDARY VIOLATION by the preceding
check.

The check is placed in check_zbc_access_params(), which every command
that advances a zone write pointer reaches first: WRITE, WRITE SCATTERED
and WRITE SAME. Reads return earlier in the function and are unaffected.

Sequential write preferred zones, which are emulated for host-aware
devices with zbc=aware, are left alone: writes to them are not required
to be sequential, and Linux does not restrict the write granularity of
host-aware devices.

With the default physblk_exp=0, the physical block size equals the
logical block size and the new check is a no-op.

Assisted-by: LLM
Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
      zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2

Before this patch, a one logical block WRITE(16) at the write pointer of
an empty sequential write required zone completes with GOOD status and
leaves the write pointer at LBA 0x18001, which is not a multiple of the
4096 byte zone_write_granularity reported for the device. After it, the
same command is terminated with ILLEGAL REQUEST / UNALIGNED WRITE
COMMAND and the zone is left EMPTY, while an aligned eight block write
is still accepted.
---
 drivers/scsi/scsi_debug.c | 11 +++++++++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3898,6 +3898,17 @@
 					UNALIGNED_WRITE_ASCQ);
 			return check_condition_result;
 		}
+		/*
+		 * Writes must end on a physical block boundary, that is, the
+		 * transfer length must be a multiple of the physical block
+		 * size.
+		 */
+		if (!IS_ALIGNED(lba + num, 1U << sdebug_physblk_exp)) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					LBA_OUT_OF_RANGE,
+					UNALIGNED_WRITE_ASCQ);
+			return check_condition_result;
+		}
 	}
 
 	/* Handle implicit open of closed and empty zones */
-- 
2.55.0

