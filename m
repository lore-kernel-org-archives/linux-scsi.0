Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043C045C6F9
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 11:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248904; cv=none; b=SFjwWhxVNYohr7uJrLyXdnQ+g/k5Pxp8gamiUjkPW3hQwdWKxvWAnLqtZ9ychELPUx6l7PzBK8oVojmBbEqb1wkKIm8tS52d1YrYfRM2BLCuag6Qo1u6+FJk8/0TLDceVwBS9t/UEV61zkVmPu4pj6hfaJ/qCe28yiOPRW9hC68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248904; c=relaxed/simple;
	bh=4SOu81yTRppMjmvYzStwz/4XSobf5kfsWdTXYk3JlgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XX7BU4jN8pb2zG8tIXfsGvKIHuL+cgtMycz3ao0OCutg3cDEG6EttvBJtQkOEA349LJ4Lgm8jsGK5I43yK7UVKcw/TXIZBPl1/9yK1+oGGPq/0VtW+GFPnRLwj452S2tpi6Hl5JzlcTprta/e+gfcfScmc+IPaU79iyFBpcWdqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZrPt1Cmy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZrPt1Cmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8089A1F00893;
	Thu, 24 Sep 2026 11:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790248901;
	bh=ey0gyz67TSo2myMlN7dPMXp4he7umj2+wNfXxNtkXX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZrPt1Cmy9XX7EVgHLLHEHTACznYxIGC+UKWzEbo7TUHpIXSwzVGiCLIhmcGpS0C8g
	 Dz54Xnt8nc4kw+D26gBhK1pCn5TFDlLJkshDLw02110iJvZFLe4U/nlYdrCu9xMXIi
	 6bePAcCPa/7BBOFAjyRwOUFDv1kZhwQJVEVFa4bUYak2S0Ms305Y5wrINBUBRe95QP
	 IrONuZHRPzZbI+9CqvRjXf1YS2gsiuFdJsE3VAIzqqW1shnGF94M3b6R/IqWHltO/9
	 USi9yPEvZv4y/49e3g0eCpvF7zdzTiEimfWYeV/08oMXrTqkLck3LCIknx5w7EcPbf
	 TBcJFkCeNaMPA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v6 01/11] scsi: scsi_debug: Refuse a zoned device with a non-zero lowest aligned LBA
Date: Thu, 24 Sep 2026 13:21:29 +0200
Message-ID: <20260924112127.3815255-14-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924112127.3815255-13-cassel@kernel.org>
References: <20260924112127.3815255-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1627; i=cassel@kernel.org; h=from:subject; bh=4SOu81yTRppMjmvYzStwz/4XSobf5kfsWdTXYk3JlgY=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2su+2O33a0GBvZS2D9Pk7/PknxY7KurIr3Zl5xVCnZ sM9IZm2jlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAEykZDojw4nXr57kpT+YzJe4 9HbSuhP1qzVSXHSe2t5JMX9gvdpywzWGv1KGkm0xC0QNvkgoMn/aMVOaVWrfh42fJVjEZn9W0jV tYAYA
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

