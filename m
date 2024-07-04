Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E65B1DA32D
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jul 2024 03:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720064321; cv=none; b=S8QQs0NbiiMp/Mz6JTkTU8sdM1OG3Oyxayb3VBOd+mM6SQLX12+lNREodZ3/0xYVTTYScFmdxGIQhrVr1p66FS/uJmgmaJFRsBi74q0ttx3uRv4Y0VMNCvWbjIXdir8XA3Ia+OBPFxM5NDmMiDygIkiCPQQ3diLfvfIoI1wWbKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720064321; c=relaxed/simple;
	bh=zFQ/R91spvIOJqIBkMctwXzedjSsMKFNW9tXi3GWjk4=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=gtrq+ZVIfeGEsNPTH3x0f80t9RvB149qdTHvJ34vYxYMKWTavA7gdmCy3z3Q2motk8RO9JLCXqfoDTf2rLasa8DpOghveX3+UN8yLpt0AjHsi7+BSB/UcR8VrFauZSUA8R82AK5tRjumINU7ywmDbQdq1zOA4VloAWZ9lNb22Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rbPP9rYA; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rbPP9rYA"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240704033830epoutp03a37913d21db717cbc4b33512f5a5b5e4~e5WCDdc8j2151521515epoutp03K
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jul 2024 03:38:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240704033830epoutp03a37913d21db717cbc4b33512f5a5b5e4~e5WCDdc8j2151521515epoutp03K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720064310;
	bh=fgpqWQKxdVf1zHAWmeRAhjw3XqMkSqHGEpj4g3+ddYY=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=rbPP9rYAWwn8zIPb8DSCz/Xp3WM7rQPsNVS8hfzEdfX4hM6OgwKcEe81cICVZlnsO
	 3rKPf5a6uFEHh2ATvasrK5KH2usrjXR/7a367+DCVNnnM0pFpJltGyAjBULs8QYP7c
	 TJVC2fq9zDUm9RXboxrnD9R0VC/ClIZqPo76wHWc=
Received: from epsmges2p3.samsung.com (unknown [182.195.42.71]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20240704033830epcas2p279e7fad1ce2cd6799da8e1bfc7ee72f9~e5WBxyy3z1215912159epcas2p2q;
	Thu,  4 Jul 2024 03:38:30 +0000 (GMT)
X-AuditID: b6c32a47-ecbfa7000000264e-c3-668619352cb8
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	57.40.09806.53916866; Thu,  4 Jul 2024 12:38:29 +0900 (KST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: core: Check LSDBS cap when !mcq
Reply-To: k831.kim@samsung.com
Sender: Kyoungrul Kim <k831.kim@samsung.com>
From: Kyoungrul Kim <k831.kim@samsung.com>
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: Kyoungrul Kim <k831.kim@samsung.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>,
	Minwoo Im <minwoo.im@samsung.com>, SSDR Gost Dev <gost.dev@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240704033829epcms2p818bb2892b4ec9536c85c1a7de925fc73@epcms2p8>
Date: Thu, 04 Jul 2024 12:38:29 +0900
X-CMS-MailID: 20240704033829epcms2p818bb2892b4ec9536c85c1a7de925fc73
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42LZdljTXNdUsi3NYHO/tcW0Dz+ZLW4e2Mlk
	sbGfw2LKpq+MFt3Xd7BZLD/+j8ni2ekDzA7sHpeveHtMm3SKzePj01ssHn1bVjF6fN4kF8Aa
	xWWTkpqTWZZapG+XwJVxtGE5S8EFgYpf90UbGG/wdjFyckgImEj0rNnNAmILCexglLi5L6+L
	kYODV0BQ4u8OYZCwsIC1xNdrd5ghSuQkrs/vZoWI60h0N38Ai7MJaElsPL6RrYuRi0NEYBKj
	xMFbT5lAHGaB24wSvVuOMEEs45WY0f6UBcKWlti+fCsjhK0h8WNZLzOELSpxc/Vbdhj7/bH5
	UDUiEq33zkLVCEo8+LkbKi4l0Tb7N9T8aonJCxZB9dZIrH07Fco2l/h9fzcrxGO+EteOFYGE
	WQRUJXZc+sMKUeIisaD/OVg5s4C8xPa3c5hBypkFNCXW79IHMSUElCWO3GKBqOCT6Dj8lx3m
	qR3znkAdoCTRvu0q1EQJiWcTL0Ad7CHR+201OyQIAyU2r/3LPoFRYRYioGch2TsLYe8CRuZV
	jGKpBcW56anFRgXGesWJucWleel6yfm5mxjBaUXLfQfjjLcf9A4xMnEwHmKU4GBWEuGVet+c
	JsSbklhZlVqUH19UmpNafIhRmoNFSZz3XuvcFCGB9MSS1OzU1ILUIpgsEwenVANTh6zPBBsR
	t0d1+zOzpNd8895iH7o87u07N9cbW1azbDW/blK3+Xjp+/lPn8fxmH09+HeBTIH1wo+TP/57
	+7r3/fQyy4Yi+f4NIh7SSbcu/Qvt3HpLUX7qA3lpnm2ZTztaQw8vPPOIaeOKmJzAB6Hl+/3C
	+XY0CBtICacsPvFo4Q+/csbcdTtFNs0/fiKSvUm3RlJj6SfB+JO1m1e8j0xfcftA46Slu2Ju
	Rmcs9MndvHnKgpBI8YNFUS2S2ZsKrkXkheuzzf31PzJeIaZzQdGRl6kLgt7UzrKaPX+eQ9+i
	ktcCDlmmh3aeYl69Ump94J+vylViTftPz3uwqvCQqHrtuc+pZe/FsqQ+l/PZxf8/r8RSnJFo
	qMVcVJwIAFA/+oiaAwAA
X-CMS-RootMailID: 20240704033829epcms2p818bb2892b4ec9536c85c1a7de925fc73
References: <CGME20240704033829epcms2p818bb2892b4ec9536c85c1a7de925fc73@epcms2p8>

if the user set use_mcq_mode to 0, the host will activate the lsdb mode
unconditionally even when the lsdbs of device hci cap is 0. so it makes
timeout cmds and fail to device probing.

To prevent that problem. check the lsdbs cap when mcq is not supported
case.

Signed-off-by: k831.kim <k831.kim@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 7 +++++++
 include/ufs/ufshcd.h      | 1 +
 include/ufs/ufshci.h      | 1 +
 3 files changed, 9 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1b65e6ae4137..c706645c0914 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2413,6 +2413,7 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 	}
 
 	hba->mcq_sup = FIELD_GET(MASK_MCQ_SUPPORT, hba->capabilities);
+	hba->lsdb_sup = FIELD_GET(MASK_LSDB_SUPPORT, hba->capabilities);
 	if (!hba->mcq_sup)
 		return 0;
 
@@ -10449,6 +10450,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 
 	if (!is_mcq_supported(hba)) {
+		if (!hba->lsdb_sup) {
+			dev_err(hba->dev, "%s: failed to initialize (legacy doorbell mode not supported\n",
+				__func__, hba->lsdb_sup);
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
