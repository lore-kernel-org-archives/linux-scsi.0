Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F593171D2;
	Fri, 18 Apr 2025 07:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744962967; cv=none; b=k2g+PTNpsjmZOcQPbiC/nVKEoh6dphavXdyXykBg+2mJ0r8l9pt8uUWy/wJWuc3mqC/Cw4gN2zntnRd/CH+ziY6ZCf6FsPRgvmD5zNNWko0ma2kkHxZYz7mBFIqiTBocL2p4Zf/e4ON9ywiGX5DE5+QFUUs1Ma+PmjA+XWM5uYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744962967; c=relaxed/simple;
	bh=Pd0q18P/a3uTz10uUBdmoKLjD8pYs76ReXf8d9zqkpc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qH7Z4hcRPx8zLMIze2Hu3ue4dp1KECOii3iLzXeFJeg45teIsFfwP20nbWni6ayPwN3//XRJ6AZZ9zSawOxGl6nd4n9Bpa947BC7wpcrlstlstEqQQ8PJp2tRRSk+SP9jOXGrd5+KlMgQjsyk2sQpzPILNx9cl3sRog+tOzz2SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WLKD3PTH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WLKD3PTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1520AC4CEEC;
	Fri, 18 Apr 2025 07:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744962966;
	bh=Pd0q18P/a3uTz10uUBdmoKLjD8pYs76ReXf8d9zqkpc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WLKD3PTHq2WvQ3pODLz33XwH4QmP7L98FBvXc680VECph7eO+915P0ISucxLOVduy
	 dg1l0Z6t3ycc9XGcrp9HWADauRmiqO/FuU+jTiNavjy+j25Q5oIYwjICX3TCabxKfi
	 SDiSHw/PPgaDrVvBLWDT/XRFSFgshT5NqWwMlm6voImhaKZOi5sLs0elunQFxaRrgX
	 6o/nDI69HVuLDudMMzO01MwaK8hc79KhJ/zeme69HcgNzjbgq8rCJ1CSRyJ2SgBnXv
	 rpWuK0Q1u1fTXa0SEPOLSoiJE1CtLt9zxi0CkgP3hJtps+dYHF62CA1RFGRuYOxCCp
	 EThzjeCFrAPkw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 1/5] ata: libata-scsi: Fix ata_mselect_control_ata_feature() return type
Date: Fri, 18 Apr 2025 16:55:13 +0900
Message-ID: <20250418075517.369098-2-dlemoal@kernel.org>
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

The function ata_mselect_control_ata_feature() has a return type defined
as unsigned int but this function may return negative error codes, which
are correctly propagated up the call chain as integers.

Fix ata_mselect_control_ata_feature() to have the correct int return
type.

While at it, also fix a typo in this function description comment.

Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-scsi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2796c0da8257..24e662c837e3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3886,12 +3886,11 @@ static int ata_mselect_control_spg0(struct ata_queued_cmd *qc,
 }
 
 /*
- * Translate MODE SELECT control mode page, sub-pages f2h (ATA feature mode
+ * Translate MODE SELECT control mode page, sub-page f2h (ATA feature mode
  * page) into a SET FEATURES command.
  */
-static unsigned int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
-						    const u8 *buf, int len,
-						    u16 *fp)
+static int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
+					   const u8 *buf, int len, u16 *fp)
 {
 	struct ata_device *dev = qc->dev;
 	struct ata_taskfile *tf = &qc->tf;
-- 
2.49.0

