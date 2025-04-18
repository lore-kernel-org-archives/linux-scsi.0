Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384631FFC62;
	Fri, 18 Apr 2025 23:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745017634; cv=none; b=kvYq7GKxNX+cESmG+q2BirZ2gCa4MBbG3C3CStETn3HjZeKnooxt2gBB08f3oFnOok622upNVcPsYT8GVwkpg/Umjqwd9g0TdfB8NdVSKUQ6nTWSq+wZSPvjGV0665PJbVOOGS/MSj0ewPhXfeuRrmdFGOklFCGhyXLtyFtQGc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745017634; c=relaxed/simple;
	bh=GCeuDVfdj52bosH3/PmUB1mxWyx2YRuNt6i+EHwTyx8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzUkH7Evh9uncgNE7SmWhWCUlCXq/gpR3SDoz5BaOkFZOwHKGBsoNtZNwkKzbSZs2227AnopgetSB+dz5Wbjq3CJCWTWeTCqDgcG9LfzyY3jaFqs+VWcVJ4cP2lCQusI6oMxWI89M6DiKWWuu6cmO2sAWDafuXWmoTTsPiNBFv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=av53x0Yh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="av53x0Yh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF44BC4CEEB;
	Fri, 18 Apr 2025 23:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745017633;
	bh=GCeuDVfdj52bosH3/PmUB1mxWyx2YRuNt6i+EHwTyx8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=av53x0Yh/ZGr4L4XBX2ORsGvJtbg/9++BQ830OXubJmdIE6rsMFbs7Gj9/i4gnuMg
	 HKiEebICpb/qbXn9E6PMqNSZwEjqPDN8vSmbnISV+vZaoRGONV8V3NNZX6uk10k5Pk
	 IBZupYi6Xwu3BV+4OMAWshJOUgw3yfDMXDwAOZdvhR9B75TXMcAcQ8I/PBRTmuVcB+
	 xntfhZj5GzjMZbo5ZoI4cuZLZdkh8ABQrJwOg+JgYVCDHHh56bjlSR8KqE77he5C1D
	 m6q8ZfJepRPuHkFIMDYZ8fzvRUcTCtqWVUFLX7QwhGUFnXG5eobxejhaTx75VuPQJx
	 YeN+HNU5tETrA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 2/4] ata: libata-scsi: Fix ata_msense_control_ata_feature()
Date: Sat, 19 Apr 2025 08:06:21 +0900
Message-ID: <20250418230623.375686-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250418230623.375686-1-dlemoal@kernel.org>
References: <20250418230623.375686-1-dlemoal@kernel.org>
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
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/ata/libata-scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 24e662c837e3..a41046cb062c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2453,8 +2453,8 @@ static unsigned int ata_msense_control_ata_feature(struct ata_device *dev,
 	 */
 	put_unaligned_be16(ATA_FEATURE_SUB_MPAGE_LEN - 4, &buf[2]);
 
-	if (dev->flags & ATA_DFLAG_CDL)
-		buf[4] = 0x02; /* Support T2A and T2B pages */
+	if (dev->flags & ATA_DFLAG_CDL_ENABLED)
+		buf[4] = 0x02; /* T2A and T2B pages enabled */
 	else
 		buf[4] = 0;
 
-- 
2.49.0

