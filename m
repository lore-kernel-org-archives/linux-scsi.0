Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696F0171D2;
	Fri, 18 Apr 2025 07:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744962968; cv=none; b=Gk1cjGKUCcCaxg0BnvEhWvj+Z4rq1ltH5yvz4YwXZQadOnFmE9AV0d2Jr89JVYYD+StGoF9cKxRL0wImNBaDic2hO3fzsM6gV8hqtAtsWSE+aEI5PP8rTVCiwBnXI9A843RycXqCz2O+kKnRxEKmrUGj0Lhd1Xo4P3CRhsySNNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744962968; c=relaxed/simple;
	bh=BAsegvms7haop65f0DlfFwI/oQc+5+ACN6HlGOF5fq0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ygo04RA/KWJ5/ty6l/+ff9CraRuotpSwRFXpHW7qCHK092s3knc6/wjpa+meGYzzphXRD3MY9EZCoqlyZVXTJG3xvT52BFzKcLSTtbvN3dFZcaTGGYpiCp2ghzLZd4TYWdnfvfu3ZVvzMcuy0A+7yjXpiS7JOwKhgVUdhMGp8NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GhR/h1vf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GhR/h1vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9E0C4CEED;
	Fri, 18 Apr 2025 07:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744962967;
	bh=BAsegvms7haop65f0DlfFwI/oQc+5+ACN6HlGOF5fq0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=GhR/h1vfyNRoKc05dEJDKRSLisWlctytplVOx3sRBGX+8RXPYMMZkzDsZMfBVEUcj
	 Q8tPuMMHA9UudSgFQs6ijUxIgkqgjyE8qHoaoNQyDvcv6SWaYBMUNuNauEz7GAfd2C
	 pduIZZMpQGHK5yOQ5CYo44xMb3FnKbc3cGLhQ5DA6+5jk4L8UbsYUnfuo4d+27F/af
	 8HrVCPeLrKnv/X57HOmh65Xu9GKSlFVvnGrxwWIKPD1d8QoFmSsm1CDo2ONotv8ISC
	 RiKcK1x3ul2yVPtEDAnA2UE6+1hGUBzxaKM6hkyLtYeAZEMFwR/n8iz7LaA0c59fbh
	 dvcHNEBV0sjGw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 2/5] ata: libata-scsi: Fail MODE SELECT for unsupported mode pages
Date: Fri, 18 Apr 2025 16:55:14 +0900
Message-ID: <20250418075517.369098-3-dlemoal@kernel.org>
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

For devices that do not support CDL, the subpage F2h of the control mode
page 0Ah should not be supported. However, the function
ata_mselect_control_ata_feature() does not fail for a device that does
not have the ATA_DFLAG_CDL device flag set, which can lead to an invalid
SET FEATURES command (which will be failed by the device) to be issued.

Modify ata_mselect_control_ata_feature() to return -EOPNOTSUPP if it is
executed for a device without CDL support. This error code is checked by
ata_scsi_mode_select_xlat() (through ata_mselect_control()) to fail the
MODE SELECT command immediately with an ILLEGAL REQUEST / INVALID FIELD
IN CDB asc/ascq as mandated by the SPC specifications for unsupported
mode pages.

Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-scsi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 24e662c837e3..15661b05cb48 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3896,6 +3896,15 @@ static int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
 	struct ata_taskfile *tf = &qc->tf;
 	u8 cdl_action;
 
+	/*
+	 * The sub-page f2h should only be supported for devices that support
+	 * the T2A and T2B command duration limits mode pages (note here the
+	 * "should" which is what SAT-6 defines). So fail this command if the
+	 * device does not support CDL.
+	 */
+	if (!(dev->flags & ATA_DFLAG_CDL))
+		return -EOPNOTSUPP;
+
 	/*
 	 * The first four bytes of ATA Feature Control mode page are a header,
 	 * so offsets in mpage are off by 4 compared to buf.  Same for len.
@@ -4101,6 +4110,8 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	case CONTROL_MPAGE:
 		ret = ata_mselect_control(qc, spg, p, pg_len, &fp);
 		if (ret < 0) {
+			if (ret == -EOPNOTSUPP)
+				goto invalid_fld;
 			fp += hdr_len + bd_len;
 			goto invalid_param;
 		}
-- 
2.49.0

