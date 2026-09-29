Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B1A3E2AD7
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 08:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790670364; cv=none; b=QvvjeLRNBqNZBpVRzJXcShKSRmudxi6lnefbyRCqJu16to2RhBT9kefNdwaOfvEfgm568hJYcy+bGhQGxlrfjDTjAEN2G2TROty9XxP00l9Ao20Ri5MnsqXFYACeJ5sXfWauREEeCkqteHv+3F1wQR3gwUiHMVNmm28Jc5E/9K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790670364; c=relaxed/simple;
	bh=4SOu81yTRppMjmvYzStwz/4XSobf5kfsWdTXYk3JlgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqRCId/+cZwMym7KNPPs1dF76YwitjCdjVWkJ7B5HE+y9sYrJ41NuufubKS7xfJVHvQap1PISP6c2l+oZ0JWM10NC4dAb9rSJNkY5vNPMbWAtjTXVf4p/RbilTnxYH4IPszCYCXeRr9/rzNXbGnurHRMeRcC72QmgFjliO9+PNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zx0RlbGA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zx0RlbGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFB41F000FF;
	Tue, 29 Sep 2026 08:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790670362;
	bh=ey0gyz67TSo2myMlN7dPMXp4he7umj2+wNfXxNtkXX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zx0RlbGAG2WRz+2rnz3y1+3zKbPX8jOPZT4enWdvOY8NGN37lOaNl7fbuIBYtL8Tz
	 WUTHSGWaIGVwnpQHkobPTypRExu/q2SZgJ5vwmrG9fzW9tjnS0pqmvV0/BleXIG+Hw
	 wtRjmWdzi/l/a1zj1j7+rEOK3BHT6ErKf6fa5potaK+SpXs6L6LhMTr4Xv/sBXhZlk
	 OfozSFTk0E3Bz6ojAaWmb1xrha4LntTZ9CColnidRN+iTAr9b56bop5db7HDdFElXw
	 ZwX0YG0Dv34w7bAUCH2VXSVVEfx/Y/1wG4qemUARVGasWwfcWD5XrQPrz1M/tCckWW
	 PT2WMzJsE+v8w==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v11 01/13] scsi: scsi_debug: Refuse a zoned device with a non-zero lowest aligned LBA
Date: Tue, 29 Sep 2026 10:24:58 +0200
Message-ID: <20260929082456.857423-16-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929082456.857423-15-cassel@kernel.org>
References: <20260929082456.857423-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1627; i=cassel@kernel.org; h=from:subject; bh=4SOu81yTRppMjmvYzStwz/4XSobf5kfsWdTXYk3JlgY=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2l76xO33a0GBvZS2D9Pk7/PknxY7KurIr3Zl5xVCnZ sM9IZm2jlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAEzEQ4iRYf1apTOX6ozDr5lG z8hgOFG6IXXdizVxgiZxHs15uWabvzAy/ORbHpVeUHQ/+oAFSzFHXmBDdlDmLS+Puzyntp3/M2c 3IwA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

scsi_debug reports the lowest_aligned module parameter in the LOWEST
ALIGNED LOGICAL BLOCK ADDRESS field, see SBC-6 r02 (T10/BSR INCITS 587),
5.20.2, but nothing else in the driver acts on it.

On a zoned device a non-zero value puts the start of every zone in the
middle of a physical block. ZBC requires a write to a sequential write
required zone to end on a physical block boundary, so a host writing in
units of the reported zone write granularity could never write such a
zone at all.

Refuse the combination rather than emulate a device that cannot be used.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested by loading the module with each combination:

  zbc=managed lowest_aligned=8    refused, -EINVAL
  zbc=aware   lowest_aligned=8    refused, -EINVAL
  zbc=managed lowest_aligned=0    loads
  lowest_aligned=8                loads, as the device is not zoned
---
 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6941809dfdb7..c664966e95cb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8734,6 +8734,11 @@ static int __init scsi_debug_init(void)
 			sdebug_dev_size_mb = DEF_ZBC_DEV_SIZE_MB;
 	}
 
+	if (sdeb_zbc_in_use && sdebug_lowest_aligned) {
+		pr_err("lowest_aligned is not supported by a zoned device\n");
+		return -EINVAL;
+	}
+
 	if (sdebug_dev_size_mb == DEF_DEV_SIZE_PRE_INIT)
 		sdebug_dev_size_mb = DEF_DEV_SIZE_MB;
 	if (sdebug_dev_size_mb < 1)
-- 
2.55.0

