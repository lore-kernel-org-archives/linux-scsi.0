Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5ACBA42
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 05:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720416350; cv=none; b=puL0yWHVyIDjWm0dAiKewqAfWRIbMSNjai6dm+st7OtdGnHhhX4KlzcB9W8Prs4qVV+b6d0nZ7fnclC8zzl0exrOL9aJSAVmmrP/p6kTsdrYcZoLmTUEfpl2BBoXKWHimdgSXmNULAdQcXJ5VIrLubYV6V1UDzlC2mp9oyGDezQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720416350; c=relaxed/simple;
	bh=6vjUqy0D75X/JgEE/L41ndV3MLqfffvp6wFALR8HmtI=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=mUQsxFtUFlrVXtBReQJMDWjaFNH5kU9AXE59jNcdf6RXj6N/sGNVCPHQB623rzzF0/Xo7rJNNfsPBIzxharCDXH9exElnKzJiyE/O5MBkhGZ7/WLWjXUN+OrkaESxAy+Gc70dvOtAEaJeGEcH/pCn3ESJupshHHbWGWBfi0QSC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NOjLIJDs; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NOjLIJDs"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240708052542epoutp031be9983deb12a43a07ab95d24273008d~gJYx7qOUn0362303623epoutp033
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 05:25:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240708052542epoutp031be9983deb12a43a07ab95d24273008d~gJYx7qOUn0362303623epoutp033
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720416342;
	bh=Gbi+MBc6CGzGAupZYXo4Iit+yJfDAtrJpzlTdPmXXoI=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=NOjLIJDs2kNvsLgAvr6dbbSV/RJSG3yH9trrqCwlP6+gP0o5NtlZ9UdsjaF6bf2s8
	 poWtQC/l5iiNqi4yVS2xM5gSnKXzvqkAnLuChl1f8xaFTKFmU2x7Wu7J8iByEpUH5r
	 oxmebv/7/iSUG7AkbX+G9zcyfO6YZBB8ztvxVYPQ=
Received: from epsmges2p4.samsung.com (unknown [182.195.42.72]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20240708052542epcas2p4d48414db49645923973ab98b17a85886~gJYxsAdBR1573815738epcas2p4m;
	Mon,  8 Jul 2024 05:25:42 +0000 (GMT)
X-AuditID: b6c32a48-e67eda8000018d5f-4b-668b7856f5e8
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
	epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	19.1B.36191.6587B866; Mon,  8 Jul 2024 14:25:42 +0900 (KST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH V3] scsi: ufs: core: Check LSDBS cap when !mcq
Reply-To: k831.kim@samsung.com
Sender: Kyoungrul Kim <k831.kim@samsung.com>
From: Kyoungrul Kim <k831.kim@samsung.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "bvanassche@acm.org" <bvanassche@acm.org>, "Ed.Tsai@mediatek.com"
	<Ed.Tsai@mediatek.com>, Minwoo Im <minwoo.im@samsung.com>, Kyoungrul Kim
	<k831.kim@samsung.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240708052542epcms2p5358e41c0116c936d2a43ad99f7c1e4a8@epcms2p5>
Date: Mon, 08 Jul 2024 14:25:42 +0900
X-CMS-MailID: 20240708052542epcms2p5358e41c0116c936d2a43ad99f7c1e4a8
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42LZdljTXDesojvNYM9fZYtpH34yW+xZb2ex
	sZ/DYsqmr4wW3dd3sFksP/6PyeLZ6QPMDuwel694e0ybdIrNo+XkfhaPj09vsXj0bVnF6PF5
	k1wAWxSXTUpqTmZZapG+XQJXxqvdUxgL1ohULJm7ja2Bcb9AFyMnh4SAicSln9cZQWwhgR2M
	Eju/2HUxcnDwCghK/N0hDBIWFrCTWPzpLzNEiZzE9fndrBBxHYnu5g9gcTYBLYmNxzeydTFy
	cYgITGKU+P/9JQuIwyzwjFHi0ZRHbBDLeCVmtD9lgbClJbYv38oIYWtI/FjWywxhi0rcXP2W
	HcZ+f2w+VI2IROu9s1A1ghIPfu6GiktJtM3+zQRhV0tcbdwNtlhCoINRoqX1IStEwlxi5epL
	YA28Ar4Spx8dB4uzCKhKHJu9hx3kYwkBF4lvByVBwswC8hLb385hBgkzC2hKrN+lD1GhLHHk
	FgtEBZ9Ex+G/7DBf7Zj3BOoCJYn2bVehlkpIPJt4AepiD4mDv86xQsIwUKK9dRfzBEaFWYiQ
	noVk7yyEvQsYmVcxiqUWFOempxYbFZjoFSfmFpfmpesl5+duYgSnGC2PHYyz337QO8TIxMF4
	iFGCg1lJhPf04/Y0Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rz3WuemCAmkJ5akZqemFqQWwWSZ
	ODilGphmBC0QfnRR6FwBy/MjrKcnNS12f3a1zTrc6qeW991Qq9CZ+2oe3ZRZp7V2epiLX2ST
	I1/S1xPT0j8IPXK0WlEx+Ze150zu1JP6b9bM48xdurlyO3+hkLNh64faTA2FzR7RK9YfMmnK
	f758tvHrVyx9moGnRVg78tOn3hAoiksM//31VlyRoJ2K4bNqjlinRYrXvI0lnmilMZ5SiTfb
	x3pnhviVK9xuGQyTHT7ZVt+OL7nCqLGlmcM/brbDqk+O/yIOWkjuXaMjxbYv9dOsK1vbvjza
	7Bq8/0lxexT3j+ofC+sMBGUKBZ4cmvT54eZHRTc6n2ssMz0bOXXBwm1fV3vtPxl4Rd313f78
	Y0d3rn+hxFKckWioxVxUnAgAw4TlvqADAAA=
X-CMS-RootMailID: 20240708052542epcms2p5358e41c0116c936d2a43ad99f7c1e4a8
References: <CGME20240708052542epcms2p5358e41c0116c936d2a43ad99f7c1e4a8@epcms2p5>

if the user set use_mcq_mode to 0, the host will try to activate the
lsdb mode unconditionally even when the lsdbs of device hci cap is 1. so
it makes timeout cmds and fail to device probing.

To prevent that problem. check the lsdbs cap when mcq is not supported
case.

Signed-off-by: k831.kim <k831.kim@samsung.com>
---
Changes to v1: Fix wrong bit of lsdb support.
Changes to v2: Fix extra space and wrong commit messeage.
---
 drivers/ufs/core/ufshcd.c | 16 ++++++++++++++++
 include/ufs/ufshcd.h      |  1 +
 include/ufs/ufshci.h      |  1 +
 3 files changed, 18 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1b65e6ae4137..9bea6dc38d64 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2412,7 +2412,17 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 		return err;
 	}
 
+	/*
+	 * UFS 3.0 has no MCQ_SUPPORT and LSDB_SUPPORT, but [31:29] as reserved
+	 * bits with reset value 0s, which means we can simply read values
+	 * regardless to version
+	 */
 	hba->mcq_sup = FIELD_GET(MASK_MCQ_SUPPORT, hba->capabilities);
+	/*
+	 * 0h: legacy single doorbell support is available
+	 * 1h: indicate that legacy single doorbell support have been removed
+	 */
+	hba->lsdb_sup = !FIELD_GET(MASK_LSDB_SUPPORT, hba->capabilities);
 	if (!hba->mcq_sup)
 		return 0;
 
@@ -10449,6 +10459,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 
 	if (!is_mcq_supported(hba)) {
+		if (!hba->lsdb_sup) {
+			dev_err(hba->dev, "%s: failed to initialize (legacy doorbell mode not supported\n",
+				__func__);
+			err = -EINVAL;
+			goto out_disable;
+		}
 		err = scsi_add_host(host, hba->dev);
 		if (err) {
 			dev_err(hba->dev, "scsi_add_host failed\n");
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index bad88bd91995..fd391f6eee73 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1074,6 +1074,7 @@ struct ufs_hba {
 	bool ext_iid_sup;
 	bool scsi_host_added;
 	bool mcq_sup;
+	bool lsdb_sup;
 	bool mcq_enabled;
 	struct ufshcd_res_info res[RES_MAX];
 	void __iomem *mcq_base;
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 385e1c6b8d60..22ba85e81d8c 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -75,6 +75,7 @@ enum {
 	MASK_OUT_OF_ORDER_DATA_DELIVERY_SUPPORT	= 0x02000000,
 	MASK_UIC_DME_TEST_MODE_SUPPORT		= 0x04000000,
 	MASK_CRYPTO_SUPPORT			= 0x10000000,
+	MASK_LSDB_SUPPORT			= 0x20000000,
 	MASK_MCQ_SUPPORT			= 0x40000000,
 };
 
-- 
2.34.1
