Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB3D53E23;
	Thu, 28 Nov 2024 07:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732778884; cv=none; b=cMcwXZOzXhulzmzc3dVqDAM1Efq72KCvHHh+M9L0Mq4UKnyutbknzMPrxf0ez1E2HeqbTE4LTpvaa+m/ZRkZ7/wNaue+cL4gpLqJxDNhbaAG+1imdfQKoWzn8O+g/Tz8LM3JOvc0IMRu57062z4SsTDqEX+BT3gmKL5UVYlu9tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732778884; c=relaxed/simple;
	bh=Ku85X8mzrnaTSyCvg1AUWpg9Plj+lbD5bVe1VuXWAio=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g4jOD5YmCT0tCf+fScQHHlIs2eLhP5xPcFaCHeijdQGJJqh7+/gcluRYLcSllTVbU6rog1NcvjVEmq48xDMO+yhgKdvpaj0XOf/v8rHh/WhvkEELYNkWwpsOmmyjkwGu78/v2wYVxkxarwS6xu3dSVy23UlnjampkQT6x7jdcRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=m9d2ggwU; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="m9d2ggwU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1732778882; x=1764314882;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ku85X8mzrnaTSyCvg1AUWpg9Plj+lbD5bVe1VuXWAio=;
  b=m9d2ggwU6YtolLL3f46SM09GN13keY42QcuCpmibvfaIuDd99tk4QVl9
   n5SOC7h8NtrT7p4GlxMTBM25m0JoY0hvOtxbne3n9SCdVFSUCf5j2YCJ/
   MmbZ28u8QaFK72a/xJ6HhFw4Dr6ENgAtdxDTDGB7gQQ7ijJ4Kn7py/3f8
   OrdfQVhH1Ahc7R+SEX0bEb0v5qJw1gQb2enxleqXnqIqxyKXsTav/g16Q
   76ufqM2T4gNiACZ86PgoVU0eeE+ImrBlPGPm/ZUfbm0tjxGmSVnWH4cH5
   U4QQpknlCNovR9iz++z3O1uVFDeTPQpQFMKoB9VzDXY5trycqhtpFuZI5
   Q==;
X-CSE-ConnectionGUID: g0HUz1ibRC6uxP2o8szcVw==
X-CSE-MsgGUID: afZ4oEZNS7uPpRuqZBN2sw==
X-IronPort-AV: E=Sophos;i="6.12,191,1728921600"; 
   d="scan'208";a="33615045"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Nov 2024 15:28:01 +0800
IronPort-SDR: 67480e2f_PFQjWliKZeCcA9/8XESAoNtCHjgETl6csA2wFvLIbqEIa/X
 dydb2quqDFpTMLr2fdTQ7dbAj+gTUFNKDNhkGKQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Nov 2024 22:31:12 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Nov 2024 23:28:00 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2] scsi: ufs: core: Do not hold any lock in ufshcd_hba_stop
Date: Thu, 28 Nov 2024 09:25:42 +0200
Message-Id: <20241128072542.219170-1-avri.altman@wdc.com>
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
Changes compared to v1:
 - ensure that interrupts are only re-enabled after the controller has
   been fully disabled (Bart)
---
 drivers/ufs/core/ufshcd.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index acc3607bbd9c..2e4748077275 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4811,20 +4811,14 @@ EXPORT_SYMBOL_GPL(ufshcd_make_hba_operational);
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
-
 	err = ufshcd_wait_for_register(hba, REG_CONTROLLER_ENABLE,
 					CONTROLLER_ENABLE, CONTROLLER_DISABLE,
 					10, 1);
+	ufshcd_enable_irq(hba);
 	if (err)
 		dev_err(hba->dev, "%s: Controller disable failed\n", __func__);
 }
-- 
2.25.1

