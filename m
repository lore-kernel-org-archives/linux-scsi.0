Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766D516D9C2;
	Wed, 16 Apr 2025 08:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744793008; cv=none; b=mgYHVKws/qePMeajUQPBL9RifA0MEgj+B+3gQB3+qIKN6e+SnqdqxhuBgD6+xcnZ5UxFOr9vBf6THbB4c8KhSa80g/1DMLcldUXJvKwU+nUK1b+nbYGzJ6wSVHdg6vFVDPQCdlsMhMj4OTLUEgLX5sCF4ATrtK/zcwih6/Rnzu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744793008; c=relaxed/simple;
	bh=TPzmugDmNNfyBq9wQg/xVIAEkeYNh6rd45Qp3mXyhf0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODJio7zwWZ7KTs64tIpUZJwmN5Qe/DPt9v8fboKCH2n7vm7SqbMOBRpgRhL0TC9KlpfHd8bLFoLwrAlCp+pg4gaKJs9YRL0VxaxV5YE0sOtFZjsFPUBsMmQYdLmc7PyzfccvJRSP4hhF+mdMx47CE4bOvFGMB1qQLm1PnX+k0iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mAultcUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mAultcUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E384C4CEEE;
	Wed, 16 Apr 2025 08:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744793007;
	bh=TPzmugDmNNfyBq9wQg/xVIAEkeYNh6rd45Qp3mXyhf0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=mAultcUCa2OKDceDdfWh9ipu+bXq38zjHrRsVEtwdjvS+GEqyAvN8dyXUllAQhnNK
	 0J+aquiVWVlTln5agDVgOG23WGe4LPu9jQXP2VYomNef+7WojbCwY4YSlDFmnMOCCr
	 0rjw2bVFUEMKD5Z0YUdsRw90XlQE/H97GKFo5agHRZjxIHBo9IQlirRVf68NJVCeAv
	 YppheyljiGh97OfyRumfwvFiggAH7vjze+39wYnq+rTlOyVSkGnUi7a8kPqvc4pCSm
	 pkMIaptZwSlQWUNVOzwp16HguZtiYxO+3olKD7+K8VRpzJJfh/U64ZnYA1Yw42B208
	 KfHJkusjok0Ug==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/3] ata: libata-scsi: Improve CDL control
Date: Wed, 16 Apr 2025 17:42:37 +0900
Message-ID: <20250416084238.258169-3-dlemoal@kernel.org>
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
---
 drivers/ata/libata-scsi.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e6c652b8a541..6c73a8066381 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3910,17 +3910,27 @@ static unsigned int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
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
+		 * Enable CDL T2A/T2B if not already enabled. Since this is
+		 * mutually exclusive with NCQ priority, allow this only if NCQ
+		 * priority is disabled.
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

