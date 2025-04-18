Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0E526AA93;
	Fri, 18 Apr 2025 07:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744962970; cv=none; b=Frw809sYWawxKtMJ2G5+zZPni3ls2okp9nhpB6VB+jE+klqmY6T3ZbdHz8Gp+t7DOzftAgXlaMy23QzOzpMVomKC3GV4bvJLfj8qMbMdj7yT+Q/Yb6o076I1rKATNZigCee+9mUj/gIkZJNcK+1Ki4IaN7Oq/CDQtvnUbcpQA3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744962970; c=relaxed/simple;
	bh=8UnRA0IbWyrZMKkMnJdWzmhwS4iXZiwv9j4AZ1nFMGU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wjnyz7d7LdJ2j5MSPDPU4PcgxzkYNASUgtXRpHsN2pl5WzjHtNVjaeZ1OUqnudTE0ceYpbXSL3Mv+K2WsOwDccgeUg7oTC3qRASI9mwJUKKAwnSQIbkjZ7x4/AEpGRdxYsW/PKuk+twTZhhISciupRf5YUv1LcAHOoI7bsn9N20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnLK1EFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnLK1EFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68758C4CEE2;
	Fri, 18 Apr 2025 07:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744962970;
	bh=8UnRA0IbWyrZMKkMnJdWzmhwS4iXZiwv9j4AZ1nFMGU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WnLK1EFYaIj+AxqS6J7b8pZUCZFzhw83qCJG0brnEca9Z1lWNg2gy3V+CTrJ/2F1u
	 UZ605qMkaAAkq5Lk09NUvsH6JuJJ6SIMnQNUzgoJSWkl9v+yEUglc/r7RrNdWrVTaW
	 owmKor3DAVwc+SH2uTgnGDR8843iT96alr9dVyrcW2Qa0UAsj3khjnRvIiH7Ue+P8T
	 10MSg6M0osTYPNru9qMrF6+2IDvsvbK/k95DPhrFQgQ2WM3U4h63Ku0NrOCnm0vkAe
	 CuqMH+vmKAhQ+FmxQvCrGYvY3aoCfzTyldwc8grc17v8iXSm3Baypcm5DDi6KvycKE
	 6Shnx5U4NPY3A==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 4/5] ata: libata-scsi: Improve CDL control
Date: Fri, 18 Apr 2025 16:55:16 +0900
Message-ID: <20250418075517.369098-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250418075517.369098-1-dlemoal@kernel.org>
References: <20250418075517.369098-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With ATA devices supporting the CDL feature, using CDL requires that the
feature be enabled with a SET FEATURES command. This command is issued
as the translated command for the MODE SELECT command issued by
scsi_cdl_enable() when the user enables CDL through the device
cdl_enable sysfs attribute.

Currently, ata_mselect_control_ata_feature() always translates a MODE
SELECT command for the ATA features subpage of the control mode page to
a SET FEATURES command to enable or disable CDL based on the cdl_ctrl
field. However, there is no need to issue the SET FEATURES command if:
1) The MODE SELECT command requests disabling CDL and CDL is already
   disabled.
2) The MODE SELECT command requests enabling CDL and CDL is already
   enabled.

Fix ata_mselect_control_ata_feature() to issue the SET FEATURES command
only when necessary. Since enabling CDL also implies a reset of the CDL
statistics log page, avoiding useless CDL enable operations also avoids
clearing the CDL statistics log.

Also add debug messages to clearly signal when CDL is being enabled or
disabled using a SET FEATURES command.

Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/ata/libata-scsi.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index f54e8a3dc46d..589dc0df63e9 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3917,17 +3917,27 @@ static int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
 	/* Check cdl_ctrl */
 	switch (buf[0] & 0x03) {
 	case 0:
-		/* Disable CDL */
+		/* Disable CDL if it is enabled */
+		if (!(dev->flags & ATA_DFLAG_CDL_ENABLED))
+			return 0;
+		ata_dev_dbg(dev, "Disabling CDL\n");
 		cdl_action = 0;
 		dev->flags &= ~ATA_DFLAG_CDL_ENABLED;
 		break;
 	case 0x02:
-		/* Enable CDL T2A/T2B: NCQ priority must be disabled */
+		/*
+		 * Enable CDL if not already enabled. Since this is mutually
+		 * exclusive with NCQ priority, allow this only if NCQ priority
+		 * is disabled.
+		 */
+		if (dev->flags & ATA_DFLAG_CDL_ENABLED)
+			return 0;
 		if (dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLED) {
 			ata_dev_err(dev,
 				"NCQ priority must be disabled to enable CDL\n");
 			return -EINVAL;
 		}
+		ata_dev_dbg(dev, "Enabling CDL\n");
 		cdl_action = 1;
 		dev->flags |= ATA_DFLAG_CDL_ENABLED;
 		break;
-- 
2.49.0

