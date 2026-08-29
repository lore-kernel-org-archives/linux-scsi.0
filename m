Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26252D061C;
	Sat, 29 Aug 2026 03:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787974152; cv=none; b=KWEGoUmxMSl+jRZ+wUrJsgUhcl+nNqrG6/36Nxuet7DpUfF3Sg1qdu4EmWCbHro2DntKjfdTysSNY3AOiKsKSI2GewFcVPqtZukEtghPHNAbVZ+WdlxlpkmUEvsVKr5dp9pDM8ajRIvujgxoUtPEFL4p3MTGTDLbFHNGVoBWcW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787974152; c=relaxed/simple;
	bh=lMDwF+yr2VDWG7d4gs3GlZUe+JEKD7ruQ0qjtD1ZIXo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HCyECdDUBB80uaLvccQz1KVb3SliVzUdZf+yZnGAPvAm7Gz00wmNHKz4GCddMLprwM3hpmq/8a05s3sjJQfKFn4hTuDOUCxBsAq2b9X4G9AQoyZ+N0To+lSSyFx46aVKhNw3QnPU37VuzxOOA19Uvxw++Xk67QKtNgKErhh3jDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=J51Xqp/P; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="J51Xqp/P"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XwQQGQxtP61fZI1yedoObdWmGXJkHPxE164vzjRl86w=;
	b=J51Xqp/PnUJbmd2tQr2WtmzkvccXid6qAFUw12Qwwa7xQ17oyxZYam25zmGxjxRXzqP/NBLvf
	8P0/IbxniGafnzYaiowLJYJshStpGDDAQTBlvz8e74rnv0R5RNQCawcveiCRIxZuKx52fTev0AO
	2rErtSWJ3LOvJl8sItIgDqU=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hX0ng0cchzRhR0;
	Sat, 29 Aug 2026 11:18:15 +0800 (CST)
Received: from kwepemp100001.china.huawei.com (unknown [7.202.195.79])
	by mail.maildlp.com (Postfix) with ESMTPS id 63CD340575;
	Sat, 29 Aug 2026 11:29:00 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp100001.china.huawei.com (7.202.195.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 29 Aug 2026 11:29:00 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 29 Aug 2026 11:28:59 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<john.g.garry@oracle.com>, <yanaijie@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH 2/3] scsi: hisi_sas: Clear PHY error counts on phyup
Date: Sat, 29 Aug 2026 11:28:57 +0800
Message-ID: <20260829032858.1661019-3-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260829032858.1661019-1-yangxingui@huawei.com>
References: <20260829032858.1661019-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemp500015.china.huawei.com (7.202.195.9)

Some disks may generate link errors during link establishment but still phy
up successfully. These intermediate error counts are not cleared after
phyup, leaving stale data for error detection. Clear them on phyup and only
print non-zero error counts to reduce log noise.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 30 +++++++++++++++++++-------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index dcb1c65113de..0cdf72f3dde9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1061,6 +1061,19 @@ static void enable_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
 }
 
+static void clear_phy_err_cnt_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	static const u32 msk = BIT(CHL_INT2_RX_DISP_ERR_OFF) |
+			       BIT(CHL_INT2_RX_CODE_ERR_OFF) |
+			       BIT(CHL_INT2_RX_INVLD_DW_OFF);
+
+	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_INVLD_DW);
+	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_DISP_ERR);
+	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_CODE_ERR);
+
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2, msk);
+}
+
 static void disable_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
@@ -1085,11 +1098,7 @@ static void disable_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 
 	udelay(1);
 
-	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_INVLD_DW);
-	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_DISP_ERR);
-	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_CODE_ERR);
-
-	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2, msk);
+	clear_phy_err_cnt_v3_hw(hisi_hba, phy_no);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2_MSK, irq_msk);
 }
 
@@ -1673,6 +1682,8 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 	phy->phy_attached = 1;
 	spin_unlock(&phy->lock);
 
+	clear_phy_err_cnt_v3_hw(hisi_hba, phy_no);
+
 	/*
 	 * Call pm_runtime_get_noresume() which pairs with
 	 * hisi_sas_phyup_pm_work() -> pm_runtime_put_sync().
@@ -1926,15 +1937,18 @@ static void handle_chl_int2_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 
 		phy_get_events_v3_hw(hisi_hba, phy_no);
 
-		if (irq_value & BIT(CHL_INT2_RX_INVLD_DW_OFF))
+		if ((irq_value & BIT(CHL_INT2_RX_INVLD_DW_OFF)) &&
+		    sphy->invalid_dword_count > 0)
 			dev_info(dev, "phy%d invalid dword cnt:   %u\n", phy_no,
 				 sphy->invalid_dword_count);
 
-		if (irq_value & BIT(CHL_INT2_RX_CODE_ERR_OFF))
+		if ((irq_value & BIT(CHL_INT2_RX_CODE_ERR_OFF)) &&
+		    phy->code_violation_err_count > 0)
 			dev_info(dev, "phy%d code violation cnt:  %u\n", phy_no,
 				 phy->code_violation_err_count);
 
-		if (irq_value & BIT(CHL_INT2_RX_DISP_ERR_OFF))
+		if ((irq_value & BIT(CHL_INT2_RX_DISP_ERR_OFF)) &&
+		    sphy->running_disparity_error_count > 0)
 			dev_info(dev, "phy%d disparity error cnt: %u\n", phy_no,
 				 sphy->running_disparity_error_count);
 	}
-- 
2.43.0

