Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9537EEADC;
	Sun, 24 Nov 2024 11:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732446614; cv=none; b=hO1bznIJtpJLvrEOy1Tg4t1mdeAT6u8yCQ8Q1saewQS6qmEAk58SI2aKXmOF+Haljdgmr34YlvxZtUkVZ+W20Ecq//kQNrl05kfy05IdSdNnQsl9kqHIUJB676t/x8ezHmOb9WR3uP8Fq3dE+s/nKHnEfZwauzjj1s29wpFKrmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732446614; c=relaxed/simple;
	bh=Do7uwsVVa8rqyOiG3sBFC9k0IxQ5rddBOiVL5p0J6qw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dy2n0BTVjynB/5iqVelZU+aWGbyLHroCw/KxhlCO8NGNcWG/kAkFPo//y/iEjXwxin9qJISqmDdEhSyXLK1YvSOat6ojmXoQcQqcPG1lCRn4Z3V/59EmJy7EqAINWA0z7/y5ignWniVDsYOsa/mF+BwZ5FnjpMqLNkI5ZG3oCn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=pmWGfJlD; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pmWGfJlD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1732446612; x=1763982612;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Do7uwsVVa8rqyOiG3sBFC9k0IxQ5rddBOiVL5p0J6qw=;
  b=pmWGfJlD2oXBPCgHeFHO/UmNJO8m+Uwnw7MNdLXzdMH4QaFWXoj5w4N2
   AG9e9aiqtj1AGPgLthckcw3K0J6ROZDD6ICpQ+mBVWQPoTryAipPfQxHz
   WpXaB+VSr/Scg6jY+7Mp/sZtn10rUYI1dc2PoMgtiwYX6yMvfbeH+1NPK
   iz016sqwXD9HQRFTgsgYkVheKMvwQYC2B762fFPFymhqb+OnsBUPsxT+A
   9K21hQLjLRzYrbnqhZNijdPYpBLCOHLxkWjYDKgZ5t5pIFrjodmrci2jv
   OJbMD+ZYsKq2yjXmj/iysdPc+vLVjw6+ydE3tbqvznXzUG7U+uZPESHUF
   w==;
X-CSE-ConnectionGUID: 6qfPif7ZTl2iajierJHEJA==
X-CSE-MsgGUID: xYCz51yKRB2MOxO0hZlVxQ==
X-IronPort-AV: E=Sophos;i="6.12,180,1728921600"; 
   d="scan'208";a="32752736"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 24 Nov 2024 19:10:06 +0800
IronPort-SDR: 6742fc41_QTPXUQ3iXQzsI558iBtQnGJG6HR0KBqnQnmgb68M90qOtp3
 b4NZB3Hy58sZiPbing8hEej7SdVY2JHFTX4GQ4Q==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Nov 2024 02:13:22 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Nov 2024 03:10:06 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs: core: Do not hold any lock in ufshcd_hba_stop
Date: Sun, 24 Nov 2024 13:07:47 +0200
Message-Id: <20241124110747.206651-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This change is motivated by Bart's suggestion in [1], which enables to
further reduce the scsi host lock usage in the ufs driver. The reason
why it make sense, because although the legacy interrupt is disabled by
some but not all ufshcd_hba_stop() callers, it is safe to nest
disable_irq() calls as it checks the irq depth.

[1] https://lore.kernel.org/linux-scsi/c58e4fce-0a74-4469-ad16-f1edbd670728@acm.org/

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index acc3607bbd9c..09a5ff49da5a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4811,16 +4811,11 @@ EXPORT_SYMBOL_GPL(ufshcd_make_hba_operational);
  */
 void ufshcd_hba_stop(struct ufs_hba *hba)
 {
-	unsigned long flags;
 	int err;
 
-	/*
-	 * Obtain the host lock to prevent that the controller is disabled
-	 * while the UFS interrupt handler is active on another CPU.
-	 */
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_disable_irq(hba);
 	ufshcd_writel(hba, CONTROLLER_DISABLE,  REG_CONTROLLER_ENABLE);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	ufshcd_enable_irq(hba);
 
 	err = ufshcd_wait_for_register(hba, REG_CONTROLLER_ENABLE,
 					CONTROLLER_ENABLE, CONTROLLER_DISABLE,
-- 
2.25.1

