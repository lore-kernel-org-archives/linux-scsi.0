Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7851FFC62;
	Fri, 18 Apr 2025 23:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745017633; cv=none; b=ULhgzHUDshnrzV8hXmM8leQrLaINmbq+u6lblMREo+E90KqyPFZu5/rO4wHt+GoZr5SpG3XT48Y+3xSptX/KHxa3cp97PLjKSpOOqb7STYrJuOYGjSVIO9YG8capDgqas1CC0zIpI9sD2cLjsu9t4GSkBdPVQRnkkN+HP2ADBro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745017633; c=relaxed/simple;
	bh=PAUBIgCu2UKGy9eddUYp7x38K4GGCEnZYI5Q2ay85ts=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vh8fRS4ai71xpSk9HkLwVJdupSlF9jh+nd2j7TQNNSCy5KeGM/Q9qVzUv9DKtOcGn/HbvjSpO89VH0t+cPovSuh4y5Z4NCQflh+DucMvwPLtQL7/xd5XHcyVm4XaFjzysQfXm5Styq2dintx6Vz1nqvUu97hYEAa1P5TdsbTOuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FGgaEyos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FGgaEyos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A6BC4CEEC;
	Fri, 18 Apr 2025 23:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745017632;
	bh=PAUBIgCu2UKGy9eddUYp7x38K4GGCEnZYI5Q2ay85ts=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FGgaEyosTaf9mjA48PhPr/VWnosIt4+magB1tcZnredsTOgWwcPBqH4UfBaGdKGED
	 R5zRbBs4ILy09W9AsRpyIRsX9TUjPmwV0f1YblYpsVZlmDipP4aelvIniNwD9ZAlXw
	 MO7eaRtMZ6khhZCL1EMnG4o2nYHwweiZEfQjHBsbeO2RX4C0Humrj+8SnEJEh/esj2
	 paBEcLcSOL/EkjuWeaNpwLrjxIWEG6Jr+LVnha/l+lHQoo0G2knCHRLVGeq3d4aQ4P
	 7f2F3k0fnhNzlJXNgmmrgGOZ8Zkj3lek3iggyYs++DYhKdyKHX1fuHV7Fzii/wdXgS
	 Y3QTkDQiV/X3g==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 1/4] ata: libata-scsi: Fix ata_mselect_control_ata_feature() return type
Date: Sat, 19 Apr 2025 08:06:20 +0900
Message-ID: <20250418230623.375686-2-dlemoal@kernel.org>
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

The function ata_mselect_control_ata_feature() has a return type defined
as unsigned int but this function may return negative error codes, which
are correctly propagated up the call chain as integers.

Fix ata_mselect_control_ata_feature() to have the correct int return
type.

While at it, also fix a typo in this function description comment.

Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
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

