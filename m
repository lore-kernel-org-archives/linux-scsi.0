Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72BF4D7D27
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 12:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789649758; cv=none; b=Ye1j6Ug0MJh8Ve1C74rsoLGH/PkUd9QpWwoMpj2MExPlDbxKk00oHcJJ3HF5C8d7RTiO0TvFZAOV4qzc2uLmbPgXBycd/lKWAL9a6FUlbdtt6sHxT7jo8vm6yxj7ECqHlv0ozUAWiK2y3feqrBiLqtFFIsB8GD/3pyFqftStAcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789649758; c=relaxed/simple;
	bh=ZHvDeW8I4CdyqVYsaIRlE1XxBHRiYFlI/qb41DWJzfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlaXWv1ejaJ3gdj3pP32zInGvfpBPyk+8wK78XAbDc3ViEbrAwC1TuXgaeW0grciVfSio/j6rSWXz8Xu8/jDIXV8qTakdFKd2FRZMZCLpGEh59mrT8kpZifV2Zyb1F8a/hQebv0PaYqYQHFC07SkGL76wyTdJ2IYt78jnC6coE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PE53wdyu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PE53wdyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787551F00893;
	Thu, 17 Sep 2026 12:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789649750;
	bh=4S1m0Jt7uGcZT91gII2QAbZptNHkXRbBZuyjEd1xgmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PE53wdyuSbHAHWY2rBsRwJXMm5nGVD2q6CiLUOBpMN2CQQpvwVna13IVmUb/mkMKD
	 N8w5CGI3B0LCq+GY1JbBN9b4uUvkDlFPYA8Ebz5nCIOuSf39MZaNmzqlfOI3DNXyo3
	 8L0ATNAQ0LTRgyfcejoQnVoUU8pnl0j0u8iIiWyC9o0WrDFlriiyWbxNpjjoVct7fg
	 Ar7DRBD6jdTajAm8Dz2JMYjm7UK0qWDODGS/HbY9r3eKYa00KQPvX1x8+1F8php+12
	 1E6bgQ+1/CbN3UHbUHYPGwDyszz1AhoOBP7kf8vo0sh/0qB4+7cEWqn9H048KIc5kA
	 Nbtf/5aT1fYnw==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v3 4/6] scsi: scsi_debug: Enforce physical block alignment of zoned writes
Date: Thu, 17 Sep 2026 14:54:50 +0200
Message-ID: <20260917125445.1376493-12-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917125445.1376493-8-cassel@kernel.org>
References: <20260917125445.1376493-8-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3586; i=cassel@kernel.org; h=from:subject; bh=ZHvDeW8I4CdyqVYsaIRlE1XxBHRiYFlI/qb41DWJzfU=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJWP5Zauuj32//HLV88zDd/JXVX+npvGusEVQum9sCzM ZE7jzmt7yhlYRDjYpAVU2Tx/eGyv7jbfcpxxTs2MHNYmUCGMHBxCsBENvozMvx3kXsxV8QxX3Bi 1WKOe9kZSRJvRRhc83VPi/lN6XxW/I/hnzaj39L+rKj/LvVt+Y/cJ3rcnn0u5/4nty3FN+osLff L8QMA
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
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/scsi_debug.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 41c8d958f445..64f32d97455d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3980,6 +3980,16 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
 					UNALIGNED_WRITE_COMMAND);
 			return check_condition_result;
 		}
+		/*
+		 * Writes must end on a physical block boundary, that is, the
+		 * transfer length must be a multiple of the physical block
+		 * size.
+		 */
+		if (!IS_ALIGNED(lba + num, 1U << sdebug_physblk_exp)) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					UNALIGNED_WRITE_COMMAND);
+			return check_condition_result;
+		}
 	}
 
 	/* Handle implicit open of closed and empty zones */
-- 
2.55.0

