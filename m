Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD5B16D9C2;
	Wed, 16 Apr 2025 08:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744793007; cv=none; b=Ltq0Bm3ZNR3ubuRg5vDQmd7BupHLRq/Ni83/EcJ7qfTVFoZD9JeJfkq9S/8vBuftE6RPMH0WvVR/BmYb9/j696LRuxXAtFNULMZPIfhMNMrl2l8+epE7y+8r6dHvkdOx0pSyt9RZcErm8eMxDYJ+07AKwp3f2lPpFWGHwA+TRg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744793007; c=relaxed/simple;
	bh=KwlgcXLBhIHGmpxNvfzwJ3uUqjR5Xd4tQVjp6spfW70=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgYvy6YzgVV1W5opRgLHBi14e5nAu8YnhLbpnvthi9UN7qgxWczXi1sIeAUSbPGuR5+EbCLVHABITXp1uMUfa1XDTfQy2xK2Bk+ZErKYQFwuk799nYYoAVKqOADbs3yovqBMx/E84TG5I5heuIJHAnTHedhjiq9pkcpNR/K9l2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZAc2IfLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAc2IfLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1D4C4CEE9;
	Wed, 16 Apr 2025 08:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744793007;
	bh=KwlgcXLBhIHGmpxNvfzwJ3uUqjR5Xd4tQVjp6spfW70=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZAc2IfLMyaYNcif6p1K4oPtCzRRmlkwG/wfbRkUR/M210aG6ZzUqRBvk1HbX8anOX
	 ApFr/cQtnLKZIRuuaSa4yRhCVPxTX3jRCsuhEedoOqiyxtLn5VFk9fZT7PpuwqTy6E
	 XSD0SSXv5WBuuimgInPtj6GSJfCx8JN5YEo/boyAnXioXwW9B9mY8ST4Y+gkOuCrby
	 F9P55X0SIP0GT5y/SE6WBAY+HuzF+7EX+TZC/r4OnDau19gW0MyaJdyaydvOwTK0h2
	 nnIgYBO9A/8u5klhgrh1FRg2yVSLEJxXRWBRxH8zmFv8YtyUkjFTPTfaYnMv7Qa3mZ
	 1zUurgd8b8rwA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/3] ata: libata-scsi: Fix ata_msense_control_ata_feature()
Date: Wed, 16 Apr 2025 17:42:36 +0900
Message-ID: <20250416084238.258169-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250416084238.258169-1-dlemoal@kernel.org>
References: <20250416084238.258169-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the ATA features subpage of the control mode page, the T10 SAT-6
specifications state that:

For a MODE SENSE command, the SATL shall return the CDL_CTRL field value
that was last set by an application client.

However, the function ata_msense_control_ata_feature() always sets the
CDL_CTRL field to the 0x02 value to indicate support for the CDL T2A and
T2B pages. This is thus incorrect and the value 0x02 must be reported
only after the user enables the CDL feature, which is indicated with the
ATA_DFLAG_CDL_ENABLED device flag. When this flag is not set, the
CDL_CTRL field of the ATA feature subpage of the control mode page must
report a value of 0x00.

Fix ata_msense_control_ata_feature() to report the correct values for
the CDL_CTRL field, according to the enable/disable state of the device
CDL feature.

Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-scsi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2796c0da8257..e6c652b8a541 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2453,8 +2453,9 @@ static unsigned int ata_msense_control_ata_feature(struct ata_device *dev,
 	 */
 	put_unaligned_be16(ATA_FEATURE_SUB_MPAGE_LEN - 4, &buf[2]);
 
-	if (dev->flags & ATA_DFLAG_CDL)
-		buf[4] = 0x02; /* Support T2A and T2B pages */
+	if ((dev->flags & ATA_DFLAG_CDL) &&
+	    (dev->flags & ATA_DFLAG_CDL_ENABLED))
+		buf[4] = 0x02; /* T2A and T2B pages enabled */
 	else
 		buf[4] = 0;
 
-- 
2.49.0

