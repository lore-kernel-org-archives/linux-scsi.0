Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F081FFC62;
	Fri, 18 Apr 2025 23:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745017635; cv=none; b=u1fVW1obKpdTpD7TE897RpTGAqveOCj+3l01Y9ta54uULsd90bMMjxLSO0aD0LU0I/pi0VeHTF2y+qhWlFnf0IulnK558FyxPPjV/gp0B++mVNdSBOLCqKTFNTkYMeHP10/pT6ufPPVRY0dmt1tKDE0c0w7VVYfBlBuTp6MUYWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745017635; c=relaxed/simple;
	bh=ySLUjTOMThNWUBCNKEwE8WqbZBkpBliSRmMskmkk+yc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlIqS0XbloSQTvPZVsLmsG5M7Ajot8MhRtQXnX3yxh/HdZcP2RHSGmlhglpF/g8+9/wF2g5nTxbaVPlGni2vcS29kP7S5dI8qv6yXrex3zsuXaKuGmPsrxab3OzR2KZYJ4bW3USezrIx5EyWa3ZWVj/Jz2Dh2UzYkJFLPz/22NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=old/7Zj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="old/7Zj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D80C4CEED;
	Fri, 18 Apr 2025 23:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745017634;
	bh=ySLUjTOMThNWUBCNKEwE8WqbZBkpBliSRmMskmkk+yc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=old/7Zj0kvVZ131b7D94JeobLuGA3mUIbiQLeHiVxgeSd/pyFgF9ayHqr2deaKrcq
	 4LjK/tKahhGra8LBvpF2eoUBTTKsJLDM5KUHkl2U/JMmsqr2qjI0fdW/bGOQLR7wm9
	 Km01bUZ+PqqFbYtKuobt+/SxZopZrtySTDQPcI39mjkSMNgpSDllOc94Q4wymMYgPP
	 F8IGJJVsV5wupRx/ZndQwSq3ZiSZJbb1PqVQ8yur+x2XwFDr2OTT5jI1SN284PTlab
	 5JjR6Pv7GUWCMYYZklE6BnnmZAg4hJGBRcYMnxTlmFqGCdGFP2IAopn4qdCcYKEWrQ
	 xWrIGxzAQ5HRw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 3/4] ata: libata-scsi: Improve CDL control
Date: Sat, 19 Apr 2025 08:06:22 +0900
Message-ID: <20250418230623.375686-4-dlemoal@kernel.org>
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
index a41046cb062c..c0eb8c67a9ff 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3908,17 +3908,27 @@ static int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
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

