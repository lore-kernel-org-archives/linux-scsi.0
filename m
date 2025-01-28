Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1934F383A5;
	Tue, 28 Jan 2025 07:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738048517; cv=none; b=k5MrLggLLP1E0jxrBuX+P0iAubWc+G9MNye66tjDRpKc7g5aEn4IriODumvx1a1Jc92KLf/Y/yghZk9OUJgGiixysuBDsyFaZlagWrway+JsiHUfy7JQvJYh79FHbn8sOeKzycDjJu1+HHjrn45NTfCHK+lrgjVBLlSH/asZ6tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738048517; c=relaxed/simple;
	bh=22B77/5C8o8nOzwznUpCupSYdGdmZMla51C/bjXhSlM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rv0frmh27kNfXRll3mwVXKMfOqRUeQZUHRuFHK1Ck9vLW0ZcwfqSu3X5gVX9gISY9g5e4YJTJJo/FPcrEtQ5JXxANY+dJPf3NQiW8kT0HUmdE/qMfxy5UtIkTU/g8RLl8qEaXo5xtxpVh59M3uA5XJ9T8PtP3akw2y0ZXhZytTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=f0tcq+PH; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="f0tcq+PH"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738048516; x=1769584516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=22B77/5C8o8nOzwznUpCupSYdGdmZMla51C/bjXhSlM=;
  b=f0tcq+PHaKpKNhk/S3yUi76mbTJM7ry2TuUW2QPkQySZT81VUCn/QSZQ
   30v4tDhCckAr1biqFfZmmwaNAkiwdJBs/M+rrFagJ+88hfItnpwB70jw+
   vqXM0CMGmucTT6Sqg49sW8lsE4VbRKy+JOjCcTzWDtegaFnfr2o75Ls8n
   /CB7c+iaMtK5ErLGMoFLgd3Edxi2eSf9ZFHnLnJrWqCjdb0xyodRVBI88
   btD5m6VHtYpgCRmQ+mCzgABn5hYGEW1dTah3N2uQP1PIoB+RkVMRe0gsq
   5/+Xi0d45Wbh0Lg47O6K2tPBdZ/wrdgBQprhny09LPNvSRrB/Ej1zisnh
   Q==;
X-CSE-ConnectionGUID: eXkFnQ8nSAqA0IsQGqyu5Q==
X-CSE-MsgGUID: 0r/wDPLtSzmiw/EBTew0NA==
X-IronPort-AV: E=Sophos;i="6.13,240,1732550400"; 
   d="scan'208";a="36361690"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2025 15:15:15 +0800
IronPort-SDR: 67987664_B971WpBvK0b5JLRDn+UlDNAXGIOk+CxI6h9NkMpYuj/mOzt
 kFkC8nVQoIymu1d9P+wp591NcpnDz+vGtfA7RgQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Jan 2025 22:17:09 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Jan 2025 23:15:13 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Avri Altman <avri.altman@wdc.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v4 2/2] scsi: ufs: Fix toggling of clk_gating.state when clock gating is not allowed
Date: Tue, 28 Jan 2025 09:12:07 +0200
Message-Id: <20250128071207.75494-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250128071207.75494-1-avri.altman@wdc.com>
References: <20250128071207.75494-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit addresses an issue where `clk_gating.state` is being toggled
in `ufshcd_setup_clocks` even if clock gating is not allowed.

The fix is to add a check for `hba->clk_gating.is_initialized` before
toggling `clk_gating.state` in `ufshcd_setup_clocks`.

Since `clk_gating.lock` is now initialized unconditionally, it can no
longer lead to the spinlock being used before it is properly
initialized, but instead it is mostly for documentation purposes.

Fixes: 1ab27c9cf8b6 ("ufs: Add support for clock gating")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b73c87da383d..abe0774133f5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9140,7 +9140,7 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
 			if (!IS_ERR_OR_NULL(clki->clk) && clki->enabled)
 				clk_disable_unprepare(clki->clk);
 		}
-	} else if (!ret && on) {
+	} else if (!ret && on && hba->clk_gating.is_initialized) {
 		scoped_guard(spinlock_irqsave, &hba->clk_gating.lock)
 			hba->clk_gating.state = CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
-- 
2.25.1

