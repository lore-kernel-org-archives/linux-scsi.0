Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2C8410D15
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790580091; cv=none; b=tKTvoArWcE+/9NpG4MdFYFMvF57vC1m/TIoHvUMfrJ0cA0Yj28CSJMpq5PJtpaa2VpDp7JiDNc5HiXHezFFT5hRZyveL/qCF/YMrCo2bcXYhFHniw507VV/ktnnCCbVpNkCwHxPUMWLQyYB/Ubv0n1yZAhE+hGFlA0alHkq+Rko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790580091; c=relaxed/simple;
	bh=DTjP0bmwghL0MmPFi0pXEr2YR8KXQtnq1m53yKiWqig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsOi9UX80/N09vxvq/VsCY2eL7q4xgMK0/NLd9ykJIK0Ctv3qBXtdR9T51ConoFdAc/vs/vL+9bj1Wn3F0vzFxNYwoxPxcbioFxc3Ld+GzI813Ho/EC7TXRYQBMmG1UIS9TX/uLPOM23dmntpIjE95WE36/zWVdeu+ta3zSmA8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XOgqi5IO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XOgqi5IO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C914C1F00893;
	Mon, 28 Sep 2026 07:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790580090;
	bh=uq+6nwNsvSrSBwgMryD5a7iW3+czzrzuM+qUCyGm/lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XOgqi5IO20IrOGsazIRU9yRLtl7ZHRSnpto6KLA4jIFb83hF42sv7EGR4SibBbMje
	 49CBu28Da4ybZpQsaJV6pLtEEEV5I/xa9OjrwwdbUm+zcyJjqKc49yd6E5WFLg44+f
	 4fO7NaJOtHGX1WKQnR23jb5J5U7lt3QqIHQRuKwYFppI6Z4a9LFJ35cB5gd0Hdn91/
	 TGLy2NDgB8wPje3RvPgJiVRvioS/4YR6PgkjvbndF20+HLoNpbhUYHr0+bq27wmAHg
	 +bjnt7Acj+I6PVkGbsVX1CjD1w9uJVqjkTNeJOQIYteAht/6kBcUVnH01Bg7h5u3Km
	 iAlL2/mgV7Uyg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v10 07/12] scsi: scsi_debug: Enforce physical block alignment of zoned writes
Date: Mon, 28 Sep 2026 09:21:10 +0200
Message-ID: <20260928072102.725566-21-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928072102.725566-14-cassel@kernel.org>
References: <20260928072102.725566-14-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2828; i=cassel@kernel.org; h=from:subject; bh=DTjP0bmwghL0MmPFi0pXEr2YR8KXQtnq1m53yKiWqig=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2iabzO1+8PVHaor1q6+RjwYEn96U2hahMWrmm/+BT9 TmvvrBO6ihlYRDjYpAVU2Tx/eGyv7jbfcpxxTs2MHNYmUCGMHBxCsBE2P0Y/grFXdRnqbs4Iy+2 2i/hYZ3ra33OfREhPdo3rTXXh05Ma2f472pl+S/y+sVvJy/wuTColaqmVecWhC/xMRaZ3jilIsC RBQA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

ZBC-3 r06 (T10/BSR INCITS 579), 4.5.3.3.2, requires a write to a
sequential write required zone to be terminated with ILLEGAL REQUEST /
UNALIGNED WRITE COMMAND both when it does not start at the write pointer
and when it does not end on a physical block boundary. That is why
sd_zbc_read_zones() sets the zone_write_granularity queue limit to the
physical block size of a host-managed device.

check_zbc_access_params() implements the first condition but not the
second. So with zbc=managed sector_size=512 physblk_exp=3, a write of a
single logical block at the write pointer is accepted and advances the
write pointer by one logical block, leaving it off the granularity that
was advertised: nothing can write at it any more, and the zone can only
be used again after being reset.

Check the ending LBA as well, with the same sense data, as the standard
gives both conditions the same. An entire medium write same command,
which the standard excludes, needs no special case: the preceding check
already terminates it with WRITE BOUNDARY VIOLATION. Sequential write
preferred zones are left alone, as writes to them need not be
sequential, and with the default physblk_exp=0 the check is a no-op.

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
---
 drivers/scsi/scsi_debug.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 691a5ad56161..b4583fe10ec5 100644
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

