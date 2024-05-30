Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D63817D8B3;
	Thu, 30 May 2024 14:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717079132; cv=none; b=hDX2DaS/qbRLs6XZfTB+OvAl2VmIKIwu2WE32w5SWgZxt/+vO9xk5gBFvVh4+MWym9hE7ioZpUqBMVLJ+v2ceZQwZhbu03xtOxnigDP8sSzPTfPKOzBz7fLm6R4kCKwut526OIqDYunCSBe9N5ZIDHRLJx/5mQNwGvP1KUq5yNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717079132; c=relaxed/simple;
	bh=jLpvsRdj6MFssffe0kGVr3EfO+1vX9Uwo/mP6AmpF74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4PYS5rM+rXk4Lne5y3u55MLBPGCYbfUvquLaj8pTymMmAE8Ajj9Ee1YrEpXVuFrddfJWfcrLXLqpgeK31NS880fzZFo3iljnmrcrYyRIMTmF++AAK5mYMcAjUGFuG770tmLxFScsicsoDcfTqDYdl6BMVDDv7soIJgQjwiEuqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Be2n5Pib; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Be2n5Pib"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1717079130; x=1748615130;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jLpvsRdj6MFssffe0kGVr3EfO+1vX9Uwo/mP6AmpF74=;
  b=Be2n5Pib87ypZdMod6TbqO0NT+mw6owLOFn9BEJBhEPgvOD6EbMLi4oW
   LvJedSrmSvmUzry3YyI64WNW76qrClIKRhg2BvfNFFbZ9d7t+wSZvYeMP
   lG73wOzfK/BhXJryr2zTmVEQBgsl8L7g3mlmWipxtr7B3UXPjTAgGTeBx
   RJRq1Kb/+xcbpOLZwwDmefQSespQwxQkzOmRizT3fmJO+2he7+LhB+BFo
   CXIgeet8cZtoAmFFN47F9S+9kfndyZB+1CxSOt+H3ly47l58wW2wSoCiF
   3vm2zx4+EsCpkGzhdsmf40icNVgJwuDmGwAA//Ws5FL6JHFknGM4sfnvP
   Q==;
X-CSE-ConnectionGUID: xCcKWqpAS0yxH9k4zDdl6Q==
X-CSE-MsgGUID: 7q9I2+qbTwOGbX09si9ZCw==
X-IronPort-AV: E=Sophos;i="6.08,201,1712592000"; 
   d="scan'208";a="17923534"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 May 2024 22:25:25 +0800
IronPort-SDR: 66587eaf_kJVo94h44/miQr20I/Av+bxm5tBwMMMueIVl/Evuo48HanL
 s67xCKdUR1/64B/1mfwvuneEk924v+6Lrf81R7w==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 May 2024 06:27:12 -0700
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip01.wdc.com with ESMTP; 30 May 2024 07:25:24 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v7 2/3] scsi: ufs: Maximum RTT supported by the host driver
Date: Thu, 30 May 2024 17:25:08 +0300
Message-ID: <20240530142510.734-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240530142510.734-1-avri.altman@wdc.com>
References: <20240530142510.734-1-avri.altman@wdc.com>
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
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c       | 5 ++++-
 drivers/ufs/host/ufs-mediatek.c | 1 +
 drivers/ufs/host/ufs-mediatek.h | 3 +++
 include/ufs/ufshcd.h            | 2 ++
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index dda6d7e44436..41bf2e249c83 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8131,6 +8131,8 @@ static void ufshcd_set_rtt(struct ufs_hba *hba)
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 	u32 rtt = 0;
 	u32 dev_rtt = 0;
+	int host_rtt_cap = hba->vops && hba->vops->max_num_rtt ?
+			   hba->vops->max_num_rtt : hba->nortt;
 
 	/* RTT override makes sense only for UFS-4.0 and above */
 	if (dev_info->wspecversion < 0x400)
@@ -8146,7 +8148,8 @@ static void ufshcd_set_rtt(struct ufs_hba *hba)
 	if (dev_rtt != DEFAULT_MAX_NUM_RTT)
 		return;
 
-	rtt = min_t(int, dev_info->rtt_cap, hba->nortt);
+	rtt = min_t(int, dev_info->rtt_cap, host_rtt_cap);
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

