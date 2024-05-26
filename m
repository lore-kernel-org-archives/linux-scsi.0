Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2704EBA2E;
	Sun, 26 May 2024 08:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716711434; cv=none; b=HCB5OJCavLKMXuPjMkxRKk70Z5Rbrb6tUkTnUyHwVze5P39M3aa4JSWESIIC0c0KJ8i/4QYV0aL1B0orVPDLnc9TPwlozEwTCgNmtX0G0kxXL5kvM9qEyoS1t1+vHADpGMc1VWtyTArILVfAcOmkfZheeneVwD3/mcVCBFSwJBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716711434; c=relaxed/simple;
	bh=UCC5TS2CQlSaPMDD1x5Ly5A/uK8AolxB07TI54mtakY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlRNOgM7lNpmQy4FfddGo8qlK3mrpdwNzlbqnEVv86ytK97cTeL4zTCTEWIvEFkatDXLX6sqpsvUCz4CFyuQ2xWH73K2MT//jIczMMdYZAAMkvbotDjFDbOB7pFyaGY9pDKvy7inUZyNDyYoJXm9QQld+GqwmNOhU0sI7ZRZNJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=P7d8xiT4; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="P7d8xiT4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1716711433; x=1748247433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UCC5TS2CQlSaPMDD1x5Ly5A/uK8AolxB07TI54mtakY=;
  b=P7d8xiT4SMGFk8yQu56PzXI2zI+seRqOPyJhU02zwW4qr8FmfrjIbFfA
   GfsDZ+b0G/0arSJwU3010Z+u42GNl1LCtjULCTnwib8ES7LkKoT6ZJWUI
   kmPI9DWY9YVIi4msV3AxdcUPs9XkMbia0ugawt/N6/P50/GL4w2UW+O+o
   59ZpW/wRaH1MuU1O1ubr6k9oKRnOkkhwfdzcCC4YSmXNa4B2eG6Moui4r
   LSGN+DlIaKlxNn9OBie/XCWIwYgGagq3ENaFDvHNdT0DVfTx2RnhtCy6a
   p1wjuO6e/sK2gl1F1q/zPxosMOLXIPigY4kTmOanUb1C45HJf7C1Ryav1
   g==;
X-CSE-ConnectionGUID: UOIsl7gJRkG3EUhn/DBzSw==
X-CSE-MsgGUID: Va1GcJyWTEu4onzRUoJfhw==
X-IronPort-AV: E=Sophos;i="6.08,190,1712592000"; 
   d="scan'208";a="17018929"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 May 2024 16:17:13 +0800
IronPort-SDR: 6652e3bc_4K2Tu0apUU0RtwIbbyZ+45DEn7n+GsIO97zfGnZ+YbHmXet
 3ap8J5fKcye8eseZnROU/Q0cfqctwZ2WZepm90A==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 May 2024 00:24:45 -0700
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 May 2024 01:17:10 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v6 2/3] scsi: ufs: Maximum RTT supported by the host driver
Date: Sun, 26 May 2024 11:16:35 +0300
Message-ID: <20240526081636.2064-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240526081636.2064-1-avri.altman@wdc.com>
References: <20240526081636.2064-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow platform vendors to take precedence having their own max rtt
support.  This makes sense because the host controller's nortt
characteristic may vary among vendors.

while at it, set this value for Mediatek, as requested by Peter -
https://lore.kernel.org/all/0a57d6bab739d6a10584f2baba115d00dfc9c94c.camel@mediatek.com/

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c       | 6 +++++-
 drivers/ufs/host/ufs-mediatek.c | 1 +
 drivers/ufs/host/ufs-mediatek.h | 3 +++
 include/ufs/ufshcd.h            | 2 ++
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7df8bcacbe7e..b62023a6c306 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8144,7 +8144,11 @@ static void ufshcd_set_rtt(struct ufs_hba *hba)
 	if (dev_rtt != DEFAULT_MAX_NUM_RTT)
 		return;
 
-	rtt = min_t(int, dev_info->rtt_cap, hba->nortt);
+	if (hba->vops && hba->vops->max_num_rtt)
+		rtt = hba->vops->max_num_rtt;
+	else
+		rtt = min_t(int, dev_info->rtt_cap, hba->nortt);
+
 	if (rtt == dev_rtt)
 		return;
 
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index c4f997196c57..c7a0ab9b1f59 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1785,6 +1785,7 @@ static int ufs_mtk_config_esi(struct ufs_hba *hba)
  */
 static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
 	.name                = "mediatek.ufshci",
+	.max_num_rtt         = MTK_MAX_NUM_RTT,
 	.init                = ufs_mtk_init,
 	.get_ufs_hci_version = ufs_mtk_get_ufs_hci_version,
 	.setup_clocks        = ufs_mtk_setup_clocks,
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 3ff17e95afab..05d76a6bd772 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -189,4 +189,7 @@ struct ufs_mtk_host {
 /* MTK delay of autosuspend: 500 ms */
 #define MTK_RPM_AUTOSUSPEND_DELAY_MS 500
 
+/* MTK RTT support number */
+#define MTK_MAX_NUM_RTT 2
+
 #endif /* !_UFS_MEDIATEK_H */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index d74bd2d67b06..ef04ec8aad69 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -295,6 +295,7 @@ struct ufs_pwr_mode_info {
 /**
  * struct ufs_hba_variant_ops - variant specific callbacks
  * @name: variant name
+ * @max_num_rtt: maximum RTT supported by the host
  * @init: called when the driver is initialized
  * @exit: called to cleanup everything done in init
  * @get_ufs_hci_version: called to get UFS HCI version
@@ -332,6 +333,7 @@ struct ufs_pwr_mode_info {
  */
 struct ufs_hba_variant_ops {
 	const char *name;
+	int	max_num_rtt;
 	int	(*init)(struct ufs_hba *);
 	void    (*exit)(struct ufs_hba *);
 	u32	(*get_ufs_hci_version)(struct ufs_hba *);
-- 
2.34.1

