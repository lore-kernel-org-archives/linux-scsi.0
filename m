Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52753C9429
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712984; cv=none; b=iRZHB6ru1PysDPYS3HOWBRVXd0BW/8dpJFZO0V2/5mMg+eZJQKfubbtqJREkRD0uK8Qn0D42t2Yucpb1DE/89bFeT//ItUQxAYcUQOwM4rtK4RG+USs3XG1gKS4yJOAgXxcO9ts5cyuxgovDIP5//rRWQqcPrqVK7iagJQneSlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712984; c=relaxed/simple;
	bh=2xafCt73hiptbHatOTv6lSSjRppbezEKvRoWUEhPF60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QysB0oHs7B8Ju4qfXW616ZiUiQStezVobntypAhcXKMJJceJ78rfDh4zFhxRCd1tUk2fo1wgeOWHcNfpWjlf/XfAlcEF9Vs3bGD86+n8M5unSwr8bU6gG1U+RKy62YYbo6Z1HMeG9P0UMCxRXclwbHYFvo2PO9tKywxwP8kfJHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D6NRjsng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D6NRjsng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6361F00893;
	Fri, 18 Sep 2026 06:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789712982;
	bh=YukQ39ex1OgShztrfhRTFNdGeMWTD5EcyNznu6rKOiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6NRjsngELTNqdgSIjtahJtpzz0OC5pAdRjyD5+7skAGoyTM8EwvK2l0oqRZf7F3S
	 9uzf4B+JhFSTvaD9B8EzAFP3XJFNlZQ9LJr8a3oCGHK2ejd35O4TjYvXqiXvdLQPjz
	 pd7kQy7PUAJpkvEpeUDbONCqKHCTkmguVwFLTxvRFvo0Eu4Om/Gua10Vv2Pi10FN0l
	 nAxzpeT0B46d7YJatN08d9rGPToRViAyCEOK6p9aBfd7/VuUNUMpF7kpNGi6eOfPa1
	 bcYsC/it07QktjXoCjmSJwPvPiD9QlRl5s5JdbRuIZ+2+SZmJB1N2PhD2uebbgJSI2
	 zQVJxRDaqtB8Q==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v4 06/10] scsi: scsi_debug: Enforce physical block alignment of zoned writes
Date: Fri, 18 Sep 2026 08:29:17 +0200
Message-ID: <20260918062910.1709791-18-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918062910.1709791-12-cassel@kernel.org>
References: <20260918062910.1709791-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4372; i=cassel@kernel.org; h=from:subject; bh=2xafCt73hiptbHatOTv6lSSjRppbezEKvRoWUEhPF60=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLLW3LLfUPfr0iQl6Wkrd/5zaFQ7c0alL5LLbLOQzd+69 4t/7og06ihlYRDjYpAVU2Tx/eGyv7jbfcpxxTs2MHNYmUCGMHBxCsBEpkxiZHjpvbSZ607V4aDV ovPNfTcq/Jjm9yTevfnWRDnJjXpfuZQZGVZ+m7fo9Y5lWVP+bj8Z6TU5JuaRs9ndLsWag7ciTl2 8LcwGAA==
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

Compared to the version reviewed in v1, the only change is that the new
mk_sense_buffer() call uses the combined UNALIGNED_WRITE_COMMAND sense
code, as this is based on 7.4/scsi-staging.
---
 drivers/scsi/scsi_debug.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 170d5c944b61..a4db282ac971 100644
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

