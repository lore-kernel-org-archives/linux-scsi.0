Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3117523D7DC
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 05:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790486837; cv=none; b=c8il0Jzj9buX0M9UhtHEPd8C3iISjT5d+fQWsbvZXvbQ/LbHY3zhPS8fdzGn51kns/6mQIYaKbkL9nTAZb7wFnpK0xINLTCAWGTgqF3ge3RxUv5/C7Kp90z3yovvs31XHvTUAqGmkZ0Jeho6VxdOqZtvqvZ8SgHm6x5npP5qFxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790486837; c=relaxed/simple;
	bh=vQR9sgPNWQDmtgkED84OjVo4rVaPA4w09hXhR7BHM5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A40E16K4iOoyzvLrSsbzYBTEmuWKJ9npAlEitRGIcHNr3RRcQ1BIUhZQ9uYfMTGo+q9br3xHYLGhuO6cFM2D+8tjLCTJRegMzd8MKgNoWgseg8qn0iHYRBiajspxrkDfHxHHanztdcvlhhuGRjE92Uo+e5/8pY1wnhmUKRnz6ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eflb56Ny; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eflb56Ny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D611F000FF;
	Sun, 27 Sep 2026 05:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790486835;
	bh=BVWbBOR5lPWbIvPOwV8i9kI6T0nYT3jdtittOmrPHos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eflb56Nyk/EQPrBkooe58/H5PR24Jvnh9T517EDJOhvL6Y8K6eXRW1JsaNjtrb+0K
	 qd49gdRXfrMvko3XXVpGd8tpX9rc9f3hZVJzlkiXTtMA5rAjtbuT/LHb6NeHjRFXhd
	 WZ/dU27fCYYFKI86LC9pDGk5gHxz2oCs2RX9I+qOQQrFnsrt8vq7ymWOrP4vNFhKTt
	 yM5iEbMf++oUlFgd2/Xvy8kZYnTl/Lx2x+w0CuBl+VgIg34Dw49kRjQ23OKSfb1aIi
	 Xi8boVVHQSi6mbJEulvsPm7NUjP+dZUBu8lv8VH6bLKTnOaBdPLoPCeMebKy+32PiX
	 9sWZlDlAGHP7Q==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v9 06/11] scsi: scsi_debug: Enforce physical block alignment of zoned writes
Date: Sun, 27 Sep 2026 07:26:57 +0200
Message-ID: <20260927052650.567035-19-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260927052650.567035-13-cassel@kernel.org>
References: <20260927052650.567035-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2828; i=cassel@kernel.org; h=from:subject; bh=vQR9sgPNWQDmtgkED84OjVo4rVaPA4w09hXhR7BHM5Y=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2rFSYafM43UF1kttyyyy9rl69csl72ulTYtzUTIx3x K6SOhzXUcrCIMbFICumyOL7w2V/cbf7lOOKd2xg5rAygQxh4OIUgInwXWBk+B3rLzPZeKL7ydpi EwPXyL6Fe2s3zLM95GlpXHS2/hb7H4b/boq5SUlPbbY7tiQ2rd3PZuf7aXXCoutXhGJq58l/eT6 XGQA=
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
index 0c66a3118ee8..82f93c63923c 100644
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

